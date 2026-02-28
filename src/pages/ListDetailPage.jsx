import { useState } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { useList } from "../hooks/useLists";
import { deleteList, updateList } from "../services/lists";
import EmptyState from "../components/ui/EmptyState";
import Spinner from "../components/ui/Spinner";
import { useDocumentTitle } from "../hooks/useDocumentTitle";
import { bookCoverUrl } from "../utils/formatters";

function ListDetailPage() {
  const { listId } = useParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const { list, items, loading, removeBook, reorder, refresh } = useList(listId);
  useDocumentTitle(list?.title || "List");
  const [editing, setEditing] = useState(false);
  const [editTitle, setEditTitle] = useState("");
  const [editDesc, setEditDesc] = useState("");

  if (loading) {
    return <div className="page-center"><Spinner size={40} /></div>;
  }

  if (!list) {
    return <EmptyState title="List not found" />;
  }

  const isOwner = user?.id === list.user_id;

  const handleDelete = async () => {
    if (!confirm("Delete this list?")) return;
    await deleteList(listId);
    navigate(`/profile/${list.user_id}/lists`);
  };

  const handleSaveEdit = async () => {
    await updateList(listId, {
      title: editTitle.trim() || list.title,
      description: editDesc.trim() || null,
    });
    setEditing(false);
    refresh();
  };

  const handleMoveUp = (index) => {
    if (index <= 0) return;
    const newItems = [...items];
    [newItems[index - 1], newItems[index]] = [newItems[index], newItems[index - 1]];
    reorder(newItems.map((i) => i.id));
  };

  const handleMoveDown = (index) => {
    if (index >= items.length - 1) return;
    const newItems = [...items];
    [newItems[index], newItems[index + 1]] = [newItems[index + 1], newItems[index]];
    reorder(newItems.map((i) => i.id));
  };

  return (
    <div className="list-detail-page">
      <div className="list-detail-header">
        <Link to={`/profile/${list.user_id}/lists`} className="back-link">&larr; Lists</Link>

        {editing ? (
          <div className="list-edit-form">
            <input
              type="text"
              value={editTitle}
              onChange={(e) => setEditTitle(e.target.value)}
              className="auth-input"
              placeholder="List title"
            />
            <textarea
              value={editDesc}
              onChange={(e) => setEditDesc(e.target.value)}
              className="auth-input"
              rows={2}
              placeholder="Description"
            />
            <div className="list-edit-actions">
              <button type="button" className="btn btn-primary btn-sm" onClick={handleSaveEdit}>Save</button>
              <button type="button" className="btn btn-ghost btn-sm" onClick={() => setEditing(false)}>Cancel</button>
            </div>
          </div>
        ) : (
          <>
            <h1>{list.title}</h1>
            {list.description ? <p className="list-detail-desc">{list.description}</p> : null}
            <div className="list-detail-meta">
              <span>{items.length} books</span>
              {list.is_ranked ? <span className="list-badge">Ranked</span> : null}
              {list.visibility !== "public" ? (
                <span className="list-badge list-badge-vis">{list.visibility === "private" ? "Private" : "Friends"}</span>
              ) : null}
            </div>
          </>
        )}

        {isOwner && !editing ? (
          <div className="list-detail-actions">
            <button
              type="button"
              className="btn btn-ghost btn-sm"
              onClick={() => {
                setEditTitle(list.title);
                setEditDesc(list.description || "");
                setEditing(true);
              }}
            >
              Edit
            </button>
            <button type="button" className="btn btn-ghost btn-sm" onClick={handleDelete}>
              Delete
            </button>
          </div>
        ) : null}
      </div>

      {items.length === 0 ? (
        <EmptyState
          title="Empty list"
          description={isOwner ? "Add books from any book's detail page." : "No books in this list yet."}
        />
      ) : (
        <div className="list-items">
          {items.map((item, index) => (
            <div key={item.id} className="list-item">
              {list.is_ranked ? <span className="list-item-rank">#{index + 1}</span> : null}
              {(item.books?.cover_url || item.books?.google_books_id) ? (
                <Link to={`/book/${item.book_id}`}>
                  <img src={bookCoverUrl(item.books)} alt="" className="list-item-cover" referrerPolicy="no-referrer" />
                </Link>
              ) : (
                <div className="list-item-cover-placeholder" />
              )}
              <div className="list-item-info">
                <Link to={`/book/${item.book_id}`} className="list-item-title">
                  {item.books?.title || "Unknown book"}
                </Link>
                <p className="list-item-author">{(item.books?.authors || []).join(", ")}</p>
                {item.note ? <p className="list-item-note">{item.note}</p> : null}
              </div>
              {isOwner ? (
                <div className="list-item-actions">
                  <button
                    type="button"
                    className="btn btn-ghost btn-sm list-reorder-btn"
                    onClick={() => handleMoveUp(index)}
                    disabled={index === 0}
                    aria-label="Move up"
                  >
                    &uarr;
                  </button>
                  <button
                    type="button"
                    className="btn btn-ghost btn-sm list-reorder-btn"
                    onClick={() => handleMoveDown(index)}
                    disabled={index === items.length - 1}
                    aria-label="Move down"
                  >
                    &darr;
                  </button>
                  <button
                    type="button"
                    className="btn btn-ghost btn-sm"
                    onClick={() => removeBook(item.book_id)}
                  >
                    Remove
                  </button>
                </div>
              ) : null}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default ListDetailPage;
