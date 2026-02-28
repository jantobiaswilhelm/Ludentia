import { supabase } from "../config/supabaseClient";

const CACHE_TTL_MS = 7 * 24 * 60 * 60 * 1000; // 7 days

export async function getCachedBook(googleBooksId) {
  if (!supabase) return null;
  const { data } = await supabase
    .from("books")
    .select("*")
    .eq("google_books_id", googleBooksId)
    .maybeSingle();
  if (!data) return null;
  const age = Date.now() - new Date(data.cached_at).getTime();
  if (age > CACHE_TTL_MS) return null;
  return data;
}

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export async function getCachedBookById(bookId) {
  if (!supabase || !bookId) return null;

  // Only query UUID column if it looks like a UUID
  if (UUID_RE.test(bookId)) {
    const { data } = await supabase
      .from("books")
      .select("*")
      .eq("id", bookId)
      .maybeSingle();
    if (data) return data;
  }

  // Try Google Books ID
  const { data: byGoogle } = await supabase
    .from("books")
    .select("*")
    .eq("google_books_id", bookId)
    .maybeSingle();
  if (byGoogle) return byGoogle;

  // Try Open Library key
  const { data: byOL } = await supabase
    .from("books")
    .select("*")
    .eq("open_library_key", bookId)
    .maybeSingle();
  return byOL;
}

export async function cacheBook(normalizedBook) {
  if (!supabase) return null;
  const row = {
    google_books_id: normalizedBook.googleBooksId || null,
    open_library_key: normalizedBook.openLibraryKey || null,
    title: normalizedBook.title,
    authors: normalizedBook.authors,
    description: normalizedBook.description,
    categories: normalizedBook.categories,
    page_count: normalizedBook.pageCount,
    published_date: normalizedBook.publishedDate,
    cover_url: normalizedBook.coverUrl,
    cover_url_large: normalizedBook.coverUrlLarge,
    google_average_rating: normalizedBook.averageRating,
    google_ratings_count: normalizedBook.ratingsCount,
    language: normalizedBook.language,
    cached_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  };

  const onConflict = normalizedBook.googleBooksId
    ? "google_books_id"
    : "open_library_key";

  const { data, error } = await supabase
    .from("books")
    .upsert(row, { onConflict })
    .select()
    .single();

  if (error) {
    console.error("Failed to cache book:", error);
    return null;
  }
  return data;
}

export async function ensureBookCached(normalizedBook) {
  if (normalizedBook.googleBooksId) {
    const cached = await getCachedBook(normalizedBook.googleBooksId);
    if (cached) return cached;
  } else if (normalizedBook.openLibraryKey) {
    const { data } = await supabase
      .from("books")
      .select("*")
      .eq("open_library_key", normalizedBook.openLibraryKey)
      .maybeSingle();
    if (data) {
      const age = Date.now() - new Date(data.cached_at).getTime();
      if (age <= CACHE_TTL_MS) return data;
    }
  }
  return await cacheBook(normalizedBook);
}
