#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

User Function FATA110()

	If PARAMIXB[ 2 ] == 'MODELPOS' .And. PARAMIXB[ 1 ]:nOperation == MODEL_OPERATION_DELETE

		Help(,, 'Help',, 'Não é Permitido Excluir Grupo de Clientes !!!', 1, 0 )

		Return .F.

	End If

Return .T.

Static Function IntegDef( cXml, cTypeTran, cTypeMsg, cVersion )

	Local oModel  := FwModelActive()
	Local cXmlRet := ''

	If cTypeMsg == EAI_MESSAGE_BUSINESS

		cXmlRet += '<BusinessEvent>'
		cXmlRet += '<Entity>GROUPOFCLIENTS</Entity>'
		cXmlRet += '<Event>upsert</Event>'
		cXmlRet += '<Identification>'
		cXmlRet += '<key name="Code">'
		cXmlRet += AllTrim( oModel:GetModel( 'ACYMASTER' ):GetValue( 'ACY_GRPVEN' ) )
		cXmlRet += '</key>'
		cXmlRet += '</Identification>'
		cXmlRet += '</BusinessEvent>'
		cXmlRet += '<BusinessContent>'
		cXmlRet += oModel:GetXmlData(.T.,,,,,.T.)
		cXmlRet += '</BusinessContent>'

	End If

Return { .T., cXmlRet, 'GROUPOFCLIENTS' }