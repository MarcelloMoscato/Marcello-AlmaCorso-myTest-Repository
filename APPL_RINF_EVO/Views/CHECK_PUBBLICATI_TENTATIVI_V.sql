--
-- CHECK_PUBBLICATI_TENTATIVI_V  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.CHECK_PUBBLICATI_TENTATIVI_V
(VERSIONE, TENTATIVI)
BEQUEATH DEFINER
AS 
Select Versione, Tentativi from
(
with dettaglio as (
Select id_log, data_attivita, substr(testo, 39) testo_red, ltrim(to_char(substr(testo, 77, 3))) versione
from log_history
where testo like '%Fine produzione XML registro Versione%'
) 
select Versione, count(*) Tentativi -- dettaglio.versione, count (*) tentativi
from dettaglio
group by versione
)
order by 1 desc;
