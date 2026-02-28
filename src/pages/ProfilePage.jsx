import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { getProfile, updateProfile } from "../services/auth";
import { getUserShelves } from "../services/bookshelves";
import { getUserLogs } from "../services/bookLog";
import { getFollowers, getFollowing, followUser, unfollowUser, isFollowing } from "../services/follows";
import EmptyState from "../components/ui/EmptyState";
import Spinner from "../components/ui/Spinner";
import { VISIBILITY_OPTIONS } from "../utils/constants";

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
    setEditing(false);
  };

  if (loading) {
    return (
      <div className="page-center">
        <Spinner size={40} />
      </div>
    );
  }

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
          <div className="profile-stats">
            <span><strong>{readCount}</strong> read</span>
            <span><strong>{readingCount}</strong> reading</span>
            <span><strong>{wantCount}</strong> want to read</span>
            <span><strong>{logs.length}</strong> logs</span>
            <span>Avg rating: <strong>{avgRating}</strong></span>
          </div>
          <div className="profile-follow-stats">
            <span><strong>{followers.length}</strong> followers</span>
            <span><strong>{following.length}</strong> following</span>
          </div>
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
            <button
              type="button"
              className="btn btn-ghost"
              onClick={() => {
                setEditForm({
                  display_name: profile.display_name || "",
                  profile_visibility: profile.profile_visibility,
                  diary_visibility: profile.diary_visibility,
                  preferred_log_mode: profile.preferred_log_mode,
                });
                setEditing(!editing);
              }}
            >
              {editing ? "Cancel" : "Edit Profile"}
            </button>
          ) : null}
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
          <button type="button" className="btn btn-primary" onClick={handleSaveProfile}>
            Save Changes
          </button>
        </div>
      ) : null}

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

export default ProfilePage;
