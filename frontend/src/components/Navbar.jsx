import { Link, useNavigate } from 'react-router-dom'
import { useApp } from '../store.jsx'

export default function Navbar() {
  const { user, signOut, itemCount } = useApp()
  const navigate = useNavigate()

  function handleSignOut() {
    signOut()
    navigate('/')
  }

  return (
    <nav className="nav">
      <div className="container nav-inner">
        <Link to="/" className="logo">SwiftBite</Link>
        <div className="nav-links">
          <Link to="/">Restaurants</Link>
          {user && <Link to="/orders">My Orders</Link>}
          <Link to="/cart" className="cart-pill">Cart ({itemCount})</Link>
          {user ? (
            <>
              <span style={{ fontSize: 14, color: 'var(--muted)' }}>Hi, {user.name.split(' ')[0]}</span>
              <button className="btn btn-ghost btn-sm" onClick={handleSignOut}>Sign out</button>
            </>
          ) : (
            <Link to="/login" className="btn btn-sm" style={{ display: 'inline-block' }}>Sign in</Link>
          )}
        </div>
      </div>
    </nav>
  )
}
