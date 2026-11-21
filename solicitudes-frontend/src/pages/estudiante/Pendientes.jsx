import { useEffect, useState } from 'react'
import api, { mensajeError } from '../../api'
import Estado from '../../components/Estado.jsx'

export default function Pendientes() {
  const [materias, setMaterias] = useState([])
  const [error, setError] = useState('')

  useEffect(() => {
    api.get('/student/pending-subjects')
      .then(({ data }) => setMaterias(data.datos))
      .catch((err) => setError(mensajeError(err)))
  }, [])

  const contar = (situacion) => materias.filter((m) => m.situacion === situacion).length
  const creditosAprobados = materias
    .filter((m) => m.situacion === 'aprobada')
    .reduce((suma, m) => suma + m.credits, 0)
  const creditosTotales = materias.reduce((suma, m) => suma + m.credits, 0)

  const porSemestre = materias.reduce((grupos, m) => {
    (grupos[m.semester] = grupos[m.semester] || []).push(m)
    return grupos
  }, {})

  return (
    <div>
      <h2>Plan de estudios</h2>
      {error && <p className="error">{error}</p>}

      <div className="resumen">
        <div className="dato-grande"><span>Créditos aprobados</span><strong>{creditosAprobados} / {creditosTotales}</strong></div>
        <div className="dato-grande"><span>Aprobadas</span><strong>{contar('aprobada')}</strong></div>
        <div className="dato-grande"><span>En curso</span><strong>{contar('en_curso')}</strong></div>
        <div className="dato-grande"><span>Disponibles</span><strong>{contar('disponible')}</strong></div>
        <div className="dato-grande"><span>Bloqueadas</span><strong>{contar('bloqueada')}</strong></div>
      </div>

      {Object.keys(porSemestre).map((semestre) => (
        <div className="tarjeta" key={semestre}>
          <h3>Semestre {semestre}</h3>
          <table className="tabla-plan">
            <thead>
              <tr><th>Código</th><th>Asignatura</th><th>Créditos</th><th>Prerrequisitos</th><th>Nota</th><th>Situación</th></tr>
            </thead>
            <tbody>
              {porSemestre[semestre].map((m) => (
                <tr key={m.id}>
                  <td>{m.code}</td>
                  <td>{m.name}</td>
                  <td>{m.credits}</td>
                  <td>
                    {m.prerrequisitos.map((p) => <div key={p.code}>{p.name}</div>)}
                  </td>
                  <td>{m.nota ?? '—'}</td>
                  <td><Estado valor={m.situacion} /></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ))}
    </div>
  )
}
