import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { usuarioActual } from './api'
import Layout from './components/Layout.jsx'
import Login from './pages/Login.jsx'
import MisDatos from './pages/estudiante/MisDatos.jsx'
import Historial from './pages/estudiante/Historial.jsx'
import Pendientes from './pages/estudiante/Pendientes.jsx'
import Actividades from './pages/estudiante/Actividades.jsx'
import MisSolicitudes from './pages/estudiante/MisSolicitudes.jsx'
import Solicitudes from './pages/docente/Solicitudes.jsx'
import Estudiantes from './pages/docente/Estudiantes.jsx'
import DetalleEstudiante from './pages/docente/DetalleEstudiante.jsx'
import Reportes from './pages/docente/Reportes.jsx'

function RutaPrivada({ rol, children }) {
  const usuario = usuarioActual()
  if (!usuario) return <Navigate to="/login" replace />
  if (usuario.role !== rol) return <Navigate to="/" replace />
  return <Layout>{children}</Layout>
}

function Inicio() {
  const usuario = usuarioActual()
  if (!usuario) return <Navigate to="/login" replace />
  return <Navigate to={usuario.role === 'docente' ? '/docente/solicitudes' : '/estudiante/solicitudes'} replace />
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/" element={<Inicio />} />

        <Route path="/estudiante/datos" element={<RutaPrivada rol="estudiante"><MisDatos /></RutaPrivada>} />
        <Route path="/estudiante/historial" element={<RutaPrivada rol="estudiante"><Historial /></RutaPrivada>} />
        <Route path="/estudiante/pendientes" element={<RutaPrivada rol="estudiante"><Pendientes /></RutaPrivada>} />
        <Route path="/estudiante/actividades" element={<RutaPrivada rol="estudiante"><Actividades /></RutaPrivada>} />
        <Route path="/estudiante/solicitudes" element={<RutaPrivada rol="estudiante"><MisSolicitudes /></RutaPrivada>} />

        <Route path="/docente/solicitudes" element={<RutaPrivada rol="docente"><Solicitudes /></RutaPrivada>} />
        <Route path="/docente/estudiantes" element={<RutaPrivada rol="docente"><Estudiantes /></RutaPrivada>} />
        <Route path="/docente/estudiantes/:id" element={<RutaPrivada rol="docente"><DetalleEstudiante /></RutaPrivada>} />
        <Route path="/docente/reportes" element={<RutaPrivada rol="docente"><Reportes /></RutaPrivada>} />

        <Route path="*" element={<Inicio />} />
      </Routes>
    </BrowserRouter>
  )
}
