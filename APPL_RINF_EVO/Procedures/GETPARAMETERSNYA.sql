--
-- GETPARAMETERSNYA  (Procedure) 
--
CREATE OR REPLACE PROCEDURE APPL_RINF_EVO."GETPARAMETERSNYA" (p_versione NUMBER , p_cursor OUT sys_refcursor)
IS

sqlstringa clob;
l_offset number;
CURSOR p_cur IS
SELECT DISTINCT CODICE_PARAMETRO,
       NUMERO_PARAMETRO_MULTIPLO,
       REPLACE (DESCRIZIONE, '''', '''''') desc_parametro,
       NOME_TABELLA nome_tabella,
       SUBSTR(NOME_COLONNA,INSTR(NOME_COLONNA,'.')+1) nome_col,
       SUBSTR(NOME_COLONNA,INSTR(NOME_COLONNA,'.')+1)||'_AP' nome_col_ap,
       STRINGA_JOIN str_join,
       APPLICABILITA
  FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
 WHERE NOME_TABELLA IS  NOT NULL
 AND NUMERO_PARAMETRO_MULTIPLO NOT LIKE '1.1.1.1.6.1%'
 AND NUMERO_PARAMETRO_MULTIPLO NOT LIKE '1.1.1.1.8.5%'
 AND NUMERO_PARAMETRO_MULTIPLO NOT LIKE '1.1.1.1.8.6%'
 AND NUMERO_PARAMETRO NOT IN ('1.2.1.0.6.4','1.2.1.0.6.5')
 AND (APPLICABILITA=0
 OR
 (APPLICABILITA=1 AND
 numero_parametro in(
       select numero_parametro
       from RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI 
       where nome_tabella is not null 
       group by (numero_parametro)
       having count(*) =1)
       )) 
       UNION
SELECT DISTINCT CODICE_PARAMETRO,
       NUMERO_PARAMETRO_MULTIPLO,
       REPLACE (DESCRIZIONE, '''', '''''') desc_parametro,
       NOME_TABELLA nome_tabella,
       SUBSTR(NOME_COLONNA,INSTR(NOME_COLONNA,'.')+1) nome_col,
       SUBSTR(SUBSTR(NOME_COLONNA,INSTR(NOME_COLONNA,'.')+1),1,INSTR(NOME_COLONNA,'_',-1)-1)||'_AP' nome_col_ap,
       STRINGA_JOIN str_join,
       APPLICABILITA
  FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI
 WHERE NOME_TABELLA IS  NOT NULL
 AND NUMERO_PARAMETRO_MULTIPLO NOT LIKE '1.1.1.1.6.1%'
 AND NUMERO_PARAMETRO_MULTIPLO NOT LIKE '1.1.1.1.8.5%'
 AND NUMERO_PARAMETRO_MULTIPLO NOT LIKE '1.1.1.1.8.6%'
 AND NUMERO_PARAMETRO NOT IN ('1.2.1.0.6.4','1.2.1.0.6.5')
 AND (APPLICABILITA=1 
 AND
 numero_parametro in(
       select numero_parametro
       from RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI 
       where nome_tabella is not null 
       group by (numero_parametro)
       having count(*) >1)
       ) 
;    



 sc_par_l p_cur%ROWTYPE;
BEGIN
 sqlstringa:='';
OPEN p_cur;
LOOP
FETCH p_cur INTO sc_par_l;
EXIT WHEN p_cur%NOTFOUND;
CASE WHEN sc_par_l.APPLICABILITA=0 THEN
  sqlstringa:=sqlstringa||' Select  '''||sc_par_l.numero_parametro_multiplo||''' numero_parametro,';
  sqlstringa:=sqlstringa||' '''||sc_par_l.desc_parametro||''' desc_parametro,';
  sqlstringa:=sqlstringa||' COUNT(*) totale_parametri, 0 totale_NYA ';
  sqlstringa:=sqlstringa||' FROM RINF_PUBBLICATI_EVO.'||sc_par_l.NOME_TABELLA||' ';
  sqlstringa:=sqlstringa||' WHERE CODICE_VERSIONE='||TO_CHAR(p_versione);
  sqlstringa:=sqlstringa||' UNION ';
ELSE
 sqlstringa:=sqlstringa||' Select  '''||sc_par_l.numero_parametro_multiplo||''' numero_parametro,';
  sqlstringa:=sqlstringa||' '''||sc_par_l.desc_parametro||''' desc_parametro,';
  sqlstringa:=sqlstringa||' n_p.totale_parametri, n_nya.totale_NYA ';
  sqlstringa:=sqlstringa||' FROM ';
  sqlstringa:=sqlstringa||' (Select  '''||sc_par_l.numero_parametro_multiplo||''' numero_parametro,';
  sqlstringa:=sqlstringa||' '''||sc_par_l.desc_parametro||''' desc_parametro,';
  sqlstringa:=sqlstringa||' COUNT(*) totale_parametri';
  sqlstringa:=sqlstringa||' FROM RINF_PUBBLICATI_EVO.'||sc_par_l.NOME_TABELLA||' ';
  sqlstringa:=sqlstringa||' WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)||' ) n_p, ';
  sqlstringa:=sqlstringa||' (Select  '''||sc_par_l.numero_parametro_multiplo||''' numero_parametro,';
  sqlstringa:=sqlstringa||' COUNT('||sc_par_l.nome_col_AP||') totale_NYA';
  sqlstringa:=sqlstringa||' FROM RINF_PUBBLICATI_EVO.'||sc_par_l.NOME_TABELLA||'  ';
  sqlstringa:=sqlstringa||' WHERE '||sc_par_l.nome_col_AP||'=''NYA''';
  sqlstringa:=sqlstringa||' AND CODICE_VERSIONE='||TO_CHAR(p_versione)||' ) n_nya ';
  sqlstringa:=sqlstringa||' WHERE n_p.numero_parametro=n_nya.numero_parametro';
  sqlstringa:=sqlstringa||' UNION ';
 END CASE; 
END LOOP; 

--tolgo l'ultima UNION
--sqlstringa:=substr(sqlstringa,1,length( sqlstringa)-7);

-- --------------------------------------------------------------------------------------------------------
---RINF_PUBBLICATI_EVO.MARCIAPIEDI_BINARI_PO 
--PARAMETRO 1.2.1.0.6.4 e PARAMETRO 1.2.1.0.6.5
-- --------------------------------------------------------------------------------------------------------
sqlstringa:=sqlstringa||'   SELECT numero_parametro,                            ';
sqlstringa:=sqlstringa||'          DESCRIZIONE,                                                         ';
sqlstringa:=sqlstringa||'          COUNT (*),                                                           ';
sqlstringa:=sqlstringa||'          n_nya.totale_NYA tot_nya                                             ';
sqlstringa:=sqlstringa||'     FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO,                           ';
sqlstringa:=sqlstringa||'          rinf_anagrafiche_evo.catalogo_parametri,                             ';
sqlstringa:=sqlstringa||'          (SELECT COUNT (*) totale_NYA                                         ';
sqlstringa:=sqlstringa||'             FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO                    ';
sqlstringa:=sqlstringa||'            WHERE     PO_TR_PLAT_1_2_1_0_6_4_B1_AP = ''NYA''                   ';
sqlstringa:=sqlstringa||'                  AND BINARIO_1 IS NOT NULL                                    ';
sqlstringa:=sqlstringa||'                  AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') n_nya         ';
sqlstringa:=sqlstringa||'    WHERE     BINARIO_1 IS NOT NULL                                            ';
sqlstringa:=sqlstringa||'          AND numero_parametro_multiplo = ''1.2.1.0.6.4.B1''                   ';
sqlstringa:=sqlstringa||'          AND CODICE_VERSIONE='||TO_CHAR(p_versione);
sqlstringa:=sqlstringa||' GROUP BY numero_parametro, DESCRIZIONE, n_nya.totale_NYA                      ';
sqlstringa:=sqlstringa||' UNION                                                                         ';
sqlstringa:=sqlstringa||'   SELECT numero_parametro,                                                    ';
sqlstringa:=sqlstringa||'          DESCRIZIONE,                                                         ';
sqlstringa:=sqlstringa||'          COUNT (*),                                                           ';
sqlstringa:=sqlstringa||'          n_nya.totale_NYA tot_nya                                             ';
sqlstringa:=sqlstringa||'     FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO,                           ';
sqlstringa:=sqlstringa||'          rinf_anagrafiche_evo.catalogo_parametri,                             ';
sqlstringa:=sqlstringa||'          (SELECT COUNT (*) totale_NYA                                         ';
sqlstringa:=sqlstringa||'             FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO                    ';
sqlstringa:=sqlstringa||'            WHERE     PO_TR_PLAT_1_2_1_0_6_4_B2_AP = ''NYA''                   ';
sqlstringa:=sqlstringa||'                  AND BINARIO_2 IS NOT NULL                                    ';
sqlstringa:=sqlstringa||'                  AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') n_nya         ';
sqlstringa:=sqlstringa||'    WHERE     BINARIO_2 IS NOT NULL                                            ';
sqlstringa:=sqlstringa||'          AND numero_parametro_multiplo = ''1.2.1.0.6.4.B2''                   ';
sqlstringa:=sqlstringa||'          AND CODICE_VERSIONE='||TO_CHAR(p_versione);
sqlstringa:=sqlstringa||' GROUP BY numero_parametro, DESCRIZIONE, n_nya.totale_NYA                      ';
sqlstringa:=sqlstringa||' UNION                                                                         ';
sqlstringa:=sqlstringa||'   SELECT numero_parametro,                                                    ';
sqlstringa:=sqlstringa||'          DESCRIZIONE,                                                         ';
sqlstringa:=sqlstringa||'          COUNT (*),                                                           ';
sqlstringa:=sqlstringa||'          n_nya.totale_NYA tot_nya                                             ';
sqlstringa:=sqlstringa||'     FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO,                           ';
sqlstringa:=sqlstringa||'          rinf_anagrafiche_evo.catalogo_parametri,                             ';
sqlstringa:=sqlstringa||'          (SELECT COUNT (*) totale_NYA                                         ';
sqlstringa:=sqlstringa||'             FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO                    ';
sqlstringa:=sqlstringa||'            WHERE     PO_TR_PLAT_1_2_1_0_6_4_B3_AP = ''NYA''                   ';
sqlstringa:=sqlstringa||'                  AND BINARIO_3 IS NOT NULL                                    ';
sqlstringa:=sqlstringa||'                  AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') n_nya         ';
sqlstringa:=sqlstringa||'    WHERE     BINARIO_3 IS NOT NULL                                            ';
sqlstringa:=sqlstringa||'          AND numero_parametro_multiplo = ''1.2.1.0.6.4.B3''                   ';
sqlstringa:=sqlstringa||'          AND CODICE_VERSIONE='||TO_CHAR(p_versione);
sqlstringa:=sqlstringa||' GROUP BY numero_parametro, DESCRIZIONE, n_nya.totale_NYA                      ';
sqlstringa:=sqlstringa||' UNION                                                                         ';
sqlstringa:=sqlstringa||'   SELECT numero_parametro,                                                    ';
sqlstringa:=sqlstringa||'          DESCRIZIONE,                                                         ';
sqlstringa:=sqlstringa||'          COUNT (*),                                                           ';
sqlstringa:=sqlstringa||'          n_nya.totale_NYA tot_nya                                             ';
sqlstringa:=sqlstringa||'     FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO,                           ';
sqlstringa:=sqlstringa||'          rinf_anagrafiche_evo.catalogo_parametri,                             ';
sqlstringa:=sqlstringa||'          (SELECT COUNT (*) totale_NYA                                         ';
sqlstringa:=sqlstringa||'             FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO                    ';
sqlstringa:=sqlstringa||'            WHERE     PO_TR_PLAT_1_2_1_0_6_4_B4_AP = ''NYA''                   ';
sqlstringa:=sqlstringa||'                  AND BINARIO_4 IS NOT NULL                                    ';
sqlstringa:=sqlstringa||'                  AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') n_nya         ';
sqlstringa:=sqlstringa||'    WHERE     BINARIO_4 IS NOT NULL                                            ';
sqlstringa:=sqlstringa||'          AND numero_parametro_multiplo = ''1.2.1.0.6.4.B4''                   ';
sqlstringa:=sqlstringa||'          AND CODICE_VERSIONE='||TO_CHAR(p_versione);
sqlstringa:=sqlstringa||' GROUP BY numero_parametro, DESCRIZIONE, n_nya.totale_NYA                      ';
sqlstringa:=sqlstringa||' UNION                                                                         ';
sqlstringa:=sqlstringa||'   SELECT numero_parametro,                                                    ';
sqlstringa:=sqlstringa||'          DESCRIZIONE,                                                         ';
sqlstringa:=sqlstringa||'          COUNT (*),                                                           ';
sqlstringa:=sqlstringa||'          n_nya.totale_NYA tot_nya                                             ';
sqlstringa:=sqlstringa||'     FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO,                           ';
sqlstringa:=sqlstringa||'          rinf_anagrafiche_evo.catalogo_parametri,                             ';
sqlstringa:=sqlstringa||'          (SELECT COUNT (*) totale_NYA                                         ';
sqlstringa:=sqlstringa||'             FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO                    ';
sqlstringa:=sqlstringa||'            WHERE     PO_TR_PLAT_1_2_1_0_6_5_B1_AP = ''NYA''                   ';
sqlstringa:=sqlstringa||'                  AND BINARIO_1 IS NOT NULL                                    ';
sqlstringa:=sqlstringa||'                  AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') n_nya         ';
sqlstringa:=sqlstringa||'    WHERE     BINARIO_1 IS NOT NULL                                            ';
sqlstringa:=sqlstringa||'          AND numero_parametro_multiplo = ''1.2.1.0.6.5.B1''                   ';
sqlstringa:=sqlstringa||'          AND CODICE_VERSIONE='||TO_CHAR(p_versione);
sqlstringa:=sqlstringa||' GROUP BY numero_parametro, DESCRIZIONE, n_nya.totale_NYA                      ';
sqlstringa:=sqlstringa||' UNION                                                                         ';
sqlstringa:=sqlstringa||'   SELECT numero_parametro,                                                    ';
sqlstringa:=sqlstringa||'          DESCRIZIONE,                                                         ';
sqlstringa:=sqlstringa||'          COUNT (*),                                                           ';
sqlstringa:=sqlstringa||'          n_nya.totale_NYA tot_nya                                             ';
sqlstringa:=sqlstringa||'     FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO,                           ';
sqlstringa:=sqlstringa||'          rinf_anagrafiche_evo.catalogo_parametri,                             ';
sqlstringa:=sqlstringa||'          (SELECT COUNT (*) totale_NYA                                         ';
sqlstringa:=sqlstringa||'             FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO                    ';
sqlstringa:=sqlstringa||'            WHERE     PO_TR_PLAT_1_2_1_0_6_5_B2_AP = ''NYA''                   ';
sqlstringa:=sqlstringa||'                  AND BINARIO_2 IS NOT NULL                                    ';
sqlstringa:=sqlstringa||'                  AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') n_nya         ';
sqlstringa:=sqlstringa||'    WHERE     BINARIO_2 IS NOT NULL                                            ';
sqlstringa:=sqlstringa||'          AND numero_parametro_multiplo = ''1.2.1.0.6.5.B2''                   ';
sqlstringa:=sqlstringa||'          AND CODICE_VERSIONE='||TO_CHAR(p_versione);
sqlstringa:=sqlstringa||' GROUP BY numero_parametro, DESCRIZIONE, n_nya.totale_NYA                      ';
sqlstringa:=sqlstringa||' UNION                                                                         ';
sqlstringa:=sqlstringa||'   SELECT numero_parametro,                                                    ';
sqlstringa:=sqlstringa||'          DESCRIZIONE,                                                         ';
sqlstringa:=sqlstringa||'          COUNT (*),                                                           ';
sqlstringa:=sqlstringa||'          n_nya.totale_NYA tot_nya                                             ';
sqlstringa:=sqlstringa||'     FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO,                           ';
sqlstringa:=sqlstringa||'          rinf_anagrafiche_evo.catalogo_parametri,                             ';
sqlstringa:=sqlstringa||'          (SELECT COUNT (*) totale_NYA                                         ';
sqlstringa:=sqlstringa||'             FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO                    ';
sqlstringa:=sqlstringa||'            WHERE     PO_TR_PLAT_1_2_1_0_6_5_B3_AP = ''NYA''                   ';
sqlstringa:=sqlstringa||'                  AND BINARIO_3 IS NOT NULL                                    ';
sqlstringa:=sqlstringa||'                  AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') n_nya         ';
sqlstringa:=sqlstringa||'    WHERE     BINARIO_3 IS NOT NULL                                            ';
sqlstringa:=sqlstringa||'          AND numero_parametro_multiplo = ''1.2.1.0.6.5.B3''                   ';
sqlstringa:=sqlstringa||'          AND CODICE_VERSIONE='||TO_CHAR(p_versione);
sqlstringa:=sqlstringa||' GROUP BY numero_parametro, DESCRIZIONE, n_nya.totale_NYA                      ';
sqlstringa:=sqlstringa||' UNION                                                                         ';
sqlstringa:=sqlstringa||'   SELECT numero_parametro,                                                    ';
sqlstringa:=sqlstringa||'          DESCRIZIONE,                                                         ';
sqlstringa:=sqlstringa||'          COUNT (*),                                                           ';
sqlstringa:=sqlstringa||'          n_nya.totale_NYA tot_nya                                             ';
sqlstringa:=sqlstringa||'     FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO,                           ';
sqlstringa:=sqlstringa||'          rinf_anagrafiche_evo.catalogo_parametri,                             ';
sqlstringa:=sqlstringa||'          (SELECT COUNT (*) totale_NYA                                         ';
sqlstringa:=sqlstringa||'             FROM rinf_pubblicati_evo.MARCIAPIEDI_BINARI_PO                    ';
sqlstringa:=sqlstringa||'            WHERE     PO_TR_PLAT_1_2_1_0_6_5_B4_AP = ''NYA''                   ';
sqlstringa:=sqlstringa||'                  AND BINARIO_4 IS NOT NULL                                    ';
sqlstringa:=sqlstringa||'                  AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') n_nya         ';
sqlstringa:=sqlstringa||'    WHERE     BINARIO_4 IS NOT NULL                                            ';
sqlstringa:=sqlstringa||'          AND numero_parametro_multiplo = ''1.2.1.0.6.5.B4''                   ';
sqlstringa:=sqlstringa||'          AND CODICE_VERSIONE='||TO_CHAR(p_versione);
sqlstringa:=sqlstringa||' GROUP BY numero_parametro, DESCRIZIONE, n_nya.totale_NYA                      ';

-- --------------------------------------------------------------------------------------------------------
--       1.2.1.0.1.1_Dichiarazione CE di verifica del binario (INF)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||' UNION                                                                         ';
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_PO                 ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EC''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT PO_TRACK_1_2_1_0_0_2                                 ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.binari_corsa_po                  ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT PO_TRACK_1_2_1_0_0_2                                 ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_PO         ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EC''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_PO                 ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EC''                              ';
 sqlstringa:=sqlstringa||'                 AND PO_TRACK_1_2_1_0_1_1O2_AP = ''NYA''                      ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.2.1.0.1.1''                          ';
 sqlstringa:=sqlstringa||' UNION ';
-- --------------------------------------------------------------------------------------------------------
--       1.2.1.0.1.2_Dichiarazione di dimostrazione IE del Binario (INF)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_PO                 ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EI''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT PO_TRACK_1_2_1_0_0_2                                 ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.binari_corsa_po                  ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT PO_TRACK_1_2_1_0_0_2                                 ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_PO         ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EI''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_PO                 ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EI''                              ';
 sqlstringa:=sqlstringa||'                 AND PO_TRACK_1_2_1_0_1_1O2_AP = ''NYA''                      ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.2.1.0.1.2''                          ';
 sqlstringa:=sqlstringa||' UNION ';

-- --------------------------------------------------------------------------------------------------------
-- RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_CCS - 1.1.1.3.1.1_Dichiarazione CE di verifica del binario(CCS)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_CCS            ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EC''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT SOL_TRACK_1_1_1_0_0_1                                ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.binari_corsa_sol                 ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT SOL_TRACK_1_1_1_0_0_1                                ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_CCS    ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EC''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_CCS            ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EC''                              ';
 sqlstringa:=sqlstringa||'                 AND SOL_TRACK_1_1_1_3_1_1_AP = ''NYA''                      ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.1.1.3.1.1''                          ';
 sqlstringa:=sqlstringa||' UNION ';

-- --------------------------------------------------------------------------------------------------------
-- RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE - 1.1.1.2.1.1_Dichiarazione di verifica CE del binario (ENE)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE            ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EC''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT SOL_TRACK_1_1_1_0_0_1                                ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.binari_corsa_sol                 ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT SOL_TRACK_1_1_1_0_0_1                                ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE    ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EC''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE            ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EC''                              ';
 sqlstringa:=sqlstringa||'                 AND SOL_TRACK_1_1_1_2_1_1O2_AP = ''NYA''                      ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.1.1.2.1.1''                          ';
 sqlstringa:=sqlstringa||' UNION ';
-- --------------------------------------------------------------------------------------------------------
-- RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE - 1.1.1.2.1.2_Dichiarazione di dimostrazione IE del binario (ENE)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE            ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EI''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT SOL_TRACK_1_1_1_0_0_1                                ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.binari_corsa_sol                 ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT SOL_TRACK_1_1_1_0_0_1                                ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE    ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EI''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_ENE            ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EI''                              ';
 sqlstringa:=sqlstringa||'                 AND SOL_TRACK_1_1_1_2_1_1O2_AP = ''NYA''                     ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.1.1.2.1.2''                          ';
 sqlstringa:=sqlstringa||' UNION ';

-- --------------------------------------------------------------------------------------------------------
-- RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF - 1.1.1.1.1.1_Dichiarazione CE di verifica del binario (INF)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF            ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EC''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT SOL_TRACK_1_1_1_0_0_1                                ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.binari_corsa_sol                 ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT SOL_TRACK_1_1_1_0_0_1                                ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF    ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EC''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF            ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EC''                              ';
 sqlstringa:=sqlstringa||'                 AND SOL_TRACK_1_1_1_1_1_1O2_AP = ''NYA''                    ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.1.1.1.1.1''                          ';
 sqlstringa:=sqlstringa||' UNION ';

-- --------------------------------------------------------------------------------------------------------
-- RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF - 1.1.1.1.1.2_Dichiarazione di dimostrazione IE del binario (INF)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF            ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EI''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT SOL_TRACK_1_1_1_0_0_1                                ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.binari_corsa_sol                 ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT SOL_TRACK_1_1_1_0_0_1                                ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF    ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EI''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_BINARIO_SOL_INF            ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EI''                              ';
 sqlstringa:=sqlstringa||'                 AND SOL_TRACK_1_1_1_1_1_1O2_AP = ''NYA''                    ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.1.1.1.1.2''                          ';
 sqlstringa:=sqlstringa||' UNION ';

-- --------------------------------------------------------------------------------------------------------
-- RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_PO  - 1.2.1.0.5.3_Dichiarazione CE di verifica della galleria (SRT)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_PO            ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EC''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT PO_TR_TUNNEL_1_2_1_0_5_2                             ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.GALLERIE_BINARI_PO               ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT PO_TR_TUNNEL_1_2_1_0_5_2                             ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_PO    ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EC''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_PO            ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EC''                              ';
 sqlstringa:=sqlstringa||'                 AND PO_TR_TUNNEL_1_2_1_0_5_3O4_AP = ''NYA''                  ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.2.1.0.5.3''                          ';
 sqlstringa:=sqlstringa||' UNION ';

-- --------------------------------------------------------------------------------------------------------
-- RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_PO  - 1.2.1.0.5.4_Dichiarazione di dimostrazione IE per la GALLERIA (SRT)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_PO            ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EI''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT PO_TR_TUNNEL_1_2_1_0_5_2                             ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.GALLERIE_BINARI_PO               ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT PO_TR_TUNNEL_1_2_1_0_5_2                             ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_PO    ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EI''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_PO            ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EI''                              ';
 sqlstringa:=sqlstringa||'                 AND PO_TR_TUNNEL_1_2_1_0_5_3O4_AP = ''NYA''                  ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.2.1.0.5.4''                          ';
 sqlstringa:=sqlstringa||' UNION ';

-- --------------------------------------------------------------------------------------------------------
-- RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_SOL - 1.1.1.1.8.5_Dichiarazione CE di verifica della galleria (SRT)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_SOL           ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EC''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT SOL_TUNNEL_1_1_1_1_8_2                               ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.GALLERIE_BINARI_SOL              ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT SOL_TUNNEL_1_1_1_1_8_2                               ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_SOL   ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EC''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_SOL           ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EC''                              ';
 sqlstringa:=sqlstringa||'                 AND SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''NYA''                  ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.1.1.1.8.5''                          ';
 sqlstringa:=sqlstringa||' UNION ';

-- --------------------------------------------------------------------------------------------------------
-- RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_SOL - 1.1.1.1.8.6_Dichiarazione di dimostrazione IE per la galleria (SRT)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_SOL           ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EI''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT SOL_TUNNEL_1_1_1_1_8_2                               ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.GALLERIE_BINARI_SOL              ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT SOL_TUNNEL_1_1_1_1_8_2                               ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_SOL   ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EI''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_GALLERIE_BIN_SOL           ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EI''                              ';
 sqlstringa:=sqlstringa||'                 AND SOL_TUNNEL_1_1_1_1_8_5O6_AP = ''NYA''                    ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.1.1.1.8.6''                          ';
 sqlstringa:=sqlstringa||' UNION ';

-- --------------------------------------------------------------------------------------------------------
-- RINF_PUBBLICATI_EVO.DICHIARAZIONI_RACCORDO_PO - 1.2.2.0.1.1_Dichiarazione CE di verifica del binario di raccordo (INF)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_RACCORDO_PO           ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EC''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT PO_SD_1_2_2_0_0_2                               ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.BINARI_RACCORDO_PO              ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT PO_SD_1_2_2_0_0_2                               ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_RACCORDO_PO   ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EC''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_RACCORDO_PO           ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EC''                              ';
 sqlstringa:=sqlstringa||'                 AND PO_SD_1_2_2_0_1_1O2_AP = ''NYA''                  ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.2.2.0.1.1''                          ';
 sqlstringa:=sqlstringa||' UNION ';

-- --------------------------------------------------------------------------------------------------------
-- RINF_PUBBLICATI_EVO.DICHIARAZIONI_RACCORDO_PO - 1.2.2.0.1.2_Dichiarazione di dimostrazione IE del binario di raccordo (INF)
-- --------------------------------------------------------------------------------------------------------
 sqlstringa:=sqlstringa||'  SELECT numero_parametro,                            ';
 sqlstringa:=sqlstringa||'         descrizione,                                                         ';
 sqlstringa:=sqlstringa||'         t1.conteggio + t2.conteggio totale_parametri,                        ';
 sqlstringa:=sqlstringa||'         t2.conteggio + t3.conteggio totale_NYA                               ';
 sqlstringa:=sqlstringa||'    FROM RINF_ANAGRAFICHE_EVO.CATALOGO_PARAMETRI,                             ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_RACCORDO_PO           ';
 sqlstringa:=sqlstringa||'           WHERE TIPO_DICHIARAZIONE = ''EI''                                  ';
 sqlstringa:=sqlstringa||'           AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t1,                 ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM (SELECT PO_SD_1_2_2_0_0_2                               ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.BINARI_RACCORDO_PO              ';
 sqlstringa:=sqlstringa||'                    WHERE CODICE_VERSIONE='||TO_CHAR(p_versione)              ;
 sqlstringa:=sqlstringa||'                  MINUS                                                       ';
 sqlstringa:=sqlstringa||'                  SELECT PO_SD_1_2_2_0_0_2                               ';
 sqlstringa:=sqlstringa||'                    FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_RACCORDO_PO   ';
 sqlstringa:=sqlstringa||'                   WHERE TIPO_DICHIARAZIONE = ''EI''                          ';
 sqlstringa:=sqlstringa||'                   AND CODICE_VERSIONE='||TO_CHAR(p_versione)||')) t2,        ';
 sqlstringa:=sqlstringa||'         (SELECT COUNT (*) conteggio                                          ';
 sqlstringa:=sqlstringa||'            FROM RINF_PUBBLICATI_EVO.DICHIARAZIONI_RACCORDO_PO           ';
 sqlstringa:=sqlstringa||'           WHERE     TIPO_DICHIARAZIONE = ''EI''                              ';
 sqlstringa:=sqlstringa||'                 AND PO_SD_1_2_2_0_1_1O2_AP = ''NYA''                  ';
 sqlstringa:=sqlstringa||'                 AND CODICE_VERSIONE='||TO_CHAR(p_versione)||') t3            ';
 sqlstringa:=sqlstringa||'   WHERE numero_parametro_multiplo = ''1.2.2.0.1.2''                          ';


--DBMS_OUTPUT.PUT_LINE (sqlstringa); 
OPEN p_cursor FOR sqlstringa;
l_offset:=1;
--loop
--       exit when l_offset > dbms_lob.getlength(sqlstringa);
--        dbms_output.put_line( dbms_lob.substr( sqlstringa, 255, l_offset ) );
--      l_offset := l_offset + 255;
--    end loop;
END GetParametersNYA;


/
