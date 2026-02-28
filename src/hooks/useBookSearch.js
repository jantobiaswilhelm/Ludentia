import { useEffect, useMemo, useState } from "react";
import { useToast } from "../context/ToastContext";
import { searchBooks } from "../services/bookApi";

const SEARCH_DEBOUNCE_MS = 400;

export default function useBookSearch(query, language = "") {
  const { addToast } = useToast();
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
          const msg =
            requestError instanceof Error
              ? requestError.message
              : "Failed to search books.";
          setError(msg);
          setBooks([]);
          addToast({ message: msg, type: "error" });
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
  }, [normalizedQuery, language, addToast]);

  return { books, isLoading, error, hasQuery: normalizedQuery.length >= 2 };
}
