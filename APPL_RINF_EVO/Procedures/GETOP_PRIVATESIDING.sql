--
-- GETOP_PRIVATESIDING  (Procedure) 
--
CREATE OR REPLACE PROCEDURE APPL_RINF_EVO.GetOP_PrivateSiding (p_OP VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT sys_refcursor) IS
--Ritorna i parametri principali di un Raccordo
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
BEGIN

sqlstringa :=  'SELECT     PO_1_2_0_0_0_2 PO_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 'PO_1_2_0_0_0_1_DEFINIZIONE PO_1_2_0_0_0_1, ';
sqlstringa := sqlstringa || 'PO_1_2_0_0_0_2, ';
sqlstringa := sqlstringa || 'NVL(PO_1_2_0_0_0_3,''N'') PO_1_2_0_0_0_3_AP, ';
sqlstringa := sqlstringa || 'PO_1_2_0_0_0_3, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.0.0.0.4'',LOWER(PO_1_2_0_0_0_4)) PO_1_2_0_0_0_4_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.0.0.0.4'',LOWER(PO_1_2_0_0_0_4)) PO_1_2_0_0_0_4_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.0.0.0.4'',LOWER(PO_1_2_0_0_0_4)) PO_1_2_0_0_0_4_DES,';
sqlstringa := sqlstringa || ' LOWER(PO_1_2_0_0_0_4) PO_1_2_0_0_0_4, ';
sqlstringa := sqlstringa || '''Latitude (''|| TRIM(TO_CHAR(TRUNC(PO_1_2_0_0_0_5_LATITUDINE,4),''999.9999''))|| '') + Longitude (''|| TRIM(TO_CHAR(TRUNC(PO_1_2_0_0_0_5_LONGITUDINE,4),''S999.9999''))|| '')'' PO_1_2_0_0_0_5, ';
sqlstringa := sqlstringa || 'NVL(TRIM(PO_1_2_0_0_0_6_LINEA||'' - ''||PO_1_2_0_0_0_6_KM),''0000 - 0.000'') PO_1_2_0_0_0_6, ';
sqlstringa := sqlstringa || 'NULL CACHE_FIELD ';
sqlstringa := sqlstringa || 'from RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI l ';
IF p_OP is not null THEN
sqlstringa := sqlstringa || ' where PO_1_2_0_0_0_2='''||p_OP||'''';
END IF;
sqlstringa := sqlstringa || 'order by 1 ';
OPEN p_cursor FOR sqlstringa;
DBMS_OUTPUT.PUT_LINE(sqlstringa);
END GetOP_PrivateSiding;
/
