import { TAG_COLORS } from "../../utils/constants";

function TagBadge({ tag, count, voted, onClick, showCount = true }) {
  const colors = TAG_COLORS[tag.color] || TAG_COLORS.gray;

  return (
    <button
      type="button"
      className={`tag-badge ${voted ? "tag-voted" : ""} ${tag.is_official ? "tag-official" : ""}`}
      style={{
        "--tag-bg": voted ? colors.border : colors.bg,
        "--tag-text": colors.text,
        "--tag-border": colors.border,
      }}
      onClick={onClick}
      title={tag.description || tag.label}
    >
      <span className="tag-label">{tag.label}</span>
      {showCount && count > 0 ? <span className="tag-count">{count}</span> : null}
    </button>
  );
}

export default TagBadge;
