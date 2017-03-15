#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} SGPEC005
Função acionada pelo EAI que retorna o organograma ou parte correspondente a um departamento conforme parâmetro enviado
@author Elton Teodoro Alves
@since 13/03/2016
@version 12.1.014
@param cXml  , Caracter, O conteúdo da tag Content do XML recebido pelo EAI Protheus.
@param cError  , Caracter, Variável passada por referência, serve para alimentar a mensagem de erro, nos casos em que a transação não foi bem sucedida.
@param cWarning, Caracter, Variável passada por referência, serve para alimentar uma mensagem de warning para o EAI. A alteração deste valor por rotinas tratadas neste tópico não causam nenhum efeito para o EAI.
@param cParams , Caracter, Parâmetros passados na mensagem do EAI.
@param oFwEai  , Object  , O objeto de EAI criado na camada do EAI Protheus. A manipulação deste objeto deve ser realizada com o máximo de cautela, e deve ser evitada ao máximo.
@return Caracter , Xml de retorno
/*/
User Function IOGPEC05( cXml, cError, cWarning, cParams, oFwEai )

	Local cRet    := ''
	Local aParams := StrTokArr2( cParams, ',', .T. )
	Local cQuery  := ''
	Local cTmp    := GetNextAlias()
	Local cErro   := ''

	cQuery := "SELECT RD4.RD4_CHAVE,RD4.RD4_DESC FROM " + RetSqlName( "RDK" ) + " RDK "
	cQuery := "LEFT JOIN " + RetSqlName( "RD4" ) + " RD4 ON RDK.RDK_CODIGO = RD4.RD4_CODIGO "
	cQuery := "WHERE RDK.D_E_L_E_T_ = ' '"
	cQuery := "AND RD4.D_E_L_E_T_ = ' '"
	cQuery := "AND RDK.RDK_STATUS = '1'"
	cQuery := "AND RD4.RD4_CHAVE LIKE '" + aParams[ 1 ] + "%'"
	cQuery := "ORDER BY RD4.RD4_CHAVE"

	If TcSqlExec( cQuery ) < 0

		cErro := TcSqlError()

	Else

		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

	EndIf


Return