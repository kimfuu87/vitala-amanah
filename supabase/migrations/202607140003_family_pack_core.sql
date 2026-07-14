create table if not exists public.family_packs (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  household_id uuid,
  status text not null default 'draft' check (status in ('draft','ready','shared')),
  sections jsonb not null default '{}'::jsonb,
  completed_sections text[] not null default '{}',
  last_reviewed_at timestamptz,
  last_pdf_generated_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  data_classification text not null default 'confidential',
  unique(owner_id)
);

create table if not exists public.report_events (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  family_pack_id uuid references public.family_packs(id) on delete set null,
  report_type text not null,
  report_id text not null unique,
  included_sections text[] not null default '{}',
  redacted boolean not null default true,
  status text not null default 'generated',
  expires_at timestamptz,
  created_at timestamptz not null default now(),
  data_classification text not null default 'confidential'
);

alter table public.family_packs enable row level security;
alter table public.report_events enable row level security;

drop policy if exists "family pack owner" on public.family_packs;
create policy "family pack owner" on public.family_packs for all to authenticated
using (owner_id=auth.uid()) with check (owner_id=auth.uid());
drop policy if exists "report event owner" on public.report_events;
create policy "report event owner" on public.report_events for all to authenticated
using (owner_id=auth.uid()) with check (owner_id=auth.uid());

create or replace function public.touch_updated_at() returns trigger language plpgsql as $$
begin new.updated_at=now(); return new; end; $$;
drop trigger if exists family_packs_touch_updated_at on public.family_packs;
create trigger family_packs_touch_updated_at before update on public.family_packs
for each row execute procedure public.touch_updated_at();

comment on table public.family_packs is 'Owner-entered continuity information. Never store passwords, PINs, payment-card data or cryptographic secrets.';
comment on table public.report_events is 'Metadata-only audit trail for protected report generation; report contents are not stored here.';
