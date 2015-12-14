--Cajas que tienen una cantidad de quejas mayores que la media
Select snombre From sucursal where nidsucursal IN (
Select nidsucursal FROM(
Select avg(unqf.nidsucursal) media, nidsucursal From(Select dfecha, nidsucursal_qm nidsucursal, sservicio from qmoral
union
Select dfecha, nidsucursal_qf nidsucursal, sservicio from qfisica) unqf where (sservicio like 'retiros') or (sservicio like 'depositos')
group by nidsucursal) prom where prom.media > (

Select avg(unqf.nidsucursal) From(Select dfecha, nidsucursal_qm nidsucursal, sservicio from qmoral
union
Select dfecha, nidsucursal_qf nidsucursal, sservicio from qfisica) unqf where (sservicio like 'retiros') or (sservicio like 'depositos')));






-- Maximo canal de ventas
SELECT MAX(f.VIA)
FROM(
SELECT scuenta_cfp AS CUENTA, svia AS VIA FROM cfp
UNION 
SELECT scuenta_cmp AS scuenta_cmp, svia AS VIA FROM cmp) AS f;


-- Persona que paga mas que el promedio
SELECT nidcliente_paf 
FROM pagaf 
GROUP BY nidcliente_paf HAVING AVG(nmonto) >=(
SELECT MAX(res."PAGOPROMEDIO")
FROM(
SELECT nidcliente_paf AS "CLIENTE", scuenta_paf AS "CUENTA", AVG(nmonto) AS "PAGOPROMEDIO" FROM pagaf 
GROUP BY nidcliente_paf, scuenta_paf 
HAVING AVG(nmonto) >
(SELECT AVG(f.MONTO)
FROM(
SELECT nidCliente_paf AS CLIENTE, nmonto AS MONTO FROM pagaf
UNION
SELECT nidCliente_pam AS CLIENTE, nmonto AS MONT FROM pagam) AS f)) AS res)


-- Empresa que para mas que el promedio
SELECT nidcliente_pam AS "NUMERO DE CLIENTE"
FROM pagam
GROUP BY nidcliente_pam HAVING AVG(nmonto) >=(
SELECT MAX(res."PAGOPROMEDIO")
FROM(
SELECT nidcliente_pam AS "CLIENTE", scuenta_pam AS "CUENTA", AVG(nmonto) AS "PAGOPROMEDIO" FROM pagam 
GROUP BY nidcliente_pam, scuenta_pam 
HAVING AVG(nmonto) >
(SELECT AVG(f.MONTO)
FROM(
SELECT nidCliente_paf AS CLIENTE, nmonto AS MONTO FROM pagaf
UNION
SELECT nidCliente_pam AS CLIENTE, nmonto AS MONT FROM pagam) AS f)) AS res)





-- Personas con la menor cantidad de movimientos
SELECT resultado."CLIENTE", resultado."APARICIONES"
FROM(
SELECT nidcliente_raaf AS "CLIENTE", COUNT(nidcliente_raaf) AS "APARICIONES" FROM retaaf GROUP BY nidcliente_raaf
UNION
SELECT nidcliente_ravf AS "CLIENTE", COUNT(nidcliente_ravf) AS "APARICIONES" FROM retavf GROUP BY nidcliente_ravf
UNION
SELECT nidcliente_paf AS "CLIENTE", COUNT(nidcliente_paf) AS "APARICIONES" FROM pagaf GROUP BY nidcliente_paf
UNION
SELECT nidcliente_rpf AS "CLIENTE", COUNT(nidcliente_rpf) AS "APARICIONES" FROM retprestamofis GROUP BY nidcliente_rpf
UNION
SELECT nidcliente_ppf AS "CLIENTE", COUNT(nidcliente_ppf) AS "APARICIONES" FROM pagpf GROUP BY nidcliente_ppf) AS resultado
GROUP BY resultado."CLIENTE" , resultado."APARICIONES"
HAVING resultado."APARICIONES" = (
SELECT MIN(res."APARICIONES")
FROM(
SELECT nidcliente_raaf AS "CLIENTE", COUNT(nidcliente_raaf) AS "APARICIONES" FROM retaaf GROUP BY nidcliente_raaf
UNION
SELECT nidcliente_ravf AS "CLIENTE", COUNT(nidcliente_ravf) AS "APARICIONES" FROM retavf GROUP BY nidcliente_ravf
UNION
SELECT nidcliente_paf AS "CLIENTE", COUNT(nidcliente_paf) AS "APARICIONES" FROM pagaf GROUP BY nidcliente_paf
UNION
SELECT nidcliente_rpf AS "CLIENTE", COUNT(nidcliente_rpf) AS "APARICIONES" FROM retprestamofis GROUP BY nidcliente_rpf
UNION
SELECT nidcliente_ppf AS "CLIENTE", COUNT(nidcliente_ppf) AS "APARICIONES" FROM pagpf GROUP BY nidcliente_ppf) AS res
)
ORDER BY RESULTADO."CLIENTE"

-- Empresas con la menor cantidad de movimientos
SELECT resultado."CLIENTE", resultado."APARICIONES"
FROM(
SELECT nidcliente_raam AS "CLIENTE", COUNT(nidcliente_raam) AS "APARICIONES" FROM retaam GROUP BY nidcliente_raam
UNION
SELECT nidcliente_ravm AS "CLIENTE", COUNT(nidcliente_ravm) AS "APARICIONES" FROM retavm GROUP BY nidcliente_ravm
UNION
SELECT nidcliente_pam AS "CLIENTE", COUNT(nidcliente_pam) AS "APARICIONES" FROM pagam GROUP BY nidcliente_pam
UNION
SELECT nidcliente_rpm AS "CLIENTE", COUNT(nidcliente_rpm) AS "APARICIONES" FROM retprestamomor GROUP BY nidcliente_rpm
UNION
SELECT nidcliente_ppm AS "CLIENTE", COUNT(nidcliente_ppm) AS "APARICIONES" FROM pagpm GROUP BY nidcliente_ppm) AS resultado
GROUP BY resultado."CLIENTE" , resultado."APARICIONES"
HAVING resultado."APARICIONES" = (
SELECT MIN(res."APARICIONES")
FROM(
SELECT nidcliente_raam AS "CLIENTE", COUNT(nidcliente_raam) AS "APARICIONES" FROM retaam GROUP BY nidcliente_raam
UNION
SELECT nidcliente_ravm AS "CLIENTE", COUNT(nidcliente_ravm) AS "APARICIONES" FROM retavm GROUP BY nidcliente_ravm
UNION
SELECT nidcliente_pam AS "CLIENTE", COUNT(nidcliente_pam) AS "APARICIONES" FROM pagam GROUP BY nidcliente_pam
UNION
SELECT nidcliente_rpm AS "CLIENTE", COUNT(nidcliente_rpm) AS "APARICIONES" FROM retprestamomor GROUP BY nidcliente_rpm
UNION
SELECT nidcliente_ppm AS "CLIENTE", COUNT(nidcliente_ppm) AS "APARICIONES" FROM pagpm GROUP BY nidcliente_ppm) AS res
)
ORDER BY RESULTADO."CLIENTE"

-- Personas con la mayor cantidad de movimientos
SELECT resultado."CLIENTE", resultado."APARICIONES"
FROM(
SELECT nidcliente_raaf AS "CLIENTE", COUNT(nidcliente_raaf) AS "APARICIONES" FROM retaaf GROUP BY nidcliente_raaf
UNION
SELECT nidcliente_ravf AS "CLIENTE", COUNT(nidcliente_ravf) AS "APARICIONES" FROM retavf GROUP BY nidcliente_ravf
UNION
SELECT nidcliente_paf AS "CLIENTE", COUNT(nidcliente_paf) AS "APARICIONES" FROM pagaf GROUP BY nidcliente_paf
UNION
SELECT nidcliente_rpf AS "CLIENTE", COUNT(nidcliente_rpf) AS "APARICIONES" FROM retprestamofis GROUP BY nidcliente_rpf
UNION
SELECT nidcliente_ppf AS "CLIENTE", COUNT(nidcliente_ppf) AS "APARICIONES" FROM pagpf GROUP BY nidcliente_ppf) AS resultado
GROUP BY resultado."CLIENTE" , resultado."APARICIONES"
HAVING resultado."APARICIONES" = (
SELECT MAX(res."APARICIONES")
FROM(
SELECT nidcliente_raaf AS "CLIENTE", COUNT(nidcliente_raaf) AS "APARICIONES" FROM retaaf GROUP BY nidcliente_raaf
UNION
SELECT nidcliente_ravf AS "CLIENTE", COUNT(nidcliente_ravf) AS "APARICIONES" FROM retavf GROUP BY nidcliente_ravf
UNION
SELECT nidcliente_paf AS "CLIENTE", COUNT(nidcliente_paf) AS "APARICIONES" FROM pagaf GROUP BY nidcliente_paf
UNION
SELECT nidcliente_rpf AS "CLIENTE", COUNT(nidcliente_rpf) AS "APARICIONES" FROM retprestamofis GROUP BY nidcliente_rpf
UNION
SELECT nidcliente_ppf AS "CLIENTE", COUNT(nidcliente_ppf) AS "APARICIONES" FROM pagpf GROUP BY nidcliente_ppf) AS res
)
ORDER BY RESULTADO."CLIENTE"

-- Empresas con la mayor cantidad de movimientos
SELECT resultado."CLIENTE", resultado."APARICIONES"
FROM(
SELECT nidcliente_raam AS "CLIENTE", COUNT(nidcliente_raam) AS "APARICIONES" FROM retaam GROUP BY nidcliente_raam
UNION
SELECT nidcliente_ravm AS "CLIENTE", COUNT(nidcliente_ravm) AS "APARICIONES" FROM retavm GROUP BY nidcliente_ravm
UNION
SELECT nidcliente_pam AS "CLIENTE", COUNT(nidcliente_pam) AS "APARICIONES" FROM pagam GROUP BY nidcliente_pam
UNION
SELECT nidcliente_rpm AS "CLIENTE", COUNT(nidcliente_rpm) AS "APARICIONES" FROM retprestamomor GROUP BY nidcliente_rpm
UNION
SELECT nidcliente_ppm AS "CLIENTE", COUNT(nidcliente_ppm) AS "APARICIONES" FROM pagpm GROUP BY nidcliente_ppm) AS resultado
GROUP BY resultado."CLIENTE" , resultado."APARICIONES"
HAVING resultado."APARICIONES" = (
SELECT MAX(res."APARICIONES")
FROM(
SELECT nidcliente_raam AS "CLIENTE", COUNT(nidcliente_raam) AS "APARICIONES" FROM retaam GROUP BY nidcliente_raam
UNION
SELECT nidcliente_ravm AS "CLIENTE", COUNT(nidcliente_ravm) AS "APARICIONES" FROM retavm GROUP BY nidcliente_ravm
UNION
SELECT nidcliente_pam AS "CLIENTE", COUNT(nidcliente_pam) AS "APARICIONES" FROM pagam GROUP BY nidcliente_pam
UNION
SELECT nidcliente_rpm AS "CLIENTE", COUNT(nidcliente_rpm) AS "APARICIONES" FROM retprestamomor GROUP BY nidcliente_rpm
UNION
SELECT nidcliente_ppm AS "CLIENTE", COUNT(nidcliente_ppm) AS "APARICIONES" FROM pagpm GROUP BY nidcliente_ppm) AS res
)
ORDER BY RESULTADO."CLIENTE"

-- Estados de cuenta de empresas
SELECT * FROM
(SELECT tfecha_pam AS "FECHAP", nidcliente_pam AS "CLIENTE", scuenta_pam AS "CUENTA" , nmonto AS "DEPOSITADO" 
FROM pagam
GROUP BY "FECHAP","CLIENTE", "CUENTA", "DEPOSITADO") AS C1,
(SELECT tfecha_raam AS "FECHAR", nidcliente_raam AS "CLIENTE", scuenta_raam AS "CUENTA", nmonto AS "RETIRADO ATM"
FROM retaam
GROUP BY "FECHAR","CLIENTE", "CUENTA", "RETIRADO ATM") AS C2,
(SELECT tfecha_ravm AS "FECHAV", nidcliente_ravm AS "CLIENTE", scuenta_ravm AS "CUENTA", nmonto AS "RETIRADO VENTANILLA"
FROM retavm
GROUP BY "FECHAV","CLIENTE", "CUENTA", "RETIRADO VENTANILLA") AS C3
WHERE C1."CLIENTE" = C2."CLIENTE" AND C2."CLIENTE" = C3."CLIENTE"

-- Estados de cuenta de personas
SELECT * FROM
(SELECT tfecha_paf AS "FECHAD", nidcliente_paf AS "CLIENTE", scuenta_paf AS "CUENTA" , nmonto AS "DEPOSITADO" 
FROM pagaf
GROUP BY "FECHAD","CLIENTE", "CUENTA", "DEPOSITADO") AS C1,
(SELECT tfecha_raaf AS "FECHAA", nidcliente_raaf AS "CLIENTE", scuenta_raaf AS "CUENTA", nmonto AS "RETIRADO ATM"
FROM retaaf
GROUP BY "FECHAA","CLIENTE", "CUENTA", "RETIRADO ATM") AS C2,
(SELECT tfecha_ravf AS "FECHAV", nidcliente_ravf AS "CLIENTE", scuenta_ravf AS "CUENTA", nmonto AS "RETIRADO VENTANILLA"
FROM retavf
GROUP BY "FECHAV","CLIENTE", "CUENTA", "RETIRADO VENTANILLA") AS C3
WHERE C1."CLIENTE" = C2."CLIENTE" AND C2."CLIENTE" = C3."CLIENTE"

-- consultas extras

-- Empresas y su pagina web, la cuales tengan mayor cantidad de prestamos que la media
Select snombre , sweb FROM moral where nidcliente_m IN (
Select nid from (
Select count(nidcliente_cmp) cont , nidcliente_cmp nid from cmp group by nidcliente_cmp) c where c.cont > (
Select avg(res) media from( 
Select count(scuenta_cmp) res , nidcliente_cmp from cmp group by nidcliente_cmp) conteo)
);


-- Personas que gastan mas que el promedio de las empresas. fckthm
Select 'Cliente: '||snombre ||' '|| spaterno || ' ' || smaterno || '"' || stcliente || '"' from fisica
where nidcliente_f IN( 

Select distinct(nidcliente_cfa) from cfa where scuenta_cfa IN (
Select cuenta from (
Select nmonto, scuenta_raaf cuenta from retaaf
union 
Select nmonto, scuenta_ravf cuenta from retavf ) ricos
where nmonto > (
Select avg(nmonto) from(
Select nmonto, scuenta_ravm cuenta from retavm
union
Select nmonto, scuenta_raam cuenta from retaam) empresas) ));


-- Sucursal con mayor numero de cajas(ventanilla/atm) no disponibles
Select * from sucursal where nidsucursal in (
Select id from (Select count(id) cuenta, id from (
Select 	nidventanilla caja, nidsucursal_v id from ventanilla where sestado like 'fuera de servicio'
union
Select nidatm  caja , nidsucursal_atm id from atm where sestado like 'fuera de servicio') inutil group by id) estos where cuenta = (

Select max(cuenta) FROM(
Select count(id) cuenta, id from (

Select 	nidventanilla caja, nidsucursal_v id from ventanilla where sestado like 'fuera de servicio'
union
Select nidatm  caja , nidsucursal_atm id from atm where sestado like 'fuera de servicio') inutil group by id) worst ));



-- Region donde se solicitan menos prestamos
Select 'Region ' || nregion from (
Select count(cuenta) conteo, nregion from 
(Select scuenta_cfp cuenta, nidsucursal_cfp id from cfp union Select scuenta_cmp cuenta, nidsucursal_cmp from cmp) cuentas join (Select nidsucursal, nregion from sucursal) suc 
ON nidsucursal = id
group by nregion) reg
where conteo = (
Select min(conteo) from (
Select count(cuenta) conteo, nregion from 
(Select scuenta_cfp cuenta, nidsucursal_cfp id from cfp union Select scuenta_cmp cuenta, nidsucursal_cmp from cmp) cuentas join (Select nidsucursal, nregion from sucursal) suc 
ON nidsucursal = id
group by nregion) estas)


-- Totales de los movimientos de cuentas de ahorro personas (se exentan las cuentas sin movimientos)
SELECT * FROM
(SELECT nidcliente_paf AS "CLIENTE", scuenta_paf AS "CUENTA" , SUM(nmonto) AS "DEPOSITADO" 
FROM pagaf
GROUP BY "CLIENTE", "CUENTA") AS C1
NATURAL JOIN
(SELECT nidcliente_raaf AS "CLIENTE", scuenta_raaf AS "CUENTA", SUM(nmonto) AS "RETIRADO ATM"
FROM retaaf 
GROUP BY "CLIENTE", "CUENTA") AS C2
NATURAL JOIN
(SELECT nidcliente_ravf AS "CLIENTE", scuenta_ravf AS "CUENTA", SUM(nmonto) AS "RETIRADO VENTANILLA"
FROM retavf
GROUP BY "CLIENTE", "CUENTA") AS C3
ORDER BY C2."CLIENTE", C2."CUENTA"

-- Totales de los movimientos de las cuentas de ahorro empresariales (se exentan las cuentas sin movimientos)
SELECT * FROM
(SELECT nidcliente_pam AS "CLIENTE", scuenta_pam AS "CUENTA" , SUM(nmonto) AS "DEPOSITADO" 
FROM pagam
GROUP BY "CLIENTE", "CUENTA") AS C1
NATURAL JOIN
(SELECT nidcliente_raam AS "CLIENTE", scuenta_raam AS "CUENTA", SUM(nmonto) AS "RETIRADO ATM"
FROM retaam
GROUP BY "CLIENTE", "CUENTA") AS C2
NATURAL JOIN
(SELECT nidcliente_ravm AS "CLIENTE", scuenta_ravm AS "CUENTA", SUM(nmonto) AS "RETIRADO VENTANILLA"
FROM retavm
GROUP BY "CLIENTE", "CUENTA") AS C3
ORDER BY C2."CLIENTE", C2."CUENTA"



