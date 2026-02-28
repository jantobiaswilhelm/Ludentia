import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { getTagBySlug, getBooksForTag, getCoOccurringTags } from "../services/tags";
import BookGrid from "../components/books/BookGrid";
import { SkeletonBookGrid } from "../components/ui/Skeleton";
import EmptyState from "../components/ui/EmptyState";
import { TAG_COLORS } from "../utils/constants";

function TagPage() {
  const { slug } = useParams();
  const [tag, setTag] = useState(null);
  const [books, setBooks] = useState([]);
  const [coTags, setCoTags] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    getTagBySlug(slug).then(async (t) => {
      setTag(t);
      if (t) {
        const [b, co] = await Promise.all([
          getBooksForTag(t.id),
          getCoOccurringTags(t.id, 8),
        ]);
        setBooks(b);
        setCoTags(co);
      }
      setLoading(false);
    });
  }, [slug]);

  if (loading) {
    return (
      <div className="tag-page">
        <SkeletonBookGrid count={8} />
      </div>
    );
  }

  if (!tag) {
    return <EmptyState title="Tag not found" description="This tag doesn't exist." />;
  }

  const colors = TAG_COLORS[tag.color] || TAG_COLORS.gray;

  return (
    <div className="tag-page">
      <div className="tag-page-header">
        <span
          className="tag-badge tag-official"
          style={{
            "--tag-bg": colors.bg,
            "--tag-text": colors.text,
            "--tag-border": colors.border,
            cursor: "default",
            fontSize: "1rem",
            padding: "0.4rem 0.9rem",
          }}
        >
          {tag.label}
        </span>
        <h1>{tag.label}</h1>
      </div>

      {tag.description ? (
        <p className="tag-page-desc">{tag.description}</p>
      ) : null}

      <p className="muted-text">
        {books.length} book{books.length !== 1 ? "s" : ""} tagged
      </p>

      {coTags.length > 0 ? (
        <section>
          <h2>Often paired with</h2>
          <div className="tag-page-co-occurring">
            {coTags.map((ct) => {
              const ctColors = TAG_COLORS[ct.color] || TAG_COLORS.gray;
              return (
                <Link
                  key={ct.tag_id}
                  to={`/tag/${ct.slug}`}
                  className="tag-badge tag-official"
                  style={{
                    "--tag-bg": ctColors.bg,
                    "--tag-text": ctColors.text,
                    "--tag-border": ctColors.border,
                  }}
                >
                  {ct.label}
                </Link>
              );
            })}
          </div>
        </section>
      ) : null}

      <section>
        <h2>Books</h2>
        {books.length === 0 ? (
          <EmptyState title="No books yet" description="Be the first to tag a book!" />
        ) : (
          <BookGrid books={books} />
        )}
      </section>
    </div>
  );
}

export default TagPage;
