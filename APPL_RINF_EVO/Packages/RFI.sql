--
-- RFI  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."RFI" As
 FUNCTION GetNYA (p_parametro Varchar2) RETURN Varchar2;
 FUNCTION GetXmlValue(p_parametro IN Varchar2, p_valore IN Varchar2) RETURN Varchar2;
 FUNCTION GetOpValue(p_parametro IN Varchar2, p_valore IN Varchar2) RETURN Varchar2;
 FUNCTION GetDescr(p_parametro IN Varchar2, p_valore IN Varchar2) RETURN Varchar2;
 FUNCTION GetSet(p_parametro IN Varchar2, p_valore IN Varchar2, p_appl_padre IN Varchar2) RETURN Varchar2;
 Function GetLastVersion (p_area Number) Return Number;
END RFI;
/


--
-- RFI  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."RFI" As
-----------------------------------------------------------------------------------------
--               FUNCTION GetPar_attivo - 
-- aggiunta per il Reg.777/2019
-- Restituisce se il parametro è rilasciato per la pubblicazione (Y) o meno (N)
-----------------------------------------------------------------------------------------

 Function GetPar_attivo (P_Parametro Varchar2)    
   Return Varchar2  Is
      n_value   Varchar2(1);
   BEGIN
      n_value := 'N';

      Select 'Y'
        Into n_value
        From RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
       Where NUMERO_PARAMETRO_MULTIPLO = P_Parametro
	   and FLAG_ATTIVO = '1';
--	   
      Return n_value;
--
   Exception
         When NO_DATA_FOUND Then
             Return 'N';
         When OTHERS Then
             Return 'N';

 End GetPar_attivo;
-----------------------------------------------------------------------------------------
--                         Get_data_validita
-- aggiunta per il Reg.777/2019 gestiste la data di inzio e la data di fine validità dei parametri
-- restituisce se il parametro è attivo (1) o no (0) alla data di riferimento indicata
-----------------------------------------------------------------------------------------
 Function GetData_validita (P_Parametro Varchar2, P_Data_Riferimento date)    
   Return Varchar2  Is
      n_value   Varchar2(1);
   BEGIN
      n_value := '0';

      Select '1'
        Into n_value
        From RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
       Where  NUMERO_PARAMETRO_MULTIPLO = P_Parametro
	   and p_data_riferimento between data_inizio_validita and data_fine_validita;
--	   
      Return n_value;
--
      Exception
         When NO_DATA_FOUND Then
             Return '0';
         When OTHERS Then
             Return '0';

 End GetData_validita;
-----------------------------------------------------------
--                         GetNYA
-- dice che il parametro è NYA (1) o no (0, ovvero OBBLIGATORIO)
------------------------------------------------------------
 Function GetNYA (P_Parametro Varchar2)    
   Return Varchar2 Is
      n_value   Varchar2(3);
   BEGIN
      Select Decode(NYA, 1, 'NYA', 'H')
        Into n_value
        From RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
       Where NUMERO_PARAMETRO_MULTIPLO = P_Parametro;
--	   
      Return n_value;
 Exception
         When NO_DATA_FOUND Then
             Return 'H';
 End GetNYA;

-- -----------------------------------------------------------------------------
--                        GetXmlValue
-- -----------------------------------------------------------------------------
 Function GetXmlValue (P_Parametro In Varchar2, P_Valore In Varchar2) 
   Return Varchar2 Is
  xml_value Varchar2(1000);
--
 BEGIN
   Select VALORE_XML Into xml_value
     From RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,
          RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c
    Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO 
      And c.NUMERO_PARAMETRO_MULTIPLO = p_parametro 
	  And d.CODIFICA_VALORE = p_valore;
--	
    If xml_value Is Null  Then
        xml_value := p_valore;
    End If;
--	
   Return xml_value;
 Exception
     When NO_DATA_FOUND Then
          Return p_valore;
     When Others Then
       -- Consider logging the error and then re-raise
          Return p_valore;
 END GetXmlValue;

-- -----------------------------------------------------------------------------
--                 GetOpValue
-- -----------------------------------------------------------------------------
 Function GetOpValue (p_parametro In Varchar2, p_valore In Varchar2) 
   Return Varchar2 Is
--
 op_value Varchar2(1000);
-- 
 BEGIN
   Select OPTIONAL_VALUE Into op_value
     From RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,
          RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c
    Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO 
      And c.NUMERO_PARAMETRO_MULTIPLO = p_parametro 
	  And d.CODIFICA_VALORE = p_valore;
--		  
   Return op_value;
 Exception
     When NO_DATA_FOUND Then
         Return Null;
     When Others Then
       -- Consider logging the error and then re-raise
         Return Null;
 END GetOpValue;

-- -----------------------------------------------------------------------------
--                        GetDescr
-------------------------------------------------------------------------
 Function GetDescr (p_parametro In Varchar2, p_valore In Varchar2) 
   Return Varchar2 Is
--
  des_value Varchar2(1000);
-- 
 BEGIN
   Select VALORE Into des_value
     From Rinf_Anagrafiche_Evo.DOMINIO_PARAMETRO d,
          Rinf_Anagrafiche_Evo.CATALOGO_PARAMETRI c
    Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO 
      And c.NUMERO_PARAMETRO_MULTIPLO = p_parametro 
	  And d.CODIFICA_VALORE = p_valore;
--		
   Return des_value;
--   
 Exception
     When NO_DATA_FOUND Then
         Return Null;
     When Others Then
       -- Consider logging the error and then re-raise
         Return Null;
 END GetDescr;

-- -----------------------------------------------------------------------------
--                          GetSet
-- -----------------------------------------------------------------------------
 Function GetSet (p_parametro In Varchar2, p_valore In Varchar2, p_appl_padre In Varchar2) 
   Return Varchar2 Is
--
  set_value Varchar2(1000);
-- 
 BEGIN
    If p_appl_padre = 'NYA' Then
         set_value := 'NYA';
---> aggiunto con mail del 11/11/2021 di V. Autiero
    Elsif p_appl_padre = 'N' and p_valore Is Null Then
--         set_value := 'NYA';
         set_value := Null;
--->
    Else
       Select Nvl(OPTIONAL_VALUE, VALORE_XML) Into set_value
       From RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,
            RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c
      Where c.CODICE_PARAMETRO = d.CODICE_PARAMETRO 
        And c.NUMERO_PARAMETRO_MULTIPLO = p_parametro 
	    And d.CODIFICA_VALORE = p_valore;
--
        If set_value Is Null Then      --se non ho SET allora metti NYA (richiesta di Autiero, non ci sono indicazioni a riguardo da parte dell'ERA, per ora)
             set_value := 'NYA';
        End If;
    End If;
--
   Return set_value;

   Exception
     When NO_DATA_FOUND Then
          Return 'NYA';
     When Others Then
       -- Consider logging the error and then re-raise
          Return Null;
 END GetSet;

-- -----------------------------------------------------------------------------
--                      GetLastVersion
-- -----------------------------------------------------------------------------
 Function GetLastVersion (p_area Number) Return Number Is
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
--
   If n_versione Is Null Then -- Se non esistono dati nell'area selezionata
      n_versione := -1;
   End If;
-- 
   Return n_versione;
-- 
 END GetLastVersion;

END RFI;
/