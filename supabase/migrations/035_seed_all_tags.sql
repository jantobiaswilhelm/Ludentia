-- 035: Comprehensive tags for ALL 200 books
-- Disables triggers during bulk insert, re-enables after, single refresh

alter table tag_votes disable trigger trg_tag_votes_insert_refresh;
alter table tag_votes disable trigger trg_tag_votes_delete_refresh;

do $$
declare
  sys_user uuid := '00000000-0000-0000-0000-000000000001';
begin

  -- ============================================================
  -- EXISTING BOOKS (001-030): Fill in missing tags
  -- Books 001-010 already tagged in 018/031, add remaining coverage
  -- Books 011-030 partially tagged, complete them
  -- ============================================================

  -- 002 LOTR Fellowship — existing: slow-burn, world-building, plot-driven, challenging, must-read-in-order
  -- Adding: dark, hopeful, emotional, literary, better-on-reread, quest-journey, found-family
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000002', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 003 Name of the Wind — existing: slow-burn, character-driven, world-building, challenging, series-gets-better
  -- Adding: emotional, melancholy, open-ending, literary, highly-rereadable, unreliable-narrator, coming-of-age
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000003', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 006 Dune — existing: slow-burn, world-building, idea-driven, challenging, literary
  -- Adding: tense, plot-driven, bittersweet, graphic-violence, better-on-reread, must-read-in-order, chosen-one
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000006', (select id from tag_definitions where slug = 'chosen-one'))
  on conflict do nothing;

  -- 007 1984 — existing: dark, tense, idea-driven, sad-ending, moderate-read
  -- Adding: emotional, plot-driven, great-standalone, highly-rereadable, secrets-and-lies
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000007', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 008 The Martian — existing: funny, fast-paced, idea-driven, happy-ending, easy-read
  -- Adding: hopeful, great-standalone, highly-rereadable, survival
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000008', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 010 Brave New World — FULLY UNTAGGED
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000010', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000010', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000010', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000010', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000010', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000010', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000010', (select id from tag_definitions where slug = 'substance-abuse')),
    (sys_user, 'a0000000-0000-0000-0000-000000000010', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000010', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000010', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 011 The Great Gatsby — FULLY UNTAGGED
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000011', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000011', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000011', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000011', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000011', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000011', (select id from tag_definitions where slug = 'substance-abuse')),
    (sys_user, 'a0000000-0000-0000-0000-000000000011', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000011', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000011', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000011', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000011', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 012 Normal People — existing: emotional, slow-burn, character-driven, relationship-focused, bittersweet
  -- Adding: moderate-read, mental-health, highly-rereadable, great-standalone, coming-of-age, identity-self-discovery
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000012', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 014 A Little Life — existing: dark, emotional, character-driven, sad-ending, challenging, mental-health
  -- Adding: slow-burn, relationship-focused, graphic-violence, substance-abuse, grief-loss, one-and-done, great-standalone, identity-self-discovery
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'substance-abuse')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'one-and-done')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000014', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 016 Girl on the Train — FULLY UNTAGGED
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000016', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000016', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000016', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000016', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000016', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000016', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000016', (select id from tag_definitions where slug = 'substance-abuse')),
    (sys_user, 'a0000000-0000-0000-0000-000000000016', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000016', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000016', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 017 Big Little Lies — FULLY UNTAGGED
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000017', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000017', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000017', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000017', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000017', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000017', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000017', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000017', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 018 Seven Husbands — existing: emotional, moderate-pace, character-driven, bittersweet, highly-rereadable
  -- Adding: great-standalone, literary, secrets-and-lies, forbidden-love, identity-self-discovery
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'secrets-and-lies')),
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'forbidden-love')),
    (sys_user, 'a0000000-0000-0000-0000-000000000018', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 019 Beach Read — existing: lighthearted, funny, relationship-focused, happy-ending, easy-read
  -- Adding: emotional, great-standalone, highly-rereadable, enemies-to-lovers
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000019', (select id from tag_definitions where slug = 'enemies-to-lovers'))
  on conflict do nothing;

  -- 020 People We Meet on Vacation — FULLY UNTAGGED
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000020', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000020', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000020', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000020', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000020', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000020', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000020', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000020', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000020', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000020', (select id from tag_definitions where slug = 'enemies-to-lovers'))
  on conflict do nothing;

  -- 021 Sapiens — FULLY UNTAGGED
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000021', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000021', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000021', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000021', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000021', (select id from tag_definitions where slug = 'one-and-done')),
    (sys_user, 'a0000000-0000-0000-0000-000000000021', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- 023 Becoming — FULLY UNTAGGED
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000023', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000023', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000023', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000023', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000023', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000023', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000023', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000023', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000023', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 024 Mexican Gothic — existing: dark, tense, slow-burn, twist-ending, great-standalone
  -- Adding: character-driven, moderate-read, graphic-violence, secrets-and-lies
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000024', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 027 Percy Jackson — FULLY UNTAGGED
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'chosen-one')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'found-family')),
    (sys_user, 'a0000000-0000-0000-0000-000000000027', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 028 Tomorrow x3 — existing: emotional, moderate-pace, character-driven, bittersweet, great-standalone
  -- Adding: melancholy, relationship-focused, moderate-read, highly-rereadable, grief-loss, identity-self-discovery, coming-of-age
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000028', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 029 Circe — existing: moderate-pace, character-driven, world-building, hopeful, better-on-reread
  -- Adding: emotional, literary, great-standalone, coming-of-age, identity-self-discovery, revenge
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000029', (select id from tag_definitions where slug = 'revenge'))
  on conflict do nothing;

  -- ============================================================
  -- NEW BOOKS (031-200): Full comprehensive tags
  -- ============================================================

  -- 031 The Way of Kings
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'redemption-arc')),
    (sys_user, 'a0000000-0000-0000-0000-000000000031', (select id from tag_definitions where slug = 'chosen-one'))
  on conflict do nothing;

  -- 032 The Hobbit
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000032', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000032', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000032', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000032', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000032', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000032', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000032', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000032', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000032', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000032', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000032', (select id from tag_definitions where slug = 'fish-out-of-water'))
  on conflict do nothing;

  -- 033 Assassin's Apprentice
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000033', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000033', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000033', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000033', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000033', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000033', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000033', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000033', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000033', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000033', (select id from tag_definitions where slug = 'series-gets-better')),
    (sys_user, 'a0000000-0000-0000-0000-000000000033', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000033', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 034 The Fifth Season
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'survival')),
    (sys_user, 'a0000000-0000-0000-0000-000000000034', (select id from tag_definitions where slug = 'morally-gray-characters'))
  on conflict do nothing;

  -- 035 Piranesi
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000035', (select id from tag_definitions where slug = 'cozy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000035', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000035', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000035', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000035', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000035', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000035', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000035', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000035', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000035', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 036 The Priory of the Orange Tree
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000036', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000036', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000036', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000036', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000036', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000036', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000036', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000036', (select id from tag_definitions where slug = 'forbidden-love')),
    (sys_user, 'a0000000-0000-0000-0000-000000000036', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 037 A Wizard of Earthsea
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000037', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000037', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000037', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000037', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000037', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000037', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000037', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000037', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000037', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000037', (select id from tag_definitions where slug = 'quest-journey'))
  on conflict do nothing;

  -- 038 Uprooted
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000038', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000038', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000038', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000038', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000038', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000038', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000038', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000038', (select id from tag_definitions where slug = 'enemies-to-lovers')),
    (sys_user, 'a0000000-0000-0000-0000-000000000038', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000038', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 039 The Night Circus
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000039', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000039', (select id from tag_definitions where slug = 'cozy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000039', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000039', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000039', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000039', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000039', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000039', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000039', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000039', (select id from tag_definitions where slug = 'forbidden-love'))
  on conflict do nothing;

  -- 040 The Lies of Locke Lamora
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000040', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000040', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000040', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000040', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000040', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000040', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000040', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000040', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000040', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000040', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000040', (select id from tag_definitions where slug = 'found-family')),
    (sys_user, 'a0000000-0000-0000-0000-000000000040', (select id from tag_definitions where slug = 'revenge'))
  on conflict do nothing;

  -- 041 An Ember in the Ashes
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000041', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000041', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000041', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000041', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000041', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000041', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000041', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000041', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000041', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000041', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000041', (select id from tag_definitions where slug = 'enemies-to-lovers')),
    (sys_user, 'a0000000-0000-0000-0000-000000000041', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 042 Spinning Silver
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000042', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000042', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000042', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000042', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000042', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000042', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000042', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000042', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000042', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 043 Ender's Game
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000043', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000043', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000043', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000043', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000043', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000043', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000043', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000043', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000043', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000043', (select id from tag_definitions where slug = 'chosen-one')),
    (sys_user, 'a0000000-0000-0000-0000-000000000043', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 044 The Left Hand of Darkness
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000044', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000044', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000044', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000044', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000044', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000044', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000044', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000044', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000044', (select id from tag_definitions where slug = 'fish-out-of-water')),
    (sys_user, 'a0000000-0000-0000-0000-000000000044', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 045 Fahrenheit 451
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000045', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000045', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000045', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000045', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000045', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000045', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000045', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000045', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 046 Hitchhiker's Guide
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000046', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000046', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000046', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000046', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000046', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000046', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000046', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000046', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000046', (select id from tag_definitions where slug = 'fish-out-of-water'))
  on conflict do nothing;

  -- 047 Klara and the Sun
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000047', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000047', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000047', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000047', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000047', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000047', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000047', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000047', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000047', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 048 Red Rising
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000048', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000048', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000048', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000048', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000048', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000048', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000048', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000048', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000048', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000048', (select id from tag_definitions where slug = 'series-gets-better')),
    (sys_user, 'a0000000-0000-0000-0000-000000000048', (select id from tag_definitions where slug = 'revenge')),
    (sys_user, 'a0000000-0000-0000-0000-000000000048', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 049 Slaughterhouse-Five
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000049', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000049', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000049', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000049', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000049', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000049', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000049', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000049', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000049', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000049', (select id from tag_definitions where slug = 'time-loop')),
    (sys_user, 'a0000000-0000-0000-0000-000000000049', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 050 The Handmaid's Tale
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000050', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000050', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000050', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000050', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000050', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000050', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000050', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000050', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000050', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000050', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000050', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 051 Recursion
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000051', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000051', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000051', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000051', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000051', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000051', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000051', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000051', (select id from tag_definitions where slug = 'time-loop')),
    (sys_user, 'a0000000-0000-0000-0000-000000000051', (select id from tag_definitions where slug = 'grief-loss'))
  on conflict do nothing;

  -- 052 Station Eleven
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000052', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000052', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000052', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000052', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000052', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000052', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000052', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000052', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000052', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000052', (select id from tag_definitions where slug = 'survival')),
    (sys_user, 'a0000000-0000-0000-0000-000000000052', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 053 Beloved
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000053', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000053', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000053', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000053', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000053', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000053', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000053', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000053', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000053', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000053', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000053', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000053', (select id from tag_definitions where slug = 'literary'))
  on conflict do nothing;

  -- 054 The Goldfinch
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000054', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000054', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000054', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000054', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000054', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000054', (select id from tag_definitions where slug = 'substance-abuse')),
    (sys_user, 'a0000000-0000-0000-0000-000000000054', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000054', (select id from tag_definitions where slug = 'one-and-done')),
    (sys_user, 'a0000000-0000-0000-0000-000000000054', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000054', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000054', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 055 Where the Crawdads Sing
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000055', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000055', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000055', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000055', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000055', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000055', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000055', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000055', (select id from tag_definitions where slug = 'survival')),
    (sys_user, 'a0000000-0000-0000-0000-000000000055', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 056 Atonement
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000056', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000056', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000056', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000056', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000056', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000056', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000056', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000056', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000056', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000056', (select id from tag_definitions where slug = 'secrets-and-lies')),
    (sys_user, 'a0000000-0000-0000-0000-000000000056', (select id from tag_definitions where slug = 'unreliable-narrator'))
  on conflict do nothing;

  -- 057 The Secret History
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000057', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000057', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000057', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000057', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000057', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000057', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000057', (select id from tag_definitions where slug = 'substance-abuse')),
    (sys_user, 'a0000000-0000-0000-0000-000000000057', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000057', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000057', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000057', (select id from tag_definitions where slug = 'morally-gray-characters')),
    (sys_user, 'a0000000-0000-0000-0000-000000000057', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 058 Pachinko
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000058', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000058', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000058', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000058', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000058', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000058', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000058', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000058', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000058', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000058', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 059 All the Light We Cannot See
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000059', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000059', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000059', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000059', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000059', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000059', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000059', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000059', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000059', (select id from tag_definitions where slug = 'survival')),
    (sys_user, 'a0000000-0000-0000-0000-000000000059', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 060 The Remains of the Day
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000060', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000060', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000060', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000060', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000060', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000060', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000060', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000060', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000060', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000060', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 061 Life of Pi
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000061', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000061', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000061', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000061', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000061', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000061', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000061', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000061', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000061', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000061', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 062 Brief Wondrous Life of Oscar Wao
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000062', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000062', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000062', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000062', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000062', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000062', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000062', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000062', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000062', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000062', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 063 Homegoing
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000063', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000063', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000063', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000063', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000063', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000063', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000063', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000063', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000063', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000063', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 064 Cloud Cuckoo Land
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000064', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000064', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000064', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000064', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000064', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000064', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000064', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000064', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000064', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000064', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- ============================================================
  -- HISTORICAL FICTION (065-076)
  -- ============================================================

  -- 065 The Book Thief
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000065', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 066 The Pillars of the Earth
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000066', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000066', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000066', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000066', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000066', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000066', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000066', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000066', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000066', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000066', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000066', (select id from tag_definitions where slug = 'revenge'))
  on conflict do nothing;

  -- 067 All Quiet on the Western Front
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'survival')),
    (sys_user, 'a0000000-0000-0000-0000-000000000067', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 068 The Nightingale
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000068', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000068', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000068', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000068', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000068', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000068', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000068', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000068', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000068', (select id from tag_definitions where slug = 'survival')),
    (sys_user, 'a0000000-0000-0000-0000-000000000068', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 069 The Tattooist of Auschwitz
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000069', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000069', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000069', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000069', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000069', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000069', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000069', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000069', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000069', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000069', (select id from tag_definitions where slug = 'survival')),
    (sys_user, 'a0000000-0000-0000-0000-000000000069', (select id from tag_definitions where slug = 'forbidden-love'))
  on conflict do nothing;

  -- 070 Outlander
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'fish-out-of-water')),
    (sys_user, 'a0000000-0000-0000-0000-000000000070', (select id from tag_definitions where slug = 'time-loop'))
  on conflict do nothing;

  -- 071 The Alice Network
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000071', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000071', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000071', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000071', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000071', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000071', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000071', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000071', (select id from tag_definitions where slug = 'secrets-and-lies')),
    (sys_user, 'a0000000-0000-0000-0000-000000000071', (select id from tag_definitions where slug = 'revenge'))
  on conflict do nothing;

  -- 072 Shogun
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000072', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000072', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000072', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000072', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000072', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000072', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000072', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000072', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000072', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000072', (select id from tag_definitions where slug = 'fish-out-of-water')),
    (sys_user, 'a0000000-0000-0000-0000-000000000072', (select id from tag_definitions where slug = 'morally-gray-characters'))
  on conflict do nothing;

  -- 073 The Shadow of the Wind
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000073', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000073', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000073', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000073', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000073', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000073', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000073', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000073', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000073', (select id from tag_definitions where slug = 'secrets-and-lies')),
    (sys_user, 'a0000000-0000-0000-0000-000000000073', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 074 Memoirs of a Geisha
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000074', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000074', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000074', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000074', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000074', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000074', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000074', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000074', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000074', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000074', (select id from tag_definitions where slug = 'forbidden-love'))
  on conflict do nothing;

  -- 075 The Help
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000075', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000075', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000075', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000075', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000075', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000075', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000075', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000075', (select id from tag_definitions where slug = 'found-family')),
    (sys_user, 'a0000000-0000-0000-0000-000000000075', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 076 The Name of the Rose
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000076', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000076', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000076', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000076', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000076', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000076', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000076', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000076', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000076', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000076', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- ============================================================
  -- MYSTERY/THRILLER (077-091)
  -- ============================================================

  -- 077 The Silent Patient
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000077', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000077', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000077', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000077', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000077', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000077', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000077', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000077', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000077', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000077', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000077', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 078 And Then There Were None
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000078', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000078', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000078', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000078', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000078', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000078', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000078', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000078', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000078', (select id from tag_definitions where slug = 'secrets-and-lies')),
    (sys_user, 'a0000000-0000-0000-0000-000000000078', (select id from tag_definitions where slug = 'revenge'))
  on conflict do nothing;

  -- 079 The Da Vinci Code
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000079', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000079', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000079', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000079', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000079', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000079', (select id from tag_definitions where slug = 'one-and-done')),
    (sys_user, 'a0000000-0000-0000-0000-000000000079', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000079', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000079', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 080 In the Woods
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000080', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000080', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000080', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000080', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000080', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000080', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000080', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000080', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000080', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000080', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000080', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 081 The Woman in the Window
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000081', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000081', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000081', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000081', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000081', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000081', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000081', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000081', (select id from tag_definitions where slug = 'substance-abuse')),
    (sys_user, 'a0000000-0000-0000-0000-000000000081', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000081', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000081', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 082 My Sister, the Serial Killer
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000082', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000082', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000082', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000082', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000082', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000082', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000082', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000082', (select id from tag_definitions where slug = 'morally-gray-characters')),
    (sys_user, 'a0000000-0000-0000-0000-000000000082', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 083 Rebecca
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000083', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000083', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000083', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000083', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000083', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000083', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000083', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000083', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000083', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000083', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 084 Sharp Objects
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000084', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000084', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000084', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000084', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000084', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000084', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000084', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000084', (select id from tag_definitions where slug = 'substance-abuse')),
    (sys_user, 'a0000000-0000-0000-0000-000000000084', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000084', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000084', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 085 The Maid
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000085', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000085', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000085', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000085', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000085', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000085', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000085', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000085', (select id from tag_definitions where slug = 'found-family')),
    (sys_user, 'a0000000-0000-0000-0000-000000000085', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 086 One of Us Is Lying
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000086', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000086', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000086', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000086', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000086', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000086', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000086', (select id from tag_definitions where slug = 'secrets-and-lies')),
    (sys_user, 'a0000000-0000-0000-0000-000000000086', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 087 The Thursday Murder Club
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000087', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000087', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000087', (select id from tag_definitions where slug = 'cozy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000087', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000087', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000087', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000087', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000087', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000087', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000087', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 088 Verity
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000088', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000088', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000088', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000088', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000088', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000088', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000088', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000088', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000088', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000088', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 089 The Girl with the Dragon Tattoo
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000089', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000089', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000089', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000089', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000089', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000089', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000089', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000089', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000089', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000089', (select id from tag_definitions where slug = 'revenge')),
    (sys_user, 'a0000000-0000-0000-0000-000000000089', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 090 Murder on the Orient Express
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000090', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000090', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000090', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000090', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000090', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000090', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000090', (select id from tag_definitions where slug = 'secrets-and-lies')),
    (sys_user, 'a0000000-0000-0000-0000-000000000090', (select id from tag_definitions where slug = 'morally-gray-characters'))
  on conflict do nothing;

  -- 091 The No. 1 Ladies' Detective Agency
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000091', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000091', (select id from tag_definitions where slug = 'cozy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000091', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000091', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000091', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000091', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000091', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000091', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000091', (select id from tag_definitions where slug = 'strong-opener'))
  on conflict do nothing;

  -- ============================================================
  -- ROMANCE (092-106)
  -- ============================================================

  -- 092 Pride and Prejudice
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000092', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000092', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000092', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000092', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000092', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000092', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000092', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000092', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000092', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000092', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000092', (select id from tag_definitions where slug = 'enemies-to-lovers'))
  on conflict do nothing;

  -- 093 The Notebook
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000093', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000093', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000093', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000093', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000093', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000093', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000093', (select id from tag_definitions where slug = 'one-and-done')),
    (sys_user, 'a0000000-0000-0000-0000-000000000093', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000093', (select id from tag_definitions where slug = 'forbidden-love'))
  on conflict do nothing;

  -- 094 Red, White & Royal Blue
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000094', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000094', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000094', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000094', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000094', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000094', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000094', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000094', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000094', (select id from tag_definitions where slug = 'enemies-to-lovers')),
    (sys_user, 'a0000000-0000-0000-0000-000000000094', (select id from tag_definitions where slug = 'forbidden-love')),
    (sys_user, 'a0000000-0000-0000-0000-000000000094', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 095 It Ends with Us
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000095', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000095', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000095', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000095', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000095', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000095', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000095', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000095', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000095', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000095', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 096 The Hating Game
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000096', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000096', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000096', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000096', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000096', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000096', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000096', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000096', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000096', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000096', (select id from tag_definitions where slug = 'enemies-to-lovers'))
  on conflict do nothing;

  -- 097 The Flatshare
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000097', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000097', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000097', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000097', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000097', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000097', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000097', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000097', (select id from tag_definitions where slug = 'enemies-to-lovers'))
  on conflict do nothing;

  -- 098 Get a Life, Chloe Brown
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000098', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000098', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000098', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000098', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000098', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000098', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000098', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000098', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000098', (select id from tag_definitions where slug = 'enemies-to-lovers'))
  on conflict do nothing;

  -- 099 The Kiss Quotient
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000099', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000099', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000099', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000099', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000099', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000099', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000099', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000099', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000099', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 100 A Court of Thorns and Roses
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000100', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000100', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000100', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000100', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000100', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000100', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000100', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000100', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000100', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000100', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000100', (select id from tag_definitions where slug = 'series-gets-better')),
    (sys_user, 'a0000000-0000-0000-0000-000000000100', (select id from tag_definitions where slug = 'enemies-to-lovers'))
  on conflict do nothing;

  -- 101 The Bromance Book Club
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000101', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000101', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000101', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000101', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000101', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000101', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000101', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000101', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 102 Book Lovers
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000102', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000102', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000102', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000102', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000102', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000102', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000102', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000102', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000102', (select id from tag_definitions where slug = 'enemies-to-lovers'))
  on conflict do nothing;

  -- 103 The Spanish Love Deception
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000103', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000103', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000103', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000103', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000103', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000103', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000103', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000103', (select id from tag_definitions where slug = 'enemies-to-lovers'))
  on conflict do nothing;

  -- 104 One Day
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000104', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000104', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000104', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000104', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000104', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000104', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000104', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000104', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000104', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000104', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 105 The Rosie Project
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000105', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000105', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000105', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000105', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000105', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000105', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000105', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000105', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000105', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000105', (select id from tag_definitions where slug = 'fish-out-of-water'))
  on conflict do nothing;

  -- 106 Me Before You
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000106', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000106', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000106', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000106', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000106', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000106', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000106', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000106', (select id from tag_definitions where slug = 'one-and-done')),
    (sys_user, 'a0000000-0000-0000-0000-000000000106', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- ============================================================
  -- HORROR (107-114)
  -- ============================================================

  -- 107 It
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000107', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000107', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000107', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000107', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000107', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000107', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000107', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000107', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000107', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000107', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000107', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000107', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 108 The Shining
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000108', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000108', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000108', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000108', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000108', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000108', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000108', (select id from tag_definitions where slug = 'substance-abuse')),
    (sys_user, 'a0000000-0000-0000-0000-000000000108', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000108', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000108', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- 109 Frankenstein
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000109', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000109', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000109', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000109', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000109', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000109', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000109', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000109', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000109', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000109', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000109', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000109', (select id from tag_definitions where slug = 'revenge'))
  on conflict do nothing;

  -- 110 Bird Box
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000110', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000110', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000110', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000110', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000110', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000110', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000110', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000110', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 111 House of Leaves
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000111', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000111', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000111', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000111', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000111', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000111', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000111', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000111', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000111', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000111', (select id from tag_definitions where slug = 'unreliable-narrator'))
  on conflict do nothing;

  -- 112 The Exorcist
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000112', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000112', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000112', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000112', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000112', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000112', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000112', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000112', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- 113 Dracula
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000113', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000113', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000113', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000113', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000113', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000113', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000113', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000113', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000113', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000113', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 114 My Best Friend's Exorcism
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000114', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000114', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000114', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000114', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000114', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000114', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000114', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000114', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000114', (select id from tag_definitions where slug = 'found-family')),
    (sys_user, 'a0000000-0000-0000-0000-000000000114', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- ============================================================
  -- NONFICTION (115-129)
  -- ============================================================

  -- 115 Atomic Habits
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000115', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000115', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000115', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000115', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000115', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000115', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- 116 The Diary of a Young Girl
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000116', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000116', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000116', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000116', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000116', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000116', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000116', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000116', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000116', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000116', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000116', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 117 A Brief History of Time
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000117', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000117', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000117', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000117', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000117', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- 118 Born a Crime
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000118', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000118', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000118', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000118', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000118', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000118', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000118', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000118', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000118', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000118', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000118', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 119 The Immortal Life of Henrietta Lacks
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000119', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000119', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000119', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000119', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000119', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000119', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000119', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 120 Thinking, Fast and Slow
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000120', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000120', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000120', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000120', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000120', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- 121 When Breath Becomes Air
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000121', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000121', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000121', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000121', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000121', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000121', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000121', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000121', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000121', (select id from tag_definitions where slug = 'one-and-done')),
    (sys_user, 'a0000000-0000-0000-0000-000000000121', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000121', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 122 Quiet: The Power of Introverts
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000122', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000122', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000122', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000122', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000122', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 123 The Body Keeps the Score
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000123', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000123', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000123', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000123', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000123', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000123', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000123', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000123', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- 124 Just Mercy
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000124', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000124', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000124', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000124', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000124', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000124', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000124', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000124', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000124', (select id from tag_definitions where slug = 'redemption-arc'))
  on conflict do nothing;

  -- 125 Outliers
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000125', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000125', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000125', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000125', (select id from tag_definitions where slug = 'one-and-done')),
    (sys_user, 'a0000000-0000-0000-0000-000000000125', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- 126 The Glass Castle
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000126', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000126', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000126', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000126', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000126', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000126', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000126', (select id from tag_definitions where slug = 'substance-abuse')),
    (sys_user, 'a0000000-0000-0000-0000-000000000126', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000126', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000126', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000126', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 127 I Know Why the Caged Bird Sings
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000127', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 128 Man's Search for Meaning
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000128', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000128', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000128', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000128', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000128', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000128', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000128', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000128', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000128', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000128', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 129 Hidden Figures
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000129', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000129', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000129', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000129', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000129', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000129', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000129', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000129', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- ============================================================
  -- YOUNG ADULT (130-147)
  -- ============================================================

  -- 130 Divergent
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000130', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000130', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000130', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000130', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000130', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000130', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000130', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000130', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000130', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000130', (select id from tag_definitions where slug = 'chosen-one')),
    (sys_user, 'a0000000-0000-0000-0000-000000000130', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 131 The Fault in Our Stars
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000131', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000131', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000131', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000131', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000131', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000131', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000131', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000131', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000131', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000131', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000131', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 132 The Maze Runner
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000132', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000132', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000132', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000132', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000132', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000132', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000132', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000132', (select id from tag_definitions where slug = 'survival')),
    (sys_user, 'a0000000-0000-0000-0000-000000000132', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 133 Twilight
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000133', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000133', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000133', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000133', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000133', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000133', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000133', (select id from tag_definitions where slug = 'forbidden-love')),
    (sys_user, 'a0000000-0000-0000-0000-000000000133', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 134 Children of Blood and Bone
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000134', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000134', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000134', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000134', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000134', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000134', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000134', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000134', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000134', (select id from tag_definitions where slug = 'chosen-one')),
    (sys_user, 'a0000000-0000-0000-0000-000000000134', (select id from tag_definitions where slug = 'quest-journey'))
  on conflict do nothing;

  -- 135 Six of Crows
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000135', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000135', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000135', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000135', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000135', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000135', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000135', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000135', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000135', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000135', (select id from tag_definitions where slug = 'found-family')),
    (sys_user, 'a0000000-0000-0000-0000-000000000135', (select id from tag_definitions where slug = 'morally-gray-characters')),
    (sys_user, 'a0000000-0000-0000-0000-000000000135', (select id from tag_definitions where slug = 'revenge'))
  on conflict do nothing;

  -- 136 The Giver
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000136', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000136', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000136', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000136', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000136', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000136', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000136', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000136', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000136', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000136', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 137 Eleanor & Park
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000137', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000137', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000137', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000137', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000137', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000137', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000137', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000137', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000137', (select id from tag_definitions where slug = 'forbidden-love'))
  on conflict do nothing;

  -- 138 Eragon
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000138', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000138', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000138', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000138', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000138', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000138', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000138', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000138', (select id from tag_definitions where slug = 'chosen-one')),
    (sys_user, 'a0000000-0000-0000-0000-000000000138', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000138', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 139 The Hate U Give
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000139', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000139', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000139', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000139', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000139', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000139', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000139', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000139', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000139', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000139', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000139', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 140 Throne of Glass
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000140', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000140', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000140', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000140', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000140', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000140', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000140', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000140', (select id from tag_definitions where slug = 'series-gets-better')),
    (sys_user, 'a0000000-0000-0000-0000-000000000140', (select id from tag_definitions where slug = 'chosen-one')),
    (sys_user, 'a0000000-0000-0000-0000-000000000140', (select id from tag_definitions where slug = 'enemies-to-lovers'))
  on conflict do nothing;

  -- 141 Shadow and Bone
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000141', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000141', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000141', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000141', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000141', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000141', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000141', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000141', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000141', (select id from tag_definitions where slug = 'chosen-one')),
    (sys_user, 'a0000000-0000-0000-0000-000000000141', (select id from tag_definitions where slug = 'enemies-to-lovers'))
  on conflict do nothing;

  -- 142 The Perks of Being a Wallflower
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000142', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000142', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000142', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000142', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000142', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000142', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000142', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000142', (select id from tag_definitions where slug = 'substance-abuse')),
    (sys_user, 'a0000000-0000-0000-0000-000000000142', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000142', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000142', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000142', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 143 Simon vs. the Homo Sapiens Agenda
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000143', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000143', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000143', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000143', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000143', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000143', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000143', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000143', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000143', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000143', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000143', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 144 We Were Liars
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000144', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000144', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000144', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000144', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000144', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000144', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000144', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000144', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000144', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 145 Sadie
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000145', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000145', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000145', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000145', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000145', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000145', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000145', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000145', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000145', (select id from tag_definitions where slug = 'revenge'))
  on conflict do nothing;

  -- 146 Turtles All the Way Down
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000146', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000146', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000146', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000146', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000146', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000146', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000146', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000146', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000146', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 147 A Darker Shade of Magic
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000147', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000147', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000147', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000147', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000147', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000147', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000147', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000147', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000147', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- ============================================================
  -- MIDDLE GRADE (148-159)
  -- ============================================================

  -- 148 Harry Potter and the Prisoner of Azkaban
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000148', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000148', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000148', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000148', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000148', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000148', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000148', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000148', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000148', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000148', (select id from tag_definitions where slug = 'series-gets-better')),
    (sys_user, 'a0000000-0000-0000-0000-000000000148', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 149 The Lion, the Witch and the Wardrobe
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000149', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000149', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000149', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000149', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000149', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000149', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000149', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000149', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000149', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000149', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000149', (select id from tag_definitions where slug = 'fish-out-of-water'))
  on conflict do nothing;

  -- 150 Matilda
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000150', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000150', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000150', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000150', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000150', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000150', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000150', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000150', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000150', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000150', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 151 Wonder
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000151', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000151', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000151', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000151', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000151', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000151', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000151', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000151', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000151', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000151', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 152-159, 160-179, 180-200: remaining books with compact inserts

  -- 152 Holes
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000152', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000152', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000152', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000152', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000152', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000152', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000152', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000152', (select id from tag_definitions where slug = 'found-family')),
    (sys_user, 'a0000000-0000-0000-0000-000000000152', (select id from tag_definitions where slug = 'redemption-arc'))
  on conflict do nothing;

  -- 153 A Wrinkle in Time
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000153', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000153', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000153', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000153', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000153', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000153', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000153', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000153', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000153', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000153', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 154 The Phantom Tollbooth
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000154', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000154', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000154', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000154', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000154', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000154', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000154', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000154', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000154', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000154', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000154', (select id from tag_definitions where slug = 'fish-out-of-water'))
  on conflict do nothing;

  -- 155 Bridge to Terabithia
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000155', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000155', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000155', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000155', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000155', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000155', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000155', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000155', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000155', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000155', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 156 Hatchet
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000156', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000156', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000156', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000156', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000156', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000156', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000156', (select id from tag_definitions where slug = 'survival')),
    (sys_user, 'a0000000-0000-0000-0000-000000000156', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 157 The One and Only Ivan
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000157', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000157', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000157', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000157', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000157', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000157', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000157', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000157', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 158 Diary of a Wimpy Kid
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000158', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000158', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000158', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000158', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000158', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000158', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000158', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000158', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000158', (select id from tag_definitions where slug = 'unreliable-narrator'))
  on conflict do nothing;

  -- 159 From the Mixed-Up Files of Mrs. Basil E. Frankweiler
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000159', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000159', (select id from tag_definitions where slug = 'cozy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000159', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000159', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000159', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000159', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000159', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000159', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000159', (select id from tag_definitions where slug = 'quest-journey'))
  on conflict do nothing;

  -- ============================================================
  -- CHILDREN'S (160-167)
  -- ============================================================

  -- 160 Charlotte's Web
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000160', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000160', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000160', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000160', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000160', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000160', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000160', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000160', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000160', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000160', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 161 The Secret Garden
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000161', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000161', (select id from tag_definitions where slug = 'cozy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000161', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000161', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000161', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000161', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000161', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000161', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000161', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000161', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 162 Little Women
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000162', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000162', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000162', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000162', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000162', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000162', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000162', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000162', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000162', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000162', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 163 Anne of Green Gables
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000163', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000163', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000163', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000163', (select id from tag_definitions where slug = 'cozy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000163', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000163', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000163', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000163', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000163', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000163', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000163', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000163', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 164 The Wonderful Wizard of Oz
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000164', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000164', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000164', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000164', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000164', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000164', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000164', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000164', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000164', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000164', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 165 James and the Giant Peach
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000165', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000165', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000165', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000165', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000165', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000165', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000165', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000165', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000165', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 166 Stuart Little
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000166', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000166', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000166', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000166', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000166', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000166', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000166', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000166', (select id from tag_definitions where slug = 'fish-out-of-water'))
  on conflict do nothing;

  -- 167 The Wind in the Willows
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000167', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000167', (select id from tag_definitions where slug = 'cozy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000167', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000167', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000167', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000167', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000167', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000167', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000167', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- ============================================================
  -- CONTEMPORARY (168-179)
  -- ============================================================

  -- 168 The Midnight Library
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000168', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000168', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000168', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000168', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000168', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000168', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000168', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000168', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000168', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000168', (select id from tag_definitions where slug = 'time-loop'))
  on conflict do nothing;

  -- 169 Anxious People
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000169', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000169', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000169', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000169', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000169', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000169', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000169', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000169', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000169', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000169', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 170 A Man Called Ove
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000170', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000170', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000170', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000170', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000170', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000170', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000170', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000170', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000170', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000170', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000170', (select id from tag_definitions where slug = 'found-family')),
    (sys_user, 'a0000000-0000-0000-0000-000000000170', (select id from tag_definitions where slug = 'redemption-arc'))
  on conflict do nothing;

  -- 171 Eleanor Oliphant Is Completely Fine
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000171', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000171', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000171', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000171', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000171', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000171', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000171', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000171', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000171', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000171', (select id from tag_definitions where slug = 'found-family')),
    (sys_user, 'a0000000-0000-0000-0000-000000000171', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 172 The House in the Cerulean Sea
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000172', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000172', (select id from tag_definitions where slug = 'cozy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000172', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000172', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000172', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000172', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000172', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000172', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000172', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000172', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 173 Lessons in Chemistry
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000173', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000173', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000173', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000173', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000173', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000173', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000173', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000173', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 174 Before the Coffee Gets Cold
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000174', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000174', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000174', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000174', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000174', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000174', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000174', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000174', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000174', (select id from tag_definitions where slug = 'time-loop'))
  on conflict do nothing;

  -- 175 The Invisible Life of Addie LaRue
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000175', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000175', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000175', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000175', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000175', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000175', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000175', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000175', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000175', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000175', (select id from tag_definitions where slug = 'forbidden-love'))
  on conflict do nothing;

  -- 176 Small Things Like These
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000176', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000176', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000176', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000176', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000176', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000176', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000176', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000176', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000176', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 177 Such a Fun Age
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000177', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000177', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000177', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000177', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000177', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000177', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000177', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000177', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 178 Daisy Jones & The Six
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000178', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000178', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000178', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000178', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000178', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000178', (select id from tag_definitions where slug = 'substance-abuse')),
    (sys_user, 'a0000000-0000-0000-0000-000000000178', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000178', (select id from tag_definitions where slug = 'secrets-and-lies')),
    (sys_user, 'a0000000-0000-0000-0000-000000000178', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 179 The Vanishing Half
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000179', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000179', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000179', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000179', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000179', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000179', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000179', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000179', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000179', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- ============================================================
  -- GRAPHIC NOVELS (180-184)
  -- ============================================================

  -- 180 Maus
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000180', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000180', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000180', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000180', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000180', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000180', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000180', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000180', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000180', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000180', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000180', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 181 Persepolis
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000181', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000181', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000181', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000181', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000181', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000181', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000181', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000181', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000181', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000181', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 182 Watchmen
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000182', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000182', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000182', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000182', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000182', (select id from tag_definitions where slug = 'twist-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000182', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000182', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000182', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000182', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000182', (select id from tag_definitions where slug = 'morally-gray-characters'))
  on conflict do nothing;

  -- 183 Saga, Vol. 1
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'forbidden-love')),
    (sys_user, 'a0000000-0000-0000-0000-000000000183', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- 184 Fun Home
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000184', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000184', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000184', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000184', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000184', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000184', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000184', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000184', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000184', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000184', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000184', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- ============================================================
  -- POETRY / SHORT STORIES (185-188)
  -- ============================================================

  -- 185 Milk and Honey
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000185', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000185', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000185', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000185', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000185', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000185', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000185', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000185', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000185', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 186 The House on Mango Street
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000186', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000186', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000186', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000186', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000186', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000186', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000186', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000186', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000186', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000186', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000186', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 187 Where the Sidewalk Ends
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000187', (select id from tag_definitions where slug = 'lighthearted')),
    (sys_user, 'a0000000-0000-0000-0000-000000000187', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000187', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000187', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000187', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000187', (select id from tag_definitions where slug = 'great-standalone'))
  on conflict do nothing;

  -- 188 Interpreter of Maladies
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000188', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000188', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000188', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000188', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000188', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000188', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000188', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000188', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000188', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000188', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000188', (select id from tag_definitions where slug = 'fish-out-of-water'))
  on conflict do nothing;

  -- ============================================================
  -- CLASSICS (189-200)
  -- ============================================================

  -- 189 To Kill a Mockingbird
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000189', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000189', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000189', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000189', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000189', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000189', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000189', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000189', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000189', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000189', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- 190 Jane Eyre
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000190', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000190', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000190', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000190', (select id from tag_definitions where slug = 'relationship-focused')),
    (sys_user, 'a0000000-0000-0000-0000-000000000190', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000190', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000190', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000190', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000190', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000190', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000190', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- 191 Wuthering Heights
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000191', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000191', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000191', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000191', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000191', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000191', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000191', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000191', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000191', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000191', (select id from tag_definitions where slug = 'revenge')),
    (sys_user, 'a0000000-0000-0000-0000-000000000191', (select id from tag_definitions where slug = 'forbidden-love'))
  on conflict do nothing;

  -- 192 The Catcher in the Rye
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000192', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000192', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000192', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000192', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000192', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000192', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000192', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000192', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000192', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000192', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000192', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 193 One Hundred Years of Solitude
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000193', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000193', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000193', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000193', (select id from tag_definitions where slug = 'world-building')),
    (sys_user, 'a0000000-0000-0000-0000-000000000193', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000193', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000193', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000193', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000193', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000193', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000193', (select id from tag_definitions where slug = 'time-loop'))
  on conflict do nothing;

  -- 194 Animal Farm
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000194', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000194', (select id from tag_definitions where slug = 'fast-paced')),
    (sys_user, 'a0000000-0000-0000-0000-000000000194', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000194', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000194', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000194', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000194', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000194', (select id from tag_definitions where slug = 'morally-gray-characters'))
  on conflict do nothing;

  -- 195 Lord of the Flies
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000195', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000195', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000195', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000195', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000195', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000195', (select id from tag_definitions where slug = 'easy-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000195', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000195', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000195', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000195', (select id from tag_definitions where slug = 'survival')),
    (sys_user, 'a0000000-0000-0000-0000-000000000195', (select id from tag_definitions where slug = 'morally-gray-characters'))
  on conflict do nothing;

  -- 196 The Picture of Dorian Gray
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000196', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000196', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000196', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000196', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000196', (select id from tag_definitions where slug = 'sad-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000196', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000196', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000196', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000196', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000196', (select id from tag_definitions where slug = 'morally-gray-characters')),
    (sys_user, 'a0000000-0000-0000-0000-000000000196', (select id from tag_definitions where slug = 'identity-self-discovery'))
  on conflict do nothing;

  -- 197 Great Expectations
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000197', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000197', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000197', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000197', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000197', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000197', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000197', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000197', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000197', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000197', (select id from tag_definitions where slug = 'redemption-arc'))
  on conflict do nothing;

  -- 198 Catch-22
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000198', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000198', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000198', (select id from tag_definitions where slug = 'uneven-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000198', (select id from tag_definitions where slug = 'idea-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000198', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000198', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000198', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000198', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000198', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000198', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000198', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- 199 The Count of Monte Cristo
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000199', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000199', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000199', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000199', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000199', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000199', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000199', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000199', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000199', (select id from tag_definitions where slug = 'revenge')),
    (sys_user, 'a0000000-0000-0000-0000-000000000199', (select id from tag_definitions where slug = 'morally-gray-characters')),
    (sys_user, 'a0000000-0000-0000-0000-000000000199', (select id from tag_definitions where slug = 'redemption-arc'))
  on conflict do nothing;

  -- 200 Don Quixote
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000200', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000200', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000200', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000200', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000200', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000200', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000200', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000200', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000200', (select id from tag_definitions where slug = 'literary')),
    (sys_user, 'a0000000-0000-0000-0000-000000000200', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000200', (select id from tag_definitions where slug = 'fish-out-of-water'))
  on conflict do nothing;

end;
$$;

-- Re-enable triggers and refresh materialized view
alter table tag_votes enable trigger trg_tag_votes_insert_refresh;
alter table tag_votes enable trigger trg_tag_votes_delete_refresh;
refresh materialized view book_tag_counts;
