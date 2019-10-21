USE TerminalAutomotriz;

/* ABM CONCESIONARIA */
-- Damos de alta 2 concesionarias
CALL altaConcesionaria('1234567890', 'Ford1', @res, @msg);
CALL altaConcesionaria('1234567891', 'Ford2', @res, @msg);
-- Modificamos el nombre de una concesionaria
CALL modificacionConcesionaria('1234567890', "FordNuevo", @res, @msg);
-- Baja lógica de una concesionaria
CALL bajaConcesionaria('1234567891', @res, @msg);
CALL bajaConcesionaria('1234567890', @res, @msg);

/* ABM PEDIDOS */
-- Damos de alta 3 pedidos para una concesionaria
CALL altaPedido('1234567890', @idP, @res, @msg);
CALL modificacionPedido(2, '1234567891', "2020-01-01", @res, @msg);
CALL bajaPedido(5, @res, @msg);
SET @id := @idP; -- Para obtener el último pedido agregado
CALL altaDetallePedido('Ranger', 15, @id, @res, @msg);
CALL altaDetallePedido('KA', 10, @id, @res, @msg);
CALL altaDetallePedido('Focus', 35, @id, @res, @msg);
-- Modificación de los detalles de los pedidos
CALL modificacionDetallePedido(1, 'Focus', 10, @res, @msg);
CALL modificacionDetallePedido(2, 'Ranger', 40, @res, @msg);
-- Damos de baja algunos pedidos
CALL bajaDetallePedido(3, @res, @msg);
CALL bajaDetallePedido(4, @res, @msg);


SELECT @id;

-- Testing
SELECT * FROM Concesionaria;
SELECT * FROM Pedido;
SELECT * FROM DetallePedido;
SELECT * FROM Modelo;
SELECT * FROM Vehiculo;

