#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOSU5BLD
//Retorno uma instância de objeto da classe IOSU5CLS
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@return return, Instância de objeto da classe IOSU5CLS
/*/
User Function IOSU5BLD()

	Local oObject := IOSU5CLS():New()

Return oObject

/*/{Protheus.doc} IOSU5CLS
//Classe que representa o cadastro do contato e seus meios de comunicação a serem incluidos/atualizados na base
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
/*/
Class IOSU5CLS

	Data cCODCONT
	Data cCONTAT
	Data cXCOTCOM
	Data cXFATPUB
	Data cXFINANC
	Data cXNF_E
	Data cXSRVGRF
	Data cXPUBLIC
	Data cXBOLELE

	// Atributos da classe que não tem campo correspondente no dicionário
	Data lErroAuto
	Data cErroMsg
	Data aMeioComun

	Method New() Constructor
	Method Grava()

End Class

/*/{Protheus.doc} New
//Método Contrutor da Classe Contato
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
@return return, Instância de objeto da classe IOSU5CLS
/*/
Method New() Class IOSU5CLS

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

Return Self

/*/{Protheus.doc} Grava
//Grava o objeto no banco via execauto
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
/*/
Method Grava() Class IOSU5CLS

	Local aAtributos := {}
	Local aBuffer    := {}
	Local aContato   := {}
	Local aMeioComun := {}
	Local oContato   := Nil
	Local cCampo     := ''
	Local cOrdem     := ''
	Local aErro      := {}
	Local xValor     := Nil
	Local nX         := 0

	Private	lMsErroAuto    := .F.
	Private	lMsHelpAuto    := .T.
	Private	lAutoErrNoFile := .T.

	aAtributos := ClassDataArr( Self, .F. )

	For nX := 1 To Len( aAtributos )

		If ! Upper( aAtributos[ nX, 1 ] ) $ Upper( 'lErroAuto/cErroMsg/aMeioComun' )

			cCampo := 'U5_' + SubStr( aAtributos[ nX, 1 ], 2, 7 )
			xValor := aAtributos[ nX, 2 ]

			If ValType( cOrdem := GetSx3Cache( cCampo, 'X3_ORDEM' ) ) # 'U' .And. ! Empty( xValor );
			.And. ValType( xValor ) # 'U'

				aAdd( aBuffer, { cCampo, xValor, cOrdem } )

			End If

		End If

	Next nX

	aContato := aSort( aBuffer,,, { | X, Y |  X[ 3 ] < Y[ 3 ] } )

	For nX := 1 To Len( aContato )

		aContato[ nX, 3 ] := Nil

	Next nX

	For nX := 1 To Len( Self:aMeioComun )

		oContato := Self:aMeioComun[ nX ]

		aAdd( aMeioComun, oContato:GetArrExec() )

	Next nX

	MSExecAuto( { | X , Y, Z, A, B | TMKA070( X , Y, Z, A, B ) }, aContato, 3, {}, aMeioComun, .F. )

	If Self:lErroAuto := lMsErroAuto

		aErro := aClone( GetAutoGRLog() )

		For nX := 1 To Len( aErro )

			Self:cErroMsg += aErro[ nX ] + Chr(13) + Chr(10)

		Next nX

	End If

Return
