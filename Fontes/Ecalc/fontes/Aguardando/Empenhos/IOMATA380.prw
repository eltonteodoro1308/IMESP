#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

user function MATA380()

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
	Local oStr1:= FWFormStruct(1,'SD4')

	oModel := MPFormModel():New('SD4_MODEL')
	oModel:SetDescription('Empenhos')
	oModel:addFields('SD4_FIELDS_MASTER',,oStr1)

Return oModel