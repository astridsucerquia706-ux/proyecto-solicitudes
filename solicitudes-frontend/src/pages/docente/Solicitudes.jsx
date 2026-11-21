import { useEffect, useState } from 'react'
import api, { mensajeError } from '../../api'
import Estado from '../../components/Estado.jsx'
import { enviarNotificacion, firebaseActivo } from '../../firebase'

const acciones = { INSERT: 'Creada', UPDATE: 'Actualizada', DELETE: 'Eliminada' }

export default function Solicitudes() {
  const [solicitudes, setSolicitudes] = useState([])
  const [periodos, setPeriodos] = useState([])
  const [filtros, setFiltros] = useState({ status: 'pendiente', period_id: '', q: '' })
  const [detalle, setDetalle] = useState(null)
  const [observacion, setObservacion] = useState('')
  const [mensaje, setMensaje] = useState('')
  const [error, setError] = useState('')
  const [procesando, setProcesando] = useState(false)

  async function cargar(f = filtros) {
    try {
      const { data } = await api.get('/teacher/requests', { params: f })
      setSolicitudes(data.datos)
    } catch (err) {
      setError(mensajeError(err))
    }
  }

  useEffect(() => {
    cargar()
    api.get('/teacher/periods').then(({ data }) => setPeriodos(data.datos)).catch(() => {})
  }, [])

  function buscar(e) {
    e.preventDefault()
    cargar()
  }

  async function revisar(id) {
    setError('')
    setObservacion('')
    try {
      const { data } = await api.get(`/teacher/requests/${id}`)
      setDetalle(data)
    } catch (err) {
      setError(mensajeError(err))
    }
  }

  async function decidir(decision) {
    const s = detalle.dato
    const texto = decision === 'aprobada' ? 'APROBAR' : 'RECHAZAR'
    if (!window.confirm(`¿Seguro que desea ${texto} la solicitud de ${s.enrollment.student.user.name}?`)) return
    setError('')
    setMensaje('')
    setProcesando(true)
    let data
    try {
      ({ data } = await api.patch(`/teacher/requests/${s.id}/decide`, { decision, observation: observacion }))
    } catch (err) {
      setError(mensajeError(err))
      setProcesando(false)
      return
    }

    setDetalle(null)
    setProcesando(false)
    setMensaje(data.mensaje)
    setTimeout(() => setMensaje(''), 4000)
    cargar()

    if (firebaseActivo) {
      enviarNotificacion({
        userId: data.student_user_id,
        requestId: s.id,
        materia: s.enrollment.subject.name,
        estado: decision,
        observacion,
      }).catch((err) => console.error('Firebase:', err))
    }
  }

  const cambiar = (campo) => (e) => setFiltros({ ...filtros, [campo]: e.target.value })

  return (
    <div>
      <h2>Solicitudes de cancelación</h2>

      <form className="tarjeta filtros" onSubmit={buscar}>
        <div>
          <label>Estado</label>
          <select value={filtros.status} onChange={cambiar('status')}>
            <option value="">Todos</option>
            <option value="pendiente">Pendiente</option>
            <option value="aprobada">Aprobada</option>
            <option value="rechazada">Rechazada</option>
          </select>
        </div>
        <div>
          <label>Periodo</label>
          <select value={filtros.period_id} onChange={cambiar('period_id')}>
            <option value="">Todos</option>
            {periodos.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
          </select>
        </div>
        <div>
          <label>Estudiante (nombre o documento)</label>
          <input value={filtros.q} onChange={cambiar('q')} />
        </div>
        <button className="boton">Buscar</button>
      </form>

      {mensaje && <p className="exito">{mensaje}</p>}
      {error && <p className="error">{error}</p>}

      {detalle && (
        <div className="tarjeta destacada">
          <h3>Revisar solicitud #{detalle.dato.id}</h3>
          <div className="fila">
            <p><strong>Estudiante:</strong> {detalle.dato.enrollment.student.user.name} ({detalle.dato.enrollment.student.document})</p>
            <p><strong>Programa:</strong> {detalle.dato.enrollment.student.program.name}</p>
          </div>
          <div className="fila">
            <p><strong>Materia:</strong> {detalle.dato.enrollment.subject.code} – {detalle.dato.enrollment.subject.name}</p>
            <p><strong>Periodo:</strong> {detalle.dato.enrollment.period.name}</p>
          </div>
          <p><strong>Motivo:</strong> {detalle.dato.reason}</p>
          <p><strong>Estado:</strong> <Estado valor={detalle.dato.status} /></p>

          <h4>Historial de seguimiento</h4>
          <ul className="historial">
            {detalle.historial.map((h) => (
              <li key={h.id}>
                {h.created_at} · {acciones[h.action]} por {h.user ? h.user.name : 'el sistema'}
                {h.new_values?.status && <> · estado: <Estado valor={h.new_values.status} /></>}
              </li>
            ))}
          </ul>

          {detalle.dato.status === 'pendiente' ? (
            <>
              <label>Observación (obligatoria)</label>
              <textarea rows="3" maxLength="255" value={observacion} onChange={(e) => setObservacion(e.target.value)} />
              <div className="botones">
                <button className="boton" disabled={procesando} onClick={() => decidir('aprobada')}>{procesando ? 'Guardando…' : 'Aprobar'}</button>
                <button className="boton-peligro" disabled={procesando} onClick={() => decidir('rechazada')}>Rechazar</button>
                <button className="boton-claro" onClick={() => setDetalle(null)}>Cerrar</button>
              </div>
            </>
          ) : (
            <>
              <p><strong>Observación:</strong> {detalle.dato.observation}</p>
              <p><strong>Decidió:</strong> {detalle.dato.reviewer?.name} el {detalle.dato.decided_at}</p>
              <button className="boton-claro" onClick={() => setDetalle(null)}>Cerrar</button>
            </>
          )}
        </div>
      )}

      <div className="tarjeta">
        <table>
          <thead>
            <tr><th>Fecha</th><th>Estudiante</th><th>Programa</th><th>Materia</th><th>Periodo</th><th>Estado</th><th></th></tr>
          </thead>
          <tbody>
            {solicitudes.map((s) => (
              <tr key={s.id}>
                <td className="nowrap">{s.created_at}</td>
                <td>{s.enrollment.student.user.name}<br /><small>{s.enrollment.student.document}</small></td>
                <td>{s.enrollment.student.program.name}</td>
                <td>{s.enrollment.subject.name}</td>
                <td className="nowrap">{s.enrollment.period.name}</td>
                <td><Estado valor={s.status} /></td>
                <td><button className="boton-claro" onClick={() => revisar(s.id)}>{s.status === 'pendiente' ? 'Revisar' : 'Ver'}</button></td>
              </tr>
            ))}
            {solicitudes.length === 0 && <tr><td colSpan="7" className="vacio">No hay solicitudes con estos filtros.</td></tr>}
          </tbody>
        </table>
      </div>
    </div>
  )
}
