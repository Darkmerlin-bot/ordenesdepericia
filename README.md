# 🔬 Sistema de Gestión de Pericias Forenses

Sistema robusto y seguro para la gestión de pericias forenses con autenticación de usuarios, asignaciones múltiples, tracking de respuestas y alertas automáticas de plazos.

## 🎯 Características Principales

### ✅ Seguridad Máxima
- **Row Level Security (RLS)** en todas las tablas
- **Autenticación robusta** con Supabase Auth
- **Auditoría completa** de todas las operaciones
- **Políticas de acceso** granulares por usuario
- **Validación de datos** con constraints SQL

### 📋 Gestión de Pericias
- Crear pericias con todos los datos requeridos
- Asignación múltiple de usuarios
- Selección de Fiscalías (7 turnos disponibles)
- Gestión de plazos con alertas automáticas
- Estados automáticos (Pendiente, En Proceso, Contestada)

### 🔔 Sistema de Alertas
- **Alertas visuales** para pericias sin responder
- **Notificaciones sonoras** 2 días antes del plazo
- **Notificaciones del navegador** (si están permitidas)
- **Resaltado especial** de tareas urgentes

### 👥 Gestión de Usuarios
- Vista personalizada por usuario
- Solo se muestran pericias asignadas
- Sistema de contestaciones con firma automática
- Historial completo de respuestas

### 📊 Dashboard y Estadísticas
- Estadísticas en tiempo real
- Vista de pericias asignadas
- Vista de todas las pericias
- Filtros y estados automáticos

---

## 🚀 Instalación y Configuración

### Paso 1: Crear Proyecto en Supabase

1. Ve a [https://supabase.com](https://supabase.com)
2. Crea una cuenta o inicia sesión
3. Haz clic en "New Project"
4. Completa los datos:
   - **Project Name**: `pericias-forenses`
   - **Database Password**: (guarda esta contraseña de forma segura)
   - **Region**: Selecciona la más cercana (South America - São Paulo)
   - **Pricing Plan**: Free (o el que prefieras)

### Paso 2: Configurar la Base de Datos

1. En tu proyecto de Supabase, ve a **SQL Editor** (menú lateral)
2. Copia el contenido completo del archivo `supabase-schema.sql`
3. Pégalo en el editor SQL
4. Haz clic en **Run** (o presiona Ctrl+Enter)
5. Verifica que se ejecute sin errores

### Paso 3: Crear Usuarios en Supabase Auth

#### Opción A: Crear usuarios manualmente (Recomendado para pruebas)

1. Ve a **Authentication** > **Users** en el panel de Supabase
2. Haz clic en **Add User** > **Create new user**
3. Completa:
   - **Email**: `usuario@fiscalia.gob.uy`
   - **Password**: (contraseña segura)
   - **Auto Confirm User**: ✅ (marca esta casilla)
4. Haz clic en **Create User**
5. Repite para cada usuario del equipo

#### Opción B: Permitir registro automático

1. Ve a **Authentication** > **Providers**
2. Asegúrate de que **Email** esté habilitado
3. En **Email Auth** configura:
   - **Enable Email Confirmations**: Desactivado (para entorno interno)
   - **Enable Email OTP**: Activado (opcional)

### Paso 4: Sincronizar usuarios con la tabla `usuarios`

Después de crear usuarios en Auth, debes agregarlos a la tabla `usuarios`:

1. Ve a **SQL Editor**
2. Ejecuta este comando para cada usuario:

```sql
-- Reemplaza con los IDs reales de tus usuarios
INSERT INTO usuarios (id, email, nombre_completo, activo)
VALUES 
  ('uuid-del-usuario-1', 'usuario1@fiscalia.gob.uy', 'Juan Pérez', true),
  ('uuid-del-usuario-2', 'usuario2@fiscalia.gob.uy', 'María González', true),
  ('uuid-del-usuario-3', 'usuario3@fiscalia.gob.uy', 'Carlos Rodríguez', true);
```

Para obtener los UUIDs de los usuarios:
```sql
SELECT id, email FROM auth.users;
```

### Paso 5: Configurar la Aplicación

1. Abre el archivo `index.html`
2. Busca las líneas 1050-1051 (aproximadamente):

```javascript
const SUPABASE_URL = 'TU_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'TU_SUPABASE_ANON_KEY';
```

3. Reemplaza con tus credenciales de Supabase:
   - Ve a **Project Settings** > **API** en Supabase
   - Copia **Project URL** → reemplaza `TU_SUPABASE_URL`
   - Copia **anon public** key → reemplaza `TU_SUPABASE_ANON_KEY`

**Ejemplo:**
```javascript
const SUPABASE_URL = 'https://xyzabcdefgh.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

---

## 📤 Deployment a GitHub Pages

### Opción 1: Desde la Interfaz de GitHub (Más Fácil)

1. **Crear Repositorio**
   - Ve a [github.com](https://github.com) e inicia sesión
   - Haz clic en el botón "+" arriba a la derecha → "New repository"
   - Nombre: `sistema-pericias-forenses`
   - Público o Privado (tu elección)
   - No inicialices con README (lo subiremos después)
   - Haz clic en "Create repository"

2. **Subir Archivo**
   - En la página del repositorio recién creado, haz clic en "uploading an existing file"
   - Arrastra el archivo `index.html` a la zona de carga
   - En "Commit changes" escribe: `Inicial: Sistema de Pericias Forenses`
   - Haz clic en "Commit changes"

3. **Activar GitHub Pages**
   - Ve a **Settings** (engranaje arriba)
   - En el menú lateral, haz clic en **Pages**
   - En "Source", selecciona `main` o `master`
   - En "Folder", selecciona `/ (root)`
   - Haz clic en **Save**
   - Espera 1-2 minutos y refresca la página
   - Verás el mensaje "Your site is published at `https://tu-usuario.github.io/sistema-pericias-forenses/`"

### Opción 2: Usando Git (Para usuarios avanzados)

```bash
# 1. Inicializar repositorio local
cd /ruta/a/tu/carpeta
git init
git add index.html
git commit -m "Inicial: Sistema de Pericias Forenses"

# 2. Conectar con GitHub
git remote add origin https://github.com/TU-USUARIO/sistema-pericias-forenses.git
git branch -M main
git push -u origin main

# 3. GitHub Pages se activará automáticamente
# o puedes hacerlo desde Settings > Pages como se indicó arriba
```

---

## 🔐 Seguridad y Mejores Prácticas

### ⚠️ IMPORTANTE: Protección de Credenciales

**NUNCA** subas tus credenciales reales de Supabase a un repositorio público. Si lo haces:

1. Ve a **Project Settings** > **API** en Supabase
2. Haz clic en "Regenerate" en el **anon key**
3. Actualiza tu aplicación con la nueva key
4. Considera hacer tu repositorio privado

### 🛡️ Características de Seguridad Implementadas

✅ **Row Level Security (RLS)**: Los usuarios solo ven sus propias pericias
✅ **Auditoría completa**: Todas las operaciones quedan registradas
✅ **Validación de datos**: Constraints SQL previenen datos inválidos
✅ **Autenticación robusta**: Sistema de Supabase Auth
✅ **Políticas de acceso**: Control granular por tabla y operación

### 📝 Recomendaciones Adicionales

1. **Backups Automáticos**: Supabase hace backups diarios automáticamente (plan Free: 7 días de retención)

2. **Monitoreo**: Revisa periódicamente los logs en Supabase:
   - **Logs** > **API Logs** para ver requests
   - **Logs** > **Auth Logs** para ver intentos de login

3. **Actualizaciones de Seguridad**:
   - Mantén las dependencias actualizadas
   - Revisa el audit log regularmente

4. **Contraseñas Fuertes**:
   - Mínimo 12 caracteres
   - Combinación de mayúsculas, minúsculas, números y símbolos

---

## 📱 Uso del Sistema

### Inicio de Sesión
1. Accede a la URL de tu aplicación
2. Ingresa tu email y contraseña
3. Haz clic en "Ingresar"

### Crear Nueva Pericia
1. Haz clic en la pestaña "➕ Nueva Pericia"
2. Completa todos los campos requeridos:
   - Fecha y hora
   - Número SGSP
   - Pericia solicitada
   - Fiscalía
   - Plazo
   - Número de Novedad
   - Selecciona usuarios asignados
3. Haz clic en "✅ Crear Pericia"

### Ver y Contestar Pericias
1. En "📥 Mis Pericias Asignadas" verás todas tus tareas
2. Las pericias **sin contestar** tienen borde naranja grueso
3. Las pericias **urgentes** (≤2 días) tienen fondo rojo
4. Haz clic en una pericia para ver detalles
5. Completa el formulario de contestación
6. Haz clic en "✅ Guardar Contestación"

### Sistema de Alertas
- **2 días antes del plazo**: Sonido + notificación del navegador
- **Resaltado especial**: Pericias urgentes en rojo
- **Badge "Sin Responder"**: En pericias pendientes de tu respuesta

---

## 🗂️ Estructura de la Base de Datos

### Tablas Principales

#### `usuarios`
- Almacena información de los usuarios del sistema
- Vinculada con `auth.users` de Supabase

#### `pericias`
- Registro principal de cada pericia
- Estados: `pendiente`, `en_proceso`, `contestada`
- Actualización automática de estado

#### `asignaciones`
- Relación muchos a muchos entre pericias y usuarios
- Permite asignar múltiples usuarios a una pericia

#### `contestaciones`
- Respuestas de los usuarios asignados
- Incluye firma automática del usuario

#### `audit_log`
- Registro completo de todas las operaciones
- Incluye datos anteriores y nuevos para auditoría

---

## 🛠️ Mantenimiento y Soporte

### Ver Logs de Auditoría

```sql
-- Ver últimas 50 operaciones
SELECT 
  al.*,
  u.email as usuario_email
FROM audit_log al
LEFT JOIN auth.users u ON al.usuario_id = u.id
ORDER BY al.created_at DESC
LIMIT 50;
```

### Ver Pericias Próximas a Vencer

```sql
SELECT 
  numero_sgsp,
  fiscalia,
  plazo,
  plazo - CURRENT_DATE as dias_restantes,
  estado
FROM pericias
WHERE plazo <= CURRENT_DATE + INTERVAL '3 days'
  AND estado != 'contestada'
ORDER BY plazo ASC;
```

### Estadísticas del Sistema

```sql
SELECT 
  COUNT(*) as total_pericias,
  COUNT(*) FILTER (WHERE estado = 'pendiente') as pendientes,
  COUNT(*) FILTER (WHERE estado = 'en_proceso') as en_proceso,
  COUNT(*) FILTER (WHERE estado = 'contestada') as contestadas,
  COUNT(*) FILTER (WHERE plazo <= CURRENT_DATE + INTERVAL '2 days' AND estado != 'contestada') as urgentes
FROM pericias;
```

---

## 📞 Solución de Problemas

### Error: "Invalid API key"
- **Causa**: Credenciales incorrectas en `index.html`
- **Solución**: Verifica que hayas copiado correctamente la URL y anon key de Supabase

### Error: "Row Level Security"
- **Causa**: Usuario no existe en tabla `usuarios`
- **Solución**: Ejecuta el INSERT para sincronizar el usuario de Auth con la tabla usuarios

### No aparecen mis pericias
- **Causa**: No estás asignado a ninguna pericia
- **Solución**: Pide que te asignen a pericias o usa la vista "Todas las Pericias"

### Las notificaciones no funcionan
- **Causa**: Permisos de notificaciones bloqueados
- **Solución**: En tu navegador, permite notificaciones para el sitio (ícono de candado en la barra de direcciones)

---

## 🔄 Actualizaciones Futuras

Algunas ideas para mejorar el sistema:

- [ ] Exportación a Excel de pericias
- [ ] Filtros avanzados (por fiscalía, fecha, estado)
- [ ] Gráficos de estadísticas
- [ ] Envío de emails automáticos
- [ ] Historial de cambios por pericia
- [ ] App móvil nativa (React Native)
- [ ] Integración con calendario
- [ ] Recordatorios programables

---

## 📄 Licencia

Sistema desarrollado para uso interno de Fiscalía.

**Desarrollado con:**
- React 18
- Supabase
- HTML5 / CSS3
- JavaScript ES6+

---

## 💡 Notas Importantes

1. **Supabase Free Tier** incluye:
   - 500 MB de espacio en base de datos
   - 2 GB de almacenamiento de archivos
   - 50,000 usuarios activos mensuales
   - 1 GB de transferencia de datos
   - Más que suficiente para la mayoría de equipos

2. **GitHub Pages** es completamente gratuito para repositorios públicos y privados

3. **Backups**: Supabase hace backups automáticos, pero considera exportar datos importantes periódicamente

4. **Performance**: El sistema se actualiza cada 30 segundos automáticamente

---

## ✅ Checklist de Instalación

- [ ] Proyecto creado en Supabase
- [ ] Schema SQL ejecutado sin errores
- [ ] Usuarios creados en Authentication
- [ ] Usuarios sincronizados en tabla `usuarios`
- [ ] Credenciales actualizadas en `index.html`
- [ ] Repositorio creado en GitHub
- [ ] Archivo subido al repositorio
- [ ] GitHub Pages activado
- [ ] Sistema accesible desde la URL pública
- [ ] Login funcionando correctamente
- [ ] Creación de pericias funcionando
- [ ] Asignaciones funcionando
- [ ] Contestaciones funcionando
- [ ] Alertas funcionando

---

**¡Sistema listo para usar! 🎉**

Si tienes alguna pregunta o necesitas soporte adicional, no dudes en consultar.
