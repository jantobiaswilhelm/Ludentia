import { supabase } from "../config/supabaseClient";

export async function followUser(followerId, followingId) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase
    .from("follows")
    .insert({ follower_id: followerId, following_id: followingId });
  if (error) throw error;
}

export async function unfollowUser(followerId, followingId) {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase
    .from("follows")
    .delete()
    .eq("follower_id", followerId)
    .eq("following_id", followingId);
  if (error) throw error;
}

export async function getFollowers(userId, { limit = 50, offset = 0 } = {}) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("follows")
    .select("follower_id, profiles!follows_follower_id_fkey(id, username, display_name, avatar_url, bio)")
    .eq("following_id", userId)
    .range(offset, offset + limit - 1);
  if (error) throw error;
  return (data || []).map((f) => f.profiles);
}

export async function getFollowing(userId, { limit = 50, offset = 0 } = {}) {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from("follows")
    .select("following_id, profiles!follows_following_id_fkey(id, username, display_name, avatar_url, bio)")
    .eq("follower_id", userId)
    .range(offset, offset + limit - 1);
  if (error) throw error;
  return (data || []).map((f) => f.profiles);
}

export async function getFollowerCount(userId) {
  if (!supabase) return 0;
  const { count, error } = await supabase
    .from("follows")
    .select("id", { count: "exact", head: true })
    .eq("following_id", userId);
  if (error) throw error;
  return count || 0;
}

export async function getFollowingCount(userId) {
  if (!supabase) return 0;
  const { count, error } = await supabase
    .from("follows")
    .select("id", { count: "exact", head: true })
    .eq("follower_id", userId);
  if (error) throw error;
  return count || 0;
}

export async function isFollowing(followerId, followingId) {
  if (!supabase) return false;
  const { data } = await supabase
    .from("follows")
    .select("id")
    .eq("follower_id", followerId)
    .eq("following_id", followingId)
    .maybeSingle();
  return !!data;
}

export async function areFriends(userA, userB) {
  if (!supabase) return false;
  const [aFollowsB, bFollowsA] = await Promise.all([
    isFollowing(userA, userB),
    isFollowing(userB, userA),
  ]);
  return aFollowsB && bFollowsA;
}
