CREATE OR REPLACE PROCEDURE ASTROIF.PRO_INS_ANA_CLI
----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Procedura di inserimento record singolo in tabella CLIENTE
-- 
-- Restituisce:
--              P_OUT:
--                  1 se inserimento OK
--                  0 se inserimento NON OK
--                  3 se inserimento NON OK per duplicazione IDE_CLI
--
-- Data Creazione:  2011-02-22
-- Ultima Modifica: 2022-04-04
--
-- Cronologia modifiche:
--        2011-08-29: IDE_TIP_IPR impostato automaticamente a 3 ("Non applicabile") per IDE_TIP_CLI <> 3
--        2011-08-31: Correzione dell'impostazione predefinita di IDE_ABI_CLI: 4 in caso di IF, 0 in caso contrario
--        2011-11-18: Modifica valore restituito in P_OUT per chiave duplicata da -1 a 3
--        2012-03-30: Aggiunto dettaglio commenti
--        2012-11-09: Gestiti diritti d'accesso per richiedente autorizzato
--        2013-02-06: AGGIUNTO LOGGING OPERAZIONE
--        2013-02-07: GESTITA ABILITAZIONE AUTOMATICA DEL RICHIEDENTE AUTORIZZATO
--        2013-08-20: CORRETTA GESTIONE ABILITAZIONE PER IF APPARTENENTI A MASTER ESISTENTE 
--		  2014-05-09: Gestione IDE_CLI in LOG
--		2021-03-16: Gestione del Tipo Traffico Prevalente - IDE_TIP_TRA_CLI
--		2021-05-07: Gestione della Sigla Cliente - SIG_CLI
--		2022-04-04: Associazione automatica di una nuova Impresa Ferroviaria al Gruppo RFICO
--
----------------------------------------------------------------------------------------------------------------------------------
  (
  P_IDE_UTE         IN NUMBER,                  -- IDENTIFICATIVO UTENTE                  
  P_IDR_MAC_CLE     IN VARCHAR2,                -- IP CLIENT
  P_ORI             IN VARCHAR2,                -- URL PAGINA
  --    
   P_IDE_CLI      IN  NUMBER,                   -- IDENTIFICATIVO CLIENTE
   P_NOM_CLI      IN  VARCHAR2,                 -- DENOMINAZIONE
   P_COD_CLI_RFI  IN  NUMBER    DEFAULT NULL,   -- CODICE CLIENTE RFI
   P_IDE_TIP_CLI  IN  NUMBER,                   -- IDENTIFICATIVO TIPO CLIENTE
   P_IDE_CLI_MSE  IN  NUMBER,                   -- IDENTIFICATIVO CLIENTE MASTER
   P_IDE_TIP_IPR  IN  NUMBER,                   -- IDENTIFICATIVO TIPO IMPRESA
   P_IDE_TIP_TRA_CLI In Number,  -- Identificativo del Tipo di Traffico del Cliente (Tipo Traffico Prevalente) - Foreign Key alla struttura Ana_Tip_Tra_Cli
   P_SIG_CLI In Varchar2,  -- Sigla associata al Cliente
   --
   P_COD_ERR      OUT VARCHAR2,                 -- CODICE ERRORE
   P_DES_ERR      OUT VARCHAR2,                 -- DESCRIZIONE ERRORE
   P_OUT          OUT NUMBER                     -- ESITO PROCEDURA
  )
  IS
  V_USR VARCHAR2(500);
  V_IDE_LOG_OPE NUMBER;
  V_DES_OPE VARCHAR2(4000);
  V_IDE_GRP NUMBER;  
  V_NOM_OPE VARCHAR2(1000);  
  V_DES_TIP_CLI VARCHAR2(100);
  V_IDE_ABI_CLI NUMBER;

  Tipo_Traffico_Nullo Exception;
  Pragma Exception_Init(Tipo_Traffico_Nullo,-20101);

  BEGIN
	If (P_IDE_TIP_TRA_CLI is null) Then
		Raise_Application_Error(-20101,'Tipo Traffico Prevalente NON Specificato');
	End If;

    SELECT DES_TIP_CLI
    INTO V_DES_TIP_CLI
    FROM ANA_TIP_CLI
    WHERE IDE_TIP_CLI = P_IDE_TIP_CLI;    
    INSERT INTO ANA_CLI
     (IDE_CLI, NOM_CLI, COD_CLI_RFI, IDE_TIP_CLI, IDE_ABI_CLI, IDE_CLI_MSE, IDE_TIP_IPR, IDE_TIP_TRA_CLI, SIG_CLI)
    VALUES
     (
		P_IDE_CLI, P_NOM_CLI,
		LPAD(P_COD_CLI_RFI,3,'0'),    -- FORMATTAZIONE A 3 CIFRE
		P_IDE_TIP_CLI,
		DECODE(P_IDE_TIP_CLI,3,4,1,1,0),  -- IMPRESA FERROVIARIA (IDE_TIP_CLI = 3)    => "SENZA LICENZA" (IDE_ABI_CLI = 4)
									-- CLIENTE (IDE_TIP_CLI = 2) => "SENZA ACCESSO" (IDE_ABI_CLI = 0)
									-- RICHIEDENTE (IDE_TIP_CLI = 1) => "ABILITATA" (IDE_ABI_CLI = 1)
		P_IDE_CLI_MSE,
		DECODE(P_IDE_TIP_CLI,3,P_IDE_TIP_IPR,3), -- PER CLIENTE, RICHIEDENTE ASSUME SEMPRE VALORE "NON APPLICABILE"
												-- (NON HA SENSO PARLARE DI RICHIEDENTE/CLIENTE SINGOLO O DI GRUPPO) 
		P_IDE_TIP_TRA_CLI,
		P_SIG_CLI
	 );
  --COMMIT;  
  -- GESTIONE ABILITAZIONE IF
  IF P_IDE_TIP_CLI = 3 AND P_IDE_TIP_IPR = 2 THEN
    -- IF DI GRUPPO:
        -- SE ESISTE LICENZA => "ABILITATA" (IDE_ABI_CLI = 1)
        -- SE NON ESISTE LICENZA => "SENZA LICENZA" (IDE_ABI_CLI = 4)
    SELECT DECODE(COUNT(*),0,4,1)
    INTO V_IDE_ABI_CLI
    FROM ANA_LIC
    WHERE IDE_CLI_MSE = P_IDE_CLI_MSE;
    --          
    UPDATE ANA_CLI
    SET IDE_ABI_CLI = V_IDE_ABI_CLI
    WHERE IDE_CLI = P_IDE_CLI;
  END IF;  
  -- INSERIMENTO DIRITTI D'ACCESSO PER RFIDC, RFICV, RFICM (TIPO GRUPPO 0,2) IN CASO DI RICHIEDENTE AUTORIZZATO
  IF P_IDE_TIP_CLI = 1 THEN
    INSERT INTO ASC_CLI_OPA_RFI (IDE_CLI, IDE_OPA_RFI, DAT_INI, DAT_FIN)        
        SELECT P_IDE_CLI, IDE_OPA_RFI, TRUNC(SYSDATE), TO_DATE('29991231','YYYYMMDD')
        FROM ANA_OPA_RFI NATURAL JOIN ASC_GRP_OPA_RFI NATURAL JOIN ANA_GRP
        WHERE IDE_TIP_GRP IN (0,2);    
  END IF;

	If (P_Ide_Tip_Cli = 3) Then
		insert into AstroIF.Asc_Cli_Opa_RFI
		(
			Ide_Cli,
			Ide_Opa_RFI,
			Dat_Ini,
			Dat_Fin
		)
		values
		(
			P_Ide_Cli,
			4,
			trunc(SysDate),
			to_date('29991231','yyyymmdd')
		);
	End If;

       -- LOGGING OPERAZIONE
        SELECT
        'DENOMINAZIONE: ' || P_NOM_CLI
        || CHR(13) || 'TIPO: ' || V_DES_TIP_CLI
        INTO V_DES_OPE
        FROM DUAL;       
        SELECT USR INTO V_USR FROM ANA_UTE WHERE IDE_UTE = P_IDE_UTE;
        SELECT IDE_GRP INTO V_IDE_GRP FROM ASC_UTE_GRP WHERE IDE_UTE = P_IDE_UTE;
        SELECT SEQ_LOG_OPE.NEXTVAL INTO V_IDE_LOG_OPE FROM DUAL;
        INSERT INTO LOG_OPE (IDE_LOG_OPE,DAT_OPE,NOM_OPE,USR,DES_OPE,IDR_MAC_CLE,ORI,IDE_GRP,IDE_CLI)
                            VALUES (V_IDE_LOG_OPE,SYSDATE,'INSERIMENTO CLIENTE',V_USR,V_DES_OPE,P_IDR_MAC_CLE,P_ORI,V_IDE_GRP,P_IDE_CLI);                                    
        -- FINE LOGGING   
  P_OUT := 1;  
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN      -- DUPLICAZIONE IDE_CLI
       P_COD_ERR := SQLCODE;
       P_DES_ERR := SQLERRM;
       P_OUT := 3;
    WHEN OTHERS THEN
       P_COD_ERR := SQLCODE;
       P_DES_ERR := SQLERRM;
       P_OUT := 0;
       -- LOGGING OPERAZIONE
        SELECT
        'DENOMINAZIONE: ' || P_NOM_CLI
        || CHR(13) || 'TIPO: ' || V_DES_TIP_CLI
        INTO V_DES_OPE
        FROM DUAL;       
        SELECT USR INTO V_USR FROM ANA_UTE WHERE IDE_UTE = P_IDE_UTE;
        SELECT IDE_GRP INTO V_IDE_GRP FROM ASC_UTE_GRP WHERE IDE_UTE = P_IDE_UTE;
        SELECT SEQ_LOG_OPE.NEXTVAL INTO V_IDE_LOG_OPE FROM DUAL;
        INSERT INTO LOG_OPE (IDE_LOG_OPE,DAT_OPE,NOM_OPE,USR,DES_OPE,IDR_MAC_CLE,ORI,IDE_GRP,IDE_CLI)
                            VALUES (V_IDE_LOG_OPE,SYSDATE,'INSERIMENTO CLIENTE FALLITO',V_USR,V_DES_OPE,P_IDR_MAC_CLE,P_ORI,V_IDE_GRP,P_IDE_CLI);                                    
        -- FINE LOGGING          
  END;
/


GRANT EXECUTE ON ASTROIF.PRO_INS_ANA_CLI TO ASTROIF_APP;

CREATE OR REPLACE SYNONYM ASTROIF_APP.PRO_INS_ANA_CLI FOR ASTROIF.PRO_INS_ANA_CLI;
