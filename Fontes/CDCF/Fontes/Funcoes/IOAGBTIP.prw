/*/{Protheus.doc} IOAGBTIP
Retorna os opções da combox do Campo AGB_XTIPO
@author Elton Teodoro Alves
@since 15/08/2017
@version 12.1.014
@return Character, String com as opções
/*/
User Function IOAGBTIP()

	Local cRet := ''

	cRet += '1=Telefone Principal;'
	cRet += '2=Telefone Comercial;'
	cRet += '3=Telefone Fax;'
	cRet += '4=Telefone Celular;'
	cRet += '5=Telefone Residencial;'
	cRet += '6=Email;'
	cRet += '7=Telefone Comercial Adicional;'
	cRet += '8=Telefone Residencial Adicional;'
	cRet += '9=Email Adicional;'
	cRet += '10=Telefone Celular Adicional;'
	cRet += '11=Telefone Fax Adicional;'
	cRet += '12=Telefone Principal Adicional;'

Return cRet