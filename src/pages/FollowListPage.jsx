import { useEffect, useState } from "react";
import { useParams, useLocation, Link } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { getProfile } from "../services/auth";
import { getFollowers, getFollowing, followUser, unfollowUser, isFollowing as checkIsFollowing } from "../services/follows";
import UserCard from "../components/social/UserCard";
import EmptyState from "../components/ui/EmptyState";
import { Skeleton } from "../components/ui/Skeleton";
import { useDocumentTitle } from "../hooks/useDocumentTitle";

function FollowListPage() {
  const { userId } = useParams();
  const { pathname } = useLocation();
  const { user } = useAuth();
  const mode = pathname.endsWith("/following") ? "following" : "followers";

  const [profile, setProfile] = useState(null);
  const [list, setList] = useState([]);
  const [followStates, setFollowStates] = useState({});
  const [loading, setLoading] = useState(true);
  const [offset, setOffset] = useState(0);
  const [hasMore, setHasMore] = useState(true);
  const PAGE_SIZE = 30;
  useDocumentTitle("Connections");

  useEffect(() => {
    setLoading(true);
    setList([]);
    setOffset(0);
    setHasMore(true);

    const fetchFn = mode === "followers" ? getFollowers : getFollowing;

    Promise.all([
      getProfile(userId),
      fetchFn(userId, { limit: PAGE_SIZE, offset: 0 }),
    ]).then(async ([p, users]) => {
      setProfile(p);
      setList(users);
      setHasMore(users.length >= PAGE_SIZE);

      if (user) {
        const states = {};
        await Promise.all(
          users.map(async (u) => {
            if (u.id === user.id) return;
            states[u.id] = await checkIsFollowing(user.id, u.id);
          })
        );
        setFollowStates(states);
      }
      setLoading(false);
    });
  }, [userId, mode, user]);

  const loadMore = async () => {
    const newOffset = offset + PAGE_SIZE;
    const fetchFn = mode === "followers" ? getFollowers : getFollowing;
    const more = await fetchFn(userId, { limit: PAGE_SIZE, offset: newOffset });
    setList((prev) => [...prev, ...more]);
    setOffset(newOffset);
    setHasMore(more.length >= PAGE_SIZE);

    if (user) {
      const states = { ...followStates };
      await Promise.all(
        more.map(async (u) => {
          if (u.id === user.id) return;
          states[u.id] = await checkIsFollowing(user.id, u.id);
        })
      );
      setFollowStates(states);
    }
  };

  const handleToggleFollow = async (targetUserId) => {
    if (!user) return;
    if (followStates[targetUserId]) {
      await unfollowUser(user.id, targetUserId);
    } else {
      await followUser(user.id, targetUserId);
    }
    setFollowStates((prev) => ({ ...prev, [targetUserId]: !prev[targetUserId] }));
  };

  if (loading) {
    return (
      <div className="follow-list-page">
        <Skeleton height="1.5rem" width="200px" />
        <div className="follow-list">
          {Array.from({ length: 5 }, (_, i) => (
            <div key={i} className="user-card">
              <Skeleton height="48px" width="48px" style={{ borderRadius: "50%" }} />
              <div style={{ flex: 1, display: "grid", gap: "0.25rem" }}>
                <Skeleton height="1rem" width="150px" />
                <Skeleton height="0.8rem" width="100px" />
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="follow-list-page">
      <div className="follow-list-header">
        <Link to={`/profile/${userId}`} className="back-link">&larr; {profile?.display_name || profile?.username}</Link>
        <h1>{mode === "followers" ? "Followers" : "Following"}</h1>
      </div>

      {list.length === 0 ? (
        <EmptyState
          title={mode === "followers" ? "No followers yet" : "Not following anyone"}
          description={mode === "followers" ? "When people follow this user, they'll appear here." : "When this user follows people, they'll appear here."}
        />
      ) : (
        <div className="follow-list">
          {list.map((u) => (
            <UserCard
              key={u.id}
              user={u}
              showFollowButton={user && u.id !== user.id}
              isFollowing={followStates[u.id]}
              onToggleFollow={() => handleToggleFollow(u.id)}
            />
          ))}
          {hasMore ? (
            <button type="button" className="btn btn-ghost" onClick={loadMore}>
              Load more
            </button>
          ) : null}
        </div>
      )}
    </div>
  );
}

export default FollowListPage;
