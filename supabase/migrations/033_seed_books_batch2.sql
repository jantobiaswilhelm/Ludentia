-- 033: Seed books batch 2 — Mystery/Thriller (rest), Romance, Horror, Nonfiction, YA (partial)
-- Books 088-144 (57 books)

insert into books (id, google_books_id, title, authors, categories, page_count, language)
values
  -- Mystery/Thriller (088-091, remaining 4)
  ('a0000000-0000-0000-0000-000000000088', '6bI6EAAAQBAJ', 'Verity', array['Colleen Hoover'], array['Thriller', 'Romance', 'Fiction'], 314, 'en'),
  ('a0000000-0000-0000-0000-000000000089', 'VSjpwAEACAAJ', 'The Girl with the Dragon Tattoo', array['Stieg Larsson'], array['Thriller', 'Mystery', 'Fiction'], 465, 'en'),
  ('a0000000-0000-0000-0000-000000000090', 'BjmmCAAAQBAJ', 'Murder on the Orient Express', array['Agatha Christie'], array['Mystery', 'Fiction', 'Classics'], 274, 'en'),
  ('a0000000-0000-0000-0000-000000000091', 'r7eSDQAAQBAJ', 'The No. 1 Ladies'' Detective Agency', array['Alexander McCall Smith'], array['Mystery', 'Fiction'], 235, 'en'),

  -- Romance (092-106)
  ('a0000000-0000-0000-0000-000000000092', 's1gVAAAAYAAJ', 'Pride and Prejudice', array['Jane Austen'], array['Romance', 'Fiction', 'Classics'], 279, 'en'),
  ('a0000000-0000-0000-0000-000000000093', '6Z5OEAAAQBAJ', 'The Notebook', array['Nicholas Sparks'], array['Romance', 'Fiction'], 214, 'en'),
  ('a0000000-0000-0000-0000-000000000094', 'MFVnDwAAQBAJ', 'Red, White & Royal Blue', array['Casey McQuiston'], array['Romance', 'Fiction'], 418, 'en'),
  ('a0000000-0000-0000-0000-000000000095', 'nbLPDwAAQBAJ', 'It Ends with Us', array['Colleen Hoover'], array['Romance', 'Fiction'], 385, 'en'),
  ('a0000000-0000-0000-0000-000000000096', 'O7VxDwAAQBAJ', 'The Hating Game', array['Sally Thorne'], array['Romance', 'Fiction'], 374, 'en'),
  ('a0000000-0000-0000-0000-000000000097', '2B6CDwAAQBAJ', 'The Flatshare', array['Beth O''Leary'], array['Romance', 'Fiction'], 325, 'en'),
  ('a0000000-0000-0000-0000-000000000098', 'IfajDwAAQBAJ', 'Get a Life, Chloe Brown', array['Talia Hibbert'], array['Romance', 'Fiction'], 373, 'en'),
  ('a0000000-0000-0000-0000-000000000099', 'Bf5rDwAAQBAJ', 'The Kiss Quotient', array['Helen Hoang'], array['Romance', 'Fiction'], 336, 'en'),
  ('a0000000-0000-0000-0000-000000000100', 'FPH2CAAAQBAJ', 'A Court of Thorns and Roses', array['Sarah J. Maas'], array['Fantasy', 'Romance', 'Fiction'], 419, 'en'),
  ('a0000000-0000-0000-0000-000000000101', 'C6OaDwAAQBAJ', 'The Bromance Book Club', array['Lyssa Kay Adams'], array['Romance', 'Fiction'], 325, 'en'),
  ('a0000000-0000-0000-0000-000000000102', 'zpFCEAAAQBAJ', 'Book Lovers', array['Emily Henry'], array['Romance', 'Fiction'], 377, 'en'),
  ('a0000000-0000-0000-0000-000000000103', 'hWg3EAAAQBAJ', 'The Spanish Love Deception', array['Elena Armas'], array['Romance', 'Fiction'], 437, 'en'),
  ('a0000000-0000-0000-0000-000000000104', 'RK1aDQAAQBAJ', 'One Day', array['David Nicholls'], array['Romance', 'Fiction'], 435, 'en'),
  ('a0000000-0000-0000-0000-000000000105', '6wgPCAAAQBAJ', 'The Rosie Project', array['Graeme Simsion'], array['Romance', 'Fiction'], 295, 'en'),
  ('a0000000-0000-0000-0000-000000000106', '-pY2LwEACAAJ', 'Me Before You', array['Jojo Moyes'], array['Romance', 'Fiction'], 369, 'en'),

  -- Horror (107-114)
  ('a0000000-0000-0000-0000-000000000107', 'ciYzDwAAQBAJ', 'It', array['Stephen King'], array['Horror', 'Fiction'], 1138, 'en'),
  ('a0000000-0000-0000-0000-000000000108', 'dqnnDwAAQBAJ', 'The Shining', array['Stephen King'], array['Horror', 'Fiction'], 447, 'en'),
  ('a0000000-0000-0000-0000-000000000109', 'GtTPGQAACAAJ', 'Frankenstein', array['Mary Shelley'], array['Horror', 'Fiction', 'Classics', 'Gothic'], 280, 'en'),
  ('a0000000-0000-0000-0000-000000000110', 'NKkrAwAAQBAJ', 'Bird Box', array['Josh Malerman'], array['Horror', 'Thriller', 'Fiction'], 262, 'en'),
  ('a0000000-0000-0000-0000-000000000111', 'qGA_3RoB0r0C', 'House of Leaves', array['Mark Z. Danielewski'], array['Horror', 'Fiction'], 709, 'en'),
  ('a0000000-0000-0000-0000-000000000112', '_cPGEAAAQBAJ', 'The Exorcist', array['William Peter Blatty'], array['Horror', 'Fiction'], 385, 'en'),
  ('a0000000-0000-0000-0000-000000000113', '7JFIBgAAQBAJ', 'Dracula', array['Bram Stoker'], array['Horror', 'Fiction', 'Classics', 'Gothic'], 418, 'en'),
  ('a0000000-0000-0000-0000-000000000114', 'VQhcDAAAQBAJ', 'My Best Friend''s Exorcism', array['Grady Hendrix'], array['Horror', 'Fiction'], 336, 'en'),

  -- Nonfiction (115-129)
  ('a0000000-0000-0000-0000-000000000115', 'XfFvDwAAQBAJ', 'Atomic Habits', array['James Clear'], array['Nonfiction', 'Self-Help'], 320, 'en'),
  ('a0000000-0000-0000-0000-000000000116', 'fBM4DwAAQBAJ', 'The Diary of a Young Girl', array['Anne Frank'], array['Nonfiction', 'Memoir', 'History'], 283, 'en'),
  ('a0000000-0000-0000-0000-000000000117', 'oZhagX6UWOMC', 'A Brief History of Time', array['Stephen Hawking'], array['Nonfiction', 'Science'], 212, 'en'),
  ('a0000000-0000-0000-0000-000000000118', 'PG3_DAAAQBAJ', 'Born a Crime', array['Trevor Noah'], array['Nonfiction', 'Memoir'], 304, 'en'),
  ('a0000000-0000-0000-0000-000000000119', 'D2MKDAAAQBAJ', 'The Immortal Life of Henrietta Lacks', array['Rebecca Skloot'], array['Nonfiction', 'Science', 'History'], 381, 'en'),
  ('a0000000-0000-0000-0000-000000000120', 'ZuKTvERuPG8C', 'Thinking, Fast and Slow', array['Daniel Kahneman'], array['Nonfiction', 'Psychology'], 499, 'en'),
  ('a0000000-0000-0000-0000-000000000121', '_DMrDAAAQBAJ', 'When Breath Becomes Air', array['Paul Kalanithi'], array['Nonfiction', 'Memoir'], 228, 'en'),
  ('a0000000-0000-0000-0000-000000000122', 'Bku7hOVhUBEC', 'Quiet: The Power of Introverts', array['Susan Cain'], array['Nonfiction', 'Psychology'], 333, 'en'),
  ('a0000000-0000-0000-0000-000000000123', 'BYS3DwAAQBAJ', 'The Body Keeps the Score', array['Bessel van der Kolk'], array['Nonfiction', 'Psychology'], 464, 'en'),
  ('a0000000-0000-0000-0000-000000000124', 'SKobBQAAQBAJ', 'Just Mercy', array['Bryan Stevenson'], array['Nonfiction', 'Memoir', 'Law'], 336, 'en'),
  ('a0000000-0000-0000-0000-000000000125', '3NSImqqnxnkC', 'Outliers', array['Malcolm Gladwell'], array['Nonfiction', 'Psychology'], 309, 'en'),
  ('a0000000-0000-0000-0000-000000000126', 'YqkXvV5kiPkC', 'The Glass Castle', array['Jeannette Walls'], array['Nonfiction', 'Memoir'], 288, 'en'),
  ('a0000000-0000-0000-0000-000000000127', 'UFLWKwqLhoIC', 'I Know Why the Caged Bird Sings', array['Maya Angelou'], array['Nonfiction', 'Memoir', 'Classics'], 289, 'en'),
  ('a0000000-0000-0000-0000-000000000128', 'K2AvAAAAMAAJ', 'Man''s Search for Meaning', array['Viktor Frankl'], array['Nonfiction', 'Psychology', 'Memoir'], 184, 'en'),
  ('a0000000-0000-0000-0000-000000000129', 'q4OfDAAAQBAJ', 'Hidden Figures', array['Margot Lee Shetterly'], array['Nonfiction', 'History', 'Science'], 346, 'en'),

  -- Young Adult (130-144, first 15)
  ('a0000000-0000-0000-0000-000000000130', 'FkFWDwAAQBAJ', 'Divergent', array['Veronica Roth'], array['Young Adult', 'Science Fiction', 'Fiction'], 487, 'en'),
  ('a0000000-0000-0000-0000-000000000131', 'UYCEjwEACAAJ', 'The Fault in Our Stars', array['John Green'], array['Young Adult', 'Fiction'], 313, 'en'),
  ('a0000000-0000-0000-0000-000000000132', 'qU5RYGMLJZcC', 'The Maze Runner', array['James Dashner'], array['Young Adult', 'Science Fiction', 'Fiction'], 375, 'en'),
  ('a0000000-0000-0000-0000-000000000133', 'ZfjzX7M8zt0C', 'Twilight', array['Stephenie Meyer'], array['Young Adult', 'Fantasy', 'Romance', 'Fiction'], 498, 'en'),
  ('a0000000-0000-0000-0000-000000000134', 'kIQNDgAAQBAJ', 'Children of Blood and Bone', array['Tomi Adeyemi'], array['Young Adult', 'Fantasy', 'Fiction'], 531, 'en'),
  ('a0000000-0000-0000-0000-000000000135', 'BnlJCgAAQBAJ', 'Six of Crows', array['Leigh Bardugo'], array['Young Adult', 'Fantasy', 'Fiction'], 462, 'en'),
  ('a0000000-0000-0000-0000-000000000136', '2eFRPwAACAAJ', 'The Giver', array['Lois Lowry'], array['Young Adult', 'Science Fiction', 'Fiction', 'Dystopia'], 180, 'en'),
  ('a0000000-0000-0000-0000-000000000137', 'yb6LBAAAQBAJ', 'Eleanor & Park', array['Rainbow Rowell'], array['Young Adult', 'Romance', 'Fiction'], 325, 'en'),
  ('a0000000-0000-0000-0000-000000000138', 'z3-s_K3JpiMC', 'Eragon', array['Christopher Paolini'], array['Young Adult', 'Fantasy', 'Fiction'], 503, 'en'),
  ('a0000000-0000-0000-0000-000000000139', 'p7o6DwAAQBAJ', 'The Hate U Give', array['Angie Thomas'], array['Young Adult', 'Fiction'], 444, 'en'),
  ('a0000000-0000-0000-0000-000000000140', 'FDYqHAv3gPgC', 'Throne of Glass', array['Sarah J. Maas'], array['Young Adult', 'Fantasy', 'Fiction'], 404, 'en'),
  ('a0000000-0000-0000-0000-000000000141', 'jn4sDQAAQBAJ', 'Shadow and Bone', array['Leigh Bardugo'], array['Young Adult', 'Fantasy', 'Fiction'], 358, 'en'),
  ('a0000000-0000-0000-0000-000000000142', 'Bt6sPwAACAAJ', 'The Perks of Being a Wallflower', array['Stephen Chbosky'], array['Young Adult', 'Fiction'], 213, 'en'),
  ('a0000000-0000-0000-0000-000000000143', 'CBopCwAAQBAJ', 'Simon vs. the Homo Sapiens Agenda', array['Becky Albertalli'], array['Young Adult', 'Romance', 'Fiction'], 303, 'en'),
  ('a0000000-0000-0000-0000-000000000144', 't6v0AwAAQBAJ', 'We Were Liars', array['E. Lockhart'], array['Young Adult', 'Mystery', 'Fiction'], 227, 'en')
on conflict (google_books_id) do nothing;
