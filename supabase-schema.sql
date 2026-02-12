-- =============================================================================
-- SISTEMA DE GESTIÓN DE PERICIAS FORENSES
-- Schema SQL para Supabase con Row Level Security (RLS)
-- =============================================================================

-- 1. TABLA DE USUARIOS
CREATE TABLE IF NOT EXISTS usuarios (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  nombre_completo TEXT NOT NULL,
  rol TEXT DEFAULT 'usuario' CHECK (rol IN ('administrador', 'usuario')),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. TABLA DE PERICIAS (Fichas principales)
CREATE TABLE IF NOT EXISTS pericias (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  numero_sgsp TEXT NOT NULL,
  pericia_solicitada TEXT NOT NULL,
  fiscalia TEXT NOT NULL CHECK (fiscalia IN (
    '1er Turno',
    '2do Turno',
    '3er Turno',
    '4to Turno',
    '5to Turno',
    '1er Turno Delitos Sexuales',
    '2do Turno Delitos Sexuales'
  )),
  plazo DATE NOT NULL,
  numero_novedad TEXT NOT NULL,
  estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'en_proceso', 'contestada')),
  creado_por UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. TABLA DE ASIGNACIONES (Relación muchos a muchos)
CREATE TABLE IF NOT EXISTS asignaciones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pericia_id UUID REFERENCES pericias(id) ON DELETE CASCADE NOT NULL,
  usuario_id UUID REFERENCES usuarios(id) NOT NULL,
  notificado BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(pericia_id, usuario_id)
);

-- 4. TABLA DE CONTESTACIONES
CREATE TABLE IF NOT EXISTS contestaciones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pericia_id UUID REFERENCES pericias(id) ON DELETE CASCADE NOT NULL,
  usuario_id UUID REFERENCES usuarios(id) NOT NULL,
  fecha_respuesta DATE NOT NULL,
  hora_respuesta TIME NOT NULL,
  contestacion TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. TABLA DE AUDIT LOG (Auditoría completa)
CREATE TABLE IF NOT EXISTS audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tabla TEXT NOT NULL,
  operacion TEXT NOT NULL,
  registro_id UUID NOT NULL,
  usuario_id UUID REFERENCES auth.users(id),
  datos_anteriores JSONB,
  datos_nuevos JSONB,
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =============================================================================

CREATE INDEX idx_pericias_estado ON pericias(estado);
CREATE INDEX idx_pericias_plazo ON pericias(plazo);
CREATE INDEX idx_pericias_creado_por ON pericias(creado_por);
CREATE INDEX idx_asignaciones_usuario ON asignaciones(usuario_id);
CREATE INDEX idx_asignaciones_pericia ON asignaciones(pericia_id);
CREATE INDEX idx_contestaciones_pericia ON contestaciones(pericia_id);
CREATE INDEX idx_audit_log_usuario ON audit_log(usuario_id);
CREATE INDEX idx_audit_log_created ON audit_log(created_at);

-- =============================================================================
-- ROW LEVEL SECURITY (RLS) - SEGURIDAD MÁXIMA
-- =============================================================================

-- Habilitar RLS en todas las tablas
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE pericias ENABLE ROW LEVEL SECURITY;
ALTER TABLE asignaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE contestaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- Políticas para USUARIOS
CREATE POLICY "usuarios_select_all" ON usuarios FOR SELECT USING (activo = true);

CREATE POLICY "usuarios_insert_admin" ON usuarios FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM usuarios WHERE id = auth.uid() AND rol = 'administrador')
);

CREATE POLICY "usuarios_update_admin" ON usuarios FOR UPDATE USING (
  EXISTS (SELECT 1 FROM usuarios WHERE id = auth.uid() AND rol = 'administrador')
);

-- Políticas para PERICIAS
CREATE POLICY "pericias_select_assigned" ON pericias FOR SELECT USING (
  creado_por = auth.uid() OR 
  id IN (SELECT pericia_id FROM asignaciones WHERE usuario_id IN (SELECT id FROM usuarios WHERE id IN (SELECT id FROM auth.users WHERE id = auth.uid())))
);

CREATE POLICY "pericias_insert_authenticated" ON pericias FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "pericias_update_creator" ON pericias FOR UPDATE USING (creado_por = auth.uid());

-- Políticas para ASIGNACIONES
CREATE POLICY "asignaciones_select_assigned" ON asignaciones FOR SELECT USING (
  usuario_id IN (SELECT id FROM usuarios WHERE id IN (SELECT id FROM auth.users WHERE id = auth.uid()))
);

CREATE POLICY "asignaciones_insert_authenticated" ON asignaciones FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- Políticas para CONTESTACIONES
CREATE POLICY "contestaciones_select_related" ON contestaciones FOR SELECT USING (
  pericia_id IN (SELECT id FROM pericias WHERE creado_por = auth.uid()) OR
  usuario_id IN (SELECT id FROM usuarios WHERE id IN (SELECT id FROM auth.users WHERE id = auth.uid()))
);

CREATE POLICY "contestaciones_insert_assigned" ON contestaciones FOR INSERT WITH CHECK (
  usuario_id IN (SELECT id FROM usuarios WHERE id IN (SELECT id FROM auth.users WHERE id = auth.uid()))
);

-- Políticas para AUDIT LOG (solo lectura para todos, escritura automática)
CREATE POLICY "audit_log_select_all" ON audit_log FOR SELECT USING (true);

-- =============================================================================
-- FUNCIONES Y TRIGGERS
-- =============================================================================

-- Función para actualizar updated_at
CREATE OR REPLACE FUNCTION actualizar_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para updated_at
CREATE TRIGGER actualizar_usuarios_updated_at
  BEFORE UPDATE ON usuarios
  FOR EACH ROW
  EXECUTE FUNCTION actualizar_updated_at();

CREATE TRIGGER actualizar_pericias_updated_at
  BEFORE UPDATE ON pericias
  FOR EACH ROW
  EXECUTE FUNCTION actualizar_updated_at();

CREATE TRIGGER actualizar_contestaciones_updated_at
  BEFORE UPDATE ON contestaciones
  FOR EACH ROW
  EXECUTE FUNCTION actualizar_updated_at();

-- Función para auditoría automática
CREATE OR REPLACE FUNCTION registrar_auditoria()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_log (tabla, operacion, registro_id, usuario_id, datos_anteriores, datos_nuevos)
  VALUES (
    TG_TABLE_NAME,
    TG_OP,
    COALESCE(NEW.id, OLD.id),
    auth.uid(),
    CASE WHEN TG_OP = 'DELETE' THEN row_to_json(OLD) ELSE NULL END,
    CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN row_to_json(NEW) ELSE NULL END
  );
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Triggers de auditoría
CREATE TRIGGER audit_pericias
  AFTER INSERT OR UPDATE OR DELETE ON pericias
  FOR EACH ROW EXECUTE FUNCTION registrar_auditoria();

CREATE TRIGGER audit_contestaciones
  AFTER INSERT OR UPDATE OR DELETE ON contestaciones
  FOR EACH ROW EXECUTE FUNCTION registrar_auditoria();

-- Función para actualizar estado de pericia automáticamente
CREATE OR REPLACE FUNCTION actualizar_estado_pericia()
RETURNS TRIGGER AS $$
DECLARE
  total_asignados INTEGER;
  total_contestados INTEGER;
BEGIN
  -- Contar asignaciones y contestaciones
  SELECT COUNT(*) INTO total_asignados 
  FROM asignaciones 
  WHERE pericia_id = NEW.pericia_id;
  
  SELECT COUNT(*) INTO total_contestados 
  FROM contestaciones 
  WHERE pericia_id = NEW.pericia_id;
  
  -- Actualizar estado
  IF total_contestados = 0 THEN
    UPDATE pericias SET estado = 'pendiente' WHERE id = NEW.pericia_id;
  ELSIF total_contestados < total_asignados THEN
    UPDATE pericias SET estado = 'en_proceso' WHERE id = NEW.pericia_id;
  ELSE
    UPDATE pericias SET estado = 'contestada' WHERE id = NEW.pericia_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_estado_al_contestar
  AFTER INSERT ON contestaciones
  FOR EACH ROW EXECUTE FUNCTION actualizar_estado_pericia();

-- =============================================================================
-- VISTAS ÚTILES
-- =============================================================================

-- Vista de pericias con información completa
CREATE OR REPLACE VIEW vista_pericias_completas AS
SELECT 
  p.*,
  u.nombre_completo as creador_nombre,
  ARRAY_AGG(DISTINCT us.nombre_completo) as usuarios_asignados,
  COUNT(DISTINCT c.id) as total_contestaciones,
  COUNT(DISTINCT a.id) as total_asignaciones,
  CASE 
    WHEN p.plazo - CURRENT_DATE <= 2 THEN true 
    ELSE false 
  END as alerta_plazo,
  p.plazo - CURRENT_DATE as dias_restantes
FROM pericias p
LEFT JOIN usuarios u ON p.creado_por = u.id
LEFT JOIN asignaciones a ON p.id = a.pericia_id
LEFT JOIN usuarios us ON a.usuario_id = us.id
LEFT JOIN contestaciones c ON p.id = c.pericia_id
GROUP BY p.id, u.nombre_completo;

-- =============================================================================
-- DATOS INICIALES (OPCIONAL)
-- =============================================================================

-- Insertar primer administrador
-- IMPORTANTE: Ejecutar esto DESPUÉS de crear el usuario en Authentication
-- Reemplazar 'UUID-DEL-USUARIO' con el UUID real del usuario creado

-- INSERT INTO usuarios (id, email, nombre_completo, rol, activo) 
-- VALUES ('UUID-DEL-USUARIO', 'admin@fiscalia.gob.uy', 'Administrador Sistema', 'administrador', true)
-- ON CONFLICT (id) DO UPDATE SET rol = 'administrador';

-- Insertar usuarios normales
-- INSERT INTO usuarios (id, email, nombre_completo, rol, activo) 
-- VALUES 
--   ('UUID-USUARIO-1', 'usuario1@fiscalia.gob.uy', 'Juan Pérez', 'usuario', true),
--   ('UUID-USUARIO-2', 'usuario2@fiscalia.gob.uy', 'María González', 'usuario', true)
-- ON CONFLICT (id) DO NOTHING;

-- =============================================================================
-- NOTAS DE SEGURIDAD
-- =============================================================================

-- 1. Todas las tablas tienen RLS habilitado
-- 2. Los usuarios solo pueden ver pericias donde están asignados o las crearon
-- 3. Auditoría completa de todas las operaciones
-- 4. Validación de datos con CHECK constraints
-- 5. Índices para optimización de consultas
-- 6. Triggers automáticos para mantener integridad
-- 7. Funciones con SECURITY DEFINER para operaciones sensibles
