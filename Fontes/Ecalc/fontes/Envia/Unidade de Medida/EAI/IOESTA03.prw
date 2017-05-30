#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function IOESTA03()

	Local oBrowse := FwMBrowse():New()

	oBrowse:SetAlias('SZB')
	oBrowse:SetDescription('Tabela de Conversões')
	oBrowse:Activate()

Return

Static Function MenuDef()

Return FWMVCMenu( 'IOESTA03' )

Static Function ModelDef()

	Local oModel

	Local oStr1:= FWFormStruct(1,'SZB')
	oModel := MPFormModel():New('MIOEST03')
	oModel:SetDescription('Tabela de Conversões')
	oModel:addFields('SZB_FIELD',,oStr1)
	oModel:getModel('SZB_FIELD'):SetDescription('Tabela de Conversões')

Return oModel

Static Function ViewDef()

	Local oView
	Local oModel := ModelDef()

	Local oStr1:= FWFormStruct(2, 'SZB')
	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'SZB_FIELD' )
	oView:CreateHorizontalBox( 'BOXFORM1', 100)
	oView:SetOwnerView('FORM1','BOXFORM1')

Return oView