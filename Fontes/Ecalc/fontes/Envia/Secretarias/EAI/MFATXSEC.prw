#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

user function MFATXSEC()

	Local oModel  := Nil
	Local lInclui := INCLUI

	If PARAMIXB[ 2 ] == 'MODELCOMMITNTTS' .And.;
	( PARAMIXB[ 1 ]:nOperation == MODEL_OPERATION_INSERT .Or. PARAMIXB[ 1 ]:nOperation == MODEL_OPERATION_UPDATE )

		oModel  := ModelDef()

		oModel:SetOperation( 3 )

		oModel:Activate()

		oModel:LoadValue( 'SECRETARIA', 'ID'          , Z01->Z01_COD )
		oModel:LoadValue( 'SECRETARIA', 'DESCRICAO'   , Z01->Z01_DESC )
		oModel:LoadValue( 'SECRETARIA', 'RAZAOSOCIAL' , Z01->Z01_DESC )
		oModel:LoadValue( 'SECRETARIA', 'ATIVO'       , If( Z01->Z01_ATIVO = '1', 'T', 'F' ) )

		If oModel:VldData()

			oModel:CommitData()

		Else

			VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

		End If

		oModel:DeActivate()

	End If

	INCLUI := lInclui

	If PARAMIXB[ 2 ] == 'BUTTONBAR'

		Return {}

	Else

		Return .T.

	EndIf

return Nil

Static Function ModelDef()

	Local oModel  := MPFormModel():New('MODSECRETARIA')
	Local oStruct := Struct()

	oModel:addFields('SECRETARIA',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Cadastro de Secretarias')
	oModel:getModel('SECRETARIA'):SetDescription('Cadastro de Secretarias')
	oModel:GetModel( 'SECRETARIA' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('Z01_ECALC',,'Z01_ECALC')

	oStruct:AddField('ID'          , 'ID'          , 'ID'          , 'C', 020, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME'        , 'DESCRICAO'   , 'DESCRICAO'   , 'C', 040, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('RAZAOSOCIAL' , 'RAZAOSOCIAL' , 'RAZAOSOCIAL' , 'C', 120, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'       , 'ATIVO'       , 'ATIVO'       , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct