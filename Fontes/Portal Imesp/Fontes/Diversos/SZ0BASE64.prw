#include 'protheus.ch'
#include 'parmtype.ch'

user function SZ0BAS64()

	DbSelectArea( 'SZ0' )
	DbSetOrder( 1 )
	DbGoTop()

	Do While ! Eof()

		RecLock( 'SZ0',.F. )

		SZ0->Z0_BASE641 := U_IOGPEB64( SZ0->Z0_BITMAP1 )
		SZ0->Z0_BASE642 := U_IOGPEB64( SZ0->Z0_BITMAP2 )

		MsUnlock()

		ConOut( SZ0->Z0_CODIGO )

		DbSkip()

	End Do

return

User Function GETSZ064( cFunc )

	DbSelectArea( 'SZ0' )
	DbSetOrder( 1 )

	If DbSeek( cFunc )

		ConOut( SZ0->Z0_CODIGO )
		ConOut( SZ0->Z0_BASE641 )
		ConOut( SZ0->Z0_BASE642 )

	End If

Return