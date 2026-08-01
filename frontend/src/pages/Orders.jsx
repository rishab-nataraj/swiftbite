import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { api } from '../api/client.js'

export default function Orders() {
  const [orders, setOrders] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.myOrders().then(setOrders).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return <div className="container page"><p className="sub">Loading orders…</p></div>

  if (orders.length === 0) {
    return (
      <div className="container page">
        <div className="empty">
          <div className="empty-icon">📦</div>
          <h2 className="h2">No orders yet</h2>
          <Link to="/" className="btn" style={{ display: 'inline-block', marginTop: 12 }}>
            Order something
          </Link>
        </div>
      </div>
    )
  }

  return (
    <div className="container page">
      <h1 className="h1">My orders</h1>
      <p className="sub">{orders.length} order{orders.length > 1 ? 's' : ''} so far.</p>

      {orders.map((o) => {
        const badge = o.status === 'DELIVERED' ? 'delivered' : o.status === 'CANCELLED' ? 'cancelled' : ''
        return (
          <Link to={`/orders/${o.id}`} key={o.id} className="panel" style={{ display: 'block', marginBottom: 14 }}>
            <div className="spread">
              <div>
                <div className="item-name">Order #{o.id}</div>
                <p style={{ fontSize: 13, color: 'var(--muted)', marginTop: 4 }}>
                  {o.items.length} item{o.items.length > 1 ? 's' : ''} · {new Date(o.placed_at).toLocaleString()}
                </p>
              </div>
              <div style={{ textAlign: 'right' }}>
                <span className={`badge ${badge}`}>{o.status.replace(/_/g, ' ')}</span>
                <div style={{ fontWeight: 800, marginTop: 8 }}>₹{o.total.toFixed(0)}</div>
              </div>
            </div>
          </Link>
        )
      })}
    </div>
  )
}
