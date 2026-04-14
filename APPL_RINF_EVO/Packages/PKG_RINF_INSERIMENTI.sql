--
-- PKG_RINF_INSERIMENTI  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_INSERIMENTI" AS
/******************************************************************************
   NAME:       PKG_RINF_INSERIMENTI
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/12/2016    d.campagiorni     1. Created this package.
   1.1        12/06/2020	e.petrilli					2. aggiunta la gesione delle coordinate dei punti di confine (SVI)
******************************************************************************/

TYPE empcur IS REF CURSOR;
--Confini
PROCEDURE GetConfini(p_cursor OUT empcur);
PROCEDURE SetNewConfine( p_sede_tecnica Varchar2, p_definizione Varchar2, p_unique_op_id Varchar2, p_tipo_punto Varchar2, 
                         p_latitudine   Number,   p_longitudine Number,   p_error    Out Number );
PROCEDURE SetUpdateConfine(p_sede_tecnica Varchar2, p_definizione Varchar2, p_unique_op_id Varchar2, p_tipo_punto Varchar2, 
                           p_latitudine   Number,   p_longitudine Number,   p_error    Out Number);
PROCEDURE SetDeleteConfine(p_sede_tecnica VARCHAR2,  p_error OUT NUMBER);
--Gallerie Diramate
PROCEDURE GetDiramate(p_cursor OUT empcur);
PROCEDURE SetNewDiramata (p_sede_tecnica       VARCHAR2,
                          p_binario            VARCHAR2,
                          p_lon_orig           NUMBER,
                          p_lat_orig           NUMBER,
                          p_km_orig            NUMBER,
                          p_lon_dest           NUMBER,
                          p_lat_dest           NUMBER,
                          p_km_dest            NUMBER,
                          p_error          OUT NUMBER);
PROCEDURE SetUpdateDiramata (p_sede_tecnica       VARCHAR2,
                          p_binario            VARCHAR2,
                          p_lon_orig           NUMBER,
                          p_lat_orig           NUMBER,
                          p_km_orig            NUMBER,
                          p_lon_dest           NUMBER,
                          p_lat_dest           NUMBER,
                          p_km_dest            NUMBER,
                          p_error          OUT NUMBER);
PROCEDURE SetDeleteDiramata (p_sede_tecnica       VARCHAR2,
                          p_binario            VARCHAR2,
                          p_error          OUT NUMBER);
--Raccordi
PROCEDURE GetRaccordi(p_cursor OUT empcur);
PROCEDURE SetNewRaccordo (p_unique_op_id       VARCHAR2,
                          p_definizione        VARCHAR2,
                          p_taf_tap            VARCHAR2,
                          p_tipo_punto         VARCHAR2,
                          p_latitudine         NUMBER,
                          p_longitudine        NUMBER,
                          p_localita           VARCHAR2,
                          p_tipo_racc          VARCHAR2,
                          p_error          OUT NUMBER);
PROCEDURE SetUpdateRaccordo (p_unique_op_id       VARCHAR2,
                             p_prog               NUMBER,
                             p_definizione        VARCHAR2,
                             p_taf_tap            VARCHAR2,
                             p_tipo_punto         VARCHAR2,
                             p_latitudine         NUMBER,
                             p_longitudine        NUMBER,
                             p_localita           VARCHAR2,
                             p_tipo_racc          VARCHAR2,
                             p_error          OUT NUMBER);
PROCEDURE SetDeleteRaccordo (p_unique_op_id VARCHAR2, p_prog NUMBER, p_error OUT NUMBER);
PROCEDURE SetRaccordoValidato (p_unique_op_id       VARCHAR2,
                             p_prog               NUMBER,
                             p_error          OUT NUMBER);
PROCEDURE GetReportRaccordi (p_tipo_report NUMBER, p_cursor OUT empcur);
FUNCTION GetLocaDesc (p_codice_lo VARCHAR2, p_area NUMBER, p_versione NUMBER) RETURN VARCHAR2;
FUNCTION GetLineaComm (p_codice_lo    VARCHAR2,
                       p_area         NUMBER,
                       p_versione     NUMBER)
   RETURN VARCHAR2;
PROCEDURE GetTipoPO (p_cursor OUT empcur);
PROCEDURE GetLineaComm (p_codice_lo       VARCHAR2,
                        p_area            NUMBER,
                        p_versione        NUMBER,
                        p_cursor      OUT empcur);

END PKG_RINF_INSERIMENTI;
/


--
-- PKG_RINF_INSERIMENTI  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_INSERIMENTI" IS
-- -------------------------------------------------------------------------------------------------
 PROCEDURE GetConfini(p_cursor OUT empcur) IS
 BEGIN
 OPEN p_cursor FOR
 Select SEDE_TECNICA, DEFINIZIONE, PO_1_2_0_0_0_2, PO_1_2_0_0_0_4, 
        LATITUDINE, LONGITUDINE                                         --> Aggiunte 20/06/2020
 FROM RINF_ANAGRAFICHE_EVO.LOCALITA_CONFINE;
 END GetConfini;

-- -------------------------------------------------------------------------------------------------
FUNCTION GetLocaDesc (p_codice_lo VARCHAR2, p_area NUMBER, p_versione NUMBER)
   RETURN VARCHAR2
IS
   s_desc   VARCHAR2 (100) := NULL;
BEGIN
   IF p_area = 1
   THEN
      SELECT DEFINIZIONE
        INTO s_desc
        FROM RINF_CONTROLLATI_EVO.PUNTI_OPERATIVI
       WHERE SEDE_TECNICA = p_codice_lo;
   ELSE
      SELECT DEFINIZIONE
        INTO s_desc
        FROM RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI
       WHERE SEDE_TECNICA = p_codice_lo AND CODICE_VERSIONE = p_versione;
   END IF;

   RETURN s_desc;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
END GetLocaDesc;

-- -------------------------------------------------------------------------------------------------
FUNCTION GetLineaComm (p_codice_lo    VARCHAR2,
                       p_area         NUMBER,
                       p_versione     NUMBER)
   RETURN VARCHAR2
IS
   s_desc   VARCHAR2 (100) := NULL;
BEGIN
   IF p_area = 1
   THEN
        SELECT LISTAGG (
                     REPLACE (CODICE, ' ', '')
--                  || ' - '
                  || ' / '
                  || TRIM (TO_CHAR (ROUND (KM_INIZIO, 3), '999990.999')),
                  '#')
               WITHIN GROUP (ORDER BY CODICE)
                  AS linea
          INTO s_desc
          FROM RINF_CONTROLLATI_EVO.V_MDR_LINEE_COMMERCIALI v
         WHERE v.SEDE_TECNICA = p_codice_lo
      GROUP BY v.SEDE_TECNICA;
   ELSE
        SELECT LISTAGG (
                     REPLACE (CODICE, ' ', '')
--                  || ' - '
                  || ' / '
                  || TRIM (TO_CHAR (ROUND (KM_INIZIO, 3), '999990.999')),
                  '#')
               WITHIN GROUP (ORDER BY CODICE)
                  AS linea
          INTO s_desc
          FROM RINF_PUBBLICATI_EVO.V_MDR_LINEE_COMMERCIALI v
         WHERE v.SEDE_TECNICA = p_codice_lo AND v.CODICE_VERSIONE = p_versione
      GROUP BY v.SEDE_TECNICA;
   END IF;

   RETURN s_desc;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
END GetLineaComm;
-- ------------------------------------------------------------------------------------------------
--                         PROCEDURE GetLineaComm 
-- ------------------------------------------------------------------------------------------------
--
PROCEDURE GetLineaComm (p_codice_lo       VARCHAR2,
                        p_area            NUMBER,
                        p_versione        NUMBER,
                        p_cursor      OUT empcur)
IS
BEGIN
   IF p_area = 1
   THEN
      OPEN p_cursor FOR
           SELECT LISTAGG (
                        REPLACE (CODICE, ' ', '')
-->                     || ' - '
                     || ' / '
                     || TRIM (TO_CHAR (ROUND (KM_INIZIO, 3), '999990.999')),
                     '#')
                  WITHIN GROUP (ORDER BY CODICE)
                     AS linea
             FROM RINF_CONTROLLATI_EVO.V_MDR_LINEE_COMMERCIALI v
            WHERE v.SEDE_TECNICA = p_codice_lo
         GROUP BY v.SEDE_TECNICA;
   ELSE
      OPEN p_cursor FOR
           SELECT LISTAGG (
                        REPLACE (CODICE, ' ', '')
-->                     || ' - '
                     || ' / '
                     || TRIM (TO_CHAR (ROUND (KM_INIZIO, 3), '999990.999')),
                     '#')
                  WITHIN GROUP (ORDER BY CODICE)
                     AS linea
             FROM RINF_PUBBLICATI_EVO.V_MDR_LINEE_COMMERCIALI v
            WHERE     v.SEDE_TECNICA = p_codice_lo
                  AND v.CODICE_VERSIONE = p_versione
         GROUP BY v.SEDE_TECNICA;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      OPEN p_cursor FOR SELECT '0000 - 0.000' linea FROM DUAL;
END GetLineaComm;
--
-- ------------------------------------------------------------------------------------------------
--                         PROCEDURE SetNewConfine
-- ------------------------------------------------------------------------------------------------
--
 PROCEDURE SetNewConfine(p_sede_tecnica Varchar2, 
                         p_definizione  Varchar2, 
					     p_unique_op_id Varchar2, 
					     p_tipo_punto   Varchar2, 
					     p_latitudine   Number,
					     p_longitudine  Number,					
					     p_error    Out Number) Is
 BEGIN
   p_error:=0;
--
   insert into RINF_ANAGRAFICHE_EVO.LOCALITA_CONFINE
             ( SEDE_TECNICA, DEFINIZIONE, PO_1_2_0_0_0_2, PO_1_2_0_0_0_4, LATITUDINE, LONGITUDINE )
      values ( p_sede_tecnica, p_definizione, p_unique_op_id, p_tipo_punto, p_latitudine, p_longitudine );

 EXCEPTION
      When OTHERS Then
           p_error := SQLCODE;
 END SetNewConfine;
--
-- -------------------------------------------------------------------------------------------------
--                       PROCEDURE SetUpdateConfine
-- -------------------------------------------------------------------------------------------------
 PROCEDURE SetUpdateConfine(p_sede_tecnica Varchar2,
                            p_definizione  Varchar2,
							p_unique_op_id Varchar2,
							p_tipo_punto   Varchar2, 
							p_latitudine   Number,
					        p_longitudine  Number,					
							p_error    Out Number) Is
 BEGIN
   p_error:=0;
--
   Update RINF_ANAGRAFICHE_EVO.LOCALITA_CONFINE
      Set
          DEFINIZIONE    = p_definizione,
		  PO_1_2_0_0_0_2 = p_unique_op_id,
		  PO_1_2_0_0_0_4 = p_tipo_punto,
		  LATITUDINE     = p_latitudine, 
		  LONGITUDINE    = p_longitudine
    Where SEDE_TECNICA   = p_sede_tecnica;
--
 EXCEPTION
      When OTHERS Then
           p_error := SQLCODE;
 END SetUpdateConfine;
--
-- -------------------------------------------------------------------------------------------------
--                      PROCEDURE SetDeleteConfine
-- -------------------------------------------------------------------------------------------------
--
 PROCEDURE SetDeleteConfine(p_sede_tecnica VARCHAR2,  p_error OUT NUMBER) IS
 BEGIN
 p_error:=0;

 DELETE FROM RINF_ANAGRAFICHE_EVO.LOCALITA_CONFINE
 WHERE
 SEDE_TECNICA=p_sede_tecnica;
 EXCEPTION
 WHEN OTHERS THEN
 p_error:= SQLCODE;
 END SetDeleteConfine;
--
-- -------------------------------------------------------------------------------------------------
--                  PROCEDURE GetDiramate
-- -------------------------------------------------------------------------------------------------
--
 PROCEDURE GetDiramate(p_cursor OUT empcur) IS
 BEGIN
 OPEN p_cursor FOR
 Select SOL_TUNNEL_1_1_1_1_8_2, SOL_TRACK_1_1_1_0_0_1,
 LONGITUDINE_ORIGINE, LATITUDINE_ORIGINE, KM_INIZIO,
 LONGITUDINE_DESTINAZIONE, LATITUDINE_DESTINAZIONE, KM_DESTINAZIONE
 FROM RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE;
 END GetDiramate;
--
-- -------------------------------------------------------------------------------------------------
--
-- -------------------------------------------------------------------------------------------------
--
PROCEDURE SetNewDiramata (p_sede_tecnica       VARCHAR2,
                          p_binario            VARCHAR2,
                          p_lon_orig           NUMBER,
                          p_lat_orig           NUMBER,
                          p_km_orig            NUMBER,
                          p_lon_dest           NUMBER,
                          p_lat_dest           NUMBER,
                          p_km_dest            NUMBER,
                          p_error          OUT NUMBER)
IS
BEGIN
   p_error := 0;

   INSERT
     INTO RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE (SOL_TUNNEL_1_1_1_1_8_2,
                                                  SOL_TRACK_1_1_1_0_0_1,
                                                  LONGITUDINE_ORIGINE,
                                                  LATITUDINE_ORIGINE,
                                                  KM_INIZIO,
                                                  LONGITUDINE_DESTINAZIONE,
                                                  LATITUDINE_DESTINAZIONE,
                                                  KM_DESTINAZIONE)
   VALUES (p_sede_tecnica,
           p_binario,
           p_lon_orig,
           p_lat_orig,
           p_km_orig,
           p_lon_dest,
           p_lat_dest,
           p_km_dest);
EXCEPTION
   WHEN OTHERS
   THEN
      p_error := SQLCODE;
END SetNewDiramata;
--
-- -------------------------------------------------------------------------------------------------
--
-- -------------------------------------------------------------------------------------------------
--
PROCEDURE SetUpdateDiramata (p_sede_tecnica       VARCHAR2,
                          p_binario            VARCHAR2,
                          p_lon_orig           NUMBER,
                          p_lat_orig           NUMBER,
                          p_km_orig            NUMBER,
                          p_lon_dest           NUMBER,
                          p_lat_dest           NUMBER,
                          p_km_dest            NUMBER,
                          p_error          OUT NUMBER)
IS
BEGIN
   p_error := 0;

UPDATE RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE
    SET
    LONGITUDINE_ORIGINE        =  p_lon_orig,
    LATITUDINE_ORIGINE              =  p_lat_orig,
    KM_INIZIO                       =  p_km_orig,
    LONGITUDINE_DESTINAZIONE        =  p_lon_dest,
    LATITUDINE_DESTINAZIONE         =  p_lat_dest,
    KM_DESTINAZIONE                 =  p_km_dest
WHERE
SOL_TUNNEL_1_1_1_1_8_2=p_sede_tecnica and
SOL_TRACK_1_1_1_0_0_1=p_binario;
EXCEPTION
   WHEN OTHERS
   THEN
      p_error := SQLCODE;
END SetUpdateDiramata;
PROCEDURE SetDeleteDiramata (p_sede_tecnica       VARCHAR2,
                          p_binario            VARCHAR2,
                          p_error          OUT NUMBER)
IS
BEGIN
   p_error := 0;

DELETE FROM RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE
WHERE
SOL_TUNNEL_1_1_1_1_8_2=p_sede_tecnica and
SOL_TRACK_1_1_1_0_0_1=p_binario;
EXCEPTION
   WHEN OTHERS
   THEN
      p_error := SQLCODE;
END SetDeleteDiramata;

-- -------------------------------------------------------------------------------------------------
PROCEDURE GetTipoPO (p_cursor OUT empcur)
IS
BEGIN
   OPEN p_cursor FOR
      SELECT rownum id, CODIFICA_VALORE
        FROM RINF_ANAGRAFICHE_EVO.DOMINIO_PARAMETRO d,
             RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI c
       WHERE     d.CODICE_PARAMETRO = c.CODICE_PARAMETRO
             AND c.NUMERO_PARAMETRO = '1.2.0.0.0.4';
END GetTipoPO;
--
-- -----------------------------------------------------------------------------
--  GetRaccordi
-- -----------------------------------------------------------------------------
PROCEDURE GetRaccordi (p_cursor OUT empcur)
IS
BEGIN
   --28/01/2019 (modifica per la visualizzazione di LAT/LONG secondo gli standard [00.00000]/[+00.00000]
   OPEN p_cursor FOR
      --Selezionoi raccordi "Validati" che sono associati ad un registro
     SELECT r.PO_1_2_0_0_0_2 PO_1_2_0_0_0_2_RAC,
             r.PROG,
             PO_1_2_0_0_0_1_DEFINIZIONE PO_1_2_0_0_0_1_RAC,
             PO_1_2_0_0_0_3 PO_1_2_0_0_0_3_RAC,
             r.PO_1_2_0_0_0_4 PO_1_2_0_0_0_4_RAC,
--             nvl(to_char(PO_1_2_0_0_0_5_LATITUDINE,'900.99999'), '00.00000') PO_1_2_0_0_0_5_LAT_RAC,
--             '+'||trim(nvl(to_char(PO_1_2_0_0_0_5_LONGITUDINE,'900.99999'), '00.00000')) PO_1_2_0_0_0_5_LONG_RAC,
             PO_1_2_0_0_0_5_LATITUDINE PO_1_2_0_0_0_5_LAT_RAC,
             PO_1_2_0_0_0_5_LONGITUDINE PO_1_2_0_0_0_5_LONG_RAC,
--eliminato il campo della chilometrica PO_1_2_0_0_0_6_KM_RAC,il valore collassa in un unico campo della linea, ereditato dalla località di riferimento
             NVL(TRIM(PKG_RINF_INSERIMENTI.GetLineaComm(LOCALITA_RIFERIMENTO, DECODE(V.PO_1_2_0_0_0_2,NULL,1,2),v.CODICE_VERSIONE)),'0000 / 0.000') PO_1_2_0_0_0_6_LINEA_RAC,
             LOCALITA_RIFERIMENTO LOCA_RAC,
             TIPOLOGIA_RACCORDO TIPO_RAC,
             PKG_RINF_INSERIMENTI.GetLocaDesc(LOCALITA_RIFERIMENTO, DECODE(V.PO_1_2_0_0_0_2,NULL,1,2),v.CODICE_VERSIONE) DESC_LOCA_RAC,
             r.CODICE_STATO,
             s.DESCRIZIONE STATO,
             DATA_MODIFICA,
             CASE WHEN i.n_ins=0 THEN 1
             ELSE 0
             END FLAG_MODIFICA
        FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI r,
             RINF_ANAGRAFICHE_EVO.ANAG_STATO_RACCORDO s,
             (  SELECT PO_1_2_0_0_0_2,
                       PROG,
                       MAX (CODICE_VERSIONE) CODICE_VERSIONE
                  FROM RINF_ANAGRAFICHE_EVO.RACCORDI_REGISTRO
              GROUP BY PO_1_2_0_0_0_2, PROG) v,
             (  SELECT PO_1_2_0_0_0_2, MAX (PROG) PROG
                  FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
                 WHERE CODICE_STATO = 2
              GROUP BY PO_1_2_0_0_0_2) h,
              (Select PO_1_2_0_0_0_2, COUNT(*) n_ins
                  FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
                 WHERE CODICE_STATO = 1
                 GROUP BY PO_1_2_0_0_0_2) i
       WHERE     r.CODICE_STATO = s.CODICE_STATO
             AND V.PO_1_2_0_0_0_2 (+)= R.PO_1_2_0_0_0_2
             AND v.PROG (+)= r.PROG
             AND h.PO_1_2_0_0_0_2 = R.PO_1_2_0_0_0_2
             AND h.PROG = r.PROG
             AND R.PO_1_2_0_0_0_2=i.PO_1_2_0_0_0_2 (+)
      --Selezionoi i raccordi "Inserito"
      UNION
      SELECT r.PO_1_2_0_0_0_2 PO_1_2_0_0_0_2_RAC,
             r.PROG,
             PO_1_2_0_0_0_1_DEFINIZIONE PO_1_2_0_0_0_1_RAC,
             PO_1_2_0_0_0_3 PO_1_2_0_0_0_3_RAC,
             r.PO_1_2_0_0_0_4 PO_1_2_0_0_0_4_RAC,
--             nvl(to_char(PO_1_2_0_0_0_5_LATITUDINE,'900.99999'), '00.00000') PO_1_2_0_0_0_5_LAT_RAC,
--             '+'||trim(nvl(to_char(PO_1_2_0_0_0_5_LONGITUDINE,'900.99999'), '00.00000')) PO_1_2_0_0_0_5_LONG_RAC,
             PO_1_2_0_0_0_5_LATITUDINE PO_1_2_0_0_0_5_LAT_RAC,
             PO_1_2_0_0_0_5_LONGITUDINE PO_1_2_0_0_0_5_LONG_RAC,
             NVL(TRIM(PKG_RINF_INSERIMENTI.GetLineaComm(LOCALITA_RIFERIMENTO,1,NULL)),'0000 / 0.000') PO_1_2_0_0_0_6_LINEA_RAC,
             LOCALITA_RIFERIMENTO LOCA_RAC,
             TIPOLOGIA_RACCORDO TIPO_RAC,
             DEFINIZIONE DESC_LOCA_RAC,
             r.CODICE_STATO,
             s.DESCRIZIONE STATO,
             DATA_MODIFICA,
             1 FLAG_MODIFICA
        FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI r,
             RINF_ANAGRAFICHE_EVO.ANAG_STATO_RACCORDO s,
             RINF_CONTROLLATI_EVO.PUNTI_OPERATIVI p
       WHERE     SEDE_TECNICA (+)= LOCALITA_RIFERIMENTO
             AND r.CODICE_STATO = s.CODICE_STATO
             AND r.CODICE_STATO IN (1)
             AND (r.PO_1_2_0_0_0_2, r.PROG) IN
                    (SELECT PO_1_2_0_0_0_2, PROG
                       FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
                     MINUS
                     SELECT PO_1_2_0_0_0_2, PROG
                       FROM RINF_ANAGRAFICHE_EVO.RACCORDI_REGISTRO)
      ORDER BY 1, 2 ASC, 12 DESC;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      OPEN p_cursor FOR
         'Select  NULL PO_1_2_0_0_0_2_RAC, NULL PROG, NULL PO_1_2_0_0_0_1_RAC, NULL PO_1_2_0_0_0_3_RAC, NULL PO_1_2_0_0_0_4_RAC, NULL PO_1_2_0_0_0_5_LAT_RAC, NULL PO_1_2_0_0_0_5_LONG_RAC, NULL PO_1_2_0_0_0_6_LINEA_RAC,  NULL LOCA_RAC, NULL TIPO_RAC, NULL DESC_LOCA_RAC, NULL CODICE_STATO, NULL STATO, NULL DATA_MODIFICA from dual';
END GetRaccordi;

-- -----------------------------------------------------------------------------
-- SetNewRaccordo
-- -----------------------------------------------------------------------------
PROCEDURE SetNewRaccordo (p_unique_op_id       VARCHAR2,
                          p_definizione        VARCHAR2,
                          p_taf_tap            VARCHAR2,
                          p_tipo_punto         VARCHAR2,
                          p_latitudine         NUMBER,
                          p_longitudine        NUMBER,
                          p_localita           VARCHAR2,
                          p_tipo_racc          VARCHAR2,
                          p_error          OUT NUMBER)
IS
   n_prog   NUMBER;
BEGIN
   p_error := 0;

--Verifico che non sia presente già un raccordo con stato "Inserito"
    SELECT COUNT(*)
     INTO n_prog
     FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
    WHERE PO_1_2_0_0_0_2 = p_unique_op_id
    AND CODICE_STATO=1;

IF n_prog=0 THEN

   SELECT NVL (MAX (PROG), 0) + 1
     INTO n_prog
     FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
    WHERE PO_1_2_0_0_0_2 = p_unique_op_id;

   INSERT
     INTO RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI (PO_1_2_0_0_0_2,
                                              PROG,
                                              PO_1_2_0_0_0_1_DEFINIZIONE,
                                              PO_1_2_0_0_0_3,
                                              PO_1_2_0_0_0_4,
                                              PO_1_2_0_0_0_5_LATITUDINE,
                                              PO_1_2_0_0_0_5_LONGITUDINE,
                                              LOCALITA_RIFERIMENTO,
                                              TIPOLOGIA_RACCORDO,
                                              CODICE_STATO,
                                              DATA_MODIFICA,
                                              DATA_MODIFICA_STATO)
   VALUES (p_unique_op_id,
           n_prog,
           p_definizione,
           NVL(p_taf_tap,'NYA'),
           p_tipo_punto,
           p_latitudine,
           p_longitudine,
           p_localita,
           p_tipo_racc,
           1,
           SYSDATE,
           null);
ELSE
--Se esiste già un record nello stato inserito, ritorna p_error=1
p_error:=n_prog;
END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      p_error := SQLCODE;
END SetNewRaccordo;

-- -------------------------------------------------------------------------------------------------
PROCEDURE SetUpdateRaccordo (p_unique_op_id       VARCHAR2,
                             p_prog               NUMBER,
                             p_definizione        VARCHAR2,
                             p_taf_tap            VARCHAR2,
                             p_tipo_punto         VARCHAR2,
                             p_latitudine         NUMBER,
                             p_longitudine        NUMBER,
                             p_localita           VARCHAR2,
                             p_tipo_racc          VARCHAR2,
                             p_error          OUT NUMBER)
IS
   n_stato   NUMBER;
BEGIN
   p_error := 0;

   SELECT CODICE_STATO
     INTO n_stato
     FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
    WHERE PO_1_2_0_0_0_2 = p_unique_op_id AND PROG = p_prog;

   --Se lo stato è "Inserito"

   IF n_stato = 1
   THEN
      UPDATE RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
         SET PO_1_2_0_0_0_1_DEFINIZIONE = p_definizione,
             PO_1_2_0_0_0_3 = NVL(p_taf_tap,'NYA'),                --p_taf_tap,   modifica del 20181005 per gestire il NULL
             PO_1_2_0_0_0_4 = p_tipo_punto,
             PO_1_2_0_0_0_5_LATITUDINE = p_latitudine,
             PO_1_2_0_0_0_5_LONGITUDINE = p_longitudine,
             LOCALITA_RIFERIMENTO = p_localita,
             TIPOLOGIA_RACCORDO = p_tipo_racc,
             DATA_MODIFICA=SYSDATE
       WHERE PO_1_2_0_0_0_2 = p_unique_op_id
       AND PROG=p_prog;
   ELSE
   --Se lo stato è "Validato" inserisco una nuova occorrenza incrementando il PROG e impostando lo stato ad "Inserito"
      INSERT
        INTO RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI (PO_1_2_0_0_0_2,
                                                 PROG,
                                                 PO_1_2_0_0_0_1_DEFINIZIONE,
                                                 PO_1_2_0_0_0_3,
                                                 PO_1_2_0_0_0_4,
                                                 PO_1_2_0_0_0_5_LATITUDINE,
                                                 PO_1_2_0_0_0_5_LONGITUDINE,
                                                 LOCALITA_RIFERIMENTO,
                                                 TIPOLOGIA_RACCORDO,
                                                 CODICE_STATO,
                                                 DATA_MODIFICA,
                                                 DATA_MODIFICA_STATO)
      VALUES (p_unique_op_id,
              p_prog + 1,
              p_definizione,
              NVL(p_taf_tap,'NYA'),                       --p_taf_tap,   modifica del 20181005 per gestire il NULL
              p_tipo_punto,
              p_latitudine,
              p_longitudine,
              p_localita,
              p_tipo_racc,
              1,
              SYSDATE,
              NULL);
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      p_error := SQLCODE;
END SetUpdateRaccordo;

-- -------------------------------------------------------------------------------------------------
PROCEDURE SetDeleteRaccordo (p_unique_op_id       VARCHAR2,
                             p_prog               NUMBER,
                             p_error          OUT NUMBER)
IS
   n_stato   NUMBER;
BEGIN
   p_error := 0;

   SELECT CODICE_STATO
     INTO n_stato
     FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
    WHERE PO_1_2_0_0_0_2 = p_unique_op_id AND PROG = p_prog;

   --Elimino i Raccordi che sono in stato "Inserito"
   DELETE FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
         WHERE PO_1_2_0_0_0_2 = p_unique_op_id AND CODICE_STATO = 1;

   --Se sto eliminando un raccordo in stato Validato devo eliminare tutte le versioni validate del raccordo
   IF n_stato = 2
   THEN
      --Aggiorno lo in "Eliminato" per i raccordi in "Validato"
      UPDATE RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
         SET CODICE_STATO = 3, DATA_MODIFICA_STATO = SYSDATE
       WHERE PO_1_2_0_0_0_2 = p_unique_op_id AND CODICE_STATO = 2;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      p_error := SQLCODE;
END SetDeleteRaccordo;

-- -------------------------------------------------------------------------------------------------
PROCEDURE SetRaccordoValidato (p_unique_op_id       VARCHAR2,
                             p_prog               NUMBER,
                             p_error          OUT NUMBER)
IS
   n_stato   NUMBER;
BEGIN
   p_error := 0;

--Modifica lo stato da Inserito a Validato e aggiorna la data di modifica

      UPDATE RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
         SET CODICE_STATO=2,
         DATA_MODIFICA=SYSDATE,
         DATA_MODIFICA_STATO=SYSDATE
       WHERE PO_1_2_0_0_0_2 = p_unique_op_id
       AND PROG=p_prog;
END SetRaccordoValidato;


-- -------------------------------------------------------------------------------------------------
PROCEDURE GetReportRaccordi (p_tipo_report NUMBER, p_cursor OUT empcur)
IS
BEGIN
--p_tipo_report= 1 per avere il report dei Raccordi Attivi
--p_tipo_report= 2 per avere il report dello Storico Raccordi

IF p_tipo_report= 1 THEN --Raccordi Attivi
   OPEN p_cursor FOR
   --Raccordi Validati che fanno aprte di un registro
      SELECT r.PO_1_2_0_0_0_2 PO_1_2_0_0_0_2_RAC,
             r.PROG,
             PO_1_2_0_0_0_1_DEFINIZIONE PO_1_2_0_0_0_1_RAC,
             PO_1_2_0_0_0_3 PO_1_2_0_0_0_3_RAC,
             r.PO_1_2_0_0_0_4 PO_1_2_0_0_0_4_RAC,
             PO_1_2_0_0_0_5_LATITUDINE PO_1_2_0_0_0_5_LAT_RAC,
             PO_1_2_0_0_0_5_LONGITUDINE PO_1_2_0_0_0_5_LONG_RAC,
             NVL(TRIM(GetLineaComm(LOCALITA_RIFERIMENTO, DECODE(m.PO_1_2_0_0_0_2,NULL,1,2),m.CODICE_VERSIONE)),'0000 / 0.000') PO_1_2_0_0_0_6_LINEA_RAC,
             LOCALITA_RIFERIMENTO LOCA_RAC,
             TIPOLOGIA_RACCORDO TIPO_RAC,
             GetLocaDesc(LOCALITA_RIFERIMENTO, DECODE(m.PO_1_2_0_0_0_2,NULL,1,2),m.CODICE_VERSIONE) DESC_LOCA_RAC,
             s.DESCRIZIONE STATO,
             CASE
                WHEN r.CODICE_STATO = 1                             --Inserito
--                                       THEN NULL
                                       THEN DATA_MODIFICA                                -- modifica del 20181002
                WHEN r.CODICE_STATO = 2                             --Validato
                                       THEN DATA_MODIFICA_STATO
                WHEN r.CODICE_STATO = 3                            --Eliminato
                                       THEN DATA_MODIFICA
             END
                DATA_VALIDAZIONE_RAC,
             CASE
                WHEN r.CODICE_STATO = 3                            --Eliminato
                                       THEN DATA_MODIFICA_STATO
                ELSE NULL
             END
                DATA_ELIMINAZIONE_RAC ,
              v.CODICE_VERSIONE REGISTRO_RAC
        FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI r,
             RINF_ANAGRAFICHE_EVO.ANAG_STATO_RACCORDO s,
             (  SELECT PO_1_2_0_0_0_2,
                       PROG,
                       MAX (CODICE_VERSIONE) CODICE_VERSIONE
                  FROM RINF_ANAGRAFICHE_EVO.RACCORDI_REGISTRO
              GROUP BY PO_1_2_0_0_0_2, PROG) m,
             (  SELECT PO_1_2_0_0_0_2,
                       PROG,
                       LISTAGG (registro || '; ')
                          WITHIN GROUP (ORDER BY r.CODICE_VERSIONE)
                          CODICE_VERSIONE
                  FROM RINF_ANAGRAFICHE_EVO.RACCORDI_REGISTRO r,
                       (SELECT k.CODICE_VERSIONE,
                                  k.CODICE_VERSIONE
                               || ' - '
                               || NVL (
                                     TO_CHAR (DATA_TRASMISSIONE, 'DD/MM/YYYY'),
                                     TO_CHAR (DATA_PUBBLICAZIONE, 'DD/MM/YYYY'))
                               || ' - '
                               || DECODE (DATA_TRASMISSIONE,
                                          NULL, 'RI Pronto',
                                          PROTOCOLLO)
                                  registro
                          FROM RINF_PUBBLICATI_EVO.VERSIONE_RINF k,
                               (SELECT codice_versione, data_trasmissione
                                  FROM RINF_PUBBLICATI_EVO.ANAGRAFICA_TRASMISSIONI
                                 WHERE CODICE_TRASMISSIONE = 1) t
                         WHERE K.CODICE_VERSIONE = T.CODICE_VERSIONE(+)) w
                 WHERE r.CODICE_VERSIONE = w.CODICE_VERSIONE
              GROUP BY PO_1_2_0_0_0_2, PROG) v,
             (  SELECT PO_1_2_0_0_0_2, MAX (PROG) PROG
                  FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
                 WHERE CODICE_STATO = 2
              GROUP BY PO_1_2_0_0_0_2) h
       WHERE      r.CODICE_STATO = s.CODICE_STATO
             AND r.PO_1_2_0_0_0_2 = v.PO_1_2_0_0_0_2 (+)
             AND r.PROG = v.PROG (+)
             AND h.PO_1_2_0_0_0_2 = R.PO_1_2_0_0_0_2
             AND h.PROG = r.PROG
             AND r.PO_1_2_0_0_0_2 = m.PO_1_2_0_0_0_2 (+)
             AND r.PROG = m.PROG (+)
      UNION
      --Seleziono i raccordi "Inserito"
      SELECT r.PO_1_2_0_0_0_2 PO_1_2_0_0_0_2_RAC,
             r.PROG,
             PO_1_2_0_0_0_1_DEFINIZIONE PO_1_2_0_0_0_1_RAC,
             PO_1_2_0_0_0_3 PO_1_2_0_0_0_3_RAC,
             r.PO_1_2_0_0_0_4 PO_1_2_0_0_0_4_RAC,
             PO_1_2_0_0_0_5_LATITUDINE PO_1_2_0_0_0_5_LAT_RAC,
             PO_1_2_0_0_0_5_LONGITUDINE PO_1_2_0_0_0_5_LONG_RAC,
             NVL(TRIM(GetLineaComm(LOCALITA_RIFERIMENTO,1,NULL)),'0000 / 0.000') PO_1_2_0_0_0_6_LINEA_RAC,
             LOCALITA_RIFERIMENTO LOCA_RAC,
             TIPOLOGIA_RACCORDO TIPO_RAC,
             DEFINIZIONE DESC_LOCA_RAC,
             s.DESCRIZIONE STATO,
            --             NULL DATA_VALIDAZIONE,
             DATA_MODIFICA      DATA_VALIDAZIONE,                           -- Modificato il 20181002
             NULL DATA_ELIMINAZIONE,
             NULL REGISTRO
        FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI r,
             RINF_ANAGRAFICHE_EVO.ANAG_STATO_RACCORDO s,
             RINF_CONTROLLATI_EVO.PUNTI_OPERATIVI p
       WHERE     SEDE_TECNICA (+)= LOCALITA_RIFERIMENTO
             AND r.CODICE_STATO = s.CODICE_STATO
             AND r.CODICE_STATO IN (1);
ELSE --Storico Raccordi
OPEN p_cursor FOR
         --Raccordi Validati che fanno parte di un registro
      SELECT r.PO_1_2_0_0_0_2 PO_1_2_0_0_0_2_RAC,
             r.PROG,
             PO_1_2_0_0_0_1_DEFINIZIONE PO_1_2_0_0_0_1_RAC,
             PO_1_2_0_0_0_3 PO_1_2_0_0_0_3_RAC,
             r.PO_1_2_0_0_0_4 PO_1_2_0_0_0_4_RAC,
             PO_1_2_0_0_0_5_LATITUDINE PO_1_2_0_0_0_5_LAT_RAC,
             PO_1_2_0_0_0_5_LONGITUDINE PO_1_2_0_0_0_5_LONG_RAC,
             NVL(TRIM(GetLineaComm(LOCALITA_RIFERIMENTO, DECODE(m.PO_1_2_0_0_0_2,NULL,1,2),m.CODICE_VERSIONE)),'0000 / 0.000') PO_1_2_0_0_0_6_LINEA_RAC,
             LOCALITA_RIFERIMENTO LOCA_RAC,
             TIPOLOGIA_RACCORDO TIPO_RAC,
             GetLocaDesc(LOCALITA_RIFERIMENTO, DECODE(m.PO_1_2_0_0_0_2,NULL,1,2),m.CODICE_VERSIONE) DESC_LOCA_RAC,
             s.DESCRIZIONE STATO,
             CASE
                WHEN r.CODICE_STATO = 1                             --Inserito
 --                                      THEN NULL
                                       THEN DATA_MODIFICA                                       -- Modificato il 20181002
                WHEN r.CODICE_STATO = 2                             --Validato
                                       THEN DATA_MODIFICA_STATO
                WHEN r.CODICE_STATO = 3                            --Eliminato
                                       THEN DATA_MODIFICA
             END
                DATA_VALIDAZIONE_RAC,
             CASE
                WHEN r.CODICE_STATO = 3                            --Eliminato
                                       THEN DATA_MODIFICA_STATO
                ELSE NULL
             END
                DATA_ELIMINAZIONE_RAC,
              v.CODICE_VERSIONE REGISTRO
        FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI r,
             RINF_ANAGRAFICHE_EVO.ANAG_STATO_RACCORDO s,
             (  SELECT PO_1_2_0_0_0_2,
                       PROG,
                       MAX (CODICE_VERSIONE) CODICE_VERSIONE
                  FROM RINF_ANAGRAFICHE_EVO.RACCORDI_REGISTRO
              GROUP BY PO_1_2_0_0_0_2, PROG) m,
             (  SELECT PO_1_2_0_0_0_2,
                       PROG,
                       LISTAGG (registro || '; ')
                          WITHIN GROUP (ORDER BY r.CODICE_VERSIONE)
                          CODICE_VERSIONE
                  FROM RINF_ANAGRAFICHE_EVO.RACCORDI_REGISTRO r,
                       (SELECT k.CODICE_VERSIONE,
                                  k.CODICE_VERSIONE
                               || ' - '
                               || NVL (
                                     TO_CHAR (DATA_TRASMISSIONE, 'DD/MM/YYYY'),
                                     TO_CHAR (DATA_PUBBLICAZIONE, 'DD/MM/YYYY'))
                               || ' - '
                               || DECODE (DATA_TRASMISSIONE,
                                          NULL, 'RI Pronto',
                                          PROTOCOLLO)
                                  registro
                          FROM RINF_PUBBLICATI_EVO.VERSIONE_RINF k,
                               (SELECT codice_versione, data_trasmissione
                                  FROM RINF_PUBBLICATI_EVO.ANAGRAFICA_TRASMISSIONI
                                 WHERE CODICE_TRASMISSIONE = 1) t
                         WHERE K.CODICE_VERSIONE = T.CODICE_VERSIONE(+)) w
                 WHERE r.CODICE_VERSIONE = w.CODICE_VERSIONE
              GROUP BY PO_1_2_0_0_0_2, PROG) v,
             (  SELECT PO_1_2_0_0_0_2,  PROG
                  FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI
                 WHERE CODICE_STATO IN (2,3)) h
       WHERE     r.CODICE_STATO = s.CODICE_STATO
             AND r.PO_1_2_0_0_0_2 = v.PO_1_2_0_0_0_2 (+)
             AND r.PROG = v.PROG (+)
             AND h.PO_1_2_0_0_0_2 = R.PO_1_2_0_0_0_2
             AND h.PROG = r.PROG
             AND r.PO_1_2_0_0_0_2 = m.PO_1_2_0_0_0_2 (+)
             AND r.PROG = m.PROG (+)
      UNION
      --Selezionoi i raccordi "Inserito" e i "Validati" che NON sono associati ad un registro
      SELECT r.PO_1_2_0_0_0_2 PO_1_2_0_0_0_2_RAC,
             r.PROG,
             PO_1_2_0_0_0_1_DEFINIZIONE PO_1_2_0_0_0_1_RAC,
             PO_1_2_0_0_0_3 PO_1_2_0_0_0_3_RAC,
             r.PO_1_2_0_0_0_4 PO_1_2_0_0_0_4_RAC,
             PO_1_2_0_0_0_5_LATITUDINE PO_1_2_0_0_0_5_LAT_RAC,
             PO_1_2_0_0_0_5_LONGITUDINE PO_1_2_0_0_0_5_LONG_RAC,
             NVL(TRIM(GetLineaComm(LOCALITA_RIFERIMENTO,1,NULL)),'0000 / 0.000') PO_1_2_0_0_0_6_LINEA_RAC,
             LOCALITA_RIFERIMENTO LOCA_RAC,
             TIPOLOGIA_RACCORDO TIPO_RAC,
             DEFINIZIONE DESC_LOCA_RAC,
             s.DESCRIZIONE STATO,
--             NULL DATA_VALIDAZIONE,
             DATA_MODIFICA DATA_VALIDAZIONE,
             NULL DATA_ELIMINAZIONE,
             NULL REGISTRO
        FROM RINF_ANAGRAFICHE_EVO.ANAG_RACCORDI r,
             RINF_ANAGRAFICHE_EVO.ANAG_STATO_RACCORDO s,
             RINF_CONTROLLATI_EVO.PUNTI_OPERATIVI p
       WHERE     SEDE_TECNICA (+)= LOCALITA_RIFERIMENTO
             AND r.CODICE_STATO = s.CODICE_STATO
             AND r.CODICE_STATO IN (1);
END IF;
END GetReportRaccordi;
END PKG_RINF_INSERIMENTI;
/