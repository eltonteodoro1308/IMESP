#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function FATA110()

	Local oModel  := Nil
	Local lInclui := INCLUI

	If PARAMIXB[ 2 ] == 'MODELCOMMITNTTS' .And.;
	( PARAMIXB[ 1 ]:nOperation == MODEL_OPERATION_INSERT .Or. PARAMIXB[ 1 ]:nOperation == MODEL_OPERATION_UPDATE )

		oModel  := ModelDef()

		oModel:SetOperation( 3 )

		oModel:Activate()

		oModel:LoadValue( 'TIPOCLIENTE', 'ID'   , ACY->ACY_GRPVEN )
		oModel:LoadValue( 'TIPOCLIENTE', 'NOME' , ACY->ACY_DESCRI )

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

	Local oModel  := MPFormModel():New('MODTIPOCLIENTE')
	Local oStruct := Struct()

	oModel:addFields('TIPOCLIENTE',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Cadastro de Grupo de Clientes')
	oModel:getModel('TIPOCLIENTE'):SetDescription('Cadastro de Grupo de Clientes')
	oModel:GetModel( 'TIPOCLIENTE' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('ACY_ECALC',,'ACY_ECALC')

	oStruct:AddField('ID'   , 'ID'   , 'ID'   , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME' , 'NOME' , 'NOME' , 'C', 40, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct