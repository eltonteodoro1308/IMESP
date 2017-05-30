#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH

User function IOREQDEV( cId, cNumAno, cCodItem, cDescricao, cTipo, cDataMovimento, cQuantidade, cValorTotal, cValorIcms, cStatus )

	Local oModel  := Nil

	Local lInclui := INCLUI
	Local cData   := ''

	oModel  := ModelDef()

	oModel:SetOperation( 3 )

	oModel:Activate()

	oModel:LoadValue( 'MOVIMENTACAOOS' , 'ID'            , cId            )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'NUMANO'        , cNumAno        )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'CODITEM'       , cCodItem       )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'DESCRICAO'     , cDescricao     )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'TIPO'          , cTipo          )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'DATAMOVIMENTO' , cDataMovimento )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'QUANTIDADE'    , cQuantidade    )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'VALORTOTAL'    , cValorTotal    )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'VALORICMS'     , cValorIcms     )
	oModel:LoadValue( 'MOVIMENTACAOOS' , 'STATUS'        , cStatus        )

	If oModel:VldData()

		oModel:CommitData()

	Else

		VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

	End If

	oModel:DeActivate()

	INCLUI := lInclui

Return

Static Function ModelDef()

	Local oModel  := MPFormModel():New('MODMOVIMENTACAOOS')
	Local oStruct := Struct()

	oModel:addFields('MOVIMENTACAOOS',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )

	oModel:SetDescription('Requisicao e Devolucao da OP')
	oModel:getModel('MOVIMENTACAOOS'):SetDescription('Requisicao e Devolucao da OP')
	oModel:GetModel( 'MOVIMENTACAOOS' ):SetOnlyQuery ( .T. )

Return oModel

Static Function Struct()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddTable('SD3_ECALC',,'SD3_ECALC')

	oStruct:AddField( 'ID'            , 'ID'            , 'ID'            ,  'C', 020, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'NUMANO'        , 'NUMANO'        , 'NUMANO'        ,  'C', 020, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'CODITEM'       , 'CODITEM'       , 'CODITEM'       ,  'C', 030, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'DESCRICAO'     , 'DESCRICAO'     , 'DESCRICAO'     ,  'C', 150, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'TIPO'          , 'TIPO'          , 'TIPO'          ,  'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'DATAMOVIMENTO' , 'DATAMOVIMENTO' , 'DATAMOVIMENTO' ,  'C', 040, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'QUANTIDADE'    , 'QUANTIDADE'    , 'QUANTIDADE'    ,  'C', 030, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'VALORTOTAL'    , 'VALORTOTAL'    , 'VALORTOTAL'    ,  'C', 030, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'VALORICMS'     , 'VALORICMS'     , 'VALORICMS'     ,  'C', 030, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField( 'STATUS'        , 'STATUS'        , 'STATUS'        ,  'C', 001, 0, , , {}, .F., , .F., .F., .F., , )

Return oStruct