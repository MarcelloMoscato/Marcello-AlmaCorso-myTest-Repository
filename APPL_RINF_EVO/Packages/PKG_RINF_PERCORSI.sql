--
-- PKG_RINF_PERCORSI  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_PERCORSI" AS
/******************************************************************************
   NAME:       PKG_RINF_GIS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/12/2016   D.Campagiorni    1. Created this package.
******************************************************************************/

  TYPE empcur IS REF CURSOR;
  PROCEDURE SetPercorso(loca_inizio VARCHAR2,loca_fine VARCHAR2,p_tipo_percorso NUMBER,p_error OUT NUMBER);
  PROCEDURE GetPercorso(p_loca_inizio VARCHAR2,p_loca_fine VARCHAR2,p_tipo_percorso NUMBER, p_cursor OUT empcur);
  PROCEDURE GetSOLPercorso(p_loca_inizio VARCHAR2,p_loca_fine VARCHAR2,p_lista_sol CLOB,p_tipo_percorso NUMBER, p_cursor OUT empcur) ;
  PROCEDURE GetPOPercorso(p_loca_inizio VARCHAR2,p_loca_fine VARCHAR2,p_lista_op CLOB, p_tipo_percorso NUMBER,p_cursor OUT empcur);
  PROCEDURE GetInfoPercorso(p_loca_inizio VARCHAR2,p_loca_fine VARCHAR2,p_lista_sol CLOB, p_cursor OUT empcur);
  PROCEDURE GetTipoPercorso(p_cursor OUT empcur);
  PROCEDURE GetCenterPercorso(p_lista_sol CLOB,p_cursor OUT empcur);
  PROCEDURE GetLegendaPercorso(p_tipo_percorso NUMBER,p_cursor OUT empcur);
  PROCEDURE GetTratteUscenti(p_loca_origine VARCHAR2,p_cursor OUT empcur);
 END PKG_RINF_PERCORSI;
/


--
-- PKG_RINF_PERCORSI  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_PERCORSI" AS
--
n_SessionId NUMBER;
n_versione_MDR NUMBER;
--
-- --------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE SetInputData (loca_inizio VARCHAR2,p_tipo_percorso NUMBER)   IS
-- --------------------------------------------------------------------------------------------------------------------------------
--
   BEGIN
      n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(2,PKG_RINF_DATA_V082.GetLastVersion(2));

      Delete From RINF_ANAGRAFICHE_EVO.PERCORSO_MINIMO
          Where SESSION_ID=n_SessionId
          And   CODICE_TIPO=p_tipo_percorso;
--
      Insert Into RINF_ANAGRAFICHE_EVO.PERCORSO_MINIMO (SESSION_ID,
                                                        SEDE_TECNICA,
                                                        PESO,
                                                        PREDECESSORE,
                                                        FLAG_VISITATO,
                                                        CODICE_TIPO)
        Select n_SessionId,
                OR_ID,
                100000000,
                NULL,
                0,
                p_tipo_percorso
           From RINF_GIS_EVO.LOCA_RETE
           Where OR_ID <> loca_inizio
           And   VERSIONE_MDR=n_versione_MDR
         Union
         Select n_SessionId,
                loca_inizio,
                0,
                loca_inizio,
                1,
                p_tipo_percorso
           From Dual;
--
           COMMIT;
   --NOTA: in questa query andranno inseriti i filtri sullo stato utente e di sistema delle località
--
   END SetInputData;
--
-- --------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE SetAggiornaPeso_Lunghezza (nodo_corrente VARCHAR2, peso_cammino NUMBER,p_tipo_percorso NUMBER) IS
-- --------------------------------------------------------------------------------------------------------------------------------
--
      TYPE nodi_connessi_rt IS RECORD
      (
         codice_nodo   VARCHAR2 (6),
         tratta         VARCHAR2 (6),
         lunghezza     NUMBER
      );
--
      TYPE nodi_connessi_t IS TABLE OF nodi_connessi_rt;
--
      l_nodi_connessi   nodi_connessi_t;
--
   BEGIN
     n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(2,PKG_RINF_DATA_V082.GetLastVersion(2));
--
      SELECT nodo_dest codice_nodo, or_id tratta, lunghezza
        BULK COLLECT INTO l_nodi_connessi
        FROM (SELECT TR_ORIG NODO_DEST,OR_ID,
                     DECODE(ABS (TR_SAPPROGIN - TR_SAPPROGOUT),0,TR_LUNGHGEOM*100,ABS (TR_SAPPROGIN - TR_SAPPROGOUT)*100) lunghezza
                FROM RINF_GIS_EVO.TRAT_RETE t
               WHERE TR_DEST = nodo_corrente
               AND t.VERSIONE_MDR=n_versione_MDR
              UNION
              SELECT TR_DEST, OR_ID,DECODE(ABS (TR_SAPPROGIN - TR_SAPPROGOUT),0,TR_LUNGHGEOM*100,ABS (TR_SAPPROGIN - TR_SAPPROGOUT)*100)  lunghezza
                FROM RINF_GIS_EVO.TRAT_RETE t
               WHERE TR_ORIG = nodo_corrente
               AND t.VERSIONE_MDR=n_versione_MDR);

      FORALL i IN 1 .. l_nodi_connessi.COUNT
         UPDATE RINF_ANAGRAFICHE_EVO.PERCORSO_MINIMO
            SET PESO =
                   CASE
                      WHEN peso_cammino + l_nodi_connessi (i).LUNGHEZZA <
                              PESO
                      THEN
                         peso_cammino + l_nodi_connessi (i).LUNGHEZZA
                      ELSE
                         PESO
                   END,
                PREDECESSORE =
                   CASE
                      WHEN peso_cammino + l_nodi_connessi (i).LUNGHEZZA <
                              PESO
                      THEN
                         nodo_corrente
                      ELSE
                         PREDECESSORE
                   END,
              TRATTA=
                   CASE
                      WHEN peso_cammino + l_nodi_connessi (i).LUNGHEZZA <
                              PESO
                      THEN
                         l_nodi_connessi (i).tratta
                      ELSE
                         TRATTA
                   END
          WHERE SEDE_TECNICA = l_nodi_connessi (i).codice_nodo
          AND SESSION_ID=n_SessionId
          AND CODICE_TIPO=p_tipo_percorso;
--
   END SetAggiornaPeso_Lunghezza;
--
-- --------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE SetAggiornaPeso_Rinf (nodo_corrente VARCHAR2, peso_cammino NUMBER,p_tipo_percorso NUMBER)
   IS
-- --------------------------------------------------------------------------------------------------------------------------------
--
      TYPE nodi_connessi_rt IS RECORD
      (
         codice_nodo   VARCHAR2 (6),
         tratta         VARCHAR2 (6),
         lunghezza     NUMBER
      );
--
      TYPE nodi_connessi_t IS TABLE OF nodi_connessi_rt;
--
      l_nodi_connessi   nodi_connessi_t;
      p_versione NUMBER;
--
   BEGIN
--
   p_versione:=PKG_RINF_DATA_V082.GetLastVersion(2);
   n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(2,PKG_RINF_DATA_V082.GetLastVersion(2));

      SELECT nodo_dest codice_nodo, or_id tratta, lunghezza
        BULK COLLECT INTO l_nodi_connessi
        FROM (SELECT TR_ORIG NODO_DEST,OR_ID,
                     DECODE(sede_tecnica,NULL,60000,DECODE(ABS (TR_SAPPROGIN - TR_SAPPROGOUT),0,TR_LUNGHGEOM*100,ABS (TR_SAPPROGIN - TR_SAPPROGOUT)*100) ) lunghezza
                FROM RINF_GIS_EVO.TRAT_RETE t,
                 (select sede_tecnica from RINF_PUBBLICATI_EVO.SEZIONI_LINEA
                 Where CODICE_VERSIONE= p_versione) s
               WHERE TR_DEST = nodo_corrente
               and t.OR_ID=s.SEDE_TECNICA (+)
               AND t.VERSIONE_MDR=n_versione_MDR

              UNION
              SELECT TR_DEST, OR_ID,
              DECODE(sede_tecnica,NULL,60000,DECODE(ABS (TR_SAPPROGIN - TR_SAPPROGOUT),0,TR_LUNGHGEOM*100,ABS (TR_SAPPROGIN - TR_SAPPROGOUT)*100) ) lunghezza
                FROM RINF_GIS_EVO.TRAT_RETE t,
                (select sede_tecnica from RINF_PUBBLICATI_EVO.SEZIONI_LINEA
                 Where CODICE_VERSIONE= p_versione) s
               WHERE TR_ORIG = nodo_corrente
               and t.OR_ID=s.SEDE_TECNICA (+)
               and t.VERSIONE_MDR=n_versione_MDR);

      FORALL i IN 1 .. l_nodi_connessi.COUNT
         UPDATE RINF_ANAGRAFICHE_EVO.PERCORSO_MINIMO
            SET PESO =
                   CASE
                      WHEN peso_cammino + l_nodi_connessi (i).LUNGHEZZA <
                              PESO
                      THEN
                         peso_cammino + l_nodi_connessi (i).LUNGHEZZA
                      ELSE
                         PESO
                   END,
                PREDECESSORE =
                   CASE
                      WHEN peso_cammino + l_nodi_connessi (i).LUNGHEZZA <
                              PESO
                      THEN
                         nodo_corrente
                      ELSE
                         PREDECESSORE
                   END,
              TRATTA=
                   CASE
                      WHEN peso_cammino + l_nodi_connessi (i).LUNGHEZZA <
                              PESO
                      THEN
                         l_nodi_connessi (i).tratta
                      ELSE
                         TRATTA
                   END
          WHERE SEDE_TECNICA = l_nodi_connessi (i).codice_nodo
          AND SESSION_ID=n_SessionId
          AND CODICE_TIPO=p_tipo_percorso;
   END SetAggiornaPeso_Rinf;
--
-- --------------------------------------------------------------------------------------------------------------------------------
      PROCEDURE SetAggiornaPeso_DM43T (nodo_corrente VARCHAR2, peso_cammino NUMBER,p_tipo_percorso NUMBER)
-- --------------------------------------------------------------------------------------------------------------------------------
--
   IS
      TYPE nodi_connessi_rt IS RECORD
      (
         codice_nodo   VARCHAR2 (6),
         tratta         VARCHAR2 (6),
         lunghezza     NUMBER
      );
--
      TYPE nodi_connessi_t IS TABLE OF nodi_connessi_rt;
--
      l_nodi_connessi   nodi_connessi_t;
      p_versione NUMBER;
   BEGIN
--
   p_versione:=PKG_RINF_DATA_V082.GetLastVersion(2);
   n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(2,PKG_RINF_DATA_V082.GetLastVersion(2));
--
      SELECT nodo_dest codice_nodo, or_id tratta, lunghezza
        BULK COLLECT INTO l_nodi_connessi
        FROM (SELECT TR_ORIG NODO_DEST,OR_ID,
                     DECODE(tipo_linea,'A',1,'F',2,'N',3,'C',4,'M',5,DECODE(ABS (TR_SAPPROGIN - TR_SAPPROGOUT),0,TR_LUNGHGEOM*100,ABS (TR_SAPPROGIN - TR_SAPPROGOUT)*100) ) lunghezza
                FROM RINF_GIS_EVO.TRAT_RETE t,
                 (select p.sede_tecnica,substr(CODICE,1,1) tipo_linea from RINF_PUBBLICATI_EVO.SEZIONI_LINEA p,
                 RINF_PUBBLICATI_EVO.V_SOL_CONTESTO_GEOGRAFICO l
                 Where p.CODICE_VERSIONE= p_versione
                 and p.CODICE_VERSIONE=l.CODICE_VERSIONE
                 and p.sede_tecnica= l.sede_tecnica
                 and l.CODICE_CONTESTO=5) s
               WHERE TR_DEST = nodo_corrente
               and t.OR_ID=s.SEDE_TECNICA (+)
               and t.VERSIONE_MDR=n_versione_MDR
              Union
              SELECT TR_DEST, OR_ID,
              DECODE(tipo_linea,'A',1,'F',2,'N',3,'C',4,'M',5,DECODE(ABS (TR_SAPPROGIN - TR_SAPPROGOUT),0,TR_LUNGHGEOM*100,ABS (TR_SAPPROGIN - TR_SAPPROGOUT)*100) ) lunghezza
                FROM RINF_GIS_EVO.TRAT_RETE t,
                (select p.sede_tecnica,substr(CODICE,1,1) tipo_linea from RINF_PUBBLICATI_EVO.SEZIONI_LINEA p,
                 RINF_PUBBLICATI_EVO.V_SOL_CONTESTO_GEOGRAFICO l
                 Where p.CODICE_VERSIONE= p_versione
                 and p.CODICE_VERSIONE=l.CODICE_VERSIONE
                 and p.sede_tecnica= l.sede_tecnica
                 and l.CODICE_CONTESTO=5) s
               WHERE TR_ORIG = nodo_corrente
               and t.OR_ID=s.SEDE_TECNICA (+)
               and t.VERSIONE_MDR=n_versione_MDR);

      FORALL i IN 1 .. l_nodi_connessi.COUNT
         UPDATE RINF_ANAGRAFICHE_EVO.PERCORSO_MINIMO
            SET PESO =
                   CASE
                      WHEN peso_cammino + l_nodi_connessi (i).LUNGHEZZA <
                              PESO
                      THEN
                         peso_cammino + l_nodi_connessi (i).LUNGHEZZA
                      ELSE
                         PESO
                   END,
                PREDECESSORE =
                   CASE
                      WHEN peso_cammino + l_nodi_connessi (i).LUNGHEZZA <
                              PESO
                      THEN
                         nodo_corrente
                      ELSE
                         PREDECESSORE
                   END,
              TRATTA=
                   CASE
                      WHEN peso_cammino + l_nodi_connessi (i).LUNGHEZZA <
                              PESO
                      THEN
                         l_nodi_connessi (i).tratta
                      ELSE
                         TRATTA
                   END
          WHERE SEDE_TECNICA = l_nodi_connessi (i).codice_nodo
          AND SESSION_ID=n_SessionId
          AND CODICE_TIPO=p_tipo_percorso;
--
   END SetAggiornaPeso_DM43T;
--
-- --------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE SetFlagVisitato(nodo_corr VARCHAR2,p_tipo_percorso NUMBER) IS
-- --------------------------------------------------------------------------------------------------------------------------------
--
   BEGIN
--
   UPDATE RINF_ANAGRAFICHE_EVO.PERCORSO_MINIMO
   SET FLAG_VISITATO = 1
   WHERE SEDE_TECNICA = nodo_corr
   AND SESSION_ID=n_SessionId
   AND CODICE_TIPO=p_tipo_percorso;
   END SetFlagVisitato;
   PROCEDURE GetNewNodoCorrente(nodo_corr OUT VARCHAR2,peso_corr OUT NUMBER,p_tipo_percorso NUMBER) IS
   BEGIN
   Select SEDE_TECNICA,PESO into nodo_corr,peso_corr
   FROM RINF_ANAGRAFICHE_EVO.PERCORSO_MINIMO
   WHERE FLAG_VISITATO=0 and
   PESO in
   (select MIN(peso) FROM RINF_ANAGRAFICHE_EVO.PERCORSO_MINIMO
   WHERE FLAG_VISITATO=0 )
   AND SESSION_ID=n_SessionId
   AND CODICE_TIPO=p_tipo_percorso
   and rownum<2;

   IF (nodo_corr is not null) AND (peso_corr<>100000000) THEN
   SetFlagVisitato(nodo_corr,p_tipo_percorso);
   END IF;

   --DBMS_OUTPUT.PUT_LINE ('Flag visitato'||nodo_corr||' ' ||peso_corr);
   END GetNewNodoCorrente;

--
-- --------------------------------------------------------------------------------------------------------------------------------
PROCEDURE SetPercorso (loca_inizio           VARCHAR2,
                       loca_fine             VARCHAR2,
                       p_tipo_percorso       NUMBER,
                       p_error           OUT NUMBER)
IS
-- --------------------------------------------------------------------------------------------------------------------------------
--
   nodo_corr       VARCHAR2 (6);
   peso_corr       NUMBER;
   flag_stop       NUMBER;
   flag_visitato   NUMBER;
BEGIN
   p_error := 0;
   SetInputData (loca_inizio,p_tipo_percorso);
   flag_stop := 0;
   nodo_corr := loca_inizio;
   peso_corr := 0;

   CASE
      WHEN p_tipo_percorso = 1
      THEN
         WHILE (flag_stop = 0 AND p_error < 10000)
         LOOP
            SetAggiornaPeso_Lunghezza (nodo_corr, peso_corr,p_tipo_percorso);
            --DBMS_OUTPUT.PUT_LINE ('Aggiorna peso' || nodo_corr || ' ' || peso_corr);
            GetNewNodoCorrente (nodo_corr, peso_corr,p_tipo_percorso);
            --DBMS_OUTPUT.PUT_LINE ('Get nodo corrente' || nodo_corr || ' ' || peso_corr);


            IF    (nodo_corr IS NULL)
               OR (nodo_corr = loca_fine)
               OR (peso_corr = 100000000)
            THEN
               flag_stop := 1;
            END IF;
--
            p_error := p_error + 1;
         END LOOP;
      WHEN p_tipo_percorso = 2
      THEN
         WHILE (flag_stop = 0 AND p_error < 10000)
         LOOP
            SetAggiornaPeso_Rinf (nodo_corr, peso_corr,p_tipo_percorso);
            --DBMS_OUTPUT.PUT_LINE ('Aggiorna peso' || nodo_corr || ' ' || peso_corr);
            GetNewNodoCorrente (nodo_corr, peso_corr,p_tipo_percorso);
            --DBMS_OUTPUT.PUT_LINE ('Get nodo corrente' || nodo_corr || ' ' || peso_corr);


            IF    (nodo_corr IS NULL)
               OR (nodo_corr = loca_fine)
               OR (peso_corr = 100000000)
            THEN
               flag_stop := 1;
            END IF;



            p_error := p_error + 1;
         END LOOP;
      WHEN p_tipo_percorso = 3
      THEN
         WHILE (flag_stop = 0 AND p_error < 10000)
         LOOP
            SetAggiornaPeso_DM43T (nodo_corr, peso_corr,p_tipo_percorso);
            --DBMS_OUTPUT.PUT_LINE ('Aggiorna peso' || nodo_corr || ' ' || peso_corr);
            GetNewNodoCorrente (nodo_corr, peso_corr,p_tipo_percorso);
            --DBMS_OUTPUT.PUT_LINE ('Get nodo corrente' || nodo_corr || ' ' || peso_corr);


            IF    (nodo_corr IS NULL)
               OR (nodo_corr = loca_fine)
               OR (peso_corr = 100000000)
            THEN
               flag_stop := 1;
            END IF;



            p_error := p_error + 1;
         END LOOP;
   END CASE;

   COMMIT;
END SetPercorso;
--
-- --------------------------------------------------------------------------------------------------------------------------------
PROCEDURE GetPercorso(p_loca_inizio VARCHAR2,p_loca_fine VARCHAR2,p_tipo_percorso NUMBER, p_cursor OUT empcur) IS
-- --------------------------------------------------------------------------------------------------------------------------------
--
p_error  NUMBER;
n_righe  NUMBER;

   BEGIN
   n_SessionId:=USERENV('sessionid');

   --14/11/2017 Per la Storicizzazione del MDR GIS è necessario individuare la versione del MDR GIS corrispondente all'ultimo RI Pubblicato/Inviato
   n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(2,PKG_RINF_DATA_V082.GetLastVersion(2));

   SetPercorso(p_loca_inizio,p_loca_fine,p_tipo_percorso,p_error);

   SELECT count(*) INTO n_righe
   FROM (SELECT p_loca_inizio LOCA_INIZIO,
           LOCA_FINE,
           N_NODI,
           LO_PERCORSO,
           SUBSTR(TR_PERCORSO,5) TR_PERCORSO
      FROM (    SELECT SEDE_TECNICA LOCA_FINE,
                       LEVEL N_NODI,
                       SUBSTR(SYS_CONNECT_BY_PATH (''''||SEDE_TECNICA||'''', ','),2) LO_PERCORSO,
                       SUBSTR(SYS_CONNECT_BY_PATH (''''||TRATTA||'''', ','),1) TR_PERCORSO
                  FROM RINF_ANAGRAFICHE_EVO.PERCORSO_MINIMO
                 WHERE FLAG_VISITATO = 1
                 AND SESSION_ID=n_SessionId
            START WITH SEDE_TECNICA = p_loca_inizio
            CONNECT BY NOCYCLE PRIOR SEDE_TECNICA = PREDECESSORE)
    WHERE LOCA_FINE = p_loca_fine);

   DBMS_OUTPUT.PUT_LINE ( 'p_error: '||  p_error);
   DBMS_OUTPUT.PUT_LINE ( 'n_righe: '||  n_righe);

   IF p_error<10000 AND n_righe>0 THEN
   OPEN p_cursor FOR
    SELECT p_loca_inizio LOCA_INIZIO,
           LOCA_FINE,
           N_NODI,
           LO_PERCORSO,
           SUBSTR(TR_PERCORSO,5) TR_PERCORSO
      FROM (    SELECT SEDE_TECNICA LOCA_FINE,
                       LEVEL N_NODI,
                       SUBSTR(SYS_CONNECT_BY_PATH (''''||SEDE_TECNICA||'''', ','),2) LO_PERCORSO,
                       SUBSTR(SYS_CONNECT_BY_PATH (''''||TRATTA||'''', ','),1) TR_PERCORSO
                  FROM RINF_ANAGRAFICHE_EVO.PERCORSO_MINIMO
                 WHERE FLAG_VISITATO = 1
                 AND SESSION_ID=n_SessionId
            START WITH SEDE_TECNICA = p_loca_inizio
            CONNECT BY NOCYCLE PRIOR SEDE_TECNICA = PREDECESSORE)
    WHERE LOCA_FINE = p_loca_fine;
    ELSE
    OPEN p_cursor FOR
      SELECT
        NULL LOCA_INIZIO,
        NULL LOCA_FINE,
        NULL N_NODI,
        NULL LO_PERCORSO,
        NULL TR_PERCORSO
        from dual;
    END IF;
--
   DELETE FROM RINF_ANAGRAFICHE_EVO.PERCORSO_MINIMO
   WHERE SESSION_ID=n_SessionId
   AND CODICE_TIPO=p_tipo_percorso;
--
   COMMIT;
--
   END GetPercorso;
--
-- --------------------------------------------------------------------------------------------------------------------------------
PROCEDURE GetSOLPercorso(p_loca_inizio VARCHAR2,p_loca_fine VARCHAR2,p_lista_sol CLOB, p_tipo_percorso NUMBER, p_cursor OUT empcur) IS
-- --------------------------------------------------------------------------------------------------------------------------------
--
 p_lista_1000 CLOB;
 p_lista_2000 CLOB;
 p_lista_3000 CLOB;
 p_versione NUMBER;
 sqlstringa VARCHAR2(30000);
--
BEGIN
--
-- ---------------------------------------------------------------------------------------
PKG_RINF_WORK_UTILITY.GetStringhe1000( p_lista_sol,p_lista_1000, p_lista_2000,p_lista_3000 );
-- ---------------------------------------------------------------------------------------
--
  p_versione:=PKG_RINF_DATA_V082.GetLastVersion(2);
  n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(2,PKG_RINF_DATA_V082.GetLastVersion(2));
--
  sqlstringa:='SELECT  T.OR_ID SEDE_TECNICA,  ';
  sqlstringa:=sqlstringa||' DECODE(ABS (TR_SAPPROGIN - TR_SAPPROGOUT),0,TR_LUNGHGEOM,ABS (TR_SAPPROGIN - TR_SAPPROGOUT))  VALORE, ';
  sqlstringa:=sqlstringa||' T.OR_ID||'' ''||TR_DESCRIZIONE ||'' lunghezza:''||TO_CHAR(DECODE(ABS (TR_SAPPROGIN - TR_SAPPROGOUT),0,TR_LUNGHGEOM,ABS (TR_SAPPROGIN - TR_SAPPROGOUT)) ,''9990.999'')||'' km'' TOOLTIP, ';
  sqlstringa:=sqlstringa||' NULL ETICHETTA, ';
  sqlstringa:=sqlstringa||'PKG_RINF_GIS_V2.FNC_GET_VERTEX(SDO_UTIL.SIMPLIFY(to_2d(t.GEOMETRY),1.5)) COORD_PUNTI, ';
  sqlstringa:=sqlstringa||' DECODE(s.SEDE_TECNICA,NULL,COLORE_NO_RINF,COLORE_RINF) COLORE ';
  sqlstringa:=sqlstringa||'   FROM ';
  sqlstringa:=sqlstringa||'RINF_GIS_EVO.TRAT_RETE T,  ';
  sqlstringa:=sqlstringa||'(select SEDE_TECNICA FROM RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
  sqlstringa:=sqlstringa||' where CODICE_VERSIONE='||p_versione||' ) S, ';
  sqlstringa:=sqlstringa||'RINF_ANAGRAFICHE_EVO.ANAG_TIPO_PERCORSO C ';
  sqlstringa:=sqlstringa||'WHERE ';
  sqlstringa:=sqlstringa||' C.CODICE_TIPO= '||p_tipo_percorso;
  sqlstringa:=sqlstringa||' and T.OR_ID=s.SEDE_TECNICA (+) ';
  sqlstringa:=sqlstringa||' and t.VERSIONE_MDR='||n_versione_MDR;
  sqlstringa:=sqlstringa||' and ( ';
  sqlstringa:=sqlstringa||' t.OR_ID IN ('||p_lista_1000||') ';
--
  IF p_lista_2000 IS NOT NULL THEN
  sqlstringa:=sqlstringa||' OR t.OR_ID IN ('||p_lista_2000||') ';
      IF p_lista_3000 IS NOT NULL THEN
        sqlstringa:=sqlstringa||' OR t.OR_ID IN ('||p_lista_3000||') ';
      END IF;
  END IF;
--
  sqlstringa:=sqlstringa||' )';
--
--  DBMS_OUTPUT.PUT_LINE(sqlstringa);
--
  OPEN p_cursor FOR sqlstringa;
--
  END GetSOLPercorso;
--
-- ---------------------------------------------------------------------------------------
  PROCEDURE GetPOPercorso(p_loca_inizio VARCHAR2,p_loca_fine VARCHAR2,p_lista_op CLOB, p_tipo_percorso NUMBER,p_cursor OUT empcur) IS
-- ---------------------------------------------------------------------------------------
--
   p_lista_1000 CLOB;
   p_lista_2000 CLOB;
   p_lista_3000 CLOB;
   p_versione NUMBER;
   sqlstringa VARCHAR2(30000);
--
  BEGIN
  n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(2,PKG_RINF_DATA_V082.GetLastVersion(2));
  PKG_RINF_WORK_UTILITY.GetStringhe1000( p_lista_op,p_lista_1000, p_lista_2000,p_lista_3000 );
--
  p_versione:=PKG_RINF_DATA_V082.GetLastVersion(2);
--
  sqlstringa:='SELECT  T.OR_ID SEDE_TECNICA,  ';
  sqlstringa:=sqlstringa||' NULL VALORE, ';
  sqlstringa:=sqlstringa||' T.OR_ID||'' ''||LO_DESCRIZIONE TOOLTIP, ';
  sqlstringa:=sqlstringa||' NULL ETICHETTA, ';
  sqlstringa:=sqlstringa||'  L_G.X      AS Xwgs, ';
  sqlstringa:=sqlstringa||'  L_G.Y      AS Ywgs, ';
  sqlstringa:=sqlstringa||' DECODE(s.SEDE_TECNICA,NULL,COLORE_NO_RINF,COLORE_RINF) COLORE ';
  sqlstringa:=sqlstringa||'   FROM ';
  sqlstringa:=sqlstringa||'RINF_GIS_EVO.LOCA_RETE T,  ';
  sqlstringa:=sqlstringa||'(select SEDE_TECNICA FROM RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI ';
  sqlstringa:=sqlstringa||' where CODICE_VERSIONE='||p_versione||' ) S, ';
  sqlstringa:=sqlstringa||'TABLE(SDO_UTIL.GETVERTICES(T.GEOMETRY)) L_G, ';
  sqlstringa:=sqlstringa||'RINF_ANAGRAFICHE_EVO.ANAG_TIPO_PERCORSO C ';
  sqlstringa:=sqlstringa||'WHERE ';
  sqlstringa:=sqlstringa||' C.CODICE_TIPO= '||p_tipo_percorso;
  sqlstringa:=sqlstringa||' and T.OR_ID=s.SEDE_TECNICA (+) ';
  sqlstringa:=sqlstringa||' and T.VERSIONE_MDR= '||n_versione_MDR;
  sqlstringa:=sqlstringa||' and ( ';
  sqlstringa:=sqlstringa||' t.OR_ID IN ('||p_lista_1000||') ';
--
  IF p_lista_2000 IS NOT NULL THEN
  sqlstringa:=sqlstringa||' OR t.OR_ID IN ('||p_lista_2000||') ';
      IF p_lista_3000 IS NOT NULL THEN
        sqlstringa:=sqlstringa||' OR t.OR_ID IN ('||p_lista_3000||') ';
      END IF;
  END IF;
--
  sqlstringa:=sqlstringa||' )';
--DBMS_OUTPUT.PUT_LINE(sqlstringa);
--
  OPEN p_cursor FOR sqlstringa;
--
END GetPOPercorso;
--
-- ---------------------------------------------------------------------------------------------------------
PROCEDURE GetInfoPercorso(p_loca_inizio VARCHAR2,p_loca_fine VARCHAR2,p_lista_sol CLOB, p_cursor OUT empcur) IS
-- ---------------------------------------------------------------------------------------------------------
   p_lista_1000 CLOB;
   p_lista_2000 CLOB;
   p_lista_3000 CLOB;
   p_versione NUMBER;
   sqlstringa VARCHAR2(30000);
--
  BEGIN
     n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(2,PKG_RINF_DATA_V082.GetLastVersion(2));
--
  IF p_lista_sol IS NOT NULL THEN
     PKG_RINF_WORK_UTILITY.GetStringhe1000( p_lista_sol,p_lista_1000, p_lista_2000,p_lista_3000 );
--
     p_versione:=PKG_RINF_DATA_V082.GetLastVersion(2);
--
     sqlstringa:= 'select 0 prog, ';
     sqlstringa:=sqlstringa||'li.OR_ID||'' ''||li.LO_DESCRIZIONE INIZIO_PERCORSO,lf.OR_ID||'' ''||lf.LO_DESCRIZIONE FINE_PERCORSO, ';
     sqlstringa:=sqlstringa||'ROUND(SUM(DECODE(ABS (TR_SAPPROGIN - TR_SAPPROGOUT),0,TR_LUNGHGEOM,ABS (TR_SAPPROGIN - TR_SAPPROGOUT)) ),3) lunghezza,COUNT(t.OR_ID) numero_tratte,SUM(DECODE(SEDE_TECNICA,NULL,0,1)) numero_tratte_rinf ';
     sqlstringa:=sqlstringa||'from ';
     sqlstringa:=sqlstringa||'RINF_GIS_EVO.TRAT_RETE t, ';
     sqlstringa:=sqlstringa||'(select sede_tecnica from RINF_PUBBLICATI_EVO.SEZIONI_LINEA  ';
     sqlstringa:=sqlstringa||'where codice_versione='||p_versione||') s, ';
     sqlstringa:=sqlstringa||'(SELECT OR_ID,LO_DESCRIZIONE ';
     sqlstringa:=sqlstringa||'FROM RINF_GIS_EVO.LOCA_RETE ';
     sqlstringa:=sqlstringa||' WHERE VERSIONE_MDR= '||n_versione_MDR;
     sqlstringa:=sqlstringa||' and OR_ID='''||p_loca_inizio||''') li, ';
     sqlstringa:=sqlstringa||'(SELECT OR_ID,LO_DESCRIZIONE ';
     sqlstringa:=sqlstringa||'FROM RINF_GIS_EVO.LOCA_RETE ';
     sqlstringa:=sqlstringa||' WHERE VERSIONE_MDR= '||n_versione_MDR;
     sqlstringa:=sqlstringa||' and OR_ID='''||p_loca_fine||''') lf ';
     sqlstringa:=sqlstringa||'WHERE ';
     sqlstringa:=sqlstringa||'t.OR_ID=s.SEDE_TECNICA (+) ';
     sqlstringa:=sqlstringa||' and VERSIONE_MDR= '||n_versione_MDR;
     sqlstringa:=sqlstringa||' and T.OR_ID=s.SEDE_TECNICA (+) ';
     sqlstringa:=sqlstringa||' and ( ';
     sqlstringa:=sqlstringa||' t.OR_ID IN ('||p_lista_1000||') ';
--
     IF p_lista_2000 IS NOT NULL THEN
         sqlstringa:=sqlstringa||' OR t.OR_ID IN ('||p_lista_2000||') ';
         IF p_lista_3000 IS NOT NULL THEN
           sqlstringa:=sqlstringa||' OR t.OR_ID IN ('||p_lista_3000||') ';
         END IF;
--
     END IF;
--
     sqlstringa:=sqlstringa||' )';
     sqlstringa:=sqlstringa||'GROUP BY li.OR_ID||'' ''||li.LO_DESCRIZIONE,lf.OR_ID||'' ''||lf.LO_DESCRIZIONE';
     sqlstringa:=sqlstringa||' UNION';
     sqlstringa:=sqlstringa||' SELECT  lista.prog, ';
     sqlstringa:=sqlstringa||'OR_ID|| '' ''|| DECODE (SEDE_TECNICA, NULL, TR_DESCRIZIONE, DEFINIZIONE) DEFINIZIONE,';
     sqlstringa:=sqlstringa||'        TR_ORIG || '' - '' || TR_DEST,                                                     ';
     sqlstringa:=sqlstringa||'        DECODE (SEDE_TECNICA,NULL, DECODE(ABS (TR_SAPPROGIN - TR_SAPPROGOUT),0,ROUND(TR_LUNGHGEOM,3),ROUND(ABS (TR_SAPPROGIN - TR_SAPPROGOUT),3)) , SOL_1_1_0_0_0_5),     ';
     sqlstringa:=sqlstringa||'        1,                                                                                   ';
     sqlstringa:=sqlstringa||'        DECODE (SEDE_TECNICA, NULL, 0, 1)                                                    ';
     sqlstringa:=sqlstringa||'   FROM RINF_GIS_EVO.TRAT_RETE t,                                                    ';
     sqlstringa:=sqlstringa||'        (SELECT SEDE_TECNICA, DEFINIZIONE, SOL_1_1_0_0_0_5                                   ';
     sqlstringa:=sqlstringa||'           FROM RINF_PUBBLICATI_EVO.SEZIONI_LINEA                                            ';
     sqlstringa:=sqlstringa||'          WHERE CODICE_VERSIONE = '||p_versione||') s,                                        ';
     sqlstringa:=sqlstringa||' (with temp as                    ';
     sqlstringa:=sqlstringa||' (select '''||replace(p_lista_sol,'''','')||'''';
     sqlstringa:=sqlstringa||' tratta                                        ';
     sqlstringa:=sqlstringa||' from dual)                                    ';
     sqlstringa:=sqlstringa||' select distinct                               ';
     sqlstringa:=sqlstringa||'  rownum prog,                                 ';
     sqlstringa:=sqlstringa||'  trim(regexp_substr(t.tratta, ''[^,]+'', 1, levels.column_value))  as tratta ';
     sqlstringa:=sqlstringa||' from         ';
     sqlstringa:=sqlstringa||'  temp t,      ';
     sqlstringa:=sqlstringa||'  table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.tratta, ''[^,]+''))  + 1) as sys.OdciNumberList)) levels  ';
     sqlstringa:=sqlstringa||' order by prog) lista ';
     sqlstringa:=sqlstringa||'  WHERE t.OR_ID = s.SEDE_TECNICA(+) ';
     sqlstringa:=sqlstringa||' and t.VERSIONE_MDR= '||n_versione_MDR;
     sqlstringa:=sqlstringa||' and t.OR_ID =lista.tratta ';
     sqlstringa:=sqlstringa||' order by prog ';
  ELSE
     sqlstringa:= 'select 0 prog, ';
     sqlstringa:=sqlstringa||'li.OR_ID||'' ''||li.LO_DESCRIZIONE INIZIO_PERCORSO,lf.OR_ID||'' ''||lf.LO_DESCRIZIONE FINE_PERCORSO, ';
     sqlstringa:=sqlstringa||'0 lunghezza,0 numero_tratte,0 numero_tratte_rinf ';
     sqlstringa:=sqlstringa||'from ';
     sqlstringa:=sqlstringa||'RINF_GIS_EVO.LOCA_RETE li,  ';
     sqlstringa:=sqlstringa||'RINF_GIS_EVO.LOCA_RETE lf ';
     sqlstringa:=sqlstringa||' WHERE li.OR_ID='''||p_loca_inizio||'''';
     sqlstringa:=sqlstringa||' AND lf.OR_ID='''||p_loca_fine||'''';
     sqlstringa:=sqlstringa||' AND li.VERSIONE_MDR= '||n_versione_MDR;
     sqlstringa:=sqlstringa||' AND lf.VERSIONE_MDR= '||n_versione_MDR;
  END IF;
--
  DBMS_OUTPUT.PUT_LINE(sqlstringa);
--
  OPEN p_cursor FOR sqlstringa;
--
END GetInfoPercorso;
--
-- ---------------------------------------------------------------------------------------
PROCEDURE GetTipoPercorso(p_cursor OUT empcur) IS
-- ---------------------------------------------------------------------------------------
  BEGIN
--
  OPEN p_cursor FOR
    SELECT CODICE_TIPO CODICE, DEFINIZIONE DESCRIZIONE
    FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_PERCORSO;
 --
END GetTipoPercorso;

-- ---------------------------------------------------------------------------------------
PROCEDURE GetCenterPercorso(p_lista_sol CLOB,p_cursor OUT empcur) IS
-- ---------------------------------------------------------------------------------------
sqlstringa VARCHAR2(30000);
--
 BEGIN
   n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(2,PKG_RINF_DATA_V082.GetLastVersion(2));
--
   sqlstringa:=' SELECT SDO_GEOM.SDO_MIN_MBR_ORDINATE (bb.GEOMETRY, 1) X1, ';
   sqlstringa:=sqlstringa||'  SDO_GEOM.SDO_MIN_MBR_ORDINATE (bb.GEOMETRY, 2) Y1,        ';
   sqlstringa:=sqlstringa||'  SDO_GEOM.SDO_MAX_MBR_ORDINATE (bb.GEOMETRY, 1) X2,        ';
   sqlstringa:=sqlstringa||'  SDO_GEOM.SDO_MAX_MBR_ORDINATE (bb.GEOMETRY, 2) Y2         ';
   sqlstringa:=sqlstringa||'  FROM (SELECT SDO_GEOM.SDO_BUFFER (SDO_AGGR_MBR (t.GEOMETRY), 100, 0.5) geometry';
   sqlstringa:=sqlstringa||'  FROM RINF_GIS_EVO.TRAT_RETE T ';
   sqlstringa:=sqlstringa||'  WHERE t.VERSIONE_MDR= '||n_versione_MDR;
   sqlstringa:=sqlstringa||'  AND T.OR_ID in ('||p_lista_sol||')) bb   ';
   OPEN p_cursor FOR sqlstringa;
--
END GetCenterPercorso;
--
-- ---------------------------------------------------------------------------------------
PROCEDURE GetLegendaPercorso(p_tipo_percorso NUMBER,p_cursor OUT empcur) IS
-- ---------------------------------------------------------------------------------------
BEGIN
--
OPEN p_cursor FOR
    SELECT CODICE_TIPO CODICE,'Dati RINF' VALORE, COLORE_RINF COLORE
      FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_PERCORSO
      WHERE CODICE_TIPO=p_tipo_percorso
    UNION
    SELECT CODICE_TIPO CODICE,'Dati RINF non disponibili' VALORE, COLORE_NO_RINF COLORE
      FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_PERCORSO
      WHERE CODICE_TIPO=p_tipo_percorso;
END GetLegendaPercorso;
--
-- ---------------------------------------------------------------------------------------
PROCEDURE GetTratteUscenti(p_loca_origine VARCHAR2,p_cursor OUT empcur) IS
-- ---------------------------------------------------------------------------------------
p_versione NUMBER;
--
BEGIN
   p_versione:=PKG_RINF_DATA_V082.GetLastVersion(2);
   n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(2,PKG_RINF_DATA_V082.GetLastVersion(2));
--
 OPEN p_cursor FOR
    SELECT t.OR_ID SEDE_TECNICA,
           DECODE (SEDE_TECNICA, NULL, TR_DESCRIZIONE, DEFINIZIONE) DEFINIZIONE,
           CASE WHEN TR_ORIG = p_loca_origine THEN TR_DEST ELSE TR_ORIG END
               LOCA_DEST,
              'Km '
           || DECODE (SEDE_TECNICA,
                      NULL, DECODE(ABS (TR_SAPPROGIN - TR_SAPPROGOUT),0,TR_LUNGHGEOM*100,ABS (TR_SAPPROGIN - TR_SAPPROGOUT)*100) ,
                      SOL_1_1_0_0_0_5)
           || ' - '
           || DECODE (SEDE_TECNICA, NULL, 'No Dati RINF', 'Dati RINF')
              ETICHETTA,
            LO_DESCRIZIONE DESC_LOCA_DEST
      FROM RINF_GIS_EVO.TRAT_RETE t,
           (SELECT SEDE_TECNICA, DEFINIZIONE, SOL_1_1_0_0_0_5
              FROM RINF_PUBBLICATI_EVO.SEZIONI_LINEA
             WHERE CODICE_VERSIONE = p_versione) s,
             RINF_GIS_EVO.LOCA_RETE l
      WHERE     t.OR_ID = s.SEDE_TECNICA(+)
           AND t.VERSIONE_MDR=n_versione_MDR
           AND l.VERSIONE_MDR=n_versione_MDR
           AND (TR_ORIG = p_loca_origine OR TR_DEST = p_loca_origine)
           AND DECODE(TR_ORIG,p_loca_origine,TR_DEST,TR_ORIG)=l.OR_ID;
--
END GetTratteUscenti;
--
END PKG_RINF_PERCORSI;
/