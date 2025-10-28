USE RutaLibreRentACar;
GO

-- Probar la función de margen
SELECT * FROM dbo.fn_MargenServicio(1);

-- Ver márgenes de todos los servicios
SELECT * FROM ServicioAdicional sa
CROSS APPLY dbo.fn_MargenServicio(sa.idServicio);

-- Probar la vista de duplicados
SELECT * FROM dbo.vw_VehiculosDuplicados;

USE RutaLibreRentACar;
GO
