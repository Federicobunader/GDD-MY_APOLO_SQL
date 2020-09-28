USE GD2C2020

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
GO
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

GO
INSERT INTO MY_APOLO_SQL.Cliente (
	clie_nombre,
	clie_apellido,
	clie_direccion,
	clie_dni,
	clie_fecha_nacimiento,
	clie_mail)
SELECT 
Cliente_Nombre,
Cliente_Apellido,
Cliente_Direccion,
#clientes.Cliente_DNI, 
Cliente_Fecha_Nac, 
Cliente_Mail
 FROM #clientes 
INNER JOIN (
	SELECT DISTINCT Cliente_DNI, max(Cliente_Compra) as fecha_compra from #clientes group by Cliente_DNI) a 
	on a.Cliente_DNI = #clientes.Cliente_DNI and a.fecha_compra = #clientes.Cliente_Compra
ORDER BY #clientes.Cliente_DNI

--Cargar clientes con UNIQUE KEY (DNI, Nombre, Apellido)


--SELECT DISTINCT Cliente_DNI, max(Cliente_Compra) as fecha_compra from #clientes 
--where Cliente_DNI in (20514527
--,37638888
--,42739188
--)
--group by Cliente_DNI


--SELECT clie_dni, count(clie_dni) as cantidad
--FROM MY_APOLO_SQL.Cliente as Cliente
--GROUP BY clie_dni 
--HAVING count(clie_dni) > 1


SELECT * FROM MY_APOLO_SQL.Cliente where clie_dni in (37638888
,42739188
,20514527)

--TRUNCATE TABLE MY_APOLO_SQL.Cliente 

--Problema
--Consideracion
-- Tenemos 3 usuarios que realizar compras el mismo dia con diferentes datos de Nombre Apellido pero mismo dni

select 
Cliente_Nombre, Cliente_Apellido, Cliente_DNI
 from #clientes
 GROUP BY Cliente_Nombre, Cliente_Apellido, Cliente_DNI
 HAVING count(Cliente_DNI) > 1


