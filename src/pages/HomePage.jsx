import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import BookGrid from "../components/books/BookGrid";
import RecommendationCard from "../components/books/RecommendationCard";
import ContinueReadingRow from "../components/books/ContinueReadingRow";
import SearchBar from "../components/search/SearchBar";
import useBookSearch from "../hooks/useBookSearch";
import { useAuth } from "../context/AuthContext";
import { getRecommendations, getTrendingBooks } from "../services/recommendations";
import { getOfficialTags } from "../services/tags";
import { TAG_COLORS } from "../utils/constants";
import { SkeletonBookGrid } from "../components/ui/Skeleton";

function HomePage() {
  const [query, setQuery] = useState("");
  const [language, setLanguage] = useState("");
  const { books, isLoading, error, hasQuery } = useBookSearch(query, language);
  const { user, profile } = useAuth();
  const [recs, setRecs] = useState([]);
  const [trending, setTrending] = useState([]);
  const [popularTags, setPopularTags] = useState([]);
  const [recsLoading, setRecsLoading] = useState(false);

  useEffect(() => {
    getOfficialTags().then((tags) => setPopularTags(tags.slice(0, 12)));
    if (user) {
      setRecsLoading(true);
      getRecommendations(user.id, 8)
        .then((data) =>
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
                reason: r.reason,
              }))
          )
        )
        .finally(() => setRecsLoading(false));
    } else {
      getTrendingBooks(8).then((data) =>
        setTrending(
          data.map((b) => ({
            id: b.id,
            title: b.title,
            authors: b.authors || [],
            coverUrl: b.cover_url,
            coverUrlLarge: b.cover_url_large,
            pageCount: b.page_count,
            averageRating: b.google_average_rating,
          }))
        )
      );
    }
  }, [user]);

  return (
    <div className="home-page">
      {/* Logged-in greeting or Hero panel */}
      {user ? (
        <p className="home-greeting">
          Welcome back, {profile?.display_name || profile?.username || "reader"}
        </p>
      ) : (
        <section className="hero-panel">
          <p className="eyebrow">Your reading companion</p>
          <h1>Discover books by feel, not just by title.</h1>
          <p>
            Search for books, track your reading, and tag books with how they actually feel.
            Community tags power smarter discovery.
          </p>
        </section>
      )}

      <SearchBar value={query} onChange={setQuery} language={language} onLanguageChange={setLanguage} />

      {/* Search results */}
      <section className="results-panel">
        {isLoading ? <SkeletonBookGrid count={8} /> : null}
        {!isLoading && error ? <p className="status-message error">{error}</p> : null}
        {!isLoading && hasQuery && !error && books.length === 0 ? (
          <p className="status-message">No books found for that search.</p>
        ) : null}
        {hasQuery ? <BookGrid books={books} /> : null}
      </section>

      {/* Below search content */}
      {!hasQuery ? (
        <>
          {/* Popular tag pills */}
          {popularTags.length > 0 ? (
            <div className="home-tags">
              <p className="home-tags-label">Popular tags</p>
              <div className="tag-list">
                {popularTags.map((tag) => {
                  const colors = TAG_COLORS[tag.color] || TAG_COLORS.gray;
                  return (
                    <Link
                      key={tag.id}
                      to={`/tag/${tag.slug}`}
                      className="tag-badge"
                      style={{
                        "--tag-bg": colors.bg,
                        "--tag-text": colors.text,
                        "--tag-border": colors.border,
                      }}
                    >
                      <span className="tag-label">{tag.label}</span>
                    </Link>
                  );
                })}
              </div>
            </div>
          ) : null}

          {/* Logged-in: Continue Reading + Recommendations */}
          {user ? (
            <>
              <ContinueReadingRow />

              <section className="home-section">
                <h2>Recommended for You</h2>
                {recsLoading ? (
                  <SkeletonBookGrid count={8} />
                ) : recs.length > 0 ? (
                  <>
                    <div className="rec-grid">
                      {recs.map((rec) => (
                        <RecommendationCard key={rec.id} book={rec} reason={rec.reason} />
                      ))}
                    </div>
                    <Link to="/recommendations" className="btn btn-ghost btn-sm home-see-all">
                      See all recommendations
                    </Link>
                  </>
                ) : (
                  <p className="muted-text">
                    Rate a few more books and we'll have personalized picks for you!
                  </p>
                )}
              </section>
            </>
          ) : null}

          {/* Logged-out: Trending + Sign up CTA */}
          {!user ? (
            <>
              {trending.length > 0 ? (
                <section className="home-section">
                  <h2>Trending</h2>
                  <BookGrid books={trending} />
                </section>
              ) : null}

              <section className="home-section" style={{ textAlign: "center" }}>
                <h2>Join the community</h2>
                <p className="muted-text" style={{ marginBottom: "1rem" }}>
                  Track your reading, tag books with vibes, and get smarter recommendations.
                </p>
                <Link to="/signup" className="btn btn-primary">
                  Create an account
                </Link>
              </section>
            </>
          ) : null}
        </>
      ) : null}
    </div>
  );
}

export default HomePage;
