#Include 'TOTVS.CH'
/*/{Protheus.doc} IOAPONTA
Função acionada pelo EAI que recebe xml com dados dos apontamentos.
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
User Function IOAPONTA( cXml, cError, cWarning, cParams, oFwEai )

	Local cRet     := ''
	Local oXml     := TXmlManager():New()
	Local aCpos    := {}
	Local nX       := 0
	Local aErro    := Nil
	Local cOp      := ''
	Local cProduto := ''
	Local cRecurso := ''
	Local cDataIni := ''
	Local cHoraIni := ''
	Local cDataFin := ''
	Local cHoraFin := ''

	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.

	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )

		If oXml:DOMChildNode()

			For nX := 1 To oXml:DOMSiblingCount()

				cOp      := oXML:XPathGetNodeValue( '/MIOAPONT/SH6_FIELD[' + cValToChar(nX) + ']/H6_OP/value'      )
				cProduto := oXML:XPathGetNodeValue( '/MIOAPONT/SH6_FIELD[' + cValToChar(nX) + ']/H6_PRODUTO/value' )
				cRecurso := oXML:XPathGetNodeValue( '/MIOAPONT/SH6_FIELD[' + cValToChar(nX) + ']/H6_RECURSO/value' )
				cDataIni := oXML:XPathGetNodeValue( '/MIOAPONT/SH6_FIELD[' + cValToChar(nX) + ']/H6_DATAINI/value' )
				cHoraIni := oXML:XPathGetNodeValue( '/MIOAPONT/SH6_FIELD[' + cValToChar(nX) + ']/H6_HORAINI/value' )
				cDataFin := oXML:XPathGetNodeValue( '/MIOAPONT/SH6_FIELD[' + cValToChar(nX) + ']/H6_DATAFIN/value' )
				cHoraFin := oXML:XPathGetNodeValue( '/MIOAPONT/SH6_FIELD[' + cValToChar(nX) + ']/H6_HORAFIN/value' )

				aAdd( aCpos, { cOp, cProduto, cRecurso, cDataIni, cHoraIni, cDataFin, cHoraFin } )

			Next nX

		End If

		For nX := 1 To Len( aCpos )

			If Empty( aCpos[ nX, 1 ] )

			Else

				{ 'D3_TM'      , '' }
				{ 'D3_COD'     , '' }
				{ 'D3_QUANT'   , CalcHoras( cDataIni, cHoraIni, cDataFin, cHoraFin ), Nil }
				{ 'D3_OP'      , cOp                                                , Nil }
				{ 'D3_EMISSAO' , StoD( cDataFin )                                   , Nil }

				MsExecAuto( { | X, Y | MATA682( X, Y ) },;
				{};
				, 3 )

			End If

		Next nX

		/*

		MSExecAuto( { | X, Y | MATA380( X, Y ) }, aCpos, 3 )

		If lMsErroAuto

		aErro := aClone( GetAutoGRLog() )

		cRet += Chr(13) + Chr(10)

		For nX := 1 To Len( aErro )

		cRet += aErro[ nX ] + Chr(13) + Chr(10)

		Next nX

		End If
		*/

	Else

		cRet := 'Erro no Parse do XML: ' + oXml:LastError()

	End If

Return cRet

Static Function CalcHoras( cDataIni, cHoraIni, cDataFin, cHoraFin )

	Local nRet := 0

	nRet := Val( FwTimeStamp( 4, StoD( cDataFin ) , cHoraFin + ':00') )
	nRet := nRet - Val( FwTimeStamp( 4, StoD( cDataIni ) , cHoraIni + ':00' ) )
	nRet := nRet / ( 60 * 60 )
	nRet := Round( nRet, 2 )

Return nRet