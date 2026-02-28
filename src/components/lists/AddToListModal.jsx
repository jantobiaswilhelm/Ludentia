import { useEffect, useState } from "react";
import { useAuth } from "../../context/AuthContext";
import { getUserLists, addBookToList, removeBookFromList, getListsContainingBook } from "../../services/lists";
import CreateListModal from "./CreateListModal";

function AddToListModal({ open, onClose, bookId }) {
  const { user } = useAuth();
  const [lists, setLists] = useState([]);
  const [containingListIds, setContainingListIds] = useState(new Set());
  const [loading, setLoading] = useState(true);
  const [showCreate, setShowCreate] = useState(false);

  useEffect(() => {
    if (!open || !user?.id || !bookId) return;
    setLoading(true);
    Promise.all([
      getUserLists(user.id),
      getListsContainingBook(user.id, bookId),
    ]).then(([userLists, containingIds]) => {
      setLists(userLists);
      setContainingListIds(new Set(containingIds));
      setLoading(false);
    }).catch(() => setLoading(false));
  }, [open, user?.id, bookId]);

  if (!open) return null;

  const handleToggle = async (listId) => {
    const isIn = containingListIds.has(listId);
    try {
      if (isIn) {
        await removeBookFromList(listId, bookId);
        setContainingListIds((prev) => {
          const next = new Set(prev);
          next.delete(listId);
          return next;
        });
      } else {
        await addBookToList(listId, bookId);
        setContainingListIds((prev) => new Set([...prev, listId]));
      }
    } catch {
      // ignore
    }
  };

  const handleCreated = (newList) => {
    setLists((prev) => [newList, ...prev]);
    setShowCreate(false);
  };

  return (
    <>
      <div className="modal-overlay" onClick={onClose}>
        <div className="modal-content" onClick={(e) => e.stopPropagation()}>
          <div className="modal-header">
            <h2 className="modal-title">Add to List</h2>
            <button type="button" className="modal-close" onClick={onClose}>&times;</button>
          </div>
          <div className="modal-body">
            {loading ? (
              <p className="muted-text">Loading lists...</p>
            ) : lists.length === 0 ? (
              <p className="muted-text">You don't have any lists yet.</p>
            ) : (
              <div className="add-to-list-options">
                {lists.map((list) => {
                  const isIn = containingListIds.has(list.id);
                  return (
                    <button
                      key={list.id}
                      type="button"
                      className={`add-to-list-item ${isIn ? "add-to-list-active" : ""}`}
                      onClick={() => handleToggle(list.id)}
                    >
                      <span className="add-to-list-check">{isIn ? "\u2713" : ""}</span>
                      <span>{list.title}</span>
                      <span className="muted-text">{list.item_count || 0} books</span>
                    </button>
                  );
                })}
              </div>
            )}
            <button
              type="button"
              className="btn btn-ghost btn-sm"
              onClick={() => setShowCreate(true)}
              style={{ marginTop: "var(--space-md)" }}
            >
              + Create new list
            </button>
          </div>
        </div>
      </div>
      <CreateListModal

        open={showCreate}
        onClose={() => setShowCreate(false)}
        onCreated={handleCreated}
      />
    </>
  );
}

export default AddToListModal;
