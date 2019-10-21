use TerminalAutomotriz;

insert into Modelo(descripcion) values ("KA");
insert into Modelo(descripcion) values ("Ranger");
insert into Modelo(descripcion) values ("Focus");
insert into Modelo(descripcion) values ("Fiesta");

insert into LineaDeMontaje(Modelo_idModelo) values (1);
insert into LineaDeMontaje(Modelo_idModelo) values (2);
insert into LineaDeMontaje(Modelo_idModelo) values (3);
insert into LineaDeMontaje(Modelo_idModelo) values (4);

/* idEstacion, orden, descripcion, stock, LineaDeMontaje_idLineaDeMontaje, LineaDeMontaje_Modelo_idModelo
STOCK ES UN VARCHAR ACA*/
insert into Estacion(orden, descripcion, stock, LineaDeMontaje_idLineaDeMontaje, LineaDeMontaje_Modelo_idModelo) values (1, "ensamblado chasis", "1", 1, 1);
insert into Estacion(orden, descripcion, stock, LineaDeMontaje_idLineaDeMontaje, LineaDeMontaje_Modelo_idModelo) values (2, "cableado", "2", 1, 1);
insert into Estacion(orden, descripcion, stock, LineaDeMontaje_idLineaDeMontaje, LineaDeMontaje_Modelo_idModelo) values (3, "pintura", "2", 1, 1);
insert into Estacion(orden, descripcion, stock, LineaDeMontaje_idLineaDeMontaje, LineaDeMontaje_Modelo_idModelo) values (4, "colocacion ruedas y ventanas", "2", 1, 1);

insert into Estacion(orden, descripcion, stock, LineaDeMontaje_idLineaDeMontaje, LineaDeMontaje_Modelo_idModelo) values (1, "", "1", 2, 2);
insert into Estacion(orden, descripcion, stock, LineaDeMontaje_idLineaDeMontaje, LineaDeMontaje_Modelo_idModelo) values (2, "", "2", 2, 2);

/*partes porque tiene lo de baja logica si no tiene abm*/
insert into Partes(descripcion) values ("neumatico");
insert into Partes(descripcion) values ("frenos");
insert into Partes(descripcion) values ("volante");
insert into Partes(descripcion) values ("caño de escape");

/*hay que hacer cambios en la base*/
