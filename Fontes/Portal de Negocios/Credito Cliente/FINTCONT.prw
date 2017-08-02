#include 'protheus.ch'
#include 'parmtype.ch'

user function FINTCONT( cXml, cError, cWarning, cParams, oFwEai )

	Local cRet := ""
	Local cQry := ""
	Local cAlias := ""
	Local aParams := {}
	Local cCodContr := aParams[1]
	Local cSitContr := aParams[2]

	Default cTpContr := ""
	Default cStatContr := ""

	//RpcSetType(3)
	//RpcSetEnv('99','01')

	if ! empty(cParams)
		if ! '/' $ cParams
			Return "Não foi encontrado o separador '/' nos parâmetros enviados!"
		elseif right( ALLTRIM( cParams ), 1 ) == '/'
			Return "Não foi passado no parâmetro o Status do Contrato!"
		elseif left( cParams, 1 ) == '/'
			Return "Não passado no parâmetro o número do Contrato!"
		endif
	endif

	cAlias := GetNextAlias()

	if ! empty(cCodContr)

		cQry := " SELECT"+CHR(13)
		cQry += " CN9_NUMERO"+CHR(13)
		cQry += " ,CN9_CLIENT"+CHR(13)
		cQry += " FROM "+RetSqlName("CN9")+""+CHR(13)
		cQry += " WHERE 1=1"+CHR(13)
		cQry += " AND D_E_L_E_T_ = ' '"+CHR(13)
		cQry += " AND CN9_FILIAL = '"+FWxFilial("CN9")+"'"+CHR(13)
		cQry += " AND CN9_NUMERO = '"+cCodContr+"'"+CHR(13)
		cQry += " AND CN9_SITUAC = '"+cSitContr+"'"+CHR(13)
		cQry += " "+CHR(13)

		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), cAlias, .F., .T. )

		if ! (cAlias)->( EOF() )
			cRet := (cAlias)->CN9_NUMERO
		else
			cRet := "Contrato não encontrado!"
		endif

		if select(cAlias) > 0
			(cAlias)->( dbCloseArea() )
		endif

	endif

return( cRet )