#include 'protheus.ch'
#include 'parmtype.ch'

user function A250ETRAN()

	RecLock( 'SC2', .F. )

	SC2->C2_DATRF := CtoD('')

	MsUnLock()

return