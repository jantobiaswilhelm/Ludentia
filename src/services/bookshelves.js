import { supabase } from "../config/supabaseClient";

export async function getUserShelves(userId) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("user_bookshelves")
    .select("*, books(*)")
    .eq("user_id", userId)
    .order("added_at", { ascending: false });
  if (error) throw error;
  return data || [];
}

export async function getBookShelfEntry(userId, bookId) {
  if (!supabase) return null;
  const { data } = await supabase
    .from("user_bookshelves")
    .select("*")
    .eq("user_id", userId)
    .eq("book_id", bookId)
    .maybeSingle();
  return data;
}

export async function setBookShelf(userId, bookId, shelf) {
  if (!supabase) throw new Error("Supabase not configured");
  const updates = {
    user_id: userId,
    book_id: bookId,
    shelf,
    added_at: new Date().toISOString(),
    finished_at: shelf === "read" ? new Date().toISOString() : null,
  };

  const { data, error } = await supabase
    .from("user_bookshelves")
    .upsert(updates, { onConflict: "user_id,book_id" })
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function getCurrentlyReading(userId) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("user_bookshelves")
    .select("*, books(*)")
    .eq("user_id", userId)
    .eq("shelf", "reading")
    .order("added_at", { ascending: false });
  if (error) return [];
  return data || [];
}

export async function removeFromShelf(userId, bookId) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase
    .from("user_bookshelves")
    .delete()
    .eq("user_id", userId)
    .eq("book_id", bookId);
  if (error) throw error;
}
