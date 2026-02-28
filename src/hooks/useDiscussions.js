import { useCallback, useEffect, useState } from "react";
import { useToast } from "../context/ToastContext";
import { getBookDiscussions, addComment, deleteComment } from "../services/discussions";

const PAGE_SIZE = 20;

export function useDiscussions(bookId) {
  const { addToast } = useToast();
  const [discussions, setDiscussions] = useState({ total: 0, comments: [] });
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);

  const load = useCallback(async (p = 0) => {
    if (!bookId) return;
    setLoading(true);
    try {
      const data = await getBookDiscussions(bookId, { limit: PAGE_SIZE, offset: p * PAGE_SIZE });
      setDiscussions(data);
    } catch {
      setDiscussions({ total: 0, comments: [] });
    } finally {
      setLoading(false);
    }
  }, [bookId]);

  useEffect(() => {
    load(page);
  }, [load, page]);

  const hasMore = discussions.total > (page + 1) * PAGE_SIZE;

  const postComment = useCallback(async ({ commentText, containsSpoilers, parentId }) => {
    try {
      await addComment({ bookId, commentText, containsSpoilers, parentId });
      addToast({ message: "Comment posted!", type: "success" });
      await load(page);
    } catch (err) {
      addToast({ message: err.message || "Failed to post comment", type: "error" });
    }
  }, [bookId, page, load, addToast]);

  const removeComment = useCallback(async (commentId) => {
    try {
      await deleteComment(commentId);
      addToast({ message: "Comment deleted", type: "success" });
      await load(page);
    } catch (err) {
      addToast({ message: err.message || "Failed to delete comment", type: "error" });
    }
  }, [page, load, addToast]);

  return { discussions, loading, hasMore, page, setPage, postComment, removeComment };
}
