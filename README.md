# Ludentia

A community-driven book recommendation app — Letterboxd for books. Track your reading, keep a diary, rate and tag books, and discover recommendations from the community.

## Stack

- **Frontend:** React 18 + Vite 5 + React Router 6
- **Backend:** Supabase (Auth, Postgres, auto-generated REST API)
- **Book Data:** Open Library API (primary) with Google Books API (fallback)

## Features

- **Book Search** — Search millions of books via Open Library with automatic caching to Supabase
- **Bookshelves** — Organize books into Want to Read, Reading, and Read shelves
- **Rating System** — 1-10 scale ratings with distribution charts
- **Reading Diary** — Journal entries while reading, with page tracking and spoiler tags
- **Reading Progress** — Track current page and mood while reading
- **Community Tags** — 37 official tags across 8 categories, plus user-created tags with voting
- **Follow System** — Follow other readers with public/friends-only/private visibility
- **Recommendations** — PostgreSQL-powered recommendation engine based on reading history
- **User Profiles** — View reading stats, recent activity, and bookshelves
- **Dark Mode** — Warm bookshop aesthetic with light/dark theme toggle

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Create a `.env.local` file with your Supabase credentials:
   ```
   VITE_SUPABASE_URL=your_supabase_url
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   VITE_GOOGLE_BOOKS_API_KEY=optional_google_books_key
   ```

3. Run the database migrations in order (`supabase/migrations/001-011`) via the Supabase SQL Editor.

4. Start the dev server:
   ```bash
   npm run dev
   ```

## Project Structure

```
src/
  config/          # Supabase client
  context/         # Auth context provider
  services/        # All API/Supabase calls (auth, bookApi, bookCache,
                   #   bookLog, bookshelves, diary, follows, recommendations, tags)
  hooks/           # React hooks wrapping services
  pages/           # Route pages (Home, BookDetail, MyShelf, Diary,
                   #   Browse, Recommendations, Profile, Login, SignUp)
  components/
    books/         # BookCard, BookCover, BookGrid
    diary/         # DiaryEntry, DiaryFeed, MoodSelector, ProgressTracker
    logging/       # LogBookModal, LogAllInOne, LogStepByStep
    ratings/       # RatingInput, RatingDisplay, RatingDistribution
    shelves/       # ShelfSelector, ShelfList
    tags/          # TagBadge, TagSection, TagVotePanel
    search/        # SearchBar
    layout/        # Navbar
    ui/            # Button, Modal, Spinner, EmptyState
  utils/           # Constants and formatters
supabase/
  migrations/      # 11 SQL migration files
```

## Database

Postgres tables managed via Supabase: profiles, books, book_editions, user_bookshelves, reading_progress, diary_entries, book_logs, follows, tag_definitions, tag_votes, plus materialized views for tag counts and rating stats.

## Design

Warm bookshop aesthetic using Playfair Display (headings) and Inter (body). CSS custom properties with `[data-theme="dark"]` toggle support.
