import { useCallback, useEffect, useState } from "react";
import { getReadingStreak } from "../services/streaks";

export function useReadingStreak(userId) {
  const [streak, setStreak] = useState(null);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    if (!userId) return;
    setLoading(true);
    try {
      const data = await getReadingStreak(userId);
      setStreak(data);
    } catch {
      setStreak(null);
    } finally {
      setLoading(false);
    }
  }, [userId]);

  useEffect(() => {
    load();
  }, [load]);

  return { streak, loading };
}
