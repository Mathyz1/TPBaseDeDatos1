use TerminalAutomotriz;

insert into Modelo(nombre) values ("KA");
insert into Modelo(nombre) values ("Ranger");
insert into Modelo(nombre) values ("Focus");
insert into Modelo(nombre) values ("Fiesta");

insert into LineaDeMontaje(idModelo) values (1);
insert into LineaDeMontaje(idModelo) values (2);
insert into LineaDeMontaje(idModelo) values (3);
insert into LineaDeMontaje(idModelo) values (4);

insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (1, "motor", 1, 1);
insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (2, "carrocería", 2, 1);
insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (3, "pintura", 2, 1);
insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (4, "ensamblado final", 4, 1);

insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (1, "motor", 1, 2);
insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (2, "carrocería", 2, 2);
insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (3, "pintura", 2, 2);
insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (4, "ensamblado final", 2, 2);

insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (1, "motor", 1, 3);
insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (2, "carrocería", 2, 3);
insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (3, "pintura", 2, 3);
insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (4, "ensamblado final", 2, 3);

insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (1, "motor", 1, 4);
insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (2, "carrocería", 2, 4);
insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (3, "pintura", 2, 4);
insert into Estacion(orden, nombre, stock, idLineaDeMontaje) values (4, "ensamblado final", 2, 4);