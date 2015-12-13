-- Schema: public

DROP SCHEMA public CASCADE;

CREATE SCHEMA public
  AUTHORIZATION postgres;

GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
COMMENT ON SCHEMA public
  IS 'Esquema de la base de datos del Banco Trasatlantico. Fisicas y Moral se refieren a los clientes personas y empresas respectivamente. Prestamos se refiere a los creditos otorgados, los cuales no son diferentes de una tarjeta de credito.';


CREATE SEQUENCE moral_nidcliente_m_seq;

CREATE TABLE Moral (
                nIdCliente_M INTEGER NOT NULL DEFAULT nextval('moral_nidcliente_m_seq'),
                sTipo VARCHAR NOT NULL,
                nDependiente INTEGER DEFAULT 0 NOT NULL,
                sWeb VARCHAR NOT NULL,
                sNombre VARCHAR NOT NULL,
                sDireccion VARCHAR NOT NULL,
                nExt INTEGER NOT NULL,
                nInt INTEGER,
                sColonia VARCHAR NOT NULL,
                sDelegacion VARCHAR NOT NULL,
                sCP VARCHAR NOT NULL,
                sEstado VARCHAR NOT NULL,
                nRegion INTEGER NOT NULL,
                sZona VARCHAR NOT NULL,
                sRFC VARCHAR(12) NOT NULL,
                CONSTRAINT nidmoral PRIMARY KEY (nIdCliente_M)
);
COMMENT ON TABLE Moral IS 'Datos de los clientes(Empresas)';


ALTER SEQUENCE moral_nidcliente_m_seq OWNED BY Moral.nIdCliente_M;

CREATE TABLE telMoral (
                sTelefono_tM VARCHAR NOT NULL,
                nIdCliente_tM INTEGER NOT NULL,
                CONSTRAINT stelefono_tm PRIMARY KEY (sTelefono_tM, nIdCliente_tM)
);
COMMENT ON TABLE telMoral IS 'Telefonos de los clientes(Empresas)';


CREATE TABLE emailMoral (
                sEmail_eM VARCHAR NOT NULL,
                nIdCliente_eM INTEGER NOT NULL,
                CONSTRAINT semail_em PRIMARY KEY (sEmail_eM, nIdCliente_eM)
);
COMMENT ON TABLE emailMoral IS 'Email de los clientes(Empresas)';


CREATE SEQUENCE fisica_nidcliente_f_seq;

CREATE TABLE Fisica (
                nIdCliente_F INTEGER NOT NULL DEFAULT nextval('fisica_nidcliente_f_seq'),
                sTCliente VARCHAR NOT NULL,
                sNombre VARCHAR NOT NULL,
                sPaterno VARCHAR NOT NULL,
                sMaterno VARCHAR,
                sGenero VARCHAR NOT NULL,
                sCURP VARCHAR(18) NOT NULL,
                sECivil VARCHAR NOT NULL,
                dFNac DATE NOT NULL,
                sJob VARCHAR NOT NULL,
                sEscolaridad VARCHAR NOT NULL,
                nDependientes INTEGER DEFAULT 0 NOT NULL,
                sDireccion VARCHAR NOT NULL,
                nExt INTEGER NOT NULL,
                nInt INTEGER,
                sColonia VARCHAR NOT NULL,
                sDelegacion VARCHAR NOT NULL,
                sCP VARCHAR NOT NULL,
                sEstado VARCHAR NOT NULL,
                nRegion INTEGER NOT NULL,
                sZona VARCHAR NOT NULL,
                sRFC VARCHAR(13) NOT NULL,
                CONSTRAINT nidfisica PRIMARY KEY (nIdCliente_F)
);
COMMENT ON TABLE Fisica IS 'Datos de los clientes(personas)';


ALTER SEQUENCE fisica_nidcliente_f_seq OWNED BY Fisica.nIdCliente_F;

CREATE TABLE telFisica (
                sTelefonoF VARCHAR NOT NULL,
                nIdCliente_tF INTEGER NOT NULL,
                CONSTRAINT stelefonof PRIMARY KEY (sTelefonoF, nIdCliente_tF)
);
COMMENT ON TABLE telFisica IS 'Telefonos de los clientes (personas)';


CREATE TABLE emailFisica (
                sEmailF VARCHAR NOT NULL,
                nIdCliente_eF INTEGER NOT NULL,
                CONSTRAINT semailf PRIMARY KEY (sEmailF, nIdCliente_eF)
);
COMMENT ON TABLE emailFisica IS 'Correos electronicos de los clientes(personas)';


CREATE SEQUENCE sucursal_nidsucursal_seq;

CREATE TABLE Sucursal (
                nIdSucursal INTEGER NOT NULL DEFAULT nextval('sucursal_nidsucursal_seq'),
                nMetros INTEGER NOT NULL,
                nTipo INTEGER NOT NULL,
                sNombre VARCHAR NOT NULL,
                sDireccion VARCHAR NOT NULL,
                nExt INTEGER NOT NULL,
                nInt INTEGER NOT NULL,
                sColonia VARCHAR NOT NULL,
                sDelegacion VARCHAR NOT NULL,
                sCP VARCHAR NOT NULL,
                sEstado VARCHAR NOT NULL,
                nRegion INTEGER NOT NULL,
                sZona VARCHAR NOT NULL,
                CONSTRAINT nidsucursal PRIMARY KEY (nIdSucursal)
);
COMMENT ON TABLE Sucursal IS 'Datos de las sucursales.
Tipo de sucursal:
1: Sucursal
2: Sucursal dentro de otro establecimiento
3: Banca en linea';
COMMENT ON COLUMN Sucursal.nTipo IS '1: Sucursal
2: Sucursal dentro de otro establecimiento
3: Banca en linea';


ALTER SEQUENCE sucursal_nidsucursal_seq OWNED BY Sucursal.nIdSucursal;

CREATE SEQUENCE qmoral_nidqueja_qm_seq;

CREATE TABLE qMoral (
                nIdQueja_qM INTEGER NOT NULL DEFAULT nextval('qmoral_nidqueja_qm_seq'),
                nIdSucursal_qM INTEGER NOT NULL,
                nIdCliente_qM INTEGER NOT NULL,
                dFecha DATE NOT NULL,
                sService VARCHAR NOT NULL,
                sAsunto VARCHAR NOT NULL,
                sDesc VARCHAR NOT NULL,
                CONSTRAINT nidqueja_qm PRIMARY KEY (nIdQueja_qM, nIdSucursal_qM, nIdCliente_qM)
);
COMMENT ON TABLE qMoral IS 'Quejas realizadas por Empresas respecto a los servicios del banco.';


ALTER SEQUENCE qmoral_nidqueja_qm_seq OWNED BY qMoral.nIdQueja_qM;

CREATE SEQUENCE qfisica_nidqueja_qf_seq;

CREATE TABLE qFisica (
                nIdQueja_qF INTEGER NOT NULL DEFAULT nextval('qfisica_nidqueja_qf_seq'),
                nIdSucursal_qF INTEGER NOT NULL,
                nIdCliente_qF INTEGER NOT NULL,
                dFecha DATE NOT NULL,
                sServicio VARCHAR NOT NULL,
                sAsunto VARCHAR NOT NULL,
                sDesc VARCHAR NOT NULL,
                CONSTRAINT nidqueja_qf PRIMARY KEY (nIdQueja_qF, nIdSucursal_qF, nIdCliente_qF)
);
COMMENT ON TABLE qFisica IS 'Quejas realizadas por personas respecto a los servicios del banco.';


ALTER SEQUENCE qfisica_nidqueja_qf_seq OWNED BY qFisica.nIdQueja_qF;

CREATE SEQUENCE evalfisica_nidevaluacion_evf_seq;

CREATE TABLE evalFisica (
                nIdEvaluacion_evF INTEGER NOT NULL DEFAULT nextval('evalfisica_nidevaluacion_evf_seq'),
                nIdSucursal_evF INTEGER NOT NULL,
                nIdCliente_evF INTEGER NOT NULL,
                sTiempo VARCHAR NOT NULL,
                sClaridad VARCHAR NOT NULL,
                sAtencion VARCHAR NOT NULL,
                sForma VARCHAR NOT NULL,
                dFecha DATE NOT NULL,
                CONSTRAINT nidevaluacion_evf PRIMARY KEY (nIdEvaluacion_evF, nIdSucursal_evF, nIdCliente_evF)
);
COMMENT ON TABLE evalFisica IS 'Evaluaciones realizadas por personas respecto a los servicios del banco.';


ALTER SEQUENCE evalfisica_nidevaluacion_evf_seq OWNED BY evalFisica.nIdEvaluacion_evF;

CREATE SEQUENCE evalmoral_nidevaluacion_evm_seq;

CREATE TABLE evalMoral (
                nIdEvaluacion_evM INTEGER NOT NULL DEFAULT nextval('evalmoral_nidevaluacion_evm_seq'),
                nIdSucursal_evM INTEGER NOT NULL,
                nIdCliente_evM INTEGER NOT NULL,
                sTiempo VARCHAR NOT NULL,
                sClaridad VARCHAR NOT NULL,
                sAtencion VARCHAR NOT NULL,
                sForma VARCHAR NOT NULL,
                dFecha DATE NOT NULL,
                CONSTRAINT nidevaluacion_evm PRIMARY KEY (nIdEvaluacion_evM, nIdSucursal_evM, nIdCliente_evM)
);
COMMENT ON TABLE evalMoral IS 'Evaluaciones realizadas por personas respecto a los servicios del banco.';


ALTER SEQUENCE evalmoral_nidevaluacion_evm_seq OWNED BY evalMoral.nIdEvaluacion_evM;

CREATE TABLE CMP (
                sCuenta_CMP VARCHAR NOT NULL,
                nIdSucursal_CMP INTEGER NOT NULL,
                nIdCliente_CMP INTEGER NOT NULL,
                dFecha DATE NOT NULL,
                nMonto INTEGER NOT NULL,
                sTipo VARCHAR NOT NULL,
                nPlazo INTEGER NOT NULL,
                nAbonado INTEGER DEFAULT 0 NOT NULL,
                sVia VARCHAR NOT NULL,
                CONSTRAINT scuentamp PRIMARY KEY (sCuenta_CMP, nIdSucursal_CMP, nIdCliente_CMP)
);
COMMENT ON TABLE CMP IS 'Tabla de cuentas de prestamo morales
Debido a la relacion uno a muchos, obtiene fecha la relacion';


CREATE TABLE pagPM (
                tFecha_pPM TIMESTAMP NOT NULL,
                sCuenta_pPM VARCHAR NOT NULL,
                nIdCliente_pPM INTEGER NOT NULL,
                OrnIdSucursal_pPM INTEGER NOT NULL,
                PagnIdSucursal_pPM INTEGER NOT NULL,
                nMonto INTEGER NOT NULL,
                CONSTRAINT tfecha_ppm PRIMARY KEY (tFecha_pPM, sCuenta_pPM, nIdCliente_pPM, OrnIdSucursal_pPM, PagnIdSucursal_pPM)
);
COMMENT ON TABLE pagPM IS 'Pagos/Abonos a cuentas de prestamo(Empresas)';


CREATE TABLE CFP (
                sCuentaFP VARCHAR NOT NULL,
                nIdCliente_CFP INTEGER NOT NULL,
                nIdSucursal_CFP INTEGER NOT NULL,
                nMonto INTEGER NOT NULL,
                sTipo VARCHAR NOT NULL,
                nPlazo INTEGER NOT NULL,
                nAbonado INTEGER DEFAULT 0 NOT NULL,
                sVia VARCHAR NOT NULL,
                dFecha DATE NOT NULL,
                CONSTRAINT scuentafp PRIMARY KEY (sCuentaFP, nIdCliente_CFP, nIdSucursal_CFP)
);
COMMENT ON TABLE CFP IS 'Cuantas de prestamo de personas fisicas.
Debido a la relacion uno a muchos, obtiene fecha la relacion';


CREATE TABLE pagPF (
                tFecha_pPF TIMESTAMP NOT NULL,
                sCuenta_pPF VARCHAR NOT NULL,
                nIdCliente_pPF INTEGER NOT NULL,
                OrnIdSucursal_pPF INTEGER NOT NULL,
                PagnIdSucursal_pPF INTEGER NOT NULL,
                nMonto INTEGER NOT NULL,
                CONSTRAINT tfecha_ppf PRIMARY KEY (tFecha_pPF, sCuenta_pPF, nIdCliente_pPF, OrnIdSucursal_pPF, PagnIdSucursal_pPF)
);
COMMENT ON TABLE pagPF IS 'Pagos/Abonos a cuentas de prestamo(Personas)';


CREATE SEQUENCE atm_nidatm_seq;

CREATE TABLE ATM (
                nIdATM INTEGER NOT NULL DEFAULT nextval('atm_nidatm_seq'),
                nIdSucursal_ATM INTEGER NOT NULL,
                sEstado VARCHAR NOT NULL,
                CONSTRAINT nidatm PRIMARY KEY (nIdATM, nIdSucursal_ATM)
);
COMMENT ON TABLE ATM IS 'ATM (Cajeros automaticos)';


ALTER SEQUENCE atm_nidatm_seq OWNED BY ATM.nIdATM;

CREATE SEQUENCE ventanilla_nidventanilla_seq;

CREATE TABLE Ventanilla (
                nIdVentanilla INTEGER NOT NULL DEFAULT nextval('ventanilla_nidventanilla_seq'),
                nIdSucursal_V INTEGER NOT NULL,
                sEstado VARCHAR NOT NULL,
                CONSTRAINT nidventanilla PRIMARY KEY (nIdVentanilla, nIdSucursal_V)
);
COMMENT ON TABLE Ventanilla IS 'Venanillas';


ALTER SEQUENCE ventanilla_nidventanilla_seq OWNED BY Ventanilla.nIdVentanilla;

CREATE TABLE retPrestamoFis (
                tFecha_rPF TIMESTAMP NOT NULL,
                sCuenta_rPF VARCHAR NOT NULL,
                nIdCliente_rPF INTEGER NOT NULL,
                OrnIdSucursal_rPF INTEGER NOT NULL,
                nIdVentanilla_rPF INTEGER NOT NULL,
                RetnIdSucursal_rPF INTEGER NOT NULL,
                nMonto INTEGER NOT NULL,
                CONSTRAINT tfecha_rpf PRIMARY KEY (tFecha_rPF, sCuenta_rPF, nIdCliente_rPF, OrnIdSucursal_rPF, nIdVentanilla_rPF, RetnIdSucursal_rPF)
);
COMMENT ON TABLE retPrestamoFis IS 'Retiros de cuenta de prestamo(Personas), estos se hacen directamente en sucursal.';


CREATE TABLE retPrestamoMor (
                tFecha_rPM TIMESTAMP NOT NULL,
                sCuenta_rPM VARCHAR NOT NULL,
                nIdCliente_rPM INTEGER NOT NULL,
                OrnIdSucursal_rPM INTEGER NOT NULL,
                nIdVentanilla_rPM INTEGER NOT NULL,
                RetnIdSucursal_rPM INTEGER NOT NULL,
                nMonto INTEGER NOT NULL,
                CONSTRAINT tfecha_rpm PRIMARY KEY (tFecha_rPM, sCuenta_rPM, nIdCliente_rPM, OrnIdSucursal_rPM, nIdVentanilla_rPM, RetnIdSucursal_rPM)
);
COMMENT ON TABLE retPrestamoMor IS 'Retiros de cuenta de prestamo(Empresa), estos se hacen directamente en sucursal.';


CREATE TABLE CMA (
                sCuenta_CMA VARCHAR NOT NULL,
                nIdCliente_CMA INTEGER NOT NULL,
                nIdSucursal_CMA INTEGER NOT NULL,
                dFecha DATE NOT NULL,
                nSaldo INTEGER NOT NULL,
                nApertura INTEGER DEFAULT 6000 NOT NULL,
                CONSTRAINT scuenta_cma PRIMARY KEY (sCuenta_CMA, nIdCliente_CMA, nIdSucursal_CMA)
);
COMMENT ON TABLE CMA IS 'Tabla de cuentas de ahorro de personas morales
Debido a la relacion uno a muchos, obtiene fecha la relacion';


CREATE TABLE cred_TCM (
                sTarjeta_TCM VARCHAR NOT NULL,
                sCuenta_TCM VARCHAR NOT NULL,
                nIdCliente_TCM INTEGER NOT NULL,
                nIdSucursal_TCM INTEGER NOT NULL,
                sTipo VARCHAR NOT NULL,
                CONSTRAINT starjeta_tcm PRIMARY KEY (sTarjeta_TCM, sCuenta_TCM, nIdCliente_TCM, nIdSucursal_TCM)
);
COMMENT ON TABLE cred_TCM IS 'Tarjetas de debito asociadas a cuantas de ahorro de Empresas.';
COMMENT ON COLUMN cred_TCM.sTipo IS 'Oro, Platino, etc';


CREATE TABLE tar_TDM (
                sTarjeta_TDM VARCHAR NOT NULL,
                sCuenta_TDM VARCHAR NOT NULL,
                nIdCliente_TDM INTEGER NOT NULL,
                nIdSucursal_TDM INTEGER NOT NULL,
                CONSTRAINT starjeta_tdm PRIMARY KEY (sTarjeta_TDM, sCuenta_TDM, nIdCliente_TDM, nIdSucursal_TDM)
);
COMMENT ON TABLE tar_TDM IS 'Tarjetas de debito, asociadas a cuentas de ahorro de personas moral.';


CREATE TABLE pagAM (
                tFecha_pAM TIMESTAMP NOT NULL,
                sCuenta_pAM VARCHAR NOT NULL,
                nIdCliente_pAM INTEGER NOT NULL,
                OrnIdSucursal_pAM INTEGER NOT NULL,
                PagnIdSucursal_pAM INTEGER NOT NULL,
                nMonto INTEGER NOT NULL,
                CONSTRAINT tfecha_pam PRIMARY KEY (tFecha_pAM, sCuenta_pAM, nIdCliente_pAM, OrnIdSucursal_pAM, PagnIdSucursal_pAM)
);
COMMENT ON TABLE pagAM IS 'Pagos/Abonos a cuentas de ahorro de empresas';


CREATE TABLE retAAM (
                tFecha_rAAM TIMESTAMP NOT NULL,
                sCuenta_rAAM VARCHAR NOT NULL,
                nIdCliente_rAAM INTEGER NOT NULL,
                OrnIdSucursal_rAAM INTEGER NOT NULL,
                nIdATM_rAAM INTEGER NOT NULL,
                RetnIdSucursal_rAAM INTEGER NOT NULL,
                nMonto INTEGER NOT NULL,
                CONSTRAINT tfecha_raam PRIMARY KEY (tFecha_rAAM, sCuenta_rAAM, nIdCliente_rAAM, OrnIdSucursal_rAAM, nIdATM_rAAM, RetnIdSucursal_rAAM)
);
COMMENT ON TABLE retAAM IS 'Retiros de cuentas de ahorro por ATM(Empresas)';


CREATE TABLE retAVM (
                tFecha_rAVM TIMESTAMP NOT NULL,
                sCuenta_rAVM VARCHAR NOT NULL,
                nIdCliente_rAVM INTEGER NOT NULL,
                OrnIdSucursal_rAVM INTEGER NOT NULL,
                nIdVentanilla_rAVM INTEGER NOT NULL,
                RetnIdSucursal_rAVM INTEGER NOT NULL,
                nMonto INTEGER NOT NULL,
                CONSTRAINT tfecha_ravm PRIMARY KEY (tFecha_rAVM, sCuenta_rAVM, nIdCliente_rAVM, OrnIdSucursal_rAVM, nIdVentanilla_rAVM, RetnIdSucursal_rAVM)
);
COMMENT ON TABLE retAVM IS 'Retiros realizados por ventanilla de cuentas de ahorro de Empresas';


CREATE TABLE CFA (
                sCuenta_CFA VARCHAR NOT NULL,
                nIdSucursal_CFA INTEGER NOT NULL,
                nIdCliente_CFA INTEGER NOT NULL,
                dFecha DATE NOT NULL,
                nSaldo INTEGER NOT NULL,
                nApertura INTEGER DEFAULT 3000 NOT NULL,
                CONSTRAINT scuenta_cfa PRIMARY KEY (sCuenta_CFA, nIdSucursal_CFA, nIdCliente_CFA)
);
COMMENT ON TABLE CFA IS 'Tabla de cuentas de ahorro de personas fisicas
Debido a la relacion uno a muchos, obtiene fecha la relacion';


CREATE TABLE cred_TCF (
                sTarjeta_TCF VARCHAR NOT NULL,
                sCuenta_TCF VARCHAR NOT NULL,
                nIdSucursal_TCF INTEGER NOT NULL,
                nIdCliente_TCF INTEGER NOT NULL,
                sTipo VARCHAR NOT NULL,
                CONSTRAINT starjeta_tcf PRIMARY KEY (sTarjeta_TCF, sCuenta_TCF, nIdSucursal_TCF, nIdCliente_TCF)
);
COMMENT ON TABLE cred_TCF IS 'Tarjetas de credito asociadas a cuantas de ahorro de personas.';
COMMENT ON COLUMN cred_TCF.sTipo IS 'Oro, Platino, etc';


CREATE TABLE tar_TDF (
                sTarjeta_TDF VARCHAR NOT NULL,
                sCuenta_TDF VARCHAR NOT NULL,
                nIdSucursal_TDF INTEGER NOT NULL,
                nIdCliente_TDF INTEGER NOT NULL,
                CONSTRAINT starjeta_tdf PRIMARY KEY (sTarjeta_TDF, sCuenta_TDF, nIdSucursal_TDF, nIdCliente_TDF)
);
COMMENT ON TABLE tar_TDF IS 'Tarjetas de debito asociadas a cuantas de ahorro de personas.';


CREATE TABLE retAVF (
                tFecha_rAVF TIMESTAMP NOT NULL,
                nIdVentanilla_rAVF INTEGER NOT NULL,
                RetnIdSucursal_rAVF INTEGER NOT NULL,
                sCuenta_rAVF VARCHAR NOT NULL,
                nIdSucursal_rAVF INTEGER NOT NULL,
                nIdCliente_rAVF INTEGER NOT NULL,
                dMonto INTEGER NOT NULL,
                CONSTRAINT tfecha_ravf PRIMARY KEY (tFecha_rAVF, nIdVentanilla_rAVF, RetnIdSucursal_rAVF, sCuenta_rAVF, nIdSucursal_rAVF, nIdCliente_rAVF)
);
COMMENT ON TABLE retAVF IS 'Retiros realizados por ventanilla de cuentas de ahorro de personas';


CREATE TABLE retAAF (
                tFecha_rAAF TIMESTAMP NOT NULL,
                nIdATM_rAAF INTEGER NOT NULL,
                RetnIdSucursal_rAAF INTEGER NOT NULL,
                sCuenta_rAAF VARCHAR NOT NULL,
                nIdSucursal_rAAF INTEGER NOT NULL,
                nIdCliente_rAAF INTEGER NOT NULL,
                nMonto INTEGER NOT NULL,
                CONSTRAINT tfecha_raaf PRIMARY KEY (tFecha_rAAF, nIdATM_rAAF, RetnIdSucursal_rAAF, sCuenta_rAAF, nIdSucursal_rAAF, nIdCliente_rAAF)
);
COMMENT ON TABLE retAAF IS 'Retiros de cuentas de ahorro por ATM(Personas)';


CREATE TABLE pagAF (
                tFecha_pAF TIMESTAMP NOT NULL,
                PagnIdSucursal_pAF INTEGER NOT NULL,
                sCuenta_pAF VARCHAR NOT NULL,
                OrgnIdSucursal_pAF INTEGER NOT NULL,
                nIdCliente_pAF INTEGER NOT NULL,
                nMonto INTEGER NOT NULL,
                CONSTRAINT tfecha_paf PRIMARY KEY (tFecha_pAF, PagnIdSucursal_pAF, sCuenta_pAF, OrgnIdSucursal_pAF, nIdCliente_pAF)
);
COMMENT ON TABLE pagAF IS 'Pagos/Abonos a cuentas de ahorro de personas';


CREATE TABLE Empleado (
                sRFC_E VARCHAR(13) NOT NULL,
                nIdSucursal_E INTEGER NOT NULL,
                nSueldo INTEGER NOT NULL,
                sNombre VARCHAR NOT NULL,
                sAPaterno VARCHAR NOT NULL,
                sAMaterno VARCHAR NOT NULL,
                sTipo VARCHAR NOT NULL,
                sDireccion VARCHAR NOT NULL,
                nExt INTEGER NOT NULL,
                nInt INTEGER NOT NULL,
                sColonia VARCHAR NOT NULL,
                sDelegacion VARCHAR NOT NULL,
                sCP VARCHAR NOT NULL,
                sEstado VARCHAR NOT NULL,
                nRegion INTEGER NOT NULL,
                sZona VARCHAR NOT NULL,
                CONSTRAINT srfc_e PRIMARY KEY (sRFC_E, nIdSucursal_E)
);
COMMENT ON TABLE Empleado IS 'Datos personales de los empleados. Como con quien anda, que le gusta, ese tipo de cosas...';


CREATE TABLE EV_Asignado (
                dFecha_A DATE NOT NULL,
                sRFC_A VARCHAR NOT NULL,
                nIdSucursal__A INTEGER NOT NULL,
                nIdVentanilla_A INTEGER NOT NULL,
                CONSTRAINT dfecha_a PRIMARY KEY (dFecha_A, sRFC_A, nIdSucursal__A, nIdVentanilla_A)
);
COMMENT ON TABLE EV_Asignado IS 'Asignacion de empleados a ventanillas';


CREATE TABLE emailEmpleado (
                sEmail_eE VARCHAR NOT NULL,
                sRFC_eE VARCHAR NOT NULL,
                nIdSucursal_eE INTEGER NOT NULL,
                CONSTRAINT semail_ee PRIMARY KEY (sEmail_eE, sRFC_eE, nIdSucursal_eE)
);
COMMENT ON TABLE emailEmpleado IS 'Correos electronicos de empleado.';


CREATE TABLE telEmpleado (
                sTelefono_tE VARCHAR NOT NULL,
                sRFC_tE VARCHAR NOT NULL,
                nIdSucursal_tE INTEGER NOT NULL,
                CONSTRAINT stelefono_te PRIMARY KEY (sTelefono_tE, sRFC_tE, nIdSucursal_tE)
);
COMMENT ON TABLE telEmpleado IS 'Telefonos de empleado';


ALTER TABLE CMA ADD CONSTRAINT moral_cma_fk
FOREIGN KEY (nIdCliente_CMA)
REFERENCES Moral (nIdCliente_M)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE emailMoral ADD CONSTRAINT moral_emoral_fk
FOREIGN KEY (nIdCliente_eM)
REFERENCES Moral (nIdCliente_M)
ON DELETE CASCADE
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE telMoral ADD CONSTRAINT moral_tmoral_fk
FOREIGN KEY (nIdCliente_tM)
REFERENCES Moral (nIdCliente_M)
ON DELETE CASCADE
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CMP ADD CONSTRAINT moral_cmp_fk
FOREIGN KEY (nIdCliente_CMP)
REFERENCES Moral (nIdCliente_M)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retPrestamoMor ADD CONSTRAINT moral_retprestamomor_fk
FOREIGN KEY (nIdCliente_rPM)
REFERENCES Moral (nIdCliente_M)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retAVM ADD CONSTRAINT moral_retavm_fk
FOREIGN KEY (nIdCliente_rAVM)
REFERENCES Moral (nIdCliente_M)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retAAM ADD CONSTRAINT moral_retaam_fk
FOREIGN KEY (nIdCliente_rAAM)
REFERENCES Moral (nIdCliente_M)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pagAM ADD CONSTRAINT moral_pagam_fk
FOREIGN KEY (nIdCliente_pAM)
REFERENCES Moral (nIdCliente_M)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pagPM ADD CONSTRAINT moral_pagpm_fk
FOREIGN KEY (nIdCliente_pPM)
REFERENCES Moral (nIdCliente_M)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE evalMoral ADD CONSTRAINT moral_evalmoral_fk
FOREIGN KEY (nIdCliente_evM)
REFERENCES Moral (nIdCliente_M)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE qMoral ADD CONSTRAINT moral_qmoral_fk
FOREIGN KEY (nIdCliente_qM)
REFERENCES Moral (nIdCliente_M)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE emailFisica ADD CONSTRAINT fisica_efisica_fk
FOREIGN KEY (nIdCliente_eF)
REFERENCES Fisica (nIdCliente_F)
ON DELETE CASCADE
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE telFisica ADD CONSTRAINT fisica_tfisica_fk
FOREIGN KEY (nIdCliente_tF)
REFERENCES Fisica (nIdCliente_F)
ON DELETE CASCADE
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CFP ADD CONSTRAINT fisica_cfp_fk
FOREIGN KEY (nIdCliente_CFP)
REFERENCES Fisica (nIdCliente_F)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retPrestamoFis ADD CONSTRAINT fisica_retprestamofis_fk
FOREIGN KEY (nIdCliente_rPF)
REFERENCES Fisica (nIdCliente_F)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pagPF ADD CONSTRAINT fisica_pagaf_fk1
FOREIGN KEY (nIdCliente_pPF)
REFERENCES Fisica (nIdCliente_F)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE evalFisica ADD CONSTRAINT fisica_evalfisica_fk
FOREIGN KEY (nIdCliente_evF)
REFERENCES Fisica (nIdCliente_F)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE qFisica ADD CONSTRAINT fisica_qfisica_fk
FOREIGN KEY (nIdCliente_qF)
REFERENCES Fisica (nIdCliente_F)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CFA ADD CONSTRAINT fisica_cfa_fk
FOREIGN KEY (nIdCliente_CFA)
REFERENCES Fisica (nIdCliente_F)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pagAF ADD CONSTRAINT fisica_pagaf_fk
FOREIGN KEY (nIdCliente_pAF)
REFERENCES Fisica (nIdCliente_F)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retAAF ADD CONSTRAINT fisica_retaaf_fk
FOREIGN KEY (nIdCliente_rAAF)
REFERENCES Fisica (nIdCliente_F)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retAVF ADD CONSTRAINT fisica_retavf_fk
FOREIGN KEY (nIdCliente_rAVF)
REFERENCES Fisica (nIdCliente_F)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CFA ADD CONSTRAINT sucursal_cfa_fk
FOREIGN KEY (nIdSucursal_CFA)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CMA ADD CONSTRAINT sucursal_cma_fk
FOREIGN KEY (nIdSucursal_CMA)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Ventanilla ADD CONSTRAINT sucursal_ventanilla_fk
FOREIGN KEY (nIdSucursal_V)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ATM ADD CONSTRAINT sucursal_atm_fk
FOREIGN KEY (nIdSucursal_ATM)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CFP ADD CONSTRAINT sucursal_cfp_fk
FOREIGN KEY (nIdSucursal_CFP)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CMP ADD CONSTRAINT sucursal_cmp_fk
FOREIGN KEY (nIdSucursal_CMP)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pagAM ADD CONSTRAINT sucursal_pagam_fk
FOREIGN KEY (PagnIdSucursal_pAM)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pagPM ADD CONSTRAINT sucursal_pagpm_fk
FOREIGN KEY (PagnIdSucursal_pPM)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pagAF ADD CONSTRAINT sucursal_pagaf_fk
FOREIGN KEY (PagnIdSucursal_pAF)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pagPF ADD CONSTRAINT sucursal_pagaf_fk1
FOREIGN KEY (PagnIdSucursal_pPF)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE evalMoral ADD CONSTRAINT sucursal_evalmoral_fk
FOREIGN KEY (nIdSucursal_evM)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE evalFisica ADD CONSTRAINT sucursal_evalfisica_fk
FOREIGN KEY (nIdSucursal_evF)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE qFisica ADD CONSTRAINT sucursal_qfisica_fk
FOREIGN KEY (nIdSucursal_qF)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE qMoral ADD CONSTRAINT sucursal_qmoral_fk
FOREIGN KEY (nIdSucursal_qM)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Empleado ADD CONSTRAINT sucursal_empleado_fk
FOREIGN KEY (nIdSucursal_E)
REFERENCES Sucursal (nIdSucursal)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retPrestamoMor ADD CONSTRAINT cmp_retprestamomor_fk
FOREIGN KEY (sCuenta_rPM, OrnIdSucursal_rPM, nIdCliente_rPM)
REFERENCES CMP (sCuenta_CMP, nIdSucursal_CMP, nIdCliente_CMP)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pagPM ADD CONSTRAINT cmp_pagpm_fk
FOREIGN KEY (sCuenta_pPM, OrnIdSucursal_pPM, nIdCliente_pPM)
REFERENCES CMP (sCuenta_CMP, nIdSucursal_CMP, nIdCliente_CMP)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retPrestamoFis ADD CONSTRAINT cfp_retprestamofis_fk
FOREIGN KEY (sCuenta_rPF, nIdCliente_rPF, OrnIdSucursal_rPF)
REFERENCES CFP (sCuentaFP, nIdCliente_CFP, nIdSucursal_CFP)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pagPF ADD CONSTRAINT cfp_pagaf_fk
FOREIGN KEY (sCuenta_pPF, nIdCliente_pPF, OrnIdSucursal_pPF)
REFERENCES CFP (sCuentaFP, nIdCliente_CFP, nIdSucursal_CFP)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retAAF ADD CONSTRAINT atm_retaaf_fk
FOREIGN KEY (nIdATM_rAAF, RetnIdSucursal_rAAF)
REFERENCES ATM (nIdATM, nIdSucursal_ATM)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retAAM ADD CONSTRAINT atm_retaam_fk
FOREIGN KEY (nIdATM_rAAM, RetnIdSucursal_rAAM)
REFERENCES ATM (nIdATM, nIdSucursal_ATM)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retPrestamoMor ADD CONSTRAINT ventanilla_retprestamomor_fk
FOREIGN KEY (nIdVentanilla_rPM, RetnIdSucursal_rPM)
REFERENCES Ventanilla (nIdVentanilla, nIdSucursal_V)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retPrestamoFis ADD CONSTRAINT ventanilla_retprestamofis_fk
FOREIGN KEY (nIdVentanilla_rPF, RetnIdSucursal_rPF)
REFERENCES Ventanilla (nIdVentanilla, nIdSucursal_V)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retAVF ADD CONSTRAINT ventanilla_retavf_fk
FOREIGN KEY (nIdVentanilla_rAVF, RetnIdSucursal_rAVF)
REFERENCES Ventanilla (nIdVentanilla, nIdSucursal_V)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retAVM ADD CONSTRAINT ventanilla_retavm_fk
FOREIGN KEY (nIdVentanilla_rAVM, RetnIdSucursal_rAVM)
REFERENCES Ventanilla (nIdVentanilla, nIdSucursal_V)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EV_Asignado ADD CONSTRAINT ventanilla_ev_asignado_fk
FOREIGN KEY (nIdVentanilla_A, nIdSucursal__A)
REFERENCES Ventanilla (nIdVentanilla, nIdSucursal_V)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retAVM ADD CONSTRAINT cma_retavm_fk
FOREIGN KEY (sCuenta_rAVM, nIdCliente_rAVM, OrnIdSucursal_rAVM)
REFERENCES CMA (sCuenta_CMA, nIdCliente_CMA, nIdSucursal_CMA)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retAAM ADD CONSTRAINT cma_retaam_fk
FOREIGN KEY (sCuenta_rAAM, nIdCliente_rAAM, OrnIdSucursal_rAAM)
REFERENCES CMA (sCuenta_CMA, nIdCliente_CMA, nIdSucursal_CMA)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pagAM ADD CONSTRAINT cma_pagam_fk
FOREIGN KEY (sCuenta_pAM, nIdCliente_pAM, OrnIdSucursal_pAM)
REFERENCES CMA (sCuenta_CMA, nIdCliente_CMA, nIdSucursal_CMA)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE tar_TDM ADD CONSTRAINT cma_tar_tdm_fk
FOREIGN KEY (sCuenta_TDM, nIdCliente_TDM, nIdSucursal_TDM)
REFERENCES CMA (sCuenta_CMA, nIdCliente_CMA, nIdSucursal_CMA)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cred_TCM ADD CONSTRAINT cma_cred_tcm_fk
FOREIGN KEY (sCuenta_TCM, nIdCliente_TCM, nIdSucursal_TCM)
REFERENCES CMA (sCuenta_CMA, nIdCliente_CMA, nIdSucursal_CMA)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pagAF ADD CONSTRAINT cfa_pagaf_fk
FOREIGN KEY (sCuenta_pAF, OrgnIdSucursal_pAF, nIdCliente_pAF)
REFERENCES CFA (sCuenta_CFA, nIdSucursal_CFA, nIdCliente_CFA)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retAAF ADD CONSTRAINT cfa_retaaf_fk
FOREIGN KEY (sCuenta_rAAF, nIdSucursal_rAAF, nIdCliente_rAAF)
REFERENCES CFA (sCuenta_CFA, nIdSucursal_CFA, nIdCliente_CFA)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE retAVF ADD CONSTRAINT cfa_retavf_fk
FOREIGN KEY (sCuenta_rAVF, nIdSucursal_rAVF, nIdCliente_rAVF)
REFERENCES CFA (sCuenta_CFA, nIdSucursal_CFA, nIdCliente_CFA)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE tar_TDF ADD CONSTRAINT cfa_tar_tdf_fk
FOREIGN KEY (sCuenta_TDF, nIdSucursal_TDF, nIdCliente_TDF)
REFERENCES CFA (sCuenta_CFA, nIdSucursal_CFA, nIdCliente_CFA)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cred_TCF ADD CONSTRAINT cfa_cred_tcf_fk
FOREIGN KEY (sCuenta_TCF, nIdSucursal_TCF, nIdCliente_TCF)
REFERENCES CFA (sCuenta_CFA, nIdSucursal_CFA, nIdCliente_CFA)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE telEmpleado ADD CONSTRAINT empleado_telempleado_fk
FOREIGN KEY (sRFC_tE, nIdSucursal_tE)
REFERENCES Empleado (sRFC_E, nIdSucursal_E)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE emailEmpleado ADD CONSTRAINT empleado_emailempleado_fk
FOREIGN KEY (sRFC_eE, nIdSucursal_eE)
REFERENCES Empleado (sRFC_E, nIdSucursal_E)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EV_Asignado ADD CONSTRAINT empleado_ev_asignado_fk
FOREIGN KEY (sRFC_A, nIdSucursal__A)
REFERENCES Empleado (sRFC_E, nIdSucursal_E)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--Constraints no generadas por power architect
ALTER TABLE Fisica ADD CONSTRAINT  unq_fisica_rfc UNIQUE(srfc);
ALTER TABLE Fisica ADD CONSTRAINT  unq_fisica_curp UNIQUE(scurp);

ALTER TABLE Moral ADD CONSTRAINT  unq_moral_rfc UNIQUE(srfc);

ALTER TABLE Empleado ADD CONSTRAINT  unq_empleado_rfc UNIQUE(srfc_e);

ALTER TABLE cred_tcf ADD CONSTRAINT  unq_starjeta_ctcf UNIQUE(starjeta_tcf);
ALTER TABLE cred_tcm ADD CONSTRAINT  unq_starjeta_ctcm UNIQUE(starjeta_tcm);
ALTER TABLE cred_tcf ADD CONSTRAINT  unq_starjeta_ttcf UNIQUE(starjeta_tcf);
ALTER TABLE cred_tcm ADD CONSTRAINT  unq_starjeta_ttcm UNIQUE(starjeta_tcm);




