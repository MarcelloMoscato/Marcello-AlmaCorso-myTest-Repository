Declare
	varIntera Pls_Integer;
	SequenzaCara Varchar2(850);
Begin
	select
		count(*) into varIntera;
	from
		mmTabellaBase
	where
		Colonna like '%' || 'Riferimento' || '%'


	DBMS_Output.Put_Line(concat('Numero Record: ', to_char(varIntera));

	SequenzaCara := 'Impostazione Iniziale Stringa';

Exception
	When Others Then
		DBMS_Output.Put_Line(SqlErrm);

End;
/
