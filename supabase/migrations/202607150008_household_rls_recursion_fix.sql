create or replace function public.is_household_owner(target_household uuid)
returns boolean language sql stable security definer set search_path=public as $$
  select exists(select 1 from public.households where id=target_household and created_by=auth.uid() and deleted_at is null)
$$;
create or replace function public.is_household_member(target_household uuid, require_asset_access boolean default false)
returns boolean language sql stable security definer set search_path=public as $$
  select exists(select 1 from public.household_members where household_id=target_household and user_id=auth.uid() and status='active' and deleted_at is null and (not require_asset_access or can_view_household_assets))
$$;
revoke all on function public.is_household_owner(uuid) from public;
revoke all on function public.is_household_member(uuid,boolean) from public;
grant execute on function public.is_household_owner(uuid) to authenticated;
grant execute on function public.is_household_member(uuid,boolean) to authenticated;
drop policy if exists "household members read" on public.households;
create policy "household members read" on public.households for select to authenticated using(created_by=auth.uid() or public.is_household_member(id,false));
drop policy if exists "household member read" on public.household_members;
create policy "household member read" on public.household_members for select to authenticated using(managed_by=auth.uid() or user_id=auth.uid() or public.is_household_owner(household_id));
drop policy if exists "owner read" on public.assets;
create policy "owner read" on public.assets for select to authenticated using(owner_id=auth.uid() or (visibility='household' and household_id is not null and public.is_household_member(household_id,true)));
