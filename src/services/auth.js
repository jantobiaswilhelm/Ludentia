import { supabase } from "../config/supabaseClient";

export async function signUp({ email, password, username }) {
  if (!supabase) throw new Error("Supabase not configured");
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: { username, display_name: username },
    },
  });
  if (error) throw error;
  return data;
}

export async function signIn({ email, password }) {
  if (!supabase) throw new Error("Supabase not configured");
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });
  if (error) throw error;
  return data;
}

export async function signInWithGoogle() {
  if (!supabase) throw new Error("Supabase not configured");
  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: "google",
    options: {
      redirectTo: window.location.origin,
    },
  });
  if (error) throw error;
  return data;
}

export async function signOut() {
  if (!supabase) throw new Error("Supabase not configured");
  const { error } = await supabase.auth.signOut();
  if (error) throw error;
}

export async function getSession() {
  if (!supabase) return null;
  const { data } = await supabase.auth.getSession();
  return data.session;
}

export async function getProfile(userId) {
  if (!supabase) return null;
  const { data, error } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", userId)
    .single();
  if (error) throw error;
  return data;
}

export async function updateProfile(userId, updates) {
  if (!supabase) throw new Error("Supabase not configured");
  const { data, error } = await supabase
    .from("profiles")
    .update({ ...updates, updated_at: new Date().toISOString() })
    .eq("id", userId)
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function searchProfiles(query, { limit = 20 } = {}) {
  if (!supabase) return [];
  const pattern = `%${query}%`;
  const { data, error } = await supabase
    .from("profiles")
    .select("id, username, display_name, avatar_url, bio")
    .or(`username.ilike.${pattern},display_name.ilike.${pattern}`)
    .limit(limit);
  if (error) throw error;
  return data || [];
}

export async function getProfileByUsername(username) {
  if (!supabase) return null;
  const { data, error } = await supabase
    .from("profiles")
    .select("*")
    .eq("username", username)
    .single();
  if (error) throw error;
  return data;
}
