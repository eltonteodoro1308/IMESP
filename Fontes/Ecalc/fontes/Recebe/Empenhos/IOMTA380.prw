#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOMTA380
Função acionada pelo EAI que recebe xml com dados do empenho da OP
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
User Function IOMTA380( cXml, cError, cWarning, cParams, oFwEai )
	
	Local cRet    := ''
	Local oXml    := TXmlManager():New()
	Local aCpos   := {}
	Local nX      := 0
	Local aErro   := Nil
	Local cOrdSrv := ''
	Local aArea   := GetArea()
	Local lExclui := .F.
	Local lExiste := .F.
	Local cOp     := ''
	Local cCod    := ''
	Local cLocal  := ''
	
	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.
	
	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )
		
		cOrdSrv := oXML:XPathGetNodeValue( '/IOMTA380/SD4_FIELD/D4_XOS/value' )
		lExclui := ( oXML:XPathGetNodeValue( '/IOMTA380/SD4_FIELD/EXCLUI/value' ) == 'T' )
		
		DbSelectArea( 'SC2' )
		DBOrderNickname( 'XOS' )
		
		If DbSeek( xFilial( 'SC2' ) + cOrdSrv )
			
			cOp := SC2->( C2_NUM + C2_ITEM + C2_SEQUEN )
			cOp += Space( TamSx3( 'D4_OP' )[1] - Len( cOp )  )
			
		End If
		
		RestArea( aArea )
		
		cCod   := oXML:XPathGetNodeValue( '/IOMTA380/SD4_FIELD/D4_COD/value' )
        cCod   += Space( TamSx3( 'D4_COD' )[1] - Len( cCod )  ) 
		
		cLocal := oXML:XPathGetNodeValue( '/IOMTA380/SD4_FIELD/D4_LOCAL/value' )
		cLocal += Space( TamSx3( 'D4_LOCAL' )[1] - Len( cLocal )  )
		
		DbSelectArea( 'SD4' )
		DBSetOrder( 2 )
		
		lExiste := DbSeek( xFilial( 'SD4' ) + cOp + cCod + cLocal )
		
		RestArea( aArea )
		
		aAdd( aCpos, { 'D4_COD'     ,      cCod                                                               , Nil } )
		aAdd( aCpos, { 'D4_LOCAL'   ,      cLocal                                                             , Nil } )
		aAdd( aCpos, { 'D4_OP'      ,      cOp                                                                , Nil } )
		aAdd( aCpos, { 'D4_QTDEORI' , Val( oXML:XPathGetNodeValue( '/IOMTA380/SD4_FIELD/D4_QTDEORI/value' ) ) , Nil } )
		aAdd( aCpos, { 'D4_QUANT'   , Val( oXML:XPathGetNodeValue( '/IOMTA380/SD4_FIELD/D4_QUANT/value'   ) ) , Nil } )
		
		If lExiste
			
			MSExecAuto( { | X, Y | MATA380( X, Y ) }, aCpos, 5 )
			
			If ! lExclui
				
				MSExecAuto( { | X, Y | MATA380( X, Y ) }, aCpos, 3 )
				
			End If
			
		Else
			
			MSExecAuto( { | X, Y | MATA380( X, Y ) }, aCpos, 3 )
			
		End If
		
		If lMsErroAuto
			
			aErro := aClone( GetAutoGRLog() )
			
			cRet += Chr(13) + Chr(10)
			
			For nX := 1 To Len( aErro )
				
				cRet += aErro[ nX ] + Chr(13) + Chr(10)
				
			Next nX
			
		Else
			
			cRet := 'OK'
			
		End If
		
	Else
		
		cRet := 'Erro no Parse do XML: ' + oXml:LastError()
		
	End If
	
Return cRet
