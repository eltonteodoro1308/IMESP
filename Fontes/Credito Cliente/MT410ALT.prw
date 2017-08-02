#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT410ALT
Ponto de entrada ap�s a grava��o dos itens
do pedido de venda (altera��o). Utilizado para atualizar
o limite de cr�dito do cliente.
@author marcos.aleluia
@since 06/07/2017
@version undefined

@type function
/*/
user function MT410ALT()

	U_FChkLC01( SC5->C5_CLIENTE, SC5->C5_LOJACLI )

return