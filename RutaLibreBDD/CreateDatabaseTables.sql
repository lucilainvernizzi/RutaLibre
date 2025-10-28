-- BASE DE DATOS: RutaLibre Rent-a-Car

--CREATE DATABASE RutaLibreRentACar;

GO
USE RutaLibreRentACar;

GO
-- TABLA: CategoriaCliente
CREATE TABLE CategoriaCliente (
    idCategoriaCliente INT IDENTITY(1,1) PRIMARY KEY,
    nombreCatCliente VARCHAR(50) NOT NULL,
    puntosMinimos INT NOT NULL,
    puntosMaximos INT NOT NULL,
    descuento DECIMAL(5,2) CHECK (descuento >= 0)
);
GO

-- TABLA: Cliente
CREATE TABLE Cliente (
    idCliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(30),
    estadoCliente VARCHAR(20) CHECK (estadoCliente IN ('Activo', 'Moroso', 'Inactivo')),
    puntosAcumulados INT DEFAULT 0,
    idCategoriaCliente INT NOT NULL,
    FOREIGN KEY (idCategoriaCliente) REFERENCES CategoriaCliente(idCategoriaCliente)
);
GO

-- TABLA: Sucursal
CREATE TABLE Sucursal (
    idSucursal INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    tipoSucursal VARCHAR(20) CHECK (tipoSucursal IN ('Retiro', 'Devolucion', 'Mixta'))
);
GO

-- TABLA: Categoria
CREATE TABLE Categoria (
    idCategoria INT IDENTITY(1,1) PRIMARY KEY,
    nombreCategoria VARCHAR(50) NOT NULL,
    capPasajeros INT CHECK (capPasajeros > 0),
    transmisionPreferente VARCHAR(20),
    prioridadReserva INT
);
GO

-- TABLA: Vehiculo
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

-- TABLA: Tarifa
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

-- TABLA: Reserva
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

-- TABLA: Garantia
CREATE TABLE Garantia (
    idGarantia INT IDENTITY(1,1) PRIMARY KEY,
    idReserva INT UNIQUE,
    montoGarantia DECIMAL(10,2) NOT NULL,
    estadoGarantia VARCHAR(30) CHECK (estadoGarantia IN ('Retenida', 'Liberada', 'Usada Parcialmente')),
    FOREIGN KEY (idReserva) REFERENCES Reserva(idReserva)
);
GO

-- TABLA: DetalleReserva
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

-- TABLA: ServicioAdicional
CREATE TABLE ServicioAdicional (
    idServicio INT IDENTITY(1,1) PRIMARY KEY,
    nombreServicio VARCHAR(100) NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    cupoDiario INT CHECK (cupoDiario >= 0)
);
GO

-- TABLA: DetalleServicio (intermedia N:M)
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
