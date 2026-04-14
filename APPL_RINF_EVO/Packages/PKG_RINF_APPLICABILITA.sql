--
-- PKG_RINF_APPLICABILITA  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_APPLICABILITA" Is
 Type empcur Is Ref CURSOR;
 Function GetAP_1_1_1_1_2_3 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_1_2_1_2 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_1_2_4_2 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_1_2_4_3 (p_value Varchar2) Return Varchar2 ;
 Function GetAP_1_1_1_1_3_1_2  Return Varchar2;
 Function GetAP_1_1_1_1_3_1_3  Return Varchar2;
 Function GetAP_1_1_1_1_3_2 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_1_3_3 (p_value_padre_1 Varchar2, p_value_padre_2 Varchar2) Return Varchar2;
 Function GetAP_1_1_1_1_4_4 (p_value_padre Number)  Return Varchar2;
 Function GetAP_1_1_1_1_6_4  Return Varchar2;
 Function GetAP_1_1_1_1_6_5  Return Varchar2;
 Function GetAP_1_1_1_1_7_5 (p_value_padre Varchar2)   Return Varchar2;
 Function GetAP_1_1_1_1_7_6 (p_value_padre Varchar2)   Return Varchar2;
 Function GetAP_1_1_1_1_7_7 (p_value_padre Varchar2)   Return Varchar2;
 Function GetAP_1_1_1_1_7_8 (p_value_padre Varchar2)   Return Varchar2; -- NUOVO 
 Function GetAP_1_1_1_1_7_9 (p_value_padre Varchar2)   Return Varchar2; -- NUOVO 
 Function GetAP_1_1_1_1_7_10  Return Varchar2;
 Function GetAP_1_1_1_1_7_11  Return Varchar2;
 Function GetAP_1_1_1_1_8_8 (p_value_padre Number)  Return Varchar2;
 Function GetAP_1_1_1_1_8_8_1 (p_value_padre Number)  Return Varchar2;
 Function GetAP_1_1_1_1_8_8_2  Return Varchar2;
 Function GetAP_1_1_1_1_8_9  (p_value_padre Number) Return Varchar2;
 Function GetAP_1_1_1_1_8_10 (p_value_padre Number) Return Varchar2;
 Function GetAP_1_1_1_1_8_11 (p_value_padre_1 Number, p_value_padre_2 Varchar2) Return Varchar2;
--
 Function GetAP_1_1_1_2_2_1_2 (p_value_padre Varchar2) Return Varchar2;
 Function GETAP_1_1_1_2_2_1_2_1 (p_value_padre Varchar2) Return Varchar2;
-- Function GetAP_1_1_1_2_2_1_1 (p_value_figlio Varchar2) Return Varchar2;
 Function GetAP_1_1_1_2_2_1_3  Return Varchar2;
 Function GetAP_1_1_1_2_2_2 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_2_2_3 (p_value_padre_1 Varchar2, p_value_padre_2 Varchar2) Return Varchar2;
 Function GetAP_1_1_1_2_2_4 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_2_2_5 (p_value_padre Varchar2)   Return Varchar2;
 Function GetAP_1_1_1_2_2_6 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_2_3_1 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_2_3_2 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_2_3_3 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_2_3_4 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_2_4_1_1 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_2_4_1_2 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_2_4_2_1 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_2_4_2_2 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_2_4_3  Return Varchar2 ;
 Function GetAP_1_1_1_2_5_1 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_2_5_2 (p_value_padre Varchar2)   Return Varchar2;
 Function GetAP_1_1_1_2_5_3 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_2_2 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_2_3 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_2_4 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_3_2_5 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_3_2_6 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_3_2_7 (p_value_padre Varchar2) Return Varchar2;           -- cancellato
 Function GetAP_1_1_1_3_2_8 (p_value_padre Varchar2) Return Varchar2;           -- Nuovo
 Function GetAP_1_1_1_3_2_9 (p_value_padre Varchar2) Return Varchar2;           -- Nuovo
 Function GetAP_1_1_1_3_2_10 (p_value_padre Varchar2) Return Varchar2;  
 Function GetAP_1_1_1_3_3_1  Return Varchar2;
 Function GetAP_1_1_1_3_3_2 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_3_3 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_3_3_1 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_3_3_2 (p_value_padre_1 Varchar2, p_value_padre_2 Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_3_3_3   Return Varchar2;
 Function GetAP_1_1_1_3_3_4 (p_value_padre Varchar2) Return Varchar2; -- Nuovo
 Function GetAP_1_1_1_3_3_5 (p_value_padre Varchar2) Return Varchar2; -- Nuovo
 Function GetAP_1_1_1_3_3_6 (p_value_padre Varchar2) Return Varchar2; -- Nuovo
 Function GetAP_1_1_1_3_3_7 (p_value_padre_1 Varchar2, p_value_padre_2 Varchar2) Return Varchar2; -- Nuovo
 Function GetAP_1_1_1_3_3_8 (p_value_padre Varchar2) Return Varchar2; -- Nuovo
 Function GetAP_1_1_1_3_3_9 (p_value_padre Varchar2) Return Varchar2; -- Nuovo
 Function GetAP_1_1_1_3_3_10 (p_value_padre Varchar2) Return Varchar2; -- Nuovo
-- Function GetAP_1_1_1_3_5_1 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_3_5_2 (p_value_padre Varchar2)  Return Varchar2;
-- Function GetAP_1_1_1_3_6_1 (p_value_padre Varchar2)  Return Varchar2; --AP FITTIZIA (AG 21/05/2015)
 Function GetAP_1_1_1_3_7_3 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_4 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_6 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_7 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_8 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_9 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_1_1 (p_value_figlio Varchar2) Return Varchar2; -- Nuovo
 Function GetAP_1_1_1_3_7_1_2 (p_value_padre Varchar2, p_value_figlio Varchar2) Return Varchar2;        -- Nuovo
 Function GetAP_1_1_1_3_7_1_3 (p_value_padre Varchar2) Return Varchar2; -- Nuovo
 Function GetAP_1_1_1_3_7_1_4  Return Varchar2; -- Nuovo
 Function GetAP_1_1_1_3_7_2_1 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_3_7_2_2 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_1_7_3 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_5 (p_value_padre Varchar2)  Return Varchar2;
 Function GetAP_1_1_1_3_7_10 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_11 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_11_1 (p_value_padre Varchar2) Return Varchar2; -- Nuovo
 Function GetAP_1_1_1_3_7_12 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_13 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_14 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_15_1 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_15_2 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_16 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_17 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_18 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_19 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_20 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_21 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_22 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_7_23 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_9_1  (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_9_2  (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_10_1 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_10_2 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_11_1    Return Varchar2;
 Function GetAP_1_1_1_3_11_2    Return Varchar2;
 Function GetAP_1_1_1_3_11_3 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_3_12_1 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_1_1_4_1       Return Varchar2;
 Function GetAP_1_1_1_4_2    (p_value_padre Varchar2)  Return Varchar2;
--
 Function GetAP_1_2_1_0_2_3 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_2_1_0_3_2 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_2_1_0_3_3 (p_value_padre_1 Varchar2, p_value_padre_2 Varchar2)   Return Varchar2;
 Function GetAP_1_2_1_0_3_5     Return Varchar2;
 Function GetAP_1_2_1_0_3_6     Return Varchar2;
 Function GetAP_1_2_1_0_5_6 (p_value_padre Number) Return Varchar2;
 Function GetAP_1_2_1_0_5_7 (p_value_padre Number) Return Varchar2;
 Function GetAP_1_2_1_0_5_8 (p_value_padre_1 Number, p_value_padre_2 Varchar2)  Return Varchar2;
 Function GetAP_1_2_1_0_5_9 (p_value_padre Varchar2) Return Varchar2;
 Function GetAP_1_2_2_0_3_3 (p_value_concava Number, p_value_convessa Number) Return Varchar2;
 Function GetAP_1_2_2_0_5_6 (p_value_padre Number) Return Varchar2;
 Function GetAP_1_2_2_0_5_7 (p_value_padre Number)  Return Varchar2;
 Function GetAP_1_2_2_0_5_8 (p_value_padre_1 Number, p_value_padre_2 Varchar2)  Return Varchar2;
 Function GetAP_1_2_2_0_6_1 (p_value_figlio Number)  Return Varchar2;
-- Function GetAP_1_2_0_0_0_4_1 (p_value_padre Varchar2, p_value_figlio Varchar2)  Return Varchar2;
 Function GetAP_1_2_0_0_0_4_1 (p_value_figlio Varchar2)  Return Varchar2;
 Function GetAP_1_2_3_1  (p_value_figlio Varchar2) Return Varchar2; -- nuovo
 Function GetAP_1_2_3_2 (p_value_padre Varchar2)      Return Varchar2; -- nuovo
End;
/


--
-- PKG_RINF_APPLICABILITA  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_APPLICABILITA" Is

-- ======================================================================================
/*
-- --------------------------------------------------------------------------------------
-- Reg. 2019/777 - Parametri che per RFI sono sempre NON APPLICABILI
-- --------------------------------------------------------------------------------------
1.1.1.1.3.1.2 Localizzazione ferroviaria di punti particolari che richiedono verifiche specifiche - 258
1.1.1.1.3.1.3 Documento che riporta la sezione trasversale di punti particolari che richiedono verifiche specifiche - 260
1.1.1.1.6.4 Documento riportante le condizioni per l'utilizzo di freni a correnti parassite - 264
1.1.1.1.6.5 Documento riportante le condizioni per l'utilizzo di freni magnetici - 266
1.1.1.1.8.8.2 Documento messo a disposizione dal GI contenente la descrizione esatta della galleria - 286
1.1.1.2.2.1.3 Umax2 per linee di cui al punto 7.4.2.2.1 del regolamento (UE) n. 1301/2014 - 290
1.1.1.2.4.3 Distanza tra il pannello e la fine della separazione di fase - 292
1.1.1.3.3.3.3 Zona di implementazione del GPRS - 304
1.1.1.3.7.1.4 Sezione con limitazione di rilevamento del treno - 328  (nel dominio ci sono Y/N)
--> (880) 1.1.1.3.7.2.2 Distanza massima consentita tra due assi consecutivi in caso di non conformità alla STI - 112
--> (880) 1.1.1.3.7.13 Conformità alla STI delle norme sulla costruzione metallica del veicolo -101  (nel dominio ci sono 3 valori tra cui NA)
--> (880) 1.1.1.3.7.15.2 Massima impedenza consentita tra ruote opposte di una sala montata in caso di non conformità alla STI - 104
1.2.1.0.3.5 Localizzazione ferroviaria di punti particolari che richiedono verifiche specifiche - 345, 346
1.2.1.0.3.6 Documento che riporta la sezione trasversale di punti particolari che richiedono verifiche specifiche - 348
1.2.1.0.5.9 Trazione diesel o altri sistemi di trazione termica consentiti  -350         -- da approfondire meglio con RFI - 

Parametri che in RFI devono essere sempre valorizzati con un unico valore (Applicabilità = Y)
-----------------------------------------------------------------------
1.1.1.1.2.4.4 (IPP_StructureCheckDocRef) = [RFI DTC SI MA IFS 001 D-II-2] - 253 (dominio OK)
1.1.1.3.6.1 (CRS_Installed) = [GSM-P] - 96 (manca _AP nel catalogo) (Ci sono tre valori nel Dominio, Y/N e GSM-P)
1.1.1.3.11.2 (CBP_AddInfoAvailable) = [S] - 332 (ci sono due valori nel domio Y/N)
1.1.1.3.11.3	(CBP_BrakePerfDocRef) = [PGOS - IF] -334


-- 1.1	Parameter groups hierarchy
-- The list below indicates the hierarchy of main parameter groups and subgroups. The network of each Member State is described in Ops and SoLs. 
-- A Sol is composed of one or several running tracks while an OP can have running track(s) and/or siding(s). 
-- Specific parameters must be fulfilled depending if the RINF element is a SoL or an OP.
-- The RINF parameters are organised as follows:
*/
-- ======================================================================================
-- 1.	MEMBER STATE – STATO MEMBRO
-- 1.1	SECTION OF LINE – SEZIONE DI LINEA
-- 1.1.0.0.0	Generic information – Informazioni Generali
-- 1.1.0.0.0.1	SOLIMCode / IM’s Code – Codice del gestore dell'infrastruttura (GI) - AP=Y
-- 1.1.0.0.0.2	SOLLineIdentification / National line identification - Identificazione nazionale della linea - AP=Y 
-- 1.1.0.0.0.3	SOLOPStart / Operational Point at start of Section of Line - Punto operativo all'inizio della sezione di linea - AP=Y
-- 1.1.0.0.0.4	SOLOPEnd / Operational Point at end of Section of Line - Punto operativo alla fine della sezione di linea - AP=Y
-- 1.1.0.0.0.5	SOLLength / Length of section of line - Lunghezza della sezione di linea - AP=Y
-- 1.1.0.0.0.6	SOLNature / Nature of Section of Line - Carattere della sezione di linea - AP=Y
--
-- ======================================================================================
-- 1.1.1	SOLTrack / RUNNING TRACK - BINARIO DI CIRCOLAZIONE
-- --------------------------------------------------------------------------------------
-- 1.1.1.0.0	Generic information - Informazioni generali
-- --------------------------------------------------------------------------------------
-- 1.1.1.0.0.1	SOLTrackIdentification / Identification of track - Identificazione del binario - AP=Y
-- 1.1.1.0.0.2	SOLTrackDirection / Normal running direction - Direzione di marcia normale - AP=Y
--
-- ======================================================================================
-- 1.1.1.1	Infrastructure subsystem - Sottosistema «infrastruttura»
--          Parameters below until 1.1.1.2 belong to the group of infrastructure parameters
-- 1.1.1.1.1 IDE / Declarations of verification for track - Dichiarazioni di verifica del binario
-- 1.1.1.1.1.1	IDE_ECVerification / EC declaration of verification for track (INF) - Dichiarazione CE di verifica del binario
-- 1.1.1.1.1.2	IDE_EIDemonstration / EI declaration of demonstration for track (INF) -           Dichiarazione di dimostrazione IE
-- ======================================================================================
-- 1.1.1.1.2	IPP / Performance parameters - Parametri di prestazione
-- --------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.2.1 - IPP_TENClass / TEN classification of track - Classificazione TEN (rete transeuropea) del binario - AP=Y 
-- --------------------------------------------------------------------------------------
--  1.1.1.1.2.1.2 - IPP_TENGISID / TEN GIS identity - Identità del sistema informativo geografico (GIS ID) TEN
-- (NUOVO) - Il parametro 1.1.1.1.2.1.2 è applicabile solo se il parametro 1.1.1.1.2.1 è diverso da Off-TEN
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_2_1_2 (p_value_padre Varchar2)          
   Return Varchar2 Is
  Begin
    If p_value_padre <> 40 Then --'Off-TEN' 
       Return 'Y';
    Else
       Return 'N';
    End If;
  End GetAP_1_1_1_1_2_1_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.2.2 - IPP_LineCat / Category of line - Categoria della linea - AP=Y 
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.2.3 - IPP_FreightCorridor / Part of a Railway freight corridor - 
-- Parte di un corridoio ferroviario merci (RFC — Rail Freight Corridor)
-- è applicabile se il binario è inserito in un Corridoio Ferroviario Merci.
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_1_2_3 (p_value_padre Varchar2)     --APPLICABILITA' CORRIDOIO MERCI
   Return Varchar2 Is
   n_conta Number;
 Begin
--
     Select Count(CODICEGIURISDIZIONE) Into n_conta
         From Rinf_Staging_Evo.PIC_CORRIDOIOMERCI_TRATTA l,
              Rinf_Staging_Evo.PIC_PERCORSIINFR t
         where l.CODICETRATTA = t.CODICETRATTA 
		   And t.CODICETRATTAIR2K = p_value_padre 
		   And Nvl(t.DATAINIZIOVALIDITA, To_Date('01011999','DDMMYYYY')) <= SysDate 
		   And Nvl(t.DATAFINEVALIDITA, To_Date('01012999','DDMMYYYY')) >= SysDate;
--
     If n_conta > 0  Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_1_2_3;
--
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.2.4 - IPP_LoadCap / Load Capability - Capacità di carico - AP=Y
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.2.4.1 - IPP_NCLoadCap /National classification for load capability - Classificazione nazionale della capacità di carico (NUOVO) - AP=Y
-- --------------------------------------------------------------------------------------
-- Il parametro 1.1.1.1.2.4.2 è applicabile quando la velocità è maggiore di 200 km/h, 
-- ovvero quando il parametro 1.1.1.1.2.5 – velocità massima consentita > 200 km/h. (NUOVO)
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_2_4_2 (p_value_padre Varchar2)      --APPLICABILITA' Conformità delle strutture al modello di carico ad alta velocità
     Return Varchar2 Is
  Begin
 --   If p_value_padre >= 200 Then  -- modifica del 11/01/2021 compresa nella Fase 4
    If p_value_padre > 200 Then
       Return 'Y';
    Else
       Return 'N';
    End If;
  End GetAP_1_1_1_1_2_4_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.2.4.3 - IPP_StructureCheckLoc/Railway location of structures requiring specific checks - 
-- (NUOVO) Localizzazione ferroviaria di strutture che richiedono verifiche specifiche (MULTIPLA)
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_2_4_3 (p_value Varchar2)
     Return Varchar2 Is
  Begin
   If p_value Is Null Or p_value = 9999.999 Then
       Return 'N';
    Else
       Return 'Y';
    End If;
  End GetAP_1_1_1_1_2_4_3;
-- --------------------------------------------------------------------------------------
-- Parametri che in RFI devono essere sempre valorizzati con un unico valore (Applicabilità = Y)
-- 1.1.1.1.2.4.4 (IPP_StructureCheckDocRef) = [RFI DTC SI MA IFS 001 D-II-2] - 253 (dominio OK)
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_2_4_4 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'Y';
  End GetAP_1_1_1_1_2_4_4;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.2.5 - IPP_MaxSpeed / Maximum permitted speed - Velocità massima consentita - AP=Y
-- 1.1.1.1.2.6 - IPP_TempRange / Temperature range - Campo di temperatura - AP=Y
-- 1.1.1.1.2.7 - IPP_MaxAltitude / Maximum altitude - Altitudine massima - AP=Y
-- 1.1.1.1.2.8 - IPP_SevereClimateCon / Existence of severe climatic conditions - (MODIFICATO)  Esistenza di condizioni climatiche estreme - AP=Y
--
-- ======================================================================================
-- 1.1.1.1.3	ILL/ Line layout - Tracciato della linea
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.3.1 - ILL_InteropGauge / Interoperable gauge - Sagoma interoperabile (CANCELLATO)
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.3.2 - ILL_MultiNatGauge / Multinational gauges - Sagome multinazionali (CANCELLATO)
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_1_3_2 (p_value_padre Varchar2)          --R16000_TR_0140 appare se R16000_TR_0130 = none
   Return Varchar2 Is
 Begin
     If p_value_padre = 'NONE'  Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_1_3_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.3.3 - ILL_NatGauge / National gauges - Sagome nazionali (CANCELLATO)
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_1_3_3 (p_value_padre_1 Varchar2, p_value_padre_2 Varchar2)      --R16000_TR_0150 appare se R16000_TR_0130 = none   R16000_TR_0140 = none
   Return Varchar2 Is
 Begin
     If p_value_padre_1 = 'NONE' And p_value_padre_2 = 'NONE'   Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_1_3_3;
 -- --------------------------------------------------------------------------------------
-- 1.1.1.1.3.1.1 - ILL_Gauging_/ Gauging - Sagoma (NUOVO) - AP=Y
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.3.1.2 - ILL_GaugeCheckLoc/Railway location of particular points requiring specific checks 
-- (NUOVO) Localizzazione ferroviaria di punti particolari che richiedono verifiche specifiche - AP=N
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_3_1_2 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'N';
  End GetAP_1_1_1_1_3_1_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.3.1.3 - ILL_GaugeCheckDocRef /Document with the transversal section of the particular points requiring specific checks
-- (NUOVO) Documento che riporta la sezione trasversale di punti particolari che richiedono verifiche specifiche AP=N
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_3_1_3 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'N';
  End GetAP_1_1_1_1_3_1_3; 
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.3.4 - ILL_ProfileNumSwapBodies / Standard combined transport profile number for swap bodies 
--               Numero standard del profilo di trasporto combinato per le casse mobili - PAR_1_1_1_1_3_4_PROF_CAS_M - GetAPMultipla
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_1_3_4 (p_value_padre NUMBER)      --R16000_TR_0230 Appare se 1.1.1.1.2.1<> [Off-TEN]
   Return Varchar2 Is
 Begin
    If p_value_padre <> 40 Then --'Off-TEN' 
       Return 'Y';
    Else
       Return 'N';
    End If;
 End GetAP_1_1_1_1_3_4;
-- --------------------------------------------------------------------------------------

-- 1.1.1.1.3.5 - ILL_ProfileNumSemiTrailers / Standard combined transport profile number for semi-trailers 
--               Numero standard del profilo di trasporto combinato per i semi rimorchi - PAR_1_1_1_1_3_5_PROF_SEMI_R - GetAPMultipla
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_1_3_5 (p_value_padre NUMBER)      --R16000_TR_0230 Appare se 1.1.1.1.2.1<> [Off-TEN]
   Return Varchar2 Is
 Begin
    If p_value_padre <> 40 Then --'Off-TEN' 
       Return 'Y';
    Else
       Return 'N';
    End If;
 End GetAP_1_1_1_1_3_5;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.3.5.1 - ILL_SpecificInfo /Specific information - (NUOVO) Informazioni specifiche - AP=Y
-- 1.1.1.1.3.6 - ILL_GradProfile / Gradient profile - Profilo del gradiente - AP=Y
-- 1.1.1.1.3.7 - ILL_MinRadHorzCurve / Minimal radius of horizontal curve - Raggio minimo di curvatura orizzontale - AP=Y
--
-- ======================================================================================
-- 1.1.1.1.4	 ITP / Track parameters - Parametri del binario
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.4.1 - ITP_NomGauge / Nominal track gauge - Scartamento nominale - AP=Y
-- 1.1.1.1.4.2 - ITP_CantDeficiency / Cant deficiency - Insufficienza di sopraelevazione - AP=Y
-- 1.1.1.1.4.3 - ITP_RailInclination / Rail inclination - Inclinazione della rotaia - AP=Y
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.4.4 - ITP_Ballast / Existence of ballast - Esistenza di ballast
-- Questo parametro è applicabile sulle sezioni di linea con velocità di percorrenza superiore a 250 km/h
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_1_4_4 (p_value_padre NUMBER)      --R16000_TR_0230 Appare se 1.1.1.1.2.5>=200
   Return Varchar2 Is
 Begin
     If p_value_padre > 250  Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_1_4_4;
-- ====================================================================================== 
-- 1.1.1.1.5	 Switches and crossings - Dispositivi di armamento
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.5.1 - ISC_TSISwitchCrossing / TSI compliance of in service values for switches and crossings
--               Rispetto da parte dei dispositivi di armamento dei valori di utilizzazione previsti dalla STI - AP=Y
-- 1.1.1.1.5.2 - ISC_MinWheelDiaFixObtuseCrossings / Minimum wheel diameter for fixed obtuse crossings 
--               Diametro minimo delle ruote per il deviatoio fisso ad angolo ottuso - AP=Y
--
-- ====================================================================================== 
-- 1.1.1.1.6   ILR / Track resistance to applied loads - Resistenza del binario ai carichi applicati
-- 1.1.1.1.6.1 - ILR_MaxDeceleration / Maximum train deceleration - Decelerazione massima del treno - AP=Y
-- 1.1.1.1.6.2 - ILR_EddyCurrentBrakes / Use of eddy current brakes - Utilizzo di freni a correnti parassite - AP=Y
-- 1.1.1.1.6.3 - ILR_MagneticBrakes / Use of magnetic brakes - Utilizzo di freni magnetici - AP=Y
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.6.4 - ILR_ECBDocRef / Document with the conditions for the use of eddy current brakes
-- (NUOVO) Documento riportante le condizioni per l'utilizzo di freni a correnti parassite - AP=N
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_6_4 --(p_value_padre Varchar2)          
     Return Varchar2 is
  Begin
       Return 'N';
  End GetAP_1_1_1_1_6_4;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.6.5 - ILR_MBDocRef / Document with the conditions for the use of magnetic brakes
-- (NUOVO) Documento riportante le condizioni per l'utilizzo di freni magnetici - AP=N
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_6_5 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'N';
  End GetAP_1_1_1_1_6_5;
--
-- ====================================================================================== 
-- 1.1.1.1.7	 IHS / Health, safety and environment - Salute, sicurezza e ambiente
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.7.1 - IHS_FlangeLubeForbidden / Use of flange lubrication forbidden - Divieto di utilizzo della lubrificazione del bordino - AP=Y
-- 1.1.1.1.7.2 - IHS_LevelCrossing / Existence of level crossings - (MODIFICATO)   Esistenza di passaggi a livello - AP=Y
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.7.3 - IHS_AccelerationLevelCrossing / Acceleration allowed at level crossing - Accelerazione consentita in prossimità dei passaggi a livello
-- Il parametro 1.1.1.1.7.3 è “applicabile” quando il valore del parametro 1.1.1.1.7.2 è [S].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_1_7_3 (p_value_padre Varchar2)      --R16000_TR_0310 appare se R16000_TR_0300=Y
   Return Varchar2 Is
 Begin
     If p_value_padre = 'Y' Then
        Return 'Y';
     Else
         Return 'N';
     End If;
 End GetAP_1_1_1_1_7_3;
--
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.7.4 - IHS_HABDExist /Existence of trackside hot axle box detector (HABD) 
-- --------------------------------------------------------------------------------------
-- (NUOVO) Esistenza di un sistema di rilevamento di anomalo riscaldamento boccole (RTB) a terra - AP=Y
-- mail Schillaci del 19/01/2021
-- ti confermo che la revisione 0 della linea guida conteneva un refuso per questi parametri. Ti allego le schede che stiamo revisionando con i redattori.
-- 1.	Il parametro 7.4 può assumere i valori [S] e [N].
-- Se assume il valore [N] tutti i parametri da 7.5 a 7.9 sono non applicabili perché non è presente RTB (tutti i parametri da 7.5 a 7.9 permettono la non applicabilità) mentre il parametro 7.4 è sempre applicabile.
-- 2.	Se il parametro 7.4 è [S] allora il parametro 7.5 è applicabile e può assumere i valori [S] o [N].
-- 3.	Se il parametro 7.5 assume il valore [S] (conforme alla STI) allora 7.6, 7.7, 7.8 e 7.9 devono essere non applicabili 
-- Se il parametro 7.5 assume il valore [N] (non conforme alla STI) allora 7.6, 7.7, 7.8 e 7.9 sono applicabili.
--
-- Il punto 3) è tracciato nella guida applicativa ERA (lo abbiamo fatto allineare per tutti i parametri, cfr. versione 1.5.4.4), mentre il punto 1) e 2) non sono direttamente tracciati ma sono combinazioni possibili con le applicabilità permesse dai parametri.
--
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.7.5 - IHS_TSIHABD/Trackside HABD TSI compliant - (NUOVO) Sistema RTB a terra conforme a STI
-- Il parametro 1.1.1.1.7.5 è applicabile solo se il parametro 1.1.1.1.7.4 = [Y]
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_7_5 (p_value_padre Varchar2)   
   Return Varchar2 Is
  Begin
   If p_value_padre = 'Y' Then
       Return 'Y';
    Else
       Return 'N';
    End If;
  End GetAP_1_1_1_1_7_5;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.7.6 - IHS_HABDID/Identification of trackside HABD - (NUOVO) Individuazione di sistema RTB a terra
-- Il parametro 1.1.1.1.7.6 è applicabile solo se il parametro 1.1.1.1.7.5 = [N]
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_7_6 (p_value_padre Varchar2)   
   Return Varchar2 Is
  Begin
     If p_value_padre = 'N' Then
       Return 'Y';
    Else
       Return 'N';
    End If;
  End GetAP_1_1_1_1_7_6;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.7.7 - IHS_HABDGen/Generation of trackside HABD - (NUOVO) Generazione di sistema RTB a terra
-- Il parametro 1.1.1.1.7.7 è applicabile solo se il parametro 1.1.1.1.7.5 = [N]
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_7_7 (p_value_padre Varchar2)   
   Return Varchar2 Is
  Begin
    If p_value_padre = 'N' Then
       Return 'Y';
    Else
       Return 'N';
    End If;
  End GetAP_1_1_1_1_7_7;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.7.8 - IHS_HABDLoc/Railway location of trackside HABD - (NUOVO) Localizzazione ferroviaria di sistema RTB a terra
-- Il parametro 1.1.1.1.7.8 è applicabile solo se il parametro 1.1.1.1.7.5 = [N]
-- --------------------------------------------------------------------------------------
/* MULTIVALORE? */
  Function GetAP_1_1_1_1_7_8 (p_value_padre Varchar2)   
   Return Varchar2 Is
  Begin
    If p_value_padre = 'N' Then
       Return 'Y';
    Else
       Return 'N';
    End If;
  End GetAP_1_1_1_1_7_8;

-- --------------------------------------------------------------------------------------
-- 1.1.1.1.7.9 - IHS_HABDDirection/Direction of measurement of trackside HABD - (NUOVO) Direzione della misurazione di sistema RTB a terra
-- Il parametro 1.1.1.1.7.9 è applicabile solo se il parametro 1.1.1.1.7.5 = [N]
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_7_9 (p_value_padre Varchar2)   
   Return Varchar2 Is
  Begin
    If p_value_padre = 'N' Then
       Return 'Y';
    Else
       Return 'N';
    End If;
  End GetAP_1_1_1_1_7_9;  
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.7.10 - IHS_RedLights/Steady red lights required - (NUOVO) Richieste luci rosse fisse - AP=Y
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_7_10  
   Return Varchar2 Is
  Begin
       Return 'Y';
  End GetAP_1_1_1_1_7_10;  
--
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.7.11 - IHS_QuietRoute / Belonging to a quieter route 
--               (NUOVO) Appartenente a una tratta meno rumorosa - AP=Y
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_7_11 
   Return Varchar2 Is
  Begin
       Return 'Y';
  End GetAP_1_1_1_1_7_11;  
--
-- ======================================================================================
-- 1.1.1.1.8	 SOLTunnel / Tunnel - Galleria
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.8.1 - SOLTunnelIMCode / IM’s Code - Codice del GI - AP=Y
-- 1.1.1.1.8.2 - SOLTunnelIdentification / Tunnel identification - Identificazione della galleria - AP=Y
-- 1.1.1.1.8.3 - SOLTunnelStart / Start of tunnel - Inizio della galleria - AP=Y
-- 1.1.1.1.8.4 - SOLTunnelEnd / End of Tunnel - Fine della galleria - AP=Y
-- 1.1.1.1.8.5 - ITU_ECVerification / EC declaration of verification for tunnel (SRT) 
--               Dichiarazione CE di verifica relativa alla conformità ai requisiti delle STI applicabili alle gallerie ferroviarie
-- 1.1.1.1.8.6 - ITU_EIDemonstration / EI declaration of verification for tunnel (SRT) 
--               Dichiarazione di dimostrazione IE relativa alla conformità ai requisiti delle STI applicabili alle gallerie ferroviarie
-- 1.1.1.1.8.7 - ITU_Length / Length of tunnel - Lunghezza della galleria - AP=Y
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.8.8 - ITU_CrossSectionArea / Cross section area - Area della sezione trasversale
-- Il parametro 1.1.1.1.8.8 è applicabile solo quando il parametro 1.1.1.1.2.5 della sezione di linea su cui
-- insiste la galleria sia >= 200 km/h
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_8_8 (p_value_padre Number)          --APPLICABILITA' Conformità delle strutture al modello di carico ad alta velocità
   Return Varchar2 Is
  Begin
    If p_value_padre >= 200 Then
	-- verificare che ci sia il certificato e che la velocità sia consentita
       Return 'Y';
    Else
       Return 'N';
    End If;
  End GetAP_1_1_1_1_8_8;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.8.8.1 - ITU_TSITunnel / compliance of the tunnel with INF TSI - (NUOVO) Conformità della galleria alla STI INF
-- Il parametro 1.1.1.1.8.8.1 è applicabile solo quando il parametro 1.1.1.1.2.5 della sezione di linea su cui
-- insiste la galleria sia >= 200 km/h
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_8_8_1 (p_value_padre Number)          --APPLICABILITA' Conformità delle strutture al modello di carico ad alta velocità
   Return Varchar2 Is
  Begin
    If p_value_padre >= 200 Then
	-- verificare che ci sia il certificato e che la velocità sia consentita
       Return 'Y';
    Else
       Return 'N';
    End If;
  End GetAP_1_1_1_1_8_8_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.8.8.2 - ITU_TunnelDocRef / Reference of to a document available from the IM with precise description of the tunnel 
-- (NUOVO) Documento messo a disposizione dal GI contenente la descrizione esatta della galleria - AP=N
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_1_8_8_2 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'N';
  End GetAP_1_1_1_1_8_8_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.8.9 - ITU_EmergencyPlan / Existence of emergency plan 
-- (MODIFICATO)   Esistenza del piano di emergenza - AP=Y
-- Il parametro:
-- assume il valore “S” se la galleria ha lunghezza maggiore o uguale di 1000 m ed esiste un piano di emergenza
-- allegato nel folder documenti della Sede Tecnica,
-- assume il valore “N” se la galleria ha lunghezza maggiore o uguale di 1000 m e non esiste ancora un piano di
-- emergenza allegato nel folder documenti della Sede Tecnica o se la galleria ha lunghezza minore di 1000 m.
-- il 15/03/2021 a seguito dei nuovi controlli sul parametro risulta che:
-- il TAG del parametro 1.1.1.1.8.9 "ITU_EmergencyPlan" se la lunghezza del tunnel “ITU_Length" è minore o uguale a 1000 metri va codificato:
--        <SOLTunnelParameter ID="ITU_EmergencyPlan" IsApplicable="N" Value="" />
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_1_8_9 (p_value_padre Number)      --R25350_TR_0100 appare se S25350_0001 > 1000
   Return Varchar2 Is
 Begin
 --    If p_value_padre > 1000  Then
       Return 'Y';                                        --> 18/03/2021 - il parametro è sempre applicabile
 --    Else
--         Return 'N';
 --    End If;
 End GetAP_1_1_1_1_8_9;
-- --------------------------------------------------------------------------------------
-- 1.1.1.1.8.10 - ITU_FireCatReq / Fire category of rolling stock required 
-- (MODIFICATO)   Categoria di sicurezza antincendio richiesta per il materiale rotabile
-- Il parametro 1.1.1.1.8.10 è applicabile per gallerie aventi lunghezza maggiore o uguale a 1000 m.
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_1_8_10 (p_value_padre Number)      --R25350_TR_0100 appare se S25350_0001 > 1000
   Return Varchar2 Is
 Begin
     If p_value_padre < 1000  Then
        Return 'N';
     Else
         Return 'Y';
     End If;
 End GetAP_1_1_1_1_8_10;
-- ----------------------------------------------------------------------------
-- 1.1.1.1.8.11 - ITU_NatFireCatReq / National fire category of rolling stock required - 
--                Categoria di sicurezza antincendio nazionale richiesta per il materiale rotabile
-- 17/05/2018  reinserita con l'aggiunta di NC in INE e con l'eliminazione di NA
-- Il parametro 1.1.1.1.8.11 è applicabile per gallerie aventi lunghezza maggiore o uguale a 1000 m 
-- e quando il parametro 1.1.1.1.8.10 è valorizzato con “nessuna”.
-- ----------------------------------------------------------------------------
 Function GetAP_1_1_1_1_8_11 (p_value_padre_1 Number, p_value_padre_2 Varchar2)      --R25350_TR_0110 Appare se S25350_0001>=1000 e R25350_TR_0100 = none
   Return Varchar2 Is
 Begin
     If p_value_padre_1 >= 1000 And p_value_padre_2 = 'NONE'  Then
         Return 'Y';
     Else
         Return 'N';
     End If;
 End GetAP_1_1_1_1_8_11;
-- 
-- ======================================================================================
-- 1.1.1.2	Energy system - Sottosistema «energia»
--          Parameters below until 1.1.1.3 belong to the group of energy parameters
--
-- ======================================================================================
-- 1.1.1.2.1 - EDE/ Declarations of verification for track - Dichiarazioni di verifica del binario
-- ----------------------------------------------------------------------------
-- 1.1.1.2.1.1 - EDE_ECVerification / EC declaration of verification for track (ENE) 
--              Dichiarazione CE di verifica del binario relativa alla conformità ai requisiti delle STI applicabili al sottosistema «energia»
-- 1.1.1.2.1.2 - EDE_EIDemonstration / EI declaration of demonstration for track (ENE) 
--              Dichiarazione di dimostrazione IE per il binario relativa alla conformità ai requisiti delle STI applicabili al sottosistema «energia»
--
-- ======================================================================================
-- 1.1.1.2.2 - ECS / Contact line system - Sistema di linea di contatto
-- 1.1.1.2.2.1.1 - ECS_SystemType / Type of contact line system - Tipo di sistema di linea di contatto - AP=Y
-- ----------------------------------------------------------------------------
-- Function GetAP_1_1_1_2_2_1_1(p_value_figlio Varchar2)      --R16000_TR_0340  appare se  S16000_0080=S
--Return Varchar2 Is                                          --questo par non ha l'app in AG: è la linea di contatto elettrica
--
--Begin
--If p_value_figlio Is NULL Then
--   Return '40';
--Else
--    Return '10';
--End If;
--End GetAP_1_1_1_2_2_1_1;
-- ----------------------------------------------------------------------------
-- Function Get_Code_1_1_1_2_2_1_1(n_parametro NUMBER)         --abbozzata non usata
--Return Varchar2 IS
--p_valore VARCHAR (26);
--Begin
--
--select valore into p_valore
--from RINF_ANAGRAFICHE.DOMINIO_PARAMETRO
--where codice_parametro = n_parametro;
--
--Return p_valore;
--End Get_Code_1_1_1_2_2_1_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.2.1.2 - ECS_VoltFreq / Energy supply system - Sistema di alimentazione elettrica (tensione e frequenza)
-- Il parametro 1.1.1.2.2.1.2 non è applicabile quando il parametro 1.1.1.2.2.1.1 è valorizzato con [non elettrificato]=40
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_2_1_2 (p_value_padre Varchar2)      --R16000_TR_0350  appare se  S16000_0080=S
   Return Varchar2 Is
 Begin
     If p_value_padre = '40' Then             -- criterio modificato con il Reg.777/2019 (prima se=10 (OCL)--> Y, altrimenti N)
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_2_2_1_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.2.1.2.1 - ECS_TSIVoltFreq / Energy supply system TSI compliant 
-- (NUOVO)  Il parametro non è applicabile quando il parametro 1.1.1.2.2.1.1 è valorizzato con [non elettrificato]=40
-- --------------------------------------------------------------------------------------
   Function GetAP_1_1_1_2_2_1_2_1 (p_value_padre Varchar2)     
    Return Varchar2 Is
   Begin
   If p_value_padre = '40' Then --Off_Ten
      Return 'N';
   Else
      Return 'Y';
    End If;
  End GetAP_1_1_1_2_2_1_2_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.2.1.3 - ECS_Umax2/Umax2 for lines referred to in sections 7.4.2.2.1 and 7.4.2.11.1 of Regulation (EU) 1301/2014. 
-- (NUOVO) Umax2 per linee di cui al punto 7.4.2.2.1 del regolamento (UE) n. 1301/2014. - AP=N
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_2_2_1_3 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'N';
  End GetAP_1_1_1_2_2_1_3;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.2.2	ECS_MaxTrainCurrent / Maximum train current - Corrente massima del treno
-- Il parametro 1.1.1.2.2.2 non è applicabile quando il parametro 1.1.1.2.2.1.1 è valorizzato con [non elettrificato]=40
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_2_2 (p_value_padre Varchar2)      --R16000_TR_0350 appare se S16000_0080=S
   Return Varchar2 Is
 Begin
     If p_value_padre = '40'  Then             -- criterio modificato con il Reg.777/2019 (prima se=10 (OCL)--> Y, altrimenti N)
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_2_2_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.2.3	ECS_MaxStandstillCurrent / Maximum current at standstill per pantograph - Corrente massima a treno fermo per pantografo
-- Il parametro 1.1.1.2.2.3 non è applicabile quando il parametro 1.1.1.2.2.1.1 è valorizzato con [non elettrificato]=40.
-- Il parametro è applicabile quando il parametro 1.1.1.2.2.1.1 è valorizzato con [Linea di contatto aerea (OCL)]=10 e il parametro
-- 1.1.1.2.2.1.2 è valorizzato con [CC 3 kV]=30.
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_2_3 (p_value_padre_1 Varchar2, p_value_padre_2 Varchar2)      --R16000_TR_0360 appare se S16000_0080=S
   Return Varchar2 Is
 Begin
     If p_value_padre_1 = '40'  Then             -- criterio modificato con il Reg.777/2019 
        Return 'N';
	 ElsIf((p_value_padre_1 = '10' or p_value_padre_1 Is null) And p_value_padre_2 = '30') Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_2_2_3;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.2.4	ECS_RegenerativeBraking / Permission for regenerative braking - Autorizzazione della frenatura a recupero
-- Il parametro 1.1.1.2.2.4 non è applicabile quando il parametro 1.1.1.2.2.1.1 è valorizzato con [non elettrificato]=40.
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_2_4 (p_value_padre Varchar2)      --R16000_TR_0370 appare  se S16000_0080=S
   Return Varchar2 Is
 Begin
     If p_value_padre = '40' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_2_2_4;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.2.5	ECS_MaxWireHeight / Maximum contact wire height - Altezza massima del filo di contatto
-- Questo parametro non è applicabile se il parametro 1.1.1.2.2.1.1 è valorizzato = [non elettrificato].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_2_5 (p_value_padre Varchar2)      --R16000_TR_0380 appare se  S16000_0080=S
   Return Varchar2 Is
 Begin
     If p_value_padre = '40' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_2_2_5;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.2.6	ECS_MinWireHeight / Minimum contact wire height - Altezza minima del filo di contatto
-- Questo parametro non è applicabile se il parametro 1.1.1.2.2.1.1 è valorizzato = [non elettrificato].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_2_6 (p_value_padre Varchar2)      --R16000_TR_0390 appare se S16000_0080=S
   Return Varchar2 Is
 Begin
     If p_value_padre = '40'  Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_2_2_6;
--
-- ======================================================================================
-- 1.1.1.2.3 EPA / Pantograph - Pantografo
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.3.1 - EPA_TSIHeads / Accepted TSI compliant pantograph heads - Archetti del pantografo accettati conformi alla STI
-- Questo parametro non è applicabile se il parametro 1.1.1.2.2.1.1 è valorizzato = [non elettrificato].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_3_1 (p_value_padre Varchar2)      --R16000_TR_0400 appare se S16000_0080=S
   Return Varchar2 Is
 Begin
     If p_value_padre = '40'  Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_2_3_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.3.2 - EPA_OtherHeads / Accepted other pantograph heads - Altri archetti del pantografo accettati
-- Questo parametro non è applicabile se il parametro 1.1.1.2.2.1.1 è valorizzato = [non elettrificato].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_3_2 (p_value_padre Varchar2)      --R16000_TR_0410 appare se  S16000_0080=S
   Return Varchar2 Is
     Begin
     If p_value_padre = '40'  Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_2_3_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.3.3 - EPA_NumRaisedSpeed / Requirements for number of raised pantographs and spacing between them, at the given speed - Requisiti in materia di numero di pantografi alzati e distanza tra loro, a una data velocità
-- Questo parametro non è applicabile se il parametro 1.1.1.2.2.1.1 è valorizzato = [non elettrificato].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_3_3 (p_value_padre Varchar2)      --R16000_TR_0420 appare se S16000_0080=S; uso un'appl totale per i parametri A, B ,C
   Return Varchar2 Is
 Begin
     If p_value_padre = '40'  Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_2_3_3;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.3.4 - EPA_StripMaterial / Permitted contact strip material - Materiali degli striscianti autorizzati
-- Questo parametro non è applicabile se il parametro 1.1.1.2.2.1.1 è valorizzato = [non elettrificato].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_3_4 (p_value_padre Varchar2)      --R16000_TR_0430 appare se   S16000_0080=S
   Return Varchar2 Is
 Begin
     If p_value_padre = '40'  Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_2_3_4;
--
-- ======================================================================================
-- 1.1.1.2.4	EOS / OCL separation sections - Tratti a separazione della catenaria 
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.4.1.1 - EOS_Phase / Phase separation - Separazione di fase
-- Il parametro è applicabile se il parametro 1.1.1.2.2.1.1 è valorizzato [Linea di contatto aerea (OCL)].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_4_1_1 (p_value_padre Varchar2)      --R16000_TR_0440 appare se  S16000_0080=S
   Return Varchar2 Is
 Begin
     If p_value_padre = '10'  Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_2_4_1_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.4.1.2	EOS_InfoPhase / Information on phase separation - Informazioni sulla separazione di fase
-- Il parametro 1.1.1.2.4.1.2 è applicabile se il parametro 1.1.1.2.4.1.1 è valorizzato con [S].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_4_1_2 (p_value_padre Varchar2)      --R16000_TR_0450 appare se R16000_TR_0440=Y  uso un'appl unica per A, B ,C
   Return Varchar2 Is
 Begin
     If p_value_padre = 'Y' Then
        Return 'Y';
     Else
         Return 'N';
     End If;
 End GetAP_1_1_1_2_4_1_2;
-- --------------------------------------------------------------------------------------
--1.1.1.2.4.2.1	EOS_System / System separation - Separazione di sistema
-- Il parametro è applicabile se il parametro 1.1.1.2.2.1.1 è valorizzato [Linea di contatto aerea (OCL)].
-- --------------------------------------------------------------------------------------
Function GetAP_1_1_1_2_4_2_1 (p_value_padre Varchar2)      --R16000_TR_0480 appare se  S16000_0080=S  esiste almeno un oggetto di tipo TR++++-BC-BC++-PK+ sotto il medesimo BC di tratta
  Return Varchar2 Is
 Begin
     If p_value_padre = '10' Then   
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_2_4_2_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.4.2.2	EOS_InfoSystem / Information on system separation - Informazioni sulla separazione di sistema
--Il parametro 1.1.1.2.4.2.2 è applicabile se il parametro 1.1.1.2.4.2.1 è valorizzato con [S].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_4_2_2 (p_value_padre Varchar2)      --R16000_TR_0490 appare se  R16000_TR_0480=Y  uso una sola appl per A, B, C, D
   Return Varchar2 Is
 Begin
     If p_value_padre = 'Y' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_2_4_2_2;
-- --------------------------------------------------------------------------------------
--  1.1.1.2.4.3	EOS_DistSignToPhaseEnd/Distance between signboard and phase separation ending 
-- (NUOVO) Distanza tra il pannello e la fine della separazione di fase AP=N
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_2_4_3 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'N';
  End GetAP_1_1_1_2_4_3;
--
-- ======================================================================================
-- 1.1.1.2.5 ERS / Requirements for rolling stock - Requisiti per il materiale rotabile
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.5.1 - ERS_PowerLimitOnBoard / Current or power limitation on board required - Limitazione di corrente o di potenza a bordo richiesta
-- Il parametro 1.1.1.2.5.1 non è applicabile quando il parametro 1.1.1.2.2.1.1 è valorizzato [non elettrificato].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_5_1 (p_value_padre Varchar2)      --R16000_TR_0530 appare se  S16000_0080=S
   Return Varchar2 Is
 Begin
     If p_value_padre = '40' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_2_5_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.5.2 - ERS_ContactForce / Contact force permitted - Forza di contatto autorizzata
-- Il parametro 1.1.1.2.5.2 non è applicabile quando il parametro 1.1.1.2.2.1.1 è valorizzato [non elettrificato].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_5_2 (p_value_padre Varchar2)      --R16000_TR_0540 appare se S16000_0080=S
   Return Varchar2 Is
 Begin
     If p_value_padre = '40' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_2_5_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.2.5.3 - ERS_AutoDropRequired / Automatic dropping device required - Dispositivo di abbassamento automatico richiesto
--Il parametro 1.1.1.2.5.3 è applicabile quando il parametro 1.1.1.2.2.1.1 è valorizzato [Linea di contatto aerea (OCL)].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_2_5_3 (p_value_padre Varchar2)      --R16000_TR_0550 appare se  S16000_0080=S
   Return Varchar2 Is
 Begin
     If p_value_padre = '10' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_2_5_3;
--
-- ======================================================================================
-- 1.1.1.3	Control-command and signalling subsystem - Sottosistema «controllo-comando e segnalamento»
--          Parameters below until 1.2 belong to the group of CCS parameters
-- 1.1.1.3.1 CDE / Declarations of verification for track - Dichiarazioni di verifica del binario
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.1.1	CDE_ECVerification / EC declaration of verification for track (CCS) 
--              Dichiarazione CE di verifica del binario relativa alla conformità ai requisiti delle STI applicabili al sottosistema «controllo-comando e segnalamento»
-- 1.1.1.3.2.1	CPE_Level / ETCS level - Livello del sistema europeo di controllo dei treni (ETCS) - AP=Y
-- ======================================================================================
-- 1.1.1.3.2 -  CPE / TSI compliant train protection system (ETCS) - Sistema di protezione del treno (ETCS) conforme alla STI
-- 1.1.1.3.2.2	CPE_Baseline / ETCS baseline - Baseline dell'ETCS
-- Il parametro 1.1.1.3.2.2 non è applicabile quando il parametro 1.1.1.3.2.1 sia valorizzato con [N].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_2_2 (p_value_padre Varchar2)      --R16000_TR_0580 appare se  R16000_TR_0570 <> N
   Return Varchar2 Is
 Begin
     If p_value_padre = 'N' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
End GetAP_1_1_1_3_2_2;
--
-- ======================================================================================
-- 1.1.1.3.2	 CPE / TSI compliant train protection system (ETCS) - Sistema di protezione del treno (ETCS) conforme alla STI
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.2.3	CPE_Infill / ETCS infill necessary for line access - Funzione infill dell'ETCS necessaria per accedere alla linea
-- Il parametro 1.1.1.3.2.3 è applicabile quando il parametro 1.1.1.3.2.1 sia valorizzato [1].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_2_3 (p_value_padre Varchar2)      --R16000_TR_0590 appare se  R16000_TR_0570 <> N
   Return Varchar2 Is
 Begin
     If p_value_padre = '1' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_2_3;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.2.4	CPE_InfillLineSide / ETCS infill installed lineside - Funzione infill dell'ETCS installata a terra
-- Il parametro 1.1.1.3.2.4 è applicabile quando il parametro 1.1.1.3.2.1 sia valorizzato [1].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_2_4 (p_value_padre Varchar2)      --R16000_TR_0600 appare se  R16000_TR_0570 <> N
   Return Varchar2 Is
 Begin
     If p_value_padre = '1' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_2_4;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.2.5	CPE_NatApplication / ETCS national packet 44 application implemented - Implementazione del pacchetto 44 dell'applicazione nazionale dell'ETCS
--Il parametro 1.1.1.3.2.5 non è applicabile quando il parametro 1.1.1.3.2.1 sia valorizzato [N]. 
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_2_5 (p_value_padre Varchar2)      --R16000_TR_0610 appare se  R16000_TR_0570 <> N
   Return Varchar2 Is
 Begin
     If p_value_padre = 'N' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_3_2_5;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.2.6	CPE_RestrictionsConditions / Existence of operating restrictions or conditions - Esistenza di restrizioni o condizioni operative
-- Il parametro 1.1.1.3.2.6 non è applicabile quando il parametro 1.1.1.3.2.1 sia valorizzato con [N]. 
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_2_6 (p_value_padre Varchar2)      --R16000_TR_0620 appare se  R16000_TR_0570 <> N
   Return Varchar2 Is
 Begin
     If p_value_padre = 'N' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_3_2_6;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.2.7	CPE_OptionalFunctions / Optional ETCS functions - (CANCELLATO) Funzioni facoltative dell'ETCS
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_2_7 (p_value_padre Varchar2)      --R16000_TR_0630 appare se  R16000_TR_0570 <> N
   Return Varchar2 Is
 Begin
     If p_value_padre = 'N' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_3_2_7;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.2.8 - CPE_IntegrityConfirmation / Train integrity confirmation from on-board necessary for line access 
-- (NUOVO) Conferma dell'integrità del treno a bordo necessaria per accedere alla linea
-- Il parametro 1.1.1.3.2.8 è applicabile solo quando il parametro 1.1.1.3.2.1 sia valorizzato con [3]
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_2_8 (p_value_padre Varchar2)      --R16000_TR_0630 appare se  R16000_TR_0570 <> N
   Return Varchar2 Is
 Begin
     If p_value_padre = '3' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_2_8;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.2.9 - CPE_SystemCompatiblity / ETCS system compatibility - (NUOVO) Compatibilità con il sistema ETCS
-- Parametro nuovo 1.1.1.3.2.9 non è applicabile quando il parametro 1.1.1.3.2.1 sia valorizzato con [N]
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_2_9 (p_value_padre Varchar2)      --R16000_TR_0630 appare se  R16000_TR_0570 <> N
   Return Varchar2 Is
 Begin
     If p_value_padre = 'N' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_3_2_9;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.2.10 - CPE_MVersion / ETCS M_version - (NUOVO) ETCS M_version
-- Parametro nuovo 1.1.1.3.2.10 non è applicabile quando il parametro 1.1.1.3.2.1 sia valorizzato con [N]
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_2_10 (p_value_padre Varchar2)      --R16000_TR_0630 appare se  R16000_TR_0570 <> N
   Return Varchar2 Is
 Begin
     If p_value_padre = 'N' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_3_2_10;
--
-- ======================================================================================
-- 1.1.1.3.3	 	CRG / TSI compliant radio (GSM-R) - Radio (GSM-R) conforme alla STI
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.3.1	CRG_Version GSM-R version - Versione GSM-R Scelta unica - AP=Y
-- --------------------------------------------------------------------------------------
Function GetAP_1_1_1_3_3_1 
   Return Varchar2 Is
 Begin
     Return 'Y';

 End GetAP_1_1_1_3_3_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.3.2	CRG_NumActiveMob / Advised Required number of active GSM-R mobiles (EDOR) or simultaneous communication session on-board for ETCS Level 2 (or level 3) needed to perform radio block centre handovers without having an operational disruption - 
-- Numero di dispositivi mobili GSM-R attivi (EDOR) o di sessioni di comunicazione simultanea a bordo per ETCS livello 2 o livello 3 necessario per il trasferimento di RBC (centro di blocco radio) senza interruzioni operative
-- Il parametro 1.1.1.3.3.2 è applicabile solo quando il parametro 1.1.1.3.2.1 - Baseline dell'ETCS, sia valorizzato con [2] o con [3].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_3_2 (p_value_padre Varchar2)      --R16000_TR_0650 appare se R16000_TR_0570=2 or  R16000_TR_0570=3
   Return Varchar2 Is
 Begin
     If (p_value_padre = '2' Or p_value_padre = '3') Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_3_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.3.3	CRG_OptionalFunctions / Optional GSM-R functions - Funzioni GSM-R facoltative
-- Il parametro 1.1.1.3.3.3 non è applicabile quando il parametro 1.1.1.3.3.1 – “Versione GSM-R” è valorizzato [nessuna].
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_3_3 (p_value_padre Varchar2)      --R16000_TR_0660 non appare se R16000_TR_0640=none
     Return Varchar2 Is
  Begin
     If Upper(p_value_padre) = 'NONE' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
  End GetAP_1_1_1_3_3_3;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.3.3.1 - CRG_AdditionalnetworkInfo / Additional information on network characteristics 
-- (NUOVO) Informazioni supplementari sulle caratteristiche di rete
-- Il parametro 1.1.1.3.3.3.1 non è applicabile quando il parametro 1.1.1.3.3.1 – “Versione GSM-R” è valorizzato [nessuna].
--  1.1.1.3.3.3.1  Quando Applicabile assume Sempre il valore = [Filtri bAnda UIC x legacy EDOR] - 300
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_3_3_1 (p_value_padre Varchar2)      --R16000_TR_0660 non appare se R16000_TR_0640=none
     Return Varchar2 Is
  Begin
     If Upper(p_value_padre) = 'NONE' Then
        Return 'N';
     Else
        Return 'Y';
     End If; 	 
  End GetAP_1_1_1_3_3_3_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.3.3.2 - CRG_GPRSForETCS / GPRS for ETCS - (NUOVO) GPRS per ETCS
-- Il parametro 1.1.1.3.3.3.2 (GPRS per ETCS) non è applicabile quando il parametro 1.1.1.3.3.1 – “Versione GSM-R” è valorizzato [nessuna]
-- o quando il parametro 1.1.1.3.2.1 - "Livello ETCS" è valorizzato [N], [NTC], [0], [1]
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_3_3_2 (p_value_padre_1 Varchar2, p_value_padre_2 Varchar2)      --R16000_TR_0660 non appare se R16000_TR_0640=none
      Return Varchar2 Is
  Begin
     If Upper(p_value_padre_1) = 'NONE' Then
        Return 'N';
     ElsIf (p_value_padre_2 = 'N' Or p_value_padre_2 = 'NTC' Or p_value_padre_2 = '0' Or p_value_padre_2 = '1') Then 
        Return 'N';
	 Else
        Return 'Y';
     End If;
  End GetAP_1_1_1_3_3_3_2;

-- --------------------------------------------------------------------------------------
--  1.1.1.3.3.3.3	CRG_GPRSAreaOfImpl / Area of implementation of GPRS 
-- (NUOVO) Zona di implementazione del GPRS - AP=N
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_3_3_3 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'N';
  End GetAP_1_1_1_3_3_3_3;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.3.4	CRG_Needof555 / Use of group 555 - (NUOVO) Utilizzo del gruppo 555
-- Il parametro 1.1.1.3.3.4 non è applicabile quando il parametro 1.1.1.3.3.1 – “Versione GSM-R” è valorizzato [nessuna].
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_3_4 (p_value_padre Varchar2)      --R16000_TR_0660 non appare se R16000_TR_0640=none
     Return Varchar2 Is
  Begin
     If Upper(p_value_padre) = 'NONE' Then
        Return 'N';
     Else
        Return 'Y';
     End If; 	 
  End GetAP_1_1_1_3_3_4;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.3.5	CRG_RoamingAgreement / GSM-R networks covered by a roaming agreement - (NUOVO) Reti GSM-R coperte da accordo di roaming
-- Il parametro 1.1.1.3.3.5 non è applicabile quando il parametro 1.1.1.3.3.1 – “Versione GSM-R” è valorizzato [nessuna].
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_3_5 (p_value_padre Varchar2)      --R16000_TR_0660 non appare se R16000_TR_0640=none
     Return Varchar2 Is
  Begin
     If Upper(p_value_padre) = 'NONE' Then
        Return 'N';
     Else
        Return 'Y';
     End If; 	 
  End GetAP_1_1_1_3_3_5;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.3.6 - CRG_RoamingPublic / Existence of roaming to public networks - (NUOVO) Presenza di roaming su reti pubbliche
-- Il parametro 1.1.1.3.3.6 non è applicabile quando il parametro 1.1.1.3.3.1 – “Versione GSM-R” è valorizzato [nessuna].
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_3_6 (p_value_padre Varchar2)      --R16000_TR_0660 non appare se R16000_TR_0640=none
     Return Varchar2 Is
  Begin
     If Upper(p_value_padre) = 'NONE' Then
        Return 'N';
     Else
        Return 'Y';
     End If; 	 
  End GetAP_1_1_1_3_3_6;
-- ----------------------------------------------------------------------------------------
-- 1.1.1.3.3.7 - CRG_RoamingPublicDetails / Details on roaming to public networks- (NUOVO) Dettagli relativi al roaming su reti pubbliche
-- Il parametro 1.1.1.3.3.7 non è applicabile quando il parametro 1.1.1.3.3.1 – “Versione GSM-R” è valorizzato [nessuna].
-- Il parametro è applicabile quando il parametro 1.1.1.3.3.6 - "Presenza di roaming su reti pubbliche" è valorizzato [S] 
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_3_7 (p_value_padre_1 Varchar2, p_value_padre_2 Varchar2)      --R16000_TR_0660 non appare se R16000_TR_0640=none
     Return Varchar2 Is
  Begin
     If Upper(p_value_padre_1) = 'NONE' Then
        Return 'N';
     Else
	   If p_value_padre_2 = 'Y' Then
           Return 'Y';
       Else 
           Return 'N';
       End If; 	 
     End If; 	 
  End GetAP_1_1_1_3_3_7;
-- ----------------------------------------------------------------------------------------
-- 1.1.1.3.3.8 - CRG_GSMRNoCoverage / No GSMR coverage - (NUOVO) Assenza di copertura GSMR
-- Il parametro 1.1.1.3.3.8 non è applicabile quando il parametro 1.1.1.3.3.1 – “Versione GSM-R” è valorizzato [nessuna].
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_3_8 (p_value_padre Varchar2)      --R16000_TR_0660 non appare se R16000_TR_0640=none
     Return Varchar2 Is
  Begin
     If Upper(p_value_padre) = 'NONE' Then
        Return 'N';
     Else
        Return 'Y';
     End If; 	 
  End GetAP_1_1_1_3_3_8;
-- --------------------------------------------------------------------------------------
--1.1.1.3.3.9 - CRG_RadioCompVoice / Radio system compatibility voice - (NUOVO) Compatibilità del sistema radio - voce
-- Il parametro 1.1.1.3.3.9 non è applicabile quando il parametro 1.1.1.3.3.1 – “Versione GSM-R” è valorizzato [nessuna].
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_3_9 (p_value_padre Varchar2)      --R16000_TR_0660 non appare se R16000_TR_0640=none
     Return Varchar2 Is
  Begin
     If Upper(p_value_padre) = 'NONE' Then
        Return 'N';
     Else
        Return 'Y';
     End If; 	 
  End GetAP_1_1_1_3_3_9;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.3.10	CRG_RadioCompData / Radio system compatibility data - (NUOVO) Compatibilità del sistema radio - dati
-- Il parametro 1.1.1.3.3.10 non è applicabile quando il parametro 1.1.1.3.3.1 – “Versione GSM-R” è valorizzato [nessuna].
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_3_10 (p_value_padre Varchar2)      --R16000_TR_0660 non appare se R16000_TR_0640=none
     Return Varchar2 Is
  Begin
     If Upper(p_value_padre) = 'NONE' Then
        Return 'N';
     Else
        Return 'Y';
     End If; 	 
  End GetAP_1_1_1_3_3_10;
--
-- ======================================================================================
-- 1.1.1.3.4 CCD / Train detection systems fully compliant with the TSI - Sistemi di rilevamento del treno pienamente conformi alla STI
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.4.1	CCD_TSITrainDetection / Existence of train detection system fully compliant with the TSI 
-- Esistenza di un sistema di rilevamento del treno pienamente conforme alla STI - AP=Y
-- ======================================================================================
-- 1.1.1.3.5	 CPO / Train protection legacy systems - Sistemi preesistenti di protezione del treno
-- 1.1.1.3.5.1	CPO_Installed / Existence of other train protection, control and warning systems installed 
-- (CANCELLATO) Esistenza di altri sistemi installati di protezione, controllo e allerta della marcia del treno Sistema di protezione del treno
-- --------------------------------------------------------------------------------------
-- Function GetAP_1_1_1_3_5_1(p_value_padre Varchar2,p_value_figlio Varchar2)      --R16000_TR_0680 Appare se 1.1.1.3.2.1 = N
--Return Varchar2 IS
--
--Begin
--If p_value_padre = 'N' --And p_value_figlio Is NULL         --eliminata applicabilità per aggiornamento ERA (mail Schillaci 19/05/2016 e risposta ERA tramite mail Autiero 19/05/2016)
--Then
--   Return 'Y';
--Else
--    Return 'N';
--End If;
--End GetAP_1_1_1_3_5_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.5.2	CPO_MultipleRequired / Need for more than one train protection, control and warning system required on-board 
-- (CANCELLATO) Necessità di disporre a bordo di più sistemi di protezione, controllo e allerta della marcia del treno
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_5_2 (p_value_padre Varchar2)      --R16000_TR_0690 Appare se 1.1.1.3.2.1 = N
   Return Varchar2 Is
 Begin
     If p_value_padre = 'N' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_5_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.5.3	CPO_LegacyTrainProtection / Train protection legacy system 
-- (NUOVO) Sistema preesistente di protezione del treno - AP=Y
--
-- ======================================================================================
-- 1.1.1.3.6	 CRS / Other radio systems ¬- Sistemi radio preesistenti
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.6.1	CRS_Installed / Other radio systems installed (Radio Legacy Systems) - 
-- (MODIFICATO) Altri sistemi radio installati (sistemi radio preesistenti) - AP=Y - vale sempre [GSM-P]
-- --------------------------------------------------------------------------------------
-- Function GetAP_1_1_1_3_6_1(p_value_padre Varchar2,p_value_figlio Varchar2) --AP FITTIZIA (AG 21/05/2015)     --R16000_TR_0700 appare se  R16000_TR_0640=none
--Return Varchar2 IS
--
--Begin
--If p_value_padre = 'NONE' --And p_value_figlio Is NULL
--Then
--   Return 'Y';
--Else
--    Return 'N';
--End If;
--End GetAP_1_1_1_3_6_1;
--
  Function GetAP_1_1_1_3_6_1 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'Y';
  End GetAP_1_1_1_3_6_1;
--
-- ======================================================================================
-- 1.1.1.3.7 CTD / Train detection systems not fully compliant with the TSI 
--     Sistemi di rilevamento del treno non pienamente conformi alla STI
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.1.1 - CTD_DetectionSystem / Type of train detection system 
-- (NUOVO) Tipo di sistema di rilevamento del treno - Sostituisce il 1.1.1.3.7.1
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_1_1 (p_value_figlio Varchar2)      --> N.B. value_figlio (VERIFICARE con RFI)
   Return Varchar2 Is
 Begin
   If Upper(p_value_figlio) = 'WHEEL DETECTOR' or Upper(p_value_figlio) = 'TRACK CIRCUIT'    Then
       Return 'Y';
   ElsIf (p_value_figlio) = 'NA' Then
       Return 'N';
   Else
      Return 'N';
   End If;
End GetAP_1_1_1_3_7_1_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.1.2 - CTD_TCCheck/Type of track circuits to which specific checks are needed 
-- (NUOVO) Tipo di circuiti di binario o contatori assi per i quali sono richieste verifiche specifiche
-- Il parametro 1.1.1.3.7.1.2 è applicabile quando il parametro 1.1.1.3.7.1.1 è valorizzato [circuito di binario] o [rilevatore di ruota] e siamo in
-- presenza di circuiti di binario o rilevatori di ruota che richiedono verifiche specifiche.
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_1_2 (p_value_padre Varchar2, p_value_figlio Varchar2)      
   Return Varchar2 Is
 Begin
     If (Upper(p_value_padre) = 'WHEEL DETECTOR' or Upper(p_value_padre) = 'TRACK CIRCUIT') And p_value_figlio is Not Null Then -- VERIFICARE
        Return 'Y';
	 Else 
  	    Return 'N';
     End If;
 End GetAP_1_1_1_3_7_1_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.1.3 - CTD_TCCheckDocRef /Document with the procedure(s) related to the type of track circuits declared in 1.1.1.3.7.1.2 
-- (NUOVO) Documento riportante la/le procedura/e relativa/e ai tipi di sistema di rilevamento del treno di cui al punto 1.1.1.3.7.1.2
-- Il parametro 1.1.1.3.7.1.3 è applicabile quando il parametro 1.1.1.3.7.1.2 è valorizzato - valore=[ERA/TD/2011-01/XA ver. 1.2]+[doc ANSF]
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_1_3 (p_value_padre Varchar2)      
   Return Varchar2 Is
 Begin
     If p_value_padre is Not Null Then
        Return 'Y';
	 Else 
  	    Return 'N';
     End If;
 End GetAP_1_1_1_3_7_1_3;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.1.4 - CTD_TCLimitation/Section with train detection limitation, only for the French network 
-- (NUOVO) Sezione con limitazione di rilevamento del treno (Solo per la rete francese) - AP=N
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_7_1_4 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'N';
  End GetAP_1_1_1_3_7_1_4;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.2.1 - CTD_TSIMaxDistConsecutiveAxles / TSI compliance of maximum permitted distance between two consecutive axles 
-- Conformità alla STI della distanza massima consentita tra due assi consecutivi
-- Il parametro 1.1.1.3.7.2.1 e  deve essere valorizzato quando il arametro 1.1.1.3.7.1.1 è Applicabile
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_2_1 (p_value_padre Varchar2)   -- SOL_TRACK_1_1_1_3_7_2_1_AP = 'Y'
   Return Varchar2 Is
 Begin
     If (Upper(p_value_padre)='WHEEL DETECTOR' Or Upper(p_value_padre)= 'TRACK CIRCUIT') Then -- Upper(p_value_padre) = 'Y'   
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_2_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.2.2 - CTD_MaxDistConsecutiveAxles / Maximum permitted distance between two consecutive axles in case of TSI non-compliance 
-- Distanza massima consentita tra due assi consecutivi in caso di non conformità alla STI
-- Il parametro 1.1.1.3.7.2.2 e  deve essere valorizzato quando il valore del parametro 1.1.1.3.7.2.1 - “Conformità alla STI della distanza massima
-- autorizzata tra due assi consecutivi” è [Non conforme alla STI] (per RFI: sempre NA)
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_2_2 (p_value_padre Varchar2)      --R16000_TR_0730 Appare se 1.1.1.3.7.2.1_Dist. max assi= TSI not compliant
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'TSI NOT COMPLIANT'  Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_2_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.3 - CTD_MinDistConsecutiveAxles / Minimum permitted distance between two consecutive axles 
-- Distanza minima consentita tra due assi consecutivi
-- Il parametro 1.1.1.3.7.3 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [rilevatore di ruota].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_3 (p_value_padre Varchar2)      --R16000_TR_0740 appare se  R16000_TR_0710=Wheel detector
   Return Varchar2 Is
 Begin
    If Upper(p_value_padre) = 'WHEEL DETECTOR' Then
       Return 'Y';
    Else
       Return 'N';
    End If;
 End GetAP_1_1_1_3_7_3;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.4 - CTD_MinDistFirstLastAxles / Minimum permitted distance between first and last axle 
-- Distanza minima consentita tra il primo e l'ultimo asse
-- Il parametro 1.1.1.3.7.4 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [circuito di binario]
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_4 (p_value_padre Varchar2)      --R16000_TR_0750 appare se  R16000_TR_0710=Track circuit
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'TRACK CIRCUIT' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_4;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.5 - CTD_MaxDistEndTrainFirstAxle / Maximum distance between end of train and first axle 
-- Distanza massima tra la fine del treno e il primo asse
-- Il parametro 1.1.1.3.7.5 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [rilevatore di ruota] o [circuito di binario].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_5 (p_value_padre Varchar2)      --R16000_TR_0760 appare se  R16000_TR_0710=Track circuit or R16000_TR_0710=Wheel Detector
   Return Varchar2 Is
 Begin
     If (Upper(p_value_padre) = 'TRACK CIRCUIT' or Upper(p_value_padre) = 'WHEEL DETECTOR') Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_5;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.6 - CTD_MinRimWidth / Minimum permitted width of the rim - Larghezza minima consentita della corona
-- Il parametro 1.1.1.3.7.6 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [rilevatore di ruota]
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_6 (p_value_padre Varchar2)      --R16000_TR_0770 appare se  R16000_TR_0710=Wheel detector
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'WHEEL DETECTOR' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_6;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.7 - CTD_MinWheelDiameter / Minimum permitted wheel diameter - Diametro minimo consentito della ruota
-- Il parametro 1.1.1.3.7.7 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [rilevatore di ruota]
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_7 (p_value_padre Varchar2)      --R16000_TR_0780 appare se  R16000_TR_0710=Wheel detector
   Return Varchar2 Is
 Begin
    If Upper(p_value_padre) = 'WHEEL DETECTOR' Then
       Return 'Y';
    Else
       Return 'N';
    End If;
 End GetAP_1_1_1_3_7_7;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.8 - CTD_MinFlangeThickness / Minimum permitted thickness of the flange - Spessore minimo consentito del bordino
-- Il parametro 1.1.1.3.7.8 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [rilevatore di ruota]
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_8 (p_value_padre Varchar2)      --R16000_TR_0790 appare se  R16000_TR_0710=Wheel detector
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'WHEEL DETECTOR' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_8;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.9 - CTD_MinFlangeHeight / Minimum permitted height of the flange - Altezza minima consentita del bordino
-- Il parametro 1.1.1.3.7.9 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” è [rilevatore
-- di ruota].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_9 (p_value_padre Varchar2)      --R16000_TR_0800 appare se  R16000_TR_0710=Wheel detector
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'WHEEL DETECTOR' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_9;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.10 - CTD_MaxFlangeHeight / Maximum permitted height of the flange - Altezza massima consentita del bordino
-- Il parametro 1.1.1.3.7.10 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [rilevatore di ruota]. Valore = [36.0]
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_10 (p_value_padre Varchar2)      --R16000_TR_0810 appare se  R16000_TR_0710=Wheel detector
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'WHEEL DETECTOR' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_10;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.11 - CTD_MinAxleLoad / Minimum permitted axle load - Carico minimo consentito per asse
-- (CANCELLATO) Il parametro 1.1.1.3.7.11 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [rilevatore di ruota] o [circuito di binario].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_11 (p_value_padre Varchar2)      --R16000_TR_0760 appare se  R16000_TR_0710=Track circuit or R16000_TR_0710=Wheel Detector
   Return Varchar2 Is
 Begin
     If (Upper(p_value_padre) = 'TRACK CIRCUIT' or Upper(p_value_padre) = 'WHEEL DETECTOR') Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_11;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.11.1 - CTD_ MinAxleLoadByVehicleCat  / Minimum permitted axle load per category of Vehicle 
-- (NUOVO) Carico minimo consentito per asse per categoria di veicoli
-- Il parametro 1.1.1.3.7.11.1 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [rilevatore di ruota] o [circuito di binario]. Valore = [5.0]
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_11_1 (p_value_padre Varchar2)      --R16000_TR_0760 appare se  R16000_TR_0710=Track circuit or R16000_TR_0710=Wheel Detector
   Return Varchar2 Is
 Begin
     If (Upper(p_value_padre) = 'TRACK CIRCUIT' or Upper(p_value_padre) = 'WHEEL DETECTOR') Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_11_1;
--
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.12 - CTD_TSIMetalFree / TSI compliance of rules for metal-free space around wheels 
-- Conformità alla STI delle norme relative a uno spazio privo di metallo attorno alle ruote
-- Il parametro 1.1.1.3.7.12 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [rilevatore di ruota].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_12 (p_value_padre Varchar2)      --R16000_TR_0830 appare se R16000_TR_0710=Wheel detector
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'WHEEL DETECTOR' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_12;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.13 - CTD_TSIMetalConstruction / TSI compliance of rules for vehicle metal construction 
-- Conformità alla STI delle norme sulla costruzione metallica del veicolo
-- Il parametro 1.1.1.3.7.13 è applicabile solo quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [loop] --> NA
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_13 (p_value_padre Varchar2)      --R16000_TR_0830 appare se R16000_TR_0710=Wheel detector
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'LOOP' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_13;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.14 - CTD_TSIFerroWheelMat / TSI compliance of Ferromagnetic characteristics of wheel material required 
-- Conformità alla STI delle caratteristiche ferromagnetiche richieste per il materiale costitutivo delle ruote
-- Il parametro 1.1.1.3.7.14 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [rilevatore di ruota].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_14 (p_value_padre Varchar2)      --R16000_TR_0850 appare se  R16000_TR_0710=Wheel detector
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'WHEEL DETECTOR' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_14;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.15.1 - CTD_TSIMaxImpedanceWheelset / TSI compliance of maximum permitted impedance between opposite wheels of a wheelset 
-- Conformità alla STI della massima impedenza consentita tra ruote opposte di una sala montata
-- Il parametro 1.1.1.3.7.15.1 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [circuito di binario].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_15_1 (p_value_padre Varchar2)      --R16000_TR_0860 appare se  R16000_TR_0710=Track circuit
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'TRACK CIRCUIT' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_15_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.15.2	CTD_MaxImpedanceWheelset / Maximum permitted impedance between opposite wheels of a wheelset when not TSI compliant 
-- Massima impedenza consentita tra ruote opposte di una sala montata in caso di non conformità alla STI
-- Il parametro 1.1.1.3.7.15.2 è applicabile quando il valore del parametro 1.1.1.3.7.15.1 – Massima impedenza autorizzata tra ruote opposte di
-- una sala sia [Non conforme alla STI].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_15_2 (p_value_padre Varchar2)      --R16000_TR_0870 appare se R16000_TR_0860=TSI not compliant
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'TSI NOT COMPLIANT'  Then          --errore nel file excel di Loretoni / Schillaci 28/05/2015 (invertito il significato rispetto alle LG)
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_15_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.16	CTD_TSISand / TSI compliance of sanding 
-- (CANCELLATO) Conformità alla STI della sabbiatura
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_16 (p_value_padre Varchar2)      --R16000_TR_0880 appare se R16000_TR_0710=Track circuit
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'TRACK CIRCUIT' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_16;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.17 - CTD_MaxSandOutput / Maximum amount of sand - Quantità massima di sabbia 
-- Il parametro 1.1.1.3.7.17 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [circuito di binario]. prima era:
-- Questo parametro è applicabile solo quando il valore del parametro 1.1.1.3.7.16 sia =[Non conforme alla STI] o []
-- CAMBIARE IL VALUE_PADRE
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_17 (p_value_padre Varchar2)      --R16000_TR_0910 appare se R16000_TR_0880=TSI not compliant
   Return Varchar2 Is
 Begin
--     If Upper(p_value_padre) =  'TSI NOT COMPLIANT' Then
     If Upper(p_value_padre) = 'TRACK CIRCUIT' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_17;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.18 - CTD_SandDriverOverride / Sanding override by driver required 
-- Necessità di disattivazione del dispositivo di sabbiatura ad opera del macchinista
-- Il parametro 1.1.1.3.7.18 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [circuito di binario].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_18 (p_value_padre Varchar2)      --R16000_TR_0920 appare se  R16000_TR_0710=Track circuit
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'TRACK CIRCUIT' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_18;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.19 - CTD_TSISandCharacteristics / TSI Compliance of rules on sand characteristics 
-- Conformità alla STI delle norme sulle caratteristiche della sabbia
-- Il parametro 1.1.1.3.7.19 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [circuito di binario].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_19 (p_value_padre Varchar2)      --R16000_TR_0930 appare se  R16000_TR_0710=Track circuit
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'TRACK CIRCUIT' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_19;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.20 - CTD_FlangeLubeRules / Existence of rules on on-board flange lubrication 
-- Esistenza di norme sulla lubrificazione del bordino a bordo
-- Il parametro 1.1.1.3.7.20 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [circuito di binario].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_20 (p_value_padre Varchar2)      --R16000_TR_0940 appare se  R16000_TR_0710=Track circuit
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'TRACK CIRCUIT' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_20;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.21 - CTD_TSICompositeBrakeBlocks / TSI compliance of rules on the use of composite brake blocks 
-- Conformità alla STI delle norme sull'uso dei ceppi dei freni in materiale composito
-- Il parametro 1.1.1.3.7.21 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [circuito di binario].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_21 (p_value_padre Varchar2)      --R16000_TR_0950 appare se  R16000_TR_0710=Track circuit
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'TRACK CIRCUIT' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_21;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.22 - CTD_TSIShuntDevices / TSI compliance of rules on shunt assisting devices 
-- Conformità alla STI delle norme sui dispositivi di assistenza allo shunt
-- Il parametro 1.1.1.3.7.22 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [circuito di binario].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_22 (p_value_padre Varchar2)      --R16000_TR_0960 appare se R16000_TR_0710=Track circuit
   Return Varchar2 Is
 Begin
     If p_value_padre = 'TRACK CIRCUIT' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_22;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.7.23 - CTD_TSIRSTShuntImpedance/ TSI compliance of rules on combination of RST characteristics influencing shunting impedance 
-- Conformità alla STI delle norme sulle combinazioni di caratteristiche del materiale rotabile che influenzano l'impedenza di shunt
-- Il parametro 1.1.1.3.7.23 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [circuito di binario].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_7_23 (p_value_padre Varchar2)      --R16000_TR_0970 appare se R16000_TR_0710=Track circuit
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'TRACK CIRCUIT' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_7_23;
-- ======================================================================================
-- 1.1.1.3.8 - CTS / Transitions between systems - Transizioni tra sistemi
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.8.1 - CTS_SwitchProtectControlWarn / Existence of switch over between different protection, control and warning systems while running 
-- Esistenza di transizione tra diversi sistemi di protezione, controllo e allerta con treno in movimento
-- AP: Il parametro è applicabile quando sono presenti almeno due sistemi di protezione della marcia
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_8_1 (p_value_figlio Varchar2) 
   Return Varchar2 Is
 Begin
     If p_value_figlio Is Not Null Then                  -- VERIFICARE CON RFI
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_8_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.8.2 - CTS_SwitchRadioSystem / Existence of switch over between different radio systems 
-- Esistenza di commutazione tra sistemi radio diversi
-- AP: Il parametro è applicabile quando nella sezione di linea sono presenti almeno due sistemi radio diversi e la commutazione da
-- un sistema all’altro viene effettuata in movimento, determinando un’inaccessibilità temporanea al servizio di comunicazione
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_8_2 (p_value_figlio Varchar2) 
   Return Varchar2 Is
 Begin
     If p_value_figlio Is Not Null Then                 -- VERIFICARE CON RFI
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_8_2;
-- ======================================================================================
-- 1.1.1.3.9 - CEI / Parameters related to electromagnetic interferences - Parametri relativi alle interferenze elettromagnetiche
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.9.1 - CEI_TSIMagneticFields / Existence and TSI compliance of rules for magnetic fields emitted by a vehicle 
-- Esistenza e conformità alla STI di norme relative ai campi magnetici emessi da un veicolo
-- Il parametro 1.1.1.3.9.1 è applicabile quando il valore del parametro 1.1.1.3.7.1.1 “Tipo di sistema di localizzazione dei treni” 
-- è [rilevatore di ruota].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_9_1 (p_value_padre Varchar2)      --R16000_TR_1000 appare se R16000_TR_0710=Wheel detector
   Return Varchar2 Is
 Begin
     If Upper(p_value_padre) = 'WHEEL DETECTOR' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_9_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.9.2 - CEI_TSITractionHarmonics / Existence and TSI compliance of limits in harmonics in the traction current of vehicles 
-- Esistenza e conformità alla STI di limiti nelle armoniche nella corrente di trazione dei veicoli
-- Il parametro 1.1.1.3.9.2 è applicabile quando il valore del parametro 1.1.1.3.7.1(.1) “Tipo di sistema di localizzazione dei treni” 
-- è [circuito di binario] o [rilevatore di ruota].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_9_2 (p_value_padre Varchar2)      --R16000_TR_1000 appare se R16000_TR_0710=Wheel detector
   Return Varchar2 Is
 Begin
     If (Upper(p_value_padre) = 'WHEEL DETECTOR' Or Upper(p_value_padre) = 'TRACK CIRCUIT') Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_9_2;
-- ======================================================================================
-- 1.1.1.3.10 CLD / Line-side system for degraded situation - Sistema di terra per situazioni degradate
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.10.1 - CLD_ETCSSituation / ETCS level for degraded situation - Livello ETCS per situazioni degradate
-- Il parametro 1.1.1.3.10.1 non è applicabile quando il parametro 1.1.1.3.2.1 sia valorizzato con [N].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_10_1 (p_value_padre Varchar2)      --R16000_TR_1020 non appare se R16000_TR_0570=N
   Return Varchar2 Is
 Begin
     If p_value_padre = 'N' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_3_10_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.10.2 - CLD_OtherProtectControlWarn / Other train protection, control and warning systems for degraded situation 
-- Altri sistemi di protezione, controllo e allerta in caso di situazioni degradate
-- Il parametro 1.1.1.3.10.2 è applicabile quando il parametro 1.1.1.3.10.1 sia valorizzato con [nessuno]. 
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_10_2 (p_value_padre Varchar2)      --R16000_TR_1030 appare se  R16000_TR_0570<>N   R16000_TR_1020=none
   Return Varchar2 Is
 Begin
-- 17/05/2016   modificato secondo nuovi algortimi INE R16000_TR_1030 non appare se R16000_TR_0570 = N
     If p_value_padre = 'NONE' Then               -- modificato il 19/07/2021 a seguito della segnalazione con mail del 09/07/2021 di Piantedosi
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_10_2;
-- ======================================================================================
-- 1.1.1.3.11 CBP / Brake related parameters - Parametri relativi ai freni
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.11.1 - CBP_MaxBrakeDist / Maximum braking distance requested - Distanza massima di frenatura richiesta - AP=Y 
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_11_1 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'Y';
  End GetAP_1_1_1_3_11_1;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.11.2	- CBP_AddInfoAvailable / Availability by the IM of additional information - AP=Y 
--               (NUOVO) Disponibilità di informazioni supplementari da parte del GI
-- --------------------------------------------------------------------------------------
  Function GetAP_1_1_1_3_11_2 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'Y';
  End GetAP_1_1_1_3_11_2;
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.11.3	- CBP_BrakePerfDocRef/ Documents available by the IM relating to braking performance 
--               (NUOVO) Documenti sulle prestazioni di frenata messi a disposizione dal GI
-- AP: Il parametro è applicabile quando il parametro 1.1.1.3.11.2 è valorizzato con [S]. Nel caso di RFI il parametro 1.1.1.3.11.1 è
-- sempre valorizzato con [S], pertanto il parametro è sempre applicabile
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_11_3 (p_value_padre Varchar2)  
   Return Varchar2 Is
 Begin
     If p_value_padre = 'Y' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_3_11_3;
-- ======================================================================================
-- 1.1.1.3.12 - COP / Other CCS related parameters - Altri parametri associati al CCS
-- --------------------------------------------------------------------------------------
-- 1.1.1.3.12.1 - COP_Tilting / Indication whether titling functions are supported by ETCS 
-- Assetto variabile supportato (Parametro cancellato)
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_3_12_1 (p_value_padre Varchar2)      --R16000_TR_1050 appare se  R16000_TR_0570<>N
   Return Varchar2 Is
 Begin
     If p_value_padre = 'N' Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_1_1_3_12_1;
-- ======================================================================================
-- 1.1.1.4 - Rules and restriction - Norme e restrizioni
-- --------------------------------------------------------------------------------------
-- 1.1.1.4.1 - RUL_LocalRulesOrRestrictions / Existence of rules and restrictions of a strictly local nature 
-- (NUOVO) Esistenza di norme e restrizioni di natura strettamente locale - AP=Y
-- --------------------------------------------------------------------------------------
Function GetAP_1_1_1_4_1 --(p_value_padre Varchar2)      --R16000_TR_1050 appare se  R16000_TR_0570<>N
   Return Varchar2 Is
 Begin
--     If p_value_padre = 'Y' Then
        Return 'Y';
--     Else
--        Return 'N';
--     End If;
 End GetAP_1_1_1_4_1;
--
-- --------------------------------------------------------------------------------------
-- 1.1.1.4.2 - RUL_LocalRulesOrRestrictionsDocRef /Reference of the documentsDocuments regarding the rules or restrictions of a strictly local nature available by the IM 
-- (NUOVO) Documenti relativi a norme e restrizioni di natura strettamente locale messi a disposizione dal GI
-- AP: Il parametro è applicabile quando il valore del parametro 1.1.1.4.1“Esistenza di norme e restrizioni di natura strettamente locale” è [S] 
-- --------------------------------------------------------------------------------------
 Function GetAP_1_1_1_4_2 (p_value_padre Varchar2)      --R16000_TR_1050 appare se  R16000_TR_0570<>N
   Return Varchar2 Is
 Begin
     If p_value_padre = 'Y' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_1_1_4_2;
--
--
-- ====================================================================================== 
-- 1.2	OPERATIONAL POINT - PUNTO OPERATIVO
-- --------------------------------------------------------------------------------------
-- 1.2.0.0.0	Generic information - Informazioni generali
-- 1.2.0.0.0.1 - OPName / Name of Operational point - Nome del punto operativo - AP=Y
-- 1.2.0.0.0.2 - UniqueOPID /Unique OP ID - Identificazione unica del punto operativo - AP=Y
-- 1.2.0.0.0.3 - OPTafTapCode / OP TAF TAP primary code - Codice primario TAF/TAP del punto operativo - AP=Y (se esiste il codice TAF/TAP)
-- 1.2.0.0.0.4 - OPType / Type of Operational Point - Tipo di punto operativo AP=Y
-- --------------------------------------------------------------------------------------
-- 1.2.0.0.0.4.1 - OPTypeGaugeChangeover / Type of track gauge changeover facility 
--                  (NUOVO) Tipo di dispositivo per consentire il passaggio fra scartamenti di binario nominali diversi
-- AP: Il parametro è applicabile solo nelle località di servizio di confine con gestori nazionali aventi scartamento nominale diverso
--  da quello di RFI e in presenza di binari con doppio scartamento - Il parametro, se applicabile, può assumere solo il valore 
-- [Apparecchio di penetrazione a doppio scartamento]
-- Qualora il parametro [1.2.0.0.0.4 – Tipo di Punto operativo] sia valorizzato <> [punto di confine nazionale], questo parametro risulta [non applicabile]
-- --------------------------------------------------------------------------------------
-- Function GetAP_1_2_0_0_0_4_1 (p_value_padre Varchar2, p_value_figlio Varchar2)      
 Function GetAP_1_2_0_0_0_4_1 (p_value_figlio Varchar2)      
   Return Varchar2 Is
 Begin
--     If (lower(p_value_padre) <> 'border point' Or upper(p_value_figlio) = 'NA') Then  --  90: 'Border point' - 'PUNTO DI CONFINE NAZIONALE'  -- 140: 'Domestric Border Point' 
     If upper(p_value_figlio) = 'NA' Then  --  90: 'Border point' - 'PUNTO DI CONFINE NAZIONALE'  -- 140: 'Domestric Border Point' 
	    Return 'N';           
     ElsIf p_value_figlio Is Not Null Then             -- 'Double gauge device'
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_2_0_0_0_4_1;
-- --------------------------------------------------------------------------------------
-- 1.2.0.0.0.5 - OPGeographicLocation / Geographical location of Operational Point - Localizzazione geografica del punto operativo - AP=Y 
-- 1.2.0.0.0.6 - OPRailwayLocation / Railway location of Operational point - Localizzazione ferroviaria del punto operativo - AP=Y 
--
-- ====================================================================================== 
-- 1.2.1	OPTrack / RUNNING TRACK - BINARIO DI CIRCOLAZIONE
-- 1.2.1.0.0 - Generic information - Informazioni generali
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.0.1 - OPTrackIMCode / IM’s Code - Codice del GI - AP=Y
-- 1.2.1.0.0.2 - OPTrackIdentification / Identification of track - Identificazione del binario - AP=Y
-- ====================================================================================== 
-- 1.2.1.0.1 - IDE / Declarations of verification for track - Dichiarazioni di verifica del binario
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.1.1 - IDE_ECVerification / EC declaration of verification for track (INF)- Dichiarazione CE di verifica del binario relativa alla conformità ai requisiti delle STI applicabili al sottosistema «infrastruttura»
-- 1.2.1.0.1.2 - IDE_EIDemonstration / EI declaration of demonstration for track (INF) - Dichiarazione di dimostrazione IE (definita dalla raccomandazione 2014/881/UE della Commissione) relativa alla conformità ai requisiti delle STI applicabili al sottosistema «infrastruttura»
--
-- ====================================================================================== 
-- 1.2.1.0.2 - IPP / Performance parameters - Parametri di prestazione
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.2.1 - IPP_TENClass / TEN classification of track - Classificazione TEN del binario - AP=Y
-- ====================================================================================== 
-- 1.2.1.0.2.2 - IPP_LineCat / Category of Line - Categoria della linea AP=Y 
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.2.3 - IPP_FreightCorridor / Part of a Railway freight corridor - Parte di un corridoio ferroviario merci
-- Il parametro 1.2.1.0.2.3 è applicabile se il binario di circolazione appartiene a un corridoio ferroviario merci.
-- 7/11/2016 è stato cambiato il calcolo dell'applicabilità per gestire correttamente i binari di fermata.
-- Se un binario è di tipo TR, il calcolo dei corridoi deve essere fatto sulla tabella PIC_CORRIDOIOMERCI_TRATTA,
-- se è di tipo LO va fatto sulla tabella PIC_CORRIDOIOMERCI_LOCALITA.
-- Il filtro PO_TRACK_1_2_1_0_0_2 LIKE 'LO%' è necessario per evitare di effettuare un calcolo errato per i binari TR, perchè anche i binari TR sono
-- presenti nella tabella REL_PO_BINARI_CORSA.
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_1_0_2_3 (p_value_padre Varchar2)          --APPLICABILITA' CORRIDOIO MERCI
   Return Varchar2 Is
          n_conta Number;
 Begin
     Select Count (CODICEGIURISDIZIONE)
       Into n_conta
       From (Select CODICEGIURISDIZIONE
               From Rinf_Staging_Evo.PIC_CORRIDOIOMERCI_LOCALITA l,
                    Rinf_Staging_Evo.PIC_LOCALITACIRCINFR t,
               (Select id_localita, id_binario
                  From (Select b.SEDE_TECNICA id_localita,
                               l.DEFINIZIONE desc_localita,
                               PO_TRACK_1_2_1_0_0_2 id_binario,
                               PO_TRACK_1_2_1_0_0_2_D desc_binario,
                               l.CODICE_DTP id_dtp
                          From Rinf_Staging_Evo.CLASSE_R16000_LO b,
                               Rinf_Lavorazione_Evo.PUNTI_OPERATIVI l
                         Where l.SEDE_TECNICA = b.SEDE_TECNICA
                           And PO_TRACK_1_2_1_0_0_2 Is Not Null
                           And Length(PO_TRACK_1_2_1_0_0_2) >= 14
                        Union
                        Select l.SEDE_TECNICA id_localita,
                               l.DEFINIZIONE desc_localita,
                               PO_TRACK_1_2_1_0_0_2 id_binario,
                               PO_TRACK_1_2_1_0_0_2_D desc_binario,
                               l.CODICE_DTP id_dtp
                          From Rinf_Staging_Evo.CLASSE_R16000_LO_TR b,
                               Rinf_Lavorazione_Evo.PUNTI_OPERATIVI l,
                               Rinf_Staging_Evo.CLASSE_R16000_LO_MULTIPLA m
                         Where m.IDENTIFICATIVO_BINARIO = b.PO_TRACK_1_2_1_0_0_2
                           And CODICE_CARATTERISTICA = 'R16000_LO_SFER'
                           And l.sede_tecnica = VALORE_CARATTERISTICA
                           And b.PO_TRACK_1_2_1_0_0_2 Is Not Null
                           And Length(b.PO_TRACK_1_2_1_0_0_2) >= 14
						   )
				  ) rel
             Where Rel.ID_BINARIO Like 'LO%'
               And Rel.ID_BINARIO = p_value_padre
               And l.CODICELOCALITA = t.CODICELOCALITAPIC
               And t.CODICELOCALITAIR2K = rel.ID_LOCALITA
               And Nvl (t.DATAINIZIOVALIDITA, To_Date ('01011999', 'DDMMYYYY')) <= SysDate
               And Nvl (t.DATAFINEVALIDITA,   To_Date ('01012999', 'DDMMYYYY')) >=  SysDate
        Union
        Select CODICEGIURISDIZIONE
          From Rinf_Staging_Evo.PIC_CORRIDOIOMERCI_TRATTA l,
               Rinf_Staging_Evo.PIC_PERCORSIINFR t
             Where t.CODICETRATTA = t.CODICETRATTA
               And t.CODICETRATTAIR2K = Substr(p_value_padre, 1, 6)
               And Nvl(t.DATAINIZIOVALIDITA, To_Date ('01011999', 'DDMMYYYY')) <= SysDate
               And Nvl(t.DATAFINEVALIDITA,   To_Date ('01012999', 'DDMMYYYY')) >= SysDate);
--
     If n_conta > 0 Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_2_1_0_2_3;
--
-- ====================================================================================== 
-- 1.2.1.0.3 - ILL / Line layout - Tracciato della linea
-- 1.2.1.0.3.1 - ILL_InteropGauge / Interoperable gauge - (CANCELLATO) Sagoma interoperabile
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.3.2 - ILL_MultiNatGauge / Multinational gauges - (CANCELLATO) Sagome multinazionali
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_1_0_3_2 (p_value_padre Varchar2)      --R16000_LO_1140 appare se  R16000_LO_1130=none
   Return Varchar2 Is
 Begin
     If p_value_padre = 'NONE' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_2_1_0_3_2;
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.3.3 - ILL_NatGauge / National gauges - (CANCELLATO) Sagome nazionali
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_1_0_3_3 (p_value_padre_1 Varchar2, p_value_padre_2 Varchar2)      --R16000_TR_0150 appare se R16000_TR_0130 = none   R16000_TR_0140 = none
   Return Varchar2 Is
 Begin
     If p_value_padre_1 = 'NONE' And p_value_padre_2 = 'NONE' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_2_1_0_3_3;
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.3.4 - ILL_Gauging_/ Gauging - (NUOVO) Sagoma - AP=Y
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.3.5	ILL_GaugeCheckLoc/Railway location of particular points requiring specific checks 
-- (NUOVO) Localizzazione ferroviaria di punti particolari che richiedono verifiche specifiche AP=N
-- --------------------------------------------------------------------------------------
  Function GetAP_1_2_1_0_3_5 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'N';
  End GetAP_1_2_1_0_3_5;
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.3.6 - ILL_GaugeCheckDocRef /Document with the transversal section of the particular points requiring specific checks 
-- (NUOVO) Documento che riporta la sezione trasversale di punti particolari che richiedono verifiche specifiche - AP=N
-- --------------------------------------------------------------------------------------
  Function GetAP_1_2_1_0_3_6 --(p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
       Return 'N';
  End GetAP_1_2_1_0_3_6;

-- ====================================================================================== 
-- 1.2.1.0.4 ITP / Track Parameters - Parametri del binario
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.4.1 - ITP_NomGauge / Nominal track gauge - Scartamento nominale - AP=Y
-- ====================================================================================== 
-- 1.2.1.0.5 - OPTrackTunnel / Tunnel - Galleria
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.5.1 - OPTrackTunnelIMCode / IM’s Code - Codice del GI - AP=Y
-- 1.2.1.0.5.2 - OPTrackTunnelIdentification / Tunnel identification - Identificazione della galleria- AP=Y
-- 1.2.1.0.5.3 - ITU_ECVerification / EC declaration of verification for tunnel (SRT) 
--               Dichiarazione CE di verifica della galleria relativa alla conformità ai requisiti delle STI applicabili alle gallerie ferroviarie
-- 1.2.1.0.5.4 - ITU_EIDemonstration / EI declaration of demonstration for tunnel (SRT) 
--               Dichiarazione di dimostrazione IE (definita dalla raccomandazione 2014/881/UE della Commissione) per la galleria relativa alla conformità ai requisiti delle STI applicabili alle gallerie ferroviarie
-- 1.2.1.0.5.5 - ITU_Length / Length of tunnel - Lunghezza della galleria - AP=Y
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.5.6 - ITU_EmergencyPlan / Existence of emergency plan - Esistenza del piano di emergenza - MODIFICATO:
-- Il parametro 1.2.1.0.5.6 è applicabile per gallerie aventi lunghezza maggiore o uguale a 1000 m.
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_1_0_5_6 (p_value_padre Number)      --R25350_LO_0180 appare se S25350_0001>1000
   Return Varchar2 Is
 Begin
 --    If p_value_padre > 1000  Then
       Return 'Y';                                        -- 18/03/2021 - il parametro è sempre Applicabile
 --    Else
 --        Return 'N';
 --    End If; 
 End GetAP_1_2_1_0_5_6;

-- --------------------------------------------------------------------------------------
-- 1.2.1.0.5.7 - ITU_FireCatReq / Fire category of rolling stock required - Categoria di sicurezza antincendio richiesta per il materiale rotabile
-- Il parametro 1.2.1.0.5.7 è applicabile per gallerie aventi lunghezza maggiore o uguale a 1000 m.
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_1_0_5_7 (p_value_padre Number)      --R25350_LO_0180 appare se S25350_0001>1000
   Return Varchar2 Is
 Begin
     If p_value_padre < 1000 Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_2_1_0_5_7;
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.5.8 - ITU_NatFireCatReq / National fire category of rolling stock required 
-- Categoria di sicurezza antincendio nazionale richiesta per il materiale rotabile
-- Il parametro 1.2.1.0.5.8 è applicabile per gallerie aventi lunghezza maggiore o uguale a 1000 m 
-- e quando il parametro 1.2.1.0.5.7 è valorizzato con “nessuna”.
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_1_0_5_8 (p_value_padre_1 Number, p_value_padre_2 Varchar2)      --R25350_LO_0190 Appare se  S25350_0001>=1000    R25350_LO_0100 = none
   Return Varchar2 Is
 Begin
     If p_value_padre_1 >= 1000 And lower(p_value_padre_2) = 'none' Then -- 30='NONE' 
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_2_1_0_5_8;
-- --------------------------------------------------------------------------------------
-- 1.2.1.0.5.9 - ITU_ThermAllowed/Diesel or other thermal traction allowed 
-- (NUOVO) Trazione diesel o altri sistemi di trazione termica consentiti - AP=N (Dipende se 1.2.1.0.5.7 = 'none' --> AP='Y')
-- Explanation on applicability:
-- ‘N’= not applicable shall be selected when respective national rules do not exist
-- ‘Y’= only for tunnels when for the parameter 1.2.1.0.5.7 the option ‘none’ was selected.
-- --------------------------------------------------------------------------------------
  Function GetAP_1_2_1_0_5_9 (p_value_padre Varchar2)          
    Return Varchar2 is
  Begin
     If lower(p_value_padre) = 'none' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
  End GetAP_1_2_1_0_5_9; 
-- ====================================================================================== 
--1.2.1.0.6 OPTrackPlatform / Platform - Marciapiede
-- --------------------------------------------------------------------------------------
--1.2.1.0.6.1 - OPTrackPlatformIMCode / IM’s Code - Codice del GI - AP=Y
--1.2.1.0.6.2 - OPTrackPlatformIdentification / Identification of platform - Identificazione del marciapiede - AP=Y
--1.2.1.0.6.3 - IPL_TENClass / TEN Classification of platform - Classificazione TEN del marciapiede - AP=Y
--1.2.1.0.6.4 - IPL_Length / Usable length of platform - Lunghezza utile del marciapiede - AP=Y
--1.2.1.0.6.5 - IPL_Height / Height of platform - Altezza del marciapiede - AP=Y
--1.2.1.0.6.6 - IPL_AssistanceStartingTrain / Existence of platform assistance for starting train 
--              Esistenza di assistenza sul marciapiede per la partenza del treno - AP=Y
--1.2.1.0.6.7 - IPL_AreaBoardingAid / Area of use of the platform boarding aid 
--              Campo di utilizzo del dispositivo di ausilio per l'accesso a bordo - AP=Y
--
-- ====================================================================================== 
-- 1.2.2	OPSiding / SIDING - BINARIO DI RACCORDO
-- --------------------------------------------------------------------------------------
-- 1.2.2.0.0 - Generic information - Informazioni generali
-- 1.2.2.0.0.1 - IM’s Code / IM’s Code - Codice del GI - AP=Y
-- 1.2.2.0.0.2 - OPSidingIdentification / Identification of siding - Identificazione del binario di raccordo - AP=Y
-- 1.2.2.0.0.3 - IPP_TENClass / TEN classification of siding - Classificazione TEN del binario di raccordo - AP=Y
-- 
-- ====================================================================================== 
-- 1.2.2.0.1 - IDE / Declaration of verification for siding - Dichiarazione di verifica del binario di raccordo
-- --------------------------------------------------------------------------------------
-- 1.2.2.0.1.1 - IDE_ECVerification / EC declaration of verification for siding (INF) 
--               Dichiarazione CE di verifica del binario di raccordo relativa alla conformità ai requisiti delle STI applicabili al sottosistema «infrastruttura»
-- 1.2.2.0.1.2 - IDE_EIDemonstration / EI declaration of demonstration for siding (INF) 
--               Dichiarazione di dimostrazione IE (definita dalla raccomandazione 2014/881/UE della Commissione) per il binario di raccordo relativa alla conformità ai requisiti delle STI applicabili al sottosistema «infrastruttura»
-- 
-- ====================================================================================== 
-- 1.2.2.0.2 - IPP / Performance parameter - Parametro di prestazione
-- --------------------------------------------------------------------------------------
-- 1.2.2.0.2.1 - IPP_Length / Usable length of siding - Lunghezza utile del binario di raccordo - AP=Y
-- 
-- ====================================================================================== 
-- 1.2.2.0.3 - Line layout - Tracciato della linea
-- --------------------------------------------------------------------------------------
-- 1.2.2.0.3.1 - ILL_Gradient / Gradient for stabling tracks - Pendenza per i binari di ricovero
-- AP: Il parametro deve essere valorizzato se la pendenza è maggiore di 2.5 mm/m.
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_2_0_3_1 (p_value_figlio Number) 
   Return Varchar2 Is
 Begin
     If p_value_figlio > 2.5 Then 
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_2_2_0_3_1;
-- --------------------------------------------------------------------------------------
-- 1.2.2.0.3.2 - ILL_MinRadHorzCurve / Minimum radius of horizontal curve - Raggio minimo di curvatura orizzontale
-- (MODIFICATO) Il parametro deve essere valorizzato se il raggio di curvatura orizzontale è minore di 150 m. 
-- Per RFI il parametro è sempre non applicabile. [999]
-- manca nel file excel; se arriva raggio di curvatura orizzontale a 999, è non applicabile
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_2_0_3_2 (p_value_figlio Number)      
   Return Varchar2 Is
 Begin
     If p_value_figlio = 999 Then   --Or p_value_figlio Is Null 
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_2_2_0_3_2;
-- --------------------------------------------------------------------------------------
-- 1.2.2.0.3.3 - ILL_MinRadVertCurve / Minimum radius of vertical curve - Raggio minimo di curvatura verticale
-- (MODIFICATO) Questo parametro è applicabile se il valore del raggio verticale è inferiore ai limiti previsti nelle STI INF
-- Per RFI il parametro è sempre non applicabile. [999]+[999]
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_2_0_3_3 (p_value_concava Number, p_value_convessa Number)      --manca nel file excel; se arrivano entrambe le curve verticali a 999, è non applicabile, se ne arriva solo una è applicabile
   Return Varchar2 Is
 Begin
     If p_value_concava = 999 And p_value_convessa = 999 Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_2_2_0_3_3;
--
-- ====================================================================================== 
-- 1.2.2.0.4 ITS / Fixed installations for servicing trains - Impianti fissi per la manutenzione dei treni
-- --------------------------------------------------------------------------------------
-- 1.2.2.0.4.1 - ITS_ToiletDischarge / Existence of toilet discharge - Esistenza di sistemi di scarico dei servizi igienici - AP=Y 
-- 1.2.2.0.4.2 - ITS_ExternalCleaning / Existence of external cleaning facilities - Esistenza di impianti di pulizia esterna - AP=Y 
-- 1.2.2.0.4.3 - ITS_WaterRestocking / Existence of water restocking - Esistenza di impianti di rifornimento di acqua - AP=Y 
-- 1.2.2.0.4.4 - ITS_Refuelling / Existence of refuelling - Esistenza di impianti di rifornimento di carburante - AP=Y 
-- 1.2.2.0.4.5 - ITS_SandRestocking / Existence of sand restocking - Esistenza di impianti di rifornimento di sabbia - AP=Y 
-- 1.2.2.0.4.6 - ITS_ElectricShoreSupply / Existence of electric shore supply - Esistenza di alimentazione elettrica a terra - AP=Y 
-- 
-- ====================================================================================== 
-- 1.2.2.0.5 OPSidingTunnel / Tunnel - Galleria
-- --------------------------------------------------------------------------------------
-- 1.2.2.0.5.1 - OPSidingTunnelIMCode / IM’s Code - Codice del GI - AP=Y 
-- 1.2.2.0.5.2 - OPSidingTunnelIdentification / Tunnel identification - Identificazione della galleria - AP=Y 
-- 1.2.2.0.5.3 - ITU_ECVerification / EC declaration of verification for tunnel (SRT) 
--               Dichiarazione CE di verifica della galleria relativa alla conformità ai requisiti delle STI applicabili alle gallerie ferroviarie
-- 1.2.2.0.5.4 - ITU_EIDemonstration : EI declaration of demonstration for tunnel (SRT) 
--               Dichiarazione di dimostrazione IE (definita dalla raccomandazione 2014/881/UE della Commissione) per la galleria relativa alla conformità ai requisiti delle STI applicabili alle gallerie ferroviarie
-- 1.2.2.0.5.5 - ITU_Length / Length of tunnel - Lunghezza della galleria - AP=Y 
-- --------------------------------------------------------------------------------------
-- 1.2.2.0.5.6 - ITU_EmergencyPlan / Existence of emergency plan - Esistenza del piano di emergenza - Modificato da AP=Y
-- stessa gestione degli analoghi 1.2.1.0.5.6 e 1.1.1.1.8.9 (ITU_EmergencyPlan) Applicabilità solo se la lunghezza della galleria > 1000 m
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_2_0_5_6 (p_value_padre Number)      --R25350_TR_0100 appare se S25350_0001 > 1000
   Return Varchar2 Is
 Begin
--    If p_value_padre > 1000  Then
       Return 'Y';                                       -- 18/03/2021  -  il parametro è sempre Applicabile
--    Else
--         Return 'N';
--     End If;
 End GetAP_1_2_2_0_5_6;
-- --------------------------------------------------------------------------------------
-- 1.2.2.0.5.7 - ITU_FireCatReq / Fire category of rolling stock required - Categoria di sicurezza antincendio richiesta per il materiale rotabile
-- Il parametro 1.2.2.0.5.7 è applicabile per gallerie aventi lunghezza maggiore o uguale a 1000 m.
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_2_0_5_7 (p_value_padre Number)      --manca nel file excel ma secondo me è uguale a: R25350_LO_0180 appare se S25350_0001>1000
   Return Varchar2 Is
 Begin
     If p_value_padre < 1000 Then
        Return 'N';
     Else
        Return 'Y';
     End If;
 End GetAP_1_2_2_0_5_7;
-- --------------------------------------------------------------------------------------
-- 1.2.2.0.5.8 - ITU_NatFireCatReq / National fire category of rolling stock required - Categoria di sicurezza antincendio nazionale richiesta per il materiale rotabile
--Il parametro 1.2.2.0.5.8 è applicabile per gallerie aventi lunghezza maggiore o uguale a 1000 m 
-- e quando il parametro 1.2.2.0.5.7 è valorizzato con “nessuna”.
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_2_0_5_8 (p_value_padre_1 Number, p_value_padre_2 Varchar2)      --manca nel file excel ma secondo me è uguale a: R25350_LO_0190 Appare se  S25350_0001>=1000    R25350_LO_0100 = none
   Return Varchar2 Is
 Begin
 --17/05/2018  reinserita con l'aggiunta di NC in INE e con l'eliminazione di NA
     If p_value_padre_1 >= 1000 And p_value_padre_2 = '30' Then       -- 30='NONE'
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_2_2_0_5_8;
-- 
-- ====================================================================================== 
-- 1.2.2.0.6	ECS / Contact line system Contact line system - Sistema di linea di contatto
-- --------------------------------------------------------------------------------------
-- 1.2.2.0.6.1	ECS_MaxStandstillCurrent/Maximum current at standstill per pantograph 
--             (NUOVO) Corrente massima a treno fermo per pantografo
-- AP: Il parametro non è applicabile quando il binario secondario non è elettrificato. (=999) mail Schillaci del 7.9.2020
-- Inoltre, se elettrificato, il parametro è applicabile se il binario è elettrificato con un sistema di trazione con tensione nominale
-- pari a 3 kVcc. Il valore di questo parametro, se applicabile, deve essere = [200]
-- --------------------------------------------------------------------------------------
Function GetAP_1_2_2_0_6_1 (p_value_figlio Number)      
   Return Varchar2 Is
 Begin
     If p_value_figlio = 999 Then 
        Return 'N';
     Elsif p_value_figlio = 200 Or p_value_figlio = 300 Then 
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_2_2_0_6_1;

-- ====================================================================================== 
-- 1.2.3	Rules and restriction - Norme e restrizioni
-- --------------------------------------------------------------------------------------
-- 1.2.3.1 - RUL_LocalRulesOrRestrictions / Existence of rules and restrictions of a strictly local nature 
--          (NUOVO) Esistenza di norme e restrizioni di natura strettamente locale AP=Y
 Function GetAP_1_2_3_1 (p_value_figlio Varchar2)      --R16000_TR_0150 appare se R16000_TR_0130 = none   R16000_TR_0140 = none
   Return Varchar2 Is
 Begin
     If (p_value_figlio = 'N' Or p_value_figlio = 'Y') Then
        Return 'Y';
	 Else 
	    Return Null;
	 End If;
 End GetAP_1_2_3_1 ;
--
-- --------------------------------------------------------------------------------------
-- 1.2.3.2 - RUL_LocalRulesOrRestrictionsDocRef /Documents regarding the rules or restrictions of a strictly local nature available by the IM 
--          (NUOVO) Documenti relativi a norme e restrizioni di natura strettamente locale messi a disposizione dal GI
-- AP: Il parametro è applicabile quando il valore del parametro 1.2.3.1“Esistenza di norme e restrizioni di natura strettamente locale” è [S].
-- --------------------------------------------------------------------------------------
 Function GetAP_1_2_3_2 (p_value_padre Varchar2)      --R16000_TR_0150 appare se R16000_TR_0130 = none   R16000_TR_0140 = none
   Return Varchar2 Is
 Begin
     If p_value_padre = 'Y' Then
        Return 'Y';
     Else
        Return 'N';
     End If;
 End GetAP_1_2_3_2 ;
--
End PKG_RINF_APPLICABILITA;
/