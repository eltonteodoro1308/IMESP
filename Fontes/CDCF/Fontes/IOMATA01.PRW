#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOMATA01
User Function chamada via EAI para executar a importação do cadastro de clientes incluir e alterados do CDCF.
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

	Local cMetodo   := ''
	Local cRet      := ''
	Local aOps      := {}
	Local aComplex  := {}
	Local aSimple   := {}
	Local cResponse := ''

	// --------------------------------------------------------------------
	// Atribui a Variáveis correspondentes os valores dos parametros
	// necessários para acesso ao CDCF
	// --------------------------------------------------------------------
	Local cWSDLUrl  := GetMv( 'IO_CDCFWSD' ) // URL do WSDL do WebService do CDCF
	Local cIDSist   := '4'//GetMv( 'IO_CDCFIDS' ) // ID do Sistema Protheus no CDCF
	Local cIdCons   := GetMv( 'IO_CDCFIDC' ) // ID da Consulta no CDCF
	// --------------------------------------------------------------------

	Local oWSDL     := TWsdlManager():New()
	Local aClientes := {}
	Local aCliente  := {}
	Local aID       := {}
	Local aDtHrAlt  := {}
	Local cEsfera   := ''
	Local cEndereco := ''

	Private oXml            := TXmlManager():New()
	Private cErro           := ''
	Private	lMsErroAuto		:= .F.
	Private	lMsHelpAuto		:= .T.
	Private	lAutoErrNoFile	:= .T.


	// Define que a validacao da resposta do WebService do CDCF nao sera processada
	oWsdl:lProcResp := .F.

	// Verifica se foram enviados clientes e define o metodo a ser executado
	If cParams == ProcName() .Or. Empty( cParams )

		cMetodo := 'SolicitaClientesParaIntegrar'

	Else

		cMetodo := 'ConsultaCliente'

	End If

	// Efetua o parse do WSDL do WebService
	If ! oWsdl:ParseUrl( cWSDLUrl )

		Return oWsdl:cError

	End If

	// Atribui a variavel array com as operacoes do WebService
	aOps := aClone( oWsdl:ListOperations() )

	If Len( aOps ) == 0

		Return oWsdl:cError

	End If

	// Seta a operacao a ser executada
	If ! oWsdl:SetOperation( aOps[ aScan( aOps, { | X | X[ 1 ] == cMetodo} ), 1 ] )

		Return oWsdl:cError

	End If

	// Atribui a variavel os tipos complexos da operacao
	aComplex := oWsdl:NextComplex()

	If Len( aComplex ) == 0

		Return oWsdl:cError

	End If

	// Atribui a variavel os tipos simples da operacao
	aSimple  := oWsdl:SimpleInput()

	If Len( aSimple ) == 0

		Return oWsdl:cError

	End If

	// Define o numero de ocorrencias do tipo complexo
	If ! oWsdl:SetComplexOccurs( aComplex[ 1 ], 1 )

		Return oWsdl:cError

	End IF

	// Seta o valor do tipo simples correspondente ao ID do Sistema Protheus no CDCF
	If ! oWsdl:SetValue( aSimple[1][1], cIDSist )

		Return oWsdl:cError

	End If

	// Seta o valor do tipo simples correspondente ao ID da Consulta no CDCF
	If  ! oWsdl:SetValue( aSimple[2][1], cIdCons  )

		Return oWsdl:cError

	End If

	// Se operacao for ConsultaCliente Seta o codigo dos clientes a serem consultados
	If cMetodo == 'ConsultaCliente'

		If  ! oWsdl:SetValues( aSimple[3][1], StrTokArr2( cParams, ',', .T. )  )

			Return oWsdl:cError

		End If

	End If

	// Efetua comunicacao com WebService do CDCF
	If ! oWsdl:SendSoapMsg()

		Return oWsdl:cError

	End If

	// Atribui a Variável o retorno do WebService
	cResponse := oWsdl:GetSoapResponse()

	// Parse do XML retornado
	If ! oXml:Parse( cResponse )

		Return 'Erro no Parse do XML de retorno do CDCF - ' + oXml:LastError()

	End If

	// Desce o nivel do XML ate encontrar as Tags desejadas
	Do While ! oXml:cName $ 'Cliente/RegistroConsulta/IntegracaoClientes/ErroConsulta'

		oXml:DOMChildNode()

	End Do

	If oXml:cName = 'ErroConsulta'

		Return 'Erro no Retorno no CDCF: ' + oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'MensagemExcecao' } ) ] [2]

	End If

	Do While AllWaysTrue()

		If oXml:cName == 'Cliente'

			cEsfera := oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'IdTipoEsfera' } ) ] [2]
			aAdd( aID, oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'IdCliente' } ) ] [2] )

			aAdd( aCliente, { 'A1_COD'   , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'CodigoERP' } ) ] [2], Nil } )
			aAdd( aCliente, { 'A1_LOJA'  , '00', Nil } )
			aAdd( aCliente, { 'A1_PESSOA', If( cEsfera $ '1235', 'J', 'F' ), Nil } )
			aAdd( aCliente, { 'A1_TIPO', 'R', Nil } )

			If cEsfera $ '1235'

				oXml:DOMChildNode()

				If cEsfera $ '123'

					Do While oXml:cName # 'OrgaoPublico'

						oXml:DOMNextNode()

					End Do

					oXml:DOMChildNode()

				End If

				Do While oXml:cName # 'PessoaJuridica'

					oXml:DOMNextNode()

				End Do

				aAdd( aCliente, { 'A1_NOME'  , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'RazaoSocial' } ) ] [2], Nil } )
				aAdd( aCliente, { 'A1_NREDUZ', oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'NomeFantasia' } ) ] [2], Nil } )
				aAdd( aCliente, { 'A1_CGC'   , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'CNPJ' } ) ] [2], Nil } )
				aAdd( aCliente, { 'A1_INSCR' , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'InscricaoEstadual' } ) ] [2], Nil } )
				aAdd( aCliente, { 'A1_INSCRM', oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'InscricaoMunicipal' } ) ] [2], Nil } )

			ElseIf cEsfera $ '4'

				oXml:DOMChildNode()

				Do While oXml:cName # 'PessoaFisica'

					oXml:DOMNextNode()

				End Do

				aAdd( aCliente, { 'A1_NOME'  , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'Nome' } ) ] [2], Nil } )
				aAdd( aCliente, { 'A1_NREDUZ', oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'Nome' } ) ] [2], Nil } )
				aAdd( aCliente, { 'A1_CGC'   , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'CPF' } ) ] [2], Nil } )
				aAdd( aCliente, { 'A1_PFISIC', oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'RG' } ) ] [2], Nil } )

			End If

			Do While oXml:cName # 'Cliente'

				oXml:DOMParentNode()

			End Do

			oXml:DOMChildNode()

			Do While AllWaysTrue()

				If oXml:cName == 'Endereco'

					cEndereco := oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'TipoLogradouro' } ) ] [2] + ' '
					cEndereco += oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'Logradouro' } ) ] [2] + ' '
					cEndereco += oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'LogradouroNumero' } ) ] [2]

					If oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'IdTipoEndereco' } ) ] [2] == '1'

						aAdd( aCliente, { 'A1_END'     , cEndereco, Nil } )
						aAdd( aCliente, { 'A1_COMPLEM' , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'LogradouroComplemento' } ) ] [2], Nil } )
						aAdd( aCliente, { 'A1_BAIRRO'  , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'Bairro' } ) ] [2], Nil } )
						aAdd( aCliente, { 'A1_EST'     , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'SiglaUnidadeFederativa' } ) ] [2], Nil } )
						aAdd( aCliente, { 'A1_CEP'     , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'CEP' } ) ] [2], Nil } )
						aAdd( aCliente, { 'A1_COD_MUN' , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'CodigoMunicipio' } ) ] [2], Nil } )
						aAdd( aCliente, { 'A1_MUN'     , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'Municipio' } ) ] [2], Nil } )

					ElseIF oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'IdTipoEndereco' } ) ] [2] == '2'

						aAdd( aCliente, { 'A1_ENDCOB', cEndereco, Nil } )


					ElseIf oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'IdTipoEndereco' } ) ] [2] == '3'

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

			Do While AllWaysTrue()

				If oXml:cName == 'ClienteContato' .And.;
				oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'NotaFiscalEletronica' } ) ] [2] == 'true'

					oXml:DOMChildNode()

					Do While AllWaysTrue()

						If oXml:cName == 'MeioComunicacao' .And.;
						oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'IdTipoContato' } ) ] [2] == '6'

							If aScan( aCliente, { |X| X[1] == 'A1_EMAIL' } ) == 0

								aAdd( aCliente, { 'A1_EMAIL',;
								oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'Email' } ) ] [2], Nil } )

							Else

								aCliente[aScan( aCliente, { |X| X[1] == 'A1_EMAIL' } )][2] +=;
								';' + oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'Email' } ) ] [2]

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

			aAdd( aClientes, aClone( aCliente ) )

			aSize( aCliente, 0 )

		ElseIf oXml:cName == 'IntegracaoClientes'

			aAdd( aDtHrAlt, {;
			oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'DataHoraAlteracao' } ) ] [2],;
			oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'IdCliente' } ) ] [2] } )

		End If

		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

	oJson := TJsonParser():New()
	cJson := FWJsonSerialize(aClientes)
	nLen  := Len( cJson )
	aJson := {}
	nRet  := 0

	If oJson:Json_Parser( cJson, nLen, @aJson , nRet )

		Return

	Else

		Return

	End If


	For nX := 1 To Len(aClientes)

		BeginTran()

		MSExecAuto( { | X, Y | MATA030( X, y ) }, aClientes[nX], 3 )

		If lMsErroAuto

			VarInfo( 'GetAutoGRLog()', GetAutoGRLog(), , .F., .T.)
			DisarmTransaction()
			lMsErroAuto := .F.

		Else

			ConOut('OK')

		End If

		EndTran()

	Next nX

	cRet := DecodeUTF8( cResponse )

Return cRet

/*/{Protheus.doc} GetVal
Retorna o valor da Tag descendente solicitada correspondenente a Tag posicionada.
@author Elton Teodoro Alves
@since 07/02/2017
@version 12.1.014
@param cTag, characters, Nome da Tag
@return characters, Valor da Tag
/*/
Static Function GetVal( cTag )

	cRet := oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = cTag } ) ] [2]

Return cRet


Static Function RegLog( cMsg )

Return