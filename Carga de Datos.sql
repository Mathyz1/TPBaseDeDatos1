use TerminalAutomotriz;

INSERT INTO Modelo(nombre) VALUES ("KA");
INSERT INTO Modelo(nombre) VALUES ("Ranger");
INSERT INTO Modelo(nombre) VALUES ("Focus");
INSERT INTO Modelo(nombre) VALUES ("Fiesta");

INSERT INTO LineaDeMontaje(idModelo) VALUES (1);
INSERT INTO LineaDeMontaje(idModelo) VALUES (2);
INSERT INTO LineaDeMontaje(idModelo) VALUES (3);
INSERT INTO LineaDeMontaje(idModelo) VALUES (4);

-- Damos de alta las partes
CALL altaPartes("motor", @res, @msg);
CALL altaPartes("caño de escape", @res, @msg); -- fin 1ro
CALL altaPartes("neumáticos", @res, @msg);
CALL altaPartes("volante", @res, @msg);
CALL altaPartes("airbag", @res, @msg); -- fin 2do
CALL altaPartes("cableado", @res, @msg);
CALL altaPartes("frenos", @res, @msg);
CALL altaPartes("pintura", @res, @msg); -- fin 3ro
CALL altaPartes("asientos", @res, @msg); 
CALL altaPartes("vidrios", @res, @msg); -- fin 4to

-- Cargamos los datos en Estación
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (1, "motor", 10, 1); -- motor, caño de escape
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (2, "carrocería", 100, 1); -- ruedas, volantes, airbag, cableado(m), frenos
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (3, "pintura", 25, 1); --pintura(ls)
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (4, "ensamblado final", 60, 1); -- asiento, vidrio

INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (1, "motor", 10, 2); -- motor, caño de escape
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (2, "carrocería", 100, 2); -- ruedas, volantes, airbag, cableado(m), frenos
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (3, "pintura", 25, 2); --pintura(ls)
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (4, "ensamblado final", 60, 2); -- asiento, vidrio

INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (1, "motor", 10, 3); -- motor, caño de escape
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (2, "carrocería", 100, 3); -- ruedas, volantes, airbag, cableado(m), frenos
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (3, "pintura", 25, 3); --pintura(ls)
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (4, "ensamblado final", 60, 3); -- asiento, vidrio

INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (1, "motor", 10, 4); -- motor, caño de escape
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (2, "carrocería", 100, 4); -- ruedas, volantes, airbag, cableado(m), frenos
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (3, "pintura", 25, 4); --pintura(ls)
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (4, "ensamblado final", 60, 4); -- asiento, vidrio

INSERT INTO Estacion_has_Partes(1, 1, 5);
INSERT INTO Estacion_has_Partes(1, 2, 5);
INSERT INTO Estacion_has_Partes(1, 3, 50);
INSERT INTO Estacion_has_Partes(1, 4, 10);
INSERT INTO Estacion_has_Partes(1, 5, 20);
INSERT INTO Estacion_has_Partes(1, 6, 1000);
INSERT INTO Estacion_has_Partes(1, 7, 20);
INSERT INTO Estacion_has_Partes(1, 8, 200);
INSERT INTO Estacion_has_Partes(1, 9, 100);
INSERT INTO Estacion_has_Partes(1, 10, 150);

INSERT INTO Estacion_has_Partes(2, 1, 5);
INSERT INTO Estacion_has_Partes(2, 2, 5);
INSERT INTO Estacion_has_Partes(2, 3, 50);
INSERT INTO Estacion_has_Partes(2, 4, 10);
INSERT INTO Estacion_has_Partes(2, 5, 20);
INSERT INTO Estacion_has_Partes(2, 6, 1000);
INSERT INTO Estacion_has_Partes(2, 7, 20);
INSERT INTO Estacion_has_Partes(2, 8, 200);
INSERT INTO Estacion_has_Partes(2, 9, 100);
INSERT INTO Estacion_has_Partes(2, 10, 150);

INSERT INTO Estacion_has_Partes(3, 1, 5);
INSERT INTO Estacion_has_Partes(3, 2, 5);
INSERT INTO Estacion_has_Partes(3, 3, 50);
INSERT INTO Estacion_has_Partes(3, 4, 10);
INSERT INTO Estacion_has_Partes(3, 5, 20);
INSERT INTO Estacion_has_Partes(3, 6, 1000);
INSERT INTO Estacion_has_Partes(3, 7, 20);
INSERT INTO Estacion_has_Partes(3, 8, 200);
INSERT INTO Estacion_has_Partes(3, 9, 100);
INSERT INTO Estacion_has_Partes(3, 10, 150);

INSERT INTO Estacion_has_Partes(4, 1, 5);
INSERT INTO Estacion_has_Partes(4, 2, 5);
INSERT INTO Estacion_has_Partes(4, 3, 50);
INSERT INTO Estacion_has_Partes(4, 4, 10);
INSERT INTO Estacion_has_Partes(4, 5, 20);
INSERT INTO Estacion_has_Partes(4, 6, 1000);
INSERT INTO Estacion_has_Partes(4, 7, 20);
INSERT INTO Estacion_has_Partes(4, 8, 200);
INSERT INTO Estacion_has_Partes(4, 9, 100);
INSERT INTO Estacion_has_Partes(4, 10, 150);3