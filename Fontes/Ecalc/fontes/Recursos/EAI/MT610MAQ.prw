#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

Static Function ModelDef()

	Local oModel  := MPFormModel():New( 'MODMAQUINA' )
	Local oStruct := Struct()

	oModel:addFields( 'MAQUINA',, oStruct )
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription( 'Cadastro de Máquinas' )
	oModel:getModel( 'MAQUINA' ):SetDescription( 'Cadastro de Máquinas' )
	oModel:GetModel( 'MAQUINA' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('SH1_ECALC',,'SH1_ECALC')

	oStruct:AddField('ID'                 , 'ID'                 , 'ID'                 , 'C', 06, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME'               , 'NOME'               , 'NOME'               , 'C', 30, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'              , 'ATIVO'              , 'ATIVO'              , 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CUSTOHORA'          , 'CUSTOHORA'          , 'CUSTOHORA'          , 'C', 10, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('MEDIAPRODUTIVIDADE' , 'MEDIAPRODUTIVIDADE' , 'MEDIAPRODUTIVIDADE' , 'C', 10, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct