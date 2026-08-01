import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { api } from '../api/client.js'
import { useApp } from '../store.jsx'

export default function Register() {
  const [form, setForm] = useState({ name: '', email: '', password: '', phone: '', address: '' })
  const [error, setError] = useState('')
  const [busy, setBusy] = useState(false)
  const { signIn } = useApp()
  const navigate = useNavigate()

  const set = (k) => (e) => setForm({ ...form, [k]: e.target.value })

  async function handleSubmit(e) {
    e.preventDefault()
    setError('')
    setBusy(true)
    try {
      const res = await api.register(form)
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
          <h1 className="h1">Create your account</h1>
          <p className="sub">Takes less than a minute.</p>

          {error && <div className="error">{error}</div>}

          <form onSubmit={handleSubmit}>
            <div className="field">
              <label>Full name</label>
              <input value={form.name} onChange={set('name')} required minLength={2} />
            </div>
            <div className="field">
              <label>Email address</label>
              <input type="email" value={form.email} onChange={set('email')} required />
            </div>
            <div className="field">
              <label>Password (min 6 characters)</label>
              <input type="password" value={form.password} onChange={set('password')} required minLength={6} />
            </div>
            <div className="field">
              <label>Phone number</label>
              <input value={form.phone} onChange={set('phone')} />
            </div>
            <div className="field">
              <label>Delivery address</label>
              <textarea rows={2} value={form.address} onChange={set('address')} />
            </div>
            <button className="btn btn-block" disabled={busy}>
              {busy ? 'Creating account…' : 'Create account'}
            </button>
          </form>

          <p style={{ marginTop: 18, fontSize: 14, color: 'var(--muted)' }}>
            Already have an account? <Link to="/login" style={{ color: 'var(--brand)', fontWeight: 600 }}>Sign in</Link>
          </p>
        </div>
      </div>
    </div>
  )
}
