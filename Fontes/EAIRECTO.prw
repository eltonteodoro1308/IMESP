#include 'totvs.ch'

user function EAIRECTO( cXML )

	Local cRet    := ''
	Local oMod    := FWLoadModel( 'MATA020' )
	Local oModSA2 := oMod:GetModel( 'MATA020_SA2' )
	Local oStrSA2 := oModSA2:GetStruct()
	Local aStrFld := {}
	Local aSetFld := {'A2_COD','A2_LOJA','A2_NOME'}	
	Local aArea   := GetArea()
	Local oXml    := TXmlManager():New()
	Local nResult := oXml:Parse( cXML )
	Local cA2Cod  := PadR( oXML:XPathGetNodeValue( "/MATA020/MATA020_SA2/A2_COD/value"    ), TAMSX3( 'A2_COD'    )[ 1 ] )
	Local cA2Loja := PadR( oXML:XPathGetNodeValue( "/MATA020/MATA020_SA2/A2_LOJA/value"   ), TAMSX3( 'A2_LOJA'   )[ 1 ] )
	Local lEmpty  := .T. // Indica se gera xml com campos nao obrigatorios vazios
	Local nX      := 0

	For nX := 1 To Len( oStrSA2:aFields )

		If aScan( aSetFld, oStrSA2:aFields[ nX, 3 ] ) # 0

			aAdd( aStrFld, oStrSA2:aFields[ nX ] )

		End If 

	Next nX	

	oStrSA2:aFields := aClone( aStrFld )

	DbSelectArea( 'SA2' )
	DbSetOrder( 1 )
	DbSeek( xFilial( 'SA2' ) + cA2COD + cA2LOJA )

	oMod:Activate()

	cRet := oMod:GetXMLData(,,,,,lEmpty)

	oMod:DeActivate()

	RestArea( aArea )

return cRet