#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

user function A010TOK()

	Local oModel  := Nil
	Local lInclui := INCLUI

	If M->B1_TIPO == 'PA'

		oModel  := ModelDef()

		oModel:SetOperation( 3 )

		oModel:Activate()

		oModel:Setvalue( 'ITEMESTOQUE' , 'ID'          , M->B1_COD )
		oModel:Setvalue( 'ITEMESTOQUE' , 'NOME'        , M->B1_DESC )
		oModel:Setvalue( 'ITEMESTOQUE' , 'DESCRICAO'   , M->B1_DESC )
		oModel:Setvalue( 'ITEMESTOQUE' , 'ATIVO'       , If( M->B1_MSBLQL = '1', 'F', 'T' ) )
		oModel:Setvalue( 'ITEMESTOQUE' , 'ITEMPROD'    , '2' )

		If oModel:VldData()

			oModel:CommitData()

		Else

			VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

		End If

		oModel:DeActivate()

		INCLUI := lInclui

	End If

return .T.

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

	oStruct:AddField('ID'        , 'ID'        , 'ID'        , 'C', 020, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME'      , 'NOME'      , 'NOME'      , 'C', 060, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('DESCRICAO' , 'DESCRICAO' , 'DESCRICAO' , 'C', 120, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'     , 'ATIVO'     , 'ATIVO'     , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ITEMPROD'  , 'ITEMPROD'  , 'ITEMPROD'  , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct