create table if not exists public.family_links (
  id uuid primary key default gen_random_uuid(),
  member_id uuid not null unique references auth.users (id) on delete cascade,
  guardian_id uuid references auth.users (id) on delete cascade,
  link_code text unique,
  expires_at timestamptz,
  created_at timestamptz not null default now(),
  constraint family_link_members_are_distinct
    check (guardian_id is null or guardian_id <> member_id),
  constraint family_link_code_state
    check (
      (guardian_id is null and link_code is not null and expires_at is not null)
      or (guardian_id is not null and link_code is null and expires_at is null)
    )
);

create table if not exists public.family_alerts (
  id uuid primary key default gen_random_uuid(),
  member_id uuid not null references auth.users (id) on delete cascade,
  guardian_id uuid not null references auth.users (id) on delete cascade,
  message text not null check (char_length(message) between 1 and 1000),
  created_at timestamptz not null default now(),
  constraint family_alert_members_are_distinct
    check (guardian_id <> member_id)
);

create index if not exists family_alerts_guardian_created_at_idx
  on public.family_alerts (guardian_id, created_at desc);

alter table public.family_links enable row level security;
alter table public.family_alerts enable row level security;

create policy "Family members can read their link"
  on public.family_links for select
  to authenticated
  using (auth.uid() = member_id or auth.uid() = guardian_id);

create policy "Family members can read received alerts"
  on public.family_alerts for select
  to authenticated
  using (auth.uid() = guardian_id);

create policy "Linked members can send alerts"
  on public.family_alerts for insert
  to authenticated
  with check (
    auth.uid() = member_id
    and exists (
      select 1
      from public.family_links
      where family_links.member_id = auth.uid()
        and family_links.guardian_id = family_alerts.guardian_id
    )
  );

create or replace function public.create_family_link()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  new_code text := upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 12));
  link_expiry timestamptz := now() + interval '30 minutes';
  link_id uuid;
begin
  if auth.uid() is null then
    raise exception 'Sign in is required to create a family link.';
  end if;

  insert into public.family_links (member_id, link_code, expires_at)
  values (auth.uid(), new_code, link_expiry)
  on conflict (member_id) do update
    set link_code = excluded.link_code,
        expires_at = excluded.expires_at
    where public.family_links.guardian_id is null
  returning id into link_id;

  if link_id is null then
    raise exception 'This account is already linked to a guardian.';
  end if;

  return jsonb_build_object('code', new_code, 'expires_at', link_expiry);
end;
$$;

create or replace function public.join_family_link(p_code text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  linked_id uuid;
begin
  if auth.uid() is null then
    raise exception 'Sign in is required to join a family link.';
  end if;

  update public.family_links
  set guardian_id = auth.uid(),
      link_code = null,
      expires_at = null
  where link_code = upper(trim(p_code))
    and expires_at > now()
    and guardian_id is null
    and member_id <> auth.uid()
  returning id into linked_id;

  if linked_id is null then
    raise exception 'The code is invalid, expired, or already used.';
  end if;

  return linked_id;
end;
$$;

revoke all on function public.create_family_link() from public;
revoke all on function public.join_family_link(text) from public;
grant execute on function public.create_family_link() to authenticated;
grant execute on function public.join_family_link(text) to authenticated;
grant select on public.family_links to authenticated;
grant select, insert on public.family_alerts to authenticated;
