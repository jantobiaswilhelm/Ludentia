function BarChart({ data, orientation = "horizontal", color, maxValue: maxProp }) {
  if (!data || data.length === 0) return <p className="muted-text">No data</p>;

  const maxVal = maxProp || Math.max(...data.map((d) => d.value), 1);

  if (orientation === "vertical") {
    return (
      <div className="bar-chart bar-chart-vertical">
        {data.map((item) => {
          const pct = Math.round((item.value / maxVal) * 100);
          return (
            <div key={item.label} className="bar-chart-col">
              <span className="bar-chart-val">{item.value}</span>
              <div
                className="bar-chart-bar"
                style={{ height: `${pct}%`, background: color || "var(--primary)" }}
              />
              <span className="bar-chart-label">{item.label}</span>
            </div>
          );
        })}
      </div>
    );
  }

  return (
    <div className="bar-chart bar-chart-horizontal">
      {data.map((item) => {
        const pct = Math.round((item.value / maxVal) * 100);
        return (
          <div key={item.label} className="bar-chart-item">
            <span className="bar-chart-label">{item.label}</span>
            <div className="bar-chart-track">
              <div
                className="bar-chart-bar"
                style={{ width: `${pct}%`, background: color || "var(--primary)" }}
              />
            </div>
            <span className="bar-chart-val">{item.value}</span>
          </div>
        );
      })}
    </div>
  );
}

export default BarChart;
