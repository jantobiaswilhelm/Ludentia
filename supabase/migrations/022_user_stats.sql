CREATE OR REPLACE FUNCTION get_user_reading_stats(
  p_user_id uuid,
  p_year int DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql STABLE AS $$
DECLARE
  result jsonb;
BEGIN
  WITH filtered_logs AS (
    SELECT bl.*, b.page_count, b.authors, b.categories
    FROM book_logs bl
    JOIN books b ON b.id = bl.book_id
    WHERE bl.user_id = p_user_id
      AND (p_year IS NULL OR EXTRACT(YEAR FROM bl.date_finished) = p_year)
  ),
  stats AS (
    SELECT
      count(*) AS books_logged,
      count(DISTINCT book_id) AS unique_books,
      coalesce(sum(page_count), 0) AS total_pages,
      round(avg(rating)::numeric, 1) AS avg_rating,
      count(*) FILTER (WHERE is_reread) AS rereads
    FROM filtered_logs
  ),
  monthly AS (
    SELECT
      EXTRACT(MONTH FROM date_finished)::int AS month,
      count(*) AS count
    FROM filtered_logs
    WHERE date_finished IS NOT NULL
    GROUP BY 1 ORDER BY 1
  ),
  rating_dist AS (
    SELECT rating, count(*) AS count
    FROM filtered_logs
    WHERE rating IS NOT NULL
    GROUP BY rating ORDER BY rating
  ),
  top_genres AS (
    SELECT unnest(categories) AS genre, count(*) AS count
    FROM filtered_logs
    WHERE categories IS NOT NULL
    GROUP BY 1 ORDER BY 2 DESC LIMIT 8
  ),
  top_authors AS (
    SELECT unnest(authors) AS author, count(*) AS count
    FROM filtered_logs
    WHERE authors IS NOT NULL
    GROUP BY 1 ORDER BY 2 DESC LIMIT 8
  )
  SELECT jsonb_build_object(
    'summary', (SELECT row_to_json(stats) FROM stats),
    'by_month', coalesce((SELECT jsonb_agg(row_to_json(m)) FROM monthly m), '[]'::jsonb),
    'rating_distribution', coalesce((SELECT jsonb_agg(row_to_json(r)) FROM rating_dist r), '[]'::jsonb),
    'top_genres', coalesce((SELECT jsonb_agg(row_to_json(g)) FROM top_genres g), '[]'::jsonb),
    'top_authors', coalesce((SELECT jsonb_agg(row_to_json(a)) FROM top_authors a), '[]'::jsonb)
  ) INTO result;

  RETURN result;
END;
$$;
