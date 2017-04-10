#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOMATA02
//Fun��o a ser utilizada no Schedule que busca no Web Service do CDCF pelo m�todo SolicitaClientesParaIntegrar os clinetes a serem incluidos/atualizados.
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
	//TODO Excluir este inicializador no deploy do programa.
	//Default aParam := {'99','01'}
	If nTime >= Val( GetParam( Space( Len( aParam[2] ) ) + 'IO_TMPWAIT', aParam[1] ) )

		oEai := WsEaiService():New()

		oEai:_URL := AllTrim( GetParam( Space( Len( aParam[2] ) ) + 'IO_EAIWSDL', aParam[1] ) )

		If oEai:ReceiveMessage( FXml( aParam ) )

			ConOut( oEai:cReceiveMessageResult )

		Else

			UserException( GetWSCError() )

		EndIf

		FreeObj( oEai )

		PutGlbValue ( 'IOMATA02', FWTimeStamp( 4 ) )

	End If

Return

/*/{Protheus.doc} GetParam
//Efetua a busca do valor de um par�metro sem que haja algum environment ativo
@author Elton Teodoro Alves
@since 10/04/2017
@version 12.1.014
@param cSeek, characters, String de busca do par�metro pela fun��o DbSeek
@param cEmp, characters, C�digo da Empresa da busca
@return return, Valor do Par�metro
/*/
Static Function GetParam( cSeek, cEmp )

	Local cRet := ''

	dbUseArea( .T. , 'CTREECDX',;
	GetSrvProfString( 'STARTPATH', '\SYSTEM' ) + 'SX6' + cEmp + '0' + GetDbExtension(),;
	'SX6TMP', .T., .T.)

	SX6TMP->( DbSetOrder( 1 ) )

	SX6TMP->( DbSeek( cSeek ) )

	cRet := SX6TMP->X6_CONTEUD

	SX6TMP->( DbCloseArea() )

Return cRet

/*/{Protheus.doc} FXml
//Monta o XML do documento EAI de requisi��o de integra��o com o CDCF
@author Elton Teodoro Alves
@since 10/04/2017
@version 12.1.014
@param aParam, array, Array enviado pelo schedule com dados do processamento
@return return, XML do documento de requisi��o do EAI.
/*/
Static Function FXml( aParam )

	Local cRet  := ''
	Local cUUID := FWUUIDV4( .T. )

	cRet += '<![CDATA['
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
	cRet += '<DocName />'
	cRet += '<DocFederalID />'
	cRet += '<DocType>1</DocType>'
	cRet += '<Message>'
	cRet += '<Layouts>'
	cRet += '<Version>1.000</Version>'
	cRet += '<Identifier>' + cUUID + '</Identifier>'
	cRet += '<FunctionCode>U_IOCDCF</FunctionCode>'
	cRet += '<Content>'
	cRet += '</Content>'
	cRet += '</Layouts>'
	cRet += '</Message>'
	cRet += '</TOTVSIntegrator>'
	cRet += ']]>'

Return cRet

/*/{Protheus.doc} IOCDCF
User Function chamada via EAI para registrar na fila as requisi��es de importa��o do cadastro de clientes incluir e alterados do CDCF.
@author Elton Teodoro Alves
@since 27/01/2017
@version 12.1.014
@param cXml, characters, O conte�do da tag Content do XML recebido pelo EAI Protheus.
@param cError, characters, Vari�vel passada por refer�ncia, serve para alimentar a mensagem de erro, nos casos em que a transa��o n�o foi bem sucedida.
@param cWarning, characters, Vari�vel passada por refer�ncia, serve para alimentar uma mensagem de warning para o EAI.
@param cParams, characters,  Par�metros passados na mensagem do EAI.
@param oFwEai, object, O objeto de EAI criado na camada do EAI Protheus.
@return characters, Retorno com resultado da opera��o.
/*/
User Function IOCDCF( cXml, cError, cWarning, cParams, oFwEai )

	Local cXmlCDCF   := ''
	Local cErrorCDCF := ''
	Local cRet       := ''

	GetXmlCDCF( @cXmlCDCF, @cErrorCDCF )

	If ! Empty( cErrorCDCF )

		UserException( cErrorCDCF )

	End If

	oFwEai:cReturnMsg := cXmlCDCF

Return cRet

/*/{Protheus.doc} GetXmlCDCF
Conecta com o WebService do CDCF no m�todo SolicitaClinetesParaIntegrar e recebe o XML a ser integrado com o Protheus
@author Elton Teodoro Alves
@since 10/04/2017
@version 12.1.014
@param cXml, characters, Vari�vel passada por refer�cia que recebe o XML retornado pelo CDCF
@param cErro, characters, Vari�vel passada por refer�ncia que recebe o erro ocorrido na integra��o com o CDCF
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

		cErro := 'N�o foi disponibilizada nenhuma opera��o pelo WebService atrav�s do documento WSDL: ' + oWsdl:cError

		Return

	End If

	// Seta a operacao a ser executada
	If ! oWsdl:SetOperation( aOps[ aScan( aOps, { | X | X[ 1 ] == 'SolicitaClientesParaIntegrar'} ), 1 ] )

		cErro := 'N�o foi poss�vel definir o m�todo SolicitaClientesParaIntegrar como a opera��o a ser realizada: ' + oWsdl:cError

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

		cErro := 'N�o foi poss�vel definir o n�mero de vezes do Tipo Complexo: ' + oWsdl:cError

		Return

	End IF

	// Seta o valor do tipo simples correspondente ao ID do Sistema Protheus no CDCF
	If ! oWsdl:SetValue( aSimple[1][1], cIDSist )

		cErro := 'N�o foi poss�vel definir o valor da vari�vel ' + aSimple[1][2] + ': ' + oWsdl:cError

		Return

	End If

	// Seta o valor do tipo simples correspondente ao ID da Consulta no CDCF
	If  ! oWsdl:SetValue( aSimple[2][1], cIdCons  )

		cErro := 'N�o foi poss�vel definir o valor da vari�vel ' + aSimple[2][2] + ': ' + oWsdl:cError

		Return

	End If

	// Efetua comunicacao com WebService do CDCF
	If ! oWsdl:SendSoapMsg()

		cErro := 'N�o foi poss�vel o envio do documento SOAP gerado ao endere�o definido: ' + oWsdl:cError

		Return

	End If

	// Atribui a Vari�vel o retorno do WebService
	cXml := oWsdl:GetSoapResponse()

Return