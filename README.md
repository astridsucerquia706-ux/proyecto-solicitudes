# Sistema de gestión y seguimiento de solicitudes estudiantiles

El estudiante consulta su historial, su plan de estudios y sus actividades, y solicita la cancelación de materias.
El docente revisa las solicitudes, las aprueba o rechaza con una observación, consulta la información de los estudiantes y genera reportes.

## Tecnologías

| Parte | Tecnología |
| --- | --- |
| Base de datos relacional | MySQL 8 (Laragon) |
| Base de datos NoSQL | Firebase Cloud Firestore (notificaciones) |
| Backend | PHP 8 · Laravel 9 |
| Frontend | React · Vite |

## Instalación

### 1. Requisitos
- Laragon con MySQL 8.
- Node.js 20 o superior.

### 2. Base de datos
Con Laragon encendido, crear en HeidiSQL una base de datos vacía llamada `solicitudes`.

### 3. Backend
En la terminal de Laragon, dentro de la carpeta `solicitudes`:

```
composer install
copy .env.example .env
php artisan key:generate
php artisan migrate:fresh --seed
php artisan serve
```

### 4. Frontend
En otra terminal, dentro de la carpeta `solicitudes-frontend`:

```
copy .env.example .env
npm install
npm run dev
```

Abrir http://localhost:5173

### 5. Firebase
1. Crear un proyecto en https://console.firebase.google.com y agregar una app **Web**.
2. Copiar sus datos de configuración en el archivo `solicitudes-frontend/.env`.
3. Crear la base de datos en **Firestore Database** y publicar las reglas de la colección `notifications`.
4. Reiniciar `npm run dev`.

## Usuarios de prueba

Contraseña para todos: `clave123`

| Rol | Correo |
| --- | --- |
| Docente | docente1@pascualbravo.test |
| Docente | docente2@pascualbravo.test |
| Estudiante | laura.gomez@pascualbravo.test |
| Estudiante | andres.rios@pascualbravo.test |
| Estudiante | valentina.torres@pascualbravo.test |
| Estudiante | santiago.herrera@pascualbravo.test |
| Estudiante | camila.ospina@pascualbravo.test |

## Copia de seguridad

Desde la carpeta `solicitudes`, en la terminal de Laragon:

```
mkdir backups
mysqldump -u root --routines --triggers --result-file=backups\backup_solicitudes.sql solicitudes
```

Para restaurar:

```
mysql -u root solicitudes < backups\backup_solicitudes.sql
```