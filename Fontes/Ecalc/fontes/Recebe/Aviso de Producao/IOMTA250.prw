#Include 'TOTVS.CH'
#Include 'FWMVCDef.ch'

Static Function ModelDef()

	Local oModel


	Local oStr1:= FWFormStruct( 1, 'SD3')

	oModel := MPFormModel():New('MIOMT250')
	oModel:SetDescription('Aviso de Produ��o')
	oModel:addFields('SD3_FIELD',,oStr1)
	oModel:getModel('SD3_FIELD'):SetDescription('Aviso de Produ��o')

Return oModel