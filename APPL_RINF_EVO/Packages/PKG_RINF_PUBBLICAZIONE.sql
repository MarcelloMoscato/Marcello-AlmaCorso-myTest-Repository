--
-- PKG_RINF_PUBBLICAZIONE  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_PUBBLICAZIONE" 
Is
/*******************************************************************************
    NAME:    PKG_RINF_PUBBLICAZIONE
    PURPOSE: Insieme di procedure per la predisposizione e l'esecuzione delle funzioni di Pubblicazione
    REVISIONS:
    Version    Date          Author          Description
    --------   ------------  --------------  --------------------------------------------------
    11.0.1.2   00/02/2025    L. Cilento      1(ADD): GetMailServerAddress per determinare il Mail Server Address
                                             2(ADD): SetMailServerAddress per aggiornare il Mail Server Address da interfaccia WEB
*******************************************************************************/
-- -----------------------------------------------------------------------------
    Type empcur Is Ref CURSOR;
    Function GetCountObjectNYA (p_tabella In Varchar2, p_versione In Number) Return Number;
    Function GetCountParameterNYA (p_tabella In Varchar2, p_versione In Number) Return Number;
--  modificata per la nuova versione RI-Pronti
    Procedure SetNewRinfVersion(p_codice_autorizzazione Number, p_error Out Number);
--
    Procedure GetAllRIPronti (p_cursor Out empcur);
    Procedure GetAllProtocols (p_cursor Out empcur);
    Procedure GetAllRIInviati (p_cursor Out empcur);
    Procedure SetSendRI (p_codice_versione Number, p_protocollo Varchar2, p_ftp Varchar2, p_destinatario Varchar2, p_note Varchar2, p_millisecondi Number, p_error Out Number);
    Procedure GetRapportoInviiRI (p_codice_versione Number, p_cursor Out empcur);
    Procedure GetFTPAddress (p_cursor Out empcur);
--  11.0.1.2  -------------------------------------------------------------------
    Procedure GetMailServerAddress (p_cursor Out empcur);
    Procedure SetMailServerAddress (p_indirizzo IN DOCS_RINF_EVO.MAILSERVER_ADDRESS.NAME_MAIN%TYPE, p_alias IN DOCS_RINF_EVO.MAILSERVER_ADDRESS.NAME_ALT%TYPE, p_service IN DOCS_RINF_EVO.MAILSERVER_ADDRESS.NAME_SMTP%TYPE, p_port IN DOCS_RINF_EVO.MAILSERVER_ADDRESS.PORT%TYPE, p_errorcode OUT NUMBER);   
-- -----------------------------------------------------------------------------   
    Procedure GetRIFile (p_codice_versione   In Number, p_estensione_file In  Varchar2, p_cursor Out empcur);
    Procedure GetRIExist (p_codice_versione   In Number, p_estensione_file In  Varchar2, p_cursor Out empcur);
    Procedure GetRIReport (p_codice_versione  In Number, p_cursor Out empcur);
    Procedure GetRIVersion (p_cursor  Out empcur);
    Procedure GetRIMetadata (p_codice_area In Number, p_codice_versione   In     Number, p_cursor Out empcur);
    Procedure GetRIReportPag2 (p_codice_versione In Number, p_cursor Out empcur);
    Procedure GetRIReportPag3 (p_codice_versione In Number, p_cursor Out empcur);
    Procedure SetDownLoadRI (p_codice_versione Number, p_protocollo Varchar2, p_ftp Varchar2, p_utente Varchar2, p_nome_file Varchar2, p_data_trasmissione DATE, p_esito Number, p_error Out Number);
    Procedure GetDownLoadRI (p_cursor  Out empcur);
    Procedure GetRISent(p_versione Varchar2, p_cursor Out empcur);
 -- modificata per la nuova versione RI-Pronti
    Procedure SetPubblicationDetail (n_versione Number, p_codice_autorizzazione Number, p_error Out Number);
--
    Procedure SetSOLTunnelNew (p_versione Number, p_error Out Number);
    Procedure SetSOLCATTENNew (p_versione Number, p_error Out Number);
    Procedure SetSOLCATLINEANew (p_versione Number, p_error Out Number);
    Procedure SetSOLCATCARICONew (p_versione Number, p_error Out Number);
    Procedure SetSOLPROFCASSEMNew (p_versione Number, p_error Out Number);
    Procedure SetOPNew (p_versione Number, p_error  Out Number);
    Procedure SetSOLNew (p_versione Number, p_error Out Number);
    Procedure SetOPTAFTAPNew (p_versione Number, p_error Out Number);
    Procedure SetOPTrackNew (p_versione Number, p_error     Out Number);
    Procedure SetOPTunnelNew (p_versione Number, p_error     Out Number);
    Procedure SetOPTunnelSDNew (p_versione Number, p_error Out Number);
    Procedure SetPOCATTENNew (p_versione Number, p_error Out Number);
    Procedure SetPOCATLINEANew (p_versione Number, p_error Out Number);
    Procedure SetPLATCATTENNew (p_versione Number, p_error Out Number);
    Procedure SetOPPlatformNew (p_versione Number, p_error Out Number);
    Procedure SetOPSidingNew (p_versione Number, p_error Out Number);
    Procedure SetOPLineNew (p_versione Number, p_error Out Number);
    Procedure SetSOLTrackNew (p_versione Number, p_error Out Number);
    Procedure SetSOLTrackDecNew(p_versione Number, p_error Out Number);
    Procedure SetPO_NORMEDOC_New (p_versione Number, p_error Out Number);
    Procedure SetSDCATTENNew (p_versione Number, p_error Out Number);
    Procedure SetSOLPROFSEMIRIMNew (p_versione Number, p_error Out Number);
    Procedure SetSOLGRADIENTENew (p_versione Number, p_error Out Number);
    Procedure SetSOLGSMRFACNew (p_versione Number, p_error Out Number);
    Procedure SetSOL_LOCAVERSPEC_New (p_versione Number, p_error Out Number);
    Procedure SetSOL_LOCASISTRTB_New (p_versione Number, p_error Out Number);
    Procedure SetSOL_COMPETCS_New (p_versione Number, p_error Out Number);
    Procedure SetSOL_RETIGSM_New (p_versione Number, p_error Out Number);
    Procedure SetSOL_COMPRADIOVOCE_New (p_versione Number, p_error Out Number);
    Procedure SetSOL_COMPRADIODATI_New (p_versione Number, p_error Out Number);
    Procedure SetSOL_SISTPREPROT_New (p_versione Number, p_error Out Number);
    Procedure SetSOL_SISRILDOC_New  (p_versione Number, p_error Out Number);
    Procedure SetSOL_CARMINASSE_New (p_versione Number, p_error Out Number);
    Procedure SetSOL_NORMEDOC_New (p_versione Number, p_error Out Number);
    Procedure SetSOLLineNew (p_versione Number, p_error Out Number);
--
--  Gestione file PDF e XML dei raccordi del 12/09/2018
    Procedure SetPubblicaRI (p_codice_versione Number, p_formato_pubblica Number, p_error Out Number);
    Procedure SetAbilitaRI (p_pubblicazione Number, p_error Out Number);
--  Procedure GetAbilitaRI (p_pubblicazione Out Number);
    Procedure GetAbilitaRI (p_cursor  Out empcur);
--
--  Nuovo Rapporto di Sintesi  Mail Schillaci del 25/05/2018 11:07
    Procedure GetRIReportInt_NEW (p_codice_versione In  Number, p_cursor Out empcur);
    Procedure GetRIReport_NEW (p_codice_versione In  Number, p_cursor Out empcur);
    Procedure GetRIReportPag2_NEW (p_codice_versione In Number, p_cursor Out empcur);
    Procedure GetRIReportPag3_NEW (p_codice_versione In Number, p_cursor Out empcur);
    Procedure GetRIReportPag4_NEW (p_versione Number , p_cursor Out sys_refcursor);
--
--  Gestione autorizzazioni di sede Centrale (Nuovo)
    Procedure Set_Autorizzazioni_SC (V_Codice_Versione Number, V_Codice_Richiesta Number, V_codice_dtp varchar2, v_tipo_depositario Number, p_error_split Out Number);
    Procedure Set_Aggiorna_SC (V_Codice_Versione Varchar2, V_CODICE_DTP varchar2, V_cod_tipo_dep Number, p_error_split Out Number);
--
END PKG_RINF_PUBBLICAZIONE;
/


--
-- PKG_RINF_PUBBLICAZIONE  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_PUBBLICAZIONE" Is

/*************************************************************************************************/

--
-- -----------------------------------------------------------------------------
--                           Function GetCountObjectNYA 27/11/2017
-- procedura che riceve in input il nome della tabella ed il numero di versione, 
-- si costruisce dinamicamente la Where per contare il numero di oggetti che hanno almeno un parametro a NYA
-- -----------------------------------------------------------------------------
--
 Function GetCountObjectNYA (p_tabella In Varchar2, p_versione In Number)
   Return Number Is
        i                         Number;
        sqlstringa                Varchar2 (30000);
        sqlstringa_Where          Varchar2 (30000);
        Type column_t Is Table Of Varchar2 (1000);
        l_column      column_t;
--
  Begin
    Select column_name  colonna
      Bulk Collect Into l_column
      From ALL_TAB_COLUMNS
     Where OWNER = 'RINF_PUBBLICATI_EVO'
       And TABLE_NAME = p_tabella
       And COLUMN_NAME Like '%\_AP' ESCAPE '\';
--'
    sqlstringa_Where := ' ( ';
--
    For i In 1 .. l_column.Count   Loop
         sqlstringa_Where := sqlstringa_Where || ' ' || l_column (i) || '=''NYA'' OR';
    End Loop;
--
-- elimino l'ultimo Or e inserisco la parentesi di chiusura
    sqlstringa_Where := Substr (sqlstringa_Where, 1, Length (sqlstringa_Where) - 3) || ' ) ';
--
    sqlstringa:='Select Count(*) tot From Rinf_Pubblicati_Evo.'||p_tabella;
---->    sqlstringa:=sqlstringa||' Where CODICE_VERSIONE='||p_versione||' And ';
    sqlstringa:=sqlstringa||' Where CODICE_VERSIONE = 93 And ';
    sqlstringa:=sqlstringa||sqlstringa_Where;
--
    Execute Immediate sqlstringa Into i;
--
    Return i;
--
 End GetCountObjectNYA;
--
-- -----------------------------------------------------------------------------
--                  Function GetCountParameterNYA  27/11/2017
-- procedura che riceve In input il nome della tabella ed il numero di versione, si costruisce dinamicamente
-- il campo per contare il numero di occorrenze NYA per tutti i parametri della tabella
-- -----------------------------------------------------------------------------
--
 Function GetCountParameterNYA (p_tabella In Varchar2, p_versione In Number)
   Return Number Is
        i                         Number;
        sqlstringa                Varchar2 (30000);
        sqlstringa_campo          Varchar2 (30000);
        Type column_t Is Table Of Varchar2 (1000);
        l_column    column_t;
 Begin
    If p_tabella <> 'MARCIAPIEDI_BINARI_PO'  Then
         Select column_name colonna
           Bulk Collect Into l_column
           From ALL_TAB_COLUMNS
          Where OWNER = 'RINF_PUBBLICATI_EVO'
            And TABLE_NAME = p_tabella
            And COLUMN_NAME Like '%\_AP' ESCAPE '\';
--'
         sqlstringa_campo := ' SUM( ';

         For i In 1 .. l_column.Count Loop
            sqlstringa_campo := sqlstringa_campo || ' DECODE('|| l_column (i) || ',''NYA'', 1, 0) +';
         End Loop;
--
-- elimino l'ultimo + e inserisco la parentesi di chiusura
         sqlstringa_campo := Substr(sqlstringa_campo, 1, Length(sqlstringa_campo) - 2) || ' ) ';
--       
         sqlstringa := 'Select ' || sqlstringa_campo || ' tot From Rinf_Pubblicati_Evo.' || p_tabella;
         sqlstringa := sqlstringa || ' Where CODICE_VERSIONE =' || p_versione;
--
         Execute Immediate sqlstringa Into i;
--
    Else
         Select SUM (
                  Decode(PO_TR_PLATFORM_1_2_1_0_6_3_AP, 'NYA', 1, 0)
                + Decode(PO_TR_PLATFORM_1_2_1_0_6_6_AP, 'NYA', 1, 0)
                + Decode(PO_TR_PLATFORM_1_2_1_0_6_7,    'NYA', 1, 0)
                + Decode(PO_TR_PLAT_1_2_1_0_6_4_B1_AP,  'NYA', 1, 0)
                - Decode(BINARIO_1, Null, 1, 0)
                + Decode(PO_TR_PLAT_1_2_1_0_6_4_B2_AP,  'NYA', 1, 0)
                - Decode(BINARIO_2, Null, 1, 0)
                + Decode(PO_TR_PLAT_1_2_1_0_6_4_B3_AP,  'NYA', 1, 0)
                - Decode(BINARIO_3, Null, 1, 0)
                + Decode(PO_TR_PLAT_1_2_1_0_6_4_B4_AP,  'NYA', 1, 0)
                - Decode(BINARIO_4, Null, 1, 0)
                + Decode(PO_TR_PLAT_1_2_1_0_6_5_B1_AP,  'NYA', 1, 0)
                - Decode(BINARIO_1, Null, 1, 0)
                + Decode(PO_TR_PLAT_1_2_1_0_6_5_B2_AP,  'NYA', 1, 0)
                - Decode(BINARIO_2, Null, 1, 0)
                + Decode(PO_TR_PLAT_1_2_1_0_6_5_B3_AP,  'NYA', 1, 0)
                - Decode(BINARIO_3, Null, 1, 0)
                + Decode(PO_TR_PLAT_1_2_1_0_6_5_B4_AP,  'NYA', 1, 0)
                - Decode(BINARIO_4, Null, 1, 0))
         Into i
         From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO
        Where CODICE_VERSIONE = p_versione;
   End If;
--
   Return i;
END GetCountParameterNYA;
--
-- -----------------------------------------------------------------------------
--  PROCEDURE PER IL TRASFERIMENTO DATI DALLO SCHEMA AUTORIZZAZIONI A PUBBLICAZIONE
-- -----------------------------------------------------------------------------
--                  Procedure SetOPNew (PUNTI_OPERATIVI)
-- -----------------------------------------------------------------------------
--
 Procedure SetOPNew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--OP nuove
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
                v.CODICE_VERSIONE,
                TIPO_LOCALITA_CONFINE,
                GRUPPO_AUTORIZZATIVO,
                Null CACHE_FIELD,
			    PO_1_2_0_0_0_4_1_AP,
                PO_1_2_0_0_0_4_1,
                PO_1_2_3_1_AP,
                PO_1_2_3_1,
                PO_1_2_3_2_AP
           From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI p,
                Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
          Where v.CODICE_VERSIONE = p_versione 
		    And v.FLAG_NEW = 1 
			And p.SEDE_TECNICA = v.SEDE_TECNICA;
--
--  OP versione precedente
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
                 v.CODICE_VERSIONE,
                 TIPO_LOCALITA_CONFINE,
                 GRUPPO_AUTORIZZATIVO,
                 Null CACHE_FIELD,
		   	     PO_1_2_0_0_0_4_1_AP,
                 PO_1_2_0_0_0_4_1,
                 PO_1_2_3_1_AP,
                 PO_1_2_3_1,
                 PO_1_2_3_2_AP
            From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI p,
                 Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
           Where v.CODICE_VERSIONE = p_versione 
		     And v.FLAG_NEW = 0 
			 And p.SEDE_TECNICA = v.SEDE_TECNICA 
			 And p.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
    When OTHERS  Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetOPNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetOPNew - Errore: '|| Substr(SQLERRM, 1, 300));
   END SetOPNew;
--
-- -----------------------------------------------------------------------------
--                Procedure SetOPTAFTAPNew  (PAR_1_2_0_0_0_3_TAF_TAP)
-- -----------------------------------------------------------------------------
--
 Procedure SetOPTAFTAPNew (p_versione Number, p_error Out Number) Is
   Begin
     p_error := 0;
--
--  TAF/TAP PO Nuovi
      Insert Into Rinf_Pubblicati_Evo.PAR_1_2_0_0_0_3_TAF_TAP
        (    SEDE_TECNICA,
             PO_1_2_0_0_0_3,
             KM_INIZIO,
             KM_FINE,
             CODICE_VERSIONE   )
         Select Distinct
             bg.SEDE_TECNICA,
             PO_1_2_0_0_0_3,
             KM_INIZIO,
             KM_FINE,
             v.CODICE_VERSIONE
        From Rinf_Autorizzazioni_Evo.PAR_1_2_0_0_0_3_TAF_TAP bg,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where v.CODICE_VERSIONE = p_versione
         And v.FLAG_NEW = 1
         And bg.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- TAF/TAP PO versione precedente
      Insert Into Rinf_Pubblicati_Evo.PAR_1_2_0_0_0_3_TAF_TAP
         (    SEDE_TECNICA,
             PO_1_2_0_0_0_3,
             KM_INIZIO,
             KM_FINE,
             CODICE_VERSIONE   )
         Select Distinct
             bg.SEDE_TECNICA,
             PO_1_2_0_0_0_3,
             KM_INIZIO,
             KM_FINE,
             v.CODICE_VERSIONE
        From Rinf_Pubblicati_Evo.PAR_1_2_0_0_0_3_TAF_TAP bg,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where v.CODICE_VERSIONE = p_versione
         And v.FLAG_NEW = 0
         And bg.SEDE_TECNICA = v.SEDE_TECNICA
         And bg.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
      When OTHERS Then
         p_error := SQLCODE;
         PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetOPTAFTAPNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
         Dbms_Output.Put_Line ('SetOPTAFTAPNew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetOPTAFTAPNew;
--
-- -----------------------------------------------------------------------------
--  Procedure SetOPTrackNew (BINARI_CORSA_PO, DICHIARAZIONI_BINARIO_PO, REL_PO_BINARI_CORSA)
-- -----------------------------------------------------------------------------
--
 Procedure SetOPTrackNew (p_versione Number, p_error Out Number) Is
    Begin
      p_error := 0;
--
-- -----------------------------------------------------------------------------
-- 25/07/2018 inserita la minus nelle Insert dei dati non autorizzati per evitare la duplicazione della chiave.
-- BINARI_CORSA_PO Binari nuovi
-- -----------------------------------------------------------------------------
      Insert Into Rinf_Pubblicati_Evo.BINARI_CORSA_PO (
         PO_TRACK_1_2_1_0_0_1,
         PO_TRACK_1_2_1_0_0_2,
         PO_TRACK_1_2_1_0_0_2_D,
         PO_TRACK_1_2_1_0_2_1_AP,
--         PO_TRACK_1_2_1_0_2_1,                            --multiplo
         PO_TRACK_1_2_1_0_2_2_AP,
--         PO_TRACK_1_2_1_0_2_2,                           --multiplo
         PO_TRACK_1_2_1_0_2_3_AP,                          --FITTIZIA PER NYA
--          PO_TRACK_1_2_1_0_2_3,                          --multiplo
         PO_TRACK_1_2_1_0_3_1_AP,                          --FITTIZIA PER NYA
         PO_TRACK_1_2_1_0_3_1,
         PO_TRACK_1_2_1_0_3_2_AP,
         PO_TRACK_1_2_1_0_3_2,
         PO_TRACK_1_2_1_0_3_3_AP,
         PO_TRACK_1_2_1_0_3_3,
         PO_TRACK_1_2_1_0_4_1_AP,                          --FITTIZIA PER NYA
         PO_TRACK_1_2_1_0_4_1,
         CODICE_VERSIONE,
         GRUPPO_AUTORIZZATIVO,
		 PO_TRACK_1_2_1_0_3_4_AP,                     
         PO_TRACK_1_2_1_0_3_4_SUP,                         -- 1.2.1.0.3.4 Parametro Reg.777/2019
         PO_TRACK_1_2_1_0_3_4_INF,                         -- 1.2.1.0.3.4 Parametro Reg.777/2019
         PO_TRACK_1_2_1_0_3_5_AP,                          
         PO_TRACK_1_2_1_0_3_5_A,                           -- 1.2.1.0.3.5 Parametro Reg.777/2019 
         PO_TRACK_1_2_1_0_3_5_B,                           -- 1.2.1.0.3.5 Parametro Reg.777/2019
         PO_TRACK_1_2_1_0_3_6_AP,                          
         PO_TRACK_1_2_1_0_3_6		 )                     -- 1.2.1.0.3.6 Parametro Reg.777/2019
      Select Distinct
         PO_TRACK_1_2_1_0_0_1,
         b.PO_TRACK_1_2_1_0_0_2,
         PO_TRACK_1_2_1_0_0_2_D,
         PO_TRACK_1_2_1_0_2_1_AP,
--         PO_TRACK_1_2_1_0_2_1,                           --multiplo
         PO_TRACK_1_2_1_0_2_2_AP,
--         PO_TRACK_1_2_1_0_2_2,                           -- multiplo
         PO_TRACK_1_2_1_0_2_3_AP,                          -- FITTIZIA PER NYA
--          PO_TRACK_1_2_1_0_2_3,                          -- multiplo
         PO_TRACK_1_2_1_0_3_1_AP,                          -- FITTIZIA PER NYA
         PO_TRACK_1_2_1_0_3_1,
         PO_TRACK_1_2_1_0_3_2_AP,
         PO_TRACK_1_2_1_0_3_2,
         PO_TRACK_1_2_1_0_3_3_AP,
         PO_TRACK_1_2_1_0_3_3,
         PO_TRACK_1_2_1_0_4_1_AP,                          -- FITTIZIA PER NYA
         PO_TRACK_1_2_1_0_4_1,
         v.CODICE_VERSIONE,
         GRUPPO_AUTORIZZATIVO,
		 PO_TRACK_1_2_1_0_3_4_AP,
         PO_TRACK_1_2_1_0_3_4_SUP,                         -- 1.2.1.0.3.4 Parametro Reg.777/2019
         PO_TRACK_1_2_1_0_3_4_INF,                         -- 1.2.1.0.3.4 Parametro Reg.777/2019
         PO_TRACK_1_2_1_0_3_5_AP,                          
         PO_TRACK_1_2_1_0_3_5_A,                           -- 1.2.1.0.3.5 Parametro Reg.777/2019 
         PO_TRACK_1_2_1_0_3_5_B,                           -- 1.2.1.0.3.5 Parametro Reg.777/2019
         PO_TRACK_1_2_1_0_3_6_AP,
         PO_TRACK_1_2_1_0_3_6                              -- 1.2.1.0.3.6 Parametro Reg.777/2019
    From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO b,
         Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r,
         Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
   Where v.CODICE_VERSIONE = p_versione 
     And v.FLAG_NEW = 1 
	 And b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2 
	 And r.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Binari versione precedente - Binari delle DTP che non hanno autorizzato
-- -----------------------------------------------------------------------------
--
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
            PO_TRACK_1_2_1_0_3_6		 )              -- 1.2.1.0.3.6 Parametro Reg.777/2019
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
            v.CODICE_VERSIONE,
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
            Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
        And b.CODICE_VERSIONE = r.CODICE_VERSIONE
        And r.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1
        And (b.PO_TRACK_1_2_1_0_0_2, v.CODICE_VERSIONE) In
                 (Select b.PO_TRACK_1_2_1_0_0_2, v.CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
                         Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
                         Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
                   Where v.CODICE_VERSIONE = p_versione
                     And v.FLAG_NEW = 0
                     And b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
                     And b.CODICE_VERSIONE = r.CODICE_VERSIONE
                     And r.SEDE_TECNICA = v.SEDE_TECNICA
                     And b.CODICE_VERSIONE = p_versione - 1
                 Minus
                  Select b.PO_TRACK_1_2_1_0_0_2, b.CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.BINARI_CORSA_PO b
				  );
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni nuove
-- -----------------------------------------------------------------------------
--
      Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO  (
                PO_TRACK_1_2_1_0_0_2,
                  TIPO_DICHIARAZIONE,
                  PO_TRACK_1_2_1_0_1_1O2_AP,
                  PO_TRACK_1_2_1_0_1_1O2,
                  KM_INIZIO,
                  KM_FINE,
                  CODICE_VERSIONE   )
         Select DISTINCT
                  d.PO_TRACK_1_2_1_0_0_2         ,
                  TIPO_DICHIARAZIONE              ,
                  PO_TRACK_1_2_1_0_1_1O2_AP       ,
                  PO_TRACK_1_2_1_0_1_1O2          ,
                  KM_INIZIO                       ,
                  KM_FINE                         ,
                  v.CODICE_VERSIONE
             From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_PO d,
                  Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO b,
                  Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r,
                  Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
            Where v.CODICE_VERSIONE = p_versione 
		      And v.FLAG_NEW = 1 
		      And b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2 
		 	  And r.SEDE_TECNICA = v.SEDE_TECNICA 
		 	  And b.PO_TRACK_1_2_1_0_0_2 = d.PO_TRACK_1_2_1_0_0_2;
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni versione precedente
-- -----------------------------------------------------------------------------
--
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
                  v.CODICE_VERSIONE
             From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO d,
                  Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
                  Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r, 
                  Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
            Where v.CODICE_VERSIONE = p_versione
              And v.FLAG_NEW = 0
              And r.SEDE_TECNICA = v.SEDE_TECNICA
              And b.PO_TRACK_1_2_1_0_0_2 = d.PO_TRACK_1_2_1_0_0_2
              And b.CODICE_VERSIONE = d.CODICE_VERSIONE
              And b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
              And b.CODICE_VERSIONE = r.CODICE_VERSIONE
              And b.CODICE_VERSIONE = p_versione - 1
              And (d.PO_TRACK_1_2_1_0_0_2,  d.TIPO_DICHIARAZIONE,  d.PO_TRACK_1_2_1_0_1_1O2, d.KM_INIZIO, v.CODICE_VERSIONE) In
                 (Select d.PO_TRACK_1_2_1_0_0_2,
                         d.TIPO_DICHIARAZIONE,
                         d.PO_TRACK_1_2_1_0_1_1O2,
                         d.KM_INIZIO,
                         v.CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO d,
                         Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
                         Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
                         Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
                   Where v.CODICE_VERSIONE = p_versione
                     And v.FLAG_NEW = 0
                     And r.SEDE_TECNICA = v.SEDE_TECNICA
                     And b.PO_TRACK_1_2_1_0_0_2 = d.PO_TRACK_1_2_1_0_0_2
                     And b.CODICE_VERSIONE = d.CODICE_VERSIONE
                     And b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
                     And b.CODICE_VERSIONE = r.CODICE_VERSIONE
                     And b.CODICE_VERSIONE = p_versione - 1
                  Minus
                  Select PO_TRACK_1_2_1_0_0_2,
                         TIPO_DICHIARAZIONE,
                         PO_TRACK_1_2_1_0_1_1O2,
                         KM_INIZIO,
                         CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO);
--
-- -----------------------------------------------------------------------------
-- Relazioni Binari-PO nuove
-- -----------------------------------------------------------------------------
--
      Insert Into Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA (
             PO_TRACK_1_2_1_0_0_2,
             SEDE_TECNICA,
             CODICE_VERSIONE )
      Select DISTINCT
             r.PO_TRACK_1_2_1_0_0_2 ,
             r.SEDE_TECNICA,
             v.CODICE_VERSIONE
        From Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r,
             Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO b,
             Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI p,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where v.CODICE_VERSIONE = p_versione 
	     And v.FLAG_NEW = 1 
		 And b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2 
		 And r.SEDE_TECNICA = v.SEDE_TECNICA 
		 And r.SEDE_TECNICA = p.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Relazione Binari-PO precedenti
-- -----------------------------------------------------------------------------
--
      Insert Into Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA (
             PO_TRACK_1_2_1_0_0_2,
             SEDE_TECNICA,
             CODICE_VERSIONE )
      Select DISTINCT
             r.PO_TRACK_1_2_1_0_0_2 ,
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
         And r.CODICE_VERSIONE = p_versione - 1
         And (r.PO_TRACK_1_2_1_0_0_2, r.SEDE_TECNICA, v.CODICE_VERSIONE) In
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
--
 EXCEPTION
    When OTHERS  Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetOPTrackNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        DBMS_OUTPUT.PUT_LINE ('SetOPTrackNew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetOPTrackNew;
--
-- -----------------------------------------------------------------------------
--  Procedure SetOPTunnelNew (GALLERIE_BINARI_PO, REL_GALLERIE_BINARI_PO, DICHIARAZIONI_GALLERIE_BIN_PO)
-- -----------------------------------------------------------------------------
--
 Procedure SetOPTunnelNew (p_versione Number, p_error     Out Number) Is
   Begin
     p_error := 0;
--
-- Gallerie Nuove
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
         v.CODICE_VERSIONE,
         GALLERIA_PRINCIPALE,
         CONFIGURAZIONE_GALLERIA,
         g.GRUPPO_AUTORIZZATIVO,
		 PO_TR_TUNNEL_1_2_1_0_5_9_AP,
         PO_TR_TUNNEL_1_2_1_0_5_9                          -- 1.2.1.0.5.9 Parametro Reg.777/2019
    From Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_PO g,
         Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
         Rinf_Autorizzazioni_Evo.REL_GALLERIE_BINARI_PO bg,
         Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO b,
         Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r
   Where g.PO_TR_TUNNEL_1_2_1_0_5_2 = bg.PO_TR_TUNNEL_1_2_1_0_5_2
     And bg.PO_TRACK_1_2_1_0_0_2 =  b.PO_TRACK_1_2_1_0_0_2
     And v.CODICE_VERSIONE = p_versione
     And v.FLAG_NEW = 1
     And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
     And r.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Gallerie Versione precedente
-- -----------------------------------------------------------------------------
--
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
         v.CODICE_VERSIONE,
         GALLERIA_PRINCIPALE,
         CONFIGURAZIONE_GALLERIA,
         g.GRUPPO_AUTORIZZATIVO,
		 PO_TR_TUNNEL_1_2_1_0_5_9_AP,
         PO_TR_TUNNEL_1_2_1_0_5_9                          -- 1.2.1.0.5.9 Parametro Reg.777/2019
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
     And (g.PO_TR_TUNNEL_1_2_1_0_5_2, v.CODICE_VERSIONE) In
                 (Select g.PO_TR_TUNNEL_1_2_1_0_5_2, v.CODICE_VERSIONE
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
                    From Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO  
				  );
--
-- -----------------------------------------------------------------------------
--Relazioni Gallerie-Binari Nuove
-- -----------------------------------------------------------------------------
--
      Insert Into Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO
          (PO_TR_TUNNEL_1_2_1_0_5_2, PO_TRACK_1_2_1_0_0_2, CODICE_VERSIONE)
      Select Distinct
           PO_TR_TUNNEL_1_2_1_0_5_2,
           bg.PO_TRACK_1_2_1_0_0_2,
           v.CODICE_VERSIONE
      From Rinf_Autorizzazioni_Evo.REL_GALLERIE_BINARI_PO bg,
           Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO b,
           Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r,
           Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
     Where bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
       And v.CODICE_VERSIONE = p_versione
       And v.FLAG_NEW = 1
       And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
       And r.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
--Relazioni Gallerie-Binari Versione Precedente
-- -----------------------------------------------------------------------------
--
      Insert Into Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO
	       (PO_TR_TUNNEL_1_2_1_0_5_2, PO_TRACK_1_2_1_0_0_2, CODICE_VERSIONE)
       Select Distinct
            PO_TR_TUNNEL_1_2_1_0_5_2, 
			bg.PO_TRACK_1_2_1_0_0_2, 
			v.CODICE_VERSIONE
       From  Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO bg,
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
        And (PO_TR_TUNNEL_1_2_1_0_5_2, bg.PO_TRACK_1_2_1_0_0_2, v.CODICE_VERSIONE) in
                 (Select PO_TR_TUNNEL_1_2_1_0_5_2,
                         bg.PO_TRACK_1_2_1_0_0_2,
                         v.CODICE_VERSIONE
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
                    From Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_PO  
				  );
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni Nuove
-- -----------------------------------------------------------------------------
--
      Insert Into Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO (
           PO_TR_TUNNEL_1_2_1_0_5_2, 
		   TIPO_DICHIARAZIONE, 
		   PO_TR_TUNNEL_1_2_1_0_5_3O4_AP, 
		   PO_TR_TUNNEL_1_2_1_0_5_3O4, 
		   KM_INIZIO, 
		   KM_FINE, 
		   CODICE_VERSIONE   )
      Select DISTINCT
           d.PO_TR_TUNNEL_1_2_1_0_5_2,
           TIPO_DICHIARAZIONE,
           PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,
           PO_TR_TUNNEL_1_2_1_0_5_3O4,
           KM_INIZIO, 
		   KM_FINE,
           v.CODICE_VERSIONE
      From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_GALLERIE_BIN_PO d,
           Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_PO g,
           Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
           Rinf_Autorizzazioni_Evo.REL_GALLERIE_BINARI_PO bg,
           Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO b,
           Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r
     Where d.PO_TR_TUNNEL_1_2_1_0_5_2 = g.PO_TR_TUNNEL_1_2_1_0_5_2
       And g.PO_TR_TUNNEL_1_2_1_0_5_2 = bg.PO_TR_TUNNEL_1_2_1_0_5_2
       And bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
       And v.CODICE_VERSIONE = p_versione
       And v.FLAG_NEW = 1
       And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
       And r.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
--Dichiarazioni versione precedente
-- -----------------------------------------------------------------------------
--
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
           v.CODICE_VERSIONE
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
       And (d.PO_TR_TUNNEL_1_2_1_0_5_2,
            d.TIPO_DICHIARAZIONE,
            d.PO_TR_TUNNEL_1_2_1_0_5_3O4,
            d.KM_INIZIO,
            v.CODICE_VERSIONE) In
          (Select d.PO_TR_TUNNEL_1_2_1_0_5_2,
                   d.TIPO_DICHIARAZIONE,
                   d.PO_TR_TUNNEL_1_2_1_0_5_3O4,
                   d.KM_INIZIO,
                   v.CODICE_VERSIONE
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
--
 EXCEPTION
     When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetOPTunnelNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetOPTunnelNew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetOPTunnelNew;
--
-- -----------------------------------------------------------------------------
--                Procedure SetOPPlatformNew (MARCIAPIEDI_BINARI_PO)
-- -----------------------------------------------------------------------------
--
 Procedure SetOPPlatformNew (p_versione Number,p_error Out Number) IS
   Begin
      p_error := 0;
--Marciapiedi nuovi
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
           v.CODICE_VERSIONE,
           m.GRUPPO_AUTORIZZATIVO
      From Rinf_Autorizzazioni_Evo.MARCIAPIEDI_BINARI_PO m,
           Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO b,
           Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r,
           Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
     Where m.BINARIO_1 = B.PO_TRACK_1_2_1_0_0_2
       And v.CODICE_VERSIONE = p_versione 
       And v.FLAG_NEW = 1 
       And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
       And r.SEDE_TECNICA = v.SEDE_TECNICA
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
           v.CODICE_VERSIONE,
           m.GRUPPO_AUTORIZZATIVO
      From Rinf_Autorizzazioni_Evo.MARCIAPIEDI_BINARI_PO m,
           Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO b,
           Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r,
           Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
     Where m.BINARIO_2 = B.PO_TRACK_1_2_1_0_0_2 
	   And v.CODICE_VERSIONE = p_versione 
	   And v.FLAG_NEW = 1 
	   And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 
	   And r.SEDE_TECNICA = v.SEDE_TECNICA
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
           v.CODICE_VERSIONE,
           m.GRUPPO_AUTORIZZATIVO
      From Rinf_Autorizzazioni_Evo.MARCIAPIEDI_BINARI_PO m,
           Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO b,
           Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r,
           Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
     Where m.BINARIO_3 = B.PO_TRACK_1_2_1_0_0_2 
	   And v.CODICE_VERSIONE = p_versione 
	   And v.FLAG_NEW = 1 
	   And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 
	   And r.SEDE_TECNICA = v.SEDE_TECNICA
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
           v.CODICE_VERSIONE,
           m.GRUPPO_AUTORIZZATIVO
      From Rinf_Autorizzazioni_Evo.MARCIAPIEDI_BINARI_PO m,
           Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO b,
           Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r,
           Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
     Where m.BINARIO_4 = B.PO_TRACK_1_2_1_0_0_2 
	   And v.CODICE_VERSIONE = p_versione 
	   And v.FLAG_NEW = 1 
	   And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 
	   And r.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
--Marciapiedi versione precedente
-- -----------------------------------------------------------------------------
--
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
             v.CODICE_VERSIONE,
             m.GRUPPO_AUTORIZZATIVO
        From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO m,
             Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
             Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA  r,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where m.BINARIO_1 = b.PO_TRACK_1_2_1_0_0_2 
         And m.CODICE_VERSIONE = b.CODICE_VERSIONE 
         And v.CODICE_VERSIONE = p_versione 
         And v.FLAG_NEW = 0 
         And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 
         And r.CODICE_VERSIONE = b.CODICE_VERSIONE
         And r.SEDE_TECNICA = v.SEDE_TECNICA 
         And b.CODICE_VERSIONE = p_versione -1
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
             v.CODICE_VERSIONE,
             m.GRUPPO_AUTORIZZATIVO
        From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO m,
             Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
             Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA  r,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where m.BINARIO_2 = b.PO_TRACK_1_2_1_0_0_2 
         And m.CODICE_VERSIONE = b.CODICE_VERSIONE 
         And v.CODICE_VERSIONE = p_versione 
         And v.FLAG_NEW = 0 
         And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 
         And r.CODICE_VERSIONE = b.CODICE_VERSIONE
         And r.SEDE_TECNICA = v.SEDE_TECNICA 
         And b.CODICE_VERSIONE = p_versione -1
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
             v.CODICE_VERSIONE,
             m.GRUPPO_AUTORIZZATIVO
        From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO m,
             Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
             Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA  r,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where m.BINARIO_3 = b.PO_TRACK_1_2_1_0_0_2 
         And m.CODICE_VERSIONE = b.CODICE_VERSIONE 
         And v.CODICE_VERSIONE = p_versione 
         And v.FLAG_NEW = 0 
         And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 
         And r.CODICE_VERSIONE = b.CODICE_VERSIONE
         And r.SEDE_TECNICA = v.SEDE_TECNICA 
         And b.CODICE_VERSIONE = p_versione -1
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
            v.CODICE_VERSIONE,
            m.GRUPPO_AUTORIZZATIVO
       From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO m,
            Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
            Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA  r,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where m.BINARIO_4 = b.PO_TRACK_1_2_1_0_0_2 
         And m.CODICE_VERSIONE = b.CODICE_VERSIONE 
         And v.CODICE_VERSIONE = p_versione 
         And v.FLAG_NEW = 0 
         And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 
         And r.CODICE_VERSIONE = b.CODICE_VERSIONE
         And r.SEDE_TECNICA = v.SEDE_TECNICA 
         And b.CODICE_VERSIONE = p_versione -1 
	  )
    Where (PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE)  Not In 
   (Select PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE
      From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO 
	);
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetOPPlatformNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetOPPlatformNew  - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetOPPlatformNew;
--
-- -----------------------------------------------------------------------------
--  Procedure SetOPSidingNew (BINARI_RACCORDO_PO, DICHIARAZIONI_RACCORDO_PO)
-- -----------------------------------------------------------------------------
--
 Procedure SetOPSidingNew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- Binari di raccordo nuovi
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
            PO_SD_1_2_2_0_6_1 			)                   -- 1.2.2.0.6.1 Parametro Reg.777/2019
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
            v.CODICE_VERSIONE,
            GRUPPO_AUTORIZZATIVO,
			PO_SD_1_2_2_0_6_1_AP,
            PO_SD_1_2_2_0_6_1                              -- 1.2.2.0.6.1 Parametro Reg.777/2019
	   From Rinf_Autorizzazioni_Evo.BINARI_RACCORDO_PO b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 1 
		And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Binari di raccordo versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE,
            GRUPPO_AUTORIZZATIVO,
			PO_SD_1_2_2_0_6_1_AP,
            PO_SD_1_2_2_0_6_1                              -- 1.2.2.0.6.1 Parametro Reg.777/2019
	   From Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
        And v.FLAG_NEW = 0 
		And b.SEDE_TECNICA = v.SEDE_TECNICA 
		And b.CODICE_VERSIONE = p_versione -1;
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni nuove
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_RACCORDO_PO d,
            Rinf_Autorizzazioni_Evo.BINARI_RACCORDO_PO b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where d.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2 
        And v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 1 
	    And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.DICHIARAZIONI_RACCORDO_PO d,
            Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where d.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2 
        And d.CODICE_VERSIONE = b.CODICE_VERSIONE 
		And v.CODICE_VERSIONE = p_versione 
		And v.FLAG_NEW = 0 
		And b.SEDE_TECNICA = v.SEDE_TECNICA 
		And b.CODICE_VERSIONE = p_versione -1;

 EXCEPTION
    When OTHERS   Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetOPSidingNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetOPSidingNew - Errore: '|| Substr(SQLERRM, 1, 300));
END  SetOPSidingNew;
--
-- -----------------------------------------------------------------------------
--  Procedure SetOPTunnelSDNew (GALLERIE_RACCORDO_PO, DICHIARAZIONI_GALLERIE_SD_PO, REL_GALLERIE_RACCORDO_PO)
-- -----------------------------------------------------------------------------
--
 Procedure SetOPTunnelSDNew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
-- Gallerie nuove
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.GALLERIE_RACCORDO_PO g,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.REL_GALLERIE_RACCORDO_PO bg,
            Rinf_Autorizzazioni_Evo.BINARI_RACCORDO_PO b
      Where g.PO_SD_TUNNEL_1_2_2_0_5_2 = bg.PO_SD_TUNNEL_1_2_2_0_5_2
        And bg.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Gallerie versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.GALLERIE_RACCORDO_PO g,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.REL_GALLERIE_RACCORDO_PO bg,
            Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO b
      Where g.PO_SD_TUNNEL_1_2_2_0_5_2 = bg.PO_SD_TUNNEL_1_2_2_0_5_2
        And g.CODICE_VERSIONE = bg.CODICE_VERSIONE
        And bg.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni nuove
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_GALLERIE_SD_PO d,
            Rinf_Autorizzazioni_Evo.GALLERIE_RACCORDO_PO g,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.REL_GALLERIE_RACCORDO_PO bg,
            Rinf_Autorizzazioni_Evo.BINARI_RACCORDO_PO b
      Where d.PO_SD_TUNNEL_1_2_2_0_5_2 = g.PO_SD_TUNNEL_1_2_2_0_5_2
        And g.PO_SD_TUNNEL_1_2_2_0_5_2 = bg.PO_SD_TUNNEL_1_2_2_0_5_2
        And bg.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_SD_PO d,
            Rinf_Pubblicati_Evo.GALLERIE_RACCORDO_PO g,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.REL_GALLERIE_RACCORDO_PO bg,
            Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO b
      Where d.PO_SD_TUNNEL_1_2_2_0_5_2 = g.PO_SD_TUNNEL_1_2_2_0_5_2
        And d.CODICE_VERSIONE = g.CODICE_VERSIONE
        And g.PO_SD_TUNNEL_1_2_2_0_5_2 = bg.PO_SD_TUNNEL_1_2_2_0_5_2
        And g.CODICE_VERSIONE = bg.CODICE_VERSIONE
        And bg.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--
-- -----------------------------------------------------------------------------
-- Relazioni Gallerie-Sd nuove
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.REL_GALLERIE_RACCORDO_PO  (
            PO_SD_TUNNEL_1_2_2_0_5_2,
            PO_SD_1_2_2_0_0_2,
            CODICE_VERSIONE  )
    Select Distinct
            bg.PO_SD_TUNNEL_1_2_2_0_5_2,
            bg.PO_SD_1_2_2_0_0_2,
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.REL_GALLERIE_RACCORDO_PO bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_RACCORDO_PO b
      Where bg.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Relazioni Gallerie-Sd versione precedente
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.REL_GALLERIE_RACCORDO_PO  (
            PO_SD_TUNNEL_1_2_2_0_5_2,
            PO_SD_1_2_2_0_0_2,
            CODICE_VERSIONE  )
    Select Distinct
            bg.PO_SD_TUNNEL_1_2_2_0_5_2,
            bg.PO_SD_1_2_2_0_0_2,
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.REL_GALLERIE_RACCORDO_PO bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO b
      Where bg.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
      When OTHERS  Then
         p_error := SQLCODE;
         PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetOPTunnelSDNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
         Dbms_Output.Put_Line ('SetOPTunnelSDNew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetOPTunnelSDNew;
 --
-- -----------------------------------------------------------------------------
--   Procedure SetOPLineNew (CORRIDOIO_PO, LINEE_TENT_PO, LINEA_COMM_PO, LINEA_TRIPLETTA )
-- -----------------------------------------------------------------------------
--
 Procedure SetOPLineNew (p_versione Number, p_error Out Number) Is
  Begin
     p_error := 0;
--
-- Relazioni Op-Corridoio Nuove
    Insert Into Rinf_Pubblicati_Evo.CORRIDOIO_PO
            (CODICE_CORRIDOIO, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_CORRIDOIO,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.CORRIDOIO_PO p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 1 
		And p.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Relazioni Op-Corridoio versione precedente
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.CORRIDOIO_PO
           (CODICE_CORRIDOIO, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_CORRIDOIO,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.CORRIDOIO_PO p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 0 
		And p.SEDE_TECNICA = v.SEDE_TECNICA
        And p.CODICE_VERSIONE = p_versione -1;
--
-- -----------------------------------------------------------------------------
-- Relazioni OP-Linee Ten Nuove
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.LINEE_TENT_PO
            (CODICE_LINEA_TENT, SEDE_TECNICA, CODICE_VERSIONE)
      Select CODICE_LINEA_TENT,
             p.SEDE_TECNICA,
             v.CODICE_VERSIONE
        From Rinf_Autorizzazioni_Evo.LINEE_TENT_PO p,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where v.CODICE_VERSIONE = p_versione 
	     And v.FLAG_NEW = 1 
		 And p.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Relazioni OP-Linee Ten versione precedente
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.LINEE_TENT_PO
            (CODICE_LINEA_TENT, SEDE_TECNICA, CODICE_VERSIONE)
      Select CODICE_LINEA_TENT,
             p.SEDE_TECNICA,
             v.CODICE_VERSIONE
        From Rinf_Pubblicati_Evo.LINEE_TENT_PO p,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where v.CODICE_VERSIONE = p_versione 
	     And v.FLAG_NEW = 0 
		 And p.SEDE_TECNICA = v.SEDE_TECNICA 
		 And p.CODICE_VERSIONE = p_versione -1;
--
-- -----------------------------------------------------------------------------
-- Relazione OP-Linee Comm nuove
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.LINEA_COMM_PO
            (CODICE_GIURISDIZIONE, SEDE_TECNICA, CODICE_VERSIONE, KM_INIZIO)
      Select CODICE_GIURISDIZIONE,
             p.SEDE_TECNICA,
             v.CODICE_VERSIONE,
             KM_INIZIO
        From Rinf_Autorizzazioni_Evo.LINEA_COMM_PO p,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where v.CODICE_VERSIONE = p_versione 
	     And v.FLAG_NEW = 1 
		 And p.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Relazione OP-Linee Comm versione precedente
-- -----------------------------------------------------------------------------
--
     Insert Into Rinf_Pubblicati_Evo.LINEA_COMM_PO
            (CODICE_GIURISDIZIONE, SEDE_TECNICA, CODICE_VERSIONE, KM_INIZIO)
      Select CODICE_GIURISDIZIONE,
             p.SEDE_TECNICA,
             v.CODICE_VERSIONE,
             KM_INIZIO
        From Rinf_Pubblicati_Evo.LINEA_COMM_PO p,
             Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
       Where v.CODICE_VERSIONE = p_versione 
	     And v.FLAG_NEW = 0
		 And p.SEDE_TECNICA = v.SEDE_TECNICA
         And p.CODICE_VERSIONE = p_versione -1;
--
-- -----------------------------------------------------------------------------
-- Relazione OP-SOL Linee Comm fittizie nuove
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.LINEA_TRIPLETTA
           (CODICE_LINEA, SEDE_TECNICA, CODICE_VERSIONE,LINEA_ORIGINE)
     Select CODICE_LINEA,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE,
            LINEA_ORIGINE
       From Rinf_Autorizzazioni_Evo.LINEA_TRIPLETTA p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 1 
		And p.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Relazione OP-SOL Linee Comm fittizie versione precedente
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.LINEA_TRIPLETTA
           (CODICE_LINEA, SEDE_TECNICA, CODICE_VERSIONE, LINEA_ORIGINE)
     Select CODICE_LINEA,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE,
            LINEA_ORIGINE
       From Rinf_Pubblicati_Evo.LINEA_TRIPLETTA p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 0 
		And p.SEDE_TECNICA = v.SEDE_TECNICA
        And p.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetOPLineNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetOPLineNew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetOPLineNew;
--
-- -----------------------------------------------------------------------------
--               Procedure SetSOLNew (SEZIONI_LINEA)
-- -----------------------------------------------------------------------------
--
 Procedure SetSOLNew(p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- SOL nuove
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
            v.CODICE_VERSIONE,
            GRUPPO_AUTORIZZATIVO,
            Null CACHE_FIELD
       From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 1 
		And p.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- SOL versione precedente
-- -----------------------------------------------------------------------------
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
            CODICE_VERSIONE,
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
            v.CODICE_VERSIONE,
            GRUPPO_AUTORIZZATIVO,
            Null CACHE_FIELD
       From Rinf_Pubblicati_Evo.SEZIONI_LINEA p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 0
		And p.SEDE_TECNICA = v.SEDE_TECNICA
		And p.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOLNew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOLNew;
--
-- -----------------------------------------------------------------------------
--                         Procedure SetSOLTrackNew (BINARI_CORSA_SOL)
-- -----------------------------------------------------------------------------
--
 Procedure SetSOLTrackNew(p_versione Number, p_error Out Number) IS
  Begin
    p_error := 0;
--
-- Binari SOl nuovi
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
    Select  b.SOL_TRACK_1_1_1_0_0_1,
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
            b.SEDE_TECNICA,
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
       From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione
 	    And v.FLAG_NEW = 1 
		And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Binari SOL versione precedente
-- -----------------------------------------------------------------------------
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
    Select
            b.SOL_TRACK_1_1_1_0_0_1,
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
            b.SEDE_TECNICA,
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
       From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione
 	    And v.FLAG_NEW = 0
		And b.SEDE_TECNICA = v.SEDE_TECNICA
		And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLTrackNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        DBMS_OUTPUT.PUT_LINE ('SetSOLTrackNew - Errore: '|| Substr(SQLERRM, 1, 300));
END SetSOLTrackNew;
--
-- -----------------------------------------------------------------------------
--  Procedure SetSOLTrackDecNew (DICHIARAZIONI_BINARIO_SOL_INF, DICHIARAZIONI_BINARIO_SOL_ENE, DICHIARAZIONI_BINARIO_SOL_CCS )
-- -----------------------------------------------------------------------------
--
 Procedure SetSOLTrackDecNew(p_versione Number,p_error Out Number) Is
  Begin
    p_error := 0;
--
-- Dichiarazioni INF nuove
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_SOL_INF d,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where d.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 
	    And v.CODICE_VERSIONE = p_versione 
		And v.FLAG_NEW = 1 
		And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni INF versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF d,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where d.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 
	    And d.CODICE_VERSIONE = b.CODICE_VERSIONE
	    And v.CODICE_VERSIONE = p_versione 
		And v.FLAG_NEW = 0
		And b.SEDE_TECNICA = v.SEDE_TECNICA
		And b.CODICE_VERSIONE = p_versione -1;
--
-- -----------------------------------------------------------------------------
--Dichiarazione ENE Nuove
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_SOL_ENE d,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where d.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 
	    And v.CODICE_VERSIONE = p_versione 
		And v.FLAG_NEW = 1 
		And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni ENE versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE d,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where d.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 
	    And d.CODICE_VERSIONE = b.CODICE_VERSIONE
	    And v.CODICE_VERSIONE = p_versione 
		And v.FLAG_NEW = 0
		And b.SEDE_TECNICA = v.SEDE_TECNICA
		And b.CODICE_VERSIONE = p_versione -1;
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni CCS Nuove
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_SOL_CCS d,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where d.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 
	    And v.CODICE_VERSIONE = p_versione 
		And v.FLAG_NEW = 1 
		And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni CCS versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_CCS d,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where d.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 
	    And d.CODICE_VERSIONE = b.CODICE_VERSIONE 
	    And v.CODICE_VERSIONE = p_versione 
		And v.FLAG_NEW = 0 
		And b.SEDE_TECNICA = v.SEDE_TECNICA
		And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLTrackDecNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('Errore SetSOLTrackDecNew ' || Substr (SQLERRM, 1, 300));
 END SetSOLTrackDecNew;
--
-- -----------------------------------------------------------------------------
--      Procedure SetSOLTunnelNew (GALLERIE_BINARI_SOL, REL_GALLERIE_BINARI_SOL, DICHIARAZIONI_GALLERIE_BIN_SOL)
-- -----------------------------------------------------------------------------
--
 Procedure SetSOLTunnelNew(p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- Gallerie SOL Nuove
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
            SOL_TUNNEL_1_1_1_1_8_8_2  )
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
            v.CODICE_VERSIONE,
            GALLERIA_PRINCIPALE,
            CONFIGURAZIONE_GALLERIA,
            g.GRUPPO_AUTORIZZATIVO,
      	  	Null SOL_TUNNEL_1_1_1_1_8_8_1_AP,                   --  NUOVI PARAMETRI Reg.2019/777
            SOL_TUNNEL_1_1_1_1_8_8_1,
            SOL_TUNNEL_1_1_1_1_8_8_2_AP,
            SOL_TUNNEL_1_1_1_1_8_8_2
       From Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_SOL g,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.REL_GALLERIE_BINARI_SOL bg,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where g.SOL_TUNNEL_1_1_1_1_8_2 = bg.SOL_TUNNEL_1_1_1_1_8_2
        And bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA=v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Gallerie SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE,
            GALLERIA_PRINCIPALE,
            CONFIGURAZIONE_GALLERIA,
            g.GRUPPO_AUTORIZZATIVO,
			Null SOL_TUNNEL_1_1_1_1_8_8_1_AP,                   --  NUOVI PARAMETRI Reg.2019/777
            SOL_TUNNEL_1_1_1_1_8_8_1,
            SOL_TUNNEL_1_1_1_1_8_8_2_AP,
            SOL_TUNNEL_1_1_1_1_8_8_2
       From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL g,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where g.SOL_TUNNEL_1_1_1_1_8_2 = bg.SOL_TUNNEL_1_1_1_1_8_2
        And g.CODICE_VERSIONE = bg.CODICE_VERSIONE
        And bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1
        And (g.SOL_TUNNEL_1_1_1_1_8_2, v.CODICE_VERSIONE) In
                 (Select g.SOL_TUNNEL_1_1_1_1_8_2, v.CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL g,
                         Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
                         Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL bg,
                         Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
                   Where g.SOL_TUNNEL_1_1_1_1_8_2 = bg.SOL_TUNNEL_1_1_1_1_8_2
                     And g.CODICE_VERSIONE = bg.CODICE_VERSIONE
                     And bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
                     And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
                     And v.CODICE_VERSIONE = p_versione
                     And v.FLAG_NEW = 0
                     And b.SEDE_TECNICA = v.SEDE_TECNICA
                     And b.CODICE_VERSIONE = p_versione -1
                 Minus
                  Select SOL_TUNNEL_1_1_1_1_8_2, CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL
				 );

-- -----------------------------------------------------------------------------
-- Relazioni Gallerie-binari Nuove
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL
      (SOL_TUNNEL_1_1_1_1_8_2, SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, SOL_TUNNEL_1_1_1_1_8_8_AP, SOL_TUNNEL_1_1_1_1_8_8_1_AP)
    Select Distinct
            SOL_TUNNEL_1_1_1_1_8_2,
            bg.SOL_TRACK_1_1_1_0_0_1 ,
            v.CODICE_VERSIONE,
			SOL_TUNNEL_1_1_1_1_8_8_AP, 
			SOL_TUNNEL_1_1_1_1_8_8_1_AP
       From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.REL_GALLERIE_BINARI_SOL bg,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA;

-- -----------------------------------------------------------------------------
-- Relazioni Gallerie-binari versione precedente
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL (
            SOL_TUNNEL_1_1_1_1_8_2,
            SOL_TRACK_1_1_1_0_0_1,
            CODICE_VERSIONE, 
			SOL_TUNNEL_1_1_1_1_8_8_AP, 
			SOL_TUNNEL_1_1_1_1_8_8_1_AP)
    Select Distinct
            SOL_TUNNEL_1_1_1_1_8_2, 
			bg.SOL_TRACK_1_1_1_0_0_1, 
			v.CODICE_VERSIONE, 
			SOL_TUNNEL_1_1_1_1_8_8_AP, 
			SOL_TUNNEL_1_1_1_1_8_8_1_AP
       From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL bg,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1
        And (SOL_TUNNEL_1_1_1_1_8_2, 
		                 bg.SOL_TRACK_1_1_1_0_0_1, 
		                 v.CODICE_VERSIONE, 
			             SOL_TUNNEL_1_1_1_1_8_8_AP, 
			             SOL_TUNNEL_1_1_1_1_8_8_1_AP) In
                 (Select SOL_TUNNEL_1_1_1_1_8_2,
                         bg.SOL_TRACK_1_1_1_0_0_1,
                         v.CODICE_VERSIONE, 
			             SOL_TUNNEL_1_1_1_1_8_8_AP, 
			             SOL_TUNNEL_1_1_1_1_8_8_1_AP
                    From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
                         Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL bg,
                         Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
                   Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
                     And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
                     And v.CODICE_VERSIONE = p_versione
                     And v.FLAG_NEW = 0
                     And b.SEDE_TECNICA = v.SEDE_TECNICA
                     And b.CODICE_VERSIONE = p_versione -1
                 Minus
                  Select SOL_TUNNEL_1_1_1_1_8_2,
                         SOL_TRACK_1_1_1_0_0_1,
                         CODICE_VERSIONE, 
			             SOL_TUNNEL_1_1_1_1_8_8_AP, 
			             SOL_TUNNEL_1_1_1_1_8_8_1_AP
                    From Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL
					);
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni nuove
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL d,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.REL_GALLERIE_BINARI_SOL bg,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where d.SOL_TUNNEL_1_1_1_1_8_2 = bg.SOL_TUNNEL_1_1_1_1_8_2
        And bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
-- Dichiarazioni versione precedente
-- -----------------------------------------------------------------------------
--
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
          v.CODICE_VERSIONE
     From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL d,
          Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
          Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL bg,
          Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
    Where d.SOL_TUNNEL_1_1_1_1_8_2 = bg.SOL_TUNNEL_1_1_1_1_8_2
      And d.CODICE_VERSIONE = bg.CODICE_VERSIONE
      And bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
      And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
      And v.CODICE_VERSIONE = p_versione
      And v.FLAG_NEW = 0
      And b.SEDE_TECNICA = v.SEDE_TECNICA
      And b.CODICE_VERSIONE = p_versione -1
      And    ( d.SOL_TUNNEL_1_1_1_1_8_2,
               TIPO_DICHIARAZIONE,
               SOL_TUNNEL_1_1_1_1_8_5O6,
               KM_INIZIO,
               v.CODICE_VERSIONE ) In
                 (Select d.SOL_TUNNEL_1_1_1_1_8_2,
                         TIPO_DICHIARAZIONE,
                         SOL_TUNNEL_1_1_1_1_8_5O6,
                         KM_INIZIO,
                         v.CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL d,
                         Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
                         Rinf_Pubblicati_Evo.REL_GALLERIE_BINARI_SOL bg,
                         Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
                   Where d.SOL_TUNNEL_1_1_1_1_8_2 = bg.SOL_TUNNEL_1_1_1_1_8_2
                         And d.CODICE_VERSIONE = bg.CODICE_VERSIONE
                         And bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
                         And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
                         And v.CODICE_VERSIONE = p_versione
                         And v.FLAG_NEW = 0
                         And b.SEDE_TECNICA = v.SEDE_TECNICA
                         And b.CODICE_VERSIONE = p_versione -1
                 Minus
                  Select SOL_TUNNEL_1_1_1_1_8_2,
                         TIPO_DICHIARAZIONE,
                         SOL_TUNNEL_1_1_1_1_8_5O6,
                         KM_INIZIO,
                         CODICE_VERSIONE
                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL 
				 );
--
 EXCEPTION
    When OTHERS  Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLTunnelNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOLTunnelNew - Errore: ' || Substr (SQLERRM, 1, 300));
 END SetSOLTunnelNew;
--
-- -----------------------------------------------------------------------------
--       Procedure SetSOLCATTENNew - PAR_1_1_1_1_2_1_CAT_TEN_SOL (1.1.1.1.2.1)
-- -----------------------------------------------------------------------------
--
 Procedure SetSOLCATTENNew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- CAT TEN SOL Nuovi
    Insert Into Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL (
            SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_2_1,
            KM_INIZIO,
            KM_FINE,
            CODICE_VERSIONE)
    Select  bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_1_2_1,
            KM_INIZIO,
            KM_FINE,
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- CAT TEN SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
      When OTHERS Then
         p_error := SQLCODE;
         PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLCATTENNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
         Dbms_Output.Put_Line ('SetSOLCATTENNew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOLCATTENNew;
--
-- -----------------------------------------------------------------------------
--      Procedure SetSOLCATLINEANew - PAR_1_1_1_1_2_2_CAT_LINEA (1.1.1.1.2.2)
-- -----------------------------------------------------------------------------
--
 Procedure SetSOLCATLINEANew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- CAT LINEA SOL Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_2_CAT_LINEA bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
-- CAT LINEA SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_2_CAT_LINEA bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--		
 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLCATLINEANew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOLCATLINEANew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOLCATLINEANew;
--
-- -----------------------------------------------------------------------------
--       Procedure SetSOLCATCARICONew - PAR_1_1_1_1_2_4_CAP_CARICO (1.1.1.1.2.4)
-- -----------------------------------------------------------------------------
--
 Procedure SetSOLCATCARICONew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- CAT CARICO SOL Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_4_CAP_CARICO bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- CAT CARICO SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_4_CAP_CARICO bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLCATCARICONew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOLCATCARICONew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOLCATCARICONew;
--
-- -----------------------------------------------------------------------------
--   Procedure SetSOLPROFCASSEMNew - PAR_1_1_1_1_3_4_PROF_CAS_M (1.1.1.1.3.4)
-- -----------------------------------------------------------------------------
--
 Procedure SetSOLPROFCASSEMNew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- PROF CASSE M Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_3_4_PROF_CAS_M bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- PROF CASSE M versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_3_4_PROF_CAS_M bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOPROFCASSELNew '||SQLERRM,PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOLPROFCASSEMNew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOLPROFCASSEMNew;
--
-- -----------------------------------------------------------------------------
--   Procedure SetSOLPROFSEMIRIMNew - PAR_1_1_1_1_3_5_PROF_SEMI_R (1.1.1.1.3.5)
-- -----------------------------------------------------------------------------
--
 Procedure SetSOLPROFSEMIRIMNew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- PROF SEMI R Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_3_5_PROF_SEMI_R bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA ;
-- -----------------------------------------------------------------------------
--PROF SEMI R versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_3_5_PROF_SEMI_R bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLPROFSEMIRINew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOLPROFCASSEMNew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOLPROFSEMIRIMNew;
--
-- -----------------------------------------------------------------------------
--      Procedure SetSOLGRADIENTENew - PAR_1_1_1_1_3_6_GRADIENTE (1.1.1.1.3.6)
-- -----------------------------------------------------------------------------
--
 Procedure SetSOLGRADIENTENew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--Profili di gradiente Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_3_6_GRADIENTE bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Profili di gradiente versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_3_6_GRADIENTE bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLGRAIDENTENew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOLGRADIENTENew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOLGRADIENTENew;
--
-- -----------------------------------------------------------------------------
--      Procedure SetSOLGSMRFACNew - PAR_1_1_1_3_3_3_GSM_R_FAC (1.1.1.3.3.3)
-- -----------------------------------------------------------------------------
--
 Procedure SetSOLGSMRFACNew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- GSM R FAC Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_3_3_GSM_R_FAC bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- GSM R FAC versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_3_3_GSM_R_FAC bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLGSMRFACNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOLGSMRFACNew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOLGSMRFACNew;
--
-- -----------------------------------------------------------------------------
--     Procedure SetPOCATTENNew - PAR_1_2_1_0_2_1_CAT_TEN_PO (1.2.1.0.2.1)
-- -----------------------------------------------------------------------------
--
 Procedure SetPOCATTENNew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- CAT TEN PO Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_2_1_0_2_1_CAT_TEN_PO bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO b,
            Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r
      Where bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And r.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- CAT TEN PO versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_2_1_0_2_1_CAT_TEN_PO bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
            Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r
      Where bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And r.CODICE_VERSIONE = b.CODICE_VERSIONE
        And r.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOCATTENLNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetPOCATTENNew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetPOCATTENNew;
--
-- -----------------------------------------------------------------------------
--    Procedure SetPOCATLINEANew - PAR_1_2_1_0_2_2_CAT_LINEA (1.2.1.0.2.2)
-- -----------------------------------------------------------------------------
--
 Procedure SetPOCATLINEANew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- CAT LINEA PO Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_2_1_0_2_2_CAT_LINEA bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO b,
            Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r
      Where bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And r.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- CAT LINEA PO versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_2_1_0_2_2_CAT_LINEA bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_PO b,
            Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r
      Where bg.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2
        And r.CODICE_VERSIONE = b.CODICE_VERSIONE
        And r.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLCATLINEANew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetPOCATLINEANew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetPOCATLINEANew;
--
-- -----------------------------------------------------------------------------
--       Procedure SetPLATCATTENNew - PAR_1_2_1_0_6_3_CAT_TEN_PL (1.2.1.0.6.3)
-- -----------------------------------------------------------------------------
--
 Procedure SetPLATCATTENNew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- CAT TEN PLATFORM Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_2_1_0_6_3_CAT_TEN_PL bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
           (Select PO_TR_PLATFORM_1_2_1_0_6_2, r.SEDE_TECNICA
              From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO c,
                   Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r,
                   Rinf_Autorizzazioni_Evo.MARCIAPIEDI_BINARI_PO b
             Where c.PO_TRACK_1_2_1_0_0_2 = b.BINARIO_1
               And c.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
           Union
            Select PO_TR_PLATFORM_1_2_1_0_6_2, r.SEDE_TECNICA
              From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO c,
                   Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r,
                   Rinf_Autorizzazioni_Evo.MARCIAPIEDI_BINARI_PO b
             Where c.PO_TRACK_1_2_1_0_0_2 = b.BINARIO_2
               And c.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
           Union
            Select PO_TR_PLATFORM_1_2_1_0_6_2, r.SEDE_TECNICA
              From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO c,
                   Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r,
                   Rinf_Autorizzazioni_Evo.MARCIAPIEDI_BINARI_PO b
             Where c.PO_TRACK_1_2_1_0_0_2 = b.BINARIO_3
               And c.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
           Union
            Select PO_TR_PLATFORM_1_2_1_0_6_2, r.SEDE_TECNICA
              From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO c,
                   Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA r,
                   Rinf_Autorizzazioni_Evo.MARCIAPIEDI_BINARI_PO b
             Where c.PO_TRACK_1_2_1_0_0_2 = b.BINARIO_4
               And c.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2   ) b
--
      Where bg.PO_TR_PLATFORM_1_2_1_0_6_2 = b.PO_TR_PLATFORM_1_2_1_0_6_2
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And v.SEDE_TECNICA = b.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- CAT TEN PLATFORM versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_2_1_0_6_3_CAT_TEN_PL bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
           (Select PO_TR_PLATFORM_1_2_1_0_6_2, SEDE_TECNICA, b.CODICE_VERSIONE
              From Rinf_Pubblicati_Evo.BINARI_CORSA_PO c,                         --30/03/206 Modificato lo schema dati dei binari,perch?ra impostato erroneamente a RINF_AUTORIZZAZIONI_EVO (non trovava binari di riferimento delle vecchie versioni ed il parametro rimaneva vuoto)
                   Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
                   Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO b
             Where c.PO_TRACK_1_2_1_0_0_2 = b.BINARIO_1
               And c.CODICE_VERSIONE = b.CODICE_VERSIONE
               And c.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
               And c.CODICE_VERSIONE = r.CODICE_VERSIONE
           Union
            Select PO_TR_PLATFORM_1_2_1_0_6_2, SEDE_TECNICA, b.CODICE_VERSIONE
              From Rinf_Pubblicati_Evo.BINARI_CORSA_PO c,                         --30/03/206 Modificato lo schema dati dei binari,perch?ra impostato erroneamente a RINF_AUTORIZZAZIONI_EVO (non trovava binari di riferimento delle vecchie versioni ed il parametro rimaneva vuoto)
                   Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
                   Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO b
            Where c.PO_TRACK_1_2_1_0_0_2 = b.BINARIO_2
              And c.CODICE_VERSIONE = b.CODICE_VERSIONE
              And c.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
              And c.CODICE_VERSIONE = r.CODICE_VERSIONE
           Union
            Select PO_TR_PLATFORM_1_2_1_0_6_2, SEDE_TECNICA, b.CODICE_VERSIONE
              From Rinf_Pubblicati_Evo.BINARI_CORSA_PO c,                         --30/03/206 Modificato lo schema dati dei binari,perch?ra impostato erroneamente a RINF_AUTORIZZAZIONI_EVO (non trovava binari di riferimento delle vecchie versioni ed il parametro rimaneva vuoto)
                   Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
                   Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO b
            Where c.PO_TRACK_1_2_1_0_0_2 = b.BINARIO_3
               And c.CODICE_VERSIONE = b.CODICE_VERSIONE
               And c.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
               And c.CODICE_VERSIONE = r.CODICE_VERSIONE
           Union
            Select PO_TR_PLATFORM_1_2_1_0_6_2, SEDE_TECNICA, b.CODICE_VERSIONE
              From Rinf_Pubblicati_Evo.BINARI_CORSA_PO c,                         --30/03/206 Modificato lo schema dati dei binari,perch?ra impostato erroneamente a RINF_AUTORIZZAZIONI_EVO (non trovava binari di riferimento delle vecchie versioni ed il parametro rimaneva vuoto)
                   Rinf_Pubblicati_Evo.REL_PO_BINARI_CORSA r,
                   Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO b
            Where c.PO_TRACK_1_2_1_0_0_2 = b.BINARIO_4
               And c.CODICE_VERSIONE = b.CODICE_VERSIONE
               And c.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2
               And c.CODICE_VERSIONE = r.CODICE_VERSIONE   ) b
--
      Where bg.PO_TR_PLATFORM_1_2_1_0_6_2 = b.PO_TR_PLATFORM_1_2_1_0_6_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.CODICE_VERSIONE = p_versione -1
        And v.SEDE_TECNICA = b.SEDE_TECNICA;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLPLATCATTENNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetPOCATLINEANew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetPLATCATTENNew;
--
-- -----------------------------------------------------------------------------
--     Procedure SetSDCATTENNew - PAR_1_2_2_0_0_3_CAT_TEN_SD (1.2.2.0.0.3)
-- -----------------------------------------------------------------------------
--
 Procedure SetSDCATTENNew (p_versione Number, p_error Out Number) Is
 Begin
    p_error := 0;
--
-- CAT TEN PO Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_2_2_0_0_3_CAT_TEN_SD bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_RACCORDO_PO b
      Where bg.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- CAT TEN PO versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_2_2_0_0_3_CAT_TEN_SD bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO b
      Where bg.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSDCATTENNew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSDCATTENNew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSDCATTENNew;
-- 
/***** Nuove procedure per le tabelle multivalore introdotte con il Reg.777/2019 ****/
--
-- -----------------------------------------------------------------------------
--      Procedure SetSOL_LOCAVERSPEC_New - PAR_1_1_1_1_2_4_3_LOCAVERSPEC (1.1.1.1.2.4.3)
-- Localizzazione Ferroviaria di strutture che richiedono verifiche specifiche
-- -----------------------------------------------------------------------------
--
 Procedure SetSOL_LOCAVERSPEC_New (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- LOCAVERSPEC SOL Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_4_3_LOCAVERSPEC bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
-- LOCAVERSPEC SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_2_4_3_LOCAVERSPEC bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOL_LOCAVERSPEC_New '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOL_LOCAVERSPEC_New - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOL_LOCAVERSPEC_New;
--
-- -----------------------------------------------------------------------------
--    Procedure SetSOL_LOCASISTRTB_New - PAR_1_1_1_1_7_8_LOCA_SIST_RTB (1.1.1.1.7.8)
-- Localizzazione Ferroviaria di di sistema RTB a terra
-- -----------------------------------------------------------------------------
--
 Procedure SetSOL_LOCASISTRTB_New (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- LOCA SIST RTB SOL Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_7_8_LOCA_SIST_RTB bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
-- LOCA SIST RTB SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_1_7_8_LOCA_SIST_RTB bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOL_LOCASISTRTB_New '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOL_LOCASISTRTB_New - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOL_LOCASISTRTB_New;
--
-- -----------------------------------------------------------------------------
--    Procedure SetSOL_COMPETCS_New - PAR_1_1_1_3_2_9_COMP_ETCS (1.1.1.3.2.9)
--            Compatibilit?ol sistema ETCS
-- -----------------------------------------------------------------------------
--
 Procedure SetSOL_COMPETCS_New (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- COMP ETCS SOL Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_2_9_COMP_ETCS bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
-- COMP ETCS SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_2_9_COMP_ETCS bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOL_COMPETCS_New '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOL_COMPETCS_New - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOL_COMPETCS_New;
--
-- -----------------------------------------------------------------------------
--    Procedure SetSOL_RETIGSM_New - PAR_1_1_1_3_3_5_RETI_GSM_R (1.1.1.3.3.5)
--            reti GSM-R coperte da accordo di roaming
-- -----------------------------------------------------------------------------
--
 Procedure SetSOL_RETIGSM_New (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- Reti GSM-R SOL Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_3_5_RETI_GSM_R bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
-- RETI GSM-R SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_3_5_RETI_GSM_R bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOL_RETIGSM_New '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOL_RETIGSM_New - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOL_RETIGSM_New;
--
-- -----------------------------------------------------------------------------
--    Procedure SetSOL_COMPRADIOVOCE_New - PAR_1_1_1_3_3_9_RADIO_VOCE (1.1.1.3.3.9)
--            Compatibilit?el sistema radio - voce
-- -----------------------------------------------------------------------------
--
 Procedure SetSOL_COMPRADIOVOCE_New (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- COMP RADIO-VOCE SOL Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_3_9_RADIO_VOCE bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
-- COMP RADIO-VOCE SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_3_9_RADIO_VOCE bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOL_COMPRADIOVOCE_New '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOL_COMPRADIOVOCE_New - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOL_COMPRADIOVOCE_New;
--
-- -----------------------------------------------------------------------------
--    Procedure SetSOL_COMPRADIODATI_New - PAR_1_1_1_3_3_10_RADIO_DATI (1.1.1.3.3.10)
--            Compatibilit? del sistema radio - dati
-- -----------------------------------------------------------------------------
--
 Procedure SetSOL_COMPRADIODATI_New (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- COMP RADIO-DATI SOL Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_3_10_RADIO_DATI bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
-- COMP RADIO-DATI SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_3_10_RADIO_DATI bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOL_COMPRADIODATI_New '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOL_COMPRADIODATI_New - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOL_COMPRADIODATI_New;
--
-- -----------------------------------------------------------------------------
--    Procedure SetSOL_SISTPREPROT_New - PAR_1_1_1_3_5_3_SIST_PRE_PROT (1.1.1.3.5.3)
--            Sistema presistente di protezione del treno
-- -----------------------------------------------------------------------------
--
 Procedure SetSOL_SISTPREPROT_New (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- SIST_PRE_PROT SOL Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_5_3_SIST_PRE_PROT bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
-- SIST_PRE_PROT SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_5_3_SIST_PRE_PROT bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOL_SISTPREPROT_New '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOL_SISTPREPROT_New - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOL_SISTPREPROT_New;
--
-- -----------------------------------------------------------------------------
--    Procedure SetSOL_SISRILDOC_New - PAR_1_1_1_3_7_1_3_SISTRILTRAIN (1.1.1.3.7.1.3)
-- Documento riportante la/le procedura/e relativa/e ai tipi di sistema di rilevamento del treno
-- -----------------------------------------------------------------------------
--
 Procedure SetSOL_SISRILDOC_New (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- SIS_RIL_DOC SOL Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_7_1_3_SISTRILTRAIN bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
-- SIS_RIL_DOC SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_7_1_3_SISTRILTRAIN bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOL_SISRILDOC_New '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOL_SISRILDOC_New - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOL_SISRILDOC_New;
--
-- -----------------------------------------------------------------------------
--    Procedure SetSOL_CARMINASSE_New - PAR_1_1_1_3_7_11_1_CARMIN_ASSE (1.1.1.3.7.11.1)
-- Carico Minimo consentito per asse per categoria di veicoli
-- -----------------------------------------------------------------------------
--
 Procedure SetSOL_CARMINASSE_New (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- CARMIN_ASSE SOL Nuovi
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
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_7_11_1_CARMIN_ASSE bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA ;
--
-- -----------------------------------------------------------------------------
-- CARMIN_ASSE SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_3_7_11_1_CARMIN_ASSE bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;

 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOL_CARMINASSE_New '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOL_CARMINASSE_New - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOL_CARMINASSE_New;
--
-- -----------------------------------------------------------------------------
--    Procedure SetSOL_NORMEDOC_New - PAR_1_1_1_4_2_NORME_DOC (1.1.1.4.2)
-- Documenti relativi a norme e restrizioni di natura strettamente locale messi a disposizione dal GI
-- -----------------------------------------------------------------------------
--
 Procedure SetSOL_NORMEDOC_New (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- NORME_DOC SOL Nuovi
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
     Select bg.SOL_TRACK_1_1_1_0_0_1,
            SOL_TRACK_1_1_1_4_2,
            KM_INIZIO,
            KM_FINE,
            LATITUDINE_INIZIO,
            LONGITUDINE_INIZIO,
            LATITUDINE_FINE,
            LONGITUDINE_FINE,
            FLAG_CALCOLATO,
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_1_1_4_2_NORME_DOC bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1
        And b.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- NORME_DOC SOL versione precedente
-- -----------------------------------------------------------------------------
--
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
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_1_1_4_2_NORME_DOC bg,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v,
            Rinf_Pubblicati_Evo.BINARI_CORSA_SOL b
      Where bg.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1
        And bg.CODICE_VERSIONE = b.CODICE_VERSIONE
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.SEDE_TECNICA = v.SEDE_TECNICA
        And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOL_NORMEDOC_New '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOL_NORMEDOC_New - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSOL_NORMEDOC_New;
--
-- -----------------------------------------------------------------------------
--    Procedure SetPO_NORMEDOC_New - PAR_1_2_3_2_DOC_norme (1.2.3.2)
-- Punto Operativo - Norme e restrizioni
-- Documenti relativi a norme e restrizioni di natura strettamente locale messi a disposizione dal GI
-- -----------------------------------------------------------------------------
--
 Procedure SetPO_NORMEDOC_New (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- NORME_DOC PO Nuovi
     Insert Into Rinf_Pubblicati_Evo.PAR_1_2_3_2_DOC_norme
             (SEDE_TECNICA, PO_1_2_3_2, CODICE_VERSIONE)
     Select b.SEDE_TECNICA, PO_1_2_3_2, v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.PAR_1_2_3_2_DOC_norme b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where b.SEDE_TECNICA = v.SEDE_TECNICA
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 1;
--
-- -----------------------------------------------------------------------------
-- NORME_DOC PO versione precedente
-- -----------------------------------------------------------------------------
--
     Insert Into Rinf_Pubblicati_Evo.PAR_1_2_3_2_DOC_norme
             (SEDE_TECNICA, PO_1_2_3_2, CODICE_VERSIONE)
     Select b.SEDE_TECNICA, PO_1_2_3_2, v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.PAR_1_2_3_2_DOC_norme b,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where b.SEDE_TECNICA = v.SEDE_TECNICA
        And v.CODICE_VERSIONE = p_versione
        And v.FLAG_NEW = 0
        And b.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
      When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetPO_NORMEDOC_New '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetPO_NORMEDOC_New - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetPO_NORMEDOC_New;
--
-- -----------------------------------------------------------------------------
--    Procedure SetSOLLineNew (CORRIDOIO_SOL, LINEE_TENT_SOL, LINEA_COMM_SOL, LINEA_FCL_SOL, FASCICOLO_SOL)
-- -----------------------------------------------------------------------------
--
 Procedure SetSOLLineNew (p_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- Relazioni SOL-Corridoi Nuove (CORRIDOIO_SOL)
    Insert Into Rinf_Pubblicati_Evo.CORRIDOIO_SOL
           (CODICE_CORRIDOIO, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_CORRIDOIO,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.CORRIDOIO_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 1 
		And p.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Relazioni SOL-Corridoi Versione precedente (CORRIDOIO_SOL)
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.CORRIDOIO_SOL
           (CODICE_CORRIDOIO, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_CORRIDOIO,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.CORRIDOIO_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 0 
		And p.SEDE_TECNICA = v.SEDE_TECNICA 
		And p.CODICE_VERSIONE = p_versione -1;
--
-- -----------------------------------------------------------------------------
-- Relazioni SOL-Linee Ten Nuove (LINEE_TENT_SOL)
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.LINEE_TENT_SOL
           (CODICE_LINEA_TENT, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_LINEA_TENT,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.LINEE_TENT_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 1 
		And p.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Relazioni SOL-Linee Ten versione precedente (LINEE_TENT_SOL)
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.LINEE_TENT_SOL
           (CODICE_LINEA_TENT, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_LINEA_TENT,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.LINEE_TENT_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 0 
		And p.SEDE_TECNICA = v.SEDE_TECNICA 
		And p.CODICE_VERSIONE = p_versione -1;
--
-- -----------------------------------------------------------------------------
--Relazione SOL-Linee Comm nuove (LINEA_COMM_SOL)
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.LINEA_COMM_SOL
           (CODICE_GIURISDIZIONE, SEDE_TECNICA, CODICE_VERSIONE, KM_INIZIO, KM_FINE)
     Select CODICE_GIURISDIZIONE,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE,
            KM_INIZIO, 
			KM_FINE
       From Rinf_Autorizzazioni_Evo.LINEA_COMM_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 1 
		And p.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Relazione SOL-Linee Comm versione precedente (LINEA_COMM_SOL)
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.LINEA_COMM_SOL
           (CODICE_GIURISDIZIONE, SEDE_TECNICA, CODICE_VERSIONE, KM_INIZIO, KM_FINE)
     Select CODICE_GIURISDIZIONE,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE,
            KM_INIZIO, 
			KM_FINE
       From Rinf_Pubblicati_Evo.LINEA_COMM_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 0 
		And p.SEDE_TECNICA = v.SEDE_TECNICA 
		And p.CODICE_VERSIONE = p_versione -1;
--
-- -----------------------------------------------------------------------------
-- Relazione SOL-Linee FCL Nuove (LINEA_FCL_SOL)
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.LINEA_FCL_SOL
           (CODICE_LINEA_FCL, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_LINEA_FCL,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.LINEA_FCL_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 1 
		And p.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Relazione SOL-Linee FCL versione precedente (LINEA_FCL_SOL)
-- -----------------------------------------------------------------------------
--

    Insert Into Rinf_Pubblicati_Evo.LINEA_FCL_SOL
           (CODICE_LINEA_FCL, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_LINEA_FCL,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.LINEA_FCL_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 0 
		And p.SEDE_TECNICA = v.SEDE_TECNICA 
		And p.CODICE_VERSIONE = p_versione -1;
--
-- -----------------------------------------------------------------------------
-- Relazione SOL-Fasciolo Linea Nuove (FASCICOLO_SOL)
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.FASCICOLO_SOL
           (CODICE_FASCICOLO, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_FASCICOLO,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE
       From Rinf_Autorizzazioni_Evo.FASCICOLO_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 1 
		And p.SEDE_TECNICA = v.SEDE_TECNICA;
--
-- -----------------------------------------------------------------------------
-- Relazione SOL-Fasciolo Linea versione precedente (FASCICOLO_SOL)
-- -----------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.FASCICOLO_SOL
           (CODICE_FASCICOLO, SEDE_TECNICA, CODICE_VERSIONE)
     Select CODICE_FASCICOLO,
            p.SEDE_TECNICA,
            v.CODICE_VERSIONE
       From Rinf_Pubblicati_Evo.FASCICOLO_SOL p,
            Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI v
      Where v.CODICE_VERSIONE = p_versione 
	    And v.FLAG_NEW = 0 
		And p.SEDE_TECNICA = v.SEDE_TECNICA 
		And p.CODICE_VERSIONE = p_versione -1;
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetSOLLINENew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetSOLLineNew - Errore: '|| Substr(SQLERRM, 1, 300));
END SetSOLLineNew;
--
--
-- -----------------------------------------------------------------------------
--                  PROCEDURE PER LA PUBBLICAZIONE DEI DATI
-- -----------------------------------------------------------------------------
--     Procedure SetPubblicationDetail - Nuova versione per la gestione delle SC
-- -----------------------------------------------------------------------------
--
  Procedure SetPubblicationDetail (n_versione Number, p_codice_autorizzazione Number, p_error Out Number) Is
--
  p_sede_tecnica varchar2(6);
  V_Definizione varchar2(200);
--
-- cursore per estrarre l'elenco delle SOL e PO presenti nella CLASSE_ELIMINATI e REGISTRO_SEDI_ELIMINATE_NUOVE
--
  Cursor cur_eliminati is 
    select SEDE_TECNICA, STATO_SISTEMA, STATO_UTENTE , 0 FLAG_TIPO
	  From Rinf_Staging_Evo.CLASSE_ELIMINATI
---> aggiunta la clausola per le ST non eliminate per consistenza della tripletta Tratta-PO
--->     where SEDE_TECNICA not in (SELECT SEDE_TECNICA from Rinf_autorizzazioni_evo.PUNTI_OPERATIVI union SELECT SEDE_TECNICA from Rinf_autorizzazioni_evo.SEZIONI_LINEA)
--->
   Union 
    ( Select SEDE_TECNICA, STATO_SISTEMA, STATO_UTENTE, FLAG_TIPO
	   From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE
	  Where CODICE_VERSIONE = n_versione -1 
	    And FLAG_TIPO = -1 
		And FLAG_STATO_FINALE = 0
        And SEDE_TECNICA not in
	         (SELECT SEDE_TECNICA from Rinf_Controllati_Evo.PUNTI_OPERATIVI 
	           union 
			  SELECT SEDE_TECNICA from Rinf_Controllati_Evo.SEZIONI_LINEA
--	   (SELECT SEDE_TECNICA from Rinf_Lavorazione_Evo.PUNTI_OPERATIVI 
--	      union 
--	    SELECT SEDE_TECNICA from Rinf_Lavorazione_Evo.SEZIONI_LINEA
		  union
		SELECT SEDE_TECNICA From Rinf_Staging_Evo.CLASSE_ELIMINATI)
	  );

--		
-- cursore per estrarre l'elenco delle SOL e PO presenti nella CLASSE_ELIMINATI che non sono stati cancellati per la consistenza delle triplette
--
  Cursor cur_non_eliminati is 

    select SEDE_TECNICA 
	  From Rinf_Staging_Evo.CLASSE_ELIMINATI                                                                       
     where SEDE_TECNICA in (SELECT SEDE_TECNICA from Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI 
	                         union 
							SELECT SEDE_TECNICA from Rinf_Autorizzazioni_Evo.SEZIONI_LINEA);

--
-- Cursore per estrarre i PO di nuova istituzione
--   
  Cursor cur_op_new is    
    Select SEDE_TECNICA From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI
     Minus
    Select SEDE_TECNICA from Rinf_Pubblicati_Evo.PUNTI_OPERATIVI Where CODICE_VERSIONE = n_versione -1;
--
-- Cursore per estrarre SOL di nuova istituzione
--   
 Cursor cur_sol_new is    
    Select SEDE_TECNICA From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
     Minus
    Select SEDE_TECNICA from Rinf_Pubblicati_Evo.SEZIONI_LINEA Where CODICE_VERSIONE = n_versione -1;
--
-- --------------------------------------------------------------------------------------------------
--                                              Main
-- --------------------------------------------------------------------------------------------------
--
  Begin
    p_error := 0;


-- Parte 1 - Gestione autorizzazioni da parte del territorio (DOIT territoriali) - ST Autorizzate
-- ------------------------------------------------------------------------------------------------------------------------------------
-- 1) Inserisco in RINF_PUBBLICATI_EVO.VERSIONE_AUTORIZZAZIONI le localit? ("SEDE_TECNICA") dei PUNTI OPERATIVI appartenenti alle DOIT Territoriali 
-- che hanno autorizzato e che provengono dall'acquisizione - area dati "RI-autorizzazioni". 
-- N.B. Le sedi tecniche, delle DOIT che hanno autorizzato, presenti in CLASSE_ELIMINATI sono stati depennati nella fase precedente. 
-- Quindi, non sono presenti nelle tabelle di Autorizzazione. I Punti Operativi, di nuova istituzione, sono inclusi nell'elenco
-- ------------------------------------------------------------------------------------------------------------------------------------
-- caso 1 (Autorizzazioni dei Punti Operativi)

    Insert Into Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI
    (CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP, SEDE_TECNICA, CODICE_CONTROLLO, FLAG_NEW, FLAG_DTEC, FLAG_DTEC_2, FLAG_DTEC_3, FLAG_DCO, FLAG_DSPS)
--
     Select n_versione,
	        v.CODICE_RICHIESTA codice_autorizzazione,
			p.CODICE_DTP, 
			p.SEDE_TECNICA,
			p.CODICE_CONTROLLO,
			Decode (FLAG_NEW_TERRITORIO, 2, 1, 1, 0) flag_new,
			Decode (FLAG_DTEC,           2, 1, 1, 0) FLAG_DTEC,
			Decode (FLAG_DTEC_2,         2, 1, 1, 0) FLAG_DTEC_2,
			Decode (FLAG_DTEC_3,         2, 1, 1, 0) FLAG_DTEC_3,
			Decode (FLAG_DCO,            2, 1, 1, 0) FLAG_DCO,
			Decode (FLAG_DSPS,           2, 1, 1, 0) FLAG_DSPS
       From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI p,
            Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
      Where p.CODICE_DTP = v.CODICE_DTP 
		And v.CODICE_RICHIESTA = p_codice_autorizzazione
	    And FLAG_NEW_TERRITORIO = 2                                  ---> clausola solo per le DOIT territoriali
--
    Minus                                                           -- per eliminare le nuove OP non autorizzate da DCO 
	 Select n_versione,
	        v.CODICE_RICHIESTA,
			p.CODICE_DTP, 
			p.SEDE_TECNICA,
			p.CODICE_CONTROLLO,
			Decode (FLAG_NEW_TERRITORIO, 2, 1, 1, 0) flag_new,
			Decode (FLAG_DTEC,           2, 1, 1, 0) FLAG_DTEC,
			Decode (FLAG_DTEC_2,         2, 1, 1, 0) FLAG_DTEC_2,
			Decode (FLAG_DTEC_3,         2, 1, 1, 0) FLAG_DTEC_3,
			Decode (FLAG_DCO,            2, 1, 1, 0) FLAG_DCO,
			Decode (FLAG_DSPS,           2, 1, 1, 0) FLAG_DSPS
       From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI  p,
            Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
      Where p.CODICE_DTP = v.CODICE_DTP 
		And v.CODICE_RICHIESTA = p_codice_autorizzazione
		And (Not Exists (Select SEDE_TECNICA From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI s 
		                  Where s.SEDE_TECNICA = p.Sede_Tecnica 
						    And CODICE_VERSIONE = n_versione -1)) --   PO non presenti in precedente Pubblicazione quindi, NUOVE ST 
		And FLAG_NEW_TERRITORIO = 2                               ---> clausola solo per le DOIT territoriali che hanno autorizzato 
	    And FLAG_DCO = 1  	;	                                  ---> e contemporaneamente, DCO non ha autorizzato

		 Dbms_Output.Put_Line('Punti operativi appartenenti alle DTP che hanno autorizzato. Record inseriti: ' || SQL%ROWCOUNT);
--
-- ------------------------------------------------------------------------------------------------------------------------------------
-- Inserisco in RINF_PUBBLICATI_EVO.VERSIONE_AUTORIZZAZIONI le Tratte ("SEDE_TECNICA") delle SEZIONI di LINEA appartenenti alle DOIT Territoriali 
-- che hanno autorizzato e che provengono dall'acquisizione - area dati "RI-autorizzazioni" 
-- ------------------------------------------------------------------------------------------------------------------------------------
-- caso 2 (SOL)
--
    Insert Into Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI
   (CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP, SEDE_TECNICA, CODICE_CONTROLLO, FLAG_NEW, FLAG_DTEC, FLAG_DTEC_2, FLAG_DTEC_3, FLAG_DCO, FLAG_DSPS)
--
     Select n_versione,
	        v.CODICE_RICHIESTA,
			p.CODICE_DTP, 
			p.SEDE_TECNICA,
			p.CODICE_CONTROLLO,
			Decode (FLAG_NEW_TERRITORIO, 2, 1, 1, 0) flag_new,
			Decode (FLAG_DTEC,           2, 1, 1, 0) FLAG_DTEC,
			Decode (FLAG_DTEC_2,         2, 1, 1, 0) FLAG_DTEC_2,
			Decode (FLAG_DTEC_3,         2, 1, 1, 0) FLAG_DTEC_3,
			Decode (FLAG_DCO,            2, 1, 1, 0) FLAG_DCO,
			Decode (FLAG_DSPS,           2, 1, 1, 0) FLAG_DSPS
       From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA  p,
            Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
      Where p.CODICE_DTP = v.CODICE_DTP 
		And v.CODICE_RICHIESTA = p_codice_autorizzazione
		And FLAG_NEW_TERRITORIO = 2                                  ---> clausola solo per le DOIT territoriali
--
    Minus                                                           -- per eliminare le nuove TR non autorizzate da DCO 
	 Select n_versione,
	        v.CODICE_RICHIESTA,
			p.CODICE_DTP, 
			p.SEDE_TECNICA,
			p.CODICE_CONTROLLO,
			Decode (FLAG_NEW_TERRITORIO, 2, 1, 1, 0) flag_new,
			Decode (FLAG_DTEC,           2, 1, 1, 0) FLAG_DTEC,
			Decode (FLAG_DTEC_2,         2, 1, 1, 0) FLAG_DTEC_2,
			Decode (FLAG_DTEC_3,         2, 1, 1, 0) FLAG_DTEC_3,
			Decode (FLAG_DCO,            2, 1, 1, 0) FLAG_DCO,
			Decode (FLAG_DSPS,           2, 1, 1, 0) FLAG_DSPS
       From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA  p,
            Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
      Where p.CODICE_DTP = v.CODICE_DTP 
		And v.CODICE_RICHIESTA = p_codice_autorizzazione
		And (Not Exists (Select SEDE_TECNICA From Rinf_Pubblicati_Evo.SEZIONI_LINEA s 
		                  Where s.SEDE_TECNICA = p.Sede_Tecnica 
						    And CODICE_VERSIONE = n_versione -1)) --   PO non presenti in precedente Pubblicazione
		And FLAG_NEW_TERRITORIO = 2                               ---> clausola solo per le DOIT territoriali
	    And FLAG_DCO = 1  ;		                                  ---> DCO non ha autorizzato

--
		 Dbms_Output.Put_Line('Sezioni Linea appartenenti alle DTP che hanno autorizzato. Record inseriti: ' || SQL%ROWCOUNT);
--
--
-- caso 3 - DOIT territoriali che NON hanno Autorizzato 
-- ------------------------------------------------------------------------------------------------------------------------------------
-- Si aggiungono in RINF_PUBBLICATI_EVO.VERSIONE_AUTORIZZAZIONI le rimanenti SEDI TECNICHE sia OP che SOL 
-- appartenenti alle DOIT Territoriali che NON hanno autorizzato recuperando le informazioni dall'ultima versione Pubblicata presente in RI-Pronti
-- N.B. Le nuove SEDI TECNICHE (presenti nella nuova acquisizione) e, contenute nella DOIT Territoriale che non ha autorizzato, non sono incluse nell'elenco 
--      Le SEDI TECNICHE presenti in CLASSE_ELIMINATI che sarebbero ripristinate vengono escluse (CASO 2 della SRE)
-- ------------------------------------------------------------------------------------------------------------------------
--
    Insert Into Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI
   (CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP, SEDE_TECNICA, CODICE_CONTROLLO, FLAG_NEW, FLAG_DTEC, FLAG_DTEC_2, FLAG_DTEC_3, FLAG_DCO, FLAG_DSPS)
--
    Select  n_versione,
	        p.CODICE_AUTORIZZAZIONE,
			p.CODICE_DTP, 
			p.SEDE_TECNICA,
			p.CODICE_CONTROLLO,
			Decode (v.FLAG_NEW_TERRITORIO, 2, 1, 1, 0) FLAG_NEW,
			Decode (v.FLAG_DTEC,           2, 1, 1, 0) FLAG_DTEC,
			Decode (v.FLAG_DTEC_2,         2, 1, 1, 0) FLAG_DTEC_2,
			Decode (v.FLAG_DTEC_3,         2, 1, 1, 0) FLAG_DTEC_3,
			Decode (v.FLAG_DCO,            2, 1, 1, 0) FLAG_DCO,
			Decode (v.FLAG_DSPS,           2, 1, 1, 0) FLAG_DSPS
       From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI p,
            Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
      Where p.CODICE_DTP  = v.CODICE_DTP 
        And v.FLAG_NEW_TERRITORIO = 1                                ---> solo per le DOIT territoriali
        And v.CODICE_RICHIESTA = p_codice_autorizzazione
        And CODICE_VERSIONE = n_versione -1
        And Not exists (Select e.SEDE_TECNICA From Rinf_Staging_Evo.CLASSE_ELIMINATI e Where e.SEDE_TECNICA = p.SEDE_TECNICA) ;
--
--        
		 Dbms_Output.Put_Line('Sedi Tecniche (SOL e OP) appartenenti alle DTP che Non hanno autorizzato. Record totali inseriti: ' || SQL%ROWCOUNT);
--		 

/******************************************************************************************************************************/
-- Parte seconda - Gestione delle ST nuove ed eliminate, sulla base dell autorizzazioni di Sede Centrale:
-- CLASSE_ELIMINATI e Nuove "SEDE_TECNICA" sulla base dello schema autorizzativo
/******************************************************************************************************************************/
--
--                                  CLASSE ELIMINATI:
--
  For Rec_eliminati In cur_eliminati Loop 

      p_sede_tecnica := Rec_eliminati.SEDE_TECNICA;

	  Dbms_Output.Put_Line('Sede Tecnica presente in CLASSE_ELIMINATI: '||p_sede_tecnica);

	If substr(p_sede_tecnica, 1, 2) = 'TR' Then 

	  Begin
	    Select Distinct DEFINIZIONE Into v_definizione From Rinf_Pubblicati_Evo.SEZIONI_LINEA 
	     Where CODICE_VERSIONE = (Select Max(CODICE_VERSIONE)-1 From Rinf_Pubblicati_Evo.VERSIONE_RINF)
           And SEDE_TECNICA = p_sede_tecnica; 
	EXCEPTION
	  When NO_DATA_FOUND Then 
	       v_definizione:= Null;
	   Dbms_Output.Put_Line('Non trovata la definizione della Sede Tecnica presente in CLASSE_ELIMINATI: '||p_sede_tecnica);
	  End; 

	Else 

	  Begin

        Select Distinct DEFINIZIONE Into v_definizione From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI 
	     Where CODICE_VERSIONE = (Select Max(CODICE_VERSIONE)-1 From Rinf_Pubblicati_Evo.VERSIONE_RINF)
           And SEDE_TECNICA = p_sede_tecnica;
	  EXCEPTION
	   When NO_DATA_FOUND Then 
	        v_definizione:= Null;
	   Dbms_Output.Put_Line('Non trovata la definizione della Sede Tecnica presente in CLASSE_ELIMINATI: '||p_sede_tecnica);
	   End; 

    End If;

	Dbms_Output.Put_Line('Definizione della Sede Tecnica '||p_sede_tecnica||' presente in CLASSE_ELIMINATI: '||v_definizione);
-- --------------------------------------------------------------------------------------------------------------------
--  inserimento nel Registro delle ST che sono presenti nella CLASSE_ELIMINATI  
-- --------------------------------------------------------------------------------------------------------------------

    Insert Into Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE   
   (CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP, SEDE_TECNICA, 
    DEFINIZIONE, FLAG_TIPO, ST_TIPOLOGIA, DATA_INSERIMENTO, FLAG_STATO_FINALE, STATO_FINALE, DATA_AGGIORNAMENTO, CODICE_VERSIONE_PUB
	, DOIT, DCO, STATO_SISTEMA, STATO_UTENTE
	)
    Select  n_Versione,
            v.CODICE_RICHIESTA,       --	    p.CODICE_AUTORIZZAZIONE,
    		p.CODICE_DTP, 
    		p.SEDE_TECNICA,
			v_DEFINIZIONE,
    		-1 FLAG_TIPO,      --  -1: ST eliminata
--    		0 FLAG_TIPO,      --  0: ST eliminata (alternativa)
			'ST da eliminare' ST_TIPOLOGIA,
            sysdate DATA_INSERIMENTO, 
    		Case v.FLAG_DCO 
			     When 1 Then 0 
                 Else 1 End  FLAG_STATO_FINALE, 
   		     Case v.FLAG_DCO 
			     When 1 Then 'ripristinata'  
                 Else 'eliminata' End  STATO_FINALE, 
    		Case v.FLAG_DCO 
			     When 1 Then Null 
				 Else Sysdate End DATA_AGGIORNAMENTO, 
    		Case v.FLAG_DCO 
			     When 1 Then Null  
--				 Else p.CODICE_VERSIONE End CODICE_VERSIONE_PUB,
				 Else n_Versione End CODICE_VERSIONE_PUB,				 
			Case v.FLAG_NEW_TERRITORIO 
			     When 1 Then 'Non Autorizzata'  
			     When 2 Then 'Autorizzata'  				 
				 Else Null End DOIT,
			Case v.FLAG_DCO 
			     When 1 Then 'Non Autorizzata'  
			     When 2 Then 'Autorizzata'  				 
				 Else Null End DCO,
--            ce.STATO_SISTEMA, 
--			ce.STATO_UTENTE
            Rec_eliminati.STATO_SISTEMA,             
			Rec_eliminati.STATO_UTENTE
	   From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI p,
	        Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
--			,		Rinf_Staging_Evo.CLASSE_ELIMINATI ce
      Where p.CODICE_DTP  = v.CODICE_DTP 
  		And v.CODICE_RICHIESTA = p_Codice_Autorizzazione
        And p.CODICE_VERSIONE = n_Versione -1	
--		And p.SEDE_TECNICA = ce.SEDE_TECNICA
        And p.SEDE_TECNICA = p_sede_tecnica; 
--			
	Dbms_Output.Put_Line('Inserimento della ST '||p_sede_tecnica||' in REGISTRO_SEDI_ELIMINATE_NUOVE');

-- --------------------------------------------------------------------------------------------------------------------
--   caso 3: se DCO NON ha autorizzato, le Sedi Tecniche presenti in CLASSE_ELIMINATI che,
--   indipendentemente se DOIT ha autorizzato o meno, non sono presenti nell'elenco finora prodotto,
--   vanno ripristinate, recuperandole dall'ultima Pubblicazione, per non avere buchi
-- --------------------------------------------------------------------------------------------------------------------

     Insert Into Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI
   (CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP, SEDE_TECNICA, CODICE_CONTROLLO, FLAG_NEW, FLAG_DTEC, FLAG_DTEC_2, FLAG_DTEC_3, FLAG_DCO, FLAG_DSPS)
--
    Select  n_Versione,
	        p.CODICE_AUTORIZZAZIONE,
			p.CODICE_DTP, 
			p.SEDE_TECNICA,
			p.CODICE_CONTROLLO,
			Decode (v.FLAG_NEW_TERRITORIO, 2, 1, 1, 0) flag_new,
			Decode (v.FLAG_DTEC,           2, 1, 1, 0) FLAG_DTEC,
			Decode (v.FLAG_DTEC_2,         2, 1, 1, 0) FLAG_DTEC_2,
			Decode (v.FLAG_DTEC_3,         2, 1, 1, 0) FLAG_DTEC_3,
			Decode (v.FLAG_DCO,            2, 1, 1, 0) FLAG_DCO,
			Decode (v.FLAG_DSPS,           2, 1, 1, 0) FLAG_DSPS
       From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI p,
            Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
      Where p.CODICE_DTP  = v.CODICE_DTP 
		And p.SEDE_TECNICA = p_Sede_Tecnica
--->        And v.FLAG_NEW_TERRITORIO = 2                                ---> la DOIT territoriale ha autorizzato (quindi la sede_tecnica era stata eliminata in precedenza)
        And v.FLAG_DCO < 2                                               ---> DCO non ha autorizzato                              
		And v.CODICE_RICHIESTA = p_Codice_Autorizzazione
        And p.CODICE_VERSIONE = n_Versione -1	
		And Not Exists (Select SEDE_TECNICA From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI Where SEDE_TECNICA = p.Sede_Tecnica 
		                   And CODICE_VERSIONE = n_Versione);  -- controlla che non sia gi? presente
--
	 Dbms_Output.Put_Line('Sedi Tecniche Eliminate da ripubblicare. '||p_Sede_Tecnica||' - Record inseriti: ' || SQL%ROWCOUNT);

   End Loop;

    For Rec_non_eliminati In cur_non_eliminati Loop 

        p_sede_tecnica := Rec_non_eliminati.SEDE_TECNICA;

        Update Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE
		   Set FLAG_STATO_FINALE = 0,
		       STATO_FINALE = 'Non Eliminata',
			   DATA_AGGIORNAMENTO = Null,
			   CODICE_VERSIONE_PUB = Null
         Where CODICE_VERSIONE = n_Versione
		   And SEDE_TECNICA = p_sede_tecnica;
--		
	    Dbms_Output.Put_Line('Sede Tecnica in CLASSE_ELIMINATI ma non eliminata per consistenza tripletta SOL-OP: '||p_sede_tecnica);
   End Loop;  


-- NUOVE ST (non presenti in DOIT n-1):
-- --------------------------------------------------------------------------------------------------------------------------------------
-- caso 2: se la Sede Centrale DCO ha autorizzato, vanno aggiunte anche le localit? ("SEDE_TECNICA") di nuova istituzione (non presenti in precedenza) 
-- che la DOIT Territoriale NON ha autorizzato. 
-- Andranno valorizzati solo i parametri obbligatori (SKELETON)
-- il caso 8 (sia T che DCO non autorizzano) ? gi? contemplato nel caso 2
-- --------------------------------------------------------------------------------------------------------------------------------------
-- PUNTI_OPERATIVI 
--
   For Rec_op_new in Cur_op_new loop
       p_Sede_Tecnica := rec_op_new.SEDE_TECNICA;

	If substr(p_sede_tecnica, 1, 2) = 'LO' Then 
--	
	  Begin

        Select Distinct DEFINIZIONE Into v_definizione From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI
	     Where SEDE_TECNICA = p_sede_tecnica;
--
	  EXCEPTION
	   When NO_DATA_FOUND Then 
	        v_definizione:= Null;
	        Dbms_Output.Put_Line('Non trovata la definizione della Nuova Sede Tecnica: '||p_sede_tecnica);

	   End; 

    End If;
--
	 Dbms_Output.Put_Line('Sede Tecnica di Nuova Istituzione: ' ||p_Sede_Tecnica|| ' -  ' ||v_definizione);


-- --------------------------------------------------------------------------------------------------------------------
--  inserimento nel registro delle ST dei nuovi Punti Operativi 
-- --------------------------------------------------------------------------------------------------------------------

    Insert Into Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE    
  (CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP, SEDE_TECNICA, 
    DEFINIZIONE, FLAG_TIPO, ST_TIPOLOGIA, DATA_INSERIMENTO, FLAG_STATO_FINALE, STATO_FINALE, DATA_AGGIORNAMENTO, CODICE_VERSIONE_PUB
	, DOIT, DCO, STATO_SISTEMA, STATO_UTENTE
	)

    Select  n_Versione,
    	    v.CODICE_RICHIESTA CODICE_AUTORIZZAZIONE,
    		p.CODICE_DTP, 
    		p.SEDE_TECNICA,
			p.DEFINIZIONE,
    		1 FLAG_TIPO,      --  1: ST nuova
			'ST nuova' ST_TIPOLOGIA,
            sysdate DATA_INSERIMENTO, 
    		Case v.FLAG_DCO 
			     When 1 Then 0 
                 Else Case  v.FLAG_NEW_TERRITORIO
				      When 1 Then 9 
                      Else 1 End
				 End  FLAG_STATO_FINALE,  
 		Case v.FLAG_DCO 
			     When 1 Then 'non pubblicata' 
 --                Else 1 End  STATO_FINALE, 
                 Else Case  v.FLAG_NEW_TERRITORIO
				      When 1 Then 'skeleton' 
                      Else 'pubblicata' End
				 End  STATO_FINALE, 
        Case v.FLAG_DCO  
			     When 1 Then Null 
				 Else Sysdate End DATA_AGGIORNAMENTO, 
    		Case v.FLAG_DCO 
			     When 1 Then Null  
				 Else n_Versione End CODICE_VERSIONE_PUB,
			Case v.FLAG_NEW_TERRITORIO 
			     When 1 Then 'Non Autorizzata'  
			     When 2 Then 'Autorizzata'  				 
				 Else Null End DOIT,
			Case v.FLAG_DCO 
			     When 1 Then 'Non Autorizzata'  
			     When 2 Then 'Autorizzata'  				 
				 Else Null End DCO,
				 Null, 
				 Null
	   From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI p,
	        Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
      Where p.CODICE_DTP  = v.CODICE_DTP 
        And p.SEDE_TECNICA = p_Sede_Tecnica
  		And v.CODICE_RICHIESTA = p_Codice_Autorizzazione; 
--
	Dbms_Output.Put_Line('Inserimento della ST '||p_sede_tecnica||' in REGISTRO_SEDI_ELIMINATE_NUOVE');

-- ---------------------------------------------------------------------------- 
--    Insert Into Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI
-- ---------------------------------------------------------------------------- 
--
     Insert Into Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI
    (CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP, SEDE_TECNICA, CODICE_CONTROLLO, FLAG_NEW, FLAG_DTEC, FLAG_DTEC_2, FLAG_DTEC_3, FLAG_DCO, FLAG_DSPS)
--
     Select n_Versione,
	        v.CODICE_RICHIESTA CODICE_AUTORIZZAZIONE,
			p.CODICE_DTP, 
			p.SEDE_TECNICA,
			p.CODICE_CONTROLLO,
--			Decode (FLAG_NEW_TERRITORIO, 2, 1, 1, 0) flag_new,
			9 FLAG_NEW,                                             --->SKELETON
			Decode (FLAG_DTEC,           2, 1, 1, 0) FLAG_DTEC,
			Decode (FLAG_DTEC_2,         2, 1, 1, 0) FLAG_DTEC_2,
			Decode (FLAG_DTEC_3,         2, 1, 1, 0) FLAG_DTEC_3,
			Decode (FLAG_DCO,            2, 1, 1, 0) FLAG_DCO,
			Decode (FLAG_DSPS,           2, 1, 1, 0) FLAG_DSPS
       From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI p,
            Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
      Where p.SEDE_TECNICA = p_Sede_Tecnica
        And p.CODICE_DTP = v.CODICE_DTP
  	    And v.FLAG_NEW_TERRITORIO = 1                                  ---> DOIT territoriali no hanno autorizzato
  	    And v.FLAG_DCO = 2                                             ---> DCO ha autorizzato
		And v.CODICE_RICHIESTA = p_Codice_Autorizzazione;

		 DBMS_OUTPUT.PUT_LINE('Punti Operativi Nuovi e Non autorizzati dalla DOIT. Record inseriti ' || SQL%ROWCOUNT);
--

     End Loop;
-- --------------------------------------------------------------------------------------------------------------------------------------
-- Analogamente per le tratte - SEZIONI_LINEA
--
   For Rec_sol_new in Cur_sol_new loop

       p_Sede_Tecnica := rec_sol_new.SEDE_TECNICA;
--
	   If substr(p_sede_tecnica, 1, 2) = 'TR' Then 

	  Begin
	    Select Distinct DEFINIZIONE Into v_definizione From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
           Where SEDE_TECNICA = p_sede_tecnica; 
--
	EXCEPTION
	  When NO_DATA_FOUND Then 
	   v_definizione:= Null;
	   Dbms_Output.Put_Line('Non trovata la definizione della Nuova Sede Tecnica: '||p_sede_tecnica);
	End; 
--	
      End If;
--
	 Dbms_Output.Put_Line('Sede Tecnica Nuova  ' ||p_Sede_Tecnica|| ' -  ' ||v_definizione);
--

-- ---------------------------------------------------------------------------- 
--    Insert Into Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE   
-- ---------------------------------------------------------------------------- 
--
    Insert Into Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE    
  (CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP, SEDE_TECNICA, 
    DEFINIZIONE, FLAG_TIPO, ST_TIPOLOGIA, DATA_INSERIMENTO, FLAG_STATO_FINALE, STATO_FINALE, DATA_AGGIORNAMENTO, CODICE_VERSIONE_PUB,
    DOIT, DCO, STATO_SISTEMA, STATO_UTENTE
	)
    Select  n_Versione,
    	    v.CODICE_RICHIESTA CODICE_AUTORIZZAZIONE,
    		p.CODICE_DTP, 
    		p.SEDE_TECNICA,
			p.DEFINIZIONE,
    		1 FLAG_TIPO,      --  1: ST nuova
			'ST nuova' ST_TIPOLOGIA,
            sysdate DATA_INSERIMENTO, 
    		Case v.FLAG_DCO 
			     When 1 Then 0 
                 Else Case  v.FLAG_NEW_TERRITORIO
				      When 1 Then 9 
                      Else 1 End
				 End  FLAG_STATO_FINALE,  
 		Case v.FLAG_DCO 
			     When 1 Then 'non pubblicata' 
 --                Else 1 End  STATO_FINALE, 
                 Else Case  v.FLAG_NEW_TERRITORIO
				      When 1 Then 'skeleton' 
                      Else 'pubblicata' End
				 End  STATO_FINALE, 
        Case v.FLAG_DCO  
			     When 1 Then Null 
				 Else Sysdate End DATA_AGGIORNAMENTO, 				 
    		Case v.FLAG_DCO 
			     When 1 Then Null  
				 Else n_Versione End CODICE_VERSIONE_PUB,
			Case v.FLAG_NEW_TERRITORIO 
			     When 1 Then 'Non Autorizzata'  
			     When 2 Then 'Autorizzata'  				 
				 Else Null End DOIT,
			Case v.FLAG_DCO 
			     When 1 Then 'Non Autorizzata'  
			     When 2 Then 'Autorizzata'  				 
				 Else Null End DCO,
		    Null, 
			Null			 
	   From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA p,
	        Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
      Where p.CODICE_DTP  = v.CODICE_DTP 
        And p.SEDE_TECNICA = p_Sede_Tecnica
  		And v.CODICE_RICHIESTA = p_Codice_Autorizzazione; 
--
	Dbms_Output.Put_Line('Inserimento della ST '||p_sede_tecnica||' in REGISTRO_SEDI_ELIMINATE_NUOVE');
--
-- ---------------------------------------------------------------------------- 
--    Insert Into Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI
-- ---------------------------------------------------------------------------- 
--
     Insert Into Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI
    (CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP, SEDE_TECNICA, CODICE_CONTROLLO, FLAG_NEW, FLAG_DTEC, FLAG_DTEC_2, FLAG_DTEC_3, FLAG_DCO, FLAG_DSPS)
--
     Select n_versione,
	        v.CODICE_RICHIESTA codice_autorizzazione,
			p.CODICE_DTP, 
			p.SEDE_TECNICA,
			p.CODICE_CONTROLLO,
--			Decode (FLAG_NEW_TERRITORIO, 2, 1, 1, 0) flag_new,
			9 flag_new,                                            --->SKELETON
			Decode (FLAG_DTEC,           2, 1, 1, 0) FLAG_DTEC,
			Decode (FLAG_DTEC_2,         2, 1, 1, 0) FLAG_DTEC_2,
			Decode (FLAG_DTEC_3,         2, 1, 1, 0) FLAG_DTEC_3,
			Decode (FLAG_DCO,            2, 1, 1, 0) FLAG_DCO,
			Decode (FLAG_DSPS,           2, 1, 1, 0) FLAG_DSPS
       From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA p,
            Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
--
      Where p.SEDE_TECNICA = p_Sede_Tecnica
        And p.CODICE_DTP = v.CODICE_DTP
  	    And FLAG_NEW_TERRITORIO = 1                                  ---> DOIT territoriali no hanno autorizzato
  	    And FLAG_DCO = 2                                             ---> DCO ha autorizzato
		And v.CODICE_RICHIESTA = p_Codice_Autorizzazione;
--
	 DBMS_OUTPUT.PUT_LINE('Sezioni di Linea Nuove e Non autorizzate. Record inseriti ' || SQL%ROWCOUNT);

    End Loop;



/* 
 Devo verificare che le localit? di confine delle DTP siano tutte presenti
 per esempio: ci sono delle tratte della DTP di VR che hanno la localit? estrema della DTP di BO; ora,
 se ho l'autorizzazione della DTP di VR, ma non quella della DTP di BO, e se questa localit? non ? mai stata
 travasata nell'area pubblicati mi manda in errore l'intera procedura, perch? non posso inserire una sezione di linea senza le sue
 localit? estreme.
*/

    Update Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE set 
	       FLAG_STATO_FINALE = 0,
           STATO_FINALE = 'ripristinata',
           DATA_AGGIORNAMENTO = Null,
           CODICE_VERSIONE_PUB = Null 
     where CODICE_VERSIONE = n_versione 
	   And SEDE_TECNICA In 
          (Select SEDE_TECNICA
		     From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI p,
                  Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
--->
            Where p.CODICE_DTP = v.CODICE_DTP 
		      And v.CODICE_RICHIESTA = p_codice_autorizzazione
              And SEDE_TECNICA In
         ( 
		    (Select LOCALITA_INIZIO
               From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI a,
                    Rinf_Autorizzazioni_Evo.SEZIONI_LINEA s
              Where s.SEDE_TECNICA = a.SEDE_TECNICA 
			    And a.CODICE_VERSIONE = n_Versione 
				And a.CODICE_AUTORIZZAZIONE = p_Codice_Autorizzazione 
                And a.FLAG_NEW = 1
             Minus
            Select SEDE_TECNICA
              From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI a
             Where a.CODICE_VERSIONE = n_Versione 
			 )
           Union
           (Select LOCALITA_FINE
              From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI a,
                   Rinf_Autorizzazioni_Evo.SEZIONI_LINEA s
             Where s.SEDE_TECNICA = a.SEDE_TECNICA 
			   And a.CODICE_VERSIONE = n_Versione 
			   And a.CODICE_AUTORIZZAZIONE = p_Codice_Autorizzazione 
			   And a.FLAG_NEW = 1
              Minus
             Select SEDE_TECNICA
               From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI a
              Where a.CODICE_VERSIONE = n_Versione  
			 )
         )	  
        )	   
       And FLAG_STATO_FINALE = 1;

		 DBMS_OUTPUT.PUT_LINE('Punti Operativi da non eliminare per la consistenza delle tratte. Record: ' || SQL%ROWCOUNT);

    Insert Into Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI
   (CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP, SEDE_TECNICA, CODICE_CONTROLLO, FLAG_NEW, FLAG_DTEC, FLAG_DTEC_2, FLAG_DTEC_3, FLAG_DCO, FLAG_DSPS)
--
     Select n_versione,
			v.CODICE_RICHIESTA,
			p.CODICE_DTP, 
			SEDE_TECNICA,
			CODICE_CONTROLLO,
			decode (v.flag_new_territorio, 2, 1, 1, 0) Flag_new,
			decode (FLAG_DTEC,   2, 1, 1, 0) FLAG_DTEC,
			decode (FLAG_DTEC_2, 2, 1, 1, 0) FLAG_DTEC_2,
			decode (FLAG_DTEC_3, 2, 1, 1, 0) FLAG_DTEC_3,
			decode (FLAG_DCO,    2, 1, 1, 0) FLAG_DCO,
			decode (FLAG_DSPS,   2, 1, 1, 0) FLAG_DSPS
       From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI p,
            Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ v
--->
      Where p.CODICE_DTP = v.CODICE_DTP 
		And v.CODICE_RICHIESTA = p_codice_autorizzazione
        And SEDE_TECNICA In
         ( 
		    (Select LOCALITA_INIZIO
               From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI a,
                    Rinf_Autorizzazioni_Evo.SEZIONI_LINEA s
              Where s.SEDE_TECNICA = a.SEDE_TECNICA 
			    And a.CODICE_VERSIONE = n_Versione 
				And a.CODICE_AUTORIZZAZIONE = p_Codice_Autorizzazione 
				And a.FLAG_NEW = 1
             Minus
            Select SEDE_TECNICA
              From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI a
             Where a.CODICE_VERSIONE = n_Versione 
			 )
           Union
           (Select LOCALITA_FINE
              From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI a,
                   Rinf_Autorizzazioni_Evo.SEZIONI_LINEA s
             Where s.SEDE_TECNICA = a.SEDE_TECNICA 
			   And a.CODICE_VERSIONE = n_Versione 
			   And a.CODICE_AUTORIZZAZIONE = p_Codice_Autorizzazione 
			   And a.FLAG_NEW = 1
              Minus
             Select SEDE_TECNICA
               From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI a
              Where a.CODICE_VERSIONE = n_Versione  
			 )
         );

		 Dbms_Output.Put_Line('Punti Operativi da aggiungere per la consistenza delle tratte. Record: ' || SQL%ROWCOUNT);

 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
--        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetPubblicationDetail '||SQLERRM, Pkg_Rinf_Sicurezza.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetPubblicationDetail - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetPubblicationDetail;

--
-- -------------------------------------------------------------------------------------------------
--                         Set_Autorizzazioni_SC
-- Programma principale per la gestione delle mancate autorizzazioni dei validatori di sede Centrale
-- -------------------------------------------------------------------------------------------------
--  
 Procedure Set_Autorizzazioni_SC (V_Codice_Versione Number, V_Codice_Richiesta Number, V_codice_dtp varchar2, v_tipo_depositario Number, p_error_split Out Number) is 
    num Number;
	Procedura Varchar2(100);
	cod_tipo_dep Number;
	sqlstring varchar2(1000);
	Cod_Ver Number;
--
    cursor cur_noabil is
--	
      Select a.CODICE_RICHIESTA,
             a.CODICE_DTP,
             a.SIGLA_TIPO_DEPOSITARIO,
             a.FLAG_SEDE_CENTRALE,
             a.FLAG_STATO_RICHIESTA
        From (
         Select CODICE_RICHIESTA,
                CODICE_DTP,
                SIGLA_TIPO_DEPOSITARIO,
                CODICE_TIPO_DEPOSITARIO FLAG_SEDE_CENTRALE,
                Decode (Max (CODICE_STATO_RICHIESTA),  2, 1, 1, 0) FLAG_STATO_RICHIESTA,
                Max (DATA_AUTORIZZAZIONE) DATA_AUTORIZZAZIONE
           From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI c,
                Rinf_Sicurezza_Evo.ANAG_TIPO_DEPOSITARIO d
          Where d.CODICE_TIPO_DEPOSITARIO = c.FLAG_SEDE_CENTRALE
            And FLAG_SEDE_CENTRALE > 0
            And AREA = 'SC'
            And CODICE_RICHIESTA = V_Codice_Richiesta
--->
          And CODICE_TIPO_DEPOSITARIO = v_tipo_depositario
		  And CODICE_DTP = V_codice_dtp
--->

       Group By CODICE_RICHIESTA,
                CODICE_DTP,
                SIGLA_TIPO_DEPOSITARIO,
                CODICE_TIPO_DEPOSITARIO
             ) a
	   Where a.FLAG_STATO_RICHIESTA = 0
-- controlla che non sia gi? stata ripristinata la versione precedente dal territorio (DOIT)
		 And Not exists
		 	 (Select 1 From Rinf_Amministrazione_evo.V_STATO_RICHIESTA_ULTIMA z Where z.CODICE_DTP = a.CODICE_DTP And z.FLAG_NEW_TERRITORIO = 0)  
	   Order By a.CODICE_RICHIESTA, a.SIGLA_TIPO_DEPOSITARIO, a.CODICE_DTP;

       row_NoAbil      Cur_noabil%rowtype;   

    Cursor cur_Proc (cod_dep number) Is
     Select a.CODICE_TIPO_DEPOSITARIO, a.CODICE_PARAMETRO, c.NOME_PROCEDURA
       From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI a,
            Rinf_Sicurezza_Evo.ANAG_TIPO_DEPOSITARIO b,
            Rinf_Anagrafiche_Evo.ANAG_TAB_PARAMETRI c
      Where b.CODICE_TIPO_DEPOSITARIO = a.CODICE_TIPO_DEPOSITARIO 
        And c.CODICE_PARAMETRO = a.CODICE_PARAMETRO
        And a.CODICE_TIPO_DEPOSITARIO = cod_dep
        And AREA = 'SC'
        And xml_name Is Not Null
        And data_fine_validita > Sysdate
		And c.FLAG_OPERAZIONE = 1
   Order By a.CODICE_TIPO_DEPOSITARIO, codice_parametro ;

       row_Proc      Cur_proc%rowtype;   

-- -----------------------------------------------------
  Begin 
    p_error_split := 0;
    Cod_Ver := V_Codice_Versione -1;
    Num := 0;
--	
	For row_NoAbil  in    Cur_noabil loop
         Num := Num + 1;
/*
	Case row_NoAbil.FLAG_SEDE_CENTRALE	
	     When 2 Then     nonaut_RC_RINF_DTEC   (v_CODICE_VERSIONE, v_DTP, p_error_split)      -- RC_RINF_DTEC
	     When 6 Then     nonaut_RC_RINF_DTEC_2 (v_CODICE_VERSIONE, v_DTP, p_error_split)      -- RC_RINF_DTEC_2 
		 When 7 Then     nonaut_RC_RINF_DTEC_3 (v_CODICE_VERSIONE, v_DTP, p_error_split)      -- RC_RINF_DTEC_3
		 When 10 Then    nonaut_RC_RINF_DCO    (v_CODICE_VERSIONE, v_DTP, p_error_split)      -- RC_RINF_DCO
		 When 11 Then    nonaut_RC_RINF_DSPS   (v_CODICE_VERSIONE, v_DTP, p_error_split)      -- RC_RINF_DSPS
		 Else Null; 
    End Case;
*/	
         cod_tipo_dep := row_NoAbil.FLAG_SEDE_CENTRALE;
--
         For Row_Proc In Cur_proc (cod_tipo_dep) Loop

		      Procedura := 'PKG_RINF_PAR_SC_AUTORIZZAZIONI.'||Row_Proc.NOME_PROCEDURA;
--			  dbms_output.put_line (procedura||' - '||row_NoAbil.CODICE_DTP);
			  sqlstring := 'CALL '||Procedura||' ( :a, :b, :c) ';
--              dbms_output.put_line (sqlstring);
--
--              dbms_output.put_line ('Esecuzione: '||Procedura||' - Codice_Versione: '||V_Codice_Versione);
			  EXECUTE IMMEDIATE sqlstring using In V_Codice_Versione, In row_NoAbil.CODICE_DTP, Out p_error_split;
              dbms_output.put_line ('Esecuzione: '||Procedura||' - Aggiornamento Parametro Con Codice_Versione: '||Cod_ver);
--          
		 End Loop;
    End Loop;	


  EXCEPTION
      When NO_DATA_FOUND Then
	  Dbms_Output.Put_Line ('Tutte le Sedi Centrali hanno autorizzato');
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('Set_Autorizzazioni_SC - Errore: ' || Substr(Sqlerrm, 1, 250));

 End Set_Autorizzazioni_SC;


-- ------------------------------------------------------------------------------------------------------------------------------- 
--                          Set_Aggiorna_SC
-- ------------------------------------------------------------------------------------------------------------------------------- 

  Procedure Set_Aggiorna_SC (V_Codice_Versione Varchar2, v_CODICE_DTP varchar2, V_cod_tipo_dep Number, p_error_split Out Number) is 

    num Number;
	Procedura Varchar2(100);
	cod_tipo_dep Number;
	sqlstring varchar2(1000);
	Cod_Ver NUMBER;

     Cursor cur_Proc (cod_dep number) Is
     Select a.CODICE_TIPO_DEPOSITARIO, a.CODICE_PARAMETRO, c.NOME_PROCEDURA
       From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI a,
            Rinf_Sicurezza_Evo.ANAG_TIPO_DEPOSITARIO b,
            Rinf_Anagrafiche_Evo.ANAG_TAB_PARAMETRI c                                            ---> Nuova Tabella da aggiungere allo schema Rinf_Anagrafiche_Evo
      Where b.CODICE_TIPO_DEPOSITARIO = a.CODICE_TIPO_DEPOSITARIO 
        And c.CODICE_PARAMETRO = a.CODICE_PARAMETRO
        And a.CODICE_TIPO_DEPOSITARIO = cod_dep
        And AREA = 'SC'
		And FLAG_OPERAZIONE = 2
        And XML_NAME Is Not Null
        And DATA_FINE_VALIDITA > Sysdate
   Order By a.CODICE_TIPO_DEPOSITARIO, codice_parametro ;

       row_Proc      Cur_proc%rowtype;   

-- -----------------------------------------------------
  Begin 
    p_error_split := 0;
    Cod_Ver := V_Codice_Versione;
    Num := 0;	
--
         For Row_Proc In Cur_proc (V_cod_tipo_dep) Loop
		      Num := Num + 1;
		      Procedura := 'PKG_RINF_PAR_SC_AUTORIZZAZIONI.'||Row_Proc.NOME_PROCEDURA;
--			  dbms_output.put_line (procedura||' - '||v_CODICE_DTP);
			  sqlstring := 'CALL '||Procedura||' ( :a, :b, :c) ';
--              dbms_output.put_line (sqlstring);

              dbms_output.put_line ('Esecuzione: '||Procedura||' - Aggiornamento Parametro Con Codice_Versione: '||Cod_ver);
--
			  EXECUTE IMMEDIATE sqlstring using In V_Codice_Versione, In v_CODICE_DTP, Out p_error_split;

		 End Loop;
 dbms_output.put_line (' Numero parametri: '||Num);

  EXCEPTION
      When NO_DATA_FOUND Then
	     Dbms_Output.Put_Line ('Non ci sono dati da aggiornare');
      When OTHERS Then
         p_error_split := 1; 
         Dbms_Output.Put_Line ('Set_aggiorna_SC - Errore: ' || Substr(Sqlerrm, 1, 250));
  End Set_Aggiorna_SC;

--
-- -----------------------------------------------------------------------------
--                          Procedure SetRaccordiRINew
-- -----------------------------------------------------------------------------
--
 Procedure SetRaccordiRINew (p_i_versione Number, p_error Out Number) Is
  Begin
    p_error := 0;
--
-- 25/06/2018 Inserisce nella tabella di relazione Raccordi-Registro i raccordi validati
    Insert Into RINF_ANAGRAFICHE_EVO.RACCORDI_REGISTRO
     Select PO_1_2_0_0_0_2, 
	        PROG,
	        p_i_versione
       From RINF_ANAGRAFICHE_EVO.V_RACCORDI_VALIDI;
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetRaccordiRINew '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetRaccordiRINew - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetRaccordiRINew;
--
-- -----------------------------------------------------------------------------
--                          Procedure SetNewRinfVersion
-- -----------------------------------------------------------------------------
--
 Procedure SetNewRinfVersion (P_Codice_Autorizzazione Number, P_Error Out Number) Is
    n_versione Number;
--
	DOIT varchar2(6);
	Cod_tipo_dep Number;
	v_SEDE_TECNICA varchar2(6);
	Num_Rec Number;
--	

 Cursor cur_DTP Is 
  Select
	CODICE_DTP,
	CODICE_TERR,
    FLAG_NEW_TERRITORIO,
	CODICE_DTEC,
    FLAG_DTEC,
	CODICE_DTEC_2,
    FLAG_DTEC_2,
    CODICE_DTEC_3,
    FLAG_DTEC_3,
	CODICE_DCO,
    FLAG_DCO,
	CODICE_DSPS,
    FLAG_DSPS
	From Rinf_Amministrazione_Evo.V_STATO_RICHIESTE_AUTORIZ
   Where CODICE_RICHIESTA = p_Codice_Autorizzazione
   Order By CODICE_DTP;

 Cursor cur_Skeleton (Cod_tipo_dep varchar2) Is 
     Select SEDE_TECNICA 
	  From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI
	 Where FLAG_NEW = 9 
	   And FLAG_DCO = 1
	   And CODICE_DTP = Cod_tipo_dep 
	   And CODICE_VERSIONE = n_versione;

--->
-- ------------------------------------------------------------------------------------------------

  Begin
    p_error := 0;
--
	Select Nvl(Max(CODICE_VERSIONE), 0) +1 
	  Into n_versione
      From Rinf_Pubblicati_Evo.VERSIONE_RINF;
--
-- 13/02/2018 Inserita la data di riferimento nella versione del RINF. Per permettere l'estrazione corretta dei dati dei report

    Insert Into Rinf_Pubblicati_Evo.VERSIONE_RINF
	       (CODICE_VERSIONE,  DATA_PUBBLICAZIONE, DATA_RIFERIMENTO)
     Select n_versione,
	        Sysdate,
			DATA_RIFERIMENTO
       From RINF_AMMINISTRAZIONE_EVO.ANAG_RICHIESTE_AUTORIZZAZIONI
      Where CODICE_RICHIESTA = p_codice_autorizzazione;

-- ------------------------------------------------------------------------------------------------
--                          Gestione Sedi Territoriali (DOIT)
-- ------------------------------------------------------------------------------------------------
--  Definisco l'elenco dele sedi tecniche autorizzate e quelle non autorizzate, da recuperare dalla versione precedente
--  la gestione delle nuove sedi tecniche (PO e SOL) e quelle inserite in CLASSE_ELIMINATI ? contenuta in questa procedura
--
     dbms_output.put_line ('Esecuzione SetPubblicationDetail - versione: '||n_versione); 
--
     SetPubblicationDetail (n_versione, p_codice_autorizzazione, p_error);
--
     dbms_output.put_line ('Fine esecuzione SetPubblicationDetail: '|| p_error); 

--	   
    dbms_output.put_line ('-----------------------------------------------------------------------------------------------------');
    dbms_output.put_line ('------------------------------------  Gestione Sedi Territoriali (DOIT)  ----------------------------');
    dbms_output.put_line ('-----------------------------------------------------------------------------------------------------');
--    dbms_output.put_line ('Definisco le sedi tecniche con nuova autorizzazione e quelle da recuperare dalla versione precedente ');

 If p_error = 0 Then
--OP
    SetOPNew (n_versione, p_error);
    If p_error = 0 Then
        SetOPTAFTAPNew (n_versione, p_error);
        If p_error = 0 Then
            SetOPTrackNew (n_versione, p_error);
            If p_error = 0 Then
               SetOPTunnelNew (n_versione, p_error);
                If p_error = 0 Then
                  SetOPPlatformNew (n_versione, p_error);
                  If p_error = 0 Then
                    SetOPSidingNew (n_versione, p_error);
                    If p_error = 0 Then
                        SetOPTunnelSDNew (n_versione, p_error);
                        If p_error = 0 Then
                            SetPOCATTENNew (n_versione, p_error);
                            If p_error = 0 Then
                                SetPOCATLINEANew (n_versione, p_error);
                                If p_error = 0 Then
                                    SetPLATCATTENNew (n_versione, p_error);
                                    If p_error = 0 Then
                                        SetSDCATTENNew (n_versione, p_error);
                                        If p_error = 0 Then
                                            SetOPLineNew (n_versione, p_error);
                                        If p_error = 0 Then
											SetPO_NORMEDOC_New (n_versione, p_error);
    ----SOL
                                                If p_error = 0 Then
                                                    SetSOLNew (n_versione, p_error);
                                                    If p_error = 0 Then
                                                        SetSOLTrackNew (n_versione, p_error);
                                                        If p_error = 0 Then
                                                            SetSOLTrackDecNew (n_versione, p_error);
                                                            If p_error = 0 Then
                                                                SetSOLTunnelNew (n_versione, p_error);
                                                                If p_error = 0 Then
                                                                    SetSOLCATTENNew (n_versione, p_error);
                                                                    If p_error = 0 Then
                                                                        SetSOLCATLINEANew (n_versione, p_error);
                                                                        If p_error = 0 Then
                                                                            SetSOLCATCARICONew (n_versione, p_error);
                                                                            If p_error = 0 Then
                                                                                SetSOLPROFCASSEMNew (n_versione, p_error);
                                                                                If p_error = 0 Then
                                                                                    SetSOLPROFSEMIRIMNew (n_versione, p_error);
                                                                                    If p_error = 0 Then
                                                                                        SetSOLGRADIENTENew (n_versione, p_error);
                                                                                        If p_error = 0 Then
                                                                                            SetSOLGSMRFACNew (n_versione, p_error);
--> nuove proc Reg.2019/777
                                                                                       If p_error = 0 Then
                                                                                         SetSOL_LOCAVERSPEC_New (n_versione, p_error);
                                                                                       If p_error = 0 Then
                                                                                         SetSOL_LOCASISTRTB_New (n_versione, p_error);
                                                                                       If p_error = 0 Then
                                                                                         SetSOL_COMPETCS_New(n_versione, p_error);
                                                                                       If p_error = 0 Then
                                                                                         SetSOL_RETIGSM_New (n_versione, p_error);
                                                                                       If p_error = 0 Then
                                                                                         SetSOL_COMPRADIOVOCE_New (n_versione, p_error);
                                                                                       If p_error = 0 Then
                                                                                         SetSOL_COMPRADIODATI_New (n_versione, p_error);
                                                                                       If p_error = 0 Then
                                                                                         SetSOL_SISTPREPROT_New (n_versione, p_error);
                                                                                       If p_error = 0 Then
                                                                                         SetSOL_SISRILDOC_New (n_versione, p_error);
                                                                                       If p_error = 0 Then
                                                                                         SetSOL_CARMINASSE_New (n_versione, p_error);
                                                                                       If p_error = 0 Then
                                                                                         SetSOL_NORMEDOC_New (n_versione, p_error);
-->
                                                                                       If p_error = 0 Then 
                                                                                             SetSOLLineNew (n_versione, p_error);
                                                                                             If p_error = 0 Then --25/06/2018 inserita l'associazione dei raccordi al registro
                                                                                                   SetRaccordiRINew(n_versione, p_error);
                                                                                             End If;

                                                                                       End If;  
-->
                                                                                       End If;  
                                                                                       End If;  
                                                                                       End If;  
                                                                                       End If;  
                                                                                       End If;                                                                                    
                                                                                       End If;                                                                                    
                                                                                       End If;                                                                                    
                                                                                       End If;                                                                                    
                                                                                       End If;                                                                                    
                                                                                       End If;                                                                                    
-->
                                                                                       End If;
                                                                                    End If;
                                                                                End If;
                                                                             End If;
                                                                        End If;
                                                                End If;
                                                            End If;
                                                        End If;
                                                End If;
                                            End If;
                                        End If;           -- Setpo_Normedoc_New
                                      End If;
                                   End If;
                                 End If;
                               End If;
                             End If;
                          End If;
                      End If;
                  End If;
               End If;
              End If;
           End If;
        End If;
 End If;


-- --------------------------------------------------------------------------------
-- Gestione delle autorizzazioni delle Sedi Centrali (ciclo sulle singole DTP):
-- --------------------------------------------------------------------------------
--
--
-- 

-- iterazione sulle singole DTP
    dbms_output.put_line ('---------------------------------------------------------------------------------------------------');
    dbms_output.put_line ('------------------------------------  Gestione Sedi Centrali x (DOIT)  ----------------------------');
    dbms_output.put_line ('---------------------------------------------------------------------------------------------------');

--
  For rec_DTP in cur_DTP Loop
-- 
      DOIT := rec_DTP.CODICE_DTP;
      dbms_output.put_line ('------------------------------------------------------------------------');  -- spaziatura output
      dbms_output.put_line ('DOIT corrente: '||DOIT);

-- ----------------------------------------------------------------------------------------------------
--    Caso 1 - il territorio NON ha autorizzato - DOIT n = T n-1 
--    TUTTI i parametri sono stati valorizzati con i dati ricavati dall'ultima autorizzazione (Pubblicati -1)
--    Se solo T non autorizza:      DOIT n = T n-1 + DCO n + DSPS n + DTEC n + DTEC_2 n-1 + DTEC_3 n-1
--    Pertanto, i parametri di DCO, DSPS e DTEC vanno aggiornati con i nuovi valori autorizzati, provenienti dall acquisizione
-- ----------------------------------------------------------------------------------------------------
      If rec_DTP.FLAG_NEW_TERRITORIO < 2 Then 

      dbms_output.put_line ('T non ha autorizzato - DTP: '||DOIT||' Tutti i parametri sono stati valorizzati dalla precedente Pubblicazione v: '||to_char(n_versione -1) );

--  + DCO n 
          If rec_DTP.FLAG_DCO = 2 Then
              Cod_tipo_dep := rec_DTP.CODICE_DCO;
--
              dbms_output.put_line ('DCO ha autorizzato - il Territorio non ha autorizzato - aggiorno i valori dei parametri DCO: Set_Aggiorna_SC - codice: '|| rec_DTP.CODICE_DCO);
--
              PKG_RINF_PUBBLICAZIONE.Set_Aggiorna_SC (n_versione, DOIT, Cod_tipo_dep, p_error);
			  If p_error > 0 Then
			       dbms_output.put_line ('Errore esecuzione Set_Aggiorna_SC - errore: '||p_error);
			  End If;
--
--
-- Verifica esistenza nuove sedi tecniche. Vanno aggiunte e valorizzare ma, solo i parametri fondamentali, il resto = NYA
--
           For Rec_Skeleton In cur_Skeleton (DOIT) Loop 
--		   
			   v_SEDE_TECNICA := Rec_Skeleton.SEDE_TECNICA;
		       dbms_output.put_line ('Nuova Sede_Tecnica NON autorizzata da T ma autorizzata da DCO - Skeleton: '||v_SEDE_TECNICA);
--
               If Substr (v_SEDE_TECNICA, 1, 2) = 'LO' Then 
             	    Dbms_Output.Put_Line ('Tracciato Skeleton per Sede_tecnica OP: '||v_SEDE_TECNICA);
                    PKG_RINF_PAR_SC_AUTORIZZAZIONI.Set_Skeleton_PO (v_SEDE_TECNICA, n_versione, p_error);
                    If p_error > 0 Then 
             		     Dbms_Output.Put_Line ('Procedura terminata con errore');
             		End If;
--             
             	Elsif Substr (v_SEDE_TECNICA, 1, 2) = 'TR' Then 
             	    Dbms_Output.Put_Line ('Tracciato Skeleton per Sede_tecnica SOL: '||v_SEDE_TECNICA);
                    PKG_RINF_PAR_SC_AUTORIZZAZIONI.Set_Skeleton_SOL (v_SEDE_TECNICA, n_versione, p_error);
                    If p_error > 0 Then 
             		     Dbms_Output.Put_Line ('Procedura terminata con errore');
             		End If;
--             
             	Else  
             	    Dbms_Output.Put_Line ('Tracciato Skeleton per Nessuna Sede_tecnica');
	            End If;
--
		   End Loop;
--
-- -----------------------------------------------------------------------------------------
-- controllo esistenza di sedi tecniche da eliminare. Nell autorizzazione precedente non autorizzate da DCO
-- -----------------------------------------------------------------------------------------
--
     Select count(distinct SEDE_TECNICA) Into Num_Rec
       From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
	  Where FLAG_TIPO = -1 
  	    And CODICE_DTP = DOIT
        And DATA_AGGIORNAMENTO Is Null	
        And STATO_FINALE = 0
		And CODICE_VERSIONE < n_versione;	  

       If Num_Rec > 0 Then 				 

   Update Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
            Set FLAG_STATO_FINALE = 1, 
			    STATO_FINALE = 'pubblicata', 
	            DATA_AGGIORNAMENTO = Sysdate,
                CODICE_VERSIONE_PUB = n_versione	  
	        Where FLAG_TIPO = -1 
	        And CODICE_DTP = DOIT
            And DATA_AGGIORNAMENTO Is Null	
            And STATO_FINALE = 0;	  

            Dbms_Output.Put_Line('Record in CLASSE_ELIMINATI acquisisioni precedentemente non autorizzate da DCO: ' || SQL%ROWCOUNT ); 
       End If;

--
--  + DCO n-1 
		  Else 
-- Caso 8. T e DCO non autorizzano:   DOIT n = T n-1 + DCO n-1 + DSPS n + DTEC n + DTEC_2 n-1 + DTEC_3 n-1
              dbms_output.put_line ('DCO e il Territorio non hanno autorizzato');
-- Le SdL ed i PO ?ELIMINATI? vengono ?rispristinati?, altrimenti le SdL/PO soppresse darebbero luogo ad un reticolo con dei ?buchi?. 
-- Le SdL ed i PO ?ripristinati? dovranno poi essere nella successiva acquisizione ?ELIMINATI? 

		  End If;
--
--  + DTEC n
          If rec_DTP.FLAG_DTEC = 2 Then
-- Caso 2 o 8 T non autorizza e, DCO autorizza o meno:  DOIT n = T n-1 + DCO n/n-1 + DSPS n + DTEC n + DTEC_2 n-1 + DTEC_3 n-1
              Cod_tipo_dep := rec_DTP.CODICE_DTEC;
--
              dbms_output.put_line ('DTEC ha autorizzato e T no - Set_Aggiorna_SC - codice: '|| rec_DTP.CODICE_DTEC);
--
              PKG_RINF_PUBBLICAZIONE.Set_Aggiorna_SC (n_versione, DOIT, Cod_tipo_dep, p_error);
			  If p_error > 0 Then
                   dbms_output.put_line ('Errore esecuzione Set_Aggiorna_SC - errore: '||p_error);	
		      End If;
--  + DTEC n-1
		  Else 
            dbms_output.put_line ('DTEC e il Territorio non hanno autorizzato');
		  End If;
--
--	 + DSPS n 	  
		  If rec_DTP.FLAG_DSPS = 2 Then
              Cod_tipo_dep := rec_DTP.CODICE_DSPS;
--
              dbms_output.put_line ('DSPS ha autorizzato e T no - Set_Aggiorna_SC - codice: '|| rec_DTP.CODICE_DSPS);

              PKG_RINF_PUBBLICAZIONE.Set_Aggiorna_SC (n_versione, DOIT, Cod_tipo_dep, p_error);
			  If p_error > 0 Then
			       dbms_output.put_line ('Errore esecuzione Set_Aggiorna_SC - errore: '||p_error);
			  End If;
--	+ DSPS n-1 	  
		  Else 
              dbms_output.put_line ('DSPS e il Territorio non hanno autorizzato');
--		      Null;
		  End If;
--
--************** se T non autorizza cosa hanno fatto DTEC_3 e DTEC_3 ? ininfluente. Quindi: DTEC_2 n-1 + DTEC_3 n-1 ***
          If rec_DTP.FLAG_DTEC_2 = 2 Then
              dbms_output.put_line ('DTEC_2 ha autorizzato - T non ha autorizzato');
--              Null;
		  Else 
              dbms_output.put_line ('DTEC_2 e T non hanno autorizzato');
--		      Null;
		  End If;
--
          If rec_DTP.FLAG_DTEC_3 = 2 Then
              dbms_output.put_line ('DTEC_3 ha autorizzato - T non ha autorizzato ');
              Null;
		  Else 
             dbms_output.put_line ('DTEC_3 e T non hanno autorizzato');
--		      Null;
		  End If;

-- -------------------------------------------------------------------------------------- 
--    FLAG_NEW_TERRITORIO = 2 il territorio ha autorizzato - DOIT n = T n 
-- -------------------------------------------------------------------------------------- 
--
      Else                             
         dbms_output.put_line ('T ha autorizzato');
--  + DCO n 
         If rec_DTP.FLAG_DCO = 2 Then
              dbms_output.put_line ('DCO e il Territorio hanno autorizzato');
--- -----------------------------------------------------------------------------------------
-- controllo esistenza di sedi tecniche da eliminare. Nell'autorizzazione precedente non autorizzate da DCO
-- -----------------------------------------------------------------------------------------
--
     Select count(distinct SEDE_TECNICA) Into Num_Rec
       From Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
	  Where FLAG_TIPO = -1 
  	    And CODICE_DTP = DOIT
        And DATA_AGGIORNAMENTO Is Null	
        And FLAG_STATO_FINALE = 0
		And CODICE_VERSIONE < n_versione;	  

       If Num_Rec > 0 Then 				 

           Update Rinf_Anagrafiche_Evo.REGISTRO_SEDI_ELIMINATE_NUOVE 
            Set FLAG_STATO_FINALE = 1, 
			    STATO_FINALE = 'pubblicata', 
	            DATA_AGGIORNAMENTO = Sysdate,
                CODICE_VERSIONE_PUB = n_versione	  
	        Where FLAG_TIPO = -1 
	        And CODICE_DTP = DOIT
            And DATA_AGGIORNAMENTO Is Null	
            And FLAG_STATO_FINALE = 0;	  

                   Dbms_Output.Put_Line('Record in CLASSE_ELIMINATI acquisisioni precedentemente non autorizzate da DCO: ' || SQL%ROWCOUNT ); 
       End If;

--
		  Else 
--  + DCO n-1  
              Cod_tipo_dep := rec_DTP.CODICE_DCO;
--
              dbms_output.put_line ('DCO non ha autorizzato - T ha autorizzato - Set_Autorizzazioni_SC - codice: '|| rec_DTP.CODICE_DCO);

 		      PKG_RINF_PUBBLICAZIONE.Set_Autorizzazioni_SC (n_versione, p_codice_autorizzazione, DOIT, Cod_tipo_dep, p_error) ;	  
			  If p_error > 0 Then
			       dbms_output.put_line ('Errore esecuzione Set_Autorizzazioni_SC - errore: '||p_error);
			  End If;


		  End If;
--  + DTEC n
          If rec_DTP.FLAG_DTEC = 2 Then
              dbms_output.put_line ('DTEC e il Territorio hanno autorizzato');
--  + DTEC n-1
		  Else 
              Cod_tipo_dep := rec_DTP.CODICE_DTEC;
--
              dbms_output.put_line ('DTEC non ha autorizzato - T ha autorizzato- Set_Autorizzazioni_SC - codice: '|| rec_DTP.CODICE_DTEC);
 		      PKG_RINF_PUBBLICAZIONE.Set_Autorizzazioni_SC (n_versione, p_codice_autorizzazione, DOIT, Cod_tipo_dep, p_error) ;	  
			  If p_error > 0 Then
			       dbms_output.put_line ('Errore esecuzione Set_Autorizzazioni_SC - errore: '||p_error);
			  End If;
		  End If;
--	+ DSPS n 	  
		  If rec_DTP.FLAG_DSPS = 2 Then
              dbms_output.put_line ('DSPS e il Territorio hanno autorizzato');
--  + DSPS n-1 
		  Else 
              Cod_tipo_dep := rec_DTP.CODICE_DSPS;
--
              dbms_output.put_line ('DSPS non ha autorizzato - T ha autorizzato - Set_Autorizzazioni_SC - codice: '|| rec_DTP.CODICE_DSPS);
 		      PKG_RINF_PUBBLICAZIONE.Set_Autorizzazioni_SC (n_versione, p_codice_autorizzazione, DOIT, Cod_tipo_dep, p_error) ;			  
			  If p_error > 0 Then
			       dbms_output.put_line ('Errore esecuzione Set_Autorizzazioni_SC - errore: '||p_error);
			  End If;
		  End If;
--  + DTEC_2 n 
          If rec_DTP.FLAG_DTEC_2 = 2 Then
              dbms_output.put_line ('DTEC_2 e il Territorio hanno autorizzato');
--  + DTEC_2 n-1
		  Else 
              Cod_tipo_dep := rec_DTP.CODICE_DTEC_2;
--
              dbms_output.put_line ('DTEC_2 non ha autorizzato - T ha autorizzato - Set_Autorizzazioni_SC - codice: '|| rec_DTP.CODICE_DTEC_2);
 		      PKG_RINF_PUBBLICAZIONE.Set_Autorizzazioni_SC (n_versione, p_codice_autorizzazione, DOIT, Cod_tipo_dep, p_error) ;	  
			  If p_error > 0 Then
			       dbms_output.put_line ('Errore esecuzione Set_Autorizzazioni_SC - errore: '||p_error);
			  End If;
		  End If;
--  + DTEC_3 n 
          If rec_DTP.FLAG_DTEC_3 = 2 Then
              dbms_output.put_line ('DTEC_3 e il Territorio hanno autorizzato');
--  + DTEC_3 n-1 
		  Else 
              Cod_tipo_dep := rec_DTP.CODICE_DTEC_3;
--
              dbms_output.put_line ('T ha autorizzato ma, DTEC_3 no - Set_Autorizzazioni_SC - codice: '|| Cod_tipo_dep);

 		      PKG_RINF_PUBBLICAZIONE.Set_Autorizzazioni_SC (n_versione, p_codice_autorizzazione, DOIT, Cod_tipo_dep, p_error) ;	  
			  If p_error > 0 Then
			       dbms_output.put_line ('Errore esecuzione Set_Autorizzazioni_SC - errore: '||p_error);
			  End If;
		  End If;
-- 
	  End If;
-- 
  End Loop; 

-- -----------------------------------------------------------------------------------------
--  al termine del processo le 53 tabelle dell area dati RI-autorizzazioni vengono svuotate
-- -----------------------------------------------------------------------------------------


  If p_error = 0 Then  --24/05/2016  inserito per svuotamento dell'area autorizzazioni
         PKG_RINF_AUTORIZZAZIONI.SetSOLClear (p_error);
         If p_error = 0 Then
              PKG_RINF_AUTORIZZAZIONI.SetOPClear (p_error);
         End If;
  End If;

   dbms_output.put_line('Fine  Elaborazione ===> '||to_char(sysdate,'DD/MM/YYYY HH24:MI:SS'));


 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        Dbms_Output.Put_Line ('SetNewRinfVersion - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetNewRinfVersion;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetAllRIPronti
-- -----------------------------------------------------------------------------
--
 Procedure GetAllRIPronti( p_cursor Out empcur) Is
  Begin
     Open p_cursor For

/***********************  
-- Modifica del 12/09/2018 per la gestione della pubblicazione dei file XML e PDF dei Raccordi 

  Select CODICE_VERSIONE,  DATA_PUBBLICAZIONE, Null DATA_TRASMISSIONE, DESCRIZIONE NOTE
  From Rinf_Pubblicati_Evo.VERSIONE_RINF
  Where 
  PROTOCOLLO IS Null
  order by 1 desc;

-- Modifica del 20/12/2018 aggiungendo la data della versione del GIS
  Select a.CODICE_VERSIONE,  a.DATA_PUBBLICAZIONE, Null DATA_TRASMISSIONE, a.DESCRIZIONE NOTE, a.FORMATO_PUBBLICAZIONE, z.VERSIONE_MDR
  From Rinf_Pubblicati_Evo.VERSIONE_RINF a, RINF_GIS_EVO.MDR_REGISTRO z
  Where a.CODICE_VERSIONE = z.CODICE_VERSIONE
  and z.codice_area = 4  
  and a.PROTOCOLLO IS Null
  order by 1 desc;

-- Modifica per aggiungere la presenza dei raccordi per ogni versione del Registro 15/5/2019
  Select a.CODICE_VERSIONE,  a.DATA_PUBBLICAZIONE, Null DATA_TRASMISSIONE, a.DESCRIZIONE NOTE, a.FORMATO_PUBBLICAZIONE, z.VERSIONE_MDR, To_Char(w.DATA_RIFERIMENTO, 'YYYYMM') DATA_GIS
  From Rinf_Pubblicati_Evo.VERSIONE_RINF a, RINF_GIS_EVO.MDR_REGISTRO z, RINF_GIS_EVO.ANAG_MDR w
  Where a.CODICE_VERSIONE = z.CODICE_VERSIONE
  and  w.VERSIONE_MDR = z.VERSIONE_MDR 
  and z.CODICE_AREA = 4  
  and a.PROTOCOLLO IS Null
  order by 1 desc;
********************/

    Select a.CODICE_VERSIONE,  
	       a.DATA_PUBBLICAZIONE, 
		   Null DATA_TRASMISSIONE, 
		   a.DESCRIZIONE NOTE, 
		   a.FORMATO_PUBBLICAZIONE, 
		   z.VERSIONE_MDR, 
		   To_Char(w.DATA_RIFERIMENTO, 'YYYYMM') DATA_GIS, 
		   Nvl(reg.Num/2, 0) flag_racc_exist
      From Rinf_Pubblicati_Evo.VERSIONE_RINF a, 
	       RINF_GIS_EVO.MDR_REGISTRO z, 
		   RINF_GIS_EVO.ANAG_MDR w, 
          (Select CODICE_VERSIONE, 
		          Count (*) Num 
		     From Docs_Rinf_Evo.VERSIONE_RINF_SF vr 
			Where (ESTENSIONE_FILE = 'RXML' Or ESTENSIONE_FILE = 'RPDF') 
			group by CODICE_VERSIONE
			) reg
      Where a.CODICE_VERSIONE = z.CODICE_VERSIONE
        and w.VERSIONE_MDR = z.VERSIONE_MDR 
        and z.CODICE_AREA = 4  
        and a.PROTOCOLLO IS Null
        and a.CODICE_VERSIONE = reg.CODICE_VERSIONE (+)
     order by 1 desc;
--
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetAllRIPronti - Errore: '|| Substr(SQLERRM, 1, 300));
END GetAllRIPronti;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetAllRIInviati
-- -----------------------------------------------------------------------------
--
 Procedure GetAllRIInviati( p_cursor Out empcur) Is
  Begin
    Open p_cursor For
/*
Modifica del 13/09/2018 per aggiungere l'informazione sulla versione del gis (MDR) associata alla versione Rinf Pubblicati/Inviati
 il 27/09/2018 aggiunto il campo FORMATO_PUBBLICAZIONE,
   Select t.CODICE_VERSIONE, v.DATA_PUBBLICAZIONE, t.DATA_TRASMISSIONE, NOTE, v.PROTOCOLLO NUMERO_PROTOCOLLO, T.FTPS FTP_ADDRESS, T.MILLISECONDI
   From Rinf_Pubblicati_Evo.ANAGRAFICA_TRASMISSIONI t,
   Rinf_Pubblicati_Evo.VERSIONE_RINF v
   Where
   t.CODICE_VERSIONE=v.CODICE_VERSIONE AND
   t.CODICE_TRASMISSIONE=1
   order by 1 desc;
*/
    Select t.CODICE_VERSIONE,  
	       v.DATA_PUBBLICAZIONE, 
		   t.DATA_TRASMISSIONE, 
		   NOTE,
           v.PROTOCOLLO NUMERO_PROTOCOLLO, 
		   T.FTPS FTP_ADDRESS,
		   T.MILLISECONDI, 
		   v.FORMATO_PUBBLICAZIONE, 
		   z.VERSIONE_MDR, 
		   To_Char(w.DATA_RIFERIMENTO, 'YYYYMM') DATA_GIS
      From Rinf_Pubblicati_Evo.ANAGRAFICA_TRASMISSIONI t,
           Rinf_Pubblicati_Evo.VERSIONE_RINF v,
           RINF_GIS_EVO.MDR_REGISTRO z,
           RINF_GIS_EVO.ANAG_MDR w
     Where t.CODICE_VERSIONE = v.CODICE_VERSIONE   
	   And v.CODICE_VERSIONE = z.CODICE_VERSIONE  
	   And w.VERSIONE_MDR = z.VERSIONE_MDR     
	   And z.codice_area = 2 
	   And t.CODICE_TRASMISSIONE = 1
     Order By 1 Desc;
--
-- Devo restituire solo la prima trasmissione, quella ufficiale che ha dato luogo al protocollo
--
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetAllRIInviati - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetAllRIInviati;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetRapportoInviiRI
-- -----------------------------------------------------------------------------
--
 Procedure GetRapportoInviiRI (p_codice_versione Number, p_cursor Out empcur) Is
  Begin
    Open p_cursor For
     Select t.CODICE_VERSIONE,  
	        v.DATA_PUBBLICAZIONE, 
		    t.DATA_TRASMISSIONE,
		    DESCRIZIONE Note, 
		    v.PROTOCOLLO Numero_Protocollo, 
		    T.FTPS Ftp_Address,
		    NOTE
       From Rinf_Pubblicati_Evo.ANAGRAFICA_TRASMISSIONI t,
            Rinf_Pubblicati_Evo.VERSIONE_RINF v
      Where t.CODICE_VERSIONE = v.CODICE_VERSIONE 
	    And t.CODICE_VERSIONE = p_codice_versione;
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetRapportoInviiRI - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetRapportoInviiRI;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetAllProtocols
-- -----------------------------------------------------------------------------
--
 Procedure GetAllProtocols (p_cursor Out empcur) Is
/*
 16/09/2016 Alessio: c'?n vincolo di Unique Key sul protocollo nella tabella Rinf_Pubblicati_Evo.VERSIONE_RINF (non si pu?serire lo stesso protocollo pi  volte, anche con versioni diverse),
 in quanto l'Update di SetSendRI fallirebbe perch?otrebbe vedersi arrivare pi  volte lo stesso PROTOCOLLO.
 Con questa procedura si seleziona la lista dei protocolli esistenti per gestire il caso In cui l'utente voglia inserire un protocollo gi?sistente.
*/
  Begin
    Open p_cursor For
     Select PROTOCOLLO
       From Rinf_Pubblicati_Evo.VERSIONE_RINF
      Where PROTOCOLLO Is Not Null
     Order By 1 Desc;
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetAllProtocols - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetAllProtocols;
--
-- -----------------------------------------------------------------------------
--                          Procedure SetSendRI
-- -----------------------------------------------------------------------------
--
 Procedure SetSendRI( p_codice_versione Number,
                      p_protocollo Varchar2,
 					  p_ftp Varchar2, 
 					  p_destinatario Varchar2,
 					  p_note Varchar2, 
 					  p_millisecondi Number, 
 					  p_error Out Number) Is
    n_esiste Number;
  Begin
    p_error := 0;
    Select Count(*) 
	  Into n_esiste
      From Rinf_Pubblicati_Evo.VERSIONE_RINF
     Where CODICE_VERSIONE = p_codice_versione 
	   And PROTOCOLLO Is Not Null;

    If n_esiste = 0 Then
        Update Rinf_Pubblicati_Evo.VERSIONE_RINF
           Set PROTOCOLLO = p_protocollo
         Where CODICE_VERSIONE = p_codice_versione;
    End If;
--
    Insert Into Rinf_Pubblicati_Evo.ANAGRAFICA_TRASMISSIONI (
            CODICE_VERSIONE, 
			CODICE_TRASMISSIONE, 
			DATA_TRASMISSIONE, 
			DESTINATARIO, 
			FTPS, 
			NOTE, 
			MILLISECONDI  )
     Select p_codice_versione,
	        Nvl(Max(CODICE_TRASMISSIONE), 0) +1,
			Sysdate, 
			p_destinatario, 
			p_ftp, 
			p_note, 
			p_millisecondi
       From Rinf_Pubblicati_Evo.ANAGRAFICA_TRASMISSIONI
      Where CODICE_VERSIONE = p_codice_versione;
--
-- -----------------------------------------------------------------------------
--    10/11/2017 Gestione storicizzazione MDR GIS
-- -----------------------------------------------------------------------------
--
    PKG_RINF_GIS_V2.SP_SET_VERSIONE_MDR(2, p_codice_versione, p_error);
--
-- -----------------------------------------------------------------------------
--     Notifiche
-- -----------------------------------------------------------------------------
--
    PKG_RINF_NOTIFICHE.SETPOSTIIT_V2(4, Null, p_codice_versione, Null);
--
 EXCEPTION
    When OTHERS Then
        p_error := SQLCODE;
        Dbms_Output.Put_Line ('SetSendRI - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetSendRI;

--
-- -----------------------------------------------------------------------------
--                          Procedure GetFTPAddress
-- -----------------------------------------------------------------------------
--
 Procedure GetFTPAddress (p_cursor Out empcur) Is
  Begin
    Open p_cursor For
         Select USERNAME,
                PASSWORD,
                INDIRIZZO,
                CERTIFICATO
           From Docs_Rinf_Evo.FTP_ADDRESS;
 EXCEPTION
        When OTHERS Then
        Open p_cursor For 'Select Null USERNAME, Null PASSWORD, Null INDIRIZZO, Null CERTIFICATO From dual';
 END GetFTPAddress;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetMailServerAddress
-- -----------------------------------------------------------------------------
--
 Procedure GetMailServerAddress (p_cursor Out empcur) Is
  Begin
    Open p_cursor For
         Select NAME_MAIN,
                NAME_ALT,
                NAME_SMTP,
                PORT
           From Docs_Rinf_Evo.MAILSERVER_ADDRESS;
 EXCEPTION
        When OTHERS Then
        Open p_cursor For 'Select Null NAME_MAIN, Null NAME_ALT, Null NAME_SMTP, Null Port From dual';
 END GetMailServerAddress;
--
-- -----------------------------------------------------------------------------
--                          Procedure SetMailServerAddress
-- -----------------------------------------------------------------------------
Procedure SetMailServerAddress  
	(
		p_indirizzo   IN DOCS_RINF_EVO.MAILSERVER_ADDRESS.NAME_MAIN%TYPE, 
		p_alias       IN DOCS_RINF_EVO.MAILSERVER_ADDRESS.NAME_ALT%TYPE, 
		p_service 	  IN DOCS_RINF_EVO.MAILSERVER_ADDRESS.NAME_SMTP%TYPE, 
		p_port   	  IN DOCS_RINF_EVO.MAILSERVER_ADDRESS.PORT%TYPE, 
		p_errorcode  OUT NUMBER
	) IS

    BEGIN
        p_errorcode:=0;
		DELETE FROM DOCS_RINF_EVO.MAILSERVER_ADDRESS;
		INSERT 
			INTO DOCS_RINF_EVO.MAILSERVER_ADDRESS
				   (NAME_MAIN,  NAME_ALT, NAME_SMTP, PORT)
			VALUES (p_indirizzo,p_alias,  p_service, p_port);

		EXCEPTION
			WHEN OTHERS THEN
				p_errorcode:=SQLCODE;
				DBMS_OUTPUT.PUT_LINE('SetMailServerAddress error! ' || SQLCODE || ' - ' || SQLERRM);

END SetMailServerAddress;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetRIFile
-- -----------------------------------------------------------------------------
--
 Procedure GetRIFile (p_codice_versione   In     Number,
                      p_estensione_file   In     Varchar2,
                      p_cursor           Out     empcur)  Is
  Begin
    Open p_cursor For
         Select CODICE_VERSIONE,
                FILE_NAME,
                SUBMIT_DTM Data_Salvataggio,
                ESTENSIONE_FILE,
                DOCUMENT FILE_O
           From Docs_Rinf_Evo.VERSIONE_RINF_SF
          Where CODICE_VERSIONE = p_codice_versione
            And ESTENSIONE_FILE = Upper(p_estensione_file);
 EXCEPTION
    When OTHERS Then
       Open p_cursor For 'Select Null CODICE_VERSIONE, Null FILE_NAME, Null DATA_SALVATAGGIO, Null ESTENSIONE_FILE, Null FILE_O From dual';
 END GetRIFile;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetRIExist
-- -----------------------------------------------------------------------------
--
 Procedure GetRIExist (p_codice_versione   In     Number,
                       p_estensione_file   In     Varchar2,
                       p_cursor           Out     empcur) Is
  Begin
    Open p_cursor For
         Select Count(*) esiste
           From Docs_Rinf_Evo.VERSIONE_RINF_SF
          Where CODICE_VERSIONE = p_codice_versione
            And ESTENSIONE_FILE = Upper(p_estensione_file);
 EXCEPTION
    When OTHERS Then
         Open p_cursor For 'Select 0 esiste From dual';
 END GetRIExist;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetRIReport
-- -----------------------------------------------------------------------------
--
 Procedure GetRIReport (p_codice_versione   In     Number,
                        p_cursor           Out     empcur) Is
  Begin

    Open p_cursor For
       Select Replace(To_Char(N_SOL.conta,'999G999G999'),',','.') N_SOL,
              Replace(To_Char(N_SOL.conta * 6,'999G999G999'),',','.') N_SOL_PAR,
              Replace(To_Char(N_SOL_TRACK.conta,'999G999G999'),',','.') N_SOL_TRACK,
              Replace(To_Char(N_SOL_TRACK.conta * 99,'999G999G999'),',','.') N_SOL_TRACK_PAR,
              Replace(To_Char(N_SOL_TRACK_TUNNEL.conta,'999G999G999'),',','.') N_SOL_TRACK_TUNNEL,
              Replace(To_Char(N_SOL_TRACK_TUNNEL.conta * 11,'999G999G999'),',','.') N_SOL_TRACK_TUNNEL_PAR,
              Replace(To_Char(N_OP.conta,'999G999G999'),',','.') N_OP,
              Replace(To_Char(N_OP.conta * 6,'999G999G999'),',','.') N_OP_PAR,
              Replace(To_Char(N_PO_TRACK.conta,'999G999G999'),',','.') N_PO_TRACK,
              Replace(To_Char(N_PO_TRACK.conta * 11,'999G999G999'),',','.') N_PO_TRACK_PAR,
              Replace(To_Char(N_PO_PLATFORM.conta,'999G999G999'),',','.') N_PO_PLATFORM,
              Replace(To_Char(N_PO_PLATFORM.conta * 7,'999G999G999'),',','.') N_PO_PLATFORM_PAR,
              Replace(To_Char(N_PO_TRACK_TUNNEL.conta,'999G999G999'),',','.') N_PO_TRACK_TUNNEL,
              Replace(To_Char(N_PO_TRACK_TUNNEL.conta * 8,'999G999G999'),',','.') N_PO_TRACK_TUNNEL_PAR,
              Replace(To_Char(N_PO_SIDING.conta,'999G999G999'),',','.') N_PO_SIDING,
              Replace(To_Char(N_PO_SIDING.conta * 15,'999G999G999'),',','.') N_PO_SIDING_PAR,
              Replace(To_Char(N_PO_SIDING_TUNNEL.conta,'999G999G999'),',','.') N_PO_SIDING_TUNNEL,
              Replace(To_Char(N_PO_SIDING_TUNNEL.conta * 8,'999G999G999'),',','.') N_PO_SIDING_TUNNEL_PAR,
              Replace(To_Char(N_MILLISECONDI.millisecondi,'999G999G999'),',','.') MILLISECONDI
         From (Select Count (*) conta
                 From Rinf_Pubblicati_Evo.SEZIONI_LINEA
                Where CODICE_VERSIONE = p_codice_versione) N_SOL,
              (Select Count (*) conta
                 From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL
                Where CODICE_VERSIONE = p_codice_versione) N_SOL_TRACK,
              (Select Count (*) conta
                 From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL
                Where CODICE_VERSIONE = p_codice_versione) N_SOL_TRACK_TUNNEL,
              (Select Count (*) conta
                 From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI
                Where CODICE_VERSIONE = p_codice_versione) N_OP,
              (Select Count (*) conta
                 From Rinf_Pubblicati_Evo.BINARI_CORSA_PO
                Where CODICE_VERSIONE = p_codice_versione) N_PO_TRACK,
              (Select Count (*) conta
                 From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO
                Where CODICE_VERSIONE = p_codice_versione) N_PO_PLATFORM,
              (Select Count (*) conta
                 From Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO
                Where CODICE_VERSIONE = p_codice_versione) N_PO_TRACK_TUNNEL,
              (Select Count (*) conta
                 From Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO
                Where CODICE_VERSIONE = p_codice_versione) N_PO_SIDING,
              (Select Count (*) conta
                 From Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO
                Where CODICE_VERSIONE = p_codice_versione) N_PO_SIDING_TUNNEL,
              (Select MILLISECONDI
                 From Rinf_Pubblicati_Evo.ANAGRAFICA_TRASMISSIONI
                Where CODICE_VERSIONE = p_codice_versione
                  And CODICE_TRASMISSIONE = 1) N_MILLISECONDI;
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetRIReport - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetRIReport;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetRIReportPag2
-- -----------------------------------------------------------------------------
--
 Procedure GetRIReportPag2 (p_codice_versione In Number, p_cursor Out empcur) Is
  Begin
    Open p_cursor For
        Select v.CODICE_VERSIONE,
               v.DATA_PUBBLICAZIONE,
               v.PROTOCOLLO,
               a.DATA_RICHIESTA Richiesta_Autorizzazione,
               a.DATA_SCADENZA  Scadenza_Autorizzazione,
               va.CODICE_DTP,
               D.TOTALE_OP,
               d.TOTALE_SOL,
               u.CODICE_UTENTE,
               d.DATA_AUTORIZZAZIONE,
               Decode(FLAG_SEDE_CENTRALE, 0, 'Territorio', 'Sede Centrale '||SIGLA_TIPO_DEPOSITARIO)
               TIPO_PARAMETRI
          From Rinf_Pubblicati_Evo.VERSIONE_RINF v,
               RINF_AMMINISTRAZIONE_EVO.ANAG_RICHIESTE_AUTORIZZAZIONI a,
               (Select Distinct
                       CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP
                  From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI) va,
                       RINF_AMMINISTRAZIONE_EVO.DETTAGLIO_AUTORIZZAZIONI d,
                       RINF_SICUREZZA_EVO.ANAG_UTENTE u,
                       RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO t
                 Where v.CODICE_VERSIONE = va.CODICE_VERSIONE
                   And a.CODICE_RICHIESTA = va.CODICE_AUTORIZZAZIONE
                   And va.CODICE_AUTORIZZAZIONE = d.CODICE_RICHIESTA
                   And d.CODICE_DTP = va.CODICE_DTP
                   And d.FLAG_SEDE_CENTRALE = T.CODICE_TIPO_DEPOSITARIO (+)
                   And u.id_utente = d.id_utente
                   And v.CODICE_VERSIONE = p_codice_versione
                   And d.DATA_AUTORIZZAZIONE Is Not Null
          Order By va.CODICE_DTP Asc, 11 Desc;
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetRIReportPag2 - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetRIReportPag2;

--
-- -----------------------------------------------------------------------------
--                          Procedure GetRIReportPag3
-- -----------------------------------------------------------------------------
--
 Procedure GetRIReportPag3 (p_codice_versione In Number, p_cursor Out empcur) Is
  Begin
    Open p_cursor For
        Select
               v.CODICE_VERSIONE,
               v.DATA_PUBBLICAZIONE,
               v.PROTOCOLLO,
               va.CODICE_DTP,
               D.TOTALE_OP,
               d.totale_sol,
               d.DATA_AUTORIZZAZIONE,
               k.NUMERO_OP,
               k.NUMERO_SOL,
               k.DATA_ACQUISIZIONE
          From Rinf_Pubblicati_Evo.VERSIONE_RINF v,
               RINF_AMMINISTRAZIONE_EVO.ANAG_RICHIESTE_AUTORIZZAZIONI a,
               (Select Distinct
                       CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP
                  From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI) va,
               RINF_AMMINISTRAZIONE_EVO.DETTAGLIO_AUTORIZZAZIONI d,
               (Select a.CODICE_DTP,
                       a.CODICE_AUTORIZZAZIONE,
                       a.CODICE_CONTROLLO,
                       Sum (Decode(Substr (SEDE_TECNICA, 1, 2), 'LO', 1, 0))  NUMERO_OP,
                       Sum (Decode(Substr (SEDE_TECNICA, 1, 2), 'TR', 1, 0))  NUMERO_SOL,
                       h.DATA_ACQUISIZIONE
                  From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI a,
                       RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c,
                       RINF_LAVORAZIONE_EVO.ACQUISIZIONE_DATI h
                 Where CODICE_VERSIONE = p_codice_versione
                   And h.CODICE_ACQUISIZIONE = c.codice_acquisizione
                   And c.CODICE_CONTROLLO = a.CODICE_CONTROLLO
                 Group By a.CODICE_DTP,
                          a.CODICE_AUTORIZZAZIONE,
                          a.CODICE_CONTROLLO,
                          h.DATA_ACQUISIZIONE) k
         Where k.CODICE_DTP = va.CODICE_DTP
           And k.CODICE_AUTORIZZAZIONE = d.CODICE_RICHIESTA
           And v.CODICE_VERSIONE = va.CODICE_VERSIONE
           And a.CODICE_RICHIESTA = va.CODICE_AUTORIZZAZIONE
           And va.CODICE_AUTORIZZAZIONE = d.CODICE_RICHIESTA
           And d.CODICE_DTP = va.CODICE_DTP
           And v.CODICE_VERSIONE = p_codice_versione
           And FLAG_SEDE_CENTRALE = 0
           And d.DATA_AUTORIZZAZIONE Is Not Null
      Order By va.codice_dtp Asc;
--
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetRIReportPag3 - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetRIReportPag3;

--27/11/2017 i tre report NEW sono da sostituire ai precedenti non appena inizier?o sviluppo della parte applicativa del Raporto di sintesi
--
-- -----------------------------------------------------------------------------
--                          Procedure GetRIReportInt_NEW
-- -----------------------------------------------------------------------------
--
 Procedure GetRIReportInt_NEW (p_codice_versione   In     Number, 
                               p_cursor           Out     empcur)  Is
  Begin
    Open p_cursor For
/*
        Select v.CODICE_VERSIONE,
               v.DATA_PUBBLICAZIONE,
               v.PROTOCOLLO,
               a.DATA_RICHIESTA richiesta_autorizzazione,
               a.DATA_SCADENZA scadenza_autorizzazione
               From Rinf_Pubblicati_Evo.VERSIONE_RINF v,
               RINF_AMMINISTRAZIONE_EVO.ANAG_RICHIESTE_AUTORIZZAZIONI a,
               (Select distinct CODICE_VERSIONE, CODICE_AUTORIZZAZIONE
               From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI) r
               Where
               v.CODICE_VERSIONE=r.CODICE_VERSIONE
               And a.CODICE_RICHIESTA=r.CODICE_AUTORIZZAZIONE
               And v.CODICE_VERSIONE=p_codice_versione;
*/

        Select v.CODICE_VERSIONE,
               To_Char(v.DATA_PUBBLICAZIONE, 'dd/mm/yyyy hh24:mi:ss') Data_Pubblicazione,
               v.PROTOCOLLO,
               To_Char(a.DATA_RICHIESTA, 'dd/mm/yyyy hh24:mi:ss') Richiesta_Autorizzazione, --  a.DATA_RICHIESTA richiesta_autorizzazione,
               To_Char(a.DATA_SCADENZA, 'dd/mm/yyyy hh24:mi:ss') Scadenza_Autorizzazione  -- a.DATA_SCADENZA scadenza_autorizzazione
          From Rinf_Pubblicati_Evo.VERSIONE_RINF v,
               Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI a,
               (Select distinct CODICE_VERSIONE, CODICE_AUTORIZZAZIONE
                  From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI) r
          Where v.CODICE_VERSIONE = r.CODICE_VERSIONE
            And a.CODICE_RICHIESTA = r.CODICE_AUTORIZZAZIONE
            And v.CODICE_VERSIONE = p_codice_versione;
--
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetRIReportInt_NEW - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetRIReportInt_NEW;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetRIReport_NEW
-- -----------------------------------------------------------------------------
--
 Procedure GetRIReport_NEW (p_codice_versione   In     Number,
                            p_cursor           Out     empcur)   Is
  Begin
    Open p_cursor For
--
         Select Replace(To_Char(N_SOL.conta, '999G999G999'), ',', '.') N_SOL,
                0 NYA_SOL,
                Replace(To_Char(N_SOL.conta * 6, '999G999G999'), ',', '.') N_SOL_PAR,
                0 NYA_SOL_PAR,
                Replace(To_Char(N_SOL_TRACK.conta, '999G999G999'), ',', '.') N_SOL_TRACK,
                Replace(To_Char(GetCountObjectNYA('BINARI_CORSA_SOL', p_codice_versione), '999G999G999'), ',', '.') NYA_SOL_TRACK,
                Replace(To_Char(N_SOL_TRACK.conta * 99, '999G999G999'), ',', '.') N_SOL_TRACK_PAR,
                Replace(To_Char(GetCountParameterNYA('BINARI_CORSA_SOL', p_codice_versione),'999G999G999'), ',', '.') NYA_SOL_TRACK_PAR,
                Replace(To_Char(N_SOL_TRACK_TUNNEL.conta, '999G999G999'), ',', '.') N_SOL_TRACK_TUNNEL,
                Replace(To_Char(GetCountObjectNYA('GALLERIE_BINARI_SOL', p_codice_versione), '999G999G999'), ',', '.') NYA_SOL_TRACK_TUNNEL,
                Replace(To_Char(N_SOL_TRACK_TUNNEL.conta * 11, '999G999G999'), ',', '.') N_SOL_TRACK_TUNNEL_PAR,
                Replace(To_Char(GetCountParameterNYA('GALLERIE_BINARI_SOL', p_codice_versione), '999G999G999'), ',', '.') NYA_SOL_TRACK_TUNNEL_PAR,
                Replace(To_Char(N_OP.conta, '999G999G999'), ',', '.') N_OP,
                0 NYA_OP,
                Replace(To_Char(N_OP.conta * 6, '999G999G999'), ',', '.') N_OP_PAR,
                0 NYA_OP_PAR,
                Replace(To_Char(N_PO_TRACK.conta, '999G999G999'), ',', '.') N_PO_TRACK,
                Replace(To_Char(GetCountObjectNYA('BINARI_CORSA_PO', p_codice_versione), '999G999G999'), ',', '.') NYA_PO_TRACK,
                Replace(To_Char(N_PO_TRACK.conta * 11, '999G999G999'), ',', '.') N_PO_TRACK_PAR,
                Replace(To_Char(GetCountParameterNYA('BINARI_CORSA_PO', p_codice_versione), '999G999G999'), ',', '.') NYA_PO_TRACK_PAR,
                Replace(To_Char(N_PO_PLATFORM.conta, '999G999G999'), ',', '.') N_PO_PLATFORM,
                Replace(To_Char(GetCountObjectNYA('MARCIAPIEDI_BINARI_PO', p_codice_versione), '999G999G999'), ',', '.') NYA_PO_PLATFORM,
                Replace(To_Char(N_PO_PLATFORM.conta * 5 + N_BIN_PLATFORM.conta * 2, '999G999G999'), ',', '.') N_PO_PLATFORM_PAR,
                Replace(To_Char(GetCountParameterNYA('MARCIAPIEDI_BINARI_PO', p_codice_versione), '999G999G999'), ',', '.') NYA_PO_PLATFORM_PAR,
                Replace(To_Char(N_PO_TRACK_TUNNEL.conta, '999G999G999'), ',', '.') N_PO_TRACK_TUNNEL,
                Replace(To_Char(GetCountObjectNYA('GALLERIE_BINARI_PO', p_codice_versione), '999G999G999'), ',', '.') NYA_PO_TRACK_TUNNEL,
                Replace(To_Char(N_PO_TRACK_TUNNEL.conta * 8, '999G999G999'), ',', '.') N_PO_TRACK_TUNNEL_PAR,
                Replace(To_Char(GetCountParameterNYA('GALLERIE_BINARI_PO', p_codice_versione), '999G999G999'), ',', '.') NYA_PO_TRACK_TUNNEL_PAR,
                Replace(To_Char(N_PO_SIDING.conta, '999G999G999'), ',', '.') N_PO_SIDING,
                Replace(To_Char(GetCountObjectNYA('BINARI_RACCORDO_PO', p_codice_versione), '999G999G999'), ',', '.') NYA_PO_SIDING,
                Replace(To_Char(N_PO_SIDING.conta * 15, '999G999G999'), ',', '.') N_PO_SIDING_PAR,
                Replace(To_Char(GetCountParameterNYA('BINARI_RACCORDO_PO', p_codice_versione), '999G999G999'), ',', '.') NYA_PO_SIDING_PAR,
                Replace(To_Char(N_PO_SIDING_TUNNEL.conta, '999G999G999'), ',', '.') N_PO_SIDING_TUNNEL,
                Replace(To_Char(GetCountObjectNYA('GALLERIE_RACCORDO_PO', p_codice_versione), '999G999G999'), ',', '.') NYA_PO_SIDING_TUNNEL,
                Replace(To_Char(N_PO_SIDING_TUNNEL.conta * 8, '999G999G999'), ',', '.') N_PO_SIDING_TUNNEL_PAR,
         --       Replace(To_Char(GetCountParameterNYA('GALLERIE_RACCORDO_PO',p_codice_versione),'999G999G999'),',','.') NYA_PO_SIDING_TUNNEL_PAR,
                Replace(To_Char(nvl(PKG_RINF_PUBBLICAZIONE.GetCountParameterNYA('GALLERIE_RACCORDO_PO', 11), 0), '999G999G999'), ',', '.') NYA_PO_SIDING_TUNNEL_PAR,
                Replace(To_Char(N_MILLISECONDI.millisecondi, '999G999G999'), ',', '.') MILLISECONDI
           From (Select Count (*) conta
                   From Rinf_Pubblicati_Evo.SEZIONI_LINEA
                  Where CODICE_VERSIONE = p_codice_versione) N_SOL,
                (Select Count (*) conta
                   From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL
                  Where CODICE_VERSIONE = p_codice_versione) N_SOL_TRACK,
                (Select Count (*) conta
                   From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL
                  Where CODICE_VERSIONE = p_codice_versione) N_SOL_TRACK_TUNNEL,
                (Select Count (*) conta
                   From Rinf_Pubblicati_Evo.PUNTI_OPERATIVI
                  Where CODICE_VERSIONE = p_codice_versione) N_OP,
                (Select Count (*) conta
                   From Rinf_Pubblicati_Evo.BINARI_CORSA_PO
                  Where CODICE_VERSIONE = p_codice_versione) N_PO_TRACK,
                (Select Count (*) conta
                   From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO
                  Where CODICE_VERSIONE = p_codice_versione) N_PO_PLATFORM,
                (Select Sum(Decode(BINARIO_1, Null, 0, 1) + Decode(BINARIO_2, Null, 0, 1) + Decode(BINARIO_3, Null, 0, 1) + Decode(BINARIO_4, Null, 0, 1)) conta
                   From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO
                  Where CODICE_VERSIONE = p_codice_versione) N_BIN_PLATFORM,
                (Select Count (*) conta
                   From Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO
                  Where CODICE_VERSIONE = p_codice_versione) N_PO_TRACK_TUNNEL,
                (Select Count (*) conta
                   From Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO
                  Where CODICE_VERSIONE = p_codice_versione) N_PO_SIDING,
                (Select Count (*) conta
                   From Rinf_Pubblicati_Evo.GALLERIE_RACCORDO_PO
                  Where CODICE_VERSIONE = p_codice_versione) N_PO_SIDING_TUNNEL,
                  (Select MILLISECONDI
                   From Rinf_Pubblicati_Evo.ANAGRAFICA_TRASMISSIONI
                  Where CODICE_VERSIONE = p_codice_versione
                  And CODICE_TRASMISSIONE = 1) N_MILLISECONDI;
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetRIReport_NEW - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetRIReport_NEW;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetRIReportPag2_NEW
-- -----------------------------------------------------------------------------
--
 Procedure GetRIReportPag2_NEW (p_codice_versione   In   Number, 
                                p_cursor           Out   empcur)  Is
  Begin
    Open p_cursor For
         Select
              -- v.CODICE_VERSIONE,
              -- v.DATA_PUBBLICAZIONE,
              --  v.PROTOCOLLO,
              -- a.DATA_RICHIESTA richiesta_autorizzazione,
              -- a.DATA_SCADENZA scadenza_autorizzazione,
                va.CODICE_DTP,
                D.TOTALE_OP,
                d.TOTALE_SOL,
                u.CODICE_UTENTE,
                d.DATA_AUTORIZZAZIONE,
                Decode(FLAG_SEDE_CENTRALE, 0, 'Territorio', 'Sede Centrale '||SIGLA_TIPO_DEPOSITARIO)
                TIPO_PARAMETRI
          From Rinf_Pubblicati_Evo.VERSIONE_RINF v,
               Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI a,
               (Select Distinct
                       CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP
                  From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI) va,
               Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI d,
               Rinf_Sicurezza_Evo.ANAG_UTENTE u,
               Rinf_Sicurezza_Evo.ANAG_TIPO_DEPOSITARIO t
         Where v.CODICE_VERSIONE = va.CODICE_VERSIONE
           And a.CODICE_RICHIESTA = va.CODICE_AUTORIZZAZIONE
           And va.CODICE_AUTORIZZAZIONE = d.CODICE_RICHIESTA
           And d.CODICE_DTP = va.CODICE_DTP
           And d.FLAG_SEDE_CENTRALE = t.CODICE_TIPO_DEPOSITARIO (+)
           And u.id_utente = d.id_utente
           And v.CODICE_VERSIONE = p_codice_versione
           And d.data_autorizzazione Is Not Null
      Order By va.CODICE_DTP Asc, tipo_parametri Desc;
--
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetRIReportPag2_NEW - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetRIReportPag2_NEW;

--
-- -----------------------------------------------------------------------------
--                          Procedure GetRIReportPag3_NEW
-- -----------------------------------------------------------------------------
--
 Procedure GetRIReportPag3_NEW (p_codice_versione In   Number, 
                                p_cursor          Out  empcur)   Is
  Begin
    Open p_cursor For
         Select
            -- v.CODICE_VERSIONE,
            --   v.DATA_PUBBLICAZIONE,
            --   v.PROTOCOLLO,
               va.CODICE_DTP,
               D.TOTALE_OP,
               d.TOTALE_SOL,
               d.DATA_AUTORIZZAZIONE,
               k.NUMERO_OP,
               k.NUMERO_SOL,
               k.DATA_ACQUISIZIONE
          From Rinf_Pubblicati_Evo.VERSIONE_RINF v,
               Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI a,
               (Select Distinct
                       CODICE_VERSIONE, CODICE_AUTORIZZAZIONE, CODICE_DTP
                  From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI) va,
                       Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI d,
               (Select a.CODICE_DTP,
                       a.CODICE_AUTORIZZAZIONE,
                       a.CODICE_CONTROLLO,
                       Sum (Decode(Substr (SEDE_TECNICA, 1, 2), 'LO', 1, 0))  NUMERO_OP,
                       Sum (Decode(Substr (SEDE_TECNICA, 1, 2), 'TR', 1, 0))  NUMERO_SOL,
                       H.DATA_ACQUISIZIONE
                  From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI a,
                       Rinf_Lavorazione_Evo.CONTROLLO_DATI c,
                       Rinf_Lavorazione_Evo.ACQUISIZIONE_DATI h
                 Where CODICE_VERSIONE = p_codice_versione
                   And h.CODICE_ACQUISIZIONE = c.CODICE_ACQUISIZIONE
                   And c.CODICE_CONTROLLO = a.CODICE_CONTROLLO
              Group By a.CODICE_DTP,
                       a.CODICE_AUTORIZZAZIONE,
                       a.CODICE_CONTROLLO,
                       h.DATA_ACQUISIZIONE) k
                 Where k.CODICE_DTP = va.CODICE_DTP
                   And k.CODICE_AUTORIZZAZIONE = d.CODICE_RICHIESTA
                   And v.CODICE_VERSIONE = va.CODICE_VERSIONE
                   And A.CODICE_RICHIESTA = VA.CODICE_AUTORIZZAZIONE
                   And va.CODICE_AUTORIZZAZIONE = d.CODICE_RICHIESTA
                   And d.CODICE_DTP = va.CODICE_DTP
                   And v.CODICE_VERSIONE = p_codice_versione
                   And FLAG_SEDE_CENTRALE = 0
                   And d.DATA_AUTORIZZAZIONE Is Not Null
              Order By va.CODICE_DTP Asc;
--
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetRIReportPag3_NEW - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetRIReportPag3_NEW;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetRIReportPag4_NEW
-- -----------------------------------------------------------------------------
--
 Procedure GetRIReportPag4_NEW (p_versione     Number, 
                                p_cursor   Out Sys_Refcursor)   Is
-- Mail Schillaci del 25/05/2018 11:07
-- Pagina da aggiungere ai due Rapporti di Sintesi
--
    sqlstringa   clob;
    l_offset     Number;
--
    CURSOR  p_cur Is
    Select Distinct 
		   CODICE_PARAMETRO,
           NUMERO_PARAMETRO_MULTIPLO,
           Replace (DESCRIZIONE, '''', '''''') Desc_Parametro,
           NOME_TABELLA nome_tabella,
           Substr(NOME_COLONNA, Instr(NOME_COLONNA, '.') +1) Nome_Col,
           Substr(NOME_COLONNA, Instr(NOME_COLONNA, '.') +1)||'_AP' Nome_Col_Ap,
           STRINGA_JOIN str_join,
           APPLICABILITA
      From RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
     Where NOME_TABELLA Is  Not Null
       And NUMERO_PARAMETRO_MULTIPLO Not Like '1.1.1.1.6.1%'
       And NUMERO_PARAMETRO_MULTIPLO Not Like '1.1.1.1.8.5%'
       And NUMERO_PARAMETRO_MULTIPLO Not Like '1.1.1.1.8.6%'
       And NUMERO_PARAMETRO_MULTIPLO Not Like '%.AP'                               -->
       And NUMERO_PARAMETRO NOT In ('1.2.1.0.6.4', '1.2.1.0.6.5')
       And (APPLICABILITA = 0  Or    
	       (APPLICABILITA = 1 And NUMERO_PARAMETRO In
		                        (
                                  Select numero_parametro
                                  From RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
                                  Where nome_tabella is not Null
                                  And NUMERO_PARAMETRO_MULTIPLO Not Like '%.AP' 
                                  group by (numero_parametro)
                                  having Count(*) = 1)
                                 )
           ) 
  Union
    Select Distinct 
	       CODICE_PARAMETRO,
           NUMERO_PARAMETRO_MULTIPLO,
           Replace (DESCRIZIONE, '''', '''''') Desc_Parametro,
           NOME_TABELLA Nome_Tabella,
           Substr(NOME_COLONNA, Instr(NOME_COLONNA, '.') +1) Nome_Col,
           Substr(Substr(NOME_COLONNA, Instr(NOME_COLONNA, '.') +1), 1, Instr(NOME_COLONNA, '_' ,-1) -1)||'_AP' Nome_Col_Ap,
           STRINGA_JOIN Str_Join,
           APPLICABILITA
      From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
     Where NOME_TABELLA Is  Not Null
       And NUMERO_PARAMETRO_MULTIPLO Not Like '1.1.1.1.6.1%'
       And NUMERO_PARAMETRO_MULTIPLO Not Like '1.1.1.1.8.5%'
       And NUMERO_PARAMETRO_MULTIPLO Not Like '1.1.1.1.8.6%'
       And NUMERO_PARAMETRO_MULTIPLO Not Like '%.AP'                               -->
       And NUMERO_PARAMETRO Not In ('1.2.1.0.6.4', '1.2.1.0.6.5')
       And (APPLICABILITA = 1 And NUMERO_PARAMETRO in
	                             (
                                    Select NUMERO_PARAMETRO
                                      From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
                                     Where NOME_TABELLA Is Not Null
                                     And NUMERO_PARAMETRO_MULTIPLO Not Like '%.AP' 
                                  Group By NUMERO_PARAMETRO
                                    Having Count(*) > 1
								 )
             );

/***************************************	 sostituzione del 27/10/2020 per adeguarlo ai nuovi parametri RINF Reg.777/2019
        Select Distinct 
		   CODICE_PARAMETRO,
           NUMERO_PARAMETRO_MULTIPLO,
           Replace (DESCRIZIONE, '''', '''''') Desc_Parametro,
           NOME_TABELLA nome_tabella,
           Substr(NOME_COLONNA, Instr(NOME_COLONNA, '.') +1) Nome_Col,
           Substr(NOME_COLONNA, Instr(NOME_COLONNA, '.') +1)||'_AP' Nome_Col_Ap,
           STRINGA_JOIN str_join,
           APPLICABILITA
      From RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
     Where NOME_TABELLA Is  Not Null
       And NUMERO_PARAMETRO_MULTIPLO Not Like '1.1.1.1.6.1%'
       And NUMERO_PARAMETRO_MULTIPLO Not Like '1.1.1.1.8.5%'
       And NUMERO_PARAMETRO_MULTIPLO Not Like '1.1.1.1.8.6%'
       And NUMERO_PARAMETRO NOT In ('1.2.1.0.6.4', '1.2.1.0.6.5')
       And (APPLICABILITA = 0  Or    
	       (APPLICABILITA = 1 And NUMERO_PARAMETRO In
		                        (
                                  Select numero_parametro
                                  From RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
                                  Where nome_tabella is not Null
                                  group by (numero_parametro)
                                  having Count(*) = 1)
                                 )
           ) 
   Union
    Select Distinct 
	       CODICE_PARAMETRO,
           NUMERO_PARAMETRO_MULTIPLO,
           Replace (DESCRIZIONE, '''', '''''') Desc_Parametro,
           NOME_TABELLA Nome_Tabella,
           Substr(NOME_COLONNA, Instr(NOME_COLONNA, '.') +1) Nome_Col,
           Substr(Substr(NOME_COLONNA, Instr(NOME_COLONNA, '.') +1), 1, Instr(NOME_COLONNA, '_' ,-1) -1)||'_AP' Nome_Col_Ap,
           STRINGA_JOIN Str_Join,
           APPLICABILITA
      From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
     Where NOME_TABELLA Is  Not Null
       And NUMERO_PARAMETRO_MULTIPLO Not Like '1.1.1.1.6.1%'
       And NUMERO_PARAMETRO_MULTIPLO Not Like '1.1.1.1.8.5%'
       And NUMERO_PARAMETRO_MULTIPLO Not Like '1.1.1.1.8.6%'
       And NUMERO_PARAMETRO Not In ('1.2.1.0.6.4', '1.2.1.0.6.5')
       And (APPLICABILITA = 1 And NUMERO_PARAMETRO in
	                             (
                                    Select NUMERO_PARAMETRO
                                      From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
                                     Where NOME_TABELLA Is Not Null
                                  Group By NUMERO_PARAMETRO
                                    Having Count(*) > 1
								 )
             );
******************/
 --   
     sc_par_l p_cur%ROWType;
--
 Begin
    sqlstringa := '';
--
    Open p_cur;
--
      Loop
--
        Fetch p_cur Into sc_par_l;
         Exit When p_cur%NOTFOUND;
--
             Case When sc_par_l.APPLICABILITA = 0 
			   Then
                  sqlstringa := sqlstringa||' Select  '''||sc_par_l.NUMERO_PARAMETRO_MULTIPLO||''' NUMERO_PARAMETRO,';
                  sqlstringa := sqlstringa||' '''||sc_par_l.desc_parametro||''' desc_parametro,';
                  sqlstringa := sqlstringa||' Count(*) totale_parametri, 0 totale_NYA ';
                  sqlstringa := sqlstringa||' From Rinf_Pubblicati_Evo.'||sc_par_l.NOME_TABELLA||' ';
                  sqlstringa := sqlstringa||' Where CODICE_VERSIONE = '||To_Char(p_versione);
                  sqlstringa := sqlstringa||' Union ';
               Else               
                  sqlstringa := sqlstringa||' Select  '''||sc_par_l.NUMERO_PARAMETRO_MULTIPLO||''' NUMERO_PARAMETRO,';
                  sqlstringa := sqlstringa||' '''||sc_par_l.desc_parametro||''' desc_parametro,';
                  sqlstringa := sqlstringa||' n_p.totale_parametri, n_nya.totale_NYA ';
                  sqlstringa := sqlstringa||' From ';
                  sqlstringa := sqlstringa||' (Select  '''||sc_par_l.NUMERO_PARAMETRO_MULTIPLO||''' NUMERO_PARAMETRO,';
                  sqlstringa := sqlstringa||' '''||sc_par_l.desc_parametro||''' desc_parametro,';
                  sqlstringa := sqlstringa||' Count(*) totale_parametri';
                  sqlstringa := sqlstringa||' From Rinf_Pubblicati_Evo.'||sc_par_l.NOME_TABELLA||' ';
                  sqlstringa := sqlstringa||' Where CODICE_VERSIONE = '||To_Char(p_versione)||' ) n_p, ';
                  sqlstringa := sqlstringa||' (Select  '''||sc_par_l.NUMERO_PARAMETRO_MULTIPLO||''' NUMERO_PARAMETRO,';
                  sqlstringa := sqlstringa||' Count('||sc_par_l.nome_col_AP||') totale_NYA';
                  sqlstringa := sqlstringa||' From Rinf_Pubblicati_Evo.'||sc_par_l.NOME_TABELLA||'  ';
                  sqlstringa := sqlstringa||' Where '||sc_par_l.nome_col_AP||' = ''NYA''';
                  sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||To_Char(p_versione)||' ) n_nya ';
                  sqlstringa := sqlstringa||' Where n_p.NUMERO_PARAMETRO = n_nya.NUMERO_PARAMETRO';
                  sqlstringa := sqlstringa||' Union ';
               End Case;
      End Loop;

-- tolgo l'ultima UNION
-- sqlstringa:=Substr(sqlstringa,1,Length( sqlstringa)-7);
-- --------------------------------------------------------------------------------------------------------
---           Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO
--         PARAMETRO 1.2.1.0.6.4 e PARAMETRO 1.2.1.0.6.5
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'   Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'          DESCRIZIONE,';
    sqlstringa := sqlstringa||'          Count (*),';
    sqlstringa := sqlstringa||'          n_nya.totale_NYA Tot_Nya';
    sqlstringa := sqlstringa||'     From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO,';
    sqlstringa := sqlstringa||'          Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'          (Select Count(*) Totale_NYA';
    sqlstringa := sqlstringa||'             From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO';
    sqlstringa := sqlstringa||'            Where     PO_TR_PLAT_1_2_1_0_6_4_B1_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'                  And BINARIO_1 Is Not Null';
    sqlstringa := sqlstringa||'                  And CODICE_VERSIONE = '||To_Char(p_versione)||') n_nya';
    sqlstringa := sqlstringa||'    Where     BINARIO_1 Is Not Null';
    sqlstringa := sqlstringa||'          And NUMERO_PARAMETRO_MULTIPLO = ''1.2.1.0.6.4.B1''  ';
    sqlstringa := sqlstringa||'          And CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||' Group By NUMERO_PARAMETRO, DESCRIZIONE, n_nya.totale_NYA';
    sqlstringa := sqlstringa||' Union ';
    sqlstringa := sqlstringa||'   Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'          DESCRIZIONE,';
    sqlstringa := sqlstringa||'          Count (*),';
    sqlstringa := sqlstringa||'          n_nya.totale_NYA Tot_Nya ';
    sqlstringa := sqlstringa||'     From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO,';
    sqlstringa := sqlstringa||'          Rinf_Anagrafiche_evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'          (Select Count(*) totale_NYA ';
    sqlstringa := sqlstringa||'             From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO ';
    sqlstringa := sqlstringa||'            Where PO_TR_PLAT_1_2_1_0_6_4_B2_AP = ''NYA''  ';
    sqlstringa := sqlstringa||'              And BINARIO_2 IS NOT Null ';
    sqlstringa := sqlstringa||'              And CODICE_VERSIONE = '||To_Char(p_versione)||') n_nya';
    sqlstringa := sqlstringa||'    Where BINARIO_2 Is Not Null ';
    sqlstringa := sqlstringa||'          And NUMERO_PARAMETRO_MULTIPLO = ''1.2.1.0.6.4.B2''  ';
    sqlstringa := sqlstringa||'          And CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||' Group By NUMERO_PARAMETRO, DESCRIZIONE, n_nya.totale_NYA ';
    sqlstringa := sqlstringa||' Union';
    sqlstringa := sqlstringa||'   Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'          DESCRIZIONE,';
    sqlstringa := sqlstringa||'          Count (*),';
    sqlstringa := sqlstringa||'          n_nya.totale_NYA tot_nya';
    sqlstringa := sqlstringa||'     From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO,';
    sqlstringa := sqlstringa||'          Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'          (Select Count(*) totale_NYA';
    sqlstringa := sqlstringa||'             From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO';
    sqlstringa := sqlstringa||'            Where PO_TR_PLAT_1_2_1_0_6_4_B3_AP = ''NYA''  ';
    sqlstringa := sqlstringa||'              And BINARIO_3 IS NOT Null';
    sqlstringa := sqlstringa||'              And CODICE_VERSIONE = '||To_Char(p_versione)||') n_nya';
    sqlstringa := sqlstringa||'     Where BINARIO_3 Is Not Null';
    sqlstringa := sqlstringa||'          And NUMERO_PARAMETRO_MULTIPLO = ''1.2.1.0.6.4.B3''  ';
    sqlstringa := sqlstringa||'          And CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||' Group By NUMERO_PARAMETRO, DESCRIZIONE, n_nya.totale_NYA';
    sqlstringa := sqlstringa||' Union';
    sqlstringa := sqlstringa||'   Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'          DESCRIZIONE,';
    sqlstringa := sqlstringa||'          Count(*),';
    sqlstringa := sqlstringa||'          n_nya.totale_NYA tot_nya';
    sqlstringa := sqlstringa||'     From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO,';
    sqlstringa := sqlstringa||'          Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'          (Select Count(*) totale_NYA';
    sqlstringa := sqlstringa||'             From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO';
    sqlstringa := sqlstringa||'            Where PO_TR_PLAT_1_2_1_0_6_4_B4_AP = ''NYA''  ';
    sqlstringa := sqlstringa||'              And BINARIO_4 Is Not Null';
    sqlstringa := sqlstringa||'              And CODICE_VERSIONE = '||To_Char(p_versione)||') n_nya';
    sqlstringa := sqlstringa||'    Where BINARIO_4 is not null';
    sqlstringa := sqlstringa||'          And NUMERO_PARAMETRO_MULTIPLO = ''1.2.1.0.6.4.B4''  ';
    sqlstringa := sqlstringa||'          And CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||' Group By NUMERO_PARAMETRO, DESCRIZIONE, n_nya.totale_NYA';
    sqlstringa := sqlstringa||' Union';
    sqlstringa := sqlstringa||'   Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'          DESCRIZIONE,';
    sqlstringa := sqlstringa||'          Count(*),';
    sqlstringa := sqlstringa||'          n_nya.totale_NYA tot_nya';
    sqlstringa := sqlstringa||'     From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO,';
    sqlstringa := sqlstringa||'          Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'          (Select Count(*) totale_NYA';
    sqlstringa := sqlstringa||'             From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO';
    sqlstringa := sqlstringa||'            Where PO_TR_PLAT_1_2_1_0_6_5_B1_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'              And BINARIO_1 Is Not Null';
    sqlstringa := sqlstringa||'              And CODICE_VERSIONE = '||To_Char(p_versione)||') n_nya';
    sqlstringa := sqlstringa||'    Where BINARIO_1 Is Not Null';
    sqlstringa := sqlstringa||'          And NUMERO_PARAMETRO_MULTIPLO = ''1.2.1.0.6.5.B1''  ';
    sqlstringa := sqlstringa||'          And CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||' Group By NUMERO_PARAMETRO, DESCRIZIONE, n_nya.totale_NYA';
    sqlstringa := sqlstringa||' Union';
    sqlstringa := sqlstringa||'   Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'          DESCRIZIONE,';
    sqlstringa := sqlstringa||'          Count(*),';
    sqlstringa := sqlstringa||'          n_nya.totale_NYA tot_nya';
    sqlstringa := sqlstringa||'     From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO,';
    sqlstringa := sqlstringa||'          Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'          (Select Count(*) totale_NYA';
    sqlstringa := sqlstringa||'             From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO';
    sqlstringa := sqlstringa||'            Where PO_TR_PLAT_1_2_1_0_6_5_B2_AP = ''NYA''  ';
    sqlstringa := sqlstringa||'              And BINARIO_2 Is Not Null';
    sqlstringa := sqlstringa||'              And CODICE_VERSIONE = '||To_Char(p_versione)||') n_nya';
    sqlstringa := sqlstringa||'    Where BINARIO_2 Is Not Null';
    sqlstringa := sqlstringa||'      And NUMERO_PARAMETRO_MULTIPLO = ''1.2.1.0.6.5.B2''  ';
    sqlstringa := sqlstringa||'      And CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||' Group By NUMERO_PARAMETRO, DESCRIZIONE, n_nya.totale_NYA';
    sqlstringa := sqlstringa||' Union';
    sqlstringa := sqlstringa||'   Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'          DESCRIZIONE,';
    sqlstringa := sqlstringa||'          Count(*),';
    sqlstringa := sqlstringa||'          n_nya.totale_NYA tot_nya';
    sqlstringa := sqlstringa||'     From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO,';
    sqlstringa := sqlstringa||'          Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'          (Select Count (*) totale_NYA';
    sqlstringa := sqlstringa||'             From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO';
    sqlstringa := sqlstringa||'            Where PO_TR_PLAT_1_2_1_0_6_5_B3_AP = ''NYA''  ';
    sqlstringa := sqlstringa||'              And BINARIO_3 Is Not Null';
    sqlstringa := sqlstringa||'              And CODICE_VERSIONE = '||To_Char(p_versione)||') n_nya';
    sqlstringa := sqlstringa||'    Where BINARIO_3 Is Not Null';
    sqlstringa := sqlstringa||'      And NUMERO_PARAMETRO_MULTIPLO = ''1.2.1.0.6.5.B3''  ';
    sqlstringa := sqlstringa||'      And CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||' Group By NUMERO_PARAMETRO, DESCRIZIONE, n_nya.totale_NYA';
    sqlstringa := sqlstringa||' Union';
    sqlstringa := sqlstringa||'   Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'          DESCRIZIONE, ';
    sqlstringa := sqlstringa||'          Count(*),';
    sqlstringa := sqlstringa||'          n_nya.totale_NYA tot_nya ';
    sqlstringa := sqlstringa||'     From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO,';
    sqlstringa := sqlstringa||'          Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'          (Select Count (*) totale_NYA';
    sqlstringa := sqlstringa||'             From Rinf_Pubblicati_Evo.MARCIAPIEDI_BINARI_PO';
    sqlstringa := sqlstringa||'            Where PO_TR_PLAT_1_2_1_0_6_5_B4_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'              And BINARIO_4 Is Not Null ';
    sqlstringa := sqlstringa||'              And CODICE_VERSIONE = '||To_Char(p_versione)||') n_nya';
    sqlstringa := sqlstringa||'    Where BINARIO_4 Is Not Null';
    sqlstringa := sqlstringa||'      And NUMERO_PARAMETRO_MULTIPLO = ''1.2.1.0.6.5.B4''';
    sqlstringa := sqlstringa||'      And CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||' Group By NUMERO_PARAMETRO, DESCRIZIONE, n_nya.totale_NYA';
--
-- --------------------------------------------------------------------------------------------------------
--       1.2.1.0.1.1_Dichiarazione CE di verifica del binario (INF)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||' Union';
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'           And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count (*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select PO_TRACK_1_2_1_0_0_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.BINARI_CORSA_PO';
    sqlstringa := sqlstringa||'                   Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select PO_TRACK_1_2_1_0_0_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'                   And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC''  ';
    sqlstringa := sqlstringa||'             And PO_TRACK_1_2_1_0_1_1O2_AP = ''NYA''  ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t3';
    sqlstringa := sqlstringa||'   Where NUMERO_PARAMETRO_MULTIPLO = ''1.2.1.0.1.1'' ';
    sqlstringa := sqlstringa||' Union';
--
-- --------------------------------------------------------------------------------------------------------
--       1.2.1.0.1.2_Dichiarazione di dimostrazione IE del Binario (INF)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EI''  ';
    sqlstringa := sqlstringa||'           And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select PO_TRACK_1_2_1_0_0_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.BINARI_CORSA_PO';
    sqlstringa := sqlstringa||'                   Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select PO_TRACK_1_2_1_0_0_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'                   And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_PO';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'             And PO_TRACK_1_2_1_0_1_1O2_AP = ''NYA''  ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_ChaR(p_versione)||') t3';
    sqlstringa := sqlstringa||'   Where NUMERO_PARAMETRO_MULTIPLO = ''1.2.1.0.1.2''  ';
    sqlstringa := sqlstringa||' Union ';
--
-- --------------------------------------------------------------------------------------------------------
-- Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_CCS - 1.1.1.3.1.1_Dichiarazione CE di verifica del binario(CCS)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_CCS';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC''   ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select SOL_TRACK_1_1_1_0_0_1';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL ';
    sqlstringa := sqlstringa||'                    Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select SOL_TRACK_1_1_1_0_0_1';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_CCS';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EC''  ';
    sqlstringa := sqlstringa||'                     And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_CCS';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'            And SOL_TRACK_1_1_1_3_1_1_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'            And CODICE_VERSIONE = '||To_Char(p_versione)||') t3';
    sqlstringa := sqlstringa||'   Where NUMERO_PARAMETRO_MULTIPLO = ''1.1.1.3.1.1'' ';
    sqlstringa := sqlstringa||' Union';
--
-- --------------------------------------------------------------------------------------------------------
-- Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE - 1.1.1.2.1.1_Dichiarazione di verifica CE del binario (ENE)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select SOL_TRACK_1_1_1_0_0_1';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL';
    sqlstringa := sqlstringa||'                   Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select SOL_TRACK_1_1_1_0_0_1';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EC''  ';
    sqlstringa := sqlstringa||'                   And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC''  ';
    sqlstringa := sqlstringa||'             And SOL_TRACK_1_1_1_2_1_1O2_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t3';
    sqlstringa := sqlstringa||'   Where NUMERO_PARAMETRO_MULTIPLO = ''1.1.1.2.1.1''  ';
    sqlstringa := sqlstringa||' Union';
--
-- --------------------------------------------------------------------------------------------------------
-- Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE - 1.1.1.2.1.2_Dichiarazione di dimostrazione IE del binario (ENE)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select SOL_TRACK_1_1_1_0_0_1';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL';
    sqlstringa := sqlstringa||'                   Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select SOL_TRACK_1_1_1_0_0_1';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'                     And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EI''  ';
    sqlstringa := sqlstringa||'             And SOL_TRACK_1_1_1_2_1_1O2_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t3 ';
    sqlstringa := sqlstringa||'   Where NUMERO_PARAMETRO_MULTIPLO = ''1.1.1.2.1.2''  ';
    sqlstringa := sqlstringa||' Union';
--
-- --------------------------------------------------------------------------------------------------------
-- Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF - 1.1.1.1.1.1_Dichiarazione CE di verifica del binario (INF)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'           And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select SOL_TRACK_1_1_1_0_0_1';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL';
    sqlstringa := sqlstringa||'                   Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select SOL_TRACK_1_1_1_0_0_1';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'                     And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'             And SOL_TRACK_1_1_1_1_1_1O2_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t3';
    sqlstringa := sqlstringa||'   Where NUMERO_PARAMETRO_MULTIPLO = ''1.1.1.1.1.1'' ';
    sqlstringa := sqlstringa||' Union';
--
-- --------------------------------------------------------------------------------------------------------
-- Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF - 1.1.1.1.1.2_Dichiarazione di dimostrazione IE del binario (INF)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select SOL_TRACK_1_1_1_0_0_1';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.BINARI_CORSA_SOL';
    sqlstringa := sqlstringa||'                    Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select SOL_TRACK_1_1_1_0_0_1';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'                     And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_BINARIO_SOL_INF';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'             And SOL_TRACK_1_1_1_1_1_1O2_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t3';
    sqlstringa := sqlstringa||'   Where numero_parametro_multiplo = ''1.1.1.1.1.2'' ';
    sqlstringa := sqlstringa||' Union';
--
-- --------------------------------------------------------------------------------------------------------
-- Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO - 1.2.1.0.5.3_Dichiarazione CE di verifica della galleria (SRT)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select PO_TR_TUNNEL_1_2_1_0_5_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO';
    sqlstringa := sqlstringa||'                   Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select PO_TR_TUNNEL_1_2_1_0_5_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'                     And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'             And PO_TR_TUNNEL_1_2_1_0_5_3O4_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t3';
    sqlstringa := sqlstringa||'   Where NUMERO_PARAMETRO_MULTIPLO = ''1.2.1.0.5.3'' ';
    sqlstringa := sqlstringa||' Union';
--
-- --------------------------------------------------------------------------------------------------------
-- Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO - 1.2.1.0.5.4_Dichiarazione di dimostrazione IE per la GALLERIA (SRT)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select PO_TR_TUNNEL_1_2_1_0_5_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.GALLERIE_BINARI_PO';
    sqlstringa := sqlstringa||'                   Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select PO_TR_TUNNEL_1_2_1_0_5_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'                     And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'             And PO_TR_TUNNEL_1_2_1_0_5_3O4_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t3';    
	sqlstringa := sqlstringa||'   Where NUMERO_PARAMETRO_MULTIPLO = ''1.2.1.0.5.4'' ';
    sqlstringa := sqlstringa||' Union ';
--
-- --------------------------------------------------------------------------------------------------------
-- Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL - 1.1.1.1.8.5_Dichiarazione CE di verifica della galleria (SRT)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select SOL_TUNNEL_1_1_1_1_8_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL';
    sqlstringa := sqlstringa||'                   Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select SOL_TUNNEL_1_1_1_1_8_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'                     And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC''  ';
    sqlstringa := sqlstringa||'             And SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t3';
    sqlstringa := sqlstringa||'   Where NUMERO_PARAMETRO_MULTIPLO = ''1.1.1.1.8.5'' ';
    sqlstringa := sqlstringa||' Union';
--
-- --------------------------------------------------------------------------------------------------------
-- Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL - 1.1.1.1.8.6_Dichiarazione di dimostrazione IE per la galleria (SRT)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select SOL_TUNNEL_1_1_1_1_8_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.GALLERIE_BINARI_SOL';
    sqlstringa := sqlstringa||'                   Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select SOL_TUNNEL_1_1_1_1_8_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'                     And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC''  ';
    sqlstringa := sqlstringa||'             And SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t3';
    sqlstringa := sqlstringa||'   Where NUMERO_PARAMETRO_MULTIPLO = ''1.1.1.1.8.6'' ';
    sqlstringa := sqlstringa||' Union';
--
-- --------------------------------------------------------------------------------------------------------
-- Rinf_Pubblicati_Evo.DICHIARAZIONI_RACCORDO_PO - 1.2.2.0.1.1_Dichiarazione CE di verifica del binario di raccordo (INF)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_RACCORDO_PO';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'           And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select PO_SD_1_2_2_0_0_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO';
    sqlstringa := sqlstringa||'                   Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select PO_SD_1_2_2_0_0_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_RACCORDO_PO';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'                     And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_RACCORDO_PO ';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EC'' ';
    sqlstringa := sqlstringa||'             And PO_SD_1_2_2_0_1_1O2_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t3';
    sqlstringa := sqlstringa||'   Where NUMERO_PARAMETRO_MULTIPLO = ''1.2.2.0.1.1''  ';
    sqlstringa := sqlstringa||' Union ';

-- --------------------------------------------------------------------------------------------------------
-- Rinf_Pubblicati_Evo.DICHIARAZIONI_RACCORDO_PO - 1.2.2.0.1.2_Dichiarazione di dimostrazione IE del binario di raccordo (INF)
-- --------------------------------------------------------------------------------------------------------
    sqlstringa := sqlstringa||'  Select NUMERO_PARAMETRO,';
    sqlstringa := sqlstringa||'         DESCRIZIONE,';
    sqlstringa := sqlstringa||'         t1.CONTEGGIO + t2.CONTEGGIO Totale_Parametri,';
    sqlstringa := sqlstringa||'         t2.CONTEGGIO + t3.CONTEGGIO Totale_NYA';
    sqlstringa := sqlstringa||'    From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_RACCORDO_PO ';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'           And CODICE_VERSIONE = '||To_Char(p_versione)||') t1,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From (Select PO_SD_1_2_2_0_0_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.BINARI_RACCORDO_PO ';
    sqlstringa := sqlstringa||'                    Where CODICE_VERSIONE = '||To_Char(p_versione);
    sqlstringa := sqlstringa||'                  Minus';
    sqlstringa := sqlstringa||'                  Select PO_SD_1_2_2_0_0_2';
    sqlstringa := sqlstringa||'                    From Rinf_Pubblicati_Evo.DICHIARAZIONI_RACCORDO_PO';
    sqlstringa := sqlstringa||'                   Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'                     And CODICE_VERSIONE = '||To_Char(p_versione)||')) t2,';
    sqlstringa := sqlstringa||'         (Select Count(*) CONTEGGIO';
    sqlstringa := sqlstringa||'            From Rinf_Pubblicati_Evo.DICHIARAZIONI_RACCORDO_PO';
    sqlstringa := sqlstringa||'           Where TIPO_DICHIARAZIONE = ''EI'' ';
    sqlstringa := sqlstringa||'             And PO_SD_1_2_2_0_1_1O2_AP = ''NYA'' ';
    sqlstringa := sqlstringa||'             And CODICE_VERSIONE = '||To_Char(p_versione)||') t3';
    sqlstringa := sqlstringa||'   Where NUMERO_PARAMETRO_MULTIPLO = ''1.2.2.0.1.2'' ';
--
-- DBMS_OUTPUT.PUT_LINE (sqlstringa);
    OPEN p_cursor FOR sqlstringa;
    l_offset := 1;
--loop
--       exit When l_offset > dbms_lob.getLength(sqlstringa);
--        dbms_output.put_line( dbms_lob.Substr( sqlstringa, 255, l_offset ) );
--      l_offset := l_offset + 255;
--    end loop;
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetRIReportPag4_NEW - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetRIReportPag4_NEW;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetRIMetadata
-- -----------------------------------------------------------------------------
--
 Procedure GetRIMetadata (p_codice_area       In     Number,
                          p_codice_versione   In     Number,
                          p_cursor           Out     empcur)  Is
  Begin
    Case When p_codice_area = 1 Then
         Open p_cursor For
            Select    'Checked/Correct Area - '
                   || 'Control Code: '
                   || c.CODICE_CONTROLLO
                   || ' Control Date: '
                   || To_Char (C.DATA_CONTROLLO, 'DD/MM/YYYY HH24:MI:SS')
                   || ' Acquisition Date: '
                   || To_Char (a.DATA_ACQUISIZIONE, 'DD/MM/YYYY HH24:MI:SS')
                   || ' Data Date: '
                   || To_Char (l.DATA_SCARICO, 'DD/MM/YYYY HH24:MI:SS')
                      METADATO
              From (Select Max(CODICE_CONTROLLO) Codice
                      From Rinf_Lavorazione_Evo.CONTROLLO_DATI) cm,
                           Rinf_Lavorazione_Evo.CONTROLLO_DATI c,
                           Rinf_Lavorazione_Evo.ACQUISIZIONE_DATI a,
                           Rinf_Staging_Evo.ANAG_CARICAMENTI l
                     Where cm.CODICE = c.CODICE_CONTROLLO
                       And c.CODICE_ACQUISIZIONE = a.CODICE_ACQUISIZIONE
                       And a.CODICE_CARICAMENTO = l.CODICE_CARICAMENTO;
         When p_codice_area = 2 Then
         Open p_cursor For
            Select    'Published/Sent Area - '
                   || 'Version: '
                   || v.CODICE_VERSIONE
                   || ' Data/Time: '
                   || To_Char (DATA_TRASMISSIONE, 'DD/MM/YYYY HH24:MI:SS')
                   || Decode(PROTOCOLLO, Null, ' ', ' Protocol: ' || PROTOCOLLO)
                      METADATO
              From Rinf_Pubblicati_Evo.VERSIONE_RINF v,
                  (Select CODICE_VERSIONE, DATA_TRASMISSIONE 
			         From Rinf_Pubblicati_Evo.ANAGRAFICA_TRASMISSIONI
                    Where CODICE_TRASMISSIONE = 1) t
             Where v.CODICE_VERSIONE = p_codice_versione
               And v.CODICE_VERSIONE = t.CODICE_VERSIONE;
         When p_codice_area = 3 Then
         Open p_cursor For
            Select    'RI Permission Request Area - '
                   || ' Request Data: '
                   || To_Char (DATA_RICHIESTA, 'DD/MM/YYYY HH24:MI:SS')
                   || ' Request Expiration Data: '
                   || To_Char (DATA_SCADENZA, 'DD/MM/YYYY HH24:MI:SS')
                   || Decode(NOTE, Null, ' ', ' Notes: ' || NOTE)
                      METADATO
              From (Select Max (CODICE_RICHIESTA) codice
                      From RINF_AMMINISTRAZIONE_EVO.ANAG_RICHIESTE_AUTORIZZAZIONI) cm,
                   RINF_AMMINISTRAZIONE_EVO.ANAG_RICHIESTE_AUTORIZZAZIONI c
             Where cm.CODICE = c.CODICE_RICHIESTA;
         When p_codice_area = 4 Then
         Open p_cursor For
            Select    'RI Ready Area - '
                   || 'Version: '
                   || CODICE_VERSIONE
                   || ' Data/Time: '
                   || To_Char (DATA_PUBBLICAZIONE, 'DD/MM/YYYY HH24:MI:SS')
                      METADATO
              From Rinf_Pubblicati_Evo.VERSIONE_RINF v
             Where CODICE_VERSIONE = p_codice_versione;
    End Case;
--
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetRIMetadata - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetRIMetadata;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetRIVersion
-- -----------------------------------------------------------------------------
--
 Procedure GetRIVersion (p_cursor  Out empcur)  Is
   Begin
         Open p_cursor For
            Select CODICE_STATO, ETICHETTA NUMERO_VERSIONE
              From Rinf_Anagrafiche_Evo.ANAG_VERSIONE
             Where (CODICE_STATO, NUMERO_VERSIONE) In
                      (  Select CODICE_STATO, Max(NUMERO_VERSIONE)
                           From Rinf_Anagrafiche_Evo.ANAG_VERSIONE
                          Where DATA_FINE_VALIDITA Is Null
                       Group By CODICE_STATO );

--22/02/2018 Modificato per permettere la visualizzazione corretta della versione dell'applicazione (tringa invece del numero)
--            Select CODICE_STATO,MAX(NUMERO_VERSIONE) NUMERO_VERSIONE
--              From RINF_ANAGRAFICHE_EVO.ANAG_VERSIONE
--             Where DATA_FINE_VALIDITA IS Null
--             GROUP BY CODICE_STATO;
 EXCEPTION
    When OTHERS Then
         Open p_cursor For 'Select ''IT'' CODICE_STATO,0 NUMERO_VERSIONE From dual';
 END GetRIVersion;

--
-- -----------------------------------------------------------------------------
--                          Procedure SetDownLoadRI
-- -----------------------------------------------------------------------------
--
 Procedure SetDownLoadRI(p_codice_versione Number,
                         p_protocollo Varchar2,
						 p_ftp Varchar2, 
						 p_utente Varchar2,
						 p_nome_file Varchar2, 
						 p_data_trasmissione DATE, 
						 p_esito Number, 
						 p_error Out Number) Is

  Begin
    p_error := 0;
--
    Insert Into  Rinf_Pubblicati_Evo.ANAGRAFICA_DOWNLOAD (
                  CODICE_VERSIONE, 
				  PROTOCOLLO, 
				  DATA_TRASMISSIONE, 
				  DATA_DOWNLOAD, 
				  CODICE_UTENTE, 
				  NOME_FILE, 
				  FTPS, 
				  ESITO )
          Values (p_codice_versione,
		          p_protocollo,
				  p_data_trasmissione,
				  Sysdate,
				  p_utente,
				  p_nome_file,
				  p_ftp,
				  p_esito);
--
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('SetDownLoadRI - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetDownLoadRI;
--
-- -----------------------------------------------------------------------------
--                          Procedure 
-- -----------------------------------------------------------------------------
--
 Procedure GetDownLoadRI (p_cursor  Out empcur)   Is
   Begin
       Open p_cursor For
            Select CODICE_VERSIONE, 
			       PROTOCOLLO, 
				   DATA_TRASMISSIONE, 
				   DATA_DOWNLOAD, 
				   CODICE_UTENTE, 
				   NOME_FILE, 
				   FTPS, 
				   ESITO
              From Rinf_Pubblicati_Evo.ANAGRAFICA_DOWNLOAD;
 EXCEPTION
    When OTHERS Then
        Open p_cursor For 'Select Null CODICE_VERSIONE, Null PROTOCOLLO, Null DATA_TRASMISSIONE, Null DATA_DOWNLOAD, Null CODICE_UTENTE, Null NOME_FILE, Null FTPS, Null ESITO From dual';
   END GetDownLoadRI;
--
-- -----------------------------------------------------------------------------
--                          Procedure 
-- -----------------------------------------------------------------------------
--
 Procedure GetRISent( p_versione     Varchar2, 
                      p_cursor   Out empcur) Is
    sqlstring  Varchar2(1000);
    s_versioni Varchar2(500);
--
  Begin
    s_versioni := Substr(p_versione, 1, Length(p_versione) -1);                               --> da verificare il -1!!!!
    sqlstring := 'Select t.CODICE_VERSIONE,  Min(t.DATA_TRASMISSIONE) DATA_TRASMISSIONE ';
    sqlstring := sqlstring||' From Rinf_Pubblicati_Evo.ANAGRAFICA_TRASMISSIONI t, ';
    sqlstring := sqlstring||' Rinf_Pubblicati_Evo.VERSIONE_RINF v ';
    sqlstring := sqlstring||' Where ';
    sqlstring := sqlstring||' t.CODICE_VERSIONE = v.CODICE_VERSIONE And ';
    sqlstring := sqlstring||' t.CODICE_VERSIONE In ('||s_versioni ||')';
    sqlstring := sqlstring||' Group By t.CODICE_VERSIONE';
    Open p_cursor For sqlstring;
 EXCEPTION
    When OTHERS Then
         Open p_cursor For 'Select Null CODICE_VERSIONE, Null DATA_TRASMISSIONE From Dual';
 END GetRISent;
--
-- -----------------------------------------------------------------------------
--                          Procedure SetPubblicaRI
-- -----------------------------------------------------------------------------
--
 Procedure SetPubblicaRI (p_codice_versione        Number, 
                          p_formato_pubblica       Number, 
						  p_error              Out Number) Is
    v_Formato_Pubblica Number;
  Begin
    p_error := 0;
    If p_formato_pubblica >1 Then
            v_formato_pubblica := 1;
    Elsif p_formato_pubblica Is Null Then
            v_formato_pubblica := 0;
    Else v_formato_pubblica := p_formato_pubblica;
    End If;

    Update Rinf_Pubblicati_Evo.VERSIONE_RINF
    Set  FORMATO_PUBBLICAZIONE = v_formato_pubblica
    Where CODICE_VERSIONE = p_codice_versione
    And PROTOCOLLO is Null;
--
 EXCEPTION
    When OTHERS Then
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetPubblicaRI '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetPubblicaRI - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetPubblicaRI;
--
-- -----------------------------------------------------------------------------
--                          Procedure SetAbilitaRI
-- -----------------------------------------------------------------------------
--
 Procedure SetAbilitaRI (p_pubblicazione     Number, 
                         p_error         Out Number) Is

    v_pubblicazione Number;
  Begin
    p_error := 0;
--
    If p_pubblicazione >1 Then
         v_pubblicazione := 1;
    Elsif p_pubblicazione Is Null Then
         v_pubblicazione := 0;
    Else
      v_pubblicazione := p_pubblicazione;
    End If;
--
    Update Rinf_Pubblicati_Evo.ANAGRAFICA_PUBBLICAZIONE_RI
       Set FLAG_PUBBLICAZIONE = v_pubblicazione
     Where NOME_TABELLA = 'VERSIONE_RINF';
--
 EXCEPTION
    When OTHERS Then
        PKG_RINF_UTILITY.SetNewLOG(0, 'PKG_RINF_PUBBLICAZIONE.SetAbilitaRI '||SQLERRM, PKG_RINF_SICUREZZA.GetUserIDServizio, p_error);
        Dbms_Output.Put_Line ('SetAbilitaRI - Errore: '|| Substr(SQLERRM, 1, 300));
 END SetAbilitaRI;
--
-- -----------------------------------------------------------------------------
--                          Procedure GetAbilitaRI
-- -----------------------------------------------------------------------------
--
 Procedure GetAbilitaRI (p_cursor  Out empcur) Is
--(p_pubblicazione Out Number) IS
  Begin
    Open p_cursor For
       Select nvl(FLAG_PUBBLICAZIONE , 0) FLAG_PUBBLICAZIONE
          From Rinf_Pubblicati_Evo.ANAGRAFICA_PUBBLICAZIONE_RI
         Where NOME_TABELLA = 'VERSIONE_RINF';
 EXCEPTION
    When OTHERS Then
        Dbms_Output.Put_Line ('GetAbilitaRI - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetAbilitaRI;
-- -----------------------------------------------------------------------------
--
END PKG_RINF_PUBBLICAZIONE;
/