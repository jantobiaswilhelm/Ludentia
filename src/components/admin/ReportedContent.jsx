import { useCallback, useEffect, useState } from "react";
import { useToast } from "../../context/ToastContext";
import { getReportedContent, updateReport } from "../../services/admin";
import { formatDate } from "../../utils/formatters";
import Spinner from "../ui/Spinner";

const STATUS_OPTIONS = ["pending", "reviewed", "actioned", "dismissed"];

function ReportedContent() {
  const { addToast } = useToast();
  const [reports, setReports] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState("pending");

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const data = await getReportedContent(filter);
      setReports(data);
    } catch {
      setReports([]);
    } finally {
      setLoading(false);
    }
  }, [filter]);

  useEffect(() => { load(); }, [load]);

  const handleResolve = async (reportId, status, notes) => {
    try {
      await updateReport(reportId, { status, adminNotes: notes });
      addToast({ message: `Report ${status}`, type: "success" });
      load();
    } catch (err) {
      addToast({ message: err.message || "Failed to update report", type: "error" });
    }
  };

  return (
    <div className="admin-section">
      <div className="admin-toolbar">
        <select value={filter} onChange={(e) => setFilter(e.target.value)} className="log-select">
          {STATUS_OPTIONS.map((s) => (
            <option key={s} value={s}>{s.charAt(0).toUpperCase() + s.slice(1)}</option>
          ))}
        </select>
      </div>

      {loading ? <Spinner size={24} /> : reports.length === 0 ? (
        <p className="muted-text">No {filter} reports</p>
      ) : (
        <div className="admin-list">
          {reports.map((r) => (
            <div key={r.id} className="admin-card">
              <div className="admin-card-header">
                <span className="admin-card-type">{r.content_type}</span>
                <span className="admin-card-meta">Reported by {r.reporter?.display_name || r.reporter?.username} &middot; {formatDate(r.created_at)}</span>
              </div>
              <p className="admin-card-body">{r.reason}</p>
              {filter === "pending" ? (
                <div className="admin-card-actions">
                  <button type="button" className="btn btn-primary btn-sm" onClick={() => handleResolve(r.id, "actioned", "")}>
                    Take Action
                  </button>
                  <button type="button" className="btn btn-ghost btn-sm" onClick={() => handleResolve(r.id, "dismissed", "")}>
                    Dismiss
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

export default ReportedContent;
