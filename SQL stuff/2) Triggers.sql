-- Function: prestamo_ok()
-- DROP FUNCTION ;
-- Verifica que el prestamo sea del rango aceptable y corresponda con el tipo.
-- Usada por los triggers bfr_ins_cfp y bfr_ins_cmp
create or replace function prestamo_ok() returns Trigger as $prestamo$
declare
begin
if(NEW.nmonto < 0) then
 return null;
end if;
if(NEW.nmonto >= 0 and NEW.nmonto < 15000) then
 if(lower(NEW.stipo) not like 'familiar') then 
 return null;
 end if;
end if;

if(NEW.nmonto >= 15000 and NEW.nmonto <50000) then
 if(lower(NEW.stipo) not like 'financiamiento') then 
 return null;
 end if;
end if;	

if(NEW.nmonto >= 50000 and NEW.nmonto <= 500000) then
 if(lower(NEW.stipo) not like 'inversion') then 
 return null;
 end if;
end if;
NEW.dfecha := now(); -- no cheating
NEW.stipo := lower(NEW.stipo);
NEW.svia := lower(NEW.svia);
return NEW;
end;
$prestamo$  language plpgsql;
-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en empleado
-- Verifica que el tipo de empleado sea ejecutivo/ventanilla
create or replace function esclavo() returns Trigger as $slave$
declare
begin
if (lower(NEW.stipo) NOT LIKE 'ejecutivo') then
 if(lower(NEW.stipo) NOT LIKE 'ventanilla') then
  return null;
 end if;
end if;
if (lower(NEW.stipo) NOT LIKE 'ventanilla') then
 if(lower(NEW.stipo) NOT LIKE 'ejecutivo') then
  return null;
 end if; 
end if;
NEW.stipo := lower(NEW.stipo);
NEW.srfc_e := lower(NEW.srfc_e);
return NEW;
end;
$slave$  language plpgsql;

-- Trigger de insercion en empleado, solo acepta ejecutivo/ventanilla
drop trigger employ_type on empleado;
create Trigger employ_type before insert or update on empleado
for each row execute procedure esclavo();
-------------------------------------------------------------------------------------

-- Trigger de insercion de cuentas de prestamo(persona fisica) 
drop trigger bfr_ins_cfp on cfp;
create Trigger bfr_ins_cfp before insert on cfp 
for each row execute procedure prestamo_ok();


-- Trigger de insercion de cuentas de prestamo(persona moral)
drop trigger bfr_ins_cmp on cmp;
create Trigger bfr_ins_cmp before insert on cmp 
for each row execute procedure prestamo_ok();
-------------------------------------------------------------------------------------

-- Funcion para trigger de insercion en cma (cuentas morales ahorro)
-- Verifica que el monto de apertura sea minimo 6k
create or replace function monto_min_m() returns Trigger as $mmm$
declare
begin
if(NEW.napertura < 6000) then
 return null;
end if;
NEW.nsaldo := NEW.napertura;
NEW.dfecha := now(); --no cheating
return NEW;
end;
$mmm$  language plpgsql;

-- Trigger de insercion en cma (cuentas morales ahorro)
drop trigger bfr_ins_cma on cma;
create Trigger bfr_ins_cma before insert on cma 
for each row execute procedure monto_min_m();

-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en cfa(cuentas fisica ahorro)
-- Verifica que el monto minimo de apertura sea 3k
create or replace function monto_min_f() returns Trigger as $mmf$
declare
begin
if(NEW.napertura < 3000) then
 return null;
end if;
NEW.nsaldo := NEW.napertura;
NEW.dfecha := now(); --no cheating
return NEW;
end;
$mmf$  language plpgsql;
-- Trigger de insercion en cfa(cuentas fisica ahorro)
drop trigger bfr_ins_cfa on cfa;
create Trigger bfr_ins_cfa before insert on cfa 
for each row execute procedure monto_min_f();
-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en tarjetas de cred_tcf
-- Verifica que el numero de tarjeta no exista.
create or replace function ctcf_avalible() returns Trigger as $card$
declare
begin
if(NEW.sTarjeta_TCF IN (SELECT starjeta_tcf FROM cred_tcf)) then
 return null;
end if;
if(NEW.sTarjeta_TCF IN (SELECT starjeta_tcm FROM cred_tcm)) then
 return null;
end if;
if(NEW.sTarjeta_TCF IN (SELECT starjeta_tdf FROM tar_tdf)) then
 return null;
end if;
if(NEW.sTarjeta_TCF IN (SELECT starjeta_tdm FROM tar_tdm)) then
 return null;
end if;
NEW.stipo := lower(NEW.stipo);
return NEW;
end;
$card$  language plpgsql;

-- Trigger de insercion en cred_tcf
drop trigger bins_cred_tcf on cred_tcf;
create Trigger bins_cred_tcf before insert or update on cred_tcf
for each row execute procedure ctcf_avalible();
-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en tarjetas de cred_tcf
-- Verifica que el numero de tarjeta no exista.
create or replace function ctcm_avalible() returns Trigger as $card$
declare
begin
if(NEW.sTarjeta_TCM IN (SELECT starjeta_tcf FROM cred_tcf)) then
 return null;
end if;
if(NEW.sTarjeta_TCM IN (SELECT starjeta_tcm FROM cred_tcm)) then
 return null;
end if;
if(NEW.sTarjeta_TCM IN (SELECT starjeta_tdf FROM tar_tdf)) then
 return null;
end if;
if(NEW.sTarjeta_TCM IN (SELECT starjeta_tdm FROM tar_tdm)) then
 return null;
end if;
NEW.stipo := lower(NEW.stipo);
return NEW;
end;
$card$  language plpgsql;

-- Trigger de insercion en cred_tcf
drop trigger bins_cred_tcm on cred_tcm;
create Trigger bins_cred_tcm before insert or update on cred_tcm
for each row execute procedure ctcm_avalible();
-------------------------------------------------------------------------------------

-- Funcion para trigger de insercion en tarjetas de tar_tdf
-- Verifica que el numero de tarjeta no exista.
create or replace function dtcf_avalible() returns Trigger as $card$
declare
begin
if(NEW.sTarjeta_TDF IN (SELECT starjeta_tcf FROM cred_tcf)) then
 return null;
end if;
if(NEW.sTarjeta_TDF IN (SELECT starjeta_tcm FROM cred_tcm)) then
 return null;
end if;
if(NEW.sTarjeta_TDF IN (SELECT starjeta_tdf FROM tar_tdf)) then
 return null;
end if;
if(NEW.sTarjeta_TDF IN (SELECT starjeta_tdm FROM tar_tdm)) then
 return null;
end if;
return NEW;
end;
$card$  language plpgsql;

-- Trigger de insercion en tar_tdf
drop trigger bins_tar_tdf on tar_tdf;
create Trigger bins_tar_tdf before insert or update on tar_tdf
for each row execute procedure dtcf_avalible();
-------------------------------------------------------------------------------------

-- Funcion para trigger de insercion en tarjetas de tar_tdm
-- Verifica que el numero de tarjeta no exista.
create or replace function dtcm_avalible() returns Trigger as $card$
declare
begin
if(NEW.sTarjeta_TDM IN (SELECT starjeta_tcf FROM cred_tcf)) then
 return null;
end if;
if(NEW.sTarjeta_TDM IN (SELECT starjeta_tcm FROM cred_tcm)) then
 return null;
end if;
if(NEW.sTarjeta_TDM IN (SELECT starjeta_tdf FROM tar_tdf)) then
 return null;
end if;
if(NEW.sTarjeta_TDM IN (SELECT starjeta_tdm FROM tar_tdm)) then
 return null;
end if;
return NEW;
end;
$card$  language plpgsql;

-- Trigger de insercion en tar_tdm
drop trigger bins_tar_tdm on tar_tdm;
create Trigger bins_tar_tdm before insert or update on tar_tdm
for each row execute procedure dtcm_avalible();
-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en asignacion de ventanillas
-- Verifica que la ventanilla pertenesca a la mismca sucursal del empleado
-- Verifica que el tipo del empleado sea ventanilla
create or replace function samePlace() returns Trigger as $okv$
declare 
begin
if(NEW.nidsucursal_a NOT IN (SELECT nidsucursal_v FROM ventanilla WHERE nidventanilla = NEW.nidventanilla_a)) then
 raise notice 'sucursal no corresponde';
 return null;
end if;
if('ventanilla' NOT LIKE (SELECT stipo FROM empleado WHERE lower(srfc_e) LIKE lower(NEW.srfc_a))) then
 raise notice 'es ejecutivo';
 return NULL;
end if;
NEW.srfc_a := lower(NEW.srfc_a);
return NEW;
end;
$okv$  language plpgsql;

-- Trigger de insercion en cred_tcf
drop trigger ok_asignacion on ev_asignado;
create Trigger ok_asignacion before insert or update on ev_asignado
for each row execute procedure samePlace();
-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en clientes
-- Asigna la region y zona de acuerdo al estado (esta funcion modifica el valor de region y zona si es que se paso como argumento de la insercion).
create or replace function zonifica() returns Trigger as $zone$
declare
begin
NEW.sestado := trim(NEW.sestado);	
if('aguascalientes' like lower(NEW.sestado)) then
	NEW.sestado := 'aguascalientes';
	NEW.nregion := 2;
	NEW.szona := 'occidental';
	return NEW;
end if;
if('baja california norte' like lower(NEW.sestado)) then
	NEW.sestado := 'baja california norte';
	NEW.nregion := 1;
	NEW.szona := 'occidental';
	return NEW;
end if;
if('baja california norte sur' like lower(NEW.sestado)) then
	NEW.sestado := 'baja california norte sur';
	NEW.nregion := 1;
	NEW.szona := 'occidental';
	return NEW;
end if;
if( 'campeche' like lower(NEW.sestado)) then
	NEW.sestado := 'campeche';
	NEW.nregion := 6;
	NEW.szona = 'centro';
	return NEW;
end if;
if( 'coahuila' like lower(NEW.sestado)) then
	NEW.sestado := 'coahuila';
	NEW.nregion := 3;
	NEW.szona = 'oriental';
	return NEW;
end if;
if( 'colima' like lower(NEW.sestado)) then
	NEW.sestado := 'colima';	
	New.nregion := 2;
	NEW.szona = 'occidental';
	return NEW;
end if;
if( 'chiapas' like lower(NEW.sestado)) then
	NEW.sestado := 'chiapas';	
	NEW.nregion := 5;
	NEW.szona = 'centro';
	return NEW;
end if;
if( 'chihuahua' like lower(NEW.sestado)) then
	NEW.sestado := 'chihuahua';
	New.nregion := 1;
	NEW.szona = 'occidental';
	return NEW;
end if;
if( 'distrito federal' like lower(NEW.sestado)) then
	NEW.sestado := 'distrito federal';
	NEW.nregion := 4;
	NEW.szona = 'oriental';
	return NEW;
end if;
if( 'durango' like lower(NEW.sestado)) then
	NEW.sestado := 'durango';
	New.nregion := 1;
	NEW.szona = 'occidental';
	return NEW;
end if;
if( 'guanajuato' like lower(NEW.sestado)) then
	NEW.sestado := 'guanajuato';	
	New.nregion := 2;
	NEW.szona = 'occidental';
	return NEW;
end if;
if( 'guerrero' like lower(NEW.sestado)) then
	NEW.sestado := 'guerrero';	
	NEW.nregion := 5;
	NEW.szona = 'centro';
	return NEW;
end if;
if( 'hidalgo' like lower(NEW.sestado)) then
	NEW.sestado := 'hidalgo';
	NEW.nregion := 4;
	NEW.szona = 'oriental';
	return NEW;
end if;
if( 'jalisco' like lower(NEW.sestado)) then
	NEW.sestado := 'jalisco';	
	New.nregion := 2;
	NEW.szona = 'occidental';
	return NEW;
end if;
if( 'estado de mexico' like lower(NEW.sestado)) then
	NEW.sestado := 'estado de mexico';
	NEW.nregion := 4;
	NEW.szona = 'oriental';
	return NEW;
end if;
if( 'michoacan' like lower(NEW.sestado)) then
	NEW.sestado := 'michoacan';	
	New.nregion := 2;
	NEW.szona = 'occidental';
	return NEW;
end if;
if( 'morelos' like lower(NEW.sestado)) then
	NEW.sestado := 'morelos';	
	NEW.nregion := 4;
	NEW.szona = 'oriental';
	return NEW;
end if;
if( 'nayarit' like lower(NEW.sestado)) then
	NEW.sestado := 'nayarit';	
	NEW.nregion := 2;
	NEW.szona = 'occidental';	
	return NEW;
end if;
if( 'nuevo leon' like lower(NEW.sestado)) then
	NEW.sestado := 'nuevo leon';
	NEW.nregion := 3;
	NEW.szona = 'oriental';
	return NEW;
end if;
if( 'oaxaca' like lower(NEW.sestado)) then
	NEW.sestado := 'oaxaca';	
	NEW.nregion := 5;
	NEW.szona = 'centro';
	return NEW;
end if;
if( 'puebla' like lower(NEW.sestado)) then
	NEW.sestado := 'puebla';
	NEW.nregion := 4;
	NEW.szona = 'oriental';
	return NEW;
end if;
if( 'queretaro' like lower(NEW.sestado)) then
	NEW.sestado := 'queretaro';
	NEW.nregion := 4;
	NEW.szona = 'oriental';
	return NEW;
end if;
if( 'quintana roo' like lower(NEW.sestado)) then
	NEW.sestado := 'quintana roo';
	NEW.nregion := 6;
	NEW.szona = 'centro';
	return NEW;
end if;
if( 'san luis potosi' like lower(NEW.sestado)) then
	NEW.sestado := 'san luis potosi';
	NEW.nregion := 3;
	NEW.szona = 'oriental';
	return NEW;
end if;
if( 'sinaloa' like lower(NEW.sestado)) then
	NEW.sestado := 'sinaloa';
	New.nregion := 1;
	NEW.szona = 'occidental';
	return NEW;
end if;
if( 'sonora' like lower(NEW.sestado)) then
	NEW.sestado := 'sonora';
	New.nregion := 1;
	NEW.szona = 'occidental';
	return NEW;
end if;
if( 'tabasco' like lower(NEW.sestado)) then
	NEW.sestado := 'tabasco';
	NEW.nregion := 6;
	NEW.szona = 'centro';
	return NEW;
end if;
if( 'tamaulipas' like lower(NEW.sestado)) then
	NEW.sestado := 'tamaulipas';
	NEW.nregion := 3;
	NEW.szona = 'oriental';
	return NEW;
end if;
if( 'tlaxcala' like lower(NEW.sestado)) then
	NEW.sestado := 'tlaxcala';
	NEW.nregion := 4;
	NEW.szona = 'oriental';
	return NEW;
end if;
if( 'veracruz' like lower(NEW.sestado)) then
	NEW.sestado := 'veracruz';
	NEW.nregion := 6;
	NEW.szona = 'centro';
	return NEW;
end if;
if( 'yucatan' like lower(NEW.sestado)) then
	NEW.sestado := 'yucatan';
	NEW.nregion := 6;
	NEW.szona = 'centro';
	return NEW;
end if;
if( 'zacatecas' like lower(NEW.sestado)) then
	NEW.sestado := 'zacatecas';
	NEW.nregion := 3;
	NEW.szona = 'oriental';
	return NEW;
end if;
raise notice '%',NEW.sestado || ' no es un estado valido.';
return null;
end;
$zone$  language plpgsql;

-- Trigger de insercion en fisica
-- Corrige la zona y region que se pase como argumento
drop trigger chk_fisica_estado on fisica;
create Trigger chk_fisica_estado before insert or update on fisica
for each row execute procedure zonifica();

-- Trigger de insercion en moral
-- Corrige la zona y region que se pase como argumento
drop trigger chk_moral_estado on moral;
create Trigger chk_moral_estado before insert or update on moral
for each row execute procedure zonifica();

-- Trigger de insercion en sucursal
-- Corrige la zona y region que se pase como argumento
drop trigger chk_sucursal_estado on sucursal;
create Trigger chk_sucursal_estado before insert or update on sucursal
for each row execute procedure zonifica();

-- Trigger de insercion en empleado
-- Corrige la zona y region que se pase como argumento
drop trigger chk_empleado_estado on empleado;
create Trigger chk_empleado_estado before insert or update on empleado
for each row execute procedure zonifica();

-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en retiros de cuentas de ahorro  de personas por atm
-- Verifica que la cuenta tenga fondos
create or replace function cash_aaf() returns Trigger as $cash$
declare
begin
if(NEW.nmonto > (select nsaldo from cfa where scuenta_cfa = NEW.scuenta_raaf and nidsucursal_cfa = NEW.nidsucursal_raaf and nidcliente_cfa = NEW.nidcliente_raaf)) then 
	return null;
end if;
return NEW;
end;
$cash$  language plpgsql;

-- Trigger de insercion en retaaf
drop trigger chk_cash_aaf on retaaf;
create Trigger chk_cash_aaf before insert on retaaf
for each row execute procedure cash_aaf();

-- Funcion para trigger de actualizacion despues de haber realizado un retiro/gasto
-- Actualiza el campo saldo
create or replace function burn_cfa() returns trigger as $lost$
declare
begin
UPDATE cfa SET nsaldo = (nsaldo - NEW.nmonto) WHERE scuenta_cfa = NEW.scuenta_raaf and nidsucursal_cfa = NEW.nidsucursal_raaf and nidcliente_cfa = NEW.nidcliente_raaf;
return null;
end;
$lost$  language plpgsql;

-- Trigger de actualizacion en cfa despues de insercion en retaaf
drop trigger exe_retaaf on retaaf;
create Trigger exe_retaaf after insert on retaaf
for each row execute procedure burn_cfa();
-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en retiros de cuentas de ahorro  de empresas por atm
-- Verifica que la cuenta tenga fondos
create or replace function cash_aam() returns Trigger as $cash$
declare
begin
if(NEW.nmonto > (select nsaldo from cma where scuenta_cma = NEW.scuenta_raam and nidsucursal_cma = NEW.ornidsucursal_raam and nidcliente_cma = NEW.nidcliente_raam)) then 
	return null;
end if;
return NEW;
end;
$cash$  language plpgsql;

-- Trigger de insercion en retaam
drop trigger chk_cash_aam on retaam;
create Trigger chk_cash_aam before insert on retaam
for each row execute procedure cash_aam();


-- Funcion para trigger de actualizacion despues de haber realizado un retiro/gasto
-- Actualiza el campo saldo
create or replace function burn_cma() returns trigger as $lost$
declare
begin
UPDATE cma SET nsaldo = (nsaldo - NEW.nmonto) WHERE scuenta_cma = NEW.scuenta_raam and nidsucursal_cma = NEW.ornidsucursal_raam and nidcliente_cma = NEW.nidcliente_raam;
return null;
end;
$lost$  language plpgsql;

-- Trigger de actualizacion en cma despues de insercion en retaam
drop trigger exe_retaam on retaam;
create Trigger exe_retaam after insert on retaam
for each row execute procedure burn_cma();

-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en retiros de cuentas de ahorro  de personas por ventanilla
-- Verifica que la cuenta tenga fondos
create or replace function cash_avf() returns Trigger as $cash$
declare
begin
if(NEW.nmonto > (select nsaldo from cfa where scuenta_cfa = NEW.scuenta_ravf and nidsucursal_cfa = NEW.nidsucursal_ravf and nidcliente_cfa = NEW.nidcliente_ravf)) then 
	return null;
end if;
return NEW;
end;
$cash$  language plpgsql;

-- Trigger de insercion en retavf
drop trigger chk_cash_avf on retavf;
create Trigger chk_cash_avf before insert on retavf
for each row execute procedure cash_avf();

-- Funcion para trigger de actualizacion despues de haber realizado un retiro/gasto
-- Actualiza el campo saldo
create or replace function burn_cfa2() returns trigger as $lost$
declare
begin
UPDATE cfa SET nsaldo = (nsaldo - NEW.nmonto) WHERE scuenta_cfa = NEW.scuenta_ravf and nidsucursal_cfa = NEW.nidsucursal_ravf and nidcliente_cfa = NEW.nidcliente_ravf;
return null;
end;
$lost$  language plpgsql;

-- Trigger de actualizacion en cfa despues de insercion en retavf
drop trigger exe_retavf on retavf;
create Trigger exe_retavf after insert on retavf
for each row execute procedure burn_cfa2();
-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en retiros de cuentas de ahorro  de empresas por ventanilla
-- Verifica que la cuenta tenga fondos
create or replace function cash_avm() returns Trigger as $cash$
declare
begin
if(NEW.nmonto > (select nsaldo from cma where scuenta_cma = NEW.scuenta_ravm and nidsucursal_cma = NEW.ornidsucursal_ravm and nidcliente_cma = NEW.nidcliente_ravm)) then 
	return null;
end if;
return NEW;
end;
$cash$  language plpgsql;

-- Trigger de insercion en retavm
drop trigger chk_cash_avm on retavm;
create Trigger chk_cash_avm before insert on retavm
for each row execute procedure cash_avm();


-- Funcion para trigger de actualizacion despues de haber realizado un retiro/gasto
-- Actualiza el campo saldo
create or replace function burn_cma2() returns trigger as $lost$
declare
begin
UPDATE cma SET nsaldo = (nsaldo - NEW.nmonto) WHERE scuenta_cma = NEW.scuenta_ravm and nidsucursal_cma = NEW.ornidsucursal_ravm and nidcliente_cma = NEW.nidcliente_ravm;
return null;
end;
$lost$  language plpgsql;

-- Trigger de actualizacion en cma despues de insercion en retaam
drop trigger exe_retavm on retavm;
create Trigger exe_retavm after insert on retavm
for each row execute procedure burn_cma2();

-------------------------------------------------------------------------------------
-- Funcion para trigger de actualizacion despues de haber un deposito/abono
-- Actualiza el campo saldo
create or replace function more_cfa() returns trigger as $more$
declare
begin
UPDATE cfa SET nsaldo = (nsaldo + NEW.nmonto) WHERE scuenta_cfa = NEW.scuenta_paf and nidsucursal_cfa = NEW.orgnidsucursal_paf and nidcliente_cfa = NEW.nidcliente_paf;
return null;
end;
$more$  language plpgsql;

-- Trigger de actualizacion en cfa despues de insercion en retaaf
drop trigger exe_pagaf on pagaf;
create Trigger exe_pagaf after insert on pagaf
for each row execute procedure more_cfa();

-------------------------------------------------------------------------------------
-- Funcion para trigger de actualizacion despues de haber realizado deposito/abono
-- Actualiza el campo saldo
create or replace function more_cma() returns trigger as $more$
declare
begin
UPDATE cma SET nsaldo = (nsaldo + NEW.nmonto) WHERE scuenta_cma = NEW.scuenta_pam and nidsucursal_cma = NEW.ornidsucursal_pam and nidcliente_cma = NEW.nidcliente_pam;
return null;
end;
$more$  language plpgsql;

-- Trigger de actualizacion en cfa despues de insercion en retaaf
drop trigger exe_pagam on pagam;
create Trigger exe_pagam after insert on pagam
for each row execute procedure more_cma();

-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en retprestamofis
create or replace function cash_cfp() returns trigger as $cash$
declare
retirado integer;
otorgado integer;
plazo integer;
meses integer;
begin
if(NEW.nmonto < 0) then	
	return NULL;
end if;
SELECT sum(nmonto) INTO retirado FROM retprestamofis WHERE scuenta_rpf = NEW.scuenta_rpf AND nidcliente_rpf = NEW.nidcliente_rpf AND ornidsucursal_rpf = NEW.ornidsucursal_rpf AND nmonto > 0; 
SELECT nmonto INTO otorgado FROM cfp WHERE scuenta_cfp = NEW.scuenta_rpf AND nidcliente_cfp = NEW.nidcliente_rpf AND nidsucursal_cfp = NEW.ornidsucursal_rpf;
if(retirado is null) then
	if(NEW.nmonto > otorgado) then		
		return null;
	end if;
else
	if(NEW.nmonto > (otorgado - retirado)) then		
		return null;
	end if;
end if;
SELECT extract(month from age(now(), dfecha)) into meses FROM cfp WHERE scuenta_cfp = NEW.scuenta_rpf AND nidcliente_cfp = NEW.nidcliente_rpf AND nidsucursal_cfp = NEW.ornidsucursal_rpf;
SELECT nplazo into plazo FROM cfp WHERE scuenta_cfp = NEW.scuenta_rpf AND nidcliente_cfp = NEW.nidcliente_rpf AND nidsucursal_cfp = NEW.ornidsucursal_rpf;
if(meses > plazo) then
return null;
end if;
return NEW;
end;
$cash$  language plpgsql;

-- Trigger de actualizacion en cfa despues de insercion en retaaf
drop trigger exe_retiro_cfp on retprestamofis;
create Trigger exe_retiro_cfp before insert on retprestamofis
for each row execute procedure cash_cfp();

-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en retprestamomor
create or replace function cash_cmp() returns trigger as $cash$
declare
retirado integer;
otorgado integer;
plazo integer;
meses integer;
begin
if(NEW.nmonto < 0) then	
	return NULL;
end if;
SELECT sum(nmonto) INTO retirado FROM retprestamomor WHERE scuenta_rpm = NEW.scuenta_rpm AND nidcliente_rpm = NEW.nidcliente_rpm AND ornidsucursal_rpm = NEW.ornidsucursal_rpm AND nmonto > 0; 
SELECT nmonto INTO otorgado FROM cmp WHERE scuenta_cmp = NEW.scuenta_rpm AND nidcliente_cmp = NEW.nidcliente_rpm AND nidsucursal_cmp = NEW.ornidsucursal_rpm;
if(retirado is null) then
	if(NEW.nmonto > otorgado) then		
		return null;
	end if;
else
	if(NEW.nmonto > (otorgado - retirado)) then		
		return null;
	end if;
end if;
SELECT extract(month from age(now(), dfecha)) into meses FROM cmp WHERE scuenta_cmp = NEW.scuenta_rpm AND nidcliente_cmp = NEW.nidcliente_rpm AND nidsucursal_cmp = NEW.ornidsucursal_rpm;
SELECT nplazo into plazo FROM cmp WHERE scuenta_cmp = NEW.scuenta_rpm AND nidcliente_cmp = NEW.nidcliente_rpm AND nidsucursal_cmp = NEW.ornidsucursal_rpm;
if(meses > plazo) then
return null;
end if;
return NEW;
end;
$cash$  language plpgsql;

-- Trigger de actualizacion en cfa despues de insercion en retaaf
drop trigger exe_retiro_cmp on retprestamomor;
create Trigger exe_retiro_cmp before insert on retprestamomor
for each row execute procedure cash_cmp();



-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en pagos a cuentas de prestamos fisica
create or replace function pay_cfp() returns trigger as $payed$
declare
ultimo date;
fapertura date;
abono integer;
monto integer;
pmin integer;
interes integer;
isOK integer;
pago integer;
today integer;
trans integer;
begin
if(NEW.nmonto < 0) then
return NEW;
end if;
SELECT max(tfecha_ppf) into ultimo FROM pagpf WHERE scuenta_ppf = NEW.scuenta_ppf AND nidcliente_ppf = NEW.nidcliente_ppf AND ornidsucursal_ppf = NEW.ornidsucursal_ppf;
SELECT dfecha INTO fapertura FROM cfp WHERE scuenta_cfp = NEW.scuenta_ppf AND nidcliente_cfp = NEW.nidcliente_ppf AND nidsucursal_cfp = NEW.ornidsucursal_ppf;
SELECT nplazo INTO pmin FROM cfp WHERE scuenta_cfp = NEW.scuenta_ppf AND nidcliente_cfp = NEW.nidcliente_ppf AND nidsucursal_cfp = NEW.ornidsucursal_ppf;
SELECT nmonto INTO monto FROM cfp WHERE scuenta_cfp = NEW.scuenta_ppf AND nidcliente_cfp = NEW.nidcliente_ppf AND nidsucursal_cfp = NEW.ornidsucursal_ppf;
SELECT nabonado INTO abono FROM cfp WHERE scuenta_cfp = NEW.scuenta_ppf AND nidcliente_cfp = NEW.nidcliente_ppf AND nidsucursal_cfp = NEW.ornidsucursal_ppf;
if(ultimo is null)then
	SELECT extract(month from age(fapertura, now())) INTO isOK;	
else
	SELECT extract(month from age(fapertura, now())) INTO today;
	SELECT extract(month from age(fapertura, ultimo)) INTO pago;
	isOK := today - pago;
	if(isOK < 0) then -- wtf!!!!!!!
		return null;
	end if;		
end if;
interes := 0;
if(isOK > 3) then -- u'r busted	
	interes := monto * -15 / 100;	
	INSERT INTO pagpf (scuenta_ppf, nidcliente_ppf, ornidsucursal_ppf, pagnidsucursal_ppf,nmonto) VALUES (NEW.scuenta_ppf, NEW.nidcliente_ppf, NEW.ornidsucursal_ppf, NEW.pagnidsucursal_ppf, interes);
end if;
pmin := monto / pmin;
trans := monto - abono;
if((NEW.nmonto + interes) > trans) then
	NEW.nmonto := trans - intereses;
	return NEW;	
else
	if((NEW.nmonto + interes) > pmin) then
		UPDATE cfp SET nabonado = (nabonado + monto * 3 / 100) WHERE scuenta_cfp = NEW.scuenta_ppf AND nidcliente_cfp = NEW.nidcliente_ppf AND ornidsucursal_cfp = NEW.ornidsucursal_ppf;	
	end if;
end if;	
return NEW;
end;
$payed$  language plpgsql;

-- Trigger de insercion en pagpf genera interese y todo
drop trigger exe_pago_cfp on pagpf;
create Trigger exe_pago_cfp before insert on pagpf
for each row execute procedure pay_cfp();

create or replace function upd_monto_cfp() returns trigger as $pagado$ 
declare
actual integer;
monto integer;
generado integer;
begin
SELECT nabonado INTO actual FROM cfp WHERE scuenta_cfp = NEW.scuenta_ppf AND nidcliente_cfp = NEW.nidcliente_ppf AND nidsucursal_cfp = NEW.ornidsucursal_ppf;
SELECT nmonto INTO monto FROM cfp WHERE scuenta_cfp = NEW.scuenta_ppf AND nidcliente_cfp = NEW.nidcliente_ppf AND nidsucursal_cfp = NEW.ornidsucursal_ppf;
SELECT sum(nmonto) INTO generado FROM pagpf WHERE scuenta_ppf = NEW.scuenta_ppf AND nidcliente_ppf = NEW.nidcliente_ppf AND nidsucursal_ppf = NEW.ornidsucursal_ppf;	
if(generado >= actual) then
	UPDATE cfp SET nabonado = generado WHERE scuenta_cfp = NEW.scuenta_ppf AND nidcliente_cfp = NEW.nidcliente_ppf AND ornidsucursal_cfp = NEW.ornidsucursal_ppf;
end if;
return null;
end;
$pagado$ language plpgsql;

-- Trigger de actualizacion del monto pagado del prestamo
drop trigger upd_cfp on pagpf;
create Trigger upd_cfp after insert on pagpf
for each row execute procedure upd_monto_cfp();

-------------------------------------------------------------------------------------
-- Funcion para trigger de insercion en pagos a cuentas de prestamos moral
create or replace function pay_cmp() returns trigger as $payed$
declare
ultimo date;
fapertura date;
abono integer;
monto integer;
pmin integer;
interes integer;
isOK integer;
pago integer;
today integer;
trans integer;
begin
if(NEW.nmonto < 0) then
return NEW;
end if;
SELECT max(tfecha_ppm) into ultimo FROM pagpm WHERE scuenta_ppm = NEW.scuenta_ppm AND nidcliente_ppm = NEW.nidcliente_ppm AND ornidsucursal_ppm = NEW.ornidsucursal_ppm;
SELECT dfecha INTO fapertura FROM cmp WHERE scuenta_cmp = NEW.scuenta_ppm AND nidcliente_cmp = NEW.nidcliente_ppm AND nidsucursal_cmp = NEW.ornidsucursal_ppm;
SELECT nplazo INTO pmin FROM cmp WHERE scuenta_cmp = NEW.scuenta_ppm AND nidcliente_cmp = NEW.nidcliente_ppm AND nidsucursal_cmp = NEW.ornidsucursal_ppm;
SELECT nmonto INTO monto FROM cmp WHERE scuenta_cmp = NEW.scuenta_ppm AND nidcliente_cmp = NEW.nidcliente_ppm AND nidsucursal_cmp = NEW.ornidsucursal_ppm;
SELECT nabonado INTO abono FROM cmp WHERE scuenta_cmp = NEW.scuenta_ppm AND nidcliente_cmp = NEW.nidcliente_ppm AND nidsucursal_cmp = NEW.ornidsucursal_ppm;
if(ultimo is null)then
	SELECT extract(month from age(fapertura, now())) INTO isOK;	
else
	SELECT extract(month from age(fapertura, now())) INTO today;
	SELECT extract(month from age(fapertura, ultimo)) INTO pago;
	isOK := today - pago;
	if(isOK < 0) then -- wtf!!!!!!!
		return null;
	end if;		
end if;
interes := 0;
if(isOK > 3) then -- u'r busted	
	interes := monto * -15 / 100;	
	INSERT INTO pagpm (scuenta_ppm, nidcliente_ppm, ornidsucursal_ppm, pagnidsucursal_ppm,nmonto) VALUES (NEW.scuenta_ppm, NEW.nidcliente_ppm, NEW.ornidsucursal_ppm, NEW.pagnidsucursal_ppm, interes);
end if;
pmin := monto / pmin;
trans := monto - abono;
if((NEW.nmonto + interes) > trans) then
	NEW.nmonto := trans - intereses;
	return NEW;
end if;	
return NEW;
end;
$payed$  language plpgsql;

-- Trigger de insercion en pagpf genera interese y todo
drop trigger exe_pago_cmp on pagpm;
create Trigger exe_pago_cmp before insert on pagpm
for each row execute procedure pay_cmp();

create or replace function upd_monto_cmp() returns trigger as $pagado$ 
declare
actual integer;
monto integer;
generado integer;
begin
SELECT nabonado INTO actual FROM cmp WHERE scuenta_cmp = NEW.scuenta_ppm AND nidcliente_cmp = NEW.nidcliente_ppm AND nidsucursal_cmp = NEW.ornidsucursal_ppm;
SELECT nmonto INTO monto FROM cmp WHERE scuenta_cmp = NEW.scuenta_ppm AND nidcliente_cmp = NEW.nidcliente_ppm AND nidsucursal_cmp = NEW.ornidsucursal_ppm;
SELECT sum(nmonto) INTO generado FROM pagpm WHERE scuenta_ppm = NEW.scuenta_ppm AND nidcliente_ppm = NEW.nidcliente_ppm AND nidsucursal_ppm = NEW.ornidsucursal_ppm;	
if(generado >= actual) then
	UPDATE cmp SET nabonado = generado WHERE scuenta_cmp = NEW.scuenta_ppm AND nidcliente_cmp = NEW.nidcliente_ppm AND ornidsucursal_cmp = NEW.ornidsucursal_ppm;
end if;
return null;
end;
$pagado$ language plpgsql;

-- Trigger de actualizacion del monto pagado del prestamo
drop trigger upd_cmp on pagpm;
create Trigger upd_cmp after insert on pagpm
for each row execute procedure upd_monto_cmp();