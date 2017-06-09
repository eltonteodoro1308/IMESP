#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOMTA410
Função acionada pelo EAI que recebe xml com dados do pedido venda e faz sua inclusão
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
User Function IOMTA410( cXml, cError, cWarning, cParams, oFwEai )
	
	Local cMsg    := ''
	Local oXml    := TXmlManager():New()
	Local aCabec  := {}
	Local aItem   := {}
	Local aItens  := {}
	Local aChild  := Nil
	Local nX      := 0
	Local aErro   := Nil
	Local cSucesso:= 'T'
	Local nItem   := 1
	
	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.
	
	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )
		
		aAdd( aCabec, { 'C5_TIPO'     , 'N'                                                                          , Nil } )
		aAdd( aCabec, { 'C5_CLIENTE'  , oXML:XPathGetNodeValue( '/MIOMT410/SC5_FIELD/C5_CLIENTE/value' ) , Nil } )
		//		aAdd( aCabec, { 'C5_LOJACLI'  , '01'                                                                         , Nil } )
		//		aAdd( aCabec, { 'C5_TIPOCLI'  , 'F'                                                                          , Nil } )
		aAdd( aCabec, { 'C5_CONDPAG'  , oXML:XPathGetNodeValue( '/MIOMT410/SC5_FIELD/C5_CONDPAG/value' ) , Nil } )
		aAdd( aCabec, { 'C5_TRANSP'   , oXML:XPathGetNodeValue( '/MIOMT410/SC5_FIELD/C5_TRANSP/value'  ) , Nil } )
		aAdd( aCabec, { 'C5_XVENDAID' , oXML:XPathGetNodeValue( '/MIOMT410/SC5_FIELD/C5_NUM/value'     ) , Nil } )
		
		oXml:DOMChildNode()
		oXml:DOMChildNode()
		
		Do While AllWaysTrue()
			
			oXml:DOMNextNode()
			
			If oXml:cName == 'SC6_GRID'
				
				Exit
				
			End If
			
		End Do
		
		oXml:DOMChildNode()
		oXml:DOMChildNode()
		
		Do While AllWaysTrue()
			
			aChild := oXML:DOMGetChildArray()
			
			aAdd( aItem, { 'C6_ITEM', StrZero( nItem, TamSx3( 'C6_ITEM' )[ 1 ] ), Nil} )
			
			For nX := 1 To Len( aChild  )
				
				If ! AllTrim( aChild[ nX, 1 ] ) $ 'C6_QTDVEN/C6_PRCVEN/C6_VALDESC'
					
					aAdd( aItem, { aChild[ nX, 1 ], aChild[ nX, 2 ], Nil} )
					
				Else
					
					aAdd( aItem, { aChild[ nX, 1 ], Val( aChild[ nX, 2 ] ) , Nil} )
					
				End If
				
			Next nX
			
			aAdd( aItens, aClone( aItem ) )
			
			aSize( aItem, 0 )
			
			If ! oXml:DOMNextNode()
				
				Exit
				
			End If
			
			nItem++
			
		End Do
		
		MSExecAuto( { | X, Y, Z | MATA410( X, Y, Z ) }, aCabec, aItens, 3 )
		
		If lMsErroAuto
			
			cSucesso := 'F'
			
			aErro := aClone( GetAutoGRLog() )
			
			cMsg += Chr(13) + Chr(10)
			
			For nX := 1 To Len( aErro )
				
				cMsg += _NoTags( aErro[ nX ] ) + Chr(13) + Chr(10)
				
			Next nX
			
		End If
		
	Else
		
		cSucesso := 'F'
		cMsg := 'Erro no Parse do XML: ' + oXml:LastError()
		
	End If
	
Return Retorno( cSucesso, cMsg, oFwEai )

Static Function Retorno( cSucesso, cMsg, oFwEai )
	
	Local cRet := ''
	
	cRet += '<MIOMT410>'
	cRet += '<SC5_FIELD>'
	cRet += '<SUCESSO>'
	cRet += '<value>' + cSucesso + '</value>'
	cRet += '</SUCESSO>'
	cRet += '<MENSAGEM>'
	cRet += '<value>' + cMsg + '</value>'
	cRet += '</MENSAGEM>'
	cRet += '</SC5_FIELD>'
	cRet += '</MIOMT410>'
	
	oFwEai:cReturnMsg := cRet
	
Return cRet
