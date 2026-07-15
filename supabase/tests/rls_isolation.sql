-- Run in Supabase SQL Editor. The transaction is always rolled back.
begin;

do $$
begin
  if (select count(*) from auth.users) < 2 then
    raise exception 'RLS isolation test requires at least two auth users';
  end if;
end $$;

select set_config('test.user_a',(select id::text from auth.users order by created_at limit 1),true);
select set_config('test.user_b',(select id::text from auth.users order by created_at offset 1 limit 1),true);

insert into public.assets(owner_id,name,category,value,liquidity,is_demo,notes)
values(current_setting('test.user_b')::uuid,'__RLS_TEST_B_ASSET__','Cash',1,'Liquid',false,'temporary isolation test');
insert into public.document_records(owner_id,name,category,status)
values(current_setting('test.user_b')::uuid,'__RLS_TEST_B_DOC__','Identity','Recorded');
insert into public.professionals(owner_id,is_directory_demo,name,category,application_status)
values(current_setting('test.user_b')::uuid,false,'__RLS_TEST_B_PRO__','Lawyer','Private');
insert into public.access_grants(owner_id,recipient_email,allowed_sections,status,expires_at)
values(current_setting('test.user_b')::uuid,'rls-a@example.invalid',array['Family Pack'],'accepted',now()-interval '1 day');

select set_config('request.jwt.claim.sub',current_setting('test.user_a'),true);
select set_config('request.jwt.claim.role','authenticated',true);
set local role authenticated;

do $$
declare visible_rows integer; changed_rows integer;
begin
  select count(*) into visible_rows from public.assets where name='__RLS_TEST_B_ASSET__';
  if visible_rows <> 0 then raise exception 'FAIL: User A can read User B assets'; end if;
  update public.assets set value=2 where name='__RLS_TEST_B_ASSET__';
  get diagnostics changed_rows = row_count;
  if changed_rows <> 0 then raise exception 'FAIL: User A can edit User B assets'; end if;
  select count(*) into visible_rows from public.document_records where name='__RLS_TEST_B_DOC__';
  if visible_rows <> 0 then raise exception 'FAIL: another adult can read private document metadata'; end if;
  select count(*) into visible_rows from public.professionals where name='__RLS_TEST_B_PRO__';
  if visible_rows <> 0 then raise exception 'FAIL: private professionals leak across users'; end if;
  select count(*) into visible_rows from public.access_grants where owner_id=current_setting('test.user_b')::uuid;
  if visible_rows <> 0 then raise exception 'FAIL: expired or foreign grants are visible'; end if;
end $$;

reset role;

do $$
begin
  if exists(
    select 1 from information_schema.columns
    where table_schema='public' and table_name='document_records'
      and column_name in ('content','plaintext','decryption_key','file_bytes')
  ) then raise exception 'FAIL: document content or keys are present in the admin-visible metadata table'; end if;
  raise notice 'PASS: cross-user read/write, adult privacy, professional isolation, expired grants and document-content gate';
end $$;

rollback;
