-- ============================================================
-- Migration 008 — FarmBox Greens Hydroponic Seed Data
-- FarmBox Greens (a Charlie's Produce company, acquired 2016)
-- 100% indoor hydroponic greens — Seattle, WA
-- ============================================================

-- -----------------------------------------------
-- Clear all existing sample data for a clean demo
-- (order matters due to foreign keys)
-- -----------------------------------------------
delete from d365_sync_queue;
delete from d365_inventory_onhand;
delete from d365_production_orders;
delete from d365_sales_orders;
delete from d365_customers;
delete from d365_warehouses;
delete from d365_products;
delete from yield_records;
delete from harvest_schedule_members;
delete from harvest_schedules;
delete from grow_cycles;
delete from crops;
delete from fields;
delete from team_members;

-- -----------------------------------------------
-- TEAM MEMBERS — FarmBox Greens Team
-- -----------------------------------------------
insert into team_members (full_name, role, email, phone) values
  ('Sarah Mitchell',   'field_manager',      'sarah.mitchell@farmboxgreens.com',   '206-555-2001'),
  ('David Nguyen',     'harvester',          'david.nguyen@farmboxgreens.com',     '206-555-2002'),
  ('Elena Vasquez',    'harvester',          'elena.vasquez@farmboxgreens.com',    '206-555-2003'),
  ('Marcus Thompson',  'planner',            'marcus.thompson@farmboxgreens.com',  '206-555-2004'),
  ('Lisa Park',        'quality_inspector',  'lisa.park@farmboxgreens.com',        '206-555-2005'),
  ('Jake Williams',    'driver',             'jake.williams@farmboxgreens.com',    '206-555-2006'),
  ('Amara Osei',       'harvester',          'amara.osei@farmboxgreens.com',       '206-555-2007'),
  ('Ryan Cooper',      'field_manager',      'ryan.cooper@farmboxgreens.com',      '206-555-2008');

-- -----------------------------------------------
-- FIELDS / GROWING ZONES — Indoor Hydroponic Facility
-- All hydroponic — no outdoor soil-based fields
-- Facility located in Seattle, WA (Georgetown)
-- area_acres stores canopy square footage for indoor operations
-- soil_type stores grow method (NFT, DWC, etc.)
-- -----------------------------------------------
insert into fields (name, location, area_acres, soil_type, status) values
  -- Greenhouse 1 — Living Lettuce Production (NFT channels, single level, ~30×40 ft bays)
  ('GH-1 Bay A — Living Lettuce',     'Greenhouse 1, NFT Channels West',      1200, 'NFT Hydroponic',       'growing'),
  ('GH-1 Bay B — Living Lettuce',     'Greenhouse 1, NFT Channels East',      1200, 'NFT Hydroponic',       'harvest_ready'),
  -- Greenhouse 2 — Deep Water Culture (DWC rafts for baby greens, single level, ~24×40 ft bays)
  ('GH-2 Bay A — Baby Greens',        'Greenhouse 2, DWC Rafts North',         960, 'DWC Hydroponic',       'growing'),
  ('GH-2 Bay B — Baby Greens',        'Greenhouse 2, DWC Rafts South',         960, 'DWC Hydroponic',       'harvest_ready'),
  -- Greenhouse 3 — Herbs (NFT / drip, single level, ~20×32 ft)
  ('GH-3 — Living Herbs',             'Greenhouse 3, NFT Drip System',         640, 'NFT Hydroponic',       'growing'),
  -- Microgreens Room — Vertical rack systems (4 levels × 150 sq ft floor = 600 sq ft canopy per room)
  ('Micro Room A — Vertical Racks',   'Indoor Climate Room A, Racks 1-6',      600, 'Vertical Racks / Coco Coir', 'harvesting'),
  ('Micro Room B — Vertical Racks',   'Indoor Climate Room B, Racks 1-6',      600, 'Vertical Racks / Coco Coir', 'growing'),
  -- Propagation (seedling nursery, ~16×20 ft)
  ('Propagation House',               'Seedling Nursery, Germination Chamber',  320, 'Rockwool Cubes',       'planted'),
  -- Expansion (matching GH-2 bay size)
  ('GH-4 — Expansion Bay',            'Greenhouse 4, New Build',                960, 'NFT Hydroponic',       'field_prep'),
  ('Cold Storage Staging',            'Pack House, Pre-Ship Staging',            480, 'N/A — Storage',        'idle');

-- -----------------------------------------------
-- CROPS — Living Lettuce (sold with roots on)
-- target_yield_per_acre stores yield per sq ft of canopy per cycle
-- Living lettuce: heads/sqft/cycle (6" spacing in NFT = ~2 heads/sqft)
-- -----------------------------------------------
insert into crops (name, variety, avg_grow_days, lead_time_hours, unit_of_measure, target_yield_per_acre) values
  ('Living Butter Lettuce',     'Bibb / Boston',            35,  18, 'heads',  2.00),
  ('Living Green Leaf Lettuce', 'Green Star',               32,  18, 'heads',  1.80),
  ('Living Red Leaf Lettuce',   'Red Sails',                33,  18, 'heads',  1.80),
  ('Living Romaine Hearts',     'Coastal Star',             38,  24, 'heads',  1.50),
  ('Living Red Oakleaf',        'Super Red',                34,  18, 'heads',  1.80);

-- -----------------------------------------------
-- CROPS — Baby Greens (cut product)
-- lbs/sqft/cycle — DWC dense-seeded, single cut
-- -----------------------------------------------
insert into crops (name, variety, avg_grow_days, lead_time_hours, unit_of_measure, target_yield_per_acre) values
  ('Baby Arugula',              'Astro',                    18,  12, 'lbs',    0.30),
  ('Baby Spinach',              'Bloomsdale',               20,  12, 'lbs',    0.28),
  ('Spring Mix',                'Mesclun Blend',            21,  12, 'lbs',    0.25),
  ('Baby Kale Mix',             'Red Russian / Lacinato',   22,  14, 'lbs',    0.22),
  ('Baby Bok Choy',             'Shanghai Baby',            20,  12, 'lbs',    0.25);

-- -----------------------------------------------
-- CROPS — Living Herbs
-- heads or bunches per sqft per cycle
-- -----------------------------------------------
insert into crops (name, variety, avg_grow_days, lead_time_hours, unit_of_measure, target_yield_per_acre) values
  ('Living Basil',              'Genovese',                 28,  14, 'heads',  2.50),
  ('Living Cilantro',           'Santo',                    25,  12, 'bunches', 0.35),
  ('Living Mint',               'Spearmint',                30,  14, 'heads',  2.00),
  ('Living Dill',               'Bouquet',                  28,  14, 'bunches', 0.30);

-- -----------------------------------------------
-- CROPS — Microgreens (high-value, fast turn)
-- lbs/sqft/cycle — 1020 trays on vertical racks
-- Industry benchmark: 0.25–0.35 lbs/sqft per harvest
-- -----------------------------------------------
insert into crops (name, variety, avg_grow_days, lead_time_hours, unit_of_measure, target_yield_per_acre) values
  ('Microgreens — Pea Shoots',    'Speckled Pea',            10,   6, 'lbs',   0.35),
  ('Microgreens — Sunflower',     'Black Oil Sunflower',      9,   6, 'lbs',   0.30),
  ('Microgreens — Radish',        'China Rose',               8,   6, 'lbs',   0.28),
  ('Microgreens — Broccoli',      'Calabrese',               10,   6, 'lbs',   0.25),
  ('Microgreens — Rainbow Mix',   'FarmBox Signature Blend',  10,   6, 'lbs',   0.30);

-- -----------------------------------------------
-- GROW CYCLES — Active cycles across hydroponic zones
-- -----------------------------------------------

-- Living Lettuce — GH-1 Bay A (growing, ~2 weeks from harvest)
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '22 days',
  current_date - interval '20 days',
  current_date + interval '15 days',
  'NFT channels — pH 5.8, EC 1.2 mS/cm — healthy root development'
from fields f, crops c
where f.name = 'GH-1 Bay A — Living Lettuce' and c.name = 'Living Butter Lettuce';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '18 days',
  current_date - interval '16 days',
  current_date + interval '16 days',
  'NFT channels — transplanted from propagation house'
from fields f, crops c
where f.name = 'GH-1 Bay A — Living Lettuce' and c.name = 'Living Green Leaf Lettuce';

-- Living Lettuce — GH-1 Bay B (harvest ready)
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvest_ready',
  current_date - interval '37 days',
  current_date - interval '35 days',
  current_date,
  'Full heads formed — roots healthy — ready for live pack'
from fields f, crops c
where f.name = 'GH-1 Bay B — Living Lettuce' and c.name = 'Living Butter Lettuce';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvest_ready',
  current_date - interval '35 days',
  current_date - interval '33 days',
  current_date + interval '1 day',
  'Red oakleaf at ideal size — vibrant color'
from fields f, crops c
where f.name = 'GH-1 Bay B — Living Lettuce' and c.name = 'Living Red Oakleaf';

-- Baby Greens — GH-2 Bay A (growing)
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '12 days',
  current_date - interval '10 days',
  current_date + interval '8 days',
  'DWC rafts — dense seeding — first true leaves emerging'
from fields f, crops c
where f.name = 'GH-2 Bay A — Baby Greens' and c.name = 'Baby Arugula';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '10 days',
  current_date - interval '8 days',
  current_date + interval '12 days',
  'DWC rafts — good germination rate, thinning not needed'
from fields f, crops c
where f.name = 'GH-2 Bay A — Baby Greens' and c.name = 'Baby Spinach';

-- Baby Greens — GH-2 Bay B (harvest ready)
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvest_ready',
  current_date - interval '24 days',
  current_date - interval '21 days',
  current_date,
  'Spring mix at target 3-inch height — cut today'
from fields f, crops c
where f.name = 'GH-2 Bay B — Baby Greens' and c.name = 'Spring Mix';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvest_ready',
  current_date - interval '25 days',
  current_date - interval '22 days',
  current_date + interval '1 day',
  'Baby kale tender and ready — second cut possible in 10 days'
from fields f, crops c
where f.name = 'GH-2 Bay B — Baby Greens' and c.name = 'Baby Kale Mix';

-- Living Herbs — GH-3 (growing)
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '18 days',
  current_date - interval '15 days',
  current_date + interval '13 days',
  'Living basil — pinch-pruned last week, branching well'
from fields f, crops c
where f.name = 'GH-3 — Living Herbs' and c.name = 'Living Basil';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '14 days',
  current_date - interval '12 days',
  current_date + interval '13 days',
  'Cilantro — steady growth, no bolting detected'
from fields f, crops c
where f.name = 'GH-3 — Living Herbs' and c.name = 'Living Cilantro';

-- Microgreens — Room A (harvesting, fast cycle)
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvesting',
  current_date - interval '12 days',
  current_date - interval '10 days',
  current_date - interval '1 day',
  'Pea shoots at 4-inch height — daily cutting in progress'
from fields f, crops c
where f.name = 'Micro Room A — Vertical Racks' and c.name = 'Microgreens — Pea Shoots';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvesting',
  current_date - interval '11 days',
  current_date - interval '9 days',
  current_date,
  'Sunflower micros — cotyledon stage, shells dropped — harvest now'
from fields f, crops c
where f.name = 'Micro Room A — Vertical Racks' and c.name = 'Microgreens — Sunflower';

-- Microgreens — Room B (growing, next batch)
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '5 days',
  current_date - interval '3 days',
  current_date + interval '5 days',
  'Radish micros — germination complete, blackout phase ending'
from fields f, crops c
where f.name = 'Micro Room B — Vertical Racks' and c.name = 'Microgreens — Radish';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '4 days',
  current_date - interval '2 days',
  current_date + interval '8 days',
  'Rainbow mix — staggered tray seeding for continuous supply'
from fields f, crops c
where f.name = 'Micro Room B — Vertical Racks' and c.name = 'Microgreens — Rainbow Mix';

-- Propagation House — seedlings for transplant
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'planting',
  current_date - interval '5 days',
  current_date - interval '3 days',
  null,
  'Romaine plugs in rockwool — will transplant to GH-1 in 10 days'
from fields f, crops c
where f.name = 'Propagation House' and c.name = 'Living Romaine Hearts';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'planting',
  current_date - interval '4 days',
  current_date - interval '2 days',
  null,
  'Red leaf plugs — germination at 95% — healthy seedlings'
from fields f, crops c
where f.name = 'Propagation House' and c.name = 'Living Red Leaf Lettuce';

-- Expansion Bay — field prep
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'field_prep',
  current_date - interval '3 days',
  null,
  null,
  'Installing new NFT channels and plumbing for mint production'
from fields f, crops c
where f.name = 'GH-4 — Expansion Bay' and c.name = 'Living Mint';

-- -----------------------------------------------
-- HARVEST SCHEDULES — for harvest_ready & harvesting cycles
-- -----------------------------------------------

-- Living Butter Lettuce — GH-1 Bay B (harvest ready)
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date, '05:00'::time, '09:00'::time, 'scheduled',
  'Pull living heads with roots — pack in clamshells for Charlie''s morning truck'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'GH-1 Bay B — Living Lettuce' and c.name = 'Living Butter Lettuce';

-- Living Red Oakleaf — GH-1 Bay B
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date + interval '1 day', '05:00'::time, '08:00'::time, 'scheduled',
  'Harvest for PCC Natural Markets weekly order'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'GH-1 Bay B — Living Lettuce' and c.name = 'Living Red Oakleaf';

-- Spring Mix — GH-2 Bay B (harvest ready)
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date, '06:00'::time, '10:00'::time, 'scheduled',
  'Cut at 3-inch — wash and spin dry — pack 1-lb clamshells'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'GH-2 Bay B — Baby Greens' and c.name = 'Spring Mix';

-- Baby Kale — GH-2 Bay B
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date + interval '1 day', '06:00'::time, '09:00'::time, 'scheduled',
  'First cut — leave crowns for regrowth'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'GH-2 Bay B — Baby Greens' and c.name = 'Baby Kale Mix';

-- Pea Shoots — Micro Room A (in progress)
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date, '04:30'::time, '07:00'::time, 'in_progress',
  'Daily harvest — racks 1-3 complete, racks 4-6 underway'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'Micro Room A — Vertical Racks' and c.name = 'Microgreens — Pea Shoots';

-- Sunflower Micros — Micro Room A (scheduled)
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date, '07:00'::time, '09:00'::time, 'scheduled',
  'Harvest after pea shoots — pack in 4 oz and 1 lb containers'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'Micro Room A — Vertical Racks' and c.name = 'Microgreens — Sunflower';

-- Completed harvest — historical (Spring Mix last week)
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date - interval '7 days', '05:30'::time, '10:00'::time, 'completed',
  'Full cut — 240 lbs spring mix packed and shipped to Charlie''s DC'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'GH-2 Bay B — Baby Greens' and c.name = 'Spring Mix';

-- Cancelled harvest — weather/power delay
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date - interval '2 days', '05:00'::time, '09:00'::time, 'cancelled',
  'Power outage at facility — rescheduled to accommodate EC level adjustment'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'GH-1 Bay A — Living Lettuce' and c.name = 'Living Butter Lettuce';

-- -----------------------------------------------
-- HARVEST SCHEDULE MEMBERS — assign teams
-- -----------------------------------------------

-- Sarah (lead) + David + Elena on Butter Lettuce harvest
insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'lead'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Living Butter Lettuce' and hs.status = 'scheduled'
  and hs.scheduled_date = current_date and tm.full_name = 'Sarah Mitchell';

insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'harvester'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Living Butter Lettuce' and hs.status = 'scheduled'
  and hs.scheduled_date = current_date and tm.full_name = 'David Nguyen';

insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'harvester'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Living Butter Lettuce' and hs.status = 'scheduled'
  and hs.scheduled_date = current_date and tm.full_name = 'Elena Vasquez';

-- Lisa (QC) on spring mix harvest
insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'quality_check'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Spring Mix' and hs.status = 'scheduled' and tm.full_name = 'Lisa Park';

insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'harvester'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Spring Mix' and hs.status = 'scheduled' and tm.full_name = 'Amara Osei';

-- Ryan (lead) + David on pea shoot harvest (in_progress)
insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'lead'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Microgreens — Pea Shoots' and hs.status = 'in_progress' and tm.full_name = 'Ryan Cooper';

insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'harvester'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Microgreens — Pea Shoots' and hs.status = 'in_progress' and tm.full_name = 'Amara Osei';

-- Jake (driver) on butter lettuce for delivery coordination
insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'delivery'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Living Butter Lettuce' and hs.status = 'scheduled'
  and hs.scheduled_date = current_date and tm.full_name = 'Jake Williams';

-- -----------------------------------------------
-- YIELD RECORDS — historical yields
-- -----------------------------------------------

-- Completed spring mix harvest yield
insert into yield_records (grow_cycle_id, harvest_schedule_id, quantity, unit_of_measure, grade, notes)
select gc.id, hs.id, 240, 'lbs', 'A', 'Premium spring mix — consistent leaf size, no yellowing'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
where c.name = 'Spring Mix' and hs.status = 'completed'
limit 1;

insert into yield_records (grow_cycle_id, harvest_schedule_id, quantity, unit_of_measure, grade, notes)
select gc.id, hs.id, 18, 'lbs', 'B', 'Slightly oversized leaves — sold to juice processor'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
where c.name = 'Spring Mix' and hs.status = 'completed'
limit 1;

-- Pea shoot in-progress yield
insert into yield_records (grow_cycle_id, harvest_schedule_id, quantity, unit_of_measure, grade, notes)
select gc.id, hs.id, 42, 'lbs', 'A', 'Morning cut — racks 1-3, crisp tendrils'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
where c.name = 'Microgreens — Pea Shoots' and hs.status = 'in_progress'
limit 1;

-- Historical standalone yields
insert into yield_records (grow_cycle_id, quantity, unit_of_measure, grade, recorded_at, notes)
select gc.id, 2400, 'heads', 'A', now() - interval '10 days', 'Living butter lettuce — full bay harvest, excellent root mass'
from grow_cycles gc
join crops c on gc.crop_id = c.id
where c.name = 'Living Butter Lettuce'
limit 1;

insert into yield_records (grow_cycle_id, quantity, unit_of_measure, grade, recorded_at, notes)
select gc.id, 280, 'lbs', 'A', now() - interval '5 days', 'Baby arugula — peppery flavor, ideal leaf size'
from grow_cycles gc
join crops c on gc.crop_id = c.id
where c.name = 'Baby Arugula'
limit 1;

insert into yield_records (grow_cycle_id, quantity, unit_of_measure, grade, recorded_at, notes)
select gc.id, 55, 'lbs', 'A', now() - interval '3 days', 'Sunflower micros — nutty crunch, bright green'
from grow_cycles gc
join crops c on gc.crop_id = c.id
where c.name = 'Microgreens — Sunflower'
limit 1;

-- -----------------------------------------------
-- D365 SYNC QUEUE — pending sync items
-- -----------------------------------------------
insert into d365_sync_queue (entity_type, entity_id, payload, status)
select 'yield', yr.id,
  jsonb_build_object(
    'quantity', yr.quantity,
    'grade', yr.grade,
    'unit', yr.unit_of_measure,
    'notes', yr.notes
  ),
  'pending'
from yield_records yr
order by yr.recorded_at desc
limit 3;

-- -----------------------------------------------
-- D365 PRODUCTS — FarmBox Greens hydroponic catalog
-- All items are hydroponic greens / herbs / microgreens
-- -----------------------------------------------
insert into d365_products (d365_item_number, product_name, product_type, item_group, inventory_unit, sales_unit, sales_price, tracking_dimension_group, shelf_life_days, buyer_group) values
  -- Living Lettuce
  ('FB-LBUT-001', 'Living Butter Lettuce',           'Item', 'Living Lettuce',   'heads', 'heads',  2.50, 'Batch', 14, 'Living Greens'),
  ('FB-LGRN-001', 'Living Green Leaf Lettuce',       'Item', 'Living Lettuce',   'heads', 'heads',  2.25, 'Batch', 14, 'Living Greens'),
  ('FB-LRED-001', 'Living Red Leaf Lettuce',         'Item', 'Living Lettuce',   'heads', 'heads',  2.50, 'Batch', 14, 'Living Greens'),
  ('FB-LROM-001', 'Living Romaine Hearts',           'Item', 'Living Lettuce',   'heads', 'heads',  2.75, 'Batch', 12, 'Living Greens'),
  ('FB-LOAK-001', 'Living Red Oakleaf',              'Item', 'Living Lettuce',   'heads', 'heads',  2.50, 'Batch', 14, 'Living Greens'),
  -- Baby Greens
  ('FB-ARUG-001', 'Baby Arugula - Hydroponic',       'Item', 'Baby Greens',      'lbs', 'lbs',     5.50, 'Batch',  7, 'Baby Greens'),
  ('FB-SPIN-001', 'Baby Spinach - Hydroponic',       'Item', 'Baby Greens',      'lbs', 'lbs',     5.00, 'Batch',  7, 'Baby Greens'),
  ('FB-SPRM-001', 'Spring Mix - Hydroponic',         'Item', 'Baby Greens',      'lbs', 'lbs',     6.00, 'Batch',  7, 'Baby Greens'),
  ('FB-KALE-001', 'Baby Kale Mix - Hydroponic',      'Item', 'Baby Greens',      'lbs', 'lbs',     5.50, 'Batch',  7, 'Baby Greens'),
  ('FB-BOKC-001', 'Baby Bok Choy - Hydroponic',      'Item', 'Baby Greens',      'lbs', 'lbs',     4.50, 'Batch',  7, 'Baby Greens'),
  -- Living Herbs
  ('FB-LBAS-001', 'Living Basil - Genovese',         'Item', 'Living Herbs',     'heads', 'heads',  3.00, 'Batch', 10, 'Living Herbs'),
  ('FB-LCIL-001', 'Living Cilantro',                 'Item', 'Living Herbs',     'bunches', 'bunches', 2.75, 'Batch', 10, 'Living Herbs'),
  ('FB-LMNT-001', 'Living Mint - Spearmint',         'Item', 'Living Herbs',     'heads', 'heads',  3.25, 'Batch', 10, 'Living Herbs'),
  ('FB-LDIL-001', 'Living Dill',                     'Item', 'Living Herbs',     'bunches', 'bunches', 2.75, 'Batch', 10, 'Living Herbs'),
  -- Microgreens
  ('FB-MPEA-001', 'Microgreens - Pea Shoots',        'Item', 'Microgreens',      'lbs', 'lbs',    14.00, 'Batch',  5, 'Microgreens'),
  ('FB-MSUN-001', 'Microgreens - Sunflower',         'Item', 'Microgreens',      'lbs', 'lbs',    16.00, 'Batch',  5, 'Microgreens'),
  ('FB-MRAD-001', 'Microgreens - Radish',            'Item', 'Microgreens',      'lbs', 'lbs',    15.00, 'Batch',  5, 'Microgreens'),
  ('FB-MBRC-001', 'Microgreens - Broccoli',          'Item', 'Microgreens',      'lbs', 'lbs',    18.00, 'Batch',  5, 'Microgreens'),
  ('FB-MRNB-001', 'Microgreens - Rainbow Mix',       'Item', 'Microgreens',      'lbs', 'lbs',    16.00, 'Batch',  5, 'Microgreens');

-- -----------------------------------------------
-- D365 CUSTOMERS — Charlie's Produce PNW accounts
-- -----------------------------------------------
insert into d365_customers (d365_customer_account, customer_name, customer_group, currency_code, payment_terms, delivery_mode, primary_contact) values
  ('CUST-001', 'PCC Community Markets',              'Retail - Grocery', 'USD', 'Net30',  'Charlie''s Truck',       'Produce Buyer - PCC'),
  ('CUST-002', 'Metropolitan Market',                 'Retail - Grocery', 'USD', 'Net30',  'Charlie''s Truck',       'Local Buyer - Metro'),
  ('CUST-003', 'Canlis Restaurant',                   'Restaurant',       'USD', 'Net15',  'Direct Delivery',        'Chef Brady Williams'),
  ('CUST-004', 'The Walrus and the Carpenter',        'Restaurant',       'USD', 'Net15',  'Direct Delivery',        'Chef Renee Erickson'),
  ('CUST-005', 'University Village Whole Foods',      'Retail - National','USD', 'Net30',  'Charlie''s Truck',       'Regional Produce Buyer'),
  ('CUST-006', 'Amazon Fresh - PNW',                  'E-Commerce',       'USD', 'Net30',  'Carrier Pickup',         'Vendor Relations'),
  ('CUST-007', 'Fred Meyer / Kroger NW',              'Retail - National','USD', 'Net45',  'Charlie''s Truck',       'Category Manager - Produce'),
  ('CUST-008', 'Seattle Public Schools Nutrition',    'Institutional',    'USD', 'Net30',  'Scheduled Delivery',     'Director of Nutrition'),
  ('CUST-009', 'Ballard Farmers Market',              'Farmers Market',   'USD', 'COD',    'Booth Delivery',         'Market Coordinator'),
  ('CUST-010', 'Charlie''s Produce - Distribution',   'Internal',         'USD', 'Net60',  'Internal Transfer',      'DC Operations Manager');

-- -----------------------------------------------
-- D365 WAREHOUSES — FarmBox / Charlie's Produce locations
-- -----------------------------------------------
insert into d365_warehouses (d365_warehouse_id, warehouse_name, site_id, is_default, address_city, address_state) values
  ('WH-GH',    'FarmBox Greens Greenhouse Facility',  'SITE-FB', true,  'Seattle',    'WA'),
  ('WH-PACK',  'FarmBox Pack House & Cold Storage',   'SITE-FB', false, 'Seattle',    'WA'),
  ('WH-CPC',   'Charlie''s Produce - Seattle DC',     'SITE-CP', false, 'Seattle',    'WA'),
  ('WH-CPP',   'Charlie''s Produce - Portland DC',    'SITE-CP', false, 'Portland',   'OR');

-- -----------------------------------------------
-- D365 SALES ORDERS — upcoming demand (PNW customers)
-- -----------------------------------------------
insert into d365_sales_orders (d365_sales_order_number, line_number, customer_account, customer_name, item_number, item_name, ordered_quantity, delivered_quantity, remaining_quantity, unit, requested_ship_date, warehouse_id, order_status) values
  -- PCC weekly standing order
  ('SO-20001', 1, 'CUST-001', 'PCC Community Markets',             'FB-LBUT-001', 'Living Butter Lettuce',       1200, 0, 1200, 'heads', current_date + 2, 'WH-PACK', 'Open'),
  ('SO-20001', 2, 'CUST-001', 'PCC Community Markets',             'FB-SPRM-001', 'Spring Mix - Hydroponic',      100, 0,  100, 'lbs',   current_date + 2, 'WH-PACK', 'Open'),
  ('SO-20001', 3, 'CUST-001', 'PCC Community Markets',             'FB-LBAS-001', 'Living Basil - Genovese',      300, 0,  300, 'heads', current_date + 2, 'WH-PACK', 'Open'),
  -- Metropolitan Market
  ('SO-20002', 1, 'CUST-002', 'Metropolitan Market',               'FB-LGRN-001', 'Living Green Leaf Lettuce',    600, 0,  600, 'heads', current_date + 1, 'WH-PACK', 'Open'),
  ('SO-20002', 2, 'CUST-002', 'Metropolitan Market',               'FB-LRED-001', 'Living Red Leaf Lettuce',      400, 0,  400, 'heads', current_date + 1, 'WH-PACK', 'Open'),
  ('SO-20002', 3, 'CUST-002', 'Metropolitan Market',               'FB-MPEA-001', 'Microgreens - Pea Shoots',      15, 0,   15, 'lbs',   current_date + 1, 'WH-PACK', 'Open'),
  -- Canlis (fine dining)
  ('SO-20003', 1, 'CUST-003', 'Canlis Restaurant',                 'FB-MRNB-001', 'Microgreens - Rainbow Mix',      8, 0,    8, 'lbs',   current_date + 1, 'WH-PACK', 'Open'),
  ('SO-20003', 2, 'CUST-003', 'Canlis Restaurant',                 'FB-LBUT-001', 'Living Butter Lettuce',         48, 0,   48, 'heads', current_date + 1, 'WH-PACK', 'Open'),
  ('SO-20003', 3, 'CUST-003', 'Canlis Restaurant',                 'FB-LBAS-001', 'Living Basil - Genovese',       36, 0,   36, 'heads', current_date + 1, 'WH-PACK', 'Open'),
  -- Whole Foods
  ('SO-20004', 1, 'CUST-005', 'University Village Whole Foods',    'FB-LBUT-001', 'Living Butter Lettuce',        800, 0,  800, 'heads', current_date + 3, 'WH-PACK', 'Open'),
  ('SO-20004', 2, 'CUST-005', 'University Village Whole Foods',    'FB-ARUG-001', 'Baby Arugula - Hydroponic',     60, 0,   60, 'lbs',   current_date + 3, 'WH-PACK', 'Open'),
  ('SO-20004', 3, 'CUST-005', 'University Village Whole Foods',    'FB-KALE-001', 'Baby Kale Mix - Hydroponic',    50, 0,   50, 'lbs',   current_date + 3, 'WH-PACK', 'Open'),
  -- Fred Meyer bulk
  ('SO-20005', 1, 'CUST-007', 'Fred Meyer / Kroger NW',           'FB-LBUT-001', 'Living Butter Lettuce',       1500, 0, 1500, 'heads', current_date + 4, 'WH-CPC', 'Open'),
  ('SO-20005', 2, 'CUST-007', 'Fred Meyer / Kroger NW',           'FB-LGRN-001', 'Living Green Leaf Lettuce',   1000, 0, 1000, 'heads', current_date + 4, 'WH-CPC', 'Open'),
  ('SO-20005', 3, 'CUST-007', 'Fred Meyer / Kroger NW',           'FB-SPIN-001', 'Baby Spinach - Hydroponic',    150, 0,  150, 'lbs',   current_date + 4, 'WH-CPC', 'Open'),
  -- Farmers Market
  ('SO-20006', 1, 'CUST-009', 'Ballard Farmers Market',           'FB-MSUN-001', 'Microgreens - Sunflower',       15, 0,   15, 'lbs',   current_date + 5, 'WH-PACK', 'Open'),
  ('SO-20006', 2, 'CUST-009', 'Ballard Farmers Market',           'FB-MPEA-001', 'Microgreens - Pea Shoots',      20, 0,   20, 'lbs',   current_date + 5, 'WH-PACK', 'Open'),
  ('SO-20006', 3, 'CUST-009', 'Ballard Farmers Market',           'FB-LBAS-001', 'Living Basil - Genovese',      120, 0,  120, 'heads', current_date + 5, 'WH-PACK', 'Open'),
  ('SO-20006', 4, 'CUST-009', 'Ballard Farmers Market',           'FB-LOAK-001', 'Living Red Oakleaf',           200, 0,  200, 'heads', current_date + 5, 'WH-PACK', 'Open'),
  -- Delivered historical order
  ('SO-19998', 1, 'CUST-010', 'Charlie''s Produce - Distribution', 'FB-LBUT-001', 'Living Butter Lettuce',       2400, 2400, 0, 'heads', current_date - 3, 'WH-CPC', 'Delivered'),
  ('SO-19998', 2, 'CUST-010', 'Charlie''s Produce - Distribution', 'FB-SPRM-001', 'Spring Mix - Hydroponic',      240,  240, 0, 'lbs',   current_date - 3, 'WH-CPC', 'Delivered'),
  ('SO-19998', 3, 'CUST-010', 'Charlie''s Produce - Distribution', 'FB-MPEA-001', 'Microgreens - Pea Shoots',      40,   40, 0, 'lbs',   current_date - 3, 'WH-CPC', 'Delivered');

-- -----------------------------------------------
-- D365 PRODUCTION ORDERS — active production
-- -----------------------------------------------
insert into d365_production_orders (d365_prod_order_id, item_number, item_name, order_quantity, remaining_quantity, unit, status, scheduled_start_date, scheduled_end_date, warehouse_id, site_id) values
  ('PROD-7001', 'FB-LBUT-001', 'Living Butter Lettuce',       2400, 2400, 'heads', 'Released',   current_date, current_date + 1, 'WH-GH',   'SITE-FB'),
  ('PROD-7002', 'FB-LGRN-001', 'Living Green Leaf Lettuce',   1800, 1800, 'heads', 'Released',   current_date, current_date + 1, 'WH-GH',   'SITE-FB'),
  ('PROD-7003', 'FB-SPRM-001', 'Spring Mix - Hydroponic',      240,  240, 'lbs',   'Released',   current_date, current_date + 1, 'WH-GH',   'SITE-FB'),
  ('PROD-7004', 'FB-MPEA-001', 'Microgreens - Pea Shoots',      60,   18, 'lbs',   'Started',    current_date - 1, current_date, 'WH-GH',   'SITE-FB'),
  ('PROD-7005', 'FB-MSUN-001', 'Microgreens - Sunflower',       45,   45, 'lbs',   'Scheduled',  current_date, current_date + 1, 'WH-GH',   'SITE-FB'),
  ('PROD-7006', 'FB-LBAS-001', 'Living Basil - Genovese',      400,  400, 'heads', 'Scheduled',  current_date + 10, current_date + 12, 'WH-GH', 'SITE-FB'),
  ('PROD-7007', 'FB-ARUG-001', 'Baby Arugula - Hydroponic',    180,  180, 'lbs',   'Scheduled',  current_date + 5, current_date + 6, 'WH-GH', 'SITE-FB'),
  ('PROD-7008', 'FB-KALE-001', 'Baby Kale Mix - Hydroponic',   150,  150, 'lbs',   'Scheduled',  current_date + 6, current_date + 7, 'WH-GH', 'SITE-FB');

-- -----------------------------------------------
-- D365 INVENTORY ON-HAND — current stock
-- -----------------------------------------------
insert into d365_inventory_onhand (item_number, warehouse_id, site_id, available_physical, available_ordered, total_available, unit, batch_number) values
  ('FB-LBUT-001', 'WH-PACK', 'SITE-FB', 2400,  1200, 3600, 'heads', 'BT-20260315-01'),
  ('FB-LGRN-001', 'WH-PACK', 'SITE-FB',  400,   600, 1000, 'heads', 'BT-20260318-01'),
  ('FB-LRED-001', 'WH-PACK', 'SITE-FB',    0,   400,  400, 'heads', null),
  ('FB-LOAK-001', 'WH-PACK', 'SITE-FB',    0,   100,  100, 'heads', null),
  ('FB-SPRM-001', 'WH-PACK', 'SITE-FB',  240,   100,  340, 'lbs',   'BT-20260318-02'),
  ('FB-ARUG-001', 'WH-GH',   'SITE-FB',    0,    80,   80, 'lbs',   null),
  ('FB-SPIN-001', 'WH-GH',   'SITE-FB',    0,   150,  150, 'lbs',   null),
  ('FB-KALE-001', 'WH-GH',   'SITE-FB',    0,    60,   60, 'lbs',   null),
  ('FB-LBAS-001', 'WH-GH',   'SITE-FB',  120,   300,  420, 'heads', 'BT-20260320-01'),
  ('FB-MPEA-001', 'WH-PACK', 'SITE-FB',   42,    35,   77, 'lbs',   'BT-20260324-01'),
  ('FB-MSUN-001', 'WH-PACK', 'SITE-FB',   35,    10,   45, 'lbs',   'BT-20260322-01'),
  ('FB-MRAD-001', 'WH-GH',   'SITE-FB',    0,     0,    0, 'lbs',   null),
  ('FB-MRNB-001', 'WH-PACK', 'SITE-FB',   12,     5,   17, 'lbs',   'BT-20260321-01');
