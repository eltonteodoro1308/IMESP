#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOCDCF
//Executa a busca do xml com os dados dos clientes a serem incluidos e atualizados no CDCF
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
@param cXml, characters, O conte�do da tag Content do XML recebido pelo EAI Protheus.
@param cError, characters, Vari�vel passada por refer�ncia, serve para alimentar a mensagem de erro, nos casos em que a transa��o n�o foi bem sucedida.
@param cWarning, characters, Vari�vel passada por refer�ncia, serve para alimentar uma mensagem de warning para o EAI.
@param cParams, characters,  Par�metros passados na mensagem do EAI.
@param oFwEai, object, O objeto de EAI criado na camada do EAI Protheus.
@return characters, Retorno com resultado da opera��o.
/*/
User Function IOCDCF( cXml, cError, cWarning, cParams, oFwEai )

	oFwEai:cReturnMsg := 'Executado as ' + Time()

Return oFwEai:cReturnMsg