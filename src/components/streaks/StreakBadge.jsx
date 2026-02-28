function StreakBadge({ streak, compact }) {
  if (!streak) return null;

  const { current_streak, longest_streak, is_active_today } = streak;
  const active = current_streak > 0;

  if (compact) {
    return (
      <div className={`streak-badge streak-compact ${active ? "streak-active" : "streak-inactive"}`}>
        <span className="streak-flame" aria-hidden="true" />
        <span className="streak-count">{current_streak}</span>
        <span className="streak-label">day streak</span>
      </div>
    );
  }

  return (
    <div className={`streak-badge ${active ? "streak-active" : "streak-inactive"}`}>
      <div className="streak-main">
        <span className="streak-flame" aria-hidden="true" />
        <span className="streak-count">{current_streak}</span>
        <span className="streak-label">day streak</span>
      </div>
      <div className="streak-meta">
        <span>Longest: {longest_streak} days</span>
        <span>Total active: {streak.total_active_days} days</span>
      </div>
      {active && !is_active_today ? (
        <span className="streak-warning">Read today to keep your streak!</span>
      ) : null}
    </div>
  );
}

export default StreakBadge;
