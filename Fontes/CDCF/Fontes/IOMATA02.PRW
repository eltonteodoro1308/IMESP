#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} IOMATA02
Rotina de Controle de Log de Recebimento e Processamento de Rquisições do CDCF
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
/*/
User Function IOMATA02()

	Local oBrowse := FwMBrowse():New()

	oBrowse:SetAlias( 'ZX1' )
	oBrowse:SetDescription( 'LOG de Integração com CDCF' )

	oBrowse:AddLegend( 'ZX1_STATUS = "0"', 'GREEN' ,'Aguardando Importação'    )
	oBrowse:AddLegend( 'ZX1_STATUS = "1"', 'BLACK' ,'Erro Comunicação CDCF'    )
	oBrowse:AddLegend( 'ZX1_STATUS = "2"', 'RED'   ,'Erro Processamento XML'   )
	oBrowse:AddLegend( 'ZX1_STATUS = "3"', 'YELLOW','Falha durante Importacao' )
	oBrowse:AddLegend( 'ZX1_STATUS = "4"', 'WHITE' ,'Importado'                )

	oBrowse:Activate()

Return

/*/{Protheus.doc} MenuDef
Função de Retorno do Menu do Browse da Rotina
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@return Array, Array com as Rotinas do menu do Browse
/*/
Static Function MenuDef()

	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar'              , 'VIEWDEF.IOMATA02', 0, 2, 0, Nil } )
	aAdd( aRotina, { 'XML Requisição'          , 'U_IOMT02EX("1")'  , 0, 6, 0, Nil } )
	aAdd( aRotina, { 'XML CDCF'                , 'U_IOMT02EX("2")'  , 0, 6, 0, Nil } )
	aAdd( aRotina, { 'Array ExecAuto'          , 'U_IOMT02EX("3")'  , 0, 6, 0, Nil } )
	aAdd( aRotina, { 'Enviar p/ Fila Novamente', 'U_IOMT02EX("4")'  , 0, 6, 0, Nil } )

Return aRotina

/*/{Protheus.doc} function_method_class_name
Função de Retorno Modelo de dados da Tabela ZX1.
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@return Object, Modelo de dados da Tabela ZX1
/*/
Static Function ModelDef()

	Local oModel  := MPFormModel():New( 'ZX1_MODEL' )
	Local oStruct := FWFormStruct( 1, 'ZX1' )

	oModel:SetDescription( 'LOG DE INTEGRAÇÃO CDCF' )
	oModel:addFields( 'ZX1_FIELD_MODEL', , oStruct )

Return oModel

/*/{Protheus.doc} ViewDef
Função de Retorno da View do Modelo de dados da Tabela ZX1..
@author elton.alves
@since 08/02/2017
@version undefined
@return Object, View do Modelo de dados da Tabela ZX1
/*/
Static Function ViewDef()

	Local oView   := FWFormView():New()
	Local oModel  := ModelDef()
	Local oStruct := FWFormStruct( 2, 'ZX1' )

	oView:SetModel( oModel )
	oView:AddField( 'ZX1_FIELD_VIEW', oStruct, 'ZX1_FIELD_MODEL' )
	oView:CreateHorizontalBox( 'BOX_ZX1_FIELD_VIEW', 100)
	oView:SetOwnerView( 'ZX1_FIELD_VIEW', 'BOX_ZX1_FIELD_VIEW' )

Return oView

/*/{Protheus.doc} IOMT2LOG
Registra o Log da Requisição de integração com o CDCF e envia e-mail com erro no processamento
para as contas definidas na tabela genéria ZX caso o ZX1_STATUS seja definido como 1, 2 ou 3
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@param cUUID, characters, UUID Documento Recebido
@param dDataRe, date, Data do Recebimento do Documento
@param cHoraRe, characters, Hora do Recebimento do Documento
@param cMetodo, characters, Metodo CDCF Invocado no WebSercice
@param cStatus, characters, Status Do Processamento, Lista de Opções:
0=Aguardando Importação
1=Erro Comunicação CDCF
2=Erro Processamento XML
3=Falha durante Importação
4=Importado
@param cConfir, characters, Integração Confirmada no CDCF ? 1=Sim 2=Não
@param cXmlRec, characters, XML Recebido pelo WebService do EAI com a Requisição de buscar no CDCF o cadastro de Clientes para Integrar.
@param cParams, characters, Parametros Enviados Pelo EAI, indicando quais os clientes que devem ser incluídos ou que tiveram alguma atualização com o CDCF.
@param dDataPr, date, Data do Processamento do XML retornado pelo método do CDCF
@param cHoraPr, characters, Hora do Processamento do XML retornado pelo método do CDCF
@param cXmlPrc, characters, XML de Processamento retornado pelo método invocado no WebService do CDCF
@param cArrExec, characters, Array em formato JSON com os dados dos clientes e seus respectivos contatos a serem processados pelo Execauto das Rotinas de cadastro
@param cObserv, characters, Observações do Processamento. Registro de erros e alertas durante todo o processo de integração
@return logical, Indica se a gravação do registro ocorreu sem erros.
/*/
User Function IOMT2LOG( cUUID, dDataRe, cHoraRe, cMetodo, cStatus, cConfir, cXmlRec, cParams, dDataPr, cHoraPr, cXmlPrc, cArrExec, cObserv )

	Local lRet   := .T.
	Local oModel := FwLoadModel( 'IOMATA02' )
	Local aArea  := GetArea()

	DbSelectArea( 'ZX1' )
	DbSetOrder( 2 )

	If DbSeek( xFilial( 'ZX1' ) + cUUID )

		oModel:SetOperation( MODEL_OPERATION_UPDATE )

	Else

		oModel:SetOperation( MODEL_OPERATION_INSERT )

	End If

	oModel:Activate()

	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_UUID'  , cUUID   )
	If ( ValType( dDataRe ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_DATARE', dDataRe ), Nil )
	If ( ValType( cHoraRe ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_HORARE', cHoraRe ), Nil )
	If ( ValType( cMetodo ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_METODO', cMetodo ), Nil )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_STATUS', cStatus )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_CONFIR', cConfir )
	If ( ValType( cXmlRec ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_XMLREC', cXmlRec ), Nil )
	If ( ValType( cParams ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_PARAMS', cParams ), Nil )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_DATAPR', dDataPr )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_HORAPR', cHoraPr )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_XMLPRC', cXmlPrc )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_ARREXE', cArrExec   )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_OBSERV', cObserv )

	If lRet := oModel:VldData()

		oModel:CommitData()

		// Caso tenho ocorre erro no processamento envia email
		If cStatus $ '123'

			IOMT2MAIL( cUUID, ZX1->ZX1_DATARE, ZX1->ZX1_HORARE, ZX1->ZX1_METODO, cStatus, dDataPr, cHoraPr, cObserv )

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
Static Function IOMT2MAIL( cUUID, dDataRe, cHoraRe, cMetodo, cStatus, dDataPr, cHoraPr, cObserv )

	Local oServer  := TMailManager():New()
	Local oMessage := TMailMessage():new()
	Local aStatus  := { '1=Erro Comunicação CDCF', '2=Erro Processamento XML', '3=Falha durante Importação' }
	Local cTo      := ''
	Local aArea    := GetArea()
	Local aAreaSX5 := SX5->( GetArea() )

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
	cMSGMAIL += '<style>'
	cMSGMAIL += 'table, th, td'
	cMSGMAIL += '{ border: 1px solid black;'
	cMSGMAIL += 'border-collapse: collapse;'
	cMSGMAIL += 'font-family:verdana;}'
	cMSGMAIL += 'th, td'
	cMSGMAIL += '{ padding: 5px;'
	cMSGMAIL += 'text-align: left;}'
	cMSGMAIL += 'th.title{'
	cMSGMAIL += 'color: white;'
	cMSGMAIL += 'background-color: black;,
	cMSGMAIL += 'text-align: center;}'
	cMSGMAIL += '</style>'
	cMSGMAIL += '</head>'
	cMSGMAIL += '<body>'
	cMSGMAIL += '<table>'
	cMSGMAIL += '<tr>'
	cMSGMAIL += '<th class="title" colspan="2">Dados do Documento de Requisição'
	cMSGMAIL += '</th>'
	cMSGMAIL += '</tr>'
	cMSGMAIL += '<tr>
	cMSGMAIL += '<td>UUID Documento Recebido</td>
	cMSGMAIL += '<td>' + cUUID + '</td>
	cMSGMAIL += '</tr>
	cMSGMAIL += '<tr>
	cMSGMAIL += '<td>Data do Recebimento</td>
	cMSGMAIL += '<td>' + dtoc( dDataRe ) + '</td>
	cMSGMAIL += '</tr>
	cMSGMAIL += '<tr>
	cMSGMAIL += '<td>Hora do Recebimento</td>
	cMSGMAIL += '<td>' + cHoraRe + '</td>
	cMSGMAIL += '</tr>
	cMSGMAIL += '<tr>
	cMSGMAIL += '<td>Metodo CDCF</td>
	cMSGMAIL += '<td>' + cMetodo + '</td>
	cMSGMAIL += '</tr>
	cMSGMAIL += '<tr>
	cMSGMAIL += '<td>Status</td>
	cMSGMAIL += '<td>' + aStatus[ Val( cStatus ) ] + '</td>
	cMSGMAIL += '</tr>
	cMSGMAIL += '<tr>
	cMSGMAIL += '<td>Data do Processamento</td>
	cMSGMAIL += '<td>' + dtoc( dDataPr ) + '</td>
	cMSGMAIL += '</tr>
	cMSGMAIL += '<tr>
	cMSGMAIL += '<td>Hora do Processamento</td>
	cMSGMAIL += '<td>' + cHoraPr + '</td>
	cMSGMAIL += '</tr>
	cMSGMAIL += '<tr>
	cMSGMAIL += '<td>Observações</td>
	cMSGMAIL += '<td>' + cObserv + '</td>
	cMSGMAIL += '</tr>
	cMSGMAIL += '</table>
	cMSGMAIL += '</body>
	cMSGMAIL += '</html>

	DbSelectArea( 'SX5' )
	DbSetOrder( 1 )
	DbSeek( xFilial( 'SX5' ) + 'ZX')

	Do While ! SX5->( Eof() ) .And. SX5->X5_TABELA == 'ZX'

		cTo += AllTrim( Lower(SX5->X5_DESCRI) ) + ';'

		SX5->( DbSkip() )

	End Do

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

/*/{Protheus.doc} IOMT02EX
Funcao informada no aRotina do Browse, que executa uma ação conforme o Codigo recebido por parametro
@author Elton Teodoro Alves
@since 09/02/2017
@version 12.1.014
@param cCod, characters, Código a ação a ser executada:
1 - Exibe o XML da Requisição
2 - Exibe o XML do CDCF
3 - Exibe o Array do ExecAuto
4 - Envia a requisição para Fila Novamente
/*/
User Function IOMT02EX( cCod )

	Local cFile    := GetTempPath( .T. ) + GetNextAlias()
	Local aArrExec := {}

	If cCod == '1'

		cFile += '.xml'

		MemoWrite( cFile, ZX1->ZX1_XMLREC )

	ElseIf cCod == '2' .And. ! Empty( ZX1->ZX1_XMLPRC )

		cFile += '.xml'

		MemoWrite( cFile, ZX1->ZX1_XMLPRC )

	ElseIf cCod == '3' .And. ! Empty( ZX1->ZX1_XMLPRC )

		cFile += '.html'

		FWJsonDeserialize( ZX1->ZX1_ARREXE, @aArrExec )

		MemoWrite( cFile, VarInfo( 'ZX1_ARREXE', aArrExec,, .T., .F. ) )

	ElseIf cCod == '4'

		If ZX1->ZX1_STATUS # '4'

			RecLock( 'ZX1', .F.)

			ZX1->ZX1_STATUS = '0'

			MsUnLock()

			Return

		Else

			ApMsgInfo( 'Esta Requisição não pode voltar para fila, pois já foi importada.', 'Atenção !!!' )

			Return

		End If

	Else

		ApMsgInfo( 'Informação não Disponível', 'Atenção !!!' )

		Return

	End If

	ShellExecute( 'Open', '%PROGRAMFILES%\Internet Explorer\iexplore.exe', cFile, 'C:\', 1 )

Return