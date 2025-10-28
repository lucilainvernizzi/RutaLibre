USE RutaLibreRentACar;
GO

-- 1 CATEGORIA CLIENTE
INSERT INTO CategoriaCliente (nombreCatCliente, puntosMinimos, puntosMaximos, descuento)
VALUES 
('Standard', 0, 999, 0),
('Gold', 1000, 4999, 10),
('Corporate', 5000, 999999, 20);
GO

-- 2 CLIENTE (100 registros)
DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO Cliente (nombre, apellido, email, telefono, estadoCliente, puntosAcumulados, idCategoriaCliente)
    VALUES (
        CONCAT('Nombre', @i),
        CONCAT('Apellido', @i),
        CONCAT('cliente', @i, '@correo.com'),
        CONCAT('11', RIGHT('0000000' + CAST(ABS(CHECKSUM(NEWID())) % 9999999 AS VARCHAR(7)), 7)),
        CASE ABS(CHECKSUM(NEWID())) % 3
            WHEN 0 THEN 'Activo'
            WHEN 1 THEN 'Moroso'
            ELSE 'Inactivo'
        END,
        ABS(CHECKSUM(NEWID())) % 7000,
        (ABS(CHECKSUM(NEWID())) % 3) + 1
    );
    SET @i += 1;
END;
GO

-- 3 SUCURSAL (10 registros)
DECLARE @i INT = 1;
WHILE @i <= 10
BEGIN
    INSERT INTO Sucursal (nombre, direccion, tipoSucursal)
    VALUES (
        CONCAT('Sucursal_', @i),
        CONCAT('Calle_', @i, ' Nº', (100 + @i)),
        CASE ABS(CHECKSUM(NEWID())) % 3
            WHEN 0 THEN 'Retiro'
            WHEN 1 THEN 'Devolucion'
            ELSE 'Mixta'
        END
    );
    SET @i += 1;
END;
GO

-- 4 CATEGORIA VEHICULO
INSERT INTO Categoria (nombreCategoria, capPasajeros, transmisionPreferente, prioridadReserva)
VALUES 
('Económico', 4, 'Manual', 1),
('SUV', 5, 'Automática', 2),
('Premium', 5, 'Automática', 3);
GO

-- 5 VEHICULOS (100 registros)
DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO Vehiculo (patenteVehiculo, idSucursal, idCategoria, marca, modelo, anio, kilometraje, estadoOperativo)
    VALUES (
        CONCAT('ABC', RIGHT('000' + CAST(@i AS VARCHAR(3)), 3)),
        ((@i % 10) + 1),  -- idSucursal 1 a 10
        ((@i % 3) + 1),   -- idCategoria 1 a 3
        CASE (@i % 5)
            WHEN 0 THEN 'Toyota'
            WHEN 1 THEN 'Ford'
            WHEN 2 THEN 'Chevrolet'
            WHEN 3 THEN 'Honda'
            ELSE 'Nissan'
        END,
        CONCAT('Modelo', @i),
        2010 + (@i % 14),
        ABS(CHECKSUM(NEWID())) % 200000,
        CASE ABS(CHECKSUM(NEWID())) % 3
            WHEN 0 THEN 'Disponible'
            WHEN 1 THEN 'Fuera de Servicio'
            ELSE 'Inactivo'
        END
    );
    SET @i += 1;
END;
GO

-- 6 TARIFAS (por categoría y temporada)
INSERT INTO Tarifa (idCategoria, temporada, fechaInicio, fechaFin, precioBase, precioPorDia)
VALUES
(1, 'Baja', '2025-03-01', '2025-06-30', 10000, 8000),
(1, 'Alta', '2025-12-01', '2026-02-28', 15000, 12000),
(2, 'Baja', '2025-03-01', '2025-06-30', 18000, 15000),
(2, 'Alta', '2025-12-01', '2026-02-28', 25000, 20000),
(3, 'Baja', '2025-03-01', '2025-06-30', 30000, 25000),
(3, 'Alta', '2025-12-01', '2026-02-28', 40000, 35000);
GO

-- 7 SERVICIOS ADICIONALES
INSERT INTO ServicioAdicional (nombreServicio, costo, precio, cupoDiario)
VALUES
('GPS', 3000, 5000, 10),
('Silla para bebé', 2500, 4000, 5),
('Cobertura ampliada', 7000, 10000, 15),
('Conductor adicional', 4000, 6500, 20);
GO

-- 8 RESERVAS (100 registros)
DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    DECLARE @fechaInicio DATETIME = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 60, GETDATE());
    DECLARE @fechaFin DATETIME = DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 10) + 1, @fechaInicio);
    INSERT INTO Reserva (idCliente, idSucursalRetiro, idSucursalDevolucion, fechaCreacion, fechaRetiro, fechaDevolucion, estadoReserva, totalReserva)
    VALUES (
        ((@i % 100) + 1),
        ((@i % 10) + 1),
        ((@i % 10) + 1),
        GETDATE(),
        @fechaInicio,
        @fechaFin,
        CASE ABS(CHECKSUM(NEWID())) % 3
            WHEN 0 THEN 'Pendiente'
            WHEN 1 THEN 'Confirmada'
            ELSE 'Anulada'
        END,
        (ABS(CHECKSUM(NEWID())) % 50000) + 10000
    );
    SET @i += 1;
END;
GO

-- 9 GARANTIAS (una por reserva)
INSERT INTO Garantia (idReserva, montoGarantia, estadoGarantia)
SELECT idReserva,
       (ABS(CHECKSUM(NEWID())) % 50000) + 10000,
       CASE ABS(CHECKSUM(NEWID())) % 3
            WHEN 0 THEN 'Retenida'
            WHEN 1 THEN 'Liberada'
            ELSE 'Usada Parcialmente'
       END
FROM Reserva;
GO

-- 10 DETALLE RESERVA
DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO DetalleReserva (idReserva, patenteVehiculo, precioPorDia, cantidadDias, subtotalDetalle)
    VALUES (
        @i,
        CONCAT('ABC', RIGHT('000' + CAST((@i % 100) + 1 AS VARCHAR(3)), 3)),
        (ABS(CHECKSUM(NEWID())) % 20000) + 5000,
        (ABS(CHECKSUM(NEWID())) % 7) + 1,
        (ABS(CHECKSUM(NEWID())) % 150000) + 50000
    );
    SET @i += 1;
END;
GO

-- 11 DETALLE SERVICIO (asociación reserva-servicio)
DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO DetalleServicio (idReserva, idServicio, cantidad, subtotal)
    VALUES (
        @i,
        ((@i % 4) + 1),
        (ABS(CHECKSUM(NEWID())) % 3) + 1,
        (ABS(CHECKSUM(NEWID())) % 15000) + 3000
    );
    SET @i += 1;
END;
GO

-- ====================================================
-- DATOS DE PRUEBA PARA VERIFICAR LA VISTA DE DUPLICADOS
-- ====================================================

-- Insertar reserva 1
INSERT INTO Reserva (idCliente, idSucursalRetiro, idSucursalDevolucion, fechaCreacion, fechaRetiro, fechaDevolucion, estadoReserva, totalReserva)
VALUES (1, 1, 1, GETDATE(), '2025-11-01', '2025-11-05', 'Pendiente', 100000);

-- Insertar reserva 2 idéntica (misma fecha, cliente y vehículo)
INSERT INTO Reserva (idCliente, idSucursalRetiro, idSucursalDevolucion, fechaCreacion, fechaRetiro, fechaDevolucion, estadoReserva, totalReserva)
VALUES (1, 1, 1, GETDATE(), '2025-11-01', '2025-11-05', 'Pendiente', 100000);

-- Insertar detalles de reserva con el mismo vehículo
INSERT INTO DetalleReserva (idReserva, patenteVehiculo, cantidadDias, precioPorDia, subtotalDetalle)
VALUES (1, 'ABC123', 4, 25000, 100000);

INSERT INTO DetalleReserva (idReserva, patenteVehiculo, cantidadDias, precioPorDia, subtotalDetalle)
VALUES (2, 'ABC123', 4, 25000, 100000);
