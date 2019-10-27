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
CREATE PROCEDURE modificacionConcesionaria(cuitP VARCHAR(45), razonSocialP VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE recv_cuit VARCHAR(45);
    SELECT C.cuit INTO recv_cuit
    FROM Concesionaria AS C 
    WHERE C.cuit = cuitP;
    
    IF (recv_cuit IS NOT NULL) THEN
        UPDATE Concesionaria AS C SET C.razonSocial=razonSocialP WHERE C.cuit = cuitP;
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


DROP PROCEDURE IF EXISTS bajaConcesionaria;
DELIMITER //
CREATE PROCEDURE bajaConcesionaria(cuitP VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE recv_cuit VARCHAR(45);
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
CREATE PROCEDURE altaPedido(Concesionaria_cuit VARCHAR(45), OUT idP INT(11), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_C INT(11);
    DECLARE ultimo_pedido INT(11) DEFAULT NULL;
    SELECT idConcesionaria INTO key_id_C
    FROM Concesionaria 
    WHERE Concesionaria.cuit = Concesionaria_cuit;

    IF (key_id_C IS NOT NULL) THEN
        INSERT INTO Pedido (idConcesionaria, fecha) VALUES (key_id_C, now());
        SET ultimo_pedido = LAST_INSERT_ID();
    ELSE
        SET res = -1;
        SET msg = 'No existe Concesionaria';
        SELECT res, msg;
    END IF;

    SET idP = ultimo_pedido;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS modificacionPedido;
DELIMITER //
CREATE PROCEDURE modificacionPedido(idPedido INT, Concesionaria_cuit VARCHAR(45), fecha_nueva DATE, OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_C INT(11);
    DECLARE key_id_P INT(11);
    -- Para verificar que existe la concesionaria que queremos cambiar
    SELECT idConcesionaria INTO key_id_C
    FROM Concesionaria AS C
    WHERE C.cuit = Concesionaria_cuit;
    -- Para verificar que existe el pedido
    SELECT P.idPedido INTO key_id_P
    FROM Pedido AS P
    WHERE P.idPedido = idPedido;
    
    IF (key_id_P IS NOT NULL AND key_id_C IS NOT NULL) THEN
        UPDATE Pedido AS P SET idConcesionaria=key_id_C, fecha=fecha_nueva WHERE P.idPedido = idPedido;
    ELSE if(key_id_C IS NULL) THEN
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
CREATE PROCEDURE altaDetallePedido(modelo VARCHAR(45), cantidad INT(11), INOUT id INT(11), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_M INT(11);
    DECLARE ultimo_detalle INT(11);
    SELECT idModelo INTO key_id_M
    FROM Modelo AS M
    WHERE M.descripcion = modelo;

    IF (key_id_M IS NOT NULL) THEN
        INSERT INTO DetallePedido(Pedido_idPedido, Modelo_idModelo, cantidad) VALUES (id, key_id_M, cantidad);
        SET ultimo_detalle = LAST_INSERT_ID();
        CALL altaVehiculo(key_id_M, ultimo_detalle, id);
        SET res = 0;
        SET msg = '';
    ELSE
        SET res = -1;
        SET msg = 'No existe modelo';
        SELECT res, msg;
    END IF;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS modificacionDetallePedido;
DELIMITER //
CREATE PROCEDURE modificacionDetallePedido(idDetallePedido INT(11), modelo VARCHAR(45), cantidad INT(11), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_M INT(11);
    DECLARE key_id_DP INT(11);
    DECLARE replModelo INT(11);
    DECLARE replCantidad INT(11);
    
    SELECT idModelo INTO key_id_M
    FROM Modelo AS M
    WHERE M.descripcion = modelo;
    
    SELECT DP.idDetallePedido INTO key_id_DP
    FROM DetallePedido AS DP 
    WHERE DP.idDetallePedido = idDetallePedido;
    
     -- Para ver si son repetidos los valores
    SELECT DP.Modelo_idModelo INTO replModelo
    FROM DetallePedido AS DP
    WHERE DP.idDetallePedido = idDetallePedido;
    
    SELECT DP.cantidad INTO replCantidad
    FROM DetallePedido AS DP 
    WHERE DP.idDetallePedido = idDetallePedido;

    IF (key_id_DP IS NOT NULL AND key_id_M IS NOT NULL) THEN
        set foreign_key_checks=0;
        IF (replModelo IS NULL AND replCantidad IS NULL) THEN
            UPDATE DetallePedido AS DP SET DP.Modelo_idModelo=key_id_M, DP.cantidad=cantidad WHERE DP.idDetallePedido = idDetallePedido;
        ELSE IF  (replModelo IS not NULL) THEN
                UPDATE DetallePedido AS DP SET DP.cantidad=cantidad WHERE DP.idDetallePedido = idDetallePedido;
            ELSE
                UPDATE DetallePedido AS DP SET DP.Modelo_idModelo=key_id_M WHERE DP.idDetallePedido = idDetallePedido;
            END IF;
        END IF;
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
    SELECT DP.idDetallePedido INTO key_id_DP
    FROM DetallePedido AS DP
    WHERE DP.idDetallePedido = idDetallePedido;
    
    IF (key_id_DP IS NOT NULL) THEN
        UPDATE DetallePedido AS DP SET eliminado=1, fechaEliminado=now() WHERE DP.idDetallePedido = idDetallePedido;
        SET res = 0;
        SET msg = '';
    ELSE
        SET res = -1;
        SET msg = 'No existe Detalle del Pedido';
        SELECT res, msg;
    END IF;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS altaVehiculo;
DELIMITER //
CREATE PROCEDURE altaVehiculo(idModelo INT(11), ultimo_detalle INT(11), INOUT id INT(11))
BEGIN
    DECLARE idModeloParametro INTEGER;
    DECLARE modelo VARCHAR(45);
    DECLARE nCantidadDetalle INT;
    DECLARE nInsertados INT;
    DECLARE finished INT DEFAULT 0;
    DECLARE curDetallePedido
        CURSOR FOR
            SELECT Modelo_idModelo, cantidad FROM DetallePedido WHERE idDetallePedido = ultimo_detalle;
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;
    OPEN curDetallePedido;
    
    -- Obtenemos el modelo
    SELECT descripcion INTO modelo
    FROM Modelo
    WHERE Modelo.idModelo = idModelo;
    
    getDetalle: LOOP
        FETCH curDetallePedido INTO idModeloParametro, nCantidadDetalle;
        IF finished = 1 THEN
            LEAVE getDetalle;
        END IF;
        
        SET nInsertados = 0;
        WHILE nInsertados < nCantidadDetalle DO
            INSERT INTO Vehiculo(DetallePedido_idDetallePedido, DetallePedido_Modelo_idModelo, DetallePedido_Pedido_idPedido, descripcion) 
                VALUES (ultimo_detalle, idModeloParametro, id, modelo);
            SET nInsertados = nInsertados  + 1;
        END WHILE;
    END LOOP getDetalle;
    -- Elimino el cursor de memoria
    CLOSE curDetallePedido;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS diferencia;
DELIMITER //
CREATE PROCEDURE diferencia(idDetallePedido INT(11), cantidad INT(11), OUT dif INT)
BEGIN
    DECLARE valor INT(11);
    SELECT COUNT(DP.idDetallePedido) INTO valor
    FROM DetallePedido AS DP
    WHERE DP.idDetallePedido = idDetallePedido;
    
    set dif=cantidad-valor;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS modifNEGVehiculo;
DELIMITER //
CREATE PROCEDURE modifNEGVehiculo(idModelo INT(11), idDetallePedido INT(11), INOUT id INT(11))
BEGIN
    DECLARE idModeloParametro INTEGER;
    DECLARE modelo VARCHAR(45);
    DECLARE nCantidadDetalle INT;
    DECLARE nInsertados INT;
    DECLARE finished INT DEFAULT 0;
    DECLARE curDetallePedido
        CURSOR FOR
            SELECT Modelo_idModelo, cantidad FROM DetallePedido WHERE idDetallePedido = idDetallePedido;
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;
    OPEN curDetallePedido;
    
    -- Obtenemos el modelo
    SELECT descripcion INTO modelo
    FROM Modelo
    WHERE Modelo.idModelo = idModelo;
    
    getDetalle: LOOP
        FETCH curDetallePedido INTO idModeloParametro, nCantidadDetalle;
        IF finished = 1 THEN
            LEAVE getDetalle;
        END IF;
        
        SET nInsertados = 0;
        WHILE nInsertados < nCantidadDetalle DO
            INSERT INTO Vehiculo(DetallePedido_idDetallePedido, DetallePedido_Modelo_idModelo, DetallePedido_Pedido_idPedido, descripcion) 
                VALUES (ultimo_detalle, idModeloParametro, id, modelo);
            SET nInsertados = nInsertados  + 1;
        END WHILE;
    END LOOP getDetalle;
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
CREATE PROCEDURE altaProveedor(cuit VARCHAR(45), razonSocial VARCHAR(45), OUT res INT, OUT msg VARCHAR(45) )
BEGIN
    DECLARE recv_cuit VARCHAR(45);
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
    SELECT cuit INTO recv_cuit
    FROM Proveedor 
    WHERE Proveedor.cuit = cuitViejo;
    
    IF (recv_cuit IS NOT NULL) THEN
        UPDATE Proveedor AS P SET P.cuit=cuitNuevo, P.razonSocial=razonSocial WHERE P.cuit = cuitViejo;
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


DROP PROCEDURE IF EXISTS bajaProveedor;
DELIMITER //
CREATE PROCEDURE bajaProveedor(cuit VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE recv_cuit VARCHAR(45);
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
CREATE PROCEDURE altaPartes(descripcion VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_PRT INT(11);
    -- Para saber si existe ya una parte con el mismo nombre
    SELECT PRT.idPartes INTO key_id_PRT
    FROM Partes AS PRT
    WHERE PRT.descripcion = descripcion;

    IF (key_id_PRT IS NULL) THEN
        INSERT INTO Partes (descripcion) VALUES (descripcion);
    ELSE
        SET res = -1;
        SET msg = 'Ya existe Parte con ese nombre';
        SELECT res, msg;
    END IF;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS modificacionPartes;
DELIMITER //
CREATE PROCEDURE modificacionPartes(descripcionNuevo VARCHAR(45), descripcionViejo varchar(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_PRT INT(11);
    -- Para saber si existe ya una parte con el mismo nombre
    SELECT PRT.idPartes INTO key_id_PRT
    FROM Partes AS PRT
    WHERE PRT.descripcion = descripcionViejo;

    IF (key_id_PRT IS NOT NULL) THEN
        UPDATE Partes AS PRT SET PRT.descripcion=descripcionNuevo WHERE PRT.idPartes=key_id_PRT;
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
CREATE PROCEDURE bajaPartes(descripcion VARCHAR(45), OUT res INT, OUT msg VARCHAR(45))
BEGIN
    DECLARE key_id_PRT INT(11);
    -- Para saber si existe ya una parte con el mismo nombre
    SELECT PRT.idPartes INTO key_id_PRT
    FROM Partes AS PRT
    WHERE PRT.descripcion = descripcion;

    IF (key_id_PRT IS NOT NULL) THEN
        UPDATE Partes AS PRT SET eliminado=1, fechaEliminado=now() WHERE PRT.idPartes=key_id_PRT;
    ELSE
        SET res = -1;
        SET msg = 'No existe Parte';
        SELECT res, msg;
    END IF;
END
//
DELIMITER ;


