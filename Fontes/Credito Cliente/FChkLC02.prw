#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} FChkLC02
Atualiza o limite de crédito do cliente
em função das movimentações no financeiro para o mesmo
@author marcos.aleluia
@since 07/07/2017
@version undefined

@type function
/*/
user function FChkLC02()

	Local nTotPV := 0

	SA1->( dbSetOrder(1) )

	// Posiciona no cliente
	if SA1->( MsSeek( FWxFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA ) )

		nTotPV := FGetBxCli()

		// Atualiza o campo de limite de crédito do cliente
		if nTotPV > 0
			if SA1->( Reclock("SA1", .F.) )
				if SA1->A1_LC > 0
					SA1->A1_XLC2 += nTotPV
				endif
				SA1->( MsUnlock() )
			endif
		endif

	endif

return



/*/{Protheus.doc} FGetBxCli
Retorna quanto teve de baixa para o cliente
@author marcos.aleluia
@since 07/07/2017
@version undefined

@type function
/*/
Static Function FGetBxCli()

	Local nRet := 0
	Local cQry := ""
	Local cAlias := GetNextAlias()
	
	cQry += CRLF + "SELECT SUM(E5_VALOR) TOT_BX_CLI"
	
	cQry += CRLF + "FROM "+RetSQLName('SE5')+" SE5"
	
	cQry += CRLF + "INNER JOIN "+RetSQLName('SE1')+" SE1"
	cQry += CRLF + "		ON	E1_FILIAL = '"+FWxFilial('SE1')+"'"
	cQry += CRLF + "		AND	SE1.E1_NATUREZ = SE5.E5_NATUREZ"
	cQry += CRLF + "		AND SE1.E1_PREFIXO = SE5.E5_PREFIXO"
	cQry += CRLF + "		AND SE1.E1_NUM = SE5.E5_NUMERO"
	cQry += CRLF + "		AND SE1.E1_PARCELA = SE5.E5_PARCELA"
	cQry += CRLF + "		AND SE1.E1_TIPO = SE5.E5_TIPO"
	cQry += CRLF + "		AND SE1.E1_CLIENTE = SE5.E5_CLIFOR"
	cQry += CRLF + "		AND SE1.E1_LOJA = SE5.E5_LOJA"
	cQry += CRLF + "		AND SE1.E1_TIPO NOT IN " + FormatIn(MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM,"/")
	cQry += CRLF + "		AND SE1.D_E_L_E_T_ = ' '"
	
	cQry += CRLF + "WHERE 1=1"

	cQry += CRLF + "		AND SE5.E5_FILIAL = '"+FWxFilial('SE5')+"'"
	cQry += CRLF + "		AND SE5.E5_RECPAG = 'R'"
	cQry += CRLF + "		AND SE5.E5_SITUACA <> 'C'"
	cQry += CRLF + "		AND SE5.E5_CLIFOR = '"+SA1->A1_COD+"'"
	cQry += CRLF + "		AND SE5.E5_LOJA = '"+SA1->A1_LOJA+"'"
	cQry += CRLF + "		AND SE5.D_E_L_E_T_= ' ' "
	cQry += CRLF + "		AND NOT EXISTS ("
	cQry += CRLF + "					SELECT 1"
	cQry += CRLF + "					FROM "+RetSQLName('SE5')+" A"
	cQry += CRLF + "					WHERE 1=1"
	cQry += CRLF + "						AND A.E5_FILIAL = '"+FWxFilial('SE5')+"'"
	cQry += CRLF + "						AND A.E5_NATUREZ = SE5.E5_NATUREZ"
	cQry += CRLF + "						AND A.E5_PREFIXO = SE5.E5_PREFIXO"
	cQry += CRLF + "						AND A.E5_NUMERO = SE5.E5_NUMERO"
	cQry += CRLF + "						AND A.E5_PARCELA = SE5.E5_PARCELA"
	cQry += CRLF + "						AND A.E5_TIPO = SE5.E5_TIPO"
	cQry += CRLF + "						AND A.E5_CLIFOR = SE5.E5_CLIFOR"
	cQry += CRLF + "						AND A.E5_LOJA = SE5.E5_LOJA"
	cQry += CRLF + "						AND A.E5_SEQ = SE5.E5_SEQ"
	cQry += CRLF + "						AND A.E5_TIPODOC = 'ES'"
	cQry += CRLF + "						AND A.E5_RECPAG <> 'R'"
	cQry += CRLF + "						AND A.D_E_L_E_T_ = ' '"
	cQry += CRLF + "					)"

	memowrite("c:\temp\FChkLC02.sql", cQry)

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), cAlias, .F., .T. )

	if ! (cAlias)->( EOF() )
		nRet := (cAlias)->TOT_BX_CLI
	endif

	if select(cAlias) > 0
		(cAlias)->( dbCloseArea() )
	endif

return( nRet )