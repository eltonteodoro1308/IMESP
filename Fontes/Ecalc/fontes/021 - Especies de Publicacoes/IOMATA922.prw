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


Local oStr1:= FWFormStruct(1,'AHH')
oModel := MPFormModel():New('AHH_MODEL')
oModel:SetDescription('AHH_MODEL')
oModel:addFields('AHH_FIELD_MASTER',,oStr1)
oModel:getModel('AHH_FIELD_MASTER'):SetDescription('AHH_FIELD_MASTER')



Return oModel