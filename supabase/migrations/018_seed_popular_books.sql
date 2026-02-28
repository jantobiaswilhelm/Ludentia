-- Create a system profile for seeding data
insert into profiles (id, username, display_name)
values ('00000000-0000-0000-0000-000000000001', 'ludentia-system', 'Ludentia')
on conflict (id) do nothing;

-- Seed well-known books with Google Books IDs
-- Using deterministic UUIDs based on a pattern for referencing later
insert into books (id, google_books_id, title, authors, categories, page_count, language)
values
  -- Fantasy
  ('a0000000-0000-0000-0000-000000000001', 'wrOQLV6xB-wC', 'Harry Potter and the Sorcerer''s Stone', array['J.K. Rowling'], array['Fantasy', 'Fiction'], 309, 'en'),
  ('a0000000-0000-0000-0000-000000000002', 'aWZzLPhY4o0C', 'The Fellowship of the Ring', array['J.R.R. Tolkien'], array['Fantasy', 'Fiction'], 423, 'en'),
  ('a0000000-0000-0000-0000-000000000003', 'K9MnDwAAQBAJ', 'The Name of the Wind', array['Patrick Rothfuss'], array['Fantasy', 'Fiction'], 662, 'en'),
  ('a0000000-0000-0000-0000-000000000004', '1q_xAwAAQBAJ', 'Mistborn: The Final Empire', array['Brandon Sanderson'], array['Fantasy', 'Fiction'], 541, 'en'),
  ('a0000000-0000-0000-0000-000000000005', 'WZn7DQAAQBAJ', 'A Game of Thrones', array['George R.R. Martin'], array['Fantasy', 'Fiction'], 694, 'en'),
  -- Sci-Fi
  ('a0000000-0000-0000-0000-000000000006', 'nGPnCwAAQBAJ', 'Dune', array['Frank Herbert'], array['Science Fiction', 'Fiction'], 412, 'en'),
  ('a0000000-0000-0000-0000-000000000007', 'kotPYEqx7kMC', '1984', array['George Orwell'], array['Science Fiction', 'Fiction', 'Dystopia'], 328, 'en'),
  ('a0000000-0000-0000-0000-000000000008', 'PGR2AwAAQBAJ', 'The Martian', array['Andy Weir'], array['Science Fiction', 'Fiction'], 369, 'en'),
  ('a0000000-0000-0000-0000-000000000009', 'IkMOBQAAQBAJ', 'Project Hail Mary', array['Andy Weir'], array['Science Fiction', 'Fiction'], 476, 'en'),
  ('a0000000-0000-0000-0000-000000000010', 'RO1WAAAAMAAJ', 'Brave New World', array['Aldous Huxley'], array['Science Fiction', 'Fiction', 'Dystopia'], 311, 'en'),
  -- Literary Fiction
  ('a0000000-0000-0000-0000-000000000011', 'PzhJjwEACAAJ', 'The Great Gatsby', array['F. Scott Fitzgerald'], array['Literary Fiction', 'Classics'], 180, 'en'),
  ('a0000000-0000-0000-0000-000000000012', '1LZzDwAAQBAJ', 'Normal People', array['Sally Rooney'], array['Literary Fiction', 'Fiction'], 266, 'en'),
  ('a0000000-0000-0000-0000-000000000013', 'k_IPpuMBLQUC', 'The Kite Runner', array['Khaled Hosseini'], array['Literary Fiction', 'Fiction'], 371, 'en'),
  ('a0000000-0000-0000-0000-000000000014', 'kPqzDAAAQBAJ', 'A Little Life', array['Hanya Yanagihara'], array['Literary Fiction', 'Fiction'], 720, 'en'),
  -- Mystery/Thriller
  ('a0000000-0000-0000-0000-000000000015', 'PI-YCgAAQBAJ', 'Gone Girl', array['Gillian Flynn'], array['Thriller', 'Mystery', 'Fiction'], 432, 'en'),
  ('a0000000-0000-0000-0000-000000000016', 'CTSgBAAAQBAJ', 'The Girl on the Train', array['Paula Hawkins'], array['Thriller', 'Mystery', 'Fiction'], 395, 'en'),
  ('a0000000-0000-0000-0000-000000000017', 'AUo-CgAAQBAJ', 'Big Little Lies', array['Liane Moriarty'], array['Fiction', 'Mystery'], 460, 'en'),
  -- Romance
  ('a0000000-0000-0000-0000-000000000018', 'VNYfEAAAQBAJ', 'The Seven Husbands of Evelyn Hugo', array['Taylor Jenkins Reid'], array['Fiction', 'Romance'], 389, 'en'),
  ('a0000000-0000-0000-0000-000000000019', 'PcWGDwAAQBAJ', 'Beach Read', array['Emily Henry'], array['Fiction', 'Romance'], 361, 'en'),
  ('a0000000-0000-0000-0000-000000000020', 'bxVHEAAAQBAJ', 'People We Meet on Vacation', array['Emily Henry'], array['Fiction', 'Romance'], 364, 'en'),
  -- Nonfiction
  ('a0000000-0000-0000-0000-000000000021', 'Yz8Fnw0PlEQC', 'Sapiens', array['Yuval Noah Harari'], array['Nonfiction', 'History'], 443, 'en'),
  ('a0000000-0000-0000-0000-000000000022', 'lFhbDwAAQBAJ', 'Educated', array['Tara Westover'], array['Nonfiction', 'Memoir'], 334, 'en'),
  ('a0000000-0000-0000-0000-000000000023', 'SJd1DwAAQBAJ', 'Becoming', array['Michelle Obama'], array['Nonfiction', 'Memoir'], 448, 'en'),
  -- Horror
  ('a0000000-0000-0000-0000-000000000024', 'JXqaDQAAQBAJ', 'Mexican Gothic', array['Silvia Moreno-Garcia'], array['Horror', 'Fiction'], 301, 'en'),
  ('a0000000-0000-0000-0000-000000000025', 'WXc2DwAAQBAJ', 'The Haunting of Hill House', array['Shirley Jackson'], array['Horror', 'Fiction', 'Classics'], 246, 'en'),
  -- Young Adult
  ('a0000000-0000-0000-0000-000000000026', 'dtBHEAAAQBAJ', 'The Hunger Games', array['Suzanne Collins'], array['Young Adult', 'Science Fiction', 'Fiction'], 374, 'en'),
  ('a0000000-0000-0000-0000-000000000027', 'gCtazG4ZXlQC', 'Percy Jackson and the Lightning Thief', array['Rick Riordan'], array['Young Adult', 'Fantasy', 'Fiction'], 375, 'en'),
  -- Contemporary
  ('a0000000-0000-0000-0000-000000000028', '7mIhEAAAQBAJ', 'Tomorrow, and Tomorrow, and Tomorrow', array['Gabrielle Zevin'], array['Fiction', 'Literary Fiction'], 401, 'en'),
  ('a0000000-0000-0000-0000-000000000029', 'xz5jDwAAQBAJ', 'Circe', array['Madeline Miller'], array['Fantasy', 'Fiction', 'Mythology'], 393, 'en'),
  ('a0000000-0000-0000-0000-000000000030', '2hJhDwAAQBAJ', 'The Song of Achilles', array['Madeline Miller'], array['Fiction', 'Fantasy', 'Mythology'], 369, 'en')
on conflict (google_books_id) do nothing;

-- Seed tag votes using the system user
-- We need tag IDs by slug, so use subqueries
do $$
declare
  sys_user uuid := '00000000-0000-0000-0000-000000000001';
begin
  -- Harry Potter: Lighthearted, Fast-Paced, World-Building, Happy Ending, Easy Read, Highly Rereadable
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'highly-rereadable'))
  on conflict do nothing;

  -- LOTR: Slow Burn, World-Building, Plot-Driven, Challenging, Must Read in Order
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'must-read-in-order'))
  on conflict do nothing;

  -- Name of the Wind: Slow Burn, Character-Driven, World-Building, Challenging, Series Gets Better
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'series-gets-better'))
  on conflict do nothing;

  -- Mistborn: Fast-Paced, World-Building, Plot-Driven, Twist Ending, Moderate Read
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'moderate-read'))
  on conflict do nothing;

  -- Game of Thrones: Dark, Slow Burn, World-Building, Graphic Violence, Must Read in Order
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'must-read-in-order'))
  on conflict do nothing;

  -- Dune: Slow Burn, World-Building, Idea-Driven, Challenging, Literary
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'literary'))
  on conflict do nothing;

  -- 1984: Dark, Tense, Idea-Driven, Sad Ending, Moderate Read
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'moderate-read'))
  on conflict do nothing;

  -- The Martian: Funny, Fast-Paced, Idea-Driven, Happy Ending, Easy Read
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'easy-read'))
  on conflict do nothing;

  -- Project Hail Mary: Funny, Fast-Paced, Idea-Driven, Hopeful, Great Standalone
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- Gone Girl: Tense, Fast-Paced, Plot-Driven, Twist Ending, Great Standalone
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- Seven Husbands of Evelyn Hugo: Emotional, Moderate, Character-Driven, Bittersweet, Highly Rereadable
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'highly-rereadable'))
  on conflict do nothing;

  -- Beach Read: Lighthearted, Funny, Relationship-Focused, Happy Ending, Easy Read
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'easy-read'))
  on conflict do nothing;

  -- Normal People: Emotional, Slow Burn, Character-Driven, Relationship-Focused, Bittersweet
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'bittersweet'))
  on conflict do nothing;

  -- A Little Life: Dark, Emotional, Character-Driven, Sad Ending, Challenging, Mental Health, Graphic Violence
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'mental-health'))
  on conflict do nothing;

  -- The Hunger Games: Tense, Fast-Paced, Plot-Driven, Cliffhanger, Easy Read
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'easy-read'))
  on conflict do nothing;

  -- Circe: Moderate, Character-Driven, World-Building, Hopeful, Better on Reread
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'better-on-reread'))
  on conflict do nothing;

  -- Song of Achilles: Emotional, Moderate, Relationship-Focused, Sad Ending, Highly Rereadable
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'highly-rereadable'))
  on conflict do nothing;

  -- Mexican Gothic: Dark, Tense, Slow Burn, Twist Ending, Great Standalone
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- Tomorrow x3: Emotional, Moderate, Character-Driven, Bittersweet, Great Standalone
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;
end;
$$;

-- Refresh the materialized view to include seeded data
refresh materialized view book_tag_counts;
