#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IFINM001
User Function que envia e-mail com a carta de cobrança anexa para o e-mail do cliente
@author Elton Teodoro Alves
@since 19/12/2016
@version 12.1.007
@param cAnexo, characters, caminho o onde o PDF da carta de cobrança foi salvo
@param cTo, characters, e-mail para envio do email
/*/
User Function IFINM001( cAnexo, cTo )

	Local oServer  := TMailManager():New()
	Local oMessage := TMailMessage():new()
	Local cAlert   := ''

	Local cMSGCOBR  := GetMv( 'MV_MSGCOBR' ) // Mensagem Email de Cobrança

	Local cRELSERV  := GetMv( 'MV_RELSERV' ) // Nome do Servidor de Envio de E-mail utilizado nos relatorios
	Local nPORSMTP  := GetMv( 'MV_PORSMTP' ) // Porta Servidor SMTP
	Local cRELAUTH  := GetMv( 'MV_RELAUTH' ) // Servidor de EMAIL necessita de Autenticacão? Determina se o Servidor necessita de Autenticacão.

	Local cRELAUSR  := GetMv( 'MV_RELAUSR' ) // Usuario para Autenticacao no Servidor de Email
	Local cRELAPSW  := GetMv( 'MV_RELAPSW' ) // Senha para autenticacäo no servidor de e-mail

	Local lRELTLS   := GetMv( 'MV_RELTLS'  ) // Informe se o servidor de SMTP possui conexão do tipo segura ( SSL/TLS ).
	Local lRELSSL   := GetMv( 'MV_RELSSL'  ) // Define se o envio e recebimento de e-mails na rotina SPED utilizará conexão segura (SSL).

	Local cRELACNT  := GetMv( 'MV_RELACNT' ) // Conta a ser utilizada no envio de E-Mail para os relatorios
	Local cRELPSW   := GetMv( 'MV_RELPSW'  ) // Senha da Conta de E-Mail para envio de relatorios

	oServer:setUseSSL( lRELSSL )
	oServer:setUseTLS( lRELTLS )

	oServer:init( '', cRELSERV, cRELAUSR, cRELAPSW,, nPORSMTP )

	If oServer:SetSMTPTimeout( 10 ) != 0

		Alert( 'Não foi possível definir tempo de espera.' )

		Return

	End If

	If oServer:smtpConnect() != 0

		Alert( 'Não foi possível conectar ao servidor SMTP.' )

		oServer:smtpDisconnect()

		Return

	End If

	If oServer:smtpAuth( cRELACNT, cRELPSW ) # 0

		Alert( 'Não foi possível autenticar o servidor SMTP.' )

		oServer:smtpDisconnect()

		Return

	End If

	oMessage:clear()

	oMessage:cFrom		:=	cRELACNT
	oMessage:cTo		:=	cTo
	oMessage:cSubject	:=	cMSGCOBR
	oMessage:cBody		:=	cMSGCOBR

	If oMessage:AttachFile( cAnexo ) == -1

		Alert( 'Não foi possível autenticar o servidor SMTP.' )

		oServer:smtpDisconnect()

		Return

	End If

	If oMessage:send(oServer) # 0

		Alert( 'Não foi possível autenticar a mensagem de e-mail para o servidor SMTP.'  )

		oServer:smtpDisconnect()

		Return

	End If

return