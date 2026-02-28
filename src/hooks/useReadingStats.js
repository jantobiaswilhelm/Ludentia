import { useCallback, useEffect, useState } from "react";
import { getUserReadingStats, getYearInReview } from "../services/stats";

export function useReadingStats(userId, initialYear = null) {
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [year, setYear] = useState(initialYear);

  const load = useCallback(async () => {
    if (!userId) return;
    setLoading(true);
    try {
      const data = await getUserReadingStats(userId, year);
      setStats(data);
    } catch {
      setStats(null);
    } finally {
      setLoading(false);
    }
  }, [userId, year]);

  useEffect(() => {
    load();
  }, [load]);

  return { stats, loading, year, setYear };
}

export function useYearInReview(userId, initialYear = new Date().getFullYear()) {
  const [review, setReview] = useState(null);
  const [loading, setLoading] = useState(true);
  const [year, setYear] = useState(initialYear);

  const load = useCallback(async () => {
    if (!userId) return;
    setLoading(true);
    try {
      const data = await getYearInReview(userId, year);
      setReview(data);
    } catch {
      setReview(null);
    } finally {
      setLoading(false);
    }
  }, [userId, year]);

  useEffect(() => {
    load();
  }, [load]);

  return { review, loading, year, setYear };
}
