USE TerminalAutomotriz;

/* ABM CONCESIONARIA */
-- Damos de alta 2 concesionarias
CALL altaConcesionaria('1234567890', 'Ford1', @res, @msg);
CALL altaConcesionaria('1234567891', 'Ford2', @res, @msg);
CALL altaConcesionaria('1234567892', 'Ford3', @res, @msg);
CALL altaConcesionaria('1234567893', 'Ford4', @res, @msg);
-- Modificamos el nombre de una concesionaria
CALL modificacionConcesionaria('1234567890', '1234567899', "FordNuevo", @res, @msg);
-- Baja lógica de una concesionaria
CALL bajaConcesionaria('1234567891', @res, @msg);
CALL bajaConcesionaria('1234567890', @res, @msg);

/* ABM PEDIDOS */
-- Damos de alta 3 pedidos para una concesionaria
CALL altaPedido('1234567890', @res, @msg);
CALL altaPedido('1234567890', @res, @msg);
CALL altaPedido('1234567891', @res, @msg);
CALL altaPedido('1234567891', @res, @msg);
CALL modificacionPedido(1, '1234567891', @res, @msg);
CALL bajaPedido(3, @res, @msg);
CALL altaDetallePedido('KA', 10, 1, @res, @msg);
CALL altaDetallePedido('Ranger', 15, 2, @res, @msg);
CALL altaDetallePedido('Focus', 35, 2, @res, @msg); -- VeRIFICAR
CALL altaDetallePedido('Fiesta', 35, 4, @res, @msg);
-- Modificación de los detalles de los pedidos
CALL modificacionDetallePedido(1, 'Focus', 10, @res, @msg);
CALL modificacionDetallePedido(2, 'KA', 40, @res, @msg);
-- Damos de baja algunos pedidos
CALL bajaDetallePedido(3, @res, @msg);
CALL bajaDetallePedido(4, @res, @msg);

/* ABM PROVEEDOR */
-- Damos de alta 3 proveedores
CALL altaProveedor("1234567891", "Empresa1", @res, @msg);
CALL altaProveedor("1234567892", "Empresa2", @res, @msg);
CALL altaProveedor("1234567893", "Empresa3", @res, @msg);
-- Modificación
CALL modificacionProveedor("1234567891", "1000567893", "EmpresaNueva1", @res, @msg);
-- Baja
CALL bajaProveedor("1234567893", @res, @msg);

/* ABM PARTES */
-- Damos de alta las partes
CALL altaPartes("motor", @res, @msg);
CALL altaPartes("neumáticos", @res, @msg);
CALL altaPartes("frenos", @res, @msg);
CALL altaPartes("volante", @res, @msg);
CALL altaPartes("caño de escape", @res, @msg);
CALL altaPartes("cableado", @res, @msg);
CALL altaPartes("airbag", @res, @msg);
-- Modificación
CALL modificacionPartes(6, "cablerío", @res, @msg);
CALL modificacionPartes(1, "turbo", @res, @msg);
-- Baja
CALL bajaPartes(7, @res, @msg);

-- Testing
SELECT * FROM RegistroEstacion;
SELECT * FROM RegistroLinea;
SELECT * FROM LineaDeMontaje;
SELECT * FROM Concesionaria;
SELECT * FROM Pedido;
SELECT * FROM DetallePedido;
SELECT * FROM Modelo;
SELECT * FROM Vehiculo;
SELECT * FROM Proveedor;
SELECT * FROM Partes;

