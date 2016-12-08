#INCLUDE 'RPTDEF.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWPRINTSETUP.CH'

User Function fPrintPDF()

	Local cFilePrint      := 'DPPR' + StrTran(Time(),':','') + '.PD_'
	Local lAdjustToLegacy := .F.
	Local cSpool          := '\spool\'
	Local lDisableSetup   := .T.
	Local lRaw            := .F.
	Local lViewPDF        := .F.
	Local oPrinter        := FWMSPrinter():New( cFilePrint, IMP_PDF, lAdjustToLegacy, cSpool, lDisableSetup,,,,,, lRaw, lViewPDF )
	Local nLinhas         := 43
	Local nPaginas        := 0
	Local oFont1          := TFont():New('Arial',,-7,,.F.)
	Local oFont2          := TFont():New('Arial',,-18,,.T.)
	Local oFont3          := TFont():New('Arial',,-12,,.T.)
	Local dDate           := Date()
	Local cDia            := PadL( cValTochar( Day( dDate ) ), 2, '0' )
	Local aMes            := Nil
	Local cAno            := cValTochar( Year( dDate ) )
	Local aMeses          := {}
	Local nX              := 0

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

	aMes := { PadL( cValToChar( Month( dDate ) ), 2, '0' ) , aMeses[ Month( dDate ) ] }

	oPrinter:SetFont(oFont1)

	oPrinter:StartPage()

	oPrinter:SayBitmap ( 010, 250, '\system\imagens\logo_io_166_68.png', 166/2, 068/2 )

	oPrinter:Say( 100, 050, 'São Paulo, ' +;
	cDia + ' de '  +;
	aMes[2] + ' de ' + cAno, oFont1 )

	oPrinter:Box( 130, 100, 230, 455, '-4' )

	oPrinter:Say( 145, 105, 'A(o)' )
	oPrinter:Say( 160, 105, SubStr( Upper( 'Cliente Nome Fulano de Tal Ltda' ), 1, 64 ), oFont1 )
	oPrinter:Say( 175, 105, SubStr( 'Rua Fulano de Tal Ltda, 9999', 1, 64 ), oFont1 )
	oPrinter:Say( 190, 105, SubStr( 'Bairro Fulano de Tal Ltda', 1, 64 ), oFont1 )
	oPrinter:Say( 205, 105, SubStr( 'CEP.: 99999-999', 1, 64 ), oFont1 )
	oPrinter:Say( 220, 105, SubStr( 'Cidade - UF', 1, 64 ), oFont1 )

	oPrinter:Say( 245, 400, '99.99.999.99', oFont1 )
	oPrinter:Say( 285, 050, 'DPPR..: 999999', oFont1 )

	oPrinter:Box( 320, 050, 350, 550, '-4' )
	oPrinter:Say( 340, 055, 'Assunto : Títulos Vencidos', oFont2 )

	oPrinter:Say( 385, 055, 'Prezados Senhores,', oFont1 )
	oPrinter:Say( 430, 055, 'Para informação e providências, estamos enviando relação de títulos vencidos, os quais deverão ser quitados', oFont1 )
	oPrinter:Say( 445, 055, 'através do boleto bancário, que em caso de extravio ou não recebimento, deverá ser observada a instrução', oFont1 )
	oPrinter:Say( 460, 055, 'mencionada na respectiva Nota Fiscal ou Fatura.', oFont1 )

	oPrinter:Say( 490, 055, 'Porventura, tenham sido pagos, pedimos desconsiderar este aviso e enviar os comprovantes via Fax (11) 2618-3609', oFont1 )
	oPrinter:Say( 505, 055, 'mencionando o número dos mesmos.', oFont1 )

	oPrinter:Say( 535, 055, 'Colocamo-nos à disposição através do telefone 0800-0123401, setor SAC', oFont1 )

	oPrinter:Say( 655, 055, 'Atenciosamente,', oFont1 )

	oPrinter:Say( 685, 055, 'IMPRENSA OFICIAL DO ESTADO S/A', oFont3 )
	oPrinter:Say( 700, 055, '48.066.047/0001-84', oFont3 )

	oPrinter:EndPage()

	oPrinter:StartPage()

	oPrinter:Say( 050, 050, 'Cliente: ' + Upper( 'Cliente Nome Fulano de Tal Ltda' ), oFont1 )
	oPrinter:Say( 050, 450, 'Referência: ' + cDia + '/' +  aMes[1] + '/' + cAno, oFont1 )
	oPrinter:Say( 065, 050, 'Tipo:      ' + Upper( '99 - Tipo do Cliente' ), oFont1 )

	oPrinter:Box( 080, 040, 120, 113, '-4' )
	oPrinter:SayAlign( 080, 040, 'Título', oFont1, 063, 040,, 2, 0 )

	oPrinter:Box( 080, 113, 120, 208, '-4' )
	oPrinter:SayAlign( 080, 113, 'Nosso Número', oFont1, 095, 040,, 2, 0 )

	oPrinter:Box( 080, 208, 120, 273, '-4' )
	oPrinter:SayAlign( 080, 208, 'Data da Emissão', oFont1, 065, 040,, 2, 0 )

	oPrinter:Box( 080, 273, 120, 340, '-4' )
	oPrinter:SayAlign( 080, 273, 'Data do Vencimento', oFont1, 067, 040,, 2, 0 )

	oPrinter:Box( 080, 340, 120, 403, '-4' )
	oPrinter:SayAlign( 080, 340, 'Valor', oFont1, 063, 040,, 2, 0 )

	/* Dias de Atraso */
	oPrinter:Box( 080, 403, 120, 435, '-4' )
	oPrinter:SayAlign( 080, 403, 'Dias de Atraso', oFont1, 030, 040,, 2, 0 )

	oPrinter:Box( 080, 435, 120, 500, '-4' )
	oPrinter:Box( 080, 500, 120, 570, '-4' )

	For nX := 1 To nLinhas

		oPrinter:Say( 120 + (15 * nX ), 045, '123456789/01', oFont1 )
		oPrinter:Say( 120 + (15 * nX ), 090, '123456789012345', oFont1 )
		oPrinter:Say( 120 + (15 * nX ), 150, cDia + '/' +  aMes[1] + '/' + cAno, oFont1 )
		oPrinter:Say( 120 + (15 * nX ), 190, cDia + '/' +  aMes[1] + '/' + cAno, oFont1 )
		//oPrinter:Say( 120 + (15 * nX ), 230, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont1 )
		oPrinter:SayAlign( 120 + (15 * nX + 1 ), 220, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont1, 070, 005,, 1, 0 )
		oPrinter:Say( 120 + (15 * nX ), 300, PadL( cValToChar( 0 ), 4, '0' ), oFont1 )
		oPrinter:Say( 120 + (15 * nX ), 320, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont1 )
		oPrinter:Say( 120 + (15 * nX ), 390, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont1 )

	Next nX

	oPrinter:Box( 125 + (15 * nX + 1 ), 040, 155 + (15 * nX + 1 ) , 570, '-4' )

	oPrinter:Say( 145 + (15 * nX + 1 ), 045, 'TOTAL GERAL :', oFont2 )

	oPrinter:SayAlign( 135 + (15 * nX + 1 ), 220, Transform(     999.99, '@E 9,999,999,999,999.99'), oFont1, 070, 020,, 1, 0 )
	oPrinter:SayAlign( 135 + (15 * nX + 1 ), 310, Transform( 1234567.12, '@E 9,999,999,999,999.99'), oFont1, 070, 020,, 1, 0 )
	oPrinter:SayAlign( 135 + (15 * nX + 1 ), 380, Transform( 1234567.12, '@E 9,999,999,999,999.99'), oFont1, 070, 020,, 1, 0 )

	File2Printer( cFilePrint, 'PDF' )
	oPrinter:cPathPDF:= cSpool
	oPrinter:Preview()

Return