import { useCallback, useEffect, useState } from "react";
import { useAuth } from "../context/AuthContext";
import { useToast } from "../context/ToastContext";
import {
  getBookTagCounts,
  getUserBookVotes,
  voteTag,
  removeVote,
  getOfficialTags,
} from "../services/tags";

export default function useBookTags(bookId) {
  const { user } = useAuth();
  const { addToast } = useToast();
  const [tagCounts, setTagCounts] = useState([]);
  const [userVotes, setUserVotes] = useState([]);
  const [officialTags, setOfficialTags] = useState([]);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    if (!bookId) return;
    setLoading(true);
    try {
      const [counts, official] = await Promise.all([
        getBookTagCounts(bookId),
        getOfficialTags(),
      ]);
      setTagCounts(counts);
      setOfficialTags(official);
      if (user) {
        const votes = await getUserBookVotes(user.id, bookId);
        setUserVotes(votes);
      }
    } catch (err) {
      addToast({ message: err.message || "Failed to load tags", type: "error" });
    } finally {
      setLoading(false);
    }
  }, [bookId, user, addToast]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  const toggleVote = async (tagId) => {
    if (!user || !bookId) return;
    try {
      if (userVotes.includes(tagId)) {
        await removeVote(user.id, bookId, tagId);
      } else {
        await voteTag(user.id, bookId, tagId);
      }
      await refresh();
    } catch (err) {
      addToast({ message: err.message || "Failed to update vote", type: "error" });
    }
  };

  return { tagCounts, userVotes, officialTags, loading, toggleVote, refresh };
}
