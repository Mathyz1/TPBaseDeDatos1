use TerminalAutomotriz;

INSERT INTO Modelo(nombre) VALUES ("KA");
INSERT INTO Modelo(nombre) VALUES ("Ranger");
INSERT INTO Modelo(nombre) VALUES ("Focus");
INSERT INTO Modelo(nombre) VALUES ("Fiesta");

INSERT INTO LineaDeMontaje(idModelo) VALUES (1);
INSERT INTO LineaDeMontaje(idModelo) VALUES (2);
INSERT INTO LineaDeMontaje(idModelo) VALUES (3);
INSERT INTO LineaDeMontaje(idModelo) VALUES (4);

-- Cargamos los datos en Estación
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (1, "motor", 1, 1);
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (2, "carrocería", 2, 1);
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (3, "pintura", 2, 1);
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (4, "ensamblado final", 4, 1);

INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (1, "motor", 1, 2);
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (2, "carrocería", 2, 2);
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (3, "pintura", 2, 2);
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (4, "ensamblado final", 2, 2);

INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (1, "motor", 1, 3);
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (2, "carrocería", 2, 3);
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (3, "pintura", 2, 3);
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (4, "ensamblado final", 2, 3);

INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (1, "motor", 1, 4);
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (2, "carrocería", 2, 4);
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (3, "pintura", 2, 4);
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (4, "ensamblado final", 2, 4);
