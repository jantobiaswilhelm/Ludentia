-- Wrap entire FTS expression in one immutable function (to_tsvector + regconfig cast are STABLE)
CREATE OR REPLACE FUNCTION books_fts_vector(
  p_title text, p_authors text[], p_categories text[], p_description text
) RETURNS tsvector AS $$
  SELECT
    setweight(to_tsvector('english', coalesce(p_title, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(array_to_string(p_authors, ' '), '')), 'B') ||
    setweight(to_tsvector('english', coalesce(array_to_string(p_categories, ' '), '')), 'C') ||
    setweight(to_tsvector('english', coalesce(p_description, '')), 'D')
$$ LANGUAGE sql IMMUTABLE;

ALTER TABLE books ADD COLUMN IF NOT EXISTS fts tsvector
  GENERATED ALWAYS AS (books_fts_vector(title, authors, categories, description)) STORED;

CREATE INDEX idx_books_fts ON books USING GIN(fts);
CREATE INDEX idx_books_categories ON books USING GIN(categories);
CREATE INDEX idx_books_authors ON books USING GIN(authors);
