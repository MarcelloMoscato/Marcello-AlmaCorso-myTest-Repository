--
-- PKG_RINF_GRAFICA  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_GRAFICA" AS
/******************************************************************************
   NAME:       PKG_RINF_GIS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/11/2016   D.Campagiorni    1. Created this package.
******************************************************************************/

  Type empcur Is Ref CURSOR;
 Procedure GetAllTematismi( p_cursor OUT empcur);
 Procedure GetDominio(p_tematismo VARCHAR2, p_cursor OUT empcur);
--
 Procedure GetPOTematismo ( p_tematismo NUMBER,p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2, p_i_versione NUMBER,xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER, p_cursor OUT empcur);
 Procedure GetSOLTematismo ( p_tematismo NUMBER,p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2, p_i_versione NUMBER,xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER, p_cursor OUT empcur);
 Procedure GetAllTipologie( p_cursor OUT empcur);
 Procedure GetPOEtichetta ( p_tipologia NUMBER,p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2, p_i_versione NUMBER, xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER,p_cursor OUT empcur);
 Procedure GetSOLEtichetta ( p_tipologia NUMBER,p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2, p_i_versione NUMBER, xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER,p_cursor OUT empcur);
 Procedure GetEtichetta ( p_tipologia NUMBER,p_contesto_SOL_OP NUMBER,p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2, p_i_versione NUMBER, xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER,p_cursor OUT empcur);
 Procedure GetAllDomini( p_cursor OUT empcur);
 Procedure SetNewDominio(p_tematismo NUMBER, p_valore VARCHAR2, p_colore VARCHAR2, p_error OUT NUMBER);
 Procedure SetUpdateDominio(p_tematismo VARCHAR2,p_valore VARCHAR2, p_colore VARCHAR2, p_error OUT NUMBER);
 Procedure SetDeleteDominio(p_tematismo NUMBER, p_valore VARCHAR2, p_error OUT NUMBER);
End PKG_RINF_GRAFICA;
/


--
-- PKG_RINF_GRAFICA  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_GRAFICA" AS
/******************************************************************************
   NAME:       PKG_RINF_GIS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/11/2016   D.Campagiorni    1. Created this package.
******************************************************************************/
--
-- --------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------
--
 Procedure GetAllTematismi( p_cursor OUT empcur ) IS
    sqlstringa VARCHAR2(500);
  Begin

    sqlstringa := 'Select CODICE_TEMATISMO, 1 CODICE_CONTESTO, DESCRIZIONE||'' - ''|| ''PO'' DESCRIZIONE';
    sqlstringa := sqlstringa||' From Rinf_Anagrafiche_Evo.ANAG_TEMATISMI ';
    sqlstringa := sqlstringa||' Where ';
    sqlstringa := sqlstringa||' FLAG_OP = 1 ';
    sqlstringa := sqlstringa||' Union ';
    sqlstringa := sqlstringa||' Select CODICE_TEMATISMO, 2 CODICE_CONTESTO, DESCRIZIONE||'' - ''|| ''SOL'' DESCRIZIONE ';
    sqlstringa := sqlstringa||' From Rinf_Anagrafiche_Evo.ANAG_TEMATISMI ';
    sqlstringa := sqlstringa||' Where ';
    sqlstringa := sqlstringa||' FLAG_SOL = 1';
    sqlstringa := sqlstringa||' Order By 1,2 ';
--
    Open p_cursor For sqlstringa;
--
 End GetAllTematismi;
--
-- --------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetDominio(p_tematismo VARCHAR2, p_cursor OUT empcur) IS

BEGIN
OPEN p_cursor FOR
Select CODICE_TEMATISMO,VALORE,COLORE
FROM RINF_ANAGRAFICHE_EVO.DOMINIO_TEMATISMO
where codice_tematismo=p_tematismo
order by progressivo;
END;
--
-- --------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------
--

PROCEDURE GetAllDomini( p_cursor OUT empcur) IS

BEGIN
OPEN p_cursor FOR
Select CODICE_TEMATISMO,VALORE,COLORE
FROM RINF_ANAGRAFICHE_EVO.DOMINIO_TEMATISMO
order by CODICE_TEMATISMO,progressivo;
END GetAllDomini;
PROCEDURE SetNewDominio(p_tematismo NUMBER, p_valore VARCHAR2, p_colore VARCHAR2, p_error OUT NUMBER) IS

BEGIN
p_error:=0;

INSERT INTO RINF_ANAGRAFICHE_EVO.DOMINIO_TEMATISMO(CODICE_TEMATISMO, PROGRESSIVO, VALORE, COLORE)
SELECT p_tematismo, MAX(PROGRESSIVO)+1,p_valore,p_colore
FROM RINF_ANAGRAFICHE_EVO.DOMINIO_TEMATISMO
WHERE codice_tematismo=p_tematismo;

EXCEPTION
      WHEN OTHERS
      THEN
         p_error := SQLCODE;
END SetNewDominio;
--
-- --------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------
--

PROCEDURE SetUpdateDominio(p_tematismo VARCHAR2,p_valore VARCHAR2, p_colore VARCHAR2, p_error OUT NUMBER) IS

BEGIN
p_error:=0;

UPDATE RINF_ANAGRAFICHE_EVO.DOMINIO_TEMATISMO
SET COLORE=p_colore
where codice_tematismo=p_tematismo
and valore=p_valore;

EXCEPTION
      WHEN OTHERS
      THEN
         p_error := SQLCODE;
END SetUpdateDominio;
--
-- --------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------
--

PROCEDURE SetDeleteDominio(p_tematismo NUMBER, p_valore VARCHAR2, p_error OUT NUMBER) IS

BEGIN
p_error:=0;

DELETE FROM RINF_ANAGRAFICHE_EVO.DOMINIO_TEMATISMO
WHERE codice_tematismo=p_tematismo
and valore=p_valore;

EXCEPTION
      WHEN OTHERS
      THEN
         p_error := SQLCODE;
END SetDeleteDominio;
--
-- --------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------
--
PROCEDURE GetPOTematismo ( p_tematismo NUMBER,p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2, p_i_versione NUMBER, xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER,p_cursor OUT empcur) IS
sqlstringa VARCHAR2(32000);
p_versione NUMBER;
s_schema VARCHAR2(200);
sqlstringa_2 VARCHAR2(32000);
n_zoom NUMBER;
n_versione_MDR NUMBER;
BEGIN

select PKG_RINF_GIS_V2.FNC_GET_ZOOM(xtl , ytl , xbr , ybr ) into n_zoom from dual;

IF p_area is not null THEN
    s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
END IF;

 p_versione:=p_i_versione;
  IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=PKG_RINF_DATA_V082.GetLastVersion(p_area);
 END IF;

 --15/11/2017 Per la Storicizzazione del MDR GIS è necessario individuare la versione del MDR GIS corrispondente all'ultimo RI Pubblicato/Inviato
   n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(p_area,p_versione);

 CASE
 WHEN p_tematismo=1 --Certificazioni
 THEN
 sqlstringa:=' (SELECT s.sede_tecnica, ';
sqlstringa:=sqlstringa||'        DECODE (dic.sede_tecnica, NULL, ''NO'', ''SI'') valore, ';
sqlstringa:=sqlstringa||'        DECODE (dic.sede_tecnica, NULL, NULL, tooltip) tooltip, ';
sqlstringa:=sqlstringa||'        NULL etichetta ';
sqlstringa:=sqlstringa||'   FROM '||s_schema||'.PUNTI_OPERATIVI s, ';
sqlstringa:=sqlstringa||'        (  SELECT SEDE_TECNICA, ';
sqlstringa:=sqlstringa||'                  LISTAGG (TIPO_DICHIARAZIONE || '': '' || dichiarazione, '';'') ';
sqlstringa:=sqlstringa||'                     WITHIN GROUP (ORDER BY dichiarazione) ';
sqlstringa:=sqlstringa||'                     AS tooltip ';
sqlstringa:=sqlstringa||'             FROM (SELECT SUBSTR (PO_TRACK_1_2_1_0_0_2, 1, 6) sede_tecnica, ';
sqlstringa:=sqlstringa||'                          ''INF - '' || TIPO_DICHIARAZIONE TIPO_DICHIARAZIONE, ';
sqlstringa:=sqlstringa||'                          PO_TRACK_1_2_1_0_1_1O2 dichiarazione ';
sqlstringa:=sqlstringa||'                     FROM '||s_schema||'.DICHIARAZIONI_BINARIO_PO ';
sqlstringa:=sqlstringa||'                    WHERE     PO_TRACK_1_2_1_0_1_1O2_AP = ''Y'' ';
IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
END IF;
sqlstringa:=sqlstringa||' ) ';
sqlstringa:=sqlstringa||'         GROUP BY SEDE_TECNICA) DIC ';
sqlstringa:=sqlstringa||'  WHERE     s.sede_tecnica = dic.sede_tecnica(+) ';
IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and s.CODICE_VERSIONE='||p_versione;
END IF;
IF p_contesto<>9 THEN
sqlstringa:=sqlstringa||' and s.sede_tecnica  IN (';
sqlstringa:=sqlstringa||' Select DISTINCT SEDE_TECNICA  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS where codice_contesto='||p_contesto;
  sqlstringa:=sqlstringa||' and CODICE='''||p_filtro ||'''';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
  sqlstringa:=sqlstringa||')';
END IF;
  WHEN p_tematismo=2 --Linea Ten
 THEN
sqlstringa:=' (Select s.SEDE_TECNICA, ';
sqlstringa:=sqlstringa||' NVL(LISTAGG(l_ten.ten_t,'';'')  WITHIN GROUP (ORDER BY l_ten.ten_t) ,''Non Applicabile'') valore, ';
sqlstringa:=sqlstringa||'  NVL(l_tooltip.tooltip,''Non Applicabile'') tooltip,';
sqlstringa:=sqlstringa||' LISTAGG(l_ten.ten_t,'';'')  WITHIN GROUP (ORDER BY l_ten.ten_t) etichetta';
sqlstringa:=sqlstringa||' from';
sqlstringa:=sqlstringa||' (select DISTINCT SUBSTR(PO_TRACK_1_2_1_0_0_2,1,6) SEDE_TECNICA, DECODE(d.VALORE,''Off TEN'',''OFF TEN'',''TEN-T'') ten_t';
sqlstringa:=sqlstringa||' from '||s_schema||'.PAR_1_2_1_0_2_1_CAT_TEN_PO l,';
sqlstringa:=sqlstringa||' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,';
sqlstringa:=sqlstringa||' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa:=sqlstringa||' where';
sqlstringa:=sqlstringa||' c.CODICE_PARAMETRO=d.CODICE_PARAMETRO and';
sqlstringa:=sqlstringa||' c.NUMERO_PARAMETRO_MULTIPLO=''1.2.1.0.2.1'' and ';
sqlstringa:=sqlstringa||' d.CODIFICA_VALORE=l.PO_TRACK_1_2_1_0_2_1';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and l.CODICE_VERSIONE='||p_versione;
  END IF;
sqlstringa:=sqlstringa||' ) l_ten,';
sqlstringa:=sqlstringa||' (select SEDE_TECNICA, LISTAGG(valore||'' (nè binari: ''||n_binari||'')'','';'')  WITHIN GROUP (ORDER BY valore) tooltip';
sqlstringa:=sqlstringa||' from';
sqlstringa:=sqlstringa||' (select   SUBSTR(PO_TRACK_1_2_1_0_0_2,1,6) SEDE_TECNICA, d.VALORE,count( distinct PO_TRACK_1_2_1_0_0_2) n_binari';
sqlstringa:=sqlstringa||' from RINF_PUBBLICATI_EVO.PAR_1_2_1_0_2_1_CAT_TEN_PO l,';
sqlstringa:=sqlstringa||' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,';
sqlstringa:=sqlstringa||' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa:=sqlstringa||' where';
sqlstringa:=sqlstringa||' c.CODICE_PARAMETRO=d.CODICE_PARAMETRO and';
sqlstringa:=sqlstringa||' c.NUMERO_PARAMETRO_MULTIPLO=''1.2.1.0.2.1'' and ';
sqlstringa:=sqlstringa||' d.CODIFICA_VALORE=l.PO_TRACK_1_2_1_0_2_1';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and l.CODICE_VERSIONE='||p_versione;
  END IF;
sqlstringa:=sqlstringa||' GROUP BY SUBSTR(PO_TRACK_1_2_1_0_0_2,1,6) , d.VALORE)';
sqlstringa:=sqlstringa||' GROUP BY SEDE_TECNICA) l_tooltip,';
sqlstringa:=sqlstringa||' '||s_schema||'.PUNTI_OPERATIVI s';
sqlstringa:=sqlstringa||' where';
sqlstringa:=sqlstringa||' s.SEDE_TECNICA=l_ten.SEDE_TECNICA (+)';
sqlstringa:=sqlstringa||' and s.SEDE_TECNICA=l_tooltip.SEDE_TECNICA (+)';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and s.CODICE_VERSIONE='||p_versione;
  END IF;
IF p_contesto<>9 THEN
sqlstringa:=sqlstringa||' and s.sede_tecnica  IN (';
sqlstringa:=sqlstringa||' Select DISTINCT SEDE_TECNICA  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS where codice_contesto='||p_contesto;
  sqlstringa:=sqlstringa||' and CODICE='''||p_filtro ||'''';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
  sqlstringa:=sqlstringa||')';
END IF;
sqlstringa:=sqlstringa||' GROUP BY s.sede_tecnica,l_tooltip.tooltip';

 WHEN p_tematismo=5 --Marciapiedi
 THEN
sqlstringa:=' (SELECT s.SEDE_TECNICA, ';
sqlstringa:=sqlstringa||' CASE WHEN INSTR(LISTAGG(VALORE,'';'') WITHIN GROUP(ORDER BY VALORE),''SI'')>0 THEN ''SI'' ELSE ''NO'' END VALORE, ';
sqlstringa:=sqlstringa||' l_tooltip.TOOLTIP, ';
sqlstringa:=sqlstringa||' NULL etichetta ';
sqlstringa:=sqlstringa||' FROM  ';
sqlstringa:=sqlstringa||' (SELECT p.SEDE_TECNICA, ';
sqlstringa:=sqlstringa||' CASE WHEN (PO_TR_PLATFORM_1_2_1_0_6_5_B1=550 OR PO_TR_PLATFORM_1_2_1_0_6_5_B2=550 OR PO_TR_PLATFORM_1_2_1_0_6_5_B3=550 OR PO_TR_PLATFORM_1_2_1_0_6_5_B4=550) ';
sqlstringa:=sqlstringa||' THEN ''SI'' ';
sqlstringa:=sqlstringa||' ELSE ''NO''  ';
sqlstringa:=sqlstringa||' END VALORE ';
sqlstringa:=sqlstringa||' FROM '||s_schema||'.MARCIAPIEDI_BINARI_PO m, ';
sqlstringa:=sqlstringa||' '||s_schema||'.PUNTI_OPERATIVI p ';
sqlstringa:=sqlstringa||' WHERE  ';
sqlstringa:=sqlstringa||' SUBSTR(PO_TR_PLATFORM_1_2_1_0_6_2,1,6)=p.SEDE_TECNICA  ';
IF p_versione IS NOT NULL THEN
sqlstringa:=sqlstringa||' and m.CODICE_VERSIONE=p.CODICE_VERSIONE and ';
  sqlstringa:=sqlstringa||' m.CODICE_VERSIONE='||p_versione;
END IF;

sqlstringa:=sqlstringa||' UNION ';
sqlstringa:=sqlstringa||' SELECT p.SEDE_TECNICA, ';
sqlstringa:=sqlstringa||' CASE WHEN (PO_TR_PLATFORM_1_2_1_0_6_5_B1=550 OR PO_TR_PLATFORM_1_2_1_0_6_5_B2=550 OR PO_TR_PLATFORM_1_2_1_0_6_5_B3=550 OR PO_TR_PLATFORM_1_2_1_0_6_5_B4=550) ';
sqlstringa:=sqlstringa||' THEN ''SI'' ';
sqlstringa:=sqlstringa||' ELSE ''NO''  ';
sqlstringa:=sqlstringa||' END VALORE ';
sqlstringa:=sqlstringa||' FROM '||s_schema||'.MARCIAPIEDI_BINARI_PO m, ';
sqlstringa:=sqlstringa||' '||s_schema||'.PUNTI_OPERATIVI p ';
sqlstringa:=sqlstringa||' WHERE  ';
sqlstringa:=sqlstringa||' SUBSTR(PO_TR_PLATFORM_1_2_1_0_6_2,1,6)=p.LOCALITA_CONTENITORE  ';
IF p_versione IS NOT NULL THEN
sqlstringa:=sqlstringa||' and m.CODICE_VERSIONE=p.CODICE_VERSIONE and ';
  sqlstringa:=sqlstringa||' m.CODICE_VERSIONE='||p_versione;
  END IF;
sqlstringa:=sqlstringa||' ) MARC, ';
sqlstringa:=sqlstringa||' (SELECT SEDE_TECNICA, LISTAGG(PO_TR_PLATFORM_1_2_1_0_6_2,'';'') WITHIN GROUP (ORDER BY PO_TR_PLATFORM_1_2_1_0_6_2) tooltip ';
sqlstringa:=sqlstringa||' FROM ';
sqlstringa:=sqlstringa||' (SELECT p.SEDE_TECNICA,PO_TR_PLATFORM_1_2_1_0_6_2 ';
sqlstringa:=sqlstringa||' FROM '||s_schema||'.MARCIAPIEDI_BINARI_PO m, ';
sqlstringa:=sqlstringa||' '||s_schema||'.PUNTI_OPERATIVI p ';
sqlstringa:=sqlstringa||' WHERE  ';
sqlstringa:=sqlstringa||' SUBSTR(PO_TR_PLATFORM_1_2_1_0_6_2,1,6)=p.SEDE_TECNICA and ';
sqlstringa:=sqlstringa||' (PO_TR_PLATFORM_1_2_1_0_6_5_B1=550 OR PO_TR_PLATFORM_1_2_1_0_6_5_B2=550 OR PO_TR_PLATFORM_1_2_1_0_6_5_B3=550 OR PO_TR_PLATFORM_1_2_1_0_6_5_B4=550)  ';
IF p_versione IS NOT NULL THEN
sqlstringa:=sqlstringa||' and m.CODICE_VERSIONE=p.CODICE_VERSIONE and ';
  sqlstringa:=sqlstringa||' m.CODICE_VERSIONE='||p_versione;
  END IF;
sqlstringa:=sqlstringa||' UNION ';
sqlstringa:=sqlstringa||' SELECT p.SEDE_TECNICA,PO_TR_PLATFORM_1_2_1_0_6_2 ';
sqlstringa:=sqlstringa||' FROM '||s_schema||'.MARCIAPIEDI_BINARI_PO m, ';
sqlstringa:=sqlstringa||' '||s_schema||'.PUNTI_OPERATIVI p ';
sqlstringa:=sqlstringa||' WHERE  ';
sqlstringa:=sqlstringa||' SUBSTR(PO_TR_PLATFORM_1_2_1_0_6_2,1,6)=p.LOCALITA_CONTENITORE and ';
sqlstringa:=sqlstringa||' (PO_TR_PLATFORM_1_2_1_0_6_5_B1=550 OR PO_TR_PLATFORM_1_2_1_0_6_5_B2=550 OR PO_TR_PLATFORM_1_2_1_0_6_5_B3=550 OR PO_TR_PLATFORM_1_2_1_0_6_5_B4=550)  ';
IF p_versione IS NOT NULL THEN
sqlstringa:=sqlstringa||' and m.CODICE_VERSIONE=p.CODICE_VERSIONE and ';
  sqlstringa:=sqlstringa||' m.CODICE_VERSIONE='||p_versione;
  END IF;
sqlstringa:=sqlstringa||' ) ';
sqlstringa:=sqlstringa||' GROUP BY SEDE_TECNICA) l_tooltip, ';
sqlstringa:=sqlstringa||' '||s_schema||'.PUNTI_OPERATIVI s ';
sqlstringa:=sqlstringa||' where ';
sqlstringa:=sqlstringa||' s.sede_TECNICA=MARC.SEDE_TECNICA (+) and ';
sqlstringa:=sqlstringa||' s.sede_TECNICA=l_tooltip.SEDE_TECNICA (+) ';
IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and s.CODICE_VERSIONE='||p_versione;
  END IF;
IF p_contesto<>9 THEN
sqlstringa:=sqlstringa||' and s.sede_tecnica  IN (';
sqlstringa:=sqlstringa||' Select DISTINCT SEDE_TECNICA  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS where codice_contesto='||p_contesto;
  sqlstringa:=sqlstringa||' and CODICE='''||p_filtro ||'''';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
  sqlstringa:=sqlstringa||')';
END IF;
sqlstringa:=sqlstringa||' GROUP BY s.SEDE_TECNICA,l_tooltip.TOOLTIP ';
 WHEN p_tematismo=6 --Raccordi
 THEN
 sqlstringa:=' (SELECT s.SEDE_TECNICA, ';
sqlstringa:=sqlstringa||' DECODE(VALORE,NULL,''NO'',''SI'') VALORE, ';
sqlstringa:=sqlstringa||' DECODE(VALORE,NULL,NULL,''Nè binari di raccordo: ''||VALORE) tooltip, ';
sqlstringa:=sqlstringa||' NULL etichetta ';
sqlstringa:=sqlstringa||' FROM  ';
sqlstringa:=sqlstringa||' (SELECT p.SEDE_TECNICA, ';
sqlstringa:=sqlstringa||' COUNT(*) VALORE ';
sqlstringa:=sqlstringa||' FROM '||s_schema||'.BINARI_RACCORDO_PO m, ';
sqlstringa:=sqlstringa||' '||s_schema||'.PUNTI_OPERATIVI p ';
sqlstringa:=sqlstringa||' WHERE  ';
sqlstringa:=sqlstringa||' p.SEDE_TECNICA=m.SEDE_TECNICA  ';
IF p_versione IS NOT NULL THEN
    sqlstringa:=sqlstringa||' and m.CODICE_VERSIONE=p.CODICE_VERSIONE  ';
  sqlstringa:=sqlstringa||' and m.CODICE_VERSIONE='||p_versione;
  END IF;

sqlstringa:=sqlstringa||' GROUP BY p.SEDE_TECNICA) RACC, ';
sqlstringa:=sqlstringa||' '||s_schema||'.PUNTI_OPERATIVI s ';
sqlstringa:=sqlstringa||' where ';
sqlstringa:=sqlstringa||' s.sede_TECNICA=RACC.SEDE_TECNICA (+)  ';
IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and s.CODICE_VERSIONE='||p_versione;
  END IF;
  IF p_contesto<>9 THEN
sqlstringa:=sqlstringa||' and s.sede_tecnica  IN (';
sqlstringa:=sqlstringa||' Select DISTINCT SEDE_TECNICA  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS where codice_contesto='||p_contesto;
  sqlstringa:=sqlstringa||' and CODICE='''||p_filtro ||'''';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
  sqlstringa:=sqlstringa||')';
END IF;
WHEN p_tematismo=7 --Confini
 THEN
sqlstringa:=' (select sede_tecnica,  ';
sqlstringa:=sqlstringa||' DECODE(TIPO_LOCALITA_CONFINE,''NA'',''NA-Nazionale'',       ';
sqlstringa:=sqlstringa||' ''RE'',''RE-Regionale'',       ';
sqlstringa:=sqlstringa||' ''AF'',''AF-Affidata'',       ';
sqlstringa:=sqlstringa||' ''AL'',''AL-Altro'',       ';
sqlstringa:=sqlstringa||' ''NO'',''NO-Non di confine'') VALORE, ';
sqlstringa:=sqlstringa||' DECODE(TIPO_LOCALITA_CONFINE,''NA'',''NA-Nazionale'',       ';
sqlstringa:=sqlstringa||' ''RE'',''RE-Regionale'',       ';
sqlstringa:=sqlstringa||' ''AF'',''AF-Affidata'',       ';
sqlstringa:=sqlstringa||' ''AL'',''AL-Altro'',       ';
sqlstringa:=sqlstringa||' ''NO'',''NO-Non di confine'') tooltip, ';
sqlstringa:=sqlstringa||' null etichetta ';
sqlstringa:=sqlstringa||' from ';
sqlstringa:=sqlstringa||' '||s_schema||'.PUNTI_OPERATIVI s';
sqlstringa:=sqlstringa||' where  TIPO_LOCALITA_CONFINE<>''NO'' ';
IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and s.CODICE_VERSIONE='||p_versione;
END IF;
  IF p_contesto<>9 THEN

  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and s.sede_tecnica  IN (';
sqlstringa:=sqlstringa||' Select DISTINCT SEDE_TECNICA  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS where codice_contesto='||p_contesto;
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  ELSE
  sqlstringa:=sqlstringa||' and s.sede_tecnica  IN (';
sqlstringa:=sqlstringa||' Select DISTINCT SEDE_TECNICA  from '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS where codice_contesto='||p_contesto;
  END IF;
  sqlstringa:=sqlstringa||' and CODICE='''||p_filtro ||'''';
  sqlstringa:=sqlstringa||')';
END IF;

END CASE;
sqlstringa:=sqlstringa||') H ';

sqlstringa_2:='SELECT  H.SEDE_TECNICA,  ';
sqlstringa_2:=sqlstringa_2||' CASE WHEN INSTR(H.VALORE,'';'')>0 THEN ''Valori Sovrapposti'' ELSE H.VALORE END VALORE,';
sqlstringa_2:=sqlstringa_2||'H.SEDE_TECNICA||'' ''|| H.TOOLTIP tooltip, ';
IF n_zoom=1 THEN
sqlstringa_2:=sqlstringa_2||' '' '' etichetta, ';
ELSE
sqlstringa_2:=sqlstringa_2||' NVL(H.ETICHETTA, '' '') etichetta, ';
END IF;
sqlstringa_2:=sqlstringa_2||'  L_G.X      AS Xwgs, ';
sqlstringa_2:=sqlstringa_2||'  L_G.Y      AS Ywgs, ';
sqlstringa_2:=sqlstringa_2||'  D.COLORE COLORE ';
sqlstringa_2:=sqlstringa_2||'   FROM ';
sqlstringa_2:=sqlstringa_2||'RINF_GIS_EVO.LOCA_RETE T,  ';
sqlstringa_2:=sqlstringa_2||'TABLE(SDO_UTIL.GETVERTICES(T.GEOMETRY)) L_G, ';
sqlstringa_2:=sqlstringa_2||'RINF_ANAGRAFICHE_EVO.DOMINIO_TEMATISMO D, ';
sqlstringa_2:=sqlstringa_2||sqlstringa;
sqlstringa_2:=sqlstringa_2||'WHERE ';
sqlstringa_2:=sqlstringa_2||'T.OR_ID=H.SEDE_TECNICA ';
sqlstringa_2:=sqlstringa_2||' AND T.VERSIONE_MDR='||n_versione_MDR;
sqlstringa_2:=sqlstringa_2||' AND DECODE(INSTR(H.VALORE,'';''),0,H.VALORE,''Valori Sovrapposti'')=D.VALORE ';

DBMS_OUTPUT.PUT_LINE(sqlstringa_2);
OPEN p_cursor FOR sqlstringa_2;
--
EXCEPTION
      WHEN OTHERS  THEN
   --      p_error := SQLCODE;
   Null;
END GetPOTematismo;
--
-- --------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------
--

PROCEDURE GetSOLTematismo ( p_tematismo NUMBER,p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2, p_i_versione NUMBER,xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER, p_cursor OUT empcur) IS
sqlstringa VARCHAR2(32000);
sqlstringa_2 VARCHAR2(32000);
p_versione NUMBER;
s_schema VARCHAR2(200);
n_zoom NUMBER;
n_versione_MDR NUMBER;

BEGIN
select PKG_RINF_GIS_V2.FNC_GET_ZOOM(xtl , ytl , xbr , ybr ) into n_zoom from dual;

IF p_area is not null THEN
    s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
END IF;

 p_versione:=p_i_versione;
  IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=PKG_RINF_DATA_V082.GetLastVersion(p_area);
 END IF;

--15/11/2017 Per la Storicizzazione del MDR GIS è necessario individuare la versione del MDR GIS corrispondente all'ultimo RI Pubblicato/Inviato
   n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(p_area,p_versione);


 CASE WHEN p_tematismo=1 --Certificazioni
 THEN


sqlstringa:=' (Select b.sede_tecnica,DECODE(dic.sede_tecnica, NULL,''NO'',''SI'') valore, DECODE(dic.sede_tecnica, NULL,null,tooltip) tooltip, null etichetta ';
sqlstringa:=sqlstringa||'  from '||s_schema||'.SEZIONI_LINEA b,';
sqlstringa:=sqlstringa||'    (SELECT SEDE_TECNICA, ';
sqlstringa:=sqlstringa||'          LISTAGG (TIPO_DICHIARAZIONE || '': '' || dichiarazione, '';'')';
sqlstringa:=sqlstringa||'             WITHIN GROUP (ORDER BY dichiarazione)                      ';
sqlstringa:=sqlstringa||'             AS tooltip                                                 ';
sqlstringa:=sqlstringa||'     FROM (SELECT substr(SOL_TRACK_1_1_1_0_0_1,1,6) sede_tecnica,       ';
sqlstringa:=sqlstringa||'                  ''INF - '' || TIPO_DICHIARAZIONE TIPO_DICHIARAZIONE,  ';
sqlstringa:=sqlstringa||'                  SOL_TRACK_1_1_1_1_1_1O2 dichiarazione                 ';
sqlstringa:=sqlstringa||'             FROM '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF';
sqlstringa:=sqlstringa||'            WHERE SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y''                ';
IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
sqlstringa:=sqlstringa||'           UNION                                                    ';
sqlstringa:=sqlstringa||'           SELECT substr(SOL_TRACK_1_1_1_0_0_1,1,6) sede_tecnica, ';
sqlstringa:=sqlstringa||'                  ''ENE - '' || TIPO_DICHIARAZIONE,               ';
sqlstringa:=sqlstringa||'                  SOL_TRACK_1_1_1_2_1_1O2                         ';
sqlstringa:=sqlstringa||'             FROM '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE    ';
sqlstringa:=sqlstringa||'            WHERE SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y'' ';
IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
sqlstringa:=sqlstringa||'           UNION   ';
sqlstringa:=sqlstringa||'           SELECT substr(SOL_TRACK_1_1_1_0_0_1,1,6) sede_tecnica,  ';
sqlstringa:=sqlstringa||'                  ''CCS - '' || TIPO_DICHIARAZIONE,';
sqlstringa:=sqlstringa||'                  SOL_TRACK_1_1_1_3_1_1  ';
sqlstringa:=sqlstringa||'             FROM '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS ';
sqlstringa:=sqlstringa||'            WHERE SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' ';
IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
sqlstringa:=sqlstringa||') GROUP BY SEDE_TECNICA) DIC                         ';
sqlstringa:=sqlstringa||' where                                              ';
sqlstringa:=sqlstringa||' b.sede_tecnica=dic.sede_tecnica (+)                ';
IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and b.CODICE_VERSIONE='||p_versione;
  END IF;
IF p_contesto<>9 THEN
sqlstringa:=sqlstringa||' and b.sede_tecnica  IN (';
sqlstringa:=sqlstringa||' Select DISTINCT SEDE_TECNICA  from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS  where codice_contesto='||p_contesto;
  sqlstringa:=sqlstringa||' and CODICE='''||p_filtro ||'''';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
  sqlstringa:=sqlstringa||')';
END IF;


WHEN p_tematismo=2 --Linee TEN-T
 THEN


sqlstringa:=' (Select s.SEDE_TECNICA, ';
sqlstringa:=sqlstringa || '  NVL(LISTAGG(l_ten.ten_t,'';'')  WITHIN GROUP (ORDER BY l_ten.ten_t),''Non Applicabile'') valore, ';
sqlstringa:=sqlstringa || '  NVL(l_tooltip.tooltip,''Non Applicabile'') tooltip, ';
sqlstringa:=sqlstringa || '  LISTAGG(l_ten.ten_t,'';'')  WITHIN GROUP (ORDER BY l_ten.ten_t) etichetta ';
sqlstringa:=sqlstringa || '  from ';
sqlstringa:=sqlstringa || '  (select DISTINCT SUBSTR(SOL_TRACK_1_1_1_0_0_1,1,6) SEDE_TECNICA, DECODE(d.VALORE,''Off TEN'',''OFF TEN'',''TEN-T'') ten_t   ';
sqlstringa:=sqlstringa || '  from '||s_schema||'.PAR_1_1_1_1_2_1_CAT_TEN_SOL l, ';
sqlstringa:=sqlstringa || '  RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa:=sqlstringa || '  RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
sqlstringa:=sqlstringa || '  where ';
sqlstringa:=sqlstringa || '  c.CODICE_PARAMETRO=d.CODICE_PARAMETRO and ';
sqlstringa:=sqlstringa || '  c.NUMERO_PARAMETRO_MULTIPLO=''1.1.1.1.2.1'' and  ';
sqlstringa:=sqlstringa || '  d.CODIFICA_VALORE=l.SOL_TRACK_1_1_1_1_2_1 ';
IF p_versione IS NOT NULL THEN
sqlstringa:=sqlstringa || '  and l.codice_versione='||p_versione;
END IF;
sqlstringa:=sqlstringa || '  ) l_ten, ';
sqlstringa:=sqlstringa || '(select  SUBSTR(SOL_TRACK_1_1_1_0_0_1,1,6) SEDE_TECNICA, LISTAGG(SUBSTR(SOL_TRACK_1_1_1_0_0_1,11)||'': ''||d.VALORE,'';'')  WITHIN GROUP (ORDER BY SUBSTR(SOL_TRACK_1_1_1_0_0_1,11)) tooltip ';
sqlstringa:=sqlstringa || ' from '||s_schema||'.PAR_1_1_1_1_2_1_CAT_TEN_SOL l, ';
sqlstringa:=sqlstringa || ' RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,     ';
sqlstringa:=sqlstringa || ' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c';
sqlstringa:=sqlstringa || ' where ';
sqlstringa:=sqlstringa || ' c.CODICE_PARAMETRO=d.CODICE_PARAMETRO and ';
sqlstringa:=sqlstringa || ' c.NUMERO_PARAMETRO_MULTIPLO=''1.1.1.1.2.1'' and ';
sqlstringa:=sqlstringa || ' d.CODIFICA_VALORE=l.SOL_TRACK_1_1_1_1_2_1 ';
IF p_versione IS NOT NULL THEN
sqlstringa:=sqlstringa || '  and l.codice_versione='||p_versione;
END IF;
sqlstringa:=sqlstringa || ' GROUP BY SUBSTR(SOL_TRACK_1_1_1_0_0_1,1,6)) l_tooltip,';
sqlstringa:=sqlstringa || s_schema||'.SEZIONI_LINEA s ';
sqlstringa:=sqlstringa || '  where ';
sqlstringa:=sqlstringa || '  s.SEDE_TECNICA=l_ten.SEDE_TECNICA (+) ';
sqlstringa:=sqlstringa || 'and s.SEDE_TECNICA=l_tooltip.SEDE_TECNICA (+) ';
IF p_versione IS NOT NULL THEN
sqlstringa:=sqlstringa || '  and s.codice_versione='||p_versione;
END IF;

IF p_contesto<>9 THEN
sqlstringa:=sqlstringa||' and s.sede_tecnica  IN (';
sqlstringa:=sqlstringa||' Select DISTINCT SEDE_TECNICA  from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS  where codice_contesto='||p_contesto;
  sqlstringa:=sqlstringa||' and CODICE='''||p_filtro ||'''';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
  sqlstringa:=sqlstringa||')';
END IF;
sqlstringa:=sqlstringa || '  GROUP BY s.sede_tecnica,l_tooltip.tooltip ';


 WHEN p_tematismo=3 --ERTMS
 THEN


sqlstringa:='(SELECT s.sede_tecnica, ';
sqlstringa:=sqlstringa || '         LISTAGG (rtms.valore, '';'') ';
sqlstringa:=sqlstringa || '            WITHIN GROUP (ORDER BY rtms.valore) ';
sqlstringa:=sqlstringa || '            "VALORE", ';
sqlstringa:=sqlstringa || '         t_tooltip.tooltip, ';
sqlstringa:=sqlstringa || '         NULL etichetta ';
sqlstringa:=sqlstringa || '         FROM ';
sqlstringa:=sqlstringa || '         (  SELECT SEDE_TECNICA, ';
sqlstringa:=sqlstringa || '                   LISTAGG ( ';
sqlstringa:=sqlstringa || '                      DECODE ( ';
sqlstringa:=sqlstringa || '                         SOL_TRACK_1_1_1_3_2_1_AP, ';
sqlstringa:=sqlstringa || '                         ''Y'',    SUBSTR (SOL_TRACK_1_1_1_0_0_1, 11) ';
sqlstringa:=sqlstringa || '                              || '': '' ';
sqlstringa:=sqlstringa || '                              || SOL_TRACK_1_1_1_3_2_1, ';
sqlstringa:=sqlstringa || '                         NULL), ';
sqlstringa:=sqlstringa || '                      '';'') ';
sqlstringa:=sqlstringa || '                   WITHIN GROUP (ORDER BY SUBSTR (SOL_TRACK_1_1_1_0_0_1, 11)) ';
sqlstringa:=sqlstringa || '                      tooltip ';
sqlstringa:=sqlstringa || '              FROM '||s_schema||'.BINARI_CORSA_SOL ';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' where CODICE_VERSIONE='||p_versione;
  END IF;
sqlstringa:=sqlstringa || '          GROUP BY SEDE_TECNICA) t_tooltip, ';
sqlstringa:=sqlstringa || '         (SELECT DISTINCT ';
sqlstringa:=sqlstringa || '                 SEDE_TECNICA, ';
sqlstringa:=sqlstringa || '                 CASE ';
sqlstringa:=sqlstringa || '                    WHEN (SOL_TRACK_1_1_1_3_2_1 = ''N'') THEN ''NO'' ';
sqlstringa:=sqlstringa || '                    WHEN SOL_TRACK_1_1_1_3_2_1_AP = ''N'' THEN ''Non Applicabile'' ';
sqlstringa:=sqlstringa || '                    WHEN SOL_TRACK_1_1_1_3_2_1_AP = ''NYA'' THEN ''NYA'' ';
sqlstringa:=sqlstringa || '                    ELSE ''SI'' ';
sqlstringa:=sqlstringa || '                 END ';
sqlstringa:=sqlstringa || '                    valore ';
sqlstringa:=sqlstringa || '            FROM '||s_schema||'.BINARI_CORSA_SOL ';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' where CODICE_VERSIONE='||p_versione;
  END IF;
sqlstringa:=sqlstringa || '           ) rtms, ';
sqlstringa:=sqlstringa || '         '||s_schema||'.sezioni_linea s ';
sqlstringa:=sqlstringa || '   WHERE     t_tooltip.SEDE_TECNICA = S.SEDE_TECNICA ';
sqlstringa:=sqlstringa || '         AND rtms.SEDE_TECNICA = S.SEDE_TECNICA ';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
  IF p_contesto<>9 THEN
sqlstringa:=sqlstringa||' and s.sede_tecnica  IN (';
sqlstringa:=sqlstringa||' Select DISTINCT SEDE_TECNICA  from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS  where codice_contesto='||p_contesto;
  sqlstringa:=sqlstringa||' and CODICE='''||p_filtro ||'''';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
  sqlstringa:=sqlstringa||')';
END IF;
sqlstringa:=sqlstringa || ' GROUP BY s.sede_tecnica, t_tooltip.tooltip ';


 WHEN p_tematismo=4 --Energia
 THEN

 sqlstringa:=' (Select s.SEDE_TECNICA, ';
sqlstringa:=sqlstringa||' LISTAGG(elettr.valore,'';'') WITHIN GROUP  (ORDER BY elettr.valore) valore, ';
sqlstringa:=sqlstringa||' l_tooltip.tooltip, ';
sqlstringa:=sqlstringa||' null etichetta ';
sqlstringa:=sqlstringa||' FROM ';
sqlstringa:=sqlstringa||' (Select Distinct SEDE_TECNICA,  ';
sqlstringa:=sqlstringa||' CASE WHEN SOL_TRACK_1_1_1_2_2_1_1=40 THEN ''Non Elettrificata'' ';
sqlstringa:=sqlstringa||' WHEN SOL_TRACK_1_1_1_2_2_1_1_AP=''N''  AND SOL_TRACK_1_1_1_2_2_1_1 <> 40 THEN ''Non Applicabile'' ';
sqlstringa:=sqlstringa||' WHEN SOL_TRACK_1_1_1_2_2_1_2_AP=''NYA''  AND SOL_TRACK_1_1_1_2_2_1_1 <> 40 THEN ''NYA'' ';
sqlstringa:=sqlstringa||' ELSE h.valore ';
sqlstringa:=sqlstringa||' END valore ';
sqlstringa:=sqlstringa||' from ';
sqlstringa:=sqlstringa||'  '||s_schema||'.binari_corsa_sol b, ';
sqlstringa:=sqlstringa||' (SELECT d.CODIFICA_VALORE,d.valore FROM RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa:=sqlstringa||' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
sqlstringa:=sqlstringa||' where ';
sqlstringa:=sqlstringa||' c.CODICE_PARAMETRO=d.CODICE_PARAMETRO and ';
sqlstringa:=sqlstringa||' c.NUMERO_PARAMETRO_MULTIPLO=''1.1.1.2.2.1.2'' ) h  ';
sqlstringa:=sqlstringa||' where h.CODIFICA_VALORE(+)=b.SOL_TRACK_1_1_1_2_2_1_2 ';
  IF p_versione IS NOT NULL THEN
sqlstringa:=sqlstringa||' and codice_versione='||p_versione;
END IF;
sqlstringa:=sqlstringa||' ) elettr, ';
sqlstringa:=sqlstringa||' (Select  SEDE_TECNICA, LISTAGG(  ';
sqlstringa:=sqlstringa||' CASE WHEN SOL_TRACK_1_1_1_2_2_1_1=40 THEN substr(SOL_TRACK_1_1_1_0_0_1,11)||'': ''||''Non Elettrificata'' ';
sqlstringa:=sqlstringa||' WHEN SOL_TRACK_1_1_1_2_2_1_1_AP=''N''  AND SOL_TRACK_1_1_1_2_2_1_1 <> 40 THEN ''Non Applicabile'' ';
sqlstringa:=sqlstringa||' WHEN SOL_TRACK_1_1_1_2_2_1_2_AP=''NYA''  AND SOL_TRACK_1_1_1_2_2_1_1 <> 40 THEN ''NYA'' ';
sqlstringa:=sqlstringa||' ELSE substr(SOL_TRACK_1_1_1_0_0_1,11)||'': ''||h.valore ';
sqlstringa:=sqlstringa||' END ,'';'') WITHIN GROUP (ORDER BY SOL_TRACK_1_1_1_0_0_1) tooltip ';
sqlstringa:=sqlstringa||' from ';
sqlstringa:=sqlstringa||'  '||s_schema||'.binari_corsa_sol b, ';
sqlstringa:=sqlstringa||' (SELECT d.CODIFICA_VALORE,d.valore FROM RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d, ';
sqlstringa:=sqlstringa||' RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c ';
sqlstringa:=sqlstringa||' where ';
sqlstringa:=sqlstringa||' c.CODICE_PARAMETRO=d.CODICE_PARAMETRO and ';
sqlstringa:=sqlstringa||' c.NUMERO_PARAMETRO_MULTIPLO=''1.1.1.2.2.1.2'' ) h  ';
sqlstringa:=sqlstringa||' where h.CODIFICA_VALORE(+)=b.SOL_TRACK_1_1_1_2_2_1_2 ';
  IF p_versione IS NOT NULL THEN
sqlstringa:=sqlstringa||' and codice_versione='||p_versione;
END IF;
sqlstringa:=sqlstringa||' GROUP BY SEDE_TECNICA) l_tooltip, ';
sqlstringa:=sqlstringa||'  '||s_schema||'.SEZIONI_LINEA s ';
sqlstringa:=sqlstringa||' where ';
sqlstringa:=sqlstringa||' s.SEDE_TECNICA=elettr.SEDE_TECNICA ';
sqlstringa:=sqlstringa||' and s.SEDE_TECNICA=l_tooltip.SEDE_TECNICA ';
  IF p_versione IS NOT NULL THEN
sqlstringa:=sqlstringa||' and s.codice_versione='||p_versione;
END IF;
IF p_contesto<>9 THEN
sqlstringa:=sqlstringa||' and s.sede_tecnica  IN (';
sqlstringa:=sqlstringa||' Select DISTINCT SEDE_TECNICA  from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS  where codice_contesto='||p_contesto;
  sqlstringa:=sqlstringa||' and CODICE='''||p_filtro ||'''';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
  sqlstringa:=sqlstringa||')';
END IF;
sqlstringa:=sqlstringa||' GROUP BY s.SEDE_TECNICA,l_tooltip.tooltip ';

--Tematismi 5, 6, 7 non sono di SOL

 WHEN p_tematismo=8 --Alta Velocità
 THEN

sqlstringa:=' (SELECT SEDE_TECNICA, ';
sqlstringa:=sqlstringa||' DECODE(SUBSTR(SIGLA_LINEA_COMMERCIALE,1,2),''AV'',''SI'',''NO'') valore, ';
sqlstringa:=sqlstringa||' SIGLA_LINEA_COMMERCIALE "TOOLTIP", ';
sqlstringa:=sqlstringa||' null etichetta ';
sqlstringa:=sqlstringa||' FROM '||s_schema||'.LINEA_COMM_SOL LC, ';
sqlstringa:=sqlstringa||' RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE AN ';
sqlstringa:=sqlstringa||' WHERE AN.CODICE_GIURISDIZIONE=LC.CODICE_GIURISDIZIONE ';
IF p_contesto<>9 THEN
sqlstringa:=sqlstringa||' and sede_tecnica  IN (';
sqlstringa:=sqlstringa||' Select DISTINCT SEDE_TECNICA  from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS  where codice_contesto='||p_contesto;
  sqlstringa:=sqlstringa||' and CODICE='''||p_filtro ||'''';
  IF p_versione IS NOT NULL THEN
  sqlstringa:=sqlstringa||' and CODICE_VERSIONE='||p_versione;
  END IF;
  sqlstringa:=sqlstringa||')';
END IF;
  IF p_versione IS NOT NULL THEN
sqlstringa:=sqlstringa||' and CODICE_VERSIONE ='||p_versione;
END IF;



END CASE;
sqlstringa:=sqlstringa||') H ';


sqlstringa_2:='SELECT  H.SEDE_TECNICA,  ';
sqlstringa_2:=sqlstringa_2||' CASE WHEN INSTR(H.VALORE,'';'')>0 THEN ''Valori Sovrapposti'' ELSE H.VALORE END VALORE, ';
sqlstringa_2:=sqlstringa_2||' H.SEDE_TECNICA||'' ''||H.TOOLTIP tooltip, ';
IF n_zoom=1 THEN
sqlstringa_2:=sqlstringa_2||' '' '' etichetta, '; --A livello di zoom basso le etichette non vanno mostrate
sqlstringa_2:=sqlstringa_2||' ''[[''||LI_G.X||'',''|| LI_G.Y ||''],[''|| LF_G.X ||'',''|| LF_G.Y||'']]'' COORD_PUNTI, ';
ELSE
sqlstringa_2:=sqlstringa_2||' NVL(H.ETICHETTA, '' '') etichetta, ';
sqlstringa_2:=sqlstringa_2||'PKG_RINF_GIS_V2.FNC_GET_VERTEX(SDO_UTIL.SIMPLIFY(to_2d(t.GEOMETRY),1.5)) COORD_PUNTI, ';
END IF;
sqlstringa_2:=sqlstringa_2||' D.COLORE COLORE ';
sqlstringa_2:=sqlstringa_2||'   FROM ';
sqlstringa_2:=sqlstringa_2||'RINF_GIS_EVO.TRAT_RETE T,  ';
sqlstringa_2:=sqlstringa_2||'RINF_GIS_EVO.LOCA_RETE LI_W, ';
sqlstringa_2:=sqlstringa_2||'RINF_GIS_EVO.LOCA_RETE LF_W,      ';
sqlstringa_2:=sqlstringa_2||'TABLE(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_START_PT(t.GEOMETRY))) LI_G, ';
sqlstringa_2:=sqlstringa_2||'TABLE(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_END_PT(t.GEOMETRY))) LF_G, ';
sqlstringa_2:=sqlstringa_2||'RINF_ANAGRAFICHE_EVO.DOMINIO_TEMATISMO D, ';
sqlstringa_2:=sqlstringa_2||sqlstringa;
sqlstringa_2:=sqlstringa_2||'WHERE ';
sqlstringa_2:=sqlstringa_2||'T.TR_ORIG = LI_W.OR_ID and ';
sqlstringa_2:=sqlstringa_2||'T.TR_DEST = LF_W.OR_ID and  ';
sqlstringa_2:=sqlstringa_2||'T.VERSIONE_MDR='||n_versione_MDR;
sqlstringa_2:=sqlstringa_2||' and LI_W.VERSIONE_MDR='||n_versione_MDR;
sqlstringa_2:=sqlstringa_2||' and LF_W.VERSIONE_MDR='||n_versione_MDR;
sqlstringa_2:=sqlstringa_2||' and T.OR_ID=H.SEDE_TECNICA ';
sqlstringa_2:=sqlstringa_2||' and DECODE(INSTR(H.VALORE,'';''),0,H.VALORE,''Valori Sovrapposti'')=D.VALORE (+)';
sqlstringa_2:=sqlstringa_2||' and SDO_ANYINTERACT(T.GEOMETRY,SDO_GEOMETRY(2003, 4326, NULL, SDO_ELEM_INFO_ARRAY(1, 1003, 3), SDO_ORDINATE_ARRAY('||REPLACE(TO_CHAR(xtl),',','.')||', '||REPLACE(TO_CHAR(ytl),',','.')||', '|| REPLACE(TO_CHAR(xbr),',','.')||', '|| REPLACE(TO_CHAR(ybr),',','.')||')))=''TRUE''';

DBMS_OUTPUT.PUT_LINE(sqlstringa_2);
OPEN p_cursor FOR sqlstringa_2;
EXCEPTION
      WHEN OTHERS  THEN
   --      p_error := SQLCODE;
   Null;
END GetSOLTematismo;
--
-- --------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------
--

 Procedure GetAllTipologie( p_cursor Out empcur) Is
    sqlstringa VARCHAR2(500);
 Begin

    sqlstringa:='Select CODICE_ETICHETTA, 1 CODICE_CONTESTO, DESCRIZIONE||'' - ''|| ''PO'' DESCRIZIONE, FLAG_ETICHETTA, FLAG_TOOLTIP ';
    sqlstringa:=sqlstringa||' From Rinf_Anagrafiche_Evo.ANAG_ETICHETTE ';
    sqlstringa:=sqlstringa||' Where ';
    sqlstringa:=sqlstringa||' FLAG_OP = 1 ';
    sqlstringa:=sqlstringa||' Union ';
    sqlstringa:=sqlstringa||' Select CODICE_ETICHETTA, 2 CODICE_CONTESTO, DESCRIZIONE||'' - ''|| ''SOL'' DESCRIZIONE, FLAG_ETICHETTA, FLAG_TOOLTIP ';
    sqlstringa:=sqlstringa||' From Rinf_Anagrafiche_Evo.ANAG_ETICHETTE ';
    sqlstringa:=sqlstringa||' Where ';
    sqlstringa:=sqlstringa||' Flag_Sol = 1';
    sqlstringa:=sqlstringa||' Order By 1,2 ';
--
    Open p_cursor For sqlstringa;
--
 End GetAllTipologie;
--
-- -----------------------------------------------------------------------------
-- PROCEDURE GetPOEtichetta
-- -----------------------------------------------------------------------------
--
 Procedure GetPOEtichetta ( p_tipologia NUMBER, p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2, p_i_versione NUMBER, xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER, p_cursor Out EMPCUR) Is

    sqlstringa     VARCHAR2(32000);
    p_versione     NUMBER;
    s_schema       VARCHAR2(200);
    sqlstringa_2   VARCHAR2(32000);
    n_zoom         NUMBER;
    n_versione_MDR NUMBER;
--
 Begin
--
  Select PKG_RINF_GIS_V2.FNC_GET_ZOOM(xtl , ytl , xbr , ybr ) Into n_zoom From dual;
--  dbms_output.put_line ('zoom: '||n_zoom);

  If n_zoom = 1 Then --14/02/2017 Se il livello di zoom è troppo basso non vengono mostrate le etichette ed i tooltip, il jason restituito è vuoto
        Open p_cursor For 'Select Null SEDE_TECNICA, Null tooltip, Null etichetta, Null Xwgs, Null Ywgs from dual';
--           dbms_output.Put_line('Select null SEDE_TECNICA, null tooltip, null etichetta, null Xwgs, null Ywgs from dual');
  Else
       If p_area Is Not Null Then
           s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--		   dbms_output.put_line ('schema: '||s_schema);
       End If;

       p_versione := p_i_versione;
       If (p_area = 2 Or p_area = 4) And p_versione Is Null Then
           p_versione := PKG_RINF_DATA_V082.GetLastVersion(p_area);
       End If;
--
 --15/11/2017 Per la Storicizzazione del MDR GIS è necessario individuare la versione del MDR GIS corrispondente all'ultimo RI Pubblicato/Inviato
       n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(p_area, p_versione);
--
--      dbms_output.put_line ('versione_MDR : '||n_versione_MDR );
--
-- 1 - Gallerie
       Case  
	     When p_tipologia = 1 Then
            sqlstringa := '(Select b.SEDE_TECNICA, ';
            sqlstringa := sqlstringa||'Listagg(g.PO_TR_TUNNEL_1_2_1_0_5_2||'' - ''|| PO_TR_TUNNEL_1_2_1_0_5_2_D,'';'') Within Group (Order By g.PO_TR_TUNNEL_1_2_1_0_5_2) tooltip, ';
            sqlstringa := sqlstringa||'Null etichetta ';
            sqlstringa := sqlstringa||'From '||s_schema||'.GALLERIE_BINARI_PO g, ';
            sqlstringa := sqlstringa||s_schema||'.REL_GALLERIE_BINARI_PO r, ';
            sqlstringa := sqlstringa||s_schema||'.REL_PO_BINARI_CORSA b ';
            sqlstringa := sqlstringa||' Where ';
            sqlstringa := sqlstringa||'g.PO_TR_TUNNEL_1_2_1_0_5_2 = r.PO_TR_TUNNEL_1_2_1_0_5_2 And ';
            sqlstringa := sqlstringa||'r.PO_TRACK_1_2_1_0_0_2 = b.PO_TRACK_1_2_1_0_0_2 ';
--          
            If p_versione Is Not Null Then
                sqlstringa := sqlstringa||'And g.CODICE_VERSIONE = r.CODICE_VERSIONE ';
                sqlstringa := sqlstringa||'And r.CODICE_VERSIONE = b.CODICE_VERSIONE ';
                sqlstringa := sqlstringa||'And b.CODICE_VERSIONE = '||p_versione;
            End If;
--          
            If p_contesto <> 9 Then
                sqlstringa := sqlstringa||' And b.SEDE_TECNICA In (';
                sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA  From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
--                sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
---> aggiunto 13702/2022
             If p_filtro Is Not Null Then
                  sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
             End If;
--
                If p_versione Is Not Null Then
                  sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
                End If;
--
                sqlstringa := sqlstringa||')';
            End If;
--
            sqlstringa := sqlstringa||' Group By SEDE_TECNICA) h ';
--
-- 2 - Corridoi UE
         When p_tipologia = 2   Then --null;
            sqlstringa := ' (Select s.SEDE_TECNICA, Nvl(tooltip, ''No-RFC'') tooltip, ';
            sqlstringa := sqlstringa ||'Case When Trim(etichetta) Is Null Or Trim(ETICHETTA) = ''RFC'' Then ''No-RFC'' ';
            sqlstringa := sqlstringa ||'Else etichetta ';
            sqlstringa := sqlstringa ||'End etichetta ';
            sqlstringa := sqlstringa ||' From ';
            sqlstringa := sqlstringa ||' (Select SEDE_TECNICA, ';
            sqlstringa := sqlstringa || ' Listagg (DESCRIZIONE, '';'') ';
            sqlstringa := sqlstringa || ' Within Group (Order By CODICE)  ';
            sqlstringa := sqlstringa || ' as tooltip, ';
            sqlstringa := sqlstringa || ' Listagg (''RFC ''||CODICE, '';'') ';
            sqlstringa := sqlstringa || ' Within Group (Order By CODICE)  ';
            sqlstringa := sqlstringa || ' as etichetta ';
            sqlstringa := sqlstringa || ' From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO v ';
            sqlstringa := sqlstringa || ' Where CODICE_CONTESTO = 3 ';
--
            If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' And CODICE_VERSIONE='||p_versione;
            End If;
--
            sqlstringa := sqlstringa || ' Group By SEDE_TECNICA ';
            sqlstringa := sqlstringa || ') l,';
            sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI s ';
            sqlstringa := sqlstringa ||'Where s.SEDE_TECNICA = l.SEDE_TECNICA (+) ';
--
            If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' And s.CODICE_VERSIONE = '||p_versione;
            End If;
--
            If p_contesto <> 9 Then
                 sqlstringa := sqlstringa||' And s.SEDE_TECNICA in (';
                 sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA  From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
--               sqlstringa:= sqlstringa||' and CODICE='''||p_filtro ||'''';
---> aggiunto 13702/2022
                 If p_filtro Is Not Null Then
                      sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
                 End If;

                 If p_versione Is Not Null Then
                     sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
                 End If;
                 sqlstringa := sqlstringa||')';
             End If;
             sqlstringa := sqlstringa || ' ) h ';
--
-- 3 - Linee Commerciali
         When p_tipologia = 3     Then
            sqlstringa := ' (Select l.SEDE_TECNICA, ';
            sqlstringa := sqlstringa ||' Nvl(Trim(Linea_Comm.LINEA),''0000 - 0.000'') tooltip, ';
            sqlstringa := sqlstringa ||' Nvl(Trim(Linea_Comm.LINEA),''0000 - 0.000'') etichetta ';
            sqlstringa := sqlstringa ||' From '||s_schema||'.PUNTI_OPERATIVI l,   ';
            sqlstringa := sqlstringa ||' (Select v.SEDE_TECNICA, Listagg(Replace(CODICE,'' '','''')||'' - ''||Trim(To_Char(Round(v.KM_INIZIO,3),''999990.999'')), '';'' ) Within Group (Order By CODICE) as LINEA   ';
            sqlstringa := sqlstringa ||' From '||s_schema||'.V_MDR_LINEE_COMMERCIALI v,  ';
            sqlstringa := sqlstringa ||' '||s_schema||'.PUNTI_OPERATIVI p  ';
            sqlstringa := sqlstringa ||' Where ';
            sqlstringa := sqlstringa ||' p.SEDE_TECNICA = v.SEDE_TECNICA ';
--
            If p_versione Is Not Null Then
                 sqlstringa := sqlstringa ||' And v.CODICE_VERSIONE = p.CODICE_VERSIONE And  ';
                 sqlstringa := sqlstringa ||' v.CODICE_VERSIONE = '||p_versione;
            End If;
--
            sqlstringa := sqlstringa ||' Group By v.SEDE_TECNICA) Linea_Comm ';
            sqlstringa := sqlstringa ||' Where l.SEDE_TECNICA = Linea_Comm.SEDE_TECNICA (+) ';
--
            If p_contesto <> 9 Then
                sqlstringa := sqlstringa||' And l.SEDE_TECNICA  in (';
                sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA  From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
--                  sqlstringa:=sqlstringa||' And CODICE = '''||p_filtro ||'''';
---> aggiunto 13702/2022
                 If p_filtro Is Not Null Then
                      sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
                 End If;
--
                 If p_versione Is Not Null Then
                     sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
                 End If;
--
                 sqlstringa := sqlstringa||') ';
            End If;
--
            If p_versione Is Not Null Then
                 sqlstringa := sqlstringa ||' And CODICE_VERSIONE = '||p_versione;
            End If;
            sqlstringa := sqlstringa ||' ) h ';
--
-- 4 Linee FL/FO
         When p_tipologia = 4      Then
            sqlstringa := ' (Select SEDE_TECNICA, ';
            sqlstringa := sqlstringa||' Listagg(DEFINIZIONE, '';'') Within Group (Order By CODICE) as tooltip, ';
            sqlstringa := sqlstringa||' Listagg(CODICE, '';'') Within Group (Order By CODICE) as etichetta ';
            sqlstringa := sqlstringa||' From ';
            sqlstringa := sqlstringa||' (Select Distinct ';
            sqlstringa := sqlstringa||' LOCALITA_INIZIO SEDE_TECNICA, ';
            sqlstringa := sqlstringa||'    ''FL '' ';
            sqlstringa := sqlstringa||' || To_Char (f.FASCICOLO_LINEA) CODICE, ';
            sqlstringa := sqlstringa||' ''FL '' ';
            sqlstringa := sqlstringa||' || To_Char (f.FASCICOLO_LINEA)||'' - ''||f.DEFINIZIONE DEFINIZIONE ';
-->            sqlstringa := sqlstringa||' || To_Char (f.FASCICOLO_LINEA)||Null DEFINIZIONE ';   -- Modifica richiesta da Autiero nel SAL 01/2019
-->         
            sqlstringa := sqlstringa||' From '||s_schema||'.LINEA_FCL_SOL c, ';
            sqlstringa := sqlstringa||' Rinf_Anagrafiche_Evo.FASCICOLO_LINEE_FCL fl, ';
            sqlstringa := sqlstringa||' Rinf_Anagrafiche_Evo.ANAG_FASCICOLO_LINEE f, ';
            sqlstringa := sqlstringa||' '||s_schema||'.SEZIONI_LINEA s, ';
            sqlstringa := sqlstringa||' Rinf_Anagrafiche_Evo.ANAG_LINEA_FCL t ';
            sqlstringa := sqlstringa||' Where  ';
            sqlstringa := sqlstringa||' c.CODICE_LINEA_FCL = t.CODICE_LINEA_FCL ';
            sqlstringa := sqlstringa||' And s.SEDE_TECNICA = c.SEDE_TECNICA ';
            sqlstringa := sqlstringa||' And c.CODICE_LINEA_FCL = fl.CODICE_LINEA_FCL ';
            sqlstringa := sqlstringa||' And fl.CODICE_FASCICOLO = f.CODICE_FASCICOLO ';
            sqlstringa := sqlstringa||' And f.FLAG_DISPARI = 1 ';
-- 
            If p_versione Is Not Null Then
                  sqlstringa := sqlstringa||' And s.CODICE_VERSIONE = c.CODICE_VERSIONE';
                  sqlstringa := sqlstringa||' And s.CODICE_VERSIONE = '||p_versione;
            End If;
            sqlstringa := sqlstringa||') ';
--
            If p_contesto <> 9 Then
                sqlstringa := sqlstringa||' Where SEDE_TECNICA in (';
                sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA  From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
--                  sqlstringa := sqlstringa||' and CODICE='''||p_filtro ||'''';
---> aggiunto 13702/2022
                 If p_filtro Is Not Null Then
                      sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
                 End If;
--
                 If p_versione Is Not Null Then
                     sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
                 End If;
                 sqlstringa := sqlstringa||') ';
             End If;
             sqlstringa := sqlstringa||' Group By SEDE_TECNICA ';
             sqlstringa := sqlstringa ||' ) h ';
--
-- 5 - Linee Tecniche
         When p_tipologia = 5    Then
            sqlstringa :=  ' ( Select SEDE_TECNICA, ';
            sqlstringa := sqlstringa || ' Listagg (CODICE ||'' ''||DESCRIZIONE, '';'') ';
            sqlstringa := sqlstringa || ' Within Group (Order By CODICE)  ';
            sqlstringa := sqlstringa || ' as tooltip, ';
            sqlstringa := sqlstringa || ' Listagg (CODICE, '';'') ';
            sqlstringa := sqlstringa || ' Within Group (Order By CODICE)  ';
            sqlstringa := sqlstringa || ' As etichetta ';
            sqlstringa := sqlstringa || ' From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO v ';
            sqlstringa := sqlstringa || ' Where CODICE_CONTESTO = 6                            ';
            If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
            End If;
--           
            If p_contesto <> 9 Then
                 sqlstringa := sqlstringa||' And SEDE_TECNICA in (';
                 sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
--               sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
---> aggiunto 13/01/2022
                 If p_filtro Is Not Null Then
                      sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
                 End If;
--               
                 If p_versione Is Not Null Then
                   sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
                 End If;
                 sqlstringa := sqlstringa||')';
             End If;
             sqlstringa := sqlstringa || ' Group By SEDE_TECNICA ';
             sqlstringa := sqlstringa || ' ) h ';
--
-- 6 - Sezioni TEN-T
         When p_tipologia = 6     Then
             sqlstringa := ' (Select s.SEDE_TECNICA, Nvl(TOOLTIP, ''Off-Ten'') tooltip, Nvl(ETICHETTA,''Off-Ten'') etichetta ';
             sqlstringa := sqlstringa || ' From ';
             sqlstringa := sqlstringa || ' (Select SEDE_TECNICA, ';
             sqlstringa := sqlstringa || ' Listagg (CODICE ||'' ''||DESCRIZIONE, '';'') ';
             sqlstringa := sqlstringa || ' Within Group (Order By CODICE)  ';
             sqlstringa := sqlstringa || ' as tooltip, ';
             sqlstringa := sqlstringa || ' Listagg (CODICE, '';'') ';
             sqlstringa := sqlstringa || ' Within Group (Order By CODICE) ';
             sqlstringa := sqlstringa || ' as etichetta ';
             sqlstringa := sqlstringa || ' From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO v ';
             sqlstringa := sqlstringa || ' Where CODICE_CONTESTO = 4 ';
             If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
             End If;
             sqlstringa := sqlstringa || ' Group By SEDE_TECNICA ';
             sqlstringa := sqlstringa || ') l,';
             sqlstringa := sqlstringa || s_schema||'.PUNTI_OPERATIVI s ';
             sqlstringa := sqlstringa ||' Where s.SEDE_TECNICA = l.SEDE_TECNICA (+) ';
             If p_versione Is Not Null Then
                   sqlstringa := sqlstringa||' And s.CODICE_VERSIONE = '||p_versione;
             End If;
--
             If p_contesto <> 9 Then
                 sqlstringa := sqlstringa||' And s.SEDE_TECNICA in (';
                 sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
--               sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
---> aggiunto 13/01/2022
                 If p_filtro Is Not Null Then
                      sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
                 End If;
--               
                 If p_versione Is Not Null Then
                   sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
                 End If;
                 sqlstringa := sqlstringa||')';
             End If;
--
            sqlstringa := sqlstringa || ' ) h ';
--
-- 7 - Certificazioni
         When p_tipologia = 7    Then
             sqlstringa := ' (Select s.SEDE_TECNICA, ';
--           sqlstringa := sqlstringa||' Decode (dic.SEDE_TECNICA, Null, ''NO'', ''SI'') VALORE, ';
             sqlstringa := sqlstringa||' Decode (dic.SEDE_TECNICA, Null, Null, tooltip) tooltip, ';
             sqlstringa := sqlstringa||' Null etichetta ';
             sqlstringa := sqlstringa||' From '||s_schema||'.PUNTI_OPERATIVI s, ';
             sqlstringa := sqlstringa||' (Select SEDE_TECNICA, ';
             sqlstringa := sqlstringa||' Listagg (TIPO_DICHIARAZIONE || '': '' || DICHIARAZIONE, '';'') ';
             sqlstringa := sqlstringa||' Within Group (Order By DICHIARAZIONE) ';
             sqlstringa := sqlstringa||' as tooltip ';
             sqlstringa := sqlstringa||' From (Select Substr (PO_TRACK_1_2_1_0_0_2, 1, 6) SEDE_TECNICA, ';
             sqlstringa := sqlstringa||' ''INF - '' || TIPO_DICHIARAZIONE TIPO_DICHIARAZIONE, ';
             sqlstringa := sqlstringa||' PO_TRACK_1_2_1_0_1_1O2 DICHIARAZIONE ';
             sqlstringa := sqlstringa||' From '||s_schema||'.DICHIARAZIONI_BINARIO_PO ';
             sqlstringa := sqlstringa||' Where PO_TRACK_1_2_1_0_1_1O2_AP = ''Y'' ';
             If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
             End If;
             sqlstringa := sqlstringa||' ) ';
             sqlstringa := sqlstringa||' Group By SEDE_TECNICA) dic ';
             sqlstringa := sqlstringa||' Where s.SEDE_TECNICA = dic.SEDE_TECNICA(+) ';
             If p_versione Is Not Null Then
               sqlstringa := sqlstringa||' And s.CODICE_VERSIONE = '||p_versione;
             End If;
--
             If p_contesto <> 9 Then
                 sqlstringa := sqlstringa||' And s.SEDE_TECNICA  in (';
                 sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA From '||s_schema||'.V_OP_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
--              sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
---> aggiunto 13702/2022
                 If p_filtro Is Not Null Then
                      sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
                 End If;
--
                 If p_versione Is Not Null Then
                     sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
                 End If;
                 sqlstringa := sqlstringa||') ';
             END IF;
             sqlstringa := sqlstringa||') h ';

 --    WHEN p_tipologia=8   ERTMS NON è DI PO
  --  THEN null;
---> 
         Else 
           sqlstringa := '(Select null SEDE_TECNICA, null tooltip, null etichetta, null Xwgs, null Ywgs from dual) h ';	
--->
  End Case;

  sqlstringa_2 := 'Select  h.SEDE_TECNICA, ';
  sqlstringa_2 := sqlstringa_2||'h.SEDE_TECNICA||'' ''|| h.TOOLTIP tooltip, ';

--IF n_zoom=1 THEN
--    sqlstringa_2:=sqlstringa_2||' '' '' etichetta, ';
--ELSE
    sqlstringa_2 := sqlstringa_2||' Nvl(h.ETICHETTA, '' '') etichetta, ';
--END IF;
  sqlstringa_2 := sqlstringa_2||'L_G.X  As Xwgs, ';
  sqlstringa_2 := sqlstringa_2||'L_G.Y  As Ywgs ';
  sqlstringa_2 := sqlstringa_2||'From ';
  sqlstringa_2 := sqlstringa_2||'Rinf_Gis_Evo.LOCA_RETE t, ';
  sqlstringa_2 := sqlstringa_2||'Table(Sdo_Util.Getvertices(T.GEOMETRY)) L_G, ';
  --
  sqlstringa_2 := sqlstringa_2||sqlstringa;
--
  sqlstringa_2 := sqlstringa_2||'Where ';
  sqlstringa_2 := sqlstringa_2||'t.OR_ID = h.SEDE_TECNICA ';
  sqlstringa_2 := sqlstringa_2||'And t.VERSIONE_MDR = '||n_versione_MDR;
--

--     DBms_Output.Put_Line(sqlstringa_2);

     Open p_cursor For sqlstringa_2;
--
  End If;

 Exception
      When Others  Then
        Dbms_Output.Put_Line ('PKG_RINF_GRAFICA.GetPOEtichetta  - Errore: '|| Substr(SQLERRM, 1, 300));
 End GetPOEtichetta;
--
-- -----------------------------------------------------------------------------
--  PROCEDURE GetSOLEtichetta
-- -----------------------------------------------------------------------------
--
 Procedure GetSOLEtichetta (p_tipologia NUMBER, p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2, p_i_versione NUMBER, xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER, p_cursor Out empcur) Is
    sqlstringa     VARCHAR2(32000);
    p_versione     NUMBER;
    s_schema       VARCHAR2(200);
    sqlstringa_2   VARCHAR2(32000);
    n_zoom         NUMBER;
    n_versione_MDR NUMBER;
--	
  Begin
--
   Select Pkg_Rinf_Gis_V2.FNC_GET_ZOOM(xtl , ytl , xbr , ybr ) Into n_zoom From dual;
--
   If n_zoom = 1 Then --14/02/2017 Se il livello di zoom è troppo basso non vengono mostrate le etichette ed i tooltip, il jason restituito è vuoto
        Open p_cursor For 'select null SEDE_TECNICA, null tooltip, null etichetta, null COORD_PUNTI from dual';
--          dbms_output.Put_line('Select null SEDE_TECNICA, null tooltip, null etichetta, null COORD_PUNTI from dual');
   Else
--
       If p_area Is Not Null Then
           s_schema := PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
--		   dbms_output.put_line ('schema: '||s_schema);
       End If;
--     
       p_versione := p_i_versione;
--
       If (p_area = 2 Or p_area = 4) And p_versione Is Null Then
            p_versione := PKG_RINF_DATA_V082.GetLastVersion(p_area);
-- 	        dbms_output.put_line ('versione Pubblicati: '||p_versione );
       End If;

      --15/11/2017 Per la Storicizzazione del MDR GIS è necessario individuare la versione del MDR GIS corrispondente all'ultimo RI Pubblicato/Inviato
       n_versione_MDR := PKG_RINF_GIS_V2.FNC_GET_VERSIONE_MDR(p_area, p_versione);
--       dbms_output.put_line ('versione_MDR : '||n_versione_MDR );

      CASE
--
-- 1 - Gallerie
      When p_tipologia = 1    Then
         sqlstringa := ' (Select b.SEDE_TECNICA, ';
         sqlstringa := sqlstringa||'Listagg(g.SOL_TUNNEL_1_1_1_1_8_2||'' - ''|| SOL_TUNNEL_1_1_1_1_8_2_D,'';'') Within Group (Order By g.SOL_TUNNEL_1_1_1_1_8_2) tooltip, ';
         sqlstringa := sqlstringa||'Null etichetta ';
         sqlstringa := sqlstringa||'From '||s_schema||'.GALLERIE_BINARI_SOL g, ';
         sqlstringa := sqlstringa||s_schema||'.REL_GALLERIE_BINARI_SOL r, ';
         sqlstringa := sqlstringa||s_schema||'.BINARI_CORSA_SOL b ';
         sqlstringa := sqlstringa||'Where ';
         sqlstringa := sqlstringa||'g.SOL_TUNNEL_1_1_1_1_8_2 = r.SOL_TUNNEL_1_1_1_1_8_2 And ';
         sqlstringa := sqlstringa||'r.SOL_TRACK_1_1_1_0_0_1 = b.SOL_TRACK_1_1_1_0_0_1  ';
         If p_versione Is Not Null Then
             sqlstringa := sqlstringa||'And g.CODICE_VERSIONE = r.CODICE_VERSIONE ';
             sqlstringa := sqlstringa||'And r.CODICE_VERSIONE = b.CODICE_VERSIONE ';
             sqlstringa := sqlstringa||'And b.CODICE_VERSIONE = '||p_versione;
         End If;
--
         If p_contesto <> 9 Then
             sqlstringa := sqlstringa||' And b.SEDE_TECNICA  in (';
             sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;

---> aggiunto 13702/2022
             If p_filtro Is Not Null Then
                 sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
             End If;
--->
             If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' and CODICE_VERSIONE = '||p_versione;
             End If;
             sqlstringa := sqlstringa||')';
         End If;
         sqlstringa := sqlstringa||' Group By SEDE_TECNICA) h ';
--
-- 2 - Corridoi UE
         When p_tipologia = 2   Then  -- null;
         sqlstringa := ' (Select s.SEDE_TECNICA, NVL(tooltip,''No-RFC'') tooltip, ';
         sqlstringa := sqlstringa ||'Case When Trim(ETICHETTA) Is Null Or Trim(ETICHETTA)=''RFC'' Then ''No-RFC'' ';
         sqlstringa := sqlstringa ||'Else etichetta ';
         sqlstringa := sqlstringa ||'End etichetta ';
         sqlstringa := sqlstringa ||' From ';
         sqlstringa := sqlstringa ||' (Select SEDE_TECNICA, ';
         sqlstringa := sqlstringa ||' Listagg (DESCRIZIONE, '';'') ';
         sqlstringa := sqlstringa ||' Within Group (Order By CODICE)  ';
         sqlstringa := sqlstringa ||' As tooltip, ';
         sqlstringa := sqlstringa ||' Listagg (''RFC ''||CODICE, '';'') ';
         sqlstringa := sqlstringa ||' Within Group (Order By CODICE) ';
         sqlstringa := sqlstringa ||' As etichetta ';
         sqlstringa := sqlstringa ||' From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v ';
         sqlstringa := sqlstringa ||' Where CODICE_CONTESTO = 3 ';
         IF p_versione Is Not Null Then
               sqlstringa := sqlstringa||' and CODICE_VERSIONE = '||p_versione;
         End If;
         sqlstringa := sqlstringa || ' Group By SEDE_TECNICA ';
         sqlstringa := sqlstringa || ' ) l,';
         sqlstringa := sqlstringa || s_schema||'.SEZIONI_LINEA s ';
         sqlstringa := sqlstringa ||'Where s.SEDE_TECNICA = l.SEDE_TECNICA (+) ';
         If p_versione Is Not Null Then
               sqlstringa := sqlstringa||' And s.CODICE_VERSIONE = '||p_versione;
         End If;
--
         If p_contesto <> 9 Then
             sqlstringa := sqlstringa||' And s.SEDE_TECNICA  In (';
             sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA  From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
--             sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
---> aggiunto 13702/2022
             If p_filtro Is Not Null Then
                  sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
             End If;
--->
             If p_versione Is Not Null Then
               sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
             End If;
             sqlstringa := sqlstringa||')';
         End If;
--
         sqlstringa := sqlstringa || ' ) h ';
-- 
-- 3 - Linee Commerciali
         When p_tipologia = 3   Then
         sqlstringa := ' (Select l.SEDE_TECNICA, ';
         sqlstringa := sqlstringa ||' Nvl(Trim(linea_comm.LINEA),''0000 - 0.000'') tooltip, ';
         sqlstringa := sqlstringa ||' Nvl(Trim(linea_comm.LINEA),''0000 - 0.000'') etichetta ';
         sqlstringa := sqlstringa ||' From '||s_schema||'.SEZIONI_LINEA l,   ';
         sqlstringa := sqlstringa ||' (Select v.SEDE_TECNICA, Listagg(Replace(CODICE,'' '','''')||'' - ''||Trim(To_Char(Round(v.KM_INIZIO,3),''999990.999'')) ,'';'' ) Within Group (Order By CODICE) As LINEA   ';
         sqlstringa := sqlstringa ||' From '||s_schema||'.V_MDR_LINEE_COMMERCIALI v,  ';
         sqlstringa := sqlstringa ||' '||s_schema||'.SEZIONI_LINEA p  ';
         sqlstringa := sqlstringa ||' Where ';
         sqlstringa := sqlstringa || ' p.SEDE_TECNICA = v.SEDE_TECNICA ';
         If p_versione Is Not Null Then
              sqlstringa := sqlstringa ||' And v.CODICE_VERSIONE = p.CODICE_VERSIONE And   ';
              sqlstringa := sqlstringa ||' v.CODICE_VERSIONE = '||p_versione;
         End If;
         sqlstringa := sqlstringa ||' Group By v.SEDE_TECNICA) linea_comm ';
         sqlstringa := sqlstringa ||' Where l.SEDE_TECNICA = linea_comm.SEDE_TECNICA (+) ';
--
         If p_contesto <> 9 Then
             sqlstringa := sqlstringa||' And l.SEDE_TECNICA  In (';
             sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA  From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
---> aggiunto 13702/2022
             If p_filtro Is Not Null Then
                  sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
             End If;
--->
             sqlstringa := sqlstringa||' and CODICE='''||p_filtro ||'''';
             If p_versione Is Not Null Then
               sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
             End If;
             sqlstringa := sqlstringa||')  ';
         End If;
         If p_versione Is Not Null Then
             sqlstringa := sqlstringa ||' And CODICE_VERSIONE='||p_versione;
         End If;
         sqlstringa := sqlstringa ||' ) h ';
--
-- 4 - Linee FL/FO
         When p_tipologia = 4    Then
             sqlstringa := ' (Select SEDE_TECNICA, ';
             sqlstringa := sqlstringa||' Listagg(DEFINIZIONE, '';'') Within Group (Order By CODICE) As tooltip, ';
             sqlstringa := sqlstringa||' Listagg(CODICE, '';'') Within Group (Order By CODICE) As etichetta ';
             sqlstringa := sqlstringa||' From ';
             sqlstringa := sqlstringa||' (Select Distinct ';
             sqlstringa := sqlstringa||' c.SEDE_TECNICA, ';
             sqlstringa := sqlstringa||' ''FL '' ';
             sqlstringa := sqlstringa||' || To_Char (f.FASCICOLO_LINEA) CODICE, ';
             sqlstringa := sqlstringa||' ''FL '' ';
             sqlstringa := sqlstringa||' || To_Char (f.FASCICOLO_LINEA)||'' - ''||f.DEFINIZIONE DEFINIZIONE ';
     -->     sqlstringa := sqlstringa||' || To_Char (f.FASCICOLO_LINEA)||NULL DEFINIZIONE ';   -- Modifica richiesta da Autiero nel SAL 01/2019
     -->
             sqlstringa := sqlstringa||' From '||s_schema||'.LINEA_FCL_SOL c, ';
             sqlstringa := sqlstringa||' RINF_ANAGRAFICHE_EVO.FASCICOLO_LINEE_FCL fl, ';
             sqlstringa := sqlstringa||' RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE f, ';
             sqlstringa := sqlstringa||' '||s_schema||'.SEZIONI_LINEA s, ';
             sqlstringa := sqlstringa||' RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL t ';
             sqlstringa := sqlstringa||' Where ';
             sqlstringa := sqlstringa||' c.CODICE_LINEA_FCL = t.CODICE_LINEA_FCL ';
             sqlstringa := sqlstringa||' AND s.SEDE_TECNICA = c.SEDE_TECNICA ';
             sqlstringa := sqlstringa||' AND c.CODICE_LINEA_FCL = fl.CODICE_LINEA_FCL ';
             sqlstringa := sqlstringa||' AND fl.CODICE_FASCICOLO = f.CODICE_FASCICOLO ';
             sqlstringa := sqlstringa||' AND f.FLAG_DISPARI = 1 ';
             IF p_versione Is Not Null Then
                  sqlstringa := sqlstringa||' And s.CODICE_VERSIONE = c.CODICE_VERSIONE';
                  sqlstringa := sqlstringa||' And s.CODICE_VERSIONE = '||p_versione;
                 End If;
             sqlstringa := sqlstringa||') ';
--
             If p_contesto <> 9 Then
                  sqlstringa := sqlstringa||' Where SEDE_TECNICA  In (';
                  sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA  From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
--                  sqlstringa := sqlstringa||' and CODICE = '''||p_filtro ||'''';
---> aggiunto 13702/2022
                 If p_filtro Is Not Null Then
                      sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
                 End If;
--->

                 If p_versione Is Not Null Then
                     sqlstringa := sqlstringa||' and CODICE_VERSIONE = '||p_versione;
                 End If;
                 sqlstringa := sqlstringa||')  ';
             End If;
             sqlstringa := sqlstringa||' Group By SEDE_TECNICA ';
             sqlstringa := sqlstringa ||' ) h ';
--
-- 5 - Linee Tecniche
         When p_tipologia = 5   Then
             sqlstringa :=  ' (Select SEDE_TECNICA, ';
             sqlstringa := sqlstringa || ' Listagg (CODICE ||'' ''||DESCRIZIONE, '';'') ';
             sqlstringa := sqlstringa || ' Within Group (Order By CODICE)  ';
             sqlstringa := sqlstringa || ' As tooltip, ';
             sqlstringa := sqlstringa || ' Listagg (CODICE, '';'') ';
             sqlstringa := sqlstringa || ' Within Group (Order By CODICE)  ';
             sqlstringa := sqlstringa || ' As  etichetta ';
             sqlstringa := sqlstringa || ' From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v ';
             sqlstringa := sqlstringa || ' Where CODICE_CONTESTO = 6                            ';
             If p_versione Is Not Null Then
                   sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
             End If;

             IF p_contesto <> 9 Then
                 sqlstringa := sqlstringa||' and sede_tecnica  IN (';
                 sqlstringa := sqlstringa||' Select DISTINCT SEDE_TECNICA  from '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
--                 sqlstringa := sqlstringa||' and CODICE='''||p_filtro ||'''';
---> aggiunto 13/01/2022
                 If p_filtro Is Not Null Then
                     sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
                 End If;
--->
                 If p_versione Is Not Null Then
                     sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
                 End If;
                 sqlstringa := sqlstringa||')';
             End If;
            sqlstringa := sqlstringa || ' Group By SEDE_TECNICA ';
            sqlstringa := sqlstringa || ' ) h ';

--
-- 6 - Sezioni TEN-T
         When p_tipologia = 6   Then
             sqlstringa := ' (Select s.SEDE_TECNICA, Nvl(TOOLTIP,''Off-Ten'') tooltip, Nvl(ETICHETTA,''Off-Ten'') etichetta ';
             sqlstringa := sqlstringa || ' From ';
             sqlstringa := sqlstringa || '(Select SEDE_TECNICA, ';
             sqlstringa := sqlstringa || ' Listagg (CODICE ||'' ''||DESCRIZIONE, '';'') ';
             sqlstringa := sqlstringa || ' Within Group (Order By CODICE)  ';
             sqlstringa := sqlstringa || ' As tooltip, ';
             sqlstringa := sqlstringa || ' Listagg (CODICE, '';'') ';
             sqlstringa := sqlstringa || ' Within Group (Order By CODICE)  ';
             sqlstringa := sqlstringa || ' As etichetta ';
             sqlstringa := sqlstringa || ' From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO v ';
             sqlstringa := sqlstringa || ' Where CODICE_CONTESTO = 4                            ';
             If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
             End If;
             sqlstringa := sqlstringa || ' Group By SEDE_TECNICA ';
             sqlstringa := sqlstringa || ') l,';
             sqlstringa := sqlstringa || s_schema||'.SEZIONI_LINEA s ';
             sqlstringa := sqlstringa ||' Where s.SEDE_TECNICA = l.SEDE_TECNICA (+) ';
             IF p_versione Is Not Null Then
                   sqlstringa := sqlstringa||' And s.CODICE_VERSIONE = '||p_versione;
             End If;
--
             IF p_contesto <> 9 Then
                 sqlstringa := sqlstringa||' And s.SEDE_TECNICA  In (';
                 sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA  From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
--                 sqlstringa := sqlstringa||' and CODICE = '''||p_filtro ||'''';
---> aggiunto 13/01/2022
                 If p_filtro Is Not Null Then
                     sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
                 End If;
--->
                 If p_versione Is Not Null Then
                     sqlstringa:=sqlstringa||' and CODICE_VERSIONE = '||p_versione;
                 End If;
                 sqlstringa := sqlstringa||')';
             End If;

         sqlstringa := sqlstringa || ' ) h ';

--
-- 7 - Certificazioni
          When p_tipologia = 7  Then
             sqlstringa := ' (Select s.SEDE_TECNICA, ';
             sqlstringa := sqlstringa||' Decode (dic.SEDE_TECNICA, Null, Null, tooltip) tooltip, ';
             sqlstringa := sqlstringa||' Null etichetta ';
             sqlstringa := sqlstringa||' From '||s_schema||'.SEZIONI_LINEA s, ';
             sqlstringa := sqlstringa||' (Select SEDE_TECNICA, ';
             sqlstringa := sqlstringa||'  Listagg (TIPO_DICHIARAZIONE || '': '' || DICHIARAZIONE, '';'') ';
             sqlstringa := sqlstringa||'  Within Group (Order By DICHIARAZIONE) ';
             sqlstringa := sqlstringa||'  As tooltip ';
             sqlstringa := sqlstringa||'  From (Select Substr (SOL_TRACK_1_1_1_0_0_1, 1, 6) SEDE_TECNICA, ';
             sqlstringa := sqlstringa||'  ''INF - '' || TIPO_DICHIARAZIONE  TIPO_DICHIARAZIONE, ';
             sqlstringa := sqlstringa||'  SOL_TRACK_1_1_1_1_1_1O2 DICHIARAZIONE ';
             sqlstringa := sqlstringa||'  From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_INF ';
             sqlstringa := sqlstringa||'  Where SOL_TRACK_1_1_1_1_1_1O2_AP = ''Y'' ';
             IF p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
             End If;
             sqlstringa := sqlstringa||' Union ';
             sqlstringa := sqlstringa||' Select Substr (SOL_TRACK_1_1_1_0_0_1, 1, 6) SEDE_TECNICA, ';
             sqlstringa := sqlstringa||' ''ENE - '' || TIPO_DICHIARAZIONE  TIPO_DICHIARAZIONE, ';
             sqlstringa := sqlstringa||' SOL_TRACK_1_1_1_2_1_1O2  DICHIARAZIONE ';
             sqlstringa := sqlstringa||' From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_ENE ';
             sqlstringa := sqlstringa||' Where SOL_TRACK_1_1_1_2_1_1O2_AP = ''Y'' ';
             IF p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' and CODICE_VERSIONE = '||p_versione;
             End If;
             sqlstringa := sqlstringa||' UNION ';
             sqlstringa := sqlstringa||' Select Substr (SOL_TRACK_1_1_1_0_0_1, 1, 6) SEDE_TECNICA, ';
             sqlstringa := sqlstringa||' ''CCS - '' || TIPO_DICHIARAZIONE  TIPO_DICHIARAZIONE, ';
             sqlstringa := sqlstringa||' SOL_TRACK_1_1_1_3_1_1  DICHIARAZIONE ';
             sqlstringa := sqlstringa||' From '||s_schema||'.DICHIARAZIONI_BINARIO_SOL_CCS ';
             sqlstringa := sqlstringa||' Where SOL_TRACK_1_1_1_3_1_1_AP = ''Y'' ';
             IF p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' and CODICE_VERSIONE = '||p_versione;
             End If;
             sqlstringa := sqlstringa||' ) ';
             sqlstringa := sqlstringa||' Group By SEDE_TECNICA) dic ';
             sqlstringa := sqlstringa||' Where s.SEDE_TECNICA = dic.SEDE_TECNICA(+) ';
             If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' And s.CODICE_VERSIONE = '||p_versione;
             End If;
--
             If p_contesto <> 9 Then
                 sqlstringa := sqlstringa||' And s.SEDE_TECNICA In (';
                 sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA  From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS Where CODICE_CONTESTO = '||p_contesto;
--                 sqlstringa := sqlstringa||' and CODICE = '''||p_filtro ||'''';
---> aggiunto 13/01/2022
                 If p_filtro Is Not Null Then
                      sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
                 End If;
--->
                 If p_versione Is Not Null Then
                     sqlstringa := sqlstringa||' and CODICE_VERSIONE = '||p_versione;
                 End If;
                    sqlstringa := sqlstringa||') ';
             End If;
             sqlstringa := sqlstringa||') h ';
--
-- 8 - ERTMS     
         When p_tipologia = 8   Then
             sqlstringa :='(Select s.SEDE_TECNICA, ';
             sqlstringa := sqlstringa || ' Listagg (rtms.VALORE, '';'') ';
             sqlstringa := sqlstringa || ' Within Group (Order By rtms.VALORE) ';
             sqlstringa := sqlstringa || ' "VALORE", ';
             sqlstringa := sqlstringa || ' t_tooltip.tooltip, ';
             sqlstringa := sqlstringa || ' Null etichetta ';
             sqlstringa := sqlstringa || ' From ';
             sqlstringa := sqlstringa || ' (Select SEDE_TECNICA, ';
             sqlstringa := sqlstringa || '  Listagg ( ';
             sqlstringa := sqlstringa || '  Decode ( ';
             sqlstringa := sqlstringa || '  SOL_TRACK_1_1_1_3_2_1_AP, ';
             sqlstringa := sqlstringa || '  ''Y'', Substr (SOL_TRACK_1_1_1_0_0_1, 11) ';
             sqlstringa := sqlstringa || '  || '': '' ';
             sqlstringa := sqlstringa || '  || SOL_TRACK_1_1_1_3_2_1, ';
             sqlstringa := sqlstringa || '  Null), ';
             sqlstringa := sqlstringa || '  '';'') ';
             sqlstringa := sqlstringa || ' Within Group (Order By Substr (SOL_TRACK_1_1_1_0_0_1, 11)) ';
             sqlstringa := sqlstringa || ' tooltip ';
             sqlstringa := sqlstringa || ' From '||s_schema||'.BINARI_CORSA_SOL ';
             If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' Where CODICE_VERSIONE = '||p_versione;
             End If;
             sqlstringa := sqlstringa || ' Group By SEDE_TECNICA) t_tooltip, ';
             sqlstringa := sqlstringa || ' (Select Distinct ';
             sqlstringa := sqlstringa || ' SEDE_TECNICA, ';
             sqlstringa := sqlstringa || ' Case ';
             sqlstringa := sqlstringa || '     When (SOL_TRACK_1_1_1_3_2_1 = ''N'') Then ''NO'' ';
             sqlstringa := sqlstringa || '     When SOL_TRACK_1_1_1_3_2_1_AP = ''N'' Then ''Non Applicabile'' ';
             sqlstringa := sqlstringa || '     When SOL_TRACK_1_1_1_3_2_1_AP = ''NYA'' Then ''NYA'' ';
             sqlstringa := sqlstringa || '     Else ''SI'' ';
             sqlstringa := sqlstringa || ' End VALORE ';
             sqlstringa := sqlstringa || ' From '||s_schema||'.BINARI_CORSA_SOL ';
             If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' Where CODICE_VERSIONE = '||p_versione;
             End If;
             sqlstringa := sqlstringa || ' ) rtms, ';
             sqlstringa := sqlstringa || ' '||s_schema||'.SEZIONI_LINEA s ';
             sqlstringa := sqlstringa || ' Where t_tooltip.SEDE_TECNICA = s.SEDE_TECNICA ';
             sqlstringa := sqlstringa || ' And rtms.SEDE_TECNICA = s.SEDE_TECNICA ';
             If p_versione Is Not Null Then
                 sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
             End If;
             If p_contesto <> 9 Then
                 sqlstringa := sqlstringa||' And s.SEDE_TECNICA  In (';
                 sqlstringa := sqlstringa||' Select Distinct SEDE_TECNICA  From '||s_schema||'.V_SOL_CONTESTO_GEOGRAFICO_PLUS  Where CODICE_CONTESTO = '||p_contesto;
--                 sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
---> aggiunto 13/01/2022
                 If p_filtro Is Not Null Then
                      sqlstringa := sqlstringa||' And CODICE = '''||p_filtro ||'''';
                 End If;
--->
                 If p_versione Is Not Null Then
                      sqlstringa := sqlstringa||' And CODICE_VERSIONE = '||p_versione;
                 End If;
                 sqlstringa := sqlstringa||')';
--
             End If;
             sqlstringa := sqlstringa || ' Group By s.SEDE_TECNICA, t_tooltip.TOOLTIP ';
             sqlstringa := sqlstringa||') h ';
             ---> aggiunto !!!
         Else 
             sqlstringa := '(Select null SEDE_TECNICA, null tooltip, null etichetta, null COORD_PUNTI from dual) h ';	
     --->

      End Case;
--
--    
     sqlstringa_2 := 'Select h.SEDE_TECNICA,  ';
     sqlstringa_2 := sqlstringa_2||' h.SEDE_TECNICA||'' ''||h.TOOLTIP tooltip, ';
     --IF n_zoom=1 Then
     --sqlstringa_2:=sqlstringa_2||' '' '' etichetta, '; --A livello di zoom basso le etichette non vanno mostrate
     --sqlstringa_2:=sqlstringa_2||' ''[[''||LI_G.X||'',''|| LI_G.Y ||''],[''|| LF_G.X ||'',''|| LF_G.Y||'']]'' COORD_PUNTI, ';
     --ELSE
     sqlstringa_2 := sqlstringa_2||' Nvl(h.ETICHETTA, '' '') etichetta, ';
     sqlstringa_2 := sqlstringa_2||'Pkg_Rinf_Gis_V2.Fnc_Get_Vertex(Sdo_Util.Simplify(to_2d(t.GEOMETRY), 1.5)) COORD_PUNTI ';
     --End If;
     sqlstringa_2 := sqlstringa_2|| ' From ';
     sqlstringa_2 := sqlstringa_2|| 'RINF_GIS_EVO.TRAT_RETE t,  ';
     sqlstringa_2 := sqlstringa_2|| 'RINF_GIS_EVO.LOCA_RETE LI_W, ';
     sqlstringa_2 := sqlstringa_2|| 'RINF_GIS_EVO.LOCA_RETE LF_W, ';
     sqlstringa_2 := sqlstringa_2|| 'Table(Sdo_Util.Getvertices(Sdo_Lrs.Geom_Segment_Start_Pt(t.GEOMETRY))) LI_G, ';
     sqlstringa_2 := sqlstringa_2|| 'Table(Sdo_Util.Getvertices(Sdo_Lrs.Geom_Segment_End_Pt(t.GEOMETRY))) LF_G, ';
     sqlstringa_2 := sqlstringa_2|| sqlstringa;
     sqlstringa_2 := sqlstringa_2||' Where ';
     sqlstringa_2 := sqlstringa_2||' t.TR_ORIG = LI_W.OR_ID ';
     sqlstringa_2 := sqlstringa_2||' And t.TR_DEST = LF_W.OR_ID  ';
     sqlstringa_2 := sqlstringa_2||' And t.VERSIONE_MDR = '||n_versione_MDR;
     sqlstringa_2 := sqlstringa_2||' And LI_W.VERSIONE_MDR = '||n_versione_MDR;
     sqlstringa_2 := sqlstringa_2||' And LF_W.VERSIONE_MDR = '||n_versione_MDR;
     sqlstringa_2 := sqlstringa_2||' And t.OR_ID = h.SEDE_TECNICA ';
     sqlstringa_2 := sqlstringa_2||' And Sdo_Anyinteract(T.GEOMETRY, Sdo_Geometry(2003, 4326, Null, Sdo_Elem_Info_Array(1, 1003, 3), Sdo_Ordinate_Array('||Replace(To_Char(xtl),',','.')||', '||Replace(To_Char(ytl),',','.')||', '|| Replace(To_Char(xbr),',','.')||', '|| Replace(To_Char(ybr),',','.')||')))=''TRUE''';
--
--     Dbms_Output.Put_Line(sqlstringa_2);
     Open p_cursor For sqlstringa_2;
  End If;
--
Exception
      When Others  Then
        Dbms_Output.Put_Line ('PKG_RINF_GRAFICA.GetSOLEtichetta  - Errore: '|| Substr(SQLERRM, 1, 300));
 END GetSOLEtichetta;
-- 
-- -------------------------------------------------------------------------------------- 
--
-- -------------------------------------------------------------------------------------- 
--
 Procedure GetEtichetta (p_tipologia NUMBER, p_contesto_SOL_OP NUMBER, p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2, p_i_versione NUMBER, xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER, p_cursor OUT empcur)
  Is
 Begin
    If p_contesto_SOL_OP = 1 Then
        GetPOEtichetta (p_tipologia, p_contesto, p_area, p_filtro, p_i_versione, xtl, ytl, xbr, ybr, p_cursor);
    Else
        GetSOLEtichetta(p_tipologia, p_contesto, p_area, p_filtro, p_i_versione, xtl, ytl, xbr, ybr, p_cursor);
    End If;
--	
 Exception
      When Others  Then
        Dbms_Output.Put_Line ('PKG_RINF_GRAFICA.GetEtichetta  - Errore: '|| Substr(SQLERRM, 1, 300));
 End GetEtichetta;
--
End PKG_RINF_GRAFICA;
/