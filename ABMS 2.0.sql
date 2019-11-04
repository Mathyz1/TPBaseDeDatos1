USE TerminalAutomotriz;

/*--------------------------------------------------------------------------------------------------------------------------------------------*/
/*----ABM CONCESIONARIA-----------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS altaConcesionaria;
DELIMITER //
CREATE PROCEDURE altaConcesionaria(cuit VARCHAR(45), razonSocial VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE recv_cuit VARCHAR(45);
    SELECT cuit INTO recv_cuit
    FROM Concesionaria 
    WHERE Concesionaria.cuit = cuit;
    
    IF (recv_cuit IS NULL) THEN
        INSERT INTO Concesionaria (cuit, razonSocial, eliminado, fechaEliminado) VALUES (cuit, razonSocial, 0, NULL);
        SET res = 0;
        SET msg = '';
    ELSE
        SET res = -1;
        SET msg = 'CUIT YA EXISTENTE';
    END IF;
    
    SELECT res, msg;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS modificacionConcesionaria;
DELIMITER //
CREATE PROCEDURE modificacionConcesionaria(cuitViejo VARCHAR(45), cuitNuevo VARCHAR(45), razonSocialP VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE recv_cuit VARCHAR(45);
    DECLARE recv_cuitNuevo VARCHAR(45);
    -- Para determinar si el cuit viejo existe en la BD
    SELECT C.cuit INTO recv_cuit
    FROM Concesionaria AS C 
    WHERE C.cuit = cuitViejo;
    -- Para determinar si el cuit nuevo existe en la BD y no haya dublicados
    SELECT C.cuit INTO recv_cuitNuevo
    FROM Concesionaria AS C 
    WHERE C.cuit = cuitNuevo;

    IF (recv_cuit IS NOT NULL AND recv_cuitNuevo IS NULL) THEN
        UPDATE Concesionaria AS C SET C.razonSocial=razonSocialP WHERE C.cuit = cuitViejo;
        SET res = 0;
        SET msg = '';
    ELSE IF (recv_cuit IS NULL) THEN
            SET res = -1;
            SET msg = 'CUIT NO EXISTENTE';
        ELSE
            SET res = -1;
            SET msg = 'Ya existe Concesionaria con ese CUIT';
        END IF;
    END IF;
    
    SELECT res, msg;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS bajaConcesionaria;
DELIMITER //
CREATE PROCEDURE bajaConcesionaria(cuitP VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE recv_cuit VARCHAR(45);
    -- Para determinar si el cuit existe en la BD
    SELECT cuit INTO recv_cuit
    FROM Concesionaria 
    WHERE Concesionaria.cuit = cuitP;
    
    IF (recv_cuit IS NOT NULL) THEN
        UPDATE Concesionaria AS C SET eliminado=1, fechaEliminado=now() WHERE C.cuit = cuitP;
        SET res = 0;
        SET msg = '';
    ELSE
        SET res = -1;
        SET msg = 'CUIT NO EXISTENTE';
    END IF;
    
    SELECT res, msg;
END
//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------*/
/*----ABM PEDIDO------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS altaPedido;
DELIMITER //
CREATE PROCEDURE altaPedido(Concesionaria_cuit VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE recv_cuit VARCHAR(45);
    -- Para determinar si el cuit existe en la BD
    SELECT cuit INTO recv_cuit
    FROM Concesionaria 
    WHERE Concesionaria.cuit = Concesionaria_cuit;

    IF (recv_cuit IS NOT NULL) THEN
        INSERT INTO Pedido (Concesionaria_cuit, fecha) VALUES (Concesionaria_cuit, now());
    ELSE
        SET res = -1;
        SET msg = 'No existe Concesionaria';
        SELECT res, msg;
    END IF;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS modificacionPedido;
DELIMITER //
CREATE PROCEDURE modificacionPedido(idPedido INT, Concesionaria_cuit VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE recv_cuit VARCHAR(45);
    DECLARE key_id_P INT(11);
    -- Para verificar que existe la concesionaria que queremos cambiar
    SELECT cuit INTO recv_cuit
    FROM Concesionaria AS C
    WHERE C.cuit = Concesionaria_cuit;
    -- Para verificar que existe el pedido
    SELECT P.idPedido INTO key_id_P
    FROM Pedido AS P
    WHERE P.idPedido = idPedido;
    
    IF (key_id_P IS NOT NULL AND recv_cuit IS NOT NULL) THEN
        UPDATE Pedido AS P SET P.Concesionaria_cuit=Concesionaria_cuit WHERE P.idPedido = idPedido;
    ELSE if(recv_cuit IS NULL) THEN
            SET res = -1;
            SET msg = 'No existe Concesionaria';
            SELECT res, msg;
        else
            SET res = -1;
            SET msg = 'No existe Pedido';
            SELECT res, msg;
        END IF;
    END IF;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS bajaPedido;
DELIMITER //
CREATE PROCEDURE bajaPedido(idPedido INT, OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_P INT(11);
    -- Para determinar si existe el Pedido
    SELECT P.idPedido INTO key_id_P
    FROM Pedido AS P
    WHERE P.idPedido = idPedido;
    IF (key_id_P IS NOT NULL) THEN
        UPDATE Pedido AS P SET eliminado=1, fechaEliminado=now() WHERE P.idPedido = idPedido;
    ELSE
        SET res = -1;
        SET msg = 'No existe Pedido';
        SELECT res, msg;
    END IF;
END
//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------*/
/*----ABM DETALLE PEDIDO(VEHICULO)------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS altaDetallePedido;
DELIMITER //
CREATE PROCEDURE altaDetallePedido(modelo VARCHAR(45), cantidad INT(11), idPedido INT(11), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_M INT(11);
    DECLARE key_id_P INT(11);
    DECLARE ultimo_detalle INT(11);
    -- Para verificar que exista dicho modelo
    SELECT idModelo INTO key_id_M
    FROM Modelo AS M
    WHERE M.nombre = modelo;
    -- Para prevenir ingresar un pedido inexistente
    SELECT idPedido INTO key_id_P
    FROM Pedido AS P
    WHERE P.idPedido = idPedido;

    IF (key_id_M IS NOT NULL AND key_id_P IS NOT NULL) THEN
        INSERT INTO DetallePedido(idPedido, idModelo, cantidad) VALUES (idPedido, key_id_M, cantidad);
        SET ultimo_detalle = LAST_INSERT_ID();
        CALL altaVehiculo(key_id_M, ultimo_detalle, idPedido);
        SET res = 0;
        SET msg = '';
    ELSE IF (key_id_P IS NULL) THEN
            SET res = -1;
            SET msg = CONCAT('No existe Pedido nro: ', idPedido);
            SELECT res, msg;
        ELSE
            SET res = -1;
            SET msg = CONCAT('No existe modelo ', modelo);
        END IF;
    END IF;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS modificacionDetallePedido;
DELIMITER //
CREATE PROCEDURE modificacionDetallePedido(idDetallePedido INT(11), modelo VARCHAR(45), cantidad INT(11), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    -- declaramos variables locales
    DECLARE key_id_M INT(11);
    DECLARE key_id_DP INT(11);
    DECLARE key_id_P INT(11);
    DECLARE deleted TINYINT(1);
    
    -- buscamos si el modelo existe en la tabla Modelo
    SELECT idModelo INTO key_id_M
    FROM Modelo AS M
    WHERE M.nombre = modelo;
    -- buscamos si el detallePedido existe en la tabla DetallePedido
    SELECT DP.idDetallePedido, DP.idPedido, DP.eliminado INTO key_id_DP, key_id_P, deleted
    FROM DetallePedido AS DP
    WHERE DP.idDetallePedido = idDetallePedido;

    IF (key_id_DP IS NOT NULL AND key_id_M IS NOT NULL AND deleted = 0) THEN
        SET FOREIGN_KEY_CHECKS = 0;
        UPDATE DetallePedido AS DP SET DP.idModelo=key_id_M, DP.cantidad=cantidad WHERE DP.idDetallePedido = idDetallePedido;
        CALL altaVehiculo(key_id_M, idDetallePedido, key_id_P); -- Para levantar los vehículos
        SET res = 0;
        SET msg = '';
    ELSE IF(key_id_DP IS NOT NULL) THEN
            SET res = -1;
            SET msg = 'No existe Detalle del Pedido';
        ELSE
            SET res = -1;
            SET msg = 'No existe Modelo';
        END IF;
    END IF;
    SELECT res, msg;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS bajaDetallePedido;
DELIMITER //
CREATE PROCEDURE bajaDetallePedido(idDetallePedido INT(11), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_DP INT(11);
    -- Para determinar si el detallePedido existe en la tabla DetallePedido
    SELECT DP.idDetallePedido INTO key_id_DP
    FROM DetallePedido AS DP
    WHERE DP.idDetallePedido = idDetallePedido;
    
    IF (key_id_DP IS NOT NULL) THEN
        UPDATE DetallePedido AS DP SET eliminado=1, fechaEliminado=now() WHERE DP.idDetallePedido = idDetallePedido;
        SET res = 0;
        SET msg = '';
    ELSE
        SET res = -1;
        SET msg = 'No existe Detalle Pedido con ese ID';
        SELECT res, msg;
    END IF;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS altaVehiculo;
DELIMITER //
CREATE PROCEDURE altaVehiculo(idModelo INT(11), ultimo_detalle INT(11), idPedido INT(11))
BEGIN
    DECLARE res INTEGER;
    DECLARE msg VARCHAR(60);
    DECLARE idModeloParametro INTEGER;
    DECLARE modif INTEGER;
    DECLARE modelo VARCHAR(45);
    DECLARE key_id_LM INT;
    DECLARE ultimo_vehiculo INT;
    DECLARE tempCantidad INT;
    DECLARE nCantidadDetalle INT;
    DECLARE nInsertados INT DEFAULT 0;
    DECLARE finished INT DEFAULT 0;
    DECLARE curDetallePedido
        CURSOR FOR
            SELECT idModelo, cantidad FROM DetallePedido WHERE idDetallePedido = ultimo_detalle;
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;
    OPEN curDetallePedido;
    
    -- Obtenemos el modelo
    SELECT nombre INTO modelo
    FROM Modelo
    WHERE Modelo.idModelo = idModelo;
    -- Obtenemos el Linea de montaje ID
    SELECT LM.idLineaDeMontaje INTO key_id_LM
    FROM LineaDeMontaje AS LM
    WHERE LM.idModelo = idModelo
    LIMIT 1;

    -- Obtener si hay vehiculos con ese detalle
    -- Es para no acumular Vehiculos cuando realizamos la modificación de Vehículos si previamente ya habían
    -- varios cargados. Si hay previos estos se borran y se agregan los nuevos.
    SELECT V.idDetallePedido INTO modif
    FROM Vehiculo AS V
    WHERE V.idDetallePedido = ultimo_detalle
    LIMIT 1;
    IF (modif IS NOT NULL) THEN
        DELETE FROM Vehiculo WHERE idDetallePedido = ultimo_detalle;
    END IF;
    
    -- Para saber si existe ese Detalle Pedido con los datos. En caso contrario devuelve NULL
    -- y no se realiza el Alta de vehículos
    SELECT cantidad INTO tempCantidad 
    FROM DetallePedido 
    WHERE idDetallePedido = ultimo_detalle;
    
    IF tempCantidad IS NOT NULL THEN
        SET nInsertados = 0;
        WHILE nInsertados < tempCantidad DO
            FETCH curDetallePedido INTO idModeloParametro, nCantidadDetalle;
            INSERT INTO Vehiculo(idDetallePedido, idModelo, idPedido) 
                VALUES (ultimo_detalle, idModeloParametro, idPedido); -- ARREGLAR DESCRIPCION
            SET ultimo_vehiculo = LAST_INSERT_ID();
            INSERT INTO RegistroLinea VALUES(ultimo_vehiculo, key_id_LM);
            SET nInsertados = nInsertados  + 1;
        END WHILE;
    ELSE
        SET res = -1;
        SET msg = 'No se pudo realizar el alta de vehiculos';
        SELECT -1, msg;
    END IF;

    -- Elimino el cursor de memoria
    CLOSE curDetallePedido;
END
//
DELIMITER ;


/*--------------------------------------------------------------------------------------------------------------------------------------------*/
/*----ABM PROVEEDOR---------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS altaProveedor;
DELIMITER //
CREATE PROCEDURE altaProveedor(cuit VARCHAR(45), razonSocial VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE recv_cuit VARCHAR(45);
    -- Para determinar que el cuit no exista en la tabla Proveedor
    SELECT cuit INTO recv_cuit
    FROM Proveedor 
    WHERE Proveedor.cuit = cuit;
    
    IF (recv_cuit IS NULL) THEN
        INSERT INTO Proveedor (cuit, razonSocial) VALUES(cuit, razonSocial);
        SET res = 0;
        SET msg = '';
    ELSE
        SET res = -1;
        SET msg = 'CUIT YA EXISTENTE';
    END IF;
    
    SELECT res, msg;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS modificacionProveedor;
DELIMITER //
CREATE PROCEDURE modificacionProveedor(cuitViejo VARCHAR(45), cuitNuevo VARCHAR(45), razonSocial VARCHAR(45), OUT res INT, OUT msg VARCHAR(45) )
BEGIN 
    DECLARE recv_cuit VARCHAR(45);
    DECLARE recv_cuitNuevo VARCHAR(45);
    -- Para determinar si el cuit viejo existe en la BD
    SELECT cuit INTO recv_cuit
    FROM Proveedor 
    WHERE Proveedor.cuit = cuitViejo;
    -- Para determinar si el cuit nuevo existe en la BD
    SELECT cuit INTO recv_cuitNuevo
    FROM Proveedor
    WHERE cuit = cuitNuevo;
    IF (recv_cuit IS NOT NULL AND recv_cuitNuevo IS NULL) THEN
        UPDATE Proveedor AS P SET P.cuit=cuitNuevo, P.razonSocial=razonSocial WHERE P.cuit = cuitViejo;
        SET res = 0;
        SET msg = '';
    ELSE IF(recv_cuit IS NULL) THEN
            SET res = -1;
            SET msg = 'CUIT NO EXISTENTE';
        ELSE
            SET res = -1;
            SET msg = 'CUIT YA EXISTENTE';
        END IF;
    END IF;
    
    SELECT res, msg; 
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS bajaProveedor;
DELIMITER //
CREATE PROCEDURE bajaProveedor(cuit VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE recv_cuit VARCHAR(45);
    -- Para determinar si el cuit existe en la BD
    SELECT cuit INTO recv_cuit
    FROM Proveedor
    WHERE Proveedor.cuit = cuit;
    
    IF (recv_cuit IS NOT NULL) THEN
        UPDATE Proveedor AS P SET P.eliminado=1, P.fechaEliminado=now() WHERE P.cuit = cuit;
        SET res = 0;
        SET msg = '';
    ELSE
        SET res = -1;
        SET msg = 'CUIT NO EXISTENTE';
    END IF;
    
    SELECT res, msg;
END
//
DELIMITER ;

/*--------------------------------------------------------------------------------------------------------------------------------------------*/
/*----ABM PARTES------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS altaPartes;
DELIMITER //
CREATE PROCEDURE altaPartes(nombreP VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_PRT INT(11);
    -- Para saber si existe ya una parte con el mismo nombre
    SELECT PRT.idPartes INTO key_id_PRT
    FROM Partes AS PRT
    WHERE MATCH(nombre) AGAINST(nombreP);

    IF (key_id_PRT IS NULL) THEN
        INSERT INTO Partes (nombre) VALUES (nombreP);
        SET res = 0;
        SET msg = '';
    ELSE
        SET res = -1;
        SET msg = 'Ya existe Parte con ese nombre';
    END IF;
    SELECT res, msg;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS modificacionPartes;
DELIMITER //
CREATE PROCEDURE modificacionPartes(idPartes INT(11), nombreNuevo VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_PRT INT(11);
    -- Para saber si existe ya una parte con el mismo nombre
    SELECT PRT.idPartes INTO key_id_PRT
    FROM Partes AS PRT
    WHERE PRT.idPartes = idPartes;

    IF (key_id_PRT IS NOT NULL) THEN
        UPDATE Partes AS PRT SET PRT.nombre=nombreNuevo WHERE PRT.idPartes=idPartes;
    ELSE
        SET res = -1;
        SET msg = 'No existe Parte para cambiar nombre';
        SELECT res, msg;
    END IF;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS bajaPartes;
DELIMITER //
CREATE PROCEDURE bajaPartes(idPartes INT(11), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_PRT INT(11);
    -- Para saber si existe ya una parte con el mismo nombre
    SELECT PRT.idPartes INTO key_id_PRT
    FROM Partes AS PRT
    WHERE PRT.idPartes = idPartes;

    IF (key_id_PRT IS NOT NULL) THEN
        UPDATE Partes AS PRT SET eliminado=1, fechaEliminado=now() WHERE PRT.idPartes=idPartes;
    ELSE
        SET res = -1;
        SET msg = 'No existe Parte';
        SELECT res, msg;
    END IF;
END
//
DELIMITER ;


/* --------------------------------------------
        RUTINAS DE LA PRODUCCIÓN DE VEHÍCULOS
   --------------------------------------------
*/
DROP PROCEDURE IF EXISTS inicioMontaje;
DELIMITER //
CREATE PROCEDURE inicioMontaje(numChasis INT(11), OUT res INT, OUT msg VARCHAR(80))
BEGIN
    DECLARE vehiculoEnProduccion INT(11);
    DECLARE terminado INT(11);
    DECLARE numChasis_id INT(11);
    DECLARE existeVehiculo INT(11);
    DECLARE key_id_DP INT(11);
    DECLARE key_id_E INT(11);
    DECLARE key_id_LM INT(11);
    DECLARE key_id_P INT(11);
    DECLARE key_id_M INT(11);

    -- Para saber si el vehículo está terminado
    SELECT V.terminado INTO terminado 
    FROM Vehiculo AS V
    WHERE V.numChasis = numChasis;
    -- Para saber si el vehículo está en producción
    SELECT RE.numChasis INTO vehiculoEnProduccion 
    FROM RegistroEstacion AS RE
    WHERE RE.numChasis = numChasis
    LIMIT 1;
    -- Para obtener id detalle pedido, pedido y modelo
    -- También para saber si existe un vehículo con ese número de chasis
    SELECT V.idDetallePedido, V.idPedido, V.idModelo, V.numChasis
        INTO key_id_DP , key_id_P , key_id_M, existeVehiculo
    FROM Vehiculo AS V USE INDEX (indice_vehiculo)
    WHERE V.numChasis = numChasis;
    -- Para obtener datos de Linea de montaje
    SELECT idLineaDeMontaje INTO key_id_LM
    FROM RegistroLinea AS RL
    WHERE RL.numChasis = numChasis;
    -- Para obtener datos de estación
    SELECT idEstacion INTO key_id_E 
    FROM Estacion AS E
    WHERE E.orden = 1 AND idLineaDeMontaje = key_id_LM;
    -- Para saber si hay un vehículo ocupando la estación
    SELECT RE.numChasis INTO numChasis_id
    FROM RegistroEstacion AS RE
    WHERE RE.fechayHoraEgreso IS NULL
        AND RE.idLineaDeMontaje = key_id_LM
        AND RE.idEstacion = key_id_E;

    IF (numChasis_id IS NULL AND vehiculoEnProduccion IS NULL AND existeVehiculo IS NOT NULL) THEN
        INSERT INTO RegistroEstacion(fechayHoraIngreso, numChasis, idEstacion, idLineaDeMontaje) 
            VALUES (now(), numChasis, key_id_E, key_id_LM);
        UPDATE Vehiculo V SET V.fechaInicio = now() WHERE V.numChasis = numChasis;
        SET res = 0;
        SET msg = CONCAT('Vehículo ', numChasis, ' en producción');
    ELSE IF(numChasis_id IS NOT NULL) THEN
            SET res = -1;
            SET msg = CONCAT('ERROR: Vehículo con num chasis ', numChasis_id, ' está actualmente ocupando la estación.');
        ELSE IF(terminado = 1) THEN
                SET res = -1;
                SET msg = "ERROR: El vehículo está terminado.";
            ELSE IF(vehiculoEnProduccion IS NOT NULL) THEN
                    SET res = -1;
                    SET msg = "ERROR: El vehículo se encuentra en producción.";
                ELSE
                    SET res = -1;
                    SET msg = "ERROR: Ese vehículo no existe.";
                END IF;
            END IF;
        END IF;
    END IF;
    SELECT res, msg;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS siguienteEstacion;
DELIMITER //
CREATE PROCEDURE siguienteEstacion(numChasis INT(11), OUT res INT, OUT msg VARCHAR(80))
BEGIN
    DECLARE vehiculoEnProduccion INT(11);
    DECLARE numChasis_id INT(11);
    DECLARE existeVehiculo INT(11);
    DECLARE cantidadEstaciones INT(11);
    DECLARE diff INT(11);
    DECLARE NumOrden INT(11);
    DECLARE key_id_DP INT(11);
    DECLARE key_id_E INT(11);
    DECLARE key_id_ENext INT(11);
    DECLARE key_id_LM INT(11);
    DECLARE key_id_P INT(11);
    DECLARE key_id_M INT(11);

    -- Para saber si existe un vehículo con ese número de chasis
    SELECT V.numChasis INTO existeVehiculo 
    FROM Vehiculo AS V
    WHERE V.numChasis = numChasis;
    -- Para saber si el vehículo está en producción
    SELECT RE.numChasis INTO vehiculoEnProduccion 
    FROM RegistroEstacion AS RE
    WHERE RE.numChasis = numChasis
    LIMIT 1;
    -- Para obtener id detalle pedido, pedido y modelo
    SELECT idDetallePedido, idPedido,idModelo
        INTO key_id_DP , key_id_P , key_id_M
    FROM Vehiculo AS V
    WHERE V.numChasis = numChasis;
    -- Para obtener datos de Linea de montaje
    SELECT idLineaDeMontaje INTO key_id_LM
    FROM RegistroLinea AS RL
    WHERE RL.numChasis = numChasis;
    -- Para obtener id Estacion
    SELECT idEstacion INTO key_id_E
    FROM RegistroEstacion AS RE
    WHERE RE.numChasis = numChasis AND RE.fechayHoraEgreso IS NULL;
    -- Para obtener el orden de estación
    SELECT orden INTO NumOrden 
    FROM Estacion AS E
    WHERE E.idEstacion = key_id_E;
    -- Para obtener la cantidad de estaciones de una Linea de montaje
    SELECT count(*) INTO cantidadEstaciones
    FROM Estacion AS E
    WHERE E.idLineaDeMontaje = key_id_LM;
    SET diff = cantidadEstaciones - NumOrden;
    IF (diff > 0) THEN
        SET NumOrden = NumOrden + 1;
        -- Para obtener la id de la siguiente estación
        SELECT idEstacion INTO key_id_ENext
            FROM Estacion AS E
            WHERE E.orden = NumOrden AND E.idLineaDeMontaje = key_id_LM;
        -- Para saber si hay un vehículo ocupando la estación
        SELECT RE.numChasis INTO numChasis_id
        FROM RegistroEstacion AS RE
        WHERE RE.fechayHoraEgreso IS NULL
            AND RE.idLineaDeMontaje = key_id_LM
            AND RE.idEstacion = key_id_ENext;
    END IF;
    IF (numChasis_id IS NULL AND vehiculoEnProduccion IS NOT NULL AND existeVehiculo IS NOT NULL) THEN
        UPDATE RegistroEstacion AS RE SET fechayHoraEgreso=now() WHERE RE.numChasis = numChasis AND idEstacion = key_id_E;
        IF (diff > 0) THEN
            INSERT INTO RegistroEstacion(fechayHoraIngreso, numChasis, idEstacion, idLineaDeMontaje) 
                VALUES (now(), numChasis, key_id_ENext, key_id_LM);
            SET res = 0;
            SET msg = CONCAT('Vehículo ', numChasis, ' en estación ', NumOrden);
        ELSE IF (diff = 0) THEN
                UPDATE Vehiculo AS V SET fechaFinalizacion=now(), terminado=1 WHERE V.numChasis = numChasis;
                SET res = 0;
                SET msg = CONCAT('Vehículo ', numChasis, ' finalizado');
            ELSE
                SET res = -1;
                SET msg = "ERROR: El vehículo ya no está en producción";
            END IF;
        END IF;
    ELSE IF(numChasis_id IS NOT NULL) THEN
            SET res = -1;
            SET msg = CONCAT('ERROR: Vehículo con num chasis ', numChasis_id, ' está actualmente ocupando la estación.');
        ELSE IF(vehiculoEnProduccion IS NULL) THEN
                SET res = -1;
                SET msg = "ERROR: El vehículo no se encuentra en producción.";
            ELSE
                SET res = -1;
                SET msg = "ERROR: Ese vehículo no existe.";
            END IF;
        END IF;
    END IF;
    SELECT res, msg;
END
//
DELIMITER ;


/* --------------------------------------------
        REPORTES
   --------------------------------------------
*/
/*
    Muestra el estado en el que se encuentra cada vehículo para un pedido dado.
*/
DROP PROCEDURE IF EXISTS listarVehiculo;
DELIMITER //
CREATE PROCEDURE listarVehiculo(idPedido INT(11), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE fechaFinalizado DATE;
    DECLARE idE INT;
    DECLARE contador INT;
    DECLARE fecha DATE;
    DECLARE tempNChasis INT; -- numChasis
    DECLARE key_id_E INT default null;
    DECLARE estado VARCHAR(45) default "";
    DECLARE finished INT DEFAULT 0;
    
    -- Uso de cursor con índice para vehículo
    DECLARE curVehiculo CURSOR FOR SELECT V.numChasis, V.fechaFinalizacion, max(RE.idEstacion) FROM Vehiculo V
        USE INDEX (indice_vehiculo) LEFT JOIN RegistroEstacion RE ON V.numChasis=RE.numChasis 
        WHERE V.idPedido = idPedido GROUP BY V.numChasis;
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;
    
    -- TABLA TEMPORAL
    CREATE TEMPORARY TABLE IF NOT EXISTS ReportPedidoVehiculo(
        idReport INTEGER NOT NULL AUTO_INCREMENT,
        numChasis INTEGER NOT NULL,
        estado VARCHAR(45) NOT NULL DEFAULT '',
        PRIMARY KEY (idReport)
    );
    
    OPEN curVehiculo;
    getVehiculo: LOOP
        FETCH curVehiculo INTO tempNChasis, fechaFinalizado, idE;
        IF finished = 1 THEN
           LEAVE getVehiculo;
        END IF;
        
        IF (fechaFinalizado IS NOT NULL) THEN
            SET estado = "Finalizado";
        ELSE IF(idE IS NOT NULL) THEN
                SET estado = CONCAT("En producción en estación: ", idE);
            ELSE
                SET estado = "No iniciado";
            END IF;
        END IF;
        
        INSERT INTO ReportPedidoVehiculo(numChasis, estado) VALUES(tempNChasis, estado);
    END LOOP getVehiculo;

    CLOSE curVehiculo;
    
    -- Mostramos la situación en la que se encuentra cada vehículo
    SELECT * FROM ReportPedidoVehiculo;
    DROP TEMPORARY TABLE ReportPedidoVehiculo;
END
//
DELIMITER ;


/*
    Lista la cantidad total de cada parte que se necesita 
    para que se realice un pedido dado.
*/
DROP PROCEDURE IF EXISTS listarPartes;
DELIMITER //
CREATE PROCEDURE listarPartes(idPedidoP INT, OUT res INT, OUT msg VARCHAR(80))
BEGIN
    DECLARE key_id_P INTEGER;
    -- Para determinar si el pedido existe
    SELECT DP.idPedido INTO key_id_P
    FROM DetallePedido AS DP
    WHERE DP.idPedido = idPedidoP
    LIMIT 1;
    IF (key_id_P IS NOT NULL) THEN
        SELECT DM.idPartes, sum(DM.cantidad * DP.cantidad) AS "Cantidad requerida"
        FROM DetalleModelo DM
        LEFT JOIN DetallePedido DP ON DM.idModelo=DP.idModelo 
        WHERE DP.idPedido = idPedidoP
        GROUP BY DM.idPartes;
    ELSE
        SET res = -1;
        SET msg = CONCAT("No existe pedido nro:", idPedidoP);
        SELECT res, msg;
    END IF;
END
//
DELIMITER ;


/*
    Muestra el promedio que le llevó a una linea de montaje realizar los autos.
    Solo toma en cuenta los vehículos terminados.
*/
DROP PROCEDURE IF EXISTS promedioLineaMontaje;
DELIMITER //
CREATE PROCEDURE promedioLineaMontaje(idLineaDeMontaje INT(11), OUT res INT, OUT msg VARCHAR(80))
BEGIN
    DECLARE promedioTiempo FLOAT DEFAULT NULL;
    -- Calculamos el promedio en segundos
    SELECT AVG(TIMEDIFF(fechaFinalizacion, fechaInicio)) INTO promedioTiempo
    FROM Vehiculo V USE INDEX (indice_vehiculo)
    WHERE V.fechaFinalizacion IS NOT NULL AND 
        V.numChasis IN (SELECT numChasis
                        FROM RegistroLinea RL
                        WHERE RL.idLineaDeMontaje = idLineaDeMontaje
        );
    IF (promedioTiempo IS NOT NULL) THEN
        SET res = 0;
        SET msg = CONCAT("El promedio de tiempo de la Línea de montaje es: ", SEC_TO_TIME(promedioTiempo));
    ELSE
        SET res = -1;
        SET msg = "El promedio de tiempo de la Línea de montaje no se pudo determinar";
    END IF;
    SELECT res, msg;
END
//
DELIMITER ;

