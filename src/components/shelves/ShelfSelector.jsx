import { SHELVES, SHELF_ORDER } from "../../utils/constants";
import { useAuth } from "../../context/AuthContext";

function ShelfSelector({ currentShelf, onSelect, loading }) {
  const { user } = useAuth();

  if (!user) return null;

  return (
    <div className="shelf-selector">
      {SHELF_ORDER.map((key) => {
        const shelf = SHELVES[key];
        const active = currentShelf === key;
        return (
          <button
            key={key}
            type="button"
            className={`shelf-btn ${active ? "shelf-btn-active" : ""}`}
            disabled={loading}
            onClick={() => onSelect(key)}
          >
            <span className="shelf-icon">{shelf.icon}</span>
            <span>{shelf.label}</span>
          </button>
        );
      })}
      {currentShelf ? (
        <button
          type="button"
          className="shelf-btn shelf-btn-remove"
          disabled={loading}
          onClick={() => onSelect(null)}
        >
          Remove
        </button>
      ) : null}
    </div>
  );
}

export default ShelfSelector;
