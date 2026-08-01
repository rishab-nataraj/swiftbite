import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { api } from '../api/client.js'
import { useApp } from '../store.jsx'

export default function Checkout() {
  const { cart, subtotal, clearCart, user } = useApp()
  const [address, setAddress] = useState(user?.address || '')
  const [payment, setPayment] = useState('COD')
  const [error, setError] = useState('')
  const [busy, setBusy] = useState(false)
  const navigate = useNavigate()

  const total = subtotal + cart.deliveryFee

  async function handlePlace(e) {
    e.preventDefault()
    setError('')
    setBusy(true)
    try {
      const order = await api.placeOrder({
        restaurant_id: cart.restaurantId,
        items: cart.lines.map((l) => ({ menu_item_id: l.id, quantity: l.qty })),
        delivery_address: address,
        payment_method: payment,
      })
      clearCart()
      navigate(`/orders/${order.id}`)
    } catch (err) {
      setError(err.message)
    } finally {
      setBusy(false)
    }
  }

  if (cart.lines.length === 0) {
    return (
      <div className="container page">
        <div className="empty">
          <div className="empty-icon">🛒</div>
          <p>Nothing to check out — your cart is empty.</p>
        </div>
      </div>
    )
  }

  return (
    <div className="container page">
      <h1 className="h1">Checkout</h1>
      <p className="sub">Confirm your address and payment method.</p>

      {error && <div className="error">{error}</div>}

      <div className="cart-layout">
        <form className="panel" onSubmit={handlePlace}>
          <h2 className="h2">Delivery details</h2>
          <div className="field">
            <label>Deliver to</label>
            <textarea rows={3} value={address} required
                      placeholder="House / flat, street, landmark, city, PIN"
                      onChange={(e) => setAddress(e.target.value)} />
          </div>
          <div className="field">
            <label>Contact number</label>
            <input value={user?.phone || ''} readOnly />
          </div>

          <h2 className="h2" style={{ marginTop: 24 }}>Payment method</h2>
          <div className="field">
            <select value={payment} onChange={(e) => setPayment(e.target.value)}>
              <option value="COD">Cash on delivery</option>
              <option value="UPI">UPI</option>
              <option value="CARD">Credit / debit card</option>
              <option value="WALLET">SwiftBite wallet</option>
            </select>
          </div>

          <button className="btn btn-block" disabled={busy}>
            {busy ? 'Placing order…' : `Place order · ₹${total.toFixed(0)}`}
          </button>
        </form>

        <div className="panel">
          <h2 className="h2">Order summary</h2>
          <p style={{ fontSize: 13, color: 'var(--muted)', marginBottom: 12 }}>{cart.restaurantName}</p>
          {cart.lines.map((l) => (
            <div className="summary-row" key={l.id}>
              <span>{l.qty} × {l.name}</span>
              <span>₹{(l.price * l.qty).toFixed(0)}</span>
            </div>
          ))}
          <div className="summary-row"><span>Delivery fee</span><span>₹{cart.deliveryFee.toFixed(0)}</span></div>
          <div className="summary-row total"><span>To pay</span><span>₹{total.toFixed(0)}</span></div>
        </div>
      </div>
    </div>
  )
}
