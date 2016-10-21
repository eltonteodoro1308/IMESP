// de model que puxa produtos da filial corrente.

#INCLUDE 'TOTVS.CH'

User Function LoadSB1()

	Local oModel := FWLoadModel( 'LoadSB1' )
	Local oXML   := TXmlManager():New()
	Local nX     := 0

	oModel:Activate()

	oXML:Parse( oModel:GetXmlData() )

	oXml:DOMChildNode()
	oXml:DOMChildNode()

	Do While oXml:CPATH # '/SB1_MODEL/SB1_FIELD/SB1_GRID'

		If oXml:CPATH # '/SB1_MODEL/SB1_FIELD/B1_FILIAL'

			oXml:DOMDelNode()

		Else

			oXml:DOMNextNode()

		End If

	End Do

	oXml:DOMChildNode()

	If oXml:CPATH == '/SB1_MODEL/SB1_FIELD/SB1_GRID/struct'

		oXml:DOMDelNode()

	End If

	oModel:DeActivate()

Return

Static Function ModelDef()

	Local oModel    := MpFormModel():New( 'SB1_MODEL' )
	Local oStrSB1CB := FWFormStruct( 1, 'SB1' )
	Local oStrSB1IT := FWFormStruct( 1, 'SB1' )

	oModel:SetDescription( 'Produtos da Filial Corrente' )

	oModel:AddFields( 'SB1_FIELD', /*cOwner*/, oStrSB1CB, /*bPre*/, /*bPost*/, /*bLoad*/ )
	oModel:GetModel( 'SB1_FIELD' ):SetDescription( 'Filial Corrente' )

	oModel:AddGrid  ( 'SB1_GRID','SB1_FIELD', oStrSB1IT, /*bLinePre*/, /*bLinePost*/, /*bPre*/, /*bPost*/, /*bLoad*/ )
	oModel:GetModel( 'SB1_GRID' ):SetDescription( 'Produtos' )

	oModel:SetRelation( 'SB1_GRID', { { 'B1_FILIAL', 'xFilial( "SB1" )' } }, SB1->( IndexKey( 1 ) ) )

Return oModel