import { useState } from 'react'
import { Plus, Pencil, Trash2, MapPin, X, Save } from 'lucide-react'
import PageHeader from '../components/PageHeader'
import { LoadingSpinner, ErrorMessage, EmptyState } from '../components/StatusMessages'
import { useFields, useCreateField, useUpdateField, useDeleteField } from '../hooks/useSupabase'

const STATUSES = [
  { value: 'idle', label: 'Idle', color: 'bg-gray-100 text-gray-600' },
  { value: 'field_prep', label: 'Field Prep', color: 'bg-yellow-100 text-yellow-700' },
  { value: 'planted', label: 'Planted', color: 'bg-blue-100 text-blue-700' },
  { value: 'growing', label: 'Growing', color: 'bg-green-100 text-green-700' },
  { value: 'harvest_ready', label: 'Harvest Ready', color: 'bg-orange-100 text-orange-700' },
  { value: 'harvesting', label: 'Harvesting', color: 'bg-red-100 text-red-700' },
  { value: 'complete', label: 'Complete', color: 'bg-purple-100 text-purple-700' },
]

const SOIL_TYPES = ['Loam', 'Sandy Loam', 'Clay Loam', 'Silt Loam', 'Sandy', 'Clay', 'Peat']

export default function FieldsManagement() {
  const { data: fields, isLoading, error, refetch } = useFields()
  const createField = useCreateField()
  const updateField = useUpdateField()
  const deleteField = useDeleteField()

  const [showForm, setShowForm] = useState(false)
  const [editingId, setEditingId] = useState(null)
  const [form, setForm] = useState({
    name: '',
    location: '',
    area_acres: '',
    soil_type: '',
    status: 'idle',
  })

  const resetForm = () => {
    setForm({ name: '', location: '', area_acres: '', soil_type: '', status: 'idle' })
    setEditingId(null)
    setShowForm(false)
  }

  const startEdit = (field) => {
    setForm({
      name: field.name,
      location: field.location || '',
      area_acres: field.area_acres ? String(field.area_acres) : '',
      soil_type: field.soil_type || '',
      status: field.status,
    })
    setEditingId(field.id)
    setShowForm(true)
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    const payload = {
      name: form.name,
      location: form.location || null,
      area_acres: form.area_acres ? parseFloat(form.area_acres) : null,
      soil_type: form.soil_type || null,
      status: form.status,
    }

    try {
      if (editingId) {
        await updateField.mutateAsync({ id: editingId, ...payload })
      } else {
        await createField.mutateAsync(payload)
      }
      resetForm()
    } catch (err) {
      console.error('Save failed:', err)
    }
  }

  const handleDelete = async (id, name) => {
    if (!confirm(`Delete field "${name}"? This will also remove associated grow cycles.`)) return
    try {
      await deleteField.mutateAsync(id)
    } catch (err) {
      console.error('Delete failed:', err)
    }
  }

  if (isLoading) return <LoadingSpinner />
  if (error) return <ErrorMessage message={error.message} onRetry={refetch} />

  return (
    <div>
      <PageHeader
        title="Fields & Locations"
        description="Manage growing locations, field areas, and soil types"
        actions={
          <button
            onClick={() => { resetForm(); setShowForm(true) }}
            className="flex items-center gap-2 px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors"
          >
            <Plus className="w-4 h-4" /> Add Field
          </button>
        }
      />

      {/* Add/Edit Form */}
      {showForm && (
        <div className="bg-white rounded-xl border border-gray-200 shadow-sm p-5 mb-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-semibold text-gray-700">
              {editingId ? 'Edit Field' : 'New Field'}
            </h3>
            <button onClick={resetForm} className="p-1 hover:bg-gray-100 rounded">
              <X className="w-4 h-4 text-gray-400" />
            </button>
          </div>
          <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Field Name *</label>
              <input
                type="text"
                required
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                placeholder="e.g. North Ridge A"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Location</label>
              <input
                type="text"
                value={form.location}
                onChange={(e) => setForm({ ...form, location: e.target.value })}
                placeholder="e.g. Block A, North Campus"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Area (acres)</label>
              <input
                type="number"
                step="0.01"
                min="0"
                value={form.area_acres}
                onChange={(e) => setForm({ ...form, area_acres: e.target.value })}
                placeholder="12.5"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Soil Type</label>
              <select
                value={form.soil_type}
                onChange={(e) => setForm({ ...form, soil_type: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              >
                <option value="">Select soil type...</option>
                {SOIL_TYPES.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Status</label>
              <select
                value={form.status}
                onChange={(e) => setForm({ ...form, status: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              >
                {STATUSES.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
              </select>
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
                disabled={createField.isPending || updateField.isPending}
                className="flex items-center gap-2 px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors disabled:opacity-50"
              >
                <Save className="w-4 h-4" />
                {editingId ? 'Update Field' : 'Save Field'}
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Fields Grid */}
      {fields?.length === 0 ? (
        <EmptyState
          icon={MapPin}
          title="No fields configured"
          description="Add growing locations to start planning grow cycles"
          action={
            <button
              onClick={() => { resetForm(); setShowForm(true) }}
              className="px-4 py-2 bg-primary-600 text-white text-sm rounded-lg hover:bg-primary-700"
            >
              Add First Field
            </button>
          }
        />
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
          {fields?.map((field) => {
            const statusObj = STATUSES.find(s => s.value === field.status)
            return (
              <div key={field.id} className="bg-white rounded-xl border border-gray-200 shadow-sm p-5">
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <h3 className="font-semibold text-gray-800">{field.name}</h3>
                    {field.location && (
                      <p className="text-xs text-gray-500 mt-0.5 flex items-center gap-1">
                        <MapPin className="w-3 h-3" /> {field.location}
                      </p>
                    )}
                  </div>
                  <span className={`inline-flex px-2 py-0.5 text-xs font-medium rounded-full ${statusObj?.color || 'bg-gray-100 text-gray-600'}`}>
                    {statusObj?.label || field.status}
                  </span>
                </div>

                <div className="grid grid-cols-2 gap-3 text-sm mb-4">
                  <div>
                    <p className="text-xs text-gray-400">Area</p>
                    <p className="font-medium text-gray-700">{field.area_acres ? `${field.area_acres} acres` : '—'}</p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-400">Soil Type</p>
                    <p className="font-medium text-gray-700">{field.soil_type || '—'}</p>
                  </div>
                </div>

                <div className="flex justify-end gap-1 border-t border-gray-100 pt-3">
                  <button
                    onClick={() => startEdit(field)}
                    className="flex items-center gap-1 px-3 py-1.5 text-xs rounded-lg hover:bg-gray-100 text-gray-500 hover:text-primary-600"
                  >
                    <Pencil className="w-3.5 h-3.5" /> Edit
                  </button>
                  <button
                    onClick={() => handleDelete(field.id, field.name)}
                    className="flex items-center gap-1 px-3 py-1.5 text-xs rounded-lg hover:bg-red-50 text-gray-500 hover:text-red-600"
                  >
                    <Trash2 className="w-3.5 h-3.5" /> Delete
                  </button>
                </div>
              </div>
            )
          })}
        </div>
      )}
    </div>
  )
}
