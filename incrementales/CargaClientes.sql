--tabla temporal para clientes
Create table #clientes(
	Cliente_Nombre nvarchar(255) NOT NULL,
	Cliente_Apellido nvarchar(255) NOT NULL,
	Cliente_Direccion nvarchar(255) NULL,
	Cliente_DNI decimal(18,0) NOT NULL,
	Cliente_Fecha_Nac datetime2(3) NULL,
	Cliente_Mail nvarchar(255) NULL,
	Cliente_Compra datetime2(3) NULL
)

--Armo la tabla de los clientes
-- hacer join de los distinct dni agrupados por max fecha 
INSERT INTO #clientes
SELECT CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_DNI, CLIENTE_FECHA_NAC, CLIENTE_MAIL, COMPRA_FECHA
FROM gd_esquema.Maestra
WHERE CLIENTE_DNI IS NOT NULL
UNION
SELECT FAC_CLIENTE_NOMBRE, FAC_CLIENTE_APELLIDO, FAC_CLIENTE_DIRECCION, FAC_CLIENTE_DNI, FAC_CLIENTE_FECHA_NAC, FAC_CLIENTE_MAIL, FACTURA_FECHA
FROM gd_esquema.Maestra
WHERE FAC_CLIENTE_DNI IS NOT NULL


INSERT INTO MY_APOLO_SQL.Cliente (
	clie_nombre,
	clie_apellido,
	clie_direccion,
	clie_dni,
	clie_fecha_nacimiento,
	clie_mail)
SELECT Cliente_Nombre,
Cliente_Apellido,
Cliente_Direccion,
#clientes.Cliente_DNI, 
Cliente_Fecha_Nac, 
Cliente_Mail
 FROM #clientes 
JOIN (
	SELECT Cliente_DNI, max(Cliente_Compra) as fecha_compra from #clientes group by Cliente_DNI
)a on a.Cliente_DNI = #clientes.Cliente_DNI and a.fecha_compra = #clientes.Cliente_Compra
ORDER BY #clientes.Cliente_DNI








