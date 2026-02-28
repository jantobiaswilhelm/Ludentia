import { useEffect, useState } from "react";
import { getAllTags } from "../services/tags";
import { supabase } from "../config/supabaseClient";
import BookGrid from "../components/books/BookGrid";
import GuidedDiscovery from "../components/discovery/GuidedDiscovery";
import { SkeletonBookGrid } from "../components/ui/Skeleton";
import EmptyState from "../components/ui/EmptyState";
import { TAG_COLORS } from "../utils/constants";
import { useDocumentTitle } from "../hooks/useDocumentTitle";
import { backfillCover } from "../services/bookCache";

function BrowsePage() {
  const [mode, setMode] = useState("guided");
  const [tags, setTags] = useState([]);
  const [selectedTag, setSelectedTag] = useState(null);
  const [books, setBooks] = useState([]);
  const [loading, setLoading] = useState(false);
  const [tagsLoading, setTagsLoading] = useState(true);
  useDocumentTitle("Browse");

  useEffect(() => {
    getAllTags().then((t) => {
      setTags(t);
      setTagsLoading(false);
    });
  }, []);

  useEffect(() => {
    if (!selectedTag || !supabase) return;
    setLoading(true);
    supabase
      .from("tag_votes")
      .select("book_id, books(*)")
      .eq("tag_id", selectedTag.id)
      .then(async ({ data }) => {
        const seen = new Set();
        const rawBooks = [];
        for (const row of data || []) {
          if (row.books && !seen.has(row.book_id)) {
            seen.add(row.book_id);
            rawBooks.push(row.books);
          }
        }
        const filled = await Promise.all(rawBooks.map((b) => backfillCover(b)));
        setBooks(filled);
        setLoading(false);
      });
  }, [selectedTag]);

  // Group tags by category
  const categories = {};
  for (const tag of tags) {
    const cat = tag.category || "Other";
    if (!categories[cat]) categories[cat] = [];
    categories[cat].push(tag);
  }

  return (
    <div className="browse-page">
      <h1>Browse by Tag</h1>

      <div className="browse-mode-toggle">
        <button
          type="button"
          className={`browse-mode-btn ${mode === "guided" ? "active" : ""}`}
          onClick={() => setMode("guided")}
        >
          Guided
        </button>
        <button
          type="button"
          className={`browse-mode-btn ${mode === "quick" ? "active" : ""}`}
          onClick={() => setMode("quick")}
        >
          Quick Filter
        </button>
      </div>

      {mode === "guided" ? (
        <GuidedDiscovery />
      ) : (
        <>
          {tagsLoading ? (
            <SkeletonBookGrid count={4} />
          ) : (
            <div className="browse-tags">
              {Object.entries(categories).map(([category, catTags]) => (
                <div key={category} className="browse-tag-group">
                  <h3>{category}</h3>
                  <div className="tag-list">
                    {catTags.map((tag) => {
                      const colors = TAG_COLORS[tag.color] || TAG_COLORS.gray;
                      const active = selectedTag?.id === tag.id;
                      return (
                        <button
                          key={tag.id}
                          type="button"
                          className={`tag-badge ${active ? "tag-voted" : ""}`}
                          style={{
                            "--tag-bg": active ? colors.border : colors.bg,
                            "--tag-text": colors.text,
                            "--tag-border": colors.border,
                          }}
                          onClick={() => setSelectedTag(active ? null : tag)}
                        >
                          {tag.label}
                        </button>
                      );
                    })}
                  </div>
                </div>
              ))}
            </div>
          )}

          {selectedTag ? (
            <div className="browse-results">
              <h2>Books tagged "{selectedTag.label}"</h2>
              {loading ? (
                <SkeletonBookGrid count={6} />
              ) : books.length === 0 ? (
                <EmptyState title="No books yet" description="Be the first to tag a book with this!" />
              ) : (
                <BookGrid books={books} />
              )}
            </div>
          ) : null}
        </>
      )}
    </div>
  );
}

export default BrowsePage;
