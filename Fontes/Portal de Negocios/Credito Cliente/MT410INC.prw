#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT410INC
Ponto de entrada após a gravação dos itens
do pedido de venda (inclusão). Utilizado para atualizar
o limite de crédito do cliente.
@author marcos.aleluia
@since 07/07/2017
@version undefined

@type function
/*/
user function MT410INC()

	U_FChkLC01( SC5->C5_CLIENTE, SC5->C5_LOJACLI )

return