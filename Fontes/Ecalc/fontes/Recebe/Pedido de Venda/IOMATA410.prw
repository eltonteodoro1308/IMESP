#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MATA410()

Return



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

Local oStr1:= FWFormStruct(1,'SC5')
Local oStr2:= FWFormStruct(1,'SC6')

oModel := MPFormModel():New('MATA410_MODEL')
oModel:SetDescription('MATA410_MODEL')
oModel:addFields('SC5_FIELD_MASTER',,oStr1)
oModel:addGrid('SC6_GRID_MASTER','SC5_FIELD_MASTER',oStr2)

oModel:SetRelation('SC6_GRID_MASTER', { { 'C6_FILIAL', 'C5_FILIAL' }, { 'C6_NUM', 'C5_NUM' } }, SC6->(IndexKey(1)) )

oModel:getModel('SC5_FIELD_MASTER'):SetDescription('SC5_FIELD_MASTER')
oModel:getModel('SC6_GRID_MASTER'):SetDescription('SC6_GRID_MASTER')

Return oModel
