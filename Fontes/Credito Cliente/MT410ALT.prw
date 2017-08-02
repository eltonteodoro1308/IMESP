#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT410ALT
Ponto de entrada após a gravação dos itens
do pedido de venda (alteração). Utilizado para atualizar
o limite de crédito do cliente.
@author marcos.aleluia
@since 06/07/2017
@version undefined

@type function
/*/
user function MT410ALT()

	U_FChkLC01( SC5->C5_CLIENTE, SC5->C5_LOJACLI )

return