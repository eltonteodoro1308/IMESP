#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

User Function QE030VLD()

	Local cRotInteg := GetRotInteg()

	SetRotInteg( 'UNITOFMEASURE' )

	FWIntegDef( 'QE030VLD', '20', '1', '', 'UNITOFMEASURE', .F., '1.000' )

	SetRotInteg( cRotInteg )

Return .T.

Static Function IntegDef( cXml, cTypeTran, cTypeMsg, cVersion )

	Local oModel  := FwModelActive()
	Local cXmlRet := ''

	If cTypeMsg != EAI_MESSAGE_WHOIS

		cXmlRet += '<BusinessEvent>'
		cXmlRet += '<Entity>UNITOFMEASURE</Entity>'
		cXmlRet += '<Event>upsert</Event>'
		cXmlRet += '<Identification>'
		cXmlRet += '<key name="Code">'
		cXmlRet += AllTrim( oModel:GetModel( 'SAHMASTER' ):GetValue( 'AH_UNIMED' ) )
		cXmlRet += '</key>'
		cXmlRet += '</Identification>'
		cXmlRet += '</BusinessEvent>'
		cXmlRet += '<BusinessContent>'
		cXmlRet += oModel:GetXmlData(.T.,,,,,.T.)
		cXmlRet += '</BusinessContent>'

	End If

Return { .T., cXmlRet, 'UNITOFMEASURE' }