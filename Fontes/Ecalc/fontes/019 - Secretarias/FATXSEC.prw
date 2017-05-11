#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWADAPTEREAI.CH'

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

Static Function IntegDef( cXml, cTypeTran, cTypeMsg, cVersion )

	Local oModel  := FwModelActive()
	Local cXmlRet := ''

	If cTypeMsg == EAI_MESSAGE_BUSINESS

		cXmlRet += '<BusinessEvent>'
		cXmlRet += '<Entity>SECRETARIES</Entity>'
		cXmlRet += '<Event>upsert</Event>'
		cXmlRet += '<Identification>'
		cXmlRet += '<key name="Code">'
		cXmlRet += AllTrim( oModel:GetModel( 'Z01_FIELD' ):GetValue( 'Z01_COD' ) )
		cXmlRet += '</key>'
		cXmlRet += '</Identification>'
		cXmlRet += '</BusinessEvent>'
		cXmlRet += '<BusinessContent>'
		cXmlRet += oModel:GetXmlData(.T.,,,,,.T.)
		cXmlRet += '</BusinessContent>'

	End If

Return { .T., cXmlRet, 'SECRETARIES' }