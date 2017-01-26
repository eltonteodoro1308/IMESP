#INCLUDE 'TOTVS.CH'

User Function IOMATA01( cXml, cError, cWarning, cParams, oFwEai )

	Local cMetodo   := ''
	Local cRet      := ''
	Local aOps      := {}
	Local aComplex  := {}
	Local aSimple   := {}
	Local cResponse := ''
	Local cWSDLUrl  := GetMv( 'IO_CDCFWSD' )
	Local cIDSist   := GetMv( 'IO_CDCFIDS'  )
	Local cIdCons   := GetMv( 'IO_CDCFIDC' )
	Local oWSDL     := TWsdlManager():New()

	Default cParams := ''

	oWsdl:lProcResp := .F.

	If cParams == ProcName() .Or. Empty( cParams )

		cMetodo := 'SolicitaClientesParaIntegrar'

	Else

		cMetodo := 'ConsultaCliente'

	End If

	If ! oWsdl:ParseUrl( cWSDLUrl )

		Return oWsdl:cError

	End If

	aOps := aClone( oWsdl:ListOperations() )

	If Len( aOps ) == 0

		Return oWsdl:cError

	End If

	If ! oWsdl:SetOperation( aOps[ aScan( aOps, { | X | X[ 1 ] == cMetodo} ), 1 ] )

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

	End IF

	If ! oWsdl:SetValue( aSimple[1][1], cIDSist )

		Return oWsdl:cError

	End If

	If  ! oWsdl:SetValue( aSimple[2][1], cIdCons  )

		Return oWsdl:cError

	End If

	If cMetodo == 'ConsultaCliente'

		If  ! oWsdl:SetValues( aSimple[3][1], StrTokArr2( cParams, ',', .T. )  )

			Return oWsdl:cError

		End If

	End If

	If ! oWsdl:SendSoapMsg()

		Return oWsdl:cError

	End If

	cResponse := oWsdl:GetSoapResponse()

	cRet := DecodeUTF8( cResponse )

Return cRet

Class IOMATA01

	Method New() Constructor

	Data ID
	Data Update
	Data A1_COD
	Data A1_LOJA
	Data A1_NOME
	Data A1_PESSOA
	Data A1_NREDUZ
	Data A1_END
	Data A1_BAIRRO
	Data A1_TIPO
	Data A1_EST
	Data A1_CEP
	Data A1_COD_MU
	Data A1_MUN
	Data A1_DDI
	Data A1_ENDCOB
	Data A1_DDD
	Data A1_TEL
	Data A1_ENDENT
	Data A1_FAX
	Data A1_CONTAT
	Data A1_CGC
	Data A1_PFISIC
	Data A1_INSCR
	Data A1_INSCRM

End Class

Method New( ) Class IOMATA01

Return Self