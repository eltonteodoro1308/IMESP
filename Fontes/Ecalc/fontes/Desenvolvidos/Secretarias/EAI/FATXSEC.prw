#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function FATXSEC()

	Local oBrowse := FwMBrowse():New()

	oBrowse:SetAlias('Z01')
	oBrowse:SetDescription('Secretarias')
	oBrowse:Activate()

Return

Static Function MenuDef()

Return FWMVCMenu( 'FATXSEC' )


Static Function ModelDef()

	Local oModel

	Local oStr1:= FWFormStruct(1,'Z01')
	oModel := MPFormModel():New('MFATXSEC')
	oModel:SetDescription('Cadastro de Secretarias')
	oModel:addFields('Z01_FIELD',,oStr1)
	oModel:getModel('Z01_FIELD'):SetDescription('Cadastro de Secretarias')
	oModel:SetPrimaryKey( { 'Z01_COD' } )

Return oModel


Static Function ViewDef()

	Local oView
	Local oModel := ModelDef()

	Local oStr1:= FWFormStruct(2, 'Z01')
	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'Z01_FIELD' )
	oView:CreateHorizontalBox( 'BOXFORM1', 100)
	oView:SetOwnerView('FORM1','BOXFORM1')

Return oView