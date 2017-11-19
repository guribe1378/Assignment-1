--------------------------------------------------------
-- Archivo creado  - sábado-noviembre-18-2017   
--------------------------------------------------------
DROP VIEW "GURIBE1378"."FACT_TOTALES";
DROP VIEW "GURIBE1378"."INFORMATION_BILL";
DROP TABLE "GURIBE1378"."BILLS";
DROP TABLE "GURIBE1378"."CITIES";
DROP TABLE "GURIBE1378"."COST_CENTER";
DROP TABLE "GURIBE1378"."INVENTORIES";
DROP TABLE "GURIBE1378"."PATIENTS";
DROP TABLE "GURIBE1378"."SERVICES";
DROP TABLE "GURIBE1378"."SERVICES_DETAILS";
DROP SEQUENCE "GURIBE1378"."ANSWER_SEQ";
DROP SEQUENCE "GURIBE1378"."SEQ_BILL";
DROP SEQUENCE "GURIBE1378"."SEQ_CITY";
DROP SEQUENCE "GURIBE1378"."SEQ_COST_CENTER";
DROP SEQUENCE "GURIBE1378"."SEQ_INV";
DROP SEQUENCE "GURIBE1378"."SEQ_PATIEN";
DROP SEQUENCE "GURIBE1378"."SEQ_PATIENSERVICE";
DROP SEQUENCE "GURIBE1378"."SEQ_SERVICEDET";
DROP PROCEDURE "GURIBE1378"."INCREASE";
DROP PROCEDURE "GURIBE1378"."INCREASES";
DROP PROCEDURE "GURIBE1378"."NOMBRE";
DROP FUNCTION "GURIBE1378"."FN_COST_CENTER_BILL";
DROP FUNCTION "GURIBE1378"."FN_COST_CENTER_COUNT";
--------------------------------------------------------
--  DDL for View FACT_TOTALES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GURIBE1378"."FACT_TOTALES" ("FACTURA", "NOMBRE", "DIRECCION", "FECHA_FACTURA", "FECHA_INGRESO", "FECHA_DESCARGA", "HOSPITALIZACION", "VR_HOSP", "LABORATORIO", "VR_LAB", "RADIOLOGIA", "VR_RAD") AS 
  (SELECT BILLS.ID AS FACTURA, PATIENTS.FIRST_NAME AS NOMBRE,
PATIENTS.ADRESS AS DIRECCION,BILLS.DATE_BILL AS FECHA_FACTURA,
BILLS.DATE_ADDMITED AS FECHA_INGRESO,BILLS.DATE_DISCHARGE AS FECHA_DESCARGA,
(FN_COST_CENTER_COUNT('20000','60001'))AS HOSPITALIZACION, (FN_COST_CENTER_BILL('20000','60001'))AS VR_HOSP,
(FN_COST_CENTER_COUNT('20011','60001'))AS LABORATORIO, (FN_COST_CENTER_BILL('20011','60001'))AS VR_LAB,
(FN_COST_CENTER_COUNT('20003','60001'))AS RADIOLOGIA, (FN_COST_CENTER_BILL('20003','60001'))AS VR_RAD
FROM BILLS JOIN PATIENTS ON BILLS.PATIENT_ID= PATIENTS.ID 
WHERE BILLS.ID=60001)
;
--------------------------------------------------------
--  DDL for View INFORMATION_BILL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GURIBE1378"."INFORMATION_BILL" ("PACIENTE", "NOMBRE", "APELLIDO", "DIRECCION", "FECHA", "TOTAL", "HOSPITALIZACION") AS 
  (SELECT  DISTINCT PATIENTS.ID AS PACIENTE,PATIENTS.FIRST_NAME AS NOMBRE,
PATIENTS.LAST_NAME AS APELLIDO,PATIENTS.ADRESS AS DIRECCION,
BILLS.DATE_BILL AS FECHA,BILLS.BAL_DUE AS TOTAL,
SUM(SERVICES.CHARGE_SERVICE)AS HOSPITALIZACION
FROM SERVICES JOIN SERVICES_DETAILS ON SERVICES.ID = SERVICES_DETAILS.SERVICE_ID
JOIN COST_CENTER ON COST_CENTER.ID = SERVICES.COST_CENTER_ID JOIN BILLS
ON SERVICES_DETAILS.BILL_ID = BILLS.ID JOIN PATIENTS ON BILLS.PATIENT_ID = PATIENTS.ID                                              
WHERE  COST_CENTER.ID='20000'
GROUP BY PATIENTS.ID,PATIENTS.FIRST_NAME,PATIENTS.LAST_NAME,PATIENTS.ADRESS,BILLS.DATE_BILL,BILLS.BAL_DUE )
;
--------------------------------------------------------
--  DDL for Table BILLS
--------------------------------------------------------

  CREATE TABLE "GURIBE1378"."BILLS" 
   (	"ID" NUMBER, 
	"DATE_BILL" DATE, 
	"DATE_ADDMITED" DATE, 
	"DATE_DISCHARGE" DATE, 
	"BAL_DUE" VARCHAR2(10 BYTE), 
	"PATIENT_ID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table CITIES
--------------------------------------------------------

  CREATE TABLE "GURIBE1378"."CITIES" 
   (	"ID" NUMBER, 
	"CITY" VARCHAR2(255 BYTE), 
	"STATE" VARCHAR2(255 BYTE), 
	"ZIP" VARCHAR2(255 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table COST_CENTER
--------------------------------------------------------

  CREATE TABLE "GURIBE1378"."COST_CENTER" 
   (	"ID" NUMBER, 
	"CENTER" VARCHAR2(255 BYTE), 
	"CENTER_NAME" VARCHAR2(255 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table INVENTORIES
--------------------------------------------------------

  CREATE TABLE "GURIBE1378"."INVENTORIES" 
   (	"ID" NUMBER, 
	"QUANTITY" NUMBER, 
	"SERVICE_ID" NUMBER, 
	"COST_CENTER_ID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table PATIENTS
--------------------------------------------------------

  CREATE TABLE "GURIBE1378"."PATIENTS" 
   (	"ID" NUMBER, 
	"FIRST_NAME" VARCHAR2(255 BYTE), 
	"LAST_NAME" VARCHAR2(255 BYTE), 
	"ADRESS" VARCHAR2(255 BYTE), 
	"CITY_ID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table SERVICES
--------------------------------------------------------

  CREATE TABLE "GURIBE1378"."SERVICES" 
   (	"ID" NUMBER, 
	"NAME_SERVICE" VARCHAR2(255 BYTE), 
	"CHARGE_SERVICE" NUMBER(8,2), 
	"COST_CENTER_ID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table SERVICES_DETAILS
--------------------------------------------------------

  CREATE TABLE "GURIBE1378"."SERVICES_DETAILS" 
   (	"ID" NUMBER, 
	"DATE_CHARGED" DATE, 
	"SERVICE_ID" NUMBER, 
	"BILL_ID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Sequence ANSWER_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "GURIBE1378"."ANSWER_SEQ"  MINVALUE 500 MAXVALUE 9999999999999999999999999999 INCREMENT BY 10 START WITH 500 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_BILL
--------------------------------------------------------

   CREATE SEQUENCE  "GURIBE1378"."SEQ_BILL"  MINVALUE 60000 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 60020 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_CITY
--------------------------------------------------------

   CREATE SEQUENCE  "GURIBE1378"."SEQ_CITY"  MINVALUE 10000 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 10020 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_COST_CENTER
--------------------------------------------------------

   CREATE SEQUENCE  "GURIBE1378"."SEQ_COST_CENTER"  MINVALUE 20000 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 20020 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_INV
--------------------------------------------------------

   CREATE SEQUENCE  "GURIBE1378"."SEQ_INV"  MINVALUE 70000 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 70020 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_PATIEN
--------------------------------------------------------

   CREATE SEQUENCE  "GURIBE1378"."SEQ_PATIEN"  MINVALUE 40000 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 40020 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_PATIENSERVICE
--------------------------------------------------------

   CREATE SEQUENCE  "GURIBE1378"."SEQ_PATIENSERVICE"  MINVALUE 30000 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 30020 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_SERVICEDET
--------------------------------------------------------

   CREATE SEQUENCE  "GURIBE1378"."SEQ_SERVICEDET"  MINVALUE 50000 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 50020 CACHE 20 NOORDER  NOCYCLE ;
REM INSERTING into GURIBE1378.BILLS
SET DEFINE OFF;
Insert into GURIBE1378.BILLS (ID,DATE_BILL,DATE_ADDMITED,DATE_DISCHARGE,BAL_DUE,PATIENT_ID) values ('60000',to_date('16/01/17','DD/MM/RR'),to_date('16/01/17','DD/MM/RR'),to_date('16/01/17','DD/MM/RR'),'46,08','40000');
Insert into GURIBE1378.BILLS (ID,DATE_BILL,DATE_ADDMITED,DATE_DISCHARGE,BAL_DUE,PATIENT_ID) values ('60001',to_date('12/03/17','DD/MM/RR'),to_date('12/03/17','DD/MM/RR'),to_date('12/03/17','DD/MM/RR'),'13,63','40001');
Insert into GURIBE1378.BILLS (ID,DATE_BILL,DATE_ADDMITED,DATE_DISCHARGE,BAL_DUE,PATIENT_ID) values ('60002',to_date('12/03/17','DD/MM/RR'),to_date('12/03/17','DD/MM/RR'),to_date('12/03/17','DD/MM/RR'),'337,08','40000');
Insert into GURIBE1378.BILLS (ID,DATE_BILL,DATE_ADDMITED,DATE_DISCHARGE,BAL_DUE,PATIENT_ID) values ('60003',to_date('12/03/17','DD/MM/RR'),to_date('12/03/17','DD/MM/RR'),to_date('12/03/17','DD/MM/RR'),'112,36','40002');
Insert into GURIBE1378.BILLS (ID,DATE_BILL,DATE_ADDMITED,DATE_DISCHARGE,BAL_DUE,PATIENT_ID) values ('60004',to_date('12/03/17','DD/MM/RR'),to_date('12/03/17','DD/MM/RR'),to_date('12/03/17','DD/MM/RR'),'88,581','40003');
Insert into GURIBE1378.BILLS (ID,DATE_BILL,DATE_ADDMITED,DATE_DISCHARGE,BAL_DUE,PATIENT_ID) values ('60005',to_date('12/03/17','DD/MM/RR'),to_date('12/03/17','DD/MM/RR'),to_date('12/03/17','DD/MM/RR'),'88,581','40000');
Insert into GURIBE1378.BILLS (ID,DATE_BILL,DATE_ADDMITED,DATE_DISCHARGE,BAL_DUE,PATIENT_ID) values ('60006',to_date('16/01/17','DD/MM/RR'),to_date('16/01/17','DD/MM/RR'),to_date('16/01/17','DD/MM/RR'),'7,186','40003');
Insert into GURIBE1378.BILLS (ID,DATE_BILL,DATE_ADDMITED,DATE_DISCHARGE,BAL_DUE,PATIENT_ID) values ('60007',to_date('16/01/17','DD/MM/RR'),to_date('16/01/17','DD/MM/RR'),to_date('16/01/17','DD/MM/RR'),'8','40003');
REM INSERTING into GURIBE1378.CITIES
SET DEFINE OFF;
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10000','Augusta','Georgia','B3I 1O8');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10001','Tranås','Jönköpings län','T2O 2C7');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10002','San Vicente','SJ','T4T 0P8');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10003','Iskenderun','Hatay','Z5Z 2Q9');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10004','Istanbul','Ist','C9J 7D3');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10005','Wommelgem','AN','U2T 8K7');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10006','Toowoomba','QLD','Q3B 2C9');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10007','Nice','PR','K6Z 2Q9');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10008','Pittsburgh','Pennsylvania','R3B 0I0');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10009','Pitlochry','Perthshire','T6H 3V2');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10010','Avellino','CAM','U0W 0Q0');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10011','Wilmington','Delaware','O3M 9T2');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10012','Torrejón de Ardoz','Madrid','L9W 6L4');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10013','Elblag','Warminsko-mazurskie','C3V 5R6');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10014','Canning','WA','X4K 5J6');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10015','Santa Coloma de Gramenet','Catalunya','U0T 8Q5');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10016','Pincher Creek','AB','T2T 0J1');
Insert into GURIBE1378.CITIES (ID,CITY,STATE,ZIP) values ('10017','Hearst','ON','C3H 6A8');
REM INSERTING into GURIBE1378.COST_CENTER
SET DEFINE OFF;
Insert into GURIBE1378.COST_CENTER (ID,CENTER,CENTER_NAME) values ('20000','100','hospitalizacion');
Insert into GURIBE1378.COST_CENTER (ID,CENTER,CENTER_NAME) values ('20001','105','monitoreo');
Insert into GURIBE1378.COST_CENTER (ID,CENTER,CENTER_NAME) values ('20002','110','direccion');
Insert into GURIBE1378.COST_CENTER (ID,CENTER,CENTER_NAME) values ('20003','115','radiologia');
Insert into GURIBE1378.COST_CENTER (ID,CENTER,CENTER_NAME) values ('20004','120','uci');
Insert into GURIBE1378.COST_CENTER (ID,CENTER,CENTER_NAME) values ('20005','125','uce');
Insert into GURIBE1378.COST_CENTER (ID,CENTER,CENTER_NAME) values ('20006','130','ambulatoria');
Insert into GURIBE1378.COST_CENTER (ID,CENTER,CENTER_NAME) values ('20007','135','monitoreo');
Insert into GURIBE1378.COST_CENTER (ID,CENTER,CENTER_NAME) values ('20008','140','rayos x');
Insert into GURIBE1378.COST_CENTER (ID,CENTER,CENTER_NAME) values ('20009','145','muestras');
Insert into GURIBE1378.COST_CENTER (ID,CENTER,CENTER_NAME) values ('20010','150','enfermeria');
Insert into GURIBE1378.COST_CENTER (ID,CENTER,CENTER_NAME) values ('20011','155','laboratorio');
REM INSERTING into GURIBE1378.INVENTORIES
SET DEFINE OFF;
Insert into GURIBE1378.INVENTORIES (ID,QUANTITY,SERVICE_ID,COST_CENTER_ID) values ('70000','10','30000','20000');
Insert into GURIBE1378.INVENTORIES (ID,QUANTITY,SERVICE_ID,COST_CENTER_ID) values ('70001','10','30001','20010');
Insert into GURIBE1378.INVENTORIES (ID,QUANTITY,SERVICE_ID,COST_CENTER_ID) values ('70002','44','30002','20000');
Insert into GURIBE1378.INVENTORIES (ID,QUANTITY,SERVICE_ID,COST_CENTER_ID) values ('70003','25','30003','20000');
Insert into GURIBE1378.INVENTORIES (ID,QUANTITY,SERVICE_ID,COST_CENTER_ID) values ('70004','42','30004','20010');
Insert into GURIBE1378.INVENTORIES (ID,QUANTITY,SERVICE_ID,COST_CENTER_ID) values ('70005','21','30005','20010');
Insert into GURIBE1378.INVENTORIES (ID,QUANTITY,SERVICE_ID,COST_CENTER_ID) values ('70006','24','30006','20004');
Insert into GURIBE1378.INVENTORIES (ID,QUANTITY,SERVICE_ID,COST_CENTER_ID) values ('70007','15','30007','20004');
Insert into GURIBE1378.INVENTORIES (ID,QUANTITY,SERVICE_ID,COST_CENTER_ID) values ('70008','15','30008','20004');
Insert into GURIBE1378.INVENTORIES (ID,QUANTITY,SERVICE_ID,COST_CENTER_ID) values ('70009','17','30009','20010');
Insert into GURIBE1378.INVENTORIES (ID,QUANTITY,SERVICE_ID,COST_CENTER_ID) values ('70010','18','30010','20008');
Insert into GURIBE1378.INVENTORIES (ID,QUANTITY,SERVICE_ID,COST_CENTER_ID) values ('70011','19','30011','20008');
REM INSERTING into GURIBE1378.PATIENTS
SET DEFINE OFF;
Insert into GURIBE1378.PATIENTS (ID,FIRST_NAME,LAST_NAME,ADRESS,CITY_ID) values ('40000','Kenneth','Candice','850-9921 Auctor Carretera','10000');
Insert into GURIBE1378.PATIENTS (ID,FIRST_NAME,LAST_NAME,ADRESS,CITY_ID) values ('40001','Kuame','Shellie','4235 Cras Avenida','10005');
Insert into GURIBE1378.PATIENTS (ID,FIRST_NAME,LAST_NAME,ADRESS,CITY_ID) values ('40002','Tamara','Todd','Apartado núm.: 977, 3211 Egestas. C.','10006');
Insert into GURIBE1378.PATIENTS (ID,FIRST_NAME,LAST_NAME,ADRESS,CITY_ID) values ('40003','Harlan','Elliott','Apdo.:198-6725 Tincidunt. Avenida','10008');
Insert into GURIBE1378.PATIENTS (ID,FIRST_NAME,LAST_NAME,ADRESS,CITY_ID) values ('40004','Rafael','Lewis','397-6490 Purus. ','10007');
Insert into GURIBE1378.PATIENTS (ID,FIRST_NAME,LAST_NAME,ADRESS,CITY_ID) values ('40005','Eleanor','MacKenzie','Apdo.:977-2525 Non, Carretera','10009');
Insert into GURIBE1378.PATIENTS (ID,FIRST_NAME,LAST_NAME,ADRESS,CITY_ID) values ('40006','Seth','Hunter','Apartado núm.: 926, 5828 Ac, Av.','10004');
Insert into GURIBE1378.PATIENTS (ID,FIRST_NAME,LAST_NAME,ADRESS,CITY_ID) values ('40007','Kermit','Malcolm','Apartado núm.: 904, 130 Blandit Ctra.','10003');
Insert into GURIBE1378.PATIENTS (ID,FIRST_NAME,LAST_NAME,ADRESS,CITY_ID) values ('40008','Brett','Hop','707-205 Nec, ','10011');
Insert into GURIBE1378.PATIENTS (ID,FIRST_NAME,LAST_NAME,ADRESS,CITY_ID) values ('40009','Judith','Justine','638-1393 Tincidunt, Avenida','10012');
REM INSERTING into GURIBE1378.SERVICES
SET DEFINE OFF;
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30000','tramal','2','20000');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30001','agujas','2','20010');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30002','agua','4','20000');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30003','camilla','8','20000');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30004','acetaminofen','2','20010');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30005','alcohol','1','20010');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30006','oxigeno','4','20004');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30007','espatula','9','20004');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30008','suero','1','20004');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30009','alcohol','2','20010');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30010','tapabocas','4','20008');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30011','microscopio','7','20008');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30012','ferula','7','20003');
Insert into GURIBE1378.SERVICES (ID,NAME_SERVICE,CHARGE_SERVICE,COST_CENTER_ID) values ('30014','amalgama','7','20011');
REM INSERTING into GURIBE1378.SERVICES_DETAILS
SET DEFINE OFF;
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50000',to_date('16/01/17','DD/MM/RR'),'30000','60000');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50001',to_date('16/01/17','DD/MM/RR'),'30001','60000');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50002',to_date('16/01/17','DD/MM/RR'),'30001','60000');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50003',to_date('12/03/17','DD/MM/RR'),'30001','60001');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50004',to_date('16/01/17','DD/MM/RR'),'30002','60001');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50005',to_date('16/01/17','DD/MM/RR'),'30002','60001');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50006',to_date('20/09/17','DD/MM/RR'),'30003','60002');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50007',to_date('20/09/17','DD/MM/RR'),'30003','60002');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50008',to_date('20/09/17','DD/MM/RR'),'30003','60002');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50009',to_date('20/09/17','DD/MM/RR'),'30003','60004');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50010',to_date('20/09/17','DD/MM/RR'),'30003','60005');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50011',to_date('20/09/17','DD/MM/RR'),'30004','60006');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50012',to_date('20/09/17','DD/MM/RR'),'30002','60006');
Insert into GURIBE1378.SERVICES_DETAILS (ID,DATE_CHARGED,SERVICE_ID,BILL_ID) values ('50013',to_date('20/09/17','DD/MM/RR'),'30002','60007');
REM INSERTING into GURIBE1378.FACT_TOTALES
SET DEFINE OFF;
Insert into GURIBE1378.FACT_TOTALES (FACTURA,NOMBRE,DIRECCION,FECHA_FACTURA,FECHA_INGRESO,FECHA_DESCARGA,HOSPITALIZACION,VR_HOSP,LABORATORIO,VR_LAB,RADIOLOGIA,VR_RAD) values ('60001','Kuame','4235 Cras Avenida',to_date('12/03/17','DD/MM/RR'),to_date('12/03/17','DD/MM/RR'),to_date('12/03/17','DD/MM/RR'),'2','8','0',null,'0',null);
REM INSERTING into GURIBE1378.INFORMATION_BILL
SET DEFINE OFF;
Insert into GURIBE1378.INFORMATION_BILL (PACIENTE,NOMBRE,APELLIDO,DIRECCION,FECHA,TOTAL,HOSPITALIZACION) values ('40001','Kuame','Shellie','4235 Cras Avenida',to_date('12/03/17','DD/MM/RR'),'13,63','8');
Insert into GURIBE1378.INFORMATION_BILL (PACIENTE,NOMBRE,APELLIDO,DIRECCION,FECHA,TOTAL,HOSPITALIZACION) values ('40000','Kenneth','Candice','850-9921 Auctor Carretera',to_date('16/01/17','DD/MM/RR'),'46,08','2');
Insert into GURIBE1378.INFORMATION_BILL (PACIENTE,NOMBRE,APELLIDO,DIRECCION,FECHA,TOTAL,HOSPITALIZACION) values ('40000','Kenneth','Candice','850-9921 Auctor Carretera',to_date('12/03/17','DD/MM/RR'),'337,08','24');
Insert into GURIBE1378.INFORMATION_BILL (PACIENTE,NOMBRE,APELLIDO,DIRECCION,FECHA,TOTAL,HOSPITALIZACION) values ('40003','Harlan','Elliott','Apdo.:198-6725 Tincidunt. Avenida',to_date('16/01/17','DD/MM/RR'),'8','4');
Insert into GURIBE1378.INFORMATION_BILL (PACIENTE,NOMBRE,APELLIDO,DIRECCION,FECHA,TOTAL,HOSPITALIZACION) values ('40003','Harlan','Elliott','Apdo.:198-6725 Tincidunt. Avenida',to_date('16/01/17','DD/MM/RR'),'7,186','4');
Insert into GURIBE1378.INFORMATION_BILL (PACIENTE,NOMBRE,APELLIDO,DIRECCION,FECHA,TOTAL,HOSPITALIZACION) values ('40000','Kenneth','Candice','850-9921 Auctor Carretera',to_date('12/03/17','DD/MM/RR'),'88,581','8');
Insert into GURIBE1378.INFORMATION_BILL (PACIENTE,NOMBRE,APELLIDO,DIRECCION,FECHA,TOTAL,HOSPITALIZACION) values ('40003','Harlan','Elliott','Apdo.:198-6725 Tincidunt. Avenida',to_date('12/03/17','DD/MM/RR'),'88,581','8');
--------------------------------------------------------
--  DDL for Index ID_PK_BILL
--------------------------------------------------------

  CREATE UNIQUE INDEX "GURIBE1378"."ID_PK_BILL" ON "GURIBE1378"."BILLS" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index ID_PK_CITIES
--------------------------------------------------------

  CREATE UNIQUE INDEX "GURIBE1378"."ID_PK_CITIES" ON "GURIBE1378"."CITIES" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index ID_PK_COST_CENTER
--------------------------------------------------------

  CREATE UNIQUE INDEX "GURIBE1378"."ID_PK_COST_CENTER" ON "GURIBE1378"."COST_CENTER" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index ID_PK_INVENTORIES
--------------------------------------------------------

  CREATE UNIQUE INDEX "GURIBE1378"."ID_PK_INVENTORIES" ON "GURIBE1378"."INVENTORIES" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index ID_PK_PATIENTS
--------------------------------------------------------

  CREATE UNIQUE INDEX "GURIBE1378"."ID_PK_PATIENTS" ON "GURIBE1378"."PATIENTS" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index ID_PK_SERVICES
--------------------------------------------------------

  CREATE UNIQUE INDEX "GURIBE1378"."ID_PK_SERVICES" ON "GURIBE1378"."SERVICES" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index ID_PK_SERVICESDET
--------------------------------------------------------

  CREATE UNIQUE INDEX "GURIBE1378"."ID_PK_SERVICESDET" ON "GURIBE1378"."SERVICES_DETAILS" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Trigger UPDATE_INVENTORIES
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "GURIBE1378"."UPDATE_INVENTORIES" AFTER INSERT  ON  SERVICES_DETAILS 
DECLARE CURSOR CANTIDAD IS

  SELECT QUANTITY ,INVENTORIES.SERVICE_ID ,BILLS.ID  FROM INVENTORIES
  JOIN SERVICES_DETAILS ON SERVICES_DETAILS.SERVICE_ID = INVENTORIES.SERVICE_ID
  JOIN BILLS ON SERVICES_DETAILS.BILL_ID= BILLS.ID;

  Q INVENTORIES.QUANTITY%TYPE;
  I INVENTORIES.SERVICE_ID%TYPE;
  B BILLS.ID%TYPE; 
  j INTEGER; 
IDE integer;
iden integer;
ideb integer;

BEGIN 
    OPEN CANTIDAD;    
    FETCH CANTIDAD INTO Q,I,B;
     Select id into ideb from (select id from bills order by id desc ) where rownum = 1 ; 
     Select BILL_ID into ide from (select BILL_ID from services_DETAILS order by BILL_ID desc ) where rownum = 1 ;      
          WHILE CANTIDAD%FOUND LOOP          
              if  ide =  ideb then 
                  select service_id into j from SERVICES_DETAILS where BILL_ID = ideb;
                  FETCH CANTIDAD INTO Q,I,B;
                  update inventories set QUANTITY= (Q-1)where service_id=j; 
              end if;
          END LOOP;            
     CLOSE CANTIDAD; 
  END;
/
ALTER TRIGGER "GURIBE1378"."UPDATE_INVENTORIES" ENABLE;
------------------------------------------------------
--  DDL for Procedure INCREASE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "INCREASE" AS
IDE integer;
centro integer;
i INTEGER:=1;
iden integer;
BEGIN
SELECT id into iden FROM services where rownum=1;
Select id into ide from (select id from services order by id desc ) where rownum = 1 ; 
for i IN iden..ide LOOP        
            SELECT COST_CENTER_ID into centro FROM services where id=iden;            
             if centro=20000 then
                update services set CHARGE_SERVICE=CHARGE_SERVICE+(CHARGE_SERVICE*0.02)where COST_CENTER_ID='20000';
                elsif centro=20011 then
                update services set CHARGE_SERVICE=CHARGE_SERVICE+(CHARGE_SERVICE*0.035)where COST_CENTER_ID='20011';
                elsif centro=20003 then
                update services set CHARGE_SERVICE=CHARGE_SERVICE+(CHARGE_SERVICE*0.04)where COST_CENTER_ID='20003';
                end if;
        iden:=iden+1;
 end loop;
end;
---execute INCREASE;
---select * from services;

/
--------------------------------------------------------
--  DDL for Procedure NOMBRE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GURIBE1378"."NOMBRE" is
begin
    declare 
        nombre VARCHAR(100);--- := 'Pepito perez';
        letra VARCHAR(1);
        letra2 VARCHAR(1);
        contador int;                       
    begin 
        for i in 1..LENGTH(nombre) loop
            contador :=0;
            letra := SUBSTR(nombre, i, 1);
            for j in 1..LENGTH(nombre) loop
                letra2 := SUBSTR(nombre, j, 1);                 
                    if (letra2 = letra) then
                        contador := contador +1;
                    end if;

            end loop;
            end loop;
            end;
            end;

/
--------------------------------------------------------
--  DDL for Function FN_COST_CENTER_BILL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "GURIBE1378"."FN_COST_CENTER_BILL" (C_CENTER_ID IN NUMBER, BILL_IDS IN NUMBER )RETURN varchar IS
RESPUESTA varchar(20);

BEGIN
SELECT SUM(SERVICES.CHARGE_SERVICE)INTO RESPUESTA FROM SERVICES JOIN SERVICES_DETAILS
    ON SERVICES.ID = SERVICES_DETAILS.SERVICE_ID JOIN COST_CENTER 
    ON COST_CENTER.ID = SERVICES.COST_CENTER_ID JOIN BILLS ON SERVICES_DETAILS.BILL_ID = BILLS.ID                                             
WHERE C_CENTER_ID = COST_CENTER.ID  AND BILL_IDS = BILLS.ID;  
IF  RESPUESTA >' ' THEN
        DBMS_OUTPUT.PUT_LINE(RESPUESTA);
        ELSE
         DBMS_OUTPUT.PUT_LINE('0');        
        END IF;
RETURN RESPUESTA;
END;

/
--------------------------------------------------------
--  DDL for Function FN_COST_CENTER_COUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "GURIBE1378"."FN_COST_CENTER_COUNT" (CCENTER_ID IN NUMBER, BILLIDS IN NUMBER )RETURN varchar IS
RESPUESTAC varchar(20);

BEGIN
SELECT COUNT(SERVICES.CHARGE_SERVICE)INTO RESPUESTAC FROM SERVICES JOIN SERVICES_DETAILS
    ON SERVICES.ID = SERVICES_DETAILS.SERVICE_ID JOIN COST_CENTER 
    ON COST_CENTER.ID = SERVICES.COST_CENTER_ID JOIN BILLS ON SERVICES_DETAILS.BILL_ID = BILLS.ID                                             
WHERE CCENTER_ID = COST_CENTER.ID  AND BILLIDS = BILLS.ID;  
        IF  RESPUESTAC >' ' THEN
            DBMS_OUTPUT.PUT_LINE(RESPUESTAC);
         ELSE

         DBMS_OUTPUT.PUT_LINE('0');  
         END IF;   
        RETURN RESPUESTAC;
END;

/
--------------------------------------------------------
--  Constraints for Table BILLS
--------------------------------------------------------

  ALTER TABLE "GURIBE1378"."BILLS" ADD CONSTRAINT "ID_PK_BILL" PRIMARY KEY ("ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table CITIES
--------------------------------------------------------

  ALTER TABLE "GURIBE1378"."CITIES" ADD CONSTRAINT "ID_PK_CITIES" PRIMARY KEY ("ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table COST_CENTER
--------------------------------------------------------

  ALTER TABLE "GURIBE1378"."COST_CENTER" ADD CONSTRAINT "ID_PK_COST_CENTER" PRIMARY KEY ("ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table INVENTORIES
--------------------------------------------------------

  ALTER TABLE "GURIBE1378"."INVENTORIES" ADD CONSTRAINT "ID_PK_INVENTORIES" PRIMARY KEY ("ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table PATIENTS
--------------------------------------------------------

  ALTER TABLE "GURIBE1378"."PATIENTS" ADD CONSTRAINT "ID_PK_PATIENTS" PRIMARY KEY ("ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table SERVICES
--------------------------------------------------------

  ALTER TABLE "GURIBE1378"."SERVICES" ADD CONSTRAINT "ID_PK_SERVICES" PRIMARY KEY ("ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table SERVICES_DETAILS
--------------------------------------------------------

  ALTER TABLE "GURIBE1378"."SERVICES_DETAILS" ADD CONSTRAINT "ID_PK_SERVICESDET" PRIMARY KEY ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BILLS
--------------------------------------------------------

  ALTER TABLE "GURIBE1378"."BILLS" ADD CONSTRAINT "FK_PATIENT" FOREIGN KEY ("PATIENT_ID")
	  REFERENCES "GURIBE1378"."PATIENTS" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table INVENTORIES
--------------------------------------------------------

  ALTER TABLE "GURIBE1378"."INVENTORIES" ADD CONSTRAINT "FK_COSTCENTER" FOREIGN KEY ("COST_CENTER_ID")
	  REFERENCES "GURIBE1378"."COST_CENTER" ("ID") ENABLE;
  ALTER TABLE "GURIBE1378"."INVENTORIES" ADD CONSTRAINT "FK_SERVICE" FOREIGN KEY ("SERVICE_ID")
	  REFERENCES "GURIBE1378"."SERVICES" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PATIENTS
--------------------------------------------------------

  ALTER TABLE "GURIBE1378"."PATIENTS" ADD CONSTRAINT "FK_CITY_ID" FOREIGN KEY ("CITY_ID")
	  REFERENCES "GURIBE1378"."CITIES" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SERVICES
--------------------------------------------------------

  ALTER TABLE "GURIBE1378"."SERVICES" ADD CONSTRAINT "FK_COST_CENTER_ID" FOREIGN KEY ("COST_CENTER_ID")
	  REFERENCES "GURIBE1378"."COST_CENTER" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SERVICES_DETAILS
--------------------------------------------------------

  ALTER TABLE "GURIBE1378"."SERVICES_DETAILS" ADD CONSTRAINT "FK_BILL" FOREIGN KEY ("BILL_ID")
	  REFERENCES "GURIBE1378"."BILLS" ("ID") ENABLE;
  ALTER TABLE "GURIBE1378"."SERVICES_DETAILS" ADD CONSTRAINT "FK_SERVICE_ID" FOREIGN KEY ("SERVICE_ID")
	  REFERENCES "GURIBE1378"."SERVICES" ("ID") ENABLE;
