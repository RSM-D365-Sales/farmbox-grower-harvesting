import { createContext, useContext, useState, useEffect } from 'react'
import { supabase } from '../lib/supabase'

const AuthContext = createContext(null)

/**
 * Simple role-based auth using the app_users table.
 *
 * Roles:
 *   'manager'  — Full access: manage crops, team members, fields, + everything below
 *   'operator' — Dashboard, grow cycles, scheduling, yield management (no setup pages)
 *
 * On mount, checks localStorage for a saved email.
 * If none found, shows the login screen.
 */
export function AuthProvider({ children }) {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    const savedEmail = localStorage.getItem('grower_user_email')
    if (savedEmail) {
      loadUser(savedEmail)
    } else {
      setLoading(false)
    }
  }, [])

  async function loadUser(email) {
    setLoading(true)
    setError(null)
    try {
      const { data, error: dbError } = await supabase
        .from('app_users')
        .select('*')
        .eq('email', email.toLowerCase().trim())
        .eq('is_active', true)
        .single()

      if (dbError || !data) {
        localStorage.removeItem('grower_user_email')
        setUser(null)
        if (dbError && !dbError.message.includes('No rows')) {
          setError('User not found or inactive. Contact your manager.')
        }
      } else {
        setUser(data)
        localStorage.setItem('grower_user_email', data.email)
      }
    } catch {
      localStorage.removeItem('grower_user_email')
      setUser(null)
    }
    setLoading(false)
  }

  async function login(email) {
    setError(null)
    await loadUser(email)
  }

  function logout() {
    localStorage.removeItem('grower_user_email')
    setUser(null)
    setError(null)
  }

  function switchUser() {
    logout()
  }

  const isManager = user?.role === 'manager'
  const isOperator = user?.role === 'operator'

  return (
    <AuthContext.Provider
      value={{
        user,
        loading,
        error,
        isManager,
        isOperator,
        login,
        logout,
        switchUser,
      }}
    >
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within <AuthProvider>')
  return ctx
}
