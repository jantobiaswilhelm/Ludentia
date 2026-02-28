import { useState } from "react";
import { useAuth } from "../context/AuthContext";
import { useUserShelves } from "../hooks/useBookshelf";
import ShelfList from "../components/shelves/ShelfList";
import EmptyState from "../components/ui/EmptyState";
import Spinner from "../components/ui/Spinner";
import { SHELVES, SHELF_ORDER } from "../utils/constants";
import { Link } from "react-router-dom";

function MyShelfPage() {
  const { user, loading: authLoading } = useAuth();
  const { shelves, loading, byShelf } = useUserShelves();
  const [activeTab, setActiveTab] = useState("all");

  if (authLoading || loading) {
    return (
      <div className="page-center">
        <Spinner size={40} />
      </div>
    );
  }

  if (!user) {
    return (
      <EmptyState
        title="Sign in to see your shelf"
        description="Track what you're reading and want to read."
        action={<Link to="/login" className="btn btn-primary">Sign In</Link>}
      />
    );
  }

  const tabs = [
    { key: "all", label: "All", count: shelves.length },
    ...SHELF_ORDER.map((key) => ({
      key,
      label: SHELVES[key].label,
      count: byShelf(key).length,
    })),
  ];

  const visibleItems = activeTab === "all" ? shelves : byShelf(activeTab);

  return (
    <div className="shelf-page">
      <h1>My Shelf</h1>

      <div className="shelf-tabs">
        {tabs.map((tab) => (
          <button
            key={tab.key}
            type="button"
            className={`shelf-tab ${activeTab === tab.key ? "shelf-tab-active" : ""}`}
            onClick={() => setActiveTab(tab.key)}
          >
            {tab.label} <span className="tab-count">{tab.count}</span>
          </button>
        ))}
      </div>

      {visibleItems.length === 0 ? (
        <EmptyState
          title="Nothing here yet"
          description="Start by searching for books and adding them to your shelf."
          action={<Link to="/" className="btn btn-primary">Discover Books</Link>}
        />
      ) : (
        <ShelfList items={visibleItems} />
      )}
    </div>
  );
}

export default MyShelfPage;
