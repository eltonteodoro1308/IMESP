#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

user function MATA360()

	Local oModel  := Nil
	Local lInclui := INCLUI

	If PARAMIXB[ 2 ] == 'MODELCOMMITNTTS' .And.;
	( PARAMIXB[ 1 ]:nOperation == MODEL_OPERATION_INSERT .Or. PARAMIXB[ 1 ]:nOperation == MODEL_OPERATION_UPDATE )

		oModel  := ModelDef()

		oModel:SetOperation( 3 )

		oModel:Activate()

		oModel:LoadValue( 'CONDICAODEPAGAMENTO', 'ID'        , SE4->E4_CODIGO )
		oModel:LoadValue( 'CONDICAODEPAGAMENTO', 'DESCRICAO' , SE4->E4_DESCRI )
		oModel:LoadValue( 'CONDICAODEPAGAMENTO', 'ATIVO'     , If( SE4->E4_MSBLQL = '1', 'F', 'T' ) )

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

	Local oModel  := MPFormModel():New('MODCONDICAODEPAGAMENTO')
	Local oStruct := Struct()

	oModel:addFields('CONDICAODEPAGAMENTO',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Cadastro de Condição de Pagamento')
	oModel:getModel('CONDICAODEPAGAMENTO'):SetDescription('Cadastro de Condição de Pagamento')
	oModel:GetModel( 'CONDICAODEPAGAMENTO' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('SE4_ECALC',,'SE4_ECALC')

	oStruct:AddField('ID'        , 'ID'        , 'ID'        , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('DESCRICAO' , 'DESCRICAO' , 'DESCRICAO' , 'C', 40, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'     , 'ATIVO'     , 'ATIVO'     , 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct