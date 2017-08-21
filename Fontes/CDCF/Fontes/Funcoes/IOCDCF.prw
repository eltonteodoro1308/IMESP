#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOCDCF
//Executa a busca do xml com os dados dos clientes a serem incluidos e atualizados no CDCF
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
@param cXml, characters, O conteúdo da tag Content do XML recebido pelo EAI Protheus.
@param cError, characters, Variável passada por referência, serve para alimentar a mensagem de erro, nos casos em que a transação não foi bem sucedida.
@param cWarning, characters, Variável passada por referência, serve para alimentar uma mensagem de warning para o EAI.
@param cParams, characters,  Parâmetros passados na mensagem do EAI.
@param oFwEai, object, O objeto de EAI criado na camada do EAI Protheus.
@return characters, Retorno com resultado da operação.
/*/
User Function IOCDCF( cXml, cError, cWarning, cParams, oFwEai )

	Local cXmlCDCF  := ''
	Local aArrStrut := {}
	Local oXml      := TXmlManager():New()
	Local cUuid     := ''
	Local aContatos := {}

	oXml:Parse( oFwEai:cXml )

	cUuid := oXml:XPathGetNodeValue( '/TOTVSIntegrator/DocIdentifier' )

	//GetXmlCDCF( @cXmlCDCF, cUuid )
	U_GetExemplo( @cXmlCDCF )

	MontaStrut( @aArrStrut, cXmlCDCF, cUuid )

	GravClient( @aArrStrut )

	DelVincCnt( @aArrStrut, @aContatos )

	DelContato( @aContatos )

	GravContat( @aArrStrut )

	VincContato( @aArrStrut )

	//ConfInteg( @aArrStrut )

	EnviaErro( @aArrStrut, cUuid )

	oFwEai:cReturnMsg := cXmlCDCF

Return oFwEai:cReturnMsg

/*/{Protheus.doc} GetXmlCDCF
Conecta com o WebService do CDCF no método SolicitaClinetesParaIntegrar e recebe o XML a ser integrado com o Protheus
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
@param cXml, characters, Variável passada por referêcia que recebe o XML retornado pelo CDCF
@param cErro, characters, Variável passada por referência que recebe o erro ocorrido na integração com o CDCF
/*/
Static Function GetXmlCDCF( cXml, cUuid )

	Local cWSDLUrl := GetMv( 'IO_CDCFWSD' ) // URL do WSDL do WebService do CDCF
	Local cIDSist  := GetMv( 'IO_CDCFIDS' ) // ID do Sistema Protheus no CDCF
	Local cIdCons  := GetMv( 'IO_CDCFIDC' ) // ID da Consulta no CDCF
	Local oWSDL    := TWsdlManager():New()
	Local aOps     := {}
	Local aComplex := {}
	Local aSimple  := {}
	Local cMsg     := ''

	// Define que a validacao da resposta do WebService do CDCF nao sera processada
	oWsdl:lProcResp := .F.

	// Efetua o parse do WSDL do WebService
	If ! oWsdl:ParseUrl( cWSDLUrl )

		U_IOEXCPT( cUuid, cMsg := 'Erro no Parse da URL do WSDL do WebService: ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Atribui a variavel array com as operacoes do WebService
	aOps := aClone( oWsdl:ListOperations() )

	If Len( aOps ) == 0

		U_IOEXCPT( cUuid, cMsg := 'Não foi disponibilizada nenhuma operação pelo WebService através do documento WSDL: ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Seta a operacao a ser executada
	If ! oWsdl:SetOperation( aOps[ aScan( aOps, { | X | X[ 1 ] == 'SolicitaClientesParaIntegrar'} ), 1 ] )

		U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o método SolicitaClientesParaIntegrar como a operação a ser realizada: ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Atribui a variavel os tipos complexos da operacao
	aComplex := oWsdl:NextComplex()

	If Len( aComplex ) == 0

		U_IOEXCPT( cUuid, cMsg := 'Nenhum Elemeto do Tipo Complexo foi Localizado: ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Atribui a variavel os tipos simples da operacao
	aSimple  := oWsdl:SimpleInput()

	If Len( aSimple ) == 0

		U_IOEXCPT( cUuid, cMsg := 'Nenhum Elemeto do Tipo Simples foi Localizado: ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Define o numero de ocorrencias do tipo complexo
	If ! oWsdl:SetComplexOccurs( aComplex[ 1 ], 1 )

		U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o número de vezes do Tipo Complexo: ' + oWsdl:cError )

		UserException( cMsg )

	End IF

	// Seta o valor do tipo simples correspondente ao ID do Sistema Protheus no CDCF
	If ! oWsdl:SetValue( aSimple[1][1], cIDSist )

		U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o valor da variável ' + aSimple[1][2] + ': ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Seta o valor do tipo simples correspondente ao ID da Consulta no CDCF
	If  ! oWsdl:SetValue( aSimple[2][1], cIdCons  )

		U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o valor da variável ' + aSimple[2][2] + ': ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Efetua comunicacao com WebService do CDCF
	If ! oWsdl:SendSoapMsg()

		U_IOEXCPT( cUuid, cMsg := 'Não foi possível o envio do documento SOAP gerado ao endereço definido: ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Atribui a Variável o retorno do WebService
	cXml := oWsdl:GetSoapResponse()

Return

/*/{Protheus.doc} MontaStrut
//Monta array com a estrutura de dados a ser executado na inclusão/ajuste do cadastro de clientes
e de seus contatos e meios de comunicaçãi
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@param aArrStrut, array, array passado por referência que recebe a estrutura de dados
/*/
Static Function MontaStrut( aArrStrut, cXml, cUuid )

	Local oXml     := TXmlManager():New()
	Local cMsg     := ''
	Local nPos     := 0
	Local oCliente := Nil

	// Parse do XML retornado
	If ! oXml:Parse( cXml )

		U_IOEXCPT( cUuid, cMsg := 'Erro no Parse do XML de retorno do CDCF: ' + oXml:LastError() )

		UserException( cMsg )

	End If

	// Desce o nivel do XML ate encontrar as Tags desejadas para processamento
	Do While ! oXml:cName $ 'Cliente/RegistroConsulta/IntegracaoClientes/ErroConsulta'

		If ! oXml:DOMChildNode()

			Exit

		End If

	End Do

	// Erro retornado pela consulta ao CDCF
	If oXml:cName = 'ErroConsulta'

		U_IOEXCPT( cUuid, cMsg := 'Erro Retornado na Consulta ao CDCF: ' + GetValTag( oXml, 'MensagemExcecao' )  )

		UserException( cMsg )

	End If

	// Percorre cada Tag do XML no nível Atual até que não haja mais uma próxima Tag
	Do While .T.

		If oXml:cName == 'Cliente'

			oCliente := U_IOSA1BLD()

			oCliente:cXCDCDCF := GetValTag( oXml, 'IdCliente' )
			oCliente:cCOD     := GetValTag( oXml, 'CodigoERP' )
			oCliente:cNOME    := GetValTag( oXml, 'NomeCliente' )
			oCliente:cCGC     := GetValTag( oXml, 'DocumentoCliente' )
			oCliente:cMSBLQL  := If( GetValTag( oXml, 'ClienteAtivo' ) == 'true', '2', '1' )
			oCliente:cXESFERA := GetValTag( oXml, 'IdTipoEsfera' )
			oCliente:cPESSOA  := If( oCliente:cXESFERA = '4', 'F' , 'J' )

			oCliente:dDTCAD  := GetDtCadAlt( oXml, 'DataHoraCriacao' )
			oCliente:dXDTALT := GetDtCadAlt( oXml, 'DataHoraAlteracao' )

			If oCliente:cXESFERA == '4'

				GetFisica( @oCliente, oXml )

			ElseIf oCliente:cXESFERA == '5'

				GetJuridic( @oCliente, oXml )

			Else

				GetOrgPubl( @oCliente, oXml )

			End If

			GetEnd( @oCliente, oXml )

			GetTelPrinc( @oCliente, oXml )

			GetContato( @oCliente, oXml )

			aAdd( aArrStrut, oCliente )

		ElseIf oXml:cName == 'IntegracaoClientes'

			nPos := aScan( aArrStrut, { | X | X:cXCDCDCF == GetValTag( oXml, 'IdCliente' ) } )

			If nPos # 0

				oCliente := aArrStrut[ nPos ]

				oCliente:cXDHCDCF := GetValTag( oXml, 'DataHoraAlteracao' )

			End If

		End If

		// Verifica se existe mais tag´s no mesmo nível e passa para a próxima
		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

Return

/*/{Protheus.doc} GetDtCadAlt
//Retorna Data de criação ou alteração conforme solicitado
@author elton.alves
@since 07/08/2017
@version undefined
@param oXml, object, Objeto que representa o xml do CDCF
@param cDate, characters, tipo de data desejada Criação ou Alteração
@return return, Data de criação ou alteração conforme solicitado
/*/
Static Function GetDtCadAlt( oXml, cDateType )

	Local dRet  := cTod('')
	Local cDate := ''
	Local cAno  := ''
	Local cMes  := ''
	Local cDia  := ''

	oXml:DOMChildNode()

	Do While .T.

		If oXml:cName == 'ControleRegistro'

			cDate :=  GetValTag( oXml, cDateType )

			cAno := SubStr( cDate, 1, 4 )
			cMes := SubStr( cDate, 6, 2 )
			cDia := SubStr( cDate, 9, 2 )

			dRet := StoD( cAno + cMes + cDia )

			Exit

		End If

		// Verifica se existe mais tag´s no mesmo nível e passa para a próxima
		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

	oXml:DOMParentNode()

Return dRet

/*/{Protheus.doc} GetFisica
//Popula os campos do objeto do cliente com dados pertinentes a pessoa física
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@param oCliente, object, Objeto que representa o cliente
@param oXml, object, Objeto que representa o xml do CDCF
/*/
Static Function GetFisica( oCliente, oXml )

	Local cDate := ''
	Local cAno  := ''
	Local cMes  := ''
	Local cDia  := ''

	oXml:DOMChildNode()

	Do While .T.

		If oXml:cName == 'PessoaFisica'

			cDate :=  GetValTag( oXml, 'DataNascimento' )

			cAno := SubStr( cDate, 1, 4 )
			cMes := SubStr( cDate, 6, 2 )
			cDia := SubStr( cDate, 9, 2 )

			oCliente:dDTNASC := StoD( cAno + cMes + cDia )
			oCliente:cXSEXO  := GetValTag( oXml, 'IdTipoSexo' )
			oCliente:cNREDUZ := oCliente:cNome

			Exit

		End If

		// Verifica se existe mais tag´s no mesmo nível e passa para a próxima
		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

	oXml:DOMParentNode()

Return

/*/{Protheus.doc} GetJuridic
//Popula os campos do objeto do cliente com dados pertinentes a pessoa juridica
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@param oCliente, object, Objeto que representa o cliente
@param oXml, object, Objeto que representa o xml do CDCF
/*/
Static Function GetJuridic( oCliente, oXml )

	oXml:DOMChildNode()

	Do While .T.

		If oXml:cName == 'PessoaJuridica'

			oCliente:cNREDUZ  := GetValTag( oXml, 'NomeFantasia' )
			oCliente:cINSCR   := GetValTag( oXml, 'InscricaoEstadual' )
			oCliente:cINSCRM  := GetValTag( oXml, 'InscricaoMunicipal' )
			oCliente:cXORGPUB := If( GetValTag( oXml, 'IsOrgaoPublico' ) == 'true', '1', '2' )
			oCliente:cXSEXO   := '0'

			Exit

		End If

		// Verifica se existe mais tag´s no mesmo nível e passa para a próxima
		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

	oXml:DOMParentNode()

Return

/*/{Protheus.doc} GetOrgPubl
//Popula os campos do objeto do cliente com dados pertinentes a Orgão Púlico
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@param oCliente, object, Objeto que representa o cliente
@param oXml, object, Objeto que representa o xml do CDCF
/*/
Static Function GetOrgPubl( oCliente, oXml )

	oXml:DOMChildNode()

	Do While .T.

		If oXml:cName == 'OrgaoPublico'

			oXml:DOMChildNode()

			Do While .T.

				If oXml:cName == 'PessoaJuridica'

					oCliente:cNREDUZ  := GetValTag( oXml, 'NomeFantasia' )
					oCliente:cINSCR   := GetValTag( oXml, 'InscricaoEstadual' )
					oCliente:cINSCRM  := GetValTag( oXml, 'InscricaoMunicipal' )
					oCliente:cXORGPUB := If( GetValTag( oXml, 'IsOrgaoPublico' ) == 'true', '1', '2' )
					oCliente:cXSEXO   := '0'

					Exit

				End If

				If ! oXml:DOMNextNode()

					Exit

				End If

			End Do

			oXml:DOMParentNode()

			Exit

		End If

		// Verifica se existe mais tag´s no mesmo nível e passa para a próxima
		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

	oXml:DOMParentNode()

Return

/*/{Protheus.doc} GetEnd
//Popula os campos do objeto do cliente com dados pertinentes aos enderecos
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@param oCliente, object, Objeto que representa o cliente
@param oXml, object, Objeto que representa o xml do CDCF
/*/
Static Function GetEnd( oCliente, oXml )

	Local cTipoEnd := ''

	oXml:DOMChildNode()

	Do While .T.

		If oXml:cName == 'Endereco'

			cTipoEnd := GetValTag( oXml, 'IdTipoEndereco' )

			If cTipoEnd == '1' // Principal

				oCliente:cEND     := GetValTag( oXml, 'TipoLogradouro' ) + ' '
				oCliente:cEND     += GetValTag( oXml, 'Logradouro' ) + ', '
				oCliente:cEND     += GetValTag( oXml, 'LogradouroNumero' )

				oCliente:cCOMPLEM := GetValTag( oXml, 'LogradouroComplemento' )
				oCliente:cBAIRRO  := GetValTag( oXml, 'Bairro' )
				oCliente:cCOD_MUN := GetValTag( oXml, 'CodigoMunicipio' )
				oCliente:cMUN     := GetValTag( oXml, 'Municipio' )
				oCliente:cEST     := GetValTag( oXml, 'SiglaUnidadeFederativa' )
				oCliente:cCEP     := GetValTag( oXml, 'CEP' )
				oCliente:cXNMPAIS := GetValTag( oXml, '' )

			ElseIf cTipoEnd == '2' // Cobrança

				oCliente:cENDCOB  := GetValTag( oXml, 'TipoLogradouro' ) + ' '
				oCliente:cENDCOB  += GetValTag( oXml, 'Logradouro' ) + ', '
				oCliente:cENDCOB  += GetValTag( oXml, 'LogradouroNumero' )

				oCliente:cXCMPCOB := GetValTag( oXml, 'LogradouroComplemento' )
				oCliente:cXBROCOB := GetValTag( oXml, 'Bairro' )
				oCliente:cXCDMNCB := GetValTag( oXml, 'CodigoMunicipio' )
				oCliente:cXMUNCOB := GetValTag( oXml, 'Municipio' )
				oCliente:cXESTCOB := GetValTag( oXml, 'SiglaUnidadeFederativa' )
				oCliente:cXCEPCOB := GetValTag( oXml, 'CEP' )
				oCliente:cXNMPSCB := GetValTag( oXml, '' )

			ElseIf cTipoEnd == '3' // Entrega Principal

				oCliente:cENDENT  := GetValTag( oXml, 'TipoLogradouro' ) + ' '
				oCliente:cENDENT  += GetValTag( oXml, 'Logradouro' ) + ', '
				oCliente:cENDENT  += GetValTag( oXml, 'LogradouroNumero' )

				oCliente:cXCMPENT := GetValTag( oXml, 'LogradouroComplemento' )
				oCliente:cXBROENT := GetValTag( oXml, 'Bairro' )
				oCliente:cXCDMNET := GetValTag( oXml, 'CodigoMunicipio' )
				oCliente:cXMUNENT := GetValTag( oXml, 'Municipio' )
				oCliente:cXESTENT := GetValTag( oXml, 'SiglaUnidadeFederativa' )
				oCliente:cXCEPENT := GetValTag( oXml, 'CEP' )
				oCliente:cXNMPSET := GetValTag( oXml, '' )

			End If

		End If

		// Verifica se existe mais tag´s no mesmo nível e passa para a próxima
		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

	oXml:DOMParentNode()

Return

/*/{Protheus.doc} GetTelPrinc
//Popula os campos do objeto do cliente com dados pertinentes ao telefone principal
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@param oCliente, object, Objeto que representa o cliente
@param oXml, object, Objeto que representa o xml do CDCF
/*/
Static Function GetTelPrinc( oCliente, oXml )

	oXml:DOMChildNode()

	Do While .T.

		If oXml:cName == 'MeioComunicacao'

			If GetValTag( oXml, 'IdTipoContato' ) = '1'

				oCliente:cDDI     := GetValTag( oXml, 'DDI' )
				oCliente:cDDD     := GetValTag( oXml, 'DDD' )
				oCliente:cTEL     := GetValTag( oXml, 'Telefone' )
				oCliente:cXRAMAL  := GetValTag( oXml, 'Ramal' )

			End If

			Exit

		End If

		// Verifica se existe mais tag´s no mesmo nível e passa para a próxima
		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

	oXml:DOMParentNode()

Return

/*/{Protheus.doc} GetContato
//Popula os campos do objeto do cliente com dados pertinentes aos contatos
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@param oCliente, object, Objeto que representa o cliente
@param oXml, object, Objeto que representa o xml do CDCF
/*/
Static Function GetContato( oCliente, oXml )

	Local oContato := Nil
	Local cPerfis  := ''

	oXml:DOMChildNode()

	Do While .T.

		If oXml:cName == 'ClienteContato'

			cPerfis := InfoPerfCont( oXml )

			aAdd( oCliente:aContatos, U_IOSU5BLD() )

			oContato := oCliente:aContatos[ Len( oCliente:aContatos ) ]

			oContato:cCODCONT := GetValTag( oXml, 'IdClienteContato' )
			oContato:cCONTAT  := GetValTag( oXml, 'NomeContato' )
			oContato:cXCOTCOM := If( '1' $ cPerfis, '1', '2' )
			oContato:cXFATPUB := If( '2' $ cPerfis, '1', '2' )
			oContato:cXFINANC := If( '3' $ cPerfis, '1', '2' )
			oContato:cXNF_E   := If( '4' $ cPerfis, '1', '2' )
			oContato:cXSRVGRF := If( '5' $ cPerfis, '1', '2' )
			oContato:cXPUBLIC := If( '6' $ cPerfis, '1', '2' )
			oContato:cXBOLELE := If( '7' $ cPerfis, '1', '2' )

			oContato:aMeioComun := GetMeioCom( oXml )

		End If

		// Verifica se existe mais tag´s no mesmo nível e passa para a próxima
		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

	oXml:DOMParentNode()

Return

/*/{Protheus.doc} InfoPerfCont
Resgata co XML as informações correspondentes ao perfil do contato
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
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

/*/{Protheus.doc} GetMeioCom
Resgata co XML as informações correspondentes ao perfil do contato
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@param oXml, object, Obejeto do Parser do XML retornado pelo XML
@return characteres, String concatenada com os perfis do contato
/*/
Static Function GetMeioCom( oXml )

	Local aRet     := {}
	Local oMeioCom := Nil
	Local cDDD     := ''
	Local cTel     := ''

	oXml:DOMChildNode()

	Do While AllWaysTrue()

		If oXml:cName == 'MeioComunicacao'

			aAdd( aRet, U_IOAGBBLD() )

			oMeioCom := aRet[ Len( aRet ) ]

			cDDD := GetValTag( oXml, 'DDD'      )
			cTel := GetValTag( oXml, 'Telefone' )

			oMeioCom:cCODIGO := GetValTag( oXml, 'IdMeioComunicacao' )
			oMeioCom:cXTIPO  := GetValTag( oXml, 'IdTipoContato'     )
			oMeioCom:cXEMAIL := GetValTag( oXml, 'Email'             )
			oMeioCom:cDDI    := GetValTag( oXml, 'DDI'               )
			oMeioCom:cDDD    := If( Empty( cDDD ), '0', cDDD         )
			oMeioCom:cTELEFO := If( Empty( cTel ), '0', cTel         )
			oMeioCom:cCOMP   := GetValTag( oXml, 'Ramal'             )

		End If

		If ! oXml:DOMNextNode()

			Exit

		End If

	EndDo

	oXml:DOMParentNode()

Return aRet

/*/{Protheus.doc} GetValTag
Retorna o valor da Tag descendente solicitada correspondenente a Tag posicionada no XML.
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
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

/*/{Protheus.doc} GravClient
//Percorre o array com a carga de dados dos clientes e faz a gravação dos mesmos
@author Elton Teodoro Alves
@since 08/08/2017
@version 12.1.017
@param aArrStrut, array, Array  com a carga de dados dos clientes
/*/
Static Function GravClient( aArrStrut )

	Local nX       := 0
	Local oCliente := Nil

	For nX := 1 To Len( aArrStrut )

		oCliente := aArrStrut[ nX ]

		oCliente:Grava()

	Next nX

Return

/*/{Protheus.doc} DelVincCnt
//Deleta o Vinculo dos Clientes incluidos/atualizados com sucesso com seus contatos correspondentes
@author Elton Teodoro Alves
@since 17/08/2017
@version 12.1.017
@param aArrStrut, array, Array com a carga de dados dos clientes
@param aContatos, array, Lista de Contatos a serem excluídos
/*/
Static Function DelVincCnt( aArrStrut, aContatos )

	Local aArea    := GetArea()
	Local nX       := 0
	Local oCliente := Nil
	Local cSeek    := ''

	DbSelectArea( 'AC8' )
	DbSetOrder( 2 ) // AC8_FILIAL + AC8_ENTIDA + AC8_FILENT + AC8_CODENT + AC8_CODCON

	For nX := 1 To Len( aArrStrut )

		oCliente := aArrStrut[ nX ]

		If ! oCliente:lErroAuto

			cSeek += FwxFilial( 'AC8' )
			cSeek += 'SA1'
			cSeek += FwxFilial( 'SA1' )
			cSeek += PadR( oCliente:cCOD, GetSx3Cache( 'A1_COD', 'X3_TAMANHO' ) )
			cSeek += oCliente:cLoja

			If DbSeek( cSeek )

				Do While !Eof() .And. AllTrim( cSeek ) == AC8->( AllTrim( AC8_FILIAL + AC8_ENTIDA + AC8_FILENT + AC8_CODENT ) )

					aAdd( aContatos, AC8->AC8_CODCON )

					RecLock( 'AC8', .F. )

					DbDelete()

					MsUnlock()

					DbSkip()

				End Do

			End If

			cSeek := ''

		End If

	Next nX

	RestArea( aArea )

Return

/*/{Protheus.doc} GravContat
//Exclui os contatos dos clientes do array com a carga de dados
@author Elton Teodoro Alves
@since 17/08/2017
@version 12.1.017
@param aContatos, array, Lista de Contatos a serem excluídos
/*/
Static Function DelContato( aContatos )

	Local nX       := 0
	Local nY       := 0
	Local aErro    := {}
	Local cErro    := ''
	Local aArea    := GetArea()
	Local aContato := {}

	Private	lMsErroAuto    := .F.
	Private	lMsHelpAuto    := .T.
	Private	lAutoErrNoFile := .T.

	For nX := 1 To Len( aContatos )

		DbSelectArea( 'SU5' )
		DbSetOrder( 1 )

		If DbSeek( FwxFilial( 'SU5' ) + aContatos[ nX ] )

			aAdd( aContato, { 'U5_CODCONT', SU5->U5_CODCONT, Nil } )
			aAdd( aContato, { 'U5_CONTAT' , SU5->U5_CONTAT , Nil } )

			MSExecAuto( { | X , Y, Z, A, B | TMKA070( X , Y, Z, A, B ) }, aContato, 5, {}, {}, .F. )

			If lMsErroAuto

				aErro := aClone( GetAutoGRLog() )

				For nY := 1 To Len( aErro )

					cErro += aErro[ nY ] + Chr(13) + Chr(10)

				Next nY

				ConOut( cErro )

				lMsErroAuto := .F.

			End If

			aSize( aContato, 0 )

		End If

	End If

	RestArea( aArea )

Return

/*/{Protheus.doc} GravContat
//Grava Contatos do Cliente
@author Elton Teodoro Alves
@since 17/08/2017
@version 12.1.017
@param aArrStrut, array, Array  com a carga de dados dos clientes
/*/
Static Function GravContat( aArrStrut )

	Local nX         := 0
	Local nY         := 0
	Local oCliente   := Nil
	Local oContato   := Nil

	For nX := 1 To len( aArrStrut )

		oCliente := aArrStrut[ nX ]

		If ! oCliente:lErroAuto

			For nY := 1 To Len( oCliente:aContatos )

				oContato := oCliente:aContatos[ nY ]

				oContato:Grava()

			Next nY

		End If

	Next nX

Return

/*/{Protheus.doc} GravContat
//Grava vinculo do Contatos com o Cliente
@author Elton Teodoro Alves
@since 17/08/2017
@version 12.1.017
@param aArrStrut, array, Array  com a carga de dados dos clientes
/*/
Static Function VincContato( aArrStrut )

	Local nX         := 0
	Local oCliente   := Nil

	For nX := 1 To len( aArrStrut )

		oCliente := aArrStrut[ nX ]

		If ! oCliente:lErroAuto

			oCliente:VincContat()

		End If

	Next nX

Return

/*/{Protheus.doc} ConfInteg
//Confirma a integração dos Clientes que tiveram seu cadastro e de seus contatos incluído/atualizado com sucesso
@author Elton Teodoro Alves
@since 17/08/2017
@version 12.1.017
@param aArrStrut, array, Array  com a carga de dados dos clientes
/*/
Static Function ConfInteg( aArrStrut )

	Local cWSDLUrl := GetMv( 'IO_CDCFWSD' ) // URL do WSDL do WebService do CDCF
	Local cIDSist  := GetMv( 'IO_CDCFIDS' ) // ID do Sistema Protheus no CDCF
	Local cIdCons  := GetMv( 'IO_CDCFIDC' ) // ID da Consulta no CDCF
	Local oWSDL    := TWsdlManager():New()
	Local aOps     := {}
	Local aComplex := {}
	Local aSimple  := {}
	Local cMsg     := ''
	Local nX       := 0
	Local oCliente := 0
	Local aCliConf := {}

	For nX := 1 To Len( aArrStrut )

		oCliente := aArrStrut[ nX ]

		If ! oCliente:lErroAuto .And. aScan( oCliente:aContatos, { | oContato | oContato:lErroAuto } ) == 0

			aAdd( aCliConf, oCliente )

		End If

	Next nX

	For nX := 1 To Len( aCliConf )

		oCliente := aCliConf[ nX ]

		// Define que a validacao da resposta do WebService do CDCF nao sera processada
		oWsdl:lProcResp := .F.

		// Efetua o parse do WSDL do WebService
		If ! oWsdl:ParseUrl( cWSDLUrl )

			U_IOEXCPT( cUuid, cMsg := 'Erro no Parse da URL do WSDL do WebService: ' + oWsdl:cError )

			UserException( cMsg )

		End If

		// Atribui a variavel array com as operacoes do WebService
		aOps := aClone( oWsdl:ListOperations() )

		If Len( aOps ) == 0

			U_IOEXCPT( cUuid, cMsg := 'Não foi disponibilizada nenhuma operação pelo WebService através do documento WSDL: ' + oWsdl:cError )

			UserException( cMsg )

		End If

		// Seta a operacao a ser executada
		If ! oWsdl:SetOperation( aOps[ aScan( aOps, { | X | X[ 1 ] == 'ConfirmaIntegracaoCliente'} ), 1 ] )

			U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o método ConfirmaIntegracaoCliente como a operação a ser realizada: ' + oWsdl:cError )

			UserException( cMsg )

		End If

		// Atribui a variavel os tipos complexos da operacao
		//aComplex := oWsdl:NextComplex()

		//If Len( aComplex ) == 0

		//U_IOEXCPT( cUuid, cMsg := 'Nenhum Elemeto do Tipo Complexo foi Localizado: ' + oWsdl:cError )

		//UserException( cMsg )

		//End If

		// Atribui a variavel os tipos simples da operacao
		aSimple  := oWsdl:SimpleInput()

		If Len( aSimple ) == 0

			U_IOEXCPT( cUuid, cMsg := 'Nenhum Elemeto do Tipo Simples foi Localizado: ' + oWsdl:cError )

			UserException( cMsg )

		End If

		// Define o numero de ocorrencias do tipo complexo
		//		If ! oWsdl:SetComplexOccurs( aComplex[ 1 ], 1 )
		//
		//			U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o número de vezes do Tipo Complexo: ' + oWsdl:cError )
		//
		//			UserException( cMsg )
		//
		//		End IF

		// Seta o valor do tipo simples correspondente ao ID do Sistema Protheus no CDCF
		If ! oWsdl:SetValue( aSimple[1][1], cIDSist )

			U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o valor da variável ' + aSimple[1][2] + ': ' + oWsdl:cError )

			UserException( cMsg )

		End If

		// Seta o valor do tipo simples correspondente ao ID da Consulta no CDCF
		If  ! oWsdl:SetValue( aSimple[2][1], cIdCons  )

			U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o valor da variável ' + aSimple[2][2] + ': ' + oWsdl:cError )

			UserException( cMsg )

		End If


		// Seta o valor do tipo simples correspondente ao ID do cliente no CDCF
		If  ! oWsdl:SetValue( aSimple[3][1], oCliente:cXCDCDCF  )

			U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o valor da variável ' + aSimple[2][2] + ': ' + oWsdl:cError )

			UserException( cMsg )

		End If

		// Seta o valor do tipo simples correspondente ao Data Hora de alteração do cliente no CDCF
		If  ! oWsdl:SetValue( aSimple[4][1], oCliente:cXDHCDCF  )

			U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o valor da variável ' + aSimple[2][2] + ': ' + oWsdl:cError )

			UserException( cMsg )

		End If

		// Efetua comunicacao com WebService do CDCF
		If ! oWsdl:SendSoapMsg()

			U_IOEXCPT( cUuid, cMsg := 'Não foi possível o envio do documento SOAP gerado ao endereço definido: ' + oWsdl:cError )

			UserException( cMsg )

		End If

		// Atribui a Variável o retorno do WebService
		ConOut( oWsdl:GetSoapResponse() )

	Next nX

Return

/*/{Protheus.doc} EnviaErro
//Envia E-Mail com os clientes que tiveram erro na gravação
@author Elton Teodoro Alves
@since 10/08/2017
@version 12.1.017
@param aArrStrut, array, Array  com a carga de dados dos clientes
/*/
Static Function EnviaErro( aArrStrut, cUuid )

	Local nX       := 0
	Local nY       := 0
	Local oCliente := Nil
	Local oContato := Nil
	Local cMsg     := ''

	For nX := 1 To len( aArrStrut )

		oCliente := aArrStrut[ nX ]

		If oCliente:lErroAuto

			cMsg += 'Erro no cadastro do Cliente : '
			cMsg += oCliente:cCOD + ' - '
			cMsg += oCliente:cNOME + '<br/>'
			cMsg += Replace( oCliente:cErroMsg, Chr( 13 ) + Chr( 10 ), '<br/>' )

		Else

			For nY := 1 To Len( oCliente:aContatos )

				oContato := oCliente:aContatos[ nY ]

				If oContato:lErroAuto

					cMsg += 'Erro no cadastro do Contato do Cliente : '
					cMsg += oCliente:cCOD + ' - '
					cMsg += oCliente:cNOME + '<br/>'
					cMsg += oContato:cCODCONT + ' - '
					cMsg += oContato:cCONTAT + '<br/>'
					cMsg += Replace( oContato:cErroMsg, Chr( 13 ) + Chr( 10 ), '<br/>' )

				End If

			Next nX

		End If

	Next nX

	If ! Empty( cMsg )

		U_IOEXCPT( cUuid, cMsg )

	End If

Return