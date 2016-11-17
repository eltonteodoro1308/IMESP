#include 'totvs.ch'

user function EAIENVIO()

	Local oFwEai := Nil
	Local cXml   := ''

	RpcSetEnv( "99","01" )

	oFwEai := FWEAI():New()

	cXml += '<MATA020 Operation="1" version="1.000" >'
	cXml += '<MATA020_SA2 modeltype="FIELDS">'
	cXml += '<A2_COD order="2">'
	cXml += '<value>F001</value>'
	cXml += '</A2_COD>'
	cXml += '<A2_LOJA order="3">'
	cXml += '<value>00</value>'
	cXml += '</A2_LOJA>'
	cXml += '</MATA020_SA2>'
	cXml += '</MATA020>'

    oFwEai:AddLayout( 'MATA020', '1.000', 'U_IMSP020', cXml )

	oFwEai:SetDocType( '1' )

	oFwEai:SetFuncCode( 'U_IMSP020' )

	oFwEai:SetFuncDescription( 'FORNECEDORES' )

	oFwEai:SetSendChannel( '2' )

	oFwEai:Activate()

	oFwEai:BuildBusiness()

	ConOut( oFwEai:Save() )

	oFwEai:DeActivate()

	RpcClearEnv()

return