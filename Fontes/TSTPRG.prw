#INCLUDE 'TOTVS.CH'

User Function TSTPRG()

	//Cria o MsApp
	MsApp():New('SIGAESP')
	oApp:CreateEnv()

	//Seta o tema do Protheus (SUNSET = Vermelho; OCEAN = Azul)
	//PtSetTheme("SUNSET")

	//Define o programa de inicialização
	oApp:bMainInit:= {|| MsgRun("Configurando ambiente...","Aguarde...",;
	{|| RpcSetEnv("99","01"), } ),;
	U_Execute(),;
	Final("TERMINO NORMAL")}

	//Seta Atributos
	__lInternet := .T.
	lMsFinalAuto := .F.
	oApp:lMessageBar:= .T.
	oApp:cModDesc:= 'SIGAESP'

	//Inicia a Janela
	oApp:Activate()

Return Nil