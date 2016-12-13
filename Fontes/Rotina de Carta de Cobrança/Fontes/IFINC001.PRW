#INCLUDE 'RPTDEF.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWPRINTSETUP.CH'
#INCLUDE 'FWMVCDEF.CH'

Static oPrinter := Nil
Static oFont08  := TFont():New('Arial',,-08,,.F.)
Static oFont18N := TFont():New('Arial',,-18,,.T.)
Static oFont12  := TFont():New('Arial',,-12,,.F.)
Static oFont12N := TFont():New('Arial',,-12,,.T.)
Static dDate    := Date()
Static cDia     := PadL( cValTochar( Day( dDate ) ), 2, '0' )
Static aMes     := Nil
Static cAno     := cValTochar( Year( dDate ) )
Static nNumTit  := 150
Static nPaginas := Int( nNumTit/045 ) + If( Mod( nNumTit, 045 ) # 0, 1, 0 ) + 001
Static nPagina  := 1
Static aCliente  := {}
Static aTitulos  := {}
Static aDados    := {}

User Function IFINC001()

	Local   oBrowse := FWMBrowse():New()
	Private aRotina := { { 'Enviar Carta de Cobrança', 'U_SE1IFC01( SA1->A1_COD, SA1->A1_LOJA )', 0, 6, 0, Nil, Nil, Nil } }
	Private cCadastro := ''

	oBrowse:SetAlias('SA1')
	oBrowse:SetFilterDefault( 'U_SA1IFC01()' )
	oBrowse:SetDescription('Clientes com Títulos em Atraso')
	oBrowse:SetOnlyFields( { 'A1_COD', 'A1_LOJA', 'A1_NOME', 'A1_EMAIL' } )
	oBrowse:DisableReport()
	oBrowse:DisableDetails()
	oBrowse:SetExecuteDef(1)
	oBrowse:Activate()

Return

//------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------

User Function SE1IFC01( cCliente, cLoja)

	Local cAliasTRB := GetNextAlias()
	Local aArea     := GetArea()
	Local cDate     := DtoS( Date() )
	Local oSize     := FwDefSize():New(.T.)
	Local oDlg      := Nil
	Local oList     := Nil
	Local aList     := {}
	Local oNO       := LoadBitmap( GetResources(),'LBNO')
	Local oOK       := LoadBitmap( GetResources(),'LBOK')
	Local aAcoes    := {}
	Local nMulta    := 0
	Local nJuros    := 0

	BeginSql Alias cAliasTRB

	SELECT E1_FILIAL, E1_PREFIXO,E1_NUM,E1_PARCELA,E1_NUMBCO,E1_EMISSAO,E1_VENCTO,E1_SALDO,
	DATEDIFF( DAY, CONVERT( DATETIME, E1_VENCTO ), CONVERT( DATETIME, %Exp:cDate% ) ) E1_ATRASO,
	E1_PORCJUR, E1_VALJUR
	FROM %Table:SE1% SE1
	WHERE DATEDIFF( DAY, CONVERT( DATETIME, SE1.E1_XULTCBR ), CONVERT( DATETIME, %Exp:cDate% ) ) >= 3
	AND SE1.E1_FILIAL = %xFilial:SN1%
	AND SE1.E1_VENCTO < %Exp:cDate%
	AND SE1.E1_CLIENTE = %Exp:cCliente%
	AND SE1.E1_LOJA = %Exp:cLoja%
	AND SE1.E1_SALDO > 0
	AND SE1.%NotDel%

	EndSql

	(cAliasTRB)->(DbGoTop())

	Do While (cAliasTRB)->(!EOF())

		//TODO Definir com deve calcular multa e juros.
		nMulta := 0
		nJuros := 0

		aAdd( aList, (cAliasTRB)->( { .F., E1_FILIAL, E1_PREFIXO,;
		Transform(  E1_NUM, GetSx3Cache( 'E1_NUM', 'X3_PICTURE' ) ),;
		E1_PARCELA, E1_NUMBCO, StoD( E1_EMISSAO ), StoD( E1_VENCTO ),;
		Transform(  E1_SALDO, GetSx3Cache( 'E1_SALDO', 'X3_PICTURE' ) ),;
		E1_ATRASO,;
		Transform(  nJuros, GetSx3Cache( 'E1_SALDO', 'X3_PICTURE' ) ),;
		Transform(  nMulta, GetSx3Cache( 'E1_SALDO' , 'X3_PICTURE' ) ),;
		Transform( ( E1_SALDO + nJuros + nMulta ), GetSx3Cache( 'E1_SALDO', 'X3_PICTURE' ) ) } ) )

		(cAliasTRB)->( DbSkip() )

	End Do

	oSize:AddObject( "LISTA", 000, 000, .T., .T. )

	oSize:Process()

	DEFINE DIALOG oDlg TITLE 'Títulos em Atraso' FROM;
	oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL

	@oSize:GetDimension("LISTA","LININI"), oSize:GetDimension("LISTA","COLINI");
	LISTBOX oList Fields HEADER '';
	SIZE oSize:GetDimension("LISTA","COLEND"), oSize:GetDimension("LISTA","LINEND")-030 OF oDlg PIXEL

	oList:aHeaders := { '', 'Filial', 'Prefixo', 'Título', 'Parcela', 'Nosso Numero', 'Data da Emissão', 'Data do Vencimento','Valor',;
	'Dias em Atraso', 'Juros Diários', 'Multa Após o Vencimento', 'Valor Atualizado a Pagar', }

	oList:SetArray( aList )

	oList:bLine := {|| {;
	If( aList[oList:nAt,01], oOK, oNO ),;
	aList[oList:nAt,02],;
	aList[oList:nAt,03],;
	aList[oList:nAt,04],;
	aList[oList:nAt,05],;
	aList[oList:nAt,06],;
	aList[oList:nAt,07],;
	aList[oList:nAt,08],;
	aList[oList:nAt,09],;
	aList[oList:nAt,10],;
	aList[oList:nAt,11],;
	aList[oList:nAt,12],;
	aList[oList:nAt,13]}}

	oList:bLDblClick   := { || aList[oList:nAt,01] := !aList[oList:nAt,01], oList:DrawSelect() }
	oList:bHeaderClick := { |oList, nCol| InvertSel( oList, nCol, @aList ) }

	EnchoiceBar( oDlg, {|| Envia()}, {||oDlg:End()},,,,,.F.,.F.,.F.,.T.,.F. )

	ACTIVATE DIALOG oDlg CENTERED

	(cAliasTRB)->(DbCloseArea())

	RestArea( aArea )

Return
//------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------

User Function SA1IFC01()

	Local lRet     := .F.
	Local cDate    := DtoS( Date() )
	Local aArea    := GetArea()
	Local cAliasTRB   := GetNextAlias()
	Local cCliente := A1_COD
	Local cLoja    := A1_LOJA

	BeginSql Alias cAliasTRB

	SELECT Count(*) Count
	FROM %Table:SE1% SE1
	WHERE DATEDIFF( DAY, CONVERT( DATETIME, SE1.E1_XULTCBR ), CONVERT( DATETIME, %Exp:cDate% ) ) >= 3
	AND SE1.E1_FILIAL = %xFilial:SN1%
	AND SE1.E1_VENCTO < %Exp:cDate%
	AND SE1.E1_CLIENTE = %Exp:cCliente%
	AND SE1.E1_LOJA = %Exp:cLoja%
	AND SE1.E1_SALDO > 0
	AND SE1.%NotDel%

	EndSql

	lRet := ( cAliasTRB )->Count > 0

	(cAliasTRB)->(DbCloseArea())

	RestArea( aArea )

Return lRet
//------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------

Static Function InvertSel( oList, nCol, aList )

	If nCol == 1

		aEval( aList, {|X| X[1] := ! X[1] } )

		oList:Refresh()

	End IF

Return


Static Function Envia()

	MsgRun( CapitalAce("Gerando Relatório ..."), CapitalAce("Aguarde ..."), { || GeraPDF() } )

Return

Static Function GeraPDF( aDados )

	Local cFilePrint      := 'DPPR' + StrTran(Time(),':','') + '.PD_'
	Local lAdjustToLegacy := .F.
	Local cSpool          := '\spool\'
	Local lDisableSetup   := .T.
	Local lRaw            := .F.
	Local lViewPDF        := .F.
	Local nCount          := 0
	Local aMeses          := {}
	Local nX              := 0

	oPrinter := FWMSPrinter():New( cFilePrint, IMP_PDF, lAdjustToLegacy, cSpool, lDisableSetup,,,,,, lRaw, lViewPDF )

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

	oPrinter:SetFont(oFont12)

	oPrinter:StartPage()

	oPrinter:SayBitmap ( 010, 250, '\system\imagens\logo_io_166_68.png', 166/2, 068/2 )

	oPrinter:Say( 100, 050, 'São Paulo, ' +;
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
	oPrinter:Say( 340, 055, 'Assunto : Títulos Vencidos', oFont18N )

	oPrinter:Say( 385, 055, 'Prezados Senhores,', oFont12 )
	oPrinter:Say( 430, 055, 'Para informação e providências, estamos enviando relação de títulos vencidos, os quais deverão ser quitados', oFont12 )
	oPrinter:Say( 445, 055, 'através do boleto bancário, que em caso de extravio ou não recebimento, deverá ser observada a instrução', oFont12 )
	oPrinter:Say( 460, 055, 'mencionada na respectiva Nota Fiscal ou Fatura.', oFont12 )

	oPrinter:Say( 490, 055, 'Porventura, tenham sido pagos, pedimos desconsiderar este aviso e enviar os comprovantes via Fax (11) 2618-3609', oFont12 )
	oPrinter:Say( 505, 055, 'mencionando o número dos mesmos.', oFont12 )

	oPrinter:Say( 535, 055, 'Colocamo-nos à disposição através do telefone 0800-0123401, setor SAC', oFont12 )

	oPrinter:Say( 655, 055, 'Atenciosamente,', oFont12 )

	oPrinter:Say( 685, 055, 'IMPRENSA OFICIAL DO ESTADO S/A', oFont12N )
	oPrinter:Say( 700, 055, '48.066.047/0001-84', oFont12N )

	oPrinter:Say( 830, 250, 'Página ' + PadL( nPagina, 3, '0' ) + '/' + PadL( nPaginas, 3, '0' ), oFont08 )

	oPrinter:EndPage()

	oPrinter:StartPage()

	ImpCabec()

	For nX := 1 To nNumTit

		ImpTitulo( ++nCount )

		If nCount == 45 .And. nX != nNumTit

			ImpRodaPe( nCount, 'Sub-Total:' )

			oPrinter:EndPage()

			oPrinter:StartPage()

			ImpCabec()

			nCount := 0

		ElseIf nX == nNumTit

			ImpRodaPe( nCount, 'Total Geral:' )

		End If

	Next nX

	File2Printer( cFilePrint, 'PDF' )
	oPrinter:cPathPDF:= cSpool
	oPrinter:Preview()

Return

Static Function ImpCabec()

	oPrinter:Say( 050, 030, 'Cliente: ' + Upper( 'Cliente Nome Fulano de Tal Ltda' ), oFont12 )
	oPrinter:Say( 050, 450, 'Referência: ' + cDia + '/' +  aMes[1] + '/' + cAno, oFont12 )
	oPrinter:Say( 065, 030, 'Tipo:      ' + Upper( '99 - Tipo do Cliente' ), oFont12 )

	oPrinter:Box( 080, 025, 100, 080, '-4' )
	oPrinter:SayAlign( 080, 025, 'Título', oFont08, 055, 020,, 2, 0 )

	oPrinter:Box( 080, 080, 100, 150, '-4' )
	oPrinter:SayAlign( 080, 080, 'Nosso Número', oFont08, 070, 020,, 2, 0 )

	oPrinter:Box( 080, 150, 100, 195, '-4' )
	oPrinter:SayAlign( 080, 150, 'Data da Emissão', oFont08, 045, 020,, 2, 0 )

	oPrinter:Box( 080, 195, 100, 240, '-4' )
	oPrinter:SayAlign( 080, 195, 'Data do Vencimento', oFont08, 045, 020,, 2, 0 )

	oPrinter:Box( 080, 240, 100, 320, '-4' )
	oPrinter:SayAlign( 080, 240, 'Valor', oFont08, 080, 020,, 2, 0 )

	oPrinter:Box( 080, 320, 100, 347, '-4' )
	oPrinter:SayAlign( 080, 320, 'Dias de Atraso', oFont08, 027, 020,, 2, 0 )

	oPrinter:Box( 080, 347, 100, 422, '-4' )
	oPrinter:SayAlign( 080, 347, 'Juros Diários 0,0333%', oFont08, 070, 020,, 2, 0 )

	oPrinter:Box( 080, 422, 100, 500, '-4' )
	oPrinter:SayAlign( 080, 422, 'Multa Após Vencimento 2,0%', oFont08, 075, 020,, 2, 0 )

	oPrinter:Box( 080, 500, 100, 585, '-4' )
	oPrinter:SayAlign( 080, 500, 'Valor Atualizado à Pagar', oFont08, 070, 020,, 2, 0 )

Return

Static Function ImpTitulo( nCount )

	oPrinter:SayAlign( 095 + (15 * nCount ), 030, '123456789/01', oFont08, 070, 005,, 0, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 085, '123456789012345', oFont08, 070, 005,, 0, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 155, cDia + '/' +  aMes[1] + '/' + cAno, oFont08, 070, 005,, 0, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 200, cDia + '/' +  aMes[1] + '/' + cAno, oFont08, 070, 005,, 0, 0  )
	oPrinter:SayAlign( 095 + (15 * nCount ), 240, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 005,, 1, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 265, PadL( cValToChar( nCount ), 4, '0' ), oFont08, 075, 005,, 1, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 345, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 005,, 1, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 420, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 005,, 1, 0 )
	oPrinter:SayAlign( 095 + (15 * nCount ), 500, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 005,, 1, 0 )

Return

Static Function ImpRodaPe( nCount, cTotal )

	oPrinter:Box( 110 + (15 * nCount + 1 ), 025, 135 + (15 * nCount + 1 ) , 585, '-4' )

	oPrinter:Say( 127 + (15 * nCount + 1 ), 045, cTotal, oFont18N )

	oPrinter:SayAlign( 117 + (15 * nCount + 1 ), 240, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 020,, 1, 0 )
	oPrinter:SayAlign( 117 + (15 * nCount + 1 ), 345, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 020,, 1, 0 )
	oPrinter:SayAlign( 117 + (15 * nCount + 1 ), 420, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 020,, 1, 0 )
	oPrinter:SayAlign( 117 + (15 * nCount + 1 ), 500, Transform( 9999999999999.99, '@E 9,999,999,999,999.99'), oFont08, 075, 020,, 1, 0 )

	oPrinter:Say( 830, 250, 'Página ' + PadL( ++nPagina, 3, '0' ) + '/' + PadL( nPaginas, 3, '0' ), oFont08 )

Return