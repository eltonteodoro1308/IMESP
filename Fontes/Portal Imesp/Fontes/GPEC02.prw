#INCLUDE 'TOTVS.CH'

user function GPEC02()

	Local cRet  := ''
	Local cImg  := ''
	Local cErro := ''
	Local cXml  := ''
	Local oXml  := TXmlManager():New()

	RpcSetEnv( '99', '01' )

	oXml:Parse( cXml := U_IOGPEC02( ,,, HttpGet->cFunc + ',' + HttpGet->cTam, ) )

	cImg  := AllTrim( oXml:XPathGetNodeValue( '/IOGPEC02_RET/IMAGE' ) )
	cErro := AllTrim( oXml:XPathGetNodeValue( '/IOGPEC02_RET/ERROR' ) )

	cRet += '<html>'
	cRet += '<head>'
	cRet += '<title></title>'
	cRet += '</head>'
	cRet += '<body>'
	cRet += '<img src="data:image/jpg;base64,' + cImg + '"/>'
	cRet += '<p>' + 'cErro' + '</p>'
	cRet += '</body>'
	cRet += '</html>'

	RpcClearEnv()

return cRet