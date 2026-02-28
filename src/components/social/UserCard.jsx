import { Link } from "react-router-dom";
import { truncate } from "../../utils/formatters";

function UserCard({ user: profile, showFollowButton, isFollowing, onToggleFollow }) {
  if (!profile) return null;

  return (
    <div className="user-card">
      <Link to={`/profile/${profile.id}`} className="user-card-main">
        <div className="user-card-avatar">
          {profile.avatar_url ? (
            <img src={profile.avatar_url} alt="" />
          ) : (
            <div className="avatar-placeholder avatar-sm">
              {(profile.display_name || profile.username || "?")[0].toUpperCase()}
            </div>
          )}
        </div>
        <div className="user-card-info">
          <span className="user-card-name">{profile.display_name || profile.username}</span>
          <span className="user-card-username">@{profile.username}</span>
          {profile.bio ? <p className="user-card-bio">{truncate(profile.bio, 80)}</p> : null}
        </div>
      </Link>
      {showFollowButton ? (
        <div className="user-card-actions">
          <button
            type="button"
            className={`btn btn-sm ${isFollowing ? "btn-ghost" : "btn-primary"}`}
            onClick={onToggleFollow}
          >
            {isFollowing ? "Unfollow" : "Follow"}
          </button>
        </div>
      ) : null}
    </div>
  );
}

export default UserCard;
