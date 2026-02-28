# Pending Supabase Migrations

Run these migrations in order against your Supabase database (SQL Editor or CLI).

## Phase 2 Migrations

### 1. `012_refresh_tag_counts.sql`
Auto-refreshes the `book_tag_counts` materialized view on tag vote changes.
```
supabase/migrations/012_refresh_tag_counts.sql
```

### 2. `013_discover_by_tags.sql`
`discover_books_by_tags()` — finds books matching multiple tags, ranked by match count.
```
supabase/migrations/013_discover_by_tags.sql
```

### 3. `014_similar_books.sql`
`get_similar_books()` — finds books sharing the most tags with a given book.
```
supabase/migrations/014_similar_books.sql
```

### 4. `015_popular_tags_for_book.sql`
`get_popular_tags_for_book()` — returns the most-voted tags for a specific book.
```
supabase/migrations/015_popular_tags_for_book.sql
```

### 5. `016_explained_recommendations.sql`
Replaces `get_recommendations()` to return JSONB reasons (matched tags, author match, high rating).
```
supabase/migrations/016_explained_recommendations.sql
```

### 6. `017_co_occurring_tags.sql`
`get_co_occurring_tags()` — finds tags that frequently appear alongside a given tag.
```
supabase/migrations/017_co_occurring_tags.sql
```

### 7. `018_seed_popular_books.sql`
Seeds a system profile, 30 popular books, and tag votes for discovery.
```
supabase/migrations/018_seed_popular_books.sql
```

## How to run

**Option A — Supabase Dashboard:**
1. Go to your Supabase project → SQL Editor
2. Copy-paste each file's contents in order (012 → 018)
3. Run each one

**Option B — Supabase CLI:**
```bash
supabase db push
```
This auto-runs any unapplied migrations from `supabase/migrations/`.
