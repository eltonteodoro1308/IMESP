#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} SGPEC004
Função acionada pelo EAI que retorna o superior conforme nível de hierarquia solicitado.
Pelos parâmetros do EAI (variável aParam) será passado o código do funcionário e nível desejado onde 0 (zero)
ao valor default e que se deseja retornar o superior imediato.
@author Elton Teodoro Alves
@since 13/03/2016
@version 12.1.014
@param cXml    , Caracter, O conteúdo da tag Content do XML recebido pelo EAI Protheus.
@param cError  , Caracter, Variável passada por referência, serve para alimentar a mensagem de erro, nos casos em que a transação não foi bem sucedida.
@param cWarning, Caracter, Variável passada por referência, serve para alimentar uma mensagem de warning para o EAI. A alteração deste valor por rotinas tratadas neste tópico não causam nenhum efeito para o EAI.
@param cParams , Caracter, Parâmetros passados na mensagem do EAI.
@param oFwEai  , Object  , O objeto de EAI criado na camada do EAI Protheus. A manipulação deste objeto deve ser realizada com o máximo de cautela, e deve ser evitada ao máximo.
@return cRet   , Xml de retorno
/*/
User Function IOGPEC04( cXml, cError, cWarning, cParams, oFwEai )

	Local cRet    := ''
	Local aParams := StrTokArr2( cParams, ',', .T. )
	Local aArea   := GetArea()
	Local cErro   := ''
	Local cChave  := ''
	Local nNivel  := 0

	If Len( aParams ) = 1 .And. aParams[ 1 ] == ProcName()

		Return RetErro( 'Não Foram enviados parâmetros para a Pesquisa.' )

	ElseIf Len( aParams ) = 1

		aAdd( aParams, '0' )

	EndIf

	DbSelectArea( 'SRA' )
	DbSetOrder( 1 )

	If DbSeek( xFilial( 'SRA' ) + aParams[ 1 ] )

		cChave := GetChave( SRA->RA_DEPTO )

		If SubStr( cChave, 1, Len( 'Erro: ' ) ) == 'Erro: '

			Return RetErro( SubStr( cChave, Len( 'Erro: ' ) + 1, Len( cChave ) ) )

		EndIf

		nNivel := Len( Alltrim( cChave ) ) / 3

		If Val( aParams[ 2 ] ) > nNivel

			Return RetErro( 'Nível Solicitado Excede Hierarquia Possível.' )

		EndIf

		cRet := GetSupXml( cChave, nNivel, aParams[ 2 ] )

		If SubStr( cRet, 1, Len( 'Erro: ' ) ) == 'Erro: '

			Return RetErro( SubStr( cRet, Len( 'Erro: ' ) + 1, Len( cRet ) ) )

		EndIf

	Else

		Return RetErro( 'Mátricula de Funcionário não localizada na base.' )

	EndIf

	RestArea( aArea )

Return cRet



/*/{Protheus.doc} RetErro
Retorna xml com mensagem de erro conforme pareâmetro
@author Elton Teodoro Alves
@since 24/03/2017
@version 12.1.014
@param cErro, characters, Mensagem de erro
@return return, Xml com mensagem de erro
/*/
Static Function RetErro( cErro )

	Local cRet := ''

	cRet += '<IOGPEC04_RET>'
	cRet += '<QB_FILRESP/>'
	cRet += '<QB_MATRESP/>'
	cRet += '<RA_DEPTO/>'
	cRet += '<RA_NOME/>'
	cRet += '<RD4_CHAVE/>'
	cRet += '<RD4_TREE/>'
	cRet += '<ERROR>' + cErro + '</ERROR>'
	cRet += '</IOGPEC04_RET>'

Return cRet

/*/{Protheus.doc} GetChave
Busca na tabela RD4 a chave do departamento na visão ativa
@author Elton Teodoro Alves
@since 24/03/2017
@version 12.1.014
@param cDepto, characters, Código do departamento pesquisado
@return return, Chave do departamento
/*/
Static Function GetChave( cDepto )

	Local cRet   := ''
	Local cErro  := ''
	Local cQuery := ''
	Local cTmp   := GetNextAlias()
	Local aArea  := GetArea()

	cQuery += "SELECT TOP 1 RTRIM(LTRIM(RD4.RD4_CHAVE)) RD4_CHAVE "
	cQuery += "FROM " + RetSqlName( "RD4" ) + " RD4 WHERE RD4.RD4_CODIDE = '"+ cDepto + "' "

	If TcSqlExec( cQuery ) < 0

		cErro := TcSqlError()

	Else

		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

	End If

	If Empty( cErro )

		cRet := ( cTmp )->RD4_CHAVE

	Else

		cRet := "Erro: " + cErro

	EndIf

	( cTmp )->( DbCloseArea() )

	RestArea( aArea )

Return cRet


/*/{Protheus.doc} GetSupXml
Retorna o XML com os dados do superior do funcionário
@author Elton Teodoro Alves
@since 24/03/2017
@version 12.1.014
@param cChave, characters, Chave do departamento na visão ativa
@param nNivel, numeric, Nível da Chave
@return return, Xml com os dados do superior solicitado
@example
(examples)
@see (links_or_references)
/*/
Static Function GetSupXml( cChave, nNivel, nNivelPesq )

	Local cRet   := ''
	Local cErro  := ''
	Local cQuery := ''
	Local cTmp   := GetNextAlias()
	Local aArea  := GetArea()

	cQuery += "SELECT TOP 1 "
	cQuery += "SQB.QB_FILRESP, "
	cQuery += "SQB.QB_MATRESP, "
	cQuery += "SRA.RA_DEPTO, "
	cQuery += "SRA.RA_NOME, "
	cQuery += "RD4.RD4_CHAVE, "
	cQuery += "RD4.RD4_TREE "
	cQuery += "FROM " + RetSqlName( "RDK" ) + " RDK "
	cQuery += "LEFT JOIN " + RetSqlName( "RD4" ) + " RD4 ON RDK.RDK_CODIGO = RD4.RD4_CODIGO "
	cQuery += "LEFT JOIN " + RetSqlName( "SQB" ) + " SQB ON RD4.RD4_CODIDE = SQB.QB_DEPTO "
	cQuery += "LEFT JOIN " + RetSqlName( "SRA" ) + " SRA ON SRA.RA_MAT = SQB.QB_MATRESP "
	cQuery += "AND SRA.RA_FILIAL = SQB.QB_FILRESP "
	cQuery += "WHERE RDK.RDK_STATUS = '1' "
	cQuery += "AND RDK.D_E_L_E_T_ = ' ' "
	cQuery += "AND RD4.D_E_L_E_T_ = ' ' "
	cQuery += "AND SQB.D_E_L_E_T_ = ' ' "
	cQuery += "AND SRA.D_E_L_E_T_ = ' ' "
	cQuery += "AND RD4.D_E_L_E_T_ = ' ' "
	cQuery += "AND RD4.RD4_CHAVE = SUBSTRING( '" + AllTrim( cChave ) + "',1 , 3 * ( " + cValToChar( nNivel ) + " - " + cValToChar( nNivelPesq ) + ") ) "

	If TcSqlExec( cQuery ) < 0

		cErro := TcSqlError()

	Else

		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

	End If

	If Empty( cErro )

		cRet += '<IOGPEC04_RET>'
		cRet += '<QB_FILRESP>' + AllTrim( ( cTmp )->QB_FILRESP ) + '</QB_FILRESP>'
		cRet += '<QB_MATRESP>' + AllTrim( ( cTmp )->QB_MATRESP ) + '</QB_MATRESP>'
		cRet += '<RA_DEPTO>'   + AllTrim( ( cTmp )->RA_DEPTO   ) + '</RA_DEPTO>'
		cRet += '<RA_NOME>'    + AllTrim( ( cTmp )->RA_NOME    ) + '</RA_NOME>'
		cRet += '<RD4_CHAVE>'  + AllTrim( ( cTmp )->RD4_CHAVE  ) + '</RD4_CHAVE>'
		cRet += '<RD4_TREE>'   + AllTrim( ( cTmp )->RD4_TREE   ) + '</RD4_TREE>'
		cRet += '<ERROR/>'
		cRet += '</IOGPEC04_RET>'

	Else

		cRet := "Erro: " + cErro

	EndIf

	( cTmp )->( DbCloseArea() )

	RestArea( aArea )



Return cRet