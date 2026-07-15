create table if not exists public.households (
  id uuid primary key default gen_random_uuid(), name text not null,
  created_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz
);
create table if not exists public.household_members (
  id uuid primary key default gen_random_uuid(), household_id uuid not null references public.households(id) on delete cascade,
  managed_by uuid not null references auth.users(id) on delete cascade, user_id uuid references auth.users(id) on delete set null,
  display_name text not null, relationship text not null,
  member_type text not null default 'dependant' check (member_type in ('adult','child','dependant')),
  role text not null default 'member' check (role in ('owner','adult','member')),
  status text not null default 'active' check (status in ('invited','active','revoked')),
  can_view_household_assets boolean not null default false,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz
);
alter table public.profiles add column if not exists household_id uuid references public.households(id) on delete set null;
alter table public.assets add column if not exists household_id uuid references public.households(id) on delete set null;
alter table public.assets add column if not exists family_member_id uuid references public.household_members(id) on delete set null;
alter table public.assets add column if not exists visibility text not null default 'private' check (visibility in ('private','household'));
create table if not exists public.admin_roles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role text not null default 'owner' check (role in ('owner','admin','support')), created_at timestamptz not null default now()
);
alter table public.households enable row level security;
alter table public.household_members enable row level security;
alter table public.admin_roles enable row level security;
drop policy if exists "household members read" on public.households;
create policy "household members read" on public.households for select to authenticated using (created_by=auth.uid() or exists(select 1 from public.household_members m where m.household_id=id and m.user_id=auth.uid() and m.status='active'));
drop policy if exists "household owner write" on public.households;
create policy "household owner write" on public.households for all to authenticated using(created_by=auth.uid()) with check(created_by=auth.uid());
drop policy if exists "household member read" on public.household_members;
create policy "household member read" on public.household_members for select to authenticated using (managed_by=auth.uid() or user_id=auth.uid() or exists(select 1 from public.households h where h.id=household_id and h.created_by=auth.uid()));
drop policy if exists "household manager write" on public.household_members;
create policy "household manager write" on public.household_members for all to authenticated using(managed_by=auth.uid()) with check(managed_by=auth.uid());
drop policy if exists "admin role self read" on public.admin_roles;
create policy "admin role self read" on public.admin_roles for select to authenticated using(user_id=auth.uid());
drop policy if exists "owner read" on public.assets;
create policy "owner read" on public.assets for select to authenticated using (owner_id=auth.uid() or (visibility='household' and household_id is not null and exists(select 1 from public.household_members m where m.household_id=assets.household_id and m.user_id=auth.uid() and m.status='active' and m.can_view_household_assets)));
create or replace function public.create_family_household(household_name text) returns uuid language plpgsql security definer set search_path=public as $$
declare hid uuid; display text;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  select coalesce(nullif(full_name,''),'Household owner') into display from public.profiles where id=auth.uid();
  insert into public.households(name,created_by) values(household_name,auth.uid()) returning id into hid;
  insert into public.household_members(household_id,managed_by,user_id,display_name,relationship,member_type,role,status,can_view_household_assets) values(hid,auth.uid(),auth.uid(),display,'Self','adult','owner','active',true);
  update public.profiles set household_id=hid,account_type='family' where id=auth.uid(); return hid;
end $$;
create or replace function public.admin_dashboard_summary() returns jsonb language plpgsql security definer set search_path=public as $$
begin
  if not exists(select 1 from public.admin_roles where user_id=auth.uid() and role in ('owner','admin')) then raise exception 'Admin access required'; end if;
  return jsonb_build_object('users',(select count(*) from public.profiles),'family_accounts',(select count(*) from public.profiles where account_type='family'),'subscriptions',(select count(*) from public.subscriptions where status in ('active','trialing')),'failed_payments',(select count(*) from public.payment_records where status='failed'),'professional_applications',(select count(*) from public.professionals where not is_directory_demo and application_status not in ('Private','Published')),'reports_generated',(select count(*) from public.report_events),'open_account_requests',(select count(*) from public.account_requests where status='requested'));
end $$;
revoke all on function public.admin_dashboard_summary() from public;
grant execute on function public.admin_dashboard_summary() to authenticated;
insert into public.admin_roles(user_id,role) select id,'owner' from auth.users where lower(email)=lower('257437484+kimfuu87@users.noreply.github.com') on conflict(user_id) do nothing;
-- Development bootstrap: if this project has exactly one real (non-demo) account, it is the project owner.
insert into public.admin_roles(user_id,role)
select min(id),'owner' from auth.users where lower(coalesce(email,''))<>'demo@vitala-amanah.app'
having count(*)=1 on conflict(user_id) do nothing;
comment on table public.household_members is 'Managed dependants may have owner-entered records. Adult accounts retain separate private ownership.';
comment on table public.admin_roles is 'Administrative metadata access only; no access to user documents or owner-scoped records.';
