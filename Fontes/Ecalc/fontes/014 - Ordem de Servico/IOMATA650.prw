#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

user function MATA650()

return
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author elton.alves

@since 27/03/2017
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'SC2')

	oModel := MPFormModel():New('SC2_MODEL')
	oModel:SetDescription('Ordem de Produção')
	oModel:addFields('SC2_FIELDS_MASTER',,oStr1)
	oModel:getModel('SC2_FIELDS_MASTER'):SetDescription('SubModel Tabela SC2')

Return oModel