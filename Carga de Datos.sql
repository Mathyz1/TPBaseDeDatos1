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
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (1, "motor", 10, 1); -- motor, caño de escape
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (2, "carrocería", 100, 1); -- ruedas, volantes, airbag, cableado(m), frenos
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (3, "pintura", 25, 1); -- pintura(ls)
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (4, "ensamblado final", 60, 1); -- asiento, vidrio

INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (1, "motor", 10, 2); -- motor, caño de escape
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (2, "carrocería", 100, 2); -- ruedas, volantes, airbag, cableado(m), frenos
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (3, "pintura", 25, 2); -- pintura(ls)
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (4, "ensamblado final", 60, 2); -- asiento, vidrio

INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (1, "motor", 10, 3); -- motor, caño de escape
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (2, "carrocería", 100, 3); -- ruedas, volantes, airbag, cableado(m), frenos
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (3, "pintura", 25, 3); -- pintura(ls)
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (4, "ensamblado final", 60, 3); -- asiento, vidrio

INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (1, "motor", 10, 4); -- motor, caño de escape
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (2, "carrocería", 100, 4); -- ruedas, volantes, airbag, cableado(m), frenos
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (3, "pintura", 25, 4); -- pintura(ls)
INSERT INTO Estacion(orden, nombre, stock, idLineaDeMontaje) VALUES (4, "ensamblado final", 60, 4); -- asiento, vidrio

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

/*AGREGAMOS LO QUE NECESITA CADA VEHICULO */
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (1, 1, 1);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (1, 2, 1);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (1, 3, 4);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (1, 4, 1);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (1, 5, 2);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (1, 6, 40); -- 40 m
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (1, 7, 2);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (1, 8, 5); -- 5 lts
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (1, 9, 3);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (1, 10, 6);

INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (2, 1, 1);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (2, 2, 1);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (2, 3, 5);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (2, 4, 1);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (2, 5, 2);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (2, 6, 30); -- 30 m
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (2, 7, 2);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (2, 8, 5); -- 5 lts
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (2, 9, 2);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (2, 10, 4);

INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (3, 1, 1);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (3, 2, 1);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (3, 3, 4);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (3, 4, 1);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (3, 5, 2);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (3, 6, 50); -- 50 m
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (3, 7, 2);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (3, 8, 5); -- 5 lts
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (3, 9, 3);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (3, 10, 8);

INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (4, 1, 1);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (4, 2, 1);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (4, 3, 4);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (4, 4, 1);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (4, 5, 2);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (4, 6, 50); -- 50 m
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (4, 7, 2);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (4, 8, 5); -- 5 lts
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (4, 9, 3);
INSERT INTO DetalleModelo(idModelo, idPartes, cantidad) VALUES (4, 10, 8);

/* INSERTAMOS LA CANTIDAD TOTAL A CADA ESTACCÓN*/
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (1, 1, 5);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (1, 2, 5);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (1, 3, 50);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (1, 4, 10);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (1, 5, 20);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (1, 6, 1000);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (1, 7, 20);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (1, 8, 200);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (1, 9, 100);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (1, 10, 150);

INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (2, 1, 5);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (2, 2, 5);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (2, 3, 50);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (2, 4, 10);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (2, 5, 20);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (2, 6, 1000);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (2, 7, 20);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (2, 8, 200);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (2, 9, 100);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (2, 10, 150);

INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (3, 1, 5);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (3, 2, 5);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (3, 3, 50);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (3, 4, 10);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (3, 5, 20);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (3, 6, 1000);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (3, 7, 20);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (3, 8, 200);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (3, 9, 100);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (3, 10, 150);

INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (4, 1, 5);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (4, 2, 5);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (4, 3, 50);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (4, 4, 10);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (4, 5, 20);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (4, 6, 1000);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (4, 7, 20);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (4, 8, 200);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (4, 9, 100);
INSERT INTO Estacion_has_Partes(idEstacion, idPartes, cantidad) VALUES (4, 10, 150);