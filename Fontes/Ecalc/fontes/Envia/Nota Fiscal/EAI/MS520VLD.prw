#INCLUDE 'TOTVS.CH'

User Function MS520VLD()

	Local aArea := GetArea()

	DbSelectArea( 'SC5' )
	DBOrderNickname( 'XVENDID' )

	DbSeek( xFilial( 'SC5' ) + SF2->F2_XVENDID )

	U_IONFE( '2' )

	RestArea( aArea )

Return .T.