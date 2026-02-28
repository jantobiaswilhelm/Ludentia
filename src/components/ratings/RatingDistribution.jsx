function RatingDistribution({ stats }) {
  if (!stats) return null;

  const bars = [];
  let maxCount = 0;
  for (let i = 1; i <= 10; i++) {
    const count = stats[`r${i}`] || 0;
    if (count > maxCount) maxCount = count;
    bars.push({ rating: i, count });
  }

  if (maxCount === 0) return null;

  return (
    <div className="rating-distribution">
      {bars.map((bar) => (
        <div key={bar.rating} className="dist-row">
          <span className="dist-label">{bar.rating}</span>
          <div className="dist-bar-track">
            <div
              className="dist-bar-fill"
              style={{ width: `${(bar.count / maxCount) * 100}%` }}
            />
          </div>
          <span className="dist-count">{bar.count}</span>
        </div>
      ))}
    </div>
  );
}

export default RatingDistribution;
