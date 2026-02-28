import { supabase } from "../config/supabaseClient";

export async function getReadingStreak(userId) {
  if (!supabase) return null;
  const { data, error } = await supabase.rpc("get_reading_streak", {
    p_user_id: userId,
  });
  if (error) throw error;
  return data;
}
