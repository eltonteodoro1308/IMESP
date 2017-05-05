#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

user function MA650TOK()

	Local oModel  := ModelDef()
	Local aFields := oModel:GetModel('SC2_MODEL'):GetStruct():GetFields()
	Local aValues := {}
	Local nX      := 0

	For nX := 1 To Len( aFields )

		aAdd( aValues, { aFields[ nX, MODEL_FIELD_IDFIELD ], Eval( &( '{||M->' + aFields[ nX, MODEL_FIELD_IDFIELD ] + '}' ) ) } )

	Next nX

	If INCLUI

		oModel:SetOperation( MODEL_OPERATION_INSERT )

	Else

		oModel:SetOperation( MODEL_OPERATION_UPDATE )

	End If

	oModel:Activate()

	For nX := 1 To Len( aValues )

		oModel:Setvalue( 'SC2_MODEL', aValues[ nX, 1 ], aValues[ nX, 2 ] )

	Next nX

	oModel:VldData()

	oModel:CommitData()

	oModel:DeActivate()

return .T.

Static Function ModelDef()

	Local oModel := MPFormModel():New('PRODUCTIONORDER')
	Local oStr:= FWFormStruct( 1, 'SC2', { | cCampo | GetSX3Cache( cCampo, 'X3_CONTEXT' ) # 'V' .And. AllTrim(cCampo) # 'C2_VERIFI' } )

	oStr:SetProperty( '*' , MODEL_FIELD_VALID, {||.T.} )
	
	oModel:SetDescription('Ordem de Produção')
	oModel:addFields('SC2_MODEL',,oStr)
	oModel:getModel('SC2_MODEL'):SetDescription('Ordem de Produção')
	oModel:GetModel( 'SC2_MODEL' ):SetOnlyQuery ( .T. )

Return oModel

Static Function IntegDef(cXml, cTypeTran, cTypeMsg, cVersion)

	Local lRet    := .T.
	Local oModel  := Nil
	Local cXmlRet := ''

	If cTypeMsg == EAI_MESSAGE_BUSINESS

		oModel := FwModelActive()

		cXmlRet += '<BusinessEvent>'
		cXmlRet += '<Entity>PRODUCTIONORDER</Entity>'
		cXmlRet += '<Event>upsert</Event>'
		cXmlRet += '<Identification>'
		cXmlRet += '<key name="Code">'
		cXmlRet += AllTrim( oModel:GetModel( 'SC2_MODEL' ):GetValue( 'C2_NUM' ) )
		cXmlRet += '</key>'
		cXmlRet += '</Identification>'
		cXmlRet += '</BusinessEvent>'
		cXmlRet += '<BusinessContent>'
		cXmlRet += oModel:GetXmlData(.T.,,,,,.T.)
		cXmlRet += '</BusinessContent>'

	End If

Return { lRet, cXmlRet, 'PRODUCTIONORDER' }