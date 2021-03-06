#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function CTA030TOK()
	
	Local oModel      := ModelDef()
	Local lInclui     := INCLUI
	Local lRet        := .T.
	Local cHoraInicio := TIME()
	
	oModel:SetOperation( 3 )
	
	oModel:Activate()
	
	oModel:LoadValue( 'CENTRODECUSTO', 'ID'   , M->CTT_CUSTO  )
	oModel:LoadValue( 'CENTRODECUSTO', 'NOME' , M->CTT_DESC01 )
	oModel:LoadValue( 'CENTRODECUSTO', 'ATIVO', If( M->CTT_BLOQ = '1', 'F', 'T' ) )
	
	If oModel:VldData()
		
		//oModel:CommitData()
		lRet := ! EaiEnvio( oModel, Replace( ProcName(), 'U_' ) )
		
	Else
		
		VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)
		
	End If
	
	oModel:DeActivate()
	
	ConOut( ProcName() + ' Executado em ' + ElapTime( cHoraInicio, TIME() ) )	
	
	INCLUI := lInclui
	
Return lRet

Static Function ModelDef()
	
	Local oModel  := MPFormModel():New('MODCENTRODECUSTO')
	Local oStruct := Struct()
	
	oModel:addFields('CENTRODECUSTO',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )
	
	oModel:SetDescription('Cadastro de Centro de Custo')
	oModel:getModel('CENTRODECUSTO'):SetDescription('Cadastro de Centro de Custo')
	oModel:GetModel( 'CENTRODECUSTO' ):SetOnlyQuery ( .T. )
	
Return oModel

Static Function Struct()
	
	Local oStruct := FWFormModelStruct():New()
	
	oStruct:AddTable('CTT_ECALC',,'CTT_ECALC')
	
	oStruct:AddField('ID'   , 'ID'   , 'ID'   , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME' , 'NOME' , 'NOME' , 'C', 40, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO', 'ATIVO', 'ATIVO', 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )
	
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
		
		ApMsgStop ( 'N�o foi possivel estabelecer Comunica��o com o sistema ECalc, integra��o n�o executada.', 'Aten��o' )
		
	Else
		
		cXmlResp := oFwEai:cResult
		
		oXmlResp:Parse( cXmlResp )
		
		If oXmlResp:XPathGetNodeValue( '/EcalcIntegraEAIResponse/SUCESSO' ) == 'F'
			
			ApMsgStop ( oXmlResp:XPathGetNodeValue( '/EcalcIntegraEAIResponse/MENSAGEM' ), 'Aten��o' )
			
			lRet := .F.
			
		End If
		
	End If
	
	oFwEai:DeActivate()
	
return lRet
