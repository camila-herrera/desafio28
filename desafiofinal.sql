CREATE DATABASE desafio_sql;
\l

--2-------------------------------------------------------------------------
\c desafio_sql




Dado el siguiente modelo:

--1. Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves primarias, foráneas y tipos de datos

-- Tabla Peliculas
CREATE TABLE peliculas (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    anno INTEGER
);

-- Tabla Tags
CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    tag VARCHAR(32) NOT NULL
);

-- Tabla intermedia para la relación muchos a muchos entre Peliculas y Tags
CREATE TABLE peliculas_tags (
    pelicula_id INTEGER,
    tag_id INTEGER,
    PRIMARY KEY (pelicula_id, tag_id),
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

-- 2.- Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la  segunda película debe tener 2 tags asociados.; 
-- Insertar películas en la tabla peliculas
INSERT INTO peliculas (id, nombre, anno) VALUES
(1, 'Inception', 2010),
(2, 'The Matrix', 1999),
(3, 'Interstellar', 2014),
(4, 'The Godfather', 1972),
(5, 'The Dark Knight', 2008);

-- Insertar tags en la tabla tags
INSERT INTO tags (id, tag) VALUES
(1, 'Sci-Fi'),
(2, 'Action'),
(3, 'Drama'),
(4, 'Thriller'),
(5, 'Classic');

-- Asociar tags a las películas en la tabla peliculas_tags
-- Primera película (Inception) con 3 tags
INSERT INTO peliculas_tags (pelicula_id, tag_id) VALUES
(1, 1),
(1, 4),
(1, 2);

-- Segunda película (The Matrix) con 2 tags
INSERT INTO peliculas_tags (pelicula_id, tag_id) VALUES
(2, 1), 
(2, 2);


--3.-Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.
SELECT p.nombre AS pelicula, COUNT(pt.tag_id) AS cantidad_tags
FROM peliculas p
LEFT JOIN peliculas_tags pt ON p.id = pt.pelicula_id
GROUP BY p.id;

------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
dado el modelo:
tabla peliculas con 3 columna la primera PK llamada ID Integer, pregunta varchar 255 y respuesta correcta varchar, esta tabla esta ligada a 
la tabla respuesta con una relacion uno es a muchos donde la tabla respuestas tiene 4 columnas solo la primera es PK llamada ID integer, la segunda llamadaresouesta con un varchar de 255. los dos ultimos son FK ambos interger uno llamado usuario_id, y el otro llamado pregunta_id esta igualmente tiene una relacion de muchos es a uno con 
la tabla usuarios con 3 columnas donde solo la primera es PK llamada ID interger, la segunda nombre varchar 255 y por ultimo edad con integer. 
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
--4. Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y foráneas y tipos de datos.

-- Crear la tabla usuarios
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    edad INTEGER
);

-- Crear la tabla preguntas
CREATE TABLE preguntas (
    id INTEGER PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR
);

--tabla de respuestas 
CREATE TABLE respuestas (
    id INTEGER PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INTEGER,
    pregunta_id INTEGER,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id)
);



--5. Agrega 5 usuarios y 5 preguntas.
 a. La primera pregunta debe estar respondida correctamente dos veces, por dos
 usuarios diferentes.

 b. La segunda pregunta debe estar contestada correctamente solo por un
 usuario.

 c. Las otras tres preguntas deben tener respuestas incorrectas.

 Contestada correctamente significa que la respuesta indicada en la tabla respuestas
 es exactamente igual al texto indicado en la tabla de preguntas.
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
 -- Insertar usuarios
INSERT INTO usuarios (id, nombre, edad) VALUES
(1, 'Juan', 25),
(2, 'Ana', 30),
(3, 'Luis', 22),
(4, 'María', 28),
(5, 'Carlos', 32);

-- Insertar preguntas
INSERT INTO preguntas (id, pregunta, respuesta_correcta) VALUES
(1, '¿Cuál es la capital de Francia?', 'París'),
(2, '¿Cuál es el resultado de 5 + 5?', '10'),
(3, '¿Cuál es el color del cielo en un día despejado?', 'Azul'),
(4, '¿Cuántos días tiene una semana?', 'Siete'),
(5, '¿Cuál es el océano más grande del mundo?', 'Pacífico');

-- Insertar respuestas:
-- Primera pregunta respondida correctamente por dos usuarios
INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES
(1, 'París', 1, 1),
(2, 'París', 2, 1);

-- Segunda pregunta respondida correctamente por un usuario
INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES
(3, '10', 3, 2);

-- Respuestas incorrectas para las otras preguntas
INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES
(4, 'Rojo', 4, 3),
(5, 'Cinco', 5, 4),
(6, 'Atlántico', 1, 5);


--6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).
SELECT u.nombre AS usuario, COUNT(r.id) AS respuestas_correctas
FROM usuarios u
JOIN respuestas r ON u.id = r.usuario_id
JOIN preguntas p ON r.pregunta_id = p.id
WHERE r.respuesta = p.respuesta_correcta
GROUP BY u.id;


--7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente.
SELECT p.pregunta, COUNT(r.id) AS cantidad_respuestas_correctas
FROM preguntas p
LEFT JOIN respuestas r ON p.id = r.pregunta_id AND r.respuesta = p.respuesta_correcta
GROUP BY p.id;


--8. Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la implementación borrando el primer usuario.
SELECT * FROM usuarios;
DELETE FROM usuarios WHERE id = 1;

ALTER TABLE respuestas
DROP CONSTRAINT respuestas_usuario_id_fkey;

ALTER TABLE respuestas
ADD CONSTRAINT respuestas_usuario_id_fkey FOREIGN KEY (usuario_id)
REFERENCES usuarios(id) ON DELETE CASCADE;

-- Eliminar el primer usuario y sus respuestas en cascada
DELETE FROM usuarios WHERE id = 1;


--9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.
ALTER TABLE usuarios
ADD CONSTRAINT edad_min CHECK (edad >= 18);

Esta restricción ya está implementada en el campo edad de la tabla usuarios mediante la restricción CHECK (edad >= 18).

-- Este intento debería fallar debido a la restricción de edad mínima
INSERT INTO usuarios (id, nombre, edad) VALUES (7, 'Joven', 17);
SELECT * FROM usuarios;



--10. Altera la tabla existente de usuarios agregando el campo email. Debe tener la restricción de ser único
-- Agregar el campo email con restricción de unicidad
ALTER TABLE usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;

-- Agregar un usuario con email
INSERT INTO usuarios (id, nombre, edad, email) VALUES (8, 'Carlos', 27, 'carlos@example.com');

-- Intentar agregar otro usuario con el mismo email (esto debería fallar)
INSERT INTO usuarios (id, nombre, edad, email) VALUES (9, 'Carla', 30, 'carlos@example.com');




------------
----------
----------
---------
---------
----------

\c postgres

\l

DROP DATABASE desafio_sql;
