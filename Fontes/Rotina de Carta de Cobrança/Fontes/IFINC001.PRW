#INCLUDE 'RPTDEF.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWPRINTSETUP.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function IFINC001()

	Local   oBrowse := FWMBrowse():New()

	Private aRotina := { { 'Enviar Carta de Cobrança',;
	'U_SE1IFC01( SA1->A1_COD, SA1->A1_LOJA, SA1->A1_NOME, SA1->A1_END, SA1->A1_BAIRRO,'+;
	' SA1->A1_CEP, SA1->A1_MUN, SA1->A1_EST, SA1->A1_EMAIL, SA1->A1_GRPVEN )',;
	0, 6, 0, Nil, Nil, Nil } }

	Private cCadastro := ''
	Private nDCRTCBR  := GetMv( 'MV_DCRTCBR' ) // Dias Carta de Cobrança
	Private cMSGCOBR  := GetMv( 'MV_MSGCOBR' ) // Mensagem Email de Cobrança
	Private cPicture  := GetSx3Cache( 'E1_SALDO', 'X3_PICTURE' )

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

User Function SE1IFC01( cCliente, cLoja, cNome, cEnd, cBairro, cCep, cMun, cEst, cEmail, cGrpVen )

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
	Local aCliente  := {}

	aAdd( aCliente, cNome    ) // 01
	aAdd( aCliente, cEnd     ) // 02
	aAdd( aCliente, cBairro  ) // 03
	aAdd( aCliente, cCep     ) // 04
	aAdd( aCliente, cMun     ) // 05
	aAdd( aCliente, cEst     ) // 06
	aAdd( aCliente, cEmail   ) // 07
	aAdd( aCliente, cCliente ) // 08
	aAdd( aCliente, AllTrim( cGrpVen ) + ' - ' + AllTrim( Posicione( 'ACY', 1, xFilial('CYA') + cGrpVen, 'ACY_DESCRI') ) ) // 09
	aAdd( aCliente, cLoja    ) // 10

	RestArea( aArea )

	BeginSql Alias cAliasTRB

	SELECT E1_FILIAL, E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_NUMBCO,E1_EMISSAO,E1_VENCTO,E1_SALDO,
	DATEDIFF( DAY, CONVERT( DATETIME, E1_VENCTO ), CONVERT( DATETIME, %Exp:cDate% ) ) E1_ATRASO
	FROM %Table:SE1% SE1
	WHERE //DATEDIFF( DAY, CONVERT( DATETIME, SE1.E1_XULTCBR ), CONVERT( DATETIME, %Exp:cDate% ) ) >= %Exp:nDCRTCBR%
	(
	SELECT COUNT(*) FROM SZA990 SZA
	WHERE SZA.ZA_FILIAL  = SE1.E1_FILIAL
	AND   SZA.ZA_PREFIXO = SE1.E1_PREFIXO
	AND   SZA.ZA_NUM     = SE1.E1_NUM
	AND   SZA.ZA_PARCELA = SE1.E1_PARCELA
	AND   SZA.ZA_TIPO    = SE1.E1_TIPO
	AND   DATEDIFF( DAY, CONVERT( DATETIME, SZA.ZA_DATA ), CONVERT( DATETIME, %Exp:cDate% ) ) <= %Exp:nDCRTCBR%
	) = 0
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

	DEFINE DIALOG oDlg TITLE 'Títulos em Atraso' FROM;
	oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL

	@oSize:GetDimension("LISTA","LININI"), oSize:GetDimension("LISTA","COLINI");
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

	EnchoiceBar( oDlg, {|| Envia( aCliente, aList )}, {||oDlg:End()},,,,,.F.,.F.,.F.,.T.,.F. )

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
	WHERE //DATEDIFF( DAY, CONVERT( DATETIME, SE1.E1_XULTCBR ), CONVERT( DATETIME, %Exp:cDate% ) ) >= %Exp:nDCRTCBR%
	(
	SELECT COUNT(*) FROM SZA990 SZA
	WHERE SZA.ZA_FILIAL  = SE1.E1_FILIAL
	AND   SZA.ZA_PREFIXO = SE1.E1_PREFIXO
	AND   SZA.ZA_NUM     = SE1.E1_NUM
	AND   SZA.ZA_PARCELA = SE1.E1_PARCELA
	AND   SZA.ZA_TIPO    = SE1.E1_TIPO
	AND   DATEDIFF( DAY, CONVERT( DATETIME, SZA.ZA_DATA ), CONVERT( DATETIME, %Exp:cDate% ) ) >= %Exp:nDCRTCBR%
	) = 0
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


Static Function Envia( aCliente, aList )

	Local aTitulos := {}
	Local nX       := 0

	For nX := 1 To Len( aList )

		If aList[ nX, 1 ]

			aAdd( aTitulos, aList[nX] )

		End If

	Next nX

	If Len( aTitulos ) == 0

		ApMsgAlert( 'Nenhum Título Selecionado !!!', 'Atenção !!!' )

	Else

		MsgRun( CapitalAce("Gerando Relatório ..."), CapitalAce("Aguarde ..."), { || U_IFINR001( aCliente, aTitulos ) } )

	End IF

Return