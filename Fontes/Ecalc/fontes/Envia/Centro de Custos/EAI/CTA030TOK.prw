#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function CTA030TOK()

	Local oModel  := ModelDef()
	Local lInclui := INCLUI

	oModel:SetOperation( 3 )

	oModel:Activate()

	oModel:LoadValue( 'CENTRODECUSTO', 'ID'   , M->CTT_CUSTO  )
	oModel:LoadValue( 'CENTRODECUSTO', 'NOME' , M->CTT_DESC01 )
	oModel:LoadValue( 'CENTRODECUSTO', 'ATIVO', If( M->CTT_BLOQ = '1', 'F', 'T' ) )

	If oModel:VldData()

		oModel:CommitData()

	Else

		VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

	End If

	oModel:DeActivate()

	INCLUI := lInclui

Return .F.

Static Function ModelDef()

	Local oModel  := MPFormModel():New('MODCENTRODECUSTO')
	Local oStruct := Struct()

	oModel:addFields('CENTRODECUSTO',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Cadastro de Centro de Custo')
	oModel:getModel('CENTRODECUSTO'):SetDescription('Cadastro de Centro de Custo')
	oModel:GetModel( 'CENTRODECUSTO' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('CTT_ECALC',,'CTT_ECALC')

	oStruct:AddField('ID'   , 'ID'   , 'ID'   , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME' , 'NOME' , 'NOME' , 'C', 40, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO', 'ATIVO', 'ATIVO', 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct