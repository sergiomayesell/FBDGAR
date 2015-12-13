--Cajas que tienen una cantidad de quejas mayores que la media

Select nidsucursal FROM(
Select avg(unqf.nidsucursal) media, nidsucursal From(Select dfecha, nidsucursal_qm nidsucursal, sservicio from qmoral
union
Select dfecha, nidsucursal_qf nidsucursal, sservicio from qfisica) unqf where (sservicio like 'retiros') or (sservicio like 'depositos')
group by nidsucursal) prom where prom.media > (

Select avg(unqf.nidsucursal) From(Select dfecha, nidsucursal_qm nidsucursal, sservicio from qmoral
union
Select dfecha, nidsucursal_qf nidsucursal, sservicio from qfisica) unqf where (sservicio like 'retiros') or (sservicio like 'depositos'));



-- Canal de ventas utilizado por todos los clientes

Select * from emailfisica join fisica on nidcliente_f = nidcliente_ef;

create or replace function r(n integer, 
s varchar) returns void as $$
begin
    If n >=0 then 
	raise notice '%', 'mayor a cero';
    end if;
    if n < -1 then
     raise notice '%', 'menor a cero';
    else
     raise notice 'cara de bola';
    end if;
    return;
end;
$$ language plpgsql;
select r(0, 'hola');

create or replace function cmp_ok(cuenta varchar, idS integer, idC integer, 
fecha date, monto integer, tipo varchar ,plazo integer, via varchar) returns void as $cmpok$
Declare
begin
if(monto >= 0 and monto < 15000) then
 if(lower(tipo) not like 'familiar') then 
 return;
 end if;
end if;
raise notice 'Pasado if 1';
if(monto >= 15000 and monto <50000) then
 if(lower(tipo) not like 'financiamiento') then 
 return;
 end if;
end if;	
raise notice 'Pasado if 2';
if(monto >= 50000 and monto <= 500000) then
 if(lower(tipo) not like 'inversion') then 
 return;
 end if;
end if;
raise notice 'Pasado if 3';
return;
end;
$cmpok$  language plpgsql;

create or replace function cmp_ok() returns Trigger as $cmpok$
declare
begin
if(NEW.nmonto >= 0 and NEW.nmonto < 15000) then
 if(lower(NEW.stipo) not like 'familiar') then 
 return null;
 end if;
end if;
--raise notice 'Pasado if 1';
if(NEW.nmonto >= 15000 and NEW.nmonto <50000) then
 if(lower(NEW.stipo) not like 'financiamiento') then 
 return null;
 end if;
end if;	
--raise notice 'Pasado if 2';
if(NEW.nmonto >= 50000 and NEW.nmonto <= 500000) then
 if(lower(NEW.stipo) not like 'inversion') then 
 return null;
 end if;
end if;
--raise notice 'Pasado if 3';
return NEW;
end;
$cmpok$  language plpgsql;

drop trigger bfr_ins_cmp on cmp;
create Trigger bfr_ins_cmp before insert or update on cmp 
for each row execute procedure cmp_ok();





INSERT INTO CMP (sCuenta_CMP,nIdSucursal_CMP,nIdCliente_CMP,dFecha,nMonto,sTipo,nPlazo,sVia) VALUES (cuenta,idS,idC, fecha,monto,tipo,plazo,via);


delete from cmp where scuenta_cmp
INSERT INTO CMP (sCuenta_CMP,nIdSucursal_CMP,nIdCliente_CMP,dFecha,nMonto,sTipo,nPlazo,sVia) VALUES (cuenta,idS,idC, fecha,monto,tipo,plazo,via);
select cmp_ok('cuenta', 1, 1,'2015-12-13', 25000,'familiar',12,'radio');
select cmp_ok('cuenta', 1, 1,'2015-12-13', 2000,'familiar',12,'radio');

INSERT INTO CMP (sCuenta_CMP,nIdSucursal_CMP,nIdCliente_CMP,dFecha,nMonto,sTipo,nPlazo,sVia) VALUES ('cuenta', 1, 1,'2015-12-13', 25000,'familiar',12,'radio');
INSERT INTO CMP (sCuenta_CMP,nIdSucursal_CMP,nIdCliente_CMP,dFecha,nMonto,sTipo,nPlazo,sVia) values ('cuenta', 1, 1,'2015-12-13', 2000,'familiar',12,'radio');

create or replace function cmp_ok(cuenta varchar, idS integer, idC integer, 
fecha date, monto integer, tipo varchar ,plazo integer, via varchar) returns void as $$
begin
if(monto >= 0 and monto < 15000) then
	if(lower(tipo) like lower('FAMILIAR')) then
		raise notice 'si es familiar';
	else
	  raise notice 'el monto es inadecuado al tipo';
	end if;
end if;
return;
end;
$$  language plpgsql;


create or replace function card_ok(cuenta varchar) returns void as $card$
declare
begin
if(cuenta IN (select scuenta_cfa from cfa)) then
	raise notice 'ya jalo';
end if;

end;
$card$  language plpgsql;

select card_ok('5318976510925759');
