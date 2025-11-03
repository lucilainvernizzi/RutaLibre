USE RutaLibreRentACar;
GO

-- ==========================================
-- SP: Registrar Reserva Con Tarifa + Servicios Adicionales
-- Registra reservas con tarifas vigente, validando:
-- 1) Existencia de vehiculo y categoria
-- 2) disponibilidad del vehiculo
-- 3) tarifa vigente segun fecha de retiro
-- 4) calculo automatico de subtotal y total
-- 5) "precio congelado" en detalle

-- ==========================================
CREATE OR ALTER PROCEDURE dbo.sp_RegistrarReservaConTarifa
(
    @idCliente INT,
    @idSucursalRetiro INT,
    @idSucursalDevolucion INT,
    @fechaRetiro DATE,
    @fechaDevolucion DATE,
    @patenteVehiculo VARCHAR(10) 
)
AS
BEGIN

    DECLARE 
        @idCategoria INT,
        @precioPorDia DECIMAL(10,2),
        @cantidadDias INT,
        @subtotalVehiculo DECIMAL(10,2),
        @idReserva INT,
        @montoGarantia DECIMAL(10,2),
        @totalReserva DECIMAL(10,2);

    -- 2) Validar vehículo
    SELECT @idCategoria = idCategoria
    FROM Vehiculo
    WHERE patenteVehiculo = @patenteVehiculo
      AND estadoOperativo = 'Disponible';

    IF @idCategoria IS NULL
    BEGIN
        RAISERROR('El vehículo no existe o no se encuentra disponible.', 16, 1);
        RETURN;
    END;

    -- 3) Tarifa vigente
    SELECT TOP 1 @precioPorDia = precioPorDia
    FROM Tarifa
    WHERE idCategoria = @idCategoria
      AND @fechaRetiro BETWEEN fechaInicio AND fechaFin
    ORDER BY fechaInicio DESC;

    IF @precioPorDia IS NULL
    BEGIN
        RAISERROR('No hay tarifa vigente para la categoría del vehículo en la fecha de retiro.', 16, 1);
        RETURN;
    END;

    -- 4) Días / subtotal / garantía
    SET @cantidadDias = DATEDIFF(DAY, @fechaRetiro, @fechaDevolucion);
    IF @cantidadDias <= 0
    BEGIN
        RAISERROR('La fecha de devolución debe ser posterior a la de retiro.', 16, 1);
        RETURN;
    END;

    SET @subtotalVehiculo = @precioPorDia * @cantidadDias;
    SET @montoGarantia = CASE WHEN @subtotalVehiculo * 0.2 < 15000 THEN 15000 ELSE @subtotalVehiculo * 0.2 END;

    -- 5) Crear reserva
    INSERT INTO Reserva (
        idCliente, idSucursalRetiro, idSucursalDevolucion,
        fechaCreacion, fechaRetiro, fechaDevolucion,
        estadoReserva, totalReserva
    )
    VALUES (
        @idCliente, @idSucursalRetiro, @idSucursalDevolucion,
        GETDATE(), @fechaRetiro, @fechaDevolucion,
        'Pendiente', 0
    );

    SET @idReserva = SCOPE_IDENTITY();

    -- 6) Insertar detalle (dispara trigger)
    INSERT INTO DetalleReserva (idReserva, patenteVehiculo, precioPorDia, cantidadDias, subtotalDetalle)
    VALUES (@idReserva, @patenteVehiculo, @precioPorDia, @cantidadDias, @subtotalVehiculo);

    -- 7) Total de la reserva (detalle + servicios) usando la función
    DECLARE @total DECIMAL(18,2);

    SELECT @totalReserva = totalReserva
    FROM dbo.fn_TotalReserva(@idReserva);

    UPDATE dbo.Reserva
    SET totalReserva = @totalReserva
    WHERE idReserva = @idReserva;

    -- 8) Garantía
    INSERT INTO Garantia (idReserva, montoGarantia, estadoGarantia)
    VALUES (@idReserva, @montoGarantia, 'Retenida');

    -- 9) Marcar vehículo como Fuera de Servicio
    UPDATE Vehiculo
    SET estadoOperativo = 'Fuera de Servicio'
    WHERE patenteVehiculo = @patenteVehiculo;

     -- 1) Mantenimiento previo
    EXEC dbo.sp_InactivarVehiculosPorMantenimiento;

    -- 10) Print final (usando la variable)
    PRINT CONCAT('Reserva ', @idReserva, ' creada. Total $',
                 @totalReserva, ' | Garantía $', @montoGarantia);

END;
GO

/* =========================================================
  PRUEBA DEL SP DE REGISTRO DE RESERVA
========================================================= */
USE RutaLibreRentACar;

-- 1) Marcar vehiculo como disponible
UPDATE Vehiculo
SET estadoOperativo = 'Disponible'
WHERE patenteVehiculo = 'ABC010';

-- 2) crear reserva
EXEC dbo.sp_RegistrarReservaConTarifa
    @idCliente = 1,
    @idSucursalRetiro = 1,
    @idSucursalDevolucion = 2,
    @fechaRetiro = '2025-11-10',
    @fechaDevolucion = '2025-11-15',
    @patenteVehiculo = 'ABC010';

-- 3) obtener última reserva creada
DECLARE @idUltimaReserva INT =
(
    SELECT TOP 1 idReserva
    FROM Reserva
    ORDER BY idReserva DESC
);

-- 4) agregar servicio adicional
INSERT INTO DetalleServicio (idReserva, idServicio, cantidad, subtotal)
VALUES (@idUltimaReserva, 2, 1, (SELECT precio FROM ServicioAdicional WHERE idServicio = 2));

-- 5) recalcular total usando función
UPDATE Reserva
SET totalReserva = (SELECT totalReserva FROM dbo.fn_TotalReserva(@idUltimaReserva))
WHERE idReserva = @idUltimaReserva;

-- 6) mostrar reserva + detalle + servicios
PRINT '====== RESERVA FINAL ======';
SELECT * FROM Reserva WHERE idReserva = @idUltimaReserva;

PRINT '====== DETALLE VEHÍCULO ======';
SELECT * FROM DetalleReserva WHERE idReserva = @idUltimaReserva;

PRINT '====== SERVICIOS ADICIONALES ======';
SELECT * FROM DetalleServicio WHERE idReserva = @idUltimaReserva;

PRINT '====== TOTAL FINAL CALCULADO ======';
SELECT totalReserva AS TotalFinal
FROM Reserva WHERE idReserva = @idUltimaReserva;

-- 7) mostrar estado vehículo
SELECT patenteVehiculo, estadoOperativo 
FROM Vehiculo 
WHERE patenteVehiculo = 'ABC010';

