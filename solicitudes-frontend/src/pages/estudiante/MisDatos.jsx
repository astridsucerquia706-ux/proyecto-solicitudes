import { useEffect, useState } from 'react'
import api, { mensajeError } from '../../api'

const generos = ['Femenino', 'Masculino', 'No binario', 'Prefiero no decir']

export default function MisDatos() {
  const [estudiante, setEstudiante] = useState(null)
  const [form, setForm] = useState({})
  const [mensaje, setMensaje] = useState('')
  const [error, setError] = useState('')

  function llenar(dato) {
    setEstudiante(dato)
    setForm({
      phone: dato.phone || '',
      address: dato.address || '',
      birth_date: dato.birth_date || '',
      gender: dato.gender || '',
      stratum: dato.stratum || '',
      city: dato.city || '',
    })
  }

  useEffect(() => {
    api.get('/student/profile')
      .then(({ data }) => llenar(data.dato))
      .catch((err) => setError(mensajeError(err)))
  }, [])

  const cambiar = (campo) => (e) => setForm({ ...form, [campo]: e.target.value })

  async function guardar(e) {
    e.preventDefault()
    setError('')
    setMensaje('')
    try {
      const { data } = await api.put('/student/profile', form)
      llenar(data.dato)
      setMensaje(data.mensaje)
    } catch (err) {
      setError(mensajeError(err))
    }
  }

  if (!estudiante) return <p>{error || 'Cargando…'}</p>

  return (
    <div>
      <h2>Mis datos</h2>

      <div className="tarjeta">
        <h3>Información académica</h3>
        <div className="fila">
          <div><label>Nombre</label><input value={estudiante.user.name} disabled /></div>
          <div><label>Documento</label><input value={estudiante.document} disabled /></div>
        </div>
        <div className="fila">
          <div><label>Correo</label><input value={estudiante.user.email} disabled /></div>
          <div><label>Programa</label><input value={estudiante.program.name} disabled /></div>
        </div>
      </div>

      <form className="tarjeta" onSubmit={guardar}>
        <h3>Contacto y datos sociodemográficos</h3>
        <div className="fila">
          <div><label>Teléfono</label><input value={form.phone} onChange={cambiar('phone')} maxLength="20" /></div>
          <div><label>Ciudad</label><input value={form.city} onChange={cambiar('city')} maxLength="60" /></div>
        </div>
        <label>Dirección</label>
        <input value={form.address} onChange={cambiar('address')} maxLength="150" />
        <div className="fila">
          <div><label>Fecha de nacimiento</label><input type="date" value={form.birth_date} onChange={cambiar('birth_date')} /></div>
          <div>
            <label>Género</label>
            <select value={form.gender} onChange={cambiar('gender')}>
              <option value="">Sin especificar</option>
              {generos.map((g) => <option key={g} value={g}>{g}</option>)}
            </select>
          </div>
          <div>
            <label>Estrato</label>
            <select value={form.stratum} onChange={cambiar('stratum')}>
              <option value="">Sin especificar</option>
              {[1, 2, 3, 4, 5, 6].map((n) => <option key={n} value={n}>{n}</option>)}
            </select>
          </div>
        </div>

        {error && <p className="error">{error}</p>}
        {mensaje && <p className="exito">{mensaje}</p>}
        <button className="boton">Guardar cambios</button>
      </form>
    </div>
  )
}
