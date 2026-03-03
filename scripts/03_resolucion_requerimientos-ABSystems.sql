-- PUNTO 1. Corregir horario según Catalogo_Materias.
UPDATE te
SET te.horario = cm.horarios
FROM Transaccion_Examenes te
INNER JOIN Catalogo_Materias cm
    ON te.id_materias = cm.id_materias;

-- PUNTO 2. Usuarios con más de 1 año sin conexión.
UPDATE Usuarios
SET estatus = 0
WHERE DATEDIFF(YEAR, ultima_conexion, GETDATE()) > 1;

-- PUNTO 3. Agregar nota mínima aprobatoria.
ALTER TABLE Catalogo_Materias
ADD nota_minima_aprobatoria INT;

SELECT * FROM Catalogo_Materias;

UPDATE Catalogo_Materias
SET nota_minima_aprobatoria = 60;

-- PUNTO 4. Presentaron en enero 2025 y aprobaron todo 2025 y 2026.
SELECT id_usuario
FROM Transaccion_Examenes
WHERE id_usuario IN (
    SELECT DISTINCT id_usuario
    FROM Transaccion_Examenes
    WHERE YEAR(fecha) = 2025
      AND MONTH(fecha) = 1
)
GROUP BY id_usuario
HAVING SUM(CASE WHEN YEAR(fecha) IN (2025, 2026)
                AND estatus <> 'Finalizado'
           THEN 1 ELSE 0 END) = 0;

-- PUNTO 5. Materias septiembre 2025 con aprobación < 50%
SELECT id_materias,
       COUNT(*) AS total_examenes,
       SUM(CASE WHEN estatus = 'Finalizado' THEN 1 ELSE 0 END) AS aprobados,
       (SUM(CASE WHEN estatus = 'Finalizado' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*)) AS porcentaje_aprobacion
FROM Transaccion_Examenes
WHERE YEAR(fecha) = 2025
  AND MONTH(fecha) = 9
GROUP BY id_materias
HAVING (SUM(CASE WHEN estatus = 'Finalizado' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*)) < 50;

-- PUNTO 6. Resetear contraseñas inseguras.
UPDATE Usuarios
SET contraseña = ''
WHERE LEN(contraseña) < 8
   OR contraseña NOT LIKE '%[A-Z]%'
   OR contraseña NOT LIKE '%[a-z]%'
   OR contraseña NOT LIKE '%[0-9]%';

-- PUNTO 7. Corregir id_usuario según estudiante.
UPDATE te
SET te.id_usuario = e.id_usuarios
FROM Transaccion_Examenes te
INNER JOIN Estudiantes e
    ON te.id_estudiantes = e.id_estudiantes
WHERE te.id_usuario <> e.id_usuarios;

-- PUNTO 8. Segundo usuario con más aprobados 2025.
WITH Ranking AS (
    SELECT id_usuario,
           COUNT(*) AS total_aprobados,
           ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS posicion
    FROM Transaccion_Examenes
    WHERE YEAR(fecha) = 2025
      AND estatus = 'Finalizado'
    GROUP BY id_usuario
)
SELECT *
FROM Ranking
WHERE posicion = 2;

-- PUNTO 9. Promedio de exámenes perdidos por materia.
SELECT id_materias,
       AVG(CASE WHEN estatus = 'Perdido' THEN 1.0 ELSE 0 END) AS promedio_perdidos
FROM Transaccion_Examenes
GROUP BY id_materias;

-- PUNTO 10. Pendientes de alumnos que no han presentado ningún examen.
SELECT COUNT(*) AS total_pendientes
FROM Transaccion_Examenes te
WHERE estatus = 'Pendiente'
AND NOT EXISTS (
    SELECT 1
    FROM Transaccion_Examenes t2
    WHERE t2.id_estudiantes = te.id_estudiantes
      AND t2.estatus <> 'Pendiente'
);

-- PUNTO 11. Materias pendientes + inscritos + aprobados + %
SELECT cm.nombre_materia,
       COUNT(DISTINCT te.id_estudiantes) AS inscritos,
       SUM(CASE WHEN te.estatus = 'Finalizado' THEN 1 ELSE 0 END) AS aprobados,
       (SUM(CASE WHEN te.estatus = 'Finalizado' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)) AS porcentaje_aprobacion
FROM Catalogo_Materias cm
LEFT JOIN Transaccion_Examenes te
    ON cm.id_materias = te.id_materias
GROUP BY cm.nombre_materia;