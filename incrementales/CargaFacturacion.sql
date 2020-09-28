

--Autos Facturadso
INSERT INTO MY_APOLO_SQL.Factura ()
SELECT 
FACTURA_NRO,
cli.clie_dni,
sucu.sucu_id_sucursal, --referencia a la ciudad
PRECIO_FACTURADO
 FROM gd_esquema.Maestra 
 JOIN MY_APOLO_SQL.Cliente as cli on FAC_CLIENTE_DNI = cli.clie_dni
 JOIN MY_APOLO_SQL.Sucurusal as sucu on FAC_SUCURSAL_DIRECCION = sucu.sucu_direccion 
where AUTO_PATENTE IS NOT NULL AND FACTURA_NRO IS NOT NULL
ORDER BY FACTURA_NRO

--AutoPartes Facturadas
INSERT INTO Factura_AutoParte ()
SELECT 
CANT_FACTURADA,
FACTURA_NRO,
PRECIO_FACTURADO,
AUTO_PARTE_CODIGO
 FROM gd_esquema.Maestra 
where AUTO_PARTE_CODIGO IS NOT NULL AND FACTURA_NRO IS NOT NULL
ORDER BY FACTURA_NRO


