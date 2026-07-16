create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
  category text not null, title text not null, message text not null, action_url text,
  read_at timestamptz, dedupe_key text not null, created_at timestamptz not null default now(), unique(owner_id,dedupe_key)
);
alter table public.notifications enable row level security;
create policy "notification owner read" on public.notifications for select to authenticated using(owner_id=auth.uid());
create policy "notification owner update" on public.notifications for update to authenticated using(owner_id=auth.uid()) with check(owner_id=auth.uid());

create or replace function public.process_founding_trial_expiry() returns jsonb
language plpgsql security definer set search_path=public as $$
declare claim record; days_left integer; reminded integer:=0; expired integer:=0;
begin
  for claim in select * from launch_offer_claims where status='active' loop
    days_left:=ceil(extract(epoch from (claim.ends_at-now()))/86400);
    if claim.ends_at<=now() then
      update launch_offer_claims set status='expired' where id=claim.id;
      update subscriptions set status='expired',updated_at=now() where id='founding-trial-'||claim.owner_id;
      update profiles set plan='free',renewal_date=null,updated_at=now() where id=claim.owner_id;
      insert into notifications(owner_id,category,title,message,action_url,dedupe_key)
      values(claim.owner_id,'billing','Your complimentary Family access has ended','Your records are preserved. Features above Free limits are now read-only until you choose a plan.','/app','founding-expired-'||claim.id) on conflict do nothing;
      insert into audit_events(owner_id,action,entity_type,entity_id,details,is_demo)
      values(claim.owner_id,'founding_trial_expired','subscription',claim.id,jsonb_build_object('ended_at',claim.ends_at),false);
      expired:=expired+1;
    elsif days_left in (14,3,1) then
      insert into notifications(owner_id,category,title,message,action_url,dedupe_key)
      values(claim.owner_id,'billing','Your complimentary access ends soon','Your Family access ends in '||days_left||' day'||case when days_left=1 then '' else 's' end||'. Your records will remain available.','/app','founding-reminder-'||claim.id||'-'||days_left) on conflict do nothing;
      if found then reminded:=reminded+1; end if;
    end if;
  end loop;
  return jsonb_build_object('expired',expired,'reminders_created',reminded,'processed_at',now());
end; $$;
revoke all on function public.process_founding_trial_expiry() from public;
grant execute on function public.process_founding_trial_expiry() to service_role;

create or replace function public.admin_dashboard_summary() returns jsonb language plpgsql security definer set search_path=public as $$
begin
 if not exists(select 1 from admin_roles where user_id=auth.uid() and role in('owner','admin')) then raise exception 'Owner access required'; end if;
 return jsonb_build_object('users',(select count(*) from profiles),'family_accounts',(select count(*) from profiles where account_type='family'),
 'subscriptions',(select count(*) from subscriptions where status in('active','trialing')),'failed_payments',(select count(*) from payment_records where status='failed'),
 'professional_applications',(select count(*) from professionals where application_status not in('Private','Published')),'reports_generated',(select count(*) from report_events),
 'open_account_requests',(select count(*) from account_requests where status='requested'),'feedback_received',(select count(*) from feedback_submissions),
 'founding_places_remaining',greatest(0,20-(select count(*) from launch_offer_claims)));
end $$;

