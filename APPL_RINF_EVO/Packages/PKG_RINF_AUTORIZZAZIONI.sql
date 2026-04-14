--
-- PKG_RINF_AUTORIZZAZIONI  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_AUTORIZZAZIONI" Is

Type EMPCUR Is Ref CURSOR;
Procedure SetAuthorizationRequest(p_DATA_SCADENZA DATE, p_NOTE Varchar2,p_Codice_Autorizzazione Out Number,p_error Out Number);
Procedure GetAuthorizationMails (p_Codice_Autorizzazione    Varchar2, p_cursor Out EMPCUR);
Procedure GetAuthorizationReqInfo (p_Codice_Autorizzazione    Varchar2, p_cursor Out EMPCUR);
Procedure GetAllAuthorizationReq (p_cursor Out EMPCUR);
Procedure GetAuthorizationDetails (p_Codice_Autorizzazione    Number, p_cursor Out EMPCUR);
Procedure SetAuthorizeMyData (p_Codice_Utente   Varchar2, p_codice_dtp Varchar2, p_Codice_Autorizzazione  Varchar2, p_is_sede_centrale Number, p_error  Out Number);
Procedure GetAuthorizationStatus (p_Codice_Autorizzazione Varchar2, p_cursor Out EMPCUR);
Procedure SetDeclareReadyRI ( p_Codice_Autorizzazione  Varchar2, p_nota Varchar2,p_versione Out Number, p_error  Out Number);
Procedure GetUserParameters (p_codice_dtp       Varchar2, p_cursor  Out EMPCUR);
Procedure GetSCParameters (p_codice_dtp Varchar2, p_tipo_dep Number, p_cursor  Out EMPCUR);
Procedure SetOPClear (p_error Out Number);
Procedure SetSOLClear (p_error Out Number);

--test
Procedure SetAuthorizationDetails (p_Codice_Autorizzazione       Number,
                                   p_error                   Out Number);
End;
/


--
-- PKG_RINF_AUTORIZZAZIONI  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_AUTORIZZAZIONI" Is

-- ----------------------------------------------------------------------------
--                   Procedure SetDataRiferimento
-- ----------------------------------------------------------------------------
  Procedure SetDataRiferimento (p_Codice_Autorizzazione Number, p_error Out Number) Is
    BEGIN
      p_error := 0;
      Update Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI
         Set DATA_RIFERIMENTO = (select Max(DATA_RIFERIMENTO) From Rinf_Lavorazione_Evo.CONTROLLO_DATI)
       Where CODICE_RICHIESTA =  p_Codice_Autorizzazione;
  EXCEPTION
        When OTHERS Then
             p_error := SQLCODE;
             Dbms_Output.Put_Line ('SetDataRiferimento - Errore : ' || Substr (Sqlerrm, 1, 300));
  End SetDataRiferimento;
--
-- ----------------------------------------------------------------------------
--                   Procedure SetOPClear
-- ----------------------------------------------------------------------------
 Procedure SetOPClear (p_error Out Number) Is
   BEGIN
      p_error := 0;
-- Reg.2019/777
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_2_3_2_DOC_NORME; 
--
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_2_1_0_2_1_CAT_TEN_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_2_1_0_2_2_CAT_LINEA;
--
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_2_1_0_6_3_CAT_TEN_PL;
--
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_2_2_0_0_3_CAT_TEN_SD;
--
      Delete From Rinf_Autorizzazioni_Evo.CORRIDOIO_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.LINEE_TENT_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.LINEA_COMM_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.LINEA_TRIPLETTA;
--
      Delete From Rinf_Autorizzazioni_Evo.REL_GALLERIE_RACCORDO_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_GALLERIE_SD_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.GALLERIE_RACCORDO_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_RACCORDO_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.BINARI_RACCORDO_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.MARCIAPIEDI_BINARI_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_GALLERIE_BIN_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.REL_GALLERIE_BINARI_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA;
--
      Delete From Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO;
--
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_2_0_0_0_3_TAF_TAP;
--
      Delete From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI;
--
   EXCEPTION
      When OTHERS  Then
         p_error := SQLCODE;
         Dbms_Output.Put_Line ('SetOPClear - Errore: ' || Substr (SQLERRM, 1, 300));
   End SetOPClear;
--
-- ----------------------------------------------------------------------------
--                   Procedure SetSOLClear
-- ----------------------------------------------------------------------------
 Procedure SetSOLClear (p_error Out Number) Is
   BEGIN
      p_error := 0;
-- Reg.2019/777
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_4_3_LOCAVERSPEC; 
-- Reg.2019/777
	  Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_7_8_LOCA_SIST_RTB;
-- Reg.2019/777
	  Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_2_9_COMP_ETCS;
-- Reg.2019/777
	  Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_3_5_RETI_GSM_R;
-- Reg.2019/777
	  Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_3_9_RADIO_VOCE;
-- Reg.2019/777
	  Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_3_10_RADIO_DATI;
-- Reg.2019/777
	  Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_5_3_SIST_PRE_PROT;
-- Reg.2019/777
	  Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_7_1_3_SISTRILTRAIN;
-- Reg.2019/777
	  Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_7_11_1_CARMIN_ASSE;
-- Reg.2019/777
	  Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_4_2_NORME_DOC;
--
      Delete From Rinf_Autorizzazioni_Evo.CORRIDOIO_SOL;
--
      Delete From Rinf_Autorizzazioni_Evo.LINEE_TENT_SOL;
--
      Delete From Rinf_Autorizzazioni_Evo.LINEA_COMM_SOL;
--
      Delete From Rinf_Autorizzazioni_Evo.LINEA_FCL_SOL;
--
      Delete From Rinf_Autorizzazioni_Evo.FASCICOLO_SOL;
--
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_3_6_GRADIENTE;
--
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL;
--
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_2_CAT_LINEA;
--
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_4_CAP_CARICO;
--
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_3_4_PROF_CAS_M;
--
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_3_5_PROF_SEMI_R;
--
      Delete From Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_3_3_GSM_R_FAC;
--
      Delete From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL;
--
      Delete From Rinf_Autorizzazioni_Evo.REL_GALLERIE_BINARI_SOL;
--
      Delete From Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_SOL;
--
      Delete From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_SOL_CCS;
--
      Delete From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_SOL_ENE;
--
      Delete From Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_SOL_INF;
--
      Delete From Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL;
--
      Delete From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA;
--
   EXCEPTION
      When OTHERS Then
         p_error := SQLCODE;
         Dbms_Output.Put_Line ('SetSOLClear - Errore: ' || Substr (SQLERRM, 1, 300));
   End SetSOLClear;
--
-- ----------------------------------------------------------------------------
--                   Procedure SetOPAuthorizationSchema (PUNTI_OPERATIVI,...)
-- ----------------------------------------------------------------------------
 Procedure SetOPAuthorizationSchema (
      p_Codice_Autorizzazione       Varchar2,
      p_error                   Out Number)  Is
   BEGIN
      p_error := 0;

      Insert Into  Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI 
             (  SEDE_TECNICA,
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
                CODICE_CONTROLLO,
                CODICE_RICHIESTA,
                TIPO_LOCALITA_CONFINE,
                GRUPPO_AUTORIZZATIVO,
				PO_1_2_0_0_0_4_1_AP,
				PO_1_2_0_0_0_4_1,
				PO_1_2_3_1_AP,
 				PO_1_2_3_1,
				PO_1_2_3_2_AP		)
         Select SEDE_TECNICA,
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
                CODICE_CONTROLLO,
                p_Codice_Autorizzazione,
                TIPO_LOCALITA_CONFINE,
                GRUPPO_AUTORIZZATIVO,
                PO_1_2_0_0_0_4_1_Ap,
    			PO_1_2_0_0_0_4_1, 
                PO_1_2_3_1_AP,
				PO_1_2_3_1, 
				PO_1_2_3_2_AP
           From Rinf_Controllati_Evo.PUNTI_OPERATIVI;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_2_0_0_0_3_TAF_TAP
        Select * from Rinf_Controllati_Evo.PAR_1_2_0_0_0_3_TAF_TAP;
--
      Insert Into  Rinf_Autorizzazioni_Evo.BINARI_CORSA_PO (
	          PO_TRACK_1_2_1_0_0_1           ,
              PO_TRACK_1_2_1_0_0_2           ,
              PO_TRACK_1_2_1_0_0_2_D         ,
              PO_TRACK_1_2_1_0_2_1_AP        ,
              PO_TRACK_1_2_1_0_2_2_AP        ,
              PO_TRACK_1_2_1_0_2_3_AP        ,
              PO_TRACK_1_2_1_0_3_1_AP        ,
              PO_TRACK_1_2_1_0_3_1           ,
              PO_TRACK_1_2_1_0_3_2_AP        ,
              PO_TRACK_1_2_1_0_3_2           ,
              PO_TRACK_1_2_1_0_3_3_AP        ,
              PO_TRACK_1_2_1_0_3_3           ,
              PO_TRACK_1_2_1_0_4_1_AP        ,
              PO_TRACK_1_2_1_0_4_1           ,
              GRUPPO_AUTORIZZATIVO           ,
              PO_TRACK_1_2_1_0_3_4_AP        ,
              PO_TRACK_1_2_1_0_3_4_SUP       ,
              PO_TRACK_1_2_1_0_3_4_INF       ,
              PO_TRACK_1_2_1_0_3_5_AP        ,
              PO_TRACK_1_2_1_0_3_5_A         ,
              PO_TRACK_1_2_1_0_3_5_B         ,
              PO_TRACK_1_2_1_0_3_6_AP        ,
              PO_TRACK_1_2_1_0_3_6 )
        Select 
	          PO_TRACK_1_2_1_0_0_1           ,
              PO_TRACK_1_2_1_0_0_2           ,
              PO_TRACK_1_2_1_0_0_2_D         ,
              PO_TRACK_1_2_1_0_2_1_AP        ,
              PO_TRACK_1_2_1_0_2_2_AP        ,
              PO_TRACK_1_2_1_0_2_3_AP        ,
              PO_TRACK_1_2_1_0_3_1_AP        ,
              PO_TRACK_1_2_1_0_3_1           ,
              PO_TRACK_1_2_1_0_3_2_AP        ,
              PO_TRACK_1_2_1_0_3_2           ,
              PO_TRACK_1_2_1_0_3_3_AP        ,
              PO_TRACK_1_2_1_0_3_3           ,
              PO_TRACK_1_2_1_0_4_1_AP        ,
              PO_TRACK_1_2_1_0_4_1           ,
              GRUPPO_AUTORIZZATIVO           ,
              PO_TRACK_1_2_1_0_3_4_AP        ,
              PO_TRACK_1_2_1_0_3_4_SUP       ,
              PO_TRACK_1_2_1_0_3_4_INF       ,
              PO_TRACK_1_2_1_0_3_5_AP        ,
              PO_TRACK_1_2_1_0_3_5_A         ,
              PO_TRACK_1_2_1_0_3_5_B         ,
              PO_TRACK_1_2_1_0_3_6_AP        ,
              PO_TRACK_1_2_1_0_3_6
		from Rinf_Controllati_Evo.BINARI_CORSA_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.REL_PO_BINARI_CORSA (
	           PO_TRACK_1_2_1_0_0_2,
               SEDE_TECNICA  )
        Select PO_TRACK_1_2_1_0_0_2,
               SEDE_TECNICA
		from Rinf_Controllati_Evo.REL_PO_BINARI_CORSA;
--
      Insert Into  Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_PO (
	         PO_TRACK_1_2_1_0_0_2         , 
             TIPO_DICHIARAZIONE           ,
             PO_TRACK_1_2_1_0_1_1O2_AP    ,
             PO_TRACK_1_2_1_0_1_1O2       ,
             KM_INIZIO                    ,
             KM_FINE                      ,
             LATITUDINE_INIZIO            ,
             LONGITUDINE_INIZIO           ,
             ALTITUDINE_INIZIO            ,
             LATITUDINE_FINE              ,
             LONGITUDINE_FINE             ,
             ALTITUDINE_FINE              ,
             FLAG_CALCOLATO         )
        Select 
             PO_TRACK_1_2_1_0_0_2         , 
             TIPO_DICHIARAZIONE           ,
             PO_TRACK_1_2_1_0_1_1O2_AP    ,
             PO_TRACK_1_2_1_0_1_1O2       ,
             KM_INIZIO                    ,
             KM_FINE                      ,
             LATITUDINE_INIZIO            ,
             LONGITUDINE_INIZIO           ,
             ALTITUDINE_INIZIO            ,
             LATITUDINE_FINE              ,
             LONGITUDINE_FINE             ,
             ALTITUDINE_FINE              ,
             FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.DICHIARAZIONI_BINARIO_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_PO (
	        PO_TR_TUNNEL_1_2_1_0_5_1      ,
            PO_TR_TUNNEL_1_2_1_0_5_2      ,
            PO_TR_TUNNEL_1_2_1_0_5_2_D    ,
            PO_TR_TUNNEL_1_2_1_0_5_5_AP   ,
            PO_TR_TUNNEL_1_2_1_0_5_5      ,
            PO_TR_TUNNEL_1_2_1_0_5_6_AP   ,
            PO_TR_TUNNEL_1_2_1_0_5_6      ,
            PO_TR_TUNNEL_1_2_1_0_5_7_AP   ,
            PO_TR_TUNNEL_1_2_1_0_5_7      ,
            PO_TR_TUNNEL_1_2_1_0_5_8_AP   ,
            PO_TR_TUNNEL_1_2_1_0_5_8      ,
            GALLERIA_PRINCIPALE           ,
            CONFIGURAZIONE_GALLERIA       ,
            GRUPPO_AUTORIZZATIVO          ,
            PO_TR_TUNNEL_1_2_1_0_5_9_AP   ,
            PO_TR_TUNNEL_1_2_1_0_5_9      )
        Select 
			PO_TR_TUNNEL_1_2_1_0_5_1      ,
            PO_TR_TUNNEL_1_2_1_0_5_2      ,
            PO_TR_TUNNEL_1_2_1_0_5_2_D    ,
            PO_TR_TUNNEL_1_2_1_0_5_5_AP   ,
            PO_TR_TUNNEL_1_2_1_0_5_5      ,
            PO_TR_TUNNEL_1_2_1_0_5_6_AP   ,
            PO_TR_TUNNEL_1_2_1_0_5_6      ,
            PO_TR_TUNNEL_1_2_1_0_5_7_AP   ,
            PO_TR_TUNNEL_1_2_1_0_5_7      ,
            PO_TR_TUNNEL_1_2_1_0_5_8_AP   ,
            PO_TR_TUNNEL_1_2_1_0_5_8      ,
            GALLERIA_PRINCIPALE           ,
            CONFIGURAZIONE_GALLERIA       ,
            GRUPPO_AUTORIZZATIVO          ,
            PO_TR_TUNNEL_1_2_1_0_5_9_AP   ,
            PO_TR_TUNNEL_1_2_1_0_5_9 
		from Rinf_Controllati_Evo.GALLERIE_BINARI_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.REL_GALLERIE_BINARI_PO (
	        PO_TR_TUNNEL_1_2_1_0_5_2,
            PO_TRACK_1_2_1_0_0_2     )
        Select 
	        PO_TR_TUNNEL_1_2_1_0_5_2,
            PO_TRACK_1_2_1_0_0_2     
		from Rinf_Controllati_Evo.REL_GALLERIE_BINARI_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.DICHIARAZIONI_GALLERIE_BIN_PO (
	        PO_TR_TUNNEL_1_2_1_0_5_2       ,
            TIPO_DICHIARAZIONE             ,
            PO_TR_TUNNEL_1_2_1_0_5_3O4_AP  ,
            PO_TR_TUNNEL_1_2_1_0_5_3O4     ,
            KM_INIZIO                      ,
            KM_FINE                        ,
            LATITUDINE_INIZIO              ,
            LONGITUDINE_INIZIO             ,
            ALTITUDINE_INIZIO              ,
            LATITUDINE_FINE                ,
            LONGITUDINE_FINE               ,
            ALTITUDINE_FINE                ,
            FLAG_CALCOLATO                 )
        Select 
            PO_TR_TUNNEL_1_2_1_0_5_2       ,
            TIPO_DICHIARAZIONE             ,
            PO_TR_TUNNEL_1_2_1_0_5_3O4_AP  ,
            PO_TR_TUNNEL_1_2_1_0_5_3O4     ,
            KM_INIZIO                      ,
            KM_FINE                        ,
            LATITUDINE_INIZIO              ,
            LONGITUDINE_INIZIO             ,
            ALTITUDINE_INIZIO              ,
            LATITUDINE_FINE                ,
            LONGITUDINE_FINE               ,
            ALTITUDINE_FINE                ,
            FLAG_CALCOLATO    
		from Rinf_Controllati_Evo.DICHIARAZIONI_GALLERIE_BIN_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.MARCIAPIEDI_BINARI_PO (
	            PO_TR_PLATFORM_1_2_1_0_6_1      ,
                PO_TR_PLATFORM_1_2_1_0_6_2      ,
                PO_TR_PLATFORM_1_2_1_0_6_2_D    ,
                PO_TR_PLATFORM_1_2_1_0_6_3_AP   ,
                PO_TR_PLAT_1_2_1_0_6_4_B1_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_4_B1   ,
                PO_TR_PLAT_1_2_1_0_6_4_B2_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_4_B2   ,
                PO_TR_PLAT_1_2_1_0_6_4_B3_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_4_B3   ,
                PO_TR_PLAT_1_2_1_0_6_5_B1_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_5_B1   ,
                PO_TR_PLAT_1_2_1_0_6_5_B2_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_5_B2   ,
                PO_TR_PLAT_1_2_1_0_6_5_B3_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_5_B3   ,
                PO_TR_PLATFORM_1_2_1_0_6_6_AP   ,
                PO_TR_PLATFORM_1_2_1_0_6_6      ,
                PO_TR_PLATFORM_1_2_1_0_6_7_AP   ,
                PO_TR_PLATFORM_1_2_1_0_6_7      ,
                BINARIO_1                       ,
                BINARIO_2                       ,
                BINARIO_3                       ,
                BINARIO_4                       ,
                PO_TR_PLAT_1_2_1_0_6_4_B4_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_4_B4   ,
                PO_TR_PLAT_1_2_1_0_6_5_B4_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_5_B4   ,
                GRUPPO_AUTORIZZATIVO           )
        Select 
	            PO_TR_PLATFORM_1_2_1_0_6_1      ,
                PO_TR_PLATFORM_1_2_1_0_6_2      ,
                PO_TR_PLATFORM_1_2_1_0_6_2_D    ,
                PO_TR_PLATFORM_1_2_1_0_6_3_AP   ,
                PO_TR_PLAT_1_2_1_0_6_4_B1_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_4_B1   ,
                PO_TR_PLAT_1_2_1_0_6_4_B2_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_4_B2   ,
                PO_TR_PLAT_1_2_1_0_6_4_B3_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_4_B3   ,
                PO_TR_PLAT_1_2_1_0_6_5_B1_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_5_B1   ,
                PO_TR_PLAT_1_2_1_0_6_5_B2_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_5_B2   ,
                PO_TR_PLAT_1_2_1_0_6_5_B3_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_5_B3   ,
                PO_TR_PLATFORM_1_2_1_0_6_6_AP   ,
                PO_TR_PLATFORM_1_2_1_0_6_6      ,
                PO_TR_PLATFORM_1_2_1_0_6_7_AP   ,
                PO_TR_PLATFORM_1_2_1_0_6_7      ,
                BINARIO_1                       ,
                BINARIO_2                       ,
                BINARIO_3                       ,
                BINARIO_4                       ,
                PO_TR_PLAT_1_2_1_0_6_4_B4_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_4_B4   ,
                PO_TR_PLAT_1_2_1_0_6_5_B4_AP    ,
                PO_TR_PLATFORM_1_2_1_0_6_5_B4   ,
                GRUPPO_AUTORIZZATIVO   		
		from Rinf_Controllati_Evo.MARCIAPIEDI_BINARI_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.BINARI_RACCORDO_PO (
                PO_SD_1_2_2_0_0_1     ,
                PO_SD_1_2_2_0_0_2     ,
                PO_SD_1_2_2_0_0_2_D   ,
                PO_SD_1_2_2_0_0_3_AP  ,
                PO_SD_1_2_2_0_2_1_AP  ,
                PO_SD_1_2_2_0_2_1     ,
                PO_SD_1_2_2_0_3_1_AP  ,
                PO_SD_1_2_2_0_3_1     ,
                PO_SD_1_2_2_0_3_2_AP  ,
                PO_SD_1_2_2_0_3_2     ,
                PO_SD_1_2_2_0_3_3_AP  ,
                PO_SD_1_2_2_0_3_3_A   ,
                PO_SD_1_2_2_0_3_3_B   ,
                PO_SD_1_2_2_0_4_1_AP  ,
                PO_SD_1_2_2_0_4_1     ,
                PO_SD_1_2_2_0_4_2_AP  ,
                PO_SD_1_2_2_0_4_2     ,
                PO_SD_1_2_2_0_4_3_AP  ,
                PO_SD_1_2_2_0_4_3     ,
                PO_SD_1_2_2_0_4_4_AP  ,
                PO_SD_1_2_2_0_4_4     ,
                PO_SD_1_2_2_0_4_5_AP  ,
                PO_SD_1_2_2_0_4_5     ,
                PO_SD_1_2_2_0_4_6_AP  ,
                PO_SD_1_2_2_0_4_6     ,
                SEDE_TECNICA          ,
                GRUPPO_AUTORIZZATIVO  ,
                PO_SD_1_2_2_0_6_1_AP  ,
                PO_SD_1_2_2_0_6_1 )	  
        Select 
                PO_SD_1_2_2_0_0_1     ,
                PO_SD_1_2_2_0_0_2     ,
                PO_SD_1_2_2_0_0_2_D   ,
                PO_SD_1_2_2_0_0_3_AP  ,
                PO_SD_1_2_2_0_2_1_AP  ,
                PO_SD_1_2_2_0_2_1     ,
                PO_SD_1_2_2_0_3_1_AP  ,
                PO_SD_1_2_2_0_3_1     ,
                PO_SD_1_2_2_0_3_2_AP  ,
                PO_SD_1_2_2_0_3_2     ,
                PO_SD_1_2_2_0_3_3_AP  ,
                PO_SD_1_2_2_0_3_3_A   ,
                PO_SD_1_2_2_0_3_3_B   ,
                PO_SD_1_2_2_0_4_1_AP  ,
                PO_SD_1_2_2_0_4_1     ,
                PO_SD_1_2_2_0_4_2_AP  ,
                PO_SD_1_2_2_0_4_2     ,
                PO_SD_1_2_2_0_4_3_AP  ,
                PO_SD_1_2_2_0_4_3     ,
                PO_SD_1_2_2_0_4_4_AP  ,
                PO_SD_1_2_2_0_4_4     ,
                PO_SD_1_2_2_0_4_5_AP  ,
                PO_SD_1_2_2_0_4_5     ,
                PO_SD_1_2_2_0_4_6_AP  ,
                PO_SD_1_2_2_0_4_6     ,
                SEDE_TECNICA          ,
                GRUPPO_AUTORIZZATIVO  ,
                PO_SD_1_2_2_0_6_1_AP  ,
                PO_SD_1_2_2_0_6_1
		from Rinf_Controllati_Evo.BINARI_RACCORDO_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.DICHIARAZIONI_RACCORDO_PO (
                PO_SD_1_2_2_0_0_2         ,
                TIPO_DICHIARAZIONE        ,
                PO_SD_1_2_2_0_1_1O2_AP    ,
                PO_SD_1_2_2_0_1_1O2       ,
                KM_INIZIO                 ,
                KM_FINE                   ,
                LATITUDINE_INIZIO         ,
                LONGITUDINE_INIZIO        ,
                ALTITUDINE_INIZIO         ,
                LATITUDINE_FINE           ,
                LONGITUDINE_FINE          ,
                ALTITUDINE_FINE           ,
                FLAG_CALCOLATO	  )
        Select 
                PO_SD_1_2_2_0_0_2         ,
                TIPO_DICHIARAZIONE        ,
                PO_SD_1_2_2_0_1_1O2_AP    ,
                PO_SD_1_2_2_0_1_1O2       ,
                KM_INIZIO                 ,
                KM_FINE                   ,
                LATITUDINE_INIZIO         ,
                LONGITUDINE_INIZIO        ,
                ALTITUDINE_INIZIO         ,
                LATITUDINE_FINE           ,
                LONGITUDINE_FINE          ,
                ALTITUDINE_FINE           ,
                FLAG_CALCOLATO
		from Rinf_Controllati_Evo.DICHIARAZIONI_RACCORDO_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.GALLERIE_RACCORDO_PO (
                PO_SD_TUNNEL_1_2_2_0_5_1        ,
                PO_SD_TUNNEL_1_2_2_0_5_2        ,
                PO_SD_TUNNEL_1_2_2_0_5_2_D      ,
                PO_SD_TUNNEL_1_2_2_0_5_5_AP     ,
                PO_SD_TUNNEL_1_2_2_0_5_5        ,
                PO_SD_TUNNEL_1_2_2_0_5_6_AP     ,
                PO_SD_TUNNEL_1_2_2_0_5_6        ,
                PO_SD_TUNNEL_1_2_2_0_5_7_AP     ,
                PO_SD_TUNNEL_1_2_2_0_5_7        ,
                PO_SD_TUNNEL_1_2_2_0_5_8_AP     ,
                PO_SD_TUNNEL_1_2_2_0_5_8	  )
        Select 
                PO_SD_TUNNEL_1_2_2_0_5_1        ,
                PO_SD_TUNNEL_1_2_2_0_5_2        ,
                PO_SD_TUNNEL_1_2_2_0_5_2_D      ,
                PO_SD_TUNNEL_1_2_2_0_5_5_AP     ,
                PO_SD_TUNNEL_1_2_2_0_5_5        ,
                PO_SD_TUNNEL_1_2_2_0_5_6_AP     ,
                PO_SD_TUNNEL_1_2_2_0_5_6        ,
                PO_SD_TUNNEL_1_2_2_0_5_7_AP     ,
                PO_SD_TUNNEL_1_2_2_0_5_7        ,
                PO_SD_TUNNEL_1_2_2_0_5_8_AP     ,
                PO_SD_TUNNEL_1_2_2_0_5_8
      	from Rinf_Controllati_Evo.GALLERIE_RACCORDO_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.DICHIARAZIONI_GALLERIE_SD_PO (
                PO_SD_TUNNEL_1_2_2_0_5_2           ,
                TIPO_DICHIARAZIONE                 ,
                PO_SD_TUNNEL_1_2_2_0_5_3O4_AP      ,
                PO_SD_TUNNEL_1_2_2_0_5_3O4         ,
                KM_INIZIO                          ,
                KM_FINE                            ,
                LATITUDINE_INIZIO                  ,
                LONGITUDINE_INIZIO                 ,
                ALTITUDINE_INIZIO                  ,
                LATITUDINE_FINE                    ,
                LONGITUDINE_FINE                   ,
                ALTITUDINE_FINE                    ,
                FLAG_CALCOLATO               )
        Select 
                PO_SD_TUNNEL_1_2_2_0_5_2           ,
                TIPO_DICHIARAZIONE                 ,
                PO_SD_TUNNEL_1_2_2_0_5_3O4_AP      ,
                PO_SD_TUNNEL_1_2_2_0_5_3O4         ,
                KM_INIZIO                          ,
                KM_FINE                            ,
                LATITUDINE_INIZIO                  ,
                LONGITUDINE_INIZIO                 ,
                ALTITUDINE_INIZIO                  ,
                LATITUDINE_FINE                    ,
                LONGITUDINE_FINE                   ,
                ALTITUDINE_FINE                    ,
                FLAG_CALCOLATO    
		from Rinf_Controllati_Evo.DICHIARAZIONI_GALLERIE_SD_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.REL_GALLERIE_RACCORDO_PO (
	           PO_SD_TUNNEL_1_2_2_0_5_2,
               PO_SD_1_2_2_0_0_2      )
        Select 
	           PO_SD_TUNNEL_1_2_2_0_5_2,
               PO_SD_1_2_2_0_0_2 
		from Rinf_Controllati_Evo.REL_GALLERIE_RACCORDO_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.CORRIDOIO_PO (
               CODICE_CORRIDOIO,
               SEDE_TECNICA   )
         Select 
               CODICE_CORRIDOIO,
               SEDE_TECNICA 
		 from Rinf_Controllati_Evo.CORRIDOIO_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.LINEE_TENT_PO (
               CODICE_LINEA_TENT,
               SEDE_TECNICA  )
        Select 
               CODICE_LINEA_TENT,
               SEDE_TECNICA 
		from Rinf_Controllati_Evo.LINEE_TENT_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.LINEA_COMM_PO (
               CODICE_GIURISDIZIONE,
               SEDE_TECNICA        ,
               KM_INIZIO            )
        Select 
               CODICE_GIURISDIZIONE,
               SEDE_TECNICA        ,
               KM_INIZIO  
		from Rinf_Controllati_Evo.LINEA_COMM_PO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.LINEA_TRIPLETTA (
               CODICE_LINEA,
               SEDE_TECNICA,
               LINEA_ORIGINE  )
        Select 
               CODICE_LINEA,
               SEDE_TECNICA,
               LINEA_ORIGINE
		from Rinf_Controllati_Evo.LINEA_TRIPLETTA;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_2_1_0_2_1_CAT_TEN_PO (
               PO_TRACK_1_2_1_0_0_2      ,
               PO_TRACK_1_2_1_0_2_1      ,
               KM_INIZIO                 ,
               KM_FINE                   ,
               LATITUDINE_INIZIO         ,
               LONGITUDINE_INIZIO        ,
               ALTITUDINE_INIZIO         ,
               LATITUDINE_FINE           ,
               LONGITUDINE_FINE          ,
               ALTITUDINE_FINE           ,
               FLAG_CALCOLATO            )
        Select 
               PO_TRACK_1_2_1_0_0_2      ,
               PO_TRACK_1_2_1_0_2_1      ,
               KM_INIZIO                 ,
               KM_FINE                   ,
               LATITUDINE_INIZIO         ,
               LONGITUDINE_INIZIO        ,
               ALTITUDINE_INIZIO         ,
               LATITUDINE_FINE           ,
               LONGITUDINE_FINE          ,
               ALTITUDINE_FINE           ,
               FLAG_CALCOLATO  
		from Rinf_Controllati_Evo.PAR_1_2_1_0_2_1_CAT_TEN_PO;
--
       Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_2_1_0_2_2_CAT_LINEA (
               PO_TRACK_1_2_1_0_0_2   ,
               PO_TRACK_1_2_1_0_2_2   ,
               KM_INIZIO              ,
               KM_FINE                ,
               LATITUDINE_INIZIO      ,
               LONGITUDINE_INIZIO     ,
               ALTITUDINE_INIZIO      ,
               LATITUDINE_FINE        ,
               LONGITUDINE_FINE       ,
               ALTITUDINE_FINE        ,
               FLAG_CALCOLATO	      )
         Select 
               PO_TRACK_1_2_1_0_0_2   ,
               PO_TRACK_1_2_1_0_2_2   ,
               KM_INIZIO              ,
               KM_FINE                ,
               LATITUDINE_INIZIO      ,
               LONGITUDINE_INIZIO     ,
               ALTITUDINE_INIZIO      ,
               LATITUDINE_FINE        ,
               LONGITUDINE_FINE       ,
               ALTITUDINE_FINE        ,
               FLAG_CALCOLATO
		 from Rinf_Controllati_Evo.PAR_1_2_1_0_2_2_CAT_LINEA;
--
       Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_2_1_0_6_3_CAT_TEN_PL  (
               PO_TR_PLATFORM_1_2_1_0_6_2  ,
               PO_TR_PLATFORM_1_2_1_0_6_3  ,
               KM_INIZIO                   ,
               KM_FINE                     ,
               LATITUDINE_INIZIO           ,
               LONGITUDINE_INIZIO          ,
               ALTITUDINE_INIZIO           ,
               LATITUDINE_FINE             ,
               LONGITUDINE_FINE            ,
               ALTITUDINE_FINE             ,
               FLAG_CALCOLATO            )
         Select 
               PO_TR_PLATFORM_1_2_1_0_6_2  ,
               PO_TR_PLATFORM_1_2_1_0_6_3  ,
               KM_INIZIO                   ,
               KM_FINE                     ,
               LATITUDINE_INIZIO           ,
               LONGITUDINE_INIZIO          ,
               ALTITUDINE_INIZIO           ,
               LATITUDINE_FINE             ,
               LONGITUDINE_FINE            ,
               ALTITUDINE_FINE             ,
               FLAG_CALCOLATO 		 
		 from Rinf_Controllati_Evo.PAR_1_2_1_0_6_3_CAT_TEN_PL;
--
       Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_2_2_0_0_3_CAT_TEN_SD  (
               PO_SD_1_2_2_0_0_2  ,
               PO_SD_1_2_2_0_0_3  ,
               KM_INIZIO          ,
               KM_FINE            ,
               LATITUDINE_INIZIO  ,
               LONGITUDINE_INIZIO ,
               ALTITUDINE_INIZIO  ,
               LATITUDINE_FINE    ,
               LONGITUDINE_FINE   ,
               ALTITUDINE_FINE    ,
               FLAG_CALCOLATO     )
         Select 
               PO_SD_1_2_2_0_0_2  ,
               PO_SD_1_2_2_0_0_3  ,
               KM_INIZIO          ,
               KM_FINE            ,
               LATITUDINE_INIZIO  ,
               LONGITUDINE_INIZIO ,
               ALTITUDINE_INIZIO  ,
               LATITUDINE_FINE    ,
               LONGITUDINE_FINE   ,
               ALTITUDINE_FINE    ,
               FLAG_CALCOLATO 
		 from Rinf_Controllati_Evo.PAR_1_2_2_0_0_3_CAT_TEN_SD;
--
       Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_2_3_2_DOC_NORME (
               SEDE_TECNICA ,
               PO_1_2_3_2   )
         Select 
               SEDE_TECNICA ,
               PO_1_2_3_2 
		 from Rinf_Controllati_Evo.PAR_1_2_3_2_DOC_NORME;
--
   EXCEPTION
      When OTHERS Then
         p_error := SQLCODE;
         DBMS_OutPUT.PUT_LINE ('SetOPAuthorizationSchema - Errore: ' || Substr (SQLERRM, 1, 300));
   End SetOPAuthorizationSchema;
--
-- ----------------------------------------------------------------------------
--                   Procedure SetSOLAuthorizationSchema (SEZIONI_LINEA,..)
-- ----------------------------------------------------------------------------
 Procedure SetSOLAuthorizationSchema (
      p_Codice_Autorizzazione       Varchar2,
      p_error                   Out Number)  Is
   BEGIN
      p_error := 0;

      Insert Into  Rinf_Autorizzazioni_Evo.SEZIONI_LINEA 
	         (     SEDE_TECNICA,
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
                   CODICE_CONTROLLO,
                   CODICE_RICHIESTA,
                   GRUPPO_AUTORIZZATIVO   )
         Select    SEDE_TECNICA,
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
                   CODICE_CONTROLLO,
                   p_Codice_Autorizzazione,
                   GRUPPO_AUTORIZZATIVO
              From Rinf_Controllati_Evo.SEZIONI_LINEA;
--
      Insert Into  Rinf_Autorizzazioni_Evo.BINARI_CORSA_SOL (
                   SOL_TRACK_1_1_1_0_0_1               ,
                   SOL_TRACK_1_1_1_0_0_1_D             ,
                   SOL_TRACK_1_1_1_0_0_2               ,
                   SOL_TRACK_1_1_1_1_2_1_AP            ,
                   SOL_TRACK_1_1_1_1_2_2_AP            ,
                   SOL_TRACK_1_1_1_1_2_3_AP            ,
                   SOL_TRACK_1_1_1_1_2_4_AP            ,
                   SOL_TRACK_1_1_1_1_2_5_AP            ,
                   SOL_TRACK_1_1_1_1_2_5               ,
                   SOL_TRACK_1_1_1_1_2_6_AP            ,
                   SOL_TRACK_1_1_1_1_2_6               ,
                   SOL_TRACK_1_1_1_1_2_7_AP            ,
                   SOL_TRACK_1_1_1_1_2_7               ,
                   SOL_TRACK_1_1_1_1_2_8_AP            ,
                   SOL_TRACK_1_1_1_1_2_8               ,
                   SOL_TRACK_1_1_1_1_3_1_AP            ,
                   SOL_TRACK_1_1_1_1_3_1               ,
                   SOL_TRACK_1_1_1_1_3_2_AP            ,
                   SOL_TRACK_1_1_1_1_3_2               ,
                   SOL_TRACK_1_1_1_1_3_3_AP            ,
                   SOL_TRACK_1_1_1_1_3_3               ,
                   SOL_TRACK_1_1_1_1_3_4_AP            ,
                   SOL_TRACK_1_1_1_1_3_5_AP            ,
                   SOL_TRACK_1_1_1_1_3_6_AP            ,
                   SOL_TRACK_1_1_1_1_3_7_AP            ,
                   SOL_TRACK_1_1_1_1_3_7               ,
                   SOL_TRACK_1_1_1_1_4_1_AP            ,
                   SOL_TRACK_1_1_1_1_4_1               ,
                   SOL_TRACK_1_1_1_1_4_2_AP            ,
                   SOL_TRACK_1_1_1_1_4_2               ,
                   SOL_TRACK_1_1_1_1_4_3_AP            ,
                   SOL_TRACK_1_1_1_1_4_3               ,
                   SOL_TRACK_1_1_1_1_4_4_AP            ,
                   SOL_TRACK_1_1_1_1_4_4               ,
                   SOL_TRACK_1_1_1_1_5_1_AP            ,
                   SOL_TRACK_1_1_1_1_5_1               ,
                   SOL_TRACK_1_1_1_1_5_2_AP            ,
                   SOL_TRACK_1_1_1_1_5_2               ,
                   SOL_TRACK_1_1_1_1_6_1_AP            ,
                   SOL_TRACK_1_1_1_1_6_1               ,
                   SOL_TRACK_1_1_1_1_6_2_AP            ,
                   SOL_TRACK_1_1_1_1_6_2               ,
                   SOL_TRACK_1_1_1_1_6_3_AP            ,
                   SOL_TRACK_1_1_1_1_6_3               ,
                   SOL_TRACK_1_1_1_1_7_1_AP            ,
                   SOL_TRACK_1_1_1_1_7_1               ,
                   SOL_TRACK_1_1_1_1_7_2_AP            ,
                   SOL_TRACK_1_1_1_1_7_2               ,
                   SOL_TRACK_1_1_1_1_7_3_AP            ,
                   SOL_TRACK_1_1_1_1_7_3               ,
                   SOL_TRACK_1_1_1_2_2_1_1_AP          ,
                   SOL_TRACK_1_1_1_2_2_1_1             ,
                   SOL_TRACK_1_1_1_2_2_1_2_AP          ,
                   SOL_TRACK_1_1_1_2_2_1_2             ,
                   SOL_TRACK_1_1_1_2_2_2_AP            ,
                   SOL_TRACK_1_1_1_2_2_2               ,
                   SOL_TRACK_1_1_1_2_2_3_AP            ,
                   SOL_TRACK_1_1_1_2_2_3               ,
                   SOL_TRACK_1_1_1_2_2_4_AP            ,
                   SOL_TRACK_1_1_1_2_2_4               ,
                   SOL_TRACK_1_1_1_2_2_5_AP            ,
                   SOL_TRACK_1_1_1_2_2_5               ,
                   SOL_TRACK_1_1_1_2_2_6_AP            ,
                   SOL_TRACK_1_1_1_2_2_6               ,
                   SOL_TRACK_1_1_1_2_3_1_AP            ,
                   SOL_TRACK_1_1_1_2_3_1               ,
                   SOL_TRACK_1_1_1_2_3_2_AP            ,
                   SOL_TRACK_1_1_1_2_3_2               ,
                   SOL_TRACK_1_1_1_2_3_3_AP            ,
                   SOL_TRACK_1_1_1_2_3_3_A             ,
                   SOL_TRACK_1_1_1_2_3_3_B             ,
                   SOL_TRACK_1_1_1_2_3_3_C             ,
                   SOL_TRACK_1_1_1_2_3_4_AP            ,
                   SOL_TRACK_1_1_1_2_3_4               ,
                   SOL_TRACK_1_1_1_2_4_1_1_AP          ,
                   SOL_TRACK_1_1_1_2_4_1_1             ,
                   SOL_TRACK_1_1_1_2_4_1_2_AP          ,
                   SOL_TRACK_1_1_1_2_4_1_2_A           ,
                   SOL_TRACK_1_1_1_2_4_1_2_B           ,
                   SOL_TRACK_1_1_1_2_4_1_2_C           ,
                   SOL_TRACK_1_1_1_2_4_2_1_AP          ,
                   SOL_TRACK_1_1_1_2_4_2_1             ,
                   SOL_TRACK_1_1_1_2_4_2_2_AP          ,
                   SOL_TRACK_1_1_1_2_4_2_2_A           ,
                   SOL_TRACK_1_1_1_2_4_2_2_B           ,
                   SOL_TRACK_1_1_1_2_4_2_2_C           ,
                   SOL_TRACK_1_1_1_2_4_2_2_D           ,
                   SOL_TRACK_1_1_1_2_5_1_AP            ,
                   SOL_TRACK_1_1_1_2_5_1               ,
                   SOL_TRACK_1_1_1_2_5_2_AP            ,
                   SOL_TRACK_1_1_1_2_5_2               ,
                   SOL_TRACK_1_1_1_2_5_3_AP            ,
                   SOL_TRACK_1_1_1_2_5_3               ,
                   SOL_TRACK_1_1_1_3_2_1_AP            ,
                   SOL_TRACK_1_1_1_3_2_1               ,
                   SOL_TRACK_1_1_1_3_2_2_AP            ,
                   SOL_TRACK_1_1_1_3_2_2               ,
                   SOL_TRACK_1_1_1_3_2_3_AP            ,
                   SOL_TRACK_1_1_1_3_2_3               ,
                   SOL_TRACK_1_1_1_3_2_4_AP            ,
                   SOL_TRACK_1_1_1_3_2_4               ,
                   SOL_TRACK_1_1_1_3_2_5_AP            ,
                   SOL_TRACK_1_1_1_3_2_5               ,
                   SOL_TRACK_1_1_1_3_2_6_AP            ,
                   SOL_TRACK_1_1_1_3_2_6               ,
                   SOL_TRACK_1_1_1_3_2_7_AP            ,
                   SOL_TRACK_1_1_1_3_2_7               ,
                   SOL_TRACK_1_1_1_3_3_1_AP            ,
                   SOL_TRACK_1_1_1_3_3_1               ,
                   SOL_TRACK_1_1_1_3_3_2_AP            ,
                   SOL_TRACK_1_1_1_3_3_2               ,
                   SOL_TRACK_1_1_1_3_3_3_AP            ,
                   SOL_TRACK_1_1_1_3_4_1_AP            ,
                   SOL_TRACK_1_1_1_3_4_1               ,
                   SOL_TRACK_1_1_1_3_5_1_AP            ,
                   SOL_TRACK_1_1_1_3_5_1               ,
                   SOL_TRACK_1_1_1_3_5_2_AP            ,
                   SOL_TRACK_1_1_1_3_5_2               ,
                   SOL_TRACK_1_1_1_3_6_1_AP            ,
                   SOL_TRACK_1_1_1_3_6_1               ,
                   SOL_TRACK_1_1_1_3_7_1_AP            ,
                   SOL_TRACK_1_1_1_3_7_1               ,
                   SOL_TRACK_1_1_1_3_7_2_1_AP          ,
                   SOL_TRACK_1_1_1_3_7_2_1             ,
                   SOL_TRACK_1_1_1_3_7_2_2_AP          ,
                   SOL_TRACK_1_1_1_3_7_2_2             ,
                   SOL_TRACK_1_1_1_3_7_3_AP            ,
                   SOL_TRACK_1_1_1_3_7_3               ,
                   SOL_TRACK_1_1_1_3_7_4_AP            ,
                   SOL_TRACK_1_1_1_3_7_4               ,
                   SOL_TRACK_1_1_1_3_7_5_AP            ,
                   SOL_TRACK_1_1_1_3_7_5               ,
                   SOL_TRACK_1_1_1_3_7_6_AP            ,
                   SOL_TRACK_1_1_1_3_7_6               ,
                   SOL_TRACK_1_1_1_3_7_7_AP            ,
                   SOL_TRACK_1_1_1_3_7_7               ,
                   SOL_TRACK_1_1_1_3_7_8_AP            ,
                   SOL_TRACK_1_1_1_3_7_8               ,
                   SOL_TRACK_1_1_1_3_7_9_AP            ,
                   SOL_TRACK_1_1_1_3_7_9               ,
                   SOL_TRACK_1_1_1_3_7_10_AP           ,
                   SOL_TRACK_1_1_1_3_7_10              ,
                   SOL_TRACK_1_1_1_3_7_11_AP           ,
                   SOL_TRACK_1_1_1_3_7_11              ,
                   SOL_TRACK_1_1_1_3_7_12_AP           ,
                   SOL_TRACK_1_1_1_3_7_12              ,
                   SOL_TRACK_1_1_1_3_7_13_AP           ,
                   SOL_TRACK_1_1_1_3_7_13              ,
                   SOL_TRACK_1_1_1_3_7_14_AP           ,
                   SOL_TRACK_1_1_1_3_7_14              ,
                   SOL_TRACK_1_1_1_3_7_15_1_AP         ,
                   SOL_TRACK_1_1_1_3_7_15_1            ,
                   SOL_TRACK_1_1_1_3_7_15_2_AP         ,
                   SOL_TRACK_1_1_1_3_7_15_2            ,
                   SOL_TRACK_1_1_1_3_7_16_AP           ,
                   SOL_TRACK_1_1_1_3_7_16              ,
                   SOL_TRACK_1_1_1_3_7_17_AP           ,
                   SOL_TRACK_1_1_1_3_7_17              ,
                   SOL_TRACK_1_1_1_3_7_18_AP           ,
                   SOL_TRACK_1_1_1_3_7_18              ,
                   SOL_TRACK_1_1_1_3_7_19_AP           ,
                   SOL_TRACK_1_1_1_3_7_19              ,
                   SOL_TRACK_1_1_1_3_7_20_AP           ,
                   SOL_TRACK_1_1_1_3_7_20              ,
                   SOL_TRACK_1_1_1_3_7_21_AP           ,
                   SOL_TRACK_1_1_1_3_7_21              ,
                   SOL_TRACK_1_1_1_3_7_22_AP           ,
                   SOL_TRACK_1_1_1_3_7_22              ,
                   SOL_TRACK_1_1_1_3_7_23_AP           ,
                   SOL_TRACK_1_1_1_3_7_23              ,
                   SOL_TRACK_1_1_1_3_8_1_AP            ,
                   SOL_TRACK_1_1_1_3_8_1               ,
                   SOL_TRACK_1_1_1_3_8_2_AP            ,
                   SOL_TRACK_1_1_1_3_8_2               ,
                   SOL_TRACK_1_1_1_3_9_1_AP            ,
                   SOL_TRACK_1_1_1_3_9_1               ,
                   SOL_TRACK_1_1_1_3_9_2_AP            ,
                   SOL_TRACK_1_1_1_3_9_2               ,
                   SOL_TRACK_1_1_1_3_10_1_AP           ,
                   SOL_TRACK_1_1_1_3_10_1              ,
                   SOL_TRACK_1_1_1_3_10_2_AP           ,
                   SOL_TRACK_1_1_1_3_10_2              ,
                   SOL_TRACK_1_1_1_3_11_1_AP           ,
                   SOL_TRACK_1_1_1_3_11_1              ,
                   SOL_TRACK_1_1_1_3_12_1_AP           ,
                   SOL_TRACK_1_1_1_3_12_1              ,
                   TIPO_BINARIO                        ,
                   SEDE_TECNICA                        ,
                   GRUPPO_AUTORIZZATIVO                ,
                   SOL_TRACK_1_1_1_1_2_4_1_AP          ,
                   SOL_TRACK_1_1_1_1_2_4_1             ,
                   SOL_TRACK_1_1_1_1_2_4_2_AP          ,
                   SOL_TRACK_1_1_1_1_2_4_2             ,
                   SOL_TRACK_1_1_1_1_2_4_3_AP          ,
                   SOL_TRACK_1_1_1_1_2_4_4_AP          ,
                   SOL_TRACK_1_1_1_1_2_4_4             ,
                   SOL_TRACK_1_1_1_1_3_1_1_AP          ,
                   SOL_TRACK_1_1_1_1_3_1_1_INF         ,
                   SOL_TRACK_1_1_1_1_3_1_1_SUP         ,
                   SOL_TRACK_1_1_1_1_3_1_2_AP          ,
                   SOL_TRACK_1_1_1_1_3_1_2             ,
                   SOL_TRACK_1_1_1_1_3_1_3_AP          ,
                   SOL_TRACK_1_1_1_1_3_1_3             ,
                   SOL_TRACK_1_1_1_1_6_4_AP            ,
                   SOL_TRACK_1_1_1_1_6_4               ,
                   SOL_TRACK_1_1_1_1_6_5_AP            ,
                   SOL_TRACK_1_1_1_1_6_5               ,
                   SOL_TRACK_1_1_1_1_7_4_AP            ,
                   SOL_TRACK_1_1_1_1_7_4               ,
                   SOL_TRACK_1_1_1_1_7_5_AP            ,
                   SOL_TRACK_1_1_1_1_7_5               ,
                   SOL_TRACK_1_1_1_1_7_6_AP            ,
                   SOL_TRACK_1_1_1_1_7_6               ,
                   SOL_TRACK_1_1_1_1_7_7_AP            ,
                   SOL_TRACK_1_1_1_1_7_7               ,
                   SOL_TRACK_1_1_1_1_7_8_AP            ,
                   SOL_TRACK_1_1_1_1_7_9_AP            ,
                   SOL_TRACK_1_1_1_1_7_9               ,
                   SOL_TRACK_1_1_1_2_2_1_2_1_AP        ,
                   SOL_TRACK_1_1_1_2_2_1_2_1           ,
                   SOL_TRACK_1_1_1_2_2_1_3_AP          ,
                   SOL_TRACK_1_1_1_2_2_1_3             ,
                   SOL_TRACK_1_1_1_2_4_3_AP            ,
                   SOL_TRACK_1_1_1_2_4_3               ,
                   SOL_TRACK_1_1_1_3_2_8_AP            ,
                   SOL_TRACK_1_1_1_3_2_8               ,
                   SOL_TRACK_1_1_1_3_2_9_AP            ,
                   SOL_TRACK_1_1_1_3_3_3_2_AP          ,
                   SOL_TRACK_1_1_1_3_3_3_2             ,
                   SOL_TRACK_1_1_1_3_3_3_3_AP          ,
                   SOL_TRACK_1_1_1_3_3_3_3             ,
                   SOL_TRACK_1_1_1_3_3_3_1_AP          ,
                   SOL_TRACK_1_1_1_3_3_3_1             ,
                   SOL_TRACK_1_1_1_3_3_4_AP            ,
                   SOL_TRACK_1_1_1_3_3_4               ,
                   SOL_TRACK_1_1_1_3_3_5_AP            ,
                   SOL_TRACK_1_1_1_3_3_6_AP            ,
                   SOL_TRACK_1_1_1_3_3_6               ,
                   SOL_TRACK_1_1_1_3_3_7_AP            ,
                   SOL_TRACK_1_1_1_3_3_7               ,
                   SOL_TRACK_1_1_1_3_3_8_AP            ,
                   SOL_TRACK_1_1_1_3_3_8               ,
                   SOL_TRACK_1_1_1_3_3_9_AP            ,
                   SOL_TRACK_1_1_1_3_3_10_AP           ,
                   SOL_TRACK_1_1_1_3_5_3_AP            ,
                   SOL_TRACK_1_1_1_3_7_1_2_AP          ,
                   SOL_TRACK_1_1_1_3_7_1_2             ,
                   SOL_TRACK_1_1_1_3_7_1_3_AP          ,
                   SOL_TRACK_1_1_1_3_7_1_4_AP          ,
                   SOL_TRACK_1_1_1_3_7_1_4             ,
                   SOL_TRACK_1_1_1_3_7_11_1_AP         ,
                   SOL_TRACK_1_1_1_3_11_2_AP           ,
                   SOL_TRACK_1_1_1_3_11_2              ,
                   SOL_TRACK_1_1_1_3_11_3_AP           ,
                   SOL_TRACK_1_1_1_3_11_3              ,
                   SOL_TRACK_1_1_1_4_1_AP              ,
                   SOL_TRACK_1_1_1_4_1                 ,
                   SOL_TRACK_1_1_1_4_2_AP              ,
                   SOL_TRACK_1_1_1_1_3_5_1             ,
                   SOL_TRACK_1_1_1_1_3_5_1_AP          ,
                   SOL_TRACK_1_1_1_1_7_10_AP           ,
                   SOL_TRACK_1_1_1_1_7_10              ,
                   SOL_TRACK_1_1_1_1_7_11_AP           ,
                   SOL_TRACK_1_1_1_1_7_11              ,
                   SOL_TRACK_1_1_1_3_2_10_AP           ,
                   SOL_TRACK_1_1_1_3_2_10              ,
                   SOL_TRACK_1_1_1_3_7_1_1_AP          ,
                   SOL_TRACK_1_1_1_3_7_1_1             ,
                   SOL_TRACK_1_1_1_1_2_1_2_AP          ,
                   SOL_TRACK_1_1_1_1_2_1_2             )
        Select 
                  SOL_TRACK_1_1_1_0_0_1               ,
                   SOL_TRACK_1_1_1_0_0_1_D             ,
                   SOL_TRACK_1_1_1_0_0_2               ,
                   SOL_TRACK_1_1_1_1_2_1_AP            ,
                   SOL_TRACK_1_1_1_1_2_2_AP            ,
                   SOL_TRACK_1_1_1_1_2_3_AP            ,
                   SOL_TRACK_1_1_1_1_2_4_AP            ,
                   SOL_TRACK_1_1_1_1_2_5_AP            ,
                   SOL_TRACK_1_1_1_1_2_5               ,
                   SOL_TRACK_1_1_1_1_2_6_AP            ,
                   SOL_TRACK_1_1_1_1_2_6               ,
                   SOL_TRACK_1_1_1_1_2_7_AP            ,
                   SOL_TRACK_1_1_1_1_2_7               ,
                   SOL_TRACK_1_1_1_1_2_8_AP            ,
                   SOL_TRACK_1_1_1_1_2_8               ,
                   SOL_TRACK_1_1_1_1_3_1_AP            ,
                   SOL_TRACK_1_1_1_1_3_1               ,
                   SOL_TRACK_1_1_1_1_3_2_AP            ,
                   SOL_TRACK_1_1_1_1_3_2               ,
                   SOL_TRACK_1_1_1_1_3_3_AP            ,
                   SOL_TRACK_1_1_1_1_3_3               ,
                   SOL_TRACK_1_1_1_1_3_4_AP            ,
                   SOL_TRACK_1_1_1_1_3_5_AP            ,
                   SOL_TRACK_1_1_1_1_3_6_AP            ,
                   SOL_TRACK_1_1_1_1_3_7_AP            ,
                   SOL_TRACK_1_1_1_1_3_7               ,
                   SOL_TRACK_1_1_1_1_4_1_AP            ,
                   SOL_TRACK_1_1_1_1_4_1               ,
                   SOL_TRACK_1_1_1_1_4_2_AP            ,
                   SOL_TRACK_1_1_1_1_4_2               ,
                   SOL_TRACK_1_1_1_1_4_3_AP            ,
                   SOL_TRACK_1_1_1_1_4_3               ,
                   SOL_TRACK_1_1_1_1_4_4_AP            ,
                   SOL_TRACK_1_1_1_1_4_4               ,
                   SOL_TRACK_1_1_1_1_5_1_AP            ,
                   SOL_TRACK_1_1_1_1_5_1               ,
                   SOL_TRACK_1_1_1_1_5_2_AP            ,
                   SOL_TRACK_1_1_1_1_5_2               ,
                   SOL_TRACK_1_1_1_1_6_1_AP            ,
                   SOL_TRACK_1_1_1_1_6_1               ,
                   SOL_TRACK_1_1_1_1_6_2_AP            ,
                   SOL_TRACK_1_1_1_1_6_2               ,
                   SOL_TRACK_1_1_1_1_6_3_AP            ,
                   SOL_TRACK_1_1_1_1_6_3               ,
                   SOL_TRACK_1_1_1_1_7_1_AP            ,
                   SOL_TRACK_1_1_1_1_7_1               ,
                   SOL_TRACK_1_1_1_1_7_2_AP            ,
                   SOL_TRACK_1_1_1_1_7_2               ,
                   SOL_TRACK_1_1_1_1_7_3_AP            ,
                   SOL_TRACK_1_1_1_1_7_3               ,
                   SOL_TRACK_1_1_1_2_2_1_1_AP          ,
                   SOL_TRACK_1_1_1_2_2_1_1             ,
                   SOL_TRACK_1_1_1_2_2_1_2_AP          ,
                   SOL_TRACK_1_1_1_2_2_1_2             ,
                   SOL_TRACK_1_1_1_2_2_2_AP            ,
                   SOL_TRACK_1_1_1_2_2_2               ,
                   SOL_TRACK_1_1_1_2_2_3_AP            ,
                   SOL_TRACK_1_1_1_2_2_3               ,
                   SOL_TRACK_1_1_1_2_2_4_AP            ,
                   SOL_TRACK_1_1_1_2_2_4               ,
                   SOL_TRACK_1_1_1_2_2_5_AP            ,
                   SOL_TRACK_1_1_1_2_2_5               ,
                   SOL_TRACK_1_1_1_2_2_6_AP            ,
                   SOL_TRACK_1_1_1_2_2_6               ,
                   SOL_TRACK_1_1_1_2_3_1_AP            ,
                   SOL_TRACK_1_1_1_2_3_1               ,
                   SOL_TRACK_1_1_1_2_3_2_AP            ,
                   SOL_TRACK_1_1_1_2_3_2               ,
                   SOL_TRACK_1_1_1_2_3_3_AP            ,
                   SOL_TRACK_1_1_1_2_3_3_A             ,
                   SOL_TRACK_1_1_1_2_3_3_B             ,
                   SOL_TRACK_1_1_1_2_3_3_C             ,
                   SOL_TRACK_1_1_1_2_3_4_AP            ,
                   SOL_TRACK_1_1_1_2_3_4               ,
                   SOL_TRACK_1_1_1_2_4_1_1_AP          ,
                   SOL_TRACK_1_1_1_2_4_1_1             ,
                   SOL_TRACK_1_1_1_2_4_1_2_AP          ,
                   SOL_TRACK_1_1_1_2_4_1_2_A           ,
                   SOL_TRACK_1_1_1_2_4_1_2_B           ,
                   SOL_TRACK_1_1_1_2_4_1_2_C           ,
                   SOL_TRACK_1_1_1_2_4_2_1_AP          ,
                   SOL_TRACK_1_1_1_2_4_2_1             ,
                   SOL_TRACK_1_1_1_2_4_2_2_AP          ,
                   SOL_TRACK_1_1_1_2_4_2_2_A           ,
                   SOL_TRACK_1_1_1_2_4_2_2_B           ,
                   SOL_TRACK_1_1_1_2_4_2_2_C           ,
                   SOL_TRACK_1_1_1_2_4_2_2_D           ,
                   SOL_TRACK_1_1_1_2_5_1_AP            ,
                   SOL_TRACK_1_1_1_2_5_1               ,
                   SOL_TRACK_1_1_1_2_5_2_AP            ,
                   SOL_TRACK_1_1_1_2_5_2               ,
                   SOL_TRACK_1_1_1_2_5_3_AP            ,
                   SOL_TRACK_1_1_1_2_5_3               ,
                   SOL_TRACK_1_1_1_3_2_1_AP            ,
                   SOL_TRACK_1_1_1_3_2_1               ,
                   SOL_TRACK_1_1_1_3_2_2_AP            ,
                   SOL_TRACK_1_1_1_3_2_2               ,
                   SOL_TRACK_1_1_1_3_2_3_AP            ,
                   SOL_TRACK_1_1_1_3_2_3               ,
                   SOL_TRACK_1_1_1_3_2_4_AP            ,
                   SOL_TRACK_1_1_1_3_2_4               ,
                   SOL_TRACK_1_1_1_3_2_5_AP            ,
                   SOL_TRACK_1_1_1_3_2_5               ,
                   SOL_TRACK_1_1_1_3_2_6_AP            ,
                   SOL_TRACK_1_1_1_3_2_6               ,
                   SOL_TRACK_1_1_1_3_2_7_AP            ,
                   SOL_TRACK_1_1_1_3_2_7               ,
                   SOL_TRACK_1_1_1_3_3_1_AP            ,
                   SOL_TRACK_1_1_1_3_3_1               ,
                   SOL_TRACK_1_1_1_3_3_2_AP            ,
                   SOL_TRACK_1_1_1_3_3_2               ,
                   SOL_TRACK_1_1_1_3_3_3_AP            ,
                   SOL_TRACK_1_1_1_3_4_1_AP            ,
                   SOL_TRACK_1_1_1_3_4_1               ,
                   SOL_TRACK_1_1_1_3_5_1_AP            ,
                   SOL_TRACK_1_1_1_3_5_1               ,
                   SOL_TRACK_1_1_1_3_5_2_AP            ,
                   SOL_TRACK_1_1_1_3_5_2               ,
                   SOL_TRACK_1_1_1_3_6_1_AP            ,
                   SOL_TRACK_1_1_1_3_6_1               ,
                   SOL_TRACK_1_1_1_3_7_1_AP            ,
                   SOL_TRACK_1_1_1_3_7_1               ,
                   SOL_TRACK_1_1_1_3_7_2_1_AP          ,
                   SOL_TRACK_1_1_1_3_7_2_1             ,
                   SOL_TRACK_1_1_1_3_7_2_2_AP          ,
                   SOL_TRACK_1_1_1_3_7_2_2             ,
                   SOL_TRACK_1_1_1_3_7_3_AP            ,
                   SOL_TRACK_1_1_1_3_7_3               ,
                   SOL_TRACK_1_1_1_3_7_4_AP            ,
                   SOL_TRACK_1_1_1_3_7_4               ,
                   SOL_TRACK_1_1_1_3_7_5_AP            ,
                   SOL_TRACK_1_1_1_3_7_5               ,
                   SOL_TRACK_1_1_1_3_7_6_AP            ,
                   SOL_TRACK_1_1_1_3_7_6               ,
                   SOL_TRACK_1_1_1_3_7_7_AP            ,
                   SOL_TRACK_1_1_1_3_7_7               ,
                   SOL_TRACK_1_1_1_3_7_8_AP            ,
                   SOL_TRACK_1_1_1_3_7_8               ,
                   SOL_TRACK_1_1_1_3_7_9_AP            ,
                   SOL_TRACK_1_1_1_3_7_9               ,
                   SOL_TRACK_1_1_1_3_7_10_AP           ,
                   SOL_TRACK_1_1_1_3_7_10              ,
                   SOL_TRACK_1_1_1_3_7_11_AP           ,
                   SOL_TRACK_1_1_1_3_7_11              ,
                   SOL_TRACK_1_1_1_3_7_12_AP           ,
                   SOL_TRACK_1_1_1_3_7_12              ,
                   SOL_TRACK_1_1_1_3_7_13_AP           ,
                   SOL_TRACK_1_1_1_3_7_13              ,
                   SOL_TRACK_1_1_1_3_7_14_AP           ,
                   SOL_TRACK_1_1_1_3_7_14              ,
                   SOL_TRACK_1_1_1_3_7_15_1_AP         ,
                   SOL_TRACK_1_1_1_3_7_15_1            ,
                   SOL_TRACK_1_1_1_3_7_15_2_AP         ,
                   SOL_TRACK_1_1_1_3_7_15_2            ,
                   SOL_TRACK_1_1_1_3_7_16_AP           ,
                   SOL_TRACK_1_1_1_3_7_16              ,
                   SOL_TRACK_1_1_1_3_7_17_AP           ,
                   SOL_TRACK_1_1_1_3_7_17              ,
                   SOL_TRACK_1_1_1_3_7_18_AP           ,
                   SOL_TRACK_1_1_1_3_7_18              ,
                   SOL_TRACK_1_1_1_3_7_19_AP           ,
                   SOL_TRACK_1_1_1_3_7_19              ,
                   SOL_TRACK_1_1_1_3_7_20_AP           ,
                   SOL_TRACK_1_1_1_3_7_20              ,
                   SOL_TRACK_1_1_1_3_7_21_AP           ,
                   SOL_TRACK_1_1_1_3_7_21              ,
                   SOL_TRACK_1_1_1_3_7_22_AP           ,
                   SOL_TRACK_1_1_1_3_7_22              ,
                   SOL_TRACK_1_1_1_3_7_23_AP           ,
                   SOL_TRACK_1_1_1_3_7_23              ,
                   SOL_TRACK_1_1_1_3_8_1_AP            ,
                   SOL_TRACK_1_1_1_3_8_1               ,
                   SOL_TRACK_1_1_1_3_8_2_AP            ,
                   SOL_TRACK_1_1_1_3_8_2               ,
                   SOL_TRACK_1_1_1_3_9_1_AP            ,
                   SOL_TRACK_1_1_1_3_9_1               ,
                   SOL_TRACK_1_1_1_3_9_2_AP            ,
                   SOL_TRACK_1_1_1_3_9_2               ,
                   SOL_TRACK_1_1_1_3_10_1_AP           ,
                   SOL_TRACK_1_1_1_3_10_1              ,
                   SOL_TRACK_1_1_1_3_10_2_AP           ,
                   SOL_TRACK_1_1_1_3_10_2              ,
                   SOL_TRACK_1_1_1_3_11_1_AP           ,
                   SOL_TRACK_1_1_1_3_11_1              ,
                   SOL_TRACK_1_1_1_3_12_1_AP           ,
                   SOL_TRACK_1_1_1_3_12_1              ,
                   TIPO_BINARIO                        ,
                   SEDE_TECNICA                        ,
                   GRUPPO_AUTORIZZATIVO                ,
                   SOL_TRACK_1_1_1_1_2_4_1_AP          ,
                   SOL_TRACK_1_1_1_1_2_4_1             ,
                   SOL_TRACK_1_1_1_1_2_4_2_AP          ,
                   SOL_TRACK_1_1_1_1_2_4_2             ,
                   SOL_TRACK_1_1_1_1_2_4_3_AP          ,
                   SOL_TRACK_1_1_1_1_2_4_4_AP          ,
                   SOL_TRACK_1_1_1_1_2_4_4             ,
                   SOL_TRACK_1_1_1_1_3_1_1_AP          ,
                   SOL_TRACK_1_1_1_1_3_1_1_INF         ,
                   SOL_TRACK_1_1_1_1_3_1_1_SUP         ,
                   SOL_TRACK_1_1_1_1_3_1_2_AP          ,
                   SOL_TRACK_1_1_1_1_3_1_2             ,
                   SOL_TRACK_1_1_1_1_3_1_3_AP          ,
                   SOL_TRACK_1_1_1_1_3_1_3             ,
                   SOL_TRACK_1_1_1_1_6_4_AP            ,
                   SOL_TRACK_1_1_1_1_6_4               ,
                   SOL_TRACK_1_1_1_1_6_5_AP            ,
                   SOL_TRACK_1_1_1_1_6_5               ,
                   SOL_TRACK_1_1_1_1_7_4_AP            ,
                   SOL_TRACK_1_1_1_1_7_4               ,
                   SOL_TRACK_1_1_1_1_7_5_AP            ,
                   SOL_TRACK_1_1_1_1_7_5               ,
                   SOL_TRACK_1_1_1_1_7_6_AP            ,
                   SOL_TRACK_1_1_1_1_7_6               ,
                   SOL_TRACK_1_1_1_1_7_7_AP            ,
                   SOL_TRACK_1_1_1_1_7_7               ,
                   SOL_TRACK_1_1_1_1_7_8_AP            ,
                   SOL_TRACK_1_1_1_1_7_9_AP            ,
                   SOL_TRACK_1_1_1_1_7_9               ,
                   SOL_TRACK_1_1_1_2_2_1_2_1_AP        ,
                   SOL_TRACK_1_1_1_2_2_1_2_1           ,
                   SOL_TRACK_1_1_1_2_2_1_3_AP          ,
                   SOL_TRACK_1_1_1_2_2_1_3             ,
                   SOL_TRACK_1_1_1_2_4_3_AP            ,
                   SOL_TRACK_1_1_1_2_4_3               ,
                   SOL_TRACK_1_1_1_3_2_8_AP            ,
                   SOL_TRACK_1_1_1_3_2_8               ,
                   SOL_TRACK_1_1_1_3_2_9_AP            ,
                   SOL_TRACK_1_1_1_3_3_3_2_AP          ,
                   SOL_TRACK_1_1_1_3_3_3_2             ,
                   SOL_TRACK_1_1_1_3_3_3_3_AP          ,
                   SOL_TRACK_1_1_1_3_3_3_3             ,
                   SOL_TRACK_1_1_1_3_3_3_1_AP          ,
                   SOL_TRACK_1_1_1_3_3_3_1             ,
                   SOL_TRACK_1_1_1_3_3_4_AP            ,
                   SOL_TRACK_1_1_1_3_3_4               ,
                   SOL_TRACK_1_1_1_3_3_5_AP            ,
                   SOL_TRACK_1_1_1_3_3_6_AP            ,
                   SOL_TRACK_1_1_1_3_3_6               ,
                   SOL_TRACK_1_1_1_3_3_7_AP            ,
                   SOL_TRACK_1_1_1_3_3_7               ,
                   SOL_TRACK_1_1_1_3_3_8_AP            ,
                   SOL_TRACK_1_1_1_3_3_8               ,
                   SOL_TRACK_1_1_1_3_3_9_AP            ,
                   SOL_TRACK_1_1_1_3_3_10_AP           ,
                   SOL_TRACK_1_1_1_3_5_3_AP            ,
                   SOL_TRACK_1_1_1_3_7_1_2_AP          ,
                   SOL_TRACK_1_1_1_3_7_1_2             ,
                   SOL_TRACK_1_1_1_3_7_1_3_AP          ,
                   SOL_TRACK_1_1_1_3_7_1_4_AP          ,
                   SOL_TRACK_1_1_1_3_7_1_4             ,
                   SOL_TRACK_1_1_1_3_7_11_1_AP         ,
                   SOL_TRACK_1_1_1_3_11_2_AP           ,
                   SOL_TRACK_1_1_1_3_11_2              ,
                   SOL_TRACK_1_1_1_3_11_3_AP           ,
                   SOL_TRACK_1_1_1_3_11_3              ,
                   SOL_TRACK_1_1_1_4_1_AP              ,
                   SOL_TRACK_1_1_1_4_1                 ,
                   SOL_TRACK_1_1_1_4_2_AP              ,
                   SOL_TRACK_1_1_1_1_3_5_1             ,
                   SOL_TRACK_1_1_1_1_3_5_1_AP          ,
                   SOL_TRACK_1_1_1_1_7_10_AP           ,
                   SOL_TRACK_1_1_1_1_7_10              ,
                   SOL_TRACK_1_1_1_1_7_11_AP           ,
                   SOL_TRACK_1_1_1_1_7_11              ,
                   SOL_TRACK_1_1_1_3_2_10_AP           ,
                   SOL_TRACK_1_1_1_3_2_10              ,
                   SOL_TRACK_1_1_1_3_7_1_1_AP          ,
                   SOL_TRACK_1_1_1_3_7_1_1             ,
                   SOL_TRACK_1_1_1_1_2_1_2_AP          ,
                   SOL_TRACK_1_1_1_1_2_1_2
		from Rinf_Controllati_Evo.BINARI_CORSA_SOL;
--
      Insert Into  Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_SOL_INF (
                   SOL_TRACK_1_1_1_0_0_1             , 
                   TIPO_DICHIARAZIONE                ,
                   SOL_TRACK_1_1_1_1_1_1O2_AP        ,
                   SOL_TRACK_1_1_1_1_1_1O2           ,
                   KM_INIZIO                         ,
                   KM_FINE                           ,
                   LATITUDINE_INIZIO                 ,
                   LONGITUDINE_INIZIO                ,
                   ALTITUDINE_INIZIO                 ,
                   LATITUDINE_FINE                   ,
                   LONGITUDINE_FINE                  ,
                   ALTITUDINE_FINE                   ,
                   FLAG_CALCOLATO	                  )
        Select 
                   SOL_TRACK_1_1_1_0_0_1             , 
                   TIPO_DICHIARAZIONE                ,
                   SOL_TRACK_1_1_1_1_1_1O2_AP        ,
                   SOL_TRACK_1_1_1_1_1_1O2           ,
                   KM_INIZIO                         ,
                   KM_FINE                           ,
                   LATITUDINE_INIZIO                 ,
                   LONGITUDINE_INIZIO                ,
                   ALTITUDINE_INIZIO                 ,
                   LATITUDINE_FINE                   ,
                   LONGITUDINE_FINE                  ,
                   ALTITUDINE_FINE                   ,
                   FLAG_CALCOLATO	
		from Rinf_Controllati_Evo.DICHIARAZIONI_BINARIO_SOL_INF;
--
      Insert Into  Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_SOL_ENE (
                   SOL_TRACK_1_1_1_0_0_1        ,
                   TIPO_DICHIARAZIONE           ,
                   SOL_TRACK_1_1_1_2_1_1O2_AP   ,
                   SOL_TRACK_1_1_1_2_1_1O2      ,
                   KM_INIZIO                    ,
                   KM_FINE                      ,
                   LATITUDINE_INIZIO            ,
                   LONGITUDINE_INIZIO           ,
                   ALTITUDINE_INIZIO            ,
                   LATITUDINE_FINE              ,
                   LONGITUDINE_FINE             ,
                   ALTITUDINE_FINE              ,
                   FLAG_CALCOLATO           )
        Select 
                   SOL_TRACK_1_1_1_0_0_1        ,
                   TIPO_DICHIARAZIONE           ,
                   SOL_TRACK_1_1_1_2_1_1O2_AP   ,
                   SOL_TRACK_1_1_1_2_1_1O2      ,
                   KM_INIZIO                    ,
                   KM_FINE                      ,
                   LATITUDINE_INIZIO            ,
                   LONGITUDINE_INIZIO           ,
                   ALTITUDINE_INIZIO            ,
                   LATITUDINE_FINE              ,
                   LONGITUDINE_FINE             ,
                   ALTITUDINE_FINE              ,
                   FLAG_CALCOLATO   
		from Rinf_Controllati_Evo.DICHIARAZIONI_BINARIO_SOL_ENE;
--
      Insert Into  Rinf_Autorizzazioni_Evo.DICHIARAZIONI_BINARIO_SOL_CCS  (
                   SOL_TRACK_1_1_1_0_0_1      ,
                   TIPO_DICHIARAZIONE         ,
                   SOL_TRACK_1_1_1_3_1_1_AP   ,
                   SOL_TRACK_1_1_1_3_1_1      ,
                   KM_INIZIO                  ,
                   KM_FINE                    ,
                   LATITUDINE_INIZIO          ,
                   LONGITUDINE_INIZIO         ,
                   ALTITUDINE_INIZIO          ,
                   LATITUDINE_FINE            ,
                   LONGITUDINE_FINE           ,
                   ALTITUDINE_FINE            ,
                   FLAG_CALCOLATO          )
        Select 
                   SOL_TRACK_1_1_1_0_0_1      ,
                   TIPO_DICHIARAZIONE         ,
                   SOL_TRACK_1_1_1_3_1_1_AP   ,
                   SOL_TRACK_1_1_1_3_1_1      ,
                   KM_INIZIO                  ,
                   KM_FINE                    ,
                   LATITUDINE_INIZIO          ,
                   LONGITUDINE_INIZIO         ,
                   ALTITUDINE_INIZIO          ,
                   LATITUDINE_FINE            ,
                   LONGITUDINE_FINE           ,
                   ALTITUDINE_FINE            ,
                   FLAG_CALCOLATO
		from Rinf_Controllati_Evo.DICHIARAZIONI_BINARIO_SOL_CCS;
--
      Insert Into  Rinf_Autorizzazioni_Evo.GALLERIE_BINARI_SOL  (
                   SOL_TUNNEL_1_1_1_1_8_1             ,
                   SOL_TUNNEL_1_1_1_1_8_2             ,
                   SOL_TUNNEL_1_1_1_1_8_2_D           ,
                   SOL_TUNNEL_1_1_1_1_8_3_AP          ,
                   SOL_TUNNEL_1_1_1_1_8_3             ,
                   SOL_TUNNEL_1_1_1_1_8_4_AP          ,
                   SOL_TUNNEL_1_1_1_1_8_4             ,
                   SOL_TUNNEL_1_1_1_1_8_7_AP          ,
                   SOL_TUNNEL_1_1_1_1_8_7             ,
                   SOL_TUNNEL_1_1_1_1_8_8_AP          ,
                   SOL_TUNNEL_1_1_1_1_8_8             ,
                   SOL_TUNNEL_1_1_1_1_8_9_AP          ,
                   SOL_TUNNEL_1_1_1_1_8_9             ,
                   SOL_TUNNEL_1_1_1_1_8_10_AP         ,
                   SOL_TUNNEL_1_1_1_1_8_10            ,
                   SOL_TUNNEL_1_1_1_1_8_11_AP         ,
                   SOL_TUNNEL_1_1_1_1_8_11            ,
                   GALLERIA_PRINCIPALE                ,
                   CONFIGURAZIONE_GALLERIA            ,
                   GRUPPO_AUTORIZZATIVO               ,
                   SOL_TUNNEL_1_1_1_1_8_8_1_AP        ,
                   SOL_TUNNEL_1_1_1_1_8_8_1           ,
                   SOL_TUNNEL_1_1_1_1_8_8_2_AP        ,
                   SOL_TUNNEL_1_1_1_1_8_8_2    )
        Select 
                   SOL_TUNNEL_1_1_1_1_8_1             ,
                   SOL_TUNNEL_1_1_1_1_8_2             ,
                   SOL_TUNNEL_1_1_1_1_8_2_D           ,
                   SOL_TUNNEL_1_1_1_1_8_3_AP          ,
                   SOL_TUNNEL_1_1_1_1_8_3             ,
                   SOL_TUNNEL_1_1_1_1_8_4_AP          ,
                   SOL_TUNNEL_1_1_1_1_8_4             ,
                   SOL_TUNNEL_1_1_1_1_8_7_AP          ,
                   SOL_TUNNEL_1_1_1_1_8_7             ,
                   SOL_TUNNEL_1_1_1_1_8_8_AP          ,
                   SOL_TUNNEL_1_1_1_1_8_8             ,
                   SOL_TUNNEL_1_1_1_1_8_9_AP          ,
                   SOL_TUNNEL_1_1_1_1_8_9             ,
                   SOL_TUNNEL_1_1_1_1_8_10_AP         ,
                   SOL_TUNNEL_1_1_1_1_8_10            ,
                   SOL_TUNNEL_1_1_1_1_8_11_AP         ,
                   SOL_TUNNEL_1_1_1_1_8_11            ,
                   GALLERIA_PRINCIPALE                ,
                   CONFIGURAZIONE_GALLERIA            ,
                   GRUPPO_AUTORIZZATIVO               ,
                   SOL_TUNNEL_1_1_1_1_8_8_1_AP        ,
                   SOL_TUNNEL_1_1_1_1_8_8_1           ,
                   SOL_TUNNEL_1_1_1_1_8_8_2_AP        ,
                   SOL_TUNNEL_1_1_1_1_8_8_2 
		from Rinf_Controllati_Evo.GALLERIE_BINARI_SOL;
--
      Insert Into  Rinf_Autorizzazioni_Evo.REL_GALLERIE_BINARI_SOL (
                   SOL_TUNNEL_1_1_1_1_8_2  ,
                   SOL_TRACK_1_1_1_0_0_1 ,
				   SOL_TUNNEL_1_1_1_1_8_8_AP,
				   SOL_TUNNEL_1_1_1_1_8_8_1_AP)
        Select     
            	   SOL_TUNNEL_1_1_1_1_8_2  ,
                   SOL_TRACK_1_1_1_0_0_1,
				   SOL_TUNNEL_1_1_1_1_8_8_AP,
				   SOL_TUNNEL_1_1_1_1_8_8_1_AP
		from Rinf_Controllati_Evo.REL_GALLERIE_BINARI_SOL;
--
      Insert Into  Rinf_Autorizzazioni_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL  (
                   SOL_TUNNEL_1_1_1_1_8_2        ,
                   TIPO_DICHIARAZIONE            ,
                   SOL_TUNNEL_1_1_1_1_8_5O6_AP   ,
                   SOL_TUNNEL_1_1_1_1_8_5O6      ,
                   KM_INIZIO                     ,
                   KM_FINE                       ,
                   LATITUDINE_INIZIO             ,
                   LONGITUDINE_INIZIO            ,
                   ALTITUDINE_INIZIO             ,
                   LATITUDINE_FINE               ,
                   LONGITUDINE_FINE              ,
                   ALTITUDINE_FINE               ,
                   FLAG_CALCOLATO    )
        Select 
                   SOL_TUNNEL_1_1_1_1_8_2        ,
                   TIPO_DICHIARAZIONE            ,
                   SOL_TUNNEL_1_1_1_1_8_5O6_AP   ,
                   SOL_TUNNEL_1_1_1_1_8_5O6      ,
                   KM_INIZIO                     ,
                   KM_FINE                       ,
                   LATITUDINE_INIZIO             ,
                   LONGITUDINE_INIZIO            ,
                   ALTITUDINE_INIZIO             ,
                   LATITUDINE_FINE               ,
                   LONGITUDINE_FINE              ,
                   ALTITUDINE_FINE               ,
                   FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.DICHIARAZIONI_GALLERIE_BIN_SOL;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL (
                   SOL_TRACK_1_1_1_0_0_1  ,
                   SOL_TRACK_1_1_1_1_2_1  ,
                   KM_INIZIO              ,
                   KM_FINE             )
        Select 
                   SOL_TRACK_1_1_1_0_0_1  ,
                   SOL_TRACK_1_1_1_1_2_1  ,
                   KM_INIZIO              ,
                   KM_FINE 
		from Rinf_Controllati_Evo.PAR_1_1_1_1_2_1_CAT_TEN_SOL;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_2_CAT_LINEA  (
                   SOL_TRACK_1_1_1_0_0_1     ,
                   SOL_TRACK_1_1_1_1_2_2     ,
                   KM_INIZIO                 ,
                   KM_FINE                   ,
                   LATITUDINE_INIZIO         ,
                   LONGITUDINE_INIZIO        ,
                   ALTITUDINE_INIZIO         ,
                   LATITUDINE_FINE           ,
                   LONGITUDINE_FINE          ,
                   ALTITUDINE_FINE           ,
                   FLAG_CALCOLATO           )
        Select 
                   SOL_TRACK_1_1_1_0_0_1     ,
                   SOL_TRACK_1_1_1_1_2_2     ,
                   KM_INIZIO                 ,
                   KM_FINE                   ,
                   LATITUDINE_INIZIO         ,
                   LONGITUDINE_INIZIO        ,
                   ALTITUDINE_INIZIO         ,
                   LATITUDINE_FINE           ,
                   LONGITUDINE_FINE          ,
                   ALTITUDINE_FINE           ,
                   FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.PAR_1_1_1_1_2_2_CAT_LINEA;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_4_CAP_CARICO  (
                   SOL_TRACK_1_1_1_0_0_1  ,
                   SOL_TRACK_1_1_1_1_2_4  ,
                   KM_INIZIO              ,
                   KM_FINE                ,
                   LATITUDINE_INIZIO      ,
                   LONGITUDINE_INIZIO     ,
                   ALTITUDINE_INIZIO      ,
                   LATITUDINE_FINE        ,
                   LONGITUDINE_FINE       ,
                   ALTITUDINE_FINE        ,
                   FLAG_CALCOLATO        )
        Select 
                   SOL_TRACK_1_1_1_0_0_1  ,
                   SOL_TRACK_1_1_1_1_2_4  ,
                   KM_INIZIO              ,
                   KM_FINE                ,
                   LATITUDINE_INIZIO      ,
                   LONGITUDINE_INIZIO     ,
                   ALTITUDINE_INIZIO      ,
                   LATITUDINE_FINE        ,
                   LONGITUDINE_FINE       ,
                   ALTITUDINE_FINE        ,
                   FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.PAR_1_1_1_1_2_4_CAP_CARICO;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_3_4_PROF_CAS_M  (
                   SOL_TRACK_1_1_1_0_0_1        ,
                   SOL_TRACK_1_1_1_1_3_4        ,
                   KM_INIZIO                    ,
                   KM_FINE                      ,
                   LATITUDINE_INIZIO            ,
                   LONGITUDINE_INIZIO           ,
                   ALTITUDINE_INIZIO            ,
                   LATITUDINE_FINE              ,
                   LONGITUDINE_FINE             ,
                   ALTITUDINE_FINE              ,
                   FLAG_CALCOLATO             )
        Select 
                   SOL_TRACK_1_1_1_0_0_1        ,
                   SOL_TRACK_1_1_1_1_3_4        ,
                   KM_INIZIO                    ,
                   KM_FINE                      ,
                   LATITUDINE_INIZIO            ,
                   LONGITUDINE_INIZIO           ,
                   ALTITUDINE_INIZIO            ,
                   LATITUDINE_FINE              ,
                   LONGITUDINE_FINE             ,
                   ALTITUDINE_FINE              ,
                   FLAG_CALCOLATO  
		from Rinf_Controllati_Evo.PAR_1_1_1_1_3_4_PROF_CAS_M;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_3_5_PROF_SEMI_R  (
                   SOL_TRACK_1_1_1_0_0_1       , 
                   SOL_TRACK_1_1_1_1_3_5       ,
                   KM_INIZIO                   ,
                   KM_FINE                     ,
                   LATITUDINE_INIZIO           ,
                   LONGITUDINE_INIZIO          ,
                   ALTITUDINE_INIZIO           ,
                   LATITUDINE_FINE             ,
                   LONGITUDINE_FINE            ,
                   ALTITUDINE_FINE             ,
                   FLAG_CALCOLATO           )
        Select 
                   SOL_TRACK_1_1_1_0_0_1       , 
                   SOL_TRACK_1_1_1_1_3_5       ,
                   KM_INIZIO                   ,
                   KM_FINE                     ,
                   LATITUDINE_INIZIO           ,
                   LONGITUDINE_INIZIO          ,
                   ALTITUDINE_INIZIO           ,
                   LATITUDINE_FINE             ,
                   LONGITUDINE_FINE            ,
                   ALTITUDINE_FINE             ,
                   FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.PAR_1_1_1_1_3_5_PROF_SEMI_R;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_3_6_GRADIENTE  (
                   SOL_TRACK_1_1_1_0_0_1    ,
                   PENDENZA                 ,
                   KM_INIZIO                ,
                   KM_FINE          )
        Select 
                   SOL_TRACK_1_1_1_0_0_1    ,
                   PENDENZA                 ,
                   KM_INIZIO                ,
                   KM_FINE
		from Rinf_Controllati_Evo.PAR_1_1_1_1_3_6_GRADIENTE;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_3_3_GSM_R_FAC  (
                   SOL_TRACK_1_1_1_0_0_1      ,
                   SOL_TRACK_1_1_1_3_3_3      ,
                   KM_INIZIO                  ,
                   KM_FINE                    ,
                   LATITUDINE_INIZIO          ,
                   LONGITUDINE_INIZIO         ,
                   ALTITUDINE_INIZIO          ,
                   LATITUDINE_FINE            ,
                   LONGITUDINE_FINE           ,
                   ALTITUDINE_FINE            ,
                   FLAG_CALCOLATO        )
        Select 
                   SOL_TRACK_1_1_1_0_0_1      ,
                   SOL_TRACK_1_1_1_3_3_3      ,
                   KM_INIZIO                  ,
                   KM_FINE                    ,
                   LATITUDINE_INIZIO          ,
                   LONGITUDINE_INIZIO         ,
                   ALTITUDINE_INIZIO          ,
                   LATITUDINE_FINE            ,
                   LONGITUDINE_FINE           ,
                   ALTITUDINE_FINE            ,
                   FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.PAR_1_1_1_3_3_3_GSM_R_FAC;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_2_4_3_LOCAVERSPEC (
                   SOL_TRACK_1_1_1_0_0_1       ,
                   SOL_TRACK_1_1_1_1_2_4_3     ,
                   KM_INIZIO                   ,
                   KM_FINE                     ,
                   LATITUDINE_INIZIO           ,
                   LONGITUDINE_INIZIO          ,
                   ALTITUDINE_INIZIO           ,
                   LATITUDINE_FINE             ,
                   LONGITUDINE_FINE            ,
                   ALTITUDINE_FINE             ,
                   FLAG_CALCOLATO            )
        Select 
                   SOL_TRACK_1_1_1_0_0_1       ,
                   SOL_TRACK_1_1_1_1_2_4_3     ,
                   KM_INIZIO                   ,
                   KM_FINE                     ,
                   LATITUDINE_INIZIO           ,
                   LONGITUDINE_INIZIO          ,
                   ALTITUDINE_INIZIO           ,
                   LATITUDINE_FINE             ,
                   LONGITUDINE_FINE            ,
                   ALTITUDINE_FINE             ,
                   FLAG_CALCOLATO   
		from Rinf_Controllati_Evo.PAR_1_1_1_1_2_4_3_LOCAVERSPEC;
--	   
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_1_7_8_LOCA_SIST_RTB (
                   SOL_TRACK_1_1_1_0_0_1      ,
                   SOL_TRACK_1_1_1_1_7_8      ,
                   KM_INIZIO                  ,
                   KM_FINE                    ,
                   LATITUDINE_INIZIO          ,
                   LONGITUDINE_INIZIO         ,
                   ALTITUDINE_INIZIO          ,
                   LATITUDINE_FINE            ,
                   LONGITUDINE_FINE           ,
                   ALTITUDINE_FINE            ,
                   FLAG_CALCOLATO         )
        Select 
                   SOL_TRACK_1_1_1_0_0_1      ,
                   SOL_TRACK_1_1_1_1_7_8      ,
                   KM_INIZIO                  ,
                   KM_FINE                    ,
                   LATITUDINE_INIZIO          ,
                   LONGITUDINE_INIZIO         ,
                   ALTITUDINE_INIZIO          ,
                   LATITUDINE_FINE            ,
                   LONGITUDINE_FINE           ,
                   ALTITUDINE_FINE            ,
                   FLAG_CALCOLATO   
		from Rinf_Controllati_Evo.PAR_1_1_1_1_7_8_LOCA_SIST_RTB;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_2_9_COMP_ETCS  (
                   SOL_TRACK_1_1_1_0_0_1    ,
                   SOL_TRACK_1_1_1_3_2_9    ,
                   KM_INIZIO                ,
                   KM_FINE                  ,
                   LATITUDINE_INIZIO        ,
                   LONGITUDINE_INIZIO       ,
                   ALTITUDINE_INIZIO        ,
                   LATITUDINE_FINE          ,
                   LONGITUDINE_FINE         ,
                   ALTITUDINE_FINE          ,
                   FLAG_CALCOLATO      )
        Select 
                   SOL_TRACK_1_1_1_0_0_1    ,
                   SOL_TRACK_1_1_1_3_2_9    ,
                   KM_INIZIO                ,
                   KM_FINE                  ,
                   LATITUDINE_INIZIO        ,
                   LONGITUDINE_INIZIO       ,
                   ALTITUDINE_INIZIO        ,
                   LATITUDINE_FINE          ,
                   LONGITUDINE_FINE         ,
                   ALTITUDINE_FINE          ,
                   FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.PAR_1_1_1_3_2_9_COMP_ETCS;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_3_5_RETI_GSM_R  (
                   SOL_TRACK_1_1_1_0_0_1      ,
                   SOL_TRACK_1_1_1_3_3_5      ,
                   KM_INIZIO                  ,
                   KM_FINE                    ,
                   LATITUDINE_INIZIO          ,
                   LONGITUDINE_INIZIO         ,
                   ALTITUDINE_INIZIO          ,
                   LATITUDINE_FINE            ,
                   LONGITUDINE_FINE           ,
                   ALTITUDINE_FINE            ,
                   FLAG_CALCOLATO        )
        Select 
                   SOL_TRACK_1_1_1_0_0_1      ,
                   SOL_TRACK_1_1_1_3_3_5      ,
                   KM_INIZIO                  ,
                   KM_FINE                    ,
                   LATITUDINE_INIZIO          ,
                   LONGITUDINE_INIZIO         ,
                   ALTITUDINE_INIZIO          ,
                   LATITUDINE_FINE            ,
                   LONGITUDINE_FINE           ,
                   ALTITUDINE_FINE            ,
                   FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.PAR_1_1_1_3_3_5_RETI_GSM_R;
--
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_3_9_RADIO_VOCE  (
                   SOL_TRACK_1_1_1_0_0_1,
                   SOL_TRACK_1_1_1_3_3_9,
                   KM_INIZIO            ,
                   KM_FINE              ,
                   LATITUDINE_INIZIO    ,
                   LONGITUDINE_INIZIO   ,
                   ALTITUDINE_INIZIO    ,
                   LATITUDINE_FINE      ,
                   LONGITUDINE_FINE     ,
                   ALTITUDINE_FINE      ,
                   FLAG_CALCOLATO    )
        Select 
                   SOL_TRACK_1_1_1_0_0_1,
                   SOL_TRACK_1_1_1_3_3_9,
                   KM_INIZIO            ,
                   KM_FINE              ,
                   LATITUDINE_INIZIO    ,
                   LONGITUDINE_INIZIO   ,
                   ALTITUDINE_INIZIO    ,
                   LATITUDINE_FINE      ,
                   LONGITUDINE_FINE     ,
                   ALTITUDINE_FINE      ,
                   FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.PAR_1_1_1_3_3_9_RADIO_VOCE;
--   
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_3_10_RADIO_DATI	   (
                   SOL_TRACK_1_1_1_0_0_1   ,
                   SOL_TRACK_1_1_1_3_3_10  ,
                   KM_INIZIO               ,
                   KM_FINE                 ,
                   LATITUDINE_INIZIO       ,
                   LONGITUDINE_INIZIO      ,
                   ALTITUDINE_INIZIO       ,
                   LATITUDINE_FINE         ,
                   LONGITUDINE_FINE        ,
                   ALTITUDINE_FINE         ,
                   FLAG_CALCOLATO     )
        Select 
                   SOL_TRACK_1_1_1_0_0_1   ,
                   SOL_TRACK_1_1_1_3_3_10  ,
                   KM_INIZIO               ,
                   KM_FINE                 ,
                   LATITUDINE_INIZIO       ,
                   LONGITUDINE_INIZIO      ,
                   ALTITUDINE_INIZIO       ,
                   LATITUDINE_FINE         ,
                   LONGITUDINE_FINE        ,
                   ALTITUDINE_FINE         ,
                   FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.PAR_1_1_1_3_3_10_RADIO_DATI;
--   
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_5_3_SIST_PRE_PROT  (
                   SOL_TRACK_1_1_1_0_0_1   ,
                   SOL_TRACK_1_1_1_3_5_3   ,
                   KM_INIZIO               ,
                   KM_FINE                 ,
                   LATITUDINE_INIZIO       ,
                   LONGITUDINE_INIZIO      ,
                   ALTITUDINE_INIZIO       ,
                   LATITUDINE_FINE         ,
                   LONGITUDINE_FINE        ,
                   ALTITUDINE_FINE         ,
                   FLAG_CALCOLATO         )
        Select 
                   SOL_TRACK_1_1_1_0_0_1   ,
                   SOL_TRACK_1_1_1_3_5_3   ,
                   KM_INIZIO               ,
                   KM_FINE                 ,
                   LATITUDINE_INIZIO       ,
                   LONGITUDINE_INIZIO      ,
                   ALTITUDINE_INIZIO       ,
                   LATITUDINE_FINE         ,
                   LONGITUDINE_FINE        ,
                   ALTITUDINE_FINE         ,
                   FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.PAR_1_1_1_3_5_3_SIST_PRE_PROT;
--   
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_7_1_3_SISTRILTRAIN  (
                   SOL_TRACK_1_1_1_0_0_1     ,
                   SOL_TRACK_1_1_1_3_7_1_3   ,
                   KM_INIZIO                 ,
                   KM_FINE                   ,
                   LATITUDINE_INIZIO         ,
                   LONGITUDINE_INIZIO        ,
                   ALTITUDINE_INIZIO         ,
                   LATITUDINE_FINE           ,
                   LONGITUDINE_FINE          ,
                   ALTITUDINE_FINE           ,
                   FLAG_CALCOLATO          )
        Select 
                   SOL_TRACK_1_1_1_0_0_1     ,
                   SOL_TRACK_1_1_1_3_7_1_3   ,
                   KM_INIZIO                 ,
                   KM_FINE                   ,
                   LATITUDINE_INIZIO         ,
                   LONGITUDINE_INIZIO        ,
                   ALTITUDINE_INIZIO         ,
                   LATITUDINE_FINE           ,
                   LONGITUDINE_FINE          ,
                   ALTITUDINE_FINE           ,
                   FLAG_CALCOLATO  
		from Rinf_Controllati_Evo.PAR_1_1_1_3_7_1_3_SISTRILTRAIN;
--   
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_3_7_11_1_CARMIN_ASSE  (
                   SOL_TRACK_1_1_1_0_0_1       ,
                   SOL_TRACK_1_1_1_3_7_11_1    ,
                   KM_INIZIO                   ,
                   KM_FINE                     ,
                   LATITUDINE_INIZIO           ,
                   LONGITUDINE_INIZIO          ,
                   ALTITUDINE_INIZIO           ,
                   LATITUDINE_FINE             ,
                   LONGITUDINE_FINE            ,
                   ALTITUDINE_FINE             ,
                   FLAG_CALCOLATO            )
        Select 
                   SOL_TRACK_1_1_1_0_0_1       ,
                   SOL_TRACK_1_1_1_3_7_11_1    ,
                   KM_INIZIO                   ,
                   KM_FINE                     ,
                   LATITUDINE_INIZIO           ,
                   LONGITUDINE_INIZIO          ,
                   ALTITUDINE_INIZIO           ,
                   LATITUDINE_FINE             ,
                   LONGITUDINE_FINE            ,
                   ALTITUDINE_FINE             ,
                   FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.PAR_1_1_1_3_7_11_1_CARMIN_ASSE;
--   
      Insert Into  Rinf_Autorizzazioni_Evo.PAR_1_1_1_4_2_NORME_DOC  (
                   SOL_TRACK_1_1_1_0_0_1  ,
                   SOL_TRACK_1_1_1_4_2    ,
                   KM_INIZIO              ,
                   KM_FINE                ,
                   LATITUDINE_INIZIO      ,
                   LONGITUDINE_INIZIO     ,
                   ALTITUDINE_INIZIO      ,
                   LATITUDINE_FINE        ,
                   LONGITUDINE_FINE       ,
                   ALTITUDINE_FINE        ,
                   FLAG_CALCOLATO     )
        Select 
                   SOL_TRACK_1_1_1_0_0_1  ,
                   SOL_TRACK_1_1_1_4_2    ,
                   KM_INIZIO              ,
                   KM_FINE                ,
                   LATITUDINE_INIZIO      ,
                   LONGITUDINE_INIZIO     ,
                   ALTITUDINE_INIZIO      ,
                   LATITUDINE_FINE        ,
                   LONGITUDINE_FINE       ,
                   ALTITUDINE_FINE        ,
                   FLAG_CALCOLATO 
		from Rinf_Controllati_Evo.PAR_1_1_1_4_2_NORME_DOC;
--
	  Insert Into  Rinf_Autorizzazioni_Evo.CORRIDOIO_SOL  (
                   CODICE_CORRIDOIO ,
                   SEDE_TECNICA    )
        Select 
                   CODICE_CORRIDOIO ,
                   SEDE_TECNICA 
		from Rinf_Controllati_Evo.CORRIDOIO_SOL;
--
      Insert Into  Rinf_Autorizzazioni_Evo.LINEE_TENT_SOL (
                   CODICE_LINEA_TENT  ,
                   SEDE_TECNICA   )
        Select 
                   CODICE_LINEA_TENT  ,
                   SEDE_TECNICA
		from Rinf_Controllati_Evo.LINEE_TENT_SOL;
--
      Insert Into  Rinf_Autorizzazioni_Evo.LINEA_COMM_SOL  (
                   CODICE_GIURISDIZIONE  ,
                   SEDE_TECNICA          ,
                   KM_INIZIO             ,
                   KM_FINE             )
        Select 
                   CODICE_GIURISDIZIONE  ,
                   SEDE_TECNICA          ,
                   KM_INIZIO             ,
                   KM_FINE  
		from Rinf_Controllati_Evo.LINEA_COMM_SOL;
--
      Insert Into  Rinf_Autorizzazioni_Evo.LINEA_FCL_SOL  (
                   CODICE_LINEA_FCL ,
                   SEDE_TECNICA	)
        Select 
                   CODICE_LINEA_FCL ,
                   SEDE_TECNICA
		from Rinf_Controllati_Evo.LINEA_FCL_SOL;
--
      Insert Into  Rinf_Autorizzazioni_Evo.FASCICOLO_SOL  (
                   CODICE_FASCICOLO,
                   SEDE_TECNICA  )
        Select 
                   CODICE_FASCICOLO,
                   SEDE_TECNICA
		from Rinf_Controllati_Evo.FASCICOLO_SOL;
--
   EXCEPTION
      When OTHERS Then
         p_error := SQLCODE;
         Dbms_Output.Put_Line ('SetSOLAuthorizationSchema - Errore: ' || Substr (SQLERRM, 1, 300));
   End SetSOLAuthorizationSchema;
--
-- ----------------------------------------------------------------------------
--                   Procedure SetAuthorizationDetails
-- ----------------------------------------------------------------------------
 Procedure SetAuthorizationDetails (p_Codice_Autorizzazione Number,
                                    p_error             Out Number) Is
   BEGIN
      p_error := 0;

      Insert Into  Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI 
                   ( CODICE_RICHIESTA,
                     ID_UTENTE,
                     FLAG_SEDE_CENTRALE,
                     CODICE_DTP,
                     TOTALE_SOL,
                     TOTALE_OP,
                     CODICE_STATO_RICHIESTA  )
              Select p_Codice_Autorizzazione, --RC_RINF RC_RES_DCI
                     u.ID_UTENTE,
                     0,
                     u.CODICE_DTP,
                     n_sol.tot_sol TOTALE_SOL,
                     n_op.tot_op TOTALE_OP,
                     1 CODICE_STATO_RICHIESTA
                From Rinf_Sicurezza_Evo.V_UTENTE_RUOLO u,
                     Rinf_Sicurezza_Evo.V_UTENTE_NOTIFICHE n,
                     (  Select d.CODICE_DTP, Count(o.SEDE_TECNICA) tot_op
                          From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI o,
                               Rinf_Anagrafiche_Evo.ANAG_DTP d
                         Where d.CODICE_DTP <> 'DG00' 
                           And d.CODICE_DTP = o.CODICE_DTP(+)
                      Group By d.codice_dtp) n_op,
                     (  Select d.CODICE_DTP, Count(s.SEDE_TECNICA) tot_sol
                          From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA s,
                               Rinf_Anagrafiche_Evo.ANAG_DTP d
                         Where d.CODICE_DTP <> 'DG00' 
                           And d.CODICE_DTP = s.CODICE_DTP(+)
                      Group By d.codice_dtp) n_sol
               Where u.CODICE_RUOLO = 5
                 And n.CODICE_NOTIFICA = 3
                 And u.CODICE_RUOLO = n.CODICE_RUOLO
                 And u.ID_UTENTE = n.ID_UTENTE
                 And u.CODICE_DTP = n_op.CODICE_DTP
                 And u.CODICE_DTP = n_sol.CODICE_DTP
                 And u.CODICE_TIPO_DEPOSITARIO In (1, 5)
                 And u.AREA <> 'SC'
                 And n_sol.tot_sol + n_op.tot_op > 0
--         UNION
--         SELECT p_Codice_Autorizzazione,                          --RC_RINF_UT
--                u.ID_UTENTE,
--                0,
--                u.CODICE_DTP,
--                u.CODICE_UT,
--                n_op.tot_op TOTALE_SOL,
--                n_sol.tot_sol TOTALE_OP,
--                1 CODICE_STATO_RICHIESTA
--           FROM RINF_SICUREZZA_EVO.V_UTENTE_RUOLO u,
--                (  SELECT CODICE_UT, COUNT (*) tot_op
--                     FROM Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI
--                 GROUP BY codice_ut) n_op,
--                (  SELECT CODICE_UT, COUNT (*) tot_sol
--                     FROM Rinf_Autorizzazioni_Evo.SEZIONI_LINEA
--                 GROUP BY codice_ut) n_sol
--          WHERE     U.CODICE_RUOLO = 5
--                AND U.CODICE_NOTIFICA=6
--                AND u.CODICE_UT = n_op.CODICE_UT
--                AND u.CODICE_UT = n_sol.CODICE_UT
--                AND u.CODICE_TIPO_DEPOSITARIO = 3
           Union
              Select Distinct
                     p_Codice_Autorizzazione,                        --RC_RINF_DTEC
                     u.ID_UTENTE,
                    -- 1, 11/01/2017 Per gestire la molteplicità di Sede Centrale il flag viene sostituito con il codice del tipo depositario
                     u.CODICE_TIPO_DEPOSITARIO ,
                     d.CODICE_DTP,
                     n_sol.tot_sol TOTALE_SOL,
                     n_op.tot_op TOTALE_OP,
                     1 CODICE_STATO_RICHIESTA
                From Rinf_Sicurezza_Evo.V_UTENTE_RUOLO u,
                     Rinf_Sicurezza_Evo.V_UTENTE_NOTIFICHE n,
                (  Select d.CODICE_DTP, Count(o.SEDE_TECNICA) tot_op
                     From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI o,
                          Rinf_Anagrafiche_Evo.ANAG_DTP d
                    Where d.CODICE_DTP <> 'DG00' 
                      And d.CODICE_DTP = o.CODICE_DTP(+)
                 Group By d.codice_dtp) n_op,
                (  Select d.CODICE_DTP, Count(s.SEDE_TECNICA) tot_sol
                     From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA s,
                          Rinf_Anagrafiche_Evo.ANAG_DTP d
                    Where d.CODICE_DTP <> 'DG00' 
                      And d.CODICE_DTP = s.CODICE_DTP(+)
                 Group By d.codice_dtp) n_sol,
                     Rinf_Anagrafiche_Evo.ANAG_DTP d
              Where U.CODICE_RUOLO = 5
                And n.CODICE_NOTIFICA = 3
                And u.CODICE_RUOLO = n.CODICE_RUOLO
                And U.ID_UTENTE = n.ID_UTENTE
                And d.CODICE_DTP = n_op.CODICE_DTP
                And d.CODICE_DTP = n_sol.CODICE_DTP
                And D.CODICE_DTP <>'-1'
               -- And u.CODICE_TIPO_DEPOSITARIO = 2
                And u.AREA = 'SC'
                And n_sol.tot_sol + n_op.tot_op > 0;
  EXCEPTION
      When OTHERS Then
         p_error := SQLCODE;
         Dbms_Output.Put_Line ('SetAuthorizationDetails - Errore: ' || Substr (SQLERRM, 1, 300));
  End SetAuthorizationDetails;
--
-- ----------------------------------------------------------------------------
--                   Procedure SetAuthorizationRequest
-- ----------------------------------------------------------------------------

 Procedure SetAuthorizationRequest (  p_DATA_SCADENZA               Date,
                                      p_NOTE                        Varchar2,
                                      p_CODICE_AUTORIZZAZIONE   Out Number,
                                      p_error                   Out Number  ) Is
   BEGIN
      p_error := 0;

      Select Count(*) Into p_error
      From Rinf_Controllati_Evo.PUNTI_OPERATIVI;

      If p_error > 0 Then

           Select Count(*) Into p_error
           From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI
           where CODICE_STATO_RICHIESTA = 1;

           If p_error = 0 Then

                Select Rinf_Amministrazione_Evo.SQ_CODICE_AUTORIZZAZIONE.Nextval
                  Into p_Codice_Autorizzazione
                  From Dual;

                Insert
                  Into Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI 
                       (  CODICE_RICHIESTA,
                          DATA_RICHIESTA,
                          DATA_SCADENZA,
                          CODICE_STATO_RICHIESTA,
                          NOTE  )
                 Values ( p_Codice_Autorizzazione,
                          SYSDATE,
                          p_DATA_SCADENZA,
                          1,
                          p_NOTE  );

-- 13/02/2018 Inserita la data di riferimento dei dati dell'autorizzazione per una consultazione corretta dei report.
-- Ogni area dati deve avere la sua data di riferimento
                SetDataRiferimento (p_Codice_Autorizzazione, p_error);
--              
                SetSOLClear (p_error);
                SetOPClear  (p_error);
                SetOPAuthorizationSchema  (p_Codice_Autorizzazione, p_error);
                SetSOLAuthorizationSchema (p_Codice_Autorizzazione, p_error);
                SetAuthorizationDetails   (p_Codice_Autorizzazione, p_error);

                If p_error = 0 Then --Ok

-- 10/11/2017 Gestione storicizzazione MDR GIS
                PKG_RINF_GIS_V2.SP_SET_VERSIONE_MDR(3, null, p_error);
--
--      evento scatenante
--      chiamata a Set PostiIt(1)vs amministartore
--      chiamata a Set PostiIt(1)vs validatori
--
                     PKG_RINF_NOTIFICHE.SetPostiIt_V2(1, Null, Null, To_Char(p_DATA_SCADENZA, 'dd/mm/yyyy'));
                End If;
           End If;
      Else
           p_error := -6;
 End If;
   EXCEPTION
      When OTHERS  Then
         p_error := SQLCODE;
         Dbms_Output.Put_Line ('SetAuthorizationRequest - Errore: ' || Substr (SQLERRM, 1, 300));
   End SetAuthorizationRequest;
--
-- ----------------------------------------------------------------------------
--                   Procedure GetAuthorizationReqInfo 
-- ----------------------------------------------------------------------------
   Procedure GetAuthorizationReqInfo (p_Codice_Autorizzazione Varchar2,
                                      p_cursor            Out EMPCUR)  Is
   BEGIN
      Open p_cursor For
         Select CODICE_RICHIESTA,
                DATA_RICHIESTA,
                DATA_SCADENZA,
                NOTE,
                CODICE_STATO_RICHIESTA,
                DATA_CHIUSURA
           From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI a
          Where a.CODICE_RICHIESTA = p_Codice_Autorizzazione;
   EXCEPTION
      When OTHERS  Then
         Dbms_Output.Put_Line ('GetAuthorizationReqInfo - Errore: ' || Substr (SQLERRM, 1, 300));
   End GetAuthorizationReqInfo;
--
-- ----------------------------------------------------------------------------
--                   Procedure GetAllAuthorizationReq
-- ----------------------------------------------------------------------------
   Procedure GetAllAuthorizationReq (p_cursor Out EMPCUR)  Is
   BEGIN
      Open p_cursor For
         Select CODICE_RICHIESTA,
                DATA_RICHIESTA,
                DATA_SCADENZA,
                NOTE,
                CODICE_STATO_RICHIESTA,
                DATA_CHIUSURA
           From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI a;
   EXCEPTION
      When OTHERS  Then
         Dbms_Output.Put_Line ('GetAllAuthorizationReq - Errore: ' || Substr (SQLERRM, 1, 300));
   End GetAllAuthorizationReq;
--
-- ----------------------------------------------------------------------------
--                   Procedure GetAuthorizationDetails
-- ----------------------------------------------------------------------------
   Procedure GetAuthorizationDetails (p_Codice_Autorizzazione Number,
                                      p_cursor            Out EMPCUR)   Is
   BEGIN
      Open p_cursor For
         Select a.CODICE_RICHIESTA,
                U.ID_UTENTE,
                U.CODICE_UTENTE,
                a.FLAG_SEDE_CENTRALE,
                 a.CODICE_DTP,
                 d.DESCRIZIONE DESCRIZIONE_DTP,
                TOTALE_SOL,
                TOTALE_OP,
                a.CODICE_STATO_RICHIESTA,
                a.DATA_AUTORIZZAZIONE,
                S.CODICE_STATO_RICHIESTA CODICE_STATO_RICHIESTA_DTP
           From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI a,
                Rinf_Sicurezza_Evo.ANAG_UTENTE u,
                Rinf_Anagrafiche_Evo.ANAG_DTP d,
                Rinf_Amministrazione_Evo.V_STATO_RICHIESTE s
          Where s.CODICE_RICHIESTA = a.CODICE_RICHIESTA
            And S.CODICE_DTP = a.CODICE_DTP
            And s.FLAG_SEDE_CENTRALE = a.FLAG_SEDE_CENTRALE
            And a.CODICE_RICHIESTA = p_Codice_Autorizzazione
            And a.CODICE_DTP = d.CODICE_DTP
            And a.ID_UTENTE = u.ID_UTENTE
        Union
         Select p_Codice_Autorizzazione,
                u.ID_UTENTE,
                u.CODICE_UTENTE,
                s.FLAG_SEDE_CENTRALE,
                u.CODICE_DTP,
                d.DESCRIZIONE DESCRIZIONE_DTP,
                0 TOTALE_SOL,
                0 TOTALE_OP,
                1 CODICE_STATO_RICHIESTA,
                null DATA_AUTORIZZAZIONE,
                s.CODICE_STATO_RICHIESTA CODICE_STATO_RICHIESTA_DTP
           From Rinf_Sicurezza_Evo.V_UTENTE_RUOLO u,
                Rinf_Amministrazione_Evo.V_STATO_RICHIESTE s,
                Rinf_Anagrafiche_Evo.ANAG_DTP d
          where codice_ruolo = 5
          --AND u.CODICE_TIPO_DEPOSITARIO <> 2 Sede Centrale Multipla
            And u.AREA <> 'SC'
            And s.CODICE_RICHIESTA = p_Codice_Autorizzazione
            And s.CODICE_DTP = u.CODICE_DTP
            And d.CODICE_DTP = u.CODICE_DTP
            And s.FLAG_SEDE_CENTRALE = 0
            And u.ID_UTENTE In
              (  Select ID_UTENTE
                   from Rinf_Sicurezza_Evo.ANAG_UTENTE
                 Minus
                 Select ID_UTENTE
                   from Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI
                  Where FLAG_SEDE_CENTRALE = 0
                    And CODICE_RICHIESTA = p_Codice_Autorizzazione )
               Union
                 Select p_Codice_Autorizzazione,
                        u.ID_UTENTE,
                        u.CODICE_UTENTE,
                        s.FLAG_SEDE_CENTRALE,
                        d.CODICE_DTP,
                        d.DESCRIZIONE DESCRIZIONE_DTP,
                        0 TOTALE_SOL,
                        0 TOTALE_OP,
                        1 CODICE_STATO_RICHIESTA,
                        Null DATA_AUTORIZZAZIONE,
                        s.CODICE_STATO_RICHIESTA CODICE_STATO_RICHIESTA_DTP
                   from Rinf_Sicurezza_Evo.V_UTENTE_RUOLO u,
                        Rinf_Amministrazione_Evo.V_STATO_RICHIESTE s,
                        Rinf_Anagrafiche_Evo.ANAG_DTP d
                  where CODICE_RUOLO = 5
--                  And u.CODICE_TIPO_DEPOSITARIO=2 Sede Centrale multipla
                    And u.AREA='SC'
                    And s.CODICE_RICHIESTA = p_Codice_Autorizzazione
                    And s.CODICE_DTP = d.CODICE_DTP
                    And s.FLAG_SEDE_CENTRALE <> 0
                    And u.ID_UTENTE In
                      (  Select ID_UTENTE
                           From RINF_SICUREZZA_EVO.ANAG_UTENTE
                        Minus
                         Select ID_UTENTE
                           From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI
                          Where          -- FLAG_SEDE_CENTRALE=1 Sede Centrale multipla
                                FLAG_SEDE_CENTRALE <> 0
                            And CODICE_RICHIESTA = p_Codice_Autorizzazione 
					   );
   EXCEPTION
      When OTHERS  Then
         Dbms_Output.Put_Line ('GetAuthorizationDetails - Errore: ' || Substr (SQLERRM, 1, 300));
   End GetAuthorizationDetails;
--
-- ----------------------------------------------------------------------------
--                   Procedure GetAuthorizationMails
-- ----------------------------------------------------------------------------
   Procedure GetAuthorizationMails (p_Codice_Autorizzazione Varchar2,
                                    p_cursor            Out EMPCUR)   Is
   BEGIN
      Open p_cursor For
         Select Distinct U.ID_UTENTE, U.CODICE_UTENTE, U.E_MAIL
           From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI a,
                Rinf_Sicurezza_Evo.V_UTENTE_NOTIFICHE u
          Where a.ID_UTENTE = u.ID_UTENTE
            And u.CODICE_NOTIFICA = 6
            And FLAG_MAIL = 1
            And U.E_MAIL Is Not Null
            And a.CODICE_RICHIESTA = p_Codice_Autorizzazione;
   EXCEPTION
      When OTHERS  Then
         Dbms_Output.Put_Line ('GetAuthorizationMails - Errore: ' || Substr (SQLERRM, 1, 300));
   End GetAuthorizationMails;
--
-- ----------------------------------------------------------------------------
--                   Procedure SetAuthorizeMyData_old
-- ----------------------------------------------------------------------------
  Procedure SetAuthorizeMyData_old ( p_Codice_Utente         Varchar2, 
                                     p_codice_dtp            Varchar2, 
								     p_Codice_Autorizzazione Varchar2, 
								     p_is_sede_centrale      Number,
                                     p_error             Out Number ) Is
    Type dtp_t  Is Record (id_dtp Varchar2(10));
    Type l_dtp  Is Table Of dtp_t;
       a_dtp  l_dtp;
  BEGIN
    p_error := 0;
    With test As
       ( Select p_codice_dtp Str From dual )
         Select regexp_substr (Str, '[^;]+', 1, Rownum) split
           Bulk Collect Into a_dtp
           From test
          Connect By Level <= Length (regexp_replace (Str, '[^;]+')) + 1;

     Forall j In 1..a_dtp.Count

         UPDATE Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI a
            Set CODICE_STATO_RICHIESTA = 2,
                DATA_AUTORIZZAZIONE = Sysdate
          Where a.CODICE_RICHIESTA = p_Codice_Autorizzazione  
		    And a.CODICE_DTP = a_dtp(j).id_dtp 
			And a.FLAG_SEDE_CENTRALE = p_is_sede_centrale  
			And a.ID_UTENTE = PKG_RINF_SICUREZZA.GetUserID(p_Codice_Utente);
   EXCEPTION
      When OTHERS  Then
         p_error := SQLCODE;
         Dbms_Output.Put_Line ('SetAuthorizeMyData_old - Errore: ' || Substr (SQLERRM, 1, 300));
  End SetAuthorizeMyData_old;
--
-- ----------------------------------------------------------------------------
--                   Procedure SetAuthorizeMyData
-- ----------------------------------------------------------------------------
  Procedure SetAuthorizeMyData ( p_Codice_Utente         Varchar2, 
                                 p_codice_dtp            Varchar2, 
								 p_Codice_Autorizzazione Varchar2, 
								 p_is_sede_centrale      Number,
                                 p_error             Out Number  )  Is
    CURSOR c_dtp Is
           With test As
          (Select p_codice_dtp Str From Dual )
           Select regexp_substr (Str, '[^;]+', 1, Rownum) id_dtp
             From test
             Connect By Level <= Length (regexp_replace (Str, '[^;]+')) + 1;
--
     l_dtp       c_dtp%ROWTYPE;
     n_utente    Number;
  BEGIN

    p_error := 0;

    Open c_dtp;
      Loop
        Fetch c_dtp Into l_dtp;
        Exit WheN c_dtp%NOTFOUND;
--
            Select Count(*) Into n_utente 
			  From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI a
             Where a.CODICE_RICHIESTA = p_Codice_Autorizzazione  
			   And a.CODICE_DTP = l_dtp.id_dtp 
			   And a.FLAG_SEDE_CENTRALE = p_is_sede_centrale  
			   And a.ID_UTENTE = PKG_RINF_SICUREZZA.GetUserID(p_Codice_Utente);
--
             If n_utente >0 Then
                     Update Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI a
                        Set CODICE_STATO_RICHIESTA = 2,
                            DATA_AUTORIZZAZIONE = Sysdate
                      Where a.CODICE_RICHIESTA = p_Codice_Autorizzazione  
					    And a.CODICE_DTP = l_dtp.id_dtp 
						And a.FLAG_SEDE_CENTRALE = p_is_sede_centrale  
						And a.ID_UTENTE = PKG_RINF_SICUREZZA.GetUserID(p_Codice_Utente);
             Else
                     Insert Into Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI
                          (CODICE_RICHIESTA, ID_UTENTE, FLAG_SEDE_CENTRALE, CODICE_DTP,
                           TOTALE_SOL, TOTALE_OP, CODICE_STATO_RICHIESTA, DATA_AUTORIZZAZIONE)
                     Values ( p_Codice_Autorizzazione,PKG_RINF_SICUREZZA.GetUserID(p_Codice_Utente),
                              p_is_sede_centrale,l_dtp.id_dtp, Null, Null, 2, Sysdate );
            End If;
           --null;
           --evento cancellante
           --chiamata a Set PostiIt(10) vs validatore (dtp)
           PKG_RINF_NOTIFICHE.SETPOSTIIT_V2(2, l_dtp.id_dtp, Null, Null);
     End Loop;
--
   EXCEPTION
      When OTHERS  Then
         p_error := SQLCODE;
         Dbms_Output.Put_Line ('SetAuthorizeMyData - Errore: ' || Substr (SQLERRM, 1, 300));
 End SetAuthorizeMyData;
--
-- ----------------------------------------------------------------------------
--                   Procedure SetDeclareReadyRI
-- ----------------------------------------------------------------------------
  Procedure SetDeclareReadyRI ( p_Codice_Autorizzazione Varchar2,
                                p_NOTA                  Varchar2,
  							    p_versione          Out Number,
                                p_error             Out Number  )  Is
    n_stato   Number;
    n_data    Number;
  BEGIN
-- 24/02/2016 Inserito parametro di Output della vesione per gestire correttamente l'invio della mail dopo che un registro è stato dichiarato pronto
    p_error := 0;

-- Verifico che tutti abbiano autorizzato
    Select Count(*) Into n_stato
      From Rinf_Amministrazione_Evo.V_STATO_RICHIESTE
     Where CODICE_RICHIESTA = p_Codice_Autorizzazione
       And CODICE_STATO_RICHIESTA <> 2;
--
    Dbms_Output.Put_Line ('Autorizzazioni aperte: ' || n_stato);
 -- se non tutti hanno autorizzato, controllo la data di scadenza
 -- se la data odierna è minore della data di scadenza

    Select To_Number(DATA_SCADENZA - To_Date(To_Char(Sysdate,'DDMMYYY'),'DDMMYYY')) Into n_data
      From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI
     Where CODICE_RICHIESTA = p_Codice_Autorizzazione;
--
    Dbms_Output.Put_Line ('Data Scadenza: ' || n_data);

    If n_stato > 0 And n_data > 0 Then
        p_error := -9;
    Elsif n_stato = 0 Or (n_stato > 0 And n_data <= 0)  Then --se la data di scadenza  è successiva alla data odierna non è possibile dichiarare pronto il RI
--
--    --verifica che la Sede Centrale abbia autorizzato i dati
--    Select NVL(MAX(CODICE_STATO_RICHIESTA),2) into n_stato
--    from
--    RINF_AMMINISTRAZIONE_EVO.V_STATO_RICHIESTE
--    WHERE    CODICE_RICHIESTA = p_Codice_Autorizzazione
--    AND CODICE_DTP='-1';
--DBMS_OutPUT.PUT_LINE ('sede centrale ' || n_stato);
--        IF n_stato=2 THEN --i dati di Sc sono stati autorizzati
--
        Update Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI a
           Set CODICE_STATO_RICHIESTA = 2,
               DATA_CHIUSURA = Sysdate,
               NOTE = Nvl(p_nota, NOTE)
         Where a.CODICE_RICHIESTA = p_Codice_Autorizzazione;
--
        PKG_RINF_PUBBLICAZIONE.SetNewRinfVersion(p_Codice_Autorizzazione, p_error);
        If p_error <> 0 Then
             Rollback;
        Else
--
--  evento cancellante
--  chiamata a Set PostiIt(11) vs amministratore
--  chiamata a Set PostiIt(11) vs tutti i validatori
         Select Max(CODICE_VERSIONE) Into p_versione From Rinf_Pubblicati_Evo.VERSIONE_RINF;
--
--  10/11/2017 Gestione storicizzazione MDR GIS
             PKG_RINF_GIS_V2.SP_SET_VERSIONE_MDR(4, p_versione,p_error);

             PKG_RINF_NOTIFICHE.SETPOSTIIT_V2(3, Null, p_versione, Null);

        End If;

     End IF;
   EXCEPTION
      When OTHERS  Then
         p_error := SQLCODE;
         Dbms_Output.Put_Line ('SetDeclareReadyRI - Errore: ' || Substr (SQLERRM, 1, 300));
End SetDeclareReadyRI;
--
-- ----------------------------------------------------------------------------
--                   Procedure GetAuthorizationStatus
-- ----------------------------------------------------------------------------
  Procedure GetAuthorizationStatus (p_Codice_Autorizzazione Varchar2,
                                    p_cursor            Out EMPCUR)  Is
  BEGIN
    Open p_cursor For  
	     Select
             CODICE_RICHIESTA,
             DATA_SCADENZA,
             CODICE_DTP,
             DESCRIZIONE_DTP,
             CODICE_STATO_RICHIESTA,
             DATA_AUTORIZZAZIONE
        From Rinf_Amministrazione_Evo.V_STATO_RICHIESTE
       Where CODICE_RICHIESTA = p_Codice_Autorizzazione;
--
   EXCEPTION
      When OTHERS  Then
         Dbms_Output.Put_Line ('GetAuthorizationStatus - Errore: ' || Substr (SQLERRM, 1, 300));
End GetAuthorizationStatus;
--
-- ----------------------------------------------------------------------------
--                   Procedure GetUserParameters
-- ----------------------------------------------------------------------------
  Procedure GetUserParameters (p_codice_dtp  Varchar2,
                               p_cursor  Out EMPCUR)   Is
    sqlstringa Varchar2(30000);
  BEGIN
    sqlstringa := 'Select NUMERO_PARAMETRO From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI c ';
--
    If p_codice_dtp = '-1' Then
         sqlstringa := sqlstringa||'  Where c.CODICE_TIPO_DEPOSITARIO = 2';
    Else
         sqlstringa := sqlstringa||'  Where c.CODICE_TIPO_DEPOSITARIO <> 2';
    End If;
--
    Open p_cursor For sqlstringa;
--
   EXCEPTION
      When OTHERS  Then
         Dbms_Output.Put_Line ('GetUserParameters - Errore: ' || Substr (SQLERRM, 1, 300));
End GetUserParameters;
--
-- ----------------------------------------------------------------------------
--                   Procedure GetSCParameters
-- ----------------------------------------------------------------------------
  Procedure GetSCParameters ( p_codice_dtp Varchar2, 
                              p_tipo_dep   Number, 
  						      p_cursor Out EMPCUR  )   Is
    sqlstringa Varchar2(32000);
--
    CURSOR p_cur Is
           Select CODICE_PARAMETRO, 
		          NUMERO_PARAMETRO_MULTIPLO, 
				  Replace(DESCRIZIONE,'''', '''''') desc_parametro, 
				  NOME_TABELLA nome_tab,
                  NOME_COLONNA nome_col, 
				  STRINGA_JOIN str_join
             From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
            Where CODICE_TIPO_DEPOSITARIO = NVL(p_tipo_dep, 2) --11/06/2018 inserito NVL perchè non funziona il Default del parametro
              And STRINGA_JOIN Is Not Null;
--
   sc_par_l p_cur%ROWTYPE;
-- -----
  BEGIN
    sqlstringa := '';
--
    Open p_cur;
      Loop
        Fetch p_cur Into sc_par_l;
          Exit When p_cur%NOTFOUND;

            sqlstringa := sqlstringa||' Select b.CODICE_DTP, b.SEDE_TECNICA, b.DEFINIZIONE DESC_SEDE_TECNICA, '''||sc_par_l.numero_parametro_multiplo||''' numero_parametro,';
            sqlstringa := sqlstringa||' '''||sc_par_l.desc_parametro||''' desc_parametro,';
            sqlstringa := sqlstringa||' To_Char('||sc_par_l.nome_col||') valore_parametro ';
            sqlstringa := sqlstringa||' '||sc_par_l.str_join||''''||p_codice_dtp||''' ';
            sqlstringa := sqlstringa||' Union ';

      End Loop;

    --tolgo l'ultima UNION
     sqlstringa := substr(sqlstringa, 1, length( sqlstringa) -7);
--
     Dbms_Output.Put_Line (sqlstringa);
--
     Open p_cursor For sqlstringa;
--
   EXCEPTION
      When OTHERS  Then
         Dbms_Output.Put_Line ('GetSCParameters - Errore: ' || Substr (SQLERRM, 1, 300));
 End GetSCParameters;
--
-- ----------------------------------------------------------------------------
End PKG_RINF_AUTORIZZAZIONI;
/