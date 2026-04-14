--
-- PKG_RINF_DATA_V082  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_DATA_V082" AS
/******************************************************************************
   NAME:       PKG_RINF_DATA
   PURPOSE: Insieme di procedure per la visualizzazione dei dati RINF

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/09/2013     D.Campagiorni        1. Created this package.
   1.1        30/11/2018                          2. Modifica con l'aggiunta LAM
******************************************************************************/

TYPE empcur IS REF CURSOR;

-- SOL
PROCEDURE GetSOL_General (p_SOL VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur);
PROCEDURE GetTracks_General (p_SOL VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur);

PROCEDURE GetTracks_Inf_EC (p_Track VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur);
PROCEDURE GetTracks_Energy_EC (p_Track VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur);
PROCEDURE GetTracks_Control_EC (p_Track VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur);

PROCEDURE GetTracks_Inf_Tunnel (p_Track VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur);
PROCEDURE GetTracks_Inf_Tunnel_EC (p_Tunnel VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur) ;
--
--PROCEDURE GetTracks_Infrastructure (p_Track VARCHAR2,p_cursor OUT empcur) ;
--PROCEDURE GetTracks_Inf_LoadCapability (p_Track VARCHAR2,p_cursor OUT empcur);
--PROCEDURE GetTracks_Energy (p_Track VARCHAR2,p_cursor OUT empcur);

--PROCEDURE GetTracks_En_Pantograph (p_Track VARCHAR2,p_cursor OUT empcur);
--PROCEDURE GetTracks_Energy_ContactForce (p_Track VARCHAR2,p_cursor OUT empcur);
--PROCEDURE GetTracks_Control (p_Track VARCHAR2,p_cursor OUT empcur);
--
--PROCEDURE GetTracks_Control_GSMR (p_Track VARCHAR2,p_cursor OUT empcur);
--PROCEDURE GetTracks_Control_Opt_GSMR (p_Track VARCHAR2,p_cursor OUT empcur);
--PROCEDURE GetTracks_Control_OtherRadio (p_Track VARCHAR2,p_cursor OUT empcur);
--PROCEDURE GetTracks_Control_OtherDetect (p_Track VARCHAR2,p_cursor OUT empcur);
--PROCEDURE GetTracks_Control_Transitions (p_Track VARCHAR2,p_cursor OUT empcur);
--PROCEDURE GetTracks_Control_Electromagn (p_Track VARCHAR2,p_cursor OUT empcur);
--PROCEDURE GetTracks_Control_LineSide (p_Track VARCHAR2,p_cursor OUT empcur);
--PROCEDURE GetTracks_Control_BrakeParam (p_Track VARCHAR2,p_cursor OUT empcur);
--PROCEDURE GetTracks_Control_OtherParam (p_Track VARCHAR2,p_cursor OUT empcur);

--PO
PROCEDURE GetOP_General (p_OP VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur);
PROCEDURE GetOPTracks_Infrastructure (p_OP VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
PROCEDURE GetOPTracks_Inf_EC (p_POTrack VARCHAR2, p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
PROCEDURE GetOPTracks_Inf_Tunnel(p_POTrack VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
PROCEDURE GetOPTracks_Inf_Tunnel_EC(p_POTrack_Tunnel VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
--PROCEDURE GetOPTracks_Inf_Platform_EC(p_POTrack_Platform VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
PROCEDURE GetOPSiding_Infrastructure (p_PO VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
PROCEDURE GetOPSiding_Inf_EC (p_POSiding VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
PROCEDURE GetOPSiding_Inf_Tunnel (p_POSiding VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
PROCEDURE GetOPSiding_Inf_Tunnel_EC (p_POSiding_Tunnel VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
--PROCEDURE GetOPTracks_General (p_OP VARCHAR2,p_cursor OUT empcur);
--PROCEDURE GetOPSiding_General (p_OP VARCHAR2,p_cursor OUT empcur);
PROCEDURE GetAllVersions( p_cursor OUT empcur);
PROCEDURE GetLastVersion (p_area NUMBER,p_versione OUT NUMBER);
FUNCTION GetLastVersion(p_area NUMBER) RETURN NUMBER;
FUNCTION GetNYA (p_parametro VARCHAR2) RETURN VARCHAR2;
FUNCTION GetXmlValue(p_parametro IN VARCHAR2,p_valore IN VARCHAR2) RETURN VARCHAR2;
FUNCTION GetOptionalValue(p_parametro IN VARCHAR2,p_valore IN VARCHAR2) RETURN VARCHAR2;
FUNCTION GetDescription(p_parametro IN VARCHAR2,p_valore IN VARCHAR2) RETURN VARCHAR2;
FUNCTION GetSet(p_parametro IN VARCHAR2,p_valore IN VARCHAR2,p_appl_padre IN VARCHAR2) RETURN VARCHAR2;
--28/09/2016 Aggiunto il parametro della OP per gestire i marciapiedi delle fermate adiacenti
PROCEDURE GetOPTracks_Inf_Platform(p_PO VARCHAR2,p_POTrack VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
--22/06/2018 Raccordi
PROCEDURE GetOP_PrivateSiding (p_i_versione NUMBER ,p_cursor OUT sys_refcursor);
END PKG_RINF_DATA_V082;
/


--
-- PKG_RINF_DATA_V082  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_DATA_V082" AS
-----------------------------------------------------------
-------------- NEW
------------------------------------------------------------
   FUNCTION GetNYA (p_parametro VARCHAR2)    ---dice che il parametro è NYA (1) o no (0, ovvero OBBLIGATORIO)
      RETURN VARCHAR2
   IS
      n_value   VARCHAR2(3);
   BEGIN
      SELECT DECODE(NYA,1,'NYA','H')
        INTO n_value
        FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
       WHERE  NUMERO_PARAMETRO_MULTIPLO = p_parametro;
      RETURN n_value;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      RETURN 'H';
   END GetNYA;

-- -----------------------------------------------------------------------------
FUNCTION GetXmlValue(p_parametro IN VARCHAR2,p_valore IN VARCHAR2) RETURN VARCHAR2 IS
    xml_value VARCHAR2(300);
-- -----------------------------------------------------------------------------
BEGIN
   SELECT VALORE_XML INTO xml_value
   from RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,
    RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c
    where
    c.codice_parametro=d.codice_parametro and
    c.numero_parametro_multiplo=p_parametro and
    d.codifica_valore=p_valore;
    IF xml_value IS NULL  THEN
        xml_value:=p_valore;
    END IF;
   RETURN xml_value;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       RETURN p_valore;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RETURN p_valore;
END GetXmlValue;

-- -----------------------------------------------------------------------------
FUNCTION GetOptionalValue(p_parametro IN VARCHAR2,p_valore IN VARCHAR2) RETURN VARCHAR2 IS
op_value VARCHAR2(300);
-- -----------------------------------------------------------------------------
BEGIN
   SELECT OPTIONAL_VALUE INTO op_value
   from RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,
    RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c
    where
    c.codice_parametro=d.codice_parametro and
    c.numero_parametro_multiplo=p_parametro and
    d.codifica_valore=p_valore;
   RETURN op_value;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       RETURN NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RETURN NULL;
END GetOptionalValue;
-- -----------------------------------------------------------------------------
FUNCTION GetDescription(p_parametro IN VARCHAR2,p_valore IN VARCHAR2) RETURN VARCHAR2 IS
des_value VARCHAR2(300);
-- -----------------------------------------------------------------------------
BEGIN
   SELECT VALORE INTO des_value
   from RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,
    RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c
    where
    c.codice_parametro=d.codice_parametro and
    c.numero_parametro_multiplo=p_parametro and
    d.codifica_valore=p_valore;
   RETURN des_value;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       RETURN NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RETURN NULL;
END GetDescription;
-- -----------------------------------------------------------------------------
FUNCTION GetSet(p_parametro IN VARCHAR2,p_valore IN VARCHAR2,p_appl_padre IN VARCHAR2) RETURN VARCHAR2 IS
set_value VARCHAR2(300);
-- -----------------------------------------------------------------------------
BEGIN
    IF p_appl_padre='NYA' THEN
        set_value := 'NYA';
    ELSE
       SELECT NVL(OPTIONAL_VALUE,VALORE_XML) INTO set_value
       from RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,
        RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c
        where
        c.codice_parametro=d.codice_parametro and
        c.numero_parametro_multiplo=p_parametro and
        d.codifica_valore=p_valore;

        IF set_value is NULL                            --se non ho SET allora metti NYA (richiesta di Autiero, non ci sono indicazioni a riguardo da parte dell'ERA, per ora)
        THEN set_value := 'NYA';
        END IF;
    END IF;

   RETURN set_value;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       RETURN 'NYA';
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RETURN NULL;
END GetSet;

-- -----------------------------------------------------------------------------
FUNCTION GetLastVersion (p_area NUMBER) RETURN NUMBER IS
n_versione NUMBER;
-- -----------------------------------------------------------------------------
BEGIN
IF p_area=2 THEN
    Select MAX(CODICE_VERSIONE) into n_versione
    FROM RINF_PUBBLICATI_EVO.VERSIONE_RINF
    where
    PROTOCOLLO IS NOT NULL;
ELSE
    Select MAX(v.CODICE_VERSIONE) into n_versione
    FROM RINF_PUBBLICATI_EVO.VERSIONE_RINF v
    where
    PROTOCOLLO IS NULL;
END IF;

IF n_versione IS NULL THEN -- Se non esistono dati nell'area selezionata
n_versione:=-1;
END IF;
return n_versione;
END GetLastVersion;

-- -----------------------------------------------------------------------------
PROCEDURE GetLastVersion (p_area NUMBER,p_versione OUT NUMBER)  IS

BEGIN
p_versione:=0;
IF p_area=2 THEN --Pubblicati/Inviati
    Select MAX(CODICE_VERSIONE) into p_versione
    FROM RINF_PUBBLICATI_EVO.VERSIONE_RINF
    where
    PROTOCOLLO IS NOT NULL;
ELSIF p_area=4 THEN --Pronti
    Select MAX(v.CODICE_VERSIONE) into p_versione
    FROM RINF_PUBBLICATI_EVO.VERSIONE_RINF v
    where
    PROTOCOLLO IS NULL;
END IF;

IF p_versione IS NULL THEN -- Se non esistono dati nell'area selezionata
p_versione:=-1;
END IF;
END GetLastVersion;

-- -----------------------------------------------------------------------------
PROCEDURE GetAllVersions( p_cursor OUT empcur) IS
BEGIN
OPEN p_cursor FOR
Select v.CODICE_VERSIONE,DATA_PUBBLICAZIONE,DATA_TRASMISSIONE, PROTOCOLLO --28/09/2016 Aggiunto protocollo per la combo dell'archiviio storico
    FROM RINF_PUBBLICATI_EVO.VERSIONE_RINF v,
    (select CODICE_VERSIONE, DATA_TRASMISSIONE
    FROM RINF_PUBBLICATI_EVO.ANAGRAFICA_TRASMISSIONI
    where CODICE_TRASMISSIONE=1) t
    where
    V.CODICE_VERSIONE=t.CODICE_VERSIONE (+)
order by  DATA_PUBBLICAZIONE desc ;
END GetAllVersions;

-- -----------------------------------------------------------------------------
--                           --------- OP -------------
-- -----------------------------------------------------------------------------
PROCEDURE GetOP_General (p_OP VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur) IS
--Ritorna i parametri principali di una OP
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
sqlstringa :=  'SELECT     l.SEDE_TECNICA PO_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 'DEFINIZIONE PO_1_2_0_0_0_1, ';
sqlstringa := sqlstringa || 'PO_1_2_0_0_0_2, ';
--09/05/2016 Modificata la struttura della tabella PUNTI_OPERATIVI. Aggiunti i campi PO_1_2_0_0_0_2 e PO_1_2_0_0_0_3_AP ed eliminaot il campo PO_1_2_0_0_0_3
--E' stata creata la tabella PAR_1_2_0_0_0_3_TAF_TAP per gestire la molteplicità del parametro 1.2.0.0.0.3
sqlstringa := sqlstringa || 'PO_1_2_0_0_0_3_AP, ';
sqlstringa := sqlstringa || 'codice_taf_tap.codice PO_1_2_0_0_0_3, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.0.0.0.4'',PO_1_2_0_0_0_4) PO_1_2_0_0_0_4_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.0.0.0.4'',PO_1_2_0_0_0_4) PO_1_2_0_0_0_4_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.0.0.0.4'',PO_1_2_0_0_0_4) PO_1_2_0_0_0_4_DES,';
sqlstringa := sqlstringa || ' PO_1_2_0_0_0_4, ';
sqlstringa := sqlstringa || '''Latitude (''|| TRIM(TO_CHAR(TRUNC(LATITUDINE,4),''999.9999''))|| '') + Longitude (''|| TRIM(TO_CHAR(TRUNC(LONGITUDINE,4),''S999.9999''))|| '')'' PO_1_2_0_0_0_5, ';
sqlstringa := sqlstringa || 'NVL(TRIM(linea_comm.linea),''0000 - 0.000'') PO_1_2_0_0_0_6, ';
sqlstringa := sqlstringa || ' CACHE_FIELD ';
sqlstringa := sqlstringa || 'from '||s_schema||'.PUNTI_OPERATIVI l, ';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || '(SELECT v.SEDE_TECNICA, LISTAGG(REPLACE(CODICE,'' '','''')||'' - ''||TRIM(TO_CHAR(ROUND(KM_INIZIO,3),''999990.999'')) ,''#'' ) WITHIN GROUP (ORDER BY CODICE) AS linea ';
sqlstringa := sqlstringa || 'from '||s_schema||'.V_MDR_LINEE_COMMERCIALI v ';
sqlstringa := sqlstringa || ' where  ';
sqlstringa := sqlstringa || ' v.CODICE_VERSIONE='||p_versione ;
sqlstringa := sqlstringa || ' GROUP BY v.SEDE_TECNICA) linea_comm, ';

--30/10/2017 la chilometrica è stata spostata nella tabella di relazione località-linea commerciale per gestirne la molteplicità
--sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI p';
--sqlstringa := sqlstringa || ' v.CODICE_VE
--sqlstringa := sqlstringa || ' and  p.sede_tecnica=v.sede_tecnica ';

sqlstringa := sqlstringa || '(SELECT v.SEDE_TECNICA, LISTAGG(PO_1_2_0_0_0_3 ,''#'' ) WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3) AS codice ';
sqlstringa := sqlstringa || 'from '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v,';
sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI p';
sqlstringa := sqlstringa || ' where  ';
sqlstringa := sqlstringa || ' v.CODICE_VERSIONE=p.CODICE_VERSIONE and ';
sqlstringa := sqlstringa || ' v.CODICE_VERSIONE='||p_versione ;
sqlstringa := sqlstringa || ' and p.sede_tecnica=v.sede_tecnica ';
sqlstringa := sqlstringa || ' GROUP BY v.SEDE_TECNICA) codice_taf_tap ';
ELSE
sqlstringa := sqlstringa || '(SELECT v.SEDE_TECNICA, LISTAGG(REPLACE(CODICE,'' '','''')||'' - ''||TRIM(TO_CHAR(ROUND(KM_INIZIO,3),''999990.999'')) ,''#'' ) WITHIN GROUP (ORDER BY CODICE) AS linea ';
sqlstringa := sqlstringa || 'from '||s_schema||'.V_MDR_LINEE_COMMERCIALI v ';

sqlstringa := sqlstringa || ' GROUP BY v.SEDE_TECNICA) linea_comm, ';
--30/10/2017 la chilometrica è stata spostata nella tabella di relazione località-linea commerciale per gestirne la molteplicità
--sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI p';
--sqlstringa := sqlstringa || ' where  ';
--sqlstringa := sqlstringa || ' p.sede_tecnica=v.sede_tecnica ';
sqlstringa := sqlstringa || '(SELECT v.SEDE_TECNICA, LISTAGG(PO_1_2_0_0_0_3 ,''#'' ) WITHIN GROUP (ORDER BY PO_1_2_0_0_0_3) AS codice ';
sqlstringa := sqlstringa || 'from '||s_schema||'.PAR_1_2_0_0_0_3_TAF_TAP v,';
sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI p';
sqlstringa := sqlstringa || ' where  ';
sqlstringa := sqlstringa || ' p.sede_tecnica=v.sede_tecnica ';
sqlstringa := sqlstringa || ' GROUP BY v.SEDE_TECNICA) codice_taf_tap ';
END IF;
sqlstringa := sqlstringa || 'where l.SEDE_TECNICA = '''||p_OP||''' ';
sqlstringa := sqlstringa || 'and l.SEDE_TECNICA = linea_comm.SEDE_TECNICA (+) ';
sqlstringa := sqlstringa || 'and l.SEDE_TECNICA = codice_taf_tap.SEDE_TECNICA (+) ';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || 'order by 1 ';
OPEN p_cursor FOR sqlstringa;
DBMS_OUTPUT.PUT_LINE(sqlstringa);
END GetOP_General;

-- -----------------------------------------------------------------------------
PROCEDURE GetOPTracks_Infrastructure (p_OP VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
--Ritorna i  Binari di Corsa della OP con relativi parametri
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(20000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
sqlstringa :=  'Select  DISTINCT r.SEDE_TECNICA PO_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.0.1'',b.PO_TRACK_1_2_1_0_0_1) PO_TRACK_1_2_1_0_0_1_XML, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.0.1'',b.PO_TRACK_1_2_1_0_0_1) PO_TRACK_1_2_1_0_0_1_OV, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.0.1'',b.PO_TRACK_1_2_1_0_0_1) PO_TRACK_1_2_1_0_0_1_DES, ';
sqlstringa := sqlstringa || ' NVL( b.PO_TRACK_1_2_1_0_0_1,''0083'') PO_TRACK_1_2_1_0_0_1,  ';
sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_0_2  PO_TRACK_1_2_1_0_0_2,  ';
sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_0_2_D PO_TRACK_1_2_1_0_0_2_DES,  ';
sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_2_1_AP, ';
sqlstringa := sqlstringa || 'cat_ten.PO_TRACK_1_2_1_0_2_1_XML,';
sqlstringa := sqlstringa || 'cat_ten.PO_TRACK_1_2_1_0_2_1_OV,';
sqlstringa := sqlstringa || 'cat_ten.PO_TRACK_1_2_1_0_2_1 PO_TRACK_1_2_1_0_2_1_DES,';
sqlstringa := sqlstringa || 'cat_ten.PO_TRACK_1_2_1_0_2_1_DES PO_TRACK_1_2_1_0_2_1, ';
sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_2_2_AP, ';
sqlstringa := sqlstringa || 'cat_linea.PO_TRACK_1_2_1_0_2_2_XML,';
sqlstringa := sqlstringa || 'cat_linea.PO_TRACK_1_2_1_0_2_2_OV,';
sqlstringa := sqlstringa || 'cat_linea.PO_TRACK_1_2_1_0_2_2_DES,';
sqlstringa := sqlstringa || 'cat_linea.PO_TRACK_1_2_1_0_2_2, ';
sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_2_3_AP, ';
sqlstringa := sqlstringa || 'corridoio.PO_TRACK_1_2_1_0_2_3_XML,';
sqlstringa := sqlstringa || 'corridoio.PO_TRACK_1_2_1_0_2_3_OV,';
sqlstringa := sqlstringa || 'corridoio.PO_TRACK_1_2_1_0_2_3 PO_TRACK_1_2_1_0_2_3_DES,';
sqlstringa := sqlstringa || 'corridoio.PO_TRACK_1_2_1_0_2_3_DES PO_TRACK_1_2_1_0_2_3, ';
sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_3_1_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.3.1'',b.PO_TRACK_1_2_1_0_3_1) PO_TRACK_1_2_1_0_3_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.3.1'',b.PO_TRACK_1_2_1_0_3_1) PO_TRACK_1_2_1_0_3_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.3.1'',b.PO_TRACK_1_2_1_0_3_1) PO_TRACK_1_2_1_0_3_1_DES,';
sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_3_1, ';
sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_3_2_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.3.2'',b.PO_TRACK_1_2_1_0_3_2) PO_TRACK_1_2_1_0_3_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.3.2'',b.PO_TRACK_1_2_1_0_3_2) PO_TRACK_1_2_1_0_3_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.3.2'',b.PO_TRACK_1_2_1_0_3_2) PO_TRACK_1_2_1_0_3_2_DES,';
sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_3_2, ';
sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_3_3_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.3.3'',b.PO_TRACK_1_2_1_0_3_3) PO_TRACK_1_2_1_0_3_3_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.3.3'',b.PO_TRACK_1_2_1_0_3_3) PO_TRACK_1_2_1_0_3_3_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.3.3'',b.PO_TRACK_1_2_1_0_3_3) PO_TRACK_1_2_1_0_3_3_DES,';
sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_3_3, ';
sqlstringa := sqlstringa || 'PO_TRACK_1_2_1_0_4_1_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.4.1'',b.PO_TRACK_1_2_1_0_4_1) PO_TRACK_1_2_1_0_4_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.4.1'',b.PO_TRACK_1_2_1_0_4_1) PO_TRACK_1_2_1_0_4_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.4.1'',b.PO_TRACK_1_2_1_0_4_1) PO_TRACK_1_2_1_0_4_1_DES,';
sqlstringa := sqlstringa || 'b.PO_TRACK_1_2_1_0_4_1 ';
sqlstringa := sqlstringa || 'from '||s_schema||'.BINARI_CORSA_PO b, ';
sqlstringa := sqlstringa ||  s_schema||'.REL_PO_BINARI_CORSA r, ';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || '(SELECT PO_TRACK_1_2_1_0_0_2, CODICE_VERSIONE, LISTAGG(PO_TRACK_1_2_1_0_2_1,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_TRACK_1_2_1_0_2_1) AS PO_TRACK_1_2_1_0_2_1, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_1_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_1_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_1_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_1_0_2_1_CAT_TEN_PO v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.1.0.2.1'' and';
sqlstringa := sqlstringa || ' PO_TRACK_1_2_1_0_2_1=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_TRACK_1_2_1_0_0_2, CODICE_VERSIONE) cat_ten, ';
sqlstringa := sqlstringa || '(SELECT PO_TRACK_1_2_1_0_0_2, CODICE_VERSIONE, LISTAGG(PO_TRACK_1_2_1_0_2_2,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_TRACK_1_2_1_0_2_2) AS PO_TRACK_1_2_1_0_2_2, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_2_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_2_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_2_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_1_0_2_2_CAT_LINEA v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.1.0.2.2'' and';
sqlstringa := sqlstringa || ' PO_TRACK_1_2_1_0_2_2=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_TRACK_1_2_1_0_0_2, CODICE_VERSIONE) cat_linea, ';

--07/11/2016 l'estrazione dei corridoi è stata cambiata sostanzialmente. e' stata introdotta la distinzione tra binari PO di tipo LO e
--quelli di tipo TR. Per i binari di tipo LO i corridoi vengono estratti dalla tabella CORRIDOIO_PO (V_OP_CONTESTO_GEOGRAFICO),
--mentre per quelli di tipo TR dalla tabella CORRIDOIO_SOL (V_SOL_CONTESTO_GEOGRAFICO).

sqlstringa := sqlstringa || '(SELECT SEDE_TECNICA, CODICE_VERSIONE, LISTAGG(v.DESCRIZIONE,''#'') WITHIN GROUP (ORDER BY v.DESCRIZIONE) AS PO_TRACK_1_2_1_0_2_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro ';
sqlstringa := sqlstringa || ' and numero_parametro=''1.2.1.0.2.3'' ';
sqlstringa := sqlstringa || ' and CODICE||''0''=CODIFICA_VALORE ';  --24/'7/2015 la vecchia join fatta sulle descrizioni non andava bene, il codice è stato moltiplicato per 10, perchè è il valore contenuto in DOMINIO_PARAMETRI(3=>30,1 =>10 etc.)
sqlstringa := sqlstringa || ' and CODICE_CONTESTO=3 ';
--07/11/2016 dalla tabella V_OP_CONTESTO_GEOGRAFICO si estraggono i corridoi della PO e delle PO da essa contenuta
sqlstringa := sqlstringa || ' and (SEDE_TECNICA,CODICE_VERSIONE) in ';
sqlstringa := sqlstringa || ' (SELECT '''||p_OP||''','||p_versione||' from dual UNION select SEDE_TECNICA,CODICE_VERSIONE from '||s_schema||'.PUNTI_OPERATIVI WHERE LOCALITA_CONTENITORE='''||p_OP||''')';
sqlstringa := sqlstringa || '  group by SEDE_TECNICA, CODICE_VERSIONE ';
sqlstringa := sqlstringa || ' UNION ';
sqlstringa := sqlstringa || ' SELECT SEDE_TECNICA, CODICE_VERSIONE, LISTAGG(v.DESCRIZIONE,''#'') WITHIN GROUP (ORDER BY v.DESCRIZIONE) AS PO_TRACK_1_2_1_0_2_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro ';
sqlstringa := sqlstringa || ' and numero_parametro=''1.1.1.1.2.3'' ';
sqlstringa := sqlstringa || ' and CODICE||''0''=CODIFICA_VALORE ';  --24/'7/2015 la vecchia join fatta sulle descrizioni non andava bene, il codice è stato moltiplicato per 10, perchè è il valore contenuto in DOMINIO_PARAMETRI(3=>30,1 =>10 etc.)
sqlstringa := sqlstringa || ' and CODICE_CONTESTO=3 ';
--07/11/2016 dalla tabella V_SOL_CONTESTO_GEOGRAFICO si estraggono i corridoi delle SOL il cui binario è di fermata per la PO
sqlstringa := sqlstringa || ' and (SEDE_TECNICA,CODICE_VERSIONE) in (select substr(PO_TRACK_1_2_1_0_0_2,1,6), CODICE_VERSIONE from '||s_schema||'.REL_PO_BINARI_CORSA ';
sqlstringa := sqlstringa || ' where SEDE_TECNICA = '''||p_OP||''') ';
sqlstringa := sqlstringa || '  group by SEDE_TECNICA, CODICE_VERSIONE) corridoio ';
sqlstringa := sqlstringa || ' where b.CODICE_VERSIONE='||p_versione;
sqlstringa := sqlstringa || ' and b.CODICE_VERSIONE=cat_ten.CODICE_VERSIONE (+) ';
sqlstringa := sqlstringa || ' and b.CODICE_VERSIONE=cat_linea.CODICE_VERSIONE (+) ';
sqlstringa := sqlstringa || ' and r.CODICE_VERSIONE=corridoio.CODICE_VERSIONE (+) ';
sqlstringa := sqlstringa || ' and b.PO_TRACK_1_2_1_0_0_2=r.PO_TRACK_1_2_1_0_0_2 ';
sqlstringa := sqlstringa || ' and b.CODICE_VERSIONE=r.CODICE_VERSIONE ';
sqlstringa := sqlstringa || ' and r.SEDE_TECNICA = '''||p_OP||''' ';
ELSE
sqlstringa := sqlstringa || '(SELECT PO_TRACK_1_2_1_0_0_2, LISTAGG(PO_TRACK_1_2_1_0_2_1,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_TRACK_1_2_1_0_2_1) AS PO_TRACK_1_2_1_0_2_1, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_1_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_1_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_1_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_1_0_2_1_CAT_TEN_PO v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.1.0.2.1'' and';
sqlstringa := sqlstringa || ' PO_TRACK_1_2_1_0_2_1=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_TRACK_1_2_1_0_0_2) cat_ten, ';
sqlstringa := sqlstringa || '(SELECT PO_TRACK_1_2_1_0_0_2,  LISTAGG(PO_TRACK_1_2_1_0_2_2,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_TRACK_1_2_1_0_2_2) AS PO_TRACK_1_2_1_0_2_2, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_2_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_2_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TRACK_1_2_1_0_2_2_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_1_0_2_2_CAT_LINEA v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where ';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and ';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.1.0.2.2'' and ';
sqlstringa := sqlstringa || ' PO_TRACK_1_2_1_0_2_2=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_TRACK_1_2_1_0_0_2) cat_linea, ';
sqlstringa := sqlstringa || '(SELECT SEDE_TECNICA, LISTAGG(v.DESCRIZIONE,''#'') WITHIN GROUP (ORDER BY v.DESCRIZIONE) AS PO_TRACK_1_2_1_0_2_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro ';
sqlstringa := sqlstringa || ' and numero_parametro=''1.2.1.0.2.3'' ';
sqlstringa := sqlstringa || ' and CODICE||''0''=CODIFICA_VALORE ';  --24/'7/2015 la vecchia join fatta sulle descrizioni non andava bene, il codice è stato moltiplicato per 10, perchè è il valore contenuto in DOMINIO_PARAMETRI(3=>30,1 =>10 etc.)
sqlstringa := sqlstringa || ' and CODICE_CONTESTO=3 ';
sqlstringa := sqlstringa || ' and SEDE_TECNICA IN (select '''||p_OP||''' from dual UNION select SEDE_TECNICA from '||s_schema||'.PUNTI_OPERATIVI WHERE LOCALITA_CONTENITORE='''||p_OP||''')';
sqlstringa := sqlstringa || '  group by SEDE_TECNICA ';
sqlstringa := sqlstringa || ' UNION ';
sqlstringa := sqlstringa || ' SELECT SEDE_TECNICA, LISTAGG(v.DESCRIZIONE,''#'') WITHIN GROUP (ORDER BY v.DESCRIZIONE) AS PO_TRACK_1_2_1_0_2_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS PO_TRACK_1_2_1_0_2_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro ';
sqlstringa := sqlstringa || ' and numero_parametro=''1.1.1.1.2.3'' ';
sqlstringa := sqlstringa || ' and CODICE||''0''=CODIFICA_VALORE ';  --24/'7/2015 la vecchia join fatta sulle descrizioni non andava bene, il codice è stato moltiplicato per 10, perchè è il valore contenuto in DOMINIO_PARAMETRI(3=>30,1 =>10 etc.)
sqlstringa := sqlstringa || ' and CODICE_CONTESTO=3 ';
sqlstringa := sqlstringa || ' and SEDE_TECNICA IN (select SUBSTR(PO_TRACK_1_2_1_0_0_2,1,6) from '||s_schema||'.REL_PO_BINARI_CORSA WHERE SEDE_TECNICA='''||p_OP||''')';
sqlstringa := sqlstringa || '  group by SEDE_TECNICA) corridoio ';
sqlstringa := sqlstringa || ' where r.SEDE_TECNICA = '''||p_OP||''' ';
sqlstringa := sqlstringa || ' and b.PO_TRACK_1_2_1_0_0_2=r.PO_TRACK_1_2_1_0_0_2 ';
END IF;
sqlstringa := sqlstringa || ' and b.PO_TRACK_1_2_1_0_0_2=cat_ten.PO_TRACK_1_2_1_0_0_2 (+) ';
sqlstringa := sqlstringa || ' and b.PO_TRACK_1_2_1_0_0_2=cat_linea.PO_TRACK_1_2_1_0_0_2 (+) ';
--07/11/2016 E' stata cambiata la join: prima era tra la sede tecnica della PO e quella del corridoi,
--ora è tra i primi sei caratteri del binario e la sede tecnica del corridoio, per garantire
--la gestione dei binari di fermata (TR) e di quelli delle località contenute
sqlstringa := sqlstringa || ' and substr(r.PO_TRACK_1_2_1_0_0_2,1,6)=corridoio.SEDE_TECNICA (+) ';
sqlstringa := sqlstringa || 'order by 3 ';
DBMS_OUTPUT.PUT_LINE(sqlstringa);
OPEN p_cursor FOR sqlstringa;
END GetOPTracks_Infrastructure;

-- -----------------------------------------------------------------------------
PROCEDURE GetOPTracks_Inf_EC (p_POTrack VARCHAR2, p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
--Ritorna l'elenco delle dichiarazioni di verifica EC e EI di un Binario di Corsa di una OP
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
sqlstringa :=  'Select DISTINCT s.PO_TRACK_1_2_1_0_0_2 POTrack_ID,  ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||'  CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione,                                      ';
sqlstringa := sqlstringa || 'NVL(PO_TRACK_1_2_1_0_1_1O2_AP,'''||GetNYA('1.2.1.0.1.1')||''') PO_TRACK_1_2_1_0_1_1O2_AP, ';
sqlstringa := sqlstringa || 'NVL(PO_TRACK_1_2_1_0_1_1O2, ''00/00000000000000/0000/000000'') PO_TRACK_1_2_1_0_1_1O2, ';
sqlstringa := sqlstringa || 'KM_INIZIO,  ';
sqlstringa := sqlstringa || 'KM_FINE     ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from        ';
sqlstringa := sqlstringa || '(select PO_TRACK_1_2_1_0_0_2,PO_TRACK_1_2_1_0_1_1O2_AP,PO_TRACK_1_2_1_0_1_1O2,KM_INIZIO,KM_FINE   ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_BINARIO_PO ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EC''' ;
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ') b,  ';
sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_PO s            ';
sqlstringa := sqlstringa || 'where s.PO_TRACK_1_2_1_0_0_2=b.PO_TRACK_1_2_1_0_0_2 (+) and ';
sqlstringa := sqlstringa || 's.PO_TRACK_1_2_1_0_0_2='''||p_POTrack||''''  ;
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || 'UNION                                                   ';
sqlstringa := sqlstringa || 'Select DISTINCT s.PO_TRACK_1_2_1_0_0_2 POTrack_ID,      ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||'  CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || '''EI'',                                                 ';
sqlstringa := sqlstringa || 'NVL(PO_TRACK_1_2_1_0_1_1O2_AP,'''||GetNYA('1.2.1.0.1.2')||''') PO_TRACK_1_2_1_0_1_1O2_AP, ';
sqlstringa := sqlstringa || 'NVL(PO_TRACK_1_2_1_0_1_1O2, ''00/00000000000000/0000/000000''), ' ;
sqlstringa := sqlstringa || 'KM_INIZIO,' ;
sqlstringa := sqlstringa || 'KM_FINE   ' ;
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';

sqlstringa := sqlstringa || 'from      ' ;
sqlstringa := sqlstringa || '(select PO_TRACK_1_2_1_0_0_2,PO_TRACK_1_2_1_0_1_1O2_AP,PO_TRACK_1_2_1_0_1_1O2,KM_INIZIO,KM_FINE  ' ;
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_BINARIO_PO ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EI''';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ') b, ';
sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_PO s            ';
sqlstringa := sqlstringa || 'where s.PO_TRACK_1_2_1_0_0_2=b.PO_TRACK_1_2_1_0_0_2 (+) and ';
sqlstringa := sqlstringa || 's.PO_TRACK_1_2_1_0_0_2='''||p_POTrack||''''                 ;
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || 'order by 3,6 ';
OPEN p_cursor FOR sqlstringa;
END GetOPTracks_Inf_EC;

-- -----------------------------------------------------------------------------
PROCEDURE GetOPTracks_Inf_Tunnel(p_POTrack VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
--Restituisce l'elenco delle gallerie, con realtivi parametri, di un Binario di Corsa di una OP
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
sqlstringa :=  'Select DISTINCT r.PO_TRACK_1_2_1_0_0_2 POTrack_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.5.1'',g.PO_TR_TUNNEL_1_2_1_0_5_1) PO_TR_TUNNEL_1_2_1_0_5_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.5.1'',g.PO_TR_TUNNEL_1_2_1_0_5_1) PO_TR_TUNNEL_1_2_1_0_5_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.5.1'',g.PO_TR_TUNNEL_1_2_1_0_5_1) PO_TR_TUNNEL_1_2_1_0_5_1_DES,';
sqlstringa := sqlstringa || 'NVL( g.PO_TR_TUNNEL_1_2_1_0_5_1,''0083'') PO_TR_TUNNEL_1_2_1_0_5_1, ';
sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_2 PO_TR_TUNNEL_1_2_1_0_5_2, ';
sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_2_D PO_TR_TUNNEL_1_2_1_0_5_2_DES, ';
sqlstringa := sqlstringa || 'PO_TR_TUNNEL_1_2_1_0_5_5_AP, ';
sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_5, ';
sqlstringa := sqlstringa || 'PO_TR_TUNNEL_1_2_1_0_5_6_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.5.6'',g.PO_TR_TUNNEL_1_2_1_0_5_6) PO_TR_TUNNEL_1_2_1_0_5_6_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.5.6'',g.PO_TR_TUNNEL_1_2_1_0_5_6) PO_TR_TUNNEL_1_2_1_0_5_6_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.5.6'',g.PO_TR_TUNNEL_1_2_1_0_5_6) PO_TR_TUNNEL_1_2_1_0_5_6_DES,';
sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_6, ';
sqlstringa := sqlstringa || 'PO_TR_TUNNEL_1_2_1_0_5_7_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.5.7'',g.PO_TR_TUNNEL_1_2_1_0_5_7) PO_TR_TUNNEL_1_2_1_0_5_7_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.5.7'',g.PO_TR_TUNNEL_1_2_1_0_5_7) PO_TR_TUNNEL_1_2_1_0_5_7_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.5.7'',g.PO_TR_TUNNEL_1_2_1_0_5_7) PO_TR_TUNNEL_1_2_1_0_5_7_DES,';
sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_7, ';
sqlstringa := sqlstringa || 'PO_TR_TUNNEL_1_2_1_0_5_8_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.5.8'',g.PO_TR_TUNNEL_1_2_1_0_5_8) PO_TR_TUNNEL_1_2_1_0_5_8_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.5.8'',g.PO_TR_TUNNEL_1_2_1_0_5_8) PO_TR_TUNNEL_1_2_1_0_5_8_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.5.8'',g.PO_TR_TUNNEL_1_2_1_0_5_8) PO_TR_TUNNEL_1_2_1_0_5_8_DES,';
sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_8 ';
sqlstringa := sqlstringa || 'from '||s_schema||'.GALLERIE_BINARI_PO g, ';
sqlstringa := sqlstringa ||  s_schema||'.REL_GALLERIE_BINARI_PO r ';
sqlstringa := sqlstringa || 'where  ';
sqlstringa := sqlstringa || 'g.PO_TR_TUNNEL_1_2_1_0_5_2=R.PO_TR_TUNNEL_1_2_1_0_5_2 and ';
sqlstringa := sqlstringa || 'r.PO_TRACK_1_2_1_0_0_2='''||p_POTrack||'''  ';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and g.CODICE_VERSIONE='||p_versione;
sqlstringa := sqlstringa || 'and r.CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ' order by 3 ';
--DBMS_OUTPUT.PUT_LINE(sqlstringa);
OPEN p_cursor FOR sqlstringa;
END GetOPTracks_Inf_Tunnel;

-- -----------------------------------------------------------------------------
PROCEDURE GetOPTracks_Inf_Tunnel_EC(p_POTrack_Tunnel VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
--Ritorna l'elenco delle dichiarazioni di verifica EC e EI di una galleria di un  Binario di Corsa di una OP
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
sqlstringa :=  'Select DISTINCT s.PO_TR_TUNNEL_1_2_1_0_5_2 POTrack_Tunnel_ID,  ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione,                                      ';
sqlstringa := sqlstringa || 'NVL(PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,'''||GetNYA('1.2.1.0.5.3')||''') PO_TR_TUNNEL_1_2_1_0_5_3O4_AP, ';
sqlstringa := sqlstringa || 'NVL(PO_TR_TUNNEL_1_2_1_0_5_3O4, ''00/00000000000000/0000/000000'') PO_TR_TUNNEL_1_2_1_0_5_3O4, ';
sqlstringa := sqlstringa || 'KM_INIZIO,  ';
sqlstringa := sqlstringa || 'KM_FINE     ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from        ';
sqlstringa := sqlstringa || '(select PO_TR_TUNNEL_1_2_1_0_5_2,PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,PO_TR_TUNNEL_1_2_1_0_5_3O4,KM_INIZIO,KM_FINE   ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_PO ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EC''';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_BINARI_PO s            ';
sqlstringa := sqlstringa || 'where s.PO_TR_TUNNEL_1_2_1_0_5_2=b.PO_TR_TUNNEL_1_2_1_0_5_2 (+) and ';
sqlstringa := sqlstringa || 's.PO_TR_TUNNEL_1_2_1_0_5_2='''||p_POTrack_Tunnel||''''  ;
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || 'UNION                                                   ';
sqlstringa := sqlstringa || 'Select DISTINCT s.PO_TR_TUNNEL_1_2_1_0_5_2 POTrack_Tunnel_ID,  ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||'  CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || '''EI'' tipo_dichiarazione,                                      ';
sqlstringa := sqlstringa || 'NVL(PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,'''||GetNYA('1.2.1.0.5.4')||''') PO_TR_TUNNEL_1_2_1_0_5_3O4_AP, ';
sqlstringa := sqlstringa || 'NVL(PO_TR_TUNNEL_1_2_1_0_5_3O4, ''00/00000000000000/0000/000000'') PO_TR_TUNNEL_1_2_1_0_5_3O4, ';
sqlstringa := sqlstringa || 'KM_INIZIO,  ';
sqlstringa := sqlstringa || 'KM_FINE     ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from        ';
sqlstringa := sqlstringa || '(select PO_TR_TUNNEL_1_2_1_0_5_2,PO_TR_TUNNEL_1_2_1_0_5_3O4_AP,PO_TR_TUNNEL_1_2_1_0_5_3O4,KM_INIZIO,KM_FINE   ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_PO ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EI''';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_BINARI_PO s            ';
sqlstringa := sqlstringa || 'where s.PO_TR_TUNNEL_1_2_1_0_5_2=b.PO_TR_TUNNEL_1_2_1_0_5_2 (+) and ';
sqlstringa := sqlstringa || 's.PO_TR_TUNNEL_1_2_1_0_5_2='''||p_POTrack_Tunnel||''''  ;
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || 'order by 3,6 ';
OPEN p_cursor FOR sqlstringa;
--DBMS_OUTPUT.PUT_LINE(sqlstringa);
END GetOPTracks_Inf_Tunnel_EC;

-- -----------------------------------------------------------------------------
PROCEDURE GetOPTracks_Inf_Platform(p_PO VARCHAR2,p_POTrack VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
--Ritorna l'elenco dei marciapiedi, con relativi parametri, di un Binario di Corsa di una OP
--28/09/2016 Aggiunto il parametro della OP per gestire i marciapiedi delle fermate adiacenti
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(20000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
sqlstringa :=  'Select DISTINCT BINARIO_1 POTrack_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_DES,';
sqlstringa := sqlstringa || 'NVL(PO_TR_PLATFORM_1_2_1_0_6_1,''0083'')  PO_TR_PLATFORM_1_2_1_0_6_1,';
sqlstringa := sqlstringa || 'b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
sqlstringa := sqlstringa || 'b.PO_TR_PLATFORM_1_2_1_0_6_2_D  PO_TR_PLATFORM_1_2_1_0_6_2_DES,' ;
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_3_AP,  ';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_XML,';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_OV,';
--08/03/2016 incrocio delle colonne verificato per la valorizzazione del file xls
--quando si effettuerà l'attività di omogenizzazione dei valori dovrà essere verificato di nuovo
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3 PO_TR_PLATFORM_1_2_1_0_6_3_DES,';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_DES PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstringa := sqlstringa || 'PO_TR_PLAT_1_2_1_0_6_4_B1_AP,  ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_4_B1 PO_TR_PLATFORM_1_2_1_0_6_4, ';
sqlstringa := sqlstringa || 'PO_TR_PLAT_1_2_1_0_6_5_B1_AP,  ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.6.5.B1'',PO_TR_PLATFORM_1_2_1_0_6_5_B1) PO_TR_PLAT_1_2_1_0_6_5_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.6.5.B1'',PO_TR_PLATFORM_1_2_1_0_6_5_B1) PO_TR_PLAT_1_2_1_0_6_5_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.6.5.B1'',PO_TR_PLATFORM_1_2_1_0_6_5_B1) PO_TR_PLAT_1_2_1_0_6_5_DES,';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_5_B1 PO_TR_PLATFORM_1_2_1_0_6_5, ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_6_AP,  ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_DES,';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_6, ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_7_AP,  ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_7  ';
sqlstringa := sqlstringa || 'from '||s_schema||'.MARCIAPIEDI_BINARI_PO b,                 ';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || '(SELECT PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE, LISTAGG(PO_TR_PLATFORM_1_2_1_0_6_3,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_TR_PLATFORM_1_2_1_0_6_3) AS PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.1.0.6.3'' and';
sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_3=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE) cat_ten ';
sqlstringa := sqlstringa || 'where b.CODICE_VERSIONE='||p_versione;
sqlstringa := sqlstringa || 'and b.CODICE_VERSIONE=cat_ten.CODICE_VERSIONE (+) ';
sqlstringa := sqlstringa || 'and BINARIO_1='''||p_POTrack||''' ';
--26/09/2016 inserita la condizione sul codice del marciapiede. Questo deve comprendere il codice della località
--o quello delle località contenute nella località principale.
--Questa condizione evita che nel caso di marciapiedi di fermate adiacenti queste abbiamo anche i marciapiedi della località adiacente
sqlstringa := sqlstringa || 'and substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) in (select '''||p_PO||''' from dual ';
sqlstringa := sqlstringa || ' UNION select sede_tecnica from '||s_schema||'.punti_operativi where LOCALITA_CONTENITORE='''||p_PO||''' and CODICE_VERSIONE='||p_versione||')';
ELSE
sqlstringa := sqlstringa || '(SELECT PO_TR_PLATFORM_1_2_1_0_6_2,  LISTAGG(PO_TR_PLATFORM_1_2_1_0_6_3,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_TR_PLATFORM_1_2_1_0_6_3) AS PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.1.0.6.3'' and';
sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_3=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_TR_PLATFORM_1_2_1_0_6_2) cat_ten ';
sqlstringa := sqlstringa || 'where BINARIO_1='''||p_POTrack||''' ';
--26/09/2016 inserita la condizione sul codice del marciapiede. Questo deve comprendere il codice della località
--o quello delle località contenute nella località principale.
--Questa condizione evita che nel caso di marciapiedi di fermate adiacenti queste abbiamo anche i marciapiedi della località adiacente
sqlstringa := sqlstringa || 'and substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) in (select '''||p_PO||''' from dual ';
sqlstringa := sqlstringa || ' UNION select sede_tecnica from '||s_schema||'.punti_operativi where LOCALITA_CONTENITORE='''||p_PO||''')';
END IF;
sqlstringa := sqlstringa || ' and b.PO_TR_PLATFORM_1_2_1_0_6_2=cat_ten.PO_TR_PLATFORM_1_2_1_0_6_2 (+) ';
sqlstringa := sqlstringa || 'UNION ';
sqlstringa := sqlstringa || 'Select DISTINCT BINARIO_2 POTrack_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_DES,';
sqlstringa := sqlstringa || 'NVL(PO_TR_PLATFORM_1_2_1_0_6_1,''0083'') PO_TR_PLATFORM_1_2_1_0_6_1, ';
sqlstringa := sqlstringa || 'b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
sqlstringa := sqlstringa || 'b.PO_TR_PLATFORM_1_2_1_0_6_2_D  PO_TR_PLATFORM_1_2_1_0_6_2_DES,' ;
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_3_AP,  ';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_XML,';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_OV,';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3 PO_TR_PLATFORM_1_2_1_0_6_3_DES,';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_DES PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstringa := sqlstringa || 'PO_TR_PLAT_1_2_1_0_6_4_B2_AP,  ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_4_B2, ';
sqlstringa := sqlstringa || 'PO_TR_PLAT_1_2_1_0_6_5_B2_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.6.5.B2'',PO_TR_PLATFORM_1_2_1_0_6_5_B2) PO_TR_PLAT_1_2_1_0_6_5_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.6.5.B2'',PO_TR_PLATFORM_1_2_1_0_6_5_B2) PO_TR_PLAT_1_2_1_0_6_5_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.6.5.B2'',PO_TR_PLATFORM_1_2_1_0_6_5_B2) PO_TR_PLAT_1_2_1_0_6_5_DES,';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_5_B2, ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_6_AP,  ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_DES,';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_6, ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_7_AP,  ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_7  ';
sqlstringa := sqlstringa || 'from '||s_schema||'.MARCIAPIEDI_BINARI_PO b,                 ';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || '(SELECT PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE, LISTAGG(PO_TR_PLATFORM_1_2_1_0_6_3,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_TR_PLATFORM_1_2_1_0_6_3) AS PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.1.0.6.3'' and';
sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_3=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE) cat_ten ';
sqlstringa := sqlstringa || 'where b.CODICE_VERSIONE='||p_versione;
sqlstringa := sqlstringa || 'and b.CODICE_VERSIONE=cat_ten.CODICE_VERSIONE (+) ';
sqlstringa := sqlstringa || 'and BINARIO_2='''||p_POTrack||''' ';
sqlstringa := sqlstringa || 'and substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) in (select '''||p_PO||''' from dual ';
sqlstringa := sqlstringa || ' UNION select sede_tecnica from '||s_schema||'.punti_operativi where LOCALITA_CONTENITORE='''||p_PO||''' and CODICE_VERSIONE='||p_versione||')';

ELSE
sqlstringa := sqlstringa || '(SELECT PO_TR_PLATFORM_1_2_1_0_6_2,  LISTAGG(PO_TR_PLATFORM_1_2_1_0_6_3,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_TR_PLATFORM_1_2_1_0_6_3) AS PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.1.0.6.3'' and';
sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_3=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_TR_PLATFORM_1_2_1_0_6_2) cat_ten ';
sqlstringa := sqlstringa || 'where BINARIO_2='''||p_POTrack||''' ';
sqlstringa := sqlstringa || 'and substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) in (select '''||p_PO||''' from dual ';
sqlstringa := sqlstringa || ' UNION select sede_tecnica from '||s_schema||'.punti_operativi where LOCALITA_CONTENITORE='''||p_PO||''')';
END IF;
sqlstringa := sqlstringa || ' and b.PO_TR_PLATFORM_1_2_1_0_6_2=cat_ten.PO_TR_PLATFORM_1_2_1_0_6_2 (+) ';
sqlstringa := sqlstringa || 'UNION ';
sqlstringa := sqlstringa || 'Select DISTINCT BINARIO_3 POTrack_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_DES,';
sqlstringa := sqlstringa || 'NVL(PO_TR_PLATFORM_1_2_1_0_6_1,''0083'') PO_TR_PLATFORM_1_2_1_0_6_1, ';
sqlstringa := sqlstringa || 'b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
sqlstringa := sqlstringa || 'b.PO_TR_PLATFORM_1_2_1_0_6_2_D  PO_TR_PLATFORM_1_2_1_0_6_2_DES,' ;
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_3_AP,  ';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_XML,';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_OV,';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3 PO_TR_PLATFORM_1_2_1_0_6_3_DES,';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_DES PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstringa := sqlstringa || 'PO_TR_PLAT_1_2_1_0_6_4_B3_AP, ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_4_B3, ';
sqlstringa := sqlstringa || 'PO_TR_PLAT_1_2_1_0_6_5_B3_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.6.5.B3'',PO_TR_PLATFORM_1_2_1_0_6_5_B3) PO_TR_PLAT_1_2_1_0_6_5_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.6.5.B3'',PO_TR_PLATFORM_1_2_1_0_6_5_B3) PO_TR_PLAT_1_2_1_0_6_5_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.6.5.B3'',PO_TR_PLATFORM_1_2_1_0_6_5_B3) PO_TR_PLAT_1_2_1_0_6_5_DES,';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_5_B3, ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_6_AP,  ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_DES,';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_6, ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_7_AP,  ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_7  ';
sqlstringa := sqlstringa || 'from '||s_schema||'.MARCIAPIEDI_BINARI_PO b,                 ';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || '(SELECT PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE, LISTAGG(PO_TR_PLATFORM_1_2_1_0_6_3,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_TR_PLATFORM_1_2_1_0_6_3) AS PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.1.0.6.3'' and';
sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_3=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE) cat_ten ';
sqlstringa := sqlstringa || 'where b.CODICE_VERSIONE='||p_versione;
sqlstringa := sqlstringa || 'and b.CODICE_VERSIONE=cat_ten.CODICE_VERSIONE (+) ';
sqlstringa := sqlstringa || 'and BINARIO_3='''||p_POTrack||''' ';
sqlstringa := sqlstringa || 'and substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) in (select '''||p_PO||''' from dual ';
sqlstringa := sqlstringa || ' UNION select sede_tecnica from '||s_schema||'.punti_operativi where LOCALITA_CONTENITORE='''||p_PO||''' and CODICE_VERSIONE='||p_versione||')';
ELSE
sqlstringa := sqlstringa || '(SELECT PO_TR_PLATFORM_1_2_1_0_6_2,  LISTAGG(PO_TR_PLATFORM_1_2_1_0_6_3,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_TR_PLATFORM_1_2_1_0_6_3) AS PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.1.0.6.3'' and';
sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_3=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_TR_PLATFORM_1_2_1_0_6_2) cat_ten ';
sqlstringa := sqlstringa || 'where BINARIO_3='''||p_POTrack||''' ';
sqlstringa := sqlstringa || 'and substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) in (select '''||p_PO||''' from dual ';
sqlstringa := sqlstringa || ' UNION select sede_tecnica from '||s_schema||'.punti_operativi where LOCALITA_CONTENITORE='''||p_PO||''')';
END IF;
sqlstringa := sqlstringa || ' and b.PO_TR_PLATFORM_1_2_1_0_6_2=cat_ten.PO_TR_PLATFORM_1_2_1_0_6_2 (+) ';
sqlstringa := sqlstringa || 'UNION ';
sqlstringa := sqlstringa || 'Select DISTINCT BINARIO_4 POTrack_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.6.1'',PO_TR_PLATFORM_1_2_1_0_6_1) PO_TR_PLATFORM_1_2_1_0_6_1_DES,';
sqlstringa := sqlstringa || 'NVL(PO_TR_PLATFORM_1_2_1_0_6_1,''0083'') PO_TR_PLATFORM_1_2_1_0_6_1, ';
sqlstringa := sqlstringa || 'b.PO_TR_PLATFORM_1_2_1_0_6_2 PO_TR_PLATFORM_1_2_1_0_6_2, ';
sqlstringa := sqlstringa || 'b.PO_TR_PLATFORM_1_2_1_0_6_2_D  PO_TR_PLATFORM_1_2_1_0_6_2_DES,' ;
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_3_AP,  ';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_XML,';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_OV,';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3 PO_TR_PLATFORM_1_2_1_0_6_3_DES,';
sqlstringa := sqlstringa || 'cat_ten.PO_TR_PLATFORM_1_2_1_0_6_3_DES PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstringa := sqlstringa || 'PO_TR_PLAT_1_2_1_0_6_4_B4_AP, ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_4_B4, ';
sqlstringa := sqlstringa || 'PO_TR_PLAT_1_2_1_0_6_5_B4_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.6.5.B4'',PO_TR_PLATFORM_1_2_1_0_6_5_B4) PO_TR_PLAT_1_2_1_0_6_5_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.6.5.B4'',PO_TR_PLATFORM_1_2_1_0_6_5_B4) PO_TR_PLAT_1_2_1_0_6_5_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.6.5.B4'',PO_TR_PLATFORM_1_2_1_0_6_5_B4) PO_TR_PLAT_1_2_1_0_6_5_DES,';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_5_B4, ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_6_AP,  ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.1.0.6.6'',PO_TR_PLATFORM_1_2_1_0_6_6) PO_TR_PLATFORM_1_2_1_0_6_6_DES,';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_6, ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_7_AP,  ';
sqlstringa := sqlstringa || 'PO_TR_PLATFORM_1_2_1_0_6_7  ';
sqlstringa := sqlstringa || 'from '||s_schema||'.MARCIAPIEDI_BINARI_PO b,                 ';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || '(SELECT PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE, LISTAGG(PO_TR_PLATFORM_1_2_1_0_6_3,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_TR_PLATFORM_1_2_1_0_6_3) AS PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.1.0.6.3'' and';
sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_3=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_TR_PLATFORM_1_2_1_0_6_2, CODICE_VERSIONE) cat_ten ';
sqlstringa := sqlstringa || 'where b.CODICE_VERSIONE='||p_versione;
sqlstringa := sqlstringa || 'and b.CODICE_VERSIONE=cat_ten.CODICE_VERSIONE (+) ';
sqlstringa := sqlstringa || 'and BINARIO_4='''||p_POTrack||''' ';
sqlstringa := sqlstringa || 'and substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) in (select '''||p_PO||''' from dual ';
sqlstringa := sqlstringa || ' UNION select sede_tecnica from '||s_schema||'.punti_operativi where LOCALITA_CONTENITORE='''||p_PO||''' and CODICE_VERSIONE='||p_versione||')';
ELSE
sqlstringa := sqlstringa || '(SELECT PO_TR_PLATFORM_1_2_1_0_6_2,  LISTAGG(PO_TR_PLATFORM_1_2_1_0_6_3,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_TR_PLATFORM_1_2_1_0_6_3) AS PO_TR_PLATFORM_1_2_1_0_6_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_TR_PLATFORM_1_2_1_0_6_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_1_0_6_3_CAT_TEN_PL v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.1.0.6.3'' and';
sqlstringa := sqlstringa || ' PO_TR_PLATFORM_1_2_1_0_6_3=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_TR_PLATFORM_1_2_1_0_6_2) cat_ten ';
sqlstringa := sqlstringa || 'where BINARIO_4='''||p_POTrack||''' ';
sqlstringa := sqlstringa || 'and substr(b.PO_TR_PLATFORM_1_2_1_0_6_2,1,6) in (select '''||p_PO||''' from dual ';
sqlstringa := sqlstringa || ' UNION select sede_tecnica from '||s_schema||'.punti_operativi where LOCALITA_CONTENITORE='''||p_PO||''')';
END IF;
sqlstringa := sqlstringa || ' and b.PO_TR_PLATFORM_1_2_1_0_6_2=cat_ten.PO_TR_PLATFORM_1_2_1_0_6_2 (+) ';
sqlstringa := sqlstringa || 'order by 3 ';
OPEN p_cursor FOR sqlstringa;
DBMS_OUTPUT.PUT_LINE(sqlstringa);
END GetOPTracks_Inf_Platform;

-- -----------------------------------------------------------------------------
PROCEDURE GetOPSiding_Infrastructure (p_PO VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
--Ritorna l'elenco dei  Binari di Raccordo di una OP, con relativi parametri
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
sqlstringa :=  'Select DISTINCT b.SEDE_TECNICA PO_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.0.1'',PO_SD_1_2_2_0_0_1) PO_SD_1_2_2_0_0_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.0.1'',PO_SD_1_2_2_0_0_1) PO_SD_1_2_2_0_0_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.0.1'',PO_SD_1_2_2_0_0_1) PO_SD_1_2_2_0_0_1_DES,';
sqlstringa := sqlstringa || ' NVL(PO_SD_1_2_2_0_0_1,''0083'') PO_SD_1_2_2_0_0_1, ';
sqlstringa := sqlstringa || 'b.PO_SD_1_2_2_0_0_2, ';
sqlstringa := sqlstringa || 'b.PO_SD_1_2_2_0_0_2_D PO_SD_1_2_2_0_0_2_DES, ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_0_3_AP, ';
sqlstringa := sqlstringa || 'cat_ten.PO_SD_1_2_2_0_0_3_XML,';
sqlstringa := sqlstringa || 'cat_ten.PO_SD_1_2_2_0_0_3_OV,';
sqlstringa := sqlstringa || 'cat_ten.PO_SD_1_2_2_0_0_3 PO_SD_1_2_2_0_0_3_DES,';
sqlstringa := sqlstringa || 'cat_ten.PO_SD_1_2_2_0_0_3_DES PO_SD_1_2_2_0_0_3, ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_2_1_AP, ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_2_1, ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_3_1_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.3.1'',PO_SD_1_2_2_0_3_1) PO_SD_1_2_2_0_3_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.3.1'',PO_SD_1_2_2_0_3_1) PO_SD_1_2_2_0_3_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.3.1'',PO_SD_1_2_2_0_3_1) PO_SD_1_2_2_0_3_1_DES,';
sqlstringa := sqlstringa || 'TRIM(TO_CHAR(ROUND(PO_SD_1_2_2_0_3_1,1),''999990.9'')) PO_SD_1_2_2_0_3_1, ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_3_2_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.3.2'',PO_SD_1_2_2_0_3_2) PO_SD_1_2_2_0_3_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.3.2'',PO_SD_1_2_2_0_3_2) PO_SD_1_2_2_0_3_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.3.2'',PO_SD_1_2_2_0_3_2) PO_SD_1_2_2_0_3_2_DES,';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_3_2, ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_3_3_AP, ';
sqlstringa := sqlstringa || 'DECODE(PO_SD_1_2_2_0_3_3_A||''+''||PO_SD_1_2_2_0_3_3_B,''+'',NULL,PO_SD_1_2_2_0_3_3_A||''+''||PO_SD_1_2_2_0_3_3_B) PO_SD_1_2_2_0_3_3_XML,';
sqlstringa := sqlstringa || 'NULL PO_SD_1_2_2_0_3_3_OV,';
sqlstringa := sqlstringa || 'DECODE(PO_SD_1_2_2_0_3_3_A||''+''||PO_SD_1_2_2_0_3_3_B,''+'',NULL,PO_SD_1_2_2_0_3_3_A||''+''||PO_SD_1_2_2_0_3_3_B) PO_SD_1_2_2_0_3_3_DES,';
sqlstringa := sqlstringa || 'DECODE(PO_SD_1_2_2_0_3_3_A||''+''||PO_SD_1_2_2_0_3_3_B,''+'',NULL,PO_SD_1_2_2_0_3_3_A||''+''||PO_SD_1_2_2_0_3_3_B) PO_SD_1_2_2_0_3_3,  ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_4_1_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.4.1'',PO_SD_1_2_2_0_4_1) PO_SD_1_2_2_0_4_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.4.1'',PO_SD_1_2_2_0_4_1) PO_SD_1_2_2_0_4_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.4.1'',PO_SD_1_2_2_0_4_1) PO_SD_1_2_2_0_4_1_DES,';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_4_1, ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_4_2_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.4.2'',PO_SD_1_2_2_0_4_2) PO_SD_1_2_2_0_4_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.4.2'',PO_SD_1_2_2_0_4_2) PO_SD_1_2_2_0_4_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.4.2'',PO_SD_1_2_2_0_4_2) PO_SD_1_2_2_0_4_2_DES,';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_4_2, ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_4_3_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.4.3'',PO_SD_1_2_2_0_4_3) PO_SD_1_2_2_0_4_3_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.4.3'',PO_SD_1_2_2_0_4_3) PO_SD_1_2_2_0_4_3_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.4.3'',PO_SD_1_2_2_0_4_3) PO_SD_1_2_2_0_4_3_DES,';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_4_3, ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_4_4_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.4.4'',PO_SD_1_2_2_0_4_4) PO_SD_1_2_2_0_4_4_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.4.4'',PO_SD_1_2_2_0_4_4) PO_SD_1_2_2_0_4_4_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.4.4'',PO_SD_1_2_2_0_4_4) PO_SD_1_2_2_0_4_4_DES,';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_4_4, ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_4_5_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.4.5'',PO_SD_1_2_2_0_4_5) PO_SD_1_2_2_0_4_5_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.4.5'',PO_SD_1_2_2_0_4_5) PO_SD_1_2_2_0_4_5_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.4.5'',PO_SD_1_2_2_0_4_5) PO_SD_1_2_2_0_4_5_DES,';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_4_5, ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_4_6_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.4.6'',PO_SD_1_2_2_0_4_6) PO_SD_1_2_2_0_4_6_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.4.6'',PO_SD_1_2_2_0_4_6) PO_SD_1_2_2_0_4_6_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.4.6'',PO_SD_1_2_2_0_4_6) PO_SD_1_2_2_0_4_6_DES,';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_4_6 ';
sqlstringa := sqlstringa || 'from '||s_schema||'.BINARI_RACCORDO_PO b, ';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || '(SELECT PO_SD_1_2_2_0_0_2, CODICE_VERSIONE, LISTAGG(PO_SD_1_2_2_0_0_3,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_SD_1_2_2_0_0_3) AS PO_SD_1_2_2_0_0_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_SD_1_2_2_0_0_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_SD_1_2_2_0_0_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_SD_1_2_2_0_0_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_2_0_0_3_CAT_TEN_SD v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where ';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and ';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.2.0.0.3'' and ';
sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_0_3=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_SD_1_2_2_0_0_2, CODICE_VERSIONE) cat_ten ';
sqlstringa := sqlstringa || 'where b.CODICE_VERSIONE='||p_versione;
sqlstringa := sqlstringa || ' and b.CODICE_VERSIONE=cat_ten.CODICE_VERSIONE (+) ';
sqlstringa := sqlstringa || 'and b.SEDE_TECNICA='''||p_PO||''' ';
ELSE
sqlstringa := sqlstringa || '(SELECT PO_SD_1_2_2_0_0_2, LISTAGG(PO_SD_1_2_2_0_0_3,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,PO_SD_1_2_2_0_0_3) AS PO_SD_1_2_2_0_0_3, ';
sqlstringa := sqlstringa || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_SD_1_2_2_0_0_3_XML,';
sqlstringa := sqlstringa || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_SD_1_2_2_0_0_3_OV,';
sqlstringa := sqlstringa || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS PO_SD_1_2_2_0_0_3_DES';
sqlstringa := sqlstringa || ' from '||s_schema||'.PAR_1_2_2_0_0_3_CAT_TEN_SD v,';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa := sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa := sqlstringa || ' where ';
sqlstringa := sqlstringa || ' c.codice_parametro=d.codice_parametro and ';
sqlstringa := sqlstringa || ' numero_parametro=''1.2.2.0.0.3'' and ';
sqlstringa := sqlstringa || ' PO_SD_1_2_2_0_0_3=CODIFICA_VALORE';
sqlstringa := sqlstringa || '  group by PO_SD_1_2_2_0_0_2) cat_ten ';
sqlstringa := sqlstringa || 'where ';
sqlstringa := sqlstringa || 'b.SEDE_TECNICA='''||p_PO||''' ';
END IF;
sqlstringa := sqlstringa || ' and  b.PO_SD_1_2_2_0_0_2=cat_ten.PO_SD_1_2_2_0_0_2 (+)';
sqlstringa := sqlstringa || 'order by 3 ';
OPEN p_cursor FOR sqlstringa;
--DBMS_OUTPUT.PUT_LINE(sqlstringa);
END GetOPSiding_Infrastructure;

-- -----------------------------------------------------------------------------
PROCEDURE GetOPSiding_Inf_EC (p_POSiding VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
--Ritorna l'elenco delle dichiarazioni di verifica EC e EI di  un Binario di Raccordo di una OP
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
    p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
sqlstringa :=  'Select DISTINCT s.PO_SD_1_2_2_0_0_2 POSiding_ID,  ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione,                                      ';
sqlstringa := sqlstringa || 'NVL(PO_SD_1_2_2_0_1_1O2_AP,'''||GetNYA('1.2.2.0.1.1')||''') PO_SD_1_2_2_0_1_1O2_AP, ';
sqlstringa := sqlstringa || 'NVL(PO_SD_1_2_2_0_1_1O2, ''00/00000000000000/0000/000000'') PO_SD_1_2_2_0_1_1O2, ';
sqlstringa := sqlstringa || 'KM_INIZIO,  ';
sqlstringa := sqlstringa || 'KM_FINE     ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from        ';
sqlstringa := sqlstringa || '(select PO_SD_1_2_2_0_0_2,PO_SD_1_2_2_0_1_1O2_AP,PO_SD_1_2_2_0_1_1O2,KM_INIZIO,KM_FINE   ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_RACCORDO_PO ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EC''';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.BINARI_RACCORDO_PO s            ';
sqlstringa := sqlstringa || 'where s.PO_SD_1_2_2_0_0_2=b.PO_SD_1_2_2_0_0_2 (+) and ';
sqlstringa := sqlstringa || 's.PO_SD_1_2_2_0_0_2='''||p_POSiding||''''  ;
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || 'UNION                                                   ';
sqlstringa := sqlstringa || 'Select DISTINCT s.PO_SD_1_2_2_0_0_2 POSiding_ID,  ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||'  CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || '''EI'' tipo_dichiarazione,                                      ';
sqlstringa := sqlstringa || 'NVL(PO_SD_1_2_2_0_1_1O2_AP,'''||GetNYA('1.2.2.0.1.2')||''')  PO_SD_1_2_2_0_1_1O2_AP, ';
sqlstringa := sqlstringa || 'NVL(PO_SD_1_2_2_0_1_1O2, ''00/00000000000000/0000/000000'') PO_SD_1_2_2_0_1_1O2, ';
sqlstringa := sqlstringa || 'KM_INIZIO,  ';
sqlstringa := sqlstringa || 'KM_FINE     ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from        ';
sqlstringa := sqlstringa || '(select PO_SD_1_2_2_0_0_2,PO_SD_1_2_2_0_1_1O2_AP,PO_SD_1_2_2_0_1_1O2,KM_INIZIO,KM_FINE   ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_RACCORDO_PO ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EI''';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.BINARI_RACCORDO_PO s            ';
sqlstringa := sqlstringa || 'where s.PO_SD_1_2_2_0_0_2=b.PO_SD_1_2_2_0_0_2 (+) and ';
sqlstringa := sqlstringa || 's.PO_SD_1_2_2_0_0_2='''||p_POSiding||''''  ;
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || 'order by 2 ';
OPEN p_cursor FOR sqlstringa;
--DBMS_OUTPUT.PUT_LINE(sqlstringa);
END GetOPSiding_Inf_EC;

-- -----------------------------------------------------------------------------
PROCEDURE GetOPSiding_Inf_Tunnel (p_POSiding VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
--Ritorna l'elenco delle gallerie di  un Binario di Raccordo di una OP, con relativi parametri
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
sqlstringa := 'Select DISTINCT PO_SD_1_2_2_0_0_2 POSiding_ID,  ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.5.1'',g.PO_SD_TUNNEL_1_2_2_0_5_1) PO_SD_TUNNEL_1_2_2_0_5_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.5.1'',g.PO_SD_TUNNEL_1_2_2_0_5_1) PO_SD_TUNNEL_1_2_2_0_5_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.5.1'',g.PO_SD_TUNNEL_1_2_2_0_5_1) PO_SD_TUNNEL_1_2_2_0_5_1_DES,';
sqlstringa := sqlstringa || 'NVL( g.PO_SD_TUNNEL_1_2_2_0_5_1, ''0083'')  PO_SD_TUNNEL_1_2_2_0_5_1, ';
sqlstringa := sqlstringa || 'g.PO_SD_TUNNEL_1_2_2_0_5_2 PO_SD_TUNNEL_1_2_2_0_5_2,  ';
sqlstringa := sqlstringa || 'g.PO_SD_TUNNEL_1_2_2_0_5_2_D PO_SD_TUNNEL_1_2_2_0_5_2_DES,  ';
sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_5_AP, ';
sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_5, ';
sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_6_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.5.6'',PO_SD_TUNNEL_1_2_2_0_5_6) PO_SD_TUNNEL_1_2_2_0_5_6_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.5.6'',PO_SD_TUNNEL_1_2_2_0_5_6) PO_SD_TUNNEL_1_2_2_0_5_6_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.5.6'',PO_SD_TUNNEL_1_2_2_0_5_6) PO_SD_TUNNEL_1_2_2_0_5_6_DES,';
sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_6, ';
sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_7_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.5.7'',PO_SD_TUNNEL_1_2_2_0_5_7) PO_SD_TUNNEL_1_2_2_0_5_7_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.5.7'',PO_SD_TUNNEL_1_2_2_0_5_7) PO_SD_TUNNEL_1_2_2_0_5_7_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.5.7'',PO_SD_TUNNEL_1_2_2_0_5_7) PO_SD_TUNNEL_1_2_2_0_5_7_DES,';
sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_7, ';
sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_8_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.2.0.5.8'',PO_SD_TUNNEL_1_2_2_0_5_8) PO_SD_TUNNEL_1_2_2_0_5_8_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.2.0.5.8'',PO_SD_TUNNEL_1_2_2_0_5_8) PO_SD_TUNNEL_1_2_2_0_5_8_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.2.0.5.8'',PO_SD_TUNNEL_1_2_2_0_5_8) PO_SD_TUNNEL_1_2_2_0_5_8_DES,';
sqlstringa := sqlstringa || 'PO_SD_TUNNEL_1_2_2_0_5_8 ';
sqlstringa := sqlstringa || 'from '||s_schema||'.GALLERIE_RACCORDO_PO g,  ';
sqlstringa := sqlstringa || s_schema||'.REL_GALLERIE_RACCORDO_PO r  ';
sqlstringa := sqlstringa || 'where   ';
sqlstringa := sqlstringa || 'r.PO_SD_TUNNEL_1_2_2_0_5_2=G.PO_SD_TUNNEL_1_2_2_0_5_2 and  ';
sqlstringa := sqlstringa || 'PO_SD_1_2_2_0_0_2='''||p_POSiding||'''   ';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and g.CODICE_VERSIONE='||p_versione;
sqlstringa := sqlstringa || 'and r.CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || 'order by 2  ';
OPEN p_cursor FOR sqlstringa;
END GetOPSiding_Inf_Tunnel;
PROCEDURE GetOPSiding_Inf_Tunnel_EC (p_POSiding_Tunnel VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
--Ritorna l'elenco delle dichiarazioni di verifica EC e EI di una galleriadi  un Binario di Raccordo di una OP
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
sqlstringa :=  'Select DISTINCT s.PO_SD_TUNNEL_1_2_2_0_5_2 POSiding_Tunnel_ID,  ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione,                                      ';
sqlstringa := sqlstringa || 'NVL(PO_SD_TUNNEL_1_2_2_0_5_3O4_AP,'''||GetNYA('1.2.2.0.5.3')||''') PO_SD_TUNNEL_1_2_2_0_5_3O4_AP, ';
sqlstringa := sqlstringa || 'NVL(PO_SD_TUNNEL_1_2_2_0_5_3O4, ''00/00000000000000/0000/000000'') PO_SD_TUNNEL_1_2_2_0_5_3O4, ';
sqlstringa := sqlstringa || 'KM_INIZIO,  ';
sqlstringa := sqlstringa || 'KM_FINE     ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from        ';
sqlstringa := sqlstringa || '(select PO_SD_TUNNEL_1_2_2_0_5_2,PO_SD_TUNNEL_1_2_2_0_5_3O4_AP,PO_SD_TUNNEL_1_2_2_0_5_3O4,KM_INIZIO,KM_FINE   ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_GALLERIE_SD_PO ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EC''';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_RACCORDO_PO s            ';
sqlstringa := sqlstringa || 'where s.PO_SD_TUNNEL_1_2_2_0_5_2=b.PO_SD_TUNNEL_1_2_2_0_5_2 (+) and ';
sqlstringa := sqlstringa || 's.PO_SD_TUNNEL_1_2_2_0_5_2='''||p_POSiding_Tunnel||''''  ;
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || 'UNION                                                   ';
sqlstringa := sqlstringa || 'Select DISTINCT s.PO_SD_TUNNEL_1_2_2_0_5_2 POSiding_Tunnel_ID,  ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || '''EI'' tipo_dichiarazione,                                      ';
sqlstringa := sqlstringa || 'NVL(PO_SD_TUNNEL_1_2_2_0_5_3O4_AP,'''||GetNYA('1.2.2.0.5.4')||''') PO_SD_TUNNEL_1_2_2_0_5_3O4_AP, ';
sqlstringa := sqlstringa || 'NVL(PO_SD_TUNNEL_1_2_2_0_5_3O4, ''00/00000000000000/0000/000000'') PO_SD_TUNNEL_1_2_2_0_5_3O4, ';
sqlstringa := sqlstringa || 'KM_INIZIO,  ';
sqlstringa := sqlstringa || 'KM_FINE     ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from        ';
sqlstringa := sqlstringa || '(select PO_SD_TUNNEL_1_2_2_0_5_2,PO_SD_TUNNEL_1_2_2_0_5_3O4_AP,PO_SD_TUNNEL_1_2_2_0_5_3O4,KM_INIZIO,KM_FINE   ';
--05/02/2018 LAM da decommentare
--sqlstringa := sqlstringa || ' , LATITUDINE_INIZIO, LONGITUDINE_INIZIO, LATITUDINE_FINE, LONGITUDINE_FINE ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_GALLERIE_SD_PO ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EI''';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_RACCORDO_PO s            ';
sqlstringa := sqlstringa || 'where s.PO_SD_TUNNEL_1_2_2_0_5_2=b.PO_SD_TUNNEL_1_2_2_0_5_2 (+) and ';
sqlstringa := sqlstringa || 's.PO_SD_TUNNEL_1_2_2_0_5_2='''||p_POSiding_Tunnel||''''  ;
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || 'order by 3,6 ';
OPEN p_cursor FOR sqlstringa;
END GetOPSiding_Inf_Tunnel_EC;

-- -----------------------------------------------------------------------------
--                         ----------- SOL -------------
-- -----------------------------------------------------------------------------
PROCEDURE GetSOL_General (p_SOL VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur) IS
-- Ritorna i dati principali della SOL
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
sqlstringa :=  'SELECT s.SEDE_TECNICA SOL_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.0.0.0.1'',SOL_1_1_0_0_0_1) SOL_1_1_0_0_0_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.0.0.0.1'',SOL_1_1_0_0_0_1) SOL_1_1_0_0_0_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.0.0.0.1'',SOL_1_1_0_0_0_1) SOL_1_1_0_0_0_1_DES,';
sqlstringa := sqlstringa || 'NVL(SOL_1_1_0_0_0_1,''0083'') SOL_1_1_0_0_0_1, ';
sqlstringa := sqlstringa || 'NVL(TRIM(linea_comm.linea),''0000'') SOL_1_1_0_0_0_2,  ';
sqlstringa := sqlstringa || 'SOL_1_1_0_0_0_3, ';
sqlstringa := sqlstringa || 'p_i.DEFINIZIONE LOCALITA_INIZIO, ';
sqlstringa := sqlstringa || 'SOL_1_1_0_0_0_4, ';
sqlstringa := sqlstringa || 'p_f.DEFINIZIONE LOCALITA_FINE, ';
sqlstringa := sqlstringa || 'TRIM(TO_CHAR(ROUND(SOL_1_1_0_0_0_5,3),''999990.999'')) SOL_1_1_0_0_0_5, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.0.0.0.6'',SOL_1_1_0_0_0_6) SOL_1_1_0_0_0_6_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.0.0.0.6'',SOL_1_1_0_0_0_6) SOL_1_1_0_0_0_6_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.0.0.0.6'',SOL_1_1_0_0_0_6) SOL_1_1_0_0_0_6_DES,';
sqlstringa := sqlstringa || 'SOL_1_1_0_0_0_6, ';
sqlstringa := sqlstringa || 's.KM_INIZIO KM_INIZIO, ';
sqlstringa := sqlstringa || 's.KM_FINE KM_FINE, ';
sqlstringa := sqlstringa || 's.CACHE_FIELD ';
sqlstringa := sqlstringa || 'from '||s_schema||'.SEZIONI_LINEA s, ';
sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI p_i, ';
sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI p_f, ';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || '(SELECT SEDE_TECNICA, LISTAGG(REPLACE(CODICE,'' '','''') ||'' '') WITHIN GROUP (ORDER BY CODICE) AS linea ';
sqlstringa := sqlstringa || 'from '||s_schema||'.V_MDR_LINEE_COMMERCIALI ';
sqlstringa := sqlstringa || ' where ';
sqlstringa := sqlstringa || ' CODICE_VERSIONE='||p_versione ;
sqlstringa := sqlstringa || ' GROUP BY SEDE_TECNICA) linea_comm ';
ELSE
sqlstringa := sqlstringa || '(SELECT SEDE_TECNICA, LISTAGG(REPLACE(CODICE,'' '','''') ||'' '') WITHIN GROUP (ORDER BY CODICE) AS linea ';
sqlstringa := sqlstringa || 'from '||s_schema||'.V_MDR_LINEE_COMMERCIALI ';
sqlstringa := sqlstringa || ' GROUP BY SEDE_TECNICA) linea_comm ';
END IF;
sqlstringa := sqlstringa || 'WHERE s.LOCALITA_INIZIO=p_i.SEDE_TECNICA ';
sqlstringa := sqlstringa || ' and s.LOCALITA_FINE=p_f.SEDE_TECNICA ';
sqlstringa := sqlstringa || ' and s.SEDE_TECNICA='''||p_SOL||''' ';
sqlstringa := sqlstringa || ' and s.SEDE_TECNICA=linea_comm.SEDE_TECNICA (+)';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and s.CODICE_VERSIONE='||p_versione;
sqlstringa := sqlstringa || 'and p_i.CODICE_VERSIONE='||p_versione;
sqlstringa := sqlstringa || 'and p_f.CODICE_VERSIONE='||p_versione;
END IF;
OPEN p_cursor FOR sqlstringa;
DBMS_OUTPUT.PUT_LINE(sqlstringa);
END GetSOL_General;

-- -----------------------------------------------------------------------------
PROCEDURE GetTracks_General (p_SOL VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur) IS
--Ritorna i  Binari di Corsa di una SOL con relativi parametri
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(32767);
sqlstringa2 VARCHAR2(32767);
sqlstringa3 VARCHAR2(32767);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
sqlstringa :=  'Select s.SEDE_TECNICA SOL_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1,      ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1_D SOL_TRACK_1_1_1_0_0_1_DES,      ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.0.0.2'',SOL_TRACK_1_1_1_0_0_2) SOL_TRACK_1_1_1_0_0_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.0.0.2'',SOL_TRACK_1_1_1_0_0_2) SOL_TRACK_1_1_1_0_0_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.0.0.2'',SOL_TRACK_1_1_1_0_0_2) SOL_TRACK_1_1_1_0_0_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_0_0_2_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_0_0_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_1_AP ,';
sqlstringa := sqlstringa || 'cat_ten.SOL_TRACK_1_1_1_1_2_1_XML,';
sqlstringa := sqlstringa || 'cat_ten.SOL_TRACK_1_1_1_1_2_1_OV,';
sqlstringa := sqlstringa || 'cat_ten.SOL_TRACK_1_1_1_1_2_1 SOL_TRACK_1_1_1_1_2_1_DES,';
sqlstringa := sqlstringa || 'cat_ten.SOL_TRACK_1_1_1_1_2_1_DES SOL_TRACK_1_1_1_1_2_1,      ';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_2_1_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_2_AP ,';
sqlstringa := sqlstringa || 'cat_linea.SOL_TRACK_1_1_1_1_2_2_XML,';
sqlstringa := sqlstringa || 'cat_linea.SOL_TRACK_1_1_1_1_2_2_OV,';
sqlstringa := sqlstringa || 'cat_linea.SOL_TRACK_1_1_1_1_2_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_2_2_SET ,      ';
sqlstringa := sqlstringa || 'cat_linea.SOL_TRACK_1_1_1_1_2_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_3_AP ,';
sqlstringa := sqlstringa || 'corridoio.SOL_TRACK_1_1_1_1_2_3_XML,';
sqlstringa := sqlstringa || 'corridoio.SOL_TRACK_1_1_1_1_2_3_OV,';
sqlstringa := sqlstringa || 'corridoio.SOL_TRACK_1_1_1_1_2_3 SOL_TRACK_1_1_1_1_2_3_DES,';
sqlstringa := sqlstringa || 'corridoio.SOL_TRACK_1_1_1_1_2_3_DES SOL_TRACK_1_1_1_1_2_3,      ';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_2_3_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_4_AP ,';
sqlstringa := sqlstringa || 'cap_carico.SOL_TRACK_1_1_1_1_2_4_XML,';
sqlstringa := sqlstringa || 'cap_carico.SOL_TRACK_1_1_1_1_2_4_OV,';
sqlstringa := sqlstringa || 'cap_carico.SOL_TRACK_1_1_1_1_2_4_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_2_4_SET ,      ';
sqlstringa := sqlstringa || 'cap_carico.SOL_TRACK_1_1_1_1_2_4,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_5_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.2.5'',SOL_TRACK_1_1_1_1_2_5) SOL_TRACK_1_1_1_1_2_5_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.2.5'',SOL_TRACK_1_1_1_1_2_5) SOL_TRACK_1_1_1_1_2_5_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.2.5'',SOL_TRACK_1_1_1_1_2_5) SOL_TRACK_1_1_1_1_2_5_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_2_5_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_5,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_6_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.2.6'',SOL_TRACK_1_1_1_1_2_6) SOL_TRACK_1_1_1_1_2_6_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.2.6'',SOL_TRACK_1_1_1_1_2_6) SOL_TRACK_1_1_1_1_2_6_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.2.6'',SOL_TRACK_1_1_1_1_2_6) SOL_TRACK_1_1_1_1_2_6_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_2_6_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_6,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_7_AP ,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_2_7_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_7,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_8_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.2.8'',SOL_TRACK_1_1_1_1_2_8) SOL_TRACK_1_1_1_1_2_8_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.2.8'',SOL_TRACK_1_1_1_1_2_8) SOL_TRACK_1_1_1_1_2_8_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.2.8'',SOL_TRACK_1_1_1_1_2_8) SOL_TRACK_1_1_1_1_2_8_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_2_8_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_2_8,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.3.1'',SOL_TRACK_1_1_1_1_3_1) SOL_TRACK_1_1_1_1_3_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.3.1'',SOL_TRACK_1_1_1_1_3_1) SOL_TRACK_1_1_1_1_3_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.3.1'',SOL_TRACK_1_1_1_1_3_1) SOL_TRACK_1_1_1_1_3_1_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_3_1_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_2_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.3.2'',SOL_TRACK_1_1_1_1_3_2) SOL_TRACK_1_1_1_1_3_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.3.2'',SOL_TRACK_1_1_1_1_3_2) SOL_TRACK_1_1_1_1_3_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.3.2'',SOL_TRACK_1_1_1_1_3_2) SOL_TRACK_1_1_1_1_3_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_3_2_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_3_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.3.3'',SOL_TRACK_1_1_1_1_3_3) SOL_TRACK_1_1_1_1_3_3_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.3.3'',SOL_TRACK_1_1_1_1_3_3) SOL_TRACK_1_1_1_1_3_3_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.3.3'',SOL_TRACK_1_1_1_1_3_3) SOL_TRACK_1_1_1_1_3_3_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_3_3_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_3,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_4_AP ,';
sqlstringa := sqlstringa || 'prof_casse.SOL_TRACK_1_1_1_1_3_4_XML,';
sqlstringa := sqlstringa || 'prof_casse.SOL_TRACK_1_1_1_1_3_4_OV,';
sqlstringa := sqlstringa || 'prof_casse.SOL_TRACK_1_1_1_1_3_4_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_3_4_SET ,      ';
sqlstringa := sqlstringa || 'prof_casse.SOL_TRACK_1_1_1_1_3_4,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_5_AP ,';
sqlstringa := sqlstringa || 'prof_semir.SOL_TRACK_1_1_1_1_3_5_XML,';
sqlstringa := sqlstringa || 'prof_semir.SOL_TRACK_1_1_1_1_3_5_OV,';
sqlstringa := sqlstringa || 'prof_semir.SOL_TRACK_1_1_1_1_3_5_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_3_5_SET ,      ';
sqlstringa := sqlstringa || 'prof_semir.SOL_TRACK_1_1_1_1_3_5,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_6_AP ,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_3_6_SET ,      ';
sqlstringa := sqlstringa || 'p.gradiente SOL_TRACK_1_1_1_1_3_6,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_7_AP ,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_3_7_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_3_7,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.4.1'',SOL_TRACK_1_1_1_1_4_1) SOL_TRACK_1_1_1_1_4_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.4.1'',SOL_TRACK_1_1_1_1_4_1) SOL_TRACK_1_1_1_1_4_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.4.1'',SOL_TRACK_1_1_1_1_4_1) SOL_TRACK_1_1_1_1_4_1_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_4_1_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_2_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.4.2'',SOL_TRACK_1_1_1_1_4_2) SOL_TRACK_1_1_1_1_4_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.4.2'',SOL_TRACK_1_1_1_1_4_2) SOL_TRACK_1_1_1_1_4_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.4.2'',SOL_TRACK_1_1_1_1_4_2) SOL_TRACK_1_1_1_1_4_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_4_2_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_3_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.4.3'',SOL_TRACK_1_1_1_1_4_3) SOL_TRACK_1_1_1_1_4_3_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.4.3'',SOL_TRACK_1_1_1_1_4_3) SOL_TRACK_1_1_1_1_4_3_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.4.3'',SOL_TRACK_1_1_1_1_4_3) SOL_TRACK_1_1_1_1_4_3_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_4_3_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_3,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_4_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.4.4'',SOL_TRACK_1_1_1_1_4_4) SOL_TRACK_1_1_1_1_4_4_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.4.4'',SOL_TRACK_1_1_1_1_4_4) SOL_TRACK_1_1_1_1_4_4_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.4.4'',SOL_TRACK_1_1_1_1_4_4) SOL_TRACK_1_1_1_1_4_4_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_4_4_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_4_4,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_5_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.5.1'',SOL_TRACK_1_1_1_1_5_1) SOL_TRACK_1_1_1_1_5_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.5.1'',SOL_TRACK_1_1_1_1_5_1) SOL_TRACK_1_1_1_1_5_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.5.1'',SOL_TRACK_1_1_1_1_5_1) SOL_TRACK_1_1_1_1_5_1_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_5_1_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_5_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_5_2_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.5.2'',SOL_TRACK_1_1_1_1_5_2) SOL_TRACK_1_1_1_1_5_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.5.2'',SOL_TRACK_1_1_1_1_5_2) SOL_TRACK_1_1_1_1_5_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.5.2'',SOL_TRACK_1_1_1_1_5_2) SOL_TRACK_1_1_1_1_5_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_5_2_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_5_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.6.1'',SOL_TRACK_1_1_1_1_6_1) SOL_TRACK_1_1_1_1_6_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.6.1'',SOL_TRACK_1_1_1_1_6_1) SOL_TRACK_1_1_1_1_6_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.6.1'',SOL_TRACK_1_1_1_1_6_1) SOL_TRACK_1_1_1_1_6_1_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_6_1_SET ,      ';
sqlstringa := sqlstringa || 'TRIM(SOL_TRACK_1_1_1_1_6_1) SOL_TRACK_1_1_1_1_6_1,      ';
--sqlstringa := sqlstringa || 'TRIM(TO_CHAR(ROUND(SOL_TRACK_1_1_1_1_6_1,1),''999990.9'')) SOL_TRACK_1_1_1_1_6_1,      '; campo numerico in INE ma stringa nel db
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_2_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.6.2'',SOL_TRACK_1_1_1_1_6_2) SOL_TRACK_1_1_1_1_6_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.6.2'',SOL_TRACK_1_1_1_1_6_2) SOL_TRACK_1_1_1_1_6_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.6.2'',SOL_TRACK_1_1_1_1_6_2) SOL_TRACK_1_1_1_1_6_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_6_2_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_3_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.6.3'',SOL_TRACK_1_1_1_1_6_3) SOL_TRACK_1_1_1_1_6_3_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.6.3'',SOL_TRACK_1_1_1_1_6_3) SOL_TRACK_1_1_1_1_6_3_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.6.3'',SOL_TRACK_1_1_1_1_6_3) SOL_TRACK_1_1_1_1_6_3_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_6_3_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_6_3,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.7.1'',SOL_TRACK_1_1_1_1_7_1) SOL_TRACK_1_1_1_1_7_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.7.1'',SOL_TRACK_1_1_1_1_7_1) SOL_TRACK_1_1_1_1_7_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.7.1'',SOL_TRACK_1_1_1_1_7_1) SOL_TRACK_1_1_1_1_7_1_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_7_1_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_2_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.7.2'',SOL_TRACK_1_1_1_1_7_2) SOL_TRACK_1_1_1_1_7_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.7.2'',SOL_TRACK_1_1_1_1_7_2) SOL_TRACK_1_1_1_1_7_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.7.2'',SOL_TRACK_1_1_1_1_7_2) SOL_TRACK_1_1_1_1_7_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_7_2_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_1_7_3_AP ,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_1_7_3_SET ,      ';
sqlstringa := sqlstringa || 'TRIM(TO_CHAR(ROUND(SOL_TRACK_1_1_1_1_7_3,1),''999990.9'')) SOL_TRACK_1_1_1_1_7_3,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_1_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1) SOL_TRACK_1_1_1_2_2_1_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1) SOL_TRACK_1_1_1_2_2_1_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1) SOL_TRACK_1_1_1_2_2_1_1_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1,SOL_TRACK_1_1_1_2_2_1_1_AP) SOL_TRACK_1_1_1_2_2_1_1_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_1_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_1_2_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.2.1.2'',SOL_TRACK_1_1_1_2_2_1_2) SOL_TRACK_1_1_1_2_2_1_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.2.1.2'',SOL_TRACK_1_1_1_2_2_1_2) SOL_TRACK_1_1_1_2_2_1_2_OV,';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_1_2 SOL_TRACK_1_1_1_2_2_1_2_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.2.1.2'',SOL_TRACK_1_1_1_2_2_1_2) SOL_TRACK_1_1_1_2_2_1_2,      ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1,SOL_TRACK_1_1_1_2_2_1_1_AP) SOL_TRACK_1_1_1_2_2_1_2_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_2_AP ,';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_2,      ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1,SOL_TRACK_1_1_1_2_2_1_1_AP) SOL_TRACK_1_1_1_2_2_2_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_3_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1,SOL_TRACK_1_1_1_2_2_1_1_AP) SOL_TRACK_1_1_1_2_2_3_SET ,      '; --SET reale maggio 2015
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_3,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_4_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.2.4'',SOL_TRACK_1_1_1_2_2_4) SOL_TRACK_1_1_1_2_2_4_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.2.4'',SOL_TRACK_1_1_1_2_2_4) SOL_TRACK_1_1_1_2_2_4_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.2.4'',SOL_TRACK_1_1_1_2_2_4) SOL_TRACK_1_1_1_2_2_4_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1,SOL_TRACK_1_1_1_2_2_1_1_AP) SOL_TRACK_1_1_1_2_2_4_SET ,      '; --Set reale maggio 2015
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_4,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_5_AP ,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_2_5_SET ,      ';
sqlstringa := sqlstringa || 'TRIM(TO_CHAR(ROUND(SOL_TRACK_1_1_1_2_2_5,2),''999990.99'')) SOL_TRACK_1_1_1_2_2_5,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_2_6_AP ,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_2_6_SET ,      ';
sqlstringa := sqlstringa || 'TRIM(TO_CHAR(ROUND(SOL_TRACK_1_1_1_2_2_6,2),''999990.99'')) SOL_TRACK_1_1_1_2_2_6,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.3.1'',SOL_TRACK_1_1_1_2_3_1) SOL_TRACK_1_1_1_2_3_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.3.1'',SOL_TRACK_1_1_1_2_3_1) SOL_TRACK_1_1_1_2_3_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.3.1'',SOL_TRACK_1_1_1_2_3_1) SOL_TRACK_1_1_1_2_3_1_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_3_1_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_2_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.3.2'',SOL_TRACK_1_1_1_2_3_2) SOL_TRACK_1_1_1_2_3_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.3.2'',SOL_TRACK_1_1_1_2_3_2) SOL_TRACK_1_1_1_2_3_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.3.2'',SOL_TRACK_1_1_1_2_3_2) SOL_TRACK_1_1_1_2_3_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_3_2_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_3_AP ,';
sqlstringa := sqlstringa || 'DECODE(PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.3.3.A'',SOL_TRACK_1_1_1_2_3_3_A)||'' ''|| PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.3.3.B'',SOL_TRACK_1_1_1_2_3_3_B)||'' ''||PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.3.3.C'',SOL_TRACK_1_1_1_2_3_3_C),''++'',NULL,PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.3.3.A'',SOL_TRACK_1_1_1_2_3_3_A)||'' ''|| PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.3.3.B'',SOL_TRACK_1_1_1_2_3_3_B)||'' ''||PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.3.3.C'',SOL_TRACK_1_1_1_2_3_3_C)) SOL_TRACK_1_1_1_2_3_3_XML,';
sqlstringa := sqlstringa || 'DECODE(PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.3.3.A'',SOL_TRACK_1_1_1_2_3_3_A)||'' ''|| PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.3.3.B'',SOL_TRACK_1_1_1_2_3_3_B)||'' ''||PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.3.3.C'',SOL_TRACK_1_1_1_2_3_3_C),''++'',NULL,PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.3.3.A'',SOL_TRACK_1_1_1_2_3_3_A)||'' ''|| PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.3.3.B'',SOL_TRACK_1_1_1_2_3_3_B)||'' ''||PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.3.3.C'',SOL_TRACK_1_1_1_2_3_3_C)) SOL_TRACK_1_1_1_2_3_3_OV,';
sqlstringa := sqlstringa || 'DECODE(PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.3.3.A'',SOL_TRACK_1_1_1_2_3_3_A)||'' ''|| PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.3.3.B'',SOL_TRACK_1_1_1_2_3_3_B)||'' ''||PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.3.3.C'',SOL_TRACK_1_1_1_2_3_3_C),''++'',NULL,PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.3.3.A'',SOL_TRACK_1_1_1_2_3_3_A)||'' ''|| PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.3.3.B'',SOL_TRACK_1_1_1_2_3_3_B)||'' ''||PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.3.3.C'',SOL_TRACK_1_1_1_2_3_3_C)) SOL_TRACK_1_1_1_2_3_3_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_3_3_SET ,      ';
sqlstringa := sqlstringa || 'DECODE(SOL_TRACK_1_1_1_2_3_3_A||'' ''||SOL_TRACK_1_1_1_2_3_3_B||'' ''||SOL_TRACK_1_1_1_2_3_3_C,''++'',NULL,SOL_TRACK_1_1_1_2_3_3_A||'' ''||SOL_TRACK_1_1_1_2_3_3_B||'' ''||SOL_TRACK_1_1_1_2_3_3_C) SOL_TRACK_1_1_1_2_3_3,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_4_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.3.4'',SOL_TRACK_1_1_1_2_3_4) SOL_TRACK_1_1_1_2_3_4_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.3.4'',SOL_TRACK_1_1_1_2_3_4) SOL_TRACK_1_1_1_2_3_4_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.3.4'',SOL_TRACK_1_1_1_2_3_4) SOL_TRACK_1_1_1_2_3_4_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_3_4_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_3_4,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_1_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.1.1'',SOL_TRACK_1_1_1_2_4_1_1) SOL_TRACK_1_1_1_2_4_1_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.4.1.1'',SOL_TRACK_1_1_1_2_4_1_1) SOL_TRACK_1_1_1_2_4_1_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.1.1'',SOL_TRACK_1_1_1_2_4_1_1) SOL_TRACK_1_1_1_2_4_1_1_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_4_1_1_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_1_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_1_2_AP ,';
sqlstringa := sqlstringa || 'DECODE(SOL_TRACK_1_1_1_2_4_1_2_A||''+''|| PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.1.2.B'',SOL_TRACK_1_1_1_2_4_1_2_B)||''+''||PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.1.2.C'',SOL_TRACK_1_1_1_2_4_1_2_C),''++'',NULL,''length ''||SOL_TRACK_1_1_1_2_4_1_2_A||'' + switch off breaker ''|| PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.1.2.B'',SOL_TRACK_1_1_1_2_4_1_2_B)||'' + lower pantograph ''||PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.1.2.C'',SOL_TRACK_1_1_1_2_4_1_2_C)) SOL_TRACK_1_1_1_2_4_1_2_XML,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_4_1_2_OV,';
sqlstringa := sqlstringa || 'DECODE(PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.1.2.A'',SOL_TRACK_1_1_1_2_4_1_2_A)||''+''|| PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.1.2.B'',SOL_TRACK_1_1_1_2_4_1_2_B)||''+''||PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.1.2.C'',SOL_TRACK_1_1_1_2_4_1_2_C),''++'',NULL,''length ''||PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.1.2.A'',SOL_TRACK_1_1_1_2_4_1_2_A)||'' + switch off breaker ''|| PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.1.2.B'',SOL_TRACK_1_1_1_2_4_1_2_B)||'' + lower pantograph ''||PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.1.2.C'',SOL_TRACK_1_1_1_2_4_1_2_C)) SOL_TRACK_1_1_1_2_4_1_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_4_1_2_SET ,      ';
sqlstringa := sqlstringa || 'DECODE(SOL_TRACK_1_1_1_2_4_1_2_A||''+''||SOL_TRACK_1_1_1_2_4_1_2_B||''+''||SOL_TRACK_1_1_1_2_4_1_2_C,''++'',NULL,''length ''||SOL_TRACK_1_1_1_2_4_1_2_A||'' + switch off breaker ''||SOL_TRACK_1_1_1_2_4_1_2_B||'' + lower pantograph ''||SOL_TRACK_1_1_1_2_4_1_2_C) SOL_TRACK_1_1_1_2_4_1_2,  ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_2_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.2.1'',SOL_TRACK_1_1_1_2_4_2_1) SOL_TRACK_1_1_1_2_4_2_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.4.2.1'',SOL_TRACK_1_1_1_2_4_2_1) SOL_TRACK_1_1_1_2_4_2_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.2.1'',SOL_TRACK_1_1_1_2_4_2_1) SOL_TRACK_1_1_1_2_4_2_1_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_4_2_1_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_2_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_4_2_2_AP ,';
sqlstringa := sqlstringa || 'DECODE(PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.2.2.A'',SOL_TRACK_1_1_1_2_4_2_2_A)||''+''||PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.2.2.B'',SOL_TRACK_1_1_1_2_4_2_2_b)||''+''||PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.2.2.C'',SOL_TRACK_1_1_1_2_4_2_2_C)||''+''||PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.2.2.D'',SOL_TRACK_1_1_1_2_4_2_2_D),''+++'',NULL,''length ''||PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.2.2.A'',SOL_TRACK_1_1_1_2_4_2_2_A)||'' + switch off breaker ''||PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.2.2.B'',SOL_TRACK_1_1_1_2_4_2_2_b)||'' + lower pantograph ''||PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.2.2.C'',SOL_TRACK_1_1_1_2_4_2_2_C)||'' + change supply system ''||PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.4.2.2.D'',SOL_TRACK_1_1_1_2_4_2_2_D)) SOL_TRACK_1_1_1_2_4_2_2_XML,';
sqlstringa := sqlstringa || 'DECODE(PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.4.2.2.A'',SOL_TRACK_1_1_1_2_4_2_2_A)||''+''||PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.4.2.2.B'',SOL_TRACK_1_1_1_2_4_2_2_b)||''+''||PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.4.2.2.C'',SOL_TRACK_1_1_1_2_4_2_2_C)||''+''||PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.4.2.2.D'',SOL_TRACK_1_1_1_2_4_2_2_D),''+++'',NULL, ''length ''||PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.4.2.2.A'',SOL_TRACK_1_1_1_2_4_2_2_A)||'' + switch off breaker ''||PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.4.2.2.B'',SOL_TRACK_1_1_1_2_4_2_2_b)||'' + lower pantograph ''||PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.4.2.2.C'',SOL_TRACK_1_1_1_2_4_2_2_C)||'' + change supply system ''||PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.4.2.2.D'',SOL_TRACK_1_1_1_2_4_2_2_D))SOL_TRACK_1_1_1_2_4_2_2_OV,';
sqlstringa := sqlstringa || 'DECODE(PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.2.2.A'',SOL_TRACK_1_1_1_2_4_2_2_A)||''+''||PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.2.2.B'',SOL_TRACK_1_1_1_2_4_2_2_b)||''+''||PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.2.2.C'',SOL_TRACK_1_1_1_2_4_2_2_C)||''+''||PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.2.2.D'',SOL_TRACK_1_1_1_2_4_2_2_D),''+++'',NULL,''length ''||PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.2.2.A'',SOL_TRACK_1_1_1_2_4_2_2_A)||'' + switch off breaker ''||PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.2.2.B'',SOL_TRACK_1_1_1_2_4_2_2_b)||'' + lower pantograph ''||PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.2.2.C'',SOL_TRACK_1_1_1_2_4_2_2_C)||'' + change supply system ''||PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.4.2.2.D'',SOL_TRACK_1_1_1_2_4_2_2_D)) SOL_TRACK_1_1_1_2_4_2_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_4_2_2_SET ,      ';
sqlstringa := sqlstringa || 'DECODE(SOL_TRACK_1_1_1_2_4_2_2_A||''+''||SOL_TRACK_1_1_1_2_4_2_2_B||''+''||SOL_TRACK_1_1_1_2_4_2_2_C||''+''||SOL_TRACK_1_1_1_2_4_2_2_D,''+++'',NULL,''length ''||SOL_TRACK_1_1_1_2_4_2_2_A||'' + switch off breaker ''||SOL_TRACK_1_1_1_2_4_2_2_B||'' + lower pantograph ''||SOL_TRACK_1_1_1_2_4_2_2_C||'' + change supply system ''||SOL_TRACK_1_1_1_2_4_2_2_D) SOL_TRACK_1_1_1_2_4_2_2,  ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_5_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.5.1'',SOL_TRACK_1_1_1_2_5_1) SOL_TRACK_1_1_1_2_5_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.5.1'',SOL_TRACK_1_1_1_2_5_1) SOL_TRACK_1_1_1_2_5_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.5.1'',SOL_TRACK_1_1_1_2_5_1) SOL_TRACK_1_1_1_2_5_1_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.2.2.1.1'',SOL_TRACK_1_1_1_2_2_1_1,SOL_TRACK_1_1_1_2_2_1_1_AP) SOL_TRACK_1_1_1_2_5_1_SET ,      '; --SET reale maggio 2015
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_5_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_5_2_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.5.2'',SOL_TRACK_1_1_1_2_5_2) SOL_TRACK_1_1_1_2_5_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.5.2'',SOL_TRACK_1_1_1_2_5_2) SOL_TRACK_1_1_1_2_5_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.5.2'',SOL_TRACK_1_1_1_2_5_2) SOL_TRACK_1_1_1_2_5_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_5_2_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_5_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_5_3_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.2.5.3'',SOL_TRACK_1_1_1_2_5_3) SOL_TRACK_1_1_1_2_5_3_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.2.5.3'',SOL_TRACK_1_1_1_2_5_3) SOL_TRACK_1_1_1_2_5_3_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.2.5.3'',SOL_TRACK_1_1_1_2_5_3) SOL_TRACK_1_1_1_2_5_3_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_2_5_3_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_2_5_3,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.2.1'',SOL_TRACK_1_1_1_3_2_1) SOL_TRACK_1_1_1_3_2_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.2.1'',SOL_TRACK_1_1_1_3_2_1) SOL_TRACK_1_1_1_3_2_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.2.1'',SOL_TRACK_1_1_1_3_2_1) SOL_TRACK_1_1_1_3_2_1_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.2.1'',SOL_TRACK_1_1_1_3_2_1,SOL_TRACK_1_1_1_3_2_1_AP) SOL_TRACK_1_1_1_3_2_1_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_2_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.2.2'',SOL_TRACK_1_1_1_3_2_2) SOL_TRACK_1_1_1_3_2_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.2.2'',SOL_TRACK_1_1_1_3_2_2) SOL_TRACK_1_1_1_3_2_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.2.2'',SOL_TRACK_1_1_1_3_2_2) SOL_TRACK_1_1_1_3_2_2_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.2.1'',SOL_TRACK_1_1_1_3_2_1,SOL_TRACK_1_1_1_3_2_1_AP) SOL_TRACK_1_1_1_3_2_2_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_3_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.2.3'',SOL_TRACK_1_1_1_3_2_3) SOL_TRACK_1_1_1_3_2_3_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.2.3'',SOL_TRACK_1_1_1_3_2_3) SOL_TRACK_1_1_1_3_2_3_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.2.3'',SOL_TRACK_1_1_1_3_2_3) SOL_TRACK_1_1_1_3_2_3_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_3_2_3_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_3,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_4_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.2.4'',SOL_TRACK_1_1_1_3_2_4) SOL_TRACK_1_1_1_3_2_4_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.2.4'',SOL_TRACK_1_1_1_3_2_4) SOL_TRACK_1_1_1_3_2_4_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.2.4'',SOL_TRACK_1_1_1_3_2_4) SOL_TRACK_1_1_1_3_2_4_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_3_2_4_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_4,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_5_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.2.5'',SOL_TRACK_1_1_1_3_2_5) SOL_TRACK_1_1_1_3_2_5_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.2.5'',SOL_TRACK_1_1_1_3_2_5) SOL_TRACK_1_1_1_3_2_5_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.2.5'',SOL_TRACK_1_1_1_3_2_5) SOL_TRACK_1_1_1_3_2_5_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_3_2_5_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_5,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_6_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.2.6'',SOL_TRACK_1_1_1_3_2_6) SOL_TRACK_1_1_1_3_2_6_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.2.6'',SOL_TRACK_1_1_1_3_2_6) SOL_TRACK_1_1_1_3_2_6_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.2.6'',SOL_TRACK_1_1_1_3_2_6) SOL_TRACK_1_1_1_3_2_6_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_3_2_6_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_6,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_7_AP ,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_3_2_7_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_2_7,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.3.1'',SOL_TRACK_1_1_1_3_3_1) SOL_TRACK_1_1_1_3_3_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.3.1'',SOL_TRACK_1_1_1_3_3_1) SOL_TRACK_1_1_1_3_3_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.3.1'',SOL_TRACK_1_1_1_3_3_1) SOL_TRACK_1_1_1_3_3_1_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_3_3_1_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_2_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.3.2'',SOL_TRACK_1_1_1_3_3_2) SOL_TRACK_1_1_1_3_3_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.3.2'',SOL_TRACK_1_1_1_3_3_2) SOL_TRACK_1_1_1_3_3_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.3.2'',SOL_TRACK_1_1_1_3_3_2) SOL_TRACK_1_1_1_3_3_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_3_3_2_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_3_3_AP ,';
sqlstringa := sqlstringa || 'gsm.SOL_TRACK_1_1_1_3_3_3_XML,';
sqlstringa := sqlstringa || 'gsm.SOL_TRACK_1_1_1_3_3_3_OV,';
sqlstringa := sqlstringa || 'gsm.SOL_TRACK_1_1_1_3_3_3 SOL_TRACK_1_1_1_3_3_3_DES,';
sqlstringa := sqlstringa || 'gsm.SOL_TRACK_1_1_1_3_3_3_DES SOL_TRACK_1_1_1_3_3_3,      ';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_3_3_3_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_4_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.4.1'',SOL_TRACK_1_1_1_3_4_1) SOL_TRACK_1_1_1_3_4_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.4.1'',SOL_TRACK_1_1_1_3_4_1) SOL_TRACK_1_1_1_3_4_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.4.1'',SOL_TRACK_1_1_1_3_4_1) SOL_TRACK_1_1_1_3_4_1_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_3_4_1_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_4_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_5_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.5.1'',SOL_TRACK_1_1_1_3_5_1) SOL_TRACK_1_1_1_3_5_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.5.1'',SOL_TRACK_1_1_1_3_5_1) SOL_TRACK_1_1_1_3_5_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.5.1'',SOL_TRACK_1_1_1_3_5_1) SOL_TRACK_1_1_1_3_5_1_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_3_5_1_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_5_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_5_2_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.5.2'',SOL_TRACK_1_1_1_3_5_2) SOL_TRACK_1_1_1_3_5_2_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.5.2'',SOL_TRACK_1_1_1_3_5_2) SOL_TRACK_1_1_1_3_5_2_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.5.2'',SOL_TRACK_1_1_1_3_5_2) SOL_TRACK_1_1_1_3_5_2_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_3_5_2_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_5_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_6_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.6.1'',SOL_TRACK_1_1_1_3_6_1) SOL_TRACK_1_1_1_3_6_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.6.1'',SOL_TRACK_1_1_1_3_6_1) SOL_TRACK_1_1_1_3_6_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.6.1'',SOL_TRACK_1_1_1_3_6_1) SOL_TRACK_1_1_1_3_6_1_DES,';
sqlstringa := sqlstringa || 'NULL SOL_TRACK_1_1_1_3_6_1_SET ,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_6_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1) SOL_TRACK_1_1_1_3_7_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1) SOL_TRACK_1_1_1_3_7_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1) SOL_TRACK_1_1_1_3_7_1_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_1_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_2_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.2.1'',SOL_TRACK_1_1_1_3_7_2_1) SOL_TRACK_1_1_1_3_7_2_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.2.1'',SOL_TRACK_1_1_1_3_7_2_1) SOL_TRACK_1_1_1_3_7_2_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.2.1'',SOL_TRACK_1_1_1_3_7_2_1) SOL_TRACK_1_1_1_3_7_2_1_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_2_1_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_2_1,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_2_2_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_2_2_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_2_2,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_3_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_3_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_3,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_4_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_4_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_4,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_5_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_5_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_5,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_6_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_6_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_6,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_7_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_7_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_7,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_8_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_8_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'TRIM(TO_CHAR(ROUND(SOL_TRACK_1_1_1_3_7_8,1),''999990.9''))SOL_TRACK_1_1_1_3_7_8,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_9_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_9_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'TRIM(TO_CHAR(ROUND(SOL_TRACK_1_1_1_3_7_9,1),''999990.9''))SOL_TRACK_1_1_1_3_7_9,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_10_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_10_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'TRIM(TO_CHAR(ROUND(SOL_TRACK_1_1_1_3_7_10,1),''999990.9'')) SOL_TRACK_1_1_1_3_7_10,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_11_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.11'',SOL_TRACK_1_1_1_3_7_11) SOL_TRACK_1_1_1_3_7_11_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.11'',SOL_TRACK_1_1_1_3_7_11) SOL_TRACK_1_1_1_3_7_11_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.11'',SOL_TRACK_1_1_1_3_7_11) SOL_TRACK_1_1_1_3_7_11_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_11_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'TRIM(TO_CHAR(ROUND(SOL_TRACK_1_1_1_3_7_11,1),''999990.9'')) SOL_TRACK_1_1_1_3_7_11,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_12_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.12'',SOL_TRACK_1_1_1_3_7_12) SOL_TRACK_1_1_1_3_7_12_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.12'',SOL_TRACK_1_1_1_3_7_12) SOL_TRACK_1_1_1_3_7_12_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.12'',SOL_TRACK_1_1_1_3_7_12) SOL_TRACK_1_1_1_3_7_12_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_12_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_12,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_13_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.13'',SOL_TRACK_1_1_1_3_7_13) SOL_TRACK_1_1_1_3_7_13_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.13'',SOL_TRACK_1_1_1_3_7_13) SOL_TRACK_1_1_1_3_7_13_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.13'',SOL_TRACK_1_1_1_3_7_13) SOL_TRACK_1_1_1_3_7_13_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_13_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_13,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_14_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.14'',SOL_TRACK_1_1_1_3_7_14) SOL_TRACK_1_1_1_3_7_14_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.14'',SOL_TRACK_1_1_1_3_7_14) SOL_TRACK_1_1_1_3_7_14_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.14'',SOL_TRACK_1_1_1_3_7_14) SOL_TRACK_1_1_1_3_7_14_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_14_SET,      ';  --SET REALE
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_14,      ';
sqlstringa := sqlstringa || 'SOL_TRACK_1_1_1_3_7_15_1_AP ,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.15.1'',SOL_TRACK_1_1_1_3_7_15_1) SOL_TRACK_1_1_1_3_7_15_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.15.1'',SOL_TRACK_1_1_1_3_7_15_1) SOL_TRACK_1_1_1_3_7_15_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.15.1'',SOL_TRACK_1_1_1_3_7_15_1) SOL_TRACK_1_1_1_3_7_15_1_DES,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_15_1_SET,      ';  --SET REALE
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_15_1,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_15_2_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_15_2_SET,      ';  --SET REALE
sqlstringa3 := sqlstringa3 || 'TRIM(TO_CHAR(ROUND(SOL_TRACK_1_1_1_3_7_15_2,3),''999990.999'')) SOL_TRACK_1_1_1_3_7_15_2,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_16_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.16'',SOL_TRACK_1_1_1_3_7_16) SOL_TRACK_1_1_1_3_7_16_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.16'',SOL_TRACK_1_1_1_3_7_16) SOL_TRACK_1_1_1_3_7_16_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.16'',SOL_TRACK_1_1_1_3_7_16) SOL_TRACK_1_1_1_3_7_16_DES,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_16_SET,      ';  --SET REALE
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_16,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_17_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_17_SET,      ';  --SET REALE
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_17,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_18_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.18'',SOL_TRACK_1_1_1_3_7_18) SOL_TRACK_1_1_1_3_7_18_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.18'',SOL_TRACK_1_1_1_3_7_18) SOL_TRACK_1_1_1_3_7_18_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.18'',SOL_TRACK_1_1_1_3_7_18) SOL_TRACK_1_1_1_3_7_18_DES,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_18_SET,      ';  --SET REALE
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_18,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_19_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.19'',SOL_TRACK_1_1_1_3_7_19) SOL_TRACK_1_1_1_3_7_19_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.19'',SOL_TRACK_1_1_1_3_7_19) SOL_TRACK_1_1_1_3_7_19_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.19'',SOL_TRACK_1_1_1_3_7_19) SOL_TRACK_1_1_1_3_7_19_DES,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_19_SET,      ';  --SET REALE
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_19,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_20_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.20'',SOL_TRACK_1_1_1_3_7_20) SOL_TRACK_1_1_1_3_7_20_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.20'',SOL_TRACK_1_1_1_3_7_20) SOL_TRACK_1_1_1_3_7_20_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.20'',SOL_TRACK_1_1_1_3_7_20) SOL_TRACK_1_1_1_3_7_20_DES,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_20_SET,      ';  --SET REALE
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_20,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_21_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.21'',SOL_TRACK_1_1_1_3_7_21) SOL_TRACK_1_1_1_3_7_21_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.21'',SOL_TRACK_1_1_1_3_7_21) SOL_TRACK_1_1_1_3_7_21_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.21'',SOL_TRACK_1_1_1_3_7_21) SOL_TRACK_1_1_1_3_7_21_DES,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_21_SET,      ';  --SET REALE
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_21,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_22_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.22'',SOL_TRACK_1_1_1_3_7_22) SOL_TRACK_1_1_1_3_7_22_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.22'',SOL_TRACK_1_1_1_3_7_22) SOL_TRACK_1_1_1_3_7_22_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.22'',SOL_TRACK_1_1_1_3_7_22) SOL_TRACK_1_1_1_3_7_22_DES,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_22_SET,      ';  --SET REALE
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_22,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_23_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.7.23'',SOL_TRACK_1_1_1_3_7_23) SOL_TRACK_1_1_1_3_7_23_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.7.23'',SOL_TRACK_1_1_1_3_7_23) SOL_TRACK_1_1_1_3_7_23_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.7.23'',SOL_TRACK_1_1_1_3_7_23) SOL_TRACK_1_1_1_3_7_23_DES,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetSet(''1.1.1.3.7.1'',SOL_TRACK_1_1_1_3_7_1,SOL_TRACK_1_1_1_3_7_1_AP) SOL_TRACK_1_1_1_3_7_23_SET,      ';  --SET REALE
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_7_23,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_8_1_AP ,';--Stringa corretta
--sqlstringa3 := sqlstringa3 || '''NYA'' SOL_TRACK_1_1_1_3_8_1_AP ,'; --Stringa forzata a NYA per Autiero in attesa di ritorno ERA 31/07/2015
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.8.1'',SOL_TRACK_1_1_1_3_8_1) SOL_TRACK_1_1_1_3_8_1_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.8.1'',SOL_TRACK_1_1_1_3_8_1) SOL_TRACK_1_1_1_3_8_1_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.8.1'',SOL_TRACK_1_1_1_3_8_1) SOL_TRACK_1_1_1_3_8_1_DES,';
sqlstringa3 := sqlstringa3 || 'NULL SOL_TRACK_1_1_1_3_8_1_SET ,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_8_1,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_8_2_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.8.2'',SOL_TRACK_1_1_1_3_8_2) SOL_TRACK_1_1_1_3_8_2_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.8.2'',SOL_TRACK_1_1_1_3_8_2) SOL_TRACK_1_1_1_3_8_2_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.8.2'',SOL_TRACK_1_1_1_3_8_2) SOL_TRACK_1_1_1_3_8_2_DES,';
sqlstringa3 := sqlstringa3 || 'NULL SOL_TRACK_1_1_1_3_8_2_SET ,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_8_2,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_9_1_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.9.1'',SOL_TRACK_1_1_1_3_9_1) SOL_TRACK_1_1_1_3_9_1_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.9.1'',SOL_TRACK_1_1_1_3_9_1) SOL_TRACK_1_1_1_3_9_1_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.9.1'',SOL_TRACK_1_1_1_3_9_1) SOL_TRACK_1_1_1_3_9_1_DES,';
sqlstringa3 := sqlstringa3 || 'NULL SOL_TRACK_1_1_1_3_9_1_SET ,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_9_1,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_9_2_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.9.2'',SOL_TRACK_1_1_1_3_9_2) SOL_TRACK_1_1_1_3_9_2_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.9.2'',SOL_TRACK_1_1_1_3_9_2) SOL_TRACK_1_1_1_3_9_2_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.9.2'',SOL_TRACK_1_1_1_3_9_2) SOL_TRACK_1_1_1_3_9_2_DES,';
sqlstringa3 := sqlstringa3 || 'NULL SOL_TRACK_1_1_1_3_9_2_SET ,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_9_2,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_10_1_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.10.1'',SOL_TRACK_1_1_1_3_10_1) SOL_TRACK_1_1_1_3_10_1_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.10.1'',SOL_TRACK_1_1_1_3_10_1) SOL_TRACK_1_1_1_3_10_1_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.10.1'',SOL_TRACK_1_1_1_3_10_1) SOL_TRACK_1_1_1_3_10_1_DES,';
sqlstringa3 := sqlstringa3 || 'NULL SOL_TRACK_1_1_1_3_10_1_SET ,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_10_1,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_10_2_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.10.2'',SOL_TRACK_1_1_1_3_10_2) SOL_TRACK_1_1_1_3_10_2_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.10.2'',SOL_TRACK_1_1_1_3_10_2) SOL_TRACK_1_1_1_3_10_2_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.10.2'',SOL_TRACK_1_1_1_3_10_2) SOL_TRACK_1_1_1_3_10_2_DES,';
sqlstringa3 := sqlstringa3 || 'NULL SOL_TRACK_1_1_1_3_10_2_SET ,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_10_2,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_11_1_AP ,';
sqlstringa3 := sqlstringa3 || 'NULL SOL_TRACK_1_1_1_3_11_1_SET ,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_11_1,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_12_1_AP ,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.3.12.1'',SOL_TRACK_1_1_1_3_12_1) SOL_TRACK_1_1_1_3_12_1_XML,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.3.12.1'',SOL_TRACK_1_1_1_3_12_1) SOL_TRACK_1_1_1_3_12_1_OV,';
sqlstringa3 := sqlstringa3 || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.3.12.1'',SOL_TRACK_1_1_1_3_12_1) SOL_TRACK_1_1_1_3_12_1_DES,';
sqlstringa3 := sqlstringa3 || 'NULL SOL_TRACK_1_1_1_3_12_1_SET ,      ';
sqlstringa3 := sqlstringa3 || 'SOL_TRACK_1_1_1_3_12_1      ';
sqlstringa3 := sqlstringa3 || ' from '||s_schema||'.BINARI_CORSA_SOL s,';
IF p_versione IS NOT NULL THEN
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, LISTAGG(DECODE(SIGN(PENDENZA),-1,TRIM(TO_CHAR(PENDENZA,''9999999999999990.9'')),''+''||TRIM(TO_CHAR(PENDENZA,''9999999999999990.9'')))||''(''||TRIM(TO_CHAR(LEAST(KM_INIZIO,KM_FINE),''9999999999999990.999''))||'')'',''#'') WITHIN GROUP (ORDER BY LEAST(KM_INIZIO,KM_FINE)) AS gradiente ';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_1_3_6_GRADIENTE ';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) p, ';
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, LISTAGG(SOL_TRACK_1_1_1_1_2_1,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_1_2_1) AS SOL_TRACK_1_1_1_1_2_1, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_1_2_1_CAT_TEN_SOL, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.1.2.1'' and';
sqlstringa2 := sqlstringa2 || ' SOL_TRACK_1_1_1_1_2_1=CODIFICA_VALORE';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) cat_ten, ';
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, LISTAGG(SOL_TRACK_1_1_1_1_2_2,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_1_2_2) AS SOL_TRACK_1_1_1_1_2_2, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_2_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_2_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_2_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_1_2_2_CAT_LINEA, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.1.2.2'' and';
sqlstringa2 := sqlstringa2 || ' SOL_TRACK_1_1_1_1_2_2=CODIFICA_VALORE';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) cat_linea, ';
sqlstringa2 := sqlstringa2 || '(SELECT SEDE_TECNICA, CODICE_VERSIONE, LISTAGG(v.DESCRIZIONE,''#'') WITHIN GROUP (ORDER BY v.DESCRIZIONE) AS SOL_TRACK_1_1_1_1_2_3, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where CODICE_CONTESTO=3 and ';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' CODICE||''0''=CODIFICA_VALORE and';  --24/'7/2015 la vecchia join fatta sulle descrizioni non andava bene, il codice è stato moltiplicato per 10, perchè è il valore contenuto in DOMINIO_PARAMETRI(3=>30,1 =>10 etc.)
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.1.2.3'' and';
sqlstringa2 := sqlstringa2 || ' SEDE_TECNICA = '''||p_SOL||''' ';
sqlstringa2 := sqlstringa2 || '  group by SEDE_TECNICA, CODICE_VERSIONE) corridoio, ';
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, LISTAGG(SOL_TRACK_1_1_1_1_2_4,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_1_2_4) AS SOL_TRACK_1_1_1_1_2_4, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_1_2_4_CAP_CARICO, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.1.2.4'' and';
sqlstringa2 := sqlstringa2 || ' SOL_TRACK_1_1_1_1_2_4=CODIFICA_VALORE';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) cap_carico, ';
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, LISTAGG(SOL_TRACK_1_1_1_1_3_4,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_1_3_4) AS SOL_TRACK_1_1_1_1_3_4, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_4_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_4_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_4_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_1_3_4_PROF_CAS_M, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.1.3.4'' and';
sqlstringa2 := sqlstringa2 || ' SOL_TRACK_1_1_1_1_3_4=CODIFICA_VALORE';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) prof_casse, ';
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, LISTAGG(SOL_TRACK_1_1_1_1_3_5,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_1_3_5) AS SOL_TRACK_1_1_1_1_3_5, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_5_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_5_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_5_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_1_3_5_PROF_SEMI_R, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.1.3.5'' and';
sqlstringa2 := sqlstringa2 || ' SOL_TRACK_1_1_1_1_3_5=CODIFICA_VALORE';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) prof_semir, ';
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE, LISTAGG(SOL_TRACK_1_1_1_3_3_3,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_3_3_3) AS SOL_TRACK_1_1_1_3_3_3, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_3_3_3_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_3_3_3_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_3_3_3_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_3_3_3_GSM_R_FAC, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.3.3.3'' and';
sqlstringa2 := sqlstringa2 || ' SOL_TRACK_1_1_1_3_3_3=CODIFICA_VALORE';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1, CODICE_VERSIONE) gsm ';
sqlstringa2 := sqlstringa2 || 'where ';
sqlstringa2 := sqlstringa2 || 's.CODICE_VERSIONE='||p_versione ||' and ';
sqlstringa2 := sqlstringa2 || 'S.CODICE_VERSIONE=P.CODICE_VERSIONE (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.CODICE_VERSIONE=cat_ten.CODICE_VERSIONE (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.CODICE_VERSIONE=cat_linea.CODICE_VERSIONE (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.CODICE_VERSIONE=corridoio.CODICE_VERSIONE (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.CODICE_VERSIONE=cap_carico.CODICE_VERSIONE (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.CODICE_VERSIONE=prof_casse.CODICE_VERSIONE (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.CODICE_VERSIONE=prof_semir.CODICE_VERSIONE (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.CODICE_VERSIONE=gsm.CODICE_VERSIONE (+) and  ';
sqlstringa2 := sqlstringa2 || 's.SEDE_TECNICA = '''||p_SOL ||''' and    ';
ELSE
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, LISTAGG(DECODE(SIGN(PENDENZA),-1,TRIM(TO_CHAR(PENDENZA,''9999999999999990.9'')),''+''||TRIM(TO_CHAR(PENDENZA,''9999999999999990.9'')))||''(''||TRIM(TO_CHAR(LEAST(KM_INIZIO,KM_FINE),''9999999999999990.999''))||'')'',''#'') WITHIN GROUP (ORDER BY LEAST(KM_INIZIO,KM_FINE)) AS gradiente ';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_1_3_6_GRADIENTE ';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1) p, ';
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, LISTAGG(SOL_TRACK_1_1_1_1_2_1,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_1_2_1) AS SOL_TRACK_1_1_1_1_2_1, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_1_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_1_2_1_CAT_TEN_SOL, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.1.2.1'' and';
sqlstringa2 := sqlstringa2 || ' SOL_TRACK_1_1_1_1_2_1=CODIFICA_VALORE';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1) cat_ten, ';
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, LISTAGG(SOL_TRACK_1_1_1_1_2_2,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_1_2_2) AS SOL_TRACK_1_1_1_1_2_2, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_2_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_2_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_2_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_1_2_2_CAT_LINEA, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.1.2.2'' and';
sqlstringa2 := sqlstringa2 || ' SOL_TRACK_1_1_1_1_2_2=CODIFICA_VALORE';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1) cat_linea, ';
sqlstringa2 := sqlstringa2 || '(SELECT SEDE_TECNICA, LISTAGG(v.DESCRIZIONE,''#'') WITHIN GROUP (ORDER BY v.DESCRIZIONE) AS SOL_TRACK_1_1_1_1_2_3, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY VALORE_XML) AS SOL_TRACK_1_1_1_1_2_3_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where CODICE_CONTESTO=3 and ';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' CODICE||''0''=CODIFICA_VALORE and';  --24/'7/2015 la vecchia join fatta sulle descrizioni non andava bene, il codice è stato moltiplicato per 10, perchè è il valore contenuto in DOMINIO_PARAMETRI(3=>30,1 =>10 etc.)
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.1.2.3'' and';
sqlstringa2 := sqlstringa2 || ' SEDE_TECNICA = '''||p_SOL||''' ';
sqlstringa2 := sqlstringa2 || '  group by SEDE_TECNICA) corridoio, ';
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, LISTAGG(SOL_TRACK_1_1_1_1_2_4,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_1_2_4) AS SOL_TRACK_1_1_1_1_2_4, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_2_4_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_1_2_4_CAP_CARICO, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.1.2.4'' and';
sqlstringa2 := sqlstringa2 || ' SOL_TRACK_1_1_1_1_2_4=CODIFICA_VALORE';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1) cap_carico, ';
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, LISTAGG(SOL_TRACK_1_1_1_1_3_4,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_1_3_4) AS SOL_TRACK_1_1_1_1_3_4, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_4_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_4_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_4_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_1_3_4_PROF_CAS_M, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.1.3.4'' and';
sqlstringa2 := sqlstringa2 || ' SOL_TRACK_1_1_1_1_3_4=CODIFICA_VALORE';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1) prof_casse, ';
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, LISTAGG(SOL_TRACK_1_1_1_1_3_5,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_1_3_5) AS SOL_TRACK_1_1_1_1_3_5, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_5_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_5_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_1_3_5_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_1_3_5_PROF_SEMI_R, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.1.3.5'' and';
sqlstringa2 := sqlstringa2 || ' SOL_TRACK_1_1_1_1_3_5=CODIFICA_VALORE';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1) prof_semir, ';
sqlstringa2 := sqlstringa2 || '(SELECT SOL_TRACK_1_1_1_0_0_1, LISTAGG(SOL_TRACK_1_1_1_3_3_3,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,SOL_TRACK_1_1_1_3_3_3) AS SOL_TRACK_1_1_1_3_3_3, ';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE_XML,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_3_3_3_XML,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(OPTIONAL_VALUE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_3_3_3_OV,';
sqlstringa2 := sqlstringa2 || ' LISTAGG(VALORE,''#'') WITHIN GROUP (ORDER BY KM_INIZIO,VALORE_XML) AS SOL_TRACK_1_1_1_3_3_3_DES';
sqlstringa2 := sqlstringa2 || ' from '||s_schema||'.PAR_1_1_1_3_3_3_GSM_R_FAC, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa2 := sqlstringa2 || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa2 := sqlstringa2 || ' where';
sqlstringa2 := sqlstringa2 || ' c.codice_parametro=d.codice_parametro and';
sqlstringa2 := sqlstringa2 || ' numero_parametro=''1.1.1.3.3.3'' and';
sqlstringa2 := sqlstringa2 || ' SOL_TRACK_1_1_1_3_3_3=CODIFICA_VALORE';
sqlstringa2 := sqlstringa2 || '  group by SOL_TRACK_1_1_1_0_0_1) gsm ';
sqlstringa2 := sqlstringa2 || ' where s.SEDE_TECNICA = '''||p_SOL ||''' and    ';
END IF;
sqlstringa2 := sqlstringa2 || 'S.SOL_TRACK_1_1_1_0_0_1=P.SOL_TRACK_1_1_1_0_0_1 (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.SOL_TRACK_1_1_1_0_0_1=cat_ten.SOL_TRACK_1_1_1_0_0_1 (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.SOL_TRACK_1_1_1_0_0_1=cat_linea.SOL_TRACK_1_1_1_0_0_1 (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.SEDE_TECNICA=corridoio.SEDE_TECNICA (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.SOL_TRACK_1_1_1_0_0_1=cap_carico.SOL_TRACK_1_1_1_0_0_1 (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.SOL_TRACK_1_1_1_0_0_1=prof_casse.SOL_TRACK_1_1_1_0_0_1 (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.SOL_TRACK_1_1_1_0_0_1=prof_semir.SOL_TRACK_1_1_1_0_0_1 (+) and  ';
sqlstringa2 := sqlstringa2 || 'S.SOL_TRACK_1_1_1_0_0_1=gsm.SOL_TRACK_1_1_1_0_0_1 (+)   ';
sqlstringa2 := sqlstringa2 || 'order by 3 ';
OPEN p_cursor FOR sqlstringa|| ' ' || sqlstringa3||' '||sqlstringa2;
DBMS_OUTPUT.PUT_LINE(sqlstringa);
DBMS_OUTPUT.PUT_LINE(sqlstringa3);      --aggiunta stringa 3 perchè con il SET esplode
DBMS_OUTPUT.PUT_LINE(sqlstringa2);
END GetTracks_General;

-- -----------------------------------------------------------------------------
PROCEDURE GetTracks_Inf_EC (p_Track VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur) IS
--Ritorna l'elenco delle dichiarazioni di verifica EC e EI della vista Infrastuttura  di un Binario di Corsa di una SOL
-- -----------------------------------------------------------------------------
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(20000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;
--
-- -------------------------------------  EC -------------------------------------------------------
sqlstringa :=  'Select DISTINCT s.SOL_TRACK_1_1_1_0_0_1 Track_ID,  ';
sqlstringa := sqlstringa || Nvl(To_Char( p_versione),'NULL')||' CODICE_VERSIONE,  ';
sqlstringa := sqlstringa || '''EC'' TIPO_DICHIARAZIONE,  ';
sqlstringa := sqlstringa || 'nvl(SOL_TRACK_1_1_1_1_1_1O2_AP,'''||PKG_RINF_DATA_V082.GetNYA('1.1.1.1.1.1')||''') SOL_TRACK_1_1_1_1_1_1O2_AP, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 ) Then SOL_TRACK_1_1_1_1_1_1O2  Else ''00/00000000000000/0000/000000'' End SOL_TRACK_1_1_1_1_1_1O2, ';
-->
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then LTrim(To_Char(t.KM_INIZIO, ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)), t.KM_INIZIO), ''9990.99999''))  Else  NULL End Else  NULL  End KM_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 and b.KM_INIZIO >= 0 and b.KM_FINE >0) then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) Then LTrim(To_Char(t.KM_FINE,''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Least(Greatest(b.KM_FINE,b.KM_INIZIO), t.KM_FINE), ''9990.99999'')) Else  NULL End Else  NULL End  KM_FINE, ';
--
/**************
--sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else  ''00.00000'' End Else NULL  End  LATITUDINE_INIZIO, ';
--sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else NULL  End  LATITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''+00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' ''+''||LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else  NULL   End  LONGITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO),t.KM_FINE),  1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End  Else  ''00.00000'' End Else  NULL  End LATITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''+00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' ''+''||LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), 2) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else NULL End  LONGITUDINE_FINE, ';
********************/
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else  NULL End Else NULL  End  LATITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then  ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 2) ), ''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End Else  NULL   End  LONGITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(nvl(trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE,  1) ), ''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO),t.KM_FINE),  1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else  NULL End  Else  NULL  End LATITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE,  2) ), ''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), 2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End Else NULL End  LONGITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' LTrim(To_Char(t.KM_INIZIO,''9990.99999'')) KM_INIZIO_TR, LTrim(To_Char(t.KM_FINE,''9990.99999'')) KM_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, 1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LATITUDINE_INIZIO_TR,  ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, 2), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LONGITUDINE_INIZIO_TR, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE,  1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL  End LATITUDINE_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE,  2), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LONGITUDINE_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
--sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) then ';
--sqlstringa := sqlstringa || ' '' Km Inizio: ''||t.KM_INIZIO|| '' - Lat\Lon Inizio: '' ';
--sqlstringa := sqlstringa ||' ||trunc(nvl(trim(LATITUDINE_INIZIO),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 1) ),5) ||''\'' ';
--sqlstringa := sqlstringa ||' ||trunc(nvl(trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 2) ),5) ';
--sqlstringa := sqlstringa ||' ||'' - Km Fine: '' ||t.KM_FINE|| '' - Lat\Lon Fine: '' ';
--sqlstringa := sqlstringa ||' ||trunc(nvl(trim(LATITUDINE_FINE),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, 1) ),5)||''\'' ';
--sqlstringa := sqlstringa ||' ||trunc(nvl(trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, 2) ),5) ';
--sqlstringa := sqlstringa || ' '' Km Inizio: ''||t.KM_INIZIO||'' - Km Fine: '' ||t.KM_FINE';
--sqlstringa := sqlstringa || ' NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
--
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
--
--sqlstringa := sqlstringa || ' '' Km Inizio: '' ||greatest( least(nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO)|| '' - Lat\Lon Inizio: '' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LATITUDINE_INIZIO),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), greatest( least(nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ),5) ||''\'' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), greatest( least(nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ),5)  ';
--sqlstringa := sqlstringa || ' ||'' - Km Fine: ''||least( nvl(b.KM_FINE, 0), t.KM_FINE)||'' - Lat\Lon Fine: '' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LATITUDINE_FINE),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), least( greatest(b.KM_FINE,b.KM_INIZIO),  t.KM_FINE), 1) ),5)||''\'' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), least( greatest(b.KM_FINE,b.KM_INIZIO),  t.KM_FINE), 2) ),5) ';
sqlstringa := sqlstringa || ' '' Km Inizio: '' ||Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO)||'' - Km Fine: ''||Least( Greatest(Nvl(b.KM_FINE,0), Nvl(b.KM_INIZIO,0)), t.KM_FINE)';
--
sqlstringa := sqlstringa || '  Else    NULL     End Else    NULL     End LABEL ';
--
-- --------------------------- join fra tabelle --------------------------------
sqlstringa := sqlstringa || ' From  ';
sqlstringa := sqlstringa || '(select SOL_TRACK_1_1_1_0_0_1,SOL_TRACK_1_1_1_1_1_1O2_AP,SOL_TRACK_1_1_1_1_1_1O2,KM_INIZIO,KM_FINE   ';
--
sqlstringa := sqlstringa || ' , trunc(LATITUDINE_INIZIO,5) LATITUDINE_INIZIO,  trunc(LONGITUDINE_INIZIO,5) LONGITUDINE_INIZIO,  ';
sqlstringa := sqlstringa || ' trunc(LATITUDINE_FINE,5)  LATITUDINE_FINE, trunc(LONGITUDINE_FINE,5) LONGITUDINE_FINE, ';
sqlstringa := sqlstringa || ' '' Km Inizio: ''||KM_INIZIO||'' - Lat\Lon Inizio: ''||trunc(LATITUDINE_INIZIO,5)||''\''||trunc(LONGITUDINE_INIZIO,5)|| '' - Km Fine: ''||KM_FINE|| '' - Lat\Lon Fine: ''||trunc(LATITUDINE_FINE,5)||''\''||trunc(LONGITUDINE_FINE,5) LABEL ';
--
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EC''';
sqlstringa := sqlstringa || ' AND KM_INIZIO IS NOT NULL            ';
sqlstringa := sqlstringa || ' AND LONGITUDINE_INIZIO IS NOT NULL   ';
sqlstringa := sqlstringa || ' AND LATITUDINE_INIZIO IS NOT NULL    ';
sqlstringa := sqlstringa || ' AND LONGITUDINE_INIZIO IS NOT NULL   ';
sqlstringa := sqlstringa || ' AND KM_FINE IS NOT NULL              ';
sqlstringa := sqlstringa || ' AND LATITUDINE_FINE IS NOT NULL      ';
sqlstringa := sqlstringa || ' AND LONGITUDINE_FINE IS NOT NULL     ';
--
IF p_versione IS NOT NULL THEN
        sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
--
sqlstringa := sqlstringa || ' UNION ';
sqlstringa := sqlstringa || 'select SOL_TRACK_1_1_1_0_0_1,SOL_TRACK_1_1_1_1_1_1O2_AP,SOL_TRACK_1_1_1_1_1_1O2, KM_INIZIO, KM_FINE   ';
--05/02/2018 LAM da decommentare
sqlstringa := sqlstringa || ' , NULL LATITUDINE_INIZIO, NULL LONGITUDINE_INIZIO, NULL LATITUDINE_FINE, NULL LONGITUDINE_FINE, ';
sqlstringa := sqlstringa || ' NULL LABEL ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EC''';
sqlstringa := sqlstringa || 'AND ( KM_INIZIO IS  NULL        ';
sqlstringa := sqlstringa || ' OR LATITUDINE_INIZIO IS  NULL     ';
sqlstringa := sqlstringa || ' OR LONGITUDINE_INIZIO IS  NULL    ';
sqlstringa := sqlstringa || ' OR KM_FINE IS  NULL               ';
sqlstringa := sqlstringa || ' OR LATITUDINE_FINE IS  NULL       ';
sqlstringa := sqlstringa || ' OR LONGITUDINE_FINE  IS  NULL )   ';
--
IF p_versione IS NOT NULL THEN
        sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
--
sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_SOL s,            ';
sqlstringa := sqlstringa || '(SELECT SEDE_TECNICA, KM_INIZIO, KM_FINE ';
sqlstringa := sqlstringa ||  'FROM '|| s_schema||'.SEZIONI_LINEA ';
--
IF p_versione IS NOT NULL THEN
         sqlstringa := sqlstringa || 'where CODICE_VERSIONE='||p_versione;
END IF;
--
sqlstringa := sqlstringa || ' ) t ';
sqlstringa := sqlstringa || 'where s.SOL_TRACK_1_1_1_0_0_1=b.SOL_TRACK_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1='''||p_Track||''''  ;
sqlstringa := sqlstringa || ' AND s.SEDE_TECNICA = t.SEDE_TECNICA ';
--
IF p_versione IS NOT NULL THEN
        sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
--
-- ------------------------------------- EI ------------------------------------
sqlstringa := sqlstringa || ' UNION    ';
sqlstringa := sqlstringa || 'Select DISTINCT s.SOL_TRACK_1_1_1_0_0_1 Track_ID,  ';
sqlstringa := sqlstringa || Nvl(To_Char( p_versione),'NULL')||' CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || '''EI'' tipo_dichiarazione,                                      ';
sqlstringa := sqlstringa || 'nvl(SOL_TRACK_1_1_1_1_1_1O2_AP,'''||PKG_RINF_DATA_V082.GetNYA('1.1.1.1.1.1')||''') SOL_TRACK_1_1_1_1_1_1O2_AP, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 ) Then SOL_TRACK_1_1_1_1_1_1O2  Else ''00/00000000000000/0000/000000'' End SOL_TRACK_1_1_1_1_1_1O2, ';
-->
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then LTrim(To_Char(t.KM_INIZIO, ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)), t.KM_INIZIO), ''9990.99999''))  Else  NULL End Else  NULL  End KM_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 and b.KM_INIZIO >= 0 and b.KM_FINE >0) then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) Then LTrim(To_Char(t.KM_FINE,''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Least(Greatest(b.KM_FINE,b.KM_INIZIO), t.KM_FINE), ''9990.99999'')) Else  NULL End Else  NULL End  KM_FINE, ';
--
/*****************************
--sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else  ''00.00000'' End Else NULL  End  LATITUDINE_INIZIO, ';
--sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else NULL  End  LATITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''+00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' ''+''||LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else  NULL   End  LONGITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO),t.KM_FINE),  1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End  Else  ''00.00000'' End Else  NULL  End LATITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''+00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' ''+''||LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), 2) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else NULL End  LONGITUDINE_FINE, ';
****************/
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else  NULL End Else NULL  End  LATITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then  ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 2) ), ''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End Else  NULL   End  LONGITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(nvl(trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE,  1) ), ''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO),t.KM_FINE),  1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else  NULL End  Else  NULL  End LATITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE,  2) ), ''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), 2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End Else NULL End  LONGITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' LTrim(To_Char(t.KM_INIZIO,''9990.99999'')) KM_INIZIO_TR, LTrim(To_Char(t.KM_FINE,''9990.99999'')) KM_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, 1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LATITUDINE_INIZIO_TR,  ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, 2), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LONGITUDINE_INIZIO_TR, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE,  1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL  End LATITUDINE_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE,  2), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LONGITUDINE_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case When (SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_1_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
--sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) then ';
--sqlstringa := sqlstringa || ' '' Km Inizio: ''||t.KM_INIZIO|| '' - Lat\Lon Inizio: '' ';
--sqlstringa := sqlstringa ||' ||trunc(nvl(trim(LATITUDINE_INIZIO),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 1) ),5) ||''\'' ';
--sqlstringa := sqlstringa ||' ||trunc(nvl(trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 2) ),5) ';
--sqlstringa := sqlstringa ||' ||'' - Km Fine: '' ||t.KM_FINE|| '' - Lat\Lon Fine: '' ';
--sqlstringa := sqlstringa ||' ||trunc(nvl(trim(LATITUDINE_FINE),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, 1) ),5)||''\'' ';
--sqlstringa := sqlstringa ||' ||trunc(nvl(trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, 2) ),5) ';
--sqlstringa := sqlstringa || ' '' Km Inizio: ''||t.KM_INIZIO||'' - Km Fine: '' ||t.KM_FINE';
--sqlstringa := sqlstringa || ' NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
--
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
--
--sqlstringa := sqlstringa || ' '' Km Inizio: '' ||greatest( least(nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO)|| '' - Lat\Lon Inizio: '' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LATITUDINE_INIZIO),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), greatest( least(nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ),5) ||''\'' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), greatest( least(nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ),5)  ';
--sqlstringa := sqlstringa || ' ||'' - Km Fine: ''||least( nvl(b.KM_FINE, 0), t.KM_FINE)||'' - Lat\Lon Fine: '' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LATITUDINE_FINE),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), least( greatest(b.KM_FINE,b.KM_INIZIO),  t.KM_FINE), 1) ),5)||''\'' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), least( greatest(b.KM_FINE,b.KM_INIZIO),  t.KM_FINE), 2) ),5) ';
sqlstringa := sqlstringa || ' '' Km Inizio: '' ||Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO)||'' - Km Fine: ''||Least( Greatest(Nvl(b.KM_FINE,0), Nvl(b.KM_INIZIO,0)), t.KM_FINE)';
--
sqlstringa := sqlstringa || '  Else    NULL     End Else    NULL     End LABEL ';
--

-- --------------------------- join fra tabelle --------------------------------
sqlstringa := sqlstringa || ' From  ';
sqlstringa := sqlstringa || '(select SOL_TRACK_1_1_1_0_0_1, SOL_TRACK_1_1_1_1_1_1O2_AP, SOL_TRACK_1_1_1_1_1_1O2, KM_INIZIO, KM_FINE   ';

--05/02/2018 LAM da decommentare
sqlstringa := sqlstringa || ' , trunc(LATITUDINE_INIZIO,5) LATITUDINE_INIZIO,  trunc(LONGITUDINE_INIZIO,5) LONGITUDINE_INIZIO,  ';
sqlstringa := sqlstringa || ' trunc(LATITUDINE_FINE,5)  LATITUDINE_FINE, trunc(LONGITUDINE_FINE,5) LONGITUDINE_FINE, ';
sqlstringa := sqlstringa || ' '' Km Inizio: ''||KM_INIZIO||'' - Lat\Lon Inizio: ''||trunc(LATITUDINE_INIZIO,5)||''\''||trunc(LONGITUDINE_INIZIO,5)|| '' - Km Fine: ''||KM_FINE|| '' - Lat\Lon Fine: ''||trunc(LATITUDINE_FINE,5)||''\''||trunc(LONGITUDINE_FINE,5) LABEL ';

sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EI''';
sqlstringa := sqlstringa || ' AND KM_INIZIO IS NOT NULL            ';
sqlstringa := sqlstringa || ' AND LONGITUDINE_INIZIO IS NOT NULL   ';
sqlstringa := sqlstringa || ' AND LATITUDINE_INIZIO IS NOT NULL    ';
sqlstringa := sqlstringa || ' AND LONGITUDINE_INIZIO IS NOT NULL   ';
sqlstringa := sqlstringa || ' AND KM_FINE IS NOT NULL              ';
sqlstringa := sqlstringa || ' AND LATITUDINE_FINE IS NOT NULL      ';
sqlstringa := sqlstringa || ' AND LONGITUDINE_FINE IS NOT NULL     ';

IF p_versione IS NOT NULL THEN
        sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa := sqlstringa || ' UNION ';
sqlstringa := sqlstringa || 'select SOL_TRACK_1_1_1_0_0_1,SOL_TRACK_1_1_1_1_1_1O2_AP,SOL_TRACK_1_1_1_1_1_1O2, NULL KM_INIZIO, NULL KM_FINE   ';
--05/02/2018 LAM da decommentare
sqlstringa := sqlstringa || ' , NULL LATITUDINE_INIZIO, NULL LONGITUDINE_INIZIO, NULL LATITUDINE_FINE, NULL LONGITUDINE_FINE, ';
sqlstringa := sqlstringa || ' NULL LABEL ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EI''';
sqlstringa := sqlstringa || 'AND ( KM_INIZIO IS  NULL        ';
sqlstringa := sqlstringa || ' OR LATITUDINE_INIZIO IS  NULL     ';
sqlstringa := sqlstringa || ' OR LONGITUDINE_INIZIO IS  NULL    ';
sqlstringa := sqlstringa || ' OR KM_FINE IS  NULL               ';
sqlstringa := sqlstringa || ' OR LATITUDINE_FINE IS  NULL       ';
sqlstringa := sqlstringa || ' OR LONGITUDINE_FINE  IS  NULL )   ';

IF p_versione IS NOT NULL THEN
         sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_SOL s,            ';
sqlstringa := sqlstringa || '(SELECT SEDE_TECNICA, KM_INIZIO, KM_FINE ';
sqlstringa := sqlstringa || 'FROM '||  s_schema||'.SEZIONI_LINEA ';

IF p_versione IS NOT NULL THEN
        sqlstringa := sqlstringa || 'where CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa := sqlstringa || ' ) t ';
sqlstringa := sqlstringa || 'where s.SOL_TRACK_1_1_1_0_0_1=b.SOL_TRACK_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1='''||p_Track||''''  ;
sqlstringa := sqlstringa || ' AND s.SEDE_TECNICA = t.SEDE_TECNICA ';

IF p_versione IS NOT NULL THEN
        sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa := sqlstringa || 'order by 3, 5, 6 ';
-- -------------------------------------------------------------------------------------------------
--
--DBMS_OUTPUT.PUT_LINE(sqlstringa);
--
OPEN p_cursor FOR sqlstringa;
--
END GetTracks_Inf_EC;
--
-- --------------------------------------------------------------------------------------------------
PROCEDURE GetTracks_Energy_EC (p_Track VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur) IS
--Ritorna l'elenco delle dichiarazioni di verifica EC e EI della vista Energia  di un Binario di Corsa di una SOL
-- --------------------------------------------------------------------------------------------------
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(20000);
p_versione NUMBER;

BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 p_versione:=p_i_versione;

 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
         p_versione:=PKG_RINF_DATA_V082.GetLastVersion(p_area);
 END IF;

-- ------------------------------------------ EC ---------------------------------------------------
sqlstringa := 'Select DISTINCT s.SOL_TRACK_1_1_1_0_0_1 Track_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE, ';
sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione, ';
sqlstringa := sqlstringa || 'NVL(SOL_TRACK_1_1_1_2_1_1O2_AP,'''||PKG_RINF_DATA_V082.GetNYA('1.1.1.2.1.1')||''') SOL_TRACK_1_1_1_2_1_1O2_AP, ';

sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 ) Then  SOL_TRACK_1_1_1_2_1_1O2  Else ''00/00000000000000/0000/000000'' END SOL_TRACK_1_1_1_2_1_1O2, ';
-->
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 and b.KM_FINE >0) then ';
--sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) then LTrim(To_Char(t.KM_INIZIO, ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Greatest( Least(Nvl(b.KM_INIZIO, 0), Nvl(b.KM_FINE, 0)), t.KM_INIZIO), ''9990.99999''))  Else  NULL End Else  NULL  End KM_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 and b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
--sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then LTrim(To_Char(t.KM_FINE,''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE between t.KM_INIZIO and t.KM_FINE )) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), ''9990.99999'')) Else  NULL End Else  NULL End  KM_FINE, ';
--
/*************************
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case  When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else ''00.00000'' End Else NULL  End  LATITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case  When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''+00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' ''+''||LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else  NULL   End  LONGITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case  When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO),t.KM_FINE),  1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else  ''00.00000'' End  Else  NULL  End LATITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case  When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''+00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' ''+''||LTrim(To_Char(Nvl(Trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), 2) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else NULL End  LONGITUDINE_FINE, ';
***************************/
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else  NULL End Else NULL  End  LATITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) Then  ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End Else  NULL   End  LONGITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(nvl(trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE,  1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO),t.KM_FINE),  1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else  NULL End  Else  NULL  End LATITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 and b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE,  2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), 2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL eNd Else NULL End  LONGITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' LTrim(To_Char(t.KM_INIZIO,''9990.99999'')) KM_INIZIO_TR, LTrim(To_Char(t.KM_FINE,''9990.99999'')) KM_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, 1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LATITUDINE_INIZIO_TR,  ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, 2), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LONGITUDINE_INIZIO_TR, ';
--
sqlstringa := sqlstringa || ' CASE  WHEN (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE,  1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL  End LATITUDINE_FINE_TR, ';
--
sqlstringa := sqlstringa || ' CASE  WHEN (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE,  2), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LONGITUDINE_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
--sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then ';
--sqlstringa := sqlstringa || ' '' Km Inizio: ''||t.KM_INIZIO|| '' - Lat\Lon Inizio: '' ';
--sqlstringa := sqlstringa ||' ||trunc(nvl(trim(LATITUDINE_INIZIO),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 1) ),5) ||''\'' ';
--sqlstringa := sqlstringa ||' ||Trunc(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 2) ),5) ';
--sqlstringa := sqlstringa ||' ||'' - Km Fine: '' ||t.KM_FINE|| '' - Lat\Lon Fine: '' ';
--sqlstringa := sqlstringa ||' ||Trunc(Nvl(Trim(LATITUDINE_FINE),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, 1) ),5)||''\'' ';
--sqlstringa := sqlstringa ||' ||Trunc(Nvl(Trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, 2) ),5) ';
--
--sqlstringa := sqlstringa || ' '' Km Inizio: ''||t.KM_INIZIO||'' - Km Fine: '' ||t.KM_FINE ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
--
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
--
--sqlstringa := sqlstringa || ' '' Km Inizio: '' ||greatest( least(nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO)|| '' - Lat\Lon Inizio: '' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LATITUDINE_INIZIO),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), greatest( least(nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ),5) ||''\'' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), greatest( least(nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ),5)  ';
--sqlstringa := sqlstringa || ' ||'' - Km Fine: ''||least( nvl(b.KM_FINE, 0), t.KM_FINE)||'' - Lat\Lon Fine: '' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LATITUDINE_FINE),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), least( greatest(b.KM_FINE,b.KM_INIZIO),  t.KM_FINE), 1) ),5)||''\'' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), least( greatest(b.KM_FINE,b.KM_INIZIO),  t.KM_FINE), 2) ),5) ';
sqlstringa := sqlstringa || ' '' Km Inizio: '' ||Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO)||'' - Km Fine: ''||Least( Greatest(Nvl(b.KM_FINE,0), Nvl(b.KM_INIZIO,0)), t.KM_FINE)';

sqlstringa := sqlstringa || '  Else  NULL  End Else   NULL   End LABEL ';

-- --------------------------- join fra tabelle --------------------------------
sqlstringa := sqlstringa || 'from   ';
sqlstringa := sqlstringa || '(select SOL_TRACK_1_1_1_0_0_1,SOL_TRACK_1_1_1_2_1_1O2_AP,SOL_TRACK_1_1_1_2_1_1O2,KM_INIZIO,KM_FINE ';

--05/02/2018 LAM da decommentare
sqlstringa := sqlstringa || ' , trunc(LATITUDINE_INIZIO,5) LATITUDINE_INIZIO,  trunc(LONGITUDINE_INIZIO,5) LONGITUDINE_INIZIO, ';
sqlstringa := sqlstringa || ' trunc(LATITUDINE_FINE,5)  LATITUDINE_FINE, trunc(LONGITUDINE_FINE,5) LONGITUDINE_FINE, ';
sqlstringa := sqlstringa || ' '' Km Inizio: ''||KM_INIZIO||'' - Lat\Lon Inizio: ''||trunc(LATITUDINE_INIZIO,5)||''\''||trunc(LONGITUDINE_INIZIO,5)|| '' - Km Fine: ''||KM_FINE|| '' - Lat\Lon Fine: ''||trunc(LATITUDINE_FINE,5)||''\''||trunc(LONGITUDINE_FINE,5) LABEL ';

sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EC''';
sqlstringa := sqlstringa || ' AND KM_INIZIO IS NOT NULL            ';
sqlstringa := sqlstringa || ' AND LONGITUDINE_INIZIO IS NOT NULL   ';
sqlstringa := sqlstringa || ' AND LATITUDINE_INIZIO IS NOT NULL    ';
sqlstringa := sqlstringa || ' AND KM_FINE IS NOT NULL              ';
sqlstringa := sqlstringa || ' AND LATITUDINE_FINE IS NOT NULL      ';
sqlstringa := sqlstringa || ' AND LONGITUDINE_FINE IS NOT NULL     ';

IF p_versione IS NOT NULL THEN
       sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa := sqlstringa || ' UNION ';
sqlstringa := sqlstringa || 'select SOL_TRACK_1_1_1_0_0_1, SOL_TRACK_1_1_1_2_1_1O2_AP, SOL_TRACK_1_1_1_2_1_1O2, KM_INIZIO, KM_FINE   ';
--05/02/2018 LAM da decommentare
sqlstringa := sqlstringa || ' , NULL LATITUDINE_INIZIO, NULL LONGITUDINE_INIZIO, NULL LATITUDINE_FINE, NULL LONGITUDINE_FINE, NULL LABEL ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EC''';
sqlstringa := sqlstringa || 'AND ( KM_INIZIO IS  NULL        ';
sqlstringa := sqlstringa || ' OR LATITUDINE_INIZIO IS  NULL     ';
sqlstringa := sqlstringa || ' OR LONGITUDINE_INIZIO IS  NULL    ';
sqlstringa := sqlstringa || ' OR KM_FINE IS  NULL               ';
sqlstringa := sqlstringa || ' OR LATITUDINE_FINE IS  NULL       ';
sqlstringa := sqlstringa || ' OR LONGITUDINE_FINE  IS  NULL )   ';

IF p_versione IS NOT NULL THEN
       sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_SOL s,            ';
sqlstringa := sqlstringa || '(SELECT SEDE_TECNICA, KM_INIZIO, KM_FINE ';
sqlstringa := sqlstringa || 'FROM '||  s_schema||'.SEZIONI_LINEA ';

IF p_versione IS NOT NULL THEN
       sqlstringa := sqlstringa || 'where CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa := sqlstringa || ' ) t ';
sqlstringa := sqlstringa || 'where s.SOL_TRACK_1_1_1_0_0_1=b.SOL_TRACK_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1='''||p_Track||''''  ;
sqlstringa := sqlstringa || ' AND s.SEDE_TECNICA = t.SEDE_TECNICA ';

IF p_versione IS NOT NULL THEN
        sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;

-- ------------------------------------- EI ------------------------------------
sqlstringa := sqlstringa || ' UNION                                                   ';
sqlstringa := sqlstringa || 'Select DISTINCT s.SOL_TRACK_1_1_1_0_0_1 Track_ID,  ';
sqlstringa := sqlstringa || Nvl(To_Char( p_versione),'NULL')||' CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || '''EI'' tipo_dichiarazione,   ';
sqlstringa := sqlstringa || 'NVL(SOL_TRACK_1_1_1_2_1_1O2_AP,'''||PKG_RINF_DATA_V082.GetNYA('1.1.1.2.1.1')||''') SOL_TRACK_1_1_1_2_1_1O2_AP, ';

sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 ) Then  SOL_TRACK_1_1_1_2_1_1O2  Else ''00/00000000000000/0000/000000'' END SOL_TRACK_1_1_1_2_1_1O2, ';
-->
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 and b.KM_FINE >0) then ';
--sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) then LTrim(To_Char(t.KM_INIZIO, ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Greatest( Least(Nvl(b.KM_INIZIO, 0), Nvl(b.KM_FINE, 0)), t.KM_INIZIO), ''9990.99999''))  Else  NULL End Else  NULL  End KM_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 and b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
--sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then LTrim(To_Char(t.KM_FINE,''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE between t.KM_INIZIO and t.KM_FINE )) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), ''9990.99999'')) Else  NULL End Else  NULL End  KM_FINE, ';
--
/***************************
--sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case  When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else  ''00.00000'' End Else NULL  End  LATITUDINE_INIZIO, ';
-- sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else NULL  End  LATITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case  When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''+00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' ''+''||LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else  NULL   End  LONGITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case  When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO),t.KM_FINE),  1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else  ''00.00000'' End  Else  NULL  End LATITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case  When (b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''+00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' ''+''||LTrim(To_Char(Nvl(Trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), 2) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else NULL End  LONGITUDINE_FINE, ';
************************************/
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else  NULL End Else NULL  End  LATITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) Then  ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End Else  NULL   End  LONGITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(nvl(trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE,  1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO),t.KM_FINE),  1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else  NULL End  Else  NULL  End LATITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  and Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 and b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE,  2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), 2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL eNd Else NULL End  LONGITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' LTrim(To_Char(t.KM_INIZIO,''9990.99999'')) KM_INIZIO_TR, LTrim(To_Char(t.KM_FINE,''9990.99999'')) KM_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, 1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LATITUDINE_INIZIO_TR,  ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, 2), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LONGITUDINE_INIZIO_TR, ';
--
sqlstringa := sqlstringa || ' CASE  WHEN (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE,  1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL  End LATITUDINE_FINE_TR, ';
--
sqlstringa := sqlstringa || ' CASE  WHEN (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE,  2), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LONGITUDINE_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y''  And Length(Trim(SOL_TRACK_1_1_1_2_1_1O2)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
--sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then ';
--sqlstringa := sqlstringa || ' '' Km Inizio: ''||t.KM_INIZIO|| '' - Lat\Lon Inizio: '' ';
--sqlstringa := sqlstringa ||' ||trunc(nvl(trim(LATITUDINE_INIZIO),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 1) ),5) ||''\'' ';
--sqlstringa := sqlstringa ||' ||Trunc(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 2) ),5) ';
--sqlstringa := sqlstringa ||' ||'' - Km Fine: '' ||t.KM_FINE|| '' - Lat\Lon Fine: '' ';
--sqlstringa := sqlstringa ||' ||Trunc(Nvl(Trim(LATITUDINE_FINE),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, 1) ),5)||''\'' ';
--sqlstringa := sqlstringa ||' ||Trunc(Nvl(Trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE, 2) ),5) ';
--
--sqlstringa := sqlstringa || ' '' Km Inizio: ''||t.KM_INIZIO||'' - Km Fine: '' ||t.KM_FINE ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
--
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) Then  ';
--
--sqlstringa := sqlstringa || ' '' Km Inizio: '' ||greatest( least(nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO)|| '' - Lat\Lon Inizio: '' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LATITUDINE_INIZIO),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), greatest( least(nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ),5) ||''\'' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), greatest( least(nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ),5)  ';
--sqlstringa := sqlstringa || ' ||'' - Km Fine: ''||least( nvl(b.KM_FINE, 0), t.KM_FINE)||'' - Lat\Lon Fine: '' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LATITUDINE_FINE),  PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), least( greatest(b.KM_FINE,b.KM_INIZIO),  t.KM_FINE), 1) ),5)||''\'' ';
--sqlstringa := sqlstringa || ' ||trunc(nvl(trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), least( greatest(b.KM_FINE,b.KM_INIZIO),  t.KM_FINE), 2) ),5) ';
sqlstringa := sqlstringa || ' '' Km Inizio: '' ||Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO)||'' - Km Fine: ''||Least( Greatest(Nvl(b.KM_FINE,0), Nvl(b.KM_INIZIO,0)), t.KM_FINE)';

sqlstringa := sqlstringa || '  Else  NULL  End Else   NULL   End LABEL ';

-- --------------------------- join fra tabelle --------------------------------
sqlstringa := sqlstringa || 'from        ';
sqlstringa := sqlstringa || '(select SOL_TRACK_1_1_1_0_0_1,SOL_TRACK_1_1_1_2_1_1O2_AP,SOL_TRACK_1_1_1_2_1_1O2,KM_INIZIO,KM_FINE   ';
--05/02/2018 LAM da decommentare
sqlstringa := sqlstringa || ' , trunc(LATITUDINE_INIZIO,5) LATITUDINE_INIZIO,  trunc(LONGITUDINE_INIZIO,5) LONGITUDINE_INIZIO,  ';
sqlstringa := sqlstringa || ' trunc(LATITUDINE_FINE,5)  LATITUDINE_FINE, trunc(LONGITUDINE_FINE,5) LONGITUDINE_FINE, ';
sqlstringa := sqlstringa || ' '' Km Inizio: ''||KM_INIZIO||'' - Lat\Lon Inizio: ''||trunc(LATITUDINE_INIZIO,5)||''\''||trunc(LONGITUDINE_INIZIO,5)|| '' - Km Fine: ''||KM_FINE|| '' - Lat\Lon Fine: ''||trunc(LATITUDINE_FINE,5)||''\''||trunc(LONGITUDINE_FINE,5) LABEL ';

sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EI''';
sqlstringa := sqlstringa || ' AND KM_INIZIO IS NOT NULL            ';
sqlstringa := sqlstringa || ' AND LONGITUDINE_INIZIO IS NOT NULL   ';
sqlstringa := sqlstringa || ' AND LATITUDINE_INIZIO IS NOT NULL    ';
sqlstringa := sqlstringa || ' AND KM_FINE IS NOT NULL              ';
sqlstringa := sqlstringa || ' AND LATITUDINE_FINE IS NOT NULL      ';
sqlstringa := sqlstringa || ' AND LONGITUDINE_FINE IS NOT NULL     ';

IF p_versione IS NOT NULL THEN
        sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa := sqlstringa || ' UNION ';
sqlstringa := sqlstringa || 'select SOL_TRACK_1_1_1_0_0_1, SOL_TRACK_1_1_1_2_1_1O2_AP, SOL_TRACK_1_1_1_2_1_1O2, KM_INIZIO, KM_FINE   ';
--05/02/2018 LAM da decommentare
sqlstringa := sqlstringa || ' , NULL LATITUDINE_INIZIO, NULL LONGITUDINE_INIZIO, NULL LATITUDINE_FINE, NULL LONGITUDINE_FINE, NULL LABEL ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EI''';
sqlstringa := sqlstringa || 'AND ( KM_INIZIO IS  NULL        ';
sqlstringa := sqlstringa || ' OR LATITUDINE_INIZIO IS  NULL     ';
sqlstringa := sqlstringa || ' OR LONGITUDINE_INIZIO IS  NULL    ';
sqlstringa := sqlstringa || ' OR KM_FINE IS  NULL               ';
sqlstringa := sqlstringa || ' OR LATITUDINE_FINE IS  NULL       ';
sqlstringa := sqlstringa || ' OR LONGITUDINE_FINE  IS  NULL )   ';

IF p_versione IS NOT NULL THEN
        sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_SOL s ,            ';
sqlstringa := sqlstringa || '(SELECT SEDE_TECNICA, KM_INIZIO, KM_FINE ';
sqlstringa := sqlstringa || 'FROM '||  s_schema||'.SEZIONI_LINEA ';

IF p_versione IS NOT NULL THEN
       sqlstringa := sqlstringa || 'where CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa := sqlstringa || ' ) t ';
sqlstringa := sqlstringa || 'where s.SOL_TRACK_1_1_1_0_0_1=b.SOL_TRACK_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1='''||p_Track||''''  ;
sqlstringa := sqlstringa || ' AND s.SEDE_TECNICA = t.SEDE_TECNICA ';

IF p_versione IS NOT NULL THEN
    sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || 'order by 3,5,6 ';
-- -------------------------------------

-- DBMS_OUTPUT.PUT_LINE(sqlstringa);
OPEN p_cursor FOR sqlstringa;
END GetTracks_Energy_EC;

-- ---------------------------------------------------------------------------------------------------------------------
PROCEDURE GetTracks_Control_EC (p_Track VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur) IS
--  Ritorna l'elenco delle dichiarazioni di verifica EC e EI della vista Controllo di un Binario di Corsa di una SOL
-- ---------------------------------------------------------------------------------------------------------------------
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(20000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  p_versione:=p_i_versione;

 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
         p_versione:= PKG_RINF_DATA_V082.GetLastVersion(p_area);
 END IF;

-- -----------------------------------------  EC  --------------------------------------------------
sqlstringa :=  'Select DISTINCT s.SOL_TRACK_1_1_1_0_0_1 Track_ID, ';
sqlstringa := sqlstringa || NVL(To_Char( p_versione),'NULL')||' CODICE_VERSIONE,  ';
sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione, ';
sqlstringa := sqlstringa || ' Nvl(SOL_TRACK_1_1_1_3_1_1_AP,'''||PKG_RINF_DATA_V082.GetNYA('1.1.1.3.1.1')||''') SOL_TRACK_1_1_1_3_1_1_AP, ';
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 ) Then SOL_TRACK_1_1_1_3_1_1  Else ''00/00000000000000/0000/000000'' End SOL_TRACK_1_1_1_3_1_1, ';
-->
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 and b.KM_INIZIO >= 0 and b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then LTrim(To_Char(t.KM_INIZIO,''9990.99999'')) ';
--sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO And t.KM_FINE )) then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)), t.KM_INIZIO),''9990.99999'')) Else  NULL End Else  NULL  End KM_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 and b.KM_INIZIO >= 0 and b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case when (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) Then LTrim(To_Char(t.KM_FINE,''9990.99999'')) ';
--sqlstringa := sqlstringa || ' Case when (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) Then NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE),''9990.99999'')) Else  NULL End Else  NULL End  KM_FINE, ';
--
/*************************
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case  When ( b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
--
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else  ''00.00000'' End Else NULL  End  LATITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case  When ( b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''+00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then  ';
sqlstringa := sqlstringa || '  ''+''||LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ),''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else  NULL   End  LONGITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case  When ( b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE,b.KM_INIZIO),t.KM_FINE), 1) ),''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else  ''00.00000'' End Else  NULL  End LATITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 ) Then ';
sqlstringa := sqlstringa || ' Case  When ( b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then ''+00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' ''+''||LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), 2) ),''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else NULL End  LONGITUDINE_FINE, ';
****************************/
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 1) ),''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO), 1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else  NULL End Else NULL  End  LATITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then  ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_INIZIO, 2) ),''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  t.KM_INIZIO), 2) ),''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End Else  NULL   End  LONGITUDINE_INIZIO, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE,  1) ),''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), Least( Greatest(b.KM_FINE,b.KM_INIZIO),t.KM_FINE), 1) ),''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else  NULL End  Else  NULL  End LATITUDINE_FINE, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 And b.KM_INIZIO >= 0 and b.KM_FINE >0) Then ';
-- sqlstringa := sqlstringa || ' Case When (b.KM_INIZIO <= t.KM_INIZIO and b.KM_FINE >= t.KM_FINE ) Then ';
-- sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1, 1, 6), t.KM_FINE,  2) ),''9990.99999'')) ';
-- sqlstringa := sqlstringa || ' NULL ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO between t.KM_INIZIO and t.KM_FINE ) or (b.KM_FINE between t.KM_INIZIO and t.KM_FINE )) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), t.KM_FINE), 2) ),''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End Else NULL End  LONGITUDINE_FINE, ';

--
sqlstringa := sqlstringa || ' LTrim(To_Char(t.KM_INIZIO,''9990.99999'')) KM_INIZIO_TR, LTrim(To_Char(t.KM_FINE,''9990.99999'')) KM_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, 1), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL  End  LATITUDINE_INIZIO_TR, ';
--
sqlstringa := sqlstringa || 'Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_INIZIO, 2), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL   End  LONGITUDINE_INIZIO_TR, ';
--
sqlstringa := sqlstringa || 'Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0) Then ';
sqlstringa := sqlstringa || 'LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE, 1), ''9900.99999'')) ';
sqlstringa := sqlstringa || 'Else NULL  End LATITUDINE_FINE_TR, ';
--
sqlstringa := sqlstringa || 'CASE  WHEN (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' and Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0) Then ';
sqlstringa := sqlstringa || 'LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TRACK_1_1_1_0_0_1,1,6), t.KM_FINE, 2), ''9900.99999'')) ';
sqlstringa := sqlstringa || 'Else  NULL End  LONGITUDINE_FINE_TR, ';
--
sqlstringa := sqlstringa || ' Case  When (SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' And Length(Trim(SOL_TRACK_1_1_1_3_1_1)) >0 And b.KM_INIZIO >= 0 And b.KM_FINE >0) then ';

sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= t.KM_INIZIO And b.KM_FINE >= t.KM_FINE) Or (b.KM_FINE <= t.KM_INIZIO And b.KM_INIZIO >= t.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between t.KM_INIZIO And t.KM_FINE ) or (b.KM_FINE Between t.KM_INIZIO and t.KM_FINE )) Then  ';
--
sqlstringa := sqlstringa || ' '' Km Inizio: '' ||Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  t.KM_INIZIO)||'' - Km Fine: ''||Least( Greatest(Nvl(b.KM_FINE,0), Nvl(b.KM_INIZIO,0)), t.KM_FINE)';
--
sqlstringa := sqlstringa || '  Else    NULL     End Else    NULL     End LABEL ';
-- --------------------------- join fra tabelle ----------------------------------------------------
sqlstringa := sqlstringa || 'From        ';
sqlstringa := sqlstringa || '(select SOL_TRACK_1_1_1_0_0_1,SOL_TRACK_1_1_1_3_1_1_AP,SOL_TRACK_1_1_1_3_1_1,KM_INIZIO,KM_FINE,   ';
--05/02/2018 LAM da decommentare
sqlstringa := sqlstringa || ' trunc(LATITUDINE_INIZIO,5) LATITUDINE_INIZIO,  trunc(LONGITUDINE_INIZIO,5) LONGITUDINE_INIZIO,  ';
sqlstringa := sqlstringa || ' trunc(LATITUDINE_FINE,5)  LATITUDINE_FINE, trunc(LONGITUDINE_FINE,5) LONGITUDINE_FINE, ';
sqlstringa := sqlstringa || ' '' Km Inizio: ''||KM_INIZIO||'' - Lat\Lon Inizio: ''||trunc(LATITUDINE_INIZIO,5)||''\''||trunc(LONGITUDINE_INIZIO,5)|| '' - Km Fine: ''||KM_FINE|| '' - Lat\Lon Fine: ''||trunc(LATITUDINE_FINE,5)||''\''||trunc(LONGITUDINE_FINE,5) LABEL ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EC''';
sqlstringa := sqlstringa || ' AND KM_INIZIO IS NOT NULL            ';
sqlstringa := sqlstringa || ' AND LONGITUDINE_INIZIO IS NOT NULL   ';
sqlstringa := sqlstringa || ' AND LATITUDINE_INIZIO IS NOT NULL    ';
sqlstringa := sqlstringa || ' AND KM_FINE IS NOT NULL              ';
sqlstringa := sqlstringa || ' AND LATITUDINE_FINE IS NOT NULL      ';
sqlstringa := sqlstringa || ' AND LONGITUDINE_FINE IS NOT NULL     ';
--
IF p_versione IS NOT NULL THEN
       sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
--
sqlstringa := sqlstringa || ' UNION ';
sqlstringa := sqlstringa || ' select SOL_TRACK_1_1_1_0_0_1,SOL_TRACK_1_1_1_3_1_1_AP,SOL_TRACK_1_1_1_3_1_1, KM_INIZIO, KM_FINE   ';
--05/02/2018 LAM da decommentare
sqlstringa := sqlstringa || ' , NULL LATITUDINE_INIZIO, NULL LONGITUDINE_INIZIO, NULL LATITUDINE_FINE, NULL LONGITUDINE_FINE, NULL LABEL ';
sqlstringa := sqlstringa || 'from '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS ';
sqlstringa := sqlstringa || 'where tipo_dichiarazione=''EC''';
sqlstringa := sqlstringa || 'AND ( KM_INIZIO IS  NULL        ';
sqlstringa := sqlstringa || ' OR LATITUDINE_INIZIO IS  NULL     ';
sqlstringa := sqlstringa || ' OR LONGITUDINE_INIZIO IS  NULL    ';
sqlstringa := sqlstringa || ' OR KM_FINE IS  NULL               ';
sqlstringa := sqlstringa || ' OR LATITUDINE_FINE IS  NULL       ';
sqlstringa := sqlstringa || ' OR LONGITUDINE_FINE  IS  NULL )   ';
--
IF p_versione IS NOT NULL THEN
        sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
--
sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.BINARI_CORSA_SOL s ,            ';
sqlstringa := sqlstringa || '(SELECT SEDE_TECNICA, KM_INIZIO, KM_FINE ';
sqlstringa := sqlstringa || 'FROM '||  s_schema||'.SEZIONI_LINEA ';
--
IF p_versione IS NOT NULL THEN
        sqlstringa := sqlstringa || 'where CODICE_VERSIONE='||p_versione;
END IF;
--
sqlstringa := sqlstringa || ' ) t ';
sqlstringa := sqlstringa || 'where s.SOL_TRACK_1_1_1_0_0_1=b.SOL_TRACK_1_1_1_0_0_1 (+) and ';
sqlstringa := sqlstringa || 's.SOL_TRACK_1_1_1_0_0_1='''||p_Track||''''  ;
sqlstringa := sqlstringa || ' AND s.SEDE_TECNICA = t.SEDE_TECNICA ';
--
IF p_versione IS NOT NULL THEN
        sqlstringa := sqlstringa || 'and CODICE_VERSIONE='||p_versione;
END IF;
--
--sqlstringa := sqlstringa || 'order by SOL_TRACK_1_1_1_3_1_1, TIPO_DICHIARAZIONE, KM_INIZIO';
sqlstringa := sqlstringa || 'order by 3,5,6';
-- ---------------------------------------------------------------------------------------
--
--DBMS_OUTPUT.PUT_LINE(sqlstringa);
--
OPEN p_cursor FOR sqlstringa;
--
END GetTracks_Control_EC;
--
-- -----------------------------------------------------------------------------
PROCEDURE GetTracks_Inf_Tunnel (p_Track VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur) IS
--Ritorna l'elenco delle gallerie di  un Binario di Corsa di una SOL, con relativi parametri
-- -----------------------------------------------------------------------------

s_schema VARCHAR2(100);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
BEGIN
 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=GetLastVersion(p_area);
 END IF;

sqlstringa :=  'Select DISTINCT r.SOL_TRACK_1_1_1_0_0_1 Track_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.8.1'',SOL_TUNNEL_1_1_1_1_8_1) SOL_TUNNEL_1_1_1_1_8_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.8.1'',SOL_TUNNEL_1_1_1_1_8_1) SOL_TUNNEL_1_1_1_1_8_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.8.1'',SOL_TUNNEL_1_1_1_1_8_1) SOL_TUNNEL_1_1_1_1_8_1_DES,';
sqlstringa := sqlstringa || 'NVL(SOL_TUNNEL_1_1_1_1_8_1,''0083'') SOL_TUNNEL_1_1_1_1_8_1,   ';
sqlstringa := sqlstringa || 'g.SOL_TUNNEL_1_1_1_1_8_2 SOL_TUNNEL_1_1_1_1_8_2,   ';
sqlstringa := sqlstringa || 'g.SOL_TUNNEL_1_1_1_1_8_2_D SOL_TUNNEL_1_1_1_1_8_2_DES, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_3_AP, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_3, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_4_AP, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_4, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_7_AP, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_7, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_8_AP, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_8, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_9_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.8.9'',SOL_TUNNEL_1_1_1_1_8_9) SOL_TUNNEL_1_1_1_1_8_9_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.8.9'',SOL_TUNNEL_1_1_1_1_8_9) SOL_TUNNEL_1_1_1_1_8_9_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.8.9'',SOL_TUNNEL_1_1_1_1_8_9) SOL_TUNNEL_1_1_1_1_8_9_DES,';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_9, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_10_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.8.10'',SOL_TUNNEL_1_1_1_1_8_10) SOL_TUNNEL_1_1_1_1_8_10_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.8.10'',SOL_TUNNEL_1_1_1_1_8_10) SOL_TUNNEL_1_1_1_1_8_10_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.8.10'',SOL_TUNNEL_1_1_1_1_8_10) SOL_TUNNEL_1_1_1_1_8_10_DES,';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_10, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_11_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.8.11'',SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.8.11'',SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.8.11'',SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11_DES,';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_11 ';
sqlstringa := sqlstringa || 'from '||s_schema||'.GALLERIE_BINARI_SOL g, ';
sqlstringa := sqlstringa || s_schema||'.REL_GALLERIE_BINARI_SOL r ';
sqlstringa := sqlstringa || 'where  ';
sqlstringa := sqlstringa || 'G.SOL_TUNNEL_1_1_1_1_8_2=R.SOL_TUNNEL_1_1_1_1_8_2 and ';
sqlstringa := sqlstringa || 'r.SOL_TRACK_1_1_1_0_0_1='''||p_Track||''' ';
--09/01/2017 Inserita la condizione che estra i dati solo delle gallerie non diramate
sqlstringa := sqlstringa || 'and G.SOL_TUNNEL_1_1_1_1_8_2 IN (SELECT SOL_TUNNEL_1_1_1_1_8_2 FROM RINF_CONTROLLATI_EVO.GALLERIE_BINARI_SOL ';
sqlstringa := sqlstringa || ' MINUS ';
sqlstringa := sqlstringa || ' SELECT SOL_TUNNEL_1_1_1_1_8_2 FROM RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE) ';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and g.CODICE_VERSIONE='||p_versione;
sqlstringa := sqlstringa || 'and r.CODICE_VERSIONE='||p_versione;
END IF;
--09/01/2017 I dati delle gallerie diramate vengono estratti dalla tabella RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE
sqlstringa := sqlstringa || ' UNION ';
sqlstringa := sqlstringa || 'Select DISTINCT d.SOL_TRACK_1_1_1_0_0_1 Track_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.8.1'',SOL_TUNNEL_1_1_1_1_8_1) SOL_TUNNEL_1_1_1_1_8_1_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.8.1'',SOL_TUNNEL_1_1_1_1_8_1) SOL_TUNNEL_1_1_1_1_8_1_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.8.1'',SOL_TUNNEL_1_1_1_1_8_1) SOL_TUNNEL_1_1_1_1_8_1_DES,';
sqlstringa := sqlstringa || 'NVL(SOL_TUNNEL_1_1_1_1_8_1,''0083'') SOL_TUNNEL_1_1_1_1_8_1,   ';
sqlstringa := sqlstringa || 'g.SOL_TUNNEL_1_1_1_1_8_2 SOL_TUNNEL_1_1_1_1_8_2,   ';
sqlstringa := sqlstringa || 'g.SOL_TUNNEL_1_1_1_1_8_2_D SOL_TUNNEL_1_1_1_1_8_2_DES, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_3_AP, ';
sqlstringa := sqlstringa || '''Latitude (''|| TRIM(TO_CHAR(TRUNC(LATITUDINE_ORIGINE,4),''999.9999''))|| '') + Longitude (''|| TRIM(TO_CHAR(TRUNC(LONGITUDINE_ORIGINE,4),''S999.9999''))|| '') + km (''||TRIM(TO_CHAR(TRUNC(KM_INIZIO,3),''9990.999''))||'')'' SOL_TUNNEL_1_1_1_1_8_3, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_4_AP, ';
sqlstringa := sqlstringa || '''Latitude (''|| TRIM(TO_CHAR(TRUNC(LATITUDINE_DESTINAZIONE,4),''999.9999''))|| '') + Longitude (''|| TRIM(TO_CHAR(TRUNC(LONGITUDINE_DESTINAZIONE,4),''S999.9999''))|| '') + km (''||TRIM(TO_CHAR(TRUNC(KM_DESTINAZIONE,3),''9990.999''))||'')'' SOL_TUNNEL_1_1_1_1_8_4, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_7_AP, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_7, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_8_AP, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_8, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_9_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.8.9'',SOL_TUNNEL_1_1_1_1_8_9) SOL_TUNNEL_1_1_1_1_8_9_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.8.9'',SOL_TUNNEL_1_1_1_1_8_9) SOL_TUNNEL_1_1_1_1_8_9_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.8.9'',SOL_TUNNEL_1_1_1_1_8_9) SOL_TUNNEL_1_1_1_1_8_9_DES,';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_9, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_10_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.8.10'',SOL_TUNNEL_1_1_1_1_8_10) SOL_TUNNEL_1_1_1_1_8_10_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.8.10'',SOL_TUNNEL_1_1_1_1_8_10) SOL_TUNNEL_1_1_1_1_8_10_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.8.10'',SOL_TUNNEL_1_1_1_1_8_10) SOL_TUNNEL_1_1_1_1_8_10_DES,';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_10, ';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_11_AP, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.1.1.1.8.11'',SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.1.1.1.8.11'',SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.1.1.1.8.11'',SOL_TUNNEL_1_1_1_1_8_11) SOL_TUNNEL_1_1_1_1_8_11_DES,';
sqlstringa := sqlstringa || 'SOL_TUNNEL_1_1_1_1_8_11 ';
sqlstringa := sqlstringa || 'from '||s_schema||'.GALLERIE_BINARI_SOL g, ';
sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE d ';
sqlstringa := sqlstringa || 'where  ';
sqlstringa := sqlstringa || 'G.SOL_TUNNEL_1_1_1_1_8_2=d.SOL_TUNNEL_1_1_1_1_8_2 and ';
sqlstringa := sqlstringa || 'd.SOL_TRACK_1_1_1_0_0_1='''||p_Track||''' ';

IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || 'and g.CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ' order by 4';
--DBMS_OUTPUT.PUT_LINE(sqlstringa);
OPEN p_cursor FOR sqlstringa;
END GetTracks_Inf_Tunnel;





-- --------------------------------------------------------------------------------------------------------
PROCEDURE GetTracks_Inf_Tunnel_EC (p_Tunnel VARCHAR2,p_area NUMBER,p_i_versione NUMBER ,p_cursor OUT empcur) IS
--Ritorna l'elenco delle dichiarazioni di verifica EC e EI di una galleria di un Binario di Corsa di una SOL
-- --------------------------------------------------------------------------------------------------------
--
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(20000);
p_versione NUMBER;
--
BEGIN
  s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
  p_versione:=p_i_versione;
--
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
     p_versione:=GetLastVersion(p_area);
 END IF;


--versione Debora
-- --------------------------------------------- EC --------------------------------------------------------
sqlstringa :=  'Select DISTINCT s.SOL_TUNNEL_1_1_1_1_8_2 Tunnel_ID,  ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione,                                      ';
sqlstringa := sqlstringa || ' NVL(SOL_TUNNEL_1_1_1_1_8_5O6_AP,'''||GetNYA('1.1.1.1.8.5')||''') SOL_TUNNEL_1_1_1_1_8_5O6_AP, ';
-->
--sqlstringa := sqlstringa || 'NVL(SOL_TUNNEL_1_1_1_1_8_5O6, ''00/00000000000000/0000/000000'') SOL_TUNNEL_1_1_1_1_8_5O6, ';
sqlstringa := sqlstringa || ' CASE  WHEN (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length(Trim(SOL_TUNNEL_1_1_1_1_8_5O6)) >0 ) Then SOL_TUNNEL_1_1_1_1_8_5O6  Else ''00/00000000000000/0000/000000'' End SOL_TUNNEL_1_1_1_1_8_5O6, ';
-->
sqlstringa := sqlstringa || ' KM_INIZIO,  ';
sqlstringa := sqlstringa || ' KM_FINE     ';
sqlstringa := sqlstringa || ' from        ';
sqlstringa := sqlstringa || '(select SOL_TUNNEL_1_1_1_1_8_2, SOL_TUNNEL_1_1_1_1_8_5O6_AP, SOL_TUNNEL_1_1_1_1_8_5O6, KM_INIZIO, KM_FINE   ';
sqlstringa := sqlstringa || ' from '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_SOL ';
sqlstringa := sqlstringa || ' where tipo_dichiarazione=''EC''';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || ' and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_BINARI_SOL s            ';
sqlstringa := sqlstringa || 'where s.SOL_TUNNEL_1_1_1_1_8_2=b.SOL_TUNNEL_1_1_1_1_8_2 (+) and ';
sqlstringa := sqlstringa || 's.SOL_TUNNEL_1_1_1_1_8_2='''||p_Tunnel||''''  ;
sqlstringa := sqlstringa || ' UNION ';
sqlstringa := sqlstringa || ' Select DISTINCT s.SOL_TUNNEL_1_1_1_1_8_2 Tunnel_ID,  ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione),'NULL')||' CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || ' ''EI'' tipo_dichiarazione,                                      ';
sqlstringa := sqlstringa || 'NVL(SOL_TUNNEL_1_1_1_1_8_5O6_AP,'''||GetNYA('1.1.1.1.8.6')||''') SOL_TUNNEL_1_1_1_1_8_5O6_AP, ';
-->
--sqlstringa := sqlstringa || 'NVL(SOL_TUNNEL_1_1_1_1_8_5O6, ''00/00000000000000/0000/000000'') SOL_TUNNEL_1_1_1_1_8_5O6, ';
sqlstringa := sqlstringa || ' CASE  WHEN (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length(Trim(SOL_TUNNEL_1_1_1_1_8_5O6)) >0 ) Then SOL_TUNNEL_1_1_1_1_8_5O6  Else ''00/00000000000000/0000/000000'' End SOL_TUNNEL_1_1_1_1_8_5O6, ';
-->
sqlstringa := sqlstringa || ' KM_INIZIO,  ';
sqlstringa := sqlstringa || ' KM_FINE     ';
sqlstringa := sqlstringa || ' from        ';
sqlstringa := sqlstringa || ' (select SOL_TUNNEL_1_1_1_1_8_2,SOL_TUNNEL_1_1_1_1_8_5O6_AP,SOL_TUNNEL_1_1_1_1_8_5O6,KM_INIZIO,KM_FINE   ';
sqlstringa := sqlstringa || ' from '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_SOL ';
sqlstringa := sqlstringa || ' where tipo_dichiarazione=''EI''';
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || ' and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ') b,                 ';
sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_BINARI_SOL s            ';
sqlstringa := sqlstringa || ' where s.SOL_TUNNEL_1_1_1_1_8_2=b.SOL_TUNNEL_1_1_1_1_8_2 (+) and ';
sqlstringa := sqlstringa || ' s.SOL_TUNNEL_1_1_1_1_8_2='''||p_Tunnel||''''  ;
IF p_versione IS NOT NULL THEN
sqlstringa := sqlstringa || ' and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa := sqlstringa || ' order by 3,6 ';

/******************************************************************************************


-- ---------------- EC ---------------------------------------------------------
sqlstringa :=  'Select DISTINCT s.SOL_TUNNEL_1_1_1_1_8_2 Tunnel_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione), 'NULL')||' CODICE_VERSIONE, ';
sqlstringa := sqlstringa || '''EC'' tipo_dichiarazione, ';
sqlstringa := sqlstringa || ' NVL(SOL_TUNNEL_1_1_1_1_8_5O6_AP,'''||PKG_RINF_DATA_V082.GetNYA('1.1.1.1.8.5')||''') SOL_TUNNEL_1_1_1_1_8_5O6_AP, ';
--
sqlstringa := sqlstringa || ' CASE  WHEN (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length(Trim(SOL_TUNNEL_1_1_1_1_8_5O6)) >0 ) Then SOL_TUNNEL_1_1_1_1_8_5O6  Else ''00/00000000000000/0000/000000'' End SOL_TUNNEL_1_1_1_1_8_5O6, ';
-->
-- KM_INIZIO
sqlstringa := sqlstringa || ' Case When ( SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then ';
sqlstringa := sqlstringa || ' REPLACE(Greatest (Least (NVL (b.KM_INIZIO, 0), NVL (b.KM_FINE, 0)), NVL(s.KM_INIZIO,0)), '','', ''.'') Else  NULL End Else NULL  End  KM_INIZIO, ';
-- KM_FINE
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO And s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO And s.KM_FINE)) Then ';
sqlstringa := sqlstringa || ' REPLACE(Least (Greatest (NVL (b.KM_INIZIO, 0), NVL (b.KM_FINE, 0)), NVL(s.KM_FINE,0)), '','', ''.'') Else NULL END ELSE NULL End KM_FINE, ';
-- LATITUDINE_INIZIO
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ( (b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  s.KM_INIZIO), 1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End Else  NULL End LATITUDINE_INIZIO, ';
--LONGITUDINE_INIZIO
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  s.KM_INIZIO), 2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End Else NULL End LONGITUDINE_INIZIO, ';
-- LATITUDINE_FINE
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), s.KM_FINE),  1) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End Else NULL End LATITUDINE_FINE, ';
-- LONGITUDINE_FINE
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO And s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO And s.KM_FINE)) Then  ';
sqlstringa := sqlstringa || ' LTrim( To_Char( Nvl( Trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), Least (Greatest(b.KM_FINE, b.KM_INIZIO), s.KM_FINE), 2) ), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End Else NULL End LONGITUDINE_FINE, ';
-->
-- ALTERNATIVA
-- LATITUDINE_INIZIO
--sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' Case When ( b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ( (b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  s.KM_INIZIO), 1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else  ''00.00000'' End Else NULL End  LATITUDINE_INIZIO, ';
--LONGITUDINE_INIZIO
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' Case When ( b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then ''+00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then  ';
sqlstringa := sqlstringa || ' ''+''||LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  s.KM_INIZIO), 2) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else NULL End LONGITUDINE_INIZIO, ';
-- LATITUDINE_FINE
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' Case When ( b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), s.KM_FINE),  1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else  ''00.00000'' End Else NULL End LATITUDINE_FINE, ';
-- LONGITUDINE_FINE
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' Case When ( b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO And s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO And s.KM_FINE)) Then  ';
sqlstringa := sqlstringa || ' LTrim( To_Char( Nvl( Trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), Least (Greatest(b.KM_FINE, b.KM_INIZIO), s.KM_FINE), 2) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else NULL End  LONGITUDINE_FINE, ';


-->
-- KM_INIZIO_GAL, KM_FINE_GAL
-- sqlstringa := sqlstringa || ' LTrim(to_char(s.KM_INIZIO,''9990D99999'')) KM_INIZIO_gal, LTrim(to_char(s.KM_FINE,''9990D99999'')) KM_FINE_gal, ';
sqlstringa := sqlstringa || ' Replace(s.KM_INIZIO, '','', ''.'') KM_INIZIO_gal, Replace(s.KM_FINE, '','', ''.'') KM_FINE_gal, ';
-- LATITUDINE_INIZIO_gal
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), s.KM_INIZIO, 1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End  LATITUDINE_INIZIO_gal, ';
-- LONGITUDINE_INIZIO_gal
sqlstringa := sqlstringa || '  Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), s.KM_INIZIO, 2), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else  NULL End LONGITUDINE_INIZIO_gal, ';
-- LATITUDINE_FINE_gal
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), s.KM_FINE,  1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LATITUDINE_FINE_gal, ';
-- LONGITUDINE_FINE_gal
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), s.KM_FINE,  2), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LONGITUDINE_FINE_gal, ';
--> LABEL
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then NULL ';
--
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then  ';
--
sqlstringa := sqlstringa || ' '' Km Inizio: '' ||Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  s.KM_INIZIO)||'' - Km Fine: ''||Least( Greatest(Nvl(b.KM_FINE,0), Nvl(b.KM_INIZIO,0)), s.KM_FINE)';
-->
--sqlstringa := sqlstringa || ' ELSE  ''Binario: '' || s.SOL_TUNNEL_1_1_1_1_8_2 ||  '' del Tunnel: ''||substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6)||'' (Km inizio: '' || RPAD(s.KM_INIZIO,10,'' '')';
--sqlstringa := sqlstringa || ' || '' Km fine: '' || RPAD(s.KM_FINE,10,'' '')|| '') il Certificato: ''|| SOL_TUNNEL_1_1_1_1_8_5O6 ||'' è Fuori Range'' End Else    NULL    End LABEL ';
sqlstringa := sqlstringa || ' ELSE NULL End Else NULL End LABEL ';
-- --------------------------- join fra tabelle ----------------------------------------------------
sqlstringa := sqlstringa || ' from        ';
sqlstringa := sqlstringa || '(select SOL_TUNNEL_1_1_1_1_8_2, SOL_TUNNEL_1_1_1_1_8_5O6_AP, SOL_TUNNEL_1_1_1_1_8_5O6, KM_INIZIO, KM_FINE, ';
sqlstringa := sqlstringa || ' LATITUDINE_INIZIO,  LONGITUDINE_INIZIO,  LATITUDINE_FINE, LONGITUDINE_FINE, ';
sqlstringa := sqlstringa || ' NULL LABEL ';
sqlstringa := sqlstringa || ' from '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_SOL ';
sqlstringa := sqlstringa || ' where tipo_dichiarazione=''EC''';
--
IF p_versione IS NOT NULL and (p_area=2 OR p_area=4) THEN
     sqlstringa := sqlstringa || ' and CODICE_VERSIONE='||p_versione;
END IF;
--
sqlstringa := sqlstringa || ') b,  ';
sqlstringa := sqlstringa || '( select SOL_TUNNEL_1_1_1_1_8_2,  ';
sqlstringa := sqlstringa || ' To_Number(Trim(Substr(SOL_TUNNEL_1_1_1_1_8_3, Instr(SOL_TUNNEL_1_1_1_1_8_3,''km ('', 1,1)+4, (Instr(SOL_TUNNEL_1_1_1_1_8_3,'')'',-1) - Instr(SOL_TUNNEL_1_1_1_1_8_3,''km ('', 1,1)-4)))) KM_INIZIO, ';
sqlstringa := sqlstringa || ' To_Number(Trim(Substr(SOL_TUNNEL_1_1_1_1_8_4, Instr(SOL_TUNNEL_1_1_1_1_8_4,''km ('', 1,1)+4, (Instr(SOL_TUNNEL_1_1_1_1_8_4,'')'',-1) - Instr(SOL_TUNNEL_1_1_1_1_8_4,''km ('', 1,1)-4)))) KM_FINE ';

IF p_versione IS NOT NULL and (p_area=2 OR p_area=4) THEN
     sqlstringa := sqlstringa || ', CODICE_VERSIONE ';
END IF;
sqlstringa := sqlstringa || ' From ';
sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_BINARI_SOL  ';
IF p_versione IS NOT NULL and (p_area=2 OR p_area=4) THEN
    sqlstringa := sqlstringa || ' where CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa := sqlstringa ||') s    ';
sqlstringa := sqlstringa || ' where s.SOL_TUNNEL_1_1_1_1_8_2=b.SOL_TUNNEL_1_1_1_1_8_2 (+) and ';
sqlstringa := sqlstringa || ' s.SOL_TUNNEL_1_1_1_1_8_2='''||p_Tunnel||''''  ;

sqlstringa := sqlstringa || ' UNION ';

-- ---------------- EI ---------------------------------------------------------
sqlstringa := sqlstringa ||' Select DISTINCT s.SOL_TUNNEL_1_1_1_1_8_2 Tunnel_ID,  ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_versione), 'NULL')||' CODICE_VERSIONE,      ';
sqlstringa := sqlstringa || '''EI'' tipo_dichiarazione, ';
sqlstringa := sqlstringa || ' NVL(SOL_TUNNEL_1_1_1_1_8_5O6_AP,'''||PKG_RINF_DATA_V082.GetNYA('1.1.1.1.8.5')||''') SOL_TUNNEL_1_1_1_1_8_5O6_AP, ';
--
sqlstringa := sqlstringa || ' CASE  WHEN (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length(Trim(SOL_TUNNEL_1_1_1_1_8_5O6)) >0 ) Then SOL_TUNNEL_1_1_1_1_8_5O6  Else ''00/00000000000000/0000/000000'' End SOL_TUNNEL_1_1_1_1_8_5O6, ';
-->
-- KM_INIZIO
sqlstringa := sqlstringa || ' Case When ( SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then ';
sqlstringa := sqlstringa || ' REPLACE(Greatest (Least (NVL (b.KM_INIZIO, 0), NVL (b.KM_FINE, 0)), NVL(s.KM_INIZIO,0)), '','', ''.'') Else  NULL End Else NULL  End  KM_INIZIO, ';
-- KM_FINE
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO And s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO And s.KM_FINE)) Then ';
sqlstringa := sqlstringa || ' REPLACE(Least (Greatest (NVL (b.KM_INIZIO, 0), NVL (b.KM_FINE, 0)), NVL(s.KM_FINE,0)), '','', ''.'') Else NULL END ELSE NULL End KM_FINE, ';
-- LATITUDINE_INIZIO
--sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' Case When ( b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ( (b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then  ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  s.KM_INIZIO), 1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else  ''00.00000'' End Else NULL End  LATITUDINE_INIZIO, ';
--LONGITUDINE_INIZIO
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' Case When ( b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then ''+00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then  ';
sqlstringa := sqlstringa || ' ''+''||LTrim(To_Char(Nvl(Trim(LONGITUDINE_INIZIO), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), Greatest( Least(Nvl(b.KM_INIZIO,0), nvl(b.KM_FINE,0)),  s.KM_INIZIO), 2) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else NULL End LONGITUDINE_INIZIO, ';
-- LATITUDINE_FINE
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' Case When ( b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then ''00.00000'' ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(Nvl(Trim(LATITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), Least( Greatest(b.KM_FINE, b.KM_INIZIO), s.KM_FINE),  1) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else  ''00.00000'' End Else  ''00.00000'' End Else NULL End LATITUDINE_FINE, ';
-- LONGITUDINE_FINE
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' Case When ( b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then NULL ';
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO And s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO And s.KM_FINE)) Then  ';
sqlstringa := sqlstringa || ' LTrim( To_Char( Nvl( Trim(LONGITUDINE_FINE), PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), Least (Greatest(b.KM_FINE, b.KM_INIZIO), s.KM_FINE), 2) ), ''9900.99999'')) ';
sqlstringa := sqlstringa || ' Else ''+00.00000'' End Else ''+00.00000'' End Else NULL End  LONGITUDINE_FINE, ';
-->
-- KM_INIZIO_GAL, KM_FINE_GAL
-- sqlstringa := sqlstringa || ' LTrim(to_char(s.KM_INIZIO,''9990D99999'')) KM_INIZIO_gal, LTrim(to_char(s.KM_FINE,''9990D99999'')) KM_FINE_gal, ';
sqlstringa := sqlstringa || ' Replace(s.KM_INIZIO, '','', ''.'') KM_INIZIO_gal, Replace(s.KM_FINE, '','', ''.'') KM_FINE_gal, ';
-- LATITUDINE_INIZIO_gal
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), s.KM_INIZIO, 1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End  LATITUDINE_INIZIO_gal, ';
-- LONGITUDINE_INIZIO_gal
sqlstringa := sqlstringa || '  Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), s.KM_INIZIO, 2), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else  NULL End LONGITUDINE_INIZIO_gal, ';
-- LATITUDINE_FINE_gal
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(Substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), s.KM_FINE,  1), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LATITUDINE_FINE_gal, ';
-- LONGITUDINE_FINE_gal
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0) Then ';
sqlstringa := sqlstringa || ' LTrim(To_Char(PKG_RINF_CONTROLLO_v082.GetLatLonFromKm(substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6), s.KM_FINE,  2), ''9990.99999'')) ';
sqlstringa := sqlstringa || ' Else NULL End LONGITUDINE_FINE_gal, ';
--> LABEL
sqlstringa := sqlstringa || ' Case When (SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''Y'' And Length (Trim (SOL_TUNNEL_1_1_1_1_8_5O6)) > 0 And b.KM_INIZIO >= 0 And b.KM_FINE > 0) Then ';
sqlstringa := sqlstringa || ' Case When ((b.KM_INIZIO <= s.KM_INIZIO And b.KM_FINE >= s.KM_FINE) Or (b.KM_FINE <= s.KM_INIZIO And b.KM_INIZIO >= s.KM_FINE)) Then NULL ';
--
sqlstringa := sqlstringa || ' When ((b.KM_INIZIO Between s.KM_INIZIO AND s.KM_FINE) OR (b.KM_FINE Between s.KM_INIZIO AND s.KM_FINE)) Then  ';
--
sqlstringa := sqlstringa || ' '' Km Inizio: '' ||Greatest( Least(Nvl(b.KM_INIZIO,0), Nvl(b.KM_FINE,0)),  s.KM_INIZIO)||'' - Km Fine: ''||Least( Greatest(Nvl(b.KM_FINE,0), Nvl(b.KM_INIZIO,0)), s.KM_FINE)';
-->
--sqlstringa := sqlstringa || ' ELSE  ''Binario: '' || s.SOL_TUNNEL_1_1_1_1_8_2 ||  '' del Tunnel: ''||substr(s.SOL_TUNNEL_1_1_1_1_8_2, 1, 6)||'' (Km inizio: '' || RPAD(s.KM_INIZIO,10,'' '')';
--sqlstringa := sqlstringa || ' || '' Km fine: '' || RPAD(s.KM_FINE,10,'' '')|| '') il Certificato: ''|| SOL_TUNNEL_1_1_1_1_8_5O6 ||'' è Fuori Range'' End Else    NULL    End LABEL ';
sqlstringa := sqlstringa || ' ELSE NULL End Else NULL End LABEL ';
-- --------------------------- join fra tabelle ----------------------------------------------------
sqlstringa := sqlstringa || ' From        ';
sqlstringa := sqlstringa || '(select SOL_TUNNEL_1_1_1_1_8_2, SOL_TUNNEL_1_1_1_1_8_5O6_AP, SOL_TUNNEL_1_1_1_1_8_5O6, KM_INIZIO, KM_FINE, ';
sqlstringa := sqlstringa || ' LATITUDINE_INIZIO,  LONGITUDINE_INIZIO,  LATITUDINE_FINE, LONGITUDINE_FINE, ';
sqlstringa := sqlstringa || ' NULL LABEL ';
sqlstringa := sqlstringa || ' from '||s_schema||'.DICHIARAZIONI_GALLERIE_BIN_SOL ';
sqlstringa := sqlstringa || ' where tipo_dichiarazione=''EI''';
--
IF p_versione IS NOT NULL and (p_area=2 OR p_area=4) THEN
     sqlstringa := sqlstringa || ' and CODICE_VERSIONE='||p_versione;
END IF;
--
sqlstringa := sqlstringa || ') b,  ';
sqlstringa := sqlstringa || '( select SOL_TUNNEL_1_1_1_1_8_2,  ';
sqlstringa := sqlstringa || ' To_Number(Trim(Substr(SOL_TUNNEL_1_1_1_1_8_3, Instr(SOL_TUNNEL_1_1_1_1_8_3,''km ('', 1,1)+4, (Instr(SOL_TUNNEL_1_1_1_1_8_3,'')'',-1) - Instr(SOL_TUNNEL_1_1_1_1_8_3,''km ('', 1,1)-4)))) KM_INIZIO, ';
sqlstringa := sqlstringa || ' To_Number(Trim(Substr(SOL_TUNNEL_1_1_1_1_8_4, Instr(SOL_TUNNEL_1_1_1_1_8_4,''km ('', 1,1)+4, (Instr(SOL_TUNNEL_1_1_1_1_8_4,'')'',-1) - Instr(SOL_TUNNEL_1_1_1_1_8_4,''km ('', 1,1)-4)))) KM_FINE ';

IF p_versione IS NOT NULL and (p_area=2 OR p_area=4) THEN
     sqlstringa := sqlstringa || ', CODICE_VERSIONE ';
END IF;
sqlstringa := sqlstringa || ' From ';
sqlstringa := sqlstringa ||  s_schema||'.GALLERIE_BINARI_SOL  ';
IF p_versione IS NOT NULL and (p_area=2 OR p_area=4) THEN
    sqlstringa := sqlstringa || ' where CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa := sqlstringa ||') s    ';
sqlstringa := sqlstringa || ' where s.SOL_TUNNEL_1_1_1_1_8_2=b.SOL_TUNNEL_1_1_1_1_8_2 (+) and ';
sqlstringa := sqlstringa || ' s.SOL_TUNNEL_1_1_1_1_8_2='''||p_Tunnel||''''  ;

IF p_versione IS NOT NULL and (p_area=2 OR p_area=4)  THEN
     sqlstringa := sqlstringa || ' and CODICE_VERSIONE='||p_versione;
END IF;

--sqlstringa := sqlstringa || ' order by TUNNEL_ID, TIPO_DICHIARAZIONE, KM_INIZIO ';
sqlstringa := sqlstringa || ' order by 3,5,6 ';


****************************************************************************************************/
--
-- -----------------------------------------------------------------------------
--
--DBMS_OUTPUT.PUT_LINE (sqlstringa);
--
OPEN p_cursor FOR sqlstringa;

 EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE ('Errore ' || SUBSTR (SQLERRM, 1, 300));
END GetTracks_Inf_Tunnel_EC;




-- -----------------------------------------------------------------------------
PROCEDURE GetOP_PrivateSiding (p_i_versione NUMBER ,p_cursor OUT sys_refcursor) IS
--Ritorna i parametri principali di un Raccordo
s_schema VARCHAR2(100);
sqlstringa VARCHAR2(5000);
BEGIN

sqlstringa :=  'SELECT     l.PO_1_2_0_0_0_2 PO_ID, ';
sqlstringa := sqlstringa || NVL(TO_CHAR( p_i_versione),'NULL')||' CODICE_VERSIONE,';
sqlstringa := sqlstringa || 'PO_1_2_0_0_0_1_DEFINIZIONE PO_1_2_0_0_0_1, ';
sqlstringa := sqlstringa || 'l.PO_1_2_0_0_0_2, ';
sqlstringa := sqlstringa || 'DECODE(PO_1_2_0_0_0_3,''NYA'',''N'',''Y'') PO_1_2_0_0_0_3_AP, ';
sqlstringa := sqlstringa || 'PO_1_2_0_0_0_3, ';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetXmlValue(''1.2.0.0.0.4'',LOWER(PO_1_2_0_0_0_4)) PO_1_2_0_0_0_4_XML,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetOptionalValue(''1.2.0.0.0.4'',LOWER(PO_1_2_0_0_0_4)) PO_1_2_0_0_0_4_OV,';
sqlstringa := sqlstringa || 'PKG_RINF_DATA_V082.GetDescription(''1.2.0.0.0.4'',LOWER(PO_1_2_0_0_0_4)) PO_1_2_0_0_0_4_DES,';
sqlstringa := sqlstringa || ' LOWER(PO_1_2_0_0_0_4) PO_1_2_0_0_0_4, ';
--sqlstringa := sqlstringa || '''Latitude (''|| TRIM(TO_CHAR(TRUNC(PO_1_2_0_0_0_5_LATITUDINE,4),''999.9999''))|| '') + Longitude (''|| TRIM(TO_CHAR(TRUNC(PO_1_2_0_0_0_5_LONGITUDINE,4),''S999.9999''))|| '')'' PO_1_2_0_0_0_5, ';
-- modifica del 22/10/2018 per visualizzare le latitudini e longitudini con 0.0 quando sono =0
sqlstringa := sqlstringa || '''Latitude (''|| case when PO_1_2_0_0_0_5_LATITUDINE=0  then ''0.0'' else TRIM (TO_CHAR (TRUNC (PO_1_2_0_0_0_5_LATITUDINE, 4), ''999.9999'')) end || '') '' ||';
sqlstringa := sqlstringa || '''+ Longitude (''|| case when PO_1_2_0_0_0_5_LONGITUDINE = 0 then ''0.0'' else TRIM (TO_CHAR (TRUNC (PO_1_2_0_0_0_5_LONGITUDINE, 4), ''S999.9999'')) end|| '')'' PO_1_2_0_0_0_5, ';
--
sqlstringa := sqlstringa || 'NVL(TRIM(PKG_RINF_INSERIMENTI.GetLineaComm(LOCALITA_RIFERIMENTO, '||CASE WHEN p_i_versione IS NULL THEN 1 ELSE 2 END||','||NVL(TO_CHAR( p_i_versione),'NULL')||')),''0000 / 0.000'')  PO_1_2_0_0_0_6, ';
sqlstringa := sqlstringa || 'NULL CACHE_FIELD ';
sqlstringa := sqlstringa || 'from RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI l, ';

IF p_i_versione IS NOT NULL THEN
    sqlstringa := sqlstringa || 'RINF_ANAGRAFICHE_EVO.RACCORDI_REGISTRO r ';
    sqlstringa := sqlstringa || 'where r.PO_1_2_0_0_0_2=l.PO_1_2_0_0_0_2 AND ';
    sqlstringa := sqlstringa || ' r.PROG=l.PROG  AND ';
    sqlstringa := sqlstringa || ' r.CODICE_VERSIONE= '||p_i_versione;
ELSE
    sqlstringa := sqlstringa || '(  SELECT PO_1_2_0_0_0_2, MAX (PROG) PROG ';
    sqlstringa := sqlstringa || 'FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI ';
    sqlstringa := sqlstringa || ' WHERE CODICE_STATO = 2 ';
    sqlstringa := sqlstringa || 'GROUP BY PO_1_2_0_0_0_2) r ';
    sqlstringa := sqlstringa || 'where r.PO_1_2_0_0_0_2=l.PO_1_2_0_0_0_2 AND ';
    sqlstringa := sqlstringa || ' r.PROG=l.PROG  ';
END IF;

sqlstringa := sqlstringa || 'order by 1 ';
OPEN p_cursor FOR sqlstringa;
DBMS_OUTPUT.PUT_LINE(sqlstringa);
END GetOP_PrivateSiding;
END PKG_RINF_DATA_V082;
/