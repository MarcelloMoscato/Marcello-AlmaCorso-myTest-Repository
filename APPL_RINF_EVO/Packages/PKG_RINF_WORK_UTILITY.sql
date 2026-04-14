--
-- PKG_RINF_WORK_UTILITY  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_WORK_UTILITY" 

IS
PROCEDURE SETREGCONTROL(id_tipo_controllo NUMBER, ID_NUM_PARAMETRO VARCHAR2,p_definizione IN varchar2,p_rif_norma VARCHAR2, p_nome_procedura VARCHAR2, p_error OUT NUMBER);
--Procedura che riceve in input una stringa di oggetti delimitati da virgola e ne restituisce tre contenenti al massimo 100 oggetti delimitati da virgola
PROCEDURE GetStringhe1000(p_lista_all CLOB,s_lista_1 OUT CLOB,s_lista_2 OUT CLOB,s_lista_3 OUT CLOB);
END;
/


--
-- PKG_RINF_WORK_UTILITY  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_WORK_UTILITY" IS



PROCEDURE SETREGCONTROL(id_tipo_controllo NUMBER, ID_NUM_PARAMETRO VARCHAR2,p_definizione IN varchar2,p_rif_norma VARCHAR2, p_nome_procedura VARCHAR2, p_error OUT NUMBER) IS
n_controllo NUMBER;
BEGIN
    p_error:=0;
    Select max(nvl(IDENTIFICATIVO_CONTROLLO,0))+1 into n_controllo FROM RINF_LAVORAZIONE_EVO.REGISTRO_CONTROLLI;
    insert into RINF_LAVORAZIONE_EVO.REGISTRO_CONTROLLI
    (IDENTIFICATIVO_CONTROLLO, CODICE_PARAMETRO, CODICE_TIPO_CONTROLLO, DEFINIZIONE, RIF_NORMA, PROCEDURA)
    VALUES (case when n_controllo is null then 1 else n_controllo end,
    PKG_RINF_INTERFACCIA.GetParameterID(ID_NUM_PARAMETRO),
    id_tipo_controllo,p_definizione,p_rif_norma,p_nome_procedura);

END SETREGCONTROL;

PROCEDURE GetStringhe1000(p_lista_all CLOB,s_lista_1 OUT CLOB,s_lista_2 OUT CLOB,s_lista_3 OUT CLOB) IS
n_conta NUMBER;

BEGIN
select
 REGEXP_COUNT(p_lista_all,
                ',', 1, 'i') into n_conta from dual;
IF n_conta>1000 THEN
    SELECT SUBSTR(p_lista_all,1,REGEXP_INSTR(p_lista_all,
                ',', 1, 1000)-1)
    INTO s_lista_1 from dual;
    IF n_conta<2000 THEN
    SELECT SUBSTR(p_lista_all,REGEXP_INSTR(p_lista_all,
                ',', 1, 1000)+1)
    INTO s_lista_2 from dual;
    ELSE
    SELECT SUBSTR(p_lista_all,REGEXP_INSTR(p_lista_all,
                ',', 1, 1000)+1,REGEXP_INSTR(p_lista_all,
                ',', 1, 2000)-REGEXP_INSTR(p_lista_all,
                ',', 1, 1000)-1)
    INTO s_lista_2 from dual;
    SELECT SUBSTR(p_lista_all,REGEXP_INSTR(p_lista_all,
                ',', 1, 2000)+1)
    INTO s_lista_3 from dual;
    END IF;
ELSE
 s_lista_1:=  p_lista_all;
END IF;

DBMS_OUTPUT.PUT_LINE ('p_lista_all: L:'||length(p_lista_all)||' N: '||REGEXP_COUNT(p_lista_all,',', 1, 'i'));
DBMS_OUTPUT.PUT_LINE ('s_lista_1: L:'||length(s_lista_1)||' N: '||REGEXP_COUNT(s_lista_1,',', 1, 'i')||' FO: '||SUBSTR(s_lista_1,1, 6)||' LO: '||SUBSTR(s_lista_1,length(s_lista_1)-7));
DBMS_OUTPUT.PUT_LINE ('s_lista_2: L:'||length(s_lista_2)||' N: '||REGEXP_COUNT(s_lista_2,',', 1, 'i')||' FO: '||SUBSTR(s_lista_2,1, 6)||' LO: '||SUBSTR(s_lista_2,length(s_lista_2)-7));
DBMS_OUTPUT.PUT_LINE ('s_lista_3: L:'||length(s_lista_3)||' N: '||REGEXP_COUNT(s_lista_3,',', 1, 'i')||' FO: '||SUBSTR(s_lista_3,1, 6)||' LO: '||SUBSTR(s_lista_3,length(s_lista_3)-7));

END GetStringhe1000;

END PKG_RINF_WORK_UTILITY;
/