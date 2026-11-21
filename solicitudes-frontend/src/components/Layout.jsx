import { NavLink, useNavigate } from 'react-router-dom'
import api, { usuarioActual, borrarSesion } from '../api'
import Notificaciones from './Notificaciones.jsx'

const menus = {
  estudiante: [
    ['/estudiante/solicitudes', 'Mis solicitudes'],
    ['/estudiante/historial', 'Historial'],
    ['/estudiante/pendientes', 'Plan de estudios'],
    ['/estudiante/actividades', 'Actividades'],
    ['/estudiante/datos', 'Mis datos'],
  ],
  docente: [
    ['/docente/solicitudes', 'Solicitudes'],
    ['/docente/estudiantes', 'Estudiantes'],
    ['/docente/reportes', 'Reportes'],
  ],
}

export default function Layout({ children }) {
  const navigate = useNavigate()
  const usuario = usuarioActual()

  async function cerrarSesion() {
    try {
      await api.post('/logout')
    } catch {
    }
    borrarSesion()
    navigate('/login')
  }

  return (
    <div>
      <header className="barra">
        <div className="marca">
          Mi Campus
          <span>{usuario.role === 'docente' ? 'Docente' : 'Estudiante'}</span>
        </div>
        <nav>
          {menus[usuario.role].map(([ruta, texto]) => (
            <NavLink key={ruta} to={ruta}>{texto}</NavLink>
          ))}
        </nav>
        <div className="usuario">
          {usuario.role === 'estudiante' && <Notificaciones userId={usuario.id} />}
          <span>{usuario.name}</span>
          <button className="boton-claro" onClick={cerrarSesion}>Cerrar sesión</button>
        </div>
      </header>
      <main className="contenido">{children}</main>
    </div>
  )
}
