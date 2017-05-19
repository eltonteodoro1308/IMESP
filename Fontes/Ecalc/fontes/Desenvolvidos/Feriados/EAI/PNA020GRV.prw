#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function PNA020GRV()

	Local oModel  := Nil
	Local lInclui := INCLUI
	Local cData   := ''

	If cValToChar( PARAMIXB[ 4 ] ) $ '12'

		oModel  := ModelDef()

		oModel:SetOperation( 3 )

		oModel:Activate()

		cData += PadL( cValToChar( Year ( SP3->P3_DATA ) ), 4, '0' )
		cData += '-'
		cData += PadL( cValToChar( Month( SP3->P3_DATA ) ), 2, '0' )
		cData += '-'
		cData += PadL( cValToChar( Day  ( SP3->P3_DATA ) ), 2, '0' )
		cData += 'T00:00:00Z'

		oModel:LoadValue( 'FERIADO', 'ID'       , DtoS( SP3->P3_DATA ) )
		oModel:LoadValue( 'FERIADO', 'FERIADO'  , cData )
		oModel:LoadValue( 'FERIADO', 'DATAFIXA' , If( SP3->P3_FIXO = 'S', 'T', 'F' ) )

		If oModel:VldData()

			oModel:CommitData()

		Else

			VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

		End If

		oModel:DeActivate()

	End If

	INCLUI := lInclui

Return

Static Function ModelDef()

	Local oModel  := MPFormModel():New('MODFERIADO')
	Local oStruct := Struct()

	oModel:addFields('FERIADO',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Cadastro de Feriados')
	oModel:getModel('FERIADO'):SetDescription('Cadastro de Feriados')
	oModel:GetModel( 'FERIADO' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('SP3_ECALC',,'SP3_ECALC')

	oStruct:AddField('ID'       , 'ID'       , 'ID'       , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('FERIADO'  , 'FERIADO'  , 'FERIADO'  , 'C', 40, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('DATAFIXA' , 'DATAFIXA' , 'DATAFIXA' , 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct