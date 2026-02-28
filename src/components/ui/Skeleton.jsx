function Skeleton({ width, height, style, className = "" }) {
  return (
    <div
      className={`skeleton ${className}`}
      style={{ width, height, ...style }}
    />
  );
}

function SkeletonBookCard() {
  return (
    <div className="skeleton-book-card">
      <div className="skeleton-cover" />
      <div className="skeleton-text" style={{ width: "80%" }} />
      <div className="skeleton-text skeleton-text-short" />
    </div>
  );
}

function SkeletonBookGrid({ count = 8 }) {
  return (
    <div className="book-grid">
      {Array.from({ length: count }, (_, i) => (
        <SkeletonBookCard key={i} />
      ))}
    </div>
  );
}

function SkeletonText({ lines = 3, width }) {
  return (
    <div style={{ display: "grid", gap: "0.5rem" }}>
      {Array.from({ length: lines }, (_, i) => (
        <Skeleton
          key={i}
          height="0.9rem"
          width={i === lines - 1 ? "60%" : width || "100%"}
        />
      ))}
    </div>
  );
}

export { Skeleton, SkeletonBookCard, SkeletonBookGrid, SkeletonText };
export default Skeleton;
