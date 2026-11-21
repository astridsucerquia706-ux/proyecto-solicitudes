import axios from 'axios'

export const CLAVE_TOKEN = 'solicitudes_token'
export const CLAVE_USUARIO = 'solicitudes_usuario'

export function guardarSesion(token, usuario) {
  localStorage.setItem(CLAVE_TOKEN, token)
  localStorage.setItem(CLAVE_USUARIO, JSON.stringify(usuario))
}

export function borrarSesion() {
  localStorage.removeItem(CLAVE_TOKEN)
  localStorage.removeItem(CLAVE_USUARIO)
}

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api',
  headers: { Accept: 'application/json' },
})

api.interceptors.request.use((config) => {
  const token = localStorage.getItem(CLAVE_TOKEN)
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

api.interceptors.response.use(
  (respuesta) => respuesta,
  (error) => {
    if (error.response?.status === 401 && !error.config.url.includes('/login')) {
      borrarSesion()
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export function mensajeError(error) {
  return error.response?.data?.error || 'No se pudo conectar con el servidor'
}

export function usuarioActual() {
  try {
    const usuario = JSON.parse(localStorage.getItem(CLAVE_USUARIO))
    if (usuario && ['estudiante', 'docente'].includes(usuario.role) && localStorage.getItem(CLAVE_TOKEN)) {
      return usuario
    }
  } catch {
  }
  return null
}

export async function descargar(url, nombreArchivo) {
  const respuesta = await api.get(url, { responseType: 'blob' })
  const enlace = document.createElement('a')
  enlace.href = URL.createObjectURL(respuesta.data)
  enlace.download = nombreArchivo
  enlace.click()
  URL.revokeObjectURL(enlace.href)
}

export default api
