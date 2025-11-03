/* =========================================================
   TRIGGER: TR_ValidarDuplicadoReserva
   Evita que un cliente reserve el mismo vehículo en la
   misma fecha de retiro más de una vez.
   Cubre:
   - Duplicados contra reservas ya existentes.
   - Duplicados dentro del mismo INSERT.
========================================================= */
CREATE OR ALTER TRIGGER dbo.TR_ValidarDuplicadoReserva
ON dbo.DetalleReserva
INSTEAD OF INSERT
AS
BEGIN

    -- 1) Duplicado contra reservas existentes
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Reserva r_new ON r_new.idReserva = i.idReserva
        JOIN DetalleReserva d_old ON d_old.patenteVehiculo = i.patenteVehiculo
        JOIN Reserva r_old ON r_old.idReserva = d_old.idReserva
        WHERE
            r_old.estadoReserva IN ('Pendiente','Confirmada')
            AND r_new.estadoReserva IN ('Pendiente','Confirmada')
            AND r_old.idCliente = r_new.idCliente
            AND r_old.fechaRetiro = r_new.fechaRetiro
            AND d_old.patenteVehiculo = i.patenteVehiculo
    )
    BEGIN
        INSERT INTO Alerta (idReserva, tipoAlerta, descripcion, idVehiculo)
        SELECT DISTINCT 
               i.idReserva, 
               'Repetición',
               CONCAT('Intento de reserva duplicada para cliente ', r_new.idCliente,
                      ' y vehículo ', i.patenteVehiculo,
                      ' en fecha ', CONVERT(VARCHAR(10), r_new.fechaRetiro, 103)),
               i.patenteVehiculo
        FROM inserted i
        JOIN Reserva r_new ON r_new.idReserva = i.idReserva;

        RAISERROR('Reserva bloqueada: duplicación detectada y registrada en alertas.', 10, 1);
        RETURN; -- no inserta nada
    END;

    -- 2) Duplicado interno en el mismo lote (misma reserva y mismo vehículo)
    IF EXISTS (
        SELECT 1
        FROM inserted i
        GROUP BY i.idReserva, i.patenteVehiculo
        HAVING COUNT(*) > 1
    )
    BEGIN
        INSERT INTO Alerta (idReserva, tipoAlerta, descripcion, idVehiculo)
        SELECT DISTINCT
               i.idReserva,
               'Repetición',
               CONCAT('Duplicado interno en el mismo lote para reserva ', i.idReserva,
                      ' y vehículo ', i.patenteVehiculo),
               i.patenteVehiculo
        FROM inserted i;

        RAISERROR('Reserva bloqueada: duplicado interno del mismo lote.', 10, 1);
        RETURN;
    END;

    -- 3) Si no hay duplicado, permitir la inserción
    INSERT INTO DetalleReserva (idReserva, patenteVehiculo, precioPorDia, cantidadDias, subtotalDetalle)
    SELECT idReserva, patenteVehiculo, precioPorDia, cantidadDias, subtotalDetalle
    FROM inserted;
END;
GO