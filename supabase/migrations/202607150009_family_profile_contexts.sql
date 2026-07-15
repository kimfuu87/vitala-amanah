do $$ declare t text; begin
  foreach t in array array['liabilities','policies','contacts','legacy_records','reminders','retirement_profiles','family_packs','claims','document_records'] loop
    execute format('alter table public.%I add column if not exists household_id uuid references public.households(id) on delete set null',t);
    execute format('alter table public.%I add column if not exists family_member_id uuid references public.household_members(id) on delete set null',t);
    execute format('alter table public.%I add column if not exists visibility text not null default ''private'' check (visibility in (''private'',''household''))',t);
  end loop;
end $$;
alter table public.retirement_profiles add column if not exists profile_scope text not null default 'owner';
alter table public.family_packs add column if not exists profile_scope text not null default 'owner';
drop index if exists public.retirement_profiles_owner_scope_key;
create unique index retirement_profiles_owner_scope_key on public.retirement_profiles(owner_id,profile_scope);
alter table public.family_packs drop constraint if exists family_packs_owner_id_key;
drop index if exists public.family_packs_owner_scope_key;
create unique index family_packs_owner_scope_key on public.family_packs(owner_id,profile_scope);

-- Household members may read only records deliberately marked household-visible.
do $$ declare t text; begin
  foreach t in array array['liabilities','policies','contacts','legacy_records','reminders','retirement_profiles','family_packs','claims','document_records'] loop
    execute format('drop policy if exists "owner read" on public.%I',t);
    execute format('create policy "owner read" on public.%I for select to authenticated using(owner_id=auth.uid() or (visibility=''household'' and household_id is not null and public.is_household_member(household_id,true)))',t);
  end loop;
end $$;

comment on column public.household_members.user_id is 'When linked, the adult owns a separate login and cannot be impersonated through the household switcher.';
