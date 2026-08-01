import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { api } from '../api/client.js'
import { useApp } from '../store.jsx'

export default function Login() {
  const [email, setEmail] = useState('demo@swiftbite.com')
  const [password, setPassword] = useState('demo1234')
  const [error, setError] = useState('')
  const [busy, setBusy] = useState(false)
  const { signIn } = useApp()
  const navigate = useNavigate()

  async function handleSubmit(e) {
    e.preventDefault()
    setError('')
    setBusy(true)
    try {
      const res = await api.login({ email, password })
      signIn(res.access_token, res.user)
      navigate('/')
    } catch (err) {
      setError(err.message)
    } finally {
      setBusy(false)
    }
  }

  return (
    <div className="container">
      <div className="auth-wrap">
        <div className="panel">
          <h1 className="h1">Welcome back</h1>
          <p className="sub">Sign in to order from your favourite restaurants.</p>

          {error && <div className="error">{error}</div>}

          <form onSubmit={handleSubmit}>
            <div className="field">
              <label htmlFor="email">Email address</label>
              <input id="email" type="email" value={email} required
                     onChange={(e) => setEmail(e.target.value)} />
            </div>
            <div className="field">
              <label htmlFor="password">Password</label>
              <input id="password" type="password" value={password} required
                     onChange={(e) => setPassword(e.target.value)} />
            </div>
            <button className="btn btn-block" disabled={busy}>
              {busy ? 'Signing in…' : 'Sign in'}
            </button>
          </form>

          <p style={{ marginTop: 18, fontSize: 14, color: 'var(--muted)' }}>
            New here? <Link to="/register" style={{ color: 'var(--brand)', fontWeight: 600 }}>Create an account</Link>
          </p>
          <p style={{ marginTop: 10, fontSize: 13, color: 'var(--muted)' }}>
            Demo login is pre-filled: <b>demo@swiftbite.com</b> / <b>demo1234</b>
          </p>
        </div>
      </div>
    </div>
  )
}
