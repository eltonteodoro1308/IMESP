#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} FChkLC01
Atualiza o limite de crédito do cliente
em função dos pedidos lançados para o mesmo
@author marcos.aleluia
@since 07/07/2017
@version undefined

@type function
/*/
user function FChkLC01( cCli, cLoja )

	Local nTotPV := 0

	SA1->( dbSetOrder(1) )

	// Posiciona no cliente
	if SA1->( MsSeek( FWxFilial("SA1") + cCli + cLoja ) )

		nTotPV := FGetTotPV()

		// Atualiza o campo de limite de crédito do cliente
		if SA1->( Reclock("SA1", .F.) )
			if SA1->A1_LC > 0
				if nTotPV > 0
					SA1->A1_XLC2 := SA1->A1_LC - nTotPV
				else
					SA1->A1_XLC2 := SA1->A1_LC
				endif
			endif
			SA1->( MsUnlock() )
		endif
	endif

return()



/*/{Protheus.doc} FGetTotPV
Calcula o total em pedido para
um determinado cliente. Considera
TES que gera financeiro.
@author marcos.aleluia
@since 07/07/2017
@version undefined

@type function
/*/
Static Function FGetTotPV()

	Local nRet := 0
	Local cQry := ""
	Local cAlias := GetNextAlias()

	cQry += CRLF + "SELECT "
	cQry += CRLF + "SUM(C6_VALOR) TOT_PV "

	cQry += CRLF + "FROM "
	cQry += CRLF + ""+RetSqlName("SC6")+" C6 "

	cQry += CRLF + "INNER JOIN "+RetSqlName("SC5")+" C5 ON 1=1 "
	cQry += CRLF + "AND C5_FILIAL = '"+FWxFilial("SC5")+"' "
	cQry += CRLF + "AND C5.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "AND C5_NUM = C6_NUM "
	cQry += CRLF + "AND C5_CLIENTE = C6_CLI "
	cQry += CRLF + "AND C5_LOJACLI = C6_LOJA "

	cQry += CRLF + "INNER JOIN "+RetSqlName("SF4")+" F4 ON 1=1 "
	cQry += CRLF + "AND F4_FILIAL = '"+FWxFilial("SF4")+"' "
	cQry += CRLF + "AND F4.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "AND F4_DUPLIC = 'S' "
	cQry += CRLF + "AND F4_CODIGO = C6_TES "

	cQry += CRLF + "WHERE 1=1 "

	cQry += CRLF + "AND C6_FILIAL = '"+FWxFilial("SC6")+"' "
	cQry += CRLF + "AND C6.D_E_L_E_T_ = ' ' "

	///////////////////////////////////////////////////////
	// Quando é a rotina de cancelamento de baixa, a query
	// deverá considerar os pedidos já faturados
	///////////////////////////////////////////////////////
	if ! FWISINCALLSTACK("FA070CAN")
		cQry += CRLF + "AND C6_NOTA = '' "
		cQry += CRLF + "AND C6_SERIE = '' "
		cQry += CRLF + "AND C6_DATFAT = '' "
	endif

	cQry += CRLF + "AND C6_CLI = '"+SA1->A1_COD+"' "
	cQry += CRLF + "AND C6_LOJA = '"+SA1->A1_LOJA+"' "

	memowrite("c:\temp\FChkLC01.sql", cQry)

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), cAlias, .F., .T. )

	if ! (cAlias)->( EOF() )
		nRet := (cAlias)->TOT_PV
	endif

	if select(cAlias) > 0
		(cAlias)->( dbCloseArea() )
	endif

return( nRet )