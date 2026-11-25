-- Storm Season Kit: one private row per signed-in person.
-- Safe to run in a Supabase project that other sites already use:
-- it only creates its own table and policies (all named storm_kit...),
-- drops nothing and changes no existing tables, policies or functions.
-- Run once in Supabase: SQL Editor > New query > paste > Run. Running it again is harmless.

create table if not exists public.storm_kit_user_state (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Signed-in users may use the table (row-level security below limits them to their own row).
-- Signed-out visitors get no access at all.
grant select, insert, update, delete on public.storm_kit_user_state to authenticated;

-- Row-level security: each person can only see and change their own row.
alter table public.storm_kit_user_state enable row level security;

do $$
begin
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'storm_kit_user_state' and policyname = 'storm_kit_read_own') then
    create policy storm_kit_read_own on public.storm_kit_user_state for select to authenticated
      using ((select auth.uid()) = user_id);
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'storm_kit_user_state' and policyname = 'storm_kit_insert_own') then
    create policy storm_kit_insert_own on public.storm_kit_user_state for insert to authenticated
      with check ((select auth.uid()) = user_id);
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'storm_kit_user_state' and policyname = 'storm_kit_update_own') then
    create policy storm_kit_update_own on public.storm_kit_user_state for update to authenticated
      using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'storm_kit_user_state' and policyname = 'storm_kit_delete_own') then
    create policy storm_kit_delete_own on public.storm_kit_user_state for delete to authenticated
      using ((select auth.uid()) = user_id);
  end if;
end $$;
