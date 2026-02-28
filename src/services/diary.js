import { supabase } from "../config/supabaseClient";

// --- Diary Entries ---

export async function createDiaryEntry(entry) {
  if (!supabase) throw new Error("Supabase not configured");
  const { data, error } = await supabase
    .from("diary_entries")
    .insert(entry)
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function getUserDiaryEntries(userId) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("diary_entries")
    .select("*, books(id, title, cover_url, authors)")
    .eq("user_id", userId)
    .order("created_at", { ascending: false });
  if (error) throw error;
  return data || [];
}

export async function getBookDiaryEntries(bookId) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("diary_entries")
    .select("*, profiles(username, display_name, avatar_url)")
    .eq("book_id", bookId)
    .eq("visibility", "public")
    .order("created_at", { ascending: false });
  if (error) throw error;
  return data || [];
}

export async function deleteDiaryEntry(entryId) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase
    .from("diary_entries")
    .delete()
    .eq("id", entryId);
  if (error) throw error;
}

// --- Reading Progress ---

export async function getReadingProgress(userId, bookId) {
  if (!supabase) return null;
  const { data } = await supabase
    .from("reading_progress")
    .select("*")
    .eq("user_id", userId)
    .eq("book_id", bookId)
    .maybeSingle();
  return data;
}

export async function updateReadingProgress(userId, bookId, updates) {
  if (!supabase) throw new Error("Supabase not configured");
  const row = {
    user_id: userId,
    book_id: bookId,
    ...updates,
    updated_at: new Date().toISOString(),
  };
  const { data, error } = await supabase
    .from("reading_progress")
    .upsert(row, { onConflict: "user_id,book_id" })
    .select()
    .single();
  if (error) throw error;
  return data;
}
