#include 'protheus.ch'
#include 'parmtype.ch'

user function TSTMT240()

	Local aCpos := {}
	Local aErro := {}
	Local nX    := 0
	Local cDoc  := '134'//AllTrim( Str( Randomize( 100, 500 ) ) )

	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.

	RpcSetEnv( '99','01' )

	aAdd( aCpos, { 'D3_TM'     , '501'           , Nil } )
	aAdd( aCpos, { 'D3_COD'    , 'MP001'         , Nil } )
	aAdd( aCpos, { 'D3_QUANT'  , 100             , Nil } )
	aAdd( aCpos, { 'D3_XDECALC', cDoc            , Nil } )
	aAdd( aCpos, { 'D3_OP'     , '00000101001'   , Nil } )
	aAdd( aCpos, { 'D3_EMISSAO', Stod('20170724'), Nil } )

	MSExecAuto( { | X, Y | MATA240( X, Y ) }, aCpos, 3 )

	If lMsErroAuto

		aErro := aClone( GetAutoGRLog() )

		For nX := 1 To Len( aErro )

			ConOut( aErro[ nX ] )

		Next nX

	End If

	aSize( aCpos, 0 )

	DbSelectArea( 'SD3' )
	DBOrderNickname( 'ESTORNADO' )

	DbSeek( FwxFilial( 'SD3' ) + PadR( cDoc, GetSx3Cache( 'D3_XDECALC', 'X3_TAMANHO' ) ) + ' ' )

	For nX := 1 To FCount()

		aAdd( aCpos, { FieldName( nX ), SD3->&( FieldName( nX ) ), Nil } )

	Next nX

	aAdd( aCpos, { 'INDEX', 2, Nil } )

	MSExecAuto( { | X, Y | MATA240( X, Y ) }, aCpos, 5 )

	If lMsErroAuto

		aErro := aClone( GetAutoGRLog() )

		For nX := 1 To Len( aErro )

			ConOut( aErro[ nX ] )

		Next nX

	End If

	RpcClearEnv()

return