USE GD2C2020
CREATE SCHEMA MY_APOLO_SQL;
GO
DECLARE @T1 varchar(20) = 'Transaction1';  
BEGIN TRAN @T1


CREATE TABLE MY_APOLO_SQL.Ciudad(
	ciud_id_ciudad NUMERIC(6) IDENTITY (1,1) NOT NULL ,
	ciud_nombre nvarchar(255) NOT NULL ,

	CONSTRAINT PK_Ciudad PRIMARY KEY (ciud_id_ciudad),
)

TRUNCATE TABLE MY_APOLO_SQL.Ciudad

GO

CREATE PROCEDURE Migracion_ciudad
AS
INSERT INTO MY_APOLO_SQL.Ciudad(ciud_nombre) 
SELECT DISTINCT SUCURSAL_CIUDAD
FROM gd_esquema.Maestra 
WHERE SUCURSAL_CIUDAD IS NOT NULL
GO

--SELECT * FROM MY_APOLO_SQL.Ciudad

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Sucursal(
	sucu_id_sucursal NUMERIC(6) IDENTITY(1,1) NOT NULL , 
	sucu_mail NVARCHAR(255),
	sucu_telefono DECIMAL(18,0),
	sucu_direccion NVARCHAR(255),

	CONSTRAINT PK_Sucursal PRIMARY KEY (sucu_id_sucursal),

	sucu_ciud_id_ciudad NUMERIC(6) CONSTRAINT sucu_ciud_id_ciudad FOREIGN KEY (sucu_ciud_id_ciudad) REFERENCES MY_APOLO_SQL.Ciudad(ciud_id_ciudad)
)
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

--SELECT * FROM MY_APOLO_SQL.Sucursal

--SELECT * FROM MY_APOLO_SQL.Sucursal S1 JOIN MY_APOLO_SQL.Ciudad ON sucu_ciud_id_ciudad = ciud_nombre

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Fabricante(
	fabr_id_fabricante NUMERIC(6) IDENTITY (1,1) NOT NULL ,
	fabr_nombre nvarchar(255) NOT NULL ,

	CONSTRAINT PK_Fabricante PRIMARY KEY (fabr_id_fabricante),
)

TRUNCATE TABLE MY_APOLO_SQL.Fabricante

GO

CREATE PROCEDURE Migracion_Fabricante
AS
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

GO

CREATE PROCEDURE Migracion_Modelo
AS
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

GO

CREATE PROCEDURE Migracion_Transmision
AS
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

GO

CREATE PROCEDURE Migracion_Tipo_Motor
AS
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

GO

CREATE PROCEDURE Migracion_Tipo_Auto
AS
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

GO

CREATE PROCEDURE Migracion_Tipo_Caja
AS
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

	CONSTRAINT PK_Auto PRIMARY KEY (auto_id_auto),
	CONSTRAINT auto_fabr_id_fabricante FOREIGN KEY (auto_fabr_id_fabricante) REFERENCES MY_APOLO_SQL.Fabricante(fabr_id_fabricante),
	CONSTRAINT auto_mode_id_modelo FOREIGN KEY (auto_mode_id_modelo) REFERENCES MY_APOLO_SQL.Modelo(mode_id_modelo),
)

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

TRUNCATE TABLE MY_APOLO_SQL.Auto_Parte

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
(SELECT TOP 1 mode_id_modelo FROM MY_APOLO_SQL.Modelo AS Modelo WHERE Modelo.mode_nombre = Maestra.MODELO_NOMBRE),
sum(COMPRA_CANT) - (SELECT count(CANT_FACTURADA) from gd_esquema.Maestra as Vendidas WHERE FACTURA_NRO IS NOT NULL AND Vendidas.AUTO_PARTE_CODIGO = Maestra.AUTO_PARTE_CODIGO  GROUP BY AUTO_PARTE_CODIGO ) as Stock,
COMPRA_PRECIO * 1.2,
AUTO_PARTE_CODIGO, 
AUTO_PARTE_DESCRIPCION,
(SELECT TOP 1 fabr_id_fabricante FROM MY_APOLO_SQL.Fabricante AS Fabricante WHERE Fabricante.fabr_nombre = Maestra.FABRICANTE_NOMBRE)
FROM gd_esquema.Maestra as Maestra
WHERE COMPRA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NOT NULL
GROUP BY AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION, MODELO_CODIGO,COMPRA_PRECIO,MODELO_NOMBRE,FABRICANTE_NOMBRE




-----------------------------------------------------------------------------------------------------------------------------------

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
)
TRUNCATE TABLE MY_APOLO_SQL.Cliente
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

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Factura(
	fact_id_factura NUMERIC(6) IDENTITY, 
	fact_fecha DATETIME2(3),
	fact_numero DECIMAL(18,0),
	fact_precio_facturado DECIMAL(18,2),

	CONSTRAINT PK_Factura PRIMARY KEY (fact_id_factura),
	fact_clie_id_cliente NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Cliente(clie_id_cliente),
	fact_sucu_id_sucursal NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Sucursal(sucu_id_sucursal),
	fact_auto_id_auto NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Auto(auto_id_auto)
)

TRUNCATE TABLE MY_APOLO_SQL.Factura

GO

CREATE PROCEDURE Migracion_Factura
AS
INSERT INTO MY_APOLO_SQL.Factura (fact_fecha,fact_numero,fact_precio_facturado,fact_clie_id_cliente,fact_sucu_id_sucursal,fact_auto_id_auto)
SELECT
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
where AUTO_PATENTE IS NOT NULL AND FACTURA_NRO IS NOT NULL
ORDER BY FACTURA_NRO

GO
-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Factura_Auto_Parte(
	fact_auto_parte_id NUMERIC(6) IDENTITY(1,1) NOT NULL,
	fact_part_fact_id_factura NUMERIC(6), 
	fact_part_part_id_auto_parte NUMERIC(6),
	fact_part_cantidad DECIMAL(18,0)

	CONSTRAINT PK_Factura_Auto_Parte PRIMARY KEY (fact_auto_parte_id),
	CONSTRAINT FK_fact_part_part_id_auto_parte FOREIGN KEY (fact_part_part_id_auto_parte) REFERENCES MY_APOLO_SQL.Auto_Parte(part_id_auto_parte),
	CONSTRAINT FK_fact_part_fact_id_factura FOREIGN KEY (fact_part_fact_id_factura) REFERENCES MY_APOLO_SQL.Factura(fact_id_factura)

)

TRUNCATE TABLE MY_APOLO_SQL.Factura_Auto_Parte

GO

CREATE PROCEDURE Migracion_Factura_Auto_Parte
AS
INSERT INTO MY_APOLO_SQL.Factura_Auto_Parte (fact_part_fact_id_factura,fact_part_part_id_auto_parte,fact_part_cantidad)
SELECT
(SELECT fact_id_factura FROM MY_APOLO_SQL.Factura F
WHERE F.fact_numero = FACTURA_NRO AND F.fact_fecha = FACTURA_FECHA),
(SELECT part_id_auto_parte FROM MY_APOLO_SQL.Auto_Parte AP
WHERE AP.part_codigo = AUTO_PARTE_CODIGO AND AP.part_descripcion = AUTO_PARTE_DESCRIPCION),
CANT_FACTURADA
FROM gd_esquema.Maestra

GO

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Compra(
	comp_id_compra NUMERIC(6) IDENTITY(1,1) NOT NULL,
	comp_fecha DATETIME2(3), 
	comp_numero DECIMAL(18,0),
	comp_precio_compra DECIMAL(18,2),
	comp_clie_id_cliente NUMERIC(6),
	comp_sucu_id_sucursal NUMERIC (6),
	comp_auto_id_auto NUMERIC (6)

	CONSTRAINT PK_Compra PRIMARY KEY (comp_id_compra),
	CONSTRAINT FK_comp_clie_id_cliente FOREIGN KEY (comp_clie_id_cliente) REFERENCES MY_APOLO_SQL.Cliente(clie_id_cliente),
	CONSTRAINT FK_comp_sucu_id_sucursal FOREIGN KEY (comp_sucu_id_sucursal) REFERENCES MY_APOLO_SQL.Sucursal(sucu_id_sucursal),
	CONSTRAINT FK_comp_auto_id_auto FOREIGN KEY (comp_auto_id_auto) REFERENCES MY_APOLO_SQL.Auto(auto_id_auto)

)

TRUNCATE TABLE MY_APOLO_SQL.Compra

GO

--CREATE PROCEDURE Migracion_Compra
--AS
--INSERT INTO MY_APOLO_SQL.Compra (comp_fecha,comp_numero,comp_precio_compra,comp_clie_id_cliente,comp_sucu_id_sucursal,comp_auto_id_auto)
--SELECT COMPRA_FECHA,COMPRA_NRO,COMPRA_PRECIO,
--(SELECT clie_id_cliente FROM MY_APOLO_SQL.Cliente C
--WHERE C.clie_dni = CLIENTE_DNI AND C.clie_nombre = CLIENTE_NOMBRE AND C.clie_apellido = CLIENTE_APELLIDO) AS ID_CLIENTE,
--(SELECT sucu_id_sucursal FROM MY_APOLO_SQL.Sucursal S
--WHERE S.sucu_direccion = SUCURSAL_DIRECCION AND S.sucu_telefono = SUCURSAL_TELEFONO) AS ID_SUCURSAL,
--(SELECT auto_id_auto FROM MY_APOLO_SQL.Auto A
--WHERE A.auto_detalle_patente = AUTO_PATENTE AND A.auto_cantidad_kilometros = AUTO_CANT_KMS) AS ID_AUTO
--FROM gd_esquema.Maestra
--GROUP BY COMPRA_FECHA,COMPRA_NRO,COMPRA_PRECIO,CLIENTE_DNI,CLIENTE_NOMBRE,CLIENTE_APELLIDO,SUCURSAL_DIRECCION,SUCURSAL_TELEFONO,AUTO_PATENTE,AUTO_CANT_KMS
--order by compra_nro


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

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Compra_Auto_Parte(
	comp_auto_parte_id NUMERIC(6) IDENTITY(1,1) NOT NULL,
	comp_part_comp_id_compra NUMERIC(6), 
	comp_part_part_id_auto_parte NUMERIC(6),
	comp_part_cantidad DECIMAL(18,0)

	CONSTRAINT PK_Compra_Auto_Parte PRIMARY KEY (comp_auto_parte_id),
	CONSTRAINT FK_comp_part_part_id_auto_parte FOREIGN KEY (comp_part_part_id_auto_parte) REFERENCES MY_APOLO_SQL.Auto_Parte(part_id_auto_parte),
	CONSTRAINT FK_comp_part_comp_id_compra FOREIGN KEY (comp_part_comp_id_compra) REFERENCES MY_APOLO_SQL.Compra(comp_id_compra)

)

TRUNCATE TABLE MY_APOLO_SQL.Compra_Auto_Parte

GO

--CREATE PROCEDURE Migracion_Compra_Auto_Parte
--AS
--INSERT INTO MY_APOLO_SQL.Compra_Auto_Parte (comp_part_comp_id_compra,comp_part_part_id_auto_parte,comp_part_cantidad)
--SELECT

--	(SELECT comp_id_compra FROM MY_APOLO_SQL.Compra C WHERE C.comp_numero = COMPRA_NRO AND C.comp_fecha = COMPRA_FECHA),

--	(SELECT part_id_auto_parte FROM MY_APOLO_SQL.Auto_Parte AP
--	WHERE AP.part_codigo = AUTO_PARTE_CODIGO AND AP.part_descripcion = AUTO_PARTE_DESCRIPCION),

--	CANT_FACTURADA FROM gd_esquema.Maestra

--WHERE (SELECT comp_id_compra FROM MY_APOLO_SQL.Compra C WHERE C.comp_numero = COMPRA_NRO AND C.comp_fecha = COMPRA_FECHA) = auto_parte_codigo and (SELECT part_id_auto_parte FROM MY_APOLO_SQL.Auto_Parte AP
--WHERE AP.part_codigo = AUTO_PARTE_CODIGO AND AP.part_descripcion = AUTO_PARTE_DESCRIPCION) = compra_nro

CREATE PROCEDURE Migracion_Compra_Auto_Parte
AS
INSERT INTO MY_APOLO_SQL.Compra_Auto_Parte (comp_part_comp_id_compra, comp_part_part_id_auto_parte, comp_part_cantidad)
SELECT comp_id_compra,part_id_auto_parte, COMPRA_CANT FROM gd_esquema.Maestra JOIN MY_APOLO_SQL.Compra ON COMPRA_NRO = comp_numero
JOIN MY_APOLO_SQL.Auto_Parte ON AUTO_PARTE_CODIGO = auto_parte.part_codigo
WHERE COMPRA_NRO is not null AND AUTO_PARTE_CODIGO is not null

GO

-----------------------------------------------------------------------------------------------------------------------------------

COMMIT TRAN
--ROLLBACK TRAN

BEGIN TRY
    BEGIN TRAN

---Aca metemos los EXEC
EXEC Migracion_Cliente

    COMMIT TRAN
END TRY

BEGIN CATCH
    ROLLBACK TRAN

    DECLARE @Problema VARCHAR(MAX)
    SELECT @Problema = 'Ocurrió un problema en el script SQL: Numero ' + CONVERT(VARCHAR(10),ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE() + ' - Linea: ' +  CONVERT(VARCHAR(10),ERROR_LINE())
    RAISERROR(@Problema, 16,1)
END CATCH
