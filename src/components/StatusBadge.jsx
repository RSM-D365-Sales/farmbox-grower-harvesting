const statusConfig = {
  scheduled: { label: 'Scheduled', color: 'bg-blue-100 text-blue-700' },
  in_progress: { label: 'In Progress', color: 'bg-yellow-100 text-yellow-700' },
  completed: { label: 'Completed', color: 'bg-green-100 text-green-700' },
  cancelled: { label: 'Cancelled', color: 'bg-gray-100 text-gray-500' },
  pending: { label: 'Pending', color: 'bg-orange-100 text-orange-700' },
  processing: { label: 'Processing', color: 'bg-blue-100 text-blue-700' },
  synced: { label: 'Synced', color: 'bg-green-100 text-green-700' },
  failed: { label: 'Failed', color: 'bg-red-100 text-red-700' },
}

export default function StatusBadge({ status }) {
  const config = statusConfig[status] || { label: status, color: 'bg-gray-100 text-gray-600' }

  return (
    <span className={`inline-block px-2.5 py-1 rounded-full text-xs font-medium ${config.color}`}>
      {config.label}
    </span>
  )
}
