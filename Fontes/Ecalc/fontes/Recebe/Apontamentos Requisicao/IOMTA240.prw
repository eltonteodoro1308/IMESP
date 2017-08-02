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
	Local aMsg     := {}

	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.

	If oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML )

		oXml:DOMChildNode()

		Do While .T.

			//BeginTran()

			If cParams == 'APONT'

				Aponta( oXml, @aMsg )

			ElseIf cParams == 'REQUIS'

				Requisita( oXml, @aMsg )

			End If

			If lMsErroAuto

				Disarmtransaction()

				Exit

			End If

			//EndTran()

			If ! oXml:DOMNextNode()

				Exit

			End If

		End Do

	Else

		BuildMsg( @aMsg, 'F', 'Erro no Parse do XML: ' + oXml:LastError(), '0' )

	End If

	oFwEai:cReturnMsg := Retorno( aMsg )

return oFwEai:cReturnMsg

Static Function Retorno( aMsg )

	Local cRet := ''
	Local nX   := 0

	cRet += '<MIOMT240>'

	For nX := 1 To Len( aMsg )

		cRet += aMsg[ nX ]

	Next nX

	cRet += '</MIOMT240>'

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

Static Function Aponta( oXml, aMsg )

	Local cTipoMov := GetMv( 'IO_TMAPONT' )
	Local cTpDoc   := '2'
	Local cDoc     := ''
	Local cOrdSrv  := ''
	Local cOp      := ''
	Local cCC      := ''
	Local cCod     := ''
	Local cDataIni := ''
	Local cHoraIni := ''
	Local cDataFin := ''
	Local cHoraFin := ''
	Local nQuant   := 0
	Local cLocal   := ''
	Local aAtt     := {}
	Local cReg     := ''
	Local nOpc     := 0
	Local aArea    := GetArea()
	Local dEmissao := CtoD('')
	Local aCpos    := {}

	aAtt := oXml:DOMGetAttArray()

	cReg := aAtt[ aScan( aAtt  , { | X | AllTrim( X[ 1 ] ) == 'Registro' } ) ][ 2 ]
	nOpc := Val( aAtt[ aScan( aAtt  , { | X | AllTrim( X[ 1 ] ) == 'Operation' } ) ][ 2 ] )

	CargaApont( oXml, @cDoc, @cOrdSrv, @cCC, @cDataIni, @cHoraIni, @cDataFin, @cHoraFin )

	DbSelectArea( 'SC2' )
	DBOrderNickname( 'XOS' )

	If ! Empty( cOrdSrv )

		If  DbSeek( xFilial( 'SC2' ) + cOrdSrv )

			cOp    := SC2->( C2_NUM + C2_ITEM + C2_SEQUEN )

		Else

			BuildMsg( @aMsg, 'F', 'OS ' + cOrdSrv + ' não localizada.', cReg )

			Return

		End If

	End If

	RestArea( aArea )

	cCod := 'MOD' + cCC

	nQuant := CalcHoras( cDataIni, cHoraIni, cDataFin, cHoraFin )

	cLocal := cLocal := Posicione( 'SB1', 1, xFilial( 'SB1' ) + cCod, 'B1_LOCPAD' )

	dEmissao := StoD( cDataIni )

	If cHoraIni < '06:01:00'

		dEmissao := dEmissao - 1

	End If

	aAdd( aCpos, { 'D3_TM'      , cTipoMov , Nil } )
	aAdd( aCpos, { 'D3_QUANT'   , nQuant   , Nil } )
	aAdd( aCpos, { 'D3_OP'      , cOP      , Nil } )
	aAdd( aCpos, { 'D3_CC'      , cCC      , Nil } )
	aAdd( aCpos, { 'D3_COD'     , cCod     , Nil } )
	aAdd( aCpos, { 'D3_LOCAL'   , cLocal   , Nil } )
	aAdd( aCpos, { 'D3_XOS'     , cOrdSrv  , Nil } )
	aAdd( aCpos, { 'D3_XTPDOC'  , cTpDoc   , Nil } )
	aAdd( aCpos, { 'D3_XDECALC' , cDoc     , Nil } )
	aAdd( aCpos, { 'D3_EMISSAO' , Date()   , Nil } )

	Grava( aCpos, @aMsg, cReg, cOrdSrv, cTpDoc, cDoc, nOpc )

Return

Static Function CargaApont( oXml, cDoc, cOrdSrv, cCC, cDataIni, cHoraIni, cDataFin, cHoraFin )

	oXml:DOMChildNode()

	Do While .T.

		If oXml:cName == 'D3_DOC'

			oXml:DOMChildNode()

			cDoc := oXml:cText

			oXml:DOMParentNode()

		ElseIf oXml:cName == 'D3_XOS'

			oXml:DOMChildNode()

			cOrdSrv := oXml:cText

			oXml:DOMParentNode()

		ElseIf oXml:cName == 'D3_CC'

			oXml:DOMChildNode()

			cCC := oXml:cText

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

Return

Static Function  Requisita( oXml, aMsg )

	Local cTipoMov := GetMv( 'IO_TMREQUI' )
	Local cTpDoc   := '3'
	Local cDoc     := ''
	Local cOrdSrv  := ''
	Local cOp      := ''
	Local cCod     := ''
	Local nQuant   := 0
	Local cLocal   := ''
	Local aAtt     := {}
	Local cReg     := ''
	Local nOpc     := 0
	Local aArea    := GetArea()
	Local aCpos    := {}

	aAtt := oXml:DOMGetAttArray()

	cReg := aAtt[ aScan( aAtt  , { | X | AllTrim( X[ 1 ] ) == 'Registro' } ) ][ 2 ]
	nOpc := Val( aAtt[ aScan( aAtt  , { | X | AllTrim( X[ 1 ] ) == 'Operation' } ) ][ 2 ] )

	CargaReq( oXml, @cDoc, @cOrdSrv, @cCod, @nQuant, @cLocal )

	DbSelectArea( 'SC2' )
	DBOrderNickname( 'XOS' )

	If ! Empty( cOrdSrv )

		If  DbSeek( xFilial( 'SC2' ) + cOrdSrv )

			cOp    := SC2->( C2_NUM + C2_ITEM + C2_SEQUEN )

		Else

			BuildMsg( @aMsg, 'F', 'OS ' + cOrdSrv + ' não localizada.', cReg )

			Return

		End If

	Else

		BuildMsg( @aMsg, 'F', 'OS não informada.', cReg )

	End If

	RestArea( aArea )

	aAdd( aCpos, { 'D3_TM'      , cTipoMov , Nil } )
	aAdd( aCpos, { 'D3_QUANT'   , nQuant   , Nil } )
	aAdd( aCpos, { 'D3_OP'      , cOP      , Nil } )
	aAdd( aCpos, { 'D3_COD'     , cCod     , Nil } )
	aAdd( aCpos, { 'D3_LOCAL'   , cLocal   , Nil } )
	aAdd( aCpos, { 'D3_XOS'     , cOrdSrv  , Nil } )
	aAdd( aCpos, { 'D3_XTPDOC'  , cTpDoc   , Nil } )
	aAdd( aCpos, { 'D3_XDECALC' , cDoc     , Nil } )
	aAdd( aCpos, { 'D3_EMISSAO' , Date()   , Nil } )

	Grava( aCpos, @aMsg, cReg, cOrdSrv, cTpDoc, cDoc, nOpc )

Return

Static Function CargaReq( oXml, cDoc, cOrdSrv, cCod, nQuant, cLocal )

	oXml:DOMChildNode()

	Do While .T.

		If oXml:cName == 'D3_DOC'

			oXml:DOMChildNode()

			cDoc := oXml:cText

			oXml:DOMParentNode()

		ElseIf oXml:cName == 'D3_XOS'

			oXml:DOMChildNode()

			cOrdSrv := oXml:cText

			oXml:DOMParentNode()

		ElseIf oXml:cName == 'D3_COD'

			oXml:DOMChildNode()

			cCod := oXml:cText

			oXml:DOMParentNode()

		ElseIf oXml:cName == 'D3_QUANT'

			oXml:DOMChildNode()

			nQuant := Val( oXml:cText )

			oXml:DOMParentNode()


		ElseIf oXml:cName == 'D3_LOCAL'

			oXml:DOMChildNode()

			cLocal := oXml:cText

			oXml:DOMParentNode()

		End If

		If ! oXml:DOMNextNode()

			Exit

		End If

	End Do

	oXml:DOMParentNode()

Return

Static Function CalcHoras( cDataIni, cHoraIni, cDataFin, cHoraFin )

	Local nRet  := 0

	nRet := Val( FwTimeStamp( 4, StoD( cDataFin ) , SubStr( cHoraFin, 1, 8 ) ) ) + ( Val( SubStr( cHoraFin, 10, 3 ) ) )/1000
	nRet := nRet - Val( FwTimeStamp( 4, StoD( cDataIni ) , SubStr( cHoraIni, 1, 8 ) ) ) + ( Val( SubStr( cHoraIni, 10, 3 ) ) )/1000
	nRet := nRet / ( 60 * 60 )

Return nRet

Static Function Grava( aCpos, aMsg, cReg, cOrdSrv, cTpDoc, cDoc, nOpc )

	If lMsErroAuto := Empty( cDoc )

		BuildMsg( @aMsg, 'F', 'Documento não informado.', cReg )

	End If

	If ! lMsErroAuto

		Estorna( cTpDoc, cDoc, @aMsg, cReg, nOpc )

	End If

	If ! lMsErroAuto .And. nOpc == 3

		MSExecAuto( { | X, Y | MATA240( X, Y ) }, aCpos, 3 )

		If lMsErroAuto

			BuildMsg( @aMsg, 'F', MontaErro(), cReg )

		Else

			BuildMsg( @aMsg, 'T', '', cReg )

		End If

	End If

Return

Static Function Estorna( cTpDoc, cDoc, aMsg, cReg, nOpc )

	Local aCpos     := {}
	Local nX        := 0
	Local aArea     := GetArea()
	Local lExiteDoc := .F.

	DbSelectArea( 'SD3' )
	DBOrderNickname( 'DOCECALC' )

	If lExiteDoc := DbSeek( xFilial( 'SD3' ) + cTpDoc + Padr( cDoc, GetSx3Cache( 'D3_XDECALC', 'X3_TAMANHO' ) ) + ' ' )

		For nX := 1 To FCount()

			aAdd( aCpos, { FieldName( nX ), SD3->&( FieldName( nX ) ), Nil } )

		Next nX

		aAdd( aCpos, { 'INDEX', 4, Nil } )

		MSExecAuto( { | X, Y | MATA240( X, Y ) }, aCpos, 5 )

	End If

	If ! lExiteDoc .And. nOpc == 5

		BuildMsg( @aMsg, 'F', 'Documento ' + cDoc + ' não localizado.', cReg )

	End If

	If lMsErroAuto

		BuildMsg( @aMsg, 'F', MontaErro(), cReg )

	End If

	If ! lMsErroAuto .And. nOpc == 5 .And. lExiteDoc

		BuildMsg( @aMsg, 'T', '', cReg )

	End If

	RestArea( aArea )

Return

Static Function MontaErro()

	Local aErro := {}
	Local nX    := 0
	Local cRet  := ''

	aErro := aClone( GetAutoGRLog() )

	For nX := 1 To Len( aErro )

		cRet += aErro[ nX ] + Chr( 13 ) + Chr( 10 )

	Next nX

Return cRet