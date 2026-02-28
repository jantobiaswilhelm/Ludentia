-- books: canonical works (one entry per work)
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

-- book_editions: individual editions linked to a canonical book
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

-- RLS: books are publicly readable, writable by authenticated users
alter table books enable row level security;
alter table book_editions enable row level security;

create policy "Books are viewable by everyone" on books for select using (true);
create policy "Authenticated users can insert books" on books for insert with check (auth.role() = 'authenticated');
create policy "Authenticated users can update books" on books for update using (auth.role() = 'authenticated');

create policy "Editions viewable by everyone" on book_editions for select using (true);
create policy "Authenticated users can insert editions" on book_editions for insert with check (auth.role() = 'authenticated');
