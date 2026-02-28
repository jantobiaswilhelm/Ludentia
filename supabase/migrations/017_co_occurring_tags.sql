-- Find tags that frequently co-occur with a given tag
create or replace function get_co_occurring_tags(
  p_tag_id uuid,
  p_limit integer default 8
)
returns table (
  tag_id uuid,
  label text,
  slug text,
  category text,
  color text,
  co_occurrence_count bigint
) as $$
begin
  return query
  select
    td.id as tag_id,
    td.label,
    td.slug,
    td.category,
    td.color,
    count(*) as co_occurrence_count
  from tag_votes tv1
  join tag_votes tv2 on tv2.book_id = tv1.book_id and tv2.tag_id != tv1.tag_id
  join tag_definitions td on td.id = tv2.tag_id
  where tv1.tag_id = p_tag_id
  group by td.id, td.label, td.slug, td.category, td.color
  order by co_occurrence_count desc
  limit p_limit;
end;
$$ language plpgsql stable;
