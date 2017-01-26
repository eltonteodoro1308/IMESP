#include 'protheus.ch'
#include 'parmtype.ch'

user function TSTXML()

	Local oXML := TXmlManager():New()

	If oXml:ParseFile( '\xml\solicitaclientesparaintegrar.xml' )

		If oXml:XPathHasNode(;
		'/soap:Envelope/soap:Body/SolicitaClientesParaIntegrarResponse/SolicitaClientesParaIntegrarResult/Cliente[1]/IdCliente')

			ConOut( 'Ok !!!' )

		Else

			ConOut( 'Erro !!!' )

		End If

		conout( 'Path: '    + oXML:CPATH )
		conout( 'Name: '    + oXML:CNAME )

		Do While oXml:DOMHasChildNode()

			oXml:DOMChildNode()

			conout( 'Path: ' + oXML:CPATH )
			conout( 'Name: ' + oXML:CNAME )

		End Do

	else

		ConOut( oXml:LastError() )

	End If

return