#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOAGBBLD
//Retorno uma inst�ncia de objeto da classe IOAGBCLS
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@return return, Inst�ncia de objeto da classe IOAGBCLS
/*/
User Function IOAGBBLD()

	Local oObject := IOSA1CLS():New()

Return oObject

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
Method New() Class IOAGBCLS
Return Self