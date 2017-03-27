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

Local oStr1:= FWFormStruct(1,'Z01')
oModel := MPFormModel():New('Z01_MODEL')
oModel:SetDescription('Z01_MODEL')
oModel:addFields('Z01_FIELD_MODEL',,oStr1)
oModel:getModel('Z01_FIELD_MODEL'):SetDescription('Z01_FIELD_MODEL')

Return oModel