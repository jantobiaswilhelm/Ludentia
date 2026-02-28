-- book_logs: the "finished book" log (Letterboxd-style)
-- Multiple logs per book allowed (re-reads)
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

create policy "Users can view own logs"
  on book_logs for select using (auth.uid() = user_id);

create policy "Public logs viewable"
  on book_logs for select using (visibility = 'public');

create policy "Users can insert logs"
  on book_logs for insert with check (auth.uid() = user_id);

create policy "Users can update own logs"
  on book_logs for update using (auth.uid() = user_id);

create policy "Users can delete own logs"
  on book_logs for delete using (auth.uid() = user_id);

-- Aggregate view for book ratings
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
