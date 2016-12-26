#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} ICTBR001
//TODO Descrição auto-gerada.
@author Elton Teodoro Alves
@since 20/12/2016
@version 12.1.007
/*/
Static 	nSaldo := 0

user function ICTBR001()

	local oReport := Nil

	oReport := ReportDef()
	oReport:printDialog()

Return
/*/{Protheus.doc} ReportDef
Função que monta o objeto correspondente ao relatório
@author Elton Teodoro Alves
@since 20/12/2016
@version 12.1.007
@return return, Objeto correspondente ao relatório
/*/
Static Function ReportDef()

	Local oReport   := Nil
	Local oSection  := Nil
	Local cTitulo   := 'Resumo Anual Por Conta'
	Local cAliasTRB := GetNextAlias()
	Local cPerg     := 'ICTBR001'

	MV_PAR01 := '2016'
	MV_PAR02 := '1222005'

	nSaldo := 130000

	Pergunte( cPerg, .F. )

	BeginSQL Alias cAliasTRB

	SELECT MES_ANO, SUM(ADICAO) ADICAO, SUM(ENTRADAS) ENTRADAS, SUM(SAIDAS) SAIDAS, SUM(BAIXAS) BAIXAS FROM

	(

	// Aquisição
	SELECT
	SUBSTRING(CT2.CT2_DATA, 1, 6 ) MES_ANO,
	SUM(CT2.CT2_VALOR) ADICAO,
	0 ENTRADAS,
	0 SAIDAS,
	0 BAIXAS
	FROM %Table:CT2% CT2
	WHERE CT2.%NotDel%
	AND CT2.CT2_FILIAL = %XFilial:CT2%
	AND CT2.CT2_DEBITO = %Exp:MV_PAR02%
	AND SUBSTRING(CT2.CT2_DATA, 1, 4 ) = '2016'
	AND CT2.CT2_LP IN ('001')
	GROUP BY
	SUBSTRING(CT2.CT2_DATA, 1, 6 )

	UNION ALL

	// Entradas
	SELECT
	SUBSTRING(CT2.CT2_DATA, 1, 6 ) MES_ANO,
	0 ADICAO,
	SUM(CT2.CT2_VALOR)  ENTRADAS,
	0 SAIDAS,
	0 BAIXAS
	FROM %Table:CT2% CT2
	WHERE CT2.%NotDel%
	AND CT2.CT2_FILIAL = %XFilial:CT2%
	AND CT2.CT2_DEBITO = %Exp:MV_PAR02%
	AND SUBSTRING(CT2.CT2_DATA, 1, 4 ) = '2016'
	AND CT2.CT2_LP IN ('002')
	GROUP BY
	SUBSTRING(CT2.CT2_DATA, 1, 6 )

	UNION ALL

	//Saidas
	SELECT
	SUBSTRING(CT2.CT2_DATA, 1, 6 ) MES_ANO,
	0 ADICAO,
	0 ENTRADAS,
	SUM(CT2.CT2_VALOR) SAIDAS,
	0 BAIXAS
	FROM %Table:CT2% CT2
	WHERE CT2.%NotDel%
	AND CT2.CT2_FILIAL = %XFilial:CT2%
	AND CT2.CT2_CREDIT = %Exp:MV_PAR02%
	AND SUBSTRING(CT2.CT2_DATA, 1, 4 ) = '2016'
	AND CT2.CT2_LP IN ('002')
	GROUP BY
	SUBSTRING(CT2.CT2_DATA, 1, 6 )

	UNION ALL

	// Baixas
	SELECT
	SUBSTRING(CT2.CT2_DATA, 1, 6 ) MES_ANO,
	0 ADICAO,
	0 ENTRADAS,
	0 SAIDAS,
	SUM(CT2.CT2_VALOR) BAIXAS
	FROM %Table:CT2% CT2
	WHERE CT2.%NotDel%
	AND CT2.CT2_FILIAL = %XFilial:CT2%
	AND	CT2.CT2_CREDIT = %Exp:MV_PAR02%
	AND SUBSTRING(CT2.CT2_DATA, 1, 4 ) = '2016'
	AND CT2.CT2_LP IN ('003')
	GROUP BY
	SUBSTRING(CT2.CT2_DATA, 1, 6 )

	) SALDO

	GROUP BY MES_ANO

	ORDER BY MES_ANO

	EndSQL

	oReport := TReport():New( 'ICTBR001', cTitulo, , { |oReport| PrintReport( oReport, cAliasTRB ) },;
	'Este relatorio ira imprimir o Resumo Anual Por Conta.' )

	oReport:SetPortrait()
	oReport:ShowHeader()

	oSection := TRSection():New( oReport, cTitulo, cAliasTRB )
	oSection:SetTotalInLine(.F.)
	oSection:SetTotalText('')
	oSection:SetTitle('S')

	TRCell():New( oSection, 'MES_ANO', cAliasTRB, 'MES', '@!', 40,,,,,'CENTER' )
	oSection:Cell('MES_ANO'):SetBorder( 'LEFT')

	TRCell():New(oSection, 'ADICAO', cAliasTRB, 'ADIÇÃO', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection:Cell('ADICAO'):SetBorder( 'LEFT')
	TRFunction():New( oSection:Cell('ADICAO'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New(oSection, 'ENTRADAS' , cAliasTRB, 'ENTRADAS'      , X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection:Cell('ENTRADAS'):SetBorder( 'LEFT')
	TRFunction():New( oSection:Cell('ENTRADAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New(oSection, 'SAIDAS'   , cAliasTRB, 'SAÍDAS'        , X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection:Cell('SAIDAS'):SetBorder( 'LEFT')
	TRFunction():New( oSection:Cell('SAIDAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New(oSection, 'BAIXAS'   , cAliasTRB, 'BAIXAS'        , X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection:Cell('BAIXAS'):SetBorder( 'LEFT')
	TRFunction():New( oSection:Cell('BAIXAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New(oSection, 'TOTAL'    , cAliasTRB, 'TOTAL DO CUSTO', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection:Cell('TOTAL'):SetBorder( 'LEFT')
	TRFunction():New( oSection:Cell('TOTAL'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )



Return oReport
/*/{Protheus.doc} PrintReport
Função gera o relatório
@author Elton Teodoro Alves
@since 19/12/2016
@version 12.1.007
@param oReport, object, Objeto correspondente ao relatório
@param cAliasTRB, characters, Nome da tabela temporária
/*/
Static Function PrintReport( oReport, cAliasTRB )

	Local oSection := oReport:Section(1)

	oSection:Init()

	(cAliasTRB)->( dbGoTop() )

	oReport:SetMeter( (cAliasTRB)->( RecCount() ) )

	While ( cAliasTRB )->( ! Eof() )

		If oReport:Cancel()

			Exit

		EndIf

		oReport:IncMeter()

		oSection:Cell( 'MES_ANO'  ):SetValue( SubStr((cAliasTRB)->MES_ANO, 5, 2) )
		oSection:Cell( 'MES_ANO'  ):SetAlign( 'CENTER' )

		oSection:Cell( 'ADICAO'  ):SetValue( (cAliasTRB)->ADICAO )
		oSection:Cell( 'ADICAO'  ):SetAlign( 'RIGHT' )

		oSection:Cell( 'ENTRADAS'  ):SetValue( (cAliasTRB)->ENTRADAS )
		oSection:Cell( 'ENTRADAS'  ):SetAlign( 'RIGHT' )

		oSection:Cell( 'SAIDAS'  ):SetValue( (cAliasTRB)->SAIDAS )
		oSection:Cell( 'SAIDAS'  ):SetAlign( 'RIGHT' )

		oSection:Cell( 'BAIXAS'  ):SetValue( (cAliasTRB)->BAIXAS )
		oSection:Cell( 'BAIXAS'  ):SetAlign( 'RIGHT' )

		oSection:Cell( 'TOTAL'  ):SetValue( nSaldo += (cAliasTRB)->(ADICAO + ENTRADAS - SAIDAS - BAIXAS) )
		oSection:Cell( 'TOTAL'  ):SetAlign( 'RIGHT' )

		oSection:PrintLine()

		( cAliasTRB )->(dbSkip())

	End Do

	oSection:Finish()

Return