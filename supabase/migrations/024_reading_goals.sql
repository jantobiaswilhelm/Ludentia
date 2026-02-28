CREATE TABLE reading_goals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles ON DELETE CASCADE,
  year integer NOT NULL,
  target_books integer NOT NULL CHECK (target_books >= 1 AND target_books <= 500),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, year)
);
CREATE INDEX idx_goals_user_year ON reading_goals(user_id, year);

-- RLS
ALTER TABLE reading_goals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own goals" ON reading_goals FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Public goals viewable" ON reading_goals FOR SELECT USING (
  EXISTS (SELECT 1 FROM profiles WHERE profiles.id = reading_goals.user_id AND profiles.profile_visibility = 'public')
);
CREATE POLICY "Users manage own goals" ON reading_goals FOR ALL USING (auth.uid() = user_id);

-- RPC: get goal + progress count
CREATE OR REPLACE FUNCTION get_goal_progress(p_user_id uuid, p_year integer DEFAULT EXTRACT(YEAR FROM now())::integer)
RETURNS jsonb LANGUAGE plpgsql STABLE AS $$
DECLARE result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'goal', (SELECT jsonb_build_object('id', g.id, 'target_books', g.target_books, 'year', g.year)
             FROM reading_goals g WHERE g.user_id = p_user_id AND g.year = p_year),
    'books_read', (SELECT count(DISTINCT book_id) FROM book_logs
                   WHERE user_id = p_user_id AND EXTRACT(YEAR FROM date_finished) = p_year AND date_finished IS NOT NULL),
    'books_this_month', (SELECT count(DISTINCT book_id) FROM book_logs
                         WHERE user_id = p_user_id AND EXTRACT(YEAR FROM date_finished) = p_year
                         AND EXTRACT(MONTH FROM date_finished) = EXTRACT(MONTH FROM now()) AND date_finished IS NOT NULL)
  ) INTO result;
  RETURN result;
END; $$;
