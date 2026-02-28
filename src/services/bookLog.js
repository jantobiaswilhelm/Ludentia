import { supabase } from "../config/supabaseClient";

export async function createBookLog(logData) {
  if (!supabase) throw new Error("Supabase not configured");
  const { data, error } = await supabase
    .from("book_logs")
    .insert(logData)
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function getUserLogs(userId) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("book_logs")
    .select("*, books(*)")
    .eq("user_id", userId)
    .order("created_at", { ascending: false });
  if (error) throw error;
  return data || [];
}

export async function getBookLogs(bookId) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("book_logs")
    .select("*, profiles(username, display_name, avatar_url)")
    .eq("book_id", bookId)
    .eq("visibility", "public")
    .order("created_at", { ascending: false });
  if (error) throw error;
  return data || [];
}

export async function getBookRatingStats(bookId) {
  if (!supabase) return null;
  const { data } = await supabase
    .from("book_rating_stats")
    .select("*")
    .eq("book_id", bookId)
    .maybeSingle();
  return data;
}

export async function updateBookLog(logId, updates) {
  if (!supabase) throw new Error("Supabase not configured");
  const { data, error } = await supabase
    .from("book_logs")
    .update(updates)
    .eq("id", logId)
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function deleteBookLog(logId) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase.from("book_logs").delete().eq("id", logId);
  if (error) throw error;
}
