--
-- V_ERRORI_UTENTE  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.V_ERRORI_UTENTE
(CODICE_ACQUISIZIONE, CODICE_UTENTE, ID_UTENTE, COGNOME, NOME, 
 E_MAIL, FLAG_MAIL, CODICE_DTP, DTP, TIPO_OGGETTO, 
 ERRORI_GEN, ERRORI_INF, ERRORI_ENE, ERRORI_CCS, TOTALE_ERRORI)
BEQUEATH DEFINER
AS 
SELECT CODICE_ACQUISIZIONE,
            CODICE_UTENTE,
            ID_UTENTE,
            COGNOME,
            NOME,
            E_MAIL,
            FLAG_MAIL,
            CODICE_DTP,
            DTP,
            TIPO_OGGETTO,
            SUM (ERRORI_GEN) ERRORI_GEN,
            SUM (ERRORI_INF) ERRORI_INF,
            SUM (ERRORI_ENE) ERRORI_ENE,
            SUM (ERRORI_CCS) ERRORI_CCS,
            SUM (TOTALE_ERRORI) TOTALE_ERRORI
       FROM (  SELECT H.CODICE_ACQUISIZIONE,
                      R.CODICE_UTENTE,
                      ID_UTENTE,
                      R.COGNOME,
                      R.NOME,
                      R.E_MAIL,
                      R.FLAG_MAIL,
                      D.CODICE_DTP,
                      D.DESCRIZIONE DTP,
                      DECODE (SUBSTR (C.CODICE_SOL_PO, 1, 2),
                              'TR', 'Sezione di Linea',
                              'Punto Operativo')
                         TIPO_OGGETTO,
                      SUM (NVL (ERRORI_GEN, 0)) ERRORI_GEN,
                      SUM (NVL (ERRORI_INF, 0)) ERRORI_INF,
                      SUM (NVL (ERRORI_ENE, 0)) ERRORI_ENE,
                      SUM (NVL (ERRORI_CCS, 0)) ERRORI_CCS,
                      SUM (
                           NVL (ERRORI_GEN, 0)
                         + NVL (ERRORI_INF, 0)
                         + NVL (ERRORI_ENE, 0)
                         + NVL (ERRORI_CCS, 0))
                         TOTALE_ERRORI
                 FROM (SELECT DISTINCT CODICE_CONTROLLO,
                                       CODICE_SOL_PO,
                                       CODICE_DTP,
                                       SIGLA_TIPO_DEPOSITARIO
                         FROM V_DETT_CONTROLLI_FALLITI_V082) C,
                      RINF_ANAGRAFICHE_EVO.ANAG_DTP D,
                      RINF_SICUREZZA_EVO.V_UTENTE_RUOLO R,
                      RINF_LAVORAZIONE_EVO.CONTROLLO_DATI H,
                      (  SELECT CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO,
                                --DATA_ACQUISIZIONE_ERRATO,
                                COUNT (*) ERRORI_GEN
                           FROM V_DETT_CONTROLLI_FALLITI_V082
                          WHERE SIGLA_VISTA = 'GEN'
                       GROUP BY CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO --, DATA_ACQUISIZIONE_ERRATO
                                                      ) ERR_GEN,
                      (  SELECT CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO,
                                --DATA_ACQUISIZIONE_ERRATO,
                                COUNT (*) ERRORI_INF
                           FROM V_DETT_CONTROLLI_FALLITI_V082
                          WHERE SIGLA_VISTA = 'INF'
                       GROUP BY CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO --, DATA_ACQUISIZIONE_ERRATO
                                                      ) ERR_INF,
                      (  SELECT CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO,
                                --DATA_ACQUISIZIONE_ERRATO,
                                COUNT (*) ERRORI_ENE
                           FROM V_DETT_CONTROLLI_FALLITI_V082
                          WHERE SIGLA_VISTA = 'ENE'
                       GROUP BY CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO --, DATA_ACQUISIZIONE_ERRATO
                                                      ) ERR_ENE,
                      (  SELECT CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO,
                                --, DATA_ACQUISIZIONE_ERRATO,
                                COUNT (*) ERRORI_CCS
                           FROM V_DETT_CONTROLLI_FALLITI_V082
                          WHERE SIGLA_VISTA = 'CCS'
                       GROUP BY CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO --, DATA_ACQUISIZIONE_ERRATO
                                                      ) ERR_CCS
                WHERE     D.CODICE_DTP = C.CODICE_DTP
                      AND C.CODICE_CONTROLLO = H.CODICE_CONTROLLO
                      AND C.CODICE_CONTROLLO = ERR_GEN.CODICE_CONTROLLO(+)
                      AND C.CODICE_SOL_PO = ERR_GEN.CODICE_SOL_PO(+)
                      AND C.SIGLA_TIPO_DEPOSITARIO =
                             ERR_GEN.SIGLA_TIPO_DEPOSITARIO(+)
                      AND C.CODICE_CONTROLLO = ERR_INF.CODICE_CONTROLLO(+)
                      AND C.CODICE_SOL_PO = ERR_INF.CODICE_SOL_PO(+)
                      AND C.SIGLA_TIPO_DEPOSITARIO =
                             ERR_INF.SIGLA_TIPO_DEPOSITARIO(+)
                      AND C.CODICE_CONTROLLO = ERR_ENE.CODICE_CONTROLLO(+)
                      AND C.CODICE_SOL_PO = ERR_ENE.CODICE_SOL_PO(+)
                      AND C.SIGLA_TIPO_DEPOSITARIO =
                             ERR_ENE.SIGLA_TIPO_DEPOSITARIO(+)
                      AND C.CODICE_CONTROLLO = ERR_CCS.CODICE_CONTROLLO(+)
                      AND C.CODICE_SOL_PO = ERR_CCS.CODICE_SOL_PO(+)
                      AND C.SIGLA_TIPO_DEPOSITARIO =
                             ERR_CCS.SIGLA_TIPO_DEPOSITARIO(+)
                      AND R.SIGLA_TIPO_DEPOSITARIO = C.SIGLA_TIPO_DEPOSITARIO
                      AND R.CODICE_RUOLO = 4 --solo depositari (vengono esclusi i validatori)
                      AND D.CODICE_DTP =
                             DECODE (R.CODICE_DTP,
                                     '-1', D.CODICE_DTP,
                                     R.CODICE_DTP) --con questa join vengono inclusi anche i parametri di sede centrale, che hanno dtp=-1
                      AND   NVL (ERRORI_GEN, 0)
                          + NVL (ERRORI_INF, 0)
                          + NVL (ERRORI_ENE, 0)
                          + NVL (ERRORI_CCS, 0) > 0
                      --AND CODICE_ACQUISIZIONE = 4 and ID_UTENTE = 182
                      AND R.CODICE_UT = '-1' --sono esclusi i depositari ut, include i dati di sede centrale e di dtp
             GROUP BY H.CODICE_ACQUISIZIONE,
                      R.CODICE_UTENTE,
                      R.ID_UTENTE,
                      R.COGNOME,
                      R.NOME,
                      R.E_MAIL,
                      R.FLAG_MAIL,
                      D.CODICE_DTP,
                      D.DESCRIZIONE,
                      DECODE (SUBSTR (C.CODICE_SOL_PO, 1, 2),
                              'TR', 'Sezione di Linea',
                              'Punto Operativo')
             UNION
               SELECT H.CODICE_ACQUISIZIONE,
                      R.CODICE_UTENTE,
                      ID_UTENTE,
                      R.COGNOME,
                      R.NOME,
                      R.E_MAIL,
                      R.FLAG_MAIL,
                      D.CODICE_DTP,
                      D.DESCRIZIONE DTP,
                      DECODE (SUBSTR (C.CODICE_SOL_PO, 1, 2),
                              'TR', 'Sezione di Linea',
                              'Punto Operativo')
                         TIPO_OGGETTO,
                      SUM (NVL (ERRORI_GEN, 0)) ERRORI_GEN,
                      SUM (NVL (ERRORI_INF, 0)) ERRORI_INF,
                      SUM (NVL (ERRORI_ENE, 0)) ERRORI_ENE,
                      SUM (NVL (ERRORI_CCS, 0)) ERRORI_CCS,
                      SUM (
                           NVL (ERRORI_GEN, 0)
                         + NVL (ERRORI_INF, 0)
                         + NVL (ERRORI_ENE, 0)
                         + NVL (ERRORI_CCS, 0))
                         TOTALE_ERRORI
                 FROM (SELECT DISTINCT CODICE_CONTROLLO,
                                       CODICE_SOL_PO,
                                       CODICE_DTP,
                                       CODICE_UT,
                                       SIGLA_TIPO_DEPOSITARIO
                         FROM V_DETT_CONTROLLI_FALLITI_V082 c,
                              (SELECT CODICE_UT, SEDE_TECNICA
                                 FROM RINF_LAVORAZIONE_EVO.SEZIONI_LINEA
                               UNION
                               SELECT CODICE_UT, SEDE_TECNICA
                                 FROM RINF_LAVORAZIONE_EVO.PUNTI_OPERATIVI) ut
                        WHERE ut.sede_tecnica = c.CODICE_SOL_PO) C,
                      RINF_ANAGRAFICHE_EVO.ANAG_DTP D,
                      RINF_SICUREZZA_EVO.V_UTENTE_RUOLO R,
                      RINF_LAVORAZIONE_EVO.CONTROLLO_DATI H,
                      (  SELECT CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO,
                                --DATA_ACQUISIZIONE_ERRATO,
                                COUNT (*) ERRORI_GEN
                           FROM V_DETT_CONTROLLI_FALLITI_V082
                          WHERE SIGLA_VISTA = 'GEN'
                       GROUP BY CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO --, DATA_ACQUISIZIONE_ERRATO
                                                      ) ERR_GEN,
                      (  SELECT CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO,
                                --DATA_ACQUISIZIONE_ERRATO,
                                COUNT (*) ERRORI_INF
                           FROM V_DETT_CONTROLLI_FALLITI_V082
                          WHERE SIGLA_VISTA = 'INF'
                       GROUP BY CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO --, DATA_ACQUISIZIONE_ERRATO
                                                      ) ERR_INF,
                      (  SELECT CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO,
                                --DATA_ACQUISIZIONE_ERRATO,
                                COUNT (*) ERRORI_ENE
                           FROM V_DETT_CONTROLLI_FALLITI_V082
                          WHERE SIGLA_VISTA = 'ENE'
                       GROUP BY CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO --, DATA_ACQUISIZIONE_ERRATO
                                                      ) ERR_ENE,
                      (  SELECT CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO,
                                --, DATA_ACQUISIZIONE_ERRATO,
                                COUNT (*) ERRORI_CCS
                           FROM V_DETT_CONTROLLI_FALLITI_V082
                          WHERE SIGLA_VISTA = 'CCS'
                       GROUP BY CODICE_CONTROLLO,
                                CODICE_SOL_PO,
                                SIGLA_VISTA,
                                SIGLA_TIPO_DEPOSITARIO --, DATA_ACQUISIZIONE_ERRATO
                                                      ) ERR_CCS
                WHERE     D.CODICE_DTP = C.CODICE_DTP
                      AND C.CODICE_CONTROLLO = H.CODICE_CONTROLLO
                      AND C.CODICE_CONTROLLO = ERR_GEN.CODICE_CONTROLLO(+)
                      AND C.CODICE_SOL_PO = ERR_GEN.CODICE_SOL_PO(+)
                      AND C.SIGLA_TIPO_DEPOSITARIO =
                             ERR_GEN.SIGLA_TIPO_DEPOSITARIO(+)
                      AND C.CODICE_CONTROLLO = ERR_INF.CODICE_CONTROLLO(+)
                      AND C.CODICE_SOL_PO = ERR_INF.CODICE_SOL_PO(+)
                      AND C.SIGLA_TIPO_DEPOSITARIO =
                             ERR_INF.SIGLA_TIPO_DEPOSITARIO(+)
                      AND C.CODICE_CONTROLLO = ERR_ENE.CODICE_CONTROLLO(+)
                      AND C.CODICE_SOL_PO = ERR_ENE.CODICE_SOL_PO(+)
                      AND C.SIGLA_TIPO_DEPOSITARIO =
                             ERR_ENE.SIGLA_TIPO_DEPOSITARIO(+)
                      AND C.CODICE_CONTROLLO = ERR_CCS.CODICE_CONTROLLO(+)
                      AND C.CODICE_SOL_PO = ERR_CCS.CODICE_SOL_PO(+)
                      AND C.SIGLA_TIPO_DEPOSITARIO =
                             ERR_CCS.SIGLA_TIPO_DEPOSITARIO(+)
                      AND R.SIGLA_TIPO_DEPOSITARIO = C.SIGLA_TIPO_DEPOSITARIO
                      AND R.CODICE_RUOLO = 4 --solo depositari (vengono esclusi i validatori)
                      AND C.CODICE_UT = R.CODICE_UT       --solo depositari ut
                      AND   NVL (ERRORI_GEN, 0)
                          + NVL (ERRORI_INF, 0)
                          + NVL (ERRORI_ENE, 0)
                          + NVL (ERRORI_CCS, 0) > 0
                      --AND CODICE_ACQUISIZIONE = 4 and ID_UTENTE = 182
                      AND R.CODICE_UT <> '-1'
             GROUP BY H.CODICE_ACQUISIZIONE,
                      R.CODICE_UTENTE,
                      R.ID_UTENTE,
                      R.COGNOME,
                      R.NOME,
                      R.E_MAIL,
                      R.FLAG_MAIL,
                      D.CODICE_DTP,
                      D.DESCRIZIONE,
                      DECODE (SUBSTR (C.CODICE_SOL_PO, 1, 2),
                              'TR', 'Sezione di Linea',
                              'Punto Operativo'))
   GROUP BY CODICE_ACQUISIZIONE,
            CODICE_UTENTE,
            ID_UTENTE,
            COGNOME,
            NOME,
            E_MAIL,
            FLAG_MAIL,
            CODICE_DTP,
            DTP,
            TIPO_OGGETTO;
