#INCLUDE 'TOTVS.CH'

User Function MT240EST()
	
	RecLock( 'SD3',.F. )
	
	SD3->D3_DOC := ''
	
	MsUnlock()
	
Return .T.
