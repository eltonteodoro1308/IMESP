#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} IOMATA01
Função acionada pelo EAI que inclui um cliente com dados mínimos
@author Elton Teodoro Alves
@since 07/04/2017
@version 12.1.014
@param cXml  , Caracter, O conteúdo da tag Content do XML recebido pelo EAI Protheus.
@param cError  , Caracter, Variável passada por referência, serve para alimentar a mensagem de erro, nos casos em que a transação não foi bem sucedida.
@param cWarning, Caracter, Variável passada por referência, serve para alimentar uma mensagem de warning para o EAI. A alteração deste valor por rotinas tratadas neste tópico não causam nenhum efeito para o EAI.
@param cParams , Caracter, Parâmetros passados na mensagem do EAI.
@param oFwEai  , Object  , O objeto de EAI criado na camada do EAI Protheus. A manipulação deste objeto deve ser realizada com o máximo de cautela, e deve ser evitada ao máximo.
@return cRet   , Xml de retorno
/*/
User Function IOMATA01( cXml, cError, cWarning, cParams, oFwEai )

	Local aVetor := {}
	Local aErro  := {}
	Local cErro  := ''
	Local nX     := 0
	Local oXml   := TXmlManager():New()
	Local aArea  := GetArea()

	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.

	If ! oXml:Parse( '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cXML ) .And.;
	oXml:ParseSchemaFile('\schemas\IOMATA01_REM.xsd') .And.;
	oXml:SchemaValidate()

		Return MakeXml( '0', 'Erro no Parse ou Schema Validate do XML enviado: ' + oXml:LastError() )

	End If

	aAdd( aVetor, { 'A1_COD'    ,AllTrim( oXml:XPathGetNodeValue( '/IOMATA01_REM/A1_COD'    ) ), Nil } ) // 01
	aAdd( aVetor, { 'A1_LOJA'   ,'01'                                                          , Nil } ) // 02
	aAdd( aVetor, { 'A1_TIPO'   ,'R'                                                           , Nil } ) // 03
	aAdd( aVetor, { 'A1_NOME'   ,AllTrim( oXml:XPathGetNodeValue( '/IOMATA01_REM/A1_NOME'   ) ), Nil } ) // 04
	aAdd( aVetor, { 'A1_PESSOA' ,AllTrim( oXml:XPathGetNodeValue( '/IOMATA01_REM/A1_PESSOA' ) ), Nil } ) // 05
	aAdd( aVetor, { 'A1_NREDUZ' ,AllTrim( oXml:XPathGetNodeValue( '/IOMATA01_REM/A1_NREDUZ' ) ), Nil } ) // 06
	aAdd( aVetor, { 'A1_END'    ,AllTrim( oXml:XPathGetNodeValue( '/IOMATA01_REM/A1_END'    ) ), Nil } ) // 07
	aAdd( aVetor, { 'A1_EST'    ,AllTrim( oXml:XPathGetNodeValue( '/IOMATA01_REM/A1_EST'    ) ), Nil } ) // 08
	aAdd( aVetor, { 'A1_MUN'    ,AllTrim( oXml:XPathGetNodeValue( '/IOMATA01_REM/A1_MUN'    ) ), Nil } ) // 09
	aAdd( aVetor, { 'A1_CGC'    ,AllTrim( oXml:XPathGetNodeValue( '/IOMATA01_REM/A1_CGC'    ) ), Nil } ) // 10

	DbSelectArea( 'SA1' )
	DbSetOrder( 1 )

	If DbSeek( xFilial( 'SA1' ) +;
	PadR( aVetor[ 1, 2 ], TamSx3( 'A1_COD' )[1] ) +;
	PadR( aVetor[ 2, 2 ], TamSx3( 'A1_LOJA' )[1] ) )

		RestArea( aArea )

		Return MakeXml( '0', 'Cliente já Cadastrado' )

	End If

	DbSetOrder( 3 )

	If DbSeek( xFilial( 'SA1' ) + aVetor[ 10, 2 ] )

		RestArea( aArea )

		Return MakeXml( '0', 'CNPJ/CPF já Cadastrado' )

	End If

	RestArea( aArea )

	MSExecAuto( { | X, Y | MATA030( X, Y ) }, aVetor, 3 )

	If lMsErroAuto

		aErro := aClone( GetAutoGRLog() )

		cErro += Chr(13) + Chr(10)

		For nX := 1 To Len( aErro )

			cErro += aErro[ nX ] + Chr(13) + Chr(10)

		Next nX

		Return MakeXml( '0', Chr(13) + Chr(10) + 'Erro na Gravação do Cadastro do Cliente: ' + cErro )

	End If

Return MakeXml( '1', 'Registro Gravado com Sucesso' )


/*/{Protheus.doc} MakeXml
Gera o xml de retorno da requisição EAI
@author Elton Teodoro Alves
@since 07/04/2017
@version 12.1.014
@param cCod, characters, Código do Resultado da Integração 0 – Erro no Processamento / 1 – Registro Gravado com Sucesso
@param cMsg, characters, Descrição do Resultado da Operação
@return character, Xml de Retorno do EAI
/*/
Static Function MakeXml( cCod, cMsg )

	Local cRet := ''

	cRet += '<IOMATA01_RET>'
	cRet += '<RESULTADO_INTEGRACAO>' + cCod + '</RESULTADO_INTEGRACAO>'
	cRet += '<DESCRICAO_RESULTADO>'  + cMsg + '</DESCRICAO_RESULTADO>'
	cRet += '</IOMATA01_RET>'

Return cRet