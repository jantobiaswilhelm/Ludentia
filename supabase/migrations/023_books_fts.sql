-- Full-text search on cached books
ALTER TABLE books ADD COLUMN IF NOT EXISTS fts tsvector
  GENERATED ALWAYS AS (
    setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(array_to_string(authors, ' '), '')), 'B') ||
    setweight(to_tsvector('english', coalesce(array_to_string(categories, ' '), '')), 'C') ||
    setweight(to_tsvector('english', coalesce(description, '')), 'D')
  ) STORED;

CREATE INDEX idx_books_fts ON books USING GIN(fts);
CREATE INDEX idx_books_categories ON books USING GIN(categories);
CREATE INDEX idx_books_authors ON books USING GIN(authors);
