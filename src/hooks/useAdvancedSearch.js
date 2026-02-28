import { useCallback, useEffect, useRef, useState } from "react";
import { searchCachedBooks } from "../services/search";
import { searchGoogleBooksAdvanced } from "../services/bookApi";

export function useAdvancedSearch(filters) {
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [totalCached, setTotalCached] = useState(0);
  const debounceRef = useRef(null);

  const search = useCallback(async (f) => {
    const hasAnyFilter = f.query?.trim() || f.author?.trim() || f.category?.trim();
    if (!hasAnyFilter) {
      setResults([]);
      setTotalCached(0);
      return;
    }

    setLoading(true);
    setError(null);
    try {
      const cached = await searchCachedBooks(f);
      setResults(cached);
      setTotalCached(cached.length);
    } catch (err) {
      setError(err.message);
      setResults([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => search(filters), 400);
    return () => clearTimeout(debounceRef.current);
  }, [filters, search]);

  const searchExternal = useCallback(async () => {
    setLoading(true);
    try {
      const external = await searchGoogleBooksAdvanced(filters.query, {
        author: filters.author,
        subject: filters.category,
        maxResults: 24,
        language: filters.language,
      });
      // Merge with existing, dedup by id
      setResults((prev) => {
        const ids = new Set(prev.map((b) => b.id));
        const newBooks = external.filter((b) => !ids.has(b.id));
        return [...prev, ...newBooks];
      });
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, [filters]);

  return { results, loading, error, totalCached, searchExternal };
}
