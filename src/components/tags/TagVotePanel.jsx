import { useState } from "react";
import TagSection from "./TagSection";
import { searchTags, createTag } from "../../services/tags";
import { useAuth } from "../../context/AuthContext";

function TagVotePanel({ bookId, tagCounts, officialTags, userVotes, onToggleVote, onRefresh }) {
  const { user } = useAuth();
  const [search, setSearch] = useState("");
  const [results, setResults] = useState([]);
  const [searching, setSearching] = useState(false);

  const handleSearch = async (q) => {
    setSearch(q);
    if (q.length < 2) {
      setResults([]);
      return;
    }
    setSearching(true);
    try {
      setResults(await searchTags(q));
    } finally {
      setSearching(false);
    }
  };

  const handleCreate = async () => {
    if (!user || search.length < 2) return;
    await createTag({ label: search, createdBy: user.id });
    setSearch("");
    setResults([]);
    if (onRefresh) onRefresh();
  };

  return (
    <div className="tag-vote-panel">
      <TagSection
        tagCounts={tagCounts}
        officialTags={officialTags}
        userVotes={userVotes}
        onToggleVote={onToggleVote}
      />

      {user ? (
        <div className="tag-search-add">
          <input
            type="text"
            value={search}
            onChange={(e) => handleSearch(e.target.value)}
            placeholder="Search or add a tag..."
            className="tag-search-input"
          />
          {results.length > 0 ? (
            <div className="tag-search-results">
              {results.map((tag) => (
                <button
                  key={tag.id}
                  type="button"
                  className="tag-search-result"
                  onClick={() => {
                    onToggleVote(tag.id);
                    setSearch("");
                    setResults([]);
                  }}
                >
                  {tag.label}
                  {tag.category ? <span className="tag-result-cat">{tag.category}</span> : null}
                </button>
              ))}
            </div>
          ) : null}
          {search.length >= 2 && results.length === 0 && !searching ? (
            <button type="button" className="btn btn-ghost btn-sm" onClick={handleCreate}>
              + Create tag "{search}"
            </button>
          ) : null}
        </div>
      ) : null}
    </div>
  );
}

export default TagVotePanel;
