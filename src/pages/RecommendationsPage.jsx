import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { getRecommendations } from "../services/recommendations";
import RecommendationCard from "../components/books/RecommendationCard";
import { SkeletonBookGrid } from "../components/ui/Skeleton";
import EmptyState from "../components/ui/EmptyState";
import { useDocumentTitle } from "../hooks/useDocumentTitle";
import { backfillCover } from "../services/bookCache";

function RecommendationsPage() {
  const { user, loading: authLoading } = useAuth();
  const [recs, setRecs] = useState([]);
  const [loading, setLoading] = useState(false);
  useDocumentTitle("Recommendations");

  useEffect(() => {
    if (!user) return;
    setLoading(true);
    getRecommendations(user.id)
      .then(async (data) => {
        const filtered = data.filter((r) => r.book);
        const filled = await Promise.all(filtered.map((r) => backfillCover(r.book)));
        setRecs(filtered.map((r, i) => ({ ...filled[i], score: r.score, reason: r.reason })));
      })
      .finally(() => setLoading(false));
  }, [user]);

  if (authLoading) {
    return <SkeletonBookGrid count={8} />;
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
        <SkeletonBookGrid count={8} />
      ) : recs.length === 0 ? (
        <EmptyState
          title="Not enough data yet"
          description="Rate at least 5 books to get personalized recommendations."
          action={<Link to="/" className="btn btn-primary">Discover Books</Link>}
        />
      ) : (
        <div className="rec-grid">
          {recs.map((rec) => (
            <RecommendationCard key={rec.id} book={rec} reason={rec.reason} />
          ))}
        </div>
      )}
    </div>
  );
}

export default RecommendationsPage;
