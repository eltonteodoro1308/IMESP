#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

User Function CTA030TOK()

	Local nOpc    := PARAMIXB
	Local oModel  := ModelDef()
	Local aFields := oModel:GetModel('CTT_MODEL'):GetStruct():GetFields()
	Local aValues := {}
	Local nX      := 0

	For nX := 1 To Len( aFields )

		aAdd( aValues, { aFields[ nX, MODEL_FIELD_IDFIELD ], Eval( &( '{||M->' + aFields[ nX, MODEL_FIELD_IDFIELD ] + '}' ) ) } )

	Next nX

	oModel:SetOperation( nOpc )

	oModel:Activate()

	For nX := 1 To Len( aValues )

		oModel:Setvalue( 'CTT_MODEL', aValues[ nX, 1 ], aValues[ nX, 2 ] )

	Next nX

	oModel:VldData()

	oModel:CommitData()

	oModel:DeActivate()

Return .F.

Static Function ModelDef()

	Local oStru  := FWFormStruct( 1, 'CTT')
	Local oModel := MPFormModel():New( 'COSTCENTER' )

	oModel:AddFields( 'CTT_MODEL',, oStru )
	oModel:SetDescription( 'Centros de Custos' )
	oModel:GetModel( 'CTT_MODEL' ):SetDescription( 'Centros de Custos' )
	oModel:GetModel( 'CTT_MODEL' ):SetOnlyQuery ( .T. )

Return oModel

Static Function IntegDef( cXml, cTypeTran, cTypeMsg, cVersion )

	Local oModel  := FwModelActive()
	Local cXmlRet := ''

	If cTypeMsg == EAI_MESSAGE_BUSINESS

		cXmlRet += '<BusinessEvent>'
		cXmlRet += '<Entity>COSTCENTER</Entity>'
		cXmlRet += '<Event>upsert</Event>'
		cXmlRet += '<Identification>'
		cXmlRet += '<key name="Code">'
		cXmlRet += AllTrim( oModel:GetModel( 'CTT_MODEL' ):GetValue( 'CTT_CUSTO' ) )
		cXmlRet += '</key>'
		cXmlRet += '</Identification>'
		cXmlRet += '</BusinessEvent>'
		cXmlRet += '<BusinessContent>'
		cXmlRet += oModel:GetXmlData(.T.,,,,,.T.)
		cXmlRet += '</BusinessContent>'

	End If

Return { .T., cXmlRet, 'COSTCENTER' }