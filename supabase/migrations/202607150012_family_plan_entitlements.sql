create or replace function public.can_add_household_member(requested_type text)
returns boolean language plpgsql stable security definer set search_path=public as $$
declare current_plan text; member_count integer; adult_count integer;
begin
  select plan into current_plan from public.profiles where id=auth.uid();
  if current_plan is null or current_plan='free' then return false; end if;
  select count(*) filter(where role<>'owner'),count(*) filter(where role<>'owner' and member_type='adult')
  into member_count,adult_count from public.household_members where managed_by=auth.uid() and status<>'revoked' and deleted_at is null;
  if current_plan='pro' then return member_count<1; end if;
  if current_plan='family' then
    if member_count>=6 then return false; end if;
    if requested_type='adult' and adult_count>=1 then return false; end if;
    return true;
  end if;
  return false;
end $$;
revoke all on function public.can_add_household_member(text) from public;
grant execute on function public.can_add_household_member(text) to authenticated;

drop policy if exists "household manager write" on public.household_members;
drop policy if exists "household manager insert" on public.household_members;
drop policy if exists "household manager update" on public.household_members;
drop policy if exists "household manager delete" on public.household_members;
create policy "household manager insert" on public.household_members for insert to authenticated
with check(managed_by=auth.uid() and (role='owner' or public.can_add_household_member(member_type)));
create policy "household manager update" on public.household_members for update to authenticated
using(managed_by=auth.uid()) with check(managed_by=auth.uid());
create policy "household manager delete" on public.household_members for delete to authenticated using(managed_by=auth.uid());

create or replace function public.create_family_household(household_name text) returns uuid language plpgsql security definer set search_path=public as $$
declare hid uuid; display text; current_plan text;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  select coalesce(nullif(full_name,''),'Household owner'),plan into display,current_plan from public.profiles where id=auth.uid();
  if current_plan='free' then raise exception 'Upgrade to Pro or Family to create a family workspace'; end if;
  select household_id into hid from public.profiles where id=auth.uid(); if hid is not null then return hid; end if;
  insert into public.households(name,created_by) values(household_name,auth.uid()) returning id into hid;
  insert into public.household_members(household_id,managed_by,user_id,display_name,relationship,member_type,role,status,can_view_household_assets)
  values(hid,auth.uid(),auth.uid(),display,'Self','adult','owner','active',true);
  update public.profiles set household_id=hid,account_type='family' where id=auth.uid(); return hid;
end $$;

comment on function public.can_add_household_member(text) is 'Server-enforced family profile limit: Free 0; Pro 1 managed profile; Family 1 additional adult and 5 managed dependant profiles.';
