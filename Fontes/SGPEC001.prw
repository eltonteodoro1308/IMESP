#DEFINE ENTER Chr(13) + Chr(10)
#INCLUDE 'TOTVS.CH'

User Function SGPEC001( cXml )

	Local cRet       := ''
	Local oXml       := TXmlManager():New()
	Local aArea      := GetArea()
	Local aAttNode   := {}
	Local aChildNode := {}
	Local nX         := 0
	Local cQuery     := "SELECT * FROM " + RetSqlName( "SRA" ) + " SRA WHERE "
	Local nPos       := 0
	Local nChild     := 0
	Local cfield     := ''
	Local cRelation  := ''
	Local cOperator  := ''
	Local cValue     := ''
	Local cTmp       := GetNextAlias()

	Local cStr       := MemoRead( "C:\TOTVS\Developer Studio\Workspace-11.3\IMESP\seek.xml", .F. )
	Default cXml := cStr

	If oXml:Parse( cXML ) .And. oXml:ParseSchemaFile('\schemas\seek.xsd')

		nChild := oXml:DOMChildCount() 

		For nX := 1 To nChild

			If nX == 1

				oXml:DOMChildNode()

			End If

			aAttNode   := oXML:DOMGetAttArray()
			aChildNode := oXML:DOMGetChildArray()

			nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'field' } )
			cfield    := aAttNode[ nPos, 2 ]

			nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'relation' } )
			cRelation := If( nPos == 0, 'EQUAL', aAttNode[ nPos, 2 ] )

			If cRelation == "EQUAL"

				cRelation := '='

			ElseIf cRelation == "NOT_EQUAL"

				cRelation := '<>'

			ElseIf cRelation == "LESS"

				cRelation := '<'

			ElseIf cRelation == "LESS_EQUAL"

				cRelation := '<='

			ElseIf cRelation == "GREATER"

				cRelation := '>'

			ElseIf cRelation == "GREATER_EQUAL"

				cRelation := '>='

			ElseIf cRelation == "CONTAINS"

				cRelation := 'LIKE'

			ElseIf cRelation == "NOT_CONTAINS"

				cRelation := 'NOT LIKE'

			ElseIf cRelation == "IS_CONTAINED"

				cRelation := 'IN'

			ElseIf cRelation == "IS_NOT_CONTAINED"

				cRelation := 'NOT IN'

			End If

			nPos      := aScan( aAttNode, { | X | X[ 1 ] == 'operator' } )
			cOperator := If( nPos == 0, 'AND', aAttNode[ nPos, 2 ] )

			cValue    := aChildNode[ 1, 2 ]

			If cRelation $ "LIKE/NOT LIKE"

				cValue := "'%" + cValue + "%'"

			ElseIf cRelation $ "IN/NOT IN"

				cValue := "(" + StrList( StrTokArr2( cValue, ",", .T. ) ) + ")"

			Else

				cValue    := "'" + cValue + "'"

			EndIf

			cQuery += cfield + " " + cRelation + " " + cValue + ENTER

			If nX < nChild  

				cQuery += cOperator + " " + ENTER

			End If

			oXml:DOMNextNode()

		Next nX

		cQuery := ChangeQuery( cQuery )

		If TcSqlExec( cQuery ) < 0

			cRet := TcSqlError()

		Else

			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

			cTmp->( DbCloseArea() )

		End If

	End If

	RestArea( aArea )

Return cRet
//------------------------------------------------------------------
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