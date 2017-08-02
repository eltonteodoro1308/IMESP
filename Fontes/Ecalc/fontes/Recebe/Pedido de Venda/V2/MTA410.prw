#include 'protheus.ch'
#include 'parmtype.ch'

user function MTA410()

	Local cMsg := ''
	Local lRet := ( Empty( M->C5_XVENDID ) .And. Empty( M->C5_XSISTEM ) ) .Or.;
	( ! Empty( M->C5_XVENDID ) .And. ! Empty( M->C5_XSISTEM ) )

	If ! lRet

		cMsg += ' Os campos ('
		cMsg += AllTrim( GetSx3Cache( 'C5_XSISTEM', 'X3_TITULO' ) )
		cMsg += ' - C5_XSISTEM) e ('
		cMsg += AllTrim( GetSx3Cache( 'C5_XVENDID', 'X3_TITULO' ) )
		cMsg += ' - C5_XVENDID) '
		cMsg += 'devem ambos estar em branco ou ambos preenchidos.'

		Help( ,, 'Help',, cMsg, 1, 0 )

	EndIf

return lRet