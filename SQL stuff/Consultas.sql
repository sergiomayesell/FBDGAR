--Cajas que tienen una cantidad de quejas mayores que la media
Select nidsucursal FROM(
Select avg(unqf.nidsucursal) media, nidsucursal From(Select dfecha, nidsucursal_qm nidsucursal, sservicio from qmoral
union
Select dfecha, nidsucursal_qf nidsucursal, sservicio from qfisica) unqf where (sservicio like 'retiros') or (sservicio like 'depositos')
group by nidsucursal) prom where prom.media > (

Select avg(unqf.nidsucursal) From(Select dfecha, nidsucursal_qm nidsucursal, sservicio from qmoral
union
Select dfecha, nidsucursal_qf nidsucursal, sservicio from qfisica) unqf where (sservicio like 'retiros') or (sservicio like 'depositos'));






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
Select 'Sucursal: ' || snombre from sucursal where nidsucursal in (
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


-- 



