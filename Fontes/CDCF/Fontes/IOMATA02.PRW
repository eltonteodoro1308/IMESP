#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#DEFINE cEnter Chr( 13 ) + Chr( 10 )

/*/{Protheus.doc} IOMATA02
Rotina de Controle de Log de Recebimento e Processamento de Rquisições do CDCF
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
/*/
User Function IOMATA02()

	Local oBrowse := FwMBrowse():New()

	oBrowse:SetAlias('ZX1')
	oBrowse:SetDescription( 'LOG de Integração com CDCF' )

	oBrowse:AddLegend( 'ZX1_STATUS = "0"', 'BLACK' ,'Erro Comunicacao CDCF'    )
	oBrowse:AddLegend( 'ZX1_STATUS = "1"', 'RED'   ,'Erro Processamento XML'   )
	oBrowse:AddLegend( 'ZX1_STATUS = "2"', 'GREEN' ,'Aguardando Importacao'    )
	oBrowse:AddLegend( 'ZX1_STATUS = "3"', 'YELLOW','Falha durante Importacao' )
	oBrowse:AddLegend( 'ZX1_STATUS = "4"', 'WHITE' ,'Importado'                )

	oBrowse:Activate()

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

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.IOMATA02', 0, 2, 0, Nil } )

Return aRotina

/*/{Protheus.doc} function_method_class_name
Função de Retorno Modelo de dados da Tabela ZX1.
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@return Object, Modelo de dados da Tabela ZX1
/*/
Static Function ModelDef()

	Local oModel  := MPFormModel():New( 'ZX1_MODEL' )
	Local oStruct := FWFormStruct( 1, 'ZX1' )

	oModel:SetDescription( 'LOG DE INTEGRAÇÃO CDCF' )
	oModel:addFields( 'ZX1_FIELD_MODEL', , oStruct )

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