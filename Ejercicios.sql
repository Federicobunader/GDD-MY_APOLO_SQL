use GD2015C1

--1. Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o
--igual a $ 1000 ordenado por código de cliente.

select clie_codigo,clie_razon_social from Cliente
where clie_limite_credito >= 1000
order by clie_codigo

--2. Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por
--cantidad vendida

select prod_codigo,prod_detalle from Producto
join Item_Factura on item_producto = prod_codigo
join Factura on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
where YEAR(fact_fecha) = 2012
group by prod_codigo,prod_detalle
order by sum(item_cantidad) desc

--3. Realizar una consulta que muestre código de producto, nombre de producto y el stock
--total, sin importar en que deposito se encuentre, los datos deben ser ordenados por
--nombre del artículo de menor a mayor

SELECT prod_codigo,prod_detalle,sum(stoc_cantidad) FROM Producto
JOIN Stock ON prod_codigo = stoc_producto
GROUP BY prod_codigo,prod_detalle
ORDER BY prod_detalle ASC

--4. Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de
--artículos que lo componen. Mostrar solo aquellos artículos para los cuales el stock
--promedio por depósito sea mayor a 100

SELECT prod_codigo,prod_detalle,comp_cantidad FROM Producto
JOIN Composicion ON prod_codigo = comp_producto
UNION
SELECT prod_codigo,prod_detalle,stoc_cantidad FROM Producto
JOIN Stock ON prod_codigo = stoc_producto
JOIN DEPOSITO ON stoc_deposito = depo_codigo
GROUP BY prod_codigo,prod_detalle,stoc_cantidad
HAVING AVG(stoc_cantidad) > 100

--5. Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de
--stock que se realizaron para ese artículo en el año 2012 (egresan los productos que
--fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.

SELECT prod_codigo,prod_detalle,sum(item_cantidad) AS Cantidad_Egresos FROM Producto
JOIN Item_Factura ON prod_codigo = item_producto
JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
WHERE YEAR(fact_fecha) = 2012
GROUP BY prod_codigo,prod_detalle
HAVING sum(item_cantidad) >
(
	SELECT sum(item_cantidad) FROM Item_Factura
	JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
	WHERE YEAR(fact_fecha) = 2011 AND prod_codigo = item_producto
)

--6. Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese
--rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que
--tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.

SELECT DISTINCT rubr_id,rubr_detalle,COUNT(prod_codigo) AS Cantidad_de_Articulos, SUM(stoc_cantidad) AS Stock_Total FROM Rubro
JOIN Producto ON rubr_id = prod_rubro
JOIN STOCK ON prod_codigo = stoc_producto
GROUP BY rubr_id,rubr_detalle,stoc_cantidad
HAVING stoc_cantidad > 
(
	SELECT stoc_cantidad FROM Producto
	JOIN STOCK ON prod_codigo = stoc_producto
	JOIN DEPOSITO ON stoc_deposito = depo_codigo
	WHERE prod_codigo = '00000000' AND depo_codigo = '00'
)
ORDER BY Stock_Total DESC

--7. Generar una consulta que muestre para cada artículo código, detalle, mayor precio
--menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio =
--10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que posean
--stock.

SELECT prod_codigo,prod_detalle, MAX(prod_precio) AS Precio_MAX, MIN(prod_precio) AS Precio_MIN,((MAX(prod_precio) - MIN(prod_precio)) * 100) AS Dif_Porcentaje  FROM Producto
JOIN STOCK ON prod_codigo = stoc_producto
WHERE stoc_cantidad > 0
GROUP BY prod_codigo,prod_detalle

--8. Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
--artículo, stock del depósito que más stock tiene.

SELECT prod_detalle,SUM(stoc_cantidad) AS Stock_DEPO FROM Producto
JOIN STOCK ON prod_codigo = stoc_producto
JOIN DEPOSITO ON stoc_deposito = depo_codigo
WHERE stoc_cantidad > 0 AND stoc_deposito = depo_codigo
GROUP BY prod_detalle,stoc_cantidad

SELECT prod_detalle, MAX(stoc_cantidad) Maximo_stoc FROM Producto JOIN STOCK ON prod_codigo = stoc_producto
WHERE stoc_cantidad != 0
GROUP BY prod_detalle, prod_codigo
HAVING COUNT(stoc_deposito) = (SELECT COUNT(*) FROM DEPOSITO)

--9. Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
--mismo y la cantidad de depósitos que ambos tienen asignados.

SELECT empl_jefe AS Jefe,empl_codigo AS Cod_Empleado,empl_nombre AS Nombre_Empleado, COUNT(depo_codigo) AS Cantidad_De_Depositos FROM Empleado
JOIN DEPOSITO ON empl_codigo = depo_encargado OR empl_jefe = depo_encargado
GROUP BY empl_jefe,empl_codigo,empl_nombre

--10. Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos
--vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que
--mayor compra realizo.

SELECT prod_codigo,prod_detalle,(SELECT TOP 1 clie_razon_social FROM Cliente C JOIN Factura ON fact_cliente = clie_codigo JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero WHERE item_producto = P1.prod_codigo GROUP BY clie_razon_social ORDER BY SUM(item_cantidad) DESC) AS Cliente FROM Producto P1 JOIN Item_Factura ON item_producto = prod_codigo WHERE P1.prod_codigo IN
(SELECT TOP 10 item_producto FROM Item_Factura GROUP BY item_producto ORDER BY SUM(item_cantidad) ASC)
OR prod_codigo IN
(SELECT TOP 10 item_producto FROM Item_Factura GROUP BY item_producto ORDER BY SUM(item_cantidad) DESC)
GROUP BY prod_codigo,prod_detalle


--11. Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de
--productos vendidos y el monto de dichas ventas sin impuestos. Los datos se deberán
--ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga,
--solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para
--el año 2012.

SELECT fami_detalle, (SELECT COUNT(prod_codigo) FROM Producto JOIN Familia F2 ON prod_familia = F2.fami_id JOIN Item_Factura ON prod_codigo = item_producto WHERE F2.fami_detalle = F1.fami_detalle AND prod_codigo IN (SELECT item_producto FROM Item_Factura)) AS Cantidad_Productos,SUM(item_cantidad * item_precio) AS TOTAL FROM Familia F1
JOIN Producto ON fami_id = prod_familia
JOIN Item_Factura ON prod_codigo = item_producto
JOIN Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
GROUP BY fami_detalle,F1.fami_id
HAVING (SELECT SUM(fact_total) FROM Factura WHERE YEAR(fact_fecha) = 2012) > 20000
ORDER BY Cantidad_Productos DESC

/*12. Mostrar nombre de producto, cantidad de clientes distintos que lo compraron, importe
promedio pagado por el producto, cantidad de depósitos en los cuales hay stock del
producto y stock actual del producto en todos los depósitos. Se deberán mostrar
aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán
ordenarse de mayor a menor por monto vendido del producto.*/

SELECT prod_detalle,
(SELECT COUNT(fact_cliente) FROM Factura JOIN Item_Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero WHERE item_producto = prod_codigo) AS Cantidad_Clientes,
(SELECT AVG(item_precio) FROM Item_Factura WHERE item_producto = prod_codigo) AS PRECIO_PROMEDIO,
(SELECT COUNT(stoc_deposito) FROM STOCK WHERE stoc_producto = prod_codigo AND stoc_cantidad > 0) AS CANTIDAD_DEPO,
(SELECT SUM(stoc_cantidad) FROM STOCK WHERE stoc_producto = prod_codigo) AS STOCK_TOTAL
FROM Producto
GROUP BY prod_codigo,prod_detalle
HAVING prod_codigo IN (SELECT item_producto FROM Item_Factura JOIN Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero WHERE item_cantidad > 0 AND YEAR(fact_fecha)=2012)
ORDER BY (SELECT SUM(item_cantidad * item_precio) FROM Item_Factura WHERE item_producto = prod_codigo) DESC

/*13. Realizar una consulta que retorne para cada producto que posea composición nombre
del producto, precio del producto, precio de la sumatoria de los precios por la cantidad
de los productos que lo componen. Solo se deberán mostrar los productos que estén
compuestos por más de 2 productos y deben ser ordenados de mayor a menor por
cantidad de productos que lo componen.*/

SELECT prod_detalle,prod_precio,SUM(prod_precio) * COUNT(comp_cantidad) AS PRECIO_TOTAL
FROM Producto P1
JOIN Composicion C1 ON prod_codigo = comp_producto 
WHERE comp_cantidad > 2
GROUP BY prod_detalle,prod_precio,comp_cantidad
ORDER BY comp_cantidad DESC

/*14. Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que
debe retornar son:
Código del cliente
Cantidad de veces que compro en el último año
Promedio por compra en el último año
Cantidad de productos diferentes que compro en el último año
Monto de la mayor compra que realizo en el último año
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en
el último año.
No se deberán visualizar NULLs en ninguna columna*/

SELECT clie_codigo,
COUNT(fact_numero) AS CANTIDAD_DE_COMPRAS,
AVG(fact_total) AS PROMEDIO_POR_COMPRA,
COUNT(item_producto) AS PRODUCTOS_DISTINTOS,
(SELECT TOP 1 fact_total FROM Factura WHERE fact_cliente = clie_codigo ORDER BY fact_total DESC) AS MAYOR_MONTO
FROM Cliente C1
JOIN Factura ON clie_codigo = fact_cliente
JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
GROUP BY clie_codigo,fact_fecha
--HAVING YEAR(fact_fecha) = YEAR(GETDATE()) - 1
HAVING YEAR(fact_Fecha) = 2011
ORDER BY CANTIDAD_DE_COMPRAS DESC


/*15. Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) más de 500 veces. El resultado debe mostrar el código y
descripción de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron
juntos dichos productos. Los distintos pares no deben retornarse más de una vez.

Ejemplo de lo que retornaría la consulta:

PROD1 DETALLE1 PROD2 DETALLE2 VECES
1731 MARLBORO KS 1 7 1 8 P H ILIPS MORRIS KS 5 0 7
1718 PHILIPS MORRIS KS 1 7 0 5 P H I L I P S MORRIS BOX 10 5 6 2 
*/

--REVISAR EJERCICIO

SELECT P1.prod_codigo AS COD_PROD_1,P1.prod_detalle AS NOMBRE_PROD_1,P2.prod_codigo AS COD_PROD_2,p2.prod_detalle AS NOMBRE_PROD_2,
(SELECT COUNT(fact_tipo+fact_sucursal+fact_numero) FROM Factura F2 JOIN Item_Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero WHERE item_producto = P1.prod_codigo OR item_producto = P2.prod_codigo) AS CANTIDAD_JUNTOS
FROM Producto P1, Producto P2
JOIN Item_Factura ON P1.prod_codigo = item_producto OR P2.prod_codigo = item_producto
JOIN Factura F1 ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
WHERE F1.fact_tipo+F1.fact_sucursal+F1.fact_numero IN (SELECT item_tipo+item_sucursal+item_numero FROM Item_Factura WHERE item_producto = P1.prod_codigo) OR F1.fact_tipo+F1.fact_sucursal+F1.fact_numero IN (SELECT DISTINCT item_tipo+item_sucursal+item_numero FROM Item_Factura WHERE item_producto = P2.prod_codigo) 
GROUP BY P1.prod_codigo,P1.prod_detalle,P2.prod_codigo,p2.prod_detalle
HAVING (SELECT COUNT(fact_tipo+fact_sucursal+fact_numero) FROM Factura F2 JOIN Item_Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero WHERE item_producto = P1.prod_codigo OR item_producto = P2.prod_codigo) > 500
ORDER BY CANTIDAD_JUNTOS DESC

SELECT (SELECT prod_codigo AS COD_PROD_1 FROM Producto P1), (SELECT prod_detalle AS NOMBRE_PROD_1 FROM Producto P1), (SELECT prod_codigo AS COD_PROD_2 FROM Producto P2), (SELECT prod_detalle AS NOMBRE_PROD_2 FROM Producto P2)

--REVISAR EJERCICIO

/*16. Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas ventas son
inferiores a 1/3 del promedio de ventas del producto que más se vendió en el 2012.
Además mostrar
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1,
mostrar solamente el de menor código) para ese cliente.
Aclaraciones:
La composición es de 2 niveles, es decir, un producto compuesto solo se compone de
productos no compuestos.
Los clientes deben ser ordenados por código de provincia ascendente.
*/

SELECT clie_razon_social,SUM(item_cantidad) AS UNIDADES_TOTALES,
 (SELECT TOP 1 item_producto FROM Item_Factura JOIN Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero WHERE YEAR(fact_fecha) = 2012 AND fact_cliente = C1.clie_codigo GROUP BY item_producto ORDER BY item_producto ASC) AS CODIGO_PROD
 FROM Cliente C1
JOIN Factura ON fact_cliente = clie_codigo
JOIN Item_Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
WHERE YEAR(fact_fecha) = 2012
GROUP BY clie_razon_social,clie_codigo,fact_cliente
HAVING (SELECT SUM(item_cantidad*item_precio) WHERE fact_cliente = C1.clie_codigo) < (SELECT SUM(item_precio*item_cantidad)/3 FROM Item_factura I1 WHERE I1.item_producto = (SELECT TOP 1 item_producto FROM Item_Factura JOIN Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero WHERE YEAR(fact_fecha) = 2012 GROUP BY item_producto ORDER BY SUM(item_cantidad) DESC))
ORDER BY clie_domicilio ASC


/*17. Escriba una consulta que retorne una estadística de ventas por año y mes para cada
producto.
La consulta debe retornar:
PERIODO: Año y mes de la estadística con el formato YYYYMM
PROD: Código de producto
DETALLE: Detalle del producto
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo
pero del año anterior
CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el
periodo
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por periodo y código de producto. 
*/

SELECT DISTINCT CONCAT((CAST(YEAR(fact_fecha) AS char(4))),CAST(MONTH(fact_fecha) AS CHAR(2))) AS PERIODO,
CONCAT((CAST(YEAR(fact_fecha) - 1 AS char(4))),CAST(MONTH(fact_fecha) AS CHAR(2))) AS PERIODO_PASADO,
prod_codigo,
prod_detalle,
(SELECT SUM(item_cantidad) FROM Item_Factura JOIN Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero WHERE item_producto = prod_codigo AND CONCAT((CAST(YEAR(fact_fecha) AS char(4))),CAST(MONTH(fact_fecha) AS CHAR(2))) = CONCAT((CAST(YEAR(fact_fecha) AS char(4))),CAST(MONTH(fact_fecha) AS CHAR(2)))) AS CANTIDAD_VENDIDA,
(SELECT SUM(item_cantidad) FROM Item_Factura JOIN Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero WHERE item_producto = prod_codigo AND YEAR(F1.fact_fecha) - 1 = YEAR(fact_fecha) - 1 AND MONTH(F1.fact_fecha) = MONTH(fact_fecha)) AS VENTAS_AÑO_ANTERIOR,
(SELECT COUNT(item_tipo+item_sucursal+item_numero) FROM Item_Factura WHERE item_producto = P1.prod_codigo) AS CANTIDAD_FACTURAS
FROM Producto P1
JOIN Item_Factura ON prod_codigo = item_producto
JOIN Factura F1 ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
GROUP BY prod_codigo,prod_detalle,fact_fecha
ORDER BY PERIODO DESC,prod_codigo DESC

/*18. Escriba una consulta que retorne una estadística de ventas para todos los rubros.
La consulta debe retornar:
DETALLE_RUBRO: Detalle del rubro
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: Código del producto más vendido de dicho rubro
PROD2: Código del segundo producto más vendido de dicho rubro
CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30
días
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por cantidad de productos diferentes vendidos del rubro.
*/

SELECT rubr_detalle,
(SELECT SUM(item_cantidad * item_precio) FROM Item_Factura JOIN Producto ON item_producto = prod_codigo JOIN Rubro ON prod_rubro = rubr_id WHERE rubr_id = R1.rubr_id AND item_cantidad IS NOT NULL AND item_precio IS NOT NULL) AS VENTAS,
(SELECT TOP 1 item_producto FROM Item_Factura JOIN Producto ON item_producto = prod_codigo JOIN Rubro ON prod_rubro = rubr_id WHERE rubr_id = R1.rubr_id GROUP BY item_producto ORDER BY SUM(item_cantidad) DESC) AS PROD1,
(SELECT TOP 1 item_producto FROM Item_Factura I1 JOIN Producto ON item_producto = prod_codigo JOIN Rubro ON prod_rubro = rubr_id WHERE rubr_id = R1.rubr_id AND I1.item_producto != (SELECT TOP 1 item_producto FROM Item_Factura JOIN Producto ON item_producto = prod_codigo JOIN Rubro ON prod_rubro = rubr_id WHERE rubr_id = R1.rubr_id GROUP BY item_producto ORDER BY SUM(item_cantidad) DESC) GROUP BY item_producto ORDER BY SUM(item_cantidad) DESC) AS PROD2,
(SELECT TOP 1 fact_cliente FROM Factura JOIN Item_Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero JOIN Producto ON item_producto = prod_codigo JOIN Rubro ON prod_rubro = rubr_id WHERE rubr_id = R1.rubr_id AND fact_fecha BETWEEN GETDATE() AND DATEADD(MONTH, -1, GETDATE()) ORDER BY item_cantidad DESC) AS CLIENTE
FROM Rubro R1

/*19. En virtud de una recategorizacion de productos referida a la familia de los mismos se
solicita que desarrolle una consulta sql que retorne para todos los productos:
 Codigo de producto
 Detalle del producto
 Codigo de la familia del producto
 Detalle de la familia actual del producto
 Codigo de la familia sugerido para el producto
 Detalla de la familia sugerido para el producto
La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo
detalle coinciden en los primeros 5 caracteres.
En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor
codigo. Solo se deben mostrar los productos para los cuales la familia actual sea
diferente a la sugerida
Los resultados deben ser ordenados por detalle de producto de manera ascendente
*/

SELECT prod_codigo,prod_detalle,fami_id,fami_detalle,
(SELECT TOP 1 fami_id FROM Familia F2 JOIN Producto P2 ON fami_id=prod_familia WHERE SUBSTRING(P2.prod_detalle,1,5) = SUBSTRING(P1.prod_detalle,1,5) GROUP BY fami_detalle,fami_id ORDER BY fami_id ASC) AS COD_FAM_SUGERIDA,
(SELECT TOP 1 fami_detalle FROM Familia F2 JOIN Producto P2 ON fami_id=prod_familia WHERE SUBSTRING(P2.prod_detalle,1,5) = SUBSTRING(P1.prod_detalle,1,5) GROUP BY fami_detalle,fami_id ORDER BY fami_id ASC) AS DET_FAM_SUGERIDA  
FROM Producto P1
JOIN Familia F1 ON prod_familia = fami_id
WHERE F1.fami_id != (SELECT TOP 1 fami_id FROM Familia F2 JOIN Producto P2 ON fami_id=prod_familia WHERE SUBSTRING(P2.prod_detalle,1,5) = SUBSTRING(P1.prod_detalle,1,5) GROUP BY fami_id ORDER BY fami_id ASC)
GROUP BY prod_codigo,prod_detalle,fami_id,fami_detalle
ORDER BY prod_detalle ASC

-- (SELECT COUNT(SUBSTRING(P2.prod_detalle,1,5) = SUBSTRING(P1.prod_detalle,1,5))) >= (SELECT(COUNT(prod_codigo)/2)

--(SELECT TOP 1 fami_id FROM Familia F2 JOIN Producto P2 ON fami_id=prod_familia GROUP BY fami_id,fami_detalle,prod_codigo,prod_detalle HAVING (SELECT COUNT(prod_codigo) FROM Producto WHERE SUBSTRING(P2.prod_detalle,1,5) = SUBSTRING(P1.prod_detalle,1,5)GROUP BY prod_detalle,prod_codigo) >= (SELECT(COUNT(prod_codigo)/2) FROM Producto) ORDER BY fami_id ASC) AS COD_FAM_SUGERIDA,