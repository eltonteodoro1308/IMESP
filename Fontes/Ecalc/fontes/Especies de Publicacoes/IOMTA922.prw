#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

Static Function ModelDef()

	Local oModel

	Local oStr1:= FWFormStruct(1,'AHH')
	oModel := MPFormModel():New('MIOMTA922')
	oModel:SetDescription('Especies de Publica��es')
	oModel:addFields('AHH_FIELD',,oStr1)
	oModel:getModel('AHH_FIELD'):SetDescription('Especies de Publica��es')
	oModel:SetPrimaryKey( { 'AHH_FILIAL', 'AHH_CODPUB' } )

Return oModel