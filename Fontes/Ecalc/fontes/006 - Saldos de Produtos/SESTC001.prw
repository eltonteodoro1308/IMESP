#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

User Function SESTC001( aParam )

	Local cRotInteg := ''

	RpcSetEnv( aParam[1], aParam[2] )

	cRotInteg := GetRotInteg()

	SetRotInteg( 'STOCKBALANCE' )

	FWIntegDef( 'SESTC001', '20', '1', '', 'STOCKBALANCE', .F., '1.000' )

	SetRotInteg( cRotInteg )

	RpcClearEnv()

Return

Static Function IntegDef( cXml, cTypeTran, cTypeMsg, cVersion )

	Local cXmlRet := ''
	Local cSldPrd := ''
	Local cTrab   := GetNextAlias()
	Local aArea   := GetArea()
	Local nX      := 0


	BeginSQL Alias cTrab

	SELECT SB2.B2_COD, SUM(SB2.B2_QATU) B2_QATU
	FROM %Table:SB2% SB2
	WHERE SB2.B2_QATU <> 0
	AND SB2.FILIAL = %XFilial:SB2%
	AND SB2.%NotDel%
	GROUP BY SB2.B2_COD

	EndSQL

	VarInfo( 'GetLastQuery', GetLastQuery(),,.F. )

	cSldPrd += '<STOCKBALANCE Operation="1" version="1.01">'

	Do While ( cTrab )->( ! EOF() )

		cSldPrd += '<SB2_MODEL modeltype="GRID" order="' + ++nX + '">'

		cSldPrd += '<B2_COD order="1" >
		cSldPrd += '<value>
		cSldPrd += AllTrim( ( cTrab )->B2_COD )
		cSldPrd += '</value>
		cSldPrd += '</B2_COD>

		cSldPrd += '<B2_COD order="2" >
		cSldPrd += '<value>
		cSldPrd += cValToChar( ( cTrab )->B2_QATU  )
		cSldPrd += '</value>
		cSldPrd += '</B2_COD>

		cSldPrd += '</SB2_MODEL>'

	End Do

	cSldPrd += '</STOCKBALANCE>'

	( cTrab )->( DbCloseArea() )

	RestArea( aArea )

	If cTypeMsg != EAI_MESSAGE_WHOIS

		cXmlRet += '<BusinessEvent>'
		cXmlRet += '<Entity>STOCKBALANCE</Entity>'
		cXmlRet += '<Event>upsert</Event>'
		cXmlRet += '<Identification>'
		cXmlRet += '<key name="Code">'
		cXmlRet += ''//AllTrim( oModel:GetModel( '' ):GetValue( '' ) )
		cXmlRet += '</key>'
		cXmlRet += '</Identification>'
		cXmlRet += '</BusinessEvent>'
		cXmlRet += '<BusinessContent>'
		cXmlRet += cSldPrd
		cXmlRet += '</BusinessContent>'

	End If

Return { .T., cXmlRet, 'STOCKBALANCE' }