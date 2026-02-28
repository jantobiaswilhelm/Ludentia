-- Track import jobs (Goodreads CSV, etc.)
CREATE TABLE import_jobs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles ON DELETE CASCADE,
  source text NOT NULL CHECK (source IN ('goodreads', 'storygraph', 'csv')),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
  total_rows integer NOT NULL DEFAULT 0,
  imported_rows integer NOT NULL DEFAULT 0,
  skipped_rows integer NOT NULL DEFAULT 0,
  errors jsonb DEFAULT '[]'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz
);
CREATE INDEX idx_import_user ON import_jobs(user_id, created_at DESC);

ALTER TABLE import_jobs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users see own imports" ON import_jobs FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users create imports" ON import_jobs FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users update own imports" ON import_jobs FOR UPDATE USING (auth.uid() = user_id);
