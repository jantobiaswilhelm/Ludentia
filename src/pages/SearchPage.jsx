import { useCallback, useEffect, useState } from "react";
import { useAdvancedSearch } from "../hooks/useAdvancedSearch";
import { getAvailableCategories } from "../services/search";
import BookGrid from "../components/books/BookGrid";
import EmptyState from "../components/ui/EmptyState";
import Spinner from "../components/ui/Spinner";
import { useDocumentTitle } from "../hooks/useDocumentTitle";

const SORT_OPTIONS = [
  { value: "relevance", label: "Relevance" },
  { value: "rating", label: "Highest Rated" },
  { value: "pages", label: "Most Pages" },
  { value: "newest", label: "Newest" },
];

const LANGUAGES = [
  { code: "", label: "Any" },
  { code: "en", label: "English" },
  { code: "de", label: "Deutsch" },
  { code: "fr", label: "Français" },
  { code: "es", label: "Español" },
  { code: "it", label: "Italiano" },
  { code: "pt", label: "Português" },
  { code: "nl", label: "Nederlands" },
  { code: "ja", label: "日本語" },
  { code: "zh", label: "中文" },
  { code: "ko", label: "한국어" },
];

function SearchPage() {
  const [query, setQuery] = useState("");
  const [author, setAuthor] = useState("");
  const [category, setCategory] = useState("");
  const [language, setLanguage] = useState("");
  const [minPages, setMinPages] = useState("");
  const [maxPages, setMaxPages] = useState("");
  const [sortBy, setSortBy] = useState("relevance");
  const [categories, setCategories] = useState([]);
  const [filtersOpen, setFiltersOpen] = useState(false);

  const filters = {
    query,
    author,
    category,
    language,
    minPages: minPages ? parseInt(minPages) : null,
    maxPages: maxPages ? parseInt(maxPages) : null,
    sortBy,
  };

  const { results, loading, error, totalCached, searchExternal } = useAdvancedSearch(filters);
  useDocumentTitle("Search");

  useEffect(() => {
    getAvailableCategories().then(setCategories).catch(() => {});
  }, []);

  const handleCategoryToggle = useCallback((cat) => {
    setCategory((prev) => (prev === cat ? "" : cat));
  }, []);

  const hasFilters = query || author || category;

  return (
    <div className="search-page">
      <h1>Advanced Search</h1>

      <div className="search-page-layout">
        <aside className={`search-filters ${filtersOpen ? "filters-open" : ""}`}>
          <button
            type="button"
            className="btn btn-ghost btn-sm filters-toggle"
            onClick={() => setFiltersOpen(!filtersOpen)}
          >
            {filtersOpen ? "Hide Filters" : "Show Filters"}
          </button>

          <div className="filters-body">
            <div className="filter-group">
              <label className="filter-label">Search</label>
              <input
                type="text"
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder="Title or keyword..."
                className="auth-input"
              />
            </div>

            <div className="filter-group">
              <label className="filter-label">Author</label>
              <input
                type="text"
                value={author}
                onChange={(e) => setAuthor(e.target.value)}
                placeholder="Author name..."
                className="auth-input"
              />
            </div>

            <div className="filter-group">
              <label className="filter-label">Language</label>
              <select
                value={language}
                onChange={(e) => setLanguage(e.target.value)}
                className="log-select"
              >
                {LANGUAGES.map((l) => (
                  <option key={l.code} value={l.code}>{l.label}</option>
                ))}
              </select>
            </div>

            <div className="filter-group">
              <label className="filter-label">Page Count</label>
              <div className="filter-range">
                <input
                  type="number"
                  value={minPages}
                  onChange={(e) => setMinPages(e.target.value)}
                  placeholder="Min"
                  className="auth-input"
                  min="0"
                />
                <span>to</span>
                <input
                  type="number"
                  value={maxPages}
                  onChange={(e) => setMaxPages(e.target.value)}
                  placeholder="Max"
                  className="auth-input"
                  min="0"
                />
              </div>
            </div>

            <div className="filter-group">
              <label className="filter-label">Sort By</label>
              <select
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value)}
                className="log-select"
              >
                {SORT_OPTIONS.map((o) => (
                  <option key={o.value} value={o.value}>{o.label}</option>
                ))}
              </select>
            </div>

            {categories.length > 0 ? (
              <div className="filter-group">
                <label className="filter-label">Genre</label>
                <div className="filter-chips">
                  {categories.map((cat) => (
                    <button
                      key={cat}
                      type="button"
                      className={`filter-chip ${category === cat ? "filter-chip-active" : ""}`}
                      onClick={() => handleCategoryToggle(cat)}
                    >
                      {cat}
                    </button>
                  ))}
                </div>
              </div>
            ) : null}
          </div>
        </aside>

        <div className="search-results-area">
          {loading ? (
            <div className="page-center"><Spinner size={32} /></div>
          ) : !hasFilters ? (
            <EmptyState
              title="Start searching"
              description="Enter a query, author, or select a genre to find books."
            />
          ) : results.length === 0 ? (
            <EmptyState
              title="No results"
              description="Try different search terms or filters."
            >
              <button type="button" className="btn btn-primary" onClick={searchExternal}>
                Search external sources
              </button>
            </EmptyState>
          ) : (
            <>
              <div className="search-results-header">
                <span className="muted-text">{totalCached} results from library</span>
                {totalCached < 10 ? (
                  <button type="button" className="btn btn-ghost btn-sm" onClick={searchExternal}>
                    Search external sources
                  </button>
                ) : null}
              </div>
              <BookGrid books={results} />
            </>
          )}
          {error ? <p className="error-text">{error}</p> : null}
        </div>
      </div>
    </div>
  );
}

export default SearchPage;
