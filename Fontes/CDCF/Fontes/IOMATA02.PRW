#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} IOMATA02
Rotina de Controle de Log de Recebimento e Processamento de Rquisições do CDCF
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
/*/
User Function IOMATA02()

	Local aCoors      := FWGetDialogSize( oMainWnd )
	Local oFWLayer    := FWLayer():New()
	Local oDlgPrinc   := Nil
	Local oBrowseTop  := FwMBrowse():New()
	Local oBrowseDown := FwMBrowse():New()
	Local oPanelTop   := Nil
	Local oPanelDown  := Nil
	Local oRelacion   := FWBrwRelation():New()

	Define MsDialog oDlgPrinc Title 'LOG de Integração com CDCF' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel


	oFWLayer:Init( oDlgPrinc, .F. )

	// Definindo Browser Top
	oFWLayer:AddLine( 'UP', 50, .F. )
	oFWLayer:AddCollumn( 'ALL_UP', 100, .T., 'UP' )

	oPanelTop := oFWLayer:GetColPanel( 'ALL_UP', 'UP' )

	oBrowseTop:SetOwner( oPanelTop )

	oBrowseTop:DisableReport()
	oBrowseTop:DisableDetails()
	oBrowseTop:ForceQuitButton()

	oBrowseTop:SetAlias( 'ZX1' )
	oBrowseTop:SetDescription( 'LOG de Integração com CDCF' )

	oBrowseTop:AddLegend( 'ZX1_STATUS = "0"', 'GREEN' ,'Aguardando Importação'    )
	oBrowseTop:AddLegend( 'ZX1_STATUS = "1"', 'BLACK' ,'Erro Comunicação CDCF'    )
	oBrowseTop:AddLegend( 'ZX1_STATUS = "2"', 'RED'   ,'Erro Processamento XML'   )
	oBrowseTop:AddLegend( 'ZX1_STATUS = "3"', 'YELLOW','Importado com Falhas' )
	oBrowseTop:AddLegend( 'ZX1_STATUS = "4"', 'WHITE' ,'Importado'                )

	oBrowseTop:Activate()

	// Definindo Browser Down
	oFWLayer:AddLine( 'DOWN', 50, .F. )
	oFWLayer:AddCollumn( 'ALL_DOWN' , 100, .T., 'DOWN' )
	oPanelDown := oFWLayer:GetColPanel( 'ALL_DOWN' , 'DOWN' )

	oBrowseDown:SetOwner( oPanelDown )

	oBrowseDown:DisableReport()
	oBrowseDown:DisableDetails()

	oBrowseDown:SetAlias( 'ZX2' )
	oBrowseDown:SetDescription( 'Clientes Processados' )
	oBrowseDown::SetMenuDef( 'IOMATA03' )

	oBrowseDown:AddLegend( 'ZX2_STATUS = "0"', 'QMT_OK'   , 'Confirmado'     )
	oBrowseDown:AddLegend( 'ZX2_STATUS = "1"', 'QMT_COND' , 'Parcial'        )
	oBrowseDown:AddLegend( 'ZX2_STATUS = "2"', 'QMT_NO'   , 'Não Confirmado' )

	oBrowseDown:Activate()

	oRelacion:AddRelation( oBrowseTop , oBrowseDown , { { 'ZX2_FILIAL', 'ZX1_FILIAL' }, { 'ZX2_CODIGO' , 'ZX1_CODIGO' } } )
	oRelacion:Activate()

	Activate MsDialog oDlgPrinc Center

Return

/*/{Protheus.doc} MenuDef
Função de Retorno do Menu do Browse da Rotina
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@return Array, Array com as Rotinas do menu do Browse
/*/
Static Function MenuDef()

	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar'     , 'VIEWDEF.IOMATA02', 0, 2, 0, Nil } )
	aAdd( aRotina, { 'XML Requisição' , 'U_IOMT02EX("1")'  , 0, 6, 0, Nil } )
	aAdd( aRotina, { 'XML CDCF'       , 'U_IOMT02EX("2")'  , 0, 6, 0, Nil } )

Return aRotina

/*/{Protheus.doc} ModelDef
Função de Retorno Modelo de dados da Tabela ZX1.
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@return Object, Modelo de dados da Tabela ZX1
/*/
Static Function ModelDef()

	Local oModel  := MPFormModel():New( 'ZX1_MODEL' )
	Local oStrZX1 := FWFormStruct( 1, 'ZX1' )
	Local oStrZX2 := FWFormStruct( 1, 'ZX2' )

	oModel:SetDescription( 'LOG DE INTEGRAÇÃO CDCF' )

	oModel:addFields( 'ZX1_FIELD_MODEL', , oStrZX1 )

Return oModel

/*/{Protheus.doc} ViewDef
Função de Retorno da View do Modelo de dados da Tabela ZX1..
@author elton.alves
@since 08/02/2017
@version undefined
@return Object, View do Modelo de dados da Tabela ZX1
/*/
Static Function ViewDef()

	Local oView   := FWFormView():New()
	Local oModel  := ModelDef()
	Local oStruct := FWFormStruct( 2, 'ZX1' )

	oView:SetModel( oModel )
	oView:AddField( 'ZX1_FIELD_VIEW', oStruct, 'ZX1_FIELD_MODEL' )
	oView:CreateHorizontalBox( 'BOX_ZX1_FIELD_VIEW', 100)
	oView:SetOwnerView( 'ZX1_FIELD_VIEW', 'BOX_ZX1_FIELD_VIEW' )

Return oView



/*/{Protheus.doc} IOMT02EX
Funcao informada no aRotina do Browse, que executa uma ação conforme o Codigo recebido por parametro
@author Elton Teodoro Alves
@since 09/02/2017
@version 12.1.014
@param cCod, characters, Código a ação a ser executada:
1 - Exibe o XML da Requisição
2 - Exibe o XML do CDCF
/*/
User Function IOMT02EX( cCod )

	Local cFile    := GetTempPath( .T. ) + GetNextAlias()
	Local aArrExec := {}

	If cCod == '1'

		cFile += '.xml'

		MemoWrite( cFile, ZX1->ZX1_XMLREC )

	ElseIf cCod == '2' .And. ! Empty( ZX1->ZX1_XMLPRC )

		cFile += '.xml'

		MemoWrite( cFile, ZX1->ZX1_XMLPRC )

	Else

		ApMsgInfo( 'Informação não Disponível', 'Atenção !!!' )

		Return

	End If

	ShellExecute( 'Open', '%PROGRAMFILES%\Internet Explorer\iexplore.exe', cFile, 'C:\', 1 )

Return