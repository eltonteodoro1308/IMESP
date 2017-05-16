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


Local oStr1:= FWFormStruct(1,'SH6')
oModel := MPFormModel():New('SH6_MODEL')
oModel:SetDescription('SH6_MODEL')
oModel:addFields('SH6_FIELD_MODEL',,oStr1)
oModel:getModel('SH6_FIELD_MODEL'):SetDescription('SH6_FIELD_MODEL')



Return oModel