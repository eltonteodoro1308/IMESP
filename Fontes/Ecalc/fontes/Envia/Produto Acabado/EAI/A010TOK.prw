#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

user function A010TOK()
	
	Local oModel     := Nil
	Local lInclui    := INCLUI
	Local cItemProd  := ''
	Local cTipoItem  := ''
	Local cXmlResp   := ''
	Local lIsPrdAcab := .F.
	Local lIsMatPrim := .F.
	Local lIsChapa   := .F.
	Local lIsTinta   := .F.
	Local lIsPapel   := .F.
	Local lRet       := .T.
	Local cHoraInicio := TIME()
	
	lIsPrdAcab  := AllTrim( M->B1_TIPO  ) == 'PA'
	lIsMatPrim  := AllTrim( M->B1_TIPO  ) == 'MP'
	lIsChapa    := AllTrim( M->B1_GRUPO ) == AllTrim( GetMv( 'IO_GRCHAPA' ) )
	lIsTinta    := AllTrim( M->B1_GRUPO ) == AllTrim( GetMv( 'IO_GRTINTA' ) )
	lIsPapel    := AllTrim( M->B1_GRUPO ) == AllTrim( GetMv( 'IO_GRPAPEL' ) )
	
	If lIsPrdAcab .Or. ( lIsMatPrim .And. ( lIsPapel .Or. lIsChapa .Or. lIsTinta ) )
		
		If lIsPrdAcab
			
			cItemProd := '2'
			
		Else
			
			cItemProd := '1'
			
			If lIsChapa
				
				cTipoItem := '0'
				
			ElseIf lIsPapel
				
				cTipoItem := '1'
				
			ElseIf lIsTinta
				
				cTipoItem := '2'
				
			End If
			
		End If
		
		oModel  := ModelDef()
		
		oModel:SetOperation( 3 )
		
		oModel:Activate()
		
		oModel:LoadValue( 'ITEMESTOQUE' , 'ID'             , M->B1_COD )
		oModel:LoadValue( 'ITEMESTOQUE' , 'NOME'           , M->B1_DESC )
		oModel:LoadValue( 'ITEMESTOQUE' , 'DESCRICAO'      , M->B1_DESC )
		oModel:LoadValue( 'ITEMESTOQUE' , 'ATIVO'          , If( M->B1_MSBLQL = '1', 'F', 'T' ) )
		oModel:LoadValue( 'ITEMESTOQUE' , 'ITEMPROD'       , cItemProd )
		oModel:LoadValue( 'ITEMESTOQUE' , 'TIPOITEMEC'     , cTipoItem )
		oModel:LoadValue( 'ITEMESTOQUE' , 'PAPELFAMILIA'   , AllTrim( M->B1_XECFML ) )
		oModel:LoadValue( 'ITEMESTOQUE' , 'PAPELGRAMATURA' , AllTrim( Str( M->B1_XECGRM ) ) )
		oModel:LoadValue( 'ITEMESTOQUE' , 'PAPELLARGURA'   , AllTrim( Str( M->B1_XECLRG ) ) )
		oModel:LoadValue( 'ITEMESTOQUE' , 'PAPELALTURA'    , AllTrim( Str( M->B1_XECALT ) ) )
		oModel:LoadValue( 'ITEMESTOQUE' , 'PRECO'          , AllTrim( Str( M->B1_PRV1 ) ) )
		
		If oModel:VldData()
			
			//oModel:CommitData()
			lRet := EaiEnvio( oModel, Replace( ProcName(), 'U_' ) )
			
		Else
			
			VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)
			
		End If
		
		oModel:DeActivate()
		
		ConOut( ProcName() + ' Executado em ' + ElapTime( cHoraInicio, TIME() ) )
		
		INCLUI := lInclui
		
	End If
	
return lRet

Static Function ModelDef()
	
	Local oModel  := MPFormModel():New('MODITEMESTOQUE')
	Local oStruct := Struct()
	
	oModel:addFields('ITEMESTOQUE',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )
	
	oModel:SetDescription('Cadastro de Produtos')
	oModel:getModel('ITEMESTOQUE'):SetDescription('Cadastro de Produtos')
	oModel:GetModel( 'ITEMESTOQUE' ):SetOnlyQuery ( .T. )
	
Return oModel

Static Function Struct()
	
	Local oStruct := FWFormModelStruct():New()
	
	oStruct:AddTable('SB1_ECALC',,'SB1_ECALC')
	
	oStruct:AddField('ID'             , 'ID'             , 'ID'             , 'C', 020, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME'           , 'NOME'           , 'NOME'           , 'C', 120, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('DESCRICAO'      , 'DESCRICAO'      , 'DESCRICAO'      , 'C', 120, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'          , 'ATIVO'          , 'ATIVO'          , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ITEMPROD'       , 'ITEMPROD'       , 'ITEMPROD'       , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('TIPOITEMEC'     , 'TIPOITEMEC'     , 'TIPOITEMEC'     , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('PAPELFAMILIA'   , 'PAPELFAMILIA'   , 'PAPELFAMILIA'   , 'C', 012, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('PAPELGRAMATURA' , 'PAPELGRAMATURA' , 'PAPELGRAMATURA' , 'C', 018, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('PAPELLARGURA'   , 'PAPELLARGURA'   , 'PAPELLARGURA'   , 'C', 018, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('PAPELALTURA'    , 'PAPELALTURA'    , 'PAPELALTURA'    , 'C', 018, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('PRECO'          , 'PRECO'          , 'PRECO'          , 'C', 018, 0, , , {}, .F., , .F., .F., .F., , )
	
return oStruct

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
