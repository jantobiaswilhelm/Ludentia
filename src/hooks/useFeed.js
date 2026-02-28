import { useCallback, useState } from "react";
import { getActivityFeed } from "../services/feed";

export function useFeed(userId) {
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(false);
  const [loadingMore, setLoadingMore] = useState(false);
  const [hasMore, setHasMore] = useState(true);

  const load = useCallback(async () => {
    if (!userId) return;
    setLoading(true);
    try {
      const data = await getActivityFeed(userId, { limit: 20 });
      setEvents(data);
      setHasMore(data.length >= 20);
    } catch {
      setEvents([]);
    } finally {
      setLoading(false);
    }
  }, [userId]);

  const loadMore = useCallback(async () => {
    if (!userId || events.length === 0) return;
    setLoadingMore(true);
    try {
      const oldest = events[events.length - 1].created_at;
      const data = await getActivityFeed(userId, { limit: 20, before: oldest });
      setEvents((prev) => [...prev, ...data]);
      setHasMore(data.length >= 20);
    } catch {
      // ignore
    } finally {
      setLoadingMore(false);
    }
  }, [userId, events]);

  const refresh = useCallback(() => {
    setHasMore(true);
    return load();
  }, [load]);

  return { events, loading, loadingMore, hasMore, load, loadMore, refresh };
}
