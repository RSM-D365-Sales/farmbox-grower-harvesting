-- ============================================================
-- Migration 004 — RLS Policies for D365 Cache Tables
--
-- The Edge Function upserts data using the service_role key
-- (which bypasses RLS), but the browser reads using the anon
-- key which IS subject to RLS.
--
-- These policies allow anonymous read access to the D365 cache
-- tables so the React app can display extracted data.
-- ============================================================

-- ─── D365 Products ─────────────────────────────────────────
alter table d365_products enable row level security;

create policy "Allow anonymous read on d365_products"
  on d365_products for select
  using (true);

create policy "Allow service role insert/update on d365_products"
  on d365_products for all
  using (true)
  with check (true);

-- ─── D365 Warehouses ───────────────────────────────────────
alter table d365_warehouses enable row level security;

create policy "Allow anonymous read on d365_warehouses"
  on d365_warehouses for select
  using (true);

create policy "Allow service role insert/update on d365_warehouses"
  on d365_warehouses for all
  using (true)
  with check (true);

-- ─── D365 Customers ────────────────────────────────────────
alter table d365_customers enable row level security;

create policy "Allow anonymous read on d365_customers"
  on d365_customers for select
  using (true);

create policy "Allow service role insert/update on d365_customers"
  on d365_customers for all
  using (true)
  with check (true);

-- ─── D365 Production Orders ────────────────────────────────
alter table d365_production_orders enable row level security;

create policy "Allow anonymous read on d365_production_orders"
  on d365_production_orders for select
  using (true);

create policy "Allow service role insert/update on d365_production_orders"
  on d365_production_orders for all
  using (true)
  with check (true);

-- ─── D365 Inventory On-Hand ────────────────────────────────
alter table d365_inventory_onhand enable row level security;

create policy "Allow anonymous read on d365_inventory_onhand"
  on d365_inventory_onhand for select
  using (true);

create policy "Allow service role insert/update on d365_inventory_onhand"
  on d365_inventory_onhand for all
  using (true)
  with check (true);

-- ─── D365 Sales Orders ────────────────────────────────────
alter table d365_sales_orders enable row level security;

create policy "Allow anonymous read on d365_sales_orders"
  on d365_sales_orders for select
  using (true);

create policy "Allow service role insert/update on d365_sales_orders"
  on d365_sales_orders for all
  using (true)
  with check (true);

-- ─── D365 Sync Log ────────────────────────────────────────
alter table d365_sync_log enable row level security;

create policy "Allow anonymous read on d365_sync_log"
  on d365_sync_log for select
  using (true);

create policy "Allow service role insert/update on d365_sync_log"
  on d365_sync_log for all
  using (true)
  with check (true);

-- ─── D365 Entity Mappings ──────────────────────────────────
alter table d365_entity_mappings enable row level security;

create policy "Allow anonymous read on d365_entity_mappings"
  on d365_entity_mappings for select
  using (true);

create policy "Allow service role insert/update on d365_entity_mappings"
  on d365_entity_mappings for all
  using (true)
  with check (true);

-- ─── D365 Connection ───────────────────────────────────────
alter table d365_connection enable row level security;

create policy "Allow anonymous read on d365_connection"
  on d365_connection for select
  using (true);

create policy "Allow service role insert/update on d365_connection"
  on d365_connection for all
  using (true)
  with check (true);
