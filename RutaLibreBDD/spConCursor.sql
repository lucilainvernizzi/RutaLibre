/* =========================================================
   SP CON CURSOR: sp_InactivarVehiculosPorMantenimiento
   - Recorre vehículos con estado = "Fuera de Servicio"
   - Cambia su estado a "Inactivo".
   - Anula reservas pendientes que involucren ese vehículo.
========================================================= */
CREATE OR ALTER PROCEDURE dbo.sp_InactivarVehiculosPorMantenimiento
AS
BEGIN
    
    -- Variable para ir trayendo la patente actual desde el cursor
    DECLARE @patente VARCHAR(10);
    
    -- Cursor que selecciona todas las patentes de vehículos que están "Fuera de Servicio"
    DECLARE cursorInactivo CURSOR FOR
        SELECT patenteVehiculo
        FROM Vehiculo
        WHERE estadoOperativo = 'Fuera de Servicio';

    OPEN cursorInactivo; -- Abrimos el cursor y traemos la primera patente
    FETCH NEXT FROM cursorInactivo INTO @patente;

    WHILE @@FETCH_STATUS = 0 -- se ejecuta mientras haya filas que procesar 
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
        FETCH NEXT FROM cursorInactivo INTO @patente; -- Traer la siguiente patente del cursor
    END

    CLOSE cursorInactivo -- Cerrar cursor
    DEALLOCATE cursorInactivo; -- Desalojar cursor (libera recursos)
END
GO

/* =========================================================
     PRUEBA DEL SP CON CURSOR
   - Inactivar vehículos en mantenimiento y anular reservas
========================================================= */

-- Cambiar vehículo a "Fuera de Servicio"
UPDATE Vehiculo SET estadoOperativo = 'Fuera de Servicio' WHERE patenteVehiculo = 'ABC003';

-- Mostrar ANTES
SELECT 'ANTES' AS momento, patenteVehiculo, estadoOperativo
FROM dbo.Vehiculo
WHERE patenteVehiculo = 'ABC003';

SELECT 'ANTES' AS momento, r.idReserva, r.estadoReserva
FROM dbo.Reserva r
WHERE EXISTS (
    SELECT 1
    FROM dbo.DetalleReserva dr
    WHERE dr.idReserva = r.idReserva
      AND dr.patenteVehiculo = 'ABC003'
);
GO
-- Ejecutar cursor
EXEC sp_InactivarVehiculosPorMantenimiento;
GO

-- Verificar estado operativo de los vehículos (verás 'Inactivo' para 'ABC003')
SELECT 'DESPUES' AS momento, patenteVehiculo, estadoOperativo
FROM dbo.Vehiculo
WHERE patenteVehiculo = 'ABC003';

-- Verificar reservas que hayan quedado anuladas por involucrar a 'ABC003' y estar 'Pendiente'
SELECT 'DESPUES' AS momento, r.idReserva, r.estadoReserva
FROM dbo.Reserva r
WHERE EXISTS (
    SELECT 1
    FROM dbo.DetalleReserva dr
    WHERE dr.idReserva = r.idReserva
      AND dr.patenteVehiculo = 'ABC003'
);
GO