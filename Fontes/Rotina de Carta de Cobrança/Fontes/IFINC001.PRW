#INCLUDE 'RPTDEF.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWPRINTSETUP.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function IFINC001()

	Local oDlg       := Nil
	Local oList      := Nil
	Local aList      := {}
	Local oSize      := FwDefSize():New(.T.)
	Local aArea      := GetArea()
	Local cAliasTRB  := GetNextAlias()
	Local oTMultiBtn := Nil

	Private cDate     := DtoS( Date() )
	Private cCadastro := 'Carta de Cobrança'
	Private nDCRTCBR  := GetMv( 'MV_DCRTCBR' ) // Dias Carta de Cobrança
	Private cMSGCOBR  := GetMv( 'MV_MSGCOBR' ) // Mensagem Email de Cobrança
	Private cPicture  := GetSx3Cache( 'E1_SALDO', 'X3_PICTURE' )

	BeginSql Alias cAliasTRB

	SELECT
	SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_END, SA1.A1_BAIRRO,
	SA1.A1_CEP, SA1.A1_MUN, SA1.A1_EST, SA1.A1_EMAIL, SA1.A1_GRPVEN,
	(SELECT TOP 1 ACY.ACY_DESCRI FROM ACY990 ACY WHERE ACY.ACY_GRPVEN = SA1.A1_GRPVEN) ACY_DESCRI
	FROM %Table:SA1% SA1
	WHERE SA1.%NotDel%
	AND
		(
			SELECT COUNT(*) COUNT FROM %Table:SE1% SE1 WHERE
				(
					SELECT COUNT(*) FROM %Table:SZA% SZA
					WHERE SZA.ZA_FILIAL  = SE1.E1_FILIAL
					AND   SZA.ZA_PREFIXO = SE1.E1_PREFIXO
					AND   SZA.ZA_NUM     = SE1.E1_NUM
					AND   SZA.ZA_PARCELA = SE1.E1_PARCELA
					AND   SZA.ZA_TIPO    = SE1.E1_TIPO
					AND   SZA.ZA_CLIENTE = SA1.A1_COD
					AND   SZA.ZA_LOJA    = SA1.A1_LOJA
					AND   DATEDIFF( DAY, CONVERT( DATETIME, SZA.ZA_DATA ), CONVERT( DATETIME, %Exp:cDate% ) ) >= %Exp:nDCRTCBR%
					AND   SZA.%NotDel%
				) > 0
			AND SE1.E1_FILIAL  = %xFilial:SE1%
			AND SE1.E1_VENCTO  < %Exp:cDate%
			AND SE1.E1_SALDO   > 0
			AND SE1.E1_CLIENTE = SA1.A1_COD
			AND SE1.E1_LOJA    = SA1.A1_LOJA
			AND SE1.%NotDel%
		) > 0
	ORDER BY SA1.A1_COD, SA1.A1_LOJA

	EndSql

	(cAliasTRB)->(DbGoTop())

	If (cAliasTRB)->( Eof() )

		ApMsgAlert( 'Não há Títulos para Seleção.', 'Atenção !!!' )

		Return

	End If

	Do While (cAliasTRB)->(! Eof())

		aAdd( aList, (cAliasTRB)->( {;
		/*01*/ A1_COD,;
		/*02*/ A1_LOJA,;
		/*03*/ A1_NOME,;
		/*04*/ A1_END,;
		/*05*/ A1_BAIRRO,;
		/*06*/ A1_CEP,;
		/*07*/ A1_MUN,;
		/*08*/ A1_EST,;
		/*09*/ A1_EMAIL,;
		/*10*/ AllTrim( A1_GRPVEN ) + ' - ' + AllTrim( ACY_DESCRI );
		} ) )

		(cAliasTRB)->(DbSkip())

	End Do

	oSize:AddObject( "LISTA", 000, 000, .T., .T. )

	oSize:Process()

	DEFINE DIALOG oDlg TITLE cCadastro FROM;
	oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL

	oTMultiBtn := TMultiBtn():New( 01, 01, 'Clientes com Títulos em Atraso', oDlg,,200,150, 'NGBIOALERTA_01',0,'',3 )
	otMultiBtn:SetFonts( ,16,,11)
	oTMultiBtn:AddButton('Selecionar Títulos')
	oTMultiBtn:AddButton('Sair')
	oTMultiBtn:bAction := { |X,Y| If( Y == 1, SelTitulo( aList[ oList:nAt ], @aList, oList, oDlg ), oDlg:End() ) }

	@oSize:GetDimension("LISTA","LININI")+010, oSize:GetDimension("LISTA","COLINI");
	LISTBOX oList Fields HEADER '';
	SIZE oSize:GetDimension("LISTA","COLEND"), oSize:GetDimension("LISTA","LINEND")-030 OF oDlg PIXEL

	oList:aHeaders := { ;
	GetSx3Cache( 'A1_COD'  , 'X3_TITULO' ),;
	GetSx3Cache( 'A1_LOJA' , 'X3_TITULO' ),;
	GetSx3Cache( 'A1_NOME' , 'X3_TITULO' ),;
	GetSx3Cache( 'A1_EMAIL', 'X3_TITULO' ) }

	oList:SetArray( aList )

	oList:bLine := { || {;
	aList[ oList:nAt, 01 ],;
	aList[ oList:nAt, 02 ],;
	aList[ oList:nAt, 03 ],;
	aList[ oList:nAt, 09 ] } }

	oList:bLDblClick   := { || SelTitulo( aList[ oList:nAt ] ) }

	ACTIVATE DIALOG oDlg CENTERED

	(cAliasTRB)->(DbCloseArea())

	RestArea( aArea )

Return

//------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------

Static Function SelTitulo( aCliente, aListMain, oListMain, oDlgMain )

	Local cAliasTRB  := GetNextAlias()
	Local aArea      := GetArea()
	Local oSize      := FwDefSize():New(.T.)
	Local oDlg       := Nil
	Local oList      := Nil
	Local aList      := {}
	Local oNO        := LoadBitmap( GetResources(),'LBNO')
	Local oOK        := LoadBitmap( GetResources(),'LBOK')
	Local nMulta     := 0
	Local nJuros     := 0
	Local oTMultiBtn := Nil
	Local lRefresh   := .F.
	Local aBuffer    := Nil
	Local nX         := 0

	RestArea( aArea )

	BeginSql Alias cAliasTRB

	SELECT SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO,
	SE1.E1_NUMBCO, SE1.E1_EMISSAO, SE1.E1_VENCTO, SE1.E1_SALDO,
	DATEDIFF( DAY, CONVERT( DATETIME, E1_VENCTO ), CONVERT( DATETIME, %Exp:cDate% ) ) E1_ATRASO
	FROM %Table:SE1% SE1
	WHERE
	(
	SELECT COUNT(*) FROM %Table:SZA% SZA
	WHERE SZA.ZA_FILIAL  = SE1.E1_FILIAL
	AND   SZA.ZA_PREFIXO = SE1.E1_PREFIXO
	AND   SZA.ZA_NUM     = SE1.E1_NUM
	AND   SZA.ZA_PARCELA = SE1.E1_PARCELA
	AND   SZA.ZA_TIPO    = SE1.E1_TIPO
	AND   DATEDIFF( DAY, CONVERT( DATETIME, SZA.ZA_DATA ), CONVERT( DATETIME, %Exp:cDate% ) ) >= %Exp:nDCRTCBR%
	AND   SZA.%NotDel%
	) = 0
	AND SE1.E1_FILIAL  = %xFilial:SE1%
	AND SE1.E1_VENCTO  < %Exp:cDate%
	AND SE1.E1_CLIENTE = %Exp:aCliente[01]%
	AND SE1.E1_LOJA    = %Exp:aCliente[02]%
	AND SE1.E1_SALDO   > 0
	AND SE1.%NotDel%

	EndSql

	(cAliasTRB)->(DbGoTop())

	Do While (cAliasTRB)->(!EOF())

		//TODO Definir com deve calcular multa e juros.
		nMulta := 0
		nJuros := 0

		aAdd( aList, (cAliasTRB)->( {;
		/*01*/ .F.,;
		/*02*/ E1_FILIAL,;
		/*03*/ E1_PREFIXO,;
		/*04*/ E1_NUM,;
		/*05*/ E1_PARCELA,;
		/*06*/ E1_NUMBCO,;
		/*07*/ StoD( E1_EMISSAO ),;
		/*08*/ StoD( E1_VENCTO ),;
		/*09*/ E1_SALDO,;
		/*10*/ E1_ATRASO,;
		/*11*/ nJuros,;
		/*12*/ nMulta,;
		/*13*/ E1_SALDO + nJuros + nMulta,;
		/*14*/ E1_TIPO;
		} ) )

		(cAliasTRB)->( DbSkip() )

	End Do

	oSize:AddObject( "LISTA", 000, 000, .T., .T. )

	oSize:Process()

	DEFINE DIALOG oDlg TITLE cCadastro FROM;
	oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL

	oTMultiBtn := TMultiBtn():New( 01, 01, aCliente[03], oDlg,,200,150, 'CLIENTE',0,'',3 )
	otMultiBtn:SetFonts( ,16,,11)
	oTMultiBtn:AddButton('Enviar Carta de Cobrança')
	oTMultiBtn:AddButton('Sair')
	oTMultiBtn:bAction := { |X,Y| If(Y == 1, If( lRefresh := Envia( aCliente, aList ), oDlg:End(), Nil ), oDlg:End() ) }

	@oSize:GetDimension("LISTA","LININI")+010, oSize:GetDimension("LISTA","COLINI");
	LISTBOX oList Fields HEADER '';
	SIZE oSize:GetDimension("LISTA","COLEND"), oSize:GetDimension("LISTA","LINEND")-030 OF oDlg PIXEL

	oList:aHeaders := { '', 'Filial', 'Prefixo', 'Título', 'Parcela', 'Nosso Numero', 'Data da Emissão', 'Data do Vencimento','Valor',;
	'Dias em Atraso', 'Juros Diários', 'Multa Após o Vencimento', 'Valor Atualizado a Pagar' }

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
	TransForm( aList[oList:nAt,09], cPicture ),;
	aList[oList:nAt,10],;
	TransForm( aList[oList:nAt,11], cPicture ),;
	TransForm( aList[oList:nAt,12], cPicture ),;
	TransForm( aList[oList:nAt,13], cPicture ),;
	aList[oList:nAt,14]}}

	oList:bLDblClick   := { || aList[oList:nAt,01] := !aList[oList:nAt,01], oList:DrawSelect() }
	oList:bHeaderClick := { |oList, nCol| InvertSel( oList, nCol, @aList ) }

	ACTIVATE DIALOG oDlg CENTERED

	(cAliasTRB)->(DbCloseArea())

	RestArea( aArea )

	If lRefresh

		aBuffer := aClone( aListMain )

		aSize( aListMain, 0 )

		For nX := 1 To Len( aBuffer )

			If aBuffer[nX] # oListMain:nAt

				aAdd( aListMain, aBuffer[nX] )

			End If

		Next nX

		If( Len( aListMain ) == 0, oDlgMain:End(), Nil )

	End If

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


Static Function Envia( aCliente, aList )

	Local aTitulos := {}
	Local nX       := 0
	Local lRet     := .T.

	For nX := 1 To Len( aList )

		If aList[ nX, 1 ]

			aAdd( aTitulos, aList[nX] )

		End If

	Next nX

	If Len( aTitulos ) == 0

		ApMsgAlert( 'Nenhum Título Selecionado !!!', 'Atenção !!!' )

		lRet := .F.

	Else

		MsgRun( CapitalAce("Gerando Relatório ..."), CapitalAce("Aguarde ..."), { || U_IFINR001( aCliente, aTitulos ) } )

	End IF

Return lRet