#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

user function MA040TOK()

	Local oModel  := ModelDef()
	Local lInclui := INCLUI

	oModel:SetOperation( 3 )

	oModel:Activate()

	oModel:Setvalue( 'VENDEDOR', 'ID'          , M->A3_COD    )
	oModel:Setvalue( 'VENDEDOR', 'NOME'        , M->A3_NREDUZ )
	oModel:Setvalue( 'VENDEDOR', 'RAZAOSOCIAL' , M->A3_NOME   )
	oModel:Setvalue( 'VENDEDOR', 'ATIVO'       , If( M->A3_BLOQ = '1', 'F', 'T' ) )

	If oModel:VldData()

		oModel:CommitData()

	Else

		VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

	End If

	oModel:DeActivate()

	INCLUI := lInclui

return .T.

Static Function ModelDef()

	Local oModel  := MPFormModel():New('MODVENDEDOR')
	Local oStruct := Struct()

	oModel:addFields('VENDEDOR',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Cadastro de Vendedores')
	oModel:getModel('VENDEDOR'):SetDescription('Cadastro de Vendedores')
	oModel:GetModel( 'VENDEDOR' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('SA3_ECALC',,'SA3_ECALC')

	oStruct:AddField('ID'          , 'ID'          , 'ID'          , 'C', 06, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME'        , 'NOME'        , 'NOME'        , 'C', 25, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('RAZAOSOCIAL' , 'RAZAOSOCIAL' , 'RAZAOSOCIAL' , 'C', 40, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'       , 'ATIVO'       , 'ATIVO'       , 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct