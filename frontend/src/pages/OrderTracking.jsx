import { useCallback, useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { api } from '../api/client.js'

const STAGES = [
  { key: 'PLACED', title: 'Order placed', sub: 'We have received your order' },
  { key: 'CONFIRMED', title: 'Order confirmed', sub: 'Restaurant accepted your order' },
  { key: 'PREPARING', title: 'Preparing your food', sub: 'The kitchen is on it' },
  { key: 'OUT_FOR_DELIVERY', title: 'Out for delivery', sub: 'Your rider is on the way' },
  { key: 'DELIVERED', title: 'Delivered', sub: 'Enjoy your meal!' },
]

export default function OrderTracking() {
  const { id } = useParams()
  const [order, setOrder] = useState(null)
  const [error, setError] = useState('')

  const load = useCallback(() => {
    api.getOrder(id).then(setOrder).catch((e) => setError(e.message))
  }, [id])

  useEffect(() => {
    load()
    const t = setInterval(load, 5000) // poll for live status updates
    return () => clearInterval(t)
  }, [load])

  async function advance() {
    const idx = STAGES.findIndex((s) => s.key === order.status)
    if (idx < 0 || idx >= STAGES.length - 1) return
    const updated = await api.updateOrderStatus(order.id, STAGES[idx + 1].key)
    setOrder(updated)
  }

  async function cancel() {
    try { setOrder(await api.cancelOrder(order.id)) } catch (e) { setError(e.message) }
  }

  if (error) return <div className="container page"><div className="error">{error}</div></div>
  if (!order) return <div className="container page"><p className="sub">Loading order…</p></div>

  const currentIdx = STAGES.findIndex((s) => s.key === order.status)
  const cancelled = order.status === 'CANCELLED'
  const badgeClass = cancelled ? 'cancelled' : order.status === 'DELIVERED' ? 'delivered' : ''

  return (
    <div className="container page">
      <Link to="/orders" style={{ fontSize: 14, color: 'var(--muted)' }}>← My orders</Link>

      <div className="spread" style={{ marginTop: 16, marginBottom: 6 }}>
        <h1 className="h1">Order #{order.id}</h1>
        <span className={`badge ${badgeClass}`}>{order.status.replace(/_/g, ' ')}</span>
      </div>
      <p className="sub">Placed on {new Date(order.placed_at).toLocaleString()}</p>

      <div className="cart-layout">
        <div className="panel">
          <h2 className="h2">Live status</h2>
          {cancelled ? (
            <p style={{ color: '#b91c1c' }}>This order was cancelled.</p>
          ) : (
            <ul className="track">
              {STAGES.map((s, i) => (
                <li key={s.key} className={i <= currentIdx ? 'done' : ''}>
                  <div className="dot">{i <= currentIdx ? '✓' : i + 1}</div>
                  <div>
                    <div className="track-title">{s.title}</div>
                    <div className="track-sub">{s.sub}</div>
                  </div>
                </li>
              ))}
            </ul>
          )}

          {!cancelled && order.status !== 'DELIVERED' && (
            <div className="row">
              <button className="btn btn-sm" onClick={advance}>Simulate next stage →</button>
              {['PLACED', 'CONFIRMED'].includes(order.status) && (
                <button className="btn btn-ghost btn-sm" onClick={cancel}>Cancel order</button>
              )}
            </div>
          )}
        </div>

        <div className="panel">
          <h2 className="h2">Bill</h2>
          {order.items.map((it) => (
            <div className="summary-row" key={it.id}>
              <span>{it.quantity} × {it.name_snapshot}</span>
              <span>₹{(it.unit_price * it.quantity).toFixed(0)}</span>
            </div>
          ))}
          <div className="summary-row"><span>Delivery fee</span><span>₹{order.delivery_fee.toFixed(0)}</span></div>
          <div className="summary-row total"><span>Total</span><span>₹{order.total.toFixed(0)}</span></div>
          <p style={{ fontSize: 13, color: 'var(--muted)', marginTop: 14 }}>
            <b>Paying by:</b> {order.payment_method}<br />
            <b>Deliver to:</b> {order.delivery_address}
          </p>
        </div>
      </div>
    </div>
  )
}
