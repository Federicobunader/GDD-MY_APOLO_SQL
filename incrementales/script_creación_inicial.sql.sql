USE GD2C2020
GO


BEGIN TRY
    BEGIN TRAN

IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'MY_APOLO_SQL')) 
BEGIN
    EXEC ('CREATE SCHEMA [MY_APOLO_SQL] AUTHORIZATION [dbo]')
END
-------------------CREACION TABLAS---------------------------
CREATE TABLE MY_APOLO_SQL.Ciudad(
	ciud_id_ciudad NUMERIC(6) IDENTITY (1,1) NOT NULL ,
	ciud_nombre nvarchar(255) NOT NULL ,

	CONSTRAINT PK_Ciudad PRIMARY KEY (ciud_id_ciudad),
);
CREATE TABLE MY_APOLO_SQL.Sucursal(
	sucu_id_sucursal NUMERIC(6) IDENTITY(1,1) NOT NULL , 
	sucu_mail NVARCHAR(255),
	sucu_telefono DECIMAL(18,0),
	sucu_direccion NVARCHAR(255),

	CONSTRAINT PK_Sucursal PRIMARY KEY (sucu_id_sucursal),

	sucu_ciud_id_ciudad NUMERIC(6) CONSTRAINT sucu_ciud_id_ciudad FOREIGN KEY (sucu_ciud_id_ciudad) REFERENCES MY_APOLO_SQL.Ciudad(ciud_id_ciudad)
);

CREATE TABLE MY_APOLO_SQL.Modelo(
	mode_id_modelo NUMERIC(6) IDENTITY,
	mode_codigo DECIMAL(18,0) ,
	mode_nombre NVARCHAR(255) ,
	mode_potencia DECIMAL(18,0) ,

	CONSTRAINT PK_Modelo PRIMARY KEY (mode_id_modelo),
);

CREATE TABLE MY_APOLO_SQL.Fabricante(
	fabr_id_fabricante NUMERIC(6) IDENTITY (1,1) NOT NULL ,
	fabr_nombre nvarchar(255) NOT NULL ,

	CONSTRAINT PK_Fabricante PRIMARY KEY (fabr_id_fabricante),
);

CREATE TABLE MY_APOLO_SQL.Tipo_Transmision(
	tipo_tran_id_tipo_transmision NUMERIC(6) IDENTITY,
	tipo_tran_codigo DECIMAL(18,0) ,
	tipo_tran_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Transmision PRIMARY KEY (tipo_tran_id_tipo_transmision)
);


CREATE TABLE MY_APOLO_SQL.Tipo_Motor(
	tipo_moto_id_tipo_motor NUMERIC(6) IDENTITY,
	tipo_moto_codigo DECIMAL(18,0) ,

	CONSTRAINT PK_Tipo_Motor PRIMARY KEY (tipo_moto_id_tipo_motor)
);

CREATE TABLE MY_APOLO_SQL.Tipo_Auto(
	tipo_auto_id_tipo_auto NUMERIC(6) IDENTITY,
	tipo_auto_codigo DECIMAL(18,0) ,
	tipo_auto_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Auto PRIMARY KEY (tipo_auto_id_tipo_auto)
);

CREATE TABLE MY_APOLO_SQL.Tipo_Caja(
	tipo_caja_id_tipo_caja NUMERIC(6) IDENTITY,
	tipo_caja_codigo DECIMAL(18,0) ,
	tipo_caja_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Caja PRIMARY KEY (tipo_caja_id_tipo_caja)
);



CREATE TABLE MY_APOLO_SQL.Auto(
	auto_id_auto NUMERIC(6) IDENTITY(1,1) NOT NULL ,
	auto_detalle_patente NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,
	auto_vendido BIT default 0,  --0 significa que no se vendio
	auto_precio DECIMAL(18,2),
	auto_nro_chasis NVARCHAR(50),
    auto_nro_motor NVARCHAR(50),
	

	CONSTRAINT PK_Auto PRIMARY KEY (auto_id_auto),
	auto_fabr_id_fabricante NUMERIC(6) not null CONSTRAINT auto_fabr_id_fabricante FOREIGN KEY (auto_fabr_id_fabricante) REFERENCES MY_APOLO_SQL.Fabricante(fabr_id_fabricante),
	auto_mode_id_modelo NUMERIC(6) not null CONSTRAINT auto_mode_id_modelo FOREIGN KEY (auto_mode_id_modelo) REFERENCES MY_APOLO_SQL.Modelo(mode_id_modelo),
	auto_tipo_caja_id_tipo_caja NUMERIC(6) not null CONSTRAINT auto_tipo_caja_id_tipo_caja FOREIGN KEY (auto_tipo_caja_id_tipo_caja) REFERENCES MY_APOLO_SQL.Tipo_Caja(tipo_caja_id_tipo_caja),
    auto_tipo_auto_id_tipo_auto NUMERIC(6) not null CONSTRAINT auto_tipo_auto_id_tipo_auto FOREIGN KEY (auto_tipo_auto_id_tipo_auto) REFERENCES MY_APOLO_SQL.Tipo_Auto(tipo_auto_id_tipo_auto),
    auto_tipo_trans_id_tipo_transimision NUMERIC(6) not null CONSTRAINT auto_tipo_trans_id_tipo_transimision FOREIGN KEY (auto_tipo_trans_id_tipo_transimision) REFERENCES MY_APOLO_SQL.Tipo_Transmision(tipo_tran_id_tipo_transmision),
    auto_tipo_moto_id_tipo_moto NUMERIC(6) not null CONSTRAINT auto_tipo_moto_id_tipo_moto FOREIGN KEY (auto_tipo_moto_id_tipo_moto) REFERENCES MY_APOLO_SQL.Tipo_Motor(tipo_moto_id_tipo_motor)
);

CREATE TABLE MY_APOLO_SQL.Auto_Parte(
	part_id_auto_parte NUMERIC(6) IDENTITY(1,1) NOT NULL  ,
	part_cantidad_stock DECIMAL(18,0),
	part_precio DECIMAL(18,2) ,
	part_codigo DECIMAL(18,0) ,
	part_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Auto_Parte PRIMARY KEY (part_id_auto_parte),
	part_fabricante_id NUMERIC(6) NOT NULL CONSTRAINT FK_part_fabricante_id FOREIGN KEY (part_fabricante_id) REFERENCES MY_APOLO_SQL.Fabricante(fabr_id_fabricante),
	part_modelo_id NUMERIC(6) NOT NULL CONSTRAINT FK_part_modelo_id FOREIGN KEY (part_modelo_id) REFERENCES MY_APOLO_SQL.Modelo(mode_id_modelo)
);

CREATE TABLE MY_APOLO_SQL.Cliente(
	clie_id_cliente NUMERIC(6) IDENTITY(1,1) NOT NULL , 
	clie_nombre NVARCHAR(255) ,
	clie_apellido NVARCHAR(255) ,
	clie_direccion NVARCHAR(255) ,
	clie_dni DECIMAL (18,0) ,
	clie_fecha_nacimiento DATETIME2 (3),
	clie_mail NVARCHAR(255),

  CONSTRAINT PK_Cliente PRIMARY KEY (clie_id_cliente),
  CONSTRAINT UC_Cliente UNIQUE (clie_apellido,clie_dni)
);

CREATE TABLE MY_APOLO_SQL.Factura(
	fact_id_factura NUMERIC(6) IDENTITY, 
	fact_fecha DATETIME2(3),
	fact_numero DECIMAL(18,0),
	fact_precio_facturado DECIMAL(18,2),

	CONSTRAINT PK_Factura PRIMARY KEY (fact_id_factura),
	fact_clie_id_cliente NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Cliente(clie_id_cliente),
	fact_sucu_id_sucursal NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Sucursal(sucu_id_sucursal),
	fact_auto_id_auto NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Auto(auto_id_auto)
);

CREATE TABLE MY_APOLO_SQL.Compra(
	comp_id_compra NUMERIC(6) IDENTITY(1,1) NOT NULL,
	comp_fecha DATETIME2(3), 
	comp_numero DECIMAL(18,0),
	comp_precio_compra DECIMAL(18,2),

	CONSTRAINT PK_Compra PRIMARY KEY (comp_id_compra),
	comp_clie_id_cliente NUMERIC(6) CONSTRAINT FK_comp_clie_id_cliente FOREIGN KEY (comp_clie_id_cliente) REFERENCES MY_APOLO_SQL.Cliente(clie_id_cliente),
	comp_sucu_id_sucursal NUMERIC (6) CONSTRAINT FK_comp_sucu_id_sucursal FOREIGN KEY (comp_sucu_id_sucursal) REFERENCES MY_APOLO_SQL.Sucursal(sucu_id_sucursal),
	comp_auto_id_auto NUMERIC (6) CONSTRAINT FK_comp_auto_id_auto FOREIGN KEY (comp_auto_id_auto) REFERENCES MY_APOLO_SQL.Auto(auto_id_auto)

);

CREATE TABLE MY_APOLO_SQL.Compra_Auto_Parte(
	comp_auto_parte_id NUMERIC(6) IDENTITY(1,1) NOT NULL,
	comp_part_cantidad DECIMAL(18,0)

	CONSTRAINT PK_Compra_Auto_Parte PRIMARY KEY (comp_auto_parte_id),
	comp_part_part_id_auto_parte NUMERIC(6) CONSTRAINT FK_comp_part_part_id_auto_parte FOREIGN KEY (comp_part_part_id_auto_parte) REFERENCES MY_APOLO_SQL.Auto_Parte(part_id_auto_parte),
	comp_part_comp_id_compra NUMERIC(6), CONSTRAINT FK_comp_part_comp_id_compra FOREIGN KEY (comp_part_comp_id_compra) REFERENCES MY_APOLO_SQL.Compra(comp_id_compra)

);

CREATE TABLE MY_APOLO_SQL.Factura_Auto_Parte(
	fact_auto_parte_id NUMERIC(6) IDENTITY(1,1) NOT NULL,
	fact_part_fact_id_factura NUMERIC(6), 
	fact_part_part_id_auto_parte NUMERIC(6),
	fact_part_cantidad DECIMAL(18,0)

	CONSTRAINT PK_Factura_Auto_Parte PRIMARY KEY (fact_auto_parte_id),
	CONSTRAINT FK_fact_part_part_id_auto_parte FOREIGN KEY (fact_part_part_id_auto_parte) REFERENCES MY_APOLO_SQL.Auto_Parte(part_id_auto_parte),
	CONSTRAINT FK_fact_part_fact_id_factura FOREIGN KEY (fact_part_fact_id_factura) REFERENCES MY_APOLO_SQL.Factura(fact_id_factura)

)
	PRINT 'Tablas Creadas Correctamente'
  COMMIT TRAN
END TRY

BEGIN CATCH
    ROLLBACK TRAN

    DECLARE @Problema VARCHAR(MAX)
    SELECT @Problema = 'Ocurrió un problema en el script SQL: Numero ' + CONVERT(VARCHAR(10),ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE() + ' - Linea: ' +  CONVERT(VARCHAR(10),ERROR_LINE())
    RAISERROR(@Problema, 16,1)
END CATCH
GO
-------------------CREACION PROCEDIMIENTOS---------------------------

CREATE PROCEDURE Migracion_Ciudad
AS
	INSERT INTO MY_APOLO_SQL.Ciudad(ciud_nombre) 
	SELECT DISTINCT SUCURSAL_CIUDAD
	FROM gd_esquema.Maestra 
	WHERE SUCURSAL_CIUDAD IS NOT NULL
GO

CREATE PROCEDURE Migracion_Sucursal
AS
INSERT INTO MY_APOLO_SQL.Sucursal(sucu_mail,sucu_telefono,sucu_direccion,sucu_ciud_id_ciudad) 
SELECT DISTINCT SUCURSAL_MAIL,SUCURSAL_TELEFONO,SUCURSAL_DIRECCION,
(SELECT TOP 1 ciud_id_ciudad 
	FROM MY_APOLO_SQL.Ciudad C1
WHERE C1.ciud_nombre = Maestra.SUCURSAL_CIUDAD)
FROM gd_esquema.Maestra
WHERE SUCURSAL_MAIL IS NOT NULL
GO

CREATE PROCEDURE Migracion_Fabricante
AS
INSERT INTO MY_APOLO_SQL.Fabricante(fabr_nombre) 
SELECT DISTINCT FABRICANTE_NOMBRE
FROM gd_esquema.Maestra
WHERE FABRICANTE_NOMBRE IS NOT NULL
GO

CREATE PROCEDURE Migracion_Modelo
AS
INSERT INTO MY_APOLO_SQL.Modelo(mode_codigo,mode_nombre,mode_potencia) 
SELECT DISTINCT MODELO_CODIGO,MODELO_NOMBRE,MODELO_POTENCIA
FROM gd_esquema.Maestra
WHERE MODELO_CODIGO IS NOT NULL
GO

CREATE PROCEDURE Migracion_Tipo_Transmision
AS
INSERT INTO MY_APOLO_SQL.Tipo_Transmision(tipo_tran_codigo,tipo_tran_descripcion) 
SELECT DISTINCT TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC 
FROM gd_esquema.Maestra
WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL
GO

CREATE PROCEDURE Migracion_Tipo_Motor
AS
INSERT INTO MY_APOLO_SQL.Tipo_Motor(tipo_moto_codigo) 
SELECT DISTINCT TIPO_MOTOR_CODIGO
FROM gd_esquema.Maestra
WHERE TIPO_MOTOR_CODIGO IS NOT NULL ORDER BY TIPO_MOTOR_CODIGO ASC
GO

CREATE PROCEDURE Migracion_Tipo_Auto
AS
INSERT INTO MY_APOLO_SQL.Tipo_Auto(tipo_auto_codigo,tipo_auto_descripcion) 
SELECT DISTINCT TIPO_AUTO_CODIGO,TIPO_AUTO_DESC
FROM gd_esquema.Maestra
WHERE TIPO_AUTO_CODIGO IS NOT NULL
GO

CREATE PROCEDURE Migracion_Tipo_Caja
AS
INSERT INTO MY_APOLO_SQL.Tipo_Caja(tipo_caja_codigo,tipo_caja_descripcion) 
SELECT DISTINCT TIPO_CAJA_CODIGO,TIPO_CAJA_DESC
FROM gd_esquema.Maestra
WHERE TIPO_CAJA_CODIGO IS NOT NULL
GO


CREATE PROCEDURE Migracion_Auto_Parte
AS
INSERT INTO MY_APOLO_SQL.Auto_Parte (
	part_modelo_id 
	,part_cantidad_stock
	,part_precio
	,part_codigo 
	,part_descripcion 
	,part_fabricante_id )

SELECT   
(
SELECT TOP 1 mode_id_modelo 
FROM MY_APOLO_SQL.Modelo AS Modelo WHERE Modelo.mode_nombre = Maestra.MODELO_NOMBRE),
sum(COALESCE(COMPRA_CANT,0)) - (SELECT sum(COALESCE(CANT_FACTURADA,0)) from gd_esquema.Maestra as Vendidas 
WHERE FACTURA_NRO IS NOT NULL AND Vendidas.AUTO_PARTE_CODIGO = Maestra.AUTO_PARTE_CODIGO  
GROUP BY AUTO_PARTE_CODIGO ) as Stock,
COMPRA_PRECIO * 1.2,
AUTO_PARTE_CODIGO, 
AUTO_PARTE_DESCRIPCION,
(SELECT TOP 1 fabr_id_fabricante FROM MY_APOLO_SQL.Fabricante AS Fabricante 
WHERE Fabricante.fabr_nombre = Maestra.FABRICANTE_NOMBRE)
FROM gd_esquema.Maestra as Maestra
WHERE COMPRA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NOT NULL
GROUP BY AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION, MODELO_CODIGO,COMPRA_PRECIO,MODELO_NOMBRE,FABRICANTE_NOMBRE

GO


CREATE PROCEDURE Migracion_Cliente
AS
INSERT INTO MY_APOLO_SQL.Cliente (
    clie_nombre,
    clie_apellido,
    clie_direccion,
    clie_dni,
    clie_fecha_nacimiento,
    clie_mail)
SELECT DISTINCT CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_DNI, CLIENTE_FECHA_NAC, CLIENTE_MAIL
FROM gd_esquema.Maestra
WHERE CLIENTE_DNI IS NOT NULL
UNION
SELECT DISTINCT FAC_CLIENTE_NOMBRE, FAC_CLIENTE_APELLIDO, FAC_CLIENTE_DIRECCION, FAC_CLIENTE_DNI, FAC_CLIENTE_FECHA_NAC, FAC_CLIENTE_MAIL
FROM gd_esquema.Maestra
WHERE FAC_CLIENTE_DNI IS NOT NULL

GO

CREATE PROCEDURE Migracion_Factura
AS
INSERT INTO MY_APOLO_SQL.Factura (fact_fecha,fact_numero,fact_precio_facturado,fact_clie_id_cliente,fact_sucu_id_sucursal,fact_auto_id_auto)
SELECT
DISTINCT
FACTURA_FECHA,
FACTURA_NRO,
PRECIO_FACTURADO,
clie_id_cliente,
sucu_id_sucursal,
auto_id_auto
 FROM gd_esquema.Maestra 
 JOIN MY_APOLO_SQL.Cliente as cli on FAC_CLIENTE_DNI = cli.clie_dni
 JOIN MY_APOLO_SQL.Sucursal as sucu on FAC_SUCURSAL_DIRECCION = sucu.sucu_direccion
 LEFT JOIN MY_APOLO_SQL.Auto AS Auto ON AUTO_PATENTE = auto.auto_detalle_patente
where FACTURA_NRO IS NOT NULL
ORDER BY FACTURA_NRO

GO

CREATE PROCEDURE Migracion_Factura_Auto_Parte
AS
INSERT INTO MY_APOLO_SQL.Factura_Auto_Parte (fact_part_fact_id_factura,fact_part_part_id_auto_parte,fact_part_cantidad)
SELECT
(SELECT TOP 1 fact_id_factura FROM MY_APOLO_SQL.Factura F
WHERE F.fact_numero = FACTURA_NRO AND F.fact_fecha = FACTURA_FECHA),
(SELECT TOP 1 part_id_auto_parte FROM MY_APOLO_SQL.Auto_Parte AP
WHERE AP.part_codigo = AUTO_PARTE_CODIGO AND AP.part_descripcion = AUTO_PARTE_DESCRIPCION),
CANT_FACTURADA
FROM gd_esquema.Maestra

GO


CREATE PROCEDURE Migracion_Compra
AS
INSERT INTO MY_APOLO_SQL.Compra (comp_fecha,comp_numero,comp_precio_compra,comp_clie_id_cliente,comp_sucu_id_sucursal,comp_auto_id_auto)
--Compra AutoParte
SELECT compra_fecha,COMPRA_NRO, SUM(COMPRA_PRECIO) AS precio,  cliente.clie_id_cliente, sucursal.sucu_id_sucursal,NULL AS auto_id
FROM gd_esquema.Maestra JOIN MY_APOLO_SQL.Sucursal ON SUCURSAL_DIRECCION = sucu_direccion
JOIN MY_APOLO_SQL.Cliente ON CLIENTE_DNI = clie_dni AND CLIENTE_APELLIDO = clie_apellido
WHERE  COMPRA_NRO IS NOT NULL AND AUTO_PATENTE IS NULL
GROUP BY COMPRA_NRO, compra_fecha, sucursal.sucu_id_sucursal, cliente.clie_id_cliente
UNION
--Compra Auto
SELECT compra_fecha,COMPRA_NRO, COMPRA_PRECIO AS precio, cliente.clie_id_cliente, sucursal.sucu_id_sucursal, auto.auto_id_auto AS auto_id
FROM gd_esquema.Maestra JOIN MY_APOLO_SQL.Auto ON AUTO_PATENTE = auto_detalle_patente
JOIN MY_APOLO_SQL.Sucursal ON SUCURSAL_DIRECCION = sucu_direccion
JOIN MY_APOLO_SQL.Cliente ON CLIENTE_DNI = clie_dni AND CLIENTE_APELLIDO = clie_apellido
WHERE  COMPRA_NRO IS NOT NULL AND AUTO_PATENTE IS NOT NULL
GROUP BY COMPRA_NRO, compra_fecha, sucursal.sucu_id_sucursal, cliente.clie_id_cliente, auto_id_auto, COMPRA_PRECIO

GO

CREATE PROCEDURE Migracion_Compra_Auto_Parte
AS
INSERT INTO MY_APOLO_SQL.Compra_Auto_Parte (comp_part_comp_id_compra, comp_part_part_id_auto_parte, comp_part_cantidad)
SELECT comp_id_compra,part_id_auto_parte, COMPRA_CANT FROM gd_esquema.Maestra JOIN MY_APOLO_SQL.Compra ON COMPRA_NRO = comp_numero
JOIN MY_APOLO_SQL.Auto_Parte ON AUTO_PARTE_CODIGO = auto_parte.part_codigo
WHERE COMPRA_NRO is not null AND AUTO_PARTE_CODIGO is not null

GO

--ToDO: Revisar el Procedure
CREATE PROCEDURE Migracion_Auto
AS
BEGIN
CREATE TABLE MY_APOLO_SQL.#Autos_Vendidos(
	auto_id_auto NUMERIC(6) IDENTITY(1,1) NOT NULL ,
	auto_detalle_patente NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,
	auto_vendido BIT default 1,  --0 significa que no se vendio
	auto_precio DECIMAL(18,2),
	auto_nro_chasis NVARCHAR(50),
    auto_nro_motor NVARCHAR(50),

	CONSTRAINT PK_Autos_Vendidos PRIMARY KEY (auto_id_auto)
);

CREATE TABLE MY_APOLO_SQL.#Autos_Totales(
	auto_id_auto NUMERIC(6) IDENTITY(1,1) NOT NULL ,
	auto_detalle_patente NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,
	auto_vendido BIT default 1,  --0 significa que no se vendio
	auto_precio DECIMAL(18,2),
	auto_nro_chasis NVARCHAR(50),
    auto_nro_motor NVARCHAR(50),
	
	CONSTRAINT PK_Autos_Totales PRIMARY KEY (auto_id_auto)
);



INSERT INTO 
MY_APOLO_SQL.Auto(
auto_detalle_patente,
auto_fecha_alta,
auto_cantidad_kilometros,
auto_vendido,
auto_precio,
auto_nro_chasis,
auto_nro_motor,
auto_fabr_id_fabricante,
auto_mode_id_modelo,
auto_tipo_caja_id_tipo_caja,
auto_tipo_auto_id_tipo_auto,
auto_tipo_trans_id_tipo_transimision,
auto_tipo_moto_id_tipo_moto) 

SELECT DISTINCT 
AUTO_PATENTE,
AUTO_FECHA_ALTA,
AUTO_CANT_KMS,
 1,
COMPRA_PRECIO * 1.2,
AUTO_NRO_CHASIS,
AUTO_NRO_MOTOR,

(SELECT TOP 1 fabr_id_fabricante 
FROM MY_APOLO_SQL.Fabricante AS Fabricante
WHERE Maestra.FABRICANTE_NOMBRE =  Fabricante.fabr_nombre), -- REVISAR

(SELECT TOP 1 mode_id_modelo 
	FROM MY_APOLO_SQL.Modelo  as ModeloTbl
WHERE ModeloTbl.mode_nombre = Maestra.MODELO_NOMBRE),

(SELECT TOP 1 tipo_caja_id_tipo_caja 
	FROM MY_APOLO_SQL.Tipo_Caja  as tc
WHERE tc.tipo_caja_codigo = Maestra.TIPO_CAJA_CODIGO),

(SELECT TOP 1 tipo_auto_id_tipo_auto 
	FROM MY_APOLO_SQL.Tipo_Auto  as ta
WHERE ta.tipo_auto_codigo = Maestra.TIPO_AUTO_CODIGO),

(SELECT TOP 1 tipo_tran_id_tipo_transmision 
	FROM MY_APOLO_SQL.Tipo_Transmision  as tt
WHERE tt.tipo_tran_codigo = Maestra.TIPO_TRANSMISION_CODIGO),

(SELECT TOP 1 tipo_moto_id_tipo_motor 
	FROM MY_APOLO_SQL.Tipo_Motor  as tm
WHERE tm.tipo_moto_codigo = Maestra.TIPO_MOTOR_CODIGO)


FROM gd_esquema.Maestra AS Maestra
WHERE AUTO_PATENTE IS NOT NULL AND PRECIO_FACTURADO IS NULL

INSERT INTO MY_APOLO_SQL.#Autos_Vendidos(
auto_detalle_patente,
auto_fecha_alta,
auto_cantidad_kilometros,
auto_vendido,
auto_precio,
auto_nro_chasis,
auto_nro_motor
) 

SELECT DISTINCT 

AUTO_PATENTE,
AUTO_FECHA_ALTA,
AUTO_CANT_KMS,
1,
COMPRA_PRECIO * 1.2,
AUTO_NRO_CHASIS,
AUTO_NRO_MOTOR

FROM gd_esquema.Maestra 
WHERE AUTO_PATENTE IS NOT NULL AND PRECIO_FACTURADO IS NOT NULL

INSERT INTO MY_APOLO_SQL.#Autos_Totales(
auto_detalle_patente,
auto_fecha_alta,
auto_cantidad_kilometros,
auto_vendido,
auto_precio,
auto_nro_chasis,
auto_nro_motor
) 

SELECT DISTINCT 

AUTO_PATENTE,
AUTO_FECHA_ALTA,
AUTO_CANT_KMS,
0,
COMPRA_PRECIO * 1.2 AS Precio,
AUTO_NRO_CHASIS,
AUTO_NRO_MOTOR

FROM gd_esquema.Maestra 
WHERE AUTO_PATENTE IS NOT NULL AND PRECIO_FACTURADO IS NULL

----------------------ACTUALIZO BIT DE VENDIDO EN AUTO--------------------------

UPDATE MY_APOLO_SQL.Auto SET auto_vendido = 0 FROM MY_APOLO_SQL.Auto WHERE auto_detalle_patente IN 
(
	SELECT auto_detalle_patente FROM MY_APOLO_SQL.#Autos_Totales
	EXCEPT
	SELECT auto_detalle_patente FROM MY_APOLO_SQL.#Autos_Vendidos
);


---------------------DROPEO DE TABLAS-------------------------


DROP TABLE MY_APOLO_SQL.#Autos_Vendidos;
DROP TABLE MY_APOLO_SQL.#Autos_Totales;

END

GO

PRINT 'Procedures Creados Correctamente'
BEGIN TRY
    BEGIN TRAN
--Migracion de Datos

EXEC Migracion_Ciudad --OK
EXEC Migracion_Sucursal --OK
EXEC Migracion_Fabricante --OK
EXEC Migracion_Modelo --OK
EXEC Migracion_Tipo_Transmision --OK
EXEC Migracion_Tipo_Motor --OK
EXEC Migracion_Tipo_Auto --OK
EXEC Migracion_Tipo_Caja --OK
EXEC Migracion_Auto_Parte --OK
EXEC Migracion_Cliente --OK
EXEC Migracion_Auto --OK
EXEC Migracion_Factura --OK
EXEC Migracion_Factura_Auto_Parte --OK
EXEC Migracion_Compra --OK
EXEC Migracion_Compra_Auto_Parte --OK


    COMMIT TRAN
END TRY

BEGIN CATCH
    ROLLBACK TRAN

    DECLARE @Problema VARCHAR(MAX)
    SELECT @Problema = 'Ocurrió un problema en el script SQL: Numero ' + CONVERT(VARCHAR(10),ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE() + ' - Linea: ' +  CONVERT(VARCHAR(10),ERROR_LINE())
    RAISERROR(@Problema, 16,1)
END CATCH

/*
drop table MY_APOLO_SQL.Compra_Auto_Parte,MY_APOLO_SQL.Compra,MY_APOLO_SQL.Factura_Auto_Parte,MY_APOLO_SQL.Factura,MY_APOLO_SQL.Auto,MY_APOLO_SQL.Auto_Parte,MY_APOLO_SQL.Fabricante,MY_APOLO_SQL.Sucursal,MY_APOLO_SQL.Tipo_Auto,MY_APOLO_SQL.Tipo_Caja,MY_APOLO_SQL.Tipo_Transmision,MY_APOLO_SQL.Cliente,MY_APOLO_SQL.Modelo,MY_APOLO_SQL.Tipo_Motor,MY_APOLO_SQL.Ciudad
drop procedure dbo.Migracion_Auto,dbo.Migracion_Auto_Parte,dbo.Migracion_Ciudad,dbo.Migracion_Cliente,dbo.Migracion_Compra,dbo.Migracion_Compra_Auto_Parte,dbo.Migracion_Fabricante,dbo.Migracion_Factura,dbo.Migracion_Factura_Auto_Parte,dbo.Migracion_Modelo,dbo.Migracion_Sucursal,dbo.Migracion_Tipo_Auto,dbo.Migracion_Tipo_Caja,dbo.Migracion_Tipo_Motor,dbo.Migracion_Tipo_Transmision

select * from MY_APOLO_SQL.Auto -> 71.946 autos

select * from MY_APOLO_SQL.Compra -> 72.504 compras

select * from MY_APOLO_SQL.Compra_Auto_Parte

*/

