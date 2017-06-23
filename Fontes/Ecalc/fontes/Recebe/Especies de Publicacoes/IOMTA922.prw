#INCLUDE 'TOTVS.CH'

User Function IOMTA922( cXml, cError, cWarning, cParams, oFwEai )
	
	Local aMsg  := {}
	Local oXml  := TXmlManager():New()
	Local aAtt  := {}
	Local cReg  := ''
	Local aCpos := {}
	Local aErro := {}
	Local cErro := ''
	Local cMsg  := ''
	
	Private lMsErroAuto    := .F.
	Private lMsHelpAuto	   := .T.
	Private lAutoErrNoFile := .T.
	
	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )
		
		BeginTran()
			
			ClearTable()
			
			If oXml:DOMChildNode()
				
				Do While .T.
					
					aAtt   := oXml:DOMGetAttArray()
					
					cReg := aAtt[ aScan( aAtt  , { | X | AllTrim( X[ 1 ] ) == 'Registro' } ) ][ 2 ]
					
					aCpos := MontaCpos( oXml )
					
					ExecAuto( aCpos, @cMsg )
					
					If lMsErroAuto
						
						aErro := aClone( GetAutoGRLog() )
						
						For nX := 1 To Len( aErro )
							
							cErro += aErro[ nX ] + Chr( 13 ) + Chr( 10 )
							
						Next nX
						
						BuildMsg( @aMsg, 'F', cErro, cReg )
						
						Disarmtransaction()
						
						Exit
						
					Else
						
						BuildMsg( @aMsg, 'T', cMsg, cReg )
						
						cMsg := ''
						
					End If
					
					If ! oXml:DOMNextNode()
						
						Exit
						
					End If
					
				End Do
				
			End If
			
		EndTran()
		
	Else
		
		BuildMsg( @aMsg, 'F', 'Erro no Parse do XML: ' + oXml:LastError(), '0' )
		
	End If
	
	oFwEai:cReturnMsg := Retorno( aMsg )
	
Return oFwEai:cReturnMsg

static function ClearTable()
	
	Local aArea := GetArea()
	
	DbSelectArea( 'AHH' )
	
	DbGoTop()
	
	Do While ! Eof()
		
		RecLock('AHH',.F.)
		
		DbDelete()
		
		MsUnLock()
		
		DbSkip()
		
	End Do
	
	RestArea( aArea )
	
Return

static function MontaCpos( oXml )
	
	Local aRet := {}
	Local aAux := {}
	
	oXml:DOMChildNode()
	
	Do While .T.
		
		aAdd( aAux, oXml:cName )
		
		oXml:DOMChildNode()
		
		aAdd( aAux, oXml:cText )
		
		oXml:DOMParentNode()
		
		aAdd( aRet, aClone( aAux ) )
		
		aSize( aAux, 0 )
		
		If ! oXml:DOMNextNode()
			
			Exit
			
		End If
		
	End Do
	
	oXml:DOMParentNode()
	
return aRet

Static Function BuildMsg( aMsg, cSucesso, cMsg, cReg )
	
	aAdd( aMsg, '<AHH_FIELD registro="' + cReg + '">' )
	aAdd( aMsg, '<SUCESSO>'                           )
	aAdd( aMsg, '<value>' + cSucesso + '</value>'     )
	aAdd( aMsg, '</SUCESSO>'                          )
	aAdd( aMsg, '<MENSAGEM>'                          )
	aAdd( aMsg, '<value>'                             )
	aAdd( aMsg,  cMsg                                 )
	aAdd( aMsg, '</value>'                            )
	aAdd( aMsg, '</MENSAGEM>'                         )
	aAdd( aMsg, '</AHH_FIELD>'                        )
	
Return

Static Function Retorno( aMsg )
	
	Local cRet := ''
	Local nX   := 0
	
	cRet += '<MIOMT922>'
	
	For nX := 1 To Len( aMsg )
		
		cRet += aMsg[ nX ]
		
	Next nX
	
	cRet += '</MIOMT922>'
	
Return cRet


static function ExecAuto( aCpos, cMsg )
	
	Local nX        := 0
	Local oModel    := ModelDef()
	Local aErro     := {}
	Local lSetValue := .T.
	Local lCodPubOk := .T.
	Local xAux      := Nil
	Local cType     := ''
	Local aArea     := {}
	Local aAreaSX5  := {}
	Local aAreaAHG  := {}
	Local aAreaAHI  := {}
	
	oModel:SetOperation( 3 )
	
	oModel:Activate()
	
	For nX := 1 To Len( aCpos )
		
		cType := GetSx3Cache( aCpos[ nX, 1 ], 'X3_TIPO' )
		
		If cType == 'D'
			
			xAux := StoD( aCpos[ nX, 2 ] )
			
		ElseIf cType == 'L'
			
			xAux := StoD( aCpos[ nX, 2 ] ) == 'T'
			
		ElseIf cType == 'N'
			
			xAux := Val( aCpos[ nX, 2 ] )
			
		Else
			
			xAux := aCpos[ nX, 2 ]
			
		End If
		
		aArea := GetArea()
		
		If aCpos[ nX, 1 ] == 'AHH_CODELE'
			
			aAreaSX5 := SX5->( GetArea() )
			
			xAux := AllTrim( Posicione( 'SX5', 2, xFilial( 'SX5' ) + 'LN' + xAux, 'X5_CHAVE' ) )
			
			SX5->( RestArea( aAreaSX5 ) )
			
			If Empty( xAux ) //.Or. AllTrim( xAux ) # AllTrim( aCpos[ nX, 2 ] )
				
				lCodPubOk := .F.
				
				cMsg := 'Código do Elemeto "' + aCpos[ nX, 2 ] + '" não localizado.'
				
				Exit
				
			End If
			
		ElseIf aCpos[ nX, 1 ] == 'AHH_CODPAP'
			
			aAreaAHI := AHI->( GetArea() )
			
			xAux := AllTrim( Posicione( 'AHI', 1, xFilial( 'AHI' ) + xAux, 'AHI_CODPAP' ) )
			
			AHI->( RestArea( aAreaAHI ) )
			
			If Empty( xAux ) //.Or. AllTrim( xAux ) # AllTrim( aCpos[ nX, 2 ] )
				
				lCodPubOk := .F.
				
				cMsg := 'Código do Papel "' + aCpos[ nX, 2 ] + '" não localizado.'
				
				Exit
				
			End If
			
		ElseIf aCpos[ nX, 1 ] == 'AHH_CODPUB'
			
			aAreaAHG := AHG->( GetArea() )
			
			xAux := AllTrim( Posicione( 'AHG', 2, xFilial( 'AHG' ) + xAux, 'AHG_CODPUB' ) )
			
			AHG->( RestArea( aAreaAHG ) )
			
			If Empty( xAux ) //.Or. AllTrim( xAux ) # AllTrim( aCpos[ nX, 2 ] )
				
				lCodPubOk := .F.
				
				cMsg := 'Código da Publicação "' + aCpos[ nX, 2 ] + '" não localizado.'
				
				Exit
				
			End If
			
		End If
		
		RestArea( aArea )
		
		If ! oModel:SetValue( 'AHH_FIELD', aCpos[ nX, 1 ], xAux )
			
			aErro := aClone( oModel:GetErrorMessage() )
			
			lSetValue := .F.
			
			Exit
			
		End If
		
	Next nX
	
	If lSetValue .And. lCodPubOk
		
		If ! ( oModel:VldData() .And. oModel:CommitData() )
			
			aErro := aClone( oModel:GetErrorMessage() )
			
		End If
		
		If ! Empty( aErro )
			
			AutoGrLog( "Id do formulário de origem:" + ' [' + AllToChar( aErro[1] ) + ']' )
			AutoGrLog( "Id do campo de origem: "     + ' [' + AllToChar( aErro[2] ) + ']' )
			AutoGrLog( "Id do formulário de erro: "  + ' [' + AllToChar( aErro[3] ) + ']' )
			AutoGrLog( "Id do campo de erro: "       + ' [' + AllToChar( aErro[4] ) + ']' )
			AutoGrLog( "Id do erro: "                + ' [' + AllToChar( aErro[5] ) + ']' )
			AutoGrLog( "Mensagem do erro: "          + ' [' + AllToChar( aErro[6] ) + ']' )
			AutoGrLog( "Mensagem da solução: "       + ' [' + AllToChar( aErro[7] ) + ']' )
			AutoGrLog( "Valor atribuído: "           + ' [' + AllToChar( aErro[8] ) + ']' )
			AutoGrLog( "Valor anterior: "            + ' [' + AllToChar( aErro[9] ) + ']' )
			
		End If
		
	End If
	
	oModel:DeActivate()
	
Return

Static Function ModelDef()
	
	Local oModel := MPFormModel():New('MIOMT922')
	Local oStr   := FWFormStruct( 1, 'AHH' )
	
	oModel:SetDescription('Especies de Publicacoes')
	oModel:addFields('AHH_FIELD',,oStr)
	oModel:getModel('AHH_FIELD'):SetDescription('Especies de Publicacoes')
	oModel:SetPrimaryKey( { 'AHH_FILIAL', 'AHH_CODPUB' } )
	
Return oModel
