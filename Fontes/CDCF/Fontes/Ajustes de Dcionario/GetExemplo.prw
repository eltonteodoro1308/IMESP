User Function GetExemplo( cXml )

	Local cRet := ''
	Local nHandle := FT_FUse( '\xml\exemplo.xml' )

	If nHandle = -1

		return cRet

	End If

	FT_FGoTop()

	While ! FT_FEOF()

		cRet += FT_FReadLn()

		FT_FSKIP()

	End

	FT_FUSE()
	
	cXml := cRet

Return cRet