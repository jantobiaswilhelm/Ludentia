import { supabase } from "../config/supabaseClient";

export async function getUserLists(userId) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("lists")
    .select("*, list_items(id)")
    .eq("user_id", userId)
    .order("updated_at", { ascending: false });
  if (error) throw error;
  return (data || []).map((list) => ({
    ...list,
    item_count: list.list_items?.length || 0,
    list_items: undefined,
  }));
}

export async function getList(listId) {
  if (!supabase) return null;
  const { data, error } = await supabase
    .from("lists")
    .select("*, list_items(*, books(id, title, authors, cover_url, page_count))")
    .eq("id", listId)
    .single();
  if (error) throw error;
  if (data?.list_items) {
    data.list_items.sort((a, b) => a.position - b.position);
  }
  return data;
}

export async function createList({ title, description, visibility = "public", is_ranked = false }) {
  if (!supabase) throw new Error("Supabase not configured");
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error("Not authenticated");

  const { data, error } = await supabase
    .from("lists")
    .insert({ user_id: user.id, title, description, visibility, is_ranked })
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function updateList(listId, updates) {
  if (!supabase) throw new Error("Supabase not configured");
  const { data, error } = await supabase
    .from("lists")
    .update({ ...updates, updated_at: new Date().toISOString() })
    .eq("id", listId)
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function deleteList(listId) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase.from("lists").delete().eq("id", listId);
  if (error) throw error;
}

export async function addBookToList(listId, bookId, { note, position } = {}) {
  if (!supabase) throw new Error("Supabase not configured");

  let pos = position;
  if (pos == null) {
    const { data: existing } = await supabase
      .from("list_items")
      .select("position")
      .eq("list_id", listId)
      .order("position", { ascending: false })
      .limit(1);
    pos = (existing?.[0]?.position ?? -1) + 1;
  }

  const { data, error } = await supabase
    .from("list_items")
    .insert({ list_id: listId, book_id: bookId, note, position: pos })
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function removeBookFromList(listId, bookId) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase
    .from("list_items")
    .delete()
    .eq("list_id", listId)
    .eq("book_id", bookId);
  if (error) throw error;
}

export async function reorderListItems(listId, orderedItemIds) {
  if (!supabase) throw new Error("Supabase not configured");
  const updates = orderedItemIds.map((id, index) => ({ id, position: index }));
  // Update each item's position
  await Promise.all(
    updates.map(({ id, position }) =>
      supabase.from("list_items").update({ position }).eq("id", id)
    )
  );
}

export async function getListsContainingBook(userId, bookId) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("lists")
    .select("id, title, list_items!inner(book_id)")
    .eq("user_id", userId)
    .eq("list_items.book_id", bookId);
  if (error) return [];
  return (data || []).map((l) => l.id);
}
