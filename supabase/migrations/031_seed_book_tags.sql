-- 031: Comprehensively tag 10 books across ALL categories (including Themes)
-- Only adds NEW tags — ON CONFLICT DO NOTHING skips any already-seeded votes

do $$
declare
  sys_user uuid := '00000000-0000-0000-0000-000000000001';
begin

  -- ============================================================
  -- Book 1: Harry Potter (a...001)
  -- Existing: Lighthearted, Fast-Paced, World-Building, Happy Ending, Easy Read, Highly Rereadable
  -- Adding: Hopeful, Funny, Plot-Driven, Must Read in Order, Strong Opener,
  --         Chosen One, Quest/Journey, Coming of Age, Found Family
  -- ============================================================
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'funny')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'chosen-one')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'quest-journey')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000001', (select id from tag_definitions where slug = 'found-family'))
  on conflict do nothing;

  -- ============================================================
  -- Book 2: The Hunger Games (a...026)
  -- Existing: Tense, Fast-Paced, Plot-Driven, Cliffhanger, Easy Read
  -- Adding: Dark, Emotional, Graphic Violence, Highly Rereadable,
  --         Must Read in Order, Strong Opener,
  --         Survival, Chosen One, Enemies to Lovers, Coming of Age
  -- ============================================================
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'survival')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'chosen-one')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'enemies-to-lovers')),
    (sys_user, 'a0000000-0000-0000-0000-000000000026', (select id from tag_definitions where slug = 'coming-of-age'))
  on conflict do nothing;

  -- ============================================================
  -- Book 3: A Game of Thrones (a...005)
  -- Existing: Dark, Slow Burn, World-Building, Graphic Violence, Must Read in Order
  -- Adding: Tense, Emotional, Plot-Driven, Character-Driven, Cliffhanger,
  --         Challenging, Sexual Content, Better on Reread, Strong Opener,
  --         Morally Gray Characters, Secrets & Lies, Revenge
  -- ============================================================
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'plot-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'cliffhanger')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'sexual-content')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'morally-gray-characters')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'secrets-and-lies')),
    (sys_user, 'a0000000-0000-0000-0000-000000000005', (select id from tag_definitions where slug = 'revenge'))
  on conflict do nothing;

  -- ============================================================
  -- Book 4: Gone Girl (a...015)
  -- Existing: Tense, Fast-Paced, Plot-Driven, Twist Ending, Great Standalone
  -- Adding: Dark, Moderate Read, Graphic Violence, Mental Health,
  --         Better on Reread, Unreliable Narrator, Secrets & Lies, Revenge
  -- ============================================================
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'secrets-and-lies')),
    (sys_user, 'a0000000-0000-0000-0000-000000000015', (select id from tag_definitions where slug = 'revenge'))
  on conflict do nothing;

  -- ============================================================
  -- Book 5: Project Hail Mary (a...009)
  -- Existing: Funny, Fast-Paced, Idea-Driven, Hopeful, Great Standalone
  -- Adding: Emotional, Happy Ending, Moderate Read, Highly Rereadable,
  --         Survival, Found Family, Fish Out of Water
  -- ============================================================
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'happy-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'highly-rereadable')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'survival')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'found-family')),
    (sys_user, 'a0000000-0000-0000-0000-000000000009', (select id from tag_definitions where slug = 'fish-out-of-water'))
  on conflict do nothing;

  -- ============================================================
  -- Book 6: Mistborn: The Final Empire (a...004)
  -- Existing: Fast-Paced, World-Building, Plot-Driven, Twist Ending, Moderate Read
  -- Adding: Dark, Hopeful, Tense, Character-Driven, Graphic Violence,
  --         Better on Reread, Strong Opener, Must Read in Order,
  --         Chosen One, Found Family, Redemption Arc
  -- ============================================================
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'strong-opener')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'must-read-in-order')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'chosen-one')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'found-family')),
    (sys_user, 'a0000000-0000-0000-0000-000000000004', (select id from tag_definitions where slug = 'redemption-arc'))
  on conflict do nothing;

  -- ============================================================
  -- Book 7: The Song of Achilles (a...030)
  -- Existing: Emotional, Moderate, Relationship-Focused, Sad Ending, Highly Rereadable
  -- Adding: Melancholy, Character-Driven, Moderate Read, Graphic Violence,
  --         Grief/Loss, Great Standalone,
  --         Forbidden Love, Coming of Age, Quest/Journey
  -- ============================================================
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'forbidden-love')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000030', (select id from tag_definitions where slug = 'quest-journey'))
  on conflict do nothing;

  -- ============================================================
  -- Book 8: The Kite Runner (a...013) — FULLY UNTAGGED
  -- Adding all: Emotional, Dark, Melancholy, Moderate, Character-Driven,
  --   Bittersweet, Moderate Read, Graphic Violence, Mental Health, Grief/Loss,
  --   Better on Reread, Great Standalone,
  --   Redemption Arc, Coming of Age, Secrets & Lies
  -- ============================================================
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'redemption-arc')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000013', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

  -- ============================================================
  -- Book 9: Educated (a...022) — FULLY UNTAGGED
  -- Adding all: Emotional, Dark, Hopeful, Tense, Moderate, Character-Driven,
  --   Bittersweet, Challenging, Mental Health, Graphic Violence, Grief/Loss,
  --   One and Done, Great Standalone,
  --   Coming of Age, Identity/Self-Discovery, Survival
  -- ============================================================
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'emotional')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'hopeful')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'moderate-pace')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'bittersweet')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'challenging')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'graphic-violence')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'grief-loss')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'one-and-done')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'coming-of-age')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000022', (select id from tag_definitions where slug = 'survival'))
  on conflict do nothing;

  -- ============================================================
  -- Book 10: The Haunting of Hill House (a...025) — FULLY UNTAGGED
  -- Adding all: Dark, Tense, Melancholy, Slow Burn, Character-Driven,
  --   Open Ending, Moderate Read, Mental Health,
  --   Better on Reread, Great Standalone,
  --   Unreliable Narrator, Identity/Self-Discovery, Secrets & Lies
  -- ============================================================
  insert into tag_votes (user_id, book_id, tag_id) values
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'dark')),
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'tense')),
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'melancholy')),
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'slow-burn')),
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'character-driven')),
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'open-ending')),
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'moderate-read')),
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'mental-health')),
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'better-on-reread')),
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'great-standalone')),
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'unreliable-narrator')),
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'identity-self-discovery')),
    (sys_user, 'a0000000-0000-0000-0000-000000000025', (select id from tag_definitions where slug = 'secrets-and-lies'))
  on conflict do nothing;

end;
$$;

-- Refresh the materialized view to include new tag votes
refresh materialized view book_tag_counts;
