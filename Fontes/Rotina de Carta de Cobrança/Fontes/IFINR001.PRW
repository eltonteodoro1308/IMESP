#INCLUDE 'RPTDEF.CH'
#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IFINR001
User Function que gera em pdf a carta de cobran�a
@author Elton Teodoro Alves
@since 19/12/2016
@version 12.1.007
@param aCliente, array, Array com dados do cliente
@param aTitulos, array, Array com dados dos t�tulos
@return return, Nome e caminho do arquivo gerado
/*/
User Function IFINR001( aCliente, aTitulos )

	Local cNUMCOBR        := GetMv( 'MV_NUMCOBR' ) // Numera��o DPPR
	Local cFilePrint      := 'DPPR' + cNUMCOBR + '.PD_'
	Local lAdjustToLegacy := .F.
	Local cSpool          := '\spool\'
	Local lDisableSetup   := .T.
	Local lRaw            := .F.
	Local lViewPDF        := .F.
	Local nCount          := 0
	Local aMeses          := {}
	Local nX              := 0

	Private oPrinter   := Nil
	Private oFont08    := TFont():New('Arial',,-08,,.F.)
	Private oFont18N   := TFont():New('Arial',,-18,,.T.)
	Private oFont12    := TFont():New('Arial',,-12,,.F.)
	Private oFont12N   := TFont():New('Arial',,-12,,.T.)
	Private cDia       := PadL( cValTochar( Day( dDate ) ), 2, '0' )
	Private cAno       := cValTochar( Year( dDate ) )
	Private nNumTit    := Len( aTitulos )
	Private nPaginas   := Int( nNumTit/045 ) + If( Mod( nNumTit, 045 ) # 0, 1, 0 ) + 001
	Private nPagina    := 1
	Private nSumTitulo := 0
	Private nSumMulta  := 0
	Private nSumJuros  := 0
	Private nSumTotal  := 0
	Private nPosTitulo := 1

	If ! ExistDir( cSpool )

		MakeDir( cSpool )

	End If

	oPrinter := FWMSPrinter():New( cFilePrint, IMP_PDF, lAdjustToLegacy, cSpool, lDisableSetup,,,,,, lRaw, lViewPDF )

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

	oPrinter:SetFont(oFont12)

	oPrinter:StartPage()

	oPrinter:SayBitmap ( 010, 250, '\system\imagens\logo_io_166_68.png', 166/2, 068/2 )

	oPrinter:Say( 100, 050, 'S�o Paulo, ' +;
	cDia + ' de '  +;
	aMeses[ Month( dDate ) ] + ' de ' + cAno, oFont12 )

	oPrinter:Box( 130, 100, 230, 455, '-4' )

	oPrinter:Say( 145, 105, 'A(o)' )
	oPrinter:Say( 160, 105, Upper( AllTrim( aCliente[03] ) ), oFont12 )
	oPrinter:Say( 175, 105, AllTrim( aCliente[04] ), oFont12 )
	oPrinter:Say( 190, 105, AllTrim( aCliente[05] ), oFont12 )
	oPrinter:Say( 205, 105, 'CEP.: ' + AllTrim( aCliente[05] ) , oFont12 )
	oPrinter:Say( 220, 105, AllTrim( aCliente[07] ) + ' - ' + AllTrim( aCliente[08] ), oFont12 )

	oPrinter:Say( 245, 400, AllTrim( aCliente[01] ), oFont12 )
	oPrinter:Say( 285, 050, 'DPPR..: ' + cNUMCOBR, oFont12 )

	PUTMV( 'MV_NUMCOBR',  If( AllTrim( cNUMCOBR ) == '999999', '000001', PadL( Val(cNUMCOBR) + 1, 6, '0' ) ) )

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

	oPrinter:Say( 685, 055, AllTrim( SM0->M0_NOMECOM ), oFont12N )
	oPrinter:Say( 700, 055, Transform( SM0->M0_CGC, '@R 99.999.999/9999-99' ), oFont12N )

	oPrinter:Say( 830, 250, 'P�gina ' + PadL( nPagina, 3, '0' ) + '/' + PadL( nPaginas, 3, '0' ), oFont08 )

	oPrinter:EndPage()

	oPrinter:StartPage()

	ImpCabec( aCliente )

	For nX := 1 To nNumTit

		ImpTitulo( ++nCount, aCliente, aTitulos )

		If nCount == 45 .And. nX != nNumTit

			ImpRodaPe( nCount, 'Sub-Total:' )

			oPrinter:EndPage()

			oPrinter:StartPage()

			ImpCabec( aCliente )

			nCount := 0

		ElseIf nX == nNumTit

			ImpRodaPe( nCount, 'Total Geral:' )

		End If

	Next nX

	File2Printer( cFilePrint, 'PDF' )
	oPrinter:cPathPDF:= cSpool
	oPrinter:Preview()

Return cSpool + cFilePrint
/*/{Protheus.doc} ImpCabec
Static Function que imprime o cabe�alho da p�gina com os dados dos t�tulos
@author Elton Teodoro Alves
@since 19/12/2016
@version 12.1.007
@param aCliente, array, Array com os dados do cliente
/*/
Static Function ImpCabec( aCliente )

	oPrinter:Say( 050, 030, 'Cliente: ' + Upper( AllTrim( aCliente[03] ) ), oFont12 )
	oPrinter:Say( 050, 450, 'Refer�ncia: ' + DtoC( dDate ), oFont12 )
	oPrinter:Say( 065, 030, 'Tipo:      ' + Upper( aCliente[10] + ' - ' + aCliente[11] ), oFont12 )

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

Return
/*/{Protheus.doc} ImpTitulo
Static Functions que imprime os dados do t�tulo em uma linha no relat�rio
@author Elton Teodoro Alves
@since 19/12/2016
@version 12.1.007
@param nCount, numeric, Contador do t�tulo na p�gina para incremento de p�gina
@param aCliente, array, Array com os dados do cliente
@param aTitulos, array, Array com os dados do t�tulo
/*/
Static Function ImpTitulo( nCount, aCliente, aTitulos )

	Local aArea := GetArea()

	oPrinter:SayAlign( 095 + (15 * nCount ), 030, AllTrim( aTitulos[ nPosTitulo, 015 ] ) + '/' + AllTrim( aTitulos[ nPosTitulo, 016 ] ), oFont08, 070, 005,, 0, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 085, AllTrim( aTitulos[ nPosTitulo, 018 ] ), oFont08, 070, 005,, 0, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 155, DtoC( Stod( aTitulos[ nPosTitulo, 019 ] ) ), oFont08, 070, 005,, 0, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 200, DtoC( Stod( aTitulos[ nPosTitulo, 020 ] ) ), oFont08, 070, 005,, 0, 0  )
	oPrinter:SayAlign( 095 + (15 * nCount ), 240, TransForm( aTitulos[ nPosTitulo, 021 ], cPicture ), oFont08, 075, 005,, 1, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 265, PadL( cValToChar( aTitulos[ nPosTitulo, 022 ] ), 4, '0' ), oFont08, 075, 005,, 1, 0 )
	//TODO Verificar C�lculo Multa e Juros
	oPrinter:SayAlign( 095 + (15 * nCount ), 345, TransForm( 0, cPicture ), oFont08, 075, 005,, 1, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 420, TransForm( 0, cPicture ), oFont08, 075, 005,, 1, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 500, TransForm( aTitulos[ nPosTitulo, 021 ], cPicture ), oFont08, 075, 005,, 1, 0 )

	If ChkFile( 'SZA' )

		DbSelectArea( 'SZA' )

		If RecLock( 'SZA', .T. )

			SZA->ZA_FILIAL  := xFilial( 'SZA' )
			SZA->ZA_CLIENTE := aCliente[001]
			SZA->ZA_LOJA    := aCliente[002]
			SZA->ZA_NOME    := aCliente[003]
			SZA->ZA_PREFIXO := aTitulos[ nPosTitulo, 014 ]
			SZA->ZA_NUM     := aTitulos[ nPosTitulo, 015 ]
			SZA->ZA_PARCELA := aTitulos[ nPosTitulo, 016 ]
			SZA->ZA_TIPO    := aTitulos[ nPosTitulo, 017 ]
			SZA->ZA_EMISSAO := StoD( aTitulos[ nPosTitulo, 019 ] )
			SZA->ZA_VENCTO  := StoD( aTitulos[ nPosTitulo, 020 ] )
			SZA->ZA_VALOR   := aTitulos[ nPosTitulo, 021 ]
			SZA->ZA_DATA    := dDate
			SZA->ZA_EMAIL   := aCliente[009]

			MsUnlock()

		End If

	End If

	DbSelectArea( 'SE1' )

	DbGoto( aTitulos[ nPosTitulo, 023 ] )

	If RecLock( 'SE1', .F. )

		SE1->E1_XDTUCBR := dDate

		MsUnlock()

	End If

	RestArea( aArea )

	//TODO Verificar C�lculo Multa e Juros
	nSumTitulo += aTitulos[ nPosTitulo, 021 ]
	nSumMulta  += 0
	nSumJuros  += 0
	nSumTotal  += aTitulos[ nPosTitulo, 021 ]

	nPosTitulo++

Return
/*/{Protheus.doc} ImpRodaPe
Static Function que imprime o rodap� do relat�rio com os totais
@author Elton Teodoro Alves
@since 19/12/2016
@version 12.1.007
@param nCount, numeric, Contador para indicar a posi��o do rodap�
@param cTotal, characters, Indica de imprime "Total" ou "Sub-Total"
/*/
Static Function ImpRodaPe( nCount, cTotal )

	oPrinter:Box( 110 + (15 * nCount + 1 ), 025, 135 + (15 * nCount + 1 ) , 585, '-4' )

	oPrinter:Say( 127 + (15 * nCount + 1 ), 045, cTotal, oFont18N )

	oPrinter:SayAlign( 117 + (15 * nCount + 1 ), 240, Transform( nSumTitulo, cPicture ), oFont08, 075, 020,, 1, 0 )
	oPrinter:SayAlign( 117 + (15 * nCount + 1 ), 345, Transform( nSumMulta , cPicture ), oFont08, 075, 020,, 1, 0 )
	oPrinter:SayAlign( 117 + (15 * nCount + 1 ), 420, Transform( nSumJuros , cPicture ), oFont08, 075, 020,, 1, 0 )
	oPrinter:SayAlign( 117 + (15 * nCount + 1 ), 500, Transform( nSumTotal , cPicture ), oFont08, 075, 020,, 1, 0 )

	oPrinter:Say( 830, 250, 'P�gina ' + PadL( ++nPagina, 3, '0' ) + '/' + PadL( nPaginas, 3, '0' ), oFont08 )

Return