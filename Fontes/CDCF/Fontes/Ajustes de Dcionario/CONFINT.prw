#include 'protheus.ch'
#include 'parmtype.ch'

user function CONFINT()

	Local cWSDLUrl := GetMv( 'IO_CDCFWSD' ) // URL do WSDL do WebService do CDCF
	Local cIDSist  := GetMv( 'IO_CDCFIDS' ) // ID do Sistema Protheus no CDCF
	Local cIdCons  := GetMv( 'IO_CDCFIDC' ) // ID da Consulta no CDCF
	Local oWSDL    := TWsdlManager():New()
	Local aOps     := {}
	Local aComplex := {}
	Local aSimple  := {}
	Local cMsg     := ''

	// Define que a validacao da resposta do WebService do CDCF nao sera processada
	oWsdl:lProcResp := .F.

	// Efetua o parse do WSDL do WebService
	If ! oWsdl:ParseUrl( cWSDLUrl )

		U_IOEXCPT( cUuid, cMsg := 'Erro no Parse da URL do WSDL do WebService: ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Atribui a variavel array com as operacoes do WebService
	aOps := aClone( oWsdl:ListOperations() )

	If Len( aOps ) == 0

		U_IOEXCPT( cUuid, cMsg := 'Não foi disponibilizada nenhuma operação pelo WebService através do documento WSDL: ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Seta a operacao a ser executada
	If ! oWsdl:SetOperation( aOps[ aScan( aOps, { | X | X[ 1 ] == 'ConfirmaIntegracaoCliente'} ), 1 ] )

		U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o método ConfirmaIntegracaoCliente como a operação a ser realizada: ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Atribui a variavel os tipos complexos da operacao
	aComplex := oWsdl:NextComplex()

	If Len( aComplex ) == 0

		U_IOEXCPT( cUuid, cMsg := 'Nenhum Elemeto do Tipo Complexo foi Localizado: ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Atribui a variavel os tipos simples da operacao
	aSimple  := oWsdl:SimpleInput()

	If Len( aSimple ) == 0

		U_IOEXCPT( cUuid, cMsg := 'Nenhum Elemeto do Tipo Simples foi Localizado: ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Define o numero de ocorrencias do tipo complexo
	If ! oWsdl:SetComplexOccurs( aComplex[ 1 ], 1 )

		U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o número de vezes do Tipo Complexo: ' + oWsdl:cError )

		UserException( cMsg )

	End IF

	// Seta o valor do tipo simples correspondente ao ID do Sistema Protheus no CDCF
	If ! oWsdl:SetValue( aSimple[1][1], cIDSist )

		U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o valor da variável ' + aSimple[1][2] + ': ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Seta o valor do tipo simples correspondente ao ID da Consulta no CDCF
	If  ! oWsdl:SetValue( aSimple[2][1], cIdCons  )

		U_IOEXCPT( cUuid, cMsg := 'Não foi possível definir o valor da variável ' + aSimple[2][2] + ': ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Efetua comunicacao com WebService do CDCF
	If ! oWsdl:SendSoapMsg()

		U_IOEXCPT( cUuid, cMsg := 'Não foi possível o envio do documento SOAP gerado ao endereço definido: ' + oWsdl:cError )

		UserException( cMsg )

	End If

	// Atribui a Variável o retorno do WebService
	cXml := oWsdl:GetSoapResponse()

return