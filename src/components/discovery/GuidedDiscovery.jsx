import { useEffect, useState } from "react";
import { getOfficialTags } from "../../services/tags";
import { discoverBooksByTags } from "../../services/discovery";
import BookGrid from "../books/BookGrid";
import { SkeletonBookGrid } from "../ui/Skeleton";

const STEP_CATEGORIES = [
  { key: "mood", label: "How do you want to feel?", category: "Mood", required: true },
  { key: "pacing", label: "What pacing are you in the mood for?", category: "Pacing", required: true },
  { key: "themes", label: "Any themes you love?", category: "Themes", required: true },
];

const OPTIONAL_CATEGORIES = [
  { key: "ending", label: "Ending preference?", category: "Ending" },
  { key: "difficulty", label: "Reading difficulty?", category: "Difficulty" },
  { key: "focus", label: "Story focus?", category: "Story Focus" },
];

function GuidedDiscovery() {
  const [allTags, setAllTags] = useState([]);
  const [step, setStep] = useState(0);
  const [selectedTags, setSelectedTags] = useState([]);
  const [showOptional, setShowOptional] = useState(false);
  const [optionalStep, setOptionalStep] = useState(0);
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [showResults, setShowResults] = useState(false);

  useEffect(() => {
    getOfficialTags().then(setAllTags);
  }, []);

  const steps = showOptional
    ? [...STEP_CATEGORIES, ...OPTIONAL_CATEGORIES]
    : STEP_CATEGORIES;

  const currentStepDef = showResults ? null : steps[step];
  const totalSteps = steps.length;

  const tagsForStep = currentStepDef
    ? allTags.filter((t) => t.category === currentStepDef.category)
    : [];

  const toggleTag = (tagId) => {
    setSelectedTags((prev) =>
      prev.includes(tagId) ? prev.filter((id) => id !== tagId) : [...prev, tagId]
    );
  };

  const fetchResults = async (tags) => {
    setLoading(true);
    setShowResults(true);
    try {
      const data = await discoverBooksByTags(tags);
      setResults(data);
    } catch {
      setResults([]);
    } finally {
      setLoading(false);
    }
  };

  const handleNext = () => {
    const nextStep = step + 1;
    // After pacing (step 1), ask about optional narrowing
    if (!showOptional && nextStep >= STEP_CATEGORIES.length) {
      // Show "narrow further" prompt
      setStep(nextStep);
      return;
    }
    if (nextStep >= totalSteps) {
      fetchResults(selectedTags);
      return;
    }
    setStep(nextStep);
  };

  const handleSkip = () => {
    fetchResults(selectedTags);
  };

  const handleStartOver = () => {
    setStep(0);
    setSelectedTags([]);
    setShowOptional(false);
    setOptionalStep(0);
    setShowResults(false);
    setResults([]);
  };

  // "Want to narrow further?" interstitial
  if (!showOptional && !showResults && step >= STEP_CATEGORIES.length) {
    return (
      <div className="discovery-step">
        <h2>Want to narrow it down?</h2>
        <p className="discovery-step-desc">
          You can optionally pick ending style, difficulty, or story focus.
        </p>
        <div className="discovery-nav">
          <button
            type="button"
            className="btn btn-ghost"
            onClick={() => { setStep(step - 1); }}
          >
            Back
          </button>
          <div style={{ display: "flex", gap: "0.5rem" }}>
            <button
              type="button"
              className="btn btn-ghost"
              onClick={() => fetchResults(selectedTags)}
            >
              Skip, show results
            </button>
            <button
              type="button"
              className="btn btn-primary"
              onClick={() => {
                setShowOptional(true);
                setStep(STEP_CATEGORIES.length);
              }}
            >
              Narrow further
            </button>
          </div>
        </div>
      </div>
    );
  }

  // Results
  if (showResults) {
    return (
      <div className="discovery-step">
        <h2>Your Discoveries</h2>
        <p className="discovery-step-desc">
          Found {results.length} book{results.length !== 1 ? "s" : ""} matching your vibes.
        </p>
        {loading ? (
          <SkeletonBookGrid count={8} />
        ) : results.length === 0 ? (
          <p className="muted-text">
            No books matched all your criteria yet. Try fewer tags or different combinations.
          </p>
        ) : (
          <BookGrid books={results} />
        )}
        <div style={{ marginTop: "1.5rem" }}>
          <button type="button" className="btn btn-ghost" onClick={handleStartOver}>
            Start over
          </button>
        </div>
      </div>
    );
  }

  // Tag selection step
  return (
    <div className="discovery-step">
      <h2>{currentStepDef.label}</h2>
      <p className="discovery-step-desc">
        Select one or more tags that match what you're looking for.
      </p>

      <div className="discovery-tag-pills">
        {tagsForStep.map((tag) => (
          <button
            key={tag.id}
            type="button"
            className={`discovery-tag-pill ${selectedTags.includes(tag.id) ? "selected" : ""}`}
            onClick={() => toggleTag(tag.id)}
          >
            {tag.label}
          </button>
        ))}
      </div>

      <div className="discovery-nav">
        <div>
          {step > 0 ? (
            <button
              type="button"
              className="btn btn-ghost"
              onClick={() => setStep(step - 1)}
            >
              Back
            </button>
          ) : null}
        </div>
        <div style={{ display: "flex", alignItems: "center", gap: "1rem" }}>
          <span className="discovery-step-counter">
            Step {step + 1} of {totalSteps}
          </span>
          {step >= STEP_CATEGORIES.length ? (
            <button type="button" className="btn btn-ghost btn-sm" onClick={handleSkip}>
              Skip
            </button>
          ) : null}
          <button
            type="button"
            className="btn btn-primary"
            onClick={handleNext}
            disabled={selectedTags.length === 0 && step < STEP_CATEGORIES.length}
          >
            {step + 1 >= totalSteps ? "Show Results" : "Next"}
          </button>
        </div>
      </div>
    </div>
  );
}

export default GuidedDiscovery;
