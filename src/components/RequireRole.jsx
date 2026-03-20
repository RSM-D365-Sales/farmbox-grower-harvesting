import { Navigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { LoadingSpinner } from './StatusMessages'

/**
 * Route guard that restricts access based on user role.
 *
 * Usage:
 *   <Route path="/admin/crops" element={
 *     <RequireRole role="manager"><CropsManagement /></RequireRole>
 *   } />
 *
 * If the user doesn't have the required role, they're redirected to '/'.
 */
export default function RequireRole({ role, children }) {
  const { profile, loading } = useAuth()

  if (loading) return <LoadingSpinner />

  if (!profile || (role === 'manager' && profile.role !== 'manager')) {
    return <Navigate to="/" replace />
  }

  return children
}
