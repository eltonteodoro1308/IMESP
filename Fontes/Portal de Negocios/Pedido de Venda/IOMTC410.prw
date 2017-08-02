#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
/*/{Protheus.doc} IOMTC410
Função acionada pelo EAI que recebe xml com dados do pedido venda e faz sua inclusão
@author Elton Teodoro Alves
@since 11/07/2017
@version Protheus 12.1.016
@param cXml    , Caracter, O conteúdo da tag Content do XML recebido pelo EAI Protheus.
@param cError  , Caracter, Variável passada por referência, serve para alimentar a mensagem de erro, nos casos em que a transação não foi bem sucedida.
@param cWarning, Caracter, Variável passada por referência, serve para alimentar uma mensagem de warning para o EAI. A alteração deste valor por rotinas tratadas neste tópico não causam nenhum efeito para o EAI.
@param cParams , Caracter, Parâmetros passados na mensagem do EAI.
@param oFwEai  , Object  , O objeto de EAI criado na camada do EAI Protheus. A manipulação deste objeto deve ser realizada com o máximo de cautela, e deve ser evitada ao máximo.
@return cRet   , Xml de retorno status da operação
/*/
user function IOMTC410( cXml, cError, cWarning, cParams, oFwEai )
	
	Local oModel   := Nil
	Local aParams  := StrTokArr2( cParams, ',', .T. )
	Local cVendaId := aParams[ 1 ]
	Local cSistem  := aParams[ 2 ]
	
	DbSelectArea( 'SC5' )
	DBOrderNickname( 'XVENDID' )
	
	cSistem  := PadR( cSistem , GetSx3Cache( 'C5_XSISTEM', 'X3_TAMANHO' ) )
	cVendaId := PadR( cVendaId, GetSx3Cache( 'C5_XVENDID', 'X3_TAMANHO' ) )
	
	If DbSeek( xFilial( 'SC5' ) + cVendaId + cSistem )
		
		oModel := ModelDef()
		
		oModel:SetOperation( 1 )
		
		oModel:Activate()
		
		oFwEai:cReturnMsg := DecodeUTF8( oModel:GetXMLData( ,,, .T.,, .T. ) )
		
		oModel:DeActivate()
		
	Else
		
		oFwEai:cReturnMsg += '<MIOMC410_RET>'
		oFwEai:cReturnMsg += '<SC5_FIELD>'
		oFwEai:cReturnMsg += '<ERRO>'
		oFwEai:cReturnMsg += 'Pedido não Localizado'
		oFwEai:cReturnMsg += '</ERRO>'
		oFwEai:cReturnMsg += '</SC5_FIELD>'
		oFwEai:cReturnMsg += '</MIOMC410_RET>'
		
	EndIf
	
return oFwEai:cReturnMsg
/*/{Protheus.doc} ModelDef
//Retorna o Modelo de Dados do Pedido de Vendas
@author Elton Teodoro Alves
@since 11/07/2017
@version Protheus 12.1.016
/*/
Static Function ModelDef()
	
	Local oModel  := MPFormModel():New('MIOMC410_RET')
	Local cCpoSC5 := ''
	Local cCpoSC6 := ''
	Local oStrSC5 := Nil
	Local oStrSC6 := Nil
	
	cCpoSC5 += '/C5_NUM/'
	cCpoSC5 += '/C5_XSISTEM/'
	cCpoSC5 += '/C5_XVENDID/'
	cCpoSC5 += '/C5_XIDCPGT/'
	cCpoSC5 += '/C5_CLIENTE/'
	cCpoSC5 += '/C5_CONDPAG/'
	cCpoSC5 += '/C5_MSBLQL/'
	cCpoSC5 += '/C5_MENNOTA/'
	cCpoSC5 += '/C5_XOBSNF/'
	cCpoSC5 += '/C5_TPFRETE/'
	cCpoSC5 += '/C5_FRETE/'
	cCpoSC5 += '/C5_PBRUTO/'
	cCpoSC5 += '/C5_PESOL/'
	cCpoSC5 += '/C5_FRETE/'
	
	oStrSC5 := FWFormStruct( 1, 'SC5', { | cCpo | '/' + AllTrim( cCpo ) + '/' $ cCpoSC5 } )
	
	oStrSC5:AddField( 'Total Bruto'    , 'Total Bruto'    , 'C5_XVLRBRT' , 'N', 16, 2, , , {}, .F.,{ | oModSC5 | CalcVlrLiq( oModSC5 ) + CalcVlrDsc( oModSC5 ) } , .F., .F., .T., , )
	oStrSC5:AddField( 'Total Desconto' , 'Total Desconto' , 'C5_XVLRDSC' , 'N', 16, 2, , , {}, .F.,{ | oModSC5 | CalcVlrDsc( oModSC5 ) } , .F., .F., .T., , )
	oStrSC5:AddField( 'Total Líquido'  , 'Total Líquido'  , 'C5_XVLRLIQ' , 'N', 16, 2, , , {}, .F.,{ | oModSC5 | CalcVlrLiq( oModSC5 ) } , .F., .F., .T., , )
	
	cCpoSC6 += '/C6_PRODUTO/'
	cCpoSC6 += '/C6_QTDVEN/'
	cCpoSC6 += '/C6_PRCVEN/'
	cCpoSC6 += '/C6_TES/'
	
	oStrSC6 := FWFormStruct( 1, 'SC6', { | cCpo | '/' + AllTrim( cCpo ) + '/' $ cCpoSC6 } )
	
	oModel:addFields('SC5_FIELD',,oStrSC5)
	oModel:addGrid('SC6_GRID','SC5_FIELD',oStrSC6)
	oModel:SetRelation('SC6_GRID', { { 'C6_FILIAL', 'C5_FILIAL' }, { 'C6_NUM', 'C5_NUM' } }, SC6->(IndexKey(1)) )
	
	oModel:SetDescription('Pedido de Venda')
	oModel:getModel('SC5_FIELD'):SetDescription('Cabeçalho do Pedido de Venda')
	oModel:getModel('SC6_GRID'):SetDescription('Itens do Pedido de Venda')
	
Return oModel
/*/{Protheus.doc} CalcVlrBrt
Inicializador Padrão do Campo Virtual C5_XVLRLIQ com o Total Bruto do Pedido 
@author Elton Teodoro Alves
@since 20/07/2017
@version 12.1.017
@param oModSC5, Object, Objeto do model SC5_FIELD
@return Number, Total Bruto do Pedido 
/*/
Static Function CalcVlrLiq( oModSC5 )
	
	Local nRet    := 0
	Local cPedido := oModSC5:GetValue( 'C5_NUM' )
	Local aArea   := GetArea()
	Local cSeek   := FWxFilial( 'SC6' ) + cPedido
	
	DbSelectArea( 'SC6' )
	DbSetOrder( 1 )
	
	If DbSeek( cSeek )
		
		Do While ! Eof() .And. cSeek == SC6->( C6_FILIAL + C6_NUM )
			
			nRet += SC6->C6_VALOR
			
			DbSkip()
			
		End Do
		
	End If
	
	RestArea( aArea )
	
Return nRet
/*/{Protheus.doc} CalcVlrDsc
Inicializador Padrão do Campo Virtual C5_XVLRBRT com o Total do Desconto 
@author Elton Teodoro Alves
@since 20/07/2017
@version 12.1.017
@param oModSC5, Object, Objeto do model SC5_FIELD
@return Number, Total do Desconto 
/*/
Static Function CalcVlrDsc( oModSC5 )
	
	Local nRet    := 0
	Local cPedido := oModSC5:GetValue( 'C5_NUM' )
	Local aArea   := GetArea()
	Local cSeek   := FWxFilial( 'SC6' ) + cPedido
	
	DbSelectArea( 'SC6' )
	DbSetOrder( 1 )
	
	If DbSeek( cSeek )
		
		Do While ! Eof() .And. cSeek == SC6->( C6_FILIAL + C6_NUM )
			
			nRet += SC6->C6_VALDESC
			
			DbSkip()
			
		End Do
		
	End If
	
	RestArea( aArea )
	
Return nRet
