#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

Static Function ModelDef()

	Local oModel

	Local oStr1:= FWFormStruct(1,'AHI')
	oModel := MPFormModel():New('MIOMT923')
	oModel:SetDescription('Tipos de Pap�is')
	oModel:addFields('AHI_FIELD',,oStr1)
	oModel:getModel('AHI_FIELD'):SetDescription('Tipos de Pap�is')
	oModel:SetPrimaryKey( { 'AHI_FILIAL', 'AHI_CODPAP' } )

Return oModel