import { supabase } from "../config/supabaseClient";

export async function getGoalProgress(userId, year = new Date().getFullYear()) {
  if (!supabase) return null;
  const { data, error } = await supabase.rpc("get_goal_progress", {
    p_user_id: userId,
    p_year: year,
  });
  if (error) throw error;
  return data;
}

export async function setReadingGoal(userId, year, target) {
  if (!supabase) throw new Error("Supabase not configured");
  const { data, error } = await supabase
    .from("reading_goals")
    .upsert({ user_id: userId, year, target_books: target, updated_at: new Date().toISOString() }, { onConflict: "user_id,year" })
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function deleteReadingGoal(goalId) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase.from("reading_goals").delete().eq("id", goalId);
  if (error) throw error;
}
