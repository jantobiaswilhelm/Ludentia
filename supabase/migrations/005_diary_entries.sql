-- diary_entries: mini journal notes while reading
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

create policy "Users can view own diary"
  on diary_entries for select using (auth.uid() = user_id);

create policy "Public diary entries viewable"
  on diary_entries for select using (visibility = 'public');

create policy "Users can insert diary entries"
  on diary_entries for insert with check (auth.uid() = user_id);

create policy "Users can update own diary entries"
  on diary_entries for update using (auth.uid() = user_id);

create policy "Users can delete own diary entries"
  on diary_entries for delete using (auth.uid() = user_id);
