--
-- CHECK_LOG_IMPORTANT  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.CHECK_LOG_IMPORTANT
(ID_LOG, CODICE_ATTIVITA, DATA_ATTIVITA, TESTO, ID_UTENTE)
BEQUEATH DEFINER
AS 
SELECT
    id_log,
    codice_attivita,
    data_attivita,
    testo,
    id_utente
FROM
    log_history
where
    codice_attivita <> 1
    and UPPER(testo) not like 'MAIL'
order by
    id_log desc;
