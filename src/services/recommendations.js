import { supabase } from "../config/supabaseClient";
import { backfillCover } from "./bookCache";

export async function getRecommendations(userId, limit = 20) {
  if (!supabase) return [];
  const { data, error } = await supabase.rpc("get_recommendations", {
    p_user_id: userId,
    p_limit: limit,
  });
  if (error) {
    console.error("Recommendations failed:", error);
    return [];
  }
  if (!data || data.length === 0) return [];

  // Fetch full book data for recommended book IDs
  const bookIds = data.map((r) => r.book_id);
  const { data: books } = await supabase
    .from("books")
    .select("*")
    .in("id", bookIds);

  return data.map((rec) => ({
    ...rec,
    book: (books || []).find((b) => b.id === rec.book_id),
    reason: rec.reason || null,
  }));
}

export async function getTrendingBooks(limit = 12) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("book_logs")
    .select("book_id, books(*)")
    .order("created_at", { ascending: false })
    .limit(50);
  if (error) return [];

  // Count and deduplicate
  const counts = {};
  for (const log of data || []) {
    if (!counts[log.book_id]) {
      counts[log.book_id] = { book: log.books, count: 0 };
    }
    counts[log.book_id].count++;
  }

  return Object.values(counts)
    .sort((a, b) => b.count - a.count)
    .slice(0, limit)
    .map((c) => c.book)
    .filter(Boolean);
}

export async function getSimilarBooks(bookId, limit = 8) {
  if (!supabase) return [];
  const { data, error } = await supabase.rpc("get_similar_books", {
    p_book_id: bookId,
    p_limit: limit,
  });
  if (error) {
    console.error("Similar books failed:", error);
    return [];
  }
  if (!data || data.length === 0) return [];

  const bookIds = data.map((r) => r.book_id);
  const { data: books } = await supabase
    .from("books")
    .select("*")
    .in("id", bookIds);

  // Also fetch tag labels for shared tags
  const allTagIds = [...new Set(data.flatMap((r) => r.shared_tag_ids))];
  const { data: tagDefs } = await supabase
    .from("tag_definitions")
    .select("id, label, slug")
    .in("id", allTagIds);
  const tagMap = {};
  for (const td of tagDefs || []) tagMap[td.id] = td;

  const results = data.map((rec) => {
    const book = (books || []).find((b) => b.id === rec.book_id);
    if (!book) return null;
    return {
      ...book,
      sharedTags: (rec.shared_tag_ids || []).map((id) => tagMap[id]).filter(Boolean),
      sharedTagIds: rec.shared_tag_ids,
    };
  }).filter(Boolean);

  return Promise.all(results.map((b) => backfillCover(b)));
}

export async function getHighlyRatedBooks(limit = 12) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("book_rating_stats")
    .select("*, books(*)")
    .gte("rating_count", 2)
    .gte("avg_rating", 7)
    .order("avg_rating", { ascending: false })
    .limit(limit);
  if (error) return [];
  return (data || []).map((r) => ({ ...r.books, avgRating: r.avg_rating, ratingCount: r.rating_count }));
}
