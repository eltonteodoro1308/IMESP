#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function IFINC001()

	Local   oBrowse := FWMBrowse():New()
	Private aRotina := { { 'Selecionar Títulos', 'U_SE1IFX01( SA1->A1_COD, SA1->A1_LOJA )', 0, 6, 0, Nil, Nil, Nil } }

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

User Function SE1IFX01( cCliente, cLoja)

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

	BeginSql Alias cAliasTRB

	SELECT E1_FILIAL, E1_PREFIXO,E1_NUM,E1_PARCELA,E1_NUMBCO,E1_EMISSAO,E1_VENCTO,E1_VLCRUZ,
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

		aAdd( aList, (cAliasTRB)->( { .F., E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_NUMBCO, E1_EMISSAO,;
		E1_VENCTO, E1_VLCRUZ, E1_ATRASO, E1_PORCJUR, E1_VALJUR, ( E1_VLCRUZ + E1_PORCJUR + E1_VALJUR ) } ) )

		(cAliasTRB)->( DbSkip() )

	End Do

	oSize:AddObject( "LISTA", 000, 000, .T., .T. )

	oSize:Process()

	DEFINE DIALOG oDlg TITLE 'Títulos em Atraso' FROM;
	oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL

	@oSize:GetDimension("LISTA","LININI"), oSize:GetDimension("LISTA","COLINI");
	LISTBOX oList Fields HEADER '';
	SIZE oSize:GetDimension("LISTA","COLEND"), oSize:GetDimension("LISTA","LINEND") OF oDlg PIXEL

	oList:aHeaders := { '', 'Filial', 'Prefixo', 'Título', 'Parcela', 'Nosso Numero', 'Data da Emissão', 'Data do Vencimento','Valor',;
	'Dias em Atraso', 'Juros Diários 0,0333%', 'Multa Após o Vencimento 2,0%','Valor Atualizado a Pagar', }

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

	EnchoiceBar( oDlg, {||ApMsgInfo('Botão OK !!!','Atençao !!!')}, {||oDlg:End()},,,,,.F.,.F.,.F.,.T.,.F. )

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