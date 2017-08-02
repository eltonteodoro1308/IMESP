#INCLUDE 'TOTVS.CH'

user function M460FIM()
	
	Local aArea := GetArea()
	local cSeek := SF2->F2_SERIE + SF2->F2_DOC
	
	RecLock( 'SF2', .F. )
	
	SF2->F2_XSISTEM := SC5->C5_XSISTEM
	SF2->F2_XVENDID := SC5->C5_XVENDID
	SF2->F2_XIDCPGT := SC5->C5_XIDCPGT
	
	MsUnlock()
	
	DbSelectArea('SE1')
	DbSetOrder(1)
	
	If DbSeek( xFilial( 'SE1' ) + cSeek )
		
		Do While cSeek == SE1->E1_PREFIXO + SE1->E1_NUM .And. ! Eof()
			
			RecLock( 'SE1', .F. )
			
			SE1->E1_XSISTEM := SC5->C5_XSISTEM
			SE1->E1_XVENDID := SC5->C5_XVENDID
			SE1->E1_XIDCPG  := SC5->C5_XIDCPGT
			SE1->E1_XPEDIDO := SC5->C5_NUM
			
			MsUnlock()
			
			DbSkip()
			
		End Do
		
	End If
	
	RestArea( aArea )
	
	If SF2->F2_XSISTEM = '05'
		
		U_IONFE( '1' )
		
	End If
	
Return
