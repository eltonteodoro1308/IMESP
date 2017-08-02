#include 'protheus.ch'
#include 'parmtype.ch'

user function M460FIL()

return "U_PEDBLQ()"

user function PEDBLQ()

Return POSICIONE( 'SC5', 1, xFilial('SC5') + SC9->C9_PEDIDO, 'C5_MSBLQL' )  ==  '2'