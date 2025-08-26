
-- CREACIÓN DE BASE DE DATOS

CREATE DATABASE RetoDB;
GO
USE RetoDB;
GO


-- SEQUENCE para numeración de Facturas

CREATE SEQUENCE SeqFactura
    AS BIGINT
    START WITH 1
    INCREMENT BY 1;
GO


-- TABLA: Usuarios 

CREATE TABLE Usuarios (
    IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    IntentosFallidos INT NOT NULL DEFAULT 0,
    Bloqueado BIT NOT NULL DEFAULT 0,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO


-- TABLA: Familia de Productos

CREATE TABLE Familias (
    IdFamilia INT IDENTITY(1,1) PRIMARY KEY,
    Codigo NVARCHAR(15) NOT NULL UNIQUE,
    Nombre NVARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO


-- TABLA: Productos

CREATE TABLE Productos (
    IdProducto INT IDENTITY(1,1) PRIMARY KEY,
    Codigo NVARCHAR(15) NOT NULL UNIQUE,
    Nombre NVARCHAR(100) NOT NULL,
    IdFamilia INT NOT NULL,
    Precio DECIMAL(18,2) NOT NULL CHECK (Precio > 0),
    Stock INT NOT NULL CHECK (Stock >= 0),
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Productos_Familias FOREIGN KEY (IdFamilia)
        REFERENCES Familias(IdFamilia)
);
GO


-- TABLA: Factura 

CREATE TABLE Facturas (
    IdFactura INT IDENTITY(1,1) PRIMARY KEY,
    NumeroFactura BIGINT NOT NULL UNIQUE DEFAULT (NEXT VALUE FOR SeqFactura),
    RucCliente NVARCHAR(20) NOT NULL,
    RazonSocial NVARCHAR(200) NOT NULL,
    Subtotal DECIMAL(18,2) NOT NULL,
    PorcentajeIGV DECIMAL(5,2) NOT NULL,
    IGV DECIMAL(18,2) NOT NULL,
    Total DECIMAL(18,2) NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO


-- TABLA: Detalle de Factura

CREATE TABLE FacturaItems (
    IdItem INT IDENTITY(1,1) PRIMARY KEY,
    IdFactura INT NOT NULL,
    CodigoProducto NVARCHAR(15) NOT NULL,
    NombreProducto NVARCHAR(100) NOT NULL,
    Precio DECIMAL(18,2) NOT NULL CHECK (Precio > 0),
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    Subtotal DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_Detalle_Factura FOREIGN KEY (IdFactura)
        REFERENCES Facturas(IdFactura)
        ON DELETE CASCADE
);
GO
