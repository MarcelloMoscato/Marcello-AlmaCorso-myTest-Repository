--
-- CHECK_ACQUISIZIONE_TEST_V  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.CHECK_ACQUISIZIONE_TEST_V
(DAY_ATTIVITA, STATUS, COUNTER)
BEQUEATH DEFINER
AS 
with completeLaunch as (
Select id_log, data_attivita, to_char(data_attivita, 'dd/mm/yyyy') day_attivita, 
case
when  INSTR(testo, 'La generazione della cache è terminata') > 0 then 'FineProc'
/*
when  INSTR(testo, 'L''acquisizione è terminata con esito') > 0 then 'FineAcqu'
when  INSTR(testo, 'I controlli sono terminati') > 0 then 'FineCtrl'
when  INSTR(testo, 'sto avviando i controlli per l') > 0 then 'InitCtrl'
when  INSTR(testo, 'Ciclo di acquisizione STEP 1 completato') > 0 then 'FineStag'
*/
when  INSTR(testo, 'è stato lanciato un ciclo di acquisizione!') > 0 then 'InitProc'
else
    'Undetermined'
end STATUS

From log_history
    WHERE TESTO LIKE '%La generazione della cache è terminata%'
/*    
       or TESTO LIKE '%L''acquisizione è terminata con esito%'
       or TESTO LIKE '%I controlli sono terminati%'
       or TESTO LIKE '%sto avviando i controlli per l%'
       or TESTO LIKE '%Ciclo di acquisizione STEP 1 completato%'
       or TESTO LIKE '%è stato lanciato un ciclo di acquisizione!%'
*/       
       or TESTO LIKE '%è stato lanciato un ciclo di acquisizione!%'
order by id_log desc
)
select day_attivita, status, count(*) COUNTER
from completeLaunch 
group by day_attivita, status
order by 1, 2;
