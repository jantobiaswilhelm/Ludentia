function StatCard({ value, label }) {
  return (
    <div className="stat-card">
      <span className="stat-card-value">{value ?? "—"}</span>
      <span className="stat-card-label">{label}</span>
    </div>
  );
}

export default StatCard;
