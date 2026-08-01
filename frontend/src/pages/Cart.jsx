import { Link, useNavigate } from 'react-router-dom'
import { useApp } from '../store.jsx'

export default function Cart() {
  const { cart, changeQty, clearCart, subtotal, user } = useApp()
  const navigate = useNavigate()

  if (cart.lines.length === 0) {
    return (
      <div className="container page">
        <div className="empty">
          <div className="empty-icon">🛒</div>
          <h2 className="h2">Your cart is empty</h2>
          <p style={{ marginBottom: 20 }}>Browse restaurants and add something delicious.</p>
          <Link to="/" className="btn" style={{ display: 'inline-block' }}>Browse restaurants</Link>
        </div>
      </div>
    )
  }

  const total = subtotal + cart.deliveryFee

  return (
    <div className="container page">
      <h1 className="h1">Your cart</h1>
      <p className="sub">From <b>{cart.restaurantName}</b></p>

      <div className="cart-layout">
        <div className="panel">
          {cart.lines.map((line) => (
            <div className="menu-item" key={line.id}>
              <div>
                <div className="item-name">{line.name}</div>
                <div className="item-price">₹{line.price.toFixed(0)} each</div>
              </div>
              <div className="row">
                <div className="qty">
                  <button onClick={() => changeQty(line.id, -1)} aria-label="Decrease">−</button>
                  <span style={{ minWidth: 18, textAlign: 'center', fontWeight: 600 }}>{line.qty}</span>
                  <button onClick={() => changeQty(line.id, +1)} aria-label="Increase">+</button>
                </div>
                <div style={{ minWidth: 70, textAlign: 'right', fontWeight: 700 }}>
                  ₹{(line.price * line.qty).toFixed(0)}
                </div>
              </div>
            </div>
          ))}
          <button className="btn btn-ghost btn-sm" style={{ marginTop: 16 }} onClick={clearCart}>
            Clear cart
          </button>
        </div>

        <div className="panel">
          <h2 className="h2">Bill summary</h2>
          <div className="summary-row"><span>Item total</span><span>₹{subtotal.toFixed(0)}</span></div>
          <div className="summary-row"><span>Delivery fee</span><span>₹{cart.deliveryFee.toFixed(0)}</span></div>
          <div className="summary-row total"><span>To pay</span><span>₹{total.toFixed(0)}</span></div>
          <button className="btn btn-block" style={{ marginTop: 18 }}
                  onClick={() => navigate(user ? '/checkout' : '/login')}>
            {user ? 'Proceed to checkout' : 'Sign in to checkout'}
          </button>
        </div>
      </div>
    </div>
  )
}
