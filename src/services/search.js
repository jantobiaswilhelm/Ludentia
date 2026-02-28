import { supabase } from "../config/supabaseClient";

export async function searchCachedBooks({ query, author, category, language, minPages, maxPages, sortBy = "relevance", limit = 24, offset = 0 } = {}) {
  if (!supabase) return [];

  let q = supabase.from("books").select("*");

  if (query?.trim()) {
    q = q.textSearch("fts", query.trim(), { type: "websearch" });
  }

  if (author?.trim()) {
    q = q.contains("authors", [author.trim()]);
  }

  if (category?.trim()) {
    q = q.contains("categories", [category.trim()]);
  }

  if (language?.trim()) {
    q = q.eq("language", language.trim());
  }

  if (minPages) {
    q = q.gte("page_count", minPages);
  }

  if (maxPages) {
    q = q.lte("page_count", maxPages);
  }

  if (sortBy === "rating") {
    q = q.order("average_rating", { ascending: false, nullsFirst: false });
  } else if (sortBy === "pages") {
    q = q.order("page_count", { ascending: false, nullsFirst: false });
  } else if (sortBy === "newest") {
    q = q.order("published_date", { ascending: false, nullsFirst: false });
  } else {
    q = q.order("created_at", { ascending: false });
  }

  q = q.range(offset, offset + limit - 1);

  const { data, error } = await q;
  if (error) throw error;
  return data || [];
}

export async function getAvailableCategories() {
  if (!supabase) return [];
  const { data, error } = await supabase.rpc("get_distinct_categories");
  if (error) {
    // Fallback: fetch from books table directly
    const { data: books } = await supabase
      .from("books")
      .select("categories")
      .not("categories", "is", null)
      .limit(200);
    if (!books) return [];
    const cats = new Set();
    books.forEach((b) => (b.categories || []).forEach((c) => cats.add(c)));
    return [...cats].sort().slice(0, 50);
  }
  return data || [];
}

export async function getAvailableAuthors(query) {
  if (!supabase || !query?.trim()) return [];
  const pattern = `%${query.trim()}%`;
  const { data, error } = await supabase
    .from("books")
    .select("authors")
    .not("authors", "is", null)
    .limit(100);
  if (error) return [];

  const authors = new Set();
  (data || []).forEach((b) =>
    (b.authors || []).forEach((a) => {
      if (a.toLowerCase().includes(query.trim().toLowerCase())) {
        authors.add(a);
      }
    })
  );
  return [...authors].sort().slice(0, 10);
}
