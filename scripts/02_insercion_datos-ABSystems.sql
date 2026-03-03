CREATE TABLE Usuarios (
    id_usuarios INT PRIMARY KEY,
    estatus BIT,
    usuario VARCHAR(50),
    contraseña VARCHAR(100),
    email VARCHAR(100),
    creacion DATE,
    ultima_conexion DATE
);

CREATE TABLE Estudiantes (
    id_estudiantes INT PRIMARY KEY,
    id_usuarios INT,
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    fecha_nacimiento DATE,
    direccion VARCHAR(200),
    sexo CHAR(1),
    curp VARCHAR(20),
    telefono VARCHAR(15),
    email VARCHAR(100),
    FOREIGN KEY (id_usuarios) REFERENCES Usuarios(id_usuarios)
);

CREATE TABLE Catalogo_Materias (
    id_materias INT PRIMARY KEY,
    nombre_materia VARCHAR(100),
    horarios VARCHAR(50),
    modalidad VARCHAR(50)
);

CREATE TABLE Transaccion_Examenes (
    id_examenes INT PRIMARY KEY,
    id_usuario INT,
    id_estudiantes INT,
    id_materias INT,
    fecha DATE,
    horario VARCHAR(50),
    modalidad VARCHAR(50),
    estatus VARCHAR(50),
    calificacion INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuarios),
    FOREIGN KEY (id_estudiantes) REFERENCES Estudiantes(id_estudiantes),
    FOREIGN KEY (id_materias) REFERENCES Catalogo_Materias(id_materias)
);

INSERT INTO Usuarios (
    id_usuarios,
    estatus,
    usuario,
    contraseña,
    email,
    creacion,
    ultima_conexion
)
VALUES
-- (id, estatus, usuario, contraseña, email, fecha_creacion, ultima_conexion)
( 1, 1, 'test01', '1234', 'test01@email.com', '2025-01-01', '2026-02-01' ),
( 2, 1, 'test02', '4321', 'test02@email.com', '2025-01-01', '2026-01-01' ),
( 3, 1, 'test03', '2314', 'test03@email.com', '2025-01-01', '2026-01-15' );
GO

INSERT INTO Estudiantes (
    id_estudiantes,
    id_usuarios,
    nombres,
    apellidos,
    fecha_nacimiento,
    direccion,
    sexo,
    curp,
    telefono,
    email
)
VALUES
( 1, 1, 'test', '01', '1990-01-01', 'Av. Popular 1234', 'F', 'DRT012TSD', '1234567890', 'test01@email.com' ),
( 2, 2, 'test', '02', '1980-01-01', 'Av. Impopular 1234', 'M', 'TFRASE123', '1234567890', 'test02@email.com' ),
( 3, 3, 'test', '03', '2000-01-01', 'Av. Neutral 1234', 'M', 'TRS779RTD', '1234567890', 'test03@email.com' );
GO

INSERT INTO Catalogo_Materias (
    id_materias,
    nombre_materia,
    horarios,
    modalidad
)
VALUES
( 1, 'Fisica', 'Mañana', 'Presencial' ),
( 2, 'Quimica', 'Todos', 'Todos' ),
( 3, 'Matematicas', 'Tarde', 'Remota' );
GO

INSERT INTO Transaccion_Examenes (
    id_examenes,
    id_usuario,
    id_estudiantes,
    id_materias,
    fecha,
    horario,
    modalidad,
    estatus,
    calificacion
)
VALUES
( 1, 1, 1, 1, '2026-02-01', 'Mañana', 'Presencial', 'Finalizado', 100),
( 2, 1, 1, 2, '2026-02-03', 'Mañana', 'Presencial', 'Pendiente', null),
( 3, 2, 2, 2, '2026-02-05', 'Tarde', 'Remoto', 'Perdido', 0),
( 3, 1, 1, 1, '2025-01-10', 'Mañana', 'Presencial', 'Finalizado', 90),
( 4, 1, 1, 2, '2025-06-10', 'Mañana', 'Presencial', 'Finalizado', 95),
( 4, 3, 3, 3, '2026-02-07', 'Tarde', 'Remoto', 'Finalizado', 85);

GO

SELECT * FROM Usuarios;
SELECT * FROM Estudiantes;
SELECT * FROM Catalogo_Materias;
SELECT * FROM Transaccion_Examenes;

