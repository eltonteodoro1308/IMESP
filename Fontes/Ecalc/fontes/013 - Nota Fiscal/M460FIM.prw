#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEDITPANEL.CH'
#INCLUDE 'FWADAPTEREAI.CH'

user function M460FIM()

	Local oModel    := ModelDef()
	Local cRotInteg := GetRotInteg()

	oModel:SetOperation( MODEL_OPERATION_INSERT )

	oModel:Activate()

	oModel:VldData()

	SetRotInteg( 'INVOICE' )

	FWIntegDef( 'M460FIM', EAI_MESSAGE_BUSINESS, TRANS_SEND, '', 'INVOICE', .F., '1.000' )

	SetRotInteg( cRotInteg )

	oModel:DeActivate()

return

Static Function ModelDef()

	Local oStruSF2  := FWFormStruct( 1, 'SF2')
	Local oStruSD2  := FWFormStruct( 1, 'SD2')
	Local oModel    := MPFormModel():New( 'INVOICE' )
	Local aRelation := {}

	oModel:SetDescription( 'Nota Fiscal' )

	oModel:AddFields( 'SF2_FIELDS',, oStruSF2 )
	oModel:AddGrid  ( 'SD2_GRID', 'SF2_FIELDS', oStruSD2 )

	aAdd( aRelation, { 'D2_FILIAL' , 'F2_FILIAL'  } )
	aAdd( aRelation, { 'D2_DOC'    , 'F2_DOC'     } )
	aAdd( aRelation, { 'D2_SERIE'  , 'F2_SERIE'   } )
	aAdd( aRelation, { 'D2_CLIENTE', 'F2_CLIENTE' } )
	aAdd( aRelation, { 'D2_LOJA'   , 'F2_LOJA'    } )

	oModel:SetRelation( 'SD2_GRID', aRelation, , SD2->( IndexKey( 1 ) ) )

	oModel:GetModel( 'SF2_FIELDS' ):SetDescription( 'Cabecalho Nota Fiscal' )
	oModel:GetModel( 'SF2_FIELDS' ):SetOnlyQuery ( .T. )

	oModel:GetModel( 'SD2_GRID' ):SetDescription( 'Itens Nota Fiscal' )
	oModel:GetModel( 'SD2_GRID' ):SetOnlyQuery ( .T. )

Return oModel

Static Function IntegDef( cXml, cTypeTran, cTypeMsg, cVersion )

	Local oModel  := FwModelActive()
	Local cXmlRet := ''

	If cTypeMsg == EAI_MESSAGE_BUSINESS

		cXmlRet += '<BusinessEvent>'
		cXmlRet += '<Entity>INVOICE</Entity>'
		cXmlRet += '<Event>upsert</Event>'
		cXmlRet += '<Identification>'
		cXmlRet += '<key name="Code">'
		cXmlRet += AllTrim( oModel:GetModel( 'SF2_FIELDS' ):GetValue( 'F2_DOC' ) )
		cXmlRet += '</key>'
		cXmlRet += '</Identification>'
		cXmlRet += '</BusinessEvent>'
		cXmlRet += '<BusinessContent>'
		cXmlRet += oModel:GetXmlData(.T.,,,,,.T.)
		cXmlRet += '</BusinessContent>'

	End If

Return { .T., cXmlRet, 'INVOICE' }