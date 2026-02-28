import { NavLink } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";

function BottomTabBar() {
  const { user } = useAuth();

  return (
    <nav className="bottom-tab-bar" aria-label="Mobile navigation">
      <div className="bottom-tab-inner">
        <NavLink to="/" end className={({ isActive }) => `bottom-tab ${isActive ? "tab-active" : ""}`}>
          <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
            <path d="M3 10.5L10 4l7 6.5" />
            <path d="M5 9.5V16a1 1 0 001 1h3v-4h2v4h3a1 1 0 001-1V9.5" />
          </svg>
          <span>Discover</span>
        </NavLink>

        {user ? (
          <NavLink to="/feed" className={({ isActive }) => `bottom-tab ${isActive ? "tab-active" : ""}`}>
            <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <path d="M3 4h14M3 8h10M3 12h14M3 16h8" />
            </svg>
            <span>Feed</span>
          </NavLink>
        ) : (
          <NavLink to="/browse" className={({ isActive }) => `bottom-tab ${isActive ? "tab-active" : ""}`}>
            <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="8.5" cy="8.5" r="5.5" />
              <path d="M12.5 12.5L17 17" />
            </svg>
            <span>Browse</span>
          </NavLink>
        )}

        {user ? (
          <NavLink to="/shelf" className={({ isActive }) => `bottom-tab ${isActive ? "tab-active" : ""}`}>
            <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <path d="M3 3h4v14H3zM8 3h4v14H8zM13 5l4-1v13l-4 1z" />
            </svg>
            <span>Shelf</span>
          </NavLink>
        ) : (
          <NavLink to="/login" className={({ isActive }) => `bottom-tab ${isActive ? "tab-active" : ""}`}>
            <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <path d="M3 3h4v14H3zM8 3h4v14H8zM13 5l4-1v13l-4 1z" />
            </svg>
            <span>Sign In</span>
          </NavLink>
        )}

        {user ? (
          <NavLink to="/profile" className={({ isActive }) => `bottom-tab ${isActive ? "tab-active" : ""}`}>
            <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="10" cy="7" r="3.5" />
              <path d="M3.5 17.5c0-3.5 3-5.5 6.5-5.5s6.5 2 6.5 5.5" />
            </svg>
            <span>Profile</span>
          </NavLink>
        ) : (
          <NavLink to="/login" className={({ isActive }) => `bottom-tab ${isActive ? "tab-active" : ""}`}>
            <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="10" cy="7" r="3.5" />
              <path d="M3.5 17.5c0-3.5 3-5.5 6.5-5.5s6.5 2 6.5 5.5" />
            </svg>
            <span>Sign In</span>
          </NavLink>
        )}
      </div>
    </nav>
  );
}

export default BottomTabBar;
