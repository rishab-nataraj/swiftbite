// Global auth + cart state using React Context (no external state library needed).
import { createContext, useContext, useEffect, useMemo, useState } from 'react'

const AppContext = createContext(null)

export function AppProvider({ children }) {
  const [user, setUser] = useState(() => {
    const raw = localStorage.getItem('sb_user')
    return raw ? JSON.parse(raw) : null
  })
  const [cart, setCart] = useState(() => {
    const raw = localStorage.getItem('sb_cart')
    return raw ? JSON.parse(raw) : { restaurantId: null, restaurantName: '', deliveryFee: 0, lines: [] }
  })

  useEffect(() => localStorage.setItem('sb_cart', JSON.stringify(cart)), [cart])

  function signIn(token, userObj) {
    localStorage.setItem('sb_token', token)
    localStorage.setItem('sb_user', JSON.stringify(userObj))
    setUser(userObj)
  }

  function signOut() {
    localStorage.removeItem('sb_token')
    localStorage.removeItem('sb_user')
    setUser(null)
  }

  function addToCart(restaurant, item) {
    setCart((prev) => {
      // Switching restaurants clears the cart (single-restaurant orders only).
      const fresh =
        prev.restaurantId === restaurant.id
          ? prev
          : { restaurantId: restaurant.id, restaurantName: restaurant.name, deliveryFee: restaurant.delivery_fee, lines: [] }

      const existing = fresh.lines.find((l) => l.id === item.id)
      const lines = existing
        ? fresh.lines.map((l) => (l.id === item.id ? { ...l, qty: l.qty + 1 } : l))
        : [...fresh.lines, { id: item.id, name: item.name, price: item.price, qty: 1 }]

      return { ...fresh, lines }
    })
  }

  function changeQty(itemId, delta) {
    setCart((prev) => {
      const lines = prev.lines
        .map((l) => (l.id === itemId ? { ...l, qty: l.qty + delta } : l))
        .filter((l) => l.qty > 0)
      return lines.length ? { ...prev, lines } : emptyCart()
    })
  }

  function clearCart() { setCart(emptyCart()) }

  const subtotal = useMemo(
    () => cart.lines.reduce((s, l) => s + l.price * l.qty, 0),
    [cart.lines]
  )
  const itemCount = useMemo(() => cart.lines.reduce((s, l) => s + l.qty, 0), [cart.lines])

  return (
    <AppContext.Provider
      value={{ user, signIn, signOut, cart, addToCart, changeQty, clearCart, subtotal, itemCount }}
    >
      {children}
    </AppContext.Provider>
  )
}

function emptyCart() {
  return { restaurantId: null, restaurantName: '', deliveryFee: 0, lines: [] }
}

export const useApp = () => useContext(AppContext)
