function Button({
  children,
  variant = "primary",
  size = "md",
  disabled,
  loading,
  onClick,
  type = "button",
  className = "",
  ...rest
}) {
  return (
    <button
      type={type}
      className={`btn btn-${variant} btn-${size} ${className}`}
      disabled={disabled || loading}
      onClick={onClick}
      {...rest}
    >
      {loading ? <span className="btn-spinner" /> : null}
      {children}
    </button>
  );
}

export default Button;
