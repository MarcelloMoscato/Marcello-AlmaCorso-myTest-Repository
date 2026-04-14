--
-- V_CONTESTO_GEOGRAFICO  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.V_CONTESTO_GEOGRAFICO
(CODICE_CONTESTO, CONTESTO, CODICE, DESCRIZIONE)
BEQUEATH DEFINER
AS 
SELECT c.codice_contesto,
          c.DESCRIZIONE contesto,
          TO_CHAR (r.CODICE_CORRIDOIO) codice,
          r.DEFINIZIONE descrizione
     FROM RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI t,
          RINF_ANAGRAFICHE_EVO.CORRIDOI_633 r,
          RINF_ANAGRAFICHE_EVO.ANAG_CONTESTO_GEO c
    WHERE     c.codice_contesto = 3
          AND r.CODICE_CORRIDOIO = t.CODICE_CORRIDOIO_633
   UNION
   --Linea Ten-T
   SELECT g.CODICE_CONTESTO,
          g.DESCRIZIONE contesto,
          TO_CHAR (t.NUMERO_LINEA_TENT),
          t.NOME_LINEA_TENT descrizione
     FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEE_TENT t,
          RINF_ANAGRAFICHE_EVO.ANAG_CONTESTO_GEO g
    WHERE g.codice_contesto = 4
   UNION
   --Linea Commerciale
   SELECT g.CODICE_CONTESTO,
          g.DESCRIZIONE contesto,
          h.SIGLA_LINEA_COMMERCIALE,
          h.DEFINIZIONE
     FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE h,
          RINF_ANAGRAFICHE_EVO.ANAG_CONTESTO_GEO g
    WHERE     g.codice_contesto = 5
          AND SUBSTR (h.SIGLA_LINEA_COMMERCIALE, 1, 1) IN ('C', 'N')
   UNION
   SELECT g.CODICE_CONTESTO,
          g.DESCRIZIONE contesto,
          td.SIGLA_LINEA_COMMERCIALE || '-' || tp.SIGLA_LINEA_COMMERCIALE,
          td.DEFINIZIONE
     FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE td,
          RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE tp,
          RINF_ANAGRAFICHE_EVO.ANAG_CONTESTO_GEO g
    WHERE     g.codice_contesto = 5
          AND MOD (SUBSTR (td.SIGLA_LINEA_COMMERCIALE, 2), 2) = 1
          AND SUBSTR (tp.SIGLA_LINEA_COMMERCIALE, 2) =
                 SUBSTR (td.SIGLA_LINEA_COMMERCIALE, 2) + 1
          AND SUBSTR (td.SIGLA_LINEA_COMMERCIALE, 1, 1) = 'F'
          AND SUBSTR (tp.SIGLA_LINEA_COMMERCIALE, 1, 1) = 'F'
   UNION
   SELECT g.CODICE_CONTESTO,
          g.DESCRIZIONE contesto,
          td.SIGLA_LINEA_COMMERCIALE || '-' || tp.SIGLA_LINEA_COMMERCIALE,
          td.DEFINIZIONE
     FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE td,
          RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE tp,
          RINF_ANAGRAFICHE_EVO.ANAG_CONTESTO_GEO g
    WHERE     g.codice_contesto = 5
          AND MOD (SUBSTR (td.SIGLA_LINEA_COMMERCIALE, 7), 2) = 1
          AND SUBSTR (tp.SIGLA_LINEA_COMMERCIALE, 7) =
                 SUBSTR (td.SIGLA_LINEA_COMMERCIALE, 7) + 1
          AND SUBSTR (td.SIGLA_LINEA_COMMERCIALE, 1, 1) = 'A'
          AND SUBSTR (tp.SIGLA_LINEA_COMMERCIALE, 1, 1) = 'A'
   UNION
   --Linea Tecnica
   SELECT c.codice_contesto,
          c.DESCRIZIONE contesto,
          t.LT_ID,
          t.DESCRIZIONE
     FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_TECNICA t,
          RINF_ANAGRAFICHE_EVO.ANAG_CONTESTO_GEO c
    WHERE c.codice_contesto = 6
   UNION
   --Linea FCL
   SELECT g.CODICE_CONTESTO,
          g.DESCRIZIONE contesto,
             'FL '
          || TO_CHAR (t.FASCICOLO_LINEA)
          || ' ('
          || f.CODICE_LINEA_FCL
          || ')',
          f.DEFINIZIONE
     FROM RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE t,
          RINF_ANAGRAFICHE_EVO.FASCICOLO_LINEE_FCL fl,
          RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL f,
          RINF_ANAGRAFICHE_EVO.ANAG_CONTESTO_GEO g
    WHERE     g.codice_contesto = 7
          AND f.CODICE_LINEA_FCL = fl.CODICE_LINEA_FCL
          AND fl.CODICE_FASCICOLO = t.CODICE_FASCICOLO
-->                Aggiunto per scartare le linee scadute o non valide
--          And (f.DAT_FINE_VAL Is Null 
          And     f.DATA_SCADENZA Is Null
--          )
--          
   UNION
   --DTP
   SELECT c.codice_contesto,
          c.DESCRIZIONE contesto,
          t.CODICE_DTP,
          t.DESCRIZIONE
     FROM RINF_ANAGRAFICHE_EVO.ANAG_DTP t,
          RINF_ANAGRAFICHE_EVO.ANAG_CONTESTO_GEO c
    WHERE c.codice_contesto = 8 AND t.codice_DTP <> '-1'
   UNION
   --Fascicolo Linea
   SELECT g.CODICE_CONTESTO,
          g.DESCRIZIONE contesto,
          'FL ' || TO_CHAR (t.FASCICOLO_LINEA),
          t.DEFINIZIONE
     FROM RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE t,
          RINF_ANAGRAFICHE_EVO.ANAG_CONTESTO_GEO g
    WHERE g.codice_contesto = 10 AND t.FLAG_DISPARI = 1;
