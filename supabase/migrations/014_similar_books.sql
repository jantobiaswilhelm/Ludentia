-- Find books that share the most tags with a given book
create or replace function get_similar_books(
  p_book_id uuid,
  p_limit integer default 8
)
returns table (
  book_id uuid,
  shared_tags bigint,
  shared_tag_ids uuid[]
) as $$
begin
  return query
  with source_tags as (
    select distinct tv0.tag_id
    from tag_votes tv0
    where tv0.book_id = p_book_id
  )
  select
    tv.book_id,
    count(distinct tv.tag_id) as shared_tags,
    array_agg(distinct tv.tag_id) as shared_tag_ids
  from tag_votes tv
  join source_tags st on st.tag_id = tv.tag_id
  where tv.book_id != p_book_id
  group by tv.book_id
  order by shared_tags desc
  limit p_limit;
end;
$$ language plpgsql stable;
