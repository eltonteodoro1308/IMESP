#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

Static Function ModelDef()

	Local oModel  := MPFormModel():New( 'MODOPERADOR' )
	Local oStruct := Struct()

	oModel:addFields( 'OPERADOR',, oStruct )
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription( 'Cadastro de Operador' )
	oModel:getModel( 'OPERADOR' ):SetDescription( 'Cadastro de Operador' )
	oModel:GetModel( 'OPERADOR' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('SH1_ECALC',,'SH1_ECALC')

	oStruct:AddField('ID'   , 'ID'   , 'ID'   , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME' , 'NOME' , 'NOME' , 'C', 40, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO', 'ATIVO', 'ATIVO', 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct