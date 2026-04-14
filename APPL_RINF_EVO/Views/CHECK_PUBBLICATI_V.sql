--
-- CHECK_PUBBLICATI_V  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.CHECK_PUBBLICATI_V
(VERSIONE, ATTIVITA)
BEQUEATH DEFINER
AS 
with RI_Fine as (
Select to_char(substr(testo, 77, 3)) versione, MAX(ID_LOG) id_log
from log_history
where testo like '%Fine produzione XML registro Versione%'
group by to_char(substr(testo, 77, 3))
having count(*) = 1
)
, RI_Avvio as (
Select to_char(substr(testo, 78, 3)) versione, MAX(ID_LOG) id_log
from log_history
where testo like '%Avvio produzione XML registro Versione%'
group by to_char(substr(testo, 78, 3))
having count(*) = 1
)
select 
--RI_Avvio.ID_Log,
RI_Avvio.Versione,
'Init: ' || log.data_attivita Attivita
from log_history log
join RI_Avvio on (to_char(substr(log.testo, 78, 3)) = RI_Avvio.versione)
WHERE LOG.TESTO LIKE '%produzione XML registro Versione%'

union

select 
--RI_Avvio.ID_Log,
RI_Fine.Versione,
'Fine: ' || log.data_attivita Attivita
from log_history log
join RI_Fine  on (to_char(substr(log.testo, 77, 3)) = RI_Fine.versione)
WHERE LOG.TESTO LIKE '%produzione XML registro Versione%'
order by 1 desc, 2 Desc;
