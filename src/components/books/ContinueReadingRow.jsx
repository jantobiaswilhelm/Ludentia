import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";
import { getCurrentlyReading } from "../../services/bookshelves";
import BookCover from "./BookCover";

function ContinueReadingRow() {
  const { user } = useAuth();
  const [books, setBooks] = useState([]);

  useEffect(() => {
    if (!user) return;
    getCurrentlyReading(user.id).then(setBooks);
  }, [user]);

  if (books.length === 0) return null;

  return (
    <section className="home-section">
      <h2>Continue Reading</h2>
      <div className="continue-reading-scroll">
        {books.map((entry) => {
          const book = entry.books;
          if (!book) return null;
          return (
            <Link
              key={entry.id || book.id}
              to={`/book/${book.id}`}
              className="continue-reading-item"
            >
              <BookCover title={book.title} coverUrl={book.cover_url_large || book.cover_url} />
              <div className="continue-reading-title">{book.title}</div>
            </Link>
          );
        })}
      </div>
    </section>
  );
}

export default ContinueReadingRow;
