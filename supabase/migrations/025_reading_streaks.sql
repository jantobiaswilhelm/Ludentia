-- Computed streak from book_logs, diary_entries, reading_progress activity
CREATE OR REPLACE FUNCTION get_reading_streak(p_user_id uuid)
RETURNS jsonb LANGUAGE plpgsql STABLE AS $$
DECLARE result jsonb;
BEGIN
  WITH activity_dates AS (
    SELECT DISTINCT activity_date FROM (
      SELECT date_finished::date AS activity_date FROM book_logs WHERE user_id = p_user_id AND date_finished IS NOT NULL
      UNION
      SELECT created_at::date FROM diary_entries WHERE user_id = p_user_id
      UNION
      SELECT updated_at::date FROM reading_progress WHERE user_id = p_user_id
    ) a WHERE activity_date IS NOT NULL
  ),
  numbered AS (
    SELECT activity_date, activity_date - (ROW_NUMBER() OVER (ORDER BY activity_date))::integer AS grp
    FROM activity_dates
  ),
  streaks AS (
    SELECT grp, count(*) AS streak_len, max(activity_date) AS streak_end FROM numbered GROUP BY grp
  )
  SELECT jsonb_build_object(
    'current_streak', coalesce((SELECT streak_len FROM streaks WHERE streak_end >= (current_date - 1) ORDER BY streak_end DESC LIMIT 1), 0),
    'longest_streak', coalesce((SELECT max(streak_len) FROM streaks), 0),
    'total_active_days', (SELECT count(*) FROM activity_dates),
    'is_active_today', EXISTS (SELECT 1 FROM activity_dates WHERE activity_date = current_date)
  ) INTO result;
  RETURN result;
END; $$;
