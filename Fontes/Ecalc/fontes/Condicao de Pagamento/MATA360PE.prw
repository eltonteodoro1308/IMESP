#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

user function MATA360()

	Local xRet := Nil 

	//	If PARAMIXB[ 2 ] == 'MODELPOS' .And. PARAMIXB[ 1 ]:nOperation == MODEL_OPERATION_DELETE
	//
	//		Help(,, 'Help',, 'Não é Permitido Excluir Condiçao de Pagamento !!!', 1, 0 )
	//
	//		Return .F.
	//
	//	End If

	If PARAMIXB[ 2 ] == 'BUTTONBAR'

		Return {}

	Else

		Return .T.

	EndIf

return xRet

Static Function IntegDef( cXml, cTypeTran, cTypeMsg, cVersion )

	Local oModel  := FwModelActive()
	Local cXmlRet := ''

	If cTypeMsg == EAI_MESSAGE_BUSINESS

		cXmlRet += '<BusinessEvent>'
		cXmlRet += '<Entity>PAYMENTCONDITION</Entity>'
		cXmlRet += '<Event>upsert</Event>'
		cXmlRet += '<Identification>'
		cXmlRet += '<key name="Code">'
		cXmlRet += AllTrim( oModel:GetModel( 'SE4MASTER' ):GetValue( 'E4_CODIGO' ) )
		cXmlRet += '</key>'
		cXmlRet += '</Identification>'
		cXmlRet += '</BusinessEvent>'
		cXmlRet += '<BusinessContent>'
		cXmlRet += oModel:GetXmlData(.T.,,,,,.T.)
		cXmlRet += '</BusinessContent>'

	End If

Return { .T., cXmlRet, 'PAYMENTCONDITION' }