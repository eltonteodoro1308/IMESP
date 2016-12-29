#include 'protheus.ch'
#include 'parmtype.ch'

user function TSTBREAK()

	local oReport := ReportDef()

	oReport:printDialog()

return

Static Function ReportDef()

	Local oReport   := Nil
	Local oSection  := Nil
	Local cAliasTRB := GetNextAlias()

	oReport := TReport():New( 'TSTBREAK', 'Teste de Quebra', ,;
	{ |oReport| PrintReport( oReport, cAliasTRB ) },;
	'Teste de Quebra' )

	oSection := TRSection():New( oReport, 'Section', cAliasTRB )
	oSection:SetTotalInLine(.F.)
	oSection:SetTotalText( 'Total Geral' )

	TRCell():New( oSection, 'DATA'      , cAliasTRB, 'DATA'      ,, 30  )
	TRCell():New( oSection, 'DEBITO'    , cAliasTRB, 'DEBITO'    ,, 30  )
	TRCell():New( oSection, 'CREDITO'   , cAliasTRB, 'CREDITO'   ,, 30  )

	TRCell():New( oSection, 'VALOR'     , cAliasTRB, 'VALOR'     ,, 30  )
	TRFunction():New( oSection:Cell('VALOR'),'SOMA','SUM', TRBreak():New( oSection, oSection:Cell('DATA'), {||( cAliasTRB )->CT2_DATA } ),,,, .T., .F., .F. )

	TRCell():New( oSection, 'HISTORICO' , cAliasTRB, 'HISTORICO' ,, 30  )

Return oReport

Static Function PrintReport( oReport, cAliasTRB )

	BeginSQL Alias cAliasTRB

	SELECT * FROM %Table:CT2% //ORDER BY CT2_DATA

	EndSQL

	( cAliasTRB )->( DbGoTop() )

	oReport:Section( 'Section' ):Init()

	Do While ( cAliasTRB )->( ! Eof() )

		oReport:Section( 'Section' ):Cell( 'DATA'      ):SetValue( ( cAliasTRB )->CT2_DATA   )
		oReport:Section( 'Section' ):Cell( 'DEBITO'    ):SetValue( ( cAliasTRB )->CT2_DEBITO )
		oReport:Section( 'Section' ):Cell( 'CREDITO'   ):SetValue( ( cAliasTRB )->CT2_CREDIT )
		oReport:Section( 'Section' ):Cell( 'VALOR'     ):SetValue( ( cAliasTRB )->CT2_VALOR  )
		oReport:Section( 'Section' ):Cell( 'HISTORICO' ):SetValue( ( cAliasTRB )->CT2_HIST   )

		oReport:Section( 'Section' ):PrintLine()

		( cAliasTRB )->( DbSkip() )

	End Do

	oReport:Section( 'Section' ):Finish()

	( cAliasTRB )->( DbCloseArea() )

Return