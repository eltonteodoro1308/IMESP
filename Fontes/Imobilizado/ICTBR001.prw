#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} ICTBR001
//TODO Descrição auto-gerada.
@author Elton Teodoro Alves
@since 20/12/2016
@version 12.1.007
/*/
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
	Local cTitulo   := 'Ativo'

	oReport := TReport():New('ICTBR001', cTitulo, , { |oReport| PrintReport( oReport ) },;
	'Este relatorio ira imprimir a relacao de Cartas de Cobrança.' )

	oReport:SetPortrait()
	oReport:ShowHeader()

	oSection := TRSection():New( oReport, cTitulo, cAliasTRB )
	oSection:SetTotalInLine(.F.)

	TRCell():New(oSection, 'ZA_FILIAL'  , cAliasTRB, GetSx3Cache( 'ZA_FILIAL' , 'X3_TITULO'  ), X3Picture( 'ZA_FILIAL'  ), TamSx3( 'ZA_FILIAL'  )[1] * nP )
	TRCell():New(oSection, 'ZA_CLIENTE' , cAliasTRB, GetSx3Cache( 'ZA_CLIENTE', 'X3_TITULO'  ), X3Picture( 'ZA_CLIENTE' ), TamSx3( 'ZA_CLIENTE' )[1] * nP )
	TRCell():New(oSection, 'ZA_LOJA'    , cAliasTRB, GetSx3Cache( 'ZA_LOJA'   , 'X3_TITULO'  ), X3Picture( 'ZA_LOJA'    ), TamSx3( 'ZA_LOJA'    )[1] * nP )
	TRCell():New(oSection, 'ZA_NOME'    , cAliasTRB, GetSx3Cache( 'ZA_NOME'   , 'X3_TITULO'  ), X3Picture( 'ZA_NOME'    ), TamSx3( 'ZA_NOME'    )[1] * nP )
	TRCell():New(oSection, 'ZA_PREFIXO' , cAliasTRB, GetSx3Cache( 'ZA_PREFIXO', 'X3_TITULO'  ), X3Picture( 'ZA_PREFIXO' ), TamSx3( 'ZA_PREFIXO' )[1] * nP )
	TRCell():New(oSection, 'ZA_NUM'     , cAliasTRB, GetSx3Cache( 'ZA_NUM'    , 'X3_TITULO'  ), X3Picture( 'ZA_NUM'     ), TamSx3( 'ZA_NUM'     )[1] * nP )
	TRCell():New(oSection, 'ZA_PARCELA' , cAliasTRB, GetSx3Cache( 'ZA_PARCELA', 'X3_TITULO'  ), X3Picture( 'ZA_PARCELA' ), TamSx3( 'ZA_PARCELA' )[1] * nP )
	TRCell():New(oSection, 'ZA_TIPO'    , cAliasTRB, GetSx3Cache( 'ZA_TIPO'   , 'X3_TITULO'  ), X3Picture( 'ZA_TIPO'    ), TamSx3( 'ZA_TIPO'    )[1] * nP )
	TRCell():New(oSection, 'ZA_EMISSAO' , cAliasTRB, GetSx3Cache( 'ZA_EMISSAO', 'X3_TITULO'  ), X3Picture( 'ZA_EMISSAO' ), TamSx3( 'ZA_EMISSAO' )[1] * nP )
	TRCell():New(oSection, 'ZA_VENCTO'  , cAliasTRB, GetSx3Cache( 'ZA_VENCTO' , 'X3_TITULO'  ), X3Picture( 'ZA_VENCTO'  ), TamSx3( 'ZA_VENCTO'  )[1] * nP )
	TRCell():New(oSection, 'ZA_VALOR'   , cAliasTRB, GetSx3Cache( 'ZA_VALOR'  , 'X3_TITULO'  ), X3Picture( 'ZA_VALOR'   ), TamSx3( 'ZA_VALOR'   )[1] * nP )
	TRCell():New(oSection, 'ZA_DATA'    , cAliasTRB, GetSx3Cache( 'ZA_DATA'   , 'X3_TITULO'  ), X3Picture( 'ZA_DATA'    ), TamSx3( 'ZA_DATA'    )[1] * nP )
	TRCell():New(oSection, 'ZA_EMAIL'   , cAliasTRB, GetSx3Cache( 'ZA_EMAIL'  , 'X3_TITULO'  ), X3Picture( 'ZA_EMAIL'   ), TamSx3( 'ZA_EMAIL'   )[1] * nP )

Return oReport