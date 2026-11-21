import { useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import api, { mensajeError } from '../../api'
import Estado from '../../components/Estado.jsx'

export default function DetalleEstudiante() {
  const { id } = useParams()
  const [info, setInfo] = useState(null)
  const [error, setError] = useState('')

  useEffect(() => {
    api.get(`/teacher/students/${id}`)
      .then(({ data }) => setInfo(data))
      .catch((err) => setError(mensajeError(err)))
  }, [id])

  if (!info) return <p>{error || 'Cargando…'}</p>
  const e = info.dato

  return (
    <div>
      <Link to="/docente/estudiantes">← Volver</Link>
      <h2>{e.user.name}</h2>

      <div className="resumen">
        <div className="dato-grande"><span>Programa</span><strong className="pequeno">{e.program.name}</strong></div>
        <div className="dato-grande"><span>Promedio</span><strong>{info.promedio ?? '—'}</strong></div>
        <div className="dato-grande"><span>Solicitudes</span><strong>{info.solicitudes.length}</strong></div>
      </div>

      <div className="tarjeta">
        <h3>Datos personales y sociodemográficos</h3>
        <div className="fila">
          <p><strong>Documento:</strong> {e.document}</p>
          <p><strong>Correo:</strong> {e.user.email}</p>
          <p><strong>Teléfono:</strong> {e.phone || '—'}</p>
        </div>
        <div className="fila">
          <p><strong>Ciudad:</strong> {e.city || '—'}</p>
          <p><strong>Estrato:</strong> {e.stratum || '—'}</p>
          <p><strong>Género:</strong> {e.gender || '—'}</p>
        </div>
      </div>

      <div className="tarjeta">
        <h3>Historial académico</h3>
        <table>
          <thead><tr><th>Periodo</th><th>Código</th><th>Materia</th><th>Nota</th><th>Estado</th></tr></thead>
          <tbody>
            {info.historial.map((m) => (
              <tr key={m.id}>
                <td className="nowrap">{m.period.name}</td><td>{m.subject.code}</td><td>{m.subject.name}</td>
                <td>{m.grade ?? '—'}</td><td><Estado valor={m.status} /></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="tarjeta">
        <h3>Solicitudes</h3>
        <table>
          <thead><tr><th>Fecha</th><th>Materia</th><th>Motivo</th><th>Estado</th><th>Observación</th></tr></thead>
          <tbody>
            {info.solicitudes.map((s) => (
              <tr key={s.id}>
                <td className="nowrap">{s.created_at}</td><td>{s.enrollment.subject.name}</td><td>{s.reason}</td>
                <td><Estado valor={s.status} /></td><td>{s.observation || '—'}</td>
              </tr>
            ))}
            {info.solicitudes.length === 0 && <tr><td colSpan="5" className="vacio">Sin solicitudes.</td></tr>}
          </tbody>
        </table>
      </div>

      <div className="tarjeta">
        <h3>Actividades</h3>
        <table>
          <thead><tr><th>Fecha</th><th>Tipo</th><th>Actividad</th></tr></thead>
          <tbody>
            {e.activities.map((a) => (
              <tr key={a.id}><td className="nowrap">{a.date}</td><td>{a.type.name}</td><td>{a.name}</td></tr>
            ))}
            {e.activities.length === 0 && <tr><td colSpan="3" className="vacio">Sin actividades registradas.</td></tr>}
          </tbody>
        </table>
      </div>
    </div>
  )
}
