# Ludentia

Phase 1 MVP scaffolding for a community-driven book recommendation app.

## Stack
- React + Vite
- React Router
- Google Books API (search)

## Setup
1. Install dependencies:
   ```bash
   npm install
   ```
2. Copy env template and optionally add API key:
   ```bash
   copy .env.example .env.local
   ```
3. Run dev server:
   ```bash
   npm run dev
   ```

## Environment
- `VITE_GOOGLE_BOOKS_API_KEY` (optional but recommended for quota stability)

## Implemented in Phase 1
- App scaffold with route setup
- Search flow with debounce (`useBookSearch`)
- Google Books integration with normalized response (`services/bookApi.js`)
- UI components: navbar, search bar, cover card, grid
- Responsive and visually rich base styling

## Verification
1. Start app with `npm run dev`.
2. Search for `Harry Potter`.
3. Confirm book covers and metadata appear in a responsive grid.
