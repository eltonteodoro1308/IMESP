#INCLUDE 'TOTVS.CH'
/*/{Protheus.doc} SGPEC002
Função acionada pelo EAI que retorna a foto do cadastro do funcionário conforme código e campo do cadastro.
@author Elton Teodoro Alves
@since 22/02/2016
@version Protheus 12.1.014
@param cXml    , Caracter, O conteúdo da tag Content do XML recebido pelo EAI Protheus.
@param cError  , Caracter, Variável passada por referência, serve para alimentar a mensagem de erro, nos casos em que a transação não foi bem sucedida.
@param cWarning, Caracter, Variável passada por referência, serve para alimentar uma mensagem de warning para o EAI. A alteração deste valor por rotinas tratadas neste tópico não causam nenhum efeito para o EAI.
@param cParams , Caracter, Parâmetros passados na mensagem do EAI. Para o envio destes parâmetros é utilizada a seguinte regra:
- Estes parâmetros são passados após o nome da função, na tag FunctionCode, no path /TOTVSIntegrator/Message/Layouts/
- Após o nome da função a ser executada deve ser colocado um '.' e após cada um dos parâmetros mais um. Exemplo: <FunctionCode>U_SGPEC002.3536.RA_BITMAP1</FunctionCode>.
- OS parâmetros são enviados na forma de uma string, separados por ','. No exemplo acima, a variável cParams irá receber a string 3536,RA_BITMAP1
- Para Função deverá ser passado dois parâmetro o primeiro com o código do funcionário e o segundo o nome de um dos três campos de imagem existentes no cadastrod o funcionário.
@param oFwEai  , Object  , O objeto de EAI criado na camada do EAI Protheus. A manipulação deste objeto deve ser realizada com o máximo de cautela, e deve ser evitada ao máximo.
@return cRet   , Imagem solicitado em formato Base64
/*/
User Function SGPEC002( cXml, cError, cWarning, cParams, oFwEai )

	Local cRet    := ''
	Local aParams := {'004642','RA_BITMAP1'}//StrTokArr2( cParams, ',', .T. )
	Local aArea   := GetArea()
	Local cBitMap := ''

	If Len( aParams ) < 2

		Return 'Os Parâmetros enviados são insufucientes para execução da rotina.'

	End If

	If ! AllTrim( aParams[ 2 ] ) $ 'RA_BITMAP1/RA_BITMAP2'

		Return 'O Segundo parâmetro só pode ter os seguintes valores permitidos: RA_BITMAP1 / RA_BITMAP2.'

	End If

	DbSelectArea( 'SRA' )
	DbSetOrder( 1 ) // RA_FILIAL + RA_MAT

	If ! DbSeek( xFilial( 'SRA' ) + AllTrim( aParams[ 1 ] ) )

		Return 'Matrícula do Funcionário não localizada.'

	Else

		If AllTrim( aParams[ 2 ] ) = 'RA_BITMAP1'

			If Empty( cBitMap := SRA->RA_BITMAP1 ) .And. Empty( cBitMap := SRA->RA_BITMAP ) .And. Empty( cBitMap := GetNewPar( 'MV_IOBMP1', '' ) )

				Return 'Nenhuma imagem definida nos campos RA_BITMAP / RA_BITAMAP1 e no parâmetro MV_IOBMP1.'

			End If

		End If

		If AllTrim( aParams[ 2 ] ) = 'RA_BITMAP2'

			If Empty( cBitMap := SRA->RA_BITMAP2 ) .And. Empty( cBitMap := GetNewPar( 'MV_IOBMP2', '' ) )

				Return 'Nenhuma imagem definida no campo RA_BITMAP2 ou no parâmetro MV_IOBMP2.'

			End If

		End If

	End If

	cBitMap := AllTrim( cBitMap )

	OpenRepositDB()

	DbSelectArea( 'PROTHEUS_REPOSIT' )
	DbSetOrder( 1 )

	If ! DbSeek( cBitMap )

		Return 'Não localizado no repositório de imagens o conteúdo do campo solicitado ou dos parâmetros MV_IOBMP1 e MV_IOBMP2'

	Else

		Do While ! Eof() .And. AllTrim( PROTHEUS_REPOSIT->BMPNAME ) == cBitMap

			cRet += PROTHEUS_REPOSIT->MEMO

			DbSkip()

		End Do

	End If

	PROTHEUS_REPOSIT->( DbCloseArea() )

	RestArea( aArea )

Return EnCode64( cRet )