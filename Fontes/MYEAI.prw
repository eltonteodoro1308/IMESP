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

	::RESPOSTA:MENSAGEM := Gravar( ::INMSG )

RETURN .T.

Static Function Gravar( cXml )

	Local cRet  := ''
	Local aArea := Nil 

	RpcSetEnv( "99","01" )
	
	aArea := GetArea() 

	ChkFile( 'ZZZ' )

	DbSelectArea( 'ZZZ' )

	If RecLock('ZZZ',.T.)

		ZZZ->ZZZ_DTTIME := Dtos( Date() ) + ' / ' + Time() 
		ZZZ->ZZZ_XML    := cXml

		MsUnlock()

		cRet := '<?xml version="1.0" encoding="UTF-8"?><MENSAGEM><CONTEUDO>FUNCIONOU</CONTEUDO></MENSAGEM>' 

	Else

		cRet := '<?xml version="1.0" encoding="UTF-8"?><MENSAGEM><CONTEUDO>ERRO</CONTEUDO></MENSAGEM>'

	End If

	RestArea( aArea )
	
	RpcClearEnv()

Return cRet
