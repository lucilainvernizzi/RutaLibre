USE RutaLibreRentACar;
GO

-- ==========================================
-- FUNCION: fn_MargenServicio
-- Calcula el margen en pesos y porcentaje de
-- los servicios adicionales ofrecidos por la compañía.
-- ==========================================
CREATE OR ALTER FUNCTION dbo.fn_MargenServicio
(
    @idServicio INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        sa.idServicio,
        sa.nombreServicio,
        sa.costo,
        sa.precio,
        (sa.precio - sa.costo) AS margenPesos,
        CASE 
            WHEN sa.costo = 0 THEN NULL
            ELSE ROUND(((sa.precio - sa.costo) / sa.costo) * 100, 2)
        END AS margenPorcentaje
    FROM ServicioAdicional sa
    WHERE sa.idServicio = @idServicio
);
GO

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
JOIN DetalleReserva dr ON r.idReserva = dr.idReserva
GROUP BY r.idCliente, dr.patenteVehiculo, r.fechaRetiro
HAVING COUNT(*) > 1;
GO
