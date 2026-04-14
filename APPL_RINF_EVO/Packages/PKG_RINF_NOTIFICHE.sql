--
-- PKG_RINF_NOTIFICHE  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_NOTIFICHE" as
    TYPE empcur IS REF CURSOR;
    --PROCEDURE GetNotificheByUtente (p_Codice_Utente in varchar2, p_cursor OUT empcur);
    --PROCEDURE SetPostiIt(p_PostID in number, p_ventType in number, p_CodDtp in varchar2 default '-1', p_DataScadenza in varchar2 default null)  ;
    PROCEDURE  SetPostiIt_V2(p_PostID in number,  p_CodDtp in varchar2 default null,p_versione IN NUMBER DEFAULT NULL, p_DataScadenza in varchar2 default null);
    PROCEDURE GetNotificheByUtente (p_Codice_Utente in varchar2, p_cursor OUT empcur);
end PKG_RINF_NOTIFICHE ;
/


--
-- PKG_RINF_NOTIFICHE  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_NOTIFICHE" 
IS

PROCEDURE GetNotificheByUtente (p_Codice_Utente in varchar2, p_cursor OUT empcur)
   IS
    l_UtenteId number;
    BEGIN
        l_UtenteId := PKG_RINF_SICUREZZA.GetUserID(p_Codice_Utente);



        OPEN p_cursor FOR

        SELECT DISTINCT
            PTT_EVENT_POSTIT REL_POSTIT_MSG
          FROM RINF_SICUREZZA_EVO.POSTIT_V2 a, RINF_SICUREZZA_EVO.UTENTE_RUOLI ur
         WHERE     ur.id_utente = l_UtenteId
               AND ur.codice_ruolo = a.PTT_CODICE_RUOLO
               AND ur.CODICE_DTP = A.PTT_CODICE_DTP
               AND ur.CODICE_UT = a.PTT_CODICE_UT
               AND ptt_codice_ruolo = PTT_CODICE_RUOLO;

        exception when others then
            OPEN p_cursor FOR select null from dual;
    END GetNotificheByUtente;

PROCEDURE  SetPostiIt_V2(p_PostID in number,  p_CodDtp in varchar2 default null,p_versione IN NUMBER DEFAULT NULL, p_DataScadenza in varchar2 default null) IS
    Begin

      IF  p_PostID= 1 THEN --Nuova richiesta autorizzazione

DELETE FROM RINF_SICUREZZA_EVO.POSTIT_V2
      WHERE PTT_EVENT_ID = 1;                                                                        --Pulizia eventuali postit precedenti rimasti appesi

INSERT INTO RINF_SICUREZZA_EVO.POSTIT_V2 (PTT_ID,
                                      PTT_CODICE_RUOLO,
                                      PTT_CODICE_DTP,
                                      PTT_CODICE_UT,
                                      PTT_CODICE_TIPO_DEPOSITARIO,
                                      PTT_EVENT_ID,
                                      PTT_EVENT_POSTIT,
                                      PTT_DATE,
                                      PTT_CODICE_VERSIONE)
   SELECT RINF_SICUREZZA_EVO.POSTIT_SEQ.NEXTVAL,
          1,
          -1,
          -1,
          -1,
          p_PostID,
          REPLACE (REL_POSTIT_MSG, '<Dati>', p_DataScadenza),
          SYSDATE,
          NULL
     FROM RINF_SICUREZZA_EVO.RUOLI_POSTIT_V2
    WHERE REL_POSTIT_ID = p_PostID AND REL_CODICE_RUOLO = 1;

INSERT INTO RINF_SICUREZZA_EVO.POSTIT_V2 (PTT_ID,
                                      PTT_CODICE_RUOLO,
                                      PTT_CODICE_DTP,
                                      PTT_CODICE_UT,
                                      PTT_CODICE_TIPO_DEPOSITARIO,
                                      PTT_EVENT_ID,
                                      PTT_EVENT_POSTIT,
                                      PTT_DATE,
                                      PTT_CODICE_VERSIONE)
   SELECT RINF_SICUREZZA_EVO.POSTIT_SEQ.NEXTVAL,
          5,
          CODICE_DTP,
          -1,
          -1,
          1,
          REPLACE (REPLACE (REL_POSTIT_MSG, '<Dati>', p_DataScadenza),
                   '<DTP>',
                   DECODE (CODICE_DTP, '-1', 'Sede Centrale', DESCRIZIONE)),
          SYSDATE,
          NULL
     FROM RINF_SICUREZZA_EVO.RUOLI_POSTIT_V2, RINF_ANAGRAFICHE_EVO.ANAG_DTP
    WHERE REL_POSTIT_ID = p_PostID AND REL_CODICE_RUOLO = 5;

ELSIF  p_PostID= 2 THEN      --Cancellante per 5 1 della stessa DTP

DELETE FROM RINF_SICUREZZA_EVO.POSTIT_V2
      WHERE     PTT_EVENT_ID = 1
            AND PTT_CODICE_RUOLO = 5
            AND PTT_CODICE_DTP = p_CodDtp;

ELSIF  p_PostID= 3 THEN      --Cancellante per 5 1 della stessa DTP

DELETE FROM RINF_SICUREZZA_EVO.POSTIT_V2
      WHERE PTT_EVENT_ID = 1;                                                                      --elimina tutte le richiste di autorizzazione

INSERT INTO RINF_SICUREZZA_EVO.POSTIT_V2 (PTT_ID,
                                      PTT_CODICE_RUOLO,
                                      PTT_CODICE_DTP,
                                      PTT_CODICE_UT,
                                      PTT_CODICE_TIPO_DEPOSITARIO,
                                      PTT_EVENT_ID,
                                      PTT_EVENT_POSTIT,
                                      PTT_DATE,
                                      PTT_CODICE_VERSIONE)
   SELECT RINF_SICUREZZA_EVO.POSTIT_SEQ.NEXTVAL,
          REL_CODICE_RUOLO,
          -1,
          -1,
          -1,
          p_PostID,
          REPLACE (REL_POSTIT_MSG, '<Dati>', p_versione),
          SYSDATE,
          p_versione
     FROM RINF_SICUREZZA_EVO.RUOLI_POSTIT_V2
    WHERE REL_POSTIT_ID = p_PostID AND REL_CODICE_RUOLO IN (1, 2);

ELSIF  p_PostID= 4 THEN

DELETE FROM RINF_SICUREZZA_EVO.POSTIT_V2
      WHERE PTT_EVENT_ID = 3 AND PTT_CODICE_VERSIONE <= p_versione;

ELSIF  p_PostID= 5 THEN

DELETE FROM RINF_SICUREZZA_EVO.POSTIT_V2
      WHERE PTT_EVENT_ID = 5;
INSERT INTO RINF_SICUREZZA_EVO.POSTIT_V2 (PTT_ID,
                                      PTT_CODICE_RUOLO,
                                      PTT_CODICE_DTP,
                                      PTT_CODICE_UT,
                                      PTT_CODICE_TIPO_DEPOSITARIO,
                                      PTT_EVENT_ID,
                                      PTT_EVENT_POSTIT,
                                      PTT_DATE,
                                      PTT_CODICE_VERSIONE)
   SELECT RINF_SICUREZZA_EVO.POSTIT_SEQ.NEXTVAL,
          REL_CODICE_RUOLO,
          -1,
          -1,
          -1,
          p_PostID,
          REL_POSTIT_MSG,
          SYSDATE,
          p_versione
     FROM RINF_SICUREZZA_EVO.RUOLI_POSTIT_V2
    WHERE REL_POSTIT_ID = p_PostID AND REL_CODICE_RUOLO=1;
ELSIF  p_PostID= 6 THEN

DELETE FROM RINF_SICUREZZA_EVO.POSTIT_V2
      WHERE PTT_EVENT_ID = 5;



END IF;

END SetPostiIt_V2;
PROCEDURE GetNotificheByUtente_OLD (p_Codice_Utente in varchar2, p_cursor OUT empcur)
   IS
    l_UtenteId number;
    BEGIN
        l_UtenteId := PKG_RINF_SICUREZZA.GetUserID(p_Codice_Utente);

        /*
        SELECT ID_UTENTE into l_UtenteId
            FROM RINF_SICUREZZA_EVO.ANAG_UTENTE
            where CODICE_UTENTE = upper(trim(p_Codice_Utente));

            SELECT REL_POSTIT_MSG
                FROM RINF_SICUREZZA_EVO.POSTIT a,RINF_SICUREZZA.ANAG_EVENTI
                , RINF_SICUREZZA_EVO.RUOLI_POSTIT
            where ptt_event_id = event_id and ptt_id_utente = l_UtenteId
            and ptt_event_id  = REL_POSTIT_ID and PTT_ACCESO = 1;

            */

        OPEN p_cursor FOR
            SELECT PTT_EVENT_POSTIT REL_POSTIT_MSG
                    FROM RINF_SICUREZZA_EVO.POSTIT a
                    , RINF_SICUREZZA_EVO.RUOLI_POSTIT
            where ptt_id_utente = l_UtenteId
                and ptt_event_id  = REL_POSTIT_ID
                and ptt_codice_ruolo = rel_codice_ruolo
                and PTT_ACCESO = 1;

        exception when others then
            OPEN p_cursor FOR select null from dual;
    END GetNotificheByUtente_OLD;
PROCEDURE  SetPostiIt_OLD(p_PostID in number, p_ventType in number, p_CodDtp in varchar2 default '-1', p_DataScadenza in varchar2 default null) IS
    Begin
        if p_ventType = 1 then
            INSERT INTO RINF_SICUREZZA_EVO.POSTIT (
                PTT_ID_UTENTE, PTT_CODICE_RUOLO, PTT_CODICE_TIPO_DEPOSITARIO,
                PTT_CODICE_DTP, PTT_CODICE_UT, PTT_EVENT_ID,PTT_EVENT_POSTIT, PTT_ACCESO
                )
            SELECT ID_UTENTE, UR.CODICE_RUOLO, UR.CODICE_TIPO_DEPOSITARIO,
             CODICE_DTP, UR.CODICE_UT, REL_POSTIT_ID ,
                CASE ATD.SIGLA_TIPO_DEPOSITARIO
                    WHEN 'RC_RINF_GOT' THEN
                        CASE WHEN p_DataScadenza is null then
                            REL_POSTIT_MSG||', quale validatore della DTP '||CODICE_DTP||'.'
                            else
                            REL_POSTIT_MSG||', con data di scadenza "'||p_DataScadenza||'", quale validatore della DTP '||CODICE_DTP||'.'
                        end
                    WHEN 'RC_RINF_DTEC' THEN
                        CASE WHEN p_DataScadenza is null then
                            REL_POSTIT_MSG||', quale validatore di Sede Centrale.'
                        else
                            REL_POSTIT_MSG||', con data di scadenza "'||p_DataScadenza||'", quale validatore di Sede Centrale.'
                        end
                    WHEN 'RC_RINF_UT' THEN
                        CASE WHEN p_DataScadenza is null then
                            REL_POSTIT_MSG||', quale responsabile UT '||CODICE_UT||'.'
                        else
                            REL_POSTIT_MSG||', con data di scadenza "'||p_DataScadenza||'", quale responsabile UT '||CODICE_UT||'.'
                        end
                    WHEN 'RC_RES_DCI' THEN
                        CASE WHEN p_DataScadenza is null then
                                REL_POSTIT_MSG||', quale responsabile DTP '||CODICE_DTP||'.'
                            else
                                REL_POSTIT_MSG||', con data di scadenza "'||p_DataScadenza||'", quale responsabile DTP '||CODICE_DTP||'.'
                            end
                    ELSE REL_POSTIT_MSG END MSG,
                    --Flag accendi spegni evento
                    CASE EVENT_EVENTTYPE_ID when 2 then 0 else 1 end
            FROM RINF_SICUREZZA_EVO.RUOLI_POSTIT
            , RINF_SICUREZZA_EVO.ANAG_RUOLO ar
            , RINF_SICUREZZA_EVO.UTENTE_RUOLI ur
            , RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO atd
            , RINF_SICUREZZA_EVO.ANAG_EVENTI ae
            WHERE REL_POSTIT_ID = p_PostID AND
            REL_CODICE_RUOLO = ar.CODICE_RUOLO
            AND ar.CODICE_RUOLO = ur.CODICE_RUOLO
            and ATD.CODICE_TIPO_DEPOSITARIO = ur.CODICE_TIPO_DEPOSITARIO
            AND EVENT_ID = REL_POSTIT_ID;
        elsif  p_ventType = 2 then
            --Devo aggiornare a "spento" il post it relativo
            --Se un validatore autorizza i propri dati (VR00) vengono spenti tutti i post-it
            --di tutti i validatori per quella DTP e non solo lui
            if p_CodDtp = '-1' then
                UPDATE RINF_SICUREZZA_EVO.POSTIT SET      PTT_ACCESO = 0
                where PTT_ACCESO = 1
                AND (PTT_ID_UTENTE, PTT_CODICE_RUOLO, PTT_CODICE_DTP, PTT_CODICE_TIPO_DEPOSITARIO,
                 PTT_CODICE_UT) IN
                (select UR.ID_UTENTE, UR.CODICE_RUOLO, UR.CODICE_DTP, UR.CODICE_TIPO_DEPOSITARIO,
                UR.CODICE_UT
                 from RINF_SICUREZZA_EVO.UTENTE_RUOLI ur
                , RINF_SICUREZZA_EVO.RUOLI_POSTIT
                where UR.CODICE_RUOLO = REL_CODICE_RUOLO
                AND REL_POSTIT_ID = p_PostID
                );
            else
                UPDATE RINF_SICUREZZA_EVO.POSTIT SET      PTT_ACCESO = 0
                where PTT_ACCESO = 1
                AND (PTT_ID_UTENTE, PTT_CODICE_RUOLO, PTT_CODICE_DTP, PTT_CODICE_TIPO_DEPOSITARIO,
                 PTT_CODICE_UT) IN
                (select UR.ID_UTENTE, UR.CODICE_RUOLO, UR.CODICE_DTP, UR.CODICE_TIPO_DEPOSITARIO,
                UR.CODICE_UT
                 from RINF_SICUREZZA_EVO.UTENTE_RUOLI ur
                , RINF_SICUREZZA_EVO.RUOLI_POSTIT
                where UR.CODICE_RUOLO = REL_CODICE_RUOLO
                AND REL_POSTIT_ID = p_PostID
                AND CODICE_DTP = p_CodDtp
                );
            end if;
        end if;
    end SetPostiIt_OLD;
END PKG_RINF_NOTIFICHE;
/