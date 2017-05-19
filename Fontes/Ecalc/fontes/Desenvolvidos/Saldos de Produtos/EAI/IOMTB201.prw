#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function MTAB2D1R()

	EnviaSaldo()

Return

User Function MTAB2D1()

Return

User Function MTAB2D2R()

	EnviaSaldo()

Return

User Function MTAB2D2()

Return

User Function MTAB2D3R()

	EnviaSaldo()

Return

User Function MTAB2D3()

Return

Static Function EnviaSaldo()

	Local oModel  := Nil
	Local lInclui := INCLUI
	Local cTrab   := GetNextAlias()
	Local aArea   := GetArea()

	BeginSQL Alias cTrab

	SELECT SB2.B2_COD,SUM( SB2.B2_QATU ) B2_QATU
	FROM %Table:SB2% SB2
	WHERE SB2.B2_FILIAL = %xFilial:SB2%
	AND SB2.B2_COD = %EXP:PARAMIXB[1]%
	AND SB2.%NotDel%
	GROUP BY SB2.B2_COD

	EndSQL

	VarInfo( 'GetLastQuery', GetLastQuery(),,.F.,.T. )

	oModel  := ModelDef()

	oModel:SetOperation( 3 )

	oModel:Activate()

	oModel:LoadValue( 'QUANTESTOQUE' , 'ID'           , ( cTrab )->B2_COD )
	oModel:LoadValue( 'QUANTESTOQUE' , 'QUANTESTPRINC', AllTrim( Str( ( cTrab )->B2_QATU ) ) )

	If oModel:VldData()

		oModel:CommitData()

	Else

		VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

	End If

	oModel:DeActivate()

	INCLUI := lInclui

	( cTrab )->( DbCloseArea() )

	RestArea( aArea )

Return

Static Function ModelDef()

	Local oModel  := MPFormModel():New('MODQUANTESTOQUE')
	Local oStruct := Struct()

	oModel:addFields('QUANTESTOQUE',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Saldo de Estoque')
	oModel:getModel('QUANTESTOQUE'):SetDescription('Saldo de Estoque')
	oModel:GetModel( 'QUANTESTOQUE' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('SB2_ECALC',,'SB2_ECALC')

	oStruct:AddField('ID'           , 'ID'            , 'ID'            , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('QUANTESTPRINC', 'QUANTESTPRINC' , 'QUANTESTPRINC' , 'C', 30, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct