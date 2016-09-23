#INCLUDE 'TOTVS.CH'
#INCLUDE 'APWEBSRV.CH'

WSSTRUCT RETORNO

	WSDATA MENSAGEM AS STRING

ENDWSSTRUCT

WSSERVICE MYEAI DESCRIPTION 'Web Service EAIC Teste' 

	WSDATA INMSG AS STRING
	WSDATA RESPOSTA AS RETORNO

	WSMETHOD RECEIVEMESSAGE DESCRIPTION 'Teste de recebimento de mensagem'

ENDWSSERVICE

WSMETHOD RECEIVEMESSAGE WSRECEIVE INMSG WSSEND RESPOSTA WSSERVICE MYEAI

	ConOut( ::INMSG )

	::RESPOSTA:MENSAGEM := ::INMSG

	//::RESPOSTA:MENSAGEM := '<TOTVSIntegrator><GlobalProduct>TOTVS|EAI</GlobalProduct><GlobalFunctionCode>EAI</GlobalFunctionCode><GlobalDocumentFunctionCode>MATA020</GlobalDocumentFunctionCode><GlobalDocumentFunctionDescription>FORNECEDORES</GlobalDocumentFunctionDescription><DocVersion>1.000</DocVersion><DocDateTime>2016-09-12T12:00:00Z</DocDateTime><DocIdentifier>9a54e460-676e-f5aa-3291-cbb6c1066c19</DocIdentifier><DocCompany>99</DocCompany><DocBranch>01</DocBranch><DocName/><DocFederalID/><DocType>1</DocType><Message><Layouts><Version>1.000</Version><Identifier>MATA020</Identifier><FunctionCode>U_IMSP020</FunctionCode><Content><MATA020 Operation="1" version="1.000" ><MATA020_SA2 modeltype="FIELDS"><A2_COD order="2"><value>F001</value></A2_COD><A2_LOJA order="3"><value>00</value></A2_LOJA></MATA020_SA2></MATA020></Content></Layouts></Message></TOTVSIntegrator>'

RETURN .T.
