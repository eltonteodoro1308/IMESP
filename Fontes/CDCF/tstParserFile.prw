#Include 'Protheus.ch'

#include 'totvs.ch'



User Function tstParserFile()



	Local oWsdl

	Local xRet



	// Cria o objeto da classe TWsdlManager

	oWsdl := TWsdlManager():New()



	// Faz o parse de um arquivo

	xRet := oWsdl:ParseFile( "\wsdl\cdcf.wsdl" )

	if xRet == .F.

		conout( "Erro: " + oWsdl:cError )

		return

	else

		conout( "Parse feito com sucesso" )

	endif



	//Lista operações

	aOps := oWsdl:ListOperations()



	//Verifica se as operações foram retornadas com sucesso

	if Len( aOps ) == 0

		conout( "Erro: " + oWsdl:cError )

		Return

	endif



	// Define a operação

	xRet := oWsdl:SetOperation( aOps[13][1] )



	//Verifica se a operação foi realizada com sucesso

	if xRet == .F.

		conout( "Erro: " + oWsdl:cError )

		Return

	else

		conout("Operacao setada com sucesso")

	endif



	aComplex := oWsdl:NextComplex()

	aSimple := oWsdl:SimpleInput()



	xRet := oWsdl:SetComplexOccurs( aComplex[1], 1 )

	if xRet == .F.

		conout( "Erro ao definir elemento")

		return

	endif



	xRet := oWsdl:SetValue( aSimple[1][1], "123" )

	xRet := oWsdl:SetValue( aSimple[2][1], "123" )



	if xRet == .F.

		conout( "Erro ao definir elemento")

		return

	endif



	cSoap := oWsdl:GetSoapMsg()

	conout(oWsdl:GetSoapMsg())



Return
