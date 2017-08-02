#INCLUDE 'TOTVS.CH'

User Function MS520VLD()
	
	Local lRet  := .T.
	
	If SF2->F2_XSISTEM = '05'
		
		lRet := U_IONFE( '2' )
		
	End If
	
Return lRet
