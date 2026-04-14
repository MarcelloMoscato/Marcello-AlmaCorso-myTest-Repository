--
-- V_OGGETTI_CONTROLLATI_DEP_V082  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.V_OGGETTI_CONTROLLATI_DEP_V082
(CODICE_CONTROLLO, CODICE_DTP, DTP, SIGLA_TIPO_DEPOSITARIO, TIPO_OGGETTO, 
 CODICE_SOL_PO, DESCRIZIONE, CODICE_XML, CODICE_ESITO, ESITO, 
 ERRORI_GEN, ERRORI_INF, ERRORI_ENE, ERRORI_CCS, TOTALE_ERRORI)
BEQUEATH DEFINER
AS 
SELECT c.CODICE_CONTROLLO,
          d.CODICE_DTP,
          D.DESCRIZIONE DTP,
          c.SIGLA_TIPO_DEPOSITARIO,
          'Sezione di Linea' tipo_oggetto,
          c.CODICE_SOL_PO,
          sol_op.DEFINIZIONE DESCRIZIONE,
             'IT'
          || SUBSTR (OP_INIZIO.CODICE_MIR, 2)
          || ' - '
          || 'IT'
          || SUBSTR (OP_FINE.CODICE_MIR, 2)
             CODICE_XML,
          e.CODICE_ESITO,
          E.DESCRIZIONE ESITO,
          ERRORI_GEN,
          ERRORI_INF,
          ERRORI_ENE,
          ERRORI_CCS,
            NVL (ERRORI_GEN, 0)
          + NVL (ERRORI_INF, 0)
          + NVL (ERRORI_ENE, 0)
          + NVL (ERRORI_CCS, 0)
             TOTALE_ERRORI
     FROM (SELECT DISTINCT o.CODICE_CONTROLLO,
                           o.CODICE_SOL_PO,
                           o.CODICE_ESITO,
                           o.CODICE_DTP,
                           a.CODICE_TIPO_DEPOSITARIO,
                           a.SIGLA_TIPO_DEPOSITARIO
             FROM RINF_LAVORAZIONE_EVO.OGGETTI_CONTROLLATI o,
                  RINF_LAVORAZIONE_EVO.DETTAGLIO_CONTROLLATI d,
                  RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI p,
                  RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO a
            WHERE     o.CODICE_CONTROLLO = d.CODICE_CONTROLLO
                  AND o.CODICE_SOL_PO = d.CODICE_SOL_PO
                  AND d.CODICE_PARAMETRO = p.CODICE_PARAMETRO
                  AND P.CODICE_TIPO_DEPOSITARIO = a.CODICE_TIPO_DEPOSITARIO) c,
          RINF_ANAGRAFICHE_EVO.ANAG_ESITO e,
          RINF_ANAGRAFICHE_EVO.ANAG_DTP d,
          RINF_LAVORAZIONE_EVO.SEZIONI_LINEA sol_op,
          RINF_LAVORAZIONE_EVO.PUNTI_OPERATIVI op_inizio,
          RINF_LAVORAZIONE_EVO.PUNTI_OPERATIVI op_fine,
          (  SELECT CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_VISTA,
                    SIGLA_TIPO_DEPOSITARIO,
                    COUNT (*) ERRORI_GEN
               FROM V_DETT_CONTROLLI_FALLITI_V082
              WHERE SIGLA_VISTA = 'GEN'
           GROUP BY CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_VISTA,
                    SIGLA_TIPO_DEPOSITARIO) err_gen,
          (  SELECT CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_VISTA,
                    SIGLA_TIPO_DEPOSITARIO,
                    COUNT (*) ERRORI_INF
               FROM V_DETT_CONTROLLI_FALLITI_V082
              WHERE SIGLA_VISTA = 'INF'
           GROUP BY CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_VISTA,
                    SIGLA_TIPO_DEPOSITARIO) err_inf,
          (  SELECT CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_VISTA,
                    SIGLA_TIPO_DEPOSITARIO,
                    COUNT (*) ERRORI_ENE
               FROM V_DETT_CONTROLLI_FALLITI_V082
              WHERE SIGLA_VISTA = 'ENE'
           GROUP BY CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_VISTA,
                    SIGLA_TIPO_DEPOSITARIO) err_ene,
          (  SELECT CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_VISTA,
                    SIGLA_TIPO_DEPOSITARIO,
                    COUNT (*) ERRORI_CCS
               FROM V_DETT_CONTROLLI_FALLITI_V082
              WHERE SIGLA_VISTA = 'CCS'
           GROUP BY CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_VISTA,
                    SIGLA_TIPO_DEPOSITARIO) err_ccs,
          (  SELECT CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_TIPO_DEPOSITARIO,
                    COUNT (*) SUPERATI
               FROM V_DETT_CONTROLLI_SUPERATI_V082
           GROUP BY CODICE_CONTROLLO, CODICE_SOL_PO, SIGLA_TIPO_DEPOSITARIO) s
    WHERE     c.CODICE_ESITO = e.CODICE_ESITO
          AND d.CODICE_DTP = c.CODICE_DTP
          AND c.CODICE_SOL_PO = SOL_OP.SEDE_TECNICA
          AND SOL_OP.LOCALITA_INIZIO = op_inizio.sede_tecnica(+)
          AND SOL_OP.LOCALITA_FINE = op_fine.sede_tecnica(+)
          AND c.CODICE_CONTROLLO = err_gen.CODICE_CONTROLLO(+)
          AND c.CODICE_SOL_PO = err_gen.CODICE_SOL_PO(+)
          AND c.SIGLA_TIPO_DEPOSITARIO = err_gen.SIGLA_TIPO_DEPOSITARIO(+)
          AND c.CODICE_CONTROLLO = err_inf.CODICE_CONTROLLO(+)
          AND c.CODICE_SOL_PO = err_inf.CODICE_SOL_PO(+)
          AND c.SIGLA_TIPO_DEPOSITARIO = err_inf.SIGLA_TIPO_DEPOSITARIO(+)
          AND c.CODICE_CONTROLLO = err_ene.CODICE_CONTROLLO(+)
          AND c.CODICE_SOL_PO = err_ene.CODICE_SOL_PO(+)
          AND c.SIGLA_TIPO_DEPOSITARIO = err_ene.SIGLA_TIPO_DEPOSITARIO(+)
          AND c.CODICE_CONTROLLO = err_ccs.CODICE_CONTROLLO(+)
          AND c.CODICE_SOL_PO = err_ccs.CODICE_SOL_PO(+)
          AND c.SIGLA_TIPO_DEPOSITARIO = err_ccs.SIGLA_TIPO_DEPOSITARIO(+)
          AND c.CODICE_CONTROLLO = s.CODICE_CONTROLLO(+)
          AND c.CODICE_SOL_PO = s.CODICE_SOL_PO(+)
          AND c.SIGLA_TIPO_DEPOSITARIO = s.SIGLA_TIPO_DEPOSITARIO(+)
          AND   NVL (ERRORI_GEN, -1)
              + NVL (ERRORI_INF, -1)
              + NVL (ERRORI_ENE, -1)
              + NVL (ERRORI_CCS, -1)
              + NVL (SUPERATI, -1) <> -5
   UNION
   SELECT c.CODICE_CONTROLLO,
          d.CODICE_DTP,
          D.DESCRIZIONE DTP,
          c.SIGLA_TIPO_DEPOSITARIO,
          'Punto Operativo' tipo_oggetto,
          c.CODICE_SOL_PO,
          sol_op.DEFINIZIONE DESCRIZIONE,
          'IT' || SUBSTR (sol_op.CODICE_MIR, 2) CODICE_XML,
          e.CODICE_ESITO,
          E.DESCRIZIONE ESITO,
          ERRORI_GEN,
          ERRORI_INF,
          ERRORI_ENE,
          ERRORI_CCS,
            NVL (ERRORI_GEN, 0)
          + NVL (ERRORI_INF, 0)
          + NVL (ERRORI_ENE, 0)
          + NVL (ERRORI_CCS, 0)
             TOTALE_ERRORI
     FROM (SELECT DISTINCT o.CODICE_CONTROLLO,
                           o.CODICE_SOL_PO,
                           o.CODICE_ESITO,
                           o.CODICE_DTP,
                           a.CODICE_TIPO_DEPOSITARIO,
                           a.SIGLA_TIPO_DEPOSITARIO
             FROM RINF_LAVORAZIONE_EVO.OGGETTI_CONTROLLATI o,
                  RINF_LAVORAZIONE_EVO.DETTAGLIO_CONTROLLATI d,
                  RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI p,
                  RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO a
            WHERE     o.CODICE_CONTROLLO = d.CODICE_CONTROLLO
                  AND o.CODICE_SOL_PO = d.CODICE_SOL_PO
                  AND d.CODICE_PARAMETRO = p.CODICE_PARAMETRO
                  AND P.CODICE_TIPO_DEPOSITARIO = a.CODICE_TIPO_DEPOSITARIO) c,
          RINF_ANAGRAFICHE_EVO.ANAG_ESITO e,
          RINF_ANAGRAFICHE_EVO.ANAG_DTP d,
          RINF_LAVORAZIONE_EVO.PUNTI_OPERATIVI sol_op,
          (  SELECT CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_TIPO_DEPOSITARIO,
                    COUNT (*) ERRORI_GEN
               FROM V_DETT_CONTROLLI_FALLITI_V082
              WHERE SIGLA_VISTA = 'GEN'
           GROUP BY CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_VISTA,
                    SIGLA_TIPO_DEPOSITARIO) err_gen,
          (  SELECT CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_TIPO_DEPOSITARIO,
                    COUNT (*) ERRORI_INF
               FROM V_DETT_CONTROLLI_FALLITI_V082
              WHERE SIGLA_VISTA = 'INF'
           GROUP BY CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_VISTA,
                    SIGLA_TIPO_DEPOSITARIO) err_inf,
          (  SELECT CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_TIPO_DEPOSITARIO,
                    COUNT (*) ERRORI_ENE
               FROM V_DETT_CONTROLLI_FALLITI_V082
              WHERE SIGLA_VISTA = 'ENE'
           GROUP BY CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_VISTA,
                    SIGLA_TIPO_DEPOSITARIO) err_ene,
          (  SELECT CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_TIPO_DEPOSITARIO,
                    COUNT (*) ERRORI_CCS
               FROM V_DETT_CONTROLLI_FALLITI_V082
              WHERE SIGLA_VISTA = 'CCS'
           GROUP BY CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_VISTA,
                    SIGLA_TIPO_DEPOSITARIO) err_ccs,
          (  SELECT CODICE_CONTROLLO,
                    CODICE_SOL_PO,
                    SIGLA_TIPO_DEPOSITARIO,
                    COUNT (*) SUPERATI
               FROM V_DETT_CONTROLLI_SUPERATI_V082
           GROUP BY CODICE_CONTROLLO, CODICE_SOL_PO, SIGLA_TIPO_DEPOSITARIO) s
    WHERE     c.CODICE_ESITO = e.CODICE_ESITO
          AND d.CODICE_DTP = c.CODICE_DTP
          AND c.CODICE_SOL_PO = SOL_OP.SEDE_TECNICA
          AND c.CODICE_CONTROLLO = err_gen.CODICE_CONTROLLO(+)
          AND c.CODICE_SOL_PO = err_gen.CODICE_SOL_PO(+)
          AND c.SIGLA_TIPO_DEPOSITARIO = err_gen.SIGLA_TIPO_DEPOSITARIO(+)
          AND c.CODICE_CONTROLLO = err_inf.CODICE_CONTROLLO(+)
          AND c.CODICE_SOL_PO = err_inf.CODICE_SOL_PO(+)
          AND c.SIGLA_TIPO_DEPOSITARIO = err_inf.SIGLA_TIPO_DEPOSITARIO(+)
          AND c.CODICE_CONTROLLO = err_ene.CODICE_CONTROLLO(+)
          AND c.CODICE_SOL_PO = err_ene.CODICE_SOL_PO(+)
          AND c.SIGLA_TIPO_DEPOSITARIO = err_ene.SIGLA_TIPO_DEPOSITARIO(+)
          AND c.CODICE_CONTROLLO = err_ccs.CODICE_CONTROLLO(+)
          AND c.CODICE_SOL_PO = err_ccs.CODICE_SOL_PO(+)
          AND c.SIGLA_TIPO_DEPOSITARIO = err_ccs.SIGLA_TIPO_DEPOSITARIO(+)
          AND c.CODICE_CONTROLLO = s.CODICE_CONTROLLO(+)
          AND c.CODICE_SOL_PO = s.CODICE_SOL_PO(+)
          AND c.SIGLA_TIPO_DEPOSITARIO = s.SIGLA_TIPO_DEPOSITARIO(+)
          AND   NVL (ERRORI_GEN, -1)
              + NVL (ERRORI_INF, -1)
              + NVL (ERRORI_ENE, -1)
              + NVL (ERRORI_CCS, -1)
              + NVL (SUPERATI, -1) <> -5;
