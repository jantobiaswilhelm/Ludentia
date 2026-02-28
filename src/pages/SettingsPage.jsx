import { useState, useRef } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { useToast } from "../context/ToastContext";
import { useDocumentTitle } from "../hooks/useDocumentTitle";
import { getExportData, exportAsJSON, exportAsCSV } from "../services/dataExport";
import { parseGoodreadsCSV, importGoodreadsData } from "../services/dataImport";
import ProgressBar from "../components/stats/ProgressBar";
import EmptyState from "../components/ui/EmptyState";

function SettingsPage() {
  const { user } = useAuth();
  const { addToast } = useToast();
  useDocumentTitle("Settings");

  const [exporting, setExporting] = useState(false);
  const [importing, setImporting] = useState(false);
  const [importProgress, setImportProgress] = useState(null);
  const [importResult, setImportResult] = useState(null);
  const [parsedRows, setParsedRows] = useState(null);
  const fileRef = useRef(null);

  if (!user) {
    return <EmptyState title="Log in to access settings" />;
  }

  const handleExportJSON = async () => {
    setExporting(true);
    try {
      const data = await getExportData(user.id);
      exportAsJSON(data);
      addToast({ message: "Data exported as JSON", type: "success" });
    } catch (err) {
      addToast({ message: err.message || "Export failed", type: "error" });
    } finally {
      setExporting(false);
    }
  };

  const handleExportCSV = async () => {
    setExporting(true);
    try {
      const data = await getExportData(user.id);
      exportAsCSV(data.book_logs);
      addToast({ message: "Books exported as CSV", type: "success" });
    } catch (err) {
      addToast({ message: err.message || "Export failed", type: "error" });
    } finally {
      setExporting(false);
    }
  };

  const handleFileSelect = (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setImportResult(null);
    setImportProgress(null);

    const reader = new FileReader();
    reader.onload = (ev) => {
      try {
        const rows = parseGoodreadsCSV(ev.target.result);
        setParsedRows(rows);
        addToast({ message: `Parsed ${rows.length} books from CSV`, type: "success" });
      } catch (err) {
        addToast({ message: err.message || "Failed to parse CSV", type: "error" });
        setParsedRows(null);
      }
    };
    reader.readAsText(file);
  };

  const handleImport = async () => {
    if (!parsedRows) return;
    setImporting(true);
    setImportResult(null);
    try {
      const result = await importGoodreadsData(parsedRows, user.id, (p) => setImportProgress(p));
      setImportResult(result);
      addToast({ message: `Imported ${result.imported} books!`, type: "success" });
    } catch (err) {
      addToast({ message: err.message || "Import failed", type: "error" });
    } finally {
      setImporting(false);
      setParsedRows(null);
      if (fileRef.current) fileRef.current.value = "";
    }
  };

  return (
    <div className="settings-page">
      <div className="stats-header">
        <Link to="/profile" className="back-link">&larr; Profile</Link>
        <h1>Settings</h1>
      </div>

      {/* Export */}
      <section className="settings-section">
        <h2>Export Your Data</h2>
        <p className="muted-text">Download your reading history, shelves, diary entries, and lists.</p>
        <div className="settings-btn-row">
          <button type="button" className="btn btn-primary" onClick={handleExportJSON} disabled={exporting}>
            {exporting ? "Exporting..." : "Export as JSON"}
          </button>
          <button type="button" className="btn btn-ghost" onClick={handleExportCSV} disabled={exporting}>
            {exporting ? "Exporting..." : "Export Books as CSV"}
          </button>
        </div>
      </section>

      {/* Import */}
      <section className="settings-section">
        <h2>Import from Goodreads</h2>
        <p className="muted-text">
          Export your Goodreads library as CSV (My Books &rarr; Import/Export &rarr; Export Library), then upload it here.
        </p>

        <div className="import-upload-area">
          <input
            type="file"
            accept=".csv"
            ref={fileRef}
            onChange={handleFileSelect}
            className="import-file-input"
            disabled={importing}
          />
        </div>

        {parsedRows && !importing ? (
          <div className="import-preview">
            <p>{parsedRows.length} books found in CSV</p>
            <p className="muted-text">
              Read: {parsedRows.filter((r) => r.shelf === "read").length} &middot;
              Reading: {parsedRows.filter((r) => r.shelf === "reading").length} &middot;
              Want to read: {parsedRows.filter((r) => r.shelf === "want_to_read").length}
            </p>
            <button type="button" className="btn btn-primary" onClick={handleImport}>
              Start Import
            </button>
          </div>
        ) : null}

        {importing && importProgress ? (
          <div className="import-progress">
            <ProgressBar value={importProgress.current} max={importProgress.total} showPct />
            <p className="muted-text">
              Processing {importProgress.current} / {importProgress.total} &middot;
              Imported: {importProgress.imported} &middot; Skipped: {importProgress.skipped}
            </p>
          </div>
        ) : null}

        {importResult ? (
          <div className="import-result">
            <p><strong>{importResult.imported}</strong> books imported, <strong>{importResult.skipped}</strong> skipped</p>
            {importResult.errors.length > 0 ? (
              <details className="import-errors">
                <summary>{importResult.errors.length} issue{importResult.errors.length !== 1 ? "s" : ""}</summary>
                <ul>
                  {importResult.errors.slice(0, 20).map((e, i) => (
                    <li key={i}>Row {e.row}: {e.title} — {e.reason}</li>
                  ))}
                  {importResult.errors.length > 20 ? <li>...and {importResult.errors.length - 20} more</li> : null}
                </ul>
              </details>
            ) : null}
          </div>
        ) : null}
      </section>
    </div>
  );
}

export default SettingsPage;
