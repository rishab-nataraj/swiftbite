import { useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { api } from '../api/client.js'
import { useApp } from '../store.jsx'

export default function RestaurantMenu() {
  const { id } = useParams()
  const [restaurant, setRestaurant] = useState(null)
  const [error, setError] = useState('')
  const [added, setAdded] = useState('')
  const { addToCart, itemCount } = useApp()

  useEffect(() => {
    api.getRestaurant(id).then(setRestaurant).catch((e) => setError(e.message))
  }, [id])

  function handleAdd(item) {
    addToCart(restaurant, item)
    setAdded(item.name)
    setTimeout(() => setAdded(''), 1600)
  }

  if (error) return <div className="container page"><div className="error">{error}</div></div>
  if (!restaurant) return <div className="container page"><p className="sub">Loading menu…</p></div>

  // Group menu items by category so the page reads like a real menu
  const grouped = restaurant.menu_items.reduce((acc, item) => {
    (acc[item.category] ||= []).push(item)
    return acc
  }, {})

  return (
    <div className="container page">
      <Link to="/" style={{ fontSize: 14, color: 'var(--muted)' }}>← All restaurants</Link>

      <div className="panel" style={{ marginTop: 16, marginBottom: 24 }}>
        <div className="spread">
          <div>
            <h1 className="h1">{restaurant.name}</h1>
            <p className="sub" style={{ marginBottom: 8 }}>{restaurant.description}</p>
            <div className="card-meta">
              <span className="rating">★ {restaurant.rating.toFixed(1)}</span>
              <span>·</span><span>{restaurant.cuisine}</span>
              <span>·</span><span>{restaurant.eta_minutes} min delivery</span>
              <span>·</span><span>₹{restaurant.delivery_fee} fee</span>
            </div>
          </div>
          {itemCount > 0 && (
            <Link to="/cart" className="btn" style={{ display: 'inline-block' }}>
              View cart ({itemCount})
            </Link>
          )}
        </div>
      </div>

      {added && <div className="notice">Added <b>{added}</b> to your cart.</div>}

      {Object.entries(grouped).map(([category, items]) => (
        <div className="panel" key={category} style={{ marginBottom: 20 }}>
          <h2 className="h2">{category}</h2>
          {items.map((item) => (
            <div className="menu-item" key={item.id}>
              <div>
                <div className="item-name">
                  <span className={`veg-dot ${item.is_veg ? '' : 'nonveg'}`} />
                  {item.name}
                </div>
                <p className="item-desc">{item.description}</p>
                <div className="item-price">₹{item.price.toFixed(0)}</div>
              </div>
              <button className="btn btn-ghost btn-sm" onClick={() => handleAdd(item)}
                      disabled={!item.is_available}>
                {item.is_available ? 'Add +' : 'Unavailable'}
              </button>
            </div>
          ))}
        </div>
      ))}
    </div>
  )
}
