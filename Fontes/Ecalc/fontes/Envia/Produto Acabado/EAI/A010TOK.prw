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

			If AllTrim( M->B1_GRUPO ) == AllTrim( GetMv( 'IO_GRCHAPA' ) )

				cTipoItem := '0'

			ElseIf AllTrim( M->B1_GRUPO ) == AllTrim( GetMv( 'IO_GRPAPEL' ) )

				cTipoItem := '1'

			ElseIf AllTrim( M->B1_GRUPO ) == AllTrim( GetMv( 'IO_GRTINTA' ) )

				cTipoItem := '2'

			End If

		End If

		oModel  := ModelDef()

		oModel:SetOperation( 3 )

		oModel:Activate()

		oModel:Setvalue( 'ITEMESTOQUE' , 'ID'             , M->B1_COD )
		oModel:Setvalue( 'ITEMESTOQUE' , 'NOME'           , M->B1_DESC )
		oModel:Setvalue( 'ITEMESTOQUE' , 'DESCRICAO'      , M->B1_DESC )
		oModel:Setvalue( 'ITEMESTOQUE' , 'ATIVO'          , If( M->B1_MSBLQL = '1', 'F', 'T' ) )
		oModel:Setvalue( 'ITEMESTOQUE' , 'ITEMPROD'       , cItemProd )
		oModel:Setvalue( 'ITEMESTOQUE' , 'TIPOITEMEC'     , cTipoItem )
		oModel:Setvalue( 'ITEMESTOQUE' , 'PAPELFAMILIA'   , AllTrim( M->B1_XECFML ) )
		oModel:Setvalue( 'ITEMESTOQUE' , 'PAPELGRAMATURA' , AllTrim( Str( M->B1_XECGRM ) ) )
		oModel:Setvalue( 'ITEMESTOQUE' , 'PAPELLARGURA'   , AllTrim( Str( M->B1_XECLRG ) ) )
		oModel:Setvalue( 'ITEMESTOQUE' , 'PAPELALTURA'    , AllTrim( Str( M->B1_XECALT ) ) )

		If oModel:VldData()

			//oModel:CommitData()
			lRet := EaiEnvio( oModel, Replace( ProcName(), 'U_' ) )

		Else

			VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

		End If

		oModel:DeActivate()

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
	oStruct:AddField('NOME'           , 'NOME'           , 'NOME'           , 'C', 060, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('DESCRICAO'      , 'DESCRICAO'      , 'DESCRICAO'      , 'C', 120, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'          , 'ATIVO'          , 'ATIVO'          , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ITEMPROD'       , 'ITEMPROD'       , 'ITEMPROD'       , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('TIPOITEMEC'     , 'TIPOITEMEC'     , 'TIPOITEMEC'     , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('PAPELFAMILIA'   , 'PAPELFAMILIA'   , 'PAPELFAMILIA'   , 'C', 012, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('PAPELGRAMATURA' , 'PAPELGRAMATURA' , 'PAPELGRAMATURA' , 'C', 018, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('PAPELLARGURA'   , 'PAPELLARGURA'   , 'PAPELLARGURA'   , 'C', 018, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('PAPELALTURA'    , 'PAPELALTURA'    , 'PAPELALTURA'    , 'C', 018, 0, , , {}, .F., , .F., .F., .F., , )

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

		ApMsgStop ( 'N�o foi possivel estabelecer Comunica��o com o sistema ECalc, integra��o n�o executada.', 'Aten��o' )

	Else

		cXmlResp := oFwEai:cResult

		oXmlResp:Parse( cXmlResp )

		If oXmlResp:XPathGetNodeValue( '/EcalcIntegraEAIResponse/SUCESSO' ) == 'F'

			ApMsgStop ( oXmlResp:XPathGetNodeValue( '/EcalcIntegraEAIResponse/MENSAGEM' ), 'Aten��o' )

			cRet := .F.

		End If

	End If

	oFwEai:DeActivate()

return cRet
