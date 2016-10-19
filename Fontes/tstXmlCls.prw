#include "protheus.ch"

user function tstXmlCls()
	Local cXML := ""
	Local oXML
	Local xRet
	Local nI := 0, nLen:= 0
	Local lLoop := .T., lRet1 := .F., lRet2 := .F.

	oXML := TXmlManager():New()

	cXML := '<?xml version="1.0"?>' + CRLF
	cXML += '<bookStore name="Saraiva" country="BR">' + CRLF
	cXML += '  <foundation>' + CRLF
	cXML += '    <founder>Seu Saraiva</founder>' + CRLF
	cXML += '    <year>1914</year>' + CRLF
	cXML += '  </foundation>' + CRLF
	cXML += '  <books>' + CRLF
	cXML += '    <book isNew="true">' + CRLF
	cXML += '      <title>A Game of Thrones</title>' + CRLF
	cXML += '      <author>George R. R. Martin</author>' + CRLF
	cXML += '      <price>9.99</price>' + CRLF
	cXML += '      <origin>US</origin>' + CRLF
	cXML += '    </book>' + CRLF
	cXML += '    <book isNew="true">' + CRLF
	cXML += '      <title>A Clash of Kings</title>' + CRLF
	cXML += '      <author>George R. R. Martin</author>' + CRLF
	cXML += '      <price>9.99</price>' + CRLF
	cXML += '      <origin>US</origin>' + CRLF
	cXML += '    </book>' + CRLF
	cXML += '  </books>' + CRLF
	cXML += '</bookStore>' + CRLF

	xRet := oXML:Parse( cXML )
	if xRet == .F.
		conout( "Error: " + oXML:Error() )
		return
	endif

	while lLoop
		conout( "Name: " + oXML:CNAME )
		conout( "Path: " + oXML:CPATH )
		conout( "Value: " + oXML:CTEXT )

		xRet := oXML:DOMHasAtt()
		if !xRet
			conout( "No attributes" )
		else
			xRet := oXML:DOMGetAttArray()
			nLen := Len( xRet )
			conout( cValToChar( nLen ) + " attributes:" )
			for nI := 1 to nLen
				conout( "Attribute " + cValToChar( nI ) )
				conout( "Name: " + xRet[nI][1] )
				conout( "Value: " + xRet[nI][2] )
				conout( "" )
			next nI
		endif

		xRet := oXML:DOMHasNextNode()
		conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )

		xRet := oXML:DOMHasPrevNode()
		conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )

		xRet := oXML:DOMHasParentNode()
		conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )

		xRet := oXML:DOMHasChildNode()
		conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )

		xRet := oXML:DOMChildCount()
		conout( "# of Children: " + cValToChar( xRet ) )

		if oXML:DOMHasChildNode()
			xRet := oXML:DOMChildNode()
		elseif oXML:DOMHasNextNode()
			xRet := oXML:DOMNextNode()
		else
			lRet1 := oXML:DOMParentNode()
			if lRet1
				lRet2 := oXML:DOMNextNode()

				while !lRet2
					lRet1 := oXML:DOMParentNode()
					lRet2 := oXML:DOMNextNode()

					if !lRet1 .And. !lRet2
						return
					endif
				enddo

				loop
			else
				conout( "Error not possible, once it came from a parent" )
				return
			endif
		endif

		if xRet == .F.
			conout( "Error: " + oXML:Error() )
			return
		endif
	enddo
return