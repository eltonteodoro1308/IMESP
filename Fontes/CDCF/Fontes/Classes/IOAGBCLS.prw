#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOAGBBLD
//Retorno uma instância de objeto da classe IOAGBCLS
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@return return, Instância de objeto da classe IOAGBCLS
/*/
User Function IOAGBBLD()

	Local oObject := IOAGBCLS():New()

Return oObject

/*/{Protheus.doc} IOAGBCLS
//Classe que representa o cadastro do Meio de Comunicação
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
/*/
Class IOAGBCLS

	Data cCODIGO
	Data cXTIPO
	Data cXEMAIL
	Data cDDI
	Data cDDD
	Data cTELEFO
	Data cCOMP

	Method New() Constructor
	Method GetArrExec()

End Class

/*/{Protheus.doc} New
//Método Contrutor da Classe Meio de Comunicação
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
@return return, Instância de objeto da classe IOAGBCLS
/*/
Method New() Class IOAGBCLS

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

/*/{Protheus.doc} GetArrExec
//Retorna
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
/*/
Method GetArrExec() Class IOAGBCLS

	Local aAtributos := {}
	Local aBuffer    := {}
	Local aMeioComun   := {}
	Local cCampo     := ''
	Local cOrdem     := ''
	Local xValor     := Nil
	Local nX         := 0

	aAtributos := ClassDataArr( Self, .F. )

	For nX := 1 To Len( aAtributos )

		cCampo := 'AGB_' + SubStr( aAtributos[ nX, 1 ], 2, 7 )
		xValor := aAtributos[ nX, 2 ]

		If ValType( cOrdem := GetSx3Cache( cCampo, 'X3_ORDEM' ) ) # 'U' .And. ! Empty( xValor );
		.And. ValType( xValor ) # 'U'

			aAdd( aBuffer, { cCampo, xValor, cOrdem } )

		End If

	Next nX

	aMeioComun := aSort( aBuffer,,, { | X, Y |  X[ 3 ] < Y[ 3 ] } )

	For nX := 1 To Len( aMeioComun )

		aMeioComun[ nX, 3 ] := Nil

	Next nX

Return aMeioComun