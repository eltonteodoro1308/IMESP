#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOGPEC01
User Function que através de XML recebido conforme schema faz busca do cadastro de funcionários
e retorna outro xml com resultado da consulta.
@author Elton Teodoro Alves
@since 07/03/2016
@version Protheus 12.1.7
@param cXml, characters, XML enviado com dados da consulta
@return cRet, characters
/*/
user function IOGPEC01( cXml )

	Local cRet     := ''
	Local oXml     := TXmlManager():New()
	Local aArea    := GetArea()
	Local aAreaSM0 := SM0->( GetArea() )
	Local cCase    := ''
	Local cQuery   := ''

	If oXml:Parse( cXML ) .And.;
	oXml:ParseSchemaFile('\schemas\IOGPEC01_REM.xsd') .And.;
	oXml:SchemaValidate()

		cCase += "CASE "

		Do While SM0->( ! Eof() ) .And. SM0->M0_CODIGO == cEmpAnt

			cCase += "WHEN SRA.RA_FILIAL = '" + SM0->M0_CODFIL + "' THEN '" + AllTrim( SM0->M0_FILIAL ) + "' "

			SM0->( DbSkip() )

		EndDo

		cCase += "ELSE '' "
		cCase += "END SM0_NOME, "

		SM0->( RestArea( aAreaSM0 ) )
		RestArea( aArea )

		cQuery := MakeQuery( cCase, cWhere, nNumRec, nPag )

		ConOut( cRet := cCase )

	Else

		ConOut( cRet := 'ERRO' )

	EndIf

return cRet

Static Function MakeQuery( cCase, cWhere, cOrder,nNumRecPag, nPagina )

	Local cQuery  := ""
	Local cPagIni := ""
	Local cPagFim := ""
	Local aCpos   := {}
	Local nX      := ""

	Default cWhere     := ""
	Default cOrder     := "SRA.RA_MAT"
	Default nNumRecPag := 0
	Default nPagina    := 0

	aAdd( aCpos, "RA_MAT, " )
	aAdd( aCpos, "RA_NOME, " )
	aAdd( aCpos, "RA_NOMECMP, " )
	aAdd( aCpos, "RA_APELIDO, " )
	aAdd( aCpos, "RA_CARGO," )
	aAdd( aCpos, cCase )//M0_FILIAL
	aAdd( aCpos, "RA_XRAMAL='', " )
	aAdd( aCpos, "RA_XRAMAL2='', " )
	aAdd( aCpos, "RA_XRAMAL3='', " )
	aAdd( aCpos, "RA_DEPTO, " )
	aAdd( aCpos, "COALESCE( SQB.QB_DESCRIC, '' ) QB_DESCRIC, " )
	aAdd( aCpos, "RA_DEMISSA, "
	aAdd( aCpos, "COALESCE( SQ3.Q3_CLASSE, '' ) Q3_CLASSE " )
	aAdd( aCpos, "RA_NASC, " )
	aAdd( aCpos, "RA_FILIAL, " )
	aAdd( aCpos, "RA_SITFOLH, " )
	aAdd( aCpos, "RA_EMAIL, " )
	aAdd( aCpos, "RA_CIC, " )
	aAdd( aCpos, "RA_XSIGLA='', " )
	aAdd( aCpos, "RA_XLOGIN='' " )

	cQuery += "WITH PAGINA_SRA AS( "
	cQuery += "SELECT "
	cQuery += "ROW_NUMBER = ROW_NUMBER() OVER ( ORDER BY " + cOrder + " ), "

	For nX := 1 To Len( aCpos )

		cQuery += aCpos[ nX ]

	Next nX

	cQuery += "FROM " + RetSqlName( "SRA" ) + " SRA "
	cQuery += "LEFT JOIN " + RetSqlName( "SQB" ) + " SQB ON SRA.RA_DEPTO = SQB.QB_DEPTO "
	cQuery += "LEFT JOIN " + RetSqlName( "SQ3" ) + " SQ3 ON SRA.RA_CARGO = SQ3.Q3_CARGO "
	cQuery += "WHERE SRA.RA_FILIAL = '" + xFilial( "SRA" ) + "' "
	cQuery += "AND SRA.D_E_L_E_T_ = ' ' "
	cQuery += cWhere
	cQuery += ")SELECT * FROM PAGINA_SRA "
	cQuery += "WHERE ROW_NUMBER BETWEEN " + cPagIni + " AND " + cPagFi

	cQuery += "UNION ALL"

	cQuery += "SELECT COUNT(*) " + Replicate( ",''", Len( aCpos ) ) + " FROM " + RetSqlName( "SRA" ) + " SRA "
	cQuery += "WHERE SRA.RA_FILIAL = '" + xFilial( "SRA" ) + "' "
	cQuery += "AND SRA.D_E_L_E_T_ = ' ' "
	cQuery += cWhere

Return cQuery