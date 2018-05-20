DROP TABLE mensajes;
CREATE TABLE mensajes
(
    id_usuario INT PRIMARY KEY NOT NULL,
    nombre_usuario VARCHAR(50) NOT NULL,
    apellido_usuario VARCHAR(50) NOT NULL,
    mensaje VARCHAR(100),
    enviado VARCHAR(50)
);

COPY mensajes FROM '/Users/jorgequintana/Documents/GitHub/Bets/mensajes.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM mensajes;

DROP TABLE public.contrasenas;
CREATE TABLE contrasenas
(
    id_usuario INT PRIMARY KEY NOT NULL,
    nombre_usuario VARCHAR(50) NOT NULL,
    apellido_usuario VARCHAR(50) NOT NULL,
    usuario VARCHAR(100),
    contrasena VARCHAR(50)
);

COPY contrasenas FROM '/Users/jorgequintana/Documents/GitHub/Bets/contrasenas.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM contrasenas;

DROP TABLE casas;
CREATE TABLE casas
(
    id_casa INT PRIMARY KEY NOT NULL,
    nombre_casa VARCHAR(50) NOT NULL,
    incluir     VARCHAR(4) NOT NULL
);

COPY public.casas FROM '/Users/jorgequintana/Documents/GitHub/Bets/casas.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM casas;

DROP TABLE deportes;
CREATE TABLE deportes
(
    id_deporte INT PRIMARY KEY NOT NULL,
    nombre_deporte VARCHAR(50) NOT NULL
);

COPY deportes FROM '/Users/jorgequintana/Documents/GitHub/Bets/deportes.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM deportes;