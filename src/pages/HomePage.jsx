import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import BookGrid from "../components/books/BookGrid";
import RecommendationCard from "../components/books/RecommendationCard";
import ContinueReadingRow from "../components/books/ContinueReadingRow";
import GuidedDiscovery from "../components/discovery/GuidedDiscovery";
import SearchBar from "../components/search/SearchBar";
import useBookSearch from "../hooks/useBookSearch";
import { useAuth } from "../context/AuthContext";
import { getRecommendations, getTrendingBooks } from "../services/recommendations";
import { getOfficialTags } from "../services/tags";
import { TAG_COLORS } from "../utils/constants";
import { SkeletonBookGrid } from "../components/ui/Skeleton";
import { useReadingGoal } from "../hooks/useReadingGoals";
import { useReadingStreak } from "../hooks/useReadingStreak";
import { useDocumentTitle } from "../hooks/useDocumentTitle";
import GoalProgress from "../components/goals/GoalProgress";
import StreakBadge from "../components/streaks/StreakBadge";

const QUICK_TAG_CATEGORIES = ["Mood", "Pacing", "Themes"];

function HomePage() {
  const [query, setQuery] = useState("");
  const [language, setLanguage] = useState("");
  const { books, isLoading, error, hasQuery } = useBookSearch(query, language);
  const { user, profile } = useAuth();
  const [recs, setRecs] = useState([]);
  const [trending, setTrending] = useState([]);
  const [quickTags, setQuickTags] = useState([]);
  const [recsLoading, setRecsLoading] = useState(false);
  const { goalData } = useReadingGoal(user?.id);
  const { streak } = useReadingStreak(user?.id);
  const [searchOpen, setSearchOpen] = useState(false);
  useDocumentTitle("Home");

  useEffect(() => {
    getOfficialTags().then((tags) => {
      setQuickTags(tags.filter((t) => QUICK_TAG_CATEGORIES.includes(t.category)).slice(0, 16));
    });
    if (user) {
      setRecsLoading(true);
      getRecommendations(user.id, 12)
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
      {/* ── Greeting + engagement (logged-in only) ── */}
      {user ? (
        <>
          <p className="home-greeting">
            Welcome back, {profile?.display_name || profile?.username || "reader"}
          </p>
          {(goalData?.goal || streak) ? (
            <div className="home-engagement-row">
              {goalData?.goal ? <GoalProgress goalData={goalData} compact /> : null}
              {streak ? <StreakBadge streak={streak} compact /> : null}
            </div>
          ) : null}
        </>
      ) : (
        <section className="hero-panel">
          <p className="eyebrow">Your reading companion</p>
          <h1>Find your next book by feel.</h1>
          <p>
            Tell us your mood and we'll match you with the perfect read.
            No endless scrolling — just answer a few questions.
          </p>
        </section>
      )}

      {/* ── HERO: Guided Discovery wizard ── */}
      <section className="home-section home-guide-hero">
        <div className="home-guide-wrapper">
          <GuidedDiscovery />
        </div>
      </section>

      {/* ── Quick tags (secondary) ── */}
      {quickTags.length > 0 ? (
        <section className="home-section home-quick-tags">
          <p className="home-quick-tags-label">Or jump to a tag</p>
          <div className="mood-pills">
            {quickTags.map((tag) => {
              const colors = TAG_COLORS[tag.color] || TAG_COLORS.gray;
              return (
                <Link
                  key={tag.id}
                  to={`/tag/${tag.slug}`}
                  className="mood-pill"
                  style={{
                    "--pill-bg": colors.bg,
                    "--pill-text": colors.text,
                    "--pill-border": colors.border,
                  }}
                >
                  {tag.label}
                </Link>
              );
            })}
          </div>
        </section>
      ) : null}

      {/* ── Logged-in: Recs + Continue Reading ── */}
      {user ? (
        <>
          <section className="home-section">
            <div className="home-section-header">
              <h2>Recommended for You</h2>
              <Link to="/recommendations" className="btn btn-ghost btn-sm">
                See all
              </Link>
            </div>
            {recsLoading ? (
              <SkeletonBookGrid count={8} />
            ) : recs.length > 0 ? (
              <div className="rec-grid">
                {recs.map((rec) => (
                  <RecommendationCard key={rec.id} book={rec} reason={rec.reason} />
                ))}
              </div>
            ) : (
              <div className="home-recs-empty">
                <p>Rate a few books and we'll have personalized picks for you!</p>
              </div>
            )}
          </section>

          <ContinueReadingRow />
        </>
      ) : null}

      {/* ── Logged-out: Trending + CTA ── */}
      {!user ? (
        <>
          {trending.length > 0 ? (
            <section className="home-section">
              <h2>Trending</h2>
              <BookGrid books={trending} />
            </section>
          ) : null}

          <section className="home-section home-cta">
            <h2>Join the community</h2>
            <p className="muted-text">
              Track your reading, tag books with vibes, and get smarter recommendations.
            </p>
            <Link to="/signup" className="btn btn-primary">
              Create an account
            </Link>
          </section>
        </>
      ) : null}

      {/* ── Search (secondary, collapsible) ── */}
      <section className="home-search-section">
        <button
          type="button"
          className={`home-search-toggle ${searchOpen ? "open" : ""}`}
          onClick={() => setSearchOpen((v) => !v)}
        >
          <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.8" width="18" height="18">
            <circle cx="8.5" cy="8.5" r="5.5" />
            <path d="M12.5 12.5L17 17" strokeLinecap="round" />
          </svg>
          Looking for a specific book?
          <svg className="home-search-chevron" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="2" width="16" height="16">
            <path d="M6 8l4 4 4-4" strokeLinecap="round" strokeLinejoin="round" />
          </svg>
        </button>

        {searchOpen ? (
          <div className="home-search-body">
            <SearchBar value={query} onChange={setQuery} language={language} onLanguageChange={setLanguage} />

            <section className="results-panel">
              {isLoading ? <SkeletonBookGrid count={8} /> : null}
              {!isLoading && error ? <p className="status-message error">{error}</p> : null}
              {!isLoading && hasQuery && !error && books.length === 0 ? (
                <p className="status-message">No books found for that search.</p>
              ) : null}
              {hasQuery ? <BookGrid books={books} /> : null}
            </section>

            {!hasQuery ? (
              <p className="muted-text" style={{ textAlign: "center", marginTop: "0.5rem" }}>
                Or try <Link to="/search">advanced search</Link> for more filters.
              </p>
            ) : null}
          </div>
        ) : null}
      </section>
    </div>
  );
}

export default HomePage;
