#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function MT610OK()
	
	Local oModel      := Nil
	Local lInclui     := INCLUI
	Local cTipo       := M->H1_XTIPO
	Local cNomeMod    := ''
	Local lRet        := .T.
	Local cHoraInicio := TIME()
	
	If cValToChar( PARAMIXB[1] ) $ '34'
		
		oModel  := FwLoadModel( If( cTipo == '1', 'MT610MAQ', 'MT610OPER' ) )
		
		cNomeMod := If( cTipo == '1', 'MAQUINA', 'OPERADOR' )
		
		oModel:SetOperation( 3 )
		
		oModel:Activate()
		
		oModel:LoadValue( cNomeMod, 'ID'   , M->H1_CODIGO  )
		oModel:LoadValue( cNomeMod, 'NOME' , M->H1_DESCRI )
		oModel:LoadValue( cNomeMod, 'ATIVO', If( M->H1_MSBLQL = '1', 'F', 'T' ) )
		
		If cTipo == '1'
			
			oModel:LoadValue( cNomeMod, 'CUSTOHORA'          , AllTrim( Str( M->H1_XCTOHR ) ) )
			oModel:LoadValue( cNomeMod, 'MEDIAPRODUTIVIDADE' , AllTrim( Str( M->H1_XMDPRD ) ) )
			
		End If
		
		If oModel:VldData()
			
			//oModel:CommitData()
			lRet := EaiEnvio( oModel, Replace( ProcName(), 'U_' ) )
			
		Else
			
			VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)
			
		End If
		
		oModel:DeActivate()
		
		ConOut( ProcName() + ' Executado em ' + ElapTime( cHoraInicio, TIME() ) )
		
		INCLUI := lInclui
		
	End If
	
Return lRet

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

