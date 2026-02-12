# 🔐 Sistema con Roles: Administradores y Usuarios

## ✨ Novedades del Sistema

### 🎯 Sistema de Roles Implementado

El sistema ahora diferencia entre dos tipos de usuarios:

#### 👑 **ADMINISTRADORES**
- ✅ Ver todas las pericias del sistema
- ✅ Crear nuevas pericias
- ✅ Asignar pericias a usuarios
- ✅ Gestionar usuarios (editar nombres, cambiar roles, activar/desactivar)
- ✅ Ver estadísticas completas
- ✅ Contestar pericias asignadas

#### 👤 **USUARIOS**
- ✅ Ver solo sus pericias asignadas
- ✅ Contestar sus pericias
- ✅ Ver estadísticas personales
- ❌ No pueden crear pericias
- ❌ No pueden gestionar usuarios
- ❌ No ven pericias de otros

---

## 🚀 Configuración Inicial (Pasos Actualizados)

### 1️⃣ Ejecutar Schema SQL en Supabase (5 minutos)

1. **Accede a tu proyecto**: https://supabase.com/dashboard/project/dhpwdkysrjjsagtiqwmz

2. **Ejecuta el Schema**:
   - Ve a **SQL Editor** → **New Query**
   - Copia TODO el contenido del archivo **`supabase-schema.sql`** actualizado
   - Pégalo en el editor
   - Haz clic en **"Run"**
   - Debe aparecer "Success. No rows returned"

3. **Verifica las tablas**:
   - Ve a **Table Editor**
   - La tabla `usuarios` ahora tiene una columna `rol` (administrador o usuario)

---

### 2️⃣ Crear el Primer Administrador (IMPORTANTE)

#### A. Crear usuario en Authentication

1. Ve a **Authentication** → **Users**
2. Clic en **"Add User"** → **"Create new user"**
3. Completa:
   - **Email**: `admin@fiscalia.gob.uy` (o tu email)
   - **Password**: `Admin2025!` (o la que prefieras - segura)
   - ✅ **Auto Confirm User** (marca esta casilla)
4. Clic en **"Create User"**
5. **COPIA EL UUID** que aparece (ejemplo: `a1b2c3d4-e5f6-7890-abcd-ef1234567890`)

#### B. Registrar como administrador en la base de datos

1. Ve a **SQL Editor** → **New Query**
2. Ejecuta este comando (reemplaza con tu UUID real):

```sql
-- Reemplaza 'UUID-AQUI' con el UUID que copiaste
INSERT INTO usuarios (id, email, nombre_completo, rol, activo)
VALUES (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',  -- UUID del usuario
  'admin@fiscalia.gob.uy',                 -- Email
  'Administrador Principal',               -- Nombre completo
  'administrador',                         -- ROL (administrador o usuario)
  true                                     -- Activo
);
```

3. **Verifica que se creó correctamente**:

```sql
SELECT * FROM usuarios WHERE rol = 'administrador';
```

---

### 3️⃣ Crear Usuarios Normales

#### Opción A: Desde el Programa (Recomendado - MÁS FÁCIL) ✨

**¡AHORA PUEDES GESTIONAR USUARIOS DESDE EL PROGRAMA!**

1. **Inicia sesión** con tu cuenta de administrador
2. Ve a la pestaña **"👥 Gestión de Usuarios"**
3. Aquí puedes:
   - ✏️ **Editar nombres** de usuarios existentes
   - 👑 **Cambiar roles** (Usuario ↔ Administrador)
   - ✅/❌ **Activar/Desactivar** usuarios
4. Los cambios se aplican **inmediatamente**

#### Opción B: Manualmente en Supabase (Método tradicional)

1. **Crear en Authentication**:
   - Authentication → Users → Add User
   - Email: `usuario1@fiscalia.gob.uy`
   - Password: `Usuario2025!`
   - ✅ Auto Confirm User
   - Copiar UUID generado

2. **Registrar en tabla usuarios**:

```sql
-- Ejemplo con múltiples usuarios normales
INSERT INTO usuarios (id, email, nombre_completo, rol, activo)
VALUES 
  ('uuid-usuario-1', 'juan.perez@fiscalia.gob.uy', 'Juan Pérez', 'usuario', true),
  ('uuid-usuario-2', 'maria.gonzalez@fiscalia.gob.uy', 'María González', 'usuario', true),
  ('uuid-usuario-3', 'carlos.rodriguez@fiscalia.gob.uy', 'Carlos Rodríguez', 'usuario', true);
```

---

### 4️⃣ Subir a GitHub Pages

El proceso es el mismo que antes:

1. **Crear repositorio** en GitHub: `sistema-pericias-forenses`
2. **Subir `index.html`** (arrastrarlo a la interfaz web)
3. **Activar GitHub Pages**: Settings → Pages → Source: main → Save
4. **Acceder**: `https://TU-USUARIO.github.io/sistema-pericias-forenses/`

---

## 🎯 Uso del Sistema según Rol

### 👑 Como Administrador

#### Panel de Control Completo

Al iniciar sesión verás **4 pestañas**:

1. **📥 Mis Pericias Asignadas**: Tus tareas pendientes
2. **📊 Todas las Pericias**: Vista completa del sistema
3. **➕ Nueva Pericia**: Crear y asignar pericias
4. **👥 Gestión de Usuarios**: Administrar el equipo

#### Gestión de Usuarios (Nueva Funcionalidad)

En la pestaña **"👥 Gestión de Usuarios"** puedes:

1. **Ver todos los usuarios** del sistema en una tabla
2. **Editar nombres**: 
   - Haz clic en "✏️ Editar"
   - Cambia el nombre completo
   - Guarda los cambios
3. **Cambiar roles**:
   - Convierte usuarios en administradores
   - O viceversa (excepto tu propio rol)
4. **Activar/Desactivar usuarios**:
   - Deshabilita usuarios que ya no están en el equipo
   - No puedes desactivarte a ti mismo

#### Crear Pericias

1. Ve a **"➕ Nueva Pericia"**
2. Completa todos los campos
3. **Selecciona usuarios** para asignar (puedes seleccionar varios)
4. Los usuarios asignados verán la pericia en "Mis Pericias"

---

### 👤 Como Usuario Normal

#### Vista Simplificada

Al iniciar sesión solo verás **1 pestaña**:

- **📥 Mis Pericias Asignadas**: Solo tus tareas

#### Funciones Disponibles

- ✅ Ver pericias asignadas a ti
- ✅ Contestar pericias
- ✅ Ver alertas de plazos
- ✅ Recibir notificaciones

#### Lo que NO puedes hacer

- ❌ Ver pericias de otros usuarios
- ❌ Crear nuevas pericias
- ❌ Asignar pericias
- ❌ Gestionar usuarios

---

## 🔄 Casos de Uso Comunes

### Cambiar el Nombre de un Usuario

**Ejemplo**: Juan se cambió el nombre a Juan Pablo

1. Login como **administrador**
2. Ve a **"👥 Gestión de Usuarios"**
3. Encuentra a "Juan Pérez" en la tabla
4. Haz clic en **"✏️ Editar"**
5. Cambia "Juan Pérez" por "Juan Pablo Pérez"
6. Haz clic en **"✅ Guardar"**
7. ✅ El cambio se refleja inmediatamente en todo el sistema

### Promover un Usuario a Administrador

**Ejemplo**: María ahora será administradora

1. Login como **administrador**
2. Ve a **"👥 Gestión de Usuarios"**
3. Encuentra a "María González"
4. Haz clic en **"✏️ Editar"**
5. Cambia el rol de "Usuario" a "Administrador"
6. Haz clic en **"✅ Guardar"**
7. ✅ María ahora ve las opciones de administrador cuando hace login

### Desactivar un Usuario que Ya No Trabaja

**Ejemplo**: Carlos dejó el equipo

1. Login como **administrador**
2. Ve a **"👥 Gestión de Usuarios"**
3. Encuentra a "Carlos Rodríguez"
4. Haz clic en **"✏️ Editar"**
5. Desmarca la casilla **"Activo"**
6. Haz clic en **"✅ Guardar"**
7. ✅ Carlos ya no podrá iniciar sesión ni se mostrará para asignaciones

---

## 🔐 Seguridad del Sistema

### Protecciones Implementadas

✅ **Row Level Security (RLS)**: Los usuarios solo ven sus datos
✅ **Políticas de acceso**: Solo administradores pueden editar usuarios
✅ **No puedes cambiar tu propio rol**: Evita que te quites privilegios por error
✅ **No puedes desactivarte**: Evita quedar bloqueado del sistema
✅ **Auditoría completa**: Todos los cambios quedan registrados

### Verificar Logs de Cambios

```sql
-- Ver últimos cambios en usuarios
SELECT 
  al.operacion,
  al.datos_nuevos->>'nombre_completo' as nombre,
  al.datos_nuevos->>'rol' as nuevo_rol,
  al.created_at as fecha
FROM audit_log al
WHERE al.tabla = 'usuarios'
ORDER BY al.created_at DESC
LIMIT 20;
```

---

## 📊 Consultas Útiles

### Ver todos los administradores

```sql
SELECT nombre_completo, email, activo
FROM usuarios
WHERE rol = 'administrador'
ORDER BY nombre_completo;
```

### Ver usuarios activos por rol

```sql
SELECT 
  rol,
  COUNT(*) as total,
  COUNT(*) FILTER (WHERE activo = true) as activos
FROM usuarios
GROUP BY rol;
```

### Ver pericias por usuario

```sql
SELECT 
  u.nombre_completo,
  COUNT(a.pericia_id) as total_asignadas,
  COUNT(c.id) as total_contestadas
FROM usuarios u
LEFT JOIN asignaciones a ON u.id = a.usuario_id
LEFT JOIN contestaciones c ON u.id = c.usuario_id
GROUP BY u.id, u.nombre_completo
ORDER BY total_asignadas DESC;
```

---

## ⚠️ Notas Importantes

### Sobre el Primer Administrador

- **CRÍTICO**: El primer usuario DEBE ser creado como administrador
- Sin un administrador, nadie puede gestionar el sistema
- Si creaste todos los usuarios como "usuario" por error, usa SQL para promocionar uno:

```sql
UPDATE usuarios 
SET rol = 'administrador' 
WHERE email = 'TU-EMAIL@fiscalia.gob.uy';
```

### Sobre Cambios de Rol

- Los cambios de rol se aplican **en el próximo login**
- Si un usuario está logueado cuando cambias su rol, debe cerrar sesión y volver a entrar
- No se pueden cambiar roles en lote (uno por uno)

### Sobre Nombres de Usuario

- Puedes cambiar nombres tantas veces como quieras
- Los cambios se reflejan inmediatamente en todo el sistema
- El email NO puede cambiarse (es el identificador único)

---

## 🎨 Diferencias Visuales

### Administrador
```
Header: 👑 Nombre Completo
        Administrador

Pestañas: [📥 Mis Pericias] [📊 Todas] [➕ Nueva] [👥 Usuarios]
```

### Usuario
```
Header: 👤 Nombre Completo
        Usuario

Pestañas: [📥 Mis Pericias]
```

---

## ✅ Checklist de Configuración con Roles

- [ ] Schema SQL ejecutado (con columna `rol`)
- [ ] Primer administrador creado en Authentication
- [ ] Primer administrador registrado en tabla `usuarios` con `rol = 'administrador'`
- [ ] Login exitoso como administrador
- [ ] Veo 4 pestañas (incluyendo "Gestión de Usuarios")
- [ ] Puedo editar nombres de usuarios
- [ ] Puedo cambiar roles de usuarios
- [ ] Usuarios normales creados
- [ ] Usuarios normales solo ven 1 pestaña
- [ ] Sistema subido a GitHub Pages
- [ ] Todo funcionando correctamente

---

## 🆘 Solución de Problemas

### Error: "No tengo permiso para editar usuarios"

**Causa**: Tu usuario no tiene rol de administrador
**Solución**:
```sql
-- Verificar tu rol
SELECT rol FROM usuarios WHERE email = 'TU-EMAIL@fiscalia.gob.uy';

-- Si aparece 'usuario', promocionar a admin
UPDATE usuarios SET rol = 'administrador' WHERE email = 'TU-EMAIL@fiscalia.gob.uy';
```

### No veo la pestaña "Gestión de Usuarios"

**Causa**: No eres administrador
**Solución**: Pide a otro administrador que te promueva, o usa SQL (comando arriba)

### Los cambios no se reflejan

**Causa**: Caché del navegador
**Solución**: 
1. Cierra sesión
2. Presiona Ctrl+F5 (forzar recarga)
3. Vuelve a iniciar sesión

---

**¡Sistema actualizado y listo con gestión de roles!** 🎉

Ahora puedes administrar usuarios fácilmente desde el programa sin necesidad de usar SQL.
