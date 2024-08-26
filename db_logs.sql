-- Crear la base de datos
CREATE DATABASE db_logs

CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    severity VARCHAR(50) NOT NULL,
    datetime TIMESTAMP NOT NULL,
    progname VARCHAR(255) NOT NULL,
    message TEXT NOT NULL
);

INSERT INTO logs (severity, datetime, progname, message)
VALUES ('DEBUG', '2023-10-05 12:34:56 -400', 'servicio1.rb', 'Hola mundo');

SELECT * FROM logs;
