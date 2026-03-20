-- ============================================================
-- Migration 003 — Add buyer_group to d365_products
-- Supports filtering products by D365 BuyerGroupId
-- ============================================================

alter table d365_products
  add column if not exists buyer_group text;

-- Index for quick lookups by buyer group
create index if not exists idx_d365_products_buyer_group
  on d365_products (buyer_group);
