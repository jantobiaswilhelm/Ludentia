import { Link } from "react-router-dom";
import BookCover from "../books/BookCover";

function ShelfList({ items, emptyMessage = "No books yet." }) {
  if (!items.length) {
    return <p className="shelf-empty">{emptyMessage}</p>;
  }

  return (
    <div className="shelf-list">
      {items.map((item) => {
        const book = item.books;
        if (!book) return null;
        return (
          <Link to={`/book/${book.id}`} key={item.id} className="shelf-item">
            <BookCover title={book.title} coverUrl={book.cover_url_large || book.cover_url} />
            <div className="shelf-item-info">
              <h4>{book.title}</h4>
              <p>{(book.authors || []).join(", ")}</p>
            </div>
          </Link>
        );
      })}
    </div>
  );
}

export default ShelfList;
