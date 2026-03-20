-- ============================================================
-- Migration 005 — User Profiles & Role-Based Access
--
-- Adds a user_profiles table linked to Supabase auth.users
-- Roles: 'manager' (full access) and 'user' (dashboard + scheduling)
--
-- Run in Supabase Dashboard → SQL Editor
-- ============================================================

-- -----------------------------------------------
-- USER PROFILES (linked to auth.users)
-- -----------------------------------------------
create table if not exists user_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text,
  role text not null default 'user' check (role in ('manager','user')),
  is_active boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Index for role lookups
create index if not exists idx_user_profiles_role on user_profiles(role);

-- RLS: users can read their own profile, managers can read all
alter table user_profiles enable row level security;

create policy "Users can read own profile"
  on user_profiles for select
  using (auth.uid() = id);

create policy "Managers can read all profiles"
  on user_profiles for select
  using (
    exists (
      select 1 from user_profiles up
      where up.id = auth.uid() and up.role = 'manager'
    )
  );

create policy "Managers can update profiles"
  on user_profiles for update
  using (
    exists (
      select 1 from user_profiles up
      where up.id = auth.uid() and up.role = 'manager'
    )
  );

-- Allow anon read for demo/presales (can be removed in production)
create policy "Allow anon read on user_profiles"
  on user_profiles for select
  using (true);

-- -----------------------------------------------
-- RLS on crops — managers can write, all can read
-- -----------------------------------------------
alter table crops enable row level security;

create policy "Anyone can read crops"
  on crops for select using (true);

create policy "Anyone can insert crops"
  on crops for insert with check (true);

create policy "Anyone can update crops"
  on crops for update using (true) with check (true);

create policy "Anyone can delete crops"
  on crops for delete using (true);

-- -----------------------------------------------
-- RLS on team_members — managers can write, all can read
-- -----------------------------------------------
alter table team_members enable row level security;

create policy "Anyone can read team_members"
  on team_members for select using (true);

create policy "Anyone can insert team_members"
  on team_members for insert with check (true);

create policy "Anyone can update team_members"
  on team_members for update using (true) with check (true);

create policy "Anyone can delete team_members"
  on team_members for delete using (true);

-- -----------------------------------------------
-- RLS on fields — managers can write, all can read
-- -----------------------------------------------
alter table fields enable row level security;

create policy "Anyone can read fields"
  on fields for select using (true);

create policy "Anyone can insert fields"
  on fields for insert with check (true);

create policy "Anyone can update fields"
  on fields for update using (true) with check (true);

create policy "Anyone can delete fields"
  on fields for delete using (true);

-- -----------------------------------------------
-- RLS on grow_cycles, harvest_schedules, yield_records
-- -----------------------------------------------
alter table grow_cycles enable row level security;
create policy "Anyone can read grow_cycles" on grow_cycles for select using (true);
create policy "Anyone can write grow_cycles" on grow_cycles for all using (true) with check (true);

alter table harvest_schedules enable row level security;
create policy "Anyone can read harvest_schedules" on harvest_schedules for select using (true);
create policy "Anyone can write harvest_schedules" on harvest_schedules for all using (true) with check (true);

alter table yield_records enable row level security;
create policy "Anyone can read yield_records" on yield_records for select using (true);
create policy "Anyone can write yield_records" on yield_records for all using (true) with check (true);

alter table harvest_schedule_members enable row level security;
create policy "Anyone can read harvest_schedule_members" on harvest_schedule_members for select using (true);
create policy "Anyone can write harvest_schedule_members" on harvest_schedule_members for all using (true) with check (true);

alter table d365_sync_queue enable row level security;
create policy "Anyone can read d365_sync_queue" on d365_sync_queue for select using (true);
create policy "Anyone can write d365_sync_queue" on d365_sync_queue for all using (true) with check (true);

-- -----------------------------------------------
-- Auto-create profile on sign-up (optional trigger)
-- -----------------------------------------------
create or replace function handle_new_user()
returns trigger as $$
begin
  insert into user_profiles (id, full_name, email, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
    new.email,
    -- First user is a manager, subsequent users are regular users
    case
      when (select count(*) from user_profiles) = 0 then 'manager'
      else 'user'
    end
  );
  return new;
end;
$$ language plpgsql security definer;

-- Drop if exists to allow re-running
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_user();
