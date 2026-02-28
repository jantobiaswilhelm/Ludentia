import { useState } from "react";
import Modal from "../ui/Modal";
import LogAllInOne from "./LogAllInOne";
import LogStepByStep from "./LogStepByStep";
import { useAuth } from "../../context/AuthContext";

function LogBookModal({ open, onClose, book, onComplete }) {
  const { profile } = useAuth();
  const [mode, setMode] = useState(profile?.preferred_log_mode || "all_in_one");

  if (!book) return null;

  const handleComplete = (logData) => {
    if (onComplete) onComplete(logData);
    onClose();
  };

  return (
    <Modal open={open} onClose={onClose} title={`Log: ${book.title}`} wide>
      <div className="log-mode-toggle">
        <button
          type="button"
          className={`btn btn-sm ${mode === "all_in_one" ? "btn-primary" : "btn-ghost"}`}
          onClick={() => setMode("all_in_one")}
        >
          All-in-One
        </button>
        <button
          type="button"
          className={`btn btn-sm ${mode === "step_by_step" ? "btn-primary" : "btn-ghost"}`}
          onClick={() => setMode("step_by_step")}
        >
          Step-by-Step
        </button>
      </div>

      {mode === "all_in_one" ? (
        <LogAllInOne book={book} onSubmit={handleComplete} />
      ) : (
        <LogStepByStep book={book} onSubmit={handleComplete} />
      )}
    </Modal>
  );
}

export default LogBookModal;
