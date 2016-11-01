#include 'totvs.ch'

User Function SGPEC002(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)

	Local cHTML       := ''

	If Len( __aProcParms ) == 0

		AEval( Directory( '\web\ws\fotos\*.*' ), { |X| cHtml += '<img src="fotos/' + X[1] + '"/><br/><p>' + X[1] + '</p><hr/>' } )

	Else

		cHTML += '<img src="fotos/' + __aProcParms[1,2] + '"/>'

	EndIf

Return cHTML