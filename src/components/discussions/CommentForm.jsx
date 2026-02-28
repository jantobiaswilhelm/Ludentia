import { useState } from "react";

function CommentForm({ onSubmit, compact, placeholder }) {
  const [text, setText] = useState("");
  const [spoiler, setSpoiler] = useState(false);
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!text.trim() || submitting) return;
    setSubmitting(true);
    try {
      await onSubmit({ commentText: text.trim(), containsSpoilers: spoiler });
      setText("");
      setSpoiler(false);
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className={`comment-form ${compact ? "comment-form-compact" : ""}`}>
      <textarea
        value={text}
        onChange={(e) => setText(e.target.value)}
        placeholder={placeholder || "Share your thoughts..."}
        className="diary-input"
        rows={compact ? 2 : 3}
        maxLength={2000}
      />
      <div className="comment-form-actions">
        <label className="log-checkbox">
          <input
            type="checkbox"
            checked={spoiler}
            onChange={(e) => setSpoiler(e.target.checked)}
          />
          Contains spoilers
        </label>
        <button
          type="submit"
          className="btn btn-primary btn-sm"
          disabled={!text.trim() || submitting}
        >
          {submitting ? "Posting..." : "Post"}
        </button>
      </div>
    </form>
  );
}

export default CommentForm;
