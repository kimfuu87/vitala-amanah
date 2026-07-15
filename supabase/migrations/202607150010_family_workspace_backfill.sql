do $$
declare p record; hid uuid;
begin
  for p in select id,coalesce(nullif(full_name,''),'Family owner') as full_name from public.profiles where account_type='family' and household_id is null loop
    insert into public.households(name,created_by) values(p.full_name||'''s family',p.id) returning id into hid;
    insert into public.household_members(household_id,managed_by,user_id,display_name,relationship,member_type,role,status,can_view_household_assets)
    values(hid,p.id,p.id,p.full_name,'Self','adult','owner','active',true);
    update public.profiles set household_id=hid where id=p.id;
    update public.assets set household_id=hid where owner_id=p.id and household_id is null;
  end loop;
end $$;

-- A fictional managed spouse profile makes the demonstration workspace immediately testable.
insert into public.household_members(household_id,managed_by,display_name,relationship,member_type,role,status,can_view_household_assets)
select p.household_id,p.id,'Aisyah Rahman','Spouse','adult','member','active',true
from public.profiles p join auth.users u on u.id=p.id
where lower(u.email)='demo@vitala-amanah.app'
and not exists(select 1 from public.household_members m where m.household_id=p.household_id and m.display_name='Aisyah Rahman');
