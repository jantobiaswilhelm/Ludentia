function RatingDisplay({ avgRating, ratingCount }) {
  if (!avgRating && !ratingCount) return null;

  return (
    <div className="rating-display">
      <span className="rating-big">{avgRating ? Number(avgRating).toFixed(1) : "—"}</span>
      <span className="rating-max">/10</span>
      {ratingCount ? (
        <span className="rating-count">
          {ratingCount.toLocaleString()} {ratingCount === 1 ? "rating" : "ratings"}
        </span>
      ) : null}
    </div>
  );
}

export default RatingDisplay;
