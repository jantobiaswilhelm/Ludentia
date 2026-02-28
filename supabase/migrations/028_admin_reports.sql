-- Admin role flag
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS is_admin boolean NOT NULL DEFAULT false;

-- Reported content
CREATE TABLE reported_content (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_id uuid NOT NULL REFERENCES profiles ON DELETE CASCADE,
  content_type text NOT NULL CHECK (content_type IN ('comment', 'review', 'diary', 'list', 'tag')),
  content_id uuid NOT NULL,
  reason text NOT NULL CHECK (char_length(reason) BETWEEN 1 AND 500),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'actioned', 'dismissed')),
  admin_notes text,
  resolved_by uuid REFERENCES profiles,
  created_at timestamptz NOT NULL DEFAULT now(),
  resolved_at timestamptz
);
CREATE INDEX idx_reports_status ON reported_content(status, created_at DESC);

ALTER TABLE reported_content ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can report" ON reported_content FOR INSERT WITH CHECK (auth.uid() = reporter_id);
CREATE POLICY "Users see own reports" ON reported_content FOR SELECT USING (auth.uid() = reporter_id);
CREATE POLICY "Admins see all reports" ON reported_content FOR SELECT USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true)
);
CREATE POLICY "Admins manage reports" ON reported_content FOR UPDATE USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true)
);

-- Admin: list reported content with reporter info
CREATE OR REPLACE FUNCTION get_reported_content(p_status text DEFAULT 'pending', p_limit int DEFAULT 50)
RETURNS jsonb LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
DECLARE result jsonb;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  SELECT coalesce(jsonb_agg(jsonb_build_object(
    'id', r.id, 'content_type', r.content_type, 'content_id', r.content_id,
    'reason', r.reason, 'status', r.status, 'admin_notes', r.admin_notes,
    'created_at', r.created_at,
    'reporter', jsonb_build_object('id', p.id, 'username', p.username, 'display_name', p.display_name)
  )), '[]'::jsonb) INTO result
  FROM reported_content r JOIN profiles p ON p.id = r.reporter_id
  WHERE r.status = p_status ORDER BY r.created_at DESC LIMIT p_limit;
  RETURN result;
END; $$;

-- Admin: get basic user list
CREATE OR REPLACE FUNCTION admin_get_users(p_search text DEFAULT '', p_limit int DEFAULT 50, p_offset int DEFAULT 0)
RETURNS jsonb LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
DECLARE result jsonb;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  SELECT jsonb_build_object(
    'total', (SELECT count(*) FROM profiles WHERE p_search = '' OR username ILIKE '%' || p_search || '%' OR display_name ILIKE '%' || p_search || '%'),
    'users', coalesce((
      SELECT jsonb_agg(jsonb_build_object(
        'id', p.id, 'username', p.username, 'display_name', p.display_name,
        'avatar_url', p.avatar_url, 'is_admin', p.is_admin, 'created_at', p.created_at,
        'books_logged', (SELECT count(*) FROM book_logs bl WHERE bl.user_id = p.id)
      ) ORDER BY p.created_at DESC)
      FROM profiles p
      WHERE p_search = '' OR p.username ILIKE '%' || p_search || '%' OR p.display_name ILIKE '%' || p_search || '%'
      LIMIT p_limit OFFSET p_offset
    ), '[]'::jsonb)
  ) INTO result;
  RETURN result;
END; $$;

-- Admin: get tag moderation data (tags with counts, sorted by votes)
CREATE OR REPLACE FUNCTION admin_get_tags(p_limit int DEFAULT 100)
RETURNS jsonb LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
DECLARE result jsonb;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  SELECT coalesce(jsonb_agg(jsonb_build_object(
    'id', td.id, 'label', td.label, 'slug', td.slug, 'category', td.category,
    'is_official', td.is_official, 'color', td.color, 'created_at', td.created_at,
    'total_votes', (SELECT count(*) FROM tag_votes tv WHERE tv.tag_id = td.id)
  ) ORDER BY (SELECT count(*) FROM tag_votes tv WHERE tv.tag_id = td.id) DESC), '[]'::jsonb) INTO result
  FROM tag_definitions td LIMIT p_limit;
  RETURN result;
END; $$;
