import { useCallback, useEffect, useState } from "react";
import { useToast } from "../../context/ToastContext";
import { getAdminTags, deleteTag } from "../../services/admin";
import Spinner from "../ui/Spinner";

function TagModeration() {
  const { addToast } = useToast();
  const [tags, setTags] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState("all");

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const data = await getAdminTags();
      setTags(data);
    } catch {
      setTags([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { load(); }, [load]);

  const handleDelete = async (tagId, label) => {
    if (!window.confirm(`Delete tag "${label}"? This removes all user votes for it.`)) return;
    try {
      await deleteTag(tagId);
      addToast({ message: `Tag "${label}" deleted`, type: "success" });
      load();
    } catch (err) {
      addToast({ message: err.message || "Failed to delete tag", type: "error" });
    }
  };

  const filtered = filter === "all" ? tags
    : filter === "official" ? tags.filter((t) => t.is_official)
    : tags.filter((t) => !t.is_official);

  return (
    <div className="admin-section">
      <div className="admin-toolbar">
        <select value={filter} onChange={(e) => setFilter(e.target.value)} className="log-select">
          <option value="all">All Tags ({tags.length})</option>
          <option value="official">Official ({tags.filter((t) => t.is_official).length})</option>
          <option value="user">User-Created ({tags.filter((t) => !t.is_official).length})</option>
        </select>
      </div>

      {loading ? <Spinner size={24} /> : filtered.length === 0 ? (
        <p className="muted-text">No tags found</p>
      ) : (
        <div className="admin-list">
          {filtered.map((tag) => (
            <div key={tag.id} className="admin-card admin-card-inline">
              <div className="admin-card-header">
                <span className="admin-tag-label">{tag.label}</span>
                <span className="admin-card-meta">
                  {tag.category} &middot; {tag.total_votes} votes &middot; {tag.is_official ? "Official" : "User"}
                </span>
              </div>
              {!tag.is_official ? (
                <button
                  type="button"
                  className="btn btn-ghost btn-sm"
                  onClick={() => handleDelete(tag.id, tag.label)}
                >
                  Delete
                </button>
              ) : null}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default TagModeration;
