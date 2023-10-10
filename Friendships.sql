/* Usando el ERD como referencia, escribe una consulta SQL que devuelva una lista de usuarios junto con los nombres de sus amigos. */

SELECT CONCAT(u1.first_name, ' ', u1.last_name) AS Usuario, CONCAT(u2.first_name, ' ', u2.last_name) AS Amigo
FROM users AS u1 LEFT JOIN friendships AS f ON(u1.id = f.user_id)
			  LEFT JOIN users AS u2 ON(u2.id = f.friend_id);

/* otra opción */
SELECT CONCAT(u1.first_name, ' ', u1.last_name) AS Usuario, GROUP_CONCAT(' ', u2.first_name, ' ', u2.last_name) AS Amigo
FROM users AS u1 LEFT JOIN friendships AS f ON(u1.id = f.user_id)
			  LEFT JOIN users AS u2 ON(u2.id = f.friend_id)
GROUP BY u1.id;

/* 1. Devuelva a todos los usuarios que son amigos de Kermit, asegúrese de que sus nombres se muestren en los resultados. */

SELECT  CONCAT(u2.first_name, ' ', u2.last_name) AS Usuario, CONCAT(u1.first_name, ' ', u1.last_name) AS Amigo
FROM users AS u1 LEFT JOIN friendships AS f ON(u1.id = f.user_id)
			  LEFT JOIN users AS u2 ON(u2.id = f.friend_id)
WHERE u2.first_name = 'Kermit';

/* 2. Devuelve el recuento de todas las amistades. */

SELECT COUNT(*) AS 'Total Amistades'
FROM users AS u1 LEFT JOIN friendships AS f ON(u1.id = f.user_id)
			  LEFT JOIN users AS u2 ON(u2.id = f.friend_id);
              
/* 3. Descubre quién tiene más amigos y devuelve el recuento de sus amigos. */
-- lista con cantidad de amigos por usuario
SELECT CONCAT(u1.first_name, ' ', u1.last_name) AS 'Nombre Usuario',  COUNT(f.friend_id) AS 'Cantidad Amigos'
FROM users AS u1 LEFT JOIN friendships AS f ON(u1.id = f.user_id)
			  LEFT JOIN users AS u2 ON(u2.id = f.friend_id)
GROUP BY u1.id;

-- usuario con mas amigos si el resultados es un usuario
SELECT CONCAT(u1.first_name, ' ', u1.last_name) AS 'Nombre Usuario',  COUNT(f.friend_id) AS 'Cantidad Amigos'
FROM users AS u1 LEFT JOIN friendships AS f ON(u1.id = f.user_id)
			  LEFT JOIN users AS u2 ON(u2.id = f.friend_id)
GROUP BY u1.id
ORDER BY 'Cantidad Amigos'
LIMIT 1;

-- usuarios con mas amigos si el resultados es mas de un usuario
SELECT CONCAT(u1.first_name, ' ', u1.last_name) AS 'Nombre Usuario',  COUNT(f.friend_id) AS 'Cantidad Amigos'
FROM users AS u1 LEFT JOIN friendships AS f ON (u1.id = f.user_id)
			  LEFT JOIN users AS u2 ON (u2.id = f.friend_id)
GROUP BY u1.id
HAVING COUNT(f.friend_id) = (
    SELECT MAX(AmigosContados)
    FROM (
        SELECT COUNT(friend_id) AS AmigosContados
        FROM friendships
        GROUP BY user_id
    ) AS ConteosAmigos
);

/* 4. Crea un nuevo usuario y hazlos amigos de Eli Byers(2), Kermit The Frog(4) y Marky Mark(5). */
-- Crear el nuevo usuario
INSERT INTO users(first_name, last_name, created_at)
VALUES ('Alex', 'Draven', Now());

-- establecer amistad
INSERT INTO friendships (user_id, friend_id, created_at)
VALUES ('6', '2', NOW()), ('6', '4', NOW()), ('6', '5', NOW());

/* 5. Devuelve a los amigos de Eli en orden alfabético. */
-- por nombre
SELECT CONCAT(u1.first_name, ' ', u1.last_name) AS Usuario, CONCAT(u2.first_name, ' ', u2.last_name) AS Amigo
FROM users AS u1 LEFT JOIN friendships AS f ON(u1.id = f.user_id)
			  LEFT JOIN users AS u2 ON(u2.id = f.friend_id)
WHERE u1.id = 2
ORDER BY u2.first_name ASC;

-- por apellido
SELECT CONCAT(u1.first_name, ' ', u1.last_name) AS Usuario, CONCAT(u2.first_name, ' ', u2.last_name) AS Amigo
FROM users AS u1 LEFT JOIN friendships AS f ON(u1.id = f.user_id)
			  LEFT JOIN users AS u2 ON(u2.id = f.friend_id)
WHERE u1.id = 2
ORDER BY u2.last_name ASC;

/* 6. Eliminar a Marky Mark de los amigos de Eli. */

DELETE FROM friendships
WHERE user_id = 2 AND friend_id = 5;

/* 7. Devuelve todas las amistades, mostrando solo el nombre y apellido de ambos amigos */

SELECT CONCAT(u1.first_name, ' ', u1.last_name) AS Usuario, CONCAT(u2.first_name, ' ', u2.last_name) AS Amigo
FROM friendships AS f JOIN users AS u1 ON(f.user_id = u1.id)
					  JOIN users AS u2 ON(f.friend_id = u2.id);