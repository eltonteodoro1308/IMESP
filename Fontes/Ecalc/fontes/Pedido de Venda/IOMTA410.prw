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
User Function IOMTA410( cXml, cError, cWarning, cParams, oFwEai )

	Local cRet    := 'ok'
	Local oXml    := TXmlManager():New()
	Local aCabec  := {}
	Local aItem   := {}
	Local aItens  := {}
	Local aChild  := Nil
	Local nX      := 0
	Local aErro   := Nil

	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.

	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )

		aAdd( aCabec, { 'C5_NUM'     , oXML:XPathGetNodeValue( '/MATA410_MODEL/SC5_FIELD_MASTER/C5_NUM/value'     ), Nil } )
		aAdd( aCabec, { 'C5_TIPO'    , oXML:XPathGetNodeValue( '/MATA410_MODEL/SC5_FIELD_MASTER/C5_TIPO/value'    ), Nil } )
		aAdd( aCabec, { 'C5_CLIENTE' , oXML:XPathGetNodeValue( '/MATA410_MODEL/SC5_FIELD_MASTER/C5_CLIENTE/value' ), Nil } )
		aAdd( aCabec, { 'C5_LOJACLI' , oXML:XPathGetNodeValue( '/MATA410_MODEL/SC5_FIELD_MASTER/C5_LOJACLI/value' ), Nil } )
		aAdd( aCabec, { 'C5_TIPOCLI' , oXML:XPathGetNodeValue( '/MATA410_MODEL/SC5_FIELD_MASTER/C5_TIPOCLI/value' ), Nil } )
		aAdd( aCabec, { 'C5_CONDPAG' , oXML:XPathGetNodeValue( '/MATA410_MODEL/SC5_FIELD_MASTER/C5_CONDPAG/value' ), Nil } )

		oXml:DOMChildNode()
		oXml:DOMChildNode()

		Do While AllWaysTrue()

			oXml:DOMNextNode()

			If oXml:cName == 'SC6_GRID_MASTER'

				Exit

			End If

		End Do

		oXml:DOMChildNode()
		oXml:DOMChildNode()

		Do While AllWaysTrue()

			aChild := oXML:DOMGetChildArray()

			For nX := 1 To Len( aChild  )

				If ! AllTrim( aChild[ nX, 1 ] ) $ 'C6_QTDVEN/C6_PRCVEN'

					aAdd( aItem, { aChild[ nX, 1 ], aChild[ nX, 2 ], Nil} )

				Else

					aAdd( aItem, { aChild[ nX, 1 ], Val( aChild[ nX, 2 ] ) , Nil} )

				End If

			Next nX

			aAdd( aItens, aClone( aItem ) )

			aSize( aItem, 0 )

			If ! oXml:DOMNextNode()

				Exit

			End If

		End Do

		MSExecAuto( { | X, Y, Z | MATA410( X, Y, Z ) }, aCabec, aItens, 3 )

		If lMsErroAuto

			aErro := aClone( GetAutoGRLog() )

			cRet += Chr(13) + Chr(10)

			For nX := 1 To Len( aErro )

				cRet += aErro[ nX ] + Chr(13) + Chr(10)

			Next nX

		End If

	Else

		cRet := 'Erro no Parse do XML: ' + oXml:LastError()

	End If

Return cRet