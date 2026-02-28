import { Link } from "react-router-dom";
import BookCover from "./BookCover";

function RecommendationCard({ book, reason }) {
  const matchedTags = reason?.matched_tags || [];
  const authorMatch = reason?.author_match || [];
  const highRating = reason?.high_community_rating || false;

  return (
    <div className="rec-card">
      <Link to={`/book/${book.id}`} className="book-card">
        <BookCover title={book.title} coverUrl={book.cover_url_large || book.cover_url} />
        <div className="book-body">
          <h3>{book.title}</h3>
          <p>{(book.authors || []).join(", ")}</p>
        </div>
      </Link>
      <div className="rec-chips">
        {authorMatch.slice(0, 1).map((author) => (
          <span key={author} className="rec-chip rec-chip-author">By {author}</span>
        ))}
        {matchedTags.slice(0, 3).map((tag) => (
          <span key={tag.id} className="rec-chip">{tag.label}</span>
        ))}
        {highRating ? (
          <span className="rec-chip rec-chip-rating">Highly rated</span>
        ) : null}
      </div>
    </div>
  );
}

export default RecommendationCard;
