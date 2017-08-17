#INCLUDE 'TOTVS.CH'

user function TSTMT030()

	Local aCliente := {}

	Private	lMsErroAuto    := .F.
	Private	lMsHelpAuto    := .T.
	Private	lAutoErrNoFile := .T.

	aAdd( aCliente, { 'A1_COD'   , '9999'  , Nil} )
	aAdd( aCliente, { 'A1_LOJA'  , '01'            , Nil} )
	aAdd( aCliente, { 'A1_NOME'  , 'NOME'          , Nil} )
	aAdd( aCliente, { 'A1_NREDUZ', 'NOME REDUZIDO' , Nil} )
	aAdd( aCliente, { 'A1_END'   , 'ENDERECO'      , Nil} )
	aAdd( aCliente, { 'A1_TIPO'  , 'R'             , Nil} )
	aAdd( aCliente, { 'A1_EST'   , 'SP'            , Nil} )
	aAdd( aCliente, { 'A1_MUN'   , 'SAO PAULO'     , Nil} )

	RpcSetEnv( '99', '01' )

	MSExecAuto( { | X, Y | MATA030( X, Y ) }, aCliente, 3 )

	If lMsErroAuto

		VarInfo( '', GetAutoGRLog(),, .F., .T. )

	Else

		ConOut( 'OK !!!!' )

	End If

	MSExecAuto( { | X, Y | MATA030( X, Y ) }, aCliente, 4 )

	If lMsErroAuto

		VarInfo( '', GetAutoGRLog(),, .F., .T. )

	Else

		ConOut( 'OK !!!!' )

	End If

	RpcClearEnv()

return