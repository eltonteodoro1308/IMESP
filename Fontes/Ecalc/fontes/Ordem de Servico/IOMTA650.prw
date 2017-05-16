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
User Function IOMTA650( cXml, cError, cWarning, cParams, oFwEai )

	Local cRet  := 'ok'
	Local oXml  := TXmlManager():New()
	Local aCpos := {}
	Local nX    := 0
	Local aErro := Nil

	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.

	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )

		aAdd( aCpos, { 'C2_NUM'     , oXML:XPathGetNodeValue( '/SC2_MODEL/SC2_FIELDS_MASTER/C2_NUM/value'     ), Nil } )
		aAdd( aCpos, { 'C2_ITEM'    , oXML:XPathGetNodeValue( '/SC2_MODEL/SC2_FIELDS_MASTER/C2_ITEM/value'    ), Nil } )
		aAdd( aCpos, { 'C2_SEQUEN'  , oXML:XPathGetNodeValue( '/SC2_MODEL/SC2_FIELDS_MASTER/C2_SEQUEN/value'  ), Nil } )
		aAdd( aCpos, { 'C2_PRODUTO' , oXML:XPathGetNodeValue( '/SC2_MODEL/SC2_FIELDS_MASTER/C2_PRODUTO/value' ), Nil } )
		aAdd( aCpos, { 'C2_LOCAL'   , oXML:XPathGetNodeValue( '/SC2_MODEL/SC2_FIELDS_MASTER/C2_LOCAL/value'   ), Nil } )
		aAdd( aCpos, { 'C2_QUANT'   , Val( oXML:XPathGetNodeValue( '/SC2_MODEL/SC2_FIELDS_MASTER/C2_QUANT/value' ) ), Nil } )
		aAdd( aCpos, { 'C2_DATPRI'  , stod( oXML:XPathGetNodeValue( '/SC2_MODEL/SC2_FIELDS_MASTER/C2_DATPRI/value'  ) ), Nil } )
		aAdd( aCpos, { 'C2_DATPRF'  , stod( oXML:XPathGetNodeValue( '/SC2_MODEL/SC2_FIELDS_MASTER/C2_DATPRF/value'  ) ), Nil } )
		aAdd( aCpos, { 'C2_EMISSAO' , stod( oXML:XPathGetNodeValue( '/SC2_MODEL/SC2_FIELDS_MASTER/C2_EMISSAO/value' ) ), Nil } )
		aAdd( aCpos, { 'C2_TPOP'    , oXML:XPathGetNodeValue( '/SC2_MODEL/SC2_FIELDS_MASTER/C2_TPOP/value'    ), Nil } )

		MSExecAuto( { | X, Y | MATA650( X, Y ) }, aCpos, 3 )

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