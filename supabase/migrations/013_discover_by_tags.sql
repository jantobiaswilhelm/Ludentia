-- Discover books matching multiple tags, ranked by match count
create or replace function discover_books_by_tags(
  p_tag_ids uuid[],
  p_limit integer default 20,
  p_offset integer default 0
)
returns table (
  book_id uuid,
  match_count bigint,
  matched_tags uuid[]
) as $$
begin
  return query
  select
    tv.book_id,
    count(distinct tv.tag_id) as match_count,
    array_agg(distinct tv.tag_id) as matched_tags
  from tag_votes tv
  where tv.tag_id = any(p_tag_ids)
  group by tv.book_id
  order by match_count desc, tv.book_id
  limit p_limit
  offset p_offset;
end;
$$ language plpgsql stable;
