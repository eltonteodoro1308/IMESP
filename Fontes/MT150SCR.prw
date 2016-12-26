#include 'protheus.ch'
#include 'parmtype.ch'

user function MT150SCR()

	Local cMsg    := Space(50)

	PARAMIXB:aControls[25]:AddItem( 'Folter Teste', .T.)

	@ 006,011 SAY OemToAnsi('Teste de campo no Folder :') OF PARAMIXB:aControls[25]:aDialogs[7] PIXEL SIZE 070,009
	@ 005,154 MSGET cMsg PICTURE '@!' OF PARAMIXB:aControls[25]:aDialogs[7] PIXEL SIZE 083,009 HASBUTTON

return