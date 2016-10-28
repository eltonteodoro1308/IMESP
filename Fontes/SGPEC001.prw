#INCLUDE 'TOTVS.CH'

User Function SGPEC001( cXml )

	Local cRet       := ''
	Local oXml       := TXmlManager():New()
	Local aArea      := GetArea()
	Local aAreaSM0   := SM0->( GetArea() )
	Local aAttNode   := {}
	Local aChildNode := {}
	Local nX         := 0
	Local nY         := 1
	Local cQuery     := ''
	Local cCase      := ''
	Local nPos       := 0
	Local nChild     := 0
	Local cfield     := ''
	Local cRelation  := ''
	Local cOperator  := ''
	Local cValue     := ''
	Local cTmp       := GetNextAlias()

	SM0->( DbSetOrder( 1 ) )
	SM0->( DbSeek( cEmpAnt ) )

	cCase += "CASE "

	Do While SM0->( .Not. Eof() ) .And. SM0->M0_CODIGO == cEmpAnt

		cCase += "WHEN SRA.RA_FILIAL = '" + SM0->M0_CODFIL + "' THEN '" + AllTrim( SM0->M0_FILIAL ) + "' "

		SM0->( DbSkip() )

	End Do

	cCase += "ELSE '' "
	cCase += "END SM0_NOME,"

	SM0->( RestArea( aAreaSM0 ) )

	cQuery += "SELECT           "
	cQuery += "RA_MAT          ,"
	cQuery += "RA_NOME         ,"
	cQuery += "RA_NOMECMP      ,"
	cQuery += "RA_APELIDO      ,"
	cQuery += "RA_CARGO        ,"
	cQuery +=  cCase //M0_FILIAL
	cQuery += "RA_XRAMAL  = '' ,"
	cQuery += "RA_XRAMAL2 = '' ,"
	cQuery += "RA_XRAMAL3 = '' ,"
	cQuery += "RA8_DEPTO  = '' ,"
	cQuery += "RA_XNCARGO = '' ,"
	cQuery += "RA_NASC         ,"
	cQuery += "RA_FILIAL       ,"
	cQuery += "RA_SITFOLH      ,"
	cQuery += "RA_EMAIL        ,"
	cQuery += "RA_CIC          ,"
	cQuery += "SIGAORG    = '' ,"
	cQuery += "RA_FILIAL       ,"
	cQuery += "RA_XSIGLA  = '' ,"
	cQuery += "RA_XLOGIN  = ''  "
	cQuery += " FROM "
	cQuery += RetSqlName( "SRA" ) + " SRA WHERE "

	If oXml:Parse( cXML ) .And.;
	oXml:ParseSchemaFile('\schemas\loadfilter.xsd') .And.;
	oXml:SchemaValidate()

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

			cValue    := Upper( aChildNode[ 1, 2 ] )

			If cRelation $ "LIKE/NOT LIKE"

				cValue := "'%" + cValue + "%'"

			ElseIf cRelation $ "IN/NOT IN"

				cValue := "(" + StrList( StrTokArr2( cValue, ",", .T. ) ) + ")"

			Else

				cValue    := "'" + cValue + "'"

			EndIf

			cQuery += "UPPER(" + cfield + ") " + cRelation + " " + cValue

			If nX < nChild

				cQuery += " " + cOperator + " "

			End If

			oXml:DOMNextNode()

		Next nX

		cQuery := ChangeQuery( cQuery )
		ConOut( cQuery )
		If TcSqlExec( cQuery ) < 0

			cRet := TcSqlError()

		Else

			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

			( cTmp )->( DbGoTop() )

			If ( cTmp )->( .Not. Eof() )

				cRet += '<?xml version="1.0" encoding="UTF-8"?>'
				cRet += '<SGPEC001 Operation="1">'

				Do While ( cTmp )->( .Not. Eof() )

					cRet += '<SGPEC001_SRA record="' + cValToChar(nY) + '">'

					For nX := 1 To ( cTmp )->( FCount() )

						cField := AllTrim( ( cTmp )->( FieldName( nX ) ) )

						cRet += '<' + cField + ' order="'+ cValToChar( nX ) +'"><value>'
						cRet += AllTrim( ( cTmp )->( FieldGet( nX ) ) )
						cRet += '</value></' + cField + '>'

					Next nX

					nY++

					( cTmp )->( DbSkip() )

					cRet += '</SGPEC001_SRA>'

				End Do

				cRet += '</SGPEC001>'

			Else

				cRet := 'Nao ha registros para esta consulta'

			EndIf

			( cTmp )->( DbCloseArea() )

		End If

	Else

		cRet := oXml:LastError()

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