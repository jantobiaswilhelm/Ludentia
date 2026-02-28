import { Link } from "react-router-dom";
import { TAG_COLORS } from "../../utils/constants";

function TagBadge({ tag, count, voted, onClick, showCount = true, linkTo }) {
  const colors = TAG_COLORS[tag.color] || TAG_COLORS.gray;

  const style = {
    "--tag-bg": voted ? colors.border : colors.bg,
    "--tag-text": colors.text,
    "--tag-border": colors.border,
  };

  const className = `tag-badge ${voted ? "tag-voted" : ""} ${tag.is_official ? "tag-official" : ""}`;

  const content = (
    <>
      <span className="tag-label">{tag.label}</span>
      {showCount && count > 0 ? <span className="tag-count">{count}</span> : null}
    </>
  );

  if (linkTo) {
    return (
      <Link
        to={linkTo}
        className={className}
        style={style}
        title={tag.description || tag.label}
      >
        {content}
      </Link>
    );
  }

  return (
    <button
      type="button"
      className={className}
      style={style}
      onClick={onClick}
      title={tag.description || tag.label}
    >
      {content}
    </button>
  );
}

export default TagBadge;
