#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

Static Function ModelDef()

	Local oModel

	Local oStr1 := FWFormStruct(1,'AHG')
	oModel := MPFormModel():New('MIOMT921')
	oModel:SetDescription('Cadastro de Publicações')
	oModel:addFields('AHG_FIELD',,oStr1)
	oModel:getModel('AHG_FIELD'):SetDescription('Cadastro de Publicações')
	oModel:SetPrimaryKey( { 'AHG_FILIAL', 'AHG_CODPUB' } )

Return oModel