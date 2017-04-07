#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  MATA030 �Autor  �Microsiga           � Data �  30/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina automatica do cadastro de clientes.                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function myMata030()

	Local aVetor := {}

	Private	lMsErroAuto		:=	.F.
	Private	lMsHelpAuto		:=	.T.
	Private	lAutoErrNoFile	:=	.T.

	//��������������������������������������������������������������Ŀ
	//| Abertura do ambiente                                         |
	//����������������������������������������������������������������

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

	MSExecAuto({|x,y| Mata030(x,y)},aVetor,3) //3- Inclus�o, 4- Altera��o, 5- Exclus�o

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

	// vari�vel de controle interno da rotina automatica que informa se houve erro durante o processamento

	PRIVATE lMsErroAuto := .F.

	// vari�vel que define que o help deve ser gravado no arquivo de log e que as informa��es est�o vindo � partir da rotina autom�tica.

	Private lMsHelpAuto	:= .T.

	// for�a a grava��o das informa��es de erro em array para manipula��o da grava��o ao inv�s de gravar direto no arquivo tempor�rio

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

	AutoGrLog("Teste de gera��o do arquivo de log "+Alltrim(Str(nCount)))
	AutoGrLog("")

	MSExecAuto( {|x,y| MATA010(x, y) }, aVetor, 3 )

	AutoGrLog(Replicate("-", 20))

	If lMsErroAuto

		cLogFile := "C:\TESTE"+Alltrim(Str(nCount))+".LOG"

		//fun��o que retorna as informa��es de erro ocorridos durante o processo da rotina autom�tica

		aLog := GetAutoGRLog()

		//efetua o tratamento para validar se o arquivo de log j� existe

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

			//grava as informa��es de log no arquivo especificado

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