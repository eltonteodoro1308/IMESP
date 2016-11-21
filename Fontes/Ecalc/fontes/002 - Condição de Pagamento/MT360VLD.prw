#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

User Function MT360VLD()

	Local cRotInteg := GetRotInteg()

	SetRotInteg( 'PAYMENTCONDITION' )

	FWIntegDef( 'MT360VLD', '20', '1', '', 'PAYMENTCONDITION', .F., '1.000' )

	SetRotInteg( cRotInteg )

Return .T.

Static Function IntegDef( cXml, cTypeTran, cTypeMsg, cVersion )

	Local oModel  := FwModelActive()
	Local cXmlRet := ''

	If cTypeMsg != EAI_MESSAGE_WHOIS

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

