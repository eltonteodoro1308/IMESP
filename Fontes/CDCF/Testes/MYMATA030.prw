#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  MATA030 บAutor  ณMicrosiga           บ Data ณ  30/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina automatica do cadastro de clientes.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function myMata030()

	Local aVetor := {}

	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Abertura do ambiente                                         |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	RpcSetEnv("99","01")

	aVetor:={;
	{"A1_COD"       ,"999999"           	,Nil},; // Codigo
	{"A1_LOJA"      ,"00"               	,Nil},; // Loja
	{"A1_NOME"      ,"INC. AUTOMATICO"  	,Nil},; // Nome
	{"A1_NREDUZ"    ,"AUTOMATICO"			,Nil},; // Nome reduz.
	{"A1_TIPO"      ,"R"					,Nil},; // Tipo
	{"A1_END"       ,"RUA AUTOMATICA"		,Nil},; // Endereco
	{"A1_EST"       ,"SP"				    ,Nil},;  // Estado
	{"A1_COD_MUN"   ,'50308'                ,Nil},; // Cod Cidade
	{"A1_MUN"       ,"SAO PAULO"		    ,Nil}} // Cidad

	MSExecAuto({|x,y| Mata030(x,y)},aVetor,3) //3- Inclusใo, 4- Altera็ใo, 5- Exclusใo

	If lMsErroAuto

		aErro := GetAutoGRLog()

		//VarInfo( 'aErro', aErro, , .F.,.T.)

		For nX := 1 To Len( aErro )

			ConOut( aErro[nX] )

		Next nX


	Else

		Alert("Ok")

	End if

	RpcClearEnv()

Return



User Function GravaErro()

	Local nX     := 0
	Local nCount := 0
	Local cLogFile := ""

	//nome do arquivo de log a ser gravado

	Local aLog 	 := {}
	Local aVetor := {}
	Local nHandle
	Local lRet := .F.

	// variแvel de controle interno da rotina automatica que informa se houve erro durante o processamento

	PRIVATE lMsErroAuto := .F.

	// variแvel que define que o help deve ser gravado no arquivo de log e que as informa็๕es estใo vindo เ partir da rotina automแtica.

	Private lMsHelpAuto	:= .T.

	// for็a a grava็ใo das informa็๕es de erro em array para manipula็ใo da grava็ใo ao inv้s de gravar direto no arquivo temporแrio

	Private lAutoErrNoFile := .T.

	Prepare Environment Empresa "01" Filial "01" Modulo "FAT"

	//+------------------------- -------------------------------------+
	//| Teste de Inclusao |
	//+------------------------------------- -------------------------+

	For nCount := 1 To 3

		aVetor:= {{"B1_COD"     ,"99"+Alltrim(Str(nCount)),Nil},;
		{"B1_DESC"    ,"Teste"        ,Nil},;
		{"B1_UM"      ,"UN"           ,Nil},;
		{"B1_LOCPAD"  ,"01"           ,Nil}}

	Next Nx

	lMsErroAuto := .F.
	lRet := .F.

	AutoGrLog("Teste de gera็ใo do arquivo de log "+Alltrim(Str(nCount)))
	AutoGrLog("")

	MSExecAuto( {|x,y| MATA010(x, y) }, aVetor, 3 )

	AutoGrLog(Replicate("-", 20))

	If lMsErroAuto

		cLogFile := "C:\TESTE"+Alltrim(Str(nCount))+".LOG"

		//fun็ใo que retorna as informa็๕es de erro ocorridos durante o processo da rotina automแtica

		aLog := GetAutoGRLog()

		//efetua o tratamento para validar se o arquivo de log jแ existe

		If !File(cLogFile)

			If (nHandle := MSFCreate(cLogFile,0)) <> -1

				lRet := .T.

			EndIf

		Else

			If (nHandle := FOpen(cLogFile,2)) <> -1

				FSeek(nHandle,0,2)

				lRet := .T.

			EndIf

		EndIf

		If	lRet

			//grava as informa็๕es de log no arquivo especificado

			For nX := 1 To Len(aLog)

				FWrite(nHandle,aLog[nX]+CHR(13)+CHR(10))

			Next nX

			FClose(nHandle)

		EndIf	EndIfNextIf !lMsErroAuto

		ConOut("Incluido com sucesso! ")

	Else

		ConOut("Erro na inclusao !")

	EndIf

Return