import { useEffect, useMemo, useState } from "react";
import { searchBooks } from "../services/bookApi";

const SEARCH_DEBOUNCE_MS = 400;

export default function useBookSearch(query, language = "") {
  const [books, setBooks] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState("");

  const normalizedQuery = useMemo(() => query.trim(), [query]);

  useEffect(() => {
    let isCancelled = false;

    if (normalizedQuery.length < 2) {
      setBooks([]);
      setError("");
      setIsLoading(false);
      return () => {
        isCancelled = true;
      };
    }

    setIsLoading(true);
    setError("");

    const timeoutId = setTimeout(async () => {
      try {
        const results = await searchBooks(normalizedQuery, { language });
        if (!isCancelled) {
          setBooks(results);
        }
      } catch (requestError) {
        if (!isCancelled) {
          setError(
            requestError instanceof Error
              ? requestError.message
              : "Failed to search books."
          );
          setBooks([]);
        }
      } finally {
        if (!isCancelled) {
          setIsLoading(false);
        }
      }
    }, SEARCH_DEBOUNCE_MS);

    return () => {
      isCancelled = true;
      clearTimeout(timeoutId);
    };
  }, [normalizedQuery, language]);

  return { books, isLoading, error, hasQuery: normalizedQuery.length >= 2 };
}
