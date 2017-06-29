#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

user function MFATXSEC()
	
	Local oModel      := Nil
	Local lInclui     := INCLUI
	Local lRet        := .T.
	Local cHoraInicio := TIME()
	
	If PARAMIXB[ 2 ] == 'FORMPOS' .And.;
			( PARAMIXB[ 1 ]:GetOperation() == MODEL_OPERATION_INSERT .Or. PARAMIXB[ 1 ]:GetOperation() == MODEL_OPERATION_UPDATE )
		
		oModel  := ModelDef()
		
		oModel:SetOperation( 3 )
		
		oModel:Activate()
		
		oModel:LoadValue( 'SECRETARIA', 'ID'          , Z01->Z01_COD )
		oModel:LoadValue( 'SECRETARIA', 'NOME'        , Z01->Z01_DESC )
		oModel:LoadValue( 'SECRETARIA', 'RAZAOSOCIAL' , Z01->Z01_DESC )
		oModel:LoadValue( 'SECRETARIA', 'ATIVO'       , If( Z01->Z01_ATIVO = '1', 'T', 'F' ) )
		
		If oModel:VldData()
			
			//oModel:CommitData()
			lRet := EaiEnvio( oModel, Replace( ProcName(), 'U_' ) )
			
		Else
			
			VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)
			
		End If
		
		oModel:DeActivate()
		
		ConOut( ProcName() + ' Executado em ' + ElapTime( cHoraInicio, TIME() ) )
		
	End If
	
	INCLUI := lInclui
	
	If PARAMIXB[ 2 ] == 'BUTTONBAR'
		
		Return {}
		
	EndIf
	
return lRet

Static Function ModelDef()
	
	Local oModel  := MPFormModel():New('MODSECRETARIA')
	Local oStruct := Struct()
	
	oModel:addFields('SECRETARIA',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )
	
	oModel:SetDescription('Cadastro de Secretarias')
	oModel:getModel('SECRETARIA'):SetDescription('Cadastro de Secretarias')
	oModel:GetModel( 'SECRETARIA' ):SetOnlyQuery ( .T. )
	
Return oModel

Static Function Struct()
	
	Local oStruct := FWFormModelStruct():New()
	
	oStruct:AddTable('Z01_ECALC',,'Z01_ECALC')
	
	oStruct:AddField('ID'          , 'ID'          , 'ID'          , 'C', 020, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME'        , 'NOME'        , 'NOME'        , 'C', 040, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('RAZAOSOCIAL' , 'RAZAOSOCIAL' , 'RAZAOSOCIAL' , 'C', 120, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'       , 'ATIVO'       , 'ATIVO'       , 'C', 001, 0, , , {}, .F., , .F., .F., .F., , )
	
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
