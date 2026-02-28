import { supabase } from "../config/supabaseClient";

export async function getExportData(userId) {
  if (!supabase) return null;

  const [logsRes, shelvesRes, diaryRes, listsRes] = await Promise.all([
    supabase.from("book_logs").select("*, books(title, authors, isbn_13, isbn_10)").eq("user_id", userId).order("created_at", { ascending: false }),
    supabase.from("user_bookshelves").select("*, books(title, authors, isbn_13, isbn_10)").eq("user_id", userId),
    supabase.from("diary_entries").select("*, books(title)").eq("user_id", userId).order("created_at", { ascending: false }),
    supabase.from("lists").select("*, list_items(*, books(title, authors))").eq("user_id", userId),
  ]);

  return {
    book_logs: logsRes.data || [],
    bookshelves: shelvesRes.data || [],
    diary_entries: diaryRes.data || [],
    lists: listsRes.data || [],
    exported_at: new Date().toISOString(),
  };
}

export function exportAsJSON(data) {
  const blob = new Blob([JSON.stringify(data, null, 2)], { type: "application/json" });
  downloadBlob(blob, `ludentia-export-${formatDateFile()}.json`);
}

export function exportAsCSV(logs) {
  const headers = ["Title", "Authors", "Rating", "Review", "Date Started", "Date Finished", "Shelf", "Is Reread", "Contains Spoilers", "ISBN-13"];
  const rows = logs.map((log) => [
    csvEscape(log.books?.title || ""),
    csvEscape((log.books?.authors || []).join("; ")),
    log.rating ?? "",
    csvEscape(log.review_text || ""),
    log.date_started || "",
    log.date_finished || "",
    log.shelf || "",
    log.is_reread ? "Yes" : "No",
    log.contains_spoilers ? "Yes" : "No",
    log.books?.isbn_13 || "",
  ]);

  const csv = [headers, ...rows].map((r) => r.join(",")).join("\n");
  const blob = new Blob([csv], { type: "text/csv" });
  downloadBlob(blob, `ludentia-books-${formatDateFile()}.csv`);
}

function csvEscape(str) {
  if (!str) return "";
  if (str.includes(",") || str.includes('"') || str.includes("\n")) {
    return `"${str.replace(/"/g, '""')}"`;
  }
  return str;
}

function downloadBlob(blob, filename) {
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}

function formatDateFile() {
  return new Date().toISOString().slice(0, 10);
}
