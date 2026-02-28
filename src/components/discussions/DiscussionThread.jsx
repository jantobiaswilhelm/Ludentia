import { useAuth } from "../../context/AuthContext";
import CommentForm from "./CommentForm";
import CommentCard from "./CommentCard";
import Spinner from "../ui/Spinner";

function DiscussionThread({ discussions, loading, hasMore, page, setPage, postComment, removeComment }) {
  const { user } = useAuth();

  return (
    <div className="discussion-thread">
      {user ? (
        <CommentForm
          onSubmit={({ commentText, containsSpoilers }) =>
            postComment({ commentText, containsSpoilers, parentId: null })
          }
        />
      ) : (
        <p className="muted-text">Log in to join the discussion.</p>
      )}

      {discussions.total > 0 ? (
        <p className="discussion-count">{discussions.total} comment{discussions.total !== 1 ? "s" : ""}</p>
      ) : null}

      {loading ? (
        <Spinner size={24} />
      ) : discussions.comments.length === 0 ? (
        <p className="muted-text">No comments yet. Start the conversation!</p>
      ) : (
        <>
          {discussions.comments.map((comment) => (
            <CommentCard
              key={comment.id}
              comment={comment}
              currentUserId={user?.id}
              onReply={user ? postComment : undefined}
              onDelete={user ? removeComment : undefined}
            />
          ))}

          {hasMore ? (
            <button
              type="button"
              className="btn btn-ghost"
              onClick={() => setPage(page + 1)}
            >
              Load more comments
            </button>
          ) : null}
        </>
      )}
    </div>
  );
}

export default DiscussionThread;
