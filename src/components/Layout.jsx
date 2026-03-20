import { useState } from 'react'
import { Outlet, NavLink } from 'react-router-dom'
import {
  LayoutDashboard,
  Sprout,
  CalendarDays,
  BarChart3,
  ArrowRightLeft,
  Menu,
  X,
  Leaf,
  Package,
  Factory,
  ShoppingCart,
  Link2,
  Settings,
  Users,
  MapPin,
  LogOut,
  Shield,
} from 'lucide-react'
import { useAuth } from '../contexts/AuthContext'

const navItems = [
  { to: '/', label: 'Dashboard', icon: LayoutDashboard },
  { to: '/grow-cycles', label: 'Grow Cycles', icon: Sprout },
  { to: '/harvest-scheduling', label: 'Harvest Scheduling', icon: CalendarDays },
  { to: '/yield-management', label: 'Yield Management', icon: BarChart3 },
  { to: '/d365', label: 'D365 Sync Queue', icon: ArrowRightLeft },
]

const setupNavItems = [
  { to: '/setup/crops', label: 'Manage Crops', icon: Sprout },
  { to: '/setup/fields', label: 'Manage Fields', icon: MapPin },
  { to: '/setup/team', label: 'Team Members', icon: Users },
]

const d365NavItems = [
  { to: '/d365/products', label: 'D365 Products', icon: Package },
  { to: '/d365/production-orders', label: 'Production Orders', icon: Factory },
  { to: '/d365/demand', label: 'Demand & Inventory', icon: ShoppingCart },
  { to: '/d365/mappings', label: 'Mappings & Log', icon: Link2 },
]

export default function Layout() {
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const { user, isManager, logout } = useAuth()

  return (
    <div className="min-h-screen flex">
      {/* Mobile overlay */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 bg-black/40 z-30 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`
          fixed inset-y-0 left-0 z-40 w-64 bg-primary-800 text-white
          transform transition-transform duration-200 ease-in-out
          lg:relative lg:translate-x-0
          ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'}
        `}
      >
        <div className="flex items-center gap-3 px-6 py-5 border-b border-primary-700">
          <Leaf className="w-8 h-8 text-primary-300" />
          <div>
            <h1 className="text-lg font-bold leading-tight">Grower</h1>
            <p className="text-xs text-primary-300">Harvest Management</p>
          </div>
        </div>

        <nav className="mt-4 px-3 space-y-1">
          {navItems.map(({ to, label, icon: Icon }) => (
            <NavLink
              key={to}
              to={to}
              end={to === '/'}
              onClick={() => setSidebarOpen(false)}
              className={({ isActive }) =>
                `flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${
                  isActive
                    ? 'bg-primary-700 text-white'
                    : 'text-primary-200 hover:bg-primary-700/50 hover:text-white'
                }`
              }
            >
              <Icon className="w-5 h-5" />
              {label}
            </NavLink>
          ))}

          {/* D365 F&SCM Section */}
          <div className="pt-4 mt-4 border-t border-primary-700">
            <p className="px-3 pb-2 text-[10px] uppercase tracking-wider text-primary-400">D365 F&SCM</p>
            {d365NavItems.map(({ to, label, icon: Icon }) => (
              <NavLink
                key={to}
                to={to}
                onClick={() => setSidebarOpen(false)}
                className={({ isActive }) =>
                  `flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${
                    isActive
                      ? 'bg-primary-700 text-white'
                      : 'text-primary-200 hover:bg-primary-700/50 hover:text-white'
                  }`
                }
              >
                <Icon className="w-5 h-5" />
                {label}
              </NavLink>
            ))}
          </div>

          {/* Setup Section — Manager Only */}
          {isManager && (
            <div className="pt-4 mt-4 border-t border-primary-700">
              <p className="px-3 pb-2 text-[10px] uppercase tracking-wider text-primary-400">
                <Settings className="w-3 h-3 inline mr-1" />Setup
              </p>
              {setupNavItems.map(({ to, label, icon: Icon }) => (
                <NavLink
                  key={to}
                  to={to}
                  onClick={() => setSidebarOpen(false)}
                  className={({ isActive }) =>
                    `flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${
                      isActive
                        ? 'bg-primary-700 text-white'
                        : 'text-primary-200 hover:bg-primary-700/50 hover:text-white'
                    }`
                  }
                >
                  <Icon className="w-5 h-5" />
                  {label}
                </NavLink>
              ))}
            </div>
          )}
        </nav>

        <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-primary-700">
          <div className="flex items-center justify-between">
            <div className="text-xs text-primary-300 min-w-0">
              <p className="font-medium truncate">{user?.full_name}</p>
              <p className="flex items-center gap-1 text-primary-400 mt-0.5">
                <Shield className="w-3 h-3" />
                {user?.role === 'manager' ? 'Manager' : 'Operator'}
              </p>
            </div>
            <button
              onClick={logout}
              className="p-1.5 rounded-lg text-primary-400 hover:text-white hover:bg-primary-700 transition-colors"
              title="Sign out"
            >
              <LogOut className="w-4 h-4" />
            </button>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <div className="flex-1 flex flex-col min-w-0">
        {/* Top bar */}
        <header className="sticky top-0 z-20 bg-white border-b border-gray-200 px-4 py-3 flex items-center gap-4 lg:px-6">
          <button
            onClick={() => setSidebarOpen(true)}
            className="lg:hidden p-1.5 rounded-md hover:bg-gray-100"
          >
            <Menu className="w-5 h-5" />
          </button>
          <h2 className="text-lg font-semibold text-gray-800">
            Grower Harvesting Dashboard
          </h2>
        </header>

        {/* Page content */}
        <main className="flex-1 p-4 lg:p-6 overflow-auto">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
