import { useCallback, useEffect, useState } from "react";
import { useAuth } from "../context/AuthContext";
import { useToast } from "../context/ToastContext";
import { createBookLog, getUserLogs, getBookLogs, getBookRatingStats } from "../services/bookLog";
import { setBookShelf } from "../services/bookshelves";

export function useUserBookLogs() {
  const { user } = useAuth();
  const { addToast } = useToast();
  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    if (!user) return;
    setLoading(true);
    try {
      setLogs(await getUserLogs(user.id));
    } catch (err) {
      addToast({ message: err.message || "Failed to load logs", type: "error" });
    } finally {
      setLoading(false);
    }
  }, [user, addToast]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  return { logs, loading, refresh };
}

export function useBookReviews(bookId) {
  const { addToast } = useToast();
  const [logs, setLogs] = useState([]);
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    if (!bookId) return;
    setLoading(true);
    try {
      const [l, s] = await Promise.all([getBookLogs(bookId), getBookRatingStats(bookId)]);
      setLogs(l);
      setStats(s);
    } catch (err) {
      addToast({ message: err.message || "Failed to load reviews", type: "error" });
    } finally {
      setLoading(false);
    }
  }, [bookId, addToast]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  return { logs, stats, loading, refresh };
}

export function useCreateBookLog() {
  const { user } = useAuth();
  const { addToast } = useToast();
  const [submitting, setSubmitting] = useState(false);

  const submit = async (logData) => {
    if (!user) throw new Error("Must be logged in");
    setSubmitting(true);
    try {
      const log = await createBookLog({ ...logData, user_id: user.id });
      // Also add to "read" shelf
      await setBookShelf(user.id, logData.book_id, "read").catch(() => {});
      addToast({ message: "Book logged successfully!", type: "success" });
      return log;
    } catch (err) {
      addToast({ message: err.message || "Failed to log book", type: "error" });
      throw err;
    } finally {
      setSubmitting(false);
    }
  };

  return { submit, submitting };
}
