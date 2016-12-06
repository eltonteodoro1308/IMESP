#INCLUDE 'RPTDEF.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE "FWPRINTSETUP.ch"

User Function fPrintPDF()

	Local cFilePrint      := 'DPPR' + StrTran(Time(),':','') + '.PD_'
	Local lAdjustToLegacy := .F.
	Local cSpool          := "\spool\"
	Local lDisableSetup   := .T.
	Local lRaw            := .F.
	Local lViewPDF        := .F.
	Local oPrinter        := FWMSPrinter():New( cFilePrint, IMP_PDF, lAdjustToLegacy, cSpool, lDisableSetup,,,,,, lRaw, lViewPDF )
	Local dDate           := Date()
	Local cDia            := PadL( cValTochar( Day( dDate ) ), 2, '0' )
	Local cMes            := ''
	Local cAno            := cValTochar( Year( dDate ) )
	Local aMeses          := {}

	aAdd( aMeses, 'Janeiro' )
	aAdd( aMeses, 'Fevereiro' )
	aAdd( aMeses, 'Março' )
	aAdd( aMeses, 'Abril' )
	aAdd( aMeses, 'Maio' )
	aAdd( aMeses, 'Junho' )
	aAdd( aMeses, 'Julho' )
	aAdd( aMeses, 'Agosto' )
	aAdd( aMeses, 'Setembro' )
	aAdd( aMeses, 'Outubro' )
	aAdd( aMeses, 'Novembro' )
	aAdd( aMeses, 'Dezembro' )

	cMes := aMeses[ Month( dDate ) ]

	//oPrinter:SetPortrait()
	//oPrinter:SetPaperSize( DMPAPER_A4 )
	//oPrinter:SetMargin(60,60,60,60)

	oPrinter:SayBitmap ( 010, 250, '\system\imagens\logo_io_166_68.png', 166/2, 068/2 )

	oPrinter:Say( 100, 050, 'São Paulo, ' +;
	cDia + ' de '  +;
	cMes + ' de ' + cAno )

	oPrinter:Box( 130, 100, 230, 450, "-4")

	oPrinter:Say( 145, 105, 'A(o)' )
	oPrinter:Say( 160, 105, SubStr( Upper( 'Cliente Nome Fulano de Tal Ltda' ), 1, 64 ) )
	oPrinter:Say( 175, 105, SubStr( 'Rua Fulano de Tal Ltda, 9999', 1, 64 ) )
	oPrinter:Say( 190, 105, SubStr( 'Bairro Fulano de Tal Ltda', 1, 64 ) )
	oPrinter:Say( 205, 105, SubStr( 'CEP.: 99999-999', 1, 64 ) )
	oPrinter:Say( 220, 105, SubStr( 'Cidade - UF', 1, 64 ) )

	oPrinter:Say( 245, 400, '99.99.999.99' )
	oPrinter:Say( 300, 050, 'DPPR..: 999999' )

	oPrinter:Box( 320, 050, 350, 550, "-4")
	oPrinter:Say( 340, 055, 'Assunto : Títulos Vencidos', TFont():New( "Courier New", , -18, .T.) )

	oPrinter:Say( 385, 055, '012345678901234567890123456789',,15 )
	oPrinter:Say( 400, 055, '012345678901234567890123456789',,15 )

	File2Printer( cFilePrint, 'PDF' )
	oPrinter:cPathPDF:= cSpool
	oPrinter:Preview()

Return