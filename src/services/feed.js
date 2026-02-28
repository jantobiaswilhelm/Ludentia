import { supabase } from "../config/supabaseClient";

export async function getActivityFeed(userId, { limit = 20, before = null } = {}) {
  if (!supabase) return [];

  const { data, error } = await supabase.rpc("get_activity_feed", {
    p_user_id: userId,
    p_limit: limit,
    p_before: before || new Date().toISOString(),
  });
  if (error) throw error;

  const events = data || [];
  if (events.length === 0) return [];

  // Batch-fetch unique books and profiles
  const bookIds = [...new Set(events.map((e) => e.book_id).filter(Boolean))];
  const userIds = [...new Set(events.map((e) => e.user_id).filter(Boolean))];

  const [booksResult, profilesResult] = await Promise.all([
    bookIds.length > 0
      ? supabase.from("books").select("id, title, cover_url, authors").in("id", bookIds)
      : { data: [] },
    userIds.length > 0
      ? supabase.from("profiles").select("id, username, display_name, avatar_url").in("id", userIds)
      : { data: [] },
  ]);

  const booksMap = Object.fromEntries((booksResult.data || []).map((b) => [b.id, b]));
  const profilesMap = Object.fromEntries((profilesResult.data || []).map((p) => [p.id, p]));

  return events.map((e) => ({
    ...e,
    book: booksMap[e.book_id] || null,
    profile: profilesMap[e.user_id] || null,
  }));
}
