import { Link } from "react-router-dom";
import BookCover from "./BookCover";

function BookCard({ book }) {
  const linkTo = book.id ? `/book/${book.id}` : "#";

  return (
    <Link to={linkTo} className="book-card">
      <BookCover title={book.title} coverUrl={book.coverUrlLarge || book.coverUrl || book.cover_url_large || book.cover_url} />
      <div className="book-body">
        <h3>{book.title}</h3>
        {(book.authors || []).length > 0 ? (
          <p>{book.authors.join(", ")}</p>
        ) : (
          <p>Unknown author</p>
        )}
        <div className="book-meta">
          {book.averageRating || book.google_average_rating ? (
            <span>{(book.averageRating || book.google_average_rating).toFixed(1)} / 5</span>
          ) : null}
          {book.pageCount || book.page_count ? (
            <span>{book.pageCount || book.page_count} pg</span>
          ) : null}
        </div>
      </div>
    </Link>
  );
}

export default BookCard;
