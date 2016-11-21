#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

user function QIEA030()

	Local aParam := PARAMIXB
	Local xRet   := .T.

	If PARAMIXB[2] == 'BUTTONBAR'

		xRet := {}

	ElseIf PARAMIXB[2] == 'MODELPOS' .And. PARAMIXB[1]:GetOperation() == MODEL_OPERATION_DELETE

		xRet   := .F.

		Help(,, 'Help',, 'Não é Permitido Excluir Unidades de Medidas !!!', 1, 0 )

	End If

return xRet