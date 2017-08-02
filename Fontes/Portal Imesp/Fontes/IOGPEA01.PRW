#Include 'TOTVS.CH'
#Include 'FWMVCDef.ch'

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
	oModel := MPFormModel():New('Complemento Para o Portal')
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

		//PROTHEUS_REPOSIT->( aAreaRep )

	End If

Return EnCode64( cRet )