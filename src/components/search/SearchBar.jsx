import { Link } from "react-router-dom";

const LANGUAGES = [
  { code: "", label: "All Languages" },
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

function SearchBar({ value, onChange, language, onLanguageChange }) {
  return (
    <div className="search-shell">
      <div className="search-row">
        <div className="search-field">
          <label htmlFor="book-query" className="search-label">
            Search by title, author, or keyword
          </label>
          <input
            id="book-query"
            type="text"
            value={value}
            onChange={(event) => onChange(event.target.value)}
            placeholder="Try: Harry Potter, Brandon Sanderson, climate fiction"
            className="search-input"
          />
        </div>
        <div className="search-lang">
          <label htmlFor="lang-select" className="search-label">Language</label>
          <select
            id="lang-select"
            value={language}
            onChange={(e) => onLanguageChange(e.target.value)}
            className="search-select"
          >
            {LANGUAGES.map((l) => (
              <option key={l.code} value={l.code}>{l.label}</option>
            ))}
          </select>
        </div>
      </div>
      <div className="search-help-row">
        <p className="search-help">Type at least 2 characters.</p>
        <Link to="/search" className="search-advanced-link">Advanced Search</Link>
      </div>
    </div>
  );
}

export default SearchBar;
