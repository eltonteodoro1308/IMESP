#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} SGPEC002
//User Function a ser utilizada pela web para exibir
a foto dos funcionários conforme requisitado pelo código,
se o código não for passado por parâmetro todas as fotos são exibidas.
@author Elton Teodoro Alves
@since 01/11/2016
@version Protheus 12.1.7
@param __aCookies, Array, Cookies criados na aplicação client HTTP
@param __aPostParms, Array, campos contidos em um formulário HTML recebido através de um comando POST
@param __nProcID, Numerico, Handle da Thread de execução
@param __aProcParms, Aray, parâmetros enviados na linha de URL do Web Browser
@param __cHTTPPage, Caracter, Compatibilidade
@return cHtml, characters
/*/
User Function SGPEC002( __aCookies, __aPostParms, __nProcID, __aProcParms, __cHTTPPage )

	Local cHTML       := ''

	If Len( __aProcParms ) == 0

		AEval( Directory( '\web\ws\fotos\*.*' ), { |X| cHtml += '<img src="fotos\' + X[1] + '"/><br/><p>' + X[1] + '</p><hr/>' } )

	Else

		cHTML += '<img src="fotos\' + __aProcParms[1,2] + '"/>'

	EndIf

Return cHTML