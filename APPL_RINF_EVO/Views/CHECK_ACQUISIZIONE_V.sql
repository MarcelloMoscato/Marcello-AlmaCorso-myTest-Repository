--
-- CHECK_ACQUISIZIONE_V  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.CHECK_ACQUISIZIONE_V
(DATA, AVVIO, FINE, FULL, LOGS, 
 OPERATOR)
BEQUEATH DEFINER
AS 
SELECT
to_char (Attivazione.ORARIO, 'yyyy/mm/dd') Data,
TO_CHAR(Attivazione.ORARIO,'HH24:MI:SS')  Avvio,
TO_CHAR(Cache_Fine.ORARIO,'HH24:MI:SS')  FINE,
-- DECODE(TRUNC((Staging_Fine.ORARIO  - Attivazione.ORARIO)  * 24),0,MOD(TRUNC((Staging_Fine.ORARIO - Attivazione.ORARIO)        * 24 * 60), 60)||' m. + '||MOD(TRUNC((Staging_Fine.ORARIO - Attivazione.ORARIO)          * 24 * 60 * 60), 60)||' s.',TRUNC((Staging_Fine.ORARIO - Attivazione.ORARIO)          * 24)||' h. + '||MOD(TRUNC((Staging_Fine.ORARIO - Attivazione.ORARIO)          * 24 * 60), 60)||' m. + '||MOD(TRUNC((Staging_Fine.ORARIO   - Attivazione.ORARIO) * 24 * 60 * 60), 60)||' s.')   
-- STAGING,
-- DECODE(TRUNC((Comm_Acquisizione.ORARIO  - Staging_Fine.ORARIO) * 24),0,MOD(TRUNC((Comm_Acquisizione.ORARIO - Staging_Fine.ORARIO)   * 24 * 60), 60)||' m. + '||MOD(TRUNC((Comm_Acquisizione.ORARIO - Staging_Fine.ORARIO)     * 24 * 60 * 60), 60)||' s.',TRUNC((Comm_Acquisizione.ORARIO - Staging_Fine.ORARIO)   * 24)||' h. + '||MOD(TRUNC((Comm_Acquisizione.ORARIO - Staging_Fine.ORARIO)   * 24 * 60), 60)||' m. + '||MOD(TRUNC((Comm_Acquisizione.ORARIO - Staging_Fine.ORARIO) * 24 * 60 * 60), 60)||' s.') 
-- NOTIFICA,
-- DECODE(TRUNC((Control_Fine.ORARIO  - Staging_Fine.ORARIO) * 24),0,MOD(TRUNC((Control_Fine.ORARIO - Staging_Fine.ORARIO)   * 24 * 60), 60)||' m. + '||MOD(TRUNC((Control_Fine.ORARIO - Staging_Fine.ORARIO)     * 24 * 60 * 60), 60)||' s.',TRUNC((Control_Fine.ORARIO - Staging_Fine.ORARIO)   * 24)||' h. + '||MOD(TRUNC((Control_Fine.ORARIO - Staging_Fine.ORARIO)   * 24 * 60), 60)||' m. + '||MOD(TRUNC((Control_Fine.ORARIO - Staging_Fine.ORARIO) * 24 * 60 * 60), 60)||' s.') 
-- CONTROLLI,
-- DECODE(TRUNC((Comm_Anomalie.ORARIO - Control_Fine.ORARIO) * 24),0,MOD(TRUNC((Comm_Anomalie.ORARIO   - Control_Fine.ORARIO) * 24 * 60), 60)||' m. + '||MOD(TRUNC((Comm_Anomalie.ORARIO   - Control_Fine.ORARIO) * 24 * 60 * 60), 60)||' s.',TRUNC((Comm_Anomalie.ORARIO - Control_Fine.ORARIO) * 24)||' h. + '||MOD(TRUNC((Comm_Anomalie.ORARIO - Control_Fine.ORARIO) * 24 * 60), 60)||' m. + '||MOD(TRUNC((Comm_Anomalie.ORARIO     - Control_Fine.ORARIO) * 24 * 60 * 60), 60)||' s.')   
-- NOTIFICA_ANOM,
-- DECODE(TRUNC((Cache_Fine.ORARIO    - Comm_Anomalie.ORARIO) * 24),0,MOD(TRUNC((Cache_Fine.ORARIO   - Comm_Anomalie.ORARIO) * 24 * 60), 60)||' m. + '||MOD(TRUNC((Cache_Fine.ORARIO   - Comm_Anomalie.ORARIO) * 24 * 60 * 60), 60)||' s.',TRUNC((Cache_Fine.ORARIO - Comm_Anomalie.ORARIO) * 24)||' h. + '||MOD(TRUNC((Cache_Fine.ORARIO - Comm_Anomalie.ORARIO) * 24 * 60), 60)||' m. + '||MOD(TRUNC((Cache_Fine.ORARIO     - Comm_Anomalie.ORARIO) * 24 * 60 * 60), 60)||' s.')   
-- CACHE,
DECODE(TRUNC((Cache_Fine.ORARIO    - Attivazione.ORARIO)  * 24),0,MOD(TRUNC((Cache_Fine.ORARIO - Attivazione.ORARIO)          * 24 * 60), 60)||' m. + '||MOD(TRUNC((Cache_Fine.ORARIO   - Attivazione.ORARIO)          * 24 * 60 * 60), 60)||' s.',TRUNC((Cache_Fine.ORARIO - Attivazione.ORARIO)            * 24)||' h. + '||MOD(TRUNC((Cache_Fine.ORARIO - Attivazione.ORARIO)            * 24 * 60), 60)||' m. + '||MOD(TRUNC((Cache_Fine.ORARIO     - Attivazione.ORARIO) * 24 * 60 * 60), 60)||' s.')   
FULL,
Attivazione.ID_LOG || '-' || Cache_Fine.ID_LOG LOGS,
'[' || Attivazione.ACQ_ID_OPERATORE || '] ' || Attivazione.ACQ_OPERATORE Operator
-- Verbose
-- TO_CHAR(Staging_Fine.ORARIO,'HH24:MI:SS')  Staging_END,
-- TO_CHAR(Comm_Acquisizione.ORARIO,'HH24:MI:SS')  Notifica_END,
-- TO_CHAR(Control_Fine.ORARIO,'HH24:MI:SS')  Control_END,
-- TO_CHAR(Comm_Anomalie.ORARIO,'HH24:MI:SS')  Notifica_Anom_END
FROM (
SELECT
      HIS.ID_LOG ID_LOG,
      HIS.data_attivita    ORARIO,
      HIS.id_utente        ACQ_ID_OPERATORE,
      UTE.NOME||' '||UTE.COGNOME    ACQ_OPERATORE
      FROM APPL_RINF_EVO.LOG_HISTORY    HIS
      JOIN RINF_SICUREZZA_EVO.ANAG_UTENTE   UTE  ON (HIS.ID_UTENTE = UTE.ID_UTENTE)
      WHERE HIS.TESTO LIKE '%è stato lanciato un ciclo di acquisizione!%')   Attivazione
LEFT OUTER JOIN (SELECT
                 HIS.data_attivita     ORARIO
                 FROM APPL_RINF_EVO.LOG_HISTORY    HIS
                 WHERE HIS.TESTO LIKE '%Ciclo di acquisizione STEP 1 completato%')  Staging_Fine
ON (TO_CHAR(Attivazione.ORARIO,'YYYYMMDD') = TO_CHAR(Staging_Fine.ORARIO,'YYYYMMDD'))
LEFT OUTER JOIN (SELECT
                 HIS.data_attivita     ORARIO,
                 INSTR (HIS.TESTO, '%sto avviando i controlli per l%') TRANSACTION_ID
                 FROM APPL_RINF_EVO.LOG_HISTORY    HIS
                 WHERE HIS.TESTO LIKE '%sto avviando i controlli per l%')  Comm_Acquisizione
ON (TO_CHAR(Attivazione.ORARIO,'YYYYMMDD') = TO_CHAR(Comm_Acquisizione.ORARIO,'YYYYMMDD'))

LEFT OUTER JOIN (SELECT
                 HIS.data_attivita     ORARIO
                 FROM APPL_RINF_EVO.LOG_HISTORY    HIS
                 WHERE HIS.TESTO LIKE '%I controlli sono terminati%')  Control_Fine
ON (TO_CHAR(Attivazione.ORARIO,'YYYYMMDD') = TO_CHAR(Control_Fine.ORARIO,'YYYYMMDD'))

LEFT OUTER JOIN (SELECT
                 HIS.data_attivita     ORARIO
                 FROM APPL_RINF_EVO.LOG_HISTORY    HIS
                 WHERE HIS.TESTO LIKE '%L''acquisizione è terminata con esito%')    Comm_Anomalie
ON (TO_CHAR(Attivazione.ORARIO,'YYYYMMDD') = TO_CHAR(Comm_Anomalie.ORARIO,'YYYYMMDD'))
LEFT OUTER JOIN (SELECT
				 HIS.ID_LOG           ID_LOG,
                 HIS.data_attivita     ORARIO
                 FROM APPL_RINF_EVO.LOG_HISTORY    HIS
                 WHERE HIS.TESTO LIKE '%La generazione della cache è terminata%')   Cache_Fine
ON (TO_CHAR(Attivazione.ORARIO,'YYYYMMDD') = TO_CHAR(Cache_Fine.ORARIO,'YYYYMMDD'))
WHERE Cache_Fine.ID_LOG IS NOT NULL
ORDER BY Attivazione.ID_LOG DESC;
