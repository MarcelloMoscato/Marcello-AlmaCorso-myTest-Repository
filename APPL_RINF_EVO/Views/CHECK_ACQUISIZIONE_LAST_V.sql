--
-- CHECK_ACQUISIZIONE_LAST_V  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.CHECK_ACQUISIZIONE_LAST_V
(DATA, AVVIO, OPERATORE, DURATA, STAGING, 
 NOTIFICA, CONTROLLI, NOTIFICA_ANOM, CACHE, STAGING_END, 
 NOTIFICA_END, CONTROL_END, NOTIFICA_ANOM_END, END)
BEQUEATH DEFINER
AS 
with LastLaunch as (
Select max (id_log) id_log, max(data_attivita) Avvio
From log_history
    WHERE TESTO LIKE '%è stato lanciato un ciclo di acquisizione!%'
)
SELECT 
    TO_CHAR(HIS.data_attivita,'yyyy/mm/dd') Data,
    TO_CHAR(HIS.data_attivita,'HH24:MI:SS')  Avvio,
    -- HIS.data_attivita    ORARIO,
    '[' || HIS.id_utente || '] ' || UTE.NOME ||' '||UTE.COGNOME  OPERATORE,
    DECODE(TRUNC((Cache_Fine.ORARIO        - LastLaunch.Avvio)    * 24),0,MOD(TRUNC((Cache_Fine.ORARIO        - LastLaunch.Avvio)    * 24 * 60), 60)||':'||MOD(TRUNC((Cache_Fine.ORARIO        - LastLaunch.Avvio)    * 24 * 60 * 60), 60)||'',TRUNC((Cache_Fine.ORARIO - LastLaunch.Avvio)           * 24)||':'||MOD(TRUNC((Cache_Fine.ORARIO        - LastLaunch.Avvio)    * 24 * 60), 60)||':'||MOD(TRUNC((Cache_Fine.ORARIO        - LastLaunch.Avvio)    * 24 * 60 * 60), 60)||'') DURATA,
    DECODE(TRUNC((Staging_Fine.ORARIO      - LastLaunch.Avvio)    * 24),0,MOD(TRUNC((Staging_Fine.ORARIO      - LastLaunch.Avvio)    * 24 * 60), 60)||':'||MOD(TRUNC((Staging_Fine.ORARIO      - LastLaunch.Avvio)    * 24 * 60 * 60), 60)||'',TRUNC((Staging_Fine.ORARIO - LastLaunch.Avvio)         * 24)||':'||MOD(TRUNC((Staging_Fine.ORARIO      - LastLaunch.Avvio)    * 24 * 60), 60)||':'||MOD(TRUNC((Staging_Fine.ORARIO      - LastLaunch.Avvio)    * 24 * 60 * 60), 60)||'') STAGING,
    DECODE(TRUNC((Comm_Acquisizione.ORARIO - Staging_Fine.ORARIO) * 24),0,MOD(TRUNC((Comm_Acquisizione.ORARIO - Staging_Fine.ORARIO) * 24 * 60), 60)||':'||MOD(TRUNC((Comm_Acquisizione.ORARIO - Staging_Fine.ORARIO) * 24 * 60 * 60), 60)||'',TRUNC((Comm_Acquisizione.ORARIO - Staging_Fine.ORARIO) * 24)||':'||MOD(TRUNC((Comm_Acquisizione.ORARIO - Staging_Fine.ORARIO) * 24 * 60), 60)||' m. + '||MOD(TRUNC((Comm_Acquisizione.ORARIO - Staging_Fine.ORARIO) * 24 * 60 * 60), 60)||'') NOTIFICA,
    DECODE(TRUNC((Control_Fine.ORARIO - Comm_Acquisizione.ORARIO) * 24),0,MOD(TRUNC((Control_Fine.ORARIO - Comm_Acquisizione.ORARIO) * 24 * 60), 60)||':'||MOD(TRUNC((Control_Fine.ORARIO - Comm_Acquisizione.ORARIO) * 24 * 60 * 60), 60)||'',TRUNC((Control_Fine.ORARIO - Comm_Acquisizione.ORARIO) * 24)||':'||MOD(TRUNC((Control_Fine.ORARIO - Comm_Acquisizione.ORARIO) * 24 * 60), 60)||' m. + '||MOD(TRUNC((Control_Fine.ORARIO - Comm_Acquisizione.ORARIO) * 24 * 60 * 60), 60)||'') CONTROLLI,
    DECODE(TRUNC((Comm_Anomalie.ORARIO     - Control_Fine.ORARIO) * 24),0,MOD(TRUNC((Comm_Anomalie.ORARIO     - Control_Fine.ORARIO) * 24 * 60), 60)||':'||MOD(TRUNC((Comm_Anomalie.ORARIO     - Control_Fine.ORARIO) * 24 * 60 * 60), 60)||'',TRUNC((Comm_Anomalie.ORARIO - Control_Fine.ORARIO)     * 24)||':'||MOD(TRUNC((Comm_Anomalie.ORARIO     - Control_Fine.ORARIO) * 24 * 60), 60)||' m. + '||MOD(TRUNC((Comm_Anomalie.ORARIO     - Control_Fine.ORARIO) * 24 * 60 * 60), 60)||'') NOTIFICA_ANOM,
    DECODE(TRUNC((Cache_Fine.ORARIO        - Comm_Anomalie.ORARIO)* 24),0,MOD(TRUNC((Cache_Fine.ORARIO        - Comm_Anomalie.ORARIO)* 24 * 60), 60)||':'||MOD(TRUNC((Cache_Fine.ORARIO        - Comm_Anomalie.ORARIO)* 24 * 60 * 60), 60)||'',TRUNC((Cache_Fine.ORARIO - Comm_Anomalie.ORARIO)       * 24)||':'||MOD(TRUNC((Cache_Fine.ORARIO        - Comm_Anomalie.ORARIO)* 24 * 60), 60)||' m. + '||MOD(TRUNC((Cache_Fine.ORARIO        - Comm_Anomalie.ORARIO)* 24 * 60 * 60), 60)||'') CACHE,
    TO_CHAR(Staging_Fine.ORARIO, 'HH24:MI:SS') Staging_END,
    TO_CHAR(Comm_Acquisizione.ORARIO, 'HH24:MI:SS') Notifica_END,
    TO_CHAR(Control_Fine.ORARIO, 'HH24:MI:SS') Control_END,
    TO_CHAR(Comm_Anomalie.ORARIO, 'HH24:MI:SS') Notifica_Anom_END,
    TO_CHAR(Cache_Fine.ORARIO, 'HH24:MI:SS') END
FROM APPL_RINF_EVO.LOG_HISTORY    HIS
JOIN RINF_SICUREZZA_EVO.ANAG_UTENTE UTE on UTE.ID_UTENTE = HIS.ID_UTENTE
JOIN LastLaunch ON (LastLaunch.ID_LOG = HIS.ID_LOG)

LEFT OUTER JOIN (
SELECT
    HIS.ID_LOG,
    HIS.data_attivita ORARIO
FROM APPL_RINF_EVO.LOG_HISTORY  HIS
WHERE HIS.TESTO LIKE '%Ciclo di acquisizione STEP 1 completato%'
-- AND LastLaunch.ID_LOG < HIS_AE.ID_LOG 
)  Staging_Fine
ON Staging_Fine.ID_LOG > LastLaunch.ID_LOG

LEFT OUTER JOIN (
SELECT
    HIS.id_log,
    HIS.data_attivita     ORARIO
    --INSTR (HIS.TESTO, '%sto avviando i controlli per l%') TRANSACTION_ID
    FROM APPL_RINF_EVO.LOG_HISTORY    HIS
    WHERE HIS.TESTO LIKE '%sto avviando i controlli per l%'
)  Comm_Acquisizione
ON Comm_Acquisizione.ID_LOG > LastLaunch.ID_LOG

LEFT OUTER JOIN (
SELECT
    HIS.id_log,
    HIS.data_attivita     ORARIO
FROM APPL_RINF_EVO.LOG_HISTORY    HIS
WHERE HIS.TESTO LIKE '%I controlli sono terminati%'
)  Control_Fine      
ON Control_Fine.ID_LOG > LastLaunch.ID_LOG

LEFT OUTER JOIN (
SELECT
    HIS.id_log,
    HIS.data_attivita     ORARIO
    FROM APPL_RINF_EVO.LOG_HISTORY    HIS
    WHERE HIS.TESTO LIKE '%L''acquisizione è terminata con esito%'
)    Comm_Anomalie      
ON Comm_Anomalie.ID_LOG > LastLaunch.ID_LOG

LEFT OUTER JOIN (
SELECT
    HIS.ID_LOG           ID_LOG,
    HIS.data_attivita     ORARIO
FROM APPL_RINF_EVO.LOG_HISTORY    HIS
WHERE HIS.TESTO LIKE '%La generazione della cache è terminata%'
)   Cache_Fine      
ON Cache_Fine.ID_LOG > LastLaunch.ID_LOG;
