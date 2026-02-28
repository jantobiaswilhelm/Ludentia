import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { useDocumentTitle } from "../hooks/useDocumentTitle";
import { isCurrentUserAdmin } from "../services/admin";
import ReportedContent from "../components/admin/ReportedContent";
import UserManagement from "../components/admin/UserManagement";
import TagModeration from "../components/admin/TagModeration";
import EmptyState from "../components/ui/EmptyState";
import Spinner from "../components/ui/Spinner";

const TABS = [
  { id: "reports", label: "Reports" },
  { id: "users", label: "Users" },
  { id: "tags", label: "Tags" },
];

function AdminPage() {
  const { user } = useAuth();
  useDocumentTitle("Admin");
  const [isAdmin, setIsAdmin] = useState(false);
  const [checking, setChecking] = useState(true);
  const [tab, setTab] = useState("reports");

  useEffect(() => {
    if (!user) { setChecking(false); return; }
    isCurrentUserAdmin()
      .then((val) => setIsAdmin(val))
      .catch(() => setIsAdmin(false))
      .finally(() => setChecking(false));
  }, [user]);

  if (checking) return <div className="page-center"><Spinner size={40} /></div>;
  if (!user || !isAdmin) return <EmptyState title="Access denied" description="You must be an admin to view this page." />;

  return (
    <div className="admin-page">
      <div className="stats-header">
        <Link to="/profile" className="back-link">&larr; Profile</Link>
        <h1>Admin</h1>
      </div>

      <div className="admin-tabs">
        {TABS.map((t) => (
          <button
            key={t.id}
            type="button"
            className={`admin-tab ${tab === t.id ? "admin-tab-active" : ""}`}
            onClick={() => setTab(t.id)}
          >
            {t.label}
          </button>
        ))}
      </div>

      {tab === "reports" ? <ReportedContent /> : null}
      {tab === "users" ? <UserManagement /> : null}
      {tab === "tags" ? <TagModeration /> : null}
    </div>
  );
}

export default AdminPage;
