#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function M050TOK()

	Local oModel  := ModelDef()
	Local lInclui := INCLUI

	oModel:SetOperation( 3 )

	oModel:Activate()

	oModel:Setvalue( 'TRANSPORTADORA', 'ID'          , M->A4_COD    )
	oModel:Setvalue( 'TRANSPORTADORA', 'NOME'        , M->A4_NREDUZ )
	oModel:Setvalue( 'TRANSPORTADORA', 'RAZAOSOCIAL' , M->A4_NOME   )
	oModel:Setvalue( 'TRANSPORTADORA', 'ATIVO'       , If( M->A4_BLOQ = '1', 'F', 'T' ) )

	If oModel:VldData()

		oModel:CommitData()

	Else

		VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

	End If

	oModel:DeActivate()

	INCLUI := lInclui

return .T.

Static Function ModelDef()

	Local oModel  := MPFormModel():New('MODTRANSPORTADORA')
	Local oStruct := Struct()

	oModel:addFields('TRANSPORTADORA',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Cadastro de Transportadoras')
	oModel:getModel('TRANSPORTADORA'):SetDescription('Cadastro de Transportadoras')
	oModel:GetModel( 'TRANSPORTADORA' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('SA4_ECALC',,'SA4_ECALC')

	oStruct:AddField('ID'          , 'ID'          , 'ID'          , 'C', 06, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME'        , 'NOME'        , 'NOME'        , 'C', 15, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('RAZAOSOCIAL' , 'RAZAOSOCIAL' , 'RAZAOSOCIAL' , 'C', 40, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'       , 'ATIVO'       , 'ATIVO'       , 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct