--
-- GETCOUNTPARAMETERNYA  (Function) 
--
CREATE OR REPLACE FUNCTION APPL_RINF_EVO."GETCOUNTPARAMETERNYA" (p_tabella    IN VARCHAR2,
                                                 p_versione   IN NUMBER)
   RETURN NUMBER
IS
   --27/11/2017
   --procedura che riceve in input il nome della tabella ed il numero di versione, si costruisce dinamicamente
   --il campo per contare il numero di occorrenze NYA per tutti i parametri della tabella
   i                  NUMBER;
   sqlstringa         VARCHAR2 (30000);
   sqlstringa_campo   VARCHAR2 (30000);

   TYPE column_t IS TABLE OF VARCHAR2 (1000);

   l_column           column_t;
BEGIN
   IF p_tabella <> 'MARCIAPIEDI_BINARI_PO'
   THEN
      SELECT column_name colonna
        BULK COLLECT INTO l_column
        FROM all_tab_columns
       WHERE     owner = 'RINF_PUBBLICATI_EVO'
             AND table_name = p_tabella
             AND column_name LIKE '%\_AP' ESCAPE '\';

      sqlstringa_campo := ' SUM( ';

      FOR i IN 1 .. l_column.COUNT
      LOOP
         sqlstringa_campo :=
               sqlstringa_campo
            || ' DECODE('
            || l_column (i)
            || ',''NYA'',1,0) +';
      END LOOP;

      --elimino l'ultimo + e inserisco la parentesi di chiusura
      sqlstringa_campo :=
         SUBSTR (sqlstringa_campo, 1, LENGTH (sqlstringa_campo) - 2) || ' ) ';

      sqlstringa :=
            'Select '
         || sqlstringa_campo
         || ' tot from RINF_PUBBLICATI_EVO.'
         || p_tabella;
      sqlstringa := sqlstringa || ' where CODICE_VERSIONE=' || p_versione;


      EXECUTE IMMEDIATE sqlstringa INTO i;
   ELSE
      SELECT SUM (
                  DECODE (PO_TR_PLATFORM_1_2_1_0_6_3_AP, 'NYA', 1, 0)
                + DECODE (PO_TR_PLATFORM_1_2_1_0_6_6_AP, 'NYA', 1, 0)
                + DECODE (PO_TR_PLATFORM_1_2_1_0_6_7, 'NYA', 1, 0)
                + DECODE (PO_TR_PLAT_1_2_1_0_6_4_B1_AP, 'NYA', 1, 0)
                - DECODE (BINARIO_1, NULL, 1, 0)
                + DECODE (PO_TR_PLAT_1_2_1_0_6_4_B2_AP, 'NYA', 1, 0)
                - DECODE (BINARIO_2, NULL, 1, 0)
                + DECODE (PO_TR_PLAT_1_2_1_0_6_4_B3_AP, 'NYA', 1, 0)
                - DECODE (BINARIO_3, NULL, 1, 0)
                + DECODE (PO_TR_PLAT_1_2_1_0_6_4_B4_AP, 'NYA', 1, 0)
                - DECODE (BINARIO_4, NULL, 1, 0)
                + DECODE (PO_TR_PLAT_1_2_1_0_6_5_B1_AP, 'NYA', 1, 0)
                - DECODE (BINARIO_1, NULL, 1, 0)
                + DECODE (PO_TR_PLAT_1_2_1_0_6_5_B2_AP, 'NYA', 1, 0)
                - DECODE (BINARIO_2, NULL, 1, 0)
                + DECODE (PO_TR_PLAT_1_2_1_0_6_5_B3_AP, 'NYA', 1, 0)
                - DECODE (BINARIO_3, NULL, 1, 0)
                + DECODE (PO_TR_PLAT_1_2_1_0_6_5_B4_AP, 'NYA', 1, 0)
                - DECODE (BINARIO_4, NULL, 1, 0))
        INTO i
        FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO
       WHERE codice_versione = p_versione;
   END IF;

   RETURN i;
END GetCountParameterNYA;


/
