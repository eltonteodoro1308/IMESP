#INCLUDE 'TOTVS.CH'

User Function SGPEC001( cXml )

	//Local cXml := '<SGPEC001 Operation="1" version="1.000"><FIELD name="RA_MAT">000001</FIELD></SGPEC001>'
	Local cRet      := ''
	Local oModel    := FWLoadModel( 'SGPEC001' )
	Local aArea     := GetArea()
	Local oXml      := TXmlManager():New()
	Local nResult   := oXml:Parse( cXML )
	Local cFldName  := AllTrim( oXML:XPathGetAtt( "/SGPEC001/FIELD", "name" ) )
	Local cFldValue := AllTrim( PadR( oXML:XPathGetNodeValue( "/SGPEC001/FIELD" ), TAMSX3( cFldName )[ 1 ] ) )
	Local lEmpty    := .T. // Indica se gera xml com campos nao obrigatorios vaziosadmin
	Local aFields   := { 'RA_MAT', 'RA_NOME'}
	Local aOrder    := { 1, 3 }
	Local nOrder    := aOrder [ aScan( aFields, cFldName ) ]

	DbSelectArea( 'SRA' )
	DbSetOrder( nOrder )
	If DbSeek( xFilial( 'SRA' ) + cFldValue )

		cRet := '<?xml version="1.0" encoding="UTF-8"?>'

		Do While ! EOF() .Or. SRA->RA_FILIAL + SRA->&cFldName == xFilial( 'SRA' ) + cFldValue 

			oModel:Activate()

			cRet += StrTran( oModel:GetXMLData(,,,,,lEmpty), '<?xml version="1.0" encoding="UTF-8"?>', '' )

			oModel:DeActivate()
			
			DbSkip()

		End Do

	End If

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