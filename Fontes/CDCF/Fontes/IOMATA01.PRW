#INCLUDE 'TOTVS.CH'

user function IOMATA01( cXml, cError, cWarning, cParams, oFwEai )



return
/*/{Protheus.doc} GetVal
Retorna o valor da Tag descendente solicitada correspondenente a Tag posicionada.
@author Elton Teodoro Alves
@since 07/02/2017
@version 12.1.014
@param cTag, characters, Nome da Tag
@return characters, Valor da Tag
/*/
Static Function GetVal( cTag )

	cRet := oXml:DOMGetChildArray() [ aScan( oXml:DOMGetChildArray(), { | X | X[1] = cTag } ) ] [2]

Return cRet

/*/{Protheus.doc} RegLogCDCF
Registra o Log da Requisição de integração com o CDCF
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@param cStatus, characters, Status do Processamento
@param cObserv, characters, Observacao  Processamento
@return logical, Retorna se o Registro do Log Ocorreu com sucesso.
/*/
Static Function RegLogCDCF( cStatus, cObserv )

	Local lRet   := .T.
	Local oModel := FwLoadModel( 'IOMATA02' )

	oModel:SetOperation( MODEL_OPERATION_INSERT )

	oModel:Activate()

	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_UUID'  , cUUID     )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_DATARE', dDataRec  )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_HORARE', cHoraRec  )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_METODO', cMetodo   )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_STATUS', cStatus   )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_XMLREC', cXmlRec   )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_XMLPRC', cResponse )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_JSON'  , cJson     )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_OBSERV', cObserv   )

	If lRet := oModel:VldData()

		oModel:CommitData()

	Else

		VarInfo( 'oModel:GetErrorMessage()', oModel:GetErrorMessage(),, .F., .T. )

	End If

	oModel:DeActivate()

Return lRet