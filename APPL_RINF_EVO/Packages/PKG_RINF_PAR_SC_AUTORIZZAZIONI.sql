--
-- PKG_RINF_PAR_SC_AUTORIZZAZIONI  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_PAR_SC_AUTORIZZAZIONI" Is

-- v 1.1 del 18/10/2023
-- v 1.2 del 25/10/2023 - modificato il nome della vista per il limite del nome a 30 caratteri MAX

-- modificata la procedura PAR_1_1_1_0_0_2_ROLLBACK per gestire il caso in cui DCO non autorizza 
-- e un binario cambia il nome tra una versione e l'altra (es. TR5880-BC-BC01 diventa TR5880-BC-BC03

-- v 1.3 del 27/10/2023  - Modificata la gestione dei parametri SOL sia in UPD che ROLLBACK. 
-- Per i parametri di binario delle tratte, RFI ha richiesto che vengano applicate solo ai binari di tipo Regular 
-- Per i binari di tipo Link si sono mantenute le precedenti impostazioni: per i parametri non fondamentali AP = [N]
--  
-- v. 1.4 escluse le Sedi tecniche Skeleton sia in cancellazione che in inserimento dai parametri multi-valore 
-- in UPD per evitare le duplicazioni, in quanto i parametri vengono valorizzati a parte con lo skeleton
-- -------------------------------------------------------------------------------------------  
-- Procedura per il Rollback dei parametri di competenza di una Sede Centrale, se Non Autorizzato:
--  viene aggiornato il parametro con i valori precedentemente Pubblicati (versione -1)
--  iterando tutte Tratte oppure tutti i Punti Operativi contenuti nelle singole DTP  (DOIT)
--	Direzione Tecnica\Normativa, Circolabilit  ed Analisi di Rischio di Sistema (DTEC)
--	Direzione Tecnica\Standard Infrastruttura (DTEC_2)
--	Direzione Tecnica\Standard Tecnologie (DTEC_3)
--	Direzione Commerciale\Pianificazione e Sviluppo Rete (DCO)
--	Direzione Strategia, Pianificazione e Sostenibilit \Progetti Internazionali e Corridoi Europei (DSPS).

-- -------------------------------------------------------------------------------------------
-- procedure per recuperare le Sedi Tecniche (SOL e/o PO) presenti in CLASSE_ELIMINATI che, 
-- malgrado autorizzati dalla DOIT Territoriale di competenza, a causa di una non autorizzazione
-- da parte di una Sede centrale (DCO) devono essere ripristinate in quanto non presenti
-- nelle tabelle dell'area dati Controllati/Corretti e RI-Autorizzazioni ma in Pubblicati (Ri-Pronti) 
-- versione precedente alla versione corrente
-- -------------------------------------------------------------------------------------------

 Procedure Rispristina_Pubblicati_PO  (p_SEDE_TECNICA varchar2, p_versione Number, p_errore out Number ) ;
 Procedure Rispristina_Pubblicati_SOL (p_SEDE_TECNICA varchar2, p_versione Number, p_errore out Number ) ;
 Procedure Ripristina_SEDE_TECNICA (V_Codice_Versione Number, v_DTP Varchar2, p_error_split Out Number); 
 Procedure Set_Skeleton_SOL (p_SEDE_TECNICA varchar2, p_versione Number, p_error out Number);
 Procedure Set_Skeleton_Po  (p_SEDE_TECNICA varchar2, p_versione Number, p_error out Number);

--
-- -------------------------------------------------------------------------------------------
--                         nonaut_RC_RINF_DTEC
-- -------------------------------------------------------------------------------------------
--
 Procedure PAR_1_2_1_0_0_1_ROLLBACK   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_7_10_ROLLBACK  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_4_1_ROLLBACK     (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_4_2_ROLLBACK     (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_2_0_0_1_ROLLBACK   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_1_0_5_1_ROLLBACK   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_8_1_ROLLBACK   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_2_0_5_1_ROLLBACK   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_1_0_6_1_ROLLBACK   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_3_1_ROLLBACK       (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_3_2_ROLLBACK       (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_0_0_0_1_ROLLBACK   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
--
--
-- -------------------------------------------------------------------------------------------
--                         aut_RC_RINF_DTEC
-- -------------------------------------------------------------------------------------------
--
 Procedure PAR_1_1_0_0_0_1_UPD   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_1_0_0_1_UPD   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_7_10_UPD  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_4_1_UPD     (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_4_2_UPD     (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_2_0_0_1_UPD   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_1_0_5_1_UPD   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_8_1_UPD   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_2_0_5_1_UPD   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_1_0_6_1_UPD   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_3_1_UPD       (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_3_2_UPD       (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
--
-- -------------------------------------------------------------------------------------------
--                         nonaut_RC_RINF_DTEC_2
-- -------------------------------------------------------------------------------------------
--  

 Procedure PAR_1_2_1_0_3_5_ROLLBACK    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_1_0_3_6_ROLLBACK    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_1_0_4_1_ROLLBACK    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_3_1_2_ROLLBACK  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_3_1_3_ROLLBACK  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_4_1_ROLLBACK    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_4_2_ROLLBACK    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_4_3_ROLLBACK    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_4_4_ROLLBACK    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_5_1_ROLLBACK    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_5_2_ROLLBACK    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_6_4_ROLLBACK    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_6_5_ROLLBACK    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_7_11_ROLLBACK   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_1_0_5_9_ROLLBACK    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_8_8_2_ROLLBACK  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
--
--
-- -------------------------------------------------------------------------------------------
--                         aut_RC_RINF_DTEC_2
-- -------------------------------------------------------------------------------------------
 Procedure PAR_1_2_1_0_3_5_UPD    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_1_0_3_6_UPD    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_1_0_4_1_UPD    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_3_1_2_UPD  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_3_1_3_UPD  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_4_1_UPD    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_4_2_UPD    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_4_3_UPD    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_4_4_UPD    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_5_1_UPD    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_5_2_UPD    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_6_4_UPD    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_6_5_UPD    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_7_11_UPD  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_2_1_0_5_9_UPD    (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_1_8_8_2_UPD  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
--
-- -------------------------------------------------------------------------------------------
--                         nonaut_RC_RINF_DTEC_3
-- -------------------------------------------------------------------------------------------
--  

 Procedure PAR_1_1_1_2_2_1_3_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_2_4_3_ROLLBACK   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_3_7_1_4_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_3_7_19_ROLLBACK  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_3_7_20_ROLLBACK  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_3_7_21_ROLLBACK  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_3_7_22_ROLLBACK  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_3_7_23_ROLLBACK  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
--
-- -------------------------------------------------------------------------------------------
--                         aut_RC_RINF_DTEC_3
-- -------------------------------------------------------------------------------------------
--  
 Procedure PAR_1_1_1_2_2_1_3_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_2_4_3_UPD   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_3_7_1_4_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) ;
 Procedure PAR_1_1_1_3_7_19_UPD  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_3_7_20_UPD  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_3_7_21_UPD  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_3_7_22_UPD  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_3_7_23_UPD  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
--
-- -------------------------------------------------------------------------------------------
--                         nonaut_RC_RINF_DSPS
-- -------------------------------------------------------------------------------------------
--  
 Procedure PAR_1_1_1_1_2_1_ROLLBACK   (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_1_2_1_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_1_2_3_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number);
--
-- -------------------------------------------------------------------------------------------
--                         aut_RC_RINF_DSPS
-- -------------------------------------------------------------------------------------------
--  
 Procedure PAR_1_1_1_1_2_1_UPD  (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_1_2_1_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_1_2_3_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number);
-- -------------------------------------------------------------------------------------
--                        nonaut_RC_RINF_DCO
-- -------------------------------------------------------------------------------------

 Procedure PAR_1_1_0_0_0_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_0_0_0_3_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_0_0_0_4_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_1_1_0_0_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_2_0_0_0_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_2_0_0_0_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_2_0_0_0_3_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_2_0_0_0_4_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_2_0_0_0_5_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;
 Procedure PAR_1_2_0_0_0_6_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number)  ;


-- -------------------------------------------------------------------------------------
--                        aut_RC_RINF_DCO
-- -------------------------------------------------------------------------------------

Procedure PAR_1_1_0_0_0_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number);
Procedure PAR_1_1_0_0_0_3_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number);
Procedure PAR_1_1_0_0_0_4_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number);
Procedure PAR_1_1_1_0_0_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number);
Procedure PAR_1_2_0_0_0_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number);
Procedure PAR_1_2_0_0_0_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number);
Procedure PAR_1_2_0_0_0_3_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number);
Procedure PAR_1_2_0_0_0_4_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number);
Procedure PAR_1_2_0_0_0_5_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number);
Procedure PAR_1_2_0_0_0_6_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number);

 End;
/


--
-- PKG_RINF_PAR_SC_AUTORIZZAZIONI  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_PAR_SC_AUTORIZZAZIONI" Is
--

Procedure Rispristina_Pubblicati_PO (p_SEDE_TECNICA varchar2, p_versione Number, p_errore out Number ) is

Begin
--  ********************************  OP  **********************************************
-- --------------------------------------------------------------------------------------
--  OP versione precedente
-- --------------------------------------------------------------------------------------
 p_errore := 1;
 Begin
     Insert Into Rinf_Pubblicati_Evo.PUNTI_OPERATIVI (
                 SEDE_TECNICA,
                 CODICE_MIR,
                 DEFINIZIONE,
                 STATO_SISTEMA,
                 STATO_UTENTE,
                 LOCALITA_CONTENITORE,
                 KM_INIZIO,
                 PO_1_2_0_0_0_2,
                 PO_1_2_0_0_0_3_AP,
                 PO_1_2_0_0_0_4,
                 PO_1_2_0_0_0_6,
                 LATITUDINE,
                 LONGITUDINE,
                 CODICE_LINEA_TECNICA,
                 CODICE_DTP,
                 CODICE_UT,
                 NUOVA_CLASSIFICAZIONE_STAZIONE,
                 CODICE_VERSIONE,
                 TIPO_LOCALITA_CONFINE,
                 GRUPPO_AUTORIZZATIVO,
                 CACHE_FIELD,
  		         PO_1_2_0_0_0_4_1_AP,
                 PO_1_2_0_0_0_4_1,
                 PO_1_2_3_1_AP,
                 PO_1_2_3_1,
                 PO_1_2_3_2_AP   )
          Select p.SEDE_TECNICA,
                 CODICE_MIR,
                 DEFINIZIONE,
                 STATO_SISTEMA,
                 STATO_UTENTE,
                 LOCALITA_CONTENITORE,
                 KM_INIZIO,
                 PO_1_2_0_0_0_2,
                 PO_1_2_0_0_0_3_AP,
                 PO_1_2_0_0_0_4,
                 PO_1_2_0_0_0_6,
                 LATITUDINE,
                 LONGITUDINE,
                 CODICE_LINEA_TECNICA,
                 p.CODICE_DTP,
                 CODICE_UT,
                 NUOVA_CLASSIFICAZIONE_STAZIONE,
                 p_versione,
                 TIPO_LOCALITA_CONFINE,
                 GRUPPO_AUTORIZZATIVO,
                 CACHE_FIELD,
				 PO_1_2_0_0_0_4_1_AP,
                 PO_1_2_0_0_0_4_1,
                 PO_1_2_3_1_AP,
                 PO_1_2_3_1,
                 PO_1_2_3_2_AP
            From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI p
           Where p.SEDE_TECNICA = p_SEDE_TECNICA 
	         And p.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PUNTI_OPERATIVI record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

 EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PUNTI_OPERATIVI - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;
-- --------------------------------------------------------------------------------------
-- TAF/TAP PO versione precedente
-- --------------------------------------------------------------------------------------

 begin
      Insert Into Rinf_Pubblicati_Evo.PAR_1_2_0_0_0_3_TAF_TAP
         (   SEDE_TECNICA,
             PO_1_2_0_0_0_3,
             KM_INIZIO,
             KM_FINE,
             CODICE_VERSIONE   )
         Select Distinct
             bg.SEDE_TECNICA,
             PO_1_2_0_0_0_3,
             KM_INIZIO,
             KM_FINE,
             p_versione
        From Rinf_Pubblicati_Evo.PAR_1_2_0_0_0_3_TAF_TAP bg
       Where bg.SEDE_TECNICA = p_SEDE_TECNICA
         And bg.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_2_0_0_0_3_TAF_TAP record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

 EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_2_0_0_0_3_TAF_TAP - Errore: '|| Substr(SQLERRM, 1, 300));
 		p_errore := 0;

 END;

-- --------------------------------------------------------------------------------------
-- Binari versione precedente - Binari delle DTP che non hanno autorizzato
-- --------------------------------------------------------------------------------------

 begin
      Insert Into Rinf_Pubblicati_Evo.BINARI_CORSA_PO (
            PO_TRACK_1_2_1_0_0_1,
            PO_TRACK_1_2_1_0_0_2,
            PO_TRACK_1_2_1_0_0_2_D,
            PO_TRACK_1_2_1_0_2_1_AP,
--            PO_TRACK_1_2_1_0_2_1,                        -- multiplo
            PO_TRACK_1_2_1_0_2_2_AP,
--            PO_TRACK_1_2_1_0_2_2,                        -- multiplo
            PO_TRACK_1_2_1_0_2_3_AP,
--            PO_TRACK_1_2_1_0_2_3,                        -- multiplo
            PO_TRACK_1_2_1_0_3_1_AP,
            PO_TRACK_1_2_1_0_3_1,
            PO_TRACK_1_2_1_0_3_2_AP,
            PO_TRACK_1_2_1_0_3_2,
            PO_TRACK_1_2_1_0_3_3_AP,
            PO_TRACK_1_2_1_0_3_3,
            PO_TRACK_1_2_1_0_4_1_AP,
            PO_TRACK_1_2_1_0_4_1,
            CODICE_VERSIONE,
            GRUPPO_AUTORIZZATIVO,
	        PO_TRACK_1_2_1_0_3_4_AP,
            PO_TRACK_1_2_1_0_3_4_SUP,                   -- 1.2.1.0.3.4 Parametro Reg.777/2019
            PO_TRACK_1_2_1_0_3_4_INF,                   -- 1.2.1.0.3.4 Parametro Reg.777/2019
            PO_TRACK_1_2_1_0_3_5_AP,                    
            PO_TRACK_1_2_1_0_3_5_A,                     -- 1.2.1.0.3.5 Parametro Reg.777/2019 
            PO_TRACK_1_2_1_0_3_5_B,                     -- 1.2.1.0.3.5 Parametro Reg.777/2019
            PO_TRACK_1_2_1_0_3_6_AP,                   
            PO_TRACK_1_2_1_0_3_6	 )              -- 1.2.1.0.3.6 Parametro Reg.777/2019
     Select Distinct 
	        PO_TRACK_1_2_1_0_0_1,
            b.PO_TRACK_1_2_1_0_0_2,
            PO_TRACK_1_2_1_0_0_2_D,
            PO_TRACK_1_2_1_0_2_1_AP,
--            PO_TRACK_1_2_1_0_2_1,                        -- multiplo
            PO_TRACK_1_2_1_0_2_2_AP,
--            PO_TRACK_1_2_1_0_2_2,                        -- multiplo
            PO_TRACK_1_2_1_0_2_3_AP,
--            PO_TRACK_1_2_1_0_2_3,                        -- multiplo
            PO_TRACK_1_2_1_0_3_1_AP,
            PO_TRACK_1_2_1_0_3_1,
            PO_TRACK_1_2_1_0_3_2_AP,
            PO_TRACK_1_2_1_0_3_2,
            PO_TRACK_1_2_1_0_3_3_AP,
            PO_TRACK_1_2_1_0_3_3,
            PO_TRACK_1_2_1_0_4_1_AP,
            PO_TRACK_1_2_1_0_4_1,
            p_versione,
            GRUPPO_AUTORIZZATIVO,
	        PO_TRACK_1_2_1_0_3_4_AP,
            PO_TRACK_1_2_1_0_3_4_SUP,                      -- 1.2.1.0.3.4 Parametro Reg.777/2019
            PO_TRACK_1_2_1_0_3_4_INF,                      -- 1.2.1.0.3.4 Parametro Reg.777/2019
            PO_TRACK_1_2_1_0_3_5_AP,                         
            PO_TRACK_1_2_1_0_3_5_A,                        -- 1.2.1.0.3.5 Parametro Reg.777/2019 
            PO_TRACK_1_2_1_0_3_5_B,                        -- 1.2.1.0.3.5 Parametro Reg.777/2019
            PO_TRACK_1_2_1_0_3_6_AP,                        
            PO_TRACK_1_2_1_0_3_6                           -- 1.2.1.0.3.6 Parametro Reg.777/2019
       From Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
            Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r
      Where b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
        And b.CODICE_VERSIONE = r.CODICE_VERSIONE
        And r.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1
        And (b.PO_TRACK_1_2_1_0_0_2, p_versione) In
                 (Select b.PO_TRACK_1_2_1_0_0_2, p_versione
                    From Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
                         Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r
                   Where b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
                     And b.CODICE_VERSIONE = r.CODICE_VERSIONE
                     And r.SEDE_TECNICA = p_SEDE_TECNICA
                     And b.CODICE_VERSIONE = p_versione -1
                 Minus
                  Select b.PO_TRACK_1_2_1_0_0_2, b.CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.BINARI_CORSA_PO b
	    );

  DBMS_OUTPUT.PUT_LINE('BINARI_CORSA_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

 EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert BINARI_CORSA_PO - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;


-- --------------------------------------------------------------------------------------
-- Dichiarazioni versione precedente
-- --------------------------------------------------------------------------------------

  begin
      Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO  (
                  PO_TRACK_1_2_1_0_0_2,
                  TIPO_DICHIARAZIONE,
                  PO_TRACK_1_2_1_0_1_1O2_AP,
                  PO_TRACK_1_2_1_0_1_1O2,
                  KM_INIZIO,
                  KM_FINE,
                  CODICE_VERSIONE   )
         Select DISTINCT
                  d.PO_TRACK_1_2_1_0_0_2          ,
                  TIPO_DICHIARAZIONE              ,
                  PO_TRACK_1_2_1_0_1_1O2_AP       ,
                  PO_TRACK_1_2_1_0_1_1O2          ,
                  KM_INIZIO                       ,
                  KM_FINE                         ,
                  p_versione
             From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO d,
                  Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
                  Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r
            Where b.PO_TRACK_1_2_1_0_0_2 = d.PO_TRACK_1_2_1_0_0_2
              And b.CODICE_VERSIONE = d.CODICE_VERSIONE
              And b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
              And b.CODICE_VERSIONE = r.CODICE_VERSIONE
			  And r.SEDE_TECNICA = p_SEDE_TECNICA
              And r.CODICE_VERSIONE = p_versione -1
              And (d.PO_TRACK_1_2_1_0_0_2,  d.TIPO_DICHIARAZIONE,  d.PO_TRACK_1_2_1_0_1_1O2, d.KM_INIZIO, p_versione) In
                 (Select d.PO_TRACK_1_2_1_0_0_2,
                         d.TIPO_DICHIARAZIONE,
                         d.PO_TRACK_1_2_1_0_1_1O2,
                         d.KM_INIZIO,
                         p_versione
                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO d,
                         Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
                         Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
						 Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
                   Where v.CODICE_VERSIONE = p_versione
                     And v.FLAG_NEW = 0
                     And r.SEDE_TECNICA = p_SEDE_TECNICA
                     And b.PO_TRACK_1_2_1_0_0_2 = d.PO_TRACK_1_2_1_0_0_2
                     And b.CODICE_VERSIONE = d.CODICE_VERSIONE
                     And b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
                     And b.CODICE_VERSIONE = r.CODICE_VERSIONE
                     And b.CODICE_VERSIONE = p_versione -1
                  Minus
                  Select PO_TRACK_1_2_1_0_0_2,
                         TIPO_DICHIARAZIONE,
                         PO_TRACK_1_2_1_0_1_1O2,
                         KM_INIZIO,
                         CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO);

  DBMS_OUTPUT.PUT_LINE('DICHIARAZIONI_BINARIO_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

 EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert DICHIARAZIONI_BINARIO_PO - Errore: '|| Substr(SQLERRM, 1, 300));
 		p_errore := 0;
END;

-- --------------------------------------------------------------------------------------
-- Relazione Binari-PO precedenti
-- --------------------------------------------------------------------------------------

 Begin
      Insert Into Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA (
             PO_TRACK_1_2_1_0_0_2,
             SEDE_TECNICA,
             CODICE_VERSIONE )
      Select DISTINCT
             r.PO_TRACK_1_2_1_0_0_2 ,
             r.SEDE_TECNICA,
             p_versione
        From Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
             Rinf_Pubblicati_Evo.BINARI_CORSA_PO b
       Where b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
         And b.CODICE_VERSIONE = r.CODICE_VERSIONE
	     And r.SEDE_TECNICA = p_SEDE_TECNICA
         And r.CODICE_VERSIONE = p_versione -1
         And (r.PO_TRACK_1_2_1_0_0_2, r.SEDE_TECNICA, p_versione) In
                 (Select r.PO_TRACK_1_2_1_0_0_2,
                         r.SEDE_TECNICA,
                         v.CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
                         Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
                         Rinf_Pubblicati_Evo.PUNTI_OPERATIVI p,
                         Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
                   Where v.CODICE_VERSIONE = p_versione
                     And v.FLAG_NEW = 0
                     And b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
                     And b.CODICE_VERSIONE = r.CODICE_VERSIONE
                     And r.SEDE_TECNICA = v.SEDE_TECNICA
                     And r.SEDE_TECNICA = p.SEDE_TECNICA
                     And r.CODICE_VERSIONE = p.CODICE_VERSIONE
                     And r.CODICE_VERSIONE = p_versione -1
                  Minus
                  Select PO_TRACK_1_2_1_0_0_2, SEDE_TECNICA, CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA  );

  DBMS_OUTPUT.PUT_LINE('REL_PO_BINARI_CORSA record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

 EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert REL_PO_BINARI_CORSA - Errore: '|| Substr(SQLERRM, 1, 300));
 		p_errore := 0;
END;


-- --------------------------------------------------------------------------------------
-- Gallerie Versione precedente
-- --------------------------------------------------------------------------------------

 Begin
     Insert Into Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO (
         PO_TR_TUNNEL_1_2_1_0_5_1,
         PO_TR_TUNNEL_1_2_1_0_5_2,
         PO_TR_TUNNEL_1_2_1_0_5_2_D,
         PO_TR_TUNNEL_1_2_1_0_5_5_AP,
         PO_TR_TUNNEL_1_2_1_0_5_5,
         PO_TR_TUNNEL_1_2_1_0_5_6_AP,
         PO_TR_TUNNEL_1_2_1_0_5_6,
         PO_TR_TUNNEL_1_2_1_0_5_7_AP,
         PO_TR_TUNNEL_1_2_1_0_5_7,
         PO_TR_TUNNEL_1_2_1_0_5_8_AP,
         PO_TR_TUNNEL_1_2_1_0_5_8,
         CODICE_VERSIONE,
         GALLERIA_PRINCIPALE,
         CONFIGURAZIONE_GALLERIA,
         GRUPPO_AUTORIZZATIVO,
	     PO_TR_TUNNEL_1_2_1_0_5_9_AP,
         PO_TR_TUNNEL_1_2_1_0_5_9		 )                 -- 1.2.1.0.5.9 Parametro Reg.777/2019
     Select Distinct
         PO_TR_TUNNEL_1_2_1_0_5_1    ,
         g.PO_TR_TUNNEL_1_2_1_0_5_2        ,
         PO_TR_TUNNEL_1_2_1_0_5_2_D,
         PO_TR_TUNNEL_1_2_1_0_5_5_AP,
         PO_TR_TUNNEL_1_2_1_0_5_5,
         PO_TR_TUNNEL_1_2_1_0_5_6_AP,
         PO_TR_TUNNEL_1_2_1_0_5_6,
         PO_TR_TUNNEL_1_2_1_0_5_7_AP,
         PO_TR_TUNNEL_1_2_1_0_5_7,
         PO_TR_TUNNEL_1_2_1_0_5_8_AP,
         PO_TR_TUNNEL_1_2_1_0_5_8,
         p_versione,
         GALLERIA_PRINCIPALE,
         CONFIGURAZIONE_GALLERIA,
         g.GRUPPO_AUTORIZZATIVO,
	     PO_TR_TUNNEL_1_2_1_0_5_9_AP,
         PO_TR_TUNNEL_1_2_1_0_5_9                          -- 1.2.1.0.5.9 Parametro Reg.777/2019
    From Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO g,
         Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO bg,
         Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
         Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r
   Where g.PO_TR_TUNNEL_1_2_1_0_5_2 = bg.PO_TR_TUNNEL_1_2_1_0_5_2
     And g.CODICE_VERSIONE = bg.CODICE_VERSIONE
     And bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
     And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
     And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
     And r.CODICE_VERSIONE = b.CODICE_VERSIONE
     And r.SEDE_TECNICA = p_SEDE_TECNICA
     And r.CODICE_VERSIONE = p_versione -1
     And (g.PO_TR_TUNNEL_1_2_1_0_5_2, p_versione) In
                 (Select g.PO_TR_TUNNEL_1_2_1_0_5_2, p_versione
                    From Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO g,
                         Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
                         Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO bg,
                         Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
                         Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r
                   Where g.PO_TR_TUNNEL_1_2_1_0_5_2 = bg.PO_TR_TUNNEL_1_2_1_0_5_2
                     And g.CODICE_VERSIONE = bg.CODICE_VERSIONE
                     And bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
                     And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
                     And v.CODICE_VERSIONE = p_versione
                     And v.FLAG_NEW = 0
                     And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
                     And r.CODICE_VERSIONE = b.CODICE_VERSIONE
                     And r.SEDE_TECNICA = v.SEDE_TECNICA
                     And b.CODICE_VERSIONE = p_versione -1
                  Minus
                  Select PO_TR_TUNNEL_1_2_1_0_5_2, CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO  );

  DBMS_OUTPUT.PUT_LINE('GALLERIE_BINARI_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

 EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert GALLERIE_BINARI_PO - Errore: '|| Substr(SQLERRM, 1, 300));
 		p_errore := 0;
END;


-- --------------------------------------------------------------------------------------
-- Relazioni Gallerie-Binari Versione Precedente
-- --------------------------------------------------------------------------------------

 Begin
      Insert Into Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO
	       (PO_TR_TUNNEL_1_2_1_0_5_2, PO_TRACK_1_2_1_0_0_2, CODICE_VERSIONE)
       Select Distinct
            PO_TR_TUNNEL_1_2_1_0_5_2, 
			bg.PO_TRACK_1_2_1_0_0_2, 
			p_versione
       From Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
            Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r
      Where bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And r.CODICE_VERSIONE = b.CODICE_VERSIONE
        And r.SEDE_TECNICA = p_SEDE_TECNICA
        And r.CODICE_VERSIONE = p_versione -1
        And (PO_TR_TUNNEL_1_2_1_0_5_2, bg.PO_TRACK_1_2_1_0_0_2, p_versione) IN
                 (Select PO_TR_TUNNEL_1_2_1_0_5_2,
                         bg.PO_TRACK_1_2_1_0_0_2,
                         p_versione
                    From Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO bg,
                         Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
                         Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
                         Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
                   Where bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
                     And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
                     And v.CODICE_VERSIONE = p_versione
                     And v.FLAG_NEW = 0
                     And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
                     And r.CODICE_VERSIONE = b.CODICE_VERSIONE
                     And r.SEDE_TECNICA = v.SEDE_TECNICA
                     And b.CODICE_VERSIONE = p_versione -1
                  Minus
                  Select Distinct
                         PO_TR_TUNNEL_1_2_1_0_5_2,
                         PO_TRACK_1_2_1_0_0_2,
                         CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO  );

  DBMS_OUTPUT.PUT_LINE('REL_GALLERIE_BINARI_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

 EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert REL_GALLERIE_BINARI_PO  - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Dichiarazioni versione precedente
-- --------------------------------------------------------------------------------------

Begin
      Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO (
           PO_TR_TUNNEL_1_2_1_0_5_2,
           TIPO_DICHIARAZIONE,
           PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,
           PO_TR_TUNNEL_1_2_1_0_5_3O4,
           KM_INIZIO,
           KM_FINE,
           CODICE_VERSIONE   )
      Select Distinct 
           d.PO_TR_TUNNEL_1_2_1_0_5_2,
           TIPO_DICHIARAZIONE,
           PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,
           PO_TR_TUNNEL_1_2_1_0_5_3O4,
           KM_INIZIO,
           KM_FINE,
           p_versione
      From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO d,
           Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO g,
           Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO bg,
           Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
           Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r
     Where d.PO_TR_TUNNEL_1_2_1_0_5_2 = g.PO_TR_TUNNEL_1_2_1_0_5_2
       And d.CODICE_VERSIONE = g.CODICE_VERSIONE
       And g.PO_TR_TUNNEL_1_2_1_0_5_2 = bg.PO_TR_TUNNEL_1_2_1_0_5_2
       And g.CODICE_VERSIONE = bg.CODICE_VERSIONE
       And bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
       And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
       And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
       And r.CODICE_VERSIONE = b.CODICE_VERSIONE
       And r.SEDE_TECNICA = p_SEDE_TECNICA
       And r.CODICE_VERSIONE = p_versione -1
       And (d.PO_TR_TUNNEL_1_2_1_0_5_2,
            d.TIPO_DICHIARAZIONE,
            d.PO_TR_TUNNEL_1_2_1_0_5_3O4,
            d.KM_INIZIO,
            p_versione) In
          (Select d.PO_TR_TUNNEL_1_2_1_0_5_2,
                   d.TIPO_DICHIARAZIONE,
                   d.PO_TR_TUNNEL_1_2_1_0_5_3O4,
                   d.KM_INIZIO,
                   p_versione
              From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO d,
                   Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO g,
                   Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
                   Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO bg,
                   Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
                   Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r
             Where d.PO_TR_TUNNEL_1_2_1_0_5_2 = g.PO_TR_TUNNEL_1_2_1_0_5_2
               And d.CODICE_VERSIONE = g.CODICE_VERSIONE
               And g.PO_TR_TUNNEL_1_2_1_0_5_2 = bg.PO_TR_TUNNEL_1_2_1_0_5_2
               And g.CODICE_VERSIONE = bg.CODICE_VERSIONE
               And bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
               And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
               And v.CODICE_VERSIONE = p_versione
               And v.FLAG_NEW = 0
               And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
               And r.CODICE_VERSIONE = b.CODICE_VERSIONE
               And r.SEDE_TECNICA = v.SEDE_TECNICA
               And b.CODICE_VERSIONE = p_versione -1
            Minus
            Select PO_TR_TUNNEL_1_2_1_0_5_2,
                    TIPO_DICHIARAZIONE,
                    PO_TR_TUNNEL_1_2_1_0_5_3O4,
                    KM_INIZIO,
                    CODICE_VERSIONE
              From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO);

  DBMS_OUTPUT.PUT_LINE('DICHIARAZIONI_GALLERIE_BIN_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

 EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert DICHIARAZIONI_GALLERIE_BIN_PO - Errore: '|| Substr(SQLERRM, 1, 300));
 		p_errore := 0;
END;

-- --------------------------------------------------------------------------------------
-- Marciapiedi versione precedente
-- --------------------------------------------------------------------------------------

Begin
      Insert Into Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO  (
           PO_TR_PLATFORM_1_2_1_0_6_1,
           PO_TR_PLATFORM_1_2_1_0_6_2,
           PO_TR_PLATFORM_1_2_1_0_6_2_D,
           PO_TR_PLATFORM_1_2_1_0_6_3_AP,
           --PO_TR_PLATFORM_1_2_1_0_6_3,                 --multiplo
           PO_TR_PLAT_1_2_1_0_6_4_B1_AP,
           PO_TR_PLATFORM_1_2_1_0_6_4_B1,
           PO_TR_PLAT_1_2_1_0_6_4_B2_AP,
           PO_TR_PLATFORM_1_2_1_0_6_4_B2,
           PO_TR_PLAT_1_2_1_0_6_4_B3_AP,
           PO_TR_PLATFORM_1_2_1_0_6_4_B3,
           PO_TR_PLAT_1_2_1_0_6_4_B4_AP,             --aggiunto da Alessio errore segnalato da mail Autiero 27/10/2016
           PO_TR_PLATFORM_1_2_1_0_6_4_B4,
           PO_TR_PLAT_1_2_1_0_6_5_B1_AP,
           PO_TR_PLATFORM_1_2_1_0_6_5_B1,
           PO_TR_PLAT_1_2_1_0_6_5_B2_AP,
           PO_TR_PLATFORM_1_2_1_0_6_5_B2,
           PO_TR_PLAT_1_2_1_0_6_5_B3_AP,
           PO_TR_PLATFORM_1_2_1_0_6_5_B3,
           PO_TR_PLAT_1_2_1_0_6_5_B4_AP,             --aggiunto da Alessio errore segnalato da mail Autiero 27/10/2016
           PO_TR_PLATFORM_1_2_1_0_6_5_B4,
           PO_TR_PLATFORM_1_2_1_0_6_6_AP,
           PO_TR_PLATFORM_1_2_1_0_6_6,
           PO_TR_PLATFORM_1_2_1_0_6_7_AP,
           PO_TR_PLATFORM_1_2_1_0_6_7,
           BINARIO_1,
           BINARIO_2,
           BINARIO_3,
           BINARIO_4,
           CODICE_VERSIONE,
           GRUPPO_AUTORIZZATIVO)
      Select
           PO_TR_PLATFORM_1_2_1_0_6_1,
           PO_TR_PLATFORM_1_2_1_0_6_2,
           PO_TR_PLATFORM_1_2_1_0_6_2_D,
           PO_TR_PLATFORM_1_2_1_0_6_3_AP,
           --PO_TR_PLATFORM_1_2_1_0_6_3,                 --multiplo
           PO_TR_PLAT_1_2_1_0_6_4_B1_AP,
           PO_TR_PLATFORM_1_2_1_0_6_4_B1,
           PO_TR_PLAT_1_2_1_0_6_4_B2_AP,
           PO_TR_PLATFORM_1_2_1_0_6_4_B2,
           PO_TR_PLAT_1_2_1_0_6_4_B3_AP,
           PO_TR_PLATFORM_1_2_1_0_6_4_B3,
           PO_TR_PLAT_1_2_1_0_6_4_B4_AP,             --aggiunto da Alessio errore segnalato da mail Autiero 27/10/2016
           PO_TR_PLATFORM_1_2_1_0_6_4_B4,
           PO_TR_PLAT_1_2_1_0_6_5_B1_AP,
           PO_TR_PLATFORM_1_2_1_0_6_5_B1,
           PO_TR_PLAT_1_2_1_0_6_5_B2_AP,
           PO_TR_PLATFORM_1_2_1_0_6_5_B2,
           PO_TR_PLAT_1_2_1_0_6_5_B3_AP,
           PO_TR_PLATFORM_1_2_1_0_6_5_B3,
           PO_TR_PLAT_1_2_1_0_6_5_B4_AP,             --aggiunto da Alessio errore segnalato da mail Autiero 27/10/2016
           PO_TR_PLATFORM_1_2_1_0_6_5_B4,
           PO_TR_PLATFORM_1_2_1_0_6_6_AP,
           PO_TR_PLATFORM_1_2_1_0_6_6,
           PO_TR_PLATFORM_1_2_1_0_6_7_AP,
           PO_TR_PLATFORM_1_2_1_0_6_7,
           BINARIO_1                       ,
           BINARIO_2                       ,
           BINARIO_3                       ,
           BINARIO_4,
           CODICE_VERSIONE,
           GRUPPO_AUTORIZZATIVO
      From
      (Select
             PO_TR_PLATFORM_1_2_1_0_6_1,
             PO_TR_PLATFORM_1_2_1_0_6_2,
             PO_TR_PLATFORM_1_2_1_0_6_2_D,
             PO_TR_PLATFORM_1_2_1_0_6_3_AP,
             --PO_TR_PLATFORM_1_2_1_0_6_3,                 --multiplo
             PO_TR_PLAT_1_2_1_0_6_4_B1_AP,
             PO_TR_PLATFORM_1_2_1_0_6_4_B1,
             PO_TR_PLAT_1_2_1_0_6_4_B2_AP,
             PO_TR_PLATFORM_1_2_1_0_6_4_B2,
             PO_TR_PLAT_1_2_1_0_6_4_B3_AP,
             PO_TR_PLATFORM_1_2_1_0_6_4_B3,
             PO_TR_PLAT_1_2_1_0_6_4_B4_AP,             --aggiunto da Alessio errore segnalato da mail Autiero 27/10/2016
             PO_TR_PLATFORM_1_2_1_0_6_4_B4,
             PO_TR_PLAT_1_2_1_0_6_5_B1_AP,
             PO_TR_PLATFORM_1_2_1_0_6_5_B1,
             PO_TR_PLAT_1_2_1_0_6_5_B2_AP,
             PO_TR_PLATFORM_1_2_1_0_6_5_B2,
             PO_TR_PLAT_1_2_1_0_6_5_B3_AP,
             PO_TR_PLATFORM_1_2_1_0_6_5_B3,
             PO_TR_PLAT_1_2_1_0_6_5_B4_AP,             --aggiunto da Alessio errore segnalato da mail Autiero 27/10/2016
             PO_TR_PLATFORM_1_2_1_0_6_5_B4,
             PO_TR_PLATFORM_1_2_1_0_6_6_AP,
             PO_TR_PLATFORM_1_2_1_0_6_6,
             PO_TR_PLATFORM_1_2_1_0_6_7_AP,
             PO_TR_PLATFORM_1_2_1_0_6_7,
             BINARIO_1                       ,
             BINARIO_2                       ,
             BINARIO_3                       ,
             BINARIO_4,
             p_versione CODICE_VERSIONE,
             m.GRUPPO_AUTORIZZATIVO
        From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO m,
             Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
             Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA  r
       Where m.BINARIO_1 = b.PO_TRACK_1_2_1_0_0_2 
         And m.CODICE_VERSIONE = b.CODICE_VERSIONE 
         And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 
         And r.CODICE_VERSIONE = b.CODICE_VERSIONE
         And r.SEDE_TECNICA = p_SEDE_TECNICA 
         And r.CODICE_VERSIONE = p_versione -1
     Union
      Select
             PO_TR_PLATFORM_1_2_1_0_6_1,
             PO_TR_PLATFORM_1_2_1_0_6_2,
             PO_TR_PLATFORM_1_2_1_0_6_2_D,
             PO_TR_PLATFORM_1_2_1_0_6_3_AP,
             --PO_TR_PLATFORM_1_2_1_0_6_3,                 --multiplo
             PO_TR_PLAT_1_2_1_0_6_4_B1_AP,
             PO_TR_PLATFORM_1_2_1_0_6_4_B1,
             PO_TR_PLAT_1_2_1_0_6_4_B2_AP,
             PO_TR_PLATFORM_1_2_1_0_6_4_B2,
             PO_TR_PLAT_1_2_1_0_6_4_B3_AP,
             PO_TR_PLATFORM_1_2_1_0_6_4_B3,
             PO_TR_PLAT_1_2_1_0_6_4_B4_AP,             --aggiunto da Alessio errore segnalato da mail Autiero 27/10/2016
             PO_TR_PLATFORM_1_2_1_0_6_4_B4,
             PO_TR_PLAT_1_2_1_0_6_5_B1_AP,
             PO_TR_PLATFORM_1_2_1_0_6_5_B1,
             PO_TR_PLAT_1_2_1_0_6_5_B2_AP,
             PO_TR_PLATFORM_1_2_1_0_6_5_B2,
             PO_TR_PLAT_1_2_1_0_6_5_B3_AP,
             PO_TR_PLATFORM_1_2_1_0_6_5_B3,
             PO_TR_PLAT_1_2_1_0_6_5_B4_AP,             --aggiunto da Alessio errore segnalato da mail Autiero 27/10/2016
             PO_TR_PLATFORM_1_2_1_0_6_5_B4,
             PO_TR_PLATFORM_1_2_1_0_6_6_AP,
             PO_TR_PLATFORM_1_2_1_0_6_6,
             PO_TR_PLATFORM_1_2_1_0_6_7_AP,
             PO_TR_PLATFORM_1_2_1_0_6_7,
             BINARIO_1                       ,
             BINARIO_2                       ,
             BINARIO_3                       ,
             BINARIO_4,
             p_versione,
             m.GRUPPO_AUTORIZZATIVO
        From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO m,
             Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
             Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA  r
       Where m.BINARIO_2 = b.PO_TRACK_1_2_1_0_0_2 
         And m.CODICE_VERSIONE = b.CODICE_VERSIONE 
         And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 
         And r.CODICE_VERSIONE = b.CODICE_VERSIONE
         And r.SEDE_TECNICA = p_SEDE_TECNICA 
         And r.CODICE_VERSIONE = p_versione -1
     Union
       Select
             PO_TR_PLATFORM_1_2_1_0_6_1,
             PO_TR_PLATFORM_1_2_1_0_6_2,
             PO_TR_PLATFORM_1_2_1_0_6_2_D,
             PO_TR_PLATFORM_1_2_1_0_6_3_AP,
             --PO_TR_PLATFORM_1_2_1_0_6_3,                 --multiplo
             PO_TR_PLAT_1_2_1_0_6_4_B1_AP,
             PO_TR_PLATFORM_1_2_1_0_6_4_B1,
             PO_TR_PLAT_1_2_1_0_6_4_B2_AP,
             PO_TR_PLATFORM_1_2_1_0_6_4_B2,
             PO_TR_PLAT_1_2_1_0_6_4_B3_AP,
             PO_TR_PLATFORM_1_2_1_0_6_4_B3,
             PO_TR_PLAT_1_2_1_0_6_4_B4_AP,             --aggiunto da Alessio errore segnalato da mail Autiero 27/10/2016
             PO_TR_PLATFORM_1_2_1_0_6_4_B4,
             PO_TR_PLAT_1_2_1_0_6_5_B1_AP,
             PO_TR_PLATFORM_1_2_1_0_6_5_B1,
             PO_TR_PLAT_1_2_1_0_6_5_B2_AP,
             PO_TR_PLATFORM_1_2_1_0_6_5_B2,
             PO_TR_PLAT_1_2_1_0_6_5_B3_AP,
             PO_TR_PLATFORM_1_2_1_0_6_5_B3,
             PO_TR_PLAT_1_2_1_0_6_5_B4_AP,             --aggiunto da Alessio errore segnalato da mail Autiero 27/10/2016
             PO_TR_PLATFORM_1_2_1_0_6_5_B4,
             PO_TR_PLATFORM_1_2_1_0_6_6_AP,
             PO_TR_PLATFORM_1_2_1_0_6_6,
             PO_TR_PLATFORM_1_2_1_0_6_7_AP,
             PO_TR_PLATFORM_1_2_1_0_6_7,
             BINARIO_1                       ,
             BINARIO_2                       ,
             BINARIO_3                       ,
             BINARIO_4,
             p_versione,
             m.GRUPPO_AUTORIZZATIVO
        From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO m,
             Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
             Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA  r
       Where m.BINARIO_3 = b.PO_TRACK_1_2_1_0_0_2 
         And m.CODICE_VERSIONE = b.CODICE_VERSIONE 
         And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 
         And r.CODICE_VERSIONE = b.CODICE_VERSIONE
         And r.SEDE_TECNICA = p_SEDE_TECNICA 
         And r.CODICE_VERSIONE = p_versione -1
     Union
       Select
            PO_TR_PLATFORM_1_2_1_0_6_1,
            PO_TR_PLATFORM_1_2_1_0_6_2,
            PO_TR_PLATFORM_1_2_1_0_6_2_D,
            PO_TR_PLATFORM_1_2_1_0_6_3_AP,
            --PO_TR_PLATFORM_1_2_1_0_6_3,                 --multiplo
            PO_TR_PLAT_1_2_1_0_6_4_B1_AP,
            PO_TR_PLATFORM_1_2_1_0_6_4_B1,
            PO_TR_PLAT_1_2_1_0_6_4_B2_AP,
            PO_TR_PLATFORM_1_2_1_0_6_4_B2,
            PO_TR_PLAT_1_2_1_0_6_4_B3_AP,
            PO_TR_PLATFORM_1_2_1_0_6_4_B3,
            PO_TR_PLAT_1_2_1_0_6_4_B4_AP,             --aggiunto da Alessio errore segnalato da mail Autiero 27/10/2016
            PO_TR_PLATFORM_1_2_1_0_6_4_B4,
            PO_TR_PLAT_1_2_1_0_6_5_B1_AP,
            PO_TR_PLATFORM_1_2_1_0_6_5_B1,
            PO_TR_PLAT_1_2_1_0_6_5_B2_AP,
            PO_TR_PLATFORM_1_2_1_0_6_5_B2,
            PO_TR_PLAT_1_2_1_0_6_5_B3_AP,
            PO_TR_PLATFORM_1_2_1_0_6_5_B3,
            PO_TR_PLAT_1_2_1_0_6_5_B4_AP,             --aggiunto da Alessio errore segnalato da mail Autiero 27/10/2016
            PO_TR_PLATFORM_1_2_1_0_6_5_B4,
            PO_TR_PLATFORM_1_2_1_0_6_6_AP,
            PO_TR_PLATFORM_1_2_1_0_6_6,
            PO_TR_PLATFORM_1_2_1_0_6_7_AP,
            PO_TR_PLATFORM_1_2_1_0_6_7,
            BINARIO_1                       ,
            BINARIO_2                       ,
            BINARIO_3                       ,
            BINARIO_4,
            p_versione,
            m.GRUPPO_AUTORIZZATIVO
        From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO m,
             Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
             Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA  r
      Where m.BINARIO_4 = b.PO_TRACK_1_2_1_0_0_2 
         And m.CODICE_VERSIONE = b.CODICE_VERSIONE 
         And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 
         And r.CODICE_VERSIONE = b.CODICE_VERSIONE
         And r.SEDE_TECNICA = p_SEDE_TECNICA 
         And r.CODICE_VERSIONE = p_versione -1 
	  )
    Where (PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE)  Not In 
   (Select PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE
      From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO );

  DBMS_OUTPUT.PUT_LINE('MARCIAPIEDI_BINARI_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
--
 EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert MARCIAPIEDI_BINARI_PO - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Binari di raccordo versione precedente
-- --------------------------------------------------------------------------------------

Begin
    Insert Into Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO (
            PO_SD_1_2_2_0_0_1,
            PO_SD_1_2_2_0_0_2,
            PO_SD_1_2_2_0_0_2_D,
            PO_SD_1_2_2_0_0_3_AP,
--            PO_SD_1_2_2_0_0_3,                    --multiplo
            PO_SD_1_2_2_0_2_1_AP,
            PO_SD_1_2_2_0_2_1,
            PO_SD_1_2_2_0_3_1_AP,
            PO_SD_1_2_2_0_3_1,
            PO_SD_1_2_2_0_3_2_AP,
            PO_SD_1_2_2_0_3_2,
            PO_SD_1_2_2_0_3_3_AP,
            PO_SD_1_2_2_0_3_3_A,
            PO_SD_1_2_2_0_3_3_B,
            PO_SD_1_2_2_0_4_1_AP,
            PO_SD_1_2_2_0_4_1,
            PO_SD_1_2_2_0_4_2_AP,
            PO_SD_1_2_2_0_4_2,
            PO_SD_1_2_2_0_4_3_AP,
            PO_SD_1_2_2_0_4_3,
            PO_SD_1_2_2_0_4_4_AP,
            PO_SD_1_2_2_0_4_4,
            PO_SD_1_2_2_0_4_5_AP,
            PO_SD_1_2_2_0_4_5,
            PO_SD_1_2_2_0_4_6_AP,
            PO_SD_1_2_2_0_4_6,
            SEDE_TECNICA,
            CODICE_VERSIONE,
            GRUPPO_AUTORIZZATIVO,
	        PO_SD_1_2_2_0_6_1_AP,
            PO_SD_1_2_2_0_6_1 			)                  -- 1.2.2.0.6.1 Parametro Reg.777/2019
    Select
            PO_SD_1_2_2_0_0_1,
            PO_SD_1_2_2_0_0_2,
            PO_SD_1_2_2_0_0_2_D,
            PO_SD_1_2_2_0_0_3_AP,
            --PO_SD_1_2_2_0_0_3,                    --multiplo
            PO_SD_1_2_2_0_2_1_AP,
            PO_SD_1_2_2_0_2_1,
            PO_SD_1_2_2_0_3_1_AP,
            PO_SD_1_2_2_0_3_1,
            PO_SD_1_2_2_0_3_2_AP,
            PO_SD_1_2_2_0_3_2,
            PO_SD_1_2_2_0_3_3_AP,
            PO_SD_1_2_2_0_3_3_A,
            PO_SD_1_2_2_0_3_3_B,
            PO_SD_1_2_2_0_4_1_AP,
            PO_SD_1_2_2_0_4_1,
            PO_SD_1_2_2_0_4_2_AP,
            PO_SD_1_2_2_0_4_2,
            PO_SD_1_2_2_0_4_3_AP,
            PO_SD_1_2_2_0_4_3,
            PO_SD_1_2_2_0_4_4_AP,
            PO_SD_1_2_2_0_4_4,
            PO_SD_1_2_2_0_4_5_AP,
            PO_SD_1_2_2_0_4_5,
            PO_SD_1_2_2_0_4_6_AP,
            PO_SD_1_2_2_0_4_6,
            b.SEDE_TECNICA,
            p_versione,
            GRUPPO_AUTORIZZATIVO,
	        PO_SD_1_2_2_0_6_1_AP,
            PO_SD_1_2_2_0_6_1                              -- 1.2.2.0.6.1 Parametro Reg.777/2019
	   From Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO b
      Where b.SEDE_TECNICA = p_SEDE_TECNICA 
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('BINARI_RACCORDO_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
--
 EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert BINARI_RACCORDO_PO - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
END;

-- --------------------------------------------------------------------------------------
-- Dichiarazioni versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_RACCORDO_PO (
            PO_SD_1_2_2_0_0_2,
            TIPO_DICHIARAZIONE,
            PO_SD_1_2_2_0_1_1O2_AP,
            PO_SD_1_2_2_0_1_1O2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select
            d.PO_SD_1_2_2_0_0_2,
            TIPO_DICHIARAZIONE,
            PO_SD_1_2_2_0_1_1O2_AP,
            PO_SD_1_2_2_0_1_1O2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.DICHIARAZIONI_RACCORDO_PO d,
            Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO b
      Where d.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2 
        And d.CODICE_VERSIONE = b.CODICE_VERSIONE 
	    And b.SEDE_TECNICA = p_SEDE_TECNICA 
	    And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('DICHIARAZIONI_RACCORDO_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

 EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert DICHIARAZIONI_RACCORDO_PO - Errore: '|| Substr(SQLERRM, 1, 300));
 		p_errore := 0;
END;

-- --------------------------------------------------------------------------------------
-- Gallerie versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.GALLERIE_RACCORDO_PO (
            PO_SD_TUNNEL_1_2_2_0_5_1,
            PO_SD_TUNNEL_1_2_2_0_5_2,
            PO_SD_TUNNEL_1_2_2_0_5_2_D,
            PO_SD_TUNNEL_1_2_2_0_5_5_AP,
            PO_SD_TUNNEL_1_2_2_0_5_5,
            PO_SD_TUNNEL_1_2_2_0_5_6_AP,
            PO_SD_TUNNEL_1_2_2_0_5_6,
            PO_SD_TUNNEL_1_2_2_0_5_7_AP,
            PO_SD_TUNNEL_1_2_2_0_5_7,
            PO_SD_TUNNEL_1_2_2_0_5_8_AP,
            PO_SD_TUNNEL_1_2_2_0_5_8,
            CODICE_VERSIONE   )
     Select Distinct
            PO_SD_TUNNEL_1_2_2_0_5_1,
            g.PO_SD_TUNNEL_1_2_2_0_5_2,
            PO_SD_TUNNEL_1_2_2_0_5_2_D,
            PO_SD_TUNNEL_1_2_2_0_5_5_AP,
            PO_SD_TUNNEL_1_2_2_0_5_5,
            PO_SD_TUNNEL_1_2_2_0_5_6_AP,
            PO_SD_TUNNEL_1_2_2_0_5_6,
            PO_SD_TUNNEL_1_2_2_0_5_7_AP,
            PO_SD_TUNNEL_1_2_2_0_5_7,
            PO_SD_TUNNEL_1_2_2_0_5_8_AP,
            PO_SD_TUNNEL_1_2_2_0_5_8,
            p_versione
       From Rinf_Pubblicati_Evo.GALLERIE_RACCORDO_PO g,
            Rinf_Pubblicati_Evo.REL_GALLERIE_RACCORDO_PO bg,
            Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO b
      Where g.PO_SD_TUNNEL_1_2_2_0_5_2 = bg.PO_SD_TUNNEL_1_2_2_0_5_2
        And g.CODICE_VERSIONE = bg.CODICE_VERSIONE
        And bg.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('GALLERIE_RACCORDO_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert GALLERIE_RACCORDO_PO - Errore: '|| Substr(SQLERRM, 1, 300));
 		p_errore := 0;
END;

-- --------------------------------------------------------------------------------------
-- Dichiarazioni versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_SD_PO (
            PO_SD_TUNNEL_1_2_2_0_5_2,
            TIPO_DICHIARAZIONE,
            PO_SD_TUNNEL_1_2_2_0_5_3O4_AP,
            PO_SD_TUNNEL_1_2_2_0_5_3O4,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE  )
    Select Distinct
            d.PO_SD_TUNNEL_1_2_2_0_5_2,
            TIPO_DICHIARAZIONE,
            PO_SD_TUNNEL_1_2_2_0_5_3O4_AP,
            PO_SD_TUNNEL_1_2_2_0_5_3O4,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_SD_PO d,
            Rinf_Pubblicati_Evo.GALLERIE_RACCORDO_PO g,
            Rinf_Pubblicati_Evo.REL_GALLERIE_RACCORDO_PO bg,
            Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO b
      Where d.PO_SD_TUNNEL_1_2_2_0_5_2 = g.PO_SD_TUNNEL_1_2_2_0_5_2
        And d.CODICE_VERSIONE = g.CODICE_VERSIONE
        And g.PO_SD_TUNNEL_1_2_2_0_5_2 = bg.PO_SD_TUNNEL_1_2_2_0_5_2
        And g.CODICE_VERSIONE = bg.CODICE_VERSIONE
        And bg.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('DICHIARAZIONI_GALLERIE_SD_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert DICHIARAZIONI_GALLERIE_SD_PO - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Relazioni Gallerie-Sd versione precedente
-- --------------------------------------------------------------------------------------

Begin
    Insert Into Rinf_Pubblicati_Evo.REL_GALLERIE_RACCORDO_PO  (
            PO_SD_TUNNEL_1_2_2_0_5_2,
            PO_SD_1_2_2_0_0_2,
            CODICE_VERSIONE  )
    Select Distinct
            bg.PO_SD_TUNNEL_1_2_2_0_5_2,
            bg.PO_SD_1_2_2_0_0_2,
            p_versione
       From Rinf_Pubblicati_Evo.REL_GALLERIE_RACCORDO_PO bg,
            Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO b
      Where bg.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = P_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('REL_GALLERIE_RACCORDO_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert REL_GALLERIE_RACCORDO_PO - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- CAT TEN PO versione precedente
-- --------------------------------------------------------------------------------------

Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_2_1_0_2_1_CAT_TEN_PO (
            PO_TRACK_1_2_1_0_0_2,
            PO_TRACK_1_2_1_0_2_1,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
    Select Distinct
            bg.PO_TRACK_1_2_1_0_0_2,
            PO_TRACK_1_2_1_0_2_1,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_2_1_0_2_1_CAT_TEN_PO bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
            Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r
      Where bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And r.CODICE_VERSIONE = b.CODICE_VERSIONE
        And r.SEDE_TECNICA = p_SEDE_TECNICA
        And r.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_2_1_0_2_1_CAT_TEN_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_2_1_0_2_1_CAT_TEN_PO - Errore: '|| Substr(SQLERRM, 1, 300));
 		p_errore := 0;
END;
-- --------------------------------------------------------------------------------------
-- CAT LINEA PO versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_2_1_0_2_2_CAT_LINEA (
            PO_TRACK_1_2_1_0_0_2,
            PO_TRACK_1_2_1_0_2_2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
    Select Distinct
            bg.PO_TRACK_1_2_1_0_0_2,
            PO_TRACK_1_2_1_0_2_2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_2_1_0_2_2_CAT_LINEA bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
            Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r
      Where bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And r.CODICE_VERSIONE = b.CODICE_VERSIONE
        And r.SEDE_TECNICA = p_SEDE_TECNICA
        And r.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_2_1_0_2_2_CAT_LINEA record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_2_1_0_2_2_CAT_LINEA - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- CAT TEN PLATFORM versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_2_1_0_6_3_CAT_TEN_PL (
            PO_TR_PLATFORM_1_2_1_0_6_2,
            PO_TR_PLATFORM_1_2_1_0_6_3,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
    Select Distinct
            bg.PO_TR_PLATFORM_1_2_1_0_6_2,
            PO_TR_PLATFORM_1_2_1_0_6_3,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_2_1_0_6_3_CAT_TEN_PL bg,
           (Select PO_TR_PLATFORM_1_2_1_0_6_2, SEDE_TECNICA, b.CODICE_VERSIONE
              From Rinf_Pubblicati_Evo.BINARI_CORSA_PO c,                         --30/03/206 Modificato lo schema dati dei binari,perch  era impostato erroneamente a RINF_AUTORIZZAZIONI_EVO (non trovava binari di riferimento delle vecchie versioni ed il parametro rimaneva vuoto)
                   Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
                   Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO b
             Where c.PO_TRACK_1_2_1_0_0_2 = b.BINARIO_1
               And c.CODICE_VERSIONE = b.CODICE_VERSIONE
               And c.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
               And c.CODICE_VERSIONE = r.CODICE_VERSIONE
           Union
            Select PO_TR_PLATFORM_1_2_1_0_6_2, SEDE_TECNICA, b.CODICE_VERSIONE
              From Rinf_Pubblicati_Evo.BINARI_CORSA_PO c,
                   Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
                   Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO b
            Where c.PO_TRACK_1_2_1_0_0_2 = b.BINARIO_2
              And c.CODICE_VERSIONE = b.CODICE_VERSIONE
              And c.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
              And c.CODICE_VERSIONE = r.CODICE_VERSIONE
           Union
            Select PO_TR_PLATFORM_1_2_1_0_6_2, SEDE_TECNICA, b.CODICE_VERSIONE
              From Rinf_Pubblicati_Evo.BINARI_CORSA_PO c,
                   Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
                   Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO b
             Where c.PO_TRACK_1_2_1_0_0_2 = b.BINARIO_3
               And c.CODICE_VERSIONE = b.CODICE_VERSIONE
               And c.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
               And c.CODICE_VERSIONE = r.CODICE_VERSIONE
           Union
            Select PO_TR_PLATFORM_1_2_1_0_6_2, SEDE_TECNICA, b.CODICE_VERSIONE
              From Rinf_Pubblicati_Evo.BINARI_CORSA_PO c,
                   Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
                   Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO b
             Where c.PO_TRACK_1_2_1_0_0_2 = b.BINARIO_4
               And c.CODICE_VERSIONE = b.CODICE_VERSIONE
               And c.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
               And c.CODICE_VERSIONE = r.CODICE_VERSIONE   ) b
--
      Where bg.PO_TR_PLATFORM_1_2_1_0_6_2 = b.PO_TR_PLATFORM_1_2_1_0_6_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.CODICE_VERSIONE = p_versione -1
        And b.SEDE_TECNICA = p_SEDE_TECNICA;

  DBMS_OUTPUT.PUT_LINE('PAR_1_2_1_0_6_3_CAT_TEN_PL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_2_1_0_6_3_CAT_TEN_PL - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- CAT TEN SD versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_2_2_0_0_3_CAT_TEN_SD (
            PO_SD_1_2_2_0_0_2,
            PO_SD_1_2_2_0_0_3,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE  )
     Select bg.PO_SD_1_2_2_0_0_2,
            PO_SD_1_2_2_0_0_3,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_2_2_0_0_3_CAT_TEN_SD bg,
            Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO b
      Where bg.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_2_2_0_0_3_CAT_TEN_SD record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_2_2_0_0_3_CAT_TEN_SD - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Relazioni Op-Corridoio versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.CORRIDOIO_PO
           (CODICE_CORRIDOIO, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_CORRIDOIO,
            p.SEDE_TECNICA,
            p_versione
       From Rinf_Pubblicati_Evo.CORRIDOIO_PO p
      Where p.SEDE_TECNICA = p_SEDE_TECNICA
        And p.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('CORRIDOIO_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert CORRIDOIO_PO - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Relazioni OP-Linee Ten versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.LINEE_TENT_PO
            (CODICE_LINEA_TENT, SEDE_TECNICA, CODICE_VERSIONE)
      Select CODICE_LINEA_TENT,
             p.SEDE_TECNICA,
             p_versione
        From Rinf_Pubblicati_Evo.LINEE_TENT_PO p
       Where p.SEDE_TECNICA = p_SEDE_TECNICA 
	 And p.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('LINEE_TENT_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert LINEE_TENT_PO - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Relazione OP-Linee Comm versione precedente
-- --------------------------------------------------------------------------------------

 Begin
     Insert Into Rinf_Pubblicati_Evo.LINEA_COMM_PO
            (CODICE_GIURISDIZIONE, SEDE_TECNICA, CODICE_VERSIONE, KM_INIZIO)
      Select CODICE_GIURISDIZIONE,
             p.SEDE_TECNICA,
             p_versione,
             KM_INIZIO
        From Rinf_Pubblicati_Evo.LINEA_COMM_PO p
       Where p.SEDE_TECNICA = p_SEDE_TECNICA
         And p.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('LINEA_COMM_PO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert LINEA_COMM_PO - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Relazione OP-SOL Linee Comm fittizie versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.LINEA_TRIPLETTA
           (CODICE_LINEA, SEDE_TECNICA, CODICE_VERSIONE, LINEA_ORIGINE)
     Select CODICE_LINEA,
            p.SEDE_TECNICA,
            p_versione,
            LINEA_ORIGINE
       From Rinf_Pubblicati_Evo.LINEA_TRIPLETTA p
      Where p.SEDE_TECNICA = p_SEDE_TECNICA
        And p.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('LINEA_TRIPLETTA record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert LINEA_TRIPLETTA - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- NORME_DOC PO versione precedente
-- --------------------------------------------------------------------------------------

 Begin
     Insert Into Rinf_Pubblicati_Evo.PAR_1_2_3_2_DOC_NORME
             (SEDE_TECNICA, PO_1_2_3_2, CODICE_VERSIONE)
     Select b.SEDE_TECNICA, PO_1_2_3_2, p_versione
       From Rinf_Pubblicati_Evo.PAR_1_2_3_2_DOC_NORME b
      Where b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_2_3_2_DOC_norme record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_2_3_2_DOC_norme - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------
--
End Rispristina_Pubblicati_PO;



-- --------------------------------------------------------------------------------------
--         Procedure Rispristina_Pubblicati_SOL
-- --------------------------------------------------------------------------------------
--
 Procedure Rispristina_Pubblicati_SOL (p_SEDE_TECNICA varchar2, p_versione Number, p_errore out Number ) is

 Begin
	p_errore := 1;

--                             SOL
-- --------------------------------------------------------------------------------------
-- SOL versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.SEZIONI_LINEA (
	        SEDE_TECNICA,
            DEFINIZIONE,
            STATO_SISTEMA,
            STATO_UTENTE,
            LOCALITA_CONTENITORE,
            LOCALITA_INIZIO,
            LOCALITA_FINE,
            KM_INIZIO,
            KM_FINE,
            SOL_1_1_0_0_0_1,
            SOL_1_1_0_0_0_3,
            SOL_1_1_0_0_0_4,
            SOL_1_1_0_0_0_5,
            SOL_1_1_0_0_0_6,
            REGIME_CIRCOLAZIONE,
            CODICE_LINEA_TECNICA,
            CODICE_DTP,
            CODICE_UT,
            CODICE_VERSIONE,
            GRUPPO_AUTORIZZATIVO,
            CACHE_FIELD    )
     Select SEDE_TECNICA,
            DEFINIZIONE,
            STATO_SISTEMA,
            STATO_UTENTE,
            LOCALITA_CONTENITORE,
            LOCALITA_INIZIO,
            LOCALITA_FINE,
            KM_INIZIO,
            KM_FINE,
            SOL_1_1_0_0_0_1,
            SOL_1_1_0_0_0_3,
            SOL_1_1_0_0_0_4,
            SOL_1_1_0_0_0_5,
            SOL_1_1_0_0_0_6,
            REGIME_CIRCOLAZIONE,
            CODICE_LINEA_TECNICA,
            CODICE_DTP,
            CODICE_UT,
            p_versione,
            GRUPPO_AUTORIZZATIVO,
            CACHE_FIELD
       From Rinf_Pubblicati_Evo.SEZIONI_LINEA
      Where CODICE_VERSIONE = p_versione -1
	    And SEDE_TECNICA = p_SEDE_TECNICA;

  DBMS_OUTPUT.PUT_LINE('SEZIONI_LINEA record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert SEZIONI_LINEA - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Binari SOL versione precedente
-- --------------------------------------------------------------------------------------

Begin
    Insert Into Rinf_Pubblicati_Evo.BINARI_CORSA_SOL (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_0_0_1_D,
            SOL_TRACK_1_1_1_0_0_2,
            SOL_TRACK_1_1_1_1_2_1_AP,
--            SOL_TRACK_1_1_1_1_2_1,
            SOL_TRACK_1_1_1_1_2_2_AP,
--            SOL_TRACK_1_1_1_1_2_2,
            SOL_TRACK_1_1_1_1_2_3_AP,
--             SOL_TRACK_1_1_1_1_2_3,
            SOL_TRACK_1_1_1_1_2_4_AP,
--             SOL_TRACK_1_1_1_1_2_4,
            SOL_TRACK_1_1_1_1_2_5_AP,
            SOL_TRACK_1_1_1_1_2_5,
            SOL_TRACK_1_1_1_1_2_6_AP,
            SOL_TRACK_1_1_1_1_2_6,
            SOL_TRACK_1_1_1_1_2_7_AP,
            SOL_TRACK_1_1_1_1_2_7,
            SOL_TRACK_1_1_1_1_2_8_AP,
            SOL_TRACK_1_1_1_1_2_8,
            SOL_TRACK_1_1_1_1_3_1_AP,
            SOL_TRACK_1_1_1_1_3_1,
            SOL_TRACK_1_1_1_1_3_2_AP,
            SOL_TRACK_1_1_1_1_3_2,
            SOL_TRACK_1_1_1_1_3_3_AP,
            SOL_TRACK_1_1_1_1_3_3,
            SOL_TRACK_1_1_1_1_3_4_AP,
--            SOL_TRACK_1_1_1_1_3_4,
            SOL_TRACK_1_1_1_1_3_5_AP,
--            SOL_TRACK_1_1_1_1_3_5,
            SOL_TRACK_1_1_1_1_3_6_AP,
--            SOL_TRACK_1_1_1_1_3_6,
            SOL_TRACK_1_1_1_1_3_7_AP,
            SOL_TRACK_1_1_1_1_3_7,
            SOL_TRACK_1_1_1_1_4_1_AP,
            SOL_TRACK_1_1_1_1_4_1,
            SOL_TRACK_1_1_1_1_4_2_AP,
            SOL_TRACK_1_1_1_1_4_2,
            SOL_TRACK_1_1_1_1_4_3_AP,
            SOL_TRACK_1_1_1_1_4_3,
            SOL_TRACK_1_1_1_1_4_4_AP,
            SOL_TRACK_1_1_1_1_4_4,
            SOL_TRACK_1_1_1_1_5_1_AP,
            SOL_TRACK_1_1_1_1_5_1,
            SOL_TRACK_1_1_1_1_5_2_AP,
            SOL_TRACK_1_1_1_1_5_2,
            SOL_TRACK_1_1_1_1_6_1_AP,
            SOL_TRACK_1_1_1_1_6_1,
            SOL_TRACK_1_1_1_1_6_2_AP,
            SOL_TRACK_1_1_1_1_6_2,
            SOL_TRACK_1_1_1_1_6_3_AP,
            SOL_TRACK_1_1_1_1_6_3,
            SOL_TRACK_1_1_1_1_7_1_AP,
            SOL_TRACK_1_1_1_1_7_1,
            SOL_TRACK_1_1_1_1_7_2_AP,
            SOL_TRACK_1_1_1_1_7_2,
            SOL_TRACK_1_1_1_1_7_3_AP,
            SOL_TRACK_1_1_1_1_7_3,
            SOL_TRACK_1_1_1_2_2_1_1_AP,
            SOL_TRACK_1_1_1_2_2_1_1,
            SOL_TRACK_1_1_1_2_2_1_2_AP,
            SOL_TRACK_1_1_1_2_2_1_2,
            SOL_TRACK_1_1_1_2_2_2_AP,
            SOL_TRACK_1_1_1_2_2_2,
            SOL_TRACK_1_1_1_2_2_3_AP,
            SOL_TRACK_1_1_1_2_2_3,
            SOL_TRACK_1_1_1_2_2_4_AP,
            SOL_TRACK_1_1_1_2_2_4,
            SOL_TRACK_1_1_1_2_2_5_AP,
            SOL_TRACK_1_1_1_2_2_5,
            SOL_TRACK_1_1_1_2_2_6_AP,
            SOL_TRACK_1_1_1_2_2_6,
            SOL_TRACK_1_1_1_2_3_1_AP,
            SOL_TRACK_1_1_1_2_3_1,
            SOL_TRACK_1_1_1_2_3_2_AP,
            SOL_TRACK_1_1_1_2_3_2,
            SOL_TRACK_1_1_1_2_3_3_AP,
            SOL_TRACK_1_1_1_2_3_3_A,
            SOL_TRACK_1_1_1_2_3_3_B,
            SOL_TRACK_1_1_1_2_3_3_C,
            SOL_TRACK_1_1_1_2_3_4_AP,
            SOL_TRACK_1_1_1_2_3_4,
            SOL_TRACK_1_1_1_2_4_1_1_AP,
            SOL_TRACK_1_1_1_2_4_1_1,
            SOL_TRACK_1_1_1_2_4_1_2_AP,
            SOL_TRACK_1_1_1_2_4_1_2_A,
            SOL_TRACK_1_1_1_2_4_1_2_B,
            SOL_TRACK_1_1_1_2_4_1_2_C,
            SOL_TRACK_1_1_1_2_4_2_1_AP,
            SOL_TRACK_1_1_1_2_4_2_1,
            SOL_TRACK_1_1_1_2_4_2_2_AP,
            SOL_TRACK_1_1_1_2_4_2_2_A,
            SOL_TRACK_1_1_1_2_4_2_2_B,
            SOL_TRACK_1_1_1_2_4_2_2_C,
            SOL_TRACK_1_1_1_2_4_2_2_D,
            SOL_TRACK_1_1_1_2_5_1_AP,
            SOL_TRACK_1_1_1_2_5_1,
            SOL_TRACK_1_1_1_2_5_2_AP,
            SOL_TRACK_1_1_1_2_5_2,
            SOL_TRACK_1_1_1_2_5_3_AP,
            SOL_TRACK_1_1_1_2_5_3,
            SOL_TRACK_1_1_1_3_2_1_AP,
            SOL_TRACK_1_1_1_3_2_1,
            SOL_TRACK_1_1_1_3_2_2_AP,
            SOL_TRACK_1_1_1_3_2_2,
            SOL_TRACK_1_1_1_3_2_3_AP,
            SOL_TRACK_1_1_1_3_2_3,
            SOL_TRACK_1_1_1_3_2_4_AP,
            SOL_TRACK_1_1_1_3_2_4,
            SOL_TRACK_1_1_1_3_2_5_AP,
            SOL_TRACK_1_1_1_3_2_5,
            SOL_TRACK_1_1_1_3_2_6_AP,
            SOL_TRACK_1_1_1_3_2_6,
            SOL_TRACK_1_1_1_3_2_7_AP,
            SOL_TRACK_1_1_1_3_2_7,
            SOL_TRACK_1_1_1_3_3_1_AP,
            SOL_TRACK_1_1_1_3_3_1,
            SOL_TRACK_1_1_1_3_3_2_AP,
            SOL_TRACK_1_1_1_3_3_2,
            SOL_TRACK_1_1_1_3_3_3_AP,
--            SOL_TRACK_1_1_1_3_3_3,
            SOL_TRACK_1_1_1_3_4_1_AP,
            SOL_TRACK_1_1_1_3_4_1,
            SOL_TRACK_1_1_1_3_5_1_AP,
            SOL_TRACK_1_1_1_3_5_1,
            SOL_TRACK_1_1_1_3_5_2_AP,
            SOL_TRACK_1_1_1_3_5_2,
            SOL_TRACK_1_1_1_3_6_1_AP,
            SOL_TRACK_1_1_1_3_6_1,
            SOL_TRACK_1_1_1_3_7_1_AP,
            SOL_TRACK_1_1_1_3_7_1,
            SOL_TRACK_1_1_1_3_7_2_1_AP,
            SOL_TRACK_1_1_1_3_7_2_1,
            SOL_TRACK_1_1_1_3_7_2_2_AP,
            SOL_TRACK_1_1_1_3_7_2_2,
            SOL_TRACK_1_1_1_3_7_3_AP,
            SOL_TRACK_1_1_1_3_7_3,
            SOL_TRACK_1_1_1_3_7_4_AP,
            SOL_TRACK_1_1_1_3_7_4,
            SOL_TRACK_1_1_1_3_7_5_AP,
            SOL_TRACK_1_1_1_3_7_5,
            SOL_TRACK_1_1_1_3_7_6_AP,
            SOL_TRACK_1_1_1_3_7_6,
            SOL_TRACK_1_1_1_3_7_7_AP,
            SOL_TRACK_1_1_1_3_7_7,
            SOL_TRACK_1_1_1_3_7_8_AP,
            SOL_TRACK_1_1_1_3_7_8,
            SOL_TRACK_1_1_1_3_7_9_AP,
            SOL_TRACK_1_1_1_3_7_9,
            SOL_TRACK_1_1_1_3_7_10_AP,
            SOL_TRACK_1_1_1_3_7_10,
            SOL_TRACK_1_1_1_3_7_11_AP,
            SOL_TRACK_1_1_1_3_7_11,
            SOL_TRACK_1_1_1_3_7_12_AP,
            SOL_TRACK_1_1_1_3_7_12,
            SOL_TRACK_1_1_1_3_7_13_AP,
            SOL_TRACK_1_1_1_3_7_13,
            SOL_TRACK_1_1_1_3_7_14_AP,
            SOL_TRACK_1_1_1_3_7_14,
            SOL_TRACK_1_1_1_3_7_15_1_AP,
            SOL_TRACK_1_1_1_3_7_15_1,
            SOL_TRACK_1_1_1_3_7_15_2_AP,
            SOL_TRACK_1_1_1_3_7_15_2,
            SOL_TRACK_1_1_1_3_7_16_AP,
            SOL_TRACK_1_1_1_3_7_16,
            SOL_TRACK_1_1_1_3_7_17_AP,
            SOL_TRACK_1_1_1_3_7_17,
            SOL_TRACK_1_1_1_3_7_18_AP,
            SOL_TRACK_1_1_1_3_7_18,
            SOL_TRACK_1_1_1_3_7_19_AP,
            SOL_TRACK_1_1_1_3_7_19,
            SOL_TRACK_1_1_1_3_7_20_AP,
            SOL_TRACK_1_1_1_3_7_20,
            SOL_TRACK_1_1_1_3_7_21_AP,
            SOL_TRACK_1_1_1_3_7_21,
            SOL_TRACK_1_1_1_3_7_22_AP,
            SOL_TRACK_1_1_1_3_7_22,
            SOL_TRACK_1_1_1_3_7_23_AP,
            SOL_TRACK_1_1_1_3_7_23,
            SOL_TRACK_1_1_1_3_8_1_AP,
            SOL_TRACK_1_1_1_3_8_1,
            SOL_TRACK_1_1_1_3_8_2_AP,
            SOL_TRACK_1_1_1_3_8_2,
            SOL_TRACK_1_1_1_3_9_1_AP,
            SOL_TRACK_1_1_1_3_9_1,
            SOL_TRACK_1_1_1_3_9_2_AP,
            SOL_TRACK_1_1_1_3_9_2,
            SOL_TRACK_1_1_1_3_10_1_AP,
            SOL_TRACK_1_1_1_3_10_1,
            SOL_TRACK_1_1_1_3_10_2_AP,
            SOL_TRACK_1_1_1_3_10_2,
            SOL_TRACK_1_1_1_3_11_1_AP,
            SOL_TRACK_1_1_1_3_11_1,
            SOL_TRACK_1_1_1_3_12_1_AP,
            SOL_TRACK_1_1_1_3_12_1,
            TIPO_BINARIO,
            SEDE_TECNICA,
            CODICE_VERSIONE,
            GRUPPO_AUTORIZZATIVO,
	        SOL_TRACK_1_1_1_1_2_4_1_AP      ,              --  NUOVI PARAMETRI Reg.2019/777
            SOL_TRACK_1_1_1_1_2_4_1         ,
            SOL_TRACK_1_1_1_1_2_4_2_AP      ,
            SOL_TRACK_1_1_1_1_2_4_2         ,
            SOL_TRACK_1_1_1_1_2_4_3_AP      ,
            SOL_TRACK_1_1_1_1_2_4_4_AP      ,
            SOL_TRACK_1_1_1_1_2_4_4         ,
            SOL_TRACK_1_1_1_1_3_1_1_AP      ,
            SOL_TRACK_1_1_1_1_3_1_1_INF     ,
            SOL_TRACK_1_1_1_1_3_1_1_SUP     ,
            SOL_TRACK_1_1_1_1_3_1_2_AP      ,
            SOL_TRACK_1_1_1_1_3_1_2         ,
            SOL_TRACK_1_1_1_1_3_1_3_AP      ,
            SOL_TRACK_1_1_1_1_3_1_3         ,
            SOL_TRACK_1_1_1_1_6_4_AP        ,
            SOL_TRACK_1_1_1_1_6_4           ,
            SOL_TRACK_1_1_1_1_6_5_AP        ,
            SOL_TRACK_1_1_1_1_6_5           ,
            SOL_TRACK_1_1_1_1_7_4_AP        ,
            SOL_TRACK_1_1_1_1_7_4           ,
            SOL_TRACK_1_1_1_1_7_5_AP        ,
            SOL_TRACK_1_1_1_1_7_5           ,
            SOL_TRACK_1_1_1_1_7_6_AP        ,
            SOL_TRACK_1_1_1_1_7_6           ,
            SOL_TRACK_1_1_1_1_7_7_AP        ,
            SOL_TRACK_1_1_1_1_7_7           ,
            SOL_TRACK_1_1_1_1_7_8_AP        ,
            SOL_TRACK_1_1_1_1_7_9_AP        ,
            SOL_TRACK_1_1_1_1_7_9           ,
            SOL_TRACK_1_1_1_2_2_1_2_1_AP    ,
            SOL_TRACK_1_1_1_2_2_1_2_1       ,
            SOL_TRACK_1_1_1_2_2_1_3_AP      ,
            SOL_TRACK_1_1_1_2_2_1_3         ,
            SOL_TRACK_1_1_1_2_4_3_AP        ,
            SOL_TRACK_1_1_1_2_4_3           ,
            SOL_TRACK_1_1_1_3_2_8_AP        ,
            SOL_TRACK_1_1_1_3_2_8           ,
            SOL_TRACK_1_1_1_3_2_9_AP        ,
            SOL_TRACK_1_1_1_3_3_3_2_AP      ,
            SOL_TRACK_1_1_1_3_3_3_2         ,
            SOL_TRACK_1_1_1_3_3_3_3_AP      ,
            SOL_TRACK_1_1_1_3_3_3_3         ,
            SOL_TRACK_1_1_1_3_3_3_1_AP      ,
            SOL_TRACK_1_1_1_3_3_3_1         ,
            SOL_TRACK_1_1_1_3_3_4_AP        ,
            SOL_TRACK_1_1_1_3_3_4           ,
            SOL_TRACK_1_1_1_3_3_5_AP        ,
            SOL_TRACK_1_1_1_3_3_6_AP        ,
            SOL_TRACK_1_1_1_3_3_6           ,
            SOL_TRACK_1_1_1_3_3_7_AP        ,
            SOL_TRACK_1_1_1_3_3_7           ,
            SOL_TRACK_1_1_1_3_3_8_AP        ,
            SOL_TRACK_1_1_1_3_3_8           ,
            SOL_TRACK_1_1_1_3_3_9_AP        ,
            SOL_TRACK_1_1_1_3_3_10_AP       ,
            SOL_TRACK_1_1_1_3_5_3_AP        ,
            SOL_TRACK_1_1_1_3_7_1_2_AP      ,
            SOL_TRACK_1_1_1_3_7_1_2         ,
            SOL_TRACK_1_1_1_3_7_1_3_AP      ,
            SOL_TRACK_1_1_1_3_7_1_4_AP      ,
            SOL_TRACK_1_1_1_3_7_1_4         ,
            SOL_TRACK_1_1_1_3_7_11_1_AP     ,
            SOL_TRACK_1_1_1_3_11_2_AP       ,
            SOL_TRACK_1_1_1_3_11_2          ,
            SOL_TRACK_1_1_1_3_11_3_AP       ,
            SOL_TRACK_1_1_1_3_11_3          ,
            SOL_TRACK_1_1_1_4_1_AP          ,
            SOL_TRACK_1_1_1_4_1             ,
            SOL_TRACK_1_1_1_4_2_AP          ,
            SOL_TRACK_1_1_1_1_3_5_1         ,
            SOL_TRACK_1_1_1_1_3_5_1_AP      ,
            SOL_TRACK_1_1_1_1_7_10_AP       ,
            SOL_TRACK_1_1_1_1_7_10          ,
            SOL_TRACK_1_1_1_1_7_11_AP       ,
            SOL_TRACK_1_1_1_1_7_11          ,
            SOL_TRACK_1_1_1_3_2_10_AP       ,
            SOL_TRACK_1_1_1_3_2_10          ,
            SOL_TRACK_1_1_1_3_7_1_1_AP      ,
            SOL_TRACK_1_1_1_3_7_1_1         ,
            SOL_TRACK_1_1_1_1_2_1_2_AP      ,
            SOL_TRACK_1_1_1_1_2_1_2
			)
    Select
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_0_0_1_D,
            SOL_TRACK_1_1_1_0_0_2,
            SOL_TRACK_1_1_1_1_2_1_AP,
--            SOL_TRACK_1_1_1_1_2_1,
            SOL_TRACK_1_1_1_1_2_2_AP,
--            SOL_TRACK_1_1_1_1_2_2,
            SOL_TRACK_1_1_1_1_2_3_AP,
--            SOL_TRACK_1_1_1_1_2_3,
            SOL_TRACK_1_1_1_1_2_4_AP,
--            SOL_TRACK_1_1_1_1_2_4,
            SOL_TRACK_1_1_1_1_2_5_AP,
            SOL_TRACK_1_1_1_1_2_5,
            SOL_TRACK_1_1_1_1_2_6_AP,
            SOL_TRACK_1_1_1_1_2_6,
            SOL_TRACK_1_1_1_1_2_7_AP,
            SOL_TRACK_1_1_1_1_2_7,
            SOL_TRACK_1_1_1_1_2_8_AP,
            SOL_TRACK_1_1_1_1_2_8,
            SOL_TRACK_1_1_1_1_3_1_AP,
            SOL_TRACK_1_1_1_1_3_1,
            SOL_TRACK_1_1_1_1_3_2_AP,
            SOL_TRACK_1_1_1_1_3_2,
            SOL_TRACK_1_1_1_1_3_3_AP,
            SOL_TRACK_1_1_1_1_3_3,
            SOL_TRACK_1_1_1_1_3_4_AP,
--            SOL_TRACK_1_1_1_1_3_4,
            SOL_TRACK_1_1_1_1_3_5_AP,
--            SOL_TRACK_1_1_1_1_3_5,
            SOL_TRACK_1_1_1_1_3_6_AP,
--            SOL_TRACK_1_1_1_1_3_6,
            SOL_TRACK_1_1_1_1_3_7_AP,
            SOL_TRACK_1_1_1_1_3_7,
            SOL_TRACK_1_1_1_1_4_1_AP,
            SOL_TRACK_1_1_1_1_4_1,
            SOL_TRACK_1_1_1_1_4_2_AP,
            SOL_TRACK_1_1_1_1_4_2,
            SOL_TRACK_1_1_1_1_4_3_AP,
            SOL_TRACK_1_1_1_1_4_3,
            SOL_TRACK_1_1_1_1_4_4_AP,
            SOL_TRACK_1_1_1_1_4_4,
            SOL_TRACK_1_1_1_1_5_1_AP,
            SOL_TRACK_1_1_1_1_5_1,
            SOL_TRACK_1_1_1_1_5_2_AP,
            SOL_TRACK_1_1_1_1_5_2,
            SOL_TRACK_1_1_1_1_6_1_AP,
            SOL_TRACK_1_1_1_1_6_1,
            SOL_TRACK_1_1_1_1_6_2_AP,
            SOL_TRACK_1_1_1_1_6_2,
            SOL_TRACK_1_1_1_1_6_3_AP,
            SOL_TRACK_1_1_1_1_6_3,
            SOL_TRACK_1_1_1_1_7_1_AP,
            SOL_TRACK_1_1_1_1_7_1,
            SOL_TRACK_1_1_1_1_7_2_AP,
            SOL_TRACK_1_1_1_1_7_2,
            SOL_TRACK_1_1_1_1_7_3_AP,
            SOL_TRACK_1_1_1_1_7_3,
            SOL_TRACK_1_1_1_2_2_1_1_AP,
            SOL_TRACK_1_1_1_2_2_1_1,
            SOL_TRACK_1_1_1_2_2_1_2_AP,
            SOL_TRACK_1_1_1_2_2_1_2,
            SOL_TRACK_1_1_1_2_2_2_AP,
            SOL_TRACK_1_1_1_2_2_2,
            SOL_TRACK_1_1_1_2_2_3_AP,
            SOL_TRACK_1_1_1_2_2_3,
            SOL_TRACK_1_1_1_2_2_4_AP,
            SOL_TRACK_1_1_1_2_2_4,
            SOL_TRACK_1_1_1_2_2_5_AP,
            SOL_TRACK_1_1_1_2_2_5,
            SOL_TRACK_1_1_1_2_2_6_AP,
            SOL_TRACK_1_1_1_2_2_6,
            SOL_TRACK_1_1_1_2_3_1_AP,
            SOL_TRACK_1_1_1_2_3_1,
            SOL_TRACK_1_1_1_2_3_2_AP,
            SOL_TRACK_1_1_1_2_3_2,
            SOL_TRACK_1_1_1_2_3_3_AP,
            SOL_TRACK_1_1_1_2_3_3_A,
            SOL_TRACK_1_1_1_2_3_3_B,
            SOL_TRACK_1_1_1_2_3_3_C,
            SOL_TRACK_1_1_1_2_3_4_AP,
            SOL_TRACK_1_1_1_2_3_4,
            SOL_TRACK_1_1_1_2_4_1_1_AP,
            SOL_TRACK_1_1_1_2_4_1_1,
            SOL_TRACK_1_1_1_2_4_1_2_AP,
            SOL_TRACK_1_1_1_2_4_1_2_A,
            SOL_TRACK_1_1_1_2_4_1_2_B,
            SOL_TRACK_1_1_1_2_4_1_2_C,
            SOL_TRACK_1_1_1_2_4_2_1_AP,
            SOL_TRACK_1_1_1_2_4_2_1,
            SOL_TRACK_1_1_1_2_4_2_2_AP,
            SOL_TRACK_1_1_1_2_4_2_2_A,
            SOL_TRACK_1_1_1_2_4_2_2_B,
            SOL_TRACK_1_1_1_2_4_2_2_C,
            SOL_TRACK_1_1_1_2_4_2_2_D,
            SOL_TRACK_1_1_1_2_5_1_AP,
            SOL_TRACK_1_1_1_2_5_1,
            SOL_TRACK_1_1_1_2_5_2_AP,
            SOL_TRACK_1_1_1_2_5_2,
            SOL_TRACK_1_1_1_2_5_3_AP,
            SOL_TRACK_1_1_1_2_5_3,
            SOL_TRACK_1_1_1_3_2_1_AP,
            SOL_TRACK_1_1_1_3_2_1,
            SOL_TRACK_1_1_1_3_2_2_AP,
            SOL_TRACK_1_1_1_3_2_2,
            SOL_TRACK_1_1_1_3_2_3_AP,
            SOL_TRACK_1_1_1_3_2_3,
            SOL_TRACK_1_1_1_3_2_4_AP,
            SOL_TRACK_1_1_1_3_2_4,
            SOL_TRACK_1_1_1_3_2_5_AP,
            SOL_TRACK_1_1_1_3_2_5,
            SOL_TRACK_1_1_1_3_2_6_AP,
            SOL_TRACK_1_1_1_3_2_6,
            SOL_TRACK_1_1_1_3_2_7_AP,
            SOL_TRACK_1_1_1_3_2_7,
            SOL_TRACK_1_1_1_3_3_1_AP,
            SOL_TRACK_1_1_1_3_3_1,
            SOL_TRACK_1_1_1_3_3_2_AP,
            SOL_TRACK_1_1_1_3_3_2,
            SOL_TRACK_1_1_1_3_3_3_AP,
--            SOL_TRACK_1_1_1_3_3_3,
            SOL_TRACK_1_1_1_3_4_1_AP,
            SOL_TRACK_1_1_1_3_4_1,
            SOL_TRACK_1_1_1_3_5_1_AP,
            SOL_TRACK_1_1_1_3_5_1,
            SOL_TRACK_1_1_1_3_5_2_AP,
            SOL_TRACK_1_1_1_3_5_2,
            SOL_TRACK_1_1_1_3_6_1_AP,
            SOL_TRACK_1_1_1_3_6_1,
            SOL_TRACK_1_1_1_3_7_1_AP,
            SOL_TRACK_1_1_1_3_7_1,
            SOL_TRACK_1_1_1_3_7_2_1_AP,
            SOL_TRACK_1_1_1_3_7_2_1,
            SOL_TRACK_1_1_1_3_7_2_2_AP,
            SOL_TRACK_1_1_1_3_7_2_2,
            SOL_TRACK_1_1_1_3_7_3_AP,
            SOL_TRACK_1_1_1_3_7_3,
            SOL_TRACK_1_1_1_3_7_4_AP,
            SOL_TRACK_1_1_1_3_7_4,
            SOL_TRACK_1_1_1_3_7_5_AP,
            SOL_TRACK_1_1_1_3_7_5,
            SOL_TRACK_1_1_1_3_7_6_AP,
            SOL_TRACK_1_1_1_3_7_6,
            SOL_TRACK_1_1_1_3_7_7_AP,
            SOL_TRACK_1_1_1_3_7_7,
            SOL_TRACK_1_1_1_3_7_8_AP,
            SOL_TRACK_1_1_1_3_7_8,
            SOL_TRACK_1_1_1_3_7_9_AP,
            SOL_TRACK_1_1_1_3_7_9,
            SOL_TRACK_1_1_1_3_7_10_AP,
            SOL_TRACK_1_1_1_3_7_10,
            SOL_TRACK_1_1_1_3_7_11_AP,
            SOL_TRACK_1_1_1_3_7_11,
            SOL_TRACK_1_1_1_3_7_12_AP,
            SOL_TRACK_1_1_1_3_7_12,
            SOL_TRACK_1_1_1_3_7_13_AP,
            SOL_TRACK_1_1_1_3_7_13,
            SOL_TRACK_1_1_1_3_7_14_AP,
            SOL_TRACK_1_1_1_3_7_14,
            SOL_TRACK_1_1_1_3_7_15_1_AP,
            SOL_TRACK_1_1_1_3_7_15_1,
            SOL_TRACK_1_1_1_3_7_15_2_AP,
            SOL_TRACK_1_1_1_3_7_15_2,
            SOL_TRACK_1_1_1_3_7_16_AP,
            SOL_TRACK_1_1_1_3_7_16,
            SOL_TRACK_1_1_1_3_7_17_AP,
            SOL_TRACK_1_1_1_3_7_17,
            SOL_TRACK_1_1_1_3_7_18_AP,
            SOL_TRACK_1_1_1_3_7_18,
            SOL_TRACK_1_1_1_3_7_19_AP,
            SOL_TRACK_1_1_1_3_7_19,
            SOL_TRACK_1_1_1_3_7_20_AP,
            SOL_TRACK_1_1_1_3_7_20,
            SOL_TRACK_1_1_1_3_7_21_AP,
            SOL_TRACK_1_1_1_3_7_21,
            SOL_TRACK_1_1_1_3_7_22_AP,
            SOL_TRACK_1_1_1_3_7_22,
            SOL_TRACK_1_1_1_3_7_23_AP,
            SOL_TRACK_1_1_1_3_7_23,
            SOL_TRACK_1_1_1_3_8_1_AP,
            SOL_TRACK_1_1_1_3_8_1,
            SOL_TRACK_1_1_1_3_8_2_AP,
            SOL_TRACK_1_1_1_3_8_2,
            SOL_TRACK_1_1_1_3_9_1_AP,
            SOL_TRACK_1_1_1_3_9_1,
            SOL_TRACK_1_1_1_3_9_2_AP,
            SOL_TRACK_1_1_1_3_9_2,
            SOL_TRACK_1_1_1_3_10_1_AP,
            SOL_TRACK_1_1_1_3_10_1,
            SOL_TRACK_1_1_1_3_10_2_AP,
            SOL_TRACK_1_1_1_3_10_2,
            SOL_TRACK_1_1_1_3_11_1_AP,
            SOL_TRACK_1_1_1_3_11_1,
            SOL_TRACK_1_1_1_3_12_1_AP,
            SOL_TRACK_1_1_1_3_12_1,
            TIPO_BINARIO,
            SEDE_TECNICA,
            p_versione,
            GRUPPO_AUTORIZZATIVO,
	        SOL_TRACK_1_1_1_1_2_4_1_AP      ,              --  NUOVI PARAMETRI Reg.2019/777
            SOL_TRACK_1_1_1_1_2_4_1         ,
            SOL_TRACK_1_1_1_1_2_4_2_AP      ,
            SOL_TRACK_1_1_1_1_2_4_2         ,
            SOL_TRACK_1_1_1_1_2_4_3_AP      ,
            SOL_TRACK_1_1_1_1_2_4_4_AP      ,
            SOL_TRACK_1_1_1_1_2_4_4         ,
            SOL_TRACK_1_1_1_1_3_1_1_AP      ,
            SOL_TRACK_1_1_1_1_3_1_1_INF     ,
            SOL_TRACK_1_1_1_1_3_1_1_SUP     ,
            SOL_TRACK_1_1_1_1_3_1_2_AP      ,
            SOL_TRACK_1_1_1_1_3_1_2         ,
            SOL_TRACK_1_1_1_1_3_1_3_AP      ,
            SOL_TRACK_1_1_1_1_3_1_3         ,
            SOL_TRACK_1_1_1_1_6_4_AP        ,
            SOL_TRACK_1_1_1_1_6_4           ,
            SOL_TRACK_1_1_1_1_6_5_AP        ,
            SOL_TRACK_1_1_1_1_6_5           ,
            SOL_TRACK_1_1_1_1_7_4_AP        ,
            SOL_TRACK_1_1_1_1_7_4           ,
            SOL_TRACK_1_1_1_1_7_5_AP        ,
            SOL_TRACK_1_1_1_1_7_5           ,
            SOL_TRACK_1_1_1_1_7_6_AP        ,
            SOL_TRACK_1_1_1_1_7_6           ,
            SOL_TRACK_1_1_1_1_7_7_AP        ,
            SOL_TRACK_1_1_1_1_7_7           ,
            SOL_TRACK_1_1_1_1_7_8_AP        ,
            SOL_TRACK_1_1_1_1_7_9_AP        ,
            SOL_TRACK_1_1_1_1_7_9           ,
            SOL_TRACK_1_1_1_2_2_1_2_1_AP    ,
            SOL_TRACK_1_1_1_2_2_1_2_1       ,
            SOL_TRACK_1_1_1_2_2_1_3_AP      ,
            SOL_TRACK_1_1_1_2_2_1_3         ,
            SOL_TRACK_1_1_1_2_4_3_AP        ,
            SOL_TRACK_1_1_1_2_4_3           ,
            SOL_TRACK_1_1_1_3_2_8_AP        ,
            SOL_TRACK_1_1_1_3_2_8           ,
            SOL_TRACK_1_1_1_3_2_9_AP        ,
            SOL_TRACK_1_1_1_3_3_3_2_AP      ,
            SOL_TRACK_1_1_1_3_3_3_2         ,
            SOL_TRACK_1_1_1_3_3_3_3_AP      ,
            SOL_TRACK_1_1_1_3_3_3_3         ,
            SOL_TRACK_1_1_1_3_3_3_1_AP      ,
            SOL_TRACK_1_1_1_3_3_3_1         ,
            SOL_TRACK_1_1_1_3_3_4_AP        ,
            SOL_TRACK_1_1_1_3_3_4           ,
            SOL_TRACK_1_1_1_3_3_5_AP        ,
            SOL_TRACK_1_1_1_3_3_6_AP        ,
            SOL_TRACK_1_1_1_3_3_6           ,
            SOL_TRACK_1_1_1_3_3_7_AP        ,
            SOL_TRACK_1_1_1_3_3_7           ,
            SOL_TRACK_1_1_1_3_3_8_AP        ,
            SOL_TRACK_1_1_1_3_3_8           ,
            SOL_TRACK_1_1_1_3_3_9_AP        ,
            SOL_TRACK_1_1_1_3_3_10_AP       ,
            SOL_TRACK_1_1_1_3_5_3_AP        ,
            SOL_TRACK_1_1_1_3_7_1_2_AP      ,
            SOL_TRACK_1_1_1_3_7_1_2         ,
            SOL_TRACK_1_1_1_3_7_1_3_AP      ,
            SOL_TRACK_1_1_1_3_7_1_4_AP      ,
            SOL_TRACK_1_1_1_3_7_1_4         ,
            SOL_TRACK_1_1_1_3_7_11_1_AP     ,
            SOL_TRACK_1_1_1_3_11_2_AP       ,
            SOL_TRACK_1_1_1_3_11_2          ,
            SOL_TRACK_1_1_1_3_11_3_AP       ,
            SOL_TRACK_1_1_1_3_11_3          ,
            SOL_TRACK_1_1_1_4_1_AP          ,
            SOL_TRACK_1_1_1_4_1             ,
            SOL_TRACK_1_1_1_4_2_AP          ,
            SOL_TRACK_1_1_1_1_3_5_1         ,
            SOL_TRACK_1_1_1_1_3_5_1_AP      ,
            SOL_TRACK_1_1_1_1_7_10_AP       ,
            SOL_TRACK_1_1_1_1_7_10          ,
            SOL_TRACK_1_1_1_1_7_11_AP       ,
            SOL_TRACK_1_1_1_1_7_11          ,
            SOL_TRACK_1_1_1_3_2_10_AP       ,
            SOL_TRACK_1_1_1_3_2_10          ,
            SOL_TRACK_1_1_1_3_7_1_1_AP      ,
            SOL_TRACK_1_1_1_3_7_1_1         ,
            SOL_TRACK_1_1_1_1_2_1_2_AP      ,
            SOL_TRACK_1_1_1_1_2_1_2
       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL 
      Where CODICE_VERSIONE = p_versione -1
	    And SEDE_TECNICA = p_SEDE_TECNICA;

  DBMS_OUTPUT.PUT_LINE('BINARI_CORSA_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert BINARI_CORSA_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
--    Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF  (
-- --------------------------------------------------------------------------------------
--
 Begin
    Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF  (
            SOL_TRACK_1_1_1_0_0_1,
            TIPO_DICHIARAZIONE,
            SOL_TRACK_1_1_1_1_1_1O2_AP,
            SOL_TRACK_1_1_1_1_1_1O2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE  )
    Select  d.SOL_TRACK_1_1_1_0_0_1,
            TIPO_DICHIARAZIONE,
            SOL_TRACK_1_1_1_1_1_1O2_AP,
            SOL_TRACK_1_1_1_1_1_1O2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF d,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where d.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 
        And d.CODICE_VERSIONE = b.CODICE_VERSIONE
	    And b.CODICE_VERSIONE = p_versione -1
	    And b.SEDE_TECNICA    = p_SEDE_TECNICA;

  DBMS_OUTPUT.PUT_LINE('DICHIARAZIONI_BINARIO_SOL_INF record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert DICHIARAZIONI_BINARIO_SOL_INF - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Dichiarazioni ENE versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE  (
            SOL_TRACK_1_1_1_0_0_1,
            TIPO_DICHIARAZIONE,
            SOL_TRACK_1_1_1_2_1_1O2_AP,
            SOL_TRACK_1_1_1_2_1_1O2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE  )
     Select d.SOL_TRACK_1_1_1_0_0_1,
            TIPO_DICHIARAZIONE,
            SOL_TRACK_1_1_1_2_1_1O2_AP,
            SOL_TRACK_1_1_1_2_1_1O2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE d,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where d.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 
        And d.CODICE_VERSIONE = b.CODICE_VERSIONE
	    And b.CODICE_VERSIONE = p_versione -1
	    And b.SEDE_TECNICA = p_SEDE_TECNICA;

  DBMS_OUTPUT.PUT_LINE('DICHIARAZIONI_BINARIO_SOL_ENE record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert DICHIARAZIONI_BINARIO_SOL_ENE - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
--  Dichiarazioni CCS versione precedente
-- --------------------------------------------------------------------------------------

 Begin
   Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_CCS  (
            SOL_TRACK_1_1_1_0_0_1,
            TIPO_DICHIARAZIONE,
            SOL_TRACK_1_1_1_3_1_1_AP,
            SOL_TRACK_1_1_1_3_1_1,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select d.SOL_TRACK_1_1_1_0_0_1,
            TIPO_DICHIARAZIONE,
            SOL_TRACK_1_1_1_3_1_1_AP,
            SOL_TRACK_1_1_1_3_1_1,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_CCS d,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where d.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 
	    And d.CODICE_VERSIONE = b.CODICE_VERSIONE 
	    And b.CODICE_VERSIONE = p_versione -1
 	    And b.SEDE_TECNICA = p_SEDE_TECNICA;

  DBMS_OUTPUT.PUT_LINE('DICHIARAZIONI_BINARIO_SOL_CCS record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert DICHIARAZIONI_BINARIO_SOL_CCS - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Gallerie SOL versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL   (
            SOL_TUNNEL_1_1_1_1_8_1,
            SOL_TUNNEL_1_1_1_1_8_2,
            SOL_TUNNEL_1_1_1_1_8_2_D,
            SOL_TUNNEL_1_1_1_1_8_3_AP,
            SOL_TUNNEL_1_1_1_1_8_3,
            SOL_TUNNEL_1_1_1_1_8_4_AP,
            SOL_TUNNEL_1_1_1_1_8_4,
            SOL_TUNNEL_1_1_1_1_8_7_AP,
            SOL_TUNNEL_1_1_1_1_8_7,
            SOL_TUNNEL_1_1_1_1_8_8_AP,
            SOL_TUNNEL_1_1_1_1_8_8,
            SOL_TUNNEL_1_1_1_1_8_9_AP,
            SOL_TUNNEL_1_1_1_1_8_9,
            SOL_TUNNEL_1_1_1_1_8_10_AP,
            SOL_TUNNEL_1_1_1_1_8_10,
            SOL_TUNNEL_1_1_1_1_8_11_AP,
            SOL_TUNNEL_1_1_1_1_8_11,
            CODICE_VERSIONE,
            GALLERIA_PRINCIPALE,
            CONFIGURAZIONE_GALLERIA,
            GRUPPO_AUTORIZZATIVO,
	        SOL_TUNNEL_1_1_1_1_8_8_1_AP,                   --  NUOVI PARAMETRI Reg.2019/777
            SOL_TUNNEL_1_1_1_1_8_8_1,
            SOL_TUNNEL_1_1_1_1_8_8_2_AP,
            SOL_TUNNEL_1_1_1_1_8_8_2    )
    Select Distinct 
	        SOL_TUNNEL_1_1_1_1_8_1,
            g.SOL_TUNNEL_1_1_1_1_8_2,
            SOL_TUNNEL_1_1_1_1_8_2_D,
            SOL_TUNNEL_1_1_1_1_8_3_AP,
            SOL_TUNNEL_1_1_1_1_8_3,
            SOL_TUNNEL_1_1_1_1_8_4_AP,
            SOL_TUNNEL_1_1_1_1_8_4,
            SOL_TUNNEL_1_1_1_1_8_7_AP,
            SOL_TUNNEL_1_1_1_1_8_7,
            Null SOL_TUNNEL_1_1_1_1_8_8_AP,
            SOL_TUNNEL_1_1_1_1_8_8,
            SOL_TUNNEL_1_1_1_1_8_9_AP,
            SOL_TUNNEL_1_1_1_1_8_9,
            SOL_TUNNEL_1_1_1_1_8_10_AP,
            SOL_TUNNEL_1_1_1_1_8_10,
            SOL_TUNNEL_1_1_1_1_8_11_AP,
            SOL_TUNNEL_1_1_1_1_8_11,
            p_versione,
            GALLERIA_PRINCIPALE,
            CONFIGURAZIONE_GALLERIA,
            g.GRUPPO_AUTORIZZATIVO,
	    Null SOL_TUNNEL_1_1_1_1_8_8_1_AP,                   --  NUOVI PARAMETRI Reg.2019/777
            SOL_TUNNEL_1_1_1_1_8_8_1,
            SOL_TUNNEL_1_1_1_1_8_8_2_AP,
            SOL_TUNNEL_1_1_1_1_8_8_2
       From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL g,
            Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where g.SOL_TUNNEL_1_1_1_1_8_2 = bg.SOL_TUNNEL_1_1_1_1_8_2
        And g.CODICE_VERSIONE = bg.CODICE_VERSIONE
        And bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.CODICE_VERSIONE = p_versione -1
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And (g.SOL_TUNNEL_1_1_1_1_8_2, p_versione) In
                 (Select g.SOL_TUNNEL_1_1_1_1_8_2, p_versione
                    From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL g,
                         Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL bg,
                         Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
                   Where g.SOL_TUNNEL_1_1_1_1_8_2 = bg.SOL_TUNNEL_1_1_1_1_8_2
                     And g.CODICE_VERSIONE = bg.CODICE_VERSIONE
                     And bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
                     And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
                     And b.SEDE_TECNICA = p_SEDE_TECNICA
                     And b.CODICE_VERSIONE = p_versione -1
                 Minus
                  Select SOL_TUNNEL_1_1_1_1_8_2, CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL);

  DBMS_OUTPUT.PUT_LINE('GALLERIE_BINARI_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert GALLERIE_BINARI_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Relazioni Gallerie-binari versione precedente
-- --------------------------------------------------------------------------------------

Begin
    Insert Into Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL (
            SOL_TUNNEL_1_1_1_1_8_2,
            SOL_TRACK_1_1_1_0_0_1,
            CODICE_VERSIONE, 
	        SOL_TUNNEL_1_1_1_1_8_8_AP, 
	        SOL_TUNNEL_1_1_1_1_8_8_1_AP)
    Select Distinct
            SOL_TUNNEL_1_1_1_1_8_2, 
	        bg.SOL_TRACK_1_1_1_0_0_1, 
	        p_versione, 
	        SOL_TUNNEL_1_1_1_1_8_8_AP, 
	        SOL_TUNNEL_1_1_1_1_8_8_1_AP
       From Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.CODICE_VERSIONE = p_versione -1
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And (SOL_TUNNEL_1_1_1_1_8_2, 
             bg.SOL_TRACK_1_1_1_0_0_1, 
             p_versione -1, 
             SOL_TUNNEL_1_1_1_1_8_8_AP, 
	         SOL_TUNNEL_1_1_1_1_8_8_1_AP) In
                 (Select SOL_TUNNEL_1_1_1_1_8_2,
                         bg.SOL_TRACK_1_1_1_0_0_1,
                         p_versione -1, 
			             SOL_TUNNEL_1_1_1_1_8_8_AP, 
			            SOL_TUNNEL_1_1_1_1_8_8_1_AP
                    From Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL bg,
                         Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
                   Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
                     And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
                     And b.SEDE_TECNICA = p_SEDE_TECNICA
                     And b.CODICE_VERSIONE = p_versione -1
                 Minus
                  Select SOL_TUNNEL_1_1_1_1_8_2,
                         SOL_TRACK_1_1_1_0_0_1,
                         CODICE_VERSIONE, 
			             SOL_TUNNEL_1_1_1_1_8_8_AP, 
			             SOL_TUNNEL_1_1_1_1_8_8_1_AP
                    From Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL
		          );

  DBMS_OUTPUT.PUT_LINE('REL_GALLERIE_BINARI_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert REL_GALLERIE_BINARI_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Dichiarazioni versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL (
          SOL_TUNNEL_1_1_1_1_8_2,
          TIPO_DICHIARAZIONE,
          SOL_TUNNEL_1_1_1_1_8_5O6_AP,
          SOL_TUNNEL_1_1_1_1_8_5O6,
          KM_INIZIO,
          KM_FINE,
          LATITUDINE_INIZIO,
          LONGITUDINE_INIZIO,
          LATITUDINE_FINE,
          LONGITUDINE_FINE,
          FLAG_CALCOLATO,
          CODICE_VERSIONE )
    Select Distinct
          d.SOL_TUNNEL_1_1_1_1_8_2,
          TIPO_DICHIARAZIONE,
          SOL_TUNNEL_1_1_1_1_8_5O6_AP,
          SOL_TUNNEL_1_1_1_1_8_5O6,
          KM_INIZIO,
          KM_FINE,
          LATITUDINE_INIZIO,
          LONGITUDINE_INIZIO,
          LATITUDINE_FINE,
          LONGITUDINE_FINE,
          FLAG_CALCOLATO,
          p_versione
     From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL d,
          Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL bg,
          Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
    Where d.SOL_TUNNEL_1_1_1_1_8_2 = bg.SOL_TUNNEL_1_1_1_1_8_2
      And d.CODICE_VERSIONE = bg.CODICE_VERSIONE
      And bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
      And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
      And b.SEDE_TECNICA = p_SEDE_TECNICA
      And b.CODICE_VERSIONE = p_versione -1
      And    ( d.SOL_TUNNEL_1_1_1_1_8_2,
               TIPO_DICHIARAZIONE,
               SOL_TUNNEL_1_1_1_1_8_5O6,
               KM_INIZIO,
               p_versione -1) In
                 (Select d.SOL_TUNNEL_1_1_1_1_8_2,
                         TIPO_DICHIARAZIONE,
                         SOL_TUNNEL_1_1_1_1_8_5O6,
                         KM_INIZIO,
                         p_versione -1
                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL d,
                         Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL bg,
                         Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
                   Where d.SOL_TUNNEL_1_1_1_1_8_2 = bg.SOL_TUNNEL_1_1_1_1_8_2
                         And d.CODICE_VERSIONE = bg.CODICE_VERSIONE
                         And bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
                         And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
                         And b.SEDE_TECNICA = p_SEDE_TECNICA
                         And b.CODICE_VERSIONE = p_versione -1
                 Minus
                  Select SOL_TUNNEL_1_1_1_1_8_2,
                         TIPO_DICHIARAZIONE,
                         SOL_TUNNEL_1_1_1_1_8_5O6,
                         KM_INIZIO,
                         CODICE_VERSIONE   --- verificare??
                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL 
		          );

  DBMS_OUTPUT.PUT_LINE('DICHIARAZIONI_GALLERIE_BIN_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert DICHIARAZIONI_GALLERIE_BIN_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- CAT TEN SOL versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_2_1,
            KM_INIZIO,
            KM_FINE,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_2_1,
            KM_INIZIO,
            KM_FINE,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_1_2_1_CAT_TEN_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_1_2_1_CAT_TEN_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- CAT LINEA SOL versione precedente
-- --------------------------------------------------------------------------------------

Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_2_CAT_LINEA (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_2_2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_2_2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_2_CAT_LINEA bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_1_2_2_CAT_LINEA record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_1_2_2_CAT_LINEA - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- CAT CARICO SOL versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_4_CAP_CARICO (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_2_4,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE )
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_2_4,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_4_CAP_CARICO bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_1_2_4_CAP_CARICO record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_1_2_4_CAP_CARICO - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- PROF CASSE M versione precedente
-- --------------------------------------------------------------------------------------

Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_1_3_4_PROF_CAS_M (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_3_4,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE )
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_3_4,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_3_4_PROF_CAS_M bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_1_3_4_PROF_CAS_M record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_1_3_4_PROF_CAS_M - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- PROF SEMI R versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_1_3_5_PROF_SEMI_R (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_3_5,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE )
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_3_5,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_3_5_PROF_SEMI_R bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_1_3_5_PROF_SEMI_R record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_1_3_5_PROF_SEMI_R - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Profili di gradiente versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_1_3_6_GRADIENTE (
            SOL_TRACK_1_1_1_0_0_1,
            KM_INIZIO,
            KM_FINE,
            PENDENZA,
            CODICE_VERSIONE )
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            KM_INIZIO,
            KM_FINE,
            PENDENZA,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_3_6_GRADIENTE bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_1_3_6_GRADIENTE record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_1_3_6_GRADIENTE - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- GSM R FAC versione precedente
-- --------------------------------------------------------------------------------------

 Begin
     Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_3_3_3_GSM_R_FAC (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_3_3,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_3_3,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_3_3_GSM_R_FAC bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_3_3_3_GSM_R_FAC record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_3_3_3_GSM_R_FAC - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- LOCAVERSPEC SOL versione precedente
-- --------------------------------------------------------------------------------------

Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_4_3_LOCAVERSPEC (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_2_4_3,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_2_4_3,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_4_3_LOCAVERSPEC bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_1_2_4_3_LOCAVERSPEC record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_1_2_4_3_LOCAVERSPEC - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- LOCA SIST RTB SOL versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_1_7_8_LOCA_SIST_RTB (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_7_8,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_7_8,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_7_8_LOCA_SIST_RTB bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_1_7_8_LOCA_SIST_RTB record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_1_7_8_LOCA_SIST_RTB - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- COMP ETCS SOL versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_3_2_9_COMP_ETCS (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_2_9,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_2_9,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_2_9_COMP_ETCS bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_3_2_9_COMP_ETCS record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_3_2_9_COMP_ETCS - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- RETI GSM-R SOL versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_3_3_5_RETI_GSM_R (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_3_5,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_3_5,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_3_5_RETI_GSM_R bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_3_3_5_RETI_GSM_R record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_3_3_5_RETI_GSM_R - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- COMP RADIO-VOCE SOL versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_3_3_9_RADIO_VOCE (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_3_9,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_3_9,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_3_9_RADIO_VOCE bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_3_3_9_RADIO_VOCE record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_3_3_9_RADIO_VOCE - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- COMP RADIO-DATI SOL versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_3_3_10_RADIO_DATI (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_3_10,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_3_10,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_3_10_RADIO_DATI bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_3_3_10_RADIO_DATI record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_3_3_10_RADIO_DATI - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- SIST_PRE_PROT SOL versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_3_5_3_SIST_PRE_PROT (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_5_3,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_5_3,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_5_3_SIST_PRE_PROT bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_3_5_3_SIST_PRE_PROT record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_3_5_3_SIST_PRE_PROT - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- SIS_RIL_DOC SOL versione precedente
-- --------------------------------------------------------------------------------------

Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_3_7_1_3_SISTRILTRAIN (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_7_1_3,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_7_1_3,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_7_1_3_SISTRILTRAIN bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_3_7_1_3_SISTRILTRAIN record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_3_7_1_3_SISTRILTRAIN - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- CARMIN_ASSE SOL versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_3_7_11_1_CARMIN_ASSE (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_7_11_1,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_3_7_11_1,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_7_11_1_CARMIN_ASSE bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_3_7_11_1_CARMIN_ASSE record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_3_7_11_1_CARMIN_ASSE - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;
-- --------------------------------------------------------------------------------------
-- NORME_DOC SOL versione precedente
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_4_2_NORME_DOC (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_4_2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            CODICE_VERSIONE)
     Select bg.SOL_TRACK_1_1_1_4_2,
            SOL_TRACK_1_1_1_4_2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            p_versione
       From Rinf_Pubblicati_Evo.PAR_1_1_1_4_2_NORME_DOC bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And b.SEDE_TECNICA = p_SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_4_2_NORME_DOC record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_4_2_NORME_DOC - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

--
-- --------------------------------------------------------------------------------------
-- Relazioni SOL-Corridoi Versione precedente (CORRIDOIO_SOL)
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.CORRIDOIO_SOL
           (CODICE_CORRIDOIO, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_CORRIDOIO,
            p.SEDE_TECNICA,
            p_versione
       From Rinf_Pubblicati_Evo.CORRIDOIO_SOL p
      Where p.SEDE_TECNICA = p_SEDE_TECNICA 
	    And p.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('CORRIDOIO_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert CORRIDOIO_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Relazioni SOL-Linee Ten versione precedente (LINEE_TENT_SOL)
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.LINEE_TENT_SOL
           (CODICE_LINEA_TENT, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_LINEA_TENT,
            p.SEDE_TECNICA,
            p_versione
       From Rinf_Pubblicati_Evo.LINEE_TENT_SOL p
      Where p.SEDE_TECNICA = p_SEDE_TECNICA 
	    And p.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('LINEE_TENT_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert LINEE_TENT_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Relazione SOL-Linee Comm versione precedente (LINEA_COMM_SOL)
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.LINEA_COMM_SOL
           (CODICE_GIURISDIZIONE, SEDE_TECNICA, CODICE_VERSIONE, KM_INIZIO, KM_FINE)
     Select CODICE_GIURISDIZIONE,
            p.SEDE_TECNICA,
            p_versione,
            KM_INIZIO, 
	        KM_FINE
       From Rinf_Pubblicati_Evo.LINEA_COMM_SOL p
      Where p.SEDE_TECNICA = p_SEDE_TECNICA 
	    And p.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('LINEA_COMM_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert LINEA_COMM_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Relazione SOL-Linee FCL versione precedente (LINEA_FCL_SOL)
-- --------------------------------------------------------------------------------------

 Begin 
    Insert Into Rinf_Pubblicati_Evo.LINEA_FCL_SOL
           (CODICE_LINEA_FCL, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_LINEA_FCL,
            p.SEDE_TECNICA,
            p_versione
       From Rinf_Pubblicati_Evo.LINEA_FCL_SOL p
      Where p.SEDE_TECNICA = p_SEDE_TECNICA 
	    And p.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('LINEA_FCL_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert LINEA_FCL_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

-- --------------------------------------------------------------------------------------
-- Relazione SOL-Fasciolo Linea versione precedente (FASCICOLO_SOL)
-- --------------------------------------------------------------------------------------

 Begin
    Insert Into Rinf_Pubblicati_Evo.FASCICOLO_SOL
           (CODICE_FASCICOLO, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_FASCICOLO,
            p.SEDE_TECNICA,
            p_versione
       From Rinf_Pubblicati_Evo.FASCICOLO_SOL p
      Where p.SEDE_TECNICA = p_SEDE_TECNICA 
	    And p.CODICE_VERSIONE = p_versione -1;

  DBMS_OUTPUT.PUT_LINE('FASCICOLO_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
EXCEPTION
      When OTHERS Then
        Dbms_Output.Put_Line ('Insert FASCICOLO_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
		p_errore := 0;
 END;

End Rispristina_Pubblicati_SOL;





/*********************************************************************************************************************/
/*********************************************************************************************************************/


--
-- Parametri assegnati al depositario di sede centrale RC_RINF_DSPS (Direzione Strategia, Pianificazione e Sostenibilit )
--
-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.2.1 - IPP_TENClass
--   Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL new 
-- -------------------------------------------------------------------------------------------
 Procedure PAR_1_1_1_1_2_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is

 begin 
  p_error_split := 0;

 Delete From  Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL new
        Where CODICE_VERSIONE = v_Codice_Versione
		  And SOL_TRACK_1_1_1_0_0_1 in 
		  (Select SOL_TRACK_1_1_1_0_0_1 
		     From Rinf_Pubblicati_Evo.SEZIONI_LINEA s,
			      Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
            Where b.SEDE_TECNICA = s.SEDE_TECNICA
	          And b.CODICE_VERSIONE = s.CODICE_VERSIONE
	          And s.CODICE_VERSIONE = v_Codice_Versione
	          And s.CODICE_DTP =  v_DTP);

--
DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.1 - IPP_TENClass - record cancellati ' || SQL%ROWCOUNT || ' PAR_1_1_1_1_2_1_CAT_TEN_SOL di '||v_DTP); 

-- 
 Insert into Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL new
        (    SOL_TRACK_1_1_1_0_0_1,
             SOL_TRACK_1_1_1_1_2_1,
             KM_INIZIO,
             KM_FINE,
             CODICE_VERSIONE  )
 Select      SOL_TRACK_1_1_1_0_0_1,
             SOL_TRACK_1_1_1_1_2_1,
             KM_INIZIO,
             KM_FINE,
             v_Codice_Versione
   From      Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL old
   Where     CODICE_VERSIONE = v_CODICE_VERSIONE -1
     And    (old.SOL_TRACK_1_1_1_0_0_1) in 
		    (Select b.SOL_TRACK_1_1_1_0_0_1  
		     From Rinf_Pubblicati_Evo.SEZIONI_LINEA s,
			      Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
            Where s.CODICE_VERSIONE = v_Codice_Versione -1
		      And b.CODICE_VERSIONE = s.CODICE_VERSIONE
		      And b.SEDE_TECNICA = s.SEDE_TECNICA
		      And s.CODICE_DTP =  v_DTP)
--> aggiungere la seguente clausola per evitare che restituisca errore quando alcuni binari vengono cancellati 
      and old.SOL_TRACK_1_1_1_0_0_1 in (select SOL_TRACK_1_1_1_0_0_1 from Rinf_Pubblicati_Evo.BINARI_CORSA_SOL
            Where CODICE_VERSIONE = v_CODICE_VERSIONE);

--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.1 - IPP_TENClass - record inseriti ' || SQL%ROWCOUNT || ' PAR_1_1_1_1_2_1_CAT_TEN_SOL di '||v_DTP);
--
-- aggiornamneto dell'applicabilit  del parametro 
   Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new 
      Set SOL_TRACK_1_1_1_1_2_1_Ap = Nvl((Select SOL_TRACK_1_1_1_1_2_1_Ap
                                           From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old
										  Where old.CODICE_VERSIONE = v_Codice_Versione -1
										    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1
--->
		                                    And Exists ( Select SOL_TRACK_1_1_1_0_0_1 
											               From Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL 
		                                                  Where SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1 
		                                                    And CODICE_VERSIONE = v_Codice_Versione -1)
--->
										  ), 'NYA')
    Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SOL_TRACK_1_1_1_0_0_1 in 
		    (Select SOL_TRACK_1_1_1_0_0_1
 		       From Rinf_Pubblicati_Evo.SEZIONI_LINEA s,
			        Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
              Where b.SEDE_TECNICA = s.SEDE_TECNICA                   
		        And b.CODICE_VERSIONE = s.CODICE_VERSIONE
			    And s.CODICE_VERSIONE = v_Codice_Versione 
				And s.SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
		        And s.CODICE_DTP =  v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.1_AP - IPP_TENClass - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_2_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_2_1_ROLLBACK;

-- ----------------------------------------------------------------------------------------------	         
--  Parametro 1.1.1.1.2.1.2 - IPP_TENGISID - Identit  del sistema informativo geografico (GID ID) 
-- ----------------------------------------------------------------------------------------------	         
 Procedure PAR_1_1_1_1_2_1_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is

 begin 

  p_error_split := 0;
--
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new 
  Set new.SOL_TRACK_1_1_1_1_2_1_2_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_2_1_2_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_1_2_1_2 = (Select old.SOL_TRACK_1_1_1_1_2_1_2
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
				                And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.1.2 - IPP_TENGISID - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_2_1_2_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_2_1_2_ROLLBACK;


-- ----------------------------------------------------------------------------------------------	         
-- 1.1.1.1.2.3	IPP_FreightCorridor
-- questo parametro non viene archiviato in una tabella
-- ----------------------------------------------------------------------------------------------	         
 Procedure PAR_1_1_1_1_2_3_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is

 begin 

 p_error_split := 0;

--
    Delete from Rinf_Pubblicati_Evo.CORRIDOIO_SOL
     Where CODICE_VERSIONE = v_Codice_Versione
       And SEDE_TECNICA in 
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione 
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.3	IPP_FreightCorridor - record cancellati ' || SQL%ROWCOUNT || ' CORRIDOIO_SOL di '||v_DTP);
--
    Insert into Rinf_Pubblicati_Evo.CORRIDOIO_SOL
    (CODICE_CORRIDOIO, SEDE_TECNICA, CODICE_VERSIONE)
	Select CODICE_CORRIDOIO, SEDE_TECNICA, v_Codice_Versione
	  From Rinf_Pubblicati_Evo.CORRIDOIO_SOL
	 Where CODICE_VERSIONE = v_Codice_Versione -1
	   And SEDE_TECNICA in 
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA
	   Where CODICE_VERSIONE = v_Codice_Versione
	     And CODICE_DTP = v_DTP);
--		 
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.3	IPP_FreightCorridor - record Inseriti ' || SQL%ROWCOUNT || ' CORRIDOIO_SOL di '||v_DTP);

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new 
  Set new.SOL_TRACK_1_1_1_1_2_3_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_2_3_AP
                                            From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									       Where old.CODICE_VERSIONE = v_Codice_Versione -1
									         And old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1 
--->
		                                    And Exists ( Select SEDE_TECNICA
											               From Rinf_Pubblicati_Evo.CORRIDOIO_SOL
		                                                  Where SEDE_TECNICA = new.SEDE_TECNICA
		                                                    And CODICE_VERSIONE = v_Codice_Versione -1)
--->
										  ), 'NYA')


  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
				                And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.3.AP - IPP_FreightCorridor - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);

--  
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_2_3_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_2_3_ROLLBACK;


-- ------------------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.2.1 - IPP_TENClass
--   Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL  
-- escluse le Sedi tecniche Skeleton sia in cancellazione che in inserimento dai parametri multi-valore 
-- in UPD per evitare le duplicazioni, in quanto i parametri vengono valorizzati a parte con lo skeleton
-- -------------------------------------------------------------------------------------------
 Procedure PAR_1_1_1_1_2_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is

 begin 
  p_error_split := 0;

 Delete From  Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL 
        Where CODICE_VERSIONE = v_Codice_Versione
		  And SOL_TRACK_1_1_1_0_0_1 in 
		  (Select SOL_TRACK_1_1_1_0_0_1 
		     From Rinf_Pubblicati_Evo.SEZIONI_LINEA s,
			      Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
            Where b.SEDE_TECNICA = s.SEDE_TECNICA
	          And b.CODICE_VERSIONE = s.CODICE_VERSIONE
	          And s.CODICE_VERSIONE = v_Codice_Versione
	          And s.CODICE_DTP =  v_DTP
--
		      And s.SEDE_TECNICA Not In 
	        (Select SEDE_TECNICA 
		     From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
            Where CODICE_DTP = v_DTP
			  And CODICE_VERSIONE = v_Codice_Versione
			  And FLAG_TIPO = 1
			  And FLAG_STATO_FINALE = 9)   -- Skeleton
           );

--
DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.1 - IPP_TENClass - record cancellati ' || SQL%ROWCOUNT || ' PAR_1_1_1_1_2_1_CAT_TEN_SOL di '||v_DTP); 

-- 
 Insert into Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL
        (    SOL_TRACK_1_1_1_0_0_1,
             SOL_TRACK_1_1_1_1_2_1,
             KM_INIZIO,
             KM_FINE,
             CODICE_VERSIONE  )
 Select      SOL_TRACK_1_1_1_0_0_1,
             SOL_TRACK_1_1_1_1_2_1,
             KM_INIZIO,
             KM_FINE,
             v_Codice_Versione
   From      Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL
   Where     (SOL_TRACK_1_1_1_0_0_1) in 
		    (Select b.SOL_TRACK_1_1_1_0_0_1  
		     From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA s,
			      Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
            Where b.SEDE_TECNICA = s.SEDE_TECNICA
		      And s.CODICE_DTP =  v_DTP
--
			  And s.SEDE_TECNICA Not In 
	      (Select SEDE_TECNICA 
		     From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
            Where CODICE_DTP = v_DTP
			  And CODICE_VERSIONE = v_Codice_Versione
			  And FLAG_TIPO = 1
			  And FLAG_STATO_FINALE = 9)   -- Skeleton
			 );
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.1 - IPP_TENClass - record inseriti ' || SQL%ROWCOUNT || ' PAR_1_1_1_1_2_1_CAT_TEN_SOL di '||v_DTP);
--
-- aggiornamneto dell'applicabilit  del parametro 
   Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new 
      Set SOL_TRACK_1_1_1_1_2_1_Ap = Nvl((Select SOL_TRACK_1_1_1_1_2_1_Ap
                                           From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old
										  Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA')
    Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SOL_TRACK_1_1_1_0_0_1 in 
/*
		    (Select SOL_TRACK_1_1_1_0_0_1
 		       From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA s,
			        Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
              Where b.SEDE_TECNICA = s.SEDE_TECNICA                   
		        And s.CODICE_DTP =  v_DTP);
*/
		    (Select SOL_TRACK_1_1_1_0_0_1
 		       From Rinf_Pubblicati_Evo.SEZIONI_LINEA s,
			        Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
              Where b.SEDE_TECNICA = s.SEDE_TECNICA 
                And b.CODICE_VERSIONE = s.CODICE_VERSIONE 
                And s.CODICE_VERSIONE = v_Codice_Versione 
				And s.SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	            And s.CODICE_DTP =  v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.1_AP - IPP_TENClass - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_2_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_2_1_UPD;

-- ----------------------------------------------------------------------------------------------	         
--  Parametro 1.1.1.1.2.1.2 - IPP_TENGISID - Identit  del sistema informativo geografico (GID ID) 
-- ----------------------------------------------------------------------------------------------	         
 Procedure PAR_1_1_1_1_2_1_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old  
  Set old.SOL_TRACK_1_1_1_1_2_1_2_AP = Nvl((Select new.SOL_TRACK_1_1_1_1_2_1_2_AP
                                       From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL new 
									  Where new.SOL_TRACK_1_1_1_0_0_1 = old.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      old.SOL_TRACK_1_1_1_1_2_1_2 = (Select new.SOL_TRACK_1_1_1_1_2_1_2
                                       From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL new 
									  Where new.SOL_TRACK_1_1_1_0_0_1 = old.SOL_TRACK_1_1_1_0_0_1) 
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.SEDE_TECNICA in 
	/*	 
	 (Select SEDE_TECNICA 
	    From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	   Where CODICE_DTP = v_DTP);
	*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
		 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.1.2 - IPP_TENGISID - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_2_1_2_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_2_1_2_UPD;

--
-- ----------------------------------------------------------------------------------------------	         
-- 1.1.1.1.2.3	IPP_FreightCorridor
-- questo parametro non viene archiviato in una tabella
-- escluse le Sedi tecniche Skeleton sia in cancellazione che in inserimento dai parametri multi-valore 
-- in UPD per evitare le duplicazioni, in quanto i parametri vengono valorizzati a parte con lo skeleton
-- ----------------------------------------------------------------------------------------------	         
 Procedure PAR_1_1_1_1_2_3_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
  Set old.SOL_TRACK_1_1_1_1_2_3_AP = Nvl((Select new.SOL_TRACK_1_1_1_1_2_3_AP
                                            From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL new 
									       Where new.SOL_TRACK_1_1_1_0_0_1 = old.SOL_TRACK_1_1_1_0_0_1), 'NYA') 
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.SEDE_TECNICA in 
	/*	 
	 (Select SEDE_TECNICA 
	    From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	   Where CODICE_DTP = v_DTP);
	*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.3.AP	IPP_FreightCorridor - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
    Delete from Rinf_Pubblicati_Evo.CORRIDOIO_SOL
     Where CODICE_VERSIONE = v_Codice_Versione
       And SEDE_TECNICA in 
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA
	   Where CODICE_VERSIONE = v_Codice_Versione 
	     And CODICE_DTP = v_DTP)
--
		 And  SEDE_TECNICA Not In 
	        (Select SEDE_TECNICA 
		     From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
            Where CODICE_DTP = v_DTP
			  And CODICE_VERSIONE = v_Codice_Versione
			  And FLAG_TIPO = 1
			  And FLAG_STATO_FINALE = 9)   -- Skeleton
   ;
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.3	IPP_FreightCorridor - record cancellati ' || SQL%ROWCOUNT || ' CORRIDOIO_SOL di '||v_DTP);
--
    Insert into Rinf_Pubblicati_Evo.CORRIDOIO_SOL
    (CODICE_CORRIDOIO, SEDE_TECNICA, CODICE_VERSIONE)
	Select CODICE_CORRIDOIO, SEDE_TECNICA, v_Codice_Versione
	  From Rinf_Autorizzazioni_Evo.CORRIDOIO_SOL
	 Where SEDE_TECNICA in 
	 (Select SEDE_TECNICA 
	    From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA
	   Where CODICE_DTP = v_DTP
	  )
--
	  And  SEDE_TECNICA Not In 
	        (Select SEDE_TECNICA 
		     From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
            Where CODICE_DTP = v_DTP
			  And CODICE_VERSIONE = v_Codice_Versione
			  And FLAG_TIPO = 1
			  And FLAG_STATO_FINALE = 9
			  )   -- Skeleton
      ;
--
 DBMS_OUTPUT.PUT_LINE('1.1.1.1.2.3	IPP_FreightCorridor - record Inseriti ' || SQL%ROWCOUNT || ' CORRIDOIO_SOL di '||v_DTP);
--  
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_2_3_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_2_3_UPD;
--


-- Parametri assegnati al depositario di sede centrale RC_RINF_DCO (Direzione Commerciale)

-- -------------------------------------------------------------------------------------------
-- 1.1.1.0.0.2	SOLTrackDirection
-- modificato per gestire i casi in cui non trova il binario nella versione precedente
-- -------------------------------------------------------------------------------------------

Procedure PAR_1_1_1_0_0_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is
 begin 
  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new 
  Set 
        new.SOL_TRACK_1_1_1_0_0_2 = Nvl(
		                                (Select old.SOL_TRACK_1_1_1_0_0_2
                                           From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									      Where old.CODICE_VERSIONE = v_Codice_Versione -1
									        And old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 
										        new.SOL_TRACK_1_1_1_0_0_2)
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
-- 				                And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.0.0.2	SOLTrackDirection - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_0_0_2_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_0_0_2_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.2.0.0.0.1	OPName
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_0_0_0_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI new 
     Set new.DEFINIZIONE = (Select old.DEFINIZIONE
                              From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.1	OPName - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_0_0_0_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_0_0_0_1_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.2.0.0.0.5	OPGeographicLocation
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_0_0_0_5_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI new 
     Set new.LATITUDINE = (Select old.LATITUDINE
                              From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA) ,
         new.LONGITUDINE = (Select old.LONGITUDINE
                              From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA)
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.5	OPGeographicLocation - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_0_0_0_5_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_0_0_0_5_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.2.0.0.0.2	UniqueOPID
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_0_0_0_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI new 
     Set new.PO_1_2_0_0_0_2 = (Select old.PO_1_2_0_0_0_2 
                              From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.2	UniqueOPID - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_0_0_0_2_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_0_0_0_2_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.2.0.0.0.3	OPTafTapCode
-- -------------------------------------------------------------------------------------------

Procedure PAR_1_2_0_0_0_3_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 
--
  p_error_split := 0;
 --
  Delete From Rinf_Pubblicati_Evo.PAR_1_2_0_0_0_3_TAF_TAP new
        Where new.CODICE_VERSIONE = v_Codice_Versione
		  And new.SEDE_TECNICA in 
		  (Select SEDE_TECNICA 
		     From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
            Where CODICE_VERSIONE = v_Codice_Versione
		      And CODICE_DTP = v_DTP);
--
 DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.3	OPTafTapCode - record cancellati ' || SQL%ROWCOUNT || ' PAR_1_2_0_0_0_3_TAF_TAP di '||v_DTP); 
-- 
 Insert into Rinf_Pubblicati_Evo.PAR_1_2_0_0_0_3_TAF_TAP new
        (    SEDE_TECNICA,
             PO_1_2_0_0_0_3,
             KM_INIZIO,
             KM_FINE,
             CODICE_VERSIONE  )
 Select      SEDE_TECNICA,
             PO_1_2_0_0_0_3,
             KM_INIZIO,
             KM_FINE,
             v_Codice_Versione
   From      Rinf_Pubblicati_Evo.PAR_1_2_0_0_0_3_TAF_TAP old
   Where     old.CODICE_VERSIONE = v_CODICE_VERSIONE -1
     And     old.SEDE_TECNICA in 
		     (Select SEDE_TECNICA 
		     From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
            Where CODICE_VERSIONE = v_Codice_Versione
		      And CODICE_DTP = v_DTP);
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.3	OPTafTapCode - record inseriti ' || SQL%ROWCOUNT || ' PAR_1_2_0_0_0_3_TAF_TAP di '||v_DTP);


-- aggiornamneto dell'applicabilit  del parametro 
--   Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI new 

  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI new 
     Set new.PO_1_2_0_0_0_3_AP = Nvl((Select old.PO_1_2_0_0_0_3_AP
                              From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA
--->
                               And Exists ( Select SEDE_TECNICA
											  From Rinf_Pubblicati_Evo.PAR_1_2_0_0_0_3_TAF_TAP 
		                                     Where SEDE_TECNICA  = new.SEDE_TECNICA 
		                                       And CODICE_VERSIONE = v_Codice_Versione -1)
--->
							          ), 'NYA')
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.3.AP	OPTafTapCode - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_0_0_0_3_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_0_0_0_3_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.2.0.0.0.4	OPType
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_0_0_0_4_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI new 
     Set new.PO_1_2_0_0_0_4 = (Select old.PO_1_2_0_0_0_4
                              From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.4	OPType - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_0_0_0_4_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_0_0_0_4_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.2.0.0.0.6 - OPRailwayLocation
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_0_0_0_6_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI new 
     Set new.KM_INIZIO = (Select old.KM_INIZIO
                              From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA) ,
         new.PO_1_2_0_0_0_6 = (Select old.PO_1_2_0_0_0_6
                              From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA) 

  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.6 - OPRailwayLocation  -record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_0_0_0_6_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_0_0_0_6_ROLLBACK;
--
-- -------------------------------------------------------------------------------------------
-- 1.1.0.0.0.2 - SOLLineIdentification  "F5-F6" <SOLLineIdentification Value="F5-F6"/>
-- il parametro viene elaborato senza essere archiviato
-- -------------------------------------------------------------------------------------------
--
 Procedure PAR_1_1_0_0_0_2_ROLLBACK (V_Codice_Versione Number, v_DTP Varchar2, p_error_split Out Number) is 
 Begin 
    p_error_split := 0;
 /*
  Update SEZIONI_LINEA new 
     Set new.SOL_1_1_0_0_0_2 = (Select old.SOL_1_1_0_0_0_2
                              From Rinf_Pubblicati_Evo.SEZIONI_LINEA old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.CODICE_DTP = v_DTP;
*/
  DBMS_OUTPUT.PUT_LINE('1.1.0.0.0.2 - SOLLineIdentification di '||v_DTP);

--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_0_0_0_2_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_0_0_0_2_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.1.0.0.0.3 - SOLOPStart
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_1_0_0_0_3_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.SEZIONI_LINEA new 
     Set new.SOL_1_1_0_0_0_3 = (Select old.SOL_1_1_0_0_0_3
                              From Rinf_Pubblicati_Evo.SEZIONI_LINEA old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.1.0.0.0.3 - SOLOPStart - record aggiornati ' || SQL%ROWCOUNT || ' SEZIONI_LINEA di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_0_0_0_3_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_0_0_0_3_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.1.0.0.0.4 - SOLOPEnd
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_1_0_0_0_4_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.SEZIONI_LINEA new 
     Set new.SOL_1_1_0_0_0_4 = (Select old.SOL_1_1_0_0_0_4
                                  From Rinf_Pubblicati_Evo.SEZIONI_LINEA old 
						         Where old.CODICE_VERSIONE = v_Codice_Versione -1
							       And old.SEDE_TECNICA  = new.SEDE_TECNICA) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.1.0.0.0.4 - SOLOPEnd - record aggiornati ' || SQL%ROWCOUNT || ' SEZIONI_LINEA di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_0_0_0_4_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_0_0_0_4_ROLLBACK;


-- --------------------------------------------------------------------------------------------------------------------   
-- Parametri assegnati al depositario di sede centrale RC_RINF_DCO (Direzione Commerciale)
--
-- Se la DOIT non ha autorizzato i dati di propria competenza ma, la DCO si, i parametri di pertinenza DCO approvati 
-- vanno comunque assegnati
-- --------------------------------------------------------------------------------------------------------------------   
--
-- -------------------------------------------------------------------------------------------
-- 1.1.1.0.0.2	SOLTrackDirection
-- -------------------------------------------------------------------------------------------

Procedure PAR_1_1_1_0_0_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is
 begin 
  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old
  Set 
  /*
        old.SOL_TRACK_1_1_1_0_0_2_AP = (Select Nvl(new.SOL_TRACK_1_1_1_0_0_2_AP, 'NYA')
                                          From RINF_AUTORIZZAZIONI_EVO.BINARI_CORSA_SOL new 
									     Where new.SOL_TRACK_1_1_1_0_0_1  = old.SOL_TRACK_1_1_1_0_0_1) ,
*/

        old.SOL_TRACK_1_1_1_0_0_2 = (Select new.SOL_TRACK_1_1_1_0_0_2
                                       From RINF_AUTORIZZAZIONI_EVO.BINARI_CORSA_SOL new 
									  Where new.SOL_TRACK_1_1_1_0_0_1 = old.SOL_TRACK_1_1_1_0_0_1) 
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.SEDE_TECNICA in 
		/*	 
	 (Select SEDE_TECNICA 
	    From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	   Where CODICE_DTP = v_DTP);
	*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.0.0.2	SOLTrackDirection - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_0_0_2_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_0_0_2_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.0.0.0.1	OPName
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_0_0_0_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 
--
  p_error_split := 0;
--  
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
     Set old.DEFINIZIONE = (Select new.DEFINIZIONE
                              From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI new 
						     Where new.SEDE_TECNICA  = old.SEDE_TECNICA) 
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.CODICE_DTP = v_DTP
	And old.SEDE_TECNICA in 
/*    ( Select SEDE_TECNICA From RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI); */
    ( Select SEDE_TECNICA From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
	   where CODICE_DTP = v_DTP 
	     And CODICE_VERSIONE = v_Codice_Versione);
--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.1	OPName - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_0_0_0_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_0_0_0_1_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.0.0.0.5	OPGeographicLocation
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_0_0_0_5_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 
--
  p_error_split := 0;
--  
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
     Set old.LATITUDINE = (Select new.LATITUDINE
                              From RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI new 
						     Where new.SEDE_TECNICA  = old.SEDE_TECNICA) ,
         old.LONGITUDINE = (Select new.LONGITUDINE
                              From RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI new 
						     Where new.SEDE_TECNICA  = old.SEDE_TECNICA)
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.CODICE_DTP = v_DTP
		And SEDE_TECNICA in 
/*    ( Select SEDE_TECNICA From RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI); */
    ( Select SEDE_TECNICA From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
	   where CODICE_DTP = v_DTP 
	     And CODICE_VERSIONE = v_Codice_Versione);

--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.5	OPGeographicLocation - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_0_0_0_5_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_0_0_0_5_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.0.0.0.2	UniqueOPID
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_0_0_0_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 
--
  p_error_split := 0;
--
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
     Set old.PO_1_2_0_0_0_2 = (Select new.PO_1_2_0_0_0_2 
                                 From RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI new 
						        Where new.SEDE_TECNICA  = old.SEDE_TECNICA) 
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.CODICE_DTP = v_DTP
		And SEDE_TECNICA in 
/*    ( Select SEDE_TECNICA From RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI); */
    ( Select SEDE_TECNICA From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
	   where CODICE_DTP = v_DTP 
	     And CODICE_VERSIONE = v_Codice_Versione);

--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.2	UniqueOPID - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_0_0_0_2_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_0_0_0_2_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.0.0.0.3	OPTafTapCode
-- escluse le Sedi tecniche Skeleton sia in cancellazione che in inserimento dai parametri multi-valore 
-- in UPD per evitare le duplicazioni, in quanto i parametri vengono valorizzati a parte con lo skeleton
-- -------------------------------------------------------------------------------------------

Procedure PAR_1_2_0_0_0_3_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 
--
  p_error_split := 0;
 --
  Delete From Rinf_Pubblicati_Evo.PAR_1_2_0_0_0_3_TAF_TAP old
        Where old.CODICE_VERSIONE = v_Codice_Versione
		  And old.SEDE_TECNICA in 
		  (Select SEDE_TECNICA 
		     From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
            Where CODICE_VERSIONE = v_Codice_Versione
		      And CODICE_DTP = v_DTP)
--
	      And old.SEDE_TECNICA Not In 
	      (Select SEDE_TECNICA 
		     From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
            Where CODICE_DTP = v_DTP
			  And CODICE_VERSIONE = v_Codice_Versione
			  And FLAG_TIPO = 1
			  And FLAG_STATO_FINALE = 9)   -- Skeleton
			  ;
--
 DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.3	OPTafTapCode - record cancellati ' || SQL%ROWCOUNT || ' PAR_1_2_0_0_0_3_TAF_TAP di '||v_DTP); 
-- 
 Insert into Rinf_Pubblicati_Evo.PAR_1_2_0_0_0_3_TAF_TAP 
        (    SEDE_TECNICA,
             PO_1_2_0_0_0_3,
             KM_INIZIO,
             KM_FINE,
             CODICE_VERSIONE  )
 Select      SEDE_TECNICA,
             PO_1_2_0_0_0_3,
             KM_INIZIO,
             KM_FINE,
             v_Codice_Versione
   From      Rinf_Autorizzazioni_Evo.PAR_1_2_0_0_0_3_TAF_TAP 
   Where     SEDE_TECNICA in 
		     (Select SEDE_TECNICA 
		     From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI 
            Where CODICE_DTP = v_DTP)
--
	    And  SEDE_TECNICA Not In 
          (Select SEDE_TECNICA 
		     From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
            Where CODICE_DTP = v_DTP
			  And CODICE_VERSIONE = v_Codice_Versione
			  And FLAG_TIPO = 1
			  And FLAG_STATO_FINALE = 9)   -- Skeleton
            ;

--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.3	OPTafTapCode - record inseriti ' || SQL%ROWCOUNT || ' PAR_1_2_0_0_0_3_TAF_TAP di '||v_DTP);
-- 
-- aggiornamneto dell'applicabilit  del parametro 
--   Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 

--  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
     Set old.PO_1_2_0_0_0_3_AP = Nvl((Select new.PO_1_2_0_0_0_3_AP
                                        From RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI new 
						               Where new.SEDE_TECNICA  = old.SEDE_TECNICA) , 'NYA')
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.CODICE_DTP = v_DTP
	And old.SEDE_TECNICA in 
/*    ( Select SEDE_TECNICA From RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI); */
    ( Select SEDE_TECNICA From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
	   where CODICE_DTP = v_DTP 
	     And CODICE_VERSIONE = v_Codice_Versione);

--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.3.AP	OPTafTapCode - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_0_0_0_3_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_0_0_0_3_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.0.0.0.4	OPType
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_0_0_0_4_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
--  
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
     Set old.PO_1_2_0_0_0_4 = (Select new.PO_1_2_0_0_0_4
                                 From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI new 
						        Where new.SEDE_TECNICA  = old.SEDE_TECNICA) 
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.CODICE_DTP = v_DTP
	And old.SEDE_TECNICA in 
/*    ( Select SEDE_TECNICA From RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI); */
    ( Select SEDE_TECNICA From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
	   where CODICE_DTP = v_DTP 
	     And CODICE_VERSIONE = v_Codice_Versione);
--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.4	OPType - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_0_0_0_4_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_0_0_0_4_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.0.0.0.6 - OPRailwayLocation
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_0_0_0_6_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 
--
  p_error_split := 0;
--
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
     Set old.KM_INIZIO = (Select new.KM_INIZIO
                                 From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI new 
						        Where new.SEDE_TECNICA  = old.SEDE_TECNICA) ,
         old.PO_1_2_0_0_0_6 = (Select new.PO_1_2_0_0_0_6
                                 From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI new 
						        Where new.SEDE_TECNICA  = old.SEDE_TECNICA) 
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.CODICE_DTP = v_DTP
	And old.SEDE_TECNICA in 
/*    ( Select SEDE_TECNICA From RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI); */
    ( Select SEDE_TECNICA From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
	   where CODICE_DTP = v_DTP 
	     And CODICE_VERSIONE = v_Codice_Versione);

--
  DBMS_OUTPUT.PUT_LINE('1.2.0.0.0.6 - OPRailwayLocation  -record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_0_0_0_6_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_0_0_0_6_UPD;
--
-- -------------------------------------------------------------------------------------------
-- 1.1.0.0.0.2 - SOLLineIdentification  "F5-F6" <SOLLineIdentification Value="F5-F6"/>
-- il parametro viene elaborato senza essere archiviato
-- -------------------------------------------------------------------------------------------
--
 Procedure PAR_1_1_0_0_0_2_UPD (V_Codice_Versione Number, v_DTP Varchar2, p_error_split Out Number) is 

 Begin 
    p_error_split := 0;
 /*
  Update SEZIONI_LINEA old 
     Set old.SOL_1_1_0_0_0_2 = (Select new.SOL_1_1_0_0_0_2
                                  From RINF_AUTORIZZAZIONI_EVO.SEZIONI_LINEA new 
						         Where new.SEDE_TECNICA  = old.SEDE_TECNICA) 
   Where old.CODICE_VERSIONE = v_Codice_Versione
     And old.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.1.0.0.0.2 - SOLLineIdentification - record aggiornati ' || SQL%ROWCOUNT || ' SEZIONI_LINEA di '||v_DTP);
*/
  DBMS_OUTPUT.PUT_LINE('1.1.0.0.0.2 - SOLLineIdentification  di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_0_0_0_2_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_0_0_0_2_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.0.0.0.3 - SOLOPStart
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_1_0_0_0_3_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.SEZIONI_LINEA old 
     Set old.SOL_1_1_0_0_0_3 = (Select new.SOL_1_1_0_0_0_3
                                  From RINF_AUTORIZZAZIONI_EVO.SEZIONI_LINEA new 
						         Where new.SEDE_TECNICA  = old.SEDE_TECNICA) 
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.CODICE_DTP = v_DTP
	And old.SEDE_TECNICA in 
/*    ( Select SEDE_TECNICA From RINF_AUTORIZZAZIONI_EVO.SEZIONI_LINEA); */
    ( Select SEDE_TECNICA From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   where CODICE_DTP = v_DTP 
	     And CODICE_VERSIONE = v_Codice_Versione);
--
  DBMS_OUTPUT.PUT_LINE('1.1.0.0.0.3 - SOLOPStart - record aggiornati ' || SQL%ROWCOUNT || ' SEZIONI_LINEA di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_0_0_0_3_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_0_0_0_3_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.0.0.0.4 - SOLOPEnd
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_1_0_0_0_4_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

 Update Rinf_Pubblicati_Evo.SEZIONI_LINEA old 
     Set old.SOL_1_1_0_0_0_4 = (Select new.SOL_1_1_0_0_0_4
                                  From RINF_AUTORIZZAZIONI_EVO.SEZIONI_LINEA new 
						         Where new.SEDE_TECNICA  = old.SEDE_TECNICA) 
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.CODICE_DTP = v_DTP
	And old.SEDE_TECNICA in 
/*    ( Select SEDE_TECNICA From RINF_AUTORIZZAZIONI_EVO.SEZIONI_LINEA); */
    ( Select SEDE_TECNICA From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   where CODICE_DTP = v_DTP 
	     And CODICE_VERSIONE = v_Codice_Versione);

--
  DBMS_OUTPUT.PUT_LINE('1.1.0.0.0.4 - SOLOPEnd - record aggiornati ' || SQL%ROWCOUNT || ' SEZIONI_LINEA di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_0_0_0_4_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_0_0_0_4_UPD;


-- --------------------------------------------------------------------------------------------------------------------   



-- RC_RINF_DTEC (Specialista DTEC)

-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.0.1	OPTrackIMCode
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_1_0_0_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_PO new 
  Set new.PO_TRACK_1_2_1_0_0_1 = Nvl((Select old.PO_TRACK_1_2_1_0_0_1
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_PO old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2), '0083')
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.PO_TRACK_1_2_1_0_0_2 in (Select b.PO_TRACK_1_2_1_0_0_2
	                                   From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
							                Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA b
							          Where po.CODICE_VERSIONE = v_Codice_Versione
							            And po.CODICE_VERSIONE = b.CODICE_VERSIONE
							        	And po.SEDE_TECNICA = b.SEDE_TECNICA
							            And po.CODICE_DTP = v_DTP);
--
	DBMS_OUTPUT.PUT_LINE('1.2.1.0.0.1	OPTrackIMCode - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_PO di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_0_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_0_1_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.7.10	IHS_RedLights
-- -------------------------------------------------------------------------------------------

Procedure PAR_1_1_1_1_7_10_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new 
  Set new.SOL_TRACK_1_1_1_1_7_10_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_7_10_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_1_7_10 = (Select old.SOL_TRACK_1_1_1_1_7_10
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							  	And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.7.10	IHS_RedLights - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_7_10_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_7_10_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.4.1	RUL_LocalRulesOrRestrictions
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_1_1_4_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new 
  Set new.SOL_TRACK_1_1_1_4_1_AP = Nvl((Select old.SOL_TRACK_1_1_1_4_1_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) , 'NYA'),

      new.SOL_TRACK_1_1_1_4_1 = (Select old.SOL_TRACK_1_1_1_4_1
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							  	And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.4.1 - RUL_LocalRulesOrRestrictions - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_4_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_4_1_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.4.2	RUL_LocalRulesOrRestrictionsDocRef
--   Rinf_Pubblicati_Evo.PAR_1_1_1_4_2_NORME_DOC
-- -------------------------------------------------------------------------------------------
 Procedure PAR_1_1_1_4_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;

 Delete From  Rinf_Pubblicati_Evo.PAR_1_1_1_4_2_NORME_DOC new
        Where CODICE_VERSIONE = v_Codice_Versione
		  And SOL_TRACK_1_1_1_0_0_1 in 
		  (Select SOL_TRACK_1_1_1_0_0_1 
		     from Rinf_Pubblicati_Evo.SEZIONI_LINEA s,
			      Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
        Where b.SEDE_TECNICA = s.SEDE_TECNICA
		  And b.CODICE_VERSIONE = s.CODICE_VERSIONE
		  And s.CODICE_VERSIONE = v_Codice_Versione
		  And s.CODICE_DTP =  v_DTP);
--
DBMS_OUTPUT.PUT_LINE('1.1.1.4.2	RUL_LocalRulesOrRestrictionsDocRef - record cancellati ' || SQL%ROWCOUNT || ' PAR_1_1_1_4_2_NORME_DOC di '||v_DTP); 

-- 
 Insert into Rinf_Pubblicati_Evo.PAR_1_1_1_4_2_NORME_DOC new
        (    SOL_TRACK_1_1_1_0_0_1,
             SOL_TRACK_1_1_1_4_2,
             CODICE_VERSIONE,  
             KM_INIZIO,
             KM_FINE,
			 LATITUDINE_INIZIO,
             LONGITUDINE_INIZIO,
             ALTITUDINE_INIZIO,
             LATITUDINE_FINE,
             LONGITUDINE_FINE,
             ALTITUDINE_FINE,
             FLAG_CALCOLATO)
 Select      SOL_TRACK_1_1_1_0_0_1,
             SOL_TRACK_1_1_1_4_2,
             v_Codice_Versione,  
             KM_INIZIO,
             KM_FINE,
			 LATITUDINE_INIZIO,
             LONGITUDINE_INIZIO,
             ALTITUDINE_INIZIO,
             LATITUDINE_FINE,
             LONGITUDINE_FINE,
             ALTITUDINE_FINE,
             FLAG_CALCOLATO
   From      Rinf_Pubblicati_Evo.PAR_1_1_1_4_2_NORME_DOC old
   Where     CODICE_VERSIONE = v_CODICE_VERSIONE -1
     And    (old.SOL_TRACK_1_1_1_0_0_1) in 
		    (Select b.SOL_TRACK_1_1_1_0_0_1  
		     From Rinf_Pubblicati_Evo.SEZIONI_LINEA s,
			      Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
        Where s.CODICE_VERSIONE = v_Codice_Versione -1
		  And b.CODICE_VERSIONE = s.CODICE_VERSIONE
		  And b.SEDE_TECNICA = s.SEDE_TECNICA
		  And s.CODICE_DTP =  v_DTP)
--->
          And old.SOL_TRACK_1_1_1_0_0_1 in 
		     (Select SOL_TRACK_1_1_1_0_0_1 
			    From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL
              Where CODICE_VERSIONE = v_Codice_Versione
			  )		  ;
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.4.2	RUL_LocalRulesOrRestrictionsDocRef - record inseriti ' || SQL%ROWCOUNT || ' PAR_1_1_1_4_2_NORME_DOC di '||v_DTP);
-- 

-- aggiornamneto dell'applicabilit  del parametro 
   Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new 
      Set SOL_TRACK_1_1_1_4_2_AP = Nvl((Select SOL_TRACK_1_1_1_4_2_AP
                                      From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old
								     Where old.CODICE_VERSIONE = v_Codice_Versione -1
									   And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1
--->
		                               And Exists ( Select SOL_TRACK_1_1_1_0_0_1 
											         From Rinf_Pubblicati_Evo.PAR_1_1_1_4_2_NORME_DOC
		                                            Where SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1 
		                                              And CODICE_VERSIONE = v_Codice_Versione -1)
--->
										  ), 'NYA')   
    Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SOL_TRACK_1_1_1_0_0_1 in 
		    (Select SOL_TRACK_1_1_1_0_0_1
 		       From Rinf_Pubblicati_Evo.SEZIONI_LINEA s,
			        Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
              Where b.SEDE_TECNICA = s.SEDE_TECNICA
		        And b.CODICE_VERSIONE = s.CODICE_VERSIONE
		        And s.CODICE_VERSIONE = v_Codice_Versione
				And s.SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
				And s.CODICE_DTP =  v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.4.2.AP	RUL_LocalRulesOrRestrictionsDocRef - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_4_2_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_4_2_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.2.2.0.0.1	OPSidingIMCode
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_2_0_0_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO new 
  Set new.PO_SD_1_2_2_0_0_1 = Nvl((Select old.PO_SD_1_2_2_0_0_1
                                       From Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.PO_SD_1_2_2_0_0_2 = new.PO_SD_1_2_2_0_0_2) , '0083')
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA
	                                   From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po
							          Where CODICE_VERSIONE = v_Codice_Versione
--							           	And po.SEDE_TECNICA = new.SEDE_TECNICA
							            And po.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.2.2.0.0.1	OPSidingIMCode - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_RACCORDO_PO di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_2_0_0_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_2_0_0_1_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.5.1	OPTrackTunnelIMCode
-- -------------------------------------------------------------------------------------------

Procedure PAR_1_2_1_0_5_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO new 
  Set new.PO_TR_TUNNEL_1_2_1_0_5_1 = Nvl((Select old.PO_TR_TUNNEL_1_2_1_0_5_1
                                       From Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.PO_TR_TUNNEL_1_2_1_0_5_2 = new.PO_TR_TUNNEL_1_2_1_0_5_2), '0083')
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.PO_TR_TUNNEL_1_2_1_0_5_2 in (Select rel_gal_po.PO_TR_TUNNEL_1_2_1_0_5_2
	                                       From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
									            Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO rel_gal_po,
									    		Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_bin_po
							              Where po.CODICE_VERSIONE = v_Codice_Versione
									        And po.CODICE_VERSIONE = rel_bin_po.CODICE_VERSIONE 
									    	And rel_gal_po.PO_TRACK_1_2_1_0_0_2 = rel_bin_po.PO_TRACK_1_2_1_0_0_2
									    	And rel_gal_po.CODICE_VERSIONE = rel_bin_po.CODICE_VERSIONE
							               	And po.SEDE_TECNICA = rel_bin_po.SEDE_TECNICA
							                And po.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.2.1.0.5.1	OPTrackTunnelIMCode - record aggiornati ' || SQL%ROWCOUNT || ' GALLERIE_BINARI_PO di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_5_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_5_1_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.8.1	SOLTunnelIMCode
-- -------------------------------------------------------------------------------------------

Procedure PAR_1_1_1_1_8_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL new 
   Set new.SOL_TUNNEL_1_1_1_1_8_1 = Nvl((Select old.SOL_TUNNEL_1_1_1_1_8_1
                                       From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TUNNEL_1_1_1_1_8_2 = new.SOL_TUNNEL_1_1_1_1_8_2) , '0083')
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SOL_TUNNEL_1_1_1_1_8_2 in (Select rel_gal_sol.SOL_TUNNEL_1_1_1_1_8_2
	                                       From Rinf_Pubblicati_Evo.SEZIONI_LINEA sol,
	                                            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL bin_sol,
									            Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL rel_gal_sol
							              Where sol.CODICE_VERSIONE = v_Codice_Versione
                                            And bin_sol.SEDE_TECNICA = sol.SEDE_TECNICA 
									        And bin_sol.CODICE_VERSIONE = sol.CODICE_VERSIONE 
									    	And rel_gal_sol.SOL_TRACK_1_1_1_0_0_1 = bin_sol.SOL_TRACK_1_1_1_0_0_1
									        And rel_gal_sol.CODICE_VERSIONE  = bin_sol.CODICE_VERSIONE		
											And sol.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.8.1	SOLTunnelIMCode - record aggiornati ' || SQL%ROWCOUNT || ' GALLERIE_BINARI_SOL di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_8_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_8_1_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.2.2.0.5.1	OPSidingTunnelIMCode
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_2_0_5_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.GALLERIE_RACCORDO_PO new 
  Set new.PO_SD_TUNNEL_1_2_2_0_5_1 = Nvl((Select old.PO_SD_TUNNEL_1_2_2_0_5_1
                                       From Rinf_Pubblicati_Evo.GALLERIE_RACCORDO_PO old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.PO_SD_TUNNEL_1_2_2_0_5_2 = new.PO_SD_TUNNEL_1_2_2_0_5_2) , '0083')
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.PO_SD_TUNNEL_1_2_2_0_5_2 in (Select rel_gal_po.PO_SD_TUNNEL_1_2_2_0_5_2
	                                       From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
									            Rinf_Pubblicati_Evo.REL_GALLERIE_RACCORDO_PO rel_gal_po,
									    		Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO bin_racc_po
							              Where po.CODICE_VERSIONE = v_Codice_Versione
									        And po.CODICE_VERSIONE = bin_racc_po.CODICE_VERSIONE 
							               	And po.SEDE_TECNICA = bin_racc_po.SEDE_TECNICA
									    	And rel_gal_po.PO_SD_1_2_2_0_0_2 = bin_racc_po.PO_SD_1_2_2_0_0_2
									    	And rel_gal_po.CODICE_VERSIONE = bin_racc_po.CODICE_VERSIONE
							                And po.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.2.2.0.5.1	OPSidingTunnelIMCode - record aggiornati ' || SQL%ROWCOUNT || ' GALLERIE_RACCORDO_PO di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_2_0_5_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_2_0_5_1_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.6.1	OPTrackPlatformIMCode
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_1_0_6_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;

   Update Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO new
      Set PO_TR_PLATFORM_1_2_1_0_6_1 = Nvl(( Select PO_TR_PLATFORM_1_2_1_0_6_1
	                                       From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO old 
										  Where old.PO_TR_PLATFORM_1_2_1_0_6_2 = new.PO_TR_PLATFORM_1_2_1_0_6_2
										    And old.CODICE_VERSIONE = v_Codice_Versione -1), '0083')
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And (
	      new.BINARIO_1 In  (Select rel_po_bin.PO_TRACK_1_2_1_0_0_2 
	                         From Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_po_bin,
							      Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po
						    Where po.CODICE_VERSIONE = v_Codice_Versione
						      And po.CODICE_VERSIONE = rel_po_bin.CODICE_VERSIONE 
						      And po.SEDE_TECNICA = rel_po_bin.SEDE_TECNICA
						      And po.CODICE_DTP = v_DTP)
           Or	
	      new.BINARIO_2 In  (Select rel_po_bin.PO_TRACK_1_2_1_0_0_2 
	                         From Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_po_bin,
							      Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po
						    Where po.CODICE_VERSIONE = v_Codice_Versione
						      And po.CODICE_VERSIONE = rel_po_bin.CODICE_VERSIONE 
						      And po.SEDE_TECNICA = rel_po_bin.SEDE_TECNICA
						      And po.CODICE_DTP = v_DTP)
           Or	
	      new.BINARIO_3 In  (Select rel_po_bin.PO_TRACK_1_2_1_0_0_2 
	                         From Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_po_bin,
							      Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po
						    Where po.CODICE_VERSIONE = v_Codice_Versione
						      And po.CODICE_VERSIONE = rel_po_bin.CODICE_VERSIONE 
						      And po.SEDE_TECNICA = rel_po_bin.SEDE_TECNICA
						      And po.CODICE_DTP = v_DTP)
           Or	
	      new.BINARIO_4 In  (Select rel_po_bin.PO_TRACK_1_2_1_0_0_2 
	                         From Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_po_bin,
							      Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po
						    Where po.CODICE_VERSIONE = v_Codice_Versione
						      And po.CODICE_VERSIONE = rel_po_bin.CODICE_VERSIONE 
						      And po.SEDE_TECNICA = rel_po_bin.SEDE_TECNICA
						      And po.CODICE_DTP = v_DTP)
     );
--
  DBMS_OUTPUT.PUT_LINE('1.2.1.0.6.1	OPTrackPlatformIMCode - record aggiornati ' || SQL%ROWCOUNT || ' MARCIAPIEDI_BINARI_PO di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_6_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_6_1_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.2.3.1		RUL_LocalRulesOrRestrictions
-- -------------------------------------------------------------------------------------------
 Procedure PAR_1_2_3_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI new 
     Set new.PO_1_2_3_1_AP = Nvl((Select old.PO_1_2_3_1_AP
                              From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA) , 'NYA'),
         new.PO_1_2_3_1    = (Select old.PO_1_2_3_1
                              From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.2.3.1	- RUL_LocalRulesOrRestrictions - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_3_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_3_1_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.2.3.2		RUL_LocalRulesOrRestrictionsDocRef
-- -------------------------------------------------------------------------------------------
 Procedure PAR_1_2_3_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;

 Delete From  Rinf_Pubblicati_Evo.PAR_1_2_3_2_DOC_NORME new
        Where new.CODICE_VERSIONE = v_Codice_Versione
		  And new.SEDE_TECNICA in 
		  (Select SEDE_TECNICA 
		     From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
            Where CODICE_VERSIONE = v_Codice_Versione
		      And CODICE_DTP = v_DTP);
--
DBMS_OUTPUT.PUT_LINE('1.2.3.2 - RUL_LocalRulesOrRestrictionsDocRef - record cancellati ' || SQL%ROWCOUNT || ' PAR_1_2_3_2_DOC_NORME di '||v_DTP); 

-- 
 Insert into Rinf_Pubblicati_Evo.PAR_1_2_3_2_DOC_NORME new
        (    SEDE_TECNICA,
             PO_1_2_3_2,
             CODICE_VERSIONE  )
 Select      SEDE_TECNICA,
             PO_1_2_3_2,
             v_Codice_Versione
   From      Rinf_Pubblicati_Evo.PAR_1_2_3_2_DOC_NORME old
   Where     old.CODICE_VERSIONE = v_CODICE_VERSIONE -1
     And     old.SEDE_TECNICA in 
		     (Select SEDE_TECNICA 
		     From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
            Where CODICE_VERSIONE = v_Codice_Versione
		      And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.2.3.2 - RUL_LocalRulesOrRestrictionsDocRef - record inseriti ' || SQL%ROWCOUNT || ' PAR_1_2_3_2_DOC_NORME di '||v_DTP); 
--
-- aggiornamneto dell'applicabilit  del parametro 
--   Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI new 

  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI new 
     Set new.PO_1_2_3_2_AP = Nvl((Select old.PO_1_2_3_2_AP
                              From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old 
						     Where old.CODICE_VERSIONE = v_Codice_Versione -1
							   And old.SEDE_TECNICA  = new.SEDE_TECNICA
--->
                               And Exists ( Select SEDE_TECNICA
											  From Rinf_Pubblicati_Evo.PAR_1_2_3_2_DOC_NORME 
		                                     Where SEDE_TECNICA  = new.SEDE_TECNICA 
		                                       And CODICE_VERSIONE = v_Codice_Versione -1)
--->
							          ), 'NYA')
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.2.3.2.AP - RUL_LocalRulesOrRestrictionsDocRef - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_3_2_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_3_2_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.0.0.0.1	SOLIMCode
-- -------------------------------------------------------------------------------------------
 Procedure PAR_1_1_0_0_0_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.SEZIONI_LINEA new 
     Set new.SOL_1_1_0_0_0_1 = Nvl((Select old.SOL_1_1_0_0_0_1
                                  From Rinf_Pubblicati_Evo.SEZIONI_LINEA old 
						         Where old.CODICE_VERSIONE = v_Codice_Versione -1
							       And old.SEDE_TECNICA  = new.SEDE_TECNICA), '0083')
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.1.0.0.0.1	SOLIMCode - record aggiornati ' || SQL%ROWCOUNT || ' SEZIONI_LINEA di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_0_0_0_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_0_0_0_1_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.0.1	OPTrackIMCode
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_1_0_0_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_PO old 
  Set old.PO_TRACK_1_2_1_0_0_1 = Nvl((Select new.PO_TRACK_1_2_1_0_0_1
                                       From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO new 
									  Where new.PO_TRACK_1_2_1_0_0_2 = old.PO_TRACK_1_2_1_0_0_2), '0083')
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.PO_TRACK_1_2_1_0_0_2 in (Select b.PO_TRACK_1_2_1_0_0_2
--	                                   From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI po,
--							                Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA b
	                                   From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
							                Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA b
							          Where po.SEDE_TECNICA = b.SEDE_TECNICA
                                        And po.CODICE_VERSIONE = b.CODICE_VERSIONE 
                                        And po.CODICE_VERSIONE = v_Codice_Versione               
							            And po.CODICE_DTP = v_DTP);
--
	DBMS_OUTPUT.PUT_LINE('1.2.1.0.0.1	OPTrackIMCode - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_PO di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_0_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_0_1_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.7.10	IHS_RedLights
-- -------------------------------------------------------------------------------------------

Procedure PAR_1_1_1_1_7_10_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
  Set old.SOL_TRACK_1_1_1_1_7_10_AP = Nvl((Select new.SOL_TRACK_1_1_1_1_7_10_AP
                                       From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL new 
									  Where new.SOL_TRACK_1_1_1_0_0_1  = old.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
--
      old.SOL_TRACK_1_1_1_1_7_10 = (Select new.SOL_TRACK_1_1_1_1_7_10
                                       From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL new 
									  Where new.SOL_TRACK_1_1_1_0_0_1  = old.SOL_TRACK_1_1_1_0_0_1) 
  Where old.CODICE_VERSIONE = v_Codice_Versione
	And old.SEDE_TECNICA in 
/*    ( Select SEDE_TECNICA From RINF_AUTORIZZAZIONI_EVO.SEZIONI_LINEA); */
    ( Select SEDE_TECNICA From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   where CODICE_DTP = v_DTP 
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_VERSIONE = v_Codice_Versione);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.7.10	IHS_RedLights - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_7_10_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_7_10_UPD;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.4.1	RUL_LocalRulesOrRestrictions
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_1_1_4_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
     Set old.SOL_TRACK_1_1_1_4_1_AP = Nvl((Select new.SOL_TRACK_1_1_1_4_1_AP
                                             From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL new 
									        Where new.SOL_TRACK_1_1_1_0_0_1 = old.SOL_TRACK_1_1_1_0_0_1) , 'NYA'),
--
         old.SOL_TRACK_1_1_1_4_1 =        (Select new.SOL_TRACK_1_1_1_4_1
                                             From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL new 
									        Where new.SOL_TRACK_1_1_1_0_0_1 = old.SOL_TRACK_1_1_1_0_0_1) 
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.SEDE_TECNICA in 
	/*    ( Select SEDE_TECNICA From RINF_AUTORIZZAZIONI_EVO.SEZIONI_LINEA); */
    (Select SEDE_TECNICA 
	   From RINF_Pubblicati_EVO.SEZIONI_LINEA 
	  where CODICE_DTP = v_DTP 
	  	And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	   And CODICE_VERSIONE = v_Codice_Versione);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.4.1 - RUL_LocalRulesOrRestrictions - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  Exception
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_4_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_4_1_UPD;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.4.2	RUL_LocalRulesOrRestrictionsDocRef
--   Rinf_Pubblicati_Evo.PAR_1_1_1_4_2_NORME_DOC
-- escluse le Sedi tecniche Skeleton sia in cancellazione che in inserimento dai parametri multi-valore 
-- in UPD per evitare le duplicazioni, in quanto i parametri vengono valorizzati a parte con lo skeleton
-- -------------------------------------------------------------------------------------------
 Procedure PAR_1_1_1_4_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;

 Delete From  Rinf_Pubblicati_Evo.PAR_1_1_1_4_2_NORME_DOC old
        Where CODICE_VERSIONE = v_Codice_Versione
		  And SOL_TRACK_1_1_1_0_0_1 in 
/*
		    (Select SOL_TRACK_1_1_1_0_0_1
 		       From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA s,
			        Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
              Where b.SEDE_TECNICA = s.SEDE_TECNICA                   
		        And s.CODICE_DTP =  v_DTP);
*/
		    (Select SOL_TRACK_1_1_1_0_0_1
 		       From Rinf_Pubblicati_Evo.SEZIONI_LINEA s,
			        Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
              Where b.SEDE_TECNICA = s.SEDE_TECNICA 
                And b.CODICE_VERSIONE = s.CODICE_VERSIONE 
                And s.CODICE_VERSIONE = v_Codice_Versione 
	            And s.CODICE_DTP =  v_DTP
--
	            And s.SEDE_TECNICA Not In 
	            (Select SEDE_TECNICA 
		           From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
                  Where CODICE_DTP = v_DTP
		    	    And CODICE_VERSIONE = v_Codice_Versione
		    	    And FLAG_TIPO = 1
		    	    And FLAG_STATO_FINALE = 9
				 )   -- Skeleton
             );
--
DBMS_OUTPUT.PUT_LINE('1.1.1.4.2	RUL_LocalRulesOrRestrictionsDocRef - record cancellati ' || SQL%ROWCOUNT || ' PAR_1_1_1_4_2_NORME_DOC di '||v_DTP); 
-- 
 Insert into Rinf_Pubblicati_Evo.PAR_1_1_1_4_2_NORME_DOC old
        (    SOL_TRACK_1_1_1_0_0_1,
             SOL_TRACK_1_1_1_4_2,
             CODICE_VERSIONE,  
             KM_INIZIO,
             KM_FINE,
			 LATITUDINE_INIZIO,
             LONGITUDINE_INIZIO,
             ALTITUDINE_INIZIO,
             LATITUDINE_FINE,
             LONGITUDINE_FINE,
             ALTITUDINE_FINE,
             FLAG_CALCOLATO)
 Select      SOL_TRACK_1_1_1_0_0_1,
             SOL_TRACK_1_1_1_4_2,
             v_Codice_Versione,  
             KM_INIZIO,
             KM_FINE,
			 LATITUDINE_INIZIO,
             LONGITUDINE_INIZIO,
             ALTITUDINE_INIZIO,
             LATITUDINE_FINE,
             LONGITUDINE_FINE,
             ALTITUDINE_FINE,
             FLAG_CALCOLATO
   From      Rinf_Autorizzazioni_Evo.PAR_1_1_1_4_2_NORME_DOC new
   Where     new.SOL_TRACK_1_1_1_0_0_1 in 
		    (Select b.SOL_TRACK_1_1_1_0_0_1  
		       From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA s,
			        Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
              Where b.SEDE_TECNICA = s.SEDE_TECNICA
		        And s.CODICE_DTP =  v_DTP
--
	            And s.SEDE_TECNICA Not In 
	            (Select SEDE_TECNICA 
		           From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
                  Where CODICE_DTP = v_DTP
		    	    And CODICE_VERSIONE = v_Codice_Versione
		    	    And FLAG_TIPO = 1
		    	    And FLAG_STATO_FINALE = 9
				 )   -- Skeleton
		    );

--
  DBMS_OUTPUT.PUT_LINE('1.1.1.4.2	RUL_LocalRulesOrRestrictionsDocRef - record inseriti ' || SQL%ROWCOUNT || ' PAR_1_1_1_4_2_NORME_DOC di '||v_DTP);
-- 

-- aggiornamneto dell'applicabilit  del parametro 
   Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new 
      Set SOL_TRACK_1_1_1_4_2_AP = Nvl((Select distinct SOL_TRACK_1_1_1_4_2_AP
                                          From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old
								         Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) , 'NYA')
    Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SOL_TRACK_1_1_1_0_0_1 in 
		    (Select SOL_TRACK_1_1_1_0_0_1
 		       From Rinf_Pubblicati_Evo.SEZIONI_LINEA s,
			        Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
              Where b.CODICE_VERSIONE = s.CODICE_VERSIONE
			    And b.SEDE_TECNICA = s.SEDE_TECNICA
				And s.CODICE_VERSIONE = v_Codice_Versione
				And s.SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular				
		        And s.CODICE_DTP =  v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.4.2.AP	RUL_LocalRulesOrRestrictionsDocRef - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  Exception
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_4_2_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_4_2_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.2.0.0.1	OPSidingIMCode
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_2_0_0_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO old 
     Set old.PO_SD_1_2_2_0_0_1 = Nvl((Select new.PO_SD_1_2_2_0_0_1
                                        From Rinf_Autorizzazioni_Evo.BINARI_RACCORDO_PO new 
								       Where new.PO_SD_1_2_2_0_0_2 = old.PO_SD_1_2_2_0_0_2) , '0083')
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.SEDE_TECNICA in 
	/*    ( Select SEDE_TECNICA From RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI); */
    ( Select SEDE_TECNICA From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
	   where CODICE_DTP = v_DTP 
	     And CODICE_VERSIONE = v_Codice_Versione);
--
  DBMS_OUTPUT.PUT_LINE('1.2.2.0.0.1	OPSidingIMCode - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_RACCORDO_PO di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_2_0_0_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_2_0_0_1_UPD;


-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.5.1	OPTrackTunnelIMCode
-- -------------------------------------------------------------------------------------------

Procedure PAR_1_2_1_0_5_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO old
     Set old.PO_TR_TUNNEL_1_2_1_0_5_1 = Nvl((Select new.PO_TR_TUNNEL_1_2_1_0_5_1
                                               From Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_PO new 
									          Where new.PO_TR_TUNNEL_1_2_1_0_5_2 = old.PO_TR_TUNNEL_1_2_1_0_5_2), '0083')
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.PO_TR_TUNNEL_1_2_1_0_5_2 in 
	                       (Select rel_gal_po.PO_TR_TUNNEL_1_2_1_0_5_2
--	                                       From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI po,
--						    					Rinf_Autorizzazioni_Evo.REL_GALLERIE_BINARI_PO rel_gal_po,
--						    					Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA rel_bin_po
	                           From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
									Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO rel_gal_po,
									Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_bin_po
				              Where rel_gal_po.PO_TRACK_1_2_1_0_0_2 = rel_bin_po.PO_TRACK_1_2_1_0_0_2
				    	        And rel_gal_po.CODICE_VERSIONE = rel_bin_po.CODICE_VERSIONE
				               	And po.SEDE_TECNICA = rel_bin_po.SEDE_TECNICA
				    	        And po.CODICE_VERSIONE = rel_bin_po.CODICE_VERSIONE
                                And po.CODICE_VERSIONE = v_Codice_Versione 
				                And po.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.2.1.0.5.1	OPTrackTunnelIMCode - record aggiornati ' || SQL%ROWCOUNT || ' GALLERIE_BINARI_PO di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_5_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_5_1_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.8.1	SOLTunnelIMCode
-- -------------------------------------------------------------------------------------------

Procedure PAR_1_1_1_1_8_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL old  
   Set old .SOL_TUNNEL_1_1_1_1_8_1 = Nvl((Select new.SOL_TUNNEL_1_1_1_1_8_1
                                            From Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_SOL new 
									       Where new.SOL_TUNNEL_1_1_1_1_8_2 = old.SOL_TUNNEL_1_1_1_1_8_2) , '0083')
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.SOL_TUNNEL_1_1_1_1_8_2 in 
	(Select rel_gal_sol.SOL_TUNNEL_1_1_1_1_8_2
--	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA sol,
--	        Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL bin_sol,
--		    Rinf_Autorizzazioni_Evo.REL_GALLERIE_BINARI_SOL rel_gal_sol
	   From Rinf_Pubblicati_Evo.SEZIONI_LINEA sol,
	        Rinf_Pubblicati_Evo.BINARI_CORSA_SOL bin_sol,
		    Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL rel_gal_sol
	  Where bin_sol.SEDE_TECNICA = sol.SEDE_TECNICA 
        And bin_sol.CODICE_VERSIONE = sol.CODICE_VERSIONE
	    And rel_gal_sol.SOL_TRACK_1_1_1_0_0_1 = bin_sol.SOL_TRACK_1_1_1_0_0_1
        And rel_gal_sol.CODICE_VERSIONE = bin_sol.CODICE_VERSIONE
        And sol.CODICE_VERSIONE = v_Codice_Versione 
		And sol.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.8.1	SOLTunnelIMCode - record aggiornati ' || SQL%ROWCOUNT || ' GALLERIE_BINARI_SOL di '||v_DTP);
--
  Exception
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_8_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_8_1_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.2.0.5.1	OPSidingTunnelIMCode
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_2_0_5_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.GALLERIE_RACCORDO_PO old 
     Set old.PO_SD_TUNNEL_1_2_2_0_5_1 = Nvl((Select new.PO_SD_TUNNEL_1_2_2_0_5_1
                                               From Rinf_Autorizzazioni_Evo.GALLERIE_RACCORDO_PO new 
									          Where new.PO_SD_TUNNEL_1_2_2_0_5_2 = old.PO_SD_TUNNEL_1_2_2_0_5_2) , '0083')
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.PO_SD_TUNNEL_1_2_2_0_5_2 in 
	(Select rel_gal_po.PO_SD_TUNNEL_1_2_2_0_5_2
--	   From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI po,
--			Rinf_Autorizzazioni_Evo.REL_GALLERIE_RACCORDO_PO rel_gal_po,
--			Rinf_Autorizzazioni_Evo.BINARI_RACCORDO_PO bin_racc_po
	   From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
		    Rinf_Pubblicati_Evo.REL_GALLERIE_RACCORDO_PO rel_gal_po,
		    Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO bin_racc_po
      Where po.SEDE_TECNICA = bin_racc_po.SEDE_TECNICA
        And po.CODICE_VERSIONE = bin_racc_po.CODICE_VERSIONE
    	And rel_gal_po.PO_SD_1_2_2_0_0_2 = bin_racc_po.PO_SD_1_2_2_0_0_2
        And rel_gal_po.CODICE_VERSIONE = bin_racc_po.CODICE_VERSIONE
        And po.CODICE_VERSIONE = v_Codice_Versione
   	    And po.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.2.2.0.5.1	OPSidingTunnelIMCode - record aggiornati ' || SQL%ROWCOUNT || ' GALLERIE_RACCORDO_PO di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_2_0_5_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_2_0_5_1_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.6.1	OPTrackPlatformIMCode
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_1_0_6_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;

   Update Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO old
      Set old.PO_TR_PLATFORM_1_2_1_0_6_1 = Nvl(( Select new.PO_TR_PLATFORM_1_2_1_0_6_1
	                                               From Rinf_Autorizzazioni_Evo.MARCIAPIEDI_BINARI_PO new
										          Where new.PO_TR_PLATFORM_1_2_1_0_6_2 = old.PO_TR_PLATFORM_1_2_1_0_6_2)
										          , '0083')
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And (
	      old.BINARIO_1 In  (Select rel_po_bin.PO_TRACK_1_2_1_0_0_2 
--	                         From Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA rel_po_bin,
--							      Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI po
	                         From Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_po_bin,
							      Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po
						    Where po.SEDE_TECNICA = rel_po_bin.SEDE_TECNICA
                              And po.CODICE_VERSIONE = rel_po_bin.CODICE_VERSIONE
                              And po.CODICE_VERSIONE = v_Codice_Versione
						      And po.CODICE_DTP = v_DTP)
           Or	
	      old.BINARIO_2 In  (Select rel_po_bin.PO_TRACK_1_2_1_0_0_2 
--	                         From Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA rel_po_bin,
--							      Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI po
	                         From Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_po_bin,
							      Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po
						    Where po.SEDE_TECNICA = rel_po_bin.SEDE_TECNICA
                              And po.CODICE_VERSIONE = rel_po_bin.CODICE_VERSIONE
                              And po.CODICE_VERSIONE = v_Codice_Versione
						      And po.CODICE_DTP = v_DTP)
           Or	
	      old.BINARIO_3 In  (Select rel_po_bin.PO_TRACK_1_2_1_0_0_2 
--	                         From Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA rel_po_bin,
--							      Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI po
	                         From Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_po_bin,
							      Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po
						    Where po.SEDE_TECNICA = rel_po_bin.SEDE_TECNICA
                              And po.CODICE_VERSIONE = rel_po_bin.CODICE_VERSIONE
                              And po.CODICE_VERSIONE = v_Codice_Versione
						      And po.CODICE_DTP = v_DTP)
           Or	
	      old.BINARIO_4 In  (Select rel_po_bin.PO_TRACK_1_2_1_0_0_2 
--	                         From Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA rel_po_bin,
--							      Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI po
	                         From Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_po_bin,
							      Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po
						    Where po.SEDE_TECNICA = rel_po_bin.SEDE_TECNICA
                              And po.CODICE_VERSIONE = rel_po_bin.CODICE_VERSIONE
                              And po.CODICE_VERSIONE = v_Codice_Versione
						      And po.CODICE_DTP = v_DTP)
     );
--
  DBMS_OUTPUT.PUT_LINE('1.2.1.0.6.1	OPTrackPlatformIMCode - record aggiornati ' || SQL%ROWCOUNT || ' MARCIAPIEDI_BINARI_PO di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_6_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_6_1_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.3.1		RUL_LocalRulesOrRestrictions
-- -------------------------------------------------------------------------------------------
 Procedure PAR_1_2_3_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old  
     Set old.PO_1_2_3_1_AP = Nvl((Select new.PO_1_2_3_1_AP
                                    From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI new
						           Where new.SEDE_TECNICA  = old.SEDE_TECNICA) , 'NYA'),
--
         old.PO_1_2_3_1    =     (Select new.PO_1_2_3_1
                                    From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI new 
						           Where new.SEDE_TECNICA  = old.SEDE_TECNICA) 
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.2.3.1	- RUL_LocalRulesOrRestrictions - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_3_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_3_1_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.3.2		RUL_LocalRulesOrRestrictionsDocRef
-- escluse le Sedi tecniche Skeleton sia in cancellazione che in inserimento dai parametri multi-valore 
-- in UPD per evitare le duplicazioni, in quanto i parametri vengono valorizzati a parte con lo skeleton
-- -------------------------------------------------------------------------------------------
 Procedure PAR_1_2_3_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;

 Delete From  Rinf_Pubblicati_Evo.PAR_1_2_3_2_DOC_NORME old
        Where old.CODICE_VERSIONE = v_Codice_Versione
		  And old.SEDE_TECNICA in 
		  (Select SEDE_TECNICA 
		     From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
            Where CODICE_VERSIONE = v_Codice_Versione
			  And CODICE_DTP = v_DTP)
--
			 And old.SEDE_TECNICA Not In 
	        (Select SEDE_TECNICA 
		       From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
              Where CODICE_DTP = v_DTP
			    And CODICE_VERSIONE = v_Codice_Versione
			    And FLAG_TIPO = 1
			    And FLAG_STATO_FINALE = 9);
--
DBMS_OUTPUT.PUT_LINE('1.2.3.2 - RUL_LocalRulesOrRestrictionsDocRef - record cancellati ' || SQL%ROWCOUNT || ' PAR_1_2_3_2_DOC_NORME di '||v_DTP||' - Versione: '||to_char(v_Codice_Versione -1));  

-- 
 Insert into Rinf_Pubblicati_Evo.PAR_1_2_3_2_DOC_NORME old
        (    SEDE_TECNICA,
             PO_1_2_3_2,
             CODICE_VERSIONE  )
 Select      SEDE_TECNICA,
             PO_1_2_3_2,
             v_Codice_Versione
   From      Rinf_Autorizzazioni_Evo.PAR_1_2_3_2_DOC_NORME new
   Where     new.SEDE_TECNICA In 
		     (Select SEDE_TECNICA 
		        From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI 
               Where CODICE_DTP = v_DTP)
--
			 And new.SEDE_TECNICA Not In 
	        (Select SEDE_TECNICA 
		       From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
              Where CODICE_DTP = v_DTP
			    And CODICE_VERSIONE = v_Codice_Versione
			    And FLAG_TIPO = 1
			    And FLAG_STATO_FINALE = 9)
   ;
--
  DBMS_OUTPUT.PUT_LINE('1.2.3.2 - RUL_LocalRulesOrRestrictionsDocRef - record inseriti ' || SQL%ROWCOUNT || ' PAR_1_2_3_2_DOC_NORME di '||v_DTP||' - Versione: '||v_Codice_Versione); 
--
-- aggiornamneto dell'applicabilit  del parametro 
  Update Rinf_Pubblicati_Evo.PUNTI_OPERATIVI old
     Set old.PO_1_2_3_2_AP = Nvl((Select new.PO_1_2_3_2_AP
                              From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI new 
						     Where new.SEDE_TECNICA  = old.SEDE_TECNICA) , 'NYA')
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.2.3.2.AP - RUL_LocalRulesOrRestrictionsDocRef - record aggiornati ' || SQL%ROWCOUNT || ' PUNTI_OPERATIVI di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_3_2_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_3_2_UPD;


-- -------------------------------------------------------------------------------------------
-- 1.1.0.0.0.1	SOLIMCode
-- -------------------------------------------------------------------------------------------
 Procedure PAR_1_1_0_0_0_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.SEZIONI_LINEA old 
     Set old.SOL_1_1_0_0_0_1 = Nvl((Select new.SOL_1_1_0_0_0_1
                                  From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA new 
						         Where new.SEDE_TECNICA  = old.SEDE_TECNICA), '0083') 
  Where old.CODICE_VERSIONE = v_Codice_Versione
    And old.CODICE_DTP = v_DTP;
--
  DBMS_OUTPUT.PUT_LINE('1.1.0.0.0.1	SOLIMCode - record aggiornati ' || SQL%ROWCOUNT || ' SEZIONI_LINEA di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_0_0_0_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_0_0_0_1_UPD;
-- ------------------------------------------------------------------------------------------





-- Parametri assegnati al depositario di sede centrale RC_RINF_DTEC2 (Specialista DTEC 2)

-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.3.5.A	ILL_GaugeCheckLoc
-- 1.2.1.0.3.5.B	ILL_GaugeCheckLoc
-- -------------------------------------------------------------------------------------------
--BINARI_CORSA_PO	PO_TRACK_1_2_1_0_3_5_A, PO_TRACK_1_2_1_0_3_5_B - Sempre Non Applicabile =[]

 Procedure PAR_1_2_1_0_3_5_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
  begin 
  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_PO new 
	Set new.PO_TRACK_1_2_1_0_3_5_AP = Nvl((Select old.PO_TRACK_1_2_1_0_3_5_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_PO old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2) , 'NYA'),
      new.PO_TRACK_1_2_1_0_3_5_A = (Select old.PO_TRACK_1_2_1_0_3_5_A
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_PO old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2),
	  new.PO_TRACK_1_2_1_0_3_5_B = (Select old.PO_TRACK_1_2_1_0_3_5_B
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_PO old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.PO_TRACK_1_2_1_0_0_2 in (Select b.PO_TRACK_1_2_1_0_0_2
	                                   From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
							                Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA b
							          Where po.CODICE_VERSIONE = v_Codice_Versione
							            And po.CODICE_VERSIONE = b.CODICE_VERSIONE
							        	And po.SEDE_TECNICA = b.SEDE_TECNICA
							            And po.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.2.1.0.3.5 - ILL_GaugeCheckLoc - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_PO di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_3_5_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_3_5_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.3.6	ILL_GaugeCheckDocRef
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_PO	PO_TRACK_1_2_1_0_3_6 - Sempre Non Applicabile =[]

 Procedure PAR_1_2_1_0_3_6_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_PO new 
  Set new.PO_TRACK_1_2_1_0_3_6_AP = Nvl((Select old.PO_TRACK_1_2_1_0_3_6_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_PO old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2) , 'NYA'),
	  new.PO_TRACK_1_2_1_0_3_6  =   (Select old.PO_TRACK_1_2_1_0_3_6
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_PO old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2) 								
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.PO_TRACK_1_2_1_0_0_2 in (Select b.PO_TRACK_1_2_1_0_0_2
	                                   From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
							                Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA b
							          Where po.CODICE_VERSIONE = v_Codice_Versione
							            And po.CODICE_VERSIONE = b.CODICE_VERSIONE
							        	And po.SEDE_TECNICA = b.SEDE_TECNICA
							            And po.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.2.1.0.3.6	ILL_GaugeCheckDocRef - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_PO di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_3_6_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_3_6_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.4.1	ITP_NomGauge
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_PO	PO_TRACK_1_2_1_0_4_1 - sempre applicabile  per RFI = [1435]

 Procedure PAR_1_2_1_0_4_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_PO new 
  Set new.PO_TRACK_1_2_1_0_4_1_AP = Nvl((Select old.PO_TRACK_1_2_1_0_4_1_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_PO old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2) , 'NYA'),
      new.PO_TRACK_1_2_1_0_4_1 = (Select old.PO_TRACK_1_2_1_0_4_1
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_PO old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.PO_TRACK_1_2_1_0_0_2 in (Select b.PO_TRACK_1_2_1_0_0_2
	                                   From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
							                Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA b
							          Where po.CODICE_VERSIONE = v_Codice_Versione
							            And po.CODICE_VERSIONE = b.CODICE_VERSIONE
							        	And po.SEDE_TECNICA = b.SEDE_TECNICA
							            And po.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.2.1.0.4.1	ITP_NomGauge - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_PO di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_4_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_4_1_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.3.1.2	ILL_GaugeCheckLoc
-- -------------------------------------------------------------------------------------------
--BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_3_1_2 - Sempre Non Applicabile =[] 

 Procedure PAR_1_1_1_1_3_1_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_1_3_1_2_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_3_1_2_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA'),

      new.SOL_TRACK_1_1_1_1_3_1_2 = (Select old.SOL_TRACK_1_1_1_1_3_1_2
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.3.1.2 - ILL_GaugeCheckLoc - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--

  Exception
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_3_1_2_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_3_1_2_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.3.1.3	ILL_GaugeCheckDocRef
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_3_1_3 - Sempre Non Applicabile =[] 

 Procedure PAR_1_1_1_1_3_1_3_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_1_3_1_3_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_3_1_3_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_1_3_1_3 = (Select old.SOL_TRACK_1_1_1_1_3_1_3
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.3.1.3 - ILL_GaugeCheckDocRef - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_3_1_3_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_3_1_3_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.4.1	ITP_NomGauge
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_4_1    se Regular AP=[S] =[1435], se Link AP=[N] =[]
 Procedure PAR_1_1_1_1_4_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_1_4_1_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_4_1_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_1_4_1 = (Select old.SOL_TRACK_1_1_1_1_4_1
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.4.1	ITP_NomGauge - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  Exception
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_4_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_4_1_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.4.2	ITP_CantDeficiency
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_4_2
 Procedure PAR_1_1_1_1_4_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_1_4_2_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_4_2_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_1_4_2 = (Select old.SOL_TRACK_1_1_1_1_4_2
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.4.2	ITP_CantDeficiency - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  Exception
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_4_2_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_4_2_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.4.3	ITP_RailInclination
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_4_3
 Procedure PAR_1_1_1_1_4_3_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_1_4_3_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_4_3_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
      new.SOL_TRACK_1_1_1_1_4_3 = (Select old.SOL_TRACK_1_1_1_1_4_3
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.4.3	ITP_RailInclination - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  Exception
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_4_3_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_4_3_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.4.4	ITP_Ballast
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_4_4  (Applicabile quando v>250km/h)
 Procedure PAR_1_1_1_1_4_4_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;


  /**

  In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di DTEC_2:
-	1.1.1.1.4.4 ITP_Ballast (rif. 1.1.1.1.2.5 IPP_MaxSpeed)
-	1.2.1.0.5.9 ITU_DieselThermAllowed (rif. 1.2.1.0.5.7 ITU_FireCatReq)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_2.
Quindi, se il Terrotirio autorizza, non va fatto il ROLLBACK. Solo per le ST di nuova istituzione di tipo Regular
va impostata l'applicabilit  1_2_1_0_5_9_AP = [NYA] 

--  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Update BINARI_CORSA_SOL new 
  Set new.SOL_TRACK_1_1_1_1_4_4_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_4_4_AP
                                       From BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
      new.SOL_TRACK_1_1_1_1_4_4 = (Select old.SOL_TRACK_1_1_1_1_4_4
                                       From BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
--	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	                           From SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And CODICE_DTP = v_DTP);
***/
--
 Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new 
  Set new.SOL_TRACK_1_1_1_1_4_4_AP =  'NYA' ,
      new.SOL_TRACK_1_1_1_1_4_4 = Null
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP)
    And new.SEDE_TECNICA not in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione -1
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);

  DBMS_OUTPUT.PUT_LINE('1.1.1.1.4.4	ITP_Ballast - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_4_4_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_4_4_ROLLBACK;



-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.5.1	ISC_TSISwitchCrossing
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_5_1 -- per Regular =[Y] se Link= []

 Procedure PAR_1_1_1_1_5_1_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_1_5_1_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_5_1_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_1_5_1 = (Select old.SOL_TRACK_1_1_1_1_5_1
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.5.1	ISC_TSISwitchCrossing - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_5_1_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_5_1_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.5.2	ISC_MinWheelDiaFixObtuseCrossings
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_5_2 - se Regular AP=[S] =[330] (non sempre), se Link AP=[N] =[] 
 Procedure PAR_1_1_1_1_5_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_1_5_2_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_5_2_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_1_5_2 = (Select old.SOL_TRACK_1_1_1_1_5_2
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.5.2	ISC_MinWheelDiaFixObtuseCrossings - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_5_2_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_5_2_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.6.4	ILR_ECBDocRef
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_6_4 - Sempre Non Applicabile =[]

 Procedure PAR_1_1_1_1_6_4_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_1_6_4_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_6_4_AP
                                        From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
								 	   Where old.CODICE_VERSIONE = v_Codice_Versione -1
									     And old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_1_6_4 = (Select old.SOL_TRACK_1_1_1_1_6_4
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.6.4	ILR_ECBDocRef - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_6_4_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_6_4_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.6.5	ILR_MBDocRef
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_6_5 - Sempre Non Applicabile =[]

 Procedure PAR_1_1_1_1_6_5_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_1_6_5_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_6_5_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_1_6_5 = (Select old.SOL_TRACK_1_1_1_1_6_5 
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.6.5	ILR_MBDocRef - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_6_5_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_6_5_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.7.11	IHS_QuietRoute
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_7_11

 Procedure PAR_1_1_1_1_7_11_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_1_7_11_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_7_11_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_1_7_11 = (Select old.SOL_TRACK_1_1_1_1_7_11
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.7.11 - IHS_QuietRoute - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_7_11_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_7_11_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.5.9	ITU_DieselThermAllowed
-- -------------------------------------------------------------------------------------------
-- GALLERIE_BINARI_PO	PO_TR_TUNNEL_1_2_1_0_5_9 - Sempre Non Applicabile =[] 

 Procedure PAR_1_2_1_0_5_9_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
/***
In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di DTEC_2:
-	1.1.1.1.4.4 ITP_Ballast (rif. 1.1.1.1.2.5 IPP_MaxSpeed)
-	1.2.1.0.5.9 ITU_DieselThermAllowed (rif. 1.2.1.0.5.7 ITU_FireCatReq)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_2.
Quindi, se il Terrotirio autorizza, non va fatto il ROLLBACK. Solo per le ST di nuova istituzione va impostata
l'applicabilit  1_2_1_0_5_9_AP = [NYA] 
***/

  Update Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO new 
--  Update GALLERIE_BINARI_PO new 
     Set new.PO_TR_TUNNEL_1_2_1_0_5_9_AP =  'NYA' ,
        new.PO_TR_TUNNEL_1_2_1_0_5_9 = Null
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.PO_TR_TUNNEL_1_2_1_0_5_2 in (Select rel_gal_po.PO_TR_TUNNEL_1_2_1_0_5_2
	                                       From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
									            Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO rel_gal_po,
									    		Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_bin_po
							              Where po.CODICE_VERSIONE = v_Codice_Versione
									        And po.CODICE_VERSIONE = rel_bin_po.CODICE_VERSIONE 
									    	And rel_gal_po.PO_TRACK_1_2_1_0_0_2 = rel_bin_po.PO_TRACK_1_2_1_0_0_2
									    	And rel_gal_po.CODICE_VERSIONE = rel_bin_po.CODICE_VERSIONE
							               	And po.SEDE_TECNICA = rel_bin_po.SEDE_TECNICA
							                And po.CODICE_DTP = v_DTP)
    And new.PO_TR_TUNNEL_1_2_1_0_5_2 not in (Select rel_gal_po.PO_TR_TUNNEL_1_2_1_0_5_2
	                                       From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
									            Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO rel_gal_po,
									    		Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_bin_po
							              Where po.CODICE_VERSIONE = v_Codice_Versione -1
									        And po.CODICE_VERSIONE = rel_bin_po.CODICE_VERSIONE 
									    	And rel_gal_po.PO_TRACK_1_2_1_0_0_2 = rel_bin_po.PO_TRACK_1_2_1_0_0_2
									    	And rel_gal_po.CODICE_VERSIONE = rel_bin_po.CODICE_VERSIONE
							               	And po.SEDE_TECNICA = rel_bin_po.SEDE_TECNICA
							                And po.CODICE_DTP = v_DTP);

--
  DBMS_OUTPUT.PUT_LINE('1.2.1.0.5.9	ITU_DieselThermAllowed - record aggiornati ' || SQL%ROWCOUNT || ' GALLERIE_BINARI_PO di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_5_9_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_5_9_ROLLBACK;
--
-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.8.8.2	ITU_TunnelDocRef
-- -------------------------------------------------------------------------------------------
-- GALLERIE_BINARI_SOL	SOL_TUNNEL_1_1_1_1_8_8_2 - sempre Non Applicabile

 Procedure PAR_1_1_1_1_8_8_2_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 Begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL new 
  Set new.SOL_TUNNEL_1_1_1_1_8_8_2_AP = Nvl((Select old.SOL_TUNNEL_1_1_1_1_8_8_2_AP
                                       From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TUNNEL_1_1_1_1_8_2 = new.SOL_TUNNEL_1_1_1_1_8_2), 'NYA') ,
      new.SOL_TUNNEL_1_1_1_1_8_8_2 = (Select old.SOL_TUNNEL_1_1_1_1_8_8_2
                                       From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TUNNEL_1_1_1_1_8_2 = new.SOL_TUNNEL_1_1_1_1_8_2) 

  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SOL_TUNNEL_1_1_1_1_8_2 in (Select rel_gal_sol.SOL_TUNNEL_1_1_1_1_8_2
	                                       From Rinf_Pubblicati_Evo.SEZIONI_LINEA sol,
	                                            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL bin_sol,
									            Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL rel_gal_sol
							              Where sol.CODICE_VERSIONE = v_Codice_Versione
                                            And bin_sol.SEDE_TECNICA = sol.SEDE_TECNICA 
									        And bin_sol.CODICE_VERSIONE = sol.CODICE_VERSIONE 
									    	And rel_gal_sol.SOL_TRACK_1_1_1_0_0_1 = bin_sol.SOL_TRACK_1_1_1_0_0_1
									        And rel_gal_sol.CODICE_VERSIONE  = bin_sol.CODICE_VERSIONE		
							                And sol.SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
											And sol.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.8.8.2 - TU_TunnelDocRef - record aggiornati ' || SQL%ROWCOUNT || ' GALLERIE_BINARI_SOL di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_8_8_2_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_8_8_2_ROLLBACK;
-- -------------------------------------------------------------------------------------------




-- RC_RINF_DTEC_3 (Specialista DTEC 3)

-- -------------------------------------------------------------------------------------------
-- 1.1.1.2.2.1.3	ECS_Umax2
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_2_2_1_3  Sempre Non Applicabile =[]
 Procedure PAR_1_1_1_2_2_1_3_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_2_2_1_3_AP = Nvl((Select old.SOL_TRACK_1_1_1_2_2_1_3_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_2_2_1_3 = (Select old.SOL_TRACK_1_1_1_2_2_1_3
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.2.2.1.3 - ECS_Umax2 - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_2_2_1_3_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_2_2_1_3_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.2.4.3		EOS_DistSignToPhaseEnd
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_2_4_3 - Sempre Non Applicabile =[]

 Procedure PAR_1_1_1_2_4_3_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_2_4_3_AP = Nvl((Select old.SOL_TRACK_1_1_1_2_4_3_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_2_4_3 = (Select old.SOL_TRACK_1_1_1_2_4_3
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.2.4.3	- EOS_DistSignToPhaseEnd - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_2_4_3_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_2_4_3_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.3.7.1.4	CTD_TCLimitation
-- -------------------------------------------------------------------------------------------
--BINARI_CORSA_SOL	SOL_TRACK_1_1_1_3_7_1_4 - Sempre Non Applicabile =[]

 Procedure PAR_1_1_1_3_7_1_4_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_3_7_1_4_AP = Nvl((Select old.SOL_TRACK_1_1_1_3_7_1_4_AP
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

      new.SOL_TRACK_1_1_1_3_7_1_4 = (Select old.SOL_TRACK_1_1_1_3_7_1_4
                                       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL old 
									  Where old.CODICE_VERSIONE = v_Codice_Versione -1
									    And old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.3.7.1.4 - CTD_TCLimitation - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_3_7_1_4_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_3_7_1_4_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.3.7.19		CTD_TSISandCharacteristics
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_3_7_19 - dipende dal valore di 1.1.1.3.7.1.1: se applicabile =[TSI compliant] altrimenti =[]

 Procedure PAR_1_1_1_3_7_19_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;

 /***
In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di  DTEC_3 :
-	1.1.1.3.7.19 CTD_TSISandCharacteristics (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.20 CTD_FlangeLubeRules (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.21 CTD_TSICompositeBrakeBlocks (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.22 CTD_TSIShuntDevices (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.23 CTD_TSIRSTShuntImpedance (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_3.

In tutte le SdL ed i PO di  DOIT n  NON PRESENTI in  DOIT n-1  i parametri di  DTEC_3 :
sono IMPOSTATI a  NYA  (inclusi gli eventuali parametri attualmente impostati a  NA  sull intera infrastruttura di RFI durante la fase di acquisizione e controllo dei dati forniti dai sistemi  owner ).
***/

    Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
   Set new.SOL_TRACK_1_1_1_3_7_19_AP =  'NYA' ,
       new.SOL_TRACK_1_1_1_3_7_19 = Null
 Where new.CODICE_VERSIONE = v_Codice_Versione
   And new.SEDE_TECNICA not in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione -1
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP)
--
   And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA
							    Where CODICE_DTP = v_DTP
                                  And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
                            );
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.3.7.19 - CTD_TSISandCharacteristics - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);

--
  Exception
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_3_7_19_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_3_7_19_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.3.7.20		CTD_FlangeLubeRules
-- -------------------------------------------------------------------------------------------
--BINARI_CORSA_SOL	SOL_TRACK_1_1_1_3_7_20 - dipende dal valore di 1.1.1.3.7.1.1: se applicabile =[Y] altrimenti =[]

 Procedure PAR_1_1_1_3_7_20_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;

/***
In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di  DTEC_3 :
-	1.1.1.3.7.19 CTD_TSISandCharacteristics (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.20 CTD_FlangeLubeRules (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.21 CTD_TSICompositeBrakeBlocks (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.22 CTD_TSIShuntDevices (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.23 CTD_TSIRSTShuntImpedance (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_3.


In tutte le SdL ed i PO di  DOIT n  NON PRESENTI in  DOIT n-1  i parametri di  DTEC_3 :
sono IMPOSTATI a  NYA  (inclusi gli eventuali parametri attualmente impostati a  NA  sull intera infrastruttura di RFI durante la fase di acquisizione e controllo dei dati forniti dai sistemi  owner ).
***/
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new

   Set new.SOL_TRACK_1_1_1_3_7_20_AP =  'NYA' ,
       new.SOL_TRACK_1_1_1_3_7_20 = Null  
 Where new.CODICE_VERSIONE = v_Codice_Versione
   And new.SEDE_TECNICA not in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione -1
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP)
--
   And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA
							    Where CODICE_DTP = v_DTP
                                  And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
                            );
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.3.7.20 - CTD_FlangeLubeRules - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_3_7_20_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_3_7_20_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.3.7.21		CTD_TSICompositeBrakeBlocks
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_3_7_21 - dipende dal valore di 1.1.1.3.7.1.1: se applicabile =[TSI compliant] altrimenti =[]
 Procedure PAR_1_1_1_3_7_21_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;

/***
In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di  DTEC_3 :
-	1.1.1.3.7.19 CTD_TSISandCharacteristics (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.20 CTD_FlangeLubeRules (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.21 CTD_TSICompositeBrakeBlocks (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.22 CTD_TSIShuntDevices (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.23 CTD_TSIRSTShuntImpedance (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_3.

In tutte le SdL ed i PO di  DOIT n  NON PRESENTI in  DOIT n-1  i parametri di  DTEC_3 :
sono IMPOSTATI a  NYA  (inclusi gli eventuali parametri attualmente impostati a  NA  sull intera infrastruttura di RFI durante la fase di acquisizione e controllo dei dati forniti dai sistemi  owner ).
***/


     Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
    Set new.SOL_TRACK_1_1_1_3_7_21_AP =  'NYA' ,
        new.SOL_TRACK_1_1_1_3_7_21 = Null
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA not in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione -1
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP)
--
   And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA
							    Where CODICE_DTP = v_DTP
                                  And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
                            );
  DBMS_OUTPUT.PUT_LINE('1.1.1.3.7.21 - CTD_TSICompositeBrakeBlocks - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_3_7_21_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_3_7_21_ROLLBACK;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.3.7.22		CTD_TSIShuntDevices
-- -------------------------------------------------------------------------------------------
--BINARI_CORSA_SOL	SOL_TRACK_1_1_1_3_7_22 - dipende dal valore di 1.1.1.3.7.1.1: se applicabile =[TSI compliant] altrimenti =[]

 Procedure PAR_1_1_1_3_7_22_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
/***
In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di  DTEC_3 :
-	1.1.1.3.7.19 CTD_TSISandCharacteristics (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.20 CTD_FlangeLubeRules (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.21 CTD_TSICompositeBrakeBlocks (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.22 CTD_TSIShuntDevices (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.23 CTD_TSIRSTShuntImpedance (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_3.

In tutte le SdL ed i PO di  DOIT n  NON PRESENTI in  DOIT n-1  i parametri di  DTEC_3 :
sono IMPOSTATI a  NYA  (inclusi gli eventuali parametri attualmente impostati a  NA  sull intera infrastruttura di RFI durante la fase di acquisizione e controllo dei dati forniti dai sistemi  owner ).
***/

   Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_3_7_22_AP = 'NYA' ,
      new.SOL_TRACK_1_1_1_3_7_22 = Null
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA not in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione -1
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP)
--
   And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA
							    Where CODICE_DTP = v_DTP
                                  And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
                            );
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.3.7.22 - CTD_TSIShuntDevices - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_3_7_22_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_3_7_22_ROLLBACK;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.3.7.23		CTD_TSIRSTShuntImpedance
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_3_7_23 - dipende dal valore di 1.1.1.3.7.1.1: se applicabile =[TSI compliant] altrimenti =[]

 Procedure PAR_1_1_1_3_7_23_ROLLBACK (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;

/***
In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di  DTEC_3 :
-	1.1.1.3.7.19 CTD_TSISandCharacteristics (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.20 CTD_FlangeLubeRules (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.21 CTD_TSICompositeBrakeBlocks (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.22 CTD_TSIShuntDevices (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.23 CTD_TSIRSTShuntImpedance (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_3.

In tutte le SdL ed i PO di  DOIT n  NON PRESENTI in  DOIT n-1  i parametri di  DTEC_3 :
sono IMPOSTATI a  NYA  (inclusi gli eventuali parametri attualmente impostati a  NA  sull intera infrastruttura di RFI durante la fase di acquisizione e controllo dei dati forniti dai sistemi  owner ).
***/

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
   Set new.SOL_TRACK_1_1_1_3_7_23_AP =  'NYA' ,
       new.SOL_TRACK_1_1_1_3_7_23 = Null
 Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA not in (Select SEDE_TECNICA 
	                           From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
							  Where CODICE_VERSIONE = v_Codice_Versione -1
							    And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
							    And CODICE_DTP = v_DTP)
--
   And new.SEDE_TECNICA in (Select SEDE_TECNICA 
	                           From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA
							    Where CODICE_DTP = v_DTP
                                  And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
                            );
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.3.7.23 - CTD_TSIRSTShuntImpedance - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_3_7_23_ROLLBACK - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_3_7_23_ROLLBACK;




--
-- -------------------------------------------------------------------------------------------
--  DTEC_2_UPD
-- -------------------------------------------------------------------------------------------
--

-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.3.5.A	ILL_GaugeCheckLoc
-- 1.2.1.0.3.5.B	ILL_GaugeCheckLoc
-- -------------------------------------------------------------------------------------------

 Procedure PAR_1_2_1_0_3_5_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_PO new 
	Set new.PO_TRACK_1_2_1_0_3_5_AP = Nvl((Select old.PO_TRACK_1_2_1_0_3_5_AP
                                             From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO old 
				                            Where old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2) , 'NYA'),
        new.PO_TRACK_1_2_1_0_3_5_A =      (Select old.PO_TRACK_1_2_1_0_3_5_A
                                             From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO old 
				                            Where old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2),
	    new.PO_TRACK_1_2_1_0_3_5_B =      (Select old.PO_TRACK_1_2_1_0_3_5_B
                                             From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO old 
				                            Where old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.PO_TRACK_1_2_1_0_0_2 in 
	(Select b.PO_TRACK_1_2_1_0_0_2
       From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
            Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA b
      Where po.SEDE_TECNICA = b.SEDE_TECNICA
        And po.CODICE_VERSIONE = b.CODICE_VERSIONE 
        And po.CODICE_VERSIONE = v_Codice_Versione
/**	
                                    (Select b.PO_TRACK_1_2_1_0_0_2
	                                   From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI po,
	                                        Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA b
			                          Where po.SEDE_TECNICA = b.SEDE_TECNICA
**/
	    And po.CODICE_DTP = v_DTP);

--
  DBMS_OUTPUT.PUT_LINE('1.2.1.0.3.5 - ILL_GaugeCheckLoc - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_PO di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_3_5_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_3_5_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.3.6	ILL_GaugeCheckDocRef
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_PO	PO_TRACK_1_2_1_0_3_6 - Sempre Non Applicabile =[]

Procedure PAR_1_2_1_0_3_6_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

 Update Rinf_Pubblicati_Evo.BINARI_CORSA_PO new 
	Set new.PO_TRACK_1_2_1_0_3_6_AP = Nvl((Select old.PO_TRACK_1_2_1_0_3_6_AP
                                                 From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO old 
				                Where old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2) , 'NYA'),
            new.PO_TRACK_1_2_1_0_3_6 = (Select old.PO_TRACK_1_2_1_0_3_6
                                          From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO old 
				         Where old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2)
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.PO_TRACK_1_2_1_0_0_2 in 
/**
	                            (Select b.PO_TRACK_1_2_1_0_0_2
	                               From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI po,
	                                    Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA b
			              Where po.SEDE_TECNICA = b.SEDE_TECNICA
**/
	(Select b.PO_TRACK_1_2_1_0_0_2
       From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
            Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA b
      Where po.SEDE_TECNICA = b.SEDE_TECNICA
        And po.CODICE_VERSIONE = b.CODICE_VERSIONE 
        And po.CODICE_VERSIONE = v_Codice_Versione
		And po.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.2.1.0.3.6	ILL_GaugeCheckDocRef - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_PO di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_3_6_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_3_6_UPD;


-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.4.1	ITP_NomGauge
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_PO	PO_TRACK_1_2_1_0_4_1 - sempre applicabile  per RFI = [1435]

 Procedure PAR_1_2_1_0_4_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_PO new 
  Set new.PO_TRACK_1_2_1_0_4_1_AP = Nvl((Select old.PO_TRACK_1_2_1_0_4_1_AP
                                           From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO old 
				                          Where old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2) , 'NYA'),
      new.PO_TRACK_1_2_1_0_4_1 =        (Select old.PO_TRACK_1_2_1_0_4_1
                                           From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO old 
				                         Where old.PO_TRACK_1_2_1_0_0_2 = new.PO_TRACK_1_2_1_0_0_2) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.PO_TRACK_1_2_1_0_0_2 in 
/**
	(Select b.PO_TRACK_1_2_1_0_0_2
	                               From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI po,
	                                    Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA b
			              Where po.SEDE_TECNICA = b.SEDE_TECNICA
				        And po.CODICE_DTP = v_DTP);
**/
	(Select b.PO_TRACK_1_2_1_0_0_2
       From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
            Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA b
      Where po.SEDE_TECNICA = b.SEDE_TECNICA
        And po.CODICE_VERSIONE = b.CODICE_VERSIONE 
        And po.CODICE_VERSIONE = v_Codice_Versione
		And po.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.2.1.0.4.1	ITP_NomGauge - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_PO di '||v_DTP);
--

  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_4_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_4_1_UPD;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.3.1.2	ILL_GaugeCheckLoc
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_3_1_2 - Sempre Non Applicabile =[] 

 Procedure PAR_1_1_1_1_3_1_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;
  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_1_3_1_2_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_3_1_2_AP
                                                 From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                                Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
         new.SOL_TRACK_1_1_1_1_3_1_2 =        (Select old.SOL_TRACK_1_1_1_1_3_1_2
                                                 From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                                Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*	 
	 (Select SEDE_TECNICA 
	    From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	   Where CODICE_DTP = v_DTP);
	*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
         And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.3.1.2 - ILL_GaugeCheckLoc - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_3_1_2_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_3_1_2_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.3.1.3	ILL_GaugeCheckDocRef
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_3_1_3 - Sempre Non Applicabile =[] 

 Procedure PAR_1_1_1_1_3_1_3_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
  Set new.SOL_TRACK_1_1_1_1_3_1_3_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_3_1_3_AP
                                              From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                             Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
      new.SOL_TRACK_1_1_1_1_3_1_3 =        (Select old.SOL_TRACK_1_1_1_1_3_1_3
                                              From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                             Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1) 
   Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in 
/*	
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
		 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.3.1.3 - ILL_GaugeCheckDocRef - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_3_1_3_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_3_1_3_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.4.1	ITP_NomGauge
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_4_1    se Regular AP=[S] =[1435], se Link AP=[N] =[]

 Procedure PAR_1_1_1_1_4_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_1_4_1_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_4_1_AP
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

         new.SOL_TRACK_1_1_1_1_4_1 =        (Select old.SOL_TRACK_1_1_1_1_4_1
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	 (Select SEDE_TECNICA 
	                       From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
			      Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
		 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.4.1	ITP_NomGauge - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_4_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_4_1_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.4.2	ITP_CantDeficiency
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_4_2
--
 Procedure PAR_1_1_1_1_4_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_1_4_2_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_4_2_AP
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                          Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
         new.SOL_TRACK_1_1_1_1_4_2 =        (Select old.SOL_TRACK_1_1_1_1_4_2
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                             Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
		 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.4.2	ITP_CantDeficiency - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_4_2_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_4_2_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.4.3	ITP_RailInclination
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_4_3
--
 Procedure PAR_1_1_1_1_4_3_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_1_4_3_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_4_3_AP
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
         new.SOL_TRACK_1_1_1_1_4_3 =        (Select old.SOL_TRACK_1_1_1_1_4_3
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
		 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.4.3	ITP_RailInclination - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_4_3_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_4_3_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.4.4	ITP_Ballast
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_4_4  (Applicabile quando v>250km/h)
--
/**
  In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri (di DTEC_2:)
-	1.1.1.1.4.4 ITP_Ballast (rif. 1.1.1.1.2.5 IPP_MaxSpeed)
-	1.2.1.0.5.9 ITU_DieselThermAllowed (rif. 1.2.1.0.5.7 ITU_FireCatReq)
     sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_2.
**/
 Procedure PAR_1_1_1_1_4_4_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_1_4_4_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_4_4_AP
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
         new.SOL_TRACK_1_1_1_1_4_4 =        (Select old.SOL_TRACK_1_1_1_1_4_4
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.4.4	ITP_Ballast - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_4_4_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_4_4_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.5.1	ISC_TSISwitchCrossing
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_5_1 -- per Regular =[Y] se Link= []

 Procedure PAR_1_1_1_1_5_1_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_1_5_1_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_5_1_AP
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
--
         new.SOL_TRACK_1_1_1_1_5_1 =        (Select old.SOL_TRACK_1_1_1_1_5_1
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.5.1	ISC_TSISwitchCrossing - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_5_1_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_5_1_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.5.2	ISC_MinWheelDiaFixObtuseCrossings
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_5_2 - se Regular AP=[S] =[330] (non sempre), se Link AP=[N] =[] 
--
 Procedure PAR_1_1_1_1_5_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_1_5_2_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_5_2_AP
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
--
         new.SOL_TRACK_1_1_1_1_5_2 =        (Select old.SOL_TRACK_1_1_1_1_5_2
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.5.2	ISC_MinWheelDiaFixObtuseCrossings - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_5_2_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_5_2_UPD;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.6.4	ILR_ECBDocRef
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_6_4 - Sempre Non Applicabile =[]

 Procedure PAR_1_1_1_1_6_4_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_1_6_4_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_6_4_AP
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
--
         new.SOL_TRACK_1_1_1_1_6_4 =        (Select old.SOL_TRACK_1_1_1_1_6_4
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.6.4	ILR_ECBDocRef - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  Exception
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_6_4_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_6_4_UPD;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.6.5	ILR_MBDocRef
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_6_5 - Sempre Non Applicabile =[]

 Procedure PAR_1_1_1_1_6_5_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_1_6_5_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_6_5_AP
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
--
         new.SOL_TRACK_1_1_1_1_6_5 =        (Select old.SOL_TRACK_1_1_1_1_6_5 
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.6.5	ILR_MBDocRef - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_6_5_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_6_5_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.7.11	IHS_QuietRoute
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_1_7_11

 Procedure PAR_1_1_1_1_7_11_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_1_7_11_AP = Nvl((Select old.SOL_TRACK_1_1_1_1_7_11_AP
                                                From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                               Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
--
         new.SOL_TRACK_1_1_1_1_7_11 =        (Select old.SOL_TRACK_1_1_1_1_7_11
                                                From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                               Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	  And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.7.11 - IHS_QuietRoute - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_7_11_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_7_11_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.2.1.0.5.9	ITU_DieselThermAllowed
-- -------------------------------------------------------------------------------------------
-- GALLERIE_BINARI_PO	PO_TR_TUNNEL_1_2_1_0_5_9 - Sempre Non Applicabile =[] 

/***
In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di DTEC_2:
-	1.1.1.1.4.4 ITP_Ballast (rif. 1.1.1.1.2.5 IPP_MaxSpeed)
-	1.2.1.0.5.9 ITU_DieselThermAllowed (rif. 1.2.1.0.5.7 ITU_FireCatReq)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_2.
***/
 Procedure PAR_1_2_1_0_5_9_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO new 
     Set new.PO_TR_TUNNEL_1_2_1_0_5_9_AP = Nvl((Select old.PO_TR_TUNNEL_1_2_1_0_5_9_AP
                                                  From Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_PO old 
					                             Where old.PO_TR_TUNNEL_1_2_1_0_5_2 = new.PO_TR_TUNNEL_1_2_1_0_5_2), 'NYA') ,
--
         new.PO_TR_TUNNEL_1_2_1_0_5_9 =        (Select old.PO_TR_TUNNEL_1_2_1_0_5_9
                                                  From Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_PO old 
					                             Where old.PO_TR_TUNNEL_1_2_1_0_5_2 = new.PO_TR_TUNNEL_1_2_1_0_5_2) 
  Where new.CODICE_VERSIONE = v_Codice_Versione
    And new.PO_TR_TUNNEL_1_2_1_0_5_2 in 
	(Select rel_gal_po.PO_TR_TUNNEL_1_2_1_0_5_2
	   From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI po,
            Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO rel_gal_po,
		    Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA rel_bin_po
      Where po.CODICE_VERSIONE = v_Codice_Versione
        And po.CODICE_VERSIONE = rel_bin_po.CODICE_VERSIONE 
	    And rel_gal_po.PO_TRACK_1_2_1_0_0_2 = rel_bin_po.PO_TRACK_1_2_1_0_0_2
	    And rel_gal_po.CODICE_VERSIONE = rel_bin_po.CODICE_VERSIONE
        And po.SEDE_TECNICA = rel_bin_po.SEDE_TECNICA
        And po.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.2.1.0.5.9	ITU_DieselThermAllowed - record aggiornati ' || SQL%ROWCOUNT || ' GALLERIE_BINARI_PO di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_2_1_0_5_9_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_2_1_0_5_9_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.1.8.8.2	ITU_TunnelDocRef
-- -------------------------------------------------------------------------------------------
-- GALLERIE_BINARI_SOL	SOL_TUNNEL_1_1_1_1_8_8_2 - sempre Non Applicabile

 Procedure PAR_1_1_1_1_8_8_2_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL new 
     Set new.SOL_TUNNEL_1_1_1_1_8_8_2_AP = Nvl((Select old.SOL_TUNNEL_1_1_1_1_8_8_2_AP
                                                  From Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_SOL old 
					                             Where old.SOL_TUNNEL_1_1_1_1_8_2 = new.SOL_TUNNEL_1_1_1_1_8_2), 'NYA') ,
--
         new.SOL_TUNNEL_1_1_1_1_8_8_2 =        (Select old.SOL_TUNNEL_1_1_1_1_8_8_2
                                                  From Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_SOL old 
				                                 Where old.SOL_TUNNEL_1_1_1_1_8_2 = new.SOL_TUNNEL_1_1_1_1_8_2) 
    Where new.CODICE_VERSIONE = v_Codice_Versione
      And new.SOL_TUNNEL_1_1_1_1_8_2 in (Select rel_gal_sol.SOL_TUNNEL_1_1_1_1_8_2
	                                       From Rinf_Pubblicati_Evo.SEZIONI_LINEA sol,
	                                            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL bin_sol,
					                            Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL rel_gal_sol
				                          Where bin_sol.SEDE_TECNICA = sol.SEDE_TECNICA 
										  	And bin_sol.CODICE_VERSIONE = sol.CODICE_VERSIONE
					    	                And rel_gal_sol.SOL_TRACK_1_1_1_0_0_1 = bin_sol.SOL_TRACK_1_1_1_0_0_1
										    And rel_gal_sol.CODICE_VERSIONE = bin_sol.CODICE_VERSIONE
											And sol.CODICE_VERSIONE = v_Codice_Versione
	   	                                    And sol.SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
						                    And sol.CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.1.8.8.2 - TU_TunnelDocRef - record aggiornati ' || SQL%ROWCOUNT || ' GALLERIE_BINARI_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_1_8_8_2_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_1_8_8_2_UPD;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.2.2.1.3	ECS_Umax2
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_2_2_1_3  Sempre Non Applicabile =[]

 Procedure PAR_1_1_1_2_2_1_3_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_2_2_1_3_AP = Nvl((Select old.SOL_TRACK_1_1_1_2_2_1_3_AP
                                                 From rinf_autorizzazioni_evo.BINARI_CORSA_SOL old 
					                            Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
--
         new.SOL_TRACK_1_1_1_2_2_1_3 =        (Select old.SOL_TRACK_1_1_1_2_2_1_3
                                                 From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                                Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.2.2.1.3 - ECS_Umax2 - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_2_2_1_3_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_2_2_1_3_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.2.4.3		EOS_DistSignToPhaseEnd
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_2_4_3 - Sempre Non Applicabile =[]

 Procedure PAR_1_1_1_2_4_3_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_2_4_3_AP = Nvl((Select old.SOL_TRACK_1_1_1_2_4_3_AP
                                               From rinf_autorizzazioni_evo.BINARI_CORSA_SOL old 
					                          Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
--
         new.SOL_TRACK_1_1_1_2_4_3 =        (Select old.SOL_TRACK_1_1_1_2_4_3
                                               From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                              Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.2.4.3	- EOS_DistSignToPhaseEnd - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_2_4_3_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_2_4_3_UPD;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.3.7.1.4	CTD_TCLimitation
-- -------------------------------------------------------------------------------------------
--BINARI_CORSA_SOL	SOL_TRACK_1_1_1_3_7_1_4 - Sempre Non Applicabile =[]

 Procedure PAR_1_1_1_3_7_1_4_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_3_7_1_4_AP = Nvl((Select old.SOL_TRACK_1_1_1_3_7_1_4_AP
                                                 From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
					                            Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
--
         new.SOL_TRACK_1_1_1_3_7_1_4 =        (Select old.SOL_TRACK_1_1_1_3_7_1_4
                                                 From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                                Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.3.7.1.4 - CTD_TCLimitation - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_3_7_1_4_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_3_7_1_4_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.3.7.19		CTD_TSISandCharacteristics
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_3_7_19 - dipende dal valore di 1.1.1.3.7.1.1: se applicabile =[TSI compliant] altrimenti =[]

 Procedure PAR_1_1_1_3_7_19_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

 /***
In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di  DTEC_3 :
-	1.1.1.3.7.19 CTD_TSISandCharacteristics (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.20 CTD_FlangeLubeRules (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.21 CTD_TSICompositeBrakeBlocks (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.22 CTD_TSIShuntDevices (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.23 CTD_TSIRSTShuntImpedance (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_3.
***/

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_3_7_19_AP = Nvl((Select old.SOL_TRACK_1_1_1_3_7_19_AP
                                                From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
					                           Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

         new.SOL_TRACK_1_1_1_3_7_19 =        (Select old.SOL_TRACK_1_1_1_3_7_19
                                                From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                               Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.3.7.19 - CTD_TSISandCharacteristics - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_3_7_19_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_3_7_19_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.3.7.20		CTD_FlangeLubeRules
-- -------------------------------------------------------------------------------------------
--BINARI_CORSA_SOL	SOL_TRACK_1_1_1_3_7_20 - dipende dal valore di 1.1.1.3.7.1.1: se applicabile =[Y] altrimenti =[]

 Procedure PAR_1_1_1_3_7_20_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

/***
In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di  DTEC_3 :
-	1.1.1.3.7.19 CTD_TSISandCharacteristics (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.20 CTD_FlangeLubeRules (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.21 CTD_TSICompositeBrakeBlocks (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.22 CTD_TSIShuntDevices (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.23 CTD_TSIRSTShuntImpedance (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_3.
***/

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_3_7_20_AP = Nvl((Select old.SOL_TRACK_1_1_1_3_7_20_AP
                                                From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
					                           Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
--
         new.SOL_TRACK_1_1_1_3_7_20 =         (Select old.SOL_TRACK_1_1_1_3_7_20
                                                 From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                                Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.3.7.20 - CTD_FlangeLubeRules - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_3_7_20_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_3_7_20_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.3.7.21		CTD_TSICompositeBrakeBlocks
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_3_7_21 - dipende dal valore di 1.1.1.3.7.1.1: se applicabile =[TSI compliant] altrimenti =[]

 Procedure PAR_1_1_1_3_7_21_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

/***
In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di  DTEC_3 :
-	1.1.1.3.7.19 CTD_TSISandCharacteristics (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.20 CTD_FlangeLubeRules (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.21 CTD_TSICompositeBrakeBlocks (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.22 CTD_TSIShuntDevices (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.23 CTD_TSIRSTShuntImpedance (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_3.
***/

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_3_7_21_AP = Nvl((Select old.SOL_TRACK_1_1_1_3_7_21_AP
                                                From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
					                           Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

         new.SOL_TRACK_1_1_1_3_7_21 =        (Select old.SOL_TRACK_1_1_1_3_7_21
                                                From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                               Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.3.7.21 - CTD_TSICompositeBrakeBlocks - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_3_7_21_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_3_7_21_UPD;

-- -------------------------------------------------------------------------------------------
-- 1.1.1.3.7.22		CTD_TSIShuntDevices
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_3_7_22 - dipende dal valore di 1.1.1.3.7.1.1: se applicabile =[TSI compliant] altrimenti =[]

 Procedure PAR_1_1_1_3_7_22_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 
 begin 

  p_error_split := 0;
/***
In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di  DTEC_3 :
-	1.1.1.3.7.19 CTD_TSISandCharacteristics (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.20 CTD_FlangeLubeRules (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.21 CTD_TSICompositeBrakeBlocks (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.22 CTD_TSIShuntDevices (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.23 CTD_TSIRSTShuntImpedance (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_3.
***/

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_3_7_22_AP = Nvl((Select old.SOL_TRACK_1_1_1_3_7_22_AP
                                                From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
					                           Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,
--
         new.SOL_TRACK_1_1_1_3_7_22 =        (Select old.SOL_TRACK_1_1_1_3_7_22
                                                From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                               Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.3.7.22 - CTD_TSIShuntDevices - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_3_7_22_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_3_7_22_UPD;


-- -------------------------------------------------------------------------------------------
-- 1.1.1.3.7.23		CTD_TSIRSTShuntImpedance
-- -------------------------------------------------------------------------------------------
-- BINARI_CORSA_SOL	SOL_TRACK_1_1_1_3_7_23 - dipende dal valore di 1.1.1.3.7.1.1: se applicabile =[TSI compliant] altrimenti =[]

 Procedure PAR_1_1_1_3_7_23_UPD (v_CODICE_VERSIONE Number, v_DTP Varchar2, p_error_split Out Number) is 

 begin 

  p_error_split := 0;

/***
In tutte le SdL ed i PO di  DOIT n  PRESENTI in  DOIT n-1  i soli parametri di  DTEC_3 :
-	1.1.1.3.7.19 CTD_TSISandCharacteristics (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.20 CTD_FlangeLubeRules (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.21 CTD_TSICompositeBrakeBlocks (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.22 CTD_TSIShuntDevices (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
-	1.1.1.3.7.23 CTD_TSIRSTShuntImpedance (rif. 1.1.1.3.7.1.1 CTD_DetectionSystem di T)
sono IMPOSTATI come da Area Dati Controllati Corretti (n) anche se NON autorizzati da DTEC_3.
***/

  Update Rinf_Pubblicati_Evo.BINARI_CORSA_SOL new
     Set new.SOL_TRACK_1_1_1_3_7_23_AP = Nvl((Select old.SOL_TRACK_1_1_1_3_7_23_AP
                                                From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
					                           Where old.SOL_TRACK_1_1_1_0_0_1 = new.SOL_TRACK_1_1_1_0_0_1), 'NYA') ,

         new.SOL_TRACK_1_1_1_3_7_23 =        (Select old.SOL_TRACK_1_1_1_3_7_23
                                                From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL old 
				                               Where old.SOL_TRACK_1_1_1_0_0_1  = new.SOL_TRACK_1_1_1_0_0_1)
   Where new.CODICE_VERSIONE = v_Codice_Versione
     And new.SEDE_TECNICA in 
/*
	(Select SEDE_TECNICA 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	  Where CODICE_DTP = v_DTP);
*/
	 (Select SEDE_TECNICA 
	    From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	   Where CODICE_VERSIONE = v_Codice_Versione
	   	 And SOL_1_1_0_0_0_6 = 'R'                     -- solo per le tratte di tipo Regular
	     And CODICE_DTP = v_DTP);
--
  DBMS_OUTPUT.PUT_LINE('1.1.1.3.7.23 - CTD_TSIRSTShuntImpedance - record aggiornati ' || SQL%ROWCOUNT || ' BINARI_CORSA_SOL di '||v_DTP);
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('PAR_1_1_1_3_7_23_UPD - Errore: ' || Substr(Sqlerrm, 1, 250));
  End PAR_1_1_1_3_7_23_UPD;


--
-- -------------------------------------------------------------------------------------------
--
-- -------------------------------------------------------------------------------------------
--
 Procedure Ripristina_SEDE_TECNICA (V_Codice_Versione Number, v_DTP Varchar2, p_error_split Out Number) is 
--
  LOC_INIZIO      Rinf_Pubblicati_evo.SEZIONI_LINEA.LOCALITA_INIZIO%Type;
  LOC_FINE        Rinf_Pubblicati_evo.SEZIONI_LINEA.LOCALITA_FINE%Type;
  Punto_Operativo Rinf_Pubblicati_evo.PUNTI_OPERATIVI.SEDE_TECNICA%Type;
  Tratta          Rinf_Pubblicati_evo.SEZIONI_LINEA.SEDE_TECNICA%Type;
--  
 Cursor Cur_sol Is 
   Select SEDE_TECNICA, LOCALITA_INIZIO, LOCALITA_FINE From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
   where SEDE_TECNICA in (
   Select SEDE_TECNICA From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
    Where CODICE_VERSIONE = v_Codice_Versione -1
      And CODICE_DTP = v_DTP
    Minus
   Select SEDE_TECNICA From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
    Where CODICE_VERSIONE = v_Codice_Versione 
      And CODICE_DTP = v_DTP );
--
 Cursor Cur_po (inizio varchar2, fine varchar2) Is 
    Select SEDE_TECNICA From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
     Where CODICE_VERSIONE = v_Codice_Versione -1
	  And SEDE_TECNICA In (INIZIO, FINE)
	 Minus
    Select SEDE_TECNICA From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
     Where CODICE_VERSIONE = v_Codice_Versione
	   And SEDE_TECNICA In (INIZIO, FINE);
--	   
 Cursor Cur_po_DTP (p_DTP varchar2) Is 
    Select SEDE_TECNICA From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
     Where CODICE_VERSIONE = v_Codice_Versione -1
	  And CODICE_DTP = p_DTP
	 Minus
    Select SEDE_TECNICA From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
     Where CODICE_VERSIONE = v_Codice_Versione
	   And CODICE_DTP = p_DTP;
--	  
 Begin 
--
  p_error_split := 0;

    For Rec_sol In Cur_sol Loop 
--	
        Tratta     := Rec_sol.SEDE_TECNICA;
        LOC_INIZIO := Rec_sol.LOCALITA_INIZIO;
        LOC_FINE   := Rec_sol.LOCALITA_FINE;
--		
		Dbms_Output.Put_Line('Sol: '||Tratta||' - Inizio: '||LOC_INIZIO||' - Fine: '||LOC_FINE);
--
        For Rec_po In Cur_po (LOC_INIZIO, LOC_FINE) Loop 
--
             Punto_Operativo := Rec_po.SEDE_TECNICA;
-- Recupero dei punti Operativi appartenenti alla DOIT che non ha autorizzato, presenti nella CLASSE_ELIMINATI ed estremi della tratta 
--
             PKG_RINF_PAR_SC_AUTORIZZAZIONI.Rispristina_Pubblicati_PO  (Punto_Operativo, v_Codice_Versione, p_error_split) ;
   		     Dbms_Output.Put_Line('Ripristino Punto Operativo: '||Punto_Operativo);
-- 
        End Loop;
--
-- Recupero della Tratta appartenente alla DOIT che non ha autorizzato, presenti nella CLASSE_ELIMINATI 
        PKG_RINF_PAR_SC_AUTORIZZAZIONI.Rispristina_Pubblicati_SOL (Tratta, v_Codice_Versione, p_error_split ) ;
   		Dbms_Output.Put_Line('Ripristino Tratta: '||Tratta);
--
    End Loop;
--
    For Rec_po_DTP In Cur_po_DTP (v_DTP) Loop 
             Punto_Operativo := Rec_po_DTP.SEDE_TECNICA;
-- Recupero dei punti Operativi appartenenti alla DOIT che non ha autorizzato presenti nella CLASSE_ELIMINATI 	
--
             PKG_RINF_PAR_SC_AUTORIZZAZIONI.Rispristina_Pubblicati_PO  (Punto_Operativo, v_Codice_Versione, p_error_split) ;
   		     Dbms_Output.Put_Line('Ripristino Punto Operativo: '||Punto_Operativo|| ', della DOIT: '||v_DTP);
--
    End Loop;
--
--
  EXCEPTION
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('Ripristina_SEDE_TECNICA - Errore: ' || Substr(Sqlerrm, 1, 250));
  End Ripristina_SEDE_TECNICA;
--  
--

-- --------------------------------------------------------------------------------------
-- Gestione delle nuove sedi tecniche nel caso non siano autorizzate dal territorio (ma la DCO autorizza)
-- --------------------------------------------------------------------------------------

Procedure Set_Skeleton_Po (p_SEDE_TECNICA varchar2, p_versione Number, p_error out Number ) is

  BEGIN

--  ********************************  OP  **********************************************
-- --------------------------------------------------------------------------------------
--                    parametri dei  PUNTI_OPERATIVI
-- --------------------------------------------------------------------------------------
 p_error := 0;

 Begin
     Insert Into Rinf_Pubblicati_Evo.PUNTI_OPERATIVI (
 --    Insert Into Rinf_Controllati_Evo.PUNTI_OPERATIVI (
                 SEDE_TECNICA,
                 CODICE_MIR,
                 DEFINIZIONE,
                 STATO_SISTEMA,
                 STATO_UTENTE,
                 LOCALITA_CONTENITORE,
                 KM_INIZIO,
                 PO_1_2_0_0_0_2,
                 PO_1_2_0_0_0_3_AP,
                 PO_1_2_0_0_0_4,
                 PO_1_2_0_0_0_6,
                 LATITUDINE,
                 LONGITUDINE,
                 CODICE_LINEA_TECNICA,
                 CODICE_DTP,
                 CODICE_UT,
                 NUOVA_CLASSIFICAZIONE_STAZIONE,
                 CODICE_VERSIONE,        -- codice_controllo,
                 TIPO_LOCALITA_CONFINE,
                 GRUPPO_AUTORIZZATIVO,
                 CACHE_FIELD,
  		         PO_1_2_0_0_0_4_1_AP,
                 PO_1_2_0_0_0_4_1,
                 PO_1_2_3_1_AP,
                 PO_1_2_3_1,
                 PO_1_2_3_2_AP   )
          Select p.SEDE_TECNICA,
                 CODICE_MIR,
                 DEFINIZIONE,
                 STATO_SISTEMA,
                 STATO_UTENTE,
                 LOCALITA_CONTENITORE,
                 KM_INIZIO,
                 PO_1_2_0_0_0_2,
                 PO_1_2_0_0_0_3_AP,
                 PO_1_2_0_0_0_4,
                 PO_1_2_0_0_0_6,
                 LATITUDINE,
                 LONGITUDINE,
                 CODICE_LINEA_TECNICA,
                 p.CODICE_DTP,
                 CODICE_UT,
                 NUOVA_CLASSIFICAZIONE_STAZIONE,
                 p_versione,      -- codice_controllo
                 TIPO_LOCALITA_CONFINE,
                 GRUPPO_AUTORIZZATIVO,
                 CACHE_FIELD,
				 PO_1_2_0_0_0_4_1_AP,
                 PO_1_2_0_0_0_4_1,
                 PO_1_2_3_1_AP,
                 PO_1_2_3_1,
                 PO_1_2_3_2_AP
            From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI p,
                 Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
           Where v.CODICE_VERSIONE = p_versione 
	         And v.FLAG_NEW = 9 
		     And p.SEDE_TECNICA = v.SEDE_TECNICA      
		     And p.SEDE_TECNICA = p_SEDE_TECNICA ;

  DBMS_OUTPUT.PUT_LINE('PUNTI_OPERATIVI record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

 EXCEPTION
      When OTHERS Then
		p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert PUNTI_OPERATIVI - Errore: '|| Substr(SQLERRM, 1, 300));
 End;


-- --------------------------------------------------------------------------------------
-- TAF/TAP PO 
-- --------------------------------------------------------------------------------------

 begin
   p_error := 0;

      Insert Into Rinf_Pubblicati_Evo.PAR_1_2_0_0_0_3_TAF_TAP
--    Insert Into Rinf_controllati_Evo.PAR_1_2_0_0_0_3_TAF_TAP
         (   SEDE_TECNICA,
             PO_1_2_0_0_0_3,
             KM_INIZIO,
             KM_FINE ,  
			 CODICE_VERSIONE   
			 )
         Select Distinct
             p.SEDE_TECNICA,
             PO_1_2_0_0_0_3,
             KM_INIZIO,
             KM_FINE ,              
			 p_versione
        From Rinf_Autorizzazioni_Evo.PAR_1_2_0_0_0_3_TAF_TAP p,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where v.CODICE_VERSIONE = p_versione 
	     And v.FLAG_NEW = 9 
		 And p.SEDE_TECNICA = v.SEDE_TECNICA
 	     And p.SEDE_TECNICA = p_SEDE_TECNICA;

  DBMS_OUTPUT.PUT_LINE('PAR_1_2_0_0_0_3_TAF_TAP record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

 EXCEPTION
      When OTHERS Then
 		p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert PAR_1_2_0_0_0_3_TAF_TAP - Errore: '|| Substr(SQLERRM, 1, 300));
 End;
-- --------------------------------------------------------------------------------------
-- NORME_DOC PO 
-- --------------------------------------------------------------------------------------

 Begin
   p_error := 0;

     Insert Into Rinf_Pubblicati_Evo.PAR_1_2_3_2_DOC_norme
--       Insert Into Rinf_Controllati_Evo.PAR_1_2_3_2_DOC_norme
             (SEDE_TECNICA, PO_1_2_3_2, CODICE_VERSIONE)
     Select p.SEDE_TECNICA, PO_1_2_3_2, p_versione
       From Rinf_Autorizzazioni_Evo.PAR_1_2_3_2_DOC_norme p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9
		And p.SEDE_TECNICA = v.SEDE_TECNICA
		And p.SEDE_TECNICA = p_SEDE_TECNICA ;

  DBMS_OUTPUT.PUT_LINE('PAR_1_2_3_2_DOC_norme record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);

EXCEPTION
      When OTHERS Then
 		p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert PAR_1_2_3_2_DOC_norme - Errore: '|| Substr(SQLERRM, 1, 300));
 End;

-- -----------------------------------------------------------------------------
--   (CORRIDOIO_PO, LINEE_TENT_PO, LINEA_COMM_PO, LINEA_TRIPLETTA )
-- -----------------------------------------------------------------------------
--

  Begin
     p_error := 0;
--
-- Relazioni Op-Corridoio Nuove
    Insert Into Rinf_Pubblicati_Evo.CORRIDOIO_PO
--    Insert Into Rinf_Controllati_Evo.CORRIDOIO_PO
            (CODICE_CORRIDOIO, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_CORRIDOIO,
            p.SEDE_TECNICA,
            p_versione
       From Rinf_Autorizzazioni_Evo.CORRIDOIO_PO p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9
		And p.SEDE_TECNICA = v.SEDE_TECNICA
		And p.SEDE_TECNICA = p_SEDE_TECNICA ;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert Into CORRIDOIO_PO - Errore: '|| Substr(SQLERRM, 1, 300));
  End;
--
-- Relazioni OP-Linee Ten Nuove
--
  Begin
     p_error := 0;
    Insert Into Rinf_Pubblicati_Evo.LINEE_TENT_PO
--    Insert Into Rinf_Controllati_Evo.LINEE_TENT_PO
            (CODICE_LINEA_TENT, SEDE_TECNICA, CODICE_VERSIONE)
      Select CODICE_LINEA_TENT,
             p.SEDE_TECNICA,
             p_versione
        From Rinf_Autorizzazioni_Evo.LINEE_TENT_PO p,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where v.CODICE_VERSIONE = p_versione 
	     And v.FLAG_NEW = 9 
		 And p.SEDE_TECNICA = v.SEDE_TECNICA
		 And p.SEDE_TECNICA = p_SEDE_TECNICA ;

 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert Into CORRIDOIO_PO - Errore: '|| Substr(SQLERRM, 1, 300));
  End;

--
-- Relazione OP-Linee Comm nuove
--
 Begin
     p_error := 0;

    Insert Into Rinf_Pubblicati_Evo.LINEA_COMM_PO
--    Insert Into Rinf_Controllati_Evo.LINEA_COMM_PO
            (CODICE_GIURISDIZIONE, 
			 SEDE_TECNICA, 
			 CODICE_VERSIONE, 
			 KM_INIZIO)
      Select CODICE_GIURISDIZIONE,
             p.SEDE_TECNICA,
             p_versione,
             KM_INIZIO
        From Rinf_Autorizzazioni_Evo.LINEA_COMM_PO p,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where v.CODICE_VERSIONE = p_versione 
	     And v.FLAG_NEW = 9 
		 And p.SEDE_TECNICA = v.SEDE_TECNICA
		 And p.SEDE_TECNICA = p_SEDE_TECNICA ;

 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert Into CORRIDOIO_PO - Errore: '|| Substr(SQLERRM, 1, 300));
  End;
--
 Begin
     p_error := 0;
--
-- Relazione OP-SOL Linee Comm fittizie nuove
    Insert Into Rinf_Pubblicati_Evo.LINEA_TRIPLETTA
--    Insert Into Rinf_Controllati_Evo.LINEA_TRIPLETTA
           (CODICE_LINEA, 
		    SEDE_TECNICA, 
			CODICE_VERSIONE,
			LINEA_ORIGINE)
     Select CODICE_LINEA,
            p.SEDE_TECNICA,
            p_versione,
            LINEA_ORIGINE
       From Rinf_Autorizzazioni_Evo.LINEA_TRIPLETTA p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9 
		And p.SEDE_TECNICA = v.SEDE_TECNICA
		And p.SEDE_TECNICA = p_SEDE_TECNICA ;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        Dbms_Output.Put_Line ('Set_Skeleton_PO - Errore: '|| Substr(SQLERRM, 1, 300));
  End;


-- --------------------------------------------------------------------------------------
-- 
-- --------------------------------------------------------------------------------------
 END Set_Skeleton_PO;



/*********************************************************************************************************************/
--
/*********************************************************************************************************************/
Procedure Set_Skeleton_SOL (p_SEDE_TECNICA varchar2, p_versione Number, p_error out Number ) is
-- Modificata il 25/10/2023 per gestire differentemente le linee di tipo Link (tutti N.A.) da quelle Regular (tutti NYA)
--
   Tipo_Linea Varchar2(1);
--
 Begin
   	p_error := 0;
--                             SOL
-- --------------------------------------------------------------------------------------
-- parametri delle SEZIONE LINEA
-- --------------------------------------------------------------------------------------
--
  Begin
 -- 
   		Select SOL_1_1_0_0_0_6 
		  Into Tipo_Linea
		  From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
		 Where Sede_Tecnica = p_SEDE_TECNICA;
--
  Exception
      When NO_DATA_FOUND Then
 		Tipo_Linea := 'R';
        Dbms_Output.Put_Line ('Tipo Linea non trovata per '||p_SEDE_TECNICA);
  End;
--
-- --------------------------------------------------------------------------
--                       SEZIONI_LINEA
-- --------------------------------------------------------------------------
--
  Begin
--
    Insert Into Rinf_Pubblicati_Evo.SEZIONI_LINEA (
	        SEDE_TECNICA,
            DEFINIZIONE,
            STATO_SISTEMA,
            STATO_UTENTE,
            LOCALITA_CONTENITORE,
            LOCALITA_INIZIO,
            LOCALITA_FINE,
            KM_INIZIO,
            KM_FINE,
            SOL_1_1_0_0_0_1,
            SOL_1_1_0_0_0_3,
            SOL_1_1_0_0_0_4,
            SOL_1_1_0_0_0_5,
            SOL_1_1_0_0_0_6,
            REGIME_CIRCOLAZIONE,
            CODICE_LINEA_TECNICA,
            CODICE_DTP,
            CODICE_UT,
            CODICE_VERSIONE,  -- Codice_controllo,  
            GRUPPO_AUTORIZZATIVO,
            CACHE_FIELD    )
     Select p.SEDE_TECNICA,
            DEFINIZIONE,
            STATO_SISTEMA,
            STATO_UTENTE,
            LOCALITA_CONTENITORE,
            LOCALITA_INIZIO,
            LOCALITA_FINE,
            KM_INIZIO,
            KM_FINE,
            SOL_1_1_0_0_0_1,
            SOL_1_1_0_0_0_3,
            SOL_1_1_0_0_0_4,
            SOL_1_1_0_0_0_5,
            SOL_1_1_0_0_0_6,
            REGIME_CIRCOLAZIONE,
            CODICE_LINEA_TECNICA,
            p.CODICE_DTP,
            CODICE_UT,
            p_versione,
            GRUPPO_AUTORIZZATIVO,
            Null --CACHE_FIELD
       From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where p.SEDE_TECNICA = v.SEDE_TECNICA
		And p.SEDE_TECNICA = p_SEDE_TECNICA
		And v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9 ;
--
  DBMS_OUTPUT.PUT_LINE('SEZIONI_LINEA record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
--
  Exception
      When OTHERS Then
 		p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert SEZIONI_LINEA - Errore: '|| Substr(SQLERRM, 1, 300));
   End;
--
-- --------------------------------------------------------------------------------------
-- (CORRIDOIO_SOL)
-- --------------------------------------------------------------------------------------
--
  Begin
--
    Insert Into Rinf_Pubblicati_Evo.CORRIDOIO_SOL
           (CODICE_CORRIDOIO, 
		    SEDE_TECNICA, 
			CODICE_VERSIONE
			)
     Select CODICE_CORRIDOIO,
            p.SEDE_TECNICA,
            p_versione
       From Rinf_Autorizzazioni_Evo.CORRIDOIO_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where p.SEDE_TECNICA = v.SEDE_TECNICA      
		And p.SEDE_TECNICA = p_SEDE_TECNICA 
		And v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9 ;
--
  DBMS_OUTPUT.PUT_LINE('CORRIDOIO_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
--
  Exception
      When OTHERS Then
  		p_error := SQLCODE;
       Dbms_Output.Put_Line ('Insert CORRIDOIO_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
  End;
--
-- --------------------------------------------------------------------------------------
-- Linee Ten (LINEE_TENT_SOL)
-- --------------------------------------------------------------------------------------
--
  Begin
--
    Insert Into Rinf_Pubblicati_Evo.LINEE_TENT_SOL
           (CODICE_LINEA_TENT, 
		    SEDE_TECNICA, 
			CODICE_VERSIONE
			)
     Select CODICE_LINEA_TENT,
            p.SEDE_TECNICA,
            p_versione
       From Rinf_Autorizzazioni_Evo.LINEE_TENT_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where p.SEDE_TECNICA = v.SEDE_TECNICA      
		And p.SEDE_TECNICA = p_SEDE_TECNICA 
		And v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9 ;
--
  DBMS_OUTPUT.PUT_LINE('LINEE_TENT_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
--
  Exception
      When OTHERS Then
 		p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert LINEE_TENT_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
  End;
--
-- --------------------------------------------------------------------------------------
--  (LINEA_COMM_SOL)
-- --------------------------------------------------------------------------------------
--
 Begin
--
    Insert Into Rinf_Pubblicati_Evo.LINEA_COMM_SOL
           (CODICE_GIURISDIZIONE, 
		    SEDE_TECNICA, 
		    CODICE_VERSIONE, 
		    KM_INIZIO, 
		    KM_FINE)
     Select CODICE_GIURISDIZIONE,
            p.SEDE_TECNICA,
            p_versione,
            KM_INIZIO, 
	        KM_FINE
       From Rinf_Autorizzazioni_Evo.LINEA_COMM_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where p.SEDE_TECNICA = v.SEDE_TECNICA      
		And p.SEDE_TECNICA = p_SEDE_TECNICA
		And v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9 ;
--
  DBMS_OUTPUT.PUT_LINE('LINEA_COMM_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
--
  Exception
      When OTHERS Then
 		p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert LINEA_COMM_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
  End;
--
-- --------------------------------------------------------------------------------------
-- Relazione SOL-Linee FCL versione precedente (LINEA_FCL_SOL)
-- --------------------------------------------------------------------------------------
--
  Begin 
--
    Insert Into Rinf_Pubblicati_Evo.LINEA_FCL_SOL
           (CODICE_LINEA_FCL, 
		    SEDE_TECNICA,
			CODICE_VERSIONE
			)
     Select CODICE_LINEA_FCL,
            p.SEDE_TECNICA,
            p_versione
       From Rinf_Autorizzazioni_Evo.LINEA_FCL_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where p.SEDE_TECNICA = v.SEDE_TECNICA      
		And p.SEDE_TECNICA = p_SEDE_TECNICA
		And v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9 ;

--
  DBMS_OUTPUT.PUT_LINE('LINEA_FCL_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
--
  Exception
      When OTHERS Then
 		p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert LINEA_FCL_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
  End;
--
-- --------------------------------------------------------------------------------------
-- Relazione SOL-Fasciolo Linea versione precedente (FASCICOLO_SOL)
-- --------------------------------------------------------------------------------------
--
  Begin
--
    Insert Into Rinf_Pubblicati_Evo.FASCICOLO_SOL
           (CODICE_FASCICOLO, 
		    SEDE_TECNICA, 
			CODICE_VERSIONE
			)
     Select CODICE_FASCICOLO,
            p.SEDE_TECNICA,
            p_versione
       From Rinf_Autorizzazioni_Evo.FASCICOLO_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where p.SEDE_TECNICA = v.SEDE_TECNICA      
		And p.SEDE_TECNICA = p_SEDE_TECNICA
		And v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9 ;
--
  DBMS_OUTPUT.PUT_LINE('FASCICOLO_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
--
  Exception
      When OTHERS Then
 		p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert FASCICOLO_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
  End;
--
-- --------------------------------------------------------------------------------------
-- Binari SOL 
-- --------------------------------------------------------------------------------------
--
    If Tipo_Linea = 'R' Then	
--
      Begin
--
       Insert Into Rinf_Pubblicati_Evo.BINARI_CORSA_SOL (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_0_0_1_D,
            SOL_TRACK_1_1_1_0_0_2,
            SOL_TRACK_1_1_1_1_2_1_AP,
--            SOL_TRACK_1_1_1_1_2_1,
            SOL_TRACK_1_1_1_1_2_2_AP,
--            SOL_TRACK_1_1_1_1_2_2,
            SOL_TRACK_1_1_1_1_2_3_AP,
--             SOL_TRACK_1_1_1_1_2_3,
            SOL_TRACK_1_1_1_1_2_4_AP,
--             SOL_TRACK_1_1_1_1_2_4,
            SOL_TRACK_1_1_1_1_2_5_AP,
            SOL_TRACK_1_1_1_1_2_5,
            SOL_TRACK_1_1_1_1_2_6_AP,
            SOL_TRACK_1_1_1_1_2_6,
            SOL_TRACK_1_1_1_1_2_7_AP,
            SOL_TRACK_1_1_1_1_2_7,
            SOL_TRACK_1_1_1_1_2_8_AP,
            SOL_TRACK_1_1_1_1_2_8,
            SOL_TRACK_1_1_1_1_3_1_AP,
            SOL_TRACK_1_1_1_1_3_1,
            SOL_TRACK_1_1_1_1_3_2_AP,
            SOL_TRACK_1_1_1_1_3_2,
            SOL_TRACK_1_1_1_1_3_3_AP,
            SOL_TRACK_1_1_1_1_3_3,
            SOL_TRACK_1_1_1_1_3_4_AP,
--            SOL_TRACK_1_1_1_1_3_4,
            SOL_TRACK_1_1_1_1_3_5_AP,
--            SOL_TRACK_1_1_1_1_3_5,
            SOL_TRACK_1_1_1_1_3_6_AP,
--            SOL_TRACK_1_1_1_1_3_6,
            SOL_TRACK_1_1_1_1_3_7_AP,
            SOL_TRACK_1_1_1_1_3_7,
            SOL_TRACK_1_1_1_1_4_1_AP,
            SOL_TRACK_1_1_1_1_4_1,
            SOL_TRACK_1_1_1_1_4_2_AP,
            SOL_TRACK_1_1_1_1_4_2,
            SOL_TRACK_1_1_1_1_4_3_AP,
            SOL_TRACK_1_1_1_1_4_3,
            SOL_TRACK_1_1_1_1_4_4_AP,
            SOL_TRACK_1_1_1_1_4_4,
            SOL_TRACK_1_1_1_1_5_1_AP,
            SOL_TRACK_1_1_1_1_5_1,
            SOL_TRACK_1_1_1_1_5_2_AP,
            SOL_TRACK_1_1_1_1_5_2,
            SOL_TRACK_1_1_1_1_6_1_AP,
            SOL_TRACK_1_1_1_1_6_1,
            SOL_TRACK_1_1_1_1_6_2_AP,
            SOL_TRACK_1_1_1_1_6_2,
            SOL_TRACK_1_1_1_1_6_3_AP,
            SOL_TRACK_1_1_1_1_6_3,
            SOL_TRACK_1_1_1_1_7_1_AP,
            SOL_TRACK_1_1_1_1_7_1,
            SOL_TRACK_1_1_1_1_7_2_AP,
            SOL_TRACK_1_1_1_1_7_2,
            SOL_TRACK_1_1_1_1_7_3_AP,
            SOL_TRACK_1_1_1_1_7_3,
            SOL_TRACK_1_1_1_2_2_1_1_AP,
            SOL_TRACK_1_1_1_2_2_1_1,
            SOL_TRACK_1_1_1_2_2_1_2_AP,
            SOL_TRACK_1_1_1_2_2_1_2,
            SOL_TRACK_1_1_1_2_2_2_AP,
            SOL_TRACK_1_1_1_2_2_2,
            SOL_TRACK_1_1_1_2_2_3_AP,
            SOL_TRACK_1_1_1_2_2_3,
            SOL_TRACK_1_1_1_2_2_4_AP,
            SOL_TRACK_1_1_1_2_2_4,
            SOL_TRACK_1_1_1_2_2_5_AP,
            SOL_TRACK_1_1_1_2_2_5,
            SOL_TRACK_1_1_1_2_2_6_AP,
            SOL_TRACK_1_1_1_2_2_6,
            SOL_TRACK_1_1_1_2_3_1_AP,
            SOL_TRACK_1_1_1_2_3_1,
            SOL_TRACK_1_1_1_2_3_2_AP,
            SOL_TRACK_1_1_1_2_3_2,
            SOL_TRACK_1_1_1_2_3_3_AP,
            SOL_TRACK_1_1_1_2_3_3_A,
            SOL_TRACK_1_1_1_2_3_3_B,
            SOL_TRACK_1_1_1_2_3_3_C,
            SOL_TRACK_1_1_1_2_3_4_AP,
            SOL_TRACK_1_1_1_2_3_4,
            SOL_TRACK_1_1_1_2_4_1_1_AP,
            SOL_TRACK_1_1_1_2_4_1_1,
            SOL_TRACK_1_1_1_2_4_1_2_AP,
            SOL_TRACK_1_1_1_2_4_1_2_A,
            SOL_TRACK_1_1_1_2_4_1_2_B,
            SOL_TRACK_1_1_1_2_4_1_2_C,
            SOL_TRACK_1_1_1_2_4_2_1_AP,
            SOL_TRACK_1_1_1_2_4_2_1,
            SOL_TRACK_1_1_1_2_4_2_2_AP,
            SOL_TRACK_1_1_1_2_4_2_2_A,
            SOL_TRACK_1_1_1_2_4_2_2_B,
            SOL_TRACK_1_1_1_2_4_2_2_C,
            SOL_TRACK_1_1_1_2_4_2_2_D,
            SOL_TRACK_1_1_1_2_5_1_AP,
            SOL_TRACK_1_1_1_2_5_1,
            SOL_TRACK_1_1_1_2_5_2_AP,
            SOL_TRACK_1_1_1_2_5_2,
            SOL_TRACK_1_1_1_2_5_3_AP,
            SOL_TRACK_1_1_1_2_5_3,
            SOL_TRACK_1_1_1_3_2_1_AP,
            SOL_TRACK_1_1_1_3_2_1,
            SOL_TRACK_1_1_1_3_2_2_AP,
            SOL_TRACK_1_1_1_3_2_2,
            SOL_TRACK_1_1_1_3_2_3_AP,
            SOL_TRACK_1_1_1_3_2_3,
            SOL_TRACK_1_1_1_3_2_4_AP,
            SOL_TRACK_1_1_1_3_2_4,
            SOL_TRACK_1_1_1_3_2_5_AP,
            SOL_TRACK_1_1_1_3_2_5,
            SOL_TRACK_1_1_1_3_2_6_AP,
            SOL_TRACK_1_1_1_3_2_6,
            SOL_TRACK_1_1_1_3_2_7_AP,
            SOL_TRACK_1_1_1_3_2_7,
            SOL_TRACK_1_1_1_3_3_1_AP,
            SOL_TRACK_1_1_1_3_3_1,
            SOL_TRACK_1_1_1_3_3_2_AP,
            SOL_TRACK_1_1_1_3_3_2,
            SOL_TRACK_1_1_1_3_3_3_AP,
--            SOL_TRACK_1_1_1_3_3_3,
            SOL_TRACK_1_1_1_3_4_1_AP,
            SOL_TRACK_1_1_1_3_4_1,
            SOL_TRACK_1_1_1_3_5_1_AP,
            SOL_TRACK_1_1_1_3_5_1,
            SOL_TRACK_1_1_1_3_5_2_AP,
            SOL_TRACK_1_1_1_3_5_2,
            SOL_TRACK_1_1_1_3_6_1_AP,
            SOL_TRACK_1_1_1_3_6_1,
            SOL_TRACK_1_1_1_3_7_1_AP,
            SOL_TRACK_1_1_1_3_7_1,
            SOL_TRACK_1_1_1_3_7_2_1_AP,
            SOL_TRACK_1_1_1_3_7_2_1,
            SOL_TRACK_1_1_1_3_7_2_2_AP,
            SOL_TRACK_1_1_1_3_7_2_2,
            SOL_TRACK_1_1_1_3_7_3_AP,
            SOL_TRACK_1_1_1_3_7_3,
            SOL_TRACK_1_1_1_3_7_4_AP,
            SOL_TRACK_1_1_1_3_7_4,
            SOL_TRACK_1_1_1_3_7_5_AP,
            SOL_TRACK_1_1_1_3_7_5,
            SOL_TRACK_1_1_1_3_7_6_AP,
            SOL_TRACK_1_1_1_3_7_6,
            SOL_TRACK_1_1_1_3_7_7_AP,
            SOL_TRACK_1_1_1_3_7_7,
            SOL_TRACK_1_1_1_3_7_8_AP,
            SOL_TRACK_1_1_1_3_7_8,
            SOL_TRACK_1_1_1_3_7_9_AP,
            SOL_TRACK_1_1_1_3_7_9,
            SOL_TRACK_1_1_1_3_7_10_AP,
            SOL_TRACK_1_1_1_3_7_10,
            SOL_TRACK_1_1_1_3_7_11_AP,
            SOL_TRACK_1_1_1_3_7_11,
            SOL_TRACK_1_1_1_3_7_12_AP,
            SOL_TRACK_1_1_1_3_7_12,
            SOL_TRACK_1_1_1_3_7_13_AP,
            SOL_TRACK_1_1_1_3_7_13,
            SOL_TRACK_1_1_1_3_7_14_AP,
            SOL_TRACK_1_1_1_3_7_14,
            SOL_TRACK_1_1_1_3_7_15_1_AP,
            SOL_TRACK_1_1_1_3_7_15_1,
            SOL_TRACK_1_1_1_3_7_15_2_AP,
            SOL_TRACK_1_1_1_3_7_15_2,
            SOL_TRACK_1_1_1_3_7_16_AP,
            SOL_TRACK_1_1_1_3_7_16,
            SOL_TRACK_1_1_1_3_7_17_AP,
            SOL_TRACK_1_1_1_3_7_17,
            SOL_TRACK_1_1_1_3_7_18_AP,
            SOL_TRACK_1_1_1_3_7_18,
            SOL_TRACK_1_1_1_3_7_19_AP,
            SOL_TRACK_1_1_1_3_7_19,
            SOL_TRACK_1_1_1_3_7_20_AP,
            SOL_TRACK_1_1_1_3_7_20,
            SOL_TRACK_1_1_1_3_7_21_AP,
            SOL_TRACK_1_1_1_3_7_21,
            SOL_TRACK_1_1_1_3_7_22_AP,
            SOL_TRACK_1_1_1_3_7_22,
            SOL_TRACK_1_1_1_3_7_23_AP,
            SOL_TRACK_1_1_1_3_7_23,
            SOL_TRACK_1_1_1_3_8_1_AP,
            SOL_TRACK_1_1_1_3_8_1,
            SOL_TRACK_1_1_1_3_8_2_AP,
            SOL_TRACK_1_1_1_3_8_2,
            SOL_TRACK_1_1_1_3_9_1_AP,
            SOL_TRACK_1_1_1_3_9_1,
            SOL_TRACK_1_1_1_3_9_2_AP,
            SOL_TRACK_1_1_1_3_9_2,
            SOL_TRACK_1_1_1_3_10_1_AP,
            SOL_TRACK_1_1_1_3_10_1,
            SOL_TRACK_1_1_1_3_10_2_AP,
            SOL_TRACK_1_1_1_3_10_2,
            SOL_TRACK_1_1_1_3_11_1_AP,
            SOL_TRACK_1_1_1_3_11_1,
            SOL_TRACK_1_1_1_3_12_1_AP,
            SOL_TRACK_1_1_1_3_12_1,
            TIPO_BINARIO,
            SEDE_TECNICA,
            CODICE_VERSIONE,
            GRUPPO_AUTORIZZATIVO,
	        SOL_TRACK_1_1_1_1_2_4_1_AP      ,              --  NUOVI PARAMETRI Reg.2019/777
            SOL_TRACK_1_1_1_1_2_4_1         ,
            SOL_TRACK_1_1_1_1_2_4_2_AP      ,
            SOL_TRACK_1_1_1_1_2_4_2         ,
            SOL_TRACK_1_1_1_1_2_4_3_AP      ,
            SOL_TRACK_1_1_1_1_2_4_4_AP      ,
            SOL_TRACK_1_1_1_1_2_4_4         ,
            SOL_TRACK_1_1_1_1_3_1_1_AP      ,
            SOL_TRACK_1_1_1_1_3_1_1_INF     ,
            SOL_TRACK_1_1_1_1_3_1_1_SUP     ,
            SOL_TRACK_1_1_1_1_3_1_2_AP      ,
            SOL_TRACK_1_1_1_1_3_1_2         ,
            SOL_TRACK_1_1_1_1_3_1_3_AP      ,
            SOL_TRACK_1_1_1_1_3_1_3         ,
            SOL_TRACK_1_1_1_1_6_4_AP        ,
            SOL_TRACK_1_1_1_1_6_4           ,
            SOL_TRACK_1_1_1_1_6_5_AP        ,
            SOL_TRACK_1_1_1_1_6_5           ,
            SOL_TRACK_1_1_1_1_7_4_AP        ,
            SOL_TRACK_1_1_1_1_7_4           ,
            SOL_TRACK_1_1_1_1_7_5_AP        ,
            SOL_TRACK_1_1_1_1_7_5           ,
            SOL_TRACK_1_1_1_1_7_6_AP        ,
            SOL_TRACK_1_1_1_1_7_6           ,
            SOL_TRACK_1_1_1_1_7_7_AP        ,
            SOL_TRACK_1_1_1_1_7_7           ,
            SOL_TRACK_1_1_1_1_7_8_AP        ,
            SOL_TRACK_1_1_1_1_7_9_AP        ,
            SOL_TRACK_1_1_1_1_7_9           ,
            SOL_TRACK_1_1_1_2_2_1_2_1_AP    ,
            SOL_TRACK_1_1_1_2_2_1_2_1       ,
            SOL_TRACK_1_1_1_2_2_1_3_AP      ,
            SOL_TRACK_1_1_1_2_2_1_3         ,
            SOL_TRACK_1_1_1_2_4_3_AP        ,
            SOL_TRACK_1_1_1_2_4_3           ,
            SOL_TRACK_1_1_1_3_2_8_AP        ,
            SOL_TRACK_1_1_1_3_2_8           ,
            SOL_TRACK_1_1_1_3_2_9_AP        ,
            SOL_TRACK_1_1_1_3_3_3_2_AP      ,
            SOL_TRACK_1_1_1_3_3_3_2         ,
            SOL_TRACK_1_1_1_3_3_3_3_AP      ,
            SOL_TRACK_1_1_1_3_3_3_3         ,
            SOL_TRACK_1_1_1_3_3_3_1_AP      ,
            SOL_TRACK_1_1_1_3_3_3_1         ,
            SOL_TRACK_1_1_1_3_3_4_AP        ,
            SOL_TRACK_1_1_1_3_3_4           ,
            SOL_TRACK_1_1_1_3_3_5_AP        ,
            SOL_TRACK_1_1_1_3_3_6_AP        ,
            SOL_TRACK_1_1_1_3_3_6           ,
            SOL_TRACK_1_1_1_3_3_7_AP        ,
            SOL_TRACK_1_1_1_3_3_7           ,
            SOL_TRACK_1_1_1_3_3_8_AP        ,
            SOL_TRACK_1_1_1_3_3_8           ,
            SOL_TRACK_1_1_1_3_3_9_AP        ,
            SOL_TRACK_1_1_1_3_3_10_AP       ,
            SOL_TRACK_1_1_1_3_5_3_AP        ,
            SOL_TRACK_1_1_1_3_7_1_2_AP      ,
            SOL_TRACK_1_1_1_3_7_1_2         ,
            SOL_TRACK_1_1_1_3_7_1_3_AP      ,
            SOL_TRACK_1_1_1_3_7_1_4_AP      ,
            SOL_TRACK_1_1_1_3_7_1_4         ,
            SOL_TRACK_1_1_1_3_7_11_1_AP     ,
            SOL_TRACK_1_1_1_3_11_2_AP       ,
            SOL_TRACK_1_1_1_3_11_2          ,
            SOL_TRACK_1_1_1_3_11_3_AP       ,
            SOL_TRACK_1_1_1_3_11_3          ,
            SOL_TRACK_1_1_1_4_1_AP          ,
            SOL_TRACK_1_1_1_4_1             ,
            SOL_TRACK_1_1_1_4_2_AP          ,
            SOL_TRACK_1_1_1_1_3_5_1         ,
            SOL_TRACK_1_1_1_1_3_5_1_AP      ,
            SOL_TRACK_1_1_1_1_7_10_AP       ,
            SOL_TRACK_1_1_1_1_7_10          ,
            SOL_TRACK_1_1_1_1_7_11_AP       ,
            SOL_TRACK_1_1_1_1_7_11          ,
            SOL_TRACK_1_1_1_3_2_10_AP       ,
            SOL_TRACK_1_1_1_3_2_10          ,
            SOL_TRACK_1_1_1_3_7_1_1_AP      ,
            SOL_TRACK_1_1_1_3_7_1_1         ,
            SOL_TRACK_1_1_1_1_2_1_2_AP      ,
            SOL_TRACK_1_1_1_1_2_1_2
			)
    Select 	SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_0_0_1_D,
            SOL_TRACK_1_1_1_0_0_2,
            Case When v.FLAG_DSPS = 1 Then SOL_TRACK_1_1_1_1_2_1_AP
                                      Else 'NYA'
            End SOL_TRACK_1_1_1_1_2_1_AP,
--            SOL_TRACK_1_1_1_1_2_1,
            'NYA',
--            SOL_TRACK_1_1_1_1_2_2,
            Case When v.FLAG_DSPS = 1 Then SOL_TRACK_1_1_1_1_2_3_AP
                                      Else 'NYA'
            End SOL_TRACK_1_1_1_1_2_3_AP,
--             SOL_TRACK_1_1_1_1_2_3,
            'NYA',
--             SOL_TRACK_1_1_1_1_2_4,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
--            SOL_TRACK_1_1_1_1_3_4,
            'NYA',
--            SOL_TRACK_1_1_1_1_3_5,
            'NYA',
--            SOL_TRACK_1_1_1_1_3_6,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            Null,
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            Null,
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            Null,
            Null,
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
--            SOL_TRACK_1_1_1_3_3_3,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            TIPO_BINARIO,
            p.SEDE_TECNICA,
            p_versione,
            GRUPPO_AUTORIZZATIVO,
	        'NYA',             --  NUOVI PARAMETRI Reg.2019/777
            Null,
            'NYA',
            Null,
            'NYA',
            'NYA',
            Null,
            'NYA',
            Null,
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            Null,
            'NYA',
            'NYA',
            'NYA',
            'NYA',
            Null,
            'NYA',
            'NYA',
            Null,
            'NYA',
            'NYA',
            Null,
            'NYA',
            Null,
            Case When v.FLAG_DTEC = 1 Then SOL_TRACK_1_1_1_4_1_AP
                                      Else 'NYA'
            End SOL_TRACK_1_1_1_4_1_AP,					-- SOL_TRACK_1_1_1_4_1_AP
            Case When v.FLAG_DTEC = 1 Then SOL_TRACK_1_1_1_4_1
                                      Else Null
            End SOL_TRACK_1_1_1_4_1,					-- SOL_TRACK_1_1_1_4_1_AP
            Case When v.FLAG_DTEC = 1 Then SOL_TRACK_1_1_1_4_2_AP
                                      Else 'NYA'
            End SOL_TRACK_1_1_1_4_2_AP,					-- SOL_TRACK_1_1_1_4_2_AP
            Null,						-- SOL_TRACK_1_1_1_1_3_5_1
            'NYA',						-- SOL_TRACK_1_1_1_1_3_5_1_AP
            'NYA',						-- SOL_TRACK_1_1_1_1_7_10_AP
            Null,
            'NYA',						-- SOL_TRACK_1_1_1_1_7_11_AP
            Null,
            'NYA',						-- SOL_TRACK_1_1_1_3_2_10_AP
            Null,
            'NYA',                      -- SOL_TRACK_1_1_1_3_7_1_1_AP
            Null,
            Case When v.FLAG_DSPS = 1 Then SOL_TRACK_1_1_1_1_2_1_2_AP
                                      Else 'NYA'
            End SOL_TRACK_1_1_1_1_2_1_2_AP,
            Case When v.FLAG_DSPS = 1 Then SOL_TRACK_1_1_1_1_2_1_2
                                      Else Null
            End SOL_TRACK_1_1_1_1_2_1_2
	   From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL p ,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where p.SEDE_TECNICA = v.SEDE_TECNICA      
		And p.SEDE_TECNICA = p_SEDE_TECNICA
		And v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9 ;
--
  DBMS_OUTPUT.PUT_LINE('BINARI_CORSA_SOL "R" record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
--
  Exception
      When OTHERS Then
 		p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert BINARI_CORSA_SOL "R" - Errore: '|| Substr(SQLERRM, 1, 300));
  End;

  --
-- --------------------------------------------------------------------------------------
--           Gestione Binari di tipo Link
-- --------------------------------------------------------------------------------------
   Elsif Tipo_Linea = 'L' Then
--
       Begin 
--
         Insert Into Rinf_Pubblicati_Evo.BINARI_CORSA_SOL (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_0_0_1_D,
            SOL_TRACK_1_1_1_0_0_2,
            SOL_TRACK_1_1_1_1_2_1_AP,
--            SOL_TRACK_1_1_1_1_2_1,
            SOL_TRACK_1_1_1_1_2_2_AP,
--            SOL_TRACK_1_1_1_1_2_2,
            SOL_TRACK_1_1_1_1_2_3_AP,
--             SOL_TRACK_1_1_1_1_2_3,
            SOL_TRACK_1_1_1_1_2_4_AP,
--             SOL_TRACK_1_1_1_1_2_4,
            SOL_TRACK_1_1_1_1_2_5_AP,
            SOL_TRACK_1_1_1_1_2_5,
            SOL_TRACK_1_1_1_1_2_6_AP,
            SOL_TRACK_1_1_1_1_2_6,
            SOL_TRACK_1_1_1_1_2_7_AP,
            SOL_TRACK_1_1_1_1_2_7,
            SOL_TRACK_1_1_1_1_2_8_AP,
            SOL_TRACK_1_1_1_1_2_8,
            SOL_TRACK_1_1_1_1_3_1_AP,
            SOL_TRACK_1_1_1_1_3_1,
            SOL_TRACK_1_1_1_1_3_2_AP,
            SOL_TRACK_1_1_1_1_3_2,
            SOL_TRACK_1_1_1_1_3_3_AP,
            SOL_TRACK_1_1_1_1_3_3,
            SOL_TRACK_1_1_1_1_3_4_AP,
--            SOL_TRACK_1_1_1_1_3_4,
            SOL_TRACK_1_1_1_1_3_5_AP,
--            SOL_TRACK_1_1_1_1_3_5,
            SOL_TRACK_1_1_1_1_3_6_AP,
--            SOL_TRACK_1_1_1_1_3_6,
            SOL_TRACK_1_1_1_1_3_7_AP,
            SOL_TRACK_1_1_1_1_3_7,
            SOL_TRACK_1_1_1_1_4_1_AP,
            SOL_TRACK_1_1_1_1_4_1,
            SOL_TRACK_1_1_1_1_4_2_AP,
            SOL_TRACK_1_1_1_1_4_2,
            SOL_TRACK_1_1_1_1_4_3_AP,
            SOL_TRACK_1_1_1_1_4_3,
            SOL_TRACK_1_1_1_1_4_4_AP,
            SOL_TRACK_1_1_1_1_4_4,
            SOL_TRACK_1_1_1_1_5_1_AP,
            SOL_TRACK_1_1_1_1_5_1,
            SOL_TRACK_1_1_1_1_5_2_AP,
            SOL_TRACK_1_1_1_1_5_2,
            SOL_TRACK_1_1_1_1_6_1_AP,
            SOL_TRACK_1_1_1_1_6_1,
            SOL_TRACK_1_1_1_1_6_2_AP,
            SOL_TRACK_1_1_1_1_6_2,
            SOL_TRACK_1_1_1_1_6_3_AP,
            SOL_TRACK_1_1_1_1_6_3,
            SOL_TRACK_1_1_1_1_7_1_AP,
            SOL_TRACK_1_1_1_1_7_1,
            SOL_TRACK_1_1_1_1_7_2_AP,
            SOL_TRACK_1_1_1_1_7_2,
            SOL_TRACK_1_1_1_1_7_3_AP,
            SOL_TRACK_1_1_1_1_7_3,
            SOL_TRACK_1_1_1_2_2_1_1_AP,
            SOL_TRACK_1_1_1_2_2_1_1,
            SOL_TRACK_1_1_1_2_2_1_2_AP,
            SOL_TRACK_1_1_1_2_2_1_2,
            SOL_TRACK_1_1_1_2_2_2_AP,
            SOL_TRACK_1_1_1_2_2_2,
            SOL_TRACK_1_1_1_2_2_3_AP,
            SOL_TRACK_1_1_1_2_2_3,
            SOL_TRACK_1_1_1_2_2_4_AP,
            SOL_TRACK_1_1_1_2_2_4,
            SOL_TRACK_1_1_1_2_2_5_AP,
            SOL_TRACK_1_1_1_2_2_5,
            SOL_TRACK_1_1_1_2_2_6_AP,
            SOL_TRACK_1_1_1_2_2_6,
            SOL_TRACK_1_1_1_2_3_1_AP,
            SOL_TRACK_1_1_1_2_3_1,
            SOL_TRACK_1_1_1_2_3_2_AP,
            SOL_TRACK_1_1_1_2_3_2,
            SOL_TRACK_1_1_1_2_3_3_AP,
            SOL_TRACK_1_1_1_2_3_3_A,
            SOL_TRACK_1_1_1_2_3_3_B,
            SOL_TRACK_1_1_1_2_3_3_C,
            SOL_TRACK_1_1_1_2_3_4_AP,
            SOL_TRACK_1_1_1_2_3_4,
            SOL_TRACK_1_1_1_2_4_1_1_AP,
            SOL_TRACK_1_1_1_2_4_1_1,
            SOL_TRACK_1_1_1_2_4_1_2_AP,
            SOL_TRACK_1_1_1_2_4_1_2_A,
            SOL_TRACK_1_1_1_2_4_1_2_B,
            SOL_TRACK_1_1_1_2_4_1_2_C,
            SOL_TRACK_1_1_1_2_4_2_1_AP,
            SOL_TRACK_1_1_1_2_4_2_1,
            SOL_TRACK_1_1_1_2_4_2_2_AP,
            SOL_TRACK_1_1_1_2_4_2_2_A,
            SOL_TRACK_1_1_1_2_4_2_2_B,
            SOL_TRACK_1_1_1_2_4_2_2_C,
            SOL_TRACK_1_1_1_2_4_2_2_D,
            SOL_TRACK_1_1_1_2_5_1_AP,
            SOL_TRACK_1_1_1_2_5_1,
            SOL_TRACK_1_1_1_2_5_2_AP,
            SOL_TRACK_1_1_1_2_5_2,
            SOL_TRACK_1_1_1_2_5_3_AP,
            SOL_TRACK_1_1_1_2_5_3,
            SOL_TRACK_1_1_1_3_2_1_AP,
            SOL_TRACK_1_1_1_3_2_1,
            SOL_TRACK_1_1_1_3_2_2_AP,
            SOL_TRACK_1_1_1_3_2_2,
            SOL_TRACK_1_1_1_3_2_3_AP,
            SOL_TRACK_1_1_1_3_2_3,
            SOL_TRACK_1_1_1_3_2_4_AP,
            SOL_TRACK_1_1_1_3_2_4,
            SOL_TRACK_1_1_1_3_2_5_AP,
            SOL_TRACK_1_1_1_3_2_5,
            SOL_TRACK_1_1_1_3_2_6_AP,
            SOL_TRACK_1_1_1_3_2_6,
            SOL_TRACK_1_1_1_3_2_7_AP,
            SOL_TRACK_1_1_1_3_2_7,
            SOL_TRACK_1_1_1_3_3_1_AP,
            SOL_TRACK_1_1_1_3_3_1,
            SOL_TRACK_1_1_1_3_3_2_AP,
            SOL_TRACK_1_1_1_3_3_2,
            SOL_TRACK_1_1_1_3_3_3_AP,
--            SOL_TRACK_1_1_1_3_3_3,
            SOL_TRACK_1_1_1_3_4_1_AP,
            SOL_TRACK_1_1_1_3_4_1,
            SOL_TRACK_1_1_1_3_5_1_AP,
            SOL_TRACK_1_1_1_3_5_1,
            SOL_TRACK_1_1_1_3_5_2_AP,
            SOL_TRACK_1_1_1_3_5_2,
            SOL_TRACK_1_1_1_3_6_1_AP,
            SOL_TRACK_1_1_1_3_6_1,
            SOL_TRACK_1_1_1_3_7_1_AP,
            SOL_TRACK_1_1_1_3_7_1,
            SOL_TRACK_1_1_1_3_7_2_1_AP,
            SOL_TRACK_1_1_1_3_7_2_1,
            SOL_TRACK_1_1_1_3_7_2_2_AP,
            SOL_TRACK_1_1_1_3_7_2_2,
            SOL_TRACK_1_1_1_3_7_3_AP,
            SOL_TRACK_1_1_1_3_7_3,
            SOL_TRACK_1_1_1_3_7_4_AP,
            SOL_TRACK_1_1_1_3_7_4,
            SOL_TRACK_1_1_1_3_7_5_AP,
            SOL_TRACK_1_1_1_3_7_5,
            SOL_TRACK_1_1_1_3_7_6_AP,
            SOL_TRACK_1_1_1_3_7_6,
            SOL_TRACK_1_1_1_3_7_7_AP,
            SOL_TRACK_1_1_1_3_7_7,
            SOL_TRACK_1_1_1_3_7_8_AP,
            SOL_TRACK_1_1_1_3_7_8,
            SOL_TRACK_1_1_1_3_7_9_AP,
            SOL_TRACK_1_1_1_3_7_9,
            SOL_TRACK_1_1_1_3_7_10_AP,
            SOL_TRACK_1_1_1_3_7_10,
            SOL_TRACK_1_1_1_3_7_11_AP,
            SOL_TRACK_1_1_1_3_7_11,
            SOL_TRACK_1_1_1_3_7_12_AP,
            SOL_TRACK_1_1_1_3_7_12,
            SOL_TRACK_1_1_1_3_7_13_AP,
            SOL_TRACK_1_1_1_3_7_13,
            SOL_TRACK_1_1_1_3_7_14_AP,
            SOL_TRACK_1_1_1_3_7_14,
            SOL_TRACK_1_1_1_3_7_15_1_AP,
            SOL_TRACK_1_1_1_3_7_15_1,
            SOL_TRACK_1_1_1_3_7_15_2_AP,
            SOL_TRACK_1_1_1_3_7_15_2,
            SOL_TRACK_1_1_1_3_7_16_AP,
            SOL_TRACK_1_1_1_3_7_16,
            SOL_TRACK_1_1_1_3_7_17_AP,
            SOL_TRACK_1_1_1_3_7_17,
            SOL_TRACK_1_1_1_3_7_18_AP,
            SOL_TRACK_1_1_1_3_7_18,
            SOL_TRACK_1_1_1_3_7_19_AP,
            SOL_TRACK_1_1_1_3_7_19,
            SOL_TRACK_1_1_1_3_7_20_AP,
            SOL_TRACK_1_1_1_3_7_20,
            SOL_TRACK_1_1_1_3_7_21_AP,
            SOL_TRACK_1_1_1_3_7_21,
            SOL_TRACK_1_1_1_3_7_22_AP,
            SOL_TRACK_1_1_1_3_7_22,
            SOL_TRACK_1_1_1_3_7_23_AP,
            SOL_TRACK_1_1_1_3_7_23,
            SOL_TRACK_1_1_1_3_8_1_AP,
            SOL_TRACK_1_1_1_3_8_1,
            SOL_TRACK_1_1_1_3_8_2_AP,
            SOL_TRACK_1_1_1_3_8_2,
            SOL_TRACK_1_1_1_3_9_1_AP,
            SOL_TRACK_1_1_1_3_9_1,
            SOL_TRACK_1_1_1_3_9_2_AP,
            SOL_TRACK_1_1_1_3_9_2,
            SOL_TRACK_1_1_1_3_10_1_AP,
            SOL_TRACK_1_1_1_3_10_1,
            SOL_TRACK_1_1_1_3_10_2_AP,
            SOL_TRACK_1_1_1_3_10_2,
            SOL_TRACK_1_1_1_3_11_1_AP,
            SOL_TRACK_1_1_1_3_11_1,
            SOL_TRACK_1_1_1_3_12_1_AP,
            SOL_TRACK_1_1_1_3_12_1,
            TIPO_BINARIO,
            SEDE_TECNICA,
            CODICE_VERSIONE,
            GRUPPO_AUTORIZZATIVO,
	        SOL_TRACK_1_1_1_1_2_4_1_AP      ,              --  NUOVI PARAMETRI Reg.2019/777
            SOL_TRACK_1_1_1_1_2_4_1         ,
            SOL_TRACK_1_1_1_1_2_4_2_AP      ,
            SOL_TRACK_1_1_1_1_2_4_2         ,
            SOL_TRACK_1_1_1_1_2_4_3_AP      ,
            SOL_TRACK_1_1_1_1_2_4_4_AP      ,
            SOL_TRACK_1_1_1_1_2_4_4         ,
            SOL_TRACK_1_1_1_1_3_1_1_AP      ,
            SOL_TRACK_1_1_1_1_3_1_1_INF     ,
            SOL_TRACK_1_1_1_1_3_1_1_SUP     ,
            SOL_TRACK_1_1_1_1_3_1_2_AP      ,
            SOL_TRACK_1_1_1_1_3_1_2         ,
            SOL_TRACK_1_1_1_1_3_1_3_AP      ,
            SOL_TRACK_1_1_1_1_3_1_3         ,
            SOL_TRACK_1_1_1_1_6_4_AP        ,
            SOL_TRACK_1_1_1_1_6_4           ,
            SOL_TRACK_1_1_1_1_6_5_AP        ,
            SOL_TRACK_1_1_1_1_6_5           ,
            SOL_TRACK_1_1_1_1_7_4_AP        ,
            SOL_TRACK_1_1_1_1_7_4           ,
            SOL_TRACK_1_1_1_1_7_5_AP        ,
            SOL_TRACK_1_1_1_1_7_5           ,
            SOL_TRACK_1_1_1_1_7_6_AP        ,
            SOL_TRACK_1_1_1_1_7_6           ,
            SOL_TRACK_1_1_1_1_7_7_AP        ,
            SOL_TRACK_1_1_1_1_7_7           ,
            SOL_TRACK_1_1_1_1_7_8_AP        ,
            SOL_TRACK_1_1_1_1_7_9_AP        ,
            SOL_TRACK_1_1_1_1_7_9           ,
            SOL_TRACK_1_1_1_2_2_1_2_1_AP    ,
            SOL_TRACK_1_1_1_2_2_1_2_1       ,
            SOL_TRACK_1_1_1_2_2_1_3_AP      ,
            SOL_TRACK_1_1_1_2_2_1_3         ,
            SOL_TRACK_1_1_1_2_4_3_AP        ,
            SOL_TRACK_1_1_1_2_4_3           ,
            SOL_TRACK_1_1_1_3_2_8_AP        ,
            SOL_TRACK_1_1_1_3_2_8           ,
            SOL_TRACK_1_1_1_3_2_9_AP        ,
            SOL_TRACK_1_1_1_3_3_3_2_AP      ,
            SOL_TRACK_1_1_1_3_3_3_2         ,
            SOL_TRACK_1_1_1_3_3_3_3_AP      ,
            SOL_TRACK_1_1_1_3_3_3_3         ,
            SOL_TRACK_1_1_1_3_3_3_1_AP      ,
            SOL_TRACK_1_1_1_3_3_3_1         ,
            SOL_TRACK_1_1_1_3_3_4_AP        ,
            SOL_TRACK_1_1_1_3_3_4           ,
            SOL_TRACK_1_1_1_3_3_5_AP        ,
            SOL_TRACK_1_1_1_3_3_6_AP        ,
            SOL_TRACK_1_1_1_3_3_6           ,
            SOL_TRACK_1_1_1_3_3_7_AP        ,
            SOL_TRACK_1_1_1_3_3_7           ,
            SOL_TRACK_1_1_1_3_3_8_AP        ,
            SOL_TRACK_1_1_1_3_3_8           ,
            SOL_TRACK_1_1_1_3_3_9_AP        ,
            SOL_TRACK_1_1_1_3_3_10_AP       ,
            SOL_TRACK_1_1_1_3_5_3_AP        ,
            SOL_TRACK_1_1_1_3_7_1_2_AP      ,
            SOL_TRACK_1_1_1_3_7_1_2         ,
            SOL_TRACK_1_1_1_3_7_1_3_AP      ,
            SOL_TRACK_1_1_1_3_7_1_4_AP      ,
            SOL_TRACK_1_1_1_3_7_1_4         ,
            SOL_TRACK_1_1_1_3_7_11_1_AP     ,
            SOL_TRACK_1_1_1_3_11_2_AP       ,
            SOL_TRACK_1_1_1_3_11_2          ,
            SOL_TRACK_1_1_1_3_11_3_AP       ,
            SOL_TRACK_1_1_1_3_11_3          ,
            SOL_TRACK_1_1_1_4_1_AP          ,
            SOL_TRACK_1_1_1_4_1             ,
            SOL_TRACK_1_1_1_4_2_AP          ,
            SOL_TRACK_1_1_1_1_3_5_1         ,
            SOL_TRACK_1_1_1_1_3_5_1_AP      ,
            SOL_TRACK_1_1_1_1_7_10_AP       ,
            SOL_TRACK_1_1_1_1_7_10          ,
            SOL_TRACK_1_1_1_1_7_11_AP       ,
            SOL_TRACK_1_1_1_1_7_11          ,
            SOL_TRACK_1_1_1_3_2_10_AP       ,
            SOL_TRACK_1_1_1_3_2_10          ,
            SOL_TRACK_1_1_1_3_7_1_1_AP      ,
            SOL_TRACK_1_1_1_3_7_1_1         ,
            SOL_TRACK_1_1_1_1_2_1_2_AP      ,
            SOL_TRACK_1_1_1_1_2_1_2
			)
    Select 	SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_0_0_1_D,
            SOL_TRACK_1_1_1_0_0_2,
            SOL_TRACK_1_1_1_1_2_1_AP,
--            SOL_TRACK_1_1_1_1_2_1,
            SOL_TRACK_1_1_1_1_2_2_AP,
--            SOL_TRACK_1_1_1_1_2_2,
            SOL_TRACK_1_1_1_1_2_3_AP,
--             SOL_TRACK_1_1_1_1_2_3,
            SOL_TRACK_1_1_1_1_2_4_AP,
--             SOL_TRACK_1_1_1_1_2_4,
            SOL_TRACK_1_1_1_1_2_5_AP,
            SOL_TRACK_1_1_1_1_2_5,
            SOL_TRACK_1_1_1_1_2_6_AP,
            SOL_TRACK_1_1_1_1_2_6,
            SOL_TRACK_1_1_1_1_2_7_AP,
            SOL_TRACK_1_1_1_1_2_7,
            SOL_TRACK_1_1_1_1_2_8_AP,
            SOL_TRACK_1_1_1_1_2_8,
            SOL_TRACK_1_1_1_1_3_1_AP,
            SOL_TRACK_1_1_1_1_3_1,
            SOL_TRACK_1_1_1_1_3_2_AP,
            SOL_TRACK_1_1_1_1_3_2,
            SOL_TRACK_1_1_1_1_3_3_AP,
            SOL_TRACK_1_1_1_1_3_3,
            SOL_TRACK_1_1_1_1_3_4_AP,
--            SOL_TRACK_1_1_1_1_3_4,
            SOL_TRACK_1_1_1_1_3_5_AP,
--            SOL_TRACK_1_1_1_1_3_5,
            SOL_TRACK_1_1_1_1_3_6_AP,
--            SOL_TRACK_1_1_1_1_3_6,
            SOL_TRACK_1_1_1_1_3_7_AP,
            SOL_TRACK_1_1_1_1_3_7,
            SOL_TRACK_1_1_1_1_4_1_AP,
            SOL_TRACK_1_1_1_1_4_1,
            SOL_TRACK_1_1_1_1_4_2_AP,
            SOL_TRACK_1_1_1_1_4_2,
            SOL_TRACK_1_1_1_1_4_3_AP,
            SOL_TRACK_1_1_1_1_4_3,
            SOL_TRACK_1_1_1_1_4_4_AP,
            SOL_TRACK_1_1_1_1_4_4,
            SOL_TRACK_1_1_1_1_5_1_AP,
            SOL_TRACK_1_1_1_1_5_1,
            SOL_TRACK_1_1_1_1_5_2_AP,
            SOL_TRACK_1_1_1_1_5_2,
            SOL_TRACK_1_1_1_1_6_1_AP,
            SOL_TRACK_1_1_1_1_6_1,
            SOL_TRACK_1_1_1_1_6_2_AP,
            SOL_TRACK_1_1_1_1_6_2,
            SOL_TRACK_1_1_1_1_6_3_AP,
            SOL_TRACK_1_1_1_1_6_3,
            SOL_TRACK_1_1_1_1_7_1_AP,
            SOL_TRACK_1_1_1_1_7_1,
            SOL_TRACK_1_1_1_1_7_2_AP,
            SOL_TRACK_1_1_1_1_7_2,
            SOL_TRACK_1_1_1_1_7_3_AP,
            SOL_TRACK_1_1_1_1_7_3,
            SOL_TRACK_1_1_1_2_2_1_1_AP,
            SOL_TRACK_1_1_1_2_2_1_1,
            SOL_TRACK_1_1_1_2_2_1_2_AP,
            SOL_TRACK_1_1_1_2_2_1_2,
            SOL_TRACK_1_1_1_2_2_2_AP,
            SOL_TRACK_1_1_1_2_2_2,
            SOL_TRACK_1_1_1_2_2_3_AP,
            SOL_TRACK_1_1_1_2_2_3,
            SOL_TRACK_1_1_1_2_2_4_AP,
            SOL_TRACK_1_1_1_2_2_4,
            SOL_TRACK_1_1_1_2_2_5_AP,
            SOL_TRACK_1_1_1_2_2_5,
            SOL_TRACK_1_1_1_2_2_6_AP,
            SOL_TRACK_1_1_1_2_2_6,
            SOL_TRACK_1_1_1_2_3_1_AP,
            SOL_TRACK_1_1_1_2_3_1,
            SOL_TRACK_1_1_1_2_3_2_AP,
            SOL_TRACK_1_1_1_2_3_2,
            SOL_TRACK_1_1_1_2_3_3_AP,
            SOL_TRACK_1_1_1_2_3_3_A,
            SOL_TRACK_1_1_1_2_3_3_B,
            SOL_TRACK_1_1_1_2_3_3_C,
            SOL_TRACK_1_1_1_2_3_4_AP,
            SOL_TRACK_1_1_1_2_3_4,
            SOL_TRACK_1_1_1_2_4_1_1_AP,
            SOL_TRACK_1_1_1_2_4_1_1,
            SOL_TRACK_1_1_1_2_4_1_2_AP,
            SOL_TRACK_1_1_1_2_4_1_2_A,
            SOL_TRACK_1_1_1_2_4_1_2_B,
            SOL_TRACK_1_1_1_2_4_1_2_C,
            SOL_TRACK_1_1_1_2_4_2_1_AP,
            SOL_TRACK_1_1_1_2_4_2_1,
            SOL_TRACK_1_1_1_2_4_2_2_AP,
            SOL_TRACK_1_1_1_2_4_2_2_A,
            SOL_TRACK_1_1_1_2_4_2_2_B,
            SOL_TRACK_1_1_1_2_4_2_2_C,
            SOL_TRACK_1_1_1_2_4_2_2_D,
            SOL_TRACK_1_1_1_2_5_1_AP,
            SOL_TRACK_1_1_1_2_5_1,
            SOL_TRACK_1_1_1_2_5_2_AP,
            SOL_TRACK_1_1_1_2_5_2,
            SOL_TRACK_1_1_1_2_5_3_AP,
            SOL_TRACK_1_1_1_2_5_3,
            SOL_TRACK_1_1_1_3_2_1_AP,
            SOL_TRACK_1_1_1_3_2_1,
            SOL_TRACK_1_1_1_3_2_2_AP,
            SOL_TRACK_1_1_1_3_2_2,
            SOL_TRACK_1_1_1_3_2_3_AP,
            SOL_TRACK_1_1_1_3_2_3,
            SOL_TRACK_1_1_1_3_2_4_AP,
            SOL_TRACK_1_1_1_3_2_4,
            SOL_TRACK_1_1_1_3_2_5_AP,
            SOL_TRACK_1_1_1_3_2_5,
            SOL_TRACK_1_1_1_3_2_6_AP,
            SOL_TRACK_1_1_1_3_2_6,
            SOL_TRACK_1_1_1_3_2_7_AP,
            SOL_TRACK_1_1_1_3_2_7,
            SOL_TRACK_1_1_1_3_3_1_AP,
            SOL_TRACK_1_1_1_3_3_1,
            SOL_TRACK_1_1_1_3_3_2_AP,
            SOL_TRACK_1_1_1_3_3_2,
            SOL_TRACK_1_1_1_3_3_3_AP,
--            SOL_TRACK_1_1_1_3_3_3,
            SOL_TRACK_1_1_1_3_4_1_AP,
            SOL_TRACK_1_1_1_3_4_1,
            SOL_TRACK_1_1_1_3_5_1_AP,
            SOL_TRACK_1_1_1_3_5_1,
            SOL_TRACK_1_1_1_3_5_2_AP,
            SOL_TRACK_1_1_1_3_5_2,
            SOL_TRACK_1_1_1_3_6_1_AP,
            SOL_TRACK_1_1_1_3_6_1,
            SOL_TRACK_1_1_1_3_7_1_AP,
            SOL_TRACK_1_1_1_3_7_1,
            SOL_TRACK_1_1_1_3_7_2_1_AP,
            SOL_TRACK_1_1_1_3_7_2_1,
            SOL_TRACK_1_1_1_3_7_2_2_AP,
            SOL_TRACK_1_1_1_3_7_2_2,
            SOL_TRACK_1_1_1_3_7_3_AP,
            SOL_TRACK_1_1_1_3_7_3,
            SOL_TRACK_1_1_1_3_7_4_AP,
            SOL_TRACK_1_1_1_3_7_4,
            SOL_TRACK_1_1_1_3_7_5_AP,
            SOL_TRACK_1_1_1_3_7_5,
            SOL_TRACK_1_1_1_3_7_6_AP,
            SOL_TRACK_1_1_1_3_7_6,
            SOL_TRACK_1_1_1_3_7_7_AP,
            SOL_TRACK_1_1_1_3_7_7,
            SOL_TRACK_1_1_1_3_7_8_AP,
            SOL_TRACK_1_1_1_3_7_8,
            SOL_TRACK_1_1_1_3_7_9_AP,
            SOL_TRACK_1_1_1_3_7_9,
            SOL_TRACK_1_1_1_3_7_10_AP,
            SOL_TRACK_1_1_1_3_7_10,
            SOL_TRACK_1_1_1_3_7_11_AP,
            SOL_TRACK_1_1_1_3_7_11,
            SOL_TRACK_1_1_1_3_7_12_AP,
            SOL_TRACK_1_1_1_3_7_12,
            SOL_TRACK_1_1_1_3_7_13_AP,
            SOL_TRACK_1_1_1_3_7_13,
            SOL_TRACK_1_1_1_3_7_14_AP,
            SOL_TRACK_1_1_1_3_7_14,
            SOL_TRACK_1_1_1_3_7_15_1_AP,
            SOL_TRACK_1_1_1_3_7_15_1,
            SOL_TRACK_1_1_1_3_7_15_2_AP,
            SOL_TRACK_1_1_1_3_7_15_2,
            SOL_TRACK_1_1_1_3_7_16_AP,
            SOL_TRACK_1_1_1_3_7_16,
            SOL_TRACK_1_1_1_3_7_17_AP,
            SOL_TRACK_1_1_1_3_7_17,
            SOL_TRACK_1_1_1_3_7_18_AP,
            SOL_TRACK_1_1_1_3_7_18,
            SOL_TRACK_1_1_1_3_7_19_AP,
            SOL_TRACK_1_1_1_3_7_19,
            SOL_TRACK_1_1_1_3_7_20_AP,
            SOL_TRACK_1_1_1_3_7_20,
            SOL_TRACK_1_1_1_3_7_21_AP,
            SOL_TRACK_1_1_1_3_7_21,
            SOL_TRACK_1_1_1_3_7_22_AP,
            SOL_TRACK_1_1_1_3_7_22,
            SOL_TRACK_1_1_1_3_7_23_AP,
            SOL_TRACK_1_1_1_3_7_23,
            SOL_TRACK_1_1_1_3_8_1_AP,
            SOL_TRACK_1_1_1_3_8_1,
            SOL_TRACK_1_1_1_3_8_2_AP,
            SOL_TRACK_1_1_1_3_8_2,
            SOL_TRACK_1_1_1_3_9_1_AP,
            SOL_TRACK_1_1_1_3_9_1,
            SOL_TRACK_1_1_1_3_9_2_AP,
            SOL_TRACK_1_1_1_3_9_2,
            SOL_TRACK_1_1_1_3_10_1_AP,
            SOL_TRACK_1_1_1_3_10_1,
            SOL_TRACK_1_1_1_3_10_2_AP,
            SOL_TRACK_1_1_1_3_10_2,
            SOL_TRACK_1_1_1_3_11_1_AP,
            SOL_TRACK_1_1_1_3_11_1,
            SOL_TRACK_1_1_1_3_12_1_AP,
            SOL_TRACK_1_1_1_3_12_1,
            TIPO_BINARIO,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE,
            GRUPPO_AUTORIZZATIVO,
	        SOL_TRACK_1_1_1_1_2_4_1_AP      ,              --  NUOVI PARAMETRI Reg.2019/777
            SOL_TRACK_1_1_1_1_2_4_1         ,
            SOL_TRACK_1_1_1_1_2_4_2_AP      ,
            SOL_TRACK_1_1_1_1_2_4_2         ,
            SOL_TRACK_1_1_1_1_2_4_3_AP      ,
            SOL_TRACK_1_1_1_1_2_4_4_AP      ,
            SOL_TRACK_1_1_1_1_2_4_4         ,
            SOL_TRACK_1_1_1_1_3_1_1_AP      ,
            SOL_TRACK_1_1_1_1_3_1_1_INF     ,
            SOL_TRACK_1_1_1_1_3_1_1_SUP     ,
            SOL_TRACK_1_1_1_1_3_1_2_AP      ,
            SOL_TRACK_1_1_1_1_3_1_2         ,
            SOL_TRACK_1_1_1_1_3_1_3_AP      ,
            SOL_TRACK_1_1_1_1_3_1_3         ,
            SOL_TRACK_1_1_1_1_6_4_AP        ,
            SOL_TRACK_1_1_1_1_6_4           ,
            SOL_TRACK_1_1_1_1_6_5_AP        ,
            SOL_TRACK_1_1_1_1_6_5           ,
            SOL_TRACK_1_1_1_1_7_4_AP        ,
            SOL_TRACK_1_1_1_1_7_4           ,
            SOL_TRACK_1_1_1_1_7_5_AP        ,
            SOL_TRACK_1_1_1_1_7_5           ,
            SOL_TRACK_1_1_1_1_7_6_AP        ,
            SOL_TRACK_1_1_1_1_7_6           ,
            SOL_TRACK_1_1_1_1_7_7_AP        ,
            SOL_TRACK_1_1_1_1_7_7           ,
            SOL_TRACK_1_1_1_1_7_8_AP        ,
            SOL_TRACK_1_1_1_1_7_9_AP        ,
            SOL_TRACK_1_1_1_1_7_9           ,
            SOL_TRACK_1_1_1_2_2_1_2_1_AP    ,
            SOL_TRACK_1_1_1_2_2_1_2_1       ,
            SOL_TRACK_1_1_1_2_2_1_3_AP      ,
            SOL_TRACK_1_1_1_2_2_1_3         ,
            SOL_TRACK_1_1_1_2_4_3_AP        ,
            SOL_TRACK_1_1_1_2_4_3           ,
            SOL_TRACK_1_1_1_3_2_8_AP        ,
            SOL_TRACK_1_1_1_3_2_8           ,
            SOL_TRACK_1_1_1_3_2_9_AP        ,
            SOL_TRACK_1_1_1_3_3_3_2_AP      ,
            SOL_TRACK_1_1_1_3_3_3_2         ,
            SOL_TRACK_1_1_1_3_3_3_3_AP      ,
            SOL_TRACK_1_1_1_3_3_3_3         ,
            SOL_TRACK_1_1_1_3_3_3_1_AP      ,
            SOL_TRACK_1_1_1_3_3_3_1         ,
            SOL_TRACK_1_1_1_3_3_4_AP        ,
            SOL_TRACK_1_1_1_3_3_4           ,
            SOL_TRACK_1_1_1_3_3_5_AP        ,
            SOL_TRACK_1_1_1_3_3_6_AP        ,
            SOL_TRACK_1_1_1_3_3_6           ,
            SOL_TRACK_1_1_1_3_3_7_AP        ,
            SOL_TRACK_1_1_1_3_3_7           ,
            SOL_TRACK_1_1_1_3_3_8_AP        ,
            SOL_TRACK_1_1_1_3_3_8           ,
            SOL_TRACK_1_1_1_3_3_9_AP        ,
            SOL_TRACK_1_1_1_3_3_10_AP       ,
            SOL_TRACK_1_1_1_3_5_3_AP        ,
            SOL_TRACK_1_1_1_3_7_1_2_AP      ,
            SOL_TRACK_1_1_1_3_7_1_2         ,
            SOL_TRACK_1_1_1_3_7_1_3_AP      ,
            SOL_TRACK_1_1_1_3_7_1_4_AP      ,
            SOL_TRACK_1_1_1_3_7_1_4         ,
            SOL_TRACK_1_1_1_3_7_11_1_AP     ,
            SOL_TRACK_1_1_1_3_11_2_AP       ,
            SOL_TRACK_1_1_1_3_11_2          ,
            SOL_TRACK_1_1_1_3_11_3_AP       ,
            SOL_TRACK_1_1_1_3_11_3          ,
            SOL_TRACK_1_1_1_4_1_AP          ,
            SOL_TRACK_1_1_1_4_1             ,
            SOL_TRACK_1_1_1_4_2_AP          ,
            SOL_TRACK_1_1_1_1_3_5_1         ,
            SOL_TRACK_1_1_1_1_3_5_1_AP      ,
            SOL_TRACK_1_1_1_1_7_10_AP       ,
            SOL_TRACK_1_1_1_1_7_10          ,
            SOL_TRACK_1_1_1_1_7_11_AP       ,
            SOL_TRACK_1_1_1_1_7_11          ,
            SOL_TRACK_1_1_1_3_2_10_AP       ,
            SOL_TRACK_1_1_1_3_2_10          ,
            SOL_TRACK_1_1_1_3_7_1_1_AP      ,
            SOL_TRACK_1_1_1_3_7_1_1         ,
            SOL_TRACK_1_1_1_1_2_1_2_AP      ,
            SOL_TRACK_1_1_1_1_2_1_2		
	   From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL p ,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where p.SEDE_TECNICA = v.SEDE_TECNICA
		And p.SEDE_TECNICA = p_SEDE_TECNICA 
		And v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9 ;
--
  DBMS_OUTPUT.PUT_LINE('BINARI_CORSA_SOL "L" record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
--
  Exception
      When OTHERS Then
 		p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert BINARI_CORSA_SOL "L" - Errore: '|| Substr(SQLERRM, 1, 300));
  End;
--
--
   Else
	     DBMS_OUTPUT.PUT_LINE('BINARI_CORSA_SOL - Tipo Linea non previsto per '||p_SEDE_TECNICA);   
   End if;
--
--
-- --------------------------------------------------------------------------------------
--  gestione parametri per binari tipo Regular 
-- --------------------------------------------------------------------------------------

    If Tipo_Linea = 'R' Then	
--
-- --------------------------------------------------------------------------------------
-- PAR_1_1_1_1_2_1_CAT_TEN_SOL
-- --------------------------------------------------------------------------------------
--
  Begin 

    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL (
	            SOL_TRACK_1_1_1_0_0_1,
                SOL_TRACK_1_1_1_1_2_1,
                KM_INIZIO,
                KM_FINE,
                CODICE_VERSIONE)
     Select     p.SOL_TRACK_1_1_1_0_0_1,
                SOL_TRACK_1_1_1_1_2_1,
                KM_INIZIO,
                KM_FINE,
				p_versione
   	   From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL p ,
	        Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b ,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where p.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
		And b.SEDE_TECNICA = v.SEDE_TECNICA
		And b.SEDE_TECNICA = p_SEDE_TECNICA 
	    And v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9 
		And v.FLAG_DSPS = 1 ;
--
  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_1_2_1_CAT_TEN_SOL record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
--
  Exception
      When OTHERS Then
 		p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_1_2_1_CAT_TEN_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
  End;
--
-- --------------------------------------------------------------------------------------
-- PAR_1_1_1_4_2_NORME_DOC
-- --------------------------------------------------------------------------------------
--
  Begin 
--
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_4_2_NORME_DOC (
	            SOL_TRACK_1_1_1_0_0_1,
                SOL_TRACK_1_1_1_4_2,
                CODICE_VERSIONE,
                KM_INIZIO,
                KM_FINE,
                LATITUDINE_INIZIO,
                LONGITUDINE_INIZIO,
                ALTITUDINE_INIZIO,
                LATITUDINE_FINE,
                LONGITUDINE_FINE,
                ALTITUDINE_FINE,
                FLAG_CALCOLATO)
   Select 	    p.SOL_TRACK_1_1_1_0_0_1,
                SOL_TRACK_1_1_1_4_2,
                p_versione,
                KM_INIZIO,
                KM_FINE,
                LATITUDINE_INIZIO,
                LONGITUDINE_INIZIO,
                ALTITUDINE_INIZIO,
                LATITUDINE_FINE,
                LONGITUDINE_FINE,
                ALTITUDINE_FINE,
                FLAG_CALCOLATO
   	   From Rinf_Autorizzazioni_Evo.PAR_1_1_1_4_2_NORME_DOC p ,
	        Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b ,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where p.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
		And b.SEDE_TECNICA = v.SEDE_TECNICA
		And b.SEDE_TECNICA = p_SEDE_TECNICA 
	    And v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 9 ;
--
  DBMS_OUTPUT.PUT_LINE('PAR_1_1_1_4_2_NORME_DOC record inseriti ' || SQL%ROWCOUNT || ' di '||p_SEDE_TECNICA);
--
  Exception
      When OTHERS Then
 		p_error := SQLCODE;
        Dbms_Output.Put_Line ('Insert PAR_1_1_1_4_2_NORME_DOC - Errore: '|| Substr(SQLERRM, 1, 300));
  End;
--
--
-- --------------------------------------------------------------------------------------
--           Gestione Binari di tipo Link
-- --------------------------------------------------------------------------------------
--
    ElsIf Tipo_Linea = 'L' Then	
--
-- DICHIARAZIONI_BINARIO_SOL_INF 
        Begin 
           Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF 
	            ( SOL_TRACK_1_1_1_0_0_1,
                  TIPO_DICHIARAZIONE,
                  SOL_TRACK_1_1_1_1_1_1O2_AP,
                  SOL_TRACK_1_1_1_1_1_1O2,
                  KM_INIZIO,
                  KM_FINE,
				  CODICE_VERSIONE, 
                  LATITUDINE_INIZIO,
                  LONGITUDINE_INIZIO,
				  ALTITUDINE_INIZIO,
                  LATITUDINE_FINE,
                  LONGITUDINE_FINE,
				  ALTITUDINE_FINE,
                  FLAG_CALCOLATO )
           Select d.SOL_TRACK_1_1_1_0_0_1,
                  TIPO_DICHIARAZIONE,
                  SOL_TRACK_1_1_1_1_1_1O2_AP,
                  SOL_TRACK_1_1_1_1_1_1O2,
                  KM_INIZIO,
                  KM_FINE,
				  p_versione, 
                  LATITUDINE_INIZIO,
                  LONGITUDINE_INIZIO,
				  ALTITUDINE_INIZIO,
                  LATITUDINE_FINE,
                  LONGITUDINE_FINE,
				  ALTITUDINE_FINE,
                  FLAG_CALCOLATO
             From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_SOL_INF d,
			      Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b,
                  Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
            Where d.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 
		      And b.SEDE_TECNICA = v.SEDE_TECNICA
		      And b.SEDE_TECNICA = p_SEDE_TECNICA 
	          And v.CODICE_VERSIONE = p_versione 
		      And v.FLAG_NEW = 9;
--
        Exception
           When Others Then
                 Dbms_Output.Put_Line ('Errore inserimento Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF: ' || Substr (Sqlerrm, 1, 300));
        End;
--
-- --------------------------------------------------------------------------------------
-- DICHIARAZIONI_BINARIO_SOL_ENE
-- --------------------------------------------------------------------------------------
--
        Begin 
           Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE 
                ( SOL_TRACK_1_1_1_0_0_1,
                  TIPO_DICHIARAZIONE,
                  SOL_TRACK_1_1_1_2_1_1O2_AP,
                  SOL_TRACK_1_1_1_2_1_1O2,
                  KM_INIZIO,
                  KM_FINE,
				  CODICE_VERSIONE, 
                  LATITUDINE_INIZIO,
                  LONGITUDINE_INIZIO,
				  ALTITUDINE_INIZIO,
                  LATITUDINE_FINE,
                  LONGITUDINE_FINE,
				  ALTITUDINE_FINE,
                  FLAG_CALCOLATO )
           Select d.SOL_TRACK_1_1_1_0_0_1,
                  TIPO_DICHIARAZIONE,
                  SOL_TRACK_1_1_1_2_1_1O2_AP,
                  SOL_TRACK_1_1_1_2_1_1O2,
                  KM_INIZIO,
                  KM_FINE,
				  p_versione, 
                  LATITUDINE_INIZIO,
                  LONGITUDINE_INIZIO,
				  ALTITUDINE_INIZIO,
                  LATITUDINE_FINE,
                  LONGITUDINE_FINE,
				  ALTITUDINE_FINE,
                  FLAG_CALCOLATO
             From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_SOL_ENE d,
			      Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b,
                  Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
            Where d.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 
		      And b.SEDE_TECNICA = v.SEDE_TECNICA
		      And b.SEDE_TECNICA = p_SEDE_TECNICA 
	          And v.CODICE_VERSIONE = p_versione 
		      And v.FLAG_NEW = 9 ;
--
        Exception
           When Others Then
                 Dbms_Output.Put_Line ('Errore inserimento Rinf_Controllati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE: ' || Substr (Sqlerrm, 1, 300));
        End;
--
-- --------------------------------------------------------------------------------------
-- DICHIARAZIONI_BINARIO_SOL_CCS
-- --------------------------------------------------------------------------------------
        Begin 
           Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_CCS 
                ( SOL_TRACK_1_1_1_0_0_1,
                  TIPO_DICHIARAZIONE,
                  SOL_TRACK_1_1_1_3_1_1_AP,
                  SOL_TRACK_1_1_1_3_1_1,
                  KM_INIZIO,
                  KM_FINE,
				  CODICE_VERSIONE, 
                  LATITUDINE_INIZIO,
                  LONGITUDINE_INIZIO,
				  ALTITUDINE_INIZIO,
                  LATITUDINE_FINE,
                  LONGITUDINE_FINE,
				  ALTITUDINE_FINE,
                  FLAG_CALCOLATO )
           Select d.SOL_TRACK_1_1_1_0_0_1,
                  TIPO_DICHIARAZIONE,
                  SOL_TRACK_1_1_1_3_1_1_AP,
                  SOL_TRACK_1_1_1_3_1_1,
                  KM_INIZIO,
                  KM_FINE,
				  p_versione, 
                  LATITUDINE_INIZIO,
                  LONGITUDINE_INIZIO,
				  ALTITUDINE_INIZIO,
                  LATITUDINE_FINE,
                  LONGITUDINE_FINE,
				  ALTITUDINE_FINE,
                  FLAG_CALCOLATO
             From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_SOL_CCS d,
			      Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b,
                  Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
            Where d.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 
		      And b.SEDE_TECNICA = v.SEDE_TECNICA
		      And b.SEDE_TECNICA = p_SEDE_TECNICA 
	          And v.CODICE_VERSIONE = p_versione 
		      And v.FLAG_NEW = 9 ;
--
        Exception
           When Others Then
                 Dbms_Output.Put_Line ('Errore inserimento Rinf_Controllati_Evo.DICHIARAZIONI_BINARIO_SOL_CCS (EC) : ' || Substr (Sqlerrm, 1, 300));
        End;

-- ----------------------------------------------------------------------------------------------------

    Else
	  	     DBMS_OUTPUT.PUT_LINE('Set_Skeleton_SOL - Tipo Linea non trovato per '||p_SEDE_TECNICA);   
	End If;
--	
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        Dbms_Output.Put_Line ('Set_Skeleton_SOL - Errore: '|| Substr(SQLERRM, 1, 300));
  END Set_Skeleton_SOL;


-- ----------------------------

 END PKG_RINF_PAR_SC_AUTORIZZAZIONI;
/