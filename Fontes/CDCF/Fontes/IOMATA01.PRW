#INCLUDE 'TOTVS.CH'

#DEFINE AGUARDANDO_IMPORTACAO  '0'
#DEFINE ERRO_COMUNICACAO_CDCF  '1'
#DEFINE ERRO_PROCESSAMENTO_XML '2'
#DEFINE IMPORTADO_COM_FALHAS   '3'
#DEFINE IMPORTADO              '4'

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

	If U_IOMT2LOG( oFwEai:cUUID, oFwEai:cDocCompany, oFwEai:cDocBranch, oFwEai:dTrialDate, oFwEai:cTrialTime, cMetodo, AGUARDANDO_IMPORTACAO,;
	oFwEai:CXML, cParJson )

		cRet := 'Documento Recebido: ' + oFwEai:cUUID

	End If

return cRet

/*/{Protheus.doc} IntgCDCF
User Função que busca na Tabela ZX1 registros com ZX1_STATUS = 0 - Aguardando Importação e executa o processo de integração com o CDCF.
@author Elton Teodoro Alves
@since 09/02/2017
@version 12.1.014
/*/
User Function IOMT1INT( aParam )

	Local cAlias  := GetNextAlias()
	Local aReq    := {}
	Local aArea   := GetArea()
	Local nX      := 0
	Default aParam := { '99', '01' }
	RpcSetEnv( aParam[1], aParam[2] )
	//TODO Tirar opção default da variável aParam
	// Busca na Tabela ZX1 os registros com ZX1_STATUS = 0 - Aguardando Importação e Grava em Array os código ZX1_UUID
	BeginSQL Alias cAlias

	SELECT ZX1.ZX1_UUID FROM %Table:ZX1% ZX1
	WHERE ZX1.ZX1_STATUS = '0' AND ZX1.%NotDel% AND ZX1.ZX1_FILIAL = %Exp:xFilial( 'ZX1' )%
	AND ZX1_EMPPRC = %Exp:cEmpAnt% AND ZX1_FILPRC = %Exp:cFilAnt%

	EndSQL

	( cAlias )->( DbGotop() )

	Do While ! ( cAlias )->( Eof() )

		aAdd( aReq, ( cAlias )->ZX1_UUID )

		( cAlias )->( DbSkip() )

	End Do

	( cAlias )->( DbCloseArea() )

	// Percorre array com códigos de requisições de integração com Status 0 - Aguardando Importação
	For nX := 1 To Len( aReq )

		ExecInteg( aReq[ nX ] )

	Next nX

	RestArea( aArea )

	RpcClearEnv()

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
		//TODO Voltar a buscar XML no Web Sercice do CDCF
		Eval( {|| oXml:= TXmlManager():New(), oXml:ParseFile( '\xml\cdcf.xml' ), cXml := oXml:Save2String() } )
		//cXml := GetXmlCDCF( cUUID, AllTrim( ZX1->ZX1_METODO ), aParams )

		If ! Empty( cXml )

			aArrExec := GerArrExec( cUUID, cXml )

		End If

	End If

	RestArea( aArea )

	If Empty( aArrExec )

		U_IOMT2LOG( cUUID,,,,,, ERRO_PROCESSAMENTO_XML,,, Date(), Time(),;
		cXml, 'XML CDCF não retornou nenhum cliente para ser processado.' )

	Else

		RunExecAuto( cUUID, cXml, aArrExec )

	End If

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

		U_IOMT2LOG( cUUID,,,,,, ERRO_COMUNICACAO_CDCF,,, Date(), Time(),;
		, 'Erro no Parse da URL do WSDL do WebService: ' + oWsdl:cError )

		Return cXml

	End If

	// Atribui a variavel array com as operacoes do WebService
	aOps := aClone( oWsdl:ListOperations() )

	If Len( aOps ) == 0

		U_IOMT2LOG( cUUID,,,,,, ERRO_COMUNICACAO_CDCF,,, Date(), Time(),;
		, 'Não foi disponibilizada nenhuma operação pelo WebService através do documento WSDL: ' + oWsdl:cError )

		Return cXml

	End If

	// Seta a operacao a ser executada
	If ! oWsdl:SetOperation( aOps[ aScan( aOps, { | X | X[ 1 ] == cMetodo} ), 1 ] )

		U_IOMT2LOG( cUUID,,,,,, ERRO_COMUNICACAO_CDCF,,, Date(), Time(),;
		, 'Não foi possível definir o método ' + cMetodo + ' como a operação a ser realizada: ' + oWsdl:cError )

		Return cXml

	End If

	// Atribui a variavel os tipos complexos da operacao
	aComplex := oWsdl:NextComplex()

	If Len( aComplex ) == 0

		U_IOMT2LOG( cUUID,,,,,, ERRO_COMUNICACAO_CDCF,,, Date(), Time(),;
		, 'Nenhum Elemeto do Tipo Complexo foi Localizado: ' + oWsdl:cError )

		Return cXml

	End If

	// Atribui a variavel os tipos simples da operacao
	aSimple  := oWsdl:SimpleInput()

	If Len( aSimple ) == 0

		U_IOMT2LOG( cUUID,,,,,, ERRO_COMUNICACAO_CDCF,,, Date(), Time(),;
		, 'Nenhum Elemeto do Tipo Simples foi Localizado: ' + oWsdl:cError )

		Return cXml

	End If

	// Define o numero de ocorrencias do tipo complexo
	If ! oWsdl:SetComplexOccurs( aComplex[ 1 ], 1 )

		U_IOMT2LOG( cUUID,,,,,, ERRO_COMUNICACAO_CDCF,,, Date(), Time(),;
		, 'Não foi possível definir o número de vezes do Tipo Complexo: ' + oWsdl:cError )

		Return cXml

	End IF

	// Seta o valor do tipo simples correspondente ao ID do Sistema Protheus no CDCF
	If ! oWsdl:SetValue( aSimple[1][1], cIDSist )

		U_IOMT2LOG( cUUID,,,,,, ERRO_COMUNICACAO_CDCF,,, Date(), Time(),;
		, 'Não foi possível definir o valor da variável ' + aSimple[1][2] + ': ' + oWsdl:cError )

		Return cXml

	End If

	// Seta o valor do tipo simples correspondente ao ID da Consulta no CDCF
	If  ! oWsdl:SetValue( aSimple[2][1], cIdCons  )

		U_IOMT2LOG( cUUID,,,,,, ERRO_COMUNICACAO_CDCF,,, Date(), Time(),;
		, 'Não foi possível definir o valor da variável ' + aSimple[2][2] + ': ' + oWsdl:cError )

		Return cXml

	End If

	// Se operacao for ConsultaCliente Seta o codigo dos clientes a serem consultados
	If cMetodo == 'ConsultaCliente'

		If  ! oWsdl:SetValues( aSimple[3][1], aParams  )

			U_IOMT2LOG( cUUID,,,,,, ERRO_COMUNICACAO_CDCF,,, Date(), Time(),;
			, 'Não foi possível definir os valores da variável ' + aSimple[3][2] + ': ' + oWsdl:cError )

			Return cXml

		End If

	End If

	// Efetua comunicacao com WebService do CDCF
	If ! oWsdl:SendSoapMsg()

		U_IOMT2LOG( cUUID,,,,,, ERRO_COMUNICACAO_CDCF,,, Date(), Time(),;
		, 'Não foi possível o envio do documento SOAP gerado ao endereço definido: ' + oWsdl:cError )

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

	Local aCliente  := {}
	Local aContatos := {}
	Local aClientes := {}
	Local aDtHrAlt  := {}
	Local cEsfera   := ''
	Local nX        := 0
	Local oXml      := TXmlManager():New()

	// Parse do XML retornado
	If ! oXml:Parse( cXmlPrc )

		U_IOMT2LOG( cUUID,,,,,, ERRO_PROCESSAMENTO_XML,,, Date(), Time(),;
		cXmlPrc, 'Erro no Parse do XML de retorno do CDCF: ' + oXml:LastError() )

		Return aClientes

	End If

	// Desce o nivel do XML ate encontrar as Tags desejadas para processamento
	Do While ! oXml:cName $ 'Cliente/RegistroConsulta/IntegracaoClientes/ErroConsulta'

		If ! oXml:DOMChildNode()

			Exit

		End If

	End Do

	// Erro retornado pela consulta ao CDCF
	If oXml:cName = 'ErroConsulta'

		U_IOMT2LOG( cUUID,,,,,, ERRO_PROCESSAMENTO_XML,,, Date(), Time(),;
		cXmlPrc, 'Erro Retornado na Consulta ao CDCF: ' + GetValTag( oXml, 'MensagemExcecao' ) )

		Return aClientes

	End If

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

		End If

		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

	For nX := 1 To Len( aClientes )

		cIdCDCF := aClientes[ nX, 1 , aScan( aClientes[ nX, 1 ], { | X | X[ 1 ] == "A1_XCD_CDC" } ), 2]

		nPos := aScan( aDtHrAlt, {|X| X[1] == cIdCDCF } )

		If nPos > 0

			aAdd( aClientes[ nX, 1 ], { 'A1_XDH_CDC', aDtHrAlt[ nPos, 2 ], Nil  } )

		End If

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

	cRet := oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = cTag } ) ] [2]

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

	End Do

	Do While oXml:cName # 'Cliente'

		oXml:DOMParentNode()

	End Do

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

			End Do

			oXml:DOMParentNode()

		End If

		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

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

	End Do

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

	End Do

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

	End Do

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

	Local nX       := 0
	Local nY       := 0
	Local aArea    := GetArea()
	Local cCodigo  := ''
	Local nOpc     := 0
	Local cCodCon  := ''
	Local aLog     := {}
	Local aLogCli  := {}
	Local aLogCont := {}


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

			DisarmTransaction()

		End If

		EndTran()
			
//TODO A seguir as consultas ao array de clientes para consulta de dados para registro do log
	//aClientes[nX, 1,aScan( aClientes[nX,1], {|X| X[1] == "A1_COD"} ),2]
	//aClientes[nX, 2, nPos, 1, aScan(  aClientes[nX, 2, nPos, 1], {|X| X[1] == "U5_CODCONT"} ), 2]
		aAdd( aLogCli, { } )

		If ! lMsErroAuto

			BeginTran()

			For nY := 1 To Len( aClientes[ NX, 2 ] )

				cCodCon := aClientes[ nX, 2, nY, 1, aScan( aClientes[ nX, 2, nY, 1 ], { | X | X[ 1 ] == 'U5_CODCONT' } ), 2 ]

				DeleteCont( cCodCon, cCodigo )

				MSExecAuto( { | X, Y, Z, A, B | TMKA070( X, Y, Z, A, B ) }, aClientes[ nX, 2, nY, 1 ], 3, {}, aClientes[ nX, 2, nY, 2 ], .F. )

				RecLock( 'AC8', .T. )

				AC8->AC8_ENTIDA := 'SA1'
				AC8->AC8_CODENT := aClientes[ nX, 1 , aScan( aClientes[ nX, 1 ], { | X | X[ 1 ] == 'A1_COD' } ), 2] + '01'
				AC8->AC8_CODCON := aClientes[ nX, 2, nY, 1, aScan( aClientes[ nX, 2, nY, 1 ], { | X | X[ 1 ] == 'U5_CODCONT' } ), 2 ]

				MsUnlock()

				If lMsErroAuto

					VarInfo( 'GetAutoGRLog()', GetAutoGRLog(), , .F., .T. )
					VarInfo( 'aClientes[ nX, 2, nY, 1 ]', aClientes[ nX, 2, nY, 1 ],, .F., .T. )
					VarInfo( 'aClientes[ nX, 2, nY, 2 ]', aClientes[ nX, 2, nY, 2 ],, .F., .T. )
					DisarmTransaction()
					lMsErroAuto := .F.

				Else

				End If

			Next nY

			EndTran()

		End If

	Next nX
	//TODO Tratat Registro de Log
	//U_IOMT2LOG( cUUID,,,,,, /*IMPORTADO_COM_FALHAS*/,,, Date(), Time(),;
	//cXmlPrc,, /*'Observação'*/ )

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

/*/{Protheus.doc} IOMT1CMB
Retorna os opções da combox do Campo AGB_XTIPO
@author Elton Teodoro Alves
@since 21/02/2017
@version 12.1.014
@return Character, String com as opções
/*/
User Function IOMT1CMB()

	Local cRet := ''

	cRet += '1=Telefone Principal;'
	cRet += '2=Telefone Comercial;'
	cRet += '3=Telefone Fax;'
	cRet += '4=Telefone Celular;'
	cRet += '5=Telefone Residencial;'
	cRet += '6=Email;'
	cRet += '7=Telefone Comercial Adicional;'
	cRet += '8=Telefone Residencial Adicional;'
	cRet += '9=Email Adicional;'
	cRet += '10=Telefone Celular Adicional;'
	cRet += '11=Telefone Fax Adicional;'
	cRet += '12=Telefone Principal Adicional;'

Return cRet