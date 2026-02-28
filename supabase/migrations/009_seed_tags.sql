-- Seed 37 official tags across 8 categories
insert into tag_definitions (label, slug, category, color, is_official, sort_order) values
  -- Pacing (4)
  ('Slow Burn', 'slow-burn', 'Pacing', 'orange', true, 1),
  ('Moderate', 'moderate-pace', 'Pacing', 'orange', true, 2),
  ('Fast-Paced', 'fast-paced', 'Pacing', 'orange', true, 3),
  ('Uneven', 'uneven-pace', 'Pacing', 'orange', true, 4),
  -- Mood (8)
  ('Dark', 'dark', 'Mood', 'purple', true, 10),
  ('Lighthearted', 'lighthearted', 'Mood', 'yellow', true, 11),
  ('Emotional', 'emotional', 'Mood', 'pink', true, 12),
  ('Tense', 'tense', 'Mood', 'red', true, 13),
  ('Hopeful', 'hopeful', 'Mood', 'green', true, 14),
  ('Funny', 'funny', 'Mood', 'yellow', true, 15),
  ('Melancholy', 'melancholy', 'Mood', 'blue', true, 16),
  ('Cozy', 'cozy', 'Mood', 'brown', true, 17),
  -- Story Focus (5)
  ('Plot-Driven', 'plot-driven', 'Story Focus', 'blue', true, 20),
  ('Character-Driven', 'character-driven', 'Story Focus', 'blue', true, 21),
  ('World-Building', 'world-building', 'Story Focus', 'blue', true, 22),
  ('Idea-Driven', 'idea-driven', 'Story Focus', 'blue', true, 23),
  ('Relationship-Focused', 'relationship-focused', 'Story Focus', 'blue', true, 24),
  -- Ending (6)
  ('Happy Ending', 'happy-ending', 'Ending', 'green', true, 30),
  ('Sad Ending', 'sad-ending', 'Ending', 'red', true, 31),
  ('Open Ending', 'open-ending', 'Ending', 'gray', true, 32),
  ('Twist Ending', 'twist-ending', 'Ending', 'purple', true, 33),
  ('Bittersweet', 'bittersweet', 'Ending', 'pink', true, 34),
  ('Cliffhanger', 'cliffhanger', 'Ending', 'orange', true, 35),
  -- Difficulty (4)
  ('Easy Read', 'easy-read', 'Difficulty', 'green', true, 40),
  ('Moderate Read', 'moderate-read', 'Difficulty', 'yellow', true, 41),
  ('Challenging', 'challenging', 'Difficulty', 'orange', true, 42),
  ('Literary', 'literary', 'Difficulty', 'red', true, 43),
  -- Content Warnings (5)
  ('Graphic Violence', 'graphic-violence', 'Content Warnings', 'red', true, 50),
  ('Sexual Content', 'sexual-content', 'Content Warnings', 'red', true, 51),
  ('Mental Health', 'mental-health', 'Content Warnings', 'red', true, 52),
  ('Substance Abuse', 'substance-abuse', 'Content Warnings', 'red', true, 53),
  ('Grief/Loss', 'grief-loss', 'Content Warnings', 'red', true, 54),
  -- Rereadability (3)
  ('Highly Rereadable', 'highly-rereadable', 'Rereadability', 'green', true, 60),
  ('One and Done', 'one-and-done', 'Rereadability', 'gray', true, 61),
  ('Better on Reread', 'better-on-reread', 'Rereadability', 'blue', true, 62),
  -- Series (4)
  ('Great Standalone', 'great-standalone', 'Series', 'green', true, 70),
  ('Must Read in Order', 'must-read-in-order', 'Series', 'orange', true, 71),
  ('Series Gets Better', 'series-gets-better', 'Series', 'blue', true, 72),
  ('Strong Opener', 'strong-opener', 'Series', 'purple', true, 73)
on conflict (slug) do nothing;
