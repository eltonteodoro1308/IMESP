#INCLUDE 'TOTVS.CH'

User Function EAIDIVISAO( cXML )

Local oXml       := TXmlManager():New()
Local nDividendo := 0
Local nDivisor   := 0
Local nQuociente := 0
Local nResto     := 0
Local cRet       := '<?xml version="1.0" encoding="UTF-8"?>'

ConOut( cXml )

oXml:Parse( cXML )

nDividendo := Val( AllTrim( oXML:XPathGetNodeValue( "/DIVISAO_REM/DIVIDENDO" ) ) )
nDivisor   := Val( AllTrim( oXML:XPathGetNodeValue( "/DIVISAO_REM/DIVISOR"   ) ) )

cRet += '<DIVISAO_RET>'

If nDivisor # 0
	
	nQuociente := Int( nDividendo / nDivisor )
	nResto     := Mod( nDividendo, nDivisor  )
	
	cRet += '<QUOCIENTE>' + cValTochar( nQuociente ) + '</QUOCIENTE>'
	cRet += '<RESTO>'     + cValTochar( nResto     ) + '</RESTO>'
	cRet += '<ERRO></ERRO>'
	
Else
	
	cRet += '<QUOCIENTE></QUOCIENTE>'
	cRet += '<RESTO></RESTO>'
	cRet += '<ERRO>Nao Permitida Divisao por Zero.</ERRO>'
	
End IF

cRet += '</DIVISAO_RET>'

Return cRet
