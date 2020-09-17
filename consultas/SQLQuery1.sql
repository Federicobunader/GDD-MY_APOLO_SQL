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
CREATE TABLE MY_APOLO_SQL.Factura(
	fact_id_factura int identity(1,1) NOT NULL,
  fact_fecha datetime()
	fact_numero
  fact_precio_facturado
  fact_cantidad_facturada
  fact_id_cliente
  fact_id_sucursal
  CONSTRAINT PK_Cliente PRIMARY KEY (clie_id_cliente)
  FOREIGN KEY (fact_id_sucursal) REFERENCES Sucur(PersonID)
)

CREATE TABLE MY_APOLO_SQL.Factura(
	fact_id_factura int identity(1,1) NOT NULL,
  fact_fecha datetime()
	fact_numero
  fact_precio_facturado
  fact_cantidad_facturada
  fact_id_cliente
  fact_id_sucursal
)

CREATE TABLE MY_APOLO_SQL.Tipo_Transmision(
	tipo_tran_id_tipo_transmision NUMERIC(6) IDENTITY,
	tipo_trans_codigo DECIMAL(18,0) ,
	tipo_tran_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Transmision PRIMARY KEY (tipo_tran_id_tipo_transmision)
)

CREATE TABLE MY_APOLO_SQL.Tipo_Motor(
	tipo_moto_id_tipo_motor NUMERIC(6) IDENTITY,
	tipo_trans_codigo DECIMAL(18,0) ,

	CONSTRAINT PK_Tipo_Motor PRIMARY KEY (tipo_moto_id_tipo_motor)
)

CREATE TABLE MY_APOLO_SQL.Tipo_Auto(
	tipo_auto_id_tipo_auto NUMERIC(6) IDENTITY,
	tipo_trans_codigo DECIMAL(18,0) ,
	tipo_tran_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Auto PRIMARY KEY (tipo_auto_id_tipo_auto)
)

CREATE TABLE MY_APOLO_SQL.Tipo_Caja(
	tipo_caja_id_tipo_caja NUMERIC(6) IDENTITY,
	tipo_trans_codigo DECIMAL(18,0) ,
	tipo_tran_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Caja PRIMARY KEY (tipo_caja_id_tipo_caja)
)

CREATE TABLE MY_APOLO_SQL.Tipo_Caja(
	tipo_caja_id_tipo_caja NUMERIC(6) IDENTITY,
	tipo_trans_codigo DECIMAL(18,0) ,
	tipo_tran_descripcion NVARCHAR(255) ,

	CONSTRAINT PK_Tipo_Caja PRIMARY KEY (tipo_caja_id_tipo_caja)
)

CREATE TABLE MY_APOLO_SQL.Auto(
	auto_id_auto NUMERIC(6) IDENTITY, 
	-- No puse "AUTO PRECIO" , no se si ponerlo o no
	auto_patente NVARCHAR(50) ,
	auto_nro_chasis NVARCHAR(50) ,
	auto_nro_motor NVARCHAR(50) ,
	auto_fecha_alta DATETIME2(3) ,
	auto_cantidad_kilometros DECIMAL(18,0) ,
	auto_tipo_caja_id_tipo_caja NUMERIC(6) ,
	auto_tipo_auto_id_tipo_auto NUMERIC(6) ,
	auto_tipo_tran_id_tipo_transmision NUMERIC(6) ,
	auto_tipo_moto_id_tipo_motor NUMERIC(6) ,
	auto_mode_id_modelo NUMERIC(6) ,
	auto_fabr_id_fabricante NUMERIC(6) ,
	
  CONSTRAINT PK_Auto PRIMARY KEY (auto_id_auto)
  FOREIGN KEY auto_tipo_caja_id_tipo_caja REFERENCES MY_APOLO_SQL.Tipo_Caja(tipo_caja_id_tipo_caja)
  FOREIGN KEY auto_tipo_auto_id_tipo_auto)REFERENCES MY_APOLO_SQL.Tipo_Auto(tipo_auto_id_tipo_auto)
  FOREIGN KEY auto_tipo_moto_id_tipo_motor REFERENCES MY_APOLO_SQL.Tipo_Motor(tipo_moto_id_tipo_motor)
  FOREIGN KEY auto_tipo_tran_id_tipo_transmision REFERENCES MY_APOLO_SQL.Tipo_Transmision(tipo_tran_id_tipo_transmision)
  FOREIGN KEY auto_mode_id_modelo REFERENCES MY_APOLO_SQL.Modelo(mode_id_modelo)
  FOREIGN KEY auto_fabr_id_fabricante REFERENCES MY_APOLO_SQL.Fabricante(fabr_id_fabricante)
)

INSERT into MY_APOLO_SQL.Cliente (clie_nombre,clie_apellido,clie_direccion,clie_dni,clie_fecha_nacimiento,clie_mail) 
SELECT DISTINCT CLIENTE_NOMBRE,CLIENTE_APELLIDO,CLIENTE_DIRECCION,CLIENTE_DNI,CLIENTE_FECHA_NAC,CLIENTE_MAIL
FROM gd_esquema.Maestra

select * from MY_APOLO_SQL.Cliente

select count(*) as DNIES, DNI from MY_APOLO_SQL.Cliente group by MY_APOLO_SQL.Cliente.DNI,MY_APOLO_SQL.Cliente.DNI having count (*) > 1

select * from gd_esquema.Maestra

DELETE FROM MY_APOLO_SQL.Cliente

DROP TABLE MY_APOLO_SQL.Cliente
 