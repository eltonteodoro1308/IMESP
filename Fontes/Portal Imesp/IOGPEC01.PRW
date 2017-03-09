#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOGPEC01
User Function que através de XML recebido conforme schema faz busca do cadastro de funcionários
e retorna outro xml com resultado da consulta.
@author Elton Teodoro Alves
@since 07/03/2016
@version Protheus 12.1.7
@param cXml, characters, XML enviado com dados da consulta
@return characters, Xml de retorno da Pesquisa
/*/
User Function IOGPEC01( cXml )

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
	Local nX         := 0
	Local nY         := 0
	cXml := MemoRead( '\xml\IOGPEC01_REM.xml' )
	If oXml:Parse( cXML ) .And.;
	oXml:ParseSchemaFile('\schemas\IOGPEC01_REM.xsd') .And.;
	oXml:SchemaValidate()

		oXml:DOMChildNode()

		Do While AllWaysTrue()

			aAttNode   := oXML:DOMGetAttArray()
			aChildNode := oXML:DOMGetChildArray()

			If ! oXml:cName $ 'SORT/PAGINATION'

				nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'field' } )
				cfield    := aAttNode[ nPos, 2 ]

				cValue    := Upper( aChildNode[ 1, 2 ] )

				nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'relation' } )
				cRelation := If( nPos == 0, 'EQUAL', aAttNode[ nPos, 2 ] )

				nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'operator' } )
				cOperator := If( nPos == 0, 'AND', aAttNode[ nPos, 2 ] )

				aAdd( aWhere, { cField, cValue, cRelation, cOperator } )

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

			cWhere += MakeWhere( aWhere[nX,1], aWhere[nX,2], aWhere[nX,3], aWhere[nX,4], nX == 1 , nX == Len( aWhere ) )

		Next nX

		MakeQuery( @cQuery, cWhere, cOrder, nNumRegPag, nPagina )

		If TcSqlExec( cQuery ) < 0

			cErro := TcSqlError()

		Else

			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

			(cTmp)->( DbGoTop() )

			Do While ! (cTmp)->( Eof() )

				If ! AllTrim( (cTmp)->RA_MAT ) == 'COUNT'

					cPesq += '<IOGPEC01_SRA record="' + cValToChar(++nY) + '">'

					For nX := 1 To ( cTmp )->( FCount() )

						cField := AllTrim( ( cTmp )->( FieldName( nX ) ) )

						If cField # 'ROW_NUMBER'

							cPesq += '<' + cField + ' order="'+ cValToChar( nX ) +'"><value>'
							cPesq += AllTrim( ( cTmp )->( FieldGet( nX ) ) )
							cPesq += '</value></' + cField + '>'

						EndIf

					Next nX

					cPesq += '</IOGPEC01_SRA>'

				Else

					cPesq += '<TOTAL_SEARCH_RECORDS value="' + AllTrim( cValToChar( (cTmp)->ROW_NUMBER ) ) + '" />'

				EndIf

				( cTmp )->( DbSkip() )

			EndDo

		EndIf

	Else

		cErro := 'Erro no Parse ou Schema Validate do XML enviado: ' + oXml:LastError()

	EndIf

	RestArea( aArea )

	cRet := '<IOGPEC01_RET>' + cPesq + '<ERROR>' + cErro + '</ERROR></IOGPEC01_RET>'

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

	Local aAreaSM0 := SM0->( GetArea() )
	Local aArea    := GetArea()
	Local cCase    := ""
	Local cPagIni  := ""
	Local cPagFim  := ""
	Local aCpos    := {}
	Local nX       := ""

	Default cWhere     := ""
	Default cOrder     := "SRA.RA_MAT"
	Default nNumRegPag := 0
	Default nPagina    := 0

	cCase += "CASE "

	Do While SM0->( ! Eof() ) .And. SM0->M0_CODIGO == cEmpAnt

		cCase += "WHEN SRA.RA_FILIAL = '" + SM0->M0_CODFIL + "' THEN '" + AllTrim( SM0->M0_FILIAL ) + "' "

		SM0->( DbSkip() )

	EndDo

	cCase += "ELSE '' "
	cCase += "END SM0_NOME, "

	SM0->( RestArea( aAreaSM0 ) )
	RestArea( aArea )

	aAdd( aCpos, "SRA.RA_MAT, " )
	aAdd( aCpos, "SRA.RA_NOME, " )
	aAdd( aCpos, "SRA.RA_NOMECMP, " )
	aAdd( aCpos, "SRA.RA_APELIDO, " )
	aAdd( aCpos, "SRA.RA_CARGO," )
	aAdd( aCpos, cCase )//M0_FILIAL
	aAdd( aCpos, "SRA.RA_XRAMAL, " )
	aAdd( aCpos, "SRA.RA_XRAMAL2, " )
	aAdd( aCpos, "SRA.RA_XRAMAL3, " )
	aAdd( aCpos, "SRA.RA_DEPTO, " )
	aAdd( aCpos, "QB_DESCRIC = COALESCE(SQB.QB_DESCRIC,''), " )
	aAdd( aCpos, "SRA.RA_DEMISSA, " )
	aAdd( aCpos, "Q3_CLASSE = COALESCE(SQ3.Q3_CLASSE,''), " )
	aAdd( aCpos, "SRA.RA_NASC, " )
	aAdd( aCpos, "SRA.RA_FILIAL, " )
	aAdd( aCpos, "SRA.RA_SITFOLH, " )
	aAdd( aCpos, "SRA.RA_EMAIL, " )
	aAdd( aCpos, "SRA.RA_CIC, " )
	aAdd( aCpos, "SRA.RA_XSIGLA, " )
	aAdd( aCpos, "SRA.RA_XLOGIN " )

	cQuery += "WITH PAGINA_SRA AS( "
	cQuery += "SELECT "
	cQuery += "ROW_NUMBER = ROW_NUMBER() OVER ( ORDER BY " + cOrder + " ), "

	For nX := 1 To Len( aCpos )

		cQuery += aCpos[ nX ]

	Next nX

	cQuery += "FROM " + RetSqlName( "SRA" ) + " SRA "
	cQuery += "LEFT JOIN " + RetSqlName( "SQB" ) + " SQB ON SRA.RA_DEPTO = SQB.QB_DEPTO "
	cQuery += "LEFT JOIN " + RetSqlName( "SQ3" ) + " SQ3 ON SRA.RA_CARGO = SQ3.Q3_CARGO "
	cQuery += "WHERE SRA.D_E_L_E_T_ = ' ' "
	cQuery += cWhere
	cQuery += ")SELECT * FROM PAGINA_SRA "

	If nNumRegPag != 0 .Or. nPagina != 0

		cPagIni := cValToChar( ( nNumRegPag * nPagina ) + 1 - nNumRegPag )
		cPagFim := cValToChar( nNumRegPag * nPagina )

		cQuery += "WHERE ROW_NUMBER BETWEEN " + cPagIni + " AND " + cPagFim

	EndIf

	cQuery += " UNION ALL "

	cQuery += "SELECT COUNT(*) ,'COUNT'" + Replicate( ",''", Len( aCpos ) - 1 ) + " FROM " + RetSqlName( "SRA" ) + " SRA "
	cQuery += "LEFT JOIN " + RetSqlName( "SQB" ) + " SQB ON SRA.RA_DEPTO = SQB.QB_DEPTO "
	cQuery += "LEFT JOIN " + RetSqlName( "SQ3" ) + " SQ3 ON SRA.RA_CARGO = SQ3.Q3_CARGO "
	cQuery += "WHERE SRA.D_E_L_E_T_ = ' ' "
	cQuery += cWhere

Return

/*/{Protheus.doc} MakeWhere
Função que monta as cláusulas where
@author Elton Teodoro Alves
@since 08/03/2017
@version 12.1.014
@param cRelation, characters, Relação enviada pelo XML
@return characters, Relação SQL correspondente
/*/
Static Function MakeWhere( cField, cValue, cRelation, cOperator, lFirst, lLast )

	Local cRet := ''

	If SubStr( cField, 3, 1 ) == '_'

		cField := 'S' + SubStr( cField, 1, 2 ) + '.' + cField

	End If

	If SubStr( cField, 4, 1 ) == '_'

		cField := SubStr( cField, 1, 3 ) + '.' + cField

	End If

	cField := "UPPER(" + cField + ")"

	If lFirst

		cRet += " AND "

	Else

		cRet += " " + cOperator + " "

	EndIf

	If cRelation == "EQUAL"

		cRet += cField + " = '" + cValue + "' "

	ElseIf cRelation == "NOT_EQUAL"

		cRet += cField + " <> '" + cValue + "' "

	ElseIf cRelation == "LESS"

		cRet += cField + " < '" + cValue + "' "

	ElseIf cRelation == "LESS_EQUAL"

		cRet += cField + " <= '" + cValue + "' "

	ElseIf cRelation == "GREATER"

		cRet += cField + " > '" + cValue + "' "

	ElseIf cRelation == "GREATER_EQUAL"

		cRet += cField + " >= '" + cValue + "' "

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