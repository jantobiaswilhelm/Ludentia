-- Rich Year in Review data — extends 022_user_stats pattern
CREATE OR REPLACE FUNCTION get_year_in_review(p_user_id uuid, p_year integer DEFAULT EXTRACT(YEAR FROM now())::integer)
RETURNS jsonb LANGUAGE plpgsql STABLE AS $$
DECLARE result jsonb;
BEGIN
  WITH fl AS (
    SELECT bl.*, b.page_count, b.authors, b.categories, b.title, b.cover_url
    FROM book_logs bl JOIN books b ON b.id = bl.book_id
    WHERE bl.user_id = p_user_id AND EXTRACT(YEAR FROM bl.date_finished) = p_year AND bl.date_finished IS NOT NULL
  ),
  summary AS (
    SELECT count(*) AS books_logged, count(DISTINCT book_id) AS unique_books,
      coalesce(sum(page_count),0) AS total_pages, round(avg(rating)::numeric,1) AS avg_rating,
      count(*) FILTER (WHERE is_reread) AS rereads, min(date_finished) AS first_finish, max(date_finished) AS last_finish
    FROM fl
  ),
  monthly AS (SELECT EXTRACT(MONTH FROM date_finished)::int AS month, count(*) AS count FROM fl GROUP BY 1 ORDER BY 1),
  rating_dist AS (SELECT rating, count(*) AS count FROM fl WHERE rating IS NOT NULL GROUP BY rating ORDER BY rating),
  top_genres AS (SELECT unnest(categories) AS genre, count(*) AS count FROM fl WHERE categories IS NOT NULL GROUP BY 1 ORDER BY 2 DESC LIMIT 8),
  top_authors AS (SELECT unnest(authors) AS author, count(*) AS count FROM fl WHERE authors IS NOT NULL GROUP BY 1 ORDER BY 2 DESC LIMIT 8),
  highest_rated AS (SELECT book_id, title, cover_url, rating, authors FROM fl WHERE rating IS NOT NULL ORDER BY rating DESC, created_at ASC LIMIT 5),
  lowest_rated AS (SELECT book_id, title, cover_url, rating, authors FROM fl WHERE rating IS NOT NULL ORDER BY rating ASC, created_at ASC LIMIT 3),
  longest_books AS (SELECT book_id, title, cover_url, page_count, authors FROM fl WHERE page_count IS NOT NULL ORDER BY page_count DESC LIMIT 3),
  shortest_books AS (SELECT book_id, title, cover_url, page_count, authors FROM fl WHERE page_count IS NOT NULL AND page_count > 0 ORDER BY page_count ASC LIMIT 3),
  fastest_reads AS (
    SELECT book_id, title, cover_url, page_count, authors, (date_finished - date_started) AS days_to_read
    FROM fl WHERE date_started IS NOT NULL AND date_finished >= date_started ORDER BY (date_finished - date_started) ASC LIMIT 3
  ),
  diary_count AS (SELECT count(*) AS total FROM diary_entries WHERE user_id = p_user_id AND EXTRACT(YEAR FROM created_at) = p_year),
  busiest AS (SELECT EXTRACT(MONTH FROM date_finished)::int AS month, count(*) AS count FROM fl GROUP BY 1 ORDER BY 2 DESC LIMIT 1)
  SELECT jsonb_build_object(
    'year', p_year,
    'summary', (SELECT row_to_json(s) FROM summary s),
    'by_month', coalesce((SELECT jsonb_agg(row_to_json(m)) FROM monthly m), '[]'::jsonb),
    'rating_distribution', coalesce((SELECT jsonb_agg(row_to_json(r)) FROM rating_dist r), '[]'::jsonb),
    'top_genres', coalesce((SELECT jsonb_agg(row_to_json(g)) FROM top_genres g), '[]'::jsonb),
    'top_authors', coalesce((SELECT jsonb_agg(row_to_json(a)) FROM top_authors a), '[]'::jsonb),
    'highest_rated', coalesce((SELECT jsonb_agg(row_to_json(h)) FROM highest_rated h), '[]'::jsonb),
    'lowest_rated', coalesce((SELECT jsonb_agg(row_to_json(l)) FROM lowest_rated l), '[]'::jsonb),
    'longest_books', coalesce((SELECT jsonb_agg(row_to_json(lb)) FROM longest_books lb), '[]'::jsonb),
    'shortest_books', coalesce((SELECT jsonb_agg(row_to_json(sb)) FROM shortest_books sb), '[]'::jsonb),
    'fastest_reads', coalesce((SELECT jsonb_agg(row_to_json(fr)) FROM fastest_reads fr), '[]'::jsonb),
    'diary_entries_count', (SELECT total FROM diary_count),
    'busiest_month', (SELECT row_to_json(bm) FROM busiest bm)
  ) INTO result;
  RETURN result;
END; $$;
