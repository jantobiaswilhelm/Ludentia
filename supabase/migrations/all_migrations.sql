-- =============================================================================
-- Ludentia — All Migrations (001–030) combined
-- Run this single file in Supabase SQL Editor to set up the entire database.
-- =============================================================================

-- ─── 001: Profiles ──────────────────────────────────────────────────────────
create table if not exists profiles (
  id uuid primary key references auth.users on delete cascade,
  username text unique not null,
  display_name text,
  avatar_url text,
  favorite_genres text[] default '{}',
  profile_visibility text not null default 'public'
    check (profile_visibility in ('public','friends_only','private')),
  diary_visibility text not null default 'public'
    check (diary_visibility in ('public','friends_only','private')),
  preferred_log_mode text not null default 'all_in_one'
    check (preferred_log_mode in ('all_in_one','step_by_step')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, username, display_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1)),
    coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1))
  );
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

alter table profiles enable row level security;

DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON profiles;
create policy "Public profiles are viewable by everyone"
  on profiles for select using (profile_visibility = 'public');

DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
create policy "Users can view own profile"
  on profiles for select using (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
create policy "Users can update own profile"
  on profiles for update using (auth.uid() = id);

-- ─── 002: Books & Editions ──────────────────────────────────────────────────
create table if not exists books (
  id uuid primary key default gen_random_uuid(),
  google_books_id text unique,
  open_library_key text,
  title text not null,
  authors text[] default '{}',
  description text default '',
  categories text[] default '{}',
  page_count integer,
  published_date text,
  cover_url text default '',
  cover_url_large text default '',
  google_average_rating real,
  google_ratings_count integer default 0,
  language text default '',
  cached_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_books_google_id on books(google_books_id);

create table if not exists book_editions (
  id uuid primary key default gen_random_uuid(),
  book_id uuid not null references books on delete cascade,
  google_books_id text unique,
  open_library_key text,
  isbn_10 text,
  isbn_13 text,
  format text check (format in ('hardcover','paperback','ebook','audiobook','other')),
  publisher text,
  edition_name text,
  cover_url text,
  page_count integer,
  cached_at timestamptz not null default now()
);

alter table books enable row level security;
alter table book_editions enable row level security;

DROP POLICY IF EXISTS "Books are viewable by everyone" ON books;
create policy "Books are viewable by everyone" on books for select using (true);
DROP POLICY IF EXISTS "Authenticated users can insert books" ON books;
create policy "Authenticated users can insert books" on books for insert with check (auth.role() = 'authenticated');
DROP POLICY IF EXISTS "Authenticated users can update books" ON books;
create policy "Authenticated users can update books" on books for update using (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Editions viewable by everyone" ON book_editions;
create policy "Editions viewable by everyone" on book_editions for select using (true);
DROP POLICY IF EXISTS "Authenticated users can insert editions" ON book_editions;
create policy "Authenticated users can insert editions" on book_editions for insert with check (auth.role() = 'authenticated');

-- ─── 003: Bookshelves ───────────────────────────────────────────────────────
create table if not exists user_bookshelves (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles on delete cascade,
  book_id uuid not null references books on delete cascade,
  edition_id uuid references book_editions on delete set null,
  shelf text not null check (shelf in ('want_to_read','reading','read')),
  added_at timestamptz not null default now(),
  finished_at timestamptz,
  unique(user_id, book_id)
);

create index if not exists idx_bookshelves_user on user_bookshelves(user_id);
create index if not exists idx_bookshelves_book on user_bookshelves(book_id);

alter table user_bookshelves enable row level security;

DROP POLICY IF EXISTS "Users can view own shelves" ON user_bookshelves;
create policy "Users can view own shelves"
  on user_bookshelves for select using (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can manage own shelves" ON user_bookshelves;
create policy "Users can manage own shelves"
  on user_bookshelves for insert with check (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own shelves" ON user_bookshelves;
create policy "Users can update own shelves"
  on user_bookshelves for update using (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own shelf entries" ON user_bookshelves;
create policy "Users can delete own shelf entries"
  on user_bookshelves for delete using (auth.uid() = user_id);

DROP POLICY IF EXISTS "Public shelves viewable" ON user_bookshelves;
create policy "Public shelves viewable"
  on user_bookshelves for select using (
    exists (
      select 1 from profiles
      where profiles.id = user_bookshelves.user_id
      and profiles.profile_visibility = 'public'
    )
  );

-- ─── 004: Reading Progress ──────────────────────────────────────────────────
create table if not exists reading_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles on delete cascade,
  book_id uuid not null references books on delete cascade,
  current_page integer default 0,
  total_pages integer,
  percentage real default 0,
  mood_tags text[] default '{}',
  updated_at timestamptz not null default now(),
  unique(user_id, book_id)
);

alter table reading_progress enable row level security;

DROP POLICY IF EXISTS "Users can view own progress" ON reading_progress;
create policy "Users can view own progress"
  on reading_progress for select using (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can manage own progress" ON reading_progress;
create policy "Users can manage own progress"
  on reading_progress for insert with check (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own progress" ON reading_progress;
create policy "Users can update own progress"
  on reading_progress for update using (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own progress" ON reading_progress;
create policy "Users can delete own progress"
  on reading_progress for delete using (auth.uid() = user_id);

-- ─── 005: Diary Entries ─────────────────────────────────────────────────────
create table if not exists diary_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles on delete cascade,
  book_id uuid not null references books on delete cascade,
  entry_text text not null,
  page_at integer,
  is_spoiler boolean not null default false,
  visibility text not null default 'public'
    check (visibility in ('public','friends_only','private')),
  created_at timestamptz not null default now()
);

create index if not exists idx_diary_user on diary_entries(user_id);
create index if not exists idx_diary_book on diary_entries(book_id);
create index if not exists idx_diary_created on diary_entries(created_at desc);

alter table diary_entries enable row level security;

DROP POLICY IF EXISTS "Users can view own diary" ON diary_entries;
create policy "Users can view own diary"
  on diary_entries for select using (auth.uid() = user_id);

DROP POLICY IF EXISTS "Public diary entries viewable" ON diary_entries;
create policy "Public diary entries viewable"
  on diary_entries for select using (visibility = 'public');

DROP POLICY IF EXISTS "Users can insert diary entries" ON diary_entries;
create policy "Users can insert diary entries"
  on diary_entries for insert with check (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own diary entries" ON diary_entries;
create policy "Users can update own diary entries"
  on diary_entries for update using (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own diary entries" ON diary_entries;
create policy "Users can delete own diary entries"
  on diary_entries for delete using (auth.uid() = user_id);

-- ─── 006: Book Logs ─────────────────────────────────────────────────────────
create table if not exists book_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles on delete cascade,
  book_id uuid not null references books on delete cascade,
  edition_id uuid references book_editions on delete set null,
  rating integer check (rating >= 1 and rating <= 10),
  review_text text,
  date_started date,
  date_finished date default current_date,
  is_reread boolean not null default false,
  reread_number integer,
  contains_spoilers boolean not null default false,
  visibility text not null default 'public'
    check (visibility in ('public','friends_only','private')),
  created_at timestamptz not null default now()
);

create index if not exists idx_logs_user on book_logs(user_id);
create index if not exists idx_logs_book on book_logs(book_id);
create index if not exists idx_logs_rating on book_logs(rating);

alter table book_logs enable row level security;

DROP POLICY IF EXISTS "Users can view own logs" ON book_logs;
create policy "Users can view own logs"
  on book_logs for select using (auth.uid() = user_id);

DROP POLICY IF EXISTS "Public logs viewable" ON book_logs;
create policy "Public logs viewable"
  on book_logs for select using (visibility = 'public');

DROP POLICY IF EXISTS "Users can insert logs" ON book_logs;
create policy "Users can insert logs"
  on book_logs for insert with check (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own logs" ON book_logs;
create policy "Users can update own logs"
  on book_logs for update using (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own logs" ON book_logs;
create policy "Users can delete own logs"
  on book_logs for delete using (auth.uid() = user_id);

create or replace view book_rating_stats as
select
  book_id,
  count(*) as rating_count,
  round(avg(rating)::numeric, 1) as avg_rating,
  count(*) filter (where rating = 1) as r1,
  count(*) filter (where rating = 2) as r2,
  count(*) filter (where rating = 3) as r3,
  count(*) filter (where rating = 4) as r4,
  count(*) filter (where rating = 5) as r5,
  count(*) filter (where rating = 6) as r6,
  count(*) filter (where rating = 7) as r7,
  count(*) filter (where rating = 8) as r8,
  count(*) filter (where rating = 9) as r9,
  count(*) filter (where rating = 10) as r10
from book_logs
where rating is not null
group by book_id;

-- ─── 007: Follows ───────────────────────────────────────────────────────────
create table if not exists follows (
  id uuid primary key default gen_random_uuid(),
  follower_id uuid not null references profiles on delete cascade,
  following_id uuid not null references profiles on delete cascade,
  created_at timestamptz not null default now(),
  unique(follower_id, following_id),
  check (follower_id != following_id)
);

create index if not exists idx_follows_follower on follows(follower_id);
create index if not exists idx_follows_following on follows(following_id);

alter table follows enable row level security;

DROP POLICY IF EXISTS "Anyone can view follows" ON follows;
create policy "Anyone can view follows"
  on follows for select using (true);

DROP POLICY IF EXISTS "Users can follow others" ON follows;
create policy "Users can follow others"
  on follows for insert with check (auth.uid() = follower_id);

DROP POLICY IF EXISTS "Users can unfollow" ON follows;
create policy "Users can unfollow"
  on follows for delete using (auth.uid() = follower_id);

-- ─── 008: Tags ──────────────────────────────────────────────────────────────
create table if not exists tag_definitions (
  id uuid primary key default gen_random_uuid(),
  label text not null,
  slug text unique not null,
  description text,
  color text default 'gray',
  category text,
  is_official boolean not null default false,
  created_by uuid references profiles on delete set null,
  sort_order integer default 0,
  created_at timestamptz not null default now()
);

create index if not exists idx_tags_slug on tag_definitions(slug);
create index if not exists idx_tags_category on tag_definitions(category);

create table if not exists tag_votes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles on delete cascade,
  book_id uuid not null references books on delete cascade,
  tag_id uuid not null references tag_definitions on delete cascade,
  voted_at timestamptz not null default now(),
  unique(user_id, book_id, tag_id)
);

create index if not exists idx_votes_book on tag_votes(book_id);
create index if not exists idx_votes_tag on tag_votes(tag_id);

create materialized view if not exists book_tag_counts as
select
  book_id,
  tag_id,
  count(*) as vote_count
from tag_votes
group by book_id, tag_id;

create unique index if not exists idx_btc_book_tag on book_tag_counts(book_id, tag_id);

alter table tag_definitions enable row level security;
alter table tag_votes enable row level security;

DROP POLICY IF EXISTS "Tags viewable by everyone" ON tag_definitions;
create policy "Tags viewable by everyone" on tag_definitions for select using (true);
DROP POLICY IF EXISTS "Authenticated users can create tags" ON tag_definitions;
create policy "Authenticated users can create tags" on tag_definitions for insert with check (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Votes viewable by everyone" ON tag_votes;
create policy "Votes viewable by everyone" on tag_votes for select using (true);
DROP POLICY IF EXISTS "Users can vote" ON tag_votes;
create policy "Users can vote" on tag_votes for insert with check (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can remove own votes" ON tag_votes;
create policy "Users can remove own votes" on tag_votes for delete using (auth.uid() = user_id);

-- ─── 009: Seed Official Tags (37 + 15 Themes) ──────────────────────────────
insert into tag_definitions (label, slug, category, color, is_official, sort_order) values
  -- Pacing (4)
  ('Slow Burn', 'slow-burn', 'Pacing', 'orange', true, 1),
  ('Moderate', 'moderate-pace', 'Pacing', 'orange', true, 2),
  ('Fast-Paced', 'fast-paced', 'Pacing', 'orange', true, 3),
  ('Uneven', 'uneven-pace', 'Pacing', 'orange', true, 4),
  -- Mood (8)
  ('Dark', 'dark', 'Mood', 'purple', true, 10),
  ('Lighthearted', 'lighthearted', 'Mood', 'yellow', true, 11),
  ('Emotional', 'emotional', 'Mood', 'pink', true, 12),
  ('Tense', 'tense', 'Mood', 'red', true, 13),
  ('Hopeful', 'hopeful', 'Mood', 'green', true, 14),
  ('Funny', 'funny', 'Mood', 'yellow', true, 15),
  ('Melancholy', 'melancholy', 'Mood', 'blue', true, 16),
  ('Cozy', 'cozy', 'Mood', 'brown', true, 17),
  -- Story Focus (5)
  ('Plot-Driven', 'plot-driven', 'Story Focus', 'blue', true, 20),
  ('Character-Driven', 'character-driven', 'Story Focus', 'blue', true, 21),
  ('World-Building', 'world-building', 'Story Focus', 'blue', true, 22),
  ('Idea-Driven', 'idea-driven', 'Story Focus', 'blue', true, 23),
  ('Relationship-Focused', 'relationship-focused', 'Story Focus', 'blue', true, 24),
  -- Ending (6)
  ('Happy Ending', 'happy-ending', 'Ending', 'green', true, 30),
  ('Sad Ending', 'sad-ending', 'Ending', 'red', true, 31),
  ('Open Ending', 'open-ending', 'Ending', 'gray', true, 32),
  ('Twist Ending', 'twist-ending', 'Ending', 'purple', true, 33),
  ('Bittersweet', 'bittersweet', 'Ending', 'pink', true, 34),
  ('Cliffhanger', 'cliffhanger', 'Ending', 'orange', true, 35),
  -- Difficulty (4)
  ('Easy Read', 'easy-read', 'Difficulty', 'green', true, 40),
  ('Moderate Read', 'moderate-read', 'Difficulty', 'yellow', true, 41),
  ('Challenging', 'challenging', 'Difficulty', 'orange', true, 42),
  ('Literary', 'literary', 'Difficulty', 'red', true, 43),
  -- Content Warnings (5)
  ('Graphic Violence', 'graphic-violence', 'Content Warnings', 'red', true, 50),
  ('Sexual Content', 'sexual-content', 'Content Warnings', 'red', true, 51),
  ('Mental Health', 'mental-health', 'Content Warnings', 'red', true, 52),
  ('Substance Abuse', 'substance-abuse', 'Content Warnings', 'red', true, 53),
  ('Grief/Loss', 'grief-loss', 'Content Warnings', 'red', true, 54),
  -- Rereadability (3)
  ('Highly Rereadable', 'highly-rereadable', 'Rereadability', 'green', true, 60),
  ('One and Done', 'one-and-done', 'Rereadability', 'gray', true, 61),
  ('Better on Reread', 'better-on-reread', 'Rereadability', 'blue', true, 62),
  -- Series (4)
  ('Great Standalone', 'great-standalone', 'Series', 'green', true, 70),
  ('Must Read in Order', 'must-read-in-order', 'Series', 'orange', true, 71),
  ('Series Gets Better', 'series-gets-better', 'Series', 'blue', true, 72),
  ('Strong Opener', 'strong-opener', 'Series', 'purple', true, 73),
  -- Themes/Tropes (15)
  ('Enemies to Lovers', 'enemies-to-lovers', 'Themes', 'pink', true, 100),
  ('Found Family', 'found-family', 'Themes', 'green', true, 101),
  ('Unreliable Narrator', 'unreliable-narrator', 'Themes', 'purple', true, 102),
  ('Redemption Arc', 'redemption-arc', 'Themes', 'blue', true, 103),
  ('Coming of Age', 'coming-of-age', 'Themes', 'yellow', true, 104),
  ('Fish Out of Water', 'fish-out-of-water', 'Themes', 'orange', true, 105),
  ('Quest/Journey', 'quest-journey', 'Themes', 'brown', true, 106),
  ('Forbidden Love', 'forbidden-love', 'Themes', 'pink', true, 107),
  ('Revenge', 'revenge', 'Themes', 'red', true, 108),
  ('Identity/Self-Discovery', 'identity-self-discovery', 'Themes', 'blue', true, 109),
  ('Time Loop', 'time-loop', 'Themes', 'purple', true, 110),
  ('Morally Gray Characters', 'morally-gray-characters', 'Themes', 'gray', true, 111),
  ('Chosen One', 'chosen-one', 'Themes', 'orange', true, 112),
  ('Secrets & Lies', 'secrets-and-lies', 'Themes', 'red', true, 113),
  ('Survival', 'survival', 'Themes', 'brown', true, 114)
on conflict (slug) do nothing;

-- ─── 010: Recommendations ───────────────────────────────────────────────────
create or replace function get_recommendations(p_user_id uuid, p_limit integer default 20)
returns table (
  book_id uuid,
  score bigint,
  reason text
) as $$
begin
  return query
  with user_rated_books as (
    select bl.book_id, bl.rating
    from book_logs bl
    where bl.user_id = p_user_id
  ),
  user_tags as (
    select tv.tag_id, td.category
    from tag_votes tv
    join tag_definitions td on td.id = tv.tag_id
    where tv.user_id = p_user_id
  ),
  user_fav_authors as (
    select unnest(b.authors) as author
    from book_logs bl
    join books b on b.id = bl.book_id
    where bl.user_id = p_user_id and bl.rating >= 9
  ),
  candidate_books as (
    select b.id as book_id
    from books b
    where b.id not in (select urb.book_id from user_rated_books urb)
      and b.id not in (select ubs.book_id from user_bookshelves ubs where ubs.user_id = p_user_id)
  ),
  scored as (
    select
      cb.book_id,
      coalesce((
        select count(distinct td.category) * 3
        from tag_votes tv
        join tag_definitions td on td.id = tv.tag_id
        where tv.book_id = cb.book_id
          and td.category in (select ut.category from user_tags ut)
      ), 0)
      + coalesce((
        select count(*) * 2
        from tag_votes tv
        where tv.book_id = cb.book_id
          and tv.tag_id in (select ut.tag_id from user_tags ut)
      ), 0)
      + case when exists (
        select 1 from books b
        where b.id = cb.book_id
          and b.authors && (select array_agg(author) from user_fav_authors)
      ) then 5 else 0 end
      + case when exists (
        select 1 from book_rating_stats brs
        where brs.book_id = cb.book_id
          and brs.avg_rating >= 7.5
          and brs.rating_count >= 3
      ) then 2 else 0 end
      as score
    from candidate_books cb
  )
  select s.book_id, s.score, 'recommended'::text as reason
  from scored s
  where s.score > 0
  order by s.score desc
  limit p_limit;
end;
$$ language plpgsql stable;

-- ─── 011: Open Library Unique Constraint ────────────────────────────────────
DO $$ BEGIN
  ALTER TABLE books ADD CONSTRAINT books_open_library_key_unique UNIQUE (open_library_key);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- ─── 012: Refresh Tag Counts ────────────────────────────────────────────────
create or replace function refresh_book_tag_counts()
returns trigger as $$
begin
  refresh materialized view concurrently book_tag_counts;
  return null;
end;
$$ language plpgsql security definer;

drop trigger if exists trg_tag_votes_insert_refresh on tag_votes;
create trigger trg_tag_votes_insert_refresh
  after insert on tag_votes
  for each statement
  execute function refresh_book_tag_counts();

drop trigger if exists trg_tag_votes_delete_refresh on tag_votes;
create trigger trg_tag_votes_delete_refresh
  after delete on tag_votes
  for each statement
  execute function refresh_book_tag_counts();

grant execute on function refresh_book_tag_counts() to authenticated;

-- ─── 013: Discover by Tags ─────────────────────────────────────────────────
create or replace function discover_books_by_tags(
  p_tag_ids uuid[],
  p_limit integer default 20,
  p_offset integer default 0
)
returns table (
  book_id uuid,
  match_count bigint,
  matched_tags uuid[]
) as $$
begin
  return query
  select
    tv.book_id,
    count(distinct tv.tag_id) as match_count,
    array_agg(distinct tv.tag_id) as matched_tags
  from tag_votes tv
  where tv.tag_id = any(p_tag_ids)
  group by tv.book_id
  order by match_count desc, tv.book_id
  limit p_limit
  offset p_offset;
end;
$$ language plpgsql stable;

-- ─── 014: Similar Books ────────────────────────────────────────────────────
create or replace function get_similar_books(
  p_book_id uuid,
  p_limit integer default 8
)
returns table (
  book_id uuid,
  shared_tags bigint,
  shared_tag_ids uuid[]
) as $$
begin
  return query
  with source_tags as (
    select distinct tag_id
    from tag_votes
    where book_id = p_book_id
  )
  select
    tv.book_id,
    count(distinct tv.tag_id) as shared_tags,
    array_agg(distinct tv.tag_id) as shared_tag_ids
  from tag_votes tv
  join source_tags st on st.tag_id = tv.tag_id
  where tv.book_id != p_book_id
  group by tv.book_id
  order by shared_tags desc
  limit p_limit;
end;
$$ language plpgsql stable;

-- ─── 015: Popular Tags for Book ─────────────────────────────────────────────
create or replace function get_popular_tags_for_book(
  p_book_id uuid,
  p_limit integer default 10
)
returns table (
  tag_id uuid,
  label text,
  category text,
  slug text,
  vote_count bigint
) as $$
begin
  return query
  select
    td.id as tag_id,
    td.label,
    td.category,
    td.slug,
    count(*) as vote_count
  from tag_votes tv
  join tag_definitions td on td.id = tv.tag_id
  where tv.book_id = p_book_id
  group by td.id, td.label, td.category, td.slug
  order by vote_count desc
  limit p_limit;
end;
$$ language plpgsql stable;

-- ─── 016: Explained Recommendations (replaces 010) ─────────────────────────
create or replace function get_recommendations(p_user_id uuid, p_limit integer default 20)
returns table (
  book_id uuid,
  score bigint,
  reason jsonb
) as $$
begin
  return query
  with user_rated_books as (
    select bl.book_id, bl.rating
    from book_logs bl
    where bl.user_id = p_user_id
  ),
  user_tags as (
    select tv.tag_id, td.category, td.label, td.id
    from tag_votes tv
    join tag_definitions td on td.id = tv.tag_id
    where tv.user_id = p_user_id
  ),
  user_fav_authors as (
    select distinct unnest(b.authors) as author
    from book_logs bl
    join books b on b.id = bl.book_id
    where bl.user_id = p_user_id and bl.rating >= 9
  ),
  candidate_books as (
    select b.id as book_id
    from books b
    where b.id not in (select urb.book_id from user_rated_books urb)
      and b.id not in (select ubs.book_id from user_bookshelves ubs where ubs.user_id = p_user_id)
  ),
  scored as (
    select
      cb.book_id,
      coalesce((
        select count(distinct td.category) * 3
        from tag_votes tv
        join tag_definitions td on td.id = tv.tag_id
        where tv.book_id = cb.book_id
          and td.category in (select ut.category from user_tags ut)
      ), 0)
      + coalesce((
        select count(*) * 2
        from tag_votes tv
        where tv.book_id = cb.book_id
          and tv.tag_id in (select ut.tag_id from user_tags ut)
      ), 0)
      + case when exists (
        select 1 from books b
        where b.id = cb.book_id
          and b.authors && (select array_agg(author) from user_fav_authors)
      ) then 5 else 0 end
      + case when exists (
        select 1 from book_rating_stats brs
        where brs.book_id = cb.book_id
          and brs.avg_rating >= 7.5
          and brs.rating_count >= 3
      ) then 2 else 0 end
      as score,
      jsonb_build_object(
        'matched_tags', coalesce((
          select jsonb_agg(jsonb_build_object('id', td.id, 'label', td.label, 'category', td.category))
          from tag_votes tv
          join tag_definitions td on td.id = tv.tag_id
          where tv.book_id = cb.book_id
            and tv.tag_id in (select ut.tag_id from user_tags ut)
        ), '[]'::jsonb),
        'matched_categories', coalesce((
          select jsonb_agg(distinct td.category)
          from tag_votes tv
          join tag_definitions td on td.id = tv.tag_id
          where tv.book_id = cb.book_id
            and td.category in (select ut.category from user_tags ut)
        ), '[]'::jsonb),
        'author_match', coalesce((
          select jsonb_agg(a.author)
          from user_fav_authors a
          join books b on b.id = cb.book_id and a.author = any(b.authors)
        ), '[]'::jsonb),
        'high_community_rating', exists (
          select 1 from book_rating_stats brs
          where brs.book_id = cb.book_id
            and brs.avg_rating >= 7.5
            and brs.rating_count >= 3
        )
      ) as reason
    from candidate_books cb
  )
  select s.book_id, s.score, s.reason
  from scored s
  where s.score > 0
  order by s.score desc
  limit p_limit;
end;
$$ language plpgsql stable;

-- ─── 017: Co-occurring Tags ─────────────────────────────────────────────────
create or replace function get_co_occurring_tags(
  p_tag_id uuid,
  p_limit integer default 8
)
returns table (
  tag_id uuid,
  label text,
  slug text,
  category text,
  color text,
  co_occurrence_count bigint
) as $$
begin
  return query
  select
    td.id as tag_id,
    td.label,
    td.slug,
    td.category,
    td.color,
    count(*) as co_occurrence_count
  from tag_votes tv1
  join tag_votes tv2 on tv2.book_id = tv1.book_id and tv2.tag_id != tv1.tag_id
  join tag_definitions td on td.id = tv2.tag_id
  where tv1.tag_id = p_tag_id
  group by td.id, td.label, td.slug, td.category, td.color
  order by co_occurrence_count desc
  limit p_limit;
end;
$$ language plpgsql stable;

-- ─── 018: Seed Popular Books ────────────────────────────────────────────────
insert into profiles (id, username, display_name)
values ('00000000-0000-0000-0000-000000000001', 'ludentia-system', 'Ludentia')
on conflict (id) do nothing;

insert into books (id, google_books_id, title, authors, categories, page_count, language)
values
  ('a0000000-0000-0000-0000-000000000001', 'wrOQLV6xB-wC', 'Harry Potter and the Sorcerer''s Stone', array['J.K. Rowling'], array['Fantasy', 'Fiction'], 309, 'en'),
  ('a0000000-0000-0000-0000-000000000002', 'aWZzLPhY4o0C', 'The Fellowship of the Ring', array['J.R.R. Tolkien'], array['Fantasy', 'Fiction'], 423, 'en'),
  ('a0000000-0000-0000-0000-000000000003', 'K9MnDwAAQBAJ', 'The Name of the Wind', array['Patrick Rothfuss'], array['Fantasy', 'Fiction'], 662, 'en'),
  ('a0000000-0000-0000-0000-000000000004', '1q_xAwAAQBAJ', 'Mistborn: The Final Empire', array['Brandon Sanderson'], array['Fantasy', 'Fiction'], 541, 'en'),
  ('a0000000-0000-0000-0000-000000000005', 'WZn7DQAAQBAJ', 'A Game of Thrones', array['George R.R. Martin'], array['Fantasy', 'Fiction'], 694, 'en'),
  ('a0000000-0000-0000-0000-000000000006', 'nGPnCwAAQBAJ', 'Dune', array['Frank Herbert'], array['Science Fiction', 'Fiction'], 412, 'en'),
  ('a0000000-0000-0000-0000-000000000007', 'kotPYEqx7kMC', '1984', array['George Orwell'], array['Science Fiction', 'Fiction', 'Dystopia'], 328, 'en'),
  ('a0000000-0000-0000-0000-000000000008', 'PGR2AwAAQBAJ', 'The Martian', array['Andy Weir'], array['Science Fiction', 'Fiction'], 369, 'en'),
  ('a0000000-0000-0000-0000-000000000009', 'IkMOBQAAQBAJ', 'Project Hail Mary', array['Andy Weir'], array['Science Fiction', 'Fiction'], 476, 'en'),
  ('a0000000-0000-0000-0000-000000000010', 'RO1WAAAAMAAJ', 'Brave New World', array['Aldous Huxley'], array['Science Fiction', 'Fiction', 'Dystopia'], 311, 'en'),
  ('a0000000-0000-0000-0000-000000000011', 'PzhJjwEACAAJ', 'The Great Gatsby', array['F. Scott Fitzgerald'], array['Literary Fiction', 'Classics'], 180, 'en'),
  ('a0000000-0000-0000-0000-000000000012', '1LZzDwAAQBAJ', 'Normal People', array['Sally Rooney'], array['Literary Fiction', 'Fiction'], 266, 'en'),
  ('a0000000-0000-0000-0000-000000000013', 'k_IPpuMBLQUC', 'The Kite Runner', array['Khaled Hosseini'], array['Literary Fiction', 'Fiction'], 371, 'en'),
  ('a0000000-0000-0000-0000-000000000014', 'kPqzDAAAQBAJ', 'A Little Life', array['Hanya Yanagihara'], array['Literary Fiction', 'Fiction'], 720, 'en'),
  ('a0000000-0000-0000-0000-000000000015', 'PI-YCgAAQBAJ', 'Gone Girl', array['Gillian Flynn'], array['Thriller', 'Mystery', 'Fiction'], 432, 'en'),
  ('a0000000-0000-0000-0000-000000000016', 'CTSgBAAAQBAJ', 'The Girl on the Train', array['Paula Hawkins'], array['Thriller', 'Mystery', 'Fiction'], 395, 'en'),
  ('a0000000-0000-0000-0000-000000000017', 'AUo-CgAAQBAJ', 'Big Little Lies', array['Liane Moriarty'], array['Fiction', 'Mystery'], 460, 'en'),
  ('a0000000-0000-0000-0000-000000000018', 'VNYfEAAAQBAJ', 'The Seven Husbands of Evelyn Hugo', array['Taylor Jenkins Reid'], array['Fiction', 'Romance'], 389, 'en'),
  ('a0000000-0000-0000-0000-000000000019', 'PcWGDwAAQBAJ', 'Beach Read', array['Emily Henry'], array['Fiction', 'Romance'], 361, 'en'),
  ('a0000000-0000-0000-0000-000000000020', 'bxVHEAAAQBAJ', 'People We Meet on Vacation', array['Emily Henry'], array['Fiction', 'Romance'], 364, 'en'),
  ('a0000000-0000-0000-0000-000000000021', 'Yz8Fnw0PlEQC', 'Sapiens', array['Yuval Noah Harari'], array['Nonfiction', 'History'], 443, 'en'),
  ('a0000000-0000-0000-0000-000000000022', 'lFhbDwAAQBAJ', 'Educated', array['Tara Westover'], array['Nonfiction', 'Memoir'], 334, 'en'),
  ('a0000000-0000-0000-0000-000000000023', 'SJd1DwAAQBAJ', 'Becoming', array['Michelle Obama'], array['Nonfiction', 'Memoir'], 448, 'en'),
  ('a0000000-0000-0000-0000-000000000024', 'JXqaDQAAQBAJ', 'Mexican Gothic', array['Silvia Moreno-Garcia'], array['Horror', 'Fiction'], 301, 'en'),
  ('a0000000-0000-0000-0000-000000000025', 'WXc2DwAAQBAJ', 'The Haunting of Hill House', array['Shirley Jackson'], array['Horror', 'Fiction', 'Classics'], 246, 'en'),
  ('a0000000-0000-0000-0000-000000000026', 'dtBHEAAAQBAJ', 'The Hunger Games', array['Suzanne Collins'], array['Young Adult', 'Science Fiction', 'Fiction'], 374, 'en'),
  ('a0000000-0000-0000-0000-000000000027', 'gCtazG4ZXlQC', 'Percy Jackson and the Lightning Thief', array['Rick Riordan'], array['Young Adult', 'Fantasy', 'Fiction'], 375, 'en'),
  ('a0000000-0000-0000-0000-000000000028', '7mIhEAAAQBAJ', 'Tomorrow, and Tomorrow, and Tomorrow', array['Gabrielle Zevin'], array['Fiction', 'Literary Fiction'], 401, 'en'),
  ('a0000000-0000-0000-0000-000000000029', 'xz5jDwAAQBAJ', 'Circe', array['Madeline Miller'], array['Fantasy', 'Fiction', 'Mythology'], 393, 'en'),
  ('a0000000-0000-0000-0000-000000000030', '2hJhDwAAQBAJ', 'The Song of Achilles', array['Madeline Miller'], array['Fiction', 'Fantasy', 'Mythology'], 369, 'en')
on conflict (google_books_id) do nothing;

do $$
declare
  sys_user uuid := '00000000-0000-0000-0000-000000000001';
begin
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'highly-rereadable'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'must-read-in-order'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'series-gets-better'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'moderate-read'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'must-read-in-order'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'literary'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'moderate-read'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'easy-read'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'highly-rereadable'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'easy-read'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'bittersweet'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'mental-health'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'easy-read'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'better-on-reread'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'highly-rereadable'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;
end;
$$;

refresh materialized view book_tag_counts;

-- ─── 019: Profile Bio & Website ─────────────────────────────────────────────
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS bio text;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS website text;

-- ─── 020: Lists ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lists (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  cover_book_id uuid REFERENCES books,
  visibility text NOT NULL DEFAULT 'public'
    CHECK (visibility IN ('public','friends_only','private')),
  is_ranked boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_lists_user ON lists(user_id);

CREATE TABLE IF NOT EXISTS list_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  list_id uuid NOT NULL REFERENCES lists ON DELETE CASCADE,
  book_id uuid NOT NULL REFERENCES books ON DELETE CASCADE,
  position integer NOT NULL DEFAULT 0,
  note text,
  added_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(list_id, book_id)
);
CREATE INDEX IF NOT EXISTS idx_list_items_list ON list_items(list_id, position);

ALTER TABLE lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE list_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public lists readable" ON lists;
CREATE POLICY "Public lists readable" ON lists FOR SELECT
  USING (visibility = 'public' OR user_id = auth.uid());
DROP POLICY IF EXISTS "Users manage own lists" ON lists;
CREATE POLICY "Users manage own lists" ON lists FOR ALL
  USING (user_id = auth.uid());
DROP POLICY IF EXISTS "List items readable with list" ON list_items;
CREATE POLICY "List items readable with list" ON list_items FOR SELECT
  USING (EXISTS (SELECT 1 FROM lists WHERE lists.id = list_id
    AND (lists.visibility = 'public' OR lists.user_id = auth.uid())));
DROP POLICY IF EXISTS "Users manage own list items" ON list_items;
CREATE POLICY "Users manage own list items" ON list_items FOR ALL
  USING (EXISTS (SELECT 1 FROM lists WHERE lists.id = list_id
    AND lists.user_id = auth.uid()));

-- ─── 021: Activity Feed ─────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_activity_feed(
  p_user_id uuid,
  p_limit int DEFAULT 20,
  p_before timestamptz DEFAULT now()
)
RETURNS TABLE (
  event_id uuid,
  event_type text,
  user_id uuid,
  book_id uuid,
  event_data jsonb,
  created_at timestamptz
) LANGUAGE sql STABLE AS $$
  SELECT bl.id, 'log'::text, bl.user_id, bl.book_id,
    jsonb_build_object(
      'rating', bl.rating,
      'review_text', bl.review_text,
      'contains_spoilers', bl.contains_spoilers,
      'is_reread', bl.is_reread
    ),
    bl.created_at
  FROM book_logs bl
  JOIN follows f ON f.following_id = bl.user_id AND f.follower_id = p_user_id
  WHERE bl.visibility = 'public' AND bl.created_at < p_before

  UNION ALL

  SELECT de.id, 'diary'::text, de.user_id, de.book_id,
    jsonb_build_object(
      'entry_text', de.entry_text,
      'page_at', de.page_at,
      'is_spoiler', de.is_spoiler
    ),
    de.created_at
  FROM diary_entries de
  JOIN follows f ON f.following_id = de.user_id AND f.follower_id = p_user_id
  WHERE de.visibility = 'public' AND de.created_at < p_before

  UNION ALL

  SELECT ub.id, 'shelf'::text, ub.user_id, ub.book_id,
    jsonb_build_object('shelf', ub.shelf),
    ub.added_at
  FROM user_bookshelves ub
  JOIN follows f ON f.following_id = ub.user_id AND f.follower_id = p_user_id
  WHERE ub.added_at < p_before

  ORDER BY created_at DESC
  LIMIT p_limit;
$$;

-- ─── 022: User Stats ────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_user_reading_stats(
  p_user_id uuid,
  p_year int DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql STABLE AS $$
DECLARE
  result jsonb;
BEGIN
  WITH filtered_logs AS (
    SELECT bl.*, b.page_count, b.authors, b.categories
    FROM book_logs bl
    JOIN books b ON b.id = bl.book_id
    WHERE bl.user_id = p_user_id
      AND (p_year IS NULL OR EXTRACT(YEAR FROM bl.date_finished) = p_year)
  ),
  stats AS (
    SELECT
      count(*) AS books_logged,
      count(DISTINCT book_id) AS unique_books,
      coalesce(sum(page_count), 0) AS total_pages,
      round(avg(rating)::numeric, 1) AS avg_rating,
      count(*) FILTER (WHERE is_reread) AS rereads
    FROM filtered_logs
  ),
  monthly AS (
    SELECT
      EXTRACT(MONTH FROM date_finished)::int AS month,
      count(*) AS count
    FROM filtered_logs
    WHERE date_finished IS NOT NULL
    GROUP BY 1 ORDER BY 1
  ),
  rating_dist AS (
    SELECT rating, count(*) AS count
    FROM filtered_logs
    WHERE rating IS NOT NULL
    GROUP BY rating ORDER BY rating
  ),
  top_genres AS (
    SELECT unnest(categories) AS genre, count(*) AS count
    FROM filtered_logs
    WHERE categories IS NOT NULL
    GROUP BY 1 ORDER BY 2 DESC LIMIT 8
  ),
  top_authors AS (
    SELECT unnest(authors) AS author, count(*) AS count
    FROM filtered_logs
    WHERE authors IS NOT NULL
    GROUP BY 1 ORDER BY 2 DESC LIMIT 8
  )
  SELECT jsonb_build_object(
    'summary', (SELECT row_to_json(stats) FROM stats),
    'by_month', coalesce((SELECT jsonb_agg(row_to_json(m)) FROM monthly m), '[]'::jsonb),
    'rating_distribution', coalesce((SELECT jsonb_agg(row_to_json(r)) FROM rating_dist r), '[]'::jsonb),
    'top_genres', coalesce((SELECT jsonb_agg(row_to_json(g)) FROM top_genres g), '[]'::jsonb),
    'top_authors', coalesce((SELECT jsonb_agg(row_to_json(a)) FROM top_authors a), '[]'::jsonb)
  ) INTO result;

  RETURN result;
END;
$$;

-- ─── 023: Full-Text Search ──────────────────────────────────────────────────
ALTER TABLE books ADD COLUMN IF NOT EXISTS fts tsvector
  GENERATED ALWAYS AS (
    setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(array_to_string(authors, ' '), '')), 'B') ||
    setweight(to_tsvector('english', coalesce(array_to_string(categories, ' '), '')), 'C') ||
    setweight(to_tsvector('english', coalesce(description, '')), 'D')
  ) STORED;

CREATE INDEX IF NOT EXISTS idx_books_fts ON books USING GIN(fts);
CREATE INDEX IF NOT EXISTS idx_books_categories ON books USING GIN(categories);
CREATE INDEX IF NOT EXISTS idx_books_authors ON books USING GIN(authors);

-- ─── 024: Reading Goals ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS reading_goals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles ON DELETE CASCADE,
  year integer NOT NULL,
  target_books integer NOT NULL CHECK (target_books >= 1 AND target_books <= 500),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, year)
);
CREATE INDEX IF NOT EXISTS idx_goals_user_year ON reading_goals(user_id, year);

ALTER TABLE reading_goals ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can view own goals" ON reading_goals;
CREATE POLICY "Users can view own goals" ON reading_goals FOR SELECT USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Public goals viewable" ON reading_goals;
CREATE POLICY "Public goals viewable" ON reading_goals FOR SELECT USING (
  EXISTS (SELECT 1 FROM profiles WHERE profiles.id = reading_goals.user_id AND profiles.profile_visibility = 'public')
);
DROP POLICY IF EXISTS "Users manage own goals" ON reading_goals;
CREATE POLICY "Users manage own goals" ON reading_goals FOR ALL USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION get_goal_progress(p_user_id uuid, p_year integer DEFAULT EXTRACT(YEAR FROM now())::integer)
RETURNS jsonb LANGUAGE plpgsql STABLE AS $$
DECLARE result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'goal', (SELECT jsonb_build_object('id', g.id, 'target_books', g.target_books, 'year', g.year)
             FROM reading_goals g WHERE g.user_id = p_user_id AND g.year = p_year),
    'books_read', (SELECT count(DISTINCT book_id) FROM book_logs
                   WHERE user_id = p_user_id AND EXTRACT(YEAR FROM date_finished) = p_year AND date_finished IS NOT NULL),
    'books_this_month', (SELECT count(DISTINCT book_id) FROM book_logs
                         WHERE user_id = p_user_id AND EXTRACT(YEAR FROM date_finished) = p_year
                         AND EXTRACT(MONTH FROM date_finished) = EXTRACT(MONTH FROM now()) AND date_finished IS NOT NULL)
  ) INTO result;
  RETURN result;
END; $$;

-- ─── 025: Reading Streaks ───────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_reading_streak(p_user_id uuid)
RETURNS jsonb LANGUAGE plpgsql STABLE AS $$
DECLARE result jsonb;
BEGIN
  WITH activity_dates AS (
    SELECT DISTINCT activity_date FROM (
      SELECT date_finished::date AS activity_date FROM book_logs WHERE user_id = p_user_id AND date_finished IS NOT NULL
      UNION
      SELECT created_at::date FROM diary_entries WHERE user_id = p_user_id
      UNION
      SELECT updated_at::date FROM reading_progress WHERE user_id = p_user_id
    ) a WHERE activity_date IS NOT NULL
  ),
  numbered AS (
    SELECT activity_date, activity_date - (ROW_NUMBER() OVER (ORDER BY activity_date))::integer AS grp
    FROM activity_dates
  ),
  streaks AS (
    SELECT grp, count(*) AS streak_len, max(activity_date) AS streak_end FROM numbered GROUP BY grp
  )
  SELECT jsonb_build_object(
    'current_streak', coalesce((SELECT streak_len FROM streaks WHERE streak_end >= (current_date - 1) ORDER BY streak_end DESC LIMIT 1), 0),
    'longest_streak', coalesce((SELECT max(streak_len) FROM streaks), 0),
    'total_active_days', (SELECT count(*) FROM activity_dates),
    'is_active_today', EXISTS (SELECT 1 FROM activity_dates WHERE activity_date = current_date)
  ) INTO result;
  RETURN result;
END; $$;

-- ─── 026: Year in Review ────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_year_in_review(p_user_id uuid, p_year integer DEFAULT EXTRACT(YEAR FROM now())::integer)
RETURNS jsonb LANGUAGE plpgsql STABLE AS $$
DECLARE result jsonb;
BEGIN
  WITH fl AS (
    SELECT bl.*, b.page_count, b.authors, b.categories, b.title, b.cover_url
    FROM book_logs bl JOIN books b ON b.id = bl.book_id
    WHERE bl.user_id = p_user_id AND EXTRACT(YEAR FROM bl.date_finished) = p_year AND bl.date_finished IS NOT NULL
  ),
  summary AS (
    SELECT count(*) AS books_logged, count(DISTINCT book_id) AS unique_books,
      coalesce(sum(page_count),0) AS total_pages, round(avg(rating)::numeric,1) AS avg_rating,
      count(*) FILTER (WHERE is_reread) AS rereads, min(date_finished) AS first_finish, max(date_finished) AS last_finish
    FROM fl
  ),
  monthly AS (SELECT EXTRACT(MONTH FROM date_finished)::int AS month, count(*) AS count FROM fl GROUP BY 1 ORDER BY 1),
  rating_dist AS (SELECT rating, count(*) AS count FROM fl WHERE rating IS NOT NULL GROUP BY rating ORDER BY rating),
  top_genres AS (SELECT unnest(categories) AS genre, count(*) AS count FROM fl WHERE categories IS NOT NULL GROUP BY 1 ORDER BY 2 DESC LIMIT 8),
  top_authors AS (SELECT unnest(authors) AS author, count(*) AS count FROM fl WHERE authors IS NOT NULL GROUP BY 1 ORDER BY 2 DESC LIMIT 8),
  highest_rated AS (SELECT book_id, title, cover_url, rating, authors FROM fl WHERE rating IS NOT NULL ORDER BY rating DESC, created_at ASC LIMIT 5),
  lowest_rated AS (SELECT book_id, title, cover_url, rating, authors FROM fl WHERE rating IS NOT NULL ORDER BY rating ASC, created_at ASC LIMIT 3),
  longest_books AS (SELECT book_id, title, cover_url, page_count, authors FROM fl WHERE page_count IS NOT NULL ORDER BY page_count DESC LIMIT 3),
  shortest_books AS (SELECT book_id, title, cover_url, page_count, authors FROM fl WHERE page_count IS NOT NULL AND page_count > 0 ORDER BY page_count ASC LIMIT 3),
  fastest_reads AS (
    SELECT book_id, title, cover_url, page_count, authors, (date_finished - date_started) AS days_to_read
    FROM fl WHERE date_started IS NOT NULL AND date_finished >= date_started ORDER BY (date_finished - date_started) ASC LIMIT 3
  ),
  diary_count AS (SELECT count(*) AS total FROM diary_entries WHERE user_id = p_user_id AND EXTRACT(YEAR FROM created_at) = p_year),
  busiest AS (SELECT EXTRACT(MONTH FROM date_finished)::int AS month, count(*) AS count FROM fl GROUP BY 1 ORDER BY 2 DESC LIMIT 1)
  SELECT jsonb_build_object(
    'year', p_year,
    'summary', (SELECT row_to_json(s) FROM summary s),
    'by_month', coalesce((SELECT jsonb_agg(row_to_json(m)) FROM monthly m), '[]'::jsonb),
    'rating_distribution', coalesce((SELECT jsonb_agg(row_to_json(r)) FROM rating_dist r), '[]'::jsonb),
    'top_genres', coalesce((SELECT jsonb_agg(row_to_json(g)) FROM top_genres g), '[]'::jsonb),
    'top_authors', coalesce((SELECT jsonb_agg(row_to_json(a)) FROM top_authors a), '[]'::jsonb),
    'highest_rated', coalesce((SELECT jsonb_agg(row_to_json(h)) FROM highest_rated h), '[]'::jsonb),
    'lowest_rated', coalesce((SELECT jsonb_agg(row_to_json(l)) FROM lowest_rated l), '[]'::jsonb),
    'longest_books', coalesce((SELECT jsonb_agg(row_to_json(lb)) FROM longest_books lb), '[]'::jsonb),
    'shortest_books', coalesce((SELECT jsonb_agg(row_to_json(sb)) FROM shortest_books sb), '[]'::jsonb),
    'fastest_reads', coalesce((SELECT jsonb_agg(row_to_json(fr)) FROM fastest_reads fr), '[]'::jsonb),
    'diary_entries_count', (SELECT total FROM diary_count),
    'busiest_month', (SELECT row_to_json(bm) FROM busiest bm)
  ) INTO result;
  RETURN result;
END; $$;

-- ─── 027: Discussions ───────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS discussion_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id uuid NOT NULL REFERENCES books ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES profiles ON DELETE CASCADE,
  parent_id uuid REFERENCES discussion_comments ON DELETE CASCADE,
  comment_text text NOT NULL CHECK (char_length(comment_text) BETWEEN 1 AND 2000),
  contains_spoilers boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_disc_book ON discussion_comments(book_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_disc_parent ON discussion_comments(parent_id);

ALTER TABLE discussion_comments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Comments readable" ON discussion_comments;
CREATE POLICY "Comments readable" ON discussion_comments FOR SELECT USING (true);
DROP POLICY IF EXISTS "Auth users can comment" ON discussion_comments;
CREATE POLICY "Auth users can comment" ON discussion_comments FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users manage own comments" ON discussion_comments;
CREATE POLICY "Users manage own comments" ON discussion_comments FOR ALL USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION get_book_discussions(p_book_id uuid, p_limit int DEFAULT 20, p_offset int DEFAULT 0)
RETURNS jsonb LANGUAGE plpgsql STABLE AS $$
DECLARE result jsonb;
BEGIN
  WITH top AS (
    SELECT dc.id, dc.user_id, dc.comment_text, dc.contains_spoilers, dc.created_at,
      p.username, p.display_name, p.avatar_url
    FROM discussion_comments dc JOIN profiles p ON p.id = dc.user_id
    WHERE dc.book_id = p_book_id AND dc.parent_id IS NULL
    ORDER BY dc.created_at DESC LIMIT p_limit OFFSET p_offset
  ),
  replies AS (
    SELECT dc.id, dc.user_id, dc.parent_id, dc.comment_text, dc.contains_spoilers, dc.created_at,
      p.username, p.display_name, p.avatar_url
    FROM discussion_comments dc JOIN profiles p ON p.id = dc.user_id
    WHERE dc.parent_id IN (SELECT t.id FROM top t)
    ORDER BY dc.created_at ASC
  ),
  cnt AS (SELECT count(*) AS total FROM discussion_comments WHERE book_id = p_book_id AND parent_id IS NULL)
  SELECT jsonb_build_object(
    'total', (SELECT total FROM cnt),
    'comments', coalesce((
      SELECT jsonb_agg(jsonb_build_object(
        'id', t.id, 'user_id', t.user_id, 'username', t.username, 'display_name', t.display_name,
        'avatar_url', t.avatar_url, 'comment_text', t.comment_text, 'contains_spoilers', t.contains_spoilers,
        'created_at', t.created_at,
        'replies', coalesce((
          SELECT jsonb_agg(jsonb_build_object(
            'id', r.id, 'user_id', r.user_id, 'username', r.username, 'display_name', r.display_name,
            'avatar_url', r.avatar_url, 'comment_text', r.comment_text, 'contains_spoilers', r.contains_spoilers,
            'created_at', r.created_at
          ) ORDER BY r.created_at) FROM replies r WHERE r.parent_id = t.id
        ), '[]'::jsonb)
      )) FROM top t
    ), '[]'::jsonb)
  ) INTO result;
  RETURN result;
END; $$;

-- ─── 028: Admin & Reports ───────────────────────────────────────────────────
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS is_admin boolean NOT NULL DEFAULT false;

CREATE TABLE IF NOT EXISTS reported_content (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_id uuid NOT NULL REFERENCES profiles ON DELETE CASCADE,
  content_type text NOT NULL CHECK (content_type IN ('comment', 'review', 'diary', 'list', 'tag')),
  content_id uuid NOT NULL,
  reason text NOT NULL CHECK (char_length(reason) BETWEEN 1 AND 500),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'actioned', 'dismissed')),
  admin_notes text,
  resolved_by uuid REFERENCES profiles,
  created_at timestamptz NOT NULL DEFAULT now(),
  resolved_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_reports_status ON reported_content(status, created_at DESC);

ALTER TABLE reported_content ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can report" ON reported_content;
CREATE POLICY "Users can report" ON reported_content FOR INSERT WITH CHECK (auth.uid() = reporter_id);
DROP POLICY IF EXISTS "Users see own reports" ON reported_content;
CREATE POLICY "Users see own reports" ON reported_content FOR SELECT USING (auth.uid() = reporter_id);
DROP POLICY IF EXISTS "Admins see all reports" ON reported_content;
CREATE POLICY "Admins see all reports" ON reported_content FOR SELECT USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true)
);
DROP POLICY IF EXISTS "Admins manage reports" ON reported_content;
CREATE POLICY "Admins manage reports" ON reported_content FOR UPDATE USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true)
);

CREATE OR REPLACE FUNCTION get_reported_content(p_status text DEFAULT 'pending', p_limit int DEFAULT 50)
RETURNS jsonb LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
DECLARE result jsonb;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  SELECT coalesce(jsonb_agg(jsonb_build_object(
    'id', r.id, 'content_type', r.content_type, 'content_id', r.content_id,
    'reason', r.reason, 'status', r.status, 'admin_notes', r.admin_notes,
    'created_at', r.created_at,
    'reporter', jsonb_build_object('id', p.id, 'username', p.username, 'display_name', p.display_name)
  )), '[]'::jsonb) INTO result
  FROM reported_content r JOIN profiles p ON p.id = r.reporter_id
  WHERE r.status = p_status ORDER BY r.created_at DESC LIMIT p_limit;
  RETURN result;
END; $$;

CREATE OR REPLACE FUNCTION admin_get_users(p_search text DEFAULT '', p_limit int DEFAULT 50, p_offset int DEFAULT 0)
RETURNS jsonb LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
DECLARE result jsonb;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  SELECT jsonb_build_object(
    'total', (SELECT count(*) FROM profiles WHERE p_search = '' OR username ILIKE '%' || p_search || '%' OR display_name ILIKE '%' || p_search || '%'),
    'users', coalesce((
      SELECT jsonb_agg(jsonb_build_object(
        'id', p.id, 'username', p.username, 'display_name', p.display_name,
        'avatar_url', p.avatar_url, 'is_admin', p.is_admin, 'created_at', p.created_at,
        'books_logged', (SELECT count(*) FROM book_logs bl WHERE bl.user_id = p.id)
      ) ORDER BY p.created_at DESC)
      FROM profiles p
      WHERE p_search = '' OR p.username ILIKE '%' || p_search || '%' OR p.display_name ILIKE '%' || p_search || '%'
      LIMIT p_limit OFFSET p_offset
    ), '[]'::jsonb)
  ) INTO result;
  RETURN result;
END; $$;

CREATE OR REPLACE FUNCTION admin_get_tags(p_limit int DEFAULT 100)
RETURNS jsonb LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
DECLARE result jsonb;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  SELECT coalesce(jsonb_agg(jsonb_build_object(
    'id', td.id, 'label', td.label, 'slug', td.slug, 'category', td.category,
    'is_official', td.is_official, 'color', td.color, 'created_at', td.created_at,
    'total_votes', (SELECT count(*) FROM tag_votes tv WHERE tv.tag_id = td.id)
  ) ORDER BY (SELECT count(*) FROM tag_votes tv WHERE tv.tag_id = td.id) DESC), '[]'::jsonb) INTO result
  FROM tag_definitions td LIMIT p_limit;
  RETURN result;
END; $$;

-- ─── 029: Import Jobs ───────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS import_jobs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles ON DELETE CASCADE,
  source text NOT NULL CHECK (source IN ('goodreads', 'storygraph', 'csv')),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
  total_rows integer NOT NULL DEFAULT 0,
  imported_rows integer NOT NULL DEFAULT 0,
  skipped_rows integer NOT NULL DEFAULT 0,
  errors jsonb DEFAULT '[]'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_import_user ON import_jobs(user_id, created_at DESC);

ALTER TABLE import_jobs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users see own imports" ON import_jobs;
CREATE POLICY "Users see own imports" ON import_jobs FOR SELECT USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users create imports" ON import_jobs;
CREATE POLICY "Users create imports" ON import_jobs FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users update own imports" ON import_jobs;
CREATE POLICY "Users update own imports" ON import_jobs FOR UPDATE USING (auth.uid() = user_id);

-- =============================================================================
-- Done! All 30 migrations applied.
-- =============================================================================
