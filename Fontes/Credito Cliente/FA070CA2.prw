#include 'protheus.ch'
#include 'parmtype.ch'

user function FA070CA2()

	if FWISINCALLSTACK("FA070CAN") // Cancelamento de baixa
		U_FChkLC01( SE1->E1_CLIENTE, SE1->E1_LOJA )
	else
		U_FChkLC02()
	endif

return