import { useState } from "react";

function ProgressTracker({ progress, totalPages, onUpdate }) {
  const [page, setPage] = useState(progress?.current_page || 0);
  const total = progress?.total_pages || totalPages || 0;

  const percentage = total > 0 ? Math.min(100, Math.round((page / total) * 100)) : 0;

  const handleSave = () => {
    onUpdate({
      current_page: page,
      total_pages: total,
      percentage: total > 0 ? Math.min(100, Math.round((page / total) * 100)) : 0,
    });
  };

  return (
    <div className="progress-tracker">
      <div className="progress-bar-container">
        <div className="progress-bar-fill" style={{ width: `${percentage}%` }} />
      </div>
      <div className="progress-controls">
        <label>
          Page
          <input
            type="number"
            min={0}
            max={total || 99999}
            value={page}
            onChange={(e) => setPage(Math.max(0, parseInt(e.target.value) || 0))}
            className="progress-input"
          />
          {total > 0 ? <span>of {total}</span> : null}
        </label>
        <span className="progress-pct">{percentage}%</span>
        <button type="button" className="btn btn-primary btn-sm" onClick={handleSave}>
          Update
        </button>
      </div>
    </div>
  );
}

export default ProgressTracker;
