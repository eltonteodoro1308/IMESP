#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOMTA380
Fun��o acionada pelo EAI que recebe xml com dados do empenho da OP
@author Elton Teodoro Alves
@since 04/05/2016
@version Protheus 12.1.014
@param cXml    , Caracter, O conte�do da tag Content do XML recebido pelo EAI Protheus.
@param cError  , Caracter, Vari�vel passada por refer�ncia, serve para alimentar a mensagem de erro, nos casos em que a transa��o n�o foi bem sucedida.
@param cWarning, Caracter, Vari�vel passada por refer�ncia, serve para alimentar uma mensagem de warning para o EAI. A altera��o deste valor por rotinas tratadas neste t�pico n�o causam nenhum efeito para o EAI.
@param cParams , Caracter, Par�metros passados na mensagem do EAI.
@param oFwEai  , Object  , O objeto de EAI criado na camada do EAI Protheus. A manipula��o deste objeto deve ser realizada com o m�ximo de cautela, e deve ser evitada ao m�ximo.
@return Caracter , Xml de retorno com a Imagem solicitado em formato Base64 ou erro de processamento
/*/
User Function IOMTA380( cXml, cError, cWarning, cParams, oFwEai )
	
	Local cMsg     := ''
	Local cSucesso := 'T'
	Local oXml     := TXmlManager():New()
	Local aCpos    := {}
	Local nX       := 0
	Local aErro    := Nil
	Local cOrdSrv  := ''
	Local aArea    := GetArea()
	Local lExiste  := .F.
	Local nOper    := 0
	Local cOp      := ''
	Local cCod     := ''
	Local cLocal   := ''
	
	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.
	
	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )
		
		nOper := Val( oXml:XPathGetAtt( '/MIOMT380', 'Operation' ) )
		
		cOrdSrv := oXML:XPathGetNodeValue( '/MIOMT380/SD4_FIELD/D4_XOS/value' )
		
		DbSelectArea( 'SC2' )
		DBOrderNickname( 'XOS' )
		
		If DbSeek( xFilial( 'SC2' ) + cOrdSrv )
			
			cOp := SC2->( C2_NUM + C2_ITEM + C2_SEQUEN )
			cOp += Space( TamSx3( 'D4_OP' )[1] - Len( cOp )  )
			
		End If
		
		RestArea( aArea )
		
		cCod   := oXML:XPathGetNodeValue( '/MIOMT380/SD4_FIELD/D4_COD/value' )
		cCod   += Space( TamSx3( 'D4_COD' )[1] - Len( cCod )  )
		
		//cLocal := oXML:XPathGetNodeValue( '/MIOMT380/SD4_FIELD/D4_LOCAL/value' )
		//cLocal += Space( TamSx3( 'D4_LOCAL' )[1] - Len( cLocal )  )
		
		DbSelectArea( 'SD4' )
		DBSetOrder( 2 )
		
		lExiste := DbSeek( xFilial( 'SD4' ) + cOp + cCod /*+ cLocal*/ )
		
		RestArea( aArea )
		
		aAdd( aCpos, { 'D4_COD'     ,      cCod                                                               , Nil } )
		//aAdd( aCpos, { 'D4_LOCAL'   ,      cLocal                                                             , Nil } )
		aAdd( aCpos, { 'D4_OP'      ,      cOp                                                                , Nil } )
		aAdd( aCpos, { 'D4_QTDEORI' , Val( oXML:XPathGetNodeValue( '/MIOMT380/SD4_FIELD/D4_QTDEORI/value' ) ) , Nil } )
		aAdd( aCpos, { 'D4_QUANT'   , Val( oXML:XPathGetNodeValue( '/MIOMT380/SD4_FIELD/D4_QUANT/value'   ) ) , Nil } )
		
		If lExiste .And. nOper == 3
			
			nOper := 4
			
		End If	
		
		MSExecAuto( { | X, Y | MATA380( X, Y ) }, aCpos, nOper )		
		
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
	
	cRet += '<MIOMT380>'
	cRet += '<SD4_FIELD>'
	cRet += '<SUCESSO>'
	cRet += '<value>' + cSucesso + '</value>'
	cRet += '</SUCESSO>'
	cRet += '<MENSAGEM>'
	cRet += '<value>' + cMsg + '</value>'
	cRet += '</MENSAGEM>'
	cRet += '</SD4_FIELD>'
	cRet += '</MIOMT380>'
	
	oFwEai:cReturnMsg := cRet
	
Return cRet
