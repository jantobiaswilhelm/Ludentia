import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import BookGrid from "../components/books/BookGrid";
import SearchBar from "../components/search/SearchBar";
import useBookSearch from "../hooks/useBookSearch";
import { useAuth } from "../context/AuthContext";
import { getRecommendations, getTrendingBooks } from "../services/recommendations";
import { getOfficialTags } from "../services/tags";
import { TAG_COLORS } from "../utils/constants";
import Spinner from "../components/ui/Spinner";

function HomePage() {
  const [query, setQuery] = useState("");
  const [language, setLanguage] = useState("");
  const { books, isLoading, error, hasQuery } = useBookSearch(query, language);
  const { user } = useAuth();
  const [recs, setRecs] = useState([]);
  const [trending, setTrending] = useState([]);
  const [popularTags, setPopularTags] = useState([]);

  useEffect(() => {
    getOfficialTags().then((tags) => setPopularTags(tags.slice(0, 12)));
    if (user) {
      getRecommendations(user.id, 8).then((data) =>
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
            }))
        )
      );
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
      <section className="hero-panel">
        <p className="eyebrow">Your reading companion</p>
        <h1>Discover books by feel, not just by title.</h1>
        <p>
          Search for books, track your reading, and tag books with how they actually feel.
          Community tags power smarter discovery.
        </p>
      </section>

      <SearchBar value={query} onChange={setQuery} language={language} onLanguageChange={setLanguage} />

      {/* Popular tag pills */}
      {!hasQuery && popularTags.length > 0 ? (
        <div className="home-tags">
          <p className="home-tags-label">Popular tags</p>
          <div className="tag-list">
            {popularTags.map((tag) => {
              const colors = TAG_COLORS[tag.color] || TAG_COLORS.gray;
              return (
                <Link
                  key={tag.id}
                  to="/browse"
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

      <section className="results-panel">
        {isLoading ? (
          <div className="page-center"><Spinner size={32} /></div>
        ) : null}
        {!isLoading && error ? <p className="status-message error">{error}</p> : null}
        {!isLoading && hasQuery && !error && books.length === 0 ? (
          <p className="status-message">No books found for that search.</p>
        ) : null}

        {hasQuery ? <BookGrid books={books} /> : null}
      </section>

      {/* Recommendations or Trending */}
      {!hasQuery ? (
        <>
          {user && recs.length > 0 ? (
            <section className="home-section">
              <h2>Recommended for You</h2>
              <BookGrid books={recs} />
              <Link to="/recommendations" className="btn btn-ghost btn-sm home-see-all">
                See all recommendations
              </Link>
            </section>
          ) : null}

          {!user && trending.length > 0 ? (
            <section className="home-section">
              <h2>Trending</h2>
              <BookGrid books={trending} />
            </section>
          ) : null}
        </>
      ) : null}
    </div>
  );
}

export default HomePage;
