#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOSA1BLD
//Retorno uma instância de objeto da classe IOSA1CLS
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@return return, Instância de objeto da classe IOSA1CLS
/*/
User Function IOSA1BLD()

	Local oObject := IOSA1CLS():New()

Return oObject

/*/{Protheus.doc} IOSA1CLS
//Classe que representa o cadastro do cliente e seus contatos a serem incluidos/atualizados na base
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
/*/
Class IOSA1CLS

	// idSistemaCriacaoOrAlteracao,

	Data cXCDCDCF // cliente.IdCliente
	Data cCOD     // cliente.CodigoERP
	Data cLoja
	Data cTipo
	Data cNREDUZ  // sNomeFantasia,
	Data cNOME    // cliente.NomeCliente
	Data cCGC     // cliente.DocumentoCliente
	Data cINSCR   // pj.InscricaoEstadual
	Data cINSCRM  // pj.InscricaoMunicipal
	Data cMSBLQL  // cliente.ClienteAtivo ? (short?)1 : (short?)0,
	Data cPESSOA  // cliente.IdTipoEsfera == 4 ? "F" : "J",//Se for pessoa física é F, senão for é J.

	// "S",//Fixo Sim,
	// "S",//Fixo Sim,

	Data cXESFERA // sEsfera
	Data dDTCAD	  // sSistemaCriacao
	Data dXDTALT  // sSistemaAlteracao
	Data dDTNASC  // cliente.PessoaFisica != null ? cliente.PessoaFisica.DataNascimento : null,//Se PessoaFisica diferemte de nulo, manda a data de nascimento.
	Data cXSEXO   // cliente.PessoaFisica == null ? "N" : (cliente.PessoaFisica.IdTipoSexo == 1 ? "F" : "M")
	Data cXORGPUB // cliente.OrgaoPublico != null ? (short?)1 : (short?)0,
	Data cEND     // endPrincipal.TipoLogradouro // endPrincipal.Logradouro	// endPrincipal.LogradouroNumero
	Data cCOMPLEM // endPrincipal.LogradouroComplemento
	Data cBAIRRO  // endPrincipal.Bairro
	Data cCOD_MUN // endPrincipal.CodigoMunicipio
	Data cMUN     // endPrincipal.Municipio,
	Data cEST     // endPrincipal.SiglaUnidadeFederativa,
	Data cCEP     // endPrincipal.CEP,
	Data cXNMPAIS // dPaisPrincipal.NomePais,
	Data cENDCOB  // endCobranca.TipoLogradouro	// endCobranca.Logradouro // endCobranca.LogradouroNumero
	Data cXCMPCOB // endCobranca.LogradouroComplemento,
	Data cXBROCOB // endCobranca.Bairro,
	Data cXCDMNCB // endCobranca.CodigoMunicipio,
	Data cXMUNCOB // endCobranca.Municipio,
	Data cXESTCOB // endCobranca.SiglaUnidadeFederativa,
	Data cXCEPCOB // endCobranca.CEP,
	Data cXNMPSCB // dPaisCobranca.NomePais,
	Data cENDENT  // endEntregaPrincipal.TipoLogradouro // endEntregaPrincipal.Logradouro // endEntregaPrincipal.LogradouroNumero
	Data cXCMPENT // endEntregaPrincipal.LogradouroComplemento
	Data cXBROENT // endEntregaPrincipal.Bairro
	Data cXCDMNET // endEntregaPrincipal.CodigoMunicipio
	Data cXMUNENT // endEntregaPrincipal.Municipio,
	Data cXESTENT // endEntregaPrincipal.SiglaUnidadeFederativa,
	Data cXCEPENT // endEntregaPrincipal.CEP,
	Data cXNMPSET // dPaisEntregaPrincipal.NomePais,
	Data cDDI     // meioComunicacao.DDI,
	Data cDDD     // meioComunicacao.DDD,
	Data cTEL     // meioComunicacao.Telefone,
	Data cXRAMAL  // meioComunicacao.Ramal,

	// meioComunicacaoDonoConta.Email,
	// clienteContatoDonodaConta.NomeContato,
	// meioComunicacaoFax.DDD + meioComunicacaoFax.Telefone

	Data cEMAIL
	Data cXDHCDCF

	// Atributos da classe que não tem campo correspondente no dicionário
	Data lErroAuto
	Data cErroMsg
	Data aContatos

	Method New() Constructor
	Method Grava()
	Method VincContat()

End Class

/*/{Protheus.doc} New
//Método Contrutor da Classe Cliente
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
@return return, Instância de objeto da classe IOSA1CLS
/*/
Method New() Class IOSA1CLS

	Local aAtributos := ClassDataArr( Self, .F. )
	Local nX         := 0

	For nX := 1 To Len( aAtributos )

		If SubStr( aAtributos[ nX, 1 ], 1, 1 ) == 'A'

			Eval( &( '{||Self:' + aAtributos[ nX, 1 ] + ' := {} }' ) )

		ElseIf SubStr( aAtributos[ nX, 1 ], 1, 1 ) $ 'CM'

			Eval( &( '{||Self:' + aAtributos[ nX, 1 ] + ' := "" }' ) )

		ElseIf SubStr( aAtributos[ nX, 1 ], 1, 1 ) == 'D'

			Eval( &( '{||Self:' + aAtributos[ nX, 1 ] + ' := CtoD( "" ) }' ) )

		ElseIf SubStr( aAtributos[ nX, 1 ], 1, 1 ) == 'L'

			Eval( &( '{||Self:' + aAtributos[ nX, 1 ] + ' := .F. }' ) )

		ElseIf SubStr( aAtributos[ nX, 1 ], 1, 1 ) == 'N'

			Eval( &( '{||Self:' + aAtributos[ nX, 1 ] + ' := 0 }' ) )

		Else

			Eval( &( '{||Self:' + aAtributos[ nX, 1 ] + ' := Nil }' ) )

		End If

	Next nX

	Self:cLoja   := '01'
	Self:cTipo    := 'R'

Return Self

/*/{Protheus.doc} Grava
//Grava o objeto no banco via execauto
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
/*/
Method Grava() Class IOSA1CLS

	Local aAtributos := {}
	Local aBuffer    := {}
	Local aCliente   := {}
	Local oContato   := Nil
	Local oMeioComum := Nil
	Local cCampo     := ''
	Local cOrdem     := ''
	Local aArea      := GetArea()
	Local nPos       := 0
	Local aErro      := {}
	Local xValor     := Nil
	Local nX         := 0
	Local nY         := 0

	Private	lMsErroAuto    := .F.
	Private	lMsHelpAuto    := .T.
	Private	lAutoErrNoFile := .T.

	Self:cCod  := PadR( Self:cCod, GetSx3Cache( 'A1_COD', 'X3_TAMANHO' ) )

	// Percorre lista de contatos, verifica quem recebe email da nf-e e
	// preenche o campo do cadastro do cliente com o email.
	For nX := 1 To Len( Self:aContatos )

		oContato := Self:aContatos[ nX ]

		If oContato:cXNF_E == '1'

			For nY:= 1 To Len( oContato:aMeioComun )

				oMeioComum := oContato:aMeioComun[ nY ]

				If oMeioComum:cXTIPO == '6'

					Self:cEMAIL += oMeioComum:cXEMAIL + ';'

				End If

			Next nY

		End If

	Next nX

	aAtributos := ClassDataArr( Self, .F. )

	For nX := 1 To Len( aAtributos )

		If ! Upper( aAtributos[ nX, 1 ] ) $ Upper( 'lErroAuto/cErroMsg/aContatos' )

			cCampo := 'A1_' + SubStr( aAtributos[ nX, 1 ], 2, 7 )
			xValor := aAtributos[ nX, 2 ]

			If ValType( cOrdem := GetSx3Cache( cCampo, 'X3_ORDEM' ) ) # 'U' .And. ! Empty( xValor );
			.And. ValType( xValor ) # 'U'

				aAdd( aBuffer, { cCampo, xValor, cOrdem } )

			End If

		End If

	Next nX

	aCliente := aSort( aBuffer,,, { | X, Y |  X[ 3 ] < Y[ 3 ] } )

	For nX := 1 To Len( aCliente )

		aCliente[ nX, 3 ] := Nil

	Next nX

	nPos := aScan( aCliente, { | X | X[ 1 ] == 'A1_COD' } )

	DbSelectArea( 'SA1' )
	DbSetOrder( 1 )

	If DbSeek( xFilial( 'SA1' ) + aCliente[ nPos, 2 ] )

		MSExecAuto( { | X, Y | MATA030( X, Y ) }, aCliente, 4 )

	Else

		MSExecAuto( { | X, Y | MATA030( X, Y ) }, aCliente, 3 )

	End If

	If Self:lErroAuto := lMsErroAuto

		aErro := aClone( GetAutoGRLog() )

		For nX := 1 To Len( aErro )

			Self:cErroMsg += aErro[ nX ] + Chr(13) + Chr(10)

		Next nX

	End If

	RestArea( aArea )

Return

/*/{Protheus.doc} VincContat
//Vincula o Cliente aos seus contatos correspondentes
@author Elton Teodoro Alves
@since 17/08/2017
@version 12.1.017
/*/
Method VincContat() Class IOSA1CLS

	Local nX       := 0
	Local oContato := Nil
	Local aArea    := GetArea()

	For nX := 1 To Len( Self:aContatos )

		oContato := Self:aContatos[ nX ]

		If ! oContato:lErroAuto

			DbSelectArea( 'AC8' )
			DbSetOrder( 1 )

			RecLock( 'AC8', .T. )

			AC8->AC8_ENTIDA := 'SA1'
			AC8->AC8_CODENT := PadR( Self:cCOD, GetSx3Cache( 'A1_COD', 'X3_TAMANHO' ) ) + Self:cLoja
			AC8->AC8_CODCON := oContato:cCODCONT

			MsUnlock()

		End If

	Next nX

	RestArea( aArea )

Return