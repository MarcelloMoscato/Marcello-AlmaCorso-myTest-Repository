--
-- PKG_RINF_UTILITY  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_UTILITY" 

IS

TYPE empcur IS REF CURSOR;

FUNCTION SETFILELOG(nome_file IN varchar2,PATHFILE IN varchar2,d_file IN date ) RETURN  UTL_FILE.FILE_TYPE;
PROCEDURE SETLINEINTOFILE(id_file IN UTL_FILE.FILE_TYPE, line_text IN varchar2);
--
PROCEDURE SETPROCESSSTATUS
(vtran_id    IN varchar2,
vmessage    IN varchar2,
vstep        IN integer,
vstep_of    IN integer,
vindex_corr    IN integer,
vindex_of     IN integer,
vcodice_esito IN INTEGER,
voperazione     IN integer
);

PROCEDURE GETPROCESSSTATUS (vtran_id IN varchar2, cursore OUT SYS_refcursor);
PROCEDURE DELPROCESSSTATUS (vtran_id IN VARCHAR2);
PROCEDURE SetNewLOG(p_CODICE_ATTIVITA NUMBER, p_TESTO VARCHAR2,p_codice_utente VARCHAR2, p_error OUT NUMBER);
PROCEDURE GetAllLogs(p_CODICE_ATTIVITA NUMBER, p_cursor OUT empcur);
PROCEDURE SetClearLog(p_giorni NUMBER, p_usa_filtro NUMBER,p_error OUT NUMBER);
PROCEDURE SetNewSemaforo (p_id IN NUMBER,p_stato IN NUMBER, p_error OUT NUMBER);
PROCEDURE SetSemaforoStato (p_id IN NUMBER,p_stato IN NUMBER, p_error OUT NUMBER);
PROCEDURE SetDeleteSemaforo (p_id IN NUMBER, p_error OUT NUMBER);
PROCEDURE GetStatoSemaforo (p_id IN NUMBER, p_stato OUT NUMBER);
-- -----------------------------------------------------------------------------
-- Nuove procedure per la gestione dell'area cache 27/02/2019 (sviluppo)
-- -----------------------------------------------------------------------------
PROCEDURE GetStatoCache (cursore  OUT SYS_REFCURSOR);
PROCEDURE SetStatoCache (p_stato IN NUMBER, p_macchina Varchar2, p_error OUT NUMBER);
PROCEDURE DelStatoCache (p_error OUT NUMBER);
END;
/


--
-- PKG_RINF_UTILITY  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_UTILITY" 
IS
   FUNCTION SETFILELOG (nome_file   IN VARCHAR2,
                        PATHFILE    IN VARCHAR2,
                        d_file      IN DATE)
      RETURN UTL_FILE.FILE_TYPE
   IS
      VAR_HANDLE_FILES   UTL_FILE.FILE_TYPE;
      NOMEFILE           VARCHAR2 (300);
   BEGIN
      --NOMEFILE:=nome_file ||'_'|| TO_CHAR(d_file,'DDMMYYYY') || '.log' ;
      NOMEFILE := nome_file;

      VAR_HANDLE_FILES :=
         UTL_FILE.FOPEN (PATHFILE,
                         NOMEFILE,
                         'w',
                         32767);
      RETURN VAR_HANDLE_FILES;
   END SETFILELOG;

   PROCEDURE SETLINEINTOFILE (id_file     IN UTL_FILE.FILE_TYPE,
                              line_text   IN VARCHAR2)
   IS
   BEGIN
      IF UTL_FILE.IS_OPEN (id_file)
      THEN
         --UTL_FILE.FCLOSE (id_file);
         UTL_FILE.PUT_LINE (id_file, line_text);
      END IF;
   --UTL_FILE.PUT_LINE (id_file,line_text);
   END SETLINEINTOFILE;

   PROCEDURE SETPROCESSSTATUS (vtran_id      IN VARCHAR2,
                               vmessage      IN VARCHAR2,
                               vstep         IN INTEGER,
                               vstep_of      IN INTEGER,
                               vindex_corr   IN INTEGER,
                               vindex_of     IN INTEGER,
                               vcodice_esito IN INTEGER,
                               voperazione   IN INTEGER)
   IS
   BEGIN
      CASE
         WHEN voperazione = 0
         THEN                                  -- devo eseguire un inserimento
            INSERT INTO PROCESS_STATUS (tran_id,
                                        MESSAGE,
                                        step,
                                        step_of,
                                        index_corr,
                                        index_of,
                                        codice_esito,
                                        data)
                 VALUES (vtran_id,
                         vmessage,
                         vstep,
                         vstep_of,
                         vindex_corr,
                         vindex_of,
                         vcodice_esito,
                         SYSDATE);

            COMMIT;
         WHEN voperazione <> 0 AND vtran_id IS NOT NULL
         THEN                                -- devo eseguire un aggiornamento
            UPDATE PROCESS_STATUS
               SET MESSAGE = vmessage,
                   step_of = vstep_of,
                   index_corr = vindex_corr,
                   index_of = vindex_of,
                   codice_esito = vcodice_esito,
                   data = SYSDATE
             WHERE tran_id = vtran_id
             and step = vstep;

            COMMIT;
      END CASE;
   END SETPROCESSSTATUS;



--   PROCEDURE GETPROCESSSTATUS (vtran_id   IN     VARCHAR2,
--                               cursore       OUT SYS_REFCURSOR)
--   IS
--   BEGIN
--      IF vtran_id IS NOT NULL
--      THEN
--         OPEN cursore FOR
--            SELECT *
--              FROM PROCESS_STATUS
--             WHERE     tran_id = vtran_id
--                   AND data = (SELECT MAX (data)
--                                 FROM PROCESS_STATUS
--                                WHERE tran_id = vtran_id)
--                                ORDER BY STEP DESC;
--      END IF;
--   END GETPROCESSSTATUS;

      PROCEDURE GETPROCESSSTATUS (vtran_id   IN     VARCHAR2,
                               cursore       OUT SYS_REFCURSOR)
   IS
   id_tran VARCHAR2(300);
   BEGIN
      IF vtran_id IS NULL THEN
      Select tran_id into id_tran
      FROM PROCESS_STATUS
      where step=1 and
      data in (select max(data) from PROCESS_STATUS where step=1);
   ELSE id_tran:= vtran_id;
   END IF;

         OPEN cursore FOR
            SELECT *
              FROM PROCESS_STATUS
             WHERE     tran_id = id_tran;
    EXCEPTION
      WHEN OTHERS
      THEN    OPEN cursore FOR select NULL TRAN_ID, NULL MESSAGE, NULL STEP, NULL STEP_OF,
      NULL INDEX_CORR, NULL INDEX_OF, NULL CODICE_ESITO, NULL DATA
      from dual;

   END GETPROCESSSTATUS;
   PROCEDURE DELPROCESSSTATUS (vtran_id      IN VARCHAR2) IS
   BEGIN
   DELETE FROM PROCESS_STATUS
    WHERE tran_id = vtran_id;

    COMMIT;
   END DELPROCESSSTATUS;
PROCEDURE SetNewLOG(p_CODICE_ATTIVITA NUMBER, p_TESTO VARCHAR2,p_codice_utente VARCHAR2, p_error OUT NUMBER) IS
l_clob clob;
BEGIN
p_error:=0;

INSERT INTO LOG_HISTORY (ID_LOG, CODICE_ATTIVITA, DATA_ATTIVITA, TESTO, ID_UTENTE)
VALUES (APPL_RINF_EVO.SQ_ID_LOG.nextval,p_CODICE_ATTIVITA,SYSDATE, empty_clob(),PKG_RINF_SICUREZZA.GetUserID(p_codice_utente))
returning TESTO into l_clob;
dbms_lob.write( l_clob,length(p_TESTO), 1,p_TESTO);
EXCEPTION
      WHEN OTHERS
      THEN
         p_error := SQLCODE;
         DBMS_OUTPUT.PUT_LINE ('Errore ' || SUBSTR (SQLERRM, 1, 300));
END SetNewLOG;

PROCEDURE GetAllLogs(p_CODICE_ATTIVITA NUMBER, p_cursor OUT empcur) IS
sql_string VARCHAR2(2000);
BEGIN
sql_string:='SELECT  ID_LOG, CODICE_ATTIVITA, DATA_ATTIVITA, TESTO,PKG_RINF_SICUREZZA.GetUserName(ID_UTENTE) nome_utente, PKG_RINF_SICUREZZA.GetUserCode(ID_UTENTE) codice_utente  ';--da specifiche tecniche si vuole sia nome sia codice
sql_string:=sql_string||' from LOG_HISTORY';
IF p_CODICE_ATTIVITA<>-1 THEN
sql_string:=sql_string||' where CODICE_ATTIVITA='||p_CODICE_ATTIVITA;
END IF;
OPEN p_cursor FOR sql_string;
END GetAllLogs;
PROCEDURE SetClearLog(p_giorni NUMBER, p_usa_filtro NUMBER,p_error OUT NUMBER) IS
BEGIN
p_error:=0;
IF p_usa_filtro=1 THEN
    delete from LOG_HISTORY
    where CODICE_ATTIVITA=0 and
    DATA_ATTIVITA<sysdate-p_giorni;
ELSE
    delete from LOG_HISTORY
    where
    DATA_ATTIVITA<sysdate-p_giorni;
END IF;

delete from PROCESS_STATUS
where
    DATA<sysdate-p_giorni;
EXCEPTION
      WHEN OTHERS
      THEN
         p_error := SQLCODE;
END SetClearLog;
PROCEDURE SetNewSemaforo (p_id IN NUMBER,p_stato IN NUMBER, p_error OUT NUMBER) IS
BEGIN
p_error:=0;
INSERT INTO APPL_RINF_EVO.SEMAFORO (ID, STATO, DATA_CREAZIONE)
VALUES(p_id, p_stato, SYSDATE);
EXCEPTION
      WHEN OTHERS
      THEN
         p_error := SQLCODE;
END SetNewSemaforo;

PROCEDURE SetSemaforoStato (p_id IN NUMBER,p_stato IN NUMBER, p_error OUT NUMBER) IS
BEGIN
p_error:=0;
UPDATE APPL_RINF_EVO.SEMAFORO
SET
STATO=p_stato,
DATA_AGGIORNAMENTO=SYSDATE
WHERE
ID=p_id;

EXCEPTION
      WHEN OTHERS
      THEN
         p_error := SQLCODE;
END SetSemaforoStato;
PROCEDURE SetDeleteSemaforo (p_id IN NUMBER, p_error OUT NUMBER) IS
BEGIN
p_error:=0;
DELETE FROM APPL_RINF_EVO.SEMAFORO
WHERE
ID=p_id;

EXCEPTION
      WHEN OTHERS
      THEN
         p_error := SQLCODE;
END SetDeleteSemaforo;
PROCEDURE GetStatoSemaforo (p_id IN NUMBER, p_stato OUT NUMBER) IS

BEGIN

Select STATO into p_stato
FROM APPL_RINF_EVO.SEMAFORO
WHERE
ID=p_id;

EXCEPTION
      WHEN OTHERS
      THEN
         p_stato := SQLCODE;
END GetStatoSemaforo;
-- -----------------------------------------------------------------------------
-- Nuove procedure per la gestione dell'area cache 27/02/2019 (sviluppo)
-- -----------------------------------------------------------------------------
PROCEDURE GetStatoCache (cursore  OUT SYS_REFCURSOR) IS
--
BEGIN
--
 OPEN cursore FOR
            Select STATO, NOME_MACCHINA
   FROM APPL_RINF_EVO.AGGIORNA_CACHE;
--
 EXCEPTION
      When OTHERS Then
      Open cursore FOR
                          Select Null STATO, Null NOME_MACCHINA
                          From Dual;
END GetStatoCache;
--
PROCEDURE SetStatoCache (p_stato IN NUMBER, p_macchina Varchar2, p_error OUT NUMBER) IS
--
APPO_STATO         AGGIORNA_CACHE.STATO%TYPE;
APPO_NOME_MACCHINA AGGIORNA_CACHE.NOME_MACCHINA%TYPE;

BEGIN
p_error:=0;
--
if ((P_STATO = 0 or P_STATO = 1) AND P_MACCHINA is NOT NULL) Then
     begin
     Select STATO, NOME_MACCHINA into APPO_STATO, APPO_NOME_MACCHINA
        FROM APPL_RINF_EVO.AGGIORNA_CACHE;
     EXCEPTION
        When NO_DATA_FOUND Then
          APPO_STATO :=NULL;
          APPO_NOME_MACCHINA := NULL;
     END;
     --
        if APPO_STATO is NULL and APPO_NOME_MACCHINA is NULL Then
           Insert Into APPL_RINF_EVO.AGGIORNA_CACHE (STATO, NOME_MACCHINA)
           values (P_STATO, P_MACCHINA);
        else
          Update APPL_RINF_EVO.AGGIORNA_CACHE
          set STATO = P_STATO,
              NOME_MACCHINA =P_MACCHINA;
        end if;

 end if;

EXCEPTION
      WHEN OTHERS
      THEN
         p_error := SQLCODE;
END SetStatoCache;
--
PROCEDURE DelStatoCache (p_error OUT NUMBER) IS
--
BEGIN
p_error:=0;
--
    delete from APPL_RINF_EVO.AGGIORNA_CACHE;

EXCEPTION
      WHEN OTHERS
      THEN
         p_error := SQLCODE;
END DelStatoCache;


END PKG_RINF_UTILITY;
/