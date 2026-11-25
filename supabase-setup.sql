-- Storm Season Kit: one private row per signed-in person.
-- Run once in Supabase: SQL Editor > New query > paste > Run.

create table if not exists public.user_state (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Row-level security: each person can only see and change their own row.
alter table public.user_state enable row level security;

create policy "Read own list"   on public.user_state for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "Create own list" on public.user_state for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "Update own list" on public.user_state for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "Delete own list" on public.user_state for delete to authenticated
  using ((select auth.uid()) = user_id);
