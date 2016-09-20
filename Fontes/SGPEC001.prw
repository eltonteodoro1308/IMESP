#INCLUDE 'TOTVS.CH'

User Function SGPEC001( cXml )

	Local cRet    := ''
	Local oModel  := FWLoadModel( 'SGPEC001' )
	Local aArea   := GetArea()
	Local oXml    := TXmlManager():New()
	Local nResult := oXml:Parse( cXML )
	Local cRAMat  := PadR( oXML:XPathGetNodeValue( "/SGPEC001/SGPEC001_SRA/RA_MAT/value" ), TAMSX3( 'RA_MAT' )[ 1 ] )
	Local lEmpty  := .T. // Indica se gera xml com campos nao obrigatorios vazios

	DbSelectArea( 'SRA' )
	DbSetOrder( 1 )
	DbSeek( xFilial( 'SRA' ) + cRAMat )

	oModel:Activate()

	cRet := oModel:GetXMLData(,,,,,lEmpty)

	oModel:DeActivate()

	RestArea( aArea )

Return cRet

//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------

Static Function ModelDef()

	Local oModel  := MpFormModel():New( 'SGPEM001' )
	Local oStruct := Nil
	Local aFields := {}

	aAdd( aFields, 'RA_MAT'     )
	aAdd( aFields, 'RA_NOME'    )
	aAdd( aFields, 'RA_NOMECMP' )
	aAdd( aFields, 'RA_APELIDO' )
	aAdd( aFields, 'RA_CARGO'   )
	aAdd( aFields, 'M0_NOME'    )
	aAdd( aFields, 'RA_XRAMAL'  )
	aAdd( aFields, 'RA_XRAMAL2' )
	aAdd( aFields, 'RA_XRAMAL3' )
	aAdd( aFields, 'RA_DEPTO'   )
	aAdd( aFields, 'RA_XNCARGO' )
	aAdd( aFields, 'RA_NASC'    )
	aAdd( aFields, 'RA_FILIAL'  )
	aAdd( aFields, 'RA_SITFOLH' )
	aAdd( aFields, 'RA_EMAIL'   )
	aAdd( aFields, 'RA_CIC'     )
	aAdd( aFields, 'RA_FILIAL'  )
	aAdd( aFields, 'RA_XSIGLA'  )
	aAdd( aFields, 'RA_XLOGIN'  )
	aAdd( aFields, 'RA_XRAMAL'  )
	aAdd( aFields, 'RA_XRAMAL2' )
	aAdd( aFields, 'RA_XRAMAL3' )
	aAdd( aFields, 'RA_SIGLA'   )
	aAdd( aFields, 'RA_XLOGIN'  )

	oStruct := FWFormStruct( 1, 'SRA', { | X | aScan( aFields, AllTrim( X ) ) # 0 } )

	oModel:AddFields( 'SGPEC001_SRA', , oStruct )
	oModel:SetDescription( 'Cadastro de Funcionarios' )
	oModel:GetModel( 'SGPEC001_SRA' ):SetDescription( 'Cadastro de Funcionarios' ) 

Return oModel