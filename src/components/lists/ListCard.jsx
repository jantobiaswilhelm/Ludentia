import { Link } from "react-router-dom";

function ListCard({ list }) {
  return (
    <Link to={`/lists/${list.id}`} className="list-card">
      <div className="list-card-body">
        <h3 className="list-card-title">{list.title}</h3>
        {list.description ? (
          <p className="list-card-desc">{list.description}</p>
        ) : null}
        <div className="list-card-meta">
          <span>{list.item_count || 0} books</span>
          {list.is_ranked ? <span className="list-badge">Ranked</span> : null}
          {list.visibility !== "public" ? (
            <span className="list-badge list-badge-vis">{list.visibility === "private" ? "Private" : "Friends"}</span>
          ) : null}
        </div>
      </div>
    </Link>
  );
}

export default ListCard;
