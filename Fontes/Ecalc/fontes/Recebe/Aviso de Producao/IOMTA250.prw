#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOMTA380
Função acionada pelo EAI que recebe xml com dados da Produção de uma OP
@author Elton Teodoro Alves
@since 04/05/2016
@version Protheus 12.1.014
@param cXml    , Caracter, O conteúdo da tag Content do XML recebido pelo EAI Protheus.
@param cError  , Caracter, Variável passada por referência, serve para alimentar a mensagem de erro, nos casos em que a transação não foi bem sucedida.
@param cWarning, Caracter, Variável passada por referência, serve para alimentar uma mensagem de warning para o EAI. A alteração deste valor por rotinas tratadas neste tópico não causam nenhum efeito para o EAI.
@param cParams , Caracter, Parâmetros passados na mensagem do EAI.
@param oFwEai  , Object  , O objeto de EAI criado na camada do EAI Protheus. A manipulação deste objeto deve ser realizada com o máximo de cautela, e deve ser evitada ao máximo.
@return Caracter , Xml de retorno com a Imagem solicitado em formato Base64 ou erro de processamento
/*/
User Function IOMTA250( cXml, cError, cWarning, cParams, oFwEai )
	
	Local oXml := TXmlManager():New()
	Local aMsg := {}
	
	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.
	
	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )
		
		oXml:DOMChildNode()
		
		Do While .T.
			
			lMsErroAuto := .F.
			
			Registra( oXml, @aMsg )
			
			If ! oXml:DOMNextNode()
				
				Exit
				
			End If
			
		End Do
		
	Else
		
		BuildMsg( @aMsg, 'F', 'Erro no Parse do XML: ' + oXml:LastError(), '0' )
		
	End If
	
	oFwEai:cReturnMsg := Retorno( aMsg )
	
Return oFwEai:cReturnMsg

Static Function Retorno( aMsg )
	
	Local cRet := ''
	Local nX   := 0
	
	cRet += '<MIOMT250>'
	
	For nX := 1 To Len( aMsg )
		
		cRet += aMsg[ nX ]
		
	Next nX
	
	cRet += '</MIOMT250>'
	
Return cRet

Static Function BuildMsg( aMsg, cSucesso, cMsg, cReg )
	
	aAdd( aMsg, '<SD3_FIELD registro="' + cReg + '">' )
	aAdd( aMsg, '<SUCESSO>'                           )
	aAdd( aMsg, '<value>' + cSucesso + '</value>'     )
	aAdd( aMsg, '</SUCESSO>'                          )
	aAdd( aMsg, '<MENSAGEM>'                          )
	aAdd( aMsg, '<value>'                             )
	aAdd( aMsg,  cMsg                                 )
	aAdd( aMsg, '</value>'                            )
	aAdd( aMsg, '</MENSAGEM>'                         )
	aAdd( aMsg, '</SD3_FIELD>'                        )
	
Return

Static Function Registra( oXml, aMsg )
	
	Local nOpc     := 3
	Local cReg     := ''
	Local aCpos    := {}
	Local cOrdSrv  := ''
	Local cDoc     := ''
	Local nQuant   := ''
	Local cDtFech  := ''
	Local cTipoMov := GetMv( 'MV_TMPAD' )
	Local cOp      := ''
	Local cLocal   := ''
	Local aArea    := GetArea()
	Local lRet     := .F.
	Local nX       := 0
	Local cSitOp   := ''
	Local aErro    := {}
	Local cErro    := ''
	
	aAtt := oXml:DOMGetAttArray()
	
	cReg := aAtt[ aScan( aAtt  , { | X | AllTrim( X[ 1 ] ) == 'Registro' } ) ][ 2 ]
	nOpc := Val( aAtt[ aScan( aAtt  , { | X | AllTrim( X[ 1 ] ) == 'Operation' } ) ][ 2 ] )
	
	Carrega( oXml, @cOrdSrv, @cDoc, @nQuant, @cDtFech )
	
	If nOpc == 3 .Or. nOpc == 5
		
		DbSelectArea( 'SD3' )
		DBOrderNickname( 'DOCECALC' )
		
		If lRet := DbSeek( xFilial( 'SD3' ) + '1' + Padr( cDoc, GetSx3Cache( 'D3_XDECALC', 'X3_TAMANHO' ) ) + ' ' )
			
			For nX := 1 To FCount()
				
				If ! AllTrim( FieldName( nX ) ) == 'D3_FATCORR' //Campo apresenta erro de gatilho, então foi tirado do array do execauto
					
					aAdd( aCpos, { FieldName( nX ), SD3->&( FieldName( nX ) ), Nil } )
					
				End If
				
			Next nX
			
			aAdd( aCpos, { 'INDEX', 4, Nil } )
			
			//BeginTran()
			
			MSExecAuto( { | X, Y | MATA250( X, Y ) }, aCpos, 5 )
			
			If ! lMsErroAuto .And. nOpc == 3
				
				aSize( aCpos, 0 )
				
				DbSelectArea( 'SC2' )
				DBOrderNickname( 'XOS' )
				
				If lRet := DbSeek( xFilial( 'SC2' ) + cOrdSrv )
					
					cOp    := SC2->( C2_NUM + C2_ITEM + C2_SEQUEN )
					cLocal := SC2->C2_LOCAL
					
					aAdd( aCpos, { 'D3_TM'      , cTipoMov , Nil } )
					aAdd( aCpos, { 'D3_QUANT'   , nQuant   , Nil } )
					aAdd( aCpos, { 'D3_OP'      , cOP      , Nil } )
					aAdd( aCpos, { 'D3_XOS'     , cOrdSrv  , Nil } )
					aAdd( aCpos, { 'D3_LOCAL'   , cLocal   , Nil } )
					aAdd( aCpos, { 'D3_XTPDOC'  , '1'      , Nil } )
					aAdd( aCpos, { 'D3_XDECALC' , cDoc     , Nil } )
					
					MSExecAuto( { | X, Y | MATA250( X, Y ) }, aCpos, 3 )
					
				Else
					
					BuildMsg( @aMsg, 'F', 'OS ' + cOrdSrv + ' não localizada.', cReg )
					
					Disarmtransaction()
					
				End If
				
			End If
			
			If lMsErroAuto
				
				aErro := aClone( GetAutoGRLog() )
				
				For nX := 1 To Len( aErro )
					
					cErro += aErro[ nX ] + Chr( 13 ) + Chr( 10 )
					
				Next nX
				
				BuildMsg( @aMsg, 'F', cErro, cReg )
				
				Disarmtransaction()
				
			Else
				
				BuildMsg( @aMsg, 'T', cErro, cReg )
				
			End If
			
			//EndTran()
			
		Else
			
			If nOpc == 5
				
				BuildMsg( @aMsg, 'F', 'Documento ' + cDoc + ' não localizada.', cReg )
				
			ElseIf nOpc == 3
				
				DbSelectArea( 'SC2' )
				DBOrderNickname( 'XOS' )
				
				If lRet := DbSeek( xFilial( 'SC2' ) + cOrdSrv )
					
					cOp    := SC2->( C2_NUM + C2_ITEM + C2_SEQUEN )
					cLocal := SC2->C2_LOCAL
					
					aAdd( aCpos, { 'D3_TM'      , cTipoMov , Nil } )
					aAdd( aCpos, { 'D3_QUANT'   , nQuant   , Nil } )
					aAdd( aCpos, { 'D3_OP'      , cOP      , Nil } )
					aAdd( aCpos, { 'D3_XOS'     , cOrdSrv  , Nil } )
					aAdd( aCpos, { 'D3_LOCAL'   , cLocal   , Nil } )
					aAdd( aCpos, { 'D3_XTPDOC'  , '1'      , Nil } )
					aAdd( aCpos, { 'D3_XDECALC' , cDoc     , Nil } )
					
					//BeginTran()
					
					MSExecAuto( { | X, Y | MATA250( X, Y ) }, aCpos, nOpc )
					
					If lMsErroAuto
						
						aErro := aClone( GetAutoGRLog() )
						
						For nX := 1 To Len( aErro )
							
							cErro += aErro[ nX ] + Chr( 13 ) + Chr( 10 )
							
						Next nX
						
						BuildMsg( @aMsg, 'F', cErro, cReg )
						
						Disarmtransaction()
						
					Else
						
						BuildMsg( @aMsg, 'T', cErro, cReg )
						
					End If
					
					//EndTran()
					
				Else
					
					BuildMsg( @aMsg, 'F', 'OS ' + cOrdSrv + ' não localizada.', cReg )
					
				End If
				
			End If
			
		End If
		
	ElseIf nOpc == 7 .Or. nOpc == 9
		
		DbSelectArea( 'SC2' )
		DBOrderNickname( 'XOS' )
		
		If lRet := DbSeek( xFilial( 'SC2' ) + cOrdSrv )
			
			RecLock( 'SC2', .F. )
			
			If nOpc == 7
				
				SC2->C2_STATUS  := 'U'
				SC2->C2_XDTFECH := StoD( Replace( SubStr( cDtFech, 1, 10 ), '-', '' ) )
				
			ElseIf nOpc == 9
				
				SC2->C2_STATUS := 'N'
				SC2->C2_XDTFECH := CtoD( '' )				
				
			End If
			
			MsUnlock()
			
			BuildMsg( @aMsg, 'T', cErro, cReg )
			
		Else
			
			BuildMsg( @aMsg, 'F', 'OS ' + cOrdSrv + ' não localizada.', cReg )
			
		End If
		
	End If
	
	RestArea( aArea )
	
Return

Static Function Carrega( oXml, cOrdSrv, cDoc, nQuant, cDtFech )
	
	oXml:DOMChildNode()
	
	Do While .T.
		
		If oXml:cName == 'D3_QUANT'
			
			oXml:DOMChildNode()
			
			nQuant :=  Val( oXml:cText )
			
			oXml:DOMParentNode()
			
		ElseIf oXml:cName == 'D3_XOS'
			
			oXml:DOMChildNode()
			
			cOrdSrv := oXml:cText
			
			oXml:DOMParentNode()
			
		ElseIf oXml:cName == 'D3_DOC'
			
			oXml:DOMChildNode()
			
			cDoc := oXml:cText
			
			oXml:DOMParentNode()
			
		ElseIf oXml:cName == 'C2_XDTFECH'
			
			oXml:DOMChildNode()
			
			cDtFech	 := oXml:cText
			
			oXml:DOMParentNode()
			
		End If
		
		If ! oXml:DOMNextNode()
			
			Exit
			
		End If
		
	End Do
	
	oXml:DOMParentNode()
	
Return
