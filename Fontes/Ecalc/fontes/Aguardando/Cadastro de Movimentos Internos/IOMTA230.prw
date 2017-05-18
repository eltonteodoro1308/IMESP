#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOMTA410
Fun��o acionada pelo EAI que recebe xml com dados do pedido venda e faz sua inclus�o
@author Elton Teodoro Alves
@since 04/05/2016
@version Protheus 12.1.014
@param cXml    , Caracter, O conte�do da tag Content do XML recebido pelo EAI Protheus.
@param cError  , Caracter, Vari�vel passada por refer�ncia, serve para alimentar a mensagem de erro, nos casos em que a transa��o n�o foi bem sucedida.
@param cWarning, Caracter, Vari�vel passada por refer�ncia, serve para alimentar uma mensagem de warning para o EAI. A altera��o deste valor por rotinas tratadas neste t�pico n�o causam nenhum efeito para o EAI.
@param cParams , Caracter, Par�metros passados na mensagem do EAI.
@param oFwEai  , Object  , O objeto de EAI criado na camada do EAI Protheus. A manipula��o deste objeto deve ser realizada com o m�ximo de cautela, e deve ser evitada ao m�ximo.
@return cRet   , Xml de retorno com a Imagem solicitado em formato Base64 ou erro de processamento
/*/
User Function IOMTA230( cXml, cError, cWarning, cParams, oFwEai )

	Local cRet  := 'ok'
	Local oXml  := TXmlManager():New()
	Local aCpos := {}
	Local nX    := 0
	Local aErro := Nil

	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.

	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )

		aAdd( aCpos, { 'F5_CODIGO'  , oXML:XPathGetNodeValue( '/SF5_MODEL/SF5_FIELD_MASTER/F5_CODIGO/value'  ), Nil } )
		aAdd( aCpos, { 'F5_TIPO'    , oXML:XPathGetNodeValue( '/SF5_MODEL/SF5_FIELD_MASTER/F5_TIPO/value'    ), Nil } )
		aAdd( aCpos, { 'F5_TEXTO'   , oXML:XPathGetNodeValue( '/SF5_MODEL/SF5_FIELD_MASTER/F5_TEXTO/value'   ), Nil } )
		aAdd( aCpos, { 'F5_APROPR'  , oXML:XPathGetNodeValue( '/SF5_MODEL/SF5_FIELD_MASTER/F5_APROPR/value'  ), Nil } )
		aAdd( aCpos, { 'F5_ATUEMP'  , oXML:XPathGetNodeValue( '/SF5_MODEL/SF5_FIELD_MASTER/F5_ATUEMP/value'  ), Nil } )
		aAdd( aCpos, { 'F5_TRANMOD' , oXML:XPathGetNodeValue( '/SF5_MODEL/SF5_FIELD_MASTER/F5_TRANMOD/value' ), Nil } )
		aAdd( aCpos, { 'F5_VAL'     , oXML:XPathGetNodeValue( '/SF5_MODEL/SF5_FIELD_MASTER/F5_VAL/value'     ), Nil } )
		aAdd( aCpos, { 'F5_QTDZERO' , oXML:XPathGetNodeValue( '/SF5_MODEL/SF5_FIELD_MASTER/F5_QTDZERO/value' ), Nil } )

		MSExecAuto( { | X, Y, Z | MATA230( X, Y ) }, aCpos, 3 )

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