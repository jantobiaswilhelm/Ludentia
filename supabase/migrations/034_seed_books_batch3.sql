-- 034: Seed books batch 3 — YA (rest), Middle Grade, Children's, Contemporary, Graphic Novels, Poetry, Classics
-- Books 145-200 (56 books)

insert into books (id, google_books_id, title, authors, categories, page_count, language)
values
  -- Young Adult (145-147, remaining 3)
  ('a0000000-0000-0000-0000-000000000145', 'kIFnDwAAQBAJ', 'Sadie', array['Courtney Summers'], array['Young Adult', 'Mystery', 'Fiction'], 312, 'en'),
  ('a0000000-0000-0000-0000-000000000146', '4gJaDgAAQBAJ', 'Turtles All the Way Down', array['John Green'], array['Young Adult', 'Fiction'], 286, 'en'),
  ('a0000000-0000-0000-0000-000000000147', 'nUPJBQAAQBAJ', 'A Darker Shade of Magic', array['V.E. Schwab'], array['Fantasy', 'Young Adult', 'Fiction'], 400, 'en'),

  -- Middle Grade (148-159)
  ('a0000000-0000-0000-0000-000000000148', 'ioaEPgAACAAJ', 'Harry Potter and the Prisoner of Azkaban', array['J.K. Rowling'], array['Fantasy', 'Fiction', 'Middle Grade'], 435, 'en'),
  ('a0000000-0000-0000-0000-000000000149', 'dOIJYJFkx-QC', 'The Lion, the Witch and the Wardrobe', array['C.S. Lewis'], array['Fantasy', 'Fiction', 'Middle Grade', 'Classics'], 206, 'en'),
  ('a0000000-0000-0000-0000-000000000150', 'BoqhzgEACAAJ', 'Matilda', array['Roald Dahl'], array['Fiction', 'Middle Grade'], 240, 'en'),
  ('a0000000-0000-0000-0000-000000000151', 'wJ0UrgEACAAJ', 'Wonder', array['R.J. Palacio'], array['Fiction', 'Middle Grade'], 315, 'en'),
  ('a0000000-0000-0000-0000-000000000152', '36wJAQAAMAAJ', 'Holes', array['Louis Sachar'], array['Fiction', 'Middle Grade'], 233, 'en'),
  ('a0000000-0000-0000-0000-000000000153', 'r119fkc63WIC', 'A Wrinkle in Time', array['Madeleine L''Engle'], array['Science Fiction', 'Fiction', 'Middle Grade', 'Classics'], 256, 'en'),
  ('a0000000-0000-0000-0000-000000000154', 'RhUXRPSbKdEC', 'The Phantom Tollbooth', array['Norton Juster'], array['Fantasy', 'Fiction', 'Middle Grade', 'Classics'], 255, 'en'),
  ('a0000000-0000-0000-0000-000000000155', 'LPBaDwAAQBAJ', 'Bridge to Terabithia', array['Katherine Paterson'], array['Fiction', 'Middle Grade'], 163, 'en'),
  ('a0000000-0000-0000-0000-000000000156', 'hOUrAAAAYAAJ', 'Hatchet', array['Gary Paulsen'], array['Fiction', 'Middle Grade'], 195, 'en'),
  ('a0000000-0000-0000-0000-000000000157', 'FhMPfuAAEYQC', 'The One and Only Ivan', array['Katherine Applegate'], array['Fiction', 'Middle Grade'], 305, 'en'),
  ('a0000000-0000-0000-0000-000000000158', 'btaODQAAQBAJ', 'Diary of a Wimpy Kid', array['Jeff Kinney'], array['Fiction', 'Middle Grade', 'Humor'], 217, 'en'),
  ('a0000000-0000-0000-0000-000000000159', 'lJflBAAAQBAJ', 'From the Mixed-Up Files of Mrs. Basil E. Frankweiler', array['E.L. Konigsburg'], array['Fiction', 'Middle Grade', 'Classics'], 162, 'en'),

  -- Children's (160-167)
  ('a0000000-0000-0000-0000-000000000160', 'HkdSkQEACAAJ', 'Charlotte''s Web', array['E.B. White'], array['Fiction', 'Children''s', 'Classics'], 184, 'en'),
  ('a0000000-0000-0000-0000-000000000161', 'ZDnMDQAAQBAJ', 'The Secret Garden', array['Frances Hodgson Burnett'], array['Fiction', 'Children''s', 'Classics'], 331, 'en'),
  ('a0000000-0000-0000-0000-000000000162', 'mMbJDwAAQBAJ', 'Little Women', array['Louisa May Alcott'], array['Fiction', 'Children''s', 'Classics'], 449, 'en'),
  ('a0000000-0000-0000-0000-000000000163', 'KBa3CAAAQBAJ', 'Anne of Green Gables', array['L.M. Montgomery'], array['Fiction', 'Children''s', 'Classics'], 320, 'en'),
  ('a0000000-0000-0000-0000-000000000164', 'LFOYBwAAQBAJ', 'The Wonderful Wizard of Oz', array['L. Frank Baum'], array['Fantasy', 'Fiction', 'Children''s', 'Classics'], 259, 'en'),
  ('a0000000-0000-0000-0000-000000000165', '0fmYDQAAQBAJ', 'James and the Giant Peach', array['Roald Dahl'], array['Fiction', 'Children''s'], 146, 'en'),
  ('a0000000-0000-0000-0000-000000000166', '1aMi_x-OBUEC', 'Stuart Little', array['E.B. White'], array['Fiction', 'Children''s', 'Classics'], 131, 'en'),
  ('a0000000-0000-0000-0000-000000000167', 'FOrHPQAACAAJ', 'The Wind in the Willows', array['Kenneth Grahame'], array['Fiction', 'Children''s', 'Classics'], 313, 'en'),

  -- Contemporary (168-179)
  ('a0000000-0000-0000-0000-000000000168', 'pgJeDwAAQBAJ', 'The Midnight Library', array['Matt Haig'], array['Fiction', 'Literary Fiction'], 288, 'en'),
  ('a0000000-0000-0000-0000-000000000169', '_lIgEAAAQBAJ', 'Anxious People', array['Fredrik Backman'], array['Fiction', 'Mystery'], 341, 'en'),
  ('a0000000-0000-0000-0000-000000000170', 'eVtGrgEACAAJ', 'A Man Called Ove', array['Fredrik Backman'], array['Fiction', 'Literary Fiction'], 337, 'en'),
  ('a0000000-0000-0000-0000-000000000171', 'HKcIDgAAQBAJ', 'Eleanor Oliphant Is Completely Fine', array['Gail Honeyman'], array['Fiction', 'Literary Fiction'], 327, 'en'),
  ('a0000000-0000-0000-0000-000000000172', '9_EfEAAAQBAJ', 'The House in the Cerulean Sea', array['TJ Klune'], array['Fantasy', 'Fiction'], 396, 'en'),
  ('a0000000-0000-0000-0000-000000000173', 'xQhCEAAAQBAJ', 'Lessons in Chemistry', array['Bonnie Garmus'], array['Fiction', 'Historical Fiction'], 400, 'en'),
  ('a0000000-0000-0000-0000-000000000174', 'aPw_DwAAQBAJ', 'Before the Coffee Gets Cold', array['Toshikazu Kawaguchi'], array['Fiction', 'Fantasy'], 213, 'en'),
  ('a0000000-0000-0000-0000-000000000175', 'bxj9DwAAQBAJ', 'The Invisible Life of Addie LaRue', array['V.E. Schwab'], array['Fantasy', 'Fiction'], 448, 'en'),
  ('a0000000-0000-0000-0000-000000000176', 'n3FJEAAAQBAJ', 'Small Things Like These', array['Claire Keegan'], array['Fiction', 'Historical Fiction'], 116, 'en'),
  ('a0000000-0000-0000-0000-000000000177', 'oYexDwAAQBAJ', 'Such a Fun Age', array['Kiley Reid'], array['Fiction', 'Literary Fiction'], 310, 'en'),
  ('a0000000-0000-0000-0000-000000000178', 'XpZfDwAAQBAJ', 'Daisy Jones & The Six', array['Taylor Jenkins Reid'], array['Fiction', 'Historical Fiction'], 355, 'en'),
  ('a0000000-0000-0000-0000-000000000179', '4hIhEAAAQBAJ', 'The Vanishing Half', array['Brit Bennett'], array['Fiction', 'Literary Fiction', 'Historical Fiction'], 343, 'en'),

  -- Graphic Novels (180-184)
  ('a0000000-0000-0000-0000-000000000180', 'sxvmDwAAQBAJ', 'Maus', array['Art Spiegelman'], array['Graphic Novel', 'Nonfiction', 'Memoir'], 296, 'en'),
  ('a0000000-0000-0000-0000-000000000181', 'cNYOBDlVZJQC', 'Persepolis', array['Marjane Satrapi'], array['Graphic Novel', 'Nonfiction', 'Memoir'], 153, 'en'),
  ('a0000000-0000-0000-0000-000000000182', 'VjXNDwAAQBAJ', 'Watchmen', array['Alan Moore'], array['Graphic Novel', 'Science Fiction', 'Fiction'], 416, 'en'),
  ('a0000000-0000-0000-0000-000000000183', 'FLUjDwAAQBAJ', 'Saga, Vol. 1', array['Brian K. Vaughan'], array['Graphic Novel', 'Science Fiction', 'Fantasy', 'Fiction'], 160, 'en'),
  ('a0000000-0000-0000-0000-000000000184', 'eq0n0GYkGZMC', 'Fun Home', array['Alison Bechdel'], array['Graphic Novel', 'Nonfiction', 'Memoir'], 232, 'en'),

  -- Poetry/Short Stories (185-188)
  ('a0000000-0000-0000-0000-000000000185', 'tBEfCAAAQBAJ', 'Milk and Honey', array['Rupi Kaur'], array['Poetry'], 204, 'en'),
  ('a0000000-0000-0000-0000-000000000186', 'lR5UBAAAQBAJ', 'The House on Mango Street', array['Sandra Cisneros'], array['Fiction', 'Short Stories'], 103, 'en'),
  ('a0000000-0000-0000-0000-000000000187', 'BaPg5IuScVIC', 'Where the Sidewalk Ends', array['Shel Silverstein'], array['Poetry', 'Children''s'], 176, 'en'),
  ('a0000000-0000-0000-0000-000000000188', 'VJjdGO4oYS4C', 'Interpreter of Maladies', array['Jhumpa Lahiri'], array['Fiction', 'Short Stories', 'Literary Fiction'], 198, 'en'),

  -- Classics (189-200)
  ('a0000000-0000-0000-0000-000000000189', 'kIR-DwAAQBAJ', 'To Kill a Mockingbird', array['Harper Lee'], array['Fiction', 'Classics', 'Literary Fiction'], 281, 'en'),
  ('a0000000-0000-0000-0000-000000000190', 'ZjNcSAAACAAJ', 'Jane Eyre', array['Charlotte Bronte'], array['Fiction', 'Classics', 'Romance', 'Gothic'], 507, 'en'),
  ('a0000000-0000-0000-0000-000000000191', '_sAvAwAAQBAJ', 'Wuthering Heights', array['Emily Bronte'], array['Fiction', 'Classics', 'Romance', 'Gothic'], 416, 'en'),
  ('a0000000-0000-0000-0000-000000000192', 'WJbfQQAACAAJ', 'The Catcher in the Rye', array['J.D. Salinger'], array['Fiction', 'Classics', 'Literary Fiction'], 234, 'en'),
  ('a0000000-0000-0000-0000-000000000193', 'OmLDAlIFLGoC', 'One Hundred Years of Solitude', array['Gabriel Garcia Marquez'], array['Fiction', 'Classics', 'Literary Fiction'], 417, 'en'),
  ('a0000000-0000-0000-0000-000000000194', 'nCalECCSi98C', 'Animal Farm', array['George Orwell'], array['Fiction', 'Classics', 'Political'], 141, 'en'),
  ('a0000000-0000-0000-0000-000000000195', '2HiVDwAAQBAJ', 'Lord of the Flies', array['William Golding'], array['Fiction', 'Classics', 'Literary Fiction'], 224, 'en'),
  ('a0000000-0000-0000-0000-000000000196', 'IfXqAAAAMAAJ', 'The Picture of Dorian Gray', array['Oscar Wilde'], array['Fiction', 'Classics', 'Gothic'], 272, 'en'),
  ('a0000000-0000-0000-0000-000000000197', 'GIhJAAAAYAAJ', 'Great Expectations', array['Charles Dickens'], array['Fiction', 'Classics', 'Literary Fiction'], 544, 'en'),
  ('a0000000-0000-0000-0000-000000000198', 'Xfze51E-au4C', 'Catch-22', array['Joseph Heller'], array['Fiction', 'Classics', 'Literary Fiction'], 453, 'en'),
  ('a0000000-0000-0000-0000-000000000199', 'UWn9RrHPjIUC', 'The Count of Monte Cristo', array['Alexandre Dumas'], array['Fiction', 'Classics'], 1276, 'en'),
  ('a0000000-0000-0000-0000-000000000200', '3QOLAAAACAAJ', 'Don Quixote', array['Miguel de Cervantes'], array['Fiction', 'Classics', 'Literary Fiction'], 982, 'en')
on conflict (google_books_id) do nothing;
