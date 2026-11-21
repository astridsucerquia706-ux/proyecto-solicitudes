import { useEffect, useState } from 'react'
import api, { mensajeError } from '../../api'
import Estado from '../../components/Estado.jsx'

export default function Historial() {
  const [materias, setMaterias] = useState([])
  const [promedio, setPromedio] = useState(null)
  const [error, setError] = useState('')

  useEffect(() => {
    api.get('/student/history')
      .then(({ data }) => { setMaterias(data.datos); setPromedio(data.promedio) })
      .catch((err) => setError(mensajeError(err)))
  }, [])

  const periodos = []
  materias.forEach((m) => {
    let grupo = periodos.find((p) => p.nombre === m.period.name)
    if (!grupo) {
      grupo = { nombre: m.period.name, materias: [] }
      periodos.push(grupo)
    }
    grupo.materias.push(m)
  })

  function promedioPeriodo(lista) {
    const notas = lista.filter((m) => m.grade !== null && ['aprobada', 'reprobada'].includes(m.status))
    if (notas.length === 0) return null
    return (notas.reduce((suma, m) => suma + Number(m.grade), 0) / notas.length).toFixed(2)
  }

  return (
    <div>
      <h2>Historial académico</h2>
      {error && <p className="error">{error}</p>}

      <div className="resumen">
        <div className="dato-grande"><span>Promedio acumulado</span><strong>{promedio ?? '—'}</strong></div>
        <div className="dato-grande"><span>Periodos cursados</span><strong>{periodos.length}</strong></div>
        <div className="dato-grande"><span>Asignaturas aprobadas</span><strong>{materias.filter((m) => m.status === 'aprobada').length}</strong></div>
        <div className="dato-grande"><span>Asignaturas en curso</span><strong>{materias.filter((m) => m.status === 'en_curso').length}</strong></div>
      </div>

      {periodos.map((p) => {
        const prom = promedioPeriodo(p.materias)
        return (
          <div className="tarjeta" key={p.nombre}>
            <div className="encabezado-tarjeta">
              <h3>Periodo {p.nombre}</h3>
              <span className="ayuda">{prom ? `Promedio del periodo: ${prom}` : 'Periodo en curso'}</span>
            </div>
            <table className="tabla-plan">
              <thead>
                <tr><th>Código</th><th>Asignatura</th><th>Créditos</th><th>Semestre</th><th>Nota</th><th>Estado</th></tr>
              </thead>
              <tbody>
                {p.materias.map((m) => (
                  <tr key={m.id}>
                    <td>{m.subject.code}</td>
                    <td>{m.subject.name}</td>
                    <td>{m.subject.credits}</td>
                    <td>{m.subject.semester}</td>
                    <td>{m.grade ?? '—'}</td>
                    <td><Estado valor={m.status} /></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )
      })}
    </div>
  )
}
