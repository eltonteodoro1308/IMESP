#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'


static function ExecAuto( aCpos )
	
	Local lRet := .F.
	Local nX   := 0
	
	
	
	
Return lRet

Static Function ModelDef()
	
	Local oModel := MPFormModel():New('MIOMT922')	
	Local oStr   := FWFormStruct( 1, 'AHH' )
	
	oModel:SetDescription('Especies de Publicacoes')
	oModel:addFields('AHH_FIELD',,oStr)
	oModel:getModel('AHH_FIELD'):SetDescription('Especies de Publicacoes')
	oModel:SetPrimaryKey( { 'AHH_FILIAL', 'AHH_CODPUB' } )
	
Return oModel
