-- Get the most popular tags for a specific book
create or replace function get_popular_tags_for_book(
  p_book_id uuid,
  p_limit integer default 10
)
returns table (
  tag_id uuid,
  label text,
  category text,
  slug text,
  vote_count bigint
) as $$
begin
  return query
  select
    td.id as tag_id,
    td.label,
    td.category,
    td.slug,
    count(*) as vote_count
  from tag_votes tv
  join tag_definitions td on td.id = tv.tag_id
  where tv.book_id = p_book_id
  group by td.id, td.label, td.category, td.slug
  order by vote_count desc
  limit p_limit;
end;
$$ language plpgsql stable;
