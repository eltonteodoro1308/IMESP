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
	Local nNumTit         := 100
	//Local nLinhas         := 45
	//Local nPaginas        := Int( nNumTit/nLinhas )
	//Local nResto          := Mod( nNumTit, nLinhas )
	Local nCount          := 0
	Local oFont08         := TFont():New('Arial',,-08,,.F.)
	Local oFont18N        := TFont():New('Arial',,-18,,.T.)
	Local oFont12         := TFont():New('Arial',,-12,,.F.)
	Local oFont12N        := TFont():New('Arial',,-12,,.T.)
	Local dDate           := Date()
	Local cDia            := PadL( cValTochar( Day( dDate ) ), 2, '0' )
	Local aMes            := Nil
	Local cAno            := cValTochar( Year( dDate ) )
	Local aMeses          := {}
	Local nX              := 0

	aAdd( aMeses, 'Janeiro' )
	aAdd( aMeses, 'Fevereiro' )
	aAdd( aMeses, 'Mar�o' )
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

	oPrinter:SetFont(oFont12)

	oPrinter:StartPage()

	oPrinter:SayBitmap ( 010, 250, '\system\imagens\logo_io_166_68.png', 166/2, 068/2 )

	oPrinter:Say( 100, 050, 'S�o Paulo, ' +;
	cDia + ' de '  +;
	aMes[2] + ' de ' + cAno, oFont12 )

	oPrinter:Box( 130, 100, 230, 455, '-4' )

	oPrinter:Say( 145, 105, 'A(o)' )
	oPrinter:Say( 160, 105, SubStr( Upper( 'Cliente Nome Fulano de Tal Ltda' ), 1, 64 ), oFont12 )
	oPrinter:Say( 175, 105, SubStr( 'Rua Fulano de Tal Ltda, 9999', 1, 64 ), oFont12 )
	oPrinter:Say( 190, 105, SubStr( 'Bairro Fulano de Tal Ltda', 1, 64 ), oFont12 )
	oPrinter:Say( 205, 105, SubStr( 'CEP.: 99999-999', 1, 64 ), oFont12 )
	oPrinter:Say( 220, 105, SubStr( 'Cidade - UF', 1, 64 ), oFont12 )

	oPrinter:Say( 245, 400, '99.99.999.99', oFont12 )
	oPrinter:Say( 285, 050, 'DPPR..: 999999', oFont12 )

	oPrinter:Box( 320, 050, 350, 550, '-4' )
	oPrinter:Say( 340, 055, 'Assunto : T�tulos Vencidos', oFont18N )

	oPrinter:Say( 385, 055, 'Prezados Senhores,', oFont12 )
	oPrinter:Say( 430, 055, 'Para informa��o e provid�ncias, estamos enviando rela��o de t�tulos vencidos, os quais dever�o ser quitados', oFont12 )
	oPrinter:Say( 445, 055, 'atrav�s do boleto banc�rio, que em caso de extravio ou n�o recebimento, dever� ser observada a instru��o', oFont12 )
	oPrinter:Say( 460, 055, 'mencionada na respectiva Nota Fiscal ou Fatura.', oFont12 )

	oPrinter:Say( 490, 055, 'Porventura, tenham sido pagos, pedimos desconsiderar este aviso e enviar os comprovantes via Fax (11) 2618-3609', oFont12 )
	oPrinter:Say( 505, 055, 'mencionando o n�mero dos mesmos.', oFont12 )

	oPrinter:Say( 535, 055, 'Colocamo-nos � disposi��o atrav�s do telefone 0800-0123401, setor SAC', oFont12 )

	oPrinter:Say( 655, 055, 'Atenciosamente,', oFont12 )

	oPrinter:Say( 685, 055, 'IMPRENSA OFICIAL DO ESTADO S/A', oFont12N )
	oPrinter:Say( 700, 055, '48.066.047/0001-84', oFont12N )

	oPrinter:EndPage()


	/*

	oPrinter:StartPage()

	ImprimeCabecalho()

	For nX := 1 To nNumTit

		ImprimeTitulo()

		If ++nCount == 45 .And. nX != nNumTit

			ImprimeSubTotal()

			oPrinter:EndPage()

			oPrinter:StartPage()

			ImprimeCabecalho()

			nCount := 0

		ElseIf nX == nNumTit

			ImprimeTotal()

		End If

	Next nX


	*/

	oPrinter:StartPage()

	// Imprime Cabecalho
	oPrinter:Say( 050, 030, 'Cliente: ' + Upper( 'Cliente Nome Fulano de Tal Ltda' ), oFont12 )
	oPrinter:Say( 050, 450, 'Refer�ncia: ' + cDia + '/' +  aMes[1] + '/' + cAno, oFont12 )
	oPrinter:Say( 065, 030, 'Tipo:      ' + Upper( '99 - Tipo do Cliente' ), oFont12 )

	oPrinter:Box( 080, 025, 100, 080, '-4' )
	oPrinter:SayAlign( 080, 025, 'T�tulo', oFont08, 055, 020,, 2, 0 )

	oPrinter:Box( 080, 080, 100, 150, '-4' )
	oPrinter:SayAlign( 080, 080, 'Nosso N�mero', oFont08, 070, 020,, 2, 0 )

	oPrinter:Box( 080, 150, 100, 195, '-4' )
	oPrinter:SayAlign( 080, 150, 'Data da Emiss�o', oFont08, 045, 020,, 2, 0 )

	oPrinter:Box( 080, 195, 100, 240, '-4' )
	oPrinter:SayAlign( 080, 195, 'Data do Vencimento', oFont08, 045, 020,, 2, 0 )

	oPrinter:Box( 080, 240, 100, 320, '-4' )
	oPrinter:SayAlign( 080, 240, 'Valor', oFont08, 080, 020,, 2, 0 )

	oPrinter:Box( 080, 320, 100, 347, '-4' )
	oPrinter:SayAlign( 080, 320, 'Dias de Atraso', oFont08, 027, 020,, 2, 0 )

	oPrinter:Box( 080, 347, 100, 422, '-4' )
	oPrinter:SayAlign( 080, 347, 'Juros Di�rios 0,0333%', oFont08, 070, 020,, 2, 0 )

	oPrinter:Box( 080, 422, 100, 500, '-4' )
	oPrinter:SayAlign( 080, 422, 'Multa Ap�s Vencimento 2,0%', oFont08, 075, 020,, 2, 0 )

	oPrinter:Box( 080, 500, 100, 585, '-4' )
	oPrinter:SayAlign( 080, 500, 'Valor Atualizado � Pagar', oFont08, 070, 020,, 2, 0 )

	// Imprime T�tulos
	For nX := 1 To nLinhas

		oPrinter:SayAlign( 095 + (15 * nX ), 030, '123456789/01', oFont08, 070, 005,, 0, 0 )
		oPrinter:SayAlign( 095 + (15 * nX ), 085, '123456789012345', oFont08, 070, 005,, 0, 0 )
		oPrinter:SayAlign( 095 + (15 * nX ), 155, cDia + '/' +  aMes[1] + '/' + cAno, oFont08, 070, 005,, 0, 0 )
		oPrinter:SayAlign( 095 + (15 * nX ), 200, cDia + '/' +  aMes[1] + '/' + cAno, oFont08, 070, 005,, 0, 0  )
		oPrinter:SayAlign( 095 + (15 * nX ), 240, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 005,, 1, 0 )
		oPrinter:SayAlign( 095 + (15 * nX ), 265, PadL( cValToChar( nX ), 4, '0' ), oFont08, 075, 005,, 1, 0 )
		oPrinter:SayAlign( 095 + (15 * nX ), 345, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 005,, 1, 0 )
		oPrinter:SayAlign( 095 + (15 * nX ), 420, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 005,, 1, 0 )
		oPrinter:SayAlign( 095 + (15 * nX ), 500, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 005,, 1, 0 )

	Next nX

	// Imprime Rodap�
	oPrinter:Box( 100 + (15 * nX + 1 ), 025, 135 + (15 * nX + 1 ) , 585, '-4' )

	oPrinter:Say( 125 + (15 * nX + 1 ), 045, 'TOTAL GERAL :', oFont18N )

	oPrinter:SayAlign( 115 + (15 * nX + 1 ), 240, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 020,, 1, 0 )
	oPrinter:SayAlign( 115 + (15 * nX + 1 ), 345, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 020,, 1, 0 )
	oPrinter:SayAlign( 115 + (15 * nX + 1 ), 420, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 020,, 1, 0 )
	oPrinter:SayAlign( 115 + (15 * nX + 1 ), 500, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 020,, 1, 0 )

	File2Printer( cFilePrint, 'PDF' )
	oPrinter:cPathPDF:= cSpool
	oPrinter:Preview()

Return