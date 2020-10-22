--Msg 512, Level 16, State 1, Procedure Migracion_Factura_Auto_Parte, Line 4
--Subquery returned more than 1 value. This is not permitted when the subquery follows =, !=, <, <= , >, >= or when the subquery is used as an expression.
--The statement has been terminated.

--Analizar porque trae mas de 1 valor en el select
CREATE PROCEDURE Migracion_Factura_Auto_Parte
AS
INSERT INTO MY_APOLO_SQL.Factura_Auto_Parte (fact_part_fact_id_factura,fact_part_part_id_auto_parte,fact_part_cantidad)
SELECT
(SELECT fact_id_factura FROM MY_APOLO_SQL.Factura F WHERE F.fact_numero = FACTURA_NRO AND F.fact_fecha = FACTURA_FECHA),
(SELECT part_id_auto_parte FROM MY_APOLO_SQL.Auto_Parte AP WHERE AP.part_codigo = AUTO_PARTE_CODIGO AND AP.part_descripcion = AUTO_PARTE_DESCRIPCION),
CANT_FACTURADA
FROM gd_esquema.Maestra


--Warning Elimina valores nulos por agregacion
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