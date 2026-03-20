import { useAuth } from '../contexts/AuthContext'
import { ShieldAlert } from 'lucide-react'

/**
 * Wraps content that requires a specific role.
 * If user doesn't have the role, shows an access-denied message.
 */
export default function RoleGuard({ requiredRole = 'manager', children }) {
  const { user, isManager } = useAuth()

  if (!user) return null

  const hasAccess = requiredRole === 'manager' ? isManager : true

  if (!hasAccess) {
    return (
      <div className="flex flex-col items-center justify-center py-16 text-center">
        <ShieldAlert className="w-12 h-12 text-amber-400 mb-4" />
        <h3 className="text-lg font-medium text-gray-700">Access Restricted</h3>
        <p className="text-sm text-gray-500 mt-1 max-w-md">
          This section requires <span className="font-semibold">Manager</span> access.
          Contact your administrator to request elevated permissions.
        </p>
      </div>
    )
  }

  return children
}
