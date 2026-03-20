-- ============================================================
-- Grower Harvesting Dashboard — Supabase Schema
-- Run this against your Supabase SQL editor
-- ============================================================

-- Enable UUID generation
create extension if not exists "uuid-ossp";

-- -----------------------------------------------
-- TEAM MEMBERS
-- -----------------------------------------------
create table if not exists team_members (
  id uuid primary key default uuid_generate_v4(),
  full_name text not null,
  role text not null check (role in ('field_manager','harvester','planner','driver','quality_inspector')),
  email text unique,
  phone text,
  is_active boolean default true,
  created_at timestamptz default now()
);

-- -----------------------------------------------
-- FIELDS / GROWING LOCATIONS
-- -----------------------------------------------
create table if not exists fields (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  location text,
  area_acres numeric(10,2),
  soil_type text,
  status text not null default 'idle' check (status in ('idle','field_prep','planted','growing','harvest_ready','harvesting','complete')),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- -----------------------------------------------
-- CROPS / PRODUCTS
-- -----------------------------------------------
create table if not exists crops (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  variety text,
  avg_grow_days integer not null,
  lead_time_hours integer not null default 24,
  unit_of_measure text not null default 'lbs',
  target_yield_per_acre numeric(10,2),
  is_short_lead_time boolean generated always as (lead_time_hours <= 48) stored,
  created_at timestamptz default now()
);

-- -----------------------------------------------
-- GROW CYCLES
-- -----------------------------------------------
create table if not exists grow_cycles (
  id uuid primary key default uuid_generate_v4(),
  field_id uuid references fields(id) on delete cascade,
  crop_id uuid references crops(id) on delete cascade,
  phase text not null default 'field_prep' check (phase in ('field_prep','planting','growing','harvest_ready','harvesting','complete')),
  field_prep_date date,
  planting_date date,
  expected_harvest_date date,
  actual_harvest_date date,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- -----------------------------------------------
-- HARVEST SCHEDULES
-- -----------------------------------------------
create table if not exists harvest_schedules (
  id uuid primary key default uuid_generate_v4(),
  grow_cycle_id uuid references grow_cycles(id) on delete cascade,
  scheduled_date date not null,
  start_time time,
  end_time time,
  status text not null default 'scheduled' check (status in ('scheduled','in_progress','completed','cancelled')),
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- -----------------------------------------------
-- HARVEST SCHEDULE ↔ TEAM MEMBER (many-to-many)
-- -----------------------------------------------
create table if not exists harvest_schedule_members (
  id uuid primary key default uuid_generate_v4(),
  harvest_schedule_id uuid references harvest_schedules(id) on delete cascade,
  team_member_id uuid references team_members(id) on delete cascade,
  role_in_harvest text,
  unique(harvest_schedule_id, team_member_id)
);

-- -----------------------------------------------
-- YIELD RECORDS
-- -----------------------------------------------
create table if not exists yield_records (
  id uuid primary key default uuid_generate_v4(),
  grow_cycle_id uuid references grow_cycles(id) on delete cascade,
  harvest_schedule_id uuid references harvest_schedules(id),
  quantity numeric(12,2) not null,
  unit_of_measure text not null default 'lbs',
  grade text check (grade in ('A','B','C','reject')),
  recorded_at timestamptz default now(),
  notes text
);

-- -----------------------------------------------
-- D365 INTEGRATION STAGING TABLE
-- -----------------------------------------------
create table if not exists d365_sync_queue (
  id uuid primary key default uuid_generate_v4(),
  entity_type text not null check (entity_type in ('harvest','yield','inventory')),
  entity_id uuid not null,
  payload jsonb not null,
  status text not null default 'pending' check (status in ('pending','processing','synced','failed')),
  attempts integer default 0,
  last_error text,
  created_at timestamptz default now(),
  synced_at timestamptz
);

-- -----------------------------------------------
-- INDEXES for common queries
-- -----------------------------------------------
create index if not exists idx_grow_cycles_phase on grow_cycles(phase);
create index if not exists idx_grow_cycles_field on grow_cycles(field_id);
create index if not exists idx_harvest_schedules_date on harvest_schedules(scheduled_date);
create index if not exists idx_d365_sync_status on d365_sync_queue(status);
create index if not exists idx_yield_records_cycle on yield_records(grow_cycle_id);

-- -----------------------------------------------
-- SEED DATA — Sample team, fields, crops
-- -----------------------------------------------
insert into team_members (full_name, role, email) values
  ('Maria Gonzalez', 'field_manager', 'maria@example.com'),
  ('James Chen', 'harvester', 'james@example.com'),
  ('Priya Patel', 'planner', 'priya@example.com'),
  ('Carlos Rivera', 'driver', 'carlos@example.com'),
  ('Aisha Johnson', 'quality_inspector', 'aisha@example.com');

insert into fields (name, location, area_acres, soil_type, status) values
  ('North Ridge A', 'Block A, North Campus', 12.5, 'Loam', 'growing'),
  ('South Valley B', 'Block B, South Campus', 8.0, 'Sandy Loam', 'planted'),
  ('East Terrace C', 'Block C, East Campus', 15.0, 'Clay Loam', 'harvest_ready'),
  ('West Plain D', 'Block D, West Campus', 10.0, 'Silt Loam', 'field_prep');

insert into crops (name, variety, avg_grow_days, lead_time_hours, unit_of_measure, target_yield_per_acre) values
  ('Baby Spinach', 'Bloomsdale', 21, 12, 'lbs', 800),
  ('Microgreens Mix', 'Spring Blend', 10, 6, 'lbs', 200),
  ('Romaine Lettuce', 'Parris Island', 55, 24, 'lbs', 1200),
  ('Cherry Tomatoes', 'Sun Gold', 75, 48, 'lbs', 3000),
  ('Fresh Herbs', 'Basil/Cilantro', 30, 8, 'bunches', 500);

-- Sample grow cycles
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date)
select
  f.id, c.id,
  case f.status
    when 'growing' then 'growing'
    when 'planted' then 'planting'
    when 'harvest_ready' then 'harvest_ready'
    when 'field_prep' then 'field_prep'
    else 'field_prep'
  end,
  current_date - interval '30 days',
  current_date - interval '20 days',
  current_date + interval '5 days'
from fields f
cross join lateral (select id from crops order by random() limit 1) c;

-- Sample harvest schedules
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status)
select
  gc.id,
  gc.expected_harvest_date,
  '06:00'::time,
  '14:00'::time,
  'scheduled'
from grow_cycles gc
where gc.phase = 'harvest_ready';

-- Sample yield records
insert into yield_records (grow_cycle_id, quantity, unit_of_measure, grade)
values
  ((select id from grow_cycles limit 1), 2400, 'lbs', 'A'),
  ((select id from grow_cycles limit 1), 800, 'lbs', 'B');

-- Sample D365 sync queue items
insert into d365_sync_queue (entity_type, entity_id, payload, status)
select 'yield', yr.id, jsonb_build_object('quantity', yr.quantity, 'grade', yr.grade, 'unit', yr.unit_of_measure), 'pending'
from yield_records yr limit 2;
