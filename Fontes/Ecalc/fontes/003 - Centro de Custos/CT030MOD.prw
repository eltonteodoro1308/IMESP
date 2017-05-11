#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author elton.alves

@since 10/05/2017
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel


Local oStr1:= mldoStr1Str()
oModel := MPFormModel():New('MCT030MOD')
oModel:addFields('CENTRODECUSTO',,oStr1)
oModel:SetPrimaryKey({ 'ID' })


oModel:SetDescription('Model CTT eCalc')
oModel:getModel('CENTRODECUSTO'):SetDescription('CENTRO DE CUSTO')
oModel:GetModel( 'CENTRODECUSTO' ):SetOnlyQuery ( .T. )


Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} mldoStr1Str()
Retorna estrutura do tipo FWformModelStruct.

@author elton.alves

@since 10/05/2017
@version 1.0
/*/
//-------------------------------------------------------------------

static function mldoStr1Str()

Local oStruct := FWFormModelStruct():New()
oStruct:AddTable('CTT_ECALC',,'CTT ECALC')
oStruct:AddField('ID','ID' , 'ID', 'C', 9, 0, , , {}, .F., , .F., .F., .F., , )
oStruct:AddField('NOME','NOME', 'NOME', 'C', 40, 0, , , {}, .F., , .F., .F., .F., , )
oStruct:AddField('ATIVO','ATIVO', 'ATIVO', 'C', 1, 0, , , {}, .F., , .F., .F., .F., , )

return oStruct
