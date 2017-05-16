#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOMTA380
Função acionada pelo EAI que recebe xml com dados do empenho da OP
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
User Function IOMTA380( cXml, cError, cWarning, cParams, oFwEai )

	Local cRet  := 'ok'
	Local oXml  := TXmlManager():New()
	Local aCpos := {}
	Local nX    := 0
	Local aErro := Nil
	//Default cXml := MemoRead( '\XML\IOMTA380.XML' )
	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.

	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )

		aAdd( aCpos, { 'D4_COD'     , oXML:XPathGetNodeValue( '/SD4_MODEL/SD4_FIELDS_MASTER/D4_COD/value'          )   , Nil } )
		aAdd( aCpos, { 'D4_LOCAL'   , oXML:XPathGetNodeValue( '/SD4_MODEL/SD4_FIELDS_MASTER/D4_LOCAL/value'        )   , Nil } )
		aAdd( aCpos, { 'D4_OP'      , oXML:XPathGetNodeValue( '/SD4_MODEL/SD4_FIELDS_MASTER/D4_OP/value'           )   , Nil } )
		aAdd( aCpos, { 'D4_QTDEORI' , Val( oXML:XPathGetNodeValue( '/SD4_MODEL/SD4_FIELDS_MASTER/D4_QTDEORI/value' ) ) , Nil } )
		aAdd( aCpos, { 'D4_QUANT'   , Val( oXML:XPathGetNodeValue( '/SD4_MODEL/SD4_FIELDS_MASTER/D4_QUANT/value'   ) ) , Nil } )


		//RpcSetEnv( '99', '01' )

		MSExecAuto( { | X, Y | MATA380( X, Y ) }, aCpos, 3 )

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

	//RpcClearEnv()
	ConOut( cRet )
Return cRet