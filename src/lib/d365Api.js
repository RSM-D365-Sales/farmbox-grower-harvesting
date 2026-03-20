/**
 * D365 Finance & Supply Chain — API Service Layer
 *
 * D365 F&SCM exposes data through OData v4 Data Entities.
 * Authentication uses OAuth 2.0 client-credentials flow against Azure AD.
 *
 * ARCHITECTURE:
 *   Browser → Supabase Edge Function (proxy) → D365 OData endpoints
 *
 * The Edge Function holds the client_secret and handles token acquisition,
 * so no D365 credentials ever reach the browser.
 *
 * KEY D365 OData ENTITIES USED:
 * ┌──────────────────────────────┬───────────────────────────────────────────────┐
 * │ Entity                       │ URL path                                      │
 * ├──────────────────────────────┼───────────────────────────────────────────────┤
 * │ ReleasedProductsV2           │ /data/ReleasedProductsV2                      │
 * │ Warehouses                   │ /data/Warehouses                              │
 * │ CustomersV3                  │ /data/CustomersV3                             │
 * │ ProductionOrderHeaders       │ /data/ProductionOrderHeaders                  │
 * │ InventOnHandEntities         │ /data/InventOnHandEntities                    │
 * │ SalesOrderHeadersV2          │ /data/SalesOrderHeadersV2                     │
 * │ SalesOrderLinesV2            │ /data/SalesOrderLinesV2                       │
 * │ InventoryJournalHeaders      │ /data/InventoryJournalHeaders (outbound)      │
 * │ InventoryJournalLines        │ /data/InventoryJournalLines  (outbound)       │
 * └──────────────────────────────┴───────────────────────────────────────────────┘
 */

import { supabase } from './supabase'

// ─── Configuration ─────────────────────────────────────────
// The Edge Function URL — Supabase functions invoke prefix
const EDGE_FN_BASE = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1`

/**
 * Call our Supabase Edge Function that proxies to D365.
 * The Edge Function handles OAuth token acquisition.
 *
 * NOTE: The Edge Function MUST be deployed with --no-verify-jwt
 * (or "Verify JWT" toggled OFF in Dashboard) so it can be called
 * without a logged-in Supabase user session.
 */
async function callD365Proxy(action, params = {}) {
  // Use session token if available, otherwise fall back to anon key
  let token = import.meta.env.VITE_SUPABASE_ANON_KEY
  try {
    const { data: { session } } = await supabase.auth.getSession()
    if (session?.access_token) token = session.access_token
  } catch {
    // No session — use anon key
  }

  const response = await fetch(`${EDGE_FN_BASE}/d365-proxy`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
      'apikey': import.meta.env.VITE_SUPABASE_ANON_KEY,
    },
    body: JSON.stringify({ action, ...params }),
  })

  if (!response.ok) {
    // Distinguish Supabase auth errors from D365 errors
    if (response.status === 401) {
      const text = await response.text()
      if (text.includes('JWT') || text.includes('Invalid token') || text.includes('missing authorization')) {
        throw new Error(
          'Supabase returned 401 — the Edge Function requires JWT verification to be DISABLED. ' +
          'Go to Supabase Dashboard → Edge Functions → d365-proxy → Settings → toggle OFF "Verify JWT", ' +
          'then redeploy. This is NOT a D365 auth error.'
        )
      }
    }
    const err = await response.json().catch(() => ({ error: response.statusText }))
    throw new Error(err.error || `D365 proxy error: ${response.status}`)
  }

  return response.json()
}

// ─── D365 Health Check ─────────────────────────────────────

/**
 * Verify D365 connection and credential configuration.
 * Returns status, config summary, and any errors.
 */
export async function checkD365Health() {
  return callD365Proxy('health_check')
}

// ─── D365 Inbound (Extract) Operations ─────────────────────

/**
 * Fetch Released Products from D365 and upsert into d365_products
 */
export async function extractD365Products(options = {}) {
  const { top = 100, filter, buyerGroup } = options
  const params = { top, filter }
  if (buyerGroup) params.buyerGroup = buyerGroup
  const result = await callD365Proxy('extract_products', params)

  // Log the sync
  await logSync('products', result.count, result.upserted)

  return result
}

/**
 * Fetch Warehouses from D365 and upsert into d365_warehouses
 */
export async function extractD365Warehouses() {
  const result = await callD365Proxy('extract_warehouses')
  await logSync('warehouses', result.count, result.upserted)
  return result
}

/**
 * Fetch Customers from D365 and upsert into d365_customers
 */
export async function extractD365Customers(options = {}) {
  const { top = 200 } = options
  const result = await callD365Proxy('extract_customers', { top })
  await logSync('customers', result.count, result.upserted)
  return result
}

/**
 * Fetch Production Orders from D365 and upsert into d365_production_orders
 */
export async function extractD365ProductionOrders(options = {}) {
  const { top = 100, filter } = options
  const result = await callD365Proxy('extract_production_orders', { top, filter })
  await logSync('production_orders', result.count, result.upserted)
  return result
}

/**
 * Fetch On-Hand Inventory snapshot from D365
 */
export async function extractD365Inventory(options = {}) {
  const { itemNumbers = [], warehouseId } = options
  const result = await callD365Proxy('extract_inventory', { itemNumbers, warehouseId })
  await logSync('inventory_onhand', result.count, result.upserted)
  return result
}

/**
 * Fetch Sales Orders (demand) from D365
 */
export async function extractD365SalesOrders(options = {}) {
  const { top = 200, filter } = options
  const result = await callD365Proxy('extract_sales_orders', { top, filter })
  await logSync('sales_orders', result.count, result.upserted)
  return result
}

// ─── D365 Outbound (Push) Operations ───────────────────────

/**
 * Push a yield record to D365 as an Inventory Counting Journal
 */
export async function pushYieldToD365(yieldRecord) {
  return callD365Proxy('push_inventory_journal', { yieldRecord })
}

/**
 * Push a completed harvest to D365 as a Production Order RAF (Report as Finished)
 */
export async function pushHarvestToD365(harvestData) {
  return callD365Proxy('push_production_raf', { harvestData })
}

// ─── Helpers ───────────────────────────────────────────────

async function logSync(entityName, fetched, upserted) {
  try {
    await supabase.from('d365_sync_log').insert({
      entity_name: entityName,
      direction: 'inbound',
      records_fetched: fetched || 0,
      records_upserted: upserted || 0,
      status: 'success',
      completed_at: new Date().toISOString(),
    })
  } catch (e) {
    console.warn('Failed to log sync:', e)
  }
}

// ─── Direct Supabase Queries (read cached D365 data) ──────

export async function getD365Products(filters = {}) {
  let q = supabase.from('d365_products').select('*').order('product_name')
  if (filters.search) q = q.ilike('product_name', `%${filters.search}%`)
  if (filters.item_group) q = q.eq('item_group', filters.item_group)
  const { data, error } = await q
  if (error) throw error
  return data
}

export async function getD365Warehouses() {
  const { data, error } = await supabase.from('d365_warehouses').select('*').order('warehouse_name')
  if (error) throw error
  return data
}

export async function getD365Customers(filters = {}) {
  let q = supabase.from('d365_customers').select('*').order('customer_name')
  if (filters.search) q = q.ilike('customer_name', `%${filters.search}%`)
  const { data, error } = await q
  if (error) throw error
  return data
}

export async function getD365ProductionOrders(filters = {}) {
  let q = supabase.from('d365_production_orders').select('*').order('scheduled_start_date', { ascending: false })
  if (filters.status) q = q.eq('status', filters.status)
  if (filters.item_number) q = q.eq('item_number', filters.item_number)
  const { data, error } = await q
  if (error) throw error
  return data
}

export async function getD365Inventory(filters = {}) {
  let q = supabase.from('d365_inventory_onhand').select('*').order('item_number')
  if (filters.item_number) q = q.eq('item_number', filters.item_number)
  if (filters.warehouse_id) q = q.eq('warehouse_id', filters.warehouse_id)
  const { data, error } = await q
  if (error) throw error
  return data
}

export async function getD365SalesOrders(filters = {}) {
  let q = supabase.from('d365_sales_orders').select('*').order('requested_ship_date', { ascending: true })
  if (filters.order_status) q = q.eq('order_status', filters.order_status)
  if (filters.item_number) q = q.eq('item_number', filters.item_number)
  const { data, error } = await q
  if (error) throw error
  return data
}

export async function getD365SyncLog() {
  const { data, error } = await supabase
    .from('d365_sync_log')
    .select('*')
    .order('started_at', { ascending: false })
    .limit(50)
  if (error) throw error
  return data
}

export async function getD365EntityMappings(localType) {
  let q = supabase.from('d365_entity_mappings').select('*')
  if (localType) q = q.eq('local_entity_type', localType)
  const { data, error } = await q
  if (error) throw error
  return data
}

export async function upsertD365EntityMapping(mapping) {
  const { data, error } = await supabase
    .from('d365_entity_mappings')
    .upsert(mapping, { onConflict: 'local_entity_type,local_entity_id,d365_entity_type' })
    .select()
    .single()
  if (error) throw error
  return data
}
