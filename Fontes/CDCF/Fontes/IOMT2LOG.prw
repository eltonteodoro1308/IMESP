#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} IOMT2LOG
Registra o Log da Requisição de integração com o CDCF e envia e-mail com erro no processamento
para as contas definidas na tabela genéria ZX caso o ZX1_STATUS seja definido como 1, 2 ou 3
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@param cUUID, characters, UUID Documento Recebido
@param cEmpPrc, characters, Empresa de Processamento
@param cFilPrc, characters, Filial de Processamento
@param dDataRe, date, Data do Recebimento do Documento
@param cHoraRe, characters, Hora do Recebimento do Documento
@param cMetodo, characters, Metodo CDCF Invocado no WebSercice
@param cStatus, characters, Status Do Processamento, Lista de Opções:
0=Aguardando Importação
1=Erro Comunicação CDCF
2=Erro Processamento XML
3=Importação Com Falhas
4=Importado
@param cXmlRec, characters, XML Recebido pelo WebService do EAI com a Requisição de buscar no CDCF o cadastro de Clientes para Integrar.
@param cParams, characters, Parametros Enviados Pelo EAI, indicando quais os clientes que devem ser incluídos ou que tiveram alguma atualização com o CDCF.
@param dDataPr, date, Data do Processamento do XML retornado pelo método do CDCF
@param cHoraPr, characters, Hora do Processamento do XML retornado pelo método do CDCF
@param cXmlPrc, characters, XML de Processamento retornado pelo método invocado no WebService do CDCF
@param cObserv, characters, Observações do Processamento. Registro de erros e alertas durante todo o processo de integração
@param aLogCli, array, Array com os dados dos Clientes e seus contatos processados na integração, composto por:
[N,1] - Código ERP do Cliente
[N,2] - Código CDCF do Cliente
[N,3] - Razão Social do Cliente
[N,4] - Nome Fantasia do Cliente
[N,5] - Observação de Integração do ExecAuto
[N,6] - Status de Integração do ExecAuto
[N,7] - Array do ExecAuto
[N,M,1] - Código CDCF do Contato
[N,M,2] - Nome do Contato
[N,M,3] - Observção
[N,M,4] - Importado 1=Sim/2=Não
@return logical, Indica se a gravação do registro ocorreu sem erros.
/*/
User Function IOMT2LOG( cUUID, cEmpPrc, cFilPrc, dDataRe, cHoraRe, cMetodo, cStatus, cXmlRec, cParams, dDataPr, cHoraPr, cXmlPrc, cObserv, aLogCli )

	Local lRet   := .T.
	Local oModel := ModelDef()
	Local aArea  := GetArea()
	Local nX     := 0
	Local nY     := 0

	DbSelectArea( 'ZX1' )
	DbSetOrder( 2 )

	If DbSeek( xFilial( 'ZX1' ) + cUUID )

		oModel:SetOperation( MODEL_OPERATION_UPDATE )

	Else

		oModel:SetOperation( MODEL_OPERATION_INSERT )

	End If

	oModel:Activate()

	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_UUID'  , cUUID   )
	If ( ValType( cEmpPrc  ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_EMPPRC', cEmpPrc  ), Nil )
	If ( ValType( cFilPrc  ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_FILPRC', cFilPrc  ), Nil )
	If ( ValType( dDataRe  ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_DATARE', dDataRe  ), Nil )
	If ( ValType( cHoraRe  ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_HORARE', cHoraRe  ), Nil )
	If ( ValType( cMetodo  ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_METODO', cMetodo  ), Nil )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_STATUS', cStatus )
	If ( ValType( cXmlRec  ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_XMLREC', cXmlRec  ), Nil )
	If ( ValType( cParams  ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_PARAMS', cParams  ), Nil )
	If ( ValType( dDataPr  ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_DATAPR', dDataPr  ), Nil )
	If ( ValType( cHoraPr  ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_HORAPR', cHoraPr  ), Nil )
	If ( ValType( cXmlPrc  ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_XMLPRC', cXmlPrc  ), Nil )
	If ( ValType( cObserv  ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_OBSERV', cObserv  ), Nil )

	If ! Empty( aLogCli )

		For nX := 1 To Len( aLogCli )

			If nX > 1

				oModel:GetModel( 'ZX2_GRID_MODEL' ):AddLine()

			EndIf

			oModel:SetValue( 'ZX2_GRID_MODEL', 'ZX2_ITEM'   , StrZero( nX, TamSx3( 'ZX2_ITEM' )[ 1 ] ) )
			oModel:SetValue( 'ZX2_GRID_MODEL', 'ZX2_CODERP' , aLogCli[ nX, 1 ] )
			oModel:SetValue( 'ZX2_GRID_MODEL', 'ZX2_CODCDC' , aLogCli[ nX, 2 ] )
			oModel:SetValue( 'ZX2_GRID_MODEL', 'ZX2_RAZAO'  , aLogCli[ nX, 3 ] )
			oModel:SetValue( 'ZX2_GRID_MODEL', 'ZX2_FANTAS' , aLogCli[ nX, 4 ] )
			oModel:SetValue( 'ZX2_GRID_MODEL', 'ZX2_OBSERV' , aLogCli[ nX, 5 ] )
			oModel:SetValue( 'ZX2_GRID_MODEL', 'ZX2_STATUS' , aLogCli[ nX, 6 ] )
			oModel:SetValue( 'ZX2_GRID_MODEL', 'ZX2_ARREXE' , aLogCli[ nX, 7 ] )

			For nY := 1 To Len( aLogCli[ nX, 8 ] )

				If nY > 1

					oModel:GetModel( 'ZX3_GRID_MODEL' ):AddLine()

				EndIf

				oModel:SetValue( 'ZX3_GRID_MODEL', 'ZX3_ITEM'   , StrZero( nY, TamSx3( 'ZX3_ITEM' )[ 1 ] ) )
				oModel:SetValue( 'ZX3_GRID_MODEL', 'ZX3_CODCDC' , aLogCli[ nX, 8, nY, 1 ] )
				oModel:SetValue( 'ZX3_GRID_MODEL', 'ZX3_NOME'   , aLogCli[ nX, 8, nY, 2 ] )
				oModel:SetValue( 'ZX3_GRID_MODEL', 'ZX3_OBSERV' , aLogCli[ nX, 8, nY, 3 ] )
				oModel:SetValue( 'ZX3_GRID_MODEL', 'ZX3_IMPORT' , aLogCli[ nX, 8, nY, 4 ] )
				oModel:SetValue( 'ZX3_GRID_MODEL', 'ZX3_ARREXE' , aLogCli[ nX, 8, nY, 5 ] )

			Next nY

		Next nX

	End If

	If lRet := oModel:VldData()

		oModel:CommitData()

		// Caso tenho ocorre erro no processamento envia email
		If cStatus $ '123'

			IOMT2MAIL( cUUID, ZX1->ZX1_EMPPRC, ZX1->ZX1_FILPRC,ZX1->ZX1_DATARE, ZX1->ZX1_HORARE, ZX1->ZX1_METODO, cStatus, dDataPr, cHoraPr, cObserv )

		End If

	Else

		VarInfo( 'oModel:GetErrorMessage()', oModel:GetErrorMessage(),, .F., .T. )

	End If

	oModel:DeActivate()

	RestArea( aArea )

Return lRet

/*/{Protheus.doc} IOMT2MAIL
Funcao que envia e-mail com Log de erro durante processamento do
documento de requisição de integração com o CDCF para as contas
definidas na tabela genérica ZX
@author Elton Teodoro Alves
@since 10/02/2017
@version 12.1.014
@param cUUID, characters, UUID Documento Recebido
@param dDataRe, date, Data do Recebimento do Documento
@param cHoraRe, characters, Hora do Recebimento do Documento
@param cMetodo, characters, Metodo CDCF Invocado no WebSercice
@param cStatus, characters, Status Do Processamento, Lista de Opções:
1=Erro Comunicação CDCF
2=Erro Processamento XML
3=Falha durante Importação
@param dDataPr, date, Data do Processamento do XML retornado pelo método do CDCF
@param cHoraPr, characters, Hora do Processamento do XML retornado pelo método do CDCF
@param cObserv, characters, Observações do Processamento. Registro de erros e alertas durante todo o processo de integração
/*/
Static Function IOMT2MAIL( cUUID, cEmpPrc, cFilPrc, dDataRe, cHoraRe, cMetodo, cStatus, dDataPr, cHoraPr, cObserv )

	Local oServer  := TMailManager():New()
	Local oMessage := TMailMessage():new()
	Local aStatus  := { '1=Erro Comunicação CDCF', '2=Erro Processamento XML', '3=Falha durante Importação' }
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
	cMSGMAIL += '<th class="title" colspan="2"><font color="#FFFFFF" face="verdana">Dados do Documento de Requisição</font>'
	cMSGMAIL += '</th>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<td><font face="verdana">UUID Documento Recebido</font></td>'
	cMSGMAIL += '<td><font face="verdana">' + cUUID + '</font></td>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<td><font face="verdana">Empresa de Processamento</font></td>'
	cMSGMAIL += '<td><font face="verdana">' + cEmpPrc + ' - ' + Posicione( 'SM0', 1, cEmpPrc + cFilPrc, 'M0_NOME' ) + '</font></td>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<td><font face="verdana">Filial de Processamento</font></td>'
	cMSGMAIL += '<td><font face="verdana">' + cFilPrc + ' - ' + Posicione( 'SM0', 1, cEmpPrc + cFilPrc, 'M0_FILIAL' ) + '</font></td>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<td><font face="verdana">Data do Recebimento</font></td>'
	cMSGMAIL += '<td><font face="verdana">' + dtoc( dDataRe ) + '</font></td>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<td><font face="verdana">Hora do Recebimento</font></td>'
	cMSGMAIL += '<td><font face="verdana">' + cHoraRe + '</font></td>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<td><font face="verdana">Metodo CDCF</font></td>'
	cMSGMAIL += '<td><font face="verdana">' + cMetodo + '</font></td>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<td><font face="verdana">Status</font></td>'
	cMSGMAIL += '<td><font face="verdana">' + aStatus[ Val( cStatus ) ] + '</font></td>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<td><font face="verdana">Data do Processamento</font></td>'
	cMSGMAIL += '<td><font face="verdana">' + dtoc( dDataPr ) + '</font></td>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<td><font face="verdana">Hora do Processamento</font></td>'
	cMSGMAIL += '<td><font face="verdana">' + cHoraPr + '</font></td>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<td><font face="verdana">Observações</font></td>'
	cMSGMAIL += '<td><font face="verdana">' + cObserv + '</font></td>'
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

	End Do

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
	oMessage:cSubject	:=	'Erro na Integração CDCF x PROTHEUS'
	oMessage:cBody		:=	cMSGMAIL

	If oMessage:send( oServer ) # 0

		ConOut( 'Não foi possível autenticar a mensagem de e-mail para o servidor SMTP.' )

		oServer:smtpDisconnect()

		Return

	End If

Return

/*/{Protheus.doc} ModelDef
Função de Retorno Modelo de dados da Tabela ZX1.
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@return Object, Modelo de dados da Tabela ZX1
/*/
Static Function ModelDef()

	Local oModel  := MPFormModel():New( 'ZX1_MODEL' )
	Local oStrZX1 := FWFormStruct( 1, 'ZX1' )
	Local oStrZX2 := FWFormStruct( 1, 'ZX2' )
	Local oStrZX3 := FwFormStruct( 1, 'ZX3' )

	oModel:SetDescription( 'LOG DE INTEGRAÇÃO CDCF' )

	oModel:addFields( 'ZX1_FIELD_MODEL',                  , oStrZX1 )
	oModel:AddGrid  ( 'ZX2_GRID_MODEL' , 'ZX1_FIELD_MODEL', oStrZX2 )
	oModel:AddGrid  ( 'ZX3_GRID_MODEL' , 'ZX2_GRID_MODEL' , oStrZX3 )

	oModel:GetModel( 'ZX2_GRID_MODEL' ):SetOptional( .T. )
	oModel:GetModel( 'ZX3_GRID_MODEL' ):SetOptional( .T. )

	oModel:SetRelation( 'ZX2_GRID_MODEL', { { 'ZX2_FILIAL', 'ZX1_FILIAL' }, { 'ZX2_CODIGO' , 'ZX1_CODIGO' } }, ZX2->(IndexKey(1)) )
	oModel:SetRelation( 'ZX3_GRID_MODEL', { { 'ZX3_FILIAL', 'ZX2_FILIAL' }, { 'ZX3_CODIGO', 'ZX2_CODIGO' },	{ 'ZX3_ITEMCL', 'ZX2_ITEM' } }, ZX3->(IndexKey(1)) )

Return oModel