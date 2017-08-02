#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function MTAB2D3R()

	Local aArea          := GetArea()
	Local cId            := SD3->( D3_NUMSEQ + D3_CF )
	Local cNumAno        := Transform( Posicione( 'SC2', 1, xFilial( 'SC2' ) + SD3->D3_OP, 'C2_XOS' ),'@R 999.999/999' )
	Local cCodItem       := SD3->D3_COD
	Local cDescricao     := Posicione( 'SB1', 1, xFilial( 'SB1' ) + SD3->D3_COD, 'B1_DESC' )
	Local cTpPrd         := Posicione( 'SB1', 1, xFilial( 'SB1' ) + SD3->D3_COD, 'B1_TIPO' )
	Local cTipo          := ''
	Local cDataMovimento := ''
	Local cQuantidade    := AllTrim( Str( SD3->D3_QUANT  ) )
	Local cValorTotal    := AllTrim( Str( SD3->D3_CUSTO1 ) )
	Local cValorIcms     := '0.00'
	Local cStatus        := '1'

	RestArea( aArea )

	cDataMovimento += PadL( cValToChar( Year ( SD3->D3_EMISSAO ) ), 4, '0' )
	cDataMovimento += '-'
	cDataMovimento += PadL( cValToChar( Month( SD3->D3_EMISSAO ) ), 2, '0' )
	cDataMovimento += '-'
	cDataMovimento += PadL( cValToChar( Day  ( SD3->D3_EMISSAO ) ), 2, '0' )
	cDataMovimento += 'T' + Time() + 'Z'

	If SubStr( SD3->D3_CF, 1, 1 ) = 'R' .And. cTpPrd # 'MO'

		cTipo := '1'

	ElseIf SubStr( SD3->D3_CF, 1, 1 ) == 'D' .And. cTpPrd # 'MO'

		cTipo := '2'

	ElseIf SubStr( SD3->D3_CF, 1, 1 ) = 'R' .And. cTpPrd == 'MO'

		cTipo := '3'

	ElseIf SubStr( SD3->D3_CF, 1, 1 ) = 'D' .And. cTpPrd == 'MO'

		cTipo := '4'

	End If

	If ! Empty( cTipo ) .And. ! Empty( SD3->D3_OP ) .And. AllTrim( SD3->D3_XTPDOC ) # '2'

		U_IOREQDEV( cId, cNumAno, cCodItem, cDescricao, cTipo, cDataMovimento, cQuantidade, cValorTotal, cValorIcms, cStatus )

	End If

	U_IOMTB201()

Return