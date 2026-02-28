import { useState } from "react";
import { Link } from "react-router-dom";
import { formatDate } from "../../utils/formatters";
import CommentForm from "./CommentForm";

function CommentCard({ comment, currentUserId, onReply, onDelete, isReply }) {
  const [showSpoiler, setShowSpoiler] = useState(false);
  const [replying, setReplying] = useState(false);

  const isOwn = currentUserId === comment.user_id;
  const displayName = comment.display_name || comment.username || "Anonymous";

  const handleReply = async (data) => {
    await onReply({ ...data, parentId: comment.id });
    setReplying(false);
  };

  return (
    <div className={`comment-card ${isReply ? "comment-reply" : ""}`}>
      <div className="comment-header">
        <Link to={`/profile/${comment.user_id}`} className="comment-author">
          {comment.avatar_url ? (
            <img src={comment.avatar_url} alt="" className="comment-avatar" referrerPolicy="no-referrer" />
          ) : (
            <span className="comment-avatar-placeholder">{displayName[0].toUpperCase()}</span>
          )}
          <span>{displayName}</span>
        </Link>
        <span className="comment-meta">{formatDate(comment.created_at)}</span>
      </div>

      {comment.contains_spoilers && !showSpoiler ? (
        <div className="comment-body">
          <button
            type="button"
            className="spoiler-reveal-btn"
            onClick={() => setShowSpoiler(true)}
          >
            This comment contains spoilers. Click to reveal.
          </button>
        </div>
      ) : (
        <div className="comment-body">{comment.comment_text}</div>
      )}

      <div className="comment-actions">
        {!isReply && onReply ? (
          <button
            type="button"
            className="btn btn-ghost btn-sm"
            onClick={() => setReplying(!replying)}
          >
            {replying ? "Cancel" : "Reply"}
          </button>
        ) : null}
        {isOwn && onDelete ? (
          <button
            type="button"
            className="btn btn-ghost btn-sm"
            onClick={() => onDelete(comment.id)}
          >
            Delete
          </button>
        ) : null}
      </div>

      {replying ? (
        <CommentForm onSubmit={handleReply} compact placeholder="Write a reply..." />
      ) : null}

      {/* Nested replies (1 level) */}
      {!isReply && comment.replies?.length > 0 ? (
        <div className="comment-replies">
          {comment.replies.map((reply) => (
            <CommentCard
              key={reply.id}
              comment={reply}
              currentUserId={currentUserId}
              onDelete={onDelete}
              isReply
            />
          ))}
        </div>
      ) : null}
    </div>
  );
}

export default CommentCard;
