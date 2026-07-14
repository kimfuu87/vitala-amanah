create table if not exists public.document_records (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
  household_id uuid, name text not null, category text not null, original_location text,
  expiry_date date, linked_record_type text, linked_record_id uuid, status text not null default 'Recorded',
  last_confirmed_at timestamptz, next_review_date date, information_source text default 'Owner entered',
  data_classification text not null default 'confidential', created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(), deleted_at timestamptz
);
create table if not exists public.claims (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
  household_id uuid, covered_person text not null, policy_name text not null, claim_type text not null,
  claims_contact text, hotline text, email text, required_documents text, reference_number text,
  submission_date date, status text not null default 'Preparing', follow_up_date date,
  responsible_person text, notes text, data_classification text not null default 'confidential',
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz
);
create table if not exists public.professionals (
  id uuid primary key default gen_random_uuid(), owner_id uuid references auth.users(id) on delete cascade,
  is_directory_demo boolean not null default false, name text not null, organisation text,
  category text not null, registration_details text, location text, languages text,
  telephone text, whatsapp text, email text, website text, matters_handled text,
  linked_records text, emergency_contact_permission boolean not null default false, notes text,
  application_status text not null default 'Private', licence_expiry date,
  referral_disclosure text, data_classification text not null default 'confidential',
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz,
  check ((is_directory_demo and owner_id is null) or (not is_directory_demo and owner_id is not null))
);
create table if not exists public.access_grants (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
  contact_id uuid references public.contacts(id) on delete cascade, recipient_email text,
  allowed_sections text[] not null default '{}', status text not null default 'draft',
  expires_at timestamptz, revoked_at timestamptz, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.payment_records (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
  provider text not null, external_reference text not null, amount_sen bigint not null default 0,
  currency text not null default 'MYR', status text not null, receipt_url text,
  paid_at timestamptz, created_at timestamptz not null default now(), unique(provider,external_reference)
);
create table if not exists public.privacy_preferences (
  owner_id uuid primary key references auth.users(id) on delete cascade, language text not null default 'en',
  ai_enabled boolean not null default true, marketing_consent boolean not null default false,
  notification_email boolean not null default true, deletion_requested_at timestamptz,
  deletion_cancel_until timestamptz, updated_at timestamptz not null default now()
);

do $$ declare t text; begin
  foreach t in array array['document_records','claims','professionals','access_grants','payment_records','privacy_preferences'] loop
    execute format('alter table public.%I enable row level security',t);
  end loop;
end $$;
drop policy if exists "documents owner" on public.document_records;
create policy "documents owner" on public.document_records for all to authenticated using(owner_id=auth.uid()) with check(owner_id=auth.uid());
drop policy if exists "claims owner" on public.claims;
create policy "claims owner" on public.claims for all to authenticated using(owner_id=auth.uid()) with check(owner_id=auth.uid());
drop policy if exists "professionals owner read" on public.professionals;
create policy "professionals owner read" on public.professionals for select to authenticated using(owner_id=auth.uid() or is_directory_demo);
drop policy if exists "professionals owner write" on public.professionals;
create policy "professionals owner write" on public.professionals for all to authenticated using(owner_id=auth.uid() and not is_directory_demo) with check(owner_id=auth.uid() and not is_directory_demo);
drop policy if exists "professionals public demo" on public.professionals;
create policy "professionals public demo" on public.professionals for select to anon using(is_directory_demo);
drop policy if exists "grants owner" on public.access_grants;
create policy "grants owner" on public.access_grants for all to authenticated using(owner_id=auth.uid()) with check(owner_id=auth.uid());
drop policy if exists "payments owner read" on public.payment_records;
create policy "payments owner read" on public.payment_records for select to authenticated using(owner_id=auth.uid());
drop policy if exists "privacy owner" on public.privacy_preferences;
create policy "privacy owner" on public.privacy_preferences for all to authenticated using(owner_id=auth.uid()) with check(owner_id=auth.uid());

insert into public.professionals(is_directory_demo,name,organisation,category,registration_details,location,languages,telephone,website,matters_handled,application_status,referral_disclosure,data_classification)
select true,v.*,'Demo','Fictional demonstration profile. No referral relationship exists.','public'
from (values
 ('Amina Salleh','Amanah Legal Studio','Estate lawyer','DEMO-LAW-001','Kuala Lumpur','English, Bahasa Melayu','+60 3-0000 1001','https://example.com','Estate-readiness education'),
 ('Farid Hakim','Hibah Education Partners','Hibah specialist','DEMO-HIBAH-002','Selangor','Bahasa Melayu, English','+60 3-0000 1002','https://example.com','General hibah education'),
 ('Mei Ling Tan','Clarity Planning','Licensed financial planner','DEMO-FP-003','Penang','English, Mandarin, Bahasa Melayu','+60 4-0000 1003','https://example.com','Retirement and cash-flow education'),
 ('Ravi Kumar','Kumar Tax Advisory','Tax agent','DEMO-TAX-004','Johor','English, Tamil, Bahasa Melayu','+60 7-0000 1004','https://example.com','General tax organisation')
) v(name,organisation,category,registration_details,location,languages,telephone,website,matters_handled)
where not exists(select 1 from public.professionals where is_directory_demo);
