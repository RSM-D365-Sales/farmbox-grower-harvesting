-- ============================================================
-- Migration 002 — D365 Inbound Data Cache Tables
-- Tables to store data extracted FROM D365 F&SCM
-- ============================================================

-- -----------------------------------------------
-- D365 CONNECTION CONFIG (stored in Supabase, 
-- referenced by Edge Functions)
-- -----------------------------------------------
create table if not exists d365_connection (
  id uuid primary key default uuid_generate_v4(),
  tenant_id text not null,
  client_id text not null,
  -- client_secret stored in Supabase Vault / Edge Function env, NOT here
  environment_url text not null,       -- e.g. https://yourorg.operations.dynamics.com
  is_active boolean default true,
  last_connected_at timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- -----------------------------------------------
-- D365 RELEASED PRODUCTS (Items / Products)
-- OData entity: ReleasedDistinctProducts  /  ReleasedProducts
-- -----------------------------------------------
create table if not exists d365_products (
  id uuid primary key default uuid_generate_v4(),
  d365_item_number text not null unique,        -- ItemId / ItemNumber
  product_name text,
  product_type text,                             -- Item, Service, BOM
  item_group text,
  product_category text,
  inventory_unit text,                           -- e.g. 'lbs', 'each', 'kg'
  purchase_unit text,
  sales_unit text,
  sales_price numeric(12,2),
  standard_cost numeric(12,2),
  tracking_dimension_group text,                 -- Batch, Serial, None
  is_catch_weight boolean default false,
  shelf_life_days integer,
  raw_payload jsonb,                             -- full OData response stored
  last_synced_at timestamptz default now(),
  created_at timestamptz default now()
);

-- -----------------------------------------------
-- D365 WAREHOUSES
-- OData entity: Warehouses
-- -----------------------------------------------
create table if not exists d365_warehouses (
  id uuid primary key default uuid_generate_v4(),
  d365_warehouse_id text not null unique,        -- WarehouseId
  warehouse_name text,
  site_id text,
  is_default boolean default false,
  address_city text,
  address_state text,
  raw_payload jsonb,
  last_synced_at timestamptz default now(),
  created_at timestamptz default now()
);

-- -----------------------------------------------
-- D365 CUSTOMERS
-- OData entity: CustomersV3
-- -----------------------------------------------
create table if not exists d365_customers (
  id uuid primary key default uuid_generate_v4(),
  d365_customer_account text not null unique,   -- CustomerAccount
  customer_name text,
  customer_group text,
  currency_code text,
  payment_terms text,
  delivery_mode text,
  primary_contact text,
  raw_payload jsonb,
  last_synced_at timestamptz default now(),
  created_at timestamptz default now()
);

-- -----------------------------------------------
-- D365 PRODUCTION ORDERS (inbound view)
-- OData entity: ProductionOrders  
-- -----------------------------------------------
create table if not exists d365_production_orders (
  id uuid primary key default uuid_generate_v4(),
  d365_prod_order_id text not null unique,      -- ProdId
  item_number text,
  item_name text,
  order_quantity numeric(12,2),
  remaining_quantity numeric(12,2),
  unit text,
  status text,                                   -- Created, Estimated, Scheduled, Released, Started, ReportedFinished, Ended
  scheduled_start_date date,
  scheduled_end_date date,
  warehouse_id text,
  site_id text,
  raw_payload jsonb,
  last_synced_at timestamptz default now(),
  created_at timestamptz default now()
);

-- -----------------------------------------------
-- D365 ON-HAND INVENTORY (snapshot)
-- OData entity: InventOnhandEntity / OnHandInventory
-- -----------------------------------------------
create table if not exists d365_inventory_onhand (
  id uuid primary key default uuid_generate_v4(),
  item_number text not null,
  warehouse_id text,
  site_id text,
  available_physical numeric(12,2),
  available_ordered numeric(12,2),
  total_available numeric(12,2),
  unit text,
  batch_number text,
  last_synced_at timestamptz default now(),
  created_at timestamptz default now(),
  unique(item_number, warehouse_id, batch_number)
);

-- -----------------------------------------------
-- D365 SALES ORDERS (demand signal)
-- OData entity: SalesOrderHeadersV2 / SalesOrderLinesV2
-- -----------------------------------------------
create table if not exists d365_sales_orders (
  id uuid primary key default uuid_generate_v4(),
  d365_sales_order_number text not null,
  line_number integer,
  customer_account text,
  customer_name text,
  item_number text,
  item_name text,
  ordered_quantity numeric(12,2),
  delivered_quantity numeric(12,2),
  remaining_quantity numeric(12,2),
  unit text,
  requested_ship_date date,
  confirmed_ship_date date,
  delivery_mode text,
  warehouse_id text,
  order_status text,                             -- Open, Delivered, Invoiced, Cancelled
  raw_payload jsonb,
  last_synced_at timestamptz default now(),
  created_at timestamptz default now(),
  unique(d365_sales_order_number, line_number)
);

-- -----------------------------------------------
-- SYNC LOG — track each inbound extraction run
-- -----------------------------------------------
create table if not exists d365_sync_log (
  id uuid primary key default uuid_generate_v4(),
  entity_name text not null,                     -- 'products', 'warehouses', 'customers', etc.
  direction text not null default 'inbound' check (direction in ('inbound','outbound')),
  records_fetched integer default 0,
  records_upserted integer default 0,
  status text not null default 'running' check (status in ('running','success','failed')),
  error_message text,
  started_at timestamptz default now(),
  completed_at timestamptz,
  duration_ms integer
);

-- -----------------------------------------------
-- ENTITY MAPPING — link D365 items to local crops
-- -----------------------------------------------
create table if not exists d365_entity_mappings (
  id uuid primary key default uuid_generate_v4(),
  local_entity_type text not null check (local_entity_type in ('crop','field')),
  local_entity_id uuid not null,
  d365_entity_type text not null,                -- 'product', 'warehouse'
  d365_entity_ref text not null,                 -- D365 identifier (ItemNumber, WarehouseId)
  created_at timestamptz default now(),
  unique(local_entity_type, local_entity_id, d365_entity_type)
);

-- -----------------------------------------------
-- INDEXES
-- -----------------------------------------------
create index if not exists idx_d365_products_item on d365_products(d365_item_number);
create index if not exists idx_d365_wh_id on d365_warehouses(d365_warehouse_id);
create index if not exists idx_d365_cust_acct on d365_customers(d365_customer_account);
create index if not exists idx_d365_prodorder_id on d365_production_orders(d365_prod_order_id);
create index if not exists idx_d365_so_number on d365_sales_orders(d365_sales_order_number);
create index if not exists idx_d365_inventory_item on d365_inventory_onhand(item_number);
create index if not exists idx_d365_sync_log_entity on d365_sync_log(entity_name);
create index if not exists idx_d365_mappings on d365_entity_mappings(local_entity_type, local_entity_id);
