#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOAGBCLS
//Classe que representa o cadastro do Meio de Comunica��o
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

End Class

/*/{Protheus.doc} New
//M�todo Contrutor da Classe Meio de Comunica��o
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
/*/
Method New() Class IOSU5CLS

Return Self