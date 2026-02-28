function BookCover({ title, coverUrl }) {
  if (!coverUrl) {
    return (
      <div className="book-cover book-cover-placeholder" role="img" aria-label={`${title} cover`}>
        <span>{title}</span>
      </div>
    );
  }

  return (
    <img
      src={coverUrl}
      alt={`${title} cover`}
      loading="lazy"
      className="book-cover"
      referrerPolicy="no-referrer"
    />
  );
}

export default BookCover;
