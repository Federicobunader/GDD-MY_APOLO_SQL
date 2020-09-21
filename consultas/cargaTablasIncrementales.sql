USE GD2C2020

--CLIENTE
--habria que tener en cuenta 
select
	DISTINCT
	CLIENTE_NOMBRE
	CLIENTE_APELLIDO,
	CLIENTE_DNI
from gd_esquema.Maestra
where CLIENTE_DNI IS NOT NULL

--SUCURSAL
select
	DISTINCT
	SUCURSAL_DIRECCION,
	SUCURSAL_CIUDAD
from gd_esquema.Maestra
where SUCURSAL_CIUDAD IS NOT NULL

select * from gd_esquema.Maestra

--AUTO_PARTE
select 
	DISTINCT
	AUTO_PARTE_CODIGO,
	AUTO_PARTE_DESCRIPCION
from gd_esquema.Maestra

--MODELO
select 
	DISTINCT
	MODELO_CODIGO,
	MODELO_NOMBRE
from gd_esquema.Maestra

--TRANSMISION
select 
	DISTINCT
	TIPO_TRANSMISION_CODIGO,
	TIPO_TRANSMISION_DESC
from gd_esquema.Maestra

--TIPO CAJA
select 
	DISTINCT
	TIPO_CAJA_CODIGO,
	TIPO_CAJA_DESC
from gd_esquema.Maestra

--TIPO AUTO
select 
	DISTINCT
	TIPO_AUTO_CODIGO,
	TIPO_AUTO_DESC
from gd_esquema.Maestra

--MOTOR
--no se de que la juega el motoro le faltan datos
select 
	DISTINCT
	TIPO_MOTOR_CODIGO
from gd_esquema.Maestra

--FABRICANTE
select 
	DISTINCT
	FABRICANTE_NOMBRE
from gd_esquema.Maestra

