import { useEffect, useState } from "react";
import RatingInput from "../ratings/RatingInput";
import TagSection from "../tags/TagSection";
import TagBadge from "../tags/TagBadge";
import { useAuth } from "../../context/AuthContext";
import { useCreateBookLog } from "../../hooks/useBookLog";
import useBookTags from "../../hooks/useBookTags";
import { getPopularTagsForBook } from "../../services/tags";
import { VISIBILITY_OPTIONS } from "../../utils/constants";

function LogAllInOne({ book, onSubmit }) {
  const { user } = useAuth();
  const { submit, submitting } = useCreateBookLog();
  const { tagCounts, userVotes, officialTags, toggleVote } = useBookTags(book.id);
  const [popularTags, setPopularTags] = useState([]);

  const [rating, setRating] = useState(0);
  const [reviewText, setReviewText] = useState("");
  const [dateFinished, setDateFinished] = useState(new Date().toISOString().slice(0, 10));
  const [dateStarted, setDateStarted] = useState("");
  const [containsSpoilers, setContainsSpoilers] = useState(false);
  const [visibility, setVisibility] = useState("public");
  const [isReread, setIsReread] = useState(false);

  useEffect(() => {
    if (book.id) {
      getPopularTagsForBook(book.id, 10).then(setPopularTags);
    }
  }, [book.id]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!rating) return;
    const log = await submit({
      book_id: book.id,
      rating,
      review_text: reviewText || null,
      date_finished: dateFinished || null,
      date_started: dateStarted || null,
      contains_spoilers: containsSpoilers,
      visibility,
      is_reread: isReread,
    });
    onSubmit(log);
  };

  return (
    <form className="log-form" onSubmit={handleSubmit}>
      <div className="log-field">
        <label className="log-label">Rating *</label>
        <RatingInput value={rating} onChange={setRating} />
      </div>

      <div className="log-row">
        <div className="log-field">
          <label className="log-label">Date finished</label>
          <input
            type="date"
            value={dateFinished}
            onChange={(e) => setDateFinished(e.target.value)}
            className="log-input"
          />
        </div>
        <div className="log-field">
          <label className="log-label">Date started</label>
          <input
            type="date"
            value={dateStarted}
            onChange={(e) => setDateStarted(e.target.value)}
            className="log-input"
          />
        </div>
      </div>

      <div className="log-field">
        <label className="log-label">Community Tags</label>
        {popularTags.length > 0 ? (
          <div className="tag-suggestions">
            <div className="tag-suggestions-label">Popular for this book</div>
            <div className="tag-list">
              {popularTags.map((pt) => {
                const officialTag = officialTags.find((t) => t.id === pt.tag_id);
                if (!officialTag) return null;
                return (
                  <TagBadge
                    key={pt.tag_id}
                    tag={officialTag}
                    count={pt.vote_count}
                    voted={userVotes.includes(pt.tag_id)}
                    onClick={() => toggleVote(pt.tag_id)}
                  />
                );
              })}
            </div>
          </div>
        ) : null}
        <TagSection
          tagCounts={tagCounts}
          officialTags={officialTags}
          userVotes={userVotes}
          onToggleVote={toggleVote}
        />
      </div>

      <div className="log-field">
        <label className="log-label">Review (optional)</label>
        <textarea
          value={reviewText}
          onChange={(e) => setReviewText(e.target.value)}
          placeholder="What did you think?"
          className="log-textarea"
          rows={4}
        />
      </div>

      <div className="log-row log-options">
        <label className="log-checkbox">
          <input
            type="checkbox"
            checked={containsSpoilers}
            onChange={(e) => setContainsSpoilers(e.target.checked)}
          />
          Contains spoilers
        </label>
        <label className="log-checkbox">
          <input
            type="checkbox"
            checked={isReread}
            onChange={(e) => setIsReread(e.target.checked)}
          />
          Re-read
        </label>
        <select
          value={visibility}
          onChange={(e) => setVisibility(e.target.value)}
          className="log-select"
        >
          {VISIBILITY_OPTIONS.map((v) => (
            <option key={v.value} value={v.value}>{v.label}</option>
          ))}
        </select>
      </div>

      <button
        type="submit"
        className="btn btn-primary"
        disabled={!rating || submitting}
      >
        {submitting ? "Saving..." : "Log Book"}
      </button>
    </form>
  );
}

export default LogAllInOne;
