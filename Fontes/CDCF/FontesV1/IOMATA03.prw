#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} MenuDef
Função de Retorno do Menu do Browse da Rotina
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@return Array, Array com as Rotinas do menu do Browse
/*/
Static Function MenuDef()

	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar'    , 'VIEWDEF.IOMATA03', 0, 2, 0, Nil } )
	aAdd( aRotina, { 'Array ExecAuto', 'U_IOMT03EX()' , 0, 6, 0, Nil } )

Return aRotina

/*/{Protheus.doc} ModelDef
Função de Retorno Modelo de dados da Tabela ZX2.
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@return Object, Modelo de dados da Tabela ZX2
/*/
Static Function ModelDef()

	Local oModel  := MPFormModel():New( 'ZX2_MODEL' )
	Local oStrZX2 := FWFormStruct( 1, 'ZX2' )
	Local oStrZX3 := FWFormStruct( 1, 'ZX3' )

	oModel:SetDescription( 'LOG DE INTEGRAÇÃO CDCF Cliente' )

	oModel:addFields( 'ZX2_FIELD_MODEL', , oStrZX2 )
	oModel:AddGrid  ( 'ZX3_GRID_MODEL', 'ZX2_FIELD_MODEL', oStrZX3 )

	oModel:GetModel( 'ZX3_GRID_MODEL' ):SetOptional( .T. )

	oModel:SetRelation( 'ZX3_GRID_MODEL', { { 'ZX3_FILIAL', 'ZX2_FILIAL' }, { 'ZX3_CODIGO', 'ZX2_CODIGO' },;
	{ 'ZX3_ITEMCL', 'ZX2_ITEM' } }, ZX3->(IndexKey(1)) )

Return oModel

/*/{Protheus.doc} ViewDef
Função de Retorno da View do Modelo de dados da Tabela ZX2.
@author elton.alves
@since 08/02/2017
@version undefined
@return Object, View do Modelo de dados da Tabela ZX2
/*/
Static Function ViewDef()

	Local oView   := FWFormView():New()
	Local oModel  := ModelDef()
	Local oStrZX2 := FWFormStruct( 2, 'ZX2' )
	Local oStrZX3 := FWFormStruct( 2, 'ZX3' )

	oView:SetModel( oModel )

	oView:CreateFolder( 'PASTAS' )

	oView:AddSheet( 'PASTAS', 'ABA01', 'Cliente' )
	oView:AddSheet( 'PASTAS', 'ABA02', 'Contatos' )

	oView:AddField( 'ZX2_FIELD_VIEW', oStrZX2, 'ZX2_FIELD_MODEL' )
	oView:CreateHorizontalBox( 'BOX_ZX2_FIELD_VIEW', 100,,, 'PASTAS', 'ABA01')
	oView:SetOwnerView( 'ZX2_FIELD_VIEW', 'BOX_ZX2_FIELD_VIEW' )

	oView:AddGrid( 'ZX3_GRID_VIEW', oStrZX3, 'ZX3_GRID_MODEL' )
	oView:CreateHorizontalBox( 'BOX_ZX3_GRID_VIEW', 100,,, 'PASTAS', 'ABA02')
	oView:SetOwnerView( 'ZX3_GRID_VIEW', 'BOX_ZX3_GRID_VIEW' )

	oView:SetViewProperty( 'ZX3_GRID_VIEW', "ENABLEDGRIDDETAIL", { 60 } )

Return oView

/*/{Protheus.doc} IOMT03EX
Funcao informada no aRotina do Browse, que Exibe o Array do ExecAuto.
@author Elton Teodoro Alves
@since 09/02/2017
@version 12.1.014
/*/
User Function IOMT03EX()

	Local cFile    := GetTempPath( .T. ) + GetNextAlias()
	Local aArrExec := {}

	If! Empty( ZX2->ZX2_ARREXE )

		cFile += '.html'

		FWJsonDeserialize( ZX2->ZX2_ARREXE, @aArrExec )

		MemoWrite( cFile, VarInfo( 'ZX2_ARREXE', aArrExec,, .T., .F. ) )

	Else

		ApMsgInfo( 'Informação não Disponível', 'Atenção !!!' )

		Return

	End If

	ShellExecute( 'Open', '%PROGRAMFILES%\Internet Explorer\iexplore.exe', cFile, 'C:\', 1 )

Return