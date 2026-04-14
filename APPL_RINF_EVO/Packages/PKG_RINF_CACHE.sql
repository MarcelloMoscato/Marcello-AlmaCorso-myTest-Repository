--
-- PKG_RINF_CACHE  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_CACHE" AS
/******************************************************************************
   NAME:       PKG_RINF_CACHE
   PURPOSE:     Versione per lo SVILUPPO

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.1        4/05/2016   D.Campagiorni    1. Created this package.
******************************************************************************/

  TYPE empcur IS REF CURSOR;
-- solo per sviluppo
 Procedure cancella_cache_controllati  (p_parametro Number, p_error Out Number);

 PROCEDURE SetOPCache(p_OP VARCHAR2, p_area NUMBER, p_i_versione NUMBER, p_testo CLOB , p_error OUT NUMBER);
 PROCEDURE SetSOLCache (p_SOL VARCHAR2, p_area NUMBER, p_i_versione NUMBER, p_testo CLOB, p_error OUT NUMBER);
 PROCEDURE PulisciCache (p_contesto NUMBER, p_area NUMBER, p_stringa VARCHAR2, p_i_versione NUMBER, p_error OUT NUMBER);

END PKG_RINF_CACHE;
/


--
-- PKG_RINF_CACHE  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_CACHE" AS

PROCEDURE SetOPCache (p_OP               VARCHAR2,
                      p_area             NUMBER,
                      p_i_versione       NUMBER,
                      p_testo            CLOB,
                      p_error        OUT NUMBER)
IS

   sqlstringa   VARCHAR2 (5000);
   p_versione   NUMBER;
BEGIN
   p_error := 0;

   p_versione := p_i_versione;

   IF (p_area = 2 OR p_area = 4) AND p_versione IS NULL
   THEN
      p_versione := PKG_RINF_DATA_V082.GetLastVersion (p_area);
   END IF;

--   sqlstringa :=
--         'UPDATE  '
--      || s_schema
--      || '.PUNTI_OPERATIVI SET CACHE_FIELD='
--      || p_testo;
--   sqlstringa := sqlstringa || ' WHERE SEDE_TECNICA=''' || p_OP || '''';
--
--   EXECUTE IMMEDIATE sqlstringa;

CASE  p_area
WHEN 1 THEN
        UPDATE RINF_CONTROLLATI_EVO.PUNTI_OPERATIVI
        SET CACHE_FIELD=p_testo
        WHERE SEDE_TECNICA=p_OP;
WHEN 3 THEN
        UPDATE RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI
        SET CACHE_FIELD=p_testo
        WHERE SEDE_TECNICA=p_OP;
ELSE
        UPDATE RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI
        SET CACHE_FIELD=p_testo
        WHERE SEDE_TECNICA=p_OP
        AND CODICE_VERSIONE=p_versione;
END CASE;
EXCEPTION
   WHEN OTHERS
   THEN
      p_error := SQLCODE;
      DBMS_OUTPUT.PUT_LINE ('SetOPCache Error' || SQLCODE);
END SetOPCache;

PROCEDURE SetSOLCache (p_SOL VARCHAR2,p_area NUMBER,p_i_versione NUMBER,p_testo CLOB,p_error OUT NUMBER) IS

   sqlstringa   VARCHAR2 (5000);
   stringa_where VARCHAR2 (5000);
   p_versione   NUMBER;
BEGIN
   p_error := 0;

   p_versione := p_i_versione;

   IF (p_area = 2 OR p_area = 4) AND p_versione IS NULL
   THEN
      p_versione := PKG_RINF_DATA_V082.GetLastVersion (p_area);
   END IF;

--   sqlstringa :=
--         'UPDATE  '
--      || s_schema
--      || '.SEZIONI_LINEA SET CACHE_FIELD=';
--   stringa_where := ' WHERE SEDE_TECNICA=''' || p_SOL || '''';
--
--   EXECUTE IMMEDIATE sqlstringa||p_testo||stringa_where;
CASE  p_area
WHEN 1 THEN
        UPDATE RINF_CONTROLLATI_EVO.SEZIONI_LINEA
        SET CACHE_FIELD=p_testo
        WHERE SEDE_TECNICA=p_SOL;
WHEN 3 THEN
        UPDATE RINF_AUTORIZZAZIONI_EVO.SEZIONI_LINEA
        SET CACHE_FIELD=p_testo
        WHERE SEDE_TECNICA=p_SOL;
ELSE
        UPDATE RINF_PUBBLICATI_EVO.SEZIONI_LINEA
        SET CACHE_FIELD=p_testo
        WHERE SEDE_TECNICA=p_SOL
        AND CODICE_VERSIONE=p_versione;
END CASE;

    EXCEPTION
        WHEN OTHERS THEN
        p_error:= SQLCODE;
        DBMS_OUTPUT.PUT_LINE('SetSOLCache Error' || SQLCODE);
END SetSOLCache;


PROCEDURE PulisciCache (p_contesto         NUMBER,
                        p_area             NUMBER,
                        p_stringa          VARCHAR2,
                        p_i_versione       NUMBER,
                        p_error        OUT NUMBER)
IS
   sqlstringa   VARCHAR2 (5000);
   s_schema     VARCHAR2 (100);
   p_versione   NUMBER;
BEGIN
   p_error := 0;

   IF p_area IS NOT NULL
   THEN
      s_schema := PKG_RINF_INTERFACCIA.GetSchemaName (p_area);
   END IF;

   p_versione := p_i_versione;

   IF (p_area = 2 OR p_area = 4) AND p_versione IS NULL
   THEN
      p_versione := PKG_RINF_DATA_V082.GetLastVersion (p_area);
   END IF;

   CASE
      WHEN p_contesto = 1
      THEN                                                   --Punto operativo
         sqlstringa :=
               'UPDATE '
            || s_schema
            || '.PUNTI_OPERATIVI SET CACHE_FIELD=NULL where (UPPER(SEDE_TECNICA)||'' ''||UPPER(DEFINIZIONE) like ''%'
            || UPPER (p_stringa)
            || '%'')';

         IF p_versione IS NOT NULL
         THEN
            sqlstringa := sqlstringa || ' and CODICE_VERSIONE=' || p_versione;
         END IF;

         DBMS_OUTPUT.PUT_LINE (sqlstringa);

         EXECUTE IMMEDIATE sqlstringa;
      WHEN p_contesto = 2
      THEN                                                  --Sezione di Linea
         sqlstringa :=
               'UPDATE '
            || s_schema
            || '.SEZIONI_LINEA SET CACHE_FIELD=NULL where (UPPER(SEDE_TECNICA)||'' ''||UPPER(DEFINIZIONE) like ''%'
            || UPPER (p_stringa)
            || '%'') ';

         IF p_versione IS NOT NULL
         THEN
            sqlstringa := sqlstringa || ' and CODICE_VERSIONE=' || p_versione;
         END IF;

         DBMS_OUTPUT.PUT_LINE (sqlstringa);

         EXECUTE IMMEDIATE sqlstringa;
      WHEN p_contesto = 9
      THEN                                                       --Intera rete
         sqlstringa :=
            'UPDATE ' || s_schema || '.SEZIONI_LINEA SET CACHE_FIELD=NULL ';

         IF p_versione IS NOT NULL
         THEN
            sqlstringa := sqlstringa || ' and CODICE_VERSIONE=' || p_versione;
         END IF;

         DBMS_OUTPUT.PUT_LINE (sqlstringa);

         EXECUTE IMMEDIATE sqlstringa;

         sqlstringa :=
            'UPDATE ' || s_schema || '.PUNTI_OPERATIVI SET CACHE_FIELD=NULL ';

         IF p_versione IS NOT NULL
         THEN
            sqlstringa := sqlstringa || ' and CODICE_VERSIONE=' || p_versione;
         END IF;

         DBMS_OUTPUT.PUT_LINE (sqlstringa);

         EXECUTE IMMEDIATE sqlstringa;
      ELSE
         sqlstringa :=
               'UPDATE '
            || s_schema
            || '.PUNTI_OPERATIVI SET CACHE_FIELD=NULL where SEDE_TECNICA IN ';
         sqlstringa :=
               sqlstringa
            || ' (select SEDE_TECNICA from '
            || s_schema
            || '.V_OP_CONTESTO_GEOGRAFICO';
         sqlstringa :=
               sqlstringa
            || ' where CODICE_CONTESTO='
            || p_contesto
            || ' and UPPER(CODICE)||'' ''||UPPER(DESCRIZIONE) like ''%'
            || UPPER (p_stringa)
            || '%'') ';

         DBMS_OUTPUT.PUT_LINE (sqlstringa);

         EXECUTE IMMEDIATE sqlstringa;

         sqlstringa :=
               'UPDATE '
            || s_schema
            || '.SEZIONI_LINEA SET CACHE_FIELD=NULL where SEDE_TECNICA IN ';
         sqlstringa :=
               sqlstringa
            || ' (select SEDE_TECNICA from '
            || s_schema
            || '.V_SOL_CONTESTO_GEOGRAFICO';
         sqlstringa :=
               sqlstringa
            || ' where CODICE_CONTESTO='
            || p_contesto
            || ' and UPPER(CODICE)||'' ''||UPPER(DESCRIZIONE) like ''%'
            || UPPER (p_stringa)
            || '%'') ';

         DBMS_OUTPUT.PUT_LINE (sqlstringa);

         EXECUTE IMMEDIATE sqlstringa;
   END CASE;
EXCEPTION
   WHEN OTHERS
   THEN
      p_error := SQLCODE;
END PulisciCache;
--
-- --------------------------------------------------------------------------------------
--            Procedure cancella_cache_controllati 
-- --------------------------------------------------------------------------------------
--
 Procedure cancella_cache_controllati  (p_parametro Number, p_error Out Number)  Is
--   esito number;
 BEGIN
  p_error := 0;
   if p_parametro = 2 then
--  
       UPDATE RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI
          SET CACHE_FIELD = NULL
          where codice_versione = (select max(codice_versione) from RINF_PUBBLICATI_EVO.versione_rinf);
--        
       UPDATE RINF_PUBBLICATI_EVO.SEZIONI_LINEA
          SET CACHE_FIELD = NULL
          where codice_versione = (select max(codice_versione) from RINF_PUBBLICATI_EVO.versione_rinf);
--
  else 
--
       UPDATE RINF_CONTROLLATI_EVO.SEZIONI_LINEA
        SET CACHE_FIELD = NULL;
--        
       UPDATE RINF_CONTROLLATI_EVO.PUNTI_OPERATIVI
        SET CACHE_FIELD = NULL;
--
  end if;
--
  COMMIT;
--
  EXCEPTION
        When OTHERS Then
		    Rollback;
			p_error := 1;
 End cancella_cache_controllati;
-- 
END PKG_RINF_CACHE;
/