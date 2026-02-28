-- Explained recommendations: returns reason as JSONB with detailed match info
create or replace function get_recommendations(p_user_id uuid, p_limit integer default 20)
returns table (
  book_id uuid,
  score bigint,
  reason jsonb
) as $$
begin
  return query
  with user_rated_books as (
    select bl.book_id, bl.rating
    from book_logs bl
    where bl.user_id = p_user_id
  ),
  user_tags as (
    select tv.tag_id, td.category, td.label, td.id
    from tag_votes tv
    join tag_definitions td on td.id = tv.tag_id
    where tv.user_id = p_user_id
  ),
  user_fav_authors as (
    select distinct unnest(b.authors) as author
    from book_logs bl
    join books b on b.id = bl.book_id
    where bl.user_id = p_user_id and bl.rating >= 9
  ),
  candidate_books as (
    select b.id as book_id
    from books b
    where b.id not in (select urb.book_id from user_rated_books urb)
      and b.id not in (select ubs.book_id from user_bookshelves ubs where ubs.user_id = p_user_id)
  ),
  scored as (
    select
      cb.book_id,
      -- Tag category overlap: +3 per matching category
      coalesce((
        select count(distinct td.category) * 3
        from tag_votes tv
        join tag_definitions td on td.id = tv.tag_id
        where tv.book_id = cb.book_id
          and td.category in (select ut.category from user_tags ut)
      ), 0)
      -- Tag exact overlap: +2 per matching tag
      + coalesce((
        select count(*) * 2
        from tag_votes tv
        where tv.book_id = cb.book_id
          and tv.tag_id in (select ut.tag_id from user_tags ut)
      ), 0)
      -- Same author as highly rated: +5
      + case when exists (
        select 1 from books b
        where b.id = cb.book_id
          and b.authors && (select array_agg(author) from user_fav_authors)
      ) then 5 else 0 end
      -- High community rating: +2
      + case when exists (
        select 1 from book_rating_stats brs
        where brs.book_id = cb.book_id
          and brs.avg_rating >= 7.5
          and brs.rating_count >= 3
      ) then 2 else 0 end
      as score,
      -- Build reason JSONB
      jsonb_build_object(
        'matched_tags', coalesce((
          select jsonb_agg(jsonb_build_object('id', td.id, 'label', td.label, 'category', td.category))
          from tag_votes tv
          join tag_definitions td on td.id = tv.tag_id
          where tv.book_id = cb.book_id
            and tv.tag_id in (select ut.tag_id from user_tags ut)
        ), '[]'::jsonb),
        'matched_categories', coalesce((
          select jsonb_agg(distinct td.category)
          from tag_votes tv
          join tag_definitions td on td.id = tv.tag_id
          where tv.book_id = cb.book_id
            and td.category in (select ut.category from user_tags ut)
        ), '[]'::jsonb),
        'author_match', coalesce((
          select jsonb_agg(a.author)
          from user_fav_authors a
          join books b on b.id = cb.book_id and a.author = any(b.authors)
        ), '[]'::jsonb),
        'high_community_rating', exists (
          select 1 from book_rating_stats brs
          where brs.book_id = cb.book_id
            and brs.avg_rating >= 7.5
            and brs.rating_count >= 3
        )
      ) as reason
    from candidate_books cb
  )
  select s.book_id, s.score, s.reason
  from scored s
  where s.score > 0
  order by s.score desc
  limit p_limit;
end;
$$ language plpgsql stable;
