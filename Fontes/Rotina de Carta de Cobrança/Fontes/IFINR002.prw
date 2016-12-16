#INCLUDE 'TOTVS.CH'

User Function IFINR002()

	local oReport := Nil
	//local cPerg   := PadR('IFINR002',10)

	oReport := ReportDef()
	oReport:printDialog()

Return

Static Function ReportDef()

	Local oReport   := Nil
	Local oSection  := Nil
	Local cTitulo   := '[IFINR002] - Impress�o de Produtos'
	Local cAliasTRB := GetNextAlias()
	Local nP        := 7

	BeginSQL Alias cAliasTRB

	SELECT

	SZA.ZA_FILIAL,
	SZA.ZA_CLIENTE,
	SZA.ZA_LOJA,
	SZA.ZA_NOME,
	SZA.ZA_PREFIXO,
	SZA.ZA_NUM,
	SZA.ZA_PARCELA,
	SZA.ZA_TIPO,
	SZA.ZA_EMISSAO,
	SZA.ZA_VENCTO,
	SZA.ZA_VALOR,
	SZA.ZA_DATA,
	SZA.ZA_EMAIL

	FROM %Table:SZA% SZA

	WHERE

	SZA.ZA_FILIAL = %XFILIAL:SZA%	AND
	SZA.%NotDel%

	EndSQL

	oReport := TReport():New('IFINR002', cTitulo, , { |oReport| PrintReport( oReport, cAliasTRB ) },;
	'Este relatorio ira imprimir a relacao de Cartas de Cobran�a.' )

	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()

	oSection := TRSection():New( oReport, 'Cartas de Cobran�a', cAliasTRB )
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

Static Function PrintReport( oReport, cAliasTRB )

	Local oSection := oReport:Section(1)

	oSection:Init()
	oSection:SetHeaderSection(.T.)

	(cAliasTRB)->( dbGoTop() )

	oReport:SetMeter( (cAliasTRB)->( RecCount() ) )

	While ( cAliasTRB )->( ! Eof() )

		If oReport:Cancel()

			Exit

		EndIf

		oReport:IncMeter()

		oSection:Cell( 'ZA_FILIAL'  ):SetValue( (cAliasTRB)->ZA_FILIAL )
		oSection:Cell( 'ZA_FILIAL'  ):SetAlign( 'LEFT' )

		oSection:Cell( 'ZA_CLIENTE' ):SetValue( (cAliasTRB)->ZA_CLIENTE )
		oSection:Cell( 'ZA_CLIENTE' ):SetAlign( 'LEFT' )

		oSection:Cell( 'ZA_LOJA'    ):SetValue( (cAliasTRB)->ZA_LOJA )
		oSection:Cell( 'ZA_LOJA'    ):SetAlign( 'LEFT' )

		oSection:Cell( 'ZA_NOME'    ):SetValue( (cAliasTRB)->ZA_NOME )
		oSection:Cell( 'ZA_NOME'    ):SetAlign( 'LEFT' )

		oSection:Cell( 'ZA_PREFIXO' ):SetValue( (cAliasTRB)->ZA_PREFIXO )
		oSection:Cell( 'ZA_PREFIXO' ):SetAlign( 'LEFT' )

		oSection:Cell( 'ZA_NUM'     ):SetValue( (cAliasTRB)->ZA_NUM )
		oSection:Cell( 'ZA_NUM'     ):SetAlign( 'LEFT' )

		oSection:Cell( 'ZA_PARCELA' ):SetValue( (cAliasTRB)->ZA_PARCELA )
		oSection:Cell( 'ZA_PARCELA' ):SetAlign( 'LEFT' )

		oSection:Cell( 'ZA_TIPO'    ):SetValue( (cAliasTRB)->ZA_TIPO )
		oSection:Cell( 'ZA_TIPO'    ):SetAlign( 'LEFT' )

		oSection:Cell( 'ZA_EMISSAO' ):SetValue( Dtoc( StoD( (cAliasTRB)->ZA_EMISSAO ) ) )
		oSection:Cell( 'ZA_EMISSAO' ):SetAlign( 'LEFT' )

		oSection:Cell( 'ZA_VENCTO'  ):SetValue( Dtoc( StoD( (cAliasTRB)->ZA_VENCTO ) ) )
		oSection:Cell( 'ZA_VENCTO'  ):SetAlign( 'LEFT' )

		oSection:Cell( 'ZA_VALOR'   ):SetValue( (cAliasTRB)->ZA_VALOR )
		oSection:Cell( 'ZA_VALOR'   ):SetAlign( 'RIGHT' )

		oSection:Cell( 'ZA_DATA'    ):SetValue( DtoC( StoD( (cAliasTRB)->ZA_DATA ) ) )
		oSection:Cell( 'ZA_DATA'    ):SetAlign( 'LEFT' )

		oSection:Cell( 'ZA_EMAIL'   ):SetValue( (cAliasTRB)->ZA_EMAIL )
		oSection:Cell( 'ZA_EMAIL'   ):SetAlign( 'LEFT' )

		oSection:PrintLine()

		( cAliasTRB )->(dbSkip())

	End Do

	oSection:Finish()

Return