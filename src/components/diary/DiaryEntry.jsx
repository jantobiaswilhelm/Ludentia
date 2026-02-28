import { useState } from "react";
import { formatRelativeDate } from "../../utils/formatters";

function DiaryEntry({ entry, showBook, onDelete }) {
  const [revealed, setRevealed] = useState(false);

  return (
    <article className="diary-entry">
      {showBook && entry.books ? (
        <div className="diary-entry-book">
          {entry.books.cover_url ? (
            <img
              src={entry.books.cover_url}
              alt=""
              className="diary-entry-thumb"
              referrerPolicy="no-referrer"
            />
          ) : null}
          <span className="diary-entry-title">{entry.books.title}</span>
        </div>
      ) : null}

      {entry.is_spoiler && !revealed ? (
        <div className="diary-spoiler">
          <p>This entry contains spoilers.</p>
          <button
            type="button"
            className="btn btn-ghost btn-sm"
            onClick={() => setRevealed(true)}
          >
            Reveal
          </button>
        </div>
      ) : (
        <p className="diary-entry-text">{entry.entry_text}</p>
      )}

      <div className="diary-entry-meta">
        {entry.page_at ? <span>Page {entry.page_at}</span> : null}
        <span>{formatRelativeDate(entry.created_at)}</span>
        {entry.profiles ? <span>by {entry.profiles.display_name || entry.profiles.username}</span> : null}
        {onDelete ? (
          <button type="button" className="btn btn-ghost btn-sm" onClick={() => onDelete(entry.id)}>
            Delete
          </button>
        ) : null}
      </div>
    </article>
  );
}

export default DiaryEntry;
