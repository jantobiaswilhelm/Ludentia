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
  const [menuOpen, setMenuOpen] = useState(false);

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

        <button
          className="nav-hamburger"
          onClick={() => setMenuOpen(!menuOpen)}
          aria-label="Toggle navigation"
        >
          <span />
          <span />
          <span />
        </button>

        <nav className={`nav-links ${menuOpen ? "nav-open" : ""}`} aria-label="Main">
          <NavLink to="/" end onClick={() => setMenuOpen(false)}>Discover</NavLink>
          <NavLink to="/browse" onClick={() => setMenuOpen(false)}>Browse</NavLink>
          {user ? (
            <>
              <NavLink to="/shelf" onClick={() => setMenuOpen(false)}>My Shelf</NavLink>
              <NavLink to="/diary" onClick={() => setMenuOpen(false)}>Diary</NavLink>
              <NavLink to="/recommendations" onClick={() => setMenuOpen(false)}>For You</NavLink>
              <NavLink to="/profile" onClick={() => setMenuOpen(false)}>
                {profile?.display_name || profile?.username || "Profile"}
              </NavLink>
              <button type="button" className="nav-sign-out" onClick={handleSignOut}>
                Sign Out
              </button>
            </>
          ) : (
            <NavLink to="/login" onClick={() => setMenuOpen(false)}>Sign In</NavLink>
          )}
          <button
            type="button"
            className="theme-toggle"
            onClick={toggleTheme}
            aria-label={`Switch to ${theme === "dark" ? "light" : "dark"} mode`}
          >
            {theme === "dark" ? "☀️" : "🌙"}
          </button>
        </nav>
      </div>
    </header>
  );
}

export default Navbar;
