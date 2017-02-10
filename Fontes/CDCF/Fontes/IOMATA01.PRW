#INCLUDE 'TOTVS.CH'

#DEFINE AGUARDANDO_IMPORTACAO    '0'
#DEFINE ERRO_COMUNICACAO_CDCF    '1'
#DEFINE ERRO_PROCESSAMENTO_XML   '2'
#DEFINE FALHA_DURANTE_IMPORTACAO '3'
#DEFINE IMPORTADO                '4'

#DEFINE CONF_SIM '1'
#DEFINE CONF_NAO '2'

/*/{Protheus.doc} IOMATA01
User Function chamada via EAI para registrar na fila as requisições de importação do cadastro de clientes incluir e alterados do CDCF.
@author Elton Teodoro Alves
@since 27/01/2017
@version 12.1.014
@param cXml, characters, O conteúdo da tag Content do XML recebido pelo EAI Protheus.
@param cError, characters, Variável passada por referência, serve para alimentar a mensagem de erro, nos casos em que a transação não foi bem sucedida.
@param cWarning, characters, Variável passada por referência, serve para alimentar uma mensagem de warning para o EAI. A alteração deste valor por rotinas tratadas neste tópico não causam nenhum efeito para o EAI.
@param cParams, characters,  Parâmetros passados na mensagem do EAI. Para o envio destes parâmetros é utilizada a seguinte regra:
- Estes parâmetros são passados após o nome da função, na tag FunctionCode, no path /TOTVSIntegrator/Message/Layouts/
- Após o nome da função a ser executada deve ser colocado um '.' e após cada um dos parâmetros mais um. Exemplo: <FunctionCode>U_TSTEAI.01.02.03</FunctionCode>.
- OS parâmetros são enviados na forma de uma string, separados por ','. No exemplo acima, a variável cParams irá receber a string 01,02,03
@param oFwEai, object, O objeto de EAI criado na camada do EAI Protheus. A manipulação deste objeto deve ser realizada com o máximo de cautela, e deve ser evitada ao máximo.
@return characters, Retorno com resultado da operação.
/*/
User Function IOMATA01( cXml, cError, cWarning, cParams, oFwEai )

	Local cRet     := ''
	Local cMetodo  := ''
	Local cParJson := ''

	// Verifica se foram enviados clientes e define o metodo a ser executado
	If cParams == ProcName() .Or. Empty( cParams )

		cMetodo := 'SolicitaClientesParaIntegrar'

	Else

		cMetodo := 'ConsultaCliente'

		cParJson := FWJsonSerialize( StrTokArr2( cParams, ',', .T. ) )

	End If

	If U_IOMT2LOG( oFwEai:cUUID, oFwEai:dTrialDate, oFwEai:cTrialTime, cMetodo, AGUARDANDO_IMPORTACAO,;
	CONF_NAO, oFwEai:CXML, cParJson, CtoD(''), '', '', '', '' )

		cRet := 'Documento Recebido: ' + oFwEai:cUUID

	End If

return cRet

/*/{Protheus.doc} IntgCDCF
User Função que busca na Tabela ZX1 registros com ZX1_STATUS = 0 - Aguardando Importação e executa o processo de integração com o CDCF.
@author Elton Teodoro Alves
@since 09/02/2017
@version 12.1.014
/*/
User Function IOMT1INT()

	Local cAlias := GetNextAlias()
	Local aUUID  := {}
	Local aArea  := GetArea()
	Local nX     := 0

	// Busca na Tabela ZX1 os registros com ZX1_STATUS = 0 - Aguardando Importação e Grava em Array os código ZX1_UUID
	BeginSQL Alias cAlias

	SELECT ZX1.ZX1_UUID	FROM %Table:ZX1% ZX1
	WHERE ZX1.ZX1_STATUS = '0' AND ZX1.%NotDel%

	EndSQL

	( cAlias )->( DbGotop() )

	Do While ! ( cAlias )->( Eof() )

		aAdd( aUUID, ( cAlias )->ZX1_UUID )

		( cAlias )->( DbSkip() )

	End Do

	( cAlias )->( DbCloseArea() )

	// Percorre array com códigos de requisições de integração com Status 0 - Aguardando Importação
	For nX := 1 To Len( aUUID )

		ExecInteg( aUUID[ nX ] )

	Next nX

	RestArea( aArea )

return

/*/{Protheus.doc} ExecInteg
Função que acessa uma requisição pelo seu UUID e executa a integração com o CDCF
@author Elton Teodoro Alves
@since 09/02/2017
@version 12.1.014
@param cUUID, characters, UUID da requisição
/*/
Static Function ExecInteg( cUUID )

	Local aArea    := GetArea()
	Local aParams  := {}
	Local cXml     := ''
	Local aArrExec := {}

	DbSelectArea( 'ZX1' )
	DbSetOrder( 2 )

	If DbSeek( xFilial( 'ZX1' ) + cUUID )

		FWJsonDeserialize( ZX1->ZX1_PARAMS, @aParams )

		cXml := GetXmlCDCF( cUUID, AllTrim( ZX1->ZX1_METODO ), aParams )

		If ! Empty( cXml )

			aArrExec := GerArrExec( cUUID, cXml )

		End If

	End If

	RestArea( aArea )

return

/*/{Protheus.doc} GetXmlCDCF
Conecta com o WebService do CDCF e recebe o XML a ser integrado com o Protheus
@author Elton Teodoro Alves
@since 09/02/2017
@version 12.1.014
@param cUUID, characters, UUID da requisição
@param cMetodo, characters, Método a ser executado no WebService
@param aParams, array, Array com os paramentos correspondentes aos códigos de clientes a serem integrados
@return characters, XML com os dados dos clientes
/*/
Static Function GetXmlCDCF( cUUID, cMetodo, aParams )

	Local cXml     := ''
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

		U_IOMT2LOG( cUUID,,,, ERRO_COMUNICACAO_CDCF, CONF_NAO,,, Date(), Time(),;
		'', '', 'Erro no Parse da URL do WSDL do WebService: ' + oWsdl:cError )

		Return cXml

	End If

	// Atribui a variavel array com as operacoes do WebService
	aOps := aClone( oWsdl:ListOperations() )

	If Len( aOps ) == 0

		U_IOMT2LOG( cUUID,,,, ERRO_COMUNICACAO_CDCF, CONF_NAO,,, Date(), Time(),;
		'', '', 'Não foi disponibilizada nenhuma operação pelo WebService através do documento WSDL: ' + oWsdl:cError )

		Return cXml

	End If

	// Seta a operacao a ser executada
	If ! oWsdl:SetOperation( aOps[ aScan( aOps, { | X | X[ 1 ] == cMetodo} ), 1 ] )

		U_IOMT2LOG( cUUID,,,, ERRO_COMUNICACAO_CDCF, CONF_NAO,,, Date(), Time(),;
		'', '', 'Não foi possível definir o método ' + cMetodo + ' como a operação a ser realizada: ' + oWsdl:cError )

		Return cXml

	End If

	// Atribui a variavel os tipos complexos da operacao
	aComplex := oWsdl:NextComplex()

	If Len( aComplex ) == 0

		U_IOMT2LOG( cUUID,,,, ERRO_COMUNICACAO_CDCF, CONF_NAO,,, Date(), Time(),;
		'', '', 'Nenhum Elemeto do Tipo Complexo foi Localizado: ' + oWsdl:cError )

		Return cXml

	End If

	// Atribui a variavel os tipos simples da operacao
	aSimple  := oWsdl:SimpleInput()

	If Len( aSimple ) == 0

		U_IOMT2LOG( cUUID,,,, ERRO_COMUNICACAO_CDCF, CONF_NAO,,, Date(), Time(),;
		'', '', 'Nenhum Elemeto do Tipo Simples foi Localizado: ' + oWsdl:cError )

		Return cXml

	End If

	// Define o numero de ocorrencias do tipo complexo
	If ! oWsdl:SetComplexOccurs( aComplex[ 1 ], 1 )

		U_IOMT2LOG( cUUID,,,, ERRO_COMUNICACAO_CDCF, CONF_NAO,,, Date(), Time(),;
		'', '', 'Não foi possível definir o número de vezes do Tipo Complexo: ' + oWsdl:cError )

		Return cXml

	End IF

	// Seta o valor do tipo simples correspondente ao ID do Sistema Protheus no CDCF
	If ! oWsdl:SetValue( aSimple[1][1], cIDSist )

		U_IOMT2LOG( cUUID,,,, ERRO_COMUNICACAO_CDCF, CONF_NAO,,, Date(), Time(),;
		'', '', 'Não foi possível definir o valor da variável ' + aSimple[1][2] + ': ' + oWsdl:cError )

		Return cXml

	End If

	// Seta o valor do tipo simples correspondente ao ID da Consulta no CDCF
	If  ! oWsdl:SetValue( aSimple[2][1], cIdCons  )

		U_IOMT2LOG( cUUID,,,, ERRO_COMUNICACAO_CDCF, CONF_NAO,,, Date(), Time(),;
		'', '', 'Não foi possível definir o valor da variável ' + aSimple[2][2] + ': ' + oWsdl:cError )

		Return cXml

	End If

	// Se operacao for ConsultaCliente Seta o codigo dos clientes a serem consultados
	If cMetodo == 'ConsultaCliente'

		If  ! oWsdl:SetValues( aSimple[3][1], aParams  )

			U_IOMT2LOG( cUUID,,,, ERRO_COMUNICACAO_CDCF, CONF_NAO,,, Date(), Time(),;
			'', '', 'Não foi possível definir os valores da variável ' + aSimple[3][2] + ': ' + oWsdl:cError )

			Return cXml

		End If

	End If

	// Efetua comunicacao com WebService do CDCF
	If ! oWsdl:SendSoapMsg()

		U_IOMT2LOG( cUUID,,,, ERRO_COMUNICACAO_CDCF, CONF_NAO,,, Date(), Time(),;
		'', '', 'Não foi possível o envio do documento SOAP gerado ao endereço definido: ' + oWsdl:cError )

		Return cXml

	End If

	// Atribui a Variável o retorno do WebService
	cXml := oWsdl:GetSoapResponse()

Return cXml

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

	Local aRet     := {}
	Local aCliente := {}
	Local cEsfera   := ''
	Local oXml := TXmlManager():New()

	// Parse do XML retornado
	If ! oXml:Parse( cXmlPrc )

		U_IOMT2LOG( cUUID,,,, ERRO_PROCESSAMENTO_XML, CONF_NAO,,, Date(), Time(),;
		cXmlPrc, '', 'Erro no Parse do XML de retorno do CDCF: ' + oXml:LastError() )

		Return aRet

	End If

	// Desce o nivel do XML ate encontrar as Tags desejadas para processamento
	Do While ! oXml:cName $ 'Cliente/RegistroConsulta/IntegracaoClientes/ErroConsulta'

		If ! oXml:DOMChildNode()

			Exit

		End If

	End Do

	// Erro retornado pela consulta ao CDCF
	If oXml:cName = 'ErroConsulta'

		U_IOMT2LOG( cUUID,,,, ERRO_PROCESSAMENTO_XML, CONF_NAO,,, Date(), Time(),;
		cXmlPrc, '', 'Erro Retornado na Consulta ao CDCF: ' + GetValTag( oXml, 'MensagemExcecao' ) )

		Return aRet

	End If

	// Percorre cada Tag do XML no nível Atual até que não haja mais uma próxima Tag
	Do While AllWaysTrue()

		If oXml:cName == 'Cliente'

			cEsfera := GetValTag( oXml, 'IdTipoEsfera' )

			aAdd( aCliente, { 'A1_XCD_CDC', GetValTag( oXml, 'IdCliente' )  , Nil } )
			aAdd( aCliente, { 'A1_COD'    , GetValTag( oXml, 'CodigoERP' )  , Nil } )
			aAdd( aCliente, { 'A1_LOJA'   , '01'                            , Nil } )
			aAdd( aCliente, { 'A1_PESSOA' , If( cEsfera $ '1235', 'J', 'F' ), Nil } )
			aAdd( aCliente, { 'A1_TIPO'   , 'R'                             , Nil } )

			InfEsfera ( oXml, cEsfera, @aCliente )
			InfEnderec( oXml, @aCliente )

		ElseIf oXml:cName == 'IntegracaoClientes'

		End If

		aAdd( aRet, aClone( aCliente ) )

		aSize( aCliente, 0 )

		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

Return aRet

/*/{Protheus.doc} GetValTag
Retorna o valor da Tag descendente solicitada correspondenente a Tag posicionada no XML.
@author Elton Teodoro Alves
@since 07/02/2017
@version 12.1.014
@param cTag, characters, Nome da Tag
@return characters, Valor da Tag
/*/
Static Function GetValTag( oXml, cTag )

	cRet := oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = cTag } ) ] [2]

Return cRet

/*/{Protheus.doc} InfEsfera
Restagata do XML as informação correspondentes a esfera do cliente
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
Static Function InfEsfera( oXml, cEsfera, aCliente )

	oXml:DOMChildNode()

	If cEsfera $ '1235'

		If cEsfera $ '123'

			Do While oXml:cName # 'OrgaoPublico'

				oXml:DOMNextNode()

			End Do

			oXml:DOMChildNode()

		End If

		Do While oXml:cName # 'PessoaJuridica'

			oXml:DOMNextNode()

		End Do

		aAdd( aCliente, { 'A1_NOME'  , GetValTag( oXml, 'RazaoSocial'        ), Nil } )
		aAdd( aCliente, { 'A1_NREDUZ', GetValTag( oXml, 'NomeFantasia'       ), Nil } )
		aAdd( aCliente, { 'A1_CGC'   , GetValTag( oXml, 'CNPJ'               ), Nil } )
		aAdd( aCliente, { 'A1_INSCR' , GetValTag( oXml, 'InscricaoEstadual'  ), Nil } )
		aAdd( aCliente, { 'A1_INSCRM', GetValTag( oXml, 'InscricaoMunicipal' ), Nil } )

	ElseIf cEsfera $ '4'

		Do While oXml:cName # 'PessoaFisica'

			oXml:DOMNextNode()

		End Do

		aAdd( aCliente, { 'A1_NOME'  , GetValTag( oXml, 'Nome' ), Nil } )
		aAdd( aCliente, { 'A1_NREDUZ', GetValTag( oXml, 'Nome' ), Nil } )
		aAdd( aCliente, { 'A1_CGC'   , GetValTag( oXml, 'CPF'  ), Nil } )
		aAdd( aCliente, { 'A1_PFISIC', GetValTag( oXml, 'RG'   ), Nil } )

	End If

	Do While oXml:cName # 'Cliente'

		oXml:DOMParentNode()

	End Do

	oXml:DOMChildNode()

Return

/*/{Protheus.doc} InfEsfera
Restagata do XML as informação correspondentes a esfera do cliente
@author Elton Teodoro Alves
@since 10/02/2017
@version 12.1.014
@param oXml, object, Obejeto do Parser do XML retornado pelo XML
@param aCliente, Array, Array com dados do cliente para o ExecAuto
/*/
Static Function InfEnderec( oXml, aCliente )

	Local cEndereco := ""

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

	End Do

	Do While oXml:cName # 'Cliente'

		oXml:DOMParentNode()

	End Do

	oXml:DOMChildNode()

Return