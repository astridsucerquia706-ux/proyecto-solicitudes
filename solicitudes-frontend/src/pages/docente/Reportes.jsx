import { useEffect, useState } from 'react'
import api, { mensajeError, descargar } from '../../api'
import Estado from '../../components/Estado.jsx'

export default function Reportes() {
  const [periodos, setPeriodos] = useState([])
  const [periodo, setPeriodo] = useState('')
  const [solicitudes, setSolicitudes] = useState([])
  const [promedios, setPromedios] = useState([])
  const [actividades, setActividades] = useState([])
  const [error, setError] = useState('')

  useEffect(() => {
    api.get('/teacher/periods').then(({ data }) => setPeriodos(data.datos)).catch(() => {})
    api.get('/teacher/reports/averages').then(({ data }) => setPromedios(data.datos)).catch((err) => setError(mensajeError(err)))
    api.get('/teacher/reports/activities').then(({ data }) => setActividades(data.datos)).catch((err) => setError(mensajeError(err)))
  }, [])

  useEffect(() => {
    api.get('/teacher/reports/requests', { params: { period_id: periodo } })
      .then(({ data }) => setSolicitudes(data.datos))
      .catch((err) => setError(mensajeError(err)))
  }, [periodo])

  async function exportar(tipo) {
    try {
      const parametro = tipo === 'solicitudes' && periodo ? `?period_id=${periodo}` : ''
      await descargar(`/teacher/reports/export/${tipo}${parametro}`, `reporte_${tipo}.csv`)
    } catch (err) {
      setError('No se pudo descargar el archivo')
    }
  }

  return (
    <div>
      <h2>Reportes</h2>
      {error && <p className="error">{error}</p>}

      <div className="tarjeta">
        <div className="encabezado-tarjeta">
          <h3>Solicitudes por estado</h3>
          <button className="boton-claro" onClick={() => exportar('solicitudes')}>Exportar CSV</button>
        </div>
        <label>Periodo</label>
        <select value={periodo} onChange={(e) => setPeriodo(e.target.value)}>
          <option value="">Todos</option>
          {periodos.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
        </select>
        <table>
          <thead><tr><th>Periodo</th><th>Estado</th><th>Cantidad</th></tr></thead>
          <tbody>
            {solicitudes.map((s, i) => (
              <tr key={i}><td>{s.periodo}</td><td><Estado valor={s.estado} /></td><td>{s.cantidad}</td></tr>
            ))}
            {solicitudes.length === 0 && <tr><td colSpan="3" className="vacio">Sin datos.</td></tr>}
          </tbody>
        </table>
      </div>

      <div className="tarjeta">
        <div className="encabezado-tarjeta">
          <h3>Desempeño académico por programa</h3>
          <button className="boton-claro" onClick={() => exportar('promedios')}>Exportar CSV</button>
        </div>
        <table>
          <thead><tr><th>Programa</th><th>Estudiantes</th><th>Promedio</th></tr></thead>
          <tbody>
            {promedios.map((p, i) => (
              <tr key={i}><td>{p.programa}</td><td>{p.estudiantes}</td><td>{p.promedio ?? '—'}</td></tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="tarjeta">
        <div className="encabezado-tarjeta">
          <h3>Participación en actividades</h3>
          <button className="boton-claro" onClick={() => exportar('actividades')}>Exportar CSV</button>
        </div>
        <table>
          <thead><tr><th>Programa</th><th>Tipo de actividad</th><th>Cantidad</th></tr></thead>
          <tbody>
            {actividades.map((a, i) => (
              <tr key={i}><td>{a.programa}</td><td>{a.tipo}</td><td>{a.cantidad}</td></tr>
            ))}
            {actividades.length === 0 && <tr><td colSpan="3" className="vacio">Sin datos.</td></tr>}
          </tbody>
        </table>
      </div>
    </div>
  )
}
