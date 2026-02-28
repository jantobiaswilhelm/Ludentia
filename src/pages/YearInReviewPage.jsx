import { useParams, Link } from "react-router-dom";
import { useYearInReview } from "../hooks/useReadingStats";
import StatCard from "../components/stats/StatCard";
import BarChart from "../components/stats/BarChart";
import BookHighlight from "../components/stats/BookHighlight";
import ProgressBar from "../components/stats/ProgressBar";
import EmptyState from "../components/ui/EmptyState";
import Spinner from "../components/ui/Spinner";
import { useDocumentTitle } from "../hooks/useDocumentTitle";

const MONTH_NAMES = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
const currentYear = new Date().getFullYear();
const YEARS = Array.from({ length: 10 }, (_, i) => currentYear - i);

function YearInReviewPage() {
  const { userId } = useParams();
  const { review, loading, year, setYear } = useYearInReview(userId);
  useDocumentTitle("Year in Review");

  if (loading) {
    return <div className="page-center"><Spinner size={40} /></div>;
  }

  const summary = review?.summary;
  const hasData = summary && summary.books_logged > 0;

  return (
    <div className="year-in-review">
      <div className="stats-header">
        <Link to={`/profile/${userId}/stats`} className="back-link">&larr; Stats</Link>
        <h1>Year in Review</h1>
        <select
          value={year}
          onChange={(e) => setYear(parseInt(e.target.value))}
          className="log-select"
        >
          {YEARS.map((y) => (
            <option key={y} value={y}>{y}</option>
          ))}
        </select>
      </div>

      {!hasData ? (
        <EmptyState
          title={`No reading data for ${year}`}
          description="Log some books to see your year in review."
        />
      ) : (
        <>
          {/* Hero stats */}
          <section className="yir-hero">
            <div className="stat-cards-row">
              <StatCard value={summary.books_logged} label="Books Read" />
              <StatCard value={summary.total_pages?.toLocaleString()} label="Pages" />
              <StatCard value={summary.avg_rating} label="Avg Rating" />
              <StatCard value={summary.unique_books} label="Unique Titles" />
            </div>
            {summary.rereads > 0 ? (
              <p className="yir-meta">{summary.rereads} reread{summary.rereads !== 1 ? "s" : ""} this year</p>
            ) : null}
            {review.diary_entries_count > 0 ? (
              <p className="yir-meta">{review.diary_entries_count} diary entr{review.diary_entries_count !== 1 ? "ies" : "y"} written</p>
            ) : null}
          </section>

          {/* Books per month */}
          {(review.by_month || []).length > 0 ? (
            <section className="yir-section">
              <h2>Books Per Month</h2>
              <BarChart
                data={review.by_month.map((m) => ({
                  label: MONTH_NAMES[m.month - 1] || m.month,
                  value: m.count,
                }))}
                orientation="vertical"
              />
              {review.busiest_month ? (
                <p className="yir-meta">
                  Busiest month: <strong>{MONTH_NAMES[review.busiest_month.month - 1]}</strong> ({review.busiest_month.count} books)
                </p>
              ) : null}
            </section>
          ) : null}

          {/* Rating distribution */}
          {(review.rating_distribution || []).length > 0 ? (
            <section className="yir-section">
              <h2>Rating Distribution</h2>
              <BarChart
                data={review.rating_distribution.map((r) => ({
                  label: `${r.rating}/10`,
                  value: r.count,
                }))}
                orientation="horizontal"
              />
            </section>
          ) : null}

          {/* Highest rated */}
          {(review.highest_rated || []).length > 0 ? (
            <section className="yir-section">
              <h2>Highest Rated</h2>
              <div className="book-highlight-grid">
                {review.highest_rated.map((b) => (
                  <BookHighlight key={b.book_id} book={b} stat={`${b.rating}/10`} />
                ))}
              </div>
            </section>
          ) : null}

          {/* Lowest rated */}
          {(review.lowest_rated || []).length > 0 ? (
            <section className="yir-section">
              <h2>Lowest Rated</h2>
              <div className="book-highlight-grid">
                {review.lowest_rated.map((b) => (
                  <BookHighlight key={b.book_id} book={b} stat={`${b.rating}/10`} />
                ))}
              </div>
            </section>
          ) : null}

          {/* Longest books */}
          {(review.longest_books || []).length > 0 ? (
            <section className="yir-section">
              <h2>Longest Books</h2>
              <div className="book-highlight-grid">
                {review.longest_books.map((b) => (
                  <BookHighlight key={b.book_id} book={b} stat={`${b.page_count} pages`} />
                ))}
              </div>
            </section>
          ) : null}

          {/* Shortest books */}
          {(review.shortest_books || []).length > 0 ? (
            <section className="yir-section">
              <h2>Shortest Books</h2>
              <div className="book-highlight-grid">
                {review.shortest_books.map((b) => (
                  <BookHighlight key={b.book_id} book={b} stat={`${b.page_count} pages`} />
                ))}
              </div>
            </section>
          ) : null}

          {/* Fastest reads */}
          {(review.fastest_reads || []).length > 0 ? (
            <section className="yir-section">
              <h2>Fastest Reads</h2>
              <div className="book-highlight-grid">
                {review.fastest_reads.map((b) => (
                  <BookHighlight key={b.book_id} book={b} stat={`${b.days_to_read} day${b.days_to_read !== 1 ? "s" : ""}`} />
                ))}
              </div>
            </section>
          ) : null}

          {/* Top genres */}
          {(review.top_genres || []).length > 0 ? (
            <section className="yir-section">
              <h2>Top Genres</h2>
              <BarChart
                data={review.top_genres.map((g) => ({ label: g.genre, value: g.count }))}
                orientation="horizontal"
                color="var(--accent)"
              />
            </section>
          ) : null}

          {/* Top authors */}
          {(review.top_authors || []).length > 0 ? (
            <section className="yir-section">
              <h2>Top Authors</h2>
              <BarChart
                data={review.top_authors.map((a) => ({ label: a.author, value: a.count }))}
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

export default YearInReviewPage;
