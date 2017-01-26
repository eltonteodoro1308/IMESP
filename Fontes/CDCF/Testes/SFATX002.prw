#INCLUDE 'TOTVS.CH'

user function SFATX002()

	Local oWsdl      := TWsdlManager():New()
	Local oXml       := TXmlManager():New()
	Local aOps       := {}
	Local aComplex   := {}
	Local aSimple    := {}
	Local cResponse  := ''
	Local oXmlParser := Nil
	Local cError     := ''
	Local cWarning   := ''

	oWsdl:lProcResp := .F.

	If ! oWsdl:ParseFile( "\wsdl\cdcf.wsdl" )

		Return oWsdl:cError

	End If

	aOps := aClone( oWsdl:ListOperations() )

	If Len( aOps ) == 0

		Return oWsdl:cError

	End If

	If ! oWsdl:SetOperation( aOps[ aScan( aOps, { | X | X[ 1 ] == 'ConsultaCliente'} ), 1 ] )

		Return oWsdl:cError

	End If

	aComplex := oWsdl:NextComplex()

	If Len( aComplex ) == 0

		Return oWsdl:cError

	End If

	aSimple  := oWsdl:SimpleInput()

	If Len( aSimple ) == 0

		Return oWsdl:cError

	End If

	If ! oWsdl:SetComplexOccurs( aComplex[ 1 ], 1 )

		Return oWsdl:cError

	endif

	If ! oWsdl:SetValue( aSimple[1][1], '11' )

		Return oWsdl:cError

	End If

	If  ! oWsdl:SetValue( aSimple[2][1], '0'  )

		Return oWsdl:cError

	End If

	If  ! oWsdl:SetValues( aSimple[3][1], {'33042','279191','253425'}  )

		Return oWsdl:cError

	End If

	If ! oWsdl:SendSoapMsg()

		Return oWsdl:cError

	End If

	cResponse := oWsdl:GetSoapResponse()

	MemoWrite( 'c:\temp\ConsultaCliente.xml', cResponse   )

	If ! oXml:Parse( cResponse )

		Return oXml:LastError()

	End If

	ConOut( oXml:cPath )

	Do While oXml:DOMHasChildNode()

		oXml:DOMChildNode()

		//conout( "Name: " + oXML:CNAME )
		conout( "Path: " + oXML:CPATH )
		//conout( "Value: " + oXML:CTEXT )

	End Do

Return