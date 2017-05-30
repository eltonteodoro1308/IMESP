#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function MT610OK()

	Local oModel   := Nil
	Local lInclui  := INCLUI
	Local cTipo    := M->H1_XTIPO
	Local cNomeMod := ''

	If cValToChar( PARAMIXB[1] ) $ '34'

		oModel  := FwLoadModel( If( cTipo == '1', 'MT610MAQ', 'MT610OPER' ) )

		cNomeMod := If( cTipo == '1', 'MAQUINA', 'OPERADOR' )

		oModel:SetOperation( 3 )

		oModel:Activate()

		oModel:LoadValue( cNomeMod, 'ID'   , M->H1_CODIGO  )
		oModel:LoadValue( cNomeMod, 'NOME' , M->H1_DESCRI )
		oModel:LoadValue( cNomeMod, 'ATIVO', If( M->H1_MSBLQL = '1', 'F', 'T' ) )

		If cTipo == '1'

			oModel:LoadValue( cNomeMod, 'CUSTOHORA'          , AllTrim( Str( M->H1_XCTOHR ) ) )
			oModel:LoadValue( cNomeMod, 'MEDIAPRODUTIVIDADE' , AllTrim( Str( M->H1_XMDPRD ) ) )

		End If

		If oModel:VldData()

			oModel:CommitData()

		Else

			VarInfo('oModel:GetErrorMessage()',oModel:GetErrorMessage(),,.F.,.T.)

		End If

		oModel:DeActivate()

		INCLUI := lInclui

	End If

Return .T.