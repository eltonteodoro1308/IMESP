#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOMATA02
//User Function para ser definida no schedule com padrão de recorrência de sempre ativo, faz a busca no Web service do CDCF
dos clientes que precisa ser incluídos ou atualizados.
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
@param aParam, array, Array com parâmetros de execução definidos no schedule
/*/
User Function IOMATA02( aParam )

	Local cTimeStamp := FWTimeStamp( 4 )
	Local cLastTime  := GetGlbValue( 'IOMATA02' )
	Local nTime      := Val( cTimeStamp ) - Val( cLastTime )
	Local oEai       := Nil
	Local cXml       := ''
	Local oXml       := TXmlManager():New()
	Local cUuid      := ''

	Default aParam := {'99','01'}

	cXml := GerXml( aParam )

	oXml:Parse( cXml )

	cUuid := oXml:XPathGetNodeValue( '/TOTVSIntegrator/DocIdentifier' )

	If nTime >= Val( GetParam( Space( Len( aParam[2] ) ) + 'IO_TMPWAIT', aParam[1] ) )

		oEai := WsEaiService():New()

		oEai:_URL := AllTrim( GetParam( Space( Len( aParam[2] ) ) + 'IO_EAIURL', aParam[1] ) )

		If ! oEai:ReceiveMessage( '<![CDATA[' + cXml + ']]>' )

			U_IOEXCPT( cUUID, GetWSCError(), aParam[1] )

		Else

			ConOut( oEai:cReceiveMessageResult )

		EndIf

		FreeObj( oEai )

		PutGlbValue ( 'IOMATA02', FWTimeStamp( 4 ) )

	Else

		ConOut( 'Não Executado as ' + Time() )

	End If

Return

/*/{Protheus.doc} GetParam
//Efetua a busca do valor de um parâmetro sem que haja algum environment ativo
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
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
@since 04/08/2017
@version 12.1.017
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