-- Function to refresh the book_tag_counts materialized view
create or replace function refresh_book_tag_counts()
returns trigger as $$
begin
  refresh materialized view concurrently book_tag_counts;
  return null;
end;
$$ language plpgsql security definer;

-- Trigger on INSERT
drop trigger if exists trg_tag_votes_insert_refresh on tag_votes;
create trigger trg_tag_votes_insert_refresh
  after insert on tag_votes
  for each statement
  execute function refresh_book_tag_counts();

-- Trigger on DELETE
drop trigger if exists trg_tag_votes_delete_refresh on tag_votes;
create trigger trg_tag_votes_delete_refresh
  after delete on tag_votes
  for each statement
  execute function refresh_book_tag_counts();

-- Grant execute to authenticated users
grant execute on function refresh_book_tag_counts() to authenticated;
