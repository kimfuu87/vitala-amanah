create extension if not exists "pgcrypto";

create table if not exists public.assets (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 120),
  category text not null default 'Cash',
  value numeric(14,2) not null default 0 check (value >= 0),
  liquidity text not null default 'Liquid' check (liquidity in ('Liquid','Illiquid')),
  institution text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.liabilities (
  id uuid primary key default gen_random_uuid(), name text not null,
  category text not null default 'Loan', balance numeric(14,2) not null default 0 check (balance >= 0),
  lender text, monthly_payment numeric(12,2) not null default 0,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);

create table if not exists public.policies (
  id uuid primary key default gen_random_uuid(), provider text not null,
  policy_type text not null, masked_number text, coverage numeric(14,2) not null default 0,
  premium numeric(12,2) not null default 0, renewal_date date, status text not null default 'Active',
  claims_contact text, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);

create table if not exists public.contacts (
  id uuid primary key default gen_random_uuid(), name text not null, relationship text not null,
  role text not null, phone text, email text, emergency_access boolean not null default false,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);

create table if not exists public.legacy_records (
  id uuid primary key default gen_random_uuid(), title text not null, record_type text not null,
  status text not null default 'Needs review', professional text, review_date date,
  notes text, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);

create table if not exists public.reminders (
  id uuid primary key default gen_random_uuid(), title text not null, due_date date not null,
  category text not null default 'Annual review', completed boolean not null default false,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);

create table if not exists public.retirement_profiles (
  id uuid primary key default gen_random_uuid(), current_age int not null default 35,
  retirement_age int not null default 60, monthly_spending numeric(12,2) not null default 5000,
  current_savings numeric(14,2) not null default 100000, monthly_contribution numeric(12,2) not null default 1500,
  annual_return numeric(5,2) not null default 5, inflation numeric(5,2) not null default 3,
  updated_at timestamptz not null default now()
);

create table if not exists public.audit_events (
  id uuid primary key default gen_random_uuid(), action text not null, entity_type text not null,
  entity_id uuid, details jsonb not null default '{}'::jsonb, created_at timestamptz not null default now()
);

alter table public.assets enable row level security;
alter table public.liabilities enable row level security;
alter table public.policies enable row level security;
alter table public.contacts enable row level security;
alter table public.legacy_records enable row level security;
alter table public.reminders enable row level security;
alter table public.retirement_profiles enable row level security;
alter table public.audit_events enable row level security;

do $$ declare t text; begin
  foreach t in array array['assets','liabilities','policies','contacts','legacy_records','reminders','retirement_profiles','audit_events'] loop
    execute format('drop policy if exists "demo read" on public.%I', t);
    execute format('drop policy if exists "demo write" on public.%I', t);
    execute format('create policy "demo read" on public.%I for select to anon, authenticated using (true)', t);
    execute format('create policy "demo write" on public.%I for all to anon, authenticated using (true) with check (true)', t);
  end loop;
end $$;

insert into public.assets (name,category,value,liquidity,institution,notes)
select * from (values
 ('Family Home','Property',850000::numeric,'Illiquid','—','Fictional demo record'),
 ('Emergency Savings','Cash',42000::numeric,'Liquid','Jade Bank','Fictional demo record'),
 ('EPF Account','Retirement',185000::numeric,'Liquid','KWSP','Fictional demo record')
) v where not exists (select 1 from public.assets);

insert into public.liabilities (name,category,balance,lender,monthly_payment)
select 'Home financing','Mortgage',380000,'Amanah Finance',2450 where not exists (select 1 from public.liabilities);

insert into public.policies (provider,policy_type,masked_number,coverage,premium,renewal_date,status,claims_contact)
select 'Harapan Takaful','Family Takaful','•••• 2841',300000,180,(current_date + interval '95 days')::date,'Active','1-800-DEMO'
where not exists (select 1 from public.policies);

insert into public.contacts (name,relationship,role,phone,email,emergency_access)
select 'Aisyah Rahman','Spouse','Emergency contact','+60 12-000 0000','aisyah@example.com',true
where not exists (select 1 from public.contacts);

insert into public.legacy_records (title,record_type,status,professional,review_date,notes)
select 'Nomination review','Nomination','Needs review',null,(current_date + interval '30 days')::date,'Confirm records after major life events.'
where not exists (select 1 from public.legacy_records);

insert into public.reminders (title,due_date,category)
select 'Review family takaful nomination',(current_date + interval '30 days')::date,'Nomination review'
where not exists (select 1 from public.reminders);

insert into public.retirement_profiles default values;
