#INCLUDE 'TOTVS.CH'

User Function SAR2SZ0()

	DbSelectArea( 'SRA' )
	DbSetOrder( 1 )

	DbSelectArea( 'SZ0' )
	DbSetOrder( 1 )

	SRA->( DbGotop() )
	SZ0->( DbGoTop() )

	Do While ! SRA->( Eof() )

		If ! SZ0-> ( DbSeek( SRA->RA_MAT ) )

			RecLock( 'SZ0', .T. )

			ConOut( SRA->( RA_FILIAL + ' - ' + RA_MAT ) )

			SZ0->Z0_FILIAL  := SRA->RA_FILIAL
			SZ0->Z0_CODIGO  := SRA->RA_MAT

			MsUnlock()

		End If

		SRA->( DbSkip() )

	End Do

Return