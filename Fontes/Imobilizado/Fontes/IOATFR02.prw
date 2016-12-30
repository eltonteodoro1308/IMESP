#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOATFR01
Relatório com resumo do saldos de aquisição, entrada e saída por transfência
e baixas da conta de ativo imobilizado intangível, diferido e amortização.
Seção 1 - Custo Contas Ativo Diferido
Seção 2 - Amortização Contas Ativo Diferido
Seção 3 - Total líquido do Diferido
Seção 4 - Custo Contas do Intangível
Seção 5 - Amortizaçao Contas do Intangível
Seção 6 - Total líquido Intangível
@author Elton Teodoro Alves
@since 27/12/2016
@version 12.1.7
/*/
User Function IOATFR02()

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

	Local oReport     := Nil
	Local oSection1   := Nil
	Local oSection2   := Nil
	Local oSection3   := Nil
	Local oSection4   := Nil
	Local oSection5   := Nil
	Local oSection6   := Nil
	Local aCtasCusto  := {}
	Local aCtasAmort  := {}
	Local cAliasTRB1  := GetNextAlias()
	Local cAliasTRB2  := GetNextAlias()
	Local cPerg       := 'IOATFR02'

	Pergunte( cPerg, .F. )

	aAdd( aCtasCusto, GetMv( 'IO_XGRDI1' ) ) // Custo Ativo Diferido
	aAdd( aCtasCusto, GetMv( 'IO_XGRCU1' ) ) // Custo Ativo Intangível
	aAdd( aCtasCusto, GetMv( 'IO_XGRCU2' ) ) // Custo Ativo Intangível
	aAdd( aCtasCusto, GetMv( 'IO_XGRCU3' ) ) // Custo Ativo Intangível
	aAdd( aCtasCusto, GetMv( 'IO_XGRCU4' ) ) // Custo Ativo Intangível
	aAdd( aCtasCusto, GetMv( 'IO_XGRCU5' ) ) // Custo Ativo Intangível
	aAdd( aCtasCusto, GetMv( 'IO_XGRCU6' ) ) // Custo Ativo Intangível

	aAdd( aCtasAmort, GetMv( 'IO_XGRAM1' ) ) // Depreciação Diferido
	aAdd( aCtasAmort, GetMv( 'IO_XGRCA1' ) ) // Depreciação Ativo Intangível
	aAdd( aCtasAmort, GetMv( 'IO_XGRCA2' ) ) // Depreciação Ativo Intangível
	aAdd( aCtasAmort, GetMv( 'IO_XGRCA3' ) ) // Depreciação Ativo Intangível

	oReport := TReport():New( 'IOATFR02', 'Deprecição Por Conta', cPerg,;
	{ |oReport| PrintReport( oReport, cAliasTRB1, cAliasTRB2, aCtasCusto, aCtasAmort ) },;
	'Imprime a Depreciação Por Conta de Ativo Imobilizado e sua Conta de Depreciação correspondente' )

	// Section 001

	oSection1 := TRSection():New( oReport, 'Section1', cAliasTRB1 )
	oSection1:SetTotalInLine(.F.)
	oSection1:SetTotalText('TOTAL DO CUSTO DO DIFERIDO ')

	TRCell():New( oSection1, 'CUSTO_CONTAS_DO_DIFERIDO', cAliasTRB1, 'CUSTO CONTAS DO DIFERIDO', '@!', 40,,,,, 'LEFT' )
	oSection1:Cell('CUSTO_CONTAS_DO_DIFERIDO'):SetBorder( 'LEFT')

	TRCell():New( oSection1, 'SALDO_DE_BALANCO', cAliasTRB1, 'SALDO DE BALANCO', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection1:Cell('SALDO_DE_BALANCO'):SetBorder( 'LEFT')
	TRFunction():New( oSection1:Cell('SALDO_DE_BALANCO'), '', 'SUM',, '', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection1, 'ADICAO', cAliasTRB1, 'ADICAO', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection1:Cell('ADICAO'):SetBorder( 'LEFT' )
	TRFunction():New( oSection1:Cell('ADICAO'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New( oSection1, 'ENTRADAS', cAliasTRB1, 'ENTRADAS', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection1:Cell('ENTRADAS'):SetBorder( 'LEFT' )
	TRFunction():New( oSection1:Cell('ENTRADAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New( oSection1, 'SAIDAS', cAliasTRB1, 'SAÍDAS', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection1:Cell('SAIDAS'):SetBorder( 'LEFT')
	TRFunction():New( oSection1:Cell('SAIDAS'), '', 'SUM',, '', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection1, 'BAIXAS', cAliasTRB1, 'BAIXAS', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection1:Cell('BAIXAS'):SetBorder( 'LEFT')
	oSection1:Cell('BAIXAS'):SetBorder( 'RIGHT')
	TRFunction():New( oSection1:Cell('BAIXAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection1, 'SALDO_ATUAL', cAliasTRB1, 'SALDO ATUAL', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection1:Cell('SALDO_ATUAL'):SetBorder( 'RIGHT')
	TRFunction():New( oSection1:Cell('SALDO_ATUAL'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	// Section 002

	oSection2 := TRSection():New( oReport, 'Section2', cAliasTRB2 )
	oSection2:SetTotalInLine(.F.)
	oSection2:SetTotalText('TOTAL DA AMORTIZACAO DIFERIDO ')

	TRCell():New( oSection2, 'AMORTIZACAO_CONTAS_DO_DIFERIDO', cAliasTRB2, 'AMORTIZACAO CONTAS DO DIFERIDO', '@!', 40,,,,, 'LEFT' )
	oSection2:Cell('AMORTIZACAO_CONTAS_DO_DIFERIDO'):SetBorder( 'LEFT')

	TRCell():New( oSection2, 'SALDO_DE_BALANCO', cAliasTRB2, 'SALDO DE BALANCO', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection2:Cell('SALDO_DE_BALANCO'):SetBorder( 'LEFT')
	TRFunction():New( oSection2:Cell('SALDO_DE_BALANCO'), '', 'SUM',, '', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection2, 'ADICAO', cAliasTRB2, 'ADICAO', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection2:Cell('ADICAO'):SetBorder( 'LEFT' )
	TRFunction():New( oSection2:Cell('ADICAO'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New( oSection2, 'ENTRADAS', cAliasTRB2, 'ENTRADAS', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection2:Cell('ENTRADAS'):SetBorder( 'LEFT' )
	TRFunction():New( oSection2:Cell('ENTRADAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New( oSection2, 'SAIDAS', cAliasTRB2, 'SAÍDAS', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection2:Cell('SAIDAS'):SetBorder( 'LEFT')
	TRFunction():New( oSection2:Cell('SAIDAS'), '', 'SUM',, '', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection2, 'BAIXAS', cAliasTRB2, 'BAIXAS', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection2:Cell('BAIXAS'):SetBorder( 'LEFT')
	oSection2:Cell('BAIXAS'):SetBorder( 'RIGHT')
	TRFunction():New( oSection2:Cell('BAIXAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection2, 'SALDO_ATUAL', cAliasTRB2, 'SALDO ATUAL', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection2:Cell('SALDO_ATUAL'):SetBorder( 'RIGHT')
	TRFunction():New( oSection2:Cell('SALDO_ATUAL'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	// Section 003

	oSection3 := TRSection():New( oReport, 'Section3', '' )

	TRCell():New( oSection3, 'TOTAL_LIQUIDO_DO_DIFERIDO', '', '', '@!', 40,,,,, 'LEFT' )
	oSection3:Cell('TOTAL_LIQUIDO_DO_DIFERIDO'):SetBorder( 'LEFT')

	TRCell():New( oSection3, 'SALDO_DE_BALANCO', '', '', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection3:Cell('SALDO_DE_BALANCO'):SetBorder( 'LEFT')

	TRCell():New( oSection3, 'ADICAO', '', '', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection3:Cell('ADICAO'):SetBorder( 'LEFT' )

	TRCell():New( oSection3, 'ENTRADAS', '', '', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection3:Cell('ENTRADAS'):SetBorder( 'LEFT' )

	TRCell():New( oSection3, 'SAIDAS', '', '', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection3:Cell('SAIDAS'):SetBorder( 'LEFT')

	TRCell():New( oSection3, 'BAIXAS', '', '', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection3:Cell('BAIXAS'):SetBorder( 'LEFT')
	oSection3:Cell('BAIXAS'):SetBorder( 'RIGHT')

	TRCell():New( oSection3, 'SALDO_ATUAL', '', '', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection3:Cell('SALDO_ATUAL'):SetBorder( 'RIGHT')

	// Section 004

	oSection4 := TRSection():New( oReport, 'Section4', cAliasTRB1 )
	oSection4:SetTotalInLine(.F.)
	oSection4:SetTotalText('TOTAL DO CUSTO DO INTANGIVEL')

	TRCell():New( oSection4, 'CUSTO_CONTAS_DO_INTANGIVEL', cAliasTRB1, 'CUSTO CONTAS DO INTANGIVEL', '@!', 40,,,,, 'LEFT' )
	oSection4:Cell('CUSTO_CONTAS_DO_INTANGIVEL'):SetBorder( 'LEFT')

	TRCell():New( oSection4, 'SALDO_DE_BALANCO', cAliasTRB1, 'SALDO DE BALANCO', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection4:Cell('SALDO_DE_BALANCO'):SetBorder( 'LEFT')
	TRFunction():New( oSection4:Cell('SALDO_DE_BALANCO'), '', 'SUM',, '', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection4, 'ADICAO', cAliasTRB1, 'ADICAO', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection4:Cell('ADICAO'):SetBorder( 'LEFT' )
	TRFunction():New( oSection4:Cell('ADICAO'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New( oSection4, 'ENTRADAS', cAliasTRB1, 'ENTRADAS', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection4:Cell('ENTRADAS'):SetBorder( 'LEFT' )
	TRFunction():New( oSection4:Cell('ENTRADAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New( oSection4, 'SAIDAS', cAliasTRB1, 'SAÍDAS', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection4:Cell('SAIDAS'):SetBorder( 'LEFT')
	TRFunction():New( oSection4:Cell('SAIDAS'), '', 'SUM',, '', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection4, 'BAIXAS', cAliasTRB1, 'BAIXAS', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection4:Cell('BAIXAS'):SetBorder( 'LEFT')
	oSection4:Cell('BAIXAS'):SetBorder( 'RIGHT')
	TRFunction():New( oSection4:Cell('BAIXAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection4, 'SALDO_ATUAL', cAliasTRB1, 'SALDO ATUAL', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection4:Cell('SALDO_ATUAL'):SetBorder( 'RIGHT')
	TRFunction():New( oSection4:Cell('SALDO_ATUAL'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	// Section 005

	oSection5 := TRSection():New( oReport, 'Section5', cAliasTRB2 )
	oSection5:SetTotalInLine(.F.)
	oSection5:SetTotalText('TOTAL DA AMORTIZACAO INTANGÍVEL ')

	TRCell():New( oSection5, 'AMORTIZACAO_CONTAS_DO_INTANGIVEL', cAliasTRB2, 'AMORTIZACAO CONTAS DO INTANGIVEL', '@!', 40,,,,, 'LEFT' )
	oSection5:Cell('AMORTIZACAO_CONTAS_DO_INTANGIVEL'):SetBorder( 'LEFT')

	TRCell():New( oSection5, 'SALDO_DE_BALANCO', cAliasTRB2, 'SALDO DE BALANCO', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection5:Cell('SALDO_DE_BALANCO'):SetBorder( 'LEFT')
	TRFunction():New( oSection5:Cell('SALDO_DE_BALANCO'), '', 'SUM',, '', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection5, 'ADICAO', cAliasTRB2, 'ADICAO', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection5:Cell('ADICAO'):SetBorder( 'LEFT' )
	TRFunction():New( oSection5:Cell('ADICAO'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New( oSection5, 'ENTRADAS', cAliasTRB2, 'ENTRADAS', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection5:Cell('ENTRADAS'):SetBorder( 'LEFT' )
	TRFunction():New( oSection5:Cell('ENTRADAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New( oSection5, 'SAIDAS', cAliasTRB2, 'SAÍDAS', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection5:Cell('SAIDAS'):SetBorder( 'LEFT')
	TRFunction():New( oSection5:Cell('SAIDAS'), '', 'SUM',, '', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection5, 'BAIXAS', cAliasTRB2, 'BAIXAS', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection5:Cell('BAIXAS'):SetBorder( 'LEFT')
	oSection5:Cell('BAIXAS'):SetBorder( 'RIGHT')
	TRFunction():New( oSection5:Cell('BAIXAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	TRCell():New( oSection5, 'SALDO_ATUAL', cAliasTRB2, 'SALDO ATUAL', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection5:Cell('SALDO_ATUAL'):SetBorder( 'RIGHT')
	TRFunction():New( oSection5:Cell('SALDO_ATUAL'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),, .T., .F., .F. )

	// Section 006

	oSection6 := TRSection():New( oReport, 'Section6', '' )

	TRCell():New( oSection6, 'TOTAL_AMORTIZACAO_CONTAS_DO_INTANGIVEL', '', '', '@!', 40,,,,, 'LEFT' )
	oSection6:Cell('TOTAL_AMORTIZACAO_CONTAS_DO_INTANGIVEL'):SetBorder( 'LEFT')

	TRCell():New( oSection6, 'SALDO_DE_BALANCO', '', '', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection6:Cell('SALDO_DE_BALANCO'):SetBorder( 'LEFT')

	TRCell():New( oSection6, 'ADICAO', '', '', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection6:Cell('ADICAO'):SetBorder( 'LEFT' )

	TRCell():New( oSection6, 'ENTRADAS', '', '', X3Picture( 'CT2_VALOR'  ), 40,,,,, 'RIGHT' )
	oSection6:Cell('ENTRADAS'):SetBorder( 'LEFT' )

	TRCell():New( oSection6, 'SAIDAS', '', '', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection6:Cell('SAIDAS'):SetBorder( 'LEFT')

	TRCell():New( oSection6, 'BAIXAS', '', '', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection6:Cell('BAIXAS'):SetBorder( 'LEFT')
	oSection6:Cell('BAIXAS'):SetBorder( 'RIGHT')

	TRCell():New( oSection6, 'SALDO_ATUAL', '', '', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection6:Cell('SALDO_ATUAL'):SetBorder( 'RIGHT')


Return oReport
/*/{Protheus.doc} PrintReport
Função Executada na impressão do Relatório
@author Elton Teodoro Alves
@since 27/12/2016
@version 12.1.007
@param oReport, object, Obejeto do Relatório
@param cAliasTRB1, Caracter, Alias da tabela da utilizada pelas secoes 1 e 4
@param cAliasTRB2, Caracter, Alias da tabela da utilizada pelas secoes 2 e 5
@param aCtasCusto, Array, Array com as contas de custo de ativo definido no parâmetros
@param aCtasAmort, Array, Array com as contas de amortizacao de ativo definido no parâmetros
/*/
Static Function PrintReport( oReport, cAliasTRB1, cAliasTRB2, aCtasCusto, aCtasAmort )

	Local aTotal1    := { 0, 0, 0, 0, 0, 0 }
	Local aTotal2    := { 0, 0, 0, 0, 0, 0 }
	Local aArea     := GetArea()
	Local oSection1 := oReport:Section( 'Section1' )
	Local oSection2 := oReport:Section( 'Section2' )
	Local oSection3 := oReport:Section( 'Section3' )
	Local oSection4 := oReport:Section( 'Section4' )
	Local oSection5 := oReport:Section( 'Section5' )
	Local oSection6 := oReport:Section( 'Section6' )


	QuerySld1( aCtasCusto, cAliasTRB1 )
	QuerySld2( aCtasAmort, cAliasTRB2 )

	( cAliasTRB1 )->( DbGoTop() )
	( cAliasTRB2 )->( DbGoTop() )

	// Section 001

	oSection1:Init()

	Do While ( cAliasTRB1 )->( ! Eof() )

		If AllTrim( ( cAliasTRB1 )->CONTA ) == aCtasCusto[1]

			oSection1:Cell('CUSTO_CONTAS_DO_DIFERIDO'):SetValue( ( cAliasTRB1 )->DESCRICAO )
			oSection1:Cell('SALDO_DE_BALANCO'):SetValue( aTotal1[1] += ( cAliasTRB1 )->SALDO_DE_BALANCO )
			oSection1:Cell('ADICAO'):SetValue( aTotal1[2] += ( cAliasTRB1 )->ADICAO )
			oSection1:Cell('ENTRADAS'):SetValue( aTotal1[3] += ( cAliasTRB1 )->ENTRADAS )
			oSection1:Cell('SAIDAS'):SetValue( aTotal1[4] += ( cAliasTRB1 )->SAIDAS )
			oSection1:Cell('BAIXAS'):SetValue( aTotal1[5] += ( cAliasTRB1 )->BAIXAS )
			oSection1:Cell('SALDO_ATUAL'):SetValue( aTotal1[6] += ( cAliasTRB1 )->( SALDO_DE_BALANCO + ADICAO + ENTRADAS - SAIDAS - BAIXAS ) )

			oSection1:PrintLine()

		End If

		( cAliasTRB1 )->( DbSkip() )

	End Do

	oSection1:Finish()

	// Section 002

	oSection2:Init()

	Do While ( cAliasTRB2 )->( ! Eof() )

		If AllTrim( ( cAliasTRB2 )->CONTA ) == aCtasAmort[1]

			oSection2:Cell('AMORTIZACAO_CONTAS_DO_DIFERIDO'):SetValue( ( cAliasTRB2 )->DESCRICAO )
			oSection2:Cell('SALDO_DE_BALANCO'):SetValue( aTotal1[1] -= ( cAliasTRB2 )->SALDO_DE_BALANCO )
			oSection2:Cell('ADICAO'):SetValue( aTotal1[2] -= ( cAliasTRB2 )->ADICAO )
			oSection2:Cell('ENTRADAS'):SetValue( aTotal1[3] -= ( cAliasTRB2 )->ENTRADAS )
			oSection2:Cell('SAIDAS'):SetValue( aTotal1[4] -= ( cAliasTRB2 )->SAIDAS )
			oSection2:Cell('BAIXAS'):SetValue( aTotal1[5] -= ( cAliasTRB2 )->BAIXAS )
			oSection2:Cell('SALDO_ATUAL'):SetValue( aTotal1[6] -= ( cAliasTRB2 )->( SALDO_DE_BALANCO + ADICAO + ENTRADAS - SAIDAS - BAIXAS ) )

			oSection2:PrintLine()

		End If

		( cAliasTRB2 )->( DbSkip() )

	End If


	oSection2:Finish()

	// Section 003

	oSection3:Init()

	oSection3:Cell('TOTAL_LIQUIDO_DO_DIFERIDO'):SetValue( 'TOTAL LIQUIDO DO DIFERIDO')
	oSection3:Cell('SALDO_DE_BALANCO'):SetValue( aTotal1[1] )
	oSection3:Cell('ADICAO'):SetValue( aTotal1[2] )
	oSection3:Cell('ENTRADAS'):SetValue( aTotal1[3] )
	oSection3:Cell('SAIDAS'):SetValue( aTotal1[4] )
	oSection3:Cell('BAIXAS'):SetValue( aTotal1[5] )
	oSection3:Cell('SALDO_ATUAL'):SetValue( aTotal1[6] )

	oSection3:PrintLine()

	oSection3:Finish()

	( cAliasTRB1 )->( DbGoTop() )
	( cAliasTRB2 )->( DbGoTop() )

	// Section 004

	oSection4:Init()

	Do While ( cAliasTRB1 )->( ! Eof() )

		If AllTrim( ( cAliasTRB1 )->CONTA ) # aCtasCusto[1]

			oSection4:Cell('CUSTO_CONTAS_DO_INTANGIVEL'):SetValue( ( cAliasTRB1 )->DESCRICAO )
			oSection4:Cell('SALDO_DE_BALANCO'):SetValue( aTotal2[1] += ( cAliasTRB1 )->SALDO_DE_BALANCO )
			oSection4:Cell('ADICAO'):SetValue( aTotal2[2] += ( cAliasTRB1 )->ADICAO )
			oSection4:Cell('ENTRADAS'):SetValue( aTotal2[3] += ( cAliasTRB1 )->ENTRADAS )
			oSection4:Cell('SAIDAS'):SetValue( aTotal2[4] += ( cAliasTRB1 )->SAIDAS )
			oSection4:Cell('BAIXAS'):SetValue( aTotal2[5] += ( cAliasTRB1 )->BAIXAS )
			oSection4:Cell('SALDO_ATUAL'):SetValue( aTotal2[6] += ( cAliasTRB1 )->( SALDO_DE_BALANCO + ADICAO + ENTRADAS - SAIDAS - BAIXAS ) )

			oSection4:PrintLine()

		End If

		( cAliasTRB1 )->( DbSkip() )

	End Do

	oSection4:Finish()

	// Section 005

	oSection5:Init()

	Do While ( cAliasTRB2 )->( ! Eof() )

		If AllTrim( ( cAliasTRB2 )->CONTA ) # aCtasAmort[1]

			oSection5:Cell('AMORTIZACAO_CONTAS_DO_INTANGIVEL'):SetValue( ( cAliasTRB2 )->DESCRICAO )
			oSection5:Cell('SALDO_DE_BALANCO'):SetValue( aTotal2[1] -= ( cAliasTRB2 )->SALDO_DE_BALANCO )
			oSection5:Cell('ADICAO'):SetValue( aTotal2[2] -= ( cAliasTRB2 )->ADICAO )
			oSection5:Cell('ENTRADAS'):SetValue( aTotal2[3] -= ( cAliasTRB2 )->ENTRADAS )
			oSection5:Cell('SAIDAS'):SetValue( aTotal2[4] -= ( cAliasTRB2 )->SAIDAS )
			oSection5:Cell('BAIXAS'):SetValue( aTotal2[5] -= ( cAliasTRB2 )->BAIXAS )
			oSection5:Cell('SALDO_ATUAL'):SetValue( aTotal2[6] -= ( cAliasTRB2 )->( SALDO_DE_BALANCO + ADICAO + ENTRADAS - SAIDAS - BAIXAS ) )

			oSection5:PrintLine()

		End If

		( cAliasTRB2 )->( DbSkip() )

	End If

	oSection5:Finish()

	// Section 006

	oSection6:Init()

	oSection6:Cell('TOTAL_AMORTIZACAO_CONTAS_DO_INTANGIVEL'):SetValue( 'TOTAL LIQUIDO DO DIFERIDO')
	oSection6:Cell('SALDO_DE_BALANCO'):SetValue( aTotal2[1] )
	oSection6:Cell('ADICAO'):SetValue( aTotal2[2] )
	oSection6:Cell('ENTRADAS'):SetValue( aTotal2[3] )
	oSection6:Cell('SAIDAS'):SetValue( aTotal2[4] )
	oSection6:Cell('BAIXAS'):SetValue( aTotal2[5] )
	oSection6:Cell('SALDO_ATUAL'):SetValue( aTotal2[6] )

	oSection6:PrintLine()


	oSection6:Finish()

	( cAliasTRB1 )->( DbCloseArea() )
	( cAliasTRB2 )->( DbCloseArea() )

	RestArea( aArea )

Return
/*/{Protheus.doc} QuerySld1
Query com dados da Seção 1 e 4
@author Elton Teodoro Alves
@since 27/12/2016
@version 12.1.007
@param aCtasCusto, Array, Array com as contas de custo de ativo definido no parâmetros
@param cAliasTRB, Caracter, Nome do Alias para o resultado da Query
/*/
Static Function QuerySld1( aCtasCusto, cAliasTRB )

	Local cQuery    := ''
	Local nX        := 1

	For nX := 1 To Len( aCtasCusto )

		cQuery += "SELECT TOP 1 CT1.CT1_CONTA CONTA, CT1.CT1_DESC01 DESCRICAO, "

		cQuery += "(SELECT SUM(VALOR) SALDO FROM( "

		cQuery += "SELECT COALESCE(SUM(CT2_DEB.CT2_VALOR), 0) VALOR FROM " + RetSqlName( "CT2" ) + " CT2_DEB "
		cQuery += "WHERE CT2_DEB.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2_DEB.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2_DEB.CT2_DEBITO = CT1.CT1_CONTA "
		cQuery += "AND SUBSTRING(CT2_DEB.CT2_DATA, 1, 6) < '" + AllTrim( MV_PAR01 ) + "' "

		cQuery += "UNION ALL "

		cQuery += "SELECT -COALESCE(SUM(CT2_CRED.CT2_VALOR), 0) VALOR FROM " + RetSqlName( "CT2" ) + " CT2_CRED "
		cQuery += "WHERE CT2_CRED.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2_CRED.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2_CRED.CT2_CREDIT = CT1.CT1_CONTA "
		cQuery += "AND SUBSTRING(CT2_CRED.CT2_DATA, 1, 6) < '" + AllTrim( MV_PAR01 ) + "' "

		cQuery += ") CT2_SALDO "

		cQuery += ") SALDO_DE_BALANCO, "

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0) "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_DEBITO = CT1.CT1_CONTA "
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR011" ) + ")) ADICAO, "

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0)  "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_DEBITO = CT1.CT1_CONTA "
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR012" ) + ")) ENTRADAS,"

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0) "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_CREDIT = CT1.CT1_CONTA "
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR013" ) + ")) SAIDAS, "

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0) "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_CREDIT = CT1.CT1_CONTA "
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR014" ) + ")) BAIXAS "

		cQuery += "FROM " + RetSqlName( "CT1" ) + " CT1 "
		cQuery += "WHERE CT1.CT1_CONTA = '" + aCtasCusto[nX] + "' "
		cQuery += "AND CT1.D_E_L_E_T_ = ' '"

		If nX # Len( aCtasCusto )

			cQuery += " UNION ALL "

		End If

	Next nX

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasTRB, .T., .T. )

Return
/*/{Protheus.doc} QuerySld1
Query com dados da Seção 2 e 5
@author Elton Teodoro Alves
@since 27/12/2016
@version 12.1.007
@param aCtasAmort, Array, Array com as contas de amortizacao de ativo definido no parâmetros
@param cAliasTRB, Caracter, Nome do Alias para o resultado da Query
/*/
Static Function QuerySld2( aCtasAmort, cAliasTRB )

	Local cQuery    := ''
	Local nX        := 1

	For nX := 1 To Len( aCtasAmort )

		cQuery += "SELECT TOP 1 CT1.CT1_CONTA CONTA, CT1.CT1_DESC01 DESCRICAO, "

		cQuery += "(SELECT SUM(VALOR) SALDO FROM( "

		cQuery += "SELECT -COALESCE(SUM(CT2_DEB.CT2_VALOR), 0) VALOR FROM " + RetSqlName( "CT2" ) + " CT2_DEB "
		cQuery += "WHERE CT2_DEB.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2_DEB.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2_DEB.CT2_DEBITO = CT1.CT1_CONTA "
		cQuery += "AND SUBSTRING(CT2_DEB.CT2_DATA, 1, 6) < '" + AllTrim( MV_PAR01 ) + "' "

		cQuery += "UNION ALL "

		cQuery += "SELECT COALESCE(SUM(CT2_CRED.CT2_VALOR), 0) VALOR FROM " + RetSqlName( "CT2" ) + " CT2_CRED "
		cQuery += "WHERE CT2_CRED.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2_CRED.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2_CRED.CT2_CREDIT = CT1.CT1_CONTA "
		cQuery += "AND SUBSTRING(CT2_CRED.CT2_DATA, 1, 6) < '" + AllTrim( MV_PAR01 ) + "' "

		cQuery += ") CT2_SALDO "

		cQuery += ") SALDO_DE_BALANCO, "


		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0) "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_CREDIT = CT1.CT1_CONTA "
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR015" ) + ")) ADICAO, "

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0) "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_CREDIT = CT1.CT1_CONTA "
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR016" ) + ")) ENTRADAS, "

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0) "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_DEBITO = CT1.CT1_CONTA "
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR017" ) + ")) SAIDAS, "

		cQuery += "(SELECT "
		cQuery += "COALESCE(SUM(CT2.CT2_VALOR), 0)  "
		cQuery += "FROM " + RetSqlName( "CT2" ) + " CT2 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = ' ' "
		cQuery += "AND CT2.CT2_FILIAL = '" + xFilial( "CT2" ) + "' "
		cQuery += "AND CT2.CT2_DEBITO = CT1.CT1_CONTA "
		cQuery += "AND SUBSTRING(CT2.CT2_DATA, 1, 6 ) = '" + cValToChar( MV_PAR01 ) + "' "
		cQuery += "AND CT2.CT2_LP IN (" + ParamToIn( "IO_ATFR017" ) + ")) BAIXAS "

		cQuery += "FROM " + RetSqlName( "CT1" ) + " CT1 "
		cQuery += "WHERE CT1.CT1_CONTA = '" + aCtasAmort[nX] + "' "
		cQuery += "AND CT1.D_E_L_E_T_ = ' '"

		If nX # Len( aCtasAmort )

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

			cRet += ","

		End If

	Next nX

Return cRet