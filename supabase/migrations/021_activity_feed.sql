CREATE OR REPLACE FUNCTION get_activity_feed(
  p_user_id uuid,
  p_limit int DEFAULT 20,
  p_before timestamptz DEFAULT now()
)
RETURNS TABLE (
  event_id uuid,
  event_type text,
  user_id uuid,
  book_id uuid,
  event_data jsonb,
  created_at timestamptz
) LANGUAGE sql STABLE AS $$
  -- Book logs from followed users (public visibility)
  SELECT bl.id, 'log'::text, bl.user_id, bl.book_id,
    jsonb_build_object(
      'rating', bl.rating,
      'review_text', bl.review_text,
      'contains_spoilers', bl.contains_spoilers,
      'is_reread', bl.is_reread
    ),
    bl.created_at
  FROM book_logs bl
  JOIN follows f ON f.following_id = bl.user_id AND f.follower_id = p_user_id
  WHERE bl.visibility = 'public' AND bl.created_at < p_before

  UNION ALL

  -- Diary entries from followed users (public visibility)
  SELECT de.id, 'diary'::text, de.user_id, de.book_id,
    jsonb_build_object(
      'entry_text', de.entry_text,
      'page_at', de.page_at,
      'is_spoiler', de.is_spoiler
    ),
    de.created_at
  FROM diary_entries de
  JOIN follows f ON f.following_id = de.user_id AND f.follower_id = p_user_id
  WHERE de.visibility = 'public' AND de.created_at < p_before

  UNION ALL

  -- Shelf additions from followed users
  SELECT ub.id, 'shelf'::text, ub.user_id, ub.book_id,
    jsonb_build_object('shelf', ub.shelf),
    ub.added_at
  FROM user_bookshelves ub
  JOIN follows f ON f.following_id = ub.user_id AND f.follower_id = p_user_id
  WHERE ub.added_at < p_before

  ORDER BY created_at DESC
  LIMIT p_limit;
$$;
