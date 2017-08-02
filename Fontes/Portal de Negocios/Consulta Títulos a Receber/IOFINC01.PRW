#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOFINC01
User Function que através de XML recebido conforme schema faz busca do cadastro de funcionários
	e retorna outro xml com resultado da consulta.
	@author Elton Teodoro Alves
	@since 07/03/2016
	@version Protheus 12.1.7
	@param cXml, characters, XML enviado com dados da consulta
	@return characters, Xml de retorno da Pesquisa
	/*/
User Function IOFINC01( cXml )
	
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
			oXml:ParseSchemaFile('\schemas\IOFINC01_REM.xsd') .And.;
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
					
					cPesq := '<IOFINC01_SE1></IOFINC01_SE1>'
					Return '<IOFINC01_RET>' + cPesq + '<ERROR>' + cTemp + '</ERROR></IOFINC01_RET>'
					
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
		MemoWrite( '\TEMP\QUERY.SQL',cQuery )
		If TcSqlExec( cQuery ) < 0
			
			cPesq := '<IOFINC01_SE1></IOFINC01_SE1>'
			cErro := TcSqlError()
			
		Else
			
			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )
			
			(cTmp)->( DbGoTop() )
			
			Do While ! (cTmp)->( Eof() )
				
				If ! AllTrim( (cTmp)->E1_CLIENTE ) == 'COUNT'
					
					cPesq += '<IOFINC01_SE1>'
					
					For nX := 1 To ( cTmp )->( FCount() )
						
						cField := AllTrim( ( cTmp )->( FieldName( nX ) ) )
						
						If cField # 'ROW_NUMBER'
							
							cPesq += '<' + cField + '>'
							cPesq += AllTrim( ( cTmp )->( FieldGet( nX ) ) )
							cPesq += '</' + cField + '>'
							
						EndIf
						
					Next nX
					
					cPesq += '</IOFINC01_SE1>'
					
				Else
					
					cPesq += '<TOTAL_SEARCH_RECORDS>' + AllTrim( cValToChar( (cTmp)->ROW_NUMBER ) ) + '</TOTAL_SEARCH_RECORDS>'
					
				EndIf
				
				( cTmp )->( DbSkip() )
				
			EndDo
			
		EndIf
		
	Else
		
		cPesq := '<IOFINC01_SE1></IOFINC01_SE1>'
		cErro := 'Erro no Parse ou Schema Validate do XML enviado: ' + oXml:LastError()
		
	EndIf
	
	RestArea( aArea )
	
	cRet := '<IOFINC01_RET>' + cPesq + '<ERROR>' + cErro + '</ERROR></IOFINC01_RET>'
	
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
	
	Local cTipoAfa := ""
	Local cPagIni  := ""
	Local cPagFim  := ""
	Local aCpos    := {}
	Local nX       := ""
	
	Default cWhere     := ""
	Default nNumRegPag := 0
	Default nPagina    := 0
	
	If Empty(cOrder)
		
		cOrder := "SE1.E1_XSISTEM,SE1.E1_XVENDID"
		
	End If
	
	aAdd( aCpos, "SE1.E1_CLIENTE, " )
	aAdd( aCpos, "SE1.E1_XPEDIDO, " )
	aAdd( aCpos, "SE1.E1_TIPO, " )
	aAdd( aCpos, "SE1.E1_PREFIXO, " )
	aAdd( aCpos, "SE1.E1_NUM, " )
	aAdd( aCpos, "SE1.E1_PARCELA, " )
	aAdd( aCpos, "FORMAT(SE1.E1_VALOR,'F') E1_VALOR, " )
	aAdd( aCpos, "FORMAT(SE1.E1_SALDO,'F') E1_SALDO, " )
	aAdd( aCpos, "SE1.E1_NUMBCO, " )
	aAdd( aCpos, "SE1.E1_BAIXA, " )
	aAdd( aCpos, "SE1.E1_XSISTEM, " )
	aAdd( aCpos, "SE1.E1_XVENDID, " )
	aAdd( aCpos, "SE1.E1_XIDCPG, " )
	aAdd( aCpos, "SE1.E1_VENCTO, " )
	aAdd( aCpos, "SE1.E1_EMISSAO " )
	
	cQuery += "WITH PAGINA_SE1 AS( "
	cQuery += "SELECT ROW_NUMBER = ROW_NUMBER() OVER ( ORDER BY E1_XSISTEM,E1_XVENDID ),* FROM ( "
	cQuery += "SELECT "
	
	For nX := 1 To Len( aCpos )
		
		cQuery += aCpos[ nX ]
		
	Next nX
	
	cQuery += "FROM " + RetSqlName( "SE1" ) + " SE1 "
	cQuery += "WHERE SE1.D_E_L_E_T_ = ' ' "
	cQuery += "AND SE1.E1_XSISTEM <> ' ' "
	cQuery += "AND SE1.E1_XVENDID <> ' ' "
	cQuery += "AND SE1.E1_FILIAL = '" + xFilial( "SE1" ) + "' "
	cQuery += ") SUBQRY "
	cQuery += cWhere
	cQuery += ")SELECT * FROM PAGINA_SE1 "
	
	If nNumRegPag != 0 .Or. nPagina != 0
		
		cPagIni := cValToChar( ( nNumRegPag * nPagina ) + 1 - nNumRegPag )
		cPagFim := cValToChar( nNumRegPag * nPagina )
		
		cQuery += "WHERE ROW_NUMBER BETWEEN " + cPagIni + " AND " + cPagFim
		
	EndIf
	
	cQuery += " UNION ALL "
	
	cQuery += "SELECT COUNT(*) ,'COUNT'" + Replicate( ",''", Len( aCpos ) - 1 ) + " FROM PAGINA_SE1 "
	
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
	
	Local cRet     := ''
	Local cTipoCpo := GetSx3Cache( cField, 'X3_TIPO' )
	
	If ! Empty( cFunction ) .AND. ! cRelation $ "EQUAL/NOT_EQUAL/LESS/LESS_EQUAL/GREATER/GREATER_EQUAL"
		
		Return 'Permitido utilizar atributo "function" somente quando o atributo "relation" for igual a "EQUAL, NOT_EQUAL, LESS, LESS_EQUAL, GREATER, GREATER_EQUAL"'
		
	EndIf
	
	If cTipoCpo == 'N' .AND. ! cRelation $ "EQUAL/NOT_EQUAL/LESS/LESS_EQUAL/GREATER/GREATER_EQUAL"
		
		Return 'Permitido utilizar valor numérico somente quando o atributo "relation" for igual a "EQUAL, NOT_EQUAL, LESS, LESS_EQUAL, GREATER, GREATER_EQUAL"'
		
	EndIf
	
	If cTipoCpo == 'N' .AND. ! Empty( cFunction )
		
		Return 'Permitido utilizar atributo "function" somente com tipo não numérico.'
		
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
			"START_WITH/NOT_START_WITH/ENDS_WITH/NOT_ENDS_WITH" .And. cTipoCpo # 'N'
		
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
