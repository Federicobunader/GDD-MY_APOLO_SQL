CREATE PROCEDURE Migracion_Autos
AS
CREATE TABLE MY_APOLO_SQL.#Autos_Vendidos(
	auto_id_auto NUMERIC(6) IDENTITY(1,1) NOT NULL ,
	auto_detalle_patente NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,
	auto_vendido BIT default 1,  --0 significa que no se vendio
	auto_precio DECIMAL(18,2),

	CONSTRAINT PK_Autos_Vendidos PRIMARY KEY (auto_id_auto),
)

GO

CREATE TABLE MY_APOLO_SQL.#Autos_Totales(
	auto_id_auto NUMERIC(6) IDENTITY(1,1) NOT NULL ,
	auto_detalle_patente NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,
	auto_vendido BIT default 1,  --0 significa que no se vendio
	auto_precio DECIMAL(18,2),

	CONSTRAINT PK_Autos_Totales PRIMARY KEY (auto_id_auto),
)

GO

-------------------CREACION TABLAS---------------------------

INSERT INTO 
MY_APOLO_SQL.Auto(
auto_detalle_patente,
auto_fecha_alta,
auto_cantidad_kilometros,
auto_vendido,
auto_precio,auto_fabr_id_fabricante,auto_mode_id_modelo) 

SELECT DISTINCT 
AUTO_PATENTE,
AUTO_FECHA_ALTA,
AUTO_CANT_KMS,
 1,
COMPRA_PRECIO * 1.2,

(SELECT TOP 1 fabr_id_fabricante 
FROM MY_APOLO_SQL.Fabricante AS Fabricante
WHERE Maestra.FABRICANTE_NOMBRE =  Fabricante.fabr_nombre), -- REVISAR

(SELECT TOP 1 mode_id_modelo 
	FROM MY_APOLO_SQL.Modelo  as ModeloTbl
WHERE ModeloTbl.mode_nombre = Maestra.MODELO_NOMBRE)

FROM gd_esquema.Maestra AS Maestra
WHERE AUTO_PATENTE IS NOT NULL AND PRECIO_FACTURADO IS NULL

INSERT INTO MY_APOLO_SQL.#Autos_Vendidos(
auto_detalle_patente,
auto_fecha_alta,
auto_cantidad_kilometros,
auto_vendido,
auto_precio) 

SELECT DISTINCT 

AUTO_PATENTE,
AUTO_FECHA_ALTA,
AUTO_CANT_KMS,
1,
COMPRA_PRECIO * 1.2

FROM gd_esquema.Maestra 
WHERE AUTO_PATENTE IS NOT NULL AND PRECIO_FACTURADO IS NOT NULL

INSERT INTO MY_APOLO_SQL.#Autos_Totales(
auto_detalle_patente,
auto_fecha_alta,
auto_cantidad_kilometros,
auto_vendido,
auto_precio) 

SELECT DISTINCT 

AUTO_PATENTE,
AUTO_FECHA_ALTA,
AUTO_CANT_KMS,
0,
COMPRA_PRECIO * 1.2 AS Precio

FROM gd_esquema.Maestra 
WHERE AUTO_PATENTE IS NOT NULL AND PRECIO_FACTURADO IS NULL


----------------------ACTUALIZO BIT DE VENDIDO EN AUTO--------------------------

UPDATE MY_APOLO_SQL.Auto SET auto_vendido = 0 FROM MY_APOLO_SQL.Auto WHERE auto_detalle_patente IN 
(
	SELECT auto_detalle_patente FROM MY_APOLO_SQL.Autos_Totales
	EXCEPT
	SELECT auto_detalle_patente FROM MY_APOLO_SQL.Autos_Vendidos
)


---------------------DROPEO DE TABLAS-------------------------


DROP TABLE MY_APOLO_SQL.#Autos_Vendidos

GO

DROP TABLE MY_APOLO_SQL.#Autos_TotalesY

