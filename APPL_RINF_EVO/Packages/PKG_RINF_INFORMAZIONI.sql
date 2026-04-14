--
-- PKG_RINF_INFORMAZIONI  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_INFORMAZIONI" 

IS

TYPE empcur IS REF CURSOR;
PROCEDURE SetNewInfoRequest(p_ID_UTENTE VARCHAR2, p_OGGETTO VARCHAR2,p_TESTO VARCHAR2, p_EMAIL_MITTENTE VARCHAR2,p_CODICE_PRIORITA NUMBER,p_CODICE_TIPO NUMBER, p_Codice_Richiesta OUT NUMBER,p_error OUT NUMBER);
PROCEDURE GetMyInfoRequests(p_ID_UTENTE VARCHAR2,p_cursor OUT empcur);
PROCEDURE GetAllRequests(p_cursor OUT empcur);
PROCEDURE SetRequestState(p_Codice_Richiesta NUMBER, p_Stato NUMBER,p_error OUT NUMBER);
PROCEDURE GetAllStates(p_cursor OUT empcur);
PROCEDURE GetAllPriorities(p_cursor OUT empcur);
PROCEDURE GetAllTypes(p_cursor OUT empcur);

END;
/


--
-- PKG_RINF_INFORMAZIONI  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_INFORMAZIONI" 
IS
PROCEDURE SetNewInfoRequest(p_ID_UTENTE VARCHAR2, p_OGGETTO VARCHAR2,p_TESTO VARCHAR2, p_EMAIL_MITTENTE VARCHAR2,p_CODICE_PRIORITA NUMBER,p_CODICE_TIPO NUMBER, p_Codice_Richiesta OUT NUMBER,p_error OUT NUMBER) IS
l_clob clob;
BEGIN
p_error:=0;

select RINF_AMMINISTRAZIONE_EVO.SQ_CODICE_RICHIESTA.nextval into p_Codice_Richiesta from dual;

INSERT INTO RINF_AMMINISTRAZIONE_EVO.RICHIESTE_INFORMAZIONE
VALUES (p_Codice_Richiesta,SYSDATE,PKG_RINF_SICUREZZA.GetUserID(p_id_utente), p_OGGETTO, empty_clob(), p_EMAIL_MITTENTE, p_CODICE_PRIORITA, 2, p_CODICE_TIPO, NULL)
returning TESTO into l_clob;
dbms_lob.write( l_clob,length(p_TESTO), 1,p_TESTO);

PKG_RINF_NOTIFICHE.SETPOSTIIT_V2(5,NULL,NULL,NULL);

EXCEPTION
      WHEN OTHERS
      THEN
         p_error := SQLCODE;
         DBMS_OUTPUT.PUT_LINE ('Errore ' || SUBSTR (SQLERRM, 1, 300));
END SetNewInfoRequest;
PROCEDURE GetMyInfoRequests(p_ID_UTENTE VARCHAR2,p_cursor OUT empcur) IS
BEGIN
OPEN p_cursor FOR
         SELECT CODICE_RICHIESTA,
            DATA_RICHIESTA        ,
            ID_UTENTE             ,
            CODICE_UTENTE         ,
            COGNOME               ,
            NOME                  ,
            OGGETTO               ,
            TESTO                 ,
            EMAIL_MITTENTE        ,
            CODICE_PRIORITA       ,
            PRIORITA              ,
            CODICE_STATO          ,
            STATO                 ,
            CODICE_TIPO           ,
            TIPO                  ,
            DATA_EVASIONE
         from V_RICHIESTE_INFORMAZIONE
         where
         id_utente=PKG_RINF_SICUREZZA.GetUserID(p_id_utente);

END GetMyInfoRequests;
PROCEDURE GetAllRequests(p_cursor OUT empcur) IS
BEGIN
OPEN p_cursor FOR
         SELECT CODICE_RICHIESTA,
            DATA_RICHIESTA        ,
            ID_UTENTE             ,
            CODICE_UTENTE         ,
            COGNOME               ,
            NOME                  ,
            OGGETTO               ,
            TESTO                 ,
            EMAIL_MITTENTE        ,
            CODICE_PRIORITA       ,
            PRIORITA              ,
            CODICE_STATO          ,
            STATO                 ,
            CODICE_TIPO           ,
            TIPO                  ,
            DATA_EVASIONE
         from V_RICHIESTE_INFORMAZIONE;
END GetAllRequests;
PROCEDURE SetRequestState(p_Codice_Richiesta NUMBER, p_Stato NUMBER,p_error OUT NUMBER) IS
flag_chiuso NUMBER;
BEGIN
p_error:=0;
Select CASE WHEN UPPER(DESCRIZIONE)='CHIUSA'THEN 1
ELSE 0
END into flag_chiuso
from RINF_AMMINISTRAZIONE_EVO.ANAG_STATO_RICHIESTA
where codice_stato=p_Stato;

UPDATE RINF_AMMINISTRAZIONE_EVO.RICHIESTE_INFORMAZIONE
SET
CODICE_STATO=p_STATO,
DATA_EVASIONE= DECODE(flag_chiuso,1,SYSDATE,NULL)
where
CODICE_RICHIESTA=p_Codice_Richiesta;

Select count(*) into flag_chiuso from RINF_AMMINISTRAZIONE_EVO.RICHIESTE_INFORMAZIONE
WHERE CODICE_STATO=2; --conteggio richieste aperte
IF flag_chiuso>0 THEN
    PKG_RINF_NOTIFICHE.SETPOSTIIT_V2(5,NULL,NULL,NULL);
ELSE
    PKG_RINF_NOTIFICHE.SETPOSTIIT_V2(6,NULL,NULL,NULL);
END IF;

EXCEPTION
      WHEN OTHERS
      THEN
         p_error := SQLCODE;
         DBMS_OUTPUT.PUT_LINE ('Errore ' || SUBSTR (SQLERRM, 1, 300));
END SetRequestState;
PROCEDURE GetAllStates(p_cursor OUT empcur) IS
BEGIN
OPEN p_cursor FOR
         SELECT
            CODICE_STATO          ,
            DESCRIZIONE STATO
         from RINF_AMMINISTRAZIONE_EVO.ANAG_STATO_RICHIESTA;
END GetAllStates;
PROCEDURE GetAllPriorities(p_cursor OUT empcur) IS
BEGIN
OPEN p_cursor FOR
         SELECT
            CODICE_PRIORITA          ,
            DESCRIZIONE  PRIORITA
         from RINF_AMMINISTRAZIONE_EVO.ANAG_PRIORITA;
END GetAllPriorities;

PROCEDURE GetAllTypes(p_cursor OUT empcur) IS
BEGIN
OPEN p_cursor FOR
         SELECT
            CODICE_TIPO          ,
            DESCRIZIONE  TIPO
         from RINF_AMMINISTRAZIONE_EVO.ANAG_TIPO_RICHIESTA;
END GetAllTypes;

END PKG_RINF_INFORMAZIONI;
/