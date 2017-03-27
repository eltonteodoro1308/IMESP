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


Local oStr1:= FWFormStruct(1,'AHG')
oModel := MPFormModel():New('AHG_MODEL')
oModel:SetDescription('AHG_MODEL')
oModel:addFields('AHG_FIELD_MASTER',,oStr1)
oModel:getModel('AHG_FIELD_MASTER'):SetDescription('AHG_FIELD_MASTER')



Return oModel