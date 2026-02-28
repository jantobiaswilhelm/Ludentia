import { useCallback, useEffect, useState } from "react";
import {
  getUserLists,
  getList,
  addBookToList,
  removeBookFromList,
  reorderListItems,
} from "../services/lists";

export function useUserLists(userId) {
  const [lists, setLists] = useState([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    if (!userId) return;
    setLoading(true);
    try {
      const data = await getUserLists(userId);
      setLists(data);
    } catch {
      setLists([]);
    } finally {
      setLoading(false);
    }
  }, [userId]);

  useEffect(() => {
    load();
  }, [load]);

  return { lists, loading, refresh: load };
}

export function useList(listId) {
  const [list, setList] = useState(null);
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    if (!listId) return;
    setLoading(true);
    try {
      const data = await getList(listId);
      setList(data);
      setItems(data?.list_items || []);
    } catch {
      setList(null);
      setItems([]);
    } finally {
      setLoading(false);
    }
  }, [listId]);

  useEffect(() => {
    load();
  }, [load]);

  const addBook = useCallback(async (bookId, opts) => {
    await addBookToList(listId, bookId, opts);
    await load();
  }, [listId, load]);

  const removeBook = useCallback(async (bookId) => {
    await removeBookFromList(listId, bookId);
    setItems((prev) => prev.filter((i) => i.book_id !== bookId));
  }, [listId]);

  const reorder = useCallback(async (orderedItemIds) => {
    await reorderListItems(listId, orderedItemIds);
    await load();
  }, [listId, load]);

  return { list, items, loading, addBook, removeBook, reorder, refresh: load };
}
