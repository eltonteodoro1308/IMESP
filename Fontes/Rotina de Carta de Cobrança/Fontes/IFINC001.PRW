#INCLUDE 'RPTDEF.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWPRINTSETUP.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function IFINC001()

	Local oDlg       := Nil
	Local oList      := Nil
	Local aList      := {}
	Local aBuffer    := {}
	Local oNO        := LoadBitmap( GetResources(),'LBNO')
	Local oOK        := LoadBitmap( GetResources(),'LBOK')
	Local oSize      := FwDefSize():New(.T.)
	Local aArea      := GetArea()
	Local cAliasTRB  := GetNextAlias()
	Local oTMultiBtn := Nil
	Local nX         := 0
	Local cBcode     := ''
	Local aBcode     := {}

	Private dDate     := Date()
	Private cDate     := DtoS( dDate )
	Private cCadastro := 'Carta de Cobrança'
	Private nDCRTCBR  := GetMv( 'MV_DCRTCBR' ) // Dias Carta de Cobrança
	Private cMSGCOBR  := GetMv( 'MV_MSGCOBR' ) // Mensagem Email de Cobrança
	Private cPicture  := AllTrim( GetSx3Cache( 'E1_SALDO', 'X3_PICTURE' ) )

	BeginSql Alias cAliasTRB

	SELECT

	SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_END, SA1.A1_BAIRRO,
	SA1.A1_CEP, SA1.A1_MUN, SA1.A1_EST, SA1.A1_EMAIL, SA1.A1_GRPVEN,
	(SELECT TOP 1 ACY.ACY_DESCRI FROM %Table:ACY% ACY WHERE ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.%NotDel%) ACY_DESCRI,

	SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO,
	SE1.E1_NUMBCO, SE1.E1_EMISSAO, SE1.E1_VENCTO, SE1.E1_SALDO,
	DATEDIFF( DAY, CONVERT( DATETIME, SE1.E1_VENCTO ), CONVERT( DATETIME, %Exp:cDate% ) ) E1_ATRASO,
	SE1.R_E_C_N_O_

	FROM %Table:SE1% SE1

	LEFT JOIN %Table:SA1% SA1
	ON  SA1.A1_COD  = SE1.E1_CLIENTE
	AND SA1.A1_LOJA = SE1.E1_LOJA
	AND SA1.%NotDel%

	WHERE SE1.%NotDel%
	AND SE1.E1_VENCTO < %Exp:cDate%
	AND SE1.E1_SALDO  > 0
	AND DATEDIFF( DAY, CONVERT( DATETIME, COALESCE( SE1.E1_XDTUCBR, '') ), CONVERT( DATETIME, %Exp:cDate% ) ) >= %Exp:nDCRTCBR%

	ORDER BY
	SA1.A1_COD, SA1.A1_LOJA, SE1.E1_FILIAL, SE1.E1_PREFIXO,
	SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO


	EndSql

	(cAliasTRB)->(DbGoTop())

	If (cAliasTRB)->( Eof() )

		ApMsgAlert( 'Não há Títulos para Seleção.', 'Atenção !!!' )

		Return

	End If

	Do While (cAliasTRB)->(! Eof())

		aAdd( aBuffer, .F. )

		For nX := 1 To FCount()

			aAdd( aBuffer, (cAliasTRB)->&( FieldName( nX ) ) )

		Next nX

		aAdd( aList, aClone( aBuffer ) )

		aSize( aBuffer, 0 )

		(cAliasTRB)->(DbSkip())

	End Do

	(cAliasTRB)->(DbCloseArea())

	RestArea( aArea )

	oSize:AddObject( "LISTA", 000, 000, .T., .T. )

	oSize:Process()

	DEFINE DIALOG oDlg TITLE cCadastro FROM;
	oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL

	oTMultiBtn := TMultiBtn():New( 01, 01, cCadastro, oDlg,,200,150, 'TOTVSPRINTER_EMAIL',0,'',3 )
	otMultiBtn:SetFonts( ,16,,11)
	aAdd( aBcode,;
	{ || MsgRun( CapitalAce("Enviando Cartas de Cobrança ..."), CapitalAce("Aguarde !!!"), { || Envia( aList ) } ), oDlg:End() } )
	aAdd( aBcode, {|| oDlg:End() } )
	oTMultiBtn:AddButton('Enviar Carta de Cobrança')
	oTMultiBtn:AddButton('Sair')
	oTMultiBtn:bAction := { |X,Y| Eval( aBcode[ Y ] ) }

	@oSize:GetDimension("LISTA","LININI")+010, oSize:GetDimension("LISTA","COLINI");
	LISTBOX oList Fields HEADER '';
	SIZE oSize:GetDimension("LISTA","COLEND"), oSize:GetDimension("LISTA","LINEND")-040 OF oDlg PIXEL

	oList:aHeaders := { '',;
	'Código',;
	'Loja',;
	'Nome',;
	'Filial',;
	'Prefixo',;
	'Título',;
	'Parcela',;
	'Nosso Numero',;
	'Data da Emissão',;
	'Data do Vencimento',;
	'Valor',;
	'Dias em Atraso',;
	'Juros Diários',;
	'Multa Após o Vencimento',;
	'Valor Atualizado a Pagar' }

	oList:SetArray( aList )

	//TODO Verificar Cálculo Multa e Juros
	oList:bLine := { || { If( aList[ oList:nAt, 1 ], oOk, oNo ),;
	aList[ oList:nAt, 002 ],;
	aList[ oList:nAt, 003 ],;
	aList[ oList:nAt, 004 ],;
	aList[ oList:nAt, 013 ],;
	aList[ oList:nAt, 014 ],;
	aList[ oList:nAt, 015 ],;
	aList[ oList:nAt, 016 ],;
	aList[ oList:nAt, 018 ],;
	StoD( aList[ oList:nAt, 019 ] ),;
	StoD( aList[ oList:nAt, 020 ] ),;
	Transform( aList[ oList:nAt, 021 ], cPicture  ),;
	aList[ oList:nAt, 022 ],;
	Transform( 0, cPicture ),; // Juros
	Transform( 0, cPicture ),; // Multa
	Transform( aList[ oList:nAt, 021 ], cPicture ) } }

	oList:bLDblClick   := { || aList[ oList:nAt, 01 ] := ! aList[ oList:nAt,01 ], oList:DrawSelect() }
	oList:bHeaderClick := { |oList, nCol| InvertSel( oList, nCol, @aList ) }

	ACTIVATE DIALOG oDlg CENTERED

Return

//------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------



Static Function InvertSel( oList, nCol, aList )

	If nCol == 1

		aEval( aList, {|X| X[1] := ! X[1] } )

		oList:Refresh()

	End IF

Return


Static Function Envia( aList )

	Local aCartas  := {}
	Local nX       := 0
	Local nPos     := 0
	Local cFile    := ''

	For nX := 1 To Len( aList )

		If aList[ nX, 1 ]

			If aScan( aCartas, {|X| X[ 1, 1 ] == aList[ nX, 2] .And. X[ 1, 2 ] == aList[ nX, 3] } ) = 0

				aAdd( aCartas, { {;
				aList[ nX, 2],;
				aList[ nX, 3],;
				aList[ nX, 4],;
				aList[ nX, 5],;
				aList[ nX, 6],;
				aList[ nX, 7],;
				aList[ nX, 8],;
				aList[ nX, 9],;
				aList[ nX,10],;
				aList[ nX,11],;
				aList[ nX,12] }, {} } )

			End If

			nPos := aScan( aCartas, {|X| X[ 1, 1 ] == aList[ nX, 2] .And. X[ 1, 2 ] == aList[ nX, 3] } )

			aAdd( aCartas[ nPos, 2  ], aList[ nX ] )


		End If

	Next nX

	BeginTran()

	For nX := 1 To Len(aCartas)

		cFile := U_IFINR001( aCartas[ nX, 1 ], aCartas[ nX, 2 ] )

		FErase( StrTokArr2( cFile, '.', .T. )[ 1 ] + '.pdf' )

	Next nX

	EndTran()

Return