import { useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { useUserDiary } from "../hooks/useDiary";
import DiaryFeed from "../components/diary/DiaryFeed";
import EmptyState from "../components/ui/EmptyState";
import Spinner from "../components/ui/Spinner";
import { useDocumentTitle } from "../hooks/useDocumentTitle";

function DiaryPage() {
  const { user, loading: authLoading } = useAuth();
  const { entries, loading, refresh } = useUserDiary();
  const [filterBook, setFilterBook] = useState("");
  useDocumentTitle("Diary");

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
        title="Sign in to see your diary"
        description="Keep a reading journal as you go."
        action={<Link to="/login" className="btn btn-primary">Sign In</Link>}
      />
    );
  }

  const filteredEntries = filterBook
    ? entries.filter((e) => e.books?.title?.toLowerCase().includes(filterBook.toLowerCase()))
    : entries;

  return (
    <div className="diary-page">
      <h1>My Reading Diary</h1>

      <div className="diary-filters">
        <input
          type="text"
          value={filterBook}
          onChange={(e) => setFilterBook(e.target.value)}
          placeholder="Filter by book title..."
          className="diary-filter-input"
        />
      </div>

      {filteredEntries.length === 0 ? (
        <EmptyState
          title="No diary entries yet"
          description="Start reading and add notes as you go!"
        />
      ) : (
        <DiaryFeed entries={filteredEntries} showBook />
      )}
    </div>
  );
}

export default DiaryPage;
