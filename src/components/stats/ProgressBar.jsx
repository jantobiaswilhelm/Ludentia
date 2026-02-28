function ProgressBar({ value, max, label, showPct }) {
  const pct = max > 0 ? Math.min(Math.round((value / max) * 100), 100) : 0;

  return (
    <div className="progress-bar-wrap">
      {label ? <span className="progress-bar-label">{label}</span> : null}
      <div className="progress-bar-track">
        <div
          className={`progress-bar-fill ${pct >= 100 ? "progress-bar-complete" : ""}`}
          style={{ width: `${pct}%` }}
        />
      </div>
      {showPct ? <span className="progress-bar-pct">{pct}%</span> : null}
    </div>
  );
}

export default ProgressBar;
