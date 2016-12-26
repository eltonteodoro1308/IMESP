#INCLUDE 'TOTVS.CH'
Static nSaldo := 0
/*/{Protheus.doc} ICTBR001
//TODO Descrição auto-gerada.
@author elton.alves
@since 26/12/2016
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function ICTBR001()

	local oReport := ReportDef()

	oReport:printDialog()

Return
/*/{Protheus.doc} ReportDef
//TODO Descrição auto-gerada.
@author elton.alves
@since 26/12/2016
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function ReportDef()

	Local oReport    := Nil
	Local oSection1  := Nil
	Local oSection2  := Nil
	Local oSection3  := Nil
	Local oSection4  := Nil
	Local oSection5  := Nil
	Local aAliasTRB  := { GetNextAlias(), GetNextAlias(), GetNextAlias(), GetNextAlias() }
	Local cPerg      := 'IOATFR01'

	Pergunte( cPerg, .F. )

	oReport := TReport():New( 'ICTBR001', 'Resumo Anual Por Conta', cPerg, { |oReport| PrintReport( oReport, aAliasTRB ) },;
	'Imprime o Resumo Anual de uma Conta de Ativo Imobilizado e sua Conta de Depreciação correspondente' )

	oSection1 := TRSection():New( oReport, 'Section1', aAliasTRB[1] )

	TRCell():New( oSection1, 'CONTA'           , aAliasTRB[1], 'Conta'           , '@!', 30  )
	TRCell():New( oSection1, 'DESCRICAO'       , aAliasTRB[1], 'Descrição'       , '@!', 30 )
	TRCell():New( oSection1, 'SALDO_DE_BALANCO', aAliasTRB[1], 'Saldo de Balanço', GetSx3Cache( 'CT2_VALOR', 'X3_PICTURE' ), 30,,,,,'RIGHT' )

	oSection2 := TRSection():New( oReport, 'Section2', 'SNG' )

	oSection3 := TRSection():New( oReport, 'Section3', aAliasTRB[2] )
	oSection3:SetTotalInLine(.F.)
	oSection3:SetTotalText('Total')

	TRCell():New( oSection3, 'MES_ANO', aAliasTRB[1], 'MES', '@!', 40,,,,,'CENTER' )
	oSection3:Cell('MES_ANO'):SetBorder( 'LEFT')

	TRCell():New(oSection3, 'ADICAO', aAliasTRB[1], 'ADIÇÃO', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection3:Cell('ADICAO'):SetBorder( 'LEFT')
	TRFunction():New( oSection3:Cell('ADICAO'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New(oSection3, 'ENTRADAS' , aAliasTRB[1], 'ENTRADAS'      , X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection3:Cell('ENTRADAS'):SetBorder( 'LEFT')
	TRFunction():New( oSection3:Cell('ENTRADAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New(oSection3, 'SAIDAS'   , aAliasTRB[1], 'SAÍDAS'        , X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection3:Cell('SAIDAS'):SetBorder( 'LEFT')
	TRFunction():New( oSection3:Cell('SAIDAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New(oSection3, 'BAIXAS'   , aAliasTRB[1], 'BAIXAS'        , X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection3:Cell('BAIXAS'):SetBorder( 'LEFT')
	oSection3:Cell('BAIXAS'):SetBorder( 'RIGHT')
	TRFunction():New( oSection3:Cell('BAIXAS'),'','SUM',,'', X3Picture( 'CT2_VALOR'  ),,.T.,.F.,.F. )

	TRCell():New(oSection3, 'TOTAL'    , aAliasTRB[1], 'TOTAL DO CUSTO', X3Picture( 'CT2_VALOR'  ), 40,,,,,'RIGHT' )
	oSection3:Cell('TOTAL'):SetBorder( 'RIGHT')

	oSection3 := TRSection():New( oReport, 'Section3', aAliasTRB[3] )

	//	TRCell():New( oSection3, 'BM_GRUPO', 'SBM', GetSx3Cache( 'BM_GRUPO', 'X3_TITULO' ), '@!' )
	//	TRCell():New( oSection3, 'BM_DESC' , 'SBM', GetSx3Cache( 'BM_DESC' , 'X3_TITULO' ), '@!' )


	oSection4 := TRSection():New( oReport, 'Section4', aAliasTRB[4] )

	//	TRCell():New( oSection4, 'AH_UNIMED', 'SAH', GetSx3Cache( 'AH_UNIMED', 'X3_TITULO' ), '@!'  )
	//	TRCell():New( oSection4, 'AH_UMRES' , 'SAH', GetSx3Cache( 'AH_UNRES' , 'X3_TITULO' ), '@!'  )

Return oReport
/*/{Protheus.doc} PrintReport
//TODO Descrição auto-gerada.
@author elton.alves
@since 26/12/2016
@version undefined
@param oReport, object, descricao
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function PrintReport( oReport, aAliasTRB )

	Local oSection1 := oReport:Section( 1 )
	Local oSection2 := oReport:Section( 2 )
	Local oSection3 := oReport:Section( 3 )
	Local oSection4 := oReport:Section( 4 )
	Local aArea     := GetArea()
	Local nLine     := 0

	oSection1:Init()

	QuerySld1( aAliasTRB[1] )

	( aAliasTRB[1] )->( DbGoTop() )

	oSection1:Cell( 'CONTA'             ):SetValue( Transform( ( aAliasTRB[1] )->CONTA, '@R  ' + AllTrim( MV_PAR03 ) ) )
	oSection1:Cell( 'DESCRICAO'         ):SetValue( ( aAliasTRB[1] )->DESCRICAO          )
	oSection1:Cell( 'SALDO_DE_BALANCO'  ):SetValue( nSaldo := ( aAliasTRB[1] )->SALDO_DE_BALANCO   )

	oSection1:PrintLine()

	DbSelectArea('SNG')
	SNG->( DbSetOrder(3) )
	SNG->( DbGoTop() )

	If DbSeek( xFilial('SNG') +  ( aAliasTRB[1] )->CONTA )

		oReport:Say ( oReport:nRow + oReport:nLineHeight * ++nLine, oReport:nCol, 'Código dos Grupos'  )
		oReport:Line( oReport:nRow + oReport:nLineHeight * ++nLine, oReport:nCol, oReport:nRow + oReport:nLineHeight * nLine, 500 )

		Do While SNG->( !Eof() ) .And. xFilial('SNG') +  ( aAliasTRB[1] )->CONTA == xFilial('SNG') + SNG->NG_CCONTAB

			oReport:Say( oReport:nRow + oReport:nLineHeight * ++nLine, oReport:nCol, SNG->( NG_GRUPO + ' - ' + NG_DESCRIC ) )

			SNG->( DbSkip() )

		End Do

	End If

	( aAliasTRB[1] )->( DbCloseArea() )

	oSection1:Finish()

	oReport:nRow += oReport:nLineHeight * ++nLine

	oSection3:Init()

	QuerySld2( aAliasTRB[2] )

	( aAliasTRB[2] )->( DbGoTop() )

	Do While ( aAliasTRB[2] )->( ! Eof() )

		oSection3:Cell( 'MES_ANO'  ):SetValue( SubStr((aAliasTRB[2])->MES_ANO, 5, 2) )
		oSection3:Cell( 'MES_ANO'  ):SetAlign( 'CENTER' )

		oSection3:Cell( 'ADICAO'  ):SetValue( (aAliasTRB[2])->ADICAO )
		oSection3:Cell( 'ADICAO'  ):SetAlign( 'RIGHT' )

		oSection3:Cell( 'ENTRADAS'  ):SetValue( (aAliasTRB[2])->ENTRADAS )
		oSection3:Cell( 'ENTRADAS'  ):SetAlign( 'RIGHT' )

		oSection3:Cell( 'SAIDAS'  ):SetValue( (aAliasTRB[2])->SAIDAS )
		oSection3:Cell( 'SAIDAS'  ):SetAlign( 'RIGHT' )

		oSection3:Cell( 'BAIXAS'  ):SetValue( (aAliasTRB[2])->BAIXAS )
		oSection3:Cell( 'BAIXAS'  ):SetAlign( 'RIGHT' )

		oSection3:Cell( 'TOTAL'  ):SetValue( nSaldo += (aAliasTRB[2])->(ADICAO + ENTRADAS - SAIDAS - BAIXAS) )
		oSection3:Cell( 'TOTAL'  ):SetAlign( 'RIGHT' )

		oSection3:PrintLine()

		( aAliasTRB[2] )->(dbSkip())

	End Do

	oSection3:Finish()

	//	oReport:EndPage( .T. )
	//
	//
	//
	//	DbSelectArea('SAH')
	//	DbSetOrder(1)
	//
	//	oSection2:Init()
	//
	//	Do While( SAH->( !Eof() ) )
	//
	//		oSection2:Cell( 'AH_UNIMED'  ):SetValue( SAH->AH_UNIMED )
	//		oSection2:Cell( 'AH_UMRES'  ):SetValue( SAH->AH_UMRES )
	//
	//		oSection2:PrintLine()
	//
	//		SAH->( DbSkip() )
	//
	//	End Do
	//
	//	oSection2:Finish()

	RestArea( aArea )

Return

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

Static Function QuerySld2( cAliasTRB )

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

Return

Static Function QuerySld3()

Return

Static Function QuerySld4()

Return