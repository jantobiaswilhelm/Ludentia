import { useParams, Link } from "react-router-dom";
import { useReadingStats } from "../hooks/useReadingStats";
import StatCard from "../components/stats/StatCard";
import BarChart from "../components/stats/BarChart";
import EmptyState from "../components/ui/EmptyState";
import Spinner from "../components/ui/Spinner";
import { useDocumentTitle } from "../hooks/useDocumentTitle";

const MONTH_NAMES = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
const currentYear = new Date().getFullYear();
const YEARS = [null, ...Array.from({ length: 10 }, (_, i) => currentYear - i)];

function StatsPage() {
  const { userId } = useParams();
  const { stats, loading, year, setYear } = useReadingStats(userId);
  useDocumentTitle("Reading Stats");

  if (loading) {
    return <div className="page-center"><Spinner size={40} /></div>;
  }

  const summary = stats?.summary;
  const hasData = summary && summary.books_logged > 0;

  return (
    <div className="stats-page">
      <div className="stats-header">
        <Link to={`/profile/${userId}`} className="back-link">&larr; Profile</Link>
        <h1>Reading Stats</h1>
        <select
          value={year ?? ""}
          onChange={(e) => setYear(e.target.value ? parseInt(e.target.value) : null)}
          className="log-select"
        >
          {YEARS.map((y) => (
            <option key={y ?? "all"} value={y ?? ""}>{y ?? "All Time"}</option>
          ))}
        </select>
        <Link to={`/profile/${userId}/year-in-review`} className="btn btn-ghost btn-sm">
          Year in Review
        </Link>
      </div>

      {!hasData ? (
        <EmptyState
          title="No reading data"
          description="Log some books to see your reading statistics."
        />
      ) : (
        <>
          <div className="stat-cards-row">
            <StatCard value={summary.books_logged} label="Books Logged" />
            <StatCard value={summary.total_pages?.toLocaleString()} label="Pages Read" />
            <StatCard value={summary.avg_rating} label="Avg Rating" />
            <StatCard value={summary.rereads} label="Rereads" />
          </div>

          {/* Books per month */}
          {(stats.by_month || []).length > 0 ? (
            <section className="stats-section">
              <h2>Books Per Month</h2>
              <BarChart
                data={stats.by_month.map((m) => ({
                  label: MONTH_NAMES[m.month - 1] || m.month,
                  value: m.count,
                }))}
                orientation="vertical"
              />
            </section>
          ) : null}

          {/* Rating distribution */}
          {(stats.rating_distribution || []).length > 0 ? (
            <section className="stats-section">
              <h2>Rating Distribution</h2>
              <BarChart
                data={stats.rating_distribution.map((r) => ({
                  label: `${r.rating}/10`,
                  value: r.count,
                }))}
                orientation="horizontal"
              />
            </section>
          ) : null}

          {/* Top genres */}
          {(stats.top_genres || []).length > 0 ? (
            <section className="stats-section">
              <h2>Top Genres</h2>
              <BarChart
                data={stats.top_genres.map((g) => ({
                  label: g.genre,
                  value: g.count,
                }))}
                orientation="horizontal"
                color="var(--accent)"
              />
            </section>
          ) : null}

          {/* Top authors */}
          {(stats.top_authors || []).length > 0 ? (
            <section className="stats-section">
              <h2>Top Authors</h2>
              <BarChart
                data={stats.top_authors.map((a) => ({
                  label: a.author,
                  value: a.count,
                }))}
                orientation="horizontal"
                color="var(--primary-hover)"
              />
            </section>
          ) : null}
        </>
      )}
    </div>
  );
}

export default StatsPage;
