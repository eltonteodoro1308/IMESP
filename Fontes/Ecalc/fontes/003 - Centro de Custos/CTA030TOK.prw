#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

User Function CTA030TOK()

	Local nOpc    := PARAMIXB
	Local oModel  := FWLoadModel('CT030MOD')//ModelDef()
	//Local aFields := oModel:GetModel('CTT_MODEL'):GetStruct():GetFields()
	//Local aValues := {}
	//Local nX      := 0

	//	For nX := 1 To Len( aFields )
	//
	//		aAdd( aValues, { aFields[ nX, MPFormModel_IDFIELD ], Eval( &( '{||M->' + aFields[ nX, MODEL_FIELD_IDFIELD ] + '}' ) ) } )
	//
	//	Next nX
	//
		oModel:SetOperation( nOpc )

		oModel:Activate()
	//
	//	For nX := 1 To Len( aValues )
	//
	//		oModel:Setvalue( 'CTT_MODEL', aValues[ nX, 1 ], aValues[ nX, 2 ] )
	//
	//	Next nX

	oModel:Setvalue( 'CENTRODECUSTO', 'ID', M->CTT_CUSTO )
	oModel:Setvalue( 'CENTRODECUSTO', 'NOME', M->CTT_DESC01 )
	oModel:Setvalue( 'CENTRODECUSTO', 'ATIVO', If( M->CTT_BLOQ = '1', 'F', 'T' ) )

	If oModel:VldData()

		oModel:CommitData()

		//U_TSTCTB030( oModel )

	Else

		VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

	End If

	oModel:DeActivate()

Return .F.

Static Function ModelDef()

	Local oStru  := FWFormStruct( 1, 'CTT', { | cCampo | AllTrim(cCampo) $ 'CTT_FILIAL/CTT_CUSTO/CTT_DESC01/CTT_BLOQ/CTT_CLASSE'} )
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
		//cXmlRet += oModel:GetXmlData(.T.,,,,,.T.)
		cXmlRet += '<CENTRODECUSTO>'
		cXmlRet += '<ID>'
		cXmlRet += '<value>' + AllTrim( oModel:GetModel( 'CTT_MODEL' ):GetValue( 'CTT_CUSTO' ) ) + '</value>'
		cXmlRet += '</ID>'
		cXmlRet += '<NOME>'
		cXmlRet += '<value>' + AllTrim( oModel:GetModel( 'CTT_MODEL' ):GetValue( 'CTT_CUSTO' ) ) + '</value>'
		cXmlRet += '</NOME>'
		cXmlRet += '<ATIVO>'
		cXmlRet += '<value>' + AllTrim( oModel:GetModel( 'CTT_MODEL' ):GetValue( 'CTT_CUSTO' ) ) + '</value>'
		cXmlRet += '</ATIVO>'
		cXmlRet += '</CENTRODECUSTO>'
		cXmlRet += '</BusinessContent>'

	End If

Return { .T., cXmlRet, 'COSTCENTER' }