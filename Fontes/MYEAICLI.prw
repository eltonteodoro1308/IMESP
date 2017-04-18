#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://spon4944:7112/ws/MYEAI.apw?WSDL
Gerado em        04/18/17 16:31:24
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _SMZPYBK ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSMYEAI
------------------------------------------------------------------------------- */

WSCLIENT WSMYEAI

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD RECEIVEMESSAGE

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cINMSG                    AS string
	WSDATA   cRECEIVEMESSAGERESULT     AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSMYEAI
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20170323 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSMYEAI
Return

WSMETHOD RESET WSCLIENT WSMYEAI
	::cINMSG             := NIL 
	::cRECEIVEMESSAGERESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSMYEAI
Local oClone := WSMYEAI():New()
	oClone:_URL          := ::_URL 
	oClone:cINMSG        := ::cINMSG
	oClone:cRECEIVEMESSAGERESULT := ::cRECEIVEMESSAGERESULT
Return oClone

// WSDL Method RECEIVEMESSAGE of Service WSMYEAI

WSMETHOD RECEIVEMESSAGE WSSEND cINMSG WSRECEIVE cRECEIVEMESSAGERESULT WSCLIENT WSMYEAI
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RECEIVEMESSAGE xmlns="http://spon4944:7112/">'
cSoap += WSSoapValue("INMSG", ::cINMSG, cINMSG , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RECEIVEMESSAGE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://spon4944:7112/RECEIVEMESSAGE",; 
	"DOCUMENT","http://spon4944:7112/",,"1.031217",; 
	"http://spon4944:7112/ws/MYEAI.apw")

::Init()
::cRECEIVEMESSAGERESULT :=  WSAdvValue( oXmlRet,"_RECEIVEMESSAGERESPONSE:_RECEIVEMESSAGERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



