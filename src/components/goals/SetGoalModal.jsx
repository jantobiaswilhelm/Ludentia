import { useState } from "react";
import Modal from "../ui/Modal";

const PRESETS = [12, 24, 36, 52];

function SetGoalModal({ open, onClose, currentTarget, onSetGoal, onRemoveGoal }) {
  const [custom, setCustom] = useState(currentTarget || "");

  const handlePreset = (val) => {
    onSetGoal(val);
    onClose();
  };

  const handleCustom = (e) => {
    e.preventDefault();
    const val = parseInt(custom);
    if (val >= 1 && val <= 500) {
      onSetGoal(val);
      onClose();
    }
  };

  const handleRemove = () => {
    onRemoveGoal();
    onClose();
  };

  return (
    <Modal open={open} onClose={onClose} title="Set Reading Goal">
      <div className="set-goal-form">
        <p className="muted-text">How many books do you want to read this year?</p>

        <div className="goal-presets">
          {PRESETS.map((n) => (
            <button
              key={n}
              type="button"
              className={`btn ${currentTarget === n ? "btn-primary" : "btn-ghost"}`}
              onClick={() => handlePreset(n)}
            >
              {n} books
            </button>
          ))}
        </div>

        <form onSubmit={handleCustom} className="goal-custom-row">
          <input
            type="number"
            min="1"
            max="500"
            value={custom}
            onChange={(e) => setCustom(e.target.value)}
            placeholder="Custom target"
            className="auth-input"
          />
          <button type="submit" className="btn btn-primary" disabled={!custom || parseInt(custom) < 1}>
            Set
          </button>
        </form>

        {currentTarget ? (
          <button type="button" className="btn btn-ghost btn-sm" onClick={handleRemove}>
            Remove goal
          </button>
        ) : null}
      </div>
    </Modal>
  );
}

export default SetGoalModal;
