import { supabase } from "../config/supabaseClient";

export async function getBookDiscussions(bookId, { limit = 20, offset = 0 } = {}) {
  if (!supabase) return { total: 0, comments: [] };
  const { data, error } = await supabase.rpc("get_book_discussions", {
    p_book_id: bookId,
    p_limit: limit,
    p_offset: offset,
  });
  if (error) throw error;
  return data;
}

export async function addComment({ bookId, commentText, containsSpoilers = false, parentId = null }) {
  if (!supabase) throw new Error("Supabase not configured");
  const row = {
    book_id: bookId,
    user_id: (await supabase.auth.getUser()).data.user.id,
    comment_text: commentText,
    contains_spoilers: containsSpoilers,
  };
  if (parentId) row.parent_id = parentId;
  const { data, error } = await supabase
    .from("discussion_comments")
    .insert(row)
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function updateComment(id, updates) {
  if (!supabase) throw new Error("Supabase not configured");
  const { data, error } = await supabase
    .from("discussion_comments")
    .update({ ...updates, updated_at: new Date().toISOString() })
    .eq("id", id)
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function deleteComment(id) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase.from("discussion_comments").delete().eq("id", id);
  if (error) throw error;
}
