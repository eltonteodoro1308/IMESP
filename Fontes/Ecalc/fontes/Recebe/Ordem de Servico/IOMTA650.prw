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
@return Caracter , Xml de retorno com a Imagem solicitado em formato Base64 ou erro de processamento
/*/
User Function IOMTA650( cXml, cError, cWarning, cParams, oFwEai )
	
	Local cMsg     := ''
	Local cSucesso := 'T' 
	Local oXml     := TXmlManager():New()
	Local aCpos    := {}
	Local nX       := 0
	Local aErro    := Nil
	Local cOrdSrv  := ''
	Local aArea    := GetArea()
	Local lExclui  := .F.
	Local lExiste  := .F.
	
	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.
	
	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )
		
		cOrdSrv := oXML:XPathGetNodeValue( '/MIOMT650/SC2_FIELD/C2_XOS/value' )
		
		DbSelectArea( 'SC2' )
		DBOrderNickname( 'XOS' )
		
		If lExiste := DbSeek( xFilial( 'SC2' ) + cOrdSrv )
			
			lExclui := ( oXML:XPathGetNodeValue( '/MIOMT650/SC2_FIELD/EXCLUI/value' ) == 'T' )
			
			aAdd( aCpos, { 'C2_NUM'     , SC2->( C2_NUM    ), Nil } )
			aAdd( aCpos, { 'C2_ITEM'    , SC2->( C2_ITEM   ), Nil } )
			aAdd( aCpos, { 'C2_SEQUEN'  , SC2->( C2_SEQUEN ), Nil } )
			
		End If
		
		RestArea( aArea )
		
		aAdd( aCpos, { 'C2_XOS'     ,       cOrdSrv                                                           , Nil } )
		aAdd( aCpos, { 'C2_XDES'    ,       oXML:XPathGetNodeValue( '/MIOMT650/SC2_FIELD/C2_XDES/value'    )  , Nil } )
		aAdd( aCpos, { 'C2_PRODUTO' ,       oXML:XPathGetNodeValue( '/MIOMT650/SC2_FIELD/C2_PRODUTO/value' )  , Nil } )
		aAdd( aCpos, { 'C2_QUANT'   , Val ( oXML:XPathGetNodeValue( '/MIOMT650/SC2_FIELD/C2_QUANT/value'   ) ), Nil } )
		aAdd( aCpos, { 'C2_DATPRI'  , StoD( oXML:XPathGetNodeValue( '/MIOMT650/SC2_FIELD/C2_DATPRI/value'  ) ), Nil } )
		aAdd( aCpos, { 'C2_DATPRF'  , StoD( oXML:XPathGetNodeValue( '/MIOMT650/SC2_FIELD/C2_DATPRF/value'  ) ), Nil } )
		aAdd( aCpos, { 'C2_EMISSAO' , StoD( oXML:XPathGetNodeValue( '/MIOMT650/SC2_FIELD/C2_EMISSAO/value' ) ), Nil } )
		aAdd( aCpos, { 'C2_TPOP'    ,       oXML:XPathGetNodeValue( '/MIOMT650/SC2_FIELD/C2_TPOP/value'    )  , Nil } )
		
		If lExiste
			
			MSExecAuto( { | X, Y | MATA650( X, Y ) }, aCpos, 5 )
			
			If ! lExclui
				
				MSExecAuto( { | X, Y | MATA650( X, Y ) }, aCpos, 3 )
				
			End If
			
		Else
			
			MSExecAuto( { | X, Y | MATA650( X, Y ) }, aCpos, 3 )
			
		End If
		
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
	
Return Retorno( cSucesso, cMsg )

Static Function Retorno( cSucesso, cMsg )
	
	Local cRet := ''
	
	cRet += '<MIOMT650>'
	cRet += '<SUCESSO>'
	cRet += '<value>' + cSucesso + '</value>'
	cRet += '</SUCESSO>'
//	cRet += '<IDRETORNO>'
//	cRet += '<value>str1234</value>'
//	cRet += '</IDRETORNO>'
	cRet += '<MENSAGEM>'
	cRet += '<value>' + cMsg + '</value>'
	cRet += '</MENSAGEM>'
	cRet += '</MIOMT650>'
	
Return cRet
