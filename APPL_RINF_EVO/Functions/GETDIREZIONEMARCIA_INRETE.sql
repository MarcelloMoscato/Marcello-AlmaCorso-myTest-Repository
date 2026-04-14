--
-- GETDIREZIONEMARCIA_INRETE  (Function) 
--
CREATE OR REPLACE FUNCTION APPL_RINF_EVO."GETDIREZIONEMARCIA_INRETE" (p_sede_tecnica VARCHAR2, p_tipo_binario VARCHAR2)
 RETURN VARCHAR2 IS
 s_tipo_tratta VARCHAR2(30);
 p_valore_ret VARCHAR2(1);
 n_binari NUMBER;
 BEGIN
 Select SOL_1_1_0_0_0_6 into s_tipo_tratta from RINF_LAVORAZIONE_EVO.SEZIONI_LINEA
      where SEDE_TECNICA=SUBSTR(p_sede_tecnica,1,6);

      --Se una tratta ¿ di tipo Link

      IF s_tipo_tratta='L' THEN
        select count(*) into n_binari
        from RINF_STAGING_EVO.CLASSE_R16000_TR
        where SEDE_TECNICA=SUBSTR(p_sede_tecnica,1,6);
        IF n_binari=1 THEN
            p_valore_ret:='B';
        ELSE
             Select
                 CASE WHEN MOD(SUBSTR(p_sede_tecnica,13),2)>0 THEN 'N'
                 ELSE 'O'
                 END CASE
             into p_valore_ret
             FROM dual;
         END IF;
      ELSE
      --11/09/2016 Modificato in seguito alla mail di Galli con l'aggiunta di Blocco Radio tra i banalizzati
         Select
         CASE WHEN (A.REGIME_CIRCOLAZIONE IN ('BAFB','BCAB','BACFCE','BAB','BCAMB') OR A.REGIME_CIRCOLAZIONE='BR')   THEN 'B'
            WHEN A.REGIME_CIRCOLAZIONE NOT IN ('BAFB','BCAB','BACFCE','BAB','BCAMB') AND A.REGIME_CIRCOLAZIONE<>'BR' AND p_tipo_binario='U' THEN 'B'
            WHEN A.REGIME_CIRCOLAZIONE NOT IN ('BAFB','BCAB','BACFCE','BAB','BCAMB') AND A.REGIME_CIRCOLAZIONE<>'BR' AND p_tipo_binario='D' THEN 'N'
            WHEN A.REGIME_CIRCOLAZIONE NOT IN ('BAFB','BCAB','BACFCE','BAB','BCAMB') AND A.REGIME_CIRCOLAZIONE<>'BR' AND p_tipo_binario='P' THEN 'O'
         END CASE
         into p_valore_ret
         FROM
         RINF_STAGING_EVO.CLASSE_R13000 a
         where SEDE_TECNICA=SUBSTR(p_sede_tecnica,1,6);
      END IF;
 return p_valore_ret;
 EXCEPTION
 WHEN OTHERS THEN
 return to_char(SQLCODE);
 END GetDirezioneMarcia_INRETE;


/
