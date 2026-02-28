# Ludentia Roadmap

## Context

The MVP is ~85-90% feature-complete — all core features (search, shelves, ratings, diary, tags, follows, recommendations, profiles, auth) are functional. The roadmap below picks up from here.

## Phase 1 — MVP Core (COMPLETED)

Everything currently in the repo: React + Vite app, Supabase backend, Open Library/Google Books search, book caching, shelves, 1-10 ratings with two logging modes, reading diary, community tags (37 official + user-created), follow system, recommendations engine, profiles, auth (email + Google OAuth), dark mode, warm bookshop design system.

---

## Phase 2 — Polish & UX Hardening

Fix rough edges, missing CRUD operations, and mobile experience.

- **Mobile hamburger menu** — CSS is ready, wire up JS toggle in Navbar
- **Toast notification system** — replace console.error with user-facing toasts for success/error
- **Error boundary component** — catch React render errors gracefully
- **Password reset flow** — Supabase supports it, build the UI (forgot password page + reset page)
- **Review editing & deletion** — services exist (`updateBookLog`, `deleteBookLog`), add UI on BookDetailPage and ProfilePage
- **Diary entry editing** — currently only create/delete, add edit support
- **Accessibility pass** — aria-labels, focus management, keyboard nav for modals and rating input
- **Loading skeletons** — replace spinners with content-shaped skeleton placeholders

---

## Phase 3 — Social & Discovery

Make the app social and browseable beyond just search.

- **Activity feed** — "what your friends are reading/rating/logging" feed on homepage or dedicated page
- **Friend/follower lists** — expandable lists on ProfilePage (currently just counts)
- **Avatar upload** — Supabase Storage integration for profile pictures
- **Bio / about section** — add to profiles
- **Advanced search** — filters (genre, year range, page count, rating), sorting (relevance, newest, rating)
- **Reading statistics** — charts on profile (books per month, genre breakdown, avg rating over time)
- **Curated lists** — user-created themed book lists ("Best Sci-Fi 2024", "Cozy Reads")

---

## Phase 4 — Engagement & Gamification

Keep users coming back.

- **Reading goals/challenges** — "Read 50 books in 2026" with progress tracking
- **Reading streaks** — track consecutive days/weeks of reading
- **Year in Review** — annual reading summary (total books, pages, genres, top-rated)
- **Book clubs** — group reading with shared diary/discussion
- **Discussion threads** — per-book discussions beyond reviews
- **Email notifications** — new follower, friend finished a book, reading goal milestone

---

## Phase 5 — Production & Scale

Ship to real users.

- **Deploy to Vercel** — environment config, build optimization
- **SEO** — meta tags, Open Graph, server-side rendering or prerendering for book pages
- **Performance** — lazy loading, code splitting, image optimization, query caching
- **Admin panel** — tag moderation, user management, reported content
- **Data export/import** — export reading history as CSV/JSON, import from Goodreads
- **Analytics** — basic usage tracking, popular books dashboard
- **Rate limiting** — protect API endpoints
