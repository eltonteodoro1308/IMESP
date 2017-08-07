#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOSU5BLD
//Retorno uma instância de objeto da classe IOSU5CLS
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@return return, Instância de objeto da classe IOSU5CLS
/*/
User Function IOSU5BLD()

	Local oObject := IOSA1CLS():New()

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

	Data aMeioComun

	Method New() Constructor

End Class

/*/{Protheus.doc} New
//Método Contrutor da Classe Contato
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
/*/
Method New() Class IOSU5CLS
Return Self
