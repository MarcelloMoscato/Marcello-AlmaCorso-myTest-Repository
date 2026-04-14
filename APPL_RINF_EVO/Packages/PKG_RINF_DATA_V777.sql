--
-- PKG_RINF_DATA_V777  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_DATA_V777" As
/*******************************************************************************
   NAME:    PKG_RINF_DATA_V777
   PURPOSE: Insieme di procedure per la visualizzazione dei dati RINF
   REVISIONS:
   Version    Date          Author          Description
   --------   ------------  --------------  --------------------------------------------------
   1.0        18/09/2013    D.Campagiorni   1. Package created
   1.1        30/11/2018    E. Petrilli     1. Modifica con l'aggiunta LAM
   1.2        30/03/2020    E. Petrilli     1. Aggiunta nuovi campi per Reg. 777/2019
   1.2.1      23/07/2020    E. Petrilli     1. Gestione lat/long con 7 decimali
                            E. Petrilli     2. Gestione parametro non attivo
   1.3        29/04/2021    E. Petrilli     1. Modfificata gestione del parametro 1.1.1.1.2.4.3
   11.0.1.2   31/12/2025    E. Petrilli  	1. Implementata la gestione della versione GetLatLonFromKm [Bug-Fix]
   11.0.1.2   10/01/2025    E. Petrilli     2. Cursori: Sostituito datatype SQLstring; da Varchar2 a CLOB
   11.1.0.3   15/07/2025    M. Annunzio     1. Modificata gestione del parametro 1.2.1.0.2.3 - IPP_FreightCorridor
                                               BUG-FIX-20250715 - "Parametro autorizzato da due validatori diversi" - Territorio per la LO e DSPS per la TR.  
*******************************************************************************/
--
    TYPE empcur IS REF CURSOR;
--
	FUNCTION GetLastVersion(p_area Number) RETURN Number;
	FUNCTION GetNYA (p_parametro Varchar2) RETURN Varchar2;
	FUNCTION GetXmlValue(p_parametro IN Varchar2, p_valore IN Varchar2) RETURN Varchar2;
	FUNCTION GetDescr(p_parametro IN Varchar2, p_valore IN Varchar2) RETURN Varchar2;
	FUNCTION GetData_validita (P_Parametro Varchar2, P_Data_Riferimento date) RETURN Varchar2;
	FUNCTION GetLatLonFromKM (p_sol Varchar2, p_km Number, p_vers Number, p_dato Number) RETURN Number;
	FUNCTION GetOpValue(p_parametro IN Varchar2, p_valore IN Varchar2) RETURN Varchar2;
-- 	FUNCTION GetSet(p_parametro IN Varchar2, p_valore IN Varchar2, p_appl_padre IN Varchar2) RETURN Varchar2;
--
	PROCEDURE GetAllVersions(p_cursor Out empcur);
	PROCEDURE GetLastVersion (p_area Number, p_versione Out Number);
-- 	da Reg. 777/2019 verifica validita dei parametri dei BINARI_CORSA_SOL 
-- 	SOL
	PROCEDURE GetSOL_General (p_SOL Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
	PROCEDURE Get_validita_binari_corsa (p_AREA Number, p_i_VERSIONE Number, p_CURSOR Out Empcur);
	PROCEDURE GetTracks_General (p_SOL Varchar2, p_AREA Number, p_i_VERSIONE Number, p_CURSOR Out Empcur);
	PROCEDURE GetTracks_Inf_EC (p_Track Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
	PROCEDURE GetTracks_Energy_EC (p_Track Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
	PROCEDURE GetTracks_Control_EC (p_Track Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
	PROCEDURE GetTracks_Inf_Tunnel (p_Track Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
	PROCEDURE GetTracks_Inf_Tunnel_EC (p_Tunnel Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur) ;
--	PO
	PROCEDURE GetOP_General (p_OP Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
--	28/09/2016 Aggiunto il parametro della OP per gestire i marciapiedi delle fermate adiacenti
	PROCEDURE GetOPTracks_Inf_Platform(p_PO Varchar2, p_POTrack Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
--	22/06/2018 Raccordi
	PROCEDURE GetOP_PrivateSiding (p_i_versione Number, p_cursor Out sys_refcursor);
	PROCEDURE GetOPTracks_Infrastructure (p_OP Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
    PROCEDURE GetOPTracks_Inf_EC (p_POTrack Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
	PROCEDURE GetOPTracks_Inf_Tunnel(p_POTrack Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
	PROCEDURE GetOPTracks_Inf_Tunnel_EC(p_POTrack_Tunnel Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
	PROCEDURE GetOPSiding_Infrastructure (p_PO Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
	PROCEDURE GetOPSiding_Inf_EC (p_POSiding Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
	PROCEDURE GetOPSiding_Inf_Tunnel (p_POSiding Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
	PROCEDURE GetOPSiding_Inf_Tunnel_EC (p_POSiding_Tunnel Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur);
--
End PKG_RINF_DATA_V777;
/


--
-- PKG_RINF_DATA_V777  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_DATA_V777" As
-- 	----------------------------------------------------------------------------
-- 	----------------------------------------------------------------------------
-- 	----------------------------------------------------------------------------
-- 	FUNCTIONS
-- 	----------------------------------------------------------------------------
-- 	----------------------------------------------------------------------------
-- 	----------------------------------------------------------------------------
--
-- 	----------------------------------------------------------------------------
--  FUNCTION GetLatLonFromKM 
--  	v.1.4 implementata la gestione della versione
-- 	----------------------------------------------------------------------------
--
	Function GetLatLonFromKM (p_sol Varchar2, p_km Number, p_vers Number, p_dato Number)
		RETURN Number  Is
			n_lat   Number;
			n_lon   Number;
			Vers_Mdr Number;
--
	BEGIN
		--  Se p_dato=1 restituisce la LATITUDINE
		--  Se p_dato=2 restituisce la LONGITUDINE
		--  Se p_dato=3 restituisce il FLAG_CALCOLATO
		--->
		If p_vers > 0 Then 
			Begin 
				Select VERSIONE_MDR into Vers_Mdr 
				From   Rinf_Gis_Evo.MDR_REGISTRO
				Where  CODICE_VERSIONE = p_vers;
			Exception 
				When NO_DATA_FOUND Then 
					Select Max(VERSIONE_MDR) Into Vers_Mdr From Rinf_Gis_Evo.ANAG_MDR;
			End;		  
		Else
			Select Max(VERSIONE_MDR) Into Vers_Mdr From Rinf_Gis_Evo.ANAG_MDR;
		End If;
--
		Select p.x, p.y  
		Into n_lon, n_lat
		From Rinf_Gis_Evo.TRAT_RETE t,
			Table (
				SDO_UTIL.GETVERTICES (
					SDO_LRS.LOCATE_PT  (
						SDO_LRS.CONVERT_TO_LRS_GEOM (t.GEOMETRY, TR_SAPPROGIN, TR_SAPPROGOUT),
						p_km )
				)
			) p
		Where  OR_ID = p_sol
		  And VERSIONE_MDR = Vers_Mdr;
--
	Case
		When p_dato = 1 Then Return n_lat;
		When p_dato = 2 Then Return n_lon;
		When p_dato = 3 Then Return 1;
	End Case;
--
	Exception
		When OTHERS Then
			Case 
				When p_dato = 1 Then Return  Null;
				When p_dato = 2 Then Return  Null;
				When p_dato = 3 Then Return  0;
			End Case;
--  		Dbms_Output.Put_Line ('GetLatLonFromKM - Errore: ' || Substr(SQLERRM, 1, 1000));
	End GetLatLonFromKM;
--
-- 	----------------------------------------------------------------------------
-- 	FUNCTION GetPar_attivo
--		Aggiunta per il Reg.777/2019
--		Restituisce il parametro di rilascio per la pubblicazione (1=Yes) (0=No)
-- 	----------------------------------------------------------------------------
--
	Function GetPar_attivo (P_Parametro Varchar2)    
		Return Varchar2  Is
			n_value Varchar2(1);
--
	BEGIN
		n_value := '0';
		Select '1'
		Into  n_value
		From  RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
		Where NUMERO_PARAMETRO_MULTIPLO = P_Parametro
		  and FLAG_ATTIVO = '1';  
	Return n_value;
--
	Exception
		When NO_DATA_FOUND Then
			Return '0';
		When OTHERS Then
			Return '0';
--  	Dbms_Output.Put_Line ('GetPar_attivo - Errore: ' || Substr(SQLERRM, 1, 1000));
	End GetPar_attivo;
--
--	----------------------------------------------------------------------------
--	Get_data_validita
-- 		aggiunta per il Reg.777/2019 
--		gestiste la data di inzio e fine validità dei parametri
-- 		determina se il parametro è attivo (1) o no (0) alla data di riferimento
--	----------------------------------------------------------------------------
--
	Function GetData_validita (P_Parametro Varchar2, P_Data_Riferimento date)    
		Return Varchar2  Is
			 n_value   Varchar2(1);
	BEGIN
		 n_value := '0';
--
		Select '1'
		Into  n_value
		From  RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
		Where NUMERO_PARAMETRO_MULTIPLO = P_Parametro
		  and p_data_riferimento between data_inizio_validita and data_fine_validita; 
	Return n_value;
--
	Exception
		When NO_DATA_FOUND Then
			Return '0';
		When OTHERS Then
			Return '0';
--
	End GetData_validita;
--
--	----------------------------------------------------------------------------
--  GetNYA
--  	Segnala se il parametro è NYA (1) o meno (0, ovvero OBBLIGATORIO)
--      Ritorna errore NO_DATA_FOUND (H)
--	----------------------------------------------------------------------------
--
	Function GetNYA (P_Parametro Varchar2)    
		Return Varchar2 Is
			n_value   Varchar2(3);
	BEGIN
		Select Decode(NYA, 1, 'NYA', 'H')
		Into  n_value
		From  RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
		Where NUMERO_PARAMETRO_MULTIPLO = P_Parametro;  
	Return n_value;
	--
	Exception
		When NO_DATA_FOUND Then
			Return 'H';
	End GetNYA;
--
-- 	----------------------------------------------------------------------------
--	GetXmlValue
-- 	----------------------------------------------------------------------------
--
	Function GetXmlValue (P_Parametro In Varchar2, P_Valore In Varchar2) 
		Return Varchar2 Is
			xml_value Varchar2(1000);
--
	BEGIN
		Select VALORE_XML Into xml_value
		From  RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,
			  RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c
		Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO 
		  And c.NUMERO_PARAMETRO_MULTIPLO = p_parametro 
		  And d.CODIFICA_VALORE = p_valore;
--	
		If xml_value Is Null  Then
			xml_value := p_valore;
		End If;
	Return xml_value;
--
	Exception
		 When NO_DATA_FOUND Then
			  Return p_valore;
		 When Others Then
			-- Consider logging the error and then re-raise
			-- Dbms_Output.Put_Line ('GetXmlValue - Errore: ' || Substr(SQLERRM, 1, 1000));
			Return p_valore;
	END GetXmlValue;
--
-- 	----------------------------------------------------------------------------
--	GetOpValue
-- 	----------------------------------------------------------------------------
--
	Function GetOpValue (p_parametro In Varchar2, p_valore In Varchar2) 
		Return Varchar2 Is
			op_value Varchar2(1000);
-- 
	BEGIN
		Select OPTIONAL_VALUE Into op_value
		From  RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,
			  RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c
		Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO 
		  And c.NUMERO_PARAMETRO_MULTIPLO = p_parametro 
		  And d.CODIFICA_VALORE = p_valore;	  
	Return op_value;
--
	Exception
		When NO_DATA_FOUND Then
			Return Null;
		When Others Then
			-- Consider logging the error and then re-raise
			-- Dbms_Output.Put_Line ('GetOpValue - Errore: ' || Substr(SQLERRM, 1, 1000));
			Return Null;
	END GetOpValue;
--
--	----------------------------------------------------------------------------
--	GetDescr
--	----------------------------------------------------------------------------
--
Function GetDescr (p_parametro In Varchar2, p_valore In Varchar2) 
	Return Varchar2 Is
		des_value Varchar2(1000);
-- 
	BEGIN
		Select VALORE Into des_value
		From  Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO d,
			  Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI c
		Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO 
		  And c.NUMERO_PARAMETRO_MULTIPLO = p_parametro 
		  And d.CODIFICA_VALORE = p_valore;
	Return des_value;
--   
	Exception
		 When NO_DATA_FOUND Then
			 Return Null;
		 When Others Then
			-- Consider logging the error and then re-raise
			-- Dbms_Output.Put_Line ('GetDescr - Errore: ' || Substr(SQLERRM, 1, 1000));
			Return Null;
	END GetDescr;
--
-- 	----------------------------------------------------------------------------
--	GetSet
-- 	----------------------------------------------------------------------------
	Function GetSet (p_parametro In Varchar2, p_valore In Varchar2, p_appl_padre In Varchar2) 
		Return Varchar2 Is
			set_value Varchar2(1000);
-- 
	BEGIN
		If p_appl_padre = 'NYA' Then
			set_value := 'NYA';
		--  aggiunto con mail del 11/11/2021 di V. Autiero
		Elsif p_appl_padre = 'N' and p_valore Is Null Then
--      	set_value := 'NYA';
			set_value := Null;
--
		Else
			Select Nvl(OPTIONAL_VALUE, VALORE_XML) Into set_value
			From  RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,
				  RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c
			Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO 
			  And c.NUMERO_PARAMETRO_MULTIPLO = p_parametro 
			  And d.CODIFICA_VALORE = p_valore;
--
			If set_value Is Null Then      --se non ho SET allora metti NYA (richiesta di Autiero, non ci sono indicazioni a riguardo da parte dell'ERA, per ora)
				set_value := 'NYA';
			End If;
		End If;
	Return set_value;
--
	Exception
		When NO_DATA_FOUND Then
			Return 'NYA';
		When Others Then
			-- Consider logging the error and then re-raise
			-- Dbms_Output.Put_Line ('GetSet - Errore: ' || Substr(SQLERRM, 1, 1000));
			Return Null;
	END GetSet;
--
-- 	----------------------------------------------------------------------------
--	GetLastVersion
-- 	----------------------------------------------------------------------------
--
	Function GetLastVersion (p_area Number) 
		Return Number Is
			n_versione Number;
-- 
	BEGIN
		If p_area = 2 Then
			Select Max(CODICE_VERSIONE) Into n_versione
			From RINF_PUBBLICATI_EVO.VERSIONE_RINF
			Where PROTOCOLLO Is Not Null;
		Else
			Select Max(v.CODICE_VERSIONE) Into n_versione
			From RINF_PUBBLICATI_EVO.VERSIONE_RINF v
			Where PROTOCOLLO Is Null;
		End If;
		-- 	Se non esistono dati nell'area selezionata
		If n_versione Is Null Then
		  n_versione := -1;
		End If;
	Return n_versione;
-- 
	END GetLastVersion;
--
-- 	----------------------------------------------------------------------------
-- 	----------------------------------------------------------------------------
-- 	----------------------------------------------------------------------------
-- 	----------------------------------------------------------------------------
--	PROCEDURES
-- 	----------------------------------------------------------------------------
-- 	----------------------------------------------------------------------------
-- 	----------------------------------------------------------------------------
--
-- 	----------------------------------------------------------------------------
--  GetLastVersion 
-- 	----------------------------------------------------------------------------
	Procedure GetLastVersion (p_area Number, p_versione Out Number)  Is
--
	BEGIN
		p_versione := 0;
		If p_area = 2 Then --Pubblicati/Inviati
			Select Max(CODICE_VERSIONE) Into p_versione
			From RINF_PUBBLICATI_EVO.VERSIONE_RINF
			Where PROTOCOLLO Is Not Null;
--	  
		ElsIf p_area = 4 Then --Pronti
			Select Max(v.CODICE_VERSIONE) Into p_versione
			From RINF_PUBBLICATI_EVO.VERSIONE_RINF v
			Where PROTOCOLLO IS Null;
		End If;
--
		If p_versione Is Null Then -- Se non esistono dati nell'area selezionata
			p_versione := -1;
		End If;
	END GetLastVersion;
--
-- 	----------------------------------------------------------------------------
--  GetAllVersions
-- 	----------------------------------------------------------------------------
--
	Procedure GetAllVersions( p_cursor Out empcur) Is
--
	BEGIN
--
		Open p_cursor For
		--28/09/2016 Aggiunto protocollo per la combo dell'archiviio storico
			Select v.CODICE_VERSIONE, DATA_PUBBLICAZIONE, DATA_TRASMISSIONE, PROTOCOLLO 
			From RINF_PUBBLICATI_EVO.VERSIONE_RINF v,
				(Select CODICE_VERSIONE, DATA_TRASMISSIONE
				From RINF_PUBBLICATI_EVO.ANAGRAFICA_TRASMISSIONI
				Where CODICE_TRASMISSIONE = 1) t
			Where   v.CODICE_VERSIONE = t.CODICE_VERSIONE (+)
			Order By  DATA_PUBBLICAZIONE desc 
		;
	 END GetAllVersions;
--
--	-----------------------------------------------------------------------------
--  PUNTI OPERATIVI (OP) / Località -------------
--                               GetOP_General
-- -----------------------------------------------------------------------------
 Procedure GetOP_General (P_OP Varchar2, P_AREA Number, P_I_VERSIONE Number, P_CURSOR Out EMPCUR) IS
--Ritorna i parametri principali di una OP

   S_SCHEMA   Varchar2(100);
--   sqlstringa Varchar2(10000);
   sqlstringa CLOB;
--
   P_VERSIONE Number;
-->   
/*
   lc  varchar2(7);
   lat number;
   lon number;
*/
--->
   Data_Validita Date;
--
 BEGIN
   S_SCHEMA   := Pkg_Rinf_Interfaccia.GetSchemaName(p_area);
   P_VERSIONE := P_I_VERSIONE;

   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
         P_VERSIONE := GetLastVersion(P_AREA);
   End If;
--->
 -- ------------------------------------------------------------------------------------------------
-- gestione della data di inizio e fine validità per il parametro	 
-- ------------------------------------------------------------------------------------------------
--
   If P_VERSIONE Is Not Null Then  
      Select Greatest(DATA_PUBBLICAZIONE, DATA_RIFERIMENTO) 
  	    Into Data_Validita 
        From RINF_PUBBLICATI_EVO.VERSIONE_RINF
       Where CODICE_VERSIONE = P_VERSIONE;
   Else
       Select Greatest(DATA_CONTROLLO, DATA_RIFERIMENTO) 
  	     Into Data_Validita 
         From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI
        Where CODICE_CONTROLLO = (Select max (CODICE_CONTROLLO) From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI);
   End If;
 --
/*
 begin
 Select PO_1_2_0_0_0_2, latitudine, longitudine into lc, lat, lon
 From  RINF_ANAGRAFICHE_EVO.LOCALITA_CONFINE Where SEDE_TECNICA = p_op;
 exception
   when NO_DATA_FOUND then
   lc :='';
   lat := Null;
   lon := Null;
 end;  
 */
 -- 1.2.0.0.0.2 - UniqueOPID
 sqlstringa :=  'Select  l.SEDE_TECNICA PO_ID, ';
 sqlstringa := sqlstringa || Nvl(To_Char( p_versione),'Null')||' CODICE_VERSIONE,';
 sqlstringa := sqlstringa || 'DEFINIZIONE PO_1_2_0_0_0_1, ';
 sqlstringa := sqlstringa || 'PO_1_2_0_0_0_2, ';
-- 09/05/2016 Modificata la struttura della tabella PUNTI_OPERATIVI. Aggiunti i campi PO_1_2_0_0_0_2 e PO_1_2_0_0_0_3_AP ed eliminato il campo PO_1_2_0_0_0_3
-- E' stata creata la tabella PAR_1_2_0_0_0_3_TAF_TAP per gestire la molteplicità del parametro 1.2.0.0.0.3
 -- 1.2.0.0.0.3 - OPTafTapCode
 sqlstringa := sqlstringa || 'PO_1_2_0_0_0_3_AP, ';
 sqlstringa := sqlstringa || 'codice_taf_tap.codice PO_1_2_0_0_0_3, ';
 -- 1.2.0.0.0.4 - OPType
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.0.0.0.4'',PO_1_2_0_0_0_4) PO_1_2_0_0_0_4_XML,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.0.0.0.4'',PO_1_2_0_0_0_4) PO_1_2_0_0_0_4_OV,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.0.0.0.4'',PO_1_2_0_0_0_4) PO_1_2_0_0_0_4_DES,';
 sqlstringa := sqlstringa || ' PO_1_2_0_0_0_4, ';
--->  -- 1.2.0.0.0.4.1 -- OPTypeGaugeChangeover - (nuovo parametro Reg.2019/777)
 sqlstringa := sqlstringa || ' PO_1_2_0_0_0_4_1_AP, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.0.0.0.4.1'', PO_1_2_0_0_0_4_1) PO_1_2_0_0_0_4_1_XML, ';
-- sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.0.0.0.4.1'', PO_1_2_0_0_0_4_1) PO_1_2_0_0_0_4_1_OV, ';
 sqlstringa := sqlstringa || 'Null PO_1_2_0_0_0_4_1_OV, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.0.0.0.4.1'', PO_1_2_0_0_0_4_1) PO_1_2_0_0_0_4_1_DES, ';
 sqlstringa := sqlstringa || 'PO_1_2_0_0_0_4_1, GetData_Validita(''1.2.0.0.0.4.1'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''', ''dd/mm/yyyy'')) Flag_1_2_0_0_0_4_1, '; 
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.2.0.0.0.4.1'') Flag_1_2_0_0_0_4_1_AT, ';
-- 1.2.3.1 - RUL_LocalRulesOrRestrictions  - (nuovo parametro Reg.2019/777)
 sqlstringa := sqlstringa || ' PO_1_2_3_1_AP, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.3.1'', PO_1_2_3_1) PO_1_2_3_1_XML, ';
-- sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.3.1'', PO_1_2_3_1) PO_1_2_3_1_OV, ';
 sqlstringa := sqlstringa || 'Null PO_1_2_3_1_OV, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.3.1'', PO_1_2_3_1) PO_1_2_3_1_DES, ';
 sqlstringa := sqlstringa || 'PO_1_2_3_1, GetData_Validita(''1.2.3.1'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''', ''dd/mm/yyyy'')) Flag_1_2_3_1, '; 
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.2.3.1'') Flag_1_2_3_1_AT, ';
-- 1.2.3.2 - RUL_LocalRulesOrRestrictionsDocRef  - (nuovo parametro Reg.2019/777)
-- il presente parametro è nella nuova tabella Rinf_lavorazione_evo.PAR_1_2_3_2_DOC_NORME
 sqlstringa := sqlstringa || 'PO_1_2_3_2_AP, ';
 sqlstringa := sqlstringa || 'Norme_Doc.PO_1_2_3_2_XML, ';
 sqlstringa := sqlstringa || 'Norme_Doc.PO_1_2_3_2_OV, ';
 sqlstringa := sqlstringa || 'Norme_Doc.PO_1_2_3_2_DES, ';
 sqlstringa := sqlstringa || 'Norme_Doc.Codice PO_1_2_3_2, ';
 sqlstringa := sqlstringa || ' GetData_Validita(''1.2.3.2'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_3_2, '; 
 sqlstringa := sqlstringa || ' GetPar_attivo(''1.2.3.2'') Flag_1_2_3_2_AT, ';
-->
--  if length(lc) = 7 and lat Is Not Null and lon Is Not Null then
-- 1.2.0.0.0.5 - OPGeographicLocation (modificato da 4 a 7 cifre decimali)
 sqlstringa := sqlstringa || '''Latitude (''|| Trim(To_Char(Trunc(LATITUDINE,7),''999.9999999''))|| '') + Longitude (''|| Trim(To_Char(Trunc(LONGITUDINE,7),''S999.9999999''))|| '')'' PO_1_2_0_0_0_5, ';
--  else
--     sqlstringa := sqlstringa || '''Latitude (''|| Trim(To_Char(Trunc(LATITUDINE,4),''999.9999''))|| '') + Longitude (''|| Trim(To_Char(Trunc(LONGITUDINE,4),''S999.9999''))|| '')'' PO_1_2_0_0_0_5, ';
 -- end if;
-- 1.2.0.0.0.6 - OPRailwayLocation
 sqlstringa := sqlstringa || 'Nvl(Trim(linea_comm.linea),''0000 - 0.000'') PO_1_2_0_0_0_6, ';
 sqlstringa := sqlstringa || ' CACHE_FIELD ';
 sqlstringa := sqlstringa || 'From '||s_schema||'.PUNTI_OPERATIVI l, ';
--
 If P_VERSIONE Is Not Null Then
      sqlstringa := sqlstringa || '(Select v.SEDE_TECNICA, Listagg(REPLACE(CODICE,'' '','''')||'' - ''||Trim(To_Char(ROUND(KM_INIZIO,3),''999990.999'')) ,''#'' ) Within Group (Order By CODICE) AS linea ';
      sqlstringa := sqlstringa || 'From '||s_schema||'.V_MDR_LINEE_COMMERCIALI v ';
      sqlstringa := sqlstringa || ' Where  ';
      sqlstringa := sqlstringa || ' v.CODICE_VERSIONE='||p_versione ;
      sqlstringa := sqlstringa || ' GROUP BY v.SEDE_TECNICA) linea_comm, ';
--
-- 30/10/2017 la chilometrica è stata spostata nella tabella di relazione località-linea commerciale per gestirne la molteplicità
-- sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI p';
-- sqlstringa := sqlstringa || ' v.CODICE_VE
-- sqlstringa := sqlstringa || ' and  p.SEDE_TECNICA = v.SEDE_TECNICA ';
--
      sqlstringa := sqlstringa || '(Select v.SEDE_TECNICA, Listagg(PO_1_2_0_0_0_3 ,''#'' ) Within Group (Order By PO_1_2_0_0_0_3) AS codice ';
      sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v,';
      sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI p';
      sqlstringa := sqlstringa || ' Where  ';
      sqlstringa := sqlstringa || ' v.CODICE_VERSIONE=p.CODICE_VERSIONE and ';
      sqlstringa := sqlstringa || ' v.CODICE_VERSIONE='||p_versione ;
      sqlstringa := sqlstringa || ' and p.SEDE_TECNICA = v.SEDE_TECNICA ';
      sqlstringa := sqlstringa || ' GROUP BY v.SEDE_TECNICA) codice_taf_tap, ';
 --

      sqlstringa := sqlstringa || '(Select v.SEDE_TECNICA, CODICE_VERSIONE, ';
      sqlstringa := sqlstringa || ' Listagg(PO_1_2_3_2, ''#'') Within Group (Order By SEDE_TECNICA) AS CODICE, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE_XML, ''#'') Within Group (Order By SEDE_TECNICA) As PO_1_2_3_2_XML, ';
      sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By SEDE_TECNICA) As PO_1_2_3_2_OV, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE, ''#'') Within Group (Order By SEDE_TECNICA) As PO_1_2_3_2_DES ';
      sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_3_2_DOC_NORME v, Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO d, Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI c ';
      sqlstringa := sqlstringa || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.2.3.2''  And PO_1_2_3_2 = CODIFICA_VALORE ';
      sqlstringa := sqlstringa || ' Group By v.SEDE_TECNICA, CODICE_VERSIONE ) Norme_Doc ';


 Else
      sqlstringa := sqlstringa || '(Select v.SEDE_TECNICA, Listagg(REPLACE(CODICE,'' '','''')||'' - ''||Trim(To_Char(ROUND(KM_INIZIO,3),''999990.999'')) ,''#'' ) Within Group (Order By CODICE) AS linea ';
      sqlstringa := sqlstringa || 'From '||s_schema||'.V_MDR_LINEE_COMMERCIALI v ';
      sqlstringa := sqlstringa || ' GROUP BY v.SEDE_TECNICA) linea_comm, ';
-- 30/10/2017 la chilometrica è stata spostata nella tabella di relazione località-linea commerciale per gestirne la molteplicità
-- sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI p';
-- sqlstringa := sqlstringa || ' Where  ';
-- sqlstringa := sqlstringa || ' p.sede_tecnica=v.sede_tecnica ';
      sqlstringa := sqlstringa || '(Select v.SEDE_TECNICA, Listagg(PO_1_2_0_0_0_3 ,''#'' ) Within Group (Order By PO_1_2_0_0_0_3) AS codice ';
      sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v,';
      sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI p';
      sqlstringa := sqlstringa || ' Where  ';
      sqlstringa := sqlstringa || ' p.sede_tecnica=v.sede_tecnica ';
      sqlstringa := sqlstringa || ' GROUP BY v.SEDE_TECNICA) codice_taf_tap, ';
--
      sqlstringa := sqlstringa || '(Select v.SEDE_TECNICA, ';
      sqlstringa := sqlstringa || ' Listagg(PO_1_2_3_2, ''#'') Within Group (Order By SEDE_TECNICA) AS CODICE, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE_XML, ''#'') Within Group (Order By SEDE_TECNICA) As PO_1_2_3_2_XML, ';
      sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By SEDE_TECNICA) As PO_1_2_3_2_OV, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE, ''#'') Within Group (Order By SEDE_TECNICA) As PO_1_2_3_2_DES ';
      sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_3_2_DOC_NORME v, Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO d, Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI c ';
      sqlstringa := sqlstringa || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.2.3.2''  And PO_1_2_3_2 = CODIFICA_VALORE ';
      sqlstringa := sqlstringa || ' Group By v.SEDE_TECNICA ) Norme_Doc ';
--  

 End If;
--
  sqlstringa := sqlstringa || 'Where l.SEDE_TECNICA = '''||p_OP||''' ';
  sqlstringa := sqlstringa || 'and l.SEDE_TECNICA = linea_comm.SEDE_TECNICA (+) ';
  sqlstringa := sqlstringa || 'and l.SEDE_TECNICA = codice_taf_tap.SEDE_TECNICA (+) ';
  sqlstringa := sqlstringa || 'and l.SEDE_TECNICA = Norme_Doc.SEDE_TECNICA (+) ';
--
  If P_VERSIONE Is Not Null Then
       sqlstringa := sqlstringa || 'And l.CODICE_VERSIONE = '||p_versione;
	   sqlstringa := sqlstringa || 'And l.CODICE_VERSIONE = Norme_Doc.CODICE_VERSIONE (+) ';
  End If;
--  
  sqlstringa := sqlstringa || 'Order By 1 ';
-- 
  Open p_cursor For sqlstringa;
--     DBMS_OutPUT.PUT_LINE(sqlstringa);
--	 
 END GetOP_General;

-- -----------------------------------------------------------------------------
--                     GetOPTracks_Infrastructure - adeguato al Reg.777/2019
-- -----------------------------------------------------------------------------
 Procedure GetOPTracks_Infrastructure (p_OP Varchar2, p_AREA Number, p_i_VERSIONE Number, p_CURSOR Out EMPCUR) Is
--Ritorna i  Binari di Corsa della OP con i relativi parametri
--
   S_SCHEMA Varchar2(100);
--   sqlstringa Varchar2(20000);
   sqlstringa CLOB;
--
   P_VERSIONE Number;
   --->
   Data_Validita Date;
--
 BEGIN
   S_SCHEMA := Pkg_Rinf_Interfaccia.GetSchemaName(P_AREA);
   P_VERSIONE := P_I_VERSIONE;
 --
   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
         P_VERSIONE := GetLastVersion(P_AREA);
   End If;
-- ------------------------------------------------------------------------------------------------
-- gestione della data di inizio e fine validità per il parametro	 
-- ------------------------------------------------------------------------------------------------
--->
 If P_VERSIONE Is Not Null Then  
    Select Greatest(DATA_PUBBLICAZIONE, DATA_RIFERIMENTO) 
	  Into Data_Validita 
      From RINF_PUBBLICATI_EVO.VERSIONE_RINF
     Where CODICE_VERSIONE = P_VERSIONE;
 Else
     Select Greatest(DATA_CONTROLLO, DATA_RIFERIMENTO) 
	   Into Data_Validita 
       From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI
      Where CODICE_CONTROLLO =(Select max (CODICE_CONTROLLO) From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI);
 End If;
-- 
 sqlstringa :=  'Select  DISTINCT r.SEDE_TECNICA PO_ID, ';
 sqlstringa := sqlstringa || Nvl(To_Char( p_versione),'Null')||' CODICE_VERSIONE,';
-- 1.2.1.0.0.1 - OPTrackIMCode
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.0.1'', b.PO_TRACK_1_2_1_0_0_1) PO_TRACK_1_2_1_0_0_1_XML, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.0.1'', b.PO_TRACK_1_2_1_0_0_1) PO_TRACK_1_2_1_0_0_1_OV, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.0.1'', b.PO_TRACK_1_2_1_0_0_1) PO_TRACK_1_2_1_0_0_1_DES, ';
 sqlstringa := sqlstringa || ' Nvl( b.PO_TRACK_1_2_1_0_0_1, ''0083'') PO_TRACK_1_2_1_0_0_1,  ';
-- 1.2.1.0.0.2 - OPTrackIdentification
 sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_0_2  PO_TRACK_1_2_1_0_0_2,  ';
 sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_0_2_D PO_TRACK_1_2_1_0_0_2_DES,  ';
-- 1.2.1.0.2.1 - IPP_TENClass
 sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_2_1_AP, ';
 sqlstringa := sqlstringa || 'cat_ten.PO_TRACK_1_2_1_0_2_1_XML,';
 sqlstringa := sqlstringa || 'cat_ten.PO_TRACK_1_2_1_0_2_1_OV,';
 sqlstringa := sqlstringa || 'cat_ten.PO_TRACK_1_2_1_0_2_1 PO_TRACK_1_2_1_0_2_1_DES,';
 sqlstringa := sqlstringa || 'cat_ten.PO_TRACK_1_2_1_0_2_1_DES PO_TRACK_1_2_1_0_2_1, ';
-- 1.2.1.0.2.2 - IPP_LineCat
 sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_2_2_AP, ';
 sqlstringa := sqlstringa || 'cat_linea.PO_TRACK_1_2_1_0_2_2_XML,';
 sqlstringa := sqlstringa || 'cat_linea.PO_TRACK_1_2_1_0_2_2_OV,';
 sqlstringa := sqlstringa || 'cat_linea.PO_TRACK_1_2_1_0_2_2_DES,';
 sqlstringa := sqlstringa || 'cat_linea.PO_TRACK_1_2_1_0_2_2, ';
-- 1.2.1.0.2.3 - IPP_FreightCorridor
-- BUG-FIX-20250715: 
-- "Parametro autorizzato da due validatori diversi" - Territorio per la LO e DSPS per la TR.
-- Per le località di tipo "Passenger Stop" (es: Calliano) si ereditano le autorizzazioni di tratta. 
-- Se DSPS non autorizza a livello di tratta si genera il bug in quanto non si riesce a agganciare la descrizione del corridoio.
-- A livello tecnica modificata la gestione del campo "PO_TRACK_1_2_1_0_2_3_AP"
-- sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_2_3_AP, ';
 If (P_AREA = 2 Or P_AREA = 4) Then
 sqlstringa := sqlstringa || 'DECODE(corridoio.PO_TRACK_1_2_1_0_2_3_XML,NULL,DECODE(PO_TRACK_1_2_1_0_2_3_AP,''N'',''N'',''NYA''),PO_TRACK_1_2_1_0_2_3_AP)  PO_TRACK_1_2_1_0_2_3_AP, ';
 Else
 sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_2_3_AP, ';
 End If;
 sqlstringa := sqlstringa || 'corridoio.PO_TRACK_1_2_1_0_2_3_XML,';
 sqlstringa := sqlstringa || 'corridoio.PO_TRACK_1_2_1_0_2_3_OV,';
 sqlstringa := sqlstringa || 'corridoio.PO_TRACK_1_2_1_0_2_3 PO_TRACK_1_2_1_0_2_3_DES,';
 sqlstringa := sqlstringa || 'corridoio.PO_TRACK_1_2_1_0_2_3_DES PO_TRACK_1_2_1_0_2_3, ';
-- 1.2.1.0.3.1 - ILL_InteropGauge (Parametro cancellato col Reg.2019/777)
 sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_3_1_AP, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.3.1'', b.PO_TRACK_1_2_1_0_3_1) PO_TRACK_1_2_1_0_3_1_XML,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.3.1'', b.PO_TRACK_1_2_1_0_3_1) PO_TRACK_1_2_1_0_3_1_OV,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.3.1'', b.PO_TRACK_1_2_1_0_3_1) PO_TRACK_1_2_1_0_3_1_DES,';
 sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_3_1, GetData_Validita(''1.2.1.0.3.1'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_1_0_3_1, ';
 --sqlstringa := sqlstringa || 'GetPar_attivo(''1.2.1.0.3.1'') Flag_1_2_1_0_3_1_AT, ';
-- 1.2.1.0.3.2 - ILL_MultiNatGauge (Parametro cancellato col Reg.2019/777)
 sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_3_2_AP, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.3.2'', b.PO_TRACK_1_2_1_0_3_2) PO_TRACK_1_2_1_0_3_2_XML,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.3.2'',b.PO_TRACK_1_2_1_0_3_2) PO_TRACK_1_2_1_0_3_2_OV,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.3.2'',b.PO_TRACK_1_2_1_0_3_2) PO_TRACK_1_2_1_0_3_2_DES,';
 sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_3_2, GetData_Validita(''1.2.1.0.3.2'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_1_0_3_2, ';
-- sqlstringa := sqlstringa || 'GetPar_attivo(''1.2.1.0.3.2'') Flag_1_2_1_0_3_2_AT, ';
-- 1.2.1.0.3.3 - ILL_NatGauge (Parametro cancellato col Reg.2019/777)
 sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_3_3_AP, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.3.3'', b.PO_TRACK_1_2_1_0_3_3) PO_TRACK_1_2_1_0_3_3_XML,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.3.3'', b.PO_TRACK_1_2_1_0_3_3) PO_TRACK_1_2_1_0_3_3_OV,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.3.3'', b.PO_TRACK_1_2_1_0_3_3) PO_TRACK_1_2_1_0_3_3_DES,';
 sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_3_3, GetData_Validita(''1.2.1.0.3.3'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_1_0_3_3, ';
 --sqlstringa := sqlstringa || 'GetPar_attivo(''1.2.1.0.3.3'') Flag_1_2_1_0_3_3_AT, ';
-- 1.2.1.0.3.4 - ILL_Gauging (Nuovo parametro Reg.2019/777)
 sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_3_4_AP, '; 
 sqlstringa := sqlstringa || 'Decode(RFI.getxmlvalue(''1.2.1.0.3.4.SUP'', b.PO_TRACK_1_2_1_0_3_4_SUP) || ''#'' || RFI.getxmlvalue(''1.2.1.0.3.4.INF'', b.PO_TRACK_1_2_1_0_3_4_INF),  ''#'', Null,  RFI.getxmlvalue(''1.2.1.0.3.4.SUP'', b.PO_TRACK_1_2_1_0_3_4_SUP)|| ''#'' || RFI.getxmlvalue(''1.2.1.0.3.4.INF'', b.PO_TRACK_1_2_1_0_3_4_INF) ) PO_TRACK_1_2_1_0_3_4_XML, ';
 sqlstringa := sqlstringa || 'Decode(RFI.GetOpValue(''1.2.1.0.3.4.SUP'', PO_TRACK_1_2_1_0_3_4_SUP) || ''#'' || RFI.GetOpValue(''1.2.1.0.3.4.INF'', PO_TRACK_1_2_1_0_3_4_INF), ''#'', Null,   RFI.GetOpValue(''1.2.1.0.3.4.SUP'', PO_TRACK_1_2_1_0_3_4_SUP)|| ''#'' || RFI.GetOpValue(''1.2.1.0.3.4.INF'', PO_TRACK_1_2_1_0_3_4_INF) ) PO_TRACK_1_2_1_0_3_4_OV, ';
 sqlstringa := sqlstringa || 'Decode(RFI.GetDescr(''1.2.1.0.3.4.SUP'', PO_TRACK_1_2_1_0_3_4_SUP)|| ''#'' || RFI.GetDescr(''1.2.1.0.3.4.INF'', PO_TRACK_1_2_1_0_3_4_INF), ''#'', Null,  RFI.GetDescr(''1.2.1.0.3.4.SUP'', PO_TRACK_1_2_1_0_3_4_SUP)  || ''#'' || RFI.GetDescr(''1.2.1.0.3.4.INF'', PO_TRACK_1_2_1_0_3_4_INF) ) PO_TRACK_1_2_1_0_3_4_DES, ';
 sqlstringa := sqlstringa || 'Decode(RFI.GetDescr(''1.2.1.0.3.4.SUP'', PO_TRACK_1_2_1_0_3_4_SUP)|| ''#'' || RFI.GetDescr(''1.2.1.0.3.4.INF'', PO_TRACK_1_2_1_0_3_4_INF), ''#'', Null,  RFI.GetDescr(''1.2.1.0.3.4.SUP'', PO_TRACK_1_2_1_0_3_4_SUP)  || ''#'' || RFI.GetDescr(''1.2.1.0.3.4.INF'', PO_TRACK_1_2_1_0_3_4_INF) )  PO_TRACK_1_2_1_0_3_4,';
 sqlstringa := sqlstringa || ' GetData_Validita(''1.2.1.0.3.4.SUP'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_1_0_3_4, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.2.1.0.3.4.SUP'') Flag_1_2_1_0_3_4_AT, ';
-- 1.2.1.0.3.5 - ILL_GaugeCheckLoc (Nuovo parametro Reg.2019/777) - AP (Intera Rete) = N - Valore = []
-- Localizzazione ferroviaria di punti particolari che richiedono verifiche specifiche
 sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_3_5_AP, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.3.5.A'', b.PO_TRACK_1_2_1_0_3_5_A)||'' ''||PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.3.5.B'', b.PO_TRACK_1_2_1_0_3_5_B) PO_TRACK_1_2_1_0_3_5_XML, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.3.5.A'', b.PO_TRACK_1_2_1_0_3_5_A)||'' ''||PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.3.5.B'', b.PO_TRACK_1_2_1_0_3_5_B) PO_TRACK_1_2_1_0_3_5_OV, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.3.5.A'', b.PO_TRACK_1_2_1_0_3_5_A)||'' ''||PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.3.5.B'', b.PO_TRACK_1_2_1_0_3_5_B) PO_TRACK_1_2_1_0_3_5_DES, ';
 sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_3_5_A||'' ''||b.PO_TRACK_1_2_1_0_3_5_B PO_TRACK_1_2_1_0_3_5, GetData_Validita(''1.2.1.0.3.5.A'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_1_0_3_5, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.2.1.0.3.5.A'') Flag_1_2_1_0_3_5_AT, ';
-- 1.2.1.0.3.6 - ILL_GaugeCheckDocRef (Nuovo parametro Reg.2019/777) - AP (Intera Rete) = N - Valore = []
-- Documento che riporta la sezione trasversale di punti particolari che richiedono verifiche specifiche
 sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_3_6_AP, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.3.6'', b.PO_TRACK_1_2_1_0_3_6) PO_TRACK_1_2_1_0_3_6_XML, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.3.6'', b.PO_TRACK_1_2_1_0_3_6) PO_TRACK_1_2_1_0_3_6_OV, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.3.6'', b.PO_TRACK_1_2_1_0_3_6) PO_TRACK_1_2_1_0_3_6_DES, ';
 sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_3_6, GetData_Validita(''1.2.1.0.3.6'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_1_0_3_6, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.2.1.0.3.6'') Flag_1_2_1_0_3_6_AT, ';
-- 1.2.1.0.4.1 - ITP_NomGauge
 sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_4_1_AP, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.4.1'', b.PO_TRACK_1_2_1_0_4_1) PO_TRACK_1_2_1_0_4_1_XML,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.4.1'', b.PO_TRACK_1_2_1_0_4_1) PO_TRACK_1_2_1_0_4_1_OV,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.4.1'', b.PO_TRACK_1_2_1_0_4_1) PO_TRACK_1_2_1_0_4_1_DES,';
 sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_4_1 ';
-- sqlstringa := sqlstringa || ' , GetData_Validita(''1.2.1.0.4.1'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_1_0_4_1, ';
-- sqlstringa := sqlstringa || 'GetPar_attivo(''1.2.1.0.4.1'') Flag_1_2_1_0_4_1_AT ';
--
 sqlstringa := sqlstringa || 'From '||s_schema||'.BINARI_CORSA_PO b, ';
 sqlstringa := sqlstringa ||  s_schema||'.REL_PO_BINARI_CORSA r, ';
--
 If p_versione Is Not Null Then
      sqlstringa := sqlstringa || '(Select PO_TRACK_1_2_1_0_0_2, CODICE_VERSIONE, Listagg(PO_TRACK_1_2_1_0_2_1,''#'') Within Group (Order By KM_INIZIO,PO_TRACK_1_2_1_0_2_1) AS PO_TRACK_1_2_1_0_2_1, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_1_XML,';
      sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_1_OV,';
      sqlstringa := sqlstringa || ' Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_1_DES';
      sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_1_0_2_1_CAT_TEN_PO v,';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
      sqlstringa := sqlstringa || ' Where';
      sqlstringa := sqlstringa || ' c.codice_parametro = d.codice_parametro and';
      sqlstringa := sqlstringa || ' numero_parametro = ''1.2.1.0.2.1'' and';
      sqlstringa := sqlstringa || ' PO_TRACK_1_2_1_0_2_1 = CODIFICA_VALORE';
      sqlstringa := sqlstringa || '  group by PO_TRACK_1_2_1_0_0_2, CODICE_VERSIONE) cat_ten, ';
      sqlstringa := sqlstringa || '(Select PO_TRACK_1_2_1_0_0_2, CODICE_VERSIONE, Listagg(PO_TRACK_1_2_1_0_2_2,''#'') Within Group (Order By KM_INIZIO,PO_TRACK_1_2_1_0_2_2) AS PO_TRACK_1_2_1_0_2_2, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_2_XML,';
      sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_2_OV,';
      sqlstringa := sqlstringa || ' Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_2_DES';
      sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_1_0_2_2_CAT_LINEA v,';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
      sqlstringa := sqlstringa || ' Where';
      sqlstringa := sqlstringa || ' c.codice_parametro = d.codice_parametro and';
      sqlstringa := sqlstringa || ' numero_parametro = ''1.2.1.0.2.2'' and';
      sqlstringa := sqlstringa || ' PO_TRACK_1_2_1_0_2_2 = CODIFICA_VALORE';
      sqlstringa := sqlstringa || '  group by PO_TRACK_1_2_1_0_0_2, CODICE_VERSIONE) cat_linea, ';

--07/11/2016 l'estrazione dei corridoi è stata cambiata sostanzialmente. e' stata introdotta la distinzione tra binari PO di tipo LO e
--quelli di tipo TR. Per i binari di tipo LO i corridoi vengono estratti dalla tabella CORRIDOIO_PO (V_OP_CONTESTO_GEOGRAFICO),
--mentre per quelli di tipo TR dalla tabella CORRIDOIO_SOL (V_SOL_CONTESTO_GEOGRAFICO).

      sqlstringa := sqlstringa || '(Select SEDE_TECNICA, CODICE_VERSIONE, Listagg(v.DESCRIZIONE,''#'') Within Group (Order By v.DESCRIZIONE) AS PO_TRACK_1_2_1_0_2_3, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE_XML,''#'') Within Group (Order By VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_XML,';
      sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_OV,';
      sqlstringa := sqlstringa || ' Listagg(VALORE,''#'') Within Group (Order By VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_DES';
      sqlstringa := sqlstringa || ' From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO v,';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
      sqlstringa := sqlstringa || ' Where';
      sqlstringa := sqlstringa || ' c.codice_parametro = d.codice_parametro ';
      sqlstringa := sqlstringa || ' and numero_parametro = ''1.2.1.0.2.3'' ';
      sqlstringa := sqlstringa || ' and CODICE||''0'' = CODIFICA_VALORE ';  --24/'7/2015 la vecchia join fatta sulle descrizioni non andava bene, il codice è stato moltiplicato per 10, perché è il valore contenuto in DOMINIO_PARAMETRI(3=>30,1 =>10 etc.)
      sqlstringa := sqlstringa || ' and CODICE_CONTESTO = 3 ';
--07/11/2016 dalla tabella V_OP_CONTESTO_GEOGRAFICO si estraggono i corridoi della PO e delle PO da essa contenuta
      sqlstringa := sqlstringa || ' and (SEDE_TECNICA,CODICE_VERSIONE) in ';
      sqlstringa := sqlstringa || ' (Select '''||p_OP||''','||p_versione||' From dual UNION Select SEDE_TECNICA,CODICE_VERSIONE From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE='''||p_OP||''')';
      sqlstringa := sqlstringa || '  group by SEDE_TECNICA, CODICE_VERSIONE ';
      sqlstringa := sqlstringa || ' UNION ';
      sqlstringa := sqlstringa || ' Select SEDE_TECNICA, CODICE_VERSIONE, Listagg(v.DESCRIZIONE,''#'') Within Group (Order By v.DESCRIZIONE) AS PO_TRACK_1_2_1_0_2_3, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE_XML,''#'') Within Group (Order By VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_XML,';
      sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_OV,';
      sqlstringa := sqlstringa || ' Listagg(VALORE,''#'') Within Group (Order By VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_DES';
      sqlstringa := sqlstringa || ' From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v,';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
      sqlstringa := sqlstringa || ' Where';
      sqlstringa := sqlstringa || ' c.codice_parametro = d.codice_parametro ';
      sqlstringa := sqlstringa || ' and numero_parametro = ''1.1.1.1.2.3'' ';
      sqlstringa := sqlstringa || ' and CODICE||''0'' = CODIFICA_VALORE ';  --24/'7/2015 la vecchia join fatta sulle descrizioni non andava bene, il codice è stato moltiplicato per 10, perché è il valore contenuto in DOMINIO_PARAMETRI(3=>30,1 =>10 etc.)
      sqlstringa := sqlstringa || ' and CODICE_CONTESTO = 3 ';
--07/11/2016 dalla tabella V_SOL_CONTESTO_GEOGRAFICO si estraggono i corridoi delle SOL il cui binario è di fermata per la PO
      sqlstringa := sqlstringa || ' and (SEDE_TECNICA,CODICE_VERSIONE) in (Select substr(PO_TRACK_1_2_1_0_0_2,1,6), CODICE_VERSIONE From '||s_schema||'.REL_PO_BINARI_CORSA ';
      sqlstringa := sqlstringa || ' Where SEDE_TECNICA = '''||p_OP||''') ';
      sqlstringa := sqlstringa || '  group by SEDE_TECNICA, CODICE_VERSIONE) corridoio ';
      sqlstringa := sqlstringa || ' Where b.CODICE_VERSIONE = '||p_versione;
      sqlstringa := sqlstringa || ' and b.CODICE_VERSIONE = cat_ten.CODICE_VERSIONE (+) ';
      sqlstringa := sqlstringa || ' and b.CODICE_VERSIONE = cat_linea.CODICE_VERSIONE (+) ';
      sqlstringa := sqlstringa || ' and r.CODICE_VERSIONE = corridoio.CODICE_VERSIONE (+) ';
      sqlstringa := sqlstringa || ' and b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2 ';
      sqlstringa := sqlstringa || ' and b.CODICE_VERSIONE = r.CODICE_VERSIONE ';
      sqlstringa := sqlstringa || ' and r.SEDE_TECNICA = '''||p_OP||''' ';
 Else
      sqlstringa := sqlstringa || '(Select PO_TRACK_1_2_1_0_0_2, Listagg(PO_TRACK_1_2_1_0_2_1,''#'') Within Group (Order By KM_INIZIO,PO_TRACK_1_2_1_0_2_1) AS PO_TRACK_1_2_1_0_2_1, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_1_XML,';
      sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_1_OV,';
      sqlstringa := sqlstringa || ' Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_1_DES';
      sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_1_0_2_1_CAT_TEN_PO v,';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
      sqlstringa := sqlstringa || ' Where';
      sqlstringa := sqlstringa || ' c.codice_parametro = d.codice_parametro and';
      sqlstringa := sqlstringa || ' numero_parametro = ''1.2.1.0.2.1'' and';
      sqlstringa := sqlstringa || ' PO_TRACK_1_2_1_0_2_1 = CODIFICA_VALORE';
      sqlstringa := sqlstringa || '  group by PO_TRACK_1_2_1_0_0_2) cat_ten, ';
      sqlstringa := sqlstringa || '(Select PO_TRACK_1_2_1_0_0_2,  Listagg(PO_TRACK_1_2_1_0_2_2,''#'') Within Group (Order By KM_INIZIO,PO_TRACK_1_2_1_0_2_2) AS PO_TRACK_1_2_1_0_2_2, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_2_XML,';
      sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_2_OV,';
      sqlstringa := sqlstringa || ' Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_2_DES';
      sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_1_0_2_2_CAT_LINEA v,';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
      sqlstringa := sqlstringa || ' Where ';
      sqlstringa := sqlstringa || ' c.codice_parametro = d.codice_parametro and ';
      sqlstringa := sqlstringa || ' numero_parametro = ''1.2.1.0.2.2'' and ';
      sqlstringa := sqlstringa || ' PO_TRACK_1_2_1_0_2_2 = CODIFICA_VALORE';
      sqlstringa := sqlstringa || '  group by PO_TRACK_1_2_1_0_0_2) cat_linea, ';
      sqlstringa := sqlstringa || '(Select SEDE_TECNICA, Listagg(v.DESCRIZIONE,''#'') Within Group (Order By v.DESCRIZIONE) AS PO_TRACK_1_2_1_0_2_3, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE_XML,''#'') Within Group (Order By VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_XML,';
      sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_OV,';
      sqlstringa := sqlstringa || ' Listagg(VALORE,''#'') Within Group (Order By VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_DES';
      sqlstringa := sqlstringa || ' From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO v,';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
      sqlstringa := sqlstringa || ' Where';
      sqlstringa := sqlstringa || ' c.codice_parametro = d.codice_parametro ';
      sqlstringa := sqlstringa || ' and numero_parametro = ''1.2.1.0.2.3'' ';
      sqlstringa := sqlstringa || ' and CODICE||''0'' = CODIFICA_VALORE ';  --24/'7/2015 la vecchia join fatta sulle descrizioni non andava bene, il codice è stato moltiplicato per 10, perché è il valore contenuto in DOMINIO_PARAMETRI(3=>30,1 =>10 etc.)
      sqlstringa := sqlstringa || ' and CODICE_CONTESTO = 3 ';
      sqlstringa := sqlstringa || ' and SEDE_TECNICA IN (Select '''||p_OP||''' From dual UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE='''||p_OP||''')';
      sqlstringa := sqlstringa || '  group by SEDE_TECNICA ';
      sqlstringa := sqlstringa || ' UNION ';
      sqlstringa := sqlstringa || ' Select SEDE_TECNICA, Listagg(v.DESCRIZIONE,''#'') Within Group (Order By v.DESCRIZIONE) AS PO_TRACK_1_2_1_0_2_3, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE_XML,''#'') Within Group (Order By VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_XML,';
      sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_OV,';
      sqlstringa := sqlstringa || ' Listagg(VALORE,''#'') Within Group (Order By VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_DES';
      sqlstringa := sqlstringa || ' From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v,';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
      sqlstringa := sqlstringa || ' Where';
      sqlstringa := sqlstringa || ' c.codice_parametro = d.codice_parametro ';
      sqlstringa := sqlstringa || ' and numero_parametro = ''1.1.1.1.2.3'' ';
      sqlstringa := sqlstringa || ' and CODICE||''0'' = CODIFICA_VALORE ';  --24/'7/2015 la vecchia join fatta sulle descrizioni non andava bene, il codice è stato moltiplicato per 10, perché è il valore contenuto in DOMINIO_PARAMETRI(3=>30,1 =>10 etc.)
      sqlstringa := sqlstringa || ' and CODICE_CONTESTO = 3 ';
      sqlstringa := sqlstringa || ' and SEDE_TECNICA IN (Select SUBSTR(PO_TRACK_1_2_1_0_0_2,1,6) From '||s_schema||'.REL_PO_BINARI_CORSA Where SEDE_TECNICA = '''||p_OP||''')';
      sqlstringa := sqlstringa || '  group by SEDE_TECNICA) corridoio ';
      sqlstringa := sqlstringa || ' Where r.SEDE_TECNICA = '''||p_OP||''' ';
      sqlstringa := sqlstringa || ' and b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2 ';
 End If;
--  
 sqlstringa := sqlstringa || ' and b.PO_TRACK_1_2_1_0_0_2 = cat_ten.PO_TRACK_1_2_1_0_0_2 (+) ';
 sqlstringa := sqlstringa || ' and b.PO_TRACK_1_2_1_0_0_2 = cat_linea.PO_TRACK_1_2_1_0_0_2 (+) ';
-- 07/11/2016 E' stata cambiata la join: prima era tra la sede tecnica della PO e quella del corridoi,
-- ora è tra i primi sei caratteri del binario e la sede tecnica del corridoio, per garantire
-- la gestione dei binari di fermata (TR) e di quelli delle località contenute
 sqlstringa := sqlstringa || ' and substr(r.PO_TRACK_1_2_1_0_0_2,1,6) = corridoio.SEDE_TECNICA (+) ';
 sqlstringa := sqlstringa || 'Order By 3 ';
--
--  Dbms_Output.Put_Line(sqlstringa);
 Open p_cursor For sqlstringa;
--  
 End GetOPTracks_Infrastructure;
--
-- -----------------------------------------------------------------------------
--                                GetOPTracks_Inf_EC
-- -----------------------------------------------------------------------------
 Procedure GetOPTracks_Inf_EC (p_POTrack Varchar2, P_AREA Number, P_I_VERSIONE Number, P_CURSOR Out EMPCUR) Is
--Ritorna l'elenco delle dichiarazioni di verifica EC e EI di un Binario di Corsa di una OP
--
  S_SCHEMA   Varchar2(100);
--  sqlstringa Varchar2(10000);
   sqlstringa CLOB;
--
  P_VERSIONE Number;
--
 BEGIN
 S_SCHEMA   := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 P_VERSIONE := P_I_VERSIONE;

 If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
      P_VERSIONE := GetLastVersion(P_AREA);
 End If;
-- 1.2.1.0.0.2 - OPTrackIdentification
 sqlstringa :=  'Select Distinct s.PO_TRACK_1_2_1_0_0_2 POTrack_ID,  ';
 sqlstringa := sqlstringa || Nvl(To_Char(p_versione), 'Null')||' CODICE_VERSIONE, ';
 sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione, ';
-- 1.2.1.0.1.1 - IDE_ECVerification -/- 1.2.1.0.1.2 - IDE_EIDemonstration
 sqlstringa := sqlstringa || ' Nvl(PO_TRACK_1_2_1_0_1_1O2_AP,'''||GetNYA('1.2.1.0.1.1')||''') PO_TRACK_1_2_1_0_1_1O2_AP, ';
 sqlstringa := sqlstringa || ' Nvl(PO_TRACK_1_2_1_0_1_1O2, ''00/00000000000000/0000/000000'') PO_TRACK_1_2_1_0_1_1O2, ';
 sqlstringa := sqlstringa || ' KM_INIZIO, ';
 sqlstringa := sqlstringa || ' KM_FINE  ';
-- sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
 sqlstringa := sqlstringa || ' From ';
 sqlstringa := sqlstringa || '(Select PO_TRACK_1_2_1_0_0_2, PO_TRACK_1_2_1_0_1_1O2_AP, PO_TRACK_1_2_1_0_1_1O2, KM_INIZIO, KM_FINE ';
-- sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
 sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_BINARIO_PO ';
 sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE =''EC''' ;
 If p_versione Is Not Null Then
    sqlstringa := sqlstringa || ' and CODICE_VERSIONE = '||p_versione;
 End If;
 sqlstringa := sqlstringa || ') b,  ';
 sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_PO s            ';
 sqlstringa := sqlstringa || ' Where s.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 (+) ';
 sqlstringa := sqlstringa || ' and s.PO_TRACK_1_2_1_0_0_2 = '''||p_POTrack||'''' ;
 If p_versione Is Not Null Then
      sqlstringa := sqlstringa || ' and CODICE_VERSIONE = '||p_versione;
 End If;
 sqlstringa := sqlstringa || ' UNION  ';
 sqlstringa := sqlstringa || ' Select Distinct s.PO_TRACK_1_2_1_0_0_2 POTrack_ID, ';
 sqlstringa := sqlstringa || Nvl(To_Char(p_versione), 'Null')||' CODICE_VERSIONE, ';
 sqlstringa := sqlstringa || '''EI'', ';
 sqlstringa := sqlstringa || ' Nvl(PO_TRACK_1_2_1_0_1_1O2_AP, '''||GetNYA('1.2.1.0.1.2')||''') PO_TRACK_1_2_1_0_1_1O2_AP, ';
 sqlstringa := sqlstringa || ' Nvl(PO_TRACK_1_2_1_0_1_1O2, ''00/00000000000000/0000/000000''), ' ;
 sqlstringa := sqlstringa || ' KM_INIZIO, ' ;
 sqlstringa := sqlstringa || ' KM_FINE ' ;
-- 05/02/2018 LAM da decommentare
-- sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
--
 sqlstringa := sqlstringa || ' From  ' ;
 sqlstringa := sqlstringa || ' (Select PO_TRACK_1_2_1_0_0_2, PO_TRACK_1_2_1_0_1_1O2_AP, PO_TRACK_1_2_1_0_1_1O2, KM_INIZIO, KM_FINE ' ;
-- 05/02/2018 LAM da decommentare
-- sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
 sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_BINARIO_PO ';
 sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EI''';
 If p_versione Is Not Null Then
      sqlstringa := sqlstringa || ' and CODICE_VERSIONE = '||p_versione;
 End If;
 sqlstringa := sqlstringa || ') b, ';
 sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_PO s ';
 sqlstringa := sqlstringa || ' Where s.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 (+) ';
 sqlstringa := sqlstringa || ' and s.PO_TRACK_1_2_1_0_0_2 = '''||p_POTrack||'''';
 If p_versione Is Not Null Then
      sqlstringa := sqlstringa || ' and CODICE_VERSIONE = '||p_versione;
 End If;
 sqlstringa := sqlstringa || ' Order By 3,6 ';
--
 Open p_cursor For sqlstringa;
--
 END GetOPTracks_Inf_EC;
--
-- -----------------------------------------------------------------------------
--                               GetOPTracks_Inf_Tunnel
-- -----------------------------------------------------------------------------
 Procedure GetOPTracks_Inf_Tunnel (P_POTRACK Varchar2, P_AREA Number, P_I_VERSIONE Number, P_CURSOR Out EMPCUR) Is
--Restituisce l'elenco delle gallerie, con realtivi parametri, di un Binario di Corsa di una OP
--
  S_SCHEMA Varchar2(100);
--  Sqlstringa Varchar2(10000);
   sqlstringa CLOB;
--
  P_VERSIONE Number;
   --->
  Data_Validita Date;
--
BEGIN
   S_SCHEMA := PKG_RINF_INTERFACCIA.GetSchemaName(P_AREA);
   P_VERSIONE := P_I_VERSIONE;
--   
  If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
      P_VERSIONE := GetLastVersion(P_AREA);
  End If;
--->
-- ------------------------------------------------------------------------------------------------
-- gestione della data di inizio e fine validità per il parametro	 
-- ------------------------------------------------------------------------------------------------
--
 If P_VERSIONE Is Not Null Then  
    Select Greatest(DATA_PUBBLICAZIONE, DATA_RIFERIMENTO) 
	  Into Data_Validita 
      From RINF_PUBBLICATI_EVO.VERSIONE_RINF
     Where CODICE_VERSIONE = P_VERSIONE;
 Else
     Select Greatest(DATA_CONTROLLO, DATA_RIFERIMENTO) 
	   Into Data_Validita 
       From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI
      Where CODICE_CONTROLLO =(Select Max (CODICE_CONTROLLO) From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI);
 End If;
 -- 1.2.1.0.0.2 - OPTrackIdentification
 sqlstringa :=  'Select Distinct r.PO_TRACK_1_2_1_0_0_2 POTrack_ID, ';
 sqlstringa := sqlstringa || Nvl(To_Char( p_versione), 'Null')||' CODICE_VERSIONE,';
-- 1.2.1.0.5.1 - OPTrackTunnelIMCode
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.5.1'', g.PO_TR_TUNNEL_1_2_1_0_5_1) PO_TR_TUNNEL_1_2_1_0_5_1_XML,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.5.1'', g.PO_TR_TUNNEL_1_2_1_0_5_1) PO_TR_TUNNEL_1_2_1_0_5_1_OV,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.5.1'', g.PO_TR_TUNNEL_1_2_1_0_5_1) PO_TR_TUNNEL_1_2_1_0_5_1_DES,';
 sqlstringa := sqlstringa || 'Nvl( g.PO_TR_TUNNEL_1_2_1_0_5_1, ''0083'') PO_TR_TUNNEL_1_2_1_0_5_1, ';
-- 1.2.1.0.5.2 - OPTrackTunnelIdentification
 sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_2 PO_TR_TUNNEL_1_2_1_0_5_2, ';
 sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_2_D PO_TR_TUNNEL_1_2_1_0_5_2_DES, ';
-- 1.2.1.0.5.5 - ITU_Length
 sqlstringa := sqlstringa || 'PO_TR_TUNNEL_1_2_1_0_5_5_AP, ';
 sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_5, ';
-- 1.2.1.0.5.6 - ITU_EmergencyPlan
 sqlstringa := sqlstringa || 'PO_TR_TUNNEL_1_2_1_0_5_6_AP, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.5.6'', g.PO_TR_TUNNEL_1_2_1_0_5_6) PO_TR_TUNNEL_1_2_1_0_5_6_XML,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.5.6'', g.PO_TR_TUNNEL_1_2_1_0_5_6) PO_TR_TUNNEL_1_2_1_0_5_6_OV,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.5.6'', g.PO_TR_TUNNEL_1_2_1_0_5_6) PO_TR_TUNNEL_1_2_1_0_5_6_DES,';
 sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_6, GetData_Validita(''1.2.1.0.5.6'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_1_0_5_6, ';
-- 1.2.1.0.5.7 - ITU_FireCatReq
 sqlstringa := sqlstringa || 'PO_TR_TUNNEL_1_2_1_0_5_7_AP, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.5.7'', g.PO_TR_TUNNEL_1_2_1_0_5_7) PO_TR_TUNNEL_1_2_1_0_5_7_XML,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.5.7'', g.PO_TR_TUNNEL_1_2_1_0_5_7) PO_TR_TUNNEL_1_2_1_0_5_7_OV,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.5.7'', g.PO_TR_TUNNEL_1_2_1_0_5_7) PO_TR_TUNNEL_1_2_1_0_5_7_DES,';
 sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_7, GetData_Validita(''1.2.1.0.5.7'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_1_0_5_7, ';
-- 1.2.1.0.5.8 - ITU_NatFireCatReq
 sqlstringa := sqlstringa || 'PO_TR_TUNNEL_1_2_1_0_5_8_AP, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.5.8'', g.PO_TR_TUNNEL_1_2_1_0_5_8) PO_TR_TUNNEL_1_2_1_0_5_8_XML, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.5.8'', g.PO_TR_TUNNEL_1_2_1_0_5_8) PO_TR_TUNNEL_1_2_1_0_5_8_OV, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.5.8'', g.PO_TR_TUNNEL_1_2_1_0_5_8) PO_TR_TUNNEL_1_2_1_0_5_8_DES, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.5.8'', g.PO_TR_TUNNEL_1_2_1_0_5_8) PO_TR_TUNNEL_1_2_1_0_5_8,  ';
-- sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_8,  ';
 sqlstringa := sqlstringa || 'GetData_Validita(''1.2.1.0.5.8'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_1_0_5_8, ';
--> 1.2.1.0.5.9 - ITU_DieselThermAllowed (Nuovo parametro Reg.2019/777) - AP (Intera Rete) = N - Valore = []
-- Trazione diesel o altri sistemi di trazione termica consentiti
 sqlstringa := sqlstringa || 'PO_TR_TUNNEL_1_2_1_0_5_9_AP, ';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.5.9'', g.PO_TR_TUNNEL_1_2_1_0_5_9) PO_TR_TUNNEL_1_2_1_0_5_9_XML,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.5.9'', g.PO_TR_TUNNEL_1_2_1_0_5_9) PO_TR_TUNNEL_1_2_1_0_5_9_OV,';
 sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.5.9'', g.PO_TR_TUNNEL_1_2_1_0_5_9) PO_TR_TUNNEL_1_2_1_0_5_9_DES,';
 sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_9, GetData_Validita(''1.2.1.0.5.9'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_1_0_5_9, ';
 sqlstringa := sqlstringa || ' GetPar_attivo(''1.2.1.0.5.9'') Flag_1_2_1_0_5_9_AT '; --> Nuovo attributo
--->
 sqlstringa := sqlstringa || 'From '||s_schema||'.GALLERIE_BINARI_PO g, ';
 sqlstringa := sqlstringa ||  s_schema||'.REL_GALLERIE_BINARI_PO r ';
 sqlstringa := sqlstringa || 'Where  ';
 sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_2 = R.PO_TR_TUNNEL_1_2_1_0_5_2 ';
 sqlstringa := sqlstringa || 'and r.PO_TRACK_1_2_1_0_0_2 = '''||p_POTrack||'''  ';
--
 If p_versione Is Not Null Then
      sqlstringa := sqlstringa || 'and g.CODICE_VERSIONE = '||p_versione;
      sqlstringa := sqlstringa || 'and r.CODICE_VERSIONE = '||p_versione;
 End If;
--
  sqlstringa := sqlstringa || ' Order By 3 ';
-- 
--DBMS_OutPUT.PUT_LINE(sqlstringa);
  Open p_cursor For sqlstringa;
--
END GetOPTracks_Inf_Tunnel;

-- -----------------------------------------------------------------------------
--                         GetOPTracks_Inf_Tunnel_EC
-- -----------------------------------------------------------------------------
 Procedure GetOPTracks_Inf_Tunnel_EC (P_POTRACK_TUNNEL Varchar2, P_AREA Number, P_I_VERSIONE Number, P_CURSOR Out empcur) IS
--Ritorna l'elenco delle dichiarazioni di verifica EC e EI di una galleria di un  Binario di Corsa di una OP
 -- 
   S_SCHEMA   Varchar2(100);
--   sqlstringa Varchar2(10000);
   sqlstringa CLOB;
--
   P_VERSIONE Number;
--
  BEGIN
   S_SCHEMA := PKG_RINF_INTERFACCIA.GetSchemaName(P_AREA);
   P_VERSIONE := P_I_VERSIONE;
-- 
   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
       P_VERSIONE := GetLastVersion(P_AREA);
   End If;
-- 1.2.1.0.5.2 - OPTrackTunnelIdentification
   sqlstringa :=  'Select Distinct s.PO_TR_TUNNEL_1_2_1_0_5_2 POTrack_Tunnel_ID, ';
   sqlstringa := sqlstringa || Nvl(To_Char( p_versione), 'Null')||' CODICE_VERSIONE, ';
-- 1.2.1.0.5.3 - ITU_ECVerification  -/- 1.2.1.0.5.4 - ITU_EIDemonstration
   sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione,                                      ';
   sqlstringa := sqlstringa || 'Nvl(PO_TR_TUNNEL_1_2_1_0_5_3O4_AP, '''||GetNYA('1.2.1.0.5.3')||''') PO_TR_TUNNEL_1_2_1_0_5_3O4_AP, ';
   sqlstringa := sqlstringa || 'Nvl(PO_TR_TUNNEL_1_2_1_0_5_3O4, ''00/00000000000000/0000/000000'') PO_TR_TUNNEL_1_2_1_0_5_3O4, ';
   sqlstringa := sqlstringa || 'KM_INIZIO,  ';
   sqlstringa := sqlstringa || 'KM_FINE ';
-- 05/02/2018 LAM da decommentare
-- sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
   sqlstringa := sqlstringa || ' From ';
   sqlstringa := sqlstringa || '(Select PO_TR_TUNNEL_1_2_1_0_5_2, PO_TR_TUNNEL_1_2_1_0_5_3O4_AP, PO_TR_TUNNEL_1_2_1_0_5_3O4, KM_INIZIO, KM_FINE ';
-- 05/02/2018 LAM da decommentare
-- sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
   sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_PO ';
   sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EC''';
   If p_versione Is Not Null Then
        sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstringa := sqlstringa || ') b, ';
   sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_BINARI_PO s ';
   sqlstringa := sqlstringa || ' Where s.PO_TR_TUNNEL_1_2_1_0_5_2 = b.PO_TR_TUNNEL_1_2_1_0_5_2 (+) ';
   sqlstringa := sqlstringa || ' And s.PO_TR_TUNNEL_1_2_1_0_5_2 = '''||p_POTrack_Tunnel||''''  ;
   If p_versione Is Not Null Then
        sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
   End If;
--
   sqlstringa := sqlstringa || 'UNION ';
   sqlstringa := sqlstringa || 'Select Distinct s.PO_TR_TUNNEL_1_2_1_0_5_2 POTrack_Tunnel_ID, ';
   sqlstringa := sqlstringa || Nvl(To_Char(p_versione), 'Null')||' CODICE_VERSIONE, ';
   sqlstringa := sqlstringa || '''EI'' tipo_dichiarazione, ';
   sqlstringa := sqlstringa || ' Nvl(PO_TR_TUNNEL_1_2_1_0_5_3O4_AP, '''||GetNYA('1.2.1.0.5.4')||''') PO_TR_TUNNEL_1_2_1_0_5_3O4_AP, ';
   sqlstringa := sqlstringa || ' Nvl(PO_TR_TUNNEL_1_2_1_0_5_3O4, ''00/00000000000000/0000/000000'') PO_TR_TUNNEL_1_2_1_0_5_3O4, ';
   sqlstringa := sqlstringa || ' KM_INIZIO, ';
   sqlstringa := sqlstringa || ' KM_FINE ';
-- 05/02/2018 LAM da decommentare
-- sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
   sqlstringa := sqlstringa || ' From ';
   sqlstringa := sqlstringa || '(Select PO_TR_TUNNEL_1_2_1_0_5_2, PO_TR_TUNNEL_1_2_1_0_5_3O4_AP, PO_TR_TUNNEL_1_2_1_0_5_3O4, KM_INIZIO, KM_FINE ';
-- 05/02/2018 LAM da decommentare
-- sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
   sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_PO ';
   sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EI''';
   If p_versione Is Not Null Then
      sqlstringa := sqlstringa || 'And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstringa := sqlstringa || ') b, ';
   sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_BINARI_PO s ';
   sqlstringa := sqlstringa || ' Where s.PO_TR_TUNNEL_1_2_1_0_5_2 = b.PO_TR_TUNNEL_1_2_1_0_5_2 (+) ';
   sqlstringa := sqlstringa || ' And s.PO_TR_TUNNEL_1_2_1_0_5_2 = '''||p_POTrack_Tunnel||''''  ;
   If p_versione Is Not Null Then
        sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstringa := sqlstringa || 'Order By 3,6 ';
--   
   Open p_cursor For sqlstringa;
--DBMS_OutPUT.PUT_LINE(sqlstringa);
--
 End GetOPTracks_Inf_Tunnel_EC;
--
-- -----------------------------------------------------------------------------
--                      GetOPTracks_Inf_Platform - 1.2.0.6 - Marciapiedi
-- Ritorna l'elenco dei marciapiedi, con relativi parametri, di un Binario di Corsa di una OP
--28/09/2016 Aggiunto il parametro della OP per gestire i marciapiedi delle fermate adiacenti
-- -----------------------------------------------------------------------------
-- 
 Procedure GetOPTracks_Inf_Platform (P_PO Varchar2, p_POTrack Varchar2, P_AREA Number, P_I_VERSIONE Number, P_CURSOR Out EMPCUR) Is
--
   S_SCHEMA   Varchar2(100);
--   sqlstringa Varchar2(20000);   
   sqlstringa CLOB;
--
   P_VERSIONE Number;
--   
 BEGIN
   S_SCHEMA   := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
   P_VERSIONE := P_I_VERSIONE;
 -- 
   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
       P_VERSIONE := GetLastVersion(P_AREA);
   End If;
--
   sqlstringa :=  'Select DISTINCT BINARIO_1 POTrack_ID, ';
   sqlstringa := sqlstringa || Nvl(To_Char( p_versione),'Null')||' CODICE_VERSIONE, ';
-- 1.2.1.0.6.1 - OPTrackPlatformIMCode
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_XML, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_OV, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_DES, ';
   sqlstringa := sqlstringa || 'Nvl(PO_TR_PLATFORM_1_2_1_0_6_1,''0083'')  PO_TR_PLATFORM_1_2_1_0_6_1, ';
-- 1.2.1.0.6.2 - OPTrackPlatformIdentification
   sqlstringa := sqlstringa || 'b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
   sqlstringa := sqlstringa || 'b.PO_TR_PLATFORM_1_2_1_0_6_2_D  PO_TR_PLATFORM_1_2_1_0_6_2_DES, ';
-- 1.2.1.0.6.3 - IPL_TENClass
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_3_AP,  ';
   sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_XML, ';
   sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_OV, ';
-- 08/03/2016 incrocio delle colonne verificato per la valorizzazione del file xls
-- quando si effettuerà l'attività di omogenizzazione dei valori dovrà essere verificato di nuovo
   sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3 PO_TR_PLATFORM_1_2_1_0_6_3_DES, ';
   sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_DES PO_TR_PLATFORM_1_2_1_0_6_3, ';
-- 1.2.1.0.6.4 - IPL_Length
   sqlstringa := sqlstringa || 'PO_TR_PLAT_1_2_1_0_6_4_B1_AP,  ';
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_4_B1 PO_TR_PLATFORM_1_2_1_0_6_4, ';
-- 1.2.1.0.6.5 - IPL_Height
   sqlstringa := sqlstringa || 'PO_TR_PLAT_1_2_1_0_6_5_B1_AP, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.6.5.B1'',PO_TR_PLATFORM_1_2_1_0_6_5_B1) PO_TR_PLAT_1_2_1_0_6_5_XML, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.6.5.B1'',PO_TR_PLATFORM_1_2_1_0_6_5_B1) PO_TR_PLAT_1_2_1_0_6_5_OV, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.6.5.B1'',PO_TR_PLATFORM_1_2_1_0_6_5_B1) PO_TR_PLAT_1_2_1_0_6_5_DES, ';
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_5_B1 PO_TR_PLATFORM_1_2_1_0_6_5, ';
-- 1.2.1.0.6.6 - IPL_AssistanceStartingTrain
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_6_AP, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_XML, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_OV, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_DES, ';
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_6, ';
-- 1.2.1.0.6.7 - IPL_AreaBoardingAid
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_7_AP, ';
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_7  ';
--
   sqlstringa := sqlstringa || ' From '||s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
   If p_versione Is Not Null Then
       sqlstringa := sqlstringa || '(Select PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE, Listagg(PO_TR_PLATFORM_1_2_1_0_6_3,''#'') Within Group (Order By KM_INIZIO,PO_TR_PLATFORM_1_2_1_0_6_3) As PO_TR_PLATFORM_1_2_1_0_6_3, ';
       sqlstringa := sqlstringa || ' Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_XML, ';
       sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_OV, ';
       sqlstringa := sqlstringa || ' Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_DES ';
       sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
       sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
       sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
       sqlstringa := sqlstringa || ' Where';
       sqlstringa := sqlstringa || ' c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
       sqlstringa := sqlstringa || ' And numero_parametro = ''1.2.1.0.6.3'' ';
       sqlstringa := sqlstringa || ' And PO_TR_PLATFORM_1_2_1_0_6_3 = CODIFICA_VALORE ';
       sqlstringa := sqlstringa || '  Group By PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE) cat_ten ';
       sqlstringa := sqlstringa || ' Where b.CODICE_VERSIONE = '||p_versione;
       sqlstringa := sqlstringa || ' And b.CODICE_VERSIONE = cat_ten.CODICE_VERSIONE (+) ';
       sqlstringa := sqlstringa || ' And BINARIO_1 = '''||p_POTrack||''' ';
-- 26/09/2016 inserita la condizione sul codice del marciapiede. Questo deve comprendere il codice della località
-- o quello delle località contenute nella località principale.
-- Questa condizione evita che nel caso di marciapiedi di fermate adiacenti queste abbiamo anche i marciapiedi della località adiacente
       sqlstringa := sqlstringa || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) in (Select '''||p_PO||''' From Dual ';
       sqlstringa := sqlstringa || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = '''||p_PO||''' And CODICE_VERSIONE = '||p_versione||') ';
   Else
       sqlstringa := sqlstringa || '(Select PO_TR_PLATFORM_1_2_1_0_6_2, Listagg(PO_TR_PLATFORM_1_2_1_0_6_3, ''#'') Within Group (Order By KM_INIZIO, PO_TR_PLATFORM_1_2_1_0_6_3) As PO_TR_PLATFORM_1_2_1_0_6_3, ';
       sqlstringa := sqlstringa || ' Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_XML, ';
       sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_OV, ';
       sqlstringa := sqlstringa || ' Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_DES ';
       sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
       sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
       sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
       sqlstringa := sqlstringa || ' Where';
       sqlstringa := sqlstringa || ' c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
       sqlstringa := sqlstringa || ' And NUMERO_PARAMETRO = ''1.2.1.0.6.3'' ';
       sqlstringa := sqlstringa || ' And PO_TR_PLATFORM_1_2_1_0_6_3 = CODIFICA_VALORE';
       sqlstringa := sqlstringa || ' Group By PO_TR_PLATFORM_1_2_1_0_6_2) cat_ten ';
       sqlstringa := sqlstringa || 'Where BINARIO_1='''||p_POTrack||''' ';
-- 26/09/2016 inserita la condizione sul codice del marciapiede. Questo deve comprendere il codice della località
-- o quello delle località contenute nella località principale.
-- Questa condizione evita che nel caso di marciapiedi di fermate adiacenti queste abbiamo anche i marciapiedi della località adiacente
--
       sqlstringa := sqlstringa || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) in (Select '''||p_PO||''' From Dual ';
       sqlstringa := sqlstringa || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = '''||p_PO||''')';
   End If;
   sqlstringa := sqlstringa || ' And b.PO_TR_PLATFORM_1_2_1_0_6_2 = cat_ten.PO_TR_PLATFORM_1_2_1_0_6_2 (+) ';
   sqlstringa := sqlstringa || ' UNION ';
   sqlstringa := sqlstringa || ' Select Distinct BINARIO_2 POTrack_ID, ';
   sqlstringa := sqlstringa ||  Nvl(To_Char( p_versione),'Null')||' CODICE_VERSIONE, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_XML, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.6.1'', PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_OV, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.6.1'', PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_DES, ';
   sqlstringa := sqlstringa || 'Nvl(PO_TR_PLATFORM_1_2_1_0_6_1, ''0083'') PO_TR_PLATFORM_1_2_1_0_6_1, ';
   sqlstringa := sqlstringa || 'b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
   sqlstringa := sqlstringa || 'b.PO_TR_PLATFORM_1_2_1_0_6_2_D  PO_TR_PLATFORM_1_2_1_0_6_2_DES, ' ;
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_3_AP, ';
   sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_XML, ';
   sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_OV, ';
   sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3 PO_TR_PLATFORM_1_2_1_0_6_3_DES, ';
   sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_DES PO_TR_PLATFORM_1_2_1_0_6_3, ';
   sqlstringa := sqlstringa || 'PO_TR_PLAT_1_2_1_0_6_4_B2_AP, ';
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_4_B2, ';
   sqlstringa := sqlstringa || 'PO_TR_PLAT_1_2_1_0_6_5_B2_AP, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.6.5.B2'', PO_TR_PLATFORM_1_2_1_0_6_5_B2) PO_TR_PLAT_1_2_1_0_6_5_XML, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.6.5.B2'', PO_TR_PLATFORM_1_2_1_0_6_5_B2) PO_TR_PLAT_1_2_1_0_6_5_OV, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.6.5.B2'', PO_TR_PLATFORM_1_2_1_0_6_5_B2) PO_TR_PLAT_1_2_1_0_6_5_DES, ';
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_5_B2, ';
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_6_AP,  ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_XML, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_OV, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_DES, ';
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_6, ';
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_7_AP,  ';
   sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_7  ';
   sqlstringa := sqlstringa || ' From '||s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
   If p_versione Is Not Null Then
        sqlstringa := sqlstringa || '(Select PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE, Listagg(PO_TR_PLATFORM_1_2_1_0_6_3, ''#'') Within Group (Order By KM_INIZIO, PO_TR_PLATFORM_1_2_1_0_6_3) As PO_TR_PLATFORM_1_2_1_0_6_3, ';
        sqlstringa := sqlstringa || ' Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_XML, ';
        sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_OV, ';
        sqlstringa := sqlstringa || ' Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_DES ';
        sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v, ';
        sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
        sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
        sqlstringa := sqlstringa || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
        sqlstringa := sqlstringa || ' And NUMERO_PARAMETRO = ''1.2.1.0.6.3'' ';
        sqlstringa := sqlstringa || ' And PO_TR_PLATFORM_1_2_1_0_6_3 = CODIFICA_VALORE ';
        sqlstringa := sqlstringa || '  Group By PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE) cat_ten ';
        sqlstringa := sqlstringa || ' Where b.CODICE_VERSIONE = '||p_versione;
        sqlstringa := sqlstringa || ' And b.CODICE_VERSIONE = cat_ten.CODICE_VERSIONE (+) ';
        sqlstringa := sqlstringa || ' And BINARIO_2 = '''||p_POTrack||''' ';
        sqlstringa := sqlstringa || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) in (Select '''||p_PO||''' From Dual ';
        sqlstringa := sqlstringa || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE='''||p_PO||''' and CODICE_VERSIONE = '||p_versione||') ';
   Else
        sqlstringa := sqlstringa || '(Select PO_TR_PLATFORM_1_2_1_0_6_2, Listagg(PO_TR_PLATFORM_1_2_1_0_6_3, ''#'') Within Group (Order By KM_INIZIO, PO_TR_PLATFORM_1_2_1_0_6_3) As PO_TR_PLATFORM_1_2_1_0_6_3, ';
        sqlstringa := sqlstringa || ' Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_XML, ';
        sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_OV, ';
        sqlstringa := sqlstringa || ' Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_DES ';
        sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v, ';
        sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
        sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
        sqlstringa := sqlstringa || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
        sqlstringa := sqlstringa || ' And NUMERO_PARAMETRO = ''1.2.1.0.6.3'' ';
        sqlstringa := sqlstringa || ' And PO_TR_PLATFORM_1_2_1_0_6_3 = CODIFICA_VALORE ';
        sqlstringa := sqlstringa || ' Group By PO_TR_PLATFORM_1_2_1_0_6_2) cat_ten ';
        sqlstringa := sqlstringa || ' Where BINARIO_2='''||p_POTrack||''' ';
        sqlstringa := sqlstringa || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) In (Select '''||p_PO||''' From Dual ';
        sqlstringa := sqlstringa || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE='''||p_PO||''') ';
   End If;
   sqlstringa := sqlstringa || ' And b.PO_TR_PLATFORM_1_2_1_0_6_2 = cat_ten.PO_TR_PLATFORM_1_2_1_0_6_2 (+) ';
   sqlstringa := sqlstringa || ' UNION ';
   sqlstringa := sqlstringa || ' Select Distinct BINARIO_3 POTrack_ID, ';
   sqlstringa := sqlstringa || Nvl(To_Char( p_versione),'Null')||' CODICE_VERSIONE, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.6.1'', PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.6.1'', PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.6.1'', PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_DES, ';
   sqlstringa := sqlstringa || ' Nvl(PO_TR_PLATFORM_1_2_1_0_6_1,''0083'') PO_TR_PLATFORM_1_2_1_0_6_1, ';
   sqlstringa := sqlstringa || ' b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
   sqlstringa := sqlstringa || ' b.PO_TR_PLATFORM_1_2_1_0_6_2_D PO_TR_PLATFORM_1_2_1_0_6_2_DES, ' ;
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_3_AP, ';
   sqlstringa := sqlstringa || ' cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_XML, ';
   sqlstringa := sqlstringa || ' cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_OV, ';
   sqlstringa := sqlstringa || ' cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3 PO_TR_PLATFORM_1_2_1_0_6_3_DES, ';
   sqlstringa := sqlstringa || ' cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_DES PO_TR_PLATFORM_1_2_1_0_6_3, ';
   sqlstringa := sqlstringa || ' PO_TR_PLAT_1_2_1_0_6_4_B3_AP, ';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_4_B3, ';
   sqlstringa := sqlstringa || ' PO_TR_PLAT_1_2_1_0_6_5_B3_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.6.5.B3'', PO_TR_PLATFORM_1_2_1_0_6_5_B3) PO_TR_PLAT_1_2_1_0_6_5_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.6.5.B3'', PO_TR_PLATFORM_1_2_1_0_6_5_B3) PO_TR_PLAT_1_2_1_0_6_5_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.6.5.B3'',PO_TR_PLATFORM_1_2_1_0_6_5_B3) PO_TR_PLAT_1_2_1_0_6_5_DES, ';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_5_B3, ';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_6_AP,  ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_DES, ';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_6, ';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_7_AP,  ';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_7  ';
   sqlstringa := sqlstringa || ' From '||s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
   If p_versione Is Not Null Then
      sqlstringa := sqlstringa || ' (Select PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE, Listagg(PO_TR_PLATFORM_1_2_1_0_6_3, ''#'') Within Group (Order By KM_INIZIO, PO_TR_PLATFORM_1_2_1_0_6_3) As PO_TR_PLATFORM_1_2_1_0_6_3, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_XML, ';
      sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_OV, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_DES ';
      sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
      sqlstringa := sqlstringa || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
      sqlstringa := sqlstringa || ' And NUMERO_PARAMETRO = ''1.2.1.0.6.3'' ';
      sqlstringa := sqlstringa || ' And PO_TR_PLATFORM_1_2_1_0_6_3 = CODIFICA_VALORE ';
      sqlstringa := sqlstringa || ' Group By PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE) cat_ten ';
      sqlstringa := sqlstringa || ' Where b.CODICE_VERSIONE = '||p_versione;
      sqlstringa := sqlstringa || ' And b.CODICE_VERSIONE = cat_ten.CODICE_VERSIONE (+) ';
      sqlstringa := sqlstringa || ' And BINARIO_3 = '''||p_POTrack||''' ';
      sqlstringa := sqlstringa || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) In (Select '''||p_PO||''' From Dual ';
      sqlstringa := sqlstringa || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = '''||p_PO||''' and CODICE_VERSIONE = '||p_versione||') ';
   Else
      sqlstringa := sqlstringa || '(Select PO_TR_PLATFORM_1_2_1_0_6_2,  Listagg(PO_TR_PLATFORM_1_2_1_0_6_3, ''#'') Within Group (Order By KM_INIZIO, PO_TR_PLATFORM_1_2_1_0_6_3) As PO_TR_PLATFORM_1_2_1_0_6_3, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_XML, ';
      sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_OV, ';
      sqlstringa := sqlstringa || ' Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_DES ';
      sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
      sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
      sqlstringa := sqlstringa || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
      sqlstringa := sqlstringa || ' And NUMERO_PARAMETRO = ''1.2.1.0.6.3'' ';
      sqlstringa := sqlstringa || ' And PO_TR_PLATFORM_1_2_1_0_6_3 = CODIFICA_VALORE ';
      sqlstringa := sqlstringa || ' Group By PO_TR_PLATFORM_1_2_1_0_6_2) cat_ten ';
      sqlstringa := sqlstringa || ' Where BINARIO_3 = '''||p_POTrack||''' ';
      sqlstringa := sqlstringa || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) in (Select '''||p_PO||''' From Dual ';
      sqlstringa := sqlstringa || ' UNION Select sede_tecnica From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = '''||p_PO||''')';
   End If;
   sqlstringa := sqlstringa || ' And b.PO_TR_PLATFORM_1_2_1_0_6_2 = cat_ten.PO_TR_PLATFORM_1_2_1_0_6_2 (+) ';
   sqlstringa := sqlstringa || ' UNION ';
   Sqlstringa := Sqlstringa || ' Select Distinct BINARIO_4 POTrack_ID, ';
   sqlstringa := sqlstringa ||   Nvl(To_Char( p_versione),'Null')||' CODICE_VERSIONE, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.6.1'', PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.6.1'', PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.6.1'', PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_DES, ';
   sqlstringa := sqlstringa || ' Nvl(PO_TR_PLATFORM_1_2_1_0_6_1, ''0083'') PO_TR_PLATFORM_1_2_1_0_6_1, ';
   sqlstringa := sqlstringa || ' b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
   sqlstringa := sqlstringa || ' b.PO_TR_PLATFORM_1_2_1_0_6_2_D PO_TR_PLATFORM_1_2_1_0_6_2_DES, ';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_3_AP, ';
   sqlstringa := sqlstringa || ' cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_XML, ';
   sqlstringa := sqlstringa || ' cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_OV, ';
   sqlstringa := sqlstringa || ' cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3 PO_TR_PLATFORM_1_2_1_0_6_3_DES, ';
   sqlstringa := sqlstringa || ' cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_DES PO_TR_PLATFORM_1_2_1_0_6_3, ';
   sqlstringa := sqlstringa || ' PO_TR_PLAT_1_2_1_0_6_4_B4_AP, ';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_4_B4, ';
   sqlstringa := sqlstringa || ' PO_TR_PLAT_1_2_1_0_6_5_B4_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.6.5.B4'', PO_TR_PLATFORM_1_2_1_0_6_5_B4) PO_TR_PLAT_1_2_1_0_6_5_XML,';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.6.5.B4'', PO_TR_PLATFORM_1_2_1_0_6_5_B4) PO_TR_PLAT_1_2_1_0_6_5_OV,';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.6.5.B4'', PO_TR_PLATFORM_1_2_1_0_6_5_B4) PO_TR_PLAT_1_2_1_0_6_5_DES,';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_5_B4, ';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_6_AP,  ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.1.0.6.6'', PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_XML,';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.1.0.6.6'', PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_OV,';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.1.0.6.6'', PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_DES,';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_6, ';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_7_AP,  ';
   sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_7  ';
   sqlstringa := sqlstringa || ' From '||s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
   If p_versione Is Not Null Then
        sqlstringa := sqlstringa || ' (Select PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE, Listagg(PO_TR_PLATFORM_1_2_1_0_6_3, ''#'') Within Group (Order By KM_INIZIO, PO_TR_PLATFORM_1_2_1_0_6_3) As PO_TR_PLATFORM_1_2_1_0_6_3, ';
        sqlstringa := sqlstringa || ' Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_XML, ';
        sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_OV, ';
        sqlstringa := sqlstringa || ' Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_DES ';
        sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v, ';
        sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
        sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
        sqlstringa := sqlstringa || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
        sqlstringa := sqlstringa || ' And NUMERO_PARAMETRO = ''1.2.1.0.6.3'' ';
        sqlstringa := sqlstringa || ' And PO_TR_PLATFORM_1_2_1_0_6_3 = CODIFICA_VALORE ';
        sqlstringa := sqlstringa || ' Group By PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE) cat_ten ';
        sqlstringa := sqlstringa || ' Where b.CODICE_VERSIONE = '||p_versione;
        sqlstringa := sqlstringa || ' And b.CODICE_VERSIONE = cat_ten.CODICE_VERSIONE (+) ';
        sqlstringa := sqlstringa || ' And BINARIO_4 = '''||p_POTrack||''' ';
        sqlstringa := sqlstringa || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) in (Select '''||p_PO||''' From Dual ';
        sqlstringa := sqlstringa || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = '''||p_PO||''' And CODICE_VERSIONE = '||p_versione||')';
   Else
        sqlstringa := sqlstringa || ' (Select PO_TR_PLATFORM_1_2_1_0_6_2,  Listagg(PO_TR_PLATFORM_1_2_1_0_6_3, ''#'') Within Group (Order By KM_INIZIO, PO_TR_PLATFORM_1_2_1_0_6_3) As PO_TR_PLATFORM_1_2_1_0_6_3, ';
        sqlstringa := sqlstringa || ' Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_XML, ';
        sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_OV, ';
        sqlstringa := sqlstringa || ' Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO,VALORE_XML) As PO_TR_PLATFORM_1_2_1_0_6_3_DES ';
        sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
        sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
        sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
        sqlstringa := sqlstringa || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
        sqlstringa := sqlstringa || ' And NUMERO_PARAMETRO = ''1.2.1.0.6.3'' ';
        sqlstringa := sqlstringa || ' And PO_TR_PLATFORM_1_2_1_0_6_3 = CODIFICA_VALORE ';
        sqlstringa := sqlstringa || ' Group By PO_TR_PLATFORM_1_2_1_0_6_2) cat_ten ';
        sqlstringa := sqlstringa || ' Where BINARIO_4 = '''||p_POTrack||''' ';
        sqlstringa := sqlstringa || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) in (Select '''||p_PO||''' From Dual ';
        sqlstringa := sqlstringa || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = '''||p_PO||''')';
   End If;
   sqlstringa := sqlstringa || ' and b.PO_TR_PLATFORM_1_2_1_0_6_2 = cat_ten.PO_TR_PLATFORM_1_2_1_0_6_2 (+) ';
   sqlstringa := sqlstringa || ' Order By 3 ';
--
   Open p_cursor For sqlstringa;
--  Dbms_Output.Put_Line(sqlstringa);
--
 End GetOPTracks_Inf_Platform;

-- -----------------------------------------------------------------------------
--                    GetOPSiding_Infrastructure 
-- 1.2.2 OPSiding - Binari di raccordo
-- Ritorna l'elenco dei  Binari di Raccordo di una OP, con relativi parametri
-- -----------------------------------------------------------------------------
 Procedure GetOPSiding_Infrastructure (P_PO Varchar2, P_AREA Number, P_I_VERSIONE Number, P_CURSOR Out EMPCUR) Is
    S_SCHEMA   Varchar2(100);
--    sqlstringa Varchar2(10000);
    sqlstringa CLOB;
--
    P_VERSIONE Number;
--->
    Data_Validita Date;
 BEGIN
    S_SCHEMA := PKG_RINF_INTERFACCIA.GetSchemaName(P_AREA);
    P_VERSIONE := P_I_VERSIONE;
--  
    If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
          P_VERSIONE := GetLastVersion(P_AREA);
    End If;
--->
-- ------------------------------------------------------------------------------------------------
-- gestione della data di inizio e fine validità per il parametro	 
-- ------------------------------------------------------------------------------------------------
--
   If P_VERSIONE Is Not Null Then  
       Select Greatest(DATA_PUBBLICAZIONE, DATA_RIFERIMENTO) 
	     Into Data_Validita 
         From RINF_PUBBLICATI_EVO.VERSIONE_RINF
        Where CODICE_VERSIONE = P_VERSIONE;
   Else
        Select Greatest(DATA_CONTROLLO, DATA_RIFERIMENTO) 
	      Into Data_Validita 
          From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI
         Where CODICE_CONTROLLO =(Select Max(CODICE_CONTROLLO) From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI);
   End If;
-- 
   sqlstringa :=  'Select Distinct b.SEDE_TECNICA PO_ID, ';
   sqlstringa := sqlstringa ||   Nvl(To_Char( p_versione), 'Null')||' CODICE_VERSIONE, ';
-- 1.2.2.0.0.1 - OPSidingIMCode
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.0.1'', PO_SD_1_2_2_0_0_1) PO_SD_1_2_2_0_0_1_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.0.1'', PO_SD_1_2_2_0_0_1) PO_SD_1_2_2_0_0_1_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.0.1'', PO_SD_1_2_2_0_0_1) PO_SD_1_2_2_0_0_1_DES, ';
   sqlstringa := sqlstringa || ' Nvl(PO_SD_1_2_2_0_0_1, ''0083'') PO_SD_1_2_2_0_0_1, ';
-- 1.2.2.0.0.2 - OPSidingIdentification
   sqlstringa := sqlstringa || ' b.PO_SD_1_2_2_0_0_2, ';
   sqlstringa := sqlstringa || ' b.PO_SD_1_2_2_0_0_2_D PO_SD_1_2_2_0_0_2_DES, ';
-- 1.2.2.0.0.3 - IPP_TENClass
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_0_3_AP, ';
   sqlstringa := sqlstringa || ' cat_ten.PO_SD_1_2_2_0_0_3_XML,';
   sqlstringa := sqlstringa || ' cat_ten.PO_SD_1_2_2_0_0_3_OV,';
   sqlstringa := sqlstringa || ' cat_ten.PO_SD_1_2_2_0_0_3 PO_SD_1_2_2_0_0_3_DES,';
   sqlstringa := sqlstringa || ' cat_ten.PO_SD_1_2_2_0_0_3_DES PO_SD_1_2_2_0_0_3, ';
-- 1.2.2.0.2.1 - IPP_Length
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_2_1_AP, ';
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_2_1, ';
-- 1.2.2.0.3.1 - ILL_Gradient
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_3_1_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.3.1'', PO_SD_1_2_2_0_3_1) PO_SD_1_2_2_0_3_1_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.3.1'', PO_SD_1_2_2_0_3_1) PO_SD_1_2_2_0_3_1_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.3.1'', PO_SD_1_2_2_0_3_1) PO_SD_1_2_2_0_3_1_DES, ';
   sqlstringa := sqlstringa || ' Trim(To_Char(Round(PO_SD_1_2_2_0_3_1,1), ''999990.9'')) PO_SD_1_2_2_0_3_1, GetData_Validita(''1.2.2.0.3.1'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_2_0_3_1, ';
-- 1.2.2.0.3.2 - ILL_MinRadHorzCurve
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_3_2_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.3.2'', PO_SD_1_2_2_0_3_2) PO_SD_1_2_2_0_3_2_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.3.2'', PO_SD_1_2_2_0_3_2) PO_SD_1_2_2_0_3_2_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.3.2'', PO_SD_1_2_2_0_3_2) PO_SD_1_2_2_0_3_2_DES, ';
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_3_2, GetData_Validita(''1.2.2.0.3.2'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''', ''dd/mm/yyyy'')) Flag_1_2_2_0_3_2, ';
-- 1.2.2.0.3.3 - ILL_MinRadVertCurve
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_3_3_AP, ';
   sqlstringa := sqlstringa || ' Decode(PO_SD_1_2_2_0_3_3_A||''+''||PO_SD_1_2_2_0_3_3_B,''+'', Null, PO_SD_1_2_2_0_3_3_A||''+''||PO_SD_1_2_2_0_3_3_B) PO_SD_1_2_2_0_3_3_XML, ';
   sqlstringa := sqlstringa || ' Null PO_SD_1_2_2_0_3_3_OV,';
   sqlstringa := sqlstringa || ' Decode(PO_SD_1_2_2_0_3_3_A||''+''||PO_SD_1_2_2_0_3_3_B,''+'', Null, PO_SD_1_2_2_0_3_3_A||''+''||PO_SD_1_2_2_0_3_3_B) PO_SD_1_2_2_0_3_3_DES, ';
   sqlstringa := sqlstringa || ' Decode(PO_SD_1_2_2_0_3_3_A||''+''||PO_SD_1_2_2_0_3_3_B,''+'', Null, PO_SD_1_2_2_0_3_3_A||''+''||PO_SD_1_2_2_0_3_3_B) PO_SD_1_2_2_0_3_3, ';
   sqlstringa := sqlstringa || ' GetData_Validita(''1.2.2.0.3.3'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''', ''dd/mm/yyyy'')) Flag_1_2_2_0_3_3, ';
-- 1.2.2.0.4.1 - ITS_ToiletDischarge
  sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_4_1_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.4.1'', PO_SD_1_2_2_0_4_1) PO_SD_1_2_2_0_4_1_XML,';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.4.1'', PO_SD_1_2_2_0_4_1) PO_SD_1_2_2_0_4_1_OV,';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.4.1'', PO_SD_1_2_2_0_4_1) PO_SD_1_2_2_0_4_1_DES,';
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_4_1, GetData_Validita(''1.2.2.0.4.1'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_2_0_4_1, ';
-- 1.2.2.0.4.2 - ITS_ExternalCleaning
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_4_2_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.4.2'', PO_SD_1_2_2_0_4_2) PO_SD_1_2_2_0_4_2_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.4.2'', PO_SD_1_2_2_0_4_2) PO_SD_1_2_2_0_4_2_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.4.2'', PO_SD_1_2_2_0_4_2) PO_SD_1_2_2_0_4_2_DES, ';
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_4_2, GetData_Validita(''1.2.2.0.4.2'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_2_0_4_2, ';
-- 1.2.2.0.4.3 - ITS_WaterRestocking
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_4_3_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.4.3'', PO_SD_1_2_2_0_4_3) PO_SD_1_2_2_0_4_3_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.4.3'', PO_SD_1_2_2_0_4_3) PO_SD_1_2_2_0_4_3_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.4.3'', PO_SD_1_2_2_0_4_3) PO_SD_1_2_2_0_4_3_DES, ';
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_4_3, GetData_Validita(''1.2.2.0.4.3'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_2_0_4_3, ';
-- 1.2.2.0.4.4 - ITS_Refuelling
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_4_4_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.4.4'', PO_SD_1_2_2_0_4_4) PO_SD_1_2_2_0_4_4_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.4.4'', PO_SD_1_2_2_0_4_4) PO_SD_1_2_2_0_4_4_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.4.4'', PO_SD_1_2_2_0_4_4) PO_SD_1_2_2_0_4_4_DES, ';
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_4_4, GetData_Validita(''1.2.2.0.4.4'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_2_0_4_4, ';
-- 1.2.2.0.4.5 - ITS_SandRestocking
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_4_5_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.4.5'', PO_SD_1_2_2_0_4_5) PO_SD_1_2_2_0_4_5_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.4.5'', PO_SD_1_2_2_0_4_5) PO_SD_1_2_2_0_4_5_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.4.5'', PO_SD_1_2_2_0_4_5) PO_SD_1_2_2_0_4_5_DES, ';
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_4_5, GetData_Validita(''1.2.2.0.4.5'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_2_0_4_5, ';
-- 1.2.2.0.4.6 - ITS_ElectricShoreSupply
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_4_6_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.4.6'', PO_SD_1_2_2_0_4_6) PO_SD_1_2_2_0_4_6_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.4.6'', PO_SD_1_2_2_0_4_6) PO_SD_1_2_2_0_4_6_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.4.6'', PO_SD_1_2_2_0_4_6) PO_SD_1_2_2_0_4_6_DES, ';
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_4_6, GetData_Validita(''1.2.2.0.4.6'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_2_0_4_6, ';
--> 1.2.2.0.6.1 - ECS_MaxStandstillCurrent - (Nuovo parametro Reg.2019/777) Corrente massima a treno fermo per pantografo. RFI=[200] - COSTANTE Intera Rete
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_6_1_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.6.1'', PO_SD_1_2_2_0_6_1) PO_SD_1_2_2_0_6_1_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.6.1'', PO_SD_1_2_2_0_6_1) PO_SD_1_2_2_0_6_1_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.6.1'', PO_SD_1_2_2_0_6_1) PO_SD_1_2_2_0_6_1_DES, ';
   sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_6_1, GetData_Validita(''1.2.2.0.6.1'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_2_2_0_6_1, ';
   sqlstringa := sqlstringa || ' GetPar_attivo(''1.2.2.0.6.1'') Flag_1_2_2_0_6_1_AT '; --> Nuovo attributo
-->
   sqlstringa := sqlstringa || 'From '||s_schema||'.BINARI_RACCORDO_PO b, ';
   --
   If p_versione Is Not Null Then
        sqlstringa := sqlstringa || '(Select PO_SD_1_2_2_0_0_2, CODICE_VERSIONE, Listagg(PO_SD_1_2_2_0_0_3, ''#'') Within Group (Order By KM_INIZIO, PO_SD_1_2_2_0_0_3) As PO_SD_1_2_2_0_0_3, ';
        sqlstringa := sqlstringa || ' Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As PO_SD_1_2_2_0_0_3_XML, ';
        sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As PO_SD_1_2_2_0_0_3_OV, ';
        sqlstringa := sqlstringa || ' Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As PO_SD_1_2_2_0_0_3_DES ';
        sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_2_0_0_3_CAT_TEN_SD v, ';
        sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
        sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
        sqlstringa := sqlstringa || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
        sqlstringa := sqlstringa || ' And NUMERO_PARAMETRO = ''1.2.2.0.0.3'' ';
        sqlstringa := sqlstringa || ' And PO_SD_1_2_2_0_0_3 = CODIFICA_VALORE ';
        sqlstringa := sqlstringa || ' Group By PO_SD_1_2_2_0_0_2, CODICE_VERSIONE) cat_ten ';
        sqlstringa := sqlstringa || ' Where b.CODICE_VERSIONE = '||p_versione;
        sqlstringa := sqlstringa || ' And b.CODICE_VERSIONE = cat_ten.CODICE_VERSIONE (+) ';
        sqlstringa := sqlstringa || ' And b.SEDE_TECNICA = '''||p_PO||''' ';
   Else
        sqlstringa := sqlstringa || ' (Select PO_SD_1_2_2_0_0_2, Listagg(PO_SD_1_2_2_0_0_3, ''#'') Within Group (Order By KM_INIZIO, PO_SD_1_2_2_0_0_3) As PO_SD_1_2_2_0_0_3, ';
        sqlstringa := sqlstringa || ' Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As PO_SD_1_2_2_0_0_3_XML, ';
        sqlstringa := sqlstringa || ' Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As PO_SD_1_2_2_0_0_3_OV, ';
        sqlstringa := sqlstringa || ' Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As PO_SD_1_2_2_0_0_3_DES ';
        sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_2_2_0_0_3_CAT_TEN_SD v, ';
        sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
        sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
        sqlstringa := sqlstringa || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
        sqlstringa := sqlstringa || ' And NUMERO_PARAMETRO = ''1.2.2.0.0.3'' ';
        sqlstringa := sqlstringa || ' And PO_SD_1_2_2_0_0_3 = CODIFICA_VALORE ';
        sqlstringa := sqlstringa || ' Group By PO_SD_1_2_2_0_0_2) cat_ten ';
        sqlstringa := sqlstringa || ' Where b.SEDE_TECNICA = '''||p_PO||''' ';
   End If;
   sqlstringa := sqlstringa || ' And b.PO_SD_1_2_2_0_0_2 = cat_ten.PO_SD_1_2_2_0_0_2 (+) ';
   sqlstringa := sqlstringa || ' Order By 3 ';
--
  Open p_cursor For sqlstringa;
--DBMS_OutPUT.PUT_LINE(sqlstringa);
--
END GetOPSiding_Infrastructure;
--
-- -----------------------------------------------------------------------------
--                             GetOPSiding_Inf_EC
-- Ritorna l'elenco delle dichiarazioni di verifica EC e EI di  un Binario di Raccordo di una OP
-- -----------------------------------------------------------------------------
 Procedure GetOPSiding_Inf_EC (p_POSiding Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur) Is
--
  s_schema Varchar2(100);
--  sqlstringa Varchar2(10000);
   sqlstringa CLOB;
--
  p_versione Number;
--
BEGIN
  S_SCHEMA   := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  P_VERSIONE := P_I_VERSIONE;
-- 
  If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
       P_VERSIONE := GetLastVersion(P_AREA);
  End If;
-- 1.2.2.0.0.2 - OPSidingIdentification
  sqlstringa :=  'Select DISTINCT s.PO_SD_1_2_2_0_0_2 POSiding_ID, ';
  sqlstringa := sqlstringa ||  Nvl(To_Char( p_versione), 'Null')||' CODICE_VERSIONE, ';
  sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione,  ';
-- 1.2.2.0.1.1 - IDE_ECVerification -/- 1.2.2.0.1.2 - IDE_EIDemonstration
  sqlstringa := sqlstringa || ' Nvl(PO_SD_1_2_2_0_1_1O2_AP, '''||GetNYA('1.2.2.0.1.1')||''') PO_SD_1_2_2_0_1_1O2_AP, ';
  sqlstringa := sqlstringa || ' Nvl(PO_SD_1_2_2_0_1_1O2, ''00/00000000000000/0000/000000'') PO_SD_1_2_2_0_1_1O2, ';
  sqlstringa := sqlstringa || ' KM_INIZIO, ';
  sqlstringa := sqlstringa || ' KM_FINE  ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
  sqlstringa := sqlstringa || ' From ';
  sqlstringa := sqlstringa || ' (Select PO_SD_1_2_2_0_0_2, PO_SD_1_2_2_0_1_1O2_AP, PO_SD_1_2_2_0_1_1O2, KM_INIZIO, KM_FINE ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
  sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_RACCORDO_PO ';
  sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EC''';
  If p_versione Is Not Null Then
       sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
  End If;
  sqlstringa := sqlstringa || ') b, ';
  sqlstringa := sqlstringa ||   s_schema||'.BINARI_RACCORDO_PO s ';
  sqlstringa := sqlstringa || ' Where s.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2 (+) ';
  sqlstringa := sqlstringa || ' And s.PO_SD_1_2_2_0_0_2 = '''||p_POSiding||''''  ;
  If p_versione Is Not Null Then
       sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
  End If;
  sqlstringa := sqlstringa || ' UNION  ';
  sqlstringa := sqlstringa || ' Select Distinct s.PO_SD_1_2_2_0_0_2 POSiding_ID, ';
  sqlstringa := sqlstringa ||   Nvl(To_Char( p_versione), 'Null')||' CODICE_VERSIONE, ';
  sqlstringa := sqlstringa || '''EI'' tipo_dichiarazione,  ';
  sqlstringa := sqlstringa || ' Nvl(PO_SD_1_2_2_0_1_1O2_AP, '''||GetNYA('1.2.2.0.1.2')||''')  PO_SD_1_2_2_0_1_1O2_AP, ';
  sqlstringa := sqlstringa || ' Nvl(PO_SD_1_2_2_0_1_1O2, ''00/00000000000000/0000/000000'') PO_SD_1_2_2_0_1_1O2, ';
  sqlstringa := sqlstringa || ' KM_INIZIO, ';
  sqlstringa := sqlstringa || ' KM_FINE ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
  sqlstringa := sqlstringa || ' From ';
  sqlstringa := sqlstringa || ' (Select PO_SD_1_2_2_0_0_2, PO_SD_1_2_2_0_1_1O2_AP, PO_SD_1_2_2_0_1_1O2, KM_INIZIO, KM_FINE  ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
  sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_RACCORDO_PO ';
  sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EI''';
  if p_versione Is Not Null Then
       sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
  End If;
  sqlstringa := sqlstringa || ') b, ';
  sqlstringa := sqlstringa ||  s_schema||'.BINARI_RACCORDO_PO s ';
  sqlstringa := sqlstringa || ' Where s.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2 (+) ';
  sqlstringa := sqlstringa || ' And s.PO_SD_1_2_2_0_0_2 = '''||p_POSiding||''''  ;
  If p_versione Is Not Null Then
       sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
  End If;
  sqlstringa := sqlstringa || ' Order By 2 ';
--  
  Open p_cursor For sqlstringa;
  --DBMS_OutPUT.PUT_LINE(sqlstringa);
--  
 End GetOPSiding_Inf_EC;
--
-- ------------------------------------------------------------------------------------------------
--                                   GetOPSiding_Inf_Tunnel
-- 1.2.2.0.5 OPSidingTunnel (gallerie dei binari di raccordo o secondari)
-- Ritorna l'elenco delle gallerie di un Binario di Raccordo di una OP, con relativi parametri
-- ------------------------------------------------------------------------------------------------
 Procedure GetOPSiding_Inf_Tunnel (p_POSiding Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur) Is
--
   s_schema Varchar2(100);
--   sqlstringa Varchar2(10000);
   sqlstringa   CLOB;            
--
   p_versione Number;
--
 BEGIN
   S_SCHEMA   := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
   P_VERSIONE := P_I_VERSIONE;
 --  
   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
        P_VERSIONE := GetLastVersion(P_AREA);
   End If;
-- 1.2.2.0.0.2 - OPSidingIdentification
   sqlstringa := 'Select DISTINCT PO_SD_1_2_2_0_0_2 POSiding_ID, ';
   sqlstringa := sqlstringa || Nvl(To_Char(p_versione), 'Null')||' CODICE_VERSIONE, ';
-- 1.2.2.0.5.1 - OPSidingTunnelIMCode
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.5.1'', g.PO_SD_TUNNEL_1_2_2_0_5_1) PO_SD_TUNNEL_1_2_2_0_5_1_XML, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.5.1'', g.PO_SD_TUNNEL_1_2_2_0_5_1) PO_SD_TUNNEL_1_2_2_0_5_1_OV, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.5.1'', g.PO_SD_TUNNEL_1_2_2_0_5_1) PO_SD_TUNNEL_1_2_2_0_5_1_DES, ';
   sqlstringa := sqlstringa || 'Nvl( g.PO_SD_TUNNEL_1_2_2_0_5_1, ''0083'')  PO_SD_TUNNEL_1_2_2_0_5_1, ';
-- 1.2.2.0.5.2 - OPSidingTunnelIdentification
   sqlstringa := sqlstringa || 'g.PO_SD_TUNNEL_1_2_2_0_5_2 PO_SD_TUNNEL_1_2_2_0_5_2, ';
   sqlstringa := sqlstringa || 'g.PO_SD_TUNNEL_1_2_2_0_5_2_D PO_SD_TUNNEL_1_2_2_0_5_2_DES, ';
-- 1.2.2.0.5.5 - ITU_Length
   sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_5_AP, ';
   sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_5, ';
-- 1.2.2.0.5.6 - ITU_EmergencyPlan
   sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_6_AP, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.5.6'',PO_SD_TUNNEL_1_2_2_0_5_6) PO_SD_TUNNEL_1_2_2_0_5_6_XML, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.5.6'',PO_SD_TUNNEL_1_2_2_0_5_6) PO_SD_TUNNEL_1_2_2_0_5_6_OV, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.5.6'',PO_SD_TUNNEL_1_2_2_0_5_6) PO_SD_TUNNEL_1_2_2_0_5_6_DES, ';
   sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_6, ';
-- 1.2.2.0.5.7 - ITU_FireCatReq
   sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_7_AP, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.5.7'',PO_SD_TUNNEL_1_2_2_0_5_7) PO_SD_TUNNEL_1_2_2_0_5_7_XML, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.5.7'',PO_SD_TUNNEL_1_2_2_0_5_7) PO_SD_TUNNEL_1_2_2_0_5_7_OV, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.5.7'',PO_SD_TUNNEL_1_2_2_0_5_7) PO_SD_TUNNEL_1_2_2_0_5_7_DES, ';
   sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_7, ';
-- 1.2.2.0.5.8 - ITU_NatFireCatReq
   sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_8_AP, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.2.0.5.8'',PO_SD_TUNNEL_1_2_2_0_5_8) PO_SD_TUNNEL_1_2_2_0_5_8_XML, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.2.0.5.8'',PO_SD_TUNNEL_1_2_2_0_5_8) PO_SD_TUNNEL_1_2_2_0_5_8_OV, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.5.8'',PO_SD_TUNNEL_1_2_2_0_5_8) PO_SD_TUNNEL_1_2_2_0_5_8_DES, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.2.0.5.8'',PO_SD_TUNNEL_1_2_2_0_5_8) PO_SD_TUNNEL_1_2_2_0_5_8 ';
   sqlstringa := sqlstringa || 'From '||s_schema||'.GALLERIE_RACCORDO_PO g, ';
   sqlstringa := sqlstringa || s_schema||'.REL_GALLERIE_RACCORDO_PO r ';
   sqlstringa := sqlstringa || ' Where  r.PO_SD_TUNNEL_1_2_2_0_5_2 = G.PO_SD_TUNNEL_1_2_2_0_5_2  ';
   sqlstringa := sqlstringa || ' And PO_SD_1_2_2_0_0_2 = '''||p_POSiding||'''  ';
   If p_versione Is Not Null Then
        sqlstringa := sqlstringa || 'And g.CODICE_VERSIONE = '||p_versione;
        sqlstringa := sqlstringa || 'And r.CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstringa := sqlstringa || ' Order By 2  ';
--
   Open p_cursor For sqlstringa;
--
 END GetOPSiding_Inf_Tunnel;

-- ------------------------------------------------------------------------------------------------
--                                       GetOPSiding_Inf_Tunnel_EC
-- Ritorna l'elenco delle dichiarazioni di verifica EC e EI di una galleria di un Binario di Raccordo di una OP
-- ------------------------------------------------------------------------------------------------
 Procedure GetOPSiding_Inf_Tunnel_EC (p_POSiding_Tunnel Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur) Is
   s_schema   Varchar2(100);
--   sqlstringa Varchar2(10000);
   sqlstringa CLOB;
--
   p_versione Number;
 Begin
   S_SCHEMA   := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
   P_VERSIONE := P_I_VERSIONE;
   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
        P_VERSIONE := GetLastVersion(P_AREA);
   End If;
-- 1.2.2.0.5.2 - OPSidingTunnelIdentification
 sqlstringa :=  'Select DISTINCT s.PO_SD_TUNNEL_1_2_2_0_5_2 POSiding_Tunnel_ID, ';
 sqlstringa := sqlstringa ||  Nvl(To_Char( p_versione), 'Null')||' CODICE_VERSIONE, ';
 sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione,  ';
-- 1.2.2.0.5.3 - ITU_ECVerification -/- 1.2.2.0.5.4 - ITU_EIDemonstration
 sqlstringa := sqlstringa || ' Nvl(PO_SD_TUNNEL_1_2_2_0_5_3O4_AP,'''||GetNYA('1.2.2.0.5.3')||''') PO_SD_TUNNEL_1_2_2_0_5_3O4_AP, ';
 sqlstringa := sqlstringa || ' Nvl(PO_SD_TUNNEL_1_2_2_0_5_3O4, ''00/00000000000000/0000/000000'') PO_SD_TUNNEL_1_2_2_0_5_3O4, ';
 sqlstringa := sqlstringa || ' KM_INIZIO, ';
 sqlstringa := sqlstringa || ' KM_FINE ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
 sqlstringa := sqlstringa || ' From        ';
 sqlstringa := sqlstringa || ' (Select PO_SD_TUNNEL_1_2_2_0_5_2, PO_SD_TUNNEL_1_2_2_0_5_3O4_AP, PO_SD_TUNNEL_1_2_2_0_5_3O4, KM_INIZIO, KM_FINE ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
 sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_GALLERIE_SD_PO ';
 sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EC''';
 If p_versione Is Not Null Then
      sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
 End If;
 sqlstringa := sqlstringa || ') b,  ';
 sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_RACCORDO_PO s ';
 sqlstringa := sqlstringa || ' Where s.PO_SD_TUNNEL_1_2_2_0_5_2 = b.PO_SD_TUNNEL_1_2_2_0_5_2 (+) ';
 sqlstringa := sqlstringa || 'And s.PO_SD_TUNNEL_1_2_2_0_5_2 = '''||p_POSiding_Tunnel||''''  ;
 If p_versione Is Not Null Then
      sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
 End If;
 sqlstringa := sqlstringa || ' UNION ';
 sqlstringa := sqlstringa || ' Select DISTINCT s.PO_SD_TUNNEL_1_2_2_0_5_2 POSiding_Tunnel_ID, ';
 sqlstringa := sqlstringa ||  Nvl(To_Char( p_versione), 'Null')||' CODICE_VERSIONE, ';
 sqlstringa := sqlstringa || '''EI'' tipo_dichiarazione,                                      ';
 sqlstringa := sqlstringa || ' Nvl(PO_SD_TUNNEL_1_2_2_0_5_3O4_AP, '''||GetNYA('1.2.2.0.5.4')||''') PO_SD_TUNNEL_1_2_2_0_5_3O4_AP, ';
 sqlstringa := sqlstringa || ' Nvl(PO_SD_TUNNEL_1_2_2_0_5_3O4, ''00/00000000000000/0000/000000'') PO_SD_TUNNEL_1_2_2_0_5_3O4, ';
 sqlstringa := sqlstringa || ' KM_INIZIO, ';
 sqlstringa := sqlstringa || ' KM_FINE ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
 sqlstringa := sqlstringa || ' From  ';
 sqlstringa := sqlstringa || '(Select PO_SD_TUNNEL_1_2_2_0_5_2, PO_SD_TUNNEL_1_2_2_0_5_3O4_AP, PO_SD_TUNNEL_1_2_2_0_5_3O4, KM_INIZIO, KM_FINE  ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
 sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_GALLERIE_SD_PO ';
 sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EI''';
 If p_versione Is Not Null Then
      sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
 End If;
 sqlstringa := sqlstringa || ') b, ';
 sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_RACCORDO_PO s ';
 sqlstringa := sqlstringa || ' Where s.PO_SD_TUNNEL_1_2_2_0_5_2 = b.PO_SD_TUNNEL_1_2_2_0_5_2 (+)  ';
 sqlstringa := sqlstringa || ' And s.PO_SD_TUNNEL_1_2_2_0_5_2 = '''||p_POSiding_Tunnel||''''  ;
 If p_versione Is Not Null Then
      sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
 End If;
 sqlstringa := sqlstringa || ' Order By 3,6 ';
--
 Open p_cursor For sqlstringa;
--
END GetOPSiding_Inf_Tunnel_EC;

-- -----------------------------------------------------------------------------
--                         ----------- SOL -------------
--                               GetSOL_General
-- -----------------------------------------------------------------------------
 Procedure GetSOL_General (p_SOL Varchar2, P_AREA Number, P_I_VERSIONE Number, P_CURSOR Out EMPCUR) Is
-- Ritorna i dati principali della SOL
--
   S_SCHEMA   Varchar2(100);
--   sqlstringa Varchar2(10000);
   sqlstringa CLOB;
--
   P_VERSIONE Number;
--   
 BEGIN
   S_SCHEMA   := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
   P_VERSIONE := P_I_VERSIONE;
   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
       P_VERSIONE := GetLastVersion(P_AREA);
   End If;
--
   sqlstringa :=  'Select s.SEDE_TECNICA SOL_ID, ';
   sqlstringa := sqlstringa ||  Nvl(To_Char( p_versione),'Null')||' CODICE_VERSIONE,';
-- 1.1.0.0.0.1 - SOLIMCode
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.0.0.0.1'', SOL_1_1_0_0_0_1) SOL_1_1_0_0_0_1_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.0.0.0.1'', SOL_1_1_0_0_0_1) SOL_1_1_0_0_0_1_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.0.0.0.1'', SOL_1_1_0_0_0_1) SOL_1_1_0_0_0_1_DES, ';
   sqlstringa := sqlstringa || ' Nvl(SOL_1_1_0_0_0_1, ''0083'') SOL_1_1_0_0_0_1, ';
-- 1.1.0.0.0.2 - SOLLineIdentification
   sqlstringa := sqlstringa || ' Nvl(Trim(linea_comm.linea), ''0000'') SOL_1_1_0_0_0_2, ';
-- 1.1.0.0.0.3 - SOLOPStart
   sqlstringa := sqlstringa || ' SOL_1_1_0_0_0_3, ';
   sqlstringa := sqlstringa || ' p_i.DEFINIZIONE LOCALITA_INIZIO, ';
-- 1.1.0.0.0.4 - SOLOPEnd
   sqlstringa := sqlstringa || ' SOL_1_1_0_0_0_4, ';
   sqlstringa := sqlstringa || ' p_f.DEFINIZIONE LOCALITA_FINE, ';
-- 1.1.0.0.0.5 - SOLLength
   sqlstringa := sqlstringa || ' Trim(To_Char(ROUND(SOL_1_1_0_0_0_5,3),''999990.999'')) SOL_1_1_0_0_0_5, ';
-- 1.1.0.0.0.6 - SOLNature
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.0.0.0.6'',SOL_1_1_0_0_0_6) SOL_1_1_0_0_0_6_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.0.0.0.6'',SOL_1_1_0_0_0_6) SOL_1_1_0_0_0_6_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.0.0.0.6'',SOL_1_1_0_0_0_6) SOL_1_1_0_0_0_6_DES, ';
   sqlstringa := sqlstringa || ' SOL_1_1_0_0_0_6, ';
   sqlstringa := sqlstringa || ' s.KM_INIZIO KM_INIZIO, ';
   sqlstringa := sqlstringa || ' s.KM_FINE KM_FINE, ';
   sqlstringa := sqlstringa || ' s.CACHE_FIELD ';
   sqlstringa := sqlstringa || ' From '||s_schema||'.SEZIONI_LINEA s, ';
   sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI p_i, ';
   sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI p_f, ';
   If p_versione Is Not Null Then
        sqlstringa := sqlstringa || '(Select SEDE_TECNICA, Listagg(Replace(CODICE, '' '','''') ||'' '') Within Group (Order By CODICE) As linea ';
        sqlstringa := sqlstringa || ' From '||s_schema||'.V_MDR_LINEE_COMMERCIALI ';
        sqlstringa := sqlstringa || ' Where ';
        sqlstringa := sqlstringa || ' CODICE_VERSIONE = '||p_versione ;
        sqlstringa := sqlstringa || ' Group By SEDE_TECNICA) linea_comm ';
   Else
        sqlstringa := sqlstringa || '(Select SEDE_TECNICA, Listagg(Replace(CODICE, '' '','''') ||'' '') Within Group (Order By CODICE) As linea ';
        sqlstringa := sqlstringa || ' From '||s_schema||'.V_MDR_LINEE_COMMERCIALI ';
        sqlstringa := sqlstringa || ' Group By SEDE_TECNICA) linea_comm ';
   End If;
   sqlstringa := sqlstringa || 'Where s.LOCALITA_INIZIO = p_i.SEDE_TECNICA ';
   sqlstringa := sqlstringa || ' And s.LOCALITA_FINE = p_f.SEDE_TECNICA ';
   sqlstringa := sqlstringa || ' And s.SEDE_TECNICA = '''||p_SOL||''' ';
   sqlstringa := sqlstringa || ' And s.SEDE_TECNICA = linea_comm.SEDE_TECNICA (+)';
   If p_versione Is Not Null Then
        sqlstringa := sqlstringa || 'and s.CODICE_VERSIONE = '||p_versione;
        sqlstringa := sqlstringa || 'and p_i.CODICE_VERSIONE = '||p_versione;
        sqlstringa := sqlstringa || 'and p_f.CODICE_VERSIONE = '||p_versione;
   End If;

   Open p_cursor For sqlstringa;
--   Dbms_Output.Put_Line(sqlstringa);
--
 END GetSOL_General;
--
-- -----------------------------------------------------------------------------
--                    GetTracks_General con il campo  CLOB
-- -----------------------------------------------------------------------------
--
-- -----------------------------------------------------------------------------
--                         GetTracks_General 
-- 1.1.1 - RUNNINGTRACK
--  Ritorna i  Binari di Corsa di una SOL con relativi parametri
-- -----------------------------------------------------------------------------
 Procedure GetTracks_General (p_SOL Varchar2, p_AREA Number, p_i_VERSIONE Number, p_CURSOR Out Empcur) Is
--
   s_schema     Varchar2(100);
--   sqlstringa  Varchar2(32767);
   sqlstringa   CLOB;            
--
   Type empcur Is Ref Cursor;
--  
   p_versione  Number;
--->
   Data_Validita Date;
 BEGIN
   S_SCHEMA := PKG_RINF_INTERFACCIA.GetSchemaName(P_AREA);
   P_VERSIONE := P_I_VERSIONE;

   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
        P_VERSIONE := pkg_rinf_data_v777.GetLastVersion(P_AREA);
   End If;

-- ------------------------------------------------------------------------------------------------
-- gestione della data di inizio e fine validità per il parametro	 
-- ------------------------------------------------------------------------------------------------
--->
   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Not Null Then  
      Select GREATEST(DATA_PUBBLICAZIONE, DATA_RIFERIMENTO) 
  	    Into Data_Validita 
        From RINF_PUBBLICATI_EVO.VERSIONE_RINF
       Where CODICE_VERSIONE = P_VERSIONE;
   Else
       Select GREATEST(DATA_CONTROLLO, DATA_RIFERIMENTO) 
  	     Into Data_Validita 
         From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI
        Where CODICE_CONTROLLO =(Select Max (CODICE_CONTROLLO) From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI);
   End If;
-->
-->
sqlstringa :=  'Select s.SEDE_TECNICA SOL_ID, ';
sqlstringa := sqlstringa || Nvl(To_Char( p_versione),'Null')||' CODICE_VERSIONE, ';
--
-- 1.1.1.0.0.1 - SOLTrackIdentification - Identificazione del binario
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1, ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1_D SOL_TRACK_1_1_1_0_0_1_DES, ';
--
-- 1.1.1.0.0.2 - SOLTrackDirection - Direzione di marcia normale
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.0.0.2'',SOL_TRACK_1_1_1_0_0_2) SOL_TRACK_1_1_1_0_0_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.0.0.2'',SOL_TRACK_1_1_1_0_0_2) SOL_TRACK_1_1_1_0_0_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.0.0.2'',SOL_TRACK_1_1_1_0_0_2) SOL_TRACK_1_1_1_0_0_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_0_0_2_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_0_0_2, ';
-- 1.1.1.1                  Sottosistema «infrastruttura»
-- Parametri di prestazione
-- 1.1.1.1.2.1 - IPP_TENClass - Classificazione TEN (rete transeuropea) del binario
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_1_AP, ';
sqlstringa := sqlstringa || 'cat_ten.SOL_TRACK_1_1_1_1_2_1_XML, ';
sqlstringa := sqlstringa || 'cat_ten.SOL_TRACK_1_1_1_1_2_1_OV, ';
sqlstringa := sqlstringa || 'cat_ten.SOL_TRACK_1_1_1_1_2_1 SOL_TRACK_1_1_1_1_2_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_2_1_SET, ';
sqlstringa := sqlstringa || 'cat_ten.SOL_TRACK_1_1_1_1_2_1_DES SOL_TRACK_1_1_1_1_2_1, ';
--
-- 1.1.1.1.2.1.2 - IPP_TENGISID (Nuovo Parametro Reg.2019/777) ancora da inserire in Tabella! - Identità del sistema informativo geografico (GIS ID) TEN
-- sqlstringa := sqlstringa || ' SOL_TRACK_1_1_1_1_2_1_2_AP, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_1_2_AP, ';
 sqlstringa := sqlstringa || 'Null SOL_TRACK_1_1_1_1_2_1_2_XML, ';
 sqlstringa := sqlstringa || 'Null SOL_TRACK_1_1_1_1_2_1_2_OV, ';
 sqlstringa := sqlstringa || 'Null SOL_TRACK_1_1_1_1_2_1_2_DES, ';
 sqlstringa := sqlstringa || 'Null SOL_TRACK_1_1_1_1_2_1_2, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.2.1.2'') Flag_1_1_1_1_2_1_2_AT, '; --> Nuovo attributo (verificare nel Catalogo)
--
-- 1.1.1.1.2.2 - IPP_LineCat - Categoria della linea
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_2_AP, ';
sqlstringa := sqlstringa || 'cat_linea.SOL_TRACK_1_1_1_1_2_2_XML, ';
sqlstringa := sqlstringa || 'cat_linea.SOL_TRACK_1_1_1_1_2_2_OV, ';
sqlstringa := sqlstringa || 'cat_linea.SOL_TRACK_1_1_1_1_2_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_2_2_SET, ';
sqlstringa := sqlstringa || 'cat_linea.SOL_TRACK_1_1_1_1_2_2, ';
--
-- 1.1.1.1.2.3 - IPP_FreightCorridor - Parte di un corridoio ferroviario merci (RFC — Rail Freight Corridor)
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_3_AP , ';
sqlstringa := sqlstringa || 'corridoio.SOL_TRACK_1_1_1_1_2_3_XML, ';
sqlstringa := sqlstringa || 'corridoio.SOL_TRACK_1_1_1_1_2_3_OV, ';
sqlstringa := sqlstringa || 'corridoio.SOL_TRACK_1_1_1_1_2_3 SOL_TRACK_1_1_1_1_2_3_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_2_3_SET, ';
sqlstringa := sqlstringa || 'corridoio.SOL_TRACK_1_1_1_1_2_3_DES SOL_TRACK_1_1_1_1_2_3, ';
--
-- 1.1.1.1.2.4 - IPP_LoadCap - Capacità di carico
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_4_AP, ';
sqlstringa := sqlstringa || 'cap_carico.SOL_TRACK_1_1_1_1_2_4_XML, ';
sqlstringa := sqlstringa || 'cap_carico.SOL_TRACK_1_1_1_1_2_4_OV, ';
sqlstringa := sqlstringa || 'cap_carico.SOL_TRACK_1_1_1_1_2_4_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_2_4_SET, ';
sqlstringa := sqlstringa || 'cap_carico.SOL_TRACK_1_1_1_1_2_4, ';
--
-- 1.1.1.1.2.4.1 - IPP_NCLoadCap (Nuovo Parametro Reg.2019/777) - Classificazione nazionale della capacità di carico
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_4_1_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.2.4.1'', SOL_TRACK_1_1_1_1_2_4_1) SOL_TRACK_1_1_1_1_2_4_1_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.2.4.1'', SOL_TRACK_1_1_1_1_2_4_1) SOL_TRACK_1_1_1_1_2_4_1_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.2.4.1'', SOL_TRACK_1_1_1_1_2_4_1) SOL_TRACK_1_1_1_1_2_4_1_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_2_4_1_SET, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_4_1, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.2.4.1'') Flag_1_1_1_1_2_4_1_AT, '; --> Nuovo attributo
--

-- 1.1.1.1.2.4.2 - IPP_HSLMCompliant (Nuovo Parametro Reg.2019/777) - Conformità delle strutture al modello di carico ad alta velocità
 sqlstringa := sqlstringa || ' SOL_TRACK_1_1_1_1_2_4_2_AP,';
 sqlstringa := sqlstringa || ' RFI.getxmlvalue(''1.1.1.1.2.4.2'', SOL_TRACK_1_1_1_1_2_4_2) SOL_TRACK_1_1_1_1_2_4_2_XML, ';
 sqlstringa := sqlstringa || ' RFI.GetOpValue(''1.1.1.1.2.4.2'', SOL_TRACK_1_1_1_1_2_4_2) SOL_TRACK_1_1_1_1_2_4_2_OV, ';
 sqlstringa := sqlstringa || ' RFI.GetDescr(''1.1.1.1.2.4.2'', SOL_TRACK_1_1_1_1_2_4_2) SOL_TRACK_1_1_1_1_2_4_2_DES, ';
 sqlstringa := sqlstringa || ' null  SOL_TRACK_1_1_1_1_2_4_2_SET,';
 sqlstringa := sqlstringa || ' SOL_TRACK_1_1_1_1_2_4_2,';
 sqlstringa := sqlstringa || ' GetPar_attivo(''1.1.1.1.2.4.2'') Flag_1_1_1_1_2_4_2_AT, '; --> Nuovo attributo
--
-- 1.1.1.1.2.4.3 (Modificata) - IPP_StructureCheckLoc (Nuovo Parametro Reg.2019/777) - Localizzazione ferroviaria di strutture che richiedono verifiche specifiche
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_4_3_AP,';
 /*   
 sqlstringa := sqlstringa || 'Locaverspec.SOL_TRACK_1_1_1_1_2_4_3_XML, ';
 sqlstringa := sqlstringa || 'Locaverspec.SOL_TRACK_1_1_1_1_2_4_3_OV, ';
 sqlstringa := sqlstringa || 'Locaverspec.SOL_TRACK_1_1_1_1_2_4_3_DES, ';
 sqlstringa := sqlstringa || ' SOL_TRACK_1_1_1_1_2_4_3_SET,';
 sqlstringa := sqlstringa || 'Locaverspec.SOL_TRACK_1_1_1_1_2_4_3,';
*/
 sqlstringa := sqlstringa || 'Decode (Locaverspec.SOL_TRACK_1_1_1_1_2_4_3_XML, ''NA'', Null, Locaverspec.SOL_TRACK_1_1_1_1_2_4_3_XML) SOL_TRACK_1_1_1_1_2_4_3_XML, ';
 sqlstringa := sqlstringa || 'Locaverspec.SOL_TRACK_1_1_1_1_2_4_3_OV, ';
 sqlstringa := sqlstringa || 'Decode (Locaverspec.SOL_TRACK_1_1_1_1_2_4_3_DES, ''NA'', Null, Locaverspec.SOL_TRACK_1_1_1_1_2_4_3_DES) SOL_TRACK_1_1_1_1_2_4_3_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_2_4_3_SET,';
 sqlstringa := sqlstringa || 'Decode (Locaverspec.SOL_TRACK_1_1_1_1_2_4_3, ''9999.999'', Null, Locaverspec.SOL_TRACK_1_1_1_1_2_4_3) SOL_TRACK_1_1_1_1_2_4_3, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.2.4.3'') Flag_1_1_1_1_2_4_3_AT, '; --> Nuovo attributo
--
--
-- 1.1.1.1.2.4.4 - IPP_StructureCheckDocRef (Nuovo Parametro Reg.2019/777) - AP = Y Valore (Intera Rete) = [RFI DTC SI MA IFS 001 D-II-2.pdf] 
-- (Documento riportante la/le procedura/e per le verifiche di compatibilità statica e dinamica della tratta)
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_4_4_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.2.4.4'', SOL_TRACK_1_1_1_1_2_4_4) SOL_TRACK_1_1_1_1_2_4_4_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.2.4.4'', SOL_TRACK_1_1_1_1_2_4_4) SOL_TRACK_1_1_1_1_2_4_4_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.2.4.4'', SOL_TRACK_1_1_1_1_2_4_4) SOL_TRACK_1_1_1_1_2_4_4_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_2_4_4_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_4_4,';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.2.4.4'') Flag_1_1_1_1_2_4_4_AT, '; --> Nuovo attributo
--						  
-- 1.1.1.1.2.5 - IPP_MaxSpeed - Velocità massima consentita
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_5_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.2.5'',SOL_TRACK_1_1_1_1_2_5) SOL_TRACK_1_1_1_1_2_5_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.2.5'',SOL_TRACK_1_1_1_1_2_5) SOL_TRACK_1_1_1_1_2_5_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.2.5'',SOL_TRACK_1_1_1_1_2_5) SOL_TRACK_1_1_1_1_2_5_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_2_5_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_5, ';
--
-- 1.1.1.1.2.6 - IPP_TempRange - Campo di temperatura
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_6_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.2.6'',SOL_TRACK_1_1_1_1_2_6) SOL_TRACK_1_1_1_1_2_6_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.2.6'',SOL_TRACK_1_1_1_1_2_6) SOL_TRACK_1_1_1_1_2_6_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.2.6'',SOL_TRACK_1_1_1_1_2_6) SOL_TRACK_1_1_1_1_2_6_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_2_6_SET, SOL_TRACK_1_1_1_1_2_6, ';
--
-- 1.1.1.1.2.7 - IPP_MaxAltitude - Altitudine massima
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_7_AP, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_2_7_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_7, ';
--
-- 1.1.1.1.2.8 - IPP_SevereClimateCon (Parametro MODIFICATO dal Reg.2019/777) - Esistenza di condizioni climatiche estreme
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_8_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.2.8'',SOL_TRACK_1_1_1_1_2_8) SOL_TRACK_1_1_1_1_2_8_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.2.8'',SOL_TRACK_1_1_1_1_2_8) SOL_TRACK_1_1_1_1_2_8_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.2.8'',SOL_TRACK_1_1_1_1_2_8) SOL_TRACK_1_1_1_1_2_8_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_2_8_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_8, ';
-- Tracciato della linea
-- 1.1.1.1.3.1 - ILL_InteropGauge (parametro cancellato con il Reg.2019/777) - Sagoma interoperabile
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.3.1'',SOL_TRACK_1_1_1_1_3_1) SOL_TRACK_1_1_1_1_3_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.3.1'',SOL_TRACK_1_1_1_1_3_1) SOL_TRACK_1_1_1_1_3_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.3.1'',SOL_TRACK_1_1_1_1_3_1) SOL_TRACK_1_1_1_1_3_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_3_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_1, ';
--
-- 1.1.1.1.3.2 - ILL_MultiNatGauge (parametro cancellato con il Reg.2019/777) - Sagome multinazionali
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.3.2'',SOL_TRACK_1_1_1_1_3_2) SOL_TRACK_1_1_1_1_3_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.3.2'',SOL_TRACK_1_1_1_1_3_2) SOL_TRACK_1_1_1_1_3_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.3.2'',SOL_TRACK_1_1_1_1_3_2) SOL_TRACK_1_1_1_1_3_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_3_2_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_2, ';
--
-- 1.1.1.1.3.3 - ILL_NatGauge (parametro cancellato con il Reg.2019/777) - Sagome nazionali
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_3_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.3.3'',SOL_TRACK_1_1_1_1_3_3) SOL_TRACK_1_1_1_1_3_3_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.3.3'',SOL_TRACK_1_1_1_1_3_3) SOL_TRACK_1_1_1_1_3_3_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.3.3'',SOL_TRACK_1_1_1_1_3_3) SOL_TRACK_1_1_1_1_3_3_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_3_3_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_3,  ';
--
-- 1.1.1.1.3.1.1 - ILL_Gauging (Nuovo Parametro Reg.2019/777) - Sagoma
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_1_1_AP,';
 sqlstringa := sqlstringa || 'Decode(RFI.getxmlvalue(''1.1.1.1.3.1.1.SUP'', SOL_TRACK_1_1_1_1_3_1_1_SUP) || ''#'' || RFI.getxmlvalue(''1.1.1.1.3.1.1.INF'', SOL_TRACK_1_1_1_1_3_1_1_INF),  ''#'', Null,  RFI.getxmlvalue(''1.1.1.1.3.1.1.SUP'', SOL_TRACK_1_1_1_1_3_1_1_SUP)  || ''#'' || RFI.getxmlvalue(''1.1.1.1.3.1.1.INF'', SOL_TRACK_1_1_1_1_3_1_1_INF) ) SOL_TRACK_1_1_1_1_3_1_1_XML, ';
 sqlstringa := sqlstringa || 'Decode(RFI.GetOpValue(''1.1.1.1.3.1.1.SUP'', SOL_TRACK_1_1_1_1_3_1_1_SUP) || ''#'' || RFI.GetOpValue(''1.1.1.1.3.1.1.INF'', SOL_TRACK_1_1_1_1_3_1_1_INF), ''#'', Null,   RFI.GetOpValue(''1.1.1.1.3.1.1.SUP'', SOL_TRACK_1_1_1_1_3_1_1_SUP) || ''#'' || RFI.GetOpValue(''1.1.1.1.3.1.1.INF'', SOL_TRACK_1_1_1_1_3_1_1_INF) ) SOL_TRACK_1_1_1_1_3_1_1_OV, ';
 sqlstringa := sqlstringa || 'Decode(RFI.GetDescr(''1.1.1.1.3.1.1.SUP'', SOL_TRACK_1_1_1_1_3_1_1_SUP)|| ''#'' || RFI.GetDescr(''1.1.1.1.3.1.1.INF'', SOL_TRACK_1_1_1_1_3_1_1_INF), ''#'', Null,  RFI.GetDescr(''1.1.1.1.3.1.1.SUP'', SOL_TRACK_1_1_1_1_3_1_1_SUP)  || ''#'' || RFI.GetDescr(''1.1.1.1.3.1.1.INF'', SOL_TRACK_1_1_1_1_3_1_1_INF) ) SOL_TRACK_1_1_1_1_3_1_1_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_3_1_1_SET,';
 --sqlstringa := sqlstringa || 'Decode(SOL_TRACK_1_1_1_1_3_1_1_SUP || ''#'' || SOL_TRACK_1_1_1_1_3_1_1_INF, ''#'', Null,  SOL_TRACK_1_1_1_1_3_1_1_SUP || ''#'' || SOL_TRACK_1_1_1_1_3_1_1_INF) SOL_TRACK_1_1_1_1_3_1_1,';
   sqlstringa := sqlstringa || 'Decode(RFI.GetDescr(''1.1.1.1.3.1.1.SUP'', SOL_TRACK_1_1_1_1_3_1_1_SUP) || ''#'' || RFI.GetDescr(''1.1.1.1.3.1.1.INF'', SOL_TRACK_1_1_1_1_3_1_1_INF), ''#'', Null,  RFI.GetDescr(''1.1.1.1.3.1.1.SUP'', SOL_TRACK_1_1_1_1_3_1_1_SUP) || ''#'' || RFI.GetDescr(''1.1.1.1.3.1.1.INF'', SOL_TRACK_1_1_1_1_3_1_1_INF)) SOL_TRACK_1_1_1_1_3_1_1,';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.3.1.1.SUP'') Flag_1_1_1_1_3_1_1_AT, '; --> Nuovo attributo
-- 
-- 1.1.1.1.3.1.2 - ILL_GaugeCheckLoc (Nuovo Parametro Reg.2019/777) - AP(Intera Rete) = N - Valore = []
-- (Localizzazione ferroviaria di punti particolari che richiedono verifiche specifiche)
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_1_2_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.3.1.2'', SOL_TRACK_1_1_1_1_3_1_2) SOL_TRACK_1_1_1_1_3_1_2_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.3.1.2'', SOL_TRACK_1_1_1_1_3_1_2) SOL_TRACK_1_1_1_1_3_1_2_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.3.1.2'', SOL_TRACK_1_1_1_1_3_1_2) SOL_TRACK_1_1_1_1_3_1_2_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_3_1_2_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_1_2,';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.3.1.2'') Flag_1_1_1_1_3_1_2_AT, '; --> Nuovo attributo
--
-- 1.1.1.1.3.1.3 - ILL_GaugeCheckDocRef (Nuovo Parametro Reg.2019/777) - AP(Intera Rete) = N - Valore = []
-- Documento che riporta la sezione trasversale di punti particolari che richiedono verifiche specifiche
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_1_3_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.3.1.3'', SOL_TRACK_1_1_1_1_3_1_3) SOL_TRACK_1_1_1_1_3_1_3_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.3.1.3'', SOL_TRACK_1_1_1_1_3_1_3) SOL_TRACK_1_1_1_1_3_1_3_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.3.1.3'', SOL_TRACK_1_1_1_1_3_1_3) SOL_TRACK_1_1_1_1_3_1_3_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_3_1_3_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_1_3,';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.3.1.3'') Flag_1_1_1_1_3_1_3_AT, '; --> Nuovo attributo
--
-- 1.1.1.1.3.4 - ILL_ProfileNumSwapBodies - Numero standard del profilo di trasporto combinato per le casse mobili
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_4_AP, ';
sqlstringa := sqlstringa || 'prof_casse.SOL_TRACK_1_1_1_1_3_4_XML, ';
sqlstringa := sqlstringa || 'prof_casse.SOL_TRACK_1_1_1_1_3_4_OV, ';
sqlstringa := sqlstringa || 'prof_casse.SOL_TRACK_1_1_1_1_3_4_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_3_4_SET, ';
sqlstringa := sqlstringa || 'prof_casse.SOL_TRACK_1_1_1_1_3_4, ';
--
-- 1.1.1.1.3.5 - ILL_ProfileNumSemiTrailers - Numero standard del profilo di trasporto combinato per i semi rimorchi
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_5_AP, ';
sqlstringa := sqlstringa || 'prof_semir.SOL_TRACK_1_1_1_1_3_5_XML, ';
sqlstringa := sqlstringa || 'prof_semir.SOL_TRACK_1_1_1_1_3_5_OV, ';
sqlstringa := sqlstringa || 'prof_semir.SOL_TRACK_1_1_1_1_3_5_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_3_5_SET, ';
sqlstringa := sqlstringa || 'prof_semir.SOL_TRACK_1_1_1_1_3_5, ';
-- 
-- 1.1.1.1.3.5.1 - ILL_SpecificInfo (Nuovo Parametro Reg.2019/777) - Informazioni specifiche
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_5_1_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.3.5.1'', SOL_TRACK_1_1_1_1_3_5_1) SOL_TRACK_1_1_1_1_3_5_1_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.3.5.1'', SOL_TRACK_1_1_1_1_3_5_1) SOL_TRACK_1_1_1_1_3_5_1_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.3.5.1'', SOL_TRACK_1_1_1_1_3_5_1) SOL_TRACK_1_1_1_1_3_5_1_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_3_5_1_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_5_1,';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.3.5.1'') Flag_1_1_1_1_3_5_1_AT, '; --> Nuovo attributo
--
-- 1.1.1.1.3.6 - ILL_GradProfile - Profilo del gradiente
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_6_AP, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_3_6_SET, ';
sqlstringa := sqlstringa || 'p.gradiente SOL_TRACK_1_1_1_1_3_6, ';
-- 
-- 1.1.1.1.3.7 - ILL_MinRadHorzCurve - Raggio minimo di curvatura orizzontale
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_7_AP, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_3_7_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_7,  ';
-- Parametri del binario
-- 1.1.1.1.4.1 - ITP_NomGauge - Scartamento nominale
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.4.1'',SOL_TRACK_1_1_1_1_4_1) SOL_TRACK_1_1_1_1_4_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.4.1'',SOL_TRACK_1_1_1_1_4_1) SOL_TRACK_1_1_1_1_4_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.4.1'',SOL_TRACK_1_1_1_1_4_1) SOL_TRACK_1_1_1_1_4_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_4_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_1, ';
--
-- 1.1.1.1.4.2 - ITP_CantDeficiency - Insufficienza di sopraelevazione
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.4.2'',SOL_TRACK_1_1_1_1_4_2) SOL_TRACK_1_1_1_1_4_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.4.2'',SOL_TRACK_1_1_1_1_4_2) SOL_TRACK_1_1_1_1_4_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.4.2'',SOL_TRACK_1_1_1_1_4_2) SOL_TRACK_1_1_1_1_4_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_4_2_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_2, ';
--
-- 1.1.1.1.4.3 - ITP_RailInclination - Inclinazione della rotaia
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_3_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.4.3'',SOL_TRACK_1_1_1_1_4_3) SOL_TRACK_1_1_1_1_4_3_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.4.3'',SOL_TRACK_1_1_1_1_4_3) SOL_TRACK_1_1_1_1_4_3_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.4.3'',SOL_TRACK_1_1_1_1_4_3) SOL_TRACK_1_1_1_1_4_3_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_4_3_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_3, ';
--
-- 1.1.1.1.4.4 - ITP_Ballast - Esistenza di ballast
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_4_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.4.4'',SOL_TRACK_1_1_1_1_4_4) SOL_TRACK_1_1_1_1_4_4_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.4.4'',SOL_TRACK_1_1_1_1_4_4) SOL_TRACK_1_1_1_1_4_4_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.4.4'',SOL_TRACK_1_1_1_1_4_4) SOL_TRACK_1_1_1_1_4_4_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_4_4_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_4, ';
-- Dispositivi di armamento
-- 1.1.1.1.5.1 - ISC_TSISwitchCrossing - Rispetto da parte dei dispositivi di armamento dei valori di utilizzazione previsti dalla STI
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_5_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.5.1'',SOL_TRACK_1_1_1_1_5_1) SOL_TRACK_1_1_1_1_5_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.5.1'',SOL_TRACK_1_1_1_1_5_1) SOL_TRACK_1_1_1_1_5_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.5.1'',SOL_TRACK_1_1_1_1_5_1) SOL_TRACK_1_1_1_1_5_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_5_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_5_1, ';
--
-- 1.1.1.1.5.2 - ISC_MinWheelDiaFixObtuseCrossings - Diametro minimo delle ruote per il deviatoio fisso ad angolo ottuso
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_5_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.5.2'',SOL_TRACK_1_1_1_1_5_2) SOL_TRACK_1_1_1_1_5_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.5.2'',SOL_TRACK_1_1_1_1_5_2) SOL_TRACK_1_1_1_1_5_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.5.2'',SOL_TRACK_1_1_1_1_5_2) SOL_TRACK_1_1_1_1_5_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_5_2_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_5_2, ';
-- Resistenza del binario ai carichi applicati
-- 1.1.1.1.6.1 - ILR_MaxDeceleration - Decelerazione massima del treno
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.6.1'',SOL_TRACK_1_1_1_1_6_1) SOL_TRACK_1_1_1_1_6_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.6.1'',SOL_TRACK_1_1_1_1_6_1) SOL_TRACK_1_1_1_1_6_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.6.1'',SOL_TRACK_1_1_1_1_6_1) SOL_TRACK_1_1_1_1_6_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_6_1_SET, ';
sqlstringa := sqlstringa || 'Trim(SOL_TRACK_1_1_1_1_6_1) SOL_TRACK_1_1_1_1_6_1, ';
--sqlstringa := sqlstringa || 'Trim(To_Char(ROUND(SOL_TRACK_1_1_1_1_6_1,1),''999990.9'')) SOL_TRACK_1_1_1_1_6_1,      '; campo numerico in INE ma stringa nel db
-- 
-- 1.1.1.1.6.2 - ILR_EddyCurrentBrakes - Utilizzo di freni a correnti parassite
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.6.2'',SOL_TRACK_1_1_1_1_6_2) SOL_TRACK_1_1_1_1_6_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.6.2'',SOL_TRACK_1_1_1_1_6_2) SOL_TRACK_1_1_1_1_6_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.6.2'',SOL_TRACK_1_1_1_1_6_2) SOL_TRACK_1_1_1_1_6_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_6_2_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_2, ';
--
-- 1.1.1.1.6.3 - ILR_MagneticBrakes - Utilizzo di freni magnetici
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_3_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.6.3'',SOL_TRACK_1_1_1_1_6_3) SOL_TRACK_1_1_1_1_6_3_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.6.3'',SOL_TRACK_1_1_1_1_6_3) SOL_TRACK_1_1_1_1_6_3_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.6.3'',SOL_TRACK_1_1_1_1_6_3) SOL_TRACK_1_1_1_1_6_3_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_6_3_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_3, ';
--
-- 1.1.1.1.6.4 - ILR_ECBDocRef (Nuovo parametro Reg.2019/777) - AP (Intera Rete) = N - Valore = []
-- Documento riportante le condizioni per l'utilizzo di freni a correnti parassite
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_4_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.6.4'', SOL_TRACK_1_1_1_1_6_4) SOL_TRACK_1_1_1_1_6_4_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.6.4'', SOL_TRACK_1_1_1_1_6_4) SOL_TRACK_1_1_1_1_6_4_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.6.4'', SOL_TRACK_1_1_1_1_6_4) SOL_TRACK_1_1_1_1_6_4_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_6_4_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_4,';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.6.4'') Flag_1_1_1_1_6_4_AT, '; --> Nuovo attributo
--
-- 1.1.1.1.6.5 - IRL_MBDocRef - (Nuovo parametro Reg.2019/777)- AP (Intera Rete) = N - Valore = []
-- Documento riportante le condizioni per l'utilizzo di freni magnetici
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_5_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.6.5'', SOL_TRACK_1_1_1_1_6_5) SOL_TRACK_1_1_1_1_6_5_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.6.5'', SOL_TRACK_1_1_1_1_6_5) SOL_TRACK_1_1_1_1_6_5_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.6.5'', SOL_TRACK_1_1_1_1_6_5) SOL_TRACK_1_1_1_1_6_5_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_6_5_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_5,';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.6.5'') Flag_1_1_1_1_6_5_AT, '; --> Nuovo attributo
-- Salute, sicurezza e ambiente
-- 1.1.1.1.7.1 - IHS_FlangeLubeForbidden - Divieto di utilizzo della lubrificazione del bordino
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.7.1'',SOL_TRACK_1_1_1_1_7_1) SOL_TRACK_1_1_1_1_7_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.7.1'',SOL_TRACK_1_1_1_1_7_1) SOL_TRACK_1_1_1_1_7_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.7.1'',SOL_TRACK_1_1_1_1_7_1) SOL_TRACK_1_1_1_1_7_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_7_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_1, ';
-- 
-- 1.1.1.1.7.2 - IHS_LevelCrossing (Parametro MODIFICATO dal Reg.2019/777) - Esistenza di passaggi a livello
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.7.2'',SOL_TRACK_1_1_1_1_7_2) SOL_TRACK_1_1_1_1_7_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.7.2'',SOL_TRACK_1_1_1_1_7_2) SOL_TRACK_1_1_1_1_7_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.7.2'',SOL_TRACK_1_1_1_1_7_2) SOL_TRACK_1_1_1_1_7_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_7_2_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_2, ';
--
-- 1.1.1.1.7.3 - IHS_AccelerationL - Accelerazione consentita in prossimità dei passaggi a livello
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_3_AP, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_7_3_SET, ';
sqlstringa := sqlstringa || 'Trim(To_Char(ROUND(SOL_TRACK_1_1_1_1_7_3,1),''999990.9'')) SOL_TRACK_1_1_1_1_7_3, ';
--
-- 1.1.1.1.7.4 - IHS_HABDExist  (Nuovo Parametro Reg.2019/777) - Esistenza di un sistema di rilevamento di anomalo riscaldamento boccole (RTB) a terra
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_4_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.7.4'', SOL_TRACK_1_1_1_1_7_4) SOL_TRACK_1_1_1_1_7_4_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.7.4'', SOL_TRACK_1_1_1_1_7_4) SOL_TRACK_1_1_1_1_7_4_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.7.4'', SOL_TRACK_1_1_1_1_7_4) SOL_TRACK_1_1_1_1_7_4_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_7_4_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_4, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.7.4'') Flag_1_1_1_1_7_4_AT, '; --> Nuovo attributo
-- 
-- 1.1.1.1.7.5 - IHS_TSIHABD  (Nuovo Parametro Reg.2019/777) - Sistema RTB a terra conforme a STI
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_5_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.7.5'', SOL_TRACK_1_1_1_1_7_5) SOL_TRACK_1_1_1_1_7_5_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.7.5'', SOL_TRACK_1_1_1_1_7_5) SOL_TRACK_1_1_1_1_7_5_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.7.5'', SOL_TRACK_1_1_1_1_7_5) SOL_TRACK_1_1_1_1_7_5_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_7_5_SET, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_5, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.7.5'') Flag_1_1_1_1_7_5_AT, '; --> Nuovo attributo
--
-- 1.1.1.1.7.6 - IHS_HABDID  (Nuovo Parametro Reg.2019/777) - Individuazione di sistema RTB a terra
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_6_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.7.6'', SOL_TRACK_1_1_1_1_7_6) SOL_TRACK_1_1_1_1_7_6_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.7.6'', SOL_TRACK_1_1_1_1_7_6) SOL_TRACK_1_1_1_1_7_6_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.7.6'', SOL_TRACK_1_1_1_1_7_6) SOL_TRACK_1_1_1_1_7_6_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_7_6_SET, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_6, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.7.6'') Flag_1_1_1_1_7_6_AT, '; --> Nuovo attributo
-- 
-- 1.1.1.1.7.7 - IHS_HABDGen  (Nuovo Parametro Reg.2019/777) - Generazione di sistema RTB a terra
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_7_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.7.7'', SOL_TRACK_1_1_1_1_7_7) SOL_TRACK_1_1_1_1_7_7_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.7.7'', SOL_TRACK_1_1_1_1_7_7) SOL_TRACK_1_1_1_1_7_7_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.7.7'', SOL_TRACK_1_1_1_1_7_7) SOL_TRACK_1_1_1_1_7_7_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_7_7_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_7, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.7.7'') Flag_1_1_1_1_7_7_AT, '; --> Nuovo attributo
-- 
-- 1.1.1.1.7.8 - IHS_HABDLoc  (Nuovo Parametro Reg.2019/777) - Localizzazione ferroviaria di sistema RTB a terra
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_8_AP,';
 sqlstringa := sqlstringa || 'Loca_Sist_Rtb.sol_track_1_1_1_1_7_8_XML, ';
 sqlstringa := sqlstringa || 'Loca_Sist_Rtb.sol_track_1_1_1_1_7_8_OV, ';
 sqlstringa := sqlstringa || 'Loca_Sist_Rtb.sol_track_1_1_1_1_7_8_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_7_8_SET, ';
 sqlstringa := sqlstringa || 'Loca_Sist_Rtb.sol_track_1_1_1_1_7_8, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.7.8'') Flag_1_1_1_1_7_8_AT, '; --> Nuovo attributo
-- 
-- 1.1.1.1.7.9 - IHS_HABDDirecton  (Nuovo Parametro Reg.2019/777) - Direzione della misurazione di sistema RTB a terra
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_9_AP, ';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.7.9'', SOL_TRACK_1_1_1_1_7_9) SOL_TRACK_1_1_1_1_7_9_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.7.9'', SOL_TRACK_1_1_1_1_7_9) SOL_TRACK_1_1_1_1_7_9_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.7.9'', SOL_TRACK_1_1_1_1_7_9) SOL_TRACK_1_1_1_1_7_9_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_7_9_SET, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_9, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.7.9'') Flag_1_1_1_1_7_9_AT, '; --> Nuovo attributo
--
-- 1.1.1.1.7.10 - IHS_RedLights  (Nuovo parametro Reg.2019/777) - Richieste luci rosse fisse
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_10_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.7.10'', SOL_TRACK_1_1_1_1_7_10) SOL_TRACK_1_1_1_1_7_10_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.7.10'', SOL_TRACK_1_1_1_1_7_10) SOL_TRACK_1_1_1_1_7_10_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.7.10'', SOL_TRACK_1_1_1_1_7_10) SOL_TRACK_1_1_1_1_7_10_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_7_10_SET, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_10, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.7.10'') Flag_1_1_1_1_7_10_AT, '; --> Nuovo attributo
--
-- 1.1.1.1.7.11 - IHS_QuietRoute (Nuovo parametro Reg.2019/777) - Appartenente a una tratta meno rumorosa
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_11_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.1.7.11'', SOL_TRACK_1_1_1_1_7_11) SOL_TRACK_1_1_1_1_7_11_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.1.7.11'', SOL_TRACK_1_1_1_1_7_11) SOL_TRACK_1_1_1_1_7_11_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.1.7.11'', SOL_TRACK_1_1_1_1_7_11) SOL_TRACK_1_1_1_1_7_11_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_1_7_11_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_11, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.1.7.11'') Flag_1_1_1_1_7_11_AT, '; --> Nuovo attributo
-- 1.1.1.2	Energy system - Sottosistema «energia»
-- 1.1.1.2.2.1.1 - ECS_SystemType - Tipo di sistema di linea di contatto
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_1_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1) SOL_TRACK_1_1_1_2_2_1_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1) SOL_TRACK_1_1_1_2_2_1_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1) SOL_TRACK_1_1_1_2_2_1_1_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.2.2.1.1'', SOL_TRACK_1_1_1_2_2_1_1, SOL_TRACK_1_1_1_2_2_1_1_AP), ''*'') SOL_TRACK_1_1_1_2_2_1_1_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1) SOL_TRACK_1_1_1_2_2_1_1, ';
--
-- 1.1.1.2.2.1.2 - ECS_VoltFreq - Sistema di alimentazione elettrica (tensione e frequenza)
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_1_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.2.1.2'', SOL_TRACK_1_1_1_2_2_1_2) SOL_TRACK_1_1_1_2_2_1_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.2.1.2'', SOL_TRACK_1_1_1_2_2_1_2) SOL_TRACK_1_1_1_2_2_1_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.2.1.2'', SOL_TRACK_1_1_1_2_2_1_2) SOL_TRACK_1_1_1_2_2_1_2_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.2.2.1.1'', SOL_TRACK_1_1_1_2_2_1_1, SOL_TRACK_1_1_1_2_2_1_1_AP), ''*'')  SOL_TRACK_1_1_1_2_2_1_2_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.2.1.2'', SOL_TRACK_1_1_1_2_2_1_2) SOL_TRACK_1_1_1_2_2_1_2, ';
--
-- 1.1.1.2.2.1.2.1 - ECS_TSIVoltFreq / Energy supply system TSI compliant (Nuovo Parametro ERA aggiunto al Reg.2019/777)
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_1_2_1_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.2.1.2.1'', SOL_TRACK_1_1_1_2_2_1_2_1) SOL_TRACK_1_1_1_2_2_1_2_1_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.2.1.2.1'', SOL_TRACK_1_1_1_2_2_1_2_1) SOL_TRACK_1_1_1_2_2_1_2_1_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.2.1.2.1'', SOL_TRACK_1_1_1_2_2_1_2_1) SOL_TRACK_1_1_1_2_2_1_2_1_DES, ';
 sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.2.2.1.1'', SOL_TRACK_1_1_1_2_2_1_1, SOL_TRACK_1_1_1_2_2_1_1_AP), ''*'')  SOL_TRACK_1_1_1_2_2_1_2_1_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_1_2_1,';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.2.2.1.2.1'') Flag_1_1_1_2_2_1_2_1_AT, '; --> Nuovo attributo
--
-- 1.1.1.2.2.1.3 - ECS_Umax2 (Nuovo Parametro Reg.2019/777) - AP (Intera Rete) = N - Valore = []
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_1_3_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.2.1.3'', SOL_TRACK_1_1_1_2_2_1_3) SOL_TRACK_1_1_1_2_2_1_3_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.2.1.3'', SOL_TRACK_1_1_1_2_2_1_3) SOL_TRACK_1_1_1_2_2_1_3_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.2.1.2.1'', SOL_TRACK_1_1_1_2_2_1_2_1) SOL_TRACK_1_1_1_2_2_1_3_DES, ';
 sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.2.2.1.1'', SOL_TRACK_1_1_1_2_2_1_1, SOL_TRACK_1_1_1_2_2_1_1_AP), ''*'')  SOL_TRACK_1_1_1_2_2_1_3_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_1_3, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.2.2.1.3'') Flag_1_1_1_2_2_1_3_AT, '; --> Nuovo attributo
--
-- 1.1.1.2.2.2 - ECS_MaxTrainCurrent (Parametro MODIFICATO dal Reg.2019/777) - Corrente massima del treno
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_2_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.2.2.1.1'', SOL_TRACK_1_1_1_2_2_1_1, SOL_TRACK_1_1_1_2_2_1_1_AP), ''*'')  SOL_TRACK_1_1_1_2_2_2_SET,  ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_2, ';
--
-- 1.1.1.2.2.3 - ECS_MaxStandstillCurrent - Corrente massima a treno fermo per pantografo
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_3_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.2.2.1.1'', SOL_TRACK_1_1_1_2_2_1_1, SOL_TRACK_1_1_1_2_2_1_1_AP), ''*'')  SOL_TRACK_1_1_1_2_2_3_SET, '; --SET reale maggio 2015
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_3, ';
--
-- 1.1.1.2.2.4 - ECS_RegenerativeBraking - Autorizzazione della frenatura a recupero
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_4_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.2.4'',SOL_TRACK_1_1_1_2_2_4) SOL_TRACK_1_1_1_2_2_4_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.2.4'',SOL_TRACK_1_1_1_2_2_4) SOL_TRACK_1_1_1_2_2_4_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.2.4'',SOL_TRACK_1_1_1_2_2_4) SOL_TRACK_1_1_1_2_2_4_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.2.2.1.1'', SOL_TRACK_1_1_1_2_2_1_1, SOL_TRACK_1_1_1_2_2_1_1_AP), ''*'')  SOL_TRACK_1_1_1_2_2_4_SET, '; --Set reale maggio 2015
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_4, ';
--
-- 1.1.1.2.2.5 - ECS_MaxWireHeight - Altezza massima del filo di contatto
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_5_AP, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_2_5_SET, ';
sqlstringa := sqlstringa || 'Trim(To_Char(ROUND(SOL_TRACK_1_1_1_2_2_5, 2),''999990.99'')) SOL_TRACK_1_1_1_2_2_5, ';
--
-- 1.1.1.2.2.6 - ECS_MinWireHeight - Altezza minima del filo di contatto
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_6_AP, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_2_6_SET, ';
sqlstringa := sqlstringa || 'Trim(To_Char(ROUND(SOL_TRACK_1_1_1_2_2_6, 2),''999990.99'')) SOL_TRACK_1_1_1_2_2_6, ';
-- 1.1.1.2.3 EPA / Pantograph - Pantografo
-- 1.1.1.2.3.1 - EPA_TSIHeads (Parametro MODIFICATO dal Reg.2019/777) - Archetti del pantografo accettati conformi alla STI
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.3.1'',SOL_TRACK_1_1_1_2_3_1) SOL_TRACK_1_1_1_2_3_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.3.1'',SOL_TRACK_1_1_1_2_3_1) SOL_TRACK_1_1_1_2_3_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.3.1'',SOL_TRACK_1_1_1_2_3_1) SOL_TRACK_1_1_1_2_3_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_3_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_1, ';
-- 
-- 1.1.1.2.3.2 - EPA_OtherHeads - Altri archetti del pantografo accettati
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.3.2'',SOL_TRACK_1_1_1_2_3_2) SOL_TRACK_1_1_1_2_3_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.3.2'',SOL_TRACK_1_1_1_2_3_2) SOL_TRACK_1_1_1_2_3_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.3.2'',SOL_TRACK_1_1_1_2_3_2) SOL_TRACK_1_1_1_2_3_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_3_2_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_2, ';
--
-- 1.1.1.2.3.3 - EPA_NumRaisedSpeed - Requisiti in materia di numero di pantografi alzati e distanza tra loro, a una data velocità
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_3_AP, ';
sqlstringa := sqlstringa || 'DECODE(RFI.getxmlvalue(''1.1.1.2.3.3.A'',SOL_TRACK_1_1_1_2_3_3_A)||'' ''|| RFI.getxmlvalue(''1.1.1.2.3.3.B'',SOL_TRACK_1_1_1_2_3_3_B)||'' ''||RFI.getxmlvalue(''1.1.1.2.3.3.C'',SOL_TRACK_1_1_1_2_3_3_C),''++'',Null,RFI.getxmlvalue(''1.1.1.2.3.3.A'',SOL_TRACK_1_1_1_2_3_3_A)||'' ''|| RFI.getxmlvalue(''1.1.1.2.3.3.B'',SOL_TRACK_1_1_1_2_3_3_B)||'' ''||RFI.getxmlvalue(''1.1.1.2.3.3.C'',SOL_TRACK_1_1_1_2_3_3_C)) SOL_TRACK_1_1_1_2_3_3_XML, ';
sqlstringa := sqlstringa || 'DECODE(RFI.GetOpValue(''1.1.1.2.3.3.A'',SOL_TRACK_1_1_1_2_3_3_A)||'' ''|| RFI.GetOpValue(''1.1.1.2.3.3.B'',SOL_TRACK_1_1_1_2_3_3_B)||'' ''||RFI.GetOpValue(''1.1.1.2.3.3.C'',SOL_TRACK_1_1_1_2_3_3_C),''++'',Null,RFI.GetOpValue(''1.1.1.2.3.3.A'',SOL_TRACK_1_1_1_2_3_3_A)||'' ''|| RFI.GetOpValue(''1.1.1.2.3.3.B'',SOL_TRACK_1_1_1_2_3_3_B)||'' ''||RFI.GetOpValue(''1.1.1.2.3.3.C'',SOL_TRACK_1_1_1_2_3_3_C)) SOL_TRACK_1_1_1_2_3_3_OV, ';
sqlstringa := sqlstringa || 'DECODE(RFI.GetDescr(''1.1.1.2.3.3.A'',SOL_TRACK_1_1_1_2_3_3_A)||'' ''|| RFI.GetDescr(''1.1.1.2.3.3.B'',SOL_TRACK_1_1_1_2_3_3_B)||'' ''||RFI.GetDescr(''1.1.1.2.3.3.C'',SOL_TRACK_1_1_1_2_3_3_C),''++'',Null,RFI.GetDescr(''1.1.1.2.3.3.A'',SOL_TRACK_1_1_1_2_3_3_A)||'' ''|| RFI.GetDescr(''1.1.1.2.3.3.B'',SOL_TRACK_1_1_1_2_3_3_B)||'' ''||RFI.GetDescr(''1.1.1.2.3.3.C'',SOL_TRACK_1_1_1_2_3_3_C)) SOL_TRACK_1_1_1_2_3_3_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_3_3_SET, ';
sqlstringa := sqlstringa || 'DECODE(SOL_TRACK_1_1_1_2_3_3_A||'' ''||SOL_TRACK_1_1_1_2_3_3_B||'' ''||SOL_TRACK_1_1_1_2_3_3_C,''++'',Null,SOL_TRACK_1_1_1_2_3_3_A||'' ''||SOL_TRACK_1_1_1_2_3_3_B||'' ''||SOL_TRACK_1_1_1_2_3_3_C) SOL_TRACK_1_1_1_2_3_3, ';
--
-- 1.1.1.2.3.4 - EPA_StripMaterial - Materiali degli striscianti autorizzati
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_4_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.3.4'',SOL_TRACK_1_1_1_2_3_4) SOL_TRACK_1_1_1_2_3_4_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.3.4'',SOL_TRACK_1_1_1_2_3_4) SOL_TRACK_1_1_1_2_3_4_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.3.4'',SOL_TRACK_1_1_1_2_3_4) SOL_TRACK_1_1_1_2_3_4_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_3_4_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_4, ';
-- 1.1.1.2.4	EOS / OCL separation sections - Tratti a separazione della catenaria
-- 1.1.1.2.4.1.1 - EOS_Phase - Separazione di fase
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_1_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.4.1.1'',SOL_TRACK_1_1_1_2_4_1_1) SOL_TRACK_1_1_1_2_4_1_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.4.1.1'',SOL_TRACK_1_1_1_2_4_1_1) SOL_TRACK_1_1_1_2_4_1_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.4.1.1'',SOL_TRACK_1_1_1_2_4_1_1) SOL_TRACK_1_1_1_2_4_1_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_4_1_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_1_1, ';
--
-- 1.1.1.2.4.1.2 - EOS_InfoPhase - Informazioni sulla separazione di fase
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_1_2_AP, ';
sqlstringa := sqlstringa || 'DECODE(SOL_TRACK_1_1_1_2_4_1_2_A||''+''|| RFI.getxmlvalue(''1.1.1.2.4.1.2.B'',SOL_TRACK_1_1_1_2_4_1_2_B)||''+''||RFI.getxmlvalue(''1.1.1.2.4.1.2.C'',SOL_TRACK_1_1_1_2_4_1_2_C),''++'',Null,''length ''||SOL_TRACK_1_1_1_2_4_1_2_A||'' + switch off breaker ''|| RFI.getxmlvalue(''1.1.1.2.4.1.2.B'',SOL_TRACK_1_1_1_2_4_1_2_B)||'' + lower pantograph ''||RFI.getxmlvalue(''1.1.1.2.4.1.2.C'',SOL_TRACK_1_1_1_2_4_1_2_C)) SOL_TRACK_1_1_1_2_4_1_2_XML, ';
sqlstringa := sqlstringa || 'Null SOL_TRACK_1_1_1_2_4_1_2_OV, ';
sqlstringa := sqlstringa || 'DECODE(RFI.GetDescr(''1.1.1.2.4.1.2.A'',SOL_TRACK_1_1_1_2_4_1_2_A)||''+''|| RFI.GetDescr(''1.1.1.2.4.1.2.B'',SOL_TRACK_1_1_1_2_4_1_2_B)||''+''||RFI.GetDescr(''1.1.1.2.4.1.2.C'',SOL_TRACK_1_1_1_2_4_1_2_C),''++'',Null,''length ''||RFI.GetDescr(''1.1.1.2.4.1.2.A'',SOL_TRACK_1_1_1_2_4_1_2_A)||'' + switch off breaker ''|| RFI.GetDescr(''1.1.1.2.4.1.2.B'',SOL_TRACK_1_1_1_2_4_1_2_B)||'' + lower pantograph ''||RFI.GetDescr(''1.1.1.2.4.1.2.C'',SOL_TRACK_1_1_1_2_4_1_2_C)) SOL_TRACK_1_1_1_2_4_1_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_4_1_2_SET, ';
sqlstringa := sqlstringa || 'DECODE(SOL_TRACK_1_1_1_2_4_1_2_A||''+''||SOL_TRACK_1_1_1_2_4_1_2_B||''+''||SOL_TRACK_1_1_1_2_4_1_2_C,''++'',Null,''length ''||SOL_TRACK_1_1_1_2_4_1_2_A||'' + switch off breaker ''||SOL_TRACK_1_1_1_2_4_1_2_B||'' + lower pantograph ''||SOL_TRACK_1_1_1_2_4_1_2_C) SOL_TRACK_1_1_1_2_4_1_2,  ';
--
-- 1.1.1.2.4.2.1 - EOS_System - Separazione di sistema
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_2_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.4.2.1'',SOL_TRACK_1_1_1_2_4_2_1) SOL_TRACK_1_1_1_2_4_2_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.4.2.1'',SOL_TRACK_1_1_1_2_4_2_1) SOL_TRACK_1_1_1_2_4_2_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.4.2.1'',SOL_TRACK_1_1_1_2_4_2_1) SOL_TRACK_1_1_1_2_4_2_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_4_2_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_2_1, ';
--
-- 1.1.1.2.4.2.2 - EOS_InfoSystem - Informazioni sulla separazione di sistema
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_2_2_AP, ';
-- sqlstringa := sqlstringa || 'DECODE(RFI.getxmlvalue(''1.1.1.2.4.2.2.A'', SOL_TRACK_1_1_1_2_4_2_2_A)||''+''||RFI.getxmlvalue(''1.1.1.2.4.2.2.B'', SOL_TRACK_1_1_1_2_4_2_2_b)||''+''||RFI.getxmlvalue(''1.1.1.2.4.2.2.C'', SOL_TRACK_1_1_1_2_4_2_2_C)||''+''||RFI.getxmlvalue(''1.1.1.2.4.2.2.D'',SOL_TRACK_1_1_1_2_4_2_2_D), ''+++'', Null, ''length ''||RFI.getxmlvalue(''1.1.1.2.4.2.2.A'',SOL_TRACK_1_1_1_2_4_2_2_A)||'' + switch off breaker ''||RFI.getxmlvalue(''1.1.1.2.4.2.2.B'',SOL_TRACK_1_1_1_2_4_2_2_b)||'' + lower pantograph ''||RFI.getxmlvalue(''1.1.1.2.4.2.2.C'',SOL_TRACK_1_1_1_2_4_2_2_C)||'' + change supply system ''||RFI.getxmlvalue(''1.1.1.2.4.2.2.D'',SOL_TRACK_1_1_1_2_4_2_2_D)) SOL_TRACK_1_1_1_2_4_2_2_XML, ';
sqlstringa := sqlstringa || 'DECODE(RFI.getxmlvalue(''1.1.1.2.4.2.2.A'', SOL_TRACK_1_1_1_2_4_2_2_A)||''+''||RFI.getxmlvalue(''1.1.1.2.4.2.2.B'', SOL_TRACK_1_1_1_2_4_2_2_b)||''+''||RFI.getxmlvalue(''1.1.1.2.4.2.2.C'', SOL_TRACK_1_1_1_2_4_2_2_C),''++'', Null, ''length ''||RFI.getxmlvalue(''1.1.1.2.4.2.2.A'', SOL_TRACK_1_1_1_2_4_2_2_A)||'' + switch off breaker ''||RFI.getxmlvalue(''1.1.1.2.4.2.2.B'', SOL_TRACK_1_1_1_2_4_2_2_b)||'' + lower pantograph ''||RFI.getxmlvalue(''1.1.1.2.4.2.2.C'', SOL_TRACK_1_1_1_2_4_2_2_C)) SOL_TRACK_1_1_1_2_4_2_2_XML, ';
--
-- sqlstringa := sqlstringa || 'DECODE(RFI.GetOpValue(''1.1.1.2.4.2.2.A'',SOL_TRACK_1_1_1_2_4_2_2_A)||''+''||RFI.GetOpValue(''1.1.1.2.4.2.2.B'',SOL_TRACK_1_1_1_2_4_2_2_b)||''+''||RFI.GetOpValue(''1.1.1.2.4.2.2.C'',SOL_TRACK_1_1_1_2_4_2_2_C)||''+''||RFI.GetOpValue(''1.1.1.2.4.2.2.D'',SOL_TRACK_1_1_1_2_4_2_2_D),''+++'',Null, ''length ''||RFI.GetOpValue(''1.1.1.2.4.2.2.A'',SOL_TRACK_1_1_1_2_4_2_2_A)||'' + switch off breaker ''||RFI.GetOpValue(''1.1.1.2.4.2.2.B'',SOL_TRACK_1_1_1_2_4_2_2_b)||'' + lower pantograph ''||RFI.GetOpValue(''1.1.1.2.4.2.2.C'',SOL_TRACK_1_1_1_2_4_2_2_C)||'' + change supply system ''||RFI.GetOpValue(''1.1.1.2.4.2.2.D'',SOL_TRACK_1_1_1_2_4_2_2_D))SOL_TRACK_1_1_1_2_4_2_2_OV, ';
-- sqlstringa := sqlstringa || 'DECODE(RFI.GetOpValue(''1.1.1.2.4.2.2.A'', SOL_TRACK_1_1_1_2_4_2_2_A)||''+''||RFI.GetOpValue(''1.1.1.2.4.2.2.B'', SOL_TRACK_1_1_1_2_4_2_2_b)||''+''||RFI.GetOpValue(''1.1.1.2.4.2.2.C'', SOL_TRACK_1_1_1_2_4_2_2_C), ''++'', Null, ''length ''||RFI.GetOpValue(''1.1.1.2.4.2.2.A'', SOL_TRACK_1_1_1_2_4_2_2_A)||'' + switch off breaker ''||RFI.GetOpValue(''1.1.1.2.4.2.2.B'', SOL_TRACK_1_1_1_2_4_2_2_b)||'' + lower pantograph ''||RFI.GetOpValue(''1.1.1.2.4.2.2.C'', SOL_TRACK_1_1_1_2_4_2_2_C)) SOL_TRACK_1_1_1_2_4_2_2_OV, ';
sqlstringa := sqlstringa || ' Null SOL_TRACK_1_1_1_2_4_2_2_OV, ';
--
--sqlstringa := sqlstringa || 'DECODE(RFI.GetDescr(''1.1.1.2.4.2.2.A'',SOL_TRACK_1_1_1_2_4_2_2_A)||''+''||RFI.GetDescr(''1.1.1.2.4.2.2.B'',SOL_TRACK_1_1_1_2_4_2_2_b)||''+''||RFI.GetDescr(''1.1.1.2.4.2.2.C'',SOL_TRACK_1_1_1_2_4_2_2_C)||''+''||RFI.GetDescr(''1.1.1.2.4.2.2.D'',SOL_TRACK_1_1_1_2_4_2_2_D), ''+++'', Null, ''length ''||RFI.GetDescr(''1.1.1.2.4.2.2.A'',SOL_TRACK_1_1_1_2_4_2_2_A)||'' + switch off breaker ''||RFI.GetDescr(''1.1.1.2.4.2.2.B'',SOL_TRACK_1_1_1_2_4_2_2_b)||'' + lower pantograph ''||RFI.GetDescr(''1.1.1.2.4.2.2.C'',SOL_TRACK_1_1_1_2_4_2_2_C)||'' + change supply system ''||RFI.GetDescr(''1.1.1.2.4.2.2.D'',SOL_TRACK_1_1_1_2_4_2_2_D)) SOL_TRACK_1_1_1_2_4_2_2_DES, ';
sqlstringa := sqlstringa || 'DECODE(RFI.GetDescr(''1.1.1.2.4.2.2.A'', SOL_TRACK_1_1_1_2_4_2_2_A)||''+''||RFI.GetDescr(''1.1.1.2.4.2.2.B'', SOL_TRACK_1_1_1_2_4_2_2_b)||''+''||RFI.GetDescr(''1.1.1.2.4.2.2.C'', SOL_TRACK_1_1_1_2_4_2_2_C), ''++'', Null, ''length ''||RFI.GetDescr(''1.1.1.2.4.2.2.A'', SOL_TRACK_1_1_1_2_4_2_2_A)||'' + switch off breaker ''||RFI.GetDescr(''1.1.1.2.4.2.2.B'', SOL_TRACK_1_1_1_2_4_2_2_b)||'' + lower pantograph ''||RFI.GetDescr(''1.1.1.2.4.2.2.C'', SOL_TRACK_1_1_1_2_4_2_2_C)) SOL_TRACK_1_1_1_2_4_2_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_4_2_2_SET, ';
sqlstringa := sqlstringa || 'DECODE(SOL_TRACK_1_1_1_2_4_2_2_A||''+''||SOL_TRACK_1_1_1_2_4_2_2_B||''+''||SOL_TRACK_1_1_1_2_4_2_2_C||''+''||SOL_TRACK_1_1_1_2_4_2_2_D, ''+++'', Null, ''length ''||SOL_TRACK_1_1_1_2_4_2_2_A||'' + switch off breaker ''||SOL_TRACK_1_1_1_2_4_2_2_B||'' + lower pantograph ''||SOL_TRACK_1_1_1_2_4_2_2_C||'' + change supply system ''||SOL_TRACK_1_1_1_2_4_2_2_D) SOL_TRACK_1_1_1_2_4_2_2, ';
---
-- 1.1.1.2.4.3 - EOS_DistSignToPhaseEnd  (Nuovo Parametro Reg.2019/777) - AP (Intera Rete) = N - Valore = []
-- Distanza tra il pannello e la fine della separazione di fase
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_3_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.4.3'', SOL_TRACK_1_1_1_2_4_3) SOL_TRACK_1_1_1_2_4_3_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.4.3'', SOL_TRACK_1_1_1_2_4_3) SOL_TRACK_1_1_1_2_4_3_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.4.3'', SOL_TRACK_1_1_1_2_4_3) SOL_TRACK_1_1_1_2_4_3_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_4_3_SET, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_3, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.2.4.3'') Flag_1_1_1_2_4_3_AT, '; --> Nuovo attributo
-- 1.1.1.2.5 ERS / Requirements for rolling stock - Requisiti per il materiale rotabile
-- 1.1.1.2.5.1 - ERS_PowerLimitOnBoard - Limitazione di corrente o di potenza a bordo richiesta
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_5_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.5.1'',SOL_TRACK_1_1_1_2_5_1) SOL_TRACK_1_1_1_2_5_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.5.1'',SOL_TRACK_1_1_1_2_5_1) SOL_TRACK_1_1_1_2_5_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.5.1'',SOL_TRACK_1_1_1_2_5_1) SOL_TRACK_1_1_1_2_5_1_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.2.2.1.1'', SOL_TRACK_1_1_1_2_2_1_1, SOL_TRACK_1_1_1_2_2_1_1_AP), ''*'')  SOL_TRACK_1_1_1_2_5_1_SET, '; --SET reale maggio 2015
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_5_1, ';
-- 
-- 1.1.1.2.5.2 - ERS_ContactForce - Forza di contatto autorizzata
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_5_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.5.2'',SOL_TRACK_1_1_1_2_5_2) SOL_TRACK_1_1_1_2_5_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.5.2'',SOL_TRACK_1_1_1_2_5_2) SOL_TRACK_1_1_1_2_5_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.5.2'',SOL_TRACK_1_1_1_2_5_2) SOL_TRACK_1_1_1_2_5_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_5_2_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_5_2, ';
--
-- 1.1.1.2.5.3 - ERS_AutoDropRequired (Parametro MODIFICATO dal Reg.2019/777) - - Dispositivo di abbassamento automatico richiesto
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_5_3_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.2.5.3'',SOL_TRACK_1_1_1_2_5_3) SOL_TRACK_1_1_1_2_5_3_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.2.5.3'',SOL_TRACK_1_1_1_2_5_3) SOL_TRACK_1_1_1_2_5_3_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.2.5.3'',SOL_TRACK_1_1_1_2_5_3) SOL_TRACK_1_1_1_2_5_3_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_2_5_3_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_5_3, ';
-- 1.1.1.3	Control-command and signalling subsystem - Sottosistema «controllo-comando e segnalamento»
-- 1.1.1.3.2.1 - CPE_Level - Livello del sistema europeo di controllo dei treni (ETCS)
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.2.1'', SOL_TRACK_1_1_1_3_2_1) SOL_TRACK_1_1_1_3_2_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.2.1'', SOL_TRACK_1_1_1_3_2_1) SOL_TRACK_1_1_1_3_2_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.2.1'', SOL_TRACK_1_1_1_3_2_1) SOL_TRACK_1_1_1_3_2_1_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.2.1'', SOL_TRACK_1_1_1_3_2_1, SOL_TRACK_1_1_1_3_2_1_AP), ''*'') SOL_TRACK_1_1_1_3_2_1_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_1, ';
--
-- 1.1.1.3.2.2 - CPE_Baseline (Parametro MODIFICATO dal Reg.2019/777) - Baseline dell'ETCS
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.2.2'', SOL_TRACK_1_1_1_3_2_2) SOL_TRACK_1_1_1_3_2_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.2.2'', SOL_TRACK_1_1_1_3_2_2) SOL_TRACK_1_1_1_3_2_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.2.2'', SOL_TRACK_1_1_1_3_2_2) SOL_TRACK_1_1_1_3_2_2_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.2.1'', SOL_TRACK_1_1_1_3_2_1, SOL_TRACK_1_1_1_3_2_1_AP), ''*'' ) SOL_TRACK_1_1_1_3_2_2_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_2, ';
--
-- 1.1.1.3.2.3 - CPE_Infill (Parametro MODIFICATO dal Reg.2019/777) - Funzione infill dell'ETCS necessaria per accedere alla linea
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_3_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.2.3'',SOL_TRACK_1_1_1_3_2_3) SOL_TRACK_1_1_1_3_2_3_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.2.3'',SOL_TRACK_1_1_1_3_2_3) SOL_TRACK_1_1_1_3_2_3_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.2.3'',SOL_TRACK_1_1_1_3_2_3) SOL_TRACK_1_1_1_3_2_3_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_2_3_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_3, ';
--
-- 1.1.1.3.2.4 - CPE_InfillLineSide - Funzione infill dell'ETCS installata a terra
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_4_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.2.4'',SOL_TRACK_1_1_1_3_2_4) SOL_TRACK_1_1_1_3_2_4_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.2.4'',SOL_TRACK_1_1_1_3_2_4) SOL_TRACK_1_1_1_3_2_4_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.2.4'',SOL_TRACK_1_1_1_3_2_4) SOL_TRACK_1_1_1_3_2_4_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_2_4_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_4,  ';
--
-- 1.1.1.3.2.5 - CPE_NatApplication - Implementazione del pacchetto 44 dell'applicazione nazionale dell'ETCS
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_5_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.2.5'',SOL_TRACK_1_1_1_3_2_5) SOL_TRACK_1_1_1_3_2_5_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.2.5'',SOL_TRACK_1_1_1_3_2_5) SOL_TRACK_1_1_1_3_2_5_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.2.5'',SOL_TRACK_1_1_1_3_2_5) SOL_TRACK_1_1_1_3_2_5_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_2_5_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_5, ';
--
-- 1.1.1.3.2.6 - CPE_RestrictionsConditions - Esistenza di restrizioni o condizioni operative
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_6_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.2.6'',SOL_TRACK_1_1_1_3_2_6) SOL_TRACK_1_1_1_3_2_6_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.2.6'',SOL_TRACK_1_1_1_3_2_6) SOL_TRACK_1_1_1_3_2_6_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.2.6'',SOL_TRACK_1_1_1_3_2_6) SOL_TRACK_1_1_1_3_2_6_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_2_6_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_6,  ';
--
-- 1.1.1.3.2.7 - CPE_OptionalFunctions (Parametro cancellato col Reg.2019/777) - Funzioni facoltative dell'ETCS
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_7_AP, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_2_7_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_7,  ';
--
-- 1.1.1.3.2.8 - CPE_IntegrityConfirmation  (Nuovo Parametro Reg.2019/777) - Conferma dell'integrità del treno a bordo necessaria per accedere alla linea
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_8_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.2.8'', SOL_TRACK_1_1_1_3_2_8) SOL_TRACK_1_1_1_3_2_8_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.2.8'', SOL_TRACK_1_1_1_3_2_8) SOL_TRACK_1_1_1_3_2_8_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.2.8'', SOL_TRACK_1_1_1_3_2_8) SOL_TRACK_1_1_1_3_2_8_DES, ';
-- sqlstringa := sqlstringa || ' RFI.GetSet(''1.1.1.3.2.1'', sol_track_1_1_1_3_2_1, sol_track_1_1_1_3_2_1_ap) SOL_TRACK_1_1_1_3_2_8_SET,';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_2_8_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_8, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.2.8'') Flag_1_1_1_3_2_8_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.2.9 - CPE_SystemCompatiblity (Nuovo Parametro Reg.2019/777) - Compatibilità con il sistema ETCS
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_9_AP,';
 sqlstringa := sqlstringa || 'Comp_Etcs.SOL_TRACK_1_1_1_3_2_9_XML, ';
 sqlstringa := sqlstringa || 'Comp_Etcs.SOL_TRACK_1_1_1_3_2_9_OV, ';
 sqlstringa := sqlstringa || 'Comp_Etcs.SOL_TRACK_1_1_1_3_2_9_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_2_9_SET,';
 sqlstringa := sqlstringa || 'Comp_Etcs.SOL_TRACK_1_1_1_3_2_9, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.2.9'') Flag_1_1_1_3_2_9_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.2.10  - CPE_MVersion  (Nuovo Parametro Reg.2019/777) - ETCS M_version
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_10_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.2.10'', SOL_TRACK_1_1_1_3_2_10) SOL_TRACK_1_1_1_3_2_10_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.2.10'', SOL_TRACK_1_1_1_3_2_10) SOL_TRACK_1_1_1_3_2_10_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.2.10'', SOL_TRACK_1_1_1_3_2_10) SOL_TRACK_1_1_1_3_2_10_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_2_10_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_10, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.2.10'') Flag_1_1_1_3_2_10_AT, '; --> Nuovo attributo
-- 1.1.1.3.3	 	CRG / TSI compliant radio (GSM-R) - Radio (GSM-R) conforme alla STI
-- 1.1.1.3.3.1 - CRG_Version (Parametro MODIFICATO dal Reg.2019/777) - Versione GSM-R Scelta unica
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_1_AP, ';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.3.1'',SOL_TRACK_1_1_1_3_3_1) SOL_TRACK_1_1_1_3_3_1_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.3.1'',SOL_TRACK_1_1_1_3_3_1) SOL_TRACK_1_1_1_3_3_1_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.3.1'',SOL_TRACK_1_1_1_3_3_1) SOL_TRACK_1_1_1_3_3_1_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_1_SET, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_1,  ';
--
-- 1.1.1.3.3.2 - CRG_NumActiveMob Numero di dispositivi mobili GSM-R attivi (EDOR) o di sessioni di comunicazione 
-- simultanea a bordo per ETCS livello 2 o livello 3 necessario per il trasferimento di RBC (centro di blocco radio) senza interruzioni operative
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_2_AP, ';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.3.2'',SOL_TRACK_1_1_1_3_3_2) SOL_TRACK_1_1_1_3_3_2_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.3.2'',SOL_TRACK_1_1_1_3_3_2) SOL_TRACK_1_1_1_3_3_2_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.3.2'',SOL_TRACK_1_1_1_3_3_2) SOL_TRACK_1_1_1_3_3_2_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_2_SET, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_2, ';
--
-- 1.1.1.3.3.3 - CRG_OptionalFunctions (Parametro MODIFICATO dal Reg.2019/777) - Funzioni GSM-R facoltative
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_3_AP, ';
 sqlstringa := sqlstringa || 'gsm.SOL_TRACK_1_1_1_3_3_3_XML, ';
 sqlstringa := sqlstringa || 'gsm.SOL_TRACK_1_1_1_3_3_3_OV, ';
 sqlstringa := sqlstringa || 'gsm.SOL_TRACK_1_1_1_3_3_3 SOL_TRACK_1_1_1_3_3_3_DES, ';            -->??
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_3_SET, ';
 sqlstringa := sqlstringa || 'gsm.SOL_TRACK_1_1_1_3_3_3_DES SOL_TRACK_1_1_1_3_3_3, ';            -->??
-- sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.3.3'') Flag_1_1_1_3_3_3_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.3.3.1 - CRG_AdditionalnetworkInfo (Nuovo Parametro Reg.2029/777) - AP = Y - Valore (Intera Rete) = [Filtri banda UIC x legacy EDOR]
-- Informazioni supplementari sulle caratteristiche di rete
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_3_1_AP, ';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.3.3.1'',SOL_TRACK_1_1_1_3_3_3_1) SOL_TRACK_1_1_1_3_3_3_1_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.3.3.1'',SOL_TRACK_1_1_1_3_3_3_1) SOL_TRACK_1_1_1_3_3_3_1_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.3.3.1'',SOL_TRACK_1_1_1_3_3_3_1) SOL_TRACK_1_1_1_3_3_3_1_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_3_1_SET, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_3_1, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.3.3.1'') Flag_1_1_1_3_3_3_1_AT, '; --> Nuovo attributo
-- 
-- 1.1.1.3.3.3.2 - CRG_GPRSForETCS (Nuovo parametro Reg.2019/777) - GPRS per ETCS
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_3_2_AP, ';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.3.3.2'',SOL_TRACK_1_1_1_3_3_3_2) SOL_TRACK_1_1_1_3_3_3_2_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.3.3.2'',SOL_TRACK_1_1_1_3_3_3_2) SOL_TRACK_1_1_1_3_3_3_2_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.3.3.2'',SOL_TRACK_1_1_1_3_3_3_2) SOL_TRACK_1_1_1_3_3_3_2_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_3_2_SET, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_3_2, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.3.3.2'') Flag_1_1_1_3_3_3_2_AT, '; --> Nuovo attributo
---
-- 1.1.1.3.3.3.3 - CRG_GPRSAreaOfImpl (Nuovo Parametro Reg.2029/777) - AP (Intera Rete) = N - Valore = []
-- Zona di implementazione del GPRS
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_3_3_AP, ';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.3.3.3'',SOL_TRACK_1_1_1_3_3_3_3) SOL_TRACK_1_1_1_3_3_3_3_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.3.3.3'',SOL_TRACK_1_1_1_3_3_3_3) SOL_TRACK_1_1_1_3_3_3_3_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.3.3.3'',SOL_TRACK_1_1_1_3_3_3_3) SOL_TRACK_1_1_1_3_3_3_3_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_3_3_SET, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_3_3, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.3.3.3'') Flag_1_1_1_3_3_3_3_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.3.4 - CRG_Needof555  (Nuovo parametro Reg.2019/777)
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_4_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.3.4'', SOL_TRACK_1_1_1_3_3_4) SOL_TRACK_1_1_1_3_3_4_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.3.4'', SOL_TRACK_1_1_1_3_3_4) SOL_TRACK_1_1_1_3_3_4_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.3.4'', SOL_TRACK_1_1_1_3_3_4) SOL_TRACK_1_1_1_3_3_4_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_4_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_4, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.3.4'') Flag_1_1_1_3_3_4_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.3.5 - CRG_RoamingAgreement (Nuovo parametro Reg.2019/777) - Utilizzo del gruppo 555
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_5_AP,';
 sqlstringa := sqlstringa || 'Reti_Gsm_R.SOL_TRACK_1_1_1_3_3_5_XML, ';
 sqlstringa := sqlstringa || 'Reti_Gsm_R.SOL_TRACK_1_1_1_3_3_5_OV, ';
 sqlstringa := sqlstringa || 'Reti_Gsm_R.SOL_TRACK_1_1_1_3_3_5_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_5_SET,';
 sqlstringa := sqlstringa || 'Reti_Gsm_R.SOL_TRACK_1_1_1_3_3_5, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.3.5'') Flag_1_1_1_3_3_5_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.3.6 - CRG_RoamingPublic (Nuovo parametro Reg.2019/777) - Presenza di Roaming su reti pubbliche - Se AP=Y Valore (Intera Rete) =[S]
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_6_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.3.6'', SOL_TRACK_1_1_1_3_3_6) SOL_TRACK_1_1_1_3_3_6_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.3.6'', SOL_TRACK_1_1_1_3_3_6) SOL_TRACK_1_1_1_3_3_6_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.3.6'', SOL_TRACK_1_1_1_3_3_6) SOL_TRACK_1_1_1_3_3_6_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_6_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_6, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.3.6'') Flag_1_1_1_3_3_6_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.3.7 - CRG_RoamingPublicDetails (Nuovo parametro Reg.2019/777) - Dettagli relativi al roaming su reti pubbliche
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_7_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.3.7'', SOL_TRACK_1_1_1_3_3_7) SOL_TRACK_1_1_1_3_3_7_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.3.7'', SOL_TRACK_1_1_1_3_3_7) SOL_TRACK_1_1_1_3_3_7_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.3.7'', SOL_TRACK_1_1_1_3_3_7) SOL_TRACK_1_1_1_3_3_7_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_7_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_7, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.3.7'') Flag_1_1_1_3_3_7_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.3.8 - CRG_GSMRNoCoverage (Nuovo parametro Reg.2019/777) - Assenza di copertura GSMR
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_8_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.3.8'', SOL_TRACK_1_1_1_3_3_8) SOL_TRACK_1_1_1_3_3_8_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.3.8'', SOL_TRACK_1_1_1_3_3_8) SOL_TRACK_1_1_1_3_3_8_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.3.8'', SOL_TRACK_1_1_1_3_3_8) SOL_TRACK_1_1_1_3_3_8_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_8_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_8, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.3.8'') Flag_1_1_1_3_3_8_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.3.9 - CRG_RadioCompVoice (Nuovo parametro Reg.2019/777) Compatibilità del sistema radio - voce
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_9_AP,';
 sqlstringa := sqlstringa || 'Radio_Voce.SOL_TRACK_1_1_1_3_3_9_XML, ';
 sqlstringa := sqlstringa || 'Radio_Voce.SOL_TRACK_1_1_1_3_3_9_OV, ';
 sqlstringa := sqlstringa || 'Radio_Voce.SOL_TRACK_1_1_1_3_3_9_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_9_SET,';
 sqlstringa := sqlstringa || 'Radio_Voce.SOL_TRACK_1_1_1_3_3_9, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.3.9'') Flag_1_1_1_3_3_9_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.3.10 - CRG_RadioCompData (Nuovo parametro Reg.2019/777) - Compatibilità del sistema radio - dati
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_10_AP,';
 sqlstringa := sqlstringa || 'Radio_Dati.SOL_TRACK_1_1_1_3_3_10_XML, ';
 sqlstringa := sqlstringa || 'Radio_Dati.SOL_TRACK_1_1_1_3_3_10_OV, ';
 sqlstringa := sqlstringa || 'Radio_Dati.SOL_TRACK_1_1_1_3_3_10_DES, ';
  sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_3_10_SET,';
 sqlstringa := sqlstringa || 'Radio_Dati.SOL_TRACK_1_1_1_3_3_10, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.3.10'') Flag_1_1_1_3_3_10_AT, '; --> Nuovo attributo
-- 1.1.1.3.4 CCD / Train detection systems fully compliant with the TSI - Sistemi di rilevamento del treno pienamente conformi alla STI
-- 1.1.1.3.4.1 - CCD_TSITrainDetection - Esistenza di un sistema di rilevamento del treno pienamente conforme alla STI
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_4_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.4.1'',SOL_TRACK_1_1_1_3_4_1) SOL_TRACK_1_1_1_3_4_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.4.1'',SOL_TRACK_1_1_1_3_4_1) SOL_TRACK_1_1_1_3_4_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.4.1'',SOL_TRACK_1_1_1_3_4_1) SOL_TRACK_1_1_1_3_4_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_4_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_4_1, ';
-- 1.1.1.3.5	 CPO / Train protection legacy systems - Sistemi preesistenti di protezione del treno
-- 1.1.1.3.5.1 - CPO_Installed (Parametro cancellato col Reg.2019/777) - Esistenza di altri sistemi installati di protezione, controllo e allerta della marcia del treno Sistema di protezione del treno
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_5_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.5.1'',SOL_TRACK_1_1_1_3_5_1) SOL_TRACK_1_1_1_3_5_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.5.1'',SOL_TRACK_1_1_1_3_5_1) SOL_TRACK_1_1_1_3_5_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.5.1'',SOL_TRACK_1_1_1_3_5_1) SOL_TRACK_1_1_1_3_5_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_5_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_5_1, ';
--
-- 1.1.1.3.5.2 - CPO_MultipleRequired (Parametro cancellato col Reg.2019/777) - Necessità di disporre a bordo di più sistemi di protezione, controllo e allerta della marcia del treno
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_5_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.5.2'',SOL_TRACK_1_1_1_3_5_2) SOL_TRACK_1_1_1_3_5_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.5.2'',SOL_TRACK_1_1_1_3_5_2) SOL_TRACK_1_1_1_3_5_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.5.2'',SOL_TRACK_1_1_1_3_5_2) SOL_TRACK_1_1_1_3_5_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_5_2_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_5_2, ';
--
-- 1.1.1.3.5.3 - CPO_LegacyTrainProtection (Nuovo parametro Reg.2019/777) - Sistema preesistente di protezione del treno
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_5_3_AP,';
 sqlstringa := sqlstringa || 'Sist_Pre_Prot.SOL_TRACK_1_1_1_3_5_3_XML, ';
 sqlstringa := sqlstringa || 'Sist_Pre_Prot.SOL_TRACK_1_1_1_3_5_3_OV, ';
 sqlstringa := sqlstringa || 'Sist_Pre_Prot.SOL_TRACK_1_1_1_3_5_3_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_5_3_SET,';
 sqlstringa := sqlstringa || 'Sist_Pre_Prot.SOL_TRACK_1_1_1_3_5_3_DES SOL_TRACK_1_1_1_3_5_3, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.5.3'') Flag_1_1_1_3_5_3_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.6	 CRS / Other radio systems ¬- Sistemi radio preesistenti
-- 1.1.1.3.6.1 - CRS_Installed (Parametro MODIFICATO dal Reg.2019/777) - AP = Y - VAlore (Intera rete) = [GSM-P] (valore “16” della Look Up value)
-- Altri sistemi radio installati (sistemi radio preesistenti)
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_6_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.6.1'',SOL_TRACK_1_1_1_3_6_1) SOL_TRACK_1_1_1_3_6_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.6.1'',SOL_TRACK_1_1_1_3_6_1) SOL_TRACK_1_1_1_3_6_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.6.1'',SOL_TRACK_1_1_1_3_6_1) SOL_TRACK_1_1_1_3_6_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_6_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_6_1, ';
--
-- 1.1.1.3.7 CTD / Train detection systems not fully compliant with the TSI - Sistemi di rilevamento del treno non pienamente conformi alla STI
-- 1.1.1.3.7.1 - CTD_DetectionSystem (Parametro cancellato, sostituito dal 1.1.1.3.7.1.1 col Reg.2019/777)
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1) SOL_TRACK_1_1_1_3_7_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1) SOL_TRACK_1_1_1_3_7_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1) SOL_TRACK_1_1_1_3_7_1_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1'', SOL_TRACK_1_1_1_3_7_1, SOL_TRACK_1_1_1_3_7_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_1_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_1, ';
--
-- 1.1.1.3.7.1.1 - CTD_DetectionSystem (Nuovo Parametro Reg.2019/777) Sostituisce il 1.1.1.3.7.1 - Tipo di sistema di rilevamento del treno
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_1_1_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1) SOL_TRACK_1_1_1_3_7_1_1_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1) SOL_TRACK_1_1_1_3_7_1_1_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1) SOL_TRACK_1_1_1_3_7_1_1_DES, ';
 sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_1_1_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_1_1, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.7.1.1'') Flag_1_1_1_3_7_1_1_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.7.1.2 - CTD_TCCheck (Nuovo parametro Reg.2019/777) - Tipo di circuiti di binario o contatori assi per i quali sono richieste verifiche specifiche
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_1_2_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.1.2'', SOL_TRACK_1_1_1_3_7_1_2) SOL_TRACK_1_1_1_3_7_1_2_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.1.2'', SOL_TRACK_1_1_1_3_7_1_2) SOL_TRACK_1_1_1_3_7_1_2_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.1.2'', SOL_TRACK_1_1_1_3_7_1_2) SOL_TRACK_1_1_1_3_7_1_2_DES, ';
 sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_1_2_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_1_2, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.7.1.2'') Flag_1_1_1_3_7_1_2_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.7.1.3 - CTD_TCCheckDocRef (Nuovo parametro Reg.2019/777) - Documento riportante la/le procedura/e relativa/e ai tipi di sistema di rilevamento del treno di cui al punto 1.1.1.3.7.1.2
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_1_3_AP,';
 sqlstringa := sqlstringa || 'Sis_Ril_Doc.SOL_TRACK_1_1_1_3_7_1_3_XML, ';
 sqlstringa := sqlstringa || 'Sis_Ril_Doc.SOL_TRACK_1_1_1_3_7_1_3_OV, ';
 sqlstringa := sqlstringa || 'Sis_Ril_Doc.SOL_TRACK_1_1_1_3_7_1_3_DES, ';
 sqlstringa := sqlstringa ||' Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_1_3_SET,';
-- sqlstringa := sqlstringa ||' Null SOL_TRACK_1_1_1_3_7_1_3_SET,';
 sqlstringa := sqlstringa || 'Sis_Ril_Doc.SOL_TRACK_1_1_1_3_7_1_3, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.7.1.3'') Flag_1_1_1_3_7_1_3_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.7.1.4 - CTD_TCLimitation (Nuovo Parametro Reg.2019/777) - AP (Intera rete) = N - Valore = []
-- Sezione con limitazione di rilevamento del treno
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_1_4_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.1.4'', SOL_TRACK_1_1_1_3_7_1_4) SOL_TRACK_1_1_1_3_7_1_4_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.1.4'', SOL_TRACK_1_1_1_3_7_1_4) SOL_TRACK_1_1_1_3_7_1_4_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.1.4'', SOL_TRACK_1_1_1_3_7_1_4) SOL_TRACK_1_1_1_3_7_1_4_DES, ';
 sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_1_4_SET, ';
-- sqlstringa := sqlstringa || ' Null SOL_TRACK_1_1_1_3_7_1_4_SET, ';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_1_4, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.7.1.4'') Flag_1_1_1_3_7_1_4_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.7.2.1 - CTD_TSIMaxDistConsecutiveAxles - Conformità alla STI della distanza massima consentita tra due assi consecutivi
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_2_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.2.1'',SOL_TRACK_1_1_1_3_7_2_1) SOL_TRACK_1_1_1_3_7_2_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.2.1'',SOL_TRACK_1_1_1_3_7_2_1) SOL_TRACK_1_1_1_3_7_2_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.2.1'',SOL_TRACK_1_1_1_3_7_2_1) SOL_TRACK_1_1_1_3_7_2_1_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_2_1_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_2_1, ';
--
-- 1.1.1.3.7.2.2 - CTD_MaxDistConsecutiveAxles - Distanza massima consentita tra due assi consecutivi in caso di non conformità alla STI
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_2_2_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_2_2_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_2_2, ';
--
-- 1.1.1.3.7.3 - CTD_MinDistConsecutiveAxles - Distanza minima consentita tra due assi consecutivi
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_3_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_3_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_3, ';
--
-- 1.1.1.3.7.4 - CTD_MinDistFirstLastAxles - Distanza minima consentita tra il primo e l'ultimo asse
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_4_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_4_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_4, ';
--
-- 1.1.1.3.7.5 - CTD_MaxDistEndTrainFirstAxle (Parametro MODIFICATO dal Reg.2019/777) - Distanza massima tra la fine del treno e il primo asse
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_5_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_5_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_5, ';
--
-- 1.1.1.3.7.6 - CTD_MinRimWidth - Larghezza minima consentita della corona
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_6_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_6_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_6, ';
--
-- 1.1.1.3.7.7 - CTD_MinWheelDiameter (Parametro MODIFICATO dal Reg.2019/777) - Diametro minimo consentito della ruota
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_7_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_7_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_7, ';
--
-- 1.1.1.3.7.8 - CTD_MinFlangeThickness - Spessore minimo consentito del bordino
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_8_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_8_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'Trim(To_Char(ROUND(SOL_TRACK_1_1_1_3_7_8,1),''999990.9''))SOL_TRACK_1_1_1_3_7_8, ';
--
-- 1.1.1.3.7.9 - CTD_MinFlangeHeight - Altezza minima consentita del bordino
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_9_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_9_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'Trim(To_Char(ROUND(SOL_TRACK_1_1_1_3_7_9,1),''999990.9''))SOL_TRACK_1_1_1_3_7_9,  ';
--
-- 1.1.1.3.7.10 - CTD_MaxFlangeHeight - Altezza massima consentita del bordino
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_10_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_10_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'Trim(To_Char(ROUND(SOL_TRACK_1_1_1_3_7_10,1),''999990.9'')) SOL_TRACK_1_1_1_3_7_10, ';
--
-- 1.1.1.3.7.11 - CTD_MinAxleLoad (Parametro cancellato col Reg.2019/777) - Carico minimo consentito per asse 
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_11_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.11'',SOL_TRACK_1_1_1_3_7_11) SOL_TRACK_1_1_1_3_7_11_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.11'',SOL_TRACK_1_1_1_3_7_11) SOL_TRACK_1_1_1_3_7_11_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.11'',SOL_TRACK_1_1_1_3_7_11) SOL_TRACK_1_1_1_3_7_11_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_11_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'Trim(To_Char(ROUND(SOL_TRACK_1_1_1_3_7_11,1),''999990.9'')) SOL_TRACK_1_1_1_3_7_11, ';
--
-- 1.1.1.3.7.11.1 - CTD_MinAxleLoadByVehicleCat (Nuovo parametro Reg.2019/777) se AP=Y valore = [5.0] - Carico minimo consentito per asse per categoria di veicoli
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_11_1_AP, ';
 --sqlstringa := sqlstringa || 'CarMin_Asse.SOL_TRACK_1_1_1_3_7_11_1_XML, ';
----> modifica per richiesta di M. Schillaci per adeguamento alla sintassi ERA-CUI
-- sqlstringa := sqlstringa || 'Trim(To_Char(RFI.getxmlvalue(''1.1.1.3.7.11'', SOL_TRACK_1_1_1_3_7_11),''9.9'')) ||'' ''|| CarMin_Asse.SOL_TRACK_1_1_1_3_7_11_1_XML SOL_TRACK_1_1_1_3_7_11_1_XML, ';
 sqlstringa := sqlstringa || 'Nvl(Trim(To_Char(RFI.getxmlvalue(''1.1.1.3.7.11'', SOL_TRACK_1_1_1_3_7_11),''9.9'')), ''5.0'' )||'' ''|| CarMin_Asse.SOL_TRACK_1_1_1_3_7_11_1_XML SOL_TRACK_1_1_1_3_7_11_1_XML, ';
----> 
 sqlstringa := sqlstringa || 'CarMin_Asse.SOL_TRACK_1_1_1_3_7_11_1_OV, ';
 sqlstringa := sqlstringa || 'CarMin_Asse.SOL_TRACK_1_1_1_3_7_11_1_DES, ';
 sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_11_1_SET, ';  --SET REALE
----> sqlstringa := sqlstringa || 'Trim(To_Char(ROUND(CarMin_Asse.SOL_TRACK_1_1_1_3_7_11_1,1),''90.9'')) SOL_TRACK_1_1_1_3_7_11_1, ';
 sqlstringa := sqlstringa || 'Trim(CarMin_Asse.SOL_TRACK_1_1_1_3_7_11_1) SOL_TRACK_1_1_1_3_7_11_1, ';
 sqlstringa := sqlstringa || ' GetPar_attivo(''1.1.1.3.7.11.1'') Flag_1_1_1_3_7_11_1_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.7.12 - CTD_TSIMetalFree - Conformità alla STI delle norme relative a uno spazio privo di metallo attorno alle ruote
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_12_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.12'',SOL_TRACK_1_1_1_3_7_12) SOL_TRACK_1_1_1_3_7_12_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.12'',SOL_TRACK_1_1_1_3_7_12) SOL_TRACK_1_1_1_3_7_12_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.12'',SOL_TRACK_1_1_1_3_7_12) SOL_TRACK_1_1_1_3_7_12_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_12_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_12, ';
--
-- 1.1.1.3.7.13 - CTD_TSIMetalConstruction - Conformità alla STI delle norme sulla costruzione metallica del veicolo
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_13_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.13'',SOL_TRACK_1_1_1_3_7_13) SOL_TRACK_1_1_1_3_7_13_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.13'',SOL_TRACK_1_1_1_3_7_13) SOL_TRACK_1_1_1_3_7_13_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.13'',SOL_TRACK_1_1_1_3_7_13) SOL_TRACK_1_1_1_3_7_13_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_13_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_13, ';
--
-- 1.1.1.3.7.14 - CTD_TSIFerroWheelMat - Conformità alla STI delle caratteristiche ferromagnetiche richieste per il materiale costitutivo delle ruote
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_14_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.14'',SOL_TRACK_1_1_1_3_7_14) SOL_TRACK_1_1_1_3_7_14_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.14'',SOL_TRACK_1_1_1_3_7_14) SOL_TRACK_1_1_1_3_7_14_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.14'',SOL_TRACK_1_1_1_3_7_14) SOL_TRACK_1_1_1_3_7_14_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_14_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_14, ';
--
-- 1.1.1.3.7.15.1 - CTD_TSIMaxImpedanceWheelset - se Ap=Y --> sempre [conforme alla STI] - Conformità alla STI della massima impedenza consentita tra ruote opposte di una sala montata
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_15_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.15.1'',SOL_TRACK_1_1_1_3_7_15_1) SOL_TRACK_1_1_1_3_7_15_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.15.1'',SOL_TRACK_1_1_1_3_7_15_1) SOL_TRACK_1_1_1_3_7_15_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.15.1'',SOL_TRACK_1_1_1_3_7_15_1) SOL_TRACK_1_1_1_3_7_15_1_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_15_1_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_15_1, ';
--
-- 1.1.1.3.7.15.2 - CTD_MaxImpedanceWheelset - per RFI sempre AP=N - Massima impedenza consentita tra ruote opposte di una sala montata in caso di non conformità alla STI
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_15_2_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_15_2_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'Trim(To_Char(Round(SOL_TRACK_1_1_1_3_7_15_2, 3), ''999990.999'')) SOL_TRACK_1_1_1_3_7_15_2, ';
--
-- 1.1.1.3.7.16 - CTD_TSISand (Parametro cancellato col Reg.2019/777) - Conformità alla STI della sabbiatura
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_16_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.16'',SOL_TRACK_1_1_1_3_7_16) SOL_TRACK_1_1_1_3_7_16_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.16'',SOL_TRACK_1_1_1_3_7_16) SOL_TRACK_1_1_1_3_7_16_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.16'',SOL_TRACK_1_1_1_3_7_16) SOL_TRACK_1_1_1_3_7_16_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_16_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_16, ';
--
-- 1.1.1.3.7.17 - CTD_MaxSandOutput (MODIFICATO col Reg.2019/777) - Quantità massima di sabbia 
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_17_AP, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_17_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_17, ';
--
-- 1.1.1.3.7.18 - CTD_SandDriverOverride - Necessità di disattivazione del dispositivo di sabbiatura ad opera del macchinista
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_18_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.18'',SOL_TRACK_1_1_1_3_7_18) SOL_TRACK_1_1_1_3_7_18_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.18'',SOL_TRACK_1_1_1_3_7_18) SOL_TRACK_1_1_1_3_7_18_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.18'',SOL_TRACK_1_1_1_3_7_18) SOL_TRACK_1_1_1_3_7_18_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_18_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_18, ';
--
-- 1.1.1.3.7.19 - CTD_TSISandCharacteristics - Conformità alla STI delle norme sulle caratteristiche della sabbia
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_19_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.19'',SOL_TRACK_1_1_1_3_7_19) SOL_TRACK_1_1_1_3_7_19_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.19'',SOL_TRACK_1_1_1_3_7_19) SOL_TRACK_1_1_1_3_7_19_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.19'',SOL_TRACK_1_1_1_3_7_19) SOL_TRACK_1_1_1_3_7_19_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_19_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_19, ';
--
-- 1.1.1.3.7.20 - CTD_FlangeLubeRules - Esistenza di norme sulla lubrificazione del bordino a bordo
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_20_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.20'',SOL_TRACK_1_1_1_3_7_20) SOL_TRACK_1_1_1_3_7_20_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.20'',SOL_TRACK_1_1_1_3_7_20) SOL_TRACK_1_1_1_3_7_20_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.20'',SOL_TRACK_1_1_1_3_7_20) SOL_TRACK_1_1_1_3_7_20_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_20_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_20, ';
--
-- 1.1.1.3.7.21 - CTD_TSICompositeBrakeBlocks - Conformità alla STI delle norme sull'uso dei ceppi dei freni in materiale composito
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_21_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.21'',SOL_TRACK_1_1_1_3_7_21) SOL_TRACK_1_1_1_3_7_21_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.21'',SOL_TRACK_1_1_1_3_7_21) SOL_TRACK_1_1_1_3_7_21_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.21'',SOL_TRACK_1_1_1_3_7_21) SOL_TRACK_1_1_1_3_7_21_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_21_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_21,  ';
--
-- 1.1.1.3.7.22 - CTD_TSIShuntDevices - Conformità alla STI delle norme sui dispositivi di assistenza allo shunt
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_22_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.22'',SOL_TRACK_1_1_1_3_7_22) SOL_TRACK_1_1_1_3_7_22_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.22'',SOL_TRACK_1_1_1_3_7_22) SOL_TRACK_1_1_1_3_7_22_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.22'',SOL_TRACK_1_1_1_3_7_22) SOL_TRACK_1_1_1_3_7_22_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_22_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_22, ';
--
-- 1.1.1.3.7.23 - CTD_TSIRSTShuntImpedance - Conformità alla STI delle norme sulle combinazioni di caratteristiche del materiale rotabile che influenzano l'impedenza di shunt
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_23_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.7.23'',SOL_TRACK_1_1_1_3_7_23) SOL_TRACK_1_1_1_3_7_23_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.7.23'',SOL_TRACK_1_1_1_3_7_23) SOL_TRACK_1_1_1_3_7_23_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.7.23'',SOL_TRACK_1_1_1_3_7_23) SOL_TRACK_1_1_1_3_7_23_DES, ';
sqlstringa := sqlstringa || 'Nvl(RFI.GetSet(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1, SOL_TRACK_1_1_1_3_7_1_1_AP), ''*'') SOL_TRACK_1_1_1_3_7_23_SET, ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_23, ';
--
-- 1.1.1.3.8	 CTS / Transitions between systems - Transizioni tra sistemi
-- 1.1.1.3.8.1 - CTS_SwitchProtectControlWarn - Esistenza di transizione tra diversi sistemi di protezione, controllo e allerta con treno in movimento
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_8_1_AP, '; --Stringa corretta
--sqlstringa := sqlstringa || '''NYA'' SOL_TRACK_1_1_1_3_8_1_AP, '; --Stringa forzata a NYA per Autiero in attesa di ritorno ERA 31/07/2015
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.8.1'',SOL_TRACK_1_1_1_3_8_1) SOL_TRACK_1_1_1_3_8_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.8.1'',SOL_TRACK_1_1_1_3_8_1) SOL_TRACK_1_1_1_3_8_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.8.1'',SOL_TRACK_1_1_1_3_8_1) SOL_TRACK_1_1_1_3_8_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_8_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_8_1, ';
--
-- 1.1.1.3.8.2 - CTS_SwitchRadioSystem - Esistenza di commutazione tra sistemi radio diversi
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_8_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.8.2'',SOL_TRACK_1_1_1_3_8_2) SOL_TRACK_1_1_1_3_8_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.8.2'',SOL_TRACK_1_1_1_3_8_2) SOL_TRACK_1_1_1_3_8_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.8.2'',SOL_TRACK_1_1_1_3_8_2) SOL_TRACK_1_1_1_3_8_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_8_2_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_8_2, ';
--
-- 1.1.1.3.9	 CEI / Parameters related to electromagnetic interferences - Parametri relativi alle interferenze elettromagnetiche
-- 1.1.1.3.9.1 - CEI_TSIMagneticFields - Esistenza e conformità alla STI di norme relative ai campi magnetici emessi da un veicolo
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_9_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.9.1'',SOL_TRACK_1_1_1_3_9_1) SOL_TRACK_1_1_1_3_9_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.9.1'',SOL_TRACK_1_1_1_3_9_1) SOL_TRACK_1_1_1_3_9_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.9.1'',SOL_TRACK_1_1_1_3_9_1) SOL_TRACK_1_1_1_3_9_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_9_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_9_1, ';
--
-- 1.1.1.3.9.2 - CEI_TSITractionHarmonics - Esistenza e conformità alla STI di limiti nelle armoniche nella corrente di trazione dei veicoli
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_9_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.9.2'',SOL_TRACK_1_1_1_3_9_2) SOL_TRACK_1_1_1_3_9_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.9.2'',SOL_TRACK_1_1_1_3_9_2) SOL_TRACK_1_1_1_3_9_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.9.2'',SOL_TRACK_1_1_1_3_9_2) SOL_TRACK_1_1_1_3_9_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_9_2_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_9_2, ';
--
-- 1.1.1.3.10 CLD / Line-side system for degraded situation - Sistema di terra per situazioni degradate
-- 1.1.1.3.10.1 - CLD_ETCSSituation  - Line-side system for degraded situation - Livello ETCS per situazioni degradate
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_10_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.10.1'',SOL_TRACK_1_1_1_3_10_1) SOL_TRACK_1_1_1_3_10_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.10.1'',SOL_TRACK_1_1_1_3_10_1) SOL_TRACK_1_1_1_3_10_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.10.1'',SOL_TRACK_1_1_1_3_10_1) SOL_TRACK_1_1_1_3_10_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_10_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_10_1, ';
--
-- 1.1.1.3.10.2 - CLD_OtherProtectControlWarn - Altri sistemi di protezione, controllo e allerta in caso di situazioni degradate
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_10_2_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.10.2'',SOL_TRACK_1_1_1_3_10_2) SOL_TRACK_1_1_1_3_10_2_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.10.2'',SOL_TRACK_1_1_1_3_10_2) SOL_TRACK_1_1_1_3_10_2_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.10.2'',SOL_TRACK_1_1_1_3_10_2) SOL_TRACK_1_1_1_3_10_2_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_10_2_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_10_2, ';
--
-- 1.1.1.3.11 CBP / Brake related parameters - Parametri relativi ai freni
-- 1.1.1.3.11.1 - CBP_MaxBrakeDist - Distanza massima di frenatura richiesta
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_11_1_AP, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_11_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_11_1, ';
--
-- 1.1.1.3.11.2 - CBP_AddInfoAvailable (Nuovo Parametro Reg.2019/777) - AP = Y - Valore (Intera rete) = [S]
-- Disponibilità di informazioni supplementari da parte del GI
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_11_2_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.11.2'', SOL_TRACK_1_1_1_3_11_2) SOL_TRACK_1_1_1_3_11_2_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.11.2'', SOL_TRACK_1_1_1_3_11_2) SOL_TRACK_1_1_1_3_11_2_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.11.2'', SOL_TRACK_1_1_1_3_11_2) SOL_TRACK_1_1_1_3_11_2_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_11_2_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_11_2, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.11.2'') Flag_1_1_1_3_11_2_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.11.3 - CBP_BrakePerfDocRef (Nuovo Parametro Reg.2019/777) - AP = Y - Valore (Intera rete) = [PGOS - IF]
-- Documenti sulle prestazioni di frenata messi a disposizione dal GI
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_11_3_AP,';
 sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.11.3'', SOL_TRACK_1_1_1_3_11_3) SOL_TRACK_1_1_1_3_11_3_XML, ';
 sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.11.3'', SOL_TRACK_1_1_1_3_11_3) SOL_TRACK_1_1_1_3_11_3_OV, ';
 sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.11.3'', SOL_TRACK_1_1_1_3_11_3) SOL_TRACK_1_1_1_3_11_3_DES, ';
 sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_11_3_SET,';
 sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_11_3, ';
 sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.3.11.3'') Flag_1_1_1_3_11_3_AT, '; --> Nuovo attributo
--
-- 1.1.1.3.12 COP / Other CCS related parameters - Altri parametri associati al CCS
-- 1.1.1.3.12.1 - COP_Tilting (Parametro cancellato col Reg.2019/777) - Assetto variabile supportato (Parametro cancellato. Da indicare per informazione.)
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_12_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.3.12.1'',SOL_TRACK_1_1_1_3_12_1) SOL_TRACK_1_1_1_3_12_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.3.12.1'',SOL_TRACK_1_1_1_3_12_1) SOL_TRACK_1_1_1_3_12_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.3.12.1'',SOL_TRACK_1_1_1_3_12_1) SOL_TRACK_1_1_1_3_12_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_3_12_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_12_1, ';
--
-- 1.1.1.4 Rules and restriction - Norme e restrizioni
-- 1.1.1.4.1 	RUL_LocalRulesOrRestrictions - Esistenza di norme e restrizioni di natura strettamente locale
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_4_1_AP, ';
sqlstringa := sqlstringa || 'RFI.getxmlvalue(''1.1.1.4.1'',SOL_TRACK_1_1_1_4_1) SOL_TRACK_1_1_1_4_1_XML, ';
sqlstringa := sqlstringa || 'RFI.GetOpValue(''1.1.1.4.1'',SOL_TRACK_1_1_1_4_1) SOL_TRACK_1_1_1_4_1_OV, ';
sqlstringa := sqlstringa || 'RFI.GetDescr(''1.1.1.4.1'',SOL_TRACK_1_1_1_4_1) SOL_TRACK_1_1_1_4_1_DES, ';
sqlstringa := sqlstringa || ' null SOL_TRACK_1_1_1_4_1_SET, ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_4_1, ';
sqlstringa := sqlstringa || 'GetPar_attivo(''1.1.1.4.1'') Flag_1_1_1_4_1_AT, '; --> Nuovo attributo
-- 1.1.1.4.2	RUL_LocalRulesOrRestrictionsDocRef - Documenti relativi a norme e restrizioni di natura strettamente locale messi a disposizione dal GI
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_4_2_AP, Norme_Doc.SOL_TRACK_1_1_1_4_2_XML, Norme_Doc.SOL_TRACK_1_1_1_4_2_OV, Norme_Doc.SOL_TRACK_1_1_1_4_2_DES, ';
sqlstringa := sqlstringa || ' null  SOL_TRACK_1_1_1_4_2_SET, Norme_Doc.SOL_TRACK_1_1_1_4_2, GetPar_attivo(''1.1.1.4.2'') Flag_1_1_1_4_2_AT '; --> Nuovo attributo
--
sqlstringa := sqlstringa || ' From '||s_schema||'.BINARI_CORSA_SOL s, ';
--
-- If p_versione Is Not Null Then
 If (P_AREA = 2 Or P_AREA = 4) Then
--  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, Listagg(DECODE(SIGN(PENDENZA),-1,Trim(To_Char(PENDENZA,''9999999999999990.9'')),''+''||Trim(To_Char(PENDENZA,''9999999999999990.9'')))||''(''||Trim(To_Char(LEAST(KM_INIZIO,KM_FINE),''9999999999999990.999''))||'')'',''#'') Within Group (Order By LEAST(KM_INIZIO,KM_FINE)) AS gradiente ';
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, Listagg(DECODE(SIGN(Nvl(PENDENZA, 99.9)),-1,Trim(To_Char(PENDENZA,''9999999999999990.9'')),''+''||Trim(To_Char(Nvl(PENDENZA,99.9),''9999999999999990.9'')))||''(''||Trim(To_Char(LEAST(KM_INIZIO,KM_FINE),''9999999999999990.999''))||'')'',''#'') Within Group (Order By LEAST(KM_INIZIO,KM_FINE)) AS gradiente ';
--
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_3_6_GRADIENTE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) p, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, Listagg(SOL_TRACK_1_1_1_1_2_1,''#'') Within Group (Order By KM_INIZIO,SOL_TRACK_1_1_1_1_2_1) AS SOL_TRACK_1_1_1_1_2_1, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_2_1_CAT_TEN_SOL, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO and ';
  sqlstringa := sqlstringa || 'numero_parametro = ''1.1.1.1.2.1'' and ';
  sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_1 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) cat_ten, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, Listagg(SOL_TRACK_1_1_1_1_2_2,''#'') Within Group (Order By KM_INIZIO,SOL_TRACK_1_1_1_1_2_2) AS SOL_TRACK_1_1_1_1_2_2, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_2_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_2_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_2_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_2_2_CAT_LINEA, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO and ';
  sqlstringa := sqlstringa || 'numero_parametro = ''1.1.1.1.2.2'' and ';
  sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_2 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) cat_linea, ';
--
  sqlstringa := sqlstringa || '(Select SEDE_TECNICA, CODICE_VERSIONE, Listagg(v.DESCRIZIONE, ''#'') Within Group (Order By v.DESCRIZIONE) AS SOL_TRACK_1_1_1_1_2_3, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where CODICE_CONTESTO = 3 and ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO and ';
  sqlstringa := sqlstringa || 'CODICE||''0'' = CODIFICA_VALORE and ';  --24/'7/2015 la vecchia join fatta sulle descrizioni non andava bene, il codice è stato moltiplicato per 10, perché è il valore contenuto in DOMINIO_PARAMETRI(3=>30,1 =>10 etc.)
  sqlstringa := sqlstringa || 'numero_parametro = ''1.1.1.1.2.3'' and ';
  sqlstringa := sqlstringa || 'SEDE_TECNICA = '''||p_SOL||''' ';
  sqlstringa := sqlstringa || 'group by SEDE_TECNICA, CODICE_VERSIONE) corridoio, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, Listagg(SOL_TRACK_1_1_1_1_2_4,''#'') Within Group (Order By KM_INIZIO,SOL_TRACK_1_1_1_1_2_4) AS SOL_TRACK_1_1_1_1_2_4, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_2_4_CAP_CARICO, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO and ';
  sqlstringa := sqlstringa || 'numero_parametro = ''1.1.1.1.2.4'' and ';
  sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_4 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) cap_carico, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, Listagg(SOL_TRACK_1_1_1_1_3_4,''#'') Within Group (Order By KM_INIZIO,SOL_TRACK_1_1_1_1_3_4) AS SOL_TRACK_1_1_1_1_3_4, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_4_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_4_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_4_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_3_4_PROF_CAS_M, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO and ';
  sqlstringa := sqlstringa || 'numero_parametro = ''1.1.1.1.3.4'' and ';
  sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_4 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) prof_casse, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, Listagg(SOL_TRACK_1_1_1_1_3_5,''#'') Within Group (Order By KM_INIZIO,SOL_TRACK_1_1_1_1_3_5) AS SOL_TRACK_1_1_1_1_3_5, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_5_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_5_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_5_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_3_5_PROF_SEMI_R, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO and ';
  sqlstringa := sqlstringa || 'numero_parametro = ''1.1.1.1.3.5'' and ';
  sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_5 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) prof_semir, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, Listagg(SOL_TRACK_1_1_1_3_3_3,''#'') Within Group (Order By KM_INIZIO,SOL_TRACK_1_1_1_3_3_3) AS SOL_TRACK_1_1_1_3_3_3, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_3_3_3_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_3_3_3_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_3_3_3_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_3_3_GSM_R_FAC, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO and ';
  sqlstringa := sqlstringa || 'numero_parametro = ''1.1.1.3.3.3'' and ';
  sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_3 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) gsm, ';
-->
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, ';
  sqlstringa := sqlstringa || 'Listagg(Decode(SOL_TRACK_1_1_1_1_2_4_3, ''9999.999'', Null, SOL_TRACK_1_1_1_1_2_4_3), ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_1_2_4_3) As SOL_TRACK_1_1_1_1_2_4_3, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By VALORE_XML) As SOL_TRACK_1_1_1_1_2_4_3_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_3_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By VALORE_XML) As SOL_TRACK_1_1_1_1_2_4_3_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_2_4_3_LOCAVERSPEC, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI   c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.1.2.4.3'' And SOL_TRACK_1_1_1_1_2_4_3 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE ) Locaverspec,	';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_1_7_8, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_1_7_8) As SOL_TRACK_1_1_1_1_7_8, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_1_7_8_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) AS SOL_TRACK_1_1_1_1_7_8_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_1_7_8_des ';
  sqlstringa := sqlstringa || 'From  '||s_schema||'.PAR_1_1_1_1_7_8_LOCA_SIST_RTB, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO    d,  RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI   c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.1.7.8'' And SOL_TRACK_1_1_1_1_7_8 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) Loca_Sist_Rtb, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_2_9, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_2_9) As SOL_TRACK_1_1_1_3_2_9, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_2_9_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) AS SOL_TRACK_1_1_1_3_2_9_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_2_9_des ';
  sqlstringa := sqlstringa || 'From  '||s_schema||'.PAR_1_1_1_3_2_9_COMP_ETCS, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO    d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.2.9'' And SOL_TRACK_1_1_1_3_2_9 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) Comp_Etcs, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_3_5, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_3_5) As SOL_TRACK_1_1_1_3_3_5, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_5_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_5_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_5_des ';
  sqlstringa := sqlstringa || 'From  '||s_schema||'.PAR_1_1_1_3_3_5_RETI_GSM_R, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO    d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.3.5''  And SOL_TRACK_1_1_1_3_3_5 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE)  Reti_Gsm_R, ';
--	
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_3_9, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_3_9) As SOL_TRACK_1_1_1_3_3_9, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_9_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) AS SOL_TRACK_1_1_1_3_3_9_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_9_des ';
  sqlstringa := sqlstringa || 'From  '||s_schema||'.PAR_1_1_1_3_3_9_RADIO_VOCE, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO    d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
--  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.3.3.9'' And SOL_TRACK_1_1_1_3_3_9 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.3.9'' And SOL_TRACK_1_1_1_3_3_9 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE ) Radio_Voce, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_3_10, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_3_10) As SOL_TRACK_1_1_1_3_3_10, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_10_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) AS SOL_TRACK_1_1_1_3_3_10_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_10_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_3_10_RADIO_DATI, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO    d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
--  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.3.3.10'' And SOL_TRACK_1_1_1_3_3_10 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.3.10'' And SOL_TRACK_1_1_1_3_3_10 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE ) Radio_Dati, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_5_3, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_5_3) As SOL_TRACK_1_1_1_3_5_3, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_5_3_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) AS SOL_TRACK_1_1_1_3_5_3_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_5_3_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_5_3_SIST_PRE_PROT, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO    d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.5.3'' And SOL_TRACK_1_1_1_3_5_3 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE ) Sist_Pre_Prot, ';
 --
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_7_1_3, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_7_1_3) As SOL_TRACK_1_1_1_3_7_1_3, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_7_1_3_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_7_1_3_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_7_1_3_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_7_1_3_SISTRILTRAIN, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO    d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.7.1.3''  And SOL_TRACK_1_1_1_3_7_1_3 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE )  Sis_Ril_Doc, ';
 --
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE,';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_7_11_1, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_7_11_1) As SOL_TRACK_1_1_1_3_7_11_1, ';
---->  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_7_11_1) As SOL_TRACK_1_1_1_3_7_11_1, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_7_11_1_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_7_11_1_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_7_11_1_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_7_11_1_CARMIN_ASSE, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.7.11.1''  And SOL_TRACK_1_1_1_3_7_11_1 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) CarMin_Asse,	';
 --
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_4_2, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_4_2) As SOL_TRACK_1_1_1_4_2, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_4_2_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_4_2_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_4_2_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_4_2_NORME_DOC, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO  d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.4.2''  And SOL_TRACK_1_1_1_4_2 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE ) Norme_Doc	';
--->	
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 's.CODICE_VERSIONE = '||To_Char(p_versione) ||' and ';
  sqlstringa := sqlstringa || 'S.CODICE_VERSIONE = P.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 'S.CODICE_VERSIONE = cat_ten.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 'S.CODICE_VERSIONE = cat_linea.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 'S.CODICE_VERSIONE = corridoio.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 'S.CODICE_VERSIONE = cap_carico.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 'S.CODICE_VERSIONE = prof_casse.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 'S.CODICE_VERSIONE = prof_semir.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 'S.CODICE_VERSIONE = gsm.CODICE_VERSIONE (+) and ';
--
  sqlstringa := sqlstringa || 's.CODICE_VERSIONE = Locaverspec.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 's.CODICE_VERSIONE = Loca_Sist_Rtb.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 's.CODICE_VERSIONE = Comp_Etcs.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 's.CODICE_VERSIONE = Reti_Gsm_R.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 's.CODICE_VERSIONE = Radio_Voce.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 's.CODICE_VERSIONE = Radio_Dati.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 's.CODICE_VERSIONE = Sist_Pre_Prot.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 's.CODICE_VERSIONE = Sis_Ril_Doc.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 's.CODICE_VERSIONE = CarMin_Asse.CODICE_VERSIONE (+) and ';
  sqlstringa := sqlstringa || 's.CODICE_VERSIONE = Norme_Doc.CODICE_VERSIONE (+) and ';
--
  sqlstringa := sqlstringa || 's.SEDE_TECNICA = '''||p_SOL ||''' and ';
-- 
 Else
--  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, Listagg(DECODE(SIGN(PENDENZA),-1,Trim(To_Char(PENDENZA,''9999999999999990.9'')),''+''||Trim(To_Char(PENDENZA,''9999999999999990.9'')))||''(''||Trim(To_Char(LEAST(KM_INIZIO,KM_FINE),''9999999999999990.999''))||'')'',''#'') Within Group (Order By LEAST(KM_INIZIO,KM_FINE)) AS gradiente ';
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, Listagg(DECODE(SIGN(Nvl(PENDENZA,99.9)),-1,Trim(To_Char(Nvl(PENDENZA,99.9),''9999999999999990.9'')),''+''||Trim(To_Char(Nvl(PENDENZA,99.9),''9999999999999990.9'')))||''(''||Trim(To_Char(LEAST(KM_INIZIO,KM_FINE),''9999999999999990.999''))||'')'',''#'') Within Group (Order By LEAST(KM_INIZIO,KM_FINE)) AS gradiente ';
--
  sqlstringa := sqlstringa || ' From '||s_schema||'.PAR_1_1_1_1_3_6_GRADIENTE ';
  sqlstringa := sqlstringa || ' group by SOL_TRACK_1_1_1_0_0_1) p, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, Listagg(SOL_TRACK_1_1_1_1_2_1,''#'') Within Group (Order By KM_INIZIO,SOL_TRACK_1_1_1_1_2_1) AS SOL_TRACK_1_1_1_1_2_1, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_2_1_CAT_TEN_SOL, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO and ';
  sqlstringa := sqlstringa || 'NUMERO_PARAMETRO = ''1.1.1.1.2.1'' and ';
  sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_1 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1) cat_ten, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, Listagg(SOL_TRACK_1_1_1_1_2_2,''#'') Within Group (Order By KM_INIZIO,SOL_TRACK_1_1_1_1_2_2) AS SOL_TRACK_1_1_1_1_2_2, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_2_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_2_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_2_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_2_2_CAT_LINEA, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO and ';
  sqlstringa := sqlstringa || 'NUMERO_PARAMETRO = ''1.1.1.1.2.2'' and ';
  sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_2 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1) cat_linea, ';
--
  sqlstringa := sqlstringa || '(Select SEDE_TECNICA, Listagg(v.DESCRIZIONE,''#'') Within Group (Order By v.DESCRIZIONE) AS SOL_TRACK_1_1_1_1_2_3, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where CODICE_CONTESTO = 3 and ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO and ';
  sqlstringa := sqlstringa || 'CODICE||''0'' = CODIFICA_VALORE and ';  --24/'7/2015 la vecchia join fatta sulle descrizioni non andava bene, il codice è stato moltiplicato per 10, perché è il valore contenuto in DOMINIO_PARAMETRI(3=>30,1 =>10 etc.)
  sqlstringa := sqlstringa || 'NUMERO_PARAMETRO = ''1.1.1.1.2.3'' and ';
  sqlstringa := sqlstringa || 'SEDE_TECNICA = '''||p_SOL||''' ';
  sqlstringa := sqlstringa || 'group by SEDE_TECNICA) corridoio, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, Listagg(SOL_TRACK_1_1_1_1_2_4,''#'') Within Group (Order By KM_INIZIO,SOL_TRACK_1_1_1_1_2_4) AS SOL_TRACK_1_1_1_1_2_4, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_2_4_CAP_CARICO, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO and ';
  sqlstringa := sqlstringa || 'NUMERO_PARAMETRO = ''1.1.1.1.2.4'' and ';
  sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_4 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1) cap_carico, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, Listagg(SOL_TRACK_1_1_1_1_3_4,''#'') Within Group (Order By KM_INIZIO,SOL_TRACK_1_1_1_1_3_4) AS SOL_TRACK_1_1_1_1_3_4, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_4_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_4_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_4_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_3_4_PROF_CAS_M, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO and ';
  sqlstringa := sqlstringa || 'NUMERO_PARAMETRO = ''1.1.1.1.3.4'' and ';
  sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_4 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1) prof_casse, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, Listagg(SOL_TRACK_1_1_1_1_3_5,''#'') Within Group (Order By KM_INIZIO,SOL_TRACK_1_1_1_1_3_5) AS SOL_TRACK_1_1_1_1_3_5, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_5_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_5_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_5_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_3_5_PROF_SEMI_R, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 'c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And ';
  sqlstringa := sqlstringa || 'NUMERO_PARAMETRO = ''1.1.1.1.3.5'' And ';
  sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_5=CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1) prof_semir, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, Listagg(SOL_TRACK_1_1_1_3_3_3,''#'') Within Group (Order By KM_INIZIO,SOL_TRACK_1_1_1_3_3_3) AS SOL_TRACK_1_1_1_3_3_3, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_3_3_3_XML, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_3_3_3_OV, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE,''#'') Within Group (Order By KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_3_3_3_DES ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_3_3_GSM_R_FAC, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
  sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where ';
  sqlstringa := sqlstringa || 'c.codice_parametro = d.codice_parametro And ';
  sqlstringa := sqlstringa || 'numero_parametro = ''1.1.1.3.3.3'' And ';
  sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_3 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'group by SOL_TRACK_1_1_1_0_0_1) gsm, ';
-->
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_1_2_4_3, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_1_2_4_3) As SOL_TRACK_1_1_1_1_2_4_3, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_1_2_4_3_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_3_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_1_2_4_3_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_2_4_3_LOCAVERSPEC, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO    d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI   c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.1.2.4.3''  And SOL_TRACK_1_1_1_1_2_4_3 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1 ) Locaverspec, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_1_7_8, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_1_7_8) As SOL_TRACK_1_1_1_1_7_8, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_1_7_8_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) AS SOL_TRACK_1_1_1_1_7_8_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_1_7_8_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_1_7_8_LOCA_SIST_RTB, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,  RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.1.7.8'' And SOL_TRACK_1_1_1_1_7_8 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1) Loca_Sist_Rtb, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_2_9, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_2_9) As SOL_TRACK_1_1_1_3_2_9, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_2_9_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) AS SOL_TRACK_1_1_1_3_2_9_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_2_9_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_2_9_COMP_ETCS, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.2.9'' And SOL_TRACK_1_1_1_3_2_9 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1) Comp_Etcs, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_3_5, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_3_5) As SOL_TRACK_1_1_1_3_3_5, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_5_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_5_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_5_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_3_5_RETI_GSM_R, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.3.5''  And SOL_TRACK_1_1_1_3_3_5 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1)  Reti_Gsm_R, ';
--	
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_3_9, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_3_9) As SOL_TRACK_1_1_1_3_3_9, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_9_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) AS SOL_TRACK_1_1_1_3_3_9_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_9_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_3_9_RADIO_VOCE, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
-- sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.3.3.9'' And SOL_TRACK_1_1_1_3_3_9 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.3.9'' And SOL_TRACK_1_1_1_3_3_9 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1 ) Radio_Voce, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_3_10, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_3_10) As SOL_TRACK_1_1_1_3_3_10, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_10_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) AS SOL_TRACK_1_1_1_3_3_10_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_3_10_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_3_10_RADIO_DATI, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
--  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.3.3.10'' And SOL_TRACK_1_1_1_3_3_10 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.3.10'' And SOL_TRACK_1_1_1_3_3_10 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1) Radio_Dati, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_5_3, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_5_3) As SOL_TRACK_1_1_1_3_5_3, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_5_3_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) AS SOL_TRACK_1_1_1_3_5_3_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_5_3_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_5_3_SIST_PRE_PROT, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO    d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.5.3'' And SOL_TRACK_1_1_1_3_5_3 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1) Sist_Pre_Prot, ';
 --
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_7_1_3, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_7_1_3) As SOL_TRACK_1_1_1_3_7_1_3, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_7_1_3_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_7_1_3_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_7_1_3_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_7_1_3_SISTRILTRAIN, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.7.1.3'' And SOL_TRACK_1_1_1_3_7_1_3 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1) Sis_Ril_Doc, ';
 --
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, ';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_3_7_11_1, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_7_11_1) As SOL_TRACK_1_1_1_3_7_11_1, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_7_11_1_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_7_11_1_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_3_7_11_1_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_3_7_11_1_CARMIN_ASSE, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.3.7.11.1''  And SOL_TRACK_1_1_1_3_7_11_1 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1) CarMin_Asse, ';
--
  sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1,';
  sqlstringa := sqlstringa || 'Listagg(SOL_TRACK_1_1_1_4_2, ''#'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_4_2) As SOL_TRACK_1_1_1_4_2, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE_XML, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_4_2_xml, ';
  sqlstringa := sqlstringa || 'Listagg(OPTIONAL_VALUE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_4_2_ov, ';
  sqlstringa := sqlstringa || 'Listagg(VALORE, ''#'') Within Group (Order By KM_INIZIO, VALORE_XML) As SOL_TRACK_1_1_1_4_2_des ';
  sqlstringa := sqlstringa || 'From '||s_schema||'.PAR_1_1_1_4_2_NORME_DOC, RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
  sqlstringa := sqlstringa || 'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO And NUMERO_PARAMETRO = ''1.1.1.4.2''  And SOL_TRACK_1_1_1_4_2 = CODIFICA_VALORE ';
  sqlstringa := sqlstringa || 'Group By SOL_TRACK_1_1_1_0_0_1)  Norme_Doc ';

--->	
  sqlstringa := sqlstringa || 'Where s.SEDE_TECNICA = '''||p_SOL ||''' and  ';
 End If;

sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1 = P.SOL_TRACK_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1 = cat_ten.SOL_TRACK_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1 = cat_linea.SOL_TRACK_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.SEDE_TECNICA = corridoio.SEDE_TECNICA (+) and  ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1 = cap_carico.SOL_TRACK_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1 = prof_casse.SOL_TRACK_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1 = prof_semir.SOL_TRACK_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1 = gsm.SOL_TRACK_1_1_1_0_0_1 (+) and ';
--->	
sqlstringa := sqlstringa || 's.sol_track_1_1_1_0_0_1 = Locaverspec.sol_track_1_1_1_0_0_1 (+) and  ';
sqlstringa := sqlstringa || 's.sol_track_1_1_1_0_0_1 = Loca_Sist_Rtb.sol_track_1_1_1_0_0_1 (+) and  ';
sqlstringa := sqlstringa || 's.sol_track_1_1_1_0_0_1 = Comp_Etcs.sol_track_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.sol_track_1_1_1_0_0_1 = Reti_Gsm_R.sol_track_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.sol_track_1_1_1_0_0_1 = Radio_Voce.sol_track_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.sol_track_1_1_1_0_0_1 = Radio_Dati.sol_track_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.sol_track_1_1_1_0_0_1 = Sist_Pre_Prot.sol_track_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.sol_track_1_1_1_0_0_1 = Sis_Ril_Doc.sol_track_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.sol_track_1_1_1_0_0_1 = CarMin_Asse.sol_track_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.sol_track_1_1_1_0_0_1 = Norme_Doc.sol_track_1_1_1_0_0_1 (+) ';
--
sqlstringa := sqlstringa || ' Order By 3';
-->
--
--
 Open p_cursor For sqlstringa;
--
--
 Exception
   When NO_DATA_FOUND Then
     Null;
   When Others Then
      raise_application_error(-20001,'GetTracks_General - '||SQLCODE||' -ERROR- '||SQLERRM);
--
 End GetTracks_General;
--
-- -----------------------------------------------------------------------------
--                                        GetTracks_Inf_EC 
-- Ritorna l'elenco delle dichiarazioni di verifica EC e EI della vista Infrastuttura  di un Binario di Corsa di una SOL
-- -----------------------------------------------------------------------------
 Procedure GetTracks_Inf_EC (p_Track Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur) Is
--
   s_schema   Varchar2(100);
--   sqlstringa Varchar2(20000);
   sqlstringa   CLOB;            
--
   p_versione Number;
--
 BEGIN
   S_SCHEMA   := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
   P_VERSIONE := P_I_VERSIONE;
   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
       P_VERSIONE := GetLastVersion(P_AREA);
   End If;
--
-- -------------------------------------  EC -------------------------------------------------------
   sqlstringa :=  'Select Distinct s.SOL_TRACK_1_1_1_0_0_1 Track_ID,  ';
   sqlstringa := sqlstringa || Nvl(To_Char( p_versione), 'Null')||' CODICE_VERSIONE,  ';
   sqlstringa := sqlstringa || '''EC'' TIPO_DICHIARAZIONE,  ';
   sqlstringa := sqlstringa || ' Nvl(SOL_TRACK_1_1_1_1_1_1O2_AP,'''||PKG_RINF_DATA_V777.GetNYA('1.1.1.1.1.1')||''') SOL_TRACK_1_1_1_1_1_1O2_AP, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) > 0 ) Then SOL_TRACK_1_1_1_1_1_1O2  Else ''00/00000000000000/0000/000000'' End SOL_TRACK_1_1_1_1_1_1O2, ';
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then '''' ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)), t.KM_INIZIO), ''9990.99999''))  Else  Null End Else  Null  End KM_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 and b.KM_INIZIO >= 0 and b.KM_FINE > 0) then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Least(Greatest(b.KM_FINE,b.KM_INIZIO), t.KM_FINE), ''9990.99999'')) Else  Null End Else  Null End  KM_FINE, ';
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), '||Nvl(To_Char( p_versione), 'Null')||', 1) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else  Null End Else Null  End  LATITUDINE_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), '||Nvl(To_Char( p_versione), 'Null')||', 2) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End Else  Null   End  LONGITUDINE_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO),t.KM_FINE), '||Nvl(To_Char( p_versione), 'Null')||', 1) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else  Null End  Else  Null  End LATITUDINE_FINE, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), '||Nvl(To_Char( p_versione), 'Null')||', 2) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End Else Null End  LONGITUDINE_FINE, ';
--
   sqlstringa := sqlstringa || ' LTrim(To_Char(t.KM_INIZIO,''9990.99999'')) KM_INIZIO_TR, LTrim(To_Char(t.KM_FINE,''9990.99999'')) KM_FINE_TR, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 1), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End LATITUDINE_INIZIO_TR,  ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 2), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End LONGITUDINE_INIZIO_TR, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE,  '||Nvl(To_Char( p_versione), 'Null')||', 1), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null  End LATITUDINE_FINE_TR, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE,  '||Nvl(To_Char( p_versione),'Null')||',2), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End LONGITUDINE_FINE_TR, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' '' Km Inizio: '' ||Greatest( Least(Nvl(b.KM_INIZIO, 0), Nvl(b.KM_FINE, 0)), t.KM_INIZIO)||'' - Km Fine: ''||Least( Greatest(Nvl(b.KM_FINE,0), Nvl(b.KM_INIZIO,0)), t.KM_FINE)';
   sqlstringa := sqlstringa || '  Else    Null     End Else    Null     End LABEL ';
-- --------------------------- join tra tabelle --------------------------------
   sqlstringa := sqlstringa || ' From  ';
   sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, SOL_TRACK_1_1_1_1_1_1O2_AP, SOL_TRACK_1_1_1_1_1_1O2, KM_INIZIO, KM_FINE, ';
   sqlstringa := sqlstringa || ' Trunc(LATITUDINE_INIZIO, 5) LATITUDINE_INIZIO,  Trunc(LONGITUDINE_INIZIO, 5) LONGITUDINE_INIZIO,  ';
   sqlstringa := sqlstringa || ' Trunc(LATITUDINE_FINE, 5)  LATITUDINE_FINE, Trunc(LONGITUDINE_FINE, 5) LONGITUDINE_FINE, ';
   sqlstringa := sqlstringa || ' '' Km Inizio: ''||KM_INIZIO||'' - Lat\Lon Inizio: ''||trunc(LATITUDINE_INIZIO, 5)||''\''||trunc(LONGITUDINE_INIZIO, 5)|| '' - Km Fine: ''||KM_FINE|| '' - Lat\Lon Fine: ''||trunc(LATITUDINE_FINE, 5)||''\''||trunc(LONGITUDINE_FINE, 5) LABEL ';
--'
   sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
   sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EC''';
   sqlstringa := sqlstringa || ' And KM_INIZIO Is Not Null ';
   sqlstringa := sqlstringa || ' And LONGITUDINE_INIZIO Is Not Null ';
   sqlstringa := sqlstringa || ' And LATITUDINE_INIZIO Is Not Null ';
   sqlstringa := sqlstringa || ' And LONGITUDINE_INIZIO Is Not Null ';
   sqlstringa := sqlstringa || ' And KM_FINE Is Not Null ';
   sqlstringa := sqlstringa || ' And LATITUDINE_FINE Is Not Null ';
   sqlstringa := sqlstringa || ' And LONGITUDINE_FINE Is Not Null ';
   If p_versione Is Not Null then
           sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstringa := sqlstringa || ' UNION ';
   sqlstringa := sqlstringa || ' Select SOL_TRACK_1_1_1_0_0_1, SOL_TRACK_1_1_1_1_1_1O2_AP, SOL_TRACK_1_1_1_1_1_1O2, KM_INIZIO, KM_FINE, ';
-- 05/02/2018 LAM da decommentare
   sqlstringa := sqlstringa || ' Null LATITUDINE_INIZIO, Null LONGITUDINE_INIZIO, Null LATITUDINE_FINE, Null LONGITUDINE_FINE, ';
   sqlstringa := sqlstringa || ' Null LABEL ';
   sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
   sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EC''';
   sqlstringa := sqlstringa || ' And ( KM_INIZIO Is  Null ';
   sqlstringa := sqlstringa || ' Or LATITUDINE_INIZIO Is Null ';
   sqlstringa := sqlstringa || ' Or LONGITUDINE_INIZIO Is Null ';
   sqlstringa := sqlstringa || ' Or KM_FINE Is Null ';
   sqlstringa := sqlstringa || ' Or LATITUDINE_FINE Is Null ';
   sqlstringa := sqlstringa || ' Or LONGITUDINE_FINE Is Null ) ';
--
   If p_versione Is Not Null Then
           sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
   End If;
--
   sqlstringa := sqlstringa || ') b, ';
   sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_SOL s, ';
   sqlstringa := sqlstringa || '(Select SEDE_TECNICA, KM_INIZIO, KM_FINE ';
   sqlstringa := sqlstringa ||  ' From '|| s_schema||'.SEZIONI_LINEA ';
--
   If p_versione Is Not Null Then
            sqlstringa := sqlstringa || ' Where CODICE_VERSIONE = '||p_versione;
   End If;
--
   sqlstringa := sqlstringa || ' ) t ';
   sqlstringa := sqlstringa || ' Where s.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 (+) ';
   sqlstringa := sqlstringa || ' And s.SOL_TRACK_1_1_1_0_0_1 = '''||p_Track||''''  ;
   sqlstringa := sqlstringa || ' And s.SEDE_TECNICA = t.SEDE_TECNICA ';
--
   If p_versione Is Not Null Then
           sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
   End If;
--
-- ------------------------------------- EI ------------------------------------
   sqlstringa := sqlstringa || ' UNION  ';
   sqlstringa := sqlstringa || 'Select Distinct s.SOL_TRACK_1_1_1_0_0_1 Track_ID, ';
   sqlstringa := sqlstringa || Nvl(To_Char( p_versione), 'Null')||' CODICE_VERSIONE, ';
   sqlstringa := sqlstringa || '''EI'' tipo_dichiarazione,  ';
   sqlstringa := sqlstringa || 'Nvl(SOL_TRACK_1_1_1_1_1_1O2_AP,'''||PKG_RINF_DATA_V777.GetNYA('1.1.1.1.1.1')||''') SOL_TRACK_1_1_1_1_1_1O2_AP, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) > 0 ) Then SOL_TRACK_1_1_1_1_1_1O2  Else ''00/00000000000000/0000/000000'' End SOL_TRACK_1_1_1_1_1_1O2, ';
-->
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then LTrim(To_Char(t.KM_INIZIO, ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)), t.KM_INIZIO), ''9990.99999''))  Else  Null End Else  Null  End KM_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) > 0 and b.KM_INIZIO >= 0 and b.KM_FINE > 0) then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) Then LTrim(To_Char(t.KM_FINE,''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Least(Greatest(b.KM_FINE,b.KM_INIZIO), t.KM_FINE), ''9990.99999'')) Else  Null End Else  Null End  KM_FINE, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), '||Nvl(To_Char( p_versione), 'Null')||', 1) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else  Null End Else Null  End  LATITUDINE_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then  ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 2) ), ''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' Null ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), '||Nvl(To_Char( p_versione), 'Null')||', 2) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End Else  Null   End  LONGITUDINE_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, '||Nvl(To_Char( p_versione), 'Null')||',  1) ), ''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' Null ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO),t.KM_FINE), '||Nvl(To_Char( p_versione),'Null')||', 1) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else  Null End  Else  Null  End LATITUDINE_FINE, ';
--
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, '||Nvl(To_Char( p_versione), 'Null')||',  2) ), ''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' Null ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), '||Nvl(To_Char( p_versione), 'Null')||', 2) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End Else Null End  LONGITUDINE_FINE, ';
--
   sqlstringa := sqlstringa || ' LTrim(To_Char(t.KM_INIZIO,''9990.99999'')) KM_INIZIO_TR, LTrim(To_Char(t.KM_FINE,''9990.99999'')) KM_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) > 0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else Null End LATITUDINE_INIZIO_TR,  ';
   --
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) > 0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 2), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End LONGITUDINE_INIZIO_TR, ';
   --
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) > 0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, '||Nvl(To_Char( p_versione), 'Null')||', 1), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null  End LATITUDINE_FINE_TR, ';
   --
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) > 0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, '||Nvl(To_Char( p_versione), 'Null')||', 2), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End LONGITUDINE_FINE_TR, ';
   --
   sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
   --sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) then ';
   --sqlstringa := sqlstringa || ' '' Km Inizio: ''||t.KM_INIZIO|| '' - Lat\Lon Inizio: '' ';
   --sqlstringa := sqlstringa ||' ||Trunc(Nvl(Trim(LATITUDINE_INIZIO),  PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 1) ), 5) ||''\'' ';
   --sqlstringa := sqlstringa ||' ||Trunc(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 2) ), 5) ';
   --sqlstringa := sqlstringa ||' ||'' - Km Fine: '' ||t.KM_FINE|| '' - Lat\Lon Fine: '' ';
   --sqlstringa := sqlstringa ||' ||Trunc(Nvl(Trim(LATITUDINE_FINE),  PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, '||Nvl(To_Char( p_versione), 'Null')||', 1) ), 5)||''\'' ';
   --sqlstringa := sqlstringa ||' ||Trunc(Nvl(Trim(LONGITUDINE_FINE), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, '||Nvl(To_Char( p_versione), 'Null')||', 2) ), 5) ';
   --sqlstringa := sqlstringa || ' '' Km Inizio: ''||t.KM_INIZIO||'' - Km Fine: '' ||t.KM_FINE';
   --sqlstringa := sqlstringa || ' Null ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   --
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
   --
   --sqlstringa := sqlstringa || ' '' Km Inizio: '' ||greatest( least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO)|| '' - Lat\Lon Inizio: '' ';
   --sqlstringa := sqlstringa || ' ||Trunc(Nvl(Trim(LATITUDINE_INIZIO),  PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest(Least(Nvl(b.KM_INIZIO, 0), Nvl(b.KM_FINE, 0)),  t.KM_INIZIO),  '||Nvl(To_Char( p_versione), 'Null')||',1) ), 5) ||''\'' ';
   --sqlstringa := sqlstringa || ' ||Trunc(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest(Least(Nvl(b.KM_INIZIO, 0), Nvl(b.KM_FINE, 0)),  t.KM_INIZIO), '||Nvl(To_Char( p_versione), 'Null')||', 2) ), 5)  ';
   --sqlstringa := sqlstringa || ' ||'' - Km Fine: ''||least( Nvl(b.KM_FINE, 0), t.KM_FINE)||'' - Lat\Lon Fine: '' ';
   --sqlstringa := sqlstringa || ' ||Trunc(Nvl(Trim(LATITUDINE_FINE),  PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least(Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), '||Nvl(To_Char( p_versione), 'Null')||', 1) ),5)||''\'' ';
   --sqlstringa := sqlstringa || ' ||Trunc(Nvl(Trim(LONGITUDINE_FINE), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least(Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), '||Nvl(To_Char( p_versione), 'Null')||', 2) ),5) ';
   sqlstringa := sqlstringa || ' '' Km Inizio: '' ||Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE, 0)),  t.KM_INIZIO)||'' - Km Fine: ''||Least( Greatest(Nvl(b.KM_FINE, 0), Nvl(b.KM_INIZIO, 0)), t.KM_FINE)';
   --
   sqlstringa := sqlstringa || '  Else    Null     End Else    Null     End LABEL ';
   --
   -- --------------------------- join tra tabelle --------------------------------
   sqlstringa := sqlstringa || ' From  ';
   sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, SOL_TRACK_1_1_1_1_1_1O2_AP, SOL_TRACK_1_1_1_1_1_1O2, KM_INIZIO, KM_FINE, ';
   sqlstringa := sqlstringa || ' Trunc(LATITUDINE_INIZIO, 5) LATITUDINE_INIZIO, Trunc(LONGITUDINE_INIZIO, 5) LONGITUDINE_INIZIO,  ';
   sqlstringa := sqlstringa || ' Trunc(LATITUDINE_FINE, 5) LATITUDINE_FINE, Trunc(LONGITUDINE_FINE, 5) LONGITUDINE_FINE, ';
   sqlstringa := sqlstringa || ' '' Km Inizio: ''||KM_INIZIO||'' - Lat\Lon Inizio: ''||Trunc(LATITUDINE_INIZIO, 5)||''\''||Trunc(LONGITUDINE_INIZIO, 5)|| '' - Km Fine: ''||KM_FINE|| '' - Lat\Lon Fine: ''||Trunc(LATITUDINE_FINE,5)||''\''||Trunc(LONGITUDINE_FINE,5) LABEL ';  --'
   sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
   sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EI''';
   sqlstringa := sqlstringa || ' And KM_INIZIO Is Not Null  ';
   sqlstringa := sqlstringa || ' And LONGITUDINE_INIZIO Is Not Null ';
   sqlstringa := sqlstringa || ' And LATITUDINE_INIZIO Is Not Null ';
   sqlstringa := sqlstringa || ' And LONGITUDINE_INIZIO Is Not Null ';
   sqlstringa := sqlstringa || ' And KM_FINE Is Not Null ';
   sqlstringa := sqlstringa || ' And LATITUDINE_FINE Is Not Null ';
   sqlstringa := sqlstringa || ' And LONGITUDINE_FINE Is Not Null ';
   If p_versione Is Not Null Then
           sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstringa := sqlstringa || ' UNION ';
   sqlstringa := sqlstringa || 'Select SOL_TRACK_1_1_1_0_0_1, SOL_TRACK_1_1_1_1_1_1O2_AP, SOL_TRACK_1_1_1_1_1_1O2, Null KM_INIZIO, Null KM_FINE, ';
   sqlstringa := sqlstringa || ' Null LATITUDINE_INIZIO, Null LONGITUDINE_INIZIO, Null LATITUDINE_FINE, Null LONGITUDINE_FINE, ';
   sqlstringa := sqlstringa || ' Null LABEL ';
   sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
   sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EI''';
   sqlstringa := sqlstringa || ' And ( KM_INIZIO Is  Null ';
   sqlstringa := sqlstringa || ' Or LATITUDINE_INIZIO Is Null ';
   sqlstringa := sqlstringa || ' Or LONGITUDINE_INIZIO Is Null  ';
   sqlstringa := sqlstringa || ' Or KM_FINE Is Null ';
   sqlstringa := sqlstringa || ' Or LATITUDINE_FINE Is Null ';
   sqlstringa := sqlstringa || ' Or LONGITUDINE_FINE Is Null ) ';
   If p_versione Is Not Null Then
            sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstringa := sqlstringa || ') b,                 ';
   sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_SOL s, ';
   sqlstringa := sqlstringa || ' (Select SEDE_TECNICA, KM_INIZIO, KM_FINE ';
   sqlstringa := sqlstringa || ' From '|| s_schema||'.SEZIONI_LINEA ';
   If p_versione Is Not Null Then
           sqlstringa := sqlstringa || ' Where CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstringa := sqlstringa || ' ) t ';
   sqlstringa := sqlstringa || ' Where s.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 (+) ';
   sqlstringa := sqlstringa || ' And s.SOL_TRACK_1_1_1_0_0_1 = '''||p_Track||''''  ;
   sqlstringa := sqlstringa || ' And s.SEDE_TECNICA = t.SEDE_TECNICA ';
   If p_versione Is Not Null Then
           sqlstringa := sqlstringa || ' And CODICE_VERSIONE ='||p_versione;
   End If;
   sqlstringa := sqlstringa || 'Order By 3, 5, 6 ';
 -- -------------------------------------------------------------------------------------------------
--
-- Dbms_Output.Put_Line(sqlstringa);
--
   Open p_cursor For sqlstringa;
--
 End GetTracks_Inf_EC;
--
-- --------------------------------------------------------------------------------------------------
--                    GetTracks_Energy_EC
-- Ritorna l''elenco delle dichiarazioni di verifica EC e EI della vista Energia  di un Binario di Corsa di una SOL
-- --------------------------------------------------------------------------------------------------
 Procedure GetTracks_Energy_EC (p_Track Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur) Is
   s_schema   Varchar2(100);
--   sqlstringa Varchar2(20000);
   sqlstringa   CLOB;            
--
   p_versione Number;
 BEGIN
   S_SCHEMA   := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
   P_VERSIONE := P_I_VERSIONE;

   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
        P_VERSIONE := GetLastVersion(P_AREA);
   End If;
--
-- ------------------------------------------ EC ---------------------------------------------------
   sqlstringa := 'Select DISTINCT s.SOL_TRACK_1_1_1_0_0_1 Track_ID, ';
   sqlstringa := sqlstringa || Nvl(To_Char( p_versione),'Null')||' CODICE_VERSIONE, ';
   sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione, ';
   sqlstringa := sqlstringa || 'Nvl(SOL_TRACK_1_1_1_2_1_1O2_AP,'''||PKG_RINF_DATA_V777.GetNYA('1.1.1.2.1.1')||''') SOL_TRACK_1_1_1_2_1_1O2_AP, ';
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 ) Then  SOL_TRACK_1_1_1_2_1_1O2  Else ''00/00000000000000/0000/000000'' END SOL_TRACK_1_1_1_2_1_1O2, ';
-->
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 and b.KM_FINE >0) then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Greatest( Least(Nvl(b.KM_INIZIO, 0), Nvl(b.KM_FINE, 0)), t.KM_INIZIO), ''9990.99999''))  Else  Null End Else  Null  End KM_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 and b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE between t.KM_INIZIO and t.KM_FINE )) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), ''9990.99999'')) Else  Null End Else  Null End  KM_FINE, ';
   --
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), '||Nvl(To_Char( p_versione), 'Null')||', 1) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else  Null End Else Null  End  LATITUDINE_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), '||Nvl(To_Char( p_versione), 'Null')||', 2) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End Else  Null   End  LONGITUDINE_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO),t.KM_FINE), '||Nvl(To_Char( p_versione), 'Null')||', 1) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else  Null End  Else  Null  End LATITUDINE_FINE, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 and b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_FINE), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), '||Nvl(To_Char( p_versione), 'Null')||', 2) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null eNd Else Null End  LONGITUDINE_FINE, ';
--
   sqlstringa := sqlstringa || ' LTrim(To_Char(t.KM_INIZIO,''9990.99999'')) KM_INIZIO_TR, LTrim(To_Char(t.KM_FINE,''9990.99999'')) KM_FINE_TR, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 1), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End LATITUDINE_INIZIO_TR,  ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 2), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End LONGITUDINE_INIZIO_TR, ';
--
   sqlstringa := sqlstringa || ' CASE  WHEN (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE, '||Nvl(To_Char( p_versione), 'Null')||', 1), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null  End LATITUDINE_FINE_TR, ';
--
   sqlstringa := sqlstringa || ' CASE  WHEN (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE, '||Nvl(To_Char( p_versione), 'Null')||', 2), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End LONGITUDINE_FINE_TR, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
--
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' '' Km Inizio: '' ||Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO)||'' - Km Fine: ''||Least( Greatest(Nvl(b.KM_FINE,0), Nvl(b.KM_INIZIO,0)), t.KM_FINE)';

   sqlstringa := sqlstringa || '  Else  Null  End Else   Null   End LABEL ';
-- --------------------------- join tra tabelle --------------------------------
   sqlstringa := sqlstringa || 'From   ';
   sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1,SOL_TRACK_1_1_1_2_1_1O2_AP,SOL_TRACK_1_1_1_2_1_1O2,KM_INIZIO,KM_FINE ';

   sqlstringa := sqlstringa || ' , Trunc(LATITUDINE_INIZIO,5) LATITUDINE_INIZIO,  Trunc(LONGITUDINE_INIZIO,5) LONGITUDINE_INIZIO, ';
   sqlstringa := sqlstringa || ' Trunc(LATITUDINE_FINE,5)  LATITUDINE_FINE, Trunc(LONGITUDINE_FINE,5) LONGITUDINE_FINE, ';
   sqlstringa := sqlstringa || ' '' Km Inizio: ''||KM_INIZIO||'' - Lat\Lon Inizio: ''||Trunc(LATITUDINE_INIZIO,5)||''\''||Trunc(LONGITUDINE_INIZIO,5)|| '' - Km Fine: ''||KM_FINE|| '' - Lat\Lon Fine: ''||Trunc(LATITUDINE_FINE,5)||''\''||Trunc(LONGITUDINE_FINE,5) LABEL ';
--'
   sqlstringa := sqlstringa || 'From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
   sqlstringa := sqlstringa || 'Where tipo_dichiarazione=''EC''';
   sqlstringa := sqlstringa || ' AND KM_INIZIO Is Not Null            ';
   sqlstringa := sqlstringa || ' AND LONGITUDINE_INIZIO Is Not Null   ';
   sqlstringa := sqlstringa || ' AND LATITUDINE_INIZIO Is Not Null    ';
   sqlstringa := sqlstringa || ' AND KM_FINE Is Not Null              ';
   sqlstringa := sqlstringa || ' AND LATITUDINE_FINE Is Not Null      ';
   sqlstringa := sqlstringa || ' AND LONGITUDINE_FINE Is Not Null     ';

   IF p_versione Is Not Null Then
          sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
   End If;

   sqlstringa := sqlstringa || ' UNION ';
   sqlstringa := sqlstringa || 'Select SOL_TRACK_1_1_1_0_0_1, SOL_TRACK_1_1_1_2_1_1O2_AP, SOL_TRACK_1_1_1_2_1_1O2, KM_INIZIO, KM_FINE   ';
   --05/02/2018 LAM da decommentare
   sqlstringa := sqlstringa || ' , Null LATITUDINE_INIZIO, Null LONGITUDINE_INIZIO, Null LATITUDINE_FINE, Null LONGITUDINE_FINE, Null LABEL ';
   sqlstringa := sqlstringa || 'From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
   sqlstringa := sqlstringa || 'Where tipo_dichiarazione=''EC''';
   sqlstringa := sqlstringa || 'AND ( KM_INIZIO IS  Null        ';
   sqlstringa := sqlstringa || ' OR LATITUDINE_INIZIO IS  Null     ';
   sqlstringa := sqlstringa || ' OR LONGITUDINE_INIZIO IS  Null    ';
   sqlstringa := sqlstringa || ' OR KM_FINE IS  Null               ';
   sqlstringa := sqlstringa || ' OR LATITUDINE_FINE IS  Null       ';
   sqlstringa := sqlstringa || ' OR LONGITUDINE_FINE  IS  Null )   ';

   IF p_versione Is Not Null Then
          sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
   End If;

   sqlstringa := sqlstringa || ') b,                 ';
   sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_SOL s,            ';
   sqlstringa := sqlstringa || '(Select SEDE_TECNICA, KM_INIZIO, KM_FINE ';
   sqlstringa := sqlstringa || 'From '||  s_schema||'.SEZIONI_LINEA ';

   IF p_versione Is Not Null Then
          sqlstringa := sqlstringa || 'Where CODICE_VERSIONE='||p_versione;
   End If;

   sqlstringa := sqlstringa || ' ) t ';
   sqlstringa := sqlstringa || 'Where s.SOL_TRACK_1_1_1_0_0_1=b.SOL_TRACK_1_1_1_0_0_1 (+) and ';
   sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1='''||p_Track||''''  ;
   sqlstringa := sqlstringa || ' AND s.SEDE_TECNICA = t.SEDE_TECNICA ';

   IF p_versione Is Not Null Then
           sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
   End If;

-- ------------------------------------- EI ------------------------------------
   sqlstringa := sqlstringa || ' UNION                                                   ';
   sqlstringa := sqlstringa || 'Select DISTINCT s.SOL_TRACK_1_1_1_0_0_1 Track_ID,  ';
   sqlstringa := sqlstringa || Nvl(To_Char( p_versione),'Null')||' CODICE_VERSIONE,      ';
   sqlstringa := sqlstringa || '''EI'' tipo_dichiarazione,   ';
   sqlstringa := sqlstringa || 'Nvl(SOL_TRACK_1_1_1_2_1_1O2_AP,'''||PKG_RINF_DATA_V777.GetNYA('1.1.1.2.1.1')||''') SOL_TRACK_1_1_1_2_1_1O2_AP, ';

   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 ) Then  SOL_TRACK_1_1_1_2_1_1O2  Else ''00/00000000000000/0000/000000'' END SOL_TRACK_1_1_1_2_1_1O2, ';
-->
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 and b.KM_FINE >0) then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Greatest( Least(Nvl(b.KM_INIZIO, 0), Nvl(b.KM_FINE, 0)), t.KM_INIZIO), ''9990.99999''))  Else  Null End Else  Null  End KM_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 and b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE between t.KM_INIZIO and t.KM_FINE )) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), ''9990.99999'')) Else  Null End Else  Null End  KM_FINE, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), '||Nvl(To_Char( p_versione), 'Null')||', 1) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else  Null End Else Null  End  LATITUDINE_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), '||Nvl(To_Char( p_versione), 'Null')||', 2) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End Else  Null   End  LONGITUDINE_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO),t.KM_FINE), '||Nvl(To_Char( p_versione), 'Null')||', 1) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else  Null End  Else  Null  End LATITUDINE_FINE, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 and b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_FINE), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE),'||Nvl(To_Char( p_versione), 'Null')||',  2) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null eNd Else Null End  LONGITUDINE_FINE, ';
--
   sqlstringa := sqlstringa || ' LTrim(To_Char(t.KM_INIZIO,''9990.99999'')) KM_INIZIO_TR, LTrim(To_Char(t.KM_FINE,''9990.99999'')) KM_FINE_TR, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 1), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End LATITUDINE_INIZIO_TR,  ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 2), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End LONGITUDINE_INIZIO_TR, ';
--
   sqlstringa := sqlstringa || ' CASE  WHEN (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE, '||Nvl(To_Char( p_versione), 'Null')||', 1), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null  End LATITUDINE_FINE_TR, ';
--
   sqlstringa := sqlstringa || ' CASE  WHEN (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE, '||Nvl(To_Char( p_versione), 'Null')||', 2), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End LONGITUDINE_FINE_TR, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
--
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' '' Km Inizio: '' ||Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO)||'' - Km Fine: ''||Least( Greatest(Nvl(b.KM_FINE,0), Nvl(b.KM_INIZIO,0)), t.KM_FINE)';
   sqlstringa := sqlstringa || '  Else  Null  End Else   Null   End LABEL ';

-- --------------------------- join tra tabelle -------------------------------- 
   sqlstringa := sqlstringa || 'From        ';
   sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1,SOL_TRACK_1_1_1_2_1_1O2_AP,SOL_TRACK_1_1_1_2_1_1O2,KM_INIZIO,KM_FINE   ';
   sqlstringa := sqlstringa || ' , Trunc(LATITUDINE_INIZIO,5) LATITUDINE_INIZIO,  Trunc(LONGITUDINE_INIZIO,5) LONGITUDINE_INIZIO,  ';
   sqlstringa := sqlstringa || ' Trunc(LATITUDINE_FINE,5)  LATITUDINE_FINE, Trunc(LONGITUDINE_FINE,5) LONGITUDINE_FINE, ';
   sqlstringa := sqlstringa || ' '' Km Inizio: ''||KM_INIZIO||'' - Lat\Lon Inizio: ''||Trunc(LATITUDINE_INIZIO,5)||''\''||Trunc(LONGITUDINE_INIZIO,5)|| '' - Km Fine: ''||KM_FINE|| '' - Lat\Lon Fine: ''||Trunc(LATITUDINE_FINE,5)||''\''||Trunc(LONGITUDINE_FINE,5) LABEL ';
--'   
   sqlstringa := sqlstringa || 'From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
   sqlstringa := sqlstringa || 'Where tipo_dichiarazione=''EI''';
   sqlstringa := sqlstringa || ' AND KM_INIZIO Is Not Null            ';
   sqlstringa := sqlstringa || ' AND LONGITUDINE_INIZIO Is Not Null   ';
   sqlstringa := sqlstringa || ' AND LATITUDINE_INIZIO Is Not Null    ';
   sqlstringa := sqlstringa || ' AND KM_FINE Is Not Null              ';
   sqlstringa := sqlstringa || ' AND LATITUDINE_FINE Is Not Null      ';
   sqlstringa := sqlstringa || ' AND LONGITUDINE_FINE Is Not Null     ';

   IF p_versione Is Not Null THEN
           sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
   END IF;

   sqlstringa := sqlstringa || ' UNION ';
   sqlstringa := sqlstringa || 'Select SOL_TRACK_1_1_1_0_0_1, SOL_TRACK_1_1_1_2_1_1O2_AP, SOL_TRACK_1_1_1_2_1_1O2, KM_INIZIO, KM_FINE   ';
   sqlstringa := sqlstringa || ' , Null LATITUDINE_INIZIO, Null LONGITUDINE_INIZIO, Null LATITUDINE_FINE, Null LONGITUDINE_FINE, Null LABEL ';
   sqlstringa := sqlstringa || 'From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
   sqlstringa := sqlstringa || 'Where tipo_dichiarazione=''EI''';
   sqlstringa := sqlstringa || 'AND ( KM_INIZIO IS  Null        ';
   sqlstringa := sqlstringa || ' OR LATITUDINE_INIZIO IS  Null     ';
   sqlstringa := sqlstringa || ' OR LONGITUDINE_INIZIO IS  Null    ';
   sqlstringa := sqlstringa || ' OR KM_FINE IS  Null               ';
   sqlstringa := sqlstringa || ' OR LATITUDINE_FINE IS  Null       ';
   sqlstringa := sqlstringa || ' OR LONGITUDINE_FINE  IS  Null )   ';

   IF p_versione Is Not Null THEN
           sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
   END IF;

   sqlstringa := sqlstringa || ') b,                 ';
   sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_SOL s ,            ';
   sqlstringa := sqlstringa || '(Select SEDE_TECNICA, KM_INIZIO, KM_FINE ';
   sqlstringa := sqlstringa || 'From '||  s_schema||'.SEZIONI_LINEA ';

   IF p_versione Is Not Null THEN
          sqlstringa := sqlstringa || 'Where CODICE_VERSIONE='||p_versione;
   END IF;

   sqlstringa := sqlstringa || ' ) t ';
   sqlstringa := sqlstringa || 'Where s.SOL_TRACK_1_1_1_0_0_1=b.SOL_TRACK_1_1_1_0_0_1 (+) and ';
   sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1='''||p_Track||''''  ;
   sqlstringa := sqlstringa || ' AND s.SEDE_TECNICA = t.SEDE_TECNICA ';

   IF p_versione Is Not Null THEN
       sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
   END IF;
   sqlstringa := sqlstringa || 'Order By 3,5,6 ';

-- Dbms_Output.Put_Line(sqlstringa);
   Open p_cursor For sqlstringa;
 End GetTracks_Energy_EC;
-- ---------------------------------------------------------------------------------------------------------------------
--                                    GetTracks_Control_EC
--  Ritorna l'elenco delle dichiarazioni di verifica EC e EI della vista Controllo di un Binario di Corsa di una SOL
-- ---------------------------------------------------------------------------------------------------------------------
 Procedure GetTracks_Control_EC (p_Track Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur) Is
   s_schema   Varchar2(100);
-- sqlstringa Varchar2(20000);
   sqlstringa   CLOB;            
--
   p_versione Number;
 BEGIN
   S_SCHEMA   := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
   P_VERSIONE := P_I_VERSIONE;

   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
        P_VERSIONE := GetLastVersion(P_AREA);
   End If;

-- -----------------------------------------  EC  --------------------------------------------------
   sqlstringa :=  'Select DISTINCT s.SOL_TRACK_1_1_1_0_0_1 Track_ID, ';
   sqlstringa := sqlstringa || Nvl(To_Char( p_versione),'Null')||' CODICE_VERSIONE,  ';
   sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione, ';
   sqlstringa := sqlstringa || ' Nvl(SOL_TRACK_1_1_1_3_1_1_AP,'''||PKG_RINF_DATA_V777.GetNYA('1.1.1.3.1.1')||''') SOL_TRACK_1_1_1_3_1_1_AP, ';
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 ) Then SOL_TRACK_1_1_1_3_1_1  Else ''00/00000000000000/0000/000000'' End SOL_TRACK_1_1_1_3_1_1, ';
-->
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 and b.KM_INIZIO >= 0 and b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)), t.KM_INIZIO),''9990.99999'')) Else  Null End Else  Null  End KM_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 and b.KM_INIZIO >= 0 and b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE),''9990.99999'')) Else  Null End Else  Null End  KM_FINE, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), '||Nvl(To_Char( p_versione), 'Null')||', 1) ), ''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else  Null End Else Null  End  LATITUDINE_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), '||Nvl(To_Char( p_versione), 'Null')||', 2) ),''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End Else  Null   End  LONGITUDINE_INIZIO, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE,b.KM_INIZIO),t.KM_FINE), '||Nvl(To_Char( p_versione), 'Null')||', 1) ),''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else  Null End  Else  Null  End LATITUDINE_FINE, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 And b.KM_INIZIO >= 0 and b.KM_FINE >0) Then ';
   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE between t.KM_INIZIO and t.KM_FINE )) Then  ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_DATA_V777.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), '||Nvl(To_Char( p_versione), 'Null')||', 2) ),''9990.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null End Else Null End  LONGITUDINE_FINE, ';
--
   sqlstringa := sqlstringa || ' LTrim(To_Char(t.KM_INIZIO,''9990.99999'')) KM_INIZIO_TR, LTrim(To_Char(t.KM_FINE,''9990.99999'')) KM_FINE_TR, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 1), ''9900.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null  End  LATITUDINE_INIZIO_TR, ';
--
   sqlstringa := sqlstringa || 'Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0) Then ';
   sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, '||Nvl(To_Char( p_versione), 'Null')||', 2), ''9900.99999'')) ';
   sqlstringa := sqlstringa || ' Else Null   End  LONGITUDINE_INIZIO_TR, ';
--
   sqlstringa := sqlstringa || 'Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0) Then ';
   sqlstringa := sqlstringa || 'LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE, '||Nvl(To_Char( p_versione), 'Null')||', 1), ''9900.99999'')) ';
   sqlstringa := sqlstringa || 'Else Null  End LATITUDINE_FINE_TR, ';
--
   sqlstringa := sqlstringa || 'CASE  WHEN (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0) Then ';
   sqlstringa := sqlstringa || 'LTrim(To_Char(PKG_RINF_DATA_V777.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE, '||Nvl(To_Char( p_versione), 'Null')||', 2), ''9900.99999'')) ';
   sqlstringa := sqlstringa || 'Else  Null End  LONGITUDINE_FINE_TR, ';
--
   sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) then ';

   sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then Null ';
   sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
--
   sqlstringa := sqlstringa || ' '' Km Inizio: '' ||Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO)||'' - Km Fine: ''||Least( Greatest(Nvl(b.KM_FINE,0), Nvl(b.KM_INIZIO,0)), t.KM_FINE)';
--
   sqlstringa := sqlstringa || '  Else    Null     End Else    Null     End LABEL ';
-- --------------------------- join tra tabelle ----------------------------------------------------
   sqlstringa := sqlstringa || 'From        ';
   sqlstringa := sqlstringa || '(Select SOL_TRACK_1_1_1_0_0_1, SOL_TRACK_1_1_1_3_1_1_AP, SOL_TRACK_1_1_1_3_1_1, KM_INIZIO, KM_FINE, ';
   sqlstringa := sqlstringa || ' Trunc(LATITUDINE_INIZIO, 5) LATITUDINE_INIZIO,  Trunc(LONGITUDINE_INIZIO, 5) LONGITUDINE_INIZIO, ';
   sqlstringa := sqlstringa || ' Trunc(LATITUDINE_FINE, 5)  LATITUDINE_FINE, Trunc(LONGITUDINE_FINE, 5) LONGITUDINE_FINE, ';
   sqlstringa := sqlstringa || ' '' Km Inizio: ''||KM_INIZIO||'' - Lat\Lon Inizio: ''||Trunc(LATITUDINE_INIZIO, 5)||''\''||Trunc(LONGITUDINE_INIZIO, 5)|| '' - Km Fine: ''||KM_FINE|| '' - Lat\Lon Fine: ''||Trunc(LATITUDINE_FINE, 5)||''\''||Trunc(LONGITUDINE_FINE,5) LABEL ';
-- '
   sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS ';
   sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EC''';
   sqlstringa := sqlstringa || ' AND KM_INIZIO Is Not Null ';
   sqlstringa := sqlstringa || ' AND LONGITUDINE_INIZIO Is Not Null ';
   sqlstringa := sqlstringa || ' AND LATITUDINE_INIZIO Is Not Null ';
   sqlstringa := sqlstringa || ' AND KM_FINE Is Not Null ';
   sqlstringa := sqlstringa || ' AND LATITUDINE_FINE Is Not Null ';
   sqlstringa := sqlstringa || ' AND LONGITUDINE_FINE Is Not Null ';
   If p_versione Is Not Null Then
          sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
   End If;
--
   sqlstringa := sqlstringa || ' UNION ';
   sqlstringa := sqlstringa || ' Select SOL_TRACK_1_1_1_0_0_1, SOL_TRACK_1_1_1_3_1_1_AP, SOL_TRACK_1_1_1_3_1_1, KM_INIZIO, KM_FINE   ';
   sqlstringa := sqlstringa || ' , Null LATITUDINE_INIZIO, Null LONGITUDINE_INIZIO, Null LATITUDINE_FINE, Null LONGITUDINE_FINE, Null LABEL ';
   sqlstringa := sqlstringa || 'From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS ';
   sqlstringa := sqlstringa || 'Where TIPO_DICHIARAZIONE = ''EC''';
   sqlstringa := sqlstringa || 'And ( KM_INIZIO Is Null ';
   sqlstringa := sqlstringa || ' Or  LATITUDINE_INIZIO Is Null  ';
   sqlstringa := sqlstringa || ' Or  LONGITUDINE_INIZIO Is Null ';
   sqlstringa := sqlstringa || ' Or  KM_FINE Is Null ';
   sqlstringa := sqlstringa || ' Or  LATITUDINE_FINE Is Null  ';
   sqlstringa := sqlstringa || ' Or  LONGITUDINE_FINE Is Null )   ';
--
   If p_versione Is Not Null Then
           sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
   End If;
--
   sqlstringa := sqlstringa || ') b,                 ';
   sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_SOL s ,            ';
   sqlstringa := sqlstringa || '(Select SEDE_TECNICA, KM_INIZIO, KM_FINE ';
   sqlstringa := sqlstringa || ' From '||  s_schema||'.SEZIONI_LINEA ';
   If p_versione Is Not Null Then
           sqlstringa := sqlstringa ||' Where CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstringa := sqlstringa || ' ) t ';
   sqlstringa := sqlstringa || ' Where s.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 (+) ';
   sqlstringa := sqlstringa || ' And s.SOL_TRACK_1_1_1_0_0_1 = '''||p_Track||''''  ;
   sqlstringa := sqlstringa || ' And s.SEDE_TECNICA = t.SEDE_TECNICA ';
--
   IF p_versione Is Not Null THEN
           sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
   END IF;
--
-- sqlstringa := sqlstringa || 'Order By SOL_TRACK_1_1_1_3_1_1, TIPO_DICHIARAZIONE, KM_INIZIO';
   sqlstringa := sqlstringa || ' Order By 3,5,6';
--
-- Dbms_Output.Put_Line(sqlstringa);
   --
   Open p_cursor For sqlstringa;
--
End GetTracks_Control_EC;
--
-- -----------------------------------------------------------------------------
--                            GetTracks_Inf_Tunnel
-- 1.1.1.1.8 - Tunnel
-- Ritorna l'elenco delle gallerie di un Binario di Corsa di una SOL, con relativi parametri
-- -----------------------------------------------------------------------------
 Procedure GetTracks_Inf_Tunnel (p_Track Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur) Is
--
  s_schema   Varchar2(100);
--  sqlstringa Varchar2(10000);
   sqlstringa   CLOB;            
--
  P_VERSIONE Number;
--->
   Data_Validita Date;
 BEGIN
   S_SCHEMA   := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
   P_VERSIONE := P_I_VERSIONE;

   If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
        P_VERSIONE := GetLastVersion(P_AREA);
   End If;
 --->
 -- ------------------------------------------------------------------------------------------------
-- gestione della data di inizio e fine validità per il parametro	 
-- ------------------------------------------------------------------------------------------------
--
   If P_VERSIONE Is Not Null Then  
      Select Greatest(DATA_PUBBLICAZIONE, DATA_RIFERIMENTO) 
  	    Into Data_Validita 
        From RINF_PUBBLICATI_EVO.VERSIONE_RINF
       Where CODICE_VERSIONE = P_VERSIONE;
   Else
       Select Greatest(DATA_CONTROLLO, DATA_RIFERIMENTO) 
  	     Into Data_Validita 
         From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI
        Where CODICE_CONTROLLO =(Select Max (CODICE_CONTROLLO) From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI);
   End If;
--
   sqlstringa :=  'Select Distinct r.SOL_TRACK_1_1_1_0_0_1 Track_ID, ';
   sqlstringa := sqlstringa ||  Nvl(To_Char(p_versione), 'Null')||' CODICE_VERSIONE, ';
-- 1.1.1.1.8.1 - SOLTunnelIMCode
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.1.1.8.1'', SOL_TUNNEL_1_1_1_1_8_1) SOL_TUNNEL_1_1_1_1_8_1_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.1.1.8.1'', SOL_TUNNEL_1_1_1_1_8_1) SOL_TUNNEL_1_1_1_1_8_1_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.1'', SOL_TUNNEL_1_1_1_1_8_1) SOL_TUNNEL_1_1_1_1_8_1_DES, ';
   sqlstringa := sqlstringa || ' Nvl(SOL_TUNNEL_1_1_1_1_8_1, ''0083'') SOL_TUNNEL_1_1_1_1_8_1,  ';
-- 1.1.1.1.8.2 - SOLTunnelIdentification
   sqlstringa := sqlstringa || ' g.SOL_TUNNEL_1_1_1_1_8_2 SOL_TUNNEL_1_1_1_1_8_2, ';
   sqlstringa := sqlstringa || ' g.SOL_TUNNEL_1_1_1_1_8_2_D SOL_TUNNEL_1_1_1_1_8_2_DES, ';
-- 1.1.1.1.8.3 - SOLTunnelStart
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_3_AP, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_3, ';
--1.1.1.1.8.4- SOLTunnelEnd
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_4_AP, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_4, ';
-- 1.1.1.1.8.7 - ITU_Length
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_7_AP, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_7, ';
-- 1.1.1.1.8.8 - ITU_CrossSectionArea
--   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_8_AP, ';
   sqlstringa := sqlstringa || ' Nvl(r.SOL_TUNNEL_1_1_1_1_8_8_AP, g.SOL_TUNNEL_1_1_1_1_8_8_AP) SOL_TUNNEL_1_1_1_1_8_8_AP, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_8, ';
--   sqlstringa := sqlstringa || ' Case When (r.SOL_TUNNEL_1_1_1_1_8_8_AP = ''N'' and SOL_TUNNEL_1_1_1_1_8_8 > 0 ) Then Null End SOL_TUNNEL_1_1_1_1_8_8, ';

   sqlstringa := sqlstringa || ' GetData_Validita(''1.1.1.1.8.8'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''', ''dd/mm/yyyy'')) Flag_1_1_1_1_8_8, ';

--> 1.1.1.1.8.8.1 - ITU_TSITunnel (Nuovo parametro Reg.2019/777)
--   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_8_1_AP, ';
   sqlstringa := sqlstringa || ' Nvl(r.SOL_TUNNEL_1_1_1_1_8_8_1_AP, g.SOL_TUNNEL_1_1_1_1_8_8_1_AP) SOL_TUNNEL_1_1_1_1_8_8_1_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.1.1.8.8.1'', SOL_TUNNEL_1_1_1_1_8_8_1) SOL_TUNNEL_1_1_1_1_8_8_1_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.1.1.8.8.1'', SOL_TUNNEL_1_1_1_1_8_8_1) SOL_TUNNEL_1_1_1_1_8_8_1_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.8.1'', SOL_TUNNEL_1_1_1_1_8_8_1) SOL_TUNNEL_1_1_1_1_8_8_1_DES, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_8_1, GetData_Validita(''1.1.1.1.8.8.1'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''', ''dd/mm/yyyy'')) Flag_1_1_1_1_8_8_1, ';
   sqlstringa := sqlstringa || ' GetPar_attivo(''1.1.1.1.8.8.1'') Flag_1_1_1_1_8_8_1_AT, '; --> Nuovo attributo
--> 1.1.1.1.8.8.2 - ITU_TunnelDocRef (Nuovo parametro Reg.2019/777) - AP (Intera Rete) = N - Valore = []
   sqlstringa := sqlstringa || ' Nvl(r.SOL_TUNNEL_1_1_1_1_8_8_1_AP, g.SOL_TUNNEL_1_1_1_1_8_8_1_AP) SOL_TUNNEL_1_1_1_1_8_8_1_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.1.1.8.8.2'', SOL_TUNNEL_1_1_1_1_8_8_2) SOL_TUNNEL_1_1_1_1_8_8_2_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.1.1.8.8.2'', SOL_TUNNEL_1_1_1_1_8_8_2) SOL_TUNNEL_1_1_1_1_8_8_2_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.8.2'', SOL_TUNNEL_1_1_1_1_8_8_2) SOL_TUNNEL_1_1_1_1_8_8_2_DES, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_8_2, GetData_Validita(''1.1.1.1.8.8.2'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''', ''dd/mm/yyyy'')) Flag_1_1_1_1_8_8_2, ';
   sqlstringa := sqlstringa || ' GetPar_attivo(''1.1.1.1.8.8.2'') Flag_1_1_1_1_8_8_2_AT, '; --> Nuovo attributo
--/>1.1.1.1.8.9 - ITU_EmergencyPlan (Parametro MODIFICATO dal Reg.2019/777)
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_9_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.1.1.8.9'', SOL_TUNNEL_1_1_1_1_8_9) SOL_TUNNEL_1_1_1_1_8_9_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.1.1.8.9'', SOL_TUNNEL_1_1_1_1_8_9) SOL_TUNNEL_1_1_1_1_8_9_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.9'', SOL_TUNNEL_1_1_1_1_8_9) SOL_TUNNEL_1_1_1_1_8_9_DES, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_9, GetData_Validita(''1.1.1.1.8.9'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''', ''dd/mm/yyyy'')) Flag_1_1_1_1_8_9, ';
-- 1.1.1.1.8.10 - ITU_FireCatReq (Parametro MODIFICATO dal Reg.2019/777)
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_10_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.1.1.8.10'', SOL_TUNNEL_1_1_1_1_8_10) SOL_TUNNEL_1_1_1_1_8_10_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.1.1.8.10'', SOL_TUNNEL_1_1_1_1_8_10) SOL_TUNNEL_1_1_1_1_8_10_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.10'', SOL_TUNNEL_1_1_1_1_8_10) SOL_TUNNEL_1_1_1_1_8_10_DES, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_10, GetData_Validita(''1.1.1.1.8.10'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''', ''dd/mm/yyyy'')) Flag_1_1_1_1_8_10, ';
-- 1.1.1.1.8.11 - ITU_NatFireCatReq
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_11_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.1.1.8.11'', SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.1.1.8.11'', SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.11'', SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11_DES, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.11'', SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11, '; 
   sqlstringa := sqlstringa || ' GetData_Validita(''1.1.1.1.8.11'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''', ''dd/mm/yyyy'')) Flag_1_1_1_1_8_11 '; 
--
   sqlstringa := sqlstringa || ' From '||s_schema||'.GALLERIE_BINARI_SOL g, ';
   sqlstringa := sqlstringa || s_schema||'.REL_GALLERIE_BINARI_SOL r ';
   sqlstringa := sqlstringa || ' Where G.SOL_TUNNEL_1_1_1_1_8_2 = R.SOL_TUNNEL_1_1_1_1_8_2 ';
   sqlstringa := sqlstringa || ' And  r.SOL_TRACK_1_1_1_0_0_1 = '''||p_Track||''' ';
--  09/01/2017 Inserita la condizione che estrae i dati solo delle gallerie non diramate
   sqlstringa := sqlstringa || ' And G.SOL_TUNNEL_1_1_1_1_8_2 In (Select SOL_TUNNEL_1_1_1_1_8_2 From RINF_CONTROLLATI_EVO.GALLERIE_BINARI_SOL ';
   sqlstringa := sqlstringa || ' Minus ';
   sqlstringa := sqlstringa || ' Select SOL_TUNNEL_1_1_1_1_8_2 From RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE) ';
   If p_versione Is Not Null Then
      sqlstringa := sqlstringa || ' And g.CODICE_VERSIONE = '||p_versione;
      sqlstringa := sqlstringa || ' And r.CODICE_VERSIONE = '||p_versione;
   End If;
--  09/01/2017 I dati delle gallerie diramate vengono estratti dalla tabella RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE
   sqlstringa := sqlstringa || ' Union ';
   sqlstringa := sqlstringa || ' Select Distinct d.SOL_TRACK_1_1_1_0_0_1 Track_ID, ';
   sqlstringa := sqlstringa ||  Nvl(To_Char( p_versione),'Null')||' CODICE_VERSIONE, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.1.1.8.1'', SOL_TUNNEL_1_1_1_1_8_1) SOL_TUNNEL_1_1_1_1_8_1_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.1.1.8.1'', SOL_TUNNEL_1_1_1_1_8_1) SOL_TUNNEL_1_1_1_1_8_1_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.1'', SOL_TUNNEL_1_1_1_1_8_1) SOL_TUNNEL_1_1_1_1_8_1_DES, ';
   sqlstringa := sqlstringa || ' Nvl(SOL_TUNNEL_1_1_1_1_8_1, ''0083'') SOL_TUNNEL_1_1_1_1_8_1,   ';
   sqlstringa := sqlstringa || ' g.SOL_TUNNEL_1_1_1_1_8_2 SOL_TUNNEL_1_1_1_1_8_2, ';
   sqlstringa := sqlstringa || ' g.SOL_TUNNEL_1_1_1_1_8_2_D SOL_TUNNEL_1_1_1_1_8_2_DES, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_3_AP, ';
   sqlstringa := sqlstringa || ' ''Latitude (''|| Trim(To_Char(Trunc(LATITUDINE_ORIGINE,7),''999.9999999''))|| '') + Longitude (''|| Trim(To_Char(Trunc(LONGITUDINE_ORIGINE,7),''S999.9999999''))|| '') + km (''||Trim(To_Char(Trunc(KM_INIZIO,3),''9990.999''))||'')'' SOL_TUNNEL_1_1_1_1_8_3, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_4_AP, ';
   sqlstringa := sqlstringa || ' ''Latitude (''|| Trim(To_Char(Trunc(LATITUDINE_DESTINAZIONE,7),''999.9999999''))|| '') + Longitude (''|| Trim(To_Char(Trunc(LONGITUDINE_DESTINAZIONE,7),''S999.9999999''))|| '') + km (''||Trim(To_Char(Trunc(KM_DESTINAZIONE,3),''9990.999''))||'')'' SOL_TUNNEL_1_1_1_1_8_4, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_7_AP, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_7, ';
   sqlstringa := sqlstringa || ' Nvl(r.SOL_TUNNEL_1_1_1_1_8_8_AP, g.SOL_TUNNEL_1_1_1_1_8_8_AP) SOL_TUNNEL_1_1_1_1_8_8_AP, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_8,  GetData_Validita(''1.1.1.1.8.8'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_1_1_1_8_8, ';
--> Nuovo parametro Reg.2019/777
   sqlstringa := sqlstringa || ' Nvl(r.SOL_TUNNEL_1_1_1_1_8_8_1_AP, g.SOL_TUNNEL_1_1_1_1_8_8_1_AP) SOL_TUNNEL_1_1_1_1_8_8_1_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.1.1.8.8.1'', SOL_TUNNEL_1_1_1_1_8_8_1) SOL_TUNNEL_1_1_1_1_8_8_1_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.1.1.8.8.1'', SOL_TUNNEL_1_1_1_1_8_8_1) SOL_TUNNEL_1_1_1_1_8_8_1_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.8.1'', SOL_TUNNEL_1_1_1_1_8_8_1) SOL_TUNNEL_1_1_1_1_8_8_1_DES, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_8_1, GetData_Validita(''1.1.1.1.8.8.1'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''', ''dd/mm/yyyy'')) Flag_1_1_1_1_8_8_1, ';
   sqlstringa := sqlstringa || ' GetPar_attivo(''1.1.1.1.8.8.1'') Flag_1_1_1_1_8_8_1_AT, '; --> Nuovo attributo
--> Nuovo parametro Reg.2019/777
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_8_2_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.1.1.8.8.2'', SOL_TUNNEL_1_1_1_1_8_8_2) SOL_TUNNEL_1_1_1_1_8_8_2_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.1.1.8.8.2'', SOL_TUNNEL_1_1_1_1_8_8_2) SOL_TUNNEL_1_1_1_1_8_8_2_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.8.2'', SOL_TUNNEL_1_1_1_1_8_8_2) SOL_TUNNEL_1_1_1_1_8_8_2_DES, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_8_2, GetData_Validita(''1.1.1.1.8.8.2'', To_Date('''||To_Char(Data_Validita, 'dd/mm/yyyy')||''', ''dd/mm/yyyy'')) Flag_1_1_1_1_8_8_2, ';
   sqlstringa := sqlstringa || ' GetPar_attivo(''1.1.1.1.8.8.2'') Flag_1_1_1_1_8_8_2_AT, '; --> Nuovo attributo
--/>
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_9_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.1.1.8.9'', SOL_TUNNEL_1_1_1_1_8_9) SOL_TUNNEL_1_1_1_1_8_9_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.1.1.8.9'', SOL_TUNNEL_1_1_1_1_8_9) SOL_TUNNEL_1_1_1_1_8_9_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.9'', SOL_TUNNEL_1_1_1_1_8_9) SOL_TUNNEL_1_1_1_1_8_9_DES, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_9,  GetData_Validita(''1.1.1.1.8.9'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_1_1_1_8_9, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_10_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.1.1.8.10'', SOL_TUNNEL_1_1_1_1_8_10) SOL_TUNNEL_1_1_1_1_8_10_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.1.1.8.10'', SOL_TUNNEL_1_1_1_1_8_10) SOL_TUNNEL_1_1_1_1_8_10_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.10'', SOL_TUNNEL_1_1_1_1_8_10) SOL_TUNNEL_1_1_1_1_8_10_DES, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_10, GetData_Validita(''1.1.1.1.8.10'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_1_1_1_8_10, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_11_AP, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetXmlValue(''1.1.1.1.8.11'', SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11_XML, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetOpValue(''1.1.1.1.8.11'', SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11_OV, ';
   sqlstringa := sqlstringa || ' PKG_RINF_DATA_V777.GetDescr(''1.1.1.1.8.11'', SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11_DES, ';
   sqlstringa := sqlstringa || ' SOL_TUNNEL_1_1_1_1_8_11, GetData_Validita(''1.1.1.1.8.11'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) Flag_1_1_1_1_8_11 '; 
   sqlstringa := sqlstringa || ' From '||s_schema||'.GALLERIE_BINARI_SOL g, ';
   sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE d, ';
   sqlstringa := sqlstringa ||   s_schema||'.REL_GALLERIE_BINARI_SOL r ';
   sqlstringa := sqlstringa || ' Where  g.SOL_TUNNEL_1_1_1_1_8_2 = d.SOL_TUNNEL_1_1_1_1_8_2 ';
   sqlstringa := sqlstringa || ' And  g.SOL_TUNNEL_1_1_1_1_8_2 = r.SOL_TUNNEL_1_1_1_1_8_2 ';
   sqlstringa := sqlstringa || ' And d.SOL_TRACK_1_1_1_0_0_1 = r.SOL_TRACK_1_1_1_0_0_1';
   sqlstringa := sqlstringa || ' And d.SOL_TRACK_1_1_1_0_0_1 = '''||p_Track||''' ';
   If p_versione Is Not Null Then
      sqlstringa := sqlstringa || ' And g.CODICE_VERSIONE = '||p_versione;
      sqlstringa := sqlstringa || ' And r.CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstringa := sqlstringa || ' Order By 4';
--
-- Dbms_Output.Put_Line(sqlstringa);
   Open p_cursor For sqlstringa;
--
 EXCEPTION
      When Others  Then
         Dbms_Output.Put_Line ('GetTracks_Inf_Tunnel - Errore: ' || SUbstr (Sqlerrm, 1, 300));
End GetTracks_Inf_Tunnel;

-- --------------------------------------------------------------------------------------------------------
--                           GetTracks_Inf_Tunnel_EC
--Ritorna l'elenco delle dichiarazioni di verifica EC e EI di una galleria di un Binario di Corsa di una SOL
-- --------------------------------------------------------------------------------------------------------
 Procedure GetTracks_Inf_Tunnel_EC (p_Tunnel Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur) Is
-- 
   s_schema   Varchar2(100);
--   sqlstringa Varchar2(20000);
   sqlstringa   CLOB;            
--
   p_versione Number;
--
 BEGIN
    S_SCHEMA   := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
    P_VERSIONE := P_I_VERSIONE;
    If (P_AREA = 2 Or P_AREA = 4) And P_VERSIONE Is Null Then
         P_VERSIONE := GetLastVersion(P_AREA);
    End If;

-- versione Debora
-- --------------------------------------------- EC --------------------------------------------------------
-- 1.1.1.1.8.2 - SOLTunnelIdentification
   sqlstringa :=  'Select DISTINCT s.SOL_TUNNEL_1_1_1_1_8_2 Tunnel_ID, ';
   sqlstringa := sqlstringa || Nvl(To_Char( p_versione), 'Null')||' CODICE_VERSIONE, ';
   sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione, ';
-- 1.1.1.1.8.5 - ITU_ECVerification -/- 1.1.1.1.8.6 - ITU_EIDemonstration
   sqlstringa := sqlstringa || ' Nvl(SOL_TUNNEL_1_1_1_1_8_5O6_AP, '''||GetNYA('1.1.1.1.8.5')||''') SOL_TUNNEL_1_1_1_1_8_5O6_AP, ';
   -->
-- sqlstringa := sqlstringa || 'Nvl(SOL_TUNNEL_1_1_1_1_8_5O6, ''00/00000000000000/0000/000000'') SOL_TUNNEL_1_1_1_1_8_5O6, ';
   sqlstringa := sqlstringa || ' Case  When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length(Trim(SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 ) Then SOL_TUNNEL_1_1_1_1_8_5O6  Else ''00/00000000000000/0000/000000'' End SOL_TUNNEL_1_1_1_1_8_5O6, ';
-->
   sqlstringa := sqlstringa || ' KM_INIZIO,  ';
   sqlstringa := sqlstringa || ' KM_FINE     ';
   sqlstringa := sqlstringa || ' From        ';
   sqlstringa := sqlstringa || '(Select SOL_TUNNEL_1_1_1_1_8_2, SOL_TUNNEL_1_1_1_1_8_5O6_AP, SOL_TUNNEL_1_1_1_1_8_5O6, KM_INIZIO, KM_FINE   ';
   sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_SOL ';
   sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EC''';
   If p_versione Is Not Null Then
        sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstringa := sqlstringa || ') b,                 ';
   sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_BINARI_SOL s            ';
   sqlstringa := sqlstringa || ' Where s.SOL_TUNNEL_1_1_1_1_8_2 = b.SOL_TUNNEL_1_1_1_1_8_2 (+) ';
   sqlstringa := sqlstringa || ' And s.SOL_TUNNEL_1_1_1_1_8_2 = '''||p_Tunnel||''''  ;
   sqlstringa := sqlstringa || ' UNION ';
   sqlstringa := sqlstringa || ' Select Distinct s.SOL_TUNNEL_1_1_1_1_8_2 Tunnel_ID,  ';
   sqlstringa := sqlstringa ||  Nvl(To_Char(p_versione), 'Null')||' CODICE_VERSIONE, ';
   sqlstringa := sqlstringa || ' ''EI'' tipo_dichiarazione, ';
   sqlstringa := sqlstringa || 'Nvl(SOL_TUNNEL_1_1_1_1_8_5O6_AP, '''||GetNYA('1.1.1.1.8.6')||''') SOL_TUNNEL_1_1_1_1_8_5O6_AP, ';
-->
-- sqlstringa := sqlstringa || 'Nvl(SOL_TUNNEL_1_1_1_1_8_5O6, ''00/00000000000000/0000/000000'') SOL_TUNNEL_1_1_1_1_8_5O6, ';
   sqlstringa := sqlstringa || ' Case  When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length(Trim(SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 ) Then SOL_TUNNEL_1_1_1_1_8_5O6  Else ''00/00000000000000/0000/000000'' End SOL_TUNNEL_1_1_1_1_8_5O6, ';
-->
   sqlstringa := sqlstringa || ' KM_INIZIO,  ';
   sqlstringa := sqlstringa || ' KM_FINE     ';
   sqlstringa := sqlstringa || ' From        ';
   sqlstringa := sqlstringa || ' (Select SOL_TUNNEL_1_1_1_1_8_2, SOL_TUNNEL_1_1_1_1_8_5O6_AP, SOL_TUNNEL_1_1_1_1_8_5O6, KM_INIZIO, KM_FINE   ';
   sqlstringa := sqlstringa || ' From '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_SOL ';
   sqlstringa := sqlstringa || ' Where TIPO_DICHIARAZIONE = ''EI''';
   If p_versione Is Not Null Then
        sqlstringa := sqlstringa || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstringa := sqlstringa || ') b,                 ';
   sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_BINARI_SOL s ';
   sqlstringa := sqlstringa || ' Where s.SOL_TUNNEL_1_1_1_1_8_2 = b.SOL_TUNNEL_1_1_1_1_8_2 (+) ';
   sqlstringa := sqlstringa || ' And s.SOL_TUNNEL_1_1_1_1_8_2 = '''||p_Tunnel||'''' ;
   If p_versione Is Not Null Then
        sqlstringa := sqlstringa || ' And CODICE_VERSIONE='||p_versione;
   End If;
   sqlstringa := sqlstringa || ' Order By 3,6 ';

-- Dbms_Output.Put_Line(sqlstringa);
--
   Open p_cursor For sqlstringa;
--
 EXCEPTION
      When Others  Then
         Dbms_Output.Put_Line ('GetTracks_Inf_Tunnel_EC - Errore: ' || SUbstr (Sqlerrm, 1, 300));
 End GetTracks_Inf_Tunnel_EC;
--
-- -----------------------------------------------------------------------------
--                     GetOP_PrivateSiding
-- Ritorna i parametri principali di un Raccordo
-- -----------------------------------------------------------------------------
--
Procedure GetOP_PrivateSiding (p_i_versione Number, p_cursor Out sys_refcursor) Is
   s_schema   Varchar2(100);
--   sqlstringa Varchar2(10000);
   sqlstringa   CLOB;            
--
BEGIN
   sqlstringa :=  'Select  l.PO_1_2_0_0_0_2 PO_ID, ';
   sqlstringa := sqlstringa || Nvl(To_Char( p_i_versione), 'Null')||' CODICE_VERSIONE,';
   sqlstringa := sqlstringa || 'PO_1_2_0_0_0_1_DEFINIZIONE PO_1_2_0_0_0_1, ';
   sqlstringa := sqlstringa || 'l.PO_1_2_0_0_0_2, ';
   sqlstringa := sqlstringa || 'DECODE(PO_1_2_0_0_0_3, ''NYA'', ''N'', ''Y'') PO_1_2_0_0_0_3_AP, ';
   sqlstringa := sqlstringa || 'PO_1_2_0_0_0_3, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetXmlValue(''1.2.0.0.0.4'', Lower(PO_1_2_0_0_0_4)) PO_1_2_0_0_0_4_XML, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetOpValue(''1.2.0.0.0.4'', Lower(PO_1_2_0_0_0_4)) PO_1_2_0_0_0_4_OV, ';
   sqlstringa := sqlstringa || 'PKG_RINF_DATA_V777.GetDescr(''1.2.0.0.0.4'', Lower(PO_1_2_0_0_0_4)) PO_1_2_0_0_0_4_DES, ';
   sqlstringa := sqlstringa || ' Lower(PO_1_2_0_0_0_4) PO_1_2_0_0_0_4, ';
--sqlstringa := sqlstringa || '''Latitude (''|| Trim(To_Char(Trunc(PO_1_2_0_0_0_5_LATITUDINE, 4), ''999.9999''))|| '') + Longitude (''|| Trim(To_Char(Trunc(PO_1_2_0_0_0_5_LONGITUDINE,4), ''S999.9999''))|| '')'' PO_1_2_0_0_0_5, ';
-- modifica del 22/10/2018 per visualizzare le latitudini e longitudini con 0.0 quando sono =0
   sqlstringa := sqlstringa || '''Latitude (''|| Case When PO_1_2_0_0_0_5_LATITUDINE = 0  Then ''0.0'' Else Trim (To_Char (Trunc (PO_1_2_0_0_0_5_LATITUDINE, 7), ''999.9999999'')) End || '') '' ||';
   sqlstringa := sqlstringa || '''+ Longitude (''|| Case When PO_1_2_0_0_0_5_LONGITUDINE = 0 Then ''0.0'' Else Trim (To_Char (Trunc (PO_1_2_0_0_0_5_LONGITUDINE, 7), ''S999.9999999'')) End|| '')'' PO_1_2_0_0_0_5, ';
--
   sqlstringa := sqlstringa || ' Nvl(Trim(PKG_RINF_INSERIMENTI.GetLineaComm(LOCALITA_RIFERIMENTO, '||Case When p_i_versione IS Null Then 1 Else 2 End||','||Nvl(To_Char(p_i_versione), 'Null')||')), ''0000 / 0.000'')  PO_1_2_0_0_0_6, ';

   sqlstringa := sqlstringa || ' Null CACHE_FIELD ';
   sqlstringa := sqlstringa || ' From RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI l, ';
   If p_i_versione Is Not Null Then
       sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.RACCORDI_REGISTRO r ';
       sqlstringa := sqlstringa || ' Where r.PO_1_2_0_0_0_2 = l.PO_1_2_0_0_0_2 ';
       sqlstringa := sqlstringa || ' And r.PROG = l.PROG  ';
       sqlstringa := sqlstringa || ' And r.CODICE_VERSIONE = '||p_i_versione;
   Else
       sqlstringa := sqlstringa || '(  Select PO_1_2_0_0_0_2, Max(PROG) PROG ';
       sqlstringa := sqlstringa || ' From RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI ';
       sqlstringa := sqlstringa || ' Where CODICE_STATO = 2 ';
       sqlstringa := sqlstringa || ' Group By PO_1_2_0_0_0_2) r ';
       sqlstringa := sqlstringa || ' Where r.PO_1_2_0_0_0_2 = l.PO_1_2_0_0_0_2  ';
       sqlstringa := sqlstringa || ' And r.PROG = l.PROG  ';
   End If;
   sqlstringa := sqlstringa || ' Order By 1 ';
--
   Open p_cursor For sqlstringa;
   Dbms_Output.Put_Line(sqlstringa);
--
END GetOP_PrivateSiding;

-- --------------------------------------------------------------------------------------
--                  PROCEDURE Get_validita_binari_corsa 
-- verifica che i parametri della tabella BINARI_CORSA_SOL non abbligatori siano validi alla data indicata
-- --------------------------------------------------------------------------------------
PROCEDURE Get_validita_binari_corsa (p_AREA Number, p_i_VERSIONE Number, p_CURSOR Out Empcur) IS

--  Sqlstringa Varchar2(32767);
   sqlstringa   CLOB;            
--
  P_Versione Number;
  Data_Validita Date;
--
BEGIN
   P_Versione := p_i_VERSIONE;
--   
  If (P_AREA = 2 Or P_AREA = 4) And P_Versione Is Null Then
     P_Versione := pkg_rinf_data_v777.GetLastVersion(P_AREA);
  End If;
-- estrazione data per la verifica di validità del parametro
 If (P_AREA = 2 Or P_AREA = 4 ) Then
       Select Greatest(DATA_PUBBLICAZIONE, DATA_RIFERIMENTO) 
	     Into Data_Validita 
         From RINF_PUBBLICATI_EVO.VERSIONE_RINF
        Where CODICE_VERSIONE = P_Versione;
 Else
       Select Greatest(DATA_CONTROLLO, DATA_RIFERIMENTO) 
	      Into Data_Validita 
          From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI
         Where CODICE_CONTROLLO =(Select max (CODICE_CONTROLLO) From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI);
 End If;
--
sqlstringa :=  'Select /*+ FIRST_ROWS */';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.0.0.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) FLAG_1_1_1_0_0_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_1, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.1.2'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_1_2, ';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.3'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_3, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.4'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_4, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.4.1'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_4_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.4.2'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_4_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.4.3'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_4_3, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.4.4'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_4_4, ';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.5'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_5, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.6'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_6, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.7'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_7, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.2.8'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_2_8, ';
--> parametri cancellati:
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.3.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_3_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.3.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_3_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.3.3'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_3_3, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.3.1.1.SUP'', To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) FLAG_1_1_1_1_3_1_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.3.1.2'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_3_1_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.3.1.3'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_3_1_3, ';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.3.4'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_3_4, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.3.5'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_3_5, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.3.5.1'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_3_5_1, ';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.3.6'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_3_6, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.3.7'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_3_7, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.4.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_4_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.4.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_4_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.4.3'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_4_3, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.4.4'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_4_4, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.5.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_5_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.5.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_5_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.6.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_6_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.6.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_6_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.6.3'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_6_3, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.6.4'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_6_4, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.6.5'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_6_5, ';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.7.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_7_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.7.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_7_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.7.3'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_7_3, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.7.4'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_7_4, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.7.5'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_7_5, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.7.6'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_7_6, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.7.7'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_7_7, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.7.8'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_7_8, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.7.9'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_7_9, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.7.10'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_7_10, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.1.7.11'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_1_7_11, ';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.2.1.1'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_2_1_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.2.1.2'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_2_1_2, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.2.1.2.1'',   To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_2_1_2_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.2.1.3'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_2_1_3, ';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.2.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_2_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.2.3'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_2_3, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.2.4'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_2_4, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.2.5'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_2_5, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.2.6'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_2_6, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.3.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_3_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.3.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_3_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.3.3.A'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) FLAG_1_1_1_2_3_3, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.3.4'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_3_4, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.4.1.1'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_4_1_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.4.1.2.A'',   To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) FLAG_1_1_1_2_4_1_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.4.2.1'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_4_2_1, ';
sqlstringa := sqlstringa || ' Getdata_Validita(''1.1.1.2.4.2.2.A'',   To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_4_2_2, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.4.3'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_4_3,';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.5.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_5_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.5.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_5_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.2.5.3'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_2_5_3, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.2.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_2_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.2.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_2_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.2.3'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_2_3, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.2.4'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_2_4, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.2.5'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_2_5, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.2.6'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_2_6, ';
-- parametro cancellato 
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.2.7'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_2_7, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.2.8'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_2_8, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.2.9'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_2_9, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.2.10'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_2_10, ';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.3'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_3, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.3.1'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_3_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.3.2'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_3_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.3.3'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_3_3, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.4'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_4, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.5'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_5, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.6'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_6, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.7'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_7, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.8'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_8, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.9'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_9, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.3.10'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_3_10, ';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.4.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_4_1, ';
-- parametro cancellato 
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.5.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_5_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.5.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_5_2, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.5.3'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_5_3, ';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.6.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_6_1, ';
-- parametro cancellato
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_1, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.1.1'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_1_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.1.2'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_1_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.1.3'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_1_3, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.1.4'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_1_4, ';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.2.1'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_2_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.2.2'',     To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_2_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.3'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_3, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.4'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_4, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.5'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_5, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.6'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_6, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.7'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_7, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.8'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_8, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.9'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_9, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.10'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_10, ';
-- parametro cancellato
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.11'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_11, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.11.1'',    To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_11_1,';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.12'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_12, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.13'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_13, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.14'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_14, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.15.1'',    To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_15_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.15.2'',    To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_15_2, ';
-- parametro cancellato
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.16'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_16, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.17'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_17, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.18'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_18, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.19'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_19, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.20'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_20, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.21'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_21, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.22'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_22, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.7.23'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_7_23, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.8.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_8_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.8.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_8_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.9.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_9_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.9.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_9_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.10.1'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_10_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.10.2'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_10_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.11.1'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_11_1, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.11.2'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_11_2, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.11.3'',      To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_11_3, ';
--/>
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.3.12.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_3_12_1, ';
--> Nuovo parametro Reg.2019/777
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.4.1'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_4_1, ';
sqlstringa := sqlstringa || ' GetData_validita(''1.1.1.4.2'',       To_Date('''||To_Char(Data_Validita,'dd/mm/yyyy')||''',''dd/mm/yyyy'')) flag_1_1_1_4_2 ';
sqlstringa := sqlstringa || ' From DUAL';
-- 
-- DBMS_OutPUT.PUT_LINE(sqlstringa);     
-- DBMS_OutPUT.PUT_LINE('sqlstringa: '||length(sqlstringa));
--
 OPEN p_cursor FOR sqlstringa;
--
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     Null;
   WHEN OTHERS THEN
      raise_application_error(-20001,'Get_validita_binari_corsa - ERRORE: '||SQLCODE||' -ERROR- '||SQLERRM);
 END Get_validita_binari_corsa;
--
--
END PKG_RINF_DATA_V777;
/