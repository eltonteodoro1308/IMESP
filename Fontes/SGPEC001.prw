#INCLUDE 'TOTVS.CH'

User Function SGPEC001( cXml )

	Local cRet       := ''
	Local oModel     := MpFormModel():New( 'SGPEM001' )
	Local oXml       := TXmlManager():New()
	Local aArea      := GetArea()
	Local lEmpty     := .T. // Indica se gera xml com campos nao obrigatorios vazios
	Local oStrSRAFld := FWFormStruct( 1, 'SRA' )
	Local oStrSRAGrd := Nil
	Local aFields    := {}
	Local nX         := 1
	Local aAttNode   := {}
	Local aChildNode := {}
	Local cStr       := MemoRead( "C:\TOTVS\Developer Studio\Workspace-11.3\IMESP\seek.xml", .F. )

	Default cXml := cStr

	aAdd( aFields, 'RA_MAT'     )
	aAdd( aFields, 'RA_NOME'    )
	aAdd( aFields, 'RA_NOMECMP' )
	aAdd( aFields, 'RA_APELIDO' )
	aAdd( aFields, 'RA_CARGO'   )
	aAdd( aFields, 'M0_NOME'    )
	aAdd( aFields, 'RA_XRAMAL'  )
	aAdd( aFields, 'RA_XRAMAL2' )
	aAdd( aFields, 'RA_XRAMAL3' )
	aAdd( aFields, 'RA8_DEPTO'  )
	aAdd( aFields, 'RA_XNCARGO' )
	aAdd( aFields, 'RA_NASC'    )
	aAdd( aFields, 'RA_FILIAL'  )
	aAdd( aFields, 'RA_SITFOLH' )
	aAdd( aFields, 'RA_EMAIL'   )
	aAdd( aFields, 'RA_CIC'     )
	aAdd( aFields, 'RA_FILIAL'  )
	aAdd( aFields, 'RA_XSIGLA'  )
	aAdd( aFields, 'RA_XLOGIN'  )
	aAdd( aFields, 'RA_XRAMAL'  )
	aAdd( aFields, 'RA_XRAMAL2' )
	aAdd( aFields, 'RA_XRAMAL3' )
	aAdd( aFields, 'RA_SIGLA'   )
	aAdd( aFields, 'RA_XLOGIN'  )

	oStrSRAGrd := FWFormStruct( 1, 'SRA', { | X | aScan( aFields, AllTrim( X ) ) # 0 } )

	oModel:SetDescription( 'Funcionarios da Filial Corrente' )

	oModel:AddFields( 'SRA_FIELD', , oStrSRAFld )
	oModel:GetModel( 'SRA_FIELD' ):SetDescription( 'Filial Corrente' )

	oModel:AddGrid( 'SRA_GRID', 'SRA_FIELD', oStrSRAGrd )
	oModel:GetModel( 'SRA_GRID' ):SetDescription( 'Funcionarios' )

	oModel:SetRelation( 'SRA_GRID', { { 'RA_FILIAL', 'xFilial( "SRA" )' } }, SRA->( IndexKey( 1 ) ) )

	If oXml:Parse( cXML )

		If oXml:cPath == '/load' .And. oXml:DOMHasChildNode()

			oXml:DOMChildNode()

			Do While AllwaysTrue()

				If oXml:cPath == '/load/filter['+ AllTrim( cValToChar( nX ) ) + ']'

					aAttNode   := oXML:DOMGetAttArray()
					aChildNode := oXML:DOMGetChildArray()

					If Len( aAttNode ) == 0 .And.; // 001
					Len( aChildNode ) == 1 .And.;
					aScan( aChildNode, { | X | X[ 1 ] == 'expression' .And. .Not. Empty( X[ 2 ] ) } ) # 0

						ConOut( oXml:cPath + ' 001')

					ElseIf Len( aAttNode ) == 1 .And.; //002
					aScan( aAttNode, { | X | X[ 1 ] == 'field' .And. AllTrim( GetSx3Cache( X[ 2 ], 'X3_CAMPO' ) ) == X[ 2 ] } ) # 0 .And.;
					Len( aChildNode ) == 1 .And.;
					aScan( aChildNode, { | X | X[ 1 ] == 'value' .And. .Not. Empty( X[ 2 ] ) } ) # 0

						ConOut( oXml:cPath + ' 002')

					ElseIf Len( aAttNode ) == 2 .And.; //003
					aScan( aAttNode, { | X | X[ 1 ] == 'field' .And. AllTrim( GetSx3Cache( X[ 2 ], 'X3_CAMPO' ) ) == X[ 2 ] } ) # 0 .And.;
					aScan( aAttNode, { | X | X[ 1 ] == 'relation' .And. AllTrim( X[ 2 ] ) $ 'EQUAL/NOT_EQUAL/LESS/LESS_EQUAL/GREATER/GREATER_EQUAL/CONTAINS/NOT_CONTAINS' } ) # 0 .And.;
					Len( aChildNode ) == 1 .And.;
					aScan( aChildNode, { | X | X[ 1 ] == 'value' .And. .Not. Empty( X[ 2 ] ) } ) # 0

						ConOut( oXml:cPath + ' 003')

					ElseIf 	Len( aAttNode ) == 3 .And.; //004
					aScan( aAttNode, { | X | X[ 1 ] == 'field' .And. AllTrim( GetSx3Cache( X[ 2 ], 'X3_CAMPO' ) ) == X[ 2 ] } ) # 0 .And.;
					aScan( aAttNode, { | X | X[ 1 ] == 'relation' .And. AllTrim( X[ 2 ] ) $ 'EQUAL/NOT_EQUAL/LESS/LESS_EQUAL/GREATER/GREATER_EQUAL/CONTAINS/NOT_CONTAINS' } ) # 0 .And.;
					aScan( aAttNode, { | X | X[ 1 ] == 'operator' .And. AllTrim( X[ 2 ] ) $ 'AND/OR' } ) # 0 .And.;
					Len( aChildNode ) == 1 .And.;
					aScan( aChildNode, { | X | X[ 1 ] == 'value' .And. .Not. Empty( X[ 2 ] ) } ) # 0

						ConOut( oXml:cPath + ' 004')

					ElseIf Len( aAttNode ) == 2 .And.; //005
					aScan( aAttNode, { | X | X[ 1 ] == 'field' .And. AllTrim( GetSx3Cache( X[ 2 ], 'X3_CAMPO' ) ) == X[ 2 ] } ) # 0 .And.;
					aScan( aAttNode, { | X | X[ 1 ] == 'relation' .And. AllTrim( X[ 2 ] ) $ 'IS_CONTAINED/IS_NOT_CONTAINED' } ) # 0 .And.;
					Len( aChildNode ) >= 1 .And.;
					.Not. aScan( aChildNode, { | X | X[ 1 ] != 'value' .Or. Empty( X[ 2 ] ) } ) # 0

						ConOut( oXml:cPath + ' 005')

					ElseIf 	Len( aAttNode ) == 3 .And.; //006
					aScan( aAttNode, { | X | X[ 1 ] == 'field' .And. AllTrim( GetSx3Cache( X[ 2 ], 'X3_CAMPO' ) ) == X[ 2 ] } ) # 0 .And.;
					aScan( aAttNode, { | X | X[ 1 ] == 'relation' .And. AllTrim( X[ 2 ] ) $ 'IS_CONTAINED/IS_NOT_CONTAINED' } ) # 0 .And.;
					aScan( aAttNode, { | X | X[ 1 ] == 'operator' .And. AllTrim( X[ 2 ] ) $ 'AND/OR' } ) # 0 .And.;
					Len( aChildNode ) >= 1 .And.;
					.Not. aScan( aChildNode, { | X | X[ 1 ] != 'value' .Or. Empty( X[ 2 ] ) } ) # 0

						ConOut( oXml:cPath + ' 006')

					Else

						ConOut( oXml:cPath + ' ???')

					End If

					//oModel:GetModel( 'SRA_GRID' ):SetLoadFilter()

					VarInfo( 'aAttNode'  , aAttNode  , ,.F.)
					VarInfo( 'aChildNode', aChildNode, ,.F.)

					oXml:DOMNextNode()

					nX++

				Else

					Exit

				End IF

			End Do

		End If

	End If

	RestArea( aArea )

Return cRet