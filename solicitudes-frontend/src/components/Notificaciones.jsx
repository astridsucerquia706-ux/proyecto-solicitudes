import { useEffect, useState } from 'react'
import { escucharNotificaciones, marcarLeida, firebaseActivo } from '../firebase'

export default function Notificaciones({ userId }) {
  const [lista, setLista] = useState([])
  const [abierto, setAbierto] = useState(false)

  useEffect(() => escucharNotificaciones(userId, setLista), [userId])

  if (!firebaseActivo) return null

  const sinLeer = lista.filter((n) => !n.read).length

  return (
    <div className="campana">
      <button className="boton-claro" onClick={() => setAbierto(!abierto)}>
        Notificaciones {sinLeer > 0 && <span className="contador">{sinLeer}</span>}
      </button>
      {abierto && (
        <div className="panel-notificaciones">
          {lista.length === 0 && <p className="vacio">No tienes notificaciones.</p>}
          {lista.map((n) => (
            <div key={n.id} className={n.read ? 'notificacion' : 'notificacion nueva'}>
              <p>{n.message}</p>
              {n.observation && <small>Observación: {n.observation}</small>}
              {!n.read && (
                <button className="enlace" onClick={() => marcarLeida(n.id)}>Marcar como leída</button>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
