#INCLUDE 'TOTVS.CH'
#DEFINE K_CTRL_E 5

User Function AfterLogin()

	SetKey( K_CTRL_E, { || U_EXECUTE() } )

Return

User Function Execute()

	Local oGet1
	Local cGet1 := MemoRead( '\system\bufexec.txt' )
	Local oSButton1
	Local oSButton2
	Static oDlg

	cGet1 := cGet1 + Space( 1048575 - Len( cGet1 ) )

	DEFINE MSDIALOG oDlg TITLE 'Executar' FROM 000, 000  TO 100, 1000 COLORS 0, 16777215 PIXEL

	@ 015, 005 MSGET oGet1 VAR cGet1 SIZE 490, 010 OF oDlg COLORS 0, 16777215 PIXEL
	DEFINE SBUTTON oSButton1 FROM 035, 005 TYPE 01 OF oDlg ENABLE ACTION Eval( {|| Execute( cGet1 ) } )
	DEFINE SBUTTON oSButton2 FROM 035, 035 TYPE 02 OF oDlg ENABLE ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function Execute( cGet1 )

	Local cBlc := '{||' + AllTrim( cGet1 ) + '}'
	Local bBlc := &( cBlc )

	MemoWrite( '\system\bufexec.txt', cGet1 )

	Eval( bBlc )

Return