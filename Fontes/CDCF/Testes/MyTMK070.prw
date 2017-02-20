#INCLUDE 'TOTVS.CH'

User Function MyTmk070()

	Local aContato := {}
	Local aEndereco := {}
	Local aTelefone := {}
	Local aAuxDados := {}
	Private lMsErroAuto := .F.

	RpcSetEnv( '99', '01' )

	aAdd(aContato,{ 'U5_FILIAL'  , xFilial( 'SU5' ), Nil } )
	aAdd(aContato,{ 'U5_CODCONT' , '17985', Nil } )
	aAdd(aContato,{ 'U5_CONTAT'  , 'RicardoBr Teste C D C F', Nil } )
	aAdd(aContato,{ 'U5_CPF'     , '13432016832', Nil } )
	aAdd(aContato,{ 'U5_XCOTCOM' , '2', Nil } )
	aAdd(aContato,{ 'U5_XFATPUB' , '1', Nil } )
	aAdd(aContato,{ 'U5_XFINANC' , '1', Nil } )
	aAdd(aContato,{ 'U5_XNF_E'   , '1', Nil } )
	aAdd(aContato,{ 'U5_XSRVGRF' , '2', Nil } )
	aAdd(aContato,{ 'U5_XPUBLIC' , '1', Nil } )

	aAdd( aAuxDados, { 'AGB_CODIGO' , '17985', Nil } )
	aAdd( aAuxDados, { 'AGB_XTIPO' , '4', Nil } )
	aAdd( aAuxDados, { 'AGB_XEMAIL' , '', Nil } )
	aAdd( aAuxDados, { 'AGB_DDI' , '', Nil } )
	aAdd( aAuxDados, { 'AGB_DDD' , '', Nil } )
	aAdd( aAuxDados, { 'AGB_TELEFO' , '98844955', Nil } )
	aAdd( aAuxDados, { 'AGB_COMP' , '', Nil } )

	AAdd(aTelefone, aClone( aAuxDados) )

	aSize( aAuxDados, 0 )

	aAdd( aAuxDados, { 'AGB_CODIGO' , '17985', Nil } )
	aAdd( aAuxDados, { 'AGB_XTIPO' , '6', Nil } )
	aAdd( aAuxDados, { 'AGB_XEMAIL' , 'ricardobrasil@imprensaoficial.com.br', Nil } )
	aAdd( aAuxDados, { 'AGB_DDI' , '', Nil } )
	aAdd( aAuxDados, { 'AGB_DDD' , '0', Nil } )
	aAdd( aAuxDados, { 'AGB_TELEFO' , '0', Nil } )
	aAdd( aAuxDados, { 'AGB_COMP' , '', Nil } )

	AAdd(aTelefone, aClone( aAuxDados) )

	//MSExecAuto( {| x,y,z,a,b | TMKA070( x,y,z,a,b ) }, aContato,3, {},aTelefone, .F.)
	MSExecAuto( {| x,y,z,a,b | TMKA070( x,y,z,a,b ) }, aContato,5, {},{}, .F.)
	MSExecAuto( {| x,y,z,a,b | TMKA070( x,y,z,a,b ) }, aContato,3, {},aTelefone, .F.)

	If lMsErroAuto
		MsgStop("Erro na gravação do contato")
		MostraErro()
	Else
		MsgAlert('Incluido contato com sucesso.')
	EndIf

	RpcClearEnv()

Return
