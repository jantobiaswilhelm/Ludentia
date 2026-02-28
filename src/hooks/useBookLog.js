import { useCallback, useEffect, useState } from "react";
import { useAuth } from "../context/AuthContext";
import { createBookLog, getUserLogs, getBookLogs, getBookRatingStats } from "../services/bookLog";
import { setBookShelf } from "../services/bookshelves";

export function useUserBookLogs() {
  const { user } = useAuth();
  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    if (!user) return;
    setLoading(true);
    try {
      setLogs(await getUserLogs(user.id));
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }, [user]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  return { logs, loading, refresh };
}

export function useBookReviews(bookId) {
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
      console.error(err);
    } finally {
      setLoading(false);
    }
  }, [bookId]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  return { logs, stats, loading, refresh };
}

export function useCreateBookLog() {
  const { user } = useAuth();
  const [submitting, setSubmitting] = useState(false);

  const submit = async (logData) => {
    if (!user) throw new Error("Must be logged in");
    setSubmitting(true);
    try {
      const log = await createBookLog({ ...logData, user_id: user.id });
      // Also add to "read" shelf
      await setBookShelf(user.id, logData.book_id, "read").catch(() => {});
      return log;
    } finally {
      setSubmitting(false);
    }
  };

  return { submit, submitting };
}
