USE RutaLibreRentACar;
GO

-- ============================
-- PRUEBA DEL TRIGGER ANTI-DUPLICADO
-- ============================

-- Creamos una reserva válida
INSERT INTO Reserva (idCliente, idSucursalRetiro, idSucursalDevolucion, fechaCreacion, fechaRetiro, fechaDevolucion, estadoReserva, totalReserva)
VALUES (1, 1, 1, GETDATE(), '2025-11-10', '2025-11-15', 'Pendiente', 150000);

DECLARE @idReserva1 INT = SCOPE_IDENTITY();

INSERT INTO DetalleReserva (idReserva, patenteVehiculo, cantidadDias, precioPorDia, subtotalDetalle)
VALUES (@idReserva1, 'ABC999', 5, 30000, 150000);

-- Intentamos crear otra reserva con el MISMO cliente, fecha y vehículo (debe fallar)
INSERT INTO Reserva (idCliente, idSucursalRetiro, idSucursalDevolucion, fechaCreacion, fechaRetiro, fechaDevolucion, estadoReserva, totalReserva)
VALUES (1, 1, 1, GETDATE(), '2025-11-10', '2025-11-15', 'Pendiente', 150000);

DECLARE @idReserva2 INT = SCOPE_IDENTITY();

INSERT INTO DetalleReserva (idReserva, patenteVehiculo, cantidadDias, precioPorDia, subtotalDetalle)
VALUES (@idReserva2, 'ABC999', 5, 30000, 150000);
GO

-- ============================
-- PRUEBA DEL CURSOR DE MANTENIMIENTO
-- ============================

-- Marcamos el vehículo como fuera de servicio
UPDATE Vehiculo SET estadoOperativo = 'Fuera de Servicio' WHERE patenteVehiculo = 'ABC999';

-- Creamos una reserva pendiente que use ese vehículo
DECLARE @idReserva3 INT;
INSERT INTO Reserva (idCliente, idSucursalRetiro, idSucursalDevolucion, fechaCreacion, fechaRetiro, fechaDevolucion, estadoReserva, totalReserva)
VALUES (2, 1, 1, GETDATE(), '2025-11-20', '2025-11-25', 'Pendiente', 120000);
SET @idReserva3 = SCOPE_IDENTITY();

INSERT INTO DetalleReserva (idReserva, patenteVehiculo, cantidadDias, precioPorDia, subtotalDetalle)
VALUES (@idReserva3, 'ABC999', 5, 24000, 120000);

-- Ejecutamos el procedimiento con cursor
EXEC dbo.sp_InactivarVehiculosPorMantenimiento;

-- Verificamos estado del vehículo
SELECT patenteVehiculo, estadoOperativo FROM Vehiculo WHERE patenteVehiculo = 'ABC999';

-- Verificamos reservas afectadas
SELECT idReserva, estadoReserva FROM Reserva WHERE idCliente IN (1,2);
GO


SELECT * FROM Vehiculo WHERE patenteVehiculo = 'ABC999';
