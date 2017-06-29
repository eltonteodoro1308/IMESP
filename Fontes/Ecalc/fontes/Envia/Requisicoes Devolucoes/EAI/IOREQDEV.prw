#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User function IOREQDEV( cId, cNumAno, cCodItem, cDescricao, cTipo, cDataMovimento, cQuantidade, cValorTotal, cValorIcms, cStatus )
	
	Local oModel  := Nil
	
	Local lInclui     := INCLUI
	Local lRet        := .T.
	Local cHoraInicio := TIME()
	
	oModel  := ModelDef()
	
	oModel:SetOperation( 3 )
	
	oModel:Activate()
	
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'ID'            , cId            )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'NUMANO'        , cNumAno        )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'CODITEM'       , cCodItem       )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'DESCRICAO'     , cDescricao     )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'TIPO'          , cTipo          )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'DATAMOVIMENTO' , cDataMovimento )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'QUANTIDADE'    , cQuantidade    )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'VALORTOTAL'    , cValorTotal    )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'VALORICMS'     , cValorIcms     )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'STATUS'        , cStatus        )
	
	If oModel:VldData()
		
		//oModel:CommitData()
		lRet := EaiEnvio( oModel, Replace( ProcName(), 'U_' ) )
		
	Else
		
		VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)
		
	End If
	
	oModel:DeActivate()
	
	ConOut( ProcName() + ' Executado em ' + ElapTime( cHoraInicio, TIME() ) )
	
	INCLUI := lInclui
	
Return lRet

Static Function ModelDef()
	
	Local oModel  := MPFormModel():New('MODMOVIMENTACAOOS')
	Local oStruct := Struct()
	
	oModel:addFields('MOVIMENTACAOOS',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )
	
	oModel:SetDescription('Requisicao e Devolucao da OP')
	oModel:getModel('MOVIMENTACAOOS'):SetDescription('Requisicao e Devolucao da OP')
	oModel:GetModel( 'MOVIMENTACAOOS' ):SetOnlyQuery ( .T. )
	
Return oModel

Static Function Struct()
	
	Local oStruct := FWFormModelStruct():New()
	
	oStruct:AddTable('SD3_ECALC',,'SD3_ECALC')
	
	oStruct:AddField( 'ID'            , 'ID'            , 'ID'            ,  'C', 020, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'NUMANO'        , 'NUMANO'        , 'NUMANO'        ,  'C', 020, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'CODITEM'       , 'CODITEM'       , 'CODITEM'       ,  'C', 030, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'DESCRICAO'     , 'DESCRICAO'     , 'DESCRICAO'     ,  'C', 150, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'TIPO'          , 'TIPO'          , 'TIPO'          ,  'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'DATAMOVIMENTO' , 'DATAMOVIMENTO' , 'DATAMOVIMENTO' ,  'C', 040, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'QUANTIDADE'    , 'QUANTIDADE'    , 'QUANTIDADE'    ,  'C', 030, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'VALORTOTAL'    , 'VALORTOTAL'    , 'VALORTOTAL'    ,  'C', 030, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'VALORICMS'     , 'VALORICMS'     , 'VALORICMS'     ,  'C', 030, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'STATUS'        , 'STATUS'        , 'STATUS'        ,  'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	
Return oStruct

Static Function EaiEnvio( oModel, cPrg )
	
	Local oFwEai   := FwEai():New()
	Local lRet     := .T.
	Local oXmlResp := TXmlManager():New()
	Local cXmlResp := ''
	
	oFwEai:AddLayout( oModel:GetId(), '1.000', 'FWFORMEAI.' + cPrg, oModel:GetXmlData() )
	
	oFwEai:SetDocType( '1' )
	
	oFwEai:SetFuncCode( oModel:GetId() )
	
	oFwEai:SetFuncDescription( oModel:GetDescription() )
	
	oFwEai:SetSendChannel( '2' )
	
	oFwEai:Activate()
	
	If ! oFwEai:Save()
		
		ApMsgStop ( 'Não foi possivel estabelecer Comunicação com o sistema ECalc, integração não executada.', 'Atenção' )
		
	Else
		
		cXmlResp := oFwEai:cResult
		
		oXmlResp:Parse( cXmlResp )
		
		If oXmlResp:XPathGetNodeValue( '/EcalcIntegraEAIResponse/SUCESSO' ) == 'F'
			
			ApMsgStop ( oXmlResp:XPathGetNodeValue( '/EcalcIntegraEAIResponse/MENSAGEM' ), 'Atenção' )
			
			lRet := .F.
			
		End If
		
	End If
	
	oFwEai:DeActivate()
	
return lRet
