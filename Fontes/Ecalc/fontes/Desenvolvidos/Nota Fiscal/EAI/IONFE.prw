#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH

user function IONFE( cStatus )

	Local oModel  := Nil
	Local lInclui := INCLUI
	Local cData   := ''

	oModel  := ModelDef()

	oModel:SetOperation( 3 )

	oModel:Activate()

	cData += PadL( cValToChar( Year ( SF2->F2_EMISSAO ) ), 4, '0' )
	cData += '-'
	cData += PadL( cValToChar( Month( SF2->F2_EMISSAO ) ), 2, '0' )
	cData += '-'
	cData += PadL( cValToChar( Day  ( SF2->F2_EMISSAO ) ), 2, '0' )
	cData += 'T' + AllTrim( SF2->F2_HORA ) + ':00Z'

	oModel:LoadValue( 'NOTAFISCAL' , 'ID'        , SF2->( AllTrim( F2_DOC + F2_SERIE + SF2->F2_XVENDID ) ) )
	oModel:LoadValue( 'NOTAFISCAL' , 'NOTANUM'   , SF2->F2_DOC )
	oModel:LoadValue( 'NOTAFISCAL' , 'NFSERIE'   , SF2->F2_SERIE  )
	oModel:LoadValue( 'NOTAFISCAL' , 'CODCLIENTE', SF2->F2_CLIENTE )
	oModel:LoadValue( 'NOTAFISCAL' , 'ENTREGA'   , cData )
	oModel:LoadValue( 'NOTAFISCAL' , 'SAIDA'     , cData )
	oModel:LoadValue( 'NOTAFISCAL' , 'VALORTOTAL', AllTrim( Str( SF2->F2_VALMERC ) ) )
	oModel:LoadValue( 'NOTAFISCAL' , 'VALORNOTA' , AllTrim( Str( SF2->F2_VALBRUT ) ) )
	oModel:LoadValue( 'NOTAFISCAL' , 'STATUS'    , cStatus )
	oModel:LoadValue( 'NOTAFISCAL' , 'VENDAID'   , SC5->C5_XVENDID )

	If oModel:VldData()

		oModel:CommitData()

	Else

		VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

	End If

	oModel:DeActivate()

	INCLUI := lInclui

Return

Static Function ModelDef()

	Local oModel  := MPFormModel():New('MODNOTAFISCAL')
	Local oStruct := Struct()

	oModel:addFields('NOTAFISCAL',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Nota Fiscal')
	oModel:getModel('NOTAFISCAL'):SetDescription('Nota Fiscal')
	oModel:GetModel( 'NOTAFISCAL' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('SF2_ECALC',,'SF2_ECALC')

	oStruct:AddField( 'ID'         , 'ID'        , 'ID'        , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'NOTANUM'    , 'NOTANUM'   , 'NOTANUM'   , 'C', 09, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'NFSERIE'    , 'NFSERIE'   , 'NFSERIE'   , 'C', 05, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'CODCLIENTE' , 'CODCLIENTE', 'CODCLIENTE', 'C', 30, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'ENTREGA'    , 'ENTREGA'   , 'ENTREGA'   , 'C', 40, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'SAIDA'      , 'SAIDA'     , 'SAIDA'     , 'C', 40, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'VALORTOTAL' , 'VALORTOTAL', 'VALORTOTAL', 'C', 14, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'VALORNOTA'  , 'VALORNOTA' , 'VALORNOTA' , 'C', 14, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'STATUS'     , 'STATUS'    , 'STATUS'    , 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'VENDAID'    , 'VENDAID'   , 'VENDAID'   , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )

Return oStruct