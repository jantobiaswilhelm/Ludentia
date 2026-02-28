export const SHELVES = {
  want_to_read: { label: "Want to Read", icon: "📚" },
  reading: { label: "Currently Reading", icon: "📖" },
  read: { label: "Read", icon: "✅" },
};

export const SHELF_ORDER = ["want_to_read", "reading", "read"];

export const MOOD_TAGS = [
  { value: "loving_it", label: "Loving It", emoji: "😍" },
  { value: "slow_start", label: "Slow Start", emoji: "🐢" },
  { value: "cant_put_down", label: "Can't Put Down", emoji: "🔥" },
  { value: "struggling", label: "Struggling", emoji: "😩" },
  { value: "intrigued", label: "Intrigued", emoji: "🤔" },
  { value: "confused", label: "Confused", emoji: "😵" },
  { value: "hooked", label: "Hooked", emoji: "🎣" },
  { value: "mixed_feelings", label: "Mixed Feelings", emoji: "🤷" },
];

export const TAG_COLORS = {
  orange: { bg: "#FFF7ED", text: "#9A3412", border: "#FDBA74" },
  purple: { bg: "#FAF5FF", text: "#6B21A8", border: "#C084FC" },
  yellow: { bg: "#FEFCE8", text: "#854D0E", border: "#FDE047" },
  pink: { bg: "#FDF2F8", text: "#9D174D", border: "#F9A8D4" },
  red: { bg: "#FEF2F2", text: "#991B1B", border: "#FCA5A5" },
  green: { bg: "#F0FDF4", text: "#166534", border: "#86EFAC" },
  blue: { bg: "#EFF6FF", text: "#1E40AF", border: "#93C5FD" },
  brown: { bg: "#FDF8F0", text: "#78350F", border: "#D4A574" },
  gray: { bg: "#F9FAFB", text: "#374151", border: "#D1D5DB" },
};

export const VISIBILITY_OPTIONS = [
  { value: "public", label: "Public" },
  { value: "friends_only", label: "Friends Only" },
  { value: "private", label: "Private" },
];
