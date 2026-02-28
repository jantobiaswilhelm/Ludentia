import { Link } from "react-router-dom";
import BookCover from "../books/BookCover";

function BookHighlight({ book, stat }) {
  if (!book) return null;

  const authors = Array.isArray(book.authors) ? book.authors.join(", ") : book.authors || "";

  return (
    <Link to={`/book/${book.book_id}`} className="book-highlight">
      <BookCover title={book.title} coverUrl={book.cover_url} />
      <div className="book-highlight-info">
        <span className="book-highlight-title">{book.title}</span>
        {authors ? <span className="book-highlight-author">{authors}</span> : null}
        {stat ? <span className="book-highlight-stat">{stat}</span> : null}
      </div>
    </Link>
  );
}

export default BookHighlight;
