import { useEffect, useState } from 'react'
import api, { mensajeError } from '../../api'

const vacio = { activity_type_id: '', name: '', date: '', description: '' }

export default function Actividades() {
  const [actividades, setActividades] = useState([])
  const [tipos, setTipos] = useState([])
  const [form, setForm] = useState(vacio)
  const [mensaje, setMensaje] = useState('')
  const [error, setError] = useState('')

  async function cargar() {
    try {
      const [a, t] = await Promise.all([api.get('/student/activities'), api.get('/student/activity-types')])
      setActividades(a.data.datos)
      setTipos(t.data.datos)
    } catch (err) {
      setError(mensajeError(err))
    }
  }

  useEffect(() => { cargar() }, [])

  const cambiar = (campo) => (e) => setForm({ ...form, [campo]: e.target.value })

  async function guardar(e) {
    e.preventDefault()
    setError('')
    setMensaje('')
    try {
      const { data } = await api.post('/student/activities', form)
      setMensaje(data.mensaje)
      setForm(vacio)
      cargar()
    } catch (err) {
      setError(mensajeError(err))
    }
  }

  async function eliminar(actividad) {
    if (!window.confirm(`¿Eliminar la actividad "${actividad.name}"?`)) return
    try {
      await api.delete(`/student/activities/${actividad.id}`)
      cargar()
    } catch (err) {
      setError(mensajeError(err))
    }
  }

  return (
    <div>
      <h2>Mis actividades</h2>

      <form className="tarjeta" onSubmit={guardar}>
        <h3>Registrar actividad</h3>
        <div className="fila">
          <div>
            <label>Tipo</label>
            <select value={form.activity_type_id} onChange={cambiar('activity_type_id')}>
              <option value="">Seleccione</option>
              {tipos.map((t) => <option key={t.id} value={t.id}>{t.name}</option>)}
            </select>
          </div>
          <div>
            <label>Fecha</label>
            <input type="date" value={form.date} onChange={cambiar('date')} />
          </div>
        </div>
        <label>Nombre</label>
        <input value={form.name} onChange={cambiar('name')} maxLength="150" />
        <label>Descripción (opcional)</label>
        <input value={form.description} onChange={cambiar('description')} maxLength="255" />

        {error && <p className="error">{error}</p>}
        {mensaje && <p className="exito">{mensaje}</p>}
        <button className="boton">Guardar</button>
      </form>

      <div className="tarjeta">
        <table>
          <thead><tr><th>Fecha</th><th>Tipo</th><th>Actividad</th><th>Descripción</th><th></th></tr></thead>
          <tbody>
            {actividades.map((a) => (
              <tr key={a.id}>
                <td className="nowrap">{a.date}</td>
                <td>{a.type.name}</td>
                <td>{a.name}</td>
                <td>{a.description || '—'}</td>
                <td><button className="boton-peligro" onClick={() => eliminar(a)}>Eliminar</button></td>
              </tr>
            ))}
            {actividades.length === 0 && <tr><td colSpan="5" className="vacio">Aún no ha registrado actividades.</td></tr>}
          </tbody>
        </table>
      </div>
    </div>
  )
}
