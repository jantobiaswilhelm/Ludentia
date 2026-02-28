import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { getProfile, updateProfile } from "../services/auth";
import { getUserShelves } from "../services/bookshelves";
import { getUserLogs } from "../services/bookLog";
import { getFollowers, getFollowing, followUser, unfollowUser, isFollowing } from "../services/follows";
import EmptyState from "../components/ui/EmptyState";
import { Skeleton, SkeletonText } from "../components/ui/Skeleton";
import { getUserLists } from "../services/lists";
import { VISIBILITY_OPTIONS } from "../utils/constants";
import { useReadingGoal } from "../hooks/useReadingGoals";
import { useReadingStreak } from "../hooks/useReadingStreak";
import GoalProgress from "../components/goals/GoalProgress";
import SetGoalModal from "../components/goals/SetGoalModal";
import StreakBadge from "../components/streaks/StreakBadge";
import { useDocumentTitle } from "../hooks/useDocumentTitle";

function ProfileSkeleton() {
  return (
    <div className="profile-page">
      <div className="profile-header">
        <div className="profile-avatar">
          <Skeleton width="80px" height="80px" style={{ borderRadius: "50%" }} />
        </div>
        <div className="profile-info">
          <Skeleton height="1.8rem" width="180px" />
          <Skeleton height="1rem" width="120px" />
          <SkeletonText lines={2} />
        </div>
      </div>
    </div>
  );
}

function ProfilePage() {
  const { userId } = useParams();
  const { user, profile: myProfile, refreshProfile } = useAuth();
  const isOwnProfile = !userId || userId === user?.id;
  const targetId = isOwnProfile ? user?.id : userId;

  const [profile, setProfile] = useState(null);
  const [shelves, setShelves] = useState([]);
  const [logs, setLogs] = useState([]);
  const [followers, setFollowers] = useState([]);
  const [following, setFollowing] = useState([]);
  const [iFollow, setIFollow] = useState(false);
  const [loading, setLoading] = useState(true);
  const [editing, setEditing] = useState(false);
  const [editForm, setEditForm] = useState({});
  const [showGoalModal, setShowGoalModal] = useState(false);

  const { goalData, loading: goalLoading, setGoal, removeGoal } = useReadingGoal(targetId);
  const { streak, loading: streakLoading } = useReadingStreak(targetId);
  useDocumentTitle(profile?.display_name || profile?.username || "Profile");

  useEffect(() => {
    if (!targetId) {
      setLoading(false);
      return;
    }
    setLoading(true);
    Promise.all([
      isOwnProfile ? Promise.resolve(myProfile) : getProfile(targetId),
      getUserShelves(targetId).catch(() => []),
      getUserLogs(targetId).catch(() => []),
      getFollowers(targetId).catch(() => []),
      getFollowing(targetId).catch(() => []),
      user && !isOwnProfile ? isFollowing(user.id, targetId) : Promise.resolve(false),
    ]).then(([p, s, l, fr, fg, follows]) => {
      setProfile(p);
      setShelves(s);
      setLogs(l);
      setFollowers(fr);
      setFollowing(fg);
      setIFollow(follows);
      setLoading(false);
    });
  }, [targetId, isOwnProfile, myProfile, user]);

  const handleFollow = async () => {
    if (!user) return;
    if (iFollow) {
      await unfollowUser(user.id, targetId);
    } else {
      await followUser(user.id, targetId);
    }
    setIFollow(!iFollow);
    setFollowers(await getFollowers(targetId));
  };

  const handleSaveProfile = async () => {
    await updateProfile(user.id, editForm);
    refreshProfile();
    setProfile((prev) => ({ ...prev, ...editForm }));
    setEditing(false);
  };

  if (loading) return <ProfileSkeleton />;

  if (!profile) {
    return <EmptyState title="Profile not found" />;
  }

  const readCount = shelves.filter((s) => s.shelf === "read").length;
  const readingCount = shelves.filter((s) => s.shelf === "reading").length;
  const wantCount = shelves.filter((s) => s.shelf === "want_to_read").length;
  const avgRating =
    logs.length > 0
      ? (logs.reduce((sum, l) => sum + (l.rating || 0), 0) / logs.filter((l) => l.rating).length).toFixed(1)
      : "—";

  const genres = profile.favorite_genres || [];

  return (
    <div className="profile-page">
      <div className="profile-header">
        <div className="profile-avatar">
          {profile.avatar_url ? (
            <img src={profile.avatar_url} alt="" />
          ) : (
            <div className="avatar-placeholder">{(profile.display_name || profile.username || "?")[0].toUpperCase()}</div>
          )}
        </div>
        <div className="profile-info">
          <h1>{profile.display_name || profile.username}</h1>
          <p className="profile-username">@{profile.username}</p>

          {profile.bio ? <p className="profile-bio">{profile.bio}</p> : null}
          {profile.website ? (
            <a
              href={profile.website.startsWith("http") ? profile.website : `https://${profile.website}`}
              target="_blank"
              rel="noopener noreferrer"
              className="profile-website"
            >
              {profile.website.replace(/^https?:\/\//, "")}
            </a>
          ) : null}

          {genres.length > 0 ? (
            <div className="profile-genres">
              {genres.map((g) => (
                <span key={g} className="genre-badge">{g}</span>
              ))}
            </div>
          ) : null}

          <div className="profile-stats">
            <span><strong>{readCount}</strong> read</span>
            <span><strong>{readingCount}</strong> reading</span>
            <span><strong>{wantCount}</strong> want to read</span>
            <span><strong>{logs.length}</strong> logs</span>
            <span>Avg rating: <strong>{avgRating}</strong></span>
          </div>
          <div className="profile-follow-stats">
            <Link to={`/profile/${targetId}/followers`} className="profile-follow-link">
              <strong>{followers.length}</strong> followers
            </Link>
            <Link to={`/profile/${targetId}/following`} className="profile-follow-link">
              <strong>{following.length}</strong> following
            </Link>
          </div>

          {!streakLoading && streak ? <StreakBadge streak={streak} /> : null}
        </div>
        <div className="profile-actions">
          {!isOwnProfile && user ? (
            <button
              type="button"
              className={`btn ${iFollow ? "btn-ghost" : "btn-primary"}`}
              onClick={handleFollow}
            >
              {iFollow ? "Unfollow" : "Follow"}
            </button>
          ) : null}
          {isOwnProfile ? (
            <>
              <button
                type="button"
                className="btn btn-ghost"
                onClick={() => {
                  setEditForm({
                    display_name: profile.display_name || "",
                    bio: profile.bio || "",
                    website: profile.website || "",
                    favorite_genres: (profile.favorite_genres || []).join(", "),
                    profile_visibility: profile.profile_visibility,
                    diary_visibility: profile.diary_visibility,
                    preferred_log_mode: profile.preferred_log_mode,
                  });
                  setEditing(!editing);
                }}
              >
                {editing ? "Cancel" : "Edit Profile"}
              </button>
              <Link to={`/profile/${targetId}/stats`} className="btn btn-ghost">
                View Stats
              </Link>
              <Link to={`/profile/${targetId}/year-in-review`} className="btn btn-ghost">
                Year in Review
              </Link>
              <button type="button" className="btn btn-ghost" onClick={() => setShowGoalModal(true)}>
                {goalData?.goal ? "Edit Goal" : "Set Goal"}
              </button>
              <Link to="/settings" className="btn btn-ghost">
                Settings
              </Link>
            </>
          ) : (
            <>
              <Link to={`/profile/${targetId}/stats`} className="btn btn-ghost">
                View Stats
              </Link>
              <Link to={`/profile/${targetId}/year-in-review`} className="btn btn-ghost">
                Year in Review
              </Link>
            </>
          )}
        </div>
      </div>

      {editing ? (
        <div className="profile-edit-section">
          <label className="auth-label">
            Display Name
            <input
              type="text"
              value={editForm.display_name}
              onChange={(e) => setEditForm({ ...editForm, display_name: e.target.value })}
              className="auth-input"
            />
          </label>
          <label className="auth-label">
            Bio
            <textarea
              value={editForm.bio}
              onChange={(e) => setEditForm({ ...editForm, bio: e.target.value })}
              className="auth-input"
              rows={3}
              placeholder="Tell others about yourself..."
            />
          </label>
          <label className="auth-label">
            Website
            <input
              type="url"
              value={editForm.website}
              onChange={(e) => setEditForm({ ...editForm, website: e.target.value })}
              className="auth-input"
              placeholder="https://yoursite.com"
            />
          </label>
          <label className="auth-label">
            Favorite Genres (comma-separated)
            <input
              type="text"
              value={editForm.favorite_genres}
              onChange={(e) => setEditForm({ ...editForm, favorite_genres: e.target.value })}
              className="auth-input"
              placeholder="Fantasy, Sci-Fi, Mystery"
            />
          </label>
          <label className="auth-label">
            Profile Visibility
            <select
              value={editForm.profile_visibility}
              onChange={(e) => setEditForm({ ...editForm, profile_visibility: e.target.value })}
              className="log-select"
            >
              {VISIBILITY_OPTIONS.map((v) => (
                <option key={v.value} value={v.value}>{v.label}</option>
              ))}
            </select>
          </label>
          <label className="auth-label">
            Diary Visibility
            <select
              value={editForm.diary_visibility}
              onChange={(e) => setEditForm({ ...editForm, diary_visibility: e.target.value })}
              className="log-select"
            >
              {VISIBILITY_OPTIONS.map((v) => (
                <option key={v.value} value={v.value}>{v.label}</option>
              ))}
            </select>
          </label>
          <label className="auth-label">
            Preferred Log Mode
            <select
              value={editForm.preferred_log_mode}
              onChange={(e) => setEditForm({ ...editForm, preferred_log_mode: e.target.value })}
              className="log-select"
            >
              <option value="all_in_one">All-in-One</option>
              <option value="step_by_step">Step-by-Step</option>
            </select>
          </label>
          <button
            type="button"
            className="btn btn-primary"
            onClick={() => {
              const genresStr = editForm.favorite_genres;
              const genresArr = genresStr
                ? genresStr.split(",").map((g) => g.trim()).filter(Boolean)
                : [];
              const { favorite_genres: _, ...rest } = editForm;
              setEditForm({ ...rest, favorite_genres: genresArr });
              updateProfile(user.id, { ...rest, favorite_genres: genresArr }).then(() => {
                refreshProfile();
                setProfile((prev) => ({ ...prev, ...rest, favorite_genres: genresArr }));
                setEditing(false);
              });
            }}
          >
            Save Changes
          </button>
        </div>
      ) : null}

      {/* Goal progress */}
      {!goalLoading && goalData?.goal ? (
        <section className="profile-section">
          <h2>Reading Goal {goalData.goal.year}</h2>
          <GoalProgress goalData={goalData} />
        </section>
      ) : null}

      {isOwnProfile ? (
        <SetGoalModal
          open={showGoalModal}
          onClose={() => setShowGoalModal(false)}
          currentTarget={goalData?.goal?.target_books}
          onSetGoal={setGoal}
          onRemoveGoal={removeGoal}
        />
      ) : null}

      {/* Lists preview */}
      <ListsPreview userId={targetId} isOwnProfile={isOwnProfile} />

      {/* Recent reads */}
      {logs.length > 0 ? (
        <section className="profile-section">
          <h2>Recent Reads</h2>
          <div className="profile-recent-grid">
            {logs.slice(0, 8).map((log) => (
              <Link to={`/book/${log.book_id}`} key={log.id} className="profile-recent-item">
                {log.books?.cover_url ? (
                  <img src={log.books.cover_url} alt="" className="profile-recent-cover" referrerPolicy="no-referrer" />
                ) : null}
                <span className="profile-recent-rating">{log.rating}/10</span>
              </Link>
            ))}
          </div>
        </section>
      ) : null}
    </div>
  );
}

function ListsPreview({ userId, isOwnProfile }) {
  const [lists, setLists] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!userId) return;
    getUserLists(userId)
      .then((data) => setLists(data))
      .catch(() => setLists([]))
      .finally(() => setLoading(false));
  }, [userId]);

  if (loading || lists.length === 0) return null;

  return (
    <section className="profile-section">
      <div className="section-header-row">
        <h2>Lists</h2>
        <Link to={`/profile/${userId}/lists`} className="btn btn-ghost btn-sm">See all</Link>
      </div>
      <div className="lists-preview-grid">
        {lists.slice(0, 4).map((list) => (
          <Link to={`/lists/${list.id}`} key={list.id} className="list-card-mini">
            <span className="list-card-mini-title">{list.title}</span>
            <span className="list-card-mini-count">{list.item_count || 0} books</span>
          </Link>
        ))}
      </div>
    </section>
  );
}

export default ProfilePage;
