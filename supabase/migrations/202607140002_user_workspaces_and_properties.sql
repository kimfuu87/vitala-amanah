create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  account_type text not null default 'individual' check (account_type in ('individual','family')),
  primary_goal text not null default 'organise_assets',
  plan text not null default 'free' check (plan in ('free','pro','family')),
  billing_cycle text not null default 'monthly' check (billing_cycle in ('monthly','annual')),
  renewal_date date,
  grace_period_ends_at timestamptz,
  onboarding_complete boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
drop policy if exists "profile owner" on public.profiles;
create policy "profile owner" on public.profiles for all to authenticated using (id=auth.uid()) with check (id=auth.uid());

create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin insert into public.profiles(id,full_name) values(new.id,new.raw_user_meta_data->>'full_name') on conflict do nothing; return new; end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

do $$ declare t text; begin
  foreach t in array array['assets','liabilities','policies','contacts','legacy_records','reminders','retirement_profiles','audit_events'] loop
    execute format('alter table public.%I add column if not exists owner_id uuid references auth.users(id) on delete cascade',t);
    execute format('alter table public.%I add column if not exists is_demo boolean not null default false',t);
  end loop;
end $$;

alter table public.assets add column if not exists property_type text;
alter table public.assets add column if not exists address text;
alter table public.assets add column if not exists state text;
alter table public.assets add column if not exists ownership_percentage numeric(5,2) default 100;
alter table public.assets add column if not exists joint_owner text;
alter table public.assets add column if not exists occupancy text check (occupancy is null or occupancy in ('Own stay','Rented','Vacant','Family use'));
alter table public.assets add column if not exists rental_income numeric(12,2) default 0;
alter table public.assets add column if not exists rental_manager text;
alter table public.assets add column if not exists rental_manager_contact text;
alter table public.assets add column if not exists tenancy_start date;
alter table public.assets add column if not exists tenancy_end date;
alter table public.assets add column if not exists tenancy_agreement_name text;
alter table public.assets add column if not exists tenancy_status text default 'Not recorded';
alter table public.assets add column if not exists loan_provider text;
alter table public.assets add column if not exists outstanding_loan numeric(14,2) default 0;
alter table public.assets add column if not exists monthly_instalment numeric(12,2) default 0;
alter table public.assets add column if not exists interest_rate numeric(6,3);
alter table public.assets add column if not exists loan_maturity date;
alter table public.assets add column if not exists maintenance_fee numeric(12,2) default 0;
alter table public.assets add column if not exists quit_rent numeric(12,2) default 0;
alter table public.assets add column if not exists assessment_tax numeric(12,2) default 0;
alter table public.assets add column if not exists title_number text;
alter table public.assets add column if not exists tenure text;
alter table public.assets add column if not exists purchase_price numeric(14,2);
alter table public.assets add column if not exists purchase_date date;

do $$ declare demo uuid := '432015d7-7053-4c98-88ff-c0d80faa08bf'; t text; begin
  insert into public.profiles(id,full_name,account_type,primary_goal,plan,onboarding_complete)
  values(demo,'Nadia Rahman','family','organise_assets','family',true) on conflict(id) do update set onboarding_complete=true;
  foreach t in array array['assets','liabilities','policies','contacts','legacy_records','reminders','retirement_profiles','audit_events'] loop
    execute format('update public.%I set owner_id=$1,is_demo=true where owner_id is null',t) using demo;
    execute format('alter table public.%I alter column owner_id set not null',t);
    execute format('drop policy if exists "demo read" on public.%I',t);
    execute format('drop policy if exists "demo write" on public.%I',t);
    execute format('drop policy if exists "owner read" on public.%I',t);
    execute format('drop policy if exists "owner write" on public.%I',t);
    execute format('drop policy if exists "public demo read" on public.%I',t);
    execute format('drop policy if exists "public demo capture" on public.%I',t);
    execute format('create policy "owner read" on public.%I for select to authenticated using (owner_id=auth.uid())',t);
    execute format('create policy "owner write" on public.%I for all to authenticated using (owner_id=auth.uid()) with check (owner_id=auth.uid())',t);
    execute format('create policy "public demo read" on public.%I for select to anon using (is_demo=true)',t);
  end loop;
  execute format('create policy "public demo capture" on public.assets for insert to anon with check (is_demo=true and owner_id=%L::uuid)',demo);
  execute format('create policy "public demo capture" on public.audit_events for insert to anon with check (is_demo=true and owner_id=%L::uuid)',demo);
end $$;

update public.assets set property_type='Condominium',address='Jalan Damai, Kuala Lumpur',state='Kuala Lumpur',ownership_percentage=100,
occupancy='Rented',rental_income=2800,rental_manager='Amanah Property Services',rental_manager_contact='+60 12-000 1122',
tenancy_start=current_date-interval '6 months',tenancy_end=current_date+interval '6 months',tenancy_agreement_name='Demo tenancy agreement.pdf',tenancy_status='Valid',
loan_provider='Amanah Finance',outstanding_loan=380000,monthly_instalment=2450,interest_rate=4.15,maintenance_fee=380,
title_number='DEMO-STRATA-001',tenure='Freehold',purchase_price=620000,purchase_date='2019-04-15'
where name='Family Home';
