alter table public.assets drop constraint if exists assets_occupancy_check;
alter table public.assets add constraint assets_occupancy_check check (occupancy is null or occupancy in ('Own stay','Rented','Vacant','Family use','Other'));
