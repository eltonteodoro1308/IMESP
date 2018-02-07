#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} MA030ROT
//Ponto de Entrada que inclui no aRotina do menu do cadastro de cliente
uma tela de consulta aos contatos do cliente
@author Elton Teodoro Alves
@since 24/08/2017
@version 12.1.016
@return Array, Array com dados da Rotina a ser incluída no menu
/*/
User Function MA030ROT()

Return { 'Contatos CDCF', 'U_IOCTCDCF', 0, 4, 0, NIL }

/*/{Protheus.doc} IOCTCDCF
//Função que exibe tela de consulta dos contatos do cliente
@author Elton Teodoro Alves
@since 24/08/2017
@version 12.1.016
/*/
User Function IOCTCDCF()

Return