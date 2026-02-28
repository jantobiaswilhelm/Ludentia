import { Link } from "react-router-dom";
import { formatRelativeDate, truncate, bookCoverUrl } from "../../utils/formatters";

const SHELF_LABELS = {
  want_to_read: "Want to Read",
  reading: "Currently Reading",
  read: "Read",
};

function FeedItem({ event }) {
  const { event_type, event_data, book, profile, created_at } = event;

  const userName = profile?.display_name || profile?.username || "Someone";
  const bookTitle = book?.title || "a book";

  let content;
  if (event_type === "log") {
    const rating = event_data?.rating;
    const review = event_data?.review_text;
    const spoiler = event_data?.contains_spoilers;
    content = (
      <>
        <p className="feed-item-text">
          <strong>{rating}</strong>/10
          {event_data?.is_reread ? " (reread)" : ""}
        </p>
        {review && !spoiler ? (
          <p className="feed-item-excerpt">{truncate(review, 150)}</p>
        ) : null}
        {review && spoiler ? (
          <p className="feed-item-excerpt feed-spoiler">Contains spoilers</p>
        ) : null}
      </>
    );
  } else if (event_type === "diary") {
    const text = event_data?.entry_text;
    const isSpoiler = event_data?.is_spoiler;
    content = (
      <>
        {text && !isSpoiler ? (
          <p className="feed-item-excerpt">{truncate(text, 150)}</p>
        ) : null}
        {text && isSpoiler ? (
          <p className="feed-item-excerpt feed-spoiler">Contains spoilers</p>
        ) : null}
      </>
    );
  } else if (event_type === "shelf") {
    const shelf = event_data?.shelf;
    content = (
      <p className="feed-item-text">
        Added to <strong>{SHELF_LABELS[shelf] || shelf}</strong>
      </p>
    );
  }

  const actionVerb = event_type === "log"
    ? "rated"
    : event_type === "diary"
    ? "wrote about"
    : "shelved";

  return (
    <div className="feed-item">
      <Link to={`/profile/${profile?.id}`} className="feed-item-avatar">
        {profile?.avatar_url ? (
          <img src={profile.avatar_url} alt="" />
        ) : (
          <div className="avatar-placeholder avatar-sm">
            {userName[0].toUpperCase()}
          </div>
        )}
      </Link>
      <div className="feed-item-content">
        <div className="feed-item-header">
          <span>
            <Link to={`/profile/${profile?.id}`} className="feed-item-user">{userName}</Link>
            {" "}{actionVerb}{" "}
            <Link to={`/book/${book?.id}`} className="feed-item-book">{bookTitle}</Link>
          </span>
          <span className="feed-item-time">{formatRelativeDate(created_at)}</span>
        </div>
        <div className="feed-item-body">
          {(book?.cover_url || book?.google_books_id) ? (
            <Link to={`/book/${book.id}`}>
              <img src={bookCoverUrl(book)} alt="" className="feed-item-cover" referrerPolicy="no-referrer" />
            </Link>
          ) : null}
          <div className="feed-item-detail">{content}</div>
        </div>
      </div>
    </div>
  );
}

export default FeedItem;
