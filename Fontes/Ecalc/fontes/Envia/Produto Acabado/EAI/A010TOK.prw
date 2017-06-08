#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

user function A010TOK()

	Local oModel    := Nil
	Local lInclui   := INCLUI
	Local cCodigo   := ''
	Local cItemProd := ''
	Local cXmlResp  := ''
	Local oXmlResp  := TXmlManager():New()
	Local lRet      := .T.

	If AllTrim( M->B1_TIPO ) == 'PA' .Or.;
	( AllTrim( M->B1_GRUPO ) == AllTrim( GetMv( 'IO_GRPAPEL' ) ) .And.;
	! Empty( AllTrim( M->B1_XECFML ) + AllTrim( M->B1_XECGRM ) + AllTrim( M->B1_XECLRG ) + AllTrim( M->B1_XECALT ) ) )

		If M->B1_TIPO == 'PA'

			cCodigo   := M->B1_COD
			cItemProd := '2'

		Else

			cCodigo   := AllTrim( M->B1_XECFML ) + '.' + AllTrim( M->B1_XECGRM ) + '.' + AllTrim( M->B1_XECLRG ) + '.' + AllTrim( M->B1_XECALT )
			cItemProd := '1'

		End If

		oModel  := ModelDef()

		oModel:SetOperation( 3 )

		oModel:Activate()

		oModel:Setvalue( 'ITEMESTOQUE' , 'ID'         , M->B1_COD )
		oModel:Setvalue( 'ITEMESTOQUE' , 'CCODIGO'    , cCodigo )
		oModel:Setvalue( 'ITEMESTOQUE' , 'NOME'       , M->B1_DESC )
		oModel:Setvalue( 'ITEMESTOQUE' , 'DESCRICAO'  , M->B1_DESC )
		oModel:Setvalue( 'ITEMESTOQUE' , 'ATIVO'      , If( M->B1_MSBLQL = '1', 'F', 'T' ) )
		oModel:Setvalue( 'ITEMESTOQUE' , 'ITEMPROD'   , cItemProd )
		oModel:Setvalue( 'ITEMESTOQUE' , 'TIPOITEMEC' , '1' )

		If oModel:VldData()

			//oModel:CommitData()
			cXmlResp := EaiEnvio( oModel, Replace( ProcName(), 'U_' ) )
			oXmlResp:Parse( cXmlResp )

			If oXmlResp:XPathGetNodeValue( '/EcalcIntegraEAIResponse/SUCESSO' ) == 'F'

				ApMsgStop ( oXmlResp:XPathGetNodeValue( '/EcalcIntegraEAIResponse/MENSAGEM' ), 'Atenção' )

				lRet := .F.

			End If

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

	oStruct:AddField('ID'         , 'ID'         , 'ID'         , 'C', 020, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CCODIGO'    , 'CCODIGO'    , 'CCODIGO'    , 'C', 020, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME'       , 'NOME'       , 'NOME'       , 'C', 060, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('DESCRICAO'  , 'DESCRICAO'  , 'DESCRICAO'  , 'C', 120, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'      , 'ATIVO'      , 'ATIVO'      , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ITEMPROD'   , 'ITEMPROD'   , 'ITEMPROD'   , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('TIPOITEMEC' , 'TIPOITEMEC' , 'TIPOITEMEC' , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct

Static Function EaiEnvio( oModel, cPrg )

	Local oFwEai := FwEai():New()
	Local cRet   := ''

	oFwEai:AddLayout( oModel:GetId(), '1.000', 'FWFORMEAI.' + cPrg, oModel:GetXmlData() )

	oFwEai:SetDocType( '1' )

	oFwEai:SetFuncCode( oModel:GetId() )

	oFwEai:SetFuncDescription( oModel:GetDescription() )

	oFwEai:SetSendChannel( '2' )

	oFwEai:Activate()

	oFwEai:Save()

	cRet := oFwEai:cResult

	oFwEai:DeActivate()

return cRet
