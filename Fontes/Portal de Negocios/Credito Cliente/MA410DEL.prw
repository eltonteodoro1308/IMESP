#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MA410DEL
Ponto de entrada após a deleção de C5. 
Utilizado para atualizar
o limite de crédito do cliente.
@author marcos.aleluia
@since 07/07/2017
@version undefined

@type function
/*/
user function MA410DEL()

	U_FChkLC01( SC5->C5_CLIENTE, SC5->C5_LOJACLI )
	
return