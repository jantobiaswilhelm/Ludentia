function GoalProgress({ goalData, compact }) {
  if (!goalData?.goal) return null;

  const { target_books } = goalData.goal;
  const booksRead = goalData.books_read || 0;
  const pct = Math.min(Math.round((booksRead / target_books) * 100), 100);
  const remaining = Math.max(target_books - booksRead, 0);
  const complete = booksRead >= target_books;

  if (compact) {
    return (
      <div className="goal-compact">
        <span className="goal-compact-label">{booksRead}/{target_books} books</span>
        <div className="progress-bar-track">
          <div
            className={`progress-bar-fill ${complete ? "progress-bar-complete" : ""}`}
            style={{ width: `${pct}%` }}
          />
        </div>
      </div>
    );
  }

  const angle = (pct / 100) * 360;

  return (
    <div className={`goal-progress ${complete ? "goal-ring-complete" : ""}`}>
      <div
        className="goal-ring"
        style={{ "--angle": `${angle}deg` }}
      >
        <div className="goal-ring-inner">
          <span className="goal-ring-count">{booksRead}</span>
          <span className="goal-ring-divider">of {target_books}</span>
        </div>
      </div>
      <div className="goal-info">
        <span className="goal-pct">{pct}% complete</span>
        {complete ? (
          <span className="goal-message goal-done">Goal reached!</span>
        ) : (
          <span className="goal-message">{remaining} more to go</span>
        )}
        {goalData.books_this_month > 0 ? (
          <span className="goal-month">{goalData.books_this_month} this month</span>
        ) : null}
      </div>
    </div>
  );
}

export default GoalProgress;
