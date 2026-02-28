import { useCallback, useEffect, useState } from "react";
import { useAuth } from "../context/AuthContext";
import {
  getUserShelves,
  getBookShelfEntry,
  setBookShelf,
  removeFromShelf,
} from "../services/bookshelves";

export function useUserShelves() {
  const { user } = useAuth();
  const [shelves, setShelves] = useState([]);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    if (!user) return;
    setLoading(true);
    try {
      const data = await getUserShelves(user.id);
      setShelves(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }, [user]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  const byShelf = (name) => shelves.filter((s) => s.shelf === name);

  return { shelves, loading, refresh, byShelf };
}

export function useBookShelfStatus(bookId) {
  const { user } = useAuth();
  const [entry, setEntry] = useState(null);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    if (!user || !bookId) return;
    setLoading(true);
    try {
      const data = await getBookShelfEntry(user.id, bookId);
      setEntry(data);
    } catch {
      setEntry(null);
    } finally {
      setLoading(false);
    }
  }, [user, bookId]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  const setShelf = async (shelf) => {
    if (!user) return;
    await setBookShelf(user.id, bookId, shelf);
    await refresh();
  };

  const remove = async () => {
    if (!user) return;
    await removeFromShelf(user.id, bookId);
    setEntry(null);
  };

  return { entry, loading, setShelf, remove, refresh };
}
