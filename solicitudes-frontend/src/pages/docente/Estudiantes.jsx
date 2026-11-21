import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import api, { mensajeError } from '../../api'

export default function Estudiantes() {
  const [estudiantes, setEstudiantes] = useState([])
  const [q, setQ] = useState('')
  const [error, setError] = useState('')

  async function cargar(texto = '') {
    try {
      const { data } = await api.get('/teacher/students', { params: { q: texto } })
      setEstudiantes(data.datos)
    } catch (err) {
      setError(mensajeError(err))
    }
  }

  useEffect(() => { cargar() }, [])

  function buscar(e) {
    e.preventDefault()
    cargar(q)
  }

  return (
    <div>
      <h2>Estudiantes</h2>
      <form className="tarjeta filtros" onSubmit={buscar}>
        <div>
          <label>Buscar por nombre o documento</label>
          <input value={q} onChange={(e) => setQ(e.target.value)} />
        </div>
        <button className="boton">Buscar</button>
      </form>
      {error && <p className="error">{error}</p>}

      <div className="tarjeta">
        <table>
          <thead><tr><th>Documento</th><th>Nombre</th><th>Programa</th><th>Correo</th><th></th></tr></thead>
          <tbody>
            {estudiantes.map((e) => (
              <tr key={e.id}>
                <td>{e.document}</td>
                <td>{e.user.name}</td>
                <td>{e.program.name}</td>
                <td>{e.user.email}</td>
                <td><Link className="boton-claro" to={`/docente/estudiantes/${e.id}`}>Ver información</Link></td>
              </tr>
            ))}
            {estudiantes.length === 0 && <tr><td colSpan="5" className="vacio">No se encontraron estudiantes.</td></tr>}
          </tbody>
        </table>
      </div>
    </div>
  )
}
