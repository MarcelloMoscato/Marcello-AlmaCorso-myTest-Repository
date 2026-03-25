-- Package per l'Oscuramento e l'Illuminazione delle Carte di Credito
------------------------------------------------------------------------------------------------------------------------------------------

-- (1)  Definizione delle Strutture Tecniche di Supporto
-- (2)  Definizione del Package Pkg_Oscura_Illumina_CCard sul Primo e Secondo Livello
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------


















-- Dwh_Dm
-------------------






create table Wt_Token_Table
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Tabella_Token Varchar2(30),
	Tabella_NoCrypto Varchar2(30),
	SqlScript_Creazione_Token CLob,
	SqlScript_Carica_Token CLob,
	SqlScript_Rinomina_Token CLob,
	Des_Stato_Oscuramento Varchar2(100),
	Dat_Aggiornamento Date,
	constraint XPK_Wt_Token_Table Primary Key
	(
		Nome_Utente,
		Nome_Tabella
	)
)
tablespace Tbs_B;

create table Wt_Pan_Table
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Tabella_Pan Varchar2(30),
	Tabella_Oscurata Varchar2(30),
	SqlScript_Creazione_Pan CLob,
	SqlScript_Carica_Pan CLob,
	SqlScript_Rinomina_Pan CLob,
	Des_Stato_Illuminazione Varchar2(100),
	Dat_Aggiornamento Date,
	constraint XPK_Wt_Pan_Table Primary Key
	(
		Nome_Utente,
		Nome_Tabella
	)
)
tablespace Tbs_B;


create table Wt_Token_Index
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Nome_Indice Varchar2(30),
	Tipo_Indice Varchar2(27),
	Univocita_Indice Varchar2(9),
	Indice_Token Varchar2(30),
	Indice_NoCrypto Varchar2(30),
	constraint XPK_Wt_Token_Index Primary Key
	(
		Nome_Utente,
		Nome_Indice
	)
)
tablespace Tbs_B;

create table Wt_Pan_Index
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Nome_Indice Varchar2(30),
	Tipo_Indice Varchar2(27),
	Univocita_Indice Varchar2(9),
	Indice_Pan Varchar2(30),
	Indice_Oscurata Varchar2(30),
	constraint XPK_Wt_Pan_Index Primary Key
	(
		Nome_Utente,
		Nome_Indice
	)
)
tablespace Tbs_B;


create table Wt_Token_Constraint
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Nome_Constraint Varchar2(30) not null,
	Tipo_Constraint Varchar2(1),
	Constraint_Token Varchar2(30),
	Constraint_NoCrypto Varchar2(30),
	constraint XPK_Wt_Token_Constraint Primary Key
	(
		Nome_Utente,
		Nome_Tabella,
		Nome_Constraint
	)
)
tablespace Tbs_B;

create table Wt_Pan_Constraint
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Nome_Constraint Varchar2(30) not null,
	Tipo_Constraint Varchar2(1),
	Constraint_Pan Varchar2(30),
	Constraint_Oscurata Varchar2(30),
	constraint XPK_Wt_Pan_Constraint Primary Key
	(
		Nome_Utente,
		Nome_Tabella,
		Nome_Constraint
	)
)
tablespace Tbs_B;


create table Wt_Token_Partition
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Numero_Partizioni Number,
	Nome_Partizione Varchar2(30) not null,
	Part_Tablespace Varchar2(30),
	Part_Compression Varchar2(9),
	Partition_Position Number,
	Numero_SottoPartizioni Number,
	Nome_SottoPartizione Varchar2(30) not null,
	SubPart_Tablespace Varchar2(30),
	SubPart_Compression Varchar2(9),
	SubPart_Position Number,
	Nome_Utente_Tk Varchar2(30),
	Nome_Tabella_Tk Varchar2(30),
	Nome_Partizione_Tk Varchar2(30),
	Part_Tablespace_Tk Varchar2(30),
	Part_Compression_Tk Varchar2(9),
	Partition_Position_Tk Number,
	Numero_SottoPartizioni_Tk Number,
	Nome_SottoPartizione_Tk Varchar2(30),
	SubPart_Tablespace_Tk Varchar2(30),
	SubPart_Compression_Tk Varchar2(9),
	SubPart_Position_Tk Number,
	constraint XPK_Wt_Token_Partition Primary Key
	(
		Nome_Utente,
		Nome_Tabella,
		Nome_Partizione,
		Nome_SottoPartizione
	)
)
tablespace Tbs_B;

create table Wt_Pan_Partition
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Numero_Partizioni Number,
	Nome_Partizione Varchar2(30) not null,
	Part_Tablespace Varchar2(30),
	Part_Compression Varchar2(9),
	Partition_Position Number,
	Numero_SottoPartizioni Number,
	Nome_SottoPartizione Varchar2(30) not null,
	SubPart_Tablespace Varchar2(30),
	SubPart_Compression Varchar2(9),
	SubPart_Position Number,
	Nome_Utente_Pan Varchar2(30),
	Nome_Tabella_Pan Varchar2(30),
	Nome_Partizione_Pan Varchar2(30),
	Part_Tablespace_Pan Varchar2(30),
	Part_Compression_Pan Varchar2(9),
	Partition_Position_Pan Number,
	Numero_SottoPartizioni_Pan Number,
	Nome_SottoPartizione_Pan Varchar2(30),
	SubPart_Tablespace_Pan Varchar2(30),
	SubPart_Compression_Pan Varchar2(9),
	SubPart_Position_Pan Number,
	constraint XPK_Wt_Pan_Partition Primary Key
	(
		Nome_Utente,
		Nome_Tabella,
		Nome_Partizione,
		Nome_SottoPartizione
	)
)
tablespace Tbs_B;


create sequence Sq_Tab_Partition_Token
increment by 1
start with 1
MaxValue 99999
NoCache
order;

create sequence Sq_Tab_Partition_Pan
increment by 1
start with 1
MaxValue 99999
NoCache
order;






create or replace
Package Pkg_Oscura_Illumina_CCard
Is

	Procedure Prc_Crea_Copia_Token(
			prmUtente In Varchar2,
			prmTabella In Varchar2
		);

	Procedure Prc_Crea_Token_Upload(
			prmUtente In Varchar2,
			prmTabella In Varchar2,
			prmElencoCampi_CCard In Varchar2,  -- I Campi rappresentanti Carte di Credito dovranno essere separati dal carattere ':'
			prmTipoUpload In Varchar2 Default 'Partizione',
			prmMoltiplicaPar_Master In Integer Default 1,
			prmMoltiplicaPar_Config In Integer Default 1,
			prmTipoStatistica In Varchar2 Default 'Parziale',
			prmFattoreStima In Integer Default 100,  -- Fattore di Divisione, rispetto all'unità, per determinare la frazione di Stima
			prmStatDegree In Integer Default 16
		);

	Procedure Prc_Crea_Rinomina_Token(
			prmUtente In Varchar2,
			prmTabella In Varchar2
		);

	Procedure Prc_Crea_Copia_Pan(
			prmUtente In Varchar2,
			prmTabella In Varchar2
		);

	Procedure Prc_Crea_Pan_Upload(
			prmUtente In Varchar2,
			prmTabella In Varchar2,
			prmElencoCampi_CCard In Varchar2,  -- I Campi rappresentanti Carte di Credito dovranno essere separati dal carattere ':'
			prmTipoUpload In Varchar2 Default 'Partizione',
			prmMoltiplicaPar_Master In Integer Default 1,
			prmMoltiplicaPar_Config In Integer Default 1,
			prmTipoStatistica In Varchar2 Default 'Parziale',
			prmFattoreStima In Integer Default 100,  -- Fattore di Divisione, rispetto all'unità, per determinare la frazione di Stima
			prmStatDegree In Integer Default 16
		);

	Procedure Prc_Crea_Rinomina_Pan(
			prmUtente In Varchar2,
			prmTabella In Varchar2
		);

	Procedure Prc_Allinea_Token_Pan_Info(
			prmUtente In Varchar2,
			prmTabella In Varchar2,
			prmTipoChiusura In Varchar2
		);


End Pkg_Oscura_Illumina_CCard;
/



create or replace
Package Body Pkg_Oscura_Illumina_CCard
Is

	NomePackage Constant Varchar2(30) := upper('Pkg_Oscura_Illumina_CCard');

	StatoAssente Constant Varchar2(100) := '<Assente>';

	TokenTab_Disponibile Constant Varchar2(100) := 'Script Creazione Tabella Token Disponibile';
	TokenTab_Creata Constant Varchar2(100) := 'Script Creazione Tabella Token ESEGUITO';
	TokenUpload_Generato Constant Varchar2(100) := 'Script Upload Token Disponibile';
	TokenUpload_Eseguito Constant Varchar2(100) := 'Script Upload Token ESEGUITO';
	TokenRinomina_Disponibile Constant Varchar2(100) := 'Script Rinomina Token Disponibile';
	StatoToken_Completo Constant Varchar2(100) := 'Oscuramento Carte Credito COMPLETATO';

	PanTab_Disponibile Constant Varchar2(100) := 'Script Creazione Tabella Pan Disponibile';
	PanTab_Creata Constant Varchar2(100) := 'Script Creazione Tabella Pan ESEGUITO';
	PanUpload_Generato Constant Varchar2(100) := 'Script Upload Pan Disponibile';
	PanUpload_Eseguito Constant Varchar2(100) := 'Script Upload Pan ESEGUITO';
	PanRinomina_Disponibile Constant Varchar2(100) := 'Script Rinomina Pan Disponibile';
	StatoPan_Completo Constant Varchar2(100) := 'Illuminazione Carte Credito COMPLETATA';


	PreToken Constant Varchar2(2) := 'TK';
	PreNoCrypto Constant Varchar2(2) := 'NC';
	PrePan Constant Varchar2(2) := 'PN';
	PreOscurata Constant Varchar2(2) := 'OS';

	Virgolette Constant Varchar2(1) := chr(34);
	Punto Constant Varchar2(1) := chr(46);
	Virgola Constant Varchar2(1) := chr(44);
	PuntoVirgola Constant Varchar2(1) := chr(59);
	DoppioPunto Constant Varchar2(1) := chr(58);
	Apice Constant Varchar2(1) := chr(39);
	Spazio Constant Varchar2(1) := chr(32);
	Vuoto Constant Varchar2(1) := to_char(null);
	ACapo Constant Varchar2(1) := chr(10);
	Tab Constant Varchar2(1) := chr(9);
	ApriPar Constant Varchar2(1) := chr(40);
	ChiudiPar Constant Varchar2(1) := chr(41);
	Slash Constant Varchar2(1) := chr(47);

	TabellaDWH_Assente Exception;
	Operazione_NonAmmessa Exception;
	Nessuna_Carta_Credito Exception;
	Tab_Partizione_Invalida Exception;

	ErroreGenerato Constant Number := -20100;




	Procedure Prc_Crea_Copia_Token(
			prmUtente In Varchar2,
			prmTabella In Varchar2
		)
	As

		Utente Varchar2(30);
		TabOrigine Varchar2(30);
		TabToken Varchar2(30);
		TabNoCrypto Varchar2(30);
		TabPan Varchar2(30);
		TabOscurata Varchar2(30);

		ObjectToken Varchar2(30);
		ObjectNoCrypto Varchar2(30);

		VerificaTabella Pls_Integer;
		StatoToken Varchar2(100);
		StatoPan Varchar2(100);

		Ricerca Varchar2(32);
		Sostituzione Varchar2(32);

		Istruz_MetaData CLob;
		Istruzione Long;
		ElencoGrant Long;
		SqlScript_Completo CLob;

		PuntaFine Pls_Integer;

		ErrOracle Varchar2(50);
		MessaggioErrOra Varchar2(1000);

		MessaggioErroreGen Varchar2(1000);

	Begin
		Utente := upper(prmUtente);
		TabOrigine := upper(prmTabella);
		TabToken := PreToken || substr(TabOrigine,1,28);
		TabNoCrypto := PreNoCrypto || substr(TabOrigine,1,28);
		TabPan := PrePan || substr(TabOrigine,1,28);
		TabOscurata := PreOscurata || substr(TabOrigine,1,28);

		select
			count(*) into VerificaTabella
		from
			DBA_Tables
		where
			Owner = Utente
		and
			Table_Name = TabOrigine;

		If (VerificaTabella = 0) Then
			Raise TabellaDWH_Assente;
		End If;


		Begin
			select
				Des_Stato_Oscuramento into StatoToken
			from
				Wt_Token_Table
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
		Exception
			When No_Data_Found Then
				StatoToken := StatoAssente;
		End;

		Begin
			select
				Des_Stato_Illuminazione into StatoPan
			from
				Wt_Pan_Table
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
		Exception
			When No_Data_Found Then
				StatoPan := StatoAssente;
		End;


		If ((StatoToken in (StatoAssente,TokenTab_Disponibile)) and (StatoPan in (StatoAssente,StatoPan_Completo))) Then

			Istruzione := '-- Schema:' || Spazio || Utente || ACapo;
			Istruzione := Istruzione || ACapo || ACapo || '-- Script per la Creazione della Struttura Token' || Spazio || ApriPar || TabToken || ChiudiPar || ACapo;
			Istruzione := Istruzione || lpad('-',120,'-') || ACapo || ACapo || ACapo || ACapo;
			SqlScript_Completo := to_CLob(Istruzione);

			Ricerca := Virgolette || TabOrigine || Virgolette;
			Sostituzione := Virgolette || TabToken || Virgolette;

			Istruz_MetaData := Dbms_MetaData.Get_DDL('TABLE',TabOrigine,Utente);
			Istruz_MetaData := trim(replace(Istruz_MetaData,Ricerca,Sostituzione));
			Dbms_Lob.Append(SqlScript_Completo,Istruz_MetaData);

			Istruzione := PuntoVirgola || ACapo || ACapo || ACapo;
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			delete from Wt_Token_Constraint
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
			commit;

			For InfoConstraint In (
					select
						Owner as UtenteDB,
						Table_Name as Tabella,
						Constraint_Name as Nome,
						Constraint_Type as Tipo
					from
						DBA_Constraints
					where
						Owner = Utente
					and
						Table_Name = TabOrigine
					and
						Constraint_Name not like 'SYS\_%' escape '\'
				)
			Loop
				ObjectToken := PreToken || substr(InfoConstraint.Nome,1,28);
				ObjectNoCrypto := PreNoCrypto || substr(InfoConstraint.Nome,1,28);

				Ricerca := Virgolette || InfoConstraint.Nome || Virgolette;
				Sostituzione := Virgolette || ObjectToken || Virgolette;
				SqlScript_Completo := replace(SqlScript_Completo,Ricerca,Sostituzione);

				-- Inserimento nella Struttura Tecnica dei Constraint
				insert into Wt_Token_Constraint
				(
					Nome_Utente,
					Nome_Tabella,
					Nome_Constraint,
					Tipo_Constraint,
					Constraint_Token,
					Constraint_NoCrypto
				)
				values
				(
					Utente,
					TabOrigine,
					InfoConstraint.Nome,
					InfoConstraint.Tipo,
					ObjectToken,
					ObjectNoCrypto
				);
				commit;

			End Loop;


			-- Inserimento nella Struttura Tecnica degli Indici
			delete from Wt_Token_Index
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
			commit;

			insert into Wt_Token_Index
			(
				Nome_Utente,
				Nome_Tabella,
				Nome_Indice,
				Tipo_Indice,
				Univocita_Indice,
				Indice_Token,
				Indice_NoCrypto
			)
			select
				Owner as UtenteDB,
				Table_Name as Tabella,
				Index_Name as Nome,
				Index_Type as Tipo,
				Uniqueness as Univocita,
				PreToken || substr(Index_Name,1,28) as NomeToken,
				PreNoCrypto || substr(Index_Name,1,28) as NomeNoCrypto
			from
				DBA_Indexes
			where
				Owner = Utente
			and
				Table_Name = TabOrigine
			and
				Index_Name not like 'SYS\_%' escape '\';
			commit;


			-- Eliminazione, preliminare e temporanea, dei Constraint legati ad Indice

			For InfoConstraint In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Constraint as Nome,
						Tipo_Constraint as Tipo,
						Constraint_Token as NomeToken,
						Constraint_NoCrypto as NomeNoCrypto
					from
						Wt_Token_Constraint
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
					and
						Tipo_Constraint in ('P','U')
				)
			Loop
				Istruzione := 'alter table' || Spazio || TabToken || Spazio || 'drop constraint' || Spazio || InfoConstraint.NomeToken || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			-- Creazione degli Indici sulla Tabella Token

			For InfoIndice In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Indice as Nome,
						Tipo_Indice as Tipo,
						Univocita_Indice as Univocita,
						Indice_Token as NomeToken,
						Indice_NoCrypto as NomeNoCrypto
					from
						Wt_Token_Index
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop
				Istruzione := Dbms_MetaData.Get_DDL('INDEX',InfoIndice.Nome,Utente);

				Ricerca := Virgolette || InfoIndice.Nome || Virgolette;
				Sostituzione := Virgolette || InfoIndice.NomeToken || Virgolette;
				Istruzione := replace(Istruzione,Ricerca,Sostituzione);

				Ricerca := Virgolette || TabOrigine || Virgolette;
				Sostituzione := Virgolette || TabToken || Virgolette;
				Istruzione := replace(Istruzione,Ricerca,Sostituzione);

				Istruzione := trim(Istruzione) || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			-- Creazione dei Constraint legati ad Indice, precedentemente eliminati

			For InfoConstraint In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Constraint as Nome,
						Tipo_Constraint as Tipo,
						Constraint_Token as NomeToken,
						Constraint_NoCrypto as NomeNoCrypto
					from
						Wt_Token_Constraint
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
					and
						Tipo_Constraint in ('P','U')
				)
			Loop
				Istruzione := Dbms_MetaData.Get_DDL('CONSTRAINT',InfoConstraint.Nome,Utente);

				Ricerca := Virgolette || InfoConstraint.Nome || Virgolette;
				Sostituzione := Virgolette || InfoConstraint.NomeToken || Virgolette;
				Istruzione := replace(Istruzione,Ricerca,Sostituzione);

				Ricerca := Virgolette || TabOrigine || Virgolette;
				Sostituzione := Virgolette || TabToken || Virgolette;
				Istruzione := replace(Istruzione,Ricerca,Sostituzione);

				Istruzione := trim(Istruzione) || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			-- Attribuzione dei Privilegi (Grant) alla Tabella Token

			Declare
				NotificaNoGrant Constant Varchar2(50) := 'specified object of type OBJECT_GRANT not found';
			Begin
				ElencoGrant := Dbms_MetaData.Get_Dependent_DDL('OBJECT_GRANT',TabOrigine,Utente);
			Exception
				When Others Then
					ErrOracle := SqlCode;
					MessaggioErrOra := SqlErrm;

					If (instr(MessaggioErrOra,NotificaNoGrant,1,1) > 0) Then
						ElencoGrant := to_char(null);
					Else
						Raise;
					End If;
			End;

			Ricerca := Virgolette || TabOrigine || Virgolette;
			Sostituzione := Virgolette || TabToken || Virgolette;
			ElencoGrant := replace(ElencoGrant,Ricerca,Sostituzione);
			ElencoGrant := trim(replace(ElencoGrant,ACapo,PuntoVirgola));

			While (ElencoGrant is not null)
			Loop
				PuntaFine := Instr(ElencoGrant,PuntoVirgola,1,1);
				Istruzione := trim(substr(ElencoGrant,1,PuntaFine - 1));
				If (Istruzione is not null) Then
					Istruzione := Istruzione || PuntoVirgola || ACapo || ACapo;
					Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));
				End If;

				ElencoGrant := trim(substr(ElencoGrant,PuntaFine + 1));

			End Loop;


			-- Aggiunta dei Commenti di Tabella

			For InfoCommento In (
					select
						replace(Comments,Apice,Apice || Apice) as Commento
					from
						DBA_Tab_Comments
					where
						Owner = Utente
					and
						Table_Name = TabOrigine
					and
						Comments is not null
				)
			Loop
				Istruzione := 'comment on table' || Spazio || TabToken || Spazio || 'is' || Spazio || Apice || InfoCommento.Commento || Apice || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			-- Aggiunta dei Commenti di Colonna

			For InfoCommento In (
					select
						Column_Name as Colonna,
						replace(Comments,Apice,Apice || Apice) as Commento
					from
						DBA_Col_Comments a
					where
						Owner = Utente
					and
						Table_Name = TabOrigine
					and
						Comments is not null
				)
			Loop
				Istruzione := 'comment on column' || Spazio || TabToken || Punto || InfoCommento.Colonna || Spazio || 'is' || Spazio || Apice || InfoCommento.Commento || Apice || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			Istruzione := ACapo || 'update Wt_Token_Table' || ACapo || 'set' || ACapo;
			Istruzione := Istruzione || Tab || 'Des_Stato_Oscuramento' || Spazio || '=' || Spazio || Apice || TokenTab_Creata || Apice || Virgola || ACapo;
			Istruzione := Istruzione || Tab || 'Dat_Aggiornamento' || Spazio || '=' || Spazio || 'SysDate' || ACapo;
			Istruzione := Istruzione || 'where' || ACapo;
			Istruzione := Istruzione || Tab || 'Nome_Utente' || Spazio || '=' || Spazio || Apice || Utente || Apice || ACapo;
			Istruzione := Istruzione || 'and' || ACapo;
			Istruzione := Istruzione || Tab || 'Nome_Tabella' || Spazio || '=' || Spazio || Apice || TabOrigine || Apice || PuntoVirgola;
			Istruzione := Istruzione || ACapo || ACapo || 'commit' || PuntoVirgola || ACapo || ACapo;

			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			delete from Wt_Token_Table
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
			commit;

			-- Inserimento nella Struttura Tecnica delle Tabelle
			insert into Wt_Token_Table
			(
				Nome_Utente,
				Nome_Tabella,
				Tabella_Token,
				Tabella_NoCrypto,
				SqlScript_Creazione_Token,
				SqlScript_Carica_Token,
				SqlScript_Rinomina_Token,
				Des_Stato_Oscuramento,
				Dat_Aggiornamento
			)
			values
			(
				Utente,
				TabOrigine,
				TabToken,
				TabNoCrypto,
				SqlScript_Completo,
				to_CLob(Vuoto),
				to_CLob(Vuoto),
				TokenTab_Disponibile,
				SysDate
			);
			commit;

		Else
			Raise Operazione_NonAmmessa;

		End If;

	Exception
		When TabellaDWH_Assente Then
			MessaggioErroreGen := 'Struttura Indicata' || Spazio || ApriPar || Utente || Punto || TabOrigine || ChiudiPar || Spazio || 'NON Trovata';
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Operazione_NonAmmessa Then
			MessaggioErroreGen := 'Stato Oscuramento e Stato Illuminazione NON Compatibili con l''Operazione Richiesta';
			MessaggioErroreGen := MessaggioErroreGen || ACapo || Tab || 'Stato Oscuramento:' || Spazio || StatoToken;
			MessaggioErroreGen := MessaggioErroreGen || ACapo || Tab || 'Stato Illuminazione:' || Spazio || StatoPan;
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Others Then
			ErrOracle := SqlCode;
			MessaggioErrOra := SqlErrm;
			Dbms_Output.Put_Line(MessaggioErrOra);
			Raise;

	End Prc_Crea_Copia_Token;




	Procedure Prc_Crea_Token_Upload(
			prmUtente In Varchar2,
			prmTabella In Varchar2,
			prmElencoCampi_CCard In Varchar2,  -- I Campi rappresentanti Carte di Credito dovranno essere separati dal carattere ':'
			prmTipoUpload In Varchar2 Default 'Partizione',
			prmMoltiplicaPar_Master In Integer Default 1,
			prmMoltiplicaPar_Config In Integer Default 1,
			prmTipoStatistica In Varchar2 Default 'Parziale',
			prmFattoreStima In Integer Default 100,  -- Fattore di Divisione, rispetto all'unità, per determinare la frazione di Stima
			prmStatDegree In Integer Default 16
		)
	As

		Type CCard_Token_Rec Is
			Record (
				Campo_CCard Varchar2(30),
				Alias_Token Varchar2(30),
				Espr_Token_CCard Varchar2(2000),
				Tab_Token_CCard Varchar2(200),
				WhereCond_CCard Varchar2(2000)
			);

		Type Lista_CCard_Token Is
			Table Of CCard_Token_Rec index by Pls_Integer;

		Info_Carta_Credito Lista_CCard_Token;
		Puntatore_ListaCC Pls_Integer;

		Utente Varchar2(30);
		TabOrigine Varchar2(30);
		TabToken Varchar2(30);
		TabNoCrypto Varchar2(30);
		ElencoCampi_CCard Varchar2(600);
		TipoUpload Varchar2(200);
		TipoStatistica Varchar2(200);
		TipoUp_Maschera Constant Varchar2(20) := '<<TipoUpload_Msch>>';

		NumPart_Tabella Pls_Integer;

		ObjectToken Varchar2(30);
		ObjectNoCrypto Varchar2(30);

		VerificaTabella Pls_Integer;
		Controllo Pls_Integer;

		OuterOp Constant Varchar2(3) := '(+)';

		Contatore Pls_Integer;
		PuntaFine Pls_Integer;
		Nome_Carta Varchar2(300);
		PreAlias Constant Varchar2(3) := 'Cfg';
		AliasCC Varchar2(5);
		AliasMaster Constant Varchar2(6) := 'MasTab';
		AliasIns Constant Varchar2(6) := 'DesTab';

		Tab_Cfg_PanToken Constant Varchar2(30) := upper('Wt_Cfg_CC_Target_Pan_Token');

		TappoToken Constant Varchar2(30) := 'Undefined';
		AliasMaschera Constant Varchar2(30) := '<<AliasMsch>>';
		CampoMaschera Constant Varchar2(30) := '<<CampoMsch>>';
		EsprToken_Maschera Constant Varchar2(2000) := 'nvl' || ApriPar || AliasMaschera || Punto || 'Token_Value' || Virgola || Apice || TappoToken || Apice || ChiudiPar || Spazio || 'as' || Spazio || CampoMaschera;
		WhereCond_Maschera Constant Varchar2(2000) := Tab || AliasMaster || Punto || CampoMaschera || Spazio || '=' || Spazio || AliasMaschera || Punto || 'Pan_Value' || OuterOp;

		EsprToken_Carta Varchar2(2000);
		WhereCond_Carta Varchar2(2000);

		InizioHint Constant Varchar2(3) := '/*+';
		FineHint Constant Varchar2(2) := '*/';
		GradoParallelismo Constant Pls_Integer := 8;

		HintInserimento Constant Varchar2(800) := InizioHint || Spazio || 'append' || Spazio || 'parallel' || ApriPar || AliasIns || Virgola || trim(to_char(GradoParallelismo*2,'999')) || ChiudiPar || Spazio || FineHint;
		HintSelezione Varchar2(800);

		WhereCondition Varchar2(4000);
		FromToken Varchar2(2000);

		Nome_Base_Token_Partition Constant Varchar2(25) := upper('mmWt_Up_Token_Partition_');
		TabDestinazione Varchar2(30);

		TipoPartSubPart Varchar2(30);
		NomePartSubPart Varchar2(30);
		PartSubPart_Tablespace Varchar2(30);
		NomePartSubPart_Token Varchar2(30);
		PartSubPart_Compression Varchar2(10);

		CommentoPassoPartiz Varchar2(2000);
		ClausolaFrom Varchar2(2000);
		TipoPartSubPart_Maschera Constant Varchar2(30) := '<<TipoPartSubPartMsch>>';
		NomePartSubPart_Maschera Constant Varchar2(30) := '<<NomePartSubPartMsch>>';
		CommentoPassoPartiz_Maschera Varchar2(2000);
		ClausolaFrom_Maschera Varchar2(2000);


		StatoToken Varchar2(100);


		SequenzaColonne Varchar2(30000);
		SequenzaEspressione Varchar2(30000);

		Istruzione Long;
		SqlScript_Completo CLob;

		ErrOracle Varchar2(50);
		MessaggioErrOra Varchar2(1000);

		MessaggioErroreGen Varchar2(1000);

	Begin
		Utente := upper(prmUtente);
		TabOrigine := upper(prmTabella);
		TabToken := PreToken || substr(TabOrigine,1,28);
		TabNoCrypto := PreNoCrypto || substr(TabOrigine,1,28);
		ElencoCampi_CCard := upper(trim(prmElencoCampi_CCard));
		TipoUpload := upper(trim(prmTipoUpload));
		TipoStatistica :=upper(trim(prmTipoStatistica));


		select
			count(*) into VerificaTabella
		from
			DBA_Tables
		where
			Owner = Utente
		and
			Table_Name = TabOrigine;

		If (VerificaTabella = 0) Then
			Raise TabellaDWH_Assente;
		End If;


		Begin
			select
				Des_Stato_Oscuramento into StatoToken
			from
				Wt_Token_Table
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
		Exception
			When No_Data_Found Then
				StatoToken := StatoAssente;
		End;


		If (StatoToken in (TokenTab_Creata,TokenUpload_Generato)) Then
			-- Inserimento nella Struttura Tecnica delle Partizioni
			delete from Wt_Token_Partition
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
			commit;

			insert into Wt_Token_Partition
			(
				Nome_Utente,
				Nome_Tabella,
				Numero_Partizioni,
				Nome_Partizione,
				Part_Tablespace,
				Part_Compression,
				Partition_Position,
				Numero_SottoPartizioni,
				Nome_SottoPartizione,
				SubPart_Tablespace,
				SubPart_Compression,
				SubPart_Position,
				Nome_Utente_Tk,
				Nome_Tabella_Tk,
				Nome_Partizione_Tk,
				Part_Tablespace_Tk,
				Part_Compression_Tk,
				Partition_Position_Tk,
				Numero_SottoPartizioni_Tk,
				Nome_SottoPartizione_Tk,
				SubPart_Tablespace_Tk,
				SubPart_Compression_Tk,
				SubPart_Position_Tk
			)
			select
				TkTb.Nome_Utente as UtenteDataBase,
				TkTb.Nome_Tabella as TabellaDWH,
				count(distinct decode(nvl(PInfo.NomePartizione,'<Assente>'),'<Assente>',to_char(null),PInfo.NomePartizione)) over
				(
					partition by
						'Gruppo Unico'
				) as NumeroPartizioni,
				nvl(PInfo.NomePartizione,'<Assente>') as NomePartizione,
				nvl(PInfo.TablespacePartiz,'Undefined') as TablespacePartiz,
				nvl(PInfo.CompressionePartiz,'Undefined') as CompressionePartiz,
				nvl(PInfo.PosizionePartiz,-1) as PosizionePartiz,
				nvl(PInfo.NumeroSottoPartiz,-1) as NumeroSottoPartiz,
				nvl(PInfo.NomeSottoPartizione,'Undefined') as NomeSottoPartizione,
				nvl(PInfo.TablespaceSottoPartiz,'Undefined') as TablespaceSottoPartiz,
				nvl(PInfo.CompressioneSottoPartiz,'Undefined') as CompressioneSottoPartiz,
				nvl(PInfo.PosizioneSottoPartiz,-1) as PosizioneSottoPartiz,
				nvl(PInfo.UtenteDB_Token,'<Assente>') as UtenteDB_Token,  -- per costruzione sarà sempre uguale all'Utente della Tabella principale (campo UtenteDB)
				nvl(PInfo.Tabella_Token,'<Assente>') as Tabella_Token,
				nvl(PInfo.NomePartizione_Token,'<Assente>') as NomePartizione_Token,
				nvl(PInfo.TablespacePartiz_Token,'Undefined') as TablespacePartiz_Token,
				nvl(PInfo.CompressionePartiz_Token,'Undefined') as CompressionePartiz_Token,
				nvl(PInfo.PosizionePartiz_Token,-1) as PoszionePartiz_Token,
				nvl(PInfo.NumeroSottoPartiz_Token,-1) as NumeroSottoPartiz_Token,
				nvl(PInfo.NomeSottoPartizione_Token,'Undefined') as NomeSottoPartizione_Token,
				nvl(PInfo.TablespaceSottoPartiz_Token,'Undefined') as TablespaceSottoPartiz_Token,
				nvl(PInfo.CompressioneSottoPartiz_Token,'Undefined') as CompressioneSottoPartiz_Token,
				nvl(PInfo.PosizioneSottoPartiz_Token,-1) as PosizioneSottoPartiz_Token
			from
				Wt_Token_Table TkTb,
				(
					select
						PSubP.UtenteDB,
						PSubP.Tabella,
						PSubP.NomePartizione,
						PSubP.TablespacePartiz,
						PSubP.CompressionePartiz,
						PSubP.PosizionePartiz,
						PSubP.NumeroSottoPartiz,
						PSubP.NomeSottoPartizione,
						PSubP.TablespaceSottoPartiz,
						PSubP.CompressioneSottoPartiz,
						PSubP.PosizioneSottoPartiz,
						nvl(PSubPTk.UtenteDB,'<Assente>') as UtenteDB_Token,  -- per costruzione sarà sempre uguale all'Utente della Tabella principale (campo UtenteDB)
						nvl(PSubPTk.Tabella,'<Assente>') as Tabella_Token,
						nvl(PSubPTk.NomePartizione,'<Assente>') as NomePartizione_Token,
						nvl(PSubPTk.TablespacePartiz,'Undefined') as TablespacePartiz_Token,
						nvl(PSubPTk.CompressionePartiz,'Undefined') as CompressionePartiz_Token,
						nvl(PSubPTk.PosizionePartiz,-1) as PosizionePartiz_Token,
						nvl(PSubPTk.NumeroSottoPartiz,-1) as NumeroSottoPartiz_Token,
						nvl(PSubPTk.NomeSottoPartizione,'Undefined') as NomeSottoPartizione_Token,
						nvl(PSubPTk.TablespaceSottoPartiz,'Undefined') as TablespaceSottoPartiz_Token,
						nvl(PSubPTk.CompressioneSottoPartiz,'Undefined') as CompressioneSottoPartiz_Token,
						nvl(PSubPTk.PosizioneSottoPartiz,-1) as PosizioneSottoPartiz_Token
					from
						(
							select
								Part.Table_Owner as UtenteDB,
								Part.Table_Name as Tabella,
								Part.Partition_Name as NomePartizione,
								Part.Tablespace_Name as TablespacePartiz,
								Part.Compression as CompressionePartiz,
								Part.Partition_Position as PosizionePartiz,
								sum(decode(nvl(SubP.SubPartition_Name,'<Assente>'),'<Assente>',0,1)) over
								(
									partition by
										Part.Partition_Name
								) as NumeroSottoPartiz,
								nvl(SubP.SubPartition_Name,'<Assente>') as NomeSottoPartizione,
								nvl(SubP.Tablespace_Name,'Undefined') as TablespaceSottoPartiz,
								nvl(SubP.Compression,'Undefined') as CompressioneSottoPartiz,
								nvl(SubP.SubPartition_Position,-1) as PosizioneSottoPartiz
							from
								DBA_Tab_Partitions Part,
								DBA_Tab_Subpartitions SubP
							where
								Part.Table_Owner = Utente
							and
								Part.Table_Name = TabOrigine
							and
								Part.Table_Owner = SubP.Table_Owner(+)
							and
								Part.Table_Name = SubP.Table_Name(+)
							and
								Part.Partition_Name = SubP.Partition_Name(+)
						) PSubP,
						(
							select
								PTk.Table_Owner as UtenteDB,
								PTk.Table_Name as Tabella,
								PTk.Partition_Name as NomePartizione,
								PTk.Tablespace_Name as TablespacePartiz,
								PTk.Compression as CompressionePartiz,
								PTk.Partition_Position as PosizionePartiz,
								sum(decode(nvl(SubTk.SubPartition_Name,'<Assente>'),'<Assente>',0,1)) over
								(
									partition by
										PTk.Partition_Name
								) as NumeroSottoPartiz,
								nvl(SubTk.SubPartition_Name,'<Assente>') as NomeSottoPartizione,
								nvl(SubTk.Tablespace_Name,'Undefined') as TablespaceSottoPartiz,
								nvl(SubTk.Compression,'Undefined') as CompressioneSottoPartiz,
								nvl(SubTk.SubPartition_Position,-1) as PosizioneSottoPartiz
							from
								DBA_Tab_Partitions PTk,
								DBA_Tab_Subpartitions SubTk
							where
								PTk.Table_Owner = Utente
							and
								PTk.Table_Name = TabToken
							and
								PTk.Table_Owner = SubTk.Table_Owner(+)
							and
								PTk.Table_Name = SubTk.Table_Name(+)
							and
								PTk.Partition_Name = SubTk.Partition_Name(+)
						) PSubPTk
					where
						PSubP.PosizionePartiz = PSubPTk.PosizionePartiz(+)
					and
						PSubP.PosizioneSottoPartiz = PSubPTk.PosizioneSottoPartiz(+)
				) PInfo
			where
				TkTb.Nome_Utente = Utente
			and
				TkTb.Nome_Tabella = TabOrigine
			and
				TkTb.Nome_Utente = PInfo.UtenteDB(+)
			and
				TkTb.Nome_Tabella = PInfo.Tabella(+);
			commit;

		Else
			Raise Operazione_NonAmmessa;

		End If;



		-- Per il parametro prmTipoUpload sono previsti i soli due valori 'Partizione' e 'Completo'
		-- Qualunque valore fornito differente da quelli indicati, sarà considerato pari a 'Partizione'

		select
			distinct Numero_Partizioni into NumPart_Tabella
		from
			Wt_Token_Partition
		where
			Nome_Utente = Utente
		and
			Nome_Tabella = TabOrigine;

		If ((TipoUpload <> upper('Completo')) and (NumPart_Tabella > 0)) Then
			TipoUpload := upper('Partizione');
			If (TipoStatistica <> upper('Totale')) Then
				TipoStatistica := upper('Parziale');
			Else
				TipoStatistica := upper('Totale');
			End If;
		Else
			TipoUpload := upper('Completo');
			TipoStatistica := upper('Totale');
		End If;



		Contatore := 0;

		While (ElencoCampi_CCard is not null)
		Loop
			PuntaFine := instr(ElencoCampi_CCard,DoppioPunto,1,1);
			If (PuntaFine = 0) Then
				PuntaFine := length(ElencoCampi_CCard) + 1;
			End If;
			Nome_Carta := trim(substr(ElencoCampi_CCard,1,PuntaFine - 1));
			ElencoCampi_CCard := trim(substr(ElencoCampi_CCard,PuntaFine + 1));

			Begin
				select
					Column_Id into Puntatore_ListaCC
				from
					DBA_Tab_Columns
				where
					Owner = Utente
				and
					Table_Name = TabOrigine
				and
					Column_Name = Nome_Carta
				and
					Data_Type = 'VARCHAR2'
				and
					Data_Length >= 19;
			Exception
				When No_Data_Found Then
					Puntatore_ListaCC := 0;
			End;


			If ((Puntatore_ListaCC > 0) and (not Info_Carta_Credito.Exists(Puntatore_ListaCC))) Then
				Contatore := Contatore + 1;
				Info_Carta_Credito(Puntatore_ListaCC).Campo_CCard := Nome_Carta;

				AliasCC := PreAlias || trim(to_char(Contatore,'09'));
				Info_Carta_Credito(Puntatore_ListaCC).Alias_Token := AliasCC;

				EsprToken_Carta := replace(EsprToken_Maschera,AliasMaschera,AliasCC);
				EsprToken_Carta := replace(EsprToken_Carta,CampoMaschera,Nome_Carta);
				Info_Carta_Credito(Puntatore_ListaCC).Espr_Token_CCard := EsprToken_Carta;

				Info_Carta_Credito(Puntatore_ListaCC).Tab_Token_CCard := Tab || Tab_Cfg_PanToken || Spazio || AliasCC;

				WhereCond_Carta := replace(WhereCond_Maschera,AliasMaschera,AliasCC);
				WhereCond_Carta := replace(WhereCond_Carta,CampoMaschera,Nome_Carta);
				Info_Carta_Credito(Puntatore_ListaCC).WhereCond_CCard := WhereCond_Carta;

			End If;

		End Loop;

		If (Contatore = 0) Then
			Raise Nessuna_Carta_Credito;
		End If;


		HintSelezione := InizioHint || Spazio || 'parallel' || ApriPar || AliasMaster || Virgola || trim(to_char(prmMoltiplicaPar_Master*GradoParallelismo*2,'999')) || ChiudiPar;
		WhereCondition := 'where' || ACapo;
		FromToken := Vuoto;
		Puntatore_ListaCC := Info_Carta_Credito.First;

		While (Puntatore_ListaCC is not null)
		Loop
			HintSelezione := HintSelezione || Spazio || 'parallel' || ApriPar || Info_Carta_Credito(Puntatore_ListaCC).Alias_Token || Virgola || trim(to_char(prmMoltiplicaPar_Config*GradoParallelismo,'999')) || ChiudiPar;
			WhereCondition := WhereCondition || Info_Carta_Credito(Puntatore_ListaCC).WhereCond_CCard;
			FromToken := FromToken || Info_Carta_Credito(Puntatore_ListaCC).Tab_Token_CCard;

			If (Puntatore_ListaCC = Info_Carta_Credito.Last) Then
				HintSelezione := HintSelezione || Spazio || FineHint;
				WhereCondition := WhereCondition || PuntoVirgola;
			Else
				WhereCondition := WhereCondition || ACapo || 'and' || ACapo;
				FromToken := FromToken || Virgola || ACapo;
			End If;

			Puntatore_ListaCC := Info_Carta_Credito.Next(Puntatore_ListaCC);

		End Loop;


		SequenzaColonne := Vuoto;
		SequenzaEspressione := Vuoto;

		For InfoColonna In (
				select
					Column_Id as OrdineColonna,
					Column_Name as Colonna,
					max(Column_Id) over
					(
						partition by
							'Gruppo Unico'
					) as NumeroColonne
				from
					DBA_Tab_Columns
				where
					Owner = Utente
				and
					Table_Name = TabOrigine
				order by
					Column_Id
			)
		Loop
			SequenzaColonne := SequenzaColonne || Tab || InfoColonna.Colonna;
			If (Info_Carta_Credito.Exists(InfoColonna.OrdineColonna)) Then
				SequenzaEspressione := SequenzaEspressione || Tab || Info_Carta_Credito(InfoColonna.OrdineColonna).Espr_Token_CCard;
			Else
				SequenzaEspressione := SequenzaEspressione || Tab || AliasMaster || Punto || InfoColonna.Colonna;
			End If;

			If (InfoColonna.OrdineColonna < InfoColonna.NumeroColonne) Then
				SequenzaColonne := SequenzaColonne || Virgola || ACapo;
				SequenzaEspressione := SequenzaEspressione || Virgola || ACapo;

			End If;

		End Loop;


		Istruzione := '-- Schema:' || Spazio || Utente || ACapo;
		Istruzione := Istruzione || ACapo || ACapo || '-- Upload della Struttura' || Spazio || Utente || Punto || TabOrigine || Spazio || ApriPar || 'Modo Operativo' || DoppioPunto || Spazio || TipoUp_Maschera || ChiudiPar;
		SqlScript_Completo := to_CLob(Istruzione);
		Dbms_Lob.Append(SqlScript_Completo,to_CLob(ACapo || lpad('-',140,'-') || ACapo || ACapo || ACapo || ACapo || ACapo || 'set timing on' || ACapo || ACapo || ACapo || ACapo || ACapo));

		Istruzione := lpad('-',80,'-') || ACapo || '-- INIZIALIZZAZIONE' || ACapo || lpad('-',80,'-') || ACapo || ACapo;
		Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

		For InfoConstraint In (
				select
					Nome_Utente as UtenteDB,
					Nome_Tabella as Tabella,
					Nome_Constraint as Nome,
					Tipo_Constraint as Tipo,
					Constraint_Token as NomeToken,
					Constraint_NoCrypto as NomeNoCrypto
				from
					Wt_Token_Constraint
				where
					Nome_Utente = Utente
				and
					Nome_Tabella = TabOrigine
				and
					Tipo_Constraint in ('P','U')
			)
		Loop
			Istruzione := 'alter table' || Spazio || TabToken || ACapo || 'disable constraint' || Spazio || InfoConstraint.NomeToken || PuntoVirgola || ACapo || ACapo;
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

		End Loop;


		If (TipoUpload = upper('Completo')) Then
			SqlScript_Completo := replace(SqlScript_Completo,TipoUp_Maschera,'Passo UNICO');

			For InfoIndice In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Indice as Nome,
						Tipo_Indice as Tipo,
						Univocita_Indice as Univocita,
						Indice_Token as NomeToken,
						Indice_NoCrypto as NomeNoCrypto
					from
						Wt_Token_Index
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop
				Istruzione := 'alter index' || Spazio || InfoIndice.NomeToken || Spazio || 'unusable' || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));
			End Loop;


			TabDestinazione := TabToken;

			ClausolaFrom := 'from' || ACapo || Tab || TabOrigine || Spazio || AliasMaster || Virgola;
			ClausolaFrom := ClausolaFrom || ACapo || FromToken;

			Istruzione := ACapo || ACapo || ACapo || '-- Caricamento dati nella Tabella' || Spazio || TabDestinazione || ACapo || lpad('-',140,'-');
			Istruzione := Istruzione || ACapo || ACapo || 'truncate table' || Spazio || TabToken || PuntoVirgola;
			Istruzione := Istruzione || ACapo || ACapo || 'alter session enable parallel dml' || PuntoVirgola || ACapo || 'alter session enable parallel dml' || PuntoVirgola;

			Istruzione := Istruzione || ACapo || ACapo || 'insert' || Spazio || HintInserimento || Spazio || 'into' || Spazio || TabDestinazione || Spazio || AliasIns;
			Istruzione := Istruzione || ACapo || ApriPar;
			Istruzione := Istruzione || ACapo || SequenzaColonne || ACapo || ChiudiPar;

			Istruzione := Istruzione || ACapo || 'select' || Spazio || HintSelezione;
			Istruzione := Istruzione || ACapo || SequenzaEspressione;

			Istruzione := Istruzione || ACapo || ClausolaFrom;
			Istruzione := Istruzione || ACapo || WhereCondition;

			Istruzione := Istruzione || ACapo || ACapo || 'commit' || PuntoVirgola || ACapo || ACapo;

			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			Istruzione := ACapo || ACapo || 'Declare';
			Istruzione := Istruzione || ACapo || 'Begin';
			Istruzione := Istruzione || ACapo || Tab || 'Run_Stats' || ApriPar || Apice || TabDestinazione || Apice || ChiudiPar || PuntoVirgola;
			Istruzione := Istruzione || ACapo || 'End' || PuntoVirgola;
			Istruzione := Istruzione || ACapo || Slash || ACapo || ACapo;
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

		Else
			-- Inizializzazione per la Modalità Operativa 'PARTIZIONE'

			SqlScript_Completo := replace(SqlScript_Completo,TipoUp_Maschera,'Per PARTIZIONI');

			select
				Nome_Base_Token_Partition || trim(to_char(Sq_Tab_Partition_Token.NextVal,'09999')) into TabDestinazione
			from
				Dual;

			select
				count(*) into Controllo
			from
				DBA_Tables
			where
				Owner = Utente
			and
				Table_Name = TabDestinazione;

			If (Controllo = 0) Then
				Istruzione := ACapo || 'create table' || Spazio || TabDestinazione || ACapo;
				Istruzione := Istruzione || 'as' || ACapo || 'select' || Spazio || '*' || Spazio || 'from' || Spazio || TabOrigine || Spazio || 'where 1 > 2' || PuntoVirgola || ACapo || ACapo;

				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));
			Else
				Raise Tab_Partizione_Invalida;
			End If;


			CommentoPassoPartiz_Maschera := ACapo || ACapo || ACapo || '-- Elaborazione per i dati della' || Spazio || TipoPartSubPart_Maschera || Spazio || NomePartSubPart_Maschera;
			CommentoPassoPartiz_Maschera := CommentoPassoPartiz_Maschera || ACapo || lpad('-',140,'-');

			ClausolaFrom_Maschera := 'from' || ACapo || Tab || TabOrigine || Spazio || TipoPartSubPart_Maschera || Spazio || ApriPar || NomePartSubPart_Maschera || ChiudiPar || Spazio || AliasMaster || Virgola;
			ClausolaFrom_Maschera := ClausolaFrom_Maschera || ACapo || FromToken;


			-- Ciclo per le Partizioni/SottoPartizioni

			For InfoPartizione In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as TabellaDWH,
						Numero_Partizioni as NumeroPartizioni,
						Nome_Partizione as NomePartizione,
						Part_Tablespace as TablespacePartiz,
						Part_Compression as CompressionePartiz,
						Partition_Position as PosizionePartiz,
						Numero_SottoPartizioni as NumeroSottoPartiz,
						Nome_SottoPartizione as NomeSottoPartizione,
						SubPart_Tablespace as TablespaceSottoPartiz,
						SubPart_Compression as CompressioneSottoPartiz,
						SubPart_Position as PosizioneSottoPartiz,
						Nome_Utente_Tk as UtenteDB_Token,
						Nome_Tabella_Tk as Tabella_Token,
						Nome_Partizione_Tk as NomePartizione_Token,
						Part_Tablespace_Tk as TablespacePartiz_Token,
						Part_Compression_Tk as CompressionPartiz_Token,
						Partition_Position_Tk as PosizionePartiz_Token,
						Numero_SottoPartizioni_Tk as NumeroSottoPartiz_Token,
						Nome_SottoPartizione_Tk as NomeSottoPartizione_Token,
						SubPart_Tablespace_Tk as TablespaceSottoPartiz_Token,
						SubPart_Compression_Tk as CompressioneSottoPartiz_Token,
						SubPart_Position_Tk as PosizioneSottoPartiz_Token
					from
						Wt_Token_Partition
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
					order by
						Partition_Position,
						SubPart_Position
				)
			Loop
				PartSubPart_Compression := 'NoCompress';

				If (InfoPartizione.PosizioneSottoPartiz = -1) Then
					TipoPartSubPart := 'Partition';
					NomePartSubPart := InfoPartizione.NomePartizione;
					NomePartSubPart_Token := InfoPartizione.NomePartizione_Token;
					PartSubPart_Tablespace := InfoPartizione.TablespacePartiz;
					If (InfoPartizione.CompressionePartiz = 'ENABLED') Then
						PartSubPart_Compression := 'Compress';
					End If;
				Else
					TipoPartSubPart := 'SubPartition';
					NomePartSubPart := InfoPartizione.NomeSottoPartizione;
					NomePartSubPart_Token := InfoPartizione.NomeSottoPartizione_Token;
					PartSubPart_Tablespace := InfoPartizione.TablespaceSottoPartiz;
					If (InfoPartizione.CompressioneSottoPartiz = 'ENABLED') Then
						PartSubPart_Compression := 'Compress';
					End If;
				End If;

				If (TipoPartSubPart like 'Sub%') Then
					CommentoPassoPartiz := replace(CommentoPassoPartiz_Maschera,TipoPartSubPart_Maschera,'SottoPartizione');
				Else
					CommentoPassoPartiz := replace(CommentoPassoPartiz_Maschera,TipoPartSubPart_Maschera,'Partizione');
				End If;
				CommentoPassoPartiz := replace(CommentoPassoPartiz,NomePartSubPart_Maschera,NomePartSubPart);

				ClausolaFrom := replace(ClausolaFrom_Maschera,TipoPartSubPart_Maschera,TipoPartSubPart);
				ClausolaFrom := replace(ClausolaFrom,NomePartSubPart_Maschera,NomePartSubPart);

				Istruzione := ACapo || ACapo || CommentoPassoPartiz;
				Istruzione := Istruzione || ACapo || ACapo || 'truncate table' || Spazio || TabDestinazione || PuntoVirgola;

				Istruzione := Istruzione || ACapo || ACapo || 'alter table' || Spazio || TabDestinazione;
				Istruzione := Istruzione || ACapo || 'move tablespace' || Spazio || PartSubPart_Tablespace || Spazio || PartSubPart_Compression || PuntoVirgola;

				Istruzione := Istruzione || ACapo || ACapo || 'alter session enable parallel dml' || PuntoVirgola || ACapo || 'alter session enable parallel dml' || PuntoVirgola;

				Istruzione := Istruzione || ACapo || ACapo || 'insert' || Spazio || HintInserimento || Spazio || 'into' || Spazio || TabDestinazione || Spazio || AliasIns;
				Istruzione := Istruzione || ACapo || ApriPar;
				Istruzione := Istruzione || ACapo || SequenzaColonne || ACapo || ChiudiPar;

				Istruzione := Istruzione || ACapo || 'select' || Spazio || HintSelezione;
				Istruzione := Istruzione || ACapo || SequenzaEspressione;

				Istruzione := Istruzione || ACapo || ClausolaFrom;
				Istruzione := Istruzione || ACapo || WhereCondition;

				Istruzione := Istruzione || ACapo || ACapo || 'commit' || PuntoVirgola;

				Istruzione := Istruzione || ACapo || ACapo || 'alter table' || Spazio || TabToken;
				Istruzione := Istruzione || ACapo || 'exchange' || Spazio || TipoPartSubPart || Spazio || NomePartSubPart_Token || Spazio || 'with table' || Spazio || TabDestinazione || Spazio || 'without validation' || PuntoVirgola;

				If (TipoStatistica = upper('Parziale')) Then
					Istruzione := Istruzione || ACapo || ACapo || 'Declare';
					Istruzione := Istruzione || ACapo || 'Begin';
					Istruzione := Istruzione || ACapo || Tab || 'Dbms_Stats' || Punto || 'Gather_Table_Stats' || ApriPar;
					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'OwnName =>' || Spazio || Apice || Utente || Apice || Virgola;
					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'TabName =>' || Spazio || Apice || TabToken || Apice || Virgola;
					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'PartName =>' || Spazio || Apice || NomePartSubPart_Token || Apice || Virgola;
--					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Estimate_Percent => 0.01' || Virgola;
					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Estimate_Percent =>' || Spazio || trim(to_char(1/prmFattoreStima,'9D999999','Nls_Numeric_Characters = ''.,''')) || Virgola;
					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Degree =>' || Spazio || trim(to_char(prmStatDegree,'999')) || Virgola;
					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Cascade => false';
					Istruzione := Istruzione || ACapo || Tab || Tab || ChiudiPar || PuntoVirgola;
					Istruzione := Istruzione || ACapo || 'End' || PuntoVirgola;
					Istruzione := Istruzione || ACapo || Slash;

				End If;

				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			If (TipoStatistica = upper('Totale')) Then
				Istruzione := ACapo || ACapo || 'Declare';
				Istruzione := Istruzione || ACapo || 'Begin';
				Istruzione := Istruzione || ACapo || Tab || 'Dbms_Stats' || Punto || 'Gather_Table_Stats' || ApriPar;
				Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'OwnName =>' || Spazio || Apice || Utente || Apice || Virgola;
				Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'TabName =>' || Spazio || Apice || TabToken || Apice || Virgola;
--				Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Estimate_Percent => 0.01' || Virgola;
				Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Estimate_Percent =>' || Spazio || trim(to_char(1/prmFattoreStima,'9D999999','Nls_Numeric_Characters = ''.,''')) || Virgola;
				Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Degree =>' || Spazio || trim(to_char(prmStatDegree,'999')) || Virgola;
				Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Cascade => false';
				Istruzione := Istruzione || ACapo || Tab || Tab || ChiudiPar || PuntoVirgola;
				Istruzione := Istruzione || ACapo || 'End' || PuntoVirgola;
				Istruzione := Istruzione || ACapo || Slash;

				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End If;


		End If;



		Istruzione := ACapo || ACapo || ACapo || ACapo || lpad('-',80,'-') || ACapo ||  '-- FINALIZZAZIONE' || ACapo || lpad('-',80,'-') || ACapo || ACapo || ACapo;
		Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

		Declare
			GradoPar_Indice Pls_Integer;
			NumIstanze_Indice Pls_Integer;
			Ind_Partizionato Pls_Integer;

			TipoPartizione Varchar2(30);
			PartSubPart_Indice Varchar2(30);

			Messaggio Varchar2(800);

		Begin
			Istruzione := Vuoto;

			For Indice In (
					select
						Indice_Token as NomeToken
					from
						Wt_Token_Index
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop

				select
					Degree,
					Instances,
					decode(Partitioned,'YES',1,0)
				into
					GradoPar_Indice,
					NumIstanze_Indice,
					Ind_Partizionato
				from
					DBA_Indexes
				where
					Owner = Utente
				and
					Index_Name = Indice.NomeToken;


				If (Ind_Partizionato = 0) Then
					Istruzione := Istruzione || 'alter index' || Spazio || Indice.NomeToken || Spazio || 'rebuild' || Spazio || 'parallel' || Spazio || trim(to_char(4*prmMoltiplicaPar_Master*GradoParallelismo,'999')) || PuntoVirgola || ACapo || ACapo;

				Else
					For InfoPartIndice In (
							select
								Prtz.Partition_Name as NomePartizione_Indice,
								Prtz.Partition_Position as OrdinePartizione,
								Prtz.SubPartition_Count as NumeroSottoPartiz,
								nvl(SubP.SubPartition_Name,'<Assente>') as NomeSottoPartizione_Indice,
								nvl(SubP.SubPartition_Position,-1) as OrdineSottoPartizione
							from
								DBA_Ind_Partitions Prtz,
								DBA_Ind_SubPartitions SubP
							where
								Prtz.Index_Owner = Utente
							and
								Prtz.Index_Name = Indice.NomeToken
							and
								Prtz.Index_Owner = SubP.Index_Owner(+)
							and
								Prtz.Index_Name = SubP.Index_Name(+)
							and
								Prtz.Partition_Name = SubP.Partition_Name(+)
							order by
								Prtz.Partition_Position,
								nvl(SubP.SubPartition_Position,-1)
						)
					Loop
						If (InfoPartIndice.OrdineSottoPartizione = -1) Then
							TipoPartizione := 'Partition';
							PartSubPart_Indice := InfoPartIndice.NomePartizione_Indice;
						Else
							TipoPartizione := 'SubPartition';
							PartSubPart_Indice := InfoPartIndice.NomeSottoPartizione_Indice;
						End If;

						Istruzione := Istruzione || 'alter index' || Spazio || Indice.NomeToken || Spazio || 'rebuild' || Spazio || TipoPartizione || Spazio || PartSubPart_Indice || Spazio || 'parallel' || Spazio || trim(to_char(4*prmMoltiplicaPar_Master*GradoParallelismo,'999')) || PuntoVirgola || ACapo || ACapo;

					End Loop;

				End If;

				Istruzione := Istruzione || 'alter index' || Spazio || Indice.NomeToken || Spazio || 'parallel' || Spazio || ApriPar || 'degree' || Spazio || trim(to_char(GradoPar_Indice,'999')) || Spazio || 'instances' || Spazio || trim(to_char(NumIstanze_Indice,'999')) || ChiudiPar || PuntoVirgola || ACapo || ACapo;

			End Loop;

			If (Istruzione is not null) Then
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));
			End If;

		Exception
			When Others Then
				Messaggio := 'Errore Riscontrato nel Blocco Anonimo per la generazione delle istruzioni di rebuild degli indici';
				Dbms_Output.Put_Line(Messaggio);

				Raise;

		End;


		For InfoConstraint In (
				select
					Nome_Utente as UtenteDB,
					Nome_Tabella as Tabella,
					Nome_Constraint as Nome,
					Tipo_Constraint as Tipo,
					Constraint_Token as NomeToken,
					Constraint_NoCrypto as NomeNoCrypto
				from
					Wt_Token_Constraint
				where
					Nome_Utente = Utente
				and
					Nome_Tabella = TabOrigine
				and
					Tipo_Constraint in ('P','U')
			)
		Loop
			Istruzione := 'alter table' || Spazio || TabToken || ACapo || 'enable constraint' || Spazio || InfoConstraint.NomeToken || PuntoVirgola || ACapo || ACapo;
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

		End Loop;



		Istruzione := ACapo || ACapo || ACapo || 'update Wt_Token_Table' || ACapo || 'set' || ACapo;
		Istruzione := Istruzione || Tab || 'Des_Stato_Oscuramento' || Spazio || '=' || Spazio || Apice || TokenUpload_Eseguito || Apice || Virgola || ACapo;
		Istruzione := Istruzione || Tab || 'Dat_Aggiornamento' || Spazio || '=' || Spazio || 'SysDate' || ACapo;
		Istruzione := Istruzione || 'where' || ACapo;
		Istruzione := Istruzione || Tab || 'Nome_Utente' || Spazio || '=' || Spazio || Apice || Utente || Apice || ACapo;
		Istruzione := Istruzione || 'and' || ACapo;
		Istruzione := Istruzione || Tab || 'Nome_Tabella' || Spazio || '=' || Spazio || Apice || TabOrigine || Apice || PuntoVirgola;
		Istruzione := Istruzione || ACapo || ACapo || 'commit' || PuntoVirgola || ACapo || ACapo || ACapo || ACapo || ACapo || 'set timing off' || ACapo || ACapo;

		Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


		update Wt_Token_Table
		set
			SqlScript_Carica_Token = SqlScript_Completo,
			Des_Stato_Oscuramento = TokenUpload_Generato,
			Dat_Aggiornamento = SysDate
		where
			Nome_Utente = Utente
		and
			Nome_Tabella = TabOrigine;
		commit;


	Exception
		When TabellaDWH_Assente Then
			MessaggioErroreGen := 'Struttura Indicata' || Spazio || ApriPar || Utente || Punto || TabOrigine || ChiudiPar || Spazio || 'NON Trovata';
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Operazione_NonAmmessa Then
			MessaggioErroreGen := 'Stato Oscuramento NON Compatibile con l''Operazione Richiesta';
			MessaggioErroreGen := MessaggioErroreGen || ACapo || Tab || 'Stato Oscuramento:' || Spazio || StatoToken;
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Nessuna_Carta_Credito Then
			MessaggioErroreGen := 'Nessuna Carta di Credito Riconosciuta nella sequenza fornita:';
			MessaggioErroreGen := MessaggioErroreGen || ACapo || Tab || prmElencoCampi_CCard;
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Tab_Partizione_Invalida Then
			MessaggioErroreGen := 'La Tabella prevista per recepire i dati della Partizione, NON è Utilizzabile';
			MessaggioErroreGen := MessaggioErroreGen || ACapo || Tab || 'Tabella Dati Partizione:' || Spazio || TabDestinazione;
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Others Then
			ErrOracle := SqlCode;
			MessaggioErrOra := SqlErrm;
			Dbms_Output.Put_Line(MessaggioErrOra);
			Raise;

	End Prc_Crea_Token_Upload;




	Procedure Prc_Crea_Rinomina_Token(
			prmUtente In Varchar2,
			prmTabella In Varchar2
		)
	As
		Utente Varchar2(30);
		TabOrigine Varchar2(30);
		TabToken Varchar2(30);
		TabNoCrypto Varchar2(30);

		VerificaTabella Pls_Integer;
		StatoToken Varchar2(100);

		Proc_Allineamento Constant Varchar2(30) := upper('Prc_Allinea_Token_Pan_Info');
		Istruzione Long;
		SqlScript_Completo CLob;

		ErrOracle Varchar2(50);
		MessaggioErrOra Varchar2(1000);

		MessaggioErroreGen Varchar2(1000);

	Begin
		Utente := upper(prmUtente);
		TabOrigine := upper(prmTabella);

		select
			count(*) into VerificaTabella
		from
			DBA_Tables
		where
			Owner = Utente
		and
			Table_Name = TabOrigine;

		If (VerificaTabella = 0) Then
			Raise TabellaDWH_Assente;
		End If;


		Begin
			select
				Tabella_Token,
				Tabella_NoCrypto,
				Des_Stato_Oscuramento
			into
				TabToken,
				TabNoCrypto,
				StatoToken
			from
				Wt_Token_Table
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;

		Exception
			When No_Data_Found Then
				TabToken := Vuoto;
				TabNoCrypto := Vuoto;
				StatoToken := StatoAssente;

		End;


		If (StatoToken = TokenUpload_Eseguito) Then
			Istruzione := '-- Schema:' || Spazio || Utente || ACapo;
			Istruzione := Istruzione || ACapo || ACapo || '-- Rinomina delle Strutture' || Spazio || ApriPar || TabOrigine || Spazio || '-->' || Spazio || TabNoCrypto || ChiudiPar || Spazio || '-' || Spazio || ApriPar || TabToken || Spazio || '-->' || Spazio || TabOrigine || ChiudiPar;

			SqlScript_Completo := to_CLob(Istruzione);
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(ACapo || lpad('-',200,'-') || ACapo || ACapo || ACapo || ACapo));

			Istruzione := 'rename' || Spazio || TabOrigine || Spazio || 'to' || Spazio || TabNoCrypto || PuntoVirgola || ACapo || ACapo;
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			For InfoConstraint In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Constraint as Nome,
						Tipo_Constraint as Tipo,
						Constraint_Token as NomeToken,
						Constraint_NoCrypto as NomeNoCrypto
					from
						Wt_Token_Constraint
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop
				Istruzione := 'alter table' || Spazio || TabNoCrypto || ACapo || 'rename constraint' || Spazio || InfoConstraint.Nome || Spazio || 'to' || Spazio || InfoConstraint.NomeNoCrypto || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			For InfoIndice In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Indice as Nome,
						Tipo_Indice as Tipo,
						Univocita_Indice as Univocita,
						Indice_Token as NomeToken,
						Indice_NoCrypto as NomeNoCrypto
					from
						Wt_Token_Index
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop
				Istruzione := 'alter index' || Spazio || InfoIndice.Nome || Spazio || 'rename to' || Spazio || InfoIndice.NomeNoCrypto || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			Istruzione := ACapo || ACapo || 'rename' || Spazio || TabToken || Spazio || 'to' || Spazio || TabOrigine || PuntoVirgola || ACapo || ACapo;
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			For InfoConstraint In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Constraint as Nome,
						Tipo_Constraint as Tipo,
						Constraint_Token as NomeToken,
						Constraint_NoCrypto as NomeNoCrypto
					from
						Wt_Token_Constraint
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop
				Istruzione := 'alter table' || Spazio || TabOrigine || ACapo || 'rename constraint' || Spazio || InfoConstraint.NomeToken || Spazio || 'to' || Spazio || InfoConstraint.Nome || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			For InfoIndice In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Indice as Nome,
						Tipo_Indice as Tipo,
						Univocita_Indice as Univocita,
						Indice_Token as NomeToken,
						Indice_NoCrypto as NomeNoCrypto
					from
						Wt_Token_Index
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop
				Istruzione := 'alter index' || Spazio || InfoIndice.NomeToken || Spazio || 'rename to' || Spazio || InfoIndice.Nome || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			Istruzione := ACapo || ACapo || ACapo || 'update Wt_Token_Table' || ACapo || 'set' || ACapo;
			Istruzione := Istruzione || Tab || 'Des_Stato_Oscuramento' || Spazio || '=' || Spazio || Apice || StatoToken_Completo || Apice || Virgola || ACapo;
			Istruzione := Istruzione || Tab || 'Dat_Aggiornamento' || Spazio || '=' || Spazio || 'SysDate' || ACapo;
			Istruzione := Istruzione || 'where' || ACapo;
			Istruzione := Istruzione || Tab || 'Nome_Utente' || Spazio || '=' || Spazio || Apice || Utente || Apice || ACapo;
			Istruzione := Istruzione || 'and' || ACapo;
			Istruzione := Istruzione || Tab || 'Nome_Tabella' || Spazio || '=' || Spazio || Apice || TabOrigine || Apice || PuntoVirgola;
			Istruzione := Istruzione || ACapo || ACapo || 'commit' || PuntoVirgola || ACapo || ACapo;

			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			Istruzione := ACapo || ACapo || ACapo || 'Declare' || ACapo || 'Begin' || ACapo;
			Istruzione := Istruzione || Tab || NomePackage || Punto || Proc_Allineamento || ApriPar;
			Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'prmUtente =>' || Spazio || Apice || prmUtente || Apice || Virgola;
			Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'prmTabella =>' || Spazio || Apice || prmTabella || Apice || Virgola;
			Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'prmTipoChiusura =>' || Spazio || Apice || StatoToken_Completo || Apice;
			Istruzione := Istruzione || ACapo || Tab || Tab || ChiudiPar || PuntoVirgola;
			Istruzione := Istruzione || ACapo || 'End' || PuntoVirgola;
			Istruzione := Istruzione || ACapo || Slash || ACapo || ACapo;

			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			update Wt_Token_Table
			set
				SqlScript_Rinomina_Token = SqlScript_Completo,
				Des_Stato_Oscuramento = TokenRinomina_Disponibile,
				Dat_Aggiornamento = SysDate
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
			commit;

		Else
			Raise Operazione_NonAmmessa;

		End If;


	Exception
		When TabellaDWH_Assente Then
			MessaggioErroreGen := 'Struttura Indicata' || Spazio || ApriPar || Utente || Punto || TabOrigine || ChiudiPar || Spazio || 'NON Trovata';
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Operazione_NonAmmessa Then
			MessaggioErroreGen := 'Stato Oscuramento NON Compatibile con l''Operazione Richiesta';
			MessaggioErroreGen := MessaggioErroreGen || ACapo || Tab || 'Stato Oscuramento:' || Spazio || StatoToken;
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Others Then
			ErrOracle := SqlCode;
			MessaggioErrOra := SqlErrm;
			Dbms_Output.Put_Line(MessaggioErrOra);
			Raise;

	End Prc_Crea_Rinomina_Token;




	Procedure Prc_Crea_Copia_Pan(
			prmUtente In Varchar2,
			prmTabella In Varchar2
		)
	As

		Utente Varchar2(30);
		TabOrigine Varchar2(30);
		TabToken Varchar2(30);
		TabNoCrypto Varchar2(30);
		TabPan Varchar2(30);
		TabOscurata Varchar2(30);

		ObjectPan Varchar2(30);
		ObjectOscurata Varchar2(30);

		VerificaTabella Pls_Integer;
		StatoToken Varchar2(100);
		StatoPan Varchar2(100);

		Ricerca Varchar2(32);
		Sostituzione Varchar2(32);

		Istruz_MetaData CLob;
		Istruzione Long;
		ElencoGrant Long;
		SqlScript_Completo CLob;

		PuntaFine Pls_Integer;

		ErrOracle Varchar2(50);
		MessaggioErrOra Varchar2(1000);

		MessaggioErroreGen Varchar2(1000);

	Begin
		Utente := upper(prmUtente);
		TabOrigine := upper(prmTabella);
		TabToken := PreToken || substr(TabOrigine,1,28);
		TabNoCrypto := PreNoCrypto || substr(TabOrigine,1,28);
		TabPan := PrePan || substr(TabOrigine,1,28);
		TabOscurata := PreOscurata || substr(TabOrigine,1,28);

		select
			count(*) into VerificaTabella
		from
			DBA_Tables
		where
			Owner = Utente
		and
			Table_Name = TabOrigine;

		If (VerificaTabella = 0) Then
			Raise TabellaDWH_Assente;
		End If;


		Begin
			select
				Des_Stato_Oscuramento into StatoToken
			from
				Wt_Token_Table
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
		Exception
			When No_Data_Found Then
				StatoToken := StatoAssente;
		End;

		Begin
			select
				Des_Stato_Illuminazione into StatoPan
			from
				Wt_Pan_Table
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
		Exception
			When No_Data_Found Then
				StatoPan := StatoAssente;
		End;


		If ((StatoToken = StatoToken_Completo) and (StatoPan in (StatoAssente,PanTab_Disponibile))) Then

			Istruzione := '-- Schema:' || Spazio || Utente || ACapo;
			Istruzione := Istruzione || ACapo || ACapo || '-- Script per la Creazione della Struttura Pan' || Spazio || ApriPar || TabPan || ChiudiPar || ACapo;
			Istruzione := Istruzione || lpad('-',120,'-') || ACapo || ACapo || ACapo || ACapo;
			SqlScript_Completo := to_CLob(Istruzione);

			Ricerca := Virgolette || TabOrigine || Virgolette;
			Sostituzione := Virgolette || TabPan || Virgolette;

			Istruz_MetaData := Dbms_MetaData.Get_DDL('TABLE',TabOrigine,Utente);
			Istruz_MetaData := trim(replace(Istruz_MetaData,Ricerca,Sostituzione));
			Dbms_Lob.Append(SqlScript_Completo,Istruz_MetaData);

			Istruzione := PuntoVirgola || ACapo || ACapo || ACapo;
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			delete from Wt_Pan_Constraint
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
			commit;

			For InfoConstraint In (
					select
						Owner as UtenteDB,
						Table_Name as Tabella,
						Constraint_Name as Nome,
						Constraint_Type as Tipo
					from
						DBA_Constraints
					where
						Owner = Utente
					and
						Table_Name = TabOrigine
					and
						Constraint_Name not like 'SYS\_%' escape '\'
				)
			Loop
				ObjectPan := PrePan || substr(InfoConstraint.Nome,1,28);
				ObjectOscurata := PreOscurata || substr(InfoConstraint.Nome,1,28);

				Ricerca := Virgolette || InfoConstraint.Nome || Virgolette;
				Sostituzione := Virgolette || ObjectPan || Virgolette;
				SqlScript_Completo := replace(SqlScript_Completo,Ricerca,Sostituzione);

				-- Inserimento nella Struttura Tecnica dei Constraint
				insert into Wt_Pan_Constraint
				(
					Nome_Utente,
					Nome_Tabella,
					Nome_Constraint,
					Tipo_Constraint,
					Constraint_Pan,
					Constraint_Oscurata
				)
				values
				(
					Utente,
					TabOrigine,
					InfoConstraint.Nome,
					InfoConstraint.Tipo,
					ObjectPan,
					ObjectOscurata
				);
				commit;

			End Loop;


			-- Inserimento nella Struttura Tecnica degli Indici
			delete from Wt_Pan_Index
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
			commit;

			insert into Wt_Pan_Index
			(
				Nome_Utente,
				Nome_Tabella,
				Nome_Indice,
				Tipo_Indice,
				Univocita_Indice,
				Indice_Pan,
				Indice_Oscurata
			)
			select
				Owner as UtenteDB,
				Table_Name as Tabella,
				Index_Name as Nome,
				Index_Type as Tipo,
				Uniqueness as Univocita,
				PrePan || substr(Index_Name,1,28) as NomePan,
				PreOscurata || substr(Index_Name,1,28) as NomeOscurata
			from
				DBA_Indexes
			where
				Owner = Utente
			and
				Table_Name = TabOrigine
			and
				Index_Name not like 'SYS\_%' escape '\';
			commit;


			-- Eliminazione, preliminare e temporanea, dei Constraint legati ad Indice

			For InfoConstraint In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Constraint as Nome,
						Tipo_Constraint as Tipo,
						Constraint_Pan as NomePan,
						Constraint_Oscurata as NomeOscurata
					from
						Wt_Pan_Constraint
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
					and
						Tipo_Constraint in ('P','U')
				)
			Loop
				Istruzione := 'alter table' || Spazio || TabPan || Spazio || 'drop constraint' || Spazio || InfoConstraint.NomePan || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			-- Creazione degli Indici sulla Tabella Token

			For InfoIndice In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Indice as Nome,
						Tipo_Indice as Tipo,
						Univocita_Indice as Univocita,
						Indice_Pan as NomePan,
						Indice_Oscurata as NomeOscurata
					from
						Wt_Pan_Index
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop
				Istruzione := Dbms_MetaData.Get_DDL('INDEX',InfoIndice.Nome,Utente);

				Ricerca := Virgolette || InfoIndice.Nome || Virgolette;
				Sostituzione := Virgolette || InfoIndice.NomePan || Virgolette;
				Istruzione := replace(Istruzione,Ricerca,Sostituzione);

				Ricerca := Virgolette || TabOrigine || Virgolette;
				Sostituzione := Virgolette || TabPan || Virgolette;
				Istruzione := replace(Istruzione,Ricerca,Sostituzione);

				Istruzione := trim(Istruzione) || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			-- Creazione dei Constraint legati ad Indice, precedentemente eliminati

			For InfoConstraint In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Constraint as Nome,
						Tipo_Constraint as Tipo,
						Constraint_Pan as NomePan,
						Constraint_Oscurata as NomeOscurata
					from
						Wt_Pan_Constraint
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
					and
						Tipo_Constraint in ('P','U')
				)
			Loop
				Istruzione := Dbms_MetaData.Get_DDL('CONSTRAINT',InfoConstraint.Nome,Utente);

				Ricerca := Virgolette || InfoConstraint.Nome || Virgolette;
				Sostituzione := Virgolette || InfoConstraint.NomePan || Virgolette;
				Istruzione := replace(Istruzione,Ricerca,Sostituzione);

				Ricerca := Virgolette || TabOrigine || Virgolette;
				Sostituzione := Virgolette || TabPan || Virgolette;
				Istruzione := replace(Istruzione,Ricerca,Sostituzione);

				Istruzione := trim(Istruzione) || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			-- Attribuzione dei Privilegi (Grant) alla Tabella Pan

			Declare
				NotificaNoGrant Constant Varchar2(50) := 'specified object of type OBJECT_GRANT not found';
			Begin
				ElencoGrant := Dbms_MetaData.Get_Dependent_DDL('OBJECT_GRANT',TabOrigine,Utente);
			Exception
				When Others Then
					ErrOracle := SqlCode;
					MessaggioErrOra := SqlErrm;

					If (instr(MessaggioErrOra,NotificaNoGrant,1,1) > 0) Then
						ElencoGrant := to_char(null);
					Else
						Raise;
					End If;
			End;

			Ricerca := Virgolette || TabOrigine || Virgolette;
			Sostituzione := Virgolette || TabPan || Virgolette;
			ElencoGrant := replace(ElencoGrant,Ricerca,Sostituzione);
			ElencoGrant := trim(replace(ElencoGrant,ACapo,PuntoVirgola));

			While (ElencoGrant is not null)
			Loop
				PuntaFine := Instr(ElencoGrant,PuntoVirgola,1,1);
				Istruzione := trim(substr(ElencoGrant,1,PuntaFine - 1));
				If (Istruzione is not null) Then
					Istruzione := Istruzione || PuntoVirgola || ACapo || ACapo;
					Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));
				End If;

				ElencoGrant := trim(substr(ElencoGrant,PuntaFine + 1));

			End Loop;


			-- Aggiunta dei Commenti di Tabella

			For InfoCommento In (
					select
						replace(Comments,Apice,Apice || Apice) as Commento
					from
						DBA_Tab_Comments
					where
						Owner = Utente
					and
						Table_Name = TabOrigine
					and
						Comments is not null
				)
			Loop
				Istruzione := 'comment on table' || Spazio || TabPan || Spazio || 'is' || Spazio || Apice || InfoCommento.Commento || Apice || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			-- Aggiunta dei Commenti di Colonna

			For InfoCommento In (
					select
						Column_Name as Colonna,
						replace(Comments,Apice,Apice || Apice) as Commento
					from
						DBA_Col_Comments a
					where
						Owner = Utente
					and
						Table_Name = TabOrigine
					and
						Comments is not null
				)
			Loop
				Istruzione := 'comment on column' || Spazio || TabPan || Punto || InfoCommento.Colonna || Spazio || 'is' || Spazio || Apice || InfoCommento.Commento || Apice || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			Istruzione := ACapo || 'update Wt_Pan_Table' || ACapo || 'set' || ACapo;
			Istruzione := Istruzione || Tab || 'Des_Stato_Illuminazione' || Spazio || '=' || Spazio || Apice || PanTab_Creata || Apice || Virgola || ACapo;
			Istruzione := Istruzione || Tab || 'Dat_Aggiornamento' || Spazio || '=' || Spazio || 'SysDate' || ACapo;
			Istruzione := Istruzione || 'where' || ACapo;
			Istruzione := Istruzione || Tab || 'Nome_Utente' || Spazio || '=' || Spazio || Apice || Utente || Apice || ACapo;
			Istruzione := Istruzione || 'and' || ACapo;
			Istruzione := Istruzione || Tab || 'Nome_Tabella' || Spazio || '=' || Spazio || Apice || TabOrigine || Apice || PuntoVirgola;
			Istruzione := Istruzione || ACapo || ACapo || 'commit' || PuntoVirgola || ACapo || ACapo;

			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			delete from Wt_Pan_Table
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
			commit;

			-- Inserimento nella Struttura Tecnica delle Tabelle
			insert into Wt_Pan_Table
			(
				Nome_Utente,
				Nome_Tabella,
				Tabella_Pan,
				Tabella_Oscurata,
				SqlScript_Creazione_Pan,
				SqlScript_Carica_Pan,
				SqlScript_Rinomina_Pan,
				Des_Stato_Illuminazione,
				Dat_Aggiornamento
			)
			values
			(
				Utente,
				TabOrigine,
				TabPan,
				TabOscurata,
				SqlScript_Completo,
				to_CLob(Vuoto),
				to_CLob(Vuoto),
				PanTab_Disponibile,
				SysDate
			);
			commit;

		Else
			Raise Operazione_NonAmmessa;

		End If;

	Exception
		When TabellaDWH_Assente Then
			MessaggioErroreGen := 'Struttura Indicata' || Spazio || ApriPar || Utente || Punto || TabOrigine || ChiudiPar || Spazio || 'NON Trovata';
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Operazione_NonAmmessa Then
			MessaggioErroreGen := 'Stato Oscuramento e Stato Illuminazione NON Compatibili con l''Operazione Richiesta';
			MessaggioErroreGen := MessaggioErroreGen || ACapo || Tab || 'Stato Oscuramento:' || Spazio || StatoToken;
			MessaggioErroreGen := MessaggioErroreGen || ACapo || Tab || 'Stato Illuminazione:' || Spazio || StatoPan;
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Others Then
			ErrOracle := SqlCode;
			MessaggioErrOra := SqlErrm;
			Dbms_Output.Put_Line(MessaggioErrOra);
			Raise;

	End Prc_Crea_Copia_Pan;




	Procedure Prc_Crea_Pan_Upload(
			prmUtente In Varchar2,
			prmTabella In Varchar2,
			prmElencoCampi_CCard In Varchar2,  -- I Campi rappresentanti Carte di Credito dovranno essere separati dal carattere ':'
			prmTipoUpload In Varchar2 Default 'Partizione',
			prmMoltiplicaPar_Master In Integer Default 1,
			prmMoltiplicaPar_Config In Integer Default 1,
			prmTipoStatistica In Varchar2 Default 'Parziale',
			prmFattoreStima In Integer Default 100,  -- Fattore di Divisione, rispetto all'unità, per determinare la frazione di Stima
			prmStatDegree In Integer Default 16
		)
	As

		Type CCard_Pan_Rec Is
			Record (
				Campo_CCard Varchar2(30),
				Alias_Pan Varchar2(30),
				Espr_Pan_CCard Varchar2(2000),
				Tab_Pan_CCard Varchar2(200),
				WhereCond_CCard Varchar2(2000)
			);

		Type Lista_CCard_Pan Is
			Table Of CCard_Pan_Rec index by Pls_Integer;

		Info_Carta_Credito Lista_CCard_Pan;
		Puntatore_ListaCC Pls_Integer;

		Utente Varchar2(30);
		TabOrigine Varchar2(30);
		TabPan Varchar2(30);
		TabOscurata Varchar2(30);
		ElencoCampi_CCard Varchar2(600);
		TipoUpload Varchar2(200);
		TipoStatistica Varchar2(200);
		TipoUp_Maschera Constant Varchar2(20) := '<<TipoUpload_Msch>>';

		NumPart_Tabella Pls_Integer;

		ObjectPan Varchar2(30);
		ObjectOscurata Varchar2(30);

		VerificaTabella Pls_Integer;
		Controllo Pls_Integer;

		OuterOp Constant Varchar2(3) := '(+)';

		Contatore Pls_Integer;
		PuntaFine Pls_Integer;
		Nome_Carta Varchar2(300);
		PreAlias Constant Varchar2(3) := 'Cfg';
		AliasCC Varchar2(5);
		AliasMaster Constant Varchar2(6) := 'MasTab';
		AliasIns Constant Varchar2(6) := 'DesTab';

		Tab_Cfg_PanToken Constant Varchar2(30) := upper('Wt_Cfg_CC_Target_Pan_Token');

		TappoPan Constant Varchar2(30) := 'Undefined';
		AliasMaschera Constant Varchar2(30) := '<<AliasMsch>>';
		CampoMaschera Constant Varchar2(30) := '<<CampoMsch>>';
		EsprPan_Maschera Constant Varchar2(2000) := 'nvl' || ApriPar || AliasMaschera || Punto || 'Pan_Value' || Virgola || Apice || TappoPan || Apice || ChiudiPar || Spazio || 'as' || Spazio || CampoMaschera;
		WhereCond_Maschera Constant Varchar2(2000) := Tab || AliasMaster || Punto || CampoMaschera || Spazio || '=' || Spazio || AliasMaschera || Punto || 'Token_Value' || OuterOp || ACapo || 'and' || ACapo || Tab || AliasMaschera || Punto || 'Token_Value' || OuterOp || Spazio || '<>' || Spazio || Apice || TappoPan || Apice;

		EsprPan_Carta Varchar2(2000);
		WhereCond_Carta Varchar2(2000);

		InizioHint Constant Varchar2(3) := '/*+';
		FineHint Constant Varchar2(2) := '*/';
		GradoParallelismo Constant Pls_Integer := 8;

		HintInserimento Constant Varchar2(800) := InizioHint || Spazio || 'append' || Spazio || 'parallel' || ApriPar || AliasIns || Virgola || trim(to_char(GradoParallelismo*2,'999')) || ChiudiPar || Spazio || FineHint;
		HintSelezione Varchar2(800);

		WhereCondition Varchar2(4000);
		FromPan Varchar2(2000);

		Nome_Base_Pan_Partition Constant Varchar2(25) := upper('mmWt_Up_Pan_Partition_');
		TabDestinazione Varchar2(30);

		TipoPartSubPart Varchar2(30);
		NomePartSubPart Varchar2(30);
		PartSubPart_Tablespace Varchar2(30);
		NomePartSubPart_Pan Varchar2(30);
		PartSubPart_Compression Varchar2(10);

		CommentoPassoPartiz Varchar2(2000);
		ClausolaFrom Varchar2(2000);
		TipoPartSubPart_Maschera Constant Varchar2(30) := '<<TipoPartSubPartMsch>>';
		NomePartSubPart_Maschera Constant Varchar2(30) := '<<NomePartSubPartMsch>>';
		CommentoPassoPartiz_Maschera Varchar2(2000);
		ClausolaFrom_Maschera Varchar2(2000);


		StatoPan Varchar2(100);


		SequenzaColonne Varchar2(30000);
		SequenzaEspressione Varchar2(30000);

		Istruzione Long;
		SqlScript_Completo CLob;

		ErrOracle Varchar2(50);
		MessaggioErrOra Varchar2(1000);

		MessaggioErroreGen Varchar2(1000);

	Begin
		Utente := upper(prmUtente);
		TabOrigine := upper(prmTabella);
		TabPan := PrePan || substr(TabOrigine,1,28);
		TabOscurata := PreOscurata || substr(TabOrigine,1,28);
		ElencoCampi_CCard := upper(trim(prmElencoCampi_CCard));
		TipoUpload := upper(trim(prmTipoUpload));
		TipoStatistica := upper(trim(prmTipoStatistica));


		select
			count(*) into VerificaTabella
		from
			DBA_Tables
		where
			Owner = Utente
		and
			Table_Name = TabOrigine;

		If (VerificaTabella = 0) Then
			Raise TabellaDWH_Assente;
		End If;


		Begin
			select
				Des_Stato_Illuminazione into StatoPan
			from
				Wt_Pan_Table
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
		Exception
			When No_Data_Found Then
				StatoPan := StatoAssente;
		End;


		If (StatoPan in (PanTab_Creata,PanUpload_Generato)) Then
			-- Inserimento nella Struttura Tecnica delle Partizioni
			delete from Wt_Pan_Partition
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
			commit;

			insert into Wt_Pan_Partition
			(
				Nome_Utente,
				Nome_Tabella,
				Numero_Partizioni,
				Nome_Partizione,
				Part_Tablespace,
				Part_Compression,
				Partition_Position,
				Numero_SottoPartizioni,
				Nome_SottoPartizione,
				SubPart_Tablespace,
				SubPart_Compression,
				SubPart_Position,
				Nome_Utente_Pan,
				Nome_Tabella_Pan,
				Nome_Partizione_Pan,
				Part_Tablespace_Pan,
				Part_Compression_Pan,
				Partition_Position_Pan,
				Numero_SottoPartizioni_Pan,
				Nome_SottoPartizione_Pan,
				SubPart_Tablespace_Pan,
				SubPart_Compression_Pan,
				SubPart_Position_Pan
			)
			select
				PanTb.Nome_Utente as UtenteDataBase,
				PanTb.Nome_Tabella as TabellaDWH,
				count(distinct decode(nvl(PInfo.NomePartizione,'<Assente>'),'<Assente>',to_char(null),PInfo.NomePartizione)) over
				(
					partition by
						'Gruppo Unico'
				) as NumeroPartizioni,
				nvl(PInfo.NomePartizione,'<Assente>') as NomePartizione,
				nvl(PInfo.TablespacePartiz,'Undefined') as TablespacePartiz,
				nvl(PInfo.CompressionePartiz,'Undefined') as CompressionePartiz,
				nvl(PInfo.PosizionePartiz,-1) as PosizionePartiz,
				nvl(PInfo.NumeroSottoPartiz,-1) as NumeroSottoPartiz,
				nvl(PInfo.NomeSottoPartizione,'Undefined') as NomeSottoPartizione,
				nvl(PInfo.TablespaceSottoPartiz,'Undefined') as TablespaceSottoPartiz,
				nvl(PInfo.CompressioneSottoPartiz,'Undefined') as CompressioneSottoPartiz,
				nvl(PInfo.PosizioneSottoPartiz,-1) as PosizioneSottoPartiz,
				nvl(PInfo.UtenteDB_Pan,'<Assente>') as UtenteDB_Pan,  -- per costruzione sarà sempre uguale all'Utente della Tabella principale (campo UtenteDB)
				nvl(PInfo.Tabella_Pan,'<Assente>') as Tabella_Pan,
				nvl(PInfo.NomePartizione_Pan,'<Assente>') as NomePartizione_Pan,
				nvl(PInfo.TablespacePartiz_Pan,'Undefined') as TablespacePartiz_Pan,
				nvl(PInfo.CompressionePartiz_Pan,'Undefined') as CompressionePartiz_Pan,
				nvl(PInfo.PosizionePartiz_Pan,-1) as PoszionePartiz_Pan,
				nvl(PInfo.NumeroSottoPartiz_Pan,-1) as NumeroSottoPartiz_Pan,
				nvl(PInfo.NomeSottoPartizione_Pan,'Undefined') as NomeSottoPartizione_Pan,
				nvl(PInfo.TablespaceSottoPartiz_Pan,'Undefined') as TablespaceSottoPartiz_Pan,
				nvl(PInfo.CompressioneSottoPartiz_Pan,'Undefined') as CompressioneSottoPartiz_Pan,
				nvl(PInfo.PosizioneSottoPartiz_Pan,-1) as PosizioneSottoPartiz_Pan
			from
				Wt_Pan_Table PanTb,
				(
					select
						PSubP.UtenteDB,
						PSubP.Tabella,
						PSubP.NomePartizione,
						PSubP.TablespacePartiz,
						PSubP.CompressionePartiz,
						PSubP.PosizionePartiz,
						PSubP.NumeroSottoPartiz,
						PSubP.NomeSottoPartizione,
						PSubP.TablespaceSottoPartiz,
						PSubP.CompressioneSottoPartiz,
						PSubP.PosizioneSottoPartiz,
						nvl(PSubPPan.UtenteDB,'<Assente>') as UtenteDB_Pan,  -- per costruzione sarà sempre uguale all'Utente della Tabella principale (campo UtenteDB)
						nvl(PSubPPan.Tabella,'<Assente>') as Tabella_Pan,
						nvl(PSubPPan.NomePartizione,'<Assente>') as NomePartizione_Pan,
						nvl(PSubPPan.TablespacePartiz,'Undefined') as TablespacePartiz_Pan,
						nvl(PSubPPan.CompressionePartiz,'Undefined') as CompressionePartiz_Pan,
						nvl(PSubPPan.PosizionePartiz,-1) as PosizionePartiz_Pan,
						nvl(PSubPPan.NumeroSottoPartiz,-1) as NumeroSottoPartiz_Pan,
						nvl(PSubPPan.NomeSottoPartizione,'Undefined') as NomeSottoPartizione_Pan,
						nvl(PSubPPan.TablespaceSottoPartiz,'Undefined') as TablespaceSottoPartiz_Pan,
						nvl(PSubPPan.CompressioneSottoPartiz,'Undefined') as CompressioneSottoPartiz_Pan,
						nvl(PSubPPan.PosizioneSottoPartiz,-1) as PosizioneSottoPartiz_Pan
					from
						(
							select
								Part.Table_Owner as UtenteDB,
								Part.Table_Name as Tabella,
								Part.Partition_Name as NomePartizione,
								Part.Tablespace_Name as TablespacePartiz,
								Part.Compression as CompressionePartiz,
								Part.Partition_Position as PosizionePartiz,
								sum(decode(nvl(SubP.SubPartition_Name,'<Assente>'),'<Assente>',0,1)) over
								(
									partition by
										Part.Partition_Name
								) as NumeroSottoPartiz,
								nvl(SubP.SubPartition_Name,'<Assente>') as NomeSottoPartizione,
								nvl(SubP.Tablespace_Name,'Undefined') as TablespaceSottoPartiz,
								nvl(SubP.Compression,'Undefined') as CompressioneSottoPartiz,
								nvl(SubP.SubPartition_Position,-1) as PosizioneSottoPartiz
							from
								DBA_Tab_Partitions Part,
								DBA_Tab_Subpartitions SubP
							where
								Part.Table_Owner = Utente
							and
								Part.Table_Name = TabOrigine
							and
								Part.Table_Owner = SubP.Table_Owner(+)
							and
								Part.Table_Name = SubP.Table_Name(+)
							and
								Part.Partition_Name = SubP.Partition_Name(+)
						) PSubP,
						(
							select
								PPan.Table_Owner as UtenteDB,
								PPan.Table_Name as Tabella,
								PPan.Partition_Name as NomePartizione,
								PPan.Tablespace_Name as TablespacePartiz,
								PPan.Compression as CompressionePartiz,
								PPan.Partition_Position as PosizionePartiz,
								sum(decode(nvl(SubPan.SubPartition_Name,'<Assente>'),'<Assente>',0,1)) over
								(
									partition by
										PPan.Partition_Name
								) as NumeroSottoPartiz,
								nvl(SubPan.SubPartition_Name,'<Assente>') as NomeSottoPartizione,
								nvl(SubPan.Tablespace_Name,'Undefined') as TablespaceSottoPartiz,
								nvl(SubPan.Compression,'Undefined') as CompressioneSottoPartiz,
								nvl(SubPan.SubPartition_Position,-1) as PosizioneSottoPartiz
							from
								DBA_Tab_Partitions PPan,
								DBA_Tab_Subpartitions SubPan
							where
								PPan.Table_Owner = Utente
							and
								PPan.Table_Name = TabPan
							and
								PPan.Table_Owner = SubPan.Table_Owner(+)
							and
								PPan.Table_Name = SubPan.Table_Name(+)
							and
								PPan.Partition_Name = SubPan.Partition_Name(+)
						) PSubPPan
					where
						PSubP.PosizionePartiz = PSubPPan.PosizionePartiz(+)
					and
						PSubP.PosizioneSottoPartiz = PSubPPan.PosizioneSottoPartiz(+)
				) PInfo
			where
				PanTb.Nome_Utente = Utente
			and
				PanTb.Nome_Tabella = TabOrigine
			and
				PanTb.Nome_Utente = PInfo.UtenteDB(+)
			and
				PanTb.Nome_Tabella = PInfo.Tabella(+);
			commit;

		Else
			Raise Operazione_NonAmmessa;

		End If;



		-- Per il parametro prmTipoUpload sono previsti i soli due valori 'Partizione' e 'Completo'
		-- Qualunque valore fornito differente da quelli indicati, sarà considerato pari a 'Partizione'

		select
			distinct Numero_Partizioni into NumPart_Tabella
		from
			Wt_Pan_Partition
		where
			Nome_Utente = Utente
		and
			Nome_Tabella = TabOrigine;

		If ((TipoUpload <> upper('Completo')) and (NumPart_Tabella > 0)) Then
			TipoUpload := upper('Partizione');
			If (TipoStatistica <> upper('Totale')) Then
				TipoStatistica := upper('Parziale');
			Else
				TipoStatistica := upper('Totale');
			End If;
		Else
			TipoUpload := upper('Completo');
			TipoStatistica := upper('Totale');
		End If;



		Contatore := 0;

		While (ElencoCampi_CCard is not null)
		Loop
			PuntaFine := instr(ElencoCampi_CCard,DoppioPunto,1,1);
			If (PuntaFine = 0) Then
				PuntaFine := length(ElencoCampi_CCard) + 1;
			End If;
			Nome_Carta := trim(substr(ElencoCampi_CCard,1,PuntaFine - 1));
			ElencoCampi_CCard := trim(substr(ElencoCampi_CCard,PuntaFine + 1));

			Begin
				select
					Column_Id into Puntatore_ListaCC
				from
					DBA_Tab_Columns
				where
					Owner = Utente
				and
					Table_Name = TabOrigine
				and
					Column_Name = Nome_Carta
				and
					Data_Type = 'VARCHAR2'
				and
					Data_Length >= 19;
			Exception
				When No_Data_Found Then
					Puntatore_ListaCC := 0;
			End;


			If ((Puntatore_ListaCC > 0) and (not Info_Carta_Credito.Exists(Puntatore_ListaCC))) Then
				Contatore := Contatore + 1;
				Info_Carta_Credito(Puntatore_ListaCC).Campo_CCard := Nome_Carta;

				AliasCC := PreAlias || trim(to_char(Contatore,'09'));
				Info_Carta_Credito(Puntatore_ListaCC).Alias_Pan := AliasCC;

				EsprPan_Carta := replace(EsprPan_Maschera,AliasMaschera,AliasCC);
				EsprPan_Carta := replace(EsprPan_Carta,CampoMaschera,Nome_Carta);
				Info_Carta_Credito(Puntatore_ListaCC).Espr_Pan_CCard := EsprPan_Carta;

				Info_Carta_Credito(Puntatore_ListaCC).Tab_Pan_CCard := Tab || Tab_Cfg_PanToken || Spazio || AliasCC;

				WhereCond_Carta := replace(WhereCond_Maschera,AliasMaschera,AliasCC);
				WhereCond_Carta := replace(WhereCond_Carta,CampoMaschera,Nome_Carta);
				Info_Carta_Credito(Puntatore_ListaCC).WhereCond_CCard := WhereCond_Carta;

			End If;

		End Loop;

		If (Contatore = 0) Then
			Raise Nessuna_Carta_Credito;
		End If;


		HintSelezione := InizioHint || Spazio || 'parallel' || ApriPar || AliasMaster || Virgola || trim(to_char(prmMoltiplicaPar_Master*GradoParallelismo*2,'999')) || ChiudiPar;
		WhereCondition := 'where' || ACapo;
		FromPan := Vuoto;
		Puntatore_ListaCC := Info_Carta_Credito.First;

		While (Puntatore_ListaCC is not null)
		Loop
			HintSelezione := HintSelezione || Spazio || 'parallel' || ApriPar || Info_Carta_Credito(Puntatore_ListaCC).Alias_Pan || Virgola || trim(to_char(prmMoltiplicaPar_Config*GradoParallelismo,'999')) || ChiudiPar;
			WhereCondition := WhereCondition || Info_Carta_Credito(Puntatore_ListaCC).WhereCond_CCard;
			FromPan := FromPan || Info_Carta_Credito(Puntatore_ListaCC).Tab_Pan_CCard;

			If (Puntatore_ListaCC = Info_Carta_Credito.Last) Then
				HintSelezione := HintSelezione || Spazio || FineHint;
				WhereCondition := WhereCondition || PuntoVirgola;
			Else
				WhereCondition := WhereCondition || ACapo || 'and' || ACapo;
				FromPan := FromPan || Virgola || ACapo;
			End If;

			Puntatore_ListaCC := Info_Carta_Credito.Next(Puntatore_ListaCC);

		End Loop;


		SequenzaColonne := Vuoto;
		SequenzaEspressione := Vuoto;

		For InfoColonna In (
				select
					Column_Id as OrdineColonna,
					Column_Name as Colonna,
					max(Column_Id) over
					(
						partition by
							'Gruppo Unico'
					) as NumeroColonne
				from
					DBA_Tab_Columns
				where
					Owner = Utente
				and
					Table_Name = TabOrigine
				order by
					Column_Id
			)
		Loop
			SequenzaColonne := SequenzaColonne || Tab || InfoColonna.Colonna;
			If (Info_Carta_Credito.Exists(InfoColonna.OrdineColonna)) Then
				SequenzaEspressione := SequenzaEspressione || Tab || Info_Carta_Credito(InfoColonna.OrdineColonna).Espr_Pan_CCard;
			Else
				SequenzaEspressione := SequenzaEspressione || Tab || AliasMaster || Punto || InfoColonna.Colonna;
			End If;

			If (InfoColonna.OrdineColonna < InfoColonna.NumeroColonne) Then
				SequenzaColonne := SequenzaColonne || Virgola || ACapo;
				SequenzaEspressione := SequenzaEspressione || Virgola || ACapo;

			End If;

		End Loop;


		Istruzione := '-- Schema:' || Spazio || Utente || ACapo;
		Istruzione := Istruzione || ACapo || ACapo || '-- Upload della Struttura' || Spazio || Utente || Punto || TabOrigine || Spazio || ApriPar || 'Modo Operativo' || DoppioPunto || Spazio || TipoUp_Maschera || ChiudiPar;
		SqlScript_Completo := to_CLob(Istruzione);
		Dbms_Lob.Append(SqlScript_Completo,to_CLob(ACapo || lpad('-',140,'-') || ACapo || ACapo || ACapo || ACapo || ACapo || 'set timing on' || ACapo || ACapo || ACapo || ACapo || ACapo));

		Istruzione := lpad('-',80,'-') || ACapo || '-- INIZIALIZZAZIONE' || ACapo || lpad('-',80,'-') || ACapo || ACapo;
		Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

		For InfoConstraint In (
				select
					Nome_Utente as UtenteDB,
					Nome_Tabella as Tabella,
					Nome_Constraint as Nome,
					Tipo_Constraint as Tipo,
					Constraint_Pan as NomePan,
					Constraint_Oscurata as NomeOscurata
				from
					Wt_Pan_Constraint
				where
					Nome_Utente = Utente
				and
					Nome_Tabella = TabOrigine
				and
					Tipo_Constraint in ('P','U')
			)
		Loop
			Istruzione := 'alter table' || Spazio || TabPan || ACapo || 'disable constraint' || Spazio || InfoConstraint.NomePan || PuntoVirgola || ACapo || ACapo;
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

		End Loop;


		If (TipoUpload = upper('Completo')) Then
			SqlScript_Completo := replace(SqlScript_Completo,TipoUp_Maschera,'Passo UNICO');

			For InfoIndice In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Indice as Nome,
						Tipo_Indice as Tipo,
						Univocita_Indice as Univocita,
						Indice_Token as NomePan,
						Indice_NoCrypto as NomeNoCrypto
					from
						Wt_Token_Index
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop
				Istruzione := 'alter index' || Spazio || InfoIndice.NomePan || Spazio || 'unusable' || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));
			End Loop;


			TabDestinazione := TabPan;

			ClausolaFrom := 'from' || ACapo || Tab || TabOrigine || Spazio || AliasMaster || Virgola;
			ClausolaFrom := ClausolaFrom || ACapo || FromPan;

			Istruzione := ACapo || ACapo || ACapo || '-- Caricamento dati nella Tabella' || Spazio || TabDestinazione || ACapo || lpad('-',140,'-');
			Istruzione := Istruzione || ACapo || ACapo || 'truncate table' || Spazio || TabPan || PuntoVirgola;
			Istruzione := Istruzione || ACapo || ACapo || 'alter session enable parallel dml' || PuntoVirgola || ACapo || 'alter session enable parallel dml' || PuntoVirgola;

			Istruzione := Istruzione || ACapo || ACapo || 'insert' || Spazio || HintInserimento || Spazio || 'into' || Spazio || TabDestinazione || Spazio || AliasIns;
			Istruzione := Istruzione || ACapo || ApriPar;
			Istruzione := Istruzione || ACapo || SequenzaColonne || ACapo || ChiudiPar;

			Istruzione := Istruzione || ACapo || 'select' || Spazio || HintSelezione;
			Istruzione := Istruzione || ACapo || SequenzaEspressione;

			Istruzione := Istruzione || ACapo || ClausolaFrom;
			Istruzione := Istruzione || ACapo || WhereCondition;

			Istruzione := Istruzione || ACapo || ACapo || 'commit' || PuntoVirgola || ACapo || ACapo;

			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			Istruzione := ACapo || ACapo || 'Declare';
			Istruzione := Istruzione || ACapo || 'Begin';
			Istruzione := Istruzione || ACapo || Tab || 'Run_Stats' || ApriPar || Apice || TabDestinazione || Apice || ChiudiPar || PuntoVirgola;
			Istruzione := Istruzione || ACapo || 'End' || PuntoVirgola;
			Istruzione := Istruzione || ACapo || Slash || ACapo || ACapo;
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

		Else
			-- Inizializzazione per la Modalità Operativa 'PARTIZIONE'

			SqlScript_Completo := replace(SqlScript_Completo,TipoUp_Maschera,'Per PARTIZIONI');

			select
				Nome_Base_Pan_Partition || trim(to_char(Sq_Tab_Partition_Pan.NextVal,'09999')) into TabDestinazione
			from
				Dual;

			select
				count(*) into Controllo
			from
				DBA_Tables
			where
				Owner = Utente
			and
				Table_Name = TabDestinazione;

			If (Controllo = 0) Then
				Istruzione := ACapo || 'create table' || Spazio || TabDestinazione || ACapo;
				Istruzione := Istruzione || 'as' || ACapo || 'select' || Spazio || '*' || Spazio || 'from' || Spazio || TabOrigine || Spazio || 'where 1 > 2' || PuntoVirgola || ACapo || ACapo;

				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));
			Else
				Raise Tab_Partizione_Invalida;
			End If;


			CommentoPassoPartiz_Maschera := ACapo || ACapo || ACapo || '-- Elaborazione per i dati della' || Spazio || TipoPartSubPart_Maschera || Spazio || NomePartSubPart_Maschera;
			CommentoPassoPartiz_Maschera := CommentoPassoPartiz_Maschera || ACapo || lpad('-',140,'-');

			ClausolaFrom_Maschera := 'from' || ACapo || Tab || TabOrigine || Spazio || TipoPartSubPart_Maschera || Spazio || ApriPar || NomePartSubPart_Maschera || ChiudiPar || Spazio || AliasMaster || Virgola;
			ClausolaFrom_Maschera := ClausolaFrom_Maschera || ACapo || FromPan;


			-- Ciclo per le Partizioni/SottoPartizioni

			For InfoPartizione In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as TabellaDWH,
						Numero_Partizioni as NumeroPartizioni,
						Nome_Partizione as NomePartizione,
						Part_Tablespace as TablespacePartiz,
						Part_Compression as CompressionePartiz,
						Partition_Position as PosizionePartiz,
						Numero_SottoPartizioni as NumeroSottoPartiz,
						Nome_SottoPartizione as NomeSottoPartizione,
						SubPart_Tablespace as TablespaceSottoPartiz,
						SubPart_Compression as CompressioneSottoPartiz,
						SubPart_Position as PosizioneSottoPartiz,
						Nome_Utente_Pan as UtenteDB_Pan,
						Nome_Tabella_Pan as Tabella_Pan,
						Nome_Partizione_Pan as NomePartizione_Pan,
						Part_Tablespace_Pan as TablespacePartiz_Pan,
						Part_Compression_Pan as CompressionPartiz_Pan,
						Partition_Position_Pan as PosizionePartiz_Pan,
						Numero_SottoPartizioni_Pan as NumeroSottoPartiz_Pan,
						Nome_SottoPartizione_Pan as NomeSottoPartizione_Pan,
						SubPart_Tablespace_Pan as TablespaceSottoPartiz_Pan,
						SubPart_Compression_Pan as CompressioneSottoPartiz_Pan,
						SubPart_Position_Pan as PosizioneSottoPartiz_Pan
					from
						Wt_Pan_Partition
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
					order by
						Partition_Position,
						SubPart_Position
				)
			Loop
				PartSubPart_Compression := 'NoCompress';

				If (InfoPartizione.PosizioneSottoPartiz = -1) Then
					TipoPartSubPart := 'Partition';
					NomePartSubPart := InfoPartizione.NomePartizione;
					NomePartSubPart_Pan := InfoPartizione.NomePartizione_Pan;
					PartSubPart_Tablespace := InfoPartizione.TablespacePartiz;
					If (InfoPartizione.CompressionePartiz = 'ENABLED') Then
						PartSubPart_Compression := 'Compress';
					End If;
				Else
					TipoPartSubPart := 'SubPartition';
					NomePartSubPart := InfoPartizione.NomeSottoPartizione;
					NomePartSubPart_Pan := InfoPartizione.NomeSottoPartizione_Pan;
					PartSubPart_Tablespace := InfoPartizione.TablespaceSottoPartiz;
					If (InfoPartizione.CompressioneSottoPartiz = 'ENABLED') Then
						PartSubPart_Compression := 'Compress';
					End If;
				End If;

				If (TipoPartSubPart like 'Sub%') Then
					CommentoPassoPartiz := replace(CommentoPassoPartiz_Maschera,TipoPartSubPart_Maschera,'SottoPartizione');
				Else
					CommentoPassoPartiz := replace(CommentoPassoPartiz_Maschera,TipoPartSubPart_Maschera,'Partizione');
				End If;
				CommentoPassoPartiz := replace(CommentoPassoPartiz,NomePartSubPart_Maschera,NomePartSubPart);

				ClausolaFrom := replace(ClausolaFrom_Maschera,TipoPartSubPart_Maschera,TipoPartSubPart);
				ClausolaFrom := replace(ClausolaFrom,NomePartSubPart_Maschera,NomePartSubPart);

				Istruzione := ACapo || ACapo || CommentoPassoPartiz;
				Istruzione := Istruzione || ACapo || ACapo || 'truncate table' || Spazio || TabDestinazione || PuntoVirgola;

				Istruzione := Istruzione || ACapo || ACapo || 'alter table' || Spazio || TabDestinazione;
				Istruzione := Istruzione || ACapo || 'move tablespace' || Spazio || PartSubPart_Tablespace || Spazio || PartSubPart_Compression || PuntoVirgola;

				Istruzione := Istruzione || ACapo || ACapo || 'alter session enable parallel dml' || PuntoVirgola || ACapo || 'alter session enable parallel dml' || PuntoVirgola;

				Istruzione := Istruzione || ACapo || ACapo || 'insert' || Spazio || HintInserimento || Spazio || 'into' || Spazio || TabDestinazione || Spazio || AliasIns;
				Istruzione := Istruzione || ACapo || ApriPar;
				Istruzione := Istruzione || ACapo || SequenzaColonne || ACapo || ChiudiPar;

				Istruzione := Istruzione || ACapo || 'select' || Spazio || HintSelezione;
				Istruzione := Istruzione || ACapo || SequenzaEspressione;

				Istruzione := Istruzione || ACapo || ClausolaFrom;
				Istruzione := Istruzione || ACapo || WhereCondition;

				Istruzione := Istruzione || ACapo || ACapo || 'commit' || PuntoVirgola;

				Istruzione := Istruzione || ACapo || ACapo || 'alter table' || Spazio || TabPan;
				Istruzione := Istruzione || ACapo || 'exchange' || Spazio || TipoPartSubPart || Spazio || NomePartSubPart_Pan || Spazio || 'with table' || Spazio || TabDestinazione || Spazio || 'without validation' || PuntoVirgola;

				If (TipoStatistica = upper('Parziale')) Then
					Istruzione := Istruzione || ACapo || ACapo || 'Declare';
					Istruzione := Istruzione || ACapo || 'Begin';
					Istruzione := Istruzione || ACapo || Tab || 'Dbms_Stats' || Punto || 'Gather_Table_Stats' || ApriPar;
					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'OwnName =>' || Spazio || Apice || Utente || Apice || Virgola;
					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'TabName =>' || Spazio || Apice || TabPan || Apice || Virgola;
					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'PartName =>' || Spazio || Apice || NomePartSubPart_Pan || Apice || Virgola;
--					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Estimate_Percent => 0.01' || Virgola;
					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Estimate_Percent =>' || Spazio || trim(to_char(1/prmFattoreStima,'9D999999','Nls_Numeric_Characters = ''.,''')) || Virgola;
					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Degree =>' || Spazio || trim(to_char(prmStatDegree,'999')) || Virgola;
					Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Cascade => false';
					Istruzione := Istruzione || ACapo || Tab || Tab || ChiudiPar || PuntoVirgola;
					Istruzione := Istruzione || ACapo || 'End' || PuntoVirgola;
					Istruzione := Istruzione || ACapo || Slash;

				End If;

				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			If (TipoStatistica = upper('Totale')) Then
				Istruzione := ACapo || ACapo || 'Declare';
				Istruzione := Istruzione || ACapo || 'Begin';
				Istruzione := Istruzione || ACapo || Tab || 'Dbms_Stats' || Punto || 'Gather_Table_Stats' || ApriPar;
				Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'OwnName =>' || Spazio || Apice || Utente || Apice || Virgola;
				Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'TabName =>' || Spazio || Apice || TabPan || Apice || Virgola;
--				Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Estimate_Percent => 0.01' || Virgola;
				Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Estimate_Percent =>' || Spazio || trim(to_char(1/prmFattoreStima,'9D999999','Nls_Numeric_Characters = ''.,''')) || Virgola;
				Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Degree =>' || Spazio || trim(to_char(prmStatDegree,'999')) || Virgola;
				Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'Cascade => false';
				Istruzione := Istruzione || ACapo || Tab || Tab || ChiudiPar || PuntoVirgola;
				Istruzione := Istruzione || ACapo || 'End' || PuntoVirgola;
				Istruzione := Istruzione || ACapo || Slash;

				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End If;


		End If;



		Istruzione := ACapo || ACapo || ACapo || ACapo || lpad('-',80,'-') || ACapo ||  '-- FINALIZZAZIONE' || ACapo || lpad('-',80,'-') || ACapo || ACapo || ACapo;
		Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

		Declare
			GradoPar_Indice Pls_Integer;
			NumIstanze_Indice Pls_Integer;
			Ind_Partizionato Pls_Integer;

			TipoPartizione Varchar2(30);
			PartSubPart_Indice Varchar2(30);

			Messaggio Varchar2(800);

		Begin
			Istruzione := Vuoto;

			For Indice In (
					select
						Indice_Pan as NomePan
					from
						Wt_Pan_Index
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop

				select
					Degree,
					Instances,
					decode(Partitioned,'YES',1,0)
				into
					GradoPar_Indice,
					NumIstanze_Indice,
					Ind_Partizionato
				from
					DBA_Indexes
				where
					Owner = Utente
				and
					Index_Name = Indice.NomePan;


				If (Ind_Partizionato = 0) Then
					Istruzione := Istruzione || 'alter index' || Spazio || Indice.NomePan || Spazio || 'rebuild' || Spazio || 'parallel' || Spazio || trim(to_char(4*prmMoltiplicaPar_Master*GradoParallelismo,'999')) || PuntoVirgola || ACapo || ACapo;

				Else
					For InfoPartIndice In (
							select
								Prtz.Partition_Name as NomePartizione_Indice,
								Prtz.Partition_Position as OrdinePartizione,
								Prtz.SubPartition_Count as NumeroSottoPartiz,
								nvl(SubP.SubPartition_Name,'<Assente>') as NomeSottoPartizione_Indice,
								nvl(SubP.SubPartition_Position,-1) as OrdineSottoPartizione
							from
								DBA_Ind_Partitions Prtz,
								DBA_Ind_SubPartitions SubP
							where
								Prtz.Index_Owner = Utente
							and
								Prtz.Index_Name = Indice.NomePan
							and
								Prtz.Index_Owner = SubP.Index_Owner(+)
							and
								Prtz.Index_Name = SubP.Index_Name(+)
							and
								Prtz.Partition_Name = SubP.Partition_Name(+)
							order by
								Prtz.Partition_Position,
								nvl(SubP.SubPartition_Position,-1)
						)
					Loop
						If (InfoPartIndice.OrdineSottoPartizione = -1) Then
							TipoPartizione := 'Partition';
							PartSubPart_Indice := InfoPartIndice.NomePartizione_Indice;
						Else
							TipoPartizione := 'SubPartition';
							PartSubPart_Indice := InfoPartIndice.NomeSottoPartizione_Indice;
						End If;

						Istruzione := Istruzione || 'alter index' || Spazio || Indice.NomePan || Spazio || 'rebuild' || Spazio || TipoPartizione || Spazio || PartSubPart_Indice || Spazio || 'parallel' || Spazio || trim(to_char(4*prmMoltiplicaPar_Master*GradoParallelismo,'999')) || PuntoVirgola || ACapo || ACapo;

					End Loop;

				End If;

				Istruzione := Istruzione || 'alter index' || Spazio || Indice.NomePan || Spazio || 'parallel' || Spazio || ApriPar || 'degree' || Spazio || trim(to_char(GradoPar_Indice,'999')) || Spazio || 'instances' || Spazio || trim(to_char(NumIstanze_Indice,'999')) || ChiudiPar || PuntoVirgola || ACapo || ACapo;

			End Loop;

			If (Istruzione is not null) Then
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));
			End If;

		Exception
			When Others Then
				Messaggio := 'Errore Riscontrato nel Blocco Anonimo per la generazione delle istruzioni di rebuild degli indici';
				Dbms_Output.Put_Line(Messaggio);

				Raise;

		End;


		For InfoConstraint In (
				select
					Nome_Utente as UtenteDB,
					Nome_Tabella as Tabella,
					Nome_Constraint as Nome,
					Tipo_Constraint as Tipo,
					Constraint_Pan as NomePan,
					Constraint_Oscurata as NomeOscurata
				from
					Wt_Pan_Constraint
				where
					Nome_Utente = Utente
				and
					Nome_Tabella = TabOrigine
				and
					Tipo_Constraint in ('P','U')
			)
		Loop
			Istruzione := 'alter table' || Spazio || TabPan || ACapo || 'enable constraint' || Spazio || InfoConstraint.NomePan || PuntoVirgola || ACapo || ACapo;
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

		End Loop;



		Istruzione := ACapo || ACapo || ACapo || 'update Wt_Pan_Table' || ACapo || 'set' || ACapo;
		Istruzione := Istruzione || Tab || 'Des_Stato_Illuminazione' || Spazio || '=' || Spazio || Apice || PanUpload_Eseguito || Apice || Virgola || ACapo;
		Istruzione := Istruzione || Tab || 'Dat_Aggiornamento' || Spazio || '=' || Spazio || 'SysDate' || ACapo;
		Istruzione := Istruzione || 'where' || ACapo;
		Istruzione := Istruzione || Tab || 'Nome_Utente' || Spazio || '=' || Spazio || Apice || Utente || Apice || ACapo;
		Istruzione := Istruzione || 'and' || ACapo;
		Istruzione := Istruzione || Tab || 'Nome_Tabella' || Spazio || '=' || Spazio || Apice || TabOrigine || Apice || PuntoVirgola;
		Istruzione := Istruzione || ACapo || ACapo || 'commit' || PuntoVirgola || ACapo || ACapo || ACapo || ACapo || ACapo || 'set timing off' || ACapo || ACapo;

		Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


		update Wt_Pan_Table
		set
			SqlScript_Carica_Pan = SqlScript_Completo,
			Des_Stato_Illuminazione = PanUpload_Generato,
			Dat_Aggiornamento = SysDate
		where
			Nome_Utente = Utente
		and
			Nome_Tabella = TabOrigine;
		commit;


	Exception
		When TabellaDWH_Assente Then
			MessaggioErroreGen := 'Struttura Indicata' || Spazio || ApriPar || Utente || Punto || TabOrigine || ChiudiPar || Spazio || 'NON Trovata';
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Operazione_NonAmmessa Then
			MessaggioErroreGen := 'Stato Illuminazione NON Compatibile con l''Operazione Richiesta';
			MessaggioErroreGen := MessaggioErroreGen || ACapo || Tab || 'Stato Illuminazione:' || Spazio || StatoPan;
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Nessuna_Carta_Credito Then
			MessaggioErroreGen := 'Nessuna Carta di Credito Riconosciuta nella sequenza fornita:';
			MessaggioErroreGen := MessaggioErroreGen || ACapo || Tab || prmElencoCampi_CCard;
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Tab_Partizione_Invalida Then
			MessaggioErroreGen := 'La Tabella prevista per recepire i dati della Partizione, NON è Utilizzabile';
			MessaggioErroreGen := MessaggioErroreGen || ACapo || Tab || 'Tabella Dati Partizione:' || Spazio || TabDestinazione;
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Others Then
			ErrOracle := SqlCode;
			MessaggioErrOra := SqlErrm;
			Dbms_Output.Put_Line(MessaggioErrOra);
			Raise;

	End Prc_Crea_Pan_Upload;




	Procedure Prc_Crea_Rinomina_Pan(
			prmUtente In Varchar2,
			prmTabella In Varchar2
		)
	As
		Utente Varchar2(30);
		TabOrigine Varchar2(30);
		TabPan Varchar2(30);
		TabOscurata Varchar2(30);

		VerificaTabella Pls_Integer;
		StatoPan Varchar2(100);

		Proc_Allineamento Constant Varchar2(30) := upper('Prc_Allinea_Token_Pan_Info');
		Istruzione Long;
		SqlScript_Completo CLob;

		ErrOracle Varchar2(50);
		MessaggioErrOra Varchar2(1000);

		MessaggioErroreGen Varchar2(1000);

	Begin
		Utente := upper(prmUtente);
		TabOrigine := upper(prmTabella);

		select
			count(*) into VerificaTabella
		from
			DBA_Tables
		where
			Owner = Utente
		and
			Table_Name = TabOrigine;

		If (VerificaTabella = 0) Then
			Raise TabellaDWH_Assente;
		End If;


		Begin
			select
				Tabella_Pan,
				Tabella_Oscurata,
				Des_Stato_Illuminazione
			into
				TabPan,
				TabOscurata,
				StatoPan
			from
				Wt_Pan_Table
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;

		Exception
			When No_Data_Found Then
				TabPan := Vuoto;
				TabOscurata := Vuoto;
				StatoPan := StatoAssente;

		End;


		If (StatoPan = PanUpload_Eseguito) Then
			Istruzione := '-- Schema:' || Spazio || Utente || ACapo;
			Istruzione := Istruzione || ACapo || ACapo || '-- Rinomina delle Strutture' || Spazio || ApriPar || TabOrigine || Spazio || '-->' || Spazio || TabOscurata || ChiudiPar || Spazio || '-' || Spazio || ApriPar || TabPan || Spazio || '-->' || Spazio || TabOrigine || ChiudiPar;

			SqlScript_Completo := to_CLob(Istruzione);
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(ACapo || lpad('-',200,'-') || ACapo || ACapo || ACapo || ACapo));

			Istruzione := 'rename' || Spazio || TabOrigine || Spazio || 'to' || Spazio || TabOscurata || PuntoVirgola || ACapo || ACapo;
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			For InfoConstraint In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Constraint as Nome,
						Tipo_Constraint as Tipo,
						Constraint_Pan as NomePan,
						Constraint_Oscurata as NomeOscurata
					from
						Wt_Pan_Constraint
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop
				Istruzione := 'alter table' || Spazio || TabOscurata || ACapo || 'rename constraint' || Spazio || InfoConstraint.Nome || Spazio || 'to' || Spazio || InfoConstraint.NomeOscurata || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			For InfoIndice In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Indice as Nome,
						Tipo_Indice as Tipo,
						Univocita_Indice as Univocita,
						Indice_Pan as NomePan,
						Indice_Oscurata as NomeOscurata
					from
						Wt_Pan_Index
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop
				Istruzione := 'alter index' || Spazio || InfoIndice.Nome || Spazio || 'rename to' || Spazio || InfoIndice.NomeOscurata || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			Istruzione := ACapo || ACapo || 'rename' || Spazio || TabPan || Spazio || 'to' || Spazio || TabOrigine || PuntoVirgola || ACapo || ACapo;
			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			For InfoConstraint In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Constraint as Nome,
						Tipo_Constraint as Tipo,
						Constraint_Pan as NomePan,
						Constraint_Oscurata as NomeOscurata
					from
						Wt_Pan_Constraint
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop
				Istruzione := 'alter table' || Spazio || TabOrigine || ACapo || 'rename constraint' || Spazio || InfoConstraint.NomePan || Spazio || 'to' || Spazio || InfoConstraint.Nome || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			For InfoIndice In (
					select
						Nome_Utente as UtenteDB,
						Nome_Tabella as Tabella,
						Nome_Indice as Nome,
						Tipo_Indice as Tipo,
						Univocita_Indice as Univocita,
						Indice_Pan as NomePan,
						Indice_Oscurata as NomeOscurata
					from
						Wt_Pan_Index
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine
				)
			Loop
				Istruzione := 'alter index' || Spazio || InfoIndice.NomePan || Spazio || 'rename to' || Spazio || InfoIndice.Nome || PuntoVirgola || ACapo || ACapo;
				Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));

			End Loop;


			Istruzione := ACapo || ACapo || ACapo || 'update Wt_Pan_Table' || ACapo || 'set' || ACapo;
			Istruzione := Istruzione || Tab || 'Des_Stato_Illuminazione' || Spazio || '=' || Spazio || Apice || StatoPan_Completo || Apice || Virgola || ACapo;
			Istruzione := Istruzione || Tab || 'Dat_Aggiornamento' || Spazio || '=' || Spazio || 'SysDate' || ACapo;
			Istruzione := Istruzione || 'where' || ACapo;
			Istruzione := Istruzione || Tab || 'Nome_Utente' || Spazio || '=' || Spazio || Apice || Utente || Apice || ACapo;
			Istruzione := Istruzione || 'and' || ACapo;
			Istruzione := Istruzione || Tab || 'Nome_Tabella' || Spazio || '=' || Spazio || Apice || TabOrigine || Apice || PuntoVirgola;
			Istruzione := Istruzione || ACapo || ACapo || 'commit' || PuntoVirgola || ACapo || ACapo;

			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			Istruzione := ACapo || ACapo || ACapo || 'Declare' || ACapo || 'Begin' || ACapo;
			Istruzione := Istruzione || Tab || NomePackage || Punto || Proc_Allineamento || ApriPar;
			Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'prmUtente =>' || Spazio || Apice || prmUtente || Apice || Virgola;
			Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'prmTabella =>' || Spazio || Apice || prmTabella || Apice || Virgola;
			Istruzione := Istruzione || ACapo || Tab || Tab || Tab || 'prmTipoChiusura =>' || Spazio || Apice || StatoPan_Completo || Apice;
			Istruzione := Istruzione || ACapo || Tab || Tab || ChiudiPar || PuntoVirgola;
			Istruzione := Istruzione || ACapo || 'End' || PuntoVirgola;
			Istruzione := Istruzione || ACapo || Slash || ACapo || ACapo;

			Dbms_Lob.Append(SqlScript_Completo,to_CLob(Istruzione));


			update Wt_Pan_Table
			set
				SqlScript_Rinomina_Pan = SqlScript_Completo,
				Des_Stato_Illuminazione = PanRinomina_Disponibile,
				Dat_Aggiornamento = SysDate
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
			commit;

		Else
			Raise Operazione_NonAmmessa;

		End If;


	Exception
		When TabellaDWH_Assente Then
			MessaggioErroreGen := 'Struttura Indicata' || Spazio || ApriPar || Utente || Punto || TabOrigine || ChiudiPar || Spazio || 'NON Trovata';
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Operazione_NonAmmessa Then
			MessaggioErroreGen := 'Stato Illuminazione NON Compatibile con l''Operazione Richiesta';
			MessaggioErroreGen := MessaggioErroreGen || ACapo || Tab || 'Stato Illuminazione:' || Spazio || StatoPan;
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Others Then
			ErrOracle := SqlCode;
			MessaggioErrOra := SqlErrm;
			Dbms_Output.Put_Line(MessaggioErrOra);
			Raise;

	End Prc_Crea_Rinomina_Pan;




	Procedure Prc_Allinea_Token_Pan_Info(
			prmUtente In Varchar2,
			prmTabella In Varchar2,
			prmTipoChiusura In Varchar2
		)
	As
		DataFittizia Constant Date := to_date('99991231','yyyymmdd');

		Utente Varchar2(30);
		TabOrigine Varchar2(30);
		TabToken Varchar2(30);
		TabNoCrypto Varchar2(30);
		TabPan Varchar2(30);
		TabOscurata Varchar2(30);

		StatoToken Varchar2(100);
		StatoPan Varchar2(100);
		DataToken Date;
		DataPan Date;

		VerificaTabella Pls_Integer;
		Controllo Pls_Integer;  -- Variabile definita per maggior sicurezza

		ErrOracle Varchar2(50);
		MessaggioErrOra Varchar2(1000);

		MessaggioErroreGen Varchar2(1000);

	Begin
		Utente := upper(prmUtente);
		TabOrigine := upper(prmTabella);
		TabToken := PreToken || substr(TabOrigine,1,28);
		TabNoCrypto := PreNoCrypto || substr(TabOrigine,1,28);
		TabPan := PrePan || substr(TabOrigine,1,28);
		TabOscurata := PreOscurata || substr(TabOrigine,1,28);

		select
			count(*) into VerificaTabella
		from
			DBA_Tables
		where
			Owner = Utente
		and
			Table_Name = TabOrigine;

		If (VerificaTabella = 0) Then
			Raise TabellaDWH_Assente;
		End If;


		Begin
			select
				Des_Stato_Oscuramento,
				Dat_Aggiornamento
			into
				StatoToken,
				DataToken
			from
				Wt_Token_Table
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
		Exception
			When No_Data_Found Then
				StatoToken := StatoAssente;
				DataToken := DataFittizia;
		End;

		Begin
			select
				Des_Stato_Illuminazione,
				Dat_Aggiornamento
			into
				StatoPan,
				DataPan
			from
				Wt_Pan_Table
			where
				Nome_Utente = Utente
			and
				Nome_Tabella = TabOrigine;
		Exception
			When No_Data_Found Then
				StatoPan := StatoAssente;
				DataPan := DataFittizia;
		End;


		Case
			When (prmTipoChiusura = StatoToken_Completo) and (StatoToken = StatoToken_Completo) and (StatoPan = StatoPan_Completo) Then
				If (DataToken > DataPan) Then
					delete from Wt_Pan_Table
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine;
					commit;

					select
						count(*) into Controllo
					from
						DBA_Tables
					where
						Owner = Utente
					and
						Table_Name = TabOscurata;

					If (Controllo = 1) Then
						Dbms_Output.Put_Line('Eliminazione della Tabella:' || ACapo || Tab || Utente || Punto || TabOscurata || ACapo);
						execute immediate 'drop table' || Spazio || Utente || Punto || TabOscurata;

					End If;

				End If;

			When (prmTipoChiusura = StatoPan_Completo) and (StatoPan = StatoPan_Completo) and (StatoToken = StatoToken_Completo) Then
				If (DataPan > DataToken) Then
					delete from Wt_Token_Table
					where
						Nome_Utente = Utente
					and
						Nome_Tabella = TabOrigine;
					commit;

					select
						count(*) into Controllo
					from
						DBA_Tables
					where
						Owner = Utente
					and
						Table_Name = TabNoCrypto;

					If (Controllo = 1) Then
						Dbms_Output.Put_Line('Eliminazione della Tabella:' || ACapo || Tab || Utente || Punto || TabNoCrypto || ACapo);
						execute immediate 'drop table' || Spazio || Utente || Punto || TabNoCrypto;

					End If;

				End If;

		Else
			Dbms_Output.Put_Line('NON è stata Riscontrata la Condizione per Aggiornare le Tabelle Tecniche' || ACapo);

		End Case;

	Exception
		When TabellaDWH_Assente Then
			MessaggioErroreGen := 'Struttura Indicata' || Spazio || ApriPar || Utente || Punto || TabOrigine || ChiudiPar || Spazio || 'NON Trovata';
			Dbms_Output.Put_Line(MessaggioErroreGen);
			Raise_Application_Error(ErroreGenerato,MessaggioErroreGen);

		When Others Then
			ErrOracle := SqlCode;
			MessaggioErrOra := SqlErrm;
			Dbms_Output.Put_Line(MessaggioErrOra);
			Raise;

	End Prc_Allinea_Token_Pan_Info;






End Pkg_Oscura_Illumina_CCard;
/












-- Dwh_Dds
-------------------






create table Wt_Token_Table
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Tabella_Token Varchar2(30),
	Tabella_NoCrypto Varchar2(30),
	SqlScript_Creazione_Token CLob,
	SqlScript_Carica_Token CLob,
	SqlScript_Rinomina_Token CLob,
	Des_Stato_Oscuramento Varchar2(100),
	Dat_Aggiornamento Date,
	constraint XPK_Wt_Token_Table Primary Key
	(
		Nome_Utente,
		Nome_Tabella
	)
)
tablespace Tbs_A;

create table Wt_Pan_Table
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Tabella_Pan Varchar2(30),
	Tabella_Oscurata Varchar2(30),
	SqlScript_Creazione_Pan CLob,
	SqlScript_Carica_Pan CLob,
	SqlScript_Rinomina_Pan CLob,
	Des_Stato_Illuminazione Varchar2(100),
	Dat_Aggiornamento Date,
	constraint XPK_Wt_Pan_Table Primary Key
	(
		Nome_Utente,
		Nome_Tabella
	)
)
tablespace Tbs_A;


create table Wt_Token_Index
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Nome_Indice Varchar2(30),
	Tipo_Indice Varchar2(27),
	Univocita_Indice Varchar2(9),
	Indice_Token Varchar2(30),
	Indice_NoCrypto Varchar2(30),
	constraint XPK_Wt_Token_Index Primary Key
	(
		Nome_Utente,
		Nome_Indice
	)
)
tablespace Tbs_A;

create table Wt_Pan_Index
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Nome_Indice Varchar2(30),
	Tipo_Indice Varchar2(27),
	Univocita_Indice Varchar2(9),
	Indice_Pan Varchar2(30),
	Indice_Oscurata Varchar2(30),
	constraint XPK_Wt_Pan_Index Primary Key
	(
		Nome_Utente,
		Nome_Indice
	)
)
tablespace Tbs_A;


create table Wt_Token_Constraint
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Nome_Constraint Varchar2(30) not null,
	Tipo_Constraint Varchar2(1),
	Constraint_Token Varchar2(30),
	Constraint_NoCrypto Varchar2(30),
	constraint XPK_Wt_Token_Constraint Primary Key
	(
		Nome_Utente,
		Nome_Tabella,
		Nome_Constraint
	)
)
tablespace Tbs_A;

create table Wt_Pan_Constraint
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Nome_Constraint Varchar2(30) not null,
	Tipo_Constraint Varchar2(1),
	Constraint_Pan Varchar2(30),
	Constraint_Oscurata Varchar2(30),
	constraint XPK_Wt_Pan_Constraint Primary Key
	(
		Nome_Utente,
		Nome_Tabella,
		Nome_Constraint
	)
)
tablespace Tbs_A;


create table Wt_Token_Partition
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Numero_Partizioni Number,
	Nome_Partizione Varchar2(30) not null,
	Part_Tablespace Varchar2(30),
	Part_Compression Varchar2(9),
	Partition_Position Number,
	Numero_SottoPartizioni Number,
	Nome_SottoPartizione Varchar2(30) not null,
	SubPart_Tablespace Varchar2(30),
	SubPart_Compression Varchar2(9),
	SubPart_Position Number,
	Nome_Utente_Tk Varchar2(30),
	Nome_Tabella_Tk Varchar2(30),
	Nome_Partizione_Tk Varchar2(30),
	Part_Tablespace_Tk Varchar2(30),
	Part_Compression_Tk Varchar2(9),
	Partition_Position_Tk Number,
	Numero_SottoPartizioni_Tk Number,
	Nome_SottoPartizione_Tk Varchar2(30),
	SubPart_Tablespace_Tk Varchar2(30),
	SubPart_Compression_Tk Varchar2(9),
	SubPart_Position_Tk Number,
	constraint XPK_Wt_Token_Partition Primary Key
	(
		Nome_Utente,
		Nome_Tabella,
		Nome_Partizione,
		Nome_SottoPartizione
	)
)
tablespace Tbs_A;

create table Wt_Pan_Partition
(
	Nome_Utente Varchar2(30) not null,
	Nome_Tabella Varchar2(30) not null,
	Numero_Partizioni Number,
	Nome_Partizione Varchar2(30) not null,
	Part_Tablespace Varchar2(30),
	Part_Compression Varchar2(9),
	Partition_Position Number,
	Numero_SottoPartizioni Number,
	Nome_SottoPartizione Varchar2(30) not null,
	SubPart_Tablespace Varchar2(30),
	SubPart_Compression Varchar2(9),
	SubPart_Position Number,
	Nome_Utente_Pan Varchar2(30),
	Nome_Tabella_Pan Varchar2(30),
	Nome_Partizione_Pan Varchar2(30),
	Part_Tablespace_Pan Varchar2(30),
	Part_Compression_Pan Varchar2(9),
	Partition_Position_Pan Number,
	Numero_SottoPartizioni_Pan Number,
	Nome_SottoPartizione_Pan Varchar2(30),
	SubPart_Tablespace_Pan Varchar2(30),
	SubPart_Compression_Pan Varchar2(9),
	SubPart_Position_Pan Number,
	constraint XPK_Wt_Pan_Partition Primary Key
	(
		Nome_Utente,
		Nome_Tabella,
		Nome_Partizione,
		Nome_SottoPartizione
	)
)
tablespace Tbs_A;


create sequence Sq_Tab_Partition_Token
increment by 1
start with 1
MaxValue 99999
NoCache
order;

create sequence Sq_Tab_Partition_Pan
increment by 1
start with 1
MaxValue 99999
NoCache
order;



-- Concessione dei Privilegi, sulle Strutture Tecniche, all'Utente Dwh_Ods

grant select, insert, update, delete on Wt_Token_Table to Dwh_Ods;

grant select, insert, update, delete on Wt_Token_Index to Dwh_Ods;

grant select, insert, update, delete on Wt_Token_Constraint to Dwh_Ods;

grant select, insert, update, delete on Wt_Token_Partition to Dwh_Ods;

grant select, insert, update, delete on Wt_Pan_Table to Dwh_Ods;

grant select, insert, update, delete on Wt_Pan_Index to Dwh_Ods;

grant select, insert, update, delete on Wt_Pan_Constraint to Dwh_Ods;

grant select, insert, update, delete on Wt_Pan_Partition to Dwh_Ods;

grant select on Sq_Tab_Partition_Token to Dwh_Ods;

grant select on Sq_Tab_Partition_Pan to Dwh_Ods;

grant select on Wt_Cfg_CC_Target_Pan_Token to Dwh_Dds;

create synonym Dwh_Dds.Wt_Cfg_CC_Target_Pan_Token for Dwh_Ods.Wt_Cfg_CC_Target_Pan_Token;



-- Creazione dei Sinonimi per le Strutture Tecniche, sullo schema Dwh_Ods

create synonym Wt_Token_Table for Dwh_Dds.Wt_Token_Table;

create synonym Wt_Token_Index for Dwh_Dds.Wt_Token_Index;

create synonym Wt_Token_Constraint for Dwh_Dds.Wt_Token_Constraint;

create synonym Wt_Token_Partition for Dwh_Dds.Wt_Token_Partition;

create synonym Wt_Pan_Table for Dwh_Dds.Wt_Pan_Table;

create synonym Wt_Pan_Index for Dwh_Dds.Wt_Pan_Index;

create synonym Wt_Pan_Constraint for Dwh_Dds.Wt_Pan_Constraint;

create synonym Wt_Pan_Partition for Dwh_Dds.Wt_Pan_Partition;

create synonym Sq_Tab_Partition_Token for Dwh_Dds.Sq_Tab_Partition_Token;

create synonym Sq_Tab_Partition_Pan for Dwh_Dds.Sq_Tab_Partition_Pan;
























------------------------------------------------------------------------------------------------------------------------------------------------
-- Esempi di Invocazione
------------------------------------------------------------------------------------------------------------------------------------------------









Declare
	UtenteDBase Constant Varchar2(30) := 'DWH_DM';
	TabellaDWH Constant Varchar2(30) := upper('Dm_Profilo_Fatt');
Begin
	Pkg_Oscura_Illumina_CCard.Prc_Crea_Copia_Token(
			prmUtente => UtenteDBase,
			prmTabella => TabellaDWH
		);
End;
/



Declare
	UtenteDBase Constant Varchar2(30) := 'DWH_DM';
	TabellaDWH Constant Varchar2(30) := upper('Dm_Profilo_Fatt');
	Elenco_CartaCredito Constant Varchar2(2000) := 'Num_Carta_Cred:AltraCCard';
Begin
	Pkg_Oscura_Illumina_CCard.Prc_Crea_Token_Upload(
			prmUtente => UtenteDBase,
			prmTabella => TabellaDWH,
			prmElencoCampi_CCard => Elenco_CartaCredito,  -- I Campi rappresentanti Carte di Credito dovranno essere separati dal carattere ':'
			prmTipoUpload => 'Partizione',  -- Il valore di Default per prmTipoUpload è 'Partizione'
			prmMoltiplicaPar_Master => 1,  -- Fattore di Moltliplicazione del Grado di Parallelismo relativo alla tabella Master
			prmMoltiplicaPar_Config => 1,  -- Fattore di Moltliplicazione del Grado di Parallelismo relativo alla tabella Config (associativa Pan-Token)
			prmTipoStatistica => 'Parziale',  -- Il valore di Default per prmTipoStatistica è 'Parziale'
			prmFattoreStima => 100,  -- Fattore di Divisione, rispetto all'unità, per determinare la frazione di Stima
			prmStatDegree => 16
		);
End;
/



Declare
	UtenteDBase Constant Varchar2(30) := 'DWH_DM';
	TabellaDWH Constant Varchar2(30) := upper('Dm_Profilo_Fatt');
Begin
	Pkg_Oscura_Illumina_CCard.Prc_Crea_Rinomina_Token(
			prmUtente => UtenteDBase,
			prmTabella => TabellaDWH
		);
End;
/









Declare
	UtenteDBase Constant Varchar2(30) := 'DWH_DM';
	TabellaDWH Constant Varchar2(30) := upper('Dm_Profilo_Fatt');
Begin
	Pkg_Oscura_Illumina_CCard.Prc_Crea_Copia_Pan(
			prmUtente => UtenteDBase,
			prmTabella => TabellaDWH
		);
End;
/



Declare
	UtenteDBase Constant Varchar2(30) := 'DWH_DM';
	TabellaDWH Constant Varchar2(30) := upper('Dm_Profilo_Fatt');
	Elenco_CartaCredito Constant Varchar2(2000) := 'Num_Carta_Cred:AltraCCard';
Begin
	Pkg_Oscura_Illumina_CCard.Prc_Crea_Pan_Upload(
			prmUtente => UtenteDBase,
			prmTabella => TabellaDWH,
			prmElencoCampi_CCard => Elenco_CartaCredito,  -- I Campi rappresentanti Carte di Credito dovranno essere separati dal carattere ':'
			prmTipoUpload => 'Partizione',  -- Il valore di Default per prmTipoUpload è 'Partizione'
			prmMoltiplicaPar_Master => 1,  -- Fattore di Moltliplicazione del Grado di Parallelismo relativo alla tabella Master
			prmMoltiplicaPar_Config => 1,  -- Fattore di Moltliplicazione del Grado di Parallelismo relativo alla tabella Config (associativa Pan-Token)
			prmTipoStatistica => 'Parziale',  -- Il valore di Default per prmTipoStatistica è 'Parziale'
			prmFattoreStima => 100,  -- Fattore di Divisione, rispetto all'unità, per determinare la frazione di Stima
			prmStatDegree => 16
		);
End;
/



Declare
	UtenteDBase Constant Varchar2(30) := 'DWH_DM';
	TabellaDWH Constant Varchar2(30) := upper('Dm_Profilo_Fatt');
Begin
	Pkg_Oscura_Illumina_CCard.Prc_Crea_Rinomina_Pan(
			prmUtente => UtenteDBase,
			prmTabella => TabellaDWH
		);
End;
/
