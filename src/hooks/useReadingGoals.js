import { useCallback, useEffect, useState } from "react";
import { useToast } from "../context/ToastContext";
import { getGoalProgress, setReadingGoal, deleteReadingGoal } from "../services/goals";

export function useReadingGoal(userId, year = new Date().getFullYear()) {
  const { addToast } = useToast();
  const [goalData, setGoalData] = useState(null);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    if (!userId) return;
    setLoading(true);
    try {
      const data = await getGoalProgress(userId, year);
      setGoalData(data);
    } catch {
      setGoalData(null);
    } finally {
      setLoading(false);
    }
  }, [userId, year]);

  useEffect(() => {
    load();
  }, [load]);

  const setGoal = useCallback(async (target) => {
    try {
      await setReadingGoal(userId, year, target);
      addToast({ message: `Reading goal set to ${target} books!`, type: "success" });
      await load();
    } catch (err) {
      addToast({ message: err.message || "Failed to set goal", type: "error" });
    }
  }, [userId, year, load, addToast]);

  const removeGoal = useCallback(async () => {
    if (!goalData?.goal?.id) return;
    try {
      await deleteReadingGoal(goalData.goal.id);
      addToast({ message: "Reading goal removed", type: "success" });
      await load();
    } catch (err) {
      addToast({ message: err.message || "Failed to remove goal", type: "error" });
    }
  }, [goalData, load, addToast]);

  return { goalData, loading, setGoal, removeGoal, refresh: load };
}
