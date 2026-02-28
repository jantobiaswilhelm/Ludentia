CREATE TABLE discussion_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id uuid NOT NULL REFERENCES books ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES profiles ON DELETE CASCADE,
  parent_id uuid REFERENCES discussion_comments ON DELETE CASCADE,
  comment_text text NOT NULL CHECK (char_length(comment_text) BETWEEN 1 AND 2000),
  contains_spoilers boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_disc_book ON discussion_comments(book_id, created_at DESC);
CREATE INDEX idx_disc_parent ON discussion_comments(parent_id);

ALTER TABLE discussion_comments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Comments readable" ON discussion_comments FOR SELECT USING (true);
CREATE POLICY "Auth users can comment" ON discussion_comments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users manage own comments" ON discussion_comments FOR ALL USING (auth.uid() = user_id);

-- Threaded comments RPC (top-level + 1 level of replies)
CREATE OR REPLACE FUNCTION get_book_discussions(p_book_id uuid, p_limit int DEFAULT 20, p_offset int DEFAULT 0)
RETURNS jsonb LANGUAGE plpgsql STABLE AS $$
DECLARE result jsonb;
BEGIN
  WITH top AS (
    SELECT dc.id, dc.user_id, dc.comment_text, dc.contains_spoilers, dc.created_at,
      p.username, p.display_name, p.avatar_url
    FROM discussion_comments dc JOIN profiles p ON p.id = dc.user_id
    WHERE dc.book_id = p_book_id AND dc.parent_id IS NULL
    ORDER BY dc.created_at DESC LIMIT p_limit OFFSET p_offset
  ),
  replies AS (
    SELECT dc.id, dc.user_id, dc.parent_id, dc.comment_text, dc.contains_spoilers, dc.created_at,
      p.username, p.display_name, p.avatar_url
    FROM discussion_comments dc JOIN profiles p ON p.id = dc.user_id
    WHERE dc.parent_id IN (SELECT t.id FROM top t)
    ORDER BY dc.created_at ASC
  ),
  cnt AS (SELECT count(*) AS total FROM discussion_comments WHERE book_id = p_book_id AND parent_id IS NULL)
  SELECT jsonb_build_object(
    'total', (SELECT total FROM cnt),
    'comments', coalesce((
      SELECT jsonb_agg(jsonb_build_object(
        'id', t.id, 'user_id', t.user_id, 'username', t.username, 'display_name', t.display_name,
        'avatar_url', t.avatar_url, 'comment_text', t.comment_text, 'contains_spoilers', t.contains_spoilers,
        'created_at', t.created_at,
        'replies', coalesce((
          SELECT jsonb_agg(jsonb_build_object(
            'id', r.id, 'user_id', r.user_id, 'username', r.username, 'display_name', r.display_name,
            'avatar_url', r.avatar_url, 'comment_text', r.comment_text, 'contains_spoilers', r.contains_spoilers,
            'created_at', r.created_at
          ) ORDER BY r.created_at) FROM replies r WHERE r.parent_id = t.id
        ), '[]'::jsonb)
      )) FROM top t
    ), '[]'::jsonb)
  ) INTO result;
  RETURN result;
END; $$;
