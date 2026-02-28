import { useEffect, useState } from "react";
import RatingInput from "../ratings/RatingInput";
import TagBadge from "../tags/TagBadge";
import { useCreateBookLog } from "../../hooks/useBookLog";
import useBookTags from "../../hooks/useBookTags";
import { getPopularTagsForBook } from "../../services/tags";
import { VISIBILITY_OPTIONS } from "../../utils/constants";

const STEPS = [
  { key: "rating", title: "Rate it", description: "How would you rate this book?" },
  { key: "mood", title: "How did it feel?", description: "Select mood and tone tags" },
  { key: "pacing", title: "Pacing?", description: "How was the pacing?" },
  { key: "ending", title: "How does it end?", description: "Warning: spoiler territory!" },
  { key: "more", title: "More tags", description: "Difficulty, rereadability, series, content warnings" },
  { key: "review", title: "Write a review", description: "Optional — share your thoughts" },
  { key: "done", title: "Done!", description: "Summary of your log" },
];

const STEP_CATEGORIES = {
  mood: "Mood",
  pacing: "Pacing",
  ending: "Ending",
  more: ["Difficulty", "Rereadability", "Series", "Content Warnings", "Story Focus"],
};

function LogStepByStep({ book, onSubmit }) {
  const { submit, submitting } = useCreateBookLog();
  const { tagCounts, userVotes, officialTags, toggleVote } = useBookTags(book.id);
  const [step, setStep] = useState(0);
  const [rating, setRating] = useState(0);
  const [reviewText, setReviewText] = useState("");
  const [visibility, setVisibility] = useState("public");
  const [containsSpoilers, setContainsSpoilers] = useState(false);
  const [popularTags, setPopularTags] = useState([]);

  useEffect(() => {
    if (book.id) {
      getPopularTagsForBook(book.id, 15).then(setPopularTags);
    }
  }, [book.id]);

  const currentStep = STEPS[step];

  const getTagsForStep = (stepKey) => {
    const cats = STEP_CATEGORIES[stepKey];
    if (!cats) return [];
    const catArr = Array.isArray(cats) ? cats : [cats];
    return officialTags.filter((t) => catArr.includes(t.category));
  };

  const getSuggestedTagsForStep = (stepKey) => {
    const cats = STEP_CATEGORIES[stepKey];
    if (!cats) return [];
    const catArr = Array.isArray(cats) ? cats : [cats];
    return popularTags.filter((t) => catArr.includes(t.category));
  };

  const countMap = {};
  for (const tc of tagCounts) {
    countMap[tc.tag_id] = tc.vote_count;
  }

  const handleFinish = async () => {
    if (!rating) return;
    const log = await submit({
      book_id: book.id,
      rating,
      review_text: reviewText || null,
      date_finished: new Date().toISOString().slice(0, 10),
      contains_spoilers: containsSpoilers,
      visibility,
    });
    onSubmit(log);
  };

  const renderStep = () => {
    if (currentStep.key === "rating") {
      return <RatingInput value={rating} onChange={setRating} />;
    }

    if (currentStep.key === "review") {
      return (
        <div className="log-field">
          <textarea
            value={reviewText}
            onChange={(e) => setReviewText(e.target.value)}
            placeholder="What did you think? (optional)"
            className="log-textarea"
            rows={4}
          />
          <label className="log-checkbox">
            <input
              type="checkbox"
              checked={containsSpoilers}
              onChange={(e) => setContainsSpoilers(e.target.checked)}
            />
            Contains spoilers
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
      );
    }

    if (currentStep.key === "done") {
      return (
        <div className="log-summary">
          <p><strong>Rating:</strong> {rating}/10</p>
          <p><strong>Tags voted:</strong> {userVotes.length}</p>
          {reviewText ? <p><strong>Review:</strong> {reviewText.slice(0, 100)}...</p> : null}
        </div>
      );
    }

    // Tag steps
    const tags = getTagsForStep(currentStep.key);
    const suggested = getSuggestedTagsForStep(currentStep.key);

    return (
      <>
        {suggested.length > 0 ? (
          <div className="tag-suggestions">
            <div className="tag-suggestions-label">Suggested by readers</div>
            <div className="tag-list">
              {suggested.map((st) => {
                const officialTag = officialTags.find((t) => t.id === st.tag_id);
                if (!officialTag) return null;
                return (
                  <TagBadge
                    key={st.tag_id}
                    tag={officialTag}
                    count={st.vote_count}
                    voted={userVotes.includes(st.tag_id)}
                    onClick={() => toggleVote(st.tag_id)}
                  />
                );
              })}
            </div>
          </div>
        ) : null}
        <div className="tag-list">
          {tags.map((tag) => (
            <TagBadge
              key={tag.id}
              tag={tag}
              count={countMap[tag.id] || 0}
              voted={userVotes.includes(tag.id)}
              onClick={() => toggleVote(tag.id)}
            />
          ))}
        </div>
      </>
    );
  };

  return (
    <div className="log-step-by-step">
      <div className="step-indicator">
        {STEPS.map((s, i) => (
          <div
            key={s.key}
            className={`step-dot ${i === step ? "step-active" : ""} ${i < step ? "step-done" : ""}`}
          />
        ))}
      </div>

      <div className="step-content">
        <h3>{currentStep.title}</h3>
        <p className="step-desc">{currentStep.description}</p>
        {renderStep()}
      </div>

      <div className="step-nav">
        {step > 0 ? (
          <button type="button" className="btn btn-ghost" onClick={() => setStep(step - 1)}>
            Back
          </button>
        ) : <span />}
        {step < STEPS.length - 1 ? (
          <button
            type="button"
            className="btn btn-primary"
            onClick={() => setStep(step + 1)}
            disabled={step === 0 && !rating}
          >
            {step === 0 && !rating ? "Rate first" : "Next"}
          </button>
        ) : (
          <button
            type="button"
            className="btn btn-primary"
            onClick={handleFinish}
            disabled={!rating || submitting}
          >
            {submitting ? "Saving..." : "Save Log"}
          </button>
        )}
      </div>
    </div>
  );
}

export default LogStepByStep;
