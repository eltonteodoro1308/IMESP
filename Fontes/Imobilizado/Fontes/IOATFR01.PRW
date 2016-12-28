#INCLUDE 'TOTVS.CH'
Static nSaldo := 0
/*/{Protheus.doc} IOATFR01
Relatório com saldos de aquisição, entrada e saída por transfência
e baixas da conta de ativo imobilizado e sua conta de deprecição correspondente
e tembém os grupos de bens vinculadas a conta de Ativo imobilizado.
Seção 1 - Saldo de Balanço da conta de Ativo Imobilizado.
Seção 2 - Grupos de Bens que compõem a conta de Ativo Imobilizado.
Seção 3 - Saldos de Aquisição, Entrada, Saída e Baixas da Conta de Ativo Imobilizado.
Seção 4 - Saldo de Balanço da conta de Depreciação/Amortização correspondente ao Ativo Imobilizado.
Seção 5 - Saldos de Aquisição, Entrada, Saída e Baixas da da conta de Depreciação/Amortização correspondente ao Ativo Imobilizado.
@author Elton Teodoro Alves
@since 27/12/2016
@version 12.1.7
/*/
User Function IOATFR01()

	local oReport := ReportDef()

	oReport:printDialog()

Return
/*/{Protheus.doc} ReportDef
Função que monta o objeto TReport
@author Elton Teodoro Alves
@since 27/12/2016
@version 12.1.007
@return Objeto, Objeto do Relatório
/*/
Static Function ReportDef()

	Local oReport    := Nil
	Local oSection1  := Nil
	Local oSection2  := Nil
	Local oSection3  := Nil
	Local oSection4  := Nil
	Local oSection5  := Nil
	Local cAliasTRB1 := GetNextAlias()
	Local cAliasTRB3 := GetNextAlias()
	Local cAliasTRB4 := GetNextAlias()
	Local cAliasTRB5 := GetNextAlias()
	Local cPerg      := 'IOATFR01'

	Pergunte( cPerg, .F. )

	oReport := TReport():New( 'IOATFR01', 'Resumo Anual Por Conta', cPerg,;
	{ |oReport| PrintReport( oReport, cAliasTRB1, cAliasTRB3, cAliasTRB4, cAliasTRB5 ) },;
	'Imprime o Resumo Anual de uma Conta de Ativo Imobilizado e sua Conta de Depreciação correspondente' )

	// Section 001

	oSection1 := TRSection():New( oReport, 'Section1', cAliasTRB1 )

	TRCell():New( oSection1, 'CONTA' , cAliasTRB1, 'Conta' , '@!', 30  )
	TRCell():New( oSection1, 'DESCRICAO' , cAliasTRB1, 'Descrição' , '@!', 30 )
	TRCell():New( oSection1, 'SALDO_DE_BALANCO', cAliasTRB1, 'Saldo de Balanço', GetSx3Cache( 'CT2_VALOR', 'X3_PICTURE' ), 30,,,,,'RIGHT' )

	// Section 002

	oSection2 := TRSection():New( oReport, 'Section2', 'SNG' )

	TRCell():New( oSection2, 'GRUPO_BENS', 'SNG', 'Código dos Grupos', '@!', 50 )

	// Section 003

	oSection3 := TRSection():New( oReport, 'Section3', cAliasTRB3 )
	oSection3:SetTotalInLine(.F.)
	oSection3:SetTotalText('Total')

	TRCell():New( oSection3, 'MES', cAliasTRB3, 'MES', '@!', 40,,,,, 'CENTER' )
	oSection3:Cell('MES'):SetBorder( 'LEFT')

	TRCell():New( oSection3, 'ADICAO', cAliasTRB3, 'ADIÇÃO', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection3:Cell('ADICAO'):SetBorder( 'LEFT')
	TRFunction():New( oSection3:Cell('ADICAO'), '', 'SUM',, '', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection3, 'ENTRADAS', cAliasTRB3, 'ENTRADAS', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection3:Cell('ENTRADAS'):SetBorder( 'LEFT' )
	TRFunction():New( oSection3:Cell('ENTRADAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New( oSection3, 'SAIDAS', cAliasTRB3, 'SAÍDAS', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection3:Cell('SAIDAS'):SetBorder( 'LEFT')
	TRFunction():New( oSection3:Cell('SAIDAS'), '', 'SUM',, '', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection3, 'BAIXAS', cAliasTRB3, 'BAIXAS', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection3:Cell('BAIXAS'):SetBorder( 'LEFT')
	oSection3:Cell('BAIXAS'):SetBorder( 'RIGHT')
	TRFunction():New( oSection3:Cell('BAIXAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection3, 'TOTAL', cAliasTRB3, 'TOTAL DO CUSTO', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection3:Cell('TOTAL'):SetBorder( 'RIGHT')

	// Section 004

	oSection4 := TRSection():New( oReport, 'Section4', cAliasTRB4 )

	TRCell():New( oSection4, 'CONTA' , cAliasTRB4, 'Conta' , '@!', 30  )
	TRCell():New( oSection4, 'DESCRICAO' , cAliasTRB4, 'Descrição' , '@!', 30 )
	TRCell():New( oSection4, 'SALDO_DE_BALANCO', cAliasTRB4, 'Saldo de Balanço', GetSx3Cache( 'CT2_VALOR', 'X3_PICTURE' ), 30,,,,,'RIGHT' )

	// Section 005

	oSection5 := TRSection():New( oReport, 'Section5', cAliasTRB5 )
	oSection5:SetTotalInLine(.F.)
	oSection5:SetTotalText('Total')

	TRCell():New( oSection5, 'MES', cAliasTRB5, 'MES', '@!', 40,,,,, 'CENTER' )
	oSection5:Cell('MES'):SetBorder( 'LEFT')

	TRCell():New( oSection5, 'ADICAO', cAliasTRB5, 'ADIÇÃO', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection5:Cell('ADICAO'):SetBorder( 'LEFT')
	TRFunction():New( oSection5:Cell('ADICAO'), '', 'SUM',, '', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection5, 'ENTRADAS', cAliasTRB5, 'ENTRADAS', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection5:Cell('ENTRADAS'):SetBorder( 'LEFT' )
	TRFunction():New( oSection5:Cell('ENTRADAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New( oSection5, 'SAIDAS', cAliasTRB5, 'SAÍDAS'        , X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection5:Cell('SAIDAS'):SetBorder( 'LEFT')
	TRFunction():New( oSection5:Cell('SAIDAS'), '', 'SUM',, '', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection5, 'BAIXAS', cAliasTRB5, 'BAIXAS', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection5:Cell('BAIXAS'):SetBorder( 'LEFT')
	oSection5:Cell('BAIXAS'):SetBorder( 'RIGHT')
	TRFunction():New( oSection5:Cell('BAIXAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection5, 'TOTAL', cAliasTRB5, 'TOTAL DO CUSTO', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection5:Cell('TOTAL'):SetBorder( 'RIGHT')

Return oReport
/*/{Protheus.doc} PrintReport
Função Executada na impressão do Relatório
@author Elton Teodoro Alves
@since 27/12/2016
@version 12.1.007
@param oReport, object, Obejeto do Relatório
@param cAliasTRB1, Caracter, Alias da tabela da seção 1
@param cAliasTRB3, Caracter, Alias da tabela da seção 3
@param cAliasTRB4, Caracter, Alias da tabela da seção 4
@param cAliasTRB5, Caracter, Alias da tabela da seção 5
/*/
Static Function PrintReport( oReport, cAliasTRB1, cAliasTRB3, cAliasTRB4, cAliasTRB5 )

	Local oSection1 := oReport:Section( 1 )
	Local oSection2 := oReport:Section( 2 )
	Local oSection3 := oReport:Section( 3 )
	Local oSection4 := oReport:Section( 4 )
	Local oSection5 := oReport:Section( 5 )
	Local aArea     := GetArea()
	Local cConta    := 0

	// Section 001

	oSection1:Init()

	QuerySld1( cAliasTRB1 )

	( cAliasTRB1 )->( DbGoTop() )

	oSection1:Cell( 'CONTA' ):SetValue( Transform( ( cAliasTRB1 )->CONTA, '@R  ' + AllTrim( MV_PAR03 ) ) )
	oSection1:Cell( 'DESCRICAO' ):SetValue( ( cAliasTRB1 )->DESCRICAO )
	oSection1:Cell( 'SALDO_DE_BALANCO' ):SetValue( nSaldo := ( cAliasTRB1 )->SALDO_DE_BALANCO   )

	oSection1:PrintLine()

	cConta := ( cAliasTRB1 )->CONTA

	( cAliasTRB1 )->( DbCloseArea() )

	oSection1:Finish()

	// Section 002

	oSection2:Init()

	DbSelectArea('SNG')
	SNG->( DbSetOrder(3) )

	If DbSeek( xFilial('SNG') + cConta )

		Do While SNG->( !Eof() ) .And. xFilial('SNG') +  cConta == xFilial('SNG') + SNG->NG_CCONTAB

			oSection2:Cell( 'GRUPO_BENS' ):SetValue( SNG->NG_GRUPO + ' - ' + SNG->NG_DESCRIC )

			oSection2:PrintLine()

			SNG->( DbSkip() )

		End Do

	End If

	oSection2:Finish()

	// Section 003

	oSection3:Init()

	QuerySld3( cAliasTRB3 )

	( cAliasTRB3 )->( DbGoTop() )

	Do While ( cAliasTRB3 )->( ! Eof() )

		oSection3:Cell( 'MES'  ):SetValue( ( cAliasTRB3 )->MES )
		oSection3:Cell( 'MES'  ):SetAlign( 'CENTER' )

		oSection3:Cell( 'ADICAO'  ):SetValue( ( cAliasTRB3 )->ADICAO )
		oSection3:Cell( 'ADICAO'  ):SetAlign( 'RIGHT' )

		oSection3:Cell( 'ENTRADAS'  ):SetValue( ( cAliasTRB3 )->ENTRADAS )
		oSection3:Cell( 'ENTRADAS'  ):SetAlign( 'RIGHT' )

		oSection3:Cell( 'SAIDAS'  ):SetValue( ( cAliasTRB3 )->SAIDAS )
		oSection3:Cell( 'SAIDAS'  ):SetAlign( 'RIGHT' )

		oSection3:Cell( 'BAIXAS'  ):SetValue( ( cAliasTRB3 )->BAIXAS )
		oSection3:Cell( 'BAIXAS'  ):SetAlign( 'RIGHT' )

		oSection3:Cell( 'TOTAL'  ):SetValue( nSaldo += ( cAliasTRB3 )->( ADICAO + ENTRADAS - SAIDAS - BAIXAS ) )
		oSection3:Cell( 'TOTAL'  ):SetAlign( 'RIGHT' )

		oSection3:PrintLine()

		( cAliasTRB3 )->(dbSkip())

	End Do

	oSection3:Finish()

	oReport:EndPage( .T. )

	// Section 004

	oSection4:Init()

	QuerySld4( cAliasTRB4 )

	( cAliasTRB4 )->( DbGoTop() )

	oSection4:Cell( 'CONTA' ):SetValue( Transform( ( cAliasTRB4 )->CONTA, '@R  ' + AllTrim( MV_PAR03 ) ) )
	oSection4:Cell( 'DESCRICAO' ):SetValue( ( cAliasTRB4 )->DESCRICAO )
	oSection4:Cell( 'SALDO_DE_BALANCO' ):SetValue( nSaldo := ( cAliasTRB4 )->SALDO_DE_BALANCO )

	oSection4:PrintLine()

	cConta := ( cAliasTRB4 )->CONTA

	( cAliasTRB4 )->( DbCloseArea() )

	oSection4:Finish()

	// Section 005

	oSection5:Init()

	QuerySld5( cAliasTRB5 )

	( cAliasTRB5 )->( DbGoTop() )

	Do While ( cAliasTRB5 )->( ! Eof() )

		oSection5:Cell( 'MES'  ):SetValue( ( cAliasTRB5 )->MES )
		oSection5:Cell( 'MES'  ):SetAlign( 'CENTER' )

		oSection5:Cell( 'ADICAO'  ):SetValue( ( cAliasTRB5 )->ADICAO )
		oSection5:Cell( 'ADICAO'  ):SetAlign( 'RIGHT' )

		oSection5:Cell( 'ENTRADAS'  ):SetValue( ( cAliasTRB5 )->ENTRADAS )
		oSection5:Cell( 'ENTRADAS'  ):SetAlign( 'RIGHT' )

		oSection5:Cell( 'SAIDAS'  ):SetValue( ( cAliasTRB5 )->SAIDAS )
		oSection5:Cell( 'SAIDAS'  ):SetAlign( 'RIGHT' )

		oSection5:Cell( 'BAIXAS'  ):SetValue( ( cAliasTRB5 )->BAIXAS )
		oSection5:Cell( 'BAIXAS'  ):SetAlign( 'RIGHT' )

		oSection5:Cell( 'TOTAL'  ):SetValue( nSaldo += ( cAliasTRB5 )->( ADICAO + ENTRADAS - SAIDAS - BAIXAS ) )
		oSection5:Cell( 'TOTAL'  ):SetAlign( 'RIGHT' )

		oSection5:PrintLine()

		( cAliasTRB5 )->(dbSkip())

	End Do

	oSection5:Finish()

	RestArea( aArea )

Return
/*/{Protheus.doc} QuerySld1
Query com dados da Seção 1
@author Elton Teodoro Alves
@since 27/12/2016
@version 12.1.007
@param cAliasTRB, Caracter, Nome do Alias para o resultado da Query
/*/
Static Function QuerySld1( cAliasTRB )

	BeginSQL Alias cAliasTRB

	SELECT TOP 1 CT1.CT1_CONTA CONTA, CT1.CT1_DESC01 DESCRICAO, (

	SELECT SUM(VALOR) SALDO FROM(

	SELECT COALESCE(SUM(CT2_DEB.CT2_VALOR), 0) VALOR FROM %Table:CT2% CT2_DEB
	WHERE CT2_DEB.CT2_FILIAL = %XFilial:CT2%
	AND CT2_DEB.%NotDel%
	AND CT2_DEB.CT2_DEBITO = CT1.CT1_CONTA
	AND SUBSTRING(CT2_DEB.CT2_DATA, 1, 4) < %Exp:cValToChar(MV_PAR01)%

	UNION ALL

	SELECT -COALESCE(SUM(CT2_CRED.CT2_VALOR), 0) VALOR FROM %Table:CT2% CT2_CRED
	WHERE CT2_CRED.CT2_FILIAL = %XFilial:CT2%
	AND CT2_CRED.%NotDel%
	AND CT2_CRED.CT2_CREDIT = CT1.CT1_CONTA
	AND SUBSTRING(CT2_CRED.CT2_DATA, 1, 4) < %Exp:cValToChar(MV_PAR01)%

	) CT2_SALDO

	) SALDO_DE_BALANCO

	FROM %Table:CT1% CT1
	WHERE CT1.CT1_CONTA = %Exp:MV_PAR02%
	AND CT1.%NotDel%

	EndSQL

Return
/*/{Protheus.doc} QuerySld3
Query com dados da Seção 3
@author Elton Teodoro Alves
@since 27/12/2016
@version 12.1.007
@param cAliasTRB, Caracter, Nome do Alias para o resultado da Query
/*/
Static Function QuerySld3( cAliasTRB )

	Local cQuery := ''
	Local nX     := 0

	For nX := 1 To 12

		cQuery += "SELECT '" + PadL( nX, 2, '0' ) + "' MES, "

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0) "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_DEBITO = '" + AllTrim( MV_PAR02 ) + "' "
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + PadL( nX, 2, '0' ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR011" ) + ")) ADICAO, "

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0)  "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_DEBITO = '" + AllTrim( MV_PAR02 ) + "' "
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + PadL( nX, 2, '0' ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR012" ) + ")) ENTRADAS,"

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0) "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_CREDIT = '" + AllTrim( MV_PAR02 ) + "' "
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + PadL( nX, 2, '0' ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR013" ) + "))SAIDAS, "

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0) "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_CREDIT = '" + AllTrim( MV_PAR02 ) + "' "
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + PadL( nX, 2, '0' ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR014" ) + "))BAIXAS "

		If nX # 12

			cQuery += " UNION ALL "

		End If

	Next nX

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasTRB, .T., .T. )

Return
/*/{Protheus.doc} QuerySld4
Query com dados da Seção 4
@author Elton Teodoro Alves
@since 27/12/2016
@version 12.1.007
@param cAliasTRB, Caracter, Nome do Alias para o resultado da Query
/*/
Static Function QuerySld4( cAliasTRB )

	BeginSQL Alias cAliasTRB

	SELECT TOP 1 CT1.CT1_CONTA CONTA, CT1.CT1_DESC01 DESCRICAO, (

	SELECT SUM(VALOR) SALDO FROM(

	SELECT -COALESCE(SUM(CT2_DEB.CT2_VALOR), 0) VALOR FROM %Table:CT2% CT2_DEB
	WHERE CT2_DEB.CT2_FILIAL = %XFilial:CT2%
	AND CT2_DEB.%NotDel%
	AND CT2_DEB.CT2_DEBITO = CT1.CT1_CONTA
	AND SUBSTRING(CT2_DEB.CT2_DATA, 1, 4) < %Exp:cValToChar(MV_PAR01)%

	UNION ALL

	SELECT COALESCE(SUM(CT2_CRED.CT2_VALOR), 0) VALOR FROM %Table:CT2% CT2_CRED
	WHERE CT2_CRED.CT2_FILIAL = %XFilial:CT2%
	AND CT2_CRED.%NotDel%
	AND CT2_CRED.CT2_CREDIT = CT1.CT1_CONTA
	AND SUBSTRING(CT2_CRED.CT2_DATA, 1, 4) < %Exp:cValToChar(MV_PAR01)%

	) CT2_SALDO

	) SALDO_DE_BALANCO

	FROM %Table:CT1% CT1
	WHERE CT1.CT1_CONTA = (

	SELECT TOP 1 SNG.NG_CDEPREC
	FROM %Table:SNG% SNG
	WHERE SNG.NG_CCONTAB = %Exp:MV_PAR02%
	AND SNG.%NotDel%

	)

	AND CT1.%NotDel%

	EndSQL

Return
/*/{Protheus.doc} QuerySld5
Query com dados da Seção 5
@author Elton Teodoro Alves
@since 27/12/2016
@version 12.1.007
@param cAliasTRB, Caracter, Nome do Alias para o resultado da Query
/*/
Static Function QuerySld5( cAliasTRB )

	Local cQuery := ''
	Local nX     := 0

	For nX := 1 To 12

		cQuery += "SELECT '" + PadL( nX, 2, '0' ) + "' MES, "

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0) "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_CREDIT = "
		cQuery += "(SELECT TOP 1 SNG.NG_CDEPREC FROM " + RetSqlName( "SNG" ) + " SNG WHERE SNG.NG_CCONTAB = '" + AllTrim( MV_PAR02 ) + "')"
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + PadL( nX, 2, '0' ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR015" ) + ")) ADICAO, "

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0)  "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_CREDIT = "
		cQuery += "(SELECT TOP 1 SNG.NG_CDEPREC FROM " + RetSqlName( "SNG" ) + " SNG WHERE SNG.NG_CCONTAB = '" + AllTrim( MV_PAR02 ) + "')"
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + PadL( nX, 2, '0' ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR016" ) + ")) ENTRADAS,"

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0) "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_DEBITO = "
		cQuery += "(SELECT TOP 1 SNG.NG_CDEPREC FROM " + RetSqlName( "SNG" ) + " SNG WHERE SNG.NG_CCONTAB = '" + AllTrim( MV_PAR02 ) + "')"
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + PadL( nX, 2, '0' ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR017" ) + "))SAIDAS, "

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0) "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_DEBITO = "
		cQuery += "(SELECT TOP 1 SNG.NG_CDEPREC FROM " + RetSqlName( "SNG" ) + " SNG WHERE SNG.NG_CCONTAB = '" + AllTrim( MV_PAR02 ) + "')"
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + PadL( nX, 2, '0' ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR018" ) + "))BAIXAS "

		If nX # 12

			cQuery += " UNION ALL "

		End If

	Next nX

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasTRB, .T., .T. )

Return
/*/{Protheus.doc} ParamToIn
Função que monta a string para ser usada na clausula IN da query
@author Elton Teodoro Alves
@since 27/12/2016
@version 12.1.007
@param cParam, Caractere, Nome do Parâmetro
@return Caractere, Clausula IN da query
/*/
Static Function ParamToIn( cParam )

	Local cRet   := ''
	Local nX     := 0
	Local aParam := StrTokArr2( GetMv( cParam ), ',', .T. )

	For nX := 1 To Len( aParam )

		cRet += "'" + aParam[nX] + "'"

		If nX # Len( aParam )

			cRet += "'"

		End If

	Next nX

Return cRet