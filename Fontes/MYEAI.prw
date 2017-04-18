#INCLUDE 'TOTVS.CH'
#INCLUDE 'APWEBSRV.CH'

WSSTRUCT RETORNO

	WSDATA MENSAGEM AS STRING

ENDWSSTRUCT

WSSERVICE MYEAI DESCRIPTION 'Web Service EAIC Teste'

	WSDATA INMSG AS STRING
	WSDATA OUTMSG AS STRING

	WSMETHOD RECEIVEMESSAGE DESCRIPTION 'Teste de recebimento de mensagem'

ENDWSSERVICE

WSMETHOD RECEIVEMESSAGE WSRECEIVE INMSG WSSEND OUTMSG WSSERVICE MYEAI

	::OUTMSG := Gravar( ::INMSG )

RETURN .T.

Static Function Gravar( cXml )

	Local cRet  := ''
	Local aArea := Nil
	Local cDia  := PadL( cValToChar( Day  ( Date() ) ), 2, '0' )
	Local cMes  := PadL( cValToChar( Month( Date() ) ), 2, '0' )
	Local cAno  := cValToChar( Year( Date() ) )
	Local oXml  := TXmlManager():New()

	//RpcSetEnv( "99","01" )

	//aArea := GetArea()

	//ChkFile( 'ZZZ' )

	//DbSelectArea( 'ZZZ' )

	//RecLock('ZZZ',.T.)

	//ZZZ->ZZZ_DTTIME := cDia + '/' + cMes + '/' + cAno + ' - ' + Time()
	//ZZZ->ZZZ_XML    := cXml

	//MsUnlock()

	oXml:Parse( cXml )

	//cRet += '<![CDATA['
	cRet += '<?xml version="1.0" encoding="UTF-8"?>'
	cRet += '<TOTVSMessage>'
	cRet += '<MessageInformation version="1.000">'
	cRet += '<UUID>' + FWUUIDV4(.T.) + '</UUID>'
	cRet += '<Type>ResponseMessage</Type>'
	cRet += '<Transaction>' + oXml:XPathGetNodeValue( '/TOTVSMessage/MessageInformation/Transaction' ) + '</Transaction>'
	cRet += '<StandardVersion>1.000</StandardVersion>'
	cRet += '<SourceApplication>ENVIRONMENT</SourceApplication>'
	cRet += '<CompanyId>99</CompanyId>'
	cRet += '<BranchId>01</BranchId>'
	cRet += '<Product name="PROTHEUS" version="12"/>'
	cRet += '<DeliveryType>Sync</DeliveryType>'
	cRet += '<GeneratedOn>' + cAno + '-' + cMes + '-' + cDia + 'T' + Time() + '</GeneratedOn>'
	cRet += '</MessageInformation>'
	cRet += '<ResponseMessage>'
	cRet += '<ReceivedMessage>'
	cRet += '<SentBy>PROTHEUS</SentBy>'
	cRet += '<UUID>' + oXml:XPathGetNodeValue( '/TOTVSMessage/MessageInformation/UUID' ) + '</UUID>'
	cRet += '<MessageContent>'
	cRet += '<![CDATA['
	cRet += cXml
	cRet += ']]>'
	cRet += '</MessageContent>'
	cRet += '</ReceivedMessage>'
	cRet += '<ProcessingInformation>'
	cRet += '<ProcessedOn>' + cAno + '-' + cMes + '-' + cDia + 'T' + Time() + '</ProcessedOn>'
	cRet += '<Status>OK</Status>'
	cRet += '<ListOfMessages>'
	cRet += '<Message type="WARNING" code="00">Executado com Sucesso</Message>'
	cRet += '</ListOfMessages>'
	cRet += '</ProcessingInformation>'
	cRet += '<ReturnContent>'
	cRet += '<Status>Incluido</Status>'
	cRet += '</ReturnContent>'
	cRet += '</ResponseMessage>'
	cRet += '</TOTVSMessage>'
	//cRet += ']]>'

	//RestArea( aArea )

	//RpcClearEnv()

Return cRet
