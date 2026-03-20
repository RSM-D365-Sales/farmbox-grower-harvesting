-- ============================================================
-- Migration 005 — App Users & Role-Based Access
--
-- Roles:
--   manager  — Full access: manage crops, team, fields, + everything below
--   operator — Can view dashboard, create grow cycles, schedules, yields
-- ============================================================

-- -----------------------------------------------
-- APP USERS (simple role table, no Supabase Auth dependency)
-- -----------------------------------------------
create table if not exists app_users (
  id uuid primary key default uuid_generate_v4(),
  email text not null unique,
  full_name text not null,
  role text not null default 'operator' check (role in ('manager', 'operator')),
  is_active boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists idx_app_users_email on app_users(email);
create index if not exists idx_app_users_role on app_users(role);

-- -----------------------------------------------
-- SEED — Default manager account
-- -----------------------------------------------
insert into app_users (email, full_name, role) values
  ('admin@grower.local', 'Admin Manager', 'manager'),
  ('operator@grower.local', 'Default Operator', 'operator')
on conflict (email) do nothing;

-- -----------------------------------------------
-- RLS for app_users
-- -----------------------------------------------
alter table app_users enable row level security;

create policy "Allow anonymous read on app_users"
  on app_users for select using (true);

create policy "Allow all on app_users"
  on app_users for all using (true) with check (true);

-- -----------------------------------------------
-- RLS for crops (allow read for all, write for all via service)
-- -----------------------------------------------
alter table crops enable row level security;

create policy "Allow anonymous read on crops"
  on crops for select using (true);

create policy "Allow all on crops"
  on crops for all using (true) with check (true);

-- -----------------------------------------------
-- RLS for fields
-- -----------------------------------------------
alter table fields enable row level security;

create policy "Allow anonymous read on fields"
  on fields for select using (true);

create policy "Allow all on fields"
  on fields for all using (true) with check (true);

-- -----------------------------------------------
-- RLS for team_members
-- -----------------------------------------------
alter table team_members enable row level security;

create policy "Allow anonymous read on team_members"
  on team_members for select using (true);

create policy "Allow all on team_members"
  on team_members for all using (true) with check (true);

-- -----------------------------------------------
-- RLS for grow_cycles
-- -----------------------------------------------
alter table grow_cycles enable row level security;

create policy "Allow anonymous read on grow_cycles"
  on grow_cycles for select using (true);

create policy "Allow all on grow_cycles"
  on grow_cycles for all using (true) with check (true);

-- -----------------------------------------------
-- RLS for harvest_schedules
-- -----------------------------------------------
alter table harvest_schedules enable row level security;

create policy "Allow anonymous read on harvest_schedules"
  on harvest_schedules for select using (true);

create policy "Allow all on harvest_schedules"
  on harvest_schedules for all using (true) with check (true);

-- -----------------------------------------------
-- RLS for yield_records
-- -----------------------------------------------
alter table yield_records enable row level security;

create policy "Allow anonymous read on yield_records"
  on yield_records for select using (true);

create policy "Allow all on yield_records"
  on yield_records for all using (true) with check (true);

-- -----------------------------------------------
-- RLS for harvest_schedule_members
-- -----------------------------------------------
alter table harvest_schedule_members enable row level security;

create policy "Allow anonymous read on harvest_schedule_members"
  on harvest_schedule_members for select using (true);

create policy "Allow all on harvest_schedule_members"
  on harvest_schedule_members for all using (true) with check (true);
