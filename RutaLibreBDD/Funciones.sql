/* ==========================================
   FUNCION: fn_TotalReserva
   Calcula total = detalle + servicios
========================================== */
USE RutaLibreRentACar;
GO

CREATE OR ALTER FUNCTION dbo.fn_TotalReserva
(
    @idReserva INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        r.idReserva,

        -- total detalle
        (
            SELECT SUM(dr.subtotalDetalle)
            FROM dbo.DetalleReserva dr
            WHERE dr.idReserva = r.idReserva
        ) AS totalDetalle,

        -- total servicios
        (
            SELECT SUM(sa.precio)
            FROM dbo.DetalleServicio ds
            JOIN dbo.ServicioAdicional sa ON sa.idServicio = ds.idServicio
            WHERE ds.idReserva = r.idReserva
        ) AS totalServicios,

        -- total final
        (
            ISNULL( (SELECT SUM(dr.subtotalDetalle) FROM dbo.DetalleReserva dr WHERE dr.idReserva = r.idReserva) ,0)
            +
            ISNULL( (SELECT SUM(sa.precio) FROM dbo.DetalleServicio ds JOIN dbo.ServicioAdicional sa ON sa.idServicio = ds.idServicio WHERE ds.idReserva = r.idReserva),0)
        ) AS totalReserva

    FROM dbo.Reserva r
    WHERE r.idReserva = @idReserva
);
GO

-- ==========================================
-- FUNCION: fn_MargenServicio
-- Calcula el margen en pesos y porcentaje de los servicios adicionales ofrecidos por la compañía.
-- ==========================================
USE RutaLibreRentACar;
GO

CREATE OR ALTER FUNCTION dbo.fn_MargenServicio
(
    @idServicio INT = NULL --id servicio NULL= TODOS
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
        (sa.precio - sa.costo) AS margenPesos, -- Margen en $ 
        CASE 
            WHEN sa.costo = 0 THEN NULL -- si costo = 0 devolvemos NULL para evitar división por cero.
            ELSE ROUND(((sa.precio - sa.costo) / sa.costo) * 100, 2) -- Margen en %, redondeado a dos decimales
        END AS margenPorcentaje
    FROM ServicioAdicional AS sa
    WHERE @idServicio IS NULL  -- si el parámetro es NULL no se filtra, se muestran todos
     OR sa.idServicio = @idServicio  -- si viene un número => muestro solo ese id
);
GO

--Consultar margen de todos los servicios adicionales
SELECT *
FROM dbo.fn_MargenServicio(NULL)
ORDER BY idServicio;

-- Ver márgenes de todos los servicios
SELECT * FROM ServicioAdicional sa
CROSS APPLY dbo.fn_MargenServicio(sa.idServicio);

--Consultar margen de servicios adicional en especifico
SELECT *
FROM dbo.fn_MargenServicio(3)
ORDER BY idServicio;