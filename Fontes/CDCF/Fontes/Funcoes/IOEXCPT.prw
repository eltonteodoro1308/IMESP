#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOEXCPT
Função que registra uma User Exception e envia e-mail com a exception para lista de usuário definada na tabela ZX
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
@param cUUID, characters, UUID Documento Recebido
@param cMsg, characters, Mensagem de Erro durante o Processamento.
/*/
User Function IOEXCPT( cUUID, cMsg )

	Local oServer  := TMailManager():New()
	Local oMessage := TMailMessage():new()
	Local cTo      := ''
	Local aArea    := GetArea()
	Local aAreaSX5 := SX5->( GetArea() )
	Local aAreaSM0 := SM0->( GetArea() )

	Local cMSGMAIL := ''

	Local cRELSERV := GetMv( 'MV_RELSERV' ) // Nome do Servidor de Envio de E-mail utilizado nos relatorios
	Local nPORSMTP := GetMv( 'MV_PORSMTP' ) // Porta Servidor SMTP
	Local cRELAUTH := GetMv( 'MV_RELAUTH' ) // Servidor de EMAIL necessita de Autenticacão? Determina se o Servidor necessita de Autenticacão.

	Local cRELAUSR := GetMv( 'MV_RELAUSR' ) // Usuario para Autenticacao no Servidor de Email
	Local cRELAPSW := GetMv( 'MV_RELAPSW' ) // Senha para autenticacäo no servidor de e-mail

	Local lRELTLS  := GetMv( 'MV_RELTLS'  ) // Informe se o servidor de SMTP possui conexão do tipo segura ( SSL/TLS ).
	Local lRELSSL  := GetMv( 'MV_RELSSL'  ) // Define se o envio e recebimento de e-mails na rotina SPED utilizará conexão segura (SSL).

	Local cRELACNT := GetMv( 'MV_RELACNT' ) // Conta a ser utilizada no envio de E-Mail para os relatorios
	Local cRELPSW  := GetMv( 'MV_RELPSW'  ) // Senha da Conta de E-Mail para envio de relatorios

	// Montagem da mensagem de e-mail em HTML
	cMSGMAIL += '<!DOCTYPE html>'
	cMSGMAIL += '<html>'
	cMSGMAIL += '<head>'
	cMSGMAIL += '</head>'
	cMSGMAIL += '<body>'
	cMSGMAIL += '<table  cellspacing="0" cellpadding="10" border="1">'
	cMSGMAIL += '<tr bgcolor="#000000">'
	cMSGMAIL += '<th class="title" colspan="2"><font color="#FFFFFF" face="verdana">Dados do Documento EAI</font>'
	cMSGMAIL += '</th>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<td><font face="verdana">UUID</font></td>'
	cMSGMAIL += '<td><font face="verdana">' + cUUID + '</font></td>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<td><font face="verdana">Mensagem</font></td>'
	cMSGMAIL += '<td><font face="verdana">' + cMsg + '</font></td>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '</table>'
	cMSGMAIL += '</body>'
	cMSGMAIL += '</html>'

	DbSelectArea( 'SX5' )
	DbSetOrder( 1 )
	DbSeek( xFilial( 'SX5' ) + 'ZX')

	Do While ! SX5->( Eof() ) .And. SX5->X5_TABELA == 'ZX'

		cTo += AllTrim( Lower(SX5->X5_DESCRI) ) + ';'

		SX5->( DbSkip() )

	EndDo

	RestArea( aAreaSM0 )
	RestArea( aAreaSX5 )
	RestArea( aArea    )

	oServer:setUseSSL( lRELSSL )
	oServer:setUseTLS( lRELTLS )

	oServer:init( '', cRELSERV, cRELAUSR, cRELAPSW,, nPORSMTP )

	If oServer:SetSMTPTimeout( 10 ) != 0

		ConOut( 'Não foi possível definir tempo de espera.' )

		Return

	End If

	If oServer:smtpConnect() != 0

		ConOut( 'Não foi possível conectar ao servidor SMTP.' )

		oServer:smtpDisconnect()

		Return

	End If

	If oServer:smtpAuth( cRELACNT, cRELPSW ) # 0

		ConOut( 'Não foi possível autenticar o servidor SMTP.' )

		oServer:smtpDisconnect()

		Return

	End If

	oMessage:clear()

	oMessage:cFrom		:=	cRELACNT
	oMessage:cTo		:=	cTo
	oMessage:cSubject	:=	'Integração CDCF x PROTHEUS'
	oMessage:cBody		:=	cMSGMAIL

	If oMessage:send( oServer ) # 0

		ConOut( 'Não foi possível autenticar a mensagem de e-mail para o servidor SMTP.' )

		oServer:smtpDisconnect()

		Return

	End If

Return