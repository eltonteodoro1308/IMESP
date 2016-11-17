#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBIConn.ch"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "APWEBSRV.CH"
                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTST       บAutor  ณMicrosiga           บ Data ณ  11/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function POLEnvCli(aCli, aContato)
Local oWsdl
Local xRet       
Local aOps 		:= {}     
Local cError 	:= "" 
Local cWarning	:= "" 

/*
Local _cIdOrg	:= SUPERGETMV("POL_IDORG"	,,"00D5B0000008dNA")						//ID da Organizacao
Local _cIdPort	:= SUPERGETMV("POL_IDPORT"	,, "")										//ID do Portal - Enviar sempre em branco
Local _cUser	:= SUPERGETMV("POL_USER"	,, "integracao@projetopolimold.com.br")		//Usuario
Local _cPass	:= SUPERGETMV("POL_PASS"	,, "poli2016sftt8Q4qIhdkmPfVs57AMdjWQLGGS")	//Senha	
*/

                                             
//---------------------------------------------   
// Cria o objeto da classe TWsdlManager        
//---------------------------------------------
oWsdl := TWsdlManager():New()

//---------------------------------------------
//Habilitar o envio do cabe็alho para o server
//---------------------------------------------
oWsdl:lAlwaysSendSA := .T.

//---------------------------------------------
//Definir o certificado exigido pelo Server
//---------------------------------------------   
 oWsdl:cSSLCACertFile := "\CA.pem"

//--------------------------------------------------------------------------------------   
// Faz o parse da conexao Wsdl - No caso o client nao tinha esta string, somente arquivo
//--------------------------------------------------------------------------------------   
//xRet := oWsdl:ParseURL("http://schemas.xmlsoap.org/wsdl")
//http://schemas.xmlsoap.org/wsdl
                                              
//--------------------------------------------------------------    
// Faz o parse do arquivo de conexao disponibilizado pelo client
//--------------------------------------------------------------   
xRet := oWsdl:ParseFile( "polimold.xml" )    

If xRet == .F.
  conout( "Erro: " + oWsdl:cError )
Else

	//--------------------------------
	// Lista as opera็๕es disponํveis
	//--------------------------------		
	//aOps := oWsdl:ListOperations()

	//---------------------------------------------------------------------
	// Lista os tipos complexos da mensagem de fault envolvida na opera็ใo
 	//---------------------------------------------------------------------
  	aComplex := oWsdl:NextComplex()                                        
  	//varinfo( "", aComplex )                                              
  		
 	//--------------------------------------------------------------------------------------
 	//Retorna os tipos simples utilizados na mensagem do tipo input para a opera็ใo definida 
 	//--------------------------------------------------------------------------------------  		
  	aSimple := oWsdl:SimpleInput()
  	//varinfo( "", aSimple )

	//----------------------------------------------------------   
	// Chama o metodo de Login
	//----------------------------------------------------------   
  	xRet := oWsdl:SetOperation( "login" )
  	If xRet == .F.
    	conout( "Erro: " + oWsdl:cError )
    Else
    	//-------------------------------------------------------------------------------------------------------------------------------
    	// O Comando abaixo envia os dados de login para o server - Pelo SoapUi, executei o metodo login e peguei as tags e colei abaixo 
    	// - Nao usarei este comando, irei utilizar o setvalue que simplifica o codigo
    	//-------------------------------------------------------------------------------------------------------------------------------
		/*    	
		cMsg:="<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:urn='urn:enterprise.soap.sforce.com'> "
		cMsg+="   <soapenv:Header>"
		cMsg+="      <urn:LoginScopeHeader>"
		cMsg+="         <urn:organizationId>00D5B0000008dNA</urn:organizationId>"
		cMsg+="         <!--Optional:-->"
		cMsg+="         <urn:portalId></urn:portalId>"
		cMsg+="      </urn:LoginScopeHeader>"
		cMsg+="   </soapenv:Header>"
		cMsg+="   <soapenv:Body>"
		cMsg+="      <urn:login>"
		cMsg+="         <urn:username>integracao@projetopolimold.com.br</urn:username>"
		cMsg+="         <urn:password>poli2016sftt8Q4qIhdkmPfVs57AMdjWQLGGS</urn:password>"
		cMsg+="      </urn:login>"
		cMsg+="   </soapenv:Body>"
		cMsg+="</soapenv:Envelope>"
		                     		                                   
	  	lRet := oWsdl:SendSoapMsg( cMsg )
	  
	  	If lRet == .F.
	    	conout( "Erro SendSoapMsg: " + oWsdl:cError )
	    	conout( "Erro SendSoapMsg FaultCode: " + oWsdl:cFaultCode )
	    	Return
	  	EndIf
	    --------------------------------------------------------------------------------------------------------------------------------*/
		
		//------------------------------------------------------------------------------
		// Define o valor de cada parโmeto necessแrio
		//------------------------------------------------------------------------------
		xRet := oWsdl:SetValue( 0, _cIdOrg )	//ID da Organizacao
		xRet := oWsdl:SetValue( 1, _cIdPort)	//ID do Portal - Enviar sempre em branco
		xRet := oWsdl:SetValue( 2, _cUser )		//Usuario
		xRet := oWsdl:SetValue( 3, _cPass )		//Senha	
		                                                  
		//------------------------------------------------------------
		//xRet := oWsdl:SetValue( aSimple[1][1], "90210" )
		//------------------------------------------------------------
		If xRet == .F.
			conout( "Erro Sales Force - Envio Login: " + oWsdl:cError )
			Return
		Else
			//------------------------------------------------------------
			// Caso queira visualizar o xml que sera enviado para o server
			//------------------------------------------------------------
			//conout( oWsdl:GetSoapMsg() )
			                                                              
			//------------------------------------------------------------
			// Envia a mensagem SOAP ao servidor
			//------------------------------------------------------------
			xRet := oWsdl:SendSoapMsg()
			
			//------------------------------------------------------------
			// Pega o retorno do envio
			//------------------------------------------------------------
			cRespost 	:= oWsdl:GetSoapResponse() 
			
			//------------------------------------------------------------
			// Realiza o PARSER do XML
			//------------------------------------------------------------		
			cIdConexao	:= RetIdCon(cRespost)  	
		Endif		    
    Endif
Endif
  
Return(xRet)                                                  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetIdCon  บAutor  ณMarcos Andrade      บ Data ณ  11/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para retornar o ID de conexao para permitir executarบฑฑ
ฑฑบ          ณ os metodos do server.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetIdCon(cXml)
Local cRet		:= ""         
Local oXML		:= Nil

oXML := TXMLManager():New()      

If oXml:Parse(cXML)    

	nQtd := oXml:DOMChildCount()
	if oXml:DOMChildNode()
		Do While nQtd < 1000
			If oXml:DOMChildNode()
				If Alltrim(oXml:cName) == "sessionId"
					cRet	:= oXml:cText
       				Exit
       			Endif			
			Else
				If Alltrim(oXml:cName) == "sessionId"
					cRet	:= oXml:cText
       				Exit
       			Endif
			EndIf
			oXml:DOMNextNode()
			nQtd --
		End
	Endif
Endif

Return(cRet)                                         
 
 
