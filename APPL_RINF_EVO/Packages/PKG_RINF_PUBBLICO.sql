--
-- PKG_RINF_PUBBLICO  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_PUBBLICO" 

IS

TYPE empcur IS REF CURSOR;

PROCEDURE GetMenuForUserId(p_cursor OUT empcur);
PROCEDURE GetGeographicContest (p_cursor OUT empcur);
PROCEDURE GetRIMetadata (p_cursor OUT empcur);
END PKG_RINF_PUBBLICO;
/


--
-- PKG_RINF_PUBBLICO  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_PUBBLICO" 
IS
   PROCEDURE GetMenuForUserId (p_cursor OUT empcur)
   IS
   BEGIN
      OPEN p_cursor FOR
           SELECT DISTINCT M.CODICE_MENU,
                           NOMEUNICOMULTILINGUA,
                           ID_PADRE,
                           CONTROLLER,
                           ACTION,
                           ATTIVO,
                           DEFAULTROLE,
                           ID_ORDINA
             FROM RINF_SICUREZZA_EVO.MENU_RUOLI mr, RINF_SICUREZZA_EVO.ANAG_MENU m
            WHERE m.CODICE_MENU = mr.CODICE_MENU AND mr.CODICE_RUOLO = 9
         ORDER BY ID_ORDINA;
   EXCEPTION
      WHEN OTHERS
      THEN
         OPEN p_cursor FOR
              SELECT CODICE_MENU,
                     NOMEUNICOMULTILINGUA,
                     ID_PADRE,
                     CONTROLLER,
                     ACTION,
                     ATTIVO,
                     DEFAULTROLE
                FROM (SELECT DISTINCT CODICE_MENU,
                                      NOMEUNICOMULTILINGUA,
                                      ID_PADRE,
                                      CONTROLLER,
                                      ACTION,
                                      ATTIVO,
                                      DEFAULTROLE,
                                      ID_ORDINA
                        FROM RINF_SICUREZZA_EVO.V_UTENTE_MENU
                       WHERE CODICE_MENU = 1)
            ORDER BY ID_ORDINA;
   END GetMenuForUserId;

PROCEDURE GetGeographicContest (p_cursor OUT empcur) IS
BEGIN
 OPEN p_cursor FOR
    SELECT CODICE_CONTESTO, CODICE_VOCE
    from RINF_ANAGRAFICHE_EVO.ANAG_CONTESTO_GEO
    where FLAG_PUBBLICO=1;
END GetGeographicContest;
PROCEDURE GetRIMetadata (p_cursor OUT empcur)
IS
BEGIN


         OPEN p_cursor FOR
            SELECT    'Published/Sent Area - '
                   || 'Version: '
                   || v.CODICE_VERSIONE
                   || ' Data/Time: '
                   || TO_CHAR (DATA_TRASMISSIONE, 'DD/MM/YYYY HH24:MI:SS')
                   ||' Protocol: '
                   ||PROTOCOLLO
                      metadato
              FROM RINF_PUBBLICATI_EVO.VERSIONE_RINF v,
              RINF_PUBBLICATI_EVO.ANAGRAFICA_TRASMISSIONI t
             WHERE v.CODICE_VERSIONE = (select MAX(CODICE_VERSIONE) from RINF_PUBBLICATI_EVO.VERSIONE_RINF where  PROTOCOLLO is not null)
             AND t.CODICE_VERSIONE=v.CODICE_VERSIONE
             AND CODICE_TRASMISSIONE=1;

END GetRIMetadata;
END PKG_RINF_PUBBLICO;
/