--
-- GETPAR_ATTIVO  (Function) 
--
CREATE OR REPLACE FUNCTION APPL_RINF_EVO."GETPAR_ATTIVO" (P_Parametro Varchar2)    
  Return Varchar2
   Is
      n_value   Varchar2(1);
   BEGIN
      n_value := '0';

      Select '1'
        Into n_value
        From RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
       Where  NUMERO_PARAMETRO_MULTIPLO = P_Parametro
	   and FLAG_ATTIVO = '1';
--	   
      Return n_value;
--
      Exception
         When NO_DATA_FOUND Then
             Return '0';
         When OTHERS Then
             Return '0';
 End GetPar_attivo;


/
