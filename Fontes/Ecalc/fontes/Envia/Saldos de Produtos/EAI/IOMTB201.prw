//TODO Só enviar saldo de papel verificar se utiliza o campo B1_GRUPO
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function IOMTB201()
	
	Local oModel  := Nil
	Local lInclui := INCLUI
	Local cTrab   := GetNextAlias()
	Local aArea   := GetArea()
	Local cHoraInicio := TIME()
	
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
		
		//oModel:CommitData()
		lRet := EaiEnvio( oModel, Replace( ProcName(), 'U_' ) )
		
	Else
		
		VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)
		
	End If
	
	oModel:DeActivate()
	
	ConOut( ProcName() + ' Executado em ' + ElapTime( cHoraInicio, TIME() ) )
	
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
