import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { api } from '../api/client.js'

const EMOJI = {
  'North Indian': '🍛', Italian: '🍕', Chinese: '🥡',
  American: '🍔', Healthy: '🥗', Japanese: '🍣',
}

export default function Restaurants() {
  const [restaurants, setRestaurants] = useState([])
  const [cuisines, setCuisines] = useState([])
  const [search, setSearch] = useState('')
  const [cuisine, setCuisine] = useState('')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => { api.listCuisines().then(setCuisines).catch(() => {}) }, [])

  useEffect(() => {
    setLoading(true)
    const t = setTimeout(() => {
      api.listRestaurants(search, cuisine)
        .then(setRestaurants)
        .catch((e) => setError(e.message))
        .finally(() => setLoading(false))
    }, 250) // debounce search typing
    return () => clearTimeout(t)
  }, [search, cuisine])

  return (
    <div className="container page">
      <h1 className="h1">Order food you love</h1>
      <p className="sub">Fresh from {restaurants.length || '—'} restaurants near you.</p>

      <input
        className="search"
        placeholder="Search restaurants…"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
      />

      <div className="chips">
        <button className={`chip ${cuisine === '' ? 'active' : ''}`} onClick={() => setCuisine('')}>
          All
        </button>
        {cuisines.map((c) => (
          <button key={c} className={`chip ${cuisine === c ? 'active' : ''}`} onClick={() => setCuisine(c)}>
            {EMOJI[c] || '🍽'} {c}
          </button>
        ))}
      </div>

      {error && <div className="error">{error}</div>}
      {loading && <p className="sub">Loading restaurants…</p>}

      {!loading && restaurants.length === 0 && (
        <div className="empty">
          <div className="empty-icon">🔍</div>
          <p>No restaurants match your search.</p>
        </div>
      )}

      <div className="grid">
        {restaurants.map((r) => (
          <Link key={r.id} to={`/restaurants/${r.id}`} className="card">
            <div className="card-thumb">{EMOJI[r.cuisine] || '🍽'}</div>
            <div className="card-body">
              <div className="card-title">{r.name}</div>
              <p style={{ fontSize: 13, color: 'var(--muted)', marginBottom: 10 }}>{r.description}</p>
              <div className="card-meta">
                <span className="rating">★ {r.rating.toFixed(1)}</span>
                <span>·</span>
                <span>{r.cuisine}</span>
                <span>·</span>
                <span>{r.eta_minutes} min</span>
                <span>·</span>
                <span>₹{r.delivery_fee} delivery</span>
              </div>
            </div>
          </Link>
        ))}
      </div>
    </div>
  )
}
