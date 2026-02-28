import { lazy, Suspense } from "react";
import { Navigate, Route, Routes } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import { ToastProvider } from "./context/ToastContext";
import Navbar from "./components/layout/Navbar";
import BottomTabBar from "./components/layout/BottomTabBar";
import ErrorBoundary from "./components/ui/ErrorBoundary";
import Spinner from "./components/ui/Spinner";

const HomePage = lazy(() => import("./pages/HomePage"));
const LoginPage = lazy(() => import("./pages/LoginPage"));
const SignUpPage = lazy(() => import("./pages/SignUpPage"));
const BookDetailPage = lazy(() => import("./pages/BookDetailPage"));
const MyShelfPage = lazy(() => import("./pages/MyShelfPage"));
const DiaryPage = lazy(() => import("./pages/DiaryPage"));
const BrowsePage = lazy(() => import("./pages/BrowsePage"));
const RecommendationsPage = lazy(() => import("./pages/RecommendationsPage"));
const ProfilePage = lazy(() => import("./pages/ProfilePage"));
const TagPage = lazy(() => import("./pages/TagPage"));
const FeedPage = lazy(() => import("./pages/FeedPage"));
const FollowListPage = lazy(() => import("./pages/FollowListPage"));
const SearchPage = lazy(() => import("./pages/SearchPage"));
const StatsPage = lazy(() => import("./pages/StatsPage"));
const ListsPage = lazy(() => import("./pages/ListsPage"));
const ListDetailPage = lazy(() => import("./pages/ListDetailPage"));
const YearInReviewPage = lazy(() => import("./pages/YearInReviewPage"));
const SettingsPage = lazy(() => import("./pages/SettingsPage"));
const AdminPage = lazy(() => import("./pages/AdminPage"));

function App() {
  return (
    <AuthProvider>
      <ToastProvider>
        <div className="app-shell">
          <Navbar />
          <main className="page-wrap">
            <ErrorBoundary>
              <Suspense fallback={<div className="page-center"><Spinner size={40} /></div>}>
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
                  <Route path="/profile/:userId/followers" element={<FollowListPage />} />
                  <Route path="/profile/:userId/following" element={<FollowListPage />} />
                  <Route path="/profile/:userId/stats" element={<StatsPage />} />
                  <Route path="/profile/:userId/lists" element={<ListsPage />} />
                  <Route path="/profile/:userId/year-in-review" element={<YearInReviewPage />} />
                  <Route path="/tag/:slug" element={<TagPage />} />
                  <Route path="/feed" element={<FeedPage />} />
                  <Route path="/search" element={<SearchPage />} />
                  <Route path="/lists/:listId" element={<ListDetailPage />} />
                  <Route path="/settings" element={<SettingsPage />} />
                  <Route path="/admin" element={<AdminPage />} />
                  <Route path="*" element={<Navigate to="/" replace />} />
                </Routes>
              </Suspense>
            </ErrorBoundary>
          </main>
          <BottomTabBar />
        </div>
      </ToastProvider>
    </AuthProvider>
  );
}

export default App;
