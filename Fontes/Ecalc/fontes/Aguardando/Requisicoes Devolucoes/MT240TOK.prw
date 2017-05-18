#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

user function MT240TOK()

	Local oModel  := ModelDef()
	Local aFields := oModel:GetModel('SD3_MODEL'):GetStruct():GetFields()
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

		oModel:Setvalue( 'SD3_MODEL', aValues[ nX, 1 ], aValues[ nX, 2 ] )

	Next nX

	oModel:VldData()

	oModel:CommitData()

	oModel:DeActivate()

return .T.

Static Function ModelDef()

	Local oModel

	Local oStr1:= FWFormStruct(1,'SD3', { | cCampo | GetSX3Cache( cCampo, 'X3_CONTEXT' ) # 'V' } )
	oModel := MPFormModel():New('INVENTORYMOVIMENT')
	oModel:SetDescription('Movimentação de Estoque')
	oModel:addFields('SD3_MODEL',,oStr1)
	oModel:getModel('SD3_MODEL'):SetDescription('Movimentação de Estoque')
	oModel:SetPrimaryKey({ 'D3_COD' })

Return oModel

Static Function IntegDef(cXml, cTypeTran, cTypeMsg, cVersion)

	Local lRet    := .T.
	Local oModel  := Nil
	Local cXmlRet := ''

	If cTypeMsg == EAI_MESSAGE_BUSINESS

		oModel := FwModelActive()

		cXmlRet += '<BusinessEvent>'
		cXmlRet += '<Entity>INVENTORYMOVIMENT</Entity>'
		cXmlRet += '<Event>upsert</Event>'
		cXmlRet += '<Identification>'
		cXmlRet += '<key name="Code">'
		cXmlRet += AllTrim( oModel:GetModel( 'SD3_MODEL' ):GetValue( 'D3_COD' ) )
		cXmlRet += '</key>'
		cXmlRet += '</Identification>'
		cXmlRet += '</BusinessEvent>'
		cXmlRet += '<BusinessContent>'
		cXmlRet += oModel:GetXmlData(.T.,,,,,.T.)
		cXmlRet += '</BusinessContent>'

	End If

Return { lRet, cXmlRet, 'INVENTORYMOVIMENT' }