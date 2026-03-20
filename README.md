# Grower Harvesting Dashboard

A React + Vite + Supabase dashboard for managing grow cycles, harvest scheduling, and yield management — with **bidirectional** D365 Finance & Supply Chain integration.

## Getting Started

```bash
npm install
npm run dev
```

## Environment Variables

Create a `.env` file with your Supabase credentials:

```
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

## Supabase Setup

Run both migration files in your Supabase SQL editor (in order):

1. `supabase/migrations/001_initial_schema.sql` — Core tables (fields, crops, grow cycles, yields, etc.)
2. `supabase/migrations/002_d365_inbound_tables.sql` — D365 inbound cache tables (products, warehouses, customers, production orders, inventory, sales orders, sync log, entity mappings)

## Features

- **KPI Dashboard** — Real-time metrics on active fields, harvest readiness, yield totals, and D365 sync status
- **Grow Cycle Tracking** — Field prep → Planting → Growth → Harvest pipeline
- **Harvest Scheduling** — Calendar-based scheduling with team member assignments
- **Yield Management** — Track product yields with short lead-time alerts
- **D365 Integration (Outbound)** — Staging queue to push harvest and yield data to D365 F&SCM
- **D365 Products (Inbound)** — Extract released products from D365 via OData
- **D365 Production Orders (Inbound)** — Pull production order status from D365
- **D365 Demand & Inventory (Inbound)** — Extract sales orders and on-hand inventory
- **D365 Mappings** — Map local crops to D365 products and fields to D365 warehouses

---

## D365 Finance & Supply Chain Integration

### Architecture Overview

```
┌─────────────────┐       ┌──────────────────────┐       ┌──────────────────────┐
│   React App     │       │  Supabase Edge Fn     │       │  D365 F&SCM          │
│   (Browser)     │──────▶│  d365-proxy           │──────▶│  OData v4 Endpoints  │
│                 │       │  (OAuth + proxy)       │       │                      │
│                 │◀──────│                        │◀──────│                      │
└─────────────────┘       └──────────────────────┘       └──────────────────────┘
        │                          │
        │                          ▼
        │                 ┌──────────────────────┐
        └────────────────▶│  Supabase PostgreSQL  │
                          │  (cache + staging)    │
                          └──────────────────────┘
```

**Data flows in two directions:**

| Direction | What | Mechanism |
|-----------|------|-----------|
| **Inbound (D365 → App)** | Products, warehouses, customers, production orders, on-hand inventory, sales orders | OData GET → cache in Supabase |
| **Outbound (App → D365)** | Yield records, harvest completions | Staging queue → OData POST (inventory journals, RAF) |

### D365 OData Entities Used

| D365 OData Entity | Direction | Maps To |
|---|---|---|
| `ReleasedProductsV2` | Inbound | `d365_products` table — item master data, shelf life, tracking dimensions |
| `Warehouses` | Inbound | `d365_warehouses` table — sites and warehouses for field mapping |
| `CustomersV3` | Inbound | `d365_customers` table — customer accounts for sales order context |
| `ProductionOrderHeaders` | Inbound | `d365_production_orders` table — production scheduling and status |
| `InventOnHandEntities` | Inbound | `d365_inventory_onhand` table — available physical/ordered inventory |
| `SalesOrderHeadersV2` / `SalesOrderLinesV2` | Inbound | `d365_sales_orders` table — demand signal with ship dates |
| `InventoryJournalHeaders` / `InventoryJournalLines` | Outbound | Yield records pushed as inventory counting journals |
| `ProductionOrderHeaders (RAF action)` | Outbound | Harvest completions pushed as Report as Finished |

### How Extraction Works

1. User clicks **"Extract from D365"** on any D365 page (Products, Production Orders, Demand & Inventory)
2. The React app calls `src/lib/d365Api.js` which sends a POST to the Supabase Edge Function
3. The Edge Function (`supabase/functions/d365-proxy/index.ts`):
   - Acquires an OAuth 2.0 access token from Azure AD using client-credentials flow
   - Calls the D365 OData v4 endpoint with `$select`, `$filter`, `$top` parameters
   - Maps the OData response fields to Supabase table columns
   - Upserts the data into the appropriate Supabase table
4. The React app refreshes its TanStack Query cache, showing the extracted data

### How Outbound Push Works

1. When a yield record is created or a harvest is completed, a row is inserted into `d365_sync_queue`
2. The D365 Sync Queue page shows pending/processing/synced/failed items
3. The Edge Function can push:
   - **Yield data** → D365 Inventory Counting Journal (creates header + lines)
   - **Harvest completion** → D365 Production Order Report as Finished (RAF action)

### Entity Mappings

The **D365 Mappings** page lets you link local entities to D365:
- **Crop → D365 Product**: Map each crop (e.g., "Baby Spinach") to its D365 item number
- **Field → D365 Warehouse**: Map each growing field to a D365 warehouse/site

These mappings are stored in `d365_entity_mappings` and used when pushing outbound data to ensure the correct D365 item/warehouse references.

### Setting Up the D365 Connection

#### 1. Azure AD App Registration

Create an app registration in Azure AD for your D365 environment:

```
Azure Portal → Azure Active Directory → App Registrations → New Registration
```

- **Name**: Grower Harvesting Integration
- **Supported account types**: Single tenant
- **API permissions**: Add `Dynamics ERP` → `CustomService.ReadWrite.All` (or `Odata.Read.All` + `Odata.Write.All`)
- **Certificates & secrets**: Create a client secret

#### 2. D365 F&SCM Configuration

In D365 Finance & Supply Chain:
- **System administration → Setup → Azure Active Directory applications**: Register the app's Client ID
- **Data management → Framework parameters → Entity settings**: Ensure the OData entities listed above are enabled
- Assign the app registration appropriate security roles (e.g., a custom "Integration User" role with read access to products, warehouses, production orders, sales orders, on-hand inventory)

#### 3. Supabase Edge Function Secrets

Set these secrets in your Supabase project dashboard under **Edge Functions → Secrets**:

```
D365_TENANT_ID=<your-azure-ad-tenant-id>
D365_CLIENT_ID=<your-app-registration-client-id>
D365_CLIENT_SECRET=<your-client-secret>
D365_ENVIRONMENT_URL=https://yourorg.operations.dynamics.com
```

#### 4. Deploy the Edge Function

```bash
# Install Supabase CLI if needed
npm install -g supabase

# Login and link to your project
supabase login
supabase link --project-ref <your-project-ref>

# Deploy the D365 proxy function
supabase functions deploy d365-proxy --no-verify-jwt
```

#### 5. Run the Database Migration

In the Supabase SQL editor, run `supabase/migrations/002_d365_inbound_tables.sql` to create all the inbound cache tables.

### D365 Data Flow Summary

```
INBOUND (Extract from D365):
  D365 ReleasedProductsV2    ──▶  d365_products         ──▶  D365 Products page
  D365 Warehouses            ──▶  d365_warehouses        ──▶  D365 Mappings page
  D365 CustomersV3           ──▶  d365_customers         ──▶  D365 Demand page context
  D365 ProductionOrderHeaders──▶  d365_production_orders ──▶  D365 Production Orders page
  D365 InventOnHandEntities  ──▶  d365_inventory_onhand  ──▶  D365 Demand page (Inventory tab)
  D365 SalesOrderHeaders/Lines──▶ d365_sales_orders      ──▶  D365 Demand page (Orders tab)

OUTBOUND (Push to D365):
  yield_records        ──▶  d365_sync_queue  ──▶  D365 InventoryJournalHeaders/Lines
  harvest_schedules    ──▶  d365_sync_queue  ──▶  D365 ProductionOrderHeaders (RAF)

MAPPINGS:
  crops  ←───mapping───▶  d365_products    (Crop → Item Number)
  fields ←───mapping───▶  d365_warehouses  (Field → Warehouse ID)
```

### Source Files

| File | Purpose |
|------|---------|
| `src/lib/d365Api.js` | D365 API service — calls Edge Function, reads cached data from Supabase |
| `src/hooks/useD365.js` | React hooks — TanStack Query wrappers for all D365 data operations |
| `src/pages/D365Integration.jsx` | Outbound sync queue monitor (push to D365) |
| `src/pages/D365Products.jsx` | Browse/extract D365 released products |
| `src/pages/D365ProductionOrders.jsx` | Browse/extract D365 production orders |
| `src/pages/D365Demand.jsx` | Browse/extract sales orders and on-hand inventory |
| `src/pages/D365Mappings.jsx` | Map crops→products, fields→warehouses, view sync history |
| `supabase/functions/d365-proxy/index.ts` | Edge Function — OAuth2 token acquisition + OData proxy |
| `supabase/migrations/002_d365_inbound_tables.sql` | Database tables for D365 cached data |
