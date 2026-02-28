import { supabase } from "../config/supabaseClient";

export async function getAllTags() {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("tag_definitions")
    .select("*")
    .order("sort_order", { ascending: true });
  if (error) throw error;
  return data || [];
}

export async function getOfficialTags() {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("tag_definitions")
    .select("*")
    .eq("is_official", true)
    .order("sort_order", { ascending: true });
  if (error) throw error;
  return data || [];
}

export async function searchTags(query) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("tag_definitions")
    .select("*")
    .ilike("label", `%${query}%`)
    .order("is_official", { ascending: false })
    .limit(20);
  if (error) throw error;
  return data || [];
}

export async function createTag({ label, category, createdBy }) {
  if (!supabase) throw new Error("Supabase not configured");
  const slug = label
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "");
  const { data, error } = await supabase
    .from("tag_definitions")
    .insert({
      label,
      slug,
      category: category || null,
      is_official: false,
      created_by: createdBy,
    })
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function getBookTagCounts(bookId) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("book_tag_counts")
    .select("*, tag_definitions(*)")
    .eq("book_id", bookId)
    .order("vote_count", { ascending: false });
  if (error) {
    // Materialized view might not exist yet; fallback to manual count
    const { data: fallback } = await supabase
      .from("tag_votes")
      .select("tag_id, tag_definitions(*)")
      .eq("book_id", bookId);
    if (!fallback) return [];
    const counts = {};
    for (const v of fallback) {
      if (!counts[v.tag_id]) {
        counts[v.tag_id] = { tag_id: v.tag_id, book_id: bookId, vote_count: 0, tag_definitions: v.tag_definitions };
      }
      counts[v.tag_id].vote_count++;
    }
    return Object.values(counts).sort((a, b) => b.vote_count - a.vote_count);
  }
  return data || [];
}

export async function getUserBookVotes(userId, bookId) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("tag_votes")
    .select("tag_id")
    .eq("user_id", userId)
    .eq("book_id", bookId);
  if (error) throw error;
  return (data || []).map((v) => v.tag_id);
}

export async function voteTag(userId, bookId, tagId) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase
    .from("tag_votes")
    .insert({ user_id: userId, book_id: bookId, tag_id: tagId });
  if (error) throw error;
}

export async function getPopularTagsForBook(bookId, limit = 10) {
  if (!supabase) return [];
  const { data, error } = await supabase.rpc("get_popular_tags_for_book", {
    p_book_id: bookId,
    p_limit: limit,
  });
  if (error) return [];
  return data || [];
}

export async function getTagBySlug(slug) {
  if (!supabase) return null;
  const { data } = await supabase
    .from("tag_definitions")
    .select("*")
    .eq("slug", slug)
    .maybeSingle();
  return data;
}

export async function getBooksForTag(tagId, limit = 50) {
  if (!supabase) return [];
  const { data } = await supabase
    .from("tag_votes")
    .select("book_id, books(*)")
    .eq("tag_id", tagId)
    .limit(200);
  if (!data) return [];

  // Deduplicate and count votes
  const counts = {};
  for (const row of data) {
    if (!row.books) continue;
    if (!counts[row.book_id]) {
      counts[row.book_id] = { book: row.books, voteCount: 0 };
    }
    counts[row.book_id].voteCount++;
  }

  return Object.values(counts)
    .sort((a, b) => b.voteCount - a.voteCount)
    .slice(0, limit)
    .map((c) => ({
      id: c.book.id,
      title: c.book.title,
      authors: c.book.authors || [],
      coverUrl: c.book.cover_url,
      coverUrlLarge: c.book.cover_url_large,
      pageCount: c.book.page_count,
      averageRating: c.book.google_average_rating,
      voteCount: c.voteCount,
    }));
}

export async function getCoOccurringTags(tagId, limit = 8) {
  if (!supabase) return [];
  const { data, error } = await supabase.rpc("get_co_occurring_tags", {
    p_tag_id: tagId,
    p_limit: limit,
  });
  if (error) return [];
  return data || [];
}

export async function removeVote(userId, bookId, tagId) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase
    .from("tag_votes")
    .delete()
    .eq("user_id", userId)
    .eq("book_id", bookId)
    .eq("tag_id", tagId);
  if (error) throw error;
}
