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

## Phase 3 Migrations

### 8. `019_profile_bio.sql`
Adds `bio` (text) and `website` (text) columns to the `profiles` table.
```
supabase/migrations/019_profile_bio.sql
```

### 9. `020_lists.sql`
Creates `lists` and `list_items` tables with indexes and RLS policies for curated book lists.
```
supabase/migrations/020_lists.sql
```

### 10. `021_activity_feed.sql`
`get_activity_feed()` — returns a union of book_logs, diary_entries, and shelf additions from followed users, ordered by recency with cursor pagination.
```
supabase/migrations/021_activity_feed.sql
```

### 11. `022_user_stats.sql`
`get_user_reading_stats()` — returns aggregated reading statistics (books logged, pages, avg rating, rereads, by-month, rating distribution, top genres, top authors) with optional year filter.
```
supabase/migrations/022_user_stats.sql
```

### 12. `023_books_fts.sql`
Adds a generated `fts` tsvector column to `books` (weighted: title A, authors B, categories C, description D) with GIN indexes for full-text search, plus GIN indexes on `categories` and `authors` arrays.
```
supabase/migrations/023_books_fts.sql
```

## Phase 4 Migrations

### 13. `024_reading_goals.sql`
Creates `reading_goals` table (user_id, year, target_books) with RLS policies and `get_goal_progress()` RPC that returns goal info + books_read + books_this_month.
```
supabase/migrations/024_reading_goals.sql
```

### 14. `025_reading_streaks.sql`
`get_reading_streak()` — computes current/longest streak from book_logs, diary_entries, and reading_progress activity dates.
```
supabase/migrations/025_reading_streaks.sql
```

### 15. `026_year_in_review.sql`
`get_year_in_review()` — returns rich year data: summary, monthly breakdown, rating distribution, top genres/authors, highest/lowest rated, longest/shortest books, fastest reads, diary count, busiest month.
```
supabase/migrations/026_year_in_review.sql
```

### 16. `027_discussions.sql`
Creates `discussion_comments` table (book_id, user_id, parent_id, comment_text, contains_spoilers) with RLS policies and `get_book_discussions()` RPC for threaded comments (top-level + 1 level of replies).
```
supabase/migrations/027_discussions.sql
```

## Phase 5 Migrations

### 17. `028_admin_reports.sql`
Adds `is_admin` boolean to `profiles`. Creates `reported_content` table with RLS. Adds `get_reported_content()`, `admin_get_users()`, and `admin_get_tags()` admin RPCs (SECURITY DEFINER, admin-gated).
```
supabase/migrations/028_admin_reports.sql
```

### 18. `029_import_jobs.sql`
Creates `import_jobs` table to track Goodreads/CSV imports (user_id, source, status, row counts, errors) with RLS.
```
supabase/migrations/029_import_jobs.sql
```

## Tag System Expansion

### 19. `030_theme_tags.sql`
Adds 15 official "Themes" category tags (Enemies to Lovers, Found Family, Unreliable Narrator, Redemption Arc, Coming of Age, Fish Out of Water, Quest/Journey, Forbidden Love, Revenge, Identity/Self-Discovery, Time Loop, Morally Gray Characters, Chosen One, Secrets & Lies, Survival).
```
supabase/migrations/030_theme_tags.sql
```

## How to run

**Option A — Supabase Dashboard:**
1. Go to your Supabase project → SQL Editor
2. Copy-paste each file's contents in order (012 → 029)
3. Run each one

**Option B — Supabase CLI:**
```bash
supabase db push
```
This auto-runs any unapplied migrations from `supabase/migrations/`.
