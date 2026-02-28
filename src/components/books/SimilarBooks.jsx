import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { getSimilarBooks } from "../../services/recommendations";
import BookCover from "./BookCover";
import { SkeletonBookGrid } from "../ui/Skeleton";

function SimilarBooks({ bookId }) {
  const [books, setBooks] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!bookId) return;
    setLoading(true);
    getSimilarBooks(bookId, 8)
      .then(setBooks)
      .finally(() => setLoading(false));
  }, [bookId]);

  if (loading) {
    return (
      <section className="book-section similar-books-section">
        <h2>Books Like This</h2>
        <SkeletonBookGrid count={4} />
      </section>
    );
  }

  if (books.length === 0) return null;

  return (
    <section className="book-section similar-books-section">
      <h2>Books Like This</h2>
      <div className="similar-books-scroll">
        {books.map((book) => (
          <Link key={book.id} to={`/book/${book.id}`} className="similar-book-item">
            <BookCover title={book.title} coverUrl={book.cover_url_large || book.cover_url} />
            <div className="similar-book-title">{book.title}</div>
            {book.sharedTags.length > 0 ? (
              <div className="similar-book-chips">
                {book.sharedTags.slice(0, 3).map((tag) => (
                  <span key={tag.id} className="similar-book-chip">{tag.label}</span>
                ))}
              </div>
            ) : null}
          </Link>
        ))}
      </div>
    </section>
  );
}

export default SimilarBooks;
