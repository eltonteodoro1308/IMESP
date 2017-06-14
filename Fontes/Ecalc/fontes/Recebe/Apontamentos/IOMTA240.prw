#Include 'TOTVS.CH'
/*/{Protheus.doc} IOAPONTA
Função acionada pelo EAI que recebe xml com dados dos apontamentos.
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
User Function IOMTA240( cXml, cError, cWarning, cParams, oFwEai )
	
	Local oXml     := TXmlManager():New()
	Local aAponts  := {}
	Local aAux     := {}
	Local aAtt     := {}
	local cReg     := ''
	Local nOpc     := 0
	Local aMsg     := {}
	Local cOrdSrv  := ''
	Local cCC      := ''
	Local cDoc     := ''
	Local cDataIni := ''
	Local cHoraIni := ''
	Local cDataFin := ''
	Local cHoraFin := ''
	Local nX       := ''
	Local aErro    := {}
	
	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.
	
	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )
		
		If oXml:DOMChildNode()
			
			Do While .T.
				
				aAtt   := oXml:DOMGetAttArray()
				
				cReg := aAtt[ aScan( aAtt  , { | X | AllTrim( X[ 1 ] ) == 'Registro' } ) ][ 2 ]
				nOpc := Val( aAtt[ aScan( aAtt  , { | X | AllTrim( X[ 1 ] ) == 'Operation' } ) ][ 2 ] )
				
				oXml:DOMChildNode()
				
				Do While .T.
					
					If oXml:cName == 'D3_XOS
						
						oXml:DOMChildNode()
						
						cOrdSrv :=  oXml:cText
						
						oXml:DOMParentNode()
						
						
					ElseIf oXml:cName == 'D3_CC'
						
						oXml:DOMChildNode()
						
						cCC := oXml:cText
						
						oXml:DOMParentNode()
						
					ElseIf oXml:cName == 'D3_DOC'
						
						oXml:DOMChildNode()
						
						cDoc := oXml:cText
						
						oXml:DOMParentNode()
						
					ElseIf oXml:cName == 'D3_DATAINI'
						
						oXml:DOMChildNode()
						
						cDataIni := oXml:cText
						
						oXml:DOMParentNode()
						
					ElseIf oXml:cName == 'D3_HORAINI'
						
						oXml:DOMChildNode()
						
						cHoraIni := oXml:cText
						
						oXml:DOMParentNode()
						
					ElseIf oXml:cName == 'D3_DATAFIN'
						
						oXml:DOMChildNode()
						
						cDataFin := oXml:cText
						
						oXml:DOMParentNode()
						
					ElseIf oXml:cName == 'D3_HORAFIN'
						
						oXml:DOMChildNode()
						
						cHoraFin := oXml:cText
						
						oXml:DOMParentNode()
						
					End If
					
					If ! oXml:DOMNextNode()
						
						Exit
						
					End If
					
				End Do
				
				oXml:DOMParentNode()
				
				aAux := DaysList( cDataIni, cHoraIni, cDataFin, cHoraFin, cOrdSrv, cCC, cDoc )
				
				For nX := 1 To Len( aAux )
					
					aAdd( aAponts, { nOpc, cReg, aAux[ nX ] } )
					
				Next nX
				
				aSize( aAux, 0 )
				
				If ! oXml:DOMNextNode()
					
					Exit
					
				End If
				
			End Do
			
			BeginTran()
				
				For nX := 1 To Len( aAponts )
					
					If aAponts[ nX, 1 ] == 3
						
						MSExecAuto( { | X, Y | MATA240( X, Y ) }, aAponts[ nX, 3 ] , 3 )
						
					Else
						
						//EstornaMov( cDoc )
						
					End If
					
					aAdd( aMsg, '<SD3_FIELD Registro="' + aAponts[ nX, 2 ] + '">' )
					
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
					
				Next nX
				
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
		
		lMsErroAuto := .T.
		
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
	
	cRet += '<MIOMT240>'
	
	For nX := 1 To Len( aMsg )
		
		cRet += aMsg[ nX ]
		
	Next nX
	
	cRet += '</MIOMT240>'
	
Return cRet

Static Function DaysList( cDataIni, cHoraIni, cDataFin, cHoraFin, cOrdSrv, cCC, cDoc )
	
	Local aRet     := {}
	Local nX       := 0
	Local cDtAux   := ''
	Local cTipoMov := GetMv( 'IO_TMAPONT' )
	Local cOp      := ''
	Local nDiasDif := DateDiffDay( StoD( cDataIni ), StoD( cDataFin ) ) + 1
	Local aArea    := {}
	Local nQuant   := 0
	
	aArea := GetArea()
	
	DbSelectArea( 'SC2' )
	DBOrderNickname( 'XOS' )
	
	If DbSeek( xFilial( 'SC2' ) + cOrdSrv )
		
		cOp    := SC2->( C2_NUM + C2_ITEM + C2_SEQUEN )
		
	End If
	
	RestArea( aArea )
	
	For nX := 1 To nDiasDif
		
		If cDataIni == cDataFin
			
			nQuant := CalcHoras( cDataIni, cHoraIni, cDataFin, cHoraFin )
			
			aAdd( aRet, {;
				{ 'D3_TM'      , cTipoMov         , Nil },;
				{ 'D3_COD'     , 'MOD' + cCC      , Nil },;
				{ 'D3_QUANT'   , nQuant           , Nil },;
				{ 'D3_OP'      , cOP              , Nil },;
				{ 'D3_DOC'     , cDoc             , Nil },;
				{ 'D3_EMISSAO' , StoD( cDataIni ) , Nil } } )
			
			Return aRet
			
		Else
			
			If nX == 1
				
				nQuant := CalcHoras( cDataIni, cHoraIni, cDataIni, '23:59' )
				
				aAdd( aRet, {;
					{ 'D3_TM'      , cTipoMov         , Nil },;
					{ 'D3_COD'     , 'MOD' + cCC      , Nil },;
					{ 'D3_QUANT'   , nQuant           , Nil },;
					{ 'D3_OP'      , cOP              , Nil },;
					{ 'D3_DOC'     , cDoc             , Nil },;
					{ 'D3_EMISSAO' , Stod( cDataIni ) , Nil } } )
				
				cDtAux := DtoS( DaySum( StoD( cDataIni ), nX ) )
				
			ElseIf nX == nDiasDif
				
				nQuant := CalcHoras( cDataFin, '00:00', cDataFin, cHoraFin )
				
				aAdd( aRet, {;
					{ 'D3_TM'      , cTipoMov         , Nil },;
					{ 'D3_COD'     , 'MOD' + cCC      , Nil },;
					{ 'D3_QUANT'   , nQuant           , Nil },;
					{ 'D3_OP'      , cOP              , Nil },;
					{ 'D3_DOC'     , cDoc             , Nil },;
					{ 'D3_EMISSAO' , StoD( cDataFin ) , Nil } } )
				
			Else
				
				nQuant := CalcHoras( cDtAux, '00:00', cDtAux, '23:59' )
				
				aAdd( aRet, {;
					{ 'D3_TM'      , cTipoMov       , Nil },;
					{ 'D3_COD'     , 'MOD' + cCC    , Nil },;
					{ 'D3_QUANT'   , nQuant         , Nil },;
					{ 'D3_OP'      , cOP            , Nil },;
					{ 'D3_DOC'     , cDoc           , Nil },;
					{ 'D3_EMISSAO' , StoD( cDtAux ) , Nil } } )
				
				cDtAux := DtoS( DaySum( StoD( cDataIni ), nX ) )
				
			End If
			
		End If
		
	Next nX
	
Return aRet

Static Function CalcHoras( cDataIni, cHoraIni, cDataFin, cHoraFin )
	
	Local nRet := 0
	
	nRet := Val( FwTimeStamp( 4, StoD( cDataFin ) , cHoraFin + ':00') )
	nRet := nRet - Val( FwTimeStamp( 4, StoD( cDataIni ) , cHoraIni + ':00' ) )
	nRet := nRet / ( 60 * 60 )
	
Return nRet

static function EstornaMov( cDoc )
	
	Local aVetor      := {}
	Local nX          := 0
	
	DbSelectArea( 'SD3' )
	DbSetOrder( 2 )
	
	If DbSeek( xFilial( 'SD3' ) + cDoc )
		
		For nX := 1 To FCount()
			
			aAdd( aVetor, { FieldName( nX ), SD3->&( FieldName( nX ) ), Nil } )
			
		Next Nx
		
		aAdd( aVetor, { 'INDEX', 2, Nil } )
		
		MSExecAuto( { | X, Y | MATA240( X, Y ) }, aVetor, 5 )
		
	End If
	
return
