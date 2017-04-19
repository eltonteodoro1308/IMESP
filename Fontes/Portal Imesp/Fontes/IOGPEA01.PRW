#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWADAPTEREAI.CH'

/*/{Protheus.doc} IOGPEA01
//Cadastro de Dados Complementares de Funcionários para o Portal
@author Elton Teodoro Alves
@since 05/04/2017
@version 12.1.014
/*/
User Function IOGPEA01()

	Local oBrowse := FwMBrowse():New()

	oBrowse:SetAlias('SZ0')
	oBrowse:SetDescription('Complemento Para o Portal')
	oBrowse:Activate()

Return

/*/{Protheus.doc} MenuDef
//Menu de Rotinas do Browse
@author Elton Teodoro Alves
@since 05/04/2017
@version 12.1.014
/*/
Static Function MenuDef()

Return FWMVCMenu( 'IOGPEA01' )

/*/{Protheus.doc} ModelDef
//Modele de dados da Tabela SZ0
@author Elton Teodoro Alves
@since 05/04/2017
@version 12.1.014
/*/
Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'SZ0')
	oModel := MPFormModel():New( 'MIOGPEA1' )
	oModel:SetDescription('Imagens de Portal')
	oModel:addFields('SZ0_FIELD',,oStr1)
	oModel:getModel('SZ0_FIELD'):SetDescription('Complemento Para o Portal')

Return oModel

/*/{Protheus.doc} ViewDef
//View do Modelo de Dados
@author Elton Teodoro Alves
@since 05/04/2017
@version 12.1.014
/*/
Static Function ViewDef()

	Local oView
	Local oModel := ModelDef()

	Local oStr1:= FWFormStruct(2, 'SZ0')
	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'SZ0_FIELD' )
	oView:CreateHorizontalBox( 'BOXFORM1', 100)
	oView:SetOwnerView('FORM1','BOXFORM1')

Return oView

/*/{Protheus.doc} IntegDef
//Função que efetua o envio da mensagem única do registro incluido, alterado e excluido.
@author elton.alves
@since 18/04/2017
@version undefined
@param cXml, characters, XML recebido pelo EAI Protheus
@param cTypeTran, characters, Tipo de transação
@param cTypeMsg, characters, Tipo da mensagem do EAI
@param cVersion, characters, Versão da Mensagem Única TOTVS
@return Array,  O retorno desta rotina será sempre um array, de três posições, sendo estas:
@obs
[1] – Deve retornar uma variável lógica, indicando se o processamento foi executado com sucesso (.T.) ou não (.F.);
[2] – Uma string contendo informações sobre o processamento;
[3] – Uma string com o nome da mensagem única desta mensagem.
/*/
Static Function IntegDef( cXml, cTypeTran, cTypeMsg, cVersion )

	Local lRet    := .T.
	Local cXmlRet := ''
	Local oModel  := Nil
	Local cCode   := ''
	Local cId     := ''


	If cTypeTran == TRANS_SEND

		oModel      := FwModelActive()
		cCode       := oModel:GetValue( 'SZ0_FIELD', 'Z0_CODIGO' )
		cId         := cEmpAnt + xFilial('SZ0') + cCode

		cXMLRet := '<BusinessEvent>'
		cXMLRet +=     '<Entity>MYMESSAGE</Entity>'
		cXMLRet +=     '<Event>'

		If oModel:GetOperation() <> MODEL_OPERATION_DELETE

			cXmlRet += 'UPSERT'

		Else

			cXmlRet += 'DELETE'

		Endif

		cXmlRet += 	  '</Event>'
		cXMLRet +=      '<Identification>'
		cXMLRet +=         '<Key name="InternalId">' + cId + '</Key>'
		cXMLRet +=     '</Identification>'
		cXMLRet += '</BusinessEvent>'
		cXMLRet += '<BusinessContent>'
		cXMLRet +=    '<Code>' + cCode + '</Code>'
		cXMLRet += '</BusinessContent>'

	End If

Return { lRet, cXmlRet, "IOGPEA01" }

/*/{Protheus.doc} IOGPEB64
//Resgata uma imagem do repositório e a converte para Base64,
utilizado nos gatilhos dos campos Z0_BASE641 e Z0_BASE642
@author elton.alves
@since 12/04/2017
@version undefined
@param cImg, characters, descricao
@return return, return_description
/*/
User Function IOGPEB64( cBitMap )

	Local cRet     := ''
	Local aArea    := GetArea()
	//Local aAreaRep := PROTHEUS_REPOSIT->( GetArea() )

	cBitMap := AllTrim( cBitMap )

	If ! Empty( cBitMap )

		OpenRepositDB()

		DbSelectArea( 'PROTHEUS_REPOSIT' )
		DbSetOrder( 1 ) //BMPNAME

		If DbSeek( cBitMap )

			Do While ! Eof() .And. AllTrim( PROTHEUS_REPOSIT->BMPNAME ) == cBitMap

				cRet += PROTHEUS_REPOSIT->MEMO

				DbSkip()

			End Do

		End If

		RestArea( aArea )

		//PROTHEUS_REPOSIT->( DbCloseArea() )

	End If

Return EnCode64( cRet )