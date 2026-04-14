--
-- V_DIZIONARIO_MULTILINGUA  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.V_DIZIONARIO_MULTILINGUA
(CODICE_LINGUA, SIGLA_LINGUA, LINGUA, GRUPPO, CODICE_VOCE, 
 NOME_UNICO, TESTO, TOOLTIP)
BEQUEATH DEFINER
AS 
SELECT l.CODICE_LINGUA,
          l.SIGLA_LINGUA,
          L.DESCRIZIONE lingua,
          g.DESCRIZIONE gruppo,
          v.CODICE_VOCE,
          v.DESCRIZIONE nome_unico,
          e.etichetta testo,
          e.tooltip tooltip
     FROM RINF_ANAGRAFICHE_EVO.ANAG_LINGUA l,
          RINF_ANAGRAFICHE_EVO.VOCE_SISTEMA v,
          RINF_ANAGRAFICHE_EVO.ETICHETTA_VOCI e,
          RINF_ANAGRAFICHE_EVO.ANAG_GRUPPO g
    WHERE     l.codice_lingua = e.codice_lingua
          AND v.codice_voce = e.CODICE_VOCE
          AND g.codice_gruppo = v.codice_gruppo;
