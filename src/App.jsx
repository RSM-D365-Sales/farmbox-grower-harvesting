import { Routes, Route } from 'react-router-dom'
import { useAuth } from './contexts/AuthContext'
import Layout from './components/Layout'
import LoginPage from './pages/LoginPage'
import Dashboard from './pages/Dashboard'
import GrowCycles from './pages/GrowCycles'
import GrowCycleDetail from './pages/GrowCycleDetail'
import HarvestScheduling from './pages/HarvestScheduling'
import YieldManagement from './pages/YieldManagement'
import ManageCrops from './pages/ManageCrops'
import ManageTeam from './pages/ManageTeam'
import ManageFields from './pages/ManageFields'
import D365Integration from './pages/D365Integration'
import D365Products from './pages/D365Products'
import D365ProductionOrders from './pages/D365ProductionOrders'
import D365Demand from './pages/D365Demand'
import D365Mappings from './pages/D365Mappings'
import { LoadingSpinner } from './components/StatusMessages'

export default function App() {
  const { user, loading } = useAuth()

  if (loading) return <LoadingSpinner />
  if (!user) return <LoginPage />

  return (
    <Routes>
      <Route path="/" element={<Layout />}>
        <Route index element={<Dashboard />} />
        <Route path="grow-cycles" element={<GrowCycles />} />
        <Route path="grow-cycles/:id" element={<GrowCycleDetail />} />
        <Route path="harvest-scheduling" element={<HarvestScheduling />} />
        <Route path="yield-management" element={<YieldManagement />} />
        {/* Manager-only setup pages */}
        <Route path="setup/crops" element={<ManageCrops />} />
        <Route path="setup/team" element={<ManageTeam />} />
        <Route path="setup/fields" element={<ManageFields />} />
        {/* D365 Integration (manager-only in nav, but routable) */}
        <Route path="d365" element={<D365Integration />} />
        <Route path="d365/products" element={<D365Products />} />
        <Route path="d365/production-orders" element={<D365ProductionOrders />} />
        <Route path="d365/demand" element={<D365Demand />} />
        <Route path="d365/mappings" element={<D365Mappings />} />
      </Route>
    </Routes>
  )
}
