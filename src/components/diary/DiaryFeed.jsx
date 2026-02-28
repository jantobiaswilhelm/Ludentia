import DiaryEntry from "./DiaryEntry";

function DiaryFeed({ entries, showBook = false, onDelete }) {
  if (!entries.length) {
    return <p className="diary-empty">No diary entries yet.</p>;
  }

  return (
    <div className="diary-feed">
      {entries.map((entry) => (
        <DiaryEntry
          key={entry.id}
          entry={entry}
          showBook={showBook}
          onDelete={onDelete}
        />
      ))}
    </div>
  );
}

export default DiaryFeed;
