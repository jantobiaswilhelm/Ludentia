-- Add unique constraint on open_library_key for upsert support
-- PostgreSQL allows multiple NULLs in a unique column, so this is safe
alter table books add constraint books_open_library_key_unique unique (open_library_key);
