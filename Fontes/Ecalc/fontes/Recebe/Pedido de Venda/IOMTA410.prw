#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOMTA410
Função acionada pelo EAI que recebe xml com dados do pedido venda e faz sua inclusão
@author Elton Teodoro Alves
@since 04/05/2016
@version Protheus 12.1.014
@param cXml    , Caracter, O conteúdo da tag Content do XML recebido pelo EAI Protheus.
@param cError  , Caracter, Variável passada por referência, serve para alimentar a mensagem de erro, nos casos em que a transação não foi bem sucedida.
@param cWarning, Caracter, Variável passada por referência, serve para alimentar uma mensagem de warning para o EAI. A alteração deste valor por rotinas tratadas neste tópico não causam nenhum efeito para o EAI.
@param cParams , Caracter, Parâmetros passados na mensagem do EAI.
@param oFwEai  , Object  , O objeto de EAI criado na camada do EAI Protheus. A manipulação deste objeto deve ser realizada com o máximo de cautela, e deve ser evitada ao máximo.
@return cRet   , Xml de retorno com a Imagem solicitado em formato Base64 ou erro de processamento
/*/

/*TODO
- Tratar a situação em que o pedido será inativa e deve-se impedir o seu faturamento.
- Verificar o ponto de entrada M460MARK
- Também campo C5_MSBLQL
*/
User Function IOMTA410( cXml, cError, cWarning, cParams, oFwEai )

	Local cMsg     := ''
	Local oXml     := TXmlManager():New()
	Local aCabec   := {}
	Local aItem    := {}
	Local aItens   := {}
	Local aChild   := Nil
	Local nX       := 0
	Local cSucesso := 'T'
	Local nItem    := 1
	Local cName    := ''
	Local cVendaId := ''
	Local aArea    := GetArea()
	Local lExiste  := .F.
	Local nOper    := 0

	Private	lMsErroAuto    := .F.
	Private	lMsHelpAuto    := .T.
	Private	lAutoErrNoFile := .T.

	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML ) .And.;
	oXml:ParseSchemaFile('\schemas\IOMTA410_REM.xsd') .And.;
	oXml:SchemaValidate()

		nOper := Val( oXml:XPathGetAtt( '/MIOMT410_REM', 'Operation' ) )

		cVendaId  := oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_XVENDID/value' )

		DbSelectArea( 'SC5' )
		DBOrderNickname( 'XVENDID' )

		If DbSeek( xFilial( 'SC5' ) + cVendaId )

			aAdd( aCabec, { 'C5_NUM', SC5->C5_NUM, Nil } )

			lExiste := .T.

		End If

		RestArea( aArea )

		aAdd( aCabec, { 'C5_TIPO'    , 'N'                                                                         , Nil } )
		aAdd( aCabec, { 'C5_CLIENTE' , oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_CLIENTE/value'      )   , Nil } )
		aAdd( aCabec, { 'C5_CONDPAG' , oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_CONDPAG/value'      )   , Nil } )
		aAdd( aCabec, { 'C5_TRANSP'  , oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_TRANSP/value'       )   , Nil } )
		aAdd( aCabec, { 'C5_XSISTEM' , oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_XSISTEM/value'  )       , Nil } )
		aAdd( aCabec, { 'C5_XVENDID' , cVendaId                                                                    , Nil } )
		aAdd( aCabec, { 'C5_XIDCPGT' , oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_XIDCPGT/value'  )       , Nil } )
		aAdd( aCabec, { 'C5_MENNOTA' , oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_MENNOTA/value'  )       , Nil } )
		aAdd( aCabec, { 'C5_TPFRETE' , oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_TPFRETE/value'  )       , Nil } )
		aAdd( aCabec, { 'C5_FRETE'   , Val( oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_FRETE/value' ) )   , Nil } )
		aAdd( aCabec, { 'C5_PESOL'   , Val( oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_PESOL/value'   ) ) , Nil } )
		aAdd( aCabec, { 'C5_PBRUTO'  , Val( oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_PBRUTO/value'  ) ) , Nil } )
		aAdd( aCabec, { 'C5_VOLUME1' , Val( oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_VOLUME1/value' ) ) , Nil } )
		aAdd( aCabec, { 'C5_ESPECI1' , oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_ESPECI1/value'      )   , Nil } )
		aAdd( aCabec, { 'C5_XOBSNF'  , StrTran( oXML:XPathGetNodeValue( '/MIOMT410_REM/SC5_FIELD/C5_XOBSNF/value' ), '/n', Chr(13)+ Chr(10) ), Nil } )

		oXml:DOMChildNode()
		oXml:DOMChildNode()

		Do While AllWaysTrue()

			oXml:DOMNextNode()

			If oXml:cName == 'SC6_GRID'

				Exit

			End If

		End Do

		oXml:DOMChildNode()
		oXml:DOMChildNode()

		Do While AllWaysTrue()

			oXml:DOMChildNode()

			aAdd( aItem, { 'C6_ITEM', StrZero( nItem, TamSx3( 'C6_ITEM' )[ 1 ] ), Nil} )

			For nX := 1 To oXml:DOMSiblingCount()

				cName := oXml:cName

				oXml:DOMChildNode()

				If ! AllTrim( cName ) $ 'C6_QTDVEN/C6_PRCVEN/C6_VALDESC/C5_FRETE'

					aAdd( aItem, { cName, oXml:cText, Nil} )

				Else

					aAdd( aItem, { cName, Val( oXml:cText ) , Nil} )

					If AllTrim( cName ) == 'C6_QTDVEN'

						aAdd( aItem, { 'C6_QTDLIB', Val( oXml:cText ) , Nil} )

					End If

				End If

				oXml:DOMParentNode()

				oXml:DOMNextNode()

			Next nX

			aAdd( aItens, aClone( aItem ) )

			aSize( aItem, 0 )

			oXml:DOMParentNode()

			If ! oXml:DOMNextNode()

				Exit

			End If

			nItem++

		End Do

		If lExiste .And. nOper == 3

			nOper := 4

		End If

		MSExecAuto( { | X, Y, Z | MATA410( X, Y, Z ) }, aCabec, aItens, nOper )

		MsErroAuto( @cSucesso, @cMsg )

	Else

		cSucesso := 'F'
		cMsg := 'Erro no Parse do XML: ' + oXml:LastError()

	End If

Return Retorno( cSucesso, cMsg, oFwEai )

Static Function Retorno( cSucesso, cMsg, oFwEai )

	Local cRet := ''

	cRet += '<MIOMT410_RET>'
	cRet += '<SC5_FIELD>'
	cRet += '<SUCESSO>'
	cRet += '<value>' + cSucesso + '</value>'
	cRet += '</SUCESSO>'
	cRet += '<MENSAGEM>'
	cRet += '<value>' + cMsg + '</value>'
	cRet += '</MENSAGEM>'
	cRet += '</SC5_FIELD>'
	cRet += '</MIOMT410_RET>'

	oFwEai:cReturnMsg := cRet

Return cRet

Static Function MsErroAuto( cSucesso, cMsg )

	Local nX    := 0
	Local aErro := {}

	If lMsErroAuto

		cSucesso := 'F'

		aErro := aClone( GetAutoGRLog() )

		cMsg += Chr(13) + Chr(10)

		For nX := 1 To Len( aErro )

			cMsg += _NoTags( aErro[ nX ] ) + Chr(13) + Chr(10)

		Next nX

	End If

Return
