import { useState } from "react";
import TagBadge from "./TagBadge";

function TagSection({ tagCounts, officialTags, userVotes, onToggleVote, compact }) {
  const [showAll, setShowAll] = useState(false);

  // Group official tags by category
  const categories = {};
  for (const tag of officialTags) {
    if (!categories[tag.category]) categories[tag.category] = [];
    categories[tag.category].push(tag);
  }

  // Build count lookup
  const countMap = {};
  for (const tc of tagCounts) {
    countMap[tc.tag_id] = tc.vote_count;
  }

  // Community tags (non-official that have votes)
  const officialIds = new Set(officialTags.map((t) => t.id));
  const communityTags = tagCounts
    .filter((tc) => !officialIds.has(tc.tag_id) && tc.tag_definitions)
    .map((tc) => ({ ...tc.tag_definitions, vote_count: tc.vote_count }));

  const visibleCommunity = showAll ? communityTags : communityTags.slice(0, 6);

  return (
    <div className={`tag-section ${compact ? "tag-section-compact" : ""}`}>
      {Object.entries(categories).map(([category, tags]) => {
        const hasCounts = tags.some((t) => countMap[t.id] > 0);
        if (compact && !hasCounts) return null;
        return (
          <div key={category} className="tag-category">
            <h4 className="tag-category-label">{category}</h4>
            <div className="tag-list">
              {tags.map((tag) => (
                <TagBadge
                  key={tag.id}
                  tag={tag}
                  count={countMap[tag.id] || 0}
                  voted={userVotes.includes(tag.id)}
                  onClick={() => onToggleVote(tag.id)}
                  showCount={!compact || countMap[tag.id] > 0}
                />
              ))}
            </div>
          </div>
        );
      })}

      {visibleCommunity.length > 0 ? (
        <div className="tag-category">
          <h4 className="tag-category-label">Community Tags</h4>
          <div className="tag-list">
            {visibleCommunity.map((tag) => (
              <TagBadge
                key={tag.id}
                tag={tag}
                count={tag.vote_count}
                voted={userVotes.includes(tag.id)}
                onClick={() => onToggleVote(tag.id)}
              />
            ))}
          </div>
          {communityTags.length > 6 && !showAll ? (
            <button
              type="button"
              className="btn btn-ghost btn-sm"
              onClick={() => setShowAll(true)}
            >
              Show {communityTags.length - 6} more
            </button>
          ) : null}
        </div>
      ) : null}
    </div>
  );
}

export default TagSection;
