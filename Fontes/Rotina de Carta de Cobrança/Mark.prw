#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function Mark()

	Private oMark

	// Instanciamento do classe
	oMark := FWMarkBrowse():New()

	// Definição da tabela a ser utilizada
	oMark:SetAlias('SA2')

	// Define se utiliza controle de marcação exclusiva do oMark:SetSemaphore(.T.)
	// Define a titulo do browse de marcacao
	oMark:SetDescription('Fornecedores')

	// Define o campo que sera utilizado para a marcação
	oMark:SetFieldMark( 'A2_OK' )

	// Define a legenda
	//oMark:AddLegend( "ZA0_TIPO=='1'", "YELLOW", "Autor" )
	//oMark:AddLegend( "ZA0_TIPO=='2'", "BLUE" , "Interprete" )

	// Definição do filtro de aplicacao
	//oMark:SetFilterDefault( "Len(AllTrim(A2_COD)) == 6 " )

	oMark:SetAfterMark( {|| Alert('SetAfterMark') } )
	oMark:SetDoubleClick( {|| Alert('SetDoubleClick') } )
	oMark:SetValid( {|| Alert('SetValid'),.T.} )
	//oMark:SetCustomMarkRec( {|| Alert('SetCustomMarkRec')} )

	// Ativacao da classe
	oMark:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Processar' ACTION 'U_COMP25PROC()' OPERATION 2 ACCESS 0

Return aRotina

User Function COMP25PROC()

	Local aArea := GetArea()
	Local cMarca := oMark:Mark()
	Local nCt := 0

	SA2->( dbGoTop() )

	While !SA2->( EOF() )

		If oMark:IsMark(cMarca)

			nCt++

		EndIf

		SA2->( dbSkip() )

	End

	ApMsgInfo( 'Foram marcados ' + AllTrim( Str( nCt ) ) + ' registros.' )

	RestArea( aArea )

Return NIL