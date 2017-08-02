#include 'protheus.ch'
#include 'parmtype.ch'

user function FINTCLIE( cXml, cError, cWarning, _cCgc, oFwEai  )

	Local cRet := ""
	Default _cCgc := ""

	//RpcSetType(3)
	//RpcSetEnv('99','01')

	if ! empty(_cCgc)
		SA1->( dbSetOrder(3) )
		if SA1->( MsSeek( FWxFilial("SA1") + _cCgc ) )
			cRet := SA1->A1_LC
		else
			cRet := "CGC não encontrado!"
		endif
	else
		cRet := "CGC não pode ser vazio"
	endif

return( cRet )