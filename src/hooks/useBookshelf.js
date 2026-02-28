import { useCallback, useEffect, useState } from "react";
import { useAuth } from "../context/AuthContext";
import { useToast } from "../context/ToastContext";
import {
  getUserShelves,
  getBookShelfEntry,
  setBookShelf,
  removeFromShelf,
} from "../services/bookshelves";

export function useUserShelves() {
  const { user } = useAuth();
  const { addToast } = useToast();
  const [shelves, setShelves] = useState([]);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    if (!user) return;
    setLoading(true);
    try {
      const data = await getUserShelves(user.id);
      setShelves(data);
    } catch (err) {
      addToast({ message: err.message || "Failed to load shelves", type: "error" });
    } finally {
      setLoading(false);
    }
  }, [user, addToast]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  const byShelf = (name) => shelves.filter((s) => s.shelf === name);

  return { shelves, loading, refresh, byShelf };
}

export function useBookShelfStatus(bookId) {
  const { user } = useAuth();
  const { addToast } = useToast();
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
    try {
      await setBookShelf(user.id, bookId, shelf);
      addToast({ message: "Shelf updated!", type: "success" });
      await refresh();
    } catch (err) {
      addToast({ message: err.message || "Failed to update shelf", type: "error" });
    }
  };

  const remove = async () => {
    if (!user) return;
    try {
      await removeFromShelf(user.id, bookId);
      setEntry(null);
    } catch (err) {
      addToast({ message: err.message || "Failed to remove from shelf", type: "error" });
    }
  };

  return { entry, loading, setShelf, remove, refresh };
}
