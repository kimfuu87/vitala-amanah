create table if not exists public.feedback_submissions (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
 rating smallint not null check(rating between 1 and 5), feedback text not null check(char_length(trim(feedback)) between 40 and 3000),
 contact_permission boolean not null default false, created_at timestamptz not null default now()
);
create table if not exists public.launch_offer_claims (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null unique references auth.users(id) on delete cascade,
 feedback_id uuid not null unique references public.feedback_submissions(id), offer_code text not null default 'FOUNDING20_3MONTH_FAMILY',
 starts_at timestamptz not null default now(), ends_at timestamptz not null, status text not null default 'active', created_at timestamptz not null default now()
);
alter table public.feedback_submissions enable row level security;
alter table public.launch_offer_claims enable row level security;
create policy "feedback owner read" on public.feedback_submissions for select to authenticated using(owner_id=auth.uid());
create policy "claim owner read" on public.launch_offer_claims for select to authenticated using(owner_id=auth.uid());
create or replace function public.founding_trial_status() returns jsonb language sql security definer stable set search_path=public as $$
 select jsonb_build_object('capacity',20,'claimed',(select count(*) from launch_offer_claims),'remaining',greatest(0,20-(select count(*) from launch_offer_claims)),
 'claim',(select jsonb_build_object('ends_at',ends_at,'status',status) from launch_offer_claims where owner_id=auth.uid())); $$;
create or replace function public.claim_founding_feedback_trial(feedback_text text,feedback_rating integer,allow_follow_up boolean default false)
returns jsonb language plpgsql security definer set search_path=public as $$
declare uid uuid:=auth.uid(); fid uuid; ending timestamptz:=now()+interval '3 months'; total integer; confirmed timestamptz; demo boolean;
begin
 if uid is null then raise exception 'Sign in is required.'; end if;
 if char_length(trim(coalesce(feedback_text,'')))<40 then raise exception 'Please provide at least 40 characters of useful feedback.'; end if;
 if feedback_rating not between 1 and 5 then raise exception 'Choose a rating from 1 to 5.'; end if;
 select email_confirmed_at into confirmed from auth.users where id=uid;
 if confirmed is null then raise exception 'Verify your email before claiming this offer.'; end if;
 select coalesce(is_demo,false) into demo from profiles where id=uid;
 if demo then raise exception 'The demo account is not eligible.'; end if;
 perform pg_advisory_xact_lock(202607160013);
 if exists(select 1 from launch_offer_claims where owner_id=uid) then return founding_trial_status(); end if;
 select count(*) into total from launch_offer_claims;
 if total>=20 then raise exception 'All 20 founding trial places have been claimed.'; end if;
 insert into feedback_submissions(owner_id,rating,feedback,contact_permission) values(uid,feedback_rating,trim(feedback_text),allow_follow_up) returning id into fid;
 insert into launch_offer_claims(owner_id,feedback_id,ends_at) values(uid,fid,ending);
 insert into subscriptions(id,owner_id,status,plan,billing_cycle,current_period_end) values('founding-trial-'||uid,uid,'trialing','family','monthly',ending)
 on conflict(id) do update set status='trialing',plan='family',current_period_end=ending,updated_at=now();
 update profiles set plan='family',billing_cycle='monthly',renewal_date=ending::date,grace_period_ends_at=null,updated_at=now() where id=uid;
 insert into audit_events(owner_id,action,entity_type,entity_id,details,is_demo) values(uid,'founding_trial_claimed','subscription',fid,jsonb_build_object('ends_at',ending),false);
 return founding_trial_status();
end; $$;
revoke all on function public.founding_trial_status() from public;
revoke all on function public.claim_founding_feedback_trial(text,integer,boolean) from public;
grant execute on function public.founding_trial_status() to authenticated;
grant execute on function public.claim_founding_feedback_trial(text,integer,boolean) to authenticated;
