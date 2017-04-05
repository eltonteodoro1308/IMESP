#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOGPEC05
User Function que através de XML recebido conforme schema faz busca de departamentos no organograma
e retorna outro xml com resultado da consulta.
@author Elton Teodoro Alves
@since 07/03/2016
@version Protheus 12.1.7
@param cXml, characters, XML enviado com dados da consulta
@return characters, Xml de retorno da Pesquisa
/*/
User Function IOGPEC05( cXml )

	Local cRet       := ''
	Local cPesq      := ''
	Local cErro      := ''
	Local oXml       := TXmlManager():New()
	Local aArea      := GetArea()
	Local cTmp       := GetNextAlias()
	Local cQuery     := ''
	Local aWhere     := {}
	Local cWhere     := ''
	Local cOrder     := ''
	Local nNumRegPag := 0
	Local nPagina    := 0
	Local aAttNode   := {}
	Local aChildNode := {}
	Local nPos       := 0
	Local cField     := ''
	Local cValue     := ''
	Local cRelation  := ''
	Local cOperator  := ''
	Local cFunction  := ''
	Local cTemp      := ''
	Local nX         := 0

	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML ) .And.;
	oXml:ParseSchemaFile('\schemas\IOGPEC05_REM.xsd') .And.;
	oXml:SchemaValidate()

		oXml:DOMChildNode()

		Do While AllWaysTrue()

			aAttNode   := oXML:DOMGetAttArray()
			aChildNode := oXML:DOMGetChildArray()

			If ! oXml:cName $ 'SORT/PAGINATION'

				nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'field' } )
				cField    := aAttNode[ nPos, 2 ]

				cValue    := Upper( aChildNode[ 1, 2 ] )

				nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'relation' } )
				cRelation := If( nPos == 0, 'EQUAL', aAttNode[ nPos, 2 ] )

				nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'operator' } )
				cOperator := If( nPos == 0, 'AND', aAttNode[ nPos, 2 ] )

				nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'function' } )
				cFunction := If( nPos == 0, '', aAttNode[ nPos, 2 ] )

				aAdd( aWhere, { cField, cValue, cRelation, cOperator, cFunction } )

			ElseIf oXml:cName == 'SORT'

				oXml:DOMChildNode()

				Do While AllWaysTrue()

					If oXml:cName == "ASC"

						cOrder += oXml:cText + " ASC"

					ElseIf oXml:cName == "DESC"

						cOrder += oXml:cText + " DESC"

					EndIf

					If ! oXml:DOMNextNode()

						Exit

					Else

						cOrder += ","

					EndIf

				EndDO

				oXml:DOMParentNode()

			ElseIf oXml:cName == 'PAGINATION'

				nPos       := aScan( aAttNode, { | X | X[ 1 ] == 'number_of_records' } )
				nNumRegPag := Val( aAttNode[ nPos, 2 ] )

				nPos       := aScan( aAttNode, { | X | X[ 1 ] == 'page' } )
				nPagina    := Val( aAttNode[ nPos, 2 ] )

			EndIf

			If ! oXml:DOMNextNode()

				Exit

			EndIf

		EndDO

		For nX:= 1 To Len( aWhere )

			cTemp := MakeWhere( aWhere[nX,1], aWhere[nX,2], aWhere[nX,3], aWhere[nX,4], aWhere[nX,5], nX == 1 , nX == Len( aWhere ) )

			If SubStr( cTemp, 1, Len("Permitido") ) = "Permitido"

				cPesq := '<IOGPEC05_RD4></IOGPEC05_RD4>'
				Return '<IOGPEC05_RET>' + cPesq + '<ERROR>' + cTemp + '</ERROR></IOGPEC05_RET>'

			Else

				cWhere += cTemp

			EndIf

		Next nX

		MakeQuery( @cQuery, cWhere, cOrder, nNumRegPag, nPagina )

		If TcSqlExec( cQuery ) < 0

			cPesq := '<IOGPEC05_RD4></IOGPEC05_RD4>'
			cErro := TcSqlError()

		Else

			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

			(cTmp)->( DbGoTop() )

			Do While ! (cTmp)->( Eof() )

				If ! AllTrim( (cTmp)->RD4_CODIDE ) == 'COUNT'

					cPesq += '<IOGPEC05_RD4>'

					For nX := 1 To ( cTmp )->( FCount() )

						cField := AllTrim( ( cTmp )->( FieldName( nX ) ) )

						If cField # 'ROW_NUMBER'

							cPesq += '<' + cField + '>'
							cPesq += AllTrim( ( cTmp )->( FieldGet( nX ) ) )
							cPesq += '</' + cField + '>'

						EndIf

					Next nX

					cPesq += '</IOGPEC05_RD4>'

				Else

					cPesq += '<TOTAL_SEARCH_RECORDS>' + AllTrim( cValToChar( (cTmp)->ROW_NUMBER ) ) + '</TOTAL_SEARCH_RECORDS>'

				EndIf

				( cTmp )->( DbSkip() )

			EndDo

		EndIf

	Else

		cPesq := '<IOGPEC05_RD4></IOGPEC05_RD4>'
		cErro := 'Erro no Parse ou Schema Validate do XML enviado: ' + oXml:LastError()

	EndIf

	RestArea( aArea )

	cRet := '<IOGPEC05_RET>' + cPesq + '<ERROR>' + cErro + '</ERROR></IOGPEC05_RET>'

Return cRet

/*/{Protheus.doc} MakeQuery
Função que monta a query de pesquisa ao banco
@author Elton Teodoro Alves
@since 08/03/2017
@version 12.1.014
@param cQuery, characters, Variável passada por referência que será preenchida com a montagem da query conforme parâmetros
@param cWhere, characters, Cláusula where montada conforme xml recebido
@param cOrder, characters, Cláusula Order By montada conforme xml recebido
@param nNumRegPag, numeric, Número de registros por página para montar paginação
@param nPagina, numeric, Númerro da página de retorno
/*/
Static Function MakeQuery( cQuery, cWhere, cOrder, nNumRegPag, nPagina )

	Local cPagIni  := ""
	Local cPagFim  := ""
	Local aCpos    := {}
	Local nX       := ""

	Default cWhere     := ""
	Default nNumRegPag := 0
	Default nPagina    := 0

	If Empty(cOrder)

		cOrder := "RD4.RD4_CHAVE"

	End If

	aAdd( aCpos, "RD4.RD4_CODIDE, " )
	aAdd( aCpos, "RD4.RD4_CHAVE, " )
	aAdd( aCpos, "RD4.RD4_DESC " )

	cQuery += "WITH PAGINA_RD4 AS( "
	cQuery += "SELECT "
	cQuery += "ROW_NUMBER = ROW_NUMBER() OVER ( ORDER BY " + cOrder + " ), "

	For nX := 1 To Len( aCpos )

		cQuery += aCpos[ nX ]

	Next nX

	cQuery += "FROM " + RetSqlName( "RD4" ) + " RD4 "
	cQuery += "LEFT JOIN " + RetSqlName( "RDK" ) + " RDK ON  RDK.RDK_CODIGO = RD4.RD4_CODIGO "
	cQuery += "WHERE RDK.D_E_L_E_T_ = ' ' "
	cQuery += "AND RD4.D_E_L_E_T_ = ' ' "
	cQuery += "AND RDK.RDK_STATUS = '1' "
	cQuery += cWhere
	cQuery += ")SELECT * FROM PAGINA_RD4 "

	If nNumRegPag != 0 .Or. nPagina != 0

		cPagIni := cValToChar( ( nNumRegPag * nPagina ) + 1 - nNumRegPag )
		cPagFim := cValToChar( nNumRegPag * nPagina )

		cQuery += "WHERE ROW_NUMBER BETWEEN " + cPagIni + " AND " + cPagFim

	EndIf

	cQuery += " UNION ALL "

	cQuery += "SELECT COUNT(*) ,'COUNT'" + Replicate( ",''", Len( aCpos ) - 1 ) + " FROM " + RetSqlName( "RD4" ) + " RD4 "
	cQuery += "LEFT JOIN " + RetSqlName( "RDK" ) + " RDK ON  RDK.RDK_CODIGO = RD4.RD4_CODIGO "
	cQuery += "WHERE RDK.D_E_L_E_T_ = ' ' "
	cQuery += "AND RD4.D_E_L_E_T_ = ' ' "
	cQuery += "AND RDK.RDK_STATUS = '1' "
	cQuery += cWhere

Return

/*/{Protheus.doc} MakeWhere
Função que monta as cláusulas where
@author Elton Teodoro Alves
@since 08/03/2017
@version 12.1.014
@param cField, characters, descricao
@param cValue, characters, descricao
@param cRelation, characters, descricao
@param cOperator, characters, descricao
@param cFunction, characters, descricao
@param lFirst, logical, descricao
@param lLast, logical, descricao
@return characters, Relação SQL correspondente
/*/
Static Function MakeWhere( cField, cValue, cRelation, cOperator, cFunction, lFirst, lLast )

	Local cRet := ''

	If ! Empty( cFunction ) .AND. ! cRelation $ "EQUAL/NOT_EQUAL/LESS/LESS_EQUAL/GREATER/GREATER_EQUAL"

		Return 'Permitido utilizar atributo "function" somente quando o atributo "relation" for igual a "EQUAL, NOT_EQUAL, LESS, LESS_EQUAL, GREATER, GREATER_EQUAL"'

	EndIf

	If SubStr( cField, 3, 1 ) == '_'

		cField := 'S' + SubStr( cField, 1, 2 ) + '.' + cField

	End If

	If SubStr( cField, 4, 1 ) == '_'

		cField := SubStr( cField, 1, 3 ) + '.' + cField

	End If

	If ! Empty( cFunction )

		cField := cFunction + "(" + cField + ")"

	ElseIf ! cRelation $  ;
	"IS_NOT_CONTAINED/IS_CONTAINED/NOT_CONTAINS/CONTAINS/" +;
	"START_WITH/NOT_START_WITH/ENDS_WITH/NOT_ENDS_WITH"

		cValue := "'" + cValue + "'"

	EndIf

	If Empty( cFunction )

		cField := "UPPER(" + cField + ")"

	EndIf

	If lFirst

		cRet += " AND "

	Else

		cRet += " " + cOperator + " "

	EndIf

	If cRelation == "EQUAL"

		cRet += cField + " = " + cValue + " "

	ElseIf cRelation == "NOT_EQUAL"

		cRet += cField + " <> " + cValue + " "

	ElseIf cRelation == "LESS"

		cRet += cField + " < " + cValue + " "

	ElseIf cRelation == "LESS_EQUAL"

		cRet += cField + " <= " + cValue + " "

	ElseIf cRelation == "GREATER"

		cRet += cField + " > " + cValue + " "

	ElseIf cRelation == "GREATER_EQUAL"

		cRet += cField + " >= " + cValue + " "

	ElseIf cRelation == "CONTAINS"

		cRet += cField + " LIKE '%" + cValue + "%' "

	ElseIf cRelation == "NOT_CONTAINS"

		cRet += cField + " NOT LIKE '%" + cValue + "%' "

	ElseIf cRelation == "START_WITH"

		cRet += cField + " LIKE '" + cValue + "%' "

	ElseIf cRelation == "NOT_START_WITH"

		cRet += cField + " NOT LIKE '" + cValue + "%' "

	ElseIf cRelation == "ENDS_WITH"

		cRet += cField + " LIKE '%" + cValue + "' "

	ElseIf cRelation == "NOT_ENDS_WITH"

		cRet += cField + " NOT LIKE '%" + cValue + "' "

	ElseIf cRelation == "IS_CONTAINED"

		cRet += cField + " IN (" + StrList( StrTokArr2( cValue, ",", .T. ) ) + ") "

	ElseIf cRelation == "IS_NOT_CONTAINED"

		cRet += cField + " NOT IN (" + StrList( StrTokArr2( cValue, ",", .T. ) ) + ") "

	EndIf

Return cRet

/*/{Protheus.doc} StrList
Static Function que monta a lista de valores para os operadores IN e NOT IN.
@author Elton Teodoro Alves
@since 01/11/2016
@version Protheus 12.1.7
@param aList, array, Array com a lista de valores para montar a string retorno
@return cRet, characters
/*/
Static Function StrList( aList )

	Local cRet := ""
	Local nX   := 0
	Local nLen := Len( aList )

	For nX := 1 To nLen

		cRet += "'" + AllTrim( aList[ nX ] ) + "'"

		If nX < nLen

			cRet += ','

		End If

	Next nX

Return cRet