USE GD2C2020
DECLARE @T1 varchar(20) = 'Transaction1';  
BEGIN TRAN @T1

CREATE TABLE Sucursal(
	sucu_id_sucursal NUMERIC(6) IDENTITY(1,1) NOT NULL , 
	sucu_mail NVARCHAR(255),
	sucu_telefono DECIMAL(18,0),
	sucu_direccion NVARCHAR(255),
	sucu_ciudad NVARCHAR(255),
	CONSTRAINT PK_Sucursal PRIMARY KEY (sucu_id_sucursal),
)

CREATE TABLE Fabricante(
	fabr_id_fabricante NUMERIC(6) IDENTITY ,
	fabr_descripcion NUMERIC(6) NOT NULL ,
	CONSTRAINT PK_Fabricante PRIMARY KEY (fabr_id_fabricante),
)


GO

-- rubro/categoria (caja, transmision, motor, chasis)
CREATE TABLE Categoria(
	categoria_id NUMERIC(6) IDENTITY(1,1) NOT NULL ,
	categoria_descripcion NVARCHAR(50) NOT NULL ,
	CONSTRAINT PK_Categoria PRIMARY KEY (categoria_id),
)

INSERT INTO Categoria VALUES('Caja')
INSERT INTO Categoria VALUES('Transmision')
INSERT INTO Categoria VALUES('Motor')
INSERT INTO Categoria VALUES('Chasis')

GO

--Auto
CREATE TABLE Auto(
	auto_id_auto NUMERIC(6) IDENTITY(1,1) NOT NULL , 
	auto_patente NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,
	auto_vendido BIT default 0,  --0 significa que no se vendio
	auto_precio DECIMAL(18,2),
	auto_fabricante NUMERIC(6) not null,
	auto_modelo NVARCHAR(100), --se podria parametrizar
	sucursal_id NUMERIC(6),
	CONSTRAINT PK_Auto PRIMARY KEY (auto_id_auto),
	CONSTRAINT auto_fabr_id_fabricante FOREIGN KEY  (auto_fabricante) REFERENCES Fabricante(fabr_id_fabricante),
	CONSTRAINT auto_sucu_id_sucursal FOREIGN KEY  (sucursal_id) REFERENCES Sucursal(sucu_id_sucursal)
)
GO
CREATE TABLE Auto_Parte(
	part_id_auto_parte NUMERIC(6) IDENTITY(1,1) NOT NULL  ,
	part_id_auto NUMERIC(6) NOT NULL ,
	part_vendida BIT default 0 ,  --0 significa que no se vendio
	part_precio DECIMAL(18,2) ,
	part_codigo DECIMAL(18,0) ,
	part_descripcion NVARCHAR(255) ,
	part_categoria NUMERIC(6) NOT NULL
	CONSTRAINT PK_Auto_Parte PRIMARY KEY (part_id_auto_parte),
	part_categoria_id_categoria NUMERIC(6) FOREIGN KEY  REFERENCES Categoria(categoria_id),
	part_auto_id_auto NUMERIC(6) FOREIGN KEY  REFERENCES Auto(auto_id_auto)
)

CREATE TABLE Cliente(
	clie_id_cliente NUMERIC(6) IDENTITY(1,1) NOT NULL , 
	clie_nombre NVARCHAR(255) ,
	clie_apellido NVARCHAR(255) ,
	clie_direccion NVARCHAR(255) ,
	clie_dni DECIMAL (18,0) ,
	clie_fecha_nacimiento DATETIME2 (3),
	clie_mail NVARCHAR(255),
  CONSTRAINT PK_Cliente PRIMARY KEY (clie_id_cliente)
)

COMMIT TRAN
ROLLBACK TRAN
