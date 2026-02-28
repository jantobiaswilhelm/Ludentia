import { supabase } from "../config/supabaseClient";

const CACHE_TTL_MS = 7 * 24 * 60 * 60 * 1000; // 7 days
const GOOGLE_BOOKS_BASE_URL = "https://www.googleapis.com/books/v1/volumes";

function toHttps(url) {
  return typeof url === "string" ? url.replace("http://", "https://") : "";
}

export async function backfillCover(book) {
  if (!book || book.cover_url) return book;
  try {
    const apiKey = import.meta.env.VITE_GOOGLE_BOOKS_API_KEY;
    const author = (book.authors || [])[0] || "";
    const q = author ? `${book.title} inauthor:${author}` : book.title;
    const params = new URLSearchParams({ q, maxResults: "1", printType: "books" });
    if (apiKey) params.append("key", apiKey);
    const res = await fetch(`${GOOGLE_BOOKS_BASE_URL}?${params}`);
    if (!res.ok) return book;
    const data = await res.json();
    const item = data.items?.[0];
    if (!item) return book;
    const links = item.volumeInfo?.imageLinks ?? {};
    const cover_url = toHttps(links.thumbnail || links.smallThumbnail) || "";
    const cover_url_large = toHttps(links.large || links.medium || links.thumbnail) || "";
    if (cover_url) {
      await supabase.from("books").update({ cover_url, cover_url_large }).eq("id", book.id);
      return { ...book, cover_url, cover_url_large };
    }
  } catch {}
  return book;
}

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

  let book = null;

  // Only query UUID column if it looks like a UUID
  if (UUID_RE.test(bookId)) {
    const { data } = await supabase
      .from("books")
      .select("*")
      .eq("id", bookId)
      .maybeSingle();
    if (data) book = data;
  }

  if (!book) {
    // Try Google Books ID
    const { data: byGoogle } = await supabase
      .from("books")
      .select("*")
      .eq("google_books_id", bookId)
      .maybeSingle();
    if (byGoogle) book = byGoogle;
  }

  if (!book) {
    // Try Open Library key
    const { data: byOL } = await supabase
      .from("books")
      .select("*")
      .eq("open_library_key", bookId)
      .maybeSingle();
    book = byOL;
  }

  return backfillCover(book);
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
