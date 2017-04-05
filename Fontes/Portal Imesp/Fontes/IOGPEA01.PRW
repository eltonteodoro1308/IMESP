#Include 'TOTVS.CH'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} IOGPEA01
//Cadastro de Dados Complementares de Funcionários para o Portal
@author Elton Teodoro Alves
@since 05/04/2017
@version 12.1.014
/*/
User Function IOGPEA01()

	Local oBrowse := FwMBrowse():New()

	oBrowse:SetAlias('SZ0')
	oBrowse:SetDescription('Complemento Para o Portal')
	oBrowse:Activate()

Return

/*/{Protheus.doc} MenuDef
//Menu de Rotinas do Browse
@author Elton Teodoro Alves
@since 05/04/2017
@version 12.1.014
/*/
Static Function MenuDef()

Return FWMVCMenu( 'IOGPEA01' )

/*/{Protheus.doc} ModelDef
//Modele de dados da Tabela SZ0
@author Elton Teodoro Alves
@since 05/04/2017
@version 12.1.014
/*/
Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'SZ0')
	oModel := MPFormModel():New('Complemento Para o Portal')
	oModel:SetDescription('Imagens de Portal')
	oModel:addFields('SZ0_FIELD',,oStr1)
	oModel:getModel('SZ0_FIELD'):SetDescription('Complemento Para o Portal')

Return oModel

/*/{Protheus.doc} ViewDef
//View do Modelo de Dados
@author Elton Teodoro Alves
@since 05/04/2017
@version 12.1.014
/*/
Static Function ViewDef()

	Local oView
	Local oModel := ModelDef()

	Local oStr1:= FWFormStruct(2, 'SZ0')
	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'SZ0_FIELD' )
	oView:CreateHorizontalBox( 'BOXFORM1', 100)
	oView:SetOwnerView('FORM1','BOXFORM1')

Return oView