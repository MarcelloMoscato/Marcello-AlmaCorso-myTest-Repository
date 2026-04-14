--
-- PKG_RINF_INTERFACCIA  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_INTERFACCIA" As
/******************************************************************************
   NAME:       PKG_RINF_INTERFACCIA
   PURPOSE: 

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/01/2014     D.Campagiorni        1. Created this package.
   1.1        16/10/2024                         1.1 Modificata SetDataValidita_Parametro   

******************************************************************************/

  TYPE empcur IS REF CURSOR;
  Procedure GetLanguageList (p_cursor Out empcur);
  Procedure GetXMLList (p_cursor Out empcur);
  Procedure GetMultiLanguageDictionary (p_codice_lingua Number, p_cursor Out empcur);
  Procedure SetMultiLanguageLabel (p_codice_lingua Number, p_codice_voce Number, p_nuovo_testo Varchar2,p_nuovo_toolTip Varchar2, p_errorcode Out Number);
  Procedure SetDefaultLanguage (p_codice_lingua Number,  p_errorcode Out Number);
  Procedure GetGeographicContest (p_username Varchar2 DEFAULT NULL,p_cursor Out empcur);
  Procedure GetDataArea (p_username Varchar2 DEFAULT NULL,p_cursor Out empcur);
  FUNCTION GetSchemaName(p_codice_area Number) RETURN Varchar2;
  FUNCTION GetDataRiferimento(p_codice_area Number,p_i_versione Number) RETURN DATE;
  Procedure GetObjectList(p_contesto Number, p_area Number, p_righe Number,p_stringa Varchar2,p_i_versione Number,p_cursor Out empcur);
  Procedure GetSOLList(p_contesto Number, p_area Number, p_filtro Varchar2,p_i_versione Number,p_cursor Out empcur);
  Procedure GetOPList(p_contesto Number, p_area Number, p_filtro Varchar2,p_i_versione Number,p_cursor Out empcur);
  Procedure GetSOLGeographicContest(p_sol Varchar2, p_area Number,p_i_versione Number,p_cursor Out empcur);
  Procedure GetOPGeographicContest(p_op Varchar2, p_area Number,p_i_versione Number,p_cursor Out empcur) ;
  FUNCTION GetParameterID(cod_parametro Varchar2) RETURN Number;
  Procedure GetAnagDTP(p_cursor Out empcur);
  Procedure GetAnagUT(p_cursor Out empcur);
  Procedure GetExpButtonList (p_username Varchar2 DEFAULT NULL,p_cursor Out empcur);
  Procedure GetcatalogoParametri (P_Numero_Parametro Varchar2, p_cursor Out sys_refcursor);
-- Modifica parametri
  Procedure GetParametersList(p_cursor Out empcur);
  Procedure GetAnagViste(p_cursor Out empcur);
  Procedure GetAnagTipoDoMinio(p_cursor Out empcur);
  Procedure GetValueList(p_codice_parametro Number,p_cursor Out empcur);
  Procedure GetRange(p_codice_parametro Number,p_cursor Out empcur);
  Procedure SetParameterValue(p_codice_parametro Number,p_codice_tipo_depositario Number,p_nya Number, p_error Out Number);
  Procedure SetParameterList(p_codice_parametro Number,p_lista Varchar2, p_error Out Number);
  Procedure SetParameterRange(p_codice_parametro Number,p_valore_Minimo Number,p_valore_massimo Number, p_error Out Number);
  Procedure SetCatalogoParametri (P_Parametri_Flag Varchar2, p_error Out Number);
  Procedure SetDataValidita_Parametro (P_Numero_Parametro Varchar2, p_data_inizio Date, p_data_fine Date, p_error Out Number);
-- Abilitazione controlli
  Procedure GetControlSet(p_cursor Out empcur);
  Procedure SetControlSet(p_lista Varchar2,p_error Out Number);
-- Sede Centrale Multipla
  Procedure GetAnagSC(p_cursor Out empcur);
END PKG_RINF_INTERFACCIA;
/


--
-- PKG_RINF_INTERFACCIA  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_INTERFACCIA" As
--
--
-- --------------------------------------------------------------------------------------
--                   Procedure GetLanguageList
-- --------------------------------------------------------------------------------------
--
  Procedure GetLanguageList (p_cursor Out empcur) Is
    BEGIN
      Open p_cursor For
      Select CODICE_LINGUA, SIGLA_LINGUA, DESCRIZIONE, LINGUA_DEFAULT
      From V_ANAGRAFICA_LINGUE
      order by CODICE_LINGUA desc;
--  
  END GetLanguageList;
--
-- --------------------------------------------------------------------------------------
--                      Procedure GetXMLList
-- --------------------------------------------------------------------------------------
--
  Procedure GetXMLList (p_cursor Out empcur) Is
    BEGIN
      Open p_cursor For
      Select Distinct  NUMERO_PARAMETRO, XML_NAME
        From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
       Where XML_NAME Is Not Null
      Union
      Select Distinct NUMERO_PARAMETRO_MULTIPLO as Numero_Parametro, XML_NAME
        From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
       Where XML_NAME Is Not Null;
--  
  END GetXMLList;
--
-- --------------------------------------------------------------------------------------
--                       Procedure GetExpButtonList 
-- --------------------------------------------------------------------------------------
--
  Procedure GetExpButtonList (p_username Varchar2 Default Null,p_cursor Out empcur) Is
    BEGIN
      If p_username Is Null Then
          Open p_cursor For Select 0 PDF,0 XML,0 XLS,0 RFL From Dual;
      Else
          Open p_cursor For
/*
 Select Max(PDF.FLAG_ABILITATO) PDF,Max(XML.FLAG_ABILITATO) XML,Max(XLS.FLAG_ABILITATO) XLS
    From
    RINF_SICUREZZA_EVO.BUTTON_RUOLI pdf,
    RINF_SICUREZZA_EVO.BUTTON_RUOLI xls,
    RINF_SICUREZZA_EVO.BUTTON_RUOLI xml,
    RINF_SICUREZZA_EVO.UTENTE_RUOLI u
    Where
    pdf.NOME_FUNZIONE='EXPORT_DATI' and
    xls.NOME_FUNZIONE='EXPORT_DATI' and
    xml.NOME_FUNZIONE='EXPORT_DATI' and
    pdf.CODICE_BUTTON='PDF' and
    xls.CODICE_BUTTON='XLS' and
    xml.CODICE_BUTTON='XML' and
    pdf.CODICE_RUOLO=U.CODICE_RUOLO and
    xls.CODICE_RUOLO=U.CODICE_RUOLO and
    xml.CODICE_RUOLO=U.CODICE_RUOLO and
    U.ID_UTENTE=PKG_RINF_SICUREZZA.GETUSERID(p_username);
*/
           Select Max(PDF.FLAG_ABILITATO) PDF, Max(XML.FLAG_ABILITATO) XML, Max(XLS.FLAG_ABILITATO) XLS, Max(RFL.FLAG_ABILITATO) RFL
              From  RINF_SICUREZZA_EVO.BUTTON_RUOLI pdf,
                    RINF_SICUREZZA_EVO.BUTTON_RUOLI xls,
                    RINF_SICUREZZA_EVO.BUTTON_RUOLI xml,
                    RINF_SICUREZZA_EVO.BUTTON_RUOLI rfl,
                    RINF_SICUREZZA_EVO.UTENTE_RUOLI u
              Where pdf.NOME_FUNZIONE = 'EXPORT_DATI' 
                And xls.NOME_FUNZIONE = 'EXPORT_DATI' 
                And xml.NOME_FUNZIONE = 'EXPORT_DATI' 
                And rfl.NOME_FUNZIONE = 'EXPORT_DATI' 
                And pdf.CODICE_BUTTON = 'PDF' 
                And xls.CODICE_BUTTON = 'XLS' 
                And xml.CODICE_BUTTON = 'XML' 
                And rfl.CODICE_BUTTON = 'RFL' 
                And pdf.CODICE_RUOLO = U.CODICE_RUOLO 
                And xls.CODICE_RUOLO = U.CODICE_RUOLO 
                And xml.CODICE_RUOLO = U.CODICE_RUOLO 
                And rfl.CODICE_RUOLO = U.CODICE_RUOLO 
                And u.ID_UTENTE = PKG_RINF_SICUREZZA.GETUSERID(p_username);
      End If;
--
  EXCEPTION 
	  When  OTHERS Then 
	       Open p_cursor For Select 0 PDF,0 XML,0 XLS From Dual;
  END GetExpButtonList;
--
-- --------------------------------------------------------------------------------------
--                      Procedure GetMultiLanguageDictionary 
-- --------------------------------------------------------------------------------------
--
  Procedure GetMultiLanguageDictionary (p_codice_lingua Number, p_cursor Out empcur) Is
    BEGIN
        Open p_cursor For
        Select CODICE_LINGUA, SIGLA_LINGUA, LINGUA, GRUPPO, CODICE_VOCE, NOME_UNICO, TESTO, TOOLTIP
        From V_DIZIONARIO_MULTILINGUA
        Where CODICE_LINGUA = p_codice_lingua
        Order By CODICE_LINGUA,CODICE_VOCE Desc;
  END GetMultiLanguageDictionary;
--
-- --------------------------------------------------------------------------------------
--                       Procedure SetMultiLanguageLabel
-- --------------------------------------------------------------------------------------
--
 Procedure SetMultiLanguageLabel (p_codice_lingua Number, p_codice_voce Number, p_nuovo_testo Varchar2, p_nuovo_toolTip Varchar2, p_errorcode Out Number) Is
    BEGIN
       p_errorcode := 0;
--
       Update Rinf_Anagrafiche_Evo.ETICHETTA_VOCI
          Set ETICHETTA = p_nuovo_testo,
              TOOLTIP = p_nuovo_toolTip
        Where CODICE_VOCE  = p_codice_voce
          And CODICE_LINGUA = p_codice_lingua;
--
       Commit;
 EXCEPTION
    When  OTHERS Then
         p_errorcode := SQLCODE;
 END SetMultiLanguageLabel;
--
-- --------------------------------------------------------------------------------------
--                  Procedure SetDefaultLanguage
-- --------------------------------------------------------------------------------------
--
 Procedure SetDefaultLanguage (p_codice_lingua Number,  p_errorcode Out Number) Is
    BEGIN
       p_errorcode := 0;
 --     
        Update Rinf_Anagrafiche_Evo.ANAG_LINGUA
           Set LINGUA_DEFAULT = 'NO';

        Update Rinf_Anagrafiche_Evo.ANAG_LINGUA
           Set LINGUA_DEFAULT = 'SI'
         Where CODICE_LINGUA = p_codice_lingua;
--
        Commit;
  EXCEPTION
     When  OTHERS Then
          p_errorcode :=  SQLCODE;
  END SetDefaultLanguage;
--
-- --------------------------------------------------------------------------------------
--                Procedure GetGeographicContest
-- --------------------------------------------------------------------------------------
--

 Procedure GetGeographicContest (p_username Varchar2 Default Null, p_cursor Out empcur) Is
    BEGIN
        If p_username Is Null Then
            Open p_cursor For
                 Select c.CODICE_CONTESTO, c.CODICE_VOCE
                   From Rinf_Anagrafiche_Evo.ANAG_CONTESTO_GEO c
                   Order By 1;
        Else
            Open p_cursor For
                Select Distinct c.CODICE_CONTESTO, c.CODICE_VOCE
                  From Rinf_Anagrafiche_Evo.ANAG_CONTESTO_GEO c,
                       Rinf_Sicurezza_Evo.CONTESTO_RUOLI r,
                       Rinf_Sicurezza_Evo.UTENTE_RUOLI u
                 Where r.CODICE_RUOLO = u.CODICE_RUOLO 
		   	       And r.CODICE_CONTESTO = c.CODICE_CONTESTO 
		   	       And u.ID_UTENTE = PKG_RINF_SICUREZZA.GetUserId(p_username)
                 Order By 1;
        End If;
 END GetGeographicContest;
--
-- --------------------------------------------------------------------------------------
--                  Procedure GetDataArea 
-- --------------------------------------------------------------------------------------
--
 Procedure GetDataArea (p_username Varchar2 Default Null, p_cursor Out empcur) Is
   BEGIN
      If p_username Is Null Then
          Open p_cursor For
--          
            Select v.CODICE_AREA, v.CODICE_VOCE, TESTO_DATE
              From Rinf_Anagrafiche_Evo.ANAG_AREA_RINF v,
                 (Select CODICE_AREA, TESTO_DATE
                    From Rinf_Anagrafiche_Evo.ANAG_AREA_RINF v,
                         (Select To_Char(Max (DATA_CONTROLLO), 'DD/MM/YYYY') as TESTO_DATE
                            From Rinf_Lavorazione_Evo.CONTROLLO_DATI)
                   Where CODICE_AREA = 1
                  Union
                  Select CODICE_AREA, TESTO_DATE
                    From Rinf_Anagrafiche_Evo.ANAG_AREA_RINF v,
                         (Select To_Char(Max (DATA_TRASMISSIONE), 'DD/MM/YYYY') as TESTO_DATE
                            From Rinf_Pubblicati_Evo.ANAGRAFICA_TRASMISSIONI
                           Where CODICE_TRASMISSIONE = 1)
                   Where CODICE_AREA = 2
                  Union
                  Select CODICE_AREA, TESTO_DATE
                    From Rinf_Anagrafiche_Evo.ANAG_AREA_RINF v,
                         (Select To_Char (Max (DATA_RICHIESTA), 'DD/MM/YYYY')  as TESTO_DATE
                            From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI
                           Where CODICE_STATO_RICHIESTA = 1)
                   Where CODICE_AREA = 3
                  Union
                  Select CODICE_AREA, TESTO_DATE
                    From Rinf_Anagrafiche_Evo.ANAG_AREA_RINF v,
                         (Select To_Char (Max (DATA_PUBBLICAZIONE), 'DD/MM/YYYY') as TESTO_DATE
                            From Rinf_Pubblicati_Evo.VERSIONE_RINF
                           Where PROTOCOLLO Is Null)
                   Where CODICE_AREA = 4)  metadati
           Where AREA_DEFAULT = 1 
		     And v.CODICE_AREA = metadati.CODICE_AREA;

     Else
          Open p_cursor For
            Select t.CODICE_AREA, t.CODICE_VOCE, TESTO_DATE
              From (Select Distinct CODICE_AREA, CODICE_VOCE, AREA_DEFAULT
                      From Rinf_Anagrafiche_Evo.ANAG_AREA_RINF v,
                           Rinf_Sicurezza_Evo.COMBO_RUOLI r,
                           Rinf_Sicurezza_Evo.UTENTE_RUOLI u
                     Where r.NOME_TABELLA = 'ANAG_AREA_RINF'
                       And r.CODICE_RUOLO = u.CODICE_RUOLO
                       And r.CODICE_COMBO = v.CODICE_AREA
                       And u.ID_UTENTE = PKG_RINF_SICUREZZA.GetUserId(p_username)
                    Union
                    Select CODICE_AREA, CODICE_VOCE, AREA_DEFAULT
                      From Rinf_Anagrafiche_Evo.ANAG_AREA_RINF
                     Where AREA_DEFAULT = 1
					 ) t,
                   (Select CODICE_AREA, TESTO_DATE
                      From Rinf_Anagrafiche_Evo.ANAG_AREA_RINF v,
                           (Select To_Char (Max (DATA_CONTROLLO), 'DD/MM/YYYY') as TESTO_DATE
                              From Rinf_Lavorazione_Evo.CONTROLLO_DATI)
                     Where CODICE_AREA = 1
                    Union
                    Select CODICE_AREA, TESTO_DATE
                      From Rinf_Anagrafiche_Evo.ANAG_AREA_RINF v,
                           (Select To_Char (Max (DATA_TRASMISSIONE), 'DD/MM/YYYY') as TESTO_DATE
                              From Rinf_Pubblicati_Evo.ANAGRAFICA_TRASMISSIONI
                             Where CODICE_TRASMISSIONE = 1)
                     Where CODICE_AREA = 2
                    Union
                    Select CODICE_AREA, TESTO_DATE
                      From Rinf_Anagrafiche_Evo.ANAG_AREA_RINF v,
                           (Select To_Char (Max (DATA_RICHIESTA), 'DD/MM/YYYY') as TESTO_DATE
                              From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI
                             Where CODICE_STATO_RICHIESTA = 1)
                     Where CODICE_AREA = 3
                    Union
                    Select CODICE_AREA, TESTO_DATE
                      From Rinf_Anagrafiche_Evo.ANAG_AREA_RINF v,
                           (Select To_Char (Max (DATA_PUBBLICAZIONE), 'DD/MM/YYYY') as TESTO_DATE
                              From Rinf_Pubblicati_Evo.VERSIONE_RINF
                             Where PROTOCOLLO Is Null)
                     Where CODICE_AREA = 4
					 ) metadati
             Where t.CODICE_AREA = metadati.CODICE_AREA
          Order By AREA_DEFAULT Desc;
     End If;
 END GetDataArea;
--
-- --------------------------------------------------------------------------------------
--                 Function GetSchemaName
-- --------------------------------------------------------------------------------------
--
 Function GetSchemaName (p_codice_area Number) Return Varchar2 Is
      s_schema Varchar2(100);
   BEGIN
      Select SCHEMA_DATI Into s_schema
        From Rinf_Anagrafiche_Evo.ANAG_AREA_RINF
       Where CODICE_AREA = p_codice_area;
   Return s_schema;
 END GetSchemaName;
--
-- --------------------------------------------------------------------------------------
--                       Function GetDataRiferimento
-- 13/02/2018 creta per gestire la data di riferimetno dei dati legata all'area dati
-- --------------------------------------------------------------------------------------
--
 Function GetDataRiferimento (p_codice_area Number, p_i_versione Number) Return Date Is
       d_data_riferimento Date;
       p_versione Number;
   BEGIN
       If (p_codice_area = 2 Or p_codice_area = 4) And p_i_versione Is Null Then
             p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_codice_area);
       Else
             p_versione := p_i_versione;
       End If;
--      
      Case
           When p_codice_area = 1 Then                                                  -- Controllati/Corretti
                   Select Max(DATA_RIFERIMENTO) Into d_data_riferimento
                     From Rinf_Lavorazione_Evo.CONTROLLO_DATI;
           When p_codice_area = 2 Then                                                  -- Pubblicati/Inviati
                   Select DATA_RIFERIMENTO Into d_data_riferimento
                     From Rinf_Pubblicati_Evo.VERSIONE_RINF
                    Where CODICE_VERSIONE = p_versione;
           When p_codice_area = 3 Then                                                  -- Autorizzati
                   Select Max(DATA_RIFERIMENTO) Into d_data_riferimento
                     From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI;
           When p_codice_area = 4 Then                                                  -- Pronti
                   Select DATA_RIFERIMENTO Into d_data_riferimento
                     From Rinf_Pubblicati_Evo.VERSIONE_RINF
                    Where CODICE_VERSIONE = p_versione;
      End Case;
      Return d_data_riferimento;
END GetDataRiferimento;
--
-- --------------------------------------------------------------------------------------
--                                Procedure GetObjectList
-- --------------------------------------------------------------------------------------
--
 Procedure GetObjectList(p_contesto Number, p_area Number, p_righe Number, p_stringa Varchar2, p_i_versione Number, p_cursor Out empcur) Is
      sqlstringa Varchar2(5000);
      s_schema Varchar2(100);
      p_versione Number;
   BEGIN
      If p_area Is Not Null Then
          s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
      End If;
--
      p_versione := p_i_versione;
--
      If (p_area = 2 Or p_area = 4) And p_versione Is Null Then
            p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
      End If;
--
      Case When p_contesto = 1 Then                                                      -- Punto operativo
                sqlstringa := 'Select SEDE_TECNICA ID, DEFINIZIONE DESCRIZIONE From '||s_schema||'.PUNTI_OPERATIVI Where (Upper(SEDE_TECNICA)||'' ''||Upper(DEFINIZIONE) like ''%'||Upper(p_stringa)||'%'') and rownum <= '||p_righe;
                If p_versione Is Not Null Then
                   sqlstringa := sqlstringa||' and CODICE_VERSIONE = '||p_versione;
                End If;
-- Dbms_Output.Put_Line(sqlstringa);
                Open p_cursor For sqlstringa;
           When p_contesto = 2 Then                                                      -- Sezione di Linea
                sqlstringa := 'Select SEDE_TECNICA ID, DEFINIZIONE DESCRIZIONE From '||s_schema||'.SEZIONI_LINEA Where (Upper(SEDE_TECNICA)||'' ''||Upper(DEFINIZIONE) like ''%'||Upper(p_stringa)||'%'') and rownum <= '||p_righe;
                If p_versione Is Not Null Then
                   sqlstringa := sqlstringa||' and CODICE_VERSIONE = '||p_versione;
                End If;
-- Dbms_Output.Put_Line(sqlstringa);
               Open p_cursor For sqlstringa;
 /** modifcato il 27/03/2018 per richiesta di Autiero di vedere la latitudine/longitudine del punto prescelto  **/

           When p_contesto = 11 Then                                                    -- Punto operativo con LAM (coordinate geografiche)
                sqlstringa := 'Select SEDE_TECNICA ID, DEFINIZIONE DESCRIZIONE, To_Char(LATITUDINE, ''990.99999'') LATITUDINE, To_Char(LONGITUDINE, ''990.99999'') LONGITUDINE From '||s_schema||'.PUNTI_OPERATIVI Where (Upper(SEDE_TECNICA)||'' ''||Upper(DEFINIZIONE) like ''%'||Upper(p_stringa)||'%'') and rownum <= '||p_righe;
-- sqlstringa:='Select SEDE_TECNICA ID, DEFINIZIONE DESCRIZIONE, trunc(LATITUDINE, 5) LATITUDINE, trunc(LONGITUDINE, 5) LONGITUDINE From '||s_schema||'.PUNTI_OPERATIVI Where (Upper(SEDE_TECNICA)||'' ''||Upper(DEFINIZIONE) like ''%'||Upper(p_stringa)||'%'') and rownum<='||p_righe;
                If p_versione Is Not Null Then
                   sqlstringa := sqlstringa||' and CODICE_VERSIONE = '||p_versione;
                End If;
-- Dbms_Output.Put_Line(sqlstringa);
                Open p_cursor For sqlstringa;

 /** modifcato il 20/12/2018 per richiesta di Autiero di non vedere la descrizione del Fascicolo Linea  **/
           When p_contesto = 10 Then                                                    -- Fascicolo Linea

/********     Versione Debora
    sqlstringa:='Select DISTINCT c.CODICE ID, NULL DESCRIZIONE From V_CONTESTO_GEOGRAFICO c, ';
    sqlstringa:=sqlstringa||'(Select CODICE_CONTESTO, CODICE From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO ';
    sqlstringa:=sqlstringa||'Union ';
    sqlstringa:=sqlstringa||'Select CODICE_CONTESTO, CODICE From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO) v ';
    sqlstringa:=sqlstringa||' Where c.CODICE_CONTESTO=v.CODICE_CONTESTO and c.CODICE=v.CODICE';
--    sqlstringa:=sqlstringa||' and c.CODICE_CONTESTO='|| p_contesto ||' and (UPPER(c.CODICE)||'' ''||UPPER(c.DESCRIZIONE) like ''%'||UPPER(p_stringa)||'%'') and rownum<='||p_righe;
    sqlstringa:=sqlstringa||' and c.CODICE_CONTESTO='|| p_contesto ||' and (UPPER(c.CODICE)||'' ''||UPPER(c.DESCRIZIONE) like ''%'||UPPER(p_stringa)||'%'')' ;
    sqlstringa:=sqlstringa||' order by to_Number(substr(c.codice,4, length(c.codice)))'; -->aggiunta per avere un ordinamento crescente E.P.
 ***********************/

                sqlstringa := 'Select Distinct ''FL ''||To_Char(fascicolo_linea) ID, '' - DTP ''||Trim(NOMEDTP) DESCRIZIONE ';
                sqlstringa := sqlstringa||' From Rinf_Anagrafiche_Evo.ANAG_FASCICOLO_LINEE fl, RINF_STAGING_EVO.PIC_DTP d ';
                sqlstringa := sqlstringa||' Where d.CODICEDTP = fl.CODICE_DTP ';
                sqlstringa := sqlstringa||' And fl.FLAG_DISPARI = 1 ';
                sqlstringa := sqlstringa||' And fl.DATA_SCADENZA Is Null ';
                sqlstringa := sqlstringa||' And d.DATAFINEVALIDITA Is Null ';
                sqlstringa := sqlstringa||' And UPPER(NOMEDTP) Like ''%'||Upper(p_stringa)||'%'' ' ;
                sqlstringa := sqlstringa||' Order By 2, 1';
-- Dbms_Output.Put_Line(sqlstringa);
                Open p_cursor FOR sqlstringa;


           Else
--                sqlstringa:='Select DISTINCT CODICE ID, DESCRIZIONE From V_CONTESTO_GEOGRAFICO Where CODICE_CONTESTO = '|| p_contesto ||' And (Upper(CODICE)||'' ''||UPPER(DESCRIZIONE) like ''%'||UPPER(p_stringa)||'%'') and rownum<='||p_righe; 18/11/2015 Modificata per evitare che gli oggetti scaduti e senza relazione nell''area selezionata vengano visualizzati
                sqlstringa := 'Select DISTINCT c.CODICE ID, DESCRIZIONE From V_CONTESTO_GEOGRAFICO c, ';
                sqlstringa := sqlstringa||'(Select CODICE_CONTESTO, CODICE From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO ';
                sqlstringa := sqlstringa||' Union ';
                sqlstringa := sqlstringa||' Select CODICE_CONTESTO, CODICE From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO) v ';
                sqlstringa := sqlstringa||' Where c.CODICE_CONTESTO = v.CODICE_CONTESTO And c.CODICE=v.CODICE';
                sqlstringa := sqlstringa||' and c.CODICE_CONTESTO = '|| p_contesto ||' And (Upper(c.CODICE)||'' ''||UPPER(c.DESCRIZIONE) Like ''%'||Upper(p_stringa)||'%'') and rownum <= '||p_righe;
--  Dbms_Output.Put_Line(sqlstringa);
                Open p_cursor FOR sqlstringa;
      End Case;
 EXCEPTION
      When OTHERS Then
           Open p_cursor For 'Select null ID, null DESCRIZIONE From Dual';
 END GetObjectList;
--
-- --------------------------------------------------------------------------------------
--                            Procedure GetSOLList
-- --------------------------------------------------------------------------------------
--
 Procedure GetSOLList (p_contesto Number, p_area Number, p_filtro Varchar2, p_i_versione Number, p_cursor Out empcur) Is
      sqlstringa Varchar2(5000);
      s_schema Varchar2(100);
      p_versione Number;
   BEGIN
      If p_area Is Not Null Then
          s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
      End If;
      p_versione := p_i_versione;
      If (p_area = 2 Or p_area = 4) And p_versione Is Null Then
          p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
      End If;
--      
      If p_contesto = 9 Then                                                             --20/07/2015 Introdotto il contesto "Intera Rete"
            sqlstringa := 'Select SEDE_TECNICA From '||s_schema||'.SEZIONI_LINEA ';
            If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' Where CODICE_VERSIONE = '||p_versione;
            End If;
       Else
            sqlstringa:='Select DISTINCT SEDE_TECNICA  From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO Where codice_contesto='||p_contesto;
            sqlstringa:=sqlstringa||' and CODICE='''||p_filtro ||'''';
            If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' and CODICE_VERSIONE = '||p_versione;
            End If;
       End If;
--
      Open p_cursor For sqlstringa;
--
 EXCEPTION
       When OTHERS Then
            Open p_cursor For 'Select null SEDE_TECNICA From Dual';
 END GetSOLList;
--
-- --------------------------------------------------------------------------------------
--                          Procedure GetOPList
-- --------------------------------------------------------------------------------------
--
 Procedure GetOPList (p_contesto Number, p_area Number, p_filtro Varchar2, p_i_versione Number, p_cursor Out empcur) Is
      sqlstringa Varchar2(5000);
      s_schema Varchar2(100);
      p_versione Number;
   BEGIN
      If p_area Is Not Null Then
          s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
      End If;
--
      p_versione := p_i_versione;
      If (p_area = 2 Or p_area = 4) And p_versione Is Null Then
          p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
      End If;
--
      If p_contesto = 9 Then                                               --03/10/2016 Introdotto il contesto "Intera Rete"
            sqlstringa := 'Select SEDE_TECNICA  From '||s_schema||'.PUNTI_OPERATIVI ';
            If p_versione Is Not Null Then
                sqlstringa := sqlstringa||' Where CODICE_VERSIONE = '||p_versione;
            End If;
      Else
           sqlstringa := 'Select DISTINCT SEDE_TECNICA  From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO Where CODICE_CONTESTO = '||p_contesto;
           sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
           If p_versione Is Not Null Then
                sqlstringa:=sqlstringa||' And CODICE_VERSIONE = '||p_versione;
           End If;
      End If;
      Open p_cursor For Sqlstringa;
 EXCEPTION
      When OTHERS Then
           Open p_cursor For 'Select null SEDE_TECNICA From Dual';
 END GetOPList;
--
-- --------------------------------------------------------------------------------------
--                       Procedure GetSOLGeographicContest
-- --------------------------------------------------------------------------------------
--
 Procedure GetSOLGeographicContest (p_sol Varchar2, p_area Number, p_i_versione Number, p_cursor Out empcur) Is
      sqlstringa Varchar2(5000);
      s_schema Varchar2(100);
      p_versione Number;
  BEGIN
      If p_area Is Not Null Then
          s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
      End If;
--
      p_versione := p_i_versione;
      If (p_area = 2 Or p_area = 4) And p_versione Is Null Then
             p_versione := PKG_RINF_DATA_V777.GetLastVersion(p_area);
      End If;
--
      sqlstringa := 'Select CODICE_CONTESTO, CONTESTO, CODICE, Case CODICE_CONTESTO When 10 Then Null Else DESCRIZIONE End DESCRIZIONE, SEDE_TECNICA  From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO Where SEDE_TECNICA = '''||p_sol||'''';
      If p_versione Is Not Null Then
            sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
      End If;
--
      sqlstringa := sqlstringa||' Order By CODICE_CONTESTO';
      Open p_cursor For sqlstringa;
 EXCEPTION
      When OTHERS Then
           Open p_cursor For 'Select Null CODICE_CONTESTO, Null CONTESTO, Null CODICE, Null DESCRIZIONE, Null SEDE_TECNICA From Dual';
 END GetSOLGeographicContest;
--
-- --------------------------------------------------------------------------------------
--                     Procedure GetOPGeographicContest
-- --------------------------------------------------------------------------------------
--
 Procedure GetOPGeographicContest (p_op Varchar2, p_area Number,p_i_versione Number,p_cursor Out empcur) IS
      sqlstringa Varchar2(5000);
      s_schema Varchar2(100);
      p_versione Number;
   BEGIN
--
      If p_area Is Not Null Then
           s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
      End If;
--     
      p_versione := p_i_versione;                                                -->aggiunto il 16/04
      If (p_area = 2 Or p_area = 4) And p_versione Is Null Then
           p_versione:=PKG_RINF_DATA_V777.GetLastVersion(p_area);
      End If;
      sqlstringa := 'Select CODICE_CONTESTO, CONTESTO, CODICE, Case CODICE_CONTESTO When 10 Then Null Else DESCRIZIONE End DESCRIZIONE, SEDE_TECNICA  From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO Where SEDE_TECNICA = '''||p_op||'''';
      If p_versione Is Not NulL Then
           sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
      End If;
      sqlstringa := sqlstringa||' Order By CODICE_CONTESTO';
--
      Open p_cursor For sqlstringa;
 EXCEPTION
      When OTHERS Then
           Open p_cursor For 'Select Null CODICE_CONTESTO, Null CONTESTO, Null CODICE, Null DESCRIZIONE,Null SEDE_TECNICA From Dual';
 END GetOPGeographicContest;
-- 
-- -----------------------------------------------------------------------------
--                     Function GetParameterID
-- -----------------------------------------------------------------------------
--
 Function GetParameterID (cod_parametro Varchar2) Return  Number Is
      id_parametro Number;
   BEGIN
      Select Min(CODICE_PARAMETRO) Into id_parametro 
	    From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
       Where NUMERO_PARAMETRO_MULTIPLO = cod_parametro;
      Return id_parametro;
 END GetParameterID;
-- 
-- -----------------------------------------------------------------------------
--                     Procedure GetAnagDTP 
-- -----------------------------------------------------------------------------
--
 Procedure GetAnagDTP (p_cursor Out empcur) Is
    BEGIN
      Open p_cursor For
         Select CODICE_DTP, DESCRIZIONE DESCRIZIONE_DTP
           From Rinf_Anagrafiche_Evo.ANAG_DTP
           Where CODICE_DTP<>'-1';
 END GetAnagDTP;
--
-- --------------------------------------------------------------------------------------
--                        Procedure GetAnagUT
-- --------------------------------------------------------------------------------------
--
 Procedure GetAnagUT (p_cursor Out empcur) Is
   BEGIN
      Open p_cursor For
         Select CODICE_UT, DESCRIZIONE DESCRIZIONE_UT
           From Rinf_Anagrafiche_Evo.ANAG_UT
          Where CODICE_UT <> '-1';
 END GetAnagUT;
--
-- --------------------------------------------------------------------------------------
--                        Procedure GetAnagSC
--      11/01/2017 creata per gestire le sedi centrali multiple
-- --------------------------------------------------------------------------------------
--
 Procedure GetAnagSC (p_cursor Out empcur) Is
   BEGIN
      Open p_cursor For
         Select CODICE_TIPO_DEPOSITARIO, SIGLA_TIPO_DEPOSITARIO
           From RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO
          Where AREA='SC';
 END GetAnagSC;
--
-- --------------------------------------------------------------------------------------
--                   Procedure GetParametersList
-- --------------------------------------------------------------------------------------
--
 Procedure GetParametersList (p_cursor Out empcur) Is
   BEGIN
      Open p_cursor For
         Select c.CODICE_PARAMETRO,
--              c.NUMERO_PARAMETRO,
                c.NUMERO_PARAMETRO_MULTIPLO NUMERO_PARAMETRO,
                TIPO_DATO FORMATO,
                Nvl(CODICE_TIPO_DOMINIO, -1) CODICE_TIPO_DOMINIO,
                CODICE_VISTA,
                C.TIPO_PARAMETRO TIPO,
                C.CODICE_TIPO_DEPOSITARIO CODICE_RESPONSABILE,
                Decode(c.OBBLIGATORIO, 1, -1, c.NYA) IS_NYA
            From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI c,
                 (Select distinct CODICE_PARAMETRO, CODICE_TIPO_DOMINIO
                    From Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO
                    Where CODICE_TIPO_DOMINIO < >2 
				  ) d
           Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO (+)
             And Instr(NUMERO_PARAMETRO_MULTIPLO, 'D') <> 13
             And Instr(NUMERO_PARAMETRO_MULTIPLO, 'AP') = 0 ;
 END GetParametersList;
--
-- --------------------------------------------------------------------------------------
--                     Procedure GetValueList 
-- --------------------------------------------------------------------------------------
--
 Procedure GetValueList (p_codice_parametro Number, p_cursor Out empcur) Is
   BEGIN
      Open p_cursor For
           Select CODICE_PARAMETRO, VALORE, CODIFICA_VALORE, BLOCCATO, VALORE_XML, OPTIONAL_VALUE
             From Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO
            Where CODICE_PARAMETRO = p_codice_parametro
              And CODICE_TIPO_DOMINIO = 0     --13/06/2016 aggiunto da Alessio per estrarre solo i valori di tipo lista valori (0) in quanto per alcuni parametri con lista valori (0) e applicabilità gestita tramite NA (2) si creerebbero dei problemi (es.par.1.1.1.1.6.1 e 1.1.1.3.7.11)
            Order By CODIFICA_VALORE;
 END GetValueList;
--
-- --------------------------------------------------------------------------------------
--              Procedure GetRange
-- --------------------------------------------------------------------------------------
--
 Procedure GetRange (p_codice_parametro Number, p_cursor Out empcur) Is
   BEGIN
      Open p_cursor For
--Select  CODICE_PARAMETRO ID_PARAMETRO, Min(TO_Number(VALORE)) Min, Max(TO_Number(VALORE)) Max         --24/05/2016 modifica di Alessio: nell'aggiungere un range numerico CON VIRGOLA mi sono accorto che anadava in errore con i valori con la virgola, quindi vanno formattati
           Select CODICE_PARAMETRO ID_PARAMETRO, 
		          TO_Number(REPLACE(To_Char(Min(TO_Number (replace(valore,',','.')))),',','.')) Min, 
		          TO_Number(REPLACE(To_Char(Max(TO_Number (replace(valore,',','.')))),',','.')) Max
             From Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO
            Where CODICE_PARAMETRO = p_codice_parametro
              And CODICE_TIPO_DOMINIO = 1     --24/05/2016 modifica di Alessio: ho aggiunto un range numerico ad un parametro con anche NA =99.9; si impalla se non si specifica tipo_dominio = 1 (cioè range) perchè altrimenti quando fa il Max e Min legge pure 99.9 = NA
            Group By CODICE_PARAMETRO;

 END GetRange;
--
-- --------------------------------------------------------------------------------------
--              Procedure GetAnagViste
-- --------------------------------------------------------------------------------------
--
 Procedure GetAnagViste (p_cursor Out empcur) Is
   BEGIN
      Open p_cursor For
           Select CODICE_VISTA,
                  SIGLA_VISTA,
                  DESCRIZIONE
             From Rinf_Anagrafiche_Evo.VISTE_PARAMETRI;
 END GetAnagViste;
--
-- --------------------------------------------------------------------------------------
--                 Procedure GetAnagTipoDoMinio
-- --------------------------------------------------------------------------------------
--
 Procedure GetAnagTipoDominio (p_cursor Out empcur) Is
   BEGIN
      Open p_cursor For
           Select CODICE_TIPO_DOMINIO,
                  Replace(Initcap(DEFINIZIONE), ' ', '') as VOCE_UNICA
             From Rinf_Anagrafiche_Evo.ANAG_TIPO_DOMINIO
            Where CODICE_TIPO_DOMINIO <> 2;
 END GetAnagTipoDominio;
--
-- --------------------------------------------------------------------------------------
--                        Procedure SetParameterValue
-- --------------------------------------------------------------------------------------
--
 Procedure SetParameterValue (p_codice_parametro Number, p_codice_tipo_depositario Number, p_nya Number, p_error Out Number) Is
   BEGIN
      p_error := 0;
      Update Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
         Set CODICE_TIPO_DEPOSITARIO = p_codice_tipo_depositario,
             NYA = p_nya
       Where CODICE_PARAMETRO = p_codice_parametro;
 EXCEPTION
      When OTHERS Then
           p_error := SQLCODE;
 END SetParameterValue;
--
-- --------------------------------------------------------------------------------------
--                    Function SetNumericValue
-- --------------------------------------------------------------------------------------
--
 Function SetNumericValue (p_codice_parametro Number, p_valore Varchar2)
   Return Varchar2 Is
        tipo_parametro   Number;
   BEGIN
        Select TIPO_DATO
          Into tipo_parametro
          From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
         Where CODICE_PARAMETRO = p_codice_parametro;
--
        If tipo_parametro In (1, 2) Then
           Return Replace (p_valore, ',', '.');
        Else
           Return p_valore;
        End If;
 EXCEPTION
   When OTHERS Then
      Return To_Char(SQLCODE);
 END SetNumericValue;
--
-- --------------------------------------------------------------------------------------
--                        Procedure SetParameterList
-- --------------------------------------------------------------------------------------
--
 Procedure SetParameterList (p_codice_parametro       Number,
                             p_lista                  Varchar2,
                             p_error              Out Number)   Is
   TYPE l_value IS TABLE OF Varchar2 (500);
   a_value             l_value;
--
   n_conta             Number;
   s_lista_codici      Varchar2 (1000);
   s_valore            Varchar2 (200);
   s_codifica_valore   Varchar2 (200);
   s_valore_xml        Varchar2 (200);
  BEGIN
      p_error := 0;
--    DELETE From Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO
--    Where CODICE_PARAMETRO = p_codice_parametro;
      s_lista_codici := '(';
--
      WITH test AS (Select p_lista str From DUAL)
       Select REGEXP_SUBSTR (str, '[^;]+',  1,  ROWNUM)  split
         Bulk Collect Into a_value
         From test
      Connect By Level <= Length (REGEXP_REPLACE (str, '[^;]+')) + 1;


      For j In 1 .. a_value.Count 
        Loop
--  creo la stringa con la lsta dei codici validi, per eliminare quelli non più presenti
           s_codifica_valore := SetNumericValue (p_codice_parametro, REGEXP_SUBSTR (a_value(j), '(^|#)([^#]*)', 1, 1,  Null, 2) );
           s_lista_codici := s_lista_codici || '''' || s_codifica_valore || ''', ';
--
           Select Count(*)
             Into n_conta
             From Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO
            Where CODICE_PARAMETRO = p_codice_parametro
              And CODIFICA_VALORE = s_codifica_valore;
--	        
           s_valore := SetNumericValue (p_codice_parametro, REGEXP_SUBSTR (a_value(j), '(^|#)([^#]*)', 1, 2, Null, 2) );
           s_valore_xml := SetNumericValue (p_codice_parametro, REGEXP_SUBSTR (a_value(j), '(^|#)([^#]*)', 1, 4, Null, 2));

           If n_conta = 0 Then

                Insert Into Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO 
				           (CODICE_PARAMETRO,
                            CODICE_LINGUA,
                            CODICE_TIPO_DOMinIO,
                            VALORE,
                            CODIFICA_VALORE,
                            BLOCCATO,
                            VALORE_XML,
                            OPTIONAL_VALUE)
                    Values (p_codice_parametro,
                            1,
                            0,
                            s_valore,
                            s_codifica_valore,
                            REGEXP_SUBSTR (a_value(j), '(^|#)([^#]*)', 1, 3, Null, 2),
                            s_valore_xml,
                            REGEXP_SUBSTR (a_value(j), '(^|#)([^#]*)', 1, 5, Null, 2) 
							);
           Else                   

                Update Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO
                   Set VALORE = s_valore,
                       VALORE_XML = s_valore_xml,
                       OPTIONAL_VALUE = REGEXP_SUBSTR (a_value(j), '(^|#)([^#]*)', 1, 5, Null, 2)
                 Where CODICE_PARAMETRO = p_codice_parametro 
				   And CODIFICA_VALORE = s_codifica_valore;
           End If;
        End Loop;

-- Eliminazione codici non più presenti: tolgo dalla stringa l'ultima virgola
        s_lista_codici := Substr(s_lista_codici, 1, Length(s_lista_codici) -2)||')';


        s_lista_codici := 'Delete From Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO Where CODICE_PARAMETRO = '||
                           p_codice_parametro||'  And CODICE_TIPO_DOMINIO = 0 And CODIFICA_VALORE Not In '||s_lista_codici; 
-- 13/06/2016 aggiunto And CODICE_TIPO_DOMINIO = 0 da Alessio per cancellare solo i valori di tipo lista valori (0) 
-- in quanto per alcuni parametri con lista valori (0) e applicabilità gestita tramite NA (2) si creerebbero dei problemi (es.par.1.1.1.1.6.1 e 1.1.1.3.7.11)

        Execute Immediate s_lista_codici;
--
 EXCEPTION 
      When OTHERS Then
           p_error := SQLCODE;
 END SetParameterList;
--
-- --------------------------------------------------------------------------------------
--                          Procedure SetParameterRange
-- --------------------------------------------------------------------------------------
--
 Procedure SetParameterRange (p_codice_parametro Number, p_valore_Minimo Number, p_valore_massimo Number, p_error Out Number) Is
   BEGIN
      p_error := 0;
      Delete From Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO
            Where CODICE_PARAMETRO = p_codice_parametro
              And CODICE_TIPO_DOMINIO = 1;  
-- 24/05/2016 modifica di Alessio: ho aggiunto un range numerico ad un parametro con anche NA =99.9 (cioè tipo_doMinio=2); 
-- se non si specifica tipo_doMinio = 1 (cioè range) cancella pure 99.9 = NA
      Insert Into Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO
                 (CODICE_PARAMETRO, 
				  CODICE_LINGUA, 
				  CODICE_TIPO_DOMINIO, 
				  VALORE, 
				  CODIFICA_VALORE)
          Values (p_codice_parametro,
		          1,
			      1,
			      p_valore_Minimo,
			      p_valore_Minimo);
--
      Insert Into Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO
                 (CODICE_PARAMETRO, 
				  CODICE_LINGUA, 
				  CODICE_TIPO_DOMINIO, 
				  VALORE,
				  CODIFICA_VALORE)
          Values (p_codice_parametro,
		          1,
				  1,
				  p_valore_massimo,
				  p_valore_massimo);

 EXCEPTION
      When OTHERS Then
           p_error := SQLCODE;
 END SetParameterRange;
--
-- --------------------------------------------------------------------------------------
--               Procedure GetControlSet
-- --------------------------------------------------------------------------------------
--
 Procedure GetControlSet (p_cursor Out empcur) Is
   BEGIN
      Open p_cursor For
          Select CODICE_CONTROLLO, SIGLA_CONTROLLO, DEFINIZIONE_CONTROLLO, FLAG_ABILITATO
            From Rinf_Anagrafiche_Evo.GESTIONE_CONTROLLI;

 END GetControlSet;
--
-- --------------------------------------------------------------------------------------
--    Procedure SetControlSet
-- --------------------------------------------------------------------------------------
--
 Procedure SetControlSet (p_lista Varchar2, p_error Out Number) Is
      Type l_value Is Table Of Varchar2(500);
           a_value l_value;
--		
      s_lista_codici Varchar2(1000);
   BEGIN
      p_error := 0;
      With test As (Select p_lista str From Dual)
          Select REGEXP_SUBSTR (str, '[^;]+', 1, Rownum)  split
             Bulk Collect Into a_value
             From test
          Connect By Level <= Length (REGEXP_REPLACE (str, '[^;]+')) + 1;
--
       For j In 1..a_value.Count
         Loop
             Update Rinf_Anagrafiche_Evo.GESTIONE_CONTROLLI
                Set FLAG_ABILITATO = REGEXP_SUBSTR(a_value(j),'[^#]+', 1, 2, 'i')
              Where CODICE_CONTROLLO = REGEXP_SUBSTR(a_value(j),'[^#]+', 1, 1, 'i');
          End Loop;
 EXCEPTION
      When OTHERS Then
           p_error := SQLCODE;
END SetControlSet;

--
-- --------------------------------------------------------------------------------------
--                       Procedure GetcatalogoParametri 
--  INPUT:  P_Numero_Parametro Varchar2(50):='1.2.2.0.6.1'; oppure  Null (Tutto l'elenco)
-- --------------------------------------------------------------------------------------
--
 Procedure GetcatalogoParametri (P_Numero_Parametro Varchar2, p_cursor Out sys_refcursor) Is
      sqlstringa Varchar2(10000);
  BEGIN
      sqlstringa := 'Select NUMERO_PARAMETRO, DESCRIZIONE,  XML_NAME, DATA_INIZIO_VALIDITA, DATA_FINE_VALIDITA, FLAG_ATTIVO ';
--     codice_parametro, 
--     numero_parametro_multiplo, 
--     tipo_parametro, 
--     codice_vista, 
--     codice_tipo_depositario, 
--     applicabilita, 
--     nya, 
--     tipo_dato, 
--     obbligatorio,
--     fondamentale, 
--     necessario_compatibilita NCT, 
      sqlstringa := sqlstringa || 'From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI ';
      sqlstringa := sqlstringa || 'Where NUMERO_PARAMETRO_MULTIPLO Not Like ''%AP'' ';
--
      If (Length(P_Numero_Parametro) > 6 
          And Substr(P_Numero_Parametro, 2, 1) = '.' 
	      And Substr(P_Numero_Parametro, 4, 1) = '.' 
	      And Substr(P_Numero_Parametro, 6, 1) = '.' ) Then

          sqlstringa := sqlstringa || 'And NUMERO_PARAMETRO_MULTIPLO = '''||P_Numero_Parametro ||'''';
       End If;
--
      sqlstringa := sqlstringa || ' And XML_NAME Is Not Null';
      sqlstringa := sqlstringa || ' And OBBLIGATORIO = 0';
      sqlstringa := sqlstringa || ' Order By NUMERO_PARAMETRO';
--      
      Open p_cursor For sqlstringa;
--      Dbms_Output.Put_Line(sqlstringa);
--
  END GetCatalogoParametri;
-- --------------------------------------------------------------------------------------
--                       Procedure SetCatalogoParametri 
-- --------------------------------------------------------------------------------------
-- 
  Procedure SetCatalogoParametri (P_Parametri_Flag Varchar2, p_error Out Number) Is
    v_parametro varchar2(20);
	v_flag varchar2(1);
	appo varchar2(40);
	indi number;
	indf number;
	indm number;
	idx number;
	str_len number;
  BEGIN
    p_error := 0;
	str_len := Length (P_Parametri_Flag);
	idx := 1;
	indi := 1;
--	dbms_output.put_line ('Lunghezza stringa: '||str_len);
    If str_len > 0 Then	 
	  indf := Instr(P_Parametri_Flag, ';', idx);
--	  dbms_output.put_line ('Lunghezza sottostringa: '||indf);

	  While indf > 0 And indf <= str_len Loop
--	  	  dbms_output.put_line ('Entrato nel loop');
	          appo := Substr(P_Parametri_flag, indi, indf - indi);
--	  	  dbms_output.put_line ('appo: '||appo);
              indm := Instr(appo, '|', 1, 1);
--	  	  dbms_output.put_line ('indm: '||indm);

	          v_parametro := Substr(appo, 1, indm - 1);
			  v_flag := Substr(appo, indm +1, 1);
--		      dbms_output.put_line ('Parametro: '|| v_parametro);      
--		      dbms_output.put_line ('Flag     : '|| v_flag);     

	          If (Length(v_Parametro) > 6 
                And Substr(v_Parametro, 2, 1) = '.' 
	            And Substr(v_Parametro, 4, 1) = '.' 
	            And Substr(v_Parametro, 6, 1) = '.' ) Then

	               If v_Flag = '0' Or v_Flag = '1' Then
--		               dbms_output.put_line ('Parametro: '|| v_Parametro||' - Flag: '||v_Flag);
                       Update Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
                          Set FLAG_ATTIVO = v_Flag
                        Where NUMERO_PARAMETRO = v_Parametro;
                   Else 
                        p_error := 1;
                   End If;
               Else 
                   p_error := 1;
               End If;
          	  idx := idx + 1;
			  indi := indf + 1;
              indf := Instr(P_Parametri_flag, ';', 1, idx);
--  	  dbms_output.put_line ('ciclo: '||idx);
--  	  dbms_output.put_line ('indi: '||indi);
-- 	      dbms_output.put_line ('indf: '||indf);
      End Loop;
      Commit;
 --
    Else 
       p_error := 1;
    End If;
--
  EXCEPTION
      When  OTHERS Then
      p_error := SQLCODE;
	  dbms_output.put_line ('SetCatalogoParametri - Errore: '|| Substr(Sqlerrm, 1, 250));
	  Rollback;
  END SetCatalogoParametri;
-- --------------------------------------------------------------------------------------
--                       Procedure SetDataValidita_Parametro
-- --------------------------------------------------------------------------------------
-- 
  Procedure SetDataValidita_Parametro (P_Numero_Parametro Varchar2, p_data_inizio Date, p_data_fine Date, p_error Out Number) Is 
      appo_data_inizio Date;
	  appo_data_fine   Date;
      v_data_inizio    Date;
      v_data_fine      Date;
  	  appo_codice_parametro Number;


  BEGIN
    p_error := 0;
--
    If p_data_inizio Is Not Null Then
	     v_data_inizio := To_Date(To_Char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy');
	End If;
--
    If p_data_fine Is Not Null Then
	     v_data_fine := To_Date(To_Char(p_data_fine,'dd/mm/yyyy'),'dd/mm/yyyy');
	End If;
--
    If   (Length(P_Numero_Parametro) > 6 
      And Substr(P_Numero_Parametro, 2, 1) = '.' 
	  And Substr(P_Numero_Parametro, 4, 1) = '.' 
	  And Substr(P_Numero_Parametro, 6, 1) = '.' ) Then
 -- 
      Begin 
        Select Distinct CODICE_PARAMETRO, DATA_INIZIO_VALIDITA, DATA_FINE_VALIDITA
		           Into appo_codice_parametro, appo_data_inizio, appo_data_fine
		  From Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI 
	 	 Where NUMERO_PARAMETRO = P_Numero_Parametro
		   And XML_NAME Is Not Null;
      Exception 
	    When NO_DATA_FOUND Then 
--		   dbms_output.put_line ('Parametro non trovato nel Catalogo');
		   p_error := 1;	   
	  End;	

           If (p_data_inizio Is Not Null And v_data_inizio <> appo_data_inizio ) Then
                Update Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
                   Set DATA_INIZIO_VALIDITA = v_data_inizio
--                 Where NUMERO_PARAMETRO = P_Numero_Parametro;
                Where CODICE_PARAMETRO = appo_codice_parametro;

--				 dbms_output.put_line ('Aggiornata la data inizio: '||p_data_inizio);
            End If;
--
            If (p_data_fine Is Not Null And v_data_fine <> appo_data_fine ) Then
                Update Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI
                   Set DATA_FINE_VALIDITA = v_data_fine
--                 Where NUMERO_PARAMETRO = P_Numero_Parametro;
                Where CODICE_PARAMETRO = appo_codice_parametro;

--				 dbms_output.put_line ('Aggiornata la data fine: '||p_data_fine);

            End If;
--
			Commit;
--
    Else 
       p_error := 1;	    
	End If;

  EXCEPTION
      When  OTHERS Then
      p_error := 1; --SQLCODE;
--	  dbms_output.put_line ('SetDataValidita_Parametro - Errore: '|| Substr(Sqlerrm, 1, 250));
	  Rollback;
  END SetDataValidita_Parametro;  
--
END PKG_RINF_INTERFACCIA;
/