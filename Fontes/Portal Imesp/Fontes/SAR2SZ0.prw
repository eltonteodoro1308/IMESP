#INCLUDE 'TOTVS.CH'

User Function SAR2SZ0()

	DbSelectArea( 'SRA' )
	DbSetOrder( 1 )

	DbSelectArea( 'SZ0' )
	DbSetOrder( 1 )

	SRA->( DbGotop() )
	SZ0->( DbGoTop() )

	Do While ! SRA->( Eof() )

		RecLock( 'SZ0', .T. )

		ConOut( SRA->( RA_FILIAL + ' - ' + RA_MAT + ' - ' + RA_BITMAP1 + ' - ' + RA_BITMAP2 ) )

		SZ0->Z0_FILIAL  := SRA->RA_FILIAL
		SZ0->Z0_CODIGO  := SRA->RA_MAT
		SZ0->Z0_BITMAP1 := SRA->RA_BITMAP1
		SZ0->Z0_BITMAP2 := SRA->RA_BITMAP2

		MsUnlock()

		SRA->( DbSkip() )

	End Do

Return