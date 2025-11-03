-- ==========================================
-- VISTA: vw_VehiculosDuplicados
-- Muestra reservas duplicadas por cliente,
-- vehículo y fecha de retiro.
-- ==========================================
CREATE OR ALTER VIEW dbo.vw_VehiculosDuplicados AS
SELECT
    r.idCliente,
    dr.patenteVehiculo,
    r.fechaRetiro,
    COUNT(*) AS cantidadDuplicados
FROM Reserva r
JOIN DetalleReserva dr 
    ON r.idReserva = dr.idReserva
GROUP BY r.idCliente, dr.patenteVehiculo, r.fechaRetiro
HAVING COUNT(*) > 1;
GO

/* =========================================================
    PRUEBA DE LA VISTA: vw_VehiculosDuplicados
   - Intentar registrar duplicado para probar detección
========================================================= */
-- Inserción duplicada (mismo cliente, mismo vehículo y fecha)
BEGIN TRY
    EXEC sp_RegistrarReservaConTarifa
        @idCliente = 1,
        @idSucursalRetiro = 1,
        @idSucursalDevolucion = 2,
        @fechaRetiro = '2025-11-10',
        @fechaDevolucion = '2025-11-15',
        @patenteVehiculo = 'ABC123';
END TRY
BEGIN CATCH
    PRINT 'Duplicado detectado correctamente.';
END CATCH;

-- Consulta para mostrar duplicados
SELECT * 
FROM dbo.vw_VehiculosDuplicados
ORDER BY idCliente, patenteVehiculo, fechaRetiro;

---Vista Alertas------
SELECT * FROM Alerta WHERE tipoAlerta = 'Repetición';
