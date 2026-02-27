export const ORDER_STATUSES = {
  pending: {
    label: 'Pendente',
    color: 'text-amber-700',
    bg: 'bg-amber-100',
    border: 'border-amber-300',
    icon: 'tabler:clock',
  },
  confirmed: {
    label: 'Confirmado',
    color: 'text-blue-700',
    bg: 'bg-blue-100',
    border: 'border-blue-300',
    icon: 'tabler:check',
  },
  preparing: {
    label: 'Preparando',
    color: 'text-yellow-700',
    bg: 'bg-yellow-100',
    border: 'border-yellow-300',
    icon: 'tabler:chef-hat',
  },
  ready: {
    label: 'Pronto',
    color: 'text-indigo-700',
    bg: 'bg-indigo-100',
    border: 'border-indigo-300',
    icon: 'tabler:package',
  },
  out_for_delivery: {
    label: 'Saiu p/ entrega',
    color: 'text-purple-700',
    bg: 'bg-purple-100',
    border: 'border-purple-300',
    icon: 'tabler:truck-delivery',
  },
  delivered: {
    label: 'Entregue',
    color: 'text-green-700',
    bg: 'bg-green-100',
    border: 'border-green-300',
    icon: 'tabler:circle-check',
  },
  cancelled: {
    label: 'Cancelado',
    color: 'text-red-700',
    bg: 'bg-red-100',
    border: 'border-red-300',
    icon: 'tabler:x',
  },
  rejected: {
    label: 'Rejeitado',
    color: 'text-red-700',
    bg: 'bg-red-100',
    border: 'border-red-300',
    icon: 'tabler:ban',
  },
}

export const STATUS_TABS = [
  { key: 'all', label: 'Todos', icon: 'tabler:list' },
  { key: 'pending', label: 'Pendentes', icon: 'tabler:clock' },
  { key: 'confirmed', label: 'Confirmados', icon: 'tabler:check' },
  { key: 'preparing', label: 'Preparando', icon: 'tabler:chef-hat' },
  { key: 'ready', label: 'Prontos', icon: 'tabler:package' },
  { key: 'out_for_delivery', label: 'Em entrega', icon: 'tabler:truck-delivery' },
  { key: 'delivered', label: 'Entregues', icon: 'tabler:circle-check' },
]

export const NEXT_STATUS = {
  confirmed: 'preparing',
  preparing: 'ready',
  ready: 'out_for_delivery',
  out_for_delivery: 'delivered',
}

export const NEXT_STATUS_LABEL = {
  confirmed: 'Iniciar preparo',
  preparing: 'Marcar como pronto',
  ready: 'Saiu para entrega',
  out_for_delivery: 'Marcar como entregue',
}

export function getStatusConfig(status) {
  return ORDER_STATUSES[status] || ORDER_STATUSES.pending
}

export const PAYMENT_METHODS = {
  pix: 'Pix',
  cash: 'Dinheiro',
}
