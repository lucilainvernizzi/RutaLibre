USE RutaLibreRentACar;
GO

/* =========================================================
   TRIGGER: TR_ValidarDuplicadoReserva
   Evita que un cliente reserve el mismo vehículo en la
   misma fecha de retiro más de una vez.
   Cubre:
   - Duplicados contra reservas ya existentes.
   - Duplicados dentro del mismo batch de INSERT.
   Dispara: AFTER INSERT en DetalleReserva.
========================================================= */
CREATE OR ALTER TRIGGER dbo.TR_ValidarDuplicadoReserva
ON dbo.DetalleReserva
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1) Duplicados contra datos YA existentes (otra reserva distinta)
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Reserva r_new
          ON r_new.idReserva = i.idReserva
        JOIN DetalleReserva d_old
          ON 1 = 1
        JOIN Reserva r_old
          ON r_old.idReserva = d_old.idReserva
        WHERE
            r_old.estadoReserva IN ('Pendiente','Confirmada')
            AND r_new.estadoReserva IN ('Pendiente','Confirmada')
            AND r_old.idReserva <> r_new.idReserva
            AND r_old.idCliente = r_new.idCliente
            AND r_old.fechaRetiro = r_new.fechaRetiro
            AND d_old.patenteVehiculo = i.patenteVehiculo
    )
    BEGIN
        RAISERROR('Error: ya existe una reserva para este cliente, vehículo y fecha de retiro.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- 2) Duplicados dentro del mismo INSERT (batch) sobre la misma reserva/cliente/fecha/vehículo
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Reserva r ON r.idReserva = i.idReserva
        GROUP BY r.idCliente, r.fechaRetiro, i.patenteVehiculo
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR('Error: inserción duplicada dentro del mismo lote para cliente, vehículo y fecha de retiro.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO


/* =========================================================
   SP CON CURSOR: sp_InactivarVehiculosPorMantenimiento
   Recorre vehículos "Fuera de Servicio" y:
   - Los pasa a "Inactivo".
   - Anula reservas PENDIENTES que involucren ese vehículo.
========================================================= */
CREATE OR ALTER PROCEDURE dbo.sp_InactivarVehiculosPorMantenimiento
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @patente VARCHAR(10);

    DECLARE cur CURSOR FAST_FORWARD FOR
        SELECT patenteVehiculo
        FROM Vehiculo
        WHERE estadoOperativo = 'Fuera de Servicio';

    OPEN cur;
    FETCH NEXT FROM cur INTO @patente;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Anular reservas pendientes que incluyan este vehículo
        UPDATE r
        SET r.estadoReserva = 'Anulada'
        FROM Reserva r
        WHERE r.estadoReserva = 'Pendiente'
          AND EXISTS (
                SELECT 1
                FROM DetalleReserva dr
                WHERE dr.idReserva = r.idReserva
                  AND dr.patenteVehiculo = @patente
          );

        -- Marcar el vehículo como Inactivo
        UPDATE Vehiculo
        SET estadoOperativo = 'Inactivo'
        WHERE patenteVehiculo = @patente;

        PRINT CONCAT('Vehículo ', @patente, ' inactivado y reservas pendientes asociadas anuladas.');
        FETCH NEXT FROM cur INTO @patente;
    END

    CLOSE cur;
    DEALLOCATE cur;
END
GO
