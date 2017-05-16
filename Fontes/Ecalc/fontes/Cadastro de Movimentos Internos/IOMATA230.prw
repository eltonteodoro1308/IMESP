#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MATA230()

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


Local oStr1:= FWFormStruct(1,'SF5')
oModel := MPFormModel():New('SF5_MODEL')
oModel:SetDescription('Model do Cadastro de Movimentação de Estoque')
oModel:addFields('SF5_FIELD_MASTER',,oStr1)
oModel:getModel('SF5_FIELD_MASTER'):SetDescription('SubModel da Tabela SF5')



Return oModel