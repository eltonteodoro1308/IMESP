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
	
	Local aMsg    := {}
	Local oXml    := TXmlManager():New()
	Local aCpos   := {}
	Local nX      := 0
	Local cOrdSrv := ''
	Local aArea   := {}
	
	Local aAtt     := {}
	
	Local nOpc     := 3
	
	Local cReg     := ''
	Local cTipoMov := GetMv( 'MV_TMPAD' )
	Local nQuant   := 0
	Local cOP      := ''
	Local cLocal   := ''
	Local lEstorna := .F.
	
	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.
	
	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )
		
		If oXml:DOMChildNode()
			
			BeginTran()
				
				Do While .T.
					
					aAtt   := oXml:DOMGetAttArray()
					
					cReg := aAtt[ aScan( aAtt  , { | X | AllTrim( X[ 1 ] ) == 'Registro' } ) ][ 2 ]
					nOpc := Val( aAtt[ aScan( aAtt  , { | X | AllTrim( X[ 1 ] ) == 'Operation' } ) ][ 2 ] )
					
					oXml:DOMChildNode()
					
					Do While .T.
						
						If oXml:cName == 'D3_QUANT
							
							oXml:DOMChildNode()
							
							nQuant :=  Val( oXml:cText )
							
							oXml:DOMParentNode()
							
						ElseIf oXml:cName == 'D3_XOS'
							
							oXml:DOMChildNode()
							
							cOrdSrv := oXml:cText
							
							oXml:DOMParentNode()
							
						End If
						
						If ! oXml:DOMNextNode()
							
							Exit
							
						End If
						
					End Do
					
					oXml:DOMParentNode()
					
					aArea := GetArea()
					
					DbSelectArea( 'SC2' )
					DBOrderNickname( 'XOS' )
					
					If DbSeek( xFilial( 'SC2' ) + cOrdSrv )
						
						cOp    := SC2->( C2_NUM + C2_ITEM + C2_SEQUEN )
						cLocal := SC2->C2_LOCAL
						
					End If
					
					RestArea( aArea )
					
					aAdd( aCpos, { 'D3_TM'      , cTipoMov , Nil } )
					aAdd( aCpos, { 'D3_QUANT'   , nQuant   , Nil } )
					aAdd( aCpos, { 'D3_OP'      , cOP      , Nil } )
					aAdd( aCpos, { 'D3_LOCAL'   , cLocal   , Nil } )
					aAdd( aCpos, { 'D3_EMISSAO' , Date()   , Nil } )
					
					MSExecAuto( { | X, Y | MATA250( X, Y ) }, aCpos, nOpc )
					
					aSize( aCpos, 0 )
					
					aAdd( aMsg, '<SD3_FIELD registro="' + cReg + '">' )
					
					If lMsErroAuto
						
						aErro := aClone( GetAutoGRLog() )
						
						aAdd( aMsg, '<SUCESSO>' )
						aAdd( aMsg, '<value>F</value>' )
						aAdd( aMsg, '</SUCESSO>' )
						
						aAdd( aMsg, '<MENSAGEM>' )
						aAdd( aMsg, '<value>' )
						
						For nX := 1 To Len( aErro )
							
							aAdd( aMsg, _NoTags( aErro[ nX ] ) + Chr(13) + Chr(10)  )
							
						Next nX
						
						aAdd( aMsg, '</value>' )
						aAdd( aMsg, '</MENSAGEM>' )
						
					Else
						
						aAdd( aMsg, '<SUCESSO>' )
						aAdd( aMsg, '<value>T</value>' )
						aAdd( aMsg, '</SUCESSO>' )
						aAdd( aMsg, '<MENSAGEM>' )
						aAdd( aMsg, '<value>' )
						aAdd( aMsg, '</value>' )
						aAdd( aMsg, '</MENSAGEM>' )
						
					End If
					
					aAdd( aMsg, '</SD3_FIELD>' )
					
					If lMsErroAuto
						
						Disarmtransaction()
						Exit
						
					End IF
					
					If ! oXml:DOMNextNode()
						
						Exit
						
					End If
					
				End Do
				
			EndTran()
			
		End If
		
	Else
		
		aAdd( aMsg, '<SUCESSO>' )
		aAdd( aMsg, '<value>F</value>' )
		aAdd( aMsg, '</SUCESSO>' )
		aAdd( aMsg, '<MENSAGEM>' )
		aAdd( aMsg, '<value>' )
		aAdd( aMsg, 'Erro no Parse do XML: ' + oXml:LastError() )
		aAdd( aMsg, '</value>' )
		aAdd( aMsg, '</MENSAGEM>' )
		
	End If
	
	oFwEai:cReturnMsg := Retorno( aMsg )
	
	aSize( aMsg, 0 )
	
	aAdd( aMsg, '<SD3_FIELD>'       )
	aAdd( aMsg, '<SUCESSO>'        )
	aAdd( aMsg, '<value>' + If(  lMsErroAuto, 'F', 'T' ) + '</value>' )
	aAdd( aMsg, '</SUCESSO>'        )
	aAdd( aMsg, '<MENSAGEM>' )
	aAdd( aMsg, '<value>' )
	aAdd( aMsg, '</value>' )
	aAdd( aMsg, '</MENSAGEM>' )
	aAdd( aMsg, '</SD3_FIELD>' )
	
Return Retorno( aMsg )

Static Function Retorno( aMsg )
	
	Local cRet := ''
	Local nX   := 0
	
	cRet += '<MIOMT250>'
	
	For nX := 1 To Len( aMsg )
		
		cRet += aMsg[ nX ]
		
	Next nX
	
	cRet += '</MIOMT250>'
	
Return cRet
