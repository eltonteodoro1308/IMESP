#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOMTA410
Função acionada pelo EAI que recebe xml com dados do pedido venda e faz sua inclusão
@author Elton Teodoro Alves
@since 11/07/2017
@version Protheus 12.1.016
@param cXml    , Caracter, O conteúdo da tag Content do XML recebido pelo EAI Protheus.
@param cError  , Caracter, Variável passada por referência, serve para alimentar a mensagem de erro, nos casos em que a transação não foi bem sucedida.
@param cWarning, Caracter, Variável passada por referência, serve para alimentar uma mensagem de warning para o EAI. A alteração deste valor por rotinas tratadas neste tópico não causam nenhum efeito para o EAI.
@param cParams , Caracter, Parâmetros passados na mensagem do EAI.
@param oFwEai  , Object  , O objeto de EAI criado na camada do EAI Protheus. A manipulação deste objeto deve ser realizada com o máximo de cautela, e deve ser evitada ao máximo.
@return cRet   , Xml de retorno status da operação
/*/
User Function IOMTA410( cXml, cError, cWarning, cParams, oFwEai )

	Local cMsg     := ''
	Local oXml     := TXmlManager():New()
	Local aCabec   := {}
	Local aItem    := {}
	Local aItens   := {}
	Local nX       := 0
	Local cSucesso := 'T'
	Local nItem    := 1
	Local cName    := ''
	Local xCache   := ''
	Local cTipo    := ''
	Local cSistem  := ''
	Local cVendaId := ''
	Local cMsBlQl  := ''
	Local aArea    := GetArea()
	Local lExiste  := .F.
	Local nOper    := 0

	Private	lMsErroAuto    := .F.
	Private	lMsHelpAuto    := .T.
	Private	lAutoErrNoFile := .T.

	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML ) .And.;
	oXml:ParseSchemaFile('\schemas\IOMTA410_REM.xsd') .And.;
	oXml:SchemaValidate()

		nOper     := Val( oXml:XPathGetAtt( '/MIOMT410_REM', 'Operation' ) )

		aAdd( aCabec, { 'C5_TIPO', 'N', Nil } )

		oXml:DOMChildNode()
		oXml:DOMChildNode()

		Do While AllWaysTrue()

			cName := oXml:cName

			If ! AllTrim( cName ) == 'SC6_GRID'

				oXml:DOMChildNode()

				cTipo := GetSx3Cache( cName, 'X3_TIPO' )

				If cTipo == 'N'

					xCache := Val( oXml:cText )

				ElseIf cTipo == 'M'

					xCache := StrTran( oXml:cText, '/n', Chr(13) + Chr(10) )

				Else

					xCache := oXml:cText

				EndIf

				aAdd( aCabec, { cName, xCache, Nil } )

				If AllTrim( cName ) == 'C5_MSBLQL'

					cMsBlQl := oXml:cText

				EndIf

				If AllTrim( cName ) == 'C5_XSISTEM'

					cSistem := oXml:cText

				EndIf

				If AllTrim( cName ) == 'C5_XVENDID'

					cVendaId  := oXml:cText

				EndIf

				If ! Empty( cSistem ) .And. ! Empty( cVendaId ) .And. aScan( aCabec, { |X| X[1] == 'C5_NUM'} ) == 0

					DbSelectArea( 'SC5' )
					DBOrderNickname( 'XVENDID' )

					cSistem  := PadR( cSistem , GetSx3Cache( 'C5_XSISTEM', 'X3_TAMANHO' ) )
					cVendaId := PadR( cVendaId, GetSx3Cache( 'C5_XVENDID', 'X3_TAMANHO' ) )

					If DbSeek( xFilial( 'SC5' ) + cVendaId  + cSistem )

						aAdd( aCabec, { 'C5_NUM', SC5->C5_NUM, Nil } )

						lExiste := .T.

					End If

					RestArea( aArea )

				EndIf

				oXml:DOMParentNode()

			Else

				Exit

			End If

			oXml:DOMNextNode()

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

						If cMsBlQl == '1'

							aAdd( aItem, { 'C6_QTDLIB', 0 , Nil} )

						Else

							aAdd( aItem, { 'C6_QTDLIB', Val( oXml:cText ) , Nil} )

						EndIf

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
/*/{Protheus.doc} Retorno
//Monta o XML de retorno da Transação
@author Elton Teodoro Alves
@since 11/07/2017
@version Protheus 12.1.016
@param cSucesso, characters, Indica se a transação foi bem sucedida 'T' ou não 'F'
@param cMsg, characters, Mensagem a ser exibida
@param oFwEai, object, Objeto da transação EAI
/*/
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
/*/{Protheus.doc} MsErroAuto
//Em caso de erro com o ExecAuto, monta mensagem de erro para o xml de retorno
@author Elton Teodoro Alves
@since 11/07/2017
@version Protheus 12.1.016
@param cSucesso, characters, Indica se a transação foi bem sucedida 'T' ou não 'F'
@param cMsg, characters, Mensagem a ser exibida
/*/
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
