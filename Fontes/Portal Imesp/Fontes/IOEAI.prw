#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://servicos20.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios.svc?singleWsdl
Gerado em        04/24/17 20:19:33
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _HKSOYIS ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSFuncionarios
------------------------------------------------------------------------------- */

WSCLIENT WSFuncionarios

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD RECEIVEMESSAGE
	WSMETHOD FuncionariosPorMatricula
	WSMETHOD FuncionariosPorNome
	WSMETHOD FuncionariosCargosIniciadosPor
	WSMETHOD FuncionariosPorRamal
	WSMETHOD FuncionariosPorDepto
	WSMETHOD FuncionariosAniversariantes
	WSMETHOD FotoPorRegistro
	WSMETHOD AfastamentoPorMatricula
	WSMETHOD testaChamada

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   creceiveMessage           AS string
	WSDATA   cRECEIVEMESSAGEResult     AS string
	WSDATA   csistema                  AS string
	WSDATA   oWSMatriculas             AS Funcionarios_ArrayOfint
	WSDATA   oWSFuncionariosPorMatriculaResult AS Funcionarios_Funcionarios_RET
	WSDATA   cnomeFuncionario          AS string
	WSDATA   oWSFuncionariosPorNomeResult AS Funcionarios_Funcionarios_RET
	WSDATA   cdescricaoCargo           AS string
	WSDATA   oWSFuncionariosCargosIniciadosPorResult AS Funcionarios_Funcionarios_RET
	WSDATA   cramal                    AS string
	WSDATA   oWSFuncionariosPorRamalResult AS Funcionarios_Funcionarios_RET
	WSDATA   cnomeDepto                AS string
	WSDATA   oWSFuncionariosPorDeptoResult AS Funcionarios_Funcionarios_RET
	WSDATA   cmesDiaInicial            AS string
	WSDATA   cmesDiaFinal              AS string
	WSDATA   oWSFuncionariosAniversariantesResult AS Funcionarios_Funcionarios_RET
	WSDATA   nmatricula                AS int
	WSDATA   ntamanho                  AS int
	WSDATA   oWSFotoPorRegistroResult  AS Funcionarios_Foto_RET
	WSDATA   cDataInicial              AS string
	WSDATA   cDataFinal                AS string
	WSDATA   oWSAfastamentoPorMatriculaResult AS Funcionarios_Afastamentos_RET
	WSDATA   ctestaChamadaResult       AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSFuncionarios
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20170323 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSFuncionarios
	::oWSMatriculas      := Funcionarios_ARRAYOFINT():New()
	::oWSFuncionariosPorMatriculaResult := Funcionarios_FUNCIONARIOS_RET():New()
	::oWSFuncionariosPorNomeResult := Funcionarios_FUNCIONARIOS_RET():New()
	::oWSFuncionariosCargosIniciadosPorResult := Funcionarios_FUNCIONARIOS_RET():New()
	::oWSFuncionariosPorRamalResult := Funcionarios_FUNCIONARIOS_RET():New()
	::oWSFuncionariosPorDeptoResult := Funcionarios_FUNCIONARIOS_RET():New()
	::oWSFuncionariosAniversariantesResult := Funcionarios_FUNCIONARIOS_RET():New()
	::oWSFotoPorRegistroResult := Funcionarios_FOTO_RET():New()
	::oWSAfastamentoPorMatriculaResult := Funcionarios_AFASTAMENTOS_RET():New()
Return

WSMETHOD RESET WSCLIENT WSFuncionarios
	::creceiveMessage    := NIL 
	::cRECEIVEMESSAGEResult := NIL 
	::csistema           := NIL 
	::oWSMatriculas      := NIL 
	::oWSFuncionariosPorMatriculaResult := NIL 
	::cnomeFuncionario   := NIL 
	::oWSFuncionariosPorNomeResult := NIL 
	::cdescricaoCargo    := NIL 
	::oWSFuncionariosCargosIniciadosPorResult := NIL 
	::cramal             := NIL 
	::oWSFuncionariosPorRamalResult := NIL 
	::cnomeDepto         := NIL 
	::oWSFuncionariosPorDeptoResult := NIL 
	::cmesDiaInicial     := NIL 
	::cmesDiaFinal       := NIL 
	::oWSFuncionariosAniversariantesResult := NIL 
	::nmatricula         := NIL 
	::ntamanho           := NIL 
	::oWSFotoPorRegistroResult := NIL 
	::cDataInicial       := NIL 
	::cDataFinal         := NIL 
	::oWSAfastamentoPorMatriculaResult := NIL 
	::ctestaChamadaResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSFuncionarios
Local oClone := WSFuncionarios():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:creceiveMessage := ::creceiveMessage
	oClone:cRECEIVEMESSAGEResult := ::cRECEIVEMESSAGEResult
	oClone:csistema      := ::csistema
	oClone:oWSMatriculas :=  IIF(::oWSMatriculas = NIL , NIL ,::oWSMatriculas:Clone() )
	oClone:oWSFuncionariosPorMatriculaResult :=  IIF(::oWSFuncionariosPorMatriculaResult = NIL , NIL ,::oWSFuncionariosPorMatriculaResult:Clone() )
	oClone:cnomeFuncionario := ::cnomeFuncionario
	oClone:oWSFuncionariosPorNomeResult :=  IIF(::oWSFuncionariosPorNomeResult = NIL , NIL ,::oWSFuncionariosPorNomeResult:Clone() )
	oClone:cdescricaoCargo := ::cdescricaoCargo
	oClone:oWSFuncionariosCargosIniciadosPorResult :=  IIF(::oWSFuncionariosCargosIniciadosPorResult = NIL , NIL ,::oWSFuncionariosCargosIniciadosPorResult:Clone() )
	oClone:cramal        := ::cramal
	oClone:oWSFuncionariosPorRamalResult :=  IIF(::oWSFuncionariosPorRamalResult = NIL , NIL ,::oWSFuncionariosPorRamalResult:Clone() )
	oClone:cnomeDepto    := ::cnomeDepto
	oClone:oWSFuncionariosPorDeptoResult :=  IIF(::oWSFuncionariosPorDeptoResult = NIL , NIL ,::oWSFuncionariosPorDeptoResult:Clone() )
	oClone:cmesDiaInicial := ::cmesDiaInicial
	oClone:cmesDiaFinal  := ::cmesDiaFinal
	oClone:oWSFuncionariosAniversariantesResult :=  IIF(::oWSFuncionariosAniversariantesResult = NIL , NIL ,::oWSFuncionariosAniversariantesResult:Clone() )
	oClone:nmatricula    := ::nmatricula
	oClone:ntamanho      := ::ntamanho
	oClone:oWSFotoPorRegistroResult :=  IIF(::oWSFotoPorRegistroResult = NIL , NIL ,::oWSFotoPorRegistroResult:Clone() )
	oClone:cDataInicial  := ::cDataInicial
	oClone:cDataFinal    := ::cDataFinal
	oClone:oWSAfastamentoPorMatriculaResult :=  IIF(::oWSAfastamentoPorMatriculaResult = NIL , NIL ,::oWSAfastamentoPorMatriculaResult:Clone() )
	oClone:ctestaChamadaResult := ::ctestaChamadaResult
Return oClone

// WSDL Method RECEIVEMESSAGE of Service WSFuncionarios

WSMETHOD RECEIVEMESSAGE WSSEND creceiveMessage WSRECEIVE cRECEIVEMESSAGEResult WSCLIENT WSFuncionarios
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RECEIVEMESSAGE xmlns="http://servicos.imprensaoficial.com.br/Integrador/Funcionarios">'
cSoap += WSSoapValue("receiveMessage", ::creceiveMessage, creceiveMessage , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RECEIVEMESSAGE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://servicos.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios/RECEIVEMESSAGE",; 
	"DOCUMENT","http://servicos.imprensaoficial.com.br/Integrador/Funcionarios",,,; 
	"http://servicos20.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios.svc")

::Init()
::cRECEIVEMESSAGEResult :=  WSAdvValue( oXmlRet,"_RECEIVEMESSAGERESPONSE:_RECEIVEMESSAGERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,"xs") 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method FuncionariosPorMatricula of Service WSFuncionarios

WSMETHOD FuncionariosPorMatricula WSSEND csistema,oWSMatriculas WSRECEIVE oWSFuncionariosPorMatriculaResult WSCLIENT WSFuncionarios
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<FuncionariosPorMatricula xmlns="http://servicos.imprensaoficial.com.br/Integrador/Funcionarios">'
cSoap += WSSoapValue("sistema", ::csistema, csistema , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Matriculas", ::oWSMatriculas, oWSMatriculas , "ArrayOfint", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</FuncionariosPorMatricula>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://servicos.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios/FuncionariosPorMatricula",; 
	"DOCUMENT","http://servicos.imprensaoficial.com.br/Integrador/Funcionarios",,,; 
	"http://servicos20.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios.svc")

::Init()
::oWSFuncionariosPorMatriculaResult:SoapRecv( WSAdvValue( oXmlRet,"_FUNCIONARIOSPORMATRICULARESPONSE:_FUNCIONARIOSPORMATRICULARESULT","Funcionarios_RET",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method FuncionariosPorNome of Service WSFuncionarios

WSMETHOD FuncionariosPorNome WSSEND csistema,cnomeFuncionario WSRECEIVE oWSFuncionariosPorNomeResult WSCLIENT WSFuncionarios
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<FuncionariosPorNome xmlns="http://servicos.imprensaoficial.com.br/Integrador/Funcionarios">'
cSoap += WSSoapValue("sistema", ::csistema, csistema , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nomeFuncionario", ::cnomeFuncionario, cnomeFuncionario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</FuncionariosPorNome>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://servicos.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios/FuncionariosPorNome",; 
	"DOCUMENT","http://servicos.imprensaoficial.com.br/Integrador/Funcionarios",,,; 
	"http://servicos20.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios.svc")

::Init()
::oWSFuncionariosPorNomeResult:SoapRecv( WSAdvValue( oXmlRet,"_FUNCIONARIOSPORNOMERESPONSE:_FUNCIONARIOSPORNOMERESULT","Funcionarios_RET",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method FuncionariosCargosIniciadosPor of Service WSFuncionarios

WSMETHOD FuncionariosCargosIniciadosPor WSSEND csistema,cdescricaoCargo WSRECEIVE oWSFuncionariosCargosIniciadosPorResult WSCLIENT WSFuncionarios
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<FuncionariosCargosIniciadosPor xmlns="http://servicos.imprensaoficial.com.br/Integrador/Funcionarios">'
cSoap += WSSoapValue("sistema", ::csistema, csistema , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("descricaoCargo", ::cdescricaoCargo, cdescricaoCargo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</FuncionariosCargosIniciadosPor>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://servicos.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios/FuncionariosCargosIniciadosPor",; 
	"DOCUMENT","http://servicos.imprensaoficial.com.br/Integrador/Funcionarios",,,; 
	"http://servicos20.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios.svc")

::Init()
::oWSFuncionariosCargosIniciadosPorResult:SoapRecv( WSAdvValue( oXmlRet,"_FUNCIONARIOSCARGOSINICIADOSPORRESPONSE:_FUNCIONARIOSCARGOSINICIADOSPORRESULT","Funcionarios_RET",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method FuncionariosPorRamal of Service WSFuncionarios

WSMETHOD FuncionariosPorRamal WSSEND csistema,cramal WSRECEIVE oWSFuncionariosPorRamalResult WSCLIENT WSFuncionarios
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<FuncionariosPorRamal xmlns="http://servicos.imprensaoficial.com.br/Integrador/Funcionarios">'
cSoap += WSSoapValue("sistema", ::csistema, csistema , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ramal", ::cramal, cramal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</FuncionariosPorRamal>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://servicos.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios/FuncionariosPorRamal",; 
	"DOCUMENT","http://servicos.imprensaoficial.com.br/Integrador/Funcionarios",,,; 
	"http://servicos20.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios.svc")

::Init()
::oWSFuncionariosPorRamalResult:SoapRecv( WSAdvValue( oXmlRet,"_FUNCIONARIOSPORRAMALRESPONSE:_FUNCIONARIOSPORRAMALRESULT","Funcionarios_RET",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method FuncionariosPorDepto of Service WSFuncionarios

WSMETHOD FuncionariosPorDepto WSSEND csistema,cnomeDepto WSRECEIVE oWSFuncionariosPorDeptoResult WSCLIENT WSFuncionarios
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<FuncionariosPorDepto xmlns="http://servicos.imprensaoficial.com.br/Integrador/Funcionarios">'
cSoap += WSSoapValue("sistema", ::csistema, csistema , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nomeDepto", ::cnomeDepto, cnomeDepto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</FuncionariosPorDepto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://servicos.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios/FuncionariosPorDepto",; 
	"DOCUMENT","http://servicos.imprensaoficial.com.br/Integrador/Funcionarios",,,; 
	"http://servicos20.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios.svc")

::Init()
::oWSFuncionariosPorDeptoResult:SoapRecv( WSAdvValue( oXmlRet,"_FUNCIONARIOSPORDEPTORESPONSE:_FUNCIONARIOSPORDEPTORESULT","Funcionarios_RET",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method FuncionariosAniversariantes of Service WSFuncionarios

WSMETHOD FuncionariosAniversariantes WSSEND csistema,cmesDiaInicial,cmesDiaFinal WSRECEIVE oWSFuncionariosAniversariantesResult WSCLIENT WSFuncionarios
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<FuncionariosAniversariantes xmlns="http://servicos.imprensaoficial.com.br/Integrador/Funcionarios">'
cSoap += WSSoapValue("sistema", ::csistema, csistema , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mesDiaInicial", ::cmesDiaInicial, cmesDiaInicial , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mesDiaFinal", ::cmesDiaFinal, cmesDiaFinal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</FuncionariosAniversariantes>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://servicos.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios/FuncionariosAniversariantes",; 
	"DOCUMENT","http://servicos.imprensaoficial.com.br/Integrador/Funcionarios",,,; 
	"http://servicos20.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios.svc")

::Init()
::oWSFuncionariosAniversariantesResult:SoapRecv( WSAdvValue( oXmlRet,"_FUNCIONARIOSANIVERSARIANTESRESPONSE:_FUNCIONARIOSANIVERSARIANTESRESULT","Funcionarios_RET",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method FotoPorRegistro of Service WSFuncionarios

WSMETHOD FotoPorRegistro WSSEND csistema,nmatricula,ntamanho WSRECEIVE oWSFotoPorRegistroResult WSCLIENT WSFuncionarios
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<FotoPorRegistro xmlns="http://servicos.imprensaoficial.com.br/Integrador/Funcionarios">'
cSoap += WSSoapValue("sistema", ::csistema, csistema , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("matricula", ::nmatricula, nmatricula , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("tamanho", ::ntamanho, ntamanho , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</FotoPorRegistro>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://servicos.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios/FotoPorRegistro",; 
	"DOCUMENT","http://servicos.imprensaoficial.com.br/Integrador/Funcionarios",,,; 
	"http://servicos20.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios.svc")

::Init()
::oWSFotoPorRegistroResult:SoapRecv( WSAdvValue( oXmlRet,"_FOTOPORREGISTRORESPONSE:_FOTOPORREGISTRORESULT","Foto_RET",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AfastamentoPorMatricula of Service WSFuncionarios

WSMETHOD AfastamentoPorMatricula WSSEND csistema,nmatricula,cDataInicial,cDataFinal WSRECEIVE oWSAfastamentoPorMatriculaResult WSCLIENT WSFuncionarios
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AfastamentoPorMatricula xmlns="http://servicos.imprensaoficial.com.br/Integrador/Funcionarios">'
cSoap += WSSoapValue("sistema", ::csistema, csistema , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("matricula", ::nmatricula, nmatricula , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DataInicial", ::cDataInicial, cDataInicial , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DataFinal", ::cDataFinal, cDataFinal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AfastamentoPorMatricula>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://servicos.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios/AfastamentoPorMatricula",; 
	"DOCUMENT","http://servicos.imprensaoficial.com.br/Integrador/Funcionarios",,,; 
	"http://servicos20.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios.svc")

::Init()
::oWSAfastamentoPorMatriculaResult:SoapRecv( WSAdvValue( oXmlRet,"_AFASTAMENTOPORMATRICULARESPONSE:_AFASTAMENTOPORMATRICULARESULT","Afastamentos_RET",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method testaChamada of Service WSFuncionarios

WSMETHOD testaChamada WSSEND NULLPARAM WSRECEIVE ctestaChamadaResult WSCLIENT WSFuncionarios
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<testaChamada xmlns="http://servicos.imprensaoficial.com.br/Integrador/Funcionarios">'
cSoap += "</testaChamada>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://servicos.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios/testaChamada",; 
	"DOCUMENT","http://servicos.imprensaoficial.com.br/Integrador/Funcionarios",,,; 
	"http://servicos20.imprensaoficial.com.br/Integrador/Funcionarios/Funcionarios.svc")

::Init()
::ctestaChamadaResult :=  WSAdvValue( oXmlRet,"_TESTACHAMADARESPONSE:_TESTACHAMADARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,"xs") 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfint

WSSTRUCT Funcionarios_ArrayOfint
	WSDATA   nint                      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Funcionarios_ArrayOfint
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Funcionarios_ArrayOfint
	::nint                 := {} // Array Of  0
Return

WSMETHOD CLONE WSCLIENT Funcionarios_ArrayOfint
	Local oClone := Funcionarios_ArrayOfint():NEW()
	oClone:nint                 := IIf(::nint <> NIL , aClone(::nint) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT Funcionarios_ArrayOfint
	Local cSoap := ""
	aEval( ::nint , {|x| cSoap := cSoap  +  WSSoapValue("int", x , x , "int", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure Funcionarios_RET

WSSTRUCT Funcionarios_Funcionarios_RET
	WSDATA   oWSFuncionarios           AS Funcionarios_ArrayOfFuncionario OPTIONAL
	WSDATA   cTOTAL_REGISTROS          AS string OPTIONAL
	WSDATA   cERROR                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Funcionarios_Funcionarios_RET
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Funcionarios_Funcionarios_RET
Return

WSMETHOD CLONE WSCLIENT Funcionarios_Funcionarios_RET
	Local oClone := Funcionarios_Funcionarios_RET():NEW()
	oClone:oWSFuncionarios      := IIF(::oWSFuncionarios = NIL , NIL , ::oWSFuncionarios:Clone() )
	oClone:cTOTAL_REGISTROS     := ::cTOTAL_REGISTROS
	oClone:cERROR               := ::cERROR
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Funcionarios_Funcionarios_RET
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_FUNCIONARIOS","ArrayOfFuncionario",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSFuncionarios := Funcionarios_ArrayOfFuncionario():New()
		::oWSFuncionarios:SoapRecv(oNode1)
	EndIf
	::cTOTAL_REGISTROS   :=  WSAdvValue( oResponse,"_TOTAL_REGISTROS","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cERROR             :=  WSAdvValue( oResponse,"_ERROR","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure Foto_RET

WSSTRUCT Funcionarios_Foto_RET
	WSDATA   cerro                     AS string OPTIONAL
	WSDATA   cimagem                   AS base64Binary OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Funcionarios_Foto_RET
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Funcionarios_Foto_RET
Return

WSMETHOD CLONE WSCLIENT Funcionarios_Foto_RET
	Local oClone := Funcionarios_Foto_RET():NEW()
	oClone:cerro                := ::cerro
	oClone:cimagem              := ::cimagem
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Funcionarios_Foto_RET
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cerro              :=  WSAdvValue( oResponse,"_ERRO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cimagem            :=  WSAdvValue( oResponse,"_IMAGEM","base64Binary",NIL,NIL,NIL,"SB",NIL,"xs") 
Return

// WSDL Data Structure Afastamentos_RET

WSSTRUCT Funcionarios_Afastamentos_RET
	WSDATA   nMatricula                AS int OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   oWSAfastamentos           AS Funcionarios_ArrayOfAfastamento OPTIONAL
	WSDATA   cERROR                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Funcionarios_Afastamentos_RET
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Funcionarios_Afastamentos_RET
Return

WSMETHOD CLONE WSCLIENT Funcionarios_Afastamentos_RET
	Local oClone := Funcionarios_Afastamentos_RET():NEW()
	oClone:nMatricula           := ::nMatricula
	oClone:cNome                := ::cNome
	oClone:oWSAfastamentos      := IIF(::oWSAfastamentos = NIL , NIL , ::oWSAfastamentos:Clone() )
	oClone:cERROR               := ::cERROR
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Funcionarios_Afastamentos_RET
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nMatricula         :=  WSAdvValue( oResponse,"_MATRICULA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode3 :=  WSAdvValue( oResponse,"_AFASTAMENTOS","ArrayOfAfastamento",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode3 != NIL
		::oWSAfastamentos := Funcionarios_ArrayOfAfastamento():New()
		::oWSAfastamentos:SoapRecv(oNode3)
	EndIf
	::cERROR             :=  WSAdvValue( oResponse,"_ERROR","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure ArrayOfFuncionario

WSSTRUCT Funcionarios_ArrayOfFuncionario
	WSDATA   oWSFuncionario            AS Funcionarios_Funcionario OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Funcionarios_ArrayOfFuncionario
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Funcionarios_ArrayOfFuncionario
	::oWSFuncionario       := {} // Array Of  Funcionarios_FUNCIONARIO():New()
Return

WSMETHOD CLONE WSCLIENT Funcionarios_ArrayOfFuncionario
	Local oClone := Funcionarios_ArrayOfFuncionario():NEW()
	oClone:oWSFuncionario := NIL
	If ::oWSFuncionario <> NIL 
		oClone:oWSFuncionario := {}
		aEval( ::oWSFuncionario , { |x| aadd( oClone:oWSFuncionario , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Funcionarios_ArrayOfFuncionario
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_FUNCIONARIO","Funcionario",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSFuncionario , Funcionarios_Funcionario():New() )
			::oWSFuncionario[len(::oWSFuncionario)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfAfastamento

WSSTRUCT Funcionarios_ArrayOfAfastamento
	WSDATA   oWSAfastamento            AS Funcionarios_Afastamento OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Funcionarios_ArrayOfAfastamento
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Funcionarios_ArrayOfAfastamento
	::oWSAfastamento       := {} // Array Of  Funcionarios_AFASTAMENTO():New()
Return

WSMETHOD CLONE WSCLIENT Funcionarios_ArrayOfAfastamento
	Local oClone := Funcionarios_ArrayOfAfastamento():NEW()
	oClone:oWSAfastamento := NIL
	If ::oWSAfastamento <> NIL 
		oClone:oWSAfastamento := {}
		aEval( ::oWSAfastamento , { |x| aadd( oClone:oWSAfastamento , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Funcionarios_ArrayOfAfastamento
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_AFASTAMENTO","Afastamento",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSAfastamento , Funcionarios_Afastamento():New() )
			::oWSAfastamento[len(::oWSAfastamento)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure Funcionario

WSSTRUCT Funcionarios_Funcionario
	WSDATA   cMatricula                AS string OPTIONAL
	WSDATA   cCpf                      AS string OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cNomeCompleto             AS string OPTIONAL
	WSDATA   cApelido                  AS string OPTIONAL
	WSDATA   cCodigoCargo              AS string OPTIONAL
	WSDATA   cDescricaoCargo           AS string OPTIONAL
	WSDATA   cCodigoFilial             AS string OPTIONAL
	WSDATA   cLocalTrabalho            AS string OPTIONAL
	WSDATA   cCodigoDepto              AS string OPTIONAL
	WSDATA   cDescricaoDepto           AS string OPTIONAL
	WSDATA   cSiglaDepto               AS string OPTIONAL
	WSDATA   cChaveDepto               AS string OPTIONAL
	WSDATA   cDataDemissao             AS string OPTIONAL
	WSDATA   cQ3_Classe                AS string OPTIONAL
	WSDATA   cDataNascimento           AS string OPTIONAL
	WSDATA   cSituacao                 AS string OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cLogin                    AS string OPTIONAL
	WSDATA   cRamal1                   AS string OPTIONAL
	WSDATA   cRamal2                   AS string OPTIONAL
	WSDATA   cRamal3                   AS string OPTIONAL
	WSDATA   cCentroCusto              AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Funcionarios_Funcionario
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Funcionarios_Funcionario
Return

WSMETHOD CLONE WSCLIENT Funcionarios_Funcionario
	Local oClone := Funcionarios_Funcionario():NEW()
	oClone:cMatricula           := ::cMatricula
	oClone:cCpf                 := ::cCpf
	oClone:cNome                := ::cNome
	oClone:cNomeCompleto        := ::cNomeCompleto
	oClone:cApelido             := ::cApelido
	oClone:cCodigoCargo         := ::cCodigoCargo
	oClone:cDescricaoCargo      := ::cDescricaoCargo
	oClone:cCodigoFilial        := ::cCodigoFilial
	oClone:cLocalTrabalho       := ::cLocalTrabalho
	oClone:cCodigoDepto         := ::cCodigoDepto
	oClone:cDescricaoDepto      := ::cDescricaoDepto
	oClone:cSiglaDepto          := ::cSiglaDepto
	oClone:cChaveDepto          := ::cChaveDepto
	oClone:cDataDemissao        := ::cDataDemissao
	oClone:cQ3_Classe           := ::cQ3_Classe
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:cSituacao            := ::cSituacao
	oClone:cEmail               := ::cEmail
	oClone:cLogin               := ::cLogin
	oClone:cRamal1              := ::cRamal1
	oClone:cRamal2              := ::cRamal2
	oClone:cRamal3              := ::cRamal3
	oClone:cCentroCusto         := ::cCentroCusto
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Funcionarios_Funcionario
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cMatricula         :=  WSAdvValue( oResponse,"_MATRICULA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCpf               :=  WSAdvValue( oResponse,"_CPF","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNomeCompleto      :=  WSAdvValue( oResponse,"_NOMECOMPLETO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cApelido           :=  WSAdvValue( oResponse,"_APELIDO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCodigoCargo       :=  WSAdvValue( oResponse,"_CODIGOCARGO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDescricaoCargo    :=  WSAdvValue( oResponse,"_DESCRICAOCARGO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCodigoFilial      :=  WSAdvValue( oResponse,"_CODIGOFILIAL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cLocalTrabalho     :=  WSAdvValue( oResponse,"_LOCALTRABALHO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCodigoDepto       :=  WSAdvValue( oResponse,"_CODIGODEPTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDescricaoDepto    :=  WSAdvValue( oResponse,"_DESCRICAODEPTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cSiglaDepto        :=  WSAdvValue( oResponse,"_SIGLADEPTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cChaveDepto        :=  WSAdvValue( oResponse,"_CHAVEDEPTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataDemissao      :=  WSAdvValue( oResponse,"_DATADEMISSAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cQ3_Classe         :=  WSAdvValue( oResponse,"_Q3_CLASSE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataNascimento    :=  WSAdvValue( oResponse,"_DATANASCIMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cSituacao          :=  WSAdvValue( oResponse,"_SITUACAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cEmail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cLogin             :=  WSAdvValue( oResponse,"_LOGIN","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cRamal1            :=  WSAdvValue( oResponse,"_RAMAL1","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cRamal2            :=  WSAdvValue( oResponse,"_RAMAL2","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cRamal3            :=  WSAdvValue( oResponse,"_RAMAL3","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCentroCusto       :=  WSAdvValue( oResponse,"_CENTROCUSTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure Afastamento

WSSTRUCT Funcionarios_Afastamento
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   cDataInicial              AS string OPTIONAL
	WSDATA   cDataFinal                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Funcionarios_Afastamento
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Funcionarios_Afastamento
Return

WSMETHOD CLONE WSCLIENT Funcionarios_Afastamento
	Local oClone := Funcionarios_Afastamento():NEW()
	oClone:cDescricao           := ::cDescricao
	oClone:cDataInicial         := ::cDataInicial
	oClone:cDataFinal           := ::cDataFinal
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Funcionarios_Afastamento
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataInicial       :=  WSAdvValue( oResponse,"_DATAINICIAL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataFinal         :=  WSAdvValue( oResponse,"_DATAFINAL","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return


