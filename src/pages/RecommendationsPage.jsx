import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { getRecommendations } from "../services/recommendations";
import BookGrid from "../components/books/BookGrid";
import Spinner from "../components/ui/Spinner";
import EmptyState from "../components/ui/EmptyState";

function RecommendationsPage() {
  const { user, loading: authLoading } = useAuth();
  const [recs, setRecs] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!user) return;
    setLoading(true);
    getRecommendations(user.id)
      .then((data) => {
        setRecs(
          data
            .filter((r) => r.book)
            .map((r) => ({
              id: r.book.id,
              title: r.book.title,
              authors: r.book.authors || [],
              coverUrl: r.book.cover_url,
              coverUrlLarge: r.book.cover_url_large,
              pageCount: r.book.page_count,
              averageRating: r.book.google_average_rating,
              score: r.score,
            }))
        );
      })
      .finally(() => setLoading(false));
  }, [user]);

  if (authLoading) {
    return (
      <div className="page-center">
        <Spinner size={40} />
      </div>
    );
  }

  if (!user) {
    return (
      <EmptyState
        title="Sign in for recommendations"
        description="Rate some books and we'll suggest what to read next."
        action={<Link to="/login" className="btn btn-primary">Sign In</Link>}
      />
    );
  }

  return (
    <div className="recommendations-page">
      <h1>Recommended for You</h1>
      <p className="page-subtitle">Based on your ratings, tags, and reading history.</p>

      {loading ? (
        <div className="page-center">
          <Spinner size={40} />
        </div>
      ) : recs.length === 0 ? (
        <EmptyState
          title="Not enough data yet"
          description="Rate at least 5 books to get personalized recommendations."
          action={<Link to="/" className="btn btn-primary">Discover Books</Link>}
        />
      ) : (
        <BookGrid books={recs} />
      )}
    </div>
  );
}

export default RecommendationsPage;
