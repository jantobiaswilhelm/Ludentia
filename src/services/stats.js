import { supabase } from "../config/supabaseClient";

export async function getUserReadingStats(userId, year = null) {
  if (!supabase) return null;

  const { data, error } = await supabase.rpc("get_user_reading_stats", {
    p_user_id: userId,
    p_year: year,
  });
  if (error) throw error;
  return data;
}

export async function getYearInReview(userId, year = new Date().getFullYear()) {
  if (!supabase) return null;

  const { data, error } = await supabase.rpc("get_year_in_review", {
    p_user_id: userId,
    p_year: year,
  });
  if (error) throw error;
  return data;
}
