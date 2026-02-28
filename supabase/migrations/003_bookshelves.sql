-- user_bookshelves: one shelf per book per user
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

-- RLS
alter table user_bookshelves enable row level security;

create policy "Users can view own shelves"
  on user_bookshelves for select using (auth.uid() = user_id);

create policy "Users can manage own shelves"
  on user_bookshelves for insert with check (auth.uid() = user_id);

create policy "Users can update own shelves"
  on user_bookshelves for update using (auth.uid() = user_id);

create policy "Users can delete own shelf entries"
  on user_bookshelves for delete using (auth.uid() = user_id);

-- Public shelves visible based on profile_visibility
create policy "Public shelves viewable"
  on user_bookshelves for select using (
    exists (
      select 1 from profiles
      where profiles.id = user_bookshelves.user_id
      and profiles.profile_visibility = 'public'
    )
  );
