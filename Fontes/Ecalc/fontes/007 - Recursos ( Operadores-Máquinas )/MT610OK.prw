#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

User Function MT610OK()

	Local nOpc    := PARAMIXB[ 1 ]
	Local lRet    := cValToChar( nOpc ) $ '34'
	Local oModel  := Nil 
	Local aFields := {} 
	Local aValues := {}
	Local nX      := 0

	If ! lRet

		ApMsgStop ( 'Não é Permitido Excluir Recursos !!!', 'Atenção !!!' )

	Else

		oModel  := ModelDef()
		aFields := oModel:GetModel('SH1_MODEL'):GetStruct():GetFields()

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

			oModel:SetValue( 'SH1_MODEL', aValues[ nX, 1 ], aValues[ nX, 2 ] )

		Next nX

		oModel:VldData()

		oModel:CommitData()

		oModel:DeActivate()

	End If

Return lRet

Static Function ModelDef()

	Local oStru  := FWFormStruct( 1, 'SH1' )
	Local oModel := MPFormModel():New( 'RESOURCES' )

	oModel:AddFields( 'SH1_MODEL',, oStru )
	oModel:SetDescription( 'Cadastro de Recursos' )
	oModel:GetModel( 'SH1_MODEL' ):SetDescription( 'Cadastro de Recursos' )
	oModel:GetModel( 'SH1_MODEL' ):SetOnlyQuery ( .T. )
	oModel:SetPrimaryKey( { 'H1_FILIAL', 'H1_CODIGO' } )

Return oModel

Static Function IntegDef(cXml, cTypeTran, cTypeMsg, cVersion)

	Local lRet    := .T.
	Local oModel  := Nil
	Local cXmlRet := ''

	If cTypeMsg == EAI_MESSAGE_BUSINESS

		oModel := FwModelActive()

		cXmlRet += '<BusinessEvent>'
		cXmlRet += '<Entity>RESOURCES</Entity>'
		cXmlRet += '<Event>upsert</Event>'
		cXmlRet += '<Identification>'
		cXmlRet += '<key name="Code">'
		cXmlRet += AllTrim( oModel:GetModel( 'SH1_MODEL' ):GetValue( 'H1_CODIGO' ) )
		cXmlRet += '</key>'
		cXmlRet += '</Identification>'
		cXmlRet += '</BusinessEvent>'
		cXmlRet += '<BusinessContent>'
		cXmlRet += oModel:GetXmlData(.T.,,,,,.T.)
		cXmlRet += '</BusinessContent>'

	End If

Return { lRet, cXmlRet, 'RESOURCES' }