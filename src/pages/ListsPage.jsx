import { useState } from "react";
import { useParams, Link } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { useUserLists } from "../hooks/useLists";
import ListCard from "../components/lists/ListCard";
import CreateListModal from "../components/lists/CreateListModal";
import EmptyState from "../components/ui/EmptyState";
import Spinner from "../components/ui/Spinner";
import { useDocumentTitle } from "../hooks/useDocumentTitle";

function ListsPage() {
  const { userId } = useParams();
  const { user } = useAuth();
  const isOwnProfile = userId === user?.id;
  const { lists, loading, refresh } = useUserLists(userId);
  const [showCreate, setShowCreate] = useState(false);
  useDocumentTitle("Lists");

  if (loading) {
    return <div className="page-center"><Spinner size={40} /></div>;
  }

  return (
    <div className="lists-page">
      <div className="lists-header">
        <Link to={`/profile/${userId}`} className="back-link">&larr; Profile</Link>
        <h1>Lists</h1>
        {isOwnProfile ? (
          <button type="button" className="btn btn-primary" onClick={() => setShowCreate(true)}>
            Create List
          </button>
        ) : null}
      </div>

      {lists.length === 0 ? (
        <EmptyState
          title="No lists yet"
          description={isOwnProfile ? "Create your first list to organize books." : "This user hasn't created any lists."}
        />
      ) : (
        <div className="lists-grid">
          {lists.map((list) => (
            <ListCard key={list.id} list={list} />
          ))}
        </div>
      )}

      <CreateListModal
        open={showCreate}
        onClose={() => setShowCreate(false)}
        onCreated={() => {
          refresh();
          setShowCreate(false);
        }}
      />
    </div>
  );
}

export default ListsPage;
