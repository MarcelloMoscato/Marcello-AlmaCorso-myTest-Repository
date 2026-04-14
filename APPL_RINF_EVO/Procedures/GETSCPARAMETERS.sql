--
-- GETSCPARAMETERS  (Procedure) 
--
CREATE OR REPLACE PROCEDURE APPL_RINF_EVO.GetSCParameters (p_codice_dtp VARCHAR2,p_cursor  OUT sys_REFCURSOR)
IS

sqlstringa long;
CURSOR p_cur IS
Select CODICE_PARAMETRO, NUMERO_PARAMETRO_MULTIPLO, DESCRIZIONE desc_parametro, NOME_TABELLA nome_tab, 
NOME_COLONNA nome_col, STRINGA_JOIN str_join
 from RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
 where STRINGA_JOIN is not null
 and codice_parametro>=1 and codice_parametro<10;

      sc_par_l p_cur%ROWTYPE;
BEGIN
 sqlstringa:='';
OPEN p_cur;
LOOP
FETCH p_cur INTO sc_par_l;
EXIT WHEN p_cur%NOTFOUND;

  sqlstringa:=sqlstringa||' Select b.CODICE_DTP, b.SEDE_TECNICA,b.DEFINIZIONE DESC_SEDE_TECNICA, '''||sc_par_l.numero_parametro_multiplo||''' numero_parametro,';
  sqlstringa:=sqlstringa||' '''||sc_par_l.desc_parametro||''' desc_parametro,';
  sqlstringa:=sqlstringa||' TO_CHAR('||sc_par_l.nome_col||') valore_parametro ';
  --sqlstringa:=sqlstringa||' FROM RINF_AUTORIZZAZIONI_V082AG.'||sc_par_l.nome_tab||' a '; --il from è nella stringa di join
  sqlstringa:=sqlstringa||' '||sc_par_l.str_join||''''||p_codice_dtp||''' ';
  sqlstringa:=sqlstringa||' UNION ';
END LOOP; 

--tolgo l'ultima UNION
 sqlstringa:=substr(sqlstringa,1,length( sqlstringa)-7);
DBMS_OUTPUT.PUT_LINE (sqlstringa); 
--OPEN p_cursor FOR sqlstringa;
END GetSCParameters;
/
