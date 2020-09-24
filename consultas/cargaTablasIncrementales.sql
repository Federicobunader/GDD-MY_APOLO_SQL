
--No ejecutar a menos que quieras consumir los recursos de tu pc
--Optimizar
--Carga de clientes (Hay algunos clientes que tienen el mismo dni pero distinto nombre y apeliido por eso armo el historial, considero los datos del cliente como los datos con las que efectuo la ultima compra)
DECLARE @DNI DECIMAL(18,0);
DECLARE @maxFecha DATETIME2 (3);
DECLARE @IdCLiente NUMERIC(6);
DECLARE dni_cursor CURSOR  
    FOR SELECT DISTINCT CLIENTE_DNI, max(COMPRA_FECHA) FROM gd_esquema.Maestra GROUP BY CLIENTE_DNI
OPEN dni_cursor
FETCH NEXT FROM dni_cursor
INTO @DNI, @maxFecha
WHILE @@FETCH_STATUS = 0  
BEGIN
	--Obtener IdCliente
	INSERT INTO Cliente 
	SELECT top 1
		CLIENTE_NOMBRE,
		CLIENTE_APELLIDO,
		CLIENTE_DIRECCION,
		CLIENTE_DNI,
		CLIENTE_FECHA_NAC,
		CLIENTE_MAIL
	FROM gd_esquema.Maestra WHERE CLIENTE_DNI = @DNI AND COMPRA_FECHA = @maxFecha
	SET @IdCLiente = @@IDENTITY
END   
CLOSE dni_cursor;  
DEALLOCATE dni_cursor; 

