#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


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


Local oStr1:= FWFormStruct(1,'AHI')
oModel := MPFormModel():New('AHI_MODEL')
oModel:SetDescription('AHI_MODEL')
oModel:addFields('AHI_FIELD_MODEL',,oStr1)
oModel:getModel('AHI_FIELD_MODEL'):SetDescription('AHI_FIELD_MODEL')



Return oModel