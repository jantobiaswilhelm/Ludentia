import { createContext, useCallback, useContext, useRef, useState } from "react";

const ToastContext = createContext(null);

let nextId = 0;

export function ToastProvider({ children }) {
  const [toasts, setToasts] = useState([]);
  const timersRef = useRef({});

  const removeToast = useCallback((id) => {
    // trigger exit animation
    setToasts((prev) =>
      prev.map((t) => (t.id === id ? { ...t, exiting: true } : t))
    );
    setTimeout(() => {
      setToasts((prev) => prev.filter((t) => t.id !== id));
      clearTimeout(timersRef.current[id]);
      delete timersRef.current[id];
    }, 200);
  }, []);

  const addToast = useCallback(
    ({ message, type = "info", duration = 4000 }) => {
      const id = ++nextId;
      setToasts((prev) => [...prev, { id, message, type, exiting: false }]);
      timersRef.current[id] = setTimeout(() => removeToast(id), duration);
      return id;
    },
    [removeToast]
  );

  return (
    <ToastContext.Provider value={{ addToast }}>
      {children}
      <div className="toast-container" role="status" aria-live="polite">
        {toasts.map((toast) => (
          <div
            key={toast.id}
            className={`toast toast-${toast.type} ${toast.exiting ? "toast-exit" : ""}`}
            onClick={() => removeToast(toast.id)}
          >
            {toast.message}
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  );
}

export function useToast() {
  const ctx = useContext(ToastContext);
  if (!ctx) throw new Error("useToast must be inside ToastProvider");
  return ctx;
}
