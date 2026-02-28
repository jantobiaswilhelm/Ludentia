import { supabase } from "../config/supabaseClient";
import { backfillCover } from "./bookCache";

export async function discoverBooksByTags(tagIds, { limit = 20, offset = 0 } = {}) {
  if (!supabase || tagIds.length === 0) return [];

  const { data, error } = await supabase.rpc("discover_books_by_tags", {
    p_tag_ids: tagIds,
    p_limit: limit,
    p_offset: offset,
  });

  if (error) throw error;
  if (!data || data.length === 0) return [];

  // Fetch full book data
  const bookIds = data.map((r) => r.book_id);
  const { data: books } = await supabase
    .from("books")
    .select("*")
    .in("id", bookIds);

  const results = data.map((rec) => {
    const book = (books || []).find((b) => b.id === rec.book_id);
    if (!book) return null;
    return { ...book, matchCount: rec.match_count, matchedTags: rec.matched_tags };
  }).filter(Boolean);

  return Promise.all(results.map((b) => backfillCover(b)));
}
