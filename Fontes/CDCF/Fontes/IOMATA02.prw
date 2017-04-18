#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOMATA02
//Função a ser utilizada no Schedule que busca no Web Service do CDCF pelo método SolicitaClientesParaIntegrar os clinetes a serem incluidos/atualizados.
@author Elton Teodoro Alves
@since 10/04/2017
@version 12.1.014
@param aParam, array, Array enviado pelo schedule com dados do processamento
/*/
User Function IOMATA02( aParam )

	Local cTimeStamp := FWTimeStamp( 4 )
	Local cLastTime  := GetGlbValue( 'IOMATA02' )
	Local nTime      := Val( cTimeStamp ) - Val( cLastTime )
	Local oEai       := Nil
	Local cXml       := GerXml( aParam )
	Local oXml       := TXmlManager():New()
	Local cUuid      := ''

	oXml:Parse( cXml )

	cUuid := oXml:XPathGetNodeValue( '/TOTVSIntegrator/DocIdentifier' )

	If nTime >= Val( GetParam( Space( Len( aParam[2] ) ) + 'IO_TMPWAIT', aParam[1] ) )

		oEai := WsEaiService():New()

		oEai:_URL := AllTrim( GetParam( Space( Len( aParam[2] ) ) + 'IO_EAIWSDL', aParam[1] ) )

		If oEai:ReceiveMessage( '<![CDATA[' + cXml + ']]>' )

			ConOut( oEai:cReceiveMessageResult )

		Else

			eMailExcep( cUuid, GetWSCError() )

		EndIf

		FreeObj( oEai )

		PutGlbValue ( 'IOMATA02', FWTimeStamp( 4 ) )

	End If

Return

/*/{Protheus.doc} GetParam
//Efetua a busca do valor de um parâmetro sem que haja algum environment ativo
@author Elton Teodoro Alves
@since 10/04/2017
@version 12.1.014
@param cSeek, characters, String de busca do parâmetro pela função DbSeek
@param cEmp, characters, Código da Empresa da busca
@return return, Valor do Parâmetro
/*/
Static Function GetParam( cSeek, cEmp )

	Local cRet := ''

	dbUseArea( .T. , 'CTREECDX',;
	GetSrvProfString( 'STARTPATH', '\SYSTEM' ) +;
	'SX6' + cEmp + '0' + GetDbExtension(),;
	'SX6TMP', .T., .T.)

	SX6TMP->( DbSetOrder( 1 ) )

	SX6TMP->( DbSeek( cSeek ) )

	cRet := SX6TMP->X6_CONTEUD

	SX6TMP->( DbCloseArea() )

Return cRet

/*/{Protheus.doc} FXml
//Monta o XML do documento EAI de requisição de integração com o CDCF
@author Elton Teodoro Alves
@since 10/04/2017
@version 12.1.014
@param aParam, array, Array enviado pelo schedule com dados do processamento
@return return, XML do documento de requisição do EAI.
/*/
Static Function GerXml( aParam )

	Local cRet  := ''
	Local cUUID := FWUUIDV4( .T. )

	cRet += '<TOTVSIntegrator>'
	cRet += '<GlobalProduct>TOTVS|EAI</GlobalProduct>'
	cRet += '<GlobalFunctionCode>EAI</GlobalFunctionCode>'
	cRet += '<GlobalDocumentFunctionCode>CDCF</GlobalDocumentFunctionCode>'
	cRet += '<GlobalDocumentFunctionDescription>Cadastro de Clientes e Fornecedores</GlobalDocumentFunctionDescription>'
	cRet += '<DocVersion>1.000</DocVersion>'
	cRet += '<DocDateTime>'

	cRet += FwTimeStamp( 3 )

	cRet += '</DocDateTime>'
	cRet += '<DocIdentifier>'

	cRet += cUUID

	cRet += '</DocIdentifier>'
	cRet += '<DocCompany>' + aParam[ 1 ] + '</DocCompany>'
	cRet += '<DocBranch>'  + aParam[ 2 ] + '</DocBranch>'
	cRet += '<DocName/>'
	cRet += '<DocFederalID />'
	cRet += '<DocType>1</DocType>'
	cRet += '<Message>'
	cRet += '<Layouts>'
	cRet += '<Version>1.000</Version>'
	cRet += '<Identifier>' + cUUID + '</Identifier>'
	cRet += '<FunctionCode>U_IOCDCF</FunctionCode>'
	cRet += '<Content/>'
	cRet += '</Layouts>'
	cRet += '</Message>'
	cRet += '</TOTVSIntegrator>'

Return cRet

/*/{Protheus.doc} IOCDCF
User Function chamada via EAI para registrar na fila as requisições de importação do cadastro de clientes incluir e alterados do CDCF.
@author Elton Teodoro Alves
@since 27/01/2017
@version 12.1.014
@param cXml, characters, O conteúdo da tag Content do XML recebido pelo EAI Protheus.
@param cError, characters, Variável passada por referência, serve para alimentar a mensagem de erro, nos casos em que a transação não foi bem sucedida.
@param cWarning, characters, Variável passada por referência, serve para alimentar uma mensagem de warning para o EAI.
@param cParams, characters,  Parâmetros passados na mensagem do EAI.
@param oFwEai, object, O objeto de EAI criado na camada do EAI Protheus.
@return characters, Retorno com resultado da operação.
/*/
User Function IOCDCF( cXml, cError, cWarning, cParams, oFwEai )

	Local cXmlCDCF   := ''
	Local cErrorCDCF := ''
	Local cRet       := ''

	GetXmlCDCF( @cXmlCDCF, @cErrorCDCF )

	If ! Empty( cErrorCDCF )

		eMailExcep( oFwEai:cUuid, cErrorCDCF )

	End If

	GerArrExec( oFwEai:cUuid, cXmlCDCF )

	oFwEai:cReturnMsg := cXmlCDCF

Return cRet

/*/{Protheus.doc} GetXmlCDCF
Conecta com o WebService do CDCF no método SolicitaClinetesParaIntegrar e recebe o XML a ser integrado com o Protheus
@author Elton Teodoro Alves
@since 10/04/2017
@version 12.1.014
@param cXml, characters, Variável passada por referêcia que recebe o XML retornado pelo CDCF
@param cErro, characters, Variável passada por referência que recebe o erro ocorrido na integração com o CDCF
/*/
Static Function GetXmlCDCF( cXml, cErro )

	Local cWSDLUrl := GetMv( 'IO_CDCFWSD' ) // URL do WSDL do WebService do CDCF
	Local cIDSist  := GetMv( 'IO_CDCFIDS' ) // ID do Sistema Protheus no CDCF
	Local cIdCons  := GetMv( 'IO_CDCFIDC' ) // ID da Consulta no CDCF
	Local oWSDL    := TWsdlManager():New()
	Local aOps     := {}
	Local aComplex := {}
	Local aSimple  := {}

	// Define que a validacao da resposta do WebService do CDCF nao sera processada
	oWsdl:lProcResp := .F.

	// Efetua o parse do WSDL do WebService
	If ! oWsdl:ParseUrl( cWSDLUrl )

		//cErro := 'Erro no Parse da URL do WSDL do WebService: ' + oWsdl:cError

		UserException( 'Erro no Parse da URL do WSDL do WebService: ' + oWsdl:cError )

		Return

	End If

	// Atribui a variavel array com as operacoes do WebService
	aOps := aClone( oWsdl:ListOperations() )

	If Len( aOps ) == 0

		cErro := 'Não foi disponibilizada nenhuma operação pelo WebService através do documento WSDL: ' + oWsdl:cError

		Return

	End If

	// Seta a operacao a ser executada
	If ! oWsdl:SetOperation( aOps[ aScan( aOps, { | X | X[ 1 ] == 'SolicitaClientesParaIntegrar'} ), 1 ] )

		cErro := 'Não foi possível definir o método SolicitaClientesParaIntegrar como a operação a ser realizada: ' + oWsdl:cError

		Return

	End If

	// Atribui a variavel os tipos complexos da operacao
	aComplex := oWsdl:NextComplex()

	If Len( aComplex ) == 0

		cErro := 'Nenhum Elemeto do Tipo Complexo foi Localizado: ' + oWsdl:cError

		Return

	End If

	// Atribui a variavel os tipos simples da operacao
	aSimple  := oWsdl:SimpleInput()

	If Len( aSimple ) == 0

		cErro := 'Nenhum Elemeto do Tipo Simples foi Localizado: ' + oWsdl:cError

		Return

	End If

	// Define o numero de ocorrencias do tipo complexo
	If ! oWsdl:SetComplexOccurs( aComplex[ 1 ], 1 )

		cErro := 'Não foi possível definir o número de vezes do Tipo Complexo: ' + oWsdl:cError

		Return

	End IF

	// Seta o valor do tipo simples correspondente ao ID do Sistema Protheus no CDCF
	If ! oWsdl:SetValue( aSimple[1][1], cIDSist )

		cErro := 'Não foi possível definir o valor da variável ' + aSimple[1][2] + ': ' + oWsdl:cError

		Return

	End If

	// Seta o valor do tipo simples correspondente ao ID da Consulta no CDCF
	If  ! oWsdl:SetValue( aSimple[2][1], cIdCons  )

		cErro := 'Não foi possível definir o valor da variável ' + aSimple[2][2] + ': ' + oWsdl:cError

		Return

	End If

	// Efetua comunicacao com WebService do CDCF
	If ! oWsdl:SendSoapMsg()

		cErro := 'Não foi possível o envio do documento SOAP gerado ao endereço definido: ' + oWsdl:cError

		Return

	End If

	// Atribui a Variável o retorno do WebService
	cXml := oWsdl:GetSoapResponse()

Return

/*/{Protheus.doc} eMailExcep
Função que registra uma User Exception e envia e-mail com a exception para lista de usuário definada na tabela ZX
@author Elton Teodoro Alves
@since 12/02/2017
@version 12.1.014
@param cUUID, characters, UUID Documento Recebido
@param cMsg, characters, Mensagem de Erro durante o Processamento.
/*/
Static Function eMailExcep( cUUID, cMsg )

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

		UserException( cMsg )

		Return

	End If

	If oServer:smtpConnect() != 0

		ConOut( 'Não foi possível conectar ao servidor SMTP.' )

		oServer:smtpDisconnect()

		UserException( cMsg )

		Return

	End If

	If oServer:smtpAuth( cRELACNT, cRELPSW ) # 0

		ConOut( 'Não foi possível autenticar o servidor SMTP.' )

		oServer:smtpDisconnect()

		UserException( cMsg )

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

		UserException( cMsg )

		Return

	End If

	UserException( cMsg )

Return

/*/{Protheus.doc} GerArrExec
Função que monta o Array para execução automática
das rotinas de cadastro de clientes e contatos
@author Elton Teodoro Alves
@since 10/02/2017
@version 12.1.014
@param cUUID, characters, UUID Documento Recebido
@param cXmlPrc, characters, XML de Processamento retornado pelo método invocado no WebService do CDCF
@return Array, Array com os dados extraidos do XML
/*/
Static Function GerArrExec( cUUID, cXmlPrc )

	Local aCliente  := {}
	Local aContatos := {}
	Local aClientes := {}
	Local aDtHrAlt  := {}
	Local cEsfera   := ''
	Local nX        := 0
	Local oXml      := TXmlManager():New()

	// Parse do XML retornado
	If ! oXml:Parse( cXmlPrc )

		eMailExcep( cUUID , 'Erro no Parse do XML de retorno do CDCF: ' + oXml:LastError() )

		Return

	End If

	// Desce o nivel do XML ate encontrar as Tags desejadas para processamento
	Do While ! oXml:cName $ 'Cliente/RegistroConsulta/IntegracaoClientes/ErroConsulta'

		If ! oXml:DOMChildNode()

			Exit

		End If

	EndDo

	// Erro retornado pela consulta ao CDCF
	If oXml:cName = 'ErroConsulta'

		eMailExcep( cUUID , 'Erro Retornado na Consulta ao CDCF: ' + GetValTag( oXml, 'MensagemExcecao' ) )

		Return

	EndIf

	// Percorre cada Tag do XML no nível Atual até que não haja mais uma próxima Tag
	Do While AllWaysTrue()

		If oXml:cName == 'Cliente'

			cEsfera := GetValTag( oXml, 'IdTipoEsfera' )

			aAdd( aCliente, { 'A1_COD'    , GetValTag( oXml, 'CodigoERP' )  , Nil } )
			aAdd( aCliente, { 'A1_LOJA'   , '01'                            , Nil } )
			aAdd( aCliente, { 'A1_PESSOA' , If( cEsfera $ '1235', 'J', 'F' ), Nil } )
			aAdd( aCliente, { 'A1_TIPO'   , 'R'                             , Nil } )
			aAdd( aCliente, { 'A1_XCD_CDC', GetValTag( oXml, 'IdCliente' )  , Nil } )

			InfoEsfera  ( oXml, cEsfera, @aCliente )
			InfoEndereco( oXml, @aCliente )
			InfoEmailNFe( oXml, @aCliente )
			InfoContatos( oXml, @aContatos )

			aAdd( aClientes, { aClone( aCliente ), aClone( aContatos ) } )

			aSize( aCliente , 0 )
			aSize( aContatos, 0 )

		ElseIf oXml:cName == 'IntegracaoClientes'

			aAdd( aDtHrAlt, { GetValTag( oXml, 'IdCliente'), GetValTag( oXml, 'DataHoraAlteracao' ) } )

		EndIf

		If ! oXml:DOMNextNode()

			Exit

		End If

	EndDo

	For nX := 1 To Len( aClientes )

		cIdCDCF := aClientes[ nX, 1 , aScan( aClientes[ nX, 1 ], { | X | X[ 1 ] == "A1_XCD_CDC" } ), 2]

		nPos := aScan( aDtHrAlt, {|X| X[1] == cIdCDCF } )

		If nPos > 0

			aAdd( aClientes[ nX, 1 ], { 'A1_XDH_CDC', aDtHrAlt[ nPos, 2 ], Nil  } )

		EndIf

	Next nX

Return aClientes

/*/{Protheus.doc} GetValTag
Retorna o valor da Tag descendente solicitada correspondenente a Tag posicionada no XML.
@author Elton Teodoro Alves
@since 07/02/2017
@version 12.1.014
@param cTag, characters, Nome da Tag
@return characters, Valor da Tag
/*/
Static Function GetValTag( oXml, cTag )

	Local cRet := ""
	Local nPos := aScan( oXml:DOMGetChildArray(), { | X | X[1] = cTag } )

	If nPos > 0

		cRet := oXml:DOMGetChildArray() [ nPos, 2]

	End If

Return cRet

/*/{Protheus.doc} InfoEsfera
Resgata do XML as informação correspondentes a esfera do cliente
@author Elton Teodoro Alves
@since 10/02/2017
@version 12.1.014
@param oXml, object, Obejeto do Parser do XML retornado pelo XML
@param cEsfera, characters, Esfera do Cliente:
1 - Federal
2 - Estadual
3 - Municipal
4 - Pessoa Fisica
5 - Pessoa Juridica
@param aCliente, Array, Array com dados do cliente para o ExecAuto
/*/
Static Function InfoEsfera( oXml, cEsfera, aCliente )

	oXml:DOMChildNode()

	If cEsfera $ '1235'

		If cEsfera $ '123'

			Do While oXml:cName # 'OrgaoPublico'

				oXml:DOMNextNode()

			EndDo

			oXml:DOMChildNode()

		End If

		Do While oXml:cName # 'PessoaJuridica'

			oXml:DOMNextNode()

		EndDo

		aAdd( aCliente, { 'A1_NOME'  , GetValTag( oXml, 'RazaoSocial'        ), Nil } )
		aAdd( aCliente, { 'A1_NREDUZ', GetValTag( oXml, 'NomeFantasia'       ), Nil } )
		aAdd( aCliente, { 'A1_CGC'   , GetValTag( oXml, 'CNPJ'               ), Nil } )
		aAdd( aCliente, { 'A1_INSCR' , GetValTag( oXml, 'InscricaoEstadual'  ), Nil } )
		aAdd( aCliente, { 'A1_INSCRM', GetValTag( oXml, 'InscricaoMunicipal' ), Nil } )

	ElseIf cEsfera $ '4'

		Do While oXml:cName # 'PessoaFisica'

			oXml:DOMNextNode()

		EndDo

		aAdd( aCliente, { 'A1_NOME'  , GetValTag( oXml, 'Nome' ), Nil } )
		aAdd( aCliente, { 'A1_NREDUZ', GetValTag( oXml, 'Nome' ), Nil } )
		aAdd( aCliente, { 'A1_CGC'   , GetValTag( oXml, 'CPF'  ), Nil } )
		aAdd( aCliente, { 'A1_PFISIC', GetValTag( oXml, 'RG'   ), Nil } )

	EndIf

	Do While oXml:cName # 'Cliente'

		oXml:DOMParentNode()

	EndDo

Return

/*/{Protheus.doc} InfoEndereco
Resgata do XML as informação correspondentes aos enderecos do cliente
@author Elton Teodoro Alves
@since 10/02/2017
@version 12.1.014
@param oXml, object, Obejeto do Parser do XML retornado pelo XML
@param aCliente, Array, Array com dados do cliente para o ExecAuto
/*/
Static Function InfoEndereco( oXml, aCliente )

	Local cEndereco := ""

	oXml:DOMChildNode()

	Do While AllWaysTrue()

		If oXml:cName == 'Endereco'

			cEndereco := GetValTag( oXml, 'TipoLogradouro' )
			cEndereco += GetValTag( oXml, 'Logradouro' )
			cEndereco += GetValTag( oXml, 'LogradouroNumero' )

			If GetValTag( oXml, 'IdTipoEndereco' ) == '1'

				aAdd( aCliente, { 'A1_END'     , cEndereco, Nil } )
				aAdd( aCliente, { 'A1_COMPLEM' , GetValTag( oXml, 'LogradouroComplemento'  ), Nil } )
				aAdd( aCliente, { 'A1_BAIRRO'  , GetValTag( oXml, 'Bairro'                 ), Nil } )
				aAdd( aCliente, { 'A1_EST'     , GetValTag( oXml, 'SiglaUnidadeFederativa' ), Nil } )
				aAdd( aCliente, { 'A1_CEP'     , GetValTag( oXml, 'CEP'                    ), Nil } )
				aAdd( aCliente, { 'A1_COD_MUN' , GetValTag( oXml, 'CodigoMunicipio'        ), Nil } )
				aAdd( aCliente, { 'A1_MUN'     , GetValTag( oXml, 'Municipio'              ), Nil } )

			ElseIF GetValTag( oXml, 'IdTipoEndereco' ) == '2'

				aAdd( aCliente, { 'A1_ENDCOB', cEndereco, Nil } )


			ElseIf GetValTag( oXml, 'IdTipoEndereco' ) == '3'

				aAdd( aCliente, { 'A1_ENDENT', cEndereco, Nil } )

			End If

		End If

		If ! oXml:DOMNextNode()

			Exit

		End If

	EndDo

	Do While oXml:cName # 'Cliente'

		oXml:DOMParentNode()

	EndDo

Return

/*/{Protheus.doc} InfoEndereco
Resgata do XML as informação correspondentes aos E-Mail´s do cliente para envio da NF-e
@author Elton Teodoro Alves
@since 10/02/2017
@version 12.1.014
@param oXml, object, Obejeto do Parser do XML retornado pelo XML
@param aCliente, Array, Array com dados do cliente para o ExecAuto
/*/
Static Function InfoEmailNFe( oXml, aCliente )

	oXml:DOMChildNode()

	Do While AllWaysTrue()

		If oXml:cName == 'ClienteContato' .And. GetValTag( oXml, 'NotaFiscalEletronica' ) == 'true'

			oXml:DOMChildNode()

			Do While AllWaysTrue()

				If oXml:cName == 'MeioComunicacao' .And. GetValTag( oXml, 'IdTipoContato' ) == '6'

					If aScan( aCliente, { |X| X[1] == 'A1_EMAIL' } ) == 0

						aAdd( aCliente, { 'A1_EMAIL', GetValTag( oXml, 'Email' ), Nil } )

					Else

						aCliente[aScan( aCliente, { |X| X[1] == 'A1_EMAIL' } )][2] += ';' + GetValTag( oXml, 'Email' )

					End If

				End If

				If ! oXml:DOMNextNode()

					Exit

				End If

			EndDo

			oXml:DOMParentNode()

		End If

		If ! oXml:DOMNextNode()

			Exit

		End If

	EndDo

	oXml:DOMParentNode()

Return

/*/{Protheus.doc} InfoEndereco
Resgata do XML as informação correspondentes aos Conatatos do cliente
@author Elton Teodoro Alves
@since 10/02/2017
@version 12.1.014
@param oXml, object, Obejeto do Parser do XML retornado pelo XML
@param aContatos, Array, Array com dados dos contatos do cliente para o ExecAuto
/*/
Static Function InfoContatos( oXml, aContatos )

	Local aContato   := {}
	Local aMeioComun := {}
	Local aEmails    := {}
	Local cPerfis    := ''

	oXml:DOMChildNode()

	Do While AllWaysTrue()

		If oXml:cName == 'ClienteContato'

			cPerfis := InfoPerfCont( oXml )

			aAdd( aContato, { 'U5_FILIAL' , xFilial( 'SU5' )                   , Nil } )
			aAdd( aContato, { 'U5_CODCONT', GetValTag( oXml, 'IdPessoaFisica' ), Nil } )
			aAdd( aContato, { 'U5_CONTAT' , GetValTag( oXml, 'NomeContato'    ), Nil } )
			aAdd( aContato, { 'U5_XCOTCOM', If( '1' $ cPerfis, '1', '2'       ), Nil } )
			aAdd( aContato, { 'U5_XFATPUB', If( '2' $ cPerfis, '1', '2'       ), Nil } )
			aAdd( aContato, { 'U5_XFINANC', If( '3' $ cPerfis, '1', '2'       ), Nil } )
			aAdd( aContato, { 'U5_XNF_E'  , If( '4' $ cPerfis, '1', '2'       ), Nil } )
			aAdd( aContato, { 'U5_XSRVGRF', If( '5' $ cPerfis, '1', '2'       ), Nil } )
			aAdd( aContato, { 'U5_XPUBLIC', If( '6' $ cPerfis, '1', '2'       ), Nil } )
			aAdd( aContato, { 'U5_XBOLELE', If( '7' $ cPerfis, '1', '2'       ), Nil } )

			InfoMeioComun( oXml, @aMeioComun )

			aAdd( aContatos, { aClone( aContato ), aClone( aMeioComun ) } )

			cPerfis := ''
			aSize( aContato, 0 )
			aSize( aMeioComun, 0 )

		End If

		If ! oXml:DOMNextNode()

			Exit

		End If

	EndDo

	oXml:DOMParentNode()

Return

/*/{Protheus.doc} InfoPerfCont
Resgata co XML as informações correspondentes ao perfil do contato
@author Elton Teodoro Alves
@since 10/02/2017
@version 12.1.014
@param oXml, object, Obejeto do Parser do XML retornado pelo XML
@return characteres, String concatenada com os perfis do contato
/*/
Static Function InfoPerfCont( oXml )

	Local cRet := ''

	oXml:DOMChildNode()

	Do While AllWaysTrue()

		If oXml:cName == 'PerfilClienteContato'

			cRet += GetValTag( oXml, 'IdTipoClienteContato' )

		End If

		If ! oXml:DOMNextNode()

			Exit

		End If

	EndDo

	oXml:DOMParentNode()

Return cRet
/*/{Protheus.doc} InfoMeioComun
Resgata do XML as informação correspondentes aos meios de comunicação do Contato do cliente
@author Elton Teodoro Alves
@since 10/02/2017
@version 12.1.014
@param oXml, object, Obejeto do Parser do XML retornado pelo XML
@param aMeioComun, Array, Array com dados dos meios de comunicação do contato do cliente
/*/
Static Function InfoMeioComun( oXml, aMeioComun )

	Local aAux := {}
	Local cDDD := ''
	Local cTel := ''

	oXml:DOMChildNode()

	Do While AllWaysTrue()

		If oXml:cName == 'MeioComunicacao'

			cDDD := GetValTag( oXml, 'DDD'      )
			cTel := GetValTag( oXml, 'Telefone' )

			aAdd( aAux,{ 'AGB_CODIGO', GetValTag( oXml, 'IdMeioComunicacao' ), Nil } )
			aAdd( aAux,{ 'AGB_XTIPO' , GetValTag( oXml, 'IdTipoContato'     ), Nil } )
			aAdd( aAux,{ 'AGB_XEMAIL', GetValTag( oXml, 'Email'             ), Nil } )
			aAdd( aAux,{ 'AGB_DDI'   , GetValTag( oXml, 'DDI'               ), Nil } )
			aAdd( aAux,{ 'AGB_DDD'   , If( Empty( cDDD ), '0', cDDD                  ), Nil } )
			aAdd( aAux,{ 'AGB_TELEFO', If( Empty( cTel ), '0', cTel                  ), Nil } )
			aAdd( aAux,{ 'AGB_COMP'  , GetValTag( oXml, 'Ramal'             ), Nil } )

			aAdd( aMeioComun, aClone( aAux ) )

			aSize( aAux, 0 )

		End If

		If ! oXml:DOMNextNode()

			Exit

		End If

	EndDo

	oXml:DOMParentNode()

Return

/*/{Protheus.doc} RunExecAuto
Executa o processamento do Array com os dados do cliente e seus contatos
@author Elton Teodoro Alves
@since 16/02/2017
@version 12.1.014
@param aClientes, array, Array com os dados dos clinetes e seus contatos
/*/
Static Function RunExecAuto( cUUID, cXmlPrc, aClientes )

	Local nX         := 0
	Local nY         := 0
	Local nZ         := 0
	Local aArea      := GetArea()
	Local cCodigo    := ''
	Local nOpc       := 0
	Local cCodCon    := ''
	Local aLog       := {}
	Local aLogCli    := {}

	Local cCodErp    := ''
	Local cCodCdcf   := ''
	Local cRazao     := ''
	Local cFantas    := ''
	Local cObserv    := ''
	Local cStatus    := ''
	Local cArrexe    := ''
	Local aErro      := ''

	Local cCodCont   := ''
	Local cNomeCont  := ''
	Local cObsCont   := ''
	Local cImpCont   := ''
	Local cArrexeCnt := ''

	Local lAllOk     := .T.


	Private	lMsErroAuto    := .F.
	Private	lMsHelpAuto    := .T.
	Private	lAutoErrNoFile := .T.

	For nX := 1 To Len( aClientes )

		lMsErroAuto := .F.

		cCodigo := aClientes[ nX, 1 , aScan( aClientes[ nX, 1 ], { | X | X[ 1 ] == 'A1_COD' } ), 2]

		nOpc := If( Empty( Posicione( 'SA1', 1, xFilial( 'SA1' ) + cCodigo + '01', 'A1_COD' ) ), 3, 4 )

		BeginTran()

		MSExecAuto( { | X, Y | MATA030( X, Y ) }, aClientes[ nX, 1 ], nOpc )

		If lMsErroAuto

			lAllOk := lAllOk .And. ! lMsErroAuto

			DisarmTransaction()

		End If

		EndTran()

		If lMsErroAuto

			aErro := GetAutoGRLog()

			For nZ := 1 To Len( aErro )

				cObserv += aErro[ nZ ] + Chr( 13 ) + Chr( 10 )

			Next nZ

		EndIf

		cCodErp := aClientes[nX, 1,aScan( aClientes[nX,1], {|X| X[1] == "A1_COD"} ),2]
		cCodCdc := aClientes[nX, 1,aScan( aClientes[nX,1], {|X| X[1] == "A1_XCD_CDC"} ),2]
		cRazao  := aClientes[nX, 1,aScan( aClientes[nX,1], {|X| X[1] == "A1_NOME"} ),2]
		cFantas := aClientes[nX, 1,aScan( aClientes[nX,1], {|X| X[1] == "A1_NREDUZ"} ),2]
		cStatus := If( lMsErroAuto, '2', '0' )
		cArrexe := FWJsonSerialize( aClientes[ nX, 1 ] )

		aAdd( aLogCli, { cCodErp, cCodCdc, cRazao, cFantas, cObserv, cStatus, cArrexe , Array(0) } )

		If ! lMsErroAuto

			For nY := 1 To Len( aClientes[ NX, 2 ] )

				BeginTran()

				cCodCon := aClientes[ nX, 2, nY, 1, aScan( aClientes[ nX, 2, nY, 1 ], { | X | X[ 1 ] == 'U5_CODCONT' } ), 2 ]

				DeleteCont( cCodCon, cCodigo )

				MSExecAuto( { | X, Y, Z, A, B | TMKA070( X, Y, Z, A, B ) }, aClientes[ nX, 2, nY, 1 ], 3, {}, aClientes[ nX, 2, nY, 2 ], .F. )

				If ! lMsErroAuto

					RecLock( 'AC8', .T. )

					AC8->AC8_ENTIDA := 'SA1'
					AC8->AC8_CODENT := aClientes[ nX, 1 , aScan( aClientes[ nX, 1 ], { | X | X[ 1 ] == 'A1_COD' } ), 2] + '01'
					AC8->AC8_CODCON := aClientes[ nX, 2, nY, 1, aScan( aClientes[ nX, 2, nY, 1 ], { | X | X[ 1 ] == 'U5_CODCONT' } ), 2 ]

					MsUnlock()

				EndIf

				If lMsErroAuto

					aErro := GetAutoGRLog()

					For nZ := 1 To Len( aErro )

						cObsCont += aErro[ nZ ] + Chr( 13 ) + Chr( 10 )

					Next nZ

				EndIf

				cCodCont   := aClientes[nX, 2, nY, 1, aScan(  aClientes[nX, 2, nY, 1], {|X| X[1] == "U5_CODCONT"} ), 2]
				cNomeCont  := aClientes[nX, 2, nY, 1, aScan(  aClientes[nX, 2, nY, 1], {|X| X[1] == "U5_CONTAT"} ), 2]
				cImpCont   := If( lMsErroAuto, '2', '1' )
				cArrexeCnt := FWJsonSerialize( aClientes[ nX, 2 ] )

				aAdd( aTail( aLogCli )[ 8 ], { cCodCont, cNomeCont, cObsCont, cImpCont, cArrexeCnt } )

				aTail( aLogCli )[ 6 ] := If( lMsErroAuto, '1', '0' )

				If lMsErroAuto

					lAllOk := lAllOk .And. ! lMsErroAuto

					DisarmTransaction()

				Else

					EndTran()

				EndIf

			Next nY

		End If

		lMsErroAuto := .F.

	Next nX

	U_IOMT2LOG( cUUID,,,,,, If( lAllOk, IMPORTADO, IMPORTADO_COM_FALHAS ),,, Date(), Time(),;
	cXmlPrc, If( lAllOk, 'Importação ocorreu sm falhas.', 'Importação ocorreu com falhas.' ), aLogCli )

Return

/*/{Protheus.doc} DeleteCont
Deleta os dados do contato e seu vínculo com o cliente para ser incluido novamente
@author Elton Teodoro Alves
@since 20/02/2017
@version 12.1.014
@param cCodCon, characters, Código do Contato
@param cCodCon, characters, Código do Cliente
/*/
Static Function DeleteCont( cCodCon, cCodigo )

	Local cQuery  := ''
	Local lRet    := .T.

	cQuery := "DELETE " + RetSqlName( 'AGA' ) + " WHERE AGA_ENTIDA = 'SU5' AND AGA_CODENT = '" + cCodCon + "' AND AGA_FILIAL = '" + xFilial( 'AGA' ) + "'"

	TCSqlExec( cQuery )

	cQuery := ''

	cQuery := "DELETE " + RetSqlName( 'AGB' ) + " WHERE AGB_ENTIDA = 'SU5' AND AGB_CODENT = '" + cCodCon + "' AND AGB_FILIAL = '" + xFilial( 'AGB' ) + "'"

	TCSqlExec( cQuery )

	cQuery := ''

	cQuery := "DELETE " + RetSqlName( 'AO4' ) + " WHERE AO4_ENTIDA = 'SU5' AND AO4_CHVREG = '" + xFilial( 'SU5' ) + cCodCon + "' AND AO4_FILIAL = '" + xFilial( 'AO4' ) + "'"

	TCSqlExec( cQuery )

	cQuery := ''

	cQuery := "DELETE " + RetSqlName( 'SU5' ) + " WHERE U5_CODCONT = '" + cCodCon + "' AND U5_FILIAL = '" + xFilial( 'SU5' ) + "'"

	TCSqlExec( cQuery )

	cQuery := ''

	cQuery := "DELETE " + RetSqlName( 'AC8' ) + " WHERE AC8_FILENT = '" + xFilial( 'SA1' ) +;
	"' AND AC8_ENTIDA = 'SA1' AND AC8_CODENT = '" + cCodigo + "01' AND AC8_CODCON = '" +;
	cCodCon + "' AND AC8_FILIAL = '" + xFilial( 'AC8' ) + "'"

	TCSqlExec( cQuery )

Return