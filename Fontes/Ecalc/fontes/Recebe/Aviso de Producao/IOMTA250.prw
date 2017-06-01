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
@return cRet   , Xml de retorno com a Imagem solicitado em formato Base64 ou erro de processamento
/*/
User Function IOMTA250( cXml, cError, cWarning, cParams, oFwEai )
	
	Local cRet    := ''
	Local oXml    := TXmlManager():New()
	Local aCpos   := {}
	Local nX      := 0
	Local cOrdSrv := ''
	Local aArea   := {}
	
	Local aChild   := {}
	Local aAtt     := {}
	
	Local nOpc     := 3
	
	Local cReg     := ''
	Local cTipoMov := ''
	Local nQuant   := 0
	Local cOP      := ''
	Local cLocal   := ''
	Local lEstorna := .F.
	
	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.
	
	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )
		
		If oXml:DOMChildNode()
			
			Do While .T.
				
				aChild := oXml:DOMGetChildArray()
				aAtt   := oXml:DOMGetAttArray()
				
				cTipoMov :=      aChild [ aScan( aChild, { | X | AllTrim( X[ 1 ] ) == 'D3_TM'    } ) ][ 2 ]
				nQuant   := Val( aChild [ aScan( aChild, { | X | AllTrim( X[ 1 ] ) == 'D3_QUANT' } ) ][ 2 ] )
				cOrdSrv  :=      aChild [ aScan( aChild, { | X | AllTrim( X[ 1 ] ) == 'D3_XOS'   } ) ][ 2 ]
				lEstorna :=      aChild [ aScan( aChild, { | X | AllTrim( X[ 1 ] ) == 'ESTORNA'  } ) ][ 2 ] == 'T'
				cReg     :=      aAtt   [ aScan( aAtt  , { | X | AllTrim( X[ 1 ] ) == 'registro' } ) ][ 2 ]
				
				aArea := GetArea()
				
				DbSelectArea( 'SC2' )
				DBOrderNickname( 'XOS' )
				
				If DbSeek( xFilial( 'SC2' ) + cOrdSrv )
					
					cOp    := SC2->( C2_NUM + C2_ITEM + C2_SEQUEN )
					cLocal := SC2->C2_LOCAL
					
				End If
				
				RestArea( aArea )
				
				If lEstorna
					
					nOpc := 5
					
				End If
				
				aAdd( aCpos, { 'D3_TM'      , cTipoMov , Nil } )
				aAdd( aCpos, { 'D3_QUANT'   , nQuant   , Nil } )
				aAdd( aCpos, { 'D3_OP'      , cOP      , Nil } )
				aAdd( aCpos, { 'D3_LOCAL'   , cLocal   , Nil } )
								
				MSExecAuto( { | X, Y | MATA250( X, Y ) }, aCpos, nOpc )
								
				aSize( aCpos, 0 )
				
				If lMsErroAuto
					
					lMsErroAuto := .F.
					
					aErro := aClone( GetAutoGRLog() )
					
					cRet += Chr(13) + Chr(10)
					cRet += 'Registro: ' + cReg
					cRet += Chr(13) + Chr(10)
					
					For nX := 1 To Len( aErro )
						
						cRet += aErro[ nX ] + Chr(13) + Chr(10)
						
					Next nX
					
				Else
					
					cRet += Chr(13) + Chr(10)
					cRet += 'Registro: ' + cReg + ' OK'
					cRet += Chr(13) + Chr(10)
					
				End If
				
				If ! oXml:DOMNextNode()
					
					Exit
					
				End If
				
			End Do
			
		End If
		
	Else
		
		cRet := 'Erro no Parse do XML: ' + oXml:LastError()
		
	End If
	
Return cRet
