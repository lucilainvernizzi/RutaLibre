-- ==========================================================
-- BASE DE DATOS: RutaLibre Rent-a-Car
-- ==========================================================

IF DB_ID('RutaLibreRentACar') IS NULL
    CREATE DATABASE RutaLibreRentACar;  -- Crea base de datos en el caso de que no exista

GO
USE RutaLibreRentACar;
GO
-- ==========================================================
------------------ CREACION DE LAS TABLAS -------------------
-- ==========================================================

IF OBJECT_ID('dbo.DetalleServicio','U') IS NOT NULL DROP TABLE dbo.DetalleServicio;
IF OBJECT_ID('dbo.ServicioAdicional','U') IS NOT NULL DROP TABLE dbo.ServicioAdicional;
IF OBJECT_ID('dbo.DetalleReserva','U') IS NOT NULL DROP TABLE dbo.DetalleReserva;
IF OBJECT_ID('dbo.Garantia','U') IS NOT NULL DROP TABLE dbo.Garantia;
IF OBJECT_ID('dbo.Reserva','U') IS NOT NULL DROP TABLE dbo.Reserva;
IF OBJECT_ID('dbo.Tarifa','U') IS NOT NULL DROP TABLE dbo.Tarifa;
IF OBJECT_ID('dbo.Vehiculo','U') IS NOT NULL DROP TABLE dbo.Vehiculo;
IF OBJECT_ID('dbo.Categoria','U') IS NOT NULL DROP TABLE dbo.Categoria;
IF OBJECT_ID('dbo.Sucursal','U') IS NOT NULL DROP TABLE dbo.Sucursal;
IF OBJECT_ID('dbo.ClienteTelefono','U') IS NOT NULL DROP TABLE dbo.ClienteTelefono;
IF OBJECT_ID('dbo.ClienteEmail','U') IS NOT NULL DROP TABLE dbo.ClienteEmail;
IF OBJECT_ID('dbo.Cliente','U') IS NOT NULL DROP TABLE dbo.Cliente;
IF OBJECT_ID('dbo.CategoriaCliente','U') IS NOT NULL DROP TABLE dbo.CategoriaCliente;
IF OBJECT_ID('dbo.Alerta','U') IS NOT NULL DROP TABLE dbo.Alerta;
GO

---- Creación tabla: CategoriaCliente
CREATE TABLE CategoriaCliente (
    idCategoriaCliente INT IDENTITY(1,1) PRIMARY KEY,
    nombreCatCliente VARCHAR(50) NOT NULL,
    puntosMinimos INT NOT NULL,
    puntosMaximos INT NOT NULL,
    descuento DECIMAL(5,2) CHECK (descuento >= 0 AND descuento<=100),
    CHECK (puntosMinimos <= puntosMaximos)
);
GO

-- Creación tabla: Cliente
CREATE TABLE Cliente (
    idCliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    estadoCliente VARCHAR(20) NOT NULL CHECK (estadoCliente IN ('Activo', 'Moroso', 'Inactivo')),
    puntosAcumulados INT DEFAULT 0,
    idCategoriaCliente INT NOT NULL,
    FOREIGN KEY (idCategoriaCliente) REFERENCES CategoriaCliente(idCategoriaCliente)
);
GO

-- Creación tabla: ClienteEmail (para almacenar atributo multivaluado)
CREATE TABLE ClienteEmail (
    idEmail INT IDENTITY (1,1) PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    idCliente INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);
GO

-- Creación tabla: ClienteTelefono (para almacenar atributo multivaluado)
CREATE TABLE ClienteTelefono (
    idTelefono INT IDENTITY (1,1) PRIMARY KEY,
    telefono VARCHAR(30),
    idCliente INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);
GO

-- Creación tabla: Sucursal
CREATE TABLE Sucursal (
    idSucursal INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    tipoSucursal VARCHAR(20) CHECK (tipoSucursal IN ('Retiro', 'Devolucion', 'Mixta'))
);
GO

-- Creación tabla: Categoria
CREATE TABLE Categoria (
    idCategoria INT IDENTITY(1,1) PRIMARY KEY,
    nombreCategoria VARCHAR(50) NOT NULL,
    capPasajeros INT CHECK (capPasajeros > 0),
    transmisionPreferente VARCHAR(20),
    prioridadReserva INT
);
GO

-- Creación tabla: Vehiculo
CREATE TABLE Vehiculo (
    patenteVehiculo VARCHAR(10) PRIMARY KEY,
    idSucursal INT NOT NULL,
    idCategoria INT NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio INT CHECK (anio >= 1990),
    kilometraje INT DEFAULT 0,
    estadoOperativo VARCHAR(30) CHECK (estadoOperativo IN ('Disponible', 'Fuera de Servicio', 'Inactivo')),
    FOREIGN KEY (idSucursal) REFERENCES Sucursal(idSucursal),
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
);
GO

-- Creación tabla: Tarifa
CREATE TABLE Tarifa (
    idTarifa INT IDENTITY(1,1) PRIMARY KEY,
    idCategoria INT NOT NULL,
    temporada VARCHAR(20) CHECK (temporada IN ('Alta', 'Media', 'Baja')),
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    precioBase DECIMAL(10,2) NOT NULL,
    precioPorDia DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
);
GO

-- Creación tabla: Reserva
CREATE TABLE Reserva (
    idReserva INT IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    idSucursalRetiro INT NOT NULL,
    idSucursalDevolucion INT NOT NULL,
    fechaCreacion DATETIME NOT NULL,
    fechaRetiro DATETIME NOT NULL,
    fechaDevolucion DATETIME NOT NULL,
    estadoReserva VARCHAR(20) CHECK (estadoReserva IN ('Pendiente', 'Confirmada', 'Anulada')),
    totalReserva DECIMAL(10,2),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (idSucursalRetiro) REFERENCES Sucursal(idSucursal),
    FOREIGN KEY (idSucursalDevolucion) REFERENCES Sucursal(idSucursal)
);
GO

-- Creación tabla: Garantia
CREATE TABLE Garantia (
    idGarantia INT IDENTITY(1,1) PRIMARY KEY,
    idReserva INT UNIQUE,
    montoGarantia DECIMAL(10,2) NOT NULL,
    estadoGarantia VARCHAR(30) CHECK (estadoGarantia IN ('Retenida', 'Liberada', 'Usada Parcialmente')),
    FOREIGN KEY (idReserva) REFERENCES Reserva(idReserva)
);
GO

-- Creación tabla: DetalleReserva
CREATE TABLE DetalleReserva (
    idDetalle INT IDENTITY(1,1) PRIMARY KEY,
    idReserva INT NOT NULL,
    patenteVehiculo VARCHAR(10) NOT NULL,
    precioPorDia DECIMAL(10,2) NOT NULL,
    cantidadDias INT CHECK (cantidadDias > 0),
    subtotalDetalle DECIMAL(10,2),
    FOREIGN KEY (idReserva) REFERENCES Reserva(idReserva),
    FOREIGN KEY (patenteVehiculo) REFERENCES Vehiculo(patenteVehiculo)
);
GO

-- Creación tabla: ServicioAdicional
CREATE TABLE ServicioAdicional (
    idServicio INT IDENTITY(1,1) PRIMARY KEY,
    nombreServicio VARCHAR(100) NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    cupoDiario INT CHECK (cupoDiario >= 0)
);
GO

-- Creación tabla: DetalleServicio (intermedia N:M)
CREATE TABLE DetalleServicio (
    idReserva INT NOT NULL,
    idServicio INT NOT NULL,
    cantidad INT CHECK (cantidad > 0),
    subtotal DECIMAL(10,2),
    PRIMARY KEY (idReserva, idServicio),
    FOREIGN KEY (idReserva) REFERENCES Reserva(idReserva),
    FOREIGN KEY (idServicio) REFERENCES ServicioAdicional(idServicio)
);
GO

-- Creación tabla: Alerta --> NO ES ENTIDAD, solo funciona como un registro de las incidencias
CREATE TABLE Alerta (
    idAlerta INT IDENTITY(1,1) PRIMARY KEY,
    tipoAlerta VARCHAR(50),
    descripcion VARCHAR(255),
    fechaAlerta DATETIME DEFAULT GETDATE(),
    idReserva INT NULL,
    idVehiculo VARCHAR(10) NULL
);
GO
