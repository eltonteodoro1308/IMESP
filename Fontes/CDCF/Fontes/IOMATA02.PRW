#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#DEFINE cEnter Chr( 13 ) + Chr( 10 )

/*/{Protheus.doc} IOMATA02
Rotina de Controle de Log de Recebimento e Processamento de Rquisições do CDCF
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
/*/
User Function IOMATA02()

	Local oBrowse := FwMBrowse():New()

	oBrowse:SetAlias( 'ZX1' )
	oBrowse:SetDescription( 'LOG de Integração com CDCF' )

	oBrowse:AddLegend( 'ZX1_STATUS = "0"', 'GREEN' ,'Aguardando Importação'    )
	oBrowse:AddLegend( 'ZX1_STATUS = "1"', 'BLACK' ,'Erro Comunicação CDCF'    )
	oBrowse:AddLegend( 'ZX1_STATUS = "2"', 'RED'   ,'Erro Processamento XML'   )
	oBrowse:AddLegend( 'ZX1_STATUS = "3"', 'YELLOW','Falha durante Importacao' )
	oBrowse:AddLegend( 'ZX1_STATUS = "4"', 'WHITE' ,'Importado'                )

	oBrowse:Activate()

Return

/*/{Protheus.doc} MenuDef
Função de Retorno do Menu do Browse da Rotina
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@return Array, Array com as Rotinas do menu do Browse
/*/
Static Function MenuDef()

	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar'              , 'VIEWDEF.IOMATA02', 0, 2, 0, Nil } )
	aAdd( aRotina, { 'XML Requisição'          , 'U_IOMT02EX("1")'  , 0, 6, 0, Nil } )
	aAdd( aRotina, { 'XML CDCF'                , 'U_IOMT02EX("2")'  , 0, 6, 0, Nil } )
	aAdd( aRotina, { 'Array ExecAuto'          , 'U_IOMT02EX("3")'  , 0, 6, 0, Nil } )
	aAdd( aRotina, { 'Enviar p/ Fila Novamente', 'U_IOMT02EX("4")'  , 0, 6, 0, Nil } )

Return aRotina

/*/{Protheus.doc} function_method_class_name
Função de Retorno Modelo de dados da Tabela ZX1.
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@return Object, Modelo de dados da Tabela ZX1
/*/
Static Function ModelDef()

	Local oModel  := MPFormModel():New( 'ZX1_MODEL' )
	Local oStruct := FWFormStruct( 1, 'ZX1' )

	oModel:SetDescription( 'LOG DE INTEGRAÇÃO CDCF' )
	oModel:addFields( 'ZX1_FIELD_MODEL', , oStruct )

Return oModel

/*/{Protheus.doc} ViewDef
Função de Retorno da View do Modelo de dados da Tabela ZX1..
@author elton.alves
@since 08/02/2017
@version undefined
@return Object, View do Modelo de dados da Tabela ZX1
/*/
Static Function ViewDef()

	Local oView   := FWFormView():New()
	Local oModel  := ModelDef()
	Local oStruct := FWFormStruct( 2, 'ZX1' )

	oView:SetModel( oModel )
	oView:AddField( 'ZX1_FIELD_VIEW', oStruct, 'ZX1_FIELD_MODEL' )
	oView:CreateHorizontalBox( 'BOX_ZX1_FIELD_VIEW', 100)
	oView:SetOwnerView( 'ZX1_FIELD_VIEW', 'BOX_ZX1_FIELD_VIEW' )

Return oView

/*/{Protheus.doc} IOMT2LOG
Registra o Log da Requisição de integração com o CDCF
@author Elton Teodoro Alves
@since 08/02/2017
@version 12.1.014
@param cUUID, characters, UUID Documento Recebido
@param dDataRe, date, Data do Recebimento do Documento
@param cHoraRe, characters, Hora do Recebimento do Documento
@param cMetodo, characters, Metodo CDCF Invocado no WebSercice
@param cStatus, characters, Status Do Processamento, Lista de Opções:
0=Aguardando Importação
1=Erro Comunicação CDCF
2=Erro Processamento XML
3=Falha durante Importação
4=Importado
@param cConfir, characters, Integração Confirmada no CDCF ? 1=Sim 2=Não
@param cXmlRec, characters, XML Recebido pelo WebService do EAI com a Requisição de buscar no CDCF o cadastro de Clientes para Integrar.
@param cParams, characters, Parametros Enviados Pelo EAI, indicando quais os clientes que devem ser incluídos ou que tiveram alguma atualização com o CDCF.
@param dDataPr, date, Data do Processamento do XML retornado pelo método do CDCF
@param cHoraPr, characters, Hora do Processamento do XML retornado pelo método do CDCF
@param cXmlPrc, characters, XML de Processamento retornado pelo método invocado no WebService do CDCF
@param cArrExec, characters, Array em formato JSON com os dados dos clientes e seus respectivos contatos a serem processados pelo Execauto das Rotinas de cadastro
@param cObserv, characters, Observações do Processamento. Registro de erros e alertas durante todo o processo de integração
@return logical, Indica se a gravação do registro ocorreu sem erros.
/*/
User Function IOMT2LOG( cUUID, dDataRe, cHoraRe, cMetodo, cStatus, cConfir, cXmlRec, cParams, dDataPr, cHoraPr, cXmlPrc, cArrExec, cObserv )

	Local lRet   := .T.
	Local oModel := FwLoadModel( 'IOMATA02' )
	Local aArea  := GetArea()

	DbSelectArea( 'ZX1' )
	DbSetOrder( 2 )

	If DbSeek( xFilial( 'ZX1' ) + cUUID )

		oModel:SetOperation( MODEL_OPERATION_UPDATE )

	Else

		oModel:SetOperation( MODEL_OPERATION_INSERT )

	End If

	oModel:Activate()

	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_UUID'  , cUUID   )
	If ( ValType( dDataRe ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_DATARE', dDataRe ), Nil )
	If ( ValType( cHoraRe ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_HORARE', cHoraRe ), Nil )
	If ( ValType( cMetodo ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_METODO', cMetodo ), Nil )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_STATUS', cStatus )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_CONFIR', cConfir )
	If ( ValType( cXmlRec ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_XMLREC', cXmlRec ), Nil )
	If ( ValType( cParams ) != 'U', oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_PARAMS', cParams ), Nil )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_DATAPR', dDataPr )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_HORAPR', cHoraPr )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_XMLPRC', cXmlPrc )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_ARREXE', cArrExec   )
	oModel:SetValue( 'ZX1_FIELD_MODEL', 'ZX1_OBSERV', cObserv )

	If lRet := oModel:VldData()

		oModel:CommitData()

	Else

		VarInfo( 'oModel:GetErrorMessage()', oModel:GetErrorMessage(),, .F., .T. )

	End If

	oModel:DeActivate()

	RestArea( aArea )

Return lRet

/*/{Protheus.doc} IOMT02EX
Funcao informada no aRotina do Browse, que executa uma ação conforme o Codigo recebido por parametro
@author Elton Teodoro Alves
@since 09/02/2017
@version 12.1.014
@param cCod, characters, Código a ação a ser executada:
1 - Exibe o XML da Requisição
2 - Exibe o XML do CDCF
3 - Exibe o Array do ExecAuto
4 - Envia a requisição para Fila Novamente
/*/
User Function IOMT02EX( cCod )

	Local cFile    := GetTempPath( .T. ) + GetNextAlias()
	Local aArrExec := {}

	If cCod == '1'

		cFile += '.xml'

		MemoWrite( cFile, ZX1->ZX1_XMLREC )

	ElseIf cCod == '2' .And. ! Empty( ZX1->ZX1_XMLPRC )

		cFile += '.xml'

		MemoWrite( cFile, ZX1->ZX1_XMLPRC )

	ElseIf cCod == '3' .And. ! Empty( ZX1->ZX1_XMLPRC )

		cFile += '.html'

		FWJsonDeserialize( ZX1->ZX1_ARREXE, @aArrExec )

		MemoWrite( cFile, VarInfo( 'ZX1_ARREXE', aArrExec,, .T., .F. ) )

	ElseIf cCod == '4'

		If ZX1->ZX1_STATUS # '4'

			RecLock( 'ZX1', .F.)

			ZX1->ZX1_STATUS = '0'

			MsUnLock()

			Return

		Else

			ApMsgInfo( 'Esta Requisição não pode voltar para fila, pois já foi importada.', 'Atenção !!!' )

			Return

		End If

	Else

		ApMsgInfo( 'Informação não Disponível', 'Atenção !!!' )

		Return

	End If

	ShellExecute( 'Open', '%PROGRAMFILES%\Internet Explorer\iexplore.exe', cFile, 'C:\', 1 )

Return