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
	Local aConds     := {}
	Local cConds     := ''
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
	Local cStart     := ''
	Local cLength    := ''
	Local cTemp      := ''
	Local nX         := 0
	Local nY         := 0

	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML ) .And.;
	oXml:ParseSchemaFile('\schemas\IOGPEC01_REM.xsd') .And.;
	oXml:SchemaValidate()

		oXml:DOMChildNode()

		Do While AllWaysTrue()

			If oXml:cName $ 'CONDITION'

				oXml:DOMChildNode()

				Do While AllWaysTrue()

					aAttNode   := oXML:DOMGetAttArray()
					aChildNode := oXML:DOMGetChildArray()

					nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'field' } )
					cField    := aAttNode[ nPos, 2 ]

					cValue    := Upper( aChildNode[ 1, 2 ] )

					nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'relation' } )
					cRelation := If( nPos == 0, 'EQUAL', aAttNode[ nPos, 2 ] )

					nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'operator' } )
					cOperator := If( nPos == 0, 'AND', aAttNode[ nPos, 2 ] )

					nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'function' } )
					cFunction := If( nPos == 0, '', aAttNode[ nPos, 2 ] )

					nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'start' } )
					cStart := If( nPos == 0, '', aAttNode[ nPos, 2 ] )

					nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'length' } )
					cLength := If( nPos == 0, '', aAttNode[ nPos, 2 ] )

					aAdd( aWhere, { cField, cValue, cRelation, cOperator, cFunction, cStart, cLength } )

					If ! oXml:DOMNextNode()

						Exit

					EndIf

				End Do

				oXml:DOMParentNode()

				aAdd( aConds, aClone( aWhere ) )

				aSize( aWhere, 0 )

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

				aAttNode   := oXML:DOMGetAttArray()

				nPos       := aScan( aAttNode, { | X | X[ 1 ] == 'number_of_records' } )
				nNumRegPag := Val( aAttNode[ nPos, 2 ] )

				nPos       := aScan( aAttNode, { | X | X[ 1 ] == 'page' } )
				nPagina    := Val( aAttNode[ nPos, 2 ] )

			EndIf

			If ! oXml:DOMNextNode()

				Exit

			EndIf

		End Do

		For nY := 1 To Len( aConds )

			For nX:= 1 To Len( aConds[ nY ] )

				cTemp := MakeWhere( aConds[nY,nX,1], aConds[nY,nX,2], aConds[nY,nX,3], aConds[nY,nX,4], aConds[nY,nX,5], aConds[nY,nX,6], aConds[nY,nX,7], nX == 1 , nX == Len( aConds[ nY ] ) )

				If SubStr( cTemp, 1, Len("Permitido") ) = "Permitido"

					cPesq := '<IOGPEC01_SRA></IOGPEC01_SRA>'
					Return '<IOGPEC01_RET>' + cPesq + '<ERROR>' + cTemp + '</ERROR></IOGPEC01_RET>'

				Else

					cWhere += cTemp

				EndIf

			Next nX

			If nY == 1

				cConds += ' WHERE ('

			Else

				cConds += ' AND ('

			End If

			cConds += cWhere + ') '

			cWhere := ''

		Next nY

		MakeQuery( @cQuery, cConds, cOrder, nNumRegPag, nPagina )

		If TcSqlExec( cQuery ) < 0

			cPesq := '<IOGPEC01_SRA></IOGPEC01_SRA>'
			cErro := TcSqlError()

		Else

			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

			(cTmp)->( DbGoTop() )

			Do While ! (cTmp)->( Eof() )

				If ! AllTrim( (cTmp)->RA_MAT ) == 'COUNT'

					cPesq += '<IOGPEC01_SRA>'

					For nX := 1 To ( cTmp )->( FCount() )

						cField := AllTrim( ( cTmp )->( FieldName( nX ) ) )

						If cField # 'ROW_NUMBER'

							cPesq += '<' + cField + '>'
							cPesq += AllTrim( ( cTmp )->( FieldGet( nX ) ) )
							cPesq += '</' + cField + '>'

						EndIf

					Next nX

					cPesq += '</IOGPEC01_SRA>'

				Else

					cPesq += '<TOTAL_SEARCH_RECORDS>' + AllTrim( cValToChar( (cTmp)->ROW_NUMBER ) ) + '</TOTAL_SEARCH_RECORDS>'

				EndIf

				( cTmp )->( DbSkip() )

			EndDo

		EndIf

	Else

		cPesq := '<IOGPEC01_SRA></IOGPEC01_SRA>'
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
	Local cTipoAfa := ""
	Local cPagIni  := ""
	Local cPagFim  := ""
	Local aCpos    := {}
	Local nX       := ""

	Default cWhere     := ""
	Default nNumRegPag := 0
	Default nPagina    := 0

	If Empty(cOrder)

		cOrder := "SRA.RA_MAT"

	End If

	cCase += "CASE "

	Do While SM0->( ! Eof() ) .And. SM0->M0_CODIGO == cEmpAnt

		cCase += "WHEN SRA.RA_FILIAL = '" + SM0->M0_CODFIL + "' THEN '" + AllTrim( SM0->M0_FILIAL ) + "' "

		SM0->( DbSkip() )

	EndDo

	cCase += "ELSE '' "
	cCase += "END M0_NOME, "

	SM0->( RestArea( aAreaSM0 ) )
	RestArea( aArea )

	cTipoAfa += "R8_TIPOAFA = "
	cTipoAfa += "COALESCE(( "
	cTipoAfa += "SELECT TOP 1 SR8.R8_TIPOAFA FROM " + RetSqlName( "SR8" ) + " SR8 "
	cTipoAfa += "WHERE SR8.D_E_L_E_T_ = ' ' "
	cTipoAfa += "AND SR8.R8_FILIAL = SRA.RA_FILIAL "
	cTipoAfa += "AND SR8.R8_MAT = SRA.RA_MAT "
	cTipoAfa += "AND SR8.R8_DATAINI <= FORMAT(GETDATE(),'yyyyMMdd') "
	cTipoAfa += "AND ( SR8.R8_DATAFIM >= FORMAT(GETDATE(),'yyyyMMdd') OR SR8.R8_DATAFIM = '' ) "
	cTipoAfa += "),''), "

	aAdd( aCpos, "SRA.RA_MAT, " )
	aAdd( aCpos, "SRA.RA_NOME, " )
	aAdd( aCpos, "SRA.RA_NOMECMP, " )
	aAdd( aCpos, "SRA.RA_APELIDO, " )
	aAdd( aCpos, "SRA.RA_CARGO," )
	aAdd( aCpos, "SQ3.Q3_DESCSUM," )
	aAdd( aCpos, "SRA.RA_CATFUNC," )
	aAdd( aCpos, cCase )//M0_NOME
	aAdd( aCpos, "SZ0.Z0_XRAMAL, " )
	aAdd( aCpos, "SZ0.Z0_XRAMAL2, " )
	aAdd( aCpos, "SZ0.Z0_XRAMAL3, " )
	aAdd( aCpos, "SRA.RA_DEPTO, " )
	aAdd( aCpos, "RD4_CHAVE = COALESCE(RD4.RD4_CHAVE,''), " )
	aAdd( aCpos, "QB_DESCRIC = COALESCE(SQB.QB_DESCRIC,''), " )
	aAdd( aCpos, "SRA.RA_DEMISSA, " )
	aAdd( aCpos, "Q3_XNIVCAR = COALESCE(SQ3.Q3_XNIVCAR,''), " )
	aAdd( aCpos, "SRA.RA_NASC, " )
	aAdd( aCpos, "SRA.RA_FILIAL, " )
	aAdd( aCpos, "SRA.RA_SITFOLH, " )
	aAdd( aCpos, cTipoAfa ) //R8_TIPOAFA
	aAdd( aCpos, "SRA.RA_EMAIL, " )
	aAdd( aCpos, "SRA.RA_CIC, " )
	aAdd( aCpos, "SQB.QB_XSIGLA, " )
	aAdd( aCpos, "SZ0.Z0_XLOGIN, " )
	aAdd( aCpos, "SRA.RA_PROCES, " )
	aAdd( aCpos, "SRA.RA_CC " )

	cQuery += "WITH PAGINA_SRA AS( "
	cQuery += "SELECT ROW_NUMBER = ROW_NUMBER() OVER ( ORDER BY RA_NOME DESC,RA_MAT DESC ),* FROM ( "
	cQuery += "SELECT "

	For nX := 1 To Len( aCpos )

		cQuery += aCpos[ nX ]

	Next nX

	cQuery += "FROM " + RetSqlName( "SRA" ) + " SRA "
	cQuery += "LEFT JOIN " + RetSqlName( "SZ0" ) + " SZ0 ON SRA.RA_MAT    = SZ0.Z0_CODIGO "
	cQuery += "LEFT JOIN " + RetSqlName( "SQB" ) + " SQB ON SRA.RA_DEPTO  = SQB.QB_DEPTO "
	cQuery += "LEFT JOIN " + RetSqlName( "SQ3" ) + " SQ3 ON SRA.RA_CARGO  = SQ3.Q3_CARGO "
	cQuery += "LEFT JOIN " + RetSqlName( "RD4" ) + " RD4 ON SRA.RA_DEPTO  = RD4.RD4_CODIDE "
	cQuery += "WHERE COALESCE(SRA.D_E_L_E_T_, ' ') = ' ' "
	cQuery += "AND COALESCE(SQB.D_E_L_E_T_, ' ') = ' ' "
	cQuery += "AND COALESCE(SQ3.D_E_L_E_T_, ' ') = ' ' "
	cQuery += "AND COALESCE(SZ0.D_E_L_E_T_, ' ') = ' ' "
	cQuery += "AND COALESCE(RD4.D_E_L_E_T_, ' ') = ' ' "
	cQuery += ") SUBQRY "
	cQuery += cWhere
	cQuery += ")SELECT * FROM PAGINA_SRA "

	If nNumRegPag != 0 .Or. nPagina != 0

		cPagIni := cValToChar( ( nNumRegPag * nPagina ) + 1 - nNumRegPag )
		cPagFim := cValToChar( nNumRegPag * nPagina )

		cQuery += "WHERE ROW_NUMBER BETWEEN " + cPagIni + " AND " + cPagFim

	EndIf

	cQuery += " UNION ALL "

	cQuery += "SELECT COUNT(*) ,'COUNT'" + Replicate( ",''", Len( aCpos ) - 1 ) + " FROM PAGINA_SRA "

Return

/*/{Protheus.doc} MakeWhere
Função que monta as cláusulas where
@author Elton Teodoro Alves
@since 08/03/2017
@version 12.1.014
@param cField, characters, Nome do Campo
@param cValue, characters, Valor de comparação
@param cRelation, characters, Operador relacional
@param cOperator, characters, Operador Logico
@param cFunction, characters, Funcao aplicada na condicao
@param lFirst, logical, Indica se é a primeira condição
@param lLast, logical, Indica se é a ultima condição
@return characters, Relação SQL correspondente
/*/
Static Function MakeWhere( cField, cValue, cRelation, cOperator, cFunction, cStart, cLength, lFirst, lLast )

	Local cRet := ''

	If ! Empty( cFunction ) .AND. ! cRelation $ "EQUAL/NOT_EQUAL/LESS/LESS_EQUAL/GREATER/GREATER_EQUAL"

		Return 'Permitido utilizar atributo "function" somente quando o atributo "relation" for igual a "EQUAL, NOT_EQUAL, LESS, LESS_EQUAL, GREATER, GREATER_EQUAL"'

	EndIf

	cField := 'SUBQRY' + '.' + cField

	If ! Empty( cFunction )

		If cFunction = 'LEN'

			cField := cFunction + "(" + cField + ")"

		ElseIf cFunction = 'SUBSTRING'

			cField := cFunction + "(" + cField + " COLLATE SQL_LATIN1_GENERAL_CP1251_CI_AS ," + cStart + "," + cLength + ")"

		End If

	End If

	If ! cRelation $ ;
	"IS_NOT_CONTAINED/IS_CONTAINED/NOT_CONTAINS/CONTAINS/" +;
	"START_WITH/NOT_START_WITH/ENDS_WITH/NOT_ENDS_WITH"

		cValue := "'" + cValue + "'"

	EndIf

	If Empty( cFunction )

		cField := " " + cField + " COLLATE SQL_LATIN1_GENERAL_CP1251_CI_AS "

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

	If ! lLast

		cRet += " " + cOperator + " "

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