--
-- GETCOUNTOBJECTNYA  (Function) 
--
CREATE OR REPLACE FUNCTION APPL_RINF_EVO."GETCOUNTOBJECTNYA" (p_tabella IN VARCHAR2, p_versione IN NUMBER)
   RETURN NUMBER
IS
   --27/11/2017
   --procedura che riceve in input il nome della tabella ed il numero di versione, si costruisce dinamicamente
   --la where per contare il numero di oggetti che hanno almeno un parametro a NYA
   i            NUMBER;
   sqlstringa   VARCHAR2 (30000);
   sqlstringa_where   VARCHAR2 (30000);

   TYPE column_t IS TABLE OF VARCHAR2 (1000);

   l_column     column_t;
BEGIN
   SELECT column_name  colonna
     BULK COLLECT INTO l_column
     FROM all_tab_columns
    WHERE     owner = 'RINF_PUBBLICATI_EVO'
          AND table_name = p_tabella
          AND column_name LIKE '%\_AP' ESCAPE '\';

   sqlstringa_where := ' ( ';

   FOR i IN 1 .. l_column.COUNT
   LOOP
      sqlstringa_where := sqlstringa_where || ' ' || l_column (i) || '=''NYA'' OR';
   END LOOP;

   --elimino l'ultimo OR e inserisco la parentesi di chiusura
   sqlstringa_where := SUBSTR (sqlstringa_where, 1, LENGTH (sqlstringa_where) - 3) || ' ) ';

   sqlstringa:='Select count(*) tot from RINF_PUBBLICATI_EVO.'||p_tabella;
   sqlstringa:=sqlstringa||' where CODICE_VERSIONE='||p_versione||' AND ';
   sqlstringa:=sqlstringa||sqlstringa_where;

   EXECUTE IMMEDIATE sqlstringa INTO i;

   RETURN i;
END GetCountObjectNYA;


/
