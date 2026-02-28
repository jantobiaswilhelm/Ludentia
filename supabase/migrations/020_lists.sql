CREATE TABLE lists (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  cover_book_id uuid REFERENCES books,
  visibility text NOT NULL DEFAULT 'public'
    CHECK (visibility IN ('public','friends_only','private')),
  is_ranked boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_lists_user ON lists(user_id);

CREATE TABLE list_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  list_id uuid NOT NULL REFERENCES lists ON DELETE CASCADE,
  book_id uuid NOT NULL REFERENCES books ON DELETE CASCADE,
  position integer NOT NULL DEFAULT 0,
  note text,
  added_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(list_id, book_id)
);
CREATE INDEX idx_list_items_list ON list_items(list_id, position);

-- RLS
ALTER TABLE lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE list_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public lists readable" ON lists FOR SELECT
  USING (visibility = 'public' OR user_id = auth.uid());
CREATE POLICY "Users manage own lists" ON lists FOR ALL
  USING (user_id = auth.uid());
CREATE POLICY "List items readable with list" ON list_items FOR SELECT
  USING (EXISTS (SELECT 1 FROM lists WHERE lists.id = list_id
    AND (lists.visibility = 'public' OR lists.user_id = auth.uid())));
CREATE POLICY "Users manage own list items" ON list_items FOR ALL
  USING (EXISTS (SELECT 1 FROM lists WHERE lists.id = list_id
    AND lists.user_id = auth.uid()));
