import { useState } from "react";

function RatingInput({ value, onChange, max = 10 }) {
  const [hover, setHover] = useState(0);

  return (
    <div className="rating-input">
      <div className="rating-slider-row">
        {Array.from({ length: max }, (_, i) => i + 1).map((n) => (
          <button
            key={n}
            type="button"
            className={`rating-pip ${n <= (hover || value) ? "active" : ""} ${n === value ? "selected" : ""}`}
            onMouseEnter={() => setHover(n)}
            onMouseLeave={() => setHover(0)}
            onClick={() => onChange(n === value ? 0 : n)}
            aria-label={`Rate ${n} out of ${max}`}
          >
            {n}
          </button>
        ))}
      </div>
      {value ? (
        <span className="rating-label">{value}/{max}</span>
      ) : (
        <span className="rating-label muted">Select a rating</span>
      )}
    </div>
  );
}

export default RatingInput;
