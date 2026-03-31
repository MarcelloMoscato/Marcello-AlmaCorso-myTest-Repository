CREATE OR REPLACE
PROCEDURE ASTROIF.PRO_INS_ASC_CLI_OPA_RFI
------------------------------------------------------------------
-- 
-- Procedura di INSERIMENTO ASSOCIATIVA CLIENTE - OPERATORE RFI
-- 
-- 
-- RESTITUISCE
--              P_OUT:
--                  1 => INSERIMENTO OK
--                  2 => INSERIMENTO NON OK
--
-- Data Creazione:  2011-07-26
-- Ultima Modifica: 2012-03-30
--
-- Cronologia modifiche:
--                  2012-03-30: Aggiunto dettaglio commenti
--
-- NOTE:
--      Implementa la funzione dei DIRITTI D'ACCESSO   
------------------------------------------------------------------
(
P_IDE_CLI IN NUMBER,            -- IDENTIFICATIVO CLIENTE
P_IDE_OPA_RFI IN NUMBER,        -- IDENTIFICATIVO OPERATORE RFI
P_DAT_INI IN DATE,              -- DATA INIZIO ASSOCIAZIONE OPERATORE / CLIENTE
P_DAT_FIN IN DATE,              -- DATA FINE ASSOCIAZIONE OPERATORE / CLIENTE
--
P_COD_ERR      OUT VARCHAR2,    -- CODICE ERRORE
P_DES_ERR      OUT VARCHAR2,    -- DESCRIZIONE ERRORE
P_OUT          OUT NUMBER       -- ESITO PROCEDURA
)
IS
BEGIN
   INSERT INTO ASC_CLI_OPA_RFI (IDE_CLI, IDE_OPA_RFI, DAT_INI, DAT_FIN)
   VALUES (P_IDE_CLI, P_IDE_OPA_RFI, P_DAT_INI, P_DAT_FIN);
   COMMIT;
    P_OUT := 1;
EXCEPTION
    WHEN OTHERS THEN
       P_COD_ERR := SQLCODE;
       P_DES_ERR := SQLERRM;
       P_OUT := 0;
END;
/

GRANT EXECUTE ON ASTROIF.PRO_INS_ASC_CLI_OPA_RFI TO ASTROIF_APP;

CREATE OR REPLACE SYNONYM ASTROIF_APP.PRO_INS_ASC_CLI_OPA_RFI FOR ASTROIF.PRO_INS_ASC_CLI_OPA_RFI;




