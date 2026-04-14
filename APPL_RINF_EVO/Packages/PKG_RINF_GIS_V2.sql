--
-- PKG_RINF_GIS_V2  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_GIS_V2" AS
/******************************************************************************
   NAME:       PKG_RINF_GIS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/10/2013   D.Campagiorni    1. Created this package.
******************************************************************************/

  TYPE empcur IS REF CURSOR;

  FUNCTION FNC_GET_ZOOM(xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER) RETURN NUMBER;
  FUNCTION FNC_GET_VERTEX(p_geometry MDSYS.SDO_GEOMETRY) RETURN CLOB;
  FUNCTION FNC_GET_VERSIONE_MDR(p_area NUMBER, p_i_versione NUMBER) RETURN NUMBER;

  PROCEDURE SP_GEO_TRATTE(p_area NUMBER, p_i_versione NUMBER, xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER,p_cursor OUT empcur);
  PROCEDURE SP_GEO_LOCALITA(p_area NUMBER, p_i_versione NUMBER,xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER,p_cursor OUT empcur);
  PROCEDURE SP_GEO_SOLList(p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2, xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
  PROCEDURE SP_GEO_OPList(p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2,p_i_versione NUMBER,p_cursor OUT empcur);
  PROCEDURE SP_GEO_CONTEST_CENTER(p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2,p_i_versione NUMBER,p_cursor OUT empcur);
  PROCEDURE SP_SET_VERSIONE_MDR( p_area NUMBER,p_i_versione NUMBER,p_error OUT NUMBER);

--13/11/2017 Per la gestione della storicizzazione è necessario cambiare le firme delle seguenti procedure
  --OLD
--  PROCEDURE SP_GET_CENTER(p_identificativo VARCHAR2,p_cursor OUT empcur);
--  PROCEDURE SP_ALL_LOCALITA(p_cursor OUT empcur);
--  PROCEDURE SP_ALL_TRATTE_SIMPLY(p_cursor OUT empcur);
--  PROCEDURE SP_ALL_LINEE_SIMPLY(p_cursor OUT empcur);
--NEW
PROCEDURE SP_GET_CENTER(p_area NUMBER,p_i_versione NUMBER, p_identificativo VARCHAR2,p_cursor OUT empcur);
--21/05/2018 i riferimenti nell'applicaizione a queste procedure non sono stati trovati
--si commentano per verificare se effettivamente siano obsolete
--PROCEDURE SP_ALL_LOCALITA(p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
--PROCEDURE SP_ALL_TRATTE_SIMPLY(p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);
--PROCEDURE SP_ALL_LINEE_SIMPLY(p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur);

END PKG_RINF_GIS_V2;
/


--
-- PKG_RINF_GIS_V2  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_GIS_V2" As
/******************************************************************************
   NAME:       PKG_RINF_GIS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/10/2013   D.Campagiorni    1. Created this package.
******************************************************************************/

--
-- --------------------------------------------------------------------------------------
--                          FUNCTION FNC_GET_ZOOM
-- --------------------------------------------------------------------------------------
--

Function FNC_GET_ZOOM(xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER)
  Return Number Is
--
  n_area Number;
--
 Begin
    Select Nvl(Round(SDO_GEOM.SDO_AREA(SDO_GEOMETRY(2003, 4326, NULL, SDO_ELEM_INFO_ARRAY(1, 1003, 3), SDO_ORDINATE_ARRAY(xtl, ytl, xbr, ybr)),0.005,'unit=SQ_KM')),0)
    Into n_area From Dual;
--
    If n_area >= 6000 Then
        Return 1;
    Elsif n_area < 6000 and n_area> 700 Then
        RETURN 2;
    Elsif n_area <= 700 Then
        Return 3;
    End If;
--
END FNC_GET_ZOOM;

--
-- --------------------------------------------------------------------------------------
--                        FUNCTION FNC_GET_VERTEX
-- --------------------------------------------------------------------------------------
--

FUNCTION FNC_GET_VERTEX(p_geometry MDSYS.SDO_GEOMETRY)
RETURN CLOB IS
s_coord CLOB;---VARCHAR2(32767);
CURSOR c_coord IS
Select a.x as x,a.y as y
from
TABLE(SDO_UTIL.GETVERTICES(p_geometry)) a;

r_coord c_coord%rowtype;

--06/03/2017 inserita la funzione di sostituzione delle virgole con i punti nelle coordinate
--per evitare un errore di parsing del jason
BEGIN
s_coord:='[';
  FOR r_coord IN c_coord LOOP
    s_coord:=to_clob(s_coord||'['||REPLACE(TO_CHAR(ROUND(r_coord.x,5)),',','.')||','||REPLACE(TO_CHAR(ROUND(r_coord.y,5)),',','.')||'],');
  END LOOP;
s_coord:=to_clob(substr(s_coord,1,length(s_coord)-1)||']');

RETURN s_coord;

END FNC_GET_VERTEX;
--
-- --------------------------------------------------------------------------------------
--                      FUNCTION FNC_GET_VERSIONE_MDR
-- --------------------------------------------------------------------------------------
--

FUNCTION FNC_GET_VERSIONE_MDR(p_area NUMBER, p_i_versione NUMBER)
RETURN NUMBER IS
n_versione_mdr NUMBER;
--13/11/2017 Funzione che in base all'area dati e al codice della versione del registro restituisce la corretta versione del MDr da visualizzare
BEGIN
Select VERSIONE_MDR into n_versione_mdr
from RINF_GIS_EVO.MDR_REGISTRO
WHERE
CODICE_AREA=p_area
AND CODICE_VERSIONE=NVL(p_i_versione,0);
RETURN n_versione_mdr;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END FNC_GET_VERSIONE_MDR;

--
-- --------------------------------------------------------------------------------------
--                     PROCEDURE SP_GEO_TRATTE
-- --------------------------------------------------------------------------------------
--

PROCEDURE SP_GEO_TRATTE(p_area NUMBER, p_i_versione NUMBER,xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER,p_cursor OUT empcur) IS
n_zoom NUMBER;
s_schema VARCHAR2(50);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
n_versione_mdr NUMBER;
BEGIN
select FNC_GET_ZOOM(xtl , ytl , xbr , ybr ) into n_zoom from dual;

 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=PKG_RINF_DATA_V082.GetLastVersion(p_area);
 END IF;

 --13/11/2017 Gestione storicizzazione MDR. In bese all'area dati e alla versione del registro viene visualizzato un MDR GIS diverso
 n_versione_mdr := FNC_GET_VERSIONE_MDR(p_area,p_versione);

IF n_zoom=1 THEN
    sqlstringa:=' SELECT ';
    sqlstringa:=sqlstringa||' T.OR_ID AS Cod, ';
    sqlstringa:=sqlstringa||' T.TR_ORIG AS L1, ';
    sqlstringa:=sqlstringa||' T.TR_DEST AS L2, ';
    sqlstringa:=sqlstringa||' NULL AS V, ';
    sqlstringa:=sqlstringa||' NULL AS T, ';
    sqlstringa:=sqlstringa||' T.LT_ID, ';
    sqlstringa:=sqlstringa||' ''[[''||LI_G.X||'',''|| LI_G.Y ||''],[''|| LF_G.X ||'',''|| LF_G.Y||'']]'' coord_punti, ';
    sqlstringa:=sqlstringa||' LI_W.LO_DESCRIZIONE         AS DscLocIni40, ';
    sqlstringa:=sqlstringa||' LF_W.LO_DESCRIZIONE         AS DscLocFin40, ';
    sqlstringa:=sqlstringa||  n_zoom||' AS Liv, ';
    --10/08/2018 modificata per gestire lo stile tratteggiato delle tratte Link
    sqlstringa:=sqlstringa||' DECODE(s.SEDE_TECNICA, NULL,''NoData'',tipo_sol) As Info ';
    sqlstringa:=sqlstringa||' FROM ';
    sqlstringa:=sqlstringa||' RINF_GIS_EVO.TRAT_RETE T,  ';
    sqlstringa:=sqlstringa||' RINF_GIS_EVO.LOCA_RETE LI_W, ';
    sqlstringa:=sqlstringa||' RINF_GIS_EVO.LOCA_RETE LF_W, ';
    sqlstringa:=sqlstringa||' TABLE(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_START_PT(t.GEOMETRY))) LI_G, ';
    sqlstringa:=sqlstringa||' TABLE(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_END_PT(t.GEOMETRY))) LF_G, ';
    sqlstringa:=sqlstringa||' (SELECT SEDE_TECNICA,DECODE(SOL_1_1_0_0_0_6,''R'',''Regular'',''L'',''Link'') tipo_sol FROM '|| s_schema||'.SEZIONI_LINEA  ';
    IF p_versione IS NOT NULL THEN
        sqlstringa:=sqlstringa||' WHERE CODICE_VERSIONE='||p_versione;
    END IF;
    sqlstringa:=sqlstringa||' ) s ';
    sqlstringa:=sqlstringa||' WHERE ';
    sqlstringa:=sqlstringa||' T.TR_ORIG = LI_W.OR_ID and ';
    sqlstringa:=sqlstringa||' T.TR_DEST = LF_W.OR_ID and  ';
    sqlstringa:=sqlstringa||' T.VERSIONE_MDR = '||n_versione_mdr||'  and  ';
    sqlstringa:=sqlstringa||' T.VERSIONE_MDR = LI_W.VERSIONE_MDR and ';
    sqlstringa:=sqlstringa||' T.VERSIONE_MDR = LF_W.VERSIONE_MDR and ';
    sqlstringa:=sqlstringa||' T.OR_ID = s.SEDE_TECNICA (+) and ';
    sqlstringa:=sqlstringa||' SDO_ANYINTERACT(T.GEOMETRY,SDO_GEOMETRY(2003, 4326, NULL, SDO_ELEM_INFO_ARRAY(1, 1003, 3), SDO_ORDINATE_ARRAY('||REPLACE(TO_CHAR(xtl),',','.')||', '||REPLACE(TO_CHAR(ytl),',','.')||','|| REPLACE(TO_CHAR(xbr),',','.')||','|| REPLACE(TO_CHAR(ybr),',','.')||')))=''TRUE''';


ELSE
    sqlstringa:=' SELECT ';
    sqlstringa:=sqlstringa||' T.OR_ID AS Cod, ';
    sqlstringa:=sqlstringa||' T.TR_ORIG AS L1, ';
    sqlstringa:=sqlstringa||' T.TR_DEST AS L2, ';
    sqlstringa:=sqlstringa||' NULL AS V, ';
    sqlstringa:=sqlstringa||' NULL AS T, ';
    sqlstringa:=sqlstringa||' T.LT_ID, ';
    sqlstringa:=sqlstringa||' PKG_RINF_GIS_V2.FNC_GET_VERTEX(SDO_UTIL.SIMPLIFY(to_2d(t.GEOMETRY),1.5)) coord_punti, ';
    sqlstringa:=sqlstringa||' LI_W.LO_DESCRIZIONE         AS DscLocIni40, ';
    sqlstringa:=sqlstringa||' LF_W.LO_DESCRIZIONE         AS DscLocFin40, ';
    sqlstringa:=sqlstringa||  n_zoom ||' AS Liv, ';
    --10/08/2018 modificata per gestire lo stile tratteggiato delle tratte Link
    sqlstringa:=sqlstringa||' DECODE(s.SEDE_TECNICA, NULL,''NoData'',tipo_sol) As Info ';
    sqlstringa:=sqlstringa||' FROM ';
    sqlstringa:=sqlstringa||' RINF_GIS_EVO.TRAT_RETE T, ';
    sqlstringa:=sqlstringa||' RINF_GIS_EVO.LOCA_RETE LI_W, ';
    sqlstringa:=sqlstringa||' RINF_GIS_EVO.LOCA_RETE LF_W,         ';
    sqlstringa:=sqlstringa||' (SELECT SEDE_TECNICA,DECODE(SOL_1_1_0_0_0_6,''R'',''Regular'',''L'',''Link'') tipo_sol FROM '|| s_schema||'.SEZIONI_LINEA  ';
    IF p_versione IS NOT NULL THEN
        sqlstringa:=sqlstringa||' WHERE CODICE_VERSIONE='||p_versione;
    END IF;
    sqlstringa:=sqlstringa||' ) s ';
    sqlstringa:=sqlstringa||' WHERE ';
    sqlstringa:=sqlstringa||' T.TR_ORIG = LI_W.OR_ID and ';
    sqlstringa:=sqlstringa||' T.TR_DEST = LF_W.OR_ID and  ';
    sqlstringa:=sqlstringa||' T.VERSIONE_MDR = '||n_versione_mdr||'  and  ';
    sqlstringa:=sqlstringa||' T.VERSIONE_MDR = LI_W.VERSIONE_MDR and ';
    sqlstringa:=sqlstringa||' T.VERSIONE_MDR = LF_W.VERSIONE_MDR and ';
    sqlstringa:=sqlstringa||' T.OR_ID = s.SEDE_TECNICA (+) and ';
    sqlstringa:=sqlstringa||' SDO_ANYINTERACT(T.GEOMETRY,SDO_GEOMETRY(2003, 4326, NULL, SDO_ELEM_INFO_ARRAY(1, 1003, 3), SDO_ORDINATE_ARRAY('||REPLACE(TO_CHAR(xtl),',','.')||', '||REPLACE(TO_CHAR(ytl),',','.')||','|| REPLACE(TO_CHAR(xbr),',','.')||','|| REPLACE(TO_CHAR(ybr),',','.')||')))=''TRUE''';
END IF;
--DBMS_OUTPUT.PUT_LINE(sqlstringa);
    OPEN p_cursor FOR sqlstringa;
END SP_GEO_TRATTE;

--
-- --------------------------------------------------------------------------------------
--                           PROCEDURE SP_GEO_LOCALITA
-- --------------------------------------------------------------------------------------
--

PROCEDURE SP_GEO_LOCALITA(p_area NUMBER, p_i_versione NUMBER,xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER,p_cursor OUT empcur) IS
n_zoom number;
s_schema VARCHAR2(50);
sqlstringa VARCHAR2(5000);
p_versione NUMBER;
n_versione_mdr NUMBER;
BEGIN
select FNC_GET_ZOOM(xtl , ytl , xbr , ybr ) into n_zoom from dual;

 s_schema:=PKG_RINF_INTERFACCIA.GetSchemaName(p_area);
 p_versione:=p_i_versione;
 IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
    p_versione:=PKG_RINF_DATA_V082.GetLastVersion(p_area);
 END IF;

 --13/11/2017 Gestione storicizzazione MDR. In bese all'area dati e alla versione del registro viene visualizzato un MDR GIS diverso
 n_versione_mdr:= FNC_GET_VERSIONE_MDR(p_area,p_versione);

IF n_zoom=1 THEN
    sqlstringa:=' SELECT ';
    sqlstringa:=sqlstringa||' T.OR_ID AS Cod, ';
    sqlstringa:=sqlstringa||' T.LO_DESCRIZIONE AS NomB, ';
    sqlstringa:=sqlstringa||' NULL AS T, ';
    sqlstringa:=sqlstringa||' NULL AS P, ';
    sqlstringa:=sqlstringa||' L_G.X      AS Xwgs, ';
    sqlstringa:=sqlstringa||' L_G.Y      AS Ywgs, ';
    sqlstringa:=sqlstringa||  n_zoom ||' AS Liv, ';
    sqlstringa:=sqlstringa||' DECODE(s.SEDE_TECNICA, NULL,''FALSE'',''TRUE'') As Info ';
    sqlstringa:=sqlstringa||' FROM ';
    sqlstringa:=sqlstringa||' RINF_GIS_EVO.LOCA_RETE T, ';
    sqlstringa:=sqlstringa||' RINF_ANAGRAFICHE_EVO.LOCALITA_METALLO M,         ';
    sqlstringa:=sqlstringa||' TABLE(SDO_UTIL.GETVERTICES(T.GEOMETRY)) L_G, ';
    sqlstringa:=sqlstringa||' (SELECT SEDE_TECNICA FROM '|| s_schema||'.PUNTI_OPERATIVI  ';
    IF p_versione IS NOT NULL THEN
        sqlstringa:=sqlstringa||' WHERE CODICE_VERSIONE='||p_versione;
    END IF;
    sqlstringa:=sqlstringa||' ) s ';
    sqlstringa:=sqlstringa||' WHERE ';
    sqlstringa:=sqlstringa||' M.OR_ID=T.OR_ID and ';
    sqlstringa:=sqlstringa||' T.VERSIONE_MDR = '||n_versione_mdr||'  and  ';
    sqlstringa:=sqlstringa||' T.OR_ID=s.SEDE_TECNICA (+) and ';
    sqlstringa:=sqlstringa||' M.LOC_MET_ID=4 and ';
    sqlstringa:=sqlstringa||' SDO_ANYINTERACT(T.GEOMETRY,SDO_GEOMETRY(2003, 4326, NULL, SDO_ELEM_INFO_ARRAY(1, 1003, 3), SDO_ORDINATE_ARRAY('||REPLACE(TO_CHAR(xtl),',','.')||', '||REPLACE(TO_CHAR(ytl),',','.')||','|| REPLACE(TO_CHAR(xbr),',','.')||','|| REPLACE(TO_CHAR(ybr),',','.')||')))=''TRUE''';
ELSE

    sqlstringa:=' SELECT ';
    sqlstringa:=sqlstringa||' T.OR_ID AS Cod, ';
    sqlstringa:=sqlstringa||' T.LO_DESCRIZIONE AS NomB, ';
    sqlstringa:=sqlstringa||' NULL AS T, ';
    sqlstringa:=sqlstringa||' NULL AS P, ';
    sqlstringa:=sqlstringa||' L_G.X      AS Xwgs, ';
    sqlstringa:=sqlstringa||' L_G.Y      AS Ywgs, ';
    sqlstringa:=sqlstringa||  n_zoom ||' AS Liv, ';
    sqlstringa:=sqlstringa||' DECODE(s.SEDE_TECNICA, NULL,''FALSE'',''TRUE'') As Info ';
    sqlstringa:=sqlstringa||' FROM ';
    sqlstringa:=sqlstringa||' RINF_GIS_EVO.LOCA_RETE T, ';
    sqlstringa:=sqlstringa||' TABLE(SDO_UTIL.GETVERTICES(T.GEOMETRY)) L_G, ';
    sqlstringa:=sqlstringa||' (SELECT SEDE_TECNICA FROM '|| s_schema||'.PUNTI_OPERATIVI  ';
    IF p_versione IS NOT NULL THEN
        sqlstringa:=sqlstringa||' WHERE CODICE_VERSIONE='||p_versione;
    END IF;
    sqlstringa:=sqlstringa||' ) s ';
    sqlstringa:=sqlstringa||' WHERE ';
    sqlstringa:=sqlstringa||' T.OR_ID=s.SEDE_TECNICA (+) and ';
    sqlstringa:=sqlstringa||' T.VERSIONE_MDR = '||n_versione_mdr||'  and  ';
    sqlstringa:=sqlstringa||' SDO_ANYINTERACT(T.GEOMETRY,SDO_GEOMETRY(2003, 4326, NULL, SDO_ELEM_INFO_ARRAY(1, 1003, 3), SDO_ORDINATE_ARRAY('||REPLACE(TO_CHAR(xtl),',','.')||', '||REPLACE(TO_CHAR(ytl),',','.')||','|| REPLACE(TO_CHAR(xbr),',','.')||','|| REPLACE(TO_CHAR(ybr),',','.')||')))=''TRUE''';
END IF;
DBMS_OUTPUT.PUT_LINE(sqlstringa);
OPEN p_cursor FOR sqlstringa;
END SP_GEO_LOCALITA;

/*******************************************************************************
PROCEDURE SP_GET_CENTER(p_identificativo VARCHAR2,p_cursor OUT empcur) IS
l_opstart varchar2(7);
l_opend varchar2(7);
l_sodid varchar2(500);
BEGIN
    IF p_identificativo like 'LO%' THEN
        OPEN p_cursor FOR
            SELECT
                    L_G.X      AS Xwgs,
                    L_G.Y      AS Ywgs
                FROM
                    RINF_ANAGRAFICHE_EVO.LOCA_RETE T,
                    TABLE(SDO_UTIL.GETVERTICES(T.GEOMETRY)) L_G
                WHERE
                    T.OR_ID = p_identificativo;
    ELSIF p_identificativo like 'TR%' THEN

        OPEN p_cursor FOR
        SELECT
                L_G.X      AS Xwgs,
                L_G.Y      AS Ywgs
            FROM
                RINF_ANAGRAFICHE_EVO.TRAT_RETE T,
                TABLE(SDO_UTIL.GETVERTICES(SDO_GEOM.SDO_MBR(SDO_GEOM.SDO_BUFFER(T.geometry,100,0.005)))) L_G
            WHERE
                T.OR_ID=p_identificativo;
    END IF;
END SP_GET_CENTER;

PROCEDURE SP_ALL_TRATTE_SIMPLY(p_cursor OUT empcur) IS

BEGIN

    OPEN p_cursor FOR
    SELECT
            T.OR_ID AS Cod,
            T.TR_ORIG AS L1,
            T.TR_DEST AS L2,
            '[['||LI_G.X||','|| LI_G.Y ||'],['|| LF_G.X ||','|| LF_G.Y||']]' coord_punti
        FROM
            RINF_ANAGRAFICHE_EVO.TRAT_RETE T,
            RINF_ANAGRAFICHE_EVO.LOCA_RETE LI_W,
            RINF_ANAGRAFICHE_EVO.LOCA_RETE LF_W,
            TABLE(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_START_PT(t.GEOMETRY))) LI_G,
            TABLE(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_END_PT(t.GEOMETRY))) LF_G

        WHERE
            T.TR_ORIG = LI_W.OR_ID and
            T.TR_DEST = LF_W.OR_ID;
END SP_ALL_TRATTE_SIMPLY;

PROCEDURE SP_ALL_LOCALITA(p_cursor OUT empcur) IS
BEGIN

OPEN p_cursor FOR
SELECT
        T.OR_ID AS Cod,
        L_G.X      AS Xwgs,
        L_G.Y      AS Ywgs
    FROM
        RINF_ANAGRAFICHE_EVO.LOCA_RETE T,
        TABLE(SDO_UTIL.GETVERTICES(T.GEOMETRY)) L_G;
END SP_ALL_LOCALITA;

PROCEDURE SP_ALL_LINEE_SIMPLY(p_cursor OUT empcur) IS

BEGIN

    OPEN p_cursor FOR
    SELECT
            L.LT_ID AS Cod,
            NULL AS L1,
            NULL AS L2,
            FNC_GET_VERTEX(L.aggr_geom) coord_punti
        FROM
        ( SELECT lt_id, sdo_aggr_union(sdoaggrtype(tratte.geometry,0.5)) aggr_geom
            FROM
            (select LT_ID,OR_ID,
            mdsys.SDO_GEOMETRY (2002,
                                            4326,
                                            NULL,
                                            MDSYS.SDO_ELEM_INFO_ARRAY (1, 2, 1),
                                            MDSYS.SDO_ORDINATE_ARRAY (li_g.x,
                                                                      li_g.y,
                                                                      lf_g.x,
                                                                      lf_g.y)) geometry
            from RINF_ANAGRAFICHE_EVO.TRAT_RETE t,
            TABLE(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_START_PT(t.GEOMETRY))) LI_G,
            TABLE(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_END_PT(t.GEOMETRY))) LF_G) tratte
            WHERE LT_ID<>'NOASS'
            group by lt_id) L;
END SP_ALL_LINEE_SIMPLY;
*******************************************************************************/

--
-- --------------------------------------------------------------------------------------
--                             PROCEDURE SP_GEO_SOLList
-- --------------------------------------------------------------------------------------
--

 PROCEDURE SP_GEO_SOLList(p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2, xtl NUMBER, ytl NUMBER, xbr NUMBER, ybr NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
     p_sol_cur empcur;
     l_SOL_List   LIST_OF_SEDE_TECNICA_t;
     n_zoom NUMBER;
     n_versione_mdr NUMBER;
	 v_area    NUMBER;
     p_versione NUMBER;

 BEGIN
     Select FNC_GET_ZOOM(xtl, ytl, xbr, ybr ) Into n_zoom From dual;

     p_versione := p_i_versione;
	 v_area := p_area;
--
     If (v_area = 2 Or v_area = 4) And p_versione Is Null Then
           p_versione := PKG_RINF_DATA_V082.GetLastVersion(v_area);
	 ElsIf v_area is Null Then 
	       v_area := 1;
     End If;
--
     PKG_RINF_INTERFACCIA.GetSOLList(p_contesto, v_area, p_filtro, p_versione, p_sol_cur );
--
     If p_sol_cur%isopen Then
          Fetch p_sol_cur Bulk Collect Into l_SOL_List;
     End If;
--
     Close p_sol_cur;

-- 13/11/2017 Gestione storicizzazione MDR. In bese all'area dati e alla versione del registro viene visualizzato un MDR GIS diverso
     n_versione_mdr := FNC_GET_VERSIONE_MDR(v_area,p_versione);

    If n_zoom = 1 Then
         Open p_cursor For
            Select
            p_filtro ID_RICERCA,
            T.OR_ID As Cod,
            T.TR_ORIG As L1,
            T.TR_DEST As L2,
            '[['||LI_G.X||','|| LI_G.Y ||'],['|| LF_G.X ||','|| LF_G.Y||']]' coord_punti,
            LI_W.LO_DESCRIZIONE         As DscLocIni40,
            LF_W.LO_DESCRIZIONE         As DscLocFin40
            From
            Rinf_Gis_Evo.TRAT_RETE T,
            Rinf_Gis_Evo.LOCA_RETE LI_W,
            Rinf_Gis_Evo.LOCA_RETE LF_W,
            Table(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_START_PT(t.GEOMETRY))) LI_G,
            Table(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_END_PT(t.GEOMETRY))) LF_G
--
        Where
            T.TR_ORIG = LI_W.OR_ID and
            T.TR_DEST = LF_W.OR_ID and
            T.VERSIONE_MDR= n_versione_mdr and
            T.VERSIONE_MDR= LI_W.VERSIONE_MDR and
            T.VERSIONE_MDR= LF_W.VERSIONE_MDR and
            T.OR_ID In (Select * From Table(l_SOL_List)) and
            SDO_ANYINTERACT(T.GEOMETRY,SDO_GEOMETRY(2003, 4326, NULL, SDO_ELEM_INFO_ARRAY(1, 1003, 3), SDO_ORDINATE_ARRAY(xtl, ytl, xbr, ybr)))='TRUE';
     Else
         Open p_cursor For
            Select
            p_filtro ID_RICERCA,
            T.OR_ID As Cod,
            T.TR_ORIG As L1,
            T.TR_DEST As L2,
            FNC_GET_VERTEX(SDO_UTIL.SIMPLIFY(to_2d(t.GEOMETRY),1.5)) coord_punti,
            LI_W.LO_DESCRIZIONE         As DscLocIni40,
            LF_W.LO_DESCRIZIONE         As DscLocFin40
            From
            Rinf_Gis_Evo.TRAT_RETE T,
            Rinf_Gis_Evo.LOCA_RETE LI_W,
            Rinf_Gis_Evo.LOCA_RETE LF_W,
            Table(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_START_PT(t.GEOMETRY))) LI_G,
            Table(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_END_PT(t.GEOMETRY))) LF_G

        Where
            T.TR_ORIG = LI_W.OR_ID and
            T.TR_DEST = LF_W.OR_ID and
            T.VERSIONE_MDR= n_versione_mdr and
            T.VERSIONE_MDR= LI_W.VERSIONE_MDR and
            T.VERSIONE_MDR= LF_W.VERSIONE_MDR and
            T.OR_ID In (Select * From Table(l_SOL_List)) and
            SDO_ANYINTERACT(T.GEOMETRY,SDO_GEOMETRY(2003, 4326, NULL, SDO_ELEM_INFO_ARRAY(1, 1003, 3), SDO_ORDINATE_ARRAY(xtl, ytl, xbr, ybr)))='TRUE';
     End If;

END SP_GEO_SOLList;

--
-- --------------------------------------------------------------------------------------
--                              PROCEDURE SP_GEO_OPList
-- --------------------------------------------------------------------------------------
--

PROCEDURE SP_GEO_OPList(p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2,p_i_versione NUMBER,p_cursor OUT empcur) IS
p_op_cur empcur;
l_OP_List LIST_OF_SEDE_TECNICA_t;
n_versione_mdr NUMBER;
p_versione NUMBER;
BEGIN

 p_versione:=p_i_versione;
  IF (p_area=2 OR p_area=4) AND p_versione IS NULL THEN
 p_versione:=PKG_RINF_DATA_V082.GetLastVersion(p_area);
 END IF;

PKG_RINF_INTERFACCIA.GetOPList(p_contesto , p_area , p_filtro ,p_versione,p_op_cur );
IF p_op_cur%isopen    THEN
      fetch p_op_cur bulk collect into l_OP_List;
END IF;

 CLOSE p_op_cur;

  --13/11/2017 Gestione storicizzazione MDR. In bese all'area dati e alla versione del registro viene visualizzato un MDR GIS diverso
 n_versione_mdr := FNC_GET_VERSIONE_MDR(p_area,p_versione);

OPEN p_cursor FOR
        SELECT
        p_filtro ID_RICERCA,
        T.OR_ID AS Cod,
        T.LO_DESCRIZIONE                           AS NomL,
        T.LO_DESCRIZIONE                           AS NomB,
        L_G.X      AS Xwgs,
        L_G.Y      AS Ywgs
    FROM
        RINF_GIS_EVO.LOCA_RETE T,
        TABLE(SDO_UTIL.GETVERTICES(T.GEOMETRY)) L_G

    WHERE
    T.VERSIONE_MDR= n_versione_mdr and
    T.OR_ID IN (select * from TABLE(l_OP_List));

END SP_GEO_OPList;

--
-- --------------------------------------------------------------------------------------
--                               PROCEDURE SP_GEO_CONTEST_CENTER
-- --------------------------------------------------------------------------------------
--

PROCEDURE SP_GEO_CONTEST_CENTER(p_contesto NUMBER, p_area NUMBER, p_filtro VARCHAR2,p_i_versione NUMBER,p_cursor OUT empcur) IS
p_sol_cur empcur;
l_SOL_List LIST_OF_SEDE_TECNICA_t;
n_versione_mdr NUMBER;
BEGIN
PKG_RINF_INTERFACCIA.GetSOLList(p_contesto , p_area , p_filtro ,p_i_versione,p_sol_cur );
IF p_sol_cur%isopen    THEN
      fetch p_sol_cur bulk collect into l_SOL_List;
END IF;

 CLOSE p_sol_cur;

 --13/11/2017 Gestione storicizzazione MDR. In bese all'area dati e alla versione del registro viene visualizzato un MDR GIS diverso
 n_versione_mdr := FNC_GET_VERSIONE_MDR(p_area,p_i_versione);

OPEN p_cursor FOR
    SELECT
            p_filtro ID_RICERCA,
            SDO_GEOM.SDO_MIN_MBR_ORDINATE(SDO_AGGR_MBR(t.GEOMETRY),1) X1,
            SDO_GEOM.SDO_MIN_MBR_ORDINATE(SDO_AGGR_MBR(t.GEOMETRY),2) Y1,
             SDO_GEOM.SDO_MAX_MBR_ORDINATE(SDO_AGGR_MBR(t.GEOMETRY),1) X2,
            SDO_GEOM.SDO_MAX_MBR_ORDINATE(SDO_AGGR_MBR(t.GEOMETRY),2) Y2

        FROM
            RINF_GIS_EVO.TRAT_RETE T

        WHERE
        T.VERSIONE_MDR= n_versione_mdr and
        T.OR_ID IN (select * from TABLE(l_SOL_List));

END SP_GEO_CONTEST_CENTER;

--
-- --------------------------------------------------------------------------------------
--                            PROCEDURE SP_SET_VERSIONE_MD
-- --------------------------------------------------------------------------------------
--

PROCEDURE SP_SET_VERSIONE_MDR( p_area NUMBER,p_i_versione NUMBER,p_error OUT NUMBER) IS

--10/11/2017
--Questa procedura mantiene la relazione del MDR GIS con il registro presente nelle quattro aree
BEGIN
p_error:=0;
--Controllati/Corretti
CASE WHEN p_area=1 THEN

    Delete FROM RINF_GIS_EVO.MDR_REGISTRO where CODICE_AREA=1;
    Insert into RINF_GIS_EVO.MDR_REGISTRO(VERSIONE_MDR, CODICE_AREA, CODICE_VERSIONE)
    Select MAX(VERSIONE_MDR),1,0  FROM RINF_GIS_EVO.ANAG_MDR;
--Richiesta Autorizzazioni
WHEN p_area=3 THEN
  --In via precauzionale, perchè non ci dovrebbe essere alcuna occorrenza per questa area
  Delete FROM RINF_GIS_EVO.MDR_REGISTRO where CODICE_AREA=3;
  --Inserisco la stessa versione del MDR dell'area Controllati/Corretti
  Insert into RINF_GIS_EVO.MDR_REGISTRO(VERSIONE_MDR, CODICE_AREA, CODICE_VERSIONE)
    Select VERSIONE_MDR, 3, CODICE_VERSIONE  FROM RINF_GIS_EVO.MDR_REGISTRO where CODICE_AREA=1;
--Pronti
WHEN p_area=4 THEN
--Inserisco la stessa versione del MDR dell'area Richiesta Autorizzazioni
   Insert into RINF_GIS_EVO.MDR_REGISTRO(VERSIONE_MDR, CODICE_AREA, CODICE_VERSIONE)
    Select VERSIONE_MDR, 4, p_i_versione  FROM RINF_GIS_EVO.MDR_REGISTRO where CODICE_AREA=3;
--Elimino l'associazione dell'area Richiesta Autorizzazioni perchè questa a valle della Dichiarazione del Pronti viene svuotata
   Delete FROM RINF_GIS_EVO.MDR_REGISTRO where CODICE_AREA=3;
--Pubblicati/Inviati
WHEN p_area=2 THEN
--Aggiorno l'area in corrispondenza del registro, da Pronti a Pubblicati
    Update  RINF_GIS_EVO.MDR_REGISTRO
    Set CODICE_AREA=2
    where  CODICE_VERSIONE= p_i_versione
    and CODICE_AREA=4;
END CASE;
EXCEPTION
         WHEN OTHERS
         THEN p_error := SQLCODE;
END SP_SET_VERSIONE_MDR;

--
-- --------------------------------------------------------------------------------------
--                                PROCEDURE SP_GET_CENTER
-- --------------------------------------------------------------------------------------
--

--13/11/2017 Per la gestione della storicizzazione è necessario cambiare le firme delle seguenti procedure
PROCEDURE SP_GET_CENTER(p_area NUMBER,p_i_versione NUMBER, p_identificativo VARCHAR2,p_cursor OUT empcur) IS
n_versione_mdr NUMBER;
BEGIN
--13/11/2017 Gestione storicizzazione MDR. In bese all'area dati e alla versione del registro viene visualizzato un MDR GIS diverso
 n_versione_mdr := FNC_GET_VERSIONE_MDR(p_area,p_i_versione);
 CASE WHEN p_identificativo like 'LO%' THEN
        OPEN p_cursor FOR
            SELECT
                    L_G.X      AS Xwgs,
                    L_G.Y      AS Ywgs
                FROM
                    RINF_GIS_EVO.LOCA_RETE T,
                    TABLE(SDO_UTIL.GETVERTICES(T.GEOMETRY)) L_G
                WHERE
                    T.OR_ID = p_identificativo and
                    T.VERSIONE_MDR=n_versione_mdr;
    WHEN p_identificativo like 'TR%' THEN

        OPEN p_cursor FOR
        SELECT
                L_G.X      AS Xwgs,
                L_G.Y      AS Ywgs
            FROM
                RINF_GIS_EVO.TRAT_RETE T,
                TABLE(SDO_UTIL.GETVERTICES(SDO_GEOM.SDO_MBR(SDO_GEOM.SDO_BUFFER(T.geometry,100,0.005)))) L_G
            WHERE
                T.OR_ID=p_identificativo and
                T.VERSIONE_MDR=n_versione_mdr;
    END CASE;
END SP_GET_CENTER;

--
-- --------------------------------------------------------------------------------------
--                               PROCEDURE SP_ALL_TRATTE_SIMPLY
-- --------------------------------------------------------------------------------------
--

PROCEDURE SP_ALL_TRATTE_SIMPLY(p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
n_versione_mdr NUMBER;
sqlstringa VARCHAR2(5000);
BEGIN
--13/11/2017 Gestione storicizzazione MDR. In bese all'area dati e alla versione del registro viene visualizzato un MDR GIS diverso
 n_versione_mdr := FNC_GET_VERSIONE_MDR(p_area,p_i_versione);

 OPEN p_cursor FOR
    SELECT
            T.OR_ID AS Cod,
            T.TR_ORIG AS L1,
            T.TR_DEST AS L2,
            '[['||LI_G.X||','|| LI_G.Y ||'],['|| LF_G.X ||','|| LF_G.Y||']]' coord_punti
        FROM
            RINF_GIS_EVO.TRAT_RETE T,
            RINF_GIS_EVO.LOCA_RETE LI_W,
            RINF_GIS_EVO.LOCA_RETE LF_W,
            TABLE(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_START_PT(t.GEOMETRY))) LI_G,
            TABLE(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_END_PT(t.GEOMETRY))) LF_G

        WHERE
            T.TR_ORIG = LI_W.OR_ID and
            T.TR_DEST = LF_W.OR_ID and
            T.VERSIONE_MDR=n_versione_mdr and
            T.VERSIONE_MDR=LI_W.VERSIONE_MDR and
            T.VERSIONE_MDR=LF_W.VERSIONE_MDR ;

END SP_ALL_TRATTE_SIMPLY;

--
-- --------------------------------------------------------------------------------------
--                              PROCEDURE SP_ALL_LOCALITA
-- --------------------------------------------------------------------------------------
--

PROCEDURE SP_ALL_LOCALITA(p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
n_versione_mdr NUMBER;
sqlstringa VARCHAR2(5000);
BEGIN
--13/11/2017 Gestione storicizzazione MDR. In bese all'area dati e alla versione del registro viene visualizzato un MDR GIS diverso
 n_versione_mdr := FNC_GET_VERSIONE_MDR(p_area,p_i_versione);

    OPEN p_cursor FOR
SELECT
        T.OR_ID AS Cod,
        L_G.X      AS Xwgs,
        L_G.Y      AS Ywgs
    FROM
        RINF_GIS_EVO.LOCA_RETE T,
        TABLE(SDO_UTIL.GETVERTICES(T.GEOMETRY)) L_G
        WHERE T.VERSIONE_MDR=n_versione_mdr;
END SP_ALL_LOCALITA;

--
-- --------------------------------------------------------------------------------------
--                            PROCEDURE SP_ALL_LINEE_SIMPLY
-- --------------------------------------------------------------------------------------
--

PROCEDURE SP_ALL_LINEE_SIMPLY(p_area NUMBER,p_i_versione NUMBER,p_cursor OUT empcur) IS
n_versione_mdr NUMBER;
sqlstringa VARCHAR2(5000);
BEGIN
--13/11/2017 Gestione storicizzazione MDR. In bese all'area dati e alla versione del registro viene visualizzato un MDR GIS diverso
 n_versione_mdr := FNC_GET_VERSIONE_MDR(p_area,p_i_versione);


   OPEN p_cursor FOR
    SELECT
            L.LT_ID AS Cod,
            NULL AS L1,
            NULL AS L2,
            FNC_GET_VERTEX(L.aggr_geom) coord_punti
        FROM
        ( SELECT lt_id, sdo_aggr_union(sdoaggrtype(tratte.geometry,0.5)) aggr_geom
            FROM
            (select LT_ID,OR_ID,
            mdsys.SDO_GEOMETRY (2002,
                                            4326,
                                            NULL,
                                            MDSYS.SDO_ELEM_INFO_ARRAY (1, 2, 1),
                                            MDSYS.SDO_ORDINATE_ARRAY (li_g.x,
                                                                      li_g.y,
                                                                      lf_g.x,
                                                                      lf_g.y)) geometry
            from RINF_GIS_EVO.TRAT_RETE t,
            TABLE(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_START_PT(t.GEOMETRY))) LI_G,
            TABLE(SDO_UTIL.GETVERTICES(SDO_LRS.GEOM_SEGMENT_END_PT(t.GEOMETRY))) LF_G
            WHERE t.VERSIONE_MDR=n_versione_mdr) tratte
            WHERE LT_ID<>'NOASS'
            group by lt_id) L;

    OPEN p_cursor FOR sqlstringa;
END SP_ALL_LINEE_SIMPLY;

-- -----------------
END PKG_RINF_GIS_V2;
/