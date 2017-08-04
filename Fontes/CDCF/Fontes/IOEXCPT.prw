#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} eMailExcep
Função que registra uma User Exception e envia e-mail com a exception para lista de usuário definada na tabela ZX
@author Elton Teodoro Alves
@since 12/02/2017
@version 12.1.014
@param cUUID, characters, UUID Documento Recebido
@param cMsg, characters, Mensagem de Erro durante o Processamento.
/*/
User Function IOEXCPT( cUUID, cMsg, cEmp )

	Local oServer  := TMailManager():New()
	Local oMessage := TMailMessage():new()
	Local cTo      := ''
	Local aArea    := Nil
	Local aAreaSX5 := Nil
	Local aAreaSM0 := Nil

	Local cMSGMAIL := ''

	Local cRELSERV := ''
	Local nPORSMTP := 0
	Local cRELAUTH := ''

	Local cRELAUSR := ''
	Local cRELAPSW := ''

	Local lRELTLS  := .F.
	Local lRELSSL  := .F.

	Local cRELACNT := ''
	Local cRELPSW  := ''

	Default cEmp := '99'

	If ! FWIsInCallStack( 'U_IOCDCF' )

		dbUseArea( .T. , 'TOPCONN',;
		'SX5' + cEmp + '0',;
		'SX5TMP', .T., .T.)


		dbUseArea( .T. , 'CTREECDX',;
		GetSrvProfString( 'STARTPATH', '\SYSTEM' ) +;
		'SX6' + cEmp + '0' + GetDbExtension(),;
		'SX6TMP', .T., .T.)

	Else

		aArea    := GetArea()
		aAreaSX5 := SX5->( GetArea() )
		aAreaSM0 := SM0->( GetArea() )

	End If

	cRELSERV := GetMv( 'MV_RELSERV' ) // Nome do Servidor de Envio de E-mail utilizado nos relatorios
	nPORSMTP := GetMv( 'MV_PORSMTP' ) // Porta Servidor SMTP
	cRELAUTH := GetMv( 'MV_RELAUTH' ) // Servidor de EMAIL necessita de Autenticacão? Determina se o Servidor necessita de Autenticacão.

	cRELAUSR := GetMv( 'MV_RELAUSR' ) // Usuario para Autenticacao no Servidor de Email
	cRELAPSW := GetMv( 'MV_RELAPSW' ) // Senha para autenticacäo no servidor de e-mail

	lRELTLS  := GetMv( 'MV_RELTLS'  ) // Informe se o servidor de SMTP possui conexão do tipo segura ( SSL/TLS ).
	lRELSSL  := GetMv( 'MV_RELSSL'  ) // Define se o envio e recebimento de e-mails na rotina SPED utilizará conexão segura (SSL).

	cRELACNT := GetMv( 'MV_RELACNT' ) // Conta a ser utilizada no envio de E-Mail para os relatorios
	cRELPSW  := GetMv( 'MV_RELPSW'  ) // Senha da Conta de E-Mail para envio de relatorios

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

	If ! FWIsInCallStack( 'U_IOCDCF' )

		SX6TMP->( DbCloseArea() )
		SX5TMP->( DbCloseArea() )

	Else

		RestArea( aAreaSM0 )
		RestArea( aAreaSX5 )
		RestArea( aArea    )

	End If

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