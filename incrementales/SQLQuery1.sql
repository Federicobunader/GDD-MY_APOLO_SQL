CREATE SCHEMA MY_APOLO_SQL;
GO

-- CREACION DE TRABLAS

CREATE TABLE MY_APOLO_SQL.Cliente(
	clie_id_cliente NUMERIC(6) IDENTITY, 
	clie_nombre NVARCHAR(255) ,
	clie_apellido NVARCHAR(255) ,
	clie_direccion NVARCHAR(255) ,
	clie_dni DECIMAL (18,0) ,
	clie_fecha_nacimiento DATETIME2 (3),
	clie_mail NVARCHAR(255),
  CONSTRAINT PK_Cliente PRIMARY KEY (clie_id_cliente)
)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Factura(
	fact_id_factura NUMERIC(6) IDENTITY, 
	fact_fecha DATETIME2(3),
	fact_numero DECIMAL(18,0),
	fact_precio_facturado DECIMAL(18,2),
	fact_cantidad_facturada DECIMAL(18,0)

	CONSTRAINT PK_Factura PRIMARY KEY (fact_id_factura),
	fact_clie_id_cliente NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Cliente(clie_id_cliente),
	fact_sucu_id_sucursal NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Sucursal(sucu_id_sucursal),
	fact_auto_id_auto NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Auto(auto_id_auto)
)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Sucursal(
	sucu_id_sucursal NUMERIC(6) IDENTITY, 
	sucu_mail NVARCHAR(255),
	sucu_telefono DECIMAL(18,0),
	sucu_direccion NVARCHAR(255),

	CONSTRAINT PK_Sucursal PRIMARY KEY (sucu_id_sucursal),
	sucu_ciud_id_ciudad NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Ciudad(ciud_id_ciudad),
)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Ciudad(
	ciud_id_ciudad NUMERIC(6) IDENTITY, 
	ciud_nombre NVARCHAR(255),

	CONSTRAINT PK_Ciudad PRIMARY KEY (ciud_id_ciudad),
)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Tipo_Transmision(
	tipo_tran_id_tipo_transmision NUMERIC(6) IDENTITY,
	tipo_trans_codigo DECIMAL(18,0) ,
	tipo_tran_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Transmision PRIMARY KEY (tipo_tran_id_tipo_transmision)
)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Tipo_Motor(
	tipo_moto_id_tipo_motor NUMERIC(6) IDENTITY,
	tipo_trans_codigo DECIMAL(18,0) ,

	CONSTRAINT PK_Tipo_Motor PRIMARY KEY (tipo_moto_id_tipo_motor)
)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Tipo_Auto(
	tipo_auto_id_tipo_auto NUMERIC(6) IDENTITY,
	tipo_trans_codigo DECIMAL(18,0) ,
	tipo_tran_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Auto PRIMARY KEY (tipo_auto_id_tipo_auto)
)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Tipo_Caja(
	tipo_caja_id_tipo_caja NUMERIC(6) IDENTITY,
	tipo_trans_codigo DECIMAL(18,0) ,
	tipo_tran_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Caja PRIMARY KEY (tipo_caja_id_tipo_caja)
)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Modelo(
	mode_id_modelo NUMERIC(6) IDENTITY,
	mode_codigo DECIMAL(18,0) ,
	mode_nombre NVARCHAR(255) ,
	mode_potencia DECIMAL(18,0) ,

	CONSTRAINT PK_Modelo PRIMARY KEY (mode_id_modelo),
)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Fabricante(
	fabr_id_fabricante NUMERIC(6) IDENTITY,
	fabr_nombre NVARCHAR(255) ,

	CONSTRAINT PK_Fabricante PRIMARY KEY (fabr_id_fabricante),
)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Auto_Parte(
	part_id_auto_parte NUMERIC(6) IDENTITY ,
	part_vendida BIT default 0 ,  --0 significa que no se vendio
	part_precio DECIMAL(18,2) ,
	part_codigo DECIMAL(18,0) ,
	part_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Auto_Parte PRIMARY KEY (part_id_auto_parte),
	part_mode_id_modelo NUMERIC(6) FOREIGN KEY  REFERENCES MY_APOLO_SQL.Modelo(mode_id_modelo),
	part_fabr_id_fabricante NUMERIC(6) FOREIGN KEY  REFERENCES MY_APOLO_SQL.Fabricante(fabr_id_fabricante),
	part_rubr_id_rubro NUMERIC(6) FOREIGN KEY  REFERENCES MY_APOLO_SQL.Rubro(rubr_id_rubro)
)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Rubro(
	rubr_id_rubro NUMERIC(6) IDENTITY ,
	rubr_nombre NVARCHAR(255) ,

	CONSTRAINT PK_Rubro PRIMARY KEY (rubr_id_rubro),
)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MY_APOLO_SQL.Auto(
	auto_id_auto NUMERIC(6) IDENTITY, 
	auto_vendido BIT default 0,  --0 significa que no se vendio
	auto_precio DECIMAL(18,2),
	auto_patente NVARCHAR(50) ,
	auto_nro_chasis NVARCHAR(50) ,
	auto_nro_motor NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,

	CONSTRAINT PK_Auto PRIMARY KEY (auto_id_auto),
	auto_tipo_caja_id_tipo_caja NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Tipo_Caja(tipo_caja_id_tipo_caja),
	auto_tipo_auto_id_tipo_auto NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Tipo_Auto(tipo_auto_id_tipo_auto),
	auto_tipo_moto_id_tipo_motor NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Tipo_Motor(tipo_moto_id_tipo_motor),
	auto_tipo_tran_id_tipo_transmision NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Tipo_Transmision(tipo_tran_id_tipo_transmision),
	auto_mode_id_modelo NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Modelo(mode_id_modelo),
	auto_fabr_id_fabricante NUMERIC(6) FOREIGN KEY REFERENCES MY_APOLO_SQL.Fabricante(fabr_id_fabricante)
)

-----------------------------------------------------------------------------------------------------------------------------------



INSERT into MY_APOLO_SQL.Cliente (clie_nombre,clie_apellido,clie_direccion,clie_dni,clie_fecha_nacimiento,clie_mail) 
SELECT DISTINCT CLIENTE_NOMBRE,CLIENTE_APELLIDO,CLIENTE_DIRECCION,CLIENTE_DNI,CLIENTE_FECHA_NAC,CLIENTE_MAIL
FROM gd_esquema.Maestra

select * from MY_APOLO_SQL.Cliente

select count(*) as DNIES, DNI from MY_APOLO_SQL.Cliente group by MY_APOLO_SQL.Cliente.DNI,MY_APOLO_SQL.Cliente.DNI having count (*) > 1

select * from gd_esquema.Maestra

DELETE FROM MY_APOLO_SQL.Cliente

DROP TABLE MY_APOLO_SQL.Cliente

DELETE FROM MY_APOLO_SQL.Tipo_Transmision

DROP TABLE MY_APOLO_SQL.Tipo_Transmision
 