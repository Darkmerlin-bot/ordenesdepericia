# 🚀 Guía Rápida de Configuración - Sistema de Pericias

## ✅ Credenciales YA CONFIGURADAS

Tu archivo `index.html` ya tiene las credenciales de Supabase configuradas:
- **Project ID**: dhpwdkysrjjsagtiqwmz
- **URL**: https://dhpwdkysrjjsagtiqwmz.supabase.co
- **Anon Key**: Ya incluida en el código

---

## 📋 Pasos para Activar el Sistema

### 1️⃣ Configurar Base de Datos en Supabase (5 minutos)

1. **Accede a tu proyecto**: https://supabase.com/dashboard/project/dhpwdkysrjjsagtiqwmz

2. **Ejecuta el Schema SQL**:
   - Ve al menú lateral → **SQL Editor**
   - Haz clic en **"New Query"**
   - Copia TODO el contenido del archivo `supabase-schema.sql`
   - Pégalo en el editor
   - Haz clic en **"Run"** (o Ctrl+Enter)
   - Debe aparecer "Success. No rows returned"

3. **Verifica las Tablas**:
   - Ve a **Table Editor** en el menú lateral
   - Deberías ver 5 tablas: `usuarios`, `pericias`, `asignaciones`, `contestaciones`, `audit_log`

---

### 2️⃣ Crear Usuarios del Sistema (3 minutos)

#### A. Crear en Authentication

1. Ve a **Authentication** → **Users** en el menú lateral
2. Haz clic en **"Add User"** → **"Create new user"**
3. Para cada miembro del equipo:
   - **Email**: (ej: `juan.perez@fiscalia.gob.uy`)
   - **Password**: (contraseña segura, ej: `Pericia2025!`)
   - ✅ **Auto Confirm User** (IMPORTANTE: marca esta casilla)
   - Haz clic en **"Create User"**
   - **Copia el UUID que aparece** (ej: `a1b2c3d4-e5f6-7890-abcd-ef1234567890`)

#### B. Sincronizar con tabla usuarios

1. Ve a **SQL Editor** → **New Query**
2. Para cada usuario creado, ejecuta:

```sql
-- Reemplaza los valores con los datos reales
INSERT INTO usuarios (id, email, nombre_completo, activo)
VALUES 
  ('PEGA-AQUI-EL-UUID', 'juan.perez@fiscalia.gob.uy', 'Juan Pérez', true);
```

**Ejemplo completo con 3 usuarios:**

```sql
-- Obtener los UUIDs primero
SELECT id, email FROM auth.users;

-- Luego insertar (reemplaza con tus UUIDs reales)
INSERT INTO usuarios (id, email, nombre_completo, activo)
VALUES 
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'juan.perez@fiscalia.gob.uy', 'Juan Pérez', true),
  ('b2c3d4e5-f6g7-8901-bcde-fg2345678901', 'maria.gonzalez@fiscalia.gob.uy', 'María González', true),
  ('c3d4e5f6-g7h8-9012-cdef-gh3456789012', 'carlos.rodriguez@fiscalia.gob.uy', 'Carlos Rodríguez', true);
```

---

### 3️⃣ Subir a GitHub Pages (5 minutos)

#### Opción A: Interfaz Web (Más Fácil)

1. **Crear Repositorio**:
   - Ve a https://github.com y inicia sesión
   - Clic en "+" arriba derecha → "New repository"
   - **Name**: `sistema-pericias-forenses`
   - **Public** o **Private** (tu elección)
   - NO marcar "Initialize with README"
   - Clic en **"Create repository"**

2. **Subir el archivo**:
   - En la página del repo, clic en **"uploading an existing file"**
   - Arrastra `index.html` a la zona de carga
   - En "Commit changes" escribe: `Sistema de Pericias configurado`
   - Clic en **"Commit changes"**

3. **Activar GitHub Pages**:
   - Ve a **Settings** (engranaje arriba)
   - Menú lateral → **Pages**
   - En "Source" selecciona: **main** o **master**
   - En "Folder" selecciona: **/ (root)**
   - Clic en **"Save"**
   - Espera 1-2 minutos
   - Refresca la página
   - Verás: "Your site is live at `https://TU-USUARIO.github.io/sistema-pericias-forenses/`"

#### Opción B: Línea de Comandos (Git)

```bash
# En la carpeta donde está index.html
git init
git add index.html
git commit -m "Sistema de Pericias configurado"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/sistema-pericias-forenses.git
git push -u origin main

# GitHub Pages se activará automáticamente o ve a Settings > Pages
```

---

## 🎯 Verificación Final

### Test 1: Login
1. Abre la URL de GitHub Pages
2. Ingresa con uno de los usuarios creados
3. Si entra al dashboard → ✅ Funciona

### Test 2: Crear Pericia
1. Ve a pestaña **"➕ Nueva Pericia"**
2. Completa todos los campos
3. Asigna usuarios
4. Guarda
5. Si aparece en "Todas las Pericias" → ✅ Funciona

### Test 3: Contestar Pericia
1. Ve a **"📥 Mis Pericias Asignadas"**
2. Haz clic en una pericia
3. Completa contestación
4. Guarda
5. Si aparece la respuesta → ✅ Funciona

---

## 🔧 Solución Rápida de Problemas

### ❌ Error: "Invalid API key"
**Causa**: El archivo index.html no se guardó correctamente con las credenciales
**Solución**: Vuelve a descargar el `index.html` de este chat (ya tiene las credenciales)

### ❌ Error: "Failed to fetch"
**Causa**: El Schema SQL no se ejecutó en Supabase
**Solución**: Ve a SQL Editor y ejecuta el archivo `supabase-schema.sql` completo

### ❌ No aparecen usuarios para asignar
**Causa**: No se ejecutó el INSERT en la tabla `usuarios`
**Solución**: Ejecuta el SQL del Paso 2B con tus UUIDs

### ❌ "No tienes pericias asignadas"
**Causa**: Normal si es la primera vez
**Solución**: Ve a "Todas las Pericias" y crea una nueva asignándote

---

## 📊 URLs Importantes

- **Tu Supabase**: https://supabase.com/dashboard/project/dhpwdkysrjjsagtiqwmz
- **SQL Editor**: https://supabase.com/dashboard/project/dhpwdkysrjjsagtiqwmz/editor
- **Authentication**: https://supabase.com/dashboard/project/dhpwdkysrjjsagtiqwmz/auth/users
- **Tu GitHub Pages**: https://TU-USUARIO.github.io/sistema-pericias-forenses/

---

## 💡 Consejos Útiles

### Crear más usuarios después
```sql
-- 1. Crear en Authentication > Users
-- 2. Copiar el UUID generado
-- 3. Ejecutar:
INSERT INTO usuarios (id, email, nombre_completo, activo)
VALUES ('UUID-AQUI', 'nuevo@fiscalia.gob.uy', 'Nombre Completo', true);
```

### Ver estadísticas del sistema
```sql
SELECT 
  COUNT(*) as total,
  COUNT(*) FILTER (WHERE estado = 'pendiente') as pendientes,
  COUNT(*) FILTER (WHERE estado = 'contestada') as contestadas
FROM pericias;
```

### Ver pericias urgentes
```sql
SELECT numero_sgsp, fiscalia, plazo, estado
FROM pericias
WHERE plazo <= CURRENT_DATE + INTERVAL '2 days'
  AND estado != 'contestada'
ORDER BY plazo;
```

---

## ✅ Checklist de Activación

- [ ] SQL Schema ejecutado en Supabase
- [ ] Tablas verificadas en Table Editor
- [ ] Usuarios creados en Authentication
- [ ] Usuarios insertados en tabla `usuarios`
- [ ] Repositorio creado en GitHub
- [ ] `index.html` subido al repositorio
- [ ] GitHub Pages activado
- [ ] Login funciona correctamente
- [ ] Puedo crear pericias
- [ ] Puedo asignar usuarios
- [ ] Puedo contestar pericias

---

**¡Todo listo! El sistema está configurado y listo para usar.** 🎉

Si tienes algún problema, consulta el README.md completo para más detalles.
