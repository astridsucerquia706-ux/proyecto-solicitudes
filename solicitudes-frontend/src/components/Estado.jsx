const textos = {
  pendiente: 'Pendiente',
  aprobada: 'Aprobada',
  rechazada: 'Rechazada',
  en_curso: 'En curso',
  reprobada: 'Reprobada',
  cancelada: 'Cancelada',
  disponible: 'Disponible',
  bloqueada: 'Bloqueada',
}

export default function Estado({ valor }) {
  return <span className={`estado estado-${valor}`}>{textos[valor] || valor}</span>
}
