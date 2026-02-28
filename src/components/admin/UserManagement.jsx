import { useCallback, useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useToast } from "../../context/ToastContext";
import { getAdminUsers, toggleUserAdmin } from "../../services/admin";
import { formatDate } from "../../utils/formatters";
import Spinner from "../ui/Spinner";

function UserManagement() {
  const { addToast } = useToast();
  const [data, setData] = useState({ total: 0, users: [] });
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [searchInput, setSearchInput] = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const result = await getAdminUsers(search);
      setData(result);
    } catch {
      setData({ total: 0, users: [] });
    } finally {
      setLoading(false);
    }
  }, [search]);

  useEffect(() => { load(); }, [load]);

  const handleSearch = (e) => {
    e.preventDefault();
    setSearch(searchInput);
  };

  const handleToggleAdmin = async (userId, currentAdmin) => {
    try {
      await toggleUserAdmin(userId, !currentAdmin);
      addToast({ message: `Admin status updated`, type: "success" });
      load();
    } catch (err) {
      addToast({ message: err.message || "Failed to update user", type: "error" });
    }
  };

  return (
    <div className="admin-section">
      <div className="admin-toolbar">
        <form onSubmit={handleSearch} className="admin-search-form">
          <input
            type="text"
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            placeholder="Search users..."
            className="auth-input"
          />
          <button type="submit" className="btn btn-ghost btn-sm">Search</button>
        </form>
        <span className="muted-text">{data.total} users</span>
      </div>

      {loading ? <Spinner size={24} /> : data.users.length === 0 ? (
        <p className="muted-text">No users found</p>
      ) : (
        <div className="admin-list">
          {data.users.map((u) => (
            <div key={u.id} className="admin-card">
              <div className="admin-card-header">
                <Link to={`/profile/${u.id}`} className="admin-user-link">
                  {u.display_name || u.username}
                </Link>
                {u.is_admin ? <span className="admin-badge">Admin</span> : null}
                <span className="admin-card-meta">Joined {formatDate(u.created_at)} &middot; {u.books_logged} books logged</span>
              </div>
              <div className="admin-card-actions">
                <button
                  type="button"
                  className={`btn btn-sm ${u.is_admin ? "btn-ghost" : "btn-primary"}`}
                  onClick={() => handleToggleAdmin(u.id, u.is_admin)}
                >
                  {u.is_admin ? "Remove Admin" : "Make Admin"}
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default UserManagement;
