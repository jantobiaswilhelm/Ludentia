import { useState, useEffect } from "react";
import { Link, NavLink, useNavigate } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";
import { signOut } from "../../services/auth";

function getInitialTheme() {
  const stored = localStorage.getItem("ludentia-theme");
  if (stored) return stored;
  return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
}

function Navbar() {
  const { user, profile } = useAuth();
  const navigate = useNavigate();
  const [theme, setTheme] = useState(getInitialTheme);

  useEffect(() => {
    document.documentElement.setAttribute("data-theme", theme);
    localStorage.setItem("ludentia-theme", theme);
  }, [theme]);

  const toggleTheme = () => setTheme((t) => (t === "dark" ? "light" : "dark"));

  const handleSignOut = async () => {
    await signOut();
    navigate("/");
  };

  return (
    <header className="site-nav">
      <div className="nav-inner">
        <Link to="/" className="brand-mark">Ludentia</Link>

        <nav className="nav-links" aria-label="Main">
          <NavLink to="/" end>Discover</NavLink>
          <NavLink to="/browse">Browse</NavLink>
          {user ? (
            <>
              <NavLink to="/shelf">My Shelf</NavLink>
              <NavLink to="/diary">Diary</NavLink>
              <NavLink to="/recommendations">For You</NavLink>
              <NavLink to="/profile">
                {profile?.display_name || profile?.username || "Profile"}
              </NavLink>
              <button type="button" className="nav-sign-out" onClick={handleSignOut}>
                Sign Out
              </button>
            </>
          ) : (
            <NavLink to="/login">Sign In</NavLink>
          )}
          <button
            type="button"
            className="theme-toggle"
            onClick={toggleTheme}
            aria-label={`Switch to ${theme === "dark" ? "light" : "dark"} mode`}
          >
            {theme === "dark" ? "\u2600\uFE0F" : "\uD83C\uDF19"}
          </button>
        </nav>

        {/* Mobile: only show theme toggle beside logo (nav handled by bottom tab bar) */}
        <button
          type="button"
          className="theme-toggle nav-mobile-theme"
          onClick={toggleTheme}
          aria-label={`Switch to ${theme === "dark" ? "light" : "dark"} mode`}
        >
          {theme === "dark" ? "\u2600\uFE0F" : "\uD83C\uDF19"}
        </button>
      </div>
    </header>
  );
}

export default Navbar;
