#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

User Function M050TOK()

	Local oModel  := ModelDef()
	Local aFields := oModel:GetModel('SA4_MODEL'):GetStruct():GetFields()
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

		oModel:Setvalue( 'SA4_MODEL', aValues[ nX, 1 ], aValues[ nX, 2 ] )

	Next nX

	oModel:VldData()

	oModel:CommitData()

	oModel:DeActivate()

return .T.

Static Function ModelDef()

	Local oStru  := FWFormStruct( 1, 'SA4')
	Local oModel := MPFormModel():New( 'CARRIER' )

	oModel:AddFields( 'SA4_MODEL',, oStru )
	oModel:SetDescription( 'Cadastro de Transportadoras' )
	oModel:GetModel( 'SA4_MODEL' ):SetDescription( 'Cadastro de Transportadoras' )
	oModel:GetModel( 'SA4_MODEL' ):SetOnlyQuery ( .T. )

Return oModel

Static Function IntegDef(cXml, cTypeTran, cTypeMsg, cVersion)

	Local lRet    := .T.
	Local oModel  := Nil
	Local cXmlRet := ''

	If cTypeMsg == EAI_MESSAGE_BUSINESS

		oModel := FwModelActive()

		cXmlRet += '<BusinessEvent>'
		cXmlRet += '<Entity>CARRIER</Entity>'
		cXmlRet += '<Event>upsert</Event>'
		cXmlRet += '<Identification>'
		cXmlRet += '<key name="Code">'
		cXmlRet += AllTrim( oModel:GetModel( 'SA4_MODEL' ):GetValue( 'A4_COD' ) )
		cXmlRet += '</key>'
		cXmlRet += '</Identification>'
		cXmlRet += '</BusinessEvent>'
		cXmlRet += '<BusinessContent>'
		cXmlRet += oModel:GetXmlData(.T.,,,,,.T.)
		cXmlRet += '</BusinessContent>'

	End If

Return { lRet, cXmlRet, 'CARRIER' }