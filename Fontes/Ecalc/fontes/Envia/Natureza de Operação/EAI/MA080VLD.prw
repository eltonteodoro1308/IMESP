#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function MA080VLD()
	
	Local nOpc        := PARAMIXB[ 1 ]
	Local oModel      := Nil
	Local lInclui     := INCLUI
	Local lRet        := .T.
	Local cHoraInicio := TIME()
	
	If cValToChar( nOpc ) $ '34'
		
		oModel  := ModelDef()
		
		oModel:SetOperation( 3 )
		
		oModel:Activate()
		
		oModel:LoadValue( 'NATUREZADEOPERACAO', 'ID'   , M->F4_CODIGO  )
		oModel:LoadValue( 'NATUREZADEOPERACAO', 'NOME' , M->F4_TEXTO )
		oModel:LoadValue( 'NATUREZADEOPERACAO', 'CFOP' , M->F4_CF )
		oModel:LoadValue( 'NATUREZADEOPERACAO', 'ATIVO', If( M->F4_MSBLQL = '1', 'F', 'T' ) )
		
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
	
Return lRet

Static Function ModelDef()
	
	Local oModel  := MPFormModel():New('MODNATUREZADEOPERACAO')
	Local oStruct := Struct()
	
	oModel:addFields('NATUREZADEOPERACAO',,oStruct)
	oModel:SetPrimaryKey( { 'ID' } )
	
	oModel:SetDescription('Cadastro de Tipos de Entradas e Saidas')
	oModel:getModel('NATUREZADEOPERACAO'):SetDescription('Cadastro de Tipos de Entradas e Saidas')
	oModel:GetModel( 'NATUREZADEOPERACAO' ):SetOnlyQuery ( .T. )
	
Return oModel

Static Function Struct()
	
	Local oStruct := FWFormModelStruct():New()
	
	oStruct:AddTable('SF4_ECALC',,'SF4_ECALC')
	
	oStruct:AddField('ID'   , 'ID'   , 'ID'   , 'C', 20, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('NOME' , 'NOME' , 'NOME' , 'C', 60, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CFOP' , 'CFOP' , 'CFOP' , 'C', 10, 0, , , {}, .F., , .F., .F., .F., , )
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
