#INCLUDE 'TOTVS.CH'

user function TSTCTB030( oModel )

	Local cWSDLUrl := 'http://10.20.5.182/WSIntegraImesp.asmx?wsdl'
	Local oWSDL    := TWsdlManager():New()
	Local aOps     := {}
	Local aComplex := {}
	Local aSimple  := {}
	Local aFields  := { 'Usuario', 'Senha', 'id', 'nome', 'ativo'}
	Local aValues  := { 'Master', 'MASTER', 'C001', 'Centro de Custo 001', '' }
	Local nX       := 0
	Local cMsg     := ''

	// Define que a validacao da resposta do WebService do CDCF nao sera processada
	oWsdl:lProcResp := .F.

	// Efetua o parse do WSDL do WebService
	If ! oWsdl:ParseUrl( cWSDLUrl )

		//cErro := 'Erro no Parse da URL do WSDL do WebService: ' + oWsdl:cError

		UserException( 'Erro no Parse da URL do WSDL do WebService: ' + oWsdl:cError )

		Return

	End If

	// Atribui a variavel array com as operacoes do WebService
	aOps := aClone( oWsdl:ListOperations() )

	If Len( aOps ) == 0

		cErro := 'Não foi disponibilizada nenhuma operação pelo WebService através do documento WSDL: ' + oWsdl:cError

		Return

	End If

	// Seta a operacao a ser executada
	If ! oWsdl:SetOperation( aOps[ aScan( aOps, { | X | X[ 1 ] == 'salvarCentroDeCusto'} ), 1 ] )

		cErro := 'Não foi possível definir o método salvarCentroDeCusto como a operação a ser realizada: ' + oWsdl:cError

		Return

	End If

	// Atribui a variavel os tipos complexos da operacao
	//	aComplex := oWsdl:NextComplex()
	//
	//	If Len( aComplex ) == 0
	//
	//		cErro := 'Nenhum Elemeto do Tipo Complexo foi Localizado: ' + oWsdl:cError
	//
	//		Return
	//
	//	End If

	// Atribui a variavel os tipos simples da operacao
	//	aSimple  := oWsdl:SimpleInput()
	//
	//	If Len( aSimple ) == 0
	//
	//		cErro := 'Nenhum Elemeto do Tipo Simples foi Localizado: ' + oWsdl:cError
	//
	//		Return
	//
	//	End If

	// Define o numero de ocorrencias do tipo complexo
	//	If ! oWsdl:SetComplexOccurs( aComplex[ 1 ], 1 )
	//
	//		cErro := 'Não foi possível definir o número de vezes do Tipo Complexo: ' + oWsdl:cError
	//
	//		Return
	//
	//	End IF
	//
	//
	//	For nX := 1 To Len( aFields )
	//
	//		If ! oWsdl:SetValue( nX, aValues[nX] )
	//
	//			cErro := 'Não foi possível definir o valor da variável ' + aFields[nX] + ': ' + oWsdl:cError
	//
	//			Return
	//
	//		End If
	//
	//
	//	Next nX

	cMsg += '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/">'
	cMsg += '<soap:Header/>'
	cMsg += '<soap:Body>'
	cMsg += '<tem:salvarCentroDeCusto>'
	cMsg += '<tem:token>'
	cMsg += '<tem:Usuario>Master</tem:Usuario>'
	cMsg += '<tem:Senha>MASTER</tem:Senha>'
	cMsg += '</tem:token>'
	cMsg += '<tem:id>' + AllTrim(oModel:GetValue( 'CTT_MODEL', 'CTT_CUSTO' )) + '</tem:id>'
	cMsg += '<tem:nome>' + AllTrim(oModel:GetValue( 'CTT_MODEL', 'CTT_DESC01' )) + '</tem:nome>'
	cMsg += '<tem:ativo>' + If(oModel:GetValue( 'CTT_MODEL', 'CTT_BLOQ' ) = '1','false','true') + '</tem:ativo>'
	cMsg += '</tem:salvarCentroDeCusto>'
	cMsg += '</soap:Body>'
	cMsg += '</soap:Envelope>'

	// Efetua comunicacao com WebService do CDCF
	If ! oWsdl:SendSoapMsg( cMsg )

		cErro := 'Não foi possível o envio do documento SOAP gerado ao endereço definido: ' + oWsdl:cError

		Return

	End If

	// Atribui a Variável o retorno do WebService
	cXml := oWsdl:GetSoapResponse()

return