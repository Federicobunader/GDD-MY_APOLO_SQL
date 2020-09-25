CREATE TABLE MY_APOLO_SQL.Autos_Vendidos(
	auto_id_auto NUMERIC(6) IDENTITY(1,1) NOT NULL ,
	auto_detalle_patente NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,
	auto_vendido BIT default 1,  --0 significa que no se vendio
	auto_precio DECIMAL(18,2),

	CONSTRAINT PK_Autos_Vendidos PRIMARY KEY (auto_id_auto),
)

INSERT INTO MY_APOLO_SQL.Autos_Vendidos(
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
PRECIO_FACTURADO * 1.2

FROM gd_esquema.Maestra 
WHERE AUTO_PATENTE IS NOT NULL AND PRECIO_FACTURADO IS NOT NULL


CREATE TABLE MY_APOLO_SQL.Autos_Totales(
	auto_id_auto NUMERIC(6) IDENTITY(1,1) NOT NULL ,
	auto_detalle_patente NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,
	auto_vendido BIT default 1,  --0 significa que no se vendio
	auto_precio DECIMAL(18,2),

	CONSTRAINT PK_Autos_Totales PRIMARY KEY (auto_id_auto),
)

INSERT INTO MY_APOLO_SQL.Autos_Totales(
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
PRECIO_FACTURADO * 1.2 AS Precio

FROM gd_esquema.Maestra 
WHERE AUTO_PATENTE IS NOT NULL AND PRECIO_FACTURADO IS NULL

UPDATE MY_APOLO_SQL.Auto SET auto_vendido = 0 FROM MY_APOLO_SQL.Auto WHERE auto_detalle_patente IN 
(
	SELECT auto_detalle_patente FROM MY_APOLO_SQL.Autos_Totales
	EXCEPT
	SELECT auto_detalle_patente FROM MY_APOLO_SQL.Autos_Vendidos
)

--SELECT auto_detalle_patente FROM MY_APOLO_SQL.Auto WHERE auto_detalle_patente IN 
--(
--	SELECT auto_detalle_patente FROM MY_APOLO_SQL.Autos_Totales
	--EXCEPT
--	SELECT auto_detalle_patente FROM MY_APOLO_SQL.Autos_Vendidos
--)

--select * from MY_APOLO_SQL.Auto



--select Distinct AUTO_PATENTE from gd_esquema.Maestra

--select* from gd_esquema.Maestra where AUTO_PATENTE ='5E5B4QC6W4QIBJ1SU279FN'