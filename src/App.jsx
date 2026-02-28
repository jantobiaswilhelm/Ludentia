import { Navigate, Route, Routes } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import { ToastProvider } from "./context/ToastContext";
import Navbar from "./components/layout/Navbar";
import BottomTabBar from "./components/layout/BottomTabBar";
import ErrorBoundary from "./components/ui/ErrorBoundary";
import HomePage from "./pages/HomePage";
import LoginPage from "./pages/LoginPage";
import SignUpPage from "./pages/SignUpPage";
import BookDetailPage from "./pages/BookDetailPage";
import MyShelfPage from "./pages/MyShelfPage";
import DiaryPage from "./pages/DiaryPage";
import BrowsePage from "./pages/BrowsePage";
import RecommendationsPage from "./pages/RecommendationsPage";
import ProfilePage from "./pages/ProfilePage";
import TagPage from "./pages/TagPage";

function App() {
  return (
    <AuthProvider>
      <ToastProvider>
        <div className="app-shell">
          <Navbar />
          <main className="page-wrap">
            <ErrorBoundary>
              <Routes>
                <Route path="/" element={<HomePage />} />
                <Route path="/login" element={<LoginPage />} />
                <Route path="/signup" element={<SignUpPage />} />
                <Route path="/book/:id/*" element={<BookDetailPage />} />
                <Route path="/shelf" element={<MyShelfPage />} />
                <Route path="/diary" element={<DiaryPage />} />
                <Route path="/browse" element={<BrowsePage />} />
                <Route path="/recommendations" element={<RecommendationsPage />} />
                <Route path="/profile" element={<ProfilePage />} />
                <Route path="/profile/:userId" element={<ProfilePage />} />
                <Route path="/tag/:slug" element={<TagPage />} />
                <Route path="*" element={<Navigate to="/" replace />} />
              </Routes>
            </ErrorBoundary>
          </main>
          <BottomTabBar />
        </div>
      </ToastProvider>
    </AuthProvider>
  );
}

export default App;
