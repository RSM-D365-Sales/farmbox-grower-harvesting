import { useState } from 'react'
import { Plus, Pencil, Trash2, Sprout, X, Save } from 'lucide-react'
import PageHeader from '../components/PageHeader'
import { LoadingSpinner, ErrorMessage, EmptyState } from '../components/StatusMessages'
import { useCrops, useCreateCrop, useUpdateCrop, useDeleteCrop } from '../hooks/useSupabase'

export default function CropsManagement() {
  const { data: crops, isLoading, error, refetch } = useCrops()
  const createCrop = useCreateCrop()
  const updateCrop = useUpdateCrop()
  const deleteCrop = useDeleteCrop()

  const [showForm, setShowForm] = useState(false)
  const [editingId, setEditingId] = useState(null)
  const [form, setForm] = useState({
    name: '',
    variety: '',
    avg_grow_days: '',
    lead_time_hours: '24',
    unit_of_measure: 'lbs',
    target_yield_per_acre: '',
  })

  const resetForm = () => {
    setForm({ name: '', variety: '', avg_grow_days: '', lead_time_hours: '24', unit_of_measure: 'lbs', target_yield_per_acre: '' })
    setEditingId(null)
    setShowForm(false)
  }

  const startEdit = (crop) => {
    setForm({
      name: crop.name,
      variety: crop.variety || '',
      avg_grow_days: String(crop.avg_grow_days),
      lead_time_hours: String(crop.lead_time_hours),
      unit_of_measure: crop.unit_of_measure,
      target_yield_per_acre: crop.target_yield_per_acre ? String(crop.target_yield_per_acre) : '',
    })
    setEditingId(crop.id)
    setShowForm(true)
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    const payload = {
      name: form.name,
      variety: form.variety || null,
      avg_grow_days: parseInt(form.avg_grow_days),
      lead_time_hours: parseInt(form.lead_time_hours),
      unit_of_measure: form.unit_of_measure,
      target_yield_per_acre: form.target_yield_per_acre ? parseFloat(form.target_yield_per_acre) : null,
    }

    try {
      if (editingId) {
        await updateCrop.mutateAsync({ id: editingId, ...payload })
      } else {
        await createCrop.mutateAsync(payload)
      }
      resetForm()
    } catch (err) {
      console.error('Save failed:', err)
    }
  }

  const handleDelete = async (id, name) => {
    if (!confirm(`Delete crop "${name}"? This cannot be undone.`)) return
    try {
      await deleteCrop.mutateAsync(id)
    } catch (err) {
      console.error('Delete failed:', err)
    }
  }

  if (isLoading) return <LoadingSpinner />
  if (error) return <ErrorMessage message={error.message} onRetry={refetch} />

  return (
    <div>
      <PageHeader
        title="Crops Management"
        description="Add, edit, and remove crop varieties for grow cycle planning"
        actions={
          <button
            onClick={() => { resetForm(); setShowForm(true) }}
            className="flex items-center gap-2 px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors"
          >
            <Plus className="w-4 h-4" /> Add Crop
          </button>
        }
      />

      {/* Add/Edit Form */}
      {showForm && (
        <div className="bg-white rounded-xl border border-gray-200 shadow-sm p-5 mb-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-semibold text-gray-700">
              {editingId ? 'Edit Crop' : 'New Crop'}
            </h3>
            <button onClick={resetForm} className="p-1 hover:bg-gray-100 rounded">
              <X className="w-4 h-4 text-gray-400" />
            </button>
          </div>
          <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Crop Name *</label>
              <input
                type="text"
                required
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                placeholder="e.g. Baby Spinach"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Variety</label>
              <input
                type="text"
                value={form.variety}
                onChange={(e) => setForm({ ...form, variety: e.target.value })}
                placeholder="e.g. Bloomsdale"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Avg Grow Days *</label>
              <input
                type="number"
                required
                min="1"
                value={form.avg_grow_days}
                onChange={(e) => setForm({ ...form, avg_grow_days: e.target.value })}
                placeholder="21"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Lead Time (hours) *</label>
              <input
                type="number"
                required
                min="1"
                value={form.lead_time_hours}
                onChange={(e) => setForm({ ...form, lead_time_hours: e.target.value })}
                placeholder="24"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Unit of Measure *</label>
              <select
                value={form.unit_of_measure}
                onChange={(e) => setForm({ ...form, unit_of_measure: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              >
                <option value="lbs">lbs</option>
                <option value="kg">kg</option>
                <option value="each">each</option>
                <option value="bunches">bunches</option>
                <option value="flats">flats</option>
                <option value="cases">cases</option>
              </select>
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 mb-1">Target Yield / Acre</label>
              <input
                type="number"
                step="0.01"
                min="0"
                value={form.target_yield_per_acre}
                onChange={(e) => setForm({ ...form, target_yield_per_acre: e.target.value })}
                placeholder="800"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
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
                disabled={createCrop.isPending || updateCrop.isPending}
                className="flex items-center gap-2 px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors disabled:opacity-50"
              >
                <Save className="w-4 h-4" />
                {editingId ? 'Update Crop' : 'Save Crop'}
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Crops Table */}
      {crops?.length === 0 ? (
        <EmptyState
          icon={Sprout}
          title="No crops configured"
          description="Add your first crop to start planning grow cycles"
          action={
            <button
              onClick={() => { resetForm(); setShowForm(true) }}
              className="px-4 py-2 bg-primary-600 text-white text-sm rounded-lg hover:bg-primary-700"
            >
              Add First Crop
            </button>
          }
        />
      ) : (
        <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="bg-gray-50 border-b border-gray-100">
                  <th className="text-left px-5 py-3 font-medium text-gray-500">Crop</th>
                  <th className="text-left px-5 py-3 font-medium text-gray-500">Variety</th>
                  <th className="text-left px-5 py-3 font-medium text-gray-500">Grow Days</th>
                  <th className="text-left px-5 py-3 font-medium text-gray-500">Lead Time</th>
                  <th className="text-left px-5 py-3 font-medium text-gray-500">Unit</th>
                  <th className="text-left px-5 py-3 font-medium text-gray-500">Target Yield/Acre</th>
                  <th className="text-left px-5 py-3 font-medium text-gray-500">Short Lead?</th>
                  <th className="text-right px-5 py-3 font-medium text-gray-500">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {crops?.map((crop) => (
                  <tr key={crop.id} className="hover:bg-gray-50/50">
                    <td className="px-5 py-3 font-medium text-gray-800">{crop.name}</td>
                    <td className="px-5 py-3 text-gray-600">{crop.variety || '—'}</td>
                    <td className="px-5 py-3 text-gray-600">{crop.avg_grow_days}d</td>
                    <td className="px-5 py-3 text-gray-600">{crop.lead_time_hours}h</td>
                    <td className="px-5 py-3 text-gray-600">{crop.unit_of_measure}</td>
                    <td className="px-5 py-3 text-gray-600">
                      {crop.target_yield_per_acre ? crop.target_yield_per_acre.toLocaleString() : '—'}
                    </td>
                    <td className="px-5 py-3">
                      {crop.is_short_lead_time ? (
                        <span className="inline-flex px-2 py-0.5 text-xs font-medium rounded-full bg-amber-100 text-amber-700">Yes</span>
                      ) : (
                        <span className="text-gray-400 text-xs">No</span>
                      )}
                    </td>
                    <td className="px-5 py-3 text-right">
                      <div className="flex justify-end gap-1">
                        <button
                          onClick={() => startEdit(crop)}
                          className="p-1.5 rounded hover:bg-gray-100 text-gray-400 hover:text-primary-600"
                          title="Edit"
                        >
                          <Pencil className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(crop.id, crop.name)}
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
