const FALLBACK_COVER = "https://via.placeholder.com/240x360/efe5d2/3a3122?text=No+Cover";

function BookCover({ title, coverUrl }) {
  return (
    <img
      src={coverUrl || FALLBACK_COVER}
      alt={`${title} cover`}
      loading="lazy"
      className="book-cover"
      referrerPolicy="no-referrer"
    />
  );
}

export default BookCover;
