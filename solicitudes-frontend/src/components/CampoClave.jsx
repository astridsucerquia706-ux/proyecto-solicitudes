import { useState } from 'react'

export default function CampoClave({ value, onChange }) {
  const [visible, setVisible] = useState(false)
  return (
    <div className="campo-clave">
      <input type={visible ? 'text' : 'password'} value={value} onChange={onChange} />
      <button type="button" className="enlace" onClick={() => setVisible(!visible)}>
        {visible ? 'Ocultar' : 'Mostrar'}
      </button>
    </div>
  )
}
