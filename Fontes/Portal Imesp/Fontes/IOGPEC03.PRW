#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} SGPEC003
Função acionada pelo EAI que retorna a lista de afastamentos do funcionário conforme código e período requisitado	.
@author Elton Teodoro Alves
@since 13/03/2016
@version 12.1.014
@param cXml  , Caracter, O conteúdo da tag Content do XML recebido pelo EAI Protheus.
@param cError  , Caracter, Variável passada por referência, serve para alimentar a mensagem de erro, nos casos em que a transação não foi bem sucedida.
@param cWarning, Caracter, Variável passada por referência, serve para alimentar uma mensagem de warning para o EAI. A alteração deste valor por rotinas tratadas neste tópico não causam nenhum efeito para o EAI.
@param cParams , Caracter, Parâmetros passados na mensagem do EAI.
@param oFwEai  , Object  , O objeto de EAI criado na camada do EAI Protheus. A manipulação deste objeto deve ser realizada com o máximo de cautela, e deve ser evitada ao máximo.
@return cRet   , Xml de retorno
/*/
User Function IOGPEC03( cXml, cError, cWarning, cParams, oFwEai )

	Local cRet     := '<IOGPEC03_RET>'
	Local cErro    := ''
	Local oXml     := TXmlManager():New()
	Local aAlias   := GetNextAlias()
	Local cQuery   := ''
	Local cMat     := ''
	Local cDataIni := ''
	Local cDataFim := ''
	Local nX       := 0
	Local nCount   := 0

	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML ) .And.;
	oXml:ParseSchemaFile('\schemas\IOGPEC03_REM.xsd') .And.;
	oXml:SchemaValidate()

		cMat     := AllTrim( oXml:XPathGetNodeValue( '/IOGPEC03_REM/RA_MAT' ) )
		cDataIni := AllTrim( oXml:XPathGetNodeValue( '/IOGPEC03_REM/R8_DATAINI' ) )
		cDataFim := AllTrim( oXml:XPathGetNodeValue( '/IOGPEC03_REM/R8_DATAFIM' ) )

		cDataFim := If( Empty( cDataFim ), DtoS( Date() ), cDataFim )

		cQuery += "SELECT SRA.RA_MAT, SRA.RA_NOMECMP, SR8.R8_TIPOAFA, RCM.RCM_DESCRI, SR8.R8_DATAINI, SR8.R8_DATAFIM "
		cQuery += "FROM " + RetSqlName( "SRA" ) + " SRA "
		cQuery += "LEFT JOIN " + RetSqlName( "SR8" ) + " SR8 ON SRA.RA_MAT = SR8.R8_MAT AND SRA.RA_FILIAL = SR8.R8_FILIAL "
		cQuery += "LEFT JOIN " + RetSqlName( "RCM" ) + " RCM ON SR8.R8_TIPOAFA = RCM.RCM_TIPO "
		cQuery += "WHERE SRA.D_E_L_E_T_= ' ' "
		cQuery += "AND SR8.D_E_L_E_T_= ' ' "
		cQuery += "AND RCM.D_E_L_E_T_= ' ' "
		//cQuery += "AND SRA.RA_FILIAL = '" + oFwEai:cDocBranch + "' "
		cQuery += "AND SRA.RA_MAT = '" + cMat + "' "
		cQuery += "AND ( SR8.R8_DATAINI >= '" + cDataIni + "' "
		cQuery += "OR SR8.R8_DATAFIM >= '" + cDataIni + "' ) "
		cQuery += "AND ( SR8.R8_DATAINI <= '" + cDataFim + "' "
		cQuery += "OR SR8.R8_DATAFIM < '" + cDataFim + "' ) "
		cQuery += "ORDER BY SR8.R8_DATAINI"

		If TcSqlExec( cQuery ) < 0

			cErro := TcSqlError()

		Else

			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , aAlias, .F., .T. )

			( aAlias )->( DbEval( { || ++nCount } ) )

			If nCount > 0

				( aAlias )->( DbGotop() )

				cRet += '<RA_MAT value="' + AllTrim( ( aAlias )->RA_MAT ) + '">'
				cRet += '<RA_NOMECMP>' + AllTrim( ( aAlias )->RA_NOMECMP ) + '</RA_NOMECMP>'

				Do While ! ( aAlias )->( Eof() )

					cRet += '<R8_TIPO order="' + cValToChar( ++nX ) + '" value="' + AllTrim( ( aAlias )->R8_TIPOAFA ) + '">'
					cRet += '<RCM_DESCRI>' + AllTrim( ( aAlias )->RCM_DESCRI ) + '</RCM_DESCRI>'
					cRet += '<R8_DATAINI>' + AllTrim( ( aAlias )->R8_DATAINI ) + '</R8_DATAINI>'
					cRet += '<R8_DATAFIM>' + AllTrim( ( aAlias )->R8_DATAFIM ) + '</R8_DATAFIM>'
					cRet += '</R8_TIPO>'

					( aAlias )->( DbSkip() )

				End Do

				cRet += '</RA_MAT>'
				cRet += '<ERROR></ERROR>'

			Else

				cErro := 'Não há registros para este funcionário.'

			EndIf

		End If

	Else

		cErro := 'Erro no Parse ou Schema Validate do XML enviado: ' + oXml:LastError()

	End If

	If ! Empty( cErro )

		cRet += '<RA_MAT value="0"></RA_MAT>'
		cRet += '<ERROR>' + cErro + '</ERROR>'

	EndIf

	cRet += '</IOGPEC03_RET>'

Return cRet
