-- 032: Seed books batch 1 — Fantasy, Sci-Fi, Literary Fiction, Historical Fiction, Mystery/Thriller (partial)
-- Books 031-087 (57 books)

insert into books (id, google_books_id, title, authors, categories, page_count, language)
values
  -- Fantasy (031-042)
  ('a0000000-0000-0000-0000-000000000031', 'QaBmDwAAQBAJ', 'The Way of Kings', array['Brandon Sanderson'], array['Fantasy', 'Fiction'], 1007, 'en'),
  ('a0000000-0000-0000-0000-000000000032', 'pD6arNyKyi8C', 'The Hobbit', array['J.R.R. Tolkien'], array['Fantasy', 'Fiction', 'Classics'], 310, 'en'),
  ('a0000000-0000-0000-0000-000000000033', '2fJBz8x_bJoC', 'Assassin''s Apprentice', array['Robin Hobb'], array['Fantasy', 'Fiction'], 435, 'en'),
  ('a0000000-0000-0000-0000-000000000034', '8qa4BgAAQBAJ', 'The Fifth Season', array['N.K. Jemisin'], array['Fantasy', 'Science Fiction', 'Fiction'], 468, 'en'),
  ('a0000000-0000-0000-0000-000000000035', '2CTOEAAAQBAJ', 'Piranesi', array['Susanna Clarke'], array['Fantasy', 'Fiction'], 272, 'en'),
  ('a0000000-0000-0000-0000-000000000036', '2ZBYEAAAQBAJ', 'The Priory of the Orange Tree', array['Samantha Shannon'], array['Fantasy', 'Fiction'], 848, 'en'),
  ('a0000000-0000-0000-0000-000000000037', '2LFiCgAAQBAJ', 'A Wizard of Earthsea', array['Ursula K. Le Guin'], array['Fantasy', 'Fiction', 'Classics'], 183, 'en'),
  ('a0000000-0000-0000-0000-000000000038', '3KaGBQAAQBAJ', 'Uprooted', array['Naomi Novik'], array['Fantasy', 'Fiction'], 438, 'en'),
  ('a0000000-0000-0000-0000-000000000039', '3mSdPQAACAAJ', 'The Night Circus', array['Erin Morgenstern'], array['Fantasy', 'Fiction'], 387, 'en'),
  ('a0000000-0000-0000-0000-000000000040', '30g5PgAACAAJ', 'The Lies of Locke Lamora', array['Scott Lynch'], array['Fantasy', 'Fiction'], 499, 'en'),
  ('a0000000-0000-0000-0000-000000000041', 'Y9FzBgAAQBAJ', 'An Ember in the Ashes', array['Sabaa Tahir'], array['Fantasy', 'Young Adult', 'Fiction'], 446, 'en'),
  ('a0000000-0000-0000-0000-000000000042', 'mLMsDwAAQBAJ', 'Spinning Silver', array['Naomi Novik'], array['Fantasy', 'Fiction'], 466, 'en'),

  -- Sci-Fi (043-052)
  ('a0000000-0000-0000-0000-000000000043', 'jaM7DwAAQBAJ', 'Ender''s Game', array['Orson Scott Card'], array['Science Fiction', 'Fiction'], 324, 'en'),
  ('a0000000-0000-0000-0000-000000000044', '69RCEAAAQBAJ', 'The Left Hand of Darkness', array['Ursula K. Le Guin'], array['Science Fiction', 'Fiction', 'Classics'], 304, 'en'),
  ('a0000000-0000-0000-0000-000000000045', 'AU9YDwAAQBAJ', 'Fahrenheit 451', array['Ray Bradbury'], array['Science Fiction', 'Fiction', 'Classics', 'Dystopia'], 194, 'en'),
  ('a0000000-0000-0000-0000-000000000046', 'lfHqSBGfAHQC', 'The Hitchhiker''s Guide to the Galaxy', array['Douglas Adams'], array['Science Fiction', 'Fiction', 'Humor'], 216, 'en'),
  ('a0000000-0000-0000-0000-000000000047', 'F8PeDwAAQBAJ', 'Klara and the Sun', array['Kazuo Ishiguro'], array['Science Fiction', 'Literary Fiction', 'Fiction'], 307, 'en'),
  ('a0000000-0000-0000-0000-000000000048', '9SHrAgAAQBAJ', 'Red Rising', array['Pierce Brown'], array['Science Fiction', 'Fiction'], 382, 'en'),
  ('a0000000-0000-0000-0000-000000000049', 'nkGsfy3VbkAC', 'Slaughterhouse-Five', array['Kurt Vonnegut'], array['Science Fiction', 'Fiction', 'Classics'], 275, 'en'),
  ('a0000000-0000-0000-0000-000000000050', '2GBfDwAAQBAJ', 'The Handmaid''s Tale', array['Margaret Atwood'], array['Science Fiction', 'Fiction', 'Dystopia'], 311, 'en'),
  ('a0000000-0000-0000-0000-000000000051', '9CuCDwAAQBAJ', 'Recursion', array['Blake Crouch'], array['Science Fiction', 'Thriller', 'Fiction'], 320, 'en'),
  ('a0000000-0000-0000-0000-000000000052', 'FNMfAwAAQBAJ', 'Station Eleven', array['Emily St. John Mandel'], array['Science Fiction', 'Literary Fiction', 'Fiction'], 333, 'en'),

  -- Literary Fiction (053-064)
  ('a0000000-0000-0000-0000-000000000053', 'TuT5ngEACAAJ', 'Beloved', array['Toni Morrison'], array['Literary Fiction', 'Fiction', 'Classics'], 324, 'en'),
  ('a0000000-0000-0000-0000-000000000054', 'VYhJAAAAQBAJ', 'The Goldfinch', array['Donna Tartt'], array['Literary Fiction', 'Fiction'], 771, 'en'),
  ('a0000000-0000-0000-0000-000000000055', 'JzpGDwAAQBAJ', 'Where the Crawdads Sing', array['Delia Owens'], array['Literary Fiction', 'Fiction', 'Mystery'], 384, 'en'),
  ('a0000000-0000-0000-0000-000000000056', 'FfSyCgAAQBAJ', 'Atonement', array['Ian McEwan'], array['Literary Fiction', 'Fiction'], 351, 'en'),
  ('a0000000-0000-0000-0000-000000000057', 'KMocBgAAQBAJ', 'The Secret History', array['Donna Tartt'], array['Literary Fiction', 'Fiction', 'Mystery'], 559, 'en'),
  ('a0000000-0000-0000-0000-000000000058', 'cxteDAAAQBAJ', 'Pachinko', array['Min Jin Lee'], array['Literary Fiction', 'Historical Fiction', 'Fiction'], 490, 'en'),
  ('a0000000-0000-0000-0000-000000000059', 'eSHSoQAACAAJ', 'All the Light We Cannot See', array['Anthony Doerr'], array['Literary Fiction', 'Historical Fiction', 'Fiction'], 531, 'en'),
  ('a0000000-0000-0000-0000-000000000060', 'MFRidQAACAAJ', 'The Remains of the Day', array['Kazuo Ishiguro'], array['Literary Fiction', 'Fiction', 'Classics'], 245, 'en'),
  ('a0000000-0000-0000-0000-000000000061', '_OFWp_O4GEIC', 'Life of Pi', array['Yann Martel'], array['Literary Fiction', 'Fiction'], 326, 'en'),
  ('a0000000-0000-0000-0000-000000000062', 'LCEWF3AkrWoC', 'The Brief Wondrous Life of Oscar Wao', array['Junot Diaz'], array['Literary Fiction', 'Fiction'], 335, 'en'),
  ('a0000000-0000-0000-0000-000000000063', 'TWy9DAAAQBAJ', 'Homegoing', array['Yaa Gyasi'], array['Literary Fiction', 'Historical Fiction', 'Fiction'], 305, 'en'),
  ('a0000000-0000-0000-0000-000000000064', '_RM2EAAAQBAJ', 'Cloud Cuckoo Land', array['Anthony Doerr'], array['Literary Fiction', 'Historical Fiction', 'Fiction'], 622, 'en'),

  -- Historical Fiction (065-076)
  ('a0000000-0000-0000-0000-000000000065', 'LPSoCgAAQBAJ', 'The Book Thief', array['Markus Zusak'], array['Historical Fiction', 'Young Adult', 'Fiction'], 552, 'en'),
  ('a0000000-0000-0000-0000-000000000066', 'pId2EAAAQBAJ', 'The Pillars of the Earth', array['Ken Follett'], array['Historical Fiction', 'Fiction'], 973, 'en'),
  ('a0000000-0000-0000-0000-000000000067', 'JEvaBQAAQBAJ', 'All Quiet on the Western Front', array['Erich Maria Remarque'], array['Historical Fiction', 'Fiction', 'Classics'], 296, 'en'),
  ('a0000000-0000-0000-0000-000000000068', 'BL18BgAAQBAJ', 'The Nightingale', array['Kristin Hannah'], array['Historical Fiction', 'Fiction'], 440, 'en'),
  ('a0000000-0000-0000-0000-000000000069', 'FJZODwAAQBAJ', 'The Tattooist of Auschwitz', array['Heather Morris'], array['Historical Fiction', 'Fiction'], 262, 'en'),
  ('a0000000-0000-0000-0000-000000000070', 'sANcBAAAQBAJ', 'Outlander', array['Diana Gabaldon'], array['Historical Fiction', 'Romance', 'Fiction'], 850, 'en'),
  ('a0000000-0000-0000-0000-000000000071', 'Ti5JDwAAQBAJ', 'The Alice Network', array['Kate Quinn'], array['Historical Fiction', 'Fiction'], 496, 'en'),
  ('a0000000-0000-0000-0000-000000000072', '8a0eDQAAQBAJ', 'Shogun', array['James Clavell'], array['Historical Fiction', 'Fiction'], 1152, 'en'),
  ('a0000000-0000-0000-0000-000000000073', 'vfvmSFxHTlYC', 'The Shadow of the Wind', array['Carlos Ruiz Zafon'], array['Historical Fiction', 'Mystery', 'Fiction'], 487, 'en'),
  ('a0000000-0000-0000-0000-000000000074', '0-y-DwAAQBAJ', 'Memoirs of a Geisha', array['Arthur Golden'], array['Historical Fiction', 'Fiction'], 434, 'en'),
  ('a0000000-0000-0000-0000-000000000075', 'AXcOEAAAQBAJ', 'The Help', array['Kathryn Stockett'], array['Historical Fiction', 'Fiction'], 451, 'en'),
  ('a0000000-0000-0000-0000-000000000076', 'OFaHDAAAQBAJ', 'The Name of the Rose', array['Umberto Eco'], array['Historical Fiction', 'Mystery', 'Fiction', 'Classics'], 536, 'en'),

  -- Mystery/Thriller (077-087, first 11)
  ('a0000000-0000-0000-0000-000000000077', 'PGqJDwAAQBAJ', 'The Silent Patient', array['Alex Michaelides'], array['Thriller', 'Mystery', 'Fiction'], 325, 'en'),
  ('a0000000-0000-0000-0000-000000000078', 'HWu_AzVTjJEC', 'And Then There Were None', array['Agatha Christie'], array['Mystery', 'Fiction', 'Classics'], 272, 'en'),
  ('a0000000-0000-0000-0000-000000000079', 'oei5NaGbOR8C', 'The Da Vinci Code', array['Dan Brown'], array['Thriller', 'Mystery', 'Fiction'], 489, 'en'),
  ('a0000000-0000-0000-0000-000000000080', 'rfHkBgAAQBAJ', 'In the Woods', array['Tana French'], array['Mystery', 'Thriller', 'Fiction'], 429, 'en'),
  ('a0000000-0000-0000-0000-000000000081', 'Joj8DwAAQBAJ', 'The Woman in the Window', array['A.J. Finn'], array['Thriller', 'Mystery', 'Fiction'], 449, 'en'),
  ('a0000000-0000-0000-0000-000000000082', 'iqx1DwAAQBAJ', 'My Sister, the Serial Killer', array['Oyinkan Braithwaite'], array['Thriller', 'Fiction'], 226, 'en'),
  ('a0000000-0000-0000-0000-000000000083', 'MhKhIKqBn6kC', 'Rebecca', array['Daphne du Maurier'], array['Mystery', 'Fiction', 'Classics', 'Gothic'], 380, 'en'),
  ('a0000000-0000-0000-0000-000000000084', 'TwRmDwAAQBAJ', 'Sharp Objects', array['Gillian Flynn'], array['Thriller', 'Mystery', 'Fiction'], 254, 'en'),
  ('a0000000-0000-0000-0000-000000000085', 'mN02EAAAQBAJ', 'The Maid', array['Nita Prose'], array['Mystery', 'Fiction'], 304, 'en'),
  ('a0000000-0000-0000-0000-000000000086', 'UGhaDgAAQBAJ', 'One of Us Is Lying', array['Karen M. McManus'], array['Mystery', 'Young Adult', 'Fiction'], 360, 'en'),
  ('a0000000-0000-0000-0000-000000000087', 'twPYDwAAQBAJ', 'The Thursday Murder Club', array['Richard Osman'], array['Mystery', 'Fiction'], 369, 'en')
on conflict (google_books_id) do nothing;
