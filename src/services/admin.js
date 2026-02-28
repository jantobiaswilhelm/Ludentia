import { supabase } from "../config/supabaseClient";

export async function getReportedContent(status = "pending") {
  if (!supabase) return [];
  const { data, error } = await supabase.rpc("get_reported_content", { p_status: status });
  if (error) throw error;
  return data || [];
}

export async function updateReport(reportId, { status, adminNotes }) {
  if (!supabase) throw new Error("Supabase not configured");
  const updates = { status, resolved_at: new Date().toISOString() };
  if (adminNotes !== undefined) updates.admin_notes = adminNotes;
  const { error } = await supabase.from("reported_content").update(updates).eq("id", reportId);
  if (error) throw error;
}

export async function reportContent({ contentType, contentId, reason }) {
  if (!supabase) throw new Error("Supabase not configured");
  const userId = (await supabase.auth.getUser()).data.user.id;
  const { error } = await supabase.from("reported_content").insert({
    reporter_id: userId,
    content_type: contentType,
    content_id: contentId,
    reason,
  });
  if (error) throw error;
}

export async function getAdminUsers(search = "", limit = 50, offset = 0) {
  if (!supabase) return { total: 0, users: [] };
  const { data, error } = await supabase.rpc("admin_get_users", {
    p_search: search,
    p_limit: limit,
    p_offset: offset,
  });
  if (error) throw error;
  return data;
}

export async function toggleUserAdmin(userId, isAdmin) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase.from("profiles").update({ is_admin: isAdmin }).eq("id", userId);
  if (error) throw error;
}

export async function getAdminTags() {
  if (!supabase) return [];
  const { data, error } = await supabase.rpc("admin_get_tags", { p_limit: 200 });
  if (error) throw error;
  return data || [];
}

export async function deleteTag(tagId) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase.from("tag_definitions").delete().eq("id", tagId);
  if (error) throw error;
}

export async function deleteDiscussionComment(commentId) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase.from("discussion_comments").delete().eq("id", commentId);
  if (error) throw error;
}

export async function isCurrentUserAdmin() {
  if (!supabase) return false;
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return false;
  const { data } = await supabase.from("profiles").select("is_admin").eq("id", user.id).single();
  return data?.is_admin === true;
}
