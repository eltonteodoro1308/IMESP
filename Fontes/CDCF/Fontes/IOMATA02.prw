#INCLUDE 'TOTVS.CH'

User Function IOMATA02()

	Local cTimeStamp := FWTimeStamp( 4 )
	Local cTimeOld   := GetGlbValue( 'IOMATA02' )
	Local nTime      := Val(cTimeStamp) - Val(cTimeOld)

	If nTime >= 60

		ConOut( 'Executa !!! ' + cValToChar(nTime) + ' Segundos')
		PutGlbValue ( 'IOMATA02', cTimeStamp )

	Else

		ConOut( 'Não Executa !!! ' + cValToChar(nTime) + ' Segundos')

	End If

	ConOut( Replicate( '=', 200) )
	ConOut( Replicate( '=', 200) )

Return