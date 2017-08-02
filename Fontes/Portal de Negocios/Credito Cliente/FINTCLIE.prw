#include 'protheus.ch'
#include 'parmtype.ch'

user function FINTCLIE( cXml, cError, cWarning, _cCod, oFwEai  )

	Local cRet := ""
	Default _cCod := ""

	//RpcSetType(3)
	//RpcSetEnv('99','01')

	_cCod := Replace( _cCod, ',', '.' )

	if ! empty(_cCod)
		SA1->( dbSetOrder(1) )
		ConOut( FWxFilial("SA1") + _cCod )
		if SA1->( MsSeek( FWxFilial("SA1") + _cCod ) )
			cRet := SA1->A1_XLC2
		else
			cRet := "Cliente não encontrado!"
		endif
	else
		cRet := "Cliente não pode ser vazio"
	endif

return( cRet )