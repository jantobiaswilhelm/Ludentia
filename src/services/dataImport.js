import { supabase } from "../config/supabaseClient";
import { searchGoogleBooks } from "./bookApi";
import { ensureBookCached } from "./bookCache";

/**
 * Parse Goodreads CSV export.
 * Expected columns: Title, Author, ISBN13, ISBN, My Rating, Date Read, Date Added, Bookshelves, Exclusive Shelf, My Review
 */
export function parseGoodreadsCSV(csvText) {
  const lines = parseCSVLines(csvText);
  if (lines.length < 2) return [];

  const headers = lines[0].map((h) => h.trim());
  const titleIdx = findCol(headers, "Title");
  const authorIdx = findCol(headers, "Author");
  const isbn13Idx = findCol(headers, "ISBN13");
  const isbnIdx = findCol(headers, "ISBN");
  const ratingIdx = findCol(headers, "My Rating");
  const dateReadIdx = findCol(headers, "Date Read");
  const dateAddedIdx = findCol(headers, "Date Added");
  const shelfIdx = findCol(headers, "Exclusive Shelf");
  const reviewIdx = findCol(headers, "My Review");

  if (titleIdx === -1) throw new Error('CSV missing "Title" column');

  return lines.slice(1).filter((row) => row.length > titleIdx && row[titleIdx].trim()).map((row) => {
    const grRating = parseInt(row[ratingIdx] || "0");
    return {
      title: row[titleIdx]?.trim() || "",
      author: row[authorIdx]?.trim() || "",
      isbn13: cleanISBN(row[isbn13Idx]),
      isbn: cleanISBN(row[isbnIdx]),
      rating: grRating > 0 ? grRating * 2 : null, // Goodreads 1-5 → Ludentia 2-10
      dateRead: row[dateReadIdx]?.trim() || null,
      dateAdded: row[dateAddedIdx]?.trim() || null,
      shelf: mapShelf(row[shelfIdx]?.trim()),
      review: row[reviewIdx]?.trim() || null,
    };
  });
}

function findCol(headers, name) {
  return headers.findIndex((h) => h.toLowerCase() === name.toLowerCase());
}

function cleanISBN(val) {
  if (!val) return "";
  return val.replace(/[="]/g, "").trim();
}

function mapShelf(grShelf) {
  if (!grShelf) return "want_to_read";
  const s = grShelf.toLowerCase();
  if (s === "read") return "read";
  if (s === "currently-reading") return "reading";
  return "want_to_read";
}

/**
 * Parse CSV text into array of arrays, handling quoted fields.
 */
function parseCSVLines(text) {
  const lines = [];
  let current = [];
  let field = "";
  let inQuotes = false;

  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (inQuotes) {
      if (ch === '"' && text[i + 1] === '"') {
        field += '"';
        i++;
      } else if (ch === '"') {
        inQuotes = false;
      } else {
        field += ch;
      }
    } else {
      if (ch === '"') {
        inQuotes = true;
      } else if (ch === ",") {
        current.push(field);
        field = "";
      } else if (ch === "\n" || (ch === "\r" && text[i + 1] === "\n")) {
        current.push(field);
        field = "";
        if (current.some((c) => c.trim())) lines.push(current);
        current = [];
        if (ch === "\r") i++;
      } else {
        field += ch;
      }
    }
  }
  if (field || current.length) {
    current.push(field);
    if (current.some((c) => c.trim())) lines.push(current);
  }
  return lines;
}

/**
 * Import parsed Goodreads rows into Ludentia.
 * Returns { imported, skipped, errors }.
 */
export async function importGoodreadsData(parsedRows, userId, onProgress) {
  if (!supabase) throw new Error("Supabase not configured");

  let imported = 0;
  let skipped = 0;
  const errors = [];

  for (let i = 0; i < parsedRows.length; i++) {
    const row = parsedRows[i];
    try {
      // Find book by ISBN or title search
      let book = null;
      if (row.isbn13) {
        const results = await searchGoogleBooks(`isbn:${row.isbn13}`);
        if (results.length > 0) book = await ensureBookCached(results[0]);
      }
      if (!book && row.isbn) {
        const results = await searchGoogleBooks(`isbn:${row.isbn}`);
        if (results.length > 0) book = await ensureBookCached(results[0]);
      }
      if (!book && row.title) {
        const query = row.author ? `${row.title} ${row.author}` : row.title;
        const results = await searchGoogleBooks(query);
        if (results.length > 0) book = await ensureBookCached(results[0]);
      }

      if (!book) {
        skipped++;
        errors.push({ row: i + 1, title: row.title, reason: "Book not found" });
        if (onProgress) onProgress({ imported, skipped, total: parsedRows.length, current: i + 1 });
        continue;
      }

      // Add to shelf
      await supabase.from("user_bookshelves").upsert(
        { user_id: userId, book_id: book.id, shelf: row.shelf },
        { onConflict: "user_id,book_id" }
      );

      // Create log if shelf is "read" and there's a rating or review
      if (row.shelf === "read" && (row.rating || row.review)) {
        const logData = {
          user_id: userId,
          book_id: book.id,
          rating: row.rating,
          review_text: row.review,
          date_finished: row.dateRead || null,
          visibility: "public",
        };
        await supabase.from("book_logs").insert(logData);
      }

      imported++;
    } catch (err) {
      skipped++;
      errors.push({ row: i + 1, title: row.title, reason: err.message });
    }

    if (onProgress) onProgress({ imported, skipped, total: parsedRows.length, current: i + 1 });

    // Small delay to avoid rate limits
    if (i % 5 === 4) await new Promise((r) => setTimeout(r, 500));
  }

  // Track import job
  await supabase.from("import_jobs").insert({
    user_id: userId,
    source: "goodreads",
    status: "completed",
    total_rows: parsedRows.length,
    imported_rows: imported,
    skipped_rows: skipped,
    errors: JSON.stringify(errors),
    completed_at: new Date().toISOString(),
  }).catch(() => {}); // non-critical

  return { imported, skipped, errors };
}
