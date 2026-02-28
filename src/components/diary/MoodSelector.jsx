import { MOOD_TAGS } from "../../utils/constants";

function MoodSelector({ selected = [], onChange }) {
  const toggle = (value) => {
    if (selected.includes(value)) {
      onChange(selected.filter((v) => v !== value));
    } else {
      onChange([...selected, value]);
    }
  };

  return (
    <div className="mood-selector">
      <p className="mood-label">How's it going?</p>
      <div className="mood-grid">
        {MOOD_TAGS.map((mood) => (
          <button
            key={mood.value}
            type="button"
            className={`mood-btn ${selected.includes(mood.value) ? "mood-active" : ""}`}
            onClick={() => toggle(mood.value)}
          >
            <span className="mood-emoji">{mood.emoji}</span>
            <span>{mood.label}</span>
          </button>
        ))}
      </div>
    </div>
  );
}

export default MoodSelector;
