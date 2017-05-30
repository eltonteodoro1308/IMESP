#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function QIEA030()

	Local oModel  := Nil
	Local lInclui := INCLUI

	If PARAMIXB[ 2 ] == 'MODELCOMMITNTTS' .And.;
	( PARAMIXB[ 1 ]:nOperation == MODEL_OPERATION_INSERT .Or. PARAMIXB[ 1 ]:nOperation == MODEL_OPERATION_UPDATE )

		oModel  := ModelDef()

		oModel:SetOperation( 3 )

		oModel:Activate()

		oModel:LoadValue( 'UNIDADE', 'ID'            , SAH->AH_UNIMED )
		oModel:LoadValue( 'UNIDADE', 'NOME'          , SAH->AH_UMRES )
		oModel:LoadValue( 'UNIDADE', 'DESCRICAO'     , SAH->AH_DESCPO )
		oModel:LoadValue( 'UNIDADE', 'ATIVO'         , If( SAH->AH_MSBLQL = '1', 'F', 'T' )  )
		oModel:LoadValue( 'UNIDADE', 'OPERADOR'      , '1' )
		oModel:LoadValue( 'UNIDADE', 'MULTIPLICADOR' , '1.00' )

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

	Local oModel  := MPFormModel():New('MODUNIDADE')
	Local oStruct := Struct()

	oModel:addFields('UNIDADE',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Cadastro de Unidade de Medida')
	oModel:getModel('UNIDADE'):SetDescription('Cadastro de Unidade de Medida')
	oModel:GetModel( 'UNIDADE' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('SAH_ECALC',,'SAH_ECALC')

	oStruct:AddField('ID'            , 'ID'            , 'ID'            , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME'          , 'NOME'          , 'NOME'          , 'C', 10, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('DESCRICAO'     , 'DESCRICAO'     , 'DESCRICAO'     , 'C', 60, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'         , 'ATIVO'         , 'ATIVO'         , 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('OPERADOR'      , 'OPERADOR'      , 'OPERADOR'      , 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('MULTIPLICADOR' , 'MULTIPLICADOR' , 'MULTIPLICADOR' , 'C', 04, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct