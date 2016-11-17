#include 'totvs.ch'

user function WsdlCdcf()

	Local oWsdl    := TWsdlManager():New()
	Local aParents := {}

	oWsdl:lProcResp := .T.

	If !( oWsdl:ParseFile( '/wsdl/cdcf.wsdl' ) .And.;
	oWsdl:SetOperation( 'SolicitaClientesParaIntegrar' ) )

		ConOut( oWsdl:cError )

		Return

	End If

	aAdd( aParents, 'SolicitaClientesParaIntegrar#1' )
	aAdd( aParents, 'parametros#1' )

	If !( oWsdl:SetValPar( 'IdSistema', aParents, '4' ) .And.;
	oWsdl:SetValPar( 'IdConsulta', aParents, '0' ) )

		ConOut( oWsdl:cError )

		Return

	End If

	ConOut( oWsdl:SendSoapMsg() )

	ConOut( oWsdl:cError )

	ConOut( oWsdl:GetSoapResponse() )

	ConOut( oWsdl:cError )

	ConOut( oWsdl:GetSoapMsg() )

	ConOut( oWsdl:cError )

return