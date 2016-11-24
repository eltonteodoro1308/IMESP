#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

User Function PNA020GRV()

	Local aParam  := PARAMIXB
	Local oModel  := ModelDef()
	Local aFields := oModel:GetModel('SP3_MODEL'):GetStruct():GetFields()
	Local aValues := {}
	Local nX      := 0

	If ! aParam[ 4 ] + 2  == MODEL_OPERATION_DELETE

		For nX := 1 To Len( aFields )

			aAdd( aValues, { aFields[ nX, MODEL_FIELD_IDFIELD ], Eval( &( '{||SP3->' + aFields[ nX, MODEL_FIELD_IDFIELD ] + '}' ) ) } )

		Next nX

	End If

	oModel:SetOperation( aParam[ 4 ] + 2 )

	oModel:Activate()

	If ! aParam[ 4 ] + 2  == MODEL_OPERATION_DELETE

		For nX := 1 To Len( aValues )

			oModel:SetValue( 'SP3_MODEL', aValues[ nX, 1 ], aValues[ nX, 2 ] )

		Next nX

	End If

	oModel:VldData()

	oModel:CommitData()

	oModel:DeActivate()


Return

Static Function ModelDef()

	Local oStru  := FWFormStruct( 1, 'SP3' )
	Local oModel := MPFormModel():New( 'HOLIDAY' )

	oStru:SetProperty( '*' , MODEL_FIELD_VALID  , {||.T.} )
	oStru:SetProperty( '*' , MODEL_FIELD_VALUES , {} )

	oModel:AddFields( 'SP3_MODEL',, oStru )
	oModel:SetDescription( 'Cadastro de Feriados' )
	oModel:GetModel( 'SP3_MODEL'):SetDescription( 'Cadastro de Feriados' )
	oModel:GetModel( 'SP3_MODEL' ):SetOnlyQuery ( .T. )

Return oModel

Static Function IntegDef(cXml, cTypeTran, cTypeMsg, cVersion)

	Local lRet    := .T.
	Local oModel  := Nil
	Local cXmlRet := ''

	If cTypeMsg == EAI_MESSAGE_BUSINESS

		oModel := FwModelActive()

		cXmlRet += '<BusinessEvent>'
		cXmlRet += '<Entity>HOLIDAY</Entity>'
		cXmlRet += '<Event>' + If(oModel:GetOperation() == 5,'delete','upsert')  + '</Event>'
		cXmlRet += '<Identification>'
		cXmlRet += '<key name="Code">'
		cXmlRet += DTOS( oModel:GetModel( 'SP3_MODEL' ):GetValue( 'P3_DATA' ) )
		cXmlRet += '</key>'
		cXmlRet += '</Identification>'
		cXmlRet += '</BusinessEvent>'
		cXmlRet += '<BusinessContent>'
		cXmlRet += oModel:GetXmlData(.T.,,,,,.T.)
		cXmlRet += '</BusinessContent>'

	End If

Return { lRet, cXmlRet, 'HOLIDAY' }