alter table public.profiles add column if not exists stripe_customer_id text;
alter table public.profiles add column if not exists storage_used_bytes bigint not null default 0;
alter table public.profiles add column if not exists record_count integer not null default 0;

alter table public.access_grants add column if not exists recipient_name text;
alter table public.access_grants add column if not exists recipient_previewed_at timestamptz;
alter table public.access_grants add column if not exists accepted_at timestamptz;
alter table public.access_grants add column if not exists verification_status text not null default 'unverified';
alter table public.access_grants add column if not exists last_accessed_at timestamptz;

create table if not exists public.subscriptions (
  id text primary key, owner_id uuid not null references auth.users(id) on delete cascade,
  stripe_customer_id text, status text not null, plan text not null default 'pro', price_id text,
  billing_cycle text not null default 'monthly', current_period_end timestamptz,
  cancel_at_period_end boolean not null default false, grace_period_ends_at timestamptz,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.purchases (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
  provider text not null, external_reference text not null, amount_sen bigint,
  access_ends_at timestamptz, status text not null, created_at timestamptz not null default now(),
  unique(provider,external_reference)
);
create table if not exists public.account_requests (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
  request_type text not null check(request_type in ('export','deletion','deletion_cancel')),
  status text not null default 'requested', recovery_until timestamptz,
  created_at timestamptz not null default now(), completed_at timestamptz
);
alter table public.subscriptions enable row level security;
alter table public.purchases enable row level security;
alter table public.account_requests enable row level security;
drop policy if exists "subscriptions owner read" on public.subscriptions;
create policy "subscriptions owner read" on public.subscriptions for select to authenticated using(owner_id=auth.uid());
drop policy if exists "purchases owner read" on public.purchases;
create policy "purchases owner read" on public.purchases for select to authenticated using(owner_id=auth.uid());
drop policy if exists "account requests owner" on public.account_requests;
create policy "account requests owner" on public.account_requests for all to authenticated using(owner_id=auth.uid()) with check(owner_id=auth.uid());

comment on table public.subscriptions is 'Entitlements are updated only by verified server-side provider webhooks.';
comment on table public.access_grants is 'Selected-section grants only; encrypted content and secrets are never granted here.';
