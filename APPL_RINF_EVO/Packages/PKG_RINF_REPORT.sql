--
-- PKG_RINF_REPORT  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_REPORT" Is
-- --------------------------------------------------------------------------------------
--                                PKG_RINF_REPORT
-- con le implementazioni del Reg.777/2019/UE - 08/02/2021 e le modifiche richieste da Schillaci con la meil del 07/04/2021
-- Versione con le modifiche delle procedure 
/*
 Report Parametri Rinf - Tutti i Parametri - Info Generali Tratta Binario (Aggiunto "Norme e restrizioni"  1.1.1.4.1 e 1.1.1.4.2 )

 Report Parametri Rinf - Tutti i Parametri - Binari Circolazione SOL Parametri INF  - PROCEDURE GetSOLParametriINF -  ok
 Report Parametri Rinf - Tutti i Parametri - Binari Circolazione SOL Parametri ENE  - PROCEDURE GetSOLParametriENE -  ok 
 Report Parametri Rinf - Tutti i Parametri - Binari Circolazione Parametri SOL CCS  - PROCEDURE GetSOLParametriCCS -  ok
 Report Parametri Rinf - Tutti i Parametri - Gallerie SOL                           - PROCEDURE GetGallerieSOL     -  ok
 Report Parametri Rinf - Tutti i Parametri - Info generali Punti Operativi          - PROCEDURE GetInfoGeneraliPO  -  ok 
 Report Parametri Rinf - Tutti i Parametri - Binari Circolazione PO Parametri INF   - PROCEDURE GetPOParametriINF  -  ok 
 Report Parametri Rinf - Tutti i Parametri - Gallerie PO Binari di corsa            - PROCEDURE GetGalleriePOBinCorsa - ok
 Report Parametri Rinf - Tutti i Parametri - Binari di Raccordo                     - PROCEDURE GetBinariRaccordo     - ok
 Report Parametri Rinf - Tutti i Parametri - Gallerie Binari di Raccordo            - PROCEDURE GetGalleriePOBinRacc  - ok
*/

-- 25/05/2021 Modificata la procedura GetReport_RC_BinariCorsa_SOL per restituire un solo campo per il parametro 1.1.1.2.3.3
-- 08/10/2021 Modificate le etichette per i parametri delle Gallerie nel report di Route Compatibility (ITU_FireCatReq e ITU_NatFireCatReq)
--
-- 18/11/2021 aggiornati tutti i report implementati da Emanuele Tisbi con i parametri del Reg.777/2019 per la fase IV *** 
-- 03/12/2021 accorpamento dei campi relativi al parametro 1.1.1.2.3.3 - "Raggio minimo di curvatura verticale [m]" del report RC dei binari di raccordo
-- 16/12/2021 accorpamento dei campi relativi ai parametri della Sagoma nei Report RC dei bianari di corsa (circolazione) delle SOL e PO
-- 27/02/2023 gestione del parametro numerico 1.2.2.0.2.1 in alfanumerico (Report Binari Raccordi)
-- novembre 2023 Modificata la procedura GetSchemaAutorizzRI in quanto non restituiva correttamente lo schema autorizzativo
--
-- --------------------------------------------------------------------------------------
--
Type empcur Is Ref CURSOR;
PROCEDURE GetListaControlli(p_cursor OUT empcur);
PROCEDURE GetListaReport(p_codice_menu NUMBER, p_cursor OUT empcur);
FUNCTION GetWhereCondition(p_filtro In Varchar2, p_alias In Varchar2) Return Varchar2 ;
FUNCTION GetOptionalValue(p_parametro IN VARCHAR2,p_valore IN VARCHAR2) RETURN VARCHAR2;
FUNCTION GetDescription(p_parametro IN VARCHAR2,p_valore IN VARCHAR2) RETURN VARCHAR2;
--blocco 3.1
PROCEDURE GetCodificaTratte (p_area NUMBER,p_i_versione NUMBER , p_filtro CLOB,p_cursor OUT empcur);
PROCEDURE GetTipologiaLocalita (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetLimiteCaricoTratte (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetTratteCorridoi (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetRanghiVelocitaBinario (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetCorridoioLineaTENBinario (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetMDRReport (p_area NUMBER,p_i_versione NUMBER , p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetCircolabilitaSOL  (p_area NUMBER,p_i_versione NUMBER , p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetRneTisPO  (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetRneTisSOL  (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
--blocco 3.2
PROCEDURE GetSchemaAutorizzRI (p_i_versione NUMBER ,p_cursor OUT empcur);
--blocco 3.4
PROCEDURE GetScartiRIPubbl (p_i_versione NUMBER ,p_cursor OUT empcur);
PROCEDURE GetSintesiRIPubbl   (p_i_versione NUMBER ,p_cursor OUT empcur);
PROCEDURE GetKPIScarti  (p_cursor OUT empcur) ;
PROCEDURE GetKPIRegistroPubbl  (p_i_versione NUMBER ,p_cursor OUT empcur);
PROCEDURE GetVariazioneOggPubbl  (p_i_versione_corrente NUMBER, p_i_versione_precedente NUMBER, p_cursor OUT empcur);
PROCEDURE GetVarScartiAcquisValidazione  (p_i_controllo_corrente NUMBER, p_i_controllo_precedente NUMBER, p_cursor OUT empcur);
PROCEDURE GetVariazioniOggettiValid  (p_i_controllo_corrente NUMBER, p_i_controllo_precedente NUMBER, p_cursor OUT empcur) ;
PROCEDURE GetVariazOggettiErroriValid  (p_i_controllo_corrente NUMBER, p_i_controllo_precedente NUMBER, p_cursor OUT empcur);
PROCEDURE GetVarErroriValidazioneNYA  (p_i_controllo_corrente NUMBER, p_i_controllo_precedente NUMBER, p_cursor OUT empcur);
--blocco 3.4
PROCEDURE GetProfilazioneUtenze (p_cursor OUT empcur);
PROCEDURE GetAccessi30gg (p_cursor OUT empcur);
PROCEDURE GetAccessi12mesi (p_cursor OUT empcur);
-- blocco 3.5
PROCEDURE GetElencoAcquisioniRITrasm (p_cursor OUT empcur);
--blocco 3.6
PROCEDURE GetDichiarazioniEC (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetInfoGeneraliTrattaBin (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetSOLParametriINF (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetSOLParametriENE (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetSOLParametriCCS (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetGallerieSOL (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetInfoGeneraliPO (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetPOParametriINF (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetMarciapiedi (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetGalleriePOBinCorsa (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetBinariRaccordo (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetGalleriePOBinRacc (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
-- Procedure per la Route Compatibility Reg.777/2019/UE
PROCEDURE GetReport_RC_BinariCorsa_PO (p_area Number, p_i_versione Number, p_filtro Clob, p_cursor Out empcur);
PROCEDURE GetReport_RC_BinariRaccordo_PO (p_area Number, p_i_versione Number, p_filtro Clob, p_cursor Out empcur);
PROCEDURE GetReport_RC_BinariCorsa_SOL (p_area Number, p_i_versione Number , p_filtro Clob, p_cursor Out empcur);
PROCEDURE GetReport_RC_PO (p_area Number, p_i_versione Number, p_filtro Clob, p_cursor Out empcur);
PROCEDURE GetMarciapiedi_RC (p_area NUMBER, p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetGallerie_RC  (p_area Number, p_i_versione Number, p_filtro Clob, p_cursor Out Empcur);
-- PROCEDURE GetGalleriePOBinCorsa_RC (p_area NUMBER, p_i_versione NUMBER, p_filtro CLOB, p_cursor OUT empcur);
-- PROCEDURE GetGalleriePOBinRacc_RC (p_area NUMBER, p_i_versione NUMBER, p_filtro CLOB, p_cursor OUT empcur);
-- PROCEDURE GetGallerieSOL_RC (p_area NUMBER,p_i_versione NUMBER  ,p_filtro CLOB, p_cursor OUT empcur);
--
--Report FLAT
PROCEDURE GetDichiarazioniEC_SOL (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetDichiarazioniEC_PO (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
--report congelati
--PROCEDURE GetRanghiVelocitaTratta (p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur);
-- Report 'Piantedosi' Query Only 2025.07
PROCEDURE GetInfoGeneraliTrattaBin2_OFF (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetSOLParametriINF2_OFF (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetSOLParametriENE2_OFF (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);
PROCEDURE GetSOLParametriCCS2_OFF (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur);


END;
/


--
-- PKG_RINF_REPORT  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_REPORT" Is
--
-- --------------------------------------------------------------------------------------
--                           GetListaControlli
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetListaControlli(p_cursor Out empcur) Is
  Begin
     Open p_cursor For
        Select CODICE_CONTROLLO, To_Char(DATA_CONTROLLO,'DD/MM/YY HH:MI:SS') DATA_CONTROLLO
          From RINF_LAVORAZIONE_EVO.CONTROLLO_DATI
         Order By CODICE_CONTROLLO Desc;
  End;
--
-- --------------------------------------------------------------------------------------
--                           GetListaReport
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetListaReport(p_codice_menu NUMBER, p_cursor OUT empcur) IS
  Begin
     Open p_cursor For
        Select CODICE_REPORT, NOME_REPORT, CODICE_MENU
  -- aggiunto per gestire i report della RC con un menu a parte 22/01/2021
  , decode (codice_menu, 35, decode (codice_report, 37,2, 38,2,  39,2,  40,2,  41,2 ,  42,2, 1), null)  sotto_menu       
          From Rinf_Anagrafiche_Evo.ANAG_REPORT
         Where CODICE_MENU = p_codice_menu
         Order By ORDINAMENTO;
  End GetListaReport;

--FUNCTION GetWhereCondition(p_filtro IN VARCHAR2, p_alias IN VARCHAR2) RETURN VARCHAR2 IS
--butttare perch  collassata con la seguente
----vale per i casi in cui ho un filtro su .SEDE_TECNICA
-- p_lista_1000 CLOB;
-- p_lista_2000 CLOB;
-- p_lista_3000 CLOB;
-- p_versione NUMBER;
-- sqlstringa VARCHAR2(30000);
--BEGIN
--PKG_RINF_WORK_UTILITY.GetStringhe1000( p_filtro,p_lista_1000, p_lista_2000,p_lista_3000 );
--
--sqlstringa:=sqlstringa||' and ( ';
--sqlstringa:=sqlstringa|| p_alias||'.SEDE_TECNICA IN ('||p_lista_1000||') ';
--IF p_lista_2000 IS NOT NULL THEN
--sqlstringa:=sqlstringa||' OR '|| p_alias||'.SEDE_TECNICA  IN ('||p_lista_2000||') ';
--    IF p_lista_3000 IS NOT NULL THEN
--      sqlstringa:=sqlstringa||' OR '|| p_alias||'.SEDE_TECNICA IN ('||p_lista_3000||') ';
--    END IF;
--END IF;
--sqlstringa:=sqlstringa||' )';
----per garantire l'ordinamento delle tratte del percorso
--sqlstringa:=sqlstringa||' order by instr('''||replace(p_filtro,'''','')||''','|| p_alias||'.SEDE_TECNICA)';
--   RETURN sqlstringa;
--   EXCEPTION
--     WHEN OTHERS THEN
--       RETURN NULL;
--END GetWhereCondition;

--
-- --------------------------------------------------------------------------------------
--                           GetWhereCondition
-- --------------------------------------------------------------------------------------
--
FUNCTION GetWhereCondition (p_filtro In Varchar2, p_alias In Varchar2) Return Varchar2 Is
----procedura che riceve in input la stringa con la lista delle SOL/PO da filtrare e restituisce la stringa da inserire nella where condition
 p_lista_1000 CLOB;
 p_lista_2000 CLOB;
 p_lista_3000 CLOB;
 p_versione NUMBER;
 sqlstringa VARCHAR2(30000);
 Begin
   PKG_RINF_WORK_UTILITY.GetStringhe1000( p_filtro, p_lista_1000, p_lista_2000, p_lista_3000 );
--
   sqlstringa := sqlstringa||' and ( ';
   sqlstringa := sqlstringa|| p_alias||' IN ('||p_lista_1000||') ';
--
   If p_lista_2000 Is Not Null Then
       sqlstringa := sqlstringa||' OR '|| p_alias||' IN ('||p_lista_2000||') ';
       If p_lista_3000 Is Not Null Then
           sqlstringa := sqlstringa||' OR '|| p_alias||' IN ('||p_lista_3000||') ';
       End If;
   End If;
--   
   sqlstringa := sqlstringa||' )';
--
-- per garantire l'ordinamento delle tratte del percorso
-- 16/03/2017 spezzo in due il filtro, per evitare di avere l'errore  ora-01704 valore di stringa troppo lungo

   p_lista_1000 := substr(p_filtro, 1, instr(p_filtro, 'TR') -1);
   p_lista_2000 := substr(p_filtro, instr(p_filtro, 'TR') );
--
--   sqlstringa:=sqlstringa||' order by instr('''||replace(p_filtro, '''','')||''', '|| p_alias||')';

   sqlstringa := sqlstringa||' order by instr('''||replace(p_lista_1000, '''', '')||''','|| p_alias||')';
   sqlstringa := sqlstringa||' , instr('''||replace(p_lista_2000, '''', '')||''','|| p_alias||')';
--
   Return sqlstringa;
--   
   EXCEPTION
     When Others Then
        Return Null;
End GetWhereCondition;
--
-- --------------------------------------------------------------------------------------
--                           GetOptionalValue
-- --------------------------------------------------------------------------------------
--
FUNCTION GetOptionalValue(p_parametro In Varchar2, p_valore In Varchar2) Return Varchar2   Is
--   procedura usata nel report Circolabilit  per avere il valore del parametro e non l'optional value 
--  (in quanto alcuni parametri hanno l'optional value anche in In.Rete a causa della loro eccessiva lunghezza)
   op_value VARCHAR2(300);
Begin
   Select OPTIONAL_VALUE Into op_value
     From Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO d,
          Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI c
    where c.codice_parametro = d.codice_parametro 
	  and c.numero_parametro_multiplo = p_parametro 
	  and d.codifica_valore = p_valore;
--
   If op_value Is Null  Then
        op_value := p_valore;
   End If;
--   
   Return op_value;
--
   EXCEPTION
     When NO_DATA_FOUND Then
       Return p_valore;
     When Others Then
       -- Consider logging the error and then re-raise
       Return p_valore;
End GetOptionalValue;
--
-- --------------------------------------------------------------------------------------
--                           GetDescription   
-- --------------------------------------------------------------------------------------
--
FUNCTION GetDescription(p_parametro In Varchar2,p_valore In Varchar2) Return Varchar2   Is
-- procedura usata nei report del blocco 3.6 (Parametri) per avere il valore in italiano (e non il inglese e neanche l'optional value)
   des_value VARCHAR2(300);
 Begin
   Select VALORE Into des_value
     From Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO d,
          Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI c
    Where c.codice_parametro = d.codice_parametro 
	  And c.numero_parametro_multiplo = p_parametro 
	  And d.codifica_valore = p_valore;
--
    If des_value Is Null  Then
       des_value := p_valore;
    End If;
--
   Return des_value;
--
   Exception
     When NO_DATA_FOUND Then
       Return p_valore;
     When OTHERS Then
       -- Consider logging the error and then re-raise
       Return p_valore;
End GetDescription;
--
-- --------------------------------------------------------------------------------------
--                           GetCodificaTratte
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetCodificaTratte (p_area Number, p_i_versione Number, p_filtro Clob, p_cursor Out empcur) Is
-- REPORT 3.1.1
   s_schema VARCHAR2(100);
   sqlstring VARCHAR2(32767);
   p_versione NUMBER;
   d_data_riferimento VARCHAR2(8);
 Begin
 s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);

 -- Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
    If (p_area = 1 Or p_area = 3) Then
        p_versione := Null;
    Else  --(p_area = 2 OR p_area = 4)
        If  p_i_versione Is Null Then
           p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
        Else
           p_versione := p_i_versione;
        End If;
    End If;

-- 14/02/2018 Inserita la data di riferimento in sostituzione della SYSDATE, per contestualizzare
-- l'estrazione dei dati validi all'area selezionata
--
   d_data_riferimento := To_Char(Pkg_Rinf_Interfaccia.GetDataRiferimento(p_area, p_i_versione), 'DDMMYYYY');
--
   sqlstring := 'Select Distinct';
   sqlstring := sqlstring||' t.sede_tecnica "CodiceTrattaINRETE"';
   sqlstring := sqlstring||', T.DEFINIZIONE "DefinizioneINRETE"';
   sqlstring := sqlstring||', pic_dispari.CODICE_TRATTA_PIC "CodicePicDispari"';
   sqlstring := sqlstring||', pic_pari.CODICE_TRATTA_PIC "CodicePicPari"';
   sqlstring := sqlstring||', rd.CODICE_TRATTA_ROMAN "CodiceRomanDispari"';
   sqlstring := sqlstring||', rp.CODICE_TRATTA_ROMAN "CodiceRomanPari"';
   sqlstring := sqlstring||', lc.SIGLA_LC "SiglaLinea43T" ';
   sqlstring := sqlstring||', lc.DEFINIZIONE_LC "Linea43T"';
   sqlstring := sqlstring||', ten.CODICE_LINEA_TENT         "CodiceLineaTent"';
   sqlstring := sqlstring||', ten.NUMERO_LINEA_TENT         "NumeroLineaTent"   ';
   sqlstring := sqlstring||', ten.NOME_LINEA_TENT           "Nome Linea Tent"     ';
   sqlstring := sqlstring||', CORR.CODICE_CORRIDOIO        "CodiceCorridoio"    ';
   sqlstring := sqlstring||', CORR.DEFINIZIONE     "SOL_TRACK_1_1_1_1_2_3"';
   sqlstring := sqlstring||', fascicolo_linea               "FascicoloLinea"';
   sqlstring := sqlstring||', codice_linea_fcl              "CodiceLineaFcl"';
   sqlstring := sqlstring||', codice_linea_fcl_inversa      "CodiceLineaFclInversa"';
   sqlstring := sqlstring||', linea_fcl                     "DefinizioneLineaFcl"';
   sqlstring := sqlstring||', t.codice_dtp "CodiceDTP"';
   sqlstring := sqlstring||', t.codice_ut "CodiceUT"';
   sqlstring := sqlstring||', t.codice_linea_tecnica "CodiceLineaTecnica"';
   sqlstring := sqlstring||' From ';
   sqlstring := sqlstring||s_schema||'.SEZIONI_LINEA t';
   sqlstring := sqlstring||'    ,(Select SEDE_TECNICA, CODICE_TRATTA_PIC, CODICE_LOCALITA_INIZIO_PIC, CODICE_LOCALITA_FINE_PIC';
   sqlstring := sqlstring||'    From RINF_ANAGRAFICHE_EVO.tratte_pic ';
   sqlstring := sqlstring||'    where';
   sqlstring := sqlstring||'    FLAG_DISPARI = 1) pic_dispari';
   sqlstring := sqlstring||'    ,(select SEDE_TECNICA, CODICE_TRATTA_PIC, CODICE_LOCALITA_INIZIO_PIC, CODICE_LOCALITA_FINE_PIC';
   sqlstring := sqlstring||'    From RINF_ANAGRAFICHE_EVO.tratte_pic ';
   sqlstring := sqlstring||'    Where';
   sqlstring := sqlstring||'    FLAG_DISPARI = 0) pic_pari';
   sqlstring := sqlstring||', RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN rd';
   sqlstring := sqlstring||', RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN rp';
   sqlstring := sqlstring||',(  Select SEDE_TECNICA, ';
   sqlstring := sqlstring||'          Listagg (Replace (CODICE, '' '', '''') || '' '') ';
   sqlstring := sqlstring||'             Within Group (Order By CODICE) ';
   sqlstring := sqlstring||'             As sigla_lc, ';
   sqlstring := sqlstring||'          Listagg (Replace (DESCRIZIONE, '' \ '', '''') || '' '') ';
   sqlstring := sqlstring||'             Within Group (Order By CODICE) ';
   sqlstring := sqlstring||'             As definizione_lc ';
   sqlstring := sqlstring||' From '||s_schema||'.V_MDR_LINEE_COMMERCIALI ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring||' Where CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring||' Group By SEDE_TECNICA) lc ';
   sqlstring := sqlstring||', (Select ten.CODICE_LINEA_TENT, ten.NUMERO_LINEA_TENT, ten.NOME_LINEA_TENT, CODICE_TRATTA_PIC';
   sqlstring := sqlstring||'    from ';
   sqlstring := sqlstring||'     Rinf_Anagrafiche_Evo.LINEA_TENT_TRATTE ten_l';
   sqlstring := sqlstring||'   , Rinf_Anagrafiche_Evo.ANAG_LINEE_TENT ten';
   sqlstring := sqlstring||'    Where';
   sqlstring := sqlstring||'    TEN.CODICE_GIURISDIZIONE = TEN_L.CODICE_GIURISDIZIONE) ten';
   sqlstring := sqlstring||', (Select R.CODICE_CORRIDOIO, R.DEFINIZIONE, ';
   sqlstring := sqlstring||'    corr_l.CODICE_TRATTA_PIC';
   sqlstring := sqlstring||'    from';
   sqlstring := sqlstring||'   Rinf_Anagrafiche_Evo.CORRIDOIO_TRATTE corr_l';
   sqlstring := sqlstring||' , Rinf_Anagrafiche_Evo.ANAG_CORRIDOI corr';
   sqlstring := sqlstring||' , Rinf_Anagrafiche_Evo.CORRIDOI_633 r';
   sqlstring := sqlstring||'    Where';
   sqlstring := sqlstring||'    corr.CODICE_GIURISDIZIONE = corr_l.CODICE_GIURISDIZIONE';
   sqlstring := sqlstring||'    And  r.CODICE_CORRIDOIO = corr.CODICE_CORRIDOIO_633) corr';
   sqlstring := sqlstring||' ';
   sqlstring := sqlstring||' ,( Select ';
   sqlstring := sqlstring||'          f.FASCICOLO_LINEA fascicolo_linea,';
   sqlstring := sqlstring||'          t.CODICE_LINEA_FCL codice_linea_fcl,';
   sqlstring := sqlstring||'          t.CODICE_LINEA_INVERSA codice_linea_fcl_inversa,';
   sqlstring := sqlstring||'          t.DEFINIZIONE linea_fcl,';
   sqlstring := sqlstring||'          DATA_INIZIO_VALIDITA, ';
   sqlstring := sqlstring||'          DAT_FINE_VAL,';
   sqlstring := sqlstring||'          l.SEDE_TECNICA';
   sqlstring := sqlstring||'     From '||s_schema||'.LINEA_FCL_SOL l,';
   sqlstring := sqlstring||'          Rinf_Anagrafiche_Evo.FASCICOLO_LINEE_FCL fl,';
   sqlstring := sqlstring||'          Rinf_Anagrafiche_Evo.ANAG_FASCICOLO_LINEE f,';
   sqlstring := sqlstring||'          Rinf_Anagrafiche_Evo.ANAG_LINEA_FCL t';
   sqlstring := sqlstring||' Where    l.CODICE_LINEA_FCL = t.CODICE_LINEA_FCL';
   sqlstring := sqlstring||'  And l.CODICE_LINEA_FCL = fl.CODICE_LINEA_FCL';
   sqlstring := sqlstring||'  And fl.CODICE_FASCICOLO = f.CODICE_FASCICOLO';
   sqlstring := sqlstring||'  And t.FLAG_DISPARI = 1 ';
   sqlstring := sqlstring||'  And Nvl(DATA_INIZIO_VAL_R, To_Date(''01011999'', ''DDMMYYYY'')) <= To_Date('''||d_data_riferimento||''', ''DDMMYYYY'')';
   sqlstring := sqlstring||'  And Nvl(DAT_FINE_VAL, To_Date(''01012999'', ''DDMMYYYY'')) >= To_Date('''||d_data_riferimento||''', ''DDMMYYYY'')';
   If p_versione Is Not Null Then
      sqlstring := sqlstring||' And l.CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring||' ) l_fd';
   sqlstring := sqlstring||' Where ';
   sqlstring := sqlstring||'t.SEDE_TECNICA = pic_dispari.SEDE_TECNICA ';
   sqlstring := sqlstring||'And t.SEDE_TECNICA = pic_pari.SEDE_TECNICA ';
   sqlstring := sqlstring||'And pic_dispari.CODICE_LOCALITA_INIZIO_PIC = pic_pari.CODICE_LOCALITA_FINE_PIC ';
   sqlstring := sqlstring||'And pic_dispari.CODICE_LOCALITA_FINE_PIC = pic_pari.CODICE_LOCALITA_INIZIO_PIC ';
   sqlstring := sqlstring||'And pic_dispari.CODICE_TRATTA_PIC = rd.CODICE_TRATTA_PIC  ';
   sqlstring := sqlstring||'And pic_pari.CODICE_TRATTA_PIC = rp.CODICE_TRATTA_PIC ';
   sqlstring := sqlstring||'And rd.CODICE_BRANCH = rp.CODICE_BRANCH ';
   sqlstring := sqlstring||'And T.SEDE_TECNICA = lc.SEDE_TECNICA  ';
   sqlstring := sqlstring||'And l_fd.SEDE_TECNICA = T.SEDE_TECNICA  ';
   sqlstring := sqlstring||'And pic_dispari.CODICE_TRATTA_PIC = ten.CODICE_TRATTA_PIC (+) ';
   sqlstring := sqlstring||'And pic_dispari.CODICE_TRATTA_PIC = corr.CODICE_TRATTA_PIC (+) ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring||' And t.CODICE_VERSIONE = '||p_versione;
   End If;

   --filtro richiamato dalla funzione ROUTING
   If p_filtro Is Not Null Then
      sqlstring := sqlstring || GetWhereCondition(p_filtro, 't.SEDE_TECNICA');
   End If;
--
-- sqlstring:=sqlstring||'order by 1';

   Dbms_Output.Put_Line(sqlstring);
--
   Open p_cursor For sqlstring;
--
END GetCodificaTratte;
--
-- --------------------------------------------------------------------------------------
--                           GetTipologiaLocalita 
-- --------------------------------------------------------------------------------------
--

PROCEDURE GetTipologiaLocalita (p_area Number, p_i_versione Number, p_filtro Clob, p_cursor Out empcur) Is
-- REPORT 3.1.2
   s_schema VARCHAR2(100);
   sqlstring VARCHAR2(32767);
   p_versione NUMBER;
 Begin
   s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--
-- Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
   If (p_area = 1 Or p_area = 3) Then
      p_versione := Null;
   Else  --(p_area = 2 Or p_area = 4)
       If  p_i_versione Is Null Then
          p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
       Else
          p_versione := p_i_versione;
       End If;
   End If;
   sqlstring := 'Select ';
   sqlstring := sqlstring||' l.SEDE_TECNICA "CodiceLocalitaINRETE"';
   sqlstring := sqlstring||' , l.DEFINIZIONE "DefinizioneINRETE"';
   sqlstring := sqlstring||' , PO_1_2_0_0_0_2 '; --06/09/2016 aggiunto su richiesta mail Autiero
   sqlstring := sqlstring||' , codice_taf_tap.CODICE PO_1_2_0_0_0_3 ';
   sqlstring := sqlstring||' , PO_1_2_0_0_0_4 ';
   sqlstring := sqlstring|| ',''Latitude (''|| Trim(To_Char(Trunc(LATITUDINE, 4),''999.9999''))|| '') + Longitude (''|| Trim(To_Char(Trunc(LONGITUDINE, 4),''S999.9999''))|| '')'' PO_1_2_0_0_0_5 ';
   sqlstring := sqlstring||' , P.CODICE_LOCALITA_PIC "CodiceLocalitaPIC"';
   sqlstring := sqlstring||' , R.CODICE_LOCALITA_ROMAN "CodiceLocalitaRoman"';
   sqlstring := sqlstring||' , CODICE_DTP "CodiceDTP"';
   sqlstring := sqlstring||' , CODICE_UT "CodiceUT"';
   sqlstring := sqlstring||' , tPo.DESCRIZIONE "TipoPuntoOrario"';
   sqlstring := sqlstring||' , tl.DESCRIZIONE  "TipoLocalita"';
   sqlstring := sqlstring||' , P.TIPO_LOCALITASBF "TipoLocalitaSBF"';
   sqlstring := sqlstring||' , Decode(P.FLAG_SERVIZIO_MERCI, 0, ''No'', 1, ''Si'', P.FLAG_SERVIZIO_MERCI) "EffettuaServizioMerci"';
   sqlstring := sqlstring||' , Decode(P.FLAG_SERVIZIO_VIAGGIATORI, 0, ''No'', 1, ''Si'', P.FLAG_SERVIZIO_VIAGGIATORI) "EffettuaServizioViaggiatori"';
   sqlstring := sqlstring||' , p.CASSIFICAZIONE_IAP "ClassificazioneIaP"';
   sqlstring := sqlstring||' , l.NUOVA_CLASSIFICAZIONE_STAZIONE "NuovaClassificazioneStazione"';
   sqlstring := sqlstring||' From ';
   sqlstring := sqlstring|| s_schema||'.PUNTI_OPERATIVI l, ';
-- 23/09/2016 aggiunti i controlli sulle date di scadenza Roman e Pic per non considerare i mapping scaduti
-- che provocano una duplicazione delle localit 
   sqlstring := sqlstring||' (Select CODICE_LOCALITA_PIC,';
   sqlstring := sqlstring||'         TIPO_LOCALITA,TIPO_PUNTOORARIO,';
   sqlstring := sqlstring||'         TIPO_LOCALITASBF,';
   sqlstring := sqlstring||'         FLAG_SERVIZIO_MERCI,';
   sqlstring := sqlstring||'         FLAG_SERVIZIO_VIAGGIATORI,';
   sqlstring := sqlstring||'         CASSIFICAZIONE_IAP,COD_LOCALITA_IN_RETE';
   sqlstring := sqlstring||'    From Rinf_Anagrafiche_Evo.LOCALITA_PIC';
   sqlstring := sqlstring||'   Where (COD_LOCALITA_IN_RETE, ';
   sqlstring := sqlstring||'    Nvl (DATA_SCADENZA, To_Date (''01012900'', ''DDMMYYYY''))) In';
   sqlstring := sqlstring||'  (  Select COD_LOCALITA_IN_RETE,';
   sqlstring := sqlstring||'     Max (';
   sqlstring := sqlstring||'       Nvl (DATA_SCADENZA,';
   sqlstring := sqlstring||'            To_Date (''01012900'', ''DDMMYYYY'')))';
   sqlstring := sqlstring||'      From Rinf_Anagrafiche_Evo.LOCALITA_PIC';
   sqlstring := sqlstring||'                      Group By COD_LOCALITA_IN_RETE)) p,';
   sqlstring := sqlstring||'          (Select CODICE_LOCALITA_ROMAN, CODICE_LOCALITA_PIC';
   sqlstring := sqlstring||'             From Rinf_Anagrafiche_Evo.LOCALITA_ROMAN';
   sqlstring := sqlstring||'            Where (CODICE_LOCALITA_PIC,';
   sqlstring := sqlstring||'                   Nvl (DATA_SCADENZA, To_Date (''01012900'', ''DDMMYYYY''))) IN';
   sqlstring := sqlstring||'                     (  Select CODICE_LOCALITA_PIC,';
   sqlstring := sqlstring||'                               Max (';
   sqlstring := sqlstring||'                                  Nvl (DATA_SCADENZA,';
   sqlstring := sqlstring||'                                       To_Date (''01012900'', ''DDMMYYYY'')))';
   sqlstring := sqlstring||'                          From Rinf_Anagrafiche_Evo.LOCALITA_ROMAN';
   sqlstring := sqlstring||'                      Group By CODICE_LOCALITA_PIC)) r';
   sqlstring := sqlstring||' , Rinf_Anagrafiche_Evo.ANAG_TIPO_PUNTOORARIO tpo  ';
   sqlstring := sqlstring||' , Rinf_Anagrafiche_Evo.ANAG_TIPO_LOCALITA tl, ';
   sqlstring := sqlstring|| '(Select v.SEDE_TECNICA, Listagg(PO_1_2_0_0_0_3 ,''-'' ) Within Group (ORDER BY PO_1_2_0_0_0_3) AS codice ';
   sqlstring := sqlstring|| 'From '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v,';
   sqlstring := sqlstring|| s_schema||'.PUNTI_OPERATIVI p';
   sqlstring := sqlstring|| ' Where  ';
   sqlstring := sqlstring|| ' p.sede_tecnica = v.sede_tecnica ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring||' And p.CODICE_VERSIONE = '||p_versione;
      sqlstring := sqlstring||' And v.CODICE_VERSIONE = '||p_versione;
   END IF;
   sqlstring := sqlstring|| ' Group By v.SEDE_TECNICA) codice_taf_tap ';
   sqlstring := sqlstring||' Where ';
   sqlstring := sqlstring||' l.SEDE_TECNICA = P.COD_LOCALITA_IN_RETE ';
   sqlstring := sqlstring||' And L.SEDE_TECNICA = codice_taf_tap.SEDE_TECNICA ';
   sqlstring := sqlstring||' And r.CODICE_LOCALITA_PIC = P.CODICE_LOCALITA_PIC ';
   sqlstring := sqlstring||' And tpo.CODICE_TIPO = P.TIPO_PUNTOORARIO';
   sqlstring := sqlstring||' And P.TIPO_LOCALITA = tl.CODICE_TIPO';

   If p_versione Is Not Null Then
      sqlstring := sqlstring||' And l.CODICE_VERSIONE = '||p_versione;
   End If;

-- filtro richiamato dalla funzione ROUTING
   If p_filtro Is Not Null Then
      sqlstring := sqlstring ||GetWhereCondition(p_filtro, 'L.SEDE_TECNICA');
   End If;

   -- sqlstring:=sqlstring||' order by 1';
   -- DBMS_OUTPUT.PUT_LINE(sqlstring);
   Open p_cursor For sqlstring;
--   
  End GetTipologiaLocalita;
--
-- --------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetLimiteCaricoTratte (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
-- REPORT 3.1.3
   s_schema VARCHAR2(100);
   sqlstring VARCHAR2(32767);
   p_versione NUMBER;
 BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area = 1 OR p_area = 3) THEN
  p_versione := NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione := p_i_versione;
     END IF;
 END IF;
   sqlstring := 'Select ';
   sqlstring := sqlstring ||'t.SEDE_TECNICA "CodiceTrattaINRETE"';
   sqlstring := sqlstring ||', T.DEFINIZIONE "DefinizioneINRETE"';
   sqlstring := sqlstring ||', pic_dispari.CODICE_TRATTA_PIC "CodicePicDispari"';
   sqlstring := sqlstring ||', pic_pari.CODICE_TRATTA_PIC "CodicePicPari"';
   sqlstring := sqlstring ||', rd.CODICE_TRATTA_ROMAN "CodiceRomanDispari"';
   sqlstring := sqlstring ||', rp.CODICE_TRATTA_ROMAN "CodiceRomanPari"';
   sqlstring := sqlstring ||', a.descrizione   "LimiteDiCarico"';
   sqlstring := sqlstring ||', t.codice_dtp "CodiceDTP"';
   sqlstring := sqlstring ||', t.codice_ut "CodiceUT"';
   sqlstring := sqlstring ||' From ';
   sqlstring := sqlstring ||s_schema||'.SEZIONI_LINEA t';
   sqlstring := sqlstring ||' , (Select SEDE_TECNICA, CODICE_TRATTA_PIC,CODICE_LOCALITA_INIZIO_PIC, CODICE_LOCALITA_FINE_PIC,CODICE_CAT_LINEA_MAS_ASS ';
   sqlstring := sqlstring ||' From RINF_ANAGRAFICHE_EVO.tratte_pic ';
   sqlstring := sqlstring ||' Where';
   sqlstring := sqlstring ||' FLAG_DISPARI = 1 ) pic_dispari';
   sqlstring := sqlstring ||' ,(Select SEDE_TECNICA, CODICE_TRATTA_PIC,CODICE_LOCALITA_INIZIO_PIC, CODICE_LOCALITA_FINE_PIC, CODICE_CAT_LINEA_MAS_ASS ';
   sqlstring := sqlstring ||' From RINF_ANAGRAFICHE_EVO.tratte_pic ';
   sqlstring := sqlstring ||' Where';
   sqlstring := sqlstring ||' FLAG_DISPARI = 0 ) pic_pari';
   sqlstring := sqlstring ||',RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN rd ';
   sqlstring := sqlstring ||',RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN rp ';
   sqlstring := sqlstring ||',RINF_ANAGRAFICHE_EVO.ANAG_TIPO_CAT_LIN_MASS_ASS a ';
   sqlstring := sqlstring ||' Where ';
   sqlstring := sqlstring ||'T.SEDE_TECNICA = pic_dispari.sede_tecnica ';
   sqlstring := sqlstring ||'And T.SEDE_TECNICA = pic_pari.sede_tecnica ';
   sqlstring := sqlstring ||'And pic_dispari.CODICE_LOCALITA_INIZIO_PIC = pic_pari.CODICE_LOCALITA_FINE_PIC ';
   sqlstring := sqlstring ||'And pic_dispari.CODICE_LOCALITA_FINE_PIC = pic_pari.CODICE_LOCALITA_INIZIO_PIC ';
   sqlstring := sqlstring ||'And pic_dispari.CODICE_TRATTA_PIC = rd.CODICE_TRATTA_PIC  ';
   sqlstring := sqlstring ||'And pic_pari.CODICE_TRATTA_PIC = rp.CODICE_TRATTA_PIC ';
   sqlstring := sqlstring ||'And rd.CODICE_BRANCH = rp.CODICE_BRANCH ';
   sqlstring := sqlstring ||'And pic_dispari.CODICE_CAT_LINEA_MAS_ASS = a.CODICE_TIPO ';
   IF p_versione IS NOT NULL THEN
      sqlstring := sqlstring||' And t.CODICE_VERSIONE = '||p_versione;
   END IF;

--filtro richiamato dalla funzione ROUTING
IF p_filtro is NOT NULL THEN
sqlstring:=sqlstring ||GetWhereCondition(p_filtro,'t.SEDE_TECNICA');
END IF;

-- sqlstring:=sqlstring||'order by 1';
   OPEN p_cursor FOR sqlstring;
END GetLimiteCaricoTratte;

--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetTratteCorridoi (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.1.4
  s_schema VARCHAR2(100);
  sqlstring VARCHAR2(32767);
  p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione := NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione := p_i_versione;
     END IF;
 END IF;
   sqlstring := 'select distinct ';
   sqlstring := sqlstring||' TO_CHAR (r.CODICE_CORRIDOIO) "CodiceCorridoio", ';
   sqlstring := sqlstring||' r.DEFINIZIONE "SOL_TRACK_1_1_1_1_2_3", ';
   sqlstring := sqlstring||' l.SEDE_TECNICA "CodiceTratta", ';
   sqlstring := sqlstring||' s.DEFINIZIONE "Tratta", ';
   sqlstring := sqlstring||' s.LOCALITA_INIZIO    "LocalitaInizio", ';
   sqlstring := sqlstring||' s.LOCALITA_FINE        "LocalitaFine", ';
   sqlstring := sqlstring||' c.CODICE_GIURISDIZIONE    "CodiceGiurisdizione", ';
   sqlstring := sqlstring||' TO_CHAR(c.INIZIO_VALIDITA,''DD/MM/YYYY'')    "InizioValidita",   ';
   sqlstring := sqlstring||' TO_CHAR(c.DATA_SCADENZA,''DD/MM/YYYY'')         "DataScadenza",     ';
   sqlstring := sqlstring||' p.CODICE_TRATTA_PIC_D "CodiceTrattaPicDispari", ';
   sqlstring := sqlstring||' DECODE (c.FLAG_TITOLARE, 1, ''Si'', ''No'') "TitolareDispari", ';
   sqlstring := sqlstring||' p.CODICE_VIA_D "CodiceViaDispari", ';
   sqlstring := sqlstring||' p.CODICE_LOCALITA_INIZIO_PIC_D "CodiceLocalitaInizioPic", ';
   sqlstring := sqlstring||' LI.NOME_LOCALITA30 "LocalitaInizioPic", ';
   sqlstring := sqlstring||' DECODE (cli.FLAG_TITOLARE, 1, ''Si'', ''No'') "TitolareLI", ';
   sqlstring := sqlstring||' p.CODICE_LOCALITA_FINE_PIC_D "CodiceLocalitaFinePic", ';
   sqlstring := sqlstring||' LF.NOME_LOCALITA30 "LocalitaFinePic", ';
   sqlstring := sqlstring||' DECODE (clf.FLAG_TITOLARE, 1, ''Si'', ''No'') "TitolareLF", ';
   sqlstring := sqlstring||' p.CODICE_TRATTA_PIC_P "CodiceTrattaPicPari", ';
   sqlstring := sqlstring||' p.CODICE_VIA_P "CodiceViaPari" , ';
   sqlstring := sqlstring||' s.codice_dtp "CodiceDTP" , ';
   sqlstring := sqlstring||' s.codice_ut "CodiceUT" , ';
   sqlstring := sqlstring||' s.codice_linea_tecnica "CodiceLineaTecnica"';
   sqlstring := sqlstring||' FROM '||s_schema||'.CORRIDOIO_SOL l, ';
   sqlstring := sqlstring||' RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI t, ';
   sqlstring := sqlstring||' RINF_ANAGRAFICHE_EVO.CORRIDOI_633 r, ';
   sqlstring := sqlstring||  s_schema||'.SEZIONI_LINEA s, ';
   sqlstring := sqlstring||' RINF_ANAGRAFICHE_EVO.V_MAPPING_TRATTE_INRETE_PIC p, ';
   sqlstring := sqlstring||' RINF_ANAGRAFICHE_EVO.CORRIDOIO_TRATTE c, ';
   sqlstring := sqlstring||' RINF_ANAGRAFICHE_EVO.CORRIDOIO_LOCALITA cli, ';
   sqlstring := sqlstring||' RINF_ANAGRAFICHE_EVO.CORRIDOIO_LOCALITA clf, ';
   sqlstring := sqlstring||' RINF_ANAGRAFICHE_EVO.LOCALITA_PIC li, ';
   sqlstring := sqlstring||' RINF_ANAGRAFICHE_EVO.LOCALITA_PIC lf ';
   sqlstring := sqlstring||' Where r.CODICE_CORRIDOIO = t.CODICE_CORRIDOIO_633 ';
   sqlstring := sqlstring||' And l.codice_corridoio = t.CODICE_GIURISDIZIONE ';
   sqlstring := sqlstring||' And c.CODICE_GIURISDIZIONE = l.CODICE_CORRIDOIO ';
   sqlstring := sqlstring||' And s.SEDE_TECNICA = l.SEDE_TECNICA ';
   sqlstring := sqlstring||' And S.SEDE_TECNICA = p.SEDE_TECNICA ';
   sqlstring := sqlstring||' And c.CODICE_TRATTA_PIC = p.CODICE_TRATTA_PIC_D ';
   sqlstring := sqlstring||' And c.DATA_SCADENZA IS NULL ';
   sqlstring := sqlstring||' And cli.CODICE_LOCALITA_PIC = li.CODICE_LOCALITA_PIC ';
   sqlstring := sqlstring||' And clf.CODICE_LOCALITA_PIC = lf.CODICE_LOCALITA_PIC ';
   sqlstring := sqlstring||' And cli.CODICE_LOCALITA_PIC = p.CODICE_LOCALITA_INIZIO_PIC_D ';
   sqlstring := sqlstring||' And clf.CODICE_LOCALITA_PIC = p.CODICE_LOCALITA_FINE_PIC_D ';
   sqlstring := sqlstring||' And cli.CODICE_GIURISDIZIONE = clf.CODICE_GIURISDIZIONE ';
   sqlstring := sqlstring||' And cli.CODICE_GIURISDIZIONE = c.CODICE_GIURISDIZIONE ';
   IF p_versione IS NOT NULL THEN
        sqlstring:=sqlstring||'    AND s.CODICE_VERSIONE = '||p_versione;
        sqlstring:=sqlstring||'    AND l.CODICE_VERSIONE = '||p_versione;
   END IF;

    --filtro richiamato dalla funzione ROUTING
   IF p_filtro is NOT NULL THEN
        sqlstring := sqlstring ||GetWhereCondition(p_filtro, 'l.SEDE_TECNICA');
   END IF;
    --sqlstring:=sqlstring||' order by 1,3';
    OPEN p_cursor FOR sqlstring;
 END GetTratteCorridoi;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
--
 PROCEDURE GetRanghiVelocitaBinario (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.1.5
s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;
d_data_riferimento VARCHAR2(8);
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;

 --14/02/2018 Inserita la data di riferimento in sostituzione della SYSDATE, per contestualizzare
--l'estrazione dei dati validi all'area selezionata
 d_data_riferimento:=TO_CHAR(PKG_RINF_INTERFACCIA.GETDATARIFERIMENTO(p_area,p_i_versione),'DDMMYYYY');

         sqlstring := 'select ';
         sqlstring := sqlstring||' t.sede_tecnica "CodiceTrattaINRETE", ';
         sqlstring := sqlstring||' T.DEFINIZIONE "DefinizioneINRETE", ';
         sqlstring := sqlstring||' t.KM_INIZIO "KmInizioTratta", ';
         sqlstring := sqlstring||' t.KM_FINE "KmFineTratta", ';
         sqlstring := sqlstring||' pic.CODICE_TRATTA_PIC_D "CodicePicDispari", ';
         sqlstring := sqlstring||' pic.CODICE_TRATTA_PIC_P "CodicePicPari", ';
         sqlstring := sqlstring||' rd.CODICE_TRATTA_ROMAN "CodiceRomanDispari", ';
         sqlstring := sqlstring||' rp.CODICE_TRATTA_ROMAN "CodiceRomanPari", ';
         sqlstring := sqlstring||' codice_linea_fcl "CodiceLineaFcl", ';
         sqlstring := sqlstring||' codice_linea_fcl_inversa "CodiceLineaFclInversa", ';
         sqlstring := sqlstring||' linea_fcl "DefinizioneLineaFcl", ';
         sqlstring := sqlstring||' tipo_binario "Binario", ';
         sqlstring := sqlstring||' progressiva_km "ProgressivaChilometrica", ';
         sqlstring := sqlstring||' VMAX_A "RangoA", ';
         sqlstring := sqlstring||' VMAX_B "RangoB", ';
         sqlstring := sqlstring||' VMAX_C "RangoC", ';
         sqlstring := sqlstring||' VMAX_P "RangoP", ';
         sqlstring := sqlstring||' t.codice_dtp "CodiceDTP", ';
         sqlstring := sqlstring||' t.codice_ut "CodiceUT" , ';
         sqlstring := sqlstring||' t.codice_linea_tecnica "CodiceLineaTecnica"  ';
         sqlstring := sqlstring||' FROM '||s_schema||'.SEZIONI_LINEA t, ';
         sqlstring := sqlstring||' RINF_ANAGRAFICHE_EVO.V_MAPPING_TRATTE_INRETE_PIC pic, ';
         sqlstring := sqlstring||' RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN rd, ';
         sqlstring := sqlstring||' RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN rp, ';
         sqlstring := sqlstring||' (SELECT DISTINCT ';
         sqlstring := sqlstring||'         D.CODICE_TRATTA_ROMAN codice_tratta_roman, ';
         sqlstring := sqlstring||'         DECODE (DIREZIONE, ';
         sqlstring := sqlstring||'                 1, ''Binario Dispari'', ';
         sqlstring := sqlstring||'                 2, ''Binario Pari'', ';
         sqlstring := sqlstring||'                 3, ''Binario Unico'') ';
         sqlstring := sqlstring||'            tipo_binario, ';
         sqlstring := sqlstring||'         PROGR_KM progressiva_km, ';
         sqlstring := sqlstring||'         t.CODICE_LINEA_FCL codice_linea_fcl, ';
         sqlstring := sqlstring||'         t.CODICE_LINEA_INVERSA codice_linea_fcl_inversa, ';
         sqlstring := sqlstring||'         t.DEFINIZIONE linea_fcl, ';
         sqlstring := sqlstring||'         DATA_INIZIO_VALIDITA, ';
         sqlstring := sqlstring||'         DAT_FINE_VAL, ';
         sqlstring := sqlstring||'         VMAX_A, ';
         sqlstring := sqlstring||'         VMAX_B, ';
         sqlstring := sqlstring||'         VMAX_C, ';
         sqlstring := sqlstring||'         VMAX_P ';
         sqlstring := sqlstring||'    FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL t, ';
         sqlstring := sqlstring||'         RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN d ';
         sqlstring := sqlstring||'   WHERE     T.CODICE_LINEA_FCL = D.CODICE_LINEA_FCL ';
         sqlstring := sqlstring||'         AND t.FLAG_DISPARI = 1 ';
         sqlstring := sqlstring||'         AND NVL (DATA_INIZIO_VAL_R, TO_DATE (''01011999'', ''DDMMYYYY'')) <= ';
         sqlstring := sqlstring||'                 TO_DATE('''||d_data_riferimento||''',''DDMMYYYY'')' ;
         sqlstring := sqlstring||'         AND NVL (DAT_FINE_VAL, TO_DATE (''01012999'', ''DDMMYYYY'')) >= ';
         sqlstring := sqlstring||'                 TO_DATE('''||d_data_riferimento||''',''DDMMYYYY'')) l_fd ';
         sqlstring := sqlstring||' WHERE     rd.CODICE_TRATTA_ROMAN = l_fd.codice_tratta_roman ';
         sqlstring := sqlstring||' AND T.SEDE_TECNICA = pic.sede_tecnica ';
         sqlstring := sqlstring||' AND pic.CODICE_TRATTA_PIC_D = rd.CODICE_TRATTA_PIC ';
         sqlstring := sqlstring||' AND pic.CODICE_TRATTA_PIC_P = rp.CODICE_TRATTA_PIC ';
         sqlstring := sqlstring||' AND rd.CODICE_BRANCH = rp.CODICE_BRANCH ';
         sqlstring := sqlstring||' AND   NVL (VMAX_A, -1) ';
         sqlstring := sqlstring||'     + NVL (VMAX_B, -1) ';
         sqlstring := sqlstring||'     + NVL (VMAX_C, -1) ';
         sqlstring := sqlstring||'     + NVL (VMAX_P, -1) <> -4 ';
         IF p_versione IS NOT NULL THEN
            sqlstring := sqlstring||'    AND t.CODICE_VERSIONE='||p_versione;
         END IF;

 --filtro richiamato dalla funzione ROUTING
        IF p_filtro is NOT NULL THEN
           sqlstring := sqlstring ||GetWhereCondition(p_filtro,'t.SEDE_TECNICA');
        END IF;
--         sqlstring:=sqlstring||' ORDER BY t.sede_tecnica, ';
--         sqlstring:=sqlstring||' codice_linea_fcl, ';
--         sqlstring:=sqlstring||' tipo_binario, ';
--         sqlstring:=sqlstring||' progressiva_km ';
         OPEN p_cursor FOR sqlstring;

 END GetRanghiVelocitaBinario;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetCorridoioLineaTENBinario (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.1.6
s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;
--
sqlstring:='Select s.SEDE_TECNICA "CodiceTrattaINRETE",  ';
sqlstring:=sqlstring||'s.SOL_TRACK_1_1_1_0_0_1 BINARIO,       ';
sqlstring:=sqlstring||'trim(s.SOL_TRACK_1_1_1_0_0_1_D) DESCRIZIONE,     ';
sqlstring:=sqlstring||'REPLACE(cat_ten.SOL_TRACK_1_1_1_1_2_1_DES,''#'','' + '') SOL_TRACK_1_1_1_1_2_1,  ';
sqlstring:=sqlstring||'REPLACE(cat_ten.SOL_TRACK_1_1_1_1_2_1,''#'','' + '') SOL_TRACK_1_1_1_1_2_1_LOOK,  ';
sqlstring:=sqlstring||'REPLACE(corridoio.SOL_TRACK_1_1_1_1_2_3_DES,''#'','' + '') SOL_TRACK_1_1_1_1_2_3,';
sqlstring:=sqlstring||'REPLACE(corridoio.SOL_TRACK_1_1_1_1_2_3_XML,''#'','' + '') SOL_TRACK_1_1_1_1_2_3_LOOK, ';
sqlstring:=sqlstring||'SL.CODICE_DTP "CodiceDTP",';
sqlstring:=sqlstring||'SL.CODICE_UT "CodiceUT" , ';
sqlstring:=sqlstring||'SL.codice_linea_tecnica "Codice Linea Tecnica" ';
sqlstring:=sqlstring||'from '||s_schema||'.BINARI_CORSA_SOL s,  ';
sqlstring:=sqlstring||'        (SELECT SOL_TRACK_1_1_1_0_0_1, LISTAGG(SOL_TRACK_1_1_1_1_2_1,''#'') ';
sqlstring:=sqlstring||'        WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_1_2_1) AS SOL_TRACK_1_1_1_1_2_1,  ';
sqlstring:=sqlstring||'         LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_XML, ';
sqlstring:=sqlstring||'         LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_OV,  ';
sqlstring:=sqlstring||'         LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_DES ';
sqlstring:=sqlstring||'         from '||s_schema||'.PAR_1_1_1_1_2_1_CAT_TEN_SOL,  ';
sqlstring:=sqlstring||'         RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,  ';
sqlstring:=sqlstring||'         RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
sqlstring:=sqlstring||'         where ';
sqlstring:=sqlstring||'         c.codice_parametro=d.codice_parametro and ';
sqlstring:=sqlstring||'         numero_parametro=''1.1.1.1.2.1'' and ';
sqlstring:=sqlstring||'         SOL_TRACK_1_1_1_1_2_1=CODIFICA_VALORE ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring||'         AND codice_versione = '||p_versione ;
END IF;
sqlstring:=sqlstring||'         group by SOL_TRACK_1_1_1_0_0_1) cat_ten,   ';
sqlstring:=sqlstring||'        (SELECT SEDE_TECNICA, LISTAGG(v.DESCRIZIONE,''#'') WITHIN GROUP (ORDER BY v.DESCRIZIONE) AS SOL_TRACK_1_1_1_1_2_3,  ';
sqlstring:=sqlstring||'         LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_XML, ';
sqlstring:=sqlstring||'         LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_OV, ';
sqlstring:=sqlstring||'         LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_DES ';
sqlstring:=sqlstring||'         from ( ';
sqlstring:=sqlstring||'         select distinct descrizione,sede_tecnica,codice,codice_contesto ';
sqlstring:=sqlstring||'         from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring||'         where codice_versione = '||p_versione;
END IF;
sqlstring:=sqlstring||' ) v,  ';
sqlstring:=sqlstring||'         RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,  ';
sqlstring:=sqlstring||'         RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
sqlstring:=sqlstring||'         where CODICE_CONTESTO=3 and  ';
sqlstring:=sqlstring||'         c.codice_parametro=d.codice_parametro and ';
sqlstring:=sqlstring||'         CODICE||''0''=CODIFICA_VALORE and  ';
sqlstring:=sqlstring||'         numero_parametro=''1.1.1.1.2.3''  ';
sqlstring:=sqlstring||'         group by SEDE_TECNICA) corridoio,   ';
sqlstring:=sqlstring||s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring||'where ';
sqlstring:=sqlstring||'S.SOL_TRACK_1_1_1_0_0_1=cat_ten.SOL_TRACK_1_1_1_0_0_1 (+) and   ';
sqlstring:=sqlstring||'S.SEDE_TECNICA=corridoio.SEDE_TECNICA (+)   AND   ';
sqlstring:=sqlstring||'SL.SEDE_TECNICA =  S.SEDE_TECNICA  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring||'AND s.codice_versione = '||p_versione;
sqlstring:=sqlstring||'AND sl.codice_versione = '||p_versione;
END IF;

--filtro richiamato dalla funzione ROUTING
IF p_filtro is NOT NULL THEN
sqlstring:=sqlstring ||GetWhereCondition(p_filtro,'s.SEDE_TECNICA');
END IF;

--sqlstring:=sqlstring||'order by 1 ';

DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;

END GetCorridoioLineaTENBinario;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
--22/11/2017 Versione Report Completa, con le Linee FCL andata e ritorno (pi  di 8.000 record)
--PROCEDURE GetMDRReport (p_area NUMBER,p_i_versione NUMBER , p_filtro CLOB, p_cursor OUT empcur) IS
----REPORT 3.1.7
--    s_schema VARCHAR2(100);
--    sqlstring VARCHAR2(32767);
--    p_versione NUMBER;
--    s_filtro VARCHAR2(32767);
--
--    BEGIN
--     s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--     --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
--     IF (p_area=1 OR p_area=3) THEN
--      p_versione:=NULL;
--     ELSE  --(p_area=2 OR p_area=4)
--         IF  p_versione IS NULL THEN
--            p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
--         ELSE
--            p_versione:=p_i_versione;
--         END IF;
--     END IF;
--
--        sqlstring:='SELECT               ';              --tabella esterna insertita per fare l'ORDER del ROUTING
--        sqlstring:=sqlstring||'"NOME_DTP"                 ,';
--        sqlstring:=sqlstring||'"FascicoloLinea"           ,';
--        sqlstring:=sqlstring||'"CodiceLineaFclSkt"        ,';
--        sqlstring:=sqlstring||'"DefinizioneLineaFclSkt"   ,';
--        sqlstring:=sqlstring||'"InizioValidita"           ,';
--        sqlstring:=sqlstring||'"FineValidita"             ,';
--        sqlstring:=sqlstring||'"CodiceLineaFclInversaSkt" ,';
--        sqlstring:=sqlstring||'"ProgressivoTratta"        ,';
--        sqlstring:=sqlstring||'CodiceTrattaIne "CodiceTrattaIne"          ,';
--        sqlstring:=sqlstring||'"TrattaIne"                ,';
--        sqlstring:=sqlstring||'"CodiceTrattaPicDis"       ,';
--        sqlstring:=sqlstring||'"CodiceTrattaPicPar"       ,';
--        sqlstring:=sqlstring||'"KmSktDa"                  ,';
--        sqlstring:=sqlstring||'"CodiceLoSktDa"            ,';
--        sqlstring:=sqlstring||'"CodiceLoIneDa"            ,';
--        sqlstring:=sqlstring||'"CodiceLoItDa"             ,';
--        sqlstring:=sqlstring||'"CodiceLoTsiDa"            ,';
--        sqlstring:=sqlstring||'"CodiceLoPicDa"            ,';
--        sqlstring:=sqlstring||'"Localita16Da"             ,';
--        sqlstring:=sqlstring||'"TipoLoDa"                 ,';
--        sqlstring:=sqlstring||'"KmSktA"                   ,';
--        sqlstring:=sqlstring||'"CodiceLoSktA"             ,';
--        sqlstring:=sqlstring||'"CodiceLoIneA"             ,';
--        sqlstring:=sqlstring||'"CodiceLoItA"              ,';
--        sqlstring:=sqlstring||'"CodiceLoTsiA"             ,';
--        sqlstring:=sqlstring||'"CodiceLoPicA"             ,';
--        sqlstring:=sqlstring||'"Localita16A"              ,';
--        sqlstring:=sqlstring||'"TipoLoA"                  ,';
--        sqlstring:=sqlstring||'"Via"                      ,';
--        sqlstring:=sqlstring||'"TipoBlocco"               ,';
--        sqlstring:=sqlstring||'"Banalizzato"              ,';
--        sqlstring:=sqlstring||'"RangoASkt"                ,';
--        sqlstring:=sqlstring||'"RangoBSkt"                ,';
--        sqlstring:=sqlstring||'"RangoCSkt"                ,';
--        sqlstring:=sqlstring||'"RangoPSkt"                ,';
--        sqlstring:=sqlstring||'"TipoEsercizio"            ,';
--        sqlstring:=sqlstring||'"Lunghezza"                ,';
--        sqlstring:=sqlstring||'"Binario"                  ,';
--        sqlstring:=sqlstring||'"TipoTrazione"             ,';
--        sqlstring:=sqlstring||'"Corridoi"                 ,';
--        sqlstring:=sqlstring||'"Commerciali"              ,';
--        sqlstring:=sqlstring||'"Regione"                  ,';
--        sqlstring:=sqlstring||'"RegimeCirc"               ,';
--        sqlstring:=sqlstring||'"PesoAssiale" ';
--        sqlstring:=sqlstring||'FROM       ';
--        sqlstring:=sqlstring||'( ';
--        --
--        --21/11/2017 Modificata query dopo la segnalazione di Schillaci che non tutte le tratte erano presenti nel report. Molte join sono stare trasformate in outer join
--        sqlstring:=sqlstring||' SELECT DISTINCT ';
--        sqlstring:=sqlstring||'        s.CODICE_DTP "NOME_DTP", ';
--        sqlstring:=sqlstring||'        f.FASCICOLO_LINEA "FascicoloLinea", ';
--        sqlstring:=sqlstring||'        fcl_all_dati.CODICE_LINEA_FCL "CodiceLineaFclSkt", ';
--        sqlstring:=sqlstring||'        fcl_all_dati.DEFINIZIONE "DefinizioneLineaFclSkt", ';
--        sqlstring:=sqlstring||'        fcl_all_dati.DATA_INIZIO_VALIDITA "InizioValidita", ';
--        sqlstring:=sqlstring||'        fcl_all_dati.DAT_FINE_VAL "FineValidita", ';
--        sqlstring:=sqlstring||'        fcl_all_dati.CODICE_LINEA_INVERSA "CodiceLineaFclInversaSkt", ';
--        sqlstring:=sqlstring||'        fcl_all_dati.PROG_TRATTA "ProgressivoTratta", ';
--        sqlstring:=sqlstring||'        s.SEDE_TECNICA CodiceTrattaIne, ';
--        sqlstring:=sqlstring||'        s.DEFINIZIONE "TrattaIne", ';
--        sqlstring:=sqlstring||'        trat_pic.CODICE_TRATTA_PIC_D "CodiceTrattaPicDis", ';
--        sqlstring:=sqlstring||'        trat_pic.CODICE_TRATTA_PIC_P "CodiceTrattaPicPar", ';
--        sqlstring:=sqlstring||'        fcl_all_dati.prog_inizio_skt "KmSktDa", ';
--        sqlstring:=sqlstring||'        LO_IN_PIC.CODICE_LOCALITA_MIR "CodiceLoSktDa", ';
--        sqlstring:=sqlstring||'        NVL (po_i.SEDE_TECNICA, ''-'') "CodiceLoIneDa", ';
--        sqlstring:=sqlstring||'        NVL (po_i.PO_1_2_0_0_0_2, ''-'') "CodiceLoItDa", ';
--        sqlstring:=sqlstring||'        NVL (codice_taf_tap_i.codice, ''-'') "CodiceLoTsiDa", ';
--        sqlstring:=sqlstring||'        trat_pic.CODICE_LOCALITA_INIZIO_PIC_D "CodiceLoPicDa", ';
--        sqlstring:=sqlstring||'        LO_IN_PIC.NOME_LOCALITA16 "Localita16Da", ';
--        sqlstring:=sqlstring||'        TIP_LOC_ROM_IN.SIGLA_TIPO "TipoLoDa", ';
--        sqlstring:=sqlstring||'        fcl_all_dati.prog_fine_skt "KmSktA", ';
--        sqlstring:=sqlstring||'        LO_FIN_PIC.CODICE_LOCALITA_MIR "CodiceLoSktA", ';
--        sqlstring:=sqlstring||'        NVL (po_f.SEDE_TECNICA, ''-'') "CodiceLoIneA", ';
--        sqlstring:=sqlstring||'        NVL (po_f.PO_1_2_0_0_0_2, ''-'') "CodiceLoItA", ';
--        sqlstring:=sqlstring||'        NVL (codice_taf_tap_f.codice, ''-'') "CodiceLoTsiA", ';
--        sqlstring:=sqlstring||'        trat_pic.CODICE_LOCALITA_FINE_PIC_D "CodiceLoPicA", ';
--        sqlstring:=sqlstring||'        LO_FIN_PIC.NOME_LOCALITA16 "Localita16A", ';
--        sqlstring:=sqlstring||'        TIP_LOC_ROM_FIN.SIGLA_TIPO "TipoLoA", ';
--        sqlstring:=sqlstring||'        TRAT_PIC.CODICE_VIA_D "Via", ';
--        sqlstring:=sqlstring||'        TIPO_BLOCCO_PIC.DESCRIZIONE "TipoBlocco", ';
--        sqlstring:=sqlstring||'        DECODE (INSTR (UPPER (TIPO_BLOCCO_PIC.DESCRIZIONE), ''BANALIZZATO''), ';
--        sqlstring:=sqlstring||'                0, ''NO'', ';
--        sqlstring:=sqlstring||'                ''SI'') ';
--        sqlstring:=sqlstring||'           "Banalizzato", ';
--        sqlstring:=sqlstring||'        FCLD_VMAX_A "RangoASkt", ';
--        sqlstring:=sqlstring||'        FCLD_VMAX_B "RangoBSkt", ';
--        sqlstring:=sqlstring||'        FCLD_VMAX_C "RangoCSkt", ';
--        sqlstring:=sqlstring||'        FCLD_VMAX_P "RangoPSkt", ';
--        sqlstring:=sqlstring||'        tipo_esercizio_pic.DESCRIZIONE "TipoEsercizio", ';
--        sqlstring:=sqlstring||'        TRAT_ROMAN.LUNGHEZZA "Lunghezza", ';
--        sqlstring:=sqlstring||'        DECODE (fcl_all_dati.DIREZIONE,  1, ''DIS'',  2, ''PAR'',  ''UNI'') ';
--        sqlstring:=sqlstring||'           "Binario", ';
--        sqlstring:=sqlstring||'        TIPO_TRAZIONE_PIC.DESCRIZIONE "TipoTrazione", ';
--        sqlstring:=sqlstring||'        corridoi.corridoio "Corridoi", ';
--        sqlstring:=sqlstring||'        linea_comm.linea "Commerciali", ';
--        sqlstring:=sqlstring||'        regione_roman.SIGLA "Regione", ';
--        sqlstring:=sqlstring||'        S.REGIME_CIRCOLAZIONE "RegimeCirc", ';
--        sqlstring:=sqlstring||'        PESO_ASSIALE_PIC.DESCRIZIONE "PesoAssiale" ';
--        sqlstring:=sqlstring||'   FROM '||s_schema||'.SEZIONI_LINEA s, ';
--        sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI po_i, ';
--        sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI po_f, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.V_MAPPING_TRATTE_INRETE_PIC trat_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN trat_roman, ';
--        sqlstring:=sqlstring||'        (SELECT FASCICOLO_LINEA, CODICE_LINEA_FCL ';
--        sqlstring:=sqlstring||'           FROM RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE a, ';
--        sqlstring:=sqlstring||'                RINF_ANAGRAFICHE_EVO.FASCICOLO_LINEE_FCL fl ';
--        sqlstring:=sqlstring||'          WHERE a.CODICE_FASCICOLO = fl.CODICE_FASCICOLO ';
--        --sqlstring:=sqlstring||'          AND FLAG_DISPARI=1 ';
--        sqlstring:=sqlstring||'          AND fl.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'          AND a.DATA_SCADENZA IS NULL) f, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.localita_roman loc_rom_in, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.localita_roman loc_rom_fin, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN tip_loc_rom_in, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN tip_loc_rom_fin, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.localita_PIC lo_in_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.localita_PIC lo_fin_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOCALITA, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_BLOCCO tipo_blocco_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAZIONE tipo_trazione_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_REGIONE_ROMAN regione_roman, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_ESERCIZIO tipo_esercizio_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TRASPORTO_COMBINATO trasporto_comb_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_CAT_LIN_MASS_ASS peso_assiale_pic, ';
--        sqlstring:=sqlstring||'        (  SELECT SEDE_TECNICA, ';
--        sqlstring:=sqlstring||'                  LISTAGG (REPLACE (CODICE, '' '', '''') || '' '') ';
--        sqlstring:=sqlstring||'                     WITHIN GROUP (ORDER BY CODICE) ';
--        sqlstring:=sqlstring||'                     AS linea ';
--        sqlstring:=sqlstring||'             FROM '||s_schema||'.V_MDR_LINEE_COMMERCIALI ';
--        IF p_versione IS NOT NULL THEN
--                sqlstring:=sqlstring||'    WHERE CODICE_VERSIONE='||p_versione;
--        END IF;
--        sqlstring:=sqlstring||'         GROUP BY SEDE_TECNICA) linea_comm, ';
--        sqlstring:=sqlstring||'        (SELECT FCL_TRAT_ROMAN.CODICE_TRATTA_ROMAN, ';
--        sqlstring:=sqlstring||'                t.CODICE_LINEA_FCL, ';
--        sqlstring:=sqlstring||'                t.DEFINIZIONE, ';
--        sqlstring:=sqlstring||'                TO_CHAR (t.DATA_INIZIO_VALIDITA, ''DD/MM/YYYY'') ';
--        sqlstring:=sqlstring||'                   DATA_INIZIO_VALIDITA, ';
--        sqlstring:=sqlstring||'                TO_CHAR (t.DAT_FINE_VAL, ''DD/MM/YYYY'') DAT_FINE_VAL, ';
--        sqlstring:=sqlstring||'                T.CODICE_LINEA_INVERSA, ';
--        sqlstring:=sqlstring||'                FCL_TRAT_ROMAN.PROG_TRATTA, ';
--        sqlstring:=sqlstring||'                FCLD_VMAX_A, ';
--        sqlstring:=sqlstring||'                FCLD_VMAX_B, ';
--        sqlstring:=sqlstring||'                FCLD_VMAX_C, ';
--        sqlstring:=sqlstring||'                FCLD_VMAX_P, ';
--        sqlstring:=sqlstring||'                l_fd.DIREZIONE, ';
--        sqlstring:=sqlstring||'                fcl_dati.prog_inizio_skt, ';
--        sqlstring:=sqlstring||'                fcl_dati.prog_fine_skt ';
--        sqlstring:=sqlstring||'           FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL t, ';
--        sqlstring:=sqlstring||'                RINF_ANAGRAFICHE_EVO.LINEA_FCL_TRATTE_ROMAN fcl_trat_roman, ';
--        sqlstring:=sqlstring||'                (SELECT DISTINCT ';
--        sqlstring:=sqlstring||'                        D.CODICE_TRATTA_ROMAN codice_tratta_roman, ';
--        sqlstring:=sqlstring||'                        t.CODICE_LINEA_FCL codice_linea_fcl, ';
--        sqlstring:=sqlstring||'                        t.CODICE_LINEA_INVERSA codice_linea_fcl_inversa, ';
--        sqlstring:=sqlstring||'                        t.DEFINIZIONE linea_fcl, ';
--        sqlstring:=sqlstring||'                        DATA_INIZIO_VALIDITA, ';
--        sqlstring:=sqlstring||'                        DAT_FINE_VAL, ';
--        sqlstring:=sqlstring||'                        DIREZIONE, ';
--        sqlstring:=sqlstring||'                        VMAX_A FCLD_VMAX_A, ';
--        sqlstring:=sqlstring||'                        VMAX_B FCLD_VMAX_B, ';
--        sqlstring:=sqlstring||'                        VMAX_C FCLD_VMAX_C, ';
--        sqlstring:=sqlstring||'                        VMAX_P FCLD_VMAX_P ';
--        sqlstring:=sqlstring||'                   FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL t, ';
--        sqlstring:=sqlstring||'                        RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN d ';
--        sqlstring:=sqlstring||'                  WHERE     T.CODICE_LINEA_FCL = D.CODICE_LINEA_FCL ';
--        sqlstring:=sqlstring||'                        AND t.FLAG_DISPARI = 1 ';
--        sqlstring:=sqlstring||'                        AND D.TIPO_PUNTO = 1 ';
--        sqlstring:=sqlstring||'                        AND D.DIREZIONE IN (1, 3) ';
--        sqlstring:=sqlstring||'                        AND NVL (DATA_INIZIO_VAL_R, ';
--        sqlstring:=sqlstring||'                                 TO_DATE (''01011999'', ''DDMMYYYY'')) <= SYSDATE ';
--        sqlstring:=sqlstring||'                        AND NVL (DAT_FINE_VAL, ';
--        sqlstring:=sqlstring||'                                 TO_DATE (''01012999'', ''DDMMYYYY'')) >= SYSDATE) l_fd, ';
--        sqlstring:=sqlstring||'                (SELECT DISTINCT di.CODICE_LINEA_FCL, ';
--        sqlstring:=sqlstring||'                                 di.CODICE_TRATTA_ROMAN, ';
--        sqlstring:=sqlstring||'                                 di.PROGR_KM prog_inizio_skt, ';
--        sqlstring:=sqlstring||'                                 df.PROGR_KM prog_fine_skt ';
--        sqlstring:=sqlstring||'                   FROM RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN di, ';
--        sqlstring:=sqlstring||'                        RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN df ';
--        sqlstring:=sqlstring||'                  WHERE     di.tipo_punto = 1 ';
--        sqlstring:=sqlstring||'                        AND df.tipo_punto = 2 ';
--        sqlstring:=sqlstring||'                        AND di.CODICE_LINEA_FCL = df.CODICE_LINEA_FCL ';
--        sqlstring:=sqlstring||'                        AND di.CODICE_TRATTA_ROMAN = df.CODICE_TRATTA_ROMAN ';
--        sqlstring:=sqlstring||'                        AND Di.DIREZIONE IN (1, 3) ';
--        sqlstring:=sqlstring||'                        AND Df.DIREZIONE IN (1, 3)) fcl_dati ';
--        sqlstring:=sqlstring||'          WHERE     fcl_trat_roman.CODICE_LINEA_FCL = T.CODICE_LINEA_FCL ';
--        sqlstring:=sqlstring||'                AND fcl_trat_roman.CODICE_LINEA_FCL = l_fd.CODICE_LINEA_FCL(+) ';
--        sqlstring:=sqlstring||'                AND fcl_trat_roman.CODICE_TRATTA_ROMAN = ';
--        sqlstring:=sqlstring||'                       l_fd.CODICE_TRATTA_ROMAN(+) ';
--        sqlstring:=sqlstring||'                AND fcl_trat_roman.CODICE_LINEA_FCL = ';
--        sqlstring:=sqlstring||'                       fcl_dati.CODICE_LINEA_FCL(+) ';
--        sqlstring:=sqlstring||'                AND fcl_trat_roman.CODICE_TRATTA_ROMAN = ';
--        sqlstring:=sqlstring||'                       fcl_dati.CODICE_TRATTA_ROMAN(+) ';
--        sqlstring:=sqlstring||'                AND NVL (t.DATA_INIZIO_VAL_R, ';
--        sqlstring:=sqlstring||'                         TO_DATE (''01011999'', ''DDMMYYYY'')) <= SYSDATE ';
--        sqlstring:=sqlstring||'                AND NVL (t.DAT_FINE_VAL, TO_DATE (''01012999'', ''DDMMYYYY'')) >= ';
--        sqlstring:=sqlstring||'                       SYSDATE) fcl_all_dati, ';
--        sqlstring:=sqlstring||'        (  SELECT CODICE_TRATTA_PIC, ';
--        sqlstring:=sqlstring||'                  LISTAGG (DEFINIZIONE || '' '') ';
--        sqlstring:=sqlstring||'                     WITHIN GROUP (ORDER BY DEFINIZIONE) ';
--        sqlstring:=sqlstring||'                     AS corridoio ';
--        sqlstring:=sqlstring||'             FROM RINF_ANAGRAFICHE_EVO.CORRIDOIO_TRATTE l, ';
--        sqlstring:=sqlstring||'                  RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI t, ';
--        sqlstring:=sqlstring||'                  RINF_ANAGRAFICHE_EVO.CORRIDOI_633 r ';
--        sqlstring:=sqlstring||'            WHERE     r.CODICE_CORRIDOIO = t.CODICE_CORRIDOIO_633 ';
--        sqlstring:=sqlstring||'                  AND l.CODICE_GIURISDIZIONE = t.CODICE_GIURISDIZIONE ';
--        sqlstring:=sqlstring||'                  AND l.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'         GROUP BY CODICE_TRATTA_PIC) corridoi, ';
--        sqlstring:=sqlstring||'        (  SELECT v.SEDE_TECNICA, ';
--        sqlstring:=sqlstring||'                  LISTAGG (PO_1_2_0_0_0_3, ''-'') ';
--        sqlstring:=sqlstring||'                     WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3) ';
--        sqlstring:=sqlstring||'                     AS codice ';
--        sqlstring:=sqlstring||'             FROM '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v, ';
--        sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI p ';
--        sqlstring:=sqlstring||'            WHERE p.sede_tecnica = v.sede_tecnica ';
--        IF p_versione IS NOT NULL THEN
--                sqlstring:=sqlstring||'    AND p.CODICE_VERSIONE='||p_versione;
--                sqlstring:=sqlstring||'    AND v.CODICE_VERSIONE='||p_versione;
--        END IF;
--        sqlstring:=sqlstring||'         GROUP BY v.SEDE_TECNICA) codice_taf_tap_i, ';
--        sqlstring:=sqlstring||'        (  SELECT v.SEDE_TECNICA, ';
--        sqlstring:=sqlstring||'                  LISTAGG (PO_1_2_0_0_0_3, ''-'') ';
--        sqlstring:=sqlstring||'                     WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3) ';
--        sqlstring:=sqlstring||'                     AS codice ';
--        sqlstring:=sqlstring||'             FROM '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v, ';
--        sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI p ';
--        sqlstring:=sqlstring||'            WHERE p.sede_tecnica = v.sede_tecnica ';
--        IF p_versione IS NOT NULL THEN
--                sqlstring:=sqlstring||'    AND p.CODICE_VERSIONE='||p_versione;
--                sqlstring:=sqlstring||'    AND v.CODICE_VERSIONE='||p_versione;
--        END IF;
--        sqlstring:=sqlstring||'         GROUP BY v.SEDE_TECNICA) codice_taf_tap_f ';
--        sqlstring:=sqlstring||'  WHERE     s.SEDE_TECNICA = trat_pic.SEDE_TECNICA ';
--        sqlstring:=sqlstring||'        AND codice_taf_tap_i.SEDE_TECNICA(+) = po_i.SEDE_TECNICA ';
--        sqlstring:=sqlstring||'        AND codice_taf_tap_f.SEDE_TECNICA(+) = po_f.SEDE_TECNICA ';
--        sqlstring:=sqlstring||'        AND fcl_all_dati.CODICE_LINEA_FCL = F.CODICE_LINEA_FCL(+) ';
--        sqlstring:=sqlstring||'        AND TRAT_ROMAN.CODICE_TRATTA_ROMAN = ';
--        sqlstring:=sqlstring||'               fcl_all_dati.CODICE_TRATTA_ROMAN(+) ';
--        sqlstring:=sqlstring||'        AND TRAT_ROMAN.CODICE_TRATTA_PIC = TRAT_PIC.CODICE_TRATTA_PIC_D ';
--        sqlstring:=sqlstring||'        AND trat_pic.CODICE_LOCALITA_INIZIO_PIC_D = ';
--        sqlstring:=sqlstring||'               LO_IN_PIC.CODICE_LOCALITA_PIC ';
--        sqlstring:=sqlstring||'        AND trat_pic.CODICE_LOCALITA_FINE_PIC_D = ';
--        sqlstring:=sqlstring||'               LO_FIN_PIC.CODICE_LOCALITA_PIC ';
--        sqlstring:=sqlstring||'        AND loc_rom_in.CODICE_LOCALITA_PIC = LO_IN_PIC.CODICE_LOCALITA_PIC ';
--        sqlstring:=sqlstring||'        AND loc_rom_fin.CODICE_LOCALITA_PIC = LO_FIN_PIC.CODICE_LOCALITA_PIC ';
--        sqlstring:=sqlstring||'        AND LO_IN_PIC.COD_LOCALITA_IN_RETE = po_i.SEDE_TECNICA(+) ';
--        sqlstring:=sqlstring||'        AND LO_FIN_PIC.COD_LOCALITA_IN_RETE = po_f.SEDE_TECNICA(+) ';
--        sqlstring:=sqlstring||'        AND TIP_LOC_ROM_IN.TIPO_LOCALITA = loc_rom_in.tipo_localita ';
--        sqlstring:=sqlstring||'        AND TIP_LOC_ROM_FIN.TIPO_LOCALITA = loc_rom_fin.tipo_localita ';
--        sqlstring:=sqlstring||'        AND TIPO_BLOCCO_PIC.CODICE_TIPO(+) = TRAT_PIC.CODICE_TIPO_BLOCCO_D ';
--        sqlstring:=sqlstring||'        AND TIPO_BLOCCO_PIC.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'        AND TIPO_TRAZIONE_PIC.CODICE_TIPO(+) = TRAT_PIC.CODICE_TIPOTRAZIONE_D ';
--        sqlstring:=sqlstring||'        AND TIPO_TRAZIONE_PIC.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'        AND TRAT_ROMAN.CODICE_REGIONE = regione_roman.CODICE_REGIONE (+) ';
--        sqlstring:=sqlstring||'        AND regione_roman.data_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'        AND linea_comm.SEDE_TECNICA = s.SEDE_TECNICA ';
--        sqlstring:=sqlstring||'        AND tipo_esercizio_pic.CODICE_TIPO(+) = ';
--        sqlstring:=sqlstring||'               TRAT_PIC.CODICE_TIPO_ESERCIZIO_D ';
--        sqlstring:=sqlstring||'        AND TIPO_ESERCIZIO_PIC.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'        AND TRASPORTO_COMB_PIC.CODICE_TRASPORTO(+) = ';
--        sqlstring:=sqlstring||'               TRAT_PIC.CODICE_TIPO_TRASP_COMBINATO1_D ';
--        sqlstring:=sqlstring||'        AND TRASPORTO_COMB_PIC.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'        AND PESO_ASSIALE_PIC.CODICE_TIPO(+) = ';
--        sqlstring:=sqlstring||'               TRAT_PIC.CODICE_CAT_LINEA_MAS_ASS_D ';
--        sqlstring:=sqlstring||'        AND PESO_ASSIALE_PIC.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'        AND TRAT_PIC.CODICE_TRATTA_PIC_D = corridoi.CODICE_TRATTA_PIC(+) ';
--        IF p_versione IS NOT NULL THEN
--        sqlstring:=sqlstring||'    AND s.CODICE_VERSIONE='||p_versione;
--        sqlstring:=sqlstring||'    AND po_i.CODICE_VERSIONE='||p_versione;
--        sqlstring:=sqlstring||'    AND po_f.CODICE_VERSIONE='||p_versione;
--        END IF;
--
--        --filtro richiamato dalla funzione ROUTING in due punti in questa procedura (1/2)
--        IF p_filtro is NOT NULL THEN
--        s_filtro:=UPPER(GetWhereCondition(p_filtro,'s.SEDE_TECNICA'));
--        sqlstring:=sqlstring ||substr(s_filtro,1,instr(s_filtro,'ORDER')-1);--siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
--        END IF;
--
--        sqlstring:=sqlstring||' UNION ';
--        sqlstring:=sqlstring||' SELECT DISTINCT ';
--        sqlstring:=sqlstring||'        s.CODICE_DTP CODICEDTP, ';
--        sqlstring:=sqlstring||'        f.FASCICOLO_LINEA FL, ';
--        sqlstring:=sqlstring||'        fcl_all_dati.CODICE_LINEA_FCL, ';
--        sqlstring:=sqlstring||'        fcl_all_dati.DEFINIZIONE LINEA_FCL, ';
--        sqlstring:=sqlstring||'        fcl_all_dati.DATA_INIZIO_VALIDITA, ';
--        sqlstring:=sqlstring||'        fcl_all_dati.DAT_FINE_VAL, ';
--        sqlstring:=sqlstring||'        fcl_all_dati.CODICE_LINEA_INVERSA, ';
--        sqlstring:=sqlstring||'        fcl_all_dati.PROG_TRATTA, ';
--        sqlstring:=sqlstring||'        s.SEDE_TECNICA, ';
--        sqlstring:=sqlstring||'        s.DEFINIZIONE DEF_SEDE_TECNICA, ';
--        sqlstring:=sqlstring||'        trat_pic.CODICE_TRATTA_PIC_P, ';
--        sqlstring:=sqlstring||'        trat_pic.CODICE_TRATTA_PIC_D, ';
--        sqlstring:=sqlstring||'        fcl_all_dati.prog_inizio_skt, ';
--        sqlstring:=sqlstring||'        LO_IN_PIC.CODICE_LOCALITA_MIR, ';
--        sqlstring:=sqlstring||'        NVL (po_i.SEDE_TECNICA, ''-'') CODICE_LOCALITA_INRETE, ';
--        sqlstring:=sqlstring||'        NVL (po_i.PO_1_2_0_0_0_2, ''-'') PO_1_2_0_0_0_2, ';
--        sqlstring:=sqlstring||'        NVL (codice_taf_tap_i.codice, ''-'') PO_1_2_0_0_0_3, ';
--        sqlstring:=sqlstring||'        trat_pic.CODICE_LOCALITA_INIZIO_PIC_D INIZIO_PIC, ';
--        sqlstring:=sqlstring||'        LO_IN_PIC.NOME_LOCALITA16, ';
--        sqlstring:=sqlstring||'        TIP_LOC_ROM_IN.SIGLA_TIPO, ';
--        sqlstring:=sqlstring||'        fcl_all_dati.prog_fine_skt, ';
--        sqlstring:=sqlstring||'        LO_FIN_PIC.CODICE_LOCALITA_MIR, ';
--        sqlstring:=sqlstring||'        NVL (po_f.SEDE_TECNICA, ''-'') CODICE_LOCALITA_INRETE, ';
--        sqlstring:=sqlstring||'        NVL (po_f.PO_1_2_0_0_0_2, ''-'') PO_1_2_0_0_0_2, ';
--        sqlstring:=sqlstring||'        NVL (codice_taf_tap_f.codice, ''-'') PO_1_2_0_0_0_3, ';
--        sqlstring:=sqlstring||'        trat_pic.CODICE_LOCALITA_FINE_PIC_P FINE_PIC, ';
--        sqlstring:=sqlstring||'        LO_FIN_PIC.NOME_LOCALITA16, ';
--        sqlstring:=sqlstring||'        TIP_LOC_ROM_FIN.SIGLA_TIPO, ';
--        sqlstring:=sqlstring||'        TRAT_PIC.CODICE_VIA_P, ';
--        sqlstring:=sqlstring||'        TIPO_BLOCCO_PIC.DESCRIZIONE TIPO_BLOCCO, ';
--        sqlstring:=sqlstring||'        DECODE (INSTR (UPPER (TIPO_BLOCCO_PIC.DESCRIZIONE), ''BANALIZZATO''), ';
--        sqlstring:=sqlstring||'                0, ''NO'', ';
--        sqlstring:=sqlstring||'                ''SI'') ';
--        sqlstring:=sqlstring||'           BANALIZZATO, ';
--        sqlstring:=sqlstring||'        FCLD_VMAX_A, ';
--        sqlstring:=sqlstring||'        FCLD_VMAX_B, ';
--        sqlstring:=sqlstring||'        FCLD_VMAX_C, ';
--        sqlstring:=sqlstring||'        FCLD_VMAX_P, ';
--        sqlstring:=sqlstring||'        tipo_esercizio_pic.DESCRIZIONE TIP_ESERCIZIO, ';
--        sqlstring:=sqlstring||'        TRAT_ROMAN.LUNGHEZZA, ';
--        sqlstring:=sqlstring||'        DECODE (fcl_all_dati.DIREZIONE,  1, ''DIS'',  2, ''PAR'',  ''UNI'') BINARIO, ';
--        sqlstring:=sqlstring||'        TIPO_TRAZIONE_PIC.DESCRIZIONE TIPO_TRAZIONE, ';
--        sqlstring:=sqlstring||'        corridoi.corridoio, ';
--        sqlstring:=sqlstring||'        linea_comm.linea, ';
--        sqlstring:=sqlstring||'        regione_roman.SIGLA REGIONE, ';
--        sqlstring:=sqlstring||'        S.REGIME_CIRCOLAZIONE, ';
--        sqlstring:=sqlstring||'        PESO_ASSIALE_PIC.DESCRIZIONE peso_assiale ';
--        sqlstring:=sqlstring||'   FROM '||s_schema||'.SEZIONI_LINEA s, ';
--        sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI po_i, ';
--        sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI po_f, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.V_MAPPING_TRATTE_INRETE_PIC trat_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN trat_roman, ';
--        sqlstring:=sqlstring||'        (SELECT FASCICOLO_LINEA, CODICE_LINEA_FCL ';
--        sqlstring:=sqlstring||'           FROM RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE a, ';
--        sqlstring:=sqlstring||'                RINF_ANAGRAFICHE_EVO.FASCICOLO_LINEE_FCL fl ';
--        sqlstring:=sqlstring||'          WHERE a.CODICE_FASCICOLO = fl.CODICE_FASCICOLO ';
--        --sqlstring:=sqlstring||'          AND FLAG_DISPARI=1 ';
--        sqlstring:=sqlstring||'          AND fl.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'          AND a.DATA_SCADENZA IS NULL) f, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.localita_roman loc_rom_in, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.localita_roman loc_rom_fin, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN tip_loc_rom_in, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN tip_loc_rom_fin, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.localita_PIC lo_in_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.localita_PIC lo_fin_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOCALITA, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_BLOCCO tipo_blocco_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAZIONE tipo_trazione_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_REGIONE_ROMAN regione_roman, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_ESERCIZIO tipo_esercizio_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TRASPORTO_COMBINATO trasporto_comb_pic, ';
--        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_CAT_LIN_MASS_ASS peso_assiale_pic, ';
--        sqlstring:=sqlstring||'        (  SELECT SEDE_TECNICA, ';
--        sqlstring:=sqlstring||'                  LISTAGG (REPLACE (CODICE, '' '', '''') || '' '') ';
--        sqlstring:=sqlstring||'                     WITHIN GROUP (ORDER BY CODICE) ';
--        sqlstring:=sqlstring||'                     AS linea ';
--        sqlstring:=sqlstring||'             FROM '||s_schema||'.V_MDR_LINEE_COMMERCIALI ';
--        IF p_versione IS NOT NULL THEN
--                sqlstring:=sqlstring||'    WHERE CODICE_VERSIONE='||p_versione;
--        END IF;
--        sqlstring:=sqlstring||'         GROUP BY SEDE_TECNICA) linea_comm, ';
--        sqlstring:=sqlstring||'        (SELECT FCL_TRAT_ROMAN.CODICE_TRATTA_ROMAN, ';
--        sqlstring:=sqlstring||'                t.CODICE_LINEA_FCL, ';
--        sqlstring:=sqlstring||'                t.DEFINIZIONE, ';
--        sqlstring:=sqlstring||'                TO_CHAR (t.DATA_INIZIO_VALIDITA, ''DD/MM/YYYY'') ';
--        sqlstring:=sqlstring||'                   DATA_INIZIO_VALIDITA, ';
--        sqlstring:=sqlstring||'                TO_CHAR (t.DAT_FINE_VAL, ''DD/MM/YYYY'') DAT_FINE_VAL, ';
--        sqlstring:=sqlstring||'                T.CODICE_LINEA_INVERSA, ';
--        sqlstring:=sqlstring||'                FCL_TRAT_ROMAN.PROG_TRATTA, ';
--        sqlstring:=sqlstring||'                FCLD_VMAX_A, ';
--        sqlstring:=sqlstring||'                FCLD_VMAX_B, ';
--        sqlstring:=sqlstring||'                FCLD_VMAX_C, ';
--        sqlstring:=sqlstring||'                FCLD_VMAX_P, ';
--        sqlstring:=sqlstring||'                l_fd.DIREZIONE, ';
--        sqlstring:=sqlstring||'                fcl_dati.prog_inizio_skt, ';
--        sqlstring:=sqlstring||'                fcl_dati.prog_fine_skt ';
--        sqlstring:=sqlstring||'           FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL t, ';
--        sqlstring:=sqlstring||'                RINF_ANAGRAFICHE_EVO.LINEA_FCL_TRATTE_ROMAN fcl_trat_roman, ';
--        sqlstring:=sqlstring||'                (SELECT DISTINCT ';
--        sqlstring:=sqlstring||'                        D.CODICE_TRATTA_ROMAN codice_tratta_roman, ';
--        sqlstring:=sqlstring||'                        t.CODICE_LINEA_FCL codice_linea_fcl, ';
--        sqlstring:=sqlstring||'                        t.CODICE_LINEA_INVERSA codice_linea_fcl_inversa, ';
--        sqlstring:=sqlstring||'                        t.DEFINIZIONE linea_fcl, ';
--        sqlstring:=sqlstring||'                        DATA_INIZIO_VALIDITA, ';
--        sqlstring:=sqlstring||'                        DAT_FINE_VAL, ';
--        sqlstring:=sqlstring||'                        DIREZIONE, ';
--        sqlstring:=sqlstring||'                        VMAX_A FCLD_VMAX_A, ';
--        sqlstring:=sqlstring||'                        VMAX_B FCLD_VMAX_B, ';
--        sqlstring:=sqlstring||'                        VMAX_C FCLD_VMAX_C, ';
--        sqlstring:=sqlstring||'                        VMAX_P FCLD_VMAX_P ';
--        sqlstring:=sqlstring||'                   FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL t, ';
--        sqlstring:=sqlstring||'                        RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN d ';
--        sqlstring:=sqlstring||'                  WHERE     T.CODICE_LINEA_FCL = D.CODICE_LINEA_FCL ';
--        sqlstring:=sqlstring||'                        AND t.FLAG_DISPARI = 1 ';
--        sqlstring:=sqlstring||'                        AND D.TIPO_PUNTO = 1 ';
--        sqlstring:=sqlstring||'                        AND D.DIREZIONE IN (2, 3) ';
--        sqlstring:=sqlstring||'                        AND NVL (DATA_INIZIO_VAL_R, ';
--        sqlstring:=sqlstring||'                                 TO_DATE (''01011999'', ''DDMMYYYY'')) <= SYSDATE ';
--        sqlstring:=sqlstring||'                        AND NVL (DAT_FINE_VAL, ';
--        sqlstring:=sqlstring||'                                 TO_DATE (''01012999'', ''DDMMYYYY'')) >= SYSDATE) l_fd, ';
--        sqlstring:=sqlstring||'                (SELECT DISTINCT di.CODICE_LINEA_FCL, ';
--        sqlstring:=sqlstring||'                                 di.CODICE_TRATTA_ROMAN, ';
--        sqlstring:=sqlstring||'                                 di.PROGR_KM prog_inizio_skt, ';
--        sqlstring:=sqlstring||'                                 df.PROGR_KM prog_fine_skt ';
--        sqlstring:=sqlstring||'                   FROM RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN di, ';
--        sqlstring:=sqlstring||'                        RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN df ';
--        sqlstring:=sqlstring||'                  WHERE     di.tipo_punto = 1 ';
--        sqlstring:=sqlstring||'                        AND df.tipo_punto = 2 ';
--        sqlstring:=sqlstring||'                        AND di.CODICE_LINEA_FCL = df.CODICE_LINEA_FCL ';
--        sqlstring:=sqlstring||'                        AND di.CODICE_TRATTA_ROMAN = df.CODICE_TRATTA_ROMAN ';
--        sqlstring:=sqlstring||'                        AND Di.DIREZIONE IN (2, 3) ';
--        sqlstring:=sqlstring||'                        AND Df.DIREZIONE IN (2, 3)) fcl_dati ';
--        sqlstring:=sqlstring||'          WHERE     fcl_trat_roman.CODICE_LINEA_FCL = T.CODICE_LINEA_FCL ';
--        sqlstring:=sqlstring||'                AND fcl_trat_roman.CODICE_LINEA_FCL = l_fd.CODICE_LINEA_FCL(+) ';
--        sqlstring:=sqlstring||'                AND fcl_trat_roman.CODICE_TRATTA_ROMAN = ';
--        sqlstring:=sqlstring||'                       l_fd.CODICE_TRATTA_ROMAN(+) ';
--        sqlstring:=sqlstring||'                AND fcl_trat_roman.CODICE_LINEA_FCL = ';
--        sqlstring:=sqlstring||'                       fcl_dati.CODICE_LINEA_FCL(+) ';
--        sqlstring:=sqlstring||'                AND fcl_trat_roman.CODICE_TRATTA_ROMAN = ';
--        sqlstring:=sqlstring||'                       fcl_dati.CODICE_TRATTA_ROMAN(+)) fcl_all_dati, ';
--        sqlstring:=sqlstring||'        (  SELECT CODICE_TRATTA_PIC, ';
--        sqlstring:=sqlstring||'                  LISTAGG (DEFINIZIONE || '' '') ';
--        sqlstring:=sqlstring||'                     WITHIN GROUP (ORDER BY DEFINIZIONE) ';
--        sqlstring:=sqlstring||'                     AS corridoio ';
--        sqlstring:=sqlstring||'             FROM RINF_ANAGRAFICHE_EVO.CORRIDOIO_TRATTE l, ';
--        sqlstring:=sqlstring||'                  RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI t, ';
--        sqlstring:=sqlstring||'                  RINF_ANAGRAFICHE_EVO.CORRIDOI_633 r ';
--        sqlstring:=sqlstring||'            WHERE     r.CODICE_CORRIDOIO = t.CODICE_CORRIDOIO_633 ';
--        sqlstring:=sqlstring||'                  AND l.CODICE_GIURISDIZIONE = t.CODICE_GIURISDIZIONE ';
--        sqlstring:=sqlstring||'                  AND l.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'         GROUP BY CODICE_TRATTA_PIC) corridoi, ';
--        sqlstring:=sqlstring||'        (  SELECT v.SEDE_TECNICA, ';
--        sqlstring:=sqlstring||'                  LISTAGG (PO_1_2_0_0_0_3, ''-'') ';
--        sqlstring:=sqlstring||'                     WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3) ';
--        sqlstring:=sqlstring||'                     AS codice ';
--        sqlstring:=sqlstring||'             FROM '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v, ';
--        sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI p ';
--        sqlstring:=sqlstring||'            WHERE p.sede_tecnica = v.sede_tecnica ';
--        IF p_versione IS NOT NULL THEN
--                sqlstring:=sqlstring||'    AND p.CODICE_VERSIONE='||p_versione;
--                sqlstring:=sqlstring||'    AND v.CODICE_VERSIONE='||p_versione;
--        END IF;
--        sqlstring:=sqlstring||'         GROUP BY v.SEDE_TECNICA) codice_taf_tap_i, ';
--        sqlstring:=sqlstring||'        (  SELECT v.SEDE_TECNICA, ';
--        sqlstring:=sqlstring||'                  LISTAGG (PO_1_2_0_0_0_3, ''-'') ';
--        sqlstring:=sqlstring||'                     WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3) ';
--        sqlstring:=sqlstring||'                     AS codice ';
--        sqlstring:=sqlstring||'             FROM '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v, ';
--        sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI p ';
--        sqlstring:=sqlstring||'            WHERE p.sede_tecnica = v.sede_tecnica ';
--        IF p_versione IS NOT NULL THEN
--                sqlstring:=sqlstring||'    AND p.CODICE_VERSIONE='||p_versione;
--                sqlstring:=sqlstring||'    AND v.CODICE_VERSIONE='||p_versione;
--        END IF;
--        sqlstring:=sqlstring||'         GROUP BY v.SEDE_TECNICA) codice_taf_tap_f ';
--        sqlstring:=sqlstring||'  WHERE     s.SEDE_TECNICA = trat_pic.SEDE_TECNICA ';
--        sqlstring:=sqlstring||'        AND codice_taf_tap_i.SEDE_TECNICA(+) = po_i.SEDE_TECNICA ';
--        sqlstring:=sqlstring||'        AND codice_taf_tap_f.SEDE_TECNICA(+) = po_f.SEDE_TECNICA ';
--        sqlstring:=sqlstring||'        AND fcl_all_dati.CODICE_LINEA_FCL = F.CODICE_LINEA_FCL(+) ';
--        sqlstring:=sqlstring||'        AND TRAT_ROMAN.CODICE_TRATTA_ROMAN = ';
--        sqlstring:=sqlstring||'               fcl_all_dati.CODICE_TRATTA_ROMAN(+) ';
--        sqlstring:=sqlstring||'        AND TRAT_ROMAN.CODICE_TRATTA_PIC = TRAT_PIC.CODICE_TRATTA_PIC_P ';
--        sqlstring:=sqlstring||'        AND trat_pic.CODICE_LOCALITA_INIZIO_PIC_P = ';
--        sqlstring:=sqlstring||'               LO_IN_PIC.CODICE_LOCALITA_PIC ';
--        sqlstring:=sqlstring||'        AND trat_pic.CODICE_LOCALITA_FINE_PIC_P = ';
--        sqlstring:=sqlstring||'               LO_FIN_PIC.CODICE_LOCALITA_PIC ';
--        sqlstring:=sqlstring||'        AND loc_rom_in.CODICE_LOCALITA_PIC = LO_IN_PIC.CODICE_LOCALITA_PIC ';
--        sqlstring:=sqlstring||'        AND loc_rom_fin.CODICE_LOCALITA_PIC = LO_FIN_PIC.CODICE_LOCALITA_PIC ';
--        sqlstring:=sqlstring||'        AND LO_IN_PIC.COD_LOCALITA_IN_RETE = po_i.SEDE_TECNICA(+) ';
--        sqlstring:=sqlstring||'        AND LO_FIN_PIC.COD_LOCALITA_IN_RETE = po_f.SEDE_TECNICA(+) ';
--        sqlstring:=sqlstring||'        AND TIP_LOC_ROM_IN.TIPO_LOCALITA = loc_rom_in.tipo_localita ';
--        sqlstring:=sqlstring||'        AND TIP_LOC_ROM_FIN.TIPO_LOCALITA = loc_rom_fin.tipo_localita ';
--        sqlstring:=sqlstring||'        AND trat_roman.CODICE_TRATTA_ROMAN = ';
--        sqlstring:=sqlstring||'               fcl_all_dati.codice_tratta_roman(+) ';
--        sqlstring:=sqlstring||'        AND TIPO_BLOCCO_PIC.CODICE_TIPO(+) = TRAT_PIC.CODICE_TIPO_BLOCCO_D ';
--        sqlstring:=sqlstring||'        AND TIPO_BLOCCO_PIC.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'        AND TIPO_TRAZIONE_PIC.CODICE_TIPO(+) = TRAT_PIC.CODICE_TIPOTRAZIONE_D ';
--        sqlstring:=sqlstring||'        AND TIPO_TRAZIONE_PIC.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'        AND TRAT_ROMAN.CODICE_REGIONE = regione_roman.CODICE_REGIONE (+) ';
--        sqlstring:=sqlstring||'        AND regione_roman.data_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'        AND linea_comm.SEDE_TECNICA = s.SEDE_TECNICA ';
--        sqlstring:=sqlstring||'        AND tipo_esercizio_pic.CODICE_TIPO(+) = ';
--        sqlstring:=sqlstring||'               TRAT_PIC.CODICE_TIPO_ESERCIZIO_D ';
--        sqlstring:=sqlstring||'        AND TIPO_ESERCIZIO_PIC.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'        AND TRASPORTO_COMB_PIC.CODICE_TRASPORTO(+) = ';
--        sqlstring:=sqlstring||'               TRAT_PIC.CODICE_TIPO_TRASP_COMBINATO1_D ';
--        sqlstring:=sqlstring||'        AND TRASPORTO_COMB_PIC.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'        AND PESO_ASSIALE_PIC.CODICE_TIPO(+) = ';
--        sqlstring:=sqlstring||'               TRAT_PIC.CODICE_CAT_LINEA_MAS_ASS_D ';
--        sqlstring:=sqlstring||'        AND PESO_ASSIALE_PIC.DATA_SCADENZA IS NULL ';
--        sqlstring:=sqlstring||'        AND TRAT_PIC.CODICE_TRATTA_PIC_P = corridoi.CODICE_TRATTA_PIC(+)        ';
--        IF p_versione IS NOT NULL THEN
--                sqlstring:=sqlstring||'    AND s.CODICE_VERSIONE='||p_versione;
--                sqlstring:=sqlstring||'    AND po_i.CODICE_VERSIONE='||p_versione;
--                sqlstring:=sqlstring||'    AND po_f.CODICE_VERSIONE='||p_versione;
--        END IF;
--
--        --filtro richiamato dalla funzione ROUTING in due punti in questa procedura (2/2)
--        IF p_filtro is NOT NULL THEN
--        s_filtro:=UPPER(GetWhereCondition(p_filtro,'s.SEDE_TECNICA'));
--        sqlstring:=sqlstring ||substr(s_filtro,1,instr(s_filtro,'ORDER')-1);--siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
--        END IF;
--
--        sqlstring:=sqlstring ||') tab_esterna ';
--
--       --filtro richiamato dalla funzione ROUTING inserito alla fine della tabella "esterna" perch  internamente ho 2 UNION e non avrei potuto fare l'ORDER
--        IF p_filtro is NOT NULL THEN
--        s_filtro:=UPPER(GetWhereCondition(p_filtro,'tab_esterna.CodiceTrattaIne'));
--        sqlstring:=sqlstring ||substr(s_filtro,instr(s_filtro,'ORDER'));
--        ELSE--se non ho p_filtro del ROUTING
--             sqlstring:=sqlstring||'ORDER BY 1, ';
--              sqlstring:=sqlstring||'  2, ';
--              sqlstring:=sqlstring||'  3, ';
--              sqlstring:=sqlstring||'  8 ';
--        END IF;
--
--     DBMS_OUTPUT.PUT_LINE(sqlstring);
--    OPEN p_cursor FOR sqlstring;
--END GetMDRReport;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetMDRReport (p_area NUMBER,p_i_versione NUMBER , p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.1.7
--22/11/2017 modificato per includere tutte le tratte del RINf, inserite outer join nella prima sellect, lasciata invariata la seconda
    s_schema VARCHAR2(100);
    sqlstring VARCHAR2(32767);
    p_versione NUMBER;
    s_filtro VARCHAR2(32767);
    d_data_riferimento VARCHAR2(8);

    BEGIN
     s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
     --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
     IF (p_area=1 OR p_area=3) THEN
      p_versione:=NULL;
     ELSE  --(p_area=2 OR p_area=4)
         IF  p_i_versione IS NULL THEN
            p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
         ELSE
            p_versione:=p_i_versione;
         END IF;
     END IF;

--14/02/2018 Inserita la data di riferimento in sostituzione della SYSDATE, per contestualizzare
--l'estrazione dei dati validi all'area selezionata

     d_data_riferimento:=TO_CHAR(PKG_RINF_INTERFACCIA.GETDATARIFERIMENTO(p_area,p_i_versione),'DDMMYYYY');

        sqlstring:='SELECT               ';              --tabella esterna insertita per fare l'ORDER del ROUTING
        sqlstring:=sqlstring||'"NOME_DTP"                 ,';
        sqlstring:=sqlstring||'"FascicoloLinea"           ,';
        sqlstring:=sqlstring||'"CodiceLineaFclSkt"        ,';
        sqlstring:=sqlstring||'"DefinizioneLineaFclSkt"   ,';
        sqlstring:=sqlstring||'"InizioValidita"           ,';
        sqlstring:=sqlstring||'"FineValidita"             ,';
        sqlstring:=sqlstring||'"CodiceLineaFclInversaSkt" ,';
        sqlstring:=sqlstring||'"ProgressivoTratta"        ,';
        sqlstring:=sqlstring||'CodiceTrattaIne "CodiceTrattaIne"          ,';
        sqlstring:=sqlstring||'"TrattaIne"                ,';
        sqlstring:=sqlstring||'"CodiceTrattaPicDis"       ,';
        sqlstring:=sqlstring||'"CodiceTrattaPicPar"       ,';
        sqlstring:=sqlstring||'"KmSktDa"                  ,';
        sqlstring:=sqlstring||'"CodiceLoSktDa"            ,';
        sqlstring:=sqlstring||'"CodiceLoIneDa"            ,';
        sqlstring:=sqlstring||'"CodiceLoItDa"             ,';
        sqlstring:=sqlstring||'"CodiceLoTsiDa"            ,';
        sqlstring:=sqlstring||'"CodiceLoPicDa"            ,';
        sqlstring:=sqlstring||'"Localita16Da"             ,';
        sqlstring:=sqlstring||'"TipoLoDa"                 ,';
        sqlstring:=sqlstring||'"KmSktA"                   ,';
        sqlstring:=sqlstring||'"CodiceLoSktA"             ,';
        sqlstring:=sqlstring||'"CodiceLoIneA"             ,';
        sqlstring:=sqlstring||'"CodiceLoItA"              ,';
        sqlstring:=sqlstring||'"CodiceLoTsiA"             ,';
        sqlstring:=sqlstring||'"CodiceLoPicA"             ,';
        sqlstring:=sqlstring||'"Localita16A"              ,';
        sqlstring:=sqlstring||'"TipoLoA"                  ,';
        sqlstring:=sqlstring||'"Via"                      ,';
        sqlstring:=sqlstring||'"TipoBlocco"               ,';
        sqlstring:=sqlstring||'"Banalizzato"              ,';
        sqlstring:=sqlstring||'"RangoASkt"                ,';
        sqlstring:=sqlstring||'"RangoBSkt"                ,';
        sqlstring:=sqlstring||'"RangoCSkt"                ,';
        sqlstring:=sqlstring||'"RangoPSkt"                ,';
        sqlstring:=sqlstring||'"TipoEsercizio"            ,';
        sqlstring:=sqlstring||'"Lunghezza"                ,';
        sqlstring:=sqlstring||'"Binario"                  ,';
        sqlstring:=sqlstring||'"TipoTrazione"             ,';
        sqlstring:=sqlstring||'"Corridoi"                 ,';
        sqlstring:=sqlstring||'"Commerciali"              ,';
        sqlstring:=sqlstring||'"Regione"                  ,';
        sqlstring:=sqlstring||'"RegimeCirc"               ,';
        sqlstring:=sqlstring||'"PesoAssiale" ';
        sqlstring:=sqlstring||'FROM       ';
        sqlstring:=sqlstring||'( ';
        --
        --21/11/2017 Modificata query dopo la segnalazione di Schillaci che non tutte le tratte erano presenti nel report. Molte join sono stare trasformate in outer join
        sqlstring:=sqlstring||' SELECT DISTINCT ';
        sqlstring:=sqlstring||'        s.CODICE_DTP "NOME_DTP", ';
        sqlstring:=sqlstring||'        f.FASCICOLO_LINEA "FascicoloLinea", ';
        sqlstring:=sqlstring||'        fcl_all_dati.CODICE_LINEA_FCL "CodiceLineaFclSkt", ';
        sqlstring:=sqlstring||'        fcl_all_dati.DEFINIZIONE "DefinizioneLineaFclSkt", ';
        sqlstring:=sqlstring||'        fcl_all_dati.DATA_INIZIO_VALIDITA "InizioValidita", ';
        sqlstring:=sqlstring||'        fcl_all_dati.DAT_FINE_VAL "FineValidita", ';
        sqlstring:=sqlstring||'        fcl_all_dati.CODICE_LINEA_INVERSA "CodiceLineaFclInversaSkt", ';
        sqlstring:=sqlstring||'        fcl_all_dati.PROG_TRATTA "ProgressivoTratta", ';
        sqlstring:=sqlstring||'        s.SEDE_TECNICA CodiceTrattaIne, ';
        sqlstring:=sqlstring||'        s.DEFINIZIONE "TrattaIne", ';
        sqlstring:=sqlstring||'        trat_pic.CODICE_TRATTA_PIC_D "CodiceTrattaPicDis", ';
        sqlstring:=sqlstring||'        trat_pic.CODICE_TRATTA_PIC_P "CodiceTrattaPicPar", ';
        sqlstring:=sqlstring||'        fcl_all_dati.prog_inizio_skt "KmSktDa", ';
        sqlstring:=sqlstring||'        LO_IN_PIC.CODICE_LOCALITA_MIR "CodiceLoSktDa", ';
        sqlstring:=sqlstring||'        NVL (po_i.SEDE_TECNICA, ''-'') "CodiceLoIneDa", ';
        sqlstring:=sqlstring||'        NVL (po_i.PO_1_2_0_0_0_2, ''-'') "CodiceLoItDa", ';
        sqlstring:=sqlstring||'        NVL (codice_taf_tap_i.codice, ''-'') "CodiceLoTsiDa", ';
        sqlstring:=sqlstring||'        trat_pic.CODICE_LOCALITA_INIZIO_PIC_D "CodiceLoPicDa", ';
        sqlstring:=sqlstring||'        LO_IN_PIC.NOME_LOCALITA16 "Localita16Da", ';
        sqlstring:=sqlstring||'        TIP_LOC_ROM_IN.SIGLA_TIPO "TipoLoDa", ';
        sqlstring:=sqlstring||'        fcl_all_dati.prog_fine_skt "KmSktA", ';
        sqlstring:=sqlstring||'        LO_FIN_PIC.CODICE_LOCALITA_MIR "CodiceLoSktA", ';
        sqlstring:=sqlstring||'        NVL (po_f.SEDE_TECNICA, ''-'') "CodiceLoIneA", ';
        sqlstring:=sqlstring||'        NVL (po_f.PO_1_2_0_0_0_2, ''-'') "CodiceLoItA", ';
        sqlstring:=sqlstring||'        NVL (codice_taf_tap_f.codice, ''-'') "CodiceLoTsiA", ';
        sqlstring:=sqlstring||'        trat_pic.CODICE_LOCALITA_FINE_PIC_D "CodiceLoPicA", ';
        sqlstring:=sqlstring||'        LO_FIN_PIC.NOME_LOCALITA16 "Localita16A", ';
        sqlstring:=sqlstring||'        TIP_LOC_ROM_FIN.SIGLA_TIPO "TipoLoA", ';
        sqlstring:=sqlstring||'        TRAT_PIC.CODICE_VIA_D "Via", ';
        sqlstring:=sqlstring||'        TIPO_BLOCCO_PIC.DESCRIZIONE "TipoBlocco", ';
        sqlstring:=sqlstring||'        DECODE (INSTR (UPPER (TIPO_BLOCCO_PIC.DESCRIZIONE), ''BANALIZZATO''), ';
        sqlstring:=sqlstring||'                0, ''NO'', ';
        sqlstring:=sqlstring||'                ''SI'') ';
        sqlstring:=sqlstring||'           "Banalizzato", ';
        sqlstring:=sqlstring||'        FCLD_VMAX_A "RangoASkt", ';
        sqlstring:=sqlstring||'        FCLD_VMAX_B "RangoBSkt", ';
        sqlstring:=sqlstring||'        FCLD_VMAX_C "RangoCSkt", ';
        sqlstring:=sqlstring||'        FCLD_VMAX_P "RangoPSkt", ';
        sqlstring:=sqlstring||'        tipo_esercizio_pic.DESCRIZIONE "TipoEsercizio", ';
        sqlstring:=sqlstring||'        TRAT_ROMAN.LUNGHEZZA "Lunghezza", ';
        sqlstring:=sqlstring||'        DECODE (fcl_all_dati.DIREZIONE,  1, ''DIS'',  2, ''PAR'',  ''UNI'') ';
        sqlstring:=sqlstring||'           "Binario", ';
        sqlstring:=sqlstring||'        TIPO_TRAZIONE_PIC.DESCRIZIONE "TipoTrazione", ';
        sqlstring:=sqlstring||'        corridoi.corridoio "Corridoi", ';
        sqlstring:=sqlstring||'        linea_comm.linea "Commerciali", ';
        sqlstring:=sqlstring||'        regione_roman.SIGLA "Regione", ';
        sqlstring:=sqlstring||'        S.REGIME_CIRCOLAZIONE "RegimeCirc", ';
        sqlstring:=sqlstring||'        PESO_ASSIALE_PIC.DESCRIZIONE "PesoAssiale" ';
        sqlstring:=sqlstring||'   FROM '||s_schema||'.SEZIONI_LINEA s, ';
        sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI po_i, ';
        sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI po_f, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.V_MAPPING_TRATTE_INRETE_PIC trat_pic, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN trat_roman, ';
        sqlstring:=sqlstring||'        (SELECT FASCICOLO_LINEA, CODICE_LINEA_FCL ';
        sqlstring:=sqlstring||'           FROM RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE a, ';
        sqlstring:=sqlstring||'                RINF_ANAGRAFICHE_EVO.FASCICOLO_LINEE_FCL fl ';
        sqlstring:=sqlstring||'          WHERE a.CODICE_FASCICOLO = fl.CODICE_FASCICOLO ';
        sqlstring:=sqlstring||'          AND fl.DATA_SCADENZA IS NULL ';
        sqlstring:=sqlstring||'          AND a.DATA_SCADENZA IS NULL) f, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.localita_roman loc_rom_in, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.localita_roman loc_rom_fin, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN tip_loc_rom_in, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN tip_loc_rom_fin, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.localita_PIC lo_in_pic, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.localita_PIC lo_fin_pic, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOCALITA, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_BLOCCO tipo_blocco_pic, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAZIONE tipo_trazione_pic, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_REGIONE_ROMAN regione_roman, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_ESERCIZIO tipo_esercizio_pic, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TRASPORTO_COMBINATO trasporto_comb_pic, ';
        sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.ANAG_TIPO_CAT_LIN_MASS_ASS peso_assiale_pic, ';
        sqlstring:=sqlstring||'        (  SELECT SEDE_TECNICA, ';
        sqlstring:=sqlstring||'                  LISTAGG (REPLACE (CODICE, '' '', '''') || '' '') ';
        sqlstring:=sqlstring||'                     WITHIN GROUP (ORDER BY CODICE) ';
        sqlstring:=sqlstring||'                     AS linea ';
        sqlstring:=sqlstring||'             FROM '||s_schema||'.V_MDR_LINEE_COMMERCIALI ';
        IF p_versione IS NOT NULL THEN
                sqlstring:=sqlstring||'    WHERE CODICE_VERSIONE='||p_versione;
        END IF;
        sqlstring:=sqlstring||'         GROUP BY SEDE_TECNICA) linea_comm, ';
        sqlstring:=sqlstring||'        (SELECT FCL_TRAT_ROMAN.CODICE_TRATTA_ROMAN, ';
        sqlstring:=sqlstring||'                t.CODICE_LINEA_FCL, ';
        sqlstring:=sqlstring||'                t.DEFINIZIONE, ';
        sqlstring:=sqlstring||'                TO_CHAR (t.DATA_INIZIO_VALIDITA, ''DD/MM/YYYY'') ';
        sqlstring:=sqlstring||'                   DATA_INIZIO_VALIDITA, ';
        sqlstring:=sqlstring||'                TO_CHAR (t.DAT_FINE_VAL, ''DD/MM/YYYY'') DAT_FINE_VAL, ';
        sqlstring:=sqlstring||'                T.CODICE_LINEA_INVERSA, ';
        sqlstring:=sqlstring||'                FCL_TRAT_ROMAN.PROG_TRATTA, ';
        sqlstring:=sqlstring||'                FCLD_VMAX_A, ';
        sqlstring:=sqlstring||'                FCLD_VMAX_B, ';
        sqlstring:=sqlstring||'                FCLD_VMAX_C, ';
        sqlstring:=sqlstring||'                FCLD_VMAX_P, ';
        sqlstring:=sqlstring||'                l_fd.DIREZIONE, ';
        sqlstring:=sqlstring||'                fcl_dati.prog_inizio_skt, ';
        sqlstring:=sqlstring||'                fcl_dati.prog_fine_skt ';
        sqlstring:=sqlstring||'           FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL t, ';
        sqlstring:=sqlstring||'                RINF_ANAGRAFICHE_EVO.LINEA_FCL_TRATTE_ROMAN fcl_trat_roman, ';
        sqlstring:=sqlstring||'                (SELECT DISTINCT ';
        sqlstring:=sqlstring||'                        D.CODICE_TRATTA_ROMAN codice_tratta_roman, ';
        sqlstring:=sqlstring||'                        t.CODICE_LINEA_FCL codice_linea_fcl, ';
        sqlstring:=sqlstring||'                        t.CODICE_LINEA_INVERSA codice_linea_fcl_inversa, ';
        sqlstring:=sqlstring||'                        t.DEFINIZIONE linea_fcl, ';
        sqlstring:=sqlstring||'                        DATA_INIZIO_VALIDITA, ';
        sqlstring:=sqlstring||'                        DAT_FINE_VAL, ';
        sqlstring:=sqlstring||'                        DIREZIONE, ';
        sqlstring:=sqlstring||'                        VMAX_A FCLD_VMAX_A, ';
        sqlstring:=sqlstring||'                        VMAX_B FCLD_VMAX_B, ';
        sqlstring:=sqlstring||'                        VMAX_C FCLD_VMAX_C, ';
        sqlstring:=sqlstring||'                        VMAX_P FCLD_VMAX_P ';
        sqlstring:=sqlstring||'                   FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL t, ';
        sqlstring:=sqlstring||'                        RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN d ';
        sqlstring:=sqlstring||'                  WHERE     T.CODICE_LINEA_FCL = D.CODICE_LINEA_FCL ';
        sqlstring:=sqlstring||'                        AND t.FLAG_DISPARI = 1 ';
        sqlstring:=sqlstring||'                        AND D.TIPO_PUNTO = 1 ';
        sqlstring:=sqlstring||'                        AND D.DIREZIONE IN (1, 3) ';
        sqlstring:=sqlstring||'                        AND NVL (DATA_INIZIO_VAL_R, ';
        sqlstring:=sqlstring||'                                 TO_DATE (''01011999'', ''DDMMYYYY'')) <=  TO_DATE('''||d_data_riferimento||''',''DDMMYYYY'')';
        sqlstring:=sqlstring||'                        AND NVL (DAT_FINE_VAL, ';
        sqlstring:=sqlstring||'                                 TO_DATE (''01012999'', ''DDMMYYYY'')) >=  TO_DATE('''||d_data_riferimento||''',''DDMMYYYY'')) l_fd, ';
        sqlstring:=sqlstring||'                (SELECT DISTINCT di.CODICE_LINEA_FCL, ';
        sqlstring:=sqlstring||'                                 di.CODICE_TRATTA_ROMAN, ';
        sqlstring:=sqlstring||'                                 di.PROGR_KM prog_inizio_skt, ';
        sqlstring:=sqlstring||'                                 df.PROGR_KM prog_fine_skt ';
        sqlstring:=sqlstring||'                   FROM RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN di, ';
        sqlstring:=sqlstring||'                        RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN df ';
        sqlstring:=sqlstring||'                  WHERE     di.tipo_punto = 1 ';
        sqlstring:=sqlstring||'                        AND df.tipo_punto = 2 ';
        sqlstring:=sqlstring||'                        AND di.CODICE_LINEA_FCL = df.CODICE_LINEA_FCL ';
        sqlstring:=sqlstring||'                        AND di.CODICE_TRATTA_ROMAN = df.CODICE_TRATTA_ROMAN ';
        sqlstring:=sqlstring||'                        AND Di.DIREZIONE IN (1, 3) ';
        sqlstring:=sqlstring||'                        AND Df.DIREZIONE IN (1, 3)) fcl_dati ';
        sqlstring:=sqlstring||'          WHERE     fcl_trat_roman.CODICE_LINEA_FCL = T.CODICE_LINEA_FCL ';
        sqlstring:=sqlstring||'                AND fcl_trat_roman.CODICE_LINEA_FCL = l_fd.CODICE_LINEA_FCL(+) ';
        sqlstring:=sqlstring||'                AND fcl_trat_roman.CODICE_TRATTA_ROMAN = ';
        sqlstring:=sqlstring||'                       l_fd.CODICE_TRATTA_ROMAN(+) ';
        sqlstring:=sqlstring||'                AND fcl_trat_roman.CODICE_LINEA_FCL = ';
        sqlstring:=sqlstring||'                       fcl_dati.CODICE_LINEA_FCL(+) ';
        sqlstring:=sqlstring||'                AND fcl_trat_roman.CODICE_TRATTA_ROMAN = ';
        sqlstring:=sqlstring||'                       fcl_dati.CODICE_TRATTA_ROMAN(+) ';
        sqlstring:=sqlstring||'                AND NVL (t.DATA_INIZIO_VAL_R, ';
        sqlstring:=sqlstring||'                         TO_DATE (''01011999'', ''DDMMYYYY'')) <=  TO_DATE('''||d_data_riferimento||''',''DDMMYYYY'') ';
        sqlstring:=sqlstring||'                AND NVL (t.DAT_FINE_VAL, TO_DATE (''01012999'', ''DDMMYYYY'')) >= ';
        sqlstring:=sqlstring||'                        TO_DATE('''||d_data_riferimento||''',''DDMMYYYY'')) fcl_all_dati, ';
        sqlstring:=sqlstring||'        (  SELECT CODICE_TRATTA_PIC, ';
        sqlstring:=sqlstring||'                  LISTAGG (DEFINIZIONE || '' '') ';
        sqlstring:=sqlstring||'                     WITHIN GROUP (ORDER BY DEFINIZIONE) ';
        sqlstring:=sqlstring||'                     AS corridoio ';
        sqlstring:=sqlstring||'             FROM RINF_ANAGRAFICHE_EVO.CORRIDOIO_TRATTE l, ';
        sqlstring:=sqlstring||'                  RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI t, ';
        sqlstring:=sqlstring||'                  RINF_ANAGRAFICHE_EVO.CORRIDOI_633 r ';
        sqlstring:=sqlstring||'            WHERE     r.CODICE_CORRIDOIO = t.CODICE_CORRIDOIO_633 ';
        sqlstring:=sqlstring||'                  AND l.CODICE_GIURISDIZIONE = t.CODICE_GIURISDIZIONE ';
        sqlstring:=sqlstring||'                  AND l.DATA_SCADENZA IS NULL ';
        sqlstring:=sqlstring||'         GROUP BY CODICE_TRATTA_PIC) corridoi, ';
        sqlstring:=sqlstring||'        (  SELECT v.SEDE_TECNICA, ';
        sqlstring:=sqlstring||'                  LISTAGG (PO_1_2_0_0_0_3, ''-'') ';
        sqlstring:=sqlstring||'                     WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3) ';
        sqlstring:=sqlstring||'                     AS codice ';
        sqlstring:=sqlstring||'             FROM '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v, ';
        sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI p ';
        sqlstring:=sqlstring||'            WHERE p.sede_tecnica = v.sede_tecnica ';
        IF p_versione IS NOT NULL THEN
                sqlstring:=sqlstring||'    AND p.CODICE_VERSIONE='||p_versione;
                sqlstring:=sqlstring||'    AND v.CODICE_VERSIONE='||p_versione;
        END IF;
        sqlstring:=sqlstring||'         GROUP BY v.SEDE_TECNICA) codice_taf_tap_i, ';
        sqlstring:=sqlstring||'        (  SELECT v.SEDE_TECNICA, ';
        sqlstring:=sqlstring||'                  LISTAGG (PO_1_2_0_0_0_3, ''-'') ';
        sqlstring:=sqlstring||'                     WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3) ';
        sqlstring:=sqlstring||'                     AS codice ';
        sqlstring:=sqlstring||'             FROM '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v, ';
        sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI p ';
        sqlstring:=sqlstring||'            WHERE p.sede_tecnica = v.sede_tecnica ';
        IF p_versione IS NOT NULL THEN
                sqlstring:=sqlstring||'    AND p.CODICE_VERSIONE='||p_versione;
                sqlstring:=sqlstring||'    AND v.CODICE_VERSIONE='||p_versione;
        END IF;
        sqlstring:=sqlstring||'         GROUP BY v.SEDE_TECNICA) codice_taf_tap_f ';
        sqlstring:=sqlstring||'  WHERE     s.SEDE_TECNICA = trat_pic.SEDE_TECNICA ';
        sqlstring:=sqlstring||'        AND codice_taf_tap_i.SEDE_TECNICA(+) = po_i.SEDE_TECNICA ';
        sqlstring:=sqlstring||'        AND codice_taf_tap_f.SEDE_TECNICA(+) = po_f.SEDE_TECNICA ';
        sqlstring:=sqlstring||'        AND fcl_all_dati.CODICE_LINEA_FCL = F.CODICE_LINEA_FCL(+) ';
        sqlstring:=sqlstring||'        AND TRAT_ROMAN.CODICE_TRATTA_ROMAN = ';
        sqlstring:=sqlstring||'               fcl_all_dati.CODICE_TRATTA_ROMAN(+) ';
        sqlstring:=sqlstring||'        AND TRAT_ROMAN.CODICE_TRATTA_PIC = TRAT_PIC.CODICE_TRATTA_PIC_D ';
        sqlstring:=sqlstring||'        AND trat_pic.CODICE_LOCALITA_INIZIO_PIC_D = ';
        sqlstring:=sqlstring||'               LO_IN_PIC.CODICE_LOCALITA_PIC ';
        sqlstring:=sqlstring||'        AND trat_pic.CODICE_LOCALITA_FINE_PIC_D = ';
        sqlstring:=sqlstring||'               LO_FIN_PIC.CODICE_LOCALITA_PIC ';
        sqlstring:=sqlstring||'        AND loc_rom_in.CODICE_LOCALITA_PIC = LO_IN_PIC.CODICE_LOCALITA_PIC ';
        sqlstring:=sqlstring||'        AND loc_rom_fin.CODICE_LOCALITA_PIC = LO_FIN_PIC.CODICE_LOCALITA_PIC ';
        sqlstring:=sqlstring||'        AND LO_IN_PIC.COD_LOCALITA_IN_RETE = po_i.SEDE_TECNICA(+) ';
        sqlstring:=sqlstring||'        AND LO_FIN_PIC.COD_LOCALITA_IN_RETE = po_f.SEDE_TECNICA(+) ';
        sqlstring:=sqlstring||'        AND TIP_LOC_ROM_IN.TIPO_LOCALITA = loc_rom_in.tipo_localita ';
        sqlstring:=sqlstring||'        AND TIP_LOC_ROM_FIN.TIPO_LOCALITA = loc_rom_fin.tipo_localita ';
        sqlstring:=sqlstring||'        AND TIPO_BLOCCO_PIC.CODICE_TIPO(+) = TRAT_PIC.CODICE_TIPO_BLOCCO_D ';
        sqlstring:=sqlstring||'        AND TIPO_BLOCCO_PIC.DATA_SCADENZA IS NULL ';
        sqlstring:=sqlstring||'        AND TIPO_TRAZIONE_PIC.CODICE_TIPO(+) = TRAT_PIC.CODICE_TIPOTRAZIONE_D ';
        sqlstring:=sqlstring||'        AND TIPO_TRAZIONE_PIC.DATA_SCADENZA IS NULL ';
        sqlstring:=sqlstring||'        AND TRAT_ROMAN.CODICE_REGIONE = regione_roman.CODICE_REGIONE (+) ';
        sqlstring:=sqlstring||'        AND regione_roman.data_SCADENZA IS NULL ';
        sqlstring:=sqlstring||'        AND linea_comm.SEDE_TECNICA = s.SEDE_TECNICA ';
        sqlstring:=sqlstring||'        AND tipo_esercizio_pic.CODICE_TIPO(+) = ';
        sqlstring:=sqlstring||'               TRAT_PIC.CODICE_TIPO_ESERCIZIO_D ';
        sqlstring:=sqlstring||'        AND TIPO_ESERCIZIO_PIC.DATA_SCADENZA IS NULL ';
        sqlstring:=sqlstring||'        AND TRASPORTO_COMB_PIC.CODICE_TRASPORTO(+) = ';
        sqlstring:=sqlstring||'               TRAT_PIC.CODICE_TIPO_TRASP_COMBINATO1_D ';
        sqlstring:=sqlstring||'        AND TRASPORTO_COMB_PIC.DATA_SCADENZA IS NULL ';
        sqlstring:=sqlstring||'        AND PESO_ASSIALE_PIC.CODICE_TIPO(+) = ';
        sqlstring:=sqlstring||'               TRAT_PIC.CODICE_CAT_LINEA_MAS_ASS_D ';
        sqlstring:=sqlstring||'        AND PESO_ASSIALE_PIC.DATA_SCADENZA IS NULL ';
        sqlstring:=sqlstring||'        AND TRAT_PIC.CODICE_TRATTA_PIC_D = corridoi.CODICE_TRATTA_PIC(+) ';
        IF p_versione IS NOT NULL THEN
        sqlstring:=sqlstring||'    AND s.CODICE_VERSIONE='||p_versione;
        sqlstring:=sqlstring||'    AND po_i.CODICE_VERSIONE='||p_versione;
        sqlstring:=sqlstring||'    AND po_f.CODICE_VERSIONE='||p_versione;
        END IF;

        --filtro richiamato dalla funzione ROUTING in due punti in questa procedura (1/2)
        IF p_filtro is NOT NULL THEN
        s_filtro:=UPPER(GetWhereCondition(p_filtro,'s.SEDE_TECNICA'));
        sqlstring:=sqlstring ||substr(s_filtro,1,instr(s_filtro,'ORDER')-1);--siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
        END IF;

       sqlstring:=sqlstring||'UNION ';
       sqlstring:=sqlstring||'SELECT DISTINCT ';
       sqlstring:=sqlstring||'s.CODICE_DTP CODICEDTP, ';
       sqlstring:=sqlstring||'f.FASCICOLO_LINEA FL, ';
       sqlstring:=sqlstring||'t.CODICE_LINEA_FCL, ';
       sqlstring:=sqlstring||'t.DEFINIZIONE LINEA_FCL, ';
       sqlstring:=sqlstring||'TO_CHAR(t.DATA_INIZIO_VALIDITA,''DD/MM/YYYY''), ';
       sqlstring:=sqlstring||'TO_CHAR(t.DAT_FINE_VAL,''DD/MM/YYYY''), ';
       sqlstring:=sqlstring||'T.CODICE_LINEA_INVERSA, ';
       sqlstring:=sqlstring||'FCL_TRAT_ROMAN.PROG_TRATTA, ';
       sqlstring:=sqlstring||'s.SEDE_TECNICA, ';
       sqlstring:=sqlstring||'s.DEFINIZIONE DEF_SEDE_TECNICA, ';
       sqlstring:=sqlstring||'trat_pic.CODICE_TRATTA_PIC_P, ';
       sqlstring:=sqlstring||'trat_pic.CODICE_TRATTA_PIC_D, ';
       sqlstring:=sqlstring||'fcl_dati.prog_inizio_skt, ';
       sqlstring:=sqlstring||'LO_IN_PIC.CODICE_LOCALITA_MIR, ';
       sqlstring:=sqlstring||'NVL (po_i.SEDE_TECNICA, ''-'') CODICE_LOCALITA_INRETE, ';
       sqlstring:=sqlstring||'NVL (po_i.PO_1_2_0_0_0_2, ''-'') PO_1_2_0_0_0_2, ';
       sqlstring:=sqlstring||'NVL (codice_taf_tap_i.codice , ''-'') PO_1_2_0_0_0_3, ';
       sqlstring:=sqlstring||'trat_pic.CODICE_LOCALITA_INIZIO_PIC_D INIZIO_PIC, ';
       sqlstring:=sqlstring||'LO_IN_PIC.NOME_LOCALITA16, ';
       sqlstring:=sqlstring||'TIP_LOC_ROM_IN.SIGLA_TIPO, ';
       sqlstring:=sqlstring||'fcl_dati.prog_fine_skt, ';
       sqlstring:=sqlstring||'LO_FIN_PIC.CODICE_LOCALITA_MIR, ';
       sqlstring:=sqlstring||'NVL (po_f.SEDE_TECNICA, ''-'') CODICE_LOCALITA_INRETE, ';
       sqlstring:=sqlstring||'NVL (po_f.PO_1_2_0_0_0_2, ''-'') PO_1_2_0_0_0_2, ';
       sqlstring:=sqlstring||'NVL (codice_taf_tap_f.codice , ''-'') PO_1_2_0_0_0_3, ';
       sqlstring:=sqlstring||'trat_pic.CODICE_LOCALITA_FINE_PIC_P FINE_PIC, ';
       sqlstring:=sqlstring||'LO_FIN_PIC.NOME_LOCALITA16, ';
       sqlstring:=sqlstring||'TIP_LOC_ROM_FIN.SIGLA_TIPO, ';
       sqlstring:=sqlstring||'TRAT_PIC.CODICE_VIA_P, ';
       sqlstring:=sqlstring||'TIPO_BLOCCO_PIC.DESCRIZIONE TIPO_BLOCCO, ';
       sqlstring:=sqlstring||'DECODE (INSTR (UPPER (TIPO_BLOCCO_PIC.DESCRIZIONE), ''BANALIZZATO''), ';
       sqlstring:=sqlstring||'        0, ''NO'', ';
       sqlstring:=sqlstring||'        ''SI'') ';
       sqlstring:=sqlstring||'   BANALIZZATO, ';
       sqlstring:=sqlstring||'FCLD_VMAX_A, ';
       sqlstring:=sqlstring||'FCLD_VMAX_B, ';
       sqlstring:=sqlstring||'FCLD_VMAX_C, ';
       sqlstring:=sqlstring||'FCLD_VMAX_P, ';
       sqlstring:=sqlstring||'tipo_esercizio_pic.DESCRIZIONE TIP_ESERCIZIO, ';
       sqlstring:=sqlstring||'TRAT_ROMAN.LUNGHEZZA, ';
       sqlstring:=sqlstring||'DECODE (l_fd.DIREZIONE,  1, ''DIS'',  2, ''PAR'',  ''UNI'') BINARIO, ';
       sqlstring:=sqlstring||'TIPO_TRAZIONE_PIC.DESCRIZIONE TIPO_TRAZIONE, ';
       sqlstring:=sqlstring||'corridoi.corridoio, ';
       sqlstring:=sqlstring||'linea_comm.linea, ';
       sqlstring:=sqlstring||'regione_roman.SIGLA REGIONE, ';
       sqlstring:=sqlstring||'S.REGIME_CIRCOLAZIONE, ';
       sqlstring:=sqlstring||'PESO_ASSIALE_PIC.DESCRIZIONE peso_assiale ';
       sqlstring:=sqlstring||'FROM  '||s_schema||'.SEZIONI_LINEA s, ';
       sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI po_i, ';
       sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI po_f, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.V_MAPPING_TRATTE_INRETE_PIC trat_pic, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN trat_roman, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE f, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.FASCICOLO_LINEE_FCL fl, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL t, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.LINEA_FCL_TRATTE_ROMAN fcl_trat_roman, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.localita_roman loc_rom_in, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.localita_roman loc_rom_fin, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN tip_loc_rom_in, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN tip_loc_rom_fin, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.localita_PIC lo_in_pic, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.localita_PIC lo_fin_pic, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOCALITA, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.ANAG_TIPO_BLOCCO tipo_blocco_pic, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAZIONE tipo_trazione_pic, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.ANAG_REGIONE_ROMAN regione_roman, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.ANAG_TIPO_ESERCIZIO tipo_esercizio_pic, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.ANAG_TRASPORTO_COMBINATO trasporto_comb_pic, ';
       sqlstring:=sqlstring||'RINF_ANAGRAFICHE_EVO.ANAG_TIPO_CAT_LIN_MASS_ASS peso_assiale_pic, ';
       sqlstring:=sqlstring||'(  SELECT SEDE_TECNICA, ';
       sqlstring:=sqlstring||'          LISTAGG (REPLACE (CODICE, '' '', '''') || '' '') ';
       sqlstring:=sqlstring||'             WITHIN GROUP (ORDER BY CODICE) ';
       sqlstring:=sqlstring||'             AS linea ';
       sqlstring:=sqlstring||'     FROM  '||s_schema||'.V_MDR_LINEE_COMMERCIALI ';
        IF p_versione IS NOT NULL THEN
        sqlstring:=sqlstring||'    WHERE CODICE_VERSIONE='||p_versione;
        END IF;
       sqlstring:=sqlstring||' GROUP BY SEDE_TECNICA) linea_comm, ';
       sqlstring:=sqlstring||'(SELECT DISTINCT D.CODICE_TRATTA_ROMAN codice_tratta_roman, ';
       sqlstring:=sqlstring||'                 t.CODICE_LINEA_FCL codice_linea_fcl, ';
       sqlstring:=sqlstring||'                 t.CODICE_LINEA_INVERSA codice_linea_fcl_inversa, ';
       sqlstring:=sqlstring||'                 t.DEFINIZIONE linea_fcl, ';
       sqlstring:=sqlstring||'                 DATA_INIZIO_VALIDITA, ';
       sqlstring:=sqlstring||'                 DAT_FINE_VAL, ';
       sqlstring:=sqlstring||'                 DIREZIONE, ';
       sqlstring:=sqlstring||'                 VMAX_A FCLD_VMAX_A, ';
       sqlstring:=sqlstring||'                 VMAX_B FCLD_VMAX_B, ';
       sqlstring:=sqlstring||'                 VMAX_C FCLD_VMAX_C, ';
       sqlstring:=sqlstring||'                 VMAX_P FCLD_VMAX_P ';
       sqlstring:=sqlstring||'   FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL t, ';
       sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN d ';
       sqlstring:=sqlstring||'  WHERE     T.CODICE_LINEA_FCL = D.CODICE_LINEA_FCL ';
       sqlstring:=sqlstring||'        AND t.FLAG_DISPARI = 1 ';
       sqlstring:=sqlstring||'        AND D.TIPO_PUNTO = 1 ';
       sqlstring:=sqlstring||'        AND D.DIREZIONE IN (2, 3) ';
       sqlstring:=sqlstring||'        AND NVL (DATA_INIZIO_VAL_R, TO_DATE (''01011999'', ''DDMMYYYY'')) <= ';
       sqlstring:=sqlstring||'                TO_DATE('''||d_data_riferimento||''',''DDMMYYYY'') ';
       sqlstring:=sqlstring||'        AND NVL (DAT_FINE_VAL, TO_DATE (''01012999'', ''DDMMYYYY'')) >= ';
       sqlstring:=sqlstring||'                TO_DATE('''||d_data_riferimento||''',''DDMMYYYY'')) l_fd, ';
       sqlstring:=sqlstring||'(SELECT DISTINCT di.CODICE_LINEA_FCL, ';
       sqlstring:=sqlstring||'                 di.CODICE_TRATTA_ROMAN, ';
       sqlstring:=sqlstring||'                 di.PROGR_KM prog_inizio_skt, ';
       sqlstring:=sqlstring||'                 df.PROGR_KM prog_fine_skt ';
       sqlstring:=sqlstring||'   FROM RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN di, ';
       sqlstring:=sqlstring||'        RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN df ';
       sqlstring:=sqlstring||'  WHERE     di.tipo_punto = 1 ';
       sqlstring:=sqlstring||'        AND df.tipo_punto = 2 ';
       sqlstring:=sqlstring||'        AND di.CODICE_LINEA_FCL = df.CODICE_LINEA_FCL ';
       sqlstring:=sqlstring||'        AND di.CODICE_TRATTA_ROMAN = df.CODICE_TRATTA_ROMAN ';
       sqlstring:=sqlstring||'        AND Di.DIREZIONE IN (2, 3) ';
       sqlstring:=sqlstring||'        AND Df.DIREZIONE IN (2, 3)) fcl_dati, ';
       sqlstring:=sqlstring||'(  SELECT CODICE_TRATTA_PIC, ';
       sqlstring:=sqlstring||'          LISTAGG (DEFINIZIONE || '' '') ';
       sqlstring:=sqlstring||'             WITHIN GROUP (ORDER BY DEFINIZIONE) ';
       sqlstring:=sqlstring||'             AS corridoio ';
       sqlstring:=sqlstring||'     FROM RINF_ANAGRAFICHE_EVO.CORRIDOIO_TRATTE l, ';
       sqlstring:=sqlstring||'          RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI t, ';
       sqlstring:=sqlstring||'          RINF_ANAGRAFICHE_EVO.CORRIDOI_633 r ';
       sqlstring:=sqlstring||'    WHERE     r.CODICE_CORRIDOIO = t.CODICE_CORRIDOIO_633 ';
       sqlstring:=sqlstring||'          AND l.CODICE_GIURISDIZIONE = t.CODICE_GIURISDIZIONE ';
       sqlstring:=sqlstring||'          AND l.DATA_SCADENZA IS NULL ';
       sqlstring:=sqlstring||' GROUP BY CODICE_TRATTA_PIC) corridoi, ';
       sqlstring:=sqlstring|| '(SELECT v.SEDE_TECNICA, LISTAGG(PO_1_2_0_0_0_3 ,''-'' ) WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3) AS codice ';
       sqlstring:=sqlstring|| 'from '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v,';
       sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI p';
       sqlstring:=sqlstring|| ' where  ';
       sqlstring:=sqlstring|| ' p.sede_tecnica=v.sede_tecnica ';
       IF p_versione IS NOT NULL THEN
        sqlstring:=sqlstring||'    AND p.CODICE_VERSIONE='||p_versione;
        sqlstring:=sqlstring||'    AND v.CODICE_VERSIONE='||p_versione;
       END IF;
       sqlstring:=sqlstring|| ' GROUP BY v.SEDE_TECNICA) codice_taf_tap_i, ';
       sqlstring:=sqlstring|| '(SELECT v.SEDE_TECNICA, LISTAGG(PO_1_2_0_0_0_3 ,''-'' ) WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3) AS codice ';
       sqlstring:=sqlstring|| 'from '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v,';
       sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI p';
       sqlstring:=sqlstring|| ' where  ';
       sqlstring:=sqlstring|| ' p.sede_tecnica=v.sede_tecnica ';
       IF p_versione IS NOT NULL THEN
        sqlstring:=sqlstring||'    AND p.CODICE_VERSIONE='||p_versione;
        sqlstring:=sqlstring||'    AND v.CODICE_VERSIONE='||p_versione;
       END IF;
       sqlstring:=sqlstring|| ' GROUP BY v.SEDE_TECNICA) codice_taf_tap_f ';
       sqlstring:=sqlstring||'WHERE     s.SEDE_TECNICA = trat_pic.SEDE_TECNICA ';
       sqlstring:=sqlstring||'AND codice_taf_tap_i.SEDE_TECNICA (+)= po_i.SEDE_TECNICA ';
       sqlstring:=sqlstring||'AND codice_taf_tap_f.SEDE_TECNICA (+)= po_f.SEDE_TECNICA ';
       sqlstring:=sqlstring||'AND fl.CODICE_FASCICOLO = f.CODICE_FASCICOLO ';
       sqlstring:=sqlstring||'AND FCL_TRAT_ROMAN.CODICE_LINEA_FCL = FL.CODICE_LINEA_FCL ';
       sqlstring:=sqlstring||'AND FCL_TRAT_ROMAN.CODICE_TRATTA_ROMAN = ';
       sqlstring:=sqlstring||'       TRAT_ROMAN.CODICE_TRATTA_ROMAN ';
       sqlstring:=sqlstring||'AND TRAT_ROMAN.CODICE_TRATTA_PIC = TRAT_PIC.CODICE_TRATTA_PIC_P  ';
       sqlstring:=sqlstring||'AND trat_pic.CODICE_LOCALITA_INIZIO_PIC_P = ';
       sqlstring:=sqlstring||'       LO_IN_PIC.CODICE_LOCALITA_PIC ';
       sqlstring:=sqlstring||'AND trat_pic.CODICE_LOCALITA_FINE_PIC_P = ';
       sqlstring:=sqlstring||'       LO_FIN_PIC.CODICE_LOCALITA_PIC ';
       sqlstring:=sqlstring||'AND loc_rom_in.CODICE_LOCALITA_PIC = LO_IN_PIC.CODICE_LOCALITA_PIC ';
       sqlstring:=sqlstring||'AND loc_rom_fin.CODICE_LOCALITA_PIC = LO_FIN_PIC.CODICE_LOCALITA_PIC ';
       sqlstring:=sqlstring||'AND LO_IN_PIC.COD_LOCALITA_IN_RETE = po_i.SEDE_TECNICA(+) ';
       sqlstring:=sqlstring||'AND LO_FIN_PIC.COD_LOCALITA_IN_RETE = po_f.SEDE_TECNICA(+) ';
       sqlstring:=sqlstring||'AND TIP_LOC_ROM_IN.TIPO_LOCALITA = loc_rom_in.tipo_localita ';
       sqlstring:=sqlstring||'AND TIP_LOC_ROM_FIN.TIPO_LOCALITA = loc_rom_fin.tipo_localita ';
       sqlstring:=sqlstring||'AND trat_roman.CODICE_TRATTA_ROMAN = l_fd.codice_tratta_roman ';
       sqlstring:=sqlstring||'AND l_fd.codice_linea_fcl = t.CODICE_LINEA_FCL ';
       sqlstring:=sqlstring||'AND NVL (t.DATA_INIZIO_VAL_R, TO_DATE (''01011999'', ''DDMMYYYY'')) <= ';
       sqlstring:=sqlstring||'        TO_DATE('''||d_data_riferimento||''',''DDMMYYYY'') ';
       sqlstring:=sqlstring||'AND NVL (t.DAT_FINE_VAL, TO_DATE (''01012999'', ''DDMMYYYY'')) >=  TO_DATE('''||d_data_riferimento||''',''DDMMYYYY'') ';
       sqlstring:=sqlstring||'AND FCL_TRAT_ROMAN.CODICE_TRATTA_ROMAN = ';
       sqlstring:=sqlstring||'       trat_roman.CODICE_TRATTA_ROMAN ';
       sqlstring:=sqlstring||'AND FCL_TRAT_ROMAN.CODICE_LINEA_FCL = t.CODICE_LINEA_FCL ';
       sqlstring:=sqlstring||'AND TIPO_BLOCCO_PIC.CODICE_TIPO(+) = TRAT_PIC.CODICE_TIPO_BLOCCO_D ';
       sqlstring:=sqlstring||'AND TIPO_BLOCCO_PIC.DATA_SCADENZA IS NULL ';
       sqlstring:=sqlstring||'AND TIPO_TRAZIONE_PIC.CODICE_TIPO(+) = TRAT_PIC.CODICE_TIPOTRAZIONE_D ';
       sqlstring:=sqlstring||'AND TIPO_TRAZIONE_PIC.DATA_SCADENZA IS NULL ';
       sqlstring:=sqlstring||'AND regione_roman.CODICE_REGIONE = TRAT_ROMAN.CODICE_REGIONE ';
       sqlstring:=sqlstring||'AND regione_roman.data_SCADENZA IS NULL ';
       sqlstring:=sqlstring||'AND linea_comm.SEDE_TECNICA = s.SEDE_TECNICA ';
       sqlstring:=sqlstring||'AND tipo_esercizio_pic.CODICE_TIPO(+) = ';
       sqlstring:=sqlstring||'       TRAT_PIC.CODICE_TIPO_ESERCIZIO_D ';
       sqlstring:=sqlstring||'AND TIPO_ESERCIZIO_PIC.DATA_SCADENZA IS NULL ';
       sqlstring:=sqlstring||'AND TRASPORTO_COMB_PIC.CODICE_TRASPORTO(+) = ';
       sqlstring:=sqlstring||'       TRAT_PIC.CODICE_TIPO_TRASP_COMBINATO1_D ';
       sqlstring:=sqlstring||'AND TRASPORTO_COMB_PIC.DATA_SCADENZA IS NULL ';
       sqlstring:=sqlstring||'AND PESO_ASSIALE_PIC.CODICE_TIPO(+) = ';
       sqlstring:=sqlstring||'       TRAT_PIC.CODICE_CAT_LINEA_MAS_ASS_D ';
       sqlstring:=sqlstring||'AND PESO_ASSIALE_PIC.DATA_SCADENZA IS NULL ';
       sqlstring:=sqlstring||'AND fcl_dati.CODICE_LINEA_FCL = fcl_trat_roman.CODICE_LINEA_FCL ';
       sqlstring:=sqlstring||'AND fcl_dati.CODICE_TRATTA_ROMAN = fcl_trat_roman.CODICE_TRATTA_ROMAN ';
       sqlstring:=sqlstring||'AND TRAT_PIC.CODICE_TRATTA_PIC_P = corridoi.CODICE_TRATTA_PIC(+) ';
       IF p_versione IS NOT NULL THEN
        sqlstring:=sqlstring||'    AND s.CODICE_VERSIONE='||p_versione;
        sqlstring:=sqlstring||'    AND po_i.CODICE_VERSIONE='||p_versione;
        sqlstring:=sqlstring||'    AND po_f.CODICE_VERSIONE='||p_versione;
        END IF;

        --filtro richiamato dalla funzione ROUTING in due punti in questa procedura (2/2)
        IF p_filtro is NOT NULL THEN
        s_filtro:=UPPER(GetWhereCondition(p_filtro,'s.SEDE_TECNICA'));
        sqlstring:=sqlstring ||substr(s_filtro,1,instr(s_filtro,'ORDER')-1);--siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
        END IF;

        sqlstring:=sqlstring ||') tab_esterna ';

       --filtro richiamato dalla funzione ROUTING inserito alla fine della tabella "esterna" perch  internamente ho 2 UNION e non avrei potuto fare l'ORDER
        IF p_filtro is NOT NULL THEN
        s_filtro:=UPPER(GetWhereCondition(p_filtro,'tab_esterna.CodiceTrattaIne'));
        sqlstring:=sqlstring ||substr(s_filtro,instr(s_filtro,'ORDER'));
        ELSE--se non ho p_filtro del ROUTING
             sqlstring:=sqlstring||'ORDER BY 1, ';
              sqlstring:=sqlstring||'  2, ';
              sqlstring:=sqlstring||'  3, ';
              sqlstring:=sqlstring||'  8 ';
        END IF;

     DBMS_OUTPUT.PUT_LINE(sqlstring);
    OPEN p_cursor FOR sqlstring;
END GetMDRReport;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--

PROCEDURE GetCircolabilitaSOL (p_area NUMBER,p_i_versione NUMBER , p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.1.8
    s_schema VARCHAR2(100);
    sqlstring VARCHAR2(32767);
    p_versione NUMBER;
    BEGIN
     s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
     --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
     IF (p_area=1 OR p_area=3) THEN
      p_versione:=NULL;
     ELSE  --(p_area=2 OR p_area=4)
         IF  p_i_versione IS NULL THEN
            p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
         ELSE
            p_versione:=p_i_versione;
         END IF;
     END IF;

 --
 -- _CiIRC NEI NOMI   STATO AGGIUNTO PER CREARE ETICHETTE INDIPENDENTI DAGLI ALTRI REPORT
 -- (VISTO CHE QUESTO REPORT HA UN SIGNIFICATO DIVERSO PER RFI E LO FARA' CIRCOLARE FUORI DAL RINF)
 --
sqlstring:='  SELECT SL.SEDE_TECNICA SEDE_TECNICA_CIRC, ';
sqlstring:=sqlstring || '         SL.DEFINIZIONE DEFINIZIONE_CIRC, ';
sqlstring:=sqlstring || '         CODICE_DTP CODICE_DTP_CIRC, ';
sqlstring:=sqlstring || '         CODICE_UT CODICE_UT_CIRC, ';
sqlstring:=sqlstring || '         s.SOL_TRACK_1_1_1_0_0_1 SOL_TRACK_1_1_1_0_0_1_CIRC, ';
sqlstring:=sqlstring || '         s.SOL_TRACK_1_1_1_0_0_1_D SOL_TRACK_1_1_1_0_0_1_D_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_1_2_4_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_1_2_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', cap_carico.SOL_TRACK_1_1_1_1_2_4) SOL_TRACK_1_1_1_1_2_4_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_1_3_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_1_3_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', SOL_TRACK_1_1_1_1_3_1) SOL_TRACK_1_1_1_1_3_1_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_1_3_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_1_3_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_1_3_2) SOL_TRACK_1_1_1_1_3_2_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_1_3_3_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_1_3_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_1_3_3) SOL_TRACK_1_1_1_1_3_3_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_1_3_6_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_1_3_6_AP, ''NYA'','' '', ''N'', ''Non applicabile'',p.gradiente )SOL_TRACK_1_1_1_1_3_6_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_1_3_7_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_1_3_7_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_1_3_7)SOL_TRACK_1_1_1_1_3_7_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_1_4_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_1_4_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_1_4_1)SOL_TRACK_1_1_1_1_4_1_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_1_4_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_1_4_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_1_4_2)SOL_TRACK_1_1_1_1_4_2_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_1_4_4_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_1_4_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_1_4_4)SOL_TRACK_1_1_1_1_4_4_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_1_5_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_1_5_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_1_5_2)SOL_TRACK_1_1_1_1_5_2_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_1_7_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_1_7_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_1_7_1)SOL_TRACK_1_1_1_1_7_1_CIRC, ';
sqlstring:=sqlstring || '     ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_2_2_1_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_2_2_1_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetOptionalValue(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1)) SOL_TRACK_1_1_1_2_2_1_1_CIRC, ';   --messa solo qui la funzione get perch  nella tabella dominio_parametro in rinf_anagrafica c'  la codifica_valore corta (10,20,30,ecc.) al posto del valore
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_2_2_1_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_2_2_1_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetOptionalValue(''1.1.1.2.2.1.2'',SOL_TRACK_1_1_1_2_2_1_2)) SOL_TRACK_1_1_1_2_2_1_2_CIRC, '; --messa solo qui la funzione get perch  nella tabella dominio_parametro in rinf_anagrafica c'  la codifica_valore corta (10,20,30,ecc.) al posto del valore
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_2_2_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_2_2_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_2_2_2) SOL_TRACK_1_1_1_2_2_2_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_2_2_3_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_2_2_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_2_2_3) SOL_TRACK_1_1_1_2_2_3_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_2_2_6_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_2_2_6_AP, ''NYA'','' '', ''N'', ''Non applicabile'',TRIM (TO_CHAR (ROUND (SOL_TRACK_1_1_1_2_2_6, 2), ''999990.99''))) SOL_TRACK_1_1_1_2_2_6_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_2_3_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_2_3_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_2_3_1) SOL_TRACK_1_1_1_2_3_1_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_2_3_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_2_3_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_2_3_2) SOL_TRACK_1_1_1_2_3_2_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_2_3_3_AP, ';
sqlstring:=sqlstring || '         DECODE( SOL_TRACK_1_1_1_2_3_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring || '            DECODE ( ';
sqlstring:=sqlstring || '               SOL_TRACK_1_1_1_2_3_3_A ';
sqlstring:=sqlstring || '            || '' '' ';
sqlstring:=sqlstring || '            || SOL_TRACK_1_1_1_2_3_3_B ';
sqlstring:=sqlstring || '            || '' '' ';
sqlstring:=sqlstring || '            || SOL_TRACK_1_1_1_2_3_3_C, ';
sqlstring:=sqlstring || '            ''++'', NULL, ';
sqlstring:=sqlstring || '               SOL_TRACK_1_1_1_2_3_3_A ';
sqlstring:=sqlstring || '            || '' '' ';
sqlstring:=sqlstring || '            || SOL_TRACK_1_1_1_2_3_3_B ';
sqlstring:=sqlstring || '            || '' '' ';
sqlstring:=sqlstring || '            || SOL_TRACK_1_1_1_2_3_3_C)) ';
sqlstring:=sqlstring || '            SOL_TRACK_1_1_1_2_3_3_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_2_3_4_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_2_3_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_2_3_4)SOL_TRACK_1_1_1_2_3_4_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_2_5_3_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_2_5_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', SOL_TRACK_1_1_1_2_5_3) SOL_TRACK_1_1_1_2_5_3_CIRC, ';
sqlstring:=sqlstring || '          ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_2_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_2_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_2_1)SOL_TRACK_1_1_1_3_2_1_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_2_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_2_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_2_2)SOL_TRACK_1_1_1_3_2_2_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_2_3_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_2_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_2_3)SOL_TRACK_1_1_1_3_2_3_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_2_4_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_2_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_2_4)SOL_TRACK_1_1_1_3_2_4_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_2_5_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_2_5_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_2_5) SOL_TRACK_1_1_1_3_2_5_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_2_6_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_2_6_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_2_6) SOL_TRACK_1_1_1_3_2_6_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_3_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_3_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_3_1)SOL_TRACK_1_1_1_3_3_1_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_3_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_3_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_3_2)SOL_TRACK_1_1_1_3_3_2_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_5_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_5_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_5_1)SOL_TRACK_1_1_1_3_5_1_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_5_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_5_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_5_2)SOL_TRACK_1_1_1_3_5_2_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_6_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_6_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_6_1)SOL_TRACK_1_1_1_3_6_1_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_1) SOL_TRACK_1_1_1_3_7_1_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_2_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_2_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_2_1)SOL_TRACK_1_1_1_3_7_2_1_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_2_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_2_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_2_2)SOL_TRACK_1_1_1_3_7_2_2_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_3_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_3)SOL_TRACK_1_1_1_3_7_3_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_4_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_4)SOL_TRACK_1_1_1_3_7_4_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_5_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_5_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_5)SOL_TRACK_1_1_1_3_7_5_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_6_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_6_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_6)SOL_TRACK_1_1_1_3_7_6_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_7_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_7_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_7)SOL_TRACK_1_1_1_3_7_7_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_8_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_8_AP, ''NYA'','' '', ''N'', ''Non applicabile'',TRIM (TO_CHAR (ROUND (SOL_TRACK_1_1_1_3_7_8, 1), ''999990.9''))) SOL_TRACK_1_1_1_3_7_8_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_9_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_9_AP, ''NYA'','' '', ''N'', ''Non applicabile'',TRIM (TO_CHAR (ROUND (SOL_TRACK_1_1_1_3_7_9, 1), ''999990.9''))) SOL_TRACK_1_1_1_3_7_9_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_10_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_10_AP, ''NYA'','' '', ''N'', ''Non applicabile'',TRIM (TO_CHAR (ROUND (SOL_TRACK_1_1_1_3_7_10, 1), ''999990.9'')) ) SOL_TRACK_1_1_1_3_7_10_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_11_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_11_AP, ''NYA'','' '', ''N'', ''Non applicabile'',TRIM (TO_CHAR (ROUND (SOL_TRACK_1_1_1_3_7_11, 1), ''999990.9'')))     SOL_TRACK_1_1_1_3_7_11_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_14_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_14_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_14)SOL_TRACK_1_1_1_3_7_14_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_15_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_15_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_15_1)SOL_TRACK_1_1_1_3_7_15_1_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_15_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_15_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',TRIM (TO_CHAR (ROUND (SOL_TRACK_1_1_1_3_7_15_2, 3), ''999990.999'')))   SOL_TRACK_1_1_1_3_7_15_2_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_16_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_16_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_16)SOL_TRACK_1_1_1_3_7_16_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_17_AP, ';
sqlstring:=sqlstring || '         DECODE( SOL_TRACK_1_1_1_3_7_17_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_17)SOL_TRACK_1_1_1_3_7_17_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_7_18_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_7_18_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_7_18)SOL_TRACK_1_1_1_3_7_18_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_8_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_8_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_8_1)SOL_TRACK_1_1_1_3_8_1_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_8_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_8_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_8_2)SOL_TRACK_1_1_1_3_8_2_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_10_1_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_10_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_10_1)SOL_TRACK_1_1_1_3_10_1_CIRC, ';
--sqlstring:=sqlstring || '         SOL_TRACK_1_1_1_3_10_2_AP, ';
sqlstring:=sqlstring || '         DECODE(SOL_TRACK_1_1_1_3_10_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',SOL_TRACK_1_1_1_3_10_2)SOL_TRACK_1_1_1_3_10_2_CIRC ';
sqlstring:=sqlstring || '    FROM  '||s_schema||'.BINARI_CORSA_SOL s ';
sqlstring:=sqlstring || '    , ';
sqlstring:=sqlstring || '    '||s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring || '    , ';
sqlstring:=sqlstring || '         (  SELECT SOL_TRACK_1_1_1_0_0_1, ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring || '                   CODICE_VERSIONE, ';
END IF;
sqlstring:=sqlstring || '                   LISTAGG ( ';
sqlstring:=sqlstring || '                      DECODE ( ';
sqlstring:=sqlstring || '                         SIGN (PENDENZA), ';
sqlstring:=sqlstring || '                         -1, TRIM (TO_CHAR (PENDENZA, ''9999999999999990.9'')), ';
sqlstring:=sqlstring || '                         ''+'' || TRIM (TO_CHAR (PENDENZA, ''9999999999999990.9''))) ';
sqlstring:=sqlstring || '                      || ''('' ';
sqlstring:=sqlstring || '                      || TRIM ( ';
sqlstring:=sqlstring || '                            TO_CHAR (LEAST (KM_INIZIO, KM_FINE), ';
sqlstring:=sqlstring || '                                     ''9999999999999990.999'')) ';
sqlstring:=sqlstring || '                      || '')'', ';
sqlstring:=sqlstring || '                      '';'') ';
sqlstring:=sqlstring || '                   WITHIN GROUP (ORDER BY LEAST (KM_INIZIO, KM_FINE)) ';
sqlstring:=sqlstring || '                      AS gradiente ';
sqlstring:=sqlstring || '              FROM  '||s_schema||'.PAR_1_1_1_1_3_6_GRADIENTE ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring || '              WHERE CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring || '          GROUP BY SOL_TRACK_1_1_1_0_0_1 ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring || '   , CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring || '   ) p, ';
sqlstring:=sqlstring || '           ';
sqlstring:=sqlstring || '         (  SELECT SOL_TRACK_1_1_1_0_0_1, ';
sqlstring:=sqlstring || '                   LISTAGG (VALORE, '';'') ';
sqlstring:=sqlstring || '                      WITHIN GROUP (ORDER BY VALORE) ';
sqlstring:=sqlstring || '                      AS SOL_TRACK_1_1_1_1_2_4 ';
sqlstring:=sqlstring || '              FROM  '||s_schema||'.PAR_1_1_1_1_2_4_CAP_CARICO, ';
sqlstring:=sqlstring || '                   RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstring:=sqlstring || '                   RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
sqlstring:=sqlstring || '             WHERE     c.codice_parametro = d.codice_parametro ';
sqlstring:=sqlstring || '                   AND numero_parametro = ''1.1.1.1.2.4'' ';
sqlstring:=sqlstring || '                   AND SOL_TRACK_1_1_1_1_2_4 = CODIFICA_VALORE ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring || '                   AND CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring || '          GROUP BY SOL_TRACK_1_1_1_0_0_1 ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring || '     , CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring || '     ) cap_carico ';
sqlstring:=sqlstring || '        ';
sqlstring:=sqlstring || 'WHERE  S.SEDE_TECNICA=SL.SEDE_TECNICA ';
sqlstring:=sqlstring || '         AND S.SOL_TRACK_1_1_1_0_0_1 = P.SOL_TRACK_1_1_1_0_0_1(+) ';
sqlstring:=sqlstring || '         AND S.SOL_TRACK_1_1_1_0_0_1 = cap_carico.SOL_TRACK_1_1_1_0_0_1(+) ';
--sqlstring:=sqlstring || '         AND rownum < 1000 ';        --solo per testare la procedura
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring || '         AND S.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring || '         AND SL.CODICE_VERSIONE=S.CODICE_VERSIONE ';
END IF;

--filtro richiamato dalla funzione ROUTING
IF p_filtro is NOT NULL THEN
sqlstring:=sqlstring ||GetWhereCondition(p_filtro,'SL.SEDE_TECNICA');
END IF;

--sqlstring:=sqlstring || '         ORDER BY 1 ';
DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetCircolabilitaSOL;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetRneTisPO  (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.1.9
s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;
BEGIN

s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;

 sqlstring:=' SELECT SIGLA_LOCALITA "ABBREV", ';
sqlstring:=sqlstring|| ' NOME_LOCALITA40 "NOME", ';
sqlstring:=sqlstring|| ' CODICE_LOCALITA_MIR "CODICE", ';
sqlstring:=sqlstring|| ' l.PO_1_2_0_0_0_2 "PO_1_2_0_0_0_2", ';
sqlstring:=sqlstring|| ' t.codice "PO_1_2_0_0_0_3", ';
sqlstring:=sqlstring|| ' ''IT'' "IG_CODICE_NAZ", ';
sqlstring:=sqlstring|| ' TRUNC(LATITUDINE,4) "LATITUDINE", ';
sqlstring:=sqlstring|| ' TRUNC(LONGITUDINE,4) "LONGITUDINE", ';
sqlstring:=sqlstring|| ' DECODE (PO_1_2_0_0_0_4, ';
sqlstring:=sqlstring|| '         ''station'', ''Basic'', ';
sqlstring:=sqlstring|| '         ''small station'', ''Passing'', ';
sqlstring:=sqlstring|| '         ''passenger terminal'', ''Reporting'', ';
sqlstring:=sqlstring|| '         ''freight terminal'', ''Reporting'', ';
sqlstring:=sqlstring|| '         ''depot or workshop'', ''Basic'', ';
sqlstring:=sqlstring|| '         ''train technical services'', ''Passing'', ';
sqlstring:=sqlstring|| '         ''passenger stop'', ''Passing'', ';
sqlstring:=sqlstring|| '         ''junction'', ''Passing'', ';
sqlstring:=sqlstring|| '         ''shunting yard'', ''Basic'', ';
sqlstring:=sqlstring|| '         ''technical change'', ''Passing'', ';
sqlstring:=sqlstring|| '         ''switch'', ''Passing'', ';
sqlstring:=sqlstring|| '         ''private siding'', ''Basic'', ';
sqlstring:=sqlstring|| '         ''border point'', ''Forecast and handover'', ';
sqlstring:=sqlstring|| '         ''domestic border point'', ''Handover'', ';
sqlstring:=sqlstring|| '         PO_1_2_0_0_0_4) ';
sqlstring:=sqlstring|| '    "TIPO", ';
sqlstring:=sqlstring|| ' CODICE_LOCALITA_PIC "CODICE_PIC", ';
sqlstring:=sqlstring|| ' p.COD_LOCALITA_IN_RETE "CODICE_INRETE" ';
sqlstring:=sqlstring|| ' FROM rinf_anagrafiche_evo.localita_pic p, ';
sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI l, ';
sqlstring:=sqlstring|| ' (  SELECT v.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '           LISTAGG (PO_1_2_0_0_0_3, ''-'') ';
sqlstring:=sqlstring|| '              WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3) ';
sqlstring:=sqlstring|| '              AS codice ';
sqlstring:=sqlstring|| '      FROM '|| s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v, ';
sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI p ';
sqlstring:=sqlstring|| '     WHERE  p.sede_tecnica = v.sede_tecnica ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '           AND v.CODICE_VERSIONE = '||p_versione;
sqlstring:=sqlstring|| '           AND v.CODICE_VERSIONE = p.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| ' GROUP BY v.SEDE_TECNICA) t ';
sqlstring:=sqlstring|| ' WHERE COD_LOCALITA_IN_RETE = l.sede_tecnica  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| ' AND codice_versione = '||p_versione;
END IF;
sqlstring:=sqlstring|| ' AND t.sede_tecnica=l.sede_tecnica ';


--filtro richiamato dalla funzione ROUTING DA COSTRUIRE A PARTE
IF p_filtro is NOT NULL THEN
sqlstring:=sqlstring ||GetWhereCondition(p_filtro,'p.COD_LOCALITA_IN_RETE');
END IF;


 --DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetRneTisPO ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetRneTisSOL  (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.1.10
s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;
BEGIN

 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;

 sqlstring:=' SELECT DECODE (pi.RETE_PROPRIETARIA, ';
sqlstring:=sqlstring|| '         83, ''RFI'', ';
sqlstring:=sqlstring|| '         64, ''FNM'', ';
sqlstring:=sqlstring|| '         85, ''SBB'', ';
sqlstring:=sqlstring|| '         pi.RETE_PROPRIETARIA) ';
sqlstring:=sqlstring|| '    "GI_PO_INIZIO", ';
sqlstring:=sqlstring|| ' pi.CODICE_LOCALITA_MIR "CODICE_MIR_PO_INIZIO ", ';
sqlstring:=sqlstring|| ' li.PO_1_2_0_0_0_2 "PO_INIZIO_1_2_0_0_0_2",  ';
sqlstring:=sqlstring|| ' ti.codice "PO_INIZIO_1_2_0_0_0_3", ';
sqlstring:=sqlstring|| ' pi.SIGLA_LOCALITA "PO_INIZIO_ABBREV", ';
sqlstring:=sqlstring|| ' pi.NOME_LOCALITA40 "PO_INIZIO_NOME", ';
sqlstring:=sqlstring|| ' DECODE (pf.RETE_PROPRIETARIA, ';
sqlstring:=sqlstring|| '         83, ''RFI'', ';
sqlstring:=sqlstring|| '         64, ''FNM'', ';
sqlstring:=sqlstring|| '         85, ''SBB'', ';
sqlstring:=sqlstring|| '         pf.RETE_PROPRIETARIA) ';
sqlstring:=sqlstring|| '    "GI_PO_FINE",   ';
sqlstring:=sqlstring|| ' pf.CODICE_LOCALITA_MIR "CODICE_MIR_PO_FINE", ';
sqlstring:=sqlstring|| ' lf.PO_1_2_0_0_0_2 "PO_FINE_1_2_0_0_0_2", ';
sqlstring:=sqlstring|| ' tf.codice "PO_FINE_1_2_0_0_0_3", ';
sqlstring:=sqlstring|| ' pf.SIGLA_LOCALITA "PO_FINE_ABBREV", ';
sqlstring:=sqlstring|| ' pf.NOME_LOCALITA40 "PO_FINE_NOME",  ';
sqlstring:=sqlstring|| ' s.LUNGHEZZA "DISTANZA", ';
sqlstring:=sqlstring|| ' S.CODICE_TRATTA_PIC "CODICE_PIC", ';
sqlstring:=sqlstring|| ' s.SEDE_TECNICA "CODICE_INRETE" ';
sqlstring:=sqlstring|| ' FROM rinf_anagrafiche_evo.tratte_pic s, ';
sqlstring:=sqlstring|| s_schema||'.sezioni_linea r, ';
sqlstring:=sqlstring|| ' rinf_anagrafiche_evo.localita_pic pi, ';
sqlstring:=sqlstring|| ' rinf_anagrafiche_evo.localita_pic pf, ';
sqlstring:=sqlstring|| s_schema||'.punti_operativi li, ';
sqlstring:=sqlstring|| s_schema||'.punti_operativi lf, ';
sqlstring:=sqlstring|| ' (  SELECT v.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '           LISTAGG (PO_1_2_0_0_0_3, ''-'') ';
sqlstring:=sqlstring|| '              WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3) ';
sqlstring:=sqlstring|| '              AS codice ';
sqlstring:=sqlstring|| '      FROM '|| s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v,  ';
sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI p  ';
sqlstring:=sqlstring|| '     WHERE     p.sede_tecnica = v.sede_tecnica  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '           AND v.CODICE_VERSIONE='||p_versione;
sqlstring:=sqlstring|| '           AND v.CODICE_VERSIONE = p.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '  GROUP BY v.SEDE_TECNICA) ti, ';
sqlstring:=sqlstring|| ' (  SELECT v.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '           LISTAGG (PO_1_2_0_0_0_3, ''-'') ';
sqlstring:=sqlstring|| '              WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3)   ';
sqlstring:=sqlstring|| '              AS codice ';
sqlstring:=sqlstring|| '      FROM '|| s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v, ';
sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI p ';
sqlstring:=sqlstring|| '     WHERE p.sede_tecnica = v.sede_tecnica';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '           AND v.CODICE_VERSIONE='||p_versione;
sqlstring:=sqlstring|| '           AND v.CODICE_VERSIONE = p.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '  GROUP BY v.SEDE_TECNICA) tf ';
sqlstring:=sqlstring|| ' WHERE r.sede_tecnica = s.sede_tecnica   ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| ' AND r.codice_versione ='||p_versione;
sqlstring:=sqlstring|| ' AND li.codice_versione ='||p_versione;
sqlstring:=sqlstring|| ' AND lf.codice_versione ='||p_versione;
END IF;
sqlstring:=sqlstring|| ' AND pi.CODICE_LOCALITA_PIC = s.CODICE_LOCALITA_INIZIO_PIC ';
sqlstring:=sqlstring|| ' AND pf.CODICE_LOCALITA_PIC = s.CODICE_LOCALITA_FINE_PIC  ';
sqlstring:=sqlstring|| ' AND pi.COD_LOCALITA_IN_RETE = li.sede_tecnica ';
sqlstring:=sqlstring|| ' AND pf.COD_LOCALITA_IN_RETE = lf.sede_tecnica   ';
sqlstring:=sqlstring|| ' AND li.sede_tecnica = ti.sede_Tecnica ';
sqlstring:=sqlstring|| ' AND lf.sede_tecnica = tf.sede_Tecnica ';

--filtro richiamato dalla funzione ROUTING
IF p_filtro is NOT NULL THEN
sqlstring:=sqlstring ||GetWhereCondition(p_filtro,'s.SEDE_TECNICA');
END IF;

--DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetRneTisSOL ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
-- -------------------------------------------------------------------------
--  PKG_RINF_REPORT.GetSchemaAutorizzRI **** NEW ****
-- -------------------------------------------------------------------------
--
PROCEDURE GetSchemaAutorizzRI  (p_i_versione NUMBER, p_cursor OUT empcur) Is
--
--REPORT 3.2.1
--
     sqlstring VARCHAR2(32767);
--
BEGIN
--
sqlstring:= 'SELECT vers.CODICE_VERSIONE,';
sqlstring:=sqlstring|| ' DECODE (vers.PROTOCOLLO, NULL, ''RI-Pronto'', ''RI-Pubblicato/Inviato'') "STATO",';
sqlstring:=sqlstring|| ' to_char(vers.DATA_PUBBLICAZIONE,''DD/MM/YY HH:MI:SS'') DATA_PUBBLICAZIONE,  ';
sqlstring:=sqlstring|| ' vers.PROTOCOLLO,';
sqlstring:=sqlstring|| ' to_char(DATA_RICHIESTA,''DD/MM/YY HH:MI:SS'') DATA_RICHIESTA,  ';
sqlstring:=sqlstring|| ' to_char(sysdate,''DD/MM/YY HH:MI:SS'') DATA_PRODUZIONE_REPORT,  ';
sqlstring:=sqlstring|| ' anagut.CODICE_UTENTE,';
sqlstring:=sqlstring|| ' anagut.MATRICOLA,';
sqlstring:=sqlstring|| ' anagut.NOME, ';
sqlstring:=sqlstring|| ' anagut.COGNOME, ';
sqlstring:=sqlstring|| ' DECODE (FLAG_SEDE_CENTRALE, 0, ''DTP'', SIGLA_TIPO_DEPOSITARIO) "COMPETENZA",';
sqlstring:=sqlstring|| ' elenco_aut.CODICE_DTP,';
sqlstring:=sqlstring|| ' TOTALE_SOL, ';
sqlstring:=sqlstring|| ' TOTALE_OP,';
sqlstring:=sqlstring|| ' TO_CHAR (DATA_AUTORIZZAZIONE, ''DD/MM/YY HH:MI:SS'') "DATA_AUTORIZZAZIONE"';
--	   
sqlstring:=sqlstring||' From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI ara,';
--
sqlstring:=sqlstring||'(Select Distinct vers.CODICE_VERSIONE, DATA_PUBBLICAZIONE, PROTOCOLLO, DATA_RIFERIMENTO, CODICE_AUTORIZZAZIONE ';
sqlstring:=sqlstring||' From Rinf_Pubblicati_Evo.VERSIONE_RINF vers,  Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI veraut ';
sqlstring:=sqlstring||' Where vers.CODICE_VERSIONE = veraut.CODICE_VERSIONE ';
sqlstring:=sqlstring||' And vers.CODICE_VERSIONE = '||   p_i_versione;
sqlstring:=sqlstring||' And FLAG_NEW = 1)  vers, '; 
--
sqlstring:=sqlstring||' Rinf_Sicurezza_Evo.ANAG_TIPO_DEPOSITARIO tipoSC, ';
--
sqlstring:=sqlstring||'	(Select ID_UTENTE, CODICE_UTENTE, MATRICOLA, NOME, COGNOME ';
sqlstring:=sqlstring||' From Rinf_Sicurezza_Evo.ANAG_UTENTE ';         
sqlstring:=sqlstring||' Union ';                                         
sqlstring:=sqlstring||' Select ID_UTENTE, CODICE_UTENTE, MATRICOLA, NOME, COGNOME ';
sqlstring:=sqlstring||' From Rinf_Sicurezza_Evo.V_UTENTE_RUOLO_H  Where DATA_SCADENZA Is Not Null) anagut, ';
--
sqlstring:=sqlstring||' (select distinct detaut.CODICE_RICHIESTA, detaut.ID_UTENTE, detaut.FLAG_SEDE_CENTRALE, detaut.CODICE_DTP, ';
sqlstring:=sqlstring||' detaut.TOTALE_SOL, detaut.TOTALE_OP, detaut.CODICE_STATO_RICHIESTA, detaut.DATA_AUTORIZZAZIONE ';
sqlstring:=sqlstring||' From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI detaut, ';
sqlstring:=sqlstring||' (Select CODICE_RICHIESTA, CODICE_DTP,''Sede Centrale:'' || SIGLA_TIPO_DEPOSITARIO,';
sqlstring:=sqlstring||' CODICE_TIPO_DEPOSITARIO FLAG_SEDE_CENTRALE, Max(CODICE_STATO_RICHIESTA) CODICE_STATO_RICHIESTA, ';
sqlstring:=sqlstring||' Max (DATA_AUTORIZZAZIONE) DATA_AUTORIZZAZIONE ';
sqlstring:=sqlstring||' From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI c, ';
sqlstring:=sqlstring||' Rinf_Sicurezza_Evo.ANAG_TIPO_DEPOSITARIO d ';
sqlstring:=sqlstring||' Where d.CODICE_TIPO_DEPOSITARIO = c.FLAG_SEDE_CENTRALE ';
sqlstring:=sqlstring||' And c.CODICE_RICHIESTA = (Select Distinct CODICE_AUTORIZZAZIONE ';
sqlstring:=sqlstring||' From  Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI Where CODICE_VERSIONE = '||p_i_versione;
sqlstring:=sqlstring||' And FLAG_NEW = 1)  Group By CODICE_RICHIESTA, CODICE_DTP, SIGLA_TIPO_DEPOSITARIO, CODICE_TIPO_DEPOSITARIO ';
sqlstring:=sqlstring||' union  Select CODICE_RICHIESTA, CODICE_DTP, ''Territorio'', 0, ';
sqlstring:=sqlstring||' Max (CODICE_STATO_RICHIESTA) CODICE_STATO_RICHIESTA, Max (DATA_AUTORIZZAZIONE) DATA_AUTORIZZAZIONE ';
sqlstring:=sqlstring||' From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI ';
sqlstring:=sqlstring||' Where CODICE_RICHIESTA = (Select Distinct CODICE_AUTORIZZAZIONE From  Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI ';
sqlstring:=sqlstring||' Where CODICE_VERSIONE = '|| p_i_versione;
sqlstring:=sqlstring||' And FLAG_NEW = 1)  And FLAG_SEDE_CENTRALE = 0 ';
sqlstring:=sqlstring||' Group By CODICE_RICHIESTA, CODICE_DTP ) elenco ';
sqlstring:=sqlstring||' Where detaut.CODICE_RICHIESTA  = elenco.CODICE_RICHIESTA  and detaut.CODICE_DTP  = elenco.CODICE_DTP  ';
sqlstring:=sqlstring||' and detaut.FLAG_SEDE_CENTRALE  = elenco.FLAG_SEDE_CENTRALE   and detaut.CODICE_STATO_RICHIESTA  = elenco.CODICE_STATO_RICHIESTA ';
sqlstring:=sqlstring||' and detaut.CODICE_STATO_RICHIESTA = 2 and detaut.CODICE_RICHIESTA = (Select Distinct CODICE_AUTORIZZAZIONE ';
sqlstring:=sqlstring||' From  Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI  Where CODICE_VERSIONE = '|| p_i_versione;
sqlstring:=sqlstring||' And FLAG_NEW = 1)  Union ';
sqlstring:=sqlstring||' Select Distinct  detaut.CODICE_RICHIESTA, Null ID_UTENTE, detaut.FLAG_SEDE_CENTRALE, ';
sqlstring:=sqlstring||' detaut.CODICE_DTP, detaut.TOTALE_SOL, detaut.TOTALE_OP, detaut.CODICE_STATO_RICHIESTA, detaut.DATA_AUTORIZZAZIONE ';
sqlstring:=sqlstring||' From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI detaut,  ';
--
sqlstring:=sqlstring||' (Select CODICE_RICHIESTA, CODICE_DTP, ''Sede Centrale:'' || SIGLA_TIPO_DEPOSITARIO, ';
sqlstring:=sqlstring||' CODICE_TIPO_DEPOSITARIO FLAG_SEDE_CENTRALE, ';
sqlstring:=sqlstring||' Max(CODICE_STATO_RICHIESTA) CODICE_STATO_RICHIESTA, Max(DATA_AUTORIZZAZIONE) DATA_AUTORIZZAZIONE ';
sqlstring:=sqlstring||' From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI c, ';
sqlstring:=sqlstring||' Rinf_Sicurezza_Evo.ANAG_TIPO_DEPOSITARIO d ';
sqlstring:=sqlstring||' Where d.CODICE_TIPO_DEPOSITARIO = c.FLAG_SEDE_CENTRALE and CODICE_RICHIESTA = ';
sqlstring:=sqlstring||' (Select Distinct CODICE_AUTORIZZAZIONE From Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI  Where CODICE_VERSIONE = '|| p_i_versione;
sqlstring:=sqlstring||' And FLAG_NEW = 1) Group By CODICE_RICHIESTA, CODICE_DTP, SIGLA_TIPO_DEPOSITARIO, CODICE_TIPO_DEPOSITARIO ';
--
sqlstring:=sqlstring||' union  Select CODICE_RICHIESTA, CODICE_DTP, ''Territorio'', 0, ';
sqlstring:=sqlstring||' Max(CODICE_STATO_RICHIESTA) CODICE_STATO_RICHIESTA, Max(DATA_AUTORIZZAZIONE) DATA_AUTORIZZAZIONE ';
sqlstring:=sqlstring||' From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI ';
sqlstring:=sqlstring||' Where CODICE_RICHIESTA = (Select Distinct CODICE_AUTORIZZAZIONE ';
sqlstring:=sqlstring||' From  Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI  Where CODICE_VERSIONE = '|| p_i_versione;
sqlstring:=sqlstring||' And FLAG_NEW = 1)  And FLAG_SEDE_CENTRALE = 0 Group By CODICE_RICHIESTA, CODICE_DTP) elenco ';
sqlstring:=sqlstring||' where detaut.CODICE_RICHIESTA = elenco.CODICE_RICHIESTA and detaut.CODICE_DTP = elenco.CODICE_DTP ';
sqlstring:=sqlstring||' and detaut.FLAG_SEDE_CENTRALE = elenco.FLAG_SEDE_CENTRALE and detaut.CODICE_STATO_RICHIESTA = elenco.CODICE_STATO_RICHIESTA ';
sqlstring:=sqlstring||' and nvl(detaut.DATA_AUTORIZZAZIONE, sysdate) = nvl(elenco.DATA_AUTORIZZAZIONE, sysdate) ';
sqlstring:=sqlstring||' and detaut.CODICE_STATO_RICHIESTA = 1 ';
sqlstring:=sqlstring||' and detaut.CODICE_RICHIESTA = (Select Distinct CODICE_AUTORIZZAZIONE ';
sqlstring:=sqlstring||' From  Rinf_Pubblicati_Evo.VERSIONE_AUTORIZZAZIONI  Where CODICE_VERSIONE = '|| p_i_versione;
sqlstring:=sqlstring||' And FLAG_NEW = 1)  ) elenco_aut ';
--
sqlstring:=sqlstring||' Where anagut.ID_UTENTE (+) = elenco_aut.ID_UTENTE ';
sqlstring:=sqlstring||' And vers.CODICE_AUTORIZZAZIONE = ara.CODICE_RICHIESTA '; 
sqlstring:=sqlstring||' And vers.CODICE_AUTORIZZAZIONE = elenco_aut.CODICE_RICHIESTA ';
sqlstring:=sqlstring||' And vers.CODICE_VERSIONE = '|| p_i_versione;
sqlstring:=sqlstring||' And elenco_aut.FLAG_SEDE_CENTRALE = tipoSC.CODICE_TIPO_DEPOSITARIO (+)';
sqlstring:=sqlstring||' Order By 1, elenco_aut.CODICE_DTP, Decode (FLAG_SEDE_CENTRALE, 0, ''DTP'', SIGLA_TIPO_DEPOSITARIO) ';
--
--DBMS_OUTPUT.PUT_LINE(sqlstring);
--
OPEN p_cursor FOR sqlstring;
--
END GetSchemaAutorizzRI ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetScartiRIPubbl  (p_i_versione NUMBER ,p_cursor OUT empcur) IS
--REPORT 3.3.1

sqlstring VARCHAR2(32767);

BEGIN
sqlstring:=' SELECT v.CODICE_VERSIONE,';
sqlstring:=sqlstring || ' to_char(v.DATA_PUBBLICAZIONE,''DD/MM/YY HH:MI:SS'') DATA_PUBBLICAZIONE,  ';
sqlstring:=sqlstring || ' v.PROTOCOLLO,';
sqlstring:=sqlstring || ' va.CODICE_DTP,  ';
sqlstring:=sqlstring || ' D.TOTALE_OP,';
sqlstring:=sqlstring || ' d.totale_sol,';
sqlstring:=sqlstring || ' to_char(d.data_autorizzazione,''DD/MM/YY HH:MI:SS'') DATA_AUTORIZZAZIONE,  ';
sqlstring:=sqlstring || ' k.Numero_OP,';
sqlstring:=sqlstring || ' k.Numero_SOL,';
sqlstring:=sqlstring || ' k.CODICE_ACQUISIZIONE,';
sqlstring:=sqlstring || ' to_char(k.data_acquisizione,''DD/MM/YY HH:MI:SS'') DATA_ACQUISIZIONE,  ';
sqlstring:=sqlstring || ' Scarti_Acq_OP,';
sqlstring:=sqlstring || ' Scarti_Acq_SOL,';
sqlstring:=sqlstring || ' k.CODICE_CONTROLLO,';
sqlstring:=sqlstring || ' Scarti_Val_OP,';
sqlstring:=sqlstring || ' Scarti_Val_SOL';
sqlstring:=sqlstring || ' FROM RINF_PUBBLICATI_EVO.VERSIONE_RINF v,';
sqlstring:=sqlstring || ' RINF_AMMINISTRAZIONE_EVO.ANAG_RICHIESTE_AUTORIZZAZIONI a,';
sqlstring:=sqlstring || ' (SELECT DISTINCT CODICE_VERSIONE,';
sqlstring:=sqlstring || '                  CODICE_AUTORIZZAZIONE,';
sqlstring:=sqlstring || '                  CODICE_DTP,';
sqlstring:=sqlstring || '                  CODICE_CONTROLLO';
sqlstring:=sqlstring || '    FROM RINF_PUBBLICATI_EVO.VERSIONE_AUTORIZZAZIONI) va,';
sqlstring:=sqlstring || ' RINF_AMMINISTRAZIONE_EVO.DETTAGLIO_AUTORIZZAZIONI d,';
sqlstring:=sqlstring || ' (  SELECT a.codice_dtp,';
sqlstring:=sqlstring || '           a.codice_autorizzazione,';
sqlstring:=sqlstring || '           a.codice_controllo,';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (sede_tecnica, 1, 2), ''LO'', 1, 0))';
sqlstring:=sqlstring || '              Numero_OP,';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (sede_tecnica, 1, 2), ''TR'', 1, 0))';
sqlstring:=sqlstring || '              Numero_SOL,       ';
sqlstring:=sqlstring || '           H.DATA_ACQUISIZIONE,';
sqlstring:=sqlstring || '           h.codice_acquisizione';
sqlstring:=sqlstring || '      FROM RINF_PUBBLICATI_EVO.VERSIONE_AUTORIZZAZIONI a,';
sqlstring:=sqlstring || '           RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c,';
sqlstring:=sqlstring || '           RINF_LAVORAZIONE_EVO.ACQUISIZIONE_DATI h';
sqlstring:=sqlstring || '     WHERE     codice_versione = '||p_i_versione;
sqlstring:=sqlstring || '           AND h.codice_acquisizione = c.codice_acquisizione  ';
sqlstring:=sqlstring || '           AND c.codice_controllo = a.codice_controllo';
sqlstring:=sqlstring || '  GROUP BY a.codice_dtp,';
sqlstring:=sqlstring || '           a.codice_autorizzazione,';
sqlstring:=sqlstring || '           a.codice_controllo,';
sqlstring:=sqlstring || '           H.DATA_ACQUISIZIONE,';
sqlstring:=sqlstring || '           h.codice_acquisizione) k,';
sqlstring:=sqlstring || ' (  SELECT CODICE_ACQUISIZIONE,';
sqlstring:=sqlstring || '           CODICE_DTP,';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0))';
sqlstring:=sqlstring || '              Scarti_Acq_OP,';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0))';
sqlstring:=sqlstring || '              Scarti_Acq_SOL';
sqlstring:=sqlstring || '      FROM (SELECT DISTINCT';
sqlstring:=sqlstring || '                   CODICE_ACQUISIZIONE, CODICE_SOL_PO, CODICE_DTP';
sqlstring:=sqlstring || '              FROM RINF_LAVORAZIONE_EVO.SCARTI_ACQUISIZIONE)';
sqlstring:=sqlstring || '  GROUP BY CODICE_ACQUISIZIONE, CODICE_DTP) scart,';
sqlstring:=sqlstring || ' (  SELECT CODICE_CONTROLLO,';
sqlstring:=sqlstring || '           CODICE_DTP,';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0))';
sqlstring:=sqlstring || '              Scarti_Val_OP,';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0))';
sqlstring:=sqlstring || '              Scarti_Val_SOL';
sqlstring:=sqlstring || '      FROM RINF_LAVORAZIONE_EVO.OGGETTI_CONTROLLATI';
sqlstring:=sqlstring || '     WHERE CODICE_ESITO = 0';
sqlstring:=sqlstring || '  GROUP BY CODICE_CONTROLLO, CODICE_DTP) noval';
sqlstring:=sqlstring || ' WHERE     k.codice_dtp = va.codice_dtp';
sqlstring:=sqlstring || ' AND k.CODICE_AUTORIZZAZIONE = d.CODICE_RICHIESTA';
sqlstring:=sqlstring || ' AND v.CODICE_VERSIONE = va.CODICE_VERSIONE';
sqlstring:=sqlstring || ' AND A.CODICE_RICHIESTA = VA.CODICE_AUTORIZZAZIONE';
sqlstring:=sqlstring || ' AND vA.CODICE_AUTORIZZAZIONE = d.CODICE_RICHIESTA';
sqlstring:=sqlstring || ' AND va.CODICE_CONTROLLO = k.CODICE_CONTROLLO';
sqlstring:=sqlstring || ' AND d.CODICE_DTP = va.CODICE_DTP';
sqlstring:=sqlstring || ' AND k.CODICE_DTP = scart.CODICE_DTP(+)';
sqlstring:=sqlstring || ' AND k.codice_acquisizione = scart.codice_acquisizione(+)';
sqlstring:=sqlstring || ' AND va.CODICE_DTP = noval.CODICE_DTP(+)';
sqlstring:=sqlstring || ' AND va.CODICE_CONTROLLO = noval.CODICE_CONTROLLO(+)';
sqlstring:=sqlstring || ' AND v.CODICE_VERSIONE = '||p_i_versione;
sqlstring:=sqlstring || ' AND FLAG_SEDE_CENTRALE = 0';
sqlstring:=sqlstring || ' AND d.data_autorizzazione IS NOT NULL';
sqlstring:=sqlstring || ' ORDER BY va.codice_dtp ASC';

--DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetScartiRIPubbl ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetSintesiRIPubbl   (p_i_versione NUMBER ,p_cursor OUT empcur) IS
--REPORT 3.3.2

sqlstring VARCHAR2(32767);
sqlstring2 VARCHAR2(32767);

BEGIN
--23/06/2017 eliminata la funzione di formattazione di alcuni campi (to_char) per gestire correttamente i campi numerici nell'export xls
sqlstring:= ' SELECT '||p_i_versione||' "CODICE_VERSIONE", ';
sqlstring:=sqlstring || ' conta_sol.n_sol,   ';
sqlstring:=sqlstring || '        6 par_sol, ';
sqlstring:=sqlstring || '        0 perc_nya_sol,  ';
sqlstring:=sqlstring || '        conta_bin.n_binari n_binari_sol,  ';
sqlstring:=sqlstring || '        99 par_bin_sol_tot,  ';
sqlstring:=sqlstring || '         round( (nvl(nya_tot.nya_bin_sol,0) / (conta_bin.n_binari * 99)) * 100,3) ';
sqlstring:=sqlstring || '        perc_nya_tot, ';
sqlstring:=sqlstring || '        29 par_bin_sol_inf,  ';
sqlstring:=sqlstring || '      round(    (nvl(nya_inf.nya_bin_sol_inf,0) / (conta_bin.n_binari * 29)) * 100,3)';
sqlstring:=sqlstring || '           perc_nya_inf,                                                      ';
sqlstring:=sqlstring || '        20 par_bin_sol_ene,                                                   ';
sqlstring:=sqlstring || '       round(   (nvl(nya_ene.nya_bin_sol_ene,0) / (conta_bin.n_binari * 20)) * 100,3) ';
sqlstring:=sqlstring || '           perc_nya_ene,                                                      ';
sqlstring:=sqlstring || '        48 par_bin_sol_ccs,                                                   ';
sqlstring:=sqlstring || '      round(   (nvl(nya_ccs.nya_bin_sol_ccs,0) / (conta_bin.n_binari * 48)) * 100,3) ';
sqlstring:=sqlstring || '           perc_nya_ccs,                                                      ';
sqlstring:=sqlstring || '        conta_gall_sol.n_gall_sol,                                            ';
sqlstring:=sqlstring || '        11 par_gall_sol,                                                      ';
sqlstring:=sqlstring || '       round(   (nvl(nya_gall_sol.nya_gall_sol,0) / (conta_gall_sol.n_gall_sol * 11)) * 100,3) ';
sqlstring:=sqlstring || '           perc_nya_gall_sol,        ';
sqlstring:=sqlstring || '        conta_po.n_po,               ';
sqlstring:=sqlstring || '        6 par_po,                    ';
sqlstring:=sqlstring || '        0 perc_nya_po,               ';
sqlstring:=sqlstring || '        conta_bin_po.n_binari_po,    ';
sqlstring:=sqlstring || '        11 par_bin_po,               ';
sqlstring:=sqlstring || '        round(  (nvl(nya_bin_po.nya_bin_po,0) / (conta_bin_po.n_binari_po * 11)) * 100,3) ';
sqlstring:=sqlstring || '           perc_nya_bin_po,                                                        ';
sqlstring:=sqlstring || '        conta_plat.n_plat,                                                         ';
sqlstring:=sqlstring || '        7 par_plat,                                                                ';
sqlstring:=sqlstring || '      round(    (nvl(nya_plat.nya_plat,0) / (conta_plat.n_plat * 7)) * 100,3) ';
sqlstring:=sqlstring || '        perc_nya_plat,  ';
sqlstring:=sqlstring || '        conta_gall_po.n_gall_po,                                                   ';
sqlstring:=sqlstring || '        8 par_gall_po,                                                             ';
sqlstring:=sqlstring || '     round(     (nvl(nya_gall_po.nya_gall_po,0) / (conta_gall_po.n_gall_po * 8)) * 100,3) ';
sqlstring:=sqlstring || '           perc_nya_gall_po,                                                       ';
sqlstring:=sqlstring || '        conta_racc_po.n_racc_po,                                                   ';
sqlstring:=sqlstring || '        15 par_rac_po,                                                             ';
sqlstring:=sqlstring || '     round(    (nvl(nya_racc_po.nya_racc_po,0) / (conta_racc_po.n_racc_po * 15)) * 100,3) ';
sqlstring:=sqlstring || '          perc_nya_racc_po,                                                        ';
sqlstring:=sqlstring || '        conta_gall_racc.n_gall_racc,                                               ';
sqlstring:=sqlstring || '        8 par_gall_racc,                                                           ';
sqlstring:=sqlstring || '      round(     (nya_gall_racc.nya_gall_racc / (conta_gall_racc.n_gall_racc * 8)) * 100,3) ';     --quando ci saranno gall SD in questa istruzione dovr  essere aggiunta NVL
sqlstring:=sqlstring || '           perc_nya_gall_racc               ';
sqlstring:=sqlstring || '   FROM (SELECT SUM (conta_nya) nya_bin_sol ';
sqlstring:=sqlstring || '           FROM (SELECT   DECODE (SOL_TRACK_1_1_1_3_11_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_12_1_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_4_2_2_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_5_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_5_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_5_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_5_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_6_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_7_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_3_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_3_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_3_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_4_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_5_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_5_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_6_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_2_1_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_2_2_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_5_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_6_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_7_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_8_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_9_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_10_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_11_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_12_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_13_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_14_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_15_1_AP, ''NYA'', 1, 0)     ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_15_2_AP, ''NYA'', 1, 0)     ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_16_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_17_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_18_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_19_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_20_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_21_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_22_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_23_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_8_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_8_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_9_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_9_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_10_1_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_10_2_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_5_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_6_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_7_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_8_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_5_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_6_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_7_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_4_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_4_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_4_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_4_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_5_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_5_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_6_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_6_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_6_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_7_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_7_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_7_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_1_1_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_1_2_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_5_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_6_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_3_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_3_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_3_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_3_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_4_1_1_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_4_1_2_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_4_2_1_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (dic_inf.inf_nya, NULL, 1, dic_inf.inf_nya)      ';
sqlstring:=sqlstring || '                  + DECODE (dic_ene.ene_nya, NULL, 1, dic_ene.ene_nya)      ';
sqlstring:=sqlstring || '                  + DECODE (dic_ccs.ccs_nya, NULL, 1, dic_ccs.ccs_nya)      ';
sqlstring:=sqlstring || '                     conta_nya                                              ';
sqlstring:=sqlstring || '             FROM rinf_pubblicati_evo.binari_corsa_sol nya,                 ';
sqlstring:=sqlstring || '                  (  SELECT SOL_TRACK_1_1_1_0_0_1,                          ';
sqlstring:=sqlstring || '                            SUM (                                           ';
sqlstring:=sqlstring || '                               DECODE (SOL_TRACK_1_1_1_1_1_1O2_AP,          ';
sqlstring:=sqlstring || '                                       ''NYA'', 1,                          ';
sqlstring:=sqlstring || '                                       0))                                  ';
sqlstring:=sqlstring || '                               inf_nya                                      ';
sqlstring:=sqlstring || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF  ';
sqlstring:=sqlstring || '                      WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and substr(SOL_TRACK_1_1_1_0_0_1,1,6) in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || '                   GROUP BY SOL_TRACK_1_1_1_0_0_1) dic_inf,                    ';
sqlstring:=sqlstring || '                  (  SELECT SOL_TRACK_1_1_1_0_0_1,                             ';
sqlstring:=sqlstring || '                            SUM (                                              ';
sqlstring:=sqlstring || '                               DECODE (SOL_TRACK_1_1_1_2_1_1O2_AP,             ';
sqlstring:=sqlstring || '                                       ''NYA'', 1,                             ';
sqlstring:=sqlstring || '                                       0))                                     ';
sqlstring:=sqlstring || '                               ene_nya                                         ';
sqlstring:=sqlstring || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE  ';
sqlstring:=sqlstring || '                      WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and substr(SOL_TRACK_1_1_1_0_0_1,1,6) in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || '                   GROUP BY SOL_TRACK_1_1_1_0_0_1) dic_ene,                    ';
sqlstring:=sqlstring || '                  (  SELECT SOL_TRACK_1_1_1_0_0_1,                             ';
sqlstring:=sqlstring || '                            SUM (                                              ';
sqlstring:=sqlstring || '                               DECODE (SOL_TRACK_1_1_1_3_1_1_AP,               ';
sqlstring:=sqlstring || '                                       ''NYA'', 1,                             ';
sqlstring:=sqlstring || '                                       0))                                     ';
sqlstring:=sqlstring || '                               ccs_nya                                         ';
sqlstring:=sqlstring || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_CCS  ';
sqlstring:=sqlstring || '                      WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and substr(SOL_TRACK_1_1_1_0_0_1,1,6) in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || '                   GROUP BY SOL_TRACK_1_1_1_0_0_1) dic_ccs                     ';
sqlstring:=sqlstring || '            WHERE     codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || '                  AND nya.SOL_TRACK_1_1_1_0_0_1 =                              ';
sqlstring:=sqlstring || '                         dic_inf.SOL_TRACK_1_1_1_0_0_1(+)                      ';
sqlstring:=sqlstring || '                  AND nya.SOL_TRACK_1_1_1_0_0_1 =                              ';
sqlstring:=sqlstring || '                         dic_ene.SOL_TRACK_1_1_1_0_0_1(+)                      ';
sqlstring:=sqlstring || '                  AND nya.SOL_TRACK_1_1_1_0_0_1 =                              ';
sqlstring:=sqlstring || '                         dic_ccs.SOL_TRACK_1_1_1_0_0_1(+) ';

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and sede_tecnica in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || ' )) nya_tot,           ';
sqlstring:=sqlstring || '  (SELECT SUM (conta_nya) nya_bin_sol_INF                           ';
sqlstring:=sqlstring || '    FROM (SELECT   DECODE (SOL_TRACK_1_1_1_1_2_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_2_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_3_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_4_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_5_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_6_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_7_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_8_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_2_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_3_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_4_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_5_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_6_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_7_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_4_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_4_2_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_4_3_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_4_4_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_5_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_5_2_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_6_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_6_2_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_6_3_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_7_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_7_2_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_7_3_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (dic_inf.inf_nya, NULL, 1, dic_inf.inf_nya)            ';
sqlstring:=sqlstring || '                    conta_nya                                                    ';
sqlstring:=sqlstring || '            FROM rinf_pubblicati_evo.binari_corsa_sol nya,                       ';
sqlstring:=sqlstring || '                 (  SELECT SOL_TRACK_1_1_1_0_0_1,                                ';
sqlstring:=sqlstring || '                           SUM (                                                 ';
sqlstring:=sqlstring || '                              DECODE (SOL_TRACK_1_1_1_1_1_1O2_AP,                ';
sqlstring:=sqlstring || '                                      ''NYA'', 1,                                ';
sqlstring:=sqlstring || '                                      0))                                        ';
sqlstring:=sqlstring || '                              inf_nya                                            ';
sqlstring:=sqlstring || '                      FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF     ';
sqlstring:=sqlstring || '                     WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and substr(SOL_TRACK_1_1_1_0_0_1,1,6) in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || '                  GROUP BY SOL_TRACK_1_1_1_0_0_1) dic_inf                        ';
sqlstring:=sqlstring || '           WHERE     codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || '                 AND nya.SOL_TRACK_1_1_1_0_0_1 =                                 ';
sqlstring:=sqlstring || '                        dic_inf.SOL_TRACK_1_1_1_0_0_1(+) ';

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and sede_tecnica in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || ')) nya_inf,              ';
sqlstring:=sqlstring || ' (SELECT SUM (conta_nya) nya_bin_sol_ene     ';
sqlstring:=sqlstring || '    FROM (SELECT   DECODE (SOL_TRACK_1_1_1_2_4_2_2_AP, ''NYA'', 1, 0)  ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_5_1_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_5_2_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_5_3_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_1_1_AP, ''NYA'', 1, 0)  ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_1_2_AP, ''NYA'', 1, 0)  ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_2_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_3_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_4_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_5_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_6_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_3_1_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_3_2_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_3_3_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_3_4_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_4_1_1_AP, ''NYA'', 1, 0)  ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_4_1_2_AP, ''NYA'', 1, 0)  ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_4_2_1_AP, ''NYA'', 1, 0)  ';
sqlstring:=sqlstring || '                 + DECODE (dic_ene.ene_nya, NULL, 1, dic_ene.ene_nya)  ';
sqlstring:=sqlstring || '                    conta_nya                                          ';
sqlstring:=sqlstring || '            FROM rinf_pubblicati_evo.binari_corsa_sol nya,             ';
sqlstring:=sqlstring || '                 (  SELECT SOL_TRACK_1_1_1_0_0_1,                      ';
sqlstring:=sqlstring || '                           SUM (                                       ';
sqlstring:=sqlstring || '                              DECODE (SOL_TRACK_1_1_1_2_1_1O2_AP,      ';
sqlstring:=sqlstring || '                                      ''NYA'', 1,                      ';
sqlstring:=sqlstring || '                                      0))                              ';
sqlstring:=sqlstring || '                              ene_nya                                  ';
sqlstring:=sqlstring || '                      FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE  ';
sqlstring:=sqlstring || '                     WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and substr(SOL_TRACK_1_1_1_0_0_1,1,6) in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || '                  GROUP BY SOL_TRACK_1_1_1_0_0_1) dic_ene                     ';
sqlstring:=sqlstring || '           WHERE     codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || '                 AND nya.SOL_TRACK_1_1_1_0_0_1 =                              ';
sqlstring:=sqlstring || '                        dic_ene.SOL_TRACK_1_1_1_0_0_1(+) ';

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and sede_tecnica in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || ' )) nya_ene,           ';
sqlstring2:=sqlstring2 || ' (SELECT SUM (conta_nya) nya_bin_sol_ccs                                      ';
sqlstring2:=sqlstring2 || '           FROM (SELECT   DECODE (SOL_TRACK_1_1_1_3_11_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_12_1_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_2_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_3_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_4_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_5_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_6_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_7_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_3_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_3_2_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_3_3_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_4_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_5_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_5_2_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_6_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_2_1_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_2_2_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_3_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_4_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_5_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_6_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_7_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_8_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_9_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_10_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_11_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_12_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_13_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_14_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_15_1_AP, ''NYA'', 1, 0)';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_15_2_AP, ''NYA'', 1, 0)';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_16_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_17_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_18_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_19_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_20_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_21_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_22_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_23_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_8_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_8_2_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_9_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_9_2_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_10_1_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_10_2_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_2_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_3_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_4_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_5_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_6_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_7_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (dic_ccs.ccs_nya, NULL, 1, dic_ccs.ccs_nya) ';
sqlstring2:=sqlstring2 || '                     conta_nya                                         ';
sqlstring2:=sqlstring2 || '             FROM rinf_pubblicati_evo.binari_corsa_sol nya,            ';
sqlstring2:=sqlstring2 || '                  (  SELECT SOL_TRACK_1_1_1_0_0_1,                     ';
sqlstring2:=sqlstring2 || '                            SUM (                                      ';
sqlstring2:=sqlstring2 || '                               DECODE (SOL_TRACK_1_1_1_3_1_1_AP,       ';
sqlstring2:=sqlstring2 || '                                       ''NYA'', 1,                     ';
sqlstring2:=sqlstring2 || '                                       0))                             ';
sqlstring2:=sqlstring2 || '                               ccs_nya                                 ';
sqlstring2:=sqlstring2 || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_CCS   ';
sqlstring2:=sqlstring2 || '                      WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || '  and substr(SOL_TRACK_1_1_1_0_0_1,1,6) in ';
sqlstring2:=sqlstring2 || '  (select sede_tecnica ';
sqlstring2:=sqlstring2 || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring2:=sqlstring2 || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || '  and codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || ' ) ';
----

sqlstring2:=sqlstring2 || '                   GROUP BY SOL_TRACK_1_1_1_0_0_1) dic_ccs             ';
sqlstring2:=sqlstring2 || '            WHERE     codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                  AND nya.SOL_TRACK_1_1_1_0_0_1 =                      ';
sqlstring2:=sqlstring2 || '                         dic_ccs.SOL_TRACK_1_1_1_0_0_1(+) ';

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || '  and sede_tecnica in ';
sqlstring2:=sqlstring2 || ' (select sede_tecnica ';
sqlstring2:=sqlstring2 || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring2:=sqlstring2 || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || ' and codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || ') ';
----

sqlstring2:=sqlstring2 || ' )) nya_ccs,   ';
sqlstring2:=sqlstring2 || '  (SELECT SUM (conta_nya) nya_gall_sol                                 ';
sqlstring2:=sqlstring2 || '     FROM (SELECT   DECODE (SOL_TUNNEL_1_1_1_1_8_3_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TUNNEL_1_1_1_1_8_4_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TUNNEL_1_1_1_1_8_7_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TUNNEL_1_1_1_1_8_8_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TUNNEL_1_1_1_1_8_9_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TUNNEL_1_1_1_1_8_10_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TUNNEL_1_1_1_1_8_11_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                  + +DECODE (dic_gall.inf_nya,                         ';
sqlstring2:=sqlstring2 || '                             NULL, 1,                                  ';
sqlstring2:=sqlstring2 || '                             dic_gall.inf_nya)                         ';
sqlstring2:=sqlstring2 || '                     conta_nya                                         ';
sqlstring2:=sqlstring2 || '             FROM rinf_pubblicati_evo.gallerie_binari_sol nya,         ';
sqlstring2:=sqlstring2 || '                  (  SELECT SOL_TUNNEL_1_1_1_1_8_2,                    ';
sqlstring2:=sqlstring2 || '                            SUM (                                      ';
sqlstring2:=sqlstring2 || '                               DECODE (SOL_TUNNEL_1_1_1_1_8_5O6_AP,    ';
sqlstring2:=sqlstring2 || '                                       ''NYA'', 1,                     ';
sqlstring2:=sqlstring2 || '                                       0))                             ';
sqlstring2:=sqlstring2 || '                               inf_nya                                 ';
sqlstring2:=sqlstring2 || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_SOL ';
sqlstring2:=sqlstring2 || '                      WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || 'and SOL_TUNNEL_1_1_1_1_8_2 in ';
sqlstring2:=sqlstring2 || ' ( select distinct SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring2:=sqlstring2 || ' from RINF_PUBBLICATI_EVO.REL_GALLERIE_BINARI_SOL rel ';
sqlstring2:=sqlstring2 || ' where SOL_TRACK_1_1_1_0_0_1 in  ';
sqlstring2:=sqlstring2 || ' ( ';
sqlstring2:=sqlstring2 || ' select distinct rel.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring2:=sqlstring2 || ' FROM RINF_PUBBLICATI_EVO.SEZIONI_LINEA  sez, ';
sqlstring2:=sqlstring2 || ' RINF_PUBBLICATI_EVO.REL_GALLERIE_BINARI_SOL rel, ';
sqlstring2:=sqlstring2 || ' rinf_pubblicati_evo.binari_corsa_sol      bin ';
sqlstring2:=sqlstring2 || ' where rel.SOL_TRACK_1_1_1_0_0_1=bin.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring2:=sqlstring2 || ' and bin.sede_tecnica =SEZ.SEDE_TECNICA ';
sqlstring2:=sqlstring2 || ' and SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || ' and rel.codice_versione = '||p_i_versione;
sqlstring2:=sqlstring2 || ' and  rel.codice_versione = bin.codice_versione ';
sqlstring2:=sqlstring2 || ' and sez.codice_versione = bin.codice_versione)) ';
-----

sqlstring2:=sqlstring2 || '                   GROUP BY SOL_TUNNEL_1_1_1_1_8_2) dic_gall                   ';
sqlstring2:=sqlstring2 || '            WHERE     codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                  AND nya.SOL_TUNNEL_1_1_1_1_8_2 =                             ';
sqlstring2:=sqlstring2 || '                         dic_gall.SOL_TUNNEL_1_1_1_1_8_2(+) ';

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || '  and substr( nya.SOL_TUNNEL_1_1_1_1_8_2,1,6) in ';
sqlstring2:=sqlstring2 || '   (select sede_tecnica';
sqlstring2:=sqlstring2 || '   from RINF_PUBBLICATI_EVO.SEZIONI_LINEA';
sqlstring2:=sqlstring2 || '   where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || '   and codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || ' ) ';
-----

sqlstring2:=sqlstring2 || ')) nya_gall_sol,    ';
sqlstring2:=sqlstring2 || '  (SELECT SUM (conta_nya) nya_bin_po                                           ';
sqlstring2:=sqlstring2 || '     FROM (SELECT   DECODE (PO_TRACK_1_2_1_0_2_1_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TRACK_1_2_1_0_2_2_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TRACK_1_2_1_0_2_3_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TRACK_1_2_1_0_3_1_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TRACK_1_2_1_0_3_2_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TRACK_1_2_1_0_3_3_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TRACK_1_2_1_0_4_1_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (dic_bin_po.inf_nya,                     ';
sqlstring2:=sqlstring2 || '                            NULL, 1,                                ';
sqlstring2:=sqlstring2 || '                            dic_bin_po.inf_nya)                     ';
sqlstring2:=sqlstring2 || '                     conta_nya                                      ';
sqlstring2:=sqlstring2 || '             FROM rinf_pubblicati_evo.binari_corsa_po nya,          ';
sqlstring2:=sqlstring2 || '                  (  SELECT PO_TRACK_1_2_1_0_0_2,                   ';
sqlstring2:=sqlstring2 || '                            SUM (                                   ';
sqlstring2:=sqlstring2 || '                               DECODE (PO_TRACK_1_2_1_0_1_1O2_AP,   ';
sqlstring2:=sqlstring2 || '                                       ''NYA'', 1,                  ';
sqlstring2:=sqlstring2 || '                                       0))                          ';
sqlstring2:=sqlstring2 || '                               inf_nya                              ';
sqlstring2:=sqlstring2 || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_PO    ';
sqlstring2:=sqlstring2 || '                      WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || 'and (substr(PO_TRACK_1_2_1_0_0_2,1,2) =''LO'' ';
sqlstring2:=sqlstring2 || 'or ';
sqlstring2:=sqlstring2 || '(substr(PO_TRACK_1_2_1_0_0_2,1,6) in ';
sqlstring2:=sqlstring2 || ' (select sede_tecnica ';
sqlstring2:=sqlstring2 || ' from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring2:=sqlstring2 || ' where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || ' and codice_versione = '||p_i_versione;
sqlstring2:=sqlstring2 || ')))';
-----

sqlstring2:=sqlstring2 || '                   GROUP BY PO_TRACK_1_2_1_0_0_2) dic_bin_po                ';
sqlstring2:=sqlstring2 || '            WHERE     codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                  AND nya.PO_TRACK_1_2_1_0_0_2 =                            ';
sqlstring2:=sqlstring2 || '                         dic_bin_po.PO_TRACK_1_2_1_0_0_2(+) ';

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || 'and (substr(nya.PO_TRACK_1_2_1_0_0_2,1,2) =''LO'' ';
sqlstring2:=sqlstring2 || 'or ';
sqlstring2:=sqlstring2 || '(substr(nya.PO_TRACK_1_2_1_0_0_2,1,6) in ';
sqlstring2:=sqlstring2 || ' (select sede_tecnica ';
sqlstring2:=sqlstring2 || ' from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring2:=sqlstring2 || ' where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || ' and codice_versione = '||p_i_versione;
sqlstring2:=sqlstring2 || ')))';
-----

sqlstring2:=sqlstring2 || ')) nya_bin_po,   ';
sqlstring2:=sqlstring2 || '  (SELECT SUM (conta_nya) nya_plat                                          ';
sqlstring2:=sqlstring2 || '     FROM (SELECT   DECODE (PO_TR_PLATFORM_1_2_1_0_6_3_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_4_B1_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_4_B2_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_4_B3_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_5_B1_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_5_B2_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_5_B3_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLATFORM_1_2_1_0_6_6_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLATFORM_1_2_1_0_6_7_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_4_B4_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_5_B4_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                     conta_nya                                              ';
sqlstring2:=sqlstring2 || '             FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO nya             ';
sqlstring2:=sqlstring2 || '            WHERE codice_versione = '||p_i_versione||')) nya_plat,                           ';
sqlstring2:=sqlstring2 || '  (SELECT SUM (conta_nya) nya_gall_po                                       ';
sqlstring2:=sqlstring2 || '     FROM (SELECT   DECODE (PO_TR_TUNNEL_1_2_1_0_5_5_AP, ''NYA'', 1, 0)     ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_TUNNEL_1_2_1_0_5_6_AP, ''NYA'', 1, 0)     ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_TUNNEL_1_2_1_0_5_7_AP, ''NYA'', 1, 0)     ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_TUNNEL_1_2_1_0_5_8_AP, ''NYA'', 1, 0)     ';
sqlstring2:=sqlstring2 || '                  + DECODE (dic_gall.inf_nya, NULL, 1, dic_gall.inf_nya)    ';
sqlstring2:=sqlstring2 || '                     conta_nya                                              ';
sqlstring2:=sqlstring2 || '             FROM rinf_pubblicati_evo.GALLERIE_BINARI_PO nya,               ';
sqlstring2:=sqlstring2 || '                  (  SELECT PO_TR_TUNNEL_1_2_1_0_5_2,                       ';
sqlstring2:=sqlstring2 || '                            SUM (                                           ';
sqlstring2:=sqlstring2 || '                               DECODE (PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,       ';
sqlstring2:=sqlstring2 || '                                       ''NYA'', 1,                          ';
sqlstring2:=sqlstring2 || '                                       0))                                  ';
sqlstring2:=sqlstring2 || '                               inf_nya                                      ';
sqlstring2:=sqlstring2 || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_PO';
sqlstring2:=sqlstring2 || '                      WHERE codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                   GROUP BY PO_TR_TUNNEL_1_2_1_0_5_2) dic_gall               ';
sqlstring2:=sqlstring2 || '            WHERE     codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                  AND nya.PO_TR_TUNNEL_1_2_1_0_5_2 =                         ';
sqlstring2:=sqlstring2 || '                         dic_gall.PO_TR_TUNNEL_1_2_1_0_5_2(+))) nya_gall_po, ';
sqlstring2:=sqlstring2 || '  (SELECT SUM (conta_nya) nya_racc_po                                        ';
sqlstring2:=sqlstring2 || '     FROM (SELECT   DECODE (PO_SD_1_2_2_0_0_3_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_2_1_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_3_1_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_3_2_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_3_3_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_4_1_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_4_2_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_4_3_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_4_4_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_4_5_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_4_6_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (dic_racc_po.inf_nya,                             ';
sqlstring2:=sqlstring2 || '                            NULL, 1,                                         ';
sqlstring2:=sqlstring2 || '                            dic_racc_po.inf_nya)                             ';
sqlstring2:=sqlstring2 || '                     conta_nya                                               ';
sqlstring2:=sqlstring2 || '             FROM rinf_pubblicati_evo.BINARI_RACCORDO_PO nya,                ';
sqlstring2:=sqlstring2 || '                  (  SELECT PO_SD_1_2_2_0_0_2,                               ';
sqlstring2:=sqlstring2 || '                            SUM (                                            ';
sqlstring2:=sqlstring2 || '                               DECODE (PO_SD_1_2_2_0_1_1O2_AP,               ';
sqlstring2:=sqlstring2 || '                                       ''NYA'', 1,                           ';
sqlstring2:=sqlstring2 || '                                       0))                                   ';
sqlstring2:=sqlstring2 || '                               inf_nya                                       ';
sqlstring2:=sqlstring2 || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_RACCORDO_PO    ';
sqlstring2:=sqlstring2 || '                      WHERE codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                   GROUP BY PO_SD_1_2_2_0_0_2) dic_racc_po                   ';
sqlstring2:=sqlstring2 || '            WHERE     codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                  AND nya.PO_SD_1_2_2_0_0_2 =                                ';
sqlstring2:=sqlstring2 || '                         dic_racc_po.PO_SD_1_2_2_0_0_2(+))) nya_racc_po,     ';
sqlstring2:=sqlstring2 || '  (SELECT SUM (conta_nya) nya_gall_racc                                    ';
sqlstring2:=sqlstring2 || '  FROM (SELECT   DECODE (PO_SD_TUNNEL_1_2_2_0_5_5_AP, ''NYA'', 1, 0)       ';
sqlstring2:=sqlstring2 || '                     + DECODE (PO_SD_TUNNEL_1_2_2_0_5_6_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                     + DECODE (PO_SD_TUNNEL_1_2_2_0_5_7_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                     + DECODE (PO_SD_TUNNEL_1_2_2_0_5_8_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                     + +DECODE (dic_gall_racc.inf_nya,                     ';
sqlstring2:=sqlstring2 || '                                NULL, 1,                                   ';
sqlstring2:=sqlstring2 || '                                dic_gall_racc.inf_nya)                     ';
sqlstring2:=sqlstring2 || '                        conta_nya                                          ';
sqlstring2:=sqlstring2 || '                FROM rinf_pubblicati_evo.GALLERIE_RACCORDO_PO nya,         ';
sqlstring2:=sqlstring2 || '                     (  SELECT PO_SD_TUNNEL_1_2_2_0_5_2,                   ';
sqlstring2:=sqlstring2 || '                               SUM (                                       ';
sqlstring2:=sqlstring2 || '                                  DECODE (PO_SD_TUNNEL_1_2_2_0_5_3O4_AP,   ';
sqlstring2:=sqlstring2 || '                                          ''NYA'', 1,                      ';
sqlstring2:=sqlstring2 || '                                          0))                              ';
sqlstring2:=sqlstring2 || '                                  inf_nya                                  ';
sqlstring2:=sqlstring2 || '                          FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_SD_PO          ';
sqlstring2:=sqlstring2 || '                         WHERE codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                      GROUP BY PO_SD_TUNNEL_1_2_2_0_5_2) dic_gall_racc                   ';
sqlstring2:=sqlstring2 || '               WHERE     codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                     AND nya.PO_SD_TUNNEL_1_2_2_0_5_2 =                                  ';
sqlstring2:=sqlstring2 || '                            dic_gall_racc.PO_SD_TUNNEL_1_2_2_0_5_2(+))) nya_gall_racc,   ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_sol                            ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.sezioni_linea          ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione||') conta_sol,            ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_binari                         ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.binari_corsa_sol       ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione||'';

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || ' and sede_tecnica in ';
sqlstring2:=sqlstring2 || ' (select sede_tecnica';
sqlstring2:=sqlstring2 || ' from RINF_PUBBLICATI_EVO.SEZIONI_LINEA';
sqlstring2:=sqlstring2 || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || '  and codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || ' ) ';
----

sqlstring2:=sqlstring2 || ' ) conta_bin,            ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_gall_sol                       ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.GALLERIE_BINARI_SOL    ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || 'and SOL_TUNNEL_1_1_1_1_8_2 in ';
sqlstring2:=sqlstring2 || ' ( select distinct SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring2:=sqlstring2 || ' from RINF_PUBBLICATI_EVO.REL_GALLERIE_BINARI_SOL rel ';
sqlstring2:=sqlstring2 || ' where SOL_TRACK_1_1_1_0_0_1 in  ';
sqlstring2:=sqlstring2 || ' ( ';
sqlstring2:=sqlstring2 || ' select distinct rel.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring2:=sqlstring2 || ' FROM RINF_PUBBLICATI_EVO.SEZIONI_LINEA  sez, ';
sqlstring2:=sqlstring2 || ' RINF_PUBBLICATI_EVO.REL_GALLERIE_BINARI_SOL rel, ';
sqlstring2:=sqlstring2 || ' rinf_pubblicati_evo.binari_corsa_sol      bin ';
sqlstring2:=sqlstring2 || ' where rel.SOL_TRACK_1_1_1_0_0_1=bin.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring2:=sqlstring2 || ' and bin.sede_tecnica =SEZ.SEDE_TECNICA ';
sqlstring2:=sqlstring2 || ' and SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || ' and rel.codice_versione = '||p_i_versione;
sqlstring2:=sqlstring2 || ' and  rel.codice_versione = bin.codice_versione ';
sqlstring2:=sqlstring2 || ' and sez.codice_versione = bin.codice_versione)) ';
-----

sqlstring2:=sqlstring2 || ') conta_gall_sol,       ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_po                             ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.PUNTI_OPERATIVI        ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione||') conta_po,             ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_binari_po                      ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.binari_corsa_po        ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || 'and (substr(PO_TRACK_1_2_1_0_0_2,1,2) =''LO'' ';
sqlstring2:=sqlstring2 || 'or ';
sqlstring2:=sqlstring2 || '(substr(PO_TRACK_1_2_1_0_0_2,1,6) in ';
sqlstring2:=sqlstring2 || ' (select sede_tecnica ';
sqlstring2:=sqlstring2 || ' from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring2:=sqlstring2 || ' where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || ' and codice_versione = '||p_i_versione;
sqlstring2:=sqlstring2 || ')))';
-----

sqlstring2:=sqlstring2 || ') conta_bin_po,         ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_plat                           ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO  ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione||') conta_plat,           ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_gall_po                        ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.GALLERIE_BINARI_PO     ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione||') conta_gall_po,        ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_racc_po                        ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.BINARI_RACCORDO_PO     ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione||') conta_racc_po,        ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_gall_racc                      ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.GALLERIE_RACCORDO_PO   ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione||') conta_gall_racc       ';

OPEN p_cursor FOR sqlstring|| ' ' || sqlstring2;
DBMS_OUTPUT.PUT_LINE(sqlstring);
DBMS_OUTPUT.PUT_LINE(sqlstring2);


END GetSintesiRIPubbl ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetKPIScarti  (p_cursor OUT empcur) IS
--REPORT 3.3.3

sqlstring VARCHAR2(32767);

BEGIN

sqlstring:=' SELECT acq.CODICE_ACQUISIZIONE, ';
sqlstring:=sqlstring || ' to_char(acq.DATA_ACQUISIZIONE,''DD/MM/YY HH:MI:SS'') DATA_ACQUISIZIONE,  ';
sqlstring:=sqlstring || ' val.codice_controllo, ';
--sqlstring:=sqlstring || ' (scart.Scarti_Acq_OP / (tot_acq.n_op_acq + scart.Scarti_Acq_OP)) * 100 ';
sqlstring:=sqlstring || ' round((scart.Scarti_Acq_OP / (tot_acq.n_op_acq + scart.Scarti_Acq_OP)) * 100,3) ';
sqlstring:=sqlstring || '    KPI2_Acq_OP, ';
--sqlstring:=sqlstring || '   (scart.Scarti_Acq_SOL / (tot_acq.n_sol_acq + scart.Scarti_Acq_SOL)) * 100 ';
sqlstring:=sqlstring || '   round((scart.Scarti_Acq_SOL / (tot_acq.n_sol_acq + scart.Scarti_Acq_SOL)) * 100,3) ';
sqlstring:=sqlstring || '    KPI2_Acq_SOL, ';
sqlstring:=sqlstring || '    round( (  (scart.Scarti_Acq_OP + scart.Scarti_Acq_SOL) ';
sqlstring:=sqlstring || '    / (  tot_acq.n_op_acq ';
sqlstring:=sqlstring || '       + scart.Scarti_Acq_OP ';
sqlstring:=sqlstring || '       + tot_acq.n_sol_acq ';
sqlstring:=sqlstring || '       + scart.Scarti_Acq_SOL)) * 100,3) ';
sqlstring:=sqlstring || '    KPI2_Acq, ';
sqlstring:=sqlstring || '  round((noval.Scarti_Val_OP / tot_val.n_OP_val) * 100,3) ';
sqlstring:=sqlstring || ' KPI2_Val_OP, ';
sqlstring:=sqlstring || '  round((noval.Scarti_Val_SOL / tot_val.n_SOL_val) * 100,3) ';
sqlstring:=sqlstring || ' KPI2_Val_SOL, ';
sqlstring:=sqlstring || '    round((  (noval.Scarti_Val_OP + Scarti_Val_SOL) ';
sqlstring:=sqlstring || '    / (tot_val.n_OP_val + tot_val.n_SOL_val)) * 100,3) ';
sqlstring:=sqlstring || '    KPI2_Val ';
sqlstring:=sqlstring || '  FROM (  SELECT CODICE_ACQUISIZIONE, ';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0)) ';
sqlstring:=sqlstring || '              Scarti_Acq_OP, ';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0)) ';
sqlstring:=sqlstring || '              Scarti_Acq_SOL ';
sqlstring:=sqlstring || '      FROM (SELECT DISTINCT CODICE_ACQUISIZIONE, CODICE_SOL_PO   ';
sqlstring:=sqlstring || '              FROM RINF_LAVORAZIONE_EVO.SCARTI_ACQUISIZIONE) ';
sqlstring:=sqlstring || '  GROUP BY CODICE_ACQUISIZIONE) scart, ';
sqlstring:=sqlstring || ' (  SELECT CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0)) ';
sqlstring:=sqlstring || '              Scarti_Val_OP, ';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0)) ';
sqlstring:=sqlstring || '              Scarti_Val_SOL ';
sqlstring:=sqlstring || '      FROM RINF_LAVORAZIONE_EVO.OGGETTI_CONTROLLATI ';
sqlstring:=sqlstring || '     WHERE CODICE_ESITO = 0 ';
sqlstring:=sqlstring || '  GROUP BY CODICE_CONTROLLO) noval, ';
sqlstring:=sqlstring || ' (  SELECT CODICE_ACQUISIZIONE, ';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0)) ';
sqlstring:=sqlstring || '              n_OP_acq, ';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0)) ';
sqlstring:=sqlstring || '              n_SOL_acq ';
sqlstring:=sqlstring || '      FROM RINF_LAVORAZIONE_EVO.OGGETTI_ACQUISITI ';
sqlstring:=sqlstring || '  GROUP BY CODICE_ACQUISIZIONE) tot_acq,       ';
sqlstring:=sqlstring || ' (  SELECT CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0)) ';
sqlstring:=sqlstring || '              n_OP_val, ';
sqlstring:=sqlstring || '           SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0)) ';
sqlstring:=sqlstring || '              n_SOL_val ';
sqlstring:=sqlstring || '      FROM RINF_LAVORAZIONE_EVO.OGGETTI_CONTROLLATI ';
sqlstring:=sqlstring || '  GROUP BY CODICE_CONTROLLO) tot_val, ';
sqlstring:=sqlstring || ' RINF_LAVORAZIONE_EVO.ACQUISIZIONE_DATI acq, ';
sqlstring:=sqlstring || ' RINF_LAVORAZIONE_EVO.CONTROLLO_DATI val ';
sqlstring:=sqlstring || ' WHERE ACQ.CODICE_ACQUISIZIONE = val.CODICE_ACQUISIZIONE    ';
sqlstring:=sqlstring || ' AND ACQ.CODICE_ACQUISIZIONE = tot_acq.CODICE_ACQUISIZIONE ';
sqlstring:=sqlstring || ' AND ACQ.CODICE_ACQUISIZIONE = scart.CODICE_ACQUISIZIONE(+) ';
sqlstring:=sqlstring || ' AND val.CODICE_CONTROLLO = noval.CODICE_CONTROLLO(+) ';
sqlstring:=sqlstring || ' AND val.CODICE_CONTROLLO = tot_val.CODICE_CONTROLLO ';
sqlstring:=sqlstring || ' ORDER BY 1 ';

DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetKPIScarti ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetKPIRegistroPubbl  (p_i_versione NUMBER ,p_cursor OUT empcur) IS
--REPORT 3.3.4

sqlstring VARCHAR2(32767);
sqlstring2 VARCHAR2(32767);

BEGIN

sqlstring:=' SELECT   round( (  (  NVL (nya_tot.nya_bin_sol, 0) ';
sqlstring:=sqlstring || '              + NVL (nya_inf.nya_bin_sol_inf, 0) ';
sqlstring:=sqlstring || '              + NVL (nya_ene.nya_bin_sol_ene, 0) ';
sqlstring:=sqlstring || '              + NVL (nya_ccs.nya_bin_sol_ccs, 0) ';
sqlstring:=sqlstring || '              + NVL (nya_gall_sol.nya_gall_sol, 0) ';
sqlstring:=sqlstring || '              + NVL (nya_bin_po.nya_bin_po, 0) ';
sqlstring:=sqlstring || '              + NVL (nya_plat.nya_plat, 0) ';
sqlstring:=sqlstring || '              + NVL (nya_gall_po.nya_gall_po, 0) ';
sqlstring:=sqlstring || '              + NVL (nya_racc_po.nya_racc_po, 0) ';
sqlstring:=sqlstring || '              + NVL (nya_gall_racc.nya_gall_racc, 0)) ';
sqlstring:=sqlstring || '           / (  (conta_sol.n_sol * 6) ';
sqlstring:=sqlstring || '              + (conta_bin.n_binari * 99) ';
sqlstring:=sqlstring || '              + (conta_bin.n_binari * 29) ';
sqlstring:=sqlstring || '              + (conta_bin.n_binari * 20) ';
sqlstring:=sqlstring || '              + (conta_bin.n_binari * 48) ';
sqlstring:=sqlstring || '              + (conta_gall_sol.n_gall_sol * 11) ';
sqlstring:=sqlstring || '              + (conta_po.n_po * 6) ';
sqlstring:=sqlstring || '              + (conta_bin_po.n_binari_po * 11) ';
sqlstring:=sqlstring || '              + (conta_plat.n_plat * 7) ';
sqlstring:=sqlstring || '              + (conta_gall_po.n_gall_po * 9) ';
sqlstring:=sqlstring || '              + (conta_racc_po.n_racc_po * 15) ';
sqlstring:=sqlstring || '              + (conta_gall_racc.n_gall_racc * 8))) ';
sqlstring:=sqlstring || '        * 100,3) ';
sqlstring:=sqlstring || '           KP1, ';
sqlstring:=sqlstring || '        round(   (NVL (dic_inf_bin_sol.n_dic_inf_bin_sol, 0) / conta_bin.n_binari) ';
sqlstring:=sqlstring || '        * 100,3) ';
sqlstring:=sqlstring || '           KPI4_bin_sol, ';
sqlstring:=sqlstring || '       round(    (  NVL (dic_inf_gall_sol.n_dic_inf_gall_sol, 0) ';
sqlstring:=sqlstring || '           / conta_gall_sol.n_gall_sol) ';
sqlstring:=sqlstring || '        * 100,3) ';
sqlstring:=sqlstring || '           KPI4_gall_sol, ';
sqlstring:=sqlstring || '       round(    (NVL (dic_inf_bin_po.n_dic_inf_bin_po, 0) / conta_bin_po.n_binari_po) ';
sqlstring:=sqlstring || '        * 100,3) ';
sqlstring:=sqlstring || '           KPI4_bin_po, ';
sqlstring:=sqlstring || '        round(   (  NVL (dic_inf_gall_po.n_dic_inf_gall_po, 0) ';
sqlstring:=sqlstring || '           / conta_gall_po.n_gall_po) ';
sqlstring:=sqlstring || '        * 100,3) ';
sqlstring:=sqlstring || '           KPI4_gall_po, ';
sqlstring:=sqlstring || '        round(   (  NVL (dic_inf_racc_po.n_dic_inf_racc_po, 0) ';
sqlstring:=sqlstring || '           / conta_racc_po.n_racc_po) ';
sqlstring:=sqlstring || '        * 100,3) ';
sqlstring:=sqlstring || '           KPI4_racc_po, ';
sqlstring:=sqlstring || '       round(   (  NVL (dic_inf_gall_racc.n_dic_inf_gall_racc, 0) ';
sqlstring:=sqlstring || '           / DECODE (conta_gall_racc.n_gall_racc, ';
sqlstring:=sqlstring || '                     0, NULL, ';
sqlstring:=sqlstring || '                     conta_gall_racc.n_gall_racc)) ';
sqlstring:=sqlstring || '        * 100,3) ';
sqlstring:=sqlstring || '           KPI4_gall_racc, ';
sqlstring:=sqlstring || '        round(   (  NVL (dic_inf_bin_sol.n_dic_inf_bin_sol, 0) ';
sqlstring:=sqlstring || '           + NVL (dic_inf_gall_sol.n_dic_inf_gall_sol, 0) ';
sqlstring:=sqlstring || '           + NVL (dic_inf_bin_po.n_dic_inf_bin_po, 0) ';
sqlstring:=sqlstring || '           + NVL (dic_inf_gall_po.n_dic_inf_gall_po, 0) ';
sqlstring:=sqlstring || '           + NVL (dic_inf_racc_po.n_dic_inf_racc_po, 0) ';
sqlstring:=sqlstring || '           + NVL (dic_inf_gall_racc.n_dic_inf_gall_racc, 0)) ';
sqlstring:=sqlstring || '        / (  conta_bin.n_binari ';
sqlstring:=sqlstring || '           + conta_gall_sol.n_gall_sol ';
sqlstring:=sqlstring || '           + conta_bin_po.n_binari_po ';
sqlstring:=sqlstring || '           + conta_gall_po.n_gall_po ';
sqlstring:=sqlstring || '           + conta_racc_po.n_racc_po ';
sqlstring:=sqlstring || '           + conta_gall_racc.n_gall_racc) ';
sqlstring:=sqlstring || '        * 100,3) ';
sqlstring:=sqlstring || '           KPI4, ';
sqlstring:=sqlstring || '       round(    (NVL (dic_ene_bin_sol.n_dic_ene_bin_sol, 0) / conta_bin.n_binari) ';
sqlstring:=sqlstring || '        * 100,3) ';
sqlstring:=sqlstring || '           KPI5, ';
sqlstring:=sqlstring || '        round(   (NVL (dic_ccs_bin_sol.n_dic_ccs_bin_sol, 0) / conta_bin.n_binari) ';
sqlstring:=sqlstring || '        * 100,3) ';
sqlstring:=sqlstring || '           KPI6 ';
sqlstring:=sqlstring || '   FROM (SELECT SUM (conta_nya) nya_bin_sol ';
sqlstring:=sqlstring || '           FROM (SELECT   DECODE (SOL_TRACK_1_1_1_3_11_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_12_1_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_4_2_2_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_5_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_5_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_5_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_5_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_6_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_2_7_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_3_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_3_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_3_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_4_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_5_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_5_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_6_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_2_1_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_2_2_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_5_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_6_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_7_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_8_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_9_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_10_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_11_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_12_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_13_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_14_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_15_1_AP, ''NYA'', 1, 0)     ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_15_2_AP, ''NYA'', 1, 0)     ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_16_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_17_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_18_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_19_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_20_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_21_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_22_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_7_23_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_8_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_8_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_9_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_9_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_10_1_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_3_10_2_AP, ''NYA'', 1, 0)       ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_5_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_6_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_7_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_2_8_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_5_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_6_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_3_7_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_4_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_4_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_4_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_4_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_5_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_5_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_6_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_6_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_6_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_7_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_7_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_1_7_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_1_1_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_1_2_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_5_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_2_6_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_3_1_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_3_2_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_3_3_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_3_4_AP, ''NYA'', 1, 0)        ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_4_1_1_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_4_1_2_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (SOL_TRACK_1_1_1_2_4_2_1_AP, ''NYA'', 1, 0)      ';
sqlstring:=sqlstring || '                  + DECODE (dic_inf.inf_nya, NULL, 1, dic_inf.inf_nya)      ';
sqlstring:=sqlstring || '                  + DECODE (dic_ene.ene_nya, NULL, 1, dic_ene.ene_nya)      ';
sqlstring:=sqlstring || '                  + DECODE (dic_ccs.ccs_nya, NULL, 1, dic_ccs.ccs_nya)      ';
sqlstring:=sqlstring || '                     conta_nya                                              ';
sqlstring:=sqlstring || '             FROM rinf_pubblicati_evo.binari_corsa_sol nya,                 ';
sqlstring:=sqlstring || '                  (  SELECT SOL_TRACK_1_1_1_0_0_1,                          ';
sqlstring:=sqlstring || '                            SUM (                                           ';
sqlstring:=sqlstring || '                               DECODE (SOL_TRACK_1_1_1_1_1_1O2_AP,          ';
sqlstring:=sqlstring || '                                       ''NYA'', 1,                          ';
sqlstring:=sqlstring || '                                       0))                                  ';
sqlstring:=sqlstring || '                               inf_nya                                      ';
sqlstring:=sqlstring || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF  ';
sqlstring:=sqlstring || '                      WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and substr(SOL_TRACK_1_1_1_0_0_1,1,6) in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || '                   GROUP BY SOL_TRACK_1_1_1_0_0_1) dic_inf,                    ';
sqlstring:=sqlstring || '                  (  SELECT SOL_TRACK_1_1_1_0_0_1,                             ';
sqlstring:=sqlstring || '                            SUM (                                              ';
sqlstring:=sqlstring || '                               DECODE (SOL_TRACK_1_1_1_2_1_1O2_AP,             ';
sqlstring:=sqlstring || '                                       ''NYA'', 1,                             ';
sqlstring:=sqlstring || '                                       0))                                     ';
sqlstring:=sqlstring || '                               ene_nya                                         ';
sqlstring:=sqlstring || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE  ';
sqlstring:=sqlstring || '                      WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and substr(SOL_TRACK_1_1_1_0_0_1,1,6) in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || '                   GROUP BY SOL_TRACK_1_1_1_0_0_1) dic_ene,                    ';
sqlstring:=sqlstring || '                  (  SELECT SOL_TRACK_1_1_1_0_0_1,                             ';
sqlstring:=sqlstring || '                            SUM (                                              ';
sqlstring:=sqlstring || '                               DECODE (SOL_TRACK_1_1_1_3_1_1_AP,               ';
sqlstring:=sqlstring || '                                       ''NYA'', 1,                             ';
sqlstring:=sqlstring || '                                       0))                                     ';
sqlstring:=sqlstring || '                               ccs_nya                                         ';
sqlstring:=sqlstring || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_CCS  ';
sqlstring:=sqlstring || '                      WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and substr(SOL_TRACK_1_1_1_0_0_1,1,6) in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || '                   GROUP BY SOL_TRACK_1_1_1_0_0_1) dic_ccs                     ';
sqlstring:=sqlstring || '            WHERE     codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || '                  AND nya.SOL_TRACK_1_1_1_0_0_1 =                              ';
sqlstring:=sqlstring || '                         dic_inf.SOL_TRACK_1_1_1_0_0_1(+)                      ';
sqlstring:=sqlstring || '                  AND nya.SOL_TRACK_1_1_1_0_0_1 =                              ';
sqlstring:=sqlstring || '                         dic_ene.SOL_TRACK_1_1_1_0_0_1(+)                      ';
sqlstring:=sqlstring || '                  AND nya.SOL_TRACK_1_1_1_0_0_1 =                              ';
sqlstring:=sqlstring || '                         dic_ccs.SOL_TRACK_1_1_1_0_0_1(+) ';

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and sede_tecnica in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || ' )) nya_tot,           ';
sqlstring:=sqlstring || '  (SELECT SUM (conta_nya) nya_bin_sol_INF                           ';
sqlstring:=sqlstring || '    FROM (SELECT   DECODE (SOL_TRACK_1_1_1_1_2_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_2_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_3_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_4_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_5_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_6_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_7_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_2_8_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_2_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_3_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_4_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_5_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_6_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_3_7_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_4_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_4_2_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_4_3_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_4_4_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_5_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_5_2_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_6_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_6_2_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_6_3_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_7_1_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_7_2_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_1_7_3_AP, ''NYA'', 1, 0) ';
sqlstring:=sqlstring || '                 + DECODE (dic_inf.inf_nya, NULL, 1, dic_inf.inf_nya)            ';
sqlstring:=sqlstring || '                    conta_nya                                                    ';
sqlstring:=sqlstring || '            FROM rinf_pubblicati_evo.binari_corsa_sol nya,                       ';
sqlstring:=sqlstring || '                 (  SELECT SOL_TRACK_1_1_1_0_0_1,                                ';
sqlstring:=sqlstring || '                           SUM (                                                 ';
sqlstring:=sqlstring || '                              DECODE (SOL_TRACK_1_1_1_1_1_1O2_AP,                ';
sqlstring:=sqlstring || '                                      ''NYA'', 1,                                ';
sqlstring:=sqlstring || '                                      0))                                        ';
sqlstring:=sqlstring || '                              inf_nya                                            ';
sqlstring:=sqlstring || '                      FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF     ';
sqlstring:=sqlstring || '                     WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and substr(SOL_TRACK_1_1_1_0_0_1,1,6) in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || '                  GROUP BY SOL_TRACK_1_1_1_0_0_1) dic_inf                        ';
sqlstring:=sqlstring || '           WHERE     codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || '                 AND nya.SOL_TRACK_1_1_1_0_0_1 =                                 ';
sqlstring:=sqlstring || '                        dic_inf.SOL_TRACK_1_1_1_0_0_1(+) ';

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and sede_tecnica in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || ')) nya_inf,              ';
sqlstring:=sqlstring || ' (SELECT SUM (conta_nya) nya_bin_sol_ene     ';
sqlstring:=sqlstring || '    FROM (SELECT   DECODE (SOL_TRACK_1_1_1_2_4_2_2_AP, ''NYA'', 1, 0)  ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_5_1_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_5_2_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_5_3_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_1_1_AP, ''NYA'', 1, 0)  ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_1_2_AP, ''NYA'', 1, 0)  ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_2_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_3_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_4_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_5_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_2_6_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_3_1_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_3_2_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_3_3_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_3_4_AP, ''NYA'', 1, 0)    ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_4_1_1_AP, ''NYA'', 1, 0)  ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_4_1_2_AP, ''NYA'', 1, 0)  ';
sqlstring:=sqlstring || '                 + DECODE (SOL_TRACK_1_1_1_2_4_2_1_AP, ''NYA'', 1, 0)  ';
sqlstring:=sqlstring || '                 + DECODE (dic_ene.ene_nya, NULL, 1, dic_ene.ene_nya)  ';
sqlstring:=sqlstring || '                    conta_nya                                          ';
sqlstring:=sqlstring || '            FROM rinf_pubblicati_evo.binari_corsa_sol nya,             ';
sqlstring:=sqlstring || '                 (  SELECT SOL_TRACK_1_1_1_0_0_1,                      ';
sqlstring:=sqlstring || '                           SUM (                                       ';
sqlstring:=sqlstring || '                              DECODE (SOL_TRACK_1_1_1_2_1_1O2_AP,      ';
sqlstring:=sqlstring || '                                      ''NYA'', 1,                      ';
sqlstring:=sqlstring || '                                      0))                              ';
sqlstring:=sqlstring || '                              ene_nya                                  ';
sqlstring:=sqlstring || '                      FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE  ';
sqlstring:=sqlstring || '                     WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and substr(SOL_TRACK_1_1_1_0_0_1,1,6) in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || '                  GROUP BY SOL_TRACK_1_1_1_0_0_1) dic_ene                     ';
sqlstring:=sqlstring || '           WHERE     codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || '                 AND nya.SOL_TRACK_1_1_1_0_0_1 =                              ';
sqlstring:=sqlstring || '                        dic_ene.SOL_TRACK_1_1_1_0_0_1(+) ';

-----introdotto per togliere gli NYA dei LINK
sqlstring:=sqlstring || '  and sede_tecnica in ';
sqlstring:=sqlstring || '  (select sede_tecnica ';
sqlstring:=sqlstring || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring:=sqlstring || '  and codice_versione = ' ||p_i_versione;
sqlstring:=sqlstring || ' ) ';
----

sqlstring:=sqlstring || ' )) nya_ene,           ';
sqlstring2:=sqlstring2 || ' (SELECT SUM (conta_nya) nya_bin_sol_ccs                                      ';
sqlstring2:=sqlstring2 || '           FROM (SELECT   DECODE (SOL_TRACK_1_1_1_3_11_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_12_1_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_2_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_3_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_4_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_5_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_6_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_2_7_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_3_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_3_2_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_3_3_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_4_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_5_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_5_2_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_6_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_2_1_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_2_2_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_3_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_4_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_5_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_6_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_7_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_8_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_9_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_10_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_11_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_12_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_13_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_14_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_15_1_AP, ''NYA'', 1, 0)';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_15_2_AP, ''NYA'', 1, 0)';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_16_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_17_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_18_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_19_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_20_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_21_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_22_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_7_23_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_8_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_8_2_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_9_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_9_2_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_10_1_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_3_10_2_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_1_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_2_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_3_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_4_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_5_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_6_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TRACK_1_1_1_1_3_7_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (dic_ccs.ccs_nya, NULL, 1, dic_ccs.ccs_nya) ';
sqlstring2:=sqlstring2 || '                     conta_nya                                         ';
sqlstring2:=sqlstring2 || '             FROM rinf_pubblicati_evo.binari_corsa_sol nya,            ';
sqlstring2:=sqlstring2 || '                  (  SELECT SOL_TRACK_1_1_1_0_0_1,                     ';
sqlstring2:=sqlstring2 || '                            SUM (                                      ';
sqlstring2:=sqlstring2 || '                               DECODE (SOL_TRACK_1_1_1_3_1_1_AP,       ';
sqlstring2:=sqlstring2 || '                                       ''NYA'', 1,                     ';
sqlstring2:=sqlstring2 || '                                       0))                             ';
sqlstring2:=sqlstring2 || '                               ccs_nya                                 ';
sqlstring2:=sqlstring2 || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_CCS   ';
sqlstring2:=sqlstring2 || '                      WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || '  and substr(SOL_TRACK_1_1_1_0_0_1,1,6) in ';
sqlstring2:=sqlstring2 || '  (select sede_tecnica ';
sqlstring2:=sqlstring2 || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring2:=sqlstring2 || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || '  and codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || ' ) ';
----

sqlstring2:=sqlstring2 || '                   GROUP BY SOL_TRACK_1_1_1_0_0_1) dic_ccs             ';
sqlstring2:=sqlstring2 || '            WHERE     codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                  AND nya.SOL_TRACK_1_1_1_0_0_1 =                      ';
sqlstring2:=sqlstring2 || '                         dic_ccs.SOL_TRACK_1_1_1_0_0_1(+) ';

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || '  and sede_tecnica in ';
sqlstring2:=sqlstring2 || ' (select sede_tecnica ';
sqlstring2:=sqlstring2 || '  from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring2:=sqlstring2 || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || ' and codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || ') ';
----

sqlstring2:=sqlstring2 || ' )) nya_ccs,   ';
sqlstring2:=sqlstring2 || '  (SELECT SUM (conta_nya) nya_gall_sol                                 ';
sqlstring2:=sqlstring2 || '     FROM (SELECT   DECODE (SOL_TUNNEL_1_1_1_1_8_3_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TUNNEL_1_1_1_1_8_4_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TUNNEL_1_1_1_1_8_7_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TUNNEL_1_1_1_1_8_8_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TUNNEL_1_1_1_1_8_9_AP, ''NYA'', 1, 0)  ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TUNNEL_1_1_1_1_8_10_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                  + DECODE (SOL_TUNNEL_1_1_1_1_8_11_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                  + +DECODE (dic_gall.inf_nya,                         ';
sqlstring2:=sqlstring2 || '                             NULL, 1,                                  ';
sqlstring2:=sqlstring2 || '                             dic_gall.inf_nya)                         ';
sqlstring2:=sqlstring2 || '                     conta_nya                                         ';
sqlstring2:=sqlstring2 || '             FROM rinf_pubblicati_evo.gallerie_binari_sol nya,         ';
sqlstring2:=sqlstring2 || '                  (  SELECT SOL_TUNNEL_1_1_1_1_8_2,                    ';
sqlstring2:=sqlstring2 || '                            SUM (                                      ';
sqlstring2:=sqlstring2 || '                               DECODE (SOL_TUNNEL_1_1_1_1_8_5O6_AP,    ';
sqlstring2:=sqlstring2 || '                                       ''NYA'', 1,                     ';
sqlstring2:=sqlstring2 || '                                       0))                             ';
sqlstring2:=sqlstring2 || '                               inf_nya                                 ';
sqlstring2:=sqlstring2 || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_SOL ';
sqlstring2:=sqlstring2 || '                      WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || 'and SOL_TUNNEL_1_1_1_1_8_2 in ';
sqlstring2:=sqlstring2 || ' ( select distinct SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring2:=sqlstring2 || ' from RINF_PUBBLICATI_EVO.REL_GALLERIE_BINARI_SOL rel ';
sqlstring2:=sqlstring2 || ' where SOL_TRACK_1_1_1_0_0_1 in  ';
sqlstring2:=sqlstring2 || ' ( ';
sqlstring2:=sqlstring2 || ' select distinct rel.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring2:=sqlstring2 || ' FROM RINF_PUBBLICATI_EVO.SEZIONI_LINEA  sez, ';
sqlstring2:=sqlstring2 || ' RINF_PUBBLICATI_EVO.REL_GALLERIE_BINARI_SOL rel, ';
sqlstring2:=sqlstring2 || ' rinf_pubblicati_evo.binari_corsa_sol      bin ';
sqlstring2:=sqlstring2 || ' where rel.SOL_TRACK_1_1_1_0_0_1=bin.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring2:=sqlstring2 || ' and bin.sede_tecnica =SEZ.SEDE_TECNICA ';
sqlstring2:=sqlstring2 || ' and SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || ' and rel.codice_versione = '||p_i_versione;
sqlstring2:=sqlstring2 || ' and  rel.codice_versione = bin.codice_versione ';
sqlstring2:=sqlstring2 || ' and sez.codice_versione = bin.codice_versione)) ';
-----

sqlstring2:=sqlstring2 || '                   GROUP BY SOL_TUNNEL_1_1_1_1_8_2) dic_gall                   ';
sqlstring2:=sqlstring2 || '            WHERE     codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                  AND nya.SOL_TUNNEL_1_1_1_1_8_2 =                             ';
sqlstring2:=sqlstring2 || '                         dic_gall.SOL_TUNNEL_1_1_1_1_8_2(+) ';

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || '  and substr( nya.SOL_TUNNEL_1_1_1_1_8_2,1,6) in ';
sqlstring2:=sqlstring2 || '   (select sede_tecnica';
sqlstring2:=sqlstring2 || '   from RINF_PUBBLICATI_EVO.SEZIONI_LINEA';
sqlstring2:=sqlstring2 || '   where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || '   and codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || ' ) ';
-----

sqlstring2:=sqlstring2 || ')) nya_gall_sol,    ';
sqlstring2:=sqlstring2 || '  (SELECT SUM (conta_nya) nya_bin_po                                           ';
sqlstring2:=sqlstring2 || '     FROM (SELECT   DECODE (PO_TRACK_1_2_1_0_2_1_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TRACK_1_2_1_0_2_2_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TRACK_1_2_1_0_2_3_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TRACK_1_2_1_0_3_1_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TRACK_1_2_1_0_3_2_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TRACK_1_2_1_0_3_3_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TRACK_1_2_1_0_4_1_AP, ''NYA'', 1, 0)            ';
sqlstring2:=sqlstring2 || '                  + DECODE (dic_bin_po.inf_nya,                     ';
sqlstring2:=sqlstring2 || '                            NULL, 1,                                ';
sqlstring2:=sqlstring2 || '                            dic_bin_po.inf_nya)                     ';
sqlstring2:=sqlstring2 || '                     conta_nya                                      ';
sqlstring2:=sqlstring2 || '             FROM rinf_pubblicati_evo.binari_corsa_po nya,          ';
sqlstring2:=sqlstring2 || '                  (  SELECT PO_TRACK_1_2_1_0_0_2,                   ';
sqlstring2:=sqlstring2 || '                            SUM (                                   ';
sqlstring2:=sqlstring2 || '                               DECODE (PO_TRACK_1_2_1_0_1_1O2_AP,   ';
sqlstring2:=sqlstring2 || '                                       ''NYA'', 1,                  ';
sqlstring2:=sqlstring2 || '                                       0))                          ';
sqlstring2:=sqlstring2 || '                               inf_nya                              ';
sqlstring2:=sqlstring2 || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_PO    ';
sqlstring2:=sqlstring2 || '                      WHERE codice_versione = ' ||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || 'and (substr(PO_TRACK_1_2_1_0_0_2,1,2) =''LO'' ';
sqlstring2:=sqlstring2 || 'or ';
sqlstring2:=sqlstring2 || '(substr(PO_TRACK_1_2_1_0_0_2,1,6) in ';
sqlstring2:=sqlstring2 || ' (select sede_tecnica ';
sqlstring2:=sqlstring2 || ' from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring2:=sqlstring2 || ' where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || ' and codice_versione = '||p_i_versione;
sqlstring2:=sqlstring2 || ')))';
-----

sqlstring2:=sqlstring2 || '                   GROUP BY PO_TRACK_1_2_1_0_0_2) dic_bin_po                ';
sqlstring2:=sqlstring2 || '            WHERE     codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                  AND nya.PO_TRACK_1_2_1_0_0_2 =                            ';
sqlstring2:=sqlstring2 || '                         dic_bin_po.PO_TRACK_1_2_1_0_0_2(+) ';

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || 'and (substr(nya.PO_TRACK_1_2_1_0_0_2,1,2) =''LO'' ';
sqlstring2:=sqlstring2 || 'or ';
sqlstring2:=sqlstring2 || '(substr(nya.PO_TRACK_1_2_1_0_0_2,1,6) in ';
sqlstring2:=sqlstring2 || ' (select sede_tecnica ';
sqlstring2:=sqlstring2 || ' from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring2:=sqlstring2 || ' where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || ' and codice_versione = '||p_i_versione;
sqlstring2:=sqlstring2 || ')))';
-----

sqlstring2:=sqlstring2 || ')) nya_bin_po,   ';
sqlstring2:=sqlstring2 || '  (SELECT SUM (conta_nya) nya_plat                                          ';
sqlstring2:=sqlstring2 || '     FROM (SELECT   DECODE (PO_TR_PLATFORM_1_2_1_0_6_3_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_4_B1_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_4_B2_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_4_B3_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_5_B1_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_5_B2_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_5_B3_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLATFORM_1_2_1_0_6_6_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLATFORM_1_2_1_0_6_7_AP, ''NYA'', 1, 0)   ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_4_B4_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_PLAT_1_2_1_0_6_5_B4_AP, ''NYA'', 1, 0)    ';
sqlstring2:=sqlstring2 || '                     conta_nya                                              ';
sqlstring2:=sqlstring2 || '             FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO nya             ';
sqlstring2:=sqlstring2 || '            WHERE codice_versione = '||p_i_versione||')) nya_plat,                           ';
sqlstring2:=sqlstring2 || '  (SELECT SUM (conta_nya) nya_gall_po                                       ';
sqlstring2:=sqlstring2 || '     FROM (SELECT   DECODE (PO_TR_TUNNEL_1_2_1_0_5_5_AP, ''NYA'', 1, 0)     ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_TUNNEL_1_2_1_0_5_6_AP, ''NYA'', 1, 0)     ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_TUNNEL_1_2_1_0_5_7_AP, ''NYA'', 1, 0)     ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_TR_TUNNEL_1_2_1_0_5_8_AP, ''NYA'', 1, 0)     ';
sqlstring2:=sqlstring2 || '                  + DECODE (dic_gall.inf_nya, NULL, 1, dic_gall.inf_nya)    ';
sqlstring2:=sqlstring2 || '                     conta_nya                                              ';
sqlstring2:=sqlstring2 || '             FROM rinf_pubblicati_evo.GALLERIE_BINARI_PO nya,               ';
sqlstring2:=sqlstring2 || '                  (  SELECT PO_TR_TUNNEL_1_2_1_0_5_2,                       ';
sqlstring2:=sqlstring2 || '                            SUM (                                           ';
sqlstring2:=sqlstring2 || '                               DECODE (PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,       ';
sqlstring2:=sqlstring2 || '                                       ''NYA'', 1,                          ';
sqlstring2:=sqlstring2 || '                                       0))                                  ';
sqlstring2:=sqlstring2 || '                               inf_nya                                      ';
sqlstring2:=sqlstring2 || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_PO';
sqlstring2:=sqlstring2 || '                      WHERE codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                   GROUP BY PO_TR_TUNNEL_1_2_1_0_5_2) dic_gall               ';
sqlstring2:=sqlstring2 || '            WHERE     codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                  AND nya.PO_TR_TUNNEL_1_2_1_0_5_2 =                         ';
sqlstring2:=sqlstring2 || '                         dic_gall.PO_TR_TUNNEL_1_2_1_0_5_2(+))) nya_gall_po, ';
sqlstring2:=sqlstring2 || '  (SELECT SUM (conta_nya) nya_racc_po                                        ';
sqlstring2:=sqlstring2 || '     FROM (SELECT   DECODE (PO_SD_1_2_2_0_0_3_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_2_1_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_3_1_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_3_2_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_3_3_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_4_1_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_4_2_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_4_3_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_4_4_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_4_5_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (PO_SD_1_2_2_0_4_6_AP, ''NYA'', 1, 0)             ';
sqlstring2:=sqlstring2 || '                  + DECODE (dic_racc_po.inf_nya,                             ';
sqlstring2:=sqlstring2 || '                            NULL, 1,                                         ';
sqlstring2:=sqlstring2 || '                            dic_racc_po.inf_nya)                             ';
sqlstring2:=sqlstring2 || '                     conta_nya                                               ';
sqlstring2:=sqlstring2 || '             FROM rinf_pubblicati_evo.BINARI_RACCORDO_PO nya,                ';
sqlstring2:=sqlstring2 || '                  (  SELECT PO_SD_1_2_2_0_0_2,                               ';
sqlstring2:=sqlstring2 || '                            SUM (                                            ';
sqlstring2:=sqlstring2 || '                               DECODE (PO_SD_1_2_2_0_1_1O2_AP,               ';
sqlstring2:=sqlstring2 || '                                       ''NYA'', 1,                           ';
sqlstring2:=sqlstring2 || '                                       0))                                   ';
sqlstring2:=sqlstring2 || '                               inf_nya                                       ';
sqlstring2:=sqlstring2 || '                       FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_RACCORDO_PO    ';
sqlstring2:=sqlstring2 || '                      WHERE codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                   GROUP BY PO_SD_1_2_2_0_0_2) dic_racc_po                   ';
sqlstring2:=sqlstring2 || '            WHERE     codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                  AND nya.PO_SD_1_2_2_0_0_2 =                                ';
sqlstring2:=sqlstring2 || '                         dic_racc_po.PO_SD_1_2_2_0_0_2(+))) nya_racc_po,     ';
sqlstring2:=sqlstring2 || '  (SELECT SUM (conta_nya) nya_gall_racc                                    ';
sqlstring2:=sqlstring2 || '  FROM (SELECT   DECODE (PO_SD_TUNNEL_1_2_2_0_5_5_AP, ''NYA'', 1, 0)       ';
sqlstring2:=sqlstring2 || '                     + DECODE (PO_SD_TUNNEL_1_2_2_0_5_6_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                     + DECODE (PO_SD_TUNNEL_1_2_2_0_5_7_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                     + DECODE (PO_SD_TUNNEL_1_2_2_0_5_8_AP, ''NYA'', 1, 0) ';
sqlstring2:=sqlstring2 || '                     + +DECODE (dic_gall_racc.inf_nya,                     ';
sqlstring2:=sqlstring2 || '                                NULL, 1,                                   ';
sqlstring2:=sqlstring2 || '                                dic_gall_racc.inf_nya)                     ';
sqlstring2:=sqlstring2 || '                        conta_nya                                          ';
sqlstring2:=sqlstring2 || '                FROM rinf_pubblicati_evo.GALLERIE_RACCORDO_PO nya,         ';
sqlstring2:=sqlstring2 || '                     (  SELECT PO_SD_TUNNEL_1_2_2_0_5_2,                   ';
sqlstring2:=sqlstring2 || '                               SUM (                                       ';
sqlstring2:=sqlstring2 || '                                  DECODE (PO_SD_TUNNEL_1_2_2_0_5_3O4_AP,   ';
sqlstring2:=sqlstring2 || '                                          ''NYA'', 1,                      ';
sqlstring2:=sqlstring2 || '                                          0))                              ';
sqlstring2:=sqlstring2 || '                                  inf_nya                                  ';
sqlstring2:=sqlstring2 || '                          FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_SD_PO          ';
sqlstring2:=sqlstring2 || '                         WHERE codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                      GROUP BY PO_SD_TUNNEL_1_2_2_0_5_2) dic_gall_racc                   ';
sqlstring2:=sqlstring2 || '               WHERE     codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || '                     AND nya.PO_SD_TUNNEL_1_2_2_0_5_2 =                                  ';
sqlstring2:=sqlstring2 || '                            dic_gall_racc.PO_SD_TUNNEL_1_2_2_0_5_2(+))) nya_gall_racc,   ';
sqlstring2:=sqlstring2 || '        (SELECT COUNT (DISTINCT SOL_TRACK_1_1_1_0_0_1) n_dic_inf_bin_sol ';
sqlstring2:=sqlstring2 || '           FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF ';
sqlstring2:=sqlstring2 || '          WHERE codice_versione = ' ||p_i_versione ||' AND SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'') dic_inf_bin_sol, ';
sqlstring2:=sqlstring2 || '        (SELECT COUNT (DISTINCT SOL_TRACK_1_1_1_0_0_1) n_dic_ene_bin_sol ';
sqlstring2:=sqlstring2 || '           FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE ';
sqlstring2:=sqlstring2 || '          WHERE codice_versione = ' ||p_i_versione ||' AND SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y'') dic_ene_bin_sol, ';
sqlstring2:=sqlstring2 || '        (SELECT COUNT (DISTINCT SOL_TRACK_1_1_1_0_0_1) n_dic_ccs_bin_sol ';
sqlstring2:=sqlstring2 || '           FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_CCS ';
sqlstring2:=sqlstring2 || '          WHERE codice_versione = ' ||p_i_versione ||' AND SOL_TRACK_1_1_1_3_1_1_AP = ''Y'') dic_ccs_bin_sol, ';
sqlstring2:=sqlstring2 || '        (SELECT COUNT (DISTINCT SOL_TUNNEL_1_1_1_1_8_2) n_dic_inf_gall_sol ';
sqlstring2:=sqlstring2 || '           FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_SOL ';
sqlstring2:=sqlstring2 || '          WHERE codice_versione = ' ||p_i_versione ||' AND SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'') dic_inf_gall_sol, ';
sqlstring2:=sqlstring2 || '        (SELECT COUNT (DISTINCT PO_TRACK_1_2_1_0_0_2) n_dic_inf_bin_po ';
sqlstring2:=sqlstring2 || '           FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_PO ';
sqlstring2:=sqlstring2 || '          WHERE codice_versione = ' ||p_i_versione ||'  AND PO_TRACK_1_2_1_0_1_1O2_AP = ''Y'') dic_inf_bin_po, ';
sqlstring2:=sqlstring2 || '        (SELECT COUNT (DISTINCT PO_TR_TUNNEL_1_2_1_0_5_2) n_dic_inf_gall_po ';
sqlstring2:=sqlstring2 || '           FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_PO ';
sqlstring2:=sqlstring2 || '          WHERE codice_versione  = ' ||p_i_versione ||'  AND PO_TR_TUNNEL_1_2_1_0_5_3O4_AP = ''Y'') dic_inf_gall_po, ';
sqlstring2:=sqlstring2 || '        (SELECT COUNT (DISTINCT PO_SD_1_2_2_0_0_2) n_dic_inf_racc_po ';
sqlstring2:=sqlstring2 || '           FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_RACCORDO_PO ';
sqlstring2:=sqlstring2 || '          WHERE codice_versione  = ' ||p_i_versione ||' AND PO_SD_1_2_2_0_1_1O2_AP = ''Y'') dic_inf_racc_po, ';
sqlstring2:=sqlstring2 || '        (SELECT COUNT (DISTINCT PO_SD_TUNNEL_1_2_2_0_5_2) n_dic_inf_gall_racc ';
sqlstring2:=sqlstring2 || '           FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_SD_PO ';
sqlstring2:=sqlstring2 || '          WHERE codice_versione  = ' ||p_i_versione ||'  AND PO_SD_TUNNEL_1_2_2_0_5_3O4_AP = ''Y'') dic_inf_gall_racc, ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_sol                            ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.sezioni_linea          ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione||') conta_sol,            ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_binari                         ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.binari_corsa_sol       ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione||'';

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || ' and sede_tecnica in ';
sqlstring2:=sqlstring2 || ' (select sede_tecnica';
sqlstring2:=sqlstring2 || ' from RINF_PUBBLICATI_EVO.SEZIONI_LINEA';
sqlstring2:=sqlstring2 || '  where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || '  and codice_versione = ' ||p_i_versione;
sqlstring2:=sqlstring2 || ' ) ';
----

sqlstring2:=sqlstring2 || ' ) conta_bin,            ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_gall_sol                       ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.GALLERIE_BINARI_SOL    ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || 'and SOL_TUNNEL_1_1_1_1_8_2 in ';
sqlstring2:=sqlstring2 || ' ( select distinct SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring2:=sqlstring2 || ' from RINF_PUBBLICATI_EVO.REL_GALLERIE_BINARI_SOL rel ';
sqlstring2:=sqlstring2 || ' where SOL_TRACK_1_1_1_0_0_1 in  ';
sqlstring2:=sqlstring2 || ' ( ';
sqlstring2:=sqlstring2 || ' select distinct rel.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring2:=sqlstring2 || ' FROM RINF_PUBBLICATI_EVO.SEZIONI_LINEA  sez, ';
sqlstring2:=sqlstring2 || ' RINF_PUBBLICATI_EVO.REL_GALLERIE_BINARI_SOL rel, ';
sqlstring2:=sqlstring2 || ' rinf_pubblicati_evo.binari_corsa_sol      bin ';
sqlstring2:=sqlstring2 || ' where rel.SOL_TRACK_1_1_1_0_0_1=bin.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring2:=sqlstring2 || ' and bin.sede_tecnica =SEZ.SEDE_TECNICA ';
sqlstring2:=sqlstring2 || ' and SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || ' and rel.codice_versione = '||p_i_versione;
sqlstring2:=sqlstring2 || ' and  rel.codice_versione = bin.codice_versione ';
sqlstring2:=sqlstring2 || ' and sez.codice_versione = bin.codice_versione)) ';
-----

sqlstring2:=sqlstring2 || ') conta_gall_sol,       ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_po                             ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.PUNTI_OPERATIVI        ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione||') conta_po,             ';
sqlstring2:=sqlstring2 || ' (SELECT COUNT (*) n_binari_po                      ';
sqlstring2:=sqlstring2 || '    FROM rinf_pubblicati_evo.binari_corsa_po        ';
sqlstring2:=sqlstring2 || '   WHERE codice_versione = '||p_i_versione;

-----introdotto per togliere gli NYA dei LINK
sqlstring2:=sqlstring2 || 'and (substr(PO_TRACK_1_2_1_0_0_2,1,2) =''LO'' ';
sqlstring2:=sqlstring2 || 'or ';
sqlstring2:=sqlstring2 || '(substr(PO_TRACK_1_2_1_0_0_2,1,6) in ';
sqlstring2:=sqlstring2 || ' (select sede_tecnica ';
sqlstring2:=sqlstring2 || ' from RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring2:=sqlstring2 || ' where SOL_1_1_0_0_0_6 =''R'' ';
sqlstring2:=sqlstring2 || ' and codice_versione = '||p_i_versione;
sqlstring2:=sqlstring2 || ')))';
-----

sqlstring2:=sqlstring2 || ') conta_bin_po,         ';
sqlstring2:=sqlstring2 || '        (SELECT COUNT (*) n_plat ';
sqlstring2:=sqlstring2 || '           FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO ';
sqlstring2:=sqlstring2 || '          WHERE codice_versione  = ' ||p_i_versione ||' ) conta_plat, ';
sqlstring2:=sqlstring2 || '        (SELECT COUNT (*) n_gall_po ';
sqlstring2:=sqlstring2 || '           FROM rinf_pubblicati_evo.GALLERIE_BINARI_PO ';
sqlstring2:=sqlstring2 || '          WHERE codice_versione  = ' ||p_i_versione ||' ) conta_gall_po, ';
sqlstring2:=sqlstring2 || '        (SELECT COUNT (*) n_racc_po ';
sqlstring2:=sqlstring2 || '           FROM rinf_pubblicati_evo.BINARI_RACCORDO_PO ';
sqlstring2:=sqlstring2 || '          WHERE codice_versione  = ' ||p_i_versione ||' ) conta_racc_po, ';
sqlstring2:=sqlstring2 || '        (SELECT COUNT (*) n_gall_racc ';
sqlstring2:=sqlstring2 || '           FROM rinf_pubblicati_evo.GALLERIE_RACCORDO_PO ';
sqlstring2:=sqlstring2 || '          WHERE codice_versione  = ' ||p_i_versione ||' ) conta_gall_racc ';

OPEN p_cursor FOR sqlstring|| ' ' || sqlstring2;
--DBMS_OUTPUT.PUT_LINE(sqlstring);
--DBMS_OUTPUT.PUT_LINE(sqlstring2);

END GetKPIRegistroPubbl ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetVariazioneOggPubbl  (p_i_versione_corrente NUMBER, p_i_versione_precedente NUMBER, p_cursor OUT empcur) IS
--REPORT 3.3.5

sqlstring VARCHAR2(32767);

BEGIN

sqlstring:=' SELECT ver_corr.CODICE_VERSIONE, ';
sqlstring:=sqlstring || ' to_char(ver_corr.DATA_PUBBLICAZIONE,''DD/MM/YY HH:MI:SS'') DATA_PUBBLICAZIONE,  ';
sqlstring:=sqlstring || '        registro_corr.CODICE_DTP, ';
sqlstring:=sqlstring || '        anag_tipi.tipo_oggetto, ';
sqlstring:=sqlstring || '        NVL (registro_corr.n_oggetti, 0) n_oggetti, ';
sqlstring:=sqlstring || '        ver_prec.CODICE_VERSIONE versione_precedente, ';
sqlstring:=sqlstring || ' to_char(ver_prec.DATA_PUBBLICAZIONE,''DD/MM/YY HH:MI:SS'') data_pubblicazione_ver_prec,  ';
sqlstring:=sqlstring || '        NVL (registro_corr.n_oggetti, 0) - NVL (registro_prec.n_oggetti, 0) ';
sqlstring:=sqlstring || '           delta_n_oggetti ';
sqlstring:=sqlstring || ' FROM (  SELECT CODICE_DTP, ';
sqlstring:=sqlstring || '      ''MARCIAPIEDI_OP'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '      SUM (n_oggetti) n_oggetti ';
sqlstring:=sqlstring || ' FROM (  SELECT CODICE_DTP, ';
sqlstring:=sqlstring || '                ''MARCIAPIEDI_OP'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '                COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '           FROM RINF_PUBBLICATI_EVO.MARCIAPIEDI_BINARI_PO g, ';
sqlstring:=sqlstring || '                RINF_PUBBLICATI_EVO.BINARI_CORSA_PO b, ';
sqlstring:=sqlstring || '                RINF_PUBBLICATI_EVO.REL_PO_BINARI_CORSA f, ';
sqlstring:=sqlstring || '                RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI s ';
sqlstring:=sqlstring || '          WHERE     g.CODICE_VERSIONE = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || '                AND g.BINARIO_1 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '                AND g.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '                AND f.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '                AND f.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '                AND f.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '                AND f.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || '       GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || '       UNION ';
sqlstring:=sqlstring || '         SELECT CODICE_DTP, ';
sqlstring:=sqlstring || '                ''MARCIAPIEDI_OP'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '                COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '           FROM RINF_PUBBLICATI_EVO.MARCIAPIEDI_BINARI_PO g, ';
sqlstring:=sqlstring || '                RINF_PUBBLICATI_EVO.BINARI_CORSA_PO b, ';
sqlstring:=sqlstring || '                RINF_PUBBLICATI_EVO.REL_PO_BINARI_CORSA f, ';
sqlstring:=sqlstring || '                RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI s ';
sqlstring:=sqlstring || '          WHERE     g.CODICE_VERSIONE = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || '                AND g.BINARIO_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '                AND g.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '                AND f.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '                AND f.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '                AND f.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '        AND f.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || '           GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || '           UNION ';
sqlstring:=sqlstring || '             SELECT CODICE_DTP, ';
sqlstring:=sqlstring || '                    ''MARCIAPIEDI_OP'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '                    COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '               FROM RINF_PUBBLICATI_EVO.MARCIAPIEDI_BINARI_PO g, ';
sqlstring:=sqlstring || '                    RINF_PUBBLICATI_EVO.BINARI_CORSA_PO b, ';
sqlstring:=sqlstring || '                    RINF_PUBBLICATI_EVO.REL_PO_BINARI_CORSA f, ';
sqlstring:=sqlstring || '                    RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI s ';
sqlstring:=sqlstring || '              WHERE     g.CODICE_VERSIONE = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || '                    AND g.BINARIO_3 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '                    AND g.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '                    AND f.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '                    AND f.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '                    AND f.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '                    AND f.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || '           GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || '           UNION ';
sqlstring:=sqlstring || '             SELECT CODICE_DTP, ';
sqlstring:=sqlstring || '                    ''MARCIAPIEDI_OP'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '                    COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '               FROM RINF_PUBBLICATI_EVO.MARCIAPIEDI_BINARI_PO g, ';
sqlstring:=sqlstring || '                    RINF_PUBBLICATI_EVO.BINARI_CORSA_PO b, ';
sqlstring:=sqlstring || '                    RINF_PUBBLICATI_EVO.REL_PO_BINARI_CORSA f, ';
sqlstring:=sqlstring || '                    RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI s ';
sqlstring:=sqlstring || '              WHERE     g.CODICE_VERSIONE = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || '                    AND g.BINARIO_4 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '                    AND g.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '                    AND f.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '                    AND f.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '                    AND f.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '                    AND f.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || '           GROUP BY CODICE_DTP) ';
sqlstring:=sqlstring || ' GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || ' UNION ';
sqlstring:=sqlstring || '   SELECT CODICE_DTP, ''OP'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '     FROM RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI ';
sqlstring:=sqlstring || '    WHERE CODICE_VERSIONE = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || ' GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || ' UNION ';
sqlstring:=sqlstring || '   SELECT CODICE_DTP, ''SOL'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '     FROM RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '    WHERE CODICE_VERSIONE = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || ' GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || ' UNION ';
sqlstring:=sqlstring || '   SELECT CODICE_DTP, ''BINARI_CORSA_OP'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '     FROM RINF_PUBBLICATI_EVO.BINARI_CORSA_PO b, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.REL_PO_BINARI_CORSA r, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI p ';
sqlstring:=sqlstring || '    WHERE     b.CODICE_VERSIONE = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || '          AND b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '          AND b.CODICE_VERSIONE = r.CODICE_VERSIONE ';
sqlstring:=sqlstring || '          AND r.SEDE_TECNICA = p.SEDE_TECNICA ';
sqlstring:=sqlstring || '          AND r.CODICE_VERSIONE = p.CODICE_VERSIONE ';
sqlstring:=sqlstring || ' GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || ' UNION ';
sqlstring:=sqlstring || '   SELECT CODICE_DTP, ''BINARI_CORSA_SOL'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '     FROM RINF_PUBBLICATI_EVO.BINARI_CORSA_SOL b, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.SEZIONI_LINEA s ';
sqlstring:=sqlstring || '    WHERE     b.CODICE_VERSIONE = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || '          AND b.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '          AND b.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || ' GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || ' UNION ';
sqlstring:=sqlstring || '   SELECT CODICE_DTP, ''BINARI_SECONDARI_OP'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '     FROM RINF_PUBBLICATI_EVO.BINARI_RACCORDO_PO b, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI p ';
sqlstring:=sqlstring || '    WHERE     b.CODICE_VERSIONE = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || '          AND b.SEDE_TECNICA = p.SEDE_TECNICA ';
sqlstring:=sqlstring || '          AND b.CODICE_VERSIONE = p.CODICE_VERSIONE ';
sqlstring:=sqlstring || ' GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || ' UNION ';
sqlstring:=sqlstring || '   SELECT CODICE_DTP, ''GALLERIE_BINARI_SOL'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '     FROM RINF_PUBBLICATI_EVO.GALLERIE_BINARI_SOL g, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.REL_GALLERIE_BINARI_SOL r, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.BINARI_CORSA_SOL b, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.SEZIONI_LINEA s ';
sqlstring:=sqlstring || '    WHERE     g.CODICE_VERSIONE = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || '          AND g.SOL_TUNNEL_1_1_1_1_8_2 = r.SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring:=sqlstring || '          AND g.CODICE_VERSIONE = r.CODICE_VERSIONE ';
sqlstring:=sqlstring || '          AND r.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring || '          AND r.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '          AND b.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '          AND b.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || ' GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || ' UNION ';
sqlstring:=sqlstring || '   SELECT CODICE_DTP, ''GALLERIE_BINARI_OP'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '     FROM RINF_PUBBLICATI_EVO.GALLERIE_BINARI_PO g, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.REL_GALLERIE_BINARI_PO r, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.BINARI_CORSA_PO b, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.REL_PO_BINARI_CORSA f, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI s ';
sqlstring:=sqlstring || '    WHERE     g.CODICE_VERSIONE = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || '          AND g.PO_TR_TUNNEL_1_2_1_0_5_2 = r.PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring || '          AND g.CODICE_VERSIONE = r.CODICE_VERSIONE ';
sqlstring:=sqlstring || '          AND r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '          AND r.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '          AND f.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '          AND f.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '          AND f.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '          AND f.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || ' GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || ' UNION ';
sqlstring:=sqlstring || '   SELECT CODICE_DTP, ';
sqlstring:=sqlstring || '          ''GALLERIE_BINARI_SECONDARI_OP'', ';
sqlstring:=sqlstring || '          COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '     FROM RINF_PUBBLICATI_EVO.GALLERIE_RACCORDO_PO g, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.REL_GALLERIE_RACCORDO_PO r, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.BINARI_RACCORDO_PO b, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI s ';
sqlstring:=sqlstring || '    WHERE     g.CODICE_VERSIONE = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || '          AND g.PO_SD_TUNNEL_1_2_2_0_5_2 = r.PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring || '          AND g.CODICE_VERSIONE = r.CODICE_VERSIONE ';
sqlstring:=sqlstring || '          AND r.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2 ';
sqlstring:=sqlstring || '          AND r.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '          AND b.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '          AND b.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || '  GROUP BY CODICE_DTP) registro_corr, ';
sqlstring:=sqlstring || ' (  SELECT CODICE_DTP, ';
sqlstring:=sqlstring || '           ''MARCIAPIEDI_OP'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '           SUM (n_oggetti) n_oggetti ';
sqlstring:=sqlstring || '      FROM (  SELECT CODICE_DTP, ';
sqlstring:=sqlstring || '                     ''MARCIAPIEDI_OP'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '                     COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '                FROM RINF_PUBBLICATI_EVO.MARCIAPIEDI_BINARI_PO g, ';
sqlstring:=sqlstring || '                     RINF_PUBBLICATI_EVO.BINARI_CORSA_PO b, ';
sqlstring:=sqlstring || '                     RINF_PUBBLICATI_EVO.REL_PO_BINARI_CORSA f, ';
sqlstring:=sqlstring || '                     RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI s ';
sqlstring:=sqlstring || '               WHERE     g.CODICE_VERSIONE = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || '                     AND g.BINARIO_1 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '                     AND g.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '                     AND f.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '                     AND f.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '                     AND f.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '                     AND f.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || '            GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || '            UNION ';
sqlstring:=sqlstring || '              SELECT CODICE_DTP, ';
sqlstring:=sqlstring || '                     ''MARCIAPIEDI_OP'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '                     COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '                FROM RINF_PUBBLICATI_EVO.MARCIAPIEDI_BINARI_PO g, ';
sqlstring:=sqlstring || '                     RINF_PUBBLICATI_EVO.BINARI_CORSA_PO b, ';
sqlstring:=sqlstring || '                     RINF_PUBBLICATI_EVO.REL_PO_BINARI_CORSA f, ';
sqlstring:=sqlstring || '                     RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI s ';
sqlstring:=sqlstring || '               WHERE     g.CODICE_VERSIONE = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || '                     AND g.BINARIO_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '                     AND g.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '                     AND f.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '                     AND f.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '                     AND f.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '                     AND f.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || ' GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || ' UNION ';
sqlstring:=sqlstring || '   SELECT CODICE_DTP, ';
sqlstring:=sqlstring || '          ''MARCIAPIEDI_OP'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '          COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '     FROM RINF_PUBBLICATI_EVO.MARCIAPIEDI_BINARI_PO g, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.BINARI_CORSA_PO b, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.REL_PO_BINARI_CORSA f, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI s ';
sqlstring:=sqlstring || '    WHERE     g.CODICE_VERSIONE = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || '          AND g.BINARIO_3 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '          AND g.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '          AND f.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '          AND f.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '          AND f.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '          AND f.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || ' GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || ' UNION ';
sqlstring:=sqlstring || '   SELECT CODICE_DTP, ';
sqlstring:=sqlstring || '          ''MARCIAPIEDI_OP'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '          COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '     FROM RINF_PUBBLICATI_EVO.MARCIAPIEDI_BINARI_PO g, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.BINARI_CORSA_PO b, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.REL_PO_BINARI_CORSA f, ';
sqlstring:=sqlstring || '          RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI s ';
sqlstring:=sqlstring || '    WHERE     g.CODICE_VERSIONE = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || '          AND g.BINARIO_4 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '          AND g.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '          AND f.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '          AND f.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '          AND f.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '          AND f.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || ' GROUP BY CODICE_DTP) ';
sqlstring:=sqlstring || 'GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || 'UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''OP'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '    FROM RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI ';
sqlstring:=sqlstring || '   WHERE CODICE_VERSIONE = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || 'GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || 'UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''SOL'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '    FROM RINF_PUBBLICATI_EVO.SEZIONI_LINEA ';
sqlstring:=sqlstring || '   WHERE CODICE_VERSIONE = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || 'GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || 'UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''BINARI_CORSA_OP'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '    FROM RINF_PUBBLICATI_EVO.BINARI_CORSA_PO b, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.REL_PO_BINARI_CORSA r, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI p ';
sqlstring:=sqlstring || '   WHERE     b.CODICE_VERSIONE = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || '         AND b.PO_TRACK_1_2_1_0_0_2 = r.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '         AND b.CODICE_VERSIONE = r.CODICE_VERSIONE ';
sqlstring:=sqlstring || '         AND r.SEDE_TECNICA = p.SEDE_TECNICA ';
sqlstring:=sqlstring || '         AND r.CODICE_VERSIONE = p.CODICE_VERSIONE ';
sqlstring:=sqlstring || 'GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || 'UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''BINARI_CORSA_SOL'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '    FROM RINF_PUBBLICATI_EVO.BINARI_CORSA_SOL b, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.SEZIONI_LINEA s ';
sqlstring:=sqlstring || '   WHERE     b.CODICE_VERSIONE = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || '         AND b.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '         AND b.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || 'GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || 'UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''BINARI_SECONDARI_OP'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '    FROM RINF_PUBBLICATI_EVO.BINARI_RACCORDO_PO b, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI p ';
sqlstring:=sqlstring || '   WHERE     b.CODICE_VERSIONE = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || '         AND b.SEDE_TECNICA = p.SEDE_TECNICA ';
sqlstring:=sqlstring || '         AND b.CODICE_VERSIONE = p.CODICE_VERSIONE ';
sqlstring:=sqlstring || 'GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || 'UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''GALLERIE_BINARI_SOL'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '    FROM RINF_PUBBLICATI_EVO.GALLERIE_BINARI_SOL g, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.REL_GALLERIE_BINARI_SOL r, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.BINARI_CORSA_SOL b, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.SEZIONI_LINEA s ';
sqlstring:=sqlstring || '   WHERE     g.CODICE_VERSIONE = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || '         AND g.SOL_TUNNEL_1_1_1_1_8_2 = r.SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring:=sqlstring || '         AND g.CODICE_VERSIONE = r.CODICE_VERSIONE ';
sqlstring:=sqlstring || '         AND r.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring || '         AND r.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '         AND b.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '         AND b.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || 'GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || 'UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''GALLERIE_BINARI_OP'', COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '    FROM RINF_PUBBLICATI_EVO.GALLERIE_BINARI_PO g, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.REL_GALLERIE_BINARI_PO r, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.BINARI_CORSA_PO b, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.REL_PO_BINARI_CORSA f, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI s ';
sqlstring:=sqlstring || '   WHERE     g.CODICE_VERSIONE = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || '         AND g.PO_TR_TUNNEL_1_2_1_0_5_2 = r.PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring || '         AND g.CODICE_VERSIONE = r.CODICE_VERSIONE ';
sqlstring:=sqlstring || '         AND r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '         AND r.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '         AND f.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring || '         AND f.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '         AND f.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '         AND f.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || 'GROUP BY CODICE_DTP ';
sqlstring:=sqlstring || 'UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ';
sqlstring:=sqlstring || '         ''GALLERIE_BINARI_SECONDARI_OP'', ';
sqlstring:=sqlstring || '         COUNT (*) n_oggetti ';
sqlstring:=sqlstring || '    FROM RINF_PUBBLICATI_EVO.GALLERIE_RACCORDO_PO g, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.REL_GALLERIE_RACCORDO_PO r, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.BINARI_RACCORDO_PO b, ';
sqlstring:=sqlstring || '         RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI s ';
sqlstring:=sqlstring || '   WHERE     g.CODICE_VERSIONE = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || '         AND g.PO_SD_TUNNEL_1_2_2_0_5_2 = r.PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring || '         AND g.CODICE_VERSIONE = r.CODICE_VERSIONE ';
sqlstring:=sqlstring || '         AND r.PO_SD_1_2_2_0_0_2 = b.PO_SD_1_2_2_0_0_2 ';
sqlstring:=sqlstring || '         AND r.CODICE_VERSIONE = b.CODICE_VERSIONE ';
sqlstring:=sqlstring || '         AND b.SEDE_TECNICA = s.SEDE_TECNICA ';
sqlstring:=sqlstring || '         AND b.CODICE_VERSIONE = s.CODICE_VERSIONE ';
sqlstring:=sqlstring || 'GROUP BY CODICE_DTP) registro_prec, ';
sqlstring:=sqlstring || ' (SELECT CODICE_DTP, ''MARCIAPIEDI_OP'' TIPO_OGGETTO ';
sqlstring:=sqlstring || '    FROM RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '   WHERE CODICE_DTP <> ''-1'' ';
sqlstring:=sqlstring || '  UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''OP'' TIPO_OGGETTO ';
sqlstring:=sqlstring || '    FROM RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '   WHERE CODICE_DTP <> ''-1'' ';
sqlstring:=sqlstring || '  UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''SOL'' TIPO_OGGETTO ';
sqlstring:=sqlstring || '    FROM RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '   WHERE CODICE_DTP <> ''-1'' ';
sqlstring:=sqlstring || '  UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''BINARI_CORSA_OP'' TIPO_OGGETTO ';
sqlstring:=sqlstring || '    FROM RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '   WHERE CODICE_DTP <> ''-1'' ';
sqlstring:=sqlstring || '  UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''BINARI_CORSA_SOL'' TIPO_OGGETTO ';
sqlstring:=sqlstring || '    FROM RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '   WHERE CODICE_DTP <> ''-1'' ';
sqlstring:=sqlstring || '  UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''BINARI_SECONDARI_OP'' TIPO_OGGETTO ';
sqlstring:=sqlstring || '    FROM RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '   WHERE CODICE_DTP <> ''-1'' ';
sqlstring:=sqlstring || '  UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''GALLERIE_BINARI_SOL'' TIPO_OGGETTO ';
sqlstring:=sqlstring || '    FROM RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '   WHERE CODICE_DTP <> ''-1'' ';
sqlstring:=sqlstring || '  UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''GALLERIE_BINARI_OP'' TIPO_OGGETTO ';
sqlstring:=sqlstring || '    FROM RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '   WHERE CODICE_DTP <> ''-1'' ';
sqlstring:=sqlstring || '  UNION ';
sqlstring:=sqlstring || '  SELECT CODICE_DTP, ''GALLERIE_BINARI_SECONDARI_OP'' TIPO_OGGETTO ';
sqlstring:=sqlstring || '    FROM RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '   WHERE CODICE_DTP <> ''-1'') anag_tipi, ';
sqlstring:=sqlstring || ' RINF_PUBBLICATI_EVO.VERSIONE_RINF ver_corr, ';
sqlstring:=sqlstring || ' RINF_PUBBLICATI_EVO.VERSIONE_RINF ver_prec ';
sqlstring:=sqlstring || ' WHERE ver_corr.codice_versione = '||p_i_versione_corrente||' ';
sqlstring:=sqlstring || ' AND ver_prec.codice_versione = '||p_i_versione_precedente||' ';
sqlstring:=sqlstring || ' AND anag_tipi.tipo_oggetto = registro_corr.tipo_oggetto(+) ';
sqlstring:=sqlstring || ' AND anag_tipi.CODICE_DTP = registro_corr.CODICE_DTP(+) ';
sqlstring:=sqlstring || ' AND anag_tipi.tipo_oggetto = registro_prec.tipo_oggetto(+) ';
sqlstring:=sqlstring || ' AND anag_tipi.CODICE_DTP = registro_prec.CODICE_DTP(+) ';

--DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetVariazioneOggPubbl ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetVarScartiAcquisValidazione  (p_i_controllo_corrente NUMBER, p_i_controllo_precedente NUMBER, p_cursor OUT empcur) IS
--REPORT 3.3.6

sqlstring VARCHAR2(32767);

BEGIN

sqlstring:=' SELECT ';
sqlstring:=sqlstring || ' val_corr.CODICE_CONTROLLO controllo_corrente, ';
sqlstring:=sqlstring || ' to_char(val_corr.DATA_CONTROLLO,''DD/MM/YY HH:MI:SS'') data_controllo_corr,  ';
sqlstring:=sqlstring || ' val_corr.CODICE_DTP, ';
sqlstring:=sqlstring || ' val_corr.n_OP_acq, ';
sqlstring:=sqlstring || ' val_corr.n_SOL_acq, ';
sqlstring:=sqlstring || ' val_corr.Scarti_Acq_OP, ';
sqlstring:=sqlstring || ' val_corr.Scarti_Acq_SOL, ';
sqlstring:=sqlstring || ' val_corr.n_OP_val, ';
sqlstring:=sqlstring || ' val_corr.n_SOL_val, ';
sqlstring:=sqlstring || ' val_corr.Scarti_Val_OP, ';
sqlstring:=sqlstring || ' val_corr.Scarti_Val_SOL, ';
sqlstring:=sqlstring || ' val_prec.CODICE_CONTROLLO controllo_precedente, ';
sqlstring:=sqlstring || ' to_char(val_prec.DATA_CONTROLLO,''DD/MM/YY HH:MI:SS'') data_controllo_prec,  ';
sqlstring:=sqlstring || ' NVL(val_corr.n_OP_acq,0)-        NVL(val_prec.n_OP_acq,0)      delta_OP_acq, ';
sqlstring:=sqlstring || ' NVL(val_corr.n_SOL_acq,0)-              NVL(val_prec.n_SOL_acq,0)     delta_SOL_acq, ';
sqlstring:=sqlstring || ' NVL(val_corr.Scarti_Acq_OP,0)-          NVL(val_prec.Scarti_Acq_OP,0) delta_Scarti_acq_OP, ';
sqlstring:=sqlstring || ' NVL(val_corr.Scarti_Acq_SOL,0)-         NVL(val_prec.Scarti_Acq_SOL,0) delta_Scarti_acq_SOL, ';
sqlstring:=sqlstring || ' NVL(val_corr.n_OP_val,0)-               NVL(val_prec.n_OP_val,0)         delta_Val_OP, ';
sqlstring:=sqlstring || ' NVL(val_corr.n_SOL_val,0)-              NVL(val_prec.n_SOL_val,0)     delta_Val_SOL, ';
sqlstring:=sqlstring || ' NVL(val_corr.Scarti_Val_OP,0)-          NVL(val_prec.Scarti_Val_OP,0)    delta_Scarti_Val_OP,   ';
sqlstring:=sqlstring || ' NVL(val_corr.Scarti_Val_SOL,0)-         NVL(val_prec.Scarti_Val_SOL,0)    delta_Scarti_Val_SOL ';
sqlstring:=sqlstring || ' from  ';
sqlstring:=sqlstring || '   (SELECT val.CODICE_CONTROLLO,val.DATA_CONTROLLO, ';
sqlstring:=sqlstring || '   tot_val.CODICE_DTP,n_OP_acq,n_SOL_acq, ';
sqlstring:=sqlstring || '   Scarti_Acq_OP,Scarti_Acq_SOL, ';
sqlstring:=sqlstring || '    n_OP_val,n_SOL_val, ';
sqlstring:=sqlstring || '                    Scarti_Val_OP, ';
sqlstring:=sqlstring || '                    Scarti_Val_SOL ';
sqlstring:=sqlstring || '     FROM (  SELECT a.CODICE_ACQUISIZIONE, ';
sqlstring:=sqlstring || '                    a.CODICE_DTP, ';
sqlstring:=sqlstring || '                    SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0)) ';
sqlstring:=sqlstring || '                       n_OP_acq, ';
sqlstring:=sqlstring || '                    SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0)) ';
sqlstring:=sqlstring || '                       n_SOL_acq, ';
sqlstring:=sqlstring || '                    Scarti_Acq_OP, ';
sqlstring:=sqlstring || '                    Scarti_Acq_SOL ';
sqlstring:=sqlstring || '               FROM RINF_LAVORAZIONE_EVO.OGGETTI_ACQUISITI a, ';
sqlstring:=sqlstring || '                    (  SELECT CODICE_ACQUISIZIONE, ';
sqlstring:=sqlstring || '                              CODICE_DTP, ';
sqlstring:=sqlstring || '                              SUM ( ';
sqlstring:=sqlstring || '                                 DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0)) ';
sqlstring:=sqlstring || '                                 Scarti_Acq_OP, ';
sqlstring:=sqlstring || '                              SUM ( ';
sqlstring:=sqlstring || '                                 DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0)) ';
sqlstring:=sqlstring || '                                 Scarti_Acq_SOL ';
sqlstring:=sqlstring || '                         FROM (SELECT DISTINCT ';
sqlstring:=sqlstring || '                                      CODICE_ACQUISIZIONE, CODICE_SOL_PO, CODICE_DTP ';
sqlstring:=sqlstring || '                                 FROM RINF_LAVORAZIONE_EVO.SCARTI_ACQUISIZIONE) ';
sqlstring:=sqlstring || '                     GROUP BY CODICE_ACQUISIZIONE, CODICE_DTP) scart ';
sqlstring:=sqlstring || '              WHERE     a.CODICE_ACQUISIZIONE = scart.CODICE_ACQUISIZIONE(+) ';
sqlstring:=sqlstring || '                    AND a.CODICE_DTP = scart.CODICE_DTP(+) ';
sqlstring:=sqlstring || '           GROUP BY a.CODICE_ACQUISIZIONE, ';
sqlstring:=sqlstring || '                    a.CODICE_DTP, ';
sqlstring:=sqlstring || '                    Scarti_Acq_OP, ';
sqlstring:=sqlstring || '                    Scarti_Acq_SOL) tot_acq, ';
sqlstring:=sqlstring || '          (  SELECT val.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '                    val.CODICE_DTP, ';
sqlstring:=sqlstring || '                    SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0)) ';
sqlstring:=sqlstring || '                       n_OP_val, ';
sqlstring:=sqlstring || '                    SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0)) ';
sqlstring:=sqlstring || '                       n_SOL_val, ';
sqlstring:=sqlstring || '                    Scarti_Val_OP, ';
sqlstring:=sqlstring || '                    Scarti_Val_SOL ';
sqlstring:=sqlstring || '               FROM RINF_LAVORAZIONE_EVO.OGGETTI_CONTROLLATI val, ';
sqlstring:=sqlstring || '                    (  SELECT CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '                              CODICE_DTP, ';
sqlstring:=sqlstring || '                              SUM ( ';
sqlstring:=sqlstring || '                                 DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0)) ';
sqlstring:=sqlstring || '                                 Scarti_Val_OP, ';
sqlstring:=sqlstring || '                              SUM ( ';
sqlstring:=sqlstring || '                                 DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0)) ';
sqlstring:=sqlstring || '                                 Scarti_Val_SOL ';
sqlstring:=sqlstring || '                         FROM RINF_LAVORAZIONE_EVO.OGGETTI_CONTROLLATI ';
sqlstring:=sqlstring || '                        WHERE CODICE_ESITO = 0 ';
sqlstring:=sqlstring || '                     GROUP BY CODICE_CONTROLLO, CODICE_DTP) noval ';
sqlstring:=sqlstring || '              WHERE     val.CODICE_CONTROLLO = noval.CODICE_CONTROLLO(+) ';
sqlstring:=sqlstring || '                    AND val.CODICE_DTP = noval.CODICE_DTP(+) ';
sqlstring:=sqlstring || '           GROUP BY val.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '                    val.CODICE_DTP, ';
sqlstring:=sqlstring || '                    Scarti_Val_OP, ';
sqlstring:=sqlstring || '                    Scarti_Val_SOL) tot_val, ';
sqlstring:=sqlstring || '          RINF_LAVORAZIONE_EVO.ACQUISIZIONE_DATI acq, ';
sqlstring:=sqlstring || '          RINF_LAVORAZIONE_EVO.CONTROLLO_DATI val ';
sqlstring:=sqlstring || '          WHERE ACQ.CODICE_ACQUISIZIONE = val.CODICE_ACQUISIZIONE ';
sqlstring:=sqlstring || '          AND ACQ.CODICE_ACQUISIZIONE = tot_acq.CODICE_ACQUISIZIONE ';
sqlstring:=sqlstring || '          AND val.CODICE_CONTROLLO = tot_val.CODICE_CONTROLLO ';
sqlstring:=sqlstring || '          AND tot_acq.CODICE_ACQUISIZIONE=val.CODICE_ACQUISIZIONE ';
sqlstring:=sqlstring || '          AND tot_acq.CODICE_DTP=tot_val.CODICE_DTP ';
sqlstring:=sqlstring || '          AND val.CODICE_CONTROLLO = '||p_i_controllo_corrente||' ) val_corr,    ';
sqlstring:=sqlstring || '           (SELECT val.CODICE_CONTROLLO,val.DATA_CONTROLLO, ';
sqlstring:=sqlstring || '   tot_val.CODICE_DTP,n_OP_acq,n_SOL_acq, ';
sqlstring:=sqlstring || '   Scarti_Acq_OP,Scarti_Acq_SOL, ';
sqlstring:=sqlstring || '    n_OP_val,n_SOL_val, ';
sqlstring:=sqlstring || '                    Scarti_Val_OP, ';
sqlstring:=sqlstring || '                    Scarti_Val_SOL ';
sqlstring:=sqlstring || '     FROM (  SELECT a.CODICE_ACQUISIZIONE, ';
sqlstring:=sqlstring || '            a.CODICE_DTP, ';
sqlstring:=sqlstring || '            SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0)) ';
sqlstring:=sqlstring || '               n_OP_acq, ';
sqlstring:=sqlstring || '            SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0)) ';
sqlstring:=sqlstring || '               n_SOL_acq, ';
sqlstring:=sqlstring || '            Scarti_Acq_OP, ';
sqlstring:=sqlstring || '            Scarti_Acq_SOL ';
sqlstring:=sqlstring || '       FROM RINF_LAVORAZIONE_EVO.OGGETTI_ACQUISITI a, ';
sqlstring:=sqlstring || '            (  SELECT CODICE_ACQUISIZIONE, ';
sqlstring:=sqlstring || '                      CODICE_DTP, ';
sqlstring:=sqlstring || '                      SUM ( ';
sqlstring:=sqlstring || '                         DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0)) ';
sqlstring:=sqlstring || '                         Scarti_Acq_OP, ';
sqlstring:=sqlstring || '                      SUM ( ';
sqlstring:=sqlstring || '                         DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0)) ';
sqlstring:=sqlstring || '                         Scarti_Acq_SOL ';
sqlstring:=sqlstring || '                 FROM (SELECT DISTINCT ';
sqlstring:=sqlstring || '                              CODICE_ACQUISIZIONE, CODICE_SOL_PO, CODICE_DTP ';
sqlstring:=sqlstring || '                         FROM RINF_LAVORAZIONE_EVO.SCARTI_ACQUISIZIONE) ';
sqlstring:=sqlstring || '             GROUP BY CODICE_ACQUISIZIONE, CODICE_DTP) scart ';
sqlstring:=sqlstring || '      WHERE     a.CODICE_ACQUISIZIONE = scart.CODICE_ACQUISIZIONE(+) ';
sqlstring:=sqlstring || '            AND a.CODICE_DTP = scart.CODICE_DTP(+) ';
sqlstring:=sqlstring || '   GROUP BY a.CODICE_ACQUISIZIONE, ';
sqlstring:=sqlstring || '            a.CODICE_DTP, ';
sqlstring:=sqlstring || '            Scarti_Acq_OP, ';
sqlstring:=sqlstring || '            Scarti_Acq_SOL) tot_acq, ';
sqlstring:=sqlstring || '  (  SELECT val.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '          val.CODICE_DTP, ';
sqlstring:=sqlstring || '          SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0)) ';
sqlstring:=sqlstring || '             n_OP_val, ';
sqlstring:=sqlstring || '          SUM (DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0)) ';
sqlstring:=sqlstring || '             n_SOL_val, ';
sqlstring:=sqlstring || '          Scarti_Val_OP, ';
sqlstring:=sqlstring || '          Scarti_Val_SOL ';
sqlstring:=sqlstring || '     FROM RINF_LAVORAZIONE_EVO.OGGETTI_CONTROLLATI val, ';
sqlstring:=sqlstring || '          (  SELECT CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '                    CODICE_DTP, ';
sqlstring:=sqlstring || '                    SUM ( ';
sqlstring:=sqlstring || '                       DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''LO'', 1, 0)) ';
sqlstring:=sqlstring || '                       Scarti_Val_OP, ';
sqlstring:=sqlstring || '                    SUM ( ';
sqlstring:=sqlstring || '                       DECODE (SUBSTR (CODICE_SOL_PO, 1, 2), ''TR'', 1, 0)) ';
sqlstring:=sqlstring || '                       Scarti_Val_SOL ';
sqlstring:=sqlstring || '               FROM RINF_LAVORAZIONE_EVO.OGGETTI_CONTROLLATI ';
sqlstring:=sqlstring || '              WHERE CODICE_ESITO = 0 ';
sqlstring:=sqlstring || '           GROUP BY CODICE_CONTROLLO, CODICE_DTP) noval ';
sqlstring:=sqlstring || '    WHERE     val.CODICE_CONTROLLO = noval.CODICE_CONTROLLO(+) ';
sqlstring:=sqlstring || '          AND val.CODICE_DTP = noval.CODICE_DTP(+) ';
sqlstring:=sqlstring || '  GROUP BY val.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '  val.CODICE_DTP, ';
sqlstring:=sqlstring || '  Scarti_Val_OP, ';
sqlstring:=sqlstring || '  Scarti_Val_SOL) tot_val, ';
sqlstring:=sqlstring || '  RINF_LAVORAZIONE_EVO.ACQUISIZIONE_DATI acq, ';
sqlstring:=sqlstring || '  RINF_LAVORAZIONE_EVO.CONTROLLO_DATI val ';
sqlstring:=sqlstring || '  WHERE ACQ.CODICE_ACQUISIZIONE = val.CODICE_ACQUISIZIONE ';
sqlstring:=sqlstring || '  AND ACQ.CODICE_ACQUISIZIONE = tot_acq.CODICE_ACQUISIZIONE ';
sqlstring:=sqlstring || '  AND val.CODICE_CONTROLLO = tot_val.CODICE_CONTROLLO ';
sqlstring:=sqlstring || '  AND tot_acq.CODICE_ACQUISIZIONE=val.CODICE_ACQUISIZIONE ';
sqlstring:=sqlstring || '  AND tot_acq.CODICE_DTP=tot_val.CODICE_DTP ';
sqlstring:=sqlstring || '  AND val.CODICE_CONTROLLO = '||p_i_controllo_precedente|| ') val_prec ';
sqlstring:=sqlstring || '  where val_corr.CODICE_DTP=val_prec.CODICE_DTP ';
sqlstring:=sqlstring || '  ORDER BY 1,2 ';


--DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetVarScartiAcquisValidazione ;

--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetVariazioniOggettiValid  (p_i_controllo_corrente NUMBER, p_i_controllo_precedente NUMBER, p_cursor OUT empcur) IS
--REPORT 3.3.7

sqlstring VARCHAR2(32767);

BEGIN

sqlstring:= 'Select tot_val_corr.codice_controllo, ';
sqlstring:=sqlstring || ' to_char(tot_val_corr.data_controllo,''DD/MM/YY HH:MI:SS'') data_controllo,  ';
sqlstring:=sqlstring || '  tot_val_corr.codice_dtp, ';
sqlstring:=sqlstring || '  tot_val_corr.tipo_oggetto, ';
sqlstring:=sqlstring || '  tot_val_corr.n_oggetti_controllati, ';
sqlstring:=sqlstring || '  nvl(tot_scar_corr.n_oggetti_scartati,0) n_oggetti_scartati, ';
sqlstring:=sqlstring || '  tot_val_prec.codice_controllo controllo_precedente, ';
sqlstring:=sqlstring || ' to_char(tot_val_prec.data_controllo,''DD/MM/YY HH:MI:SS'') data_controllo_prec,  ';
sqlstring:=sqlstring || '  tot_val_corr.n_oggetti_controllati-tot_val_prec.n_oggetti_controllati delta_oggetti_controllati, ';
sqlstring:=sqlstring || '  NVL(tot_scar_corr.n_oggetti_scartati,0)-NVL(tot_scar_prec.n_oggetti_scartati,0) delta_oggetti_scartati ';
sqlstring:=sqlstring || '  FROM ';
sqlstring:=sqlstring || '  (SELECT ';
sqlstring:=sqlstring || '     c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '     DATA_CONTROLLO, ';
sqlstring:=sqlstring || '     CODICE_DTP, ';
sqlstring:=sqlstring || '      CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '     COUNT(DISTINCT SEDE_TECNICA) n_oggetti_controllati ';
sqlstring:=sqlstring || '     FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '     RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '     where d.codice_controllo= '||p_i_controllo_corrente;
sqlstring:=sqlstring || '     and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '     GROUP BY c.CODICE_CONTROLLO, DATA_CONTROLLO,CODICE_DTP,    ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END ) tot_val_corr,    ';
sqlstring:=sqlstring || '      ';
sqlstring:=sqlstring || '     (SELECT ';
sqlstring:=sqlstring || '     CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '     CODICE_DTP, ';
sqlstring:=sqlstring || '      CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '     COUNT(DISTINCT SEDE_TECNICA) n_oggetti_scartati ';
sqlstring:=sqlstring || '     FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d ';
sqlstring:=sqlstring || '     where codice_controllo= '||p_i_controllo_corrente;
sqlstring:=sqlstring || '     and codice_esito=0 ';
sqlstring:=sqlstring || '     GROUP BY CODICE_CONTROLLO, CODICE_DTP,    ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END ) tot_scar_corr, ';
sqlstring:=sqlstring || '     (SELECT ';
sqlstring:=sqlstring || '     c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '     DATA_CONTROLLO, ';
sqlstring:=sqlstring || '     CODICE_DTP, ';
sqlstring:=sqlstring || '      CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '     COUNT(DISTINCT SEDE_TECNICA) n_oggetti_controllati ';
sqlstring:=sqlstring || '     FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '     RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '     where d.codice_controllo= '||p_i_controllo_precedente;
sqlstring:=sqlstring || '     and c.CODICE_CONTROLLO=d.CODICE_CONTROLLO ';
sqlstring:=sqlstring || '     GROUP BY c.CODICE_CONTROLLO, DATA_CONTROLLO,CODICE_DTP,    ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END ) tot_val_prec,   ';
sqlstring:=sqlstring || '      ';
sqlstring:=sqlstring || '     (SELECT ';
sqlstring:=sqlstring || '     CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '     CODICE_DTP, ';
sqlstring:=sqlstring || '      CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '     COUNT(DISTINCT SEDE_TECNICA) n_oggetti_scartati ';
sqlstring:=sqlstring || '     FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d ';
sqlstring:=sqlstring || '     where codice_controllo= '||p_i_controllo_precedente;
sqlstring:=sqlstring || '     and codice_esito=0 ';
sqlstring:=sqlstring || '     GROUP BY CODICE_CONTROLLO, CODICE_DTP,    ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END ) tot_scar_prec ';
sqlstring:=sqlstring || '     where ';
sqlstring:=sqlstring || '    tot_val_corr.CODICE_DTP=tot_scar_corr.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '     tot_val_corr.TIPO_OGGETTO=tot_scar_corr.TIPO_OGGETTO (+) and  ';
sqlstring:=sqlstring || '     tot_val_corr.CODICE_DTP=tot_val_prec.CODICE_DTP  and ';
sqlstring:=sqlstring || '     tot_val_corr.TIPO_OGGETTO=tot_val_prec.TIPO_OGGETTO  and ';
sqlstring:=sqlstring || '     tot_val_prec.CODICE_DTP=tot_scar_prec.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '     tot_val_prec.TIPO_OGGETTO=tot_scar_prec.TIPO_OGGETTO (+)  ';
sqlstring:=sqlstring || '     order by 3,4 ';

--DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetVariazioniOggettiValid ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetVariazOggettiErroriValid  (p_i_controllo_corrente NUMBER, p_i_controllo_precedente NUMBER, p_cursor OUT empcur) IS
--REPORT 3.3.8

sqlstring VARCHAR2(32767);

BEGIN

sqlstring:=' Select tot_val_corr.codice_controllo, ';
sqlstring:=sqlstring || ' to_char(tot_val_corr.data_controllo,''DD/MM/YY HH:MI:SS'') data_controllo,  ';
sqlstring:=sqlstring || ' tot_val_corr.codice_dtp, ';
sqlstring:=sqlstring || ' tot_val_corr.tipo_oggetto, ';
sqlstring:=sqlstring || ' tot_val_corr.n_oggetti_controllati, ';
sqlstring:=sqlstring || ' tot_val_corr.n_oggetti_controllati-NVL(tot_scar_corr.n_oggetti_scartati,0) n_corretti, ';
sqlstring:=sqlstring || ' NVL(tot_scar_corr.n_oggetti_scartati,0) n_oggetti_errore, ';
sqlstring:=sqlstring || ' nvl(errori_inf.n_errori_inf,NVL(tot_scar_corr.n_oggetti_scartati,0)) N_ERRORI_INF, ';
sqlstring:=sqlstring || ' case when tot_val_corr.TIPO_OGGETTO=''BINARI_CORSA_SOL'' then nvl(errori_ene.n_errori_ene,0) ';
sqlstring:=sqlstring || ' else errori_ene.n_errori_ene ';
sqlstring:=sqlstring || ' end n_errori_ene, ';
sqlstring:=sqlstring || ' case when tot_val_corr.TIPO_OGGETTO=''BINARI_CORSA_SOL'' then nvl(errori_ccs.n_errori_ccs,0) ';
sqlstring:=sqlstring || ' else errori_ccs.n_errori_ccs ';
sqlstring:=sqlstring || ' end n_errori_ccs, ';
sqlstring:=sqlstring || ' tot_val_corr.n_oggetti_controllati-NVL(tot_area_contr_corr.n_oggetti_validati,0) n_oggetti_validati, ';
sqlstring:=sqlstring || ' tot_val_prec.codice_controllo controllo_precedente, ';
sqlstring:=sqlstring || ' to_char(tot_val_prec.data_controllo,''DD/MM/YY HH:MI:SS'') data_controllo_prec,  ';
sqlstring:=sqlstring || ' tot_val_corr.n_oggetti_controllati-tot_val_prec.n_oggetti_controllati delta_oggetti_controllati, ';
sqlstring:=sqlstring || ' NVL(tot_scar_corr.n_oggetti_scartati,0)-NVL(tot_scar_prec.n_oggetti_scartati,0) delta_oggetti_errati, ';
sqlstring:=sqlstring || ' (tot_val_corr.n_oggetti_controllati-NVL(tot_area_contr_corr.n_oggetti_validati,0))-(tot_val_prec.n_oggetti_controllati-NVL(tot_area_contr_prec.n_oggetti_validati,0)) delta_oggetti_validati ';
sqlstring:=sqlstring || ' FROM ';
sqlstring:=sqlstring || ' (SELECT ';
sqlstring:=sqlstring || '    c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '    DATA_CONTROLLO, ';
sqlstring:=sqlstring || '    CODICE_DTP, ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '    END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '    COUNT(DISTINCT SEDE_TECNICA) n_oggetti_controllati ';
sqlstring:=sqlstring || '    FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '    RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '    where d.codice_controllo= '||p_i_controllo_corrente;
sqlstring:=sqlstring || '    and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '    GROUP BY c.CODICE_CONTROLLO, DATA_CONTROLLO,CODICE_DTP,    ';
sqlstring:=sqlstring || '    CASE  ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '    END ) tot_val_corr,    ';
sqlstring:=sqlstring || '    (SELECT ';
sqlstring:=sqlstring || '    c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '    CODICE_DTP, ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '    END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '    COUNT(DISTINCT SEDE_TECNICA) n_oggetti_validati ';
sqlstring:=sqlstring || '    FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '    RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '    where d.codice_controllo= '||p_i_controllo_corrente;
sqlstring:=sqlstring || '    and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '    and codice_esito=0 ';
sqlstring:=sqlstring || '    GROUP BY c.CODICE_CONTROLLO, DATA_CONTROLLO,CODICE_DTP,    ';
sqlstring:=sqlstring || '    CASE  ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '    END ) tot_area_contr_corr,  ';
sqlstring:=sqlstring || '    (SELECT ';
sqlstring:=sqlstring || '    CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '    CODICE_DTP, ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '    END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '    COUNT(DISTINCT SEDE_TECNICA) n_oggetti_scartati ';
sqlstring:=sqlstring || '    FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d ';
sqlstring:=sqlstring || '    where codice_controllo= '||p_i_controllo_corrente;
sqlstring:=sqlstring || '    and ESITO_CONTROLLO=0 ';
sqlstring:=sqlstring || '    GROUP BY CODICE_CONTROLLO, CODICE_DTP,    ';
sqlstring:=sqlstring || '    CASE  ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '    END ) tot_scar_corr, ';
sqlstring:=sqlstring || '    (SELECT ';
sqlstring:=sqlstring || '    c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '    DATA_CONTROLLO, ';
sqlstring:=sqlstring || '    CODICE_DTP, ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '    END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '    COUNT(DISTINCT SEDE_TECNICA) n_oggetti_controllati ';
sqlstring:=sqlstring || '    FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '    RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '    where d.codice_controllo= '||p_i_controllo_precedente;
sqlstring:=sqlstring || '    and c.CODICE_CONTROLLO=d.CODICE_CONTROLLO ';
sqlstring:=sqlstring || '    GROUP BY c.CODICE_CONTROLLO, DATA_CONTROLLO,CODICE_DTP,    ';
sqlstring:=sqlstring || '    CASE  ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '    END ) tot_val_prec,   ';
sqlstring:=sqlstring || '     (SELECT ';
sqlstring:=sqlstring || '    c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '    CODICE_DTP, ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '    END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '    COUNT(DISTINCT SEDE_TECNICA) n_oggetti_validati ';
sqlstring:=sqlstring || '    FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '    RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '    where d.codice_controllo= '||p_i_controllo_precedente;
sqlstring:=sqlstring || '    and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '    and codice_esito=0 ';
sqlstring:=sqlstring || '    GROUP BY c.CODICE_CONTROLLO, DATA_CONTROLLO,CODICE_DTP,    ';
sqlstring:=sqlstring || '    CASE  ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '    END ) tot_area_contr_prec,  ';
sqlstring:=sqlstring || '     ';
sqlstring:=sqlstring || '    (SELECT ';
sqlstring:=sqlstring || '    CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '    CODICE_DTP, ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '    END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '    COUNT(DISTINCT SEDE_TECNICA) n_oggetti_scartati ';
sqlstring:=sqlstring || '    FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d ';
sqlstring:=sqlstring || '    where codice_controllo= '||p_i_controllo_precedente;
sqlstring:=sqlstring || '    and ESITO_CONTROLLO=0 ';
sqlstring:=sqlstring || '    GROUP BY CODICE_CONTROLLO, CODICE_DTP,    ';
sqlstring:=sqlstring || '    CASE  ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '    ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '    END ) tot_scar_prec, ';
sqlstring:=sqlstring || '       (SELECT ';
sqlstring:=sqlstring || '    c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '    CODICE_DTP, ';
sqlstring:=sqlstring || '      ''BINARI_CORSA_SOL'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '    COUNT(DISTINCT SEDE_TECNICA) n_errori_inf ';
sqlstring:=sqlstring || '    FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '    RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '    where d.codice_controllo= '||p_i_controllo_corrente;
sqlstring:=sqlstring || '    AND d.ESITO_CONTROLLO=0 ';
sqlstring:=sqlstring || '    AND NUMERO_PARAMETRO like ''1.1.1.1%'' ';
sqlstring:=sqlstring || '    And NUMERO_PARAMETRO NOT like ''1.1.1.1.8%'' ';
sqlstring:=sqlstring || '    and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '    GROUP BY c.CODICE_CONTROLLO, CODICE_DTP  ';
sqlstring:=sqlstring || '     ) errori_inf, ';
sqlstring:=sqlstring || '    (SELECT ';
sqlstring:=sqlstring || '    c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '    CODICE_DTP, ';
sqlstring:=sqlstring || '      ''BINARI_CORSA_SOL'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '    COUNT(DISTINCT SEDE_TECNICA) n_errori_ene ';
sqlstring:=sqlstring || '    FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '    RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '    where d.codice_controllo= '||p_i_controllo_corrente;
sqlstring:=sqlstring || '    AND d.ESITO_CONTROLLO=0 ';
sqlstring:=sqlstring || '    AND NUMERO_PARAMETRO like ''1.1.1.2%'' ';
sqlstring:=sqlstring || '    and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '    GROUP BY c.CODICE_CONTROLLO, CODICE_DTP  ';
sqlstring:=sqlstring || '     ) errori_ene, ';
sqlstring:=sqlstring || '     (SELECT ';
sqlstring:=sqlstring || '    c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '    CODICE_DTP, ';
sqlstring:=sqlstring || '      ''BINARI_CORSA_SOL'' TIPO_OGGETTO, ';
sqlstring:=sqlstring || '    COUNT(DISTINCT SEDE_TECNICA) n_errori_ccs ';
sqlstring:=sqlstring || '    FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '    RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '    where d.codice_controllo= '||p_i_controllo_corrente;
sqlstring:=sqlstring || '    AND d.ESITO_CONTROLLO=0 ';
sqlstring:=sqlstring || '    AND NUMERO_PARAMETRO like ''1.1.1.3%'' ';
sqlstring:=sqlstring || '    and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '    GROUP BY c.CODICE_CONTROLLO, CODICE_DTP  ';
sqlstring:=sqlstring || '     ) errori_ccs ';
sqlstring:=sqlstring || '    where ';
sqlstring:=sqlstring || '   tot_val_corr.CODICE_DTP=tot_scar_corr.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '    tot_val_corr.TIPO_OGGETTO=tot_scar_corr.TIPO_OGGETTO (+) and ';
sqlstring:=sqlstring || '    tot_val_corr.CODICE_DTP=tot_area_contr_corr.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '    tot_val_corr.TIPO_OGGETTO=tot_area_contr_corr.TIPO_OGGETTO (+) and ';
sqlstring:=sqlstring || '    tot_val_corr.CODICE_DTP=errori_inf.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '    tot_val_corr.TIPO_OGGETTO=errori_inf.TIPO_OGGETTO (+) and ';
sqlstring:=sqlstring || '    tot_val_corr.CODICE_DTP=errori_ene.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '    tot_val_corr.TIPO_OGGETTO=errori_ene.TIPO_OGGETTO (+) and  ';
sqlstring:=sqlstring || '    tot_val_corr.CODICE_DTP=errori_ccs.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '    tot_val_corr.TIPO_OGGETTO=errori_ccs.TIPO_OGGETTO (+) and  ';
sqlstring:=sqlstring || '    tot_val_corr.CODICE_DTP=tot_val_prec.CODICE_DTP  and ';
sqlstring:=sqlstring || '    tot_val_corr.TIPO_OGGETTO=tot_val_prec.TIPO_OGGETTO  and ';
sqlstring:=sqlstring || '    tot_val_prec.CODICE_DTP=tot_scar_prec.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '    tot_val_prec.TIPO_OGGETTO=tot_scar_prec.TIPO_OGGETTO (+) and ';
sqlstring:=sqlstring || '    tot_val_prec.CODICE_DTP=tot_area_contr_prec.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '    tot_val_prec.TIPO_OGGETTO=tot_area_contr_prec.TIPO_OGGETTO (+)  ';
sqlstring:=sqlstring || '    order by 3,4 ';

--DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetVariazOggettiErroriValid ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetVarErroriValidazioneNYA  (p_i_controllo_corrente NUMBER, p_i_controllo_precedente NUMBER, p_cursor OUT empcur) IS
--REPORT 3.3.9

sqlstring VARCHAR2(32767);

BEGIN

sqlstring:='  Select tot_controllati.codice_controllo codice_controllo_corr, ';
sqlstring:=sqlstring || ' to_char(tot_controllati.data_controllo,''DD/MM/YY HH:MI:SS'') data_controllo_corr,  ';
sqlstring:=sqlstring || '  tot_controllati.codice_dtp, ';
sqlstring:=sqlstring || '  tot_controllati.tipo_oggetto, ';
sqlstring:=sqlstring || '  tot_controllati.n_oggetti_controllati, ';
sqlstring:=sqlstring || '  elenco_dtp.n_parametri*tot_controllati.n_oggetti_controllati tot_parametri, ';
sqlstring:=sqlstring || '  tot_nya.n_nya , ';
sqlstring:=sqlstring || '  round( tot_nya.n_nya/(elenco_dtp.n_parametri*tot_controllati.n_oggetti_controllati)*100,3)  perc_nya, ';
sqlstring:=sqlstring || '  tot_controllati_prec.codice_controllo controllo_prec, ';
sqlstring:=sqlstring || ' to_char(tot_controllati_prec.data_controllo,''DD/MM/YY HH:MI:SS'') data_controllo_prec,  ';
sqlstring:=sqlstring || '  (tot_controllati.n_oggetti_controllati)- (tot_controllati_prec.n_oggetti_controllati  )     delta_tot_controllati,                                      ';
sqlstring:=sqlstring || '  (elenco_dtp.n_parametri*tot_controllati.n_oggetti_controllati )              - (elenco_dtp.n_parametri*tot_controllati_prec.n_oggetti_controllati  )  delta_tot_parametri,     ';
sqlstring:=sqlstring || '  tot_nya.n_nya                                                                           - nvl((tot_nya_prec.n_nya),0) delta_nya,                                                                    ';
sqlstring:=sqlstring || '  round(  (tot_nya.n_nya/(elenco_dtp.n_parametri*tot_controllati.n_oggetti_controllati)*100)        - nvl((tot_nya_prec.n_nya/(elenco_dtp.n_parametri*tot_controllati_prec.n_oggetti_controllati)*100),0 ),3) delta_perc_nya, ';
sqlstring:=sqlstring || '  nvl(tot_errori.n_errori,0) n_errori_corr, ';
sqlstring:=sqlstring || '  nvl(tot_errori_prec.n_errori,0)  n_errori_prec,  ';
sqlstring:=sqlstring || '  nvl((tot_errori.n_errori                                                                     - (tot_errori_prec.n_errori )),0) delta_tot_errori  ';
sqlstring:=sqlstring || '                   ';
sqlstring:=sqlstring || '  FROM ';
sqlstring:=sqlstring || '  (SELECT ';
sqlstring:=sqlstring || '     c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '     DATA_CONTROLLO, ';
sqlstring:=sqlstring || '     CODICE_DTP, ';
sqlstring:=sqlstring || '      CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '     COUNT(DISTINCT SEDE_TECNICA) n_oggetti_controllati ';
sqlstring:=sqlstring || '     FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '     RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '     where d.codice_controllo= '||p_i_controllo_corrente;
sqlstring:=sqlstring || '     and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '     GROUP BY c.CODICE_CONTROLLO, DATA_CONTROLLO,CODICE_DTP,    ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END ) tot_controllati,    ';
sqlstring:=sqlstring || '     (SELECT ';
sqlstring:=sqlstring || '     c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '     CODICE_DTP, ';
sqlstring:=sqlstring || '      CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '     COUNT( SEDE_TECNICA) n_nya ';
sqlstring:=sqlstring || '     FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '     RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '     where d.codice_controllo= '||p_i_controllo_corrente;
sqlstring:=sqlstring || '     and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '     and codice_esito=1 and esito_controllo=0 ';
sqlstring:=sqlstring || '     GROUP BY c.CODICE_CONTROLLO, DATA_CONTROLLO,CODICE_DTP,    ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END ) tot_nya, ';
sqlstring:=sqlstring || '     (SELECT ';
sqlstring:=sqlstring || '     c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '     CODICE_DTP, ';
sqlstring:=sqlstring || '      CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '     COUNT( SEDE_TECNICA) n_errori ';
sqlstring:=sqlstring || '     FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '     RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '     where d.codice_controllo= '||p_i_controllo_corrente;
sqlstring:=sqlstring || '     and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '     and codice_esito=0  ';
sqlstring:=sqlstring || '     GROUP BY c.CODICE_CONTROLLO, DATA_CONTROLLO,CODICE_DTP,    ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END ) tot_errori, ';
sqlstring:=sqlstring || '     (SELECT ';
sqlstring:=sqlstring || '     c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '     DATA_CONTROLLO, ';
sqlstring:=sqlstring || '     CODICE_DTP, ';
sqlstring:=sqlstring || '      CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '     COUNT(DISTINCT SEDE_TECNICA) n_oggetti_controllati ';
sqlstring:=sqlstring || '     FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '     RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '     where d.codice_controllo= '||p_i_controllo_precedente;
sqlstring:=sqlstring || '     and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '     GROUP BY c.CODICE_CONTROLLO, DATA_CONTROLLO,CODICE_DTP,    ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END ) tot_controllati_prec,    ';
sqlstring:=sqlstring || '     (SELECT ';
sqlstring:=sqlstring || '     c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '     CODICE_DTP, ';
sqlstring:=sqlstring || '      CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '     COUNT( SEDE_TECNICA) n_nya ';
sqlstring:=sqlstring || '     FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '     RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '     where d.codice_controllo= '||p_i_controllo_precedente;
sqlstring:=sqlstring || '     and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '     and codice_esito=1 and esito_controllo=0 ';
sqlstring:=sqlstring || '     GROUP BY c.CODICE_CONTROLLO, DATA_CONTROLLO,CODICE_DTP,    ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END ) tot_nya_prec, ';
sqlstring:=sqlstring || '     (SELECT ';
sqlstring:=sqlstring || '     c.CODICE_CONTROLLO, ';
sqlstring:=sqlstring || '     CODICE_DTP, ';
sqlstring:=sqlstring || '      CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END TIPO_OGGETTO, ';
sqlstring:=sqlstring || '     COUNT( SEDE_TECNICA) n_errori ';
sqlstring:=sqlstring || '     FROM RINF_LAVORAZIONE_EVO.RAPPORTO_CONTROLLI d, ';
sqlstring:=sqlstring || '     RINF_LAVORAZIONE_EVO.CONTROLLO_DATI c ';
sqlstring:=sqlstring || '     where d.codice_controllo= '||p_i_controllo_precedente;
sqlstring:=sqlstring || '     and d.codice_controllo=c.codice_controllo ';
sqlstring:=sqlstring || '     and codice_esito=0  ';
sqlstring:=sqlstring || '     GROUP BY c.CODICE_CONTROLLO, DATA_CONTROLLO,CODICE_DTP,    ';
sqlstring:=sqlstring || '     CASE  ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.0'' THEN ''SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,5)=''1.1.1'' and substr(NUMERO_PARAMETRO,1,9)<>''1.1.1.1.8'' THEN ''BINARI_CORSA_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.1.1.1.8''THEN ''GALLERIE_BINARI_SOL'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.0.0'' THEN ''OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.1.0'' and substr(NUMERO_PARAMETRO,1,9) NOT IN (''1.2.1.0.5'' ,''1.2.1.0.6'') THEN ''BINARI_CORSA_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.5''THEN ''GALLERIE_BINARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.1.0.6''THEN ''MARCIAPIEDI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,7)=''1.2.2.0'' and substr(NUMERO_PARAMETRO,1,9)<>''1.2.2.0.5'' THEN ''BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     WHEN substr(NUMERO_PARAMETRO,1,9)=''1.2.2.0.5''THEN ''GALLERIE_BINARI_SECONDARI_OP'' ';
sqlstring:=sqlstring || '     ELSE NUMERO_PARAMETRO ';
sqlstring:=sqlstring || '     END ) tot_errori_prec, ';
sqlstring:=sqlstring || '     (select codice_dtp, ''SOL'' TIPO_OGGETTO,6 n_parametri ';
sqlstring:=sqlstring || '     from RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '     where codice_dtp<>''-1'' ';
sqlstring:=sqlstring || '     union ';
sqlstring:=sqlstring || '     select codice_dtp, ''BINARI_CORSA_SOL'' TIPO_OGGETTO,99 ';
sqlstring:=sqlstring || '     from RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '     where codice_dtp<>''-1'' ';
sqlstring:=sqlstring || '      union ';
sqlstring:=sqlstring || '     select codice_dtp, ''GALLERIE_BINARI_SOL'' TIPO_OGGETTO,99 ';
sqlstring:=sqlstring || '     from RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '     where codice_dtp<>''-1'' ';
sqlstring:=sqlstring || '         union ';
sqlstring:=sqlstring || '     select codice_dtp, ''OP'' TIPO_OGGETTO,6 ';
sqlstring:=sqlstring || '     from RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '     where codice_dtp<>''-1'' ';
sqlstring:=sqlstring || '         union ';
sqlstring:=sqlstring || '     select codice_dtp, ''BINARI_CORSA_OP'' TIPO_OGGETTO,11 ';
sqlstring:=sqlstring || '     from RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '     where codice_dtp<>''-1'' ';
sqlstring:=sqlstring || '           union ';
sqlstring:=sqlstring || '     select codice_dtp, ''GALLERIE_BINARI_OP'' TIPO_OGGETTO,8 ';
sqlstring:=sqlstring || '     from RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '     where codice_dtp<>''-1'' ';
sqlstring:=sqlstring || '          union ';
sqlstring:=sqlstring || '     select codice_dtp, ''MARCIAPIEDI_OP'' TIPO_OGGETTO,7 ';
sqlstring:=sqlstring || '     from RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '     where codice_dtp<>''-1'' ';
sqlstring:=sqlstring || '           union ';
sqlstring:=sqlstring || '     select codice_dtp, ''BINARI_SECONDARI_OP'' TIPO_OGGETTO,15 ';
sqlstring:=sqlstring || '     from RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '     where codice_dtp<>''-1'' ';
sqlstring:=sqlstring || '         union ';
sqlstring:=sqlstring || '     select codice_dtp, ''GALLERIE_BINARI_SECONDARI_OP'' TIPO_OGGETTO,8 ';
sqlstring:=sqlstring || '     from RINF_ANAGRAFICHE_EVO.ANAG_DTP ';
sqlstring:=sqlstring || '     where codice_dtp<>''-1'') elenco_dtp ';
sqlstring:=sqlstring || '     where ';
sqlstring:=sqlstring || '    tot_controllati.CODICE_DTP=tot_nya.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '     tot_controllati.TIPO_OGGETTO=tot_nya.TIPO_OGGETTO (+) and ';
sqlstring:=sqlstring || '     tot_controllati.CODICE_DTP=tot_errori.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '     tot_controllati.TIPO_OGGETTO=tot_errori.TIPO_OGGETTO (+) and ';
sqlstring:=sqlstring || '     tot_controllati.CODICE_DTP=elenco_dtp.CODICE_DTP  and ';
sqlstring:=sqlstring || '     tot_controllati.TIPO_OGGETTO=elenco_dtp.TIPO_OGGETTO and ';
sqlstring:=sqlstring || '     tot_controllati.CODICE_DTP=tot_nya_prec.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '     tot_controllati.TIPO_OGGETTO=tot_nya_prec.TIPO_OGGETTO (+) and ';
sqlstring:=sqlstring || '     tot_controllati.CODICE_DTP=tot_errori_prec.CODICE_DTP (+) and ';
sqlstring:=sqlstring || '     tot_controllati.TIPO_OGGETTO=tot_errori_prec.TIPO_OGGETTO (+) and ';
sqlstring:=sqlstring || '     tot_controllati_prec.CODICE_DTP=elenco_dtp.CODICE_DTP  and ';
sqlstring:=sqlstring || '     tot_controllati_prec.TIPO_OGGETTO=elenco_dtp.TIPO_OGGETTO  ';


--DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetVarErroriValidazioneNYA ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--

PROCEDURE GetProfilazioneUtenze  (p_cursor OUT empcur) IS
--REPORT 3.4.1

sqlstring VARCHAR2(32767);

BEGIN

--sqlstring:=sqlstring || ' SELECT ' ;
----sqlstring:=sqlstring || ' utenti.ID_UTENTE identificativo_utenza, ';      --collassate in un'unica colonna
----sqlstring:=sqlstring || ' utenti.CODICE_UTENTE codice_utenza,    ';
--sqlstring:=sqlstring || ' utenti.CODICE_UTENTE identificativo_utenza,    ';
--sqlstring:=sqlstring || ' COGNOME,    ';
--sqlstring:=sqlstring || ' NOME, ';
--sqlstring:=sqlstring || ' MATRICOLA, ';
--sqlstring:=sqlstring || ' E_MAIL, ';
--sqlstring:=sqlstring || ' decode(FLAG_MAIL,''0'', ''NO'', ''SI'') notifiche_attivate, ';
--sqlstring:=sqlstring || ' anagruoli.DESCRIZIONE ruolo,  ';
--sqlstring:=sqlstring || ' anartipodep.area area, ';
--sqlstring:=sqlstring || ' decode(anartipodep.DESCRIZIONE,''NON APPLICABILE'','''',anartipodep.DESCRIZIONE) tipologia,  ';
--sqlstring:=sqlstring || ' decode(ruoli.CODICE_DTP, ''-1'','''', ruoli.CODICE_DTP) DTP,  ';
--sqlstring:=sqlstring || ' decode(ruoli.CODICE_UT, ''-1'','''', ruoli.CODICE_UT) UT, ';
--sqlstring:=sqlstring || ' substr(decode(anartipodep.sigla_tipo_depositario,''NA'','''',anartipodep.sigla_tipo_depositario),9) parametri_assegnati  ';
--sqlstring:=sqlstring || ' FROM RINF_SICUREZZA_EVO.ANAG_UTENTE utenti, ';
--sqlstring:=sqlstring || ' RINF_SICUREZZA_EVO.UTENTE_RUOLI ruoli, ';
--sqlstring:=sqlstring || ' RINF_SICUREZZA_EVO.ANAG_RUOLO anagruoli, ';
--sqlstring:=sqlstring || ' RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO anartipodep ';
--sqlstring:=sqlstring || ' where utenti.ID_UTENTE=RUOLI.ID_UTENTE(+) ';
--sqlstring:=sqlstring || ' and ANAGRUOLI.CODICE_RUOLO=RUOLI.CODICE_RUOLO ';
--sqlstring:=sqlstring || ' and ANARTIPODEP.CODICE_TIPO_DEPOSITARIO=RUOLI.CODICE_TIPO_DEPOSITARIO ';
--sqlstring:=sqlstring || ' and ANAGRUOLI.CODICE_RUOLO not in (8,1000) ';
--sqlstring:=sqlstring || ' order by COGNOME,NOME ';
--
--DBMS_OUTPUT.PUT_LINE(sqlstring);
--OPEN p_cursor FOR sqlstring;

--17/02/2017 Inserito lo storico degli utenti e dei ruoli

OPEN p_cursor FOR
  SELECT CODICE_UTENTE identificativo_utenza,
         COGNOME,
         NOME,
         MATRICOLA,
         E_MAIL,
         DECODE (FLAG_MAIL, '0', 'NO', 'SI') notifiche_attivate,
         DESCRIZIONE ruolo,
         area COMPETENZA,
         DECODE (DESCRIZIONE, 'NON APPLICABILE', '', DESCRIZIONE) tipologia,
         DECODE (CODICE_DTP, '-1', '', CODICE_DTP) DTP,
         DECODE (CODICE_UT, '-1', '', CODICE_UT) UT,
         SUBSTR (
            DECODE (sigla_tipo_depositario, 'NA', '', sigla_tipo_depositario),
            9)
            parametri_assegnati,
         STATO_RUOLO,
         TO_CHAR (DATA_CREAZIONE, 'DD/MM/YYYY') DATA_CREAZIONE,
         TO_CHAR (DATA_MODIFICA, 'DD/MM/YYYY') DATA_MODIFICA,
         TO_CHAR (DATA_SCADENZA, 'DD/MM/YYYY') DATA_SCADENZA
    FROM RINF_SICUREZZA_EVO.V_UTENTE_RUOLO_H
   WHERE CODICE_RUOLO NOT IN (8, 1000)
ORDER BY NVL (DATA_SCADENZA, TO_DATE ('01/01/1900', 'DD/MM/YYYY')),
         COGNOME,
         NOME;
END GetProfilazioneUtenze ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetAccessi30gg  (p_cursor OUT empcur) IS
--REPORT 3.4.2
/* Procedura modificata in data 24/09/2018 per aggiungere il campo in output ACCESSI_SITO_PUBBLICO valorizzato con il conteggio degli accessi
 registrati in tabella APPL_RINF_EVO.LOG_HISTORY con CODICE_ATTIVITA = 4
 */

sqlstring VARCHAR2(32767);

BEGIN

sqlstring:= 'SELECT TO_CHAR (SYSDATE - 30, ''DD/MM/YYYY'') data_inizio_periodo, ';
sqlstring:=sqlstring || '       TO_CHAR (SYSDATE, ''DD/MM/YYYY'') data_fine_periodo,   ';
sqlstring:=sqlstring || '       giorno,     ';
sqlstring:=sqlstring || '       accessi,  ';
sqlstring:=sqlstring || '       ACCESSI_SITO_PUBBLICO  ';
sqlstring:=sqlstring || 'FROM (  SELECT giorno, accessi, ACCESSI_SITO_PUBBLICO    ';
sqlstring:=sqlstring || '            FROM (  SELECT SUBSTR (TO_CHAR (DATA_ATTIVITA, ''DD/MM/YYYY''), 1, 10)  ';
sqlstring:=sqlstring || '                              giorno,   ';
sqlstring:=sqlstring || '                           COUNT (*) accessi   ';
sqlstring:=sqlstring || '                      FROM APPL_RINF_EVO.LOG_HISTORY  ';
sqlstring:=sqlstring || '                     WHERE CODICE_ATTIVITA = 1  ';
--
sqlstring:=sqlstring || '                     AND DATA_ATTIVITA <= SYSDATE  ';
sqlstring:=sqlstring || '                     AND DATA_ATTIVITA > SYSDATE - 31 ';
--
sqlstring:=sqlstring || '                  GROUP BY SUBSTR (TO_CHAR (DATA_ATTIVITA, ''DD/MM/YYYY''),  ';
sqlstring:=sqlstring || '                                   1,          ';
sqlstring:=sqlstring || '                                   10)) tabella_data,  ';
--
sqlstring:=sqlstring || ' (  SELECT  SUBSTR (TO_CHAR (DATA_ATTIVITA, ''DD/MM/YYYY''), 1, 10)  giorno1,   ';
sqlstring:=sqlstring || '                           COUNT (*) ACCESSI_SITO_PUBBLICO   ';
sqlstring:=sqlstring || '                      FROM APPL_RINF_EVO.LOG_HISTORY  ';
sqlstring:=sqlstring || '                     WHERE CODICE_ATTIVITA = 4  ';
--
sqlstring:=sqlstring || '                     AND DATA_ATTIVITA <= SYSDATE  ';
sqlstring:=sqlstring || '                     AND DATA_ATTIVITA > SYSDATE - 31 ';
--
sqlstring:=sqlstring || '                  GROUP BY SUBSTR (TO_CHAR (DATA_ATTIVITA, ''DD/MM/YYYY''),  ';
sqlstring:=sqlstring || '                                   1,          ';
sqlstring:=sqlstring || '                                   10)) tabella_data1  ';
--
sqlstring:=sqlstring || 'WHERE TO_DATE (tabella_data.giorno, ''DD/MM/YYYY'') <= SYSDATE    ';
sqlstring:=sqlstring || 'AND TO_DATE (tabella_data.giorno, ''DD/MM/YYYY'') > SYSDATE - 31  ';
--
sqlstring:=sqlstring || 'AND tabella_data1.giorno1 (+) = tabella_data.giorno ';
sqlstring:=sqlstring || 'ORDER BY TO_DATE (tabella_data.giorno, ''DD/MM/YYYY'') DESC)   ';
--DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetAccessi30gg ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetAccessi12mesi  (p_cursor OUT empcur) IS
--REPORT 3.4.3
/* Procedura modificata in data 24/09/2018 per aggiungere il campo in output ACCESSI_SITO_PUBBLICO valorizzato con il conteggio degli accessi
 registrati in tabella APPL_RINF_EVO.LOG_HISTORY con CODICE_ATTIVITA = 4
 */

sqlstring VARCHAR2(32767);

BEGIN

sqlstring:='SELECT TO_CHAR (SYSDATE - 365, ''DD/MM/YYYY'') data_inizio_periodo, ';
sqlstring:=sqlstring || '       TO_CHAR (SYSDATE, ''DD/MM/YYYY'') data_fine_periodo, ';
sqlstring:=sqlstring || '       mese, ';
sqlstring:=sqlstring || '       accessi,  ';
sqlstring:=sqlstring || '       ACCESSI_SITO_PUBBLICO  ';
sqlstring:=sqlstring || 'FROM (  SELECT mese, accessi, ACCESSI_SITO_PUBBLICO    ';
sqlstring:=sqlstring || '            FROM (  SELECT SUBSTR (TO_CHAR (DATA_ATTIVITA, ''MM/YYYY''), 1, 10) ';
sqlstring:=sqlstring || '                              mese, ';
sqlstring:=sqlstring || '                           COUNT (*) accessi ';
sqlstring:=sqlstring || '                      FROM APPL_RINF_EVO.LOG_HISTORY ';
sqlstring:=sqlstring || '                     WHERE CODICE_ATTIVITA = 1 ';
sqlstring:=sqlstring || '                     AND DATA_ATTIVITA <= SYSDATE ';
sqlstring:=sqlstring || '                     AND DATA_ATTIVITA > SYSDATE - 365 ';
sqlstring:=sqlstring || '                  GROUP BY SUBSTR (TO_CHAR (DATA_ATTIVITA, ''MM/YYYY''), ';
sqlstring:=sqlstring || '                                   1, ';
sqlstring:=sqlstring || '                                   10)) tabella_data, ';
sqlstring:=sqlstring || '              (  SELECT SUBSTR (TO_CHAR (DATA_ATTIVITA, ''MM/YYYY''), 1, 10) ';
sqlstring:=sqlstring || '                              mese1, ';
sqlstring:=sqlstring || '                           COUNT (*) ACCESSI_SITO_PUBBLICO ';
sqlstring:=sqlstring || '                      FROM APPL_RINF_EVO.LOG_HISTORY ';
sqlstring:=sqlstring || '                     WHERE CODICE_ATTIVITA = 4 ';
sqlstring:=sqlstring || '                     AND DATA_ATTIVITA <= SYSDATE ';
sqlstring:=sqlstring || '                     AND DATA_ATTIVITA > SYSDATE - 365 ';
sqlstring:=sqlstring || '                  GROUP BY SUBSTR (TO_CHAR (DATA_ATTIVITA, ''MM/YYYY''), ';
sqlstring:=sqlstring || '                                   1, ';
sqlstring:=sqlstring || '                                   10)) tabella_data1 ';
sqlstring:=sqlstring || '           WHERE TO_DATE (tabella_data.mese, ''MM/YYYY'') <= SYSDATE ';
sqlstring:=sqlstring || '           AND TO_DATE (tabella_data.mese, ''MM/YYYY'') > SYSDATE - 365 ';
--
sqlstring:=sqlstring || '           AND tabella_data1.mese1 (+) = tabella_data.mese ';
--
sqlstring:=sqlstring || '        ORDER BY TO_DATE (tabella_data.mese, ''MM/YYYY'') DESC)   ';

--DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetAccessi12mesi ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetElencoAcquisioniRITrasm  (p_cursor OUT empcur) IS
--REPORT 3.5.1

sqlstring VARCHAR2(32767);

BEGIN
sqlstring:=' SELECT ad.FTPS ,';
sqlstring:=sqlstring|| ' ad.CODICE_VERSIONE,  ';
sqlstring:=sqlstring|| ' PROTOCOLLO, ';
sqlstring:=sqlstring || ' to_char(at.DATA_TRASMISSIONE,''DD/MM/YY HH:MI:SS'') DATA_TRASMISSIONE,  ';
sqlstring:=sqlstring || ' to_char(DATA_DOWNLOAD,''DD/MM/YY HH:MI:SS'') DATA_DOWNLOAD,  ';
sqlstring:=sqlstring|| ' CODICE_UTENTE, ';
sqlstring:=sqlstring|| ' DECODE (ESITO,''1'', ''OK'', ''KO'') Esito';
sqlstring:=sqlstring|| ' FROM RINF_PUBBLICATI_EVO.ANAGRAFICA_DOWNLOAD ad,';
sqlstring:=sqlstring|| ' RINF_PUBBLICATI_EVO.ANAGRAFICA_TRASMISSIONI at';
sqlstring:=sqlstring|| ' WHERE AD.CODICE_VERSIONE=AT.CODICE_VERSIONE';
sqlstring:=sqlstring|| ' and CODICE_TRASMISSIONE=1';
sqlstring:=sqlstring|| ' ORDER BY DATA_DOWNLOAD desc';

--DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetElencoAcquisioniRITrasm ;



PROCEDURE GetDichiarazioniEC (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.1

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;

sqlstring:='Select tab_totale.SEDE_TECNICA,  ';       --INSERITA SELECT ESTERNA PER CREARE UNA TABELLA UNICA SU CUI FARE POI LA SOTTOSELEZIONE PER IL ROUTING
sqlstring:=sqlstring|| '     DEFINIZIONE, ';                --in quanto sarebbe troppo oneroso spostare la condizione del routing in ogni union di questa query molto complessa
sqlstring:=sqlstring|| '     CODICE_OGGETTO, ';
sqlstring:=sqlstring|| '     DESCRIZIONE, ';
sqlstring:=sqlstring|| '     PARAMETRO, ';
sqlstring:=sqlstring|| '     DICHIARAZIONE,  ';
sqlstring:=sqlstring|| '     CODICE_DTP, ';
sqlstring:=sqlstring|| '     CODICE_UT, ';
sqlstring:=sqlstring|| '     CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring|| '     FROM ';
sqlstring:=sqlstring|| '     ( ';

sqlstring:=sqlstring|| '     SELECT BCS.SOL_TRACK_1_1_1_0_0_1 "CODICE_OGGETTO",            ';--DICH SOL INF
sqlstring:=sqlstring|| '       BCS.SOL_TRACK_1_1_1_0_0_1_D "DESCRIZIONE",     ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.1.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       SOL_TRACK_1_1_1_1_1_1O2_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (SOL_TRACK_1_1_1_1_1_1O2_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               SOL_TRACK_1_1_1_1_1_1O2) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND DIC.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND DIC.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE=SL.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '       AND BCS.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1(+) ';
sqlstring:=sqlstring|| '       AND BCS.SEDE_TECNICA=SL.SEDE_TECNICA ';
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT DIC.SOL_TRACK_1_1_1_0_0_1 "CODICE_OGGETTO",     '; --DICH ASSENTI
sqlstring:=sqlstring|| '       BCS.SOL_TRACK_1_1_1_0_0_1_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.1.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.BINARI_CORSA_SOL BCS ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '         )  DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE  BCS.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '       AND BCS.SEDE_TECNICA=SL.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND SL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       UNION ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       SELECT BCS.SOL_TRACK_1_1_1_0_0_1 "CODICE_OGGETTO",            ';--DICH SOL ENE
sqlstring:=sqlstring|| '       BCS.SOL_TRACK_1_1_1_0_0_1_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.2.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       SOL_TRACK_1_1_1_2_1_1O2_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (SOL_TRACK_1_1_1_2_1_1O2_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               SOL_TRACK_1_1_1_2_1_1O2) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
sqlstring:=sqlstring|| '       AND BCS.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1(+) ';
sqlstring:=sqlstring|| '       AND SL.SEDE_TECNICA = BCS.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND SL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = DIC.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT DIC.SOL_TRACK_1_1_1_0_0_1 "CODICE_OGGETTO",             ';--DICH ASSENTI
sqlstring:=sqlstring|| '       BCS.SOL_TRACK_1_1_1_0_0_1_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.2.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.BINARI_CORSA_SOL BCS ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '       ) DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE     BCS.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '       AND SL.SEDE_TECNICA = BCS.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND SL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '          ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       UNION ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       SELECT BCS.SOL_TRACK_1_1_1_0_0_1 "CODICE_OGGETTO",            ';--DICH SOL CCS
sqlstring:=sqlstring|| '       BCS.SOL_TRACK_1_1_1_0_0_1_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.3.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       SOL_TRACK_1_1_1_3_1_1_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (SOL_TRACK_1_1_1_3_1_1_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               SOL_TRACK_1_1_1_3_1_1) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = DIC.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '       AND BCS.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1(+) ';
sqlstring:=sqlstring|| '       AND SL.SEDE_TECNICA = BCS.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND SL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT DIC.SOL_TRACK_1_1_1_0_0_1 "CODICE_OGGETTO",                     ';--DICH ASSENTI
sqlstring:=sqlstring|| '       BCS.SOL_TRACK_1_1_1_0_0_1_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.3.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.BINARI_CORSA_SOL BCS ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '   )  DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE     BCS.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '       AND SL.SEDE_TECNICA = BCS.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND SL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       UNION ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       SELECT GAL.SOL_TUNNEL_1_1_1_1_8_2 "CODICE_OGGETTO",            ';--DICH SOL GALLERIA
sqlstring:=sqlstring|| '       GAL.SOL_TUNNEL_1_1_1_1_8_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.1.8.5'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       SOL_TUNNEL_1_1_1_1_8_5O6_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (SOL_TUNNEL_1_1_1_1_8_5O6_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               SOL_TUNNEL_1_1_1_1_8_5O6) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_GALLERIE_BIN_SOL DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.GALLERIE_BINARI_SOL GAL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.REL_GALLERIE_BINARI_SOL REL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND DIC.CODICE_VERSIONE=GAL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE = REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND REL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = SL.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '       AND GAL.SOL_TUNNEL_1_1_1_1_8_2 = DIC.SOL_TUNNEL_1_1_1_1_8_2(+) ';
sqlstring:=sqlstring|| '       AND GAL.SOL_TUNNEL_1_1_1_1_8_2 = REL.SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring:=sqlstring|| '       AND REL.SOL_TRACK_1_1_1_0_0_1 = BCS.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '       AND BCS.SEDE_TECNICA = SL.SEDE_TECNICA      ';
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT DIC.SOL_TUNNEL_1_1_1_1_8_2 "CODICE_OGGETTO",                    ';--DICH ASSENTI
sqlstring:=sqlstring|| '       GAL.SOL_TUNNEL_1_1_1_1_8_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.1.8.5'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.GALLERIE_BINARI_SOL ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_GALLERIE_BIN_SOL ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '         )  DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.GALLERIE_BINARI_SOL GAL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.REL_GALLERIE_BINARI_SOL REL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE    DIC.SOL_TUNNEL_1_1_1_1_8_2=GAL.SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring:=sqlstring|| ' AND GAL.SOL_TUNNEL_1_1_1_1_8_2=REL.SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring:=sqlstring|| ' AND REL.SOL_TRACK_1_1_1_0_0_1=BCS.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| ' AND BCS.SEDE_TECNICA=SL.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE  = ' ||p_versione;
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE = REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND REL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = SL.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       UNION ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| 'SELECT BCP.PO_TRACK_1_2_1_0_0_2 "CODICE_OGGETTO",               '; --DICH INF PO
sqlstring:=sqlstring|| '       BCP.PO_TRACK_1_2_1_0_0_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.1.0.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       PO_TRACK_1_2_1_0_1_1O2_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (PO_TRACK_1_2_1_0_1_1O2_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               PO_TRACK_1_2_1_0_1_1O2) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_PO DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.REL_PO_BINARI_CORSA rel, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_PO BCP, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI PO ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
sqlstring:=sqlstring|| '       AND dic.PO_TRACK_1_2_1_0_0_2 = rel.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '       AND rel.SEDE_TECNICA = po.SEDE_TECNICA ';
sqlstring:=sqlstring|| '       AND BCP.PO_TRACK_1_2_1_0_0_2 = DIC.PO_TRACK_1_2_1_0_0_2(+) ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCP.CODICE_VERSIONE  = ' ||p_versione;
sqlstring:=sqlstring|| '       AND PO.CODICE_VERSIONE = BCP.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND rel.CODICE_VERSIONE = BCP.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BCP.CODICE_VERSIONE = DIC.CODICE_VERSIONE ';
END IF;
      -- AND rel.PO_TRACK_1_2_1_0_0_2 LIKE ''LO%''
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT BCP.PO_TRACK_1_2_1_0_0_2 "CODICE_OGGETTO",               ';--DICH  ASSENTI
sqlstring:=sqlstring|| '       BCP.PO_TRACK_1_2_1_0_0_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.1.0.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.BINARI_CORSA_PO BCP ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_PO ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '     )  DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_PO BCP, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.REL_PO_BINARI_CORSA REL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI PO ';
sqlstring:=sqlstring|| ' WHERE     Bcp.PO_TRACK_1_2_1_0_0_2 = DIC.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '       AND PO.SEDE_TECNICA = REL.SEDE_TECNICA ';
sqlstring:=sqlstring|| '       AND REL.PO_TRACK_1_2_1_0_0_2 = BCP.PO_TRACK_1_2_1_0_0_2 ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCP.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND PO.CODICE_VERSIONE = BCP.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND REL.CODICE_VERSIONE = BCP.CODICE_VERSIONE ';
END IF;
      -- AND REL.PO_TRACK_1_2_1_0_0_2 LIKE ''LO%''
sqlstring:=sqlstring|| '   ';
sqlstring:=sqlstring|| ' UNION       ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '           SELECT GAL.PO_TR_TUNNEL_1_2_1_0_5_2 "CODICE_OGGETTO",            ';--DICH PO GALLERIA
sqlstring:=sqlstring|| '       GAL.PO_TR_TUNNEL_1_2_1_0_5_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.1.0.5.3'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       PO_TR_TUNNEL_1_2_1_0_5_3O4_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (PO_TR_TUNNEL_1_2_1_0_5_3O4_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               PO_TR_TUNNEL_1_2_1_0_5_3O4) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_GALLERIE_BIN_PO DIC, ';
sqlstring:=sqlstring|| '   '|| s_schema||'.GALLERIE_BINARI_PO GAL, ';
sqlstring:=sqlstring|| '   '|| s_schema||'.REL_GALLERIE_BINARI_PO REL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_PO BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.REL_PO_BINARI_CORSA relpobc, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI SL ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE=DIC.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE = REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND REL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = relpobc.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND relpobc.CODICE_VERSIONE = SL.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '       AND GAL.PO_TR_TUNNEL_1_2_1_0_5_2 = DIC.PO_TR_TUNNEL_1_2_1_0_5_2(+) ';
sqlstring:=sqlstring|| '       AND GAL.PO_TR_TUNNEL_1_2_1_0_5_2 = REL.PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring|| '       AND REL.PO_TRACK_1_2_1_0_0_2 = BCS.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '       AND BCS.PO_TRACK_1_2_1_0_0_2 =relpobc.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '       AND relpobc.SEDE_TECNICA = SL.SEDE_TECNICA      ';
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT GAL.PO_TR_TUNNEL_1_2_1_0_5_2 "CODICE_OGGETTO",                    ';--DICH ASSENTI
sqlstring:=sqlstring|| '       GAL.PO_TR_TUNNEL_1_2_1_0_5_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       po.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       po.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.1.0.5.3'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.GALLERIE_BINARI_PO ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_GALLERIE_BIN_PO ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '         ) DICH, ';
sqlstring:=sqlstring|| '          '|| s_schema||'.GALLERIE_BINARI_PO GAL, ';
sqlstring:=sqlstring|| '          '|| s_schema||'.REL_GALLERIE_BINARI_PO REL, ';
sqlstring:=sqlstring|| '          '|| s_schema||'.BINARI_CORSA_PO BCP, ';
sqlstring:=sqlstring|| '          '|| s_schema||'.REL_PO_BINARI_CORSA relpobc, ';
sqlstring:=sqlstring|| '          '|| s_schema||'.PUNTI_OPERATIVI PO         ';
sqlstring:=sqlstring|| '         WHERE   DICH.PO_TR_TUNNEL_1_2_1_0_5_2=GAL.PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring|| '         AND GAL.PO_TR_TUNNEL_1_2_1_0_5_2=REL.PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring|| '        AND REL.PO_TRACK_1_2_1_0_0_2=BCP.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '        AND BCP.PO_TRACK_1_2_1_0_0_2=relpobc.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '        AND relpobc.SEDE_TECNICA=po.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '        AND GAL.CODICE_VERSIONE  = ' ||p_versione;
sqlstring:=sqlstring|| '        AND GAL.CODICE_VERSIONE = REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '        AND REL.CODICE_VERSIONE = BCP.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '        AND BCP.CODICE_VERSIONE = relpobc.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '        AND relpobc.CODICE_VERSIONE=po.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '         ';
sqlstring:=sqlstring|| '         ';
sqlstring:=sqlstring|| '  UNION       ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '           SELECT BR.PO_SD_1_2_2_0_0_2 "CODICE_OGGETTO",            ';--DICH RACCORDO
sqlstring:=sqlstring|| '       BR.PO_SD_1_2_2_0_0_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '      PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.2.0.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       PO_SD_1_2_2_0_1_1O2_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (PO_SD_1_2_2_0_1_1O2_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               PO_SD_1_2_2_0_1_1O2) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_RACCORDO_PO DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_RACCORDO_PO BR, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI PO ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND DIC.CODICE_VERSIONE  = ' ||p_versione;
sqlstring:=sqlstring|| '       AND BR.CODICE_VERSIONE=DIC.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND PO.CODICE_VERSIONE = BR.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '       AND BR.PO_SD_1_2_2_0_0_2 = DIC.PO_SD_1_2_2_0_0_2(+) ';
sqlstring:=sqlstring|| '       AND BR.SEDE_TECNICA = PO.SEDE_TECNICA      ';
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT BR.PO_SD_1_2_2_0_0_2 "CODICE_OGGETTO",            ';--DICH RACCORDO
sqlstring:=sqlstring|| '       BR.PO_SD_1_2_2_0_0_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '      PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.2.0.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT PO_SD_1_2_2_0_0_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.BINARI_RACCORDO_PO ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT PO_SD_1_2_2_0_0_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_RACCORDO_PO ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '         ) DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_RACCORDO_PO BR, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI PO       ';
sqlstring:=sqlstring|| '       WHERE  BR.PO_SD_1_2_2_0_0_2 = DIC.PO_SD_1_2_2_0_0_2(+) ';
sqlstring:=sqlstring|| '       AND BR.SEDE_TECNICA = PO.SEDE_TECNICA  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND  BR.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND PO.CODICE_VERSIONE = BR.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       UNION       ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '           SELECT GAL.PO_SD_TUNNEL_1_2_2_0_5_2 "CODICE_OGGETTO",            ';--DICH GALLERIA RACCORDO
sqlstring:=sqlstring|| '       GAL.PO_SD_TUNNEL_1_2_2_0_5_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.2.0.5.3'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       PO_SD_TUNNEL_1_2_2_0_5_3O4_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (PO_SD_TUNNEL_1_2_2_0_5_3O4_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               PO_SD_TUNNEL_1_2_2_0_5_3O4) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_GALLERIE_SD_PO DIC, ';
sqlstring:=sqlstring|| '   '|| s_schema||'.GALLERIE_RACCORDO_PO GAL, ';
sqlstring:=sqlstring|| '   '|| s_schema||'.REL_GALLERIE_RACCORDO_PO REL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_RACCORDO_PO BR, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI PO ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE  = ' ||p_versione;
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE=DIC.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE = REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND REL.CODICE_VERSIONE = BR.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BR.CODICE_VERSIONE = PO.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '       AND GAL.PO_SD_TUNNEL_1_2_2_0_5_2 = DIC.PO_SD_TUNNEL_1_2_2_0_5_2(+) ';
sqlstring:=sqlstring|| '       AND GAL.PO_SD_TUNNEL_1_2_2_0_5_2 = REL.PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring|| '       AND REL.PO_SD_1_2_2_0_0_2 = BR.PO_SD_1_2_2_0_0_2 ';
sqlstring:=sqlstring|| '       AND BR.SEDE_TECNICA =PO.SEDE_TECNICA      ';
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT GAL.PO_SD_TUNNEL_1_2_2_0_5_2 "CODICE_OGGETTO",            ';--DICH ASSENTI
sqlstring:=sqlstring|| '       GAL.PO_SD_TUNNEL_1_2_2_0_5_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.2.0.5.3'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.REL_GALLERIE_RACCORDO_PO ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_GALLERIE_SD_PO ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '         ) DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.GALLERIE_RACCORDO_PO GAL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.REL_GALLERIE_RACCORDO_PO REL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_RACCORDO_PO BR, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI PO        ';
sqlstring:=sqlstring|| '         WHERE   DIC.PO_SD_TUNNEL_1_2_2_0_5_2=GAL.PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring|| '         AND GAL.PO_SD_TUNNEL_1_2_2_0_5_2=REL.PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring|| '        AND REL.PO_SD_1_2_2_0_0_2=BR.PO_SD_1_2_2_0_0_2 ';
sqlstring:=sqlstring|| '        AND BR.SEDE_TECNICA=PO.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '        AND GAL.CODICE_VERSIONE  = ' ||p_versione;
sqlstring:=sqlstring|| '        AND GAL.CODICE_VERSIONE = REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '        AND REL.CODICE_VERSIONE = BR.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '        AND BR.CODICE_VERSIONE = po.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '         ) tab_totale   ';                      --INSERITA SELECT ESTERNA PER CREARE UNA TABELLA UNICA SU CUI FARE POI LA SOTTOSELEZIONE PER IL ROUTING
sqlstring:=sqlstring|| '         WHERE DEFINIZIONE IS NOT NULL ';       --CODICE INUTILE; SERVE SOLO PER POTER ATTACCARE DOPO LA STRINGA DI SOTTOSELEZIONE DEL ROUTING (CHE INZIA PER 'and')

--filtro richiamato dalla funzione ROUTING
IF p_filtro is NOT NULL THEN
sqlstring:=sqlstring ||GetWhereCondition(p_filtro,'tab_totale.SEDE_TECNICA');
END IF;

--DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetDichiarazioniEC ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetInfoGeneraliTrattaBin (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.2

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area = 1 OR p_area = 3) 
 THEN
    p_versione := NULL;
 ELSE  --(p_area=2 OR p_area=4)
    IF p_i_versione IS NULL 
    THEN
       p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
    ELSE
       p_versione := p_i_versione;
    END IF;
 END IF;

--->
 sqlstring := 'Select  ';
 sqlstring := sqlstring ||' s.SEDE_TECNICA, ';
 sqlstring := sqlstring ||' s.DEFINIZIONE, ';
 sqlstring := sqlstring ||' bcs.SOL_TRACK_1_1_1_0_0_1 , ';
 sqlstring := sqlstring ||' SOL_TRACK_1_1_1_0_0_1_D, ';
 sqlstring := sqlstring ||' PKG_RINF_REPORT.GetDescription(''1.1.1.0.0.2'', SOL_TRACK_1_1_1_0_0_2) SOL_TRACK_1_1_1_0_0_2, ';
 sqlstring := sqlstring ||' Nvl (SOL_1_1_0_0_0_1, ''0083'') SOL_1_1_0_0_0_1, ';
 sqlstring := sqlstring ||' Nvl (Trim (linea_comm.linea), ''0000'') SOL_1_1_0_0_0_2, ';
 sqlstring := sqlstring ||' SOL_1_1_0_0_0_3, ';
 sqlstring := sqlstring ||' p_i.DEFINIZIONE LOCALITA_INIZIO, ';
 sqlstring := sqlstring ||' SOL_1_1_0_0_0_4, ';
 sqlstring := sqlstring ||' p_f.DEFINIZIONE LOCALITA_FINE, ';
 sqlstring := sqlstring ||' Round (SOL_1_1_0_0_0_5, 3) SOL_1_1_0_0_0_5, ';
 sqlstring := sqlstring ||' PKG_RINF_REPORT.GetDescription(''1.1.0.0.0.6'', SOL_1_1_0_0_0_6) SOL_1_1_0_0_0_6, ';

 ---> Modifica al reg 777/2019 del 06/04/2021
 sqlstring:=sqlstring || ' Decode(SOL_TRACK_1_1_1_4_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.4.1'', SOL_TRACK_1_1_1_4_1)) SOL_TRACK_1_1_1_4_1, ';
 sqlstring:=sqlstring || ' Decode(SOL_TRACK_1_1_1_4_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.4.2'', SOL_TRACK_1_1_1_4_2)) SOL_TRACK_1_1_1_4_2, ';
 ---> Fine modifica
 sqlstring := sqlstring ||' S.CODICE_DTP, ';
 sqlstring := sqlstring ||' S.CODICE_UT, ';
 sqlstring := sqlstring ||' S.CODICE_LINEA_TECNICA ';
--
 sqlstring := sqlstring ||' From '|| s_schema||'.SEZIONI_LINEA s, ';
 sqlstring := sqlstring ||  s_schema||'.PUNTI_OPERATIVI p_i, ';
 sqlstring := sqlstring ||  s_schema||'.PUNTI_OPERATIVI p_f, ';
 sqlstring := sqlstring ||  s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring ||' (Select SEDE_TECNICA, ';
 sqlstring := sqlstring ||'  Listagg (Replace (CODICE, '' '', '''') || '' '') ';
 sqlstring := sqlstring ||'  Within Group (Order By CODICE) ';
 sqlstring := sqlstring ||'  As linea ';
 sqlstring := sqlstring ||' From '|| s_schema||'.V_MDR_LINEE_COMMERCIALI ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring ||' Where CODICE_VERSIONE  = ' ||p_versione;
 End If;
 sqlstring := sqlstring ||' Group By SEDE_TECNICA) linea_comm, ';
 ---> modifica reg 777/2019 del 06/04/2021
 sqlstring:=sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 If p_versione Is Not Null Then
    sqlstring:=sqlstring ||' CODICE_VERSIONE, ';
End If;
 sqlstring:=sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring:=sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring:=sqlstring || '  As SOL_TRACK_1_1_1_4_2 ';
 sqlstring:=sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_4_2_NORME_DOC, ';
 sqlstring:=sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring:=sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring:=sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring:=sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.4.2'' ';
 sqlstring:=sqlstring || ' And SOL_TRACK_1_1_1_4_2 = CODIFICA_VALORE ';
 If p_versione Is Not Null  Then
    sqlstring:=sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring:=sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null  Then
    sqlstring:=sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring:=sqlstring || '   ) norme_doc ';
 ---> fine modifica
 sqlstring := sqlstring ||' Where s.LOCALITA_INIZIO = p_i.SEDE_TECNICA ';
 sqlstring := sqlstring ||' And s.LOCALITA_FINE = p_f.SEDE_TECNICA ';
 sqlstring := sqlstring ||' And s.SEDE_TECNICA = linea_comm.SEDE_TECNICA(+) ';
 sqlstring := sqlstring ||' And s.SEDE_TECNICA = bcs.SEDE_TECNICA ';
 sqlstring := sqlstring ||' And norme_doc.SOL_TRACK_1_1_1_0_0_1(+) = bcs.SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null  Then
    sqlstring := sqlstring ||' And s.CODICE_VERSIONE  = ' ||p_versione;
    sqlstring := sqlstring ||' And p_i.CODICE_VERSIONE = s.CODICE_VERSIONE ';
    sqlstring := sqlstring ||' And p_f.CODICE_VERSIONE = s.CODICE_VERSIONE ';
    sqlstring := sqlstring ||' And bcs.CODICE_VERSIONE = s.CODICE_VERSIONE ';
    sqlstring := sqlstring ||' And norme_doc.CODICE_VERSIONE (+) = s.CODICE_VERSIONE ';
 End If;
 --filtro richiamato dalla funzione ROUTING
 If p_filtro Is Not Null  Then
    sqlstring := sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro, 's.SEDE_TECNICA');
 End If;
-- DBMS_OUTPUT.PUT_LINE(sqlstring);

 OPEN p_cursor FOR sqlstring;

END GetInfoGeneraliTrattaBin ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetSOLParametriINF (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.3
--p_filtro VARCHAR2(32767);
s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) 
 THEN
    p_versione:=NULL;
 ELSE 
    IF p_i_versione IS NULL 
    THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
    ELSE
       p_versione:=p_i_versione;
    END IF;
 END IF;

 sqlstring := 'Select SL.SEDE_TECNICA, ';
 sqlstring := sqlstring || ' SL.DEFINIZIONE, ';
 sqlstring := sqlstring || ' s.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' s.SOL_TRACK_1_1_1_0_0_1_D , ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_1, ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.1'', cat_ten.SOL_TRACK_1_1_1_1_2_1)) SOL_TRACK_1_1_1_1_2_1, ';
 ---> mofica Reg.777/2019/UE 06/04/2021
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_1_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.1.2'', SOL_TRACK_1_1_1_1_2_1_2)) SOL_TRACK_1_1_1_1_2_1_2, ';
 ---> fine modifica
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.2'', cat_linea.SOL_TRACK_1_1_1_1_2_2)) SOL_TRACK_1_1_1_1_2_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.3'', corridoio.SOL_TRACK_1_1_1_1_2_3)) SOL_TRACK_1_1_1_1_2_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4'', cap_carico.SOL_TRACK_1_1_1_1_2_4)) SOL_TRACK_1_1_1_1_2_4, ';
 ---> mofica Reg.777/2019/UE 06/04/2021
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4.1'', SOL_TRACK_1_1_1_1_2_4_1)) SOL_TRACK_1_1_1_1_2_4_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4.2'', SOL_TRACK_1_1_1_1_2_4_2)) SOL_TRACK_1_1_1_1_2_4_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4.3'', SOL_TRACK_1_1_1_1_2_4_3)) SOL_TRACK_1_1_1_1_2_4_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4.4'', SOL_TRACK_1_1_1_1_2_4_4)) SOL_TRACK_1_1_1_1_2_4_4, ';
 ---> fine modifica  
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.5'', SOL_TRACK_1_1_1_1_2_5)) SOL_TRACK_1_1_1_1_2_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.6'', SOL_TRACK_1_1_1_1_2_6)) SOL_TRACK_1_1_1_1_2_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.7'', SOL_TRACK_1_1_1_1_2_7)) SOL_TRACK_1_1_1_1_2_7, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.8'', SOL_TRACK_1_1_1_1_2_8)) SOL_TRACK_1_1_1_1_2_8, ';
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1'', SOL_TRACK_1_1_1_1_3_1)) SOL_TRACK_1_1_1_1_3_1, ';
 ---> mofica Reg.777/2019/UE 06/04/2021
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_1_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1.1.SUP'', SOL_TRACK_1_1_1_1_3_1_1_SUP)||'' + ''||PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1.1.INF'', SOL_TRACK_1_1_1_1_3_1_1_INF)) SOL_TRACK_1_1_1_1_3_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_1_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1.2'', SOL_TRACK_1_1_1_1_3_1_2)) SOL_TRACK_1_1_1_1_3_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_1_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1.3'', SOL_TRACK_1_1_1_1_3_1_3)) SOL_TRACK_1_1_1_1_3_1_3, ';
 ---> fine modifica 
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.2'', SOL_TRACK_1_1_1_1_3_2)) SOL_TRACK_1_1_1_1_3_2, ';
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.3'', SOL_TRACK_1_1_1_1_3_3)) SOL_TRACK_1_1_1_1_3_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.4'', prof_casse.SOL_TRACK_1_1_1_1_3_4)) SOL_TRACK_1_1_1_1_3_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.5'', prof_semir.SOL_TRACK_1_1_1_1_3_5)) SOL_TRACK_1_1_1_1_3_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_5_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.5.1'', SOL_TRACK_1_1_1_1_3_5_1)) SOL_TRACK_1_1_1_1_3_5_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.6'', p.gradiente)) SOL_TRACK_1_1_1_1_3_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.7'', SOL_TRACK_1_1_1_1_3_7)) SOL_TRACK_1_1_1_1_3_7, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_4_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.4.1'',SOL_TRACK_1_1_1_1_4_1))SOL_TRACK_1_1_1_1_4_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_4_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.4.2'',SOL_TRACK_1_1_1_1_4_2))SOL_TRACK_1_1_1_1_4_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_4_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.4.3'',SOL_TRACK_1_1_1_1_4_3))SOL_TRACK_1_1_1_1_4_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_4_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.4.4'',SOL_TRACK_1_1_1_1_4_4))SOL_TRACK_1_1_1_1_4_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_5_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.5.1'',SOL_TRACK_1_1_1_1_5_1))SOL_TRACK_1_1_1_1_5_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_5_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.5.2'',SOL_TRACK_1_1_1_1_5_2))SOL_TRACK_1_1_1_1_5_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',TRIM(PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.1'',TRIM (SOL_TRACK_1_1_1_1_6_1))))SOL_TRACK_1_1_1_1_6_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.2'',SOL_TRACK_1_1_1_1_6_2))SOL_TRACK_1_1_1_1_6_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.3'',SOL_TRACK_1_1_1_1_6_3))SOL_TRACK_1_1_1_1_6_3, ';
 ---> mofica Reg.777/2019/UE 06/04/2021   
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.4'', SOL_TRACK_1_1_1_1_6_4)) SOL_TRACK_1_1_1_1_6_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_5_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.5'', SOL_TRACK_1_1_1_1_6_5)) SOL_TRACK_1_1_1_1_6_5, ';
 ---> fine modifica 
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.1'',SOL_TRACK_1_1_1_1_7_1))SOL_TRACK_1_1_1_1_7_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.2'',SOL_TRACK_1_1_1_1_7_2))SOL_TRACK_1_1_1_1_7_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.3'',SOL_TRACK_1_1_1_1_7_3))SOL_TRACK_1_1_1_1_7_3, ';
 ---> mofica Reg.777/2019/UE 06/04/2021    
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.4'', SOL_TRACK_1_1_1_1_7_4)) SOL_TRACK_1_1_1_1_7_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_5_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.5'', SOL_TRACK_1_1_1_1_7_5)) SOL_TRACK_1_1_1_1_7_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_6_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.6'', SOL_TRACK_1_1_1_1_7_6)) SOL_TRACK_1_1_1_1_7_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_7_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.7'', SOL_TRACK_1_1_1_1_7_7)) SOL_TRACK_1_1_1_1_7_7, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_8_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.8'', SOL_TRACK_1_1_1_1_7_8)) SOL_TRACK_1_1_1_1_7_8, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_9_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.9'', SOL_TRACK_1_1_1_1_7_9)) SOL_TRACK_1_1_1_1_7_9, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_10_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.10'', SOL_TRACK_1_1_1_1_7_10)) SOL_TRACK_1_1_1_1_7_10, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_11_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.11'', SOL_TRACK_1_1_1_1_7_11)) SOL_TRACK_1_1_1_1_7_11, ';
 ---> fine modifica 
 sqlstring := sqlstring || ' CODICE_DTP, ';
 sqlstring := sqlstring || ' CODICE_UT, ';
 sqlstring := sqlstring || ' CODICE_LINEA_TECNICA ';
 sqlstring := sqlstring || ' From '|| s_schema||'.BINARI_CORSA_SOL s, ';
 sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA sl, '; 
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' CODICE_VERSIONE, ';
 End If;
 sqlstring := sqlstring || ' Listagg ( ';
 sqlstring := sqlstring || ' Decode ( ';
 sqlstring := sqlstring || ' Sign (PENDENZA), ';
 sqlstring := sqlstring || ' -1, Trim (To_Char (PENDENZA, ''9999999999999990.9'')), ';
 sqlstring := sqlstring || ' ''+'' || Trim (To_Char (PENDENZA, ''9999999999999990.9''))) ';
 sqlstring := sqlstring || ' || ''('' ';
 sqlstring := sqlstring || ' || Trim ( ';
 sqlstring := sqlstring || ' To_Char (Least (KM_INIZIO, KM_FINE), ';
 sqlstring := sqlstring || ' ''9999999999999990.999'')) ';
 sqlstring := sqlstring || ' || '')'', ';
 sqlstring := sqlstring || ' '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By Least (KM_INIZIO, KM_FINE)) ';
 sqlstring := sqlstring || ' As gradiente ';
 sqlstring := sqlstring || ' From '|| s_schema||'.PAR_1_1_1_1_3_6_GRADIENTE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || '  , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '  ) p, ';
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_1_2_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_1_2_1_CAT_TEN_SOL, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.codice_parametro = d.codice_parametro ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.1.2.1'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_2_1 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
   sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '   ) cat_ten, ';
 sqlstring := sqlstring || '( Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_1_2_2 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.PAR_1_1_1_1_2_2_CAT_LINEA, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.1.2.2'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_2_2 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '  ) cat_linea, ';
 sqlstring := sqlstring || ' (Select SEDE_TECNICA, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_1_2_3 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  CODICE_CONTESTO = 3 ';
 sqlstring := sqlstring || ' And c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And CODICE || ''0'' = CODIFICA_VALORE ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.1.2.3'' ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SEDE_TECNICA ';
 If p_versione Is Not Null 
 Then
   sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) corridoio, ';
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_1_2_4 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.PAR_1_1_1_1_2_4_CAP_CARICO, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And numero_parametro = ''1.1.1.1.2.4'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_2_4 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) cap_carico, ';
 sqlstring := sqlstring || '           ';
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_1_3_4 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_1_3_4_PROF_CAS_M, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And numero_parametro = ''1.1.1.1.3.4'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_3_4 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '  ) prof_casse, ';
 sqlstring := sqlstring || '           ';
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_1_3_5 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_1_3_5_PROF_SEMI_R, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And numero_parametro = ''1.1.1.1.3.5'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_3_5 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
   sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '  ) prof_semir, ';
 sqlstring := sqlstring || '       ';
 sqlstring := sqlstring || ' ( Select bcs.SOL_TRACK_1_1_1_0_0_1 , ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_1O2_AP SOL_TRACK_1_1_1_1_1_1_AP, ';
 sqlstring := sqlstring || ' Decode (SOL_TRACK_1_1_1_1_1_1O2_AP, ';
 sqlstring := sqlstring || ' ''NYA'','' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_1O2) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF DIC, ';
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where  DIC.TIPO_DICHIARAZIONE = ''EC'' ';
 If p_versione Is Not Null 
 Then
   sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = ' ||p_versione;
   sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
   sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = sl.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' And bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || 'Union ';
 sqlstring := sqlstring || 'Select DIC.SOL_TRACK_1_1_1_0_0_1 , ';
 sqlstring := sqlstring || '  ''NYA'' SOL_TRACK_1_1_1_1_1_1_AP, ';
 sqlstring := sqlstring || ' '' '' SOL_TRACK_1_1_1_1_1_1 ';
 sqlstring := sqlstring || ' From (Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.BINARI_CORSA_SOL bcs ';
 If p_versione Is Not Null 
 Then
   sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Minus ';
 sqlstring := sqlstring || ' Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
 sqlstring := sqlstring || ' Where TIPO_DICHIARAZIONE= ''EC''  ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' )  dic, ';
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where  bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' and BCS.SEDE_TECNICA = sl.SEDE_TECNICA ';
 If p_versione Is Not Null Then
   sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = ' ||p_versione;
   sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '  ) dich_ec_inf, ';
 ---> inizio modifica reg 777/2019 del 06/04/2021
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_1_2_4_3 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_1_2_4_3_LOCAVERSPEC, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.1.2.4.3'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_2_4_3 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
   sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null
 Then
    sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '   ) locaverspec, ';
 ---> fine modifica 
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_1_7_8 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_1_7_8_LOCA_SIST_RTB, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.1.7.8'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_7_8 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '   ) loca_sist_rtb, ';
 ---> inizio modifica reg 777/2019 06/04/2021 
 sqlstring := sqlstring || ' ( SELECT BCS.SOL_TRACK_1_1_1_0_0_1 , ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_1O2_AP SOL_TRACK_1_1_1_1_1_2_AP, ';
 sqlstring := sqlstring || ' Decode (SOL_TRACK_1_1_1_1_1_1O2_AP, ';
 sqlstring := sqlstring || ' ''NYA'','' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_1O2) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_2 ';
 sqlstring := sqlstring || '  From  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF DIC, ';
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_SOL BCS, ';
 sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA SL ';
 sqlstring := sqlstring || ' Where  dic.TIPO_DICHIARAZIONE = ''EI'' ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = sl.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' And bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || 'Union ';
 sqlstring := sqlstring || 'Select dic.SOL_TRACK_1_1_1_0_0_1 , ';
 sqlstring := sqlstring || ' ''NYA'' SOL_TRACK_1_1_1_1_1_2_AP, ';
 sqlstring := sqlstring || ' '' '' SOL_TRACK_1_1_1_1_1_2 ';
 sqlstring := sqlstring || '  From (Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || '  From  '|| s_schema||'.BINARI_CORSA_SOL BCS ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || 'Minus ';
 sqlstring := sqlstring || 'Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
 sqlstring := sqlstring || ' Where TIPO_DICHIARAZIONE= ''EI''  ';
 If p_versione Is Not Null 
 Then
   sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' )  dic, ';
 ---> fine modifica 
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_SOL BCS, ';
 sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA SL ';
 sqlstring := sqlstring || ' Where bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) dich_ie_inf ';
 sqlstring := sqlstring || '                ';
 sqlstring := sqlstring || 'Where  S.SEDE_TECNICA=SL.SEDE_TECNICA ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = p.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = cat_ten.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = cat_linea.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SEDE_TECNICA = corridoio.SEDE_TECNICA(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = cap_carico.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = prof_casse.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = prof_semir.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = dich_ec_inf.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = dich_ie_inf.SOL_TRACK_1_1_1_0_0_1(+) ';
 ---> inizio modifica reg 777/2019 06/04/2021
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = locaverspec.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = loca_sist_rtb.SOL_TRACK_1_1_1_0_0_1(+) ';
 ---> fine modifica 
 If p_versione Is Not Null Then
   sqlstring := sqlstring || 'And s.CODICE_VERSIONE = ' ||p_versione;
   sqlstring := sqlstring || 'And sl.CODICE_VERSIONE = s.CODICE_VERSIONE ';
 End If;


--filtro richiamato dalla funzione ROUTING
IF p_filtro is NOT NULL THEN
sqlstring:=sqlstring ||GetWhereCondition(p_filtro,'SL.SEDE_TECNICA');
END IF;

--sqlstring:=sqlstring || '         order by 1 ';

DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;

END GetSOLParametriINF ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetSOLParametriENE (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.4

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) 
 THEN
    p_versione:=NULL;
 ELSE 
     IF p_i_versione IS NULL 
     THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;

 sqlstring := ' Select sl.SEDE_TECNICA, ';
 sqlstring := sqlstring || ' sl.DEFINIZIONE, ';
 sqlstring := sqlstring || ' s.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' s.SOL_TRACK_1_1_1_0_0_1_D , ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_1_1, ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_1_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.1.1'', SOL_TRACK_1_1_1_2_2_1_1)) SOL_TRACK_1_1_1_2_2_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_1_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.1.2'', SOL_TRACK_1_1_1_2_2_1_2)) SOL_TRACK_1_1_1_2_2_1_2, ';
 ---> inizio modifica reg 777/2019 06/04/2021
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_1_2_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.1.2.1'', SOL_TRACK_1_1_1_2_2_1_2_1)) SOL_TRACK_1_1_1_2_2_1_2_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_1_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.1.3'', SOL_TRACK_1_1_1_2_2_1_3)) SOL_TRACK_1_1_1_2_2_1_3, ';
 ---> fine modifica 
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.2'', SOL_TRACK_1_1_1_2_2_2)) SOL_TRACK_1_1_1_2_2_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.3'', SOL_TRACK_1_1_1_2_2_3)) SOL_TRACK_1_1_1_2_2_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.4'', SOL_TRACK_1_1_1_2_2_4)) SOL_TRACK_1_1_1_2_2_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_5_AP, ''NYA'','' '', ''N'', ''Non applicabile'', Trim (To_Char (Round (SOL_TRACK_1_1_1_2_2_5, 2), ''999990.99''))) SOL_TRACK_1_1_1_2_2_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_6_AP, ''NYA'','' '', ''N'', ''Non applicabile'', Trim (To_Char (Round (SOL_TRACK_1_1_1_2_2_6, 2), ''999990.99''))) SOL_TRACK_1_1_1_2_2_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_3_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.1'', SOL_TRACK_1_1_1_2_3_1)) SOL_TRACK_1_1_1_2_3_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_3_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.2'', SOL_TRACK_1_1_1_2_3_2)) SOL_TRACK_1_1_1_2_3_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_3_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' Decode ( SOL_TRACK_1_1_1_2_3_3_A ';
 sqlstring := sqlstring || ' || '' '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_3_3_B ';
 sqlstring := sqlstring || ' || '' '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_3_3_C, ';
 sqlstring := sqlstring || ' ''++'', NULL, ';
 sqlstring := sqlstring || '    SOL_TRACK_1_1_1_2_3_3_A ';
 sqlstring := sqlstring || ' || '' '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_3_3_B ';
 sqlstring := sqlstring || ' || '' '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_3_3_C)) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_3_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_3_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.4'', SOL_TRACK_1_1_1_2_3_4)) SOL_TRACK_1_1_1_2_3_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_4_1_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.4.1.1'', SOL_TRACK_1_1_1_2_4_1_1)) SOL_TRACK_1_1_1_2_4_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_4_1_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' Decode ( ';
 sqlstring := sqlstring || '    SOL_TRACK_1_1_1_2_4_1_2_A ';
 sqlstring := sqlstring || ' || ''+'' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_1_2_B ';
 sqlstring := sqlstring || ' || ''+'' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_1_2_C, ';
 sqlstring := sqlstring || ' ''++'', NULL, ';
 sqlstring := sqlstring || ' ''length '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_1_2_A ';
 sqlstring := sqlstring || ' || '' + switch off breaker '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_1_2_B ';
 sqlstring := sqlstring || ' || '' + lower pantograph '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_1_2_C)) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_4_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_4_2_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.4.2.1'', SOL_TRACK_1_1_1_2_4_2_1)) SOL_TRACK_1_1_1_2_4_2_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_4_2_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' Decode ( ';
 sqlstring := sqlstring || '    SOL_TRACK_1_1_1_2_4_2_2_A ';
 sqlstring := sqlstring || ' || ''+'' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_B ';
 sqlstring := sqlstring || ' || ''+'' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_C ';
 sqlstring := sqlstring || ' || ''+'' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_D, ';
 sqlstring := sqlstring || ' ''+++'', NULL, ';
 sqlstring := sqlstring || '    ''length '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_A ';
 sqlstring := sqlstring || ' || '' + switch off breaker '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_B ';
 sqlstring := sqlstring || ' || '' + lower pantograph '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_C ';
 sqlstring := sqlstring || ' || '' + change supply system '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_D)) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_4_2_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_4_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.4.3'', SOL_TRACK_1_1_1_2_4_3)) SOL_TRACK_1_1_1_2_4_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_5_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.5.1'', SOL_TRACK_1_1_1_2_5_1)) SOL_TRACK_1_1_1_2_5_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_5_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.5.2'', SOL_TRACK_1_1_1_2_5_2)) SOL_TRACK_1_1_1_2_5_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_5_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.5.3'', SOL_TRACK_1_1_1_2_5_3)) SOL_TRACK_1_1_1_2_5_3, ';
 sqlstring := sqlstring || ' CODICE_DTP, ';
 sqlstring := sqlstring || ' CODICE_UT, ';
 sqlstring := sqlstring || ' CODICE_LINEA_TECNICA ';
 sqlstring := sqlstring || ' From '|| s_schema||'.BINARI_CORSA_SOL s, ';
 sqlstring := sqlstring ||   s_schema||'.SEZIONI_LINEA sl, ';
 sqlstring := sqlstring || ' ( Select BCS.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_1_1O2_AP SOL_TRACK_1_1_1_2_1_1_AP, ';
 sqlstring := sqlstring || ' Decode (SOL_TRACK_1_1_1_2_1_1O2_AP, ';
 sqlstring := sqlstring || ' ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || '  SOL_TRACK_1_1_1_2_1_1O2) ';
 sqlstring := sqlstring || '  SOL_TRACK_1_1_1_2_1_1 ';
 sqlstring := sqlstring || '  From '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE dic, ';
 sqlstring := sqlstring ||    s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring ||    s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' where  DIC.TIPO_DICHIARAZIONE = ''EC'' ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = sl.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' And bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || ' Union ';
 sqlstring := sqlstring || ' Select dic.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' ''NYA'' SOL_TRACK_1_1_1_2_1_1_AP, ';
 sqlstring := sqlstring || ' '' '' SOL_TRACK_1_1_1_2_1_1 ';
 sqlstring := sqlstring || ' From (SELECT SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.BINARI_CORSA_SOL bcs ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Minus ';
 sqlstring := sqlstring || ' Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
 sqlstring := sqlstring || ' Where TIPO_DICHIARAZIONE = ''EC''  ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ')  dic, ';
 sqlstring := sqlstring ||   s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring ||   s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where  BCS.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
 End If;
 sqlstring :=sqlstring || ' ) DICH_EC_ENE, ';
 sqlstring := sqlstring || ' ( SELECT BCS.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_1_1O2_AP SOL_TRACK_1_1_1_2_1_2_AP, ';
 sqlstring := sqlstring || ' Decode (SOL_TRACK_1_1_1_2_1_1O2_AP, ';
 sqlstring := sqlstring || ' ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_1_1O2) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_1_2 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE dic, ';
 sqlstring := sqlstring ||   s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring ||   s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where dic.TIPO_DICHIARAZIONE = ''EI'' ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = sl.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' And bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || ' Union ';
 sqlstring := sqlstring || ' Select dic.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' ''NYA'' SOL_TRACK_1_1_1_2_1_2_AP, ';
 sqlstring := sqlstring || ' '' '' SOL_TRACK_1_1_1_2_1_2 ';
 sqlstring := sqlstring || ' From (Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.BINARI_CORSA_SOL bcs ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Minus ';
 sqlstring := sqlstring || ' Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
 sqlstring := sqlstring || ' Where TIPO_DICHIARAZIONE= ''EI''  ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' )  dic, ';
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where  bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
 End If;         
 sqlstring := sqlstring || ') dich_ie_ene    ';
 sqlstring := sqlstring || ' Where s.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = dich_ec_ene.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = dich_ie_ene.SOL_TRACK_1_1_1_0_0_1(+) ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And s.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = s.CODICE_VERSIONE ';
 End If;
 --filtro richiamato dalla funzione ROUTING
 If p_filtro Is Not Null 
 Then
   sqlstring:=sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro,'SL.SEDE_TECNICA');
 End If;
 --sqlstring:=sqlstring || '         order by 1 ';
 DBMS_OUTPUT.PUT_LINE(sqlstring);
 OPEN p_cursor FOR sqlstring;
END GetSOLParametriENE ;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetSOLParametriCCS (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.5

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;

 sqlstring := 'Select sl.SEDE_TECNICA, ';
 sqlstring := sqlstring || ' sl.DEFINIZIONE, ';
 sqlstring := sqlstring || ' s.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' s.SOL_TRACK_1_1_1_0_0_1_D , ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_3_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.1'', SOL_TRACK_1_1_1_3_2_1)) SOL_TRACK_1_1_1_3_2_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.2'', SOL_TRACK_1_1_1_3_2_2)) SOL_TRACK_1_1_1_3_2_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.3'', SOL_TRACK_1_1_1_3_2_3)) SOL_TRACK_1_1_1_3_2_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.4'', SOL_TRACK_1_1_1_3_2_4)) SOL_TRACK_1_1_1_3_2_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.5'', SOL_TRACK_1_1_1_3_2_5)) SOL_TRACK_1_1_1_3_2_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.6'', SOL_TRACK_1_1_1_3_2_6)) SOL_TRACK_1_1_1_3_2_6, ';
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.7'', SOL_TRACK_1_1_1_3_2_7)) SOL_TRACK_1_1_1_3_2_7, '; --eliminato il 04-10-2021
--->
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.8'', SOL_TRACK_1_1_1_3_2_8)) SOL_TRACK_1_1_1_3_2_8, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_9_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.9'', SOL_TRACK_1_1_1_3_2_9)) SOL_TRACK_1_1_1_3_2_9, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_10_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.10'', SOL_TRACK_1_1_1_3_2_10)) SOL_TRACK_1_1_1_3_2_10, ';
--->
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.1'', SOL_TRACK_1_1_1_3_3_1)) SOL_TRACK_1_1_1_3_3_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.2'', SOL_TRACK_1_1_1_3_3_2)) SOL_TRACK_1_1_1_3_3_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.3'', gsm.SOL_TRACK_1_1_1_3_3_3)) SOL_TRACK_1_1_1_3_3_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_3_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.3.1'', SOL_TRACK_1_1_1_3_3_3_1)) SOL_TRACK_1_1_1_3_3_3_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_3_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.3.2'', SOL_TRACK_1_1_1_3_3_3_2)) SOL_TRACK_1_1_1_3_3_3_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_3_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.3.3'', SOL_TRACK_1_1_1_3_3_3_3)) SOL_TRACK_1_1_1_3_3_3_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.4'', SOL_TRACK_1_1_1_3_3_4)) SOL_TRACK_1_1_1_3_3_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.5'', SOL_TRACK_1_1_1_3_3_5)) SOL_TRACK_1_1_1_3_3_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.6'', SOL_TRACK_1_1_1_3_3_6)) SOL_TRACK_1_1_1_3_3_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.7'', SOL_TRACK_1_1_1_3_3_7)) SOL_TRACK_1_1_1_3_3_7, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.8'', SOL_TRACK_1_1_1_3_3_8)) SOL_TRACK_1_1_1_3_3_8, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_9_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.9'', SOL_TRACK_1_1_1_3_3_9)) SOL_TRACK_1_1_1_3_3_9, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_10_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.10'', SOL_TRACK_1_1_1_3_3_10)) SOL_TRACK_1_1_1_3_3_10, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_4_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.4.1'', SOL_TRACK_1_1_1_3_4_1)) SOL_TRACK_1_1_1_3_4_1, ';
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_5_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.5.1'', SOL_TRACK_1_1_1_3_5_1)) SOL_TRACK_1_1_1_3_5_1, '; -- eliminato 04-10-2021
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_5_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.5.2'', SOL_TRACK_1_1_1_3_5_2)) SOL_TRACK_1_1_1_3_5_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_5_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.5.3'', SOL_TRACK_1_1_1_3_5_3)) SOL_TRACK_1_1_1_3_5_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_6_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.6.1'', SOL_TRACK_1_1_1_3_6_1)) SOL_TRACK_1_1_1_3_6_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_1_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1)) SOL_TRACK_1_1_1_3_7_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_1_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.2'', SOL_TRACK_1_1_1_3_7_1_2)) SOL_TRACK_1_1_1_3_7_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_1_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.3'', SOL_TRACK_1_1_1_3_7_1_3)) SOL_TRACK_1_1_1_3_7_1_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_1_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.4'',SOL_TRACK_1_1_1_3_7_1_4)) SOL_TRACK_1_1_1_3_7_1_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_2_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.2.1'', SOL_TRACK_1_1_1_3_7_2_1)) SOL_TRACK_1_1_1_3_7_2_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_2_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.2.2'', SOL_TRACK_1_1_1_3_7_2_2)) SOL_TRACK_1_1_1_3_7_2_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.3'', SOL_TRACK_1_1_1_3_7_3)) SOL_TRACK_1_1_1_3_7_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.4'', SOL_TRACK_1_1_1_3_7_4)) SOL_TRACK_1_1_1_3_7_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.5'', SOL_TRACK_1_1_1_3_7_5)) SOL_TRACK_1_1_1_3_7_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.6'', SOL_TRACK_1_1_1_3_7_6)) SOL_TRACK_1_1_1_3_7_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.7'', SOL_TRACK_1_1_1_3_7_7)) SOL_TRACK_1_1_1_3_7_7, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Trim (To_Char (Round (SOL_TRACK_1_1_1_3_7_8, 1), ''999990.9''))) SOL_TRACK_1_1_1_3_7_8, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_9_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Trim (To_Char (Round (SOL_TRACK_1_1_1_3_7_9, 1), ''999990.9''))) SOL_TRACK_1_1_1_3_7_9, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_10_AP, ''NYA'' ,'' '', ''N'', ''Non applicabile'',Trim (To_Char (Round (SOL_TRACK_1_1_1_3_7_10, 1), ''999990.9'')) ) SOL_TRACK_1_1_1_3_7_10, ';
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_11_AP, ''NYA'' ,'' '', ''N'', ''Non applicabile'',Trim (To_Char (Round (SOL_TRACK_1_1_1_3_7_11, 1), ''999990.9'')))  SOL_TRACK_1_1_1_3_7_11, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_11_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.11.1'', SOL_TRACK_1_1_1_3_7_11_1)) SOL_TRACK_1_1_1_3_7_11_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_12_AP, ''NYA'' ,'' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.12'', SOL_TRACK_1_1_1_3_7_12)) SOL_TRACK_1_1_1_3_7_12, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_13_AP, ''NYA'' ,'' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.13'', SOL_TRACK_1_1_1_3_7_13)) SOL_TRACK_1_1_1_3_7_13, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_14_AP, ''NYA'' ,'' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.14'', SOL_TRACK_1_1_1_3_7_14)) SOL_TRACK_1_1_1_3_7_14, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_15_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.15.1'', SOL_TRACK_1_1_1_3_7_15_1)) SOL_TRACK_1_1_1_3_7_15_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_15_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', TRIM (TO_CHAR (ROUND (SOL_TRACK_1_1_1_3_7_15_2, 3), ''999990.999''))) SOL_TRACK_1_1_1_3_7_15_2, ';
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_16_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.16'', SOL_TRACK_1_1_1_3_7_16)) SOL_TRACK_1_1_1_3_7_16, ';
 sqlstring := sqlstring || ' Decode( SOL_TRACK_1_1_1_3_7_17_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.17'', SOL_TRACK_1_1_1_3_7_17) )SOL_TRACK_1_1_1_3_7_17, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_18_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.18'', SOL_TRACK_1_1_1_3_7_18)) SOL_TRACK_1_1_1_3_7_18, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_19_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.19'', SOL_TRACK_1_1_1_3_7_19)) SOL_TRACK_1_1_1_3_7_19, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_20_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.20'', SOL_TRACK_1_1_1_3_7_20)) SOL_TRACK_1_1_1_3_7_20, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_21_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.21'', SOL_TRACK_1_1_1_3_7_21)) SOL_TRACK_1_1_1_3_7_21, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_22_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.22'', SOL_TRACK_1_1_1_3_7_22)) SOL_TRACK_1_1_1_3_7_22, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_23_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.23'', SOL_TRACK_1_1_1_3_7_23)) SOL_TRACK_1_1_1_3_7_23, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_8_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.8.1'', SOL_TRACK_1_1_1_3_8_1)) SOL_TRACK_1_1_1_3_8_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_8_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.8.2'', SOL_TRACK_1_1_1_3_8_2)) SOL_TRACK_1_1_1_3_8_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_9_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.9.1'', SOL_TRACK_1_1_1_3_9_1)) SOL_TRACK_1_1_1_3_9_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_9_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.9.2'', SOL_TRACK_1_1_1_3_9_2)) SOL_TRACK_1_1_1_3_9_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_10_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.10.1'', SOL_TRACK_1_1_1_3_10_1)) SOL_TRACK_1_1_1_3_10_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_10_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.10.2'', SOL_TRACK_1_1_1_3_10_2)) SOL_TRACK_1_1_1_3_10_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_11_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.11.1'', SOL_TRACK_1_1_1_3_11_1)) SOL_TRACK_1_1_1_3_11_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_11_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.11.2'', SOL_TRACK_1_1_1_3_11_2)) SOL_TRACK_1_1_1_3_11_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_11_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.11.3'', SOL_TRACK_1_1_1_3_11_3)) SOL_TRACK_1_1_1_3_11_3, ';
 --sqlstring := sqlstring || ' Decode( SOL_TRACK_1_1_1_3_12_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.12.1'', SOL_TRACK_1_1_1_3_12_1)) SOL_TRACK_1_1_1_3_12_1, ';
 sqlstring := sqlstring || ' CODICE_DTP, ';
 sqlstring := sqlstring || ' CODICE_UT, ';
 sqlstring := sqlstring || ' CODICE_LINEA_TECNICA ';
 sqlstring := sqlstring || ' From '|| s_schema||'.BINARI_CORSA_SOL s, ';
 sqlstring := sqlstring ||   s_schema||'.SEZIONI_LINEA sl,';
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_3_3_3 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_3_3_GSM_R_FAC, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.3.3'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_3_3 = CODIFICA_VALORE ';
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring:=sqlstring || ' ) gsm, ';
--
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_3_2_9 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_2_9_COMP_ETCS, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.2.9'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_2_9 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ') comp_etcs, ';
--
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_3_3_5 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_3_5_RETI_GSM_R, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.3.5'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_3_5 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ') reti_gsm_r, ';
--
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_3_3_9 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_3_9_RADIO_VOCE, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.3.9'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_3_9 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) radio_voce, ';
--
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (Valore, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_3_3_10 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_3_10_RADIO_DATI, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.3.10'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_3_10 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) radio_dati, ';
 --
 sqlstring := sqlstring || '(Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (Valore, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_3_5_3 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_5_3_SIST_PRE_PROT, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.5.3'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_5_3 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) Sist_Pre_Prot, ';
 --
 sqlstring := sqlstring || '(Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (Valore, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_3_7_11_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_7_11_1_CARMIN_ASSE, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.7.11.1'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_7_11_1 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) Carmin_Asse, ';
 --
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_3_7_1_3 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_7_1_3_SISTRILTRAIN, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.7.1.3'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_7_1_3 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) sistriltrain, ';
 --
 sqlstring := sqlstring || ' ( Select bcs.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_3_1_1_AP SOL_TRACK_1_1_1_3_1_1_AP, ';
 sqlstring := sqlstring || ' Decode (SOL_TRACK_1_1_1_3_1_1_AP, ';
 sqlstring := sqlstring || ' ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_3_1_1) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_3_1_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS dic, ';
 sqlstring := sqlstring ||  s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring ||  s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where  dic.TIPO_DICHIARAZIONE = ''EC'' ';
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = sl.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' And bcs.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || ' Union ';
 sqlstring := sqlstring || ' Select DIC.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' ''NYA'' SOL_TRACK_1_1_1_3_1_1_AP, ';
 sqlstring := sqlstring || ' '' '' SOL_TRACK_1_1_1_3_1_1 ';
 sqlstring := sqlstring || ' From (Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.BINARI_CORSA_SOL bcs ';
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Minus ';
 sqlstring := sqlstring || ' Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS ';
 sqlstring := sqlstring || ' Where TIPO_DICHIARAZIONE = ''EC''  ';
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ')  dic, ';
 sqlstring := sqlstring ||   s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring ||   s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = Sl.SEDE_TECNICA ';
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ') dich_ec_ccs ';
 sqlstring := sqlstring || ' Where  s.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = gsm.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = comp_etcs.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = reti_gsm_r.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = radio_voce.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = radio_dati.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = Sist_Pre_Prot.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = sistriltrain.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = Carmin_Asse.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = dich_ec_ccs.SOL_TRACK_1_1_1_0_0_1(+) ';
-- 
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And s.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = s.CODICE_VERSIONE ';
 End If;

 --filtro richiamato dalla funzione ROUTING
 If p_filtro Is Not Null 
 Then
    sqlstring := sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'SL.SEDE_TECNICA');
 End If;
 --sqlstring:=sqlstring || '          ORDER BY 1 ';
 --
 DBMS_OUTPUT.PUT_LINE(sqlstring);
 OPEN p_cursor FOR sqlstring;
END GetSOLParametriCCS;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetGallerieSOL (p_area NUMBER,p_i_versione NUMBER  ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.6

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) 
 THEN
    p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
    IF  p_i_versione IS NULL 
    THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
    ELSE
        p_versione:=p_i_versione;
    END IF;
 END IF;

 sqlstring := 'Select ';
 sqlstring := sqlstring|| ' sez.SEDE_TECNICA, ';
 sqlstring := sqlstring|| ' sez.DEFINIZIONE, ';
 sqlstring := sqlstring|| ' rel.SOL_TRACK_1_1_1_0_0_1 ,    ';
 sqlstring := sqlstring|| ' BINARI.SOL_TRACK_1_1_1_0_0_1_D ,    ';
 sqlstring := sqlstring|| ' SOL_TUNNEL_1_1_1_1_8_1,';
 sqlstring := sqlstring|| ' gal.SOL_TUNNEL_1_1_1_1_8_2, ';
 sqlstring := sqlstring|| ' SOL_TUNNEL_1_1_1_1_8_2_D, ';
 sqlstring := sqlstring|| ' SOL_TUNNEL_1_1_1_1_8_3,';
 sqlstring := sqlstring|| ' SOL_TUNNEL_1_1_1_1_8_4,';
 sqlstring := sqlstring|| ' Decode(ec.SOL_TUNNEL_1_1_1_1_8_5O6_AP, NULL, '' '', ''N'', ''Non applicabile'', ec.SOL_TUNNEL_1_1_1_1_8_5O6) SOL_TUNNEL_1_1_1_1_8_5, ';
 sqlstring := sqlstring|| ' Decode(ei.SOL_TUNNEL_1_1_1_1_8_5O6_AP, NULL, '' '', ''N'', ''Non applicabile'', ei.SOL_TUNNEL_1_1_1_1_8_5O6) SOL_TUNNEL_1_1_1_1_8_6, ';
 sqlstring := sqlstring|| ' SOL_TUNNEL_1_1_1_1_8_7, ';
 sqlstring := sqlstring|| ' Decode(rel.SOL_TUNNEL_1_1_1_1_8_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.8.8'',SOL_TUNNEL_1_1_1_1_8_8)) SOL_TUNNEL_1_1_1_1_8_8, ';
 ---> Modifica del 06/04/2021 adeguamente reg 777/2019
 sqlstring := sqlstring|| ' Decode(rel.SOL_TUNNEL_1_1_1_1_8_8_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', SOL_TUNNEL_1_1_1_1_8_8_1) SOL_TUNNEL_1_1_1_1_8_8_1, ';
 sqlstring := sqlstring|| ' Decode(SOL_TUNNEL_1_1_1_1_8_8_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', SOL_TUNNEL_1_1_1_1_8_8_2) SOL_TUNNEL_1_1_1_1_8_8_2, ';
 ---> Modifica del 06/04/2021 adeguamente reg 777/2019
 sqlstring := sqlstring|| ' Decode(SOL_TUNNEL_1_1_1_1_8_9_AP, ''NYA'', '' '', ''N'', ''Non applicabile'',  PKG_RINF_REPORT.GetDescription(''1.1.1.1.8.9'',SOL_TUNNEL_1_1_1_1_8_9)) SOL_TUNNEL_1_1_1_1_8_9,  ';
 sqlstring := sqlstring|| ' Decode(SOL_TUNNEL_1_1_1_1_8_10_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.8.10'',SOL_TUNNEL_1_1_1_1_8_10) ) SOL_TUNNEL_1_1_1_1_8_10,';
 sqlstring := sqlstring|| ' Decode(SOL_TUNNEL_1_1_1_1_8_11_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.8.11'',SOL_TUNNEL_1_1_1_1_8_11) ) SOL_TUNNEL_1_1_1_1_8_11,';
 sqlstring := sqlstring|| ' sez.CODICE_DTP,';
 sqlstring := sqlstring|| ' CODICE_UT,';
 sqlstring := sqlstring|| ' CODICE_LINEA_TECNICA';
 sqlstring := sqlstring|| ' From '||s_schema||'.GALLERIE_BINARI_SOL gal,';
 sqlstring := sqlstring|| s_schema||'.SEZIONI_LINEA sez,';
 sqlstring := sqlstring|| s_schema||'.REL_GALLERIE_BINARI_SOL rel, ';
 sqlstring := sqlstring|| s_schema||'.BINARI_CORSA_SOL binari,';
 sqlstring := sqlstring|| '( Select SOL_TUNNEL_1_1_1_1_8_2, ';
 sqlstring := sqlstring|| ' Listagg (ec.SOL_TUNNEL_1_1_1_1_8_5O6, '', '') ';
 sqlstring := sqlstring|| ' Within Group (Order By ec.SOL_TUNNEL_1_1_1_1_8_5O6)';
 sqlstring := sqlstring|| ' SOL_TUNNEL_1_1_1_1_8_5O6, ';
 sqlstring := sqlstring|| ' SOL_TUNNEL_1_1_1_1_8_5O6_AP ';
 sqlstring := sqlstring|| ' From (Select SOL_TUNNEL_1_1_1_1_8_2, SOL_TUNNEL_1_1_1_1_8_5O6, SOL_TUNNEL_1_1_1_1_8_5O6_AP  ';
 sqlstring := sqlstring|| ' From '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_SOL  ';
 sqlstring := sqlstring|| ' Where TIPO_DICHIARAZIONE = ''EC''  ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring|| ' And CODICE_VERSIONE = '||p_versione;
 End If;
 sqlstring := sqlstring|| '  ) ec ';
 sqlstring := sqlstring|| ' Group By SOL_TUNNEL_1_1_1_1_8_2,SOL_TUNNEL_1_1_1_1_8_5O6_AP) ec, ';
 sqlstring := sqlstring|| '( Select SOL_TUNNEL_1_1_1_1_8_2, ';
 sqlstring := sqlstring|| '  Listagg (ei.SOL_TUNNEL_1_1_1_1_8_5O6, '', '') ';
 sqlstring := sqlstring|| ' Within Group (Order By ei.SOL_TUNNEL_1_1_1_1_8_5O6) ';
 sqlstring := sqlstring|| ' SOL_TUNNEL_1_1_1_1_8_5O6,';
 sqlstring := sqlstring|| ' SOL_TUNNEL_1_1_1_1_8_5O6_AP   ';
 sqlstring := sqlstring|| ' From (Select SOL_TUNNEL_1_1_1_1_8_2, SOL_TUNNEL_1_1_1_1_8_5O6,SOL_TUNNEL_1_1_1_1_8_5O6_AP  ';
 sqlstring := sqlstring|| ' From '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_SOL  ';
 sqlstring := sqlstring|| ' Where TIPO_DICHIARAZIONE = ''EI''';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring|| ' And CODICE_VERSIONE = '||p_versione;
 End If;
 sqlstring := sqlstring|| ' ) ei  ';
 sqlstring := sqlstring|| ' Group By SOL_TUNNEL_1_1_1_1_8_2,SOL_TUNNEL_1_1_1_1_8_5O6_AP) ei   ';
 sqlstring := sqlstring|| 'Where  rel.SOL_TUNNEL_1_1_1_1_8_2 = gal.SOL_TUNNEL_1_1_1_1_8_2 ';
 sqlstring := sqlstring|| 'And gal.SOL_TUNNEL_1_1_1_1_8_2 = ec.SOL_TUNNEL_1_1_1_1_8_2 (+) ';
 sqlstring := sqlstring|| 'And gal.SOL_TUNNEL_1_1_1_1_8_2 = ei.SOL_TUNNEL_1_1_1_1_8_2 (+) ';
 sqlstring := sqlstring|| 'And REL.SOL_TRACK_1_1_1_0_0_1 = BINARI.SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring|| 'And BINARI.SEDE_TECNICA = SEZ.SEDE_TECNICA  ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring|| 'and sez.codice_versione = rel.CODICE_VERSIONE  ';
    sqlstring := sqlstring|| 'and rel.CODICE_VERSIONE = BINARI.CODICE_VERSIONE ';
    sqlstring := sqlstring|| 'and BINARI.CODICE_VERSIONE = gal.CODICE_VERSIONE ';
    sqlstring := sqlstring|| 'and gal.CODICE_VERSIONE = '||p_versione;
 End If;
 --filtro richiamato dalla funzione ROUTING
 If p_filtro Is Not Null 
 Then
    sqlstring:=sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'Sez.SEDE_TECNICA');
 End If;
 DBMS_OUTPUT.PUT_LINE(sqlstring);
 OPEN p_cursor FOR sqlstring;
END GetGallerieSOL;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetDichiarazioniEC_SOL (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--28/02/2018
--REPORT FLAT SOL

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;

sqlstring:='Select /*+ PARALLEL(default) */  tab_totale.SEDE_TECNICA,  ';       --INSERITA SELECT ESTERNA PER CREARE UNA TABELLA UNICA SU CUI FARE POI LA SOTTOSELEZIONE PER IL ROUTING
sqlstring:=sqlstring|| '     DEFINIZIONE, ';                --in quanto sarebbe troppo oneroso spostare la condizione del routing in ogni union di questa query molto complessa
sqlstring:=sqlstring|| '     CODICE_DTP, ';
sqlstring:=sqlstring|| '     CODICE_UT, ';
sqlstring:=sqlstring|| '     CODICE_OGGETTO, ';
sqlstring:=sqlstring|| '     DESCRIZIONE, ';
sqlstring:=sqlstring|| '     PARAMETRO, ';
sqlstring:=sqlstring|| '     DICHIARAZIONE,  ';
sqlstring:=sqlstring|| '     CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring|| '     FROM ';
sqlstring:=sqlstring|| '     ( ';

sqlstring:=sqlstring|| '     SELECT BCS.SOL_TRACK_1_1_1_0_0_1 "CODICE_OGGETTO",            ';--DICH SOL INF
sqlstring:=sqlstring|| '       BCS.SOL_TRACK_1_1_1_0_0_1_D "DESCRIZIONE",     ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.1.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       SOL_TRACK_1_1_1_1_1_1O2_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (SOL_TRACK_1_1_1_1_1_1O2_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               SOL_TRACK_1_1_1_1_1_1O2) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND DIC.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND DIC.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE=SL.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '       AND BCS.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1(+) ';
sqlstring:=sqlstring|| '       AND BCS.SEDE_TECNICA=SL.SEDE_TECNICA ';
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT DIC.SOL_TRACK_1_1_1_0_0_1 "CODICE_OGGETTO",     '; --DICH ASSENTI
sqlstring:=sqlstring|| '       BCS.SOL_TRACK_1_1_1_0_0_1_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.1.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.BINARI_CORSA_SOL BCS ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '         )  DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE  BCS.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '       AND BCS.SEDE_TECNICA=SL.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND SL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       UNION ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       SELECT BCS.SOL_TRACK_1_1_1_0_0_1 "CODICE_OGGETTO",            ';--DICH SOL ENE
sqlstring:=sqlstring|| '       BCS.SOL_TRACK_1_1_1_0_0_1_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.2.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       SOL_TRACK_1_1_1_2_1_1O2_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (SOL_TRACK_1_1_1_2_1_1O2_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               SOL_TRACK_1_1_1_2_1_1O2) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
sqlstring:=sqlstring|| '       AND BCS.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1(+) ';
sqlstring:=sqlstring|| '       AND SL.SEDE_TECNICA = BCS.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND SL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = DIC.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT DIC.SOL_TRACK_1_1_1_0_0_1 "CODICE_OGGETTO",             ';--DICH ASSENTI
sqlstring:=sqlstring|| '       BCS.SOL_TRACK_1_1_1_0_0_1_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.2.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.BINARI_CORSA_SOL BCS ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '       ) DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE     BCS.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '       AND SL.SEDE_TECNICA = BCS.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND SL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '          ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       UNION ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       SELECT BCS.SOL_TRACK_1_1_1_0_0_1 "CODICE_OGGETTO",            ';--DICH SOL CCS
sqlstring:=sqlstring|| '       BCS.SOL_TRACK_1_1_1_0_0_1_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.3.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       SOL_TRACK_1_1_1_3_1_1_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (SOL_TRACK_1_1_1_3_1_1_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               SOL_TRACK_1_1_1_3_1_1) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = DIC.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '       AND BCS.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1(+) ';
sqlstring:=sqlstring|| '       AND SL.SEDE_TECNICA = BCS.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND SL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT DIC.SOL_TRACK_1_1_1_0_0_1 "CODICE_OGGETTO",                     ';--DICH ASSENTI
sqlstring:=sqlstring|| '       BCS.SOL_TRACK_1_1_1_0_0_1_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.3.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.BINARI_CORSA_SOL BCS ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '   )  DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE     BCS.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '       AND SL.SEDE_TECNICA = BCS.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND SL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       UNION ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       SELECT GAL.SOL_TUNNEL_1_1_1_1_8_2 "CODICE_OGGETTO",            ';--DICH SOL GALLERIA
sqlstring:=sqlstring|| '       GAL.SOL_TUNNEL_1_1_1_1_8_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.1.8.5'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       SOL_TUNNEL_1_1_1_1_8_5O6_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (SOL_TUNNEL_1_1_1_1_8_5O6_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               SOL_TUNNEL_1_1_1_1_8_5O6) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_GALLERIE_BIN_SOL DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.GALLERIE_BINARI_SOL GAL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.REL_GALLERIE_BINARI_SOL REL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND DIC.CODICE_VERSIONE=GAL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE = REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND REL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = SL.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '       AND GAL.SOL_TUNNEL_1_1_1_1_8_2 = DIC.SOL_TUNNEL_1_1_1_1_8_2(+) ';
sqlstring:=sqlstring|| '       AND GAL.SOL_TUNNEL_1_1_1_1_8_2 = REL.SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring:=sqlstring|| '       AND REL.SOL_TRACK_1_1_1_0_0_1 = BCS.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| '       AND BCS.SEDE_TECNICA = SL.SEDE_TECNICA      ';
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT DIC.SOL_TUNNEL_1_1_1_1_8_2 "CODICE_OGGETTO",                    ';--DICH ASSENTI
sqlstring:=sqlstring|| '       GAL.SOL_TUNNEL_1_1_1_1_8_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.1.1.1.8.5'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.GALLERIE_BINARI_SOL ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_GALLERIE_BIN_SOL ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '         )  DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.GALLERIE_BINARI_SOL GAL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.REL_GALLERIE_BINARI_SOL REL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_SOL BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.SEZIONI_LINEA SL ';
sqlstring:=sqlstring|| ' WHERE    DIC.SOL_TUNNEL_1_1_1_1_8_2=GAL.SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring:=sqlstring|| ' AND GAL.SOL_TUNNEL_1_1_1_1_8_2=REL.SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring:=sqlstring|| ' AND REL.SOL_TRACK_1_1_1_0_0_1=BCS.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring:=sqlstring|| ' AND BCS.SEDE_TECNICA=SL.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE  = ' ||p_versione;
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE = REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND REL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = SL.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '         ) tab_totale   ';                      --INSERITA SELECT ESTERNA PER CREARE UNA TABELLA UNICA SU CUI FARE POI LA SOTTOSELEZIONE PER IL ROUTING
sqlstring:=sqlstring|| '         WHERE DEFINIZIONE IS NOT NULL ';       --CODICE INUTILE; SERVE SOLO PER POTER ATTACCARE DOPO LA STRINGA DI SOTTOSELEZIONE DEL ROUTING (CHE INZIA PER 'and')


--filtro richiamato dalla funzione ROUTING
IF p_filtro is NOT NULL THEN
sqlstring:=sqlstring ||GetWhereCondition(p_filtro,'tab_totale.SEDE_TECNICA');
END IF;

DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetDichiarazioniEC_SOL ;
--
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetInfoGeneraliPO (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--Ritorna i parametri principali di una OP; attualmente   l'unico blocco di parametri a non avere un report in 3.6
--16/06/2017 inserito dietro richiesta di Schillaci (rif. e-mail Schillaci 4/5/2017)

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) 
 THEN
    p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF p_i_versione IS NULL 
     THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;


sqlstring := 'Select l.SEDE_TECNICA, ';
 sqlstring := sqlstring || 'DEFINIZIONE PO_1_2_0_0_0_1, ';
 sqlstring := sqlstring || ' PO_1_2_0_0_0_2, ';
 sqlstring := sqlstring || ' Decode (PO_1_2_0_0_0_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', codice_taf_tap.CODICE) PO_1_2_0_0_0_3,';
 sqlstring := sqlstring || ' PKG_RINF_REPORT.GetDescription(''1.2.0.0.0.4'', PO_1_2_0_0_0_4) PO_1_2_0_0_0_4,';
 --->
    sqlstring:=sqlstring || ' Decode(PO_1_2_0_0_0_4_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PO_1_2_0_0_0_4_1) PO_1_2_0_0_0_4_1, ';
 sqlstring := sqlstring || '''Latitude (''|| Trim(To_Char(Trunc(LATITUDINE, 4),''999.9999''))|| '') + Longitude (''|| Trim(To_Char(Trunc(LONGITUDINE, 4),''S999.9999''))|| '')'' PO_1_2_0_0_0_5, ';
 sqlstring := sqlstring || ' Nvl(Trim(linea_comm.LINEA),''0000 - 0.000'') PO_1_2_0_0_0_6, ';
--->
    sqlstring:=sqlstring || ' Decode(PO_1_2_3_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PO_1_2_3_1) PO_1_2_3_1, ';
    sqlstring:=sqlstring || ' Decode(PO_1_2_3_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PO_1_2_3_2) PO_1_2_3_2, ';
 sqlstring := sqlstring || ' CODICE_DTP, ';
 sqlstring := sqlstring || ' CODICE_UT, ';
 sqlstring := sqlstring || ' CODICE_LINEA_TECNICA ';
 sqlstring := sqlstring || ' From '||s_schema||'.PUNTI_OPERATIVI l, ';
 If p_versione Is Not Null Then
    sqlstring := sqlstring || ' (Select v.SEDE_TECNICA, Listagg(Replace(CODICE, '' '', '''')||'' - ''||Trim(To_Char(Round(v.KM_INIZIO,3), ''999990.999'')) ,''#'' ) Within Group (Order By CODICE) As LINEA ';
    sqlstring := sqlstring || ' From '||s_schema||'.V_MDR_LINEE_COMMERCIALI v,';
    sqlstring := sqlstring || s_schema||'.PUNTI_OPERATIVI p';
    sqlstring := sqlstring ||' Where  ';
    sqlstring := sqlstring || ' v.CODICE_VERSIONE = p.CODICE_VERSIONE And ';
    sqlstring := sqlstring || ' v.CODICE_VERSIONE = '||p_versione ;
    sqlstring := sqlstring || ' And  p.SEDE_TECNICA = v.SEDE_TECNICA ';
    sqlstring := sqlstring || ' Group By v.SEDE_TECNICA) linea_comm, ';
    sqlstring := sqlstring || '(Select v.SEDE_TECNICA, Listagg(PO_1_2_0_0_0_3, ''#'' ) Within Group (ORDER BY PO_1_2_0_0_0_3) As CODICE ';
    sqlstring := sqlstring || ' From '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v,';
    sqlstring := sqlstring || s_schema||'.PUNTI_OPERATIVI p';
    sqlstring := sqlstring || ' Where  ';
    sqlstring := sqlstring || ' v.CODICE_VERSIONE = p.CODICE_VERSIONE and ';
    sqlstring := sqlstring || ' v.CODICE_VERSIONE = '||p_versione ;
    sqlstring := sqlstring || ' And p.SEDE_TECNICA = v.SEDE_TECNICA ';
    sqlstring := sqlstring || ' Group By v.SEDE_TECNICA) codice_taf_tap, ';
 Else
    sqlstring := sqlstring ||  '(Select v.SEDE_TECNICA, Listagg(Replace(CODICE, '' '', '''')||'' - ''||Trim(To_Char(Round(v.KM_INIZIO,3), ''999990.999'')), ''#'' ) Within Group (Order By CODICE) AS LINEA ';
    sqlstring := sqlstring || ' From '||s_schema||'.V_MDR_LINEE_COMMERCIALI v,';
    sqlstring := sqlstring || s_schema||'.PUNTI_OPERATIVI p';
    sqlstring := sqlstring || ' Where ';
    sqlstring := sqlstring || ' p.SEDE_TECNICA = v.SEDE_TECNICA ';
    sqlstring := sqlstring || ' Group By v.SEDE_TECNICA) linea_comm, ';
    sqlstring := sqlstring || '(Select v.SEDE_TECNICA, Listagg(PO_1_2_0_0_0_3 ,''#'' ) Within Group (Order By PO_1_2_0_0_0_3) As CODICE ';
    sqlstring := sqlstring || ' From '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v,';
    sqlstring := sqlstring || s_schema||'.PUNTI_OPERATIVI p';
    sqlstring := sqlstring || ' Where ';
    sqlstring := sqlstring || ' p.SEDE_TECNICA = v.SEDE_TECNICA ';
    sqlstring := sqlstring || ' Group By v.SEDE_TECNICA) codice_taf_tap, '; 
 End If;
   --
   sqlstring := sqlstring || ' (Select SEDE_TECNICA, ';
   sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
   sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
   sqlstring := sqlstring || '  As PO_1_2_3_2 ';
   sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_2_3_2_DOC_NORME, ';
   sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
   sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
   sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
   sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.2.3.2'' ';
   sqlstring := sqlstring || ' And PO_1_2_3_2 = CODIFICA_VALORE ';
   If p_versione Is Not Null Then
     sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
   End If;
     sqlstring := sqlstring || ' Group By SEDE_TECNICA ';
   If p_versione Is Not Null Then
     sqlstring := sqlstring || ' , CODICE_VERSIONE ';
   End If;
   sqlstring := sqlstring || '  ) doc_norme ';

 sqlstring := sqlstring || ' Where l.SEDE_TECNICA = linea_comm.SEDE_TECNICA (+) ';
 sqlstring := sqlstring || ' And l.SEDE_TECNICA = codice_taf_tap.SEDE_TECNICA (+) ';
 sqlstring := sqlstring || ' And l.SEDE_TECNICA = doc_norme.SEDE_TECNICA (+) ';
If p_versione Is Not Null Then
   sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
End If;

--filtro richiamato dalla funzione ROUTING
If p_filtro Is Not Null Then
   sqlstring:=sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'l.SEDE_TECNICA');
End If;

--sqlstring := sqlstring || 'order by 1 ';

 OPEN p_cursor FOR sqlstring;
  Dbms_Output.Put_Line(sqlstring);

 OPEN p_cursor FOR sqlstring;
 DBMS_OUTPUT.PUT_LINE(sqlstring);
END GetInfoGeneraliPO;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetPOParametriINF (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.7

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) 
 THEN
    p_versione:=NULL;
 ELSE 
    IF p_i_versione IS NULL 
    THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;

 sqlstring := 'Select  ';
 sqlstring := sqlstring || ' po.SEDE_TECNICA, ';
 sqlstring := sqlstring || ' po.DEFINIZIONE, ';
 sqlstring := sqlstring || ' NVL (bcp.PO_TRACK_1_2_1_0_0_1, ''0083'') PO_TRACK_1_2_1_0_0_1, ';
 sqlstring := sqlstring || ' bcp.PO_TRACK_1_2_1_0_0_2, ';
 sqlstring := sqlstring || ' PO_TRACK_1_2_1_0_0_2_D, ';
 sqlstring := sqlstring || ' PO_TRACK_1_2_1_0_1_1, ';
 sqlstring := sqlstring || ' PO_TRACK_1_2_1_0_1_2, ';
 sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_2_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.1.0.2.1'', cat_ten.PO_TRACK_1_2_1_0_2_1)) PO_TRACK_1_2_1_0_2_1, ';
 sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_2_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.1.0.2.2'', cat_linea.PO_TRACK_1_2_1_0_2_2)) PO_TRACK_1_2_1_0_2_2, ';
 sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_2_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.1.0.2.3'', corridoio.PO_TRACK_1_2_1_0_2_3)) PO_TRACK_1_2_1_0_2_3, ';
 --sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_3_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.1.0.3.1'', PO_TRACK_1_2_1_0_3_1)) PO_TRACK_1_2_1_0_3_1, ';
 --sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_3_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.1.0.3.2'', PO_TRACK_1_2_1_0_3_2)) PO_TRACK_1_2_1_0_3_2, ';
 --sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_3_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.1.0.3.3'', PO_TRACK_1_2_1_0_3_3)) PO_TRACK_1_2_1_0_3_3, ';
 ---> inizio modifica reg 777/2109 del 06/04/2021
 sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_3_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.1.0.3.4.SUP'', PO_TRACK_1_2_1_0_3_4_SUP)||'' + ''||PKG_RINF_REPORT.GetDescription(''1.2.1.0.3.4.INF'', PO_TRACK_1_2_1_0_3_4_INF)) PO_TRACK_1_2_1_0_3_4, ';
 sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_3_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.1.0.3.5.A'', PO_TRACK_1_2_1_0_3_5_A)) PO_TRACK_1_2_1_0_3_5, ';
 sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_3_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PO_TRACK_1_2_1_0_3_6) PO_TRACK_1_2_1_0_3_6, ';
 ---> fine modifica        
 sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_4_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.1.0.4.1'', PO_TRACK_1_2_1_0_4_1)) PO_TRACK_1_2_1_0_4_1, ';
 sqlstring := sqlstring || ' CODICE_DTP, ';
 sqlstring := sqlstring || ' CODICE_UT, ';
 sqlstring := sqlstring || ' CODICE_LINEA_TECNICA ';
 sqlstring := sqlstring || ' From '|| s_schema||'.BINARI_CORSA_PO bcp, ';
 sqlstring := sqlstring || s_schema||'.REL_PO_BINARI_CORSA rel, ';
 sqlstring := sqlstring || s_schema||'.PUNTI_OPERATIVI po, ';
 sqlstring := sqlstring || ' (Select PO_TRACK_1_2_1_0_0_2, ';
 sqlstring := sqlstring || ' Listagg (Valore, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As PO_TRACK_1_2_1_0_2_1 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.PAR_1_2_1_0_2_1_CAT_TEN_PO v, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.2.1.0.2.1'' ';
 sqlstring := sqlstring || ' And PO_TRACK_1_2_1_0_2_1 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And v.CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By PO_TRACK_1_2_1_0_0_2) cat_ten, ';
 sqlstring := sqlstring || ' (Select PO_TRACK_1_2_1_0_0_2, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As PO_TRACK_1_2_1_0_2_2 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_2_1_0_2_2_CAT_LINEA v, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.2.1.0.2.2'' ';
 sqlstring := sqlstring || ' And PO_TRACK_1_2_1_0_2_2 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And v.CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring:=sqlstring || ' Group By PO_TRACK_1_2_1_0_0_2) cat_linea, ';
 sqlstring := sqlstring || ' (Select SEDE_TECNICA, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As PO_TRACK_1_2_1_0_2_3 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.V_OP_CONTESTO_GEOGRAFICO v, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.2.1.0.2.3'' ';
 sqlstring := sqlstring || ' And CODICE || ''0'' = CODIFICA_VALORE ';
 sqlstring := sqlstring || ' And CODICE_CONTESTO = 3 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SEDE_TECNICA ';
 sqlstring := sqlstring || ' Union ';
 sqlstring := sqlstring || ' Select SEDE_TECNICA, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') Within Group (Order By VALORE_XML) ';
 sqlstring := sqlstring || ' As PO_TRACK_1_2_1_0_2_3 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.1.2.3'' ';
 sqlstring := sqlstring || ' And CODICE || ''0'' = CODIFICA_VALORE ';
 sqlstring := sqlstring || ' And CODICE_CONTESTO = 3 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SEDE_TECNICA) corridoio, ';
 sqlstring := sqlstring || ' (Select bcp.PO_TRACK_1_2_1_0_0_2, ';
 sqlstring := sqlstring || ' PO_TRACK_1_2_1_0_1_1O2_AP PO_TRACK_1_2_1_0_1_1_AP, ';
 sqlstring := sqlstring || ' Decode (PO_TRACK_1_2_1_0_1_1O2_AP, ';
 sqlstring := sqlstring || ' ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' PO_TRACK_1_2_1_0_1_1O2) ';
 sqlstring := sqlstring || ' PO_TRACK_1_2_1_0_1_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.DICHIARAZIONI_BINARIO_PO dic, ';
 sqlstring := sqlstring || s_schema||'.REL_PO_BINARI_CORSA rel, ';
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_PO bcp, ';
 sqlstring := sqlstring || s_schema||'.PUNTI_OPERATIVI PO ';
 sqlstring := sqlstring || ' Where dic.TIPO_DICHIARAZIONE = ''EC'' ';
 sqlstring := sqlstring || ' And dic.PO_TRACK_1_2_1_0_0_2 = rel.PO_TRACK_1_2_1_0_0_2 ';
 sqlstring := sqlstring || ' And rel.SEDE_TECNICA = po.SEDE_TECNICA ';
 sqlstring := sqlstring || ' And bcp.PO_TRACK_1_2_1_0_0_2 = dic.PO_TRACK_1_2_1_0_0_2(+) ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And bcp.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And  po.CODICE_VERSIONE = bcp.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And rel.CODICE_VERSIONE = bcp.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And bcp.CODICE_VERSIONE = dic.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' Union ';
 sqlstring := sqlstring || ' Select BCP.PO_TRACK_1_2_1_0_0_2, ';
 sqlstring := sqlstring || ' ''NYA'' PO_TRACK_1_2_1_0_1_1_AP, ';
 sqlstring := sqlstring || ' '' '' PO_TRACK_1_2_1_0_1_1 ';
 sqlstring := sqlstring || ' From (Select PO_TRACK_1_2_1_0_0_2 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.BINARI_CORSA_PO bcp ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Minus ';
 sqlstring := sqlstring || ' Select PO_TRACK_1_2_1_0_0_2 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.DICHIARAZIONI_BINARIO_PO ';
 sqlstring := sqlstring || ' Where TIPO_DICHIARAZIONE = ''EC'' ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ') dic, ';
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_PO bcp, ';
 sqlstring := sqlstring || s_schema||'.REL_PO_BINARI_CORSA rel, ';
 sqlstring := sqlstring || s_schema||'.PUNTI_OPERATIVI po ';
 sqlstring := sqlstring || ' Where bcp.PO_TRACK_1_2_1_0_0_2 = dic.PO_TRACK_1_2_1_0_0_2 ';
 sqlstring := sqlstring || ' And po.SEDE_TECNICA = rel.SEDE_TECNICA ';
 sqlstring := sqlstring || ' And rel.PO_TRACK_1_2_1_0_0_2 = bcp.PO_TRACK_1_2_1_0_0_2 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And bcp.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And po.CODICE_VERSIONE = bcp.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And rel.CODICE_VERSIONE = bcp.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '  ) dich_ec, ';
 sqlstring := sqlstring || ' (Select BCP.PO_TRACK_1_2_1_0_0_2, ';
 sqlstring := sqlstring || ' PO_TRACK_1_2_1_0_1_1O2_AP PO_TRACK_1_2_1_0_1_2_AP, ';
 sqlstring := sqlstring || ' Decode (PO_TRACK_1_2_1_0_1_1O2_AP, ';
 sqlstring := sqlstring || ' ''NYA'','' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' PO_TRACK_1_2_1_0_1_1O2) ';
 sqlstring := sqlstring || ' PO_TRACK_1_2_1_0_1_2 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.DICHIARAZIONI_BINARIO_PO dic, ';
 sqlstring := sqlstring || s_schema||'.REL_PO_BINARI_CORSA rel, ';
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_PO bcp, ';
 sqlstring := sqlstring || s_schema||'.PUNTI_OPERATIVI po ';
 sqlstring := sqlstring || ' Where dic.TIPO_DICHIARAZIONE = ''EI'' ';
 sqlstring := sqlstring || ' And dic.PO_TRACK_1_2_1_0_0_2 = rel.PO_TRACK_1_2_1_0_0_2 ';
 sqlstring := sqlstring || ' And rel.SEDE_TECNICA = po.SEDE_TECNICA ';
 sqlstring := sqlstring || ' And bcp.PO_TRACK_1_2_1_0_0_2 = dic.PO_TRACK_1_2_1_0_0_2(+) ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' and bcp.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' and po.CODICE_VERSIONE = bcp.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' and rel.CODICE_VERSIONE = bcp.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' and bcp.CODICE_VERSIONE = dic.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '  Union ';
 sqlstring := sqlstring || '  Select bcp.PO_TRACK_1_2_1_0_0_2, ';
 sqlstring := sqlstring || ' ''NYA'' PO_TRACK_1_2_1_0_1_2_AP, ';
 sqlstring := sqlstring || ' '' '' PO_TRACK_1_2_1_0_1_2 ';
 sqlstring := sqlstring || ' From (Select PO_TRACK_1_2_1_0_0_2 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.BINARI_CORSA_PO bcp ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Minus ';
 sqlstring := sqlstring || ' Select PO_TRACK_1_2_1_0_0_2 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.DICHIARAZIONI_BINARIO_PO ';
 sqlstring := sqlstring || ' Where TIPO_DICHIARAZIONE = ''EI'' ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' ) dic, ';
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_PO bcp, ';
 sqlstring := sqlstring || s_schema||'.REL_PO_BINARI_CORSA rel, ';
 sqlstring := sqlstring || s_schema||'.PUNTI_OPERATIVI po ';
 sqlstring := sqlstring || ' Where bcp.PO_TRACK_1_2_1_0_0_2 = dic.PO_TRACK_1_2_1_0_0_2 ';
 sqlstring := sqlstring || ' And po.SEDE_TECNICA = rel.SEDE_TECNICA ';
 sqlstring := sqlstring || ' And rel.PO_TRACK_1_2_1_0_0_2 = bcp.PO_TRACK_1_2_1_0_0_2 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And bcp.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And po.CODICE_VERSIONE = bcp.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And rel.CODICE_VERSIONE = bcp.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) dich_ie ';
 sqlstring := sqlstring || ' Where bcp.PO_TRACK_1_2_1_0_0_2 = cat_ten.PO_TRACK_1_2_1_0_0_2(+) ';
 sqlstring := sqlstring || ' And bcp.PO_TRACK_1_2_1_0_0_2 = cat_linea.PO_TRACK_1_2_1_0_0_2(+) ';
 sqlstring := sqlstring || ' And Substr (bcp.PO_TRACK_1_2_1_0_0_2, 1, 6) = corridoio.SEDE_TECNICA(+) ';
 sqlstring := sqlstring || ' And bcp.PO_TRACK_1_2_1_0_0_2 = dich_ec.PO_TRACK_1_2_1_0_0_2(+) ';
 sqlstring := sqlstring || ' And bcp.PO_TRACK_1_2_1_0_0_2 = dich_ie.PO_TRACK_1_2_1_0_0_2(+) ';
 sqlstring := sqlstring || ' And bcp.PO_TRACK_1_2_1_0_0_2 = rel.PO_TRACK_1_2_1_0_0_2 ';
 sqlstring := sqlstring || ' And rel.SEDE_TECNICA = po.SEDE_TECNICA ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And bcp.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And bcp.CODICE_VERSIONE = rel.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And rel.CODICE_VERSIONE = po.CODICE_VERSIONE ';
 End If;

 --filtro richiamato dalla funzione ROUTING
 If p_filtro Is Not Null 
 Then
    sqlstring := sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'po.SEDE_TECNICA');
 End If;
  --sqlstring:=sqlstring || ' ORDER BY 1 ';
 DBMS_OUTPUT.PUT_LINE(sqlstring);
 OPEN p_cursor FOR sqlstring;
END GetPOParametriINF;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
--
PROCEDURE GetMarciapiedi (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.8

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;
s_filtro VARCHAR2(32767);

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;
--



 -- inserita una tabella "esterna" per poter fare l'ORDER dei marciapiedi nel ROUTING
sqlstring:=' Select ';
sqlstring:=sqlstring ||'SEDE_TECNICA, ';
sqlstring:=sqlstring ||'DEFINIZIONE, ';
sqlstring:=sqlstring ||'BINARIO, ';
sqlstring:=sqlstring ||'PO_TRACK_1_2_1_0_0_2_D, ';
sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_1, ';
sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_2, ';
sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_2_D , ';
sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_4, ';
sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_5, ';
sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_6 , ';
sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_7, ';
sqlstring:=sqlstring ||'CODICE_DTP, ';
sqlstring:=sqlstring ||'CODICE_UT, ';
sqlstring:=sqlstring ||'CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring ||' From ( ';
--
sqlstring:=sqlstring ||'Select Distinct ';
sqlstring:=sqlstring ||'PO.SEDE_TECNICA, ';
sqlstring:=sqlstring ||'PO.DEFINIZIONE, ';
sqlstring:=sqlstring ||'CODICE_DTP, ';
sqlstring:=sqlstring ||'CODICE_UT, ';
sqlstring:=sqlstring ||'BINARIO_1 BINARIO, ';      ---> Binario_1
sqlstring:=sqlstring ||'bin_po.PO_TRACK_1_2_1_0_0_2_D, ';
sqlstring:=sqlstring ||'NVL (PO_TR_PLATFORM_1_2_1_0_6_1, ''0083'') PO_TR_PLATFORM_1_2_1_0_6_1, ';
sqlstring:=sqlstring ||'b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
sqlstring:=sqlstring ||'b.PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
--sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_3_AP, ';
sqlstring:=sqlstring ||'Decode(PO_TR_PLATFORM_1_2_1_0_6_3_AP,''NYA'', '' '', ''N'', ''Non applicabile'', Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.3'',cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3)) PO_TR_PLATFORM_1_2_1_0_6_3, ';
--sqlstring:=sqlstring ||'PO_TR_PLAT_1_2_1_0_6_4_B1_AP PO_TR_PLAT_1_2_1_0_6_4_AP, ';
sqlstring:=sqlstring ||'Decode(PO_TR_PLAT_1_2_1_0_6_4_B1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.4.B1'',PO_TR_PLATFORM_1_2_1_0_6_4_B1)) PO_TR_PLATFORM_1_2_1_0_6_4, ';
--sqlstring:=sqlstring ||'PO_TR_PLAT_1_2_1_0_6_5_B1_AP PO_TR_PLAT_1_2_1_0_6_5_AP, ';
sqlstring:=sqlstring ||'Decode(PO_TR_PLAT_1_2_1_0_6_5_B1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.5.B1'',PO_TR_PLATFORM_1_2_1_0_6_5_B1)) PO_TR_PLATFORM_1_2_1_0_6_5, ';
--sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_6_AP, ';
sqlstring:=sqlstring ||'Decode (PO_TR_PLATFORM_1_2_1_0_6_6_AP, ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring ||'Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.6'', PO_TR_PLATFORM_1_2_1_0_6_6)) PO_TR_PLATFORM_1_2_1_0_6_6, ';
--sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_7_AP, ';
sqlstring:=sqlstring ||'Decode (PO_TR_PLATFORM_1_2_1_0_6_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring ||'Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.7'', PO_TR_PLATFORM_1_2_1_0_6_7)) PO_TR_PLATFORM_1_2_1_0_6_7, ';
sqlstring:=sqlstring ||'CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring ||'From  '|| s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
sqlstring:=sqlstring ||'(  Select PO_TR_PLATFORM_1_2_1_0_6_2, ';
If p_versione Is Not Null Then
     sqlstring:=sqlstring ||'CODICE_VERSIONE, ';
End If;
sqlstring:=sqlstring ||'Listagg (VALORE, '';'') ';
sqlstring:=sqlstring ||'Within Group (Order By VALORE) ';
sqlstring:=sqlstring ||'As PO_TR_PLATFORM_1_2_1_0_6_3 ';
sqlstring:=sqlstring ||'From  '|| s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v, ';
sqlstring:=sqlstring ||'Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO d, ';
sqlstring:=sqlstring ||'Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI c ';
sqlstring:=sqlstring ||'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
sqlstring:=sqlstring ||'And NUMERO_PARAMETRO = ''1.2.1.0.6.3'' ';
sqlstring:=sqlstring ||'And PO_TR_PLATFORM_1_2_1_0_6_3 = CODIFICA_VALORE ';
sqlstring:=sqlstring ||'Group By PO_TR_PLATFORM_1_2_1_0_6_2 ';
If p_versione Is Not Null Then
     sqlstring:=sqlstring ||', CODICE_VERSIONE ';
End If;
sqlstring:=sqlstring ||' ) cat_ten, ';
sqlstring:=sqlstring ||' '|| s_schema||'.BINARI_CORSA_PO bin_po, ';
sqlstring:=sqlstring ||' '|| s_schema||'.REL_PO_BINARI_CORSA Rel, ';
sqlstring:=sqlstring ||' '|| s_schema||'.PUNTI_OPERATIVI Po ';
sqlstring:=sqlstring ||'Where  b.PO_TR_PLATFORM_1_2_1_0_6_2 = cat_ten.PO_TR_PLATFORM_1_2_1_0_6_2(+) ';
sqlstring:=sqlstring ||'And Rel.SEDE_TECNICA = Po.SEDE_TECNICA ';
sqlstring:=sqlstring ||'And BINARIO_1 = Rel.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring ||'And BINARIO_1 = bin_po.PO_TRACK_1_2_1_0_0_2 ';
--->
--  sqlstring:=sqlstring ||'And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) = PO.SEDE_TECNICA ';
--  oppure:
   sqlstring := sqlstring || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) in (Select Po.SEDE_TECNICA From Dual ';
   sqlstring := sqlstring || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = Po.SEDE_TECNICA ' ;
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring ||') ';
--->
If p_versione Is Not Null Then
     sqlstring:=sqlstring ||'And b.CODICE_VERSIONE  = ' ||p_versione;
     sqlstring:=sqlstring ||'And b.CODICE_VERSIONE = cat_ten.CODICE_VERSIONE(+) ';
     sqlstring:=sqlstring ||'And b.CODICE_VERSIONE = bin_po.CODICE_VERSIONE ';
     sqlstring:=sqlstring ||'And b.CODICE_VERSIONE = Rel.CODICE_VERSIONE ';
     sqlstring:=sqlstring ||'And Rel.CODICE_VERSIONE = Po.CODICE_VERSIONE ';
End If;
--filtro richiamato dalla funzione ROUTING DA INSERIRE 4 VOLTE, UNA PER OGNI MARCIAPIEDE; qui   per MARC 1
If p_filtro Is Not Null Then
     s_filtro := Upper(Pkg_Rinf_Report.GetWhereCondition(p_filtro,'PO.SEDE_TECNICA'));
     sqlstring := sqlstring ||Substr(s_filtro, 1, Instr(s_filtro, 'ORDER') -1);   --siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
End If;

--
sqlstring:=sqlstring ||'Union ';
--
sqlstring:=sqlstring ||'Select Distinct ';
sqlstring:=sqlstring ||'po.SEDE_TECNICA, ';
sqlstring:=sqlstring ||'po.DEFINIZIONE, ';
sqlstring:=sqlstring ||'CODICE_DTP, ';
sqlstring:=sqlstring ||'CODICE_UT, ';
sqlstring:=sqlstring ||'BINARIO_2 BINARIO, ';
sqlstring:=sqlstring ||'bin_po.PO_TRACK_1_2_1_0_0_2_D, ';
sqlstring:=sqlstring ||'NVL (PO_TR_PLATFORM_1_2_1_0_6_1, ''0083'') PO_TR_PLATFORM_1_2_1_0_6_1, ';
sqlstring:=sqlstring ||'b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
sqlstring:=sqlstring ||'b.PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
--sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_3_AP, ';
sqlstring:=sqlstring ||'Decode(PO_TR_PLATFORM_1_2_1_0_6_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.3'', cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3)) PO_TR_PLATFORM_1_2_1_0_6_3, ';
--sqlstring:=sqlstring ||'PO_TR_PLAT_1_2_1_0_6_4_B2_AP PO_TR_PLAT_1_2_1_0_6_4_AP, ';
sqlstring:=sqlstring ||'Decode(PO_TR_PLAT_1_2_1_0_6_4_B2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.4.B2'', PO_TR_PLATFORM_1_2_1_0_6_4_B2)) PO_TR_PLATFORM_1_2_1_0_6_4, ';
--sqlstring:=sqlstring ||'PO_TR_PLAT_1_2_1_0_6_5_B2_AP PO_TR_PLAT_1_2_1_0_6_5_AP, ';
sqlstring:=sqlstring ||'Decode(PO_TR_PLAT_1_2_1_0_6_5_B2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.5.B2'', PO_TR_PLATFORM_1_2_1_0_6_5_B2)) PO_TR_PLATFORM_1_2_1_0_6_5, ';
--sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_6_AP, ';
sqlstring:=sqlstring ||'Decode (PO_TR_PLATFORM_1_2_1_0_6_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring ||'Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.6'', PO_TR_PLATFORM_1_2_1_0_6_6)) PO_TR_PLATFORM_1_2_1_0_6_6, ';
--sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_7_AP, ';
sqlstring:=sqlstring ||'Decode (PO_TR_PLATFORM_1_2_1_0_6_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring ||'Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.7'', PO_TR_PLATFORM_1_2_1_0_6_7)) PO_TR_PLATFORM_1_2_1_0_6_7, ';
sqlstring:=sqlstring ||'CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring ||'From '|| s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
sqlstring:=sqlstring ||'( Select PO_TR_PLATFORM_1_2_1_0_6_2, ';
If p_versione Is Not Null Then
     sqlstring := sqlstring ||'CODICE_VERSIONE, ';
End If;
sqlstring:=sqlstring ||'Listagg (VALORE, '';'') ';
sqlstring:=sqlstring ||'Within Group (Order By VALORE) As PO_TR_PLATFORM_1_2_1_0_6_3 ';
sqlstring:=sqlstring ||'From  '|| s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v, ';
sqlstring:=sqlstring ||'Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO d, ';
sqlstring:=sqlstring ||'Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI c ';
sqlstring:=sqlstring ||'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
sqlstring:=sqlstring ||'And NUMERO_PARAMETRO = ''1.2.1.0.6.3'' ';
sqlstring:=sqlstring ||'And PO_TR_PLATFORM_1_2_1_0_6_3 = CODIFICA_VALORE ';
sqlstring:=sqlstring ||'Group By PO_TR_PLATFORM_1_2_1_0_6_2 ';
If p_versione Is Not Null Then
     sqlstring := sqlstring ||', CODICE_VERSIONE ';
End If;
sqlstring:=sqlstring ||' ) cat_ten, ';
sqlstring:=sqlstring ||' '|| s_schema||'.BINARI_CORSA_PO bin_po, ';
sqlstring:=sqlstring ||' '|| s_schema||'.REL_PO_BINARI_CORSA rel, ';
sqlstring:=sqlstring ||' '|| s_schema||'.PUNTI_OPERATIVI po ';
sqlstring:=sqlstring ||'Where b.PO_TR_PLATFORM_1_2_1_0_6_2 = cat_ten.PO_TR_PLATFORM_1_2_1_0_6_2(+) ';
sqlstring:=sqlstring ||'And rel.SEDE_TECNICA = po.SEDE_TECNICA  ';
sqlstring:=sqlstring ||'And BINARIO_2 = rel.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring ||'And BINARIO_2 = bin_po.PO_TRACK_1_2_1_0_0_2 ';
--->
--  sqlstring:=sqlstring ||'And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) = PO.SEDE_TECNICA ';
--  oppure:
   sqlstring := sqlstring || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) in (Select Po.SEDE_TECNICA From Dual ';
   sqlstring := sqlstring || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = Po.SEDE_TECNICA ' ;
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring ||') ';
--->

If p_versione Is Not Null Then
     sqlstring := sqlstring ||' And b.CODICE_VERSIONE = ' ||p_versione;
     sqlstring := sqlstring ||' And b.CODICE_VERSIONE = cat_ten.CODICE_VERSIONE(+) ';
     sqlstring := sqlstring ||' And b.CODICE_VERSIONE = bin_po.CODICE_VERSIONE ';
     sqlstring := sqlstring ||' And b.CODICE_VERSIONE = rel.CODICE_VERSIONE ';
     sqlstring := sqlstring ||' And rel.CODICE_VERSIONE = po.CODICE_VERSIONE ';
END IF;

--filtro richiamato dalla funzione ROUTING DA INSERIRE 4 VOLTE, UNA PER OGNI MARCIAPIEDE; qui   per MARC 2
If p_filtro Is Not Null Then
     s_filtro := Upper(Pkg_Rinf_Report.GetWhereCondition(p_filtro,'PO.SEDE_TECNICA'));
     sqlstring := sqlstring ||Substr(s_filtro, 1, Instr(s_filtro, 'ORDER') -1);   --siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
End If;
--
sqlstring:=sqlstring ||'Union ';
sqlstring:=sqlstring ||'Select Distinct ';
sqlstring:=sqlstring ||'po.SEDE_TECNICA, ';
sqlstring:=sqlstring ||'po.DEFINIZIONE, ';
sqlstring:=sqlstring ||'CODICE_DTP, ';
sqlstring:=sqlstring ||'CODICE_UT, ';
sqlstring:=sqlstring ||'BINARIO_3 BINARIO, ';
sqlstring:=sqlstring ||'bin_po.PO_TRACK_1_2_1_0_0_2_D, ';
sqlstring:=sqlstring ||'Nvl (PO_TR_PLATFORM_1_2_1_0_6_1, ''0083'') PO_TR_PLATFORM_1_2_1_0_6_1, ';
sqlstring:=sqlstring ||'b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
sqlstring:=sqlstring ||'b.PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
--sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_3_AP, ';
sqlstring:=sqlstring ||'Decode(PO_TR_PLATFORM_1_2_1_0_6_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.3'',cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3)) PO_TR_PLATFORM_1_2_1_0_6_3, ';
--sqlstring:=sqlstring ||'PO_TR_PLAT_1_2_1_0_6_4_B3_AP PO_TR_PLAT_1_2_1_0_6_4_AP, ';
sqlstring:=sqlstring ||'Decode(PO_TR_PLAT_1_2_1_0_6_4_B3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.4.B3'',PO_TR_PLATFORM_1_2_1_0_6_4_B3)) PO_TR_PLATFORM_1_2_1_0_6_4, ';
--sqlstring:=sqlstring ||'PO_TR_PLAT_1_2_1_0_6_5_B3_AP PO_TR_PLAT_1_2_1_0_6_5_AP, ';
sqlstring:=sqlstring ||'Decode(PO_TR_PLAT_1_2_1_0_6_5_B3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.5.B3'',PO_TR_PLATFORM_1_2_1_0_6_5_B3)) PO_TR_PLATFORM_1_2_1_0_6_5, ';
--sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_6_AP, ';
sqlstring:=sqlstring ||'Decode (PO_TR_PLATFORM_1_2_1_0_6_6_AP, ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring ||'Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.6'', PO_TR_PLATFORM_1_2_1_0_6_6)) PO_TR_PLATFORM_1_2_1_0_6_6, ';
--sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_7_AP, ';
sqlstring:=sqlstring ||'Decode (PO_TR_PLATFORM_1_2_1_0_6_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring ||'Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.7'', PO_TR_PLATFORM_1_2_1_0_6_7)) PO_TR_PLATFORM_1_2_1_0_6_7, ';
sqlstring:=sqlstring ||'CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring ||'From  '|| s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
sqlstring:=sqlstring ||' (  Select PO_TR_PLATFORM_1_2_1_0_6_2, ';
If p_versione IS Not Null Then
     sqlstring := sqlstring ||'CODICE_VERSIONE, ';
End If;
sqlstring:=sqlstring ||'Listagg (VALORE, '';'') Within Group (Order By VALORE) as PO_TR_PLATFORM_1_2_1_0_6_3 ';
sqlstring:=sqlstring ||'From  '|| s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v, ';
sqlstring:=sqlstring ||'Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO d, ';
sqlstring:=sqlstring ||'Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI c ';
sqlstring:=sqlstring ||'Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
sqlstring:=sqlstring ||'And NUMERO_PARAMETRO = ''1.2.1.0.6.3'' ';
sqlstring:=sqlstring ||'And PO_TR_PLATFORM_1_2_1_0_6_3 = CODIFICA_VALORE ';
sqlstring:=sqlstring ||'Group By PO_TR_PLATFORM_1_2_1_0_6_2 ';
If p_versione Is Not Null Then
     sqlstring := sqlstring ||', CODICE_VERSIONE ';
End If;
sqlstring:=sqlstring ||') cat_ten, ';
sqlstring:=sqlstring ||' '|| s_schema||'.BINARI_CORSA_PO bin_po, ';
sqlstring:=sqlstring ||' '|| s_schema||'.REL_PO_BINARI_CORSA rel, ';
sqlstring:=sqlstring ||' '|| s_schema||'.PUNTI_OPERATIVI po ';
sqlstring:=sqlstring ||'WHERE b.PO_TR_PLATFORM_1_2_1_0_6_2 =  cat_ten.PO_TR_PLATFORM_1_2_1_0_6_2(+) ';
sqlstring:=sqlstring ||'And rel.SEDE_TECNICA = PO.SEDE_TECNICA ';
sqlstring:=sqlstring ||'And BINARIO_3 = rel.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring ||'And BINARIO_3 = bin_po.PO_TRACK_1_2_1_0_0_2 ';
--->
--  sqlstring:=sqlstring ||'And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) = PO.SEDE_TECNICA ';
--  oppure:
   sqlstring := sqlstring || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) in (Select Po.SEDE_TECNICA From Dual ';
   sqlstring := sqlstring || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = Po.SEDE_TECNICA ' ;
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring ||') ';
--->

If p_versione Is Not Null Then
     sqlstring := sqlstring ||'And b.CODICE_VERSIONE = ' ||p_versione;
     sqlstring := sqlstring ||'And b.CODICE_VERSIONE = cat_ten.CODICE_VERSIONE(+) ';
     sqlstring := sqlstring ||'And b.CODICE_VERSIONE = bin_po.CODICE_VERSIONE ';
     sqlstring := sqlstring ||'And b.CODICE_VERSIONE = rel.CODICE_VERSIONE ';
     sqlstring := sqlstring ||'And REL.CODICE_VERSIONE = po.CODICE_VERSIONE ';
End If;
--
--filtro richiamato dalla funzione ROUTING DA INSERIRE 4 VOLTE, UNA PER OGNI MARCIAPIEDE; qui   per MARC 3
If p_filtro Is Not Null Then
     s_filtro := Upper(PKg_Rinf_Report.GetWhereCondition(p_filtro, 'PO.SEDE_TECNICA'));
     sqlstring := sqlstring ||Substr(s_filtro, 1, Instr(s_filtro, 'ORDER') -1);   --siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
End If;
--
sqlstring:=sqlstring ||'Union ';
sqlstring:=sqlstring ||'Select Distinct ';
sqlstring:=sqlstring ||'po.SEDE_TECNICA, ';
sqlstring:=sqlstring ||'po.DEFINIZIONE, ';
sqlstring:=sqlstring ||'CODICE_DTP, ';
sqlstring:=sqlstring ||'CODICE_UT, ';
sqlstring:=sqlstring ||'BINARIO_4 BINARIO, ';
sqlstring:=sqlstring ||'bin_po.PO_TRACK_1_2_1_0_0_2_D, ';
sqlstring:=sqlstring ||'Nvl (PO_TR_PLATFORM_1_2_1_0_6_1, ''0083'') PO_TR_PLATFORM_1_2_1_0_6_1, ';
sqlstring:=sqlstring ||'b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
sqlstring:=sqlstring ||'b.PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
--sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_3_AP, ';
sqlstring:=sqlstring ||' Decode(PO_TR_PLATFORM_1_2_1_0_6_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.3'', cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3)) PO_TR_PLATFORM_1_2_1_0_6_3, ';
--sqlstring:=sqlstring ||'PO_TR_PLAT_1_2_1_0_6_4_B4_AP PO_TR_PLAT_1_2_1_0_6_4_AP, ';
sqlstring:=sqlstring ||' Decode(PO_TR_PLAT_1_2_1_0_6_4_B4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.4.B4'', PO_TR_PLATFORM_1_2_1_0_6_4_B4)) PO_TR_PLATFORM_1_2_1_0_6_4, ';
--sqlstring:=sqlstring ||'PO_TR_PLAT_1_2_1_0_6_5_B4_AP PO_TR_PLAT_1_2_1_0_6_5_AP, ';
sqlstring:=sqlstring ||'Decode(PO_TR_PLAT_1_2_1_0_6_5_B4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.5.B4'', PO_TR_PLATFORM_1_2_1_0_6_5_B4)) PO_TR_PLATFORM_1_2_1_0_6_5, ';
--sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_6_AP, ';
sqlstring:=sqlstring ||'Decode (PO_TR_PLATFORM_1_2_1_0_6_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring ||'Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6)) PO_TR_PLATFORM_1_2_1_0_6_6, ';
--sqlstring:=sqlstring ||'PO_TR_PLATFORM_1_2_1_0_6_7_AP, ';
sqlstring:=sqlstring ||'Decode (PO_TR_PLATFORM_1_2_1_0_6_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring ||'Pkg_Rinf_Report.GetDescription(''1.2.1.0.6.7'', PO_TR_PLATFORM_1_2_1_0_6_7) ) PO_TR_PLATFORM_1_2_1_0_6_7, ';
sqlstring:=sqlstring ||'CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring ||'From '|| s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
sqlstring:=sqlstring ||'( Select PO_TR_PLATFORM_1_2_1_0_6_2, ';
If p_versione Is Not Null Then
     sqlstring := sqlstring ||' CODICE_VERSIONE, ';
End If;
sqlstring:=sqlstring ||'Listagg (VALORE, '';'')  Within Group (Order By VALORE) as PO_TR_PLATFORM_1_2_1_0_6_3 ';
sqlstring:=sqlstring ||'From  '|| s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v, ';
sqlstring:=sqlstring ||'Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO d, ';
sqlstring:=sqlstring ||'Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI c ';
sqlstring:=sqlstring ||'Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
sqlstring:=sqlstring ||'And NUMERO_PARAMETRO = ''1.2.1.0.6.3'' ';
sqlstring:=sqlstring ||'And PO_TR_PLATFORM_1_2_1_0_6_3 = CODIFICA_VALORE ';
sqlstring:=sqlstring ||'Group By PO_TR_PLATFORM_1_2_1_0_6_2 ';
If p_versione Is Not Null Then
     sqlstring := sqlstring ||', CODICE_VERSIONE ';
End If;
sqlstring:=sqlstring ||' ) cat_ten, ';
sqlstring:=sqlstring ||' '|| s_schema||'.BINARI_CORSA_PO bin_po, ';
sqlstring:=sqlstring ||' '|| s_schema||'.REL_PO_BINARI_CORSA rel, ';
sqlstring:=sqlstring ||' '|| s_schema||'.PUNTI_OPERATIVI po ';
sqlstring:=sqlstring ||'Where b.PO_TR_PLATFORM_1_2_1_0_6_2 = cat_ten.PO_TR_PLATFORM_1_2_1_0_6_2(+) ';
sqlstring:=sqlstring ||'And rel.SEDE_TECNICA = po.SEDE_TECNICA      ';
sqlstring:=sqlstring ||'And BINARIO_4 = rel.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring ||'And BINARIO_4 = bin_po.PO_TRACK_1_2_1_0_0_2 ';
--->
--  sqlstring:=sqlstring ||'And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) = PO.SEDE_TECNICA ';
--  oppure:
   sqlstring := sqlstring || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) in (Select Po.SEDE_TECNICA From Dual ';
   sqlstring := sqlstring || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = Po.SEDE_TECNICA ' ;
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring ||') ';
--->

If p_versione Is Not Null Then
     sqlstring := sqlstring ||'And b.CODICE_VERSIONE  = ' ||p_versione;
     sqlstring := sqlstring ||'And b.CODICE_VERSIONE = cat_ten.CODICE_VERSIONE(+) ';
     sqlstring := sqlstring ||'And b.CODICE_VERSIONE = bin_po.CODICE_VERSIONE ';
     sqlstring := sqlstring ||'And b.CODICE_VERSIONE = rel.CODICE_VERSIONE ';
     sqlstring := sqlstring ||'And rel.CODICE_VERSIONE = po.CODICE_VERSIONE ';
End If;
--
--filtro richiamato dalla funzione ROUTING DA INSERIRE 4 VOLTE, UNA PER OGNI MARCIAPIEDE; qui   per MARC 4
If p_filtro Is Not Null Then
     s_filtro := Upper(Pkg_Rinf_Report.GetWhereCondition(p_filtro, 'PO.SEDE_TECNICA'));
     sqlstring := sqlstring ||Substr(s_filtro, 1, Instr(s_filtro, 'ORDER') -1);   --siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
End If;
sqlstring := sqlstring ||') tab_esterna ';
--
--filtro richiamato dalla funzione ROUTING inserito alla fine della tabella "esterna" perch  internamente ho 4 UNION e non avrei potuto fare l'ORDER
If p_filtro Is Not Null Then
     s_filtro := Upper(Pkg_Rinf_Report.GetWhereCondition(p_filtro, 'tab_esterna.SEDE_TECNICA'));
     sqlstring := sqlstring ||Substr(s_filtro, Instr(s_filtro, 'ORDER'));
End If;
--
-- Dbms_Output.Put_Line(sqlstring);
--
 Open p_cursor For sqlstring;
--
End GetMarciapiedi;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetGalleriePOBinCorsa  (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.9

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;



sqlstring:=' SELECT ';
sqlstring:=sqlstring|| ' PO.SEDE_TECNICA,';
sqlstring:=sqlstring|| ' PO.DEFINIZIONE,';
sqlstring:=sqlstring|| ' rel.PO_TRACK_1_2_1_0_0_2 ,';
sqlstring:=sqlstring|| ' binari.PO_TRACK_1_2_1_0_0_2_D ,';
sqlstring:=sqlstring|| ' PO_TR_TUNNEL_1_2_1_0_5_1, ';
sqlstring:=sqlstring|| ' gal.PO_TR_TUNNEL_1_2_1_0_5_2,';
sqlstring:=sqlstring|| ' PO_TR_TUNNEL_1_2_1_0_5_2_D,';
--sqlstring:=sqlstring|| ' NVL(ec.PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,''NYA'') PO_TR_TUNNEL_1_2_1_0_5_3_AP,   ';
sqlstring:=sqlstring|| ' DECODE(ec.PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,NULL,'' '', ''N'', ''Non applicabile'', ec.PO_TR_TUNNEL_1_2_1_0_5_3O4)     PO_TR_TUNNEL_1_2_1_0_5_3,';
--sqlstring:=sqlstring|| ' NVL(ei.PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,''NYA'') PO_TR_TUNNEL_1_2_1_0_5_4_AP, ';
sqlstring:=sqlstring|| ' DECODE(ei.PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,NULL,'' '', ''N'', ''Non applicabile'', ei.PO_TR_TUNNEL_1_2_1_0_5_3O4)     PO_TR_TUNNEL_1_2_1_0_5_4,';
--sqlstring:=sqlstring|| ' PO_TR_TUNNEL_1_2_1_0_5_5_AP, ';
sqlstring:=sqlstring|| '  PO_TR_TUNNEL_1_2_1_0_5_5,';
--sqlstring:=sqlstring|| ' PO_TR_TUNNEL_1_2_1_0_5_6_AP, ';
sqlstring:=sqlstring|| ' DECODE(PO_TR_TUNNEL_1_2_1_0_5_6_AP,''NYA'','' '', ''N'', ''Non applicabile'',  PKG_RINF_REPORT.GetDescription(''1.2.1.0.5.6'',PO_TR_TUNNEL_1_2_1_0_5_6)) PO_TR_TUNNEL_1_2_1_0_5_6,';
--sqlstring:=sqlstring|| ' PO_TR_TUNNEL_1_2_1_0_5_7_AP, ';
sqlstring:=sqlstring|| ' DECODE(PO_TR_TUNNEL_1_2_1_0_5_7_AP,''NYA'','' '', ''N'', ''Non applicabile'',  PKG_RINF_REPORT.GetDescription(''1.2.1.0.5.7'',PO_TR_TUNNEL_1_2_1_0_5_7)) PO_TR_TUNNEL_1_2_1_0_5_7,';
--sqlstring:=sqlstring|| ' PO_TR_TUNNEL_1_2_1_0_5_8_AP, ';
sqlstring:=sqlstring|| ' DECODE(PO_TR_TUNNEL_1_2_1_0_5_8_AP,''NYA'','' '', ''N'', ''Non applicabile'',  PKG_RINF_REPORT.GetDescription(''1.2.1.0.5.8'',PO_TR_TUNNEL_1_2_1_0_5_8)) PO_TR_TUNNEL_1_2_1_0_5_8,';
sqlstring:=sqlstring|| ' DECODE(PO_TR_TUNNEL_1_2_1_0_5_9_AP,''NYA'','' '', ''N'', ''Non applicabile'',  PKG_RINF_REPORT.GetDescription(''1.2.1.0.5.9'',PO_TR_TUNNEL_1_2_1_0_5_9)) PO_TR_TUNNEL_1_2_1_0_5_9,';
sqlstring:=sqlstring|| ' PO.CODICE_DTP,';
sqlstring:=sqlstring|| ' CODICE_UT, ';
sqlstring:=sqlstring|| ' CODICE_LINEA_TECNICA  ';
sqlstring:=sqlstring|| '  from '||s_schema||'.GALLERIE_BINARI_PO gal, ';
sqlstring:=sqlstring||  s_schema||'.PUNTI_OPERATIVI po,   ';
sqlstring:=sqlstring||  s_schema||'.REL_GALLERIE_BINARI_PO rel, ';
sqlstring:=sqlstring||  s_schema||'.BINARI_CORSA_PO binari, ';
sqlstring:=sqlstring||  s_schema||'.REL_PO_BINARI_CORSA rel_binari_po,   ';
sqlstring:=sqlstring|| ' (  SELECT PO_TR_TUNNEL_1_2_1_0_5_2,  ';
sqlstring:=sqlstring|| '           LISTAGG (ec.PO_TR_TUNNEL_1_2_1_0_5_3O4, '', '')';
sqlstring:=sqlstring|| '              WITHIN GROUP (ORDER BY ec.PO_TR_TUNNEL_1_2_1_0_5_3O4) ';
sqlstring:=sqlstring|| '              PO_TR_TUNNEL_1_2_1_0_5_3O4, ';
sqlstring:=sqlstring|| '              PO_TR_TUNNEL_1_2_1_0_5_3O4_AP ';
sqlstring:=sqlstring|| '      FROM (SELECT PO_TR_TUNNEL_1_2_1_0_5_2, PO_TR_TUNNEL_1_2_1_0_5_3O4,PO_TR_TUNNEL_1_2_1_0_5_3O4_AP';
sqlstring:=sqlstring|| '              from '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_PO';
sqlstring:=sqlstring|| '             WHERE TIPO_DICHIARAZIONE = ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '             AND CODICE_VERSIONE='||p_versione;
END IF;
sqlstring:=sqlstring|| '             ) ec  ';
sqlstring:=sqlstring|| '  GROUP BY PO_TR_TUNNEL_1_2_1_0_5_2,PO_TR_TUNNEL_1_2_1_0_5_3O4_AP) ec,     ';
sqlstring:=sqlstring|| ' (  SELECT PO_TR_TUNNEL_1_2_1_0_5_2,';
sqlstring:=sqlstring|| '           LISTAGG (ei.PO_TR_TUNNEL_1_2_1_0_5_3O4, '', '') ';
sqlstring:=sqlstring|| '              WITHIN GROUP (ORDER BY ei.PO_TR_TUNNEL_1_2_1_0_5_3O4)  ';
sqlstring:=sqlstring|| '              PO_TR_TUNNEL_1_2_1_0_5_3O4,';
sqlstring:=sqlstring|| '              PO_TR_TUNNEL_1_2_1_0_5_3O4_AP   ';
sqlstring:=sqlstring|| '      FROM (SELECT PO_TR_TUNNEL_1_2_1_0_5_2, PO_TR_TUNNEL_1_2_1_0_5_3O4,PO_TR_TUNNEL_1_2_1_0_5_3O4_AP ';
sqlstring:=sqlstring|| '              from '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_PO ';
sqlstring:=sqlstring|| '             WHERE TIPO_DICHIARAZIONE = ''EI''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '             AND CODICE_VERSIONE='||p_versione;
END IF;
sqlstring:=sqlstring|| '             ) ei    ';
sqlstring:=sqlstring|| ' GROUP BY PO_TR_TUNNEL_1_2_1_0_5_2,PO_TR_TUNNEL_1_2_1_0_5_3O4_AP) ei ';
sqlstring:=sqlstring|| ' WHERE     rel.PO_TR_TUNNEL_1_2_1_0_5_2 = GAL.PO_TR_TUNNEL_1_2_1_0_5_2   ';
sqlstring:=sqlstring|| ' AND gal.PO_TR_TUNNEL_1_2_1_0_5_2 = ec.PO_TR_TUNNEL_1_2_1_0_5_2 (+) ';
sqlstring:=sqlstring|| ' AND gal.PO_TR_TUNNEL_1_2_1_0_5_2 = ei.PO_TR_TUNNEL_1_2_1_0_5_2 (+) ';
sqlstring:=sqlstring|| ' AND REL.PO_TRACK_1_2_1_0_0_2 = BINARI.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| ' AND BINARI.PO_TRACK_1_2_1_0_0_2 = REL_BINARI_PO.PO_TRACK_1_2_1_0_0_2   ';
sqlstring:=sqlstring|| ' and REL_BINARI_PO.SEDE_TECNICA=PO.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| ' and po.codice_versione=REL.CODICE_VERSIONE    ';
sqlstring:=sqlstring|| ' and REL.CODICE_VERSIONE=BINARI.CODICE_VERSIONE ';
sqlstring:=sqlstring|| ' and BINARI.CODICE_VERSIONE= GAL.CODICE_VERSIONE  ';
sqlstring:=sqlstring|| ' and BINARI.CODICE_VERSIONE= rel_binari_po.CODICE_VERSIONE ';
sqlstring:=sqlstring|| ' and GAL.CODICE_VERSIONE='||p_versione;
END IF;

--filtro richiamato dalla funzione ROUTING
IF p_filtro is NOT NULL THEN
sqlstring:=sqlstring ||GetWhereCondition(p_filtro,'PO.SEDE_TECNICA');
END IF;

--sqlstring:=sqlstring|| ' ORDER BY po.CODICE_DTP,gal.PO_TR_TUNNEL_1_2_1_0_5_2,rel.PO_TRACK_1_2_1_0_0_2';

DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetGalleriePOBinCorsa ;

--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetBinariRaccordo  (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.10

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) 
 THEN
    p_versione:=NULL;
 ELSE 
    IF p_i_versione IS NULL 
    THEN
       p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
    ELSE
        p_versione:=p_i_versione;
    END IF;
 END IF;

 sqlstring := 'Select po.SEDE_TECNICA, ';
 sqlstring := sqlstring ||' DEFINIZIONE, ';
 sqlstring := sqlstring ||' Nvl(PO_SD_1_2_2_0_0_1, ''0083'') PO_SD_1_2_2_0_0_1, ';
 sqlstring := sqlstring ||' b.PO_SD_1_2_2_0_0_2, ';
 sqlstring := sqlstring ||' b.PO_SD_1_2_2_0_0_2_D, ';
 sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_0_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.0.3'',cat_ten.PO_SD_1_2_2_0_0_3)) PO_SD_1_2_2_0_0_3, ';
 sqlstring := sqlstring ||' DICH_EC.PO_SD_1_2_2_0_1_1, ';
 sqlstring := sqlstring ||' DICH_EI.PO_SD_1_2_2_0_1_2, ';
---> modifica del 16/02/2023 con mail di richiesta RFI 
--     sqlstring := sqlstring ||' PO_SD_1_2_2_0_2_1, ';
 sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_2_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PO_SD_1_2_2_0_2_1) PO_SD_1_2_2_0_2_1, ';
--->
--
 sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_3_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Trim (To_Char (Round (PO_SD_1_2_2_0_3_1, 1), ''999990.9''))) PO_SD_1_2_2_0_3_1, ';
 sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_3_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.3.2'',PO_SD_1_2_2_0_3_2)) PO_SD_1_2_2_0_3_2, ';
 sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_3_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Decode (PO_SD_1_2_2_0_3_3_A || ''+'' || PO_SD_1_2_2_0_3_3_B,''+'', NULL, PO_SD_1_2_2_0_3_3_A || ''+'' || PO_SD_1_2_2_0_3_3_B)) PO_SD_1_2_2_0_3_3, ';
 sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_4_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.4.1'', PO_SD_1_2_2_0_4_1)) PO_SD_1_2_2_0_4_1, ';
 sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_4_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.4.2'', PO_SD_1_2_2_0_4_2)) PO_SD_1_2_2_0_4_2, ';
 sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_4_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.4.3'', PO_SD_1_2_2_0_4_3)) PO_SD_1_2_2_0_4_3, ';
 sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_4_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.4.4'', PO_SD_1_2_2_0_4_4)) PO_SD_1_2_2_0_4_4, ';
 sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_4_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.4.5'', PO_SD_1_2_2_0_4_5)) PO_SD_1_2_2_0_4_5, ';
 sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_4_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.4.6'', PO_SD_1_2_2_0_4_6)) PO_SD_1_2_2_0_4_6, ';
 ---> Inizio Modifica reg 777/2019 del 06/04/2021
 sqlstring := sqlstring || ' Decode(PO_SD_1_2_2_0_6_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.6.1'', PO_SD_1_2_2_0_6_1)) PO_SD_1_2_2_0_6_1, ';
 ---> Fine modifica   
 sqlstring := sqlstring ||' CODICE_DTP, ';
 sqlstring := sqlstring ||' CODICE_UT, ';
 sqlstring := sqlstring ||' CODICE_LINEA_TECNICA ';
 sqlstring := sqlstring ||' From  '|| s_schema||'.BINARI_RACCORDO_PO b, ';
 sqlstring := sqlstring || s_schema||'.PUNTI_OPERATIVI PO, ';
 sqlstring := sqlstring ||' (Select PO_SD_1_2_2_0_0_2, ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring ||' CODICE_VERSIONE, ';
 End If;
 sqlstring := sqlstring ||' Listagg (VALORE, '';'') ';
 sqlstring := sqlstring ||' Within Group (Order By KM_INIZIO, VALORE_XML) ';
 sqlstring := sqlstring ||' As PO_SD_1_2_2_0_0_3 ';
 sqlstring := sqlstring ||' From  '|| s_schema||'.PAR_1_2_2_0_0_3_CAT_TEN_SD v, ';
 sqlstring := sqlstring ||' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring ||' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring ||' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring ||' And NUMERO_PARAMETRO = ''1.2.2.0.0.3'' ';
 sqlstring := sqlstring ||' And PO_SD_1_2_2_0_0_3 = CODIFICA_VALORE ';
 sqlstring :=sqlstring ||' Group By PO_SD_1_2_2_0_0_2 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring ||' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring ||' ) cat_ten, ';
 sqlstring := sqlstring ||' (Select DIC.PO_SD_1_2_2_0_0_2, ';
 sqlstring := sqlstring ||' PO_SD_1_2_2_0_1_1O2_AP PO_SD_1_2_2_0_1_1_AP, ';
 sqlstring := sqlstring ||' Decode (PO_SD_1_2_2_0_1_1O2_AP, ';
 sqlstring := sqlstring ||' ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring ||' PO_SD_1_2_2_0_1_1O2) ';
 sqlstring := sqlstring ||' PO_SD_1_2_2_0_1_1 ';
 sqlstring := sqlstring ||' From  '|| s_schema||'.DICHIARAZIONI_RACCORDO_PO DIC ';
 sqlstring := sqlstring ||' Where DIC.TIPO_DICHIARAZIONE = ''EC''  ';
 If p_versione Is Not Null 
 Then
    sqlstring:=sqlstring ||'  And DIC.CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring ||' Union ';
 sqlstring := sqlstring ||' Select DIC.PO_SD_1_2_2_0_0_2, ';
 sqlstring := sqlstring ||' ''NYA'' PO_SD_1_2_2_0_1_1_AP, ';
 sqlstring := sqlstring ||' '' '' PO_SD_1_2_2_0_1_1 ';
 sqlstring := sqlstring ||' From (Select PO_SD_1_2_2_0_0_2 ';
 sqlstring := sqlstring ||' From '|| s_schema||'.BINARI_RACCORDO_PO ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring ||' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring:=sqlstring ||' Minus ';
 sqlstring:=sqlstring ||' Select PO_SD_1_2_2_0_0_2 ';
 sqlstring:=sqlstring ||' From '|| s_schema||'.DICHIARAZIONI_RACCORDO_PO ';
 sqlstring:=sqlstring ||' Where TIPO_DICHIARAZIONE = ''EC''  ';
 If p_versione Is Not Null 
 Then
    sqlstring:=sqlstring ||' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring ||' ) dic) dich_ec, ';
 sqlstring := sqlstring ||' (Select dic.PO_SD_1_2_2_0_0_2, ';
 sqlstring := sqlstring ||' PO_SD_1_2_2_0_1_1O2_AP PO_SD_1_2_2_0_1_2_AP, ';
 sqlstring := sqlstring ||' Decode (PO_SD_1_2_2_0_1_1O2_AP, ';
 sqlstring := sqlstring ||' ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring ||' PO_SD_1_2_2_0_1_1O2) ';
 sqlstring := sqlstring ||' PO_SD_1_2_2_0_1_2 ';
 sqlstring := sqlstring ||' From '|| s_schema||'.DICHIARAZIONI_RACCORDO_PO dic ';
 sqlstring := sqlstring ||' Where dic.TIPO_DICHIARAZIONE = ''EI'' ';
 If p_versione Is Not Null 
 Then
    sqlstring:=sqlstring ||' And dic.CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring ||' Union ';
 sqlstring := sqlstring ||' Select dic.PO_SD_1_2_2_0_0_2, ';
 sqlstring := sqlstring ||' ''NYA'' PO_SD_1_2_2_0_1_2_AP, ';
 sqlstring := sqlstring ||' '' '' PO_SD_1_2_2_0_1_2 ';
 sqlstring := sqlstring ||' From (Select PO_SD_1_2_2_0_0_2 ';
 sqlstring := sqlstring ||' From '|| s_schema||'.BINARI_RACCORDO_PO ';
 If p_versione Is Not Null 
 Then
    sqlstring:=sqlstring ||' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring ||' Minus ';
 sqlstring := sqlstring ||' Select PO_SD_1_2_2_0_0_2 ';
 sqlstring := sqlstring ||' From  '|| s_schema||'.DICHIARAZIONI_RACCORDO_PO ';
 sqlstring := sqlstring ||' Where TIPO_DICHIARAZIONE = ''EI'' ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring ||' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring ||' ) dic) dich_ei ';
 sqlstring := sqlstring ||' Where b.SEDE_TECNICA = po.SEDE_TECNICA ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring ||' And b.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring ||' And b.CODICE_VERSIONE = po.CODICE_VERSIONE ';
    sqlstring := sqlstring ||' And b.CODICE_VERSIONE = cat_ten.CODICE_VERSIONE(+) ';
 End If;
 sqlstring := sqlstring ||' And b.PO_SD_1_2_2_0_0_2 = cat_ten.PO_SD_1_2_2_0_0_2(+) ';
 sqlstring := sqlstring ||' And b.PO_SD_1_2_2_0_0_2 = dich_ec.PO_SD_1_2_2_0_0_2(+) ';
 sqlstring := sqlstring ||' And b.PO_SD_1_2_2_0_0_2 = dich_ei.PO_SD_1_2_2_0_0_2(+) ';
 --filtro richiamato dalla funzione ROUTING
 If p_filtro Is Not Null 
 Then
    sqlstring := sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'po.SEDE_TECNICA');
 End If;
 DBMS_OUTPUT.PUT_LINE(sqlstring);
 OPEN p_cursor FOR sqlstring;
END GetBinariRaccordo;
--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetGalleriePOBinRacc  (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.11
-- Procedura modificata il 05-10-2021

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;



sqlstring:=' SELECT ';
sqlstring:=sqlstring|| ' PO.SEDE_TECNICA,';
sqlstring:=sqlstring|| ' PO.DEFINIZIONE,';
--sqlstring:=sqlstring|| ' PO.CODICE_DTP ,'; -- colonna Elinata il 02/04
--sqlstring:=sqlstring|| ' CODICE_UT,';      -- colonna Elinata il 02/04
sqlstring:=sqlstring|| ' rel.PO_SD_1_2_2_0_0_2 ,';
sqlstring:=sqlstring|| ' binari.PO_SD_1_2_2_0_0_2_D ,';
sqlstring:=sqlstring|| ' PO_SD_TUNNEL_1_2_2_0_5_1,';
sqlstring:=sqlstring|| ' gal.PO_SD_TUNNEL_1_2_2_0_5_2,';
sqlstring:=sqlstring|| ' PO_SD_TUNNEL_1_2_2_0_5_2_D,';
sqlstring:=sqlstring|| ' DECODE(ec.PO_SD_TUNNEL_1_2_2_0_5_3O4_AP,NULL,'' '', ''N'', ''Non applicabile'', ec.PO_SD_TUNNEL_1_2_2_0_5_3O4)     PO_SD_TUNNEL_1_2_2_0_5_3,';
sqlstring:=sqlstring|| ' DECODE(ei.PO_SD_TUNNEL_1_2_2_0_5_3O4_AP,NULL,'' '', ''N'', ''Non applicabile'', ei.PO_SD_TUNNEL_1_2_2_0_5_3O4)     PO_SD_TUNNEL_1_2_2_0_5_4,';
sqlstring:=sqlstring|| '  PO_SD_TUNNEL_1_2_2_0_5_5,';
sqlstring:=sqlstring|| ' DECODE(PO_SD_TUNNEL_1_2_2_0_5_6_AP,''NYA'','' '', ''N'', ''Non applicabile'',  PKG_RINF_REPORT.GetDescription(''1.2.2.0.5.6'',PO_SD_TUNNEL_1_2_2_0_5_6)) PO_SD_TUNNEL_1_2_2_0_5_6,';
sqlstring:=sqlstring|| ' DECODE(PO_SD_TUNNEL_1_2_2_0_5_7_AP,''NYA'','' '', ''N'', ''Non applicabile'',  PKG_RINF_REPORT.GetDescription(''1.2.2.0.5.7'',PO_SD_TUNNEL_1_2_2_0_5_7)) PO_SD_TUNNEL_1_2_2_0_5_7,';
sqlstring:=sqlstring|| ' DECODE(PO_SD_TUNNEL_1_2_2_0_5_8_AP,''NYA'','' '', ''N'', ''Non applicabile'',  PKG_RINF_REPORT.GetDescription(''1.2.2.0.5.8'',PO_SD_TUNNEL_1_2_2_0_5_8)) PO_SD_TUNNEL_1_2_2_0_5_8,';
sqlstring:=sqlstring|| ' PO.CODICE_DTP ,'; -- colonna inserita il 02/04
sqlstring:=sqlstring|| ' CODICE_UT,';      -- colonna inserita il 02/04
sqlstring:=sqlstring|| ' CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring|| ' from '||s_schema||'.GALLERIE_RACCORDO_PO gal,';
sqlstring:=sqlstring|| s_schema||'.PUNTI_OPERATIVI po,';
sqlstring:=sqlstring|| s_schema||'.REL_GALLERIE_RACCORDO_PO rel,  ';
sqlstring:=sqlstring|| s_schema||'.BINARI_RACCORDO_PO binari,';
sqlstring:=sqlstring|| ' (  SELECT PO_SD_TUNNEL_1_2_2_0_5_2,';
sqlstring:=sqlstring|| '           LISTAGG (ec.PO_SD_TUNNEL_1_2_2_0_5_3O4, '', '')';
sqlstring:=sqlstring|| '              WITHIN GROUP (ORDER BY ec.PO_SD_TUNNEL_1_2_2_0_5_3O4)';
sqlstring:=sqlstring|| '              PO_SD_TUNNEL_1_2_2_0_5_3O4,';
sqlstring:=sqlstring|| '              PO_SD_TUNNEL_1_2_2_0_5_3O4_AP ';
sqlstring:=sqlstring|| '      FROM (SELECT PO_SD_TUNNEL_1_2_2_0_5_2, PO_SD_TUNNEL_1_2_2_0_5_3O4,PO_SD_TUNNEL_1_2_2_0_5_3O4_AP';
sqlstring:=sqlstring|| '              from '||s_schema||'.DICHIARAZIONI_GALLERIE_SD_PO ';
sqlstring:=sqlstring|| '             WHERE TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '             AND CODICE_VERSIONE='||p_versione;
END IF;
sqlstring:=sqlstring|| '             ) ec';
sqlstring:=sqlstring|| '  GROUP BY PO_SD_TUNNEL_1_2_2_0_5_2,PO_SD_TUNNEL_1_2_2_0_5_3O4_AP) ec,';
sqlstring:=sqlstring|| ' (  SELECT PO_SD_TUNNEL_1_2_2_0_5_2,';
sqlstring:=sqlstring|| '           LISTAGG (ei.PO_SD_TUNNEL_1_2_2_0_5_3O4, '', '')';
sqlstring:=sqlstring|| '              WITHIN GROUP (ORDER BY ei.PO_SD_TUNNEL_1_2_2_0_5_3O4)';
sqlstring:=sqlstring|| '              PO_SD_TUNNEL_1_2_2_0_5_3O4,';
sqlstring:=sqlstring|| '              PO_SD_TUNNEL_1_2_2_0_5_3O4_AP';
sqlstring:=sqlstring|| '      FROM (SELECT PO_SD_TUNNEL_1_2_2_0_5_2, PO_SD_TUNNEL_1_2_2_0_5_3O4,PO_SD_TUNNEL_1_2_2_0_5_3O4_AP';
sqlstring:=sqlstring|| '              from '||s_schema||'.DICHIARAZIONI_GALLERIE_SD_PO';
sqlstring:=sqlstring|| '             WHERE TIPO_DICHIARAZIONE = ''EI''';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '             AND CODICE_VERSIONE='||p_versione;
END IF;
sqlstring:=sqlstring|| '             ) ei';
sqlstring:=sqlstring|| '  GROUP BY PO_SD_TUNNEL_1_2_2_0_5_2,PO_SD_TUNNEL_1_2_2_0_5_3O4_AP) ei ';
sqlstring:=sqlstring|| ' WHERE     rel.PO_SD_TUNNEL_1_2_2_0_5_2 = GAL.PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring|| ' AND gal.PO_SD_TUNNEL_1_2_2_0_5_2 = ec.PO_SD_TUNNEL_1_2_2_0_5_2 (+) ';
sqlstring:=sqlstring|| ' AND gal.PO_SD_TUNNEL_1_2_2_0_5_2 = ei.PO_SD_TUNNEL_1_2_2_0_5_2 (+) ';
sqlstring:=sqlstring|| ' AND REL.PO_SD_1_2_2_0_0_2 = BINARI.PO_SD_1_2_2_0_0_2';
sqlstring:=sqlstring|| ' AND BINARI.SEDE_TECNICA =PO.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| ' and po.codice_versione=REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| ' and REL.CODICE_VERSIONE=BINARI.CODICE_VERSIONE ';
sqlstring:=sqlstring|| ' and BINARI.CODICE_VERSIONE= GAL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| ' and GAL.CODICE_VERSIONE='||p_versione;
END IF;

--filtro richiamato dalla funzione ROUTING
IF p_filtro is NOT NULL THEN
sqlstring:=sqlstring ||GetWhereCondition(p_filtro,'PO.SEDE_TECNICA');
END IF;

--sqlstring:=sqlstring|| ' ORDER BY po.CODICE_DTP,gal.PO_SD_TUNNEL_1_2_2_0_5_2,rel.PO_SD_1_2_2_0_0_2 ';

DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetGalleriePOBinRacc ;




--report congelati



--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--

-- PROCEDURE GetRanghiVelocitaTratta (p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur) IS
--eliminato nella versione 4.0
--s_schema VARCHAR2(100);
--sqlstring VARCHAR2(32767);
--p_versione NUMBER;
--BEGIN
-- s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--  p_versione:=p_i_versione;
-- IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
-- p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
-- END IF;
-- sqlstring:='select ';
--      sqlstring:=sqlstring||' t.sede_tecnica "Codice Tratta IN.RETE", ';
--         sqlstring:=sqlstring||' T.DEFINIZIONE "Definizione IN.RETE", ';
--         sqlstring:=sqlstring||' pic.CODICE_TRATTA_PIC_D "Codice Pic Dispari", ';
--         sqlstring:=sqlstring||' pic.CODICE_TRATTA_PIC_P "Codice Pic Pari", ';
--         sqlstring:=sqlstring||' rd.CODICE_TRATTA_ROMAN "Codice Roman Dispari", ';
--         sqlstring:=sqlstring||' rp.CODICE_TRATTA_ROMAN "Codice Roman Pari", ';
--         sqlstring:=sqlstring||' codice_linea_fcl "Codice Linea Fcl", ';
--         sqlstring:=sqlstring||' codice_linea_fcl_inversa "Codice Linea Fcl Inversa", ';
--         sqlstring:=sqlstring||' linea_fcl "Definizione Linea Fcl", ';
--         sqlstring:=sqlstring||' FCLD_VMAX_A "Rango A", ';
--         sqlstring:=sqlstring||' FCLD_VMAX_B "Rango B", ';
--         sqlstring:=sqlstring||' FCLD_VMAX_C "Rango C", ';
--         sqlstring:=sqlstring||' FCLD_VMAX_P "Rango P", ';
--         sqlstring:=sqlstring||' t.codice_dtp "Codice DTP", ';
--         sqlstring:=sqlstring||' t.codice_ut "Codice UT" ';
--         sqlstring:=sqlstring||' FROM '||s_schema||'.SEZIONI_LINEA T, ';
--         sqlstring:=sqlstring||' RINF_ANAGRAFICHE_EVO.V_MAPPING_TRATTE_INRETE_PIC pic, ';
--         sqlstring:=sqlstring||' RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN rd, ';
--         sqlstring:=sqlstring||' RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN rp, ';
--         sqlstring:=sqlstring||' (SELECT DISTINCT D.FCLD_TRSC_ID codice_tratta_roman, ';
--         sqlstring:=sqlstring||'                 t.CODICE_LINEA_FCL codice_linea_fcl, ';
--         sqlstring:=sqlstring||'                 t.CODICE_LINEA_INVERSA codice_linea_fcl_inversa, ';
--         sqlstring:=sqlstring||'                 t.DEFINIZIONE linea_fcl, ';
--         sqlstring:=sqlstring||'                 DATA_INIZIO_VALIDITA, ';
--         sqlstring:=sqlstring||'                 DAT_FINE_VAL, ';
--         sqlstring:=sqlstring||'                 FCLD_VMAX_A, ';
--         sqlstring:=sqlstring||'                 FCLD_VMAX_B, ';
--         sqlstring:=sqlstring||'                 FCLD_VMAX_C, ';
--         sqlstring:=sqlstring||'                 FCLD_VMAX_P ';
--         sqlstring:=sqlstring||'   FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL t, ';
--         sqlstring:=sqlstring||'        RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_DATI d ';
--         sqlstring:=sqlstring||'  WHERE     T.CODICE_LINEA_FCL = D.FCLD_FCL_ID ';
--         sqlstring:=sqlstring||'        AND t.FLAG_DISPARI = 1 ';
--         sqlstring:=sqlstring||'        AND NVL (DATA_INIZIO_VAL_R, TO_DATE (''01011999'', ''DDMMYYYY'')) <= ';
--         sqlstring:=sqlstring||'               SYSDATE ';
--         sqlstring:=sqlstring||'        AND NVL (DAT_FINE_VAL, TO_DATE (''01012999'', ''DDMMYYYY'')) >= ';
--         sqlstring:=sqlstring||'               SYSDATE) l_fd ';
--         sqlstring:=sqlstring||' WHERE     rd.CODICE_TRATTA_ROMAN = l_fd.codice_tratta_roman ';
--         sqlstring:=sqlstring||' AND T.SEDE_TECNICA = pic.sede_tecnica ';
--         sqlstring:=sqlstring||' AND pic.CODICE_TRATTA_PIC_D = rd.CODICE_TRATTA_PIC ';
--         sqlstring:=sqlstring||' AND pic.CODICE_TRATTA_PIC_P = rp.CODICE_TRATTA_PIC ';
--         sqlstring:=sqlstring||' AND rd.CODICE_BRANCH = rp.CODICE_BRANCH ';
--         sqlstring:=sqlstring||' AND   NVL (FCLD_VMAX_A, -1) ';
--         sqlstring:=sqlstring||'     + NVL (FCLD_VMAX_B, -1) ';
--         sqlstring:=sqlstring||'     + NVL (FCLD_VMAX_C, -1) ';
--         sqlstring:=sqlstring||'     + NVL (FCLD_VMAX_P, -1) <> -4 ';
--         IF p_versione IS NOT NULL THEN
--            sqlstring:=sqlstring||'    AND t.CODICE_VERSIONE='||p_versione;
--         END IF;
--       sqlstring:=sqlstring||' order by 1';
--       OPEN p_cursor FOR sqlstring;
-- END GetRanghiVelocitaTratta

--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
--
PROCEDURE GetDichiarazioniEC_PO  (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--28/02/2018
--REPORT FLAT SOL

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;

sqlstring:='Select /*+ PARALLEL(default) */  tab_totale.SEDE_TECNICA,  ';       --INSERITA SELECT ESTERNA PER CREARE UNA TABELLA UNICA SU CUI FARE POI LA SOTTOSELEZIONE PER IL ROUTING
sqlstring:=sqlstring|| '     DEFINIZIONE, ';                --in quanto sarebbe troppo oneroso spostare la condizione del routing in ogni union di questa query molto complessa
sqlstring:=sqlstring|| '     CODICE_DTP, ';
sqlstring:=sqlstring|| '     CODICE_UT, ';
sqlstring:=sqlstring|| '     CODICE_OGGETTO, ';
sqlstring:=sqlstring|| '     DESCRIZIONE, ';
sqlstring:=sqlstring|| '     PARAMETRO, ';
sqlstring:=sqlstring|| '     DICHIARAZIONE,  ';
sqlstring:=sqlstring|| '     CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring|| '     FROM ';
sqlstring:=sqlstring|| '     ( ';
sqlstring:=sqlstring|| ' SELECT BCP.PO_TRACK_1_2_1_0_0_2 "CODICE_OGGETTO",               '; --DICH INF PO
sqlstring:=sqlstring|| '       BCP.PO_TRACK_1_2_1_0_0_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.1.0.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       PO_TRACK_1_2_1_0_1_1O2_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (PO_TRACK_1_2_1_0_1_1O2_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               PO_TRACK_1_2_1_0_1_1O2) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_PO DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.REL_PO_BINARI_CORSA rel, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_PO BCP, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI PO ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
sqlstring:=sqlstring|| '       AND dic.PO_TRACK_1_2_1_0_0_2 = rel.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '       AND rel.SEDE_TECNICA = po.SEDE_TECNICA ';
sqlstring:=sqlstring|| '       AND BCP.PO_TRACK_1_2_1_0_0_2 = DIC.PO_TRACK_1_2_1_0_0_2(+) ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCP.CODICE_VERSIONE  = ' ||p_versione;
sqlstring:=sqlstring|| '       AND PO.CODICE_VERSIONE = BCP.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND rel.CODICE_VERSIONE = BCP.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BCP.CODICE_VERSIONE = DIC.CODICE_VERSIONE ';
END IF;
      -- AND rel.PO_TRACK_1_2_1_0_0_2 LIKE ''LO%''
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT BCP.PO_TRACK_1_2_1_0_0_2 "CODICE_OGGETTO",               ';--DICH  ASSENTI
sqlstring:=sqlstring|| '       BCP.PO_TRACK_1_2_1_0_0_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.1.0.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.BINARI_CORSA_PO BCP ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_BINARIO_PO ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '     )  DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_PO BCP, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.REL_PO_BINARI_CORSA REL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI PO ';
sqlstring:=sqlstring|| ' WHERE     Bcp.PO_TRACK_1_2_1_0_0_2 = DIC.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '       AND PO.SEDE_TECNICA = REL.SEDE_TECNICA ';
sqlstring:=sqlstring|| '       AND REL.PO_TRACK_1_2_1_0_0_2 = BCP.PO_TRACK_1_2_1_0_0_2 ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND BCP.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND PO.CODICE_VERSIONE = BCP.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND REL.CODICE_VERSIONE = BCP.CODICE_VERSIONE ';
END IF;
      -- AND REL.PO_TRACK_1_2_1_0_0_2 LIKE ''LO%''
sqlstring:=sqlstring|| '   ';
sqlstring:=sqlstring|| ' UNION       ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '           SELECT GAL.PO_TR_TUNNEL_1_2_1_0_5_2 "CODICE_OGGETTO",            ';--DICH PO GALLERIA
sqlstring:=sqlstring|| '       GAL.PO_TR_TUNNEL_1_2_1_0_5_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       SL.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       SL.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.1.0.5.3'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       PO_TR_TUNNEL_1_2_1_0_5_3O4_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (PO_TR_TUNNEL_1_2_1_0_5_3O4_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               PO_TR_TUNNEL_1_2_1_0_5_3O4) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_GALLERIE_BIN_PO DIC, ';
sqlstring:=sqlstring|| '   '|| s_schema||'.GALLERIE_BINARI_PO GAL, ';
sqlstring:=sqlstring|| '   '|| s_schema||'.REL_GALLERIE_BINARI_PO REL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_CORSA_PO BCS, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.REL_PO_BINARI_CORSA relpobc, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI SL ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE=DIC.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE = REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND REL.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BCS.CODICE_VERSIONE = relpobc.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND relpobc.CODICE_VERSIONE = SL.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '       AND GAL.PO_TR_TUNNEL_1_2_1_0_5_2 = DIC.PO_TR_TUNNEL_1_2_1_0_5_2(+) ';
sqlstring:=sqlstring|| '       AND GAL.PO_TR_TUNNEL_1_2_1_0_5_2 = REL.PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring|| '       AND REL.PO_TRACK_1_2_1_0_0_2 = BCS.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '       AND BCS.PO_TRACK_1_2_1_0_0_2 =relpobc.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '       AND relpobc.SEDE_TECNICA = SL.SEDE_TECNICA      ';
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT GAL.PO_TR_TUNNEL_1_2_1_0_5_2 "CODICE_OGGETTO",                    ';--DICH ASSENTI
sqlstring:=sqlstring|| '       GAL.PO_TR_TUNNEL_1_2_1_0_5_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       po.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       po.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.1.0.5.3'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.GALLERIE_BINARI_PO ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_GALLERIE_BIN_PO ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '         ) DICH, ';
sqlstring:=sqlstring|| '          '|| s_schema||'.GALLERIE_BINARI_PO GAL, ';
sqlstring:=sqlstring|| '          '|| s_schema||'.REL_GALLERIE_BINARI_PO REL, ';
sqlstring:=sqlstring|| '          '|| s_schema||'.BINARI_CORSA_PO BCP, ';
sqlstring:=sqlstring|| '          '|| s_schema||'.REL_PO_BINARI_CORSA relpobc, ';
sqlstring:=sqlstring|| '          '|| s_schema||'.PUNTI_OPERATIVI PO         ';
sqlstring:=sqlstring|| '         WHERE   DICH.PO_TR_TUNNEL_1_2_1_0_5_2=GAL.PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring|| '         AND GAL.PO_TR_TUNNEL_1_2_1_0_5_2=REL.PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring|| '        AND REL.PO_TRACK_1_2_1_0_0_2=BCP.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '        AND BCP.PO_TRACK_1_2_1_0_0_2=relpobc.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| '        AND relpobc.SEDE_TECNICA=po.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '        AND GAL.CODICE_VERSIONE  = ' ||p_versione;
sqlstring:=sqlstring|| '        AND GAL.CODICE_VERSIONE = REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '        AND REL.CODICE_VERSIONE = BCP.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '        AND BCP.CODICE_VERSIONE = relpobc.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '        AND relpobc.CODICE_VERSIONE=po.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '         ';
sqlstring:=sqlstring|| '         ';
sqlstring:=sqlstring|| '  UNION       ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '           SELECT BR.PO_SD_1_2_2_0_0_2 "CODICE_OGGETTO",            ';--DICH RACCORDO
sqlstring:=sqlstring|| '       BR.PO_SD_1_2_2_0_0_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '      PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.2.0.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       PO_SD_1_2_2_0_1_1O2_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (PO_SD_1_2_2_0_1_1O2_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               PO_SD_1_2_2_0_1_1O2) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_RACCORDO_PO DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_RACCORDO_PO BR, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI PO ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND DIC.CODICE_VERSIONE  = ' ||p_versione;
sqlstring:=sqlstring|| '       AND BR.CODICE_VERSIONE=DIC.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND PO.CODICE_VERSIONE = BR.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '       AND BR.PO_SD_1_2_2_0_0_2 = DIC.PO_SD_1_2_2_0_0_2(+) ';
sqlstring:=sqlstring|| '       AND BR.SEDE_TECNICA = PO.SEDE_TECNICA      ';
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT BR.PO_SD_1_2_2_0_0_2 "CODICE_OGGETTO",            ';--DICH RACCORDO
sqlstring:=sqlstring|| '       BR.PO_SD_1_2_2_0_0_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '      PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.2.0.1.1'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT PO_SD_1_2_2_0_0_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.BINARI_RACCORDO_PO ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT PO_SD_1_2_2_0_0_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_RACCORDO_PO ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '         ) DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_RACCORDO_PO BR, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI PO       ';
sqlstring:=sqlstring|| '       WHERE  BR.PO_SD_1_2_2_0_0_2 = DIC.PO_SD_1_2_2_0_0_2(+) ';
sqlstring:=sqlstring|| '       AND BR.SEDE_TECNICA = PO.SEDE_TECNICA  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND  BR.CODICE_VERSIONE = ' ||p_versione;
sqlstring:=sqlstring|| '       AND PO.CODICE_VERSIONE = BR.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '       UNION       ';
sqlstring:=sqlstring|| '        ';
sqlstring:=sqlstring|| '           SELECT GAL.PO_SD_TUNNEL_1_2_2_0_5_2 "CODICE_OGGETTO",            ';--DICH GALLERIA RACCORDO
sqlstring:=sqlstring|| '       GAL.PO_SD_TUNNEL_1_2_2_0_5_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.2.0.5.3'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       PO_SD_TUNNEL_1_2_2_0_5_3O4_AP "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       DECODE (PO_SD_TUNNEL_1_2_2_0_5_3O4_AP, ';
sqlstring:=sqlstring|| '               ''NYA'','' '', ''N'', ''Non applicabile'', ';
sqlstring:=sqlstring|| '               PO_SD_TUNNEL_1_2_2_0_5_3O4) ';
sqlstring:=sqlstring|| '          "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM  '|| s_schema||'.DICHIARAZIONI_GALLERIE_SD_PO DIC, ';
sqlstring:=sqlstring|| '   '|| s_schema||'.GALLERIE_RACCORDO_PO GAL, ';
sqlstring:=sqlstring|| '   '|| s_schema||'.REL_GALLERIE_RACCORDO_PO REL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_RACCORDO_PO BR, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI PO ';
sqlstring:=sqlstring|| ' WHERE     DIC.TIPO_DICHIARAZIONE = ''EC'' ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE  = ' ||p_versione;
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE=DIC.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND GAL.CODICE_VERSIONE = REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND REL.CODICE_VERSIONE = BR.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '       AND BR.CODICE_VERSIONE = PO.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '       AND GAL.PO_SD_TUNNEL_1_2_2_0_5_2 = DIC.PO_SD_TUNNEL_1_2_2_0_5_2(+) ';
sqlstring:=sqlstring|| '       AND GAL.PO_SD_TUNNEL_1_2_2_0_5_2 = REL.PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring|| '       AND REL.PO_SD_1_2_2_0_0_2 = BR.PO_SD_1_2_2_0_0_2 ';
sqlstring:=sqlstring|| '       AND BR.SEDE_TECNICA =PO.SEDE_TECNICA      ';
sqlstring:=sqlstring|| 'UNION ';
sqlstring:=sqlstring|| 'SELECT GAL.PO_SD_TUNNEL_1_2_2_0_5_2 "CODICE_OGGETTO",            ';--DICH ASSENTI
sqlstring:=sqlstring|| '       GAL.PO_SD_TUNNEL_1_2_2_0_5_2_D "DESCRIZIONE", ';
sqlstring:=sqlstring|| '       PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| '       PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| '       ''1.2.2.0.5.3'' "PARAMETRO", ';
--sqlstring:=sqlstring|| '       ''NYA'' "DICHIARAZIONE_AP", ';
sqlstring:=sqlstring|| '       '' '' "DICHIARAZIONE", ';
sqlstring:=sqlstring|| '       CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| '       CODICE_DTP, ';
sqlstring:=sqlstring|| '       CODICE_UT ';
sqlstring:=sqlstring|| '  FROM (SELECT PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.REL_GALLERIE_RACCORDO_PO ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         WHERE CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '        MINUS ';
sqlstring:=sqlstring|| '        SELECT PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring|| '          FROM  '|| s_schema||'.DICHIARAZIONI_GALLERIE_SD_PO ';
sqlstring:=sqlstring|| '         WHERE TIPO_DICHIARAZIONE= ''EC''  ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '         AND CODICE_VERSIONE  = ' ||p_versione;
END IF;
sqlstring:=sqlstring|| '         ) DIC, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.GALLERIE_RACCORDO_PO GAL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.REL_GALLERIE_RACCORDO_PO REL, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.BINARI_RACCORDO_PO BR, ';
sqlstring:=sqlstring|| '        '|| s_schema||'.PUNTI_OPERATIVI PO        ';
sqlstring:=sqlstring|| '         WHERE   DIC.PO_SD_TUNNEL_1_2_2_0_5_2=GAL.PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring|| '         AND GAL.PO_SD_TUNNEL_1_2_2_0_5_2=REL.PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring:=sqlstring|| '        AND REL.PO_SD_1_2_2_0_0_2=BR.PO_SD_1_2_2_0_0_2 ';
sqlstring:=sqlstring|| '        AND BR.SEDE_TECNICA=PO.SEDE_TECNICA ';
IF p_versione IS NOT NULL THEN
sqlstring:=sqlstring|| '        AND GAL.CODICE_VERSIONE  = ' ||p_versione;
sqlstring:=sqlstring|| '        AND GAL.CODICE_VERSIONE = REL.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '        AND REL.CODICE_VERSIONE = BR.CODICE_VERSIONE ';
sqlstring:=sqlstring|| '        AND BR.CODICE_VERSIONE = po.CODICE_VERSIONE ';
END IF;
sqlstring:=sqlstring|| '         ) tab_totale   ';                      --INSERITA SELECT ESTERNA PER CREARE UNA TABELLA UNICA SU CUI FARE POI LA SOTTOSELEZIONE PER IL ROUTING
sqlstring:=sqlstring|| '         WHERE DEFINIZIONE IS NOT NULL ';       --CODICE INUTILE; SERVE SOLO PER POTER ATTACCARE DOPO LA STRINGA DI SOTTOSELEZIONE DEL ROUTING (CHE INZIA PER 'and')

--filtro richiamato dalla funzione ROUTING
IF p_filtro is NOT NULL THEN
sqlstring:=sqlstring ||GetWhereCondition(p_filtro,'tab_totale.SEDE_TECNICA');
END IF;

--DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
END GetDichiarazioniEC_PO ;


--
-- --------------------------------------------------------------------------------------
--                           
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetCompatibilitaTrattaPO (p_area Number, p_i_versione Number, p_filtro Clob, p_cursor Out empcur) Is
-- REPORT 3.6.13
   s_schema VARCHAR2(100);
   sqlstring VARCHAR2(32767);
   p_versione NUMBER;

   Cursor Cur_col is
   Select  NOME_COLONNA from RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
     Where NECESSARIO_COMPATIBILITA = 1
       And nome_tabella = 'BINARI_CORSA_PO'
     Order By codice_parametro;

 Begin
   s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--
-- Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
   If (p_area = 1 Or p_area = 3) Then
      p_versione := Null;
   Else  --(p_area = 2 Or p_area = 4)
       If  p_i_versione Is Null Then
          p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
       Else
          p_versione := p_i_versione;
       End If;
   End If;
   sqlstring := 'Select ';
   sqlstring := sqlstring||' l.SEDE_TECNICA "CodiceLocalitaINRETE"';
   sqlstring := sqlstring||' , l.DEFINIZIONE "DefinizioneINRETE"';
   sqlstring := sqlstring||' , PO_1_2_1_0_0_1 "Codice del GI 1.2.1.0.0.1" '; 
   sqlstring := sqlstring||' , PO_1_2_1_0_0_2 "Identificazione del binario 1.2.1.0.0.2" ';
   sqlstring := sqlstring||' , PO_1_2_1_0_0_2_D "Definizione binario" ';
   For Rec_col in Cur_col loop
       sqlstring := sqlstring||' ,' ||Rec_col.NOME_COLONNA;
   End Loop;

 --      sqlstring := sqlstring||' , "L207" "Codice Linea" ';
   sqlstring := sqlstring||' , CODICE_DTP "Codice DTP"';
   sqlstring := sqlstring||' , CODICE_UT "Codice UT"';
   sqlstring := sqlstring||' From ';
   sqlstring := sqlstring|| s_schema||'.PUNTI_OPERATIVI l, ';
   sqlstring := sqlstring||' (Select CODICE_LOCALITA_PIC,';
   sqlstring := sqlstring||'         TIPO_LOCALITA,TIPO_PUNTOORARIO,';
   sqlstring := sqlstring||'         TIPO_LOCALITASBF,';
   sqlstring := sqlstring||'         FLAG_SERVIZIO_MERCI,';
   sqlstring := sqlstring||'         FLAG_SERVIZIO_VIAGGIATORI,';
   sqlstring := sqlstring||'         CASSIFICAZIONE_IAP,COD_LOCALITA_IN_RETE';
   sqlstring := sqlstring||'    From Rinf_Anagrafiche_Evo.LOCALITA_PIC';
   sqlstring := sqlstring||'   Where (COD_LOCALITA_IN_RETE, ';
   sqlstring := sqlstring||'    Nvl (DATA_SCADENZA, To_Date (''01012900'', ''DDMMYYYY''))) In';
   sqlstring := sqlstring||'  (  Select COD_LOCALITA_IN_RETE,';
   sqlstring := sqlstring||'     Max (';
   sqlstring := sqlstring||'       Nvl (DATA_SCADENZA,';
   sqlstring := sqlstring||'            To_Date (''01012900'', ''DDMMYYYY'')))';
   sqlstring := sqlstring||'      From Rinf_Anagrafiche_Evo.LOCALITA_PIC';
   sqlstring := sqlstring||'                      Group By COD_LOCALITA_IN_RETE)) p,';
   sqlstring := sqlstring||'          (Select CODICE_LOCALITA_ROMAN, CODICE_LOCALITA_PIC';
   sqlstring := sqlstring||'             From Rinf_Anagrafiche_Evo.LOCALITA_ROMAN';
   sqlstring := sqlstring||'            Where (CODICE_LOCALITA_PIC,';
   sqlstring := sqlstring||'                   Nvl (DATA_SCADENZA, To_Date (''01012900'', ''DDMMYYYY''))) IN';
   sqlstring := sqlstring||'                     (  Select CODICE_LOCALITA_PIC,';
   sqlstring := sqlstring||'                               Max (';
   sqlstring := sqlstring||'                                  Nvl (DATA_SCADENZA,';
   sqlstring := sqlstring||'                                       To_Date (''01012900'', ''DDMMYYYY'')))';
   sqlstring := sqlstring||'                          From Rinf_Anagrafiche_Evo.LOCALITA_ROMAN';
   sqlstring := sqlstring||'                      Group By CODICE_LOCALITA_PIC)) r';
   sqlstring := sqlstring||' , Rinf_Anagrafiche_Evo.ANAG_TIPO_PUNTOORARIO tpo  ';
   sqlstring := sqlstring||' , Rinf_Anagrafiche_Evo.ANAG_TIPO_LOCALITA tl, ';
   sqlstring := sqlstring|| '(Select v.SEDE_TECNICA, Listagg(PO_1_2_0_0_0_3 ,''-'' ) Within Group (ORDER BY PO_1_2_0_0_0_3) AS codice ';
   sqlstring := sqlstring|| 'From '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v,';
   sqlstring := sqlstring|| s_schema||'.PUNTI_OPERATIVI p';
   sqlstring := sqlstring|| ' Where  ';
   sqlstring := sqlstring|| ' p.sede_tecnica = v.sede_tecnica ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring||' And p.CODICE_VERSIONE = '||p_versione;
      sqlstring := sqlstring||' And v.CODICE_VERSIONE = '||p_versione;
   END IF;
   sqlstring:=sqlstring|| ' Group By v.SEDE_TECNICA) codice_taf_tap ';
   sqlstring:=sqlstring||' Where ';
   sqlstring:=sqlstring||' l.SEDE_TECNICA = P.COD_LOCALITA_IN_RETE ';
   sqlstring:=sqlstring||' And L.SEDE_TECNICA = codice_taf_tap.SEDE_TECNICA ';
   sqlstring:=sqlstring||' And r.CODICE_LOCALITA_PIC = P.CODICE_LOCALITA_PIC ';
   sqlstring:=sqlstring||' And tpo.CODICE_TIPO = P.TIPO_PUNTOORARIO';
   sqlstring:=sqlstring||' And P.TIPO_LOCALITA = tl.CODICE_TIPO';

   If p_versione Is Not Null Then
      sqlstring := sqlstring||' And l.CODICE_VERSIONE = '||p_versione;
   End If;

-- filtro richiamato dalla funzione ROUTING
   If p_filtro Is Not Null Then
      sqlstring := sqlstring ||GetWhereCondition(p_filtro, 'L.SEDE_TECNICA');
   End If;

   -- sqlstring:=sqlstring||' order by 1';
   -- DBMS_OUTPUT.PUT_LINE(sqlstring);
   Open p_cursor For sqlstring;
--   
  End GetCompatibilitaTrattaPO;

--   ********* Parametri Necessari per la Compatibilit  di Tratta (NCT) *********
-- ------------------------------------------------------------------------------------------------
--           PROCEDURE GetReport_RC_BinariCorsa_PO (report per la Route Compatibility) Reg.777/2019/UE
-- ------------------------------------------------------------------------------------------------
--  

PROCEDURE GetReport_RC_BinariCorsa_PO (p_area Number, p_i_versione Number, p_filtro Clob, p_cursor Out empcur) Is
-- REPORT 3.6.14

   s_schema Varchar2(100);
   sqlstring Varchar2(32767);
   p_versione Number;
/****
   Cursor Cur_col is
   Select  a.NOME_COLONNA, Nvl(b.NOME_COLONNA, a.NOME_COLONNA||'_AP') NOME_COLONNA_AP, a.Numero_parametro_Multiplo 
   from RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI a,
        RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI b
     Where a.NECESSARIO_COMPATIBILITA = 1
       And a.NOME_TABELLA = 'BINARI_CORSA_PO'
	   And a.NUMERO_PARAMETRO = b.NUMERO_PARAMETRO (+)
	   And b.NOME_COLONNA (+) like '%AP'
	   And a.Numero_parametro_Multiplo  not like '%B'
     Order By a.numero_parametro_multiplo;****/

 Begin
   s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--
-- 
   If (p_area = 1 Or p_area = 3) Then
       p_versione := Null;
   Else  --(p_area = 2 Or p_area = 4)
       If  p_i_versione Is Null Then
          p_versione := Pkg_Rinf_Data_V777.GetLastVersion(p_area);
       Else
          p_versione := p_i_versione;
       End If;
   End If;
--   
   sqlstring := 'Select ';
   sqlstring := sqlstring||' p.SEDE_TECNICA, ';   --"Codifica Punto Operativo"
   sqlstring := sqlstring||' p.DEFINIZIONE, ';    --"Definizione"
   sqlstring := sqlstring||' NVL (b.PO_TRACK_1_2_1_0_0_1, ''0083'')  PO_TRACK_1_2_1_0_0_1, ';      --"Codice del GI 1.2.1.0.0.1"
   sqlstring := sqlstring||' b.PO_TRACK_1_2_1_0_0_2,  ';                           --"Codifica binario 1.2.1.0.0.2"
   sqlstring := sqlstring||' b.PO_TRACK_1_2_1_0_0_2_D,  ';      --"Definizione binario"
/****
   For Rec_col In Cur_col Loop
--       sqlstring := sqlstring||' , Decode('||Rec_col.NOME_COLONNA_AP ||', ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription('''||Rec_col.NUMERO_PARAMETRO_MULTIPLO||''','||Rec_col.NOME_COLONNA ||')) as "'||Rec_col.NUMERO_PARAMETRO_MULTIPLO||'" ';
       sqlstring := sqlstring||'  Decode('||Rec_col.NOME_COLONNA_AP ||', ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription('''||Rec_col.NUMERO_PARAMETRO_MULTIPLO||''','||Rec_col.NOME_COLONNA ||')) as '||Rec_col.NOME_COLONNA ||', ';
   End Loop;
****/

---> inizio modifica reg 777/2109 del 16/12/2021
 sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_3_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.1.0.3.4.SUP'', PO_TRACK_1_2_1_0_3_4_SUP)||'' + ''||PKG_RINF_REPORT.GetDescription(''1.2.1.0.3.4.INF'', PO_TRACK_1_2_1_0_3_4_INF)) PO_TRACK_1_2_1_0_3_4, ';
 sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_3_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.1.0.3.5.A'', PO_TRACK_1_2_1_0_3_5_A)) PO_TRACK_1_2_1_0_3_5_A, '; -- per mantenere inalterata la label
 sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_3_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PO_TRACK_1_2_1_0_3_6) PO_TRACK_1_2_1_0_3_6, ';
 sqlstring := sqlstring || ' Decode(PO_TRACK_1_2_1_0_4_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.1.0.4.1'', PO_TRACK_1_2_1_0_4_1)) PO_TRACK_1_2_1_0_4_1, ';
---->
   sqlstring := sqlstring||'  v.CODICE "Codice_Linea_Commerciale",  ';  --"Codice_Linea_Commerciale" 
   sqlstring := sqlstring||' p.CODICE_DTP, ';         --"Codice DTP"
   sqlstring := sqlstring||' p.CODICE_UT, ';  --"Codice UT"
   sqlstring := sqlstring||' p.CODICE_LINEA_TECNICA ';            --"Codice Linea Tecnica"
--
   sqlstring := sqlstring||' From ';
   sqlstring := sqlstring|| s_schema||'.PUNTI_OPERATIVI p, ';
   sqlstring := sqlstring|| s_schema||'.BINARI_CORSA_PO b, ';
   sqlstring := sqlstring|| s_schema||'.REL_PO_BINARI_CORSA r, ';
   sqlstring := sqlstring|| '(Select SEDE_TECNICA, Listagg (CODICE, '';'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO  ';
   sqlstring := sqlstring|| ' where  CODICE_CONTESTO = 5 ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring||' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring|| ' Group By SEDE_TECNICA) v ';   
   sqlstring := sqlstring|| ' Where ';
   sqlstring := sqlstring|| ' p.SEDE_TECNICA = r.SEDE_TECNICA (+)';
   sqlstring := sqlstring|| ' And  b.PO_TRACK_1_2_1_0_0_2  = r.PO_TRACK_1_2_1_0_0_2 ';
   sqlstring := sqlstring|| ' And v.SEDE_TECNICA (+) = p.SEDE_TECNICA ';
--
   If p_versione Is Not Null Then
      sqlstring := sqlstring||' And p.CODICE_VERSIONE = '||p_versione;
      sqlstring := sqlstring||' And b.CODICE_VERSIONE = '||p_versione;
      sqlstring := sqlstring||' And r.CODICE_VERSIONE(+) = '||p_versione;
   End If;
--
--filtro richiamato dalla funzione ROUTING
   If p_filtro is Not Null Then
      sqlstring:=sqlstring ||Pkg_Rinf_Report.GetWhereCondition(p_filtro, 'p.SEDE_TECNICA');
   Else 
      sqlstring:=sqlstring||' order by p.CODICE_DTP, p.CODICE_UT, p.SEDE_TECNICA, b.PO_TRACK_1_2_1_0_0_2';
   End If;

--   Dbms_Output.Put_Line(sqlstring);

   Open p_cursor For sqlstring;
--
 Exception
   When NO_DATA_FOUND Then
     Null;
   When Others Then
      raise_application_error(-20001,'GetReport_RC_BinariCorsa_PO - '||SQLCODE||' - ERROR - '||SQLERRM);

--   
  End GetReport_RC_BinariCorsa_PO;
--
-- ------------------------------------------------------------------------------------------------
--         PROCEDURE GetReport_RC_BinariCorsa_SOL (report per la Route Compatibility) Reg.777/2019/UE
-- ------------------------------------------------------------------------------------------------
--  
 PROCEDURE GetReport_RC_BinariCorsa_SOL (p_area Number, p_i_versione Number , p_filtro Clob, p_cursor Out empcur) Is

--REPORT 3.6.15
    s_schema Varchar2(100);
    sqlstring Varchar2(32767);
    p_versione Number;

/****
  Cursor Cur_col is
   Select replace(a.NOME_COLONNA, 'PENDENZA', 'SOL_TRACK_1_1_1_1_3_6') NOME_COLONNA,
          Nvl(b.NOME_COLONNA, replace(replace(replace(replace (a.NOME_COLONNA, '_A', ''), '_B', ''), '_C', ''), 'PENDENZA', 'SOL_TRACK_1_1_1_1_3_6')||'_AP') NOME_COLONNA_AP, 
           a.Numero_parametro_Multiplo
   from RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI a,
       RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI b
     Where a.NECESSARIO_COMPATIBILITA = 1
       And a.NOME_TABELLA = 'BINARI_CORSA_SOL'
	   And a.NUMERO_PARAMETRO = b.NUMERO_PARAMETRO (+)
	   And b.NOME_COLONNA (+) like '%AP'
    Order By replace (replace(a.numero_parametro_multiplo,'.11.', '.9.'), '.10', '.910');
****/


--
 Begin
   s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--
-- 
    If (p_area = 1 Or p_area = 3) Then
        p_versione := Null;
    Else  --(p_area = 2 Or p_area = 4)
        If  p_i_versione Is Null Then	
           p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
        Else
           p_versione := p_i_versione;
        End If;
    End If;
 --

   sqlstring := 'Select sl.SEDE_TECNICA, ';                      -- "Codifica Sezione di Linea"
   sqlstring := sqlstring || ' sl.DEFINIZIONE, ';                -- "Definizione"
   sqlstring := sqlstring || ' sl.SOL_1_1_0_0_0_1, ';            -- "Codice del GI 1.1.0.0.0.1"
   sqlstring := sqlstring || ' bc.SOL_TRACK_1_1_1_0_0_1, ';      -- "Codifica binario 1.1.1.0.0.1"
   sqlstring := sqlstring || ' bc.SOL_TRACK_1_1_1_0_0_1_D, ';    -- "Definizione binario"
--
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 13/05/2021
-- Modifica da apportare al report delle Route Compatibility PROCEDURE GetReport_RC_BinariCorsa_SOL   per avere un unico campo di output i tre valori del parametro 
-- 1.1.1.2.3.3 - EPA_NumRaisedSpeed - Requisiti in materia di numero di pantografi alzati e distanza tra loro, a una data velocit 
-- ----------------------------------------------------------------------------------------------------------------------------------------

/****
   For Rec_col In Cur_col Loop
--
    If (Rec_col.NUMERO_PARAMETRO_MULTIPLO = '1.1.1.2.3.3.A') Or (Rec_col.NUMERO_PARAMETRO_MULTIPLO = '1.1.1.2.3.3.B') Then 
	    Null;
--	
	ElsIf (Rec_col.NUMERO_PARAMETRO_MULTIPLO = '1.1.1.2.3.3.C') Then
           sqlstring := sqlstring ||' Decode(SOL_TRACK_1_1_1_2_3_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', ';
           sqlstring := sqlstring ||' Decode(PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.3.A'', SOL_TRACK_1_1_1_2_3_3_A) ||''+''|| PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.3.B'', SOL_TRACK_1_1_1_2_3_3_B) ||''+''||  PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.3.C'', SOL_TRACK_1_1_1_2_3_3_C), ''++'', Null,   ';
	       sqlstring := sqlstring ||' PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.3.A'', SOL_TRACK_1_1_1_2_3_3_A) ||'' ''||  PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.3.B'', SOL_TRACK_1_1_1_2_3_3_B) ||'' ''||  PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.3.C'', SOL_TRACK_1_1_1_2_3_3_C) ) ) SOL_TRACK_1_1_1_2_3_3 ,';
--  
    Else 
       sqlstring := sqlstring||' Decode('||Rec_col.NOME_COLONNA_AP ||', ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription('''||Rec_col.NUMERO_PARAMETRO_MULTIPLO||''','||Rec_col.NOME_COLONNA ||')) '||Rec_col.NOME_COLONNA||', ';
    End If;
--
   End Loop;
****/
---> mofica Reg.777/2019/UE 16/12/2021
-- INF 
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4'', cap_carico.SOL_TRACK_1_1_1_1_2_4)) SOL_TRACK_1_1_1_1_2_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4.1'', SOL_TRACK_1_1_1_1_2_4_1)) SOL_TRACK_1_1_1_1_2_4_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4.2'', SOL_TRACK_1_1_1_1_2_4_2)) SOL_TRACK_1_1_1_1_2_4_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4.3'', SOL_TRACK_1_1_1_1_2_4_3)) SOL_TRACK_1_1_1_1_2_4_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4.4'', SOL_TRACK_1_1_1_1_2_4_4)) SOL_TRACK_1_1_1_1_2_4_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.5'', SOL_TRACK_1_1_1_1_2_5)) SOL_TRACK_1_1_1_1_2_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.6'', SOL_TRACK_1_1_1_1_2_6)) SOL_TRACK_1_1_1_1_2_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.8'', SOL_TRACK_1_1_1_1_2_8)) SOL_TRACK_1_1_1_1_2_8, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_1_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1.1.SUP'', SOL_TRACK_1_1_1_1_3_1_1_SUP)||'' + ''||PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1.1.INF'', SOL_TRACK_1_1_1_1_3_1_1_INF)) SOL_TRACK_1_1_1_1_3_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_1_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1.2'', SOL_TRACK_1_1_1_1_3_1_2)) SOL_TRACK_1_1_1_1_3_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_1_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1.3'', SOL_TRACK_1_1_1_1_3_1_3)) SOL_TRACK_1_1_1_1_3_1_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.6'', p.SOL_TRACK_1_1_1_1_3_6)) SOL_TRACK_1_1_1_1_3_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.7'', SOL_TRACK_1_1_1_1_3_7)) SOL_TRACK_1_1_1_1_3_7, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_4_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.4.1'',SOL_TRACK_1_1_1_1_4_1))SOL_TRACK_1_1_1_1_4_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_4_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.4.2'',SOL_TRACK_1_1_1_1_4_2))SOL_TRACK_1_1_1_1_4_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_4_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.4.3'',SOL_TRACK_1_1_1_1_4_3))SOL_TRACK_1_1_1_1_4_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_5_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.5.2'',SOL_TRACK_1_1_1_1_5_2))SOL_TRACK_1_1_1_1_5_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',TRIM(PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.1'',TRIM (SOL_TRACK_1_1_1_1_6_1))))SOL_TRACK_1_1_1_1_6_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.2'',SOL_TRACK_1_1_1_1_6_2))SOL_TRACK_1_1_1_1_6_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.3'',SOL_TRACK_1_1_1_1_6_3))SOL_TRACK_1_1_1_1_6_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.4'', SOL_TRACK_1_1_1_1_6_4)) SOL_TRACK_1_1_1_1_6_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_5_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.5'', SOL_TRACK_1_1_1_1_6_5)) SOL_TRACK_1_1_1_1_6_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.4'', SOL_TRACK_1_1_1_1_7_4)) SOL_TRACK_1_1_1_1_7_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_5_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.5'', SOL_TRACK_1_1_1_1_7_5)) SOL_TRACK_1_1_1_1_7_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_6_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.6'', SOL_TRACK_1_1_1_1_7_6)) SOL_TRACK_1_1_1_1_7_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_7_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.7'', SOL_TRACK_1_1_1_1_7_7)) SOL_TRACK_1_1_1_1_7_7, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_8_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.8'', SOL_TRACK_1_1_1_1_7_8)) SOL_TRACK_1_1_1_1_7_8, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_9_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.9'', SOL_TRACK_1_1_1_1_7_9)) SOL_TRACK_1_1_1_1_7_9, ';
-- ENE
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_1_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.1.1'', SOL_TRACK_1_1_1_2_2_1_1)) SOL_TRACK_1_1_1_2_2_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_1_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.1.2'', SOL_TRACK_1_1_1_2_2_1_2)) SOL_TRACK_1_1_1_2_2_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_1_2_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.1.2.1'', SOL_TRACK_1_1_1_2_2_1_2_1)) SOL_TRACK_1_1_1_2_2_1_2_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_1_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.1.3'', SOL_TRACK_1_1_1_2_2_1_3)) SOL_TRACK_1_1_1_2_2_1_3, ';

 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.3'', SOL_TRACK_1_1_1_2_2_3)) SOL_TRACK_1_1_1_2_2_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.4'', SOL_TRACK_1_1_1_2_2_4)) SOL_TRACK_1_1_1_2_2_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_5_AP, ''NYA'','' '', ''N'', ''Non applicabile'', Trim (To_Char (Round (SOL_TRACK_1_1_1_2_2_5, 2), ''999990.99''))) SOL_TRACK_1_1_1_2_2_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_6_AP, ''NYA'','' '', ''N'', ''Non applicabile'', Trim (To_Char (Round (SOL_TRACK_1_1_1_2_2_6, 2), ''999990.99''))) SOL_TRACK_1_1_1_2_2_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_3_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.1'', SOL_TRACK_1_1_1_2_3_1)) SOL_TRACK_1_1_1_2_3_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_3_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.2'', SOL_TRACK_1_1_1_2_3_2)) SOL_TRACK_1_1_1_2_3_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_3_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', ';
 /*
 sqlstring := sqlstring || ' Decode ( SOL_TRACK_1_1_1_2_3_3_A ';
 sqlstring := sqlstring || ' || '' '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_3_3_B ';
 sqlstring := sqlstring || ' || '' '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_3_3_C, ';
 sqlstring := sqlstring || ' ''++'', NULL, ';
 sqlstring := sqlstring || '    SOL_TRACK_1_1_1_2_3_3_A ';
 sqlstring := sqlstring || ' || '' '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_3_3_B ';
 sqlstring := sqlstring || ' || '' '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_3_3_C)) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_3_3, ';
*/
 sqlstring := sqlstring ||' Decode(PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.3.A'', SOL_TRACK_1_1_1_2_3_3_A) ||''+''|| PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.3.B'', SOL_TRACK_1_1_1_2_3_3_B) ||''+''||  PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.3.C'', SOL_TRACK_1_1_1_2_3_3_C), ''++'', Null,   ';
 sqlstring := sqlstring ||' PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.3.A'', SOL_TRACK_1_1_1_2_3_3_A) ||'' ''||  PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.3.B'', SOL_TRACK_1_1_1_2_3_3_B) ||'' ''||  PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.3.C'', SOL_TRACK_1_1_1_2_3_3_C) ) ) SOL_TRACK_1_1_1_2_3_3 ,';



 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_3_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.4'', SOL_TRACK_1_1_1_2_3_4)) SOL_TRACK_1_1_1_2_3_4, ';

 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_4_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.4.3'', SOL_TRACK_1_1_1_2_4_3)) SOL_TRACK_1_1_1_2_4_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_5_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.5.1'', SOL_TRACK_1_1_1_2_5_1)) SOL_TRACK_1_1_1_2_5_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_5_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.5.2'', SOL_TRACK_1_1_1_2_5_2)) SOL_TRACK_1_1_1_2_5_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_5_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.5.3'', SOL_TRACK_1_1_1_2_5_3)) SOL_TRACK_1_1_1_2_5_3, ';

-- CCS
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.8'', SOL_TRACK_1_1_1_3_2_8)) SOL_TRACK_1_1_1_3_2_8, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_9_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.9'', SOL_TRACK_1_1_1_3_2_9)) SOL_TRACK_1_1_1_3_2_9, ';

 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.4'', SOL_TRACK_1_1_1_3_3_4)) SOL_TRACK_1_1_1_3_3_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.5'', SOL_TRACK_1_1_1_3_3_5)) SOL_TRACK_1_1_1_3_3_5, ';

 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_9_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.9'', SOL_TRACK_1_1_1_3_3_9)) SOL_TRACK_1_1_1_3_3_9, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_10_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.10'', SOL_TRACK_1_1_1_3_3_10)) SOL_TRACK_1_1_1_3_3_10, ';

 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_5_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.5.3'', SOL_TRACK_1_1_1_3_5_3)) SOL_TRACK_1_1_1_3_5_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_6_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.6.1'', SOL_TRACK_1_1_1_3_6_1)) SOL_TRACK_1_1_1_3_6_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_1_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1)) SOL_TRACK_1_1_1_3_7_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_1_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.2'', SOL_TRACK_1_1_1_3_7_1_2)) SOL_TRACK_1_1_1_3_7_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_1_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.3'', SOL_TRACK_1_1_1_3_7_1_3)) SOL_TRACK_1_1_1_3_7_1_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_1_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.4'',SOL_TRACK_1_1_1_3_7_1_4)) SOL_TRACK_1_1_1_3_7_1_4, ';

 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_11_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.11.1'', SOL_TRACK_1_1_1_3_11_1)) SOL_TRACK_1_1_1_3_11_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_11_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.11.2'', SOL_TRACK_1_1_1_3_11_2)) SOL_TRACK_1_1_1_3_11_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_11_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.11.3'', SOL_TRACK_1_1_1_3_11_3)) SOL_TRACK_1_1_1_3_11_3, ';

--->
   sqlstring := sqlstring || ' v.CODICE "Codice_linea_commerciale", ';             --"Codice Linea Commerciale"
   sqlstring := sqlstring || ' CODICE_DTP, '; --"Codice DTP"
   sqlstring := sqlstring || ' CODICE_UT, ';  --"Codice UT"
   sqlstring := sqlstring || ' CODICE_LINEA_TECNICA '; --"Codice Linea Tecnica"
--
   sqlstring := sqlstring || ' From '||s_schema||'.BINARI_CORSA_SOL bc, ';
   sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA sl, ';
--
   sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
   sqlstring := sqlstring || ' Listagg(Decode(Sign(Nvl(PENDENZA, 99.9)), -1, Trim(To_Char(PENDENZA,''9999999999999990.9'')), ''+''||Trim(To_Char(Nvl(PENDENZA, 99.9),''9999999999999990.9'')))|| ''(''||Trim(To_Char(Least(KM_INIZIO, KM_FINE), ''9999999999999990.999''))||'')'','';'') Within Group (Order By Least(KM_INIZIO, KM_FINE)) AS SOL_TRACK_1_1_1_1_3_6 '; --PENDENZA  ';
   sqlstring := sqlstring || '   From '||s_schema||'.PAR_1_1_1_1_3_6_GRADIENTE ';
   If p_versione Is Not Null Then
           sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
   End If;
   sqlstring := sqlstring || ' group by SOL_TRACK_1_1_1_0_0_1) p, ';
--
   sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, Listagg(SOL_TRACK_1_1_1_1_2_4, '';'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_1_2_4) AS SOL_TRACK_1_1_1_1_2_4 ';
   sqlstring := sqlstring || '   From '||s_schema||'.PAR_1_1_1_1_2_4_CAP_CARICO ';
   If p_versione Is Not Null Then
           sqlstring :=sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
   End If;
   sqlstring := sqlstring || ' group by SOL_TRACK_1_1_1_0_0_1) cap_carico, ';
--
   sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, Listagg(SOL_TRACK_1_1_1_1_2_4_3, '';'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_1_2_4_3) As SOL_TRACK_1_1_1_1_2_4_3  ';
   sqlstring := sqlstring || '   From '||s_schema||'.PAR_1_1_1_1_2_4_3_LOCAVERSPEC  ';
   If p_versione Is Not Null Then
           sqlstring:=sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
   End If;
   sqlstring := sqlstring || '  Group By SOL_TRACK_1_1_1_0_0_1 ) Locaverspec,	';
--
   sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, Listagg(SOL_TRACK_1_1_1_1_7_8, '';'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_1_7_8) As SOL_TRACK_1_1_1_1_7_8 ';
   sqlstring := sqlstring || '   From  '||s_schema||'.PAR_1_1_1_1_7_8_LOCA_SIST_RTB  ';
   If p_versione Is Not Null Then
           sqlstring:=sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
   End If;
   sqlstring := sqlstring || '   Group By SOL_TRACK_1_1_1_0_0_1) Loca_Sist_Rtb,  ';
--
   sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, Listagg(PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.9'', SOL_TRACK_1_1_1_3_2_9), '';'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_2_9) As SOL_TRACK_1_1_1_3_2_9 ';
   sqlstring := sqlstring || '   From '||s_schema||'.PAR_1_1_1_3_2_9_COMP_ETCS  ';
   If p_versione Is Not Null Then
           sqlstring:=sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
   End If;
   sqlstring := sqlstring || '  Group By SOL_TRACK_1_1_1_0_0_1) Comp_Etcs, ';  
--
   sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, Listagg(PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.5'', SOL_TRACK_1_1_1_3_3_5), '';'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_3_5) As SOL_TRACK_1_1_1_3_3_5 ';
   sqlstring := sqlstring || '   From '||s_schema||'.PAR_1_1_1_3_3_5_RETI_GSM_R  ';
   If p_versione Is Not Null Then
           sqlstring:=sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
   End If;
   sqlstring := sqlstring || '  Group By SOL_TRACK_1_1_1_0_0_1)  Reti_Gsm_R,  ';   
--
   sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, Listagg(PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.9'', SOL_TRACK_1_1_1_3_3_9), '';'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_3_9) As SOL_TRACK_1_1_1_3_3_9 ';
   sqlstring := sqlstring || '   From  '||s_schema||'.PAR_1_1_1_3_3_9_RADIO_VOCE  ';
   If p_versione Is Not Null Then
           sqlstring:=sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
   End If;
   sqlstring := sqlstring || '   Group By SOL_TRACK_1_1_1_0_0_1 ) Radio_Voce,  ';
--
   sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, Listagg(PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.10'', SOL_TRACK_1_1_1_3_3_10), '';'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_3_10) As SOL_TRACK_1_1_1_3_3_10 ';
   sqlstring := sqlstring || '   From '||s_schema||'.PAR_1_1_1_3_3_10_RADIO_DATI  ';
   If p_versione Is Not Null Then
           sqlstring:=sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
   End If;
   sqlstring := sqlstring || '  Group By SOL_TRACK_1_1_1_0_0_1 ) Radio_Dati,  ';
--
   sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, Listagg(PKG_RINF_REPORT.GetDescription(''1.1.1.3.5.3'', SOL_TRACK_1_1_1_3_5_3), '';'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_5_3) As SOL_TRACK_1_1_1_3_5_3 ';
   sqlstring := sqlstring || '   From '||s_schema||'.PAR_1_1_1_3_5_3_SIST_PRE_PROT  ';
   If p_versione Is Not Null Then
           sqlstring:=sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
   End If;
   sqlstring := sqlstring || '  Group By SOL_TRACK_1_1_1_0_0_1 ) Sist_Pre_Prot, ';
--
   sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, Listagg(PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.3'', SOL_TRACK_1_1_1_3_7_1_3), '';'') Within Group (Order By KM_INIZIO, SOL_TRACK_1_1_1_3_7_1_3) As SOL_TRACK_1_1_1_3_7_1_3 ';
   sqlstring := sqlstring || '   From '||s_schema||'.PAR_1_1_1_3_7_1_3_SISTRILTRAIN '; 
   If p_versione Is Not Null Then
           sqlstring:=sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
   End If;
   sqlstring := sqlstring || '  Group By  SOL_TRACK_1_1_1_0_0_1 )  Sis_Ril_Doc, ';
--
   sqlstring := sqlstring || '(Select SEDE_TECNICA, Listagg (CODICE, '';'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO  ';
   sqlstring := sqlstring || ' where  CODICE_CONTESTO = 5 ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring ||' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring || ' Group By SEDE_TECNICA) v ';   
--
   sqlstring := sqlstring || ' Where  bc.SEDE_TECNICA = sl.SEDE_TECNICA ';
   sqlstring := sqlstring || ' And v.SEDE_TECNICA (+) = sl.SEDE_TECNICA ';                     ---> AGGIUNTO (+)
--
   sqlstring := sqlstring || '  and bc.SOL_TRACK_1_1_1_0_0_1 = P.SOL_TRACK_1_1_1_0_0_1 (+) ';
   sqlstring := sqlstring || '  and bc.SOL_TRACK_1_1_1_0_0_1 = cap_carico.SOL_TRACK_1_1_1_0_0_1 (+) ';
   sqlstring := sqlstring || '  and bc.sol_track_1_1_1_0_0_1 = Locaverspec.sol_track_1_1_1_0_0_1 (+) ';
   sqlstring := sqlstring || '  and bc.sol_track_1_1_1_0_0_1 = Loca_Sist_Rtb.sol_track_1_1_1_0_0_1 (+) ';
   sqlstring := sqlstring || '  and bc.sol_track_1_1_1_0_0_1 = Comp_Etcs.sol_track_1_1_1_0_0_1 (+) ';
   sqlstring := sqlstring || '  and bc.sol_track_1_1_1_0_0_1 = Reti_Gsm_R.sol_track_1_1_1_0_0_1 (+) ';
   sqlstring := sqlstring || '  and bc.sol_track_1_1_1_0_0_1 = Radio_Voce.sol_track_1_1_1_0_0_1 (+) ';
   sqlstring := sqlstring || '  and bc.sol_track_1_1_1_0_0_1 = Radio_Dati.sol_track_1_1_1_0_0_1 (+) ';
   sqlstring := sqlstring || '  and bc.sol_track_1_1_1_0_0_1 = Sist_Pre_Prot.sol_track_1_1_1_0_0_1 (+) ';
   sqlstring := sqlstring || '  and bc.sol_track_1_1_1_0_0_1 = Sis_Ril_Doc.sol_track_1_1_1_0_0_1 (+) ';
--
   If p_versione Is Not Null Then
      sqlstring := sqlstring || '  And bc.CODICE_VERSIONE = ' ||p_versione;
      sqlstring := sqlstring || '  And sl.CODICE_VERSIONE = bc.CODICE_VERSIONE ';
   End If;
--filtro richiamato dalla funzione ROUTING
   If p_filtro is Not Null Then
      sqlstring:=sqlstring ||pkg_rinf_report.GetWhereCondition(p_filtro,'SL.SEDE_TECNICA');
   Else 
      sqlstring := sqlstring || ' Order by CODICE_DTP, CODICE_UT, sl.SEDE_TECNICA';
   End If;   
--
--   Dbms_Output.Put_Line('Lunghezza stringa: '||length(sqlstring));
--   Dbms_Output.Put_Line(sqlstring);
--
   Open p_cursor For sqlstring;
/*
SOL_TRACK_1_1_1_3_7_1_3  PAR_1_1_1_3_7_1_3_SISTRILTRAIN
SOL_TRACK_1_1_1_3_5_3    PAR_1_1_1_3_5_3_SIST_PRE_PROT
SOL_TRACK_1_1_1_3_2_9    PAR_1_1_1_3_2_9_COMP_ETCS, 
SOL_TRACK_1_1_1_3_3_10   PAR_1_1_1_3_3_10_RADIO_DATI
SOL_TRACK_1_1_1_3_3_5    PAR_1_1_1_3_3_5_RETI_GSM_R
SOL_TRACK_1_1_1_3_2_9    PAR_1_1_1_3_2_9_COMP_ETCS
SOL_TRACK_1_1_1_1_7_8    PAR_1_1_1_1_7_8_LOCA_SIST_RTB
SOL_TRACK_1_1_1_1_2_4_3  PAR_1_1_1_1_2_4_3_LOCAVERSPEC
PENDENZA                 PAR_1_1_1_1_3_6_GRADIENTE
SOL_TRACK_1_1_1_1_2_4    PAR_1_1_1_1_2_4_CAP_CARICO
*/

 Exception
   When NO_DATA_FOUND Then
     Null;
   When Others Then
      raise_application_error(-20001,'GetReport_RC_BinariCorsa_SOL - '||SQLCODE||' - ERROR - '||SQLERRM);
 END GetReport_RC_BinariCorsa_SOL;
--
-- ------------------------------------------------------------------------------------------------
--         PROCEDURE GetReport_RC_BinariRaccordo_PO (report per la Route Compatibility) Reg.777/2019/UE
-- ------------------------------------------------------------------------------------------------
--  
 PROCEDURE GetReport_RC_BinariRaccordo_PO (p_area Number, p_i_versione Number, p_filtro Clob, p_cursor Out empcur) Is
-- REPORT 3.6.16
--
   s_schema Varchar2(100);
   sqlstring Varchar2(32767);
   p_versione Number;
/***
   Cursor Cur_col is
 Select  a.NOME_COLONNA, nvl(b.NOME_COLONNA, replace(replace (a.NOME_COLONNA, '_A', ''), '_B', '')||'_AP') NOME_COLONNA_AP, a.Numero_parametro_Multiplo 
   from RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI a,
       RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI b
     Where a.NECESSARIO_COMPATIBILITA = 1
       And a.NOME_TABELLA = 'BINARI_RACCORDO_PO'
	   And a.NUMERO_PARAMETRO = b.NUMERO_PARAMETRO (+)
	   And b.NOME_COLONNA (+) like '%AP'
     Order By a.numero_parametro_multiplo;
***/
 Begin
   s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
-- 
   If (p_area = 1 Or p_area = 3) Then
       p_versione := Null;
   Else  --(p_area = 2 Or p_area = 4)
       If  p_i_versione Is Null Then
          p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
       Else
          p_versione := p_i_versione;
       End If;
   End If;
--
--
   sqlstring := 'Select ';
   sqlstring := sqlstring ||' p.SEDE_TECNICA, ';  --"Codifica Punto Operativo"
   sqlstring := sqlstring ||' p.DEFINIZIONE, ';   --"Definizione"
   sqlstring := sqlstring ||' NVL (PO_SD_1_2_2_0_0_1, ''0083'') PO_SD_1_2_2_0_0_1, ';     --"Codice del GI 1.2.2.0.0.1"
   sqlstring := sqlstring ||' b.PO_SD_1_2_2_0_0_2,  ';  --"Codifica binario 1.2.2.0.0.2"
   sqlstring := sqlstring ||' b.PO_SD_1_2_2_0_0_2_D , ';     --"Definizione binario"
--
/***
   For Rec_col In Cur_col Loop
--       sqlstring := sqlstring ||' , Decode('||Rec_col.NOME_COLONNA_AP ||', ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription('''||Rec_col.NUMERO_PARAMETRO_MULTIPLO||''','||Rec_col.NOME_COLONNA ||')) as "'||Rec_col.NUMERO_PARAMETRO_MULTIPLO||'" ';
       sqlstring := sqlstring ||' Decode('||Rec_col.NOME_COLONNA_AP ||', ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription('''||Rec_col.NUMERO_PARAMETRO_MULTIPLO||''','||Rec_col.NOME_COLONNA ||')) as '||Rec_col.NOME_COLONNA||', ';
   End Loop;
--
***/
--->

---> modifica del 16/02/2023 con mail di richiesta RFI 
--   sqlstring := sqlstring ||' PO_SD_1_2_2_0_2_1, ';
   sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_2_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PO_SD_1_2_2_0_2_1) PO_SD_1_2_2_0_2_1, ';
--->

   sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_3_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Trim (To_Char (Round (PO_SD_1_2_2_0_3_1, 1), ''999990.9''))) PO_SD_1_2_2_0_3_1, ';
   sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_3_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.3.2'',PO_SD_1_2_2_0_3_2)) PO_SD_1_2_2_0_3_2, ';
   sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_3_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Decode (PO_SD_1_2_2_0_3_3_A || ''+'' || PO_SD_1_2_2_0_3_3_B,''+'', NULL, PO_SD_1_2_2_0_3_3_A || ''+'' || PO_SD_1_2_2_0_3_3_B)) PO_SD_1_2_2_0_3_3, ';
   sqlstring := sqlstring ||' Decode(PO_SD_1_2_2_0_6_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.6.1'', PO_SD_1_2_2_0_6_1)) PO_SD_1_2_2_0_6_1, ';
--->

   sqlstring := sqlstring ||' v.CODICE "Codice_Linea_Commerciale",  ';   --"Codice Linea Commerciale"
   sqlstring := sqlstring ||' p.CODICE_DTP, ';   --"Codice DTP"
   sqlstring := sqlstring ||' p.CODICE_UT, ';   --"Codice UT"
   sqlstring := sqlstring ||' p.CODICE_LINEA_TECNICA ';   --"Codice Linea Tecnica"
--
   sqlstring := sqlstring ||' From ';
   sqlstring := sqlstring || s_schema||'.PUNTI_OPERATIVI p, ';
   sqlstring := sqlstring || s_schema||'.BINARI_RACCORDO_PO b, ';
   sqlstring := sqlstring || '(Select SEDE_TECNICA, Listagg (CODICE, '';'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO ';
   sqlstring := sqlstring || ' Where  CODICE_CONTESTO = 5 ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring ||' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring|| ' Group By SEDE_TECNICA) v ';   
--   
   sqlstring := sqlstring || ' Where p.SEDE_TECNICA = b.SEDE_TECNICA ';
   sqlstring := sqlstring || '   And v.SEDE_TECNICA(+) = p.SEDE_TECNICA ';
--   
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And p.CODICE_VERSIONE = b.CODICE_VERSIONE ';
      sqlstring := sqlstring || ' And b.CODICE_VERSIONE = '||p_versione;
   End If;
--filtro richiamato dalla funzione ROUTING
   If p_filtro is Not Null Then
      sqlstring := sqlstring || pkg_rinf_report.GetWhereCondition(p_filtro,'p.SEDE_TECNICA');
   Else 
      sqlstring := sqlstring||' order by p.CODICE_DTP, p.CODICE_UT, p.SEDE_TECNICA, b.PO_SD_1_2_2_0_0_2';
   End If;
--
--   DBMS_OUTPUT.PUT_LINE(sqlstring);
--
   Open p_cursor For sqlstring;
--
 Exception
   When NO_DATA_FOUND Then
     Null;
   When Others Then
      raise_application_error(-20001,'GetReport_RC_BinariRaccordo_PO - '||SQLCODE||' - ERROR - '||SQLERRM);
--   
  End GetReport_RC_BinariRaccordo_PO;
--
-- ------------------------------------------------------------------------------------------------
--         PROCEDURE GetReport_RC_PO (report per la Route Compatibility) Reg.777/2019/UE
-- ------------------------------------------------------------------------------------------------
--  
 PROCEDURE GetReport_RC_PO (p_area Number, p_i_versione Number, p_filtro Clob, p_cursor Out empcur) Is
-- REPORT 3.6.17
   s_schema Varchar2(100);
   sqlstring Varchar2(32767);
   p_versione Number;

 Begin
   s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
-- 
   If (p_area = 1 Or p_area = 3) Then
       p_versione := Null;
   Else  --(p_area = 2 Or p_area = 4)
       If  p_i_versione Is Null Then
          p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
       Else
          p_versione := p_i_versione;
       End If;
   End If;
--   
   sqlstring := 'Select ';
   sqlstring := sqlstring || ' p.SEDE_TECNICA, ';						-- "Codifica Punto Operativo"
   sqlstring := sqlstring || ' p.DEFINIZIONE, ';           				-- "Definizione"
--
   sqlstring := sqlstring || 'Nvl(Trim(LINEA_COMM.LINEA),''0000 - 0.000'') PO_1_2_0_0_0_6, ';
--
--   sqlstring:=sqlstring || ' Latitude ('|| Trim(To_Char(Trunc(LATITUDINE, 7),'999.9999999'))|| ') + Longitude ('|| Trim(To_Char(Trunc(LONGITUDINE, 7),'S999.9999999'))|| PO_1_2_0_0_0_5, ')';
   sqlstring := sqlstring || ' ''Latitude (''|| Case When LATITUDINE = 0  Then ''0.0'' Else Trim (To_Char (Trunc (LATITUDINE, 7), ''999.9999999'')) End || '') '' ||';
   sqlstring := sqlstring || '''+ Longitude (''|| Case When LONGITUDINE = 0 Then ''0.0'' Else Trim (To_Char (Trunc (LONGITUDINE, 7), ''S999.9999999'')) End|| '')'' PO_1_2_0_0_0_5, ';
--
   sqlstring := sqlstring || ' Decode(PO_1_2_0_0_0_4_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.0.0.0.4.1'', PO_1_2_0_0_0_4_1)) as PO_1_2_0_0_0_4_1, ';
   sqlstring := sqlstring || ' v.CODICE "Codice_Linea_Commerciale", '; 	-- "Codice Linea Commerciale"
   sqlstring := sqlstring || ' p.CODICE_DTP, ';               			--"Codice DTP"
   sqlstring := sqlstring || ' p.CODICE_UT, ';                   		-- "Codice UT"
   sqlstring := sqlstring || ' p.CODICE_LINEA_TECNICA ';        		--"Codice Linea Tecnica"
-- 
   sqlstring := sqlstring || ' From ';
   sqlstring := sqlstring || s_schema|| '.PUNTI_OPERATIVI p, ';
--->
 --  sqlstring := sqlstring || '(Select v.SEDE_TECNICA, Listagg(REPLACE(CODICE,'' '','''')||'' - ''||Trim(To_Char(ROUND(KM_INIZIO,3),''999990.999'')) ,''#'' ) Within Group (Order By CODICE) AS linea ';
   sqlstring := sqlstring || '(Select v.SEDE_TECNICA, Listagg(REPLACE(CODICE,'' '','''')||'' - ''||Trim(To_Char(ROUND(KM_INIZIO,3),''999990.999'')) ,''; '' ) Within Group (Order By CODICE) AS linea ';
   sqlstring := sqlstring || 'From '||s_schema||'.V_MDR_LINEE_COMMERCIALI v ';
   If P_VERSIONE Is Not Null Then
      sqlstring := sqlstring || ' Where  ';
      sqlstring := sqlstring || ' v.CODICE_VERSIONE = '||p_versione ;
   End If;
      sqlstring := sqlstring || ' Group By v.SEDE_TECNICA) linea_comm, ';
--->
   sqlstring := sqlstring || '(Select SEDE_TECNICA, Listagg (CODICE, ''-'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO  ';
   sqlstring := sqlstring || ' where  CODICE_CONTESTO = 5 ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring ||' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring || ' Group By SEDE_TECNICA) v ';   
--  
   sqlstring := sqlstring || ' Where ';
   sqlstring := sqlstring || ' v.SEDE_TECNICA (+) = p.SEDE_TECNICA ';   ---> aggiunto (+)
--->
  sqlstring := sqlstring || ' And p.SEDE_TECNICA = linea_comm.SEDE_TECNICA (+) ';
--->
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And p.CODICE_VERSIONE = '||p_versione;
   End If;
--
--filtro richiamato dalla funzione ROUTING
   If p_filtro is Not Null Then
       sqlstring := sqlstring || Pkg_Rinf_Report.GetWhereCondition(p_filtro, 'p.SEDE_TECNICA');
   Else 
       sqlstring := sqlstring ||' order by p.CODICE_DTP, p.CODICE_UT, p.SEDE_TECNICA';
   End If;

--     DBMS_OUTPUT.PUT_LINE(sqlstring);
   Open p_cursor For sqlstring;
--
 Exception
   When NO_DATA_FOUND Then
		Null;
   When Others Then
		raise_application_error(-20001,'GetReport_RC_PO - '||SQLCODE||' - ERROR - '||SQLERRM);
  End  GetReport_RC_PO;

--
-- ------------------------------------------------------------------------------------------------
--         PROCEDURE GetMarciapiedi_RC(report per la Route Compatibility) Reg.777/2019/UE
-- Procedura modificata il 01/09/2021 per gestire i marciapiedi di fermate adiacenti:
--
-- 26/09/2016 inserita la condizione sul codice del marciapiede. Questo deve comprendere il codice della localit 
-- o quello delle localit  contenute nella localit  principale.
-- Questa condizione evita che nel caso di marciapiedi di fermate adiacenti queste abbiamo anche i marciapiedi della localit  adiacente

-- ------------------------------------------------------------------------------------------------
--  
 PROCEDURE GetMarciapiedi_RC (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
 --
 s_schema Varchar2(100);
 sqlstring Varchar2(32767);
 p_versione Number;
 s_filtro Varchar2(32767);

 BEGIN
  s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--
  If (p_area = 1 Or p_area = 3) Then
      p_versione := NULL;
  Else                                   --(p_area = 2 Or p_area = 4)
     If  p_i_versione Is Null Then
        p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
     Else
        p_versione := p_i_versione;
     End If;
  End If;
--
--   inserita una tabella "esterna" per poter fare l'ORDER dei marciapiedi nel ROUTING
--
sqlstring := 'Select ';
sqlstring:=sqlstring || 'SEDE_TECNICA, ';                                -- "Codifica Punto Operativo"
sqlstring:=sqlstring || 'DEFINIZIONE, ';                                 -- "Definizione"
sqlstring:=sqlstring || 'BINARIO, ';                                   -- "Codifica binario"
sqlstring:=sqlstring || 'PO_TRACK_1_2_1_0_0_2_D, ';                     -- "Definizione binario"
sqlstring:=sqlstring || 'PO_TR_PLATFORM_1_2_1_0_6_1, ';                    -- codice GI
sqlstring:=sqlstring || 'PO_TR_PLATFORM_1_2_1_0_6_2, ';                   -- identificazione del marciapiede
sqlstring:=sqlstring || 'PO_TR_PLATFORM_1_2_1_0_6_2_D, ';                -- descrizione del marciapiede 
sqlstring:=sqlstring || 'PO_TR_PLATFORM_1_2_1_0_6_4, ';                 -- "Lunghezza utile del marciapiede [m]"
sqlstring:=sqlstring || 'PO_TR_PLATFORM_1_2_1_0_6_5, ';                 -- "Altezza del marciapiede [m]"
sqlstring:=sqlstring || 'CODICE "Codice_Linea_Commerciale", ';      --"Codice Linea Commerciale"

sqlstring:=sqlstring || 'CODICE_DTP, ';                              -- "Codice DTP"
sqlstring:=sqlstring || 'CODICE_UT, ';                                  --  "Codice UT"
sqlstring:=sqlstring || 'CODICE_LINEA_TECNICA ';                       -- "Codice Linea Tecnica"

sqlstring:=sqlstring || ' From ( ';
--
sqlstring:=sqlstring ||' Select Distinct ';
sqlstring:=sqlstring ||' Po.SEDE_TECNICA, ';
sqlstring:=sqlstring ||' Po.DEFINIZIONE, ';
sqlstring:=sqlstring ||' PO_TR_PLATFORM_1_2_1_0_6_1, ';                    -- codice GI
sqlstring:=sqlstring ||' PO_TR_PLATFORM_1_2_1_0_6_2, ';                   -- identificazione del marciapiede
--
sqlstring := sqlstring || 'v.CODICE,  ';
sqlstring:=sqlstring ||' CODICE_DTP, ';
sqlstring:=sqlstring ||' CODICE_UT, ';
sqlstring:=sqlstring ||' BINARIO_1 BINARIO, ';
sqlstring:=sqlstring ||' bin_po.PO_TRACK_1_2_1_0_0_2_D, ';
--sqlstring:=sqlstring ||'          NVL (PO_TR_PLATFORM_1_2_1_0_6_1, ''0083'') PO_TR_PLATFORM_1_2_1_0_6_1, ';
--sqlstring:=sqlstring ||'          b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
sqlstring:=sqlstring ||' b.PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_4_B1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.4.B1'',PO_TR_PLATFORM_1_2_1_0_6_4_B1)) PO_TR_PLATFORM_1_2_1_0_6_4, ';
sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_5_B1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.5.B1'',PO_TR_PLATFORM_1_2_1_0_6_5_B1)) PO_TR_PLATFORM_1_2_1_0_6_5, ';
sqlstring:=sqlstring ||' CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring ||' From '|| s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
sqlstring:=sqlstring || s_schema||'.BINARI_CORSA_PO bin_po, ';
sqlstring:=sqlstring || s_schema||'.REL_PO_BINARI_CORSA Rel, ';
sqlstring:=sqlstring || s_schema||'.PUNTI_OPERATIVI Po, ';
--
  sqlstring := sqlstring|| '(Select SEDE_TECNICA, Listagg (CODICE, ''-'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO  ';
  sqlstring := sqlstring|| ' where  CODICE_CONTESTO = 5 ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring || ' Group By SEDE_TECNICA) v ';   
--
  sqlstring := sqlstring || ' Where Rel.SEDE_TECNICA = Po.SEDE_TECNICA ';
  sqlstring := sqlstring || ' And v.SEDE_TECNICA(+) = Po.SEDE_TECNICA ';
  sqlstring := sqlstring || ' And BINARIO_1 = Rel.PO_TRACK_1_2_1_0_0_2 ';
  sqlstring := sqlstring || ' And BINARIO_1 = bin_po.PO_TRACK_1_2_1_0_0_2 ';
--
-- 26/09/2016 inserita la condizione sul codice del marciapiede. Questo deve comprendere il codice della localit 
-- o quello delle localit  contenute nella localit  principale.
-- Questa condizione evita che nel caso di marciapiedi di fermate adiacenti queste abbiamo anche i marciapiedi della localit  adiacente
--->
--  sqlstring:=sqlstring ||'And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) = PO.SEDE_TECNICA ';
--->
   sqlstring := sqlstring || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) in (Select Po.SEDE_TECNICA From Dual ';
   sqlstring := sqlstring || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = Po.SEDE_TECNICA ' ;
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring ||') ';
--
--
If p_versione Is Not Null Then
   sqlstring := sqlstring || ' And b.CODICE_VERSIONE  = ' ||p_versione;
   sqlstring := sqlstring || ' And B.CODICE_VERSIONE = bin_po.CODICE_VERSIONE ';
   sqlstring := sqlstring || ' And B.CODICE_VERSIONE = Rel.CODICE_VERSIONE ';
   sqlstring := sqlstring || ' And Rel.CODICE_VERSIONE = Po.CODICE_VERSIONE ';
End If;
-- 
--filtro richiamato dalla funzione ROUTING DA INSERIRE 4 VOLTE, UNA PER OGNI MARCIAPIEDE; qui   per MARC 1
If p_filtro is Not Null Then
   s_filtro := Upper(PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'Po.SEDE_TECNICA'));
   sqlstring := sqlstring ||Substr(s_filtro, 1, Instr(s_filtro, 'ORDER') -1);      --siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
End If;
--
sqlstring:=sqlstring ||' Union ';
--
sqlstring:=sqlstring ||' Select Distinct ';
sqlstring:=sqlstring ||' Po.SEDE_TECNICA, ';
sqlstring:=sqlstring ||' Po.DEFINIZIONE, ';
sqlstring:=sqlstring ||' PO_TR_PLATFORM_1_2_1_0_6_1, ';                    -- codice GI
sqlstring:=sqlstring ||' PO_TR_PLATFORM_1_2_1_0_6_2, ';                   -- identificazione del marciapiede
--
sqlstring := sqlstring || 'v.CODICE,  ';
sqlstring:=sqlstring ||' CODICE_DTP, ';
sqlstring:=sqlstring ||' CODICE_UT, ';
sqlstring:=sqlstring ||' BINARIO_2 BINARIO, ';
sqlstring:=sqlstring ||' bin_po.PO_TRACK_1_2_1_0_0_2_D, ';
sqlstring:=sqlstring ||' b.PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_4_B2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.4.B2'',PO_TR_PLATFORM_1_2_1_0_6_4_B2)) PO_TR_PLATFORM_1_2_1_0_6_4, ';
sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_5_B2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.5.B2'',PO_TR_PLATFORM_1_2_1_0_6_5_B2)) PO_TR_PLATFORM_1_2_1_0_6_5, ';
sqlstring:=sqlstring ||' CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring ||' From '|| s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
sqlstring:=sqlstring || s_schema||'.BINARI_CORSA_PO bin_po, ';
sqlstring:=sqlstring || s_schema||'.REL_PO_BINARI_CORSA Rel, ';
sqlstring:=sqlstring || s_schema||'.PUNTI_OPERATIVI Po, ';
--
  sqlstring := sqlstring|| '(Select SEDE_TECNICA, Listagg (CODICE, ''-'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO  ';
  sqlstring := sqlstring|| ' where  CODICE_CONTESTO = 5 ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring || ' Group By SEDE_TECNICA) v ';   
--
  sqlstring := sqlstring || ' Where Rel.SEDE_TECNICA = Po.SEDE_TECNICA ';
  sqlstring := sqlstring || ' And v.SEDE_TECNICA(+) = Po.SEDE_TECNICA ';
  sqlstring := sqlstring || ' And BINARIO_2 = Rel.PO_TRACK_1_2_1_0_0_2 ';
  sqlstring := sqlstring || ' And BINARIO_2 = bin_po.PO_TRACK_1_2_1_0_0_2 ';
--
-- 26/09/2016 inserita la condizione sul codice del marciapiede. Questo deve comprendere il codice della localit 
-- o quello delle localit  contenute nella localit  principale.
-- Questa condizione evita che nel caso di marciapiedi di fermate adiacenti queste abbiamo anche i marciapiedi della localit  adiacente
--->
--   sqlstring:=sqlstring ||'And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) = PO.SEDE_TECNICA ';
--->
   sqlstring := sqlstring || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) in (Select Po.SEDE_TECNICA From Dual ';
   sqlstring := sqlstring || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = Po.SEDE_TECNICA ' ;
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring ||') ';
 --
--
If p_versione Is Not Null Then
   sqlstring:=sqlstring ||' And b.CODICE_VERSIONE  = ' ||p_versione;
   sqlstring:=sqlstring ||' And B.CODICE_VERSIONE = bin_po.CODICE_VERSIONE ';
   sqlstring:=sqlstring ||' And B.CODICE_VERSIONE = Rel.CODICE_VERSIONE ';
   sqlstring:=sqlstring ||' And Rel.CODICE_VERSIONE = Po.CODICE_VERSIONE ';
End If;

--filtro richiamato dalla funzione ROUTING DA INSERIRE 4 VOLTE, UNA PER OGNI MARCIAPIEDE; qui   per MARC 2
If p_filtro is Not Null Then
   s_filtro := Upper(PKG_RINF_REPORT.GetWhereCondition(p_filtro,'Po.SEDE_TECNICA'));
   sqlstring := sqlstring ||Substr(s_filtro, 1, Instr(s_filtro, 'ORDER') -1);      --siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
End If;
--
sqlstring:=sqlstring ||' Union ';
--
sqlstring:=sqlstring ||' Select Distinct ';
sqlstring:=sqlstring ||' Po.SEDE_TECNICA, ';
sqlstring:=sqlstring ||' Po.DEFINIZIONE, ';
sqlstring:=sqlstring ||' PO_TR_PLATFORM_1_2_1_0_6_1, ';                    -- codice GI
sqlstring:=sqlstring ||' PO_TR_PLATFORM_1_2_1_0_6_2, ';                   -- identificazione del marciapiede
--
sqlstring := sqlstring || 'v.CODICE,  ';
sqlstring:=sqlstring ||' CODICE_DTP, ';
sqlstring:=sqlstring ||' CODICE_UT, ';
sqlstring:=sqlstring ||' BINARIO_3 BINARIO, ';
sqlstring:=sqlstring ||' bin_po.PO_TRACK_1_2_1_0_0_2_D, ';
sqlstring:=sqlstring ||' b.PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_4_B3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.4.B3'',PO_TR_PLATFORM_1_2_1_0_6_4_B3)) PO_TR_PLATFORM_1_2_1_0_6_4, ';
sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_5_B3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.5.B3'',PO_TR_PLATFORM_1_2_1_0_6_5_B3)) PO_TR_PLATFORM_1_2_1_0_6_5, ';
sqlstring:=sqlstring ||' CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring ||' From '|| s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
sqlstring:=sqlstring || s_schema||'.BINARI_CORSA_PO bin_po, ';
sqlstring:=sqlstring || s_schema||'.REL_PO_BINARI_CORSA Rel, ';
sqlstring:=sqlstring || s_schema||'.PUNTI_OPERATIVI Po, ';
--
  sqlstring := sqlstring|| '(Select SEDE_TECNICA, Listagg (CODICE, ''-'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO  ';
  sqlstring := sqlstring|| ' where  CODICE_CONTESTO = 5 ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring || ' Group By SEDE_TECNICA) v ';   
--
  sqlstring := sqlstring || ' Where Rel.SEDE_TECNICA = Po.SEDE_TECNICA ';
  sqlstring := sqlstring || ' And v.SEDE_TECNICA(+) = Po.SEDE_TECNICA ';
  sqlstring := sqlstring || ' And BINARIO_3 = Rel.PO_TRACK_1_2_1_0_0_2 ';
  sqlstring := sqlstring || ' And BINARIO_3 = bin_po.PO_TRACK_1_2_1_0_0_2 ';

--
-- 26/09/2016 inserita la condizione sul codice del marciapiede. Questo deve comprendere il codice della localit 
-- o quello delle localit  contenute nella localit  principale.
-- Questa condizione evita che nel caso di marciapiedi di fermate adiacenti queste abbiamo anche i marciapiedi della localit  adiacente
--->
--  sqlstring:=sqlstring ||'And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) = PO.SEDE_TECNICA ';
--->
   sqlstring := sqlstring || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) in (Select Po.SEDE_TECNICA From Dual ';
   sqlstring := sqlstring || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = Po.SEDE_TECNICA ' ;
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring ||') ';
--
--
If p_versione Is Not Null Then
   sqlstring:=sqlstring ||' And b.CODICE_VERSIONE  = ' ||p_versione;
   sqlstring:=sqlstring ||' And b.CODICE_VERSIONE = bin_po.CODICE_VERSIONE ';
   sqlstring:=sqlstring ||' And b.CODICE_VERSIONE = Rel.CODICE_VERSIONE ';
   sqlstring:=sqlstring ||' And Rel.CODICE_VERSIONE = Po.CODICE_VERSIONE ';
End If;
--
--filtro richiamato dalla funzione ROUTING DA INSERIRE 4 VOLTE, UNA PER OGNI MARCIAPIEDE; qui   per MARC 2
If p_filtro is Not Null Then
   s_filtro := Upper(PKG_RINF_REPORT.GetWhereCondition(p_filtro,'Po.SEDE_TECNICA'));
   sqlstring := sqlstring ||Substr(s_filtro, 1, Instr(s_filtro, 'ORDER') -1);      --siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
End If;
--
sqlstring:=sqlstring ||' Union ';
--
sqlstring:=sqlstring ||' Select Distinct ';
sqlstring:=sqlstring ||' Po.SEDE_TECNICA, ';
sqlstring:=sqlstring ||' Po.DEFINIZIONE, ';
sqlstring:=sqlstring ||' PO_TR_PLATFORM_1_2_1_0_6_1, ';                    -- codice GI
sqlstring:=sqlstring ||' PO_TR_PLATFORM_1_2_1_0_6_2, ';                   -- identificazione del marciapiede
--
sqlstring := sqlstring || 'v.CODICE,  ';
sqlstring:=sqlstring ||' CODICE_DTP, ';
sqlstring:=sqlstring ||' CODICE_UT, ';
sqlstring:=sqlstring ||' BINARIO_4 BINARIO, ';
sqlstring:=sqlstring ||' bin_po.PO_TRACK_1_2_1_0_0_2_D, ';
sqlstring:=sqlstring ||' b.PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_4_B4_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.4.B4'',PO_TR_PLATFORM_1_2_1_0_6_4_B4)) PO_TR_PLATFORM_1_2_1_0_6_4, ';
sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_5_B4_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.5.B4'',PO_TR_PLATFORM_1_2_1_0_6_5_B4)) PO_TR_PLATFORM_1_2_1_0_6_5, ';
sqlstring:=sqlstring ||' CODICE_LINEA_TECNICA ';
sqlstring:=sqlstring ||' From '|| s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
sqlstring:=sqlstring || s_schema||'.BINARI_CORSA_PO bin_po, ';
sqlstring:=sqlstring || s_schema||'.REL_PO_BINARI_CORSA Rel, ';
sqlstring:=sqlstring || s_schema||'.PUNTI_OPERATIVI Po, ';
--
  sqlstring := sqlstring|| '(Select SEDE_TECNICA, Listagg (CODICE, ''-'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO  ';
  sqlstring := sqlstring|| ' where  CODICE_CONTESTO = 5 ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring || ' Group By SEDE_TECNICA) v ';   
--
  sqlstring := sqlstring || ' Where Rel.SEDE_TECNICA = Po.SEDE_TECNICA ';
  sqlstring := sqlstring || ' And v.SEDE_TECNICA(+) = Po.SEDE_TECNICA ';
  sqlstring := sqlstring || ' And BINARIO_4 = Rel.PO_TRACK_1_2_1_0_0_2 ';
  sqlstring := sqlstring || ' And BINARIO_4 = bin_po.PO_TRACK_1_2_1_0_0_2 ';
--
-- 26/09/2016 inserita la condizione sul codice del marciapiede. Questo deve comprendere il codice della localit 
-- o quello delle localit  contenute nella localit  principale.
-- Questa condizione evita che nel caso di marciapiedi di fermate adiacenti queste abbiamo anche i marciapiedi della localit  adiacente
--->
--  sqlstring:=sqlstring ||'And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) = PO.SEDE_TECNICA ';
--->
   sqlstring := sqlstring || ' And Substr(b.PO_TR_PLATFORM_1_2_1_0_6_2, 1, 6) in (Select Po.SEDE_TECNICA From Dual ';
   sqlstring := sqlstring || ' UNION Select SEDE_TECNICA From '||s_schema||'.PUNTI_OPERATIVI Where LOCALITA_CONTENITORE = Po.SEDE_TECNICA ' ;
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring ||') ';
--
--
If p_versione Is Not Null Then
   sqlstring:=sqlstring ||' And b.CODICE_VERSIONE  = ' ||p_versione;
   sqlstring:=sqlstring ||' And B.CODICE_VERSIONE = bin_po.CODICE_VERSIONE ';
   sqlstring:=sqlstring ||' And B.CODICE_VERSIONE = Rel.CODICE_VERSIONE ';
   sqlstring:=sqlstring ||' And Rel.CODICE_VERSIONE = Po.CODICE_VERSIONE ';
End If;
--
--filtro richiamato dalla funzione ROUTING DA INSERIRE 4 VOLTE, UNA PER OGNI MARCIAPIEDE; qui   per MARC 2
If p_filtro is Not Null Then
   s_filtro := Upper(PKG_RINF_REPORT.GetWhereCondition(p_filtro,'Po.SEDE_TECNICA'));
   sqlstring := sqlstring ||Substr(s_filtro, 1, Instr(s_filtro, 'ORDER') -1);      --siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
End If;
sqlstring:=sqlstring ||') tab_esterna ';

--filtro richiamato dalla funzione ROUTING inserito alla fine della tabella "esterna" perch  internamente ho 4 UNION e non avrei potuto fare l'ORDER
--filtro richiamato dalla funzione ROUTING inserito alla fine della tabella "esterna" perch  internamente ho 4 UNION e non avrei potuto fare l'ORDER
If p_filtro is Not Null Then
   s_filtro := Upper(PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'tab_esterna.SEDE_TECNICA'));
   sqlstring:=sqlstring ||Substr(s_filtro, Instr(s_filtro, 'ORDER'));
Else 
   sqlstring := sqlstring ||' Order By CODICE_DTP, CODICE_UT, SEDE_TECNICA, PO_TR_PLATFORM_1_2_1_0_6_2_D ';
End If;
--

 /***********************************
--REPORT 3.6.18
  s_schema Varchar2(100);
  sqlstring Varchar2(32767);
  p_versione Number;
  s_filtro Varchar2(32767);
 BEGIN
   s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--
   If (p_area = 1 Or p_area = 3) Then
       p_versione := NULL;
   Else                                   --(p_area = 2 Or p_area = 4)
      If  p_i_versione Is Null Then
         p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
      Else
         p_versione := p_i_versione;
      End If;
   End If;
--
--   inserita una tabella "esterna" per poter fare l'ORDER dei marciapiedi nel ROUTING
--
   sqlstring := 'Select ';
   sqlstring:=sqlstring || 'SEDE_TECNICA, ';                                -- "Codifica Punto Operativo"
   sqlstring:=sqlstring || 'DEFINIZIONE, ';                                 -- "Definizione"
   sqlstring:=sqlstring || 'BINARIO , ';                                   -- "Codifica binario"
   sqlstring:=sqlstring || 'PO_TRACK_1_2_1_0_0_2_D, ';                     -- "Definizione binario"
   sqlstring:=sqlstring || 'PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
   sqlstring:=sqlstring || 'PO_TR_PLATFORM_1_2_1_0_6_4, ';                 -- "Lunghezza utile del marciapiede [m]"
   sqlstring:=sqlstring || 'PO_TR_PLATFORM_1_2_1_0_6_5, ';                 -- "Altezza del marciapiede [m]"
   sqlstring:=sqlstring || 'CODICE_LINEA_TECNICA, ';                       -- "Codice Linea Tecnica"
   sqlstring := sqlstring || 'CODICE "Codice_Linea_Commerciale", ';      --"Codice Linea Commerciale"
   sqlstring:=sqlstring || 'CODICE_DTP, ';                              -- "Codice DTP"
   sqlstring:=sqlstring || 'CODICE_UT';                                  --  "Codice UT"
   sqlstring:=sqlstring || ' From ( ';
--
   sqlstring:=sqlstring ||' Select Distinct ';
   sqlstring:=sqlstring ||' Po.SEDE_TECNICA, ';
   sqlstring:=sqlstring ||' Po.DEFINIZIONE, ';
   sqlstring := sqlstring || 'v.CODICE,  ';
   sqlstring:=sqlstring ||' CODICE_DTP, ';
   sqlstring:=sqlstring ||' CODICE_UT, ';
   sqlstring:=sqlstring ||' BINARIO_1 BINARIO, ';
   sqlstring:=sqlstring ||' bin_po.PO_TRACK_1_2_1_0_0_2_D, ';
--sqlstring:=sqlstring ||'          NVL (PO_TR_PLATFORM_1_2_1_0_6_1, ''0083'') PO_TR_PLATFORM_1_2_1_0_6_1, ';
--sqlstring:=sqlstring ||'          b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
   sqlstring:=sqlstring ||' b.PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
   sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_4_B1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.4.B1'',PO_TR_PLATFORM_1_2_1_0_6_4_B1)) PO_TR_PLATFORM_1_2_1_0_6_4, ';
   sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_5_B1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.5.B1'',PO_TR_PLATFORM_1_2_1_0_6_5_B1)) PO_TR_PLATFORM_1_2_1_0_6_5, ';
   sqlstring:=sqlstring ||' CODICE_LINEA_TECNICA ';
   sqlstring:=sqlstring ||' From '|| s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
   sqlstring:=sqlstring || s_schema||'.BINARI_CORSA_PO bin_po, ';
   sqlstring:=sqlstring || s_schema||'.REL_PO_BINARI_CORSA Rel, ';
   sqlstring:=sqlstring || s_schema||'.PUNTI_OPERATIVI Po, ';
--
   sqlstring := sqlstring|| '(Select SEDE_TECNICA, Listagg (CODICE, '';'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO  ';
   sqlstring := sqlstring|| ' where  CODICE_CONTESTO = 5 ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring || ' Group By SEDE_TECNICA) v ';   
--
   sqlstring := sqlstring || ' Where Rel.SEDE_TECNICA = Po.SEDE_TECNICA ';
   sqlstring := sqlstring || ' And v.SEDE_TECNICA(+) = Po.SEDE_TECNICA ';
   sqlstring := sqlstring || ' And BINARIO_1 = Rel.PO_TRACK_1_2_1_0_0_2 ';
   sqlstring := sqlstring || ' And BINARIO_1 = bin_po.PO_TRACK_1_2_1_0_0_2 ';
--
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And b.CODICE_VERSIONE  = ' ||p_versione;
      sqlstring := sqlstring || ' And B.CODICE_VERSIONE = bin_po.CODICE_VERSIONE ';
      sqlstring := sqlstring || ' And B.CODICE_VERSIONE = Rel.CODICE_VERSIONE ';
      sqlstring := sqlstring || ' And Rel.CODICE_VERSIONE = Po.CODICE_VERSIONE ';
   End If;
-- 
--filtro richiamato dalla funzione ROUTING DA INSERIRE 4 VOLTE, UNA PER OGNI MARCIAPIEDE; qui   per MARC 1
   If p_filtro is Not Null Then
      s_filtro := Upper(PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'Po.SEDE_TECNICA'));
      sqlstring := sqlstring ||Substr(s_filtro, 1, Instr(s_filtro, 'ORDER') -1);      --siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
   End If;
--
   sqlstring:=sqlstring ||' Union ';
--
   sqlstring:=sqlstring ||' Select Distinct ';
   sqlstring:=sqlstring ||' Po.SEDE_TECNICA, ';
   sqlstring:=sqlstring ||' Po.DEFINIZIONE, ';
   sqlstring := sqlstring || 'v.CODICE,  ';
   sqlstring:=sqlstring ||' CODICE_DTP, ';
   sqlstring:=sqlstring ||' CODICE_UT, ';
   sqlstring:=sqlstring ||' BINARIO_2 BINARIO, ';
   sqlstring:=sqlstring ||' bin_po.PO_TRACK_1_2_1_0_0_2_D, ';
   sqlstring:=sqlstring ||' b.PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
   sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_4_B2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.4.B2'',PO_TR_PLATFORM_1_2_1_0_6_4_B2)) PO_TR_PLATFORM_1_2_1_0_6_4, ';
   sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_5_B2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.5.B2'',PO_TR_PLATFORM_1_2_1_0_6_5_B2)) PO_TR_PLATFORM_1_2_1_0_6_5, ';
   sqlstring:=sqlstring ||' CODICE_LINEA_TECNICA ';
   sqlstring:=sqlstring ||' From '|| s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
   sqlstring:=sqlstring || s_schema||'.BINARI_CORSA_PO bin_po, ';
   sqlstring:=sqlstring || s_schema||'.REL_PO_BINARI_CORSA Rel, ';
   sqlstring:=sqlstring || s_schema||'.PUNTI_OPERATIVI Po, ';
--
   sqlstring := sqlstring|| '(Select SEDE_TECNICA, Listagg (CODICE, '';'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO  ';
   sqlstring := sqlstring|| ' where  CODICE_CONTESTO = 5 ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring || ' Group By SEDE_TECNICA) v ';   
--
   sqlstring := sqlstring || ' Where Rel.SEDE_TECNICA = Po.SEDE_TECNICA ';
   sqlstring := sqlstring || ' And v.SEDE_TECNICA(+) = Po.SEDE_TECNICA ';
   sqlstring := sqlstring || ' And BINARIO_2 = Rel.PO_TRACK_1_2_1_0_0_2 ';
   sqlstring := sqlstring || ' And BINARIO_2 = bin_po.PO_TRACK_1_2_1_0_0_2 ';
--
   If p_versione Is Not Null Then
      sqlstring:=sqlstring ||' And b.CODICE_VERSIONE  = ' ||p_versione;
      sqlstring:=sqlstring ||' And B.CODICE_VERSIONE = bin_po.CODICE_VERSIONE ';
      sqlstring:=sqlstring ||' And B.CODICE_VERSIONE = Rel.CODICE_VERSIONE ';
      sqlstring:=sqlstring ||' And Rel.CODICE_VERSIONE = Po.CODICE_VERSIONE ';
   End If;

-- filtro richiamato dalla funzione ROUTING DA INSERIRE 4 VOLTE, UNA PER OGNI MARCIAPIEDE; qui   per MARC 2
   If p_filtro is Not Null Then
      s_filtro := Upper(PKG_RINF_REPORT.GetWhereCondition(p_filtro,'Po.SEDE_TECNICA'));
      sqlstring := sqlstring ||Substr(s_filtro, 1, Instr(s_filtro, 'ORDER') -1);      --siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
   End If;
--
   sqlstring:=sqlstring ||' Union ';
--
   sqlstring:=sqlstring ||' Select Distinct ';
   sqlstring:=sqlstring ||' Po.SEDE_TECNICA, ';
   sqlstring:=sqlstring ||' Po.DEFINIZIONE, ';
   sqlstring := sqlstring || 'v.CODICE,  ';
   sqlstring:=sqlstring ||' CODICE_DTP, ';
   sqlstring:=sqlstring ||' CODICE_UT, ';
   sqlstring:=sqlstring ||' BINARIO_3 BINARIO, ';
   sqlstring:=sqlstring ||' bin_po.PO_TRACK_1_2_1_0_0_2_D, ';
   sqlstring:=sqlstring ||' b.PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
   sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_4_B3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.4.B3'',PO_TR_PLATFORM_1_2_1_0_6_4_B3)) PO_TR_PLATFORM_1_2_1_0_6_4, ';
   sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_5_B3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.5.B3'',PO_TR_PLATFORM_1_2_1_0_6_5_B3)) PO_TR_PLATFORM_1_2_1_0_6_5, ';
   sqlstring:=sqlstring ||' CODICE_LINEA_TECNICA ';
   sqlstring:=sqlstring ||' From '|| s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
   sqlstring:=sqlstring || s_schema||'.BINARI_CORSA_PO bin_po, ';
   sqlstring:=sqlstring || s_schema||'.REL_PO_BINARI_CORSA Rel, ';
   sqlstring:=sqlstring || s_schema||'.PUNTI_OPERATIVI Po, ';
--
   sqlstring := sqlstring|| '(Select SEDE_TECNICA, Listagg (CODICE, '';'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO  ';
   sqlstring := sqlstring|| ' where  CODICE_CONTESTO = 5 ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring || ' Group By SEDE_TECNICA) v ';   
--
  sqlstring := sqlstring || ' Where Rel.SEDE_TECNICA = Po.SEDE_TECNICA ';
  sqlstring := sqlstring || ' And v.SEDE_TECNICA(+) = Po.SEDE_TECNICA ';
  sqlstring := sqlstring || ' And BINARIO_3 = Rel.PO_TRACK_1_2_1_0_0_2 ';
  sqlstring := sqlstring || ' And BINARIO_3 = bin_po.PO_TRACK_1_2_1_0_0_2 ';
--
If p_versione Is Not Null Then
   sqlstring:=sqlstring ||' And b.CODICE_VERSIONE  = ' ||p_versione;
   sqlstring:=sqlstring ||' And b.CODICE_VERSIONE = bin_po.CODICE_VERSIONE ';
   sqlstring:=sqlstring ||' And b.CODICE_VERSIONE = Rel.CODICE_VERSIONE ';
   sqlstring:=sqlstring ||' And Rel.CODICE_VERSIONE = Po.CODICE_VERSIONE ';
End If;
--
--filtro richiamato dalla funzione ROUTING DA INSERIRE 4 VOLTE, UNA PER OGNI MARCIAPIEDE; qui   per MARC 2
If p_filtro is Not Null Then
   s_filtro := Upper(PKG_RINF_REPORT.GetWhereCondition(p_filtro,'Po.SEDE_TECNICA'));
   sqlstring := sqlstring ||Substr(s_filtro, 1, Instr(s_filtro, 'ORDER') -1);      --siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
End If;
--
   sqlstring:=sqlstring ||' Union ';
--
   sqlstring:=sqlstring ||' Select Distinct ';
   sqlstring:=sqlstring ||' Po.SEDE_TECNICA, ';
   sqlstring:=sqlstring ||' Po.DEFINIZIONE, ';
   sqlstring := sqlstring || 'v.CODICE,  ';
   sqlstring:=sqlstring ||' CODICE_DTP, ';
   sqlstring:=sqlstring ||' CODICE_UT, ';
   sqlstring:=sqlstring ||' BINARIO_4 BINARIO, ';
   sqlstring:=sqlstring ||' bin_po.PO_TRACK_1_2_1_0_0_2_D, ';
   sqlstring:=sqlstring ||' b.PO_TR_PLATFORM_1_2_1_0_6_2_D, ';
   sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_4_B4_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.4.B4'',PO_TR_PLATFORM_1_2_1_0_6_4_B4)) PO_TR_PLATFORM_1_2_1_0_6_4, ';
   sqlstring:=sqlstring ||' DECODE(PO_TR_PLAT_1_2_1_0_6_5_B4_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.2.1.0.6.5.B4'',PO_TR_PLATFORM_1_2_1_0_6_5_B4)) PO_TR_PLATFORM_1_2_1_0_6_5, ';
   sqlstring:=sqlstring ||' CODICE_LINEA_TECNICA ';
   sqlstring:=sqlstring ||' From '|| s_schema||'.MARCIAPIEDI_BINARI_PO b, ';
   sqlstring:=sqlstring || s_schema||'.BINARI_CORSA_PO bin_po, ';
   sqlstring:=sqlstring || s_schema||'.REL_PO_BINARI_CORSA Rel, ';
   sqlstring:=sqlstring || s_schema||'.PUNTI_OPERATIVI Po, ';
--
   sqlstring := sqlstring|| '(Select SEDE_TECNICA, Listagg (CODICE, '';'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO  ';
   sqlstring := sqlstring|| ' where  CODICE_CONTESTO = 5 ';
   If p_versione Is Not Null Then
      sqlstring := sqlstring || ' And CODICE_VERSIONE = '||p_versione;
   End If;
   sqlstring := sqlstring || ' Group By SEDE_TECNICA) v ';   
--
  sqlstring := sqlstring || ' Where Rel.SEDE_TECNICA = Po.SEDE_TECNICA ';
  sqlstring := sqlstring || ' And v.SEDE_TECNICA(+) = Po.SEDE_TECNICA ';
  sqlstring := sqlstring || ' And BINARIO_4 = Rel.PO_TRACK_1_2_1_0_0_2 ';
  sqlstring := sqlstring || ' And BINARIO_4 = bin_po.PO_TRACK_1_2_1_0_0_2 ';
--
If p_versione Is Not Null Then
   sqlstring:=sqlstring ||' And b.CODICE_VERSIONE  = ' ||p_versione;
   sqlstring:=sqlstring ||' And B.CODICE_VERSIONE = bin_po.CODICE_VERSIONE ';
   sqlstring:=sqlstring ||' And B.CODICE_VERSIONE = Rel.CODICE_VERSIONE ';
   sqlstring:=sqlstring ||' And Rel.CODICE_VERSIONE = Po.CODICE_VERSIONE ';
End If;
--
--filtro richiamato dalla funzione ROUTING DA INSERIRE 4 VOLTE, UNA PER OGNI MARCIAPIEDE; qui   per MARC 2
If p_filtro is Not Null Then
   s_filtro := Upper(PKG_RINF_REPORT.GetWhereCondition(p_filtro,'Po.SEDE_TECNICA'));
   sqlstring := sqlstring ||Substr(s_filtro, 1, Instr(s_filtro, 'ORDER') -1);      --siccome questa where   in una union, devo tagliare la parte di stringa con ORDER
End If;
sqlstring:=sqlstring ||') tab_esterna ';

--filtro richiamato dalla funzione ROUTING inserito alla fine della tabella "esterna" perch  internamente ho 4 UNION e non avrei potuto fare l'ORDER
--filtro richiamato dalla funzione ROUTING inserito alla fine della tabella "esterna" perch  internamente ho 4 UNION e non avrei potuto fare l'ORDER
If p_filtro is Not Null Then
   s_filtro := Upper(PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'tab_esterna.SEDE_TECNICA'));
   sqlstring:=sqlstring ||Substr(s_filtro, Instr(s_filtro, 'ORDER'));
Else 
   sqlstring := sqlstring ||' Order By CODICE_DTP, CODICE_UT, SEDE_TECNICA, PO_TR_PLATFORM_1_2_1_0_6_2_D ';
End If;
--

-- DBMS_OUTPUT.PUT_LINE(sqlstring);

*******/
  OPEN p_cursor FOR sqlstring;
--
 Exception
   When NO_DATA_FOUND Then
     Null;
   When Others Then
      raise_application_error(-20001,'GetMarciapiedi_RC - '||SQLCODE||' - ERROR - '||SQLERRM);
--
END GetMarciapiedi_RC;
--
-- ------------------------------------------------------------------------------------------------
--         PROCEDURE GetGallerie_RC (report per la Route Compatibility) Reg.777/2019/UE
-- ------------------------------------------------------------------------------------------------
--  
 PROCEDURE GetGallerie_RC  (p_area Number, p_i_versione Number, p_filtro Clob, p_cursor Out Empcur) Is
-- REPORT 3.6.19

 s_schema Varchar2(100);
 sqlstring Varchar2(32767);
 p_versione Number;
 s_filtro Varchar2(32767);

 BEGIN
  s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--
  If (p_area = 1 Or p_area = 3) Then
      p_versione := NULL;
  Else                                   --(p_area = 2 Or p_area = 4)
     If  p_i_versione Is Null Then
        p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
     Else
        p_versione := p_i_versione;
     End If;
  End If;
/***
  sqlstring := 'Select SEDE_TECNICA "Codifica", DEFINIZIONE "Definizione", BINARIO "Codifica binario", DESCRIZIONE "Definizione binario" , ';
  sqlstring := sqlstring || ' CODICEGI "Codice del GI", GALLERIA "Codifica Galleria",  DESCR_GALLERIA "Definizione galleria", ';
  sqlstring := sqlstring || ' PO_SD_TUNNEL_1_2_2_0_5_7 as ITU_FireCatReq, ';               -- "Categoria di sicurezza antincendio richiesta per il materiale rotabile", 
  sqlstring := sqlstring || ' PO_SD_TUNNEL_1_2_2_0_5_8 as ITU_NatFireCatReq, ';            -- "Categoria di sicurezza antincendio nazionale richiesta per il materiale rotabile", 
  sqlstring := sqlstring || ' CODICE_LINEA_TECNICA "Codice Linea Tecnica", ';
  sqlstring := sqlstring || ' CODICE "Codice Linea Commerciale", ';
  sqlstring := sqlstring || ' CODICE_DTP "Codice DTP", ';
  sqlstring := sqlstring || ' CODICE_UT "Codice UT" ';
***/
--
  sqlstring := 'Select SEDE_TECNICA, DEFINIZIONE, BINARIO, DEFINIZIONE_BINARIO, ';
  sqlstring := sqlstring || ' CODICEGI CODICE_GI, GALLERIA,  DESCR_GALLERIA, ';
  sqlstring := sqlstring || ' PO_SD_TUNNEL_1_2_2_0_5_7 as "ITU_FireCatReq", ';               -- "Categoria di sicurezza antincendio richiesta per il materiale rotabile", 
  sqlstring := sqlstring || ' PO_SD_TUNNEL_1_2_2_0_5_8 as "ITU_NatFireCatReq", ';            -- "Categoria di sicurezza antincendio nazionale richiesta per il materiale rotabile", 
  sqlstring := sqlstring || ' CODICE "Codice_Linea_Commerciale", ';
  sqlstring := sqlstring || ' CODICE_DTP, ';
  sqlstring := sqlstring || ' CODICE_UT, ';
  sqlstring := sqlstring || ' CODICE_LINEA_TECNICA ';
-- 
  sqlstring := sqlstring || ' From ( ';
--  
-- gallerie binari raccordo PO
  sqlstring := sqlstring || ' Select  po.SEDE_TECNICA, po.DEFINIZIONE, po.CODICE_DTP, CODICE_UT, rel.PO_SD_1_2_2_0_0_2 binario, binari.PO_SD_1_2_2_0_0_2_D DEFINIZIONE_BINARIO, PO_SD_TUNNEL_1_2_2_0_5_1 codiceGI, ';
  sqlstring := sqlstring || ' gal.PO_SD_TUNNEL_1_2_2_0_5_2 galleria, PO_SD_TUNNEL_1_2_2_0_5_2_D descr_galleria, ';
  sqlstring := sqlstring|| ' Decode(PO_SD_TUNNEL_1_2_2_0_5_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.5.7'', PO_SD_TUNNEL_1_2_2_0_5_7)) PO_SD_TUNNEL_1_2_2_0_5_7,';
  sqlstring := sqlstring|| ' Decode(PO_SD_TUNNEL_1_2_2_0_5_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.5.8'', PO_SD_TUNNEL_1_2_2_0_5_8)) PO_SD_TUNNEL_1_2_2_0_5_8,';
  sqlstring := sqlstring|| ' CODICE_LINEA_TECNICA, v.codice ';
  sqlstring := sqlstring|| ' From '||s_schema||'.GALLERIE_RACCORDO_PO gal,';
  sqlstring := sqlstring||  s_schema||'.PUNTI_OPERATIVI po, ';
  sqlstring := sqlstring||  s_schema||'.REL_GALLERIE_RACCORDO_PO rel, ';
  sqlstring := sqlstring||  s_schema||'.BINARI_RACCORDO_PO binari, ';
  sqlstring := sqlstring|| '(Select SEDE_TECNICA, Listagg (CODICE, '';'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO  ';
  sqlstring := sqlstring|| ' where  CODICE_CONTESTO = 5 ';
  If p_versione Is Not Null Then
      sqlstring := sqlstring||' And CODICE_VERSIONE = '||p_versione;
  End If;
  sqlstring := sqlstring|| ' Group By SEDE_TECNICA) v ';   
 --
  sqlstring := sqlstring|| ' Where rel.PO_SD_TUNNEL_1_2_2_0_5_2 = gal.PO_SD_TUNNEL_1_2_2_0_5_2 ';
  sqlstring := sqlstring|| ' And rel.PO_SD_1_2_2_0_0_2 = binari.PO_SD_1_2_2_0_0_2';
  sqlstring := sqlstring|| ' And binari.SEDE_TECNICA = po.SEDE_TECNICA ';
  sqlstring := sqlstring|| ' And v.SEDE_TECNICA = po.SEDE_TECNICA ';
--
If p_versione Is Not Null Then
   sqlstring := sqlstring|| ' And po.codice_versione = Rel.CODICE_VERSIONE ';
   sqlstring := sqlstring|| ' And Rel.CODICE_VERSIONE = binari.CODICE_VERSIONE ';
   sqlstring := sqlstring|| ' And binari.CODICE_VERSIONE = gal.CODICE_VERSIONE ';
   sqlstring := sqlstring|| ' And gal.CODICE_VERSIONE ='||p_versione;
End If;
--filtro richiamato dalla funzione ROUTING
-- If p_filtro Is Not Null Then
   -- sqlstring := sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'PO.SEDE_TECNICA');
-- End If;
--
--
  sqlstring := sqlstring|| ' Union ';
-- gallerie binari corsa PO
  sqlstring := sqlstring|| ' Select  PO.SEDE_TECNICA, PO.DEFINIZIONE, PO.CODICE_DTP, CODICE_UT, rel.PO_TRACK_1_2_1_0_0_2 , binari.PO_TRACK_1_2_1_0_0_2_D , PO_TR_TUNNEL_1_2_1_0_5_1, ';
  sqlstring := sqlstring|| ' gal.PO_TR_TUNNEL_1_2_1_0_5_2,  PO_TR_TUNNEL_1_2_1_0_5_2_D, ';
  sqlstring := sqlstring|| ' DECODE(PO_TR_TUNNEL_1_2_1_0_5_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'',  PKG_RINF_REPORT.GetDescription(''1.2.1.0.5.7'', PO_TR_TUNNEL_1_2_1_0_5_7)) PO_TR_TUNNEL_1_2_1_0_5_7,';
  sqlstring := sqlstring|| ' DECODE(PO_TR_TUNNEL_1_2_1_0_5_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'',  PKG_RINF_REPORT.GetDescription(''1.2.1.0.5.8'', PO_TR_TUNNEL_1_2_1_0_5_8)) PO_TR_TUNNEL_1_2_1_0_5_8,';
  sqlstring := sqlstring|| ' CODICE_LINEA_TECNICA, v.CODICE  ';
  sqlstring := sqlstring|| ' From '||s_schema||'.GALLERIE_BINARI_PO gal, ';
  sqlstring := sqlstring||  s_schema||'.PUNTI_OPERATIVI po, ';
  sqlstring := sqlstring||  s_schema||'.REL_GALLERIE_BINARI_PO rel, ';
  sqlstring := sqlstring||  s_schema||'.BINARI_CORSA_PO binari, ';
  sqlstring := sqlstring||  s_schema||'.REL_PO_BINARI_CORSA rel_binari_po, ';
  sqlstring := sqlstring|| '(Select SEDE_TECNICA, Listagg (CODICE, '';'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO  ';
  sqlstring := sqlstring|| ' Where  CODICE_CONTESTO = 5 ';
  If p_versione Is Not Null Then
      sqlstring := sqlstring||' And CODICE_VERSIONE = '||p_versione;
  End If;
  sqlstring := sqlstring|| ' Group By SEDE_TECNICA) v ';   
  sqlstring := sqlstring|| ' Where rel.PO_TR_TUNNEL_1_2_1_0_5_2 = gal.PO_TR_TUNNEL_1_2_1_0_5_2 ';
  sqlstring := sqlstring|| ' And rel.PO_TRACK_1_2_1_0_0_2 = Binari.PO_TRACK_1_2_1_0_0_2 ';
  sqlstring := sqlstring|| ' And Binari.PO_TRACK_1_2_1_0_0_2 = Rel_Binari_Po.PO_TRACK_1_2_1_0_0_2  ';
  sqlstring := sqlstring|| ' And Rel_Binari_Po.SEDE_TECNICA = Po.SEDE_TECNICA ';
  sqlstring := sqlstring|| ' And v.SEDE_TECNICA = po.SEDE_TECNICA ';
--
If p_versione Is Not Null Then
   sqlstring:=sqlstring|| ' And po.CODICE_VERSIONE = rel.CODICE_VERSIONE  ';
   sqlstring:=sqlstring|| ' And rel.CODICE_VERSIONE = Binari.CODICE_VERSIONE ';
   sqlstring:=sqlstring|| ' And Binari.CODICE_VERSIONE = gal.CODICE_VERSIONE  ';
   sqlstring:=sqlstring|| ' And Binari.CODICE_VERSIONE = Rel_Binari_po.CODICE_VERSIONE ';
   sqlstring:=sqlstring|| ' And gal.CODICE_VERSIONE = '||p_versione;
End If;
--filtro richiamato dalla funzione ROUTING
-- If p_filtro is Not Null Then
--    sqlstring:=sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'PO.SEDE_TECNICA');
-- End If;
--
  sqlstring := sqlstring|| ' Union ';
--
-- gallerie binari corsa sol
  sqlstring := sqlstring|| 'Select  sez.SEDE_TECNICA, sez.DEFINIZIONE, sez.CODICE_DTP, CODICE_UT, rel.SOL_TRACK_1_1_1_0_0_1, binari.SOL_TRACK_1_1_1_0_0_1_D, SOL_TUNNEL_1_1_1_1_8_1, ';
  sqlstring := sqlstring|| ' gal.SOL_TUNNEL_1_1_1_1_8_2,  SOL_TUNNEL_1_1_1_1_8_2_D, ';
  sqlstring := sqlstring|| ' Decode(SOL_TUNNEL_1_1_1_1_8_10_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.8.10'', SOL_TUNNEL_1_1_1_1_8_10) ) SOL_TUNNEL_1_1_1_1_8_10, ';
  sqlstring := sqlstring|| ' Decode(SOL_TUNNEL_1_1_1_1_8_11_AP,''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.8.11'', SOL_TUNNEL_1_1_1_1_8_11) ) SOL_TUNNEL_1_1_1_1_8_11, ';
  sqlstring := sqlstring|| ' CODICE_LINEA_TECNICA, v.CODICE ';
  sqlstring := sqlstring|| ' From '||s_schema||'.GALLERIE_BINARI_SOL gal,';
  sqlstring := sqlstring||  s_schema||'.SEZIONI_LINEA sez,';
  sqlstring := sqlstring||  s_schema||'.REL_GALLERIE_BINARI_SOL rel, ';
  sqlstring := sqlstring||  s_schema||'.BINARI_CORSA_SOL binari, ';
  sqlstring := sqlstring|| '(Select SEDE_TECNICA, Listagg (CODICE, '';'') Within Group (Order By CODICE) as CODICE  from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO ';
  sqlstring := sqlstring|| ' Where  CODICE_CONTESTO = 5 ';
  If p_versione Is Not Null Then
      sqlstring := sqlstring||' And CODICE_VERSIONE = '||p_versione;
  End If;
  sqlstring := sqlstring|| ' Group By SEDE_TECNICA) v ';   
--
  sqlstring := sqlstring|| ' Where rel.SOL_TUNNEL_1_1_1_1_8_2 = gal.SOL_TUNNEL_1_1_1_1_8_2 ';
  sqlstring := sqlstring|| ' And rel.SOL_TRACK_1_1_1_0_0_1 = binari.SOL_TRACK_1_1_1_0_0_1 ';
  sqlstring := sqlstring|| ' And binari.SEDE_TECNICA = SEZ.SEDE_TECNICA  ';
  sqlstring := sqlstring|| ' And v.SEDE_TECNICA = sez.SEDE_TECNICA ';
--
If p_versione Is Not Null Then
   sqlstring := sqlstring||  'And sez.CODICE_VERSIONE = rel.CODICE_VERSIONE  ';
   sqlstring := sqlstring|| ' And Rel.CODICE_VERSIONE = binari.CODICE_VERSIONE ';
   sqlstring := sqlstring|| ' And binari.CODICE_VERSIONE = gal.CODICE_VERSIONE ';
   sqlstring := sqlstring|| ' And gal.CODICE_VERSIONE = '||p_versione;
End If;
--filtro richiamato dalla funzione ROUTING
 If  p_filtro Is Not Null Then
    sqlstring := sqlstring || ')'|| replace (PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'SEDE_TECNICA'), 'and', 'Where');
 Else 
    sqlstring := sqlstring|| ' ) order by CODICE_DTP, CODICE_UT, BINARIO, GALLERIA ';
 End if;
-- Dbms_Output.Put_Line(sqlstring);
   OPEN p_cursor FOR sqlstring;
--
 Exception
   When NO_DATA_FOUND Then
     Null;
   When Others Then raise_application_error(-20001, 'GetGallerie_RC - '||SQLCODE||' - ERROR - '||SQLERRM);
--
END GetGallerie_RC ;

/************** NON Utilizzate pi  perch  accorpate in un unico report delle Gallerie (GetGallerie_RC)
--
-- ------------------------------------------------------------------------------------------------
--         PROCEDURE GetGalleriePOBinCorsa_RC (report per la Route Compatibility) Reg.777/2019/UE
-- ------------------------------------------------------------------------------------------------
PROCEDURE GetGalleriePOBinCorsa_RC  (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
-- REPORT 3.6.19
   s_schema Varchar2(100);
   sqlstring Varchar2(32767);
   p_versione Number;
   s_filtro Varchar2(32767);
 BEGIN
  s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--
  If (p_area = 1 Or p_area = 3) Then
      p_versione := NULL;
  Else                                   --(p_area = 2 Or p_area = 4)
     If  p_i_versione Is Null Then
        p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
     Else
        p_versione := p_i_versione;
     End If;
  End If;
--
sqlstring:='Select ';
sqlstring:=sqlstring|| ' PO.SEDE_TECNICA, ';
sqlstring:=sqlstring|| ' PO.DEFINIZIONE, ';
sqlstring:=sqlstring|| ' rel.PO_TRACK_1_2_1_0_0_2 , ';
sqlstring:=sqlstring|| ' binari.PO_TRACK_1_2_1_0_0_2_D , ';
sqlstring:=sqlstring|| ' PO_TR_TUNNEL_1_2_1_0_5_1, ';
sqlstring:=sqlstring|| ' gal.PO_TR_TUNNEL_1_2_1_0_5_2, ';
sqlstring:=sqlstring|| ' PO_TR_TUNNEL_1_2_1_0_5_2_D, ';
sqlstring:=sqlstring|| ' DECODE(PO_TR_TUNNEL_1_2_1_0_5_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'',  PKG_RINF_REPORT.GetDescription(''1.2.1.0.5.7'', PO_TR_TUNNEL_1_2_1_0_5_7)) PO_TR_TUNNEL_1_2_1_0_5_7,';
sqlstring:=sqlstring|| ' DECODE(PO_TR_TUNNEL_1_2_1_0_5_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'',  PKG_RINF_REPORT.GetDescription(''1.2.1.0.5.8'', PO_TR_TUNNEL_1_2_1_0_5_8)) PO_TR_TUNNEL_1_2_1_0_5_8,';
sqlstring:=sqlstring|| ' CODICE_LINEA_TECNICA, ';
sqlstring:=sqlstring|| ' PO.CODICE_DTP ,';
sqlstring:=sqlstring|| ' CODICE_UT ';
sqlstring:=sqlstring|| ' From '||s_schema||'.GALLERIE_BINARI_PO gal, ';
sqlstring:=sqlstring||  s_schema||'.PUNTI_OPERATIVI po, ';
sqlstring:=sqlstring||  s_schema||'.REL_GALLERIE_BINARI_PO rel, ';
sqlstring:=sqlstring||  s_schema||'.BINARI_CORSA_PO binari, ';
sqlstring:=sqlstring||  s_schema||'.REL_PO_BINARI_CORSA rel_binari_po ';
sqlstring:=sqlstring|| ' Where rel.PO_TR_TUNNEL_1_2_1_0_5_2 = gal.PO_TR_TUNNEL_1_2_1_0_5_2 ';
sqlstring:=sqlstring|| ' And rel.PO_TRACK_1_2_1_0_0_2 = Binari.PO_TRACK_1_2_1_0_0_2 ';
sqlstring:=sqlstring|| ' And Binari.PO_TRACK_1_2_1_0_0_2 = Rel_Binari_Po.PO_TRACK_1_2_1_0_0_2  ';
sqlstring:=sqlstring|| ' And Rel_Binari_Po.SEDE_TECNICA = Po.SEDE_TECNICA ';
--
If p_versione Is Not Null Then
   sqlstring:=sqlstring|| ' And po.CODICE_VERSIONE = rel.CODICE_VERSIONE  ';
   sqlstring:=sqlstring|| ' And rel.CODICE_VERSIONE = Binari.CODICE_VERSIONE ';
   sqlstring:=sqlstring|| ' And Binari.CODICE_VERSIONE = gal.CODICE_VERSIONE  ';
   sqlstring:=sqlstring|| ' And Binari.CODICE_VERSIONE = Rel_Binari_po.CODICE_VERSIONE ';
   sqlstring:=sqlstring|| ' And gal.CODICE_VERSIONE = '||p_versione;
End If;

--filtro richiamato dalla funzione ROUTING
If p_filtro is Not Null Then
   sqlstring:=sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'PO.SEDE_TECNICA');
Else 
   sqlstring:=sqlstring|| ' Order By po.CODICE_DTP, gal.PO_TR_TUNNEL_1_2_1_0_5_2, rel.PO_TRACK_1_2_1_0_0_2';
End If;

-- DBMS_OUTPUT.PUT_LINE(sqlstring);
OPEN p_cursor FOR sqlstring;
--
END GetGalleriePOBinCorsa_RC ;
--
-- --------------------------------------------------------------------------------------
--                PROCEDURE GetGalleriePOBinRacc_RC             
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetGalleriePOBinRacc_RC  (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.20
--
    s_schema Varchar2(100);
    sqlstring Varchar2(32767);
    p_versione Number;
    s_filtro Varchar2(32767);
 BEGIN
  s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--
  If (p_area = 1 Or p_area = 3) Then
      p_versione := NULL;
  Else                                   --(p_area = 2 Or p_area = 4)
     If  p_i_versione Is Null Then
        p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
     Else
        p_versione := p_i_versione;
     End If;
  End If;
  --
sqlstring := 'Select ';
sqlstring := sqlstring|| ' po.SEDE_TECNICA, ';
sqlstring := sqlstring|| ' po.DEFINIZIONE, ';
sqlstring := sqlstring|| ' rel.PO_SD_1_2_2_0_0_2, ';
sqlstring := sqlstring|| ' binari.PO_SD_1_2_2_0_0_2_D ,';
sqlstring := sqlstring|| ' PO_SD_TUNNEL_1_2_2_0_5_1, ';
sqlstring := sqlstring|| ' gal.PO_SD_TUNNEL_1_2_2_0_5_2, ';
sqlstring := sqlstring|| ' PO_SD_TUNNEL_1_2_2_0_5_2_D, ';
sqlstring := sqlstring|| ' Decode(PO_SD_TUNNEL_1_2_2_0_5_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.5.7'', PO_SD_TUNNEL_1_2_2_0_5_7)) PO_SD_TUNNEL_1_2_2_0_5_7,';
sqlstring := sqlstring|| ' Decode(PO_SD_TUNNEL_1_2_2_0_5_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.2.2.0.5.8'', PO_SD_TUNNEL_1_2_2_0_5_8)) PO_SD_TUNNEL_1_2_2_0_5_8,';
sqlstring := sqlstring|| ' CODICE_LINEA_TECNICA, ';
sqlstring := sqlstring|| ' po.CODICE_DTP, ';
sqlstring := sqlstring|| ' CODICE_UT ';
sqlstring := sqlstring|| ' From '||s_schema||'.GALLERIE_RACCORDO_PO gal,';
sqlstring := sqlstring||  s_schema||'.PUNTI_OPERATIVI po, ';
sqlstring := sqlstring||  s_schema||'.REL_GALLERIE_RACCORDO_PO rel, ';
sqlstring := sqlstring||  s_schema||'.BINARI_RACCORDO_PO binari ';
sqlstring := sqlstring|| ' Where rel.PO_SD_TUNNEL_1_2_2_0_5_2 = gal.PO_SD_TUNNEL_1_2_2_0_5_2 ';
sqlstring := sqlstring|| ' And rel.PO_SD_1_2_2_0_0_2 = binari.PO_SD_1_2_2_0_0_2';
sqlstring := sqlstring|| ' And binari.SEDE_TECNICA = po.SEDE_TECNICA ';
--
If p_versione Is Not Null Then
   sqlstring := sqlstring|| ' And po.CODICE_VERSIONE = Rel.CODICE_VERSIONE ';
   sqlstring := sqlstring|| ' And Rel.CODICE_VERSIONE = binari.CODICE_VERSIONE ';
   sqlstring := sqlstring|| ' And binari.CODICE_VERSIONE = gal.CODICE_VERSIONE ';
   sqlstring := sqlstring|| ' And gal.CODICE_VERSIONE ='||p_versione;
End If;

--filtro richiamato dalla funzione ROUTING
If p_filtro Is Not Null Then
   sqlstring := sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'PO.SEDE_TECNICA');
Else
   sqlstring := sqlstring|| ' Order By po.CODICE_DTP, gal.PO_SD_TUNNEL_1_2_2_0_5_2, rel.PO_SD_1_2_2_0_0_2 ';
End If;

-- DBMS_OUTPUT.PUT_LINE(sqlstring);
   OPEN p_cursor FOR sqlstring;
--
END GetGalleriePOBinRacc_RC ;
--
-- --------------------------------------------------------------------------------------
--                         PROCEDURE GetGallerieSOL_RC     
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetGallerieSOL_RC (p_area NUMBER,p_i_versione NUMBER  ,p_filtro CLOB, p_cursor OUT empcur) IS
-- REPORT 3.6.20
--
   s_schema VARCHAR2(100);
   sqlstring VARCHAR2(32767);
   p_versione NUMBER;
BEGIN
  s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--
  If (p_area = 1 Or p_area = 3) Then
      p_versione := NULL;
  Else                                   --(p_area = 2 Or p_area = 4)
     If  p_i_versione Is Null Then
        p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
     Else
        p_versione := p_i_versione;
     End If;
  End If;
--
sqlstring := 'Select ';
sqlstring := sqlstring|| ' sez.SEDE_TECNICA, ';
sqlstring := sqlstring|| ' sez.DEFINIZIONE, ';
sqlstring := sqlstring|| ' rel.SOL_TRACK_1_1_1_0_0_1, ';
sqlstring := sqlstring|| ' binari.SOL_TRACK_1_1_1_0_0_1_D, ';
sqlstring := sqlstring|| ' SOL_TUNNEL_1_1_1_1_8_1, ';
sqlstring := sqlstring|| ' gal.SOL_TUNNEL_1_1_1_1_8_2, ';
sqlstring := sqlstring|| ' SOL_TUNNEL_1_1_1_1_8_2_D, ';
sqlstring := sqlstring|| ' Decode(SOL_TUNNEL_1_1_1_1_8_10_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.8.10'', SOL_TUNNEL_1_1_1_1_8_10) ) SOL_TUNNEL_1_1_1_1_8_10, ';
sqlstring := sqlstring|| ' Decode(SOL_TUNNEL_1_1_1_1_8_11_AP,''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.8.11'', SOL_TUNNEL_1_1_1_1_8_11) ) SOL_TUNNEL_1_1_1_1_8_11, ';
sqlstring := sqlstring|| ' CODICE_LINEA_TECNICA, ';
sqlstring := sqlstring|| ' sez.CODICE_DTP, ';
sqlstring := sqlstring|| ' CODICE_UT ';
sqlstring := sqlstring|| ' From '||s_schema||'.GALLERIE_BINARI_SOL gal,';
sqlstring := sqlstring||  s_schema||'.SEZIONI_LINEA sez,';
sqlstring := sqlstring||  s_schema||'.REL_GALLERIE_BINARI_SOL rel, ';
sqlstring := sqlstring||  s_schema||'.BINARI_CORSA_SOL binari ';
sqlstring := sqlstring|| ' Where rel.SOL_TUNNEL_1_1_1_1_8_2 = gal.SOL_TUNNEL_1_1_1_1_8_2 ';
sqlstring := sqlstring|| ' And rel.SOL_TRACK_1_1_1_0_0_1 = binari.SOL_TRACK_1_1_1_0_0_1 ';
sqlstring := sqlstring|| ' And binari.SEDE_TECNICA=SEZ.SEDE_TECNICA  ';
--
If p_versione Is Not Null Then
   sqlstring := sqlstring|| ' And sez.CODICE_VERSIONE = rel.CODICE_VERSIONE  ';
   sqlstring := sqlstring|| ' And Rel.CODICE_VERSIONE = binari.CODICE_VERSIONE ';
   sqlstring := sqlstring|| ' And binari.CODICE_VERSIONE = gal.CODICE_VERSIONE ';
   sqlstring := sqlstring|| ' And gal.CODICE_VERSIONE = '||p_versione;
End If;

--filtro richiamato dalla funzione ROUTING
If p_filtro Is Not Null Then
   sqlstring := sqlstring || PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'sez.SEDE_TECNICA');
Else   
   sqlstring := sqlstring|| ' order by SEZ.CODICE_DTP, gal.SOL_TUNNEL_1_1_1_1_8_2, rel.SOL_TRACK_1_1_1_0_0_1 ';
End If;


--  DBMS_OUTPUT.PUT_LINE(sqlstring);
  OPEN p_cursor FOR sqlstring;
 END GetGallerieSOL_RC;
***********************************/
--


PROCEDURE GetSOLParametriCCS2_OFF (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.5

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) THEN
  p_versione:=NULL;
 ELSE  --(p_area=2 OR p_area=4)
     IF  p_i_versione IS NULL THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;

 sqlstring := 'Select sl.SEDE_TECNICA, ';
 sqlstring := sqlstring || ' sl.DEFINIZIONE, ';
 sqlstring := sqlstring || ' s.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' s.SOL_TRACK_1_1_1_0_0_1_D , ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_3_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.1'', SOL_TRACK_1_1_1_3_2_1)) SOL_TRACK_1_1_1_3_2_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.2'', SOL_TRACK_1_1_1_3_2_2)) SOL_TRACK_1_1_1_3_2_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.3'', SOL_TRACK_1_1_1_3_2_3)) SOL_TRACK_1_1_1_3_2_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.4'', SOL_TRACK_1_1_1_3_2_4)) SOL_TRACK_1_1_1_3_2_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.5'', SOL_TRACK_1_1_1_3_2_5)) SOL_TRACK_1_1_1_3_2_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.6'', SOL_TRACK_1_1_1_3_2_6)) SOL_TRACK_1_1_1_3_2_6, ';
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.7'', SOL_TRACK_1_1_1_3_2_7)) SOL_TRACK_1_1_1_3_2_7, '; --eliminato il 04-10-2021
--->
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.8'', SOL_TRACK_1_1_1_3_2_8)) SOL_TRACK_1_1_1_3_2_8, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_9_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.9'', SOL_TRACK_1_1_1_3_2_9)) SOL_TRACK_1_1_1_3_2_9, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_2_10_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.2.10'', SOL_TRACK_1_1_1_3_2_10)) SOL_TRACK_1_1_1_3_2_10, ';
--->
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.1'', SOL_TRACK_1_1_1_3_3_1)) SOL_TRACK_1_1_1_3_3_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.2'', SOL_TRACK_1_1_1_3_3_2)) SOL_TRACK_1_1_1_3_3_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.3'', gsm.SOL_TRACK_1_1_1_3_3_3)) SOL_TRACK_1_1_1_3_3_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_3_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.3.1'', SOL_TRACK_1_1_1_3_3_3_1)) SOL_TRACK_1_1_1_3_3_3_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_3_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.3.2'', SOL_TRACK_1_1_1_3_3_3_2)) SOL_TRACK_1_1_1_3_3_3_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_3_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.3.3'', SOL_TRACK_1_1_1_3_3_3_3)) SOL_TRACK_1_1_1_3_3_3_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.4'', SOL_TRACK_1_1_1_3_3_4)) SOL_TRACK_1_1_1_3_3_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.5'', SOL_TRACK_1_1_1_3_3_5)) SOL_TRACK_1_1_1_3_3_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.6'', SOL_TRACK_1_1_1_3_3_6)) SOL_TRACK_1_1_1_3_3_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.7'', SOL_TRACK_1_1_1_3_3_7)) SOL_TRACK_1_1_1_3_3_7, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.8'', SOL_TRACK_1_1_1_3_3_8)) SOL_TRACK_1_1_1_3_3_8, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_9_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.9'', SOL_TRACK_1_1_1_3_3_9)) SOL_TRACK_1_1_1_3_3_9, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_3_10_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.3.10'', SOL_TRACK_1_1_1_3_3_10)) SOL_TRACK_1_1_1_3_3_10, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_4_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.4.1'', SOL_TRACK_1_1_1_3_4_1)) SOL_TRACK_1_1_1_3_4_1, ';
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_5_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.5.1'', SOL_TRACK_1_1_1_3_5_1)) SOL_TRACK_1_1_1_3_5_1, '; -- eliminato 04-10-2021
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_5_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.5.2'', SOL_TRACK_1_1_1_3_5_2)) SOL_TRACK_1_1_1_3_5_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_5_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.5.3'', SOL_TRACK_1_1_1_3_5_3)) SOL_TRACK_1_1_1_3_5_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_6_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.6.1'', SOL_TRACK_1_1_1_3_6_1)) SOL_TRACK_1_1_1_3_6_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_1_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.1'', SOL_TRACK_1_1_1_3_7_1_1)) SOL_TRACK_1_1_1_3_7_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_1_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.2'', SOL_TRACK_1_1_1_3_7_1_2)) SOL_TRACK_1_1_1_3_7_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_1_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.3'', SOL_TRACK_1_1_1_3_7_1_3)) SOL_TRACK_1_1_1_3_7_1_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_1_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.1.4'',SOL_TRACK_1_1_1_3_7_1_4)) SOL_TRACK_1_1_1_3_7_1_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_2_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.2.1'', SOL_TRACK_1_1_1_3_7_2_1)) SOL_TRACK_1_1_1_3_7_2_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_2_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.2.2'', SOL_TRACK_1_1_1_3_7_2_2)) SOL_TRACK_1_1_1_3_7_2_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.3'', SOL_TRACK_1_1_1_3_7_3)) SOL_TRACK_1_1_1_3_7_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.4'', SOL_TRACK_1_1_1_3_7_4)) SOL_TRACK_1_1_1_3_7_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.5'', SOL_TRACK_1_1_1_3_7_5)) SOL_TRACK_1_1_1_3_7_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.6'', SOL_TRACK_1_1_1_3_7_6)) SOL_TRACK_1_1_1_3_7_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.7'', SOL_TRACK_1_1_1_3_7_7)) SOL_TRACK_1_1_1_3_7_7, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Trim (To_Char (Round (SOL_TRACK_1_1_1_3_7_8, 1), ''999990.9''))) SOL_TRACK_1_1_1_3_7_8, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_9_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', Trim (To_Char (Round (SOL_TRACK_1_1_1_3_7_9, 1), ''999990.9''))) SOL_TRACK_1_1_1_3_7_9, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_10_AP, ''NYA'' ,'' '', ''N'', ''Non applicabile'',Trim (To_Char (Round (SOL_TRACK_1_1_1_3_7_10, 1), ''999990.9'')) ) SOL_TRACK_1_1_1_3_7_10, ';
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_11_AP, ''NYA'' ,'' '', ''N'', ''Non applicabile'',Trim (To_Char (Round (SOL_TRACK_1_1_1_3_7_11, 1), ''999990.9'')))  SOL_TRACK_1_1_1_3_7_11, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_11_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.11.1'', SOL_TRACK_1_1_1_3_7_11_1)) SOL_TRACK_1_1_1_3_7_11_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_12_AP, ''NYA'' ,'' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.12'', SOL_TRACK_1_1_1_3_7_12)) SOL_TRACK_1_1_1_3_7_12, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_13_AP, ''NYA'' ,'' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.13'', SOL_TRACK_1_1_1_3_7_13)) SOL_TRACK_1_1_1_3_7_13, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_14_AP, ''NYA'' ,'' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.14'', SOL_TRACK_1_1_1_3_7_14)) SOL_TRACK_1_1_1_3_7_14, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_15_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.15.1'', SOL_TRACK_1_1_1_3_7_15_1)) SOL_TRACK_1_1_1_3_7_15_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_15_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', TRIM (TO_CHAR (ROUND (SOL_TRACK_1_1_1_3_7_15_2, 3), ''999990.999''))) SOL_TRACK_1_1_1_3_7_15_2, ';
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_16_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.16'', SOL_TRACK_1_1_1_3_7_16)) SOL_TRACK_1_1_1_3_7_16, ';
 sqlstring := sqlstring || ' Decode( SOL_TRACK_1_1_1_3_7_17_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.17'', SOL_TRACK_1_1_1_3_7_17) )SOL_TRACK_1_1_1_3_7_17, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_18_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.18'', SOL_TRACK_1_1_1_3_7_18)) SOL_TRACK_1_1_1_3_7_18, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_19_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.19'', SOL_TRACK_1_1_1_3_7_19)) SOL_TRACK_1_1_1_3_7_19, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_20_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.20'', SOL_TRACK_1_1_1_3_7_20)) SOL_TRACK_1_1_1_3_7_20, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_21_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.21'', SOL_TRACK_1_1_1_3_7_21)) SOL_TRACK_1_1_1_3_7_21, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_22_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.22'', SOL_TRACK_1_1_1_3_7_22)) SOL_TRACK_1_1_1_3_7_22, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_7_23_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.7.23'', SOL_TRACK_1_1_1_3_7_23)) SOL_TRACK_1_1_1_3_7_23, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_8_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.8.1'', SOL_TRACK_1_1_1_3_8_1)) SOL_TRACK_1_1_1_3_8_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_8_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.8.2'', SOL_TRACK_1_1_1_3_8_2)) SOL_TRACK_1_1_1_3_8_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_9_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.9.1'', SOL_TRACK_1_1_1_3_9_1)) SOL_TRACK_1_1_1_3_9_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_9_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.9.2'', SOL_TRACK_1_1_1_3_9_2)) SOL_TRACK_1_1_1_3_9_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_10_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.10.1'', SOL_TRACK_1_1_1_3_10_1)) SOL_TRACK_1_1_1_3_10_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_10_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.10.2'', SOL_TRACK_1_1_1_3_10_2)) SOL_TRACK_1_1_1_3_10_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_11_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.11.1'', SOL_TRACK_1_1_1_3_11_1)) SOL_TRACK_1_1_1_3_11_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_11_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.11.2'', SOL_TRACK_1_1_1_3_11_2)) SOL_TRACK_1_1_1_3_11_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_3_11_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.11.3'', SOL_TRACK_1_1_1_3_11_3)) SOL_TRACK_1_1_1_3_11_3, ';
 --sqlstring := sqlstring || ' Decode( SOL_TRACK_1_1_1_3_12_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.3.12.1'', SOL_TRACK_1_1_1_3_12_1)) SOL_TRACK_1_1_1_3_12_1, ';
 sqlstring := sqlstring || ' CODICE_DTP, ';
 sqlstring := sqlstring || ' CODICE_UT, ';
 sqlstring := sqlstring || ' CODICE_LINEA_TECNICA ';
 sqlstring := sqlstring || ' From '|| s_schema||'.BINARI_CORSA_SOL s, ';
 sqlstring := sqlstring ||   s_schema||'.SEZIONI_LINEA sl,';
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_3_3_3 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_3_3_GSM_R_FAC, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.3.3'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_3_3 = CODIFICA_VALORE ';
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring:=sqlstring || ' ) gsm, ';
--
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_3_2_9 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_2_9_COMP_ETCS, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.2.9'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_2_9 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ') comp_etcs, ';
--
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_3_3_5 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_3_5_RETI_GSM_R, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.3.5'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_3_5 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ') reti_gsm_r, ';
--
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_3_3_9 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_3_9_RADIO_VOCE, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.3.9'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_3_9 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) radio_voce, ';
--
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (Valore, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_3_3_10 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_3_10_RADIO_DATI, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.3.10'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_3_10 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) radio_dati, ';
 --
 sqlstring := sqlstring || '(Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (Valore, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_3_5_3 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_5_3_SIST_PRE_PROT, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.5.3'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_5_3 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) Sist_Pre_Prot, ';
 --
 sqlstring := sqlstring || '(Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (Valore, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_3_7_11_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_7_11_1_CARMIN_ASSE, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.7.11.1'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_7_11_1 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) Carmin_Asse, ';
 --
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_3_7_1_3 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_3_7_1_3_SISTRILTRAIN, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.3.7.1.3'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_3_7_1_3 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ', CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) sistriltrain, ';
 --
 sqlstring := sqlstring || ' ( Select bcs.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_3_1_1_AP SOL_TRACK_1_1_1_3_1_1_AP, ';
 sqlstring := sqlstring || ' Decode (SOL_TRACK_1_1_1_3_1_1_AP, ';
 sqlstring := sqlstring || ' ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_3_1_1) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_3_1_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS dic, ';
 sqlstring := sqlstring ||  s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring ||  s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where  dic.TIPO_DICHIARAZIONE = ''EC'' ';
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = sl.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' And bcs.SOL_TRACK_1_1_1_0_0_1 = DIC.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || ' Union ';
 sqlstring := sqlstring || ' Select DIC.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' ''NYA'' SOL_TRACK_1_1_1_3_1_1_AP, ';
 sqlstring := sqlstring || ' '' '' SOL_TRACK_1_1_1_3_1_1 ';
 sqlstring := sqlstring || ' From (Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.BINARI_CORSA_SOL bcs ';
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Minus ';
 sqlstring := sqlstring || ' Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS ';
 sqlstring := sqlstring || ' Where TIPO_DICHIARAZIONE = ''EC''  ';
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ')  dic, ';
 sqlstring := sqlstring ||   s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring ||   s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = Sl.SEDE_TECNICA ';
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ') dich_ec_ccs ';
 sqlstring := sqlstring || ' Where  s.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = gsm.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = comp_etcs.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = reti_gsm_r.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = radio_voce.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = radio_dati.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = Sist_Pre_Prot.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = sistriltrain.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = Carmin_Asse.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = dich_ec_ccs.SOL_TRACK_1_1_1_0_0_1(+) ';
-- 
 IF p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And s.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = s.CODICE_VERSIONE ';
 End If;

 --filtro richiamato dalla funzione ROUTING
 If p_filtro Is Not Null 
 Then
    sqlstring := sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro, 'SL.SEDE_TECNICA');
 End If;
 --sqlstring:=sqlstring || '          ORDER BY 1 ';
 --
 DBMS_OUTPUT.PUT_LINE(sqlstring);
 OPEN p_cursor FOR sqlstring;
END GetSOLParametriCCS2_OFF;

PROCEDURE GetSOLParametriINF2_OFF (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.3
--p_filtro VARCHAR2(32767);
s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) 
 THEN
    p_versione:=NULL;
 ELSE 
    IF p_i_versione IS NULL 
    THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
    ELSE
       p_versione:=p_i_versione;
    END IF;
 END IF;

 sqlstring := 'Select SL.SEDE_TECNICA, ';
 sqlstring := sqlstring || ' SL.DEFINIZIONE, ';
 sqlstring := sqlstring || ' s.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' s.SOL_TRACK_1_1_1_0_0_1_D , ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_1, ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.1'', cat_ten.SOL_TRACK_1_1_1_1_2_1)) SOL_TRACK_1_1_1_1_2_1, ';
 ---> mofica Reg.777/2019/UE 06/04/2021
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_1_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.1.2'', SOL_TRACK_1_1_1_1_2_1_2)) SOL_TRACK_1_1_1_1_2_1_2, ';
 ---> fine modifica
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.2'', cat_linea.SOL_TRACK_1_1_1_1_2_2)) SOL_TRACK_1_1_1_1_2_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.3'', corridoio.SOL_TRACK_1_1_1_1_2_3)) SOL_TRACK_1_1_1_1_2_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4'', cap_carico.SOL_TRACK_1_1_1_1_2_4)) SOL_TRACK_1_1_1_1_2_4, ';
 ---> mofica Reg.777/2019/UE 06/04/2021
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4.1'', SOL_TRACK_1_1_1_1_2_4_1)) SOL_TRACK_1_1_1_1_2_4_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4.2'', SOL_TRACK_1_1_1_1_2_4_2)) SOL_TRACK_1_1_1_1_2_4_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4.3'', SOL_TRACK_1_1_1_1_2_4_3)) SOL_TRACK_1_1_1_1_2_4_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_4_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.4.4'', SOL_TRACK_1_1_1_1_2_4_4)) SOL_TRACK_1_1_1_1_2_4_4, ';
 ---> fine modifica  
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.5'', SOL_TRACK_1_1_1_1_2_5)) SOL_TRACK_1_1_1_1_2_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.6'', SOL_TRACK_1_1_1_1_2_6)) SOL_TRACK_1_1_1_1_2_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.7'', SOL_TRACK_1_1_1_1_2_7)) SOL_TRACK_1_1_1_1_2_7, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_2_8_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.2.8'', SOL_TRACK_1_1_1_1_2_8)) SOL_TRACK_1_1_1_1_2_8, ';
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1'', SOL_TRACK_1_1_1_1_3_1)) SOL_TRACK_1_1_1_1_3_1, ';
 ---> mofica Reg.777/2019/UE 06/04/2021
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_1_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1.1.SUP'', SOL_TRACK_1_1_1_1_3_1_1_SUP)||'' + ''||PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1.1.INF'', SOL_TRACK_1_1_1_1_3_1_1_INF)) SOL_TRACK_1_1_1_1_3_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_1_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1.2'', SOL_TRACK_1_1_1_1_3_1_2)) SOL_TRACK_1_1_1_1_3_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_1_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.1.3'', SOL_TRACK_1_1_1_1_3_1_3)) SOL_TRACK_1_1_1_1_3_1_3, ';
 ---> fine modifica 
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.2'', SOL_TRACK_1_1_1_1_3_2)) SOL_TRACK_1_1_1_1_3_2, ';
 --sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.3'', SOL_TRACK_1_1_1_1_3_3)) SOL_TRACK_1_1_1_1_3_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.4'', prof_casse.SOL_TRACK_1_1_1_1_3_4)) SOL_TRACK_1_1_1_1_3_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_5_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.5'', prof_semir.SOL_TRACK_1_1_1_1_3_5)) SOL_TRACK_1_1_1_1_3_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_5_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.5.1'', SOL_TRACK_1_1_1_1_3_5_1)) SOL_TRACK_1_1_1_1_3_5_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_6_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.6'', p.gradiente)) SOL_TRACK_1_1_1_1_3_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_3_7_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.3.7'', SOL_TRACK_1_1_1_1_3_7)) SOL_TRACK_1_1_1_1_3_7, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_4_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.4.1'',SOL_TRACK_1_1_1_1_4_1))SOL_TRACK_1_1_1_1_4_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_4_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.4.2'',SOL_TRACK_1_1_1_1_4_2))SOL_TRACK_1_1_1_1_4_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_4_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.4.3'',SOL_TRACK_1_1_1_1_4_3))SOL_TRACK_1_1_1_1_4_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_4_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.4.4'',SOL_TRACK_1_1_1_1_4_4))SOL_TRACK_1_1_1_1_4_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_5_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.5.1'',SOL_TRACK_1_1_1_1_5_1))SOL_TRACK_1_1_1_1_5_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_5_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.5.2'',SOL_TRACK_1_1_1_1_5_2))SOL_TRACK_1_1_1_1_5_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',TRIM(PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.1'',TRIM (SOL_TRACK_1_1_1_1_6_1))))SOL_TRACK_1_1_1_1_6_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.2'',SOL_TRACK_1_1_1_1_6_2))SOL_TRACK_1_1_1_1_6_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.3'',SOL_TRACK_1_1_1_1_6_3))SOL_TRACK_1_1_1_1_6_3, ';
 ---> mofica Reg.777/2019/UE 06/04/2021   
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.4'', SOL_TRACK_1_1_1_1_6_4)) SOL_TRACK_1_1_1_1_6_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_6_5_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.6.5'', SOL_TRACK_1_1_1_1_6_5)) SOL_TRACK_1_1_1_1_6_5, ';
 ---> fine modifica 
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.1'',SOL_TRACK_1_1_1_1_7_1))SOL_TRACK_1_1_1_1_7_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.2'',SOL_TRACK_1_1_1_1_7_2))SOL_TRACK_1_1_1_1_7_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'',PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.3'',SOL_TRACK_1_1_1_1_7_3))SOL_TRACK_1_1_1_1_7_3, ';
 ---> mofica Reg.777/2019/UE 06/04/2021    
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.4'', SOL_TRACK_1_1_1_1_7_4)) SOL_TRACK_1_1_1_1_7_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_5_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.5'', SOL_TRACK_1_1_1_1_7_5)) SOL_TRACK_1_1_1_1_7_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_6_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.6'', SOL_TRACK_1_1_1_1_7_6)) SOL_TRACK_1_1_1_1_7_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_7_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.7'', SOL_TRACK_1_1_1_1_7_7)) SOL_TRACK_1_1_1_1_7_7, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_8_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.8'', SOL_TRACK_1_1_1_1_7_8)) SOL_TRACK_1_1_1_1_7_8, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_9_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.9'', SOL_TRACK_1_1_1_1_7_9)) SOL_TRACK_1_1_1_1_7_9, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_10_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.10'', SOL_TRACK_1_1_1_1_7_10)) SOL_TRACK_1_1_1_1_7_10, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_1_7_11_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.1.7.11'', SOL_TRACK_1_1_1_1_7_11)) SOL_TRACK_1_1_1_1_7_11, ';
 ---> fine modifica 
 sqlstring := sqlstring || ' CODICE_DTP, ';
 sqlstring := sqlstring || ' CODICE_UT, ';
 sqlstring := sqlstring || ' CODICE_LINEA_TECNICA ';
 sqlstring := sqlstring || ' From '|| s_schema||'.BINARI_CORSA_SOL s, ';
 sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA sl, '; 
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' CODICE_VERSIONE, ';
 End If;
 sqlstring := sqlstring || ' Listagg ( ';
 sqlstring := sqlstring || ' Decode ( ';
 sqlstring := sqlstring || ' Sign (PENDENZA), ';
 sqlstring := sqlstring || ' -1, Trim (To_Char (PENDENZA, ''9999999999999990.9'')), ';
 sqlstring := sqlstring || ' ''+'' || Trim (To_Char (PENDENZA, ''9999999999999990.9''))) ';
 sqlstring := sqlstring || ' || ''('' ';
 sqlstring := sqlstring || ' || Trim ( ';
 sqlstring := sqlstring || ' To_Char (Least (KM_INIZIO, KM_FINE), ';
 sqlstring := sqlstring || ' ''9999999999999990.999'')) ';
 sqlstring := sqlstring || ' || '')'', ';
 sqlstring := sqlstring || ' '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By Least (KM_INIZIO, KM_FINE)) ';
 sqlstring := sqlstring || ' As gradiente ';
 sqlstring := sqlstring || ' From '|| s_schema||'.PAR_1_1_1_1_3_6_GRADIENTE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || '  , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '  ) p, ';
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_1_2_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_1_2_1_CAT_TEN_SOL, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.codice_parametro = d.codice_parametro ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.1.2.1'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_2_1 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
   sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '   ) cat_ten, ';
 sqlstring := sqlstring || '( Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_1_2_2 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.PAR_1_1_1_1_2_2_CAT_LINEA, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.1.2.2'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_2_2 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '  ) cat_linea, ';
 sqlstring := sqlstring || ' (Select SEDE_TECNICA, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_1_2_3 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  CODICE_CONTESTO = 3 ';
 sqlstring := sqlstring || ' And c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And CODICE || ''0'' = CODIFICA_VALORE ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.1.2.3'' ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SEDE_TECNICA ';
 If p_versione Is Not Null 
 Then
   sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) corridoio, ';
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_1_2_4 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.PAR_1_1_1_1_2_4_CAP_CARICO, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And numero_parametro = ''1.1.1.1.2.4'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_2_4 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) cap_carico, ';
 sqlstring := sqlstring || '           ';
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_1_3_4 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_1_3_4_PROF_CAS_M, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And numero_parametro = ''1.1.1.1.3.4'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_3_4 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '  ) prof_casse, ';
 sqlstring := sqlstring || '           ';
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' Listagg (VALORE, '';'') ';
 sqlstring := sqlstring || ' Within Group (Order By VALORE) ';
 sqlstring := sqlstring || ' As SOL_TRACK_1_1_1_1_3_5 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_1_3_5_PROF_SEMI_R, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And numero_parametro = ''1.1.1.1.3.5'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_3_5 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
   sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '  ) prof_semir, ';
 sqlstring := sqlstring || '       ';
 sqlstring := sqlstring || ' ( Select bcs.SOL_TRACK_1_1_1_0_0_1 , ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_1O2_AP SOL_TRACK_1_1_1_1_1_1_AP, ';
 sqlstring := sqlstring || ' Decode (SOL_TRACK_1_1_1_1_1_1O2_AP, ';
 sqlstring := sqlstring || ' ''NYA'','' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_1O2) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF DIC, ';
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where  DIC.TIPO_DICHIARAZIONE = ''EC'' ';
 If p_versione Is Not Null 
 Then
   sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = ' ||p_versione;
   sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
   sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = sl.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' And bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || 'Union ';
 sqlstring := sqlstring || 'Select DIC.SOL_TRACK_1_1_1_0_0_1 , ';
 sqlstring := sqlstring || '  ''NYA'' SOL_TRACK_1_1_1_1_1_1_AP, ';
 sqlstring := sqlstring || ' '' '' SOL_TRACK_1_1_1_1_1_1 ';
 sqlstring := sqlstring || ' From (Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.BINARI_CORSA_SOL bcs ';
 If p_versione Is Not Null 
 Then
   sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Minus ';
 sqlstring := sqlstring || ' Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
 sqlstring := sqlstring || ' Where TIPO_DICHIARAZIONE= ''EC''  ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' )  dic, ';
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where  bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' and BCS.SEDE_TECNICA = sl.SEDE_TECNICA ';
 If p_versione Is Not Null Then
   sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = ' ||p_versione;
   sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '  ) dich_ec_inf, ';
 ---> inizio modifica reg 777/2019 del 06/04/2021
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_1_2_4_3 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_1_2_4_3_LOCAVERSPEC, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.1.2.4.3'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_2_4_3 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
   sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null
 Then
    sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '   ) locaverspec, ';
 ---> fine modifica 
 sqlstring := sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring := sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring := sqlstring || '  As SOL_TRACK_1_1_1_1_7_8 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_1_7_8_LOCA_SIST_RTB, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring := sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring := sqlstring || ' Where  c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring := sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.1.7.8'' ';
 sqlstring := sqlstring || ' And SOL_TRACK_1_1_1_1_7_8 = CODIFICA_VALORE ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || '   ) loca_sist_rtb, ';
 ---> inizio modifica reg 777/2019 06/04/2021 
 sqlstring := sqlstring || ' ( SELECT BCS.SOL_TRACK_1_1_1_0_0_1 , ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_1O2_AP SOL_TRACK_1_1_1_1_1_2_AP, ';
 sqlstring := sqlstring || ' Decode (SOL_TRACK_1_1_1_1_1_1O2_AP, ';
 sqlstring := sqlstring || ' ''NYA'','' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_1O2) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_1_1_2 ';
 sqlstring := sqlstring || '  From  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF DIC, ';
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_SOL BCS, ';
 sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA SL ';
 sqlstring := sqlstring || ' Where  dic.TIPO_DICHIARAZIONE = ''EI'' ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = sl.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' And bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || 'Union ';
 sqlstring := sqlstring || 'Select dic.SOL_TRACK_1_1_1_0_0_1 , ';
 sqlstring := sqlstring || ' ''NYA'' SOL_TRACK_1_1_1_1_1_2_AP, ';
 sqlstring := sqlstring || ' '' '' SOL_TRACK_1_1_1_1_1_2 ';
 sqlstring := sqlstring || '  From (Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || '  From  '|| s_schema||'.BINARI_CORSA_SOL BCS ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || 'Minus ';
 sqlstring := sqlstring || 'Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
 sqlstring := sqlstring || ' Where TIPO_DICHIARAZIONE= ''EI''  ';
 If p_versione Is Not Null 
 Then
   sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' )  dic, ';
 ---> fine modifica 
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_SOL BCS, ';
 sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA SL ';
 sqlstring := sqlstring || ' Where bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' ) dich_ie_inf ';
 sqlstring := sqlstring || '                ';
 sqlstring := sqlstring || 'Where  S.SEDE_TECNICA=SL.SEDE_TECNICA ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = p.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = cat_ten.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = cat_linea.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SEDE_TECNICA = corridoio.SEDE_TECNICA(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = cap_carico.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = prof_casse.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = prof_semir.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = dich_ec_inf.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = dich_ie_inf.SOL_TRACK_1_1_1_0_0_1(+) ';
 ---> inizio modifica reg 777/2019 06/04/2021
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = locaverspec.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || '  And s.SOL_TRACK_1_1_1_0_0_1 = loca_sist_rtb.SOL_TRACK_1_1_1_0_0_1(+) ';
 ---> fine modifica 
 If p_versione Is Not Null Then
   sqlstring := sqlstring || 'And s.CODICE_VERSIONE = ' ||p_versione;
   sqlstring := sqlstring || 'And sl.CODICE_VERSIONE = s.CODICE_VERSIONE ';
 End If;


--filtro richiamato dalla funzione ROUTING
IF p_filtro is NOT NULL THEN
sqlstring:=sqlstring ||GetWhereCondition(p_filtro,'SL.SEDE_TECNICA');
END IF;

--sqlstring:=sqlstring || '         order by 1 ';

DBMS_OUTPUT.PUT_LINE(sqlstring);

END GetSOLParametriINF2_OFF;

PROCEDURE GetInfoGeneraliTrattaBin2_OFF (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.2

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area = 1 OR p_area = 3) 
 THEN
    p_versione := NULL;
 ELSE  --(p_area=2 OR p_area=4)
    IF p_i_versione IS NULL 
    THEN
       p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
    ELSE
       p_versione := p_i_versione;
    END IF;
 END IF;

--->
 sqlstring := 'Select  ';
 sqlstring := sqlstring ||' s.SEDE_TECNICA, ';
 sqlstring := sqlstring ||' s.DEFINIZIONE, ';
 sqlstring := sqlstring ||' bcs.SOL_TRACK_1_1_1_0_0_1 , ';
 sqlstring := sqlstring ||' SOL_TRACK_1_1_1_0_0_1_D, ';
 sqlstring := sqlstring ||' PKG_RINF_REPORT.GetDescription(''1.1.1.0.0.2'', SOL_TRACK_1_1_1_0_0_2) SOL_TRACK_1_1_1_0_0_2, ';
 sqlstring := sqlstring ||' Nvl (SOL_1_1_0_0_0_1, ''0083'') SOL_1_1_0_0_0_1, ';
 sqlstring := sqlstring ||' Nvl (Trim (linea_comm.linea), ''0000'') SOL_1_1_0_0_0_2, ';
 sqlstring := sqlstring ||' SOL_1_1_0_0_0_3, ';
 sqlstring := sqlstring ||' p_i.DEFINIZIONE LOCALITA_INIZIO, ';
 sqlstring := sqlstring ||' SOL_1_1_0_0_0_4, ';
 sqlstring := sqlstring ||' p_f.DEFINIZIONE LOCALITA_FINE, ';
 sqlstring := sqlstring ||' Round (SOL_1_1_0_0_0_5, 3) SOL_1_1_0_0_0_5, ';
 sqlstring := sqlstring ||' PKG_RINF_REPORT.GetDescription(''1.1.0.0.0.6'', SOL_1_1_0_0_0_6) SOL_1_1_0_0_0_6, ';

 ---> Modifica al reg 777/2019 del 06/04/2021
 sqlstring:=sqlstring || ' Decode(SOL_TRACK_1_1_1_4_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.4.1'', SOL_TRACK_1_1_1_4_1)) SOL_TRACK_1_1_1_4_1, ';
 sqlstring:=sqlstring || ' Decode(SOL_TRACK_1_1_1_4_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.4.2'', SOL_TRACK_1_1_1_4_2)) SOL_TRACK_1_1_1_4_2, ';
 ---> Fine modifica
 sqlstring := sqlstring ||' S.CODICE_DTP, ';
 sqlstring := sqlstring ||' S.CODICE_UT, ';
 sqlstring := sqlstring ||' S.CODICE_LINEA_TECNICA ';
--
 sqlstring := sqlstring ||' From '|| s_schema||'.SEZIONI_LINEA s, ';
 sqlstring := sqlstring ||  s_schema||'.PUNTI_OPERATIVI p_i, ';
 sqlstring := sqlstring ||  s_schema||'.PUNTI_OPERATIVI p_f, ';
 sqlstring := sqlstring ||  s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring ||' (Select SEDE_TECNICA, ';
 sqlstring := sqlstring ||'  Listagg (Replace (CODICE, '' '', '''') || '' '') ';
 sqlstring := sqlstring ||'  Within Group (Order By CODICE) ';
 sqlstring := sqlstring ||'  As linea ';
 sqlstring := sqlstring ||' From '|| s_schema||'.V_MDR_LINEE_COMMERCIALI ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring ||' Where CODICE_VERSIONE  = ' ||p_versione;
 End If;
 sqlstring := sqlstring ||' Group By SEDE_TECNICA) linea_comm, ';
 ---> modifica reg 777/2019 del 06/04/2021
 sqlstring:=sqlstring || ' (Select SOL_TRACK_1_1_1_0_0_1, ';
 If p_versione Is Not Null Then
    sqlstring:=sqlstring ||' CODICE_VERSIONE, ';
End If;
 sqlstring:=sqlstring || '  Listagg (Valore, '';'') ';
 sqlstring:=sqlstring || '  Within Group (Order By VALORE) ';
 sqlstring:=sqlstring || '  As SOL_TRACK_1_1_1_4_2 ';
 sqlstring:=sqlstring || ' From  '|| s_schema||'.PAR_1_1_1_4_2_NORME_DOC, ';
 sqlstring:=sqlstring || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
 sqlstring:=sqlstring || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
 sqlstring:=sqlstring || ' Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO ';
 sqlstring:=sqlstring || ' And NUMERO_PARAMETRO = ''1.1.1.4.2'' ';
 sqlstring:=sqlstring || ' And SOL_TRACK_1_1_1_4_2 = CODIFICA_VALORE ';
 If p_versione Is Not Null  Then
    sqlstring:=sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring:=sqlstring || ' Group By SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null  Then
    sqlstring:=sqlstring || ' , CODICE_VERSIONE ';
 End If;
 sqlstring:=sqlstring || '   ) norme_doc ';
 ---> fine modifica
 sqlstring := sqlstring ||' Where s.LOCALITA_INIZIO = p_i.SEDE_TECNICA ';
 sqlstring := sqlstring ||' And s.LOCALITA_FINE = p_f.SEDE_TECNICA ';
 sqlstring := sqlstring ||' And s.SEDE_TECNICA = linea_comm.SEDE_TECNICA(+) ';
 sqlstring := sqlstring ||' And s.SEDE_TECNICA = bcs.SEDE_TECNICA ';
 sqlstring := sqlstring ||' And norme_doc.SOL_TRACK_1_1_1_0_0_1(+) = bcs.SOL_TRACK_1_1_1_0_0_1 ';
 If p_versione Is Not Null  Then
    sqlstring := sqlstring ||' And s.CODICE_VERSIONE  = ' ||p_versione;
    sqlstring := sqlstring ||' And p_i.CODICE_VERSIONE = s.CODICE_VERSIONE ';
    sqlstring := sqlstring ||' And p_f.CODICE_VERSIONE = s.CODICE_VERSIONE ';
    sqlstring := sqlstring ||' And bcs.CODICE_VERSIONE = s.CODICE_VERSIONE ';
    sqlstring := sqlstring ||' And norme_doc.CODICE_VERSIONE (+) = s.CODICE_VERSIONE ';
 End If;
 --filtro richiamato dalla funzione ROUTING
 If p_filtro Is Not Null  Then
    sqlstring := sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro, 's.SEDE_TECNICA');
 End If;
DBMS_OUTPUT.PUT_LINE(sqlstring);

END GetInfoGeneraliTrattaBin2_OFF ;

PROCEDURE GetSOLParametriENE2_OFF (p_area NUMBER,p_i_versione NUMBER ,p_filtro CLOB, p_cursor OUT empcur) IS
--REPORT 3.6.4

s_schema VARCHAR2(100);
sqlstring VARCHAR2(32767);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 --Modifica del 11/09/2017 per ovviare al problema dell'applicazione che passa il parametro della versione sbagliato
 IF (p_area=1 OR p_area=3) 
 THEN
    p_versione:=NULL;
 ELSE 
     IF p_i_versione IS NULL 
     THEN
        p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
     ELSE
        p_versione:=p_i_versione;
     END IF;
 END IF;

 sqlstring := ' Select sl.SEDE_TECNICA, ';
 sqlstring := sqlstring || ' sl.DEFINIZIONE, ';
 sqlstring := sqlstring || ' s.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' s.SOL_TRACK_1_1_1_0_0_1_D , ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_1_1, ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_1_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.1.1'', SOL_TRACK_1_1_1_2_2_1_1)) SOL_TRACK_1_1_1_2_2_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_1_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.1.2'', SOL_TRACK_1_1_1_2_2_1_2)) SOL_TRACK_1_1_1_2_2_1_2, ';
 ---> inizio modifica reg 777/2019 06/04/2021
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_1_2_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.1.2.1'', SOL_TRACK_1_1_1_2_2_1_2_1)) SOL_TRACK_1_1_1_2_2_1_2_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_1_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.1.3'', SOL_TRACK_1_1_1_2_2_1_3)) SOL_TRACK_1_1_1_2_2_1_3, ';
 ---> fine modifica 
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.2'', SOL_TRACK_1_1_1_2_2_2)) SOL_TRACK_1_1_1_2_2_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.3'', SOL_TRACK_1_1_1_2_2_3)) SOL_TRACK_1_1_1_2_2_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_4_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.2.4'', SOL_TRACK_1_1_1_2_2_4)) SOL_TRACK_1_1_1_2_2_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_5_AP, ''NYA'','' '', ''N'', ''Non applicabile'', Trim (To_Char (Round (SOL_TRACK_1_1_1_2_2_5, 2), ''999990.99''))) SOL_TRACK_1_1_1_2_2_5, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_2_6_AP, ''NYA'','' '', ''N'', ''Non applicabile'', Trim (To_Char (Round (SOL_TRACK_1_1_1_2_2_6, 2), ''999990.99''))) SOL_TRACK_1_1_1_2_2_6, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_3_1_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.1'', SOL_TRACK_1_1_1_2_3_1)) SOL_TRACK_1_1_1_2_3_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_3_2_AP, ''NYA'','' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.2'', SOL_TRACK_1_1_1_2_3_2)) SOL_TRACK_1_1_1_2_3_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_3_3_AP, ''NYA'','' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' Decode ( SOL_TRACK_1_1_1_2_3_3_A ';
 sqlstring := sqlstring || ' || '' '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_3_3_B ';
 sqlstring := sqlstring || ' || '' '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_3_3_C, ';
 sqlstring := sqlstring || ' ''++'', NULL, ';
 sqlstring := sqlstring || '    SOL_TRACK_1_1_1_2_3_3_A ';
 sqlstring := sqlstring || ' || '' '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_3_3_B ';
 sqlstring := sqlstring || ' || '' '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_3_3_C)) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_3_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_3_4_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.3.4'', SOL_TRACK_1_1_1_2_3_4)) SOL_TRACK_1_1_1_2_3_4, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_4_1_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.4.1.1'', SOL_TRACK_1_1_1_2_4_1_1)) SOL_TRACK_1_1_1_2_4_1_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_4_1_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' Decode ( ';
 sqlstring := sqlstring || '    SOL_TRACK_1_1_1_2_4_1_2_A ';
 sqlstring := sqlstring || ' || ''+'' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_1_2_B ';
 sqlstring := sqlstring || ' || ''+'' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_1_2_C, ';
 sqlstring := sqlstring || ' ''++'', NULL, ';
 sqlstring := sqlstring || ' ''length '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_1_2_A ';
 sqlstring := sqlstring || ' || '' + switch off breaker '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_1_2_B ';
 sqlstring := sqlstring || ' || '' + lower pantograph '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_1_2_C)) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_4_1_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_4_2_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.4.2.1'', SOL_TRACK_1_1_1_2_4_2_1)) SOL_TRACK_1_1_1_2_4_2_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_4_2_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' Decode ( ';
 sqlstring := sqlstring || '    SOL_TRACK_1_1_1_2_4_2_2_A ';
 sqlstring := sqlstring || ' || ''+'' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_B ';
 sqlstring := sqlstring || ' || ''+'' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_C ';
 sqlstring := sqlstring || ' || ''+'' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_D, ';
 sqlstring := sqlstring || ' ''+++'', NULL, ';
 sqlstring := sqlstring || '    ''length '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_A ';
 sqlstring := sqlstring || ' || '' + switch off breaker '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_B ';
 sqlstring := sqlstring || ' || '' + lower pantograph '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_C ';
 sqlstring := sqlstring || ' || '' + change supply system '' ';
 sqlstring := sqlstring || ' || SOL_TRACK_1_1_1_2_4_2_2_D)) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_4_2_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_4_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.4.3'', SOL_TRACK_1_1_1_2_4_3)) SOL_TRACK_1_1_1_2_4_3, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_5_1_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.5.1'', SOL_TRACK_1_1_1_2_5_1)) SOL_TRACK_1_1_1_2_5_1, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_5_2_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.5.2'', SOL_TRACK_1_1_1_2_5_2)) SOL_TRACK_1_1_1_2_5_2, ';
 sqlstring := sqlstring || ' Decode(SOL_TRACK_1_1_1_2_5_3_AP, ''NYA'', '' '', ''N'', ''Non applicabile'', PKG_RINF_REPORT.GetDescription(''1.1.1.2.5.3'', SOL_TRACK_1_1_1_2_5_3)) SOL_TRACK_1_1_1_2_5_3, ';
 sqlstring := sqlstring || ' CODICE_DTP, ';
 sqlstring := sqlstring || ' CODICE_UT, ';
 sqlstring := sqlstring || ' CODICE_LINEA_TECNICA ';
 sqlstring := sqlstring || ' From '|| s_schema||'.BINARI_CORSA_SOL s, ';
 sqlstring := sqlstring ||   s_schema||'.SEZIONI_LINEA sl, ';
 sqlstring := sqlstring || ' ( Select BCS.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_1_1O2_AP SOL_TRACK_1_1_1_2_1_1_AP, ';
 sqlstring := sqlstring || ' Decode (SOL_TRACK_1_1_1_2_1_1O2_AP, ';
 sqlstring := sqlstring || ' ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || '  SOL_TRACK_1_1_1_2_1_1O2) ';
 sqlstring := sqlstring || '  SOL_TRACK_1_1_1_2_1_1 ';
 sqlstring := sqlstring || '  From '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE dic, ';
 sqlstring := sqlstring ||    s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring ||    s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' where  DIC.TIPO_DICHIARAZIONE = ''EC'' ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = sl.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' And bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || ' Union ';
 sqlstring := sqlstring || ' Select dic.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' ''NYA'' SOL_TRACK_1_1_1_2_1_1_AP, ';
 sqlstring := sqlstring || ' '' '' SOL_TRACK_1_1_1_2_1_1 ';
 sqlstring := sqlstring || ' From (SELECT SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.BINARI_CORSA_SOL bcs ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Minus ';
 sqlstring := sqlstring || ' Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
 sqlstring := sqlstring || ' Where TIPO_DICHIARAZIONE = ''EC''  ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ')  dic, ';
 sqlstring := sqlstring ||   s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring ||   s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where  BCS.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
 End If;
 sqlstring :=sqlstring || ' ) DICH_EC_ENE, ';
 sqlstring := sqlstring || ' ( SELECT BCS.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_1_1O2_AP SOL_TRACK_1_1_1_2_1_2_AP, ';
 sqlstring := sqlstring || ' Decode (SOL_TRACK_1_1_1_2_1_1O2_AP, ';
 sqlstring := sqlstring || ' ''NYA'', '' '', ''N'', ''Non applicabile'', ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_1_1O2) ';
 sqlstring := sqlstring || ' SOL_TRACK_1_1_1_2_1_2 ';
 sqlstring := sqlstring || ' From  '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE dic, ';
 sqlstring := sqlstring ||   s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring ||   s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where dic.TIPO_DICHIARAZIONE = ''EI'' ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And dic.CODICE_VERSIONE = bcs.CODICE_VERSIONE ';
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = sl.CODICE_VERSIONE ';
 End If;
 sqlstring := sqlstring || ' And bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || ' Union ';
 sqlstring := sqlstring || ' Select dic.SOL_TRACK_1_1_1_0_0_1, ';
 sqlstring := sqlstring || ' ''NYA'' SOL_TRACK_1_1_1_2_1_2_AP, ';
 sqlstring := sqlstring || ' '' '' SOL_TRACK_1_1_1_2_1_2 ';
 sqlstring := sqlstring || ' From (Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.BINARI_CORSA_SOL bcs ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' Where CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' Minus ';
 sqlstring := sqlstring || ' Select SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' From '|| s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
 sqlstring := sqlstring || ' Where TIPO_DICHIARAZIONE= ''EI''  ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And CODICE_VERSIONE = ' ||p_versione;
 End If;
 sqlstring := sqlstring || ' )  dic, ';
 sqlstring := sqlstring || s_schema||'.BINARI_CORSA_SOL bcs, ';
 sqlstring := sqlstring || s_schema||'.SEZIONI_LINEA sl ';
 sqlstring := sqlstring || ' Where  bcs.SOL_TRACK_1_1_1_0_0_1 = dic.SOL_TRACK_1_1_1_0_0_1 ';
 sqlstring := sqlstring || ' And bcs.SEDE_TECNICA = sl.SEDE_TECNICA ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And bcs.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = BCS.CODICE_VERSIONE ';
 End If;         
 sqlstring := sqlstring || ') dich_ie_ene    ';
 sqlstring := sqlstring || ' Where s.SEDE_TECNICA = sl.SEDE_TECNICA ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = dich_ec_ene.SOL_TRACK_1_1_1_0_0_1(+) ';
 sqlstring := sqlstring || ' And s.SOL_TRACK_1_1_1_0_0_1 = dich_ie_ene.SOL_TRACK_1_1_1_0_0_1(+) ';
 If p_versione Is Not Null 
 Then
    sqlstring := sqlstring || ' And s.CODICE_VERSIONE = ' ||p_versione;
    sqlstring := sqlstring || ' And sl.CODICE_VERSIONE = s.CODICE_VERSIONE ';
 End If;
 --filtro richiamato dalla funzione ROUTING
 If p_filtro Is Not Null 
 Then
   sqlstring:=sqlstring ||PKG_RINF_REPORT.GetWhereCondition(p_filtro,'SL.SEDE_TECNICA');
 End If;
 --sqlstring:=sqlstring || '         order by 1 ';
 DBMS_OUTPUT.PUT_LINE(sqlstring);
 -- OPEN p_cursor FOR sqlstring;
END GetSOLParametriENE2_OFF ;


END PKG_RINF_REPORT;
/