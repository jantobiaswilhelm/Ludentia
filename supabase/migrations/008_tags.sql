-- tag_definitions: two-tier tag system (official + community)
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

-- tag_votes: user votes (one per user/book/tag)
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

-- Materialized view for fast tag counts per book
create materialized view if not exists book_tag_counts as
select
  book_id,
  tag_id,
  count(*) as vote_count
from tag_votes
group by book_id, tag_id;

create unique index if not exists idx_btc_book_tag on book_tag_counts(book_id, tag_id);

-- RLS
alter table tag_definitions enable row level security;
alter table tag_votes enable row level security;

create policy "Tags viewable by everyone" on tag_definitions for select using (true);
create policy "Authenticated users can create tags" on tag_definitions for insert with check (auth.role() = 'authenticated');

create policy "Votes viewable by everyone" on tag_votes for select using (true);
create policy "Users can vote" on tag_votes for insert with check (auth.uid() = user_id);
create policy "Users can remove own votes" on tag_votes for delete using (auth.uid() = user_id);
