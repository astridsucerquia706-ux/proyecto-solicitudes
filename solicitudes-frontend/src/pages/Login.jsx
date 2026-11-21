import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import api, { mensajeError, guardarSesion } from '../api'
import CampoClave from '../components/CampoClave.jsx'

export default function Login() {
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [cargando, setCargando] = useState(false)

  async function ingresar(e) {
    e.preventDefault()
    setError('')
    setCargando(true)
    try {
      const { data } = await api.post('/login', { email, password })
      guardarSesion(data.token, data.usuario)
      navigate('/')
    } catch (err) {
      setError(mensajeError(err))
    } finally {
      setCargando(false)
    }
  }

  return (
    <div className="pantalla-login">
      <form className="tarjeta login" onSubmit={ingresar}>
        <h1>Inicio de sesión</h1>

        <label>Correo</label>
        <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} />

        <label>Contraseña</label>
        <CampoClave value={password} onChange={(e) => setPassword(e.target.value)} />

        {error && <p className="error">{error}</p>}
        <button className="boton" disabled={cargando}>{cargando ? 'Ingresando…' : 'Ingresar'}</button>
      </form>
    </div>
  )
}
