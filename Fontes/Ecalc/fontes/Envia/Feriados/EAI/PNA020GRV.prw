#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function PNA020GRV()
	
	Local oModel  := Nil
	Local lInclui := INCLUI
	Local cData   := ''
	Local cHoraInicio := TIME()
	
	If cValToChar( PARAMIXB[ 4 ] ) $ '12'
		
		oModel  := ModelDef()
		
		oModel:SetOperation( 3 )
		
		oModel:Activate()
		
		cData += PadL( cValToChar( Year ( SP3->P3_DATA ) ), 4, '0' )
		cData += '-'
		cData += PadL( cValToChar( Month( SP3->P3_DATA ) ), 2, '0' )
		cData += '-'
		cData += PadL( cValToChar( Day  ( SP3->P3_DATA ) ), 2, '0' )
		cData += 'T' + TIME() + 'Z'
		
		oModel:LoadValue( 'FERIADO', 'ID'          , DtoS( SP3->P3_DATA ) )
		oModel:LoadValue( 'FERIADO', 'DATAFERIADO' , cData )
		oModel:LoadValue( 'FERIADO', 'DATAFIXA'    , If( SP3->P3_FIXO = 'S', 'T', 'F' ) )
		
		If oModel:VldData()
			
			//oModel:CommitData()
			EaiEnvio( oModel, Replace( ProcName(), 'U_' ) )
			
		Else
			
			VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)
			
		End If
		
		oModel:DeActivate()
		
		ConOut( ProcName() + ' Executado em ' + ElapTime( cHoraInicio, TIME() ) )
		
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
	
	oStruct:AddField('ID'          , 'ID'          , 'ID'          , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('DATAFERIADO' , 'DATAFERIADO' , 'DATAFERIADO' , 'C', 40, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('DATAFIXA'    , 'DATAFIXA'    , 'DATAFIXA'    , 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )
	
return oStruct

Static Function EaiEnvio( oModel, cPrg )
	
	Local oFwEai   := FwEai():New()
	Local lRet     := .T.
	Local oXmlResp := TXmlManager():New()
	Local cXmlResp := ''
	
	oFwEai:AddLayout( oModel:GetId(), '1.000', 'FWFORMEAI.' + cPrg, oModel:GetXmlData() )
	
	oFwEai:SetDocType( '1' )
	
	oFwEai:SetFuncCode( oModel:GetId() )
	
	oFwEai:SetFuncDescription( oModel:GetDescription() )
	
	oFwEai:SetSendChannel( '2' )
	
	oFwEai:Activate()
	
	If ! oFwEai:Save()
		
		ApMsgStop ( 'Não foi possivel estabelecer Comunicação com o sistema ECalc, integração não executada.', 'Atenção' )
		
	Else
		
		cXmlResp := oFwEai:cResult
		
		oXmlResp:Parse( cXmlResp )
		
		If oXmlResp:XPathGetNodeValue( '/EcalcIntegraEAIResponse/SUCESSO' ) == 'F'
			
			ApMsgStop ( oXmlResp:XPathGetNodeValue( '/EcalcIntegraEAIResponse/MENSAGEM' ), 'Atenção' )
			
			lRet := .F.
			
		End If
		
	End If
	
	oFwEai:DeActivate()
	
return lRet
