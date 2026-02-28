-- Immutable wrapper needed for generated columns (to_tsvector is STABLE, not IMMUTABLE)
CREATE OR REPLACE FUNCTION immutable_to_tsvector(config regconfig, input text)
RETURNS tsvector AS $$ SELECT to_tsvector(config, input) $$ LANGUAGE sql IMMUTABLE;

-- Full-text search on cached books
ALTER TABLE books ADD COLUMN IF NOT EXISTS fts tsvector
  GENERATED ALWAYS AS (
    setweight(immutable_to_tsvector('english'::regconfig, coalesce(title, '')), 'A') ||
    setweight(immutable_to_tsvector('english'::regconfig, coalesce(array_to_string(authors, ' '), '')), 'B') ||
    setweight(immutable_to_tsvector('english'::regconfig, coalesce(array_to_string(categories, ' '), '')), 'C') ||
    setweight(immutable_to_tsvector('english'::regconfig, coalesce(description, '')), 'D')
  ) STORED;

CREATE INDEX idx_books_fts ON books USING GIN(fts);
CREATE INDEX idx_books_categories ON books USING GIN(categories);
CREATE INDEX idx_books_authors ON books USING GIN(authors);
