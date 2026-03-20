-- ============================================================
-- Migration 006 — Farmbox Demo Seed Data
-- Leafy Greens, Vegetables, Gourmet Mushrooms
-- ============================================================

-- -----------------------------------------------
-- Clear existing sample data for a clean demo
-- (order matters due to foreign keys)
-- -----------------------------------------------
delete from d365_sync_queue;
delete from yield_records;
delete from harvest_schedule_members;
delete from harvest_schedules;
delete from grow_cycles;
delete from crops;
delete from fields;
delete from team_members;

-- -----------------------------------------------
-- TEAM MEMBERS — Farmbox Team
-- -----------------------------------------------
insert into team_members (full_name, role, email, phone) values
  ('Sarah Mitchell',   'field_manager',      'sarah.mitchell@farmbox.com',   '555-100-2001'),
  ('David Nguyen',     'harvester',          'david.nguyen@farmbox.com',     '555-100-2002'),
  ('Elena Vasquez',    'harvester',          'elena.vasquez@farmbox.com',    '555-100-2003'),
  ('Marcus Thompson',  'planner',            'marcus.thompson@farmbox.com',  '555-100-2004'),
  ('Lisa Park',        'quality_inspector',  'lisa.park@farmbox.com',        '555-100-2005'),
  ('Jake Williams',    'driver',             'jake.williams@farmbox.com',    '555-100-2006'),
  ('Amara Osei',       'harvester',          'amara.osei@farmbox.com',       '555-100-2007'),
  ('Ryan Cooper',      'field_manager',      'ryan.cooper@farmbox.com',      '555-100-2008');

-- -----------------------------------------------
-- FIELDS / GROWING LOCATIONS — Farmbox Facilities
-- -----------------------------------------------
insert into fields (name, location, area_acres, soil_type, status) values
  -- Leafy Greens Zone
  ('Greenhouse A - Leafy Greens',    'Indoor Facility, Bay 1',      2.00, 'Hydroponic',     'growing'),
  ('Greenhouse B - Leafy Greens',    'Indoor Facility, Bay 2',      1.50, 'Hydroponic',     'harvest_ready'),
  ('Field 1 - Outdoor Greens',       'North Plot, Rows 1-20',       5.00, 'Loam',           'planted'),
  -- Vegetable Zone
  ('Greenhouse C - Vegetables',      'Indoor Facility, Bay 3',      3.00, 'Soilless Mix',   'growing'),
  ('Field 2 - Root Vegetables',      'East Plot, Rows 1-30',        8.00, 'Sandy Loam',     'harvest_ready'),
  ('Field 3 - Vine Vegetables',      'South Plot, Rows 1-25',       6.00, 'Clay Loam',      'growing'),
  ('High Tunnel 1 - Tomatoes',       'West Section, Tunnel A',      1.00, 'Raised Bed Mix', 'harvesting'),
  -- Mushroom Zone
  ('Mushroom House 1 - Lions Mane',  'Climate-Controlled Bldg A',   0.50, 'Hardwood Substrate', 'growing'),
  ('Mushroom House 2 - Reishi',      'Climate-Controlled Bldg B',   0.50, 'Oak Log Substrate',  'harvest_ready'),
  ('Mushroom House 3 - Oyster',      'Climate-Controlled Bldg C',   0.75, 'Straw Substrate',    'harvest_ready'),
  -- Idle / Prep
  ('Field 4 - Expansion Plot',       'North Plot, Rows 21-40',      4.00, 'Silt Loam',      'field_prep'),
  ('Mushroom House 4 - New Build',   'Climate-Controlled Bldg D',   0.50, 'Sawdust Substrate',  'idle');

-- -----------------------------------------------
-- CROPS — Leafy Greens
-- -----------------------------------------------
insert into crops (name, variety, avg_grow_days, lead_time_hours, unit_of_measure, target_yield_per_acre) values
  ('Baby Spinach',       'Bloomsdale Long Standing',  21,  12, 'lbs',     800),
  ('Arugula',            'Astro',                     21,  12, 'lbs',     600),
  ('Mixed Lettuce',      'Mesclun Blend',             28,  18, 'lbs',     900),
  ('Romaine Lettuce',    'Parris Island Cos',         55,  24, 'lbs',    1200),
  ('Butter Lettuce',     'Bibb',                      45,  24, 'heads',   800),
  ('Kale',               'Lacinato (Dinosaur)',       50,  24, 'lbs',    1000),
  ('Swiss Chard',        'Rainbow',                   50,  24, 'lbs',     900),
  ('Microgreens Mix',    'Sunflower / Pea Shoots',    10,   6, 'lbs',     200),
  ('Watercress',         'Aqua',                      14,   8, 'lbs',     400),
  ('Bok Choy',           'Shanghai Green',            30,  18, 'lbs',     750);

-- -----------------------------------------------
-- CROPS — Vegetables
-- -----------------------------------------------
insert into crops (name, variety, avg_grow_days, lead_time_hours, unit_of_measure, target_yield_per_acre) values
  ('Cherry Tomatoes',    'Sun Gold',                  75,  48, 'lbs',    3000),
  ('Beefsteak Tomatoes', 'Brandywine',                80,  48, 'lbs',    2500),
  ('Bell Peppers',       'California Wonder',         70,  48, 'lbs',    2000),
  ('Cucumbers',          'Marketmore 76',             55,  36, 'lbs',    2800),
  ('Zucchini',           'Black Beauty',              45,  36, 'lbs',    3500),
  ('Snap Peas',          'Sugar Ann',                 60,  24, 'lbs',    1500),
  ('Radishes',           'Cherry Belle',              25,  12, 'lbs',    1000),
  ('Baby Carrots',       'Nantes',                    65,  36, 'lbs',    2000),
  ('Green Beans',        'Blue Lake Bush',            55,  24, 'lbs',    1800),
  ('Fresh Herbs Mix',    'Basil / Cilantro / Dill',   30,   8, 'bunches', 500);

-- -----------------------------------------------
-- CROPS — Gourmet Mushrooms
-- -----------------------------------------------
insert into crops (name, variety, avg_grow_days, lead_time_hours, unit_of_measure, target_yield_per_acre) values
  ('Lions Mane',         'Hericium erinaceus',        14,  12, 'lbs',     600),
  ('Reishi',             'Ganoderma lucidum',         60,  48, 'lbs',     300),
  ('Oyster Mushroom',    'Pleurotus ostreatus',       10,   8, 'lbs',     800),
  ('Shiitake',           'Lentinula edodes',          21,  18, 'lbs',     500),
  ('Maitake',            'Grifola frondosa',          30,  24, 'lbs',     400),
  ('Chestnut Mushroom',  'Pholiota adiposa',          18,  14, 'lbs',     550),
  ('King Trumpet',       'Pleurotus eryngii',         14,  12, 'lbs',     650),
  ('Pink Oyster',        'Pleurotus djamor',           7,   6, 'lbs',     900);

-- -----------------------------------------------
-- GROW CYCLES — Active cycles across all zones
-- -----------------------------------------------

-- Leafy Greens cycles
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '25 days',
  current_date - interval '18 days',
  current_date + interval '3 days',
  'Hydroponic bay — nutrient solution refreshed weekly'
from fields f, crops c
where f.name = 'Greenhouse A - Leafy Greens' and c.name = 'Baby Spinach';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvest_ready',
  current_date - interval '35 days',
  current_date - interval '28 days',
  current_date,
  'Ready for cut — quality check passed'
from fields f, crops c
where f.name = 'Greenhouse B - Leafy Greens' and c.name = 'Mixed Lettuce';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvest_ready',
  current_date - interval '32 days',
  current_date - interval '25 days',
  current_date + interval '1 day',
  'Second flush ready for harvest'
from fields f, crops c
where f.name = 'Greenhouse B - Leafy Greens' and c.name = 'Arugula';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'planting',
  current_date - interval '10 days',
  current_date - interval '3 days',
  current_date + interval '52 days',
  'Outdoor succession planting — row covers in place'
from fields f, crops c
where f.name = 'Field 1 - Outdoor Greens' and c.name = 'Romaine Lettuce';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '8 days',
  current_date - interval '5 days',
  current_date + interval '5 days',
  'Microgreen trays — stacked germination'
from fields f, crops c
where f.name = 'Greenhouse A - Leafy Greens' and c.name = 'Microgreens Mix';

-- Vegetable cycles
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '50 days',
  current_date - interval '40 days',
  current_date + interval '10 days',
  'Greenhouse cucumbers — trellised, drip irrigation'
from fields f, crops c
where f.name = 'Greenhouse C - Vegetables' and c.name = 'Cucumbers';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvest_ready',
  current_date - interval '30 days',
  current_date - interval '25 days',
  current_date,
  'Radishes sizing up — pull today'
from fields f, crops c
where f.name = 'Field 2 - Root Vegetables' and c.name = 'Radishes';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvest_ready',
  current_date - interval '70 days',
  current_date - interval '65 days',
  current_date + interval '1 day',
  'Baby carrots at target size'
from fields f, crops c
where f.name = 'Field 2 - Root Vegetables' and c.name = 'Baby Carrots';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '40 days',
  current_date - interval '30 days',
  current_date + interval '15 days',
  'Zucchini flowering — pollination underway'
from fields f, crops c
where f.name = 'Field 3 - Vine Vegetables' and c.name = 'Zucchini';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvesting',
  current_date - interval '80 days',
  current_date - interval '70 days',
  current_date - interval '2 days',
  'Peak harvest — daily picks'
from fields f, crops c
where f.name = 'High Tunnel 1 - Tomatoes' and c.name = 'Cherry Tomatoes';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '35 days',
  current_date - interval '28 days',
  current_date + interval '32 days',
  'Snap peas climbing — netting installed'
from fields f, crops c
where f.name = 'Field 3 - Vine Vegetables' and c.name = 'Snap Peas';

-- Gourmet Mushroom cycles
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '10 days',
  current_date - interval '7 days',
  current_date + interval '7 days',
  'Fruiting blocks in climate chamber — 85% humidity, 65°F'
from fields f, crops c
where f.name = 'Mushroom House 1 - Lions Mane' and c.name = 'Lions Mane';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvest_ready',
  current_date - interval '65 days',
  current_date - interval '60 days',
  current_date,
  'Antler form developed — ready for harvest'
from fields f, crops c
where f.name = 'Mushroom House 2 - Reishi' and c.name = 'Reishi';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvest_ready',
  current_date - interval '14 days',
  current_date - interval '10 days',
  current_date,
  'Clusters fully formed — shelf caps curling'
from fields f, crops c
where f.name = 'Mushroom House 3 - Oyster' and c.name = 'Oyster Mushroom';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'harvest_ready',
  current_date - interval '12 days',
  current_date - interval '8 days',
  current_date + interval '1 day',
  'Second flush — pins visible, harvest in 24hrs'
from fields f, crops c
where f.name = 'Mushroom House 3 - Oyster' and c.name = 'Pink Oyster';

insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'growing',
  current_date - interval '15 days',
  current_date - interval '12 days',
  current_date + interval '9 days',
  'Log inoculation complete — primordia forming'
from fields f, crops c
where f.name = 'Mushroom House 2 - Reishi' and c.name = 'Shiitake';

-- Field Prep cycle
insert into grow_cycles (field_id, crop_id, phase, field_prep_date, planting_date, expected_harvest_date, notes)
select f.id, c.id, 'field_prep',
  current_date - interval '2 days',
  null,
  null,
  'Soil amendment and bed prep for new kale rotation'
from fields f, crops c
where f.name = 'Field 4 - Expansion Plot' and c.name = 'Kale';

-- -----------------------------------------------
-- HARVEST SCHEDULES — for harvest_ready cycles
-- -----------------------------------------------

-- Mixed Lettuce harvest
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date, '06:00'::time, '10:00'::time, 'scheduled',
  'Morning cut — pack for afternoon delivery'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'Greenhouse B - Leafy Greens' and c.name = 'Mixed Lettuce';

-- Arugula harvest
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date + interval '1 day', '06:00'::time, '09:00'::time, 'scheduled',
  'Early cut for farmers market order'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'Greenhouse B - Leafy Greens' and c.name = 'Arugula';

-- Radishes harvest
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date, '07:00'::time, '11:00'::time, 'scheduled',
  'Pull and wash — restaurant delivery by 2pm'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'Field 2 - Root Vegetables' and c.name = 'Radishes';

-- Baby Carrots harvest
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date + interval '1 day', '06:30'::time, '12:00'::time, 'scheduled',
  'Mechanical harvest — wash and grade'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'Field 2 - Root Vegetables' and c.name = 'Baby Carrots';

-- Cherry Tomatoes — active harvest
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date, '05:30'::time, '13:00'::time, 'in_progress',
  'Daily pick — sorting by color grade'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'High Tunnel 1 - Tomatoes' and c.name = 'Cherry Tomatoes';

-- Reishi harvest
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date, '08:00'::time, '11:00'::time, 'scheduled',
  'Careful hand harvest — antler form, dry immediately'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'Mushroom House 2 - Reishi' and c.name = 'Reishi';

-- Oyster Mushroom harvest
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date, '07:00'::time, '10:00'::time, 'scheduled',
  'Twist and pull — pack in breathable containers'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'Mushroom House 3 - Oyster' and c.name = 'Oyster Mushroom';

-- Pink Oyster harvest
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date + interval '1 day', '07:00'::time, '09:30'::time, 'scheduled',
  'Harvest at first sign of cap flattening — very perishable'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'Mushroom House 3 - Oyster' and c.name = 'Pink Oyster';

-- A completed harvest for demo history
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date - interval '3 days', '06:00'::time, '12:00'::time, 'completed',
  'Full cut completed — 1,800 lbs packed'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'Greenhouse B - Leafy Greens' and c.name = 'Mixed Lettuce';

-- A cancelled harvest for demo (to show the Reopen feature)
insert into harvest_schedules (grow_cycle_id, scheduled_date, start_time, end_time, status, notes)
select gc.id, current_date - interval '1 day', '06:00'::time, '10:00'::time, 'cancelled',
  'Weather delay — reschedule needed'
from grow_cycles gc
join fields f on gc.field_id = f.id
join crops c on gc.crop_id = c.id
where f.name = 'Greenhouse A - Leafy Greens' and c.name = 'Baby Spinach';

-- -----------------------------------------------
-- HARVEST SCHEDULE MEMBERS — assign teams
-- -----------------------------------------------

-- Assign Sarah (field_manager) + David + Elena to the lettuce harvest
insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'lead'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Mixed Lettuce' and hs.status = 'scheduled' and tm.full_name = 'Sarah Mitchell';

insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'harvester'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Mixed Lettuce' and hs.status = 'scheduled' and tm.full_name = 'David Nguyen';

insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'harvester'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Mixed Lettuce' and hs.status = 'scheduled' and tm.full_name = 'Elena Vasquez';

-- Assign Lisa (QC) + Amara to mushroom harvests
insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'quality_check'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name in ('Reishi', 'Oyster Mushroom') and hs.status = 'scheduled' and tm.full_name = 'Lisa Park';

insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'harvester'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name in ('Reishi', 'Oyster Mushroom', 'Pink Oyster') and hs.status = 'scheduled' and tm.full_name = 'Amara Osei';

-- Assign Jake (driver) to radish harvest for delivery logistics
insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'delivery'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Radishes' and hs.status = 'scheduled' and tm.full_name = 'Jake Williams';

-- Assign Ryan + David to tomato harvest (in_progress)
insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'lead'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Cherry Tomatoes' and hs.status = 'in_progress' and tm.full_name = 'Ryan Cooper';

insert into harvest_schedule_members (harvest_schedule_id, team_member_id, role_in_harvest)
select hs.id, tm.id, 'harvester'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
cross join team_members tm
where c.name = 'Cherry Tomatoes' and hs.status = 'in_progress' and tm.full_name = 'David Nguyen';

-- -----------------------------------------------
-- YIELD RECORDS — some historical yields
-- -----------------------------------------------

-- Completed lettuce harvest yield
insert into yield_records (grow_cycle_id, harvest_schedule_id, quantity, unit_of_measure, grade, notes)
select gc.id, hs.id, 1800, 'lbs', 'A', 'Excellent quality — full cut'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
where c.name = 'Mixed Lettuce' and hs.status = 'completed'
limit 1;

insert into yield_records (grow_cycle_id, harvest_schedule_id, quantity, unit_of_measure, grade, notes)
select gc.id, hs.id, 150, 'lbs', 'B', 'Slight tip burn — still sellable'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
where c.name = 'Mixed Lettuce' and hs.status = 'completed'
limit 1;

-- Tomato daily pick yield (in progress)
insert into yield_records (grow_cycle_id, harvest_schedule_id, quantity, unit_of_measure, grade, notes)
select gc.id, hs.id, 420, 'lbs', 'A', 'Morning pick — Sun Gold premium'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
where c.name = 'Cherry Tomatoes' and hs.status = 'in_progress'
limit 1;

insert into yield_records (grow_cycle_id, harvest_schedule_id, quantity, unit_of_measure, grade, notes)
select gc.id, hs.id, 80, 'lbs', 'B', 'Minor cracking — juice grade'
from harvest_schedules hs
join grow_cycles gc on hs.grow_cycle_id = gc.id
join crops c on gc.crop_id = c.id
where c.name = 'Cherry Tomatoes' and hs.status = 'in_progress'
limit 1;

-- Historical mushroom yield (standalone, no schedule)
insert into yield_records (grow_cycle_id, quantity, unit_of_measure, grade, recorded_at, notes)
select gc.id, 45, 'lbs', 'A', now() - interval '7 days', 'Lions Mane — first flush, beautiful clusters'
from grow_cycles gc
join crops c on gc.crop_id = c.id
where c.name = 'Lions Mane'
limit 1;

insert into yield_records (grow_cycle_id, quantity, unit_of_measure, grade, recorded_at, notes)
select gc.id, 28, 'lbs', 'A', now() - interval '5 days', 'Reishi antler harvest — dried weight'
from grow_cycles gc
join crops c on gc.crop_id = c.id
where c.name = 'Reishi'
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
-- D365 PRODUCTS — matching Farmbox catalog
-- -----------------------------------------------
insert into d365_products (d365_item_number, product_name, product_type, item_group, inventory_unit, sales_unit, sales_price, tracking_dimension_group, shelf_life_days, buyer_group) values
  ('FB-SPIN-001', 'Baby Spinach - Organic',       'Item', 'Leafy Greens',      'lbs', 'lbs',   4.50, 'Batch', 7,  'Greens'),
  ('FB-ARUG-001', 'Arugula - Organic',             'Item', 'Leafy Greens',      'lbs', 'lbs',   5.00, 'Batch', 5,  'Greens'),
  ('FB-LETT-001', 'Mixed Lettuce - Mesclun',       'Item', 'Leafy Greens',      'lbs', 'lbs',   6.00, 'Batch', 5,  'Greens'),
  ('FB-ROML-001', 'Romaine Lettuce',               'Item', 'Leafy Greens',      'lbs', 'lbs',   3.50, 'Batch', 7,  'Greens'),
  ('FB-BUTL-001', 'Butter Lettuce - Bibb',         'Item', 'Leafy Greens',      'heads', 'heads', 2.50, 'Batch', 5, 'Greens'),
  ('FB-KALE-001', 'Lacinato Kale',                 'Item', 'Leafy Greens',      'lbs', 'lbs',   4.00, 'Batch', 7,  'Greens'),
  ('FB-CHRD-001', 'Rainbow Swiss Chard',           'Item', 'Leafy Greens',      'lbs', 'lbs',   4.00, 'Batch', 7,  'Greens'),
  ('FB-MICR-001', 'Microgreens Mix',               'Item', 'Leafy Greens',      'lbs', 'lbs',  12.00, 'Batch', 3,  'Greens'),
  ('FB-WCRS-001', 'Watercress',                    'Item', 'Leafy Greens',      'lbs', 'lbs',   8.00, 'Batch', 3,  'Greens'),
  ('FB-BOKC-001', 'Bok Choy - Shanghai',           'Item', 'Leafy Greens',      'lbs', 'lbs',   3.50, 'Batch', 5,  'Greens'),
  ('FB-CHTM-001', 'Cherry Tomatoes - Sun Gold',    'Item', 'Vegetables',        'lbs', 'lbs',   5.50, 'Batch', 10, 'Vegetables'),
  ('FB-BFTM-001', 'Beefsteak Tomatoes',            'Item', 'Vegetables',        'lbs', 'lbs',   4.00, 'Batch', 7,  'Vegetables'),
  ('FB-BELL-001', 'Bell Peppers - Mixed',          'Item', 'Vegetables',        'lbs', 'lbs',   3.50, 'Batch', 10, 'Vegetables'),
  ('FB-CUCU-001', 'Cucumbers - Marketmore',        'Item', 'Vegetables',        'lbs', 'lbs',   2.50, 'Batch', 7,  'Vegetables'),
  ('FB-ZUCC-001', 'Zucchini - Black Beauty',       'Item', 'Vegetables',        'lbs', 'lbs',   2.00, 'Batch', 7,  'Vegetables'),
  ('FB-SNAP-001', 'Snap Peas - Sugar Ann',         'Item', 'Vegetables',        'lbs', 'lbs',   6.00, 'Batch', 5,  'Vegetables'),
  ('FB-RADI-001', 'Radishes - Cherry Belle',       'Item', 'Vegetables',        'lbs', 'lbs',   3.00, 'Batch', 10, 'Vegetables'),
  ('FB-CARR-001', 'Baby Carrots - Nantes',         'Item', 'Vegetables',        'lbs', 'lbs',   3.50, 'Batch', 14, 'Vegetables'),
  ('FB-GRNB-001', 'Green Beans - Blue Lake',       'Item', 'Vegetables',        'lbs', 'lbs',   4.00, 'Batch', 7,  'Vegetables'),
  ('FB-HERB-001', 'Fresh Herbs Mix',               'Item', 'Vegetables',        'bunches', 'bunches', 3.00, 'Batch', 5, 'Vegetables'),
  ('FB-LION-001', 'Lions Mane Mushroom',           'Item', 'Gourmet Mushrooms', 'lbs', 'lbs',  16.00, 'Batch', 7,  'Mushrooms'),
  ('FB-REIS-001', 'Reishi Mushroom - Dried',       'Item', 'Gourmet Mushrooms', 'lbs', 'lbs',  30.00, 'Batch', 180, 'Mushrooms'),
  ('FB-OYST-001', 'Oyster Mushroom',               'Item', 'Gourmet Mushrooms', 'lbs', 'lbs',  12.00, 'Batch', 5,  'Mushrooms'),
  ('FB-SHII-001', 'Shiitake Mushroom',             'Item', 'Gourmet Mushrooms', 'lbs', 'lbs',  14.00, 'Batch', 7,  'Mushrooms'),
  ('FB-MAIT-001', 'Maitake Mushroom',              'Item', 'Gourmet Mushrooms', 'lbs', 'lbs',  18.00, 'Batch', 5,  'Mushrooms'),
  ('FB-CHST-001', 'Chestnut Mushroom',             'Item', 'Gourmet Mushrooms', 'lbs', 'lbs',  10.00, 'Batch', 7,  'Mushrooms'),
  ('FB-KING-001', 'King Trumpet Mushroom',         'Item', 'Gourmet Mushrooms', 'lbs', 'lbs',  15.00, 'Batch', 7,  'Mushrooms'),
  ('FB-PINK-001', 'Pink Oyster Mushroom',          'Item', 'Gourmet Mushrooms', 'lbs', 'lbs',  14.00, 'Batch', 3,  'Mushrooms');

-- -----------------------------------------------
-- D365 CUSTOMERS — Farmbox buyer accounts
-- -----------------------------------------------
insert into d365_customers (d365_customer_account, customer_name, customer_group, currency_code, payment_terms, delivery_mode, primary_contact) values
  ('CUST-001', 'Whole Foods Market - Regional',   'Retail',      'USD', 'Net30',  'Refrigerated Truck', 'Buyer Team - Produce'),
  ('CUST-002', 'Farm-to-Table Restaurant Group',   'Restaurant',  'USD', 'Net15',  'Direct Delivery',    'Chef Marco Bellini'),
  ('CUST-003', 'Green Valley Co-op',               'Co-op',       'USD', 'Net30',  'Pickup',             'Distribution Manager'),
  ('CUST-004', 'Medicinal Mushroom Co.',            'Wholesale',   'USD', 'Net45',  'FedEx Cold',         'Alex Tran - Procurement'),
  ('CUST-005', 'Local Farmers Market - Saturday',   'Direct',      'USD', 'COD',    'Booth Delivery',     'Market Coordinator'),
  ('CUST-006', 'FreshDirect Northeast',             'E-Commerce',  'USD', 'Net30',  'Carrier Pickup',     'Vendor Relations'),
  ('CUST-007', 'Hospital Nutrition Services',       'Institutional','USD', 'Net30',  'Scheduled Delivery', 'Dietician Susan Park');

-- -----------------------------------------------
-- D365 WAREHOUSES — Farmbox locations
-- -----------------------------------------------
insert into d365_warehouses (d365_warehouse_id, warehouse_name, site_id, is_default, address_city, address_state) values
  ('WH-MAIN',  'Farmbox Main Cold Storage',    'SITE-01', true,  'Portland', 'OR'),
  ('WH-PACK',  'Farmbox Packing Facility',     'SITE-01', false, 'Portland', 'OR'),
  ('WH-MUSH',  'Mushroom Processing Center',   'SITE-02', false, 'Portland', 'OR'),
  ('WH-DIST',  'Distribution Hub',             'SITE-03', false, 'Salem',    'OR');

-- -----------------------------------------------
-- D365 SALES ORDERS — upcoming demand
-- -----------------------------------------------
insert into d365_sales_orders (d365_sales_order_number, line_number, customer_account, customer_name, item_number, item_name, ordered_quantity, delivered_quantity, remaining_quantity, unit, requested_ship_date, warehouse_id, order_status) values
  ('SO-10001', 1, 'CUST-001', 'Whole Foods Market - Regional',  'FB-LETT-001', 'Mixed Lettuce - Mesclun',     500, 0, 500, 'lbs',   current_date + 2, 'WH-MAIN', 'Open'),
  ('SO-10001', 2, 'CUST-001', 'Whole Foods Market - Regional',  'FB-SPIN-001', 'Baby Spinach - Organic',      300, 0, 300, 'lbs',   current_date + 2, 'WH-MAIN', 'Open'),
  ('SO-10001', 3, 'CUST-001', 'Whole Foods Market - Regional',  'FB-LION-001', 'Lions Mane Mushroom',          50, 0,  50, 'lbs',   current_date + 2, 'WH-MUSH', 'Open'),
  ('SO-10002', 1, 'CUST-002', 'Farm-to-Table Restaurant Group', 'FB-MICR-001', 'Microgreens Mix',              20, 0,  20, 'lbs',   current_date + 1, 'WH-PACK', 'Open'),
  ('SO-10002', 2, 'CUST-002', 'Farm-to-Table Restaurant Group', 'FB-CHTM-001', 'Cherry Tomatoes - Sun Gold',  100, 0, 100, 'lbs',   current_date + 1, 'WH-PACK', 'Open'),
  ('SO-10002', 3, 'CUST-002', 'Farm-to-Table Restaurant Group', 'FB-HERB-001', 'Fresh Herbs Mix',              30, 0,  30, 'bunches', current_date + 1, 'WH-PACK', 'Open'),
  ('SO-10003', 1, 'CUST-004', 'Medicinal Mushroom Co.',         'FB-REIS-001', 'Reishi Mushroom - Dried',     100, 0, 100, 'lbs',   current_date + 5, 'WH-MUSH', 'Open'),
  ('SO-10003', 2, 'CUST-004', 'Medicinal Mushroom Co.',         'FB-LION-001', 'Lions Mane Mushroom',          75, 0,  75, 'lbs',   current_date + 5, 'WH-MUSH', 'Open'),
  ('SO-10003', 3, 'CUST-004', 'Medicinal Mushroom Co.',         'FB-MAIT-001', 'Maitake Mushroom',             40, 0,  40, 'lbs',   current_date + 5, 'WH-MUSH', 'Open'),
  ('SO-10004', 1, 'CUST-005', 'Local Farmers Market - Saturday','FB-ARUG-001', 'Arugula - Organic',            60, 0,  60, 'lbs',   current_date + 4, 'WH-PACK', 'Open'),
  ('SO-10004', 2, 'CUST-005', 'Local Farmers Market - Saturday','FB-RADI-001', 'Radishes - Cherry Belle',      40, 0,  40, 'lbs',   current_date + 4, 'WH-PACK', 'Open'),
  ('SO-10004', 3, 'CUST-005', 'Local Farmers Market - Saturday','FB-OYST-001', 'Oyster Mushroom',              25, 0,  25, 'lbs',   current_date + 4, 'WH-PACK', 'Open'),
  ('SO-10004', 4, 'CUST-005', 'Local Farmers Market - Saturday','FB-PINK-001', 'Pink Oyster Mushroom',         15, 0,  15, 'lbs',   current_date + 4, 'WH-PACK', 'Open'),
  ('SO-10005', 1, 'CUST-006', 'FreshDirect Northeast',          'FB-KALE-001', 'Lacinato Kale',               200, 0, 200, 'lbs',   current_date + 3, 'WH-MAIN', 'Open'),
  ('SO-10005', 2, 'CUST-006', 'FreshDirect Northeast',          'FB-BOKC-001', 'Bok Choy - Shanghai',         150, 0, 150, 'lbs',   current_date + 3, 'WH-MAIN', 'Open'),
  ('SO-10005', 3, 'CUST-006', 'FreshDirect Northeast',          'FB-CUCU-001', 'Cucumbers - Marketmore',      250, 0, 250, 'lbs',   current_date + 3, 'WH-MAIN', 'Open'),
  -- A delivered order for history
  ('SO-09998', 1, 'CUST-003', 'Green Valley Co-op',             'FB-LETT-001', 'Mixed Lettuce - Mesclun',     400, 400, 0, 'lbs',  current_date - 3, 'WH-MAIN', 'Delivered'),
  ('SO-09998', 2, 'CUST-003', 'Green Valley Co-op',             'FB-SHII-001', 'Shiitake Mushroom',            30,  30, 0, 'lbs',  current_date - 3, 'WH-MUSH', 'Delivered');

-- -----------------------------------------------
-- D365 PRODUCTION ORDERS — active production
-- -----------------------------------------------
insert into d365_production_orders (d365_prod_order_id, item_number, item_name, order_quantity, remaining_quantity, unit, status, scheduled_start_date, scheduled_end_date, warehouse_id, site_id) values
  ('PROD-5001', 'FB-LETT-001', 'Mixed Lettuce - Mesclun',     600, 600, 'lbs', 'Released',        current_date, current_date + 1, 'WH-MAIN', 'SITE-01'),
  ('PROD-5002', 'FB-SPIN-001', 'Baby Spinach - Organic',      400, 400, 'lbs', 'Released',        current_date, current_date + 1, 'WH-MAIN', 'SITE-01'),
  ('PROD-5003', 'FB-CHTM-001', 'Cherry Tomatoes - Sun Gold',  500, 80,  'lbs', 'Started',         current_date - 1, current_date, 'WH-PACK', 'SITE-01'),
  ('PROD-5004', 'FB-LION-001', 'Lions Mane Mushroom',         100, 100, 'lbs', 'Scheduled',       current_date + 5, current_date + 7, 'WH-MUSH', 'SITE-02'),
  ('PROD-5005', 'FB-REIS-001', 'Reishi Mushroom - Dried',     120, 120, 'lbs', 'Scheduled',       current_date + 3, current_date + 5, 'WH-MUSH', 'SITE-02'),
  ('PROD-5006', 'FB-OYST-001', 'Oyster Mushroom',              80,  80, 'lbs', 'Released',        current_date, current_date + 1, 'WH-MUSH', 'SITE-02'),
  ('PROD-5007', 'FB-RADI-001', 'Radishes - Cherry Belle',     150, 150, 'lbs', 'Released',        current_date, current_date, 'WH-PACK', 'SITE-01'),
  ('PROD-5008', 'FB-CARR-001', 'Baby Carrots - Nantes',       300, 300, 'lbs', 'Scheduled',       current_date + 1, current_date + 2, 'WH-MAIN', 'SITE-01');

-- -----------------------------------------------
-- D365 INVENTORY ON-HAND — current stock
-- -----------------------------------------------
insert into d365_inventory_onhand (item_number, warehouse_id, site_id, available_physical, available_ordered, total_available, unit, batch_number) values
  ('FB-LETT-001', 'WH-MAIN', 'SITE-01', 1800,  500, 2300, 'lbs', 'BT-20260317-01'),
  ('FB-SPIN-001', 'WH-MAIN', 'SITE-01',  200,  300,  500, 'lbs', 'BT-20260318-01'),
  ('FB-CHTM-001', 'WH-PACK', 'SITE-01',  420,  100,  520, 'lbs', 'BT-20260320-01'),
  ('FB-LION-001', 'WH-MUSH', 'SITE-02',   45,   50,   95, 'lbs', 'BT-20260313-01'),
  ('FB-REIS-001', 'WH-MUSH', 'SITE-02',   28,  100,  128, 'lbs', 'BT-20260315-01'),
  ('FB-OYST-001', 'WH-MUSH', 'SITE-02',    0,   25,   25, 'lbs', null),
  ('FB-PINK-001', 'WH-MUSH', 'SITE-02',    0,   15,   15, 'lbs', null),
  ('FB-RADI-001', 'WH-PACK', 'SITE-01',    0,   40,   40, 'lbs', null),
  ('FB-CARR-001', 'WH-MAIN', 'SITE-01',    0,    0,    0, 'lbs', null),
  ('FB-MICR-001', 'WH-PACK', 'SITE-01',   35,   20,   55, 'lbs', 'BT-20260319-01'),
  ('FB-HERB-001', 'WH-PACK', 'SITE-01',   80,   30,  110, 'bunches', 'BT-20260319-02'),
  ('FB-KALE-001', 'WH-MAIN', 'SITE-01',    0,  200,  200, 'lbs', null),
  ('FB-ARUG-001', 'WH-PACK', 'SITE-01',    0,   60,   60, 'lbs', null);

-- -----------------------------------------------
-- D365 ENTITY MAPPINGS — link local crops to D365 products
-- -----------------------------------------------
insert into d365_entity_mappings (local_entity_type, local_entity_id, d365_entity_type, d365_entity_ref)
select 'crop', c.id, 'product', p.d365_item_number
from crops c
join d365_products p on (
  (c.name = 'Baby Spinach'       and p.d365_item_number = 'FB-SPIN-001') or
  (c.name = 'Arugula'            and p.d365_item_number = 'FB-ARUG-001') or
  (c.name = 'Mixed Lettuce'      and p.d365_item_number = 'FB-LETT-001') or
  (c.name = 'Romaine Lettuce'    and p.d365_item_number = 'FB-ROML-001') or
  (c.name = 'Butter Lettuce'     and p.d365_item_number = 'FB-BUTL-001') or
  (c.name = 'Kale'               and p.d365_item_number = 'FB-KALE-001') or
  (c.name = 'Swiss Chard'        and p.d365_item_number = 'FB-CHRD-001') or
  (c.name = 'Microgreens Mix'    and p.d365_item_number = 'FB-MICR-001') or
  (c.name = 'Watercress'         and p.d365_item_number = 'FB-WCRS-001') or
  (c.name = 'Bok Choy'           and p.d365_item_number = 'FB-BOKC-001') or
  (c.name = 'Cherry Tomatoes'    and p.d365_item_number = 'FB-CHTM-001') or
  (c.name = 'Beefsteak Tomatoes' and p.d365_item_number = 'FB-BFTM-001') or
  (c.name = 'Bell Peppers'       and p.d365_item_number = 'FB-BELL-001') or
  (c.name = 'Cucumbers'          and p.d365_item_number = 'FB-CUCU-001') or
  (c.name = 'Zucchini'           and p.d365_item_number = 'FB-ZUCC-001') or
  (c.name = 'Snap Peas'          and p.d365_item_number = 'FB-SNAP-001') or
  (c.name = 'Radishes'           and p.d365_item_number = 'FB-RADI-001') or
  (c.name = 'Baby Carrots'       and p.d365_item_number = 'FB-CARR-001') or
  (c.name = 'Green Beans'        and p.d365_item_number = 'FB-GRNB-001') or
  (c.name = 'Fresh Herbs Mix'    and p.d365_item_number = 'FB-HERB-001') or
  (c.name = 'Lions Mane'         and p.d365_item_number = 'FB-LION-001') or
  (c.name = 'Reishi'             and p.d365_item_number = 'FB-REIS-001') or
  (c.name = 'Oyster Mushroom'    and p.d365_item_number = 'FB-OYST-001') or
  (c.name = 'Shiitake'           and p.d365_item_number = 'FB-SHII-001') or
  (c.name = 'Maitake'            and p.d365_item_number = 'FB-MAIT-001') or
  (c.name = 'Chestnut Mushroom'  and p.d365_item_number = 'FB-CHST-001') or
  (c.name = 'King Trumpet'       and p.d365_item_number = 'FB-KING-001') or
  (c.name = 'Pink Oyster'        and p.d365_item_number = 'FB-PINK-001')
);

-- Map fields to warehouses
insert into d365_entity_mappings (local_entity_type, local_entity_id, d365_entity_type, d365_entity_ref)
select 'field', f.id, 'warehouse', w.d365_warehouse_id
from fields f
cross join d365_warehouses w
where
  (f.name like '%Mushroom%' and w.d365_warehouse_id = 'WH-MUSH') or
  (f.name like '%Greenhouse%' and w.d365_warehouse_id = 'WH-PACK') or
  (f.name like '%Field%' and w.d365_warehouse_id = 'WH-MAIN') or
  (f.name like '%High Tunnel%' and w.d365_warehouse_id = 'WH-PACK');
