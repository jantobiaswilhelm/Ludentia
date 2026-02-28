-- reading_progress: tracks page/percentage for "currently reading" books
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

create policy "Users can view own progress"
  on reading_progress for select using (auth.uid() = user_id);

create policy "Users can manage own progress"
  on reading_progress for insert with check (auth.uid() = user_id);

create policy "Users can update own progress"
  on reading_progress for update using (auth.uid() = user_id);

create policy "Users can delete own progress"
  on reading_progress for delete using (auth.uid() = user_id);
