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
NEW.stipo := lower(NEW.stipo);
NEW.svia := lower(NEW.svia);
return NEW;
end;
$prestamo$  language plpgsql;
--------------------------------------------
--------------------------------------------

-- Trigger de insercion de cuentas de prestamo(persona fisica)
drop trigger bfr_ins_cfp on cfp;
create Trigger bfr_ins_cfp before insert on cfp 
for each row execute procedure prestamo_ok();
--------------

-- Trigger de insercion de cuentas de prestamo(persona moral)
drop trigger bfr_ins_cmp on cmp;
create Trigger bfr_ins_cmp before insert on cmp 
for each row execute procedure prestamo_ok();
--------------

-- Funcion para trigger de insercion en cma (cuentas morales ahorro)
create or replace function monto_min_m() returns Trigger as $mmm$
declare
begin
if(NEW.napertura < 6000) then
 return null;
end if;
NEW.nsaldo := NEW.napertura;
return NEW;
end;
$mmm$  language plpgsql;

-- Trigger de insercion en cma (cuentas morales ahorro)
drop trigger bfr_ins_cma on cma;
create Trigger bfr_ins_cma before insert on cma 
for each row execute procedure monto_min_m();

--------------
-- Funcion para trigger de insercion en cfa(cuentas fisica ahorro)
create or replace function monto_min_f() returns Trigger as $mmf$
declare
begin
if(NEW.napertura < 3000) then
 return null;
end if;
NEW.nsaldo := NEW.napertura;
return NEW;
end;
$mmf$  language plpgsql;
-- Trigger de insercion en cfa(cuentas fisica ahorro)
drop trigger bfr_ins_cfa on cfa;
create Trigger bfr_ins_cfa before insert on cfa 
for each row execute procedure monto_min_f();

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
create Trigger bins_cred_tcm before insert or update on ctcm_avalible()
for each row execute procedure ctcm_avalible();



