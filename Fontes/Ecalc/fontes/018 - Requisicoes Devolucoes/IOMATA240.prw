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

Local oStr1:= FWFormStruct(1,'SD3')
oModel := MPFormModel():New('SD3_MODEL')
oModel:SetDescription('SD3_MODEL')
oModel:addFields('SD3_FIELD_MASTER',,oStr1)
oModel:getModel('SD3_FIELD_MASTER'):SetDescription('SD3_FIELD_MASTER')

Return oModel