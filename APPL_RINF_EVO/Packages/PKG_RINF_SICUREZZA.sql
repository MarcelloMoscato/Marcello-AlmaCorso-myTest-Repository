--
-- PKG_RINF_SICUREZZA  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_SICUREZZA" 
/*****************************************************************************
 vers.1.1 Modificata la gestione della cancellazione delle utenze Rinf DelUserId
 vers.1.2 Modificata la gestione dell'inserimento delle utenze Rinf SetNewUserId
 vers.1.3 Modificata la gestione dell'inserimento delle utenze Rinf SetNewUserId (gestione utenze case sensitive)

*****************************************************************************/
Is

TYPE empcur IS REF CURSOR;
PROCEDURE GetRolesForUsername (p_username VARCHAR2,p_cursor OUT empcur);
PROCEDURE GetRolesForUserId(p_userid NUMBER,p_cursor OUT empcur);
PROCEDURE GetAllRoles  (p_cursor OUT empcur);
PROCEDURE GetAllIneRoles (p_cursor OUT empcur);
PROCEDURE GetAllUsers (p_cursor OUT empcur);
PROCEDURE GetMenuForUserId(p_userid NUMBER,p_cursor OUT empcur);
PROCEDURE DelUserId (p_userid NUMBER,p_error OUT NUMBER);
PROCEDURE SetNewUserId (p_CODICE_UTENTE          VARCHAR2,
                           p_MATRICOLA              VARCHAR2   ,
                           p_NOME                   VARCHAR2 ,
                           p_COGNOME                VARCHAR2 ,
                           p_TELEFONO               VARCHAR2 ,
                           p_CELLULARE              VARCHAR2 ,
                           p_E_MAIL                 VARCHAR2 ,
                           p_error OUT NUMBER);
PROCEDURE SetInfoUserId (p_ID_UTENTE              NUMBER,
                            p_CODICE_UTENTE          VARCHAR2,
                            p_MATRICOLA              VARCHAR2,
                            p_NOME                   VARCHAR2,
                            p_COGNOME                VARCHAR2,
                            p_TELEFONO               VARCHAR2,
                            p_CELLULARE              VARCHAR2,
                            p_E_MAIL                 VARCHAR2,
                            p_error              OUT NUMBER);


PROCEDURE SetUserNameRoleString (p_username VARCHAR2, s_role VARCHAR2,p_flag_notifica IN NUMBER,p_error OUT NUMBER);
FUNCTION GetUserID (p_username VARCHAR2) RETURN NUMBER;
FUNCTION GetUserCode (p_userid NUMBER) RETURN VARCHAR2;
FUNCTION GetUserName (p_userid NUMBER) RETURN VARCHAR2;
PROCEDURE GetMailByEvent (p_EventId in number, p_DtpId in VARCHAR2 default null, p_ParId in number default null, p_CodiceAcquisizione in NUMBER default null, p_DataScadenza in varchar2 default null, p_UserId number default null, p_CodiceRichiesta in number default null, p_Versione IN NUMBER DEFAULT NULL,p_cursor OUT empcur);
Procedure GetReportMail (p_CodiceAcquisizione in NUMBER , p_IDUTENTE in NUMBER, p_cursor OUT empcur) ;
Procedure GetFooter (p_cursor OUT empcur) ;

PROCEDURE SetUserAuthorizationRequest (p_userid NUMBER, p_error OUT NUMBER);
FUNCTION GetUserIDServizio RETURN NUMBER ;
END;
/


--
-- PKG_RINF_SICUREZZA  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_SICUREZZA" Is

/*****************************************************************************
 vers.1.1 Modificata la gestione della cancellazione delle utenze Rinf DelUserId

*****************************************************************************/

  Function GetUserID (p_username VARCHAR2)
   Return Number Is
         n_id_utente Number;
   Begin
    Select ID_UTENTE into n_id_utente
      From Rinf_Sicurezza_Evo.ANAG_UTENTE
     Where Upper(CODICE_UTENTE) = Upper(p_username);
--
   Return n_id_utente;
--   
  Exception
      When Others
      Then Return Null;
--
  End GetUserID;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--
 Function GetUserCode (p_userid NUMBER)
 Return VARCHAR2 Is
 s_codice_utente VARCHAR2(200);
--
 Begin
--
 Select CODICE_UTENTE 
   Into s_codice_utente
   From Rinf_Sicurezza_Evo.ANAG_UTENTE
  Where ID_UTENTE = p_userid;
--
 Return s_codice_utente;
-- 
 Exception
       When Others
       Then Return Null;
-- 
 END GetUserCode;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--

 Function GetUserName (p_userid Number)
 Return Varchar2 Is
-- 
 s_nome_utente Varchar2(200);
--
 Begin
 Select NOME||' '||COGNOME Into s_nome_utente
   From Rinf_Sicurezza_Evo.ANAG_UTENTE
  Where ID_UTENTE = p_userid;
--
 Return s_nome_utente;
--
 Exception
       When Others
       Then Return Null;
-- 
 END GetUserName;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--

Function GetUserIDServizio
   Return NUMBER Is
   n_id_utente   NUMBER;

--26/07/2018 Questa funzione è stata creata per scrivere nella tabella di log le exception
--delle procedure.
 Begin
--
   Select ID_UTENTE Into n_id_utente
     From Rinf_Sicurezza_Evo.ANAG_UTENTE
    Where ID_UTENTE In (Select ID_UTENTE From Rinf_Sicurezza_Evo.UTENTE_RUOLI
                         Where CODICE_RUOLO = 8 And Rownum = 1);
--
   Return n_id_utente;
--
Exception
   When Others
   Then
      Select Min (ID_UTENTE)
        Into n_id_utente
        From Rinf_Sicurezza_Evo.ANAG_UTENTE;
      Return n_id_utente;
--
End GetUserIDServizio;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--

   Procedure GetRolesForUsername (p_username VARCHAR2, p_cursor OUT empcur)
   Is
   Begin
--
      Open p_cursor For
--
         Select Distinct
                ID_UTENTE,
                CODICE_UTENTE,
                CODICE_RUOLO,
                DESCRIZIONE,
                COMMENTO,
                CODICE_DTP,
                CODICE_UT,
                --21/02/2017 aggiunto per gestire la molteplicità di sede centrale
                Case When AREA = 'SC' 
				     Then CODICE_TIPO_DEPOSITARIO
                     Else 0  --se non è un validatore di sede centrale ritorna 0
                End CODICE_RUOLO_ORGANIZZATIVO,
                Case When AREA = 'SC' 
				     Then CODICE_TIPO_DEPOSITARIO
                     Else 0  --se non è un validatore di sede centrale ritorna 0
                End CODICE_TIPO_DEPOSITARIO
           From Rinf_Sicurezza_Evo.V_UTENTE_RUOLO
          Where Upper(CODICE_UTENTE) = Upper(p_username)
            And  CODICE_RUOLO = 5                            -- 'VALIDATORE'        
--
          Union
--
          Select Distinct
                ID_UTENTE,
                CODICE_UTENTE,
                CODICE_RUOLO,
                DESCRIZIONE,
                COMMENTO,
                CODICE_DTP,
                CODICE_UT,
                CODICE_RUOLO_ORGANIZZATIVO,
                CODICE_TIPO_DEPOSITARIO
           From Rinf_Sicurezza_Evo.V_UTENTE_RUOLO
          Where Upper(CODICE_UTENTE) = Upper(p_username)
            And CODICE_RUOLO <> 5;                               -- Validatore
--
   Exception
      When Others  Then
         Open p_cursor For
            'Select Null ID_UTENTE,null CODICE_UTENTE,null CODICE_RUOLO, null DESCRIZIONE, null COMMENTO, null CODICE_DTP, null CODICE_UT, null CODICE_RUOLO_ORGANIZZATIVO from dual';
--
   End GetRolesForUsername;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--

   Procedure GetRolesForUserId (p_userid Number, p_cursor Out Empcur)  Is
--
   Begin
--
      Open p_cursor For
         Select Distinct 
		        ID_UTENTE,
                CODICE_UTENTE,
                CODICE_RUOLO,
                DESCRIZIONE,
                COMMENTO,
                CODICE_DTP,
                CODICE_UT,
                -- 12/01/2017 aggiunto per gestire la molteplicità di sede centrale
                Case When AREA = 'SC' 
				     Then CODICE_TIPO_DEPOSITARIO
                     Else 0                     --se non è un validatore di sede centrale ritorna 0
                End       CODICE_TIPO_DEPOSITARIO,
                0         CODICE_RUOLO_ORGANIZZATIVO
           From Rinf_Sicurezza_Evo.V_UTENTE_RUOLO
          Where ID_UTENTE = p_userid
            And CODICE_RUOLO = 5                    -- Validatore
--
        Union
--
         Select Distinct
                ID_UTENTE,
                CODICE_UTENTE,
                CODICE_RUOLO,
                DESCRIZIONE,
                COMMENTO,
                CODICE_DTP,
                CODICE_UT,
                CODICE_TIPO_DEPOSITARIO,
                CODICE_RUOLO_ORGANIZZATIVO
           From Rinf_Sicurezza_Evo.V_UTENTE_RUOLO
          Where ID_UTENTE = p_userid
            And CODICE_RUOLO <> 5;                -- validatore
--
   Exception
      When Others Then
         Open p_cursor For
            'Select Null ID_UTENTE,null CODICE_UTENTE,null CODICE_RUOLO, null DESCRIZIONE, null COMMENTO, null CODICE_DTP, null CODICE_UT, null CODICE_RUOLO_ORGANIZZATIVO from dual';
--
   End GetRolesForUserId;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--

   Procedure GetAllRoles (p_cursor Out Empcur)  Is
--
   Begin
--
      Open p_cursor For
         Select CODICE_RUOLO, DESCRIZIONE, COMMENTO
           From RINF_SICUREZZA_EVO.ANAG_RUOLO
           Where CODICE_RUOLO Not In (1000, 8);
--
   Exception
      When Others Then
         Open p_cursor For
            'select null CODICE_RUOLO, null DESCRIZIONE, null COMMENTO from dual';
--
   End GetAllRoles;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--

  Procedure GetAllIneRoles (p_cursor Out Empcur)   Is
--
   Begin
--
      Open p_cursor For
         Select CODICE_TIPO_DEPOSITARIO, 
		        SIGLA_TIPO_DEPOSITARIO, 
				DESCRIZIONE, 
				AREA
           From Rinf_Sicurezza_Evo.ANAG_TIPO_DEPOSITARIO
          Where CODICE_TIPO_DEPOSITARIO <> -1;
--
   Exception
      When Others Then
         Open p_cursor For
            'select null CODICE_TIPO_DEPOSITARIO, null SIGLA_TIPO_DEPOSITARIO, null DESCRIZIONE, null AREA from dual';
   End GetAllIneRoles;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--
   Procedure GetAllUsers (p_cursor OUT empcur)
   Is
--
   Begin
--
       Open p_cursor For
         Select ID_UTENTE,
                CODICE_UTENTE,
                MATRICOLA,
                NOME,
                COGNOME,
                TELEFONO,
                CELLULARE,
                E_MAIL,
                FLAG_MAIL
           From Rinf_Sicurezza_Evo.ANAG_UTENTE
          Where ID_UTENTE Not In (Select ID_UTENTE From Rinf_Sicurezza_Evo.UTENTE_RUOLI Where CODICE_RUOLO = 8)
            And FLAG_UTE_ABILITAZ <> 0;
--
   Exception
      When Others
      Then
         Open p_cursor For
            'select ID_UTENTE, null CODICE_UTENTE, null MATRICOLA, null NOME, null COGNOME,  null TELEFONO, null CELLULARE, null E_MAIL, null FLAG_MAIL from dual';
   End GetAllUsers;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--

   Procedure GetMenuForUserId (p_userid Number, p_cursor Out Empcur)   Is
   myStr varchar2(4000);
--
   Begin
--
        myStr := Null;
--
        If p_userid = 0 Then
               myStr := 'Select ID_UTENTE,'
                    ||' CODICE_UTENTE,'
                    ||' CODICE_MENU,'
                    ||' NOMEUNICOMULTILINGUA,'
                    ||' ID_PADRE,'||
                    ' CONTROLLER,'||
                    ' ACTION,'||
                    ' ATTIVO,'||
                    ' DEFAULTROLE'||
               ' From ('||
                    ' Select Distinct Null ID_UTENTE,'||
                        ' Null CODICE_UTENTE,'||
                        ' CODICE_MENU,'||
                        ' NOMEUNICOMULTILINGUA,'||
                        ' ID_PADRE,'||
                        ' CONTROLLER,'||
                        ' ACTION,'||
                        ' ATTIVO,'||
                        ' DEFAULTROLE, ID_ORDINA'||
                   ' From Rinf_Sicurezza_Evo.V_UTENTE_MENU'||
                  ' Where DEFAULTROLE = -1)'||
                ' Order By ID_ORDINA';
        Else
            myStr := ' Select ID_UTENTE,'
                    ||' CODICE_UTENTE,'
                    ||' CODICE_MENU,'
                    ||' NOMEUNICOMULTILINGUA,'
                    ||' ID_PADRE,'
                    ||' CONTROLLER,'
                    ||' ACTION,'
                    ||' ATTIVO,'
                    ||' DEFAULTROLE'
               ||' From Rinf_Sicurezza_Evo.V_UTENTE_MENU'
              ||' Where ID_UTENTE = ' ||p_userid
            ||' Order By ID_ORDINA';
        End If;
--
        dbms_output.put_line(myStr);
--
        Open p_cursor For myStr;
--
   Exception
      When Others  Then
--
        Open p_cursor For
             Select ID_UTENTE,
                    CODICE_UTENTE,
                    CODICE_MENU,
                    NOMEUNICOMULTILINGUA,
                    ID_PADRE,
                    CONTROLLER,
                    ACTION,
                    ATTIVO,
                    DEFAULTROLE
             From ( Select Distinct 
			            Null ID_UTENTE,
                        Null CODICE_UTENTE,
                        CODICE_MENU,
                        NOMEUNICOMULTILINGUA,
                        ID_PADRE,
                        CONTROLLER,
                        ACTION,
                        ATTIVO,
                        DEFAULTROLE, 
						ID_ORDINA
                   From RINF_SICUREZZA_EVO.V_UTENTE_MENU
                  Where DEFAULTROLE = -1)
                Order By ID_ORDINA;
--
   End GetMenuForUserId;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--


Procedure SetOldUserNameRole (p_userid Number, p_error Out Number) Is
   n_utente   NUMBER;
   a_role     LIST_OF_RUOLI_T;
--
 Begin
   p_error := 0;
--
   Merge Into RINF_SICUREZZA_EVO.H_UTENTE_RUOLO D       --Se il ruolo esiste già aggiorno la data modifica ed imposto a null la data scadenza
        Using (Select Distinct 
		              r.ID_UTENTE,
                      r.CODICE_UTENTE,
                      r.MATRICOLA,
                      r.NOME,
                      r.COGNOME,
                      r.E_MAIL,
                      r.CODICE_DTP,
                      r.CODICE_UT,
                      r.CODICE_RUOLO,
                      r.DESCRIZIONE,
                      r.COMMENTO,
                      r.CODICE_TIPO_DEPOSITARIO,
                      r.CODICE_RUOLO_ORGANIZZATIVO,
                      r.SIGLA_TIPO_DEPOSITARIO,
                      r.AREA,
                      r.DESC_RUOLO_INE
                 From Rinf_Sicurezza_Evo.V_UTENTE_RUOLO r
                Where r.ID_UTENTE = p_userid) s
           On (    D.ID_UTENTE = s.ID_UTENTE
               And Nvl(d.CODICE_RUOLO, 0) = Nvl(s.CODICE_RUOLO, 0)
               And s.CODICE_DTP = d.CODICE_DTP
               And s.CODICE_UT = d.CODICE_UT
               And Nvl(s.CODICE_TIPO_DEPOSITARIO, 0) = Nvl(d.CODICE_TIPO_DEPOSITARIO, 0)
               And Nvl(s.SIGLA_TIPO_DEPOSITARIO, 'vuoto') = Nvl(d.SIGLA_TIPO_DEPOSITARIO, 'vuoto')
               And Nvl(s.AREA, 'vuoto') = Nvl(d.AREA, 'vuoto')
               And s.ID_UTENTE = p_userid)
   When MATCHED Then
      Update Set 
	         D.DATA_MODIFICA = Sysdate, 
			 D.DATA_SCADENZA = Null
--
   When Not MATCHED Then
      Insert     (ID_UTENTE,            --Se il ruolo non esiste lo inserisco con la data di creazione
                  CODICE_UTENTE,
                  MATRICOLA,
                  NOME,
                  COGNOME,
                  E_MAIL,
                  CODICE_DTP,
                  CODICE_UT,
                  CODICE_RUOLO,
                  DESCRIZIONE,
                  COMMENTO,
                  CODICE_TIPO_DEPOSITARIO,
                  CODICE_RUOLO_ORGANIZZATIVO,
                  SIGLA_TIPO_DEPOSITARIO,
                  AREA,
                  DESC_RUOLO_INE,
                  DATA_CREAZIONE)
          Values (s.ID_UTENTE,
                  s.CODICE_UTENTE,
                  s.MATRICOLA,
                  s.NOME,
                  s.COGNOME,
                  s.E_MAIL,
                  s.CODICE_DTP,
                  s.CODICE_UT,
                  s.CODICE_RUOLO,
                  s.DESCRIZIONE,
                  s.COMMENTO,
                  s.CODICE_TIPO_DEPOSITARIO,
                  s.CODICE_RUOLO_ORGANIZZATIVO,
                  s.SIGLA_TIPO_DEPOSITARIO,
                  s.AREA,
                  s.DESC_RUOLO_INE,
                  Sysdate);

  Update Rinf_Sicurezza_Evo.H_UTENTE_RUOLO --Aggiorno la data di scadenza dei ruoli che non l'hanno valorizzata e che non sono in linea
     Set DATA_SCADENZA = Sysdate
   Where DATA_SCADENZA Is Null
     And CODICE_RUOLO Is Not Null
     And ID_UTENTE=p_userid
     And ( ID_UTENTE,
           CODICE_UTENTE,
           CODICE_DTP,
           CODICE_UT,
           CODICE_RUOLO,
           Nvl(CODICE_TIPO_DEPOSITARIO, 0),
           Nvl(SIGLA_TIPO_DEPOSITARIO, 'vuoto'),
           Nvl(AREA, 'vuoto')
		  ) In
             (Select ID_UTENTE,
                     CODICE_UTENTE,
                     CODICE_DTP,
                     CODICE_UT,
                     CODICE_RUOLO,
                     Nvl(CODICE_TIPO_DEPOSITARIO, 0),
                     Nvl(SIGLA_TIPO_DEPOSITARIO, 'vuoto'),
                     Nvl(AREA, 'vuoto')
                From Rinf_Sicurezza_Evo.H_UTENTE_RUOLO
                Where ID_UTENTE = p_userid
              Minus
              Select ID_UTENTE,
                     CODICE_UTENTE,
                     CODICE_DTP,
                     CODICE_UT,
                     CODICE_RUOLO,
                     Nvl(CODICE_TIPO_DEPOSITARIO,0),
                     Nvl(SIGLA_TIPO_DEPOSITARIO, 'vuoto'),
                     Nvl(AREA,'vuoto')
                From Rinf_Sicurezza_Evo.V_UTENTE_RUOLO
               Where ID_UTENTE = p_userid);
--
 Exception
   When Others Then
      p_error := Sqlcode;
 End SetOldUserNameRole;
--
-- ----------------------------------------------------------------------------
--                    DelUserId -- procedura nuova 19/03/2024
-- ----------------------------------------------------------------------------
--
Procedure DelUserId (p_userid Number, p_error Out Number)  Is
 N_Conta NUMBER;
 Num     NUMBER;

 Begin
   p_error := 0;

  Begin 
   Select Count (*)
     Into N_Conta
     From Rinf_Sicurezza_Evo.H_UTENTE_RUOLO
    Where ID_UTENTE = p_userid
 	  And DATA_SCADENZA Is Null;
   Exception 
	  When NO_DATA_FOUND Then
	    N_Conta := 0;
  	  End;
	
--	
--    Dbms_Output.Put_Line(N_Conta);
--
   If N_Conta > 0  Then
      Update Rinf_Sicurezza_Evo.H_UTENTE_RUOLO
         Set DATA_SCADENZA = Sysdate
       Where ID_UTENTE = p_userid;
--	   
   Else
      Insert Into Rinf_Sicurezza_Evo.H_UTENTE_RUOLO (
                ID_UTENTE,
                CODICE_UTENTE,
                MATRICOLA,
                NOME,
                COGNOME,
                E_MAIL,
                CODICE_DTP,
                CODICE_UT,
                CODICE_RUOLO,
                DESCRIZIONE,
                COMMENTO,
                CODICE_TIPO_DEPOSITARIO,
                CODICE_RUOLO_ORGANIZZATIVO,
                SIGLA_TIPO_DEPOSITARIO,
                AREA,
                DESC_RUOLO_INE,
                DATA_CREAZIONE,
                DATA_MODIFICA,
                DATA_SCADENZA)
         Select ID_UTENTE,
                CODICE_UTENTE,
                MATRICOLA,
                NOME,
                COGNOME,
                E_MAIL,
                CODICE_DTP,
                CODICE_UT,
                CODICE_RUOLO,
                DESCRIZIONE,
                COMMENTO,
                CODICE_TIPO_DEPOSITARIO,
                CODICE_RUOLO_ORGANIZZATIVO,
                SIGLA_TIPO_DEPOSITARIO,
                AREA,
                DESC_RUOLO_INE,
                To_Date ('01/12/2015', 'DD/MM/YYYY') DATA_CREAZIONE,
                Null DATA_MODIFICA,
                Sysdate DATA_SCADENZA
           From Rinf_Sicurezza_Evo.V_UTENTE_RUOLO
          Where ID_UTENTE = p_userid;
   End If;

  Begin
 
    Select count(*) Into Num
    From (
         Select 1 
           From Rinf_Sicurezza_Evo.UTENTE_RUOLI
          Where ID_UTENTE = p_userid
	        And CODICE_RUOLO in (1, 5)
         Union
         Select 1 
           From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI
          Where ID_UTENTE = p_userid
          ) ;
  Exception 
	  When NO_DATA_FOUND Then
	    Num := 0;
  	  End;
--	
--    Dbms_Output.Put_Line('L Utente è un Validatore o Amministratore: '||Num);
--
	   
	   If Num = 0 Then
--	
--    Dbms_Output.Put_Line('Utenza viene cancellata dagli archivi del Rinf');
--->
              Delete From Rinf_Sicurezza_Evo.UTENTE_RUOLI
                    Where ID_UTENTE = p_userid;
	          
              Delete From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI
                    Where ID_UTENTE = p_userid;
	          
              Delete From Rinf_Amministrazione_Evo.RICHIESTE_INFORMAZIONE
                    Where ID_UTENTE = p_userid;
	          
              Delete From Rinf_Sicurezza_Evo.ANAG_UTENTE
                    Where ID_UTENTE = p_userid;
         Else 
--             Dbms_Output.Put_Line('Utenza viene disabilitata ma resta negli archivi del Rinf');
	
              Update Rinf_Sicurezza_Evo.ANAG_UTENTE
			     Set FLAG_MAIL = 0,
				     FLAG_UTE_ABILITAZ = 0
               Where ID_UTENTE = p_userid;

              Delete From Rinf_Sicurezza_Evo.UTENTE_RUOLI
                    Where ID_UTENTE = p_userid;

         End If;

--->
 Exception
   When Others  Then
--     Dbms_Output.Put_Line('Errore Oracle procedura DelUserID: '||SQLCODE );  
      p_error := SQLCODE;
 End DelUserId;

--
-- ----------------------------------------------------------------------------
--   SetNewUserId Modificata la gestione di ANAG_UTENTE 
-- ----------------------------------------------------------------------------
--
Procedure SetNewUserId (p_CODICE_UTENTE       Varchar2,
                        p_MATRICOLA           Varchar2,
                        p_NOME                Varchar2,
                        p_COGNOME             Varchar2,
                        p_TELEFONO            Varchar2,
                        p_CELLULARE           Varchar2,
                        p_E_MAIL              Varchar2,
                        p_error           Out Number) Is
--
   n_id_utente          Number;
   id_ute               Number;
   n_conta              Number;
   Num_Ute              Number;
   v_COD_UTENTE         Varchar2(200); 
--
 Begin
   p_error := 0;
 -- --------------------------------------------------------------------------------------------------------------------
 -- Verifico se l'utente è già memorizzato nella tabella dello storico H_UTENTE_RUOLO, in modo da riutilizzare il suo id
 -- (Caso di un utente eliminato in precedenza) 
 -- N.B: il nome utente è CASE Sensitive: Prova, PROVA, prova ecc.. sono utenti diversi!
 -- nella tabella H_UTENTE_RUOLO non ci sono indici. Mentre, in ANAG_UTENTE esiste una unique su [lower(CODICE_UTENTE)]!!!
 -- --------------------------------------------------------------------------------------------------------------------

 Begin
   Select CODICE_UTENTE, Nvl (Max (ID_UTENTE), 0) 
     Into v_COD_UTENTE, n_id_utente
     From Rinf_Sicurezza_Evo.H_UTENTE_RUOLO
    Where Lower(CODICE_UTENTE) = Lower(p_CODICE_UTENTE)              
    Group By CODICE_UTENTE;
 Exception 
	  When NO_DATA_FOUND Then
	       n_ID_UTENTE := 0;
		   v_COD_UTENTE := ' ';
  	  End;

   If n_id_utente = 0   Then   
--
-- Se l'utente non è nello storico, genere un nuovo id utente e lo inserisco nello storico con il codice progressivo implementato
--
        Select Max(Num_Ute) + 1
          Into n_id_utente
		  From
            ( Select Max(ID_UTENTE) Num_Ute
                From Rinf_Sicurezza_Evo.H_UTENTE_RUOLO
              Union
              Select Max(ID_UTENTE) Num_Ute
                From Rinf_Sicurezza_Evo.ANAG_UTENTE 
	         );  
    	 
/*
        Select Max (ID_UTENTE) + 1
          Into n_id_utente
          From Rinf_Sicurezza_Evo.ANAG_UTENTE;
*/
--     
         Insert Into RINF_SICUREZZA_EVO.H_UTENTE_RUOLO 
	                (ID_UTENTE,
                     CODICE_UTENTE,
                     MATRICOLA,
                     NOME,
                     COGNOME,
                     E_MAIL,
                     DATA_CREAZIONE)
             Values (n_id_utente,
                     p_CODICE_UTENTE,
                     p_MATRICOLA,
                     p_NOME,
                     p_COGNOME,
                     p_E_MAIL,
                     Sysdate);
--
   Else
--
-- Verifico che esista la riga "madre" dell'utente, quella senza un ruolo specifico in H_UTENTE_RUOLO
       Begin 
        Select Count (*)
          Into n_conta
          From Rinf_Sicurezza_Evo.H_UTENTE_RUOLO
         Where CODICE_UTENTE = v_COD_UTENTE
	       And CODICE_RUOLO Is Null;
       Exception 
	        When NO_DATA_FOUND Then
	            n_conta := 0;
  	   End;

--      
-- se esiste, l'aggiorno
        If n_conta > 0  Then
--
-- Se l'utente è nello storico, aggiorno le informazioni dello storico ed imposto a Null la data scadenza
             Update Rinf_Sicurezza_Evo.H_UTENTE_RUOLO
                Set DATA_SCADENZA = Null,
                    DATA_MODIFICA = Sysdate,
                    MATRICOLA = p_MATRICOLA,
                    NOME = p_NOME,
                    COGNOME = p_COGNOME,
                    E_MAIL = p_E_MAIL
              Where CODICE_UTENTE = v_COD_UTENTE
		        And CODICE_RUOLO Is Null;
        Else
-- Altrimenti, la inserisco
             Insert Into Rinf_Sicurezza_Evo.H_UTENTE_RUOLO 
		                (ID_UTENTE,
                         CODICE_UTENTE,
                         MATRICOLA,
                         NOME,
                         COGNOME,
                         E_MAIL,
                         DATA_CREAZIONE)
                 Values (n_id_utente,
                         p_CODICE_UTENTE,
                         p_MATRICOLA,
                         p_NOME,
                         p_COGNOME,
                         p_E_MAIL,
                         Sysdate);
        End If;
--
   End If;

-- ---------------------------------------------------------
-- Verifico che esista l'utente nell'anagrafica degli utenti
-- ---------------------------------------------------------
   Begin 
   Select count(*)
     Into id_ute
     From Rinf_Sicurezza_Evo.ANAG_UTENTE
    Where ID_UTENTE = n_id_utente;
--          CODICE_UTENTE = p_CODICE_UTENTE;
      Exception 
	        When NO_DATA_FOUND Then
	            id_ute := 0;
  	   End;

  If id_ute = 0 Then
-- non esiste 
      Insert Into Rinf_Sicurezza_Evo.ANAG_UTENTE 
	           (ID_UTENTE,
                CODICE_UTENTE,
                MATRICOLA,
                NOME,
                COGNOME,
                TELEFONO,
                CELLULARE,
                E_MAIL,
				FLAG_MAIL,
				FLAG_UTE_ABILITAZ)
        Values (n_id_utente,
                p_CODICE_UTENTE,
                p_MATRICOLA,
                p_NOME,
                p_COGNOME,
                p_TELEFONO,
                p_CELLULARE,
                p_E_MAIL,
				1,
				1);
 Else 
-- era già presente e lo riabilito [FLAG_UTE_ABILITAZ = 1]
      Update  Rinf_Sicurezza_Evo.ANAG_UTENTE  Set   
            --  CODICE_UTENTE = p_CODICE_UTENTE,
            --  MATRICOLA = p_MATRICOLA,
           --   NOME = p_NOME,
           --   COGNOME = p_COGNOME,
      		--  TELEFONO = p_TELEFONO,
      		--  CELLULARE = p_CELLULARE,
      		--  E_MAIL = p_E_MAIL,
              FLAG_MAIL = 1,
      		  FLAG_UTE_ABILITAZ = 1
        Where ID_UTENTE = n_id_utente;

End If;


/*** 

   Merge Into Rinf_Sicurezza_Evo.ANAG_UTENTE a
   Using (Select 
          n_id_utente as ID_UTENTE ,  
          p_CODICE_UTENTE as CODICE_UTENTE     , 
          p_MATRICOLA as MATRICOLA         ,
          p_NOME as NOME              ,
          p_COGNOME as COGNOME           ,
          p_TELEFONO as TELEFONO          ,
          p_CELLULARE as CELLULARE         ,
          p_E_MAIL as E_MAIL  ,          
          1 as FLAG_MAIL         ,
          1 as FLAG_UTE_ABILITAZ 
         From Dual) b 
--
	On (a.ID_UTENTE = b.ID_UTENTE )
--  
  When MATCHED Then 
       Update  Set   
         CODICE_UTENTE = b.CODICE_UTENTE,
         MATRICOLA = b.MATRICOLA,
         NOME = b.NOME,
         COGNOME = b.COGNOME,
		 TELEFONO = b.TELEFONO,
		 CELLULARE = b.CELLULARE,
		 E_MAIL = b.E_MAIL,
         FLAG_MAIL = b.FLAG_MAIL,
		 FLAG_UTE_ABILITAZ = b.FLAG_UTE_ABILITAZ
--		 
  When Not MATCHED Then 
        Insert 
		       (ID_UTENTE,
                CODICE_UTENTE,
                MATRICOLA,
                NOME,
                COGNOME,
                TELEFONO,
                CELLULARE,
                E_MAIL,
				FLAG_MAIL,
				FLAG_UTE_ABILITAZ
                )
        Values (b.ID_UTENTE,
                b.CODICE_UTENTE,
                b.MATRICOLA,
                b.NOME,
                b.COGNOME,
                b.TELEFONO,
                b.CELLULARE,
                b.E_MAIL,
				b.FLAG_MAIL,
				b.FLAG_UTE_ABILITAZ
				);
***/
--
 Exception
   When Others Then
      p_error := SQLCODE;
	Dbms_Output.Put_Line ('Errore: '||  SQLCODE ||' - '||Substr(SQLERRM, 1, 500));
 End SetNewUserId;
--
-- --------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------
--
   Procedure SetInfoUserId (P_Id_Utente              Number,
                            P_Codice_Utente          Varchar2,
                            P_Matricola              Varchar2,
                            P_Nome                   Varchar2,
                            P_Cognome                Varchar2,
                            P_Telefono               Varchar2,
                            P_Cellulare              Varchar2,
                            P_E_Mail                 Varchar2,
                            P_Error              Out Number)
   Is
--
   Begin
      p_error := 0;

      Update Rinf_Sicurezza_Evo.ANAG_UTENTE
         Set CODICE_UTENTE = P_Codice_Utente,
             MATRICOLA = P_Matricola,
             NOME = P_Nome,
             COGNOME = P_Cognome,
             TELEFONO = P_Telefono,
             CELLULARE = P_Cellulare,
             E_MAIL = P_E_Mail
       Where ID_UTENTE = P_Id_Utente;
--
   Exception
      When Others  Then
         p_error := SQLCODE;
   End SetInfoUserId;
--
-- ----------------------------------------------------------------------------
--              SetUserAuthorizationRequest
-- ----------------------------------------------------------------------------
--

 PROCEDURE SetUserAuthorizationRequest (p_userid Number, p_error Out Number) Is
    n_conta1            Number;
    n_conta2            Number;
    n_conta3            Number;
    n_codice_richiesta  Number;
--
      Type dtp_ric_rt Is Record
      (
         id_dtp    Rinf_Sicurezza_Evo.V_UTENTE_RUOLO.CODICE_DTP%Type);
      Type dtp_ric_t Is Table Of dtp_ric_rt;
--
      l_dtp_ric    dtp_ric_t;
--
 Begin
    p_error := 0;

-- controllo se ci sono richieste aperte
    Select Count(*) Into n_conta1
      From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI
     Where CODICE_STATO_RICHIESTA = 1;
--
      Dbms_Output.Put_Line ('Richieste aperte: '||to_char(n_conta1));

    If n_conta1 > 0 Then
        Select CODICE_RICHIESTA Into n_codice_richiesta
          From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI
         Where CODICE_STATO_RICHIESTA = 1;
--
--  Elimino le eventuali richieste nei dati di dettaglio
--  relative all'utente per essere sicuro che non rimangano richieste non idonee
--  (caso in cui l'utente era validatore ad esempio della DTP VR00 ed ora è validatore di AN00)
--
        Delete From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI
        Where CODICE_RICHIESTA = n_codice_richiesta
          And CODICE_STATO_RICHIESTA = 1
          And ID_UTENTE = p_userid;

-- Verifico se l'utente è un validatore
        Select Count(*) Into n_conta2
          From Rinf_Sicurezza_Evo.UTENTE_RUOLI
         Where ID_UTENTE = p_userid 
		   And CODICE_RUOLO = 5;
--
        Dbms_Output.Put_Line ('Validatore: '||to_char(n_conta2));
--
        If n_conta2 > 0 Then
-- controllo se l'utente è un validatore di Sede centrale
            Select Count(*) Into n_conta3
              From Rinf_Sicurezza_Evo.UTENTE_RUOLI u,
			       Rinf_Sicurezza_Evo.ANAG_RUOLO r
             Where u.ID_UTENTE = p_userid 
			   And Upper(r.DESCRIZIONE) = 'VALIDATORE'
			   And u.CODICE_RUOLO = r.CODICE_RUOLO 
			   And u.CODICE_DTP = '-1';
--
             Dbms_Output.Put_Line ('Sede Centrale: '||to_char(n_conta3));
             If n_conta3 > 0 Then

            --inserisco l'utente nel dettaglio dei dati da autorizzare
              Insert Into Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI (
                     CODICE_RICHIESTA,
                     ID_UTENTE,
                     FLAG_SEDE_CENTRALE,
                     CODICE_DTP,
                     TOTALE_SOL,
                     TOTALE_OP,
                     CODICE_STATO_RICHIESTA)
             Select Distinct
                n_codice_richiesta ,                      --RC_RINF_DTEC
                u.ID_UTENTE,
                --13/01/2017 Modificato per gestire Sedi Centrali multiple 1,
                u.CODICE_TIPO_DEPOSITARIO,
                d.CODICE_DTP,
                N_Sol.Tot_Sol  TOTALE_SOL,
                N_Op.Tot_Op    TOTALE_OP,
                1 CODICE_STATO_RICHIESTA
             From
                Rinf_Sicurezza_Evo.V_UTENTE_RUOLO u,
                Rinf_Sicurezza_Evo.V_UTENTE_NOTIFICHE n,
                (  Select CODICE_DTP, Count (*) Tot_Op
                     From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI
                 Group By codice_dtp) n_op,
                (  Select CODICE_DTP, Count (*) Tot_Sol
                     From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA
                 Group By CODICE_DTP) N_Sol,
--
                Rinf_Anagrafiche_EvO.ANAG_DTP d
--
          Where u.CODICE_RUOLO = 5         -- 'VALIDATORE'        
            And u.ID_UTENTE = p_userid
            And n.CODICE_NOTIFICA = 3                       -- "Autorizzazione dati"
            And u.CODICE_RUOLO = n.CODICE_RUOLO
            And u.ID_UTENTE = n.ID_UTENTE
            And d.CODICE_DTP = n_op.CODICE_DTP
            And d.CODICE_DTP = n_sol.CODICE_DTP
            And d.CODICE_DTP <> '-1'
            --13/01/2017 Sede Centrale multipla AND u.CODICE_TIPO_DEPOSITARIO = 2
            And u.AREA = 'SC'
--
       Minus
--
         Select CODICE_RICHIESTA,
                ID_UTENTE,
                FLAG_SEDE_CENTRALE,
                CODICE_DTP,
                TOTALE_SOL,
                TOTALE_OP,
                1
            From Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI
           Where ID_UTENTE = p_userid
             And CODICE_RICHIESTA = n_codice_richiesta;

        End If;
--
-- Controllo se, come validatore DTP, ha le giuste occorrenze nel dettaglio dei dati da autorizzare

        Select u.CODICE_DTP
--
          Bulk Collect Into l_dtp_ric
--
        From (Select d.ID_UTENTE,D.CODICE_DTP
                From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI r,
                     Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI d
               Where r.CODICE_RICHIESTA = d.CODICE_RICHIESTA
                 And r.CODICE_STATO_RICHIESTA = 1
                 And FLAG_SEDE_CENTRALE = 0
              ) h,
              Rinf_Sicurezza_Evo.V_UTENTE_RUOLO u
        Where u.CODICE_RUOLO = 5
          And u.CODICE_DTP <> '-1'
          And u.ID_UTENTE = h.ID_UTENTE (+)
          And u.CODICE_DTP = h.CODICE_DTP (+)
          And u.ID_UTENTE = p_userid
        Group By u.CODICE_DTP
        Having Count(h.ID_UTENTE) = 0;
--
--
        Forall n_conta In 1 .. l_dtp_ric.Count
--
         Insert Into Rinf_Amministrazione_Evo.DETTAGLIO_AUTORIZZAZIONI (
                     CODICE_RICHIESTA,
                     ID_UTENTE,
                     FLAG_SEDE_CENTRALE,
                     CODICE_DTP,
                     TOTALE_SOL,
                     TOTALE_OP,
                     CODICE_STATO_RICHIESTA)
              Select Distinct 
		             CODICE_RICHIESTA, --RC_RINF RC_RES_DCI
                     u.ID_UTENTE,
                     0,
                     u.CODICE_DTP,
                     N_Sol.Tot_Sol  TOTALE_SOL,
                     N_Op.Tot_Op    TOTALE_OP,
                     1              CODICE_STATO_RICHIESTA
           From Rinf_Amministrazione_Evo.ANAG_RICHIESTE_AUTORIZZAZIONI r,
                Rinf_Sicurezza_Evo.V_UTENTE_RUOLO u,
                Rinf_Sicurezza_Evo.V_UTENTE_NOTIFICHE n,
--
                ( Select Count(*) Tot_Op
                    From Rinf_Autorizzazioni_Evo.PUNTI_OPERATIVI
                   Where CODICE_DTP = l_dtp_ric(n_conta).id_dtp) N_Op,
--
                ( Select Count(*) Tot_Sol
                    From Rinf_Autorizzazioni_Evo.SEZIONI_LINEA
                 Where CODICE_DTP = l_dtp_ric(n_conta).id_dtp) N_Sol
--
              Where u.CODICE_RUOLO = 5
                And u.ID_UTENTE = p_userid
                And r.CODICE_STATO_RICHIESTA = 1
                And n.CODICE_NOTIFICA = 3
                And u.CODICE_RUOLO = n.CODICE_RUOLO
                And u.ID_UTENTE = n.ID_UTENTE
                And u.CODICE_DTP = l_dtp_ric(n_conta).id_dtp
                And u.CODICE_TIPO_DEPOSITARIO In (1, 5)
                And N_Sol.Tot_Sol + N_Op.Tot_Op > 0;

        End If;

    End If;

   Exception
      When Others Then
         p_error := SQLCODE;

End SetUserAuthorizationRequest;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--

PROCEDURE SetUserNameRoleString (p_username               VARCHAR2,
                                 s_role                   VARCHAR2,
                                 p_flag_notifica   IN     NUMBER,
                                 p_error              OUT NUMBER)
IS
   a_role     LIST_OF_RUOLI_T;
   n_utente   NUMBER;
BEGIN
   p_error := 0;
   n_utente := GetUserID (p_username);

   SetOldUserNameRole (n_utente, p_error);
   DBMS_OUTPUT.PUT_LINE(p_error);
 IF p_error=0 THEN
   DELETE FROM RINF_SICUREZZA_EVO.UTENTE_RUOLI
         WHERE ID_UTENTE = n_utente AND CODICE_RUOLO NOT IN (1000,8); --26/01/2017 inserito filtro per ruolo 8 di servizio per l'acquisizione

   WITH test AS (SELECT s_role str FROM DUAL)
       SELECT REGEXP_SUBSTR (str,
                             '[^;]+',
                             1,
                             ROWNUM)
                 split
         BULK COLLECT INTO a_role
         FROM test
   CONNECT BY LEVEL <= LENGTH (REGEXP_REPLACE (str, '[^;]+')) + 1;


   FORALL j IN 1 .. a_role.COUNT
      INSERT INTO RINF_SICUREZZA_EVO.UTENTE_RUOLI (ID_UTENTE,
                                                   CODICE_RUOLO,
                                                   CODICE_TIPO_DEPOSITARIO,
                                                   CODICE_DTP,
                                                   CODICE_UT)
           VALUES (n_utente,
                   REGEXP_SUBSTR (a_role (j),
                                  '[^#]+',
                                  1,
                                  1,
                                  'i'),
                   CASE
                      WHEN (    REGEXP_SUBSTR (a_role (j),
                                               '[^#]+',
                                               1,
                                               1,
                                               'i') = 5
                            AND REGEXP_SUBSTR (a_role (j),
                                               '[^#]+',
                                               1,
                                               3,
                                               'i') <> '-1')
                      THEN
                         1
                      WHEN (    REGEXP_SUBSTR (a_role (j),
                                               '[^#]+',
                                               1,
                                               1,
                                               'i') = 5
                            AND REGEXP_SUBSTR (a_role (j),
                                               '[^#]+',
                                               1,
                                               3,
                                               'i') = '-1')
                      --12/01/2017 modificato per gestire sede centrale multipla THEN 2
                      THEN
                         TO_NUMBER (REGEXP_SUBSTR (a_role (j),
                                                   '[^#]+',
                                                   1,
                                                   2,
                                                   'i'))
                      ELSE
                         TO_NUMBER (REGEXP_SUBSTR (a_role (j),
                                                   '[^#]+',
                                                   1,
                                                   2,
                                                   'i'))
                   END,
                   REGEXP_SUBSTR (a_role (j),
                                  '[^#]+',
                                  1,
                                  3,
                                  'i'),
                   REGEXP_SUBSTR (a_role (j),
                                  '[^#]+',
                                  1,
                                  4,
                                  'i'));


   ---------------------------------------
   --Aggiorno il flag di notifica mail --modifica del 26/06/2015
   UPDATE RINF_SICUREZZA_EVO.ANAG_UTENTE
      SET FLAG_MAIL = p_flag_notifica
    WHERE ID_UTENTE = n_utente;

   -------------------------------

   --Inserisco anche gli altri CODICE_TIPO_DEPOSITARIO per i validatori di DTP
   --In modo che il validatore veda tutti i parametri
   INSERT INTO RINF_SICUREZZA_EVO.UTENTE_RUOLI (ID_UTENTE,
                                                CODICE_RUOLO,
                                                CODICE_TIPO_DEPOSITARIO,
                                                CODICE_DTP,
                                                CODICE_UT)
      SELECT ID_UTENTE,
             CODICE_RUOLO,
             d.CODICE_TIPO_DEPOSITARIO,
             CODICE_DTP,
             CODICE_UT
        FROM RINF_SICUREZZA_EVO.UTENTE_RUOLI r,
             RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO d
       WHERE     ID_UTENTE = n_utente
             AND CODICE_RUOLO = 5
             AND r.CODICE_TIPO_DEPOSITARIO = 1
             AND D.AREA IN ('DTP', 'UT')
             AND d.CODICE_TIPO_DEPOSITARIO <> 1;

   ------------
   --17/02/2017 Aggiorno la data di scadenza nella tabella dello storico

    SetOldUserNameRole (n_utente, p_error);

   --Procedura che verifica se l'utente è un validatore e se ci sono autorizzazioni aperte
   SetUserAuthorizationRequest (GetUserID (p_username), p_error);
 END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      p_error := SQLCODE;
END SetUserNameRoleString;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--

   Procedure GetReportMail (p_CodiceAcquisizione in NUMBER , p_IDUTENTE in NUMBER, p_cursor OUT empcur) is
    myDett varchar2(4000);
    begin
        myDett:='select codice_acquisizione, id_utente, dtp, tipo_oggetto, '
                ||' errori_gen, errori_inf, errori_ene, errori_ccs, totale_errori '
                ||' from V_ERRORI_UTENTE v '
                ||' where  CODICE_ACQUISIZIONE = '||p_CodiceAcquisizione
                ||' AND ID_UTENTE = '||p_IDUTENTE
                ||' order by dtp, tipo_oggetto ';
        DBMS_OUTPUT.PUT_LINE(myDett);
        OPEN p_cursor FOR myDett;
    end;

--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--

PROCEDURE  GetMailByEvent ( p_EventId              IN     NUMBER,
   p_DtpId                IN     VARCHAR2 DEFAULT NULL,
   p_ParId                IN     NUMBER DEFAULT NULL,
   p_CodiceAcquisizione   IN     NUMBER DEFAULT NULL,
   p_DataScadenza         IN     VARCHAR2 DEFAULT NULL,
   p_UserId                      NUMBER DEFAULT NULL,
   p_CodiceRichiesta      IN     NUMBER DEFAULT NULL,
   p_Versione             IN     NUMBER DEFAULT NULL,
   p_cursor                  OUT empcur)
IS
   myStr                VARCHAR2 (32767);
   myDett               VARCHAR2 (32767);
   l_CodiceAcq          NUMBER (9);
   l_dataTrasmissione   VARCHAR2 (10);
   l_protocollo         RINF_PUBBLICATI_EVO.VERSIONE_RINF.PROTOCOLLO%TYPE;
   l_ftp                RINF_PUBBLICATI_EVO.ANAGRAFICA_TRASMISSIONI.FTPS%TYPE;
   l_Versione           RINF_PUBBLICATI_EVO.ANAGRAFICA_TRASMISSIONI.CODICE_VERSIONE%TYPE;
   l_cur                SYS_REFCURSOR;
   r_profilo            VARCHAR2 (400);
   l_profilo            VARCHAR2 (4000);
   l_dtp                VARCHAR2 (4000);
   a_DTP                LIST_OF_RUOLI_T;
   s_ambiente           VARCHAR2(50);
BEGIN
--Imposto l'ambiente da inserire nell'oggetto della mail (per gli ambienti diversi da esercizio)

insert into t_log_chiamate (Parametri) values (p_EventId||' <=> '||
                                               p_DtpId||' <=> '||
                                               p_ParId||' <=> '||
                                               p_CodiceAcquisizione||' <=> '||
                                               p_DataScadenza||' <=> '||
                                               p_UserId||' <=> '||
                                               p_CodiceRichiesta||' <=> '||p_Versione);
commit;
--
SELECT
CASE WHEN SIGLA='RINF-ESER' THEN NULL
ELSE SIGLA||'-'
END into s_ambiente
FROM RINF_ANAGRAFICHE_EVO.ANAG_AMBIENTE
WHERE FLAG_CORRENTE=1;

   CASE
      WHEN p_EventId = 1    --Avvenuta trasmissione ai validatori
      THEN
         SELECT TO_CHAR (TRUNC (t.DATA_TRASMISSIONE), 'dd/mm/yyyy'),
                v.PROTOCOLLO NUMERO_PROTOCOLLO,
                T.FTPS FTP_ADDRESS,
                t.CODICE_VERSIONE
           INTO l_dataTrasmissione,
                l_protocollo,
                l_ftp,
                l_versione
           FROM RINF_PUBBLICATI_EVO.ANAGRAFICA_TRASMISSIONI t,
                RINF_PUBBLICATI_EVO.VERSIONE_RINF v
          WHERE     t.CODICE_VERSIONE = v.CODICE_VERSIONE
                AND t.CODICE_TRASMISSIONE = 1
                AND t.CODICE_VERSIONE =p_Versione;

         myStr :=
               ' SELECT DISTINCT UE.ID_UTENTE, UE.CODICE_UTENTE, UE.E_MAIL, '''||s_ambiente||'''||UE.OGGETTO_EMAIL OGGETTO_EMAIL, '
            || '  replace('
            || '   replace('
            || '    replace('
            || '      replace('
            || '       replace('
            || '        replace(UE.BODY_EMAIL ,''<Nome>'', nvl(ue.nome, ''<Nome>'')), '
            || ' ''<Cognome>'', nvl(ue.cognome, ''<Cognome>'')),'
            || '  ''<Ruolo>'', ue.descrizione), '
            || '  ''<Versione>'', '''
            || TO_CHAR (l_versione)
            || '''), '
            --                ||'  ''<ftp>'', '''||l_ftp||'''), ' modifica del 17/06/2015- la trasmissione non avvine per ftp
            || '  ''<Protocollo>'', '''
            || l_protocollo
            || '''), '
            || '   ''<DataTrasmissione>'', '''
            || l_dataTrasmissione
            || ''' ) BODY_EMAIL'
            || ' ,  null OGGETTO_POSTIT '
            || ' FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE'
            || ' WHERE '
            || ' UE.CODICE_EVENTO = '
            || p_EventID
            || ' AND UE.FLAG_MAIL = 1 '
            || ' AND UE.E_MAIL IS NOT NULL';

      WHEN p_EventId = 2 --Invio RI FTP fallito  --11/02/2016 evento inserito per gestire correttamente i tag.Aggiunto nella procedura parametor di input conil codice versione del registro
      THEN
             myStr :=
                'SELECT DISTINCT         '
                ||'UE.ID_UTENTE,           '
                ||'UE.CODICE_UTENTE,       '
                ||'UE.E_MAIL,              '
                ||''''||s_ambiente||'''||UE.OGGETTO_EMAIL OGGETTO_EMAIL,'
                ||'REPLACE (               '
                ||'REPLACE (               '
                ||'REPLACE (               '
                ||'REPLACE (               '
                ||'REPLACE (               '
                ||'REPLACE (UE.BODY_EMAIL, '
                ||'''<Nome>'',                       '
                ||'NVL (ue.nome, ''<Nome>'')),       '
                ||'''<Cognome>'',                    '
                ||'NVL (ue.cognome, ''<Cognome>'')), '
                ||'''<Ruolo>'',                      '
                ||'ue.descrizione),                  '
                ||'''<Versione>'',                   '
                ||'CODICE_VERSIONE),                 '
                ||'''<DataTrasmissione>'',           '
                ||'TO_DATE (SYSDATE, ''DD/MM/YYYY'')),'
                ||'''<Protocollo>'',                 '
                ||'NVL (PROTOCOLLO, ''-''))          '
                ||'BODY_EMAIL,                       '
                ||'NULL OGGETTO_POSTIT               '
                ||'FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE,'
                ||'RINF_PUBBLICATI_EVO.VERSIONE_RINF '
                ||'WHERE     UE.CODICE_EVENTO = 2    '
                ||'AND UE.FLAG_MAIL = 1              '
                ||'AND UE.E_MAIL IS NOT NULL         '
                ||'AND CODICE_VERSIONE ='||p_Versione;

      WHEN p_EventId = 3 --Nuovo RI pronto
      THEN
         myStr :=
               ' SELECT DISTINCT UE.ID_UTENTE, UE.CODICE_UTENTE, UE.E_MAIL, '''||s_ambiente||'''||UE.OGGETTO_EMAIL OGGETTO_EMAIL'
            || ',  replace(replace(replace(replace(replace(UE.BODY_EMAIL ,''<Nome>'', nvl(ue.nome, ''<Nome>'')), ''<Cognome>'', nvl(ue.cognome, ''<Cognome>'')), ''<Ruolo>'', ue.descrizione), ''<DataProntoTrasmissione>'', to_char(trunc(data_pubblicazione ), ''dd/mm/yyyy'') ), ''<Versione>'', CODICE_VERSIONE)  BODY_EMAIL'
            || ',  null OGGETTO_POSTIT '
            || 'FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE'
            || ', RINF_PUBBLICATI_EVO.VERSIONE_RINF'
            || ' WHERE '
            || ' UE.CODICE_EVENTO = 31'
            || ' AND UE.FLAG_MAIL = 1 '
            || ' AND UE.E_MAIL IS NOT NULL '
            || ' AND UE.CODICE_RUOLO in (1)'
            || ' AND CODICE_VERSIONE ='||p_Versione
            || ' UNION '
            || ' SELECT DISTINCT UE.ID_UTENTE, UE.CODICE_UTENTE, UE.E_MAIL,'''||s_ambiente||'''|| UE.OGGETTO_EMAIL OGGETTO_EMAIL'
            || ',  replace(replace(replace(replace(replace(UE.BODY_EMAIL ,''<Nome>'', nvl(ue.nome, ''<Nome>'')), ''<Cognome>'', nvl(ue.cognome, ''<Cognome>'')), ''<Ruolo>'', ue.descrizione), ''<DataProntoTrasmissione>'', to_char(trunc(data_pubblicazione ), ''dd/mm/yyyy'') ), ''<Versione>'', CODICE_VERSIONE)  BODY_EMAIL'
            || ',  null OGGETTO_POSTIT '
            || 'FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE'
            || ', RINF_PUBBLICATI_EVO.VERSIONE_RINF'
            || ' WHERE '
            || ' UE.CODICE_EVENTO = 32'
            || ' AND UE.FLAG_MAIL = 1 '
            || ' AND UE.E_MAIL IS NOT NULL '
            || ' AND UE.CODICE_RUOLO in (2)'
            || ' AND CODICE_VERSIONE ='||p_Versione;
            
        insert into t_log_chiamate (Parametri) values (p_EventId||' <=> '||myStr);    
        commit;
      WHEN p_EventId = 4 --Condizione anomala di controllo al Responsabile
      THEN
         myStr :=
               'select DISTINCT v1.ID_UTENTE, v1.CODICE_UTENTE, v1.E_MAIL,'
            || ''''||s_ambiente||'''|| AE.EVENT_EMAIL_SUBJECT OGGETTO_EMAIL, '
            || '    replace(replace(replace(AE.EVENT_EMAIL_BODY ,''<Nome>'', nvl(V1.nome, ''<Nome>'')), ''<Cognome>'', nvl(V1.cognome, ''<Cognome>'')), ''<DataAcquisizione>'', to_char(V2.DATA_ACQUISIZIONE,''dd/mm/yyyy hh24:mi:ss'')) BODY_EMAIL,'
            || ' null OGGETTO_POSTIT'
            || '      from V_ERRORI_UTENTE v1'
            || ' , RINF_SICUREZZA_EVO.ANAG_EVENTI AE'
            || ', V_ACQUISIZIONE_DATI_V082 V2'
            || '     where AE.EVENT_ID = 4'
            || '     AND v1.FLAG_MAIL = 1 '
            || '     AND v1.E_MAIL IS NOT NULL'
            || ' and V1.CODICE_ACQUISIZIONE ='
            || NVL (p_CodiceAcquisizione, 0)
            || ' and V2.CODICE_ACQUISIZIONE ='
            || NVL (p_CodiceAcquisizione, 0);
      WHEN p_EventId = 6 --Richiesta autorizzazione
      THEN
      --18/01/2017 modificata la stringa per gestire le sedi centrali multiple
         myStr :=
               'SELECT DISTINCT UE.ID_UTENTE, UE.CODICE_UTENTE, UE.E_MAIL, '''||s_ambiente||'''||UE.OGGETTO_EMAIL OGGETTO_EMAIL
              ,REPLACE(
                REPLACE(
                  REPLACE(
                   REPLACE(
                    REPLACE(
                     REPLACE(
                      REPLACE(UE.BODY_EMAIL ,''<Nome>'', NVL(ue.nome, ''<Nome>'')),
                 ''<Cognome>'', NVL(ue.cognome, ''<Cognome>'')),
                  ''<Ruolo>'', ue.descrizione),
                  ''<GruppoDati>'',DE.gruppodati ),
                   ''<DataScadenza>'', TO_CHAR(TRUNC(RI.data_scadenza ), ''dd/mm/yyyy'') ),
                 ''<Autorizzatore>'', CASE WHEN AGU.COGNOME IS NULL THEN ''<Autorizzatore>'' ELSE AGU.COGNOME ||'' ''||AGU.NOME END),
                 ''<DataRIPrecedente>'', TO_CHAR(TRUNC(VE.DataRIPrecedente ), ''dd/mm/yyyy'') )  BODY_EMAIL
                ,  NULL OGGETTO_POSTIT
                , RI.DATA_SCADENZA
                ,VE.DataRIPrecedente
                ,DE.gruppodati

                FROM
                                RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE
                                , RINF_SICUREZZA_EVO.ANAG_UTENTE AGU
                                , RINF_AMMINISTRAZIONE_EVO.ANAG_RICHIESTE_AUTORIZZAZIONI RI
                                , (SELECT MAX(DATA_PUBBLICAZIONE) DataRIPrecedente FROM RINF_PUBBLICATI_EVO.VERSIONE_RINF) VE
                                , (SELECT id_utente, LISTAGG( CODICE_DTP  ,'', '') WITHIN GROUP (ORDER BY FLAG_SEDE_CENTRALE,CODICE_DTP) GruppoDati

                FROM (

                select distinct id_utente, CODICE_DTP,0 FLAG_SEDE_CENTRALE from RINF_SICUREZZA_EVO.UTENTE_RUOLI u, RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO d
                                    where CODICE_RUOLO = 5
                                    and d.CODICE_TIPO_DEPOSITARIO=u.CODICE_TIPO_DEPOSITARIO
                                    and d.AREA<>''SC''
                UNION
                select distinct id_utente, SIGLA_TIPO_DEPOSITARIO,1 FLAG_SEDE_CENTRALE from RINF_SICUREZZA_EVO.UTENTE_RUOLI u, RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO d
                                    where CODICE_RUOLO = 5
                                    and d.CODICE_TIPO_DEPOSITARIO=u.CODICE_TIPO_DEPOSITARIO
                                    and d.AREA=''SC''                     ) group by ID_UTENTE     ) de
                                 WHERE
                                 UE.CODICE_EVENTO = 6
                                 AND UE.FLAG_MAIL = 1
                                 AND UE.E_MAIL IS NOT NULL
                                 AND UE.CODICE_TIPO_DEPOSITARIO <>-1 AND UE.CODICE_RUOLO = 5
                                 AND DE.ID_UTENTE=UE.ID_UTENTE
                                 AND RI.CODICE_RICHIESTA = '
            || p_CodiceRichiesta;
      WHEN p_EventId = 7 --Validazione DTP
      THEN
         myStr :=
               ' SELECT DISTINCT UE.ID_UTENTE, UE.CODICE_UTENTE, UE.E_MAIL, '''||s_ambiente||'''||UE.OGGETTO_EMAIL OGGETTO_EMAIL'
            || ',replace('
            || '  replace('
            || '   replace('
            || '    replace('
            || '     replace('
            || '      replace(UE.BODY_EMAIL ,''<Nome>'', nvl(ue.nome, ''<Nome>'')), '
            || ' ''<Cognome>'', nvl(ue.cognome, ''<Cognome>'')),'
            || '  ''<Ruolo>'', ue.descrizione), '
            || '  ''<DTP>'', '''
            || p_DtpID
            || '''), '
            || '   ''<DataAutorizzazione>'', to_char(trunc(data_autorizzazione ), ''dd/mm/yyyy'') ), '
            || ' ''<Autorizzatore>'', case when AGU.COGNOME is null then ''<Autorizzatore>'' else AGU.COGNOME ||'' ''||AGU.NOME end)   BODY_EMAIL'
            || ',  null OGGETTO_POSTIT '
            || 'FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE'
            || ', RINF_AMMINISTRAZIONE_EVO.DETTAGLIO_AUTORIZZAZIONI DA'
            || ', RINF_SICUREZZA_EVO.ANAG_UTENTE AGU'
            || ' WHERE '
            || ' UE.CODICE_EVENTO = '
            || p_EventID
            || ' AND UE.FLAG_MAIL = 1 '
            || ' AND UE.E_MAIL IS NOT NULL '
            || ' AND DA.ID_UTENTE = AGU.ID_UTENTE '
            || ' AND UE.CODICE_TIPO_DEPOSITARIO in (-1, 1) AND UE.CODICE_RUOLO in (1, 5) '
            || ' AND (UE.CODICE_DTP = '''
            || UPPER (p_DtpId)
            || ''' OR (UE.CODICE_DTP = ''-1'' AND CODICE_RUOLO = 1) )'
            || ' AND DA.CODICE_DTP = '''
            || UPPER (p_DtpId)
            || ''' '
            || ' AND DA.DATA_AUTORIZZAZIONE IS NOT NULL '
            || ' AND DA.FLAG_SEDE_CENTRALE = 0'
            || ' AND DA.CODICE_RICHIESTA= '
            || p_CodiceRichiesta;
      WHEN p_EventId = 8 --Avvenuta trasmissione all'Amministratore e al resp.le Trasmissione
      --03/10/2016 è stato creato un nuovo evento dedicato al Dest. Ist. perchè a lui non devono essere inviati gli allegati
      THEN
         SELECT TO_CHAR (TRUNC (t.DATA_TRASMISSIONE), 'dd/mm/yyyy'),
                v.PROTOCOLLO NUMERO_PROTOCOLLO,
                T.FTPS FTP_ADDRESS,
                t.CODICE_VERSIONE
           INTO l_dataTrasmissione,
                l_protocollo,
                l_ftp,
                l_versione
           FROM RINF_PUBBLICATI_EVO.ANAGRAFICA_TRASMISSIONI t,
                RINF_PUBBLICATI_EVO.VERSIONE_RINF v
          WHERE     t.CODICE_VERSIONE = v.CODICE_VERSIONE
                AND t.CODICE_TRASMISSIONE = 1
                AND t.CODICE_VERSIONE =p_Versione;

         myStr :=
               ' SELECT DISTINCT UE.ID_UTENTE, UE.CODICE_UTENTE, UE.E_MAIL, '''||s_ambiente||'''||UE.OGGETTO_EMAIL OGGETTO_EMAIL, '
            || '  replace('
            || '   replace('
            || '    replace('
            || '      replace('
            --||'      replace('
            || '       replace('
            || '        replace(UE.BODY_EMAIL ,''<Nome>'', nvl(ue.nome, ''<Nome>'')), '
            || ' ''<Cognome>'', nvl(ue.cognome, ''<Cognome>'')),'
            || '  ''<Ruolo>'', ue.descrizione), '
            || '  ''<Versione>'', '''
            || TO_CHAR (l_versione)
            || '''), '
            --                ||'  ''<ftp>'', '''||l_ftp||'''), ' modifica del 17/06/2015- la trasmissione non avvine per ftp
            || '  ''<Protocollo>'', '''
            || l_protocollo
            || '''), '
            || '   ''<DataTrasmissione>'', '''
            || l_dataTrasmissione
            || ''' ) BODY_EMAIL'
            || ' ,  null OGGETTO_POSTIT '
            || ' FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE'
            || ' WHERE '
            || ' UE.CODICE_EVENTO = '
            || p_EventID
            || ' AND UE.FLAG_MAIL = 1 '
            || ' AND UE.E_MAIL IS NOT NULL';

WHEN p_EventId = 15 --Avvenuta trasmissione al Destinatario Istituzionale
--03/10/2016 è stato creato un nuovo evento dedicato al Dest. Ist. perchè a lui non devono essere inviati gli allegati
      THEN
         SELECT TO_CHAR (TRUNC (t.DATA_TRASMISSIONE), 'dd/mm/yyyy'),
                v.PROTOCOLLO NUMERO_PROTOCOLLO,
                T.FTPS FTP_ADDRESS,
                t.CODICE_VERSIONE
           INTO l_dataTrasmissione,
                l_protocollo,
                l_ftp,
                l_versione
           FROM RINF_PUBBLICATI_EVO.ANAGRAFICA_TRASMISSIONI t,
                RINF_PUBBLICATI_EVO.VERSIONE_RINF v
          WHERE     t.CODICE_VERSIONE = v.CODICE_VERSIONE
                AND t.CODICE_TRASMISSIONE = 1
                AND t.CODICE_VERSIONE =p_Versione;

         myStr :=
               ' SELECT DISTINCT UE.ID_UTENTE, UE.CODICE_UTENTE, UE.E_MAIL, '''||s_ambiente||'''||UE.OGGETTO_EMAIL OGGETTO_EMAIL, '
            || '  replace('
            || '   replace('
            || '    replace('
            || '      replace('
            --||'      replace('
            || '       replace('
            || '        replace(UE.BODY_EMAIL ,''<Nome>'', nvl(ue.nome, ''<Nome>'')), '
            || ' ''<Cognome>'', nvl(ue.cognome, ''<Cognome>'')),'
            || '  ''<Ruolo>'', ue.descrizione), '
            || '  ''<Versione>'', '''
            || TO_CHAR (l_versione)
            || '''), '
            --                ||'  ''<ftp>'', '''||l_ftp||'''), ' modifica del 17/06/2015- la trasmissione non avvine per ftp
            || '  ''<Protocollo>'', '''
            || l_protocollo
            || '''), '
            || '   ''<DataTrasmissione>'', '''
            || l_dataTrasmissione
            || ''' ) BODY_EMAIL'
            || ' ,  null OGGETTO_POSTIT '
            || ' FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE'
            || ' WHERE '
            || ' UE.CODICE_EVENTO = '
            || p_EventID
            || ' AND UE.FLAG_MAIL = 1 '
            || ' AND UE.E_MAIL IS NOT NULL';
WHEN p_EventId = 9 --Condizione anomala di controllo all'amministratore
      THEN
         myStr :=
               'SELECT DISTINCT'
            || '       v1.ID_UTENTE,'
            || '       v1.CODICE_UTENTE,'
            || '       v1.E_MAIL,'
            || ''''||s_ambiente||'''||AE.EVENT_EMAIL_SUBJECT OGGETTO_EMAIL,'
            || '       REPLACE ('
            || '          REPLACE ('
            || '             REPLACE ('
            || '                REPLACE (AE.EVENT_EMAIL_BODY,'
            || '                         ''<Nome>'','
            || '                         NVL (V1.nome, ''<Nome>'')),'
            || '                ''<Cognome>'','
            || '                NVL (V1.cognome, ''<Cognome>'')),'
            || '             ''<DataAcquisizione>'','
            || '             TO_CHAR (V2.DATA_ACQUISIZIONE, ''dd/mm/yyyy hh24:mi:ss'')),'
            || '          ''<Ruolo>'','
            || '          NVL (V1.DESCRIZIONE, ''<Ruolo>''))'
            || '          BODY_EMAIL,'
            || '       NULL OGGETTO_POSTIT'
            || '  FROM RINF_SICUREZZA_EVO.V_UTENTE_RUOLO v1,'
            || '       RINF_SICUREZZA_EVO.ANAG_EVENTI AE,'
            || '       V_ACQUISIZIONE_DATI_V082 V2'
            || ' WHERE     AE.EVENT_ID = 9'
            || '       AND v1.FLAG_MAIL = 1'
            || '       AND v1.E_MAIL IS NOT NULL'
            || '       AND V1.CODICE_RUOLO = 1'
            || '       AND V2.CODICE_ACQUISIZIONE ='
            || NVL (p_CodiceAcquisizione, 0);
      WHEN p_EventId = 12 --Nuova acquisizione
      THEN
         SELECT CODICE_ACQUISIZIONE
           INTO l_CodiceAcq
           FROM RINF_LAVORAZIONE_EVO.ACQUISIZIONE_DATI a,
                RINF_STAGING_EVO.ANAG_CARICAMENTI c
          WHERE     C.CODICE_CARICAMENTO = A.CODICE_CARICAMENTO
                AND CODICE_ACQUISIZIONE IN
                       (SELECT MAX (codice_acquisizione)
                          FROM RINF_LAVORAZIONE_EVO.ACQUISIZIONE_DATI);

         myStr :=
               'SELECT DISTINCT UE.ID_UTENTE, UE.CODICE_UTENTE, UE.E_MAIL, '''||s_ambiente||'''||UE.OGGETTO_EMAIL OGGETTO_EMAIL,'
            || '    replace(replace(replace(UE.BODY_EMAIL ,''<Nome>'', nvl(ue.nome, ''<Nome>'')), ''<Cognome>'', nvl(ue.cognome, ''<Cognome>'')), ''<DataAcquisizione>'', to_char(DATA_ACQUISIZIONE,''dd/mm/yyyy hh24:mi:ss'')) BODY_EMAIL,'
            || '    null OGGETTO_POSTIT'
            || ' FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE'
            || ', V_ACQUISIZIONE_DATI_V082'
            || ' WHERE  UE.CODICE_EVENTO = '
            || p_EventId
            || ' and CODICE_ACQUISIZIONE = '
            || NVL (p_CodiceAcquisizione, l_CodiceAcq)
            || ' AND CODICE_RUOLO=1  AND UE.FLAG_MAIL = 1  AND UE.E_MAIL IS NOT NULL ';
      WHEN p_EventId = 13 --Nuovo file
      THEN
         myStr :='SELECT DISTINCT'
            ||'       UE.ID_UTENTE,'
            ||'       UE.CODICE_UTENTE,'
            ||'       UE.E_MAIL,'
            ||''''||s_ambiente||'''||       UE.OGGETTO_EMAIL OGGETTO_EMAIL,'
            ||'       REPLACE ('
            ||'          REPLACE ('
            ||'             REPLACE ('
            ||'                REPLACE ('
            ||'                   REPLACE (UE.BODY_EMAIL, ''<Nome>'', NVL (ue.nome, ''<Nome>'')),'
            ||'                   ''<Cognome>'','
            ||'                   NVL (ue.cognome, ''<Cognome>'')),'
            ||'                ''<Ruolo>'','
            ||'                ue.descrizione),'
            ||'             ''<DataRiPronto>'','
            ||'             TO_CHAR (TRUNC (data_pubblicazione), ''dd/mm/yyyy'')),'
            ||'          ''<Versione>'','
            ||'          CODICE_VERSIONE)'
            ||'          BODY_EMAIL,'
            ||'       NULL OGGETTO_POSTIT'
            ||'  FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE,'
            ||'       RINF_PUBBLICATI_EVO.VERSIONE_RINF'
            ||' WHERE     UE.CODICE_EVENTO = 13'
            ||'       AND UE.FLAG_MAIL = 1'
            ||'       AND UE.E_MAIL IS NOT NULL'
            ||'       AND UE.CODICE_RUOLO IN (1,2)'
            ||'       AND CODICE_VERSIONE ='||p_Versione;
       WHEN p_EventId = 14 --Validazione DTP di sede centrale
      THEN
      --18/01/2017 stringa modificata per gestire le sedi centrali multiple
--         myStr :=
--               ' SELECT DISTINCT UE.ID_UTENTE, UE.CODICE_UTENTE, UE.E_MAIL, '''||s_ambiente||'''||UE.OGGETTO_EMAIL OGGETTO_EMAIL'
--            || ',replace('
--            || '  replace('
--            || '  replace('
--            || '   replace('
--            || '    replace('
--            || '     replace('
--            || '      replace(UE.BODY_EMAIL ,''<Nome>'', nvl(ue.nome, ''<Nome>'')), '
--            || ' ''<Cognome>'', nvl(ue.cognome, ''<Cognome>'')),'
--            || '  ''<Ruolo>'', ue.descrizione), '
--            || '  ''<DTPS>'', '''
--            || p_DtpID
--            || '''), '
--            || '   ''<DataAutorizzazione>'', to_char(trunc(data_autorizzazione ), ''dd/mm/yyyy'') ), '
--            || ' ''<Autorizzatore>'', case when AGU.COGNOME is null then ''<Autorizzatore>'' else AGU.COGNOME ||'' ''||AGU.NOME end), '
--            || ' ''<Depositario>'', d.SIGLA_TIPO_DEPOSITARIO)   BODY_EMAIL'
--            || ' ,  null OGGETTO_POSTIT '
--            || ' FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE'
--            || ' , RINF_AMMINISTRAZIONE_EVO.DETTAGLIO_AUTORIZZAZIONI DA'
--            || ' , RINF_SICUREZZA_EVO.ANAG_UTENTE AGU'
--            || ' , RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO d'
--            || ' WHERE '
--            || ' UE.CODICE_EVENTO = '
--            || p_EventID
--            || ' AND UE.FLAG_MAIL = 1 '
--            || ' AND UE.E_MAIL IS NOT NULL'
--            || ' AND DA.ID_UTENTE = AGU.ID_UTENTE '
--            || ' AND ( UE.CODICE_RUOLO in (1) OR '
--            || '  (UE.CODICE_TIPO_DEPOSITARIO =d.CODICE_TIPO_DEPOSITARIO AND UE.CODICE_RUOLO in (5) ) )'
--            || ' AND DA.DATA_AUTORIZZAZIONE IS NOT NULL '
--            || ' AND DA.FLAG_SEDE_CENTRALE <>0'
--            || ' AND da.FLAG_SEDE_CENTRALE=d.CODICE_TIPO_DEPOSITARIO'
--            || ' AND DA.CODICE_DTP in ('
--            || ''''
--            || REPLACE (
--                  p_DtpID,
--                  ';',''',''')
--            || ''''
--            || ' ) '
--            || ' AND DA.CODICE_RICHIESTA= '
--            || p_CodiceRichiesta;

--16/02/2017 Modificata query per estrazione dei soli validatori della stessa Sede Centrale dell'utente che ha autorizzato.
--L'applicazione deve inviare come parametro l'id dell'utetne che ha autorizzato.
            myStr :=
               ' SELECT DISTINCT UE.ID_UTENTE, UE.CODICE_UTENTE, UE.E_MAIL, '''||s_ambiente||'''||UE.OGGETTO_EMAIL OGGETTO_EMAIL' --Amministratori
            || ',replace('
            || '  replace('
            || '  replace('
            || '   replace('
            || '    replace('
            || '     replace('
            || '      replace(UE.BODY_EMAIL ,''<Nome>'', nvl(ue.nome, ''<Nome>'')), '
            || ' ''<Cognome>'', nvl(ue.cognome, ''<Cognome>'')),'
            || '  ''<Ruolo>'', ue.descrizione), '
            || '  ''<DTPS>'', '''
            || p_DtpID
            || '''), '
            || '   ''<DataAutorizzazione>'', to_char(trunc(data_autorizzazione ), ''dd/mm/yyyy'') ), '
            || ' ''<Autorizzatore>'', case when AGU.COGNOME is null then ''<Autorizzatore>'' else AGU.COGNOME ||'' ''||AGU.NOME end), '
            || ' ''<Depositario>'', d.SIGLA_TIPO_DEPOSITARIO)   BODY_EMAIL'
            || ' ,  null OGGETTO_POSTIT '
            || ' FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE'
            || ' , RINF_AMMINISTRAZIONE_EVO.DETTAGLIO_AUTORIZZAZIONI DA'
            || ' , RINF_SICUREZZA_EVO.ANAG_UTENTE AGU'
            || ' , RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO d'
            || ' , (select MAX(DATA_AUTORIZZAZIONE) ultima_autorizzazione '
            || '  from RINF_AMMINISTRAZIONE_EVO.DETTAGLIO_AUTORIZZAZIONI '
            || '  where '
            || '   ID_UTENTE= '|| p_UserId
            || '  AND DATA_AUTORIZZAZIONE IS NOT NULL '
            || '  AND FLAG_SEDE_CENTRALE <>0 '
            || '  AND CODICE_RICHIESTA= '|| p_CodiceRichiesta
            || ') aut_corr '
            || ' WHERE '
            || ' UE.CODICE_EVENTO = '
            || p_EventID
            || ' AND UE.FLAG_MAIL = 1 '
            || ' AND UE.E_MAIL IS NOT NULL'
            || ' AND DA.ID_UTENTE = AGU.ID_UTENTE '
            || ' AND UE.CODICE_RUOLO=1 '
            || ' AND DA.ID_UTENTE= '
            || p_UserId
            || ' AND DA.DATA_AUTORIZZAZIONE=aut_corr.ultima_autorizzazione '
            || ' AND DA.DATA_AUTORIZZAZIONE IS NOT NULL '
            || ' AND DA.FLAG_SEDE_CENTRALE <>0'
            || ' AND da.FLAG_SEDE_CENTRALE=d.CODICE_TIPO_DEPOSITARIO'
            || ' AND DA.CODICE_DTP in ('
            || ''''
            || REPLACE (
                  p_DtpID,
                  ';',''',''')
            || ''''
            || ' ) '
            || ' AND DA.CODICE_RICHIESTA= '
            || p_CodiceRichiesta
            || ' UNION '        --Validatori della STESSA Sede Centrale dell'utente che ha autorizzato
            || ' SELECT DISTINCT UE.ID_UTENTE, UE.CODICE_UTENTE, UE.E_MAIL, '''||s_ambiente||'''||UE.OGGETTO_EMAIL OGGETTO_EMAIL'
            || ',replace('
            || '  replace('
            || '  replace('
            || '   replace('
            || '    replace('
            || '     replace('
            || '      replace(UE.BODY_EMAIL ,''<Nome>'', nvl(ue.nome, ''<Nome>'')), '
            || ' ''<Cognome>'', nvl(ue.cognome, ''<Cognome>'')),'
            || '  ''<Ruolo>'', ue.descrizione), '
            || '  ''<DTPS>'', '''
            || p_DtpID
            || '''), '
            || '   ''<DataAutorizzazione>'', to_char(trunc(data_autorizzazione ), ''dd/mm/yyyy'') ), '
            || ' ''<Autorizzatore>'', case when AGU.COGNOME is null then ''<Autorizzatore>'' else AGU.COGNOME ||'' ''||AGU.NOME end), '
            || ' ''<Depositario>'', d.SIGLA_TIPO_DEPOSITARIO)   BODY_EMAIL'
            || ' ,  null OGGETTO_POSTIT '
            || ' FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE'
            || ' , RINF_AMMINISTRAZIONE_EVO.DETTAGLIO_AUTORIZZAZIONI DA'
            || ' , RINF_SICUREZZA_EVO.ANAG_UTENTE AGU'
            || ' , RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO d'
            || ' , (select MAX(DATA_AUTORIZZAZIONE) ultima_autorizzazione '
            || '  from RINF_AMMINISTRAZIONE_EVO.DETTAGLIO_AUTORIZZAZIONI '
            || '  where '
            || '   ID_UTENTE= '|| p_UserId
            || '  AND DATA_AUTORIZZAZIONE IS NOT NULL '
            || '  AND FLAG_SEDE_CENTRALE <>0 '
            || '  AND CODICE_RICHIESTA= '|| p_CodiceRichiesta
            || ') aut_corr '
            || ' WHERE '
            || ' UE.CODICE_EVENTO = '
            || p_EventID
            || ' AND UE.FLAG_MAIL = 1 '
            || ' AND UE.E_MAIL IS NOT NULL'
            || ' AND DA.ID_UTENTE = AGU.ID_UTENTE '
            || ' AND UE.CODICE_RUOLO=5 '
            || ' AND DA.ID_UTENTE= '
            || p_UserId
            || ' AND DA.DATA_AUTORIZZAZIONE=aut_corr.ultima_autorizzazione '
            || ' AND UE.CODICE_TIPO_DEPOSITARIO = d.CODICE_TIPO_DEPOSITARIO '
            || ' AND DA.DATA_AUTORIZZAZIONE IS NOT NULL '
            || ' AND DA.FLAG_SEDE_CENTRALE <>0'
            || ' AND da.FLAG_SEDE_CENTRALE=d.CODICE_TIPO_DEPOSITARIO'
            || ' AND DA.CODICE_DTP in ('
            || ''''
            || REPLACE (
                  p_DtpID,
                  ';',''',''')
            || ''''
            || ' ) '
            || ' AND DA.CODICE_RICHIESTA= '
            || p_CodiceRichiesta;

      WHEN p_EventId = 102 --Modifica ruolo
      THEN
         OPEN l_cur FOR

            SELECT DISTINCT
                   CASE
                      WHEN dettaglio IS NULL
                      THEN
                         descrizione
                      WHEN gruppo_dati IS NOT NULL
                      THEN
                         descrizione || ' - ' || dettaglio || ' - ' || gruppo_dati
                      ELSE
                         descrizione || ' - ' || dettaglio
                   END
                      profilo
              FROM (  SELECT ar.descrizione,
                             CASE R.CODICE_DTP
                                WHEN '-1'
                                THEN
                                   CASE R.CODICE_UT
                                      WHEN '-1'
                                      THEN
                                         CASE TD.AREA
                                            WHEN 'SC' THEN 'Sede Centrale'
                                            ELSE NULL
                                         END
                                      ELSE
                                         AUT.DESCRIZIONE
                                   END
                                ELSE
                                   DTP.DESCRIZIONE
                             END
                                DETTAGLIO,
                             LISTAGG (td.SIGLA_TIPO_DEPOSITARIO, ', ')
                                WITHIN GROUP (ORDER BY td.SIGLA_TIPO_DEPOSITARIO)
                                gruppo_dati
                        FROM RINF_SICUREZZA_EVO.ANAG_UTENTE au,
                             RINF_SICUREZZA_EVO.ANAG_RUOLO ar,
                             RINF_SICUREZZA_EVO.UTENTE_RUOLI r,
                             RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO td,
                             RINF_ANAGRAFICHE_EVO.ANAG_UT AUT,
                             RINF_ANAGRAFICHE_EVO.ANAG_DTP DTP
                       WHERE     R.CODICE_RUOLO <> 4
                             AND AR.CODICE_RUOLO = R.CODICE_RUOLO
                             AND R.CODICE_TIPO_DEPOSITARIO = TD.CODICE_TIPO_DEPOSITARIO
                             AND R.ID_UTENTE = AU.ID_UTENTE
                             AND AUT.CODICE_UT = R.CODICE_UT
                             AND DTP.CODICE_DTP = R.CODICE_DTP
                             AND AU.ID_UTENTE = p_UserId
                    GROUP BY ar.descrizione,
                             CASE R.CODICE_DTP
                                WHEN '-1'
                                THEN
                                   CASE R.CODICE_UT
                                      WHEN '-1'
                                      THEN
                                         CASE TD.AREA
                                            WHEN 'SC' THEN 'Sede Centrale'
                                            ELSE NULL
                                         END
                                      ELSE
                                         AUT.DESCRIZIONE
                                   END
                                ELSE
                                   DTP.DESCRIZIONE
                             END
                    UNION
                      SELECT ar.descrizione,
                             CASE R.CODICE_DTP
                                WHEN '-1'
                                THEN
                                   CASE R.CODICE_UT
                                      WHEN '-1'
                                      THEN
                                         CASE TD.AREA
                                            WHEN 'SC' THEN 'Sede Centrale'
                                            ELSE NULL
                                         END
                                      ELSE
                                         AUT.DESCRIZIONE
                                   END
                                ELSE
                                   DTP.DESCRIZIONE
                             END
                                DETTAGLIO,
                             LISTAGG (td.SIGLA_TIPO_DEPOSITARIO, ', ')
                                WITHIN GROUP (ORDER BY td.SIGLA_TIPO_DEPOSITARIO)
                                gruppo_dati
                        FROM RINF_SICUREZZA_EVO.ANAG_UTENTE au,
                             RINF_SICUREZZA_EVO.ANAG_RUOLO ar,
                             RINF_SICUREZZA_EVO.UTENTE_RUOLI r,
                             RINF_SICUREZZA_EVO.ANAG_TIPO_DEPOSITARIO td,
                             RINF_ANAGRAFICHE_EVO.ANAG_UT AUT,
                             RINF_ANAGRAFICHE_EVO.ANAG_DTP DTP
                       WHERE     R.CODICE_RUOLO = 4
                             AND AR.CODICE_RUOLO = R.CODICE_RUOLO
                             AND R.CODICE_TIPO_DEPOSITARIO = TD.CODICE_TIPO_DEPOSITARIO
                             AND R.ID_UTENTE = AU.ID_UTENTE
                             AND AUT.CODICE_UT = R.CODICE_UT
                             AND DTP.CODICE_DTP = R.CODICE_DTP
                             AND AU.ID_UTENTE = p_UserId
                    GROUP BY ar.descrizione,
                             CASE R.CODICE_DTP
                                WHEN '-1'
                                THEN
                                   CASE R.CODICE_UT
                                      WHEN '-1'
                                      THEN
                                         CASE TD.AREA
                                            WHEN 'SC' THEN 'Sede Centrale'
                                            ELSE NULL
                                         END
                                      ELSE
                                         AUT.DESCRIZIONE
                                   END
                                ELSE
                                   DTP.DESCRIZIONE
                             END);

         LOOP
            FETCH l_cur INTO r_profilo;

            EXIT WHEN l_cur%NOTFOUND;

            IF l_cur%ROWCOUNT = 1
            THEN
               l_profilo := r_profilo;
            ELSE
               l_profilo := l_profilo || '; ' || r_profilo;
            END IF;
         END LOOP;

         CLOSE l_cur;


         myStr :=
               'SELECT ID_UTENTE, CODICE_UTENTE, E_MAIL, '
            || ''''||s_ambiente||'''|| UE.EVENT_EMAIL_SUBJECT OGGETTO_EMAIL,  '
            || '  replace('
            || '   replace('
            || '        replace(EVENT_EMAIL_BODY ,''<Nome>'', nvl(nome, ''<Nome>'')), '
            || ' ''<Cognome>'', nvl(cognome, ''<Cognome>'')) '
            || '  , ''<NuovoRuolo>'', '''
            || l_profilo
            || ''' )'
            || '  BODY_EMAIL'
            || ' from RINF_SICUREZZA_EVO.ANAG_EVENTI ue  '
            || ', RINF_SICUREZZA_EVO.ANAG_UTENTE '
            || ' where event_id ='
            || p_EventId
            || ' and ID_UTENTE = '
            || p_UserId
            || ' and FLAG_MAIL = 1';

         --        Se il parametr op_DtpId non è nullo, vuol dire che all'utente è stato assegnato un nuovo ruolo di depositario di una DTP o di una UT
         --        e bisogna mandare una mail di notifica al validatore responsabile (evento 105)
         IF p_DtpId IS NOT NULL
         THEN
            OPEN l_cur FOR
               WITH test AS (SELECT p_DtpId str FROM DUAL)
                   SELECT REGEXP_SUBSTR (str,
                                         '[^;]+',
                                         1,
                                         ROWNUM)
                             split
                     FROM test
               CONNECT BY LEVEL <= LENGTH (REGEXP_REPLACE (str, '[^;]+')) + 1;

            LOOP
               FETCH l_cur INTO r_profilo;

               EXIT WHEN l_cur%NOTFOUND;
               l_dtp := l_dtp || ' ''' || r_profilo || ''',';
            END LOOP;

            CLOSE l_cur;

            --tolgo l'ultima virgola
            l_dtp := SUBSTR (l_dtp, 1, LENGTH (l_dtp) - 1);



            MyDett :=
                  'SELECT DISTINCT        ' --La prima select restituisce i depositari di DTP
               || '         rval.ID_UTENTE,        '
               || '         rval.CODICE_UTENTE,    '
               || '         rval.E_MAIL,           '
               || ''''||s_ambiente||'''||UE.EVENT_EMAIL_SUBJECT OGGETTO_EMAIL,'
               || '         REPLACE (                            '
               || '            REPLACE (                         '
               || '               REPLACE (                      '
               || '                  REPLACE (                   '
               || '                     REPLACE (                '
               || '                        REPLACE (             '
               || '                           REPLACE (          '
               || '                              REPLACE (       '
               || '                                 REPLACE (EVENT_EMAIL_BODY,        '
               || '                                          ''<Nome>'',                   '
               || '                                          NVL (rval.nome, ''<Nome>'')), '
               || '                                 ''<Cognome>'',                         '
               || '                                 NVL (rval.cognome, ''<Cognome>'')),    '
               || '                              ''<RuoloVal>'',                           '
               || '                              NVL (rval.DESCRIZIONE, ''<RuoloVal>'')),  '
               || '                           ''<DtpVal>'',                                '
               || '                           DECODE (rval.CODICE_DTP,                     '
               || '                                   ''-1'', ''Sede Centrale'',           '
               || '                                   rval.CODICE_DTP)),                   '
               || '                        ''<NomeDep>'',                                  '
               || '                        NVL (rdep.nome, ''<NomeDep>'')),                '
               || '                     ''<CognomeDep>'',                                  '
               || '                     NVL (rdep.cognome, ''<CognomeDep>'')),             '
               || '                  ''<NuovoRuoloDep>'',                                  '
               || '                  NVL (rdep.DESCRIZIONE, ''<NuovoRuoloDep>'')),         '
               || '               ''<DtpDep>'',                '
               || '               NVL (                                    '
               || '                  DECODE (rdep.CODICE_DTP,              '
               || '                          ''-1'', ''Sede Centrale'',    '
               || '                          rdep.CODICE_DTP),             '
               || '                  ''<DtpDep>'')),                       '
               || '            ''<TipoDep>'',                              '
               || '            LISTAGG (RDEP.SIGLA_TIPO_DEPOSITARIO, '', '')        '
               || '               WITHIN GROUP (ORDER BY RDEP.SIGLA_TIPO_DEPOSITARIO))     '
               || '            BODY_EMAIL '
               || '    FROM (SELECT DISTINCT ID_UTENTE,        '
               || '                          CODICE_DTP,           '
               || '                          CODICE_UTENTE,        '
               || '                          E_MAIL,               '
               || '                          nome,                 '
               || '                          cognome,              '
               || '                          descrizione           '
               || '            FROM RINF_SICUREZZA_EVO.V_UTENTE_RUOLO  '
               || '           WHERE     CODICE_RUOLO = 5           '
               || '                 AND FLAG_MAIL = 1              '
               || '                 AND CODICE_DTP IN ('    --Depositari delle DTP della lista
               || l_dtp
               || ')  '
               || '                 AND E_MAIL IS NOT NULL) rval,                           '
               || '         RINF_SICUREZZA_EVO.V_UTENTE_RUOLO rdep,                             '
               || '         RINF_SICUREZZA_EVO.ANAG_EVENTI ue                                   '
               || '   WHERE     event_id = 105                                              '
               || '         AND rdep.CODICE_RUOLO = 4                                       '
               || '         AND rdep.ID_UTENTE = '
               || p_UserId
               || '         AND rval.CODICE_DTP = rdep.CODICE_DTP                           '
               || '         AND  rdep.CODICE_DTP <>''-1'' '         --07/03/2017 inserita condizione per evitare doppia mail ai validatori di SC
               || '         AND rdep.CODICE_DTP IN ('
               || l_dtp
               || ')  '
               || 'GROUP BY rval.ID_UTENTE,        '
               || '         rval.CODICE_DTP,               '
               || '         rval.CODICE_UTENTE,            '
               || '         rval.E_MAIL,                   '
               || '         UE.EVENT_EMAIL_SUBJECT,        '
               || '         EVENT_EMAIL_BODY,              '
               || '         rval.nome,                     '
               || '         rval.cognome,                  '
               || '         rdep.nome,                     '
               || '         rdep.cognome,                  '
               || '         rdep.DESCRIZIONE,              '
               || '         rval.DESCRIZIONE,              '
               || '         rdep.CODICE_DTP                '
               || ' UNION '
               || '                  SELECT DISTINCT        ' --La seconda select restituisce i depositari di UT
               || '         rval.ID_UTENTE,        '
               || '         rval.CODICE_UTENTE,    '
               || '         rval.E_MAIL,           '
               || ''''||s_ambiente||'''||UE.EVENT_EMAIL_SUBJECT OGGETTO_EMAIL,'
               || '         REPLACE (                            '
               || '            REPLACE (                         '
               || '               REPLACE (                      '
               || '                  REPLACE (                   '
               || '                     REPLACE (                '
               || '                        REPLACE (             '
               || '                           REPLACE (          '
               || '                              REPLACE (       '
               || '                                 REPLACE (EVENT_EMAIL_BODY,        '
               || '                                          ''<Nome>'',                   '
               || '                                          NVL (rval.nome, ''<Nome>'')), '
               || '                                 ''<Cognome>'',                         '
               || '                                 NVL (rval.cognome, ''<Cognome>'')),    '
               || '                              ''<RuoloVal>'',                           '
               || '                              NVL (rval.DESCRIZIONE, ''<RuoloVal>'')),  '
               || '                           ''<DtpVal>'',                                '
               || '                           DECODE (rval.CODICE_DTP,                     '
               || '                                   ''-1'', ''Sede Centrale'',           '
               || '                                   rval.CODICE_DTP)),                   '
               || '                        ''<NomeDep>'',                                  '
               || '                        NVL (rdep.nome, ''<NomeDep>'')),                '
               || '                     ''<CognomeDep>'',                                  '
               || '                     NVL (rdep.cognome, ''<CognomeDep>'')),             '
               || '                  ''<NuovoRuoloDep>'',                                  '
               || '                  NVL (rdep.DESCRIZIONE, ''<NuovoRuoloDep>'')),         '
               || '               ''<DtpDep>'',                '
               || '               NVL (                                    '
               || '                          rdep.CODICE_UT,             '
               || '                  ''<DtpDep>'')),                       '
               || '            ''<TipoDep>'',                              '
               || '            LISTAGG (RDEP.SIGLA_TIPO_DEPOSITARIO, '', '')        '
               || '               WITHIN GROUP (ORDER BY RDEP.SIGLA_TIPO_DEPOSITARIO))     '
               || '            BODY_EMAIL '
               || '    FROM (SELECT DISTINCT ID_UTENTE,        '
               || '                          CODICE_DTP,           '
               || '                          CODICE_UTENTE,        '
               || '                          E_MAIL,               '
               || '                          nome,                 '
               || '                          cognome,              '
               || '                          descrizione           '
               || '            FROM RINF_SICUREZZA_EVO.V_UTENTE_RUOLO  '
               || '           WHERE     CODICE_RUOLO = 5           '
               || '                 AND FLAG_MAIL = 1              '
               || '                 AND CODICE_DTP IN ('
               || l_dtp
               || ')  '
               || '                 AND E_MAIL IS NOT NULL) rval,                           ' --Validatori delle DTP della lista
               || '         RINF_SICUREZZA_EVO.V_UTENTE_RUOLO rdep,                             '
               || '         RINF_SICUREZZA_EVO.ANAG_EVENTI ue                                   '
               || '   WHERE     event_id = 105                                              '
               || '         AND rdep.CODICE_RUOLO = 4                                       '
               || '         AND rdep.CODICE_UT<>''-1''  '
               || '         AND rdep.ID_UTENTE = '
               || p_UserId
               || '         AND rval.CODICE_DTP = substr(rdep.CODICE_UT,1,2)||''00''        ' --Depositari delle UT appartenenti alle DTP della lista
               || '         AND substr(rdep.CODICE_UT,1,2)||''00'' IN ('
               || l_dtp
               || ')  '
               || 'GROUP BY rval.ID_UTENTE,        '
               || '         rval.CODICE_DTP,               '
               || '         rval.CODICE_UTENTE,            '
               || '         rval.E_MAIL,                   '
               || '         UE.EVENT_EMAIL_SUBJECT,        '
               || '         EVENT_EMAIL_BODY,              '
               || '         rval.nome,                     '
               || '         rval.cognome,                  '
               || '         rdep.nome,                     '
               || '         rdep.cognome,                  '
               || '         rdep.DESCRIZIONE,              '
               || '         rval.DESCRIZIONE,              '
               || '         rdep.CODICE_DTP,                '
               || '         rdep.CODICE_UT                 '
               || ' UNION '                                     --La terza select restituisce i depositari di Sede Centrale
               || '                  SELECT DISTINCT        '
               || '         rval.ID_UTENTE,        '
               || '         rval.CODICE_UTENTE,    '
               || '         rval.E_MAIL,           '
               || ''''||s_ambiente||'''||UE.EVENT_EMAIL_SUBJECT OGGETTO_EMAIL,'
               || '         REPLACE (                            '
               || '            REPLACE (                         '
               || '               REPLACE (                      '
               || '                  REPLACE (                   '
               || '                     REPLACE (                '
               || '                        REPLACE (             '
               || '                           REPLACE (          '
               || '                              REPLACE (       '
               || '                                 REPLACE (EVENT_EMAIL_BODY,        '
               || '                                          ''<Nome>'',                   '
               || '                                          NVL (rval.nome, ''<Nome>'')), '
               || '                                 ''<Cognome>'',                         '
               || '                                 NVL (rval.cognome, ''<Cognome>'')),    '
               || '                              ''<RuoloVal>'',                           '
               || '                              NVL (rval.DESCRIZIONE, ''<RuoloVal>'')),  '
               || '                           ''<DtpVal>'',                                '
               || '                           DECODE (rval.CODICE_DTP,                     '
               || '                                   ''-1'', ''Sede Centrale ''||LISTAGG (RDEP.SIGLA_TIPO_DEPOSITARIO, '', '') WITHIN GROUP (ORDER BY RDEP.SIGLA_TIPO_DEPOSITARIO),           '
               || '                                   rval.CODICE_DTP)),                   '
               || '                        ''<NomeDep>'',                                  '
               || '                        NVL (rdep.nome, ''<NomeDep>'')),                '
               || '                     ''<CognomeDep>'',                                  '
               || '                     NVL (rdep.cognome, ''<CognomeDep>'')),             '
               || '                  ''<NuovoRuoloDep>'',                                  '
               || '                  NVL (rdep.DESCRIZIONE, ''<NuovoRuoloDep>'')),         '
               || '               ''<DtpDep>'',                '
               || '               NVL (                                    '
               || '                  DECODE (rdep.CODICE_DTP,              '
               || '                          ''-1'', ''Sede Centrale'',    '
               || '                          rdep.CODICE_DTP),             '
               || '                  ''<DtpDep>'')),                       '
               || '            ''<TipoDep>'',                              '
               || '            LISTAGG (RDEP.SIGLA_TIPO_DEPOSITARIO, '', '')        '
               || '               WITHIN GROUP (ORDER BY RDEP.SIGLA_TIPO_DEPOSITARIO))     '
               || '            BODY_EMAIL '
               || '    FROM (SELECT DISTINCT ID_UTENTE,        '
               || '                          CODICE_DTP,           '
               || '                          CODICE_UTENTE,        '
               || '                          E_MAIL,               '
               || '                          nome,                 '
               || '                          cognome,              '
               || '                          descrizione,           '
               || '                          SIGLA_TIPO_DEPOSITARIO           '
               || '            FROM RINF_SICUREZZA_EVO.V_UTENTE_RUOLO  '
               || '           WHERE     CODICE_RUOLO = 5           '
               || '                 AND FLAG_MAIL = 1              '
               || '                 AND CODICE_DTP =''-1'' '
               || '                 AND CODICE_UT =''-1'' '
               || '                 AND E_MAIL IS NOT NULL) rval,                           ' --Validatori di Sede Centrale
               || '         RINF_SICUREZZA_EVO.V_UTENTE_RUOLO rdep,                             '
               || '         RINF_SICUREZZA_EVO.ANAG_EVENTI ue                                   '
               || '   WHERE     event_id = 105                                              '
               || '         AND rdep.CODICE_RUOLO = 4                                       ' --Depositari di Sede Centrale
               || '         AND rdep.CODICE_UT=''-1''  '
               || '         AND rdep.CODICE_DTP=''-1''  '
               || '         AND rdep.SIGLA_TIPO_DEPOSITARIO=rval.SIGLA_TIPO_DEPOSITARIO '
               || '         AND rdep.ID_UTENTE = '
               || p_UserId
               || 'GROUP BY rval.ID_UTENTE,        '
               || '         rval.CODICE_DTP,               '
               || '         rval.CODICE_UTENTE,            '
               || '         rval.E_MAIL,                   '
               || '         UE.EVENT_EMAIL_SUBJECT,        '
               || '         EVENT_EMAIL_BODY,              '
               || '         rval.nome,                     '
               || '         rval.cognome,                  '
               || '         rdep.nome,                     '
               || '         rdep.cognome,                  '
               || '         rdep.DESCRIZIONE,              '
               || '         rval.DESCRIZIONE,              '
               || '         rdep.CODICE_DTP                ';

            myStr := myStr || ' UNION ' || myDett;
         ELSE
         --Se il parametro p_DtpId è nullo, è necessario verificare che l'utente sia un depositario di sede centrale e nel caso inviare la mail
         --al validatore di Sede Centrale
            myStr := myStr || ' UNION '
               || '                  SELECT DISTINCT        '
               || '         rval.ID_UTENTE,        '
               || '         rval.CODICE_UTENTE,    '
               || '         rval.E_MAIL,           '
               || ''''||s_ambiente||'''||UE.EVENT_EMAIL_SUBJECT OGGETTO_EMAIL,'
               || '         REPLACE (                            '
               || '            REPLACE (                         '
               || '               REPLACE (                      '
               || '                  REPLACE (                   '
               || '                     REPLACE (                '
               || '                        REPLACE (             '
               || '                           REPLACE (          '
               || '                              REPLACE (       '
               || '                                 REPLACE (EVENT_EMAIL_BODY,        '
               || '                                          ''<Nome>'',                   '
               || '                                          NVL (rval.nome, ''<Nome>'')), '
               || '                                 ''<Cognome>'',                         '
               || '                                 NVL (rval.cognome, ''<Cognome>'')),    '
               || '                              ''<RuoloVal>'',                           '
               || '                              NVL (rval.DESCRIZIONE, ''<RuoloVal>'')),  '
               || '                           ''<DtpVal>'',                                '
               || '                           DECODE (rval.CODICE_DTP,                     '
               || '                                   ''-1'', ''Sede Centrale ''||LISTAGG (RDEP.SIGLA_TIPO_DEPOSITARIO, '', '') WITHIN GROUP (ORDER BY RDEP.SIGLA_TIPO_DEPOSITARIO),           '
               || '                                   rval.CODICE_DTP)),                   '
               || '                        ''<NomeDep>'',                                  '
               || '                        NVL (rdep.nome, ''<NomeDep>'')),                '
               || '                     ''<CognomeDep>'',                                  '
               || '                     NVL (rdep.cognome, ''<CognomeDep>'')),             '
               || '                  ''<NuovoRuoloDep>'',                                  '
               || '                  NVL (rdep.DESCRIZIONE, ''<NuovoRuoloDep>'')),         '
               || '               ''<DtpDep>'',                '
               || '               NVL (                                    '
               || '                  DECODE (rdep.CODICE_DTP,              '
               || '                          ''-1'', ''Sede Centrale'',    '
               || '                          rdep.CODICE_DTP),             '
               || '                  ''<DtpDep>'')),                       '
               || '            ''<TipoDep>'',                              '
               || '            LISTAGG (RDEP.SIGLA_TIPO_DEPOSITARIO, '', '')        '
               || '               WITHIN GROUP (ORDER BY RDEP.SIGLA_TIPO_DEPOSITARIO))     '
               || '            BODY_EMAIL '
               || '    FROM (SELECT DISTINCT ID_UTENTE,        '
               || '                          CODICE_DTP,           '
               || '                          CODICE_UTENTE,        '
               || '                          E_MAIL,               '
               || '                          nome,                 '
               || '                          cognome,              '
               || '                          descrizione,           '
               || '                          SIGLA_TIPO_DEPOSITARIO  '
               || '            FROM RINF_SICUREZZA_EVO.V_UTENTE_RUOLO  '
               || '           WHERE     CODICE_RUOLO = 5           '
               || '                 AND FLAG_MAIL = 1              '
               || '                 AND CODICE_DTP =''-1'' '    --Validatore  di Sede Centrale
               || '                 AND CODICE_UT =''-1'' '
               || '                 AND E_MAIL IS NOT NULL) rval,                           '
               || '         RINF_SICUREZZA_EVO.V_UTENTE_RUOLO rdep,                             '
               || '         RINF_SICUREZZA_EVO.ANAG_EVENTI ue                                   '
               || '   WHERE     event_id = 105                                              '
               || '         AND rdep.CODICE_RUOLO = 4                                       '
               || '         AND rdep.CODICE_UT=''-1''  ' --Depositario di Sede Centrale
               || '         AND rdep.CODICE_DTP=''-1''  '
               || '         AND rdep.SIGLA_TIPO_DEPOSITARIO=rval.SIGLA_TIPO_DEPOSITARIO '
               || '         AND rdep.ID_UTENTE = '
               || p_UserId
               || 'GROUP BY rval.ID_UTENTE,        '
               || '         rval.CODICE_DTP,               '
               || '         rval.CODICE_UTENTE,            '
               || '         rval.E_MAIL,                   '
               || '         UE.EVENT_EMAIL_SUBJECT,        '
               || '         EVENT_EMAIL_BODY,              '
               || '         rval.nome,                     '
               || '         rval.cognome,                  '
               || '         rdep.nome,                     '
               || '         rdep.cognome,                  '
               || '         rdep.DESCRIZIONE,              '
               || '         rval.DESCRIZIONE,              '
               || '         rdep.CODICE_DTP                ';
         END IF;
      ELSE
         myStr :=
            'SELECT DISTINCT UE.ID_UTENTE, UE.CODICE_UTENTE, UE.E_MAIL, '''||s_ambiente||'''||UE.OGGETTO_EMAIL OGGETTO_EMAIL, UE.BODY_EMAIL ';

         myStr :=
               myStr
            || ', null OGGETTO_POSTIT '
            || ' FROM RINF_SICUREZZA_EVO.V_UTENTE_EVENTI UE '
            || ' WHERE '
            || ' UE.CODICE_EVENTO = '
            || p_EventId
            || ' AND UE.FLAG_MAIL = 1 '
            || ' AND UE.E_MAIL IS NOT NULL ';

   END CASE;



   DBMS_OUTPUT.PUT_LINE (myStr);

   OPEN p_cursor FOR myStr;
END GetMailByEvent;
--
-- ----------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------
--

   Procedure GetFooter (p_cursor OUT empcur) is
    myStr varchar2(4000);
   begin


        myStr := 'Select FOO_FOOTER footer from RINF_SICUREZZA_EVO.EMAIL_FOOTER '
        ||' WHERE FOO_ID = 1 ';
        DBMS_OUTPUT.PUT_LINE(myStr);
        --myStr := 'Select ''Si prega di non rispondere a questa mail in quando generata automaticamente dal sistema RFI-RINF. Per richiedere informazioni usare la funzione apposita del sistema RFI-RINF o aprire un cartellino al service desk'' footer from dual';
        OPEN p_cursor FOR myStr;
   end;

-- -------------------
END PKG_RINF_SICUREZZA;
/