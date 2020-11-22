USE GD2C2020
GO


BEGIN TRY
    BEGIN TRAN

IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'MY_APOLO_SQL')) 
BEGIN
    EXEC ('CREATE SCHEMA [MY_APOLO_SQL] AUTHORIZATION [dbo]')
END

-------------------CREACION TABLAS---------------------------
CREATE TABLE MY_APOLO_SQL.BI_Tiempo(
	tiem_id_tiempo NUMERIC(6) IDENTITY (1,1) NOT NULL ,
	tiem_anio integer NOT NULL ,
	tiem_mes integer NOT NULL

	CONSTRAINT PK_BI_Tiempo PRIMARY KEY (tiem_id_tiempo),
);
CREATE TABLE MY_APOLO_SQL.BI_Sucursal(
	sucu_id_sucursal NUMERIC(6) IDENTITY(1,1) NOT NULL , 
	sucu_mail NVARCHAR(255),
	sucu_telefono DECIMAL(18,0),
	sucu_direccion NVARCHAR(255),

	CONSTRAINT PK_BI_Sucursal PRIMARY KEY (sucu_id_sucursal),

	sucu_ciud_id_ciudad NUMERIC(6) CONSTRAINT sucu_ciud_id_ciudad FOREIGN KEY (sucu_ciud_id_ciudad) REFERENCES MY_APOLO_SQL.Ciudad(ciud_id_ciudad)
);

CREATE TABLE MY_APOLO_SQL.BI_Modelo(
	mode_id_modelo NUMERIC(6) IDENTITY,
	mode_codigo DECIMAL(18,0) ,
	mode_nombre NVARCHAR(255) ,
	mode_potencia DECIMAL(18,0) ,

	CONSTRAINT PK_BI_Modelo PRIMARY KEY (mode_id_modelo),
);

CREATE TABLE MY_APOLO_SQL.BI_Fabricante(
	fabr_id_fabricante NUMERIC(6) IDENTITY (1,1) NOT NULL ,
	fabr_nombre nvarchar(255) NOT NULL ,

	CONSTRAINT PK_BI_Fabricante PRIMARY KEY (fabr_id_fabricante),
);

CREATE TABLE MY_APOLO_SQL.BI_Tipo_Transmision(
	tipo_tran_id_tipo_transmision NUMERIC(6) IDENTITY,
	tipo_tran_codigo DECIMAL(18,0) ,
	tipo_tran_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_BI_Tipo_Transmision PRIMARY KEY (tipo_tran_id_tipo_transmision)
);

CREATE TABLE MY_APOLO_SQL.BI_Tipo_Motor(
	tipo_moto_id_tipo_motor NUMERIC(6) IDENTITY,
	tipo_moto_codigo DECIMAL(18,0) ,

	CONSTRAINT PK_BI_Tipo_Motor PRIMARY KEY (tipo_moto_id_tipo_motor)
);

CREATE TABLE MY_APOLO_SQL.BI_Tipo_Auto(
	tipo_auto_id_tipo_auto NUMERIC(6) IDENTITY,
	tipo_auto_codigo DECIMAL(18,0) ,
	tipo_auto_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_BI_Tipo_Auto PRIMARY KEY (tipo_auto_id_tipo_auto)
);

CREATE TABLE MY_APOLO_SQL.BI_Tipo_Caja(
	tipo_caja_id_tipo_caja NUMERIC(6) IDENTITY,
	tipo_caja_codigo DECIMAL(18,0) ,
	tipo_caja_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_BI_Tipo_Caja PRIMARY KEY (tipo_caja_id_tipo_caja)
);

CREATE TABLE MY_APOLO_SQL.BI_Auto(
	auto_id_auto NUMERIC(6) IDENTITY(1,1) NOT NULL ,
	auto_detalle_patente NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,
	auto_vendido BIT default 0,  --0 significa que no se vendio
	auto_precio DECIMAL(18,2),

	CONSTRAINT PK_BI_Auto PRIMARY KEY (auto_id_auto),
	
);

CREATE TABLE MY_APOLO_SQL.BI_Auto_Parte(
	part_id_auto_parte NUMERIC(6) IDENTITY(1,1) NOT NULL  ,
	part_cantidad_stock DECIMAL(18,0),
	part_precio DECIMAL(18,2) ,
	part_codigo DECIMAL(18,0) ,
	part_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_BI_Auto_Parte PRIMARY KEY (part_id_auto_parte),
	
);

CREATE TABLE MY_APOLO_SQL.BI_Cliente(
	clie_id_cliente NUMERIC(6) IDENTITY(1,1) NOT NULL , 
	clie_nombre NVARCHAR(255) ,
	clie_apellido NVARCHAR(255) ,
	clie_direccion NVARCHAR(255) ,
	clie_dni DECIMAL (18,0),
	clie_mail NVARCHAR(255),
	clie_fecha_nacimiento DATETIME2 (3),
	clie_rango_edad decimal(1,0),

  CONSTRAINT PK_BI_Cliente PRIMARY KEY (clie_id_cliente),
  CONSTRAINT UC_BI_Cliente UNIQUE (clie_apellido,clie_dni)
);

CREATE TABLE MY_APOLO_SQL.BI_Hecho_Compra_Auto(
	precio_promedio DECIMAL(18,2),
	ganancia DECIMAL (18,2),
	tiempo_promedio_en_stock INTEGER,

	tiem_id_tiempo NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Tiempo(tiem_id_tiempo),
	tipo_caja_id_tipo_caja NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Tipo_Caja(tipo_caja_id_tipo_caja),
	tipo_auto_id_tipo_auto NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Tipo_Auto(tipo_auto_id_tipo_auto),
	tipo_moto_id_tipo_motor NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Tipo_Motor(tipo_moto_id_tipo_motor),
	tipo_tran_id_tipo_transmision NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Tipo_Transmision(tipo_tran_id_tipo_transmision),
	fabr_id_fabricante NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Fabricante(fabr_id_fabricante),
	mode_id_modelo NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Modelo(mode_id_modelo),
	auto_id_auto NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Auto(auto_id_auto),
	clie_id_cliente NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Cliente(clie_id_cliente),
	sucu_id_sucursal NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Sucursal(sucu_id_sucursal)
);

CREATE TABLE MY_APOLO_SQL.BI_Hecho_Venta_Auto(
	cantidad_vendidos INTEGER,
	precio_promedio DECIMAL(18,2),
	ganancia DECIMAL (18,2),
	tiempo_promedio_en_stock INTEGER,

	tiem_id_tiempo NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Tiempo(tiem_id_tiempo),
	tipo_caja_id_tipo_caja NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Tipo_Caja(tipo_caja_id_tipo_caja),
	tipo_auto_id_tipo_auto NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Tipo_Auto(tipo_auto_id_tipo_auto),
	tipo_moto_id_tipo_motor NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Tipo_Motor(tipo_moto_id_tipo_motor),
	tipo_tran_id_tipo_transmision NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Tipo_Transmision(tipo_tran_id_tipo_transmision),
	fabr_id_fabricante NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Fabricante(fabr_id_fabricante),
	mode_id_modelo NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Modelo(mode_id_modelo),
	auto_id_auto NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Auto(auto_id_auto),
	clie_id_cliente NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Cliente(clie_id_cliente),
	sucu_id_sucursal NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Sucursal(sucu_id_sucursal)
);

CREATE TABLE MY_APOLO_SQL.BI_Hecho_Compra_Auto_Parte(
	cantidad_vendidos INTEGER,
	precio_promedio DECIMAL(18,2),
	ganancia DECIMAL (18,2),
	tiempo_promedio_en_stock INTEGER,
	maxica_cantidad_en_stock INTEGER,

	tiem_id_tiempo NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Tiempo(tiem_id_tiempo),
	fabr_id_fabricante NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Fabricante(fabr_id_fabricante),
	mode_id_modelo NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Modelo(mode_id_modelo),
	auto_id_auto_parte NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Auto_Parte(part_id_auto_parte),
	clie_id_cliente NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Cliente(clie_id_cliente),
	sucu_id_sucursal NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Sucursal(sucu_id_sucursal)
);

CREATE TABLE MY_APOLO_SQL.BI_Hecho_Venta_Auto_Parte(
	cantidad_vendidos INTEGER,
	precio_promedio DECIMAL(18,2),
	ganancia DECIMAL (18,2),
	tiempo_promedio_en_stock INTEGER,
	maxica_cantidad_en_stock INTEGER,

	tiem_id_tiempo NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Tiempo(tiem_id_tiempo),
	fabr_id_fabricante NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Fabricante(fabr_id_fabricante),
	mode_id_modelo NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Modelo(mode_id_modelo),
	auto_id_auto_parte NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Auto_Parte(part_id_auto_parte),
	clie_id_cliente NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Cliente(clie_id_cliente),
	sucu_id_sucursal NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES MY_APOLO_SQL.BI_Sucursal(sucu_id_sucursal)
);

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

CREATE PROCEDURE Migracion_Hecho_Compra_Auto 
AS
	INSERT INTO MY_APOLO_SQL.BI_Hecho_Compra_Auto( 
	tiem_id_tiempo,
	tipo_caja_id_tipo_caja,
	tipo_auto_id_tipo_auto,
	tipo_moto_id_tipo_motor,
	tipo_tran_id_tipo_transmision,
	fabr_id_fabricante,
	mode_id_modelo,
	auto_id_auto,
	clie_id_cliente,
	sucu_id_sucursal)
	
	SELECT T.tiem_id_tiempo,Btc.tipo_caja_id_tipo_caja,Bta.tipo_auto_id_tipo_auto,Btm.tipo_moto_id_tipo_motor,Btt.tipo_tran_id_tipo_transmision,
	BF.fabr_id_fabricante,BM.mode_id_modelo,BA.auto_id_auto,BCLI.clie_id_cliente,BS.sucu_id_sucursal

	FROM MY_APOLO_SQL.Compra C

	JOIN MY_APOLO_SQL.Auto A ON C.comp_auto_id_auto = A.auto_id_auto
	JOIN MY_APOLO_SQL.Tipo_Caja tc ON A.auto_tipo_caja_id_tipo_caja = tc.tipo_caja_id_tipo_caja
	JOIN MY_APOLO_SQL.Tipo_Auto tA ON A.auto_tipo_auto_id_tipo_auto = tA.tipo_auto_id_tipo_auto
	JOIN MY_APOLO_SQL.Tipo_Motor tm ON A.auto_tipo_moto_id_tipo_moto = tm.tipo_moto_id_tipo_motor
	JOIN MY_APOLO_SQL.Tipo_Transmision tt ON A.auto_tipo_trans_id_tipo_transimision = tt.tipo_tran_id_tipo_transmision
	JOIN MY_APOLO_SQL.Modelo M ON A.auto_mode_id_modelo = M.mode_id_modelo
	JOIN MY_APOLO_SQL.Fabricante F ON A.auto_fabr_id_fabricante = F.fabr_id_fabricante
	JOIN MY_APOLO_SQL.Sucursal S ON C.comp_sucu_id_sucursal = S.sucu_id_sucursal
	JOIN MY_APOLO_SQL.Ciudad CIU ON S.sucu_ciud_id_ciudad = CIU.ciud_id_ciudad
	JOIN MY_APOLO_SQL.Cliente CLI ON C.comp_clie_id_cliente = CLI.clie_id_cliente

	JOIN MY_APOLO_SQL.BI_Auto BA ON BA.auto_id_auto = A.auto_id_auto
	JOIN MY_APOLO_SQL.BI_Tipo_Caja Btc ON Btc.tipo_caja_id_tipo_caja = tc.tipo_caja_id_tipo_caja
	JOIN MY_APOLO_SQL.BI_Tipo_Auto BtA ON BtA.tipo_auto_id_tipo_auto = tA.tipo_auto_id_tipo_auto
	JOIN MY_APOLO_SQL.BI_Tipo_Motor Btm ON Btm.tipo_moto_id_tipo_motor = tm.tipo_moto_id_tipo_motor
	JOIN MY_APOLO_SQL.BI_Tipo_Transmision Btt ON Btt.tipo_tran_id_tipo_transmision = tt.tipo_tran_id_tipo_transmision
	JOIN MY_APOLO_SQL.BI_Modelo BM ON BM.mode_id_modelo = M.mode_id_modelo
	JOIN MY_APOLO_SQL.BI_Fabricante BF ON BF.fabr_id_fabricante = F.fabr_id_fabricante
	JOIN MY_APOLO_SQL.BI_Sucursal BS ON BS.sucu_ciud_id_ciudad = S.sucu_ciud_id_ciudad
	JOIN MY_APOLO_SQL.BI_Cliente BCLI ON BCLI.clie_id_cliente = CLI.clie_id_cliente
	JOIN MY_APOLO_SQL.BI_Tiempo T ON T.tiem_anio = YEAR(C.comp_fecha) AND T.tiem_mes = MONTH(C.comp_fecha)

GO

CREATE PROCEDURE Migracion_Hecho_Venta_Auto 
AS
	INSERT INTO MY_APOLO_SQL.BI_Hecho_Venta_Auto( 
	tiem_id_tiempo,
	tipo_caja_id_tipo_caja,
	tipo_auto_id_tipo_auto,
	tipo_moto_id_tipo_motor,
	tipo_tran_id_tipo_transmision,
	fabr_id_fabricante,
	mode_id_modelo,
	auto_id_auto,
	clie_id_cliente,
	sucu_id_sucursal)
	
	SELECT T.tiem_id_tiempo,Btc.tipo_caja_id_tipo_caja,Bta.tipo_auto_id_tipo_auto,Btm.tipo_moto_id_tipo_motor,Btt.tipo_tran_id_tipo_transmision,
	BF.fabr_id_fabricante,BM.mode_id_modelo,BA.auto_id_auto,BCLI.clie_id_cliente,BS.sucu_id_sucursal

	FROM MY_APOLO_SQL.Factura Fact

	JOIN MY_APOLO_SQL.Auto A ON Fact.fact_auto_id_auto = A.auto_id_auto
	JOIN MY_APOLO_SQL.Tipo_Caja tc ON A.auto_tipo_caja_id_tipo_caja = tc.tipo_caja_id_tipo_caja
	JOIN MY_APOLO_SQL.Tipo_Auto tA ON A.auto_tipo_auto_id_tipo_auto = tA.tipo_auto_id_tipo_auto
	JOIN MY_APOLO_SQL.Tipo_Motor tm ON A.auto_tipo_moto_id_tipo_moto = tm.tipo_moto_id_tipo_motor
	JOIN MY_APOLO_SQL.Tipo_Transmision tt ON A.auto_tipo_trans_id_tipo_transimision = tt.tipo_tran_id_tipo_transmision
	JOIN MY_APOLO_SQL.Modelo M ON A.auto_mode_id_modelo = M.mode_id_modelo
	JOIN MY_APOLO_SQL.Fabricante F ON A.auto_fabr_id_fabricante = F.fabr_id_fabricante
	JOIN MY_APOLO_SQL.Sucursal S ON Fact.fact_sucu_id_sucursal = S.sucu_id_sucursal
	JOIN MY_APOLO_SQL.Ciudad CIU ON S.sucu_ciud_id_ciudad = CIU.ciud_id_ciudad
	JOIN MY_APOLO_SQL.Cliente CLI ON Fact.fact_clie_id_cliente = CLI.clie_id_cliente

	JOIN MY_APOLO_SQL.BI_Auto BA ON BA.auto_id_auto = A.auto_id_auto
	JOIN MY_APOLO_SQL.BI_Tipo_Caja Btc ON Btc.tipo_caja_id_tipo_caja = tc.tipo_caja_id_tipo_caja
	JOIN MY_APOLO_SQL.BI_Tipo_Auto BtA ON BtA.tipo_auto_id_tipo_auto = tA.tipo_auto_id_tipo_auto
	JOIN MY_APOLO_SQL.BI_Tipo_Motor Btm ON Btm.tipo_moto_id_tipo_motor = tm.tipo_moto_id_tipo_motor
	JOIN MY_APOLO_SQL.BI_Tipo_Transmision Btt ON Btt.tipo_tran_id_tipo_transmision = tt.tipo_tran_id_tipo_transmision
	JOIN MY_APOLO_SQL.BI_Modelo BM ON BM.mode_id_modelo = M.mode_id_modelo
	JOIN MY_APOLO_SQL.BI_Fabricante BF ON BF.fabr_id_fabricante = F.fabr_id_fabricante
	JOIN MY_APOLO_SQL.BI_Sucursal BS ON BS.sucu_ciud_id_ciudad = S.sucu_ciud_id_ciudad
	JOIN MY_APOLO_SQL.BI_Cliente BCLI ON BCLI.clie_id_cliente = CLI.clie_id_cliente
	JOIN MY_APOLO_SQL.BI_Tiempo T ON T.tiem_anio = YEAR(Fact.fact_fecha) AND T.tiem_mes = MONTH(Fact.fact_fecha)

GO

CREATE PROCEDURE Migracion_Hecho_Venta_Auto 
AS
	INSERT INTO MY_APOLO_SQL.BI_Hecho_Venta_Auto( 
	tiem_id_tiempo,
	tipo_caja_id_tipo_caja,
	tipo_auto_id_tipo_auto,
	tipo_moto_id_tipo_motor,
	tipo_tran_id_tipo_transmision,
	fabr_id_fabricante,
	mode_id_modelo,
	auto_id_auto,
	clie_id_cliente,
	sucu_id_sucursal)
	
	SELECT T.tiem_id_tiempo,Btc.tipo_caja_id_tipo_caja,Bta.tipo_auto_id_tipo_auto,Btm.tipo_moto_id_tipo_motor,Btt.tipo_tran_id_tipo_transmision,
	BF.fabr_id_fabricante,BM.mode_id_modelo,BA.auto_id_auto,BCLI.clie_id_cliente,BS.sucu_id_sucursal

	FROM MY_APOLO_SQL.Factura Fact

	JOIN MY_APOLO_SQL.Auto A ON Fact.fact_auto_id_auto = A.auto_id_auto
	JOIN MY_APOLO_SQL.Tipo_Caja tc ON A.auto_tipo_caja_id_tipo_caja = tc.tipo_caja_id_tipo_caja
	JOIN MY_APOLO_SQL.Tipo_Auto tA ON A.auto_tipo_auto_id_tipo_auto = tA.tipo_auto_id_tipo_auto
	JOIN MY_APOLO_SQL.Tipo_Motor tm ON A.auto_tipo_moto_id_tipo_moto = tm.tipo_moto_id_tipo_motor
	JOIN MY_APOLO_SQL.Tipo_Transmision tt ON A.auto_tipo_trans_id_tipo_transimision = tt.tipo_tran_id_tipo_transmision
	JOIN MY_APOLO_SQL.Modelo M ON A.auto_mode_id_modelo = M.mode_id_modelo
	JOIN MY_APOLO_SQL.Fabricante F ON A.auto_fabr_id_fabricante = F.fabr_id_fabricante
	JOIN MY_APOLO_SQL.Sucursal S ON Fact.fact_sucu_id_sucursal = S.sucu_id_sucursal
	JOIN MY_APOLO_SQL.Ciudad CIU ON S.sucu_ciud_id_ciudad = CIU.ciud_id_ciudad
	JOIN MY_APOLO_SQL.Cliente CLI ON Fact.fact_clie_id_cliente = CLI.clie_id_cliente

	JOIN MY_APOLO_SQL.BI_Auto BA ON BA.auto_id_auto = A.auto_id_auto
	JOIN MY_APOLO_SQL.BI_Tipo_Caja Btc ON Btc.tipo_caja_id_tipo_caja = tc.tipo_caja_id_tipo_caja
	JOIN MY_APOLO_SQL.BI_Tipo_Auto BtA ON BtA.tipo_auto_id_tipo_auto = tA.tipo_auto_id_tipo_auto
	JOIN MY_APOLO_SQL.BI_Tipo_Motor Btm ON Btm.tipo_moto_id_tipo_motor = tm.tipo_moto_id_tipo_motor
	JOIN MY_APOLO_SQL.BI_Tipo_Transmision Btt ON Btt.tipo_tran_id_tipo_transmision = tt.tipo_tran_id_tipo_transmision
	JOIN MY_APOLO_SQL.BI_Modelo BM ON BM.mode_id_modelo = M.mode_id_modelo
	JOIN MY_APOLO_SQL.BI_Fabricante BF ON BF.fabr_id_fabricante = F.fabr_id_fabricante
	JOIN MY_APOLO_SQL.BI_Sucursal BS ON BS.sucu_ciud_id_ciudad = S.sucu_ciud_id_ciudad
	JOIN MY_APOLO_SQL.BI_Cliente BCLI ON BCLI.clie_id_cliente = CLI.clie_id_cliente
	JOIN MY_APOLO_SQL.BI_Tiempo T ON T.tiem_anio = YEAR(Fact.fact_fecha) AND T.tiem_mes = MONTH(Fact.fact_fecha)

GO

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

CREATE PROCEDURE Migracion_BI_Fabricante
AS
INSERT INTO MY_APOLO_SQL.BI_Fabricante(fabr_nombre) 
SELECT * FROM MY_APOLO_SQL.Fabricante
GO

CREATE PROCEDURE Migracion_BI_Modelo
AS
INSERT INTO MY_APOLO_SQL.BI_Modelo(mode_codigo,mode_nombre,mode_potencia) 
SELECT * 
FROM MY_APOLO_SQL.Modelo
GO

CREATE PROCEDURE Migracion_BI_Tipo_Transmision
AS
INSERT INTO MY_APOLO_SQL.BI_Tipo_Transmision(tipo_tran_codigo,tipo_tran_descripcion) 
SELECT * FROM MY_APOLO_SQL.Tipo_Transmision
GO

CREATE PROCEDURE Migracion_BI_Tipo_Motor
AS
INSERT INTO MY_APOLO_SQL.BI_Tipo_Motor(tipo_moto_codigo) 
SELECT * FROM MY_APOLO_SQL.Tipo_Motor
GO

CREATE PROCEDURE Migracion_BI_Auto_Parte
AS
INSERT INTO MY_APOLO_SQL.BI_Auto_Parte ( 
	,part_cantidad_stock
	,part_precio
	,part_codigo 
	,part_descripcion)

SELECT * FROM MY_APOLO_SQL.Auto_Parte

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
SELECT * FROM MY_APOLO_SQL.Cliente

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

CREATE PROCEDURE Migracion_BI_Tipo_Auto
AS
INSERT INTO MY_APOLO_SQL.BI_Tipo_Auto(tipo_auto_codigo,tipo_auto_descripcion) 
SELECT * FROM MY_APOLO_SQL.Tipo_Auto
GO

CREATE PROCEDURE Migracion_BI_Tipo_Caja
AS
INSERT INTO MY_APOLO_SQL.BI_Tipo_Caja(tipo_caja_codigo,tipo_caja_descripcion) 
SELECT * FROM MY_APOLO_SQL.Tipo_Caja
GO

--ToDO: Revisar el Procedure
CREATE PROCEDURE Migracion_BI_Auto
AS
BEGIN
INSERT INTO 
MY_APOLO_SQL.BI_Auto(
auto_detalle_patente,
auto_fecha_alta,
auto_cantidad_kilometros,
auto_vendido,
auto_precio) 

SELECT * FROM MY_APOLO_SQL.Auto

---------------------DROPEO DE TABLAS-------------------------

