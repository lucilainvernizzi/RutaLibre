GO
USE RutaLibreRentACar;
GO

-- =============================
-- REGISTROS TABLA: Sucursal
-- =============================
INSERT INTO Sucursal (nombre, direccion, tipoSucursal) VALUES
('Sucursal Centro', 'Av. 18 de Julio 1234, Montevideo', 'Mixta'),
('Sucursal Pocitos', 'Bvar. España 2456, Montevideo', 'Retiro'),
('Sucursal Punta Carretas', 'Ellauri 3500, Montevideo', 'Mixta'),
('Sucursal Ciudad de la Costa', 'Av. Giannattasio km 21, Canelones', 'Devolucion'),
('Sucursal Maldonado', 'Av. Roosevelt 4567, Maldonado', 'Devolucion'),
('Sucursal Colonia', 'Av. Artigas 890, Colonia', 'Retiro'),
('Sucursal Salto', 'Uruguay 1122, Salto', 'Mixta'),
('Sucursal Paysandú', 'Leandro Gómez 1345, Paysandú', 'Mixta'),
('Sucursal Tacuarembó', '25 de Agosto 455, Tacuarembó', 'Retiro'),
('Sucursal Rivera', 'Sarandí 899, Rivera', 'Mixta');

-- ==========================================
-- REGISTROS TABLA: CategoriaCliente
-- ==========================================
SET IDENTITY_INSERT CategoriaCliente ON;

INSERT INTO CategoriaCliente (idCategoriaCliente, nombreCatCliente, puntosMinimos, puntosMaximos, descuento) VALUES
(1, 'Standard',   0, 249,  0.00),
(2, 'Gold',     250, 349, 10.00),
(3, 'Corporate',350, 500, 18.00);

SET IDENTITY_INSERT CategoriaCliente OFF;

-- ==========================================
-- REGISTROS TABLA: Cliente
-- ==========================================

SET IDENTITY_INSERT Cliente ON;

INSERT INTO Cliente (idCliente, nombre, apellido, estadoCliente, puntosAcumulados, idCategoriaCliente)
SELECT  idCliente, nombre, apellido, estadoCliente, puntos,
        CASE 
            WHEN puntos BETWEEN 350 AND 500 THEN 3  -- Corporate
            WHEN puntos BETWEEN 250 AND 349 THEN 2  -- Gold
            ELSE 1                                  -- Standard
        END AS idCategoriaCliente
FROM (
VALUES
(1,'Camila','González','Activo',250),
(2,'Mateo','Rodríguez','Activo',390),
(3,'Sofía','López','Activo',180),
(4,'Benjamín','Fernández','Activo',320),
(5,'Martina','Pérez','Activo',210),
(6,'Valentino','Torres','Inactivo',60),
(7,'Lucía','Díaz','Activo',340),
(8,'Santiago','Ruiz','Activo',200),
(9,'Emilia','Romero','Activo',175),
(10,'Joaquín','Sosa','Activo',400),
(11,'Isabella','Benítez','Activo',95),
(12,'Thiago','Gómez','Activo',450),
(13,'Catalina','Luna','Activo',310),
(14,'Lautaro','Ramírez','Activo',280),
(15,'Valentina','Herrera','Activo',230),
(16,'Emma','Vega','Inactivo',70),
(17,'Bruno','Acosta','Activo',325),
(18,'Mía','Rivas','Activo',210),
(19,'Francesca','Castro','Activo',290),
(20,'Julieta','Medina','Activo',350),
(21,'Dylan','Molina','Inactivo',40),
(22,'Bautista','Campos','Activo',480),
(23,'Chiara','Correa','Activo',220),
(24,'Juan','Ponce','Activo',310),
(25,'Mía','Morales','Activo',260),
(26,'Valeria','Arias','Activo',330),
(27,'Luciano','Domínguez','Activo',120),
(28,'Renata','Ortiz','Activo',340),
(29,'Ignacio','Flores','Activo',220),
(30,'Jazmín','Moreno','Activo',305),
(31,'Tomás','Benítez','Activo',410),
(32,'Ariana','Méndez','Activo',155),
(33,'Julian','Ledesma','Activo',245),
(34,'Melina','Navarro','Activo',370),
(35,'Alan','Vega','Activo',390),
(36,'Lara','Salazar','Activo',300),
(37,'Tobías','Campos','Inactivo',90),
(38,'Elena','Paz','Activo',270),
(39,'Lucas','Montes','Activo',350),
(40,'Agustina','Peralta','Activo',250),
(41,'Gonzalo','Núñez','Activo',460),
(42,'Nicolás','Aguirre','Activo',125),
(43,'Martín','Toledo','Activo',270),
(44,'Ciro','Carrizo','Activo',340),
(45,'Luna','Gómez','Activo',210),
(46,'Guadalupe','Rojas','Activo',310),
(47,'Felipe','Ibáñez','Activo',430),
(48,'Agustín','Mansilla','Activo',180),
(49,'Zoe','Pereyra','Activo',360),
(50,'Emma','Romano','Activo',150),
(51,'Benicio','Campos','Activo',210),
(52,'Renzo','Ojeda','Activo',280),
(53,'Isabela','Rey','Activo',305),
(54,'Abril','Ramos','Activo',255),
(55,'Milo','Giménez','Inactivo',50),
(56,'Mora','Cáceres','Activo',390),
(57,'Simón','Delgado','Activo',205),
(58,'Paulina','Silva','Activo',370),
(59,'Felipe','Arce','Activo',330),
(60,'Isidro','Miranda','Activo',310),
(61,'Alma','Roldán','Activo',275),
(62,'Ramiro','Villar','Activo',440),
(63,'Bautista','Soria','Activo',190),
(64,'Valentina','Ferrari','Activo',350),
(65,'Amparo','Cortés','Activo',175),
(66,'Luca','Bravo','Activo',260),
(67,'Candelaria','Montiel','Activo',200),
(68,'Ian','Guerra','Activo',230),
(69,'Valeria','Romero','Activo',320),
(70,'Julieta','Molina','Activo',290),
(71,'Tomás','Benítez','Activo',230),
(72,'Luciana','Torres','Activo',310),
(73,'Camilo','Sánchez','Activo',160),
(74,'Clara','Paredes','Activo',340),
(75,'Aitana','Cruz','Activo',400),
(76,'Ernesto','Vera','Inactivo',85),
(77,'Pedro','Mendez','Activo',255),
(78,'Daniela','Ramos','Activo',300),
(79,'Axel','Navarro','Activo',390),
(80,'Micaela','Carrizo','Activo',360),
(81,'Carolina','Martínez','Activo',240),
(82,'Juan','Pereyra','Activo',315),
(83,'Patricio','Rivero','Activo',370),
(84,'Brisa','Maldonado','Activo',265),
(85,'Naiara','Ibarra','Activo',410),
(86,'Valen','Montoya','Activo',295),
(87,'Gabriel','Coronel','Activo',260),
(88,'Victoria','Pardo','Activo',330),
(89,'Lucía','Santos','Activo',275),
(90,'Dante','Del Valle','Activo',380),
(91,'Renata','Sánchez','Activo',420),
(92,'Sebastián','Arias','Activo',270),
(93,'Camila','Flores','Activo',300),
(94,'Julian','Ledesma','Activo',190),
(95,'Melina','Navarro','Activo',370),
(96,'Alan','Vega','Activo',250),
(97,'Lara','Salazar','Activo',200),
(98,'Tobías','Campos','Activo',355),
(99,'Elena','Paz','Activo',180),
(100,'Diego','Moreira','Activo',440)
) AS V(idCliente, nombre, apellido, estadoCliente, puntos);

SET IDENTITY_INSERT Cliente OFF;


-- ==========================================
-- REGISTROS TABLA: ClienteTelefono 
-- ==========================================
-- ClienteTelefono (telefono, idCliente)
INSERT INTO ClienteTelefono (telefono, idCliente) VALUES
('11-50000001', 1),
('11-50000002', 2),
('11-50000003', 3),
('11-50000004', 4),
('11-50000005', 5),
('11-50000006', 6),
('11-50000007', 7),
('11-50000008', 8),
('11-50000009', 9),
('11-50000010', 10),
('11-50000011', 11),
('11-50000012', 12),
('11-50000013', 13),
('11-50000014', 14),
('11-50000015', 15),
('11-50000016', 16),
('11-50000017', 17),
('11-50000018', 18),
('11-50000019', 19),
('11-50000020', 20),
('11-50000021', 21),
('11-50000022', 22),
('11-50000023', 23),
('11-50000024', 24),
('11-50000025', 25),
('11-50000026', 26),
('11-50000027', 27),
('11-50000028', 28),
('11-50000029', 29),
('11-50000030', 30),
('11-50000031', 31),
('11-50000032', 32),
('11-50000033', 33),
('11-50000034', 34),
('11-50000035', 35),
('11-50000036', 36),
('11-50000037', 37),
('11-50000038', 38),
('11-50000039', 39),
('11-50000040', 40),
('11-50000041', 41),
('11-50000042', 42),
('11-50000043', 43),
('11-50000044', 44),
('11-50000045', 45),
('11-50000046', 46),
('11-50000047', 47),
('11-50000048', 48),
('11-50000049', 49),
('11-50000050', 50),
('11-60000001', 51),
('11-60000002', 52),
('11-60000003', 53),
('11-60000004', 54),
('11-60000005', 55),
('11-60000006', 56),
('11-60000007', 57),
('11-60000008', 58),
('11-60000009', 59),
('11-60000010', 60),
('11-60000011', 61),
('11-60000012', 62),
('11-60000013', 63),
('11-60000014', 64),
('11-60000015', 65),
('11-60000016', 66),
('11-60000017', 67),
('11-60000018', 68),
('11-60000019', 69),
('11-60000020', 70),
('11-60000021', 71),
('11-60000022', 72),
('11-60000023', 73),
('11-60000024', 74),
('11-60000025', 75),
('11-60000026', 76),
('11-60000027', 77),
('11-60000028', 78),
('11-60000029', 79),
('11-60000030', 80),
('11-60000031', 81),
('11-60000032', 82),
('11-60000033', 83),
('11-60000034', 84),
('11-60000035', 85),
('11-60000036', 86),
('11-60000037', 87),
('11-60000038', 88),
('11-60000039', 89),
('11-60000040', 90),
('11-60000041', 91),
('11-60000042', 92),
('11-60000043', 93),
('11-60000044', 94),
('11-60000045', 95),
('11-60000046', 96),
('11-60000047', 97),
('11-60000048', 98),
('11-60000049', 99),
('11-60000050', 100),
('11-60000051', 2),
('11-60000052', 45),
('11-60000053', 66),
('11-60000054', 80),
('11-60000055', 10);


-- ==========================================
-- REGISTROS TABLA: ClienteEmail (1 email por cliente)
-- ==========================================

INSERT INTO ClienteEmail (email, idCliente) VALUES
('camila.gonzalez@email.com', 1),
('mateo.rodriguez@email.com', 2),
('sofia.lopez@email.com', 3),
('benjamin.fernandez@email.com', 4),
('martina.perez@email.com', 5),
('lucia.diaz@email.com', 6),
('santiago.ruiz@email.com', 7),
('emilia.romero@email.com', 8),
('joaquin.sosa@email.com', 9),
('isabella.benitez@email.com', 10),
('thiago.gomez@email.com', 11),
('catalina.luna@email.com', 12),
('lautaro.ramirez@email.com', 13),
('valentina.herrera@email.com', 14),
('bruno.acosta@email.com', 15),
('mia.rivas@email.com', 16),
('francesca.castro@email.com', 17),
('julieta.medina@email.com', 18),
('bautista.campos@email.com', 19),
('chiara.correa@email.com', 20),
('juan.ponce@email.com', 21),
('valeria.arias@email.com', 22),
('renata.ortiz@email.com', 23),
('ignacio.flores@email.com', 24),
('tomas.benitez@email.com', 25),
('ariana.mendez@email.com', 26),
('melina.navarro@email.com', 27),
('alan.vega@email.com', 28),
('lara.salazar@email.com', 29),
('elena.paz@email.com', 30),
('agustina.peralta@email.com', 31),
('gonzalo.nunez@email.com', 32),
('nicolas.aguirre@email.com', 33),
('martin.toledo@email.com', 34),
('luna.gomez@email.com', 35),
('guadalupe.rojas@email.com', 36),
('felipe.ibanez@email.com', 37),
('zoe.pereyra@email.com', 38),
('emma.romano@email.com', 39),
('renzo.ojeda@email.com', 40),
('abril.ramos@email.com', 41),
('mora.caceres@email.com', 42),
('simon.delgado@email.com', 43),
('paulina.silva@email.com', 44),
('alma.roldan@email.com', 45),
('ramiro.villar@email.com', 46),
('valentina.ferrari@email.com', 47),
('amparo.cortes@email.com', 48),
('luca.bravo@email.com', 49),
('candelaria.montiel@email.com', 50),
('ian.guerra@email.com', 51),
('valeria.romero@email.com', 52),
('julieta.molina@email.com', 53),
('tomas.benitez2@email.com', 54),
('luciana.torres@email.com', 55),
('camilo.sanchez@email.com', 56),
('clara.paredes@email.com', 57),
('aitana.cruz@email.com', 58),
('ernesto.vera@email.com', 59),
('pedro.mendez@email.com', 60),
('daniela.ramos@email.com', 61),
('axel.navarro@email.com', 62),
('micaela.carrizo@email.com', 63),
('carolina.martinez@email.com', 64),
('juan.pereyra@email.com', 65),
('patricio.rivero@email.com', 66),
('brisa.maldonado@email.com', 67),
('naiara.ibarra@email.com', 68),
('valen.montoya@email.com', 69),
('gabriel.coronel@email.com', 70),
('victoria.pardo@email.com', 71),
('lucia.santos@email.com', 72),
('dante.delvalle@email.com', 73),
('renata.sanchez@email.com', 74),
('sebastian.arias@email.com', 75),
('camila.flores@email.com', 76),
('julian.ledesma@email.com', 77),
('melina.navarro2@email.com', 78),
('alan.vega2@email.com', 79),
('lara.salazar2@email.com', 80),
('tobias.campos@email.com', 81),
('elena.paz2@email.com', 82),
('diego.moreira@email.com', 83),
('tamara.rios@email.com', 84),
('franco.aguilar@email.com', 85),
('micaela.luna@email.com', 86),
('facundo.paz@email.com', 87),
('carla.dominguez@email.com', 88),
('florencia.rey@email.com', 89),
('agustin.molina@email.com', 90),
('jazmin.pardo@email.com', 91),
('rodrigo.caceres@email.com', 92),
('luciano.rivas@email.com', 93),
('maria.fernandez@email.com', 94),
('pilar.cruz@email.com', 95),
('ramiro.campos@email.com', 96),
('mauro.roldan@email.com', 97),
('barbara.suarez@email.com', 98),
('esteban.soria@email.com', 99),
('paula.gomez@email.com', 100),
('emiromero@email.com', 8),
('joacososa@email.com', 9),
('bellabenitez@email.com', 10),
('titigomez@email.com', 11),
('catitaluna@email.com', 12),
('laucharamirez@email.com', 13),
('tinaaaaherrera@email.com', 14),
('brunomars@email.com', 15);

/* =====================================================
   REGISTROS TABLA: Categoria (Vehiculo)
   ===================================================== */

INSERT INTO Categoria (nombreCategoria, capPasajeros, transmisionPreferente, prioridadReserva) VALUES
('Económico', 4, 'Manual',      1),
('SUV',       5, 'Automática',  2),
('Premium',   5, 'Automática',  3);

GO

-- ==========================================================
-- REGISTROS TABLA: Vehiculo (50 registros base)
-- ==========================================================
INSERT INTO Vehiculo (patenteVehiculo, idSucursal, idCategoria, marca, modelo, anio, kilometraje, estadoOperativo)
VALUES
('ABC001', 1, 1, 'Chevrolet', 'Onix', 2022, 15000, 'Disponible'),
('ABC002', 1, 1, 'Fiat', 'Cronos', 2023, 12000, 'Disponible'),
('ABC003', 2, 2, 'Toyota', 'RAV4', 2021, 28000, 'Disponible'),
('ABC004', 3, 3, 'BMW', 'X1', 2022, 19000, 'Disponible'),
('ABC005', 2, 1, 'Volkswagen', 'Polo', 2023, 11000, 'Disponible'),
('ABC006', 3, 2, 'Nissan', 'Kicks', 2021, 27000, 'Disponible'),
('ABC007', 4, 1, 'Renault', 'Logan', 2022, 22000, 'Disponible'),
('ABC008', 5, 1, 'Peugeot', '208', 2021, 26000, 'Disponible'),
('ABC009', 5, 3, 'Audi', 'Q3', 2023, 15000, 'Disponible'),
('ABC010', 6, 1, 'Ford', 'Ka', 2021, 29000, 'Disponible'),
('ABC011', 6, 2, 'Jeep', 'Compass', 2023, 17000, 'Disponible'),
('ABC012', 7, 1, 'Toyota', 'Etios', 2020, 30000, 'Disponible'),
('ABC013', 7, 2, 'Hyundai', 'Tucson', 2022, 18000, 'Disponible'),
('ABC014', 8, 3, 'Mercedes', 'GLA', 2023, 12000, 'Disponible'),
('ABC015', 8, 1, 'Chevrolet', 'Prisma', 2021, 25000, 'Disponible'),
('ABC016', 9, 2, 'Honda', 'HR-V', 2022, 20000, 'Disponible'),
('ABC017', 9, 1, 'Citroën', 'C3', 2023, 10000, 'Disponible'),
('ABC018', 10, 3, 'BMW', 'Serie 3', 2021, 24000, 'Disponible'),
('ABC019', 10, 2, 'Volkswagen', 'T-Cross', 2023, 13000, 'Disponible'),
('ABC020', 1, 1, 'Nissan', 'Versa', 2022, 18000, 'Disponible'),
('ABC021', 2, 1, 'Peugeot', '301', 2020, 35000, 'Disponible'),
('ABC022', 3, 3, 'Audi', 'A4', 2022, 21000, 'Disponible'),
('ABC023', 4, 2, 'Toyota', 'Corolla Cross', 2023, 16000, 'Disponible'),
('ABC024', 4, 1, 'Fiat', 'Argo', 2021, 27000, 'Disponible'),
('ABC025', 5, 1, 'Renault', 'Sandero', 2023, 10000, 'Disponible'),
('ABC026', 5, 2, 'Ford', 'Ecosport', 2021, 22000, 'Disponible'),
('ABC027', 6, 1, 'Volkswagen', 'Gol', 2022, 14000, 'Disponible'),
('ABC028', 7, 3, 'BMW', 'X3', 2022, 19000, 'Disponible'),
('ABC029', 8, 1, 'Toyota', 'Yaris', 2021, 24000, 'Disponible'),
('ABC030', 9, 2, 'Hyundai', 'Kona', 2023, 15000, 'Disponible'),
('ABC031', 10, 1, 'Chevrolet', 'Sonic', 2020, 32000, 'Disponible'),
('ABC032', 1, 2, 'Nissan', 'Qashqai', 2023, 12000, 'Disponible'),
('ABC033', 2, 1, 'Peugeot', '208', 2023, 8000, 'Disponible'),
('ABC034', 3, 1, 'Fiat', 'Mobi', 2021, 18000, 'Disponible'),
('ABC035', 3, 2, 'Toyota', 'Hilux', 2022, 25000, 'Disponible'),
('ABC036', 4, 3, 'BMW', 'X5', 2022, 14000, 'Disponible'),
('ABC037', 5, 1, 'Renault', 'Kwid', 2023, 9000, 'Disponible'),
('ABC038', 5, 2, 'Jeep', 'Renegade', 2021, 20000, 'Disponible'),
('ABC039', 6, 1, 'Ford', 'Focus', 2020, 32000, 'Disponible'),
('ABC040', 6, 2, 'Volkswagen', 'Tiguan', 2023, 10000, 'Disponible'),
('ABC041', 7, 3, 'Mercedes', 'C200', 2022, 15000, 'Disponible'),
('ABC042', 8, 1, 'Chevrolet', 'Spin', 2021, 26000, 'Disponible'),
('ABC043', 8, 1, 'Fiat', 'Palio', 2020, 31000, 'Disponible'),
('ABC044', 9, 2, 'Nissan', 'X-Trail', 2022, 18000, 'Disponible'),
('ABC045', 10, 3, 'Audi', 'A6', 2023, 12000, 'Disponible'),
('ABC046', 1, 1, 'Volkswagen', 'Up', 2021, 15000, 'Disponible'),
('ABC047', 2, 2, 'Honda', 'CR-V', 2022, 19000, 'Disponible'),
('ABC048', 3, 3, 'BMW', 'Serie 1', 2023, 10000, 'Disponible'),
('ABC049', 4, 2, 'Hyundai', 'Creta', 2022, 16000, 'Disponible'),
('ABC050', 5, 1, 'Fiat', 'Siena', 2021, 22000, 'Disponible');
GO


/* =====================================================
   REGISTROS TABLA: Tarifa
   - Temporadas válidas: 'Baja', 'Media', 'Alta'
   - Fechas sin solapamiento durante 2025
   - Valores coherentes con segmento de vehículo
   ===================================================== */

-- ECONÓMICO
INSERT INTO Tarifa (idCategoria, temporada, fechaInicio, fechaFin, precioBase, precioPorDia) VALUES
((SELECT idCategoria FROM Categoria WHERE nombreCategoria = 'Económico'), 'Baja',  '2025-01-01', '2025-03-31', 32000.00, 11000.00),
((SELECT idCategoria FROM Categoria WHERE nombreCategoria = 'Económico'), 'Media', '2025-04-01', '2025-08-31', 39000.00, 14000.00),
((SELECT idCategoria FROM Categoria WHERE nombreCategoria = 'Económico'), 'Alta',  '2025-09-01', '2025-12-31', 48000.00, 17000.00);

-- SUV
INSERT INTO Tarifa (idCategoria, temporada, fechaInicio, fechaFin, precioBase, precioPorDia) VALUES
((SELECT idCategoria FROM Categoria WHERE nombreCategoria = 'SUV'), 'Baja',  '2025-01-01', '2025-03-31', 46000.00, 16000.00),
((SELECT idCategoria FROM Categoria WHERE nombreCategoria = 'SUV'), 'Media', '2025-04-01', '2025-08-31', 54000.00, 19000.00),
((SELECT idCategoria FROM Categoria WHERE nombreCategoria = 'SUV'), 'Alta',  '2025-09-01', '2025-12-31', 64000.00, 23000.00);

-- PREMIUM
INSERT INTO Tarifa (idCategoria, temporada, fechaInicio, fechaFin, precioBase, precioPorDia) VALUES
((SELECT idCategoria FROM Categoria WHERE nombreCategoria = 'Premium'), 'Baja',  '2025-01-01', '2025-03-31', 65000.00, 22000.00),
((SELECT idCategoria FROM Categoria WHERE nombreCategoria = 'Premium'), 'Media', '2025-04-01', '2025-08-31', 74000.00, 26000.00),
((SELECT idCategoria FROM Categoria WHERE nombreCategoria = 'Premium'), 'Alta',  '2025-09-01', '2025-12-31', 90000.00, 32000.00);

GO

-- ==========================================================
-- REGISTROS TABLA: ServicioAdicional
-- ==========================================================
INSERT INTO ServicioAdicional (nombreServicio, costo, precio, cupoDiario)
VALUES
('Silla para bebé', 500.00, 800.00, 10),
('GPS', 300.00, 600.00, 15),
('Cobertura ampliada', 1500.00, 2500.00, 20);
GO

-- ==========================================================
-- REGISTROS TABLA: Reserva 
-- ==========================================================
INSERT INTO Reserva (idCliente, idSucursalRetiro, idSucursalDevolucion, fechaCreacion, fechaRetiro, fechaDevolucion, estadoReserva, totalReserva)
VALUES
(1, 1, 2, GETDATE(), '2025-01-10', '2025-01-15', 'Confirmada', 55000.00),
(2, 3, 4, GETDATE(), '2025-01-12', '2025-01-18', 'Pendiente', 48000.00),
(3, 5, 5, GETDATE(), '2025-02-01', '2025-02-05', 'Anulada', 0.00),
(4, 6, 7, GETDATE(), '2025-02-10', '2025-02-14', 'Confirmada', 60000.00),
(5, 2, 3, GETDATE(), '2025-03-01', '2025-03-07', 'Pendiente', 72000.00),
(6, 3, 3, GETDATE(), '2025-03-15', '2025-03-18', 'Confirmada', 42000.00),
(7, 4, 4, GETDATE(), '2025-03-20', '2025-03-25', 'Pendiente', 56000.00),
(8, 1, 1, GETDATE(), '2025-03-25', '2025-03-28', 'Confirmada', 35000.00),
(9, 2, 2, GETDATE(), '2025-04-01', '2025-04-05', 'Confirmada', 40000.00),
(10, 3, 4, GETDATE(), '2025-04-10', '2025-04-15', 'Anulada', 0.00),
(11, 5, 6, GETDATE(), '2025-04-20', '2025-04-25', 'Confirmada', 70000.00),
(12, 1, 3, GETDATE(), '2025-05-01', '2025-05-07', 'Pendiente', 62000.00),
(13, 2, 4, GETDATE(), '2025-05-10', '2025-05-15', 'Confirmada', 48000.00),
(14, 6, 7, GETDATE(), '2025-05-20', '2025-05-27', 'Confirmada', 83000.00),
(15, 8, 8, GETDATE(), '2025-06-01', '2025-06-06', 'Pendiente', 51000.00),
(16, 9, 9, GETDATE(), '2025-06-10', '2025-06-15', 'Confirmada', 60000.00),
(17, 10, 10, GETDATE(), '2025-06-20', '2025-06-25', 'Confirmada', 70000.00),
(18, 1, 2, GETDATE(), '2025-07-01', '2025-07-05', 'Pendiente', 45000.00),
(19, 3, 3, GETDATE(), '2025-07-10', '2025-07-15', 'Confirmada', 49000.00),
(20, 4, 5, GETDATE(), '2025-07-20', '2025-07-25', 'Confirmada', 64000.00),
(21, 5, 6, GETDATE(), '2025-08-01', '2025-08-06', 'Confirmada', 70000.00),
(22, 7, 7, GETDATE(), '2025-08-10', '2025-08-15', 'Pendiente', 55000.00),
(23, 8, 8, GETDATE(), '2025-08-20', '2025-08-25', 'Confirmada', 50000.00),
(24, 9, 10, GETDATE(), '2025-09-01', '2025-09-07', 'Confirmada', 73000.00),
(25, 10, 10, GETDATE(), '2025-09-10', '2025-09-15', 'Anulada', 0.00),
(26, 1, 2, GETDATE(), '2025-09-20', '2025-09-25', 'Confirmada', 67000.00),
(27, 2, 3, GETDATE(), '2025-10-01', '2025-10-05', 'Pendiente', 48000.00),
(28, 3, 3, GETDATE(), '2025-10-10', '2025-10-15', 'Confirmada', 52000.00),
(29, 4, 4, GETDATE(), '2025-10-20', '2025-10-25', 'Confirmada', 58000.00),
(30, 5, 6, GETDATE(), '2025-10-25', '2025-10-30', 'Pendiente', 60000.00);
GO

-- ==========================================================
-- REGISTROS TABLA: Garantia (30 registros, una por reserva)
-- ==========================================================
INSERT INTO Garantia (idReserva, montoGarantia, estadoGarantia)
VALUES
(1, 15000.00, 'Retenida'),
(2, 12000.00, 'Retenida'),
(3, 0.00, 'Liberada'),
(4, 16000.00, 'Retenida'),
(5, 18000.00, 'Retenida'),
(6, 10000.00, 'Liberada'),
(7, 12000.00, 'Retenida'),
(8, 8000.00, 'Liberada'),
(9, 9500.00, 'Retenida'),
(10, 0.00, 'Liberada'),
(11, 17000.00, 'Retenida'),
(12, 15000.00, 'Retenida'),
(13, 10000.00, 'Retenida'),
(14, 16000.00, 'Retenida'),
(15, 11000.00, 'Retenida'),
(16, 13000.00, 'Liberada'),
(17, 14500.00, 'Retenida'),
(18, 9500.00, 'Retenida'),
(19, 10000.00, 'Retenida'),
(20, 12000.00, 'Retenida'),
(21, 15000.00, 'Retenida'),
(22, 11500.00, 'Retenida'),
(23, 10000.00, 'Retenida'),
(24, 16000.00, 'Retenida'),
(25, 0.00, 'Liberada'),
(26, 14000.00, 'Retenida'),
(27, 11000.00, 'Retenida'),
(28, 12500.00, 'Retenida'),
(29, 13500.00, 'Retenida'),
(30, 12000.00, 'Retenida');
GO

-- ==========================================================
-- REGISTROS TABLA: DetalleReserva 
-- ==========================================================
INSERT INTO DetalleReserva (idReserva, patenteVehiculo, precioPorDia, cantidadDias, subtotalDetalle)
VALUES
(1, 'ABC001', 11000, 5, 55000),
(2, 'ABC002', 12000, 4, 48000),
(4, 'ABC003', 15000, 4, 60000),
(5, 'ABC004', 12000, 6, 72000),
(6, 'ABC005', 14000, 3, 42000),
(7, 'ABC006', 14000, 4, 56000),
(8, 'ABC007', 11600, 3, 34800),
(9, 'ABC008', 10000, 4, 40000),
(11, 'ABC009', 14000, 5, 70000),
(12, 'ABC010', 15500, 4, 62000),
(13, 'ABC011', 12000, 4, 48000),
(14, 'ABC012', 11850, 7, 82950),
(15, 'ABC013', 10200, 5, 51000),
(16, 'ABC014', 12000, 5, 60000),
(17, 'ABC015', 14000, 5, 70000),
(18, 'ABC016', 9000, 5, 45000),
(19, 'ABC017', 9800, 5, 49000),
(20, 'ABC018', 12800, 5, 64000),
(21, 'ABC019', 14000, 5, 70000),
(22, 'ABC020', 11000, 5, 55000),
(23, 'ABC021', 10000, 5, 50000),
(24, 'ABC022', 14600, 5, 73000),
(26, 'ABC023', 13400, 5, 67000),
(27, 'ABC024', 9600, 5, 48000),
(28, 'ABC025', 10400, 5, 52000),
(29, 'ABC026', 11600, 5, 58000),
(30, 'ABC027', 12000, 5, 60000),
-- reservas con 2 autos (multi-detalle)
(1, 'ABC028', 11000, 5, 55000),
(5, 'ABC029', 12000, 3, 36000),
(14, 'ABC030', 16000, 2, 32000);
GO

-- ==========================================================
-- REGISTROS TABLA: DetalleServicio (algunas reservas con servicios)
-- ==========================================================
INSERT INTO DetalleServicio (idReserva, idServicio, cantidad, subtotal)
VALUES
(1, 1, 1, 800),
(1, 2, 1, 600),
(2, 3, 1, 2500),
(4, 1, 1, 800),
(4, 2, 1, 600),
(5, 3, 1, 2500),
(7, 2, 1, 600),
(8, 1, 2, 1600),
(11, 3, 1, 2500),
(12, 2, 1, 600),
(13, 1, 1, 800),
(14, 3, 1, 2500),
(15, 2, 1, 600),
(16, 1, 1, 800),
(18, 2, 1, 600),
(19, 1, 1, 800),
(20, 3, 1, 2500),
(21, 2, 1, 600),
(22, 1, 1, 800),
(23, 3, 1, 2500);
GO