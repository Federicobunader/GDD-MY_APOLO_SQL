USE GD2C2020
CREATE SCHEMA MY_APOLO_SQL;
GO
DECLARE @T1 varchar(20) = 'Transaction1';  
BEGIN TRAN @T1

CREATE TABLE MY_APOLO_SQL.Sucursal(
	sucu_id_sucursal NUMERIC(6) IDENTITY(1,1) NOT NULL , 
	sucu_mail NVARCHAR(255),
	sucu_telefono DECIMAL(18,0),
	sucu_direccion NVARCHAR(255),
	sucu_ciudad NVARCHAR(255),

	CONSTRAINT PK_Sucursal PRIMARY KEY (sucu_id_sucursal),
)

TRUNCATE TABLE MY_APOLO_SQL.Sucursal

INSERT INTO MY_APOLO_SQL.Sucursal(sucu_mail,sucu_telefono,sucu_direccion,sucu_ciudad) 
SELECT DISTINCT SUCURSAL_MAIL,SUCURSAL_TELEFONO,SUCURSAL_DIRECCION,SUCURSAL_CIUDAD
FROM gd_esquema.Maestra
WHERE SUCURSAL_MAIL IS NOT NULL

GO

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Fabricante(
	fabr_id_fabricante NUMERIC(6) IDENTITY (1,1) NOT NULL ,
	fabr_nombre nvarchar(250) NOT NULL ,

	CONSTRAINT PK_Fabricante PRIMARY KEY (fabr_id_fabricante),
)

TRUNCATE TABLE MY_APOLO_SQL.Fabricante

INSERT INTO MY_APOLO_SQL.Fabricante(fabr_nombre) 
SELECT DISTINCT FABRICANTE_NOMBRE
FROM gd_esquema.Maestra
WHERE FABRICANTE_NOMBRE IS NOT NULL

GO

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Modelo(
	mode_id_modelo NUMERIC(6) IDENTITY,
	mode_codigo DECIMAL(18,0) ,
	mode_nombre NVARCHAR(255) ,
	mode_potencia DECIMAL(18,0) ,

	CONSTRAINT PK_Modelo PRIMARY KEY (mode_id_modelo),
)

TRUNCATE TABLE MY_APOLO_SQL.Modelo

INSERT INTO MY_APOLO_SQL.Modelo(mode_codigo,mode_nombre,mode_potencia) 
SELECT DISTINCT MODELO_CODIGO,MODELO_NOMBRE,MODELO_POTENCIA
FROM gd_esquema.Maestra
WHERE MODELO_CODIGO IS NOT NULL

GO

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Tipo_Transmision(
	tipo_tran_id_tipo_transmision NUMERIC(6) IDENTITY,
	tipo_tran_codigo DECIMAL(18,0) ,
	tipo_tran_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Transmision PRIMARY KEY (tipo_tran_id_tipo_transmision)
)

TRUNCATE TABLE MY_APOLO_SQL.Tipo_Transmision

INSERT INTO MY_APOLO_SQL.Tipo_Transmision(tipo_tran_codigo,tipo_tran_descripcion) 
SELECT DISTINCT TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC 
FROM gd_esquema.Maestra
WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL

GO

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Tipo_Motor(
	tipo_moto_id_tipo_motor NUMERIC(6) IDENTITY,
	tipo_moto_codigo DECIMAL(18,0) ,

	CONSTRAINT PK_Tipo_Motor PRIMARY KEY (tipo_moto_id_tipo_motor)
)

TRUNCATE TABLE MY_APOLO_SQL.Tipo_Motor

INSERT INTO MY_APOLO_SQL.Tipo_Motor(tipo_moto_codigo) 
SELECT DISTINCT TIPO_MOTOR_CODIGO
FROM gd_esquema.Maestra
WHERE TIPO_MOTOR_CODIGO IS NOT NULL

GO

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Tipo_Auto(
	tipo_auto_id_tipo_auto NUMERIC(6) IDENTITY,
	tipo_auto_codigo DECIMAL(18,0) ,
	tipo_auto_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Auto PRIMARY KEY (tipo_auto_id_tipo_auto)
)

TRUNCATE TABLE MY_APOLO_SQL.Tipo_Auto

INSERT INTO MY_APOLO_SQL.Tipo_Auto(tipo_auto_codigo,tipo_auto_descripcion) 
SELECT DISTINCT TIPO_AUTO_CODIGO,TIPO_AUTO_DESC
FROM gd_esquema.Maestra
WHERE TIPO_AUTO_CODIGO IS NOT NULL

GO

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Tipo_Caja(
	tipo_caja_id_tipo_caja NUMERIC(6) IDENTITY,
	tipo_caja_codigo DECIMAL(18,0) ,
	tipo_caja_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Caja PRIMARY KEY (tipo_caja_id_tipo_caja)
)

TRUNCATE TABLE MY_APOLO_SQL.Tipo_Caja

INSERT INTO MY_APOLO_SQL.Tipo_Caja(tipo_caja_codigo,tipo_caja_descripcion) 
SELECT DISTINCT TIPO_CAJA_CODIGO,TIPO_CAJA_DESC
FROM gd_esquema.Maestra
WHERE TIPO_CAJA_CODIGO IS NOT NULL

GO

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Auto(
	auto_id_auto NUMERIC(6) IDENTITY(1,1) NOT NULL ,
	auto_detalle_patente NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,
	auto_vendido BIT default 0,  --0 significa que no se vendio
	auto_precio DECIMAL(18,2),
	auto_fabr_id_fabricante NUMERIC(6) not null,
	auto_mode_id_modelo NUMERIC(6) not null, --se podria parametrizar
	auto_sucursal_id NUMERIC(6) not null,

	CONSTRAINT PK_Auto PRIMARY KEY (auto_id_auto),
	CONSTRAINT auto_fabr_id_fabricante FOREIGN KEY (auto_fabr_id_fabricante) REFERENCES MY_APOLO_SQL.Fabricante(fabr_id_fabricante),
	CONSTRAINT auto_mode_id_modelo FOREIGN KEY (auto_mode_id_modelo) REFERENCES MY_APOLO_SQL.Modelo(mode_id_modelo),
	CONSTRAINT auto_sucu_id_sucursal FOREIGN KEY (auto_sucursal_id) REFERENCES MY_APOLO_SQL.Sucursal(sucu_id_sucursal)
)


TRUNCATE TABLE MY_APOLO_SQL.Auto

--REVISAR MIGRACION DE AUTOS, (LOS SELECTS)

INSERT INTO MY_APOLO_SQL.Auto(auto_detalle_patente,auto_fecha_alta,auto_cantidad_kilometros,auto_precio,auto_fabr_id_fabricante,auto_mode_id_modelo,auto_sucursal_id) 
SELECT DISTINCT AUTO_PATENTE,AUTO_FECHA_ALTA,AUTO_CANT_KMS,
(SELECT PRECIO_FACTURADO * 1.2 FROM gd_esquema.Maestra WHERE AUTO_PATENTE = auto_patente AND AUTO_PATENTE IS NOT NULL),
(SELECT TOP 1 fabr_id_fabricante 
	FROM MY_APOLO_SQL.Fabricante 
JOIN gd_esquema.Maestra ON  fabr_nombre = FABRICANTE_NOMBRE 
JOIN MY_APOLO_SQL.Auto ON AUTO_PATENTE = auto_detalle_patente AND FABRICANTE_NOMBRE IS NOT NULL), -- REVISAR

(SELECT TOP 1 mode_id_modelo FROM MY_APOLO_SQL.Modelo JOIN gd_esquema.Maestra ON  mode_nombre = MODELO_NOMBRE WHERE mode_nombre = MODELO_NOMBRE AND MODELO_NOMBRE IS NOT NULL),
(SELECT TOP 1 sucu_id_sucursal FROM MY_APOLO_SQL.Sucursal JOIN gd_esquema.Maestra ON  sucu_mail = SUCURSAL_MAIL WHERE sucu_mail = SUCURSAL_MAIL AND SUCURSAL_MAIL IS NOT NULL)
FROM gd_esquema.Maestra
WHERE AUTO_PATENTE IS NOT NULL

TRUNCATE TABLE MY_APOLO_SQL.Auto

INSERT INTO 
MY_APOLO_SQL.Auto(
auto_detalle_patente,
auto_fecha_alta,
auto_cantidad_kilometros,
auto_precio,auto_fabr_id_fabricante,auto_mode_id_modelo,auto_sucursal_id) 
SELECT DISTINCT 
AUTO_PATENTE,
AUTO_FECHA_ALTA,
AUTO_CANT_KMS,
PRECIO_FACTURADO * 1.2,
--(SELECT PRECIO_FACTURADO * 1.2 
--FROM gd_esquema.Maestra 
--WHERE AUTO_PATENTE = auto_patente AND AUTO_PATENTE IS NOT NULL),
(SELECT TOP 1 fabr_id_fabricante 
FROM MY_APOLO_SQL.Fabricante AS Fabricante
WHERE Maestra.FABRICANTE_NOMBRE =  Fabricante.fabr_nombre), -- REVISAR

(SELECT TOP 1 mode_id_modelo 
	FROM MY_APOLO_SQL.Modelo  as ModeloTbl
WHERE ModeloTbl.mode_nombre = Maestra.MODELO_NOMBRE),

(SELECT TOP 1 sucu_id_sucursal 
	FROM MY_APOLO_SQL.Sucursal 	 as SucursalTbl
 WHERE SucursalTbl.sucu_mail = Maestra.SUCURSAL_MAIL)

FROM gd_esquema.Maestra AS Maestra
WHERE AUTO_PATENTE IS NOT NULL AND PRECIO_FACTURADO IS NOT NULL

select * from MY_APOLO_SQL.Auto

GO

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Auto_Parte(
	part_id_auto_parte NUMERIC(6) IDENTITY(1,1) NOT NULL  ,
	part_modelo_id NUMERIC(6) NOT NULL ,
	part_cantidad_stock DECIMAL(18,0),
	part_precio DECIMAL(18,2) ,
	part_codigo DECIMAL(18,0) ,
	part_descripcion NVARCHAR(255) ,
	part_fabricante_id NUMERIC(6) NOT NULL

	CONSTRAINT PK_Auto_Parte PRIMARY KEY (part_id_auto_parte),
	CONSTRAINT FK_part_fabricante_id FOREIGN KEY (part_fabricante_id) REFERENCES MY_APOLO_SQL.Fabricante(fabr_id_fabricante),
	CONSTRAINT FK_part_modelo_id FOREIGN KEY (part_modelo_id) REFERENCES MY_APOLO_SQL.Modelo(mode_id_modelo)
)


INSERT INTO MY_APOLO_SQL.Auto_Parte (
	part_modelo_id 
	,part_cantidad_stock
	,part_precio
	,part_codigo 
	,part_descripcion 
	,part_fabricante_id )
SELECT   
-- Tenes que joinear con Modelo para obtener el id MODELO_CODIGO,,
sum(COMPRA_CANT) - (SELECT count(CANT_FACTURADA) from gd_esquema.Maestra as Vendidas WHERE FACTURA_NRO IS NOT NULL AND Vendidas.AUTO_PARTE_CODIGO = Maestra.AUTO_PARTE_CODIGO  GROUP BY AUTO_PARTE_CODIGO ) as Stock,
COMPRA_PRECIO * 1.2
AUTO_PARTE_CODIGO, 
AUTO_PARTE_DESCRIPCION
-- Tenes que joinear con Fabricante para obtener el id FABRICANTE_NOMBRE,
FROM gd_esquema.Maestra as Maestra
WHERE COMPRA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NOT NULL
GROUP BY AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION, MODELO_CODIGO, FABRICANTE_NOMBRE,COMPRA_PRECIO




-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Cliente(
	clie_id_cliente NUMERIC(6) IDENTITY(1,1) NOT NULL , 
	clie_nombre NVARCHAR(255) ,
	clie_apellido NVARCHAR(255) ,
	clie_direccion NVARCHAR(255) ,
	clie_dni DECIMAL (18,0) ,
	clie_fecha_nacimiento DATETIME2 (3),
	clie_mail NVARCHAR(255),

  CONSTRAINT PK_Cliente PRIMARY KEY (clie_id_cliente)
)

-----------------------------------------------------------------------------------------------------------------------------------


COMMIT TRAN
ROLLBACK TRAN

