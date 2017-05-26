#INCLUDE 'TOTVS.CH'

user function M460FIM()

	RecLock( 'SF2', .F. )

	SF2->F2_XVENDID := SC5->C5_XVENDID 

	MsUnlock()

	U_IONFE( '1' )

Return