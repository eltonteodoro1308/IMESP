#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function SFINC001()

	Local aCoors      := FWGetDialogSize( oMainWnd )
	Local oPanelUp    := Nil
	Local oPanelDown  := Nil
	Local oFWLayer    := Nil
	Local oBrowseUp   := Nil
	Local oBrowseDown := Nil
	Local oRelacSE1   := Nil
	Local oDlgPrinc   := Nil
	Local aFldsDown   := {}
	Private aRotina   := { { 'Enviar', 'Alert("Enviado !!!")', 0, 6, 0, Nil, Nil, Nil } }

	Define MsDialog oDlgPrinc Title 'Carta de Cobrança' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

	oFWLayer := FWLayer():New()
	oFWLayer:Init( oDlgPrinc, .F. )
	oFWLayer:AddLine( 'UP', 50, .F. )
	oFWLayer:AddCollumn( 'UP', 100, .T., 'UP' )

	oPanelUp := oFWLayer:GetColPanel( 'UP', 'UP' )

	oBrowseUp := FwMarkBrowse():New()
	oBrowseUp:DisableReport()
	oBrowseUp:SetCustomMarkRec( {|| U_Exec( oBrowseUp:Data() ) } )
	oBrowseUp:SetOnlyFields( { 'A1_COD', 'A1_LOJA', 'A1_NOME', 'A1_EMAIL' } )
	oBrowseUp:SetFilterDefault('u_Verifica()')
	oBrowseUp:SetOwner( oPanelUp )
	oBrowseUp:SetDescription( "Clientes" )
	oBrowseUp:SetAlias( 'SA1' )
	oBrowseUp:SetProfileID( '1' )
	oBrowseUp:ForceQuitButton()
	oBrowseUp:Activate()

	oFWLayer:AddLine( 'DOWN', 100, .F. )
	oFWLayer:AddCollumn( 'DOWN', 100, .T., 'DOWN' )

	oPanelDown := oFWLayer:GetColPanel( 'DOWN' , 'DOWN' )
	oBrowseDown:= FwMarkBrowse():New()
	oBrowseDown:DisableReport()
	oBrowseDown:SetOnlyFields( {''} )

	// [n][01] Título da coluna
	// [n][02] Code-Block de carga dos dados
	// [n][03] Tipo de dados
	// [n][04] Máscara
	// [n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	// [n][06] Tamanho
	// [n][07] Decimal
	// [n][08] Indica se permite a edição
	// [n][09] Code-Block de validação da coluna após a edição
	// [n][10] Indica se exibe imagem
	// [n][11] Code-Block de execução do duplo clique
	// [n][12] Variável a ser utilizada na edição (ReadVar)
	// [n][13] Code-Block de execução do clique no header
	// [n][14] Indica se a coluna está deletada
	// [n][15] Indica se a coluna será exibida nos detalhes do Browse
	// [n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)

	aAdd(aFldsDown,{GetSx3Cache('E1_PREFIXO','X3_TITULO'),{||SE1->E1_PREFIXO},'C','@!','1',GetSx3Cache('E1_PREFIXO','X3_TAMANHO')})
	aAdd(aFldsDown,{GetSx3Cache('E1_NUM','X3_TITULO'),{||SE1->E1_NUM},'C','@!','1',GetSx3Cache('E1_NUM','X3_TAMANHO')})
	aAdd(aFldsDown,{GetSx3Cache('E1_PARCELA','X3_TITULO'),{||SE1->E1_PARCELA},'C','@!','1',GetSx3Cache('E1_PARCELA','X3_TAMANHO')})
	aAdd(aFldsDown,{GetSx3Cache('E1_NUMBCO','X3_TITULO'),{||SE1->E1_NUMBCO},'C','@!','1',GetSx3Cache('E1_NUMBCO','X3_TAMANHO')})
	aAdd(aFldsDown,{GetSx3Cache('E1_EMISSAO','X3_TITULO'),{||SE1->E1_EMISSAO},'D',,'1',GetSx3Cache('E1_EMISSAO','X3_TAMANHO')})
	aAdd(aFldsDown,{GetSx3Cache('E1_VENCREA','X3_TITULO'),{||SE1->E1_VENCREA},'D',,'1',GetSx3Cache('E1_VENCREA','X3_TAMANHO')})
	aAdd(aFldsDown,{'Dias de Atraso',{||Date()-SE1->E1_VENCREA},'N','9999','2', 004})
	aAdd(aFldsDown,{GetSx3Cache('E1_VLCRUZ','X3_TITULO'),{||SE1->E1_VLCRUZ},'N',GetSx3Cache('E1_VLCRUZ','X3_PICTURE'),'2',;
	GetSx3Cache('E1_VLCRUZ','X3_TAMANHO'),GetSx3Cache('E1_VLCRUZ','X3_DECIMAL')})
	aAdd(aFldsDown,{'Juros',{||SE1->E1_PORCJUR*(Date()-SE1->E1_VENCREA)},'N',GetSx3Cache('E1_VLCRUZ','X3_PICTURE'),'2',;
	GetSx3Cache('E1_VLCRUZ','X3_TAMANHO'),GetSx3Cache('E1_VLCRUZ','X3_DECIMAL')})
	aAdd(aFldsDown,{'Multa',{||(SE1->E1_VALJUR*(Date()-SE1->E1_VENCREA))},'N',GetSx3Cache('E1_VLCRUZ','X3_PICTURE'),'2',;
	GetSx3Cache('E1_VLCRUZ','X3_TAMANHO'),GetSx3Cache('E1_VLCRUZ','X3_DECIMAL')})

	oBrowseDown:SetFields( aFldsDown )
	oBrowseDown:SetOwner( oPanelDown )
	oBrowseDown:SetDescription( 'Títulos' )
	oBrowseDown:SetIgnoreARotina( .T. )
	oBrowseDown:SetMenuDef( 'SFINM001' )
	oBrowseDown:SetFieldMark( 'E1_OK' )
	oBrowseDown:DisableDetails()
	oBrowseDown:SetAlias( 'SE1' )
	oBrowseDown:SetProfileID( '2' )
	oBrowseDown:Activate()

	oRelacSE1:= FWBrwRelation():New()
	oRelacSE1:AddRelation( oBrowseUp , oBrowseDown ,;
	{ { 'E1_CLIENTE' , 'A1_COD' }, { 'E1_LOJA' , 'A1_LOJA' } } )
	oRelacSE1:Activate()

	Activate MsDialog oDlgPrinc Center

Return NIL

User Function Exec( oData )

	Alert( oData:IsLast() )

Return

User Function Verifica()

Return A1_COD = 'C001'