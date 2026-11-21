import { initializeApp } from 'firebase/app'
import {
  getFirestore, collection, addDoc, query, where, onSnapshot,
  updateDoc, doc, serverTimestamp,
} from 'firebase/firestore'

const configuracion = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID,
}

export const firebaseActivo = Boolean(configuracion.apiKey && configuracion.projectId)

const db = firebaseActivo ? getFirestore(initializeApp(configuracion)) : null

export async function enviarNotificacion({ userId, requestId, materia, estado, observacion }) {
  if (!db) return false
  await addDoc(collection(db, 'notifications'), {
    user_id: userId,
    request_id: requestId,
    message: `Tu solicitud de cancelación de ${materia} fue ${estado}.`,
    observation: observacion,
    status: estado,
    read: false,
    created_at: serverTimestamp(),
  })
  return true
}

export function escucharNotificaciones(userId, alRecibir) {
  if (!db) return () => {}
  const consulta = query(collection(db, 'notifications'), where('user_id', '==', userId))
  return onSnapshot(consulta, (resultado) => {
    const lista = resultado.docs.map((d) => ({ id: d.id, ...d.data() }))
    lista.sort((a, b) => (b.created_at?.seconds || 0) - (a.created_at?.seconds || 0))
    alRecibir(lista)
  })
}

export async function marcarLeida(id) {
  if (!db) return
  await updateDoc(doc(db, 'notifications', id), { read: true })
}
