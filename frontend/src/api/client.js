// Thin fetch wrapper. All calls go to /api/* which Vite proxies to FastAPI.
const BASE = '/api'

function authHeaders() {
  const token = localStorage.getItem('sb_token')
  return token ? { Authorization: `Bearer ${token}` } : {}
}

async function request(path, options = {}) {
  const res = await fetch(`${BASE}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...authHeaders(),
      ...(options.headers || {}),
    },
  })

  if (!res.ok) {
    let message = `Request failed (${res.status})`
    try {
      const body = await res.json()
      if (body.detail) message = typeof body.detail === 'string' ? body.detail : JSON.stringify(body.detail)
    } catch (_) { /* non-JSON error body */ }
    throw new Error(message)
  }
  return res.status === 204 ? null : res.json()
}

export const api = {
  register: (data) => request('/auth/register', { method: 'POST', body: JSON.stringify(data) }),
  login: (data) => request('/auth/login', { method: 'POST', body: JSON.stringify(data) }),
  me: () => request('/auth/me'),

  listRestaurants: (search = '', cuisine = '') => {
    const p = new URLSearchParams()
    if (search) p.set('search', search)
    if (cuisine) p.set('cuisine', cuisine)
    const qs = p.toString()
    return request(`/restaurants${qs ? `?${qs}` : ''}`)
  },
  listCuisines: () => request('/restaurants/cuisines'),
  getRestaurant: (id) => request(`/restaurants/${id}`),

  placeOrder: (data) => request('/orders', { method: 'POST', body: JSON.stringify(data) }),
  myOrders: () => request('/orders'),
  getOrder: (id) => request(`/orders/${id}`),
  updateOrderStatus: (id, status) =>
    request(`/orders/${id}/status`, { method: 'PATCH', body: JSON.stringify({ status }) }),
  cancelOrder: (id) => request(`/orders/${id}/cancel`, { method: 'POST' }),
}
