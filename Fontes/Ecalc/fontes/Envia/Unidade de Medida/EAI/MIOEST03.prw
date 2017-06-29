#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

user function MIOEST03()
	
	Local oModel      := Nil
	Local lInclui     := INCLUI
	Local lRet        := .T.
	Local cHoraInicio := TIME()
	
	If PARAMIXB[ 2 ] == 'FORMPOS' .And.;
			( PARAMIXB[ 1 ]:GetOperation() == MODEL_OPERATION_INSERT .Or. PARAMIXB[ 1 ]:GetOperation() == MODEL_OPERATION_UPDATE )
		
		oModel  := ModelDef()
		
		oModel:SetOperation( 3 )
		
		oModel:Activate()
		
		oModel:LoadValue( 'UNIDADE', 'ID'            , SZB->ZB_COD )
		oModel:LoadValue( 'UNIDADE', 'NOME'          , SZB->ZB_SIGLA )
		oModel:LoadValue( 'UNIDADE', 'DESCRICAO'     , SZB->ZB_DESC )
		oModel:LoadValue( 'UNIDADE', 'ATIVO'         , If( SZB->ZB_MSBLQL = '1', 'F', 'T' )  )
		oModel:LoadValue( 'UNIDADE', 'OPERADOR'      , '1' )
		oModel:LoadValue( 'UNIDADE', 'MULTIPLICADOR' , AllTrim( Str( SZB->ZB_FATOR ) ) )
		
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
	
	Local oModel  := MPFormModel():New('MODUNIDADE')
	Local oStruct := Struct()
	
	oModel:addFields('UNIDADE',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )
	
	oModel:SetDescription('Cadastro de Unidade de Medida')
	oModel:getModel('UNIDADE'):SetDescription('Cadastro de Unidade de Medida')
	oModel:GetModel( 'UNIDADE' ):SetOnlyQuery ( .T. )
	
Return oModel

Static Function Struct()
	
	Local oStruct := FWFormModelStruct():New()
	
	oStruct:AddTable('SZB_ECALC',,'SZB_ECALC')
	
	oStruct:AddField('ID'            , 'ID'            , 'ID'            , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME'          , 'NOME'          , 'NOME'          , 'C', 10, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('DESCRICAO'     , 'DESCRICAO'     , 'DESCRICAO'     , 'C', 60, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('ATIVO'         , 'ATIVO'         , 'ATIVO'         , 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('OPERADOR'      , 'OPERADOR'      , 'OPERADOR'      , 'C', 01, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('MULTIPLICADOR' , 'MULTIPLICADOR' , 'MULTIPLICADOR' , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	
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
