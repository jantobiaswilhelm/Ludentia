import { useCallback, useEffect, useState } from "react";
import { useAuth } from "../context/AuthContext";
import {
  getUserDiaryEntries,
  getBookDiaryEntries,
  createDiaryEntry,
  deleteDiaryEntry,
  getReadingProgress,
  updateReadingProgress,
} from "../services/diary";

export function useUserDiary() {
  const { user } = useAuth();
  const [entries, setEntries] = useState([]);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    if (!user) return;
    setLoading(true);
    try {
      setEntries(await getUserDiaryEntries(user.id));
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }, [user]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  return { entries, loading, refresh };
}

export function useBookDiary(bookId) {
  const { user } = useAuth();
  const [entries, setEntries] = useState([]);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    if (!bookId) return;
    setLoading(true);
    try {
      setEntries(await getBookDiaryEntries(bookId));
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }, [bookId]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  const addEntry = async (entryData) => {
    if (!user) return;
    await createDiaryEntry({ ...entryData, user_id: user.id, book_id: bookId });
    await refresh();
  };

  const removeEntry = async (entryId) => {
    await deleteDiaryEntry(entryId);
    await refresh();
  };

  return { entries, loading, addEntry, removeEntry, refresh };
}

export function useReadingProgress(bookId) {
  const { user } = useAuth();
  const [progress, setProgress] = useState(null);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    if (!user || !bookId) return;
    setLoading(true);
    try {
      setProgress(await getReadingProgress(user.id, bookId));
    } catch {
      setProgress(null);
    } finally {
      setLoading(false);
    }
  }, [user, bookId]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  const update = async (updates) => {
    if (!user) return;
    const result = await updateReadingProgress(user.id, bookId, updates);
    setProgress(result);
  };

  return { progress, loading, update, refresh };
}
