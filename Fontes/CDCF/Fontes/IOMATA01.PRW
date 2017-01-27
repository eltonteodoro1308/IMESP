#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOMATA01
//User Function chamada via EAI para executar a importação do cadastro de clientes incluir e alterados do CDCF.
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
	Local cWSDLUrl  := GetMv( 'IO_CDCFWSD' )
	Local cIDSist   := GetMv( 'IO_CDCFIDS'  )
	Local cIdCons   := GetMv( 'IO_CDCFIDC' )
	Local oWSDL     := TWsdlManager():New()
	Local oXml      := TXmlManager():New()
	Local aClientes := {}
	Local aCliente  := {}
	Local cID       := ''
	Local cEsfera   := ''
	Local cEndereco := ''

	Default cParams := '279191,253425,253383'

	oWsdl:lProcResp := .F.

	If cParams == ProcName() .Or. Empty( cParams )

		cMetodo := 'SolicitaClientesParaIntegrar'

	Else

		cMetodo := 'ConsultaCliente'

	End If

	If ! oWsdl:ParseUrl( cWSDLUrl )

		Return oWsdl:cError

	End If

	aOps := aClone( oWsdl:ListOperations() )

	If Len( aOps ) == 0

		Return oWsdl:cError

	End If

	If ! oWsdl:SetOperation( aOps[ aScan( aOps, { | X | X[ 1 ] == cMetodo} ), 1 ] )

		Return oWsdl:cError

	End If

	aComplex := oWsdl:NextComplex()

	If Len( aComplex ) == 0

		Return oWsdl:cError

	End If

	aSimple  := oWsdl:SimpleInput()

	If Len( aSimple ) == 0

		Return oWsdl:cError

	End If

	If ! oWsdl:SetComplexOccurs( aComplex[ 1 ], 1 )

		Return oWsdl:cError

	End IF

	If ! oWsdl:SetValue( aSimple[1][1], cIDSist )

		Return oWsdl:cError

	End If

	If  ! oWsdl:SetValue( aSimple[2][1], cIdCons  )

		Return oWsdl:cError

	End If

	If cMetodo == 'ConsultaCliente'

		If  ! oWsdl:SetValues( aSimple[3][1], StrTokArr2( cParams, ',', .T. )  )

			Return oWsdl:cError

		End If

	End If

	If ! oWsdl:SendSoapMsg()

		Return oWsdl:cError

	End If

	cResponse := oWsdl:GetSoapResponse()

	If ! oXml:Parse( cResponse )

		Return 'Erro no Parse do XML de retorno do CDCF.'

	End If

	Do While oXml:cName # 'Cliente'

		oXml:DOMChildNode()

	End Do

	Do While AllWaysTrue()

		cEsfera := oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'IdTipoEsfera' } ) ] [2]
		cID     := oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'IdCliente' } ) ] [2]

		aAdd( aCliente, { 'A1_COD'   , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'CodigoERP' } ) ] [2], Nil } )
		aAdd( aCliente, { 'A1_LOJA'  , '00', Nil } )
		aAdd( aCliente, { 'A1_PESSOA', If( cEsfera $ '1235', 'J', 'F' ), Nil } )

		/*
		aAdd( aCliente, { 'A1_CONTAT', , Nil } )

		aAdd( aCliente, { 'A1_DDI'   , , Nil } )
		aAdd( aCliente, { 'A1_DDD'   , , Nil } )
		aAdd( aCliente, { 'A1_TEL'   , , Nil } )
		aAdd( aCliente, { 'A1_FAX'   , , Nil } )

		*/

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

			Do While oXml:cName # 'PessoaFisica'

				oXml:DOMNextNode()

			End Do

			aAdd( aCliente, { 'A1_NOME'  , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'NOME' } ) ] [2], Nil } )
			aAdd( aCliente, { 'A1_NREDUZ', oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'NOME' } ) ] [2], Nil } )
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

					aAdd( aCliente, { 'A1_END'    , cEndereco, Nil } )
					aAdd( aCliente, { 'A1_COMPLEM', oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'LogradouroComplemento' } ) ] [2], Nil } )
					aAdd( aCliente, { 'A1_BAIRRO' , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'Bairro' } ) ] [2], Nil } )
					aAdd( aCliente, { 'A1_EST'    , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'SiglaUnidadeFederativa' } ) ] [2], Nil } )
					aAdd( aCliente, { 'A1_CEP'    , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'CEP' } ) ] [2], Nil } )
					aAdd( aCliente, { 'A1_COD_MU' , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'CodigoMunicipio' } ) ] [2], Nil } )
					aAdd( aCliente, { 'A1_MUN'    , oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = 'Municipio' } ) ] [2], Nil } )

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

		aAdd( aClientes, aClone( aCliente ) )

		aSize( aCliente, 0 )

		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

	cRet := DecodeUTF8( cResponse )

Return cRet