import { useState } from 'react'
import { Plus, Pencil, Trash2, Users, X, Save, UserCheck, UserX } from 'lucide-react'
import PageHeader from '../components/PageHeader'
import { LoadingSpinner, ErrorMessage, EmptyState } from '../components/StatusMessages'
import { useAllTeamMembers, useCreateTeamMember, useUpdateTeamMember, useDeleteTeamMember } from '../hooks/useSupabase'

const ROLES = [
  { value: 'field_manager', label: 'Field Manager' },
  { value: 'harvester', label: 'Harvester' },
  { value: 'planner', label: 'Planner' },
  { value: 'driver', label: 'Driver' },
  { value: 'quality_inspector', label: 'Quality Inspector' },
]

const roleBadgeColors = {
  field_manager: 'bg-blue-100 text-blue-700',
  harvester: 'bg-green-100 text-green-700',
  planner: 'bg-purple-100 text-purple-700',
  driver: 'bg-amber-100 text-amber-700',
  quality_inspector: 'bg-pink-100 text-pink-700',
}

export default function TeamMembersManagement() {
  const { data: members, isLoading, error, refetch } = useAllTeamMembers()
  const createMember = useCreateTeamMember()
  const updateMember = useUpdateTeamMember()
  const deleteMember = useDeleteTeamMember()

  const [showForm, setShowForm] = useState(false)
  const [editingId, setEditingId] = useState(null)
  const [form, setForm] = useState({
    full_name: '',
    role: 'harvester',
    email: '',
    phone: '',
    is_active: true,
  })

  const resetForm = () => {
    setForm({ full_name: '', role: 'harvester', email: '', phone: '', is_active: true })
    setEditingId(null)
    setShowForm(false)
  }

  const startEdit = (member) => {
    setForm({
      full_name: member.full_name,
      role: member.role,
      email: member.email || '',
      phone: member.phone || '',
      is_active: member.is_active,
    })
    setEditingId(member.id)
    setShowForm(true)
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    const payload = {
      full_name: form.full_name,
      role: form.role,
      email: form.email || null,
      phone: form.phone || null,
      is_active: form.is_active,
    }

    try {
      if (editingId) {
        await updateMember.mutateAsync({ id: editingId, ...payload })
      } else {
        await createMember.mutateAsync(payload)
      }
      resetForm()
    } catch (err) {
      console.error('Save failed:', err)
    }
  }

  const handleDelete = async (id, name) => {
    if (!confirm(`Delete team member "${name}"? This cannot be undone.`)) return
    try {
      await deleteMember.mutateAsync(id)
    } catch (err) {
      console.error('Delete failed:', err)
    }
  }

  const toggleActive = async (member) => {
    try {
      await updateMember.mutateAsync({ id: member.id, is_active: !member.is_active })
    } catch (err) {
      console.error('Toggle failed:', err)
    }
  }

  if (isLoading) return <LoadingSpinner />
  if (error) return <ErrorMessage message={error.message} onRetry={refetch} />

  return (
    <div>
      <PageHeader
        title="Team Members"
        description="Manage harvest crew, field managers, planners, and drivers"
        actions={
          <button
            onClick={() => { resetForm(); setShowForm(true) }}
            className="flex items-center gap-2 px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors"
          >
            <Plus className="w-4 h-4" /> Add Member
          </button>
        }
      />

      {/* Add/Edit Form */}
      {showForm && (
        <div className="bg-white rounded-xl border border-gray-200 shadow-sm p-5 mb-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-semibold text-gray-700">
              {editingId ? 'Edit Team Member' : 'New Team Member'}
            </h3>
            <button onClick={resetForm} className="p-1 hover:bg-gray-100 rounded">
              <X className="w-4 h-4 text-gray-400" />
            </button>
          </div>
          <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Full Name *</label>
              <input
                type="text"
                required
                value={form.full_name}
                onChange={(e) => setForm({ ...form, full_name: e.target.value })}
                placeholder="e.g. Maria Gonzalez"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Role *</label>
              <select
                required
                value={form.role}
                onChange={(e) => setForm({ ...form, role: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              >
                {ROLES.map(r => (
                  <option key={r.value} value={r.value}>{r.label}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Email</label>
              <input
                type="email"
                value={form.email}
                onChange={(e) => setForm({ ...form, email: e.target.value })}
                placeholder="maria@example.com"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Phone</label>
              <input
                type="tel"
                value={form.phone}
                onChange={(e) => setForm({ ...form, phone: e.target.value })}
                placeholder="(555) 123-4567"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
            <div className="flex items-end">
              <label className="flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={form.is_active}
                  onChange={(e) => setForm({ ...form, is_active: e.target.checked })}
                  className="w-4 h-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                />
                <span className="text-sm text-gray-600">Active</span>
              </label>
            </div>
            <div className="md:col-span-3 flex justify-end gap-2">
              <button
                type="button"
                onClick={resetForm}
                className="px-4 py-2 text-sm text-gray-600 hover:text-gray-800"
              >
                Cancel
              </button>
              <button
                type="submit"
                disabled={createMember.isPending || updateMember.isPending}
                className="flex items-center gap-2 px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors disabled:opacity-50"
              >
                <Save className="w-4 h-4" />
                {editingId ? 'Update Member' : 'Save Member'}
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Members Table */}
      {members?.length === 0 ? (
        <EmptyState
          icon={Users}
          title="No team members"
          description="Add team members to assign them to harvest schedules"
          action={
            <button
              onClick={() => { resetForm(); setShowForm(true) }}
              className="px-4 py-2 bg-primary-600 text-white text-sm rounded-lg hover:bg-primary-700"
            >
              Add First Member
            </button>
          }
        />
      ) : (
        <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="bg-gray-50 border-b border-gray-100">
                  <th className="text-left px-5 py-3 font-medium text-gray-500">Name</th>
                  <th className="text-left px-5 py-3 font-medium text-gray-500">Role</th>
                  <th className="text-left px-5 py-3 font-medium text-gray-500">Email</th>
                  <th className="text-left px-5 py-3 font-medium text-gray-500">Phone</th>
                  <th className="text-left px-5 py-3 font-medium text-gray-500">Status</th>
                  <th className="text-right px-5 py-3 font-medium text-gray-500">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {members?.map((m) => (
                  <tr key={m.id} className={`hover:bg-gray-50/50 ${!m.is_active ? 'opacity-50' : ''}`}>
                    <td className="px-5 py-3 font-medium text-gray-800">{m.full_name}</td>
                    <td className="px-5 py-3">
                      <span className={`inline-flex px-2 py-0.5 text-xs font-medium rounded-full ${roleBadgeColors[m.role] || 'bg-gray-100 text-gray-600'}`}>
                        {ROLES.find(r => r.value === m.role)?.label || m.role}
                      </span>
                    </td>
                    <td className="px-5 py-3 text-gray-600">{m.email || '—'}</td>
                    <td className="px-5 py-3 text-gray-600">{m.phone || '—'}</td>
                    <td className="px-5 py-3">
                      <button
                        onClick={() => toggleActive(m)}
                        className={`inline-flex items-center gap-1 px-2 py-0.5 text-xs font-medium rounded-full cursor-pointer ${
                          m.is_active ? 'bg-green-100 text-green-700 hover:bg-green-200' : 'bg-gray-100 text-gray-500 hover:bg-gray-200'
                        }`}
                      >
                        {m.is_active ? <><UserCheck className="w-3 h-3" /> Active</> : <><UserX className="w-3 h-3" /> Inactive</>}
                      </button>
                    </td>
                    <td className="px-5 py-3 text-right">
                      <div className="flex justify-end gap-1">
                        <button
                          onClick={() => startEdit(m)}
                          className="p-1.5 rounded hover:bg-gray-100 text-gray-400 hover:text-primary-600"
                          title="Edit"
                        >
                          <Pencil className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(m.id, m.full_name)}
                          className="p-1.5 rounded hover:bg-red-50 text-gray-400 hover:text-red-600"
                          title="Delete"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  )
}
