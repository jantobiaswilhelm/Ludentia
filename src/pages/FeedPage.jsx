import { useEffect } from "react";
import { Navigate, Link } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { useFeed } from "../hooks/useFeed";
import FeedItem from "../components/feed/FeedItem";
import EmptyState from "../components/ui/EmptyState";
import Spinner from "../components/ui/Spinner";
import { useDocumentTitle } from "../hooks/useDocumentTitle";

function FeedPage() {
  const { user, loading: authLoading } = useAuth();
  const { events, loading, loadingMore, hasMore, load, loadMore } = useFeed(user?.id);
  useDocumentTitle("Feed");

  useEffect(() => {
    if (user?.id) load();
  }, [user?.id, load]);

  if (authLoading) return <div className="page-center"><Spinner size={40} /></div>;
  if (!user) return <Navigate to="/login" replace />;

  return (
    <div className="feed-page">
      <h1>Activity Feed</h1>

      {loading ? (
        <div className="page-center"><Spinner size={32} /></div>
      ) : events.length === 0 ? (
        <EmptyState
          title="No activity yet"
          description="Follow some readers to see their activity here."
        >
          <Link to="/browse" className="btn btn-primary">Browse readers</Link>
        </EmptyState>
      ) : (
        <div className="feed-list">
          {events.map((event) => (
            <FeedItem key={event.event_id} event={event} />
          ))}
          {hasMore ? (
            <button
              type="button"
              className="btn btn-ghost feed-load-more"
              onClick={loadMore}
              disabled={loadingMore}
            >
              {loadingMore ? "Loading..." : "Load more"}
            </button>
          ) : null}
        </div>
      )}
    </div>
  );
}

export default FeedPage;
