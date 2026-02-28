import { useState } from "react";
import { createList } from "../../services/lists";

function CreateListModal({ open, onClose, onCreated }) {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [visibility, setVisibility] = useState("public");
  const [isRanked, setIsRanked] = useState(false);
  const [saving, setSaving] = useState(false);

  if (!open) return null;

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!title.trim()) return;
    setSaving(true);
    try {
      const list = await createList({
        title: title.trim(),
        description: description.trim() || null,
        visibility,
        is_ranked: isRanked,
      });
      setTitle("");
      setDescription("");
      setVisibility("public");
      setIsRanked(false);
      onCreated?.(list);
      onClose();
    } catch {
      // ignore
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h2 className="modal-title">Create List</h2>
          <button type="button" className="modal-close" onClick={onClose}>&times;</button>
        </div>
        <form onSubmit={handleSubmit} className="modal-body">
          <label className="auth-label">
            Title
            <input
              type="text"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              className="auth-input"
              required
              placeholder="My favorite sci-fi books..."
            />
          </label>
          <label className="auth-label">
            Description
            <textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              className="auth-input"
              rows={3}
              placeholder="What's this list about?"
            />
          </label>
          <label className="auth-label">
            Visibility
            <select
              value={visibility}
              onChange={(e) => setVisibility(e.target.value)}
              className="log-select"
            >
              <option value="public">Public</option>
              <option value="friends_only">Friends Only</option>
              <option value="private">Private</option>
            </select>
          </label>
          <label className="log-checkbox">
            <input
              type="checkbox"
              checked={isRanked}
              onChange={(e) => setIsRanked(e.target.checked)}
            />
            Ranked list (numbered)
          </label>
          <button type="submit" className="btn btn-primary" disabled={saving || !title.trim()}>
            {saving ? "Creating..." : "Create List"}
          </button>
        </form>
      </div>
    </div>

  );
}

export default CreateListModal;
