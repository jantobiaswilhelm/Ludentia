import { useCallback, useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { getCachedBookById } from "../services/bookCache";
import { useBookShelfStatus } from "../hooks/useBookshelf";
import { useBookReviews } from "../hooks/useBookLog";
import useBookTags from "../hooks/useBookTags";
import { useBookDiary, useReadingProgress } from "../hooks/useDiary";
import BookCover from "../components/books/BookCover";
import ShelfSelector from "../components/shelves/ShelfSelector";
import RatingDisplay from "../components/ratings/RatingDisplay";
import RatingDistribution from "../components/ratings/RatingDistribution";
import TagSection from "../components/tags/TagSection";
import TagVotePanel from "../components/tags/TagVotePanel";
import DiaryFeed from "../components/diary/DiaryFeed";
import ProgressTracker from "../components/diary/ProgressTracker";
import MoodSelector from "../components/diary/MoodSelector";
import LogBookModal from "../components/logging/LogBookModal";
import EmptyState from "../components/ui/EmptyState";
import Spinner from "../components/ui/Spinner";
import { formatDate, truncate } from "../utils/formatters";

function BookDetailPage() {
  const { id, "*": rest } = useParams();
  const fullId = rest ? `${id}/${rest}` : id;
  const { user } = useAuth();
  const [book, setBook] = useState(null);
  const [loading, setLoading] = useState(true);
  const [showLogModal, setShowLogModal] = useState(false);
  const [descExpanded, setDescExpanded] = useState(false);
  const [diaryText, setDiaryText] = useState("");
  const [diaryPage, setDiaryPage] = useState("");
  const [diarySpoiler, setDiarySpoiler] = useState(false);

  // Use resolved Supabase UUID, not URL param
  const bookId = book?.id || null;

  const { entry: shelfEntry, setShelf, remove: removeShelf } = useBookShelfStatus(bookId);
  const { logs: reviews, stats, refresh: refreshReviews } = useBookReviews(bookId);
  const { tagCounts, userVotes, officialTags, toggleVote, refresh: refreshTags } = useBookTags(bookId);
  const { entries: diaryEntries, addEntry, removeEntry, refresh: refreshDiary } = useBookDiary(bookId);
  const { progress, update: updateProgress } = useReadingProgress(bookId);

  const loadBook = useCallback(async () => {
    setLoading(true);
    try {
      const data = await getCachedBookById(fullId);
      setBook(data);
    } catch {
      setBook(null);
    } finally {
      setLoading(false);
    }
  }, [fullId]);

  useEffect(() => {
    loadBook();
  }, [loadBook]);

  const handleShelfSelect = async (shelf) => {
    if (shelf === null) {
      await removeShelf();
      return;
    }
    await setShelf(shelf);
    if (shelf === "read") {
      setShowLogModal(true);
    }
  };

  const handleAddDiary = async () => {
    if (!diaryText.trim()) return;
    await addEntry({
      entry_text: diaryText,
      page_at: diaryPage ? parseInt(diaryPage) : null,
      is_spoiler: diarySpoiler,
    });
    setDiaryText("");
    setDiaryPage("");
    setDiarySpoiler(false);
  };

  const handleMoodChange = async (moods) => {
    await updateProgress({ mood_tags: moods });
  };

  if (loading) {
    return (
      <div className="page-center">
        <Spinner size={40} />
      </div>
    );
  }

  if (!book) {
    return <EmptyState title="Book not found" description="This book doesn't exist in our database yet." />;
  }

  const desc = book.description || "";
  const longDesc = desc.length > 300;

  return (
    <div className="book-detail-page">
      <div className="book-detail-hero">
        <div className="book-detail-cover">
          <BookCover
            title={book.title}
            coverUrl={book.cover_url_large || book.cover_url}
          />
        </div>

        <div className="book-detail-info">
          <h1>{book.title}</h1>
          <p className="book-detail-authors">{(book.authors || []).join(", ") || "Unknown author"}</p>

          <RatingDisplay
            avgRating={stats?.avg_rating}
            ratingCount={stats?.rating_count}
          />

          <div className="book-detail-meta-row">
            {book.page_count ? <span className="meta-chip">{book.page_count} pages</span> : null}
            {book.published_date ? <span className="meta-chip">{book.published_date}</span> : null}
            {book.language ? <span className="meta-chip">{book.language.toUpperCase()}</span> : null}
          </div>

          {(book.categories || []).length > 0 ? (
            <div className="book-detail-genres">
              {book.categories.map((cat) => (
                <span key={cat} className="genre-badge">{cat}</span>
              ))}
            </div>
          ) : null}

          {user ? (
            <ShelfSelector
              currentShelf={shelfEntry?.shelf}
              onSelect={handleShelfSelect}
            />
          ) : null}

          {user && shelfEntry?.shelf !== "read" ? (
            <button
              type="button"
              className="btn btn-primary"
              onClick={() => setShowLogModal(true)}
            >
              Log this book
            </button>
          ) : null}
        </div>
      </div>

      {/* Description */}
      {desc ? (
        <section className="book-section">
          <h2>About</h2>
          <p className="book-description">
            {longDesc && !descExpanded ? truncate(desc, 300) : desc}
          </p>
          {longDesc ? (
            <button
              type="button"
              className="btn btn-ghost btn-sm"
              onClick={() => setDescExpanded(!descExpanded)}
            >
              {descExpanded ? "Show less" : "Read more"}
            </button>
          ) : null}
        </section>
      ) : null}

      {/* Reading progress (if currently reading) */}
      {user && shelfEntry?.shelf === "reading" ? (
        <section className="book-section">
          <h2>Reading Progress</h2>
          <ProgressTracker
            progress={progress}
            totalPages={book.page_count}
            onUpdate={updateProgress}
          />
          <MoodSelector
            selected={progress?.mood_tags || []}
            onChange={handleMoodChange}
          />
        </section>
      ) : null}

      {/* Community Tags */}
      <section className="book-section">
        <h2>Community Tags</h2>
        {user ? (
          <TagVotePanel
            bookId={bookId}
            tagCounts={tagCounts}
            officialTags={officialTags}
            userVotes={userVotes}
            onToggleVote={toggleVote}
            onRefresh={refreshTags}
          />
        ) : (
          <TagSection
            tagCounts={tagCounts}
            officialTags={officialTags}
            userVotes={[]}
            onToggleVote={() => {}}
            compact
          />
        )}
      </section>

      {/* Rating distribution */}
      {stats ? (
        <section className="book-section">
          <h2>Rating Distribution</h2>
          <RatingDistribution stats={stats} />
        </section>
      ) : null}

      {/* Reviews */}
      <section className="book-section">
        <h2>Reviews</h2>
        {reviews.length === 0 ? (
          <p className="muted-text">No reviews yet. Be the first!</p>
        ) : (
          <div className="reviews-list">
            {reviews.map((log) => (
              <div key={log.id} className="review-card">
                <div className="review-header">
                  <span className="review-author">
                    {log.profiles?.display_name || log.profiles?.username || "Anonymous"}
                  </span>
                  <span className="review-rating">{log.rating}/10</span>
                  <span className="review-date">{formatDate(log.created_at)}</span>
                </div>
                {log.contains_spoilers ? (
                  <p className="review-spoiler-warn">Contains spoilers</p>
                ) : null}
                {log.review_text ? <p className="review-text">{log.review_text}</p> : null}
              </div>
            ))}
          </div>
        )}
      </section>

      {/* Diary entries */}
      <section className="book-section">
        <h2>Diary Entries</h2>
        {user ? (
          <div className="diary-add-form">
            <textarea
              value={diaryText}
              onChange={(e) => setDiaryText(e.target.value)}
              placeholder="Add a diary entry..."
              className="diary-input"
              rows={2}
            />
            <div className="diary-add-options">
              <input
                type="number"
                value={diaryPage}
                onChange={(e) => setDiaryPage(e.target.value)}
                placeholder="Page #"
                className="diary-page-input"
              />
              <label className="log-checkbox">
                <input
                  type="checkbox"
                  checked={diarySpoiler}
                  onChange={(e) => setDiarySpoiler(e.target.checked)}
                />
                Spoiler
              </label>
              <button
                type="button"
                className="btn btn-primary btn-sm"
                onClick={handleAddDiary}
                disabled={!diaryText.trim()}
              >
                Add
              </button>
            </div>
          </div>
        ) : null}
        <DiaryFeed
          entries={diaryEntries}
          onDelete={user ? removeEntry : undefined}
        />
      </section>

      <LogBookModal
        open={showLogModal}
        onClose={() => setShowLogModal(false)}
        book={book}
        onComplete={() => {
          refreshReviews();
          refreshTags();
        }}
      />
    </div>
  );
}

export default BookDetailPage;
