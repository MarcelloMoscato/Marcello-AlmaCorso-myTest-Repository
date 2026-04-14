--
-- PKG_RINF_CONSOLE  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_CONSOLE" 

IS

TYPE empcur IS REF CURSOR;
PROCEDURE GetAcquisitionStatus(p_stato OUT NUMBER);
PROCEDURE SetAcquisitionStatus(p_stato IN NUMBER,p_error OUT NUMBER);
PROCEDURE GetEnvironments(p_cursor OUT empcur);
PROCEDURE SetEnvironment(p_codice  IN NUMBER, p_error OUT NUMBER);

END PKG_RINF_CONSOLE;
/


--
-- PKG_RINF_CONSOLE  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_CONSOLE" 
IS

PROCEDURE GetAcquisitionStatus (p_stato OUT NUMBER)
IS
   n_righe   NUMBER;
BEGIN
   --0 Semaforo bloccato
   --1 semaforo libero


   SELECT COUNT (*) INTO n_righe FROM RINF_STAGING_EVO.ANAG_CARICAMENTI;

   IF n_righe = 0
   THEN
      p_stato := 1;
   ELSE
      SELECT CASE WHEN CODICE_ESITO IS NULL THEN 0 ELSE 1 END
        INTO p_stato
        FROM RINF_STAGING_EVO.ANAG_CARICAMENTI
       WHERE CODICE_CARICAMENTO IN
                (SELECT MAX (CODICE_CARICAMENTO)
                   FROM RINF_STAGING_EVO.ANAG_CARICAMENTI);
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      p_stato := 0;
END GetAcquisitionStatus;
PROCEDURE SetAcquisitionStatus(p_stato IN NUMBER,p_error OUT NUMBER) IS
BEGIN
--Questa procedura forza un valore al campo CODICE_ESITO. Se quesot campo non è valorizzato, i processi di acquisizione non partono
--perchè il semforo indica che c'è un altro processo di acquisizione in corso.
--Se si verifica un'anomalia nel processo di acquisizione, questo campo può rimanere non valorizzato e nasce la necessità di resettarlo.
--In tal caso si imposta il valore 0 (esito negativo)
--0 Semaforo bloccato
--1 semaforo libero
p_error:=0;
Update RINF_STAGING_EVO.ANAG_CARICAMENTI
SET CODICE_ESITO=DECODE(p_stato,0,NULL,0) --forzo a 0 l'esito dello step 1 dell'acquisizione quando forzo il valore del semaforo
WHERE
CODICE_CARICAMENTO IN (SELECt MAX(CODICE_CARICAMENTO) from RINF_STAGING_EVO.ANAG_CARICAMENTI);

EXCEPTION
WHEN OTHERS THEN p_error:=SQLCODE;
END SetAcquisitionStatus;
PROCEDURE GetEnvironments(p_cursor OUT empcur) IS
BEGIN

OPEN p_cursor FOR
select  CODICE, SIGLA, DEFINIZIONE,FLAG_CORRENTE
from RINF_ANAGRAFICHE_EVO.ANAG_AMBIENTE;

EXCEPTION
WHEN OTHERS THEN
OPEN p_cursor FOR 'select null CODICE, null SIGLA, null DEFINIZIONE, null FLAG_CORRENTE from dual)';
END GetEnvironments;
PROCEDURE SetEnvironment(p_codice  IN NUMBER, p_error OUT NUMBER) IS
BEGIN
p_error:=0;

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_AMBIENTE
SET FLAG_CORRENTE=DECODE(CODICE,p_codice,1,0);

EXCEPTION
WHEN OTHERS THEN
p_error:=SQLCODE;
END SetEnvironment;
END PKG_RINF_CONSOLE;
/