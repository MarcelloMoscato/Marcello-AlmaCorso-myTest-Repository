--
-- V_STATO_RICHIESTE_SINTESI  (View) 
--
CREATE OR REPLACE VIEW RINF_AMMINISTRAZIONE_EVO.V_STATO_RICHIESTE_SINTESI
(CODICE_RICHIESTA, DATA_RICHIESTA, DATA_SCADENZA, STATO_FINALE, NOTE, 
 DATA_CHIUSURA, CODICE_DTP, DESCRIZIONE_DTP, CODICE_STATO_RICHIESTA, DATA_AUTORIZZAZIONE, 
 FLAG_SEDE_CENTRALE)
BEQUEATH DEFINER
AS 
Select 
          r.CODICE_RICHIESTA,
          r.DATA_RICHIESTA,
          r.DATA_SCADENZA,
          r.CODICE_STATO_RICHIESTA STATO_FINALE,
          r.NOTE,
          r.DATA_CHIUSURA,
          s.CODICE_DTP,
          DESCRIZIONE_DTP,
          S.CODICE_STATO_RICHIESTA,
          s.DATA_AUTORIZZAZIONE,
          s.FLAG_SEDE_CENTRALE
     From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI r,
          (  Select CODICE_RICHIESTA,
                    c.CODICE_DTP,
                    d.DESCRIZIONE DESCRIZIONE_DTP,
                    FLAG_SEDE_CENTRALE,
                    Max (CODICE_STATO_RICHIESTA) CODICE_STATO_RICHIESTA,
                    Max (DATA_AUTORIZZAZIONE) DATA_AUTORIZZAZIONE
               From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI c,
                    Rinf_Anagrafiche_Evo.ANAG_DTP d
              Where FLAG_SEDE_CENTRALE = 0 
			    And d.CODICE_DTP = c.CODICE_DTP
           Group By CODICE_RICHIESTA,
                    c.CODICE_DTP,
                    d.DESCRIZIONE,
                    FLAG_SEDE_CENTRALE
           Union
           (  Select c.CODICE_RICHIESTA,
                     c.CODICE_DTP,
                     'Sede Centrale' DESCRIZIONE_DTP,
                     1 FLAG_SEDE_CENTRALE,
                     Decode ( Sum (c.CODICE_STATO_RICHIESTA) - t.tot_autorizzati, 0, 2, 1) CODICE_STATO_RICHIESTA,
                     Max (c.DATA_AUTORIZZAZIONE) DATA_AUTORIZZAZIONE
                From (  Select CODICE_RICHIESTA,
                               CODICE_DTP,
                               d.SIGLA_TIPO_DEPOSITARIO,
                               FLAG_SEDE_CENTRALE,
                               Max (CODICE_STATO_RICHIESTA) CODICE_STATO_RICHIESTA,
                               Max (DATA_AUTORIZZAZIONE) DATA_AUTORIZZAZIONE
                          From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI a,
                               Rinf_Sicurezza_Evo.ANAG_TIPO_DEPOSITARIO d
                         Where FLAG_SEDE_CENTRALE <> 0
                           And a.FLAG_SEDE_CENTRALE = d.CODICE_TIPO_DEPOSITARIO
                           And FLAG_ABILITA_RICHIESTA_SC = '1'  -- SIGLA_TIPO_DEPOSITARIO not in( 'RC_RINF_DSPS', 'RC_RINF_DCO') 
                     Group By CODICE_RICHIESTA,
                               CODICE_DTP,
                               SIGLA_TIPO_DEPOSITARIO,
                               FLAG_SEDE_CENTRALE    ) c,
                       (Select Count (SIGLA_TIPO_DEPOSITARIO) * 2 tot_autorizzati
                        From Rinf_Sicurezza_Evo.ANAG_TIPO_DEPOSITARIO
                       Where AREA = 'SC' 
					     And FLAG_ABILITA_RICHIESTA_SC = '1') t,   -- SIGLA_TIPO_DEPOSITARIO not in( 'RC_RINF_DSPS', 'RC_RINF_DCO') 
                    RINF_ANAGRAFICHE_EVO.ANAG_DTP d
               Where c.CODICE_RICHIESTA = c.CODICE_RICHIESTA
                 And d.CODICE_DTP = c.CODICE_DTP
            Group By c.CODICE_RICHIESTA, c.CODICE_DTP, t.tot_autorizzati ) ) s
    Where r.CODICE_RICHIESTA = s.CODICE_RICHIESTA;


GRANT SELECT ON RINF_AMMINISTRAZIONE_EVO.V_STATO_RICHIESTE_SINTESI TO APPL_RINF_EVO;

GRANT SELECT ON RINF_AMMINISTRAZIONE_EVO.V_STATO_RICHIESTE_SINTESI TO RINF_GESTIONE_DB;
