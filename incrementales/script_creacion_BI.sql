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
	tiem_id_tiempo NUMERIC(6) NOT NULL ,
	tiem_anio integer NOT NULL ,
	tiem_mes integer NOT NULL

	CONSTRAINT PK_BI_Tiempo PRIMARY KEY (tiem_id_tiempo),
);
CREATE TABLE MY_APOLO_SQL.BI_Sucursal(
	sucu_id_sucursal NUMERIC(6) NOT NULL , 
	sucu_mail NVARCHAR(255),
	sucu_telefono DECIMAL(18,0),
	sucu_direccion NVARCHAR(255),
	sucu_ciudad NVARCHAR(255)

	CONSTRAINT PK_BI_Sucursal PRIMARY KEY (sucu_id_sucursal),
);

CREATE TABLE MY_APOLO_SQL.BI_Modelo(
	mode_id_modelo NUMERIC(6),
	mode_codigo DECIMAL(18,0) ,
	mode_nombre NVARCHAR(255) ,
	mode_potencia DECIMAL(18,0) ,

	CONSTRAINT PK_BI_Modelo PRIMARY KEY (mode_id_modelo),
);

CREATE TABLE MY_APOLO_SQL.BI_Fabricante(
	fabr_id_fabricante NUMERIC(6) NOT NULL ,
	fabr_nombre nvarchar(255) NOT NULL ,

	CONSTRAINT PK_BI_Fabricante PRIMARY KEY (fabr_id_fabricante),
);

CREATE TABLE MY_APOLO_SQL.BI_Tipo_Transmision(
	tipo_tran_id_tipo_transmision NUMERIC(6),
	tipo_tran_codigo DECIMAL(18,0) ,
	tipo_tran_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_BI_Tipo_Transmision PRIMARY KEY (tipo_tran_id_tipo_transmision)
);

CREATE TABLE MY_APOLO_SQL.BI_Tipo_Motor(
	tipo_moto_id_tipo_motor NUMERIC(6),
	tipo_moto_codigo DECIMAL(18,0) ,

	CONSTRAINT PK_BI_Tipo_Motor PRIMARY KEY (tipo_moto_id_tipo_motor)
);

CREATE TABLE MY_APOLO_SQL.BI_Tipo_Auto(
	tipo_auto_id_tipo_auto NUMERIC(6),
	tipo_auto_codigo DECIMAL(18,0) ,
	tipo_auto_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_BI_Tipo_Auto PRIMARY KEY (tipo_auto_id_tipo_auto)
);

CREATE TABLE MY_APOLO_SQL.BI_Tipo_Caja(
	tipo_caja_id_tipo_caja NUMERIC(6),
	tipo_caja_codigo DECIMAL(18,0) ,
	tipo_caja_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_BI_Tipo_Caja PRIMARY KEY (tipo_caja_id_tipo_caja)
);

CREATE TABLE MY_APOLO_SQL.BI_Auto(
	auto_id_auto NUMERIC(6) NOT NULL ,
	auto_detalle_patente NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,
	auto_vendido BIT default 0,  --0 significa que no se vendio
	auto_precio DECIMAL(18,2),

	CONSTRAINT PK_BI_Auto PRIMARY KEY (auto_id_auto),
	
);

CREATE TABLE MY_APOLO_SQL.BI_Auto_Parte(
	part_id_auto_parte NUMERIC(6) NOT NULL  ,
	part_cantidad_stock DECIMAL(18,0),
	part_precio DECIMAL(18,2) ,
	part_codigo DECIMAL(18,0) ,
	part_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_BI_Auto_Parte PRIMARY KEY (part_id_auto_parte),
	
);

CREATE TABLE MY_APOLO_SQL.BI_Cliente(
	clie_id_cliente NUMERIC(6) NOT NULL , 
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
	fact_compra_auto_id int identity(1,1) NOT NULL,
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
	fact_hecho_venta_auto_id int identity(1,1) NOT NULL,
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
	fact_hecho_compra_auto_parte_id int identity(1,1) NOT NULL,
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
	fact_hecho_venta_auto_parte_id int identity(1,1) NOT NULL,
	cantidad_vendidos INTEGER,
	precio_promedio DECIMAL(18,2),
	ganancia DECIMAL (18,2),
	tiempo_promedio_en_stock INTEGER,
	maxima_cantidad_en_stock INTEGER,

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
	JOIN MY_APOLO_SQL.BI_Sucursal BS ON BS.sucu_id_sucursal = S.sucu_id_sucursal
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
	JOIN MY_APOLO_SQL.BI_Cliente BCLI ON BCLI.clie_id_cliente = CLI.clie_id_cliente
	JOIN MY_APOLO_SQL.BI_Sucursal BS ON BS.sucu_id_sucursal = S.sucu_id_sucursal
	JOIN MY_APOLO_SQL.BI_Tiempo T ON T.tiem_anio = YEAR(Fact.fact_fecha) AND T.tiem_mes = MONTH(Fact.fact_fecha)

GO

CREATE PROCEDURE Migracion_Hecho_Compra_Auto_Parte 
AS
	INSERT INTO MY_APOLO_SQL.BI_Hecho_Compra_Auto_Parte( 
	tiem_id_tiempo,
	fabr_id_fabricante,
	mode_id_modelo,
	auto_id_auto_parte,
	clie_id_cliente,
	sucu_id_sucursal)
	
	SELECT T.tiem_id_tiempo,BF.fabr_id_fabricante,BM.mode_id_modelo,BAP.part_id_auto_parte,BCLI.clie_id_cliente,BS.sucu_id_sucursal

	FROM MY_APOLO_SQL.Compra_Auto_Parte CAP
	
	JOIN MY_APOLO_SQL.Auto_Parte AP ON CAP.comp_part_part_id_auto_parte = AP.part_id_auto_parte
	JOIN MY_APOLO_SQL.Modelo M ON AP.part_modelo_id = M.mode_id_modelo
	JOIN MY_APOLO_SQL.Fabricante F ON AP.part_fabricante_id = F.fabr_id_fabricante
	JOIN MY_APOLO_SQL.Compra C ON C.comp_id_compra = CAP.comp_part_comp_id_compra
	JOIN MY_APOLO_SQL.Sucursal S ON C.comp_sucu_id_sucursal = S.sucu_id_sucursal
	JOIN MY_APOLO_SQL.Ciudad CIU ON S.sucu_ciud_id_ciudad = CIU.ciud_id_ciudad
	JOIN MY_APOLO_SQL.Cliente CLI ON C.comp_clie_id_cliente = CLI.clie_id_cliente
	
	
	JOIN MY_APOLO_SQL.BI_Auto_Parte BAP ON BAP.part_id_auto_parte = AP.part_id_auto_parte
	JOIN MY_APOLO_SQL.BI_Modelo BM ON BM.mode_id_modelo = M.mode_id_modelo
	JOIN MY_APOLO_SQL.BI_Fabricante BF ON BF.fabr_id_fabricante = F.fabr_id_fabricante
	JOIN MY_APOLO_SQL.BI_Sucursal BS ON BS.sucu_id_sucursal = S.sucu_id_sucursal
	JOIN MY_APOLO_SQL.BI_Cliente BCLI ON BCLI.clie_id_cliente = CLI.clie_id_cliente
	JOIN MY_APOLO_SQL.BI_Tiempo T ON T.tiem_anio = YEAR(C.comp_fecha) AND T.tiem_mes = MONTH(C.comp_fecha)
	
GO

CREATE PROCEDURE Migracion_Hecho_Venta_Auto_Parte 
AS
	INSERT INTO MY_APOLO_SQL.BI_Hecho_Venta_Auto_Parte( 
	tiem_id_tiempo,
	fabr_id_fabricante,
	mode_id_modelo,
	auto_id_auto_parte,
	clie_id_cliente,
	sucu_id_sucursal)
	
	SELECT T.tiem_id_tiempo,BF.fabr_id_fabricante,BM.mode_id_modelo,BAP.part_id_auto_parte,BCLI.clie_id_cliente,BS.sucu_id_sucursal 
	FROM MY_APOLO_SQL.Factura_Auto_Parte FAP
	
	JOIN MY_APOLO_SQL.Auto_Parte AP ON FAP.fact_part_part_id_auto_parte = AP.part_id_auto_parte
	JOIN MY_APOLO_SQL.Modelo M ON AP.part_modelo_id = M.mode_id_modelo
	JOIN MY_APOLO_SQL.Fabricante F ON AP.part_fabricante_id = F.fabr_id_fabricante
	JOIN MY_APOLO_SQL.Factura FT ON FT.fact_id_factura = FAP.fact_part_fact_id_factura
	JOIN MY_APOLO_SQL.Sucursal S ON FT.fact_sucu_id_sucursal = S.sucu_id_sucursal
	JOIN MY_APOLO_SQL.Ciudad CIU ON S.sucu_ciud_id_ciudad = CIU.ciud_id_ciudad
	JOIN MY_APOLO_SQL.Cliente CLI ON FT.fact_clie_id_cliente = CLI.clie_id_cliente
	
	JOIN MY_APOLO_SQL.BI_Auto_Parte BAP ON BAP.part_id_auto_parte = AP.part_id_auto_parte
	JOIN MY_APOLO_SQL.BI_Modelo BM ON BM.mode_id_modelo = M.mode_id_modelo
	JOIN MY_APOLO_SQL.BI_Fabricante BF ON BF.fabr_id_fabricante = F.fabr_id_fabricante
	JOIN MY_APOLO_SQL.BI_Sucursal BS ON BS.sucu_id_sucursal = S.sucu_ciud_id_ciudad
	JOIN MY_APOLO_SQL.BI_Cliente BCLI ON BCLI.clie_id_cliente = CLI.clie_id_cliente
	JOIN MY_APOLO_SQL.BI_Tiempo T ON T.tiem_anio = YEAR(FT.fact_fecha) AND T.tiem_mes = MONTH(FT.fact_fecha)

GO

CREATE PROCEDURE Migracion_BI_Sucursal
AS
INSERT INTO MY_APOLO_SQL.BI_Sucursal(sucu_id_sucursal, sucu_mail,sucu_telefono,sucu_direccion,sucu_ciudad) 
SELECT s.sucu_id_sucursal, s.sucu_mail,s.sucu_telefono,s.sucu_direccion, ciud_nombre
FROM MY_APOLO_SQL.Sucursal s
join MY_APOLO_SQL.Ciudad c on s.sucu_ciud_id_ciudad = c.ciud_id_ciudad
GO

CREATE PROCEDURE Migracion_BI_Fabricante
AS
INSERT INTO MY_APOLO_SQL.BI_Fabricante(fabr_id_fabricante, fabr_nombre) 
SELECT * FROM MY_APOLO_SQL.Fabricante
GO

CREATE PROCEDURE Migracion_BI_Modelo
AS
INSERT INTO MY_APOLO_SQL.BI_Modelo(mode_id_modelo, mode_codigo,mode_nombre,mode_potencia) 
SELECT *
FROM MY_APOLO_SQL.Modelo
GO

CREATE PROCEDURE Migracion_BI_Tipo_Transmision
AS
INSERT INTO MY_APOLO_SQL.BI_Tipo_Transmision(tipo_tran_id_tipo_transmision, tipo_tran_codigo,tipo_tran_descripcion) 
SELECT * FROM MY_APOLO_SQL.Tipo_Transmision
GO

CREATE PROCEDURE Migracion_BI_Tipo_Motor
AS
INSERT INTO MY_APOLO_SQL.BI_Tipo_Motor(tipo_moto_id_tipo_motor, tipo_moto_codigo) 
SELECT tipo_moto_id_tipo_motor,tipo_moto_codigo FROM MY_APOLO_SQL.Tipo_Motor
GO

CREATE PROCEDURE Migracion_BI_Auto_Parte
AS
INSERT INTO MY_APOLO_SQL.BI_Auto_Parte (
	part_id_auto_parte,
	part_cantidad_stock,
	part_precio,
	part_codigo,
	part_descripcion)

SELECT part_id_auto_parte, part_cantidad_stock, part_precio, part_codigo, part_descripcion FROM MY_APOLO_SQL.Auto_Parte

GO

CREATE PROCEDURE Migracion_BI_Cliente
AS
INSERT INTO MY_APOLO_SQL.BI_Cliente (
	clie_id_cliente,
    clie_nombre,
    clie_apellido,
    clie_direccion,
    clie_dni,
    clie_fecha_nacimiento,
    clie_mail,
	clie_rango_edad)
SELECT clie_id_cliente, clie_nombre,clie_apellido,clie_direccion,clie_dni,clie_fecha_nacimiento,clie_mail,
CASE 	WHEN YEAR(GETDATE()) - YEAR(C.clie_fecha_nacimiento) >= 18 AND YEAR(GETDATE()) - YEAR(C.clie_fecha_nacimiento) < 30 THEN 1
		WHEN YEAR(GETDATE()) - YEAR(C.clie_fecha_nacimiento) >= 30 AND YEAR(GETDATE()) - YEAR(C.clie_fecha_nacimiento) < 50 THEN 2
		WHEN YEAR(GETDATE()) - YEAR(C.clie_fecha_nacimiento) >= 50 THEN 3
		ELSE 'ERROR: EL CLIENTE TIENE QUE SER MAYOR DE EDAD'
		END

FROM MY_APOLO_SQL.Cliente C 
GO

CREATE PROCEDURE Migracion_BI_Tipo_Auto
AS
INSERT INTO MY_APOLO_SQL.BI_Tipo_Auto(tipo_auto_id_tipo_auto, tipo_auto_codigo,tipo_auto_descripcion) 
SELECT * FROM MY_APOLO_SQL.Tipo_Auto
GO

CREATE PROCEDURE Migracion_BI_Tipo_Caja
AS
INSERT INTO MY_APOLO_SQL.BI_Tipo_Caja(tipo_caja_id_tipo_caja, tipo_caja_codigo,tipo_caja_descripcion) 
SELECT * FROM MY_APOLO_SQL.Tipo_Caja
GO

GO
--ToDO: Revisar el Procedure
CREATE PROCEDURE Migracion_BI_Auto
AS
BEGIN
INSERT INTO MY_APOLO_SQL.BI_Auto(auto_id_auto, auto_detalle_patente,auto_fecha_alta,auto_cantidad_kilometros,auto_vendido,auto_precio) 
SELECT auto_id_auto, auto_detalle_patente,auto_fecha_alta, auto_cantidad_kilometros, auto_vendido, auto_precio FROM MY_APOLO_SQL.Auto
END

GO

CREATE PROCEDURE Migracion_BI_Tiempo
AS
BEGIN
SELECT DISTINCT YEAR(comp_fecha), MONTH(comp_fecha) FROM MY_APOLO_SQL.Compra
UNION
SELECT DISTINCT YEAR(fact_fecha), MONTH(fact_fecha) FROM MY_APOLO_SQL.Factura

END

GO

---------------------EJECUCION PROCEDURES--------------------

PRINT 'Procedures Creados Correctamente'
BEGIN TRY
    BEGIN TRAN
--Migracion de Datos

EXEC Migracion_BI_Tiempo --OK
EXEC Migracion_BI_Sucursal --OK
EXEC Migracion_BI_Auto --OK
EXEC Migracion_BI_Tipo_Caja --OK
EXEC Migracion_BI_Tipo_Auto --OK
EXEC Migracion_BI_Cliente --OK
EXEC Migracion_BI_Auto_Parte --OK
EXEC Migracion_BI_Tipo_Motor --OK
EXEC Migracion_BI_Tipo_Transmision --OK
EXEC Migracion_BI_Modelo --OK
EXEC Migracion_BI_Fabricante --OK
EXEC Migracion_Hecho_Venta_Auto_Parte --OK
EXEC Migracion_Hecho_Compra_Auto_Parte --OK
EXEC Migracion_Hecho_Venta_Auto --OK
EXEC Migracion_Hecho_Compra_Auto --OK


    COMMIT TRAN
END TRY

BEGIN CATCH
    ROLLBACK TRAN

    DECLARE @Problema VARCHAR(MAX)
    SELECT @Problema = 'Ocurrió un problema en el script SQL: Numero ' + CONVERT(VARCHAR(10),ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE() + ' - Linea: ' +  CONVERT(VARCHAR(10),ERROR_LINE())
    RAISERROR(@Problema, 16,1)
END CATCH


---------------------DROPEO DE TABLAS-------------------------


/*
drop table MY_APOLO_SQL.BI_Tiempo,MY_APOLO_SQL.BI_Auto,MY_APOLO_SQL.BI_Auto_Parte,MY_APOLO_SQL.BI_Fabricante,MY_APOLO_SQL.BI_Sucursal,MY_APOLO_SQL.BI_Tipo_Auto,MY_APOLO_SQL.BI_Tipo_Caja,MY_APOLO_SQL.BI_Tipo_Transmision,MY_APOLO_SQL.BI_Cliente,MY_APOLO_SQL.BI_Modelo,MY_APOLO_SQL.BI_Tipo_Motor
drop table MY_APOLO_SQL.BI_Hecho_Compra_Auto,MY_APOLO_SQL.BI_Hecho_Venta_Auto,MY_APOLO_SQL.BI_Hecho_Compra_Auto_Parte,MY_APOLO_SQL.BI_Hecho_Venta_Auto_Parte
drop procedure dbo.Migracion_BI_Auto,dbo.Migracion_BI_Auto_Parte,dbo.Migracion_BI_Cliente,dbo.Migracion_BI_Compra,dbo.Migracion_BI_Compra_Auto_Parte,dbo.Migracion_BI_Fabricante,dbo.Migracion_BI_Modelo,dbo.Migracion_BI_Sucursal,dbo.Migracion_BI_Tipo_Auto,dbo.Migracion_BI_Tipo_Caja,dbo.Migracion_BI_Tipo_Motor,dbo.Migracion_BI_Tipo_Transmision
drop procedure dbo.Migracion_Hecho_Compra_Auto,dbo.Migracion_Hecho_Venta_Auto,dbo.Migracion_Hecho_Compra_Auto_Parte,dbo.Migracion_Hecho_Venta_Auto_Parte

*/

select * from MY_APOLO_SQL.BI_Auto

select * from MY_APOLO_SQL.BI_Tipo_Motor


select * from MY_APOLO_SQL.BI_Hecho_Venta_Auto_Parte

GO

/*
CREATE VIEW cant_automoviles_vendidos_y_comprados
	AS 
	SELECT title, type, price, pubdate
	FROM titles
GO
*/