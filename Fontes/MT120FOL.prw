#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT120TEL( )

	AAdd( aTitles, 'Folder TESTE' ) //Nome do folder que será adicionado

Return Nil

//--------------------------------------------------------------------------------------------

User Function MT120FOL( )

	Local nOpc    := PARAMIXB[1]
	Local aPosGet := PARAMIXB[2]
	Local cMsg    := Space(50)

	If nOpc <> 1

		@ 006,aPosGet[3,1] SAY OemToAnsi('Teste de campo no Folder :') OF oFolder:aDialogs[7] PIXEL SIZE 070,009
		@ 005,aPosGet[3,2] MSGET cMsg PICTURE '@!' OF oFolder:aDialogs[7] PIXEL SIZE 083,009 HASBUTTON

	Endif

Return Nil