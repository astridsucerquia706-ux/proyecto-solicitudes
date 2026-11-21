import { useEffect, useState } from 'react'
import api, { mensajeError } from '../../api'
import Estado from '../../components/Estado.jsx'

export default function MisSolicitudes() {
  const [solicitudes, setSolicitudes] = useState([])
  const [materias, setMaterias] = useState([])
  const [enrollmentId, setEnrollmentId] = useState('')
  const [motivo, setMotivo] = useState('')
  const [mensaje, setMensaje] = useState('')
  const [error, setError] = useState('')

  async function cargar() {
    try {
      const [s, m] = await Promise.all([
        api.get('/student/requests'),
        api.get('/student/cancelable-enrollments'),
      ])
      setSolicitudes(s.data.datos)
      setMaterias(m.data.datos)
    } catch (err) {
      setError(mensajeError(err))
    }
  }

  useEffect(() => { cargar() }, [])

  async function enviar(e) {
    e.preventDefault()
    setError('')
    setMensaje('')
    const materia = materias.find((m) => String(m.id) === String(enrollmentId))
    if (materia && !window.confirm(`¿Seguro que desea solicitar la cancelación de ${materia.subject.name}?`)) return
    try {
      const { data } = await api.post('/student/requests', { enrollment_id: enrollmentId, reason: motivo })
      setMensaje(data.mensaje)
      setEnrollmentId('')
      setMotivo('')
      cargar()
    } catch (err) {
      setError(mensajeError(err))
    }
  }

  return (
    <div>
      <h2>Mis solicitudes de cancelación</h2>

      <form className="tarjeta" onSubmit={enviar}>
        <h3>Nueva solicitud</h3>
        <label>Materia en curso</label>
        <select value={enrollmentId} onChange={(e) => setEnrollmentId(e.target.value)}>
          <option value="">Seleccione una materia</option>
          {materias.map((m) => (
            <option key={m.id} value={m.id}>{m.subject.code} – {m.subject.name} ({m.period.name})</option>
          ))}
        </select>
        {materias.length === 0 && <p className="ayuda">No tiene materias en curso disponibles para cancelar.</p>}

        <label>Motivo</label>
        <textarea rows="3" maxLength="255" value={motivo} onChange={(e) => setMotivo(e.target.value)} />

        {error && <p className="error">{error}</p>}
        {mensaje && <p className="exito">{mensaje}</p>}
        <button className="boton">Enviar solicitud</button>
      </form>

      <div className="tarjeta">
        <h3>Seguimiento</h3>
        <table>
          <thead>
            <tr>
              <th>Fecha</th><th>Materia</th><th>Periodo</th><th>Motivo</th>
              <th>Estado</th><th>Observación del docente</th><th>Revisó</th>
            </tr>
          </thead>
          <tbody>
            {solicitudes.map((s) => (
              <tr key={s.id}>
                <td className="nowrap">{s.created_at}</td>
                <td>{s.enrollment.subject.name}</td>
                <td className="nowrap">{s.enrollment.period.name}</td>
                <td>{s.reason}</td>
                <td><Estado valor={s.status} /></td>
                <td>{s.observation || '—'}</td>
                <td>{s.reviewer ? `${s.reviewer.name} (${s.decided_at})` : '—'}</td>
              </tr>
            ))}
            {solicitudes.length === 0 && <tr><td colSpan="7" className="vacio">Aún no ha hecho solicitudes.</td></tr>}
          </tbody>
        </table>
      </div>
    </div>
  )
}
