import BookCard from "./BookCard";

function BookGrid({ books }) {
  if (!books.length) {
    return null;
  }

  return (
    <section className="book-grid" aria-label="Search results">
      {books.map((book) => (
        <BookCard key={book.id} book={book} />
      ))}
    </section>
  );
}

export default BookGrid;
