#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://10.20.5.182/WSIntegraImesp.asmx?WSDL
Gerado em        05/12/17 10:13:07
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _BPQCDJU ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWSIntegraImesp
------------------------------------------------------------------------------- */

WSCLIENT WSWSIntegraImesp

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD RECEIVEMESSAGE

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cINMSG                    AS string
	WSDATA   cRECEIVEMESSAGEResult     AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSIntegraImesp
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20170412 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSIntegraImesp
Return

WSMETHOD RESET WSCLIENT WSWSIntegraImesp
	::cINMSG             := NIL 
	::cRECEIVEMESSAGEResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSIntegraImesp
Local oClone := WSWSIntegraImesp():New()
	oClone:_URL          := ::_URL 
	oClone:cINMSG        := ::cINMSG
	oClone:cRECEIVEMESSAGEResult := ::cRECEIVEMESSAGEResult
Return oClone

// WSDL Method RECEIVEMESSAGE of Service WSWSIntegraImesp

WSMETHOD RECEIVEMESSAGE WSSEND cINMSG WSRECEIVE cRECEIVEMESSAGEResult WSCLIENT WSWSIntegraImesp
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RECEIVEMESSAGE xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("INMSG", ::cINMSG, cINMSG , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RECEIVEMESSAGE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/RECEIVEMESSAGE",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://10.20.5.182/WSIntegraImesp.asmx")

::Init()
::cRECEIVEMESSAGEResult :=  WSAdvValue( oXmlRet,"_RECEIVEMESSAGERESPONSE:_RECEIVEMESSAGERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



