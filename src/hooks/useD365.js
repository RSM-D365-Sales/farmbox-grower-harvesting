import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import {
  extractD365Products,
  extractD365Warehouses,
  extractD365Customers,
  extractD365ProductionOrders,
  extractD365Inventory,
  extractD365SalesOrders,
  getD365Products,
  getD365Warehouses,
  getD365Customers,
  getD365ProductionOrders,
  getD365Inventory,
  getD365SalesOrders,
  getD365SyncLog,
  getD365EntityMappings,
  upsertD365EntityMapping,
} from '../lib/d365Api'

// ─── Cached D365 Data (read from Supabase) ─────────────────

export function useD365Products(filters = {}) {
  return useQuery({
    queryKey: ['d365-products', filters],
    queryFn: () => getD365Products(filters),
  })
}

export function useD365Warehouses() {
  return useQuery({
    queryKey: ['d365-warehouses'],
    queryFn: getD365Warehouses,
  })
}

export function useD365Customers(filters = {}) {
  return useQuery({
    queryKey: ['d365-customers', filters],
    queryFn: () => getD365Customers(filters),
  })
}

export function useD365ProductionOrders(filters = {}) {
  return useQuery({
    queryKey: ['d365-production-orders', filters],
    queryFn: () => getD365ProductionOrders(filters),
  })
}

export function useD365Inventory(filters = {}) {
  return useQuery({
    queryKey: ['d365-inventory', filters],
    queryFn: () => getD365Inventory(filters),
  })
}

export function useD365SalesOrders(filters = {}) {
  return useQuery({
    queryKey: ['d365-sales-orders', filters],
    queryFn: () => getD365SalesOrders(filters),
  })
}

export function useD365SyncLog() {
  return useQuery({
    queryKey: ['d365-sync-log'],
    queryFn: getD365SyncLog,
  })
}

export function useD365EntityMappings(localType) {
  return useQuery({
    queryKey: ['d365-entity-mappings', localType],
    queryFn: () => getD365EntityMappings(localType),
  })
}

// ─── Extract (Pull from D365) Mutations ─────────────────────

export function useExtractD365Products() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: extractD365Products,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['d365-products'] })
      qc.invalidateQueries({ queryKey: ['d365-sync-log'] })
    },
  })
}

export function useExtractD365Warehouses() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: extractD365Warehouses,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['d365-warehouses'] })
      qc.invalidateQueries({ queryKey: ['d365-sync-log'] })
    },
  })
}

export function useExtractD365Customers() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: extractD365Customers,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['d365-customers'] })
      qc.invalidateQueries({ queryKey: ['d365-sync-log'] })
    },
  })
}

export function useExtractD365ProductionOrders() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: extractD365ProductionOrders,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['d365-production-orders'] })
      qc.invalidateQueries({ queryKey: ['d365-sync-log'] })
    },
  })
}

export function useExtractD365Inventory() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: extractD365Inventory,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['d365-inventory'] })
      qc.invalidateQueries({ queryKey: ['d365-sync-log'] })
    },
  })
}

export function useExtractD365SalesOrders() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: extractD365SalesOrders,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['d365-sales-orders'] })
      qc.invalidateQueries({ queryKey: ['d365-sync-log'] })
    },
  })
}

// ─── Entity Mapping Mutation ────────────────────────────────

export function useUpsertD365Mapping() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: upsertD365EntityMapping,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['d365-entity-mappings'] })
    },
  })
}
