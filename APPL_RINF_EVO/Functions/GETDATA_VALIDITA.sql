--
-- GETDATA_VALIDITA  (Function) 
--
CREATE OR REPLACE FUNCTION APPL_RINF_EVO."GETDATA_VALIDITA" (P_Parametro Varchar2, P_Data_Riferimento date)    
  Return Varchar2
   Is
      n_value   VARCHAR2(3);
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
         When Others Then
             Return '0';

 End GetData_validita;


/
