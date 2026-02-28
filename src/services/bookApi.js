import { ensureBookCached } from "./bookCache";

const GOOGLE_BOOKS_BASE_URL = "https://www.googleapis.com/books/v1/volumes";
const OPEN_LIBRARY_SEARCH = "https://openlibrary.org/search.json";

function toHttps(url) {
  return typeof url === "string" ? url.replace("http://", "https://") : "";
}

function normalizeGoogleBook(item) {
  const volumeInfo = item?.volumeInfo ?? {};
  const imageLinks = volumeInfo.imageLinks ?? {};

  return {
    id: item.id,
    source: "google_books",
    googleBooksId: item.id,
    title: volumeInfo.title ?? "Untitled",
    subtitle: volumeInfo.subtitle ?? "",
    authors: volumeInfo.authors ?? [],
    description: volumeInfo.description ?? "",
    categories: volumeInfo.categories ?? [],
    pageCount: volumeInfo.pageCount ?? null,
    publishedDate: volumeInfo.publishedDate ?? "",
    language: volumeInfo.language ?? "",
    coverUrl:
      toHttps(imageLinks.thumbnail) ||
      toHttps(imageLinks.smallThumbnail) ||
      "",
    coverUrlLarge:
      toHttps(imageLinks.large) ||
      toHttps(imageLinks.medium) ||
      toHttps(imageLinks.thumbnail) ||
      "",
    averageRating: volumeInfo.averageRating ?? null,
    ratingsCount: volumeInfo.ratingsCount ?? 0,
  };
}

export async function searchGoogleBooks(query, { maxResults = 24, language = "en" } = {}) {
  const trimmedQuery = query.trim();
  if (!trimmedQuery) return [];

  const apiKey = import.meta.env.VITE_GOOGLE_BOOKS_API_KEY;
  const params = new URLSearchParams({
    q: trimmedQuery,
    maxResults: String(maxResults),
    printType: "books",
  });
  if (language) {
    params.append("langRestrict", language);
    // Return metadata in the selected language instead of user's locale
    const hlMap = { en: "en", de: "de", fr: "fr", es: "es", it: "it", pt: "pt", nl: "nl", ja: "ja", zh: "zh", ko: "ko" };
    if (hlMap[language]) params.append("hl", hlMap[language]);
  }

  if (apiKey) params.append("key", apiKey);

  const response = await fetch(`${GOOGLE_BOOKS_BASE_URL}?${params.toString()}`);
  if (!response.ok) throw new Error("Google Books request failed.");

  const data = await response.json();
  const items = Array.isArray(data.items) ? data.items : [];
  const normalized = items.map(normalizeGoogleBook);

  // Cache books and get Supabase UUIDs
  const withIds = await Promise.all(
    normalized.map(async (book) => {
      try {
        const cached = await ensureBookCached(book);
        if (cached) return { ...book, id: cached.id };
      } catch {}
      return book;
    })
  );

  return withIds;
}

export async function getGoogleBookById(volumeId) {
  const apiKey = import.meta.env.VITE_GOOGLE_BOOKS_API_KEY;
  const params = new URLSearchParams();
  if (apiKey) params.append("key", apiKey);

  const url = `${GOOGLE_BOOKS_BASE_URL}/${volumeId}${params.toString() ? "?" + params.toString() : ""}`;
  const response = await fetch(url);
  if (!response.ok) throw new Error("Failed to fetch book details.");
  const item = await response.json();
  return normalizeGoogleBook(item);
}

// Open Library fallback
function normalizeOpenLibraryBook(doc) {
  const coverId = doc.cover_i;
  // Strip leading slash from key (e.g. "/works/OL82563W" -> "works/OL82563W")
  const olKey = doc.key?.replace(/^\//, "") ?? "";
  return {
    id: olKey,
    source: "open_library",
    googleBooksId: null,
    openLibraryKey: olKey,
    title: doc.title ?? "Untitled",
    subtitle: doc.subtitle ?? "",
    authors: doc.author_name ?? [],
    description: "",
    categories: doc.subject?.slice(0, 5) ?? [],
    pageCount: doc.number_of_pages_median ?? null,
    publishedDate: doc.first_publish_year ? String(doc.first_publish_year) : "",
    language: (doc.language ?? [])[0] ?? "",
    coverUrl: coverId
      ? `https://covers.openlibrary.org/b/id/${coverId}-M.jpg`
      : "",
    coverUrlLarge: coverId
      ? `https://covers.openlibrary.org/b/id/${coverId}-L.jpg`
      : "",
    averageRating: null,
    ratingsCount: 0,
  };
}

export async function searchOpenLibrary(query, { limit = 24, language } = {}) {
  const trimmedQuery = query.trim();
  if (!trimmedQuery) return [];

  const params = new URLSearchParams({
    q: trimmedQuery,
    limit: String(limit),
    fields: "key,title,subtitle,author_name,cover_i,first_publish_year,number_of_pages_median,subject,language",
  });
  if (language) params.append("language", language);

  const response = await fetch(`${OPEN_LIBRARY_SEARCH}?${params.toString()}`);
  if (!response.ok) throw new Error("Open Library request failed.");

  const data = await response.json();
  const normalized = (data.docs ?? []).map(normalizeOpenLibraryBook);

  // Cache books and use Supabase UUIDs for navigation
  const withIds = await Promise.all(
    normalized.map(async (book) => {
      try {
        const cached = await ensureBookCached(book);
        if (cached) return { ...book, id: cached.id };
      } catch {}
      return book;
    })
  );

  return withIds;
}

// Combined search: Open Library primary, Google Books fallback
export async function searchBooks(query, { maxResults = 24, language = "" } = {}) {
  try {
    const results = await searchOpenLibrary(query, { limit: maxResults, language });
    if (results.length > 0) return results;
  } catch {}
  return searchGoogleBooks(query, { maxResults, language });
}
