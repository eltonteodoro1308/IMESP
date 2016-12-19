#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IFINC001
User Function da Rotina de Cartas de cobrança para clientes com títulos em atraso.
@author Elton Teodoro Alves
@since 19/12/2016
@version 12.1.007
/*/
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
	Local cPerg     := 'IFINR002'

	Private dDate     := Date()
	Private cDate     := DtoS( dDate )
	Private cCadastro := 'Carta de Cobrança'
	Private nDCRTCBR  := GetMv( 'MV_DCRTCBR' ) // Dias Carta de Cobrança

	Private cPicture  := AllTrim( GetSx3Cache( 'E1_SALDO', 'X3_PICTURE' ) )

	Pergunte( cPerg, .T. )

	BeginSql Alias cAliasTRB

	SELECT

	SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_END, SA1.A1_BAIRRO,
	SA1.A1_CEP, SA1.A1_MUN, SA1.A1_EST, SA1.A1_EMAIL, SA1.A1_GRPVEN,
	(SELECT TOP 1 ACY.ACY_DESCRI FROM %Table:ACY% ACY WHERE ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.%NotDel%) ACY_DESCRI,

	SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO,
	SE1.E1_NUMBCO, SE1.E1_EMISSAO, SE1.E1_VENCTO, SE1.E1_SALDO,
	DATEDIFF( DAY, CONVERT( DATETIME, SE1.E1_VENCTO ), CONVERT( DATETIME, %Exp:cDate% ) ) E1_ATRASO,
	SE1.R_E_C_N_O_, SE1.E1_XDTUCBR

	FROM %Table:SE1% SE1

	LEFT JOIN %Table:SA1% SA1
	ON  SA1.A1_COD  = SE1.E1_CLIENTE
	AND SA1.A1_LOJA = SE1.E1_LOJA
	AND SA1.%NotDel%

	WHERE

	SE1.%NotDel% AND
	SE1.E1_VENCTO < %Exp:cDate%	AND
	SE1.E1_SALDO  > 0 AND
	DATEDIFF( DAY, CONVERT( DATETIME, COALESCE( SE1.E1_XDTUCBR, '') ), CONVERT( DATETIME, %Exp:cDate% ) ) >= %Exp:nDCRTCBR% AND
	SE1.E1_FILIAL  BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND
	SE1.E1_CLIENTE BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR05% AND
	SE1.E1_LOJA    BETWEEN %Exp:MV_PAR04% AND %Exp:MV_PAR06%

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
	'Valor Atualizado a Pagar',;
	'Data Ult. Carta de Cobrança' }

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
	Transform( aList[ oList:nAt, 021 ], cPicture ),;
	StoD( aList[ oList:nAt, 024 ] ) } }

	oList:bLDblClick   := { || aList[ oList:nAt, 01 ] := ! aList[ oList:nAt,01 ], oList:DrawSelect() }
	oList:bHeaderClick := { |oList, nCol| InvertSel( oList, nCol, @aList ) }

	ACTIVATE DIALOG oDlg CENTERED

Return
/*/{Protheus.doc} InvertSel
Static Function e inverte a seleção dos títulos da lista na tela de cartas de cobrança
@author Elton Teodoro Alves
@since 19/12/2016
@version 12.1.007
@param oList, object, Objeto que corresponde a lista de títulos
@param nCol, numeric, Posição do cabeçalho da coluna que foi clicada
@param aList, array, Array que corresponde a lista de títulos
/*/
Static Function InvertSel( oList, nCol, aList )

	If nCol == 1

		aEval( aList, {|X| X[1] := ! X[1] } )

		oList:Refresh()

	End IF

Return
/*/{Protheus.doc} Envia
Static Function que gera o PDF das Cartas de Cobrança e envia por Email para o cliente.
@author Elton Teodoro Alves
@since 19/12/2016
@version 12.1.007
@param aList, array, Array com lista de títulos em atraso
/*/
Static Function Envia( aList )

	Local aCartas  := {}
	Local nX       := 0
	Local nPos     := 0
	Local cFile    := ''
	Local oDlg     := Nil
	Local oList    := Nil
	Local oSButton := Nil

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

	If Len( aCartas ) = 0

		ApMsgStop( 'Nenhum Título Selecionado, nenhuma Carta de Cobrança será enviada.', 'Atenção !!!' )

		Return

	Else

		DEFINE DIALOG oDlg TITLE 'Confirma as contas de e-mail a seguir ?' FROM	000, 000 TO 500, 750 PIXEL

		@002,005 LISTBOX oList Fields HEADER '' SIZE 365, 225 OF oDlg PIXEL

		oList:aHeaders := { 'Código', 'Loja', 'Nome', 'Email'  }
		oList:SetArray( aCartas )

		oList:bLine := { || {;
		aCartas[ oList:nAt, 001, 001 ],;
		aCartas[ oList:nAt, 001, 002 ],;
		aCartas[ oList:nAt, 001, 003 ],;
		aCartas[ oList:nAt, 001, 009 ] } }

		oList:bLDblClick   := { || aCartas[ oList:nAt, 001, 009 ] := SetMail( aCartas[ oList:nAt, 001, 009 ] ), oList:DrawSelect() }

		DEFINE SBUTTON oSButton FROM 232, 342 TYPE 01 OF oDlg ENABLE ACTION oDlg:End()

		ACTIVATE DIALOG oDlg CENTERED

	End If

	BeginTran()

	For nX := 1 To Len(aCartas)

		cFile := U_IFINR001( aCartas[ nX, 1 ], aCartas[ nX, 2 ] )

		cFile := StrTokArr2( cFile, '.', .T. )[ 1 ] + '.pdf'

		U_IFINM001( cFile, aCartas[ nX, 1, 9 ] )

		FErase( cFile )

	Next nX

	EndTran()

Return
/*/{Protheus.doc} SetMail
Static Function que exibe tela para modificar e-mail de envio
@author Elton Teodoro Alves
@since 19/12/2016
@version 12.1.007
@param cEmail, characters, E-mail atual do cadastro do cliente
@return return, Se for informado um e-mail válido retorna o mesmo, senão retorna o email do cadastro do cliente
/*/
Static Function SetMail( cEmail )

	Local oGet     := Nil
	Local cGet     := PadR( cEmail, GetSx3Cache( 'A1_EMAIL', 'X3_TAMANHO' ) )
	Local cRet
	Local oSButton := Nil
	Local oDlg     := Nil

	DEFINE MSDIALOG oDlg TITLE 'Informe o e-mail para envio.' FROM 000, 000  TO 070, 500 COLORS 0, 16777215 PIXEL

	@ 002, 002 MSGET oGet VAR cGet SIZE 245, 010 OF oDlg COLORS 0, 16777215 PIXEL
	DEFINE SBUTTON oSButton FROM 018, 220 TYPE 01 OF oDlg ENABLE ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

	If IsEmail( cGet )

		cRet := cGet

	Else

		ApMsgStop( 'Digite um e-mail válido.', 'Atenção !!!' )

		cRet := cEmail

	End If

Return cRet