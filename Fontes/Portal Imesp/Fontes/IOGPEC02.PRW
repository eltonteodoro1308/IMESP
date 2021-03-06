#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} SGPEC002
Fun��o acionada pelo EAI que retorna a foto do cadastro do funcion�rio conforme c�digo e campo do cadastro.
@author Elton Teodoro Alves
@since 22/02/2016
@version Protheus 12.1.014
@param cXml    , Caracter, O conte�do da tag Content do XML recebido pelo EAI Protheus.
@param cError  , Caracter, Vari�vel passada por refer�ncia, serve para alimentar a mensagem de erro, nos casos em que a transa��o n�o foi bem sucedida.
@param cWarning, Caracter, Vari�vel passada por refer�ncia, serve para alimentar uma mensagem de warning para o EAI. A altera��o deste valor por rotinas tratadas neste t�pico n�o causam nenhum efeito para o EAI.
@param cParams , Caracter, Par�metros passados na mensagem do EAI. Para o envio destes par�metros � utilizada a seguinte regra:
- Estes par�metros s�o passados ap�s o nome da fun��o, na tag FunctionCode, no path /TOTVSIntegrator/Message/Layouts/
- Ap�s o nome da fun��o a ser executada deve ser colocado um '.' e ap�s cada um dos par�metros mais um. Exemplo: <FunctionCode>U_SGPEC002.3536.65</FunctionCode>.
- OS par�metros s�o enviados na forma de uma string, separados por ','. No exemplo acima, a vari�vel cParams ir� receber a string 3536,65
- Para Fun��o dever� ser passado dois par�metro o primeiro com o c�digo do funcion�rio e o segundo deve ser 65 para foto s� de rosto do campo RA_BITMAP1 e 200 para foto do campo RA_BITIMAP2 .
@param oFwEai  , Object  , O objeto de EAI criado na camada do EAI Protheus. A manipula��o deste objeto deve ser realizada com o m�ximo de cautela, e deve ser evitada ao m�ximo.
@return cRet   , Xml de retorno com a Imagem solicitado em formato Base64 ou erro de processamento
/*/
User Function IOGPEC02( cXml, cError, cWarning, cParams, oFwEai )

	Local cRet      := ''
	Local aParams   := StrTokArr2( cParams, ',', .T. )
	Local aArea     := GetArea()
	Local cBitMap   := ''
	Local cRaBitMap := ''
	Local cIOJPG65  := GetNewPar( 'IO_JPG_65' , '' )
	Local cIOJPG200 := GetNewPar( 'IO_JPG_200', '' )

	If Len( aParams ) < 2

		Return MakeXml( ,'Os Par�metros enviados s�o insufucientes para execu��o da rotina.')

	End If

	If ! AllTrim( aParams[ 2 ] ) $ '65/200'

		Return MakeXml( ,'O Segundo par�metro s� pode ter os seguintes valores permitidos: 65 / 200.' )

	End If

	DbSelectArea( 'SZ0' )
	DbSetOrder( 1 )// Z0_CODIGO

	If ! DbSeek( AllTrim( aParams[ 1 ] ) )

		Return MakeXml( ,'Complemento de Portal do Funcion�rio n�o localizado.' )

	End If

	If AllTrim( aParams[ 2 ] ) = '65'

		cRaBitMap := Posicione( 'SRA', 13, SZ0->Z0_CODIGO, 'RA_BITMAP' )

		RestArea( aArea )

		If ! Empty( cBitMap := SZ0->Z0_BASE641 ) .Or.;
		! Empty( cBitMap := U_IOGPEB64( cRaBitMap ) ) .Or.;
		! Empty( cBitMap := U_IOGPEB64( cIOJPG65 ) )

			Return MakeXml( cBitMap )

		Else

			Return MakeXml( ,'Nenhuma imagem definida nos campos Z0_BITMAP1 / RA_BITAMAP e no par�metro IO_JPG_65.' )

		End If

	End If

	If AllTrim( aParams[ 2 ] ) = '200'

		If ! Empty( cBitMap := SZ0->Z0_BASE642 ) .Or.;
		! Empty( cBitMap := U_IOGPEB64( cIOJPG200 ) )

			Return MakeXml( cBitMap )

		Else

			Return MakeXml( ,'Nenhuma imagem definida no campo Z0_BITMAP2 ou no par�metro IO_JPG_200.' )

		End If

	End If

	RestArea( aArea )

Return

/*/{Protheus.doc} MakeXml
Gera o xml de retorno da requisi��o EAI
@author Elton Teodoro Alves
@since 03/03/2017
@version 12.1.014
@param cImagem, characters, Foto Funcion�rio em Base64
@param cError, characters, Mensagem de Erro
@return character, Xml de Retorno do EAI
/*/
Static Function MakeXml( cImagem, cError )

	Local cRet := ''

	Default cImagem := ''
	Default cError  := ''

	cRet += '<IOGPEC02_RET>'
	cRet += '<IMAGE>'+cImagem+'</IMAGE>'
	cRet += '<ERROR>'+cError+'</ERROR>'
	cRet += '</IOGPEC02_RET>'

Return cRet